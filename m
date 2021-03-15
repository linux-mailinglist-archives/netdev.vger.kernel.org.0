Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A507433C39C
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 18:10:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235552AbhCORJ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 13:09:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234810AbhCORJt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 13:09:49 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56AF0C06174A;
        Mon, 15 Mar 2021 10:09:49 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id bt4so9148570pjb.5;
        Mon, 15 Mar 2021 10:09:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gVx9Pv6PF+gvg4bUX5R/A8d5/YPrI5l7pmHtd3cE+qE=;
        b=QeuiYMZQbXOp1ZPqMRl0R797j0LbFfYcmg55F/EhdPYt/+GYF6XrcfEYGCI2/6kiN3
         oy5J6pK1YcjaziwXvDZufwJ3dRJfO1MPrULpPBs/o5VCzZ28cZ6ttAKaFRLkGrwj+aNe
         1sSLd/N7yTtGPUmXMHWdKN/6107JrnjuYC9/yBm5FHULCkQzGMgRzTVc+pRNxUPJyoN0
         o4/8hHjW0YH3+YVE5qJfIlE617ouI+3GDsa2/MzD2Uy7Wbzfbko5C41ppZU7jjPnWF4R
         V6gO1vcxNQxCOgQzQ2ymcDKHRw0HeqVSWyS2IawMu0orn3EjR43yXn6FhYYwU+3mqWMU
         d6UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gVx9Pv6PF+gvg4bUX5R/A8d5/YPrI5l7pmHtd3cE+qE=;
        b=iWVOJ3UffTuryZh67S5ilKl7Nv0VRzEqEAdV/wIQOCTIgGSYcvmixeA4RrBaQn8yOv
         HoqHCWkqFKwkIfVrmCtPml4zDql0s2kum1E3f9ke42U7Bx+VmPSMh7M9Ync4YAuzkWBE
         D8KFeUplBnl6qs8x+TG2S4kdz4C4bgwX4DUnCIJDvcvJmRoPY8OYam2qPMYARtCJYneH
         hSo/h5TEe67Caj5QgfXTPEx1pqBLot4MJglJ/1EWWC2KcjbcpwoJR5Sbj1ZK3W6KexQW
         zuOIkA0Vjti0M23WqS6F+hwvpOOK2vDm3YXiRVt4NLw8SNRh1tXp14O3YLw3KTAUvtl2
         3hsQ==
X-Gm-Message-State: AOAM533ljL2pLX20pQd2QX1+1EdE2oIc5VBEHFVozwP6RI9HdLGxPIuB
        Lgs/GMdjmu+OZqpxUgUKOPQ=
X-Google-Smtp-Source: ABdhPJywCavdQIXmIQDkguNJ+qt5BapJfqmaDbzyt7G1QhVz3ck1507LWgBrfyNKqGtjgVxyo8SrSg==
X-Received: by 2002:a17:902:aa0c:b029:e5:da5f:5f66 with SMTP id be12-20020a170902aa0cb02900e5da5f5f66mr12798299plb.81.1615828188892;
        Mon, 15 Mar 2021 10:09:48 -0700 (PDT)
Received: from localhost.localdomain ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id 186sm15221799pfb.143.2021.03.15.10.09.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 10:09:48 -0700 (PDT)
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
Subject: [PATCH net-next] net: dsa: mt7530: support MDB and bridge flag operations
Date:   Tue, 16 Mar 2021 01:09:40 +0800
Message-Id: <20210315170940.2414854-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support port MDB and bridge flag operations.

As the hardware can manage multicast forwarding itself, offload_fwd_mark
can be unconditionally set to true.

Signed-off-by: DENG Qingfang <dqfext@gmail.com>
---
Changes since RFC:
  Replaced BR_AUTO_MASK with BR_FLOOD | BR_LEARNING

 drivers/net/dsa/mt7530.c | 124 +++++++++++++++++++++++++++++++++++++--
 drivers/net/dsa/mt7530.h |   1 +
 net/dsa/tag_mtk.c        |  14 +----
 3 files changed, 122 insertions(+), 17 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 2342d4528b4c..f765984330c9 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1000,8 +1000,9 @@ mt753x_cpu_port_enable(struct dsa_switch *ds, int port)
 	mt7530_write(priv, MT7530_PVC_P(port),
 		     PORT_SPEC_TAG);
 
