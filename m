Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0681A2FDFDC
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 04:03:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392932AbhAUCuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 21:50:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728852AbhAUCjW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 21:39:22 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68DB6C061796
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 18:36:41 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id s11so696521edd.5
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 18:36:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bJRFeWSKXa/HwHIOv2knUSM2rJZlTGkvY8pKAbByy7o=;
        b=CrCvO0SdKdvFvbl7227bjKo8GhET3TAGCW3QvKxekFo5vYJ92fG/ird83qu/IkMWTu
         IDx1XYgSikAt70O2fl0zqm7mnfBuGPqbIjzUZ4VNqlhYrL5uXOn0Rd43lv/6908Pxf9G
         dIQR/UlmbUG9HlClLEFWoUqOOrT4F7VOk5QvzDIL+fz/YEI1ZKH8OpHZhd9sVZuoMsOk
         ffXYJAAUSiZQeRbWB71usb2Wx0hBFZAAg8F4Xk0pwVBds9YJDMM6NhG3muk98tNQn+5L
         MgufS2gurQrVPuhhfjOCNS2zwKbKZEqX3jIwE6pgrecmLI46jPRwvF2w95kdZaFCldSX
         nE9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bJRFeWSKXa/HwHIOv2knUSM2rJZlTGkvY8pKAbByy7o=;
        b=ojclLgG6Ya2Hc1l1TKgduGCBxsJLxexfygHStgy7idK8J8qoiSzrL4wFnsq9cP8AQ8
         voxEm6nltdo0azCkisK10c31X4XKdIyfEWRGCXmVLOrm9VQARXFfFSNODnGyiHtRlvFN
         w1jQtOpmJxMP8q4OV4n48Pw9CJ6ZJa1SGjVc5KYi2ev69h9ezWzHYYYrecPJgFaNQi0d
         uXSE7HuG3ITq8xL/3aooKSd/tHu50UW21OaJLiM1VSBPnLpBzvKKToEthJnaP6waD9To
         NoHzzFTkZVbMrgx/u/jq21rmZ/ZkcUcNs7KDQhPxwIsXVG6he09dqWnrchYi5vJ0t+I8
         WZ8Q==
X-Gm-Message-State: AOAM5305QXqSKglDYgqCXUU/sty3MmxN7X/o12x45o1Txx1FWiDvAj49
        u9EFw7ZlqWlTcJRQo974r2XtMfQER9I=
X-Google-Smtp-Source: ABdhPJwNI7fI0VT0gS5Z912yN/aK5GnnxEGYCoUTOkF5mXXps6l5Kf6fPbliFWw0wlDJuwiADDh0yw==
X-Received: by 2002:a05:6402:402:: with SMTP id q2mr9528899edv.116.1611196600180;
        Wed, 20 Jan 2021 18:36:40 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id k22sm2025787edv.33.2021.01.20.18.36.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 18:36:39 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Hongbo Wang <hongbo.wang@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Po Liu <po.liu@nxp.com>, Yangbo Lu <yangbo.lu@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Eldar Gasanov <eldargasanov2@gmail.com>,
        Andrey L <al@b4comtech.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH v5 net-next 09/10] net: dsa: add a second tagger for Ocelot switches based on tag_8021q
Date:   Thu, 21 Jan 2021 04:36:15 +0200
Message-Id: <20210121023616.1696021-10-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210121023616.1696021-1-olteanv@gmail.com>
References: <20210121023616.1696021-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

There are use cases for which the existing tagger, based on the NPI
(Node Processor Interface) functionality, is insufficient.

Namely:
- Frames injected through the NPI port bypass the frame analyzer, so no
  source address learning is performed, no TSN stream classification,
  etc.
- Flow control is not functional over an NPI port (PAUSE frames are
  encapsulated in the same Extraction Frame Header as all other frames)
- There can be at most one NPI port configured for an Ocelot switch. But
  in NXP LS1028A and T1040 there are two Ethernet CPU ports. The non-NPI
  port is currently either disabled, or operated as a plain user port
  (albeit an internally-facing one). Having the ability to configure the
  two CPU ports symmetrically could pave the way for e.g. creating a LAG
  between them, to increase bandwidth seamlessly for the system.

So there is a desire to have an alternative to the NPI mode. This change
keeps the default tagger for the Seville and Felix switches as "ocelot",
but it can be changed via the following device attribute:

