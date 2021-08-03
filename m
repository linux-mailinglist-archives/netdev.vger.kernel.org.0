Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C7483DF20D
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 18:04:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231605AbhHCQEn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 12:04:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231523AbhHCQEl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 12:04:41 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B600BC061757;
        Tue,  3 Aug 2021 09:04:30 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id q2so24272193plr.11;
        Tue, 03 Aug 2021 09:04:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=trHX3dNNxUniX6odh5y30TfJPrJF2MKuXcijydie94Y=;
        b=NfG7+rxcLJmBodWpezqUR4cmNXccL1ppNPmGHayEAk1rKL2Q8lDgU/tydcniRSfz0q
         Hk1skwGADBUIDidM11A5sVl4FFhQcCqj233cmWTMxFu2hcUEWTOplAOfUClyo0yBgQmq
         070yL3QqqflzfK3bdgq+jVNmVUwSBcoPYapIJWrxdb48iefYC9WFnpbebvXWSLVSCVAo
         oi8f+1BKSiXsBCXbN3NPtoaiANnWJpeDRTlCOzeLjkW6MZIjegCzy964C82SI1mlsdAT
         auy+W4K5YxemXFKjQ0NcjFtN2ztmpBdC5n9F6o5OUSy85rBByZBNt4tccS9lltvAfeEp
         AMbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=trHX3dNNxUniX6odh5y30TfJPrJF2MKuXcijydie94Y=;
        b=qpr1IKLSiqbGStdfxnbmRnLm9ZGFWgHxv/RWXEuWmRvSXLSo7vujNIeldrPd904mWa
         Gvq/Um/EM5btqhgUqPLGoayxTFfnLNnHi33dINMDUKhWuhO79Pb7ZJD7DcseAkFM3rAq
         YsyHdpvu4QHWsKd+03VuI4ye9XXhzg/Xfek4J340bzdE2Gd4QueDb5UFuLgO6mv6CjfN
         Syy3ZGn1u0/yOLRhCsceDlxvCCIK4vPJOLRmI9+EzfJnKoWQqR7ddD4f5eKahbOUbrHS
         ZyJ7WweoDBvFadPu9AesVe+/g5WRbtXkBTVT8bWiMiAsuz8fiomOhy8INGhhlYuHNiXb
         3DPg==
X-Gm-Message-State: AOAM531TAWYcqVz4i36RUef1YNLTvmSXYJY3K6vXhCcgXrvPGrZs45k9
        FXNsTKOunvt0QPsyakuPGWE=
X-Google-Smtp-Source: ABdhPJzsOMAtDWMmETjJ8Y08EB4KiUxjyEx0F7EmMrQAkkBaEy/ytg3ad8G1rlSQPG/nlvMV272UrA==
X-Received: by 2002:a63:4a43:: with SMTP id j3mr696633pgl.302.1628006670264;
        Tue, 03 Aug 2021 09:04:30 -0700 (PDT)
Received: from haswell-ubuntu20.lan ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id y6sm14390653pjr.48.2021.08.03.09.04.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 09:04:29 -0700 (PDT)
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
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     Eric Woudstra <ericwouds@gmail.com>,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Subject: [PATCH net-next v2 2/4] net: dsa: mt7530: use independent VLAN learning on VLAN-unaware bridges
Date:   Wed,  4 Aug 2021 00:04:02 +0800
Message-Id: <20210803160405.3025624-3-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210803160405.3025624-1-dqfext@gmail.com>
References: <20210803160405.3025624-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Consider the following bridge configuration, where bond0 is not
offloaded:

         +-- br0 --+
        / /   |     \
       / /    |      \
      /  |    |     bond0
     /   |    |     /   \
   swp0 swp1 swp2 swp3 swp4
     .        .       .
     .        .       .
     A        B       C

Ideally, when the switch receives a packet from swp3 or swp4, it should
forward the packet to the CPU, according to the port matrix and unknown
unicast flood settings.

But packet loss will happen if the destination address is at one of the
offloaded ports (swp0~2). For example, when client C sends a packet to
A, the FDB lookup will indicate that it should be forwarded to swp0, but
the port matrix of swp3 and swp4 is configured to only allow the CPU to
be its destination, so it is dropped.