-	/* Unknown multicast frame forwarding to the cpu port */
-	mt7530_rmw(priv, MT7530_MFC, UNM_FFP_MASK, UNM_FFP(BIT(port)));
+	/* Disable flooding by default */
+	mt7530_rmw(priv, MT7530_MFC, BC_FFP_MASK | UNM_FFP_MASK | UNU_FFP_MASK,
+		   BC_FFP(BIT(port)) | UNM_FFP(BIT(port)) | UNU_FFP(BIT(port)));
 
 	/* Set CPU port number */
 	if (priv->id == ID_MT7621)
@@ -1138,6 +1139,56 @@ mt7530_stp_state_set(struct dsa_switch *ds, int port, u8 state)
 	mt7530_rmw(priv, MT7530_SSP_P(port), FID_PST_MASK, stp_state);
 }
 
+static int
+mt7530_port_pre_bridge_flags(struct dsa_switch *ds, int port,
+			     struct switchdev_brport_flags flags,
+			     struct netlink_ext_ack *extack)
+{
+	if (flags.mask & ~(BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD |
+			   BR_BCAST_FLOOD))
+		return -EINVAL;
+
+	return 0;
+}
+
+static int
+mt7530_port_bridge_flags(struct dsa_switch *ds, int port,
+			 struct switchdev_brport_flags flags,
+			 struct netlink_ext_ack *extack)
+{
+	struct mt7530_priv *priv = ds->priv;
+
+	if (flags.mask & BR_LEARNING)
+		mt7530_rmw(priv, MT7530_PSC_P(port), SA_DIS,
+			   flags.val & BR_LEARNING ? 0 : SA_DIS);
+
+	if (flags.mask & BR_FLOOD)
+		mt7530_rmw(priv, MT7530_MFC, UNU_FFP(BIT(port)),
+			   flags.val & BR_FLOOD ? UNU_FFP(BIT(port)) : 0);
+
+	if (flags.mask & BR_MCAST_FLOOD)
+		mt7530_rmw(priv, MT7530_MFC, UNM_FFP(BIT(port)),
+			   flags.val & BR_MCAST_FLOOD ? UNM_FFP(BIT(port)) : 0);
+
+	if (flags.mask & BR_BCAST_FLOOD)
+		mt7530_rmw(priv, MT7530_MFC, BC_FFP(BIT(port)),
+			   flags.val & BR_BCAST_FLOOD ? BC_FFP(BIT(port)) : 0);
+
+	return 0;
+}
+
+static int
+mt7530_port_set_mrouter(struct dsa_switch *ds, int port, bool mrouter,
+			struct netlink_ext_ack *extack)
+{
+	struct mt7530_priv *priv = ds->priv;
+
+	mt7530_rmw(priv, MT7530_MFC, UNM_FFP(BIT(port)),
+		   mrouter ? UNM_FFP(BIT(port)) : 0);
+
+	return 0;
+}
+
 static int
 mt7530_port_bridge_join(struct dsa_switch *ds, int port,
 			struct net_device *bridge)
@@ -1349,6 +1400,59 @@ mt7530_port_fdb_dump(struct dsa_switch *ds, int port,
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
@@ -2492,9 +2596,13 @@ mt7530_setup(struct dsa_switch *ds)
 			ret = mt753x_cpu_port_enable(ds, i);
 			if (ret)
 				return ret;
-		} else
+		} else {
 			mt7530_port_disable(ds, i);
 
+			/* Disable learning by default on all user ports */
+			mt7530_set(priv, MT7530_PSC_P(i), SA_DIS);
+		}
+
 		/* Enable consistent egress tag */
 		mt7530_rmw(priv, MT7530_PVC_P(i), PVC_EG_TAG_MASK,
 			   PVC_EG_TAG(MT7530_VLAN_EG_CONSISTENT));
@@ -2656,9 +2764,12 @@ mt7531_setup(struct dsa_switch *ds)
 			ret = mt753x_cpu_port_enable(ds, i);
 			if (ret)
 				return ret;
