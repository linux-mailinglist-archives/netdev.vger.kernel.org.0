Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C679A2FEFC5
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 17:06:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387494AbhAUQGX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 11:06:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732279AbhAUQEF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 11:04:05 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 235F0C0617A7
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 08:02:40 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id g12so3312683ejf.8
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 08:02:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RZ+w9rCfLnWnvDqbX5iT9h0O4SpnqyN4I3aza4h4cxk=;
        b=mbONaNdcFJx4qu2/l2AZV8Kfjc1GsyWJ9BcfZCIwhqqKgZmZOAXyRRIehHrcCAib49
         UZXhcP+gT340wNznHaKFa4+WRbu9iRZL7ORfPXQO0fy78TRj8m3XlGWyOLahvJJwUQtu
         mypBtyMHHxf0Duyg2k0eyM8hHf+uapxnbeuejDTLDVYiUrq3VRi1nkqNQYSC1kVoDW1n
         xsji2f/b6TIwi7NoaD5E84vsHuEk3Zl2wjrlRvWDGMas6gnp//Lpb9dKSB8vF4asTixy
         vKXXsJjuSrERPK1JZEoWMCdRp0VP/DuVUdnQcVDBSZjsqCQUwONFkzGe+Mq/E7u+GAWl
         0WEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RZ+w9rCfLnWnvDqbX5iT9h0O4SpnqyN4I3aza4h4cxk=;
        b=iKoXrAzU3A3u6rKA+zK4gF5W95Z1QaHheyPIJmuVsN9vJyXxAp8Wez/ScymwV+TGQr
         rvaef6pLsfi99yfh0yOCh+v79N1ogFmdjAjNSf6hR8epB6xt8B7xU3iCZdBPFPuMDgcU
         tLivuB0jqeJK4LpQsM3r6UyPrcPtYRlfRUZxG6ycvY4iGQV65PuCQrkQWztsfwi/JSR5
         8S9DBfSAupz9k5+yHjBJUwLjvpgLPl5VxG8UinEiHDtuJKIJKq5zh2vunQG6N7Tg3dwz
         uKMs0PmscrkJmddc4H/4zKOrP4nhlNH5RdNrLMoOeMfnBpXFY6IsGoNmiZMNS31tnVLW
         yCDQ==
X-Gm-Message-State: AOAM530qIOMuC/PKX7tCJ47aD2rW2dbfFuQk6YjMy9k5Au0xc84kP4hm
        mCmZfKTJWw3Qt2Ixq+UTCf8=
X-Google-Smtp-Source: ABdhPJwM30Kc7Ng68nu4xwX8Bjv6DYlWX+wKI2n7otmIaND+6nGbdHuDQLYUd7+QQ/btLwWSdgJTOw==
X-Received: by 2002:a17:906:4d19:: with SMTP id r25mr119917eju.148.1611244958804;
        Thu, 21 Jan 2021 08:02:38 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id zk10sm2419973ejb.10.2021.01.21.08.02.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jan 2021 08:02:37 -0800 (PST)
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
Subject: [PATCH v6 net-next 09/10] net: dsa: add a second tagger for Ocelot switches based on tag_8021q
Date:   Thu, 21 Jan 2021 18:01:30 +0200
Message-Id: <20210121160131.2364236-10-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210121160131.2364236-1-olteanv@gmail.com>
References: <20210121160131.2364236-1-olteanv@gmail.com>
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
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v6:
None.

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
index 1df56a32d2df..567ff39c7ffe 100644
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
index b7e680aa325d..108ae4fc4f81 100644
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

