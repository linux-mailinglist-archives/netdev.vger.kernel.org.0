Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 409416DC378
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 08:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbjDJGTW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 02:19:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjDJGTV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 02:19:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DA7C40D5
        for <netdev@vger.kernel.org>; Sun,  9 Apr 2023 23:19:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BACDA60FE5
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 06:19:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FF70C433D2;
        Mon, 10 Apr 2023 06:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681107558;
        bh=eCchtxQv5U9RG+1RZ8MRxgtUS88RDHlOWqrb/ACN/0o=;
        h=From:To:Cc:Subject:Date:From;
        b=u7SYdE+KRLhJif+dYWVvj7o6Ac6zI9S/fq6oocURUqobxs8wBm8cettbWqTQndvMO
         8OzVHz5w2201GvJqJj7Stv3v5HCWRg9WsOaRY3uK6IVrS6pZAQZr4fHN3SWw49Ch51
         97gkPNegpbqalTD8iULM4/dj0A6TqkEfNFRKsnrHjrR8e7QlwYTS2Cne6BtsKsvMgZ
         teWOlVgJyFcKYEDH2NI3yYeiQh1Jkh+B606EQbG22U/7jTNlxKdMhgDJKNb0WcOLK+
         2VhKg2JcmPIlwAQ8RfLft4czjaD27rL5Y0J+vfdOimD95qk7FA/6JL0an3MVZ1IV9M
         HH1BAbYJANOYw==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Raed Salem <raeds@nvidia.com>, Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH net-next 00/10] Support tunnel mode in mlx5 IPsec packet offload 
Date:   Mon, 10 Apr 2023 09:19:02 +0300
Message-Id: <cover.1681106636.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Hi,

This series extends mlx5 to support tunnel mode in its IPsec packet
offload implementation.

Thanks

---------------------------------------------------------------------
I would like to ask to apply it directly to netdev tree as PR is not
really needed here.
---------------------------------------------------------------------

Leon Romanovsky (10):
  net/mlx5e: Add IPsec packet offload tunnel bits
  net/mlx5e: Check IPsec packet offload tunnel capabilities
  net/mlx5e: Configure IPsec SA tables to support tunnel mode
  net/mlx5e: Prepare IPsec packet reformat code for tunnel mode
  net/mlx5e: Support IPsec RX packet offload in tunnel mode
  net/mlx5e: Support IPsec TX packet offload in tunnel mode
  net/mlx5e: Listen to ARP events to update IPsec L2 headers in tunnel
    mode
  net/mlx5: Allow blocking encap changes in eswitch
  net/mlx5e: Create IPsec table with tunnel support only when encap is
    disabled
  net/mlx5e: Accept tunnel mode for IPsec packet offload

 .../mellanox/mlx5/core/en_accel/ipsec.c       | 201 ++++++++++++++-
 .../mellanox/mlx5/core/en_accel/ipsec.h       |  11 +-
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    | 243 +++++++++++++++---
 .../mlx5/core/en_accel/ipsec_offload.c        |   6 +
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  14 +
 .../mellanox/mlx5/core/eswitch_offloads.c     |  48 ++++
 include/linux/mlx5/mlx5_ifc.h                 |   8 +-
 7 files changed, 484 insertions(+), 47 deletions(-)

-- 
2.39.2

