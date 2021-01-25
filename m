Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76EBF302111
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 05:21:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726929AbhAYEVl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 23:21:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726791AbhAYEVk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jan 2021 23:21:40 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59E5AC061573
        for <netdev@vger.kernel.org>; Sun, 24 Jan 2021 20:21:00 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id f63so7652271pfa.13
        for <netdev@vger.kernel.org>; Sun, 24 Jan 2021 20:21:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aQVPUVHoBdlY6V+RdDxvoDz7e3XOV+lhuXRN33kGS5I=;
        b=j8pQPS7i1XTBUyVeKrvMCNPhtMa6c3NjMh90kZYr2KFByTPVTRspfDouPa/7AVLJjN
         /remz122wlScbuBXRqA/JMMS5RHyqEvx7TKzvclOE/sJ2A86DOWem3klj9mbZiWCtApM
         /8F8tnF0bqmTfkbAu71WO4dFFeXaAumdQRc9OnmK5UqbYfeE0AmE0z91SpIaBRwmvkSu
         J5/pswhXcIHNc1y+plxw87idYNwe+qbUEKnXzHj/XIEhqsVoCHqEqs7S3P/zIcYF8bn8
         Jfr/AYTK6Ws8NeYdd+55OD/UZE3D+xXhgDICZYAJfcfYf1W6uB+0IbGZjUTo7gWNCATI
         p13g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aQVPUVHoBdlY6V+RdDxvoDz7e3XOV+lhuXRN33kGS5I=;
        b=uUaYYrmxP4eltefEBtnwcwkOaEIBqnRr3ixa9s+dCtjzA4lFacRr4QNmSftT0e1/q4
         jYR3NtP1CXkRdMMyT7/4h48xJvpR4JrKwt+FzDM/vbwaHXdXyYFAUIcX9YxpLPTkbegX
         fJhmmXsPlLakbyc0sfXaClYTcHjcmS/1NL9ffywyWHhZGQiKdPLm9KQM0+sZ1beHnEzQ
         A604hrn5RagChVlLCgWyTErRUqXefqeyoE9wNevwLqsBCTeDPvqxyMi01xR4e+jm36D/
         E1R7H4gY479mWXSo989ZuStdzgOIvEGTWIgPLwbuiKlJuNz/AwpGECtt8AM2+WW6GSrQ
         SNCA==
X-Gm-Message-State: AOAM530rkRtX/VSik+zIsZQwepv+xHFy+ndc/3nb3j63tSDHJpzyxB/6
        gbEa0yp2rMU9APlZk0EX6cdyE5LkXlmjsw==
X-Google-Smtp-Source: ABdhPJwmJ4CFHbMtosfNzUQ8kDUyF20Z1g72VDc7HQTj6bRYxKCRoIRZkr8Ncu+fAr5EE6sWIrUyAQ==
X-Received: by 2002:a62:9295:0:b029:1b7:b74f:75b1 with SMTP id o143-20020a6292950000b02901b7b74f75b1mr15656452pfd.67.1611548459506;
        Sun, 24 Jan 2021 20:20:59 -0800 (PST)
Received: from container-ubuntu.lan ([171.211.26.203])
        by smtp.gmail.com with ESMTPSA id bk18sm17111119pjb.41.2021.01.24.20.20.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Jan 2021 20:20:58 -0800 (PST)
From:   DENG Qingfang <dqfext@gmail.com>
To:     netdev@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, Andrew Lunn <andrew@lunn.ch>
Cc:     Frank Wunderlich <frank-w@public-files.de>,
        David Woodhouse <dwmw2@infradead.org>,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>
Subject: [PATCH net-next v2] net: ethernet: mediatek: support setting MTU
Date:   Mon, 25 Jan 2021 12:20:46 +0800
Message-Id: <20210125042046.5599-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MT762x HW, except for MT7628, supports frame length up to 2048
(maximum length on GDM), so allow setting MTU up to 2030.

Also set the default frame length to the hardware default 1518.

Signed-off-by: DENG Qingfang <dqfext@gmail.com>
---
Changes v1 -> v2:

- Set netdev->max_mtu accordingly
- Mention default MAX_RX change

 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 43 ++++++++++++++++++---
 drivers/net/ethernet/mediatek/mtk_eth_soc.h | 12 ++++--
 2 files changed, 47 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 6d2d60675ffd..01d3ee4b5829 100644
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
@@ -759,8 +759,8 @@ static void mtk_get_stats64(struct net_device *dev,
 static inline int mtk_max_frag_size(int mtu)
 {
 	/* make sure buf_size will be at least MTK_MAX_RX_LENGTH */
-	if (mtu + MTK_RX_ETH_HLEN < MTK_MAX_RX_LENGTH)
-		mtu = MTK_MAX_RX_LENGTH - MTK_RX_ETH_HLEN;
+	if (mtu + MTK_RX_ETH_HLEN < MTK_MAX_RX_LENGTH_2K)
+		mtu = MTK_MAX_RX_LENGTH_2K - MTK_RX_ETH_HLEN;
 
 	return SKB_DATA_ALIGN(MTK_RX_HLEN + mtu) +
 		SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
@@ -771,7 +771,7 @@ static inline int mtk_max_buf_size(int frag_size)
 	int buf_size = frag_size - NET_SKB_PAD - NET_IP_ALIGN -
 		       SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
 
-	WARN_ON(buf_size < MTK_MAX_RX_LENGTH);
+	WARN_ON(buf_size < MTK_MAX_RX_LENGTH_2K);
 
 	return buf_size;
 }
@@ -2499,6 +2499,35 @@ static void mtk_uninit(struct net_device *dev)
 	mtk_rx_irq_disable(eth, ~0);
 }
 
