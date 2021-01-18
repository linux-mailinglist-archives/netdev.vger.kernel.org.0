Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A77EA2FA5EA
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 17:19:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406530AbhARQS7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 11:18:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406593AbhARQS3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 11:18:29 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08B4DC0613C1
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 08:17:48 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id g1so17553644edu.4
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 08:17:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2bGcQWB3ypfl5Ekc41+nBkI/SGVPlvLzbfVesm3JAZE=;
        b=OLoCtVZaly11KrG9vGo3Qne2FlTw9nO92KF0sYBBIPSHSjoqj/mo1PBNpDbSlMA/34
         OijQ4BoiaY2Ge/LrrkJcopnlyFpZqWv9plqKsKadyTnnyulTzDFJWPDtnw6A9Bt9B1ee
         6VES29soF+N6ASmeKzaAwrtX+e3elGHA8WBI5IivkNMvlmvgsAAXZil7SmiQpmZgSp0f
         jjThL8F/LQXfu2CpkIJ34xjs6YJUXPPxYoilExxgIwUiNDD3MvT182wj6mYp8d6QevsM
         X9OMT2OqKDsWRIiteKf+0hO40WwDbcOAq6zgtrtkuSvtSzlzrQFa+oJS5jJdu77Nn2zh
         Xilg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2bGcQWB3ypfl5Ekc41+nBkI/SGVPlvLzbfVesm3JAZE=;
        b=h4Z7w+SP/mZ2P5I9F6kbkliO59cPn0/HrrFrHUgkXRpUsnRhj5V++P/f6J95n3+fMH
         JMNjsA3ZGUMX3Je4kVRBq3C/0Yriyye9YlEcfkfxKRGVEqHr1NMcIfvB4zqMlvAfxmwl
         oj4krIofG8k/lerGpm0zcyFtmQhZlyL1oT42F/2tGL7DO21SVk+vSe6SgaFI72Lvi3QR
         WqEKU5RMPzU2gUPKjwJ6LkwMNBIuBUqXhiSJcHCQh38P0iCoHvyAYHpMGaHm/kTZaj8M
         w/6FB5HQIQdlzTPwwEZBmRsI7VaGZ9iZ27sNIvacI1cWzA0xwVxLhrtwLMNp5v83ijZX
         vi6A==
X-Gm-Message-State: AOAM531jERg1Z9vLJaivFm9glSPfdwjG4uoh02i+lCSlYzo8OvXc6+b2
        bMcMWHrXkAnh+JpFG3REKZ0=
X-Google-Smtp-Source: ABdhPJy2fqt0ZnDtm+Cktz34k+qSyinNvQj1Y7hF3OuAHWepcJx/vuxdew5qS8N+ttOa+5vwfSn3Kg==
X-Received: by 2002:a05:6402:1102:: with SMTP id u2mr209087edv.18.1610986666578;
        Mon, 18 Jan 2021 08:17:46 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id u23sm6093781edt.78.2021.01.18.08.17.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 08:17:46 -0800 (PST)
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
        Hongbo Wang <hongbo.wang@nxp.com>, Po Liu <po.liu@nxp.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Eldar Gasanov <eldargasanov2@gmail.com>,
        Andrey L <al@b4comtech.com>, UNGLinuxDriver@microchip.com
Subject: [PATCH v3 net-next 04/15] net: dsa: felix: add new VLAN-based tagger
Date:   Mon, 18 Jan 2021 18:17:20 +0200
Message-Id: <20210118161731.2837700-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210118161731.2837700-1-olteanv@gmail.com>
References: <20210118161731.2837700-1-olteanv@gmail.com>
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

So, there is a desire to have an alternative to the NPI mode.

This patch brings an implementation of the software-defined tag_8021q.c
tagger format, which also preserves full functionality under a
vlan_filtering bridge (unlike sja1105, the only other user of
tag_8021q).

It does this by using the TCAM engines for:
- pushing the RX VLAN as a second, outer tag, on egress towards the CPU
  port
