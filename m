Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A253931D55A
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 07:27:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231277AbhBQGWa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 01:22:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230309AbhBQGW3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 01:22:29 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54F2DC06174A
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 22:21:49 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id y25so4491252pfp.5
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 22:21:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7eoxcOjCKZJFMLJSiIhB+Z/LLaVRPkl9IMiQ6LnEmVs=;
        b=FWAwyYCv7QWkp9R8/osuB1U0BeqaxGmEubd8t6bhyFeK66unzamuHBgbksmKKX8vd/
         SpT68IaOK6b6vkkS0cBXDIV9nj1bFPte17vb/CU67T+DUdnMbXx4C1dgDeKZWoCsK9RT
         6gsceBE5cpcofl8CqlWQR4SWXOT2J039kax0Ekvbzn1hQLn5zsYw8vFTaERnm6pxqZAr
         We/OJ1qNsfVuUfj/CazcdxRyVuAlFbXxuFO0zMx4Nf08EFguqiAk1SMaPW3q4+TCfZSC
         3lRGPHTeFMEnFVsJraZyIBbfc4WXEQdTMB1F6gJUK8Es6tcJ5nIq5QEjhaFepCq3DtmN
         1qkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7eoxcOjCKZJFMLJSiIhB+Z/LLaVRPkl9IMiQ6LnEmVs=;
        b=BoiQFBX2TlHFy64aFbqM/cRbln9/8+9oHstG8r8SSU0neFWeIpUhRpHYhn4FmayFJ2
         sXpfB/wijiO2d4ixSZm1qKXj2I8OU5YXKzASfUede7Bqp0Nr5zMur8uAI88HQrK5tTkX
         KIbYMpmv3zxa/oTBBlBzrGn2sSOMkwwNBgpUh4bd8KI8pREi+LcM4Z7CmU5RguOdkcw6
         F6m29lWOSo49Hgt5MhC49eRrOMSVZuOxkjXK8DV7Ypf9DJ/37KqVt5mSOJq+cIRfb6yQ
         wwyjEXzOPudRcdAcSve806dRBMHhu+UIS4i6GrT+lM5HKE3jh6LnY+RDXlxngeNqyn4J
         QLvw==
X-Gm-Message-State: AOAM530UBmu3ZtHcssYGRRXD2/M0uSJoidmGXnRKa5FLEdMFf/Ey6+Hz
        ytcm8Wxc2y/Ibnkct5I302A=
X-Google-Smtp-Source: ABdhPJybOj2RnkYYR81LIXZe1wpNvOxnkjIguY+Tvvjs0E2qc+glJLsy33JFBmY2V9gPeG49QbmVvQ==
X-Received: by 2002:a05:6a00:894:b029:1dc:2f68:5f0 with SMTP id q20-20020a056a000894b02901dc2f6805f0mr1312328pfj.23.1613542908951;
        Tue, 16 Feb 2021 22:21:48 -0800 (PST)
Received: from Haswell.lan ([2a09:bac0:23::815:b46])
        by smtp.gmail.com with ESMTPSA id p2sm843233pjv.31.2021.02.16.22.21.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Feb 2021 22:21:48 -0800 (PST)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Mauri Sandberg <sandberg@mailfence.com>
Subject: [RFC net-next 1/2] net: dsa: add Realtek RTL8366S switch tag
Date:   Wed, 17 Feb 2021 14:21:38 +0800
Message-Id: <20210217062139.7893-2-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210217062139.7893-1-dqfext@gmail.com>
References: <20210217062139.7893-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for Realtek RTL8366S switch tag

Signed-off-by: DENG Qingfang <dqfext@gmail.com>
---
 include/net/dsa.h      |  2 +
 net/dsa/Kconfig        |  6 +++
 net/dsa/Makefile       |  1 +
 net/dsa/tag_rtl8366s.c | 98 ++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 107 insertions(+)
 create mode 100644 net/dsa/tag_rtl8366s.c

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 83a933e563fe..14fedf832f27 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -49,6 +49,7 @@ struct phylink_link_state;
 #define DSA_TAG_PROTO_XRS700X_VALUE		19
 #define DSA_TAG_PROTO_OCELOT_8021Q_VALUE	20
 #define DSA_TAG_PROTO_SEVILLE_VALUE		21
