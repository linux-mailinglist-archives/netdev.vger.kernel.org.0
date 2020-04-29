Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE4121BE804
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 22:02:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbgD2UCT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 16:02:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726456AbgD2UCR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 16:02:17 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70615C03C1AE;
        Wed, 29 Apr 2020 13:02:17 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id n11so1522427pgl.9;
        Wed, 29 Apr 2020 13:02:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Lt2wsDTP1dZbAx86w3ZjTWR6LwcLzUhJBjuXStdHEjY=;
        b=oirCxvG4LhoXUizdVbVdUgL/5JkKqH+lNIaU5bS5rK9zyKlV20Dx4RnQygjhsd2uBj
         MWHccuOLUki4vjwX/sdq+dvXIQZI2JrpWZB0RXpoxkh86PWJL0BnKxDU7Xb5olA6S+Sg
         Bs42yz8EpB7pxwH1/jJTX0aw/I8+ZrQx6ZZfVS4NgnZcbIcdfEeNjjeT1I9ck6nVJHRD
         CXxdTUhZUCmMFFR46O+iCf6FJ5p1usEfT0bVrRIMXx3mEXjJ3LIYrvFBP2VlIh30y6oI
         bW2N8lvkdPBLbgKQ06hDjP9/XXbuXUxZJ8cyr9inpTv6laLw2oMpcDgcVTkkKnPV+tG0
         AwAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Lt2wsDTP1dZbAx86w3ZjTWR6LwcLzUhJBjuXStdHEjY=;
        b=WSpf/47twqOR0UgHkEU+WyNm+i9DCoCnwNQ09nzC4p4qz3ZkV3P7sWGCBKDEHgh6Uq
         MR52Bh/yH0DerTRktnUTJutEc409KZEwdqJQYjAgspyMycY8L9HOb8UrcMawifsVKMYJ
         UOEsgyW8PYaoUsyAo5KqMQbxR9SqXdN4apCIdJQoYEO4kC9UgvppOPPOlY7Zn3OS7uMj
         JODcWvMK3WNaWPhczxShF5tRyxksD/9rU2pN8nVPn/T9nGd+/G5bzGWpxvZBSjAKdgo7
         rKtLWwgNuyueoU3uOsYeCalsCXNcsOjq/Cu1j4vHnszhONL4Kqr9juab2PRozoLB2DA0
         z14A==
X-Gm-Message-State: AGi0PuabWCRvUM7FVKVpI2m+eBvy6XyfDn0GOwFWi9GrS17fnIWeuTK5
        /VW+UnEr0225qwNZK3MtuI4=
X-Google-Smtp-Source: APiQypJ5vwo8lRBHBtV2r+bMeb0emMNKMyR6/mF9LmYX2IHiq+4LjN5GMp6Vqa4V+pPx8we89GjhhA==
X-Received: by 2002:a63:fa0e:: with SMTP id y14mr33417154pgh.13.1588190536858;
        Wed, 29 Apr 2020 13:02:16 -0700 (PDT)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r128sm1705817pfc.141.2020.04.29.13.02.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 Apr 2020 13:02:16 -0700 (PDT)
From:   Doug Berger <opendmb@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Doug Berger <opendmb@gmail.com>
Subject: [PATCH net-next v2 5/7] net: bcmgenet: code movement
Date:   Wed, 29 Apr 2020 13:02:04 -0700
Message-Id: <1588190526-2082-6-git-send-email-opendmb@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1588190526-2082-1-git-send-email-opendmb@gmail.com>
References: <1588190526-2082-1-git-send-email-opendmb@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Hardware Filter Block code will be used by ethtool functions
when defining flow types so this commit moves the functions in the
file to prevent the need for prototype declarations.

This is broken out to facilitate review.

Signed-off-by: Doug Berger <opendmb@gmail.com>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 308 ++++++++++++-------------
 1 file changed, 154 insertions(+), 154 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index b37ef05c5083..ad41944d2cc0 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -459,6 +459,160 @@ static inline void bcmgenet_rdma_ring_writel(struct bcmgenet_priv *priv,
 			genet_dma_ring_regs[r]);
 }
 
