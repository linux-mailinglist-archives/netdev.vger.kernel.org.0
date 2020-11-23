Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05CBA2BFECA
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 04:49:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727383AbgKWDps (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Nov 2020 22:45:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726407AbgKWDps (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Nov 2020 22:45:48 -0500
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 308DEC0613CF
        for <netdev@vger.kernel.org>; Sun, 22 Nov 2020 19:45:46 -0800 (PST)
Received: by mail-lj1-x244.google.com with SMTP id r18so1693657ljc.2
        for <netdev@vger.kernel.org>; Sun, 22 Nov 2020 19:45:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UU8EP5wBKEQP6da8/PNv0YuofmsT1cYlYb+MrY2uJNM=;
        b=puwQs1JgTJ5JRiyxJapv349RmvdEYM882XwnQgxN1WO1XZ/4rIpFptI3nk84L3L1Hf
         5i95Ku69I51Zru18c78/2JpAew8jGPCHz3QlT/eR+0SLwEBh3tjxGlwlsy7GiXXI7rzo
         78cdYl1p0ca4UiXeWwQbXaWYL6cmT38E9KXNOhWmNqYXoePp7Re01tF478Yki+Y9n5SH
         /ttTph36ZcidX5kH2moF64VDHZin68Cklzmq7ckt7FP6L3PTO39iW5XOBEvvQESErIT1
         zqPoEnqjtZzhb4hbvk1E4ZFxy634LaqtNXgrq2iFjb+6aegWMriXDKar/YuMiyCN58eP
         6+cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UU8EP5wBKEQP6da8/PNv0YuofmsT1cYlYb+MrY2uJNM=;
        b=NQlf3ugB9BBty0EauTCJW3QRMwoKKJ2YnAbY28BDI460KBZZJzwNnao125Lr8HTWkW
         5F3r3k8uICSosv4rE0AOMrZhsVL59+5H9l34bGg+BV2tB+7MLs3FHt0TxwO3FMlrTTBX
         eVXtiKjLLsYolnVsnSZ3iH1uGkINGJ6z2FZS3l5yMiBcMDe3FnBzXhsCgz2WwzOtMRt1
         FDIWeTTbRjSNtj/CEeg6tJsqzlH7zr6VTNeDnVfS6TUatp3zz/Di3Pgdzamw0xRqTx4t
         4eCXR90btP9CA6QvBEusEAMRzL2VeU5MAfkP/uZq5TWvJS8wlPy9CRBBS7SvcT2U9kI3
         aoVg==
X-Gm-Message-State: AOAM530IgZTv140lwhlK8T89JVuNhNIxoLVb5tH+1+3kz4D9GTTPDIwk
        w4hSowp5XUgsosdJ5mBStY+O0SxFrmh9iA==
X-Google-Smtp-Source: ABdhPJzETsKeKiB7E7nu5SY0i/2zCu1rLnuLi1ddHAgRWYuzzweN0a3lkVu3pPJN0YV6HGYMWrWaMg==
X-Received: by 2002:a05:651c:203:: with SMTP id y3mr11499902ljn.66.1606103144192;
        Sun, 22 Nov 2020 19:45:44 -0800 (PST)
Received: from container-ubuntu.lan ([240e:398:25da:d530::d2c])
        by smtp.gmail.com with ESMTPSA id f10sm780378ljf.26.2020.11.22.19.45.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2020 19:45:43 -0800 (PST)
From:   DENG Qingfang <dqfext@gmail.com>
To:     netdev@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Cc:     Frank Wunderlich <frank-w@public-files.de>,
        David Woodhouse <dwmw2@infradead.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Rene van Dorst <opensource@vdorst.com>
Subject: [PATCH net-next] net: ethernet: mediatek: support setting MTU
Date:   Mon, 23 Nov 2020 11:45:22 +0800
Message-Id: <20201123034522.1268-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MT762x HW, except for MT7628, supports frame length up to 2048
(maximum length on GDM), so allow setting MTU up to 2030.

Signed-off-by: DENG Qingfang <dqfext@gmail.com>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 36 ++++++++++++++++++++-
 drivers/net/ethernet/mediatek/mtk_eth_soc.h | 11 +++++--
 2 files changed, 43 insertions(+), 4 deletions(-)

Changes RFC -> v1:
	Exclude MT7628

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 6d2d60675ffd..27cae3f43972 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -353,7 +353,7 @@ static void mtk_mac_config(struct phylink_config *config, unsigned int mode,
 	/* Setup gmac */
 	mcr_cur = mtk_r32(mac->hw, MTK_MAC_MCR(mac->id));
 	mcr_new = mcr_cur;
-	mcr_new |= MAC_MCR_MAX_RX_1536 | MAC_MCR_IPG_CFG | MAC_MCR_FORCE_MODE |
+	mcr_new |= MAC_MCR_IPG_CFG | MAC_MCR_FORCE_MODE |
 		   MAC_MCR_BACKOFF_EN | MAC_MCR_BACKPR_EN | MAC_MCR_FORCE_LINK;
 
 	/* Only update control register when needed! */
@@ -2499,6 +2499,39 @@ static void mtk_uninit(struct net_device *dev)
 	mtk_rx_irq_disable(eth, ~0);
 }
 
+static int mtk_change_mtu(struct net_device *dev, int new_mtu)
+{
+	int length = new_mtu + MTK_RX_ETH_HLEN;
+	struct mtk_mac *mac = netdev_priv(dev);
+	struct mtk_eth *eth = mac->hw;
+	u32 mcr_cur, mcr_new;
+
+	if (MTK_HAS_CAPS(eth->soc->caps, MTK_SOC_MT7628)) {
+		if (length > 1536)
+			return -EINVAL;
+	} else {
+		mcr_cur = mtk_r32(mac->hw, MTK_MAC_MCR(mac->id));
+		mcr_new = mcr_cur & ~MAC_MCR_MAX_RX_LEN_MASK;
+
+		if (length <= 1518)
+			mcr_new |= MAC_MCR_MAX_RX_LEN(MAC_MCR_MAX_RX_LEN_1518);
+		else if (length <= 1536)
+			mcr_new |= MAC_MCR_MAX_RX_LEN(MAC_MCR_MAX_RX_LEN_1536);
+		else if (length <= 1552)
+			mcr_new |= MAC_MCR_MAX_RX_LEN(MAC_MCR_MAX_RX_LEN_1552);
+		else
+			mcr_new |= MAC_MCR_MAX_RX_LEN(MAC_MCR_MAX_RX_LEN_2048);
+
+		/* Only update control register when needed! */
+		if (mcr_new != mcr_cur)
+			mtk_w32(mac->hw, mcr_new, MTK_MAC_MCR(mac->id));
+	}
+
+	dev->mtu = new_mtu;
+
+	return 0;
+}
+
 static int mtk_do_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 {
 	struct mtk_mac *mac = netdev_priv(dev);
@@ -2795,6 +2828,7 @@ static const struct net_device_ops mtk_netdev_ops = {
 	.ndo_set_mac_address	= mtk_set_mac_address,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_do_ioctl		= mtk_do_ioctl,
+	.ndo_change_mtu		= mtk_change_mtu,
 	.ndo_tx_timeout		= mtk_tx_timeout,
 	.ndo_get_stats64        = mtk_get_stats64,
 	.ndo_fix_features	= mtk_fix_features,
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 454cfcd465fd..cfc11654ccd6 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -17,12 +17,12 @@
 #include <linux/phylink.h>
 
 #define MTK_QDMA_PAGE_SIZE	2048
-#define	MTK_MAX_RX_LENGTH	1536
+#define MTK_MAX_RX_LENGTH	2048
 #define MTK_TX_DMA_BUF_LEN	0x3fff
 #define MTK_DMA_SIZE		256
 #define MTK_NAPI_WEIGHT		64
 #define MTK_MAC_COUNT		2
-#define MTK_RX_ETH_HLEN		(VLAN_ETH_HLEN + VLAN_HLEN + ETH_FCS_LEN)
+#define MTK_RX_ETH_HLEN		(ETH_HLEN + ETH_FCS_LEN)
 #define MTK_RX_HLEN		(NET_SKB_PAD + MTK_RX_ETH_HLEN + NET_IP_ALIGN)
 #define MTK_DMA_DUMMY_DESC	0xffffffff
 #define MTK_DEFAULT_MSG_ENABLE	(NETIF_MSG_DRV | \
@@ -320,7 +320,12 @@
 
 /* Mac control registers */
 #define MTK_MAC_MCR(x)		(0x10100 + (x * 0x100))
-#define MAC_MCR_MAX_RX_1536	BIT(24)
+#define MAC_MCR_MAX_RX_LEN_MASK	GENMASK(25, 24)
+#define MAC_MCR_MAX_RX_LEN(_x)	(MAC_MCR_MAX_RX_LEN_MASK & ((_x) << 24))
+#define MAC_MCR_MAX_RX_LEN_1518	0x0
+#define MAC_MCR_MAX_RX_LEN_1536	0x1
+#define MAC_MCR_MAX_RX_LEN_1552	0x2
+#define MAC_MCR_MAX_RX_LEN_2048	0x3
 #define MAC_MCR_IPG_CFG		(BIT(18) | BIT(16))
 #define MAC_MCR_FORCE_MODE	BIT(15)
 #define MAC_MCR_TX_EN		BIT(14)
-- 
2.25.1