However, this issue does not happen if the bridge is VLAN-aware. That is
because VLAN-aware bridges use independent VLAN learning, i.e. use VID
for FDB lookup, on offloaded ports. As swp3 and swp4 are not offloaded,
shared VLAN learning with default filter ID of 0 is used instead. So the
lookup for A with filter ID 0 never hits and the packet can be forwarded
to the CPU.

In the current code, only two combinations were used to toggle user
ports' VLAN awareness: one is PCR.PORT_VLAN set to port matrix mode with
PVC.VLAN_ATTR set to transparent port, the other is PCR.PORT_VLAN set to
security mode with PVC.VLAN_ATTR set to user port.

It turns out that only PVC.VLAN_ATTR contributes to VLAN awareness, and
port matrix mode just skips the VLAN table lookup. The reference manual
is somehow misleading when describing PORT_VLAN modes. It states that
PORT_MEM (VLAN port member) is used for destination if the VLAN table
lookup hits, but actually **PORT_MEM & PORT_MATRIX** (bitwise AND of
VLAN port member and port matrix) is used instead, which means we can
have two or more separate VLAN-aware bridges with the same PVID and
traffic won't leak between them.

Therefore, to solve this, enable independent VLAN learning with PVID 0
on VLAN-unaware bridges, by setting their PCR.PORT_VLAN to fallback
mode, while leaving standalone ports in port matrix mode. The CPU port
is always set to fallback mode to serve those bridges.

During testing, it is found that FDB lookup with filter ID of 0 will
also hit entries with VID 0 even with independent VLAN learning. To
avoid that, install all VLANs with filter ID of 1.

Signed-off-by: DENG Qingfang <dqfext@gmail.com>
---
v1 -> v2: use FID enum instead of hardcoding.

 drivers/net/dsa/mt7530.c | 71 +++++++++++++++++++++++++++++-----------
 drivers/net/dsa/mt7530.h |  9 ++++-
 2 files changed, 59 insertions(+), 21 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index abe57b04fc39..606a9f4db579 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1021,6 +1021,10 @@ mt753x_cpu_port_enable(struct dsa_switch *ds, int port)
 	mt7530_write(priv, MT7530_PCR_P(port),
 		     PCR_MATRIX(dsa_user_ports(priv->ds)));
 
+	/* Set to fallback mode for independent VLAN learning */
+	mt7530_rmw(priv, MT7530_PCR_P(port), PCR_PORT_VLAN_MASK,
+		   MT7530_PORT_FALLBACK_MODE);
+
 	return 0;
 }
 
@@ -1229,6 +1233,10 @@ mt7530_port_bridge_join(struct dsa_switch *ds, int port,
 			   PCR_MATRIX_MASK, PCR_MATRIX(port_bitmap));
 	priv->ports[port].pm |= PCR_MATRIX(port_bitmap);
 
+	/* Set to fallback mode for independent VLAN learning */
+	mt7530_rmw(priv, MT7530_PCR_P(port), PCR_PORT_VLAN_MASK,
+		   MT7530_PORT_FALLBACK_MODE);
+
 	mutex_unlock(&priv->reg_mutex);
 
 	return 0;
@@ -1241,16 +1249,21 @@ mt7530_port_set_vlan_unaware(struct dsa_switch *ds, int port)
 	bool all_user_ports_removed = true;
 	int i;
 
-	/* When a port is removed from the bridge, the port would be set up
-	 * back to the default as is at initial boot which is a VLAN-unaware
-	 * port.
+	/* This is called after .port_bridge_leave when leaving a VLAN-aware
+	 * bridge. Don't set standalone ports to fallback mode.
 	 */
-	mt7530_rmw(priv, MT7530_PCR_P(port), PCR_PORT_VLAN_MASK,
-		   MT7530_PORT_MATRIX_MODE);
+	if (dsa_to_port(ds, port)->bridge_dev)
+		mt7530_rmw(priv, MT7530_PCR_P(port), PCR_PORT_VLAN_MASK,
+			   MT7530_PORT_FALLBACK_MODE);
+
 	mt7530_rmw(priv, MT7530_PVC_P(port), VLAN_ATTR_MASK | PVC_EG_TAG_MASK,
 		   VLAN_ATTR(MT7530_VLAN_TRANSPARENT) |
 		   PVC_EG_TAG(MT7530_VLAN_EG_CONSISTENT));
 