+static bool bcmgenet_hfb_is_filter_enabled(struct bcmgenet_priv *priv,
+					   u32 f_index)
+{
+	u32 offset;
+	u32 reg;
+
+	offset = HFB_FLT_ENABLE_V3PLUS + (f_index < 32) * sizeof(u32);
+	reg = bcmgenet_hfb_reg_readl(priv, offset);
+	return !!(reg & (1 << (f_index % 32)));
+}
+
+static void bcmgenet_hfb_enable_filter(struct bcmgenet_priv *priv, u32 f_index)
+{
+	u32 offset;
+	u32 reg;
+
+	offset = HFB_FLT_ENABLE_V3PLUS + (f_index < 32) * sizeof(u32);
+	reg = bcmgenet_hfb_reg_readl(priv, offset);
+	reg |= (1 << (f_index % 32));
+	bcmgenet_hfb_reg_writel(priv, reg, offset);
+}
+
+static void bcmgenet_hfb_set_filter_rx_queue_mapping(struct bcmgenet_priv *priv,
+						     u32 f_index, u32 rx_queue)
+{
+	u32 offset;
+	u32 reg;
+
+	offset = f_index / 8;
+	reg = bcmgenet_rdma_readl(priv, DMA_INDEX2RING_0 + offset);
+	reg &= ~(0xF << (4 * (f_index % 8)));
+	reg |= ((rx_queue & 0xF) << (4 * (f_index % 8)));
+	bcmgenet_rdma_writel(priv, reg, DMA_INDEX2RING_0 + offset);
+}
+
+static void bcmgenet_hfb_set_filter_length(struct bcmgenet_priv *priv,
+					   u32 f_index, u32 f_length)
+{
+	u32 offset;
+	u32 reg;
+
+	offset = HFB_FLT_LEN_V3PLUS +
+		 ((priv->hw_params->hfb_filter_cnt - 1 - f_index) / 4) *
+		 sizeof(u32);
+	reg = bcmgenet_hfb_reg_readl(priv, offset);
+	reg &= ~(0xFF << (8 * (f_index % 4)));
+	reg |= ((f_length & 0xFF) << (8 * (f_index % 4)));
+	bcmgenet_hfb_reg_writel(priv, reg, offset);
+}
+
+static int bcmgenet_hfb_find_unused_filter(struct bcmgenet_priv *priv)
+{
+	u32 f_index;
+
+	for (f_index = 0; f_index < priv->hw_params->hfb_filter_cnt; f_index++)
+		if (!bcmgenet_hfb_is_filter_enabled(priv, f_index))
+			return f_index;
+
+	return -ENOMEM;
+}
+
+/* bcmgenet_hfb_add_filter
+ *
+ * Add new filter to Hardware Filter Block to match and direct Rx traffic to
+ * desired Rx queue.
+ *
+ * f_data is an array of unsigned 32-bit integers where each 32-bit integer
+ * provides filter data for 2 bytes (4 nibbles) of Rx frame:
+ *
+ * bits 31:20 - unused
+ * bit  19    - nibble 0 match enable
+ * bit  18    - nibble 1 match enable
+ * bit  17    - nibble 2 match enable
+ * bit  16    - nibble 3 match enable
+ * bits 15:12 - nibble 0 data
+ * bits 11:8  - nibble 1 data
+ * bits 7:4   - nibble 2 data
+ * bits 3:0   - nibble 3 data
+ *
+ * Example:
+ * In order to match:
+ * - Ethernet frame type = 0x0800 (IP)
+ * - IP version field = 4
+ * - IP protocol field = 0x11 (UDP)
+ *
+ * The following filter is needed:
+ * u32 hfb_filter_ipv4_udp[] = {
+ *   Rx frame offset 0x00: 0x00000000, 0x00000000, 0x00000000, 0x00000000,
+ *   Rx frame offset 0x08: 0x00000000, 0x00000000, 0x000F0800, 0x00084000,
+ *   Rx frame offset 0x10: 0x00000000, 0x00000000, 0x00000000, 0x00030011,
+ * };
+ *
+ * To add the filter to HFB and direct the traffic to Rx queue 0, call:
+ * bcmgenet_hfb_add_filter(priv, hfb_filter_ipv4_udp,
+ *                         ARRAY_SIZE(hfb_filter_ipv4_udp), 0);
+ */
+int bcmgenet_hfb_add_filter(struct bcmgenet_priv *priv, u32 *f_data,
+			    u32 f_length, u32 rx_queue)
+{
+	int f_index;
+	u32 i;
+
+	f_index = bcmgenet_hfb_find_unused_filter(priv);
+	if (f_index < 0)
+		return -ENOMEM;
+
+	if (f_length > priv->hw_params->hfb_filter_size)
+		return -EINVAL;
+
+	for (i = 0; i < f_length; i++)
+		bcmgenet_hfb_writel(priv, f_data[i],
+			(f_index * priv->hw_params->hfb_filter_size + i) *
+			sizeof(u32));
+
+	bcmgenet_hfb_set_filter_length(priv, f_index, 2 * f_length);
+	bcmgenet_hfb_set_filter_rx_queue_mapping(priv, f_index, rx_queue);
+	bcmgenet_hfb_enable_filter(priv, f_index);
+	bcmgenet_hfb_reg_writel(priv, 0x1, HFB_CTRL);
+
+	return 0;
+}
+
+/* bcmgenet_hfb_clear
+ *
+ * Clear Hardware Filter Block and disable all filtering.
+ */
+static void bcmgenet_hfb_clear(struct bcmgenet_priv *priv)
+{
+	u32 i;
+
+	bcmgenet_hfb_reg_writel(priv, 0x0, HFB_CTRL);
+	bcmgenet_hfb_reg_writel(priv, 0x0, HFB_FLT_ENABLE_V3PLUS);
+	bcmgenet_hfb_reg_writel(priv, 0x0, HFB_FLT_ENABLE_V3PLUS + 4);
+
+	for (i = DMA_INDEX2RING_0; i <= DMA_INDEX2RING_7; i++)
+		bcmgenet_rdma_writel(priv, 0x0, i);
+
+	for (i = 0; i < (priv->hw_params->hfb_filter_cnt / 4); i++)
+		bcmgenet_hfb_reg_writel(priv, 0x0,
+					HFB_FLT_LEN_V3PLUS + i * sizeof(u32));
+
+	for (i = 0; i < priv->hw_params->hfb_filter_cnt *
+			priv->hw_params->hfb_filter_size; i++)
+		bcmgenet_hfb_writel(priv, 0x0, i * sizeof(u32));
+}
+
+static void bcmgenet_hfb_init(struct bcmgenet_priv *priv)
+{
+	if (GENET_IS_V1(priv) || GENET_IS_V2(priv))
+		return;
+
+	bcmgenet_hfb_clear(priv);
+}
+
 static int bcmgenet_begin(struct net_device *dev)
 {
 	struct bcmgenet_priv *priv = netdev_priv(dev);
@@ -2759,160 +2913,6 @@ static void bcmgenet_enable_dma(struct bcmgenet_priv *priv, u32 dma_ctrl)
 	bcmgenet_tdma_writel(priv, reg, DMA_CTRL);
 }
 
