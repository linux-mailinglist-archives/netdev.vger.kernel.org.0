Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19EE9218739
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 14:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729167AbgGHM0L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 08:26:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729147AbgGHM0I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 08:26:08 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4535EC08C5DC
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 05:26:08 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id r19so2949529ljn.12
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 05:26:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=syekLrJ/kMEkGwFeYVoTH9pZEdhSWnyepu5FFqs9cuc=;
        b=Ed5XcdJLBPVPjW+dW+0GN/W9akk/BWUXLaO0mBAOba7cq4mmkiSFA7giPYqysYhfIz
         yIpqRnPv4gJccJMmtoqa3ds/mfyac3I8uQa6K/wGmWHYeoK+ywlvzyYvalB/Vbs9N2WA
         mFWwcAVDI1JRtDnFwv0BaYguuXP/snd/kZ3YUTID+1uNF2UsEZmv3bm6zjAlFXJ6EiDl
         uwxQERyldA3Lpv70UZ0ZJR3Cc9cIjAE5IL+0Q42EaVs0mhlbOTIUK4Xu5sC6QzxBUBE9
         ELUILLRou8FP8fuWCcnFgyw6srR+fSggkYGRLtW3eezpcZJdNIymDDhrN/b4JR70oS1x
         tZhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=syekLrJ/kMEkGwFeYVoTH9pZEdhSWnyepu5FFqs9cuc=;
        b=F3OdUtUszz0yNjHPqf6FrdoeA8hNrf75Hgc6Z9KBfRltkRVNrJvPrWs0Qk13tf94qW
         rux9xInUQkTdHZw4xnMoWiEp20UumoSZ/i6P0ze2e0VLUqaG369c+uTMmBUgxvhIW6S7
         lUVBOhswEsM4Nj/iCMRZpAkDXr7ONhiq9u67XkUKyweBwsG8Smvz5OC0RzaKsO0Kx7tQ
         gnmJvfmdZgJTETKPtuEt4R6kGBFc7PNywIzfO8o1TvSfriqPwLQwLboUXeCqV4dFNoXu
         ziyAQOymsB2/XHgrGtNEbmtQN2zF7JmNMoyZVkcN1gTNaNZ2IT2qQJc1G16Kk3MMWTnN
         vLGA==
X-Gm-Message-State: AOAM5312ISAsPYnFRuG3AELuU3hBh9UOUDYwqw5YB7L/NO72IY50dc9X
        sq6QsozH5JDOOvSQPFrsu6OLTg==
X-Google-Smtp-Source: ABdhPJzYOIhmJVcNrWlri3hLju11ld+l43XzvOQ0HwLl3QfG9gcE6sGm27Iy2iJH/BlNGpQUFw3ijg==
X-Received: by 2002:a2e:8187:: with SMTP id e7mr27806626ljg.308.1594211166631;
        Wed, 08 Jul 2020 05:26:06 -0700 (PDT)
Received: from localhost.bredbandsbolaget (c-92d7225c.014-348-6c756e10.bbcust.telenor.se. [92.34.215.146])
        by smtp.gmail.com with ESMTPSA id q128sm874934ljb.140.2020.07.08.05.26.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 05:26:05 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Mauri Sandberg <sandberg@mailfence.com>
Subject: [net-next PATCH 1/2 v6] net: dsa: tag_rtl4_a: Implement Realtek 4 byte A tag
Date:   Wed,  8 Jul 2020 14:25:36 +0200
Message-Id: <20200708122537.1341307-2-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200708122537.1341307-1-linus.walleij@linaro.org>
References: <20200708122537.1341307-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This implements the known parts of the Realtek 4 byte
tag protocol version 0xA, as found in the RTL8366RB
DSA switch.

It is designated as protocol version 0xA as a
different Realtek 4 byte tag format with protocol
version 0x9 is known to exist in the Realtek RTL8306
chips.

The tag and switch chip lacks public documentation, so
the tag format has been reverse-engineered from
packet dumps. As only ingress traffic has been available
for analysis an egress tag has not been possible to
develop (even using educated guesses about bit fields)
so this is as far as it gets. It is not known if the
switch even supports egress tagging.

Excessive attempts to figure out the egress tag format
was made. When nothing else worked, I just tried all bit
combinations with 0xannp where a is protocol and p is
port. I looped through all values several times trying
to get a response from ping, without any positive
result.

Using just these ingress tags however, the switch
functionality is vastly improved and the packets find
their way into the destination port without any
tricky VLAN configuration. On the D-Link DIR-685 the
LAN ports now come up and respond to ping without
any command line configuration so this is a real
improvement for users.

