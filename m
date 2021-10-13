Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 999E142C3FA
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 16:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237834AbhJMOxL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 10:53:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237704AbhJMOxG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 10:53:06 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5477EC061753
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 07:51:02 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id z20so11338505edc.13
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 07:51:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pqrs.dk; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DvxPpI1QqpuFFFdv0VSJDe/ExW+UqbSq25EgmJVcWnU=;
        b=lVYRsysQt8XKcMAoGgFaoP8rijTG+L0C3UuwqlUL6nK0tBUWpbnvtLp9lLUMFH0JGq
         PX68MSWA4HrcF/YP2JQPolVrmv41JUPtDXit00iGNxkPjsuRfi6fhpmqoqugKn87T7as
         zXyCnkZiSlQG5UPZk2rNlfDHl+7dzSuXK95Lo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DvxPpI1QqpuFFFdv0VSJDe/ExW+UqbSq25EgmJVcWnU=;
        b=GfSpjb6j/Snph7F3V7dSP9zyJhy2wGlCbf3t1jz4m72fF9s5CTGOnlbo6YalTHwXMw
         l86ydhPZtbNJY4u0ownp1YiT7QHukzLIY8rglNXjxCE+BFNjGXk4YeuOqKWIaMOQK0d+
         KQ8MuNyX+hz164IxGaeBzuDap00tAYi6aZLT4gfGdCpsUKMD8dBRin9COZ0J6I7yDMag
         MFFfTvkPkjdXq9wxfW4HiOQwHjgZG8Ygg3Rx+mP8VuxPIgza9TODd2MnCpIlLl9zfIIZ
         WbkwLXE44v5xiwFL+FgrW2w9Ne5dn6MlKjjywZFxKVQKqDuuJqMEYIUFUR6dbGw/xTLM
         rdxQ==
X-Gm-Message-State: AOAM530Hf/+trST8drxlI7oHIVcNwoi5cjK2h+z1l0MuPsUueQxBH6j1
        LzlKiYk8XtT8t31VRtoNuZGhkQ==
X-Google-Smtp-Source: ABdhPJzoYfwMiNfOX1iLHGYJWF5dA+zcUlq6AYClDvHogdjI8sdj5GBXaPxMgbTzex0oVfXr9MUlqw==
X-Received: by 2002:a50:bf08:: with SMTP id f8mr10022636edk.400.1634136660570;
        Wed, 13 Oct 2021 07:51:00 -0700 (PDT)
Received: from capella.. (27-reverse.bang-olufsen.dk. [193.89.194.27])
        by smtp.gmail.com with ESMTPSA id nd22sm7535098ejc.98.2021.10.13.07.50.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 07:51:00 -0700 (PDT)
From:   =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alvin@pqrs.dk>
To:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next 4/6] net: dsa: tag_rtl8_4: add realtek 8 byte protocol 4 tag
Date:   Wed, 13 Oct 2021 16:50:36 +0200
Message-Id: <20211013145040.886956-5-alvin@pqrs.dk>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211013145040.886956-1-alvin@pqrs.dk>
References: <20211013145040.886956-1-alvin@pqrs.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alvin Šipraga <alsi@bang-olufsen.dk>

This commit implements a basic version of the 8 byte tag protocol used
in the Realtek RTL8365MB-VC unmanaged switch, which carries with it a
protocol version of 0x04.

The implementation itself only handles the parsing of the EtherType
value and Realtek protocol version, together with the source or
destination port fields. The rest is left unimplemented for now.

The tag format is described in a confidential document provided to my
company by Realtek Semiconductor Corp. Permission has been granted by
the vendor to publish this driver based on that material, together with
an extract from the document describing the tag format and its fields.
It is hoped that this will help future implementors who do not have
access to the material but who wish to extend the functionality of
drivers for chips which use this protocol.

In addition, two possible values of the REASON field are specified,
based on experiments on my end. Realtek does not specify what value this
field can take.

Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
---

v1 -> v2:
  - collect Reviewed-by from Vladimir and Linus
  - don't set default fwd_offload_mark if packet is trapped to CPU
  - use #defines and FIELD_* macros to make Linus happy