- redirecting towards the correct front port based on TX VLAN and
  popping that on egress

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v3:
- Use a per-port bool is_dsa_8021q_cpu instead of a single dsa_8021q_cpu
  variable, to be compatible with future work where there may be
  potentially multiple tag_8021q CPU ports in a LAG.
- Initialize ocelot->npi = -1 in felix_8021q_cpu_port_init to ensure we
  don't mistakenly trigger NPI-specific code in ocelot.

Changes in v2:
Clean up the hardcoding of random VCAP filter IDs and the inclusion of a
private ocelot header.

 MAINTAINERS                              |   1 +
 drivers/net/dsa/ocelot/Kconfig           |   4 +-
 drivers/net/dsa/ocelot/Makefile          |   5 +
 drivers/net/dsa/ocelot/felix.c           | 108 ++++++++++++--
 drivers/net/dsa/ocelot/felix.h           |   1 +
 drivers/net/dsa/ocelot/felix_tag_8021q.c | 173 +++++++++++++++++++++++
 drivers/net/dsa/ocelot/felix_tag_8021q.h |  20 +++
 drivers/net/ethernet/mscc/ocelot.c       |  32 +++--
 include/soc/mscc/ocelot.h                |   1 +
 net/dsa/Kconfig                          |  34 +++++
 net/dsa/Makefile                         |   3 +-
 net/dsa/tag_ocelot_8021q.c               |  61 ++++++++
 12 files changed, 419 insertions(+), 24 deletions(-)
 create mode 100644 drivers/net/dsa/ocelot/felix_tag_8021q.c
 create mode 100644 drivers/net/dsa/ocelot/felix_tag_8021q.h
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
index c110e82a7973..ab8de14c4dae 100644
--- a/drivers/net/dsa/ocelot/Kconfig
+++ b/drivers/net/dsa/ocelot/Kconfig
@@ -2,11 +2,11 @@
 config NET_DSA_MSCC_FELIX
 	tristate "Ocelot / Felix Ethernet switch support"
 	depends on NET_DSA && PCI
+	depends on NET_DSA_TAG_OCELOT_NPI || NET_DSA_TAG_OCELOT_8021Q
 	depends on NET_VENDOR_MICROSEMI
 	depends on NET_VENDOR_FREESCALE
 	depends on HAS_IOMEM
 	select MSCC_OCELOT_SWITCH_LIB
-	select NET_DSA_TAG_OCELOT
 	select FSL_ENETC_MDIO
 	select PCS_LYNX
 	help
@@ -16,10 +16,10 @@ config NET_DSA_MSCC_FELIX
 config NET_DSA_MSCC_SEVILLE
 	tristate "Ocelot / Seville Ethernet switch support"
 	depends on NET_DSA
+	depends on NET_DSA_TAG_OCELOT_NPI || NET_DSA_TAG_OCELOT_8021Q
 	depends on NET_VENDOR_MICROSEMI
 	depends on HAS_IOMEM
 	select MSCC_OCELOT_SWITCH_LIB
-	select NET_DSA_TAG_OCELOT
 	select PCS_LYNX
 	help
 	  This driver supports the VSC9953 (Seville) switch, which is embedded
diff --git a/drivers/net/dsa/ocelot/Makefile b/drivers/net/dsa/ocelot/Makefile
index f6dd131e7491..e9ea8c0331d8 100644
--- a/drivers/net/dsa/ocelot/Makefile
+++ b/drivers/net/dsa/ocelot/Makefile
@@ -9,3 +9,8 @@ mscc_felix-objs := \
 mscc_seville-objs := \
 	felix.o \
 	seville_vsc9953.o
+
+ifdef CONFIG_NET_DSA_TAG_OCELOT_8021Q
+mscc_felix-objs += felix_tag_8021q.o
+mscc_seville-objs += felix_tag_8021q.o
+endif
diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 767cbdccdb3e..88ceed15e9cf 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -23,6 +23,7 @@
 #include <net/pkt_sched.h>
 #include <net/dsa.h>
 #include "felix.h"
