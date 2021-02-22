Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3B073213C9
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 11:09:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230400AbhBVKIx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 05:08:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231127AbhBVKIM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 05:08:12 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB668C061786;
        Mon, 22 Feb 2021 02:07:31 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id gm18so3365253pjb.1;
        Mon, 22 Feb 2021 02:07:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Udsk+z6S+lmul3ghhLaA1MmOuPDaJpmhE/2DZlIxpH4=;
        b=TEF49KVVMWNsLlswBqRlelynbivwsoSQOJvdti1iBz7y6wQSK+YDDUw6N4qTsngxyt
         aFvJY+ZF5jdgwGyL+J3+jbU02AS2rhGBMNhh7gqN4bKz+Ich0CxQfhA1FzTueW4I5SdH
         pVxLvRZL6iXiYSXhIWmJ2VdvZ7dAPACvaCK8TvhgwM8aeScdsFZSJ/ij9e1nF6k/y6X/
         YguC69OdU9rEMwAzGU17PaiiJCODVTzNu5HJ7SkbZpP1DrKil3WaH4Y62fK29Hvg2iGV
         kBNAm4xvTucYXOClAerpJg4T4ah3fuMktt8PlS0uv+0hhCKaYgDUmlMfHUkf6mguLsUr
         MR3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Udsk+z6S+lmul3ghhLaA1MmOuPDaJpmhE/2DZlIxpH4=;
        b=mdWCl25kfVQUkU1gTW22RicmVUxCegf6XqIXpt3sjofC4TIo6cYZQg1GahUqjHxadm
         ErHIUtSAorVuL1mWjkart0n7uUkL2qHSzdwPlS1FkQxuTYzd26EoxOm8XLpn0zBtKG+b
         3gMXPd0LLu87DpuZEQv+KmQcqoZNaXgyF8zXmO6pFOlxopeoO4ndh0UtYhJyvok4pa2d
         cS1L3rtE+LPuHX3EV0u0eivYTqmkTREwlBdx/gLO/4uZyOAFXVADFqJjzoW15QwoX++U
         Vg8OIyIy8p2izL/8UO7+XmjEP6LPrrgIZ19P6CbFea/zHH3hwhKyZVBwtX3BBnkJzXtM
         Dtcg==
X-Gm-Message-State: AOAM53147eWtZM3wmpy2ReYKdLgzGTlmfq0jFS6b6zw7gHt63UETO7Ag
        5kSO8diWdcyVCQzFArZzeHU=
X-Google-Smtp-Source: ABdhPJyrTvPPv2k+hYwKfxlUJ73L09piHJhfK1M3zTlfpoK9V1u1YJefTgwbbsb+YFs9kfD1kV94qQ==
X-Received: by 2002:a17:902:ba91:b029:e3:fe6d:505c with SMTP id k17-20020a170902ba91b02900e3fe6d505cmr2630491pls.7.1613988451310;
        Mon, 22 Feb 2021 02:07:31 -0800 (PST)
Received: from container-ubuntu.lan ([171.211.28.185])
        by smtp.gmail.com with ESMTPSA id ch14sm9317902pjb.22.2021.02.22.02.07.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 02:07:30 -0800 (PST)
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
Subject: [PATCH net-next v2] net: dsa: mt7530: support MDB operations
Date:   Mon, 22 Feb 2021 18:07:17 +0800
Message-Id: <20210222100717.451-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support port MDB add to/delete from MT7530 ARL.

As the hardware can manage multicast forwarding itself, trapping
multicast traffic to the CPU is no longer required.

Signed-off-by: DENG Qingfang <dqfext@gmail.com>
---
v1 -> v2: fix commit message

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