RFC -> v1:
  - minor changes to the big comment at the top, including some
    empirical information about the REASON code
  - use dev_*_ratelimited() instead of netdev_*() for logging
  - use warning instead of debug messages
  - use ETH_P_REALTEK from if_ether.h
  - set LEARN_DIS on xmit
  - remove superfluous variables/expressions and use __b16 for tag
    variable
  - use new helper functions to insert/remove CPU tag
  - set offload_fwd_mark properly using helper function

 include/net/dsa.h    |   2 +
 net/dsa/Kconfig      |   6 ++
 net/dsa/Makefile     |   1 +
 net/dsa/tag_rtl8_4.c | 184 +++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 193 insertions(+)
 create mode 100644 net/dsa/tag_rtl8_4.c

diff --git a/include/net/dsa.h b/include/net/dsa.h
index d784e76113b8..783060e851a9 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -51,6 +51,7 @@ struct phylink_link_state;
 #define DSA_TAG_PROTO_SEVILLE_VALUE		21
 #define DSA_TAG_PROTO_BRCM_LEGACY_VALUE		22
 #define DSA_TAG_PROTO_SJA1110_VALUE		23
+#define DSA_TAG_PROTO_RTL8_4_VALUE		24
 
 enum dsa_tag_protocol {
 	DSA_TAG_PROTO_NONE		= DSA_TAG_PROTO_NONE_VALUE,
@@ -77,6 +78,7 @@ enum dsa_tag_protocol {
 	DSA_TAG_PROTO_OCELOT_8021Q	= DSA_TAG_PROTO_OCELOT_8021Q_VALUE,
 	DSA_TAG_PROTO_SEVILLE		= DSA_TAG_PROTO_SEVILLE_VALUE,
 	DSA_TAG_PROTO_SJA1110		= DSA_TAG_PROTO_SJA1110_VALUE,
+	DSA_TAG_PROTO_RTL8_4		= DSA_TAG_PROTO_RTL8_4_VALUE,
 };
 
 struct dsa_switch;
diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
index 6c7f79e45886..57fc52b17d55 100644
--- a/net/dsa/Kconfig
+++ b/net/dsa/Kconfig
@@ -130,6 +130,12 @@ config NET_DSA_TAG_RTL4_A
 	  Realtek switches with 4 byte protocol A tags, sich as found in
 	  the Realtek RTL8366RB.
 
+config NET_DSA_TAG_RTL8_4
+	tristate "Tag driver for Realtek 8 byte protocol 4 tags"
+	help
+	  Say Y or M if you want to enable support for tagging frames for Realtek
+	  switches with 8 byte protocol 4 tags, such as the Realtek RTL8365MB-VC.
+
 config NET_DSA_TAG_LAN9303
 	tristate "Tag driver for SMSC/Microchip LAN9303 family of switches"
 	help
diff --git a/net/dsa/Makefile b/net/dsa/Makefile
index f78d537044db..9f75820e7c98 100644
--- a/net/dsa/Makefile
+++ b/net/dsa/Makefile
@@ -16,6 +16,7 @@ obj-$(CONFIG_NET_DSA_TAG_OCELOT) += tag_ocelot.o
 obj-$(CONFIG_NET_DSA_TAG_OCELOT_8021Q) += tag_ocelot_8021q.o
 obj-$(CONFIG_NET_DSA_TAG_QCA) += tag_qca.o
 obj-$(CONFIG_NET_DSA_TAG_RTL4_A) += tag_rtl4_a.o
+obj-$(CONFIG_NET_DSA_TAG_RTL8_4) += tag_rtl8_4.o
 obj-$(CONFIG_NET_DSA_TAG_SJA1105) += tag_sja1105.o
 obj-$(CONFIG_NET_DSA_TAG_TRAILER) += tag_trailer.o
 obj-$(CONFIG_NET_DSA_TAG_XRS700X) += tag_xrs700x.o
diff --git a/net/dsa/tag_rtl8_4.c b/net/dsa/tag_rtl8_4.c
new file mode 100644
index 000000000000..8dbdefe47289
--- /dev/null
+++ b/net/dsa/tag_rtl8_4.c
@@ -0,0 +1,184 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Handler for Realtek 8 byte switch tags
+ *
+ * Copyright (C) 2021 Alvin Šipraga <alsi@bang-olufsen.dk>
+ *
+ * NOTE: Currently only supports protocol "4" found in the RTL8365MB, hence
+ * named tag_rtl8_4.
+ *
+ * This tag header has the following format:
+ *
+ *  -------------------------------------------
+ *  | MAC DA | MAC SA | 8 byte tag | Type | ...
+ *  -------------------------------------------
+ *     _______________/            \______________________________________
+ *    /                                                                   \
+ *  0                                  7|8                                 15
+ *  |-----------------------------------+-----------------------------------|---
+ *  |                               (16-bit)                                | ^
+ *  |                       Realtek EtherType [0x8899]                      | |
+ *  |-----------------------------------+-----------------------------------| 8
+ *  |              (8-bit)              |              (8-bit)              |
+ *  |          Protocol [0x04]          |              REASON               | b
+ *  |-----------------------------------+-----------------------------------| y
+ *  |   (1)  | (1) | (2) |   (1)  | (3) | (1)  | (1) |    (1)    |   (5)    | t
+ *  | FID_EN |  X  | FID | PRI_EN | PRI | KEEP |  X  | LEARN_DIS |    X     | e
+ *  |-----------------------------------+-----------------------------------| s
+ *  |   (1)  |                       (15-bit)                               | |
+ *  |  ALLOW |                        TX/RX                                 | v
+ *  |-----------------------------------+-----------------------------------|---
+ *
+ * With the following field descriptions:
+ *
+ *    field      | description
+ *   ------------+-------------
+ *    Realtek    | 0x8899: indicates that this is a proprietary Realtek tag;
+ *     EtherType |         note that Realtek uses the same EtherType for
+ *               |         other incompatible tag formats (e.g. tag_rtl4_a.c)
+ *    Protocol   | 0x04: indicates that this tag conforms to this format
+ *    X          | reserved
+ *   ------------+-------------
+ *    REASON     | reason for forwarding packet to CPU
+ *               | 0: packet was forwarded or flooded to CPU
+ *               | 80: packet was trapped to CPU
+ *    FID_EN     | 1: packet has an FID
+ *               | 0: no FID
+ *    FID        | FID of packet (if FID_EN=1)
+ *    PRI_EN     | 1: force priority of packet
+ *               | 0: don't force priority
+ *    PRI        | priority of packet (if PRI_EN=1)
+ *    KEEP       | preserve packet VLAN tag format
+ *    LEARN_DIS  | don't learn the source MAC address of the packet
+ *    ALLOW      | 1: treat TX/RX field as an allowance port mask, meaning the
+ *               |    packet may only be forwarded to ports specified in the
+ *               |    mask
+ *               | 0: no allowance port mask, TX/RX field is the forwarding
+ *               |    port mask
+ *    TX/RX      | TX (switch->CPU): port number the packet was received on
+ *               | RX (CPU->switch): forwarding port mask (if ALLOW=0)
+ *               |                   allowance port mask (if ALLOW=1)
+ */
+
+#include <linux/bits.h>
+#include <linux/etherdevice.h>
+
+#include "dsa_priv.h"
+
+/* Protocols supported:
+ *
+ * 0x04 = RTL8365MB DSA protocol
+ */
+
+#define RTL8_4_TAG_LEN			8
+
+#define RTL8_4_PROTOCOL			GENMASK(15, 8)
+#define   RTL8_4_PROTOCOL_RTL8365MB	0x04
+#define RTL8_4_REASON			GENMASK(7, 0)
+#define   RTL8_4_REASON_FORWARD		0
+#define   RTL8_4_REASON_TRAP		80
+
+#define RTL8_4_LEARN_DIS		BIT(5)
+
+#define RTL8_4_TX			GENMASK(3, 0)
+#define RTL8_4_RX			GENMASK(10, 0)
+
+static struct sk_buff *rtl8_4_tag_xmit(struct sk_buff *skb,
+				       struct net_device *dev)
+{
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	__be16 *tag;
+
+	/* Pad out so the (stripped) packet is at least 64 bytes long
+	 * (including FCS), otherwise the switch will drop the packet.
+	 * Then we need an additional 8 bytes for the Realtek tag.
+	 */
+	if (unlikely(__skb_put_padto(skb, ETH_ZLEN + RTL8_4_TAG_LEN, false)))
+		return NULL;
+
+	skb_push(skb, RTL8_4_TAG_LEN);
+
+	dsa_alloc_etype_header(skb, RTL8_4_TAG_LEN);
+	tag = dsa_etype_header_pos_tx(skb);
+
+	/* Set Realtek EtherType */
+	tag[0] = htons(ETH_P_REALTEK);
+
+	/* Set Protocol; zero REASON */
+	tag[1] = htons(FIELD_PREP(RTL8_4_PROTOCOL, RTL8_4_PROTOCOL_RTL8365MB));
+
+	/* Zero FID_EN, FID, PRI_EN, PRI, KEEP; set LEARN_DIS */
+	tag[2] = htons(FIELD_PREP(RTL8_4_LEARN_DIS, 1));
+
+	/* Zero ALLOW; set RX (CPU->switch) forwarding port mask */
+	tag[3] = htons(FIELD_PREP(RTL8_4_RX, BIT(dp->index)));
+
+	return skb;
+}
+
+static struct sk_buff *rtl8_4_tag_rcv(struct sk_buff *skb,
+				      struct net_device *dev)
+{
+	__be16 *tag;
+	u16 etype;
+	u8 reason;
+	u8 proto;
+	u8 port;
+
+	if (unlikely(!pskb_may_pull(skb, RTL8_4_TAG_LEN)))
+		return NULL;
+
+	tag = dsa_etype_header_pos_rx(skb);
+
+	/* Parse Realtek EtherType */
+	etype = ntohs(tag[0]);
+	if (unlikely(etype != ETH_P_REALTEK)) {
+		dev_warn_ratelimited(&dev->dev,
+				     "non-realtek ethertype 0x%04x\n", etype);
+		return NULL;
+	}
+
+	/* Parse Protocol */
+	proto = FIELD_GET(RTL8_4_PROTOCOL, ntohs(tag[1]));
+	if (unlikely(proto != RTL8_4_PROTOCOL_RTL8365MB)) {
+		dev_warn_ratelimited(&dev->dev,
+				     "unknown realtek protocol 0x%02x\n",
+				     proto);
+		return NULL;
+	}
+
+	/* Parse REASON */
+	reason = FIELD_GET(RTL8_4_REASON, ntohs(tag[1]));
+
+	/* Parse TX (switch->CPU) */
+	port = FIELD_GET(RTL8_4_TX, ntohs(tag[3]));
+	skb->dev = dsa_master_find_slave(dev, 0, port);
+	if (!skb->dev) {
+		dev_warn_ratelimited(&dev->dev,
+				     "could not find slave for port %d\n",
+				     port);
+		return NULL;
+	}
+
+	/* Remove tag and recalculate checksum */
+	skb_pull_rcsum(skb, RTL8_4_TAG_LEN);
+
+	dsa_strip_etype_header(skb, RTL8_4_TAG_LEN);
+
+	if (reason != RTL8_4_REASON_TRAP)
+		dsa_default_offload_fwd_mark(skb);
+
+	return skb;
+}
+
+static const struct dsa_device_ops rtl8_4_netdev_ops = {
+	.name = "rtl8_4",
+	.proto = DSA_TAG_PROTO_RTL8_4,
+	.xmit = rtl8_4_tag_xmit,
+	.rcv = rtl8_4_tag_rcv,
+	.needed_headroom = RTL8_4_TAG_LEN,
+};
+module_dsa_tag_driver(rtl8_4_netdev_ops);
+
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_RTL8_4);
-- 
2.32.0

