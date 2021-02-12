Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9812631A19C
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 16:28:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232222AbhBLPYx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 10:24:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231709AbhBLPWo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 10:22:44 -0500
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ACBAC06178A
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 07:22:04 -0800 (PST)
Received: by mail-lj1-x234.google.com with SMTP id b16so11955429lji.13
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 07:22:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LjT1JP+REdRJgIAZW0dU5uYbYVFL93YUfJdwzvo3Wfs=;
        b=O2YX1Iqw5eEaTInfSrhz90lkja7M0sj5e8J0y2V7EHRVYEEnznO+BWLRU/iXEpSuJK
         sbnAGDsXdU8/ryF9XZy0iAb/AA7U1zpYxieQYpx2bGDUFt7R4whWoFl2TswyHkw/7jfM
         cZKfQMSxpSxTv4+KXWKmLs7gVP4p8VHIvwTtyZFzZh8TV+NlkAKxdVk49dcbqmAaGNyC
         uAxcR7QqJtc9CldVjxpyAqaLNJcobcKmdcv+lqUyDakzg7vmalDpm+GAvDYXuFw38cfS
         A7hSWf2oE7eWu9iCcDV6hFCwP2ppqfV0ba33NT4uP+NU4cLq3cnqrRKR3PB9yVFmBhut
         5crw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LjT1JP+REdRJgIAZW0dU5uYbYVFL93YUfJdwzvo3Wfs=;
        b=GmTN5ldCVtHUv38bDiFLOpCNYcBtH3tXhauVWDWaouwGEnaGOWM2FC9oBS13Df5V3/
         9+Tu2VbxihjbJ7FvN7PjztqUAaMhf+r0qNoWWt/JcAIQ7krrfO/2RIY2N66TZN8qSVB6
         BR+1ilSlugcRMaPY4QnqKVRb16gH1sQvZktbKO/LaOID1r+0lF5LW/z8ZeYlv2oCm90t
         emuBC2rYW3CFJ4NMBafaDabqcT4AeXnw+3GbZWqKS7bGJt6gifG71YJwtNU6BW+tLaeE
         m6z0knx/WHEmFe3rDAENTReTClFPpMZua/XUkpYUQkVvbtv3sdP/UgmPsmvJHR5fwYTs
         nNVw==
X-Gm-Message-State: AOAM532cEvybTjwxC9Aw3hn9ZAaUOF6Dhzf9mjPS4GySXKuBKPrtyp8Z
        sIaPmrOsi/kUiJJ/Uv5PZi8=
X-Google-Smtp-Source: ABdhPJzGaLBSR7uCYNPtrw9GWtqhd3wRX6Bk6W+bWUJdVv+7C/tsE1e40uvSGY/sTwpcVCfrrTayRQ==
X-Received: by 2002:a2e:9cd5:: with SMTP id g21mr1983749ljj.383.1613143322653;
        Fri, 12 Feb 2021 07:22:02 -0800 (PST)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id n2sm1047217lfu.274.2021.02.12.07.22.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Feb 2021 07:22:01 -0800 (PST)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH 5.12] net: broadcom: bcm4908_enet: set MTU on open & on request
Date:   Fri, 12 Feb 2021 16:21:35 +0100
Message-Id: <20210212152135.27030-1-zajec5@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

Hardware comes up with default max frame size set to 1518. When using it
with switch it results in actual Ethernet MTU 1492:
1518 - 14 (Ethernet header) - 4 (Broadcom's tag) - 4 (802.1q) - 4 (FCS)

Above means hardware in its default state can't handle standard Ethernet
traffic (MTU 1500).

Define maximum possible Ethernet overhead and always set MAC max frame
length accordingly. This change fixes handling Ethernet frames of length
1506 - 1514.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
If possible I'd like to get this fix for 5.12.
---
 drivers/net/ethernet/broadcom/bcm4908_enet.c | 31 ++++++++++++++++----
 1 file changed, 25 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bcm4908_enet.c b/drivers/net/ethernet/broadcom/bcm4908_enet.c
index 0da8c8c73ba7..9be33dc98072 100644
--- a/drivers/net/ethernet/broadcom/bcm4908_enet.c
+++ b/drivers/net/ethernet/broadcom/bcm4908_enet.c
@@ -5,6 +5,7 @@
 
 #include <linux/delay.h>
 #include <linux/etherdevice.h>
+#include <linux/if_vlan.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/of.h>
@@ -29,9 +30,10 @@
 						 ENET_DMA_CH_CFG_INT_BUFF_DONE)
 #define ENET_DMA_MAX_BURST_LEN			8 /* in 64 bit words */
 
