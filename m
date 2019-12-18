Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D23C124C55
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 17:01:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbfLRQBv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 11:01:51 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:43581 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726980AbfLRQBu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 11:01:50 -0500
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1ihblk-00040v-U4; Wed, 18 Dec 2019 17:01:48 +0100
Received: from mgr by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1ihblj-00072X-5g; Wed, 18 Dec 2019 17:01:47 +0100
From:   Michael Grzeschik <m.grzeschik@pengutronix.de>
To:     andrew@lunn.ch
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kernel@pengutronix.de
Subject: [PATCH] net: dsa: ksz: use common define for tag len
Date:   Wed, 18 Dec 2019 17:01:39 +0100
Message-Id: <20191218160139.26972-1-m.grzeschik@pengutronix.de>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: mgr@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove special taglen define KSZ8795_INGRESS_TAG_LEN
and use generic KSZ_INGRESS_TAG_LEN instead.

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
---
 net/dsa/tag_ksz.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/dsa/tag_ksz.c b/net/dsa/tag_ksz.c
index 3e63a9426633f..efdcbe2f29ae7 100644
--- a/net/dsa/tag_ksz.c
+++ b/net/dsa/tag_ksz.c
@@ -84,8 +84,6 @@ static struct sk_buff *ksz_common_rcv(struct sk_buff *skb,
  *	  (eg, 0x00=port1, 0x02=port3, 0x06=port7)
  */
 
-#define KSZ8795_INGRESS_TAG_LEN		1
-
 #define KSZ8795_TAIL_TAG_OVERRIDE	BIT(6)
 #define KSZ8795_TAIL_TAG_LOOKUP		BIT(7)
 
@@ -96,12 +94,12 @@ static struct sk_buff *ksz8795_xmit(struct sk_buff *skb, struct net_device *dev)
 	u8 *tag;
 	u8 *addr;
 
-	nskb = ksz_common_xmit(skb, dev, KSZ8795_INGRESS_TAG_LEN);
+	nskb = ksz_common_xmit(skb, dev, KSZ_INGRESS_TAG_LEN);
 	if (!nskb)
 		return NULL;
 
 	/* Tag encoding */
-	tag = skb_put(nskb, KSZ8795_INGRESS_TAG_LEN);
+	tag = skb_put(nskb, KSZ_INGRESS_TAG_LEN);
 	addr = skb_mac_header(nskb);
 
 	*tag = 1 << dp->index;
@@ -124,7 +122,7 @@ static const struct dsa_device_ops ksz8795_netdev_ops = {
 	.proto	= DSA_TAG_PROTO_KSZ8795,
 	.xmit	= ksz8795_xmit,
 	.rcv	= ksz8795_rcv,
-	.overhead = KSZ8795_INGRESS_TAG_LEN,
+	.overhead = KSZ_INGRESS_TAG_LEN,
 };
 
 DSA_TAG_DRIVER(ksz8795_netdev_ops);
-- 
2.24.0

