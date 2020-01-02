Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 582CF12F1D9
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 00:38:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727227AbgABXig (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 18:38:36 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:37647 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbgABXif (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 18:38:35 -0500
Received: by mail-pg1-f193.google.com with SMTP id q127so22625450pga.4;
        Thu, 02 Jan 2020 15:38:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=+i7ic5QJroprhhGIk1bmK5MIiUO4KPc7ky4YhGp+2n8=;
        b=sto1QBYvyxocM5YSop6sa2vDb3lP0kZwCy4NX7l+uNw399ljIgLFFEh/lLsr3WbrZ6
         Ua75WZA53oAXtgMz5HOaatc1X1cerw6JrQVgzV7wNGF2cwHvwaH6BnxCrYUC8aaXttEi
         G3e/FqkalbF5q7AFmL1S68iRyDyCznkQ8ugRC1ID+kb1ESqTO+ybB1YWSuQF8L0M834v
         lSOzbjzxDELT1sRzyKSQZZcb+O8SJKjU776Nq/CAJFrSE2zzKkNeHPNnns+V6dZFAPaw
         SBI2EBLrIcO8R6lkgx9yDOCrvlEfA2xCLdFup3CmCOI0ekRNIHHoPoHU0K/SUKl1wMaq
         ZudQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=+i7ic5QJroprhhGIk1bmK5MIiUO4KPc7ky4YhGp+2n8=;
        b=Y8FnM5+VEN5d72NkgUkxOWNq2sYPyCnX+JBiVpxutGWUEn8MosrbRYDYFwoHptivIV
         4LcMbOTMcEY9r9VgtwCfbZqWpsVJS4nwHcUyWYHPd0/9FAuQF5TFimx+G8QcZD41R5Dy
         MAAT+gpD7/UlZ/lPmiro/jJDjsrzetg7uoKnieBEHW9/xjXG5cHwX7QqYXood5QNsztE
         BCnw2BemSxy8Ppj984TeuXN+km68/1on1JgD2+Vta2EVBotuxRSXO2b80oSG6+S8xk9h
         ozGPxO1D1OdGJt2RNzQJPTOvn6Abh1NK9d7B+4eUoMrP8Ecpu+0vhB6pkJGpCk/KT+90
         901w==
X-Gm-Message-State: APjAAAWqQcSmtjNYv450Rl5hXSaM7S53zIQoDeySfp0BIFaBsrC9U/Ii
        qUbn6ARU5b/41fFRP9irUql+bvnt
X-Google-Smtp-Source: APXvYqyOn4AyoceAvfeBjHjiSwgLJ2hMKiYpUPV5l+dd5BsW3kJDiPu1tRRJxaRZ5TaG5KAigNZnWA==
X-Received: by 2002:aa7:9d9c:: with SMTP id f28mr91617241pfq.20.1578008314628;
        Thu, 02 Jan 2020 15:38:34 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id c22sm42720161pfo.50.2020.01.02.15.38.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jan 2020 15:38:33 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     alobakin@dlink.ru, rmk+kernel@armlinux.org.uk,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Stanislav Fomichev <sdf@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>,
        Petar Penkov <ppenkov@google.com>,
        Matteo Croce <mcroce@redhat.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>,
        Paul Blakey <paulb@mellanox.com>,
        Yoshiki Komachi <komachi.yoshiki@gmail.com>,
        linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/Mediatek SoC
        support),
        linux-mediatek@lists.infradead.org (moderated list:ARM/Mediatek SoC
        support)
Subject: [PATCH net-next] net: dsa: Remove indirect function call for flow dissection
Date:   Thu,  2 Jan 2020 15:36:53 -0800
Message-Id: <20200102233657.12933-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We only need "static" information to be given for DSA flow dissection,
so replace the expensive call to .flow_dissect() with an integer giving
us the offset into the packet array of bytes that we must de-reference
to obtain the protocol number. The overhead was alreayd available from
the dsa_device_ops structure so use that directly.

The presence of a flow_dissect callback used to indicate that the DSA
tagger supported returning that information,we now encode this with a
proto_off value of DSA_PROTO_OFF_UNPSEC if the tagger does not support
providing that information yet.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes since RFC:

- use a constant instead of the "magic" -1
- update all tag drivers and build test correctly

 include/net/dsa.h         |  5 +++--
 net/core/flow_dissector.c | 15 ++++++++++-----
 net/dsa/tag_brcm.c        |  2 ++
 net/dsa/tag_dsa.c         | 10 +---------
 net/dsa/tag_edsa.c        | 10 +---------
 net/dsa/tag_gswip.c       |  1 +
 net/dsa/tag_ksz.c         |  3 +++
 net/dsa/tag_lan9303.c     |  1 +
 net/dsa/tag_mtk.c         | 11 +----------
 net/dsa/tag_ocelot.c      |  1 +
 net/dsa/tag_qca.c         | 11 +----------
 net/dsa/tag_sja1105.c     |  1 +
 12 files changed, 26 insertions(+), 45 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index da5578db228e..5b77eb7eea02 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -68,18 +68,19 @@ enum dsa_tag_protocol {
 struct packet_type;
 struct dsa_switch;
 
+#define DSA_PROTO_OFF_UNSPEC	-1
+
 struct dsa_device_ops {
 	struct sk_buff *(*xmit)(struct sk_buff *skb, struct net_device *dev);
 	struct sk_buff *(*rcv)(struct sk_buff *skb, struct net_device *dev,
 			       struct packet_type *pt);
-	int (*flow_dissect)(const struct sk_buff *skb, __be16 *proto,
-			    int *offset);
 	/* Used to determine which traffic should match the DSA filter in
 	 * eth_type_trans, and which, if any, should bypass it and be processed
 	 * as regular on the master net device.
 	 */
 	bool (*filter)(const struct sk_buff *skb, struct net_device *dev);
 	unsigned int overhead;
+	int proto_off;
 	const char *name;
 	enum dsa_tag_protocol proto;
 };
diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 2dbbb030fbed..1d8f1ecde51e 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -972,13 +972,18 @@ bool __skb_flow_dissect(const struct net *net,
 		if (unlikely(skb->dev && netdev_uses_dsa(skb->dev) &&
 			     proto == htons(ETH_P_XDSA))) {
 			const struct dsa_device_ops *ops;
-			int offset = 0;
+			unsigned int overhead;
+			int proto_off;
 
 			ops = skb->dev->dsa_ptr->tag_ops;
-			if (ops->flow_dissect &&
-			    !ops->flow_dissect(skb, &proto, &offset)) {
-				hlen -= offset;
-				nhoff += offset;
+			overhead = ops->overhead;
+			proto_off = ops->proto_off;
+			if (likely(overhead &&
+				   proto_off != DSA_PROTO_OFF_UNSPEC &&
+				   proto_off < skb->len)) {
+				hlen -= overhead;
+				nhoff += overhead;
+				proto = ((__be16 *)skb->data)[proto_off];
 			}
 		}
 #endif
diff --git a/net/dsa/tag_brcm.c b/net/dsa/tag_brcm.c
index 9c3114179690..abc050e3c092 100644
--- a/net/dsa/tag_brcm.c
+++ b/net/dsa/tag_brcm.c
@@ -177,6 +177,7 @@ static const struct dsa_device_ops brcm_netdev_ops = {
 	.xmit	= brcm_tag_xmit,
 	.rcv	= brcm_tag_rcv,
 	.overhead = BRCM_TAG_LEN,
+	.proto_off = DSA_PROTO_OFF_UNSPEC,
 };
 
 DSA_TAG_DRIVER(brcm_netdev_ops);
@@ -205,6 +206,7 @@ static const struct dsa_device_ops brcm_prepend_netdev_ops = {
 	.xmit	= brcm_tag_xmit_prepend,
 	.rcv	= brcm_tag_rcv_prepend,
 	.overhead = BRCM_TAG_LEN,
+	.proto_off = DSA_PROTO_OFF_UNSPEC,
 };
 
 DSA_TAG_DRIVER(brcm_prepend_netdev_ops);
diff --git a/net/dsa/tag_dsa.c b/net/dsa/tag_dsa.c
index 7ddec9794477..4a970e959fef 100644
--- a/net/dsa/tag_dsa.c
+++ b/net/dsa/tag_dsa.c
@@ -142,21 +142,13 @@ static struct sk_buff *dsa_rcv(struct sk_buff *skb, struct net_device *dev,
 	return skb;
 }
 
-static int dsa_tag_flow_dissect(const struct sk_buff *skb, __be16 *proto,
-				int *offset)
-{
-	*offset = 4;
-	*proto = ((__be16 *)skb->data)[1];
-	return 0;
-}
-
 static const struct dsa_device_ops dsa_netdev_ops = {
 	.name	= "dsa",
 	.proto	= DSA_TAG_PROTO_DSA,
 	.xmit	= dsa_xmit,
 	.rcv	= dsa_rcv,
-	.flow_dissect   = dsa_tag_flow_dissect,
 	.overhead = DSA_HLEN,
+	.proto_off = 1,
 };
 
 MODULE_LICENSE("GPL");
diff --git a/net/dsa/tag_edsa.c b/net/dsa/tag_edsa.c
index e8eaa804ccb9..c7cb0df17287 100644
--- a/net/dsa/tag_edsa.c
+++ b/net/dsa/tag_edsa.c
@@ -161,21 +161,13 @@ static struct sk_buff *edsa_rcv(struct sk_buff *skb, struct net_device *dev,
 	return skb;
 }
 
-static int edsa_tag_flow_dissect(const struct sk_buff *skb, __be16 *proto,
-				 int *offset)
-{
-	*offset = 8;
-	*proto = ((__be16 *)skb->data)[3];
-	return 0;
-}
-
 static const struct dsa_device_ops edsa_netdev_ops = {
 	.name	= "edsa",
 	.proto	= DSA_TAG_PROTO_EDSA,
 	.xmit	= edsa_xmit,
 	.rcv	= edsa_rcv,
-	.flow_dissect   = edsa_tag_flow_dissect,
 	.overhead = EDSA_HLEN,
+	.proto_off = 3,
 };
 
 MODULE_LICENSE("GPL");
diff --git a/net/dsa/tag_gswip.c b/net/dsa/tag_gswip.c
index b678160bbd66..4161852d871d 100644
--- a/net/dsa/tag_gswip.c
+++ b/net/dsa/tag_gswip.c
@@ -109,6 +109,7 @@ static const struct dsa_device_ops gswip_netdev_ops = {
 	.xmit = gswip_tag_xmit,
 	.rcv = gswip_tag_rcv,
 	.overhead = GSWIP_RX_HEADER_LEN,
+	.proto_off = DSA_PROTO_OFF_UNSPEC,
 };
 
 MODULE_LICENSE("GPL");
diff --git a/net/dsa/tag_ksz.c b/net/dsa/tag_ksz.c
index 90d055c4df9e..4c9576201963 100644
--- a/net/dsa/tag_ksz.c
+++ b/net/dsa/tag_ksz.c
@@ -123,6 +123,7 @@ static const struct dsa_device_ops ksz8795_netdev_ops = {
 	.xmit	= ksz8795_xmit,
 	.rcv	= ksz8795_rcv,
 	.overhead = KSZ_INGRESS_TAG_LEN,
+	.proto_off = DSA_PROTO_OFF_UNSPEC,
 };
 
 DSA_TAG_DRIVER(ksz8795_netdev_ops);
@@ -198,6 +199,7 @@ static const struct dsa_device_ops ksz9477_netdev_ops = {
 	.xmit	= ksz9477_xmit,
 	.rcv	= ksz9477_rcv,
 	.overhead = KSZ9477_INGRESS_TAG_LEN,
+	.proto_off = DSA_PROTO_OFF_UNSPEC,
 };
 
 DSA_TAG_DRIVER(ksz9477_netdev_ops);
@@ -236,6 +238,7 @@ static const struct dsa_device_ops ksz9893_netdev_ops = {
 	.xmit	= ksz9893_xmit,
 	.rcv	= ksz9477_rcv,
 	.overhead = KSZ_INGRESS_TAG_LEN,
+	.proto_off = DSA_PROTO_OFF_UNSPEC,
 };
 
 DSA_TAG_DRIVER(ksz9893_netdev_ops);
diff --git a/net/dsa/tag_lan9303.c b/net/dsa/tag_lan9303.c
index eb0e7a32e53d..16cdc2e4c050 100644
--- a/net/dsa/tag_lan9303.c
+++ b/net/dsa/tag_lan9303.c
@@ -134,6 +134,7 @@ static const struct dsa_device_ops lan9303_netdev_ops = {
 	.xmit = lan9303_xmit,
 	.rcv = lan9303_rcv,
 	.overhead = LAN9303_TAG_LEN,
+	.proto_off = DSA_PROTO_OFF_UNSPEC,
 };
 
 MODULE_LICENSE("GPL");
diff --git a/net/dsa/tag_mtk.c b/net/dsa/tag_mtk.c
index b5705cba8318..c96354f12317 100644
--- a/net/dsa/tag_mtk.c
+++ b/net/dsa/tag_mtk.c
@@ -89,22 +89,13 @@ static struct sk_buff *mtk_tag_rcv(struct sk_buff *skb, struct net_device *dev,
 	return skb;
 }
 
-static int mtk_tag_flow_dissect(const struct sk_buff *skb, __be16 *proto,
-				int *offset)
-{
-	*offset = 4;
-	*proto = ((__be16 *)skb->data)[1];
-
-	return 0;
-}
-
 static const struct dsa_device_ops mtk_netdev_ops = {
 	.name		= "mtk",
 	.proto		= DSA_TAG_PROTO_MTK,
 	.xmit		= mtk_tag_xmit,
 	.rcv		= mtk_tag_rcv,
-	.flow_dissect	= mtk_tag_flow_dissect,
 	.overhead	= MTK_HDR_LEN,
+	.proto_off	= 1,
 };
 
 MODULE_LICENSE("GPL");
diff --git a/net/dsa/tag_ocelot.c b/net/dsa/tag_ocelot.c
index 8e3e7283d430..f9d9cc705caf 100644
--- a/net/dsa/tag_ocelot.c
+++ b/net/dsa/tag_ocelot.c
@@ -233,6 +233,7 @@ static struct dsa_device_ops ocelot_netdev_ops = {
 	.xmit			= ocelot_xmit,
 	.rcv			= ocelot_rcv,
 	.overhead		= OCELOT_TAG_LEN + OCELOT_LONG_PREFIX_LEN,
+	.proto_off		= DSA_PROTO_OFF_UNSPEC,
 };
 
 MODULE_LICENSE("GPL v2");
diff --git a/net/dsa/tag_qca.c b/net/dsa/tag_qca.c
index c95885215525..87cf2b9f78ea 100644
--- a/net/dsa/tag_qca.c
+++ b/net/dsa/tag_qca.c
@@ -90,22 +90,13 @@ static struct sk_buff *qca_tag_rcv(struct sk_buff *skb, struct net_device *dev,
 	return skb;
 }
 
-static int qca_tag_flow_dissect(const struct sk_buff *skb, __be16 *proto,
-                                int *offset)
-{
-	*offset = QCA_HDR_LEN;
-	*proto = ((__be16 *)skb->data)[0];
-
-	return 0;
-}
-
 static const struct dsa_device_ops qca_netdev_ops = {
 	.name	= "qca",
 	.proto	= DSA_TAG_PROTO_QCA,
 	.xmit	= qca_tag_xmit,
 	.rcv	= qca_tag_rcv,
-	.flow_dissect = qca_tag_flow_dissect,
 	.overhead = QCA_HDR_LEN,
+	.proto_off = 0,
 };
 
 MODULE_LICENSE("GPL");
diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index 63ef2a14c934..9be591186638 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -300,6 +300,7 @@ static struct dsa_device_ops sja1105_netdev_ops = {
 	.rcv = sja1105_rcv,
 	.filter = sja1105_filter,
 	.overhead = VLAN_HLEN,
+	.proto_off = DSA_PROTO_OFF_UNSPEC,
 };
 
 MODULE_LICENSE("GPL v2");
-- 
2.17.1