-static bool bcmgenet_hfb_is_filter_enabled(struct bcmgenet_priv *priv,
-					   u32 f_index)
-{
-	u32 offset;
-	u32 reg;
-
-	offset = HFB_FLT_ENABLE_V3PLUS + (f_index < 32) * sizeof(u32);
-	reg = bcmgenet_hfb_reg_readl(priv, offset);
-	return !!(reg & (1 << (f_index % 32)));
-}
-
-static void bcmgenet_hfb_enable_filter(struct bcmgenet_priv *priv, u32 f_index)
-{
-	u32 offset;
-	u32 reg;
-
-	offset = HFB_FLT_ENABLE_V3PLUS + (f_index < 32) * sizeof(u32);
-	reg = bcmgenet_hfb_reg_readl(priv, offset);
-	reg |= (1 << (f_index % 32));
-	bcmgenet_hfb_reg_writel(priv, reg, offset);
-}
-
-static void bcmgenet_hfb_set_filter_rx_queue_mapping(struct bcmgenet_priv *priv,
-						     u32 f_index, u32 rx_queue)
-{
-	u32 offset;
-	u32 reg;
-
-	offset = f_index / 8;
-	reg = bcmgenet_rdma_readl(priv, DMA_INDEX2RING_0 + offset);
-	reg &= ~(0xF << (4 * (f_index % 8)));
-	reg |= ((rx_queue & 0xF) << (4 * (f_index % 8)));
-	bcmgenet_rdma_writel(priv, reg, DMA_INDEX2RING_0 + offset);
-}
-
-static void bcmgenet_hfb_set_filter_length(struct bcmgenet_priv *priv,
-					   u32 f_index, u32 f_length)
-{
-	u32 offset;
-	u32 reg;
-
-	offset = HFB_FLT_LEN_V3PLUS +
-		 ((priv->hw_params->hfb_filter_cnt - 1 - f_index) / 4) *
-		 sizeof(u32);
-	reg = bcmgenet_hfb_reg_readl(priv, offset);
-	reg &= ~(0xFF << (8 * (f_index % 4)));
-	reg |= ((f_length & 0xFF) << (8 * (f_index % 4)));
-	bcmgenet_hfb_reg_writel(priv, reg, offset);
-}
-
-static int bcmgenet_hfb_find_unused_filter(struct bcmgenet_priv *priv)
-{
-	u32 f_index;
-
-	for (f_index = 0; f_index < priv->hw_params->hfb_filter_cnt; f_index++)
-		if (!bcmgenet_hfb_is_filter_enabled(priv, f_index))
-			return f_index;
-
-	return -ENOMEM;
-}
-
-/* bcmgenet_hfb_add_filter
- *
- * Add new filter to Hardware Filter Block to match and direct Rx traffic to
- * desired Rx queue.
- *
- * f_data is an array of unsigned 32-bit integers where each 32-bit integer
- * provides filter data for 2 bytes (4 nibbles) of Rx frame:
- *
- * bits 31:20 - unused
- * bit  19    - nibble 0 match enable
- * bit  18    - nibble 1 match enable
- * bit  17    - nibble 2 match enable
- * bit  16    - nibble 3 match enable
- * bits 15:12 - nibble 0 data
- * bits 11:8  - nibble 1 data
- * bits 7:4   - nibble 2 data
- * bits 3:0   - nibble 3 data
- *
- * Example:
- * In order to match:
- * - Ethernet frame type = 0x0800 (IP)
- * - IP version field = 4
- * - IP protocol field = 0x11 (UDP)
- *
- * The following filter is needed:
- * u32 hfb_filter_ipv4_udp[] = {
- *   Rx frame offset 0x00: 0x00000000, 0x00000000, 0x00000000, 0x00000000,
- *   Rx frame offset 0x08: 0x00000000, 0x00000000, 0x000F0800, 0x00084000,
- *   Rx frame offset 0x10: 0x00000000, 0x00000000, 0x00000000, 0x00030011,
- * };
- *
- * To add the filter to HFB and direct the traffic to Rx queue 0, call:
- * bcmgenet_hfb_add_filter(priv, hfb_filter_ipv4_udp,
- *                         ARRAY_SIZE(hfb_filter_ipv4_udp), 0);
- */
-int bcmgenet_hfb_add_filter(struct bcmgenet_priv *priv, u32 *f_data,
-			    u32 f_length, u32 rx_queue)
-{
-	int f_index;
-	u32 i;
-
-	f_index = bcmgenet_hfb_find_unused_filter(priv);
-	if (f_index < 0)
-		return -ENOMEM;
-
-	if (f_length > priv->hw_params->hfb_filter_size)
-		return -EINVAL;
-
-	for (i = 0; i < f_length; i++)
-		bcmgenet_hfb_writel(priv, f_data[i],
-			(f_index * priv->hw_params->hfb_filter_size + i) *
-			sizeof(u32));
-
-	bcmgenet_hfb_set_filter_length(priv, f_index, 2 * f_length);
-	bcmgenet_hfb_set_filter_rx_queue_mapping(priv, f_index, rx_queue);
-	bcmgenet_hfb_enable_filter(priv, f_index);
-	bcmgenet_hfb_reg_writel(priv, 0x1, HFB_CTRL);
-
-	return 0;
-}
-
-/* bcmgenet_hfb_clear
- *
- * Clear Hardware Filter Block and disable all filtering.
- */
-static void bcmgenet_hfb_clear(struct bcmgenet_priv *priv)
-{
-	u32 i;
-
-	bcmgenet_hfb_reg_writel(priv, 0x0, HFB_CTRL);
-	bcmgenet_hfb_reg_writel(priv, 0x0, HFB_FLT_ENABLE_V3PLUS);
-	bcmgenet_hfb_reg_writel(priv, 0x0, HFB_FLT_ENABLE_V3PLUS + 4);
-
-	for (i = DMA_INDEX2RING_0; i <= DMA_INDEX2RING_7; i++)
-		bcmgenet_rdma_writel(priv, 0x0, i);
-
-	for (i = 0; i < (priv->hw_params->hfb_filter_cnt / 4); i++)
-		bcmgenet_hfb_reg_writel(priv, 0x0,
-					HFB_FLT_LEN_V3PLUS + i * sizeof(u32));
-
-	for (i = 0; i < priv->hw_params->hfb_filter_cnt *
-			priv->hw_params->hfb_filter_size; i++)
-		bcmgenet_hfb_writel(priv, 0x0, i * sizeof(u32));
-}
-
-static void bcmgenet_hfb_init(struct bcmgenet_priv *priv)
-{
-	if (GENET_IS_V1(priv) || GENET_IS_V2(priv))
-		return;
-
-	bcmgenet_hfb_clear(priv);
-}
-
 static void bcmgenet_netif_start(struct net_device *dev)
 {
 	struct bcmgenet_priv *priv = netdev_priv(dev);
-- 
2.7.4

