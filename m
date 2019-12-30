Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18D1812D3D7
	for <lists+netdev@lfdr.de>; Mon, 30 Dec 2019 20:21:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727669AbfL3TVt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Dec 2019 14:21:49 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:33147 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727278AbfL3TVs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Dec 2019 14:21:48 -0500
Received: by mail-pj1-f68.google.com with SMTP id u63so190827pjb.0;
        Mon, 30 Dec 2019 11:21:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=l3p+J+NMA4RacixDQSVQdCBbSfVRvmkFA8N8sAMaHR0=;
        b=lKt2P/F16WRytsC4P82G59gXvnKuyL5Xmb3uEboalC0aL7L7K0XGHtA8ztMt4QE5nB
         +XnKPtvtxDo6DFwL+94MA3QJG5bo8J85Ixh8lpREUFDHB6quXMAf/pezv4RoDJjynuyO
         GCKgR7hDapsdnqUg8GIy5CkHdDPL2AM+8F3i/rWRkr0YQziR9Ja1jYZu9UuhMoCqsT2X
         mUjBhdcAJO5pCjW3rsYoZ/czVPwmUfWu5mUUqg+VakyPei+vugp93abK3sj4TXHEVdie
         yjmw7HctR285DnWcfU5RfEH86IT9cj/jn6txcn/k/IaOCTmJn8QCvbrVYAs9pTyZ8xgo
         dkFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=l3p+J+NMA4RacixDQSVQdCBbSfVRvmkFA8N8sAMaHR0=;
        b=M0DOZRzZmIH0Y1MnEUcLFxDXcxNNXbH1TpASiYVwaC6fk4OEAKJVVwNEwqcHfcK0oq
         l130oOASvofHZ1DoUdl1PxjhCKsvSFIFVQw9aNTISc/qpUhjbQZYQAxkKgck8vAZu8Cw
         ejaZD6E9IKm8qYYXu5UN8w9tL5g2Ow9Apzgsxzdx85408jrYPf89N3Ij5GLjgEm+d8N4
         3ogadTbO80CR0SVLr4ysEAUB+2Eh5QXHefyL96eUbX1kMeTkru0qZp8lj/GZmV75Ja4k
         0iG6pxgVYn4kdpsCmABUxy2dpF4EF9uPP9tVZDmHIRLS8s9//SKeY/LwpSIz8Ohcy3Cx
         YRwA==
X-Gm-Message-State: APjAAAXPNSrhpslTeT5h7+PDwKynbnsspycMHNFSKqRfOtadfmw4ByvL
        hS3gizU2v+/Q0T9dLj9lTJIDxo84
X-Google-Smtp-Source: APXvYqw84MQhflqquwmqg25ne2SB0uiY4DhKbvkO8v/WKGdmQyhKZ//nObXAwT8l91fvuauMS5Gs/w==
X-Received: by 2002:a17:90a:20c4:: with SMTP id f62mr911488pjg.70.1577733707609;
        Mon, 30 Dec 2019 11:21:47 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h3sm53392631pfr.15.2019.12.30.11.21.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Dec 2019 11:21:46 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     alobakin@dlink.ru, Florian Fainelli <f.fainelli@gmail.com>,
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
Subject: [RFC net-next v2] net: dsa: Remove indirect function call for flow dissection
Date:   Mon, 30 Dec 2019 11:20:22 -0800
Message-Id: <20191230192025.14567-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We only need "static" information to be given for DSA flow dissection,
so replace the expensive call to .flow_dissect() with an integer given
us the offset into the packet that we must de-reference to obtain the
protocol number. The overhead was alreayd available from the
dsa_device_ops structure so use that directly.

The presence of a flow_dissect callback used to indicate that the DSA
tagger supported returning that information,we now encode this with a
negative proto_off if the tagger does not support providing that
information.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v2:

