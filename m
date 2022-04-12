Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1015B4FE5EB
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 18:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357659AbiDLQeo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 12:34:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243406AbiDLQel (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 12:34:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89CEA5E152
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 09:32:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 46069B81A00
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 16:32:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCD70C385A5;
        Tue, 12 Apr 2022 16:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649781140;
        bh=dCrkNJ0MdPHL5VXZd9moFjWg+Jdlm+gxCeH2bLhf1RY=;
        h=From:To:Cc:Subject:Date:From;
        b=n0NdsuRWd9zNAgkvaP8tmMljdre2inLnteG7CjJjshMs4Nxz8vbO7oqAdWxhrz7XK
         KwamJSzLs5ENETBgGVhfoEzzvYTAaRcDjh1v2dieJOoHutYs8dMN/reMLxVzYo8p0z
         mxTuMjDutHYTpEsT6xcMYXn0ubYYtJeS8eejHVZZoW1AVf/5pp1qY+TTJMjKmjWWEZ
         4FEI/BR9UN8QbKjmOI4jC1o+Lop/bdNahHUSqUOfockDuMsch6fMXliHvN+BgAOoVK
         JBuBwUlKZ0se4Gy/SCjiw9WPG8J3a8iWzV5RX7G7usoPhiUUAWFbVCp8PilwI9GxZi
         +LsVOCd9wv0Mg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, thomas.petazzoni@bootlin.com,
        ilias.apalodimas@linaro.org, jbrouer@redhat.com, andrew@lunn.ch,
        jdamato@fastly.com
Subject: [PATCH v5 net-next 0/2] net: mvneta: add support for page_pool_get_stats
Date:   Tue, 12 Apr 2022 18:31:57 +0200
Message-Id: <cover.1649780789.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.1
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

Introduce page_pool stats ethtool APIs in order to avoid driver duplicated
code.

Changes since v4:
- rebase on top of net-next

Changes since v3:
- get rid of wrong for loop in page_pool_ethtool_stats_get()
- add API stubs when page_pool_stats are not compiled in

Changes since v2:
- remove enum list of page_pool stats in page_pool.h
- remove leftover change in mvneta.c for ethtool_stats array allocation

Changes since v1:
- move stats accounting to page_pool code
- move stats string management to page_pool code

Lorenzo Bianconi (2):
  net: page_pool: introduce ethtool stats
  net: mvneta: add support for page_pool_get_stats

 drivers/net/ethernet/marvell/Kconfig  |  1 +
 drivers/net/ethernet/marvell/mvneta.c | 20 ++++++++-
 include/net/page_pool.h               | 21 +++++++++
 net/core/page_pool.c                  | 63 ++++++++++++++++++++++++++-
 4 files changed, 103 insertions(+), 2 deletions(-)

-- 
2.35.1