+static int mtk_change_mtu(struct net_device *dev, int new_mtu)
+{
+	int length = new_mtu + MTK_RX_ETH_HLEN;
+	struct mtk_mac *mac = netdev_priv(dev);
+	struct mtk_eth *eth = mac->hw;
+	u32 mcr_cur, mcr_new;
+
+	if (!MTK_HAS_CAPS(eth->soc->caps, MTK_SOC_MT7628)) {
+		mcr_cur = mtk_r32(mac->hw, MTK_MAC_MCR(mac->id));
+		mcr_new = mcr_cur & ~MAC_MCR_MAX_RX_MASK;
+
+		if (length <= 1518)
+			mcr_new |= MAC_MCR_MAX_RX(MAC_MCR_MAX_RX_1518);
+		else if (length <= 1536)
+			mcr_new |= MAC_MCR_MAX_RX(MAC_MCR_MAX_RX_1536);
+		else if (length <= 1552)
+			mcr_new |= MAC_MCR_MAX_RX(MAC_MCR_MAX_RX_1552);
+		else
+			mcr_new |= MAC_MCR_MAX_RX(MAC_MCR_MAX_RX_2048);
+
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
@@ -2795,6 +2824,7 @@ static const struct net_device_ops mtk_netdev_ops = {
 	.ndo_set_mac_address	= mtk_set_mac_address,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_do_ioctl		= mtk_do_ioctl,
+	.ndo_change_mtu		= mtk_change_mtu,
 	.ndo_tx_timeout		= mtk_tx_timeout,
 	.ndo_get_stats64        = mtk_get_stats64,
 	.ndo_fix_features	= mtk_fix_features,
@@ -2896,7 +2926,10 @@ static int mtk_add_mac(struct mtk_eth *eth, struct device_node *np)
 	eth->netdev[id]->irq = eth->irq[0];
 	eth->netdev[id]->dev.of_node = np;
 
-	eth->netdev[id]->max_mtu = MTK_MAX_RX_LENGTH - MTK_RX_ETH_HLEN;
+	if (MTK_HAS_CAPS(eth->soc->caps, MTK_SOC_MT7628))
+		eth->netdev[id]->max_mtu = MTK_MAX_RX_LENGTH - MTK_RX_ETH_HLEN;
+	else
+		eth->netdev[id]->max_mtu = MTK_MAX_RX_LENGTH_2K - MTK_RX_ETH_HLEN;
 
 	return 0;
 
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 454cfcd465fd..fd3cec8f06ba 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -17,12 +17,13 @@
 #include <linux/phylink.h>
 
 #define MTK_QDMA_PAGE_SIZE	2048
-#define	MTK_MAX_RX_LENGTH	1536
+#define MTK_MAX_RX_LENGTH	1536
+#define MTK_MAX_RX_LENGTH_2K	2048
 #define MTK_TX_DMA_BUF_LEN	0x3fff
 #define MTK_DMA_SIZE		256
 #define MTK_NAPI_WEIGHT		64
 #define MTK_MAC_COUNT		2
-#define MTK_RX_ETH_HLEN		(VLAN_ETH_HLEN + VLAN_HLEN + ETH_FCS_LEN)
+#define MTK_RX_ETH_HLEN		(ETH_HLEN + ETH_FCS_LEN)
 #define MTK_RX_HLEN		(NET_SKB_PAD + MTK_RX_ETH_HLEN + NET_IP_ALIGN)
 #define MTK_DMA_DUMMY_DESC	0xffffffff
 #define MTK_DEFAULT_MSG_ENABLE	(NETIF_MSG_DRV | \
@@ -320,7 +321,12 @@
 
 /* Mac control registers */
 #define MTK_MAC_MCR(x)		(0x10100 + (x * 0x100))
-#define MAC_MCR_MAX_RX_1536	BIT(24)
+#define MAC_MCR_MAX_RX_MASK	GENMASK(25, 24)
+#define MAC_MCR_MAX_RX(_x)	(MAC_MCR_MAX_RX_MASK & ((_x) << 24))
+#define MAC_MCR_MAX_RX_1518	0x0
+#define MAC_MCR_MAX_RX_1536	0x1
+#define MAC_MCR_MAX_RX_1552	0x2
+#define MAC_MCR_MAX_RX_2048	0x3
 #define MAC_MCR_IPG_CFG		(BIT(18) | BIT(16))
 #define MAC_MCR_FORCE_MODE	BIT(15)
 #define MAC_MCR_TX_EN		BIT(14)
-- 
2.25.1