Egress packets need to be restricted to the proper
target ports using VLAN, which the RTL8366RB DSA
switch driver already sets up.

Cc: DENG Qingfang <dqfext@gmail.com>
Cc: Mauri Sandberg <sandberg@mailfence.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v5->v6:
- Fix the lookup for port on incoming packets to be
  done before any packet rewrite happens so we don't
  waste cycles.
- Collect Florian's review tag.
ChangeLog v4->v5:
- Split tagging support from the VLAN fix-ups.
ChangeLog v3->v4:
- Drop an unused variable found with -Wunused-variable
ChangeLog v2->v3:
- Collect Andrew's review tag.
ChangeLog v1->v2:
- Drop some netdev_dbg() calls that was just littering.
- Rebase on v5.8-rc1
---
 include/net/dsa.h    |   2 +
 net/dsa/Kconfig      |   7 +++
 net/dsa/Makefile     |   1 +
 net/dsa/tag_rtl4_a.c | 130 +++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 140 insertions(+)
 create mode 100644 net/dsa/tag_rtl4_a.c

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 50389772c597..2b37943f09a4 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -44,6 +44,7 @@ struct phylink_link_state;
 #define DSA_TAG_PROTO_KSZ8795_VALUE		14
 #define DSA_TAG_PROTO_OCELOT_VALUE		15
 #define DSA_TAG_PROTO_AR9331_VALUE		16