+#define DSA_TAG_PROTO_RTL8366S_VALUE		22
 
 enum dsa_tag_protocol {
 	DSA_TAG_PROTO_NONE		= DSA_TAG_PROTO_NONE_VALUE,
@@ -73,6 +74,7 @@ enum dsa_tag_protocol {
 	DSA_TAG_PROTO_XRS700X		= DSA_TAG_PROTO_XRS700X_VALUE,
 	DSA_TAG_PROTO_OCELOT_8021Q	= DSA_TAG_PROTO_OCELOT_8021Q_VALUE,
 	DSA_TAG_PROTO_SEVILLE		= DSA_TAG_PROTO_SEVILLE_VALUE,
+	DSA_TAG_PROTO_RTL8366S		= DSA_TAG_PROTO_RTL8366S_VALUE,
 };
 
 struct packet_type;
diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
index a45572cfb71a..303228e0ad8b 100644
--- a/net/dsa/Kconfig
+++ b/net/dsa/Kconfig
@@ -104,6 +104,12 @@ config NET_DSA_TAG_RTL4_A
 	  Realtek switches with 4 byte protocol A tags, sich as found in
 	  the Realtek RTL8366RB.
 
+config NET_DSA_TAG_RTL8366S
+	tristate "Tag driver for Realtek RTL8366S switch tags"
+	help
+	  Say Y or M if you want to enable support for tagging frames for the
+	  Realtek RTL8366S switch.
+
 config NET_DSA_TAG_OCELOT
 	tristate "Tag driver for Ocelot family of switches, using NPI port"
 	select PACKING
diff --git a/net/dsa/Makefile b/net/dsa/Makefile
index 44bc79952b8b..df158e73a30b 100644
--- a/net/dsa/Makefile
+++ b/net/dsa/Makefile
@@ -12,6 +12,7 @@ obj-$(CONFIG_NET_DSA_TAG_GSWIP) += tag_gswip.o
 obj-$(CONFIG_NET_DSA_TAG_HELLCREEK) += tag_hellcreek.o
 obj-$(CONFIG_NET_DSA_TAG_KSZ) += tag_ksz.o
 obj-$(CONFIG_NET_DSA_TAG_RTL4_A) += tag_rtl4_a.o
+obj-$(CONFIG_NET_DSA_TAG_RTL8366S) += tag_rtl8366s.o
 obj-$(CONFIG_NET_DSA_TAG_LAN9303) += tag_lan9303.o
 obj-$(CONFIG_NET_DSA_TAG_MTK) += tag_mtk.o
 obj-$(CONFIG_NET_DSA_TAG_OCELOT) += tag_ocelot.o
diff --git a/net/dsa/tag_rtl8366s.c b/net/dsa/tag_rtl8366s.c
new file mode 100644
index 000000000000..6c6c66853e4c
--- /dev/null
+++ b/net/dsa/tag_rtl8366s.c
@@ -0,0 +1,98 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Handler for Realtek RTL8366S switch tags
+ * Copyright (c) 2021 DENG, Qingfang <dqfext@gmail.com>
+ *
+ * This tag header looks like:
+ *
+ * -------------------------------------------------
+ * | MAC DA | MAC SA | 0x8899 | 2-byte tag  | Type |
+ * -------------------------------------------------
+ *
+ * The 2-byte tag format in tag_rcv:
+ *       +------+------+------+------+------+------+------+------+
+ * 15: 8 |   Protocol number (0x9)   |  Priority   |  Reserved   |
+ *       +------+------+------+------+------+------+------+------+
+ *  7: 0 |             Reserved             | Source port number |
+ *       +------+------+------+------+------+------+------+------+
+ *
+ * The 2-byte tag format in tag_xmit:
+ *       +------+------+------+------+------+------+------+------+
+ * 15: 8 |   Protocol number (0x9)   |  Priority   |  Reserved   |
+ *       +------+------+------+------+------+------+------+------+
+ *  7: 0 |  Reserved   |          Destination port mask          |
+ *       +------+------+------+------+------+------+------+------+
+ */
+
+#include <linux/etherdevice.h>
+
+#include "dsa_priv.h"
+
+#define RTL8366S_HDR_LEN	4
+#define RTL8366S_ETHERTYPE	0x8899
+#define RTL8366S_PROTOCOL_SHIFT	12
+#define RTL8366S_PROTOCOL	0x9
+#define RTL8366S_TAG	\
+	(RTL8366S_PROTOCOL << RTL8366S_PROTOCOL_SHIFT)
+
+static struct sk_buff *rtl8366s_tag_xmit(struct sk_buff *skb,
+					 struct net_device *dev)
+{
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	__be16 *tag;
+
+	/* Make sure the frame is at least 60 bytes long _before_
+	 * inserting the CPU tag, or it will be dropped by the switch.
+	 */
+	if (unlikely(eth_skb_pad(skb)))
+		return NULL;
+
+	skb_push(skb, RTL8366S_HDR_LEN);
+	memmove(skb->data, skb->data + RTL8366S_HDR_LEN,
+		2 * ETH_ALEN);
+
+	tag = (__be16 *)(skb->data + 2 * ETH_ALEN);
+	tag[0] = htons(RTL8366S_ETHERTYPE);
+	tag[1] = htons(RTL8366S_TAG | BIT(dp->index));
+
+	return skb;
+}
+
+static struct sk_buff *rtl8366s_tag_rcv(struct sk_buff *skb,
+					struct net_device *dev,
+					struct packet_type *pt)
+{
+	u8 *tag;
+	u8 port;
+
+	if (unlikely(!pskb_may_pull(skb, RTL8366S_HDR_LEN)))
+		return NULL;
+
+	tag = skb->data - 2;
+	port = tag[3] & 0x7;
+
+	skb->dev = dsa_master_find_slave(dev, 0, port);
+	if (unlikely(!skb->dev))
+		return NULL;
+
+	skb_pull_rcsum(skb, RTL8366S_HDR_LEN);
+	memmove(skb->data - ETH_HLEN,
+		skb->data - ETH_HLEN - RTL8366S_HDR_LEN,
+		2 * ETH_ALEN);
+
+	skb->offload_fwd_mark = 1;
+
+	return skb;
+}
+
+static const struct dsa_device_ops rtl8366s_netdev_ops = {
+	.name		= "rtl8366s",
+	.proto		= DSA_TAG_PROTO_RTL8366S,
+	.xmit		= rtl8366s_tag_xmit,
+	.rcv		= rtl8366s_tag_rcv,
+	.overhead	= RTL8366S_HDR_LEN,
+};
+module_dsa_tag_driver(rtl8366s_netdev_ops);
+
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_RTL8366S);
-- 
2.25.1

