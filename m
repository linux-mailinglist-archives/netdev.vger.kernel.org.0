Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E11AD29E402
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 08:27:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728468AbgJ2H0k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 03:26:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728252AbgJ2HY7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 03:24:59 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B6C9C05BD3C
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 23:39:25 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id w65so1536083pfd.3
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 23:39:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VT9QO83j2myJhpJ9PKMpE3RJLSMwvgT4KD6kwuSUMuM=;
        b=t2llJPepnEmVh85AzXgPiu945GNPUYcME9ZITdGCHiSzjdUH3ns0+GqeFOqyIsdJKk
         uJMNKNJkyuoHgDtFgnwRBNqD+Np+nV44dkFk0luBuZjbv3mdB79qTvjJTIkQ6VmDKm19
         LhU6q7QYRtwyS7IehUQ9b1xA71DeVmomNDv5pbk3LL4ebln5lKWPqEulC/4VldyCEWi6
         3OUqG0cM9AO3t1cNYzao57cwFwvf0BFtEbe92eQ7NCWTPClx5BoH+Q1ZStjBWy+N+RWq
         Ulc2eVGGpWxaMtjyMHuBWXuT2aE8czrI53dCUXPUUbJiUGjx8uKva6dp5oc3e0Esl8B6
         iCHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VT9QO83j2myJhpJ9PKMpE3RJLSMwvgT4KD6kwuSUMuM=;
        b=QlT6Jf/r2FokBHRkNtWgep1Nr1iQ7QCB3sHKUnDmYrcZbm0R/0txHx25HONTfNpfbN
         7vvLEGZYIUjkLAbnG8SF2brS6QLT7ikl8uWyMRpDIF+EHGPp/rAXryQcEh8LJv8t2Fiy
         UcWppi9gANtlu6VxP3kRiLb1hJrBkJHKgUg69BVpJc6CR6SY4pr4LP18jAxYW23PAt8q
         b9ekYRj3Ej6LJ5y2qQQP2euUsxfphZI3VxwDBljIR65kzD6btI0s8dWNKJS/oo0Kfj+D
         w/hc/wfXBTLtsYYMrl8Oi7orYPn7AtHO2rdzHe3sbwPphLe38z9yo8e1aRUmVtgLOyCW
         5QnQ==
X-Gm-Message-State: AOAM531ZRm6+oErXy2N2U3RBJ6NhlQU1DKgleW49S9rxwfyekLC2HPY4
        0+HN/eUtJxY0Z8KYYHcrNGK/19pL8IOio0qLfUw=
X-Google-Smtp-Source: ABdhPJy4xjDYOxKKTKWDdTXa7LDLXWc6SUX8PALsQp5Zc2SzchOyH8l7gQLCumetD6EyiHqIFSvkOA==
X-Received: by 2002:a17:90a:a4c9:: with SMTP id l9mr2640736pjw.203.1603953564323;
        Wed, 28 Oct 2020 23:39:24 -0700 (PDT)
Received: from container-ubuntu.lan ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id bx24sm1551548pjb.20.2020.10.28.23.39.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 23:39:23 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Landen Chao <landen.chao@mediatek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Frank Wunderlich <frank-w@public-files.de>
Subject: [RFC PATCH net-next] net: ethernet: mediatek: support setting MTU
Date:   Thu, 29 Oct 2020 14:39:15 +0800
Message-Id: <20201029063915.4287-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MT762x HW supports frame length up to 2048 (maximum length on GDM),
so allow setting MTU up to 2030.

Signed-off-by: DENG Qingfang <dqfext@gmail.com>
---

I only tested this on MT7621, no sure if it is applicable for other SoCs
especially MT7628, which has an old IP.

---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 31 ++++++++++++++++++++-
 drivers/net/ethernet/mediatek/mtk_eth_soc.h | 11 ++++++--
 2 files changed, 38 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 6d2d60675ffd..a0c56d9be1d5 100644
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
@@ -2499,6 +2499,34 @@ static void mtk_uninit(struct net_device *dev)
 	mtk_rx_irq_disable(eth, ~0);
 }
 
+static int mtk_change_mtu(struct net_device *dev, int new_mtu)
+{
+	struct mtk_mac *mac = netdev_priv(dev);
+	u32 mcr_cur, mcr_new;
+	int length;
+
+	mcr_cur = mtk_r32(mac->hw, MTK_MAC_MCR(mac->id));
+	mcr_new = mcr_cur & ~MAC_MCR_MAX_RX_LEN_MASK;
+	length = new_mtu + MTK_RX_ETH_HLEN;
+
+	if (length <= 1518)
+		mcr_new |= MAC_MCR_MAX_RX_LEN(MAC_MCR_MAX_RX_LEN_1518);
+	else if (length <= 1536)
+		mcr_new |= MAC_MCR_MAX_RX_LEN(MAC_MCR_MAX_RX_LEN_1536);
+	else if (length <= 1552)
+		mcr_new |= MAC_MCR_MAX_RX_LEN(MAC_MCR_MAX_RX_LEN_1552);
+	else
+		mcr_new |= MAC_MCR_MAX_RX_LEN(MAC_MCR_MAX_RX_LEN_2048);
+
+	/* Only update control register when needed! */
+	if (mcr_new != mcr_cur)
+		mtk_w32(mac->hw, mcr_new, MTK_MAC_MCR(mac->id));
+
+	dev->mtu = new_mtu;
+
+	return 0;
+}
+
 static int mtk_do_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 {
 	struct mtk_mac *mac = netdev_priv(dev);
@@ -2795,6 +2823,7 @@ static const struct net_device_ops mtk_netdev_ops = {
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

