Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEB612BB248
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 19:21:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728434AbgKTSRI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 13:17:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728264AbgKTSRI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 13:17:08 -0500
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C892C0613CF;
        Fri, 20 Nov 2020 10:17:08 -0800 (PST)
Received: by mail-ot1-x32f.google.com with SMTP id o3so9565682ota.8;
        Fri, 20 Nov 2020 10:17:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=dMsZ96Z56DG7YvVJK4mhbiI38VIB7s9L8TPHyCjzPZs=;
        b=KKwlUPAnFJARBksAUBT9lx2pVu4b+qGrAkgYPRSQPHZDN0A0aoOSYKjXdpkkMpz9AC
         J9PFvl8JY/ajo7V7DVzbe1CVs+H+FhfTd/mj/7CQ/lutwECVC/KWJcPGdalqOjFlqJZX
         nNv9ti3MHC8NLNRM0IKlDLv27KSrM7SOIj6DCeBa72jLCvCWttsosGFAw3x5T0YhcmbG
         qTf+8ly+tLA5YFHY03xJV7p6tVHUSG2wOsnu6I0pVeAKjBOJVF/rVX+jlzBGsHV2uU/Z
         K8uuUkIlrnVKjy+glriwLDrteFfeTSbmetvRfh3ok3Q+eCxzc4CI9fng9+TYT9/stWJN
         BHgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=dMsZ96Z56DG7YvVJK4mhbiI38VIB7s9L8TPHyCjzPZs=;
        b=N5wpPj1eVvOItiW1U6IeN+wm9K6o+dwzxZntqg6CE0X60Tpe5nFx33hlril1UDd3Bt
         tKj1FcOJqdxw5Z8fO4zQWI5uORRf4JMXiyod0MqVvTcWmg4eLNngFEsvxc1Z0vssJO+5
         U3k8LS/bw1cDF4LJDtmW2zftKe03FTDNn/fIYayHD3fYQ2NxKfADjXIrrfqiEN0y7xMD
         rBhs/Em7U3hoP4HRahDjuLRKf+1D0Bof6ZttrjDwNPQB/2zsNCYaEEmQgW4jIsd6dgf/
         kY9oFrQy/Tj65qdwQkloLGXkZX1E/o8yPHLGumjAMDXNxmZKGPsBcGFn5Mwee937Bysp
         J2wQ==
X-Gm-Message-State: AOAM533Zg2eLomaqtEEz6wDzpDjN/NAkHmdJ9zFFrI9PZsYpfPSCV+jP
        Fo+VqGJQr8zXpSFVwIteDQ==
X-Google-Smtp-Source: ABdhPJzuARgWRkty5BuNMSBTpguHQQKNbKUekgmuAh67iB/jE7rxwz1huz7r14dJn94x6hPB++wkLw==
X-Received: by 2002:a9d:27a5:: with SMTP id c34mr14266264otb.303.1605896227481;
        Fri, 20 Nov 2020 10:17:07 -0800 (PST)
Received: from threadripper.novatech-llc.local ([216.21.169.52])
        by smtp.gmail.com with ESMTPSA id y35sm1764420otb.5.2020.11.20.10.17.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 20 Nov 2020 10:17:06 -0800 (PST)
From:   George McCollister <george.mccollister@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S . Miller " <davem@davemloft.net>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org,
        George McCollister <george.mccollister@gmail.com>
Subject: [PATCH net-next 1/3] dsa: add support for Arrow XRS700x tag trailer
Date:   Fri, 20 Nov 2020 12:16:25 -0600
Message-Id: <20201120181627.21382-2-george.mccollister@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20201120181627.21382-1-george.mccollister@gmail.com>
References: <20201120181627.21382-1-george.mccollister@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for Arrow SpeedChips XRS700x single byte tag trailer. This
is modeled on tag_trailer.c which works in a similar way.

Signed-off-by: George McCollister <george.mccollister@gmail.com>
---
 include/net/dsa.h     |  2 ++
 net/dsa/Kconfig       |  6 ++++
 net/dsa/Makefile      |  1 +
 net/dsa/tag_xrs700x.c | 91 +++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 100 insertions(+)
 create mode 100644 net/dsa/tag_xrs700x.c

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 2e64e8de4631..eb46ecdcf165 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -46,6 +46,7 @@ struct phylink_link_state;
 #define DSA_TAG_PROTO_AR9331_VALUE		16
 #define DSA_TAG_PROTO_RTL4_A_VALUE		17
 #define DSA_TAG_PROTO_HELLCREEK_VALUE		18
