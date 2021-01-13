Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92EC92F4E07
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 16:00:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbhAMPA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 10:00:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726837AbhAMPA0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 10:00:26 -0500
Received: from mail-oo1-xc30.google.com (mail-oo1-xc30.google.com [IPv6:2607:f8b0:4864:20::c30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9161DC061794;
        Wed, 13 Jan 2021 06:59:45 -0800 (PST)
Received: by mail-oo1-xc30.google.com with SMTP id p72so580534oop.4;
        Wed, 13 Jan 2021 06:59:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=DD9DlgAgyNERj6h+oZEYHseyiB3DhwtndfKECvUciw4=;
        b=AVDV7RXR1CWpH4LqOtbhZwd9FB8Tns0SuQPMWII1pMY0okU3xU/OEdqr49d0XCRehU
         cSjHnPfepBFXMrPJLwiXSgoei2yyhfh+e5d3FhVBOm9rTnxYIstoYrPzxh/ylFvAD2im
         eMwyLNKwq2C1MqXZCbvKWk5r6kcDfxp7e1o3WprBcPmhVzQcMagtPSZryLR150qI4yeq
         qFPvQxD1RevSVGENPuz/usgmibC+koPFdlh73NhN+vym6twFOBKXb6vmqSPBgFYlDfvD
         k/lz1ptWF0Hbsc/h8N5TnVOndZNabQR6LFKidzgjhaSdVfVZJhl70vREskbvgn0ZuUcA
         XaXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=DD9DlgAgyNERj6h+oZEYHseyiB3DhwtndfKECvUciw4=;
        b=iwcLnYNMCLQ6q8JCkF7bLSSFTFjTarDiWogtssWrcWmzDcheEfpAslCLCTju5tl4nc
         6hPP1UACTH2yYCLuyhb4VzYH6lyGkTfmu9iVNAWMDQ5t3WcylbLnD2GVO8BUn4N1qwxt
         7i/XLewERWDemDcc9oovNQz/1JP3aNtX7yoZFQ1WBsjgcK2/6oo6mMf8OYo8EYGjgVqq
         ZFtQGIi9We0tMZ60DCHecdQsqWlHA1gUeNizwHqiuYf+AS/B9KrrEJEOY1LS+90QMYSK
         w2Of+oObTlTqNr0jnQjI9CH1ikNf8UdvJsewXIxt9zACAjcGn0FuwYk3GoRuMoe6bZs6
         9gOg==
X-Gm-Message-State: AOAM530MOL6LgVJzRgm2GQZz2jKaM/Z/klf+hClwyWheeYE1OdG0l+mn
        yoAlgB++nRuhPnbyCbUzxA==
X-Google-Smtp-Source: ABdhPJy9wLMxaUE85yzD04+dYjDul1NbB00aTRS36Tvv8iZ6DxoyoTpedKcEFSg03dCIosGfQu8IMw==
X-Received: by 2002:a4a:e606:: with SMTP id f6mr1535452oot.4.1610549983556;
        Wed, 13 Jan 2021 06:59:43 -0800 (PST)
Received: from threadripper.novatech-llc.local ([216.21.169.52])
        by smtp.gmail.com with ESMTPSA id f25sm440719oou.39.2021.01.13.06.59.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 13 Jan 2021 06:59:42 -0800 (PST)
From:   George McCollister <george.mccollister@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     Rob Herring <robh@kernel.org>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org,
        George McCollister <george.mccollister@gmail.com>
Subject: [PATCH net-next v4 1/3] dsa: add support for Arrow XRS700x tag trailer
Date:   Wed, 13 Jan 2021 08:59:20 -0600
Message-Id: <20210113145922.92848-2-george.mccollister@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20210113145922.92848-1-george.mccollister@gmail.com>
References: <20210113145922.92848-1-george.mccollister@gmail.com>
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
 net/dsa/tag_xrs700x.c | 67 +++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 76 insertions(+)
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
index 000000000000..4ee7c260a8a9
--- /dev/null
+++ b/net/dsa/tag_xrs700x.c
@@ -0,0 +1,67 @@
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
+	.tail_tag = true,
+};
+
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_XRS700X);
+
+module_dsa_tag_driver(xrs700x_netdev_ops);
-- 
2.11.0