-		} else
+		} else {
 			mt7530_port_disable(ds, i);
 
+			/* Disable learning by default on all user ports */
+			mt7530_set(priv, MT7530_PSC_P(i), SA_DIS);
+		}
 		/* Enable consistent egress tag */
 		mt7530_rmw(priv, MT7530_PVC_P(i), PVC_EG_TAG_MASK,
 			   PVC_EG_TAG(MT7530_VLAN_EG_CONSISTENT));
@@ -3385,11 +3496,16 @@ static const struct dsa_switch_ops mt7530_switch_ops = {
 	.port_change_mtu	= mt7530_port_change_mtu,
 	.port_max_mtu		= mt7530_port_max_mtu,
 	.port_stp_state_set	= mt7530_stp_state_set,
+	.port_pre_bridge_flags	= mt7530_port_pre_bridge_flags,
+	.port_bridge_flags	= mt7530_port_bridge_flags,
+	.port_set_mrouter	= mt7530_port_set_mrouter,
 	.port_bridge_join	= mt7530_port_bridge_join,
 	.port_bridge_leave	= mt7530_port_bridge_leave,
 	.port_fdb_add		= mt7530_port_fdb_add,
 	.port_fdb_del		= mt7530_port_fdb_del,
 	.port_fdb_dump		= mt7530_port_fdb_dump,
+	.port_mdb_add		= mt7530_port_mdb_add,
+	.port_mdb_del		= mt7530_port_mdb_del,
 	.port_vlan_filtering	= mt7530_port_vlan_filtering,
 	.port_vlan_add		= mt7530_port_vlan_add,
 	.port_vlan_del		= mt7530_port_vlan_del,
diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
index e4a4c8d1fbc8..fd7b66776c4e 100644
--- a/drivers/net/dsa/mt7530.h
+++ b/drivers/net/dsa/mt7530.h
@@ -34,6 +34,7 @@ enum mt753x_id {
 /* Registers to mac forward control for unknown frames */
 #define MT7530_MFC			0x10
 #define  BC_FFP(x)			(((x) & 0xff) << 24)
+#define  BC_FFP_MASK			BC_FFP(~0)
 #define  UNM_FFP(x)			(((x) & 0xff) << 16)
 #define  UNM_FFP_MASK			UNM_FFP(~0)
 #define  UNU_FFP(x)			(((x) & 0xff) << 8)
diff --git a/net/dsa/tag_mtk.c b/net/dsa/tag_mtk.c
index 59748487664f..f9b2966d1936 100644
--- a/net/dsa/tag_mtk.c
+++ b/net/dsa/tag_mtk.c
@@ -24,9 +24,6 @@ static struct sk_buff *mtk_tag_xmit(struct sk_buff *skb,
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	u8 xmit_tpid;
 	u8 *mtk_tag;
-	unsigned char *dest = eth_hdr(skb)->h_dest;
-	bool is_multicast_skb = is_multicast_ether_addr(dest) &&
-				!is_broadcast_ether_addr(dest);
 
 	/* Build the special tag after the MAC Source Address. If VLAN header
 	 * is present, it's required that VLAN header and special tag is
@@ -55,10 +52,6 @@ static struct sk_buff *mtk_tag_xmit(struct sk_buff *skb,
 	mtk_tag[0] = xmit_tpid;
 	mtk_tag[1] = (1 << dp->index) & MTK_HDR_XMIT_DP_BIT_MASK;
 
-	/* Disable SA learning for multicast frames */
-	if (unlikely(is_multicast_skb))
-		mtk_tag[1] |= MTK_HDR_XMIT_SA_DIS;
-
 	/* Tag control information is kept for 802.1Q */
 	if (xmit_tpid == MTK_HDR_XMIT_UNTAGGED) {
 		mtk_tag[2] = 0;
@@ -74,9 +67,6 @@ static struct sk_buff *mtk_tag_rcv(struct sk_buff *skb, struct net_device *dev,
 	u16 hdr;
 	int port;
 	__be16 *phdr;
-	unsigned char *dest = eth_hdr(skb)->h_dest;
-	bool is_multicast_skb = is_multicast_ether_addr(dest) &&
-				!is_broadcast_ether_addr(dest);
 
 	if (unlikely(!pskb_may_pull(skb, MTK_HDR_LEN)))
 		return NULL;
@@ -102,9 +92,7 @@ static struct sk_buff *mtk_tag_rcv(struct sk_buff *skb, struct net_device *dev,
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