echo ocelot-8021q > /sys/class/<dsa-master>/dsa/tagging

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v5:
Path is split from previous monolithic patch "net: dsa: felix: add new
VLAN-based tagger".

 MAINTAINERS                    |  1 +
 drivers/net/dsa/ocelot/Kconfig |  2 +
 include/net/dsa.h              |  2 +
 net/dsa/Kconfig                | 21 +++++++++--
 net/dsa/Makefile               |  1 +
 net/dsa/tag_ocelot_8021q.c     | 68 ++++++++++++++++++++++++++++++++++
 6 files changed, 92 insertions(+), 3 deletions(-)
 create mode 100644 net/dsa/tag_ocelot_8021q.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 096b584e7fed..ae793658e6a5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12842,6 +12842,7 @@ F:	drivers/net/dsa/ocelot/*
 F:	drivers/net/ethernet/mscc/
 F:	include/soc/mscc/ocelot*
 F:	net/dsa/tag_ocelot.c
+F:	net/dsa/tag_ocelot_8021q.c
 F:	tools/testing/selftests/drivers/net/ocelot/*
 
 OCXL (Open Coherent Accelerator Processor Interface OpenCAPI) DRIVER
diff --git a/drivers/net/dsa/ocelot/Kconfig b/drivers/net/dsa/ocelot/Kconfig
index c110e82a7973..932b6b6fe817 100644
--- a/drivers/net/dsa/ocelot/Kconfig
+++ b/drivers/net/dsa/ocelot/Kconfig
@@ -6,6 +6,7 @@ config NET_DSA_MSCC_FELIX
 	depends on NET_VENDOR_FREESCALE
 	depends on HAS_IOMEM
 	select MSCC_OCELOT_SWITCH_LIB
+	select NET_DSA_TAG_OCELOT_8021Q
 	select NET_DSA_TAG_OCELOT
 	select FSL_ENETC_MDIO
 	select PCS_LYNX
@@ -19,6 +20,7 @@ config NET_DSA_MSCC_SEVILLE
 	depends on NET_VENDOR_MICROSEMI
 	depends on HAS_IOMEM
 	select MSCC_OCELOT_SWITCH_LIB
+	select NET_DSA_TAG_OCELOT_8021Q
 	select NET_DSA_TAG_OCELOT
 	select PCS_LYNX
 	help
diff --git a/include/net/dsa.h b/include/net/dsa.h
index be77a7c0a22d..6cbd06c6c61c 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -47,6 +47,7 @@ struct phylink_link_state;
 #define DSA_TAG_PROTO_RTL4_A_VALUE		17
 #define DSA_TAG_PROTO_HELLCREEK_VALUE		18
 #define DSA_TAG_PROTO_XRS700X_VALUE		19
+#define DSA_TAG_PROTO_OCELOT_8021Q_VALUE	20
 
 enum dsa_tag_protocol {
 	DSA_TAG_PROTO_NONE		= DSA_TAG_PROTO_NONE_VALUE,
@@ -69,6 +70,7 @@ enum dsa_tag_protocol {
 	DSA_TAG_PROTO_RTL4_A		= DSA_TAG_PROTO_RTL4_A_VALUE,
 	DSA_TAG_PROTO_HELLCREEK		= DSA_TAG_PROTO_HELLCREEK_VALUE,
 	DSA_TAG_PROTO_XRS700X		= DSA_TAG_PROTO_XRS700X_VALUE,
+	DSA_TAG_PROTO_OCELOT_8021Q	= DSA_TAG_PROTO_OCELOT_8021Q_VALUE,
 };
 
 struct packet_type;
diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
index 2d226a5c085f..a45572cfb71a 100644
--- a/net/dsa/Kconfig
+++ b/net/dsa/Kconfig
@@ -105,11 +105,26 @@ config NET_DSA_TAG_RTL4_A
 	  the Realtek RTL8366RB.
 
 config NET_DSA_TAG_OCELOT
-	tristate "Tag driver for Ocelot family of switches"
+	tristate "Tag driver for Ocelot family of switches, using NPI port"
 	select PACKING
 	help
-	  Say Y or M if you want to enable support for tagging frames for the
-	  Ocelot switches (VSC7511, VSC7512, VSC7513, VSC7514, VSC9959).
+	  Say Y or M if you want to enable NPI tagging for the Ocelot switches
+	  (VSC7511, VSC7512, VSC7513, VSC7514, VSC9953, VSC9959). In this mode,
+	  the frames over the Ethernet CPU port are prepended with a
+	  hardware-defined injection/extraction frame header.  Flow control
+	  (PAUSE frames) over the CPU port is not supported when operating in
+	  this mode.
+
+config NET_DSA_TAG_OCELOT_8021Q
+	tristate "Tag driver for Ocelot family of switches, using VLAN"
+	select NET_DSA_TAG_8021Q
+	help
+	  Say Y or M if you want to enable support for tagging frames with a
+	  custom VLAN-based header. Frames that require timestamping, such as
+	  PTP, are not delivered over Ethernet but over register-based MMIO.
+	  Flow control over the CPU port is functional in this mode. When using
+	  this mode, less TCAM resources (VCAP IS1, IS2, ES0) are available for
+	  use with tc-flower.
 
 config NET_DSA_TAG_QCA
 	tristate "Tag driver for Qualcomm Atheros QCA8K switches"
diff --git a/net/dsa/Makefile b/net/dsa/Makefile
index 92cea2132241..44bc79952b8b 100644
--- a/net/dsa/Makefile
+++ b/net/dsa/Makefile
@@ -15,6 +15,7 @@ obj-$(CONFIG_NET_DSA_TAG_RTL4_A) += tag_rtl4_a.o
 obj-$(CONFIG_NET_DSA_TAG_LAN9303) += tag_lan9303.o
 obj-$(CONFIG_NET_DSA_TAG_MTK) += tag_mtk.o
 obj-$(CONFIG_NET_DSA_TAG_OCELOT) += tag_ocelot.o
+obj-$(CONFIG_NET_DSA_TAG_OCELOT_8021Q) += tag_ocelot_8021q.o
 obj-$(CONFIG_NET_DSA_TAG_QCA) += tag_qca.o
 obj-$(CONFIG_NET_DSA_TAG_SJA1105) += tag_sja1105.o
 obj-$(CONFIG_NET_DSA_TAG_TRAILER) += tag_trailer.o
diff --git a/net/dsa/tag_ocelot_8021q.c b/net/dsa/tag_ocelot_8021q.c
new file mode 100644
index 000000000000..09e10ade11f7
--- /dev/null
+++ b/net/dsa/tag_ocelot_8021q.c
@@ -0,0 +1,68 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright 2020-2021 NXP Semiconductors
+ *
+ * An implementation of the software-defined tag_8021q.c tagger format, which
+ * also preserves full functionality under a vlan_filtering bridge. It does
+ * this by using the TCAM engines for:
+ * - pushing the RX VLAN as a second, outer tag, on egress towards the CPU port
+ * - redirecting towards the correct front port based on TX VLAN and popping
+ *   that on egress
+ */
+#include <linux/dsa/8021q.h>
+#include "dsa_priv.h"
+
+static struct sk_buff *ocelot_xmit(struct sk_buff *skb,
+				   struct net_device *netdev)
+{
+	struct dsa_port *dp = dsa_slave_to_port(netdev);
+	u16 tx_vid = dsa_8021q_tx_vid(dp->ds, dp->index);
+	u16 queue_mapping = skb_get_queue_mapping(skb);
+	u8 pcp = netdev_txq_to_tc(netdev, queue_mapping);
+
+	return dsa_8021q_xmit(skb, netdev, ETH_P_8021Q,
+			      ((pcp << VLAN_PRIO_SHIFT) | tx_vid));
+}
+
+static struct sk_buff *ocelot_rcv(struct sk_buff *skb,
+				  struct net_device *netdev,
+				  struct packet_type *pt)
+{
+	int src_port, switch_id, qos_class;
+	u16 vid, tci;
+
+	skb_push_rcsum(skb, ETH_HLEN);
+	if (skb_vlan_tag_present(skb)) {
+		tci = skb_vlan_tag_get(skb);
+		__vlan_hwaccel_clear_tag(skb);
+	} else {
+		__skb_vlan_pop(skb, &tci);
+	}
+	skb_pull_rcsum(skb, ETH_HLEN);
+
+	vid = tci & VLAN_VID_MASK;
+	src_port = dsa_8021q_rx_source_port(vid);
+	switch_id = dsa_8021q_rx_switch_id(vid);
+	qos_class = (tci & VLAN_PRIO_MASK) >> VLAN_PRIO_SHIFT;
+
+	skb->dev = dsa_master_find_slave(netdev, switch_id, src_port);
+	if (!skb->dev)
+		return NULL;
+
+	skb->offload_fwd_mark = 1;
+	skb->priority = qos_class;
+
+	return skb;
+}
+
+static struct dsa_device_ops ocelot_netdev_ops = {
+	.name			= "ocelot-8021q",
+	.proto			= DSA_TAG_PROTO_OCELOT_8021Q,
+	.xmit			= ocelot_xmit,
+	.rcv			= ocelot_rcv,
+	.overhead		= VLAN_HLEN,
+};
+
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_OCELOT_8021Q);
+
+module_dsa_tag_driver(ocelot_netdev_ops);
-- 
2.25.1

