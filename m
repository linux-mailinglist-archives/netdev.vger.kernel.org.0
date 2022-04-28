Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79D45513D7A
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 23:24:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352171AbiD1V1N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 17:27:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352242AbiD1V1G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 17:27:06 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 667FFBF948
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 14:23:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BBBE6CE2DD1
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 21:23:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA40AC385B1;
        Thu, 28 Apr 2022 21:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651181025;
        bh=b0Skan6E/pSD77Oh8H3NQvHtdLVh9W9t15et8aOO+es=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NY1JmJgfbuR4GBGDWgEF6VnVtJeaF1um2B3VrY3t8RF1GsKakbTKsnVraC4duMB32
         WFllbOq8yigbhI/Y2VJIYBC7jQfBUkAdFEnLBZrXb6R4XwwtmKbm1Tabp4/GXwE2Fw
         HdwOcX1n+zZKQ7lIdfcL8VClasbBAi4x89Xwvl68+C/5hvqM15MGHtieKLMPWetL2m
         U9O8NLBKGRf0rz/lNeJi6VibpfyMbGPLV7hH/xhODRwov5eOQF1N9S2/12Sk/pRmJB
         wLSYiHtC4krMM/r+jZgztQw89MIaGvIYOk8C+46bWb2AWhr5Zm5FXLzJ7VB+gRndGk
         7d/Irq1zCxZhg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, pabeni@redhat.com
Cc:     edumazet@google.com, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Geoff Levand <geoff@infradead.org>, kou.ishizaki@toshiba.co.jp,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH net-next v2 13/15] eth: spider: remove a copy of the NAPI_POLL_WEIGHT define
Date:   Thu, 28 Apr 2022 14:23:21 -0700
Message-Id: <20220428212323.104417-14-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220428212323.104417-1-kuba@kernel.org>
References: <20220428212323.104417-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Defining local versions of NAPI_POLL_WEIGHT with the same
values in the drivers just makes refactoring harder.

Acked-by: Geoff Levand <geoff@infradead.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: kou.ishizaki@toshiba.co.jp
CC: linuxppc-dev@lists.ozlabs.org
---
 drivers/net/ethernet/toshiba/spider_net.c | 2 +-
 drivers/net/ethernet/toshiba/spider_net.h | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/toshiba/spider_net.c b/drivers/net/ethernet/toshiba/spider_net.c
index f47b8358669d..c09cd961edbb 100644
--- a/drivers/net/ethernet/toshiba/spider_net.c
+++ b/drivers/net/ethernet/toshiba/spider_net.c
@@ -2270,7 +2270,7 @@ spider_net_setup_netdev(struct spider_net_card *card)
 	timer_setup(&card->aneg_timer, spider_net_link_phy, 0);
 
 	netif_napi_add(netdev, &card->napi,
-		       spider_net_poll, SPIDER_NET_NAPI_WEIGHT);
+		       spider_net_poll, NAPI_POLL_WEIGHT);
 
 	spider_net_setup_netdev_ops(netdev);
 
diff --git a/drivers/net/ethernet/toshiba/spider_net.h b/drivers/net/ethernet/toshiba/spider_net.h
index 05b1a0736835..51948e2b3a34 100644
--- a/drivers/net/ethernet/toshiba/spider_net.h
+++ b/drivers/net/ethernet/toshiba/spider_net.h
@@ -44,7 +44,6 @@ extern char spider_net_driver_name[];
 #define SPIDER_NET_RX_CSUM_DEFAULT		1
 
 #define SPIDER_NET_WATCHDOG_TIMEOUT		50*HZ
-#define SPIDER_NET_NAPI_WEIGHT			64
 
 #define SPIDER_NET_FIRMWARE_SEQS	6
 #define SPIDER_NET_FIRMWARE_SEQWORDS	1024
-- 
2.34.1

