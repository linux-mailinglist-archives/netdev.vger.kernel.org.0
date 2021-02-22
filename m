Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9B803213AE
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 11:04:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230449AbhBVKEe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 05:04:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230240AbhBVKCv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 05:02:51 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FC9BC061574;
        Mon, 22 Feb 2021 02:02:07 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id z5so3077395pfe.3;
        Mon, 22 Feb 2021 02:02:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=W8DgW6oECOiwuHvyIv6eHEM1u1Xu5AIuzuKgMGxRQOc=;
        b=MiEZXuXs6i/aKscHT4ECjnJa3i/ukmy5gJSH2dC5aL/hj2Q1xiVdd8QOaW8xYoClRK
         Kya1/nCvRVaKylUcDSGRidbNOBTKh+uY9HdOgpjLGtq7EthmgyxczTVhopoV8RyODVt1
         kX0Bv2ZcK5vVJ3NIJFSkqUDaAe75ZS+mM51BH824LG/BKjJwDM8ENAPqbd9exuGnvl9R
         jOcbMRGkVjvBGzoiGKXOBcfYHp89IOzJdPhKfpiWWg4q7OZkP5jpWIpNCfZ9fNnM9mTR
         WGevu1vdZvvjaMS9WOPQqED01LvfPCI0UqP+c5J9FH6sK11sCQ+WUTLSzL7usZkAEoU3
         LEQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=W8DgW6oECOiwuHvyIv6eHEM1u1Xu5AIuzuKgMGxRQOc=;
        b=qORDj2I1k3icx4A7XuZ4mmBvKdn0kDnx/qRwZ0f2H8jW/ws9J5wyfl2Co54Z+NwkGl
         XjKuX/xgnVtnzL6UmwX5oUqdK/zwZv2dDt2Y0877Y/nLjUKc8+kWJa39MhlZ5pKqPz1J
         POuTIYQWWtisodXtymOIPByDTin+aM7rVP94pNR+5mATS/zU8oXwtshFTYjc9GWka9IM
         0vxb5iMreI+qCiw3VWxMyjn1cDtA46c00NzbvqvouC0bic2qssjgUOpGArAr2OX5ZScK
         THuE8Pd3RFIzhCelbZPkS61YwfzBiWDfBfg4Nyx74nWFnHW9DyQaBb9y7C6LuKwQ/Dox
         htVQ==
X-Gm-Message-State: AOAM533KBHNGzzXnadQGu0lQZqce4XdaLOQzpFo9U4Ie7Rb1ZNspyw6z
        P2KVbbSP3LV4v0iLfiaaURs=
X-Google-Smtp-Source: ABdhPJxPbX8kcc0YRwDKsYkpBpFhUH5DXAs4YwwcgTB6ayWfqqx01TcOv3b+jjft8RhXAPa8KJOYjg==
X-Received: by 2002:a63:4602:: with SMTP id t2mr19186801pga.214.1613988126938;
        Mon, 22 Feb 2021 02:02:06 -0800 (PST)
Received: from container-ubuntu.lan ([171.211.28.185])
        by smtp.gmail.com with ESMTPSA id t16sm3605213pfe.165.2021.02.22.02.01.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 02:02:06 -0800 (PST)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     Frank Wunderlich <frank-w@public-files.de>,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>
Subject: [PATCH net-next] net: dsa: mt7530: support MDB operations
Date:   Mon, 22 Feb 2021 18:01:56 +0800
Message-Id: <20210222100156.32652-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As the hardware can manage multicast forwarding itself, trapping
multicast traffic to the CPU is no longer required.

Signed-off-by: DENG Qingfang <dqfext@gmail.com>
---
 drivers/net/dsa/mt7530.c | 58 +++++++++++++++++++++++++++++++++++++---
 net/dsa/tag_mtk.c        | 14 +---------
 2 files changed, 56 insertions(+), 16 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 28aab0ff6e7d..20e66cf13485 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1000,9 +1000,6 @@ mt753x_cpu_port_enable(struct dsa_switch *ds, int port)
 	mt7530_write(priv, MT7530_PVC_P(port),
 		     PORT_SPEC_TAG);
 
-	/* Unknown multicast frame forwarding to the cpu port */
-	mt7530_rmw(priv, MT7530_MFC, UNM_FFP_MASK, UNM_FFP(BIT(port)));
-
 	/* Set CPU port number */
 	if (priv->id == ID_MT7621)
 		mt7530_rmw(priv, MT7530_MFC, CPU_MASK, CPU_EN | CPU_PORT(port));
@@ -1365,6 +1362,59 @@ mt7530_port_fdb_dump(struct dsa_switch *ds, int port,
 	return 0;
 }
 
