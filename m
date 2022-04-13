Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B3C64FFD08
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 19:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237252AbiDMRp4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 13:45:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229701AbiDMRpy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 13:45:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B9C56C97E
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 10:43:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B489EB825E5
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 17:43:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00A48C385A3;
        Wed, 13 Apr 2022 17:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649871810;
        bh=rujZCBfRO3EudgIhDtHgAqeD5eynCw989C974g1dub4=;
        h=From:To:Cc:Subject:Date:From;
        b=uqvzqWdiOOOSlvPHM9V+q4+roccu+CCjhEe0kI7KSEi4VrpQW6gd2NpKGaIFlnbJX
         bAKyty4CC4ycpqvj6X9Kwg+XzqTjn3eS4mizpZ81NvlZp2C7u7+Awe6VP6kB7JxpNv
         YXxmlg4w5/6Y+PDW1FrPj5ze5NplXSvmcs8ObJAlL1uBsZOCV2YFp8uyscc0KV7tMQ
         arwIGtZaKNgxSICrJRQtcwtomKvAH9WKWiQIJ4a7RyUdsHMAy8eEmqo8zNs3rPQa06
         ke6ZyVYUiKJzMzQLHX/62D2kRwY0QhFPMRoLn0XISl7IjEHR0xXuR1utVTHlkRCR4h
         PAlpdCdwagzwA==
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        pabeni@redhat.com
Cc:     David Ahern <dsahern@kernel.org>
Subject: [PATCH net 0/2] l3mdev: Fix ip tunnel case after recent l3mdev change
Date:   Wed, 13 Apr 2022 11:43:18 -0600
Message-Id: <20220413174320.28989-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Second patch provides a fix for ip tunnels after the recent l3mdev change
that avoids touching the oif in the flow struct. First patch preemptively
provides a fix to an existing function that the second patch uses.

David Ahern (2):
  l3mdev: l3mdev_master_upper_ifindex_by_index_rcu should be using
    netdev_master_upper_dev_get_rcu
  net: Handle l3mdev in ip_tunnel_init_flow

 drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c |  2 +-
 include/net/ip_tunnels.h                            | 11 +++++++++--
 net/ipv4/ip_gre.c                                   |  4 ++--
 net/ipv4/ip_tunnel.c                                |  9 +++++----
 net/l3mdev/l3mdev.c                                 |  2 +-
 5 files changed, 18 insertions(+), 10 deletions(-)

-- 
2.24.3 (Apple Git-128)

