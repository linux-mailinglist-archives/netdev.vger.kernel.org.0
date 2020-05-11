Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6D151CE549
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 22:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731644AbgEKUVF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 16:21:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731639AbgEKUVE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 16:21:04 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0305BC061A0C
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 13:21:04 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id n5so5939112wmd.0
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 13:21:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=XgrvFHBlyVCjUHEjV8Ov/RrMWZAxZtozBiAwsbt9CSM=;
        b=CBJp+6D0h8GSvD8timYI9dpjjD63i/Nhb27odaRR/6/M6/hCdDko6emepc8MqAD6gN
         AsrqGBeink05mP/CkCXdau30kysWFvyAKKE4xSTosp0YP2hxueh2S3u08FBSorYEGoeO
         VvHGcBDy4Zd2zP1Qac6/TygTNh/6yVHw42J3/VazCUHpGAuF795UN17zhtAg4kCxF1Ym
         mLsVpAu1lLQCNWTojBLiC6X+HEHEg5xIDQoT+HhGAF3VmQkmazAaqQU8eYjAiF03rAhA
         qZxhUyCq91s8gnHwATI2gcRZTjBpSQ54YnPu5MT6vTD4I3nUb0aozTAavdrLht6+QKvr
         xHaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=XgrvFHBlyVCjUHEjV8Ov/RrMWZAxZtozBiAwsbt9CSM=;
        b=PCOnh+dfXkhO7IFE1sdApT3oNaImoX69lYsJ2/dbdZvR+zEhxgT/ec8FlVZa/fBROP
         kXS9YaZyqnwe7V/06q0nMR5cjGOmO+K6dfFR2lTT/pNBBFn2cR0Xh/BsVZu+OuQtn7eI
         IvgAAnQYGdVmvynxDeOCs9qAbCgXxGaMD5uYiNrJ6rE0rTbAkmLknEbiRPPCcn2Df17U
         2yrFIM0iJeCvHu3V2ECo3cXwgzNxlAwodM4DeTKtLESBEzrKEpnlMYzfL5p1iuVTtefc
         ZJ6UbZuEEQlmRK8leMzhNczRYb05uE2faKXogb+VLB6rxT4u48hNGepaCtsx0LnEOs/J
         h7zA==
X-Gm-Message-State: AGi0PuZoLMQP8q1EFygJuF54aQ09rgeP5hd3RLgVjUr3hpWO1pPhn1Sp
        QJXy198rvktJsnZ9AKHpzyw=
X-Google-Smtp-Source: APiQypJX5+22+NpEmmNM0hAY2FTxGjFWWHYiNC9DsqOArlexRCRMIp/SIxeEva6pOi7tTOUAKn6jAw==
X-Received: by 2002:a1c:4e0a:: with SMTP id g10mr4236093wmh.75.1589228462683;
        Mon, 11 May 2020 13:21:02 -0700 (PDT)
Received: from localhost.localdomain ([86.121.118.29])
        by smtp.gmail.com with ESMTPSA id 77sm19811305wrc.6.2020.05.11.13.21.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2020 13:21:02 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 3/4] net: dsa: tag_ocelot: use a short prefix on both ingress and egress
Date:   Mon, 11 May 2020 23:20:45 +0300
Message-Id: <20200511202046.20515-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200511202046.20515-1-olteanv@gmail.com>
References: <20200511202046.20515-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

There are 2 goals that we follow:

- Reduce the header size
- Make the header size equal between RX and TX

The issue that required long prefix on RX was the fact that the ocelot
DSA tag, being put before Ethernet as it is, would overlap with the area
that a DSA master uses for RX filtering (destination MAC address
mainly).

Now that we can ask DSA to put the master in promiscuous mode, in theory
we could remove the prefix altogether and call it a day, but it looks
like we can't. Using no prefix on ingress, some packets (such as ICMP)
would be received, while others (such as PTP) would not be received.
This is because the DSA master we use (enetc) triggers parse errors
("MAC rx frame errors") presumably because it sees Ethernet frames with
a bad length. And indeed, when using no prefix, the EtherType (bytes
12-13 of the frame, bits 96-111) falls over the REW_VAL field from the
extraction header, aka the PTP timestamp.

When turning the short (32-bit) prefix on, the EtherType overlaps with
bits 64-79 of the extraction header, which are a reserved area
transmitted as zero by the switch. The packets are not dropped by the
DSA master with a short prefix. Actually, the frames look like this in
tcpdump (below is a PTP frame, with an extra dsa_8021q tag - dadb 0482 -
added by a downstream sja1105).

89:0c:a9:f2:01:00 > 88:80:00:0a:00:1d, 802.3, length 0: LLC, \
	dsap Unknown (0x10) Individual, ssap ProWay NM (0x0e) Response, \
	ctrl 0x0004: Information, send seq 2, rcv seq 0, \
	Flags [Response], length 78