+static int
+mt7530_port_mdb_add(struct dsa_switch *ds, int port,
+		    const struct switchdev_obj_port_mdb *mdb)
+{
+	struct mt7530_priv *priv = ds->priv;
+	const u8 *addr = mdb->addr;
+	u16 vid = mdb->vid;
+	u8 port_mask = 0;
+	int ret;
+
+	mutex_lock(&priv->reg_mutex);
+
+	mt7530_fdb_write(priv, vid, 0, addr, 0, STATIC_EMP);
+	if (!mt7530_fdb_cmd(priv, MT7530_FDB_READ, NULL))
+		port_mask = (mt7530_read(priv, MT7530_ATRD) >> PORT_MAP)
+			    & PORT_MAP_MASK;
+
+	port_mask |= BIT(port);
+	mt7530_fdb_write(priv, vid, port_mask, addr, -1, STATIC_ENT);
+	ret = mt7530_fdb_cmd(priv, MT7530_FDB_WRITE, NULL);
+
+	mutex_unlock(&priv->reg_mutex);
+
+	return ret;
+}
+
+static int
+mt7530_port_mdb_del(struct dsa_switch *ds, int port,
+		    const struct switchdev_obj_port_mdb *mdb)
+{
+	struct mt7530_priv *priv = ds->priv;
+	const u8 *addr = mdb->addr;
+	u16 vid = mdb->vid;
+	u8 port_mask = 0;
+	int ret;
+
+	mutex_lock(&priv->reg_mutex);
+
+	mt7530_fdb_write(priv, vid, 0, addr, 0, STATIC_EMP);
+	if (!mt7530_fdb_cmd(priv, MT7530_FDB_READ, NULL))
+		port_mask = (mt7530_read(priv, MT7530_ATRD) >> PORT_MAP)
+			    & PORT_MAP_MASK;
+
+	port_mask &= ~BIT(port);
+	mt7530_fdb_write(priv, vid, port_mask, addr, -1,
+			 port_mask ? STATIC_ENT : STATIC_EMP);
+	ret = mt7530_fdb_cmd(priv, MT7530_FDB_WRITE, NULL);
+
+	mutex_unlock(&priv->reg_mutex);
+
+	return ret;
+}
+
 static int
 mt7530_vlan_cmd(struct mt7530_priv *priv, enum mt7530_vlan_cmd cmd, u16 vid)
 {
@@ -3403,6 +3453,8 @@ static const struct dsa_switch_ops mt7530_switch_ops = {
 	.port_fdb_add		= mt7530_port_fdb_add,
 	.port_fdb_del		= mt7530_port_fdb_del,
 	.port_fdb_dump		= mt7530_port_fdb_dump,
+	.port_mdb_add		= mt7530_port_mdb_add,
+	.port_mdb_del		= mt7530_port_mdb_del,
 	.port_vlan_filtering	= mt7530_port_vlan_filtering,
 	.port_vlan_add		= mt7530_port_vlan_add,
 	.port_vlan_del		= mt7530_port_vlan_del,
diff --git a/net/dsa/tag_mtk.c b/net/dsa/tag_mtk.c
index 38dcdded74c0..53b620e177ad 100644
--- a/net/dsa/tag_mtk.c
+++ b/net/dsa/tag_mtk.c
@@ -23,9 +23,6 @@ static struct sk_buff *mtk_tag_xmit(struct sk_buff *skb,
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	u8 *mtk_tag;
 	bool is_vlan_skb = true;
-	unsigned char *dest = eth_hdr(skb)->h_dest;
-	bool is_multicast_skb = is_multicast_ether_addr(dest) &&
-				!is_broadcast_ether_addr(dest);
 
 	/* Build the special tag after the MAC Source Address. If VLAN header
 	 * is present, it's required that VLAN header and special tag is
@@ -48,10 +45,6 @@ static struct sk_buff *mtk_tag_xmit(struct sk_buff *skb,
 		     MTK_HDR_XMIT_UNTAGGED;
 	mtk_tag[1] = (1 << dp->index) & MTK_HDR_XMIT_DP_BIT_MASK;
 
-	/* Disable SA learning for multicast frames */
-	if (unlikely(is_multicast_skb))
-		mtk_tag[1] |= MTK_HDR_XMIT_SA_DIS;
-
 	/* Tag control information is kept for 802.1Q */
 	if (!is_vlan_skb) {
 		mtk_tag[2] = 0;
@@ -67,9 +60,6 @@ static struct sk_buff *mtk_tag_rcv(struct sk_buff *skb, struct net_device *dev,
 	u16 hdr;
 	int port;
 	__be16 *phdr;
-	unsigned char *dest = eth_hdr(skb)->h_dest;
-	bool is_multicast_skb = is_multicast_ether_addr(dest) &&
-				!is_broadcast_ether_addr(dest);
 
 	if (unlikely(!pskb_may_pull(skb, MTK_HDR_LEN)))
 		return NULL;
@@ -95,9 +85,7 @@ static struct sk_buff *mtk_tag_rcv(struct sk_buff *skb, struct net_device *dev,
 	if (!skb->dev)
 		return NULL;
 
-	/* Only unicast or broadcast frames are offloaded */
-	if (likely(!is_multicast_skb))
-		skb->offload_fwd_mark = 1;
+	skb->offload_fwd_mark = 1;
 
 	return skb;
 }
-- 
2.25.1

