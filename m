Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40F1B647CDB
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 05:14:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbiLIEON (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 23:14:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbiLIEOK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 23:14:10 -0500
Received: from out199-18.us.a.mail.aliyun.com (out199-18.us.a.mail.aliyun.com [47.90.199.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4E727124A;
        Thu,  8 Dec 2022 20:14:04 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045176;MF=jiapeng.chong@linux.alibaba.com;NM=0;PH=DS;RN=11;SR=0;TI=SMTPD_---0VWseMqA_1670557049;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0VWseMqA_1670557049)
          by smtp.aliyun-inc.com;
          Fri, 09 Dec 2022 11:38:35 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     opendmb@gmail.com
Cc:     f.fainelli@gmail.com, bcm-kernel-feedback-list@broadcom.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH] net: bcmgenet: Remove the unused function
Date:   Fri,  9 Dec 2022 11:37:23 +0800
Message-Id: <20221209033723.32452-1-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function dmadesc_get_addr() is defined in the bcmgenet.c file, but
not called elsewhere, so remove this unused function.

drivers/net/ethernet/broadcom/genet/bcmgenet.c:120:26: warning: unused function 'dmadesc_get_addr'.

Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=3401
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index a8ce8d0cf9c4..21973046b12b 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -117,24 +117,6 @@ static inline void dmadesc_set(struct bcmgenet_priv *priv,
 	dmadesc_set_length_status(priv, d, val);
 }
 
-static inline dma_addr_t dmadesc_get_addr(struct bcmgenet_priv *priv,
-					  void __iomem *d)
-{
-	dma_addr_t addr;
-
-	addr = bcmgenet_readl(d + DMA_DESC_ADDRESS_LO);
-
-	/* Register writes to GISB bus can take couple hundred nanoseconds
-	 * and are done for each packet, save these expensive writes unless
-	 * the platform is explicitly configured for 64-bits/LPAE.
-	 */
-#ifdef CONFIG_PHYS_ADDR_T_64BIT
-	if (priv->hw_params->flags & GENET_HAS_40BITS)
-		addr |= (u64)bcmgenet_readl(d + DMA_DESC_ADDRESS_HI) << 32;
-#endif
-	return addr;
-}
-
 #define GENET_VER_FMT	"%1d.%1d EPHY: 0x%04x"
 
 #define GENET_MSG_DEFAULT	(NETIF_MSG_DRV | NETIF_MSG_PROBE | \
-- 
2.20.1.7.g153144c