-#define ENET_MTU_MIN				60
-#define ENET_MTU_MAX				1500 /* Is it possible to support 2044? */
-#define ENET_MTU_MAX_EXTRA_SIZE			32 /* L2 */
+#define ENET_MTU_MAX				ETH_DATA_LEN /* Is it possible to support 2044? */
+#define BRCM_MAX_TAG_LEN			6
+#define ENET_MAX_ETH_OVERHEAD			(ETH_HLEN + BRCM_MAX_TAG_LEN + VLAN_HLEN + \
+						 ETH_FCS_LEN + 4) /* 32 */
 
 struct bcm4908_enet_dma_ring_bd {
 	__le32 ctl;
@@ -135,6 +137,11 @@ static void bcm4908_enet_intrs_ack(struct bcm4908_enet *enet)
 	enet_write(enet, ENET_DMA_CH_RX_CFG + ENET_DMA_CH_CFG_INT_STAT, ENET_DMA_INT_DEFAULTS);
 }
 
+static void bcm4908_enet_set_mtu(struct bcm4908_enet *enet, int mtu)
+{
+	enet_umac_write(enet, UMAC_MAX_FRAME_LEN, mtu + ENET_MAX_ETH_OVERHEAD);
+}
+
 /***
  * DMA
  */
@@ -246,7 +253,7 @@ static int bcm4908_enet_dma_alloc_rx_buf(struct bcm4908_enet *enet, unsigned int
 	u32 tmp;
 	int err;
 
-	slot->len = ENET_MTU_MAX + ENET_MTU_MAX_EXTRA_SIZE;
+	slot->len = ENET_MTU_MAX + ENET_MAX_ETH_OVERHEAD;
 
 	slot->skb = netdev_alloc_skb(enet->netdev, slot->len);
 	if (!slot->skb)
@@ -374,6 +381,8 @@ static void bcm4908_enet_gmac_init(struct bcm4908_enet *enet)
 {
 	u32 cmd;
 
+	bcm4908_enet_set_mtu(enet, enet->netdev->mtu);
+
 	cmd = enet_umac_read(enet, UMAC_CMD);
 	enet_umac_write(enet, UMAC_CMD, cmd | CMD_SW_RESET);
 	enet_umac_write(enet, UMAC_CMD, cmd & ~CMD_SW_RESET);
@@ -559,7 +568,7 @@ static int bcm4908_enet_poll(struct napi_struct *napi, int weight)
 
 		len = (ctl & DMA_CTL_LEN_DESC_BUFLENGTH) >> DMA_CTL_LEN_DESC_BUFLENGTH_SHIFT;
 
-		if (len < ENET_MTU_MIN ||
+		if (len < ETH_ZLEN ||
 		    (ctl & (DMA_CTL_STATUS_SOP | DMA_CTL_STATUS_EOP)) != (DMA_CTL_STATUS_SOP | DMA_CTL_STATUS_EOP)) {
 			enet->netdev->stats.rx_dropped++;
 			break;
@@ -583,11 +592,21 @@ static int bcm4908_enet_poll(struct napi_struct *napi, int weight)
 	return handled;
 }
 
+static int bcm4908_enet_change_mtu(struct net_device *netdev, int new_mtu)
+{
+	struct bcm4908_enet *enet = netdev_priv(netdev);
+
+	bcm4908_enet_set_mtu(enet, new_mtu);
+
+	return 0;
+}
+
 static const struct net_device_ops bcm4908_enet_netdev_ops = {
 	.ndo_open = bcm4908_enet_open,
 	.ndo_stop = bcm4908_enet_stop,
 	.ndo_start_xmit = bcm4908_enet_start_xmit,
 	.ndo_set_mac_address = eth_mac_addr,
+	.ndo_change_mtu = bcm4908_enet_change_mtu,
 };
 
 static int bcm4908_enet_probe(struct platform_device *pdev)
@@ -625,7 +644,7 @@ static int bcm4908_enet_probe(struct platform_device *pdev)
 	eth_hw_addr_random(netdev);
 	netdev->netdev_ops = &bcm4908_enet_netdev_ops;
 	netdev->min_mtu = ETH_ZLEN;
-	netdev->mtu = ENET_MTU_MAX;
+	netdev->mtu = ETH_DATA_LEN;
 	netdev->max_mtu = ENET_MTU_MAX;
 	netif_napi_add(netdev, &enet->napi, bcm4908_enet_poll, 64);
 
-- 
2.26.2