+	/* Set PVID to 0 */
+	mt7530_rmw(priv, MT7530_PPBV1_P(port), G0_PORT_VID_MASK,
+		   G0_PORT_VID_DEF);
+
 	for (i = 0; i < MT7530_NUM_PORTS; i++) {
 		if (dsa_is_user_port(ds, i) &&
 		    dsa_port_is_vlan_filtering(dsa_to_port(ds, i))) {
@@ -1276,15 +1289,14 @@ mt7530_port_set_vlan_aware(struct dsa_switch *ds, int port)
 	struct mt7530_priv *priv = ds->priv;
 
 	/* Trapped into security mode allows packet forwarding through VLAN
-	 * table lookup. CPU port is set to fallback mode to let untagged
-	 * frames pass through.
+	 * table lookup.
 	 */
-	if (dsa_is_cpu_port(ds, port))
-		mt7530_rmw(priv, MT7530_PCR_P(port), PCR_PORT_VLAN_MASK,
-			   MT7530_PORT_FALLBACK_MODE);
-	else
+	if (dsa_is_user_port(ds, port)) {
 		mt7530_rmw(priv, MT7530_PCR_P(port), PCR_PORT_VLAN_MASK,
 			   MT7530_PORT_SECURITY_MODE);
+		mt7530_rmw(priv, MT7530_PPBV1_P(port), G0_PORT_VID_MASK,
+			   G0_PORT_VID(priv->ports[port].pvid));
+	}
 
 	/* Set the port as a user port which is to be able to recognize VID
 	 * from incoming packets before fetching entry within the VLAN table.
@@ -1329,6 +1341,13 @@ mt7530_port_bridge_leave(struct dsa_switch *ds, int port,
 			   PCR_MATRIX(BIT(MT7530_CPU_PORT)));
 	priv->ports[port].pm = PCR_MATRIX(BIT(MT7530_CPU_PORT));
 
+	/* When a port is removed from the bridge, the port would be set up
+	 * back to the default as is at initial boot which is a VLAN-unaware
+	 * port.
+	 */
+	mt7530_rmw(priv, MT7530_PCR_P(port), PCR_PORT_VLAN_MASK,
+		   MT7530_PORT_MATRIX_MODE);
+
 	mutex_unlock(&priv->reg_mutex);
 }
 
@@ -1511,7 +1530,8 @@ mt7530_hw_vlan_add(struct mt7530_priv *priv,
 	/* Validate the entry with independent learning, create egress tag per
 	 * VLAN and joining the port as one of the port members.
 	 */
-	val = IVL_MAC | VTAG_EN | PORT_MEM(new_members) | VLAN_VALID;
+	val = IVL_MAC | VTAG_EN | PORT_MEM(new_members) | FID(FID_BRIDGED) |
+	      VLAN_VALID;
 	mt7530_write(priv, MT7530_VAWD1, val);
 
 	/* Decide whether adding tag or not for those outgoing packets from the
@@ -1601,9 +1621,13 @@ mt7530_port_vlan_add(struct dsa_switch *ds, int port,
 	mt7530_hw_vlan_update(priv, vlan->vid, &new_entry, mt7530_hw_vlan_add);
 
 	if (pvid) {
-		mt7530_rmw(priv, MT7530_PPBV1_P(port), G0_PORT_VID_MASK,
-			   G0_PORT_VID(vlan->vid));
 		priv->ports[port].pvid = vlan->vid;
+
+		/* Only configure PVID if VLAN filtering is enabled */
+		if (dsa_port_is_vlan_filtering(dsa_to_port(ds, port)))
+			mt7530_rmw(priv, MT7530_PPBV1_P(port),
+				   G0_PORT_VID_MASK,
+				   G0_PORT_VID(vlan->vid));
 	}
 
 	mutex_unlock(&priv->reg_mutex);
@@ -1617,11 +1641,9 @@ mt7530_port_vlan_del(struct dsa_switch *ds, int port,
 {
 	struct mt7530_hw_vlan_entry target_entry;
 	struct mt7530_priv *priv = ds->priv;
-	u16 pvid;
 
 	mutex_lock(&priv->reg_mutex);
 
-	pvid = priv->ports[port].pvid;
 	mt7530_hw_vlan_entry_init(&target_entry, port, 0);
 	mt7530_hw_vlan_update(priv, vlan->vid, &target_entry,
 			      mt7530_hw_vlan_del);
@@ -1629,11 +1651,12 @@ mt7530_port_vlan_del(struct dsa_switch *ds, int port,
 	/* PVID is being restored to the default whenever the PVID port
 	 * is being removed from the VLAN.
 	 */
-	if (pvid == vlan->vid)
-		pvid = G0_PORT_VID_DEF;
+	if (priv->ports[port].pvid == vlan->vid) {
+		priv->ports[port].pvid = G0_PORT_VID_DEF;
+		mt7530_rmw(priv, MT7530_PPBV1_P(port), G0_PORT_VID_MASK,
+			   G0_PORT_VID_DEF);
+	}
 
-	mt7530_rmw(priv, MT7530_PPBV1_P(port), G0_PORT_VID_MASK, pvid);
-	priv->ports[port].pvid = pvid;
 
 	mutex_unlock(&priv->reg_mutex);
 
@@ -2126,6 +2149,10 @@ mt7530_setup(struct dsa_switch *ds)
 				return ret;
 		} else {
 			mt7530_port_disable(ds, i);
+
+			/* Set default PVID to 0 on all user ports */
+			mt7530_rmw(priv, MT7530_PPBV1_P(i), G0_PORT_VID_MASK,
+				   G0_PORT_VID_DEF);
 		}
 		/* Enable consistent egress tag */
 		mt7530_rmw(priv, MT7530_PVC_P(i), PVC_EG_TAG_MASK,
@@ -2293,6 +2320,10 @@ mt7531_setup(struct dsa_switch *ds)
 				return ret;
 		} else {
 			mt7530_port_disable(ds, i);
+
+			/* Set default PVID to 0 on all user ports */
+			mt7530_rmw(priv, MT7530_PPBV1_P(i), G0_PORT_VID_MASK,
+				   G0_PORT_VID_DEF);
 		}
 
 		/* Enable consistent egress tag */
diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
index b19b389ff10a..d44640bbd865 100644
--- a/drivers/net/dsa/mt7530.h
+++ b/drivers/net/dsa/mt7530.h
@@ -148,11 +148,18 @@ enum mt7530_vlan_cmd {
 #define  VTAG_EN			BIT(28)
 /* VLAN Member Control */
 #define  PORT_MEM(x)			(((x) & 0xff) << 16)
+/* Filter ID */
+#define  FID(x)				(((x) & 0x7) << 1)
 /* VLAN Entry Valid */
 #define  VLAN_VALID			BIT(0)
 #define  PORT_MEM_SHFT			16
 #define  PORT_MEM_MASK			0xff
 
+enum mt7530_fid {
+	FID_STANDALONE = 0,
+	FID_BRIDGED = 1,
+};
+
 #define MT7530_VAWD2			0x98
 /* Egress Tag Control */
 #define  ETAG_CTRL_P(p, x)		(((x) & 0x3) << ((p) << 1))
@@ -247,7 +254,7 @@ enum mt7530_vlan_port_attr {
 #define MT7530_PPBV1_P(x)		(0x2014 + ((x) * 0x100))
 #define  G0_PORT_VID(x)			(((x) & 0xfff) << 0)
 #define  G0_PORT_VID_MASK		G0_PORT_VID(0xfff)
-#define  G0_PORT_VID_DEF		G0_PORT_VID(1)
+#define  G0_PORT_VID_DEF		G0_PORT_VID(0)
 
 /* Register for port MAC control register */
 #define MT7530_PMCR_P(x)		(0x3000 + ((x) * 0x100))
-- 
2.25.1