+#define DSA_TAG_PROTO_RTL4_A_VALUE		17
 
 enum dsa_tag_protocol {
 	DSA_TAG_PROTO_NONE		= DSA_TAG_PROTO_NONE_VALUE,
@@ -63,6 +64,7 @@ enum dsa_tag_protocol {
 	DSA_TAG_PROTO_KSZ8795		= DSA_TAG_PROTO_KSZ8795_VALUE,
 	DSA_TAG_PROTO_OCELOT		= DSA_TAG_PROTO_OCELOT_VALUE,
 	DSA_TAG_PROTO_AR9331		= DSA_TAG_PROTO_AR9331_VALUE,
+	DSA_TAG_PROTO_RTL4_A		= DSA_TAG_PROTO_RTL4_A_VALUE,
 };
 
 struct packet_type;
diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
index d5bc6ac599ef..1f9b9b11008c 100644
--- a/net/dsa/Kconfig
+++ b/net/dsa/Kconfig
@@ -86,6 +86,13 @@ config NET_DSA_TAG_KSZ
 	  Say Y if you want to enable support for tagging frames for the
 	  Microchip 8795/9477/9893 families of switches.
 
+config NET_DSA_TAG_RTL4_A
+	tristate "Tag driver for Realtek 4 byte protocol A tags"
+	help
+	  Say Y or M if you want to enable support for tagging frames for the
+	  Realtek switches with 4 byte protocol A tags, sich as found in
+	  the Realtek RTL8366RB.
+
 config NET_DSA_TAG_OCELOT
 	tristate "Tag driver for Ocelot family of switches"
 	select PACKING
diff --git a/net/dsa/Makefile b/net/dsa/Makefile
index 108486cfdeef..4f47b2025ff5 100644
--- a/net/dsa/Makefile
+++ b/net/dsa/Makefile
@@ -11,6 +11,7 @@ obj-$(CONFIG_NET_DSA_TAG_DSA) += tag_dsa.o
 obj-$(CONFIG_NET_DSA_TAG_EDSA) += tag_edsa.o
 obj-$(CONFIG_NET_DSA_TAG_GSWIP) += tag_gswip.o
 obj-$(CONFIG_NET_DSA_TAG_KSZ) += tag_ksz.o
+obj-$(CONFIG_NET_DSA_TAG_RTL4_A) += tag_rtl4_a.o
 obj-$(CONFIG_NET_DSA_TAG_LAN9303) += tag_lan9303.o
 obj-$(CONFIG_NET_DSA_TAG_MTK) += tag_mtk.o
 obj-$(CONFIG_NET_DSA_TAG_OCELOT) += tag_ocelot.o
diff --git a/net/dsa/tag_rtl4_a.c b/net/dsa/tag_rtl4_a.c
new file mode 100644
index 000000000000..7b63010fa87b
--- /dev/null
+++ b/net/dsa/tag_rtl4_a.c
@@ -0,0 +1,130 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Handler for Realtek 4 byte DSA switch tags
+ * Currently only supports protocol "A" found in RTL8366RB
+ * Copyright (c) 2020 Linus Walleij <linus.walleij@linaro.org>
+ *
+ * This "proprietary tag" header looks like so:
+ *
+ * -------------------------------------------------
+ * | MAC DA | MAC SA | 0x8899 | 2 bytes tag | Type |
+ * -------------------------------------------------
+ *
+ * The 2 bytes tag form a 16 bit big endian word. The exact
+ * meaning has been guessed from packet dumps from ingress
+ * frames, as no working egress traffic has been available
+ * we do not know the format of the egress tags or if they
+ * are even supported.
+ */
+
+#include <linux/etherdevice.h>
+#include <linux/bits.h>
+
+#include "dsa_priv.h"
+
+#define RTL4_A_HDR_LEN		4
+#define RTL4_A_ETHERTYPE	0x8899
+#define RTL4_A_PROTOCOL_SHIFT	12
+/*
+ * 0x1 = Realtek Remote Control protocol (RRCP)
+ * 0x2/0x3 seems to be used for loopback testing
+ * 0x9 = RTL8306 DSA protocol
+ * 0xa = RTL8366RB DSA protocol
+ */
+#define RTL4_A_PROTOCOL_RTL8366RB	0xa
+
+static struct sk_buff *rtl4a_tag_xmit(struct sk_buff *skb,
+				      struct net_device *dev)
+{
+	/*
+	 * Just let it pass thru, we don't know if it is possible
+	 * to tag a frame with the 0x8899 ethertype and direct it
+	 * to a specific port, all attempts at reverse-engineering have
+	 * ended up with the frames getting dropped.
+	 *
+	 * The VLAN set-up needs to restrict the frames to the right port.
+	 *
+	 * If you have documentation on the tagging format for RTL8366RB
+	 * (tag type A) then please contribute.
+	 */
+	return skb;
+}
+
+static struct sk_buff *rtl4a_tag_rcv(struct sk_buff *skb,
+				     struct net_device *dev,
+				     struct packet_type *pt)
+{
+	u16 protport;
+	__be16 *p;
+	u16 etype;
+	u8 *tag;
+	u8 prot;
+	u8 port;
+
+	if (unlikely(!pskb_may_pull(skb, RTL4_A_HDR_LEN)))
+		return NULL;
+
+	/* The RTL4 header has its own custom Ethertype 0x8899 and that
+	 * starts right at the beginning of the packet, after the src
+	 * ethernet addr. Apparantly skb->data always points 2 bytes in,
+	 * behind the Ethertype.
+	 */
+	tag = skb->data - 2;
+	p = (__be16 *)tag;
+	etype = ntohs(*p);
+	if (etype != RTL4_A_ETHERTYPE) {
+		/* Not custom, just pass through */
+		netdev_dbg(dev, "non-realtek ethertype 0x%04x\n", etype);
+		return skb;
+	}
+	p = (__be16 *)(tag + 2);
+	protport = ntohs(*p);
+	/* The 4 upper bits are the protocol */
+	prot = (protport >> RTL4_A_PROTOCOL_SHIFT) & 0x0f;
+	if (prot != RTL4_A_PROTOCOL_RTL8366RB) {
+		netdev_err(dev, "unknown realtek protocol 0x%01x\n", prot);
+		return NULL;
+	}
+	port = protport & 0xff;
+
+	skb->dev = dsa_master_find_slave(dev, 0, port);
+	if (!skb->dev) {
+		netdev_dbg(dev, "could not find slave for port %d\n", port);
+		return NULL;
+	}
+
+	/* Remove RTL4 tag and recalculate checksum */
+	skb_pull_rcsum(skb, RTL4_A_HDR_LEN);
+
+	/* Move ethernet DA and SA in front of the data */
+	memmove(skb->data - ETH_HLEN,
+		skb->data - ETH_HLEN - RTL4_A_HDR_LEN,
+		2 * ETH_ALEN);
+
+	skb->offload_fwd_mark = 1;
+
+	return skb;
+}
+
+static int rtl4a_tag_flow_dissect(const struct sk_buff *skb, __be16 *proto,
+				  int *offset)
+{
+	*offset = RTL4_A_HDR_LEN;
+	/* Skip past the tag and fetch the encapsulated Ethertype */
+	*proto = ((__be16 *)skb->data)[1];
+
+	return 0;
+}
+
+static const struct dsa_device_ops rtl4a_netdev_ops = {
+	.name	= "rtl4a",
+	.proto	= DSA_TAG_PROTO_RTL4_A,
+	.xmit	= rtl4a_tag_xmit,
+	.rcv	= rtl4a_tag_rcv,
+	.flow_dissect = rtl4a_tag_flow_dissect,
+	.overhead = RTL4_A_HDR_LEN,
+};
+module_dsa_tag_driver(rtl4a_netdev_ops);
+
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_RTL4_A);
-- 
2.26.2

