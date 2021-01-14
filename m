Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB012F6BA1
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 20:58:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730347AbhANT63 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 14:58:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729069AbhANT62 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 14:58:28 -0500
Received: from mail-oo1-xc35.google.com (mail-oo1-xc35.google.com [IPv6:2607:f8b0:4864:20::c35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CD4AC061757;
        Thu, 14 Jan 2021 11:57:48 -0800 (PST)
Received: by mail-oo1-xc35.google.com with SMTP id y14so1649997oom.10;
        Thu, 14 Jan 2021 11:57:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=srrihTdP83kkaii+4P/xPu1Zy6Z+rb6DxOXiimJIHjs=;
        b=ThUBDBgaxjNIfPKczEKbRRjqspkjal4K9Kbo16HJssJGrQLvatiKSwziCPmFM0ta4v
         2dPitp9zsx2dioiRXpy7G7groMKqBNePI6y6LU+9EDEpezhDGqT4nD3gT7Fr+yYieDaa
         muuuTtb+6lV8W9kAB5MHsmq6EIzfWyOBU/thCe5BfIud6eoAWX/WVwsUtzK8m0csZkmD
         v7yLulzfPxguycXPJMfYyZc4PKlp1yZcvo8WqjeOk6Rn25V6gtdRqtGNQQnIYhTxc2+R
         UPoif9xeJ55CJuFJWOY+EnT/JPe+epLimsiBkLXPQYydxPbxhFElQ/AJV8AAbxo/UDvz
         uQLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=srrihTdP83kkaii+4P/xPu1Zy6Z+rb6DxOXiimJIHjs=;
        b=bumtvtujeQWQJQZ2ya7GhVVpWWk7wfe4PmH2F1b1IUpn1pF0YIEllWyA1COgoTLR+u
         ncjlYs1Q0F1NW63nIEdeTdJiOQMSewiBdVDtFa83qGkHnJwXlW3SiZSTui0rsO5aWjnA
         iGofwgSISsdO4of4G9IeEpfzO8teeSXfWw5cNf6FcpAQplpcNhsv2OrY9tppBHTpQRCL
         o9DGZJzTdirc5D4kA+A2NH7A5PkdPvw7xpLKmBg2H77/BxgjKr6HsR2Lz6KNi0nZdrUt
         mSJmnHHQxQ22f5+SPkDEuqLa621KpBZ0wfJSWQApg1GqGgpGpLVhiQdM3TpAMNgL889p
         kdDA==
X-Gm-Message-State: AOAM532QIbHonWXf6itevEFLRsx6Z4O2ZERwJ7gCN+byLNyDczEWPRwn
        aIxroS3ojjnt88MDqlTgPA==
X-Google-Smtp-Source: ABdhPJzv1GofgRnQw1sN90tsebW5M2vFj57Ju04iJsHDObOYGPOWMgNtw4BrfP8MXP4kt0YdSjrlYw==
X-Received: by 2002:a05:6820:34b:: with SMTP id m11mr5867328ooe.74.1610654267503;
        Thu, 14 Jan 2021 11:57:47 -0800 (PST)
Received: from threadripper.novatech-llc.local ([216.21.169.52])
        by smtp.gmail.com with ESMTPSA id e17sm1244820otk.64.2021.01.14.11.57.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Jan 2021 11:57:46 -0800 (PST)
From:   George McCollister <george.mccollister@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     Rob Herring <robh@kernel.org>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org,
        George McCollister <george.mccollister@gmail.com>
Subject: [PATCH net-next v5 1/3] dsa: add support for Arrow XRS700x tag trailer
Date:   Thu, 14 Jan 2021 13:57:32 -0600
Message-Id: <20210114195734.55313-2-george.mccollister@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20210114195734.55313-1-george.mccollister@gmail.com>
References: <20210114195734.55313-1-george.mccollister@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for Arrow SpeedChips XRS700x single byte tag trailer. This
is modeled on tag_trailer.c which works in a similar way.

Signed-off-by: George McCollister <george.mccollister@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 include/net/dsa.h     |  2 ++
 net/dsa/Kconfig       |  6 +++++
 net/dsa/Makefile      |  1 +
 net/dsa/tag_xrs700x.c | 61 +++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 70 insertions(+)
 create mode 100644 net/dsa/tag_xrs700x.c

diff --git a/include/net/dsa.h b/include/net/dsa.h
index c3485ba6c312..74b5bf835657 100644
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
index 000000000000..db0ed1a5fcb7
--- /dev/null
+++ b/net/dsa/tag_xrs700x.c
@@ -0,0 +1,61 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * XRS700x tag format handling
+ * Copyright (c) 2008-2009 Marvell Semiconductor
+ * Copyright (c) 2020 NovaTech LLC
+ */
+
+#include <linux/bitops.h>
+
+#include "dsa_priv.h"
+
+static struct sk_buff *xrs700x_xmit(struct sk_buff *skb, struct net_device *dev)
+{
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	u8 *trailer;
+
+	trailer = skb_put(skb, 1);
+	trailer[0] = BIT(dp->index);
+
+	return skb;
+}
+
+static struct sk_buff *xrs700x_rcv(struct sk_buff *skb, struct net_device *dev,
+				   struct packet_type *pt)
+{
+	int source_port;
+	u8 *trailer;
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
+	.tail_tag = true,
+};
+
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_XRS700X);
+
+module_dsa_tag_driver(xrs700x_netdev_ops);
-- 
2.11.0

