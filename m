Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A43B52569F
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 22:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243663AbiELU4L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 16:56:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235697AbiELU4K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 16:56:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13A9030549
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 13:56:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A193D61E71
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 20:56:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A37CFC34100;
        Thu, 12 May 2022 20:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652388968;
        bh=MrQ1bFr+j+ORcgL1WrZNax5u2M8luXO5o/XVWZbBrqI=;
        h=From:To:Cc:Subject:Date:From;
        b=dxkvzp6c8l5jQBRuZoAN9L4PgvQrh3T1Y2jJwxjJIRQqqKRKlNkLyASPKc/FlgbEO
         6sekNhkJ17wTVQy22UfbUiS2/m+CtSSzDLMTgVE/uYMCf7UWlht3PMRval/zbCXvkG
         CaiifGVfEAA+wSB2cee1SBN4GAYX8Q9zJqB3PTEYHhWq/hD76tqdNViRRZwcdWlfgu
         luNpK2kYOIng65gjsfPqTr1re5jffti4jFl2q8nMAgGxdl1pMoBkhd7e7jeCihiutm
         9NXOoygKyil7YY/9TEjvlEoXSy9FiGqm0zBuiXgY3mnBCtUGwk+KaB227aKxiKu77z
         MM/uUjUOmmTDg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>, ecree.xilinx@gmail.com,
        habetsm.xilinx@gmail.com, hkallweit1@gmail.com, ihuguet@redhat.com
Subject: [PATCH net-next] eth: sfc: remove remnants of the out-of-tree napi_weight module param
Date:   Thu, 12 May 2022 13:56:03 -0700
Message-Id: <20220512205603.1536771-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove napi_weight statics which are set to 64 and never modified,
remnants of the out-of-tree napi_weight module param.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: ecree.xilinx@gmail.com
CC: habetsm.xilinx@gmail.com
CC: hkallweit1@gmail.com
CC: ihuguet@redhat.com
---
 drivers/net/ethernet/sfc/efx_channels.c       | 8 +-------
 drivers/net/ethernet/sfc/falcon/efx.c         | 8 +-------
 drivers/net/ethernet/sfc/siena/efx_channels.c | 8 +-------
 3 files changed, 3 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
index 3f28f9861dfa..8c00e05e7650 100644
--- a/drivers/net/ethernet/sfc/efx_channels.c
+++ b/drivers/net/ethernet/sfc/efx_channels.c
@@ -46,11 +46,6 @@ module_param(irq_adapt_high_thresh, uint, 0644);
 MODULE_PARM_DESC(irq_adapt_high_thresh,
 		 "Threshold score for increasing IRQ moderation");
 
-/* This is the weight assigned to each of the (per-channel) virtual
- * NAPI devices.
- */
-static int napi_weight = 64;
-
 static const struct efx_channel_type efx_default_channel_type;
 
 /*************
@@ -1316,8 +1311,7 @@ void efx_init_napi_channel(struct efx_channel *channel)
 	struct efx_nic *efx = channel->efx;
 
 	channel->napi_dev = efx->net_dev;
-	netif_napi_add_weight(channel->napi_dev, &channel->napi_str, efx_poll,
-			      napi_weight);
+	netif_napi_add(channel->napi_dev, &channel->napi_str, efx_poll, 64);
 }
 
 void efx_init_napi(struct efx_nic *efx)
diff --git a/drivers/net/ethernet/sfc/falcon/efx.c b/drivers/net/ethernet/sfc/falcon/efx.c
index f619ffb26787..a63f40b09856 100644
--- a/drivers/net/ethernet/sfc/falcon/efx.c
+++ b/drivers/net/ethernet/sfc/falcon/efx.c
@@ -112,11 +112,6 @@ module_param(ef4_separate_tx_channels, bool, 0444);
 MODULE_PARM_DESC(ef4_separate_tx_channels,
 		 "Use separate channels for TX and RX");
 
-/* This is the weight assigned to each of the (per-channel) virtual
- * NAPI devices.
- */
-static int napi_weight = 64;
-
 /* This is the time (in jiffies) between invocations of the hardware
  * monitor.
  * On Falcon-based NICs, this will:
@@ -2017,8 +2012,7 @@ static void ef4_init_napi_channel(struct ef4_channel *channel)
 	struct ef4_nic *efx = channel->efx;
 
 	channel->napi_dev = efx->net_dev;
-	netif_napi_add_weight(channel->napi_dev, &channel->napi_str, ef4_poll,
-			      napi_weight);
+	netif_napi_add(channel->napi_dev, &channel->napi_str, ef4_poll, 64);
 }
 
 static void ef4_init_napi(struct ef4_nic *efx)
diff --git a/drivers/net/ethernet/sfc/siena/efx_channels.c b/drivers/net/ethernet/sfc/siena/efx_channels.c
index 276cd7d88732..3e1468c81ba2 100644
--- a/drivers/net/ethernet/sfc/siena/efx_channels.c
+++ b/drivers/net/ethernet/sfc/siena/efx_channels.c
@@ -46,11 +46,6 @@ module_param(irq_adapt_high_thresh, uint, 0644);
 MODULE_PARM_DESC(irq_adapt_high_thresh,
 		 "Threshold score for increasing IRQ moderation");
 
-/* This is the weight assigned to each of the (per-channel) virtual
- * NAPI devices.
- */
-static int napi_weight = 64;
-
 static const struct efx_channel_type efx_default_channel_type;
 
 /*************
@@ -1324,8 +1319,7 @@ static void efx_init_napi_channel(struct efx_channel *channel)
 	struct efx_nic *efx = channel->efx;
 
 	channel->napi_dev = efx->net_dev;
-	netif_napi_add_weight(channel->napi_dev, &channel->napi_str, efx_poll,
-			      napi_weight);
+	netif_napi_add(channel->napi_dev, &channel->napi_str, efx_poll, 64);
 }
 
 void efx_siena_init_napi(struct efx_nic *efx)
-- 
2.34.3