- update all taggers to indicate a valid/invalid protocol offset where
  applicable

 include/net/dsa.h         |  3 +--
 net/core/flow_dissector.c | 14 +++++++++-----
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
 12 files changed, 23 insertions(+), 45 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index da5578db228e..fc656cf3e3dd 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -72,14 +72,13 @@ struct dsa_device_ops {
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
index 2dbbb030fbed..942218943010 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -972,13 +972,17 @@ bool __skb_flow_dissect(const struct net *net,
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
+			if (likely(overhead && proto_off >= 0 &&
+				   proto_off < skb->len)) {
+				hlen -= overhead;
+				nhoff += overhead;
+				proto = ((__be16 *)skb->data)[proto_off];
 			}
 		}
 #endif
diff --git a/net/dsa/tag_brcm.c b/net/dsa/tag_brcm.c
index 9c3114179690..5b4c5bbba2cc 100644
--- a/net/dsa/tag_brcm.c
+++ b/net/dsa/tag_brcm.c
@@ -177,6 +177,7 @@ static const struct dsa_device_ops brcm_netdev_ops = {
 	.xmit	= brcm_tag_xmit,
 	.rcv	= brcm_tag_rcv,
 	.overhead = BRCM_TAG_LEN,
+	.proto_off = -1,
 };
 
 DSA_TAG_DRIVER(brcm_netdev_ops);
@@ -205,6 +206,7 @@ static const struct dsa_device_ops brcm_prepend_netdev_ops = {
 	.xmit	= brcm_tag_xmit_prepend,
 	.rcv	= brcm_tag_rcv_prepend,
 	.overhead = BRCM_TAG_LEN,
+	.proto_off = -1,
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
index b678160bbd66..646453c3ef44 100644
--- a/net/dsa/tag_gswip.c
+++ b/net/dsa/tag_gswip.c
@@ -109,6 +109,7 @@ static const struct dsa_device_ops gswip_netdev_ops = {
 	.xmit = gswip_tag_xmit,
 	.rcv = gswip_tag_rcv,
 	.overhead = GSWIP_RX_HEADER_LEN,
+	.proto_off = -1,
 };
 
 MODULE_LICENSE("GPL");
diff --git a/net/dsa/tag_ksz.c b/net/dsa/tag_ksz.c
index 90d055c4df9e..ab42d8ddeade 100644
--- a/net/dsa/tag_ksz.c
+++ b/net/dsa/tag_ksz.c
@@ -123,6 +123,7 @@ static const struct dsa_device_ops ksz8795_netdev_ops = {
 	.xmit	= ksz8795_xmit,
 	.rcv	= ksz8795_rcv,
 	.overhead = KSZ_INGRESS_TAG_LEN,
+	.proto_off = -1,
 };
 
 DSA_TAG_DRIVER(ksz8795_netdev_ops);
@@ -198,6 +199,7 @@ static const struct dsa_device_ops ksz9477_netdev_ops = {
 	.xmit	= ksz9477_xmit,
 	.rcv	= ksz9477_rcv,
 	.overhead = KSZ9477_INGRESS_TAG_LEN,
+	.proto_off = -1,
 };
 
 DSA_TAG_DRIVER(ksz9477_netdev_ops);
@@ -236,6 +238,7 @@ static const struct dsa_device_ops ksz9893_netdev_ops = {
 	.xmit	= ksz9893_xmit,
 	.rcv	= ksz9477_rcv,
 	.overhead = KSZ_INGRESS_TAG_LEN,
+	.proto_off = -1,
 };
 
 DSA_TAG_DRIVER(ksz9893_netdev_ops);
diff --git a/net/dsa/tag_lan9303.c b/net/dsa/tag_lan9303.c
index eb0e7a32e53d..709abf0ab6be 100644
--- a/net/dsa/tag_lan9303.c
+++ b/net/dsa/tag_lan9303.c
@@ -134,6 +134,7 @@ static const struct dsa_device_ops lan9303_netdev_ops = {
 	.xmit = lan9303_xmit,
 	.rcv = lan9303_rcv,
 	.overhead = LAN9303_TAG_LEN,
+	.proto_off = -1,
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
index 8e3e7283d430..d29e86c66853 100644
--- a/net/dsa/tag_ocelot.c
+++ b/net/dsa/tag_ocelot.c
@@ -233,6 +233,7 @@ static struct dsa_device_ops ocelot_netdev_ops = {
 	.xmit			= ocelot_xmit,
 	.rcv			= ocelot_rcv,
 	.overhead		= OCELOT_TAG_LEN + OCELOT_LONG_PREFIX_LEN,
+	.proto_off		= -1,
 };
 
 MODULE_LICENSE("GPL v2");
diff --git a/net/dsa/tag_qca.c b/net/dsa/tag_qca.c
index c95885215525..a88849d211f0 100644
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
+	.proto_offset = 0,
 };
 
 MODULE_LICENSE("GPL");
diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index 63ef2a14c934..626d3476c6af 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -300,6 +300,7 @@ static struct dsa_device_ops sja1105_netdev_ops = {
 	.rcv = sja1105_rcv,
 	.filter = sja1105_filter,
 	.overhead = VLAN_HLEN,
+	.proto_off = -1,
 };
 
 MODULE_LICENSE("GPL v2");
-- 
2.17.1