+#define DSA_TAG_PROTO_XRS700X_VALUE		19
 
 enum dsa_tag_protocol {
 	DSA_TAG_PROTO_NONE		= DSA_TAG_PROTO_NONE_VALUE,
@@ -67,6 +68,7 @@ enum dsa_tag_protocol {
 	DSA_TAG_PROTO_AR9331		= DSA_TAG_PROTO_AR9331_VALUE,
 	DSA_TAG_PROTO_RTL4_A		= DSA_TAG_PROTO_RTL4_A_VALUE,
 	DSA_TAG_PROTO_HELLCREEK		= DSA_TAG_PROTO_HELLCREEK_VALUE,
+	DSA_TAG_PROTO_XRS700X		= DSA_TAG_PROTO_XRS700X_VALUE,
 };
 
 struct packet_type;
diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
index dfecd7b22fd7..2d226a5c085f 100644
--- a/net/dsa/Kconfig
+++ b/net/dsa/Kconfig
@@ -139,4 +139,10 @@ config NET_DSA_TAG_TRAILER
 	  Say Y or M if you want to enable support for tagging frames at
 	  with a trailed. e.g. Marvell 88E6060.
 
+config NET_DSA_TAG_XRS700X
+	tristate "Tag driver for XRS700x switches"
+	help
+	  Say Y or M if you want to enable support for tagging frames for
+	  Arrow SpeedChips XRS700x switches that use a single byte tag trailer.
+
 endif
diff --git a/net/dsa/Makefile b/net/dsa/Makefile
index 0fb2b75a7ae3..92cea2132241 100644
--- a/net/dsa/Makefile
+++ b/net/dsa/Makefile
@@ -18,3 +18,4 @@ obj-$(CONFIG_NET_DSA_TAG_OCELOT) += tag_ocelot.o
 obj-$(CONFIG_NET_DSA_TAG_QCA) += tag_qca.o
 obj-$(CONFIG_NET_DSA_TAG_SJA1105) += tag_sja1105.o
 obj-$(CONFIG_NET_DSA_TAG_TRAILER) += tag_trailer.o
+obj-$(CONFIG_NET_DSA_TAG_XRS700X) += tag_xrs700x.o
diff --git a/net/dsa/tag_xrs700x.c b/net/dsa/tag_xrs700x.c
new file mode 100644
index 000000000000..2eda57a4a474
--- /dev/null
+++ b/net/dsa/tag_xrs700x.c
@@ -0,0 +1,91 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * XRS700x tag format handling
+ * Copyright (c) 2008-2009 Marvell Semiconductor
+ * Copyright (c) 2020 NovaTech LLC
+ */
+
+#include <linux/etherdevice.h>
+#include <linux/list.h>
+#include <linux/slab.h>
+#include <linux/bitops.h>
+
+#include "dsa_priv.h"
+
+static struct sk_buff *xrs700x_xmit(struct sk_buff *skb, struct net_device *dev)
+{
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct sk_buff *nskb;
+	int padlen;
+	u8 *trailer;
+
+	/* We have to make sure that the trailer ends up as the very
+	 * last byte of the packet.  This means that we have to pad
+	 * the packet to the minimum ethernet frame size, if necessary,
+	 * before adding the trailer.
+	 */
+	padlen = 0;
+	if (skb->len < 63)
+		padlen = 63 - skb->len;
+
+	nskb = alloc_skb(NET_IP_ALIGN + skb->len + padlen + 1, GFP_ATOMIC);
+	if (!nskb)
+		return NULL;
+	skb_reserve(nskb, NET_IP_ALIGN);
+
+	skb_reset_mac_header(nskb);
+	skb_set_network_header(nskb, skb_network_header(skb) - skb->head);
+	skb_set_transport_header(nskb, skb_transport_header(skb) - skb->head);
+	skb_copy_and_csum_dev(skb, skb_put(nskb, skb->len));
+	consume_skb(skb);
+
+	if (padlen)
+		skb_put_zero(nskb, padlen);
+
+	trailer = skb_put(nskb, 1);
+	trailer[0] = BIT(dp->index);
+
+	return nskb;
+}
+
+static struct sk_buff *xrs700x_rcv(struct sk_buff *skb, struct net_device *dev,
+				   struct packet_type *pt)
+{
+	u8 *trailer;
+	int source_port;
+
+	if (skb_linearize(skb))
+		return NULL;
+
+	trailer = skb_tail_pointer(skb) - 1;
+
+	source_port = ffs((int)trailer[0]) - 1;
+
+	if (source_port < 0)
+		return NULL;
+
+	skb->dev = dsa_master_find_slave(dev, 0, source_port);
+	if (!skb->dev)
+		return NULL;
+
+	if (pskb_trim_rcsum(skb, skb->len - 1))
+		return NULL;
+
+	/* Frame is forwarded by hardware, don't forward in software. */
+	skb->offload_fwd_mark = 1;
+
+	return skb;
+}
+
+static const struct dsa_device_ops xrs700x_netdev_ops = {
+	.name	= "xrs700x",
+	.proto	= DSA_TAG_PROTO_XRS700X,
+	.xmit	= xrs700x_xmit,
+	.rcv	= xrs700x_rcv,
+	.overhead = 1,
+};
+
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_XRS700X);
+
+module_dsa_tag_driver(xrs700x_netdev_ops);
-- 
2.11.0

