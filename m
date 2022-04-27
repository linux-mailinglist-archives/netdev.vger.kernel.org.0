Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34B21511F53
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239986AbiD0Po7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 11:44:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240159AbiD0Pop (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 11:44:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDE43329A7
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 08:41:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82049B82875
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 15:41:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09B29C385AF;
        Wed, 27 Apr 2022 15:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651074088;
        bh=AQ2M2cIdMLKFRoOhOa3L4wS6t0ZWgmj+IPNpm9VSkJ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=seE+Cwqa8hiSgbmdjS9MW4M3EBVzWCGeN0jgLmE9eq3pU+6hg6CEVcjBSJwDcSSIX
         koW4eq89pTGtsvENbKFGoSZJXtwXL8ef8R7vfRt4HGLuZrRNS6akXyDqjPZw6GxlFV
         NU8VhqW339ENzH9C9qLQq92CXQUxIquUC70nb9vyjW5FziQZR4WR3TaV4heKwrfCWv
         iOr6/jWKGryNxi3ih90VtCiW8gRTBK9KBuuU7MP6BkFJyXJMiBR5PnZ4wDahoyEYO/
         dBlDKwETCbDu1pgNoAgFAxVPpVkA6X6qSzUUg/vFJFeo/aGvXrykjF5ZDU3vuMs5Qi
         7uvmtDz7Y+C/g==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        kou.ishizaki@toshiba.co.jp, geoff@infradead.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH net-next 13/14] eth: spider: remove a copy of the NAPI_POLL_WEIGHT define
Date:   Wed, 27 Apr 2022 08:41:10 -0700
Message-Id: <20220427154111.529975-14-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220427154111.529975-1-kuba@kernel.org>
References: <20220427154111.529975-1-kuba@kernel.org>
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

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: kou.ishizaki@toshiba.co.jp
CC: geoff@infradead.org
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