+#include "felix_tag_8021q.h"
 
 static enum dsa_tag_protocol felix_get_tag_protocol(struct dsa_switch *ds,
 						    int port,
@@ -410,6 +411,7 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 {
 	struct ocelot *ocelot = &felix->ocelot;
 	phy_interface_t *port_phy_modes;
+	enum ocelot_tag_prefix prefix;
 	struct resource res;
 	int port, i, err;
 
@@ -419,14 +421,19 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 	if (!ocelot->ports)
 		return -ENOMEM;
 
+	if (IS_ENABLED(CONFIG_NET_DSA_TAG_OCELOT_NPI))
+		prefix = OCELOT_TAG_PREFIX_SHORT;
+	else if (IS_ENABLED(CONFIG_NET_DSA_TAG_OCELOT_8021Q))
+		prefix = OCELOT_TAG_PREFIX_NONE;
+
+	ocelot->inj_prefix	= prefix;
+	ocelot->xtr_prefix	= prefix;
 	ocelot->map		= felix->info->map;
 	ocelot->stats_layout	= felix->info->stats_layout;
 	ocelot->num_stats	= felix->info->num_stats;
 	ocelot->num_mact_rows	= felix->info->num_mact_rows;
 	ocelot->vcap		= felix->info->vcap;
 	ocelot->ops		= felix->info->ops;
-	ocelot->inj_prefix	= OCELOT_TAG_PREFIX_SHORT;
-	ocelot->xtr_prefix	= OCELOT_TAG_PREFIX_SHORT;
 	ocelot->devlink		= felix->ds->devlink;
 
 	port_phy_modes = kcalloc(num_phys_ports, sizeof(phy_interface_t),
@@ -549,6 +556,15 @@ static void felix_npi_port_init(struct ocelot *ocelot, int port)
 	ocelot_fields_write(ocelot, port, SYS_PAUSE_CFG_PAUSE_ENA, 0);
 }
 
+static void felix_8021q_cpu_port_init(struct ocelot *ocelot, int port)
+{
+	ocelot->ports[port]->is_dsa_8021q_cpu = true;
+	ocelot->npi = -1;
+
+	/* Overwrite PGID_CPU with the non-tagging port */
+	ocelot_write_rix(ocelot, BIT(port), ANA_PGID_PGID, PGID_CPU);
+}
+
 /* Hardware initialization done here so that we can allocate structures with
  * devm without fear of dsa_register_switch returning -EPROBE_DEFER and causing
  * us to allocate structures twice (leak memory) and map PCI memory twice
@@ -558,7 +574,7 @@ static int felix_setup(struct dsa_switch *ds)
 {
 	struct ocelot *ocelot = ds->priv;
 	struct felix *felix = ocelot_to_felix(ocelot);
-	int port, err;
+	int port, cpu = -1, err;
 
 	err = felix_init_structs(felix, ds->num_ports);
 	if (err)
@@ -578,10 +594,20 @@ static int felix_setup(struct dsa_switch *ds)
 	}
 
 	for (port = 0; port < ds->num_ports; port++) {
+		if (dsa_is_unused_port(ds, port))
+			continue;
+
 		ocelot_init_port(ocelot, port);
 
-		if (dsa_is_cpu_port(ds, port))
-			felix_npi_port_init(ocelot, port);
+		cpu = dsa_upstream_port(ds, port);
+		if (port == cpu)
+			continue;
+
+		/* Allow forwarding to and from the CPU port */
+		ocelot_rmw_rix(ocelot, BIT(cpu), BIT(cpu),
+			       ANA_PGID_PGID, PGID_SRC + port);
+		ocelot_rmw_rix(ocelot, BIT(port), BIT(port),
+			       ANA_PGID_PGID, PGID_SRC + cpu);
 
 		/* Set the default QoS Classification based on PCP and DEI
 		 * bits of vlan tag.
@@ -593,14 +619,70 @@ static int felix_setup(struct dsa_switch *ds)
 	if (err)
 		return err;
 
-	/* Include the CPU port module in the forwarding mask for unknown
-	 * unicast - the hardware default value for ANA_FLOODING_FLD_UNICAST
-	 * excludes BIT(ocelot->num_phys_ports), and so does ocelot_init, since
-	 * Ocelot relies on whitelisting MAC addresses towards PGID_CPU.
-	 */
-	ocelot_write_rix(ocelot,
-			 ANA_PGID_PGID_PGID(GENMASK(ocelot->num_phys_ports, 0)),
-			 ANA_PGID_PGID, PGID_UC);
+	if (IS_ENABLED(CONFIG_NET_DSA_TAG_OCELOT_NPI)) {
+		unsigned long flood_mask = BIT(ocelot->num_phys_ports);
+
+		felix_npi_port_init(ocelot, cpu);
+
+		/* Include the CPU port module (and indirectly, the NPI port)
+		 * in the forwarding mask for unknown unicast - the hardware
+		 * default value for ANA_FLOODING_FLD_UNICAST excludes
+		 * BIT(ocelot->num_phys_ports), and so does ocelot_init,
+		 * since Ocelot relies on whitelisting MAC addresses towards
+		 * PGID_CPU.
+		 * We do this because DSA does not yet perform RX filtering,
+		 * and the NPI port does not perform source address learning,
+		 * so traffic sent to Linux is effectively unknown from the
+		 * switch's perspective.
+		 */
+		for (port = 0; port < ds->num_ports; port++) {
+			if (dsa_is_unused_port(ds, port))
+				continue;
+
+			flood_mask |= BIT(port);
+		}
+
+		ocelot_write_rix(ocelot, ANA_PGID_PGID_PGID(flood_mask),
+				 ANA_PGID_PGID, PGID_UC);
+	} else if (IS_ENABLED(CONFIG_NET_DSA_TAG_OCELOT_8021Q)) {
+		unsigned long flood_mask = 0;
+
+		felix_8021q_cpu_port_init(ocelot, cpu);
+
+		for (port = 0; port < ds->num_ports; port++) {
+			if (dsa_is_unused_port(ds, port))
+				continue;
+
+			flood_mask |= BIT(port);
+
+			/* This overwrites ocelot_init():
+			 * Do not forward BPDU frames to the CPU port module,
+			 * for 2 reasons:
+			 * - When these packets are injected from the tag_8021q
+			 *   CPU port, we want them to go out, not loop back
+			 *   into the system.
+			 * - STP traffic ingressing on a user port should go to
+			 *   the tag_8021q CPU port, not to the hardware CPU
+			 *   port module.
+			 */
+			ocelot_write_gix(ocelot,
+					 ANA_PORT_CPU_FWD_BPDU_CFG_BPDU_REDIR_ENA(0),
+					 ANA_PORT_CPU_FWD_BPDU_CFG, port);
+		}
+
+		/* In tag_8021q mode, the CPU port module is unused. So we
+		 * want to disable flooding of any kind to the CPU port module
+		 * (which is BIT(ocelot->num_phys_ports)).
+		 */
+		ocelot_write_rix(ocelot, ANA_PGID_PGID_PGID(flood_mask),
+				 ANA_PGID_PGID, PGID_UC);
+		ocelot_write_rix(ocelot, ANA_PGID_PGID_PGID(flood_mask),
+				 ANA_PGID_PGID, PGID_MC);
+
+		err = felix_setup_8021q_tagging(ocelot);
+		if (err)
+			return err;
+	}
 
 	ds->mtu_enforcement_ingress = true;
 	ds->assisted_learning_on_cpu_port = true;
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index 994835cb9307..a2b579f4b6a5 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -48,6 +48,7 @@ struct felix {
 	struct lynx_pcs			**pcs;
 	resource_size_t			switch_base;
 	resource_size_t			imdio_base;
+	struct dsa_8021q_context	*dsa_8021q_ctx;
 };
 
 struct net_device *felix_port_to_netdev(struct ocelot *ocelot, int port);
diff --git a/drivers/net/dsa/ocelot/felix_tag_8021q.c b/drivers/net/dsa/ocelot/felix_tag_8021q.c
new file mode 100644
index 000000000000..0cbe5c19cc48
--- /dev/null
+++ b/drivers/net/dsa/ocelot/felix_tag_8021q.c
@@ -0,0 +1,173 @@
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
+#include <soc/mscc/ocelot_vcap.h>
+#include <linux/dsa/8021q.h>
+#include <linux/if_bridge.h>
+#include "felix.h"
+#include "felix_tag_8021q.h"
+
+static int felix_tag_8021q_rxvlan_add(struct felix *felix, int port, u16 vid,
+				      bool pvid, bool untagged)
+{
+	struct ocelot_vcap_filter *outer_tagging_rule;
+	struct ocelot *ocelot = &felix->ocelot;
+	struct dsa_switch *ds = felix->ds;
+	int key_length, upstream;
+
+	/* We don't need to install the rxvlan into the other ports' filtering
+	 * tables, because we're just pushing the rxvlan when sending towards
+	 * the CPU
+	 */
+	if (!pvid)
+		return 0;
+
+	key_length = ocelot->vcap[VCAP_ES0].keys[VCAP_ES0_IGR_PORT].length;
+	upstream = dsa_upstream_port(ds, port);
+
+	outer_tagging_rule = kzalloc(sizeof(struct ocelot_vcap_filter),
+				     GFP_KERNEL);
+	if (!outer_tagging_rule)
+		return -ENOMEM;
+
+	outer_tagging_rule->key_type = OCELOT_VCAP_KEY_ANY;
+	outer_tagging_rule->prio = 1;
+	outer_tagging_rule->id.cookie = port;
+	outer_tagging_rule->id.tc_offload = false;
+	outer_tagging_rule->block_id = VCAP_ES0;
+	outer_tagging_rule->type = OCELOT_VCAP_FILTER_OFFLOAD;
+	outer_tagging_rule->lookup = 0;
+	outer_tagging_rule->ingress_port.value = port;
+	outer_tagging_rule->ingress_port.mask = GENMASK(key_length - 1, 0);
+	outer_tagging_rule->egress_port.value = upstream;
+	outer_tagging_rule->egress_port.mask = GENMASK(key_length - 1, 0);
+	outer_tagging_rule->action.push_outer_tag = OCELOT_ES0_TAG;
+	outer_tagging_rule->action.tag_a_tpid_sel = OCELOT_TAG_TPID_SEL_8021AD;
+	outer_tagging_rule->action.tag_a_vid_sel = 1;
+	outer_tagging_rule->action.vid_a_val = vid;
+
+	return ocelot_vcap_filter_add(ocelot, outer_tagging_rule, NULL);
+}
+
+static int felix_tag_8021q_txvlan_add(struct felix *felix, int port, u16 vid,
+				      bool pvid, bool untagged)
+{
+	struct ocelot_vcap_filter *untagging_rule, *redirect_rule;
+	struct ocelot *ocelot = &felix->ocelot;
+	struct dsa_switch *ds = felix->ds;
+	int upstream, ret;
+
+	/* tag_8021q.c assumes we are implementing this via port VLAN
+	 * membership, which we aren't. So we don't need to add any VCAP filter
+	 * for the CPU port.
+	 */
+	if (ocelot->ports[port]->is_dsa_8021q_cpu)
+		return 0;
+
+	untagging_rule = kzalloc(sizeof(struct ocelot_vcap_filter), GFP_KERNEL);
+	if (!untagging_rule)
+		return -ENOMEM;
+
+	redirect_rule = kzalloc(sizeof(struct ocelot_vcap_filter), GFP_KERNEL);
+	if (!redirect_rule) {
+		kfree(untagging_rule);
+		return -ENOMEM;
+	}
+
+	upstream = dsa_upstream_port(ds, port);
+
+	untagging_rule->key_type = OCELOT_VCAP_KEY_ANY;
+	untagging_rule->ingress_port_mask = BIT(upstream);
+	untagging_rule->vlan.vid.value = vid;
+	untagging_rule->vlan.vid.mask = VLAN_VID_MASK;
+	untagging_rule->prio = 1;
+	untagging_rule->id.cookie = port;
+	untagging_rule->id.tc_offload = false;
+	untagging_rule->block_id = VCAP_IS1;
+	untagging_rule->type = OCELOT_VCAP_FILTER_OFFLOAD;
+	untagging_rule->lookup = 0;
+	untagging_rule->action.vlan_pop_cnt_ena = true;
+	untagging_rule->action.vlan_pop_cnt = 1;
+	untagging_rule->action.pag_override_mask = 0xff;
+	untagging_rule->action.pag_val = port;
+
+	ret = ocelot_vcap_filter_add(ocelot, untagging_rule, NULL);
+	if (ret) {
+		kfree(untagging_rule);
+		kfree(redirect_rule);
+		return ret;
+	}
+
+	redirect_rule->key_type = OCELOT_VCAP_KEY_ANY;
+	redirect_rule->ingress_port_mask = BIT(upstream);
+	redirect_rule->pag = port;
+	redirect_rule->prio = 1;
+	redirect_rule->id.cookie = port;
+	redirect_rule->id.tc_offload = false;
+	redirect_rule->block_id = VCAP_IS2;
+	redirect_rule->type = OCELOT_VCAP_FILTER_OFFLOAD;
+	redirect_rule->lookup = 0;
+	redirect_rule->action.mask_mode = OCELOT_MASK_MODE_REDIRECT;
+	redirect_rule->action.port_mask = BIT(port);
+
+	ret = ocelot_vcap_filter_add(ocelot, redirect_rule, NULL);
+	if (ret) {
+		ocelot_vcap_filter_del(ocelot, untagging_rule);
+		kfree(redirect_rule);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int felix_tag_8021q_vlan_add(struct dsa_switch *ds, int port, u16 vid,
+				    u16 flags)
+{
+	bool untagged = flags & BRIDGE_VLAN_INFO_UNTAGGED;
+	bool pvid = flags & BRIDGE_VLAN_INFO_PVID;
+	struct ocelot *ocelot = ds->priv;
+
+	if (vid_is_dsa_8021q_rxvlan(vid))
+		return felix_tag_8021q_rxvlan_add(ocelot_to_felix(ocelot),
+						  port, vid, pvid, untagged);
+
+	if (vid_is_dsa_8021q_txvlan(vid))
+		return felix_tag_8021q_txvlan_add(ocelot_to_felix(ocelot),
+						  port, vid, pvid, untagged);
+
+	return 0;
+}
+
+static const struct dsa_8021q_ops felix_tag_8021q_ops = {
+	.vlan_add	= felix_tag_8021q_vlan_add,
+};
+
+int felix_setup_8021q_tagging(struct ocelot *ocelot)
+{
+	struct felix *felix = ocelot_to_felix(ocelot);
+	struct dsa_switch *ds = felix->ds;
+	int ret;
+
+	felix->dsa_8021q_ctx = devm_kzalloc(ds->dev,
+					    sizeof(*felix->dsa_8021q_ctx),
+					    GFP_KERNEL);
+	if (!felix->dsa_8021q_ctx)
+		return -ENOMEM;
+
+	felix->dsa_8021q_ctx->ops = &felix_tag_8021q_ops;
+	felix->dsa_8021q_ctx->proto = htons(ETH_P_8021AD);
+	felix->dsa_8021q_ctx->ds = ds;
+
+	rtnl_lock();
+	ret = dsa_8021q_setup(felix->dsa_8021q_ctx, true);
+	rtnl_unlock();
+
+	return ret;
+}
diff --git a/drivers/net/dsa/ocelot/felix_tag_8021q.h b/drivers/net/dsa/ocelot/felix_tag_8021q.h
new file mode 100644
index 000000000000..a3501904e748
--- /dev/null
+++ b/drivers/net/dsa/ocelot/felix_tag_8021q.h
@@ -0,0 +1,20 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright 2020-2021 NXP Semiconductors
+ */
+#ifndef _MSCC_FELIX_TAG_8021Q_H
+#define _MSCC_FELIX_TAG_8021Q_H
+
+#if IS_ENABLED(CONFIG_NET_DSA_TAG_OCELOT_8021Q)
+
+int felix_setup_8021q_tagging(struct ocelot *ocelot);
+
+#else
+
+static inline int felix_setup_8021q_tagging(struct ocelot *ocelot)
+{
+	return -EOPNOTSUPP;
+}
+
+#endif /* IS_ENABLED(CONFIG_NET_DSA_TAG_OCELOT_8021Q) */
+
+#endif /* _MSCC_FELIX_TAG_8021Q_H */
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index a560d6be2a44..895df050abba 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -878,6 +878,7 @@ EXPORT_SYMBOL(ocelot_get_ts_info);
 
 void ocelot_bridge_stp_state_set(struct ocelot *ocelot, int port, u8 state)
 {
+	unsigned long cpu_fwd_mask = 0;
 	u32 port_cfg;
 	int p, i;
 
@@ -902,12 +903,31 @@ void ocelot_bridge_stp_state_set(struct ocelot *ocelot, int port, u8 state)
 
 	ocelot_write_gix(ocelot, port_cfg, ANA_PORT_PORT_CFG, port);
 
+	/* If a DSA tag_8021q CPU exists, it needs to be unconditionally
+	 * (i.e. regardless of whether the port is bridged or standalone)
+	 * included in the regular forwarding path, as opposed to the
+	 * hardware-based CPU port module which can be a destination for
+	 * packets even if it isn't part of PGID_SRC.
+	 */
+	for (p = 0; p < ocelot->num_phys_ports; p++)
+		if (ocelot->ports[p]->is_dsa_8021q_cpu)
+			cpu_fwd_mask |= BIT(p);
+
 	/* Apply FWD mask. The loop is needed to add/remove the current port as
 	 * a source for the other ports.
 	 */
 	for (p = 0; p < ocelot->num_phys_ports; p++) {
-		if (ocelot->bridge_fwd_mask & BIT(p)) {
-			unsigned long mask = ocelot->bridge_fwd_mask & ~BIT(p);
+		/* Standalone ports forward only to DSA tag_8021q CPU ports */
+		unsigned long mask = cpu_fwd_mask;
+
+		/* The DSA tag_8021q CPU ports need to be able to forward
+		 * packets to all other ports except for themselves
+		 */
+		if (ocelot->ports[p]->is_dsa_8021q_cpu) {
+			mask = GENMASK(ocelot->num_phys_ports - 1, 0);
+			mask &= ~cpu_fwd_mask;
+		} else if (ocelot->bridge_fwd_mask & BIT(p)) {
+			mask |= ocelot->bridge_fwd_mask & ~BIT(p);
 
 			for (i = 0; i < ocelot->num_phys_ports; i++) {
 				unsigned long bond_mask = ocelot->lags[i];
@@ -920,13 +940,9 @@ void ocelot_bridge_stp_state_set(struct ocelot *ocelot, int port, u8 state)
 					break;
 				}
 			}
-
-			ocelot_write_rix(ocelot, mask,
-					 ANA_PGID_PGID, PGID_SRC + p);
-		} else {
-			ocelot_write_rix(ocelot, 0,
-					 ANA_PGID_PGID, PGID_SRC + p);
 		}
+
+		ocelot_write_rix(ocelot, mask, ANA_PGID_PGID, PGID_SRC + p);
 	}
 }
 EXPORT_SYMBOL(ocelot_bridge_stp_state_set);
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index cdc33fa05660..360615c36ab9 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -610,6 +610,7 @@ struct ocelot_port {
 	phy_interface_t			phy_mode;
 
 	u8				*xmit_template;
+	bool				is_dsa_8021q_cpu;
 };
 
 struct ocelot {
diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
index 2d226a5c085f..cbef1477b355 100644
--- a/net/dsa/Kconfig
+++ b/net/dsa/Kconfig
@@ -111,6 +111,40 @@ config NET_DSA_TAG_OCELOT
 	  Say Y or M if you want to enable support for tagging frames for the
 	  Ocelot switches (VSC7511, VSC7512, VSC7513, VSC7514, VSC9959).
 
+choice
+	prompt "Tagging format"
+	depends on NET_DSA_TAG_OCELOT
+	default NET_DSA_TAG_OCELOT_NPI
+	help
+	  Choose the tagging format for frames delivered by the Ocelot
+	  switches to the CPU.
+
+config NET_DSA_TAG_OCELOT_NPI
+	bool "Native tagging over NPI"
+	help
+	  Say Y if you want to enable NPI tagging for the Ocelot switches.
+	  In this mode, the frames over the Ethernet CPU port are prepended
+	  with a hardware-defined injection/extraction frame header.
+	  Flow control (PAUSE frames) over the CPU port is not supported
+	  when operating in this mode.
+
+	  If unsure, say Y.
+
+config NET_DSA_TAG_OCELOT_8021Q
+	bool "VLAN-based tagging"
+	select NET_DSA_TAG_8021Q
+	help
+	  Say Y if you want to enable support for tagging frames with a custom
+	  VLAN-based header. Frames that require timestamping, such as PTP, are
+	  not delivered over Ethernet but over register-based MMIO. Flow
+	  control over the CPU port is functional in this mode. When using this
+	  mode, less TCAM resources (VCAP IS1, IS2, ES0) are available for use
+	  with tc-flower.
+
+	  If unsure, say N.
+
+endchoice
+
 config NET_DSA_TAG_QCA
 	tristate "Tag driver for Qualcomm Atheros QCA8K switches"
 	help
diff --git a/net/dsa/Makefile b/net/dsa/Makefile
index 92cea2132241..ca68bfbcb009 100644
--- a/net/dsa/Makefile
+++ b/net/dsa/Makefile
@@ -14,7 +14,8 @@ obj-$(CONFIG_NET_DSA_TAG_KSZ) += tag_ksz.o
 obj-$(CONFIG_NET_DSA_TAG_RTL4_A) += tag_rtl4_a.o
 obj-$(CONFIG_NET_DSA_TAG_LAN9303) += tag_lan9303.o
 obj-$(CONFIG_NET_DSA_TAG_MTK) += tag_mtk.o
-obj-$(CONFIG_NET_DSA_TAG_OCELOT) += tag_ocelot.o
+obj-$(CONFIG_NET_DSA_TAG_OCELOT_NPI) += tag_ocelot.o
+obj-$(CONFIG_NET_DSA_TAG_OCELOT_8021Q) += tag_ocelot_8021q.o
 obj-$(CONFIG_NET_DSA_TAG_QCA) += tag_qca.o
 obj-$(CONFIG_NET_DSA_TAG_SJA1105) += tag_sja1105.o
 obj-$(CONFIG_NET_DSA_TAG_TRAILER) += tag_trailer.o
diff --git a/net/dsa/tag_ocelot_8021q.c b/net/dsa/tag_ocelot_8021q.c
new file mode 100644
index 000000000000..290880b94bb3
--- /dev/null
+++ b/net/dsa/tag_ocelot_8021q.c
@@ -0,0 +1,61 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright 2020-2021 NXP Semiconductors
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
+	.name			= "ocelot",
+	.proto			= DSA_TAG_PROTO_OCELOT,
+	.xmit			= ocelot_xmit,
+	.rcv			= ocelot_rcv,
+	.overhead		= VLAN_HLEN,
+};
+
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_OCELOT);
+
+module_dsa_tag_driver(ocelot_netdev_ops);
-- 
2.25.1