0x0000:  8880 000a 001d 890c a9f2 0100 0000 100f  ................
0x0010:  0400 0000 0180 c200 000e 001f 7b63 0248  ............{c.H
0x0020:  dadb 0482 88f7 1202 0036 0000 0000 0000  .........6......
0x0030:  0000 0000 0000 0000 0000 001f 7bff fe63  ............{..c
0x0040:  0248 0001 1f81 0500 0000 0000 0000 0000  .H..............
0x0050:  0000 0000 0000 0000 0000 0000            ............

So the short prefix is our new default: we've shortened our RX frames by
12 octets, increased TX by 4, and headers are now equal between RX and
TX. Note that we still need promiscuous mode for the DSA master to not
drop it.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c |  5 +++--
 net/dsa/tag_ocelot.c           | 20 +++++++++++++++-----
 2 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index a2dfd73f8a1a..8b8d463223d5 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -545,8 +545,8 @@ static int felix_setup(struct dsa_switch *ds)
 		/* Bring up the CPU port module and configure the NPI port */
 		if (dsa_is_cpu_port(ds, port))
 			ocelot_configure_cpu(ocelot, port,
-					     OCELOT_TAG_PREFIX_NONE,
-					     OCELOT_TAG_PREFIX_LONG);
+					     OCELOT_TAG_PREFIX_SHORT,
+					     OCELOT_TAG_PREFIX_SHORT);
 	}
 
 	/* Include the CPU port module in the forwarding mask for unknown
@@ -564,6 +564,7 @@ static int felix_setup(struct dsa_switch *ds)
 				 ANA_FLOODING_FLD_UNICAST(PGID_UC),
 				 ANA_FLOODING, tc);
 
+	ds->promisc_on_master = true;
 	ds->mtu_enforcement_ingress = true;
 	/* It looks like the MAC/PCS interrupt register - PM0_IEVENT (0x8040)
 	 * isn't instantiated for the Felix PF.
diff --git a/net/dsa/tag_ocelot.c b/net/dsa/tag_ocelot.c
index 59de1315100f..778a7f34f8ec 100644
--- a/net/dsa/tag_ocelot.c
+++ b/net/dsa/tag_ocelot.c
@@ -5,6 +5,9 @@
 #include <linux/packing.h>
 #include "dsa_priv.h"
 
+#define OCELOT_PREFIX_VAL	0x8880000a
+#define OCELOT_TOTAL_TAG_LEN	(OCELOT_SHORT_PREFIX_LEN + OCELOT_TAG_LEN)
+
 /* The CPU injection header and the CPU extraction header can have 3 types of
  * prefixes: long, short and no prefix. The format of the header itself is the
  * same in all 3 cases.
@@ -143,8 +146,11 @@ static struct sk_buff *ocelot_xmit(struct sk_buff *skb,
 	struct ocelot *ocelot = ds->priv;
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
 	u8 *injection;
+	u32 *prefix;
+	int rc;
 
-	if (unlikely(skb_cow_head(skb, OCELOT_TAG_LEN) < 0)) {
+	rc = skb_cow_head(skb, OCELOT_TOTAL_TAG_LEN);
+	if (unlikely(rc < 0)) {
 		netdev_err(netdev, "Cannot make room for tag.\n");
 		return NULL;
 	}
@@ -174,6 +180,10 @@ static struct sk_buff *ocelot_xmit(struct sk_buff *skb,
 		packing(injection, &rew_op, 125, 117, OCELOT_TAG_LEN, PACK, 0);
 	}
 
+	prefix = skb_push(skb, OCELOT_SHORT_PREFIX_LEN);
+
+	*prefix = cpu_to_be32(OCELOT_PREFIX_VAL);
+
 	return skb;
 }
 
@@ -189,11 +199,11 @@ static struct sk_buff *ocelot_rcv(struct sk_buff *skb,
 	 * so it points to the beginning of the frame.
 	 */
 	skb_push(skb, ETH_HLEN);
-	/* We don't care about the long prefix, it is just for easy entrance
+	/* We don't care about the short prefix, it is just for easy entrance
 	 * into the DSA master's RX filter. Discard it now by moving it into
 	 * the headroom.
 	 */
-	skb_pull(skb, OCELOT_LONG_PREFIX_LEN);
+	skb_pull(skb, OCELOT_SHORT_PREFIX_LEN);
 	/* And skb->data now points to the extraction frame header.
 	 * Keep a pointer to it.
 	 */
@@ -207,7 +217,7 @@ static struct sk_buff *ocelot_rcv(struct sk_buff *skb,
 	skb_pull(skb, ETH_HLEN);
 
 	/* Remove from inet csum the extraction header */
-	skb_postpull_rcsum(skb, start, OCELOT_LONG_PREFIX_LEN + OCELOT_TAG_LEN);
+	skb_postpull_rcsum(skb, start, OCELOT_TOTAL_TAG_LEN);
 
 	packing(extraction, &src_port,  46, 43, OCELOT_TAG_LEN, UNPACK, 0);
 	packing(extraction, &qos_class, 19, 17, OCELOT_TAG_LEN, UNPACK, 0);
@@ -233,7 +243,7 @@ static struct dsa_device_ops ocelot_netdev_ops = {
 	.proto			= DSA_TAG_PROTO_OCELOT,
 	.xmit			= ocelot_xmit,
 	.rcv			= ocelot_rcv,
-	.overhead		= OCELOT_TAG_LEN + OCELOT_LONG_PREFIX_LEN,
+	.overhead		= OCELOT_TOTAL_TAG_LEN,
 };
 
 MODULE_LICENSE("GPL v2");
-- 
2.17.1

