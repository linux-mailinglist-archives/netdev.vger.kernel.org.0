Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6CFE31AE59
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 23:41:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbhBMWlD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 17:41:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbhBMWjq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 17:39:46 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE37DC0617A7
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 14:38:31 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id i8so5398739ejc.7
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 14:38:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5f/fblgwKtn7Aw/atHU4xTeKd8DVFuAnjpQTe2OdGqQ=;
        b=ZC7oiVUiDdhZQNTimL/owVyWY4NkxnOdVUbk6zoX5CM1LV6EGhohq70T4wD+EmXFrG
         BssvEQnOT99egAhs4zxcC8V2R0kh+F2pi4uftaCZghAudmmE7h3xX61cYCDUpaghUbA/
         k9pV5FLzVxzq/goIlO/rMauhLe94FFOALQ1TUmfrPp3SMmHGJFiWIbQ2rp5QKIJZjwWV
         DT3KG7L6O8DhnXFkMRxj2fOJpadujoGeXa01uW//Ewv5jj9ktKHewLwc6YJ9atgCff+G
         pzvwbPbXAaPiDOTcasTtCegwAfWs7s6pKyPRTGBiijGk74MbGVaRdEcOvb8g7z7ex6S3
         9pvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5f/fblgwKtn7Aw/atHU4xTeKd8DVFuAnjpQTe2OdGqQ=;
        b=UIPwM3CNIVfORHJ0kzdZ44JtIZ7USfXRjPg+j1x5kLBI9u5ohINnLljMTNeipAcaNd
         yAOgRdRx1Tm07L18oG8acMEKmZtuviAEbKwNJbF+/tImAjYUA7cjSkSOGYxNE0Fy2RfB
         S7HXojaIohf2yw+xC/gtmqwOfrQOyH25SVfClOrsZVlOI5nrbt5RWGNLa9ECkj9vtEY+
         2DmtafB+jY6qYrnCOiLthsBk1V7We096blWqR6VAYCVXl1RJhiCwtH3KGeyfnKyOWW0g
         n1y0sZPfJrPLO8iISIT398jwAI6Cag7UXlCUxawt4WupqS3AyDm9cadEHt9P4x9lD6ux
         xauA==
X-Gm-Message-State: AOAM5327OiQJ9IWLQkq3+3DjpRibBxx00A3wTZKkZ9XCbgMufgFPr6L4
        k1w7m9vPhcOK/6CE92EXb60=
X-Google-Smtp-Source: ABdhPJzw1RipLZCr589T/umVCFepDwjxe9+WDImhHThsgAOuHxhOyjgMd2fGWEtV5wOVoJGnHWq1Eg==
X-Received: by 2002:a17:906:af6b:: with SMTP id os11mr9113739ejb.472.1613255910537;
        Sat, 13 Feb 2021 14:38:30 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id h3sm7662582edw.18.2021.02.13.14.38.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Feb 2021 14:38:30 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH v2 net-next 11/12] net: dsa: felix: setup MMIO filtering rules for PTP when using tag_8021q
Date:   Sun, 14 Feb 2021 00:38:00 +0200
Message-Id: <20210213223801.1334216-12-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210213223801.1334216-1-olteanv@gmail.com>
References: <20210213223801.1334216-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Since the tag_8021q tagger is software-defined, it has no means by
itself for retrieving hardware timestamps of PTP event messages.

Because we do want to support PTP on ocelot even with tag_8021q, we need
to use the CPU port module for that. The RX timestamp is present in the
Extraction Frame Header. And because we can't use NPI mode which redirects
the CPU queues to an "external CPU" (meaning the ARM CPU running Linux),
then we need to poll the CPU port module through the MMIO registers to
retrieve TX and RX timestamps.

Sadly, on NXP LS1028A, the Felix switch was integrated into the SoC
without wiring the extraction IRQ line to the ARM GIC. So, if we want to
be notified of any PTP packets received on the CPU port module, we have
a problem.

There is a possible workaround, which is to use the Ethernet CPU port as
a notification channel that packets are available on the CPU port module
as well. When a PTP packet is received by the DSA tagger (without timestamp,
of course), we go to the CPU extraction queues, poll for it there, then
we drop the original Ethernet packet and masquerade the packet retrieved
over MMIO (plus the timestamp) as the original when we inject it up the
stack.

Create a quirk in struct felix is selected by the Felix driver (but not
by Seville, since that doesn't support PTP at all). We want to do this
such that the workaround is minimally invasive for future switches that
don't require this workaround.

The only traffic for which we need timestamps is PTP traffic, so add a
redirection rule to the CPU port module for this. Currently we only have
the need for PTP over L2, so redirection rules for UDP ports 319 and 320
are TBD for now.

Note that for the workaround of matching of PTP-over-Ethernet-port with
PTP-over-MMIO queues to work properly, both channels need to be
absolutely lossless. There are two parts to achieving that:
- We keep flow control enabled on the tag_8021q CPU port
- We put the DSA master interface in promiscuous mode, so it will never
  drop a PTP frame (for the profiles we are interested in, these are
  sent to the multicast MAC addresses of 01-80-c2-00-00-0e and
  01-1b-19-00-00-00).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
None.

 drivers/net/dsa/ocelot/felix.c         | 131 ++++++++++++++++++++++++-
 drivers/net/dsa/ocelot/felix.h         |  13 +++
 drivers/net/dsa/ocelot/felix_vsc9959.c |   1 +
 net/dsa/tag_ocelot_8021q.c             |   1 +
 4 files changed, 143 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index f294f5f62505..d3b18aa6a582 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -264,6 +264,120 @@ static void felix_8021q_cpu_port_deinit(struct ocelot *ocelot, int port)
 	ocelot_apply_bridge_fwd_mask(ocelot);
 }
 
+/* Set up a VCAP IS2 rule for delivering PTP frames to the CPU port module.
+ * If the quirk_no_xtr_irq is in place, then also copy those PTP frames to the
+ * tag_8021q CPU port.
+ */
+static int felix_setup_mmio_filtering(struct felix *felix)
+{
+	unsigned long user_ports = 0, cpu_ports = 0;
+	struct ocelot_vcap_filter *redirect_rule;
+	struct ocelot_vcap_filter *tagging_rule;
+	struct ocelot *ocelot = &felix->ocelot;
+	struct dsa_switch *ds = felix->ds;
+	int port, ret;
+
+	tagging_rule = kzalloc(sizeof(struct ocelot_vcap_filter), GFP_KERNEL);
+	if (!tagging_rule)
+		return -ENOMEM;
+
+	redirect_rule = kzalloc(sizeof(struct ocelot_vcap_filter), GFP_KERNEL);
+	if (!redirect_rule) {
+		kfree(tagging_rule);
+		return -ENOMEM;
+	}
+
+	for (port = 0; port < ocelot->num_phys_ports; port++) {
+		if (dsa_is_user_port(ds, port))
+			user_ports |= BIT(port);
+		if (dsa_is_cpu_port(ds, port))
+			cpu_ports |= BIT(port);
+	}
+
+	tagging_rule->key_type = OCELOT_VCAP_KEY_ETYPE;
+	*(__be16 *)tagging_rule->key.etype.etype.value = htons(ETH_P_1588);
+	*(__be16 *)tagging_rule->key.etype.etype.mask = htons(0xffff);
+	tagging_rule->ingress_port_mask = user_ports;
+	tagging_rule->prio = 1;
+	tagging_rule->id.cookie = ocelot->num_phys_ports;
+	tagging_rule->id.tc_offload = false;
+	tagging_rule->block_id = VCAP_IS1;
+	tagging_rule->type = OCELOT_VCAP_FILTER_OFFLOAD;
+	tagging_rule->lookup = 0;
+	tagging_rule->action.pag_override_mask = 0xff;
+	tagging_rule->action.pag_val = ocelot->num_phys_ports;
+
+	ret = ocelot_vcap_filter_add(ocelot, tagging_rule, NULL);
+	if (ret) {
+		kfree(tagging_rule);
+		kfree(redirect_rule);
+		return ret;
+	}
+
+	redirect_rule->key_type = OCELOT_VCAP_KEY_ANY;
+	redirect_rule->ingress_port_mask = user_ports;
+	redirect_rule->pag = ocelot->num_phys_ports;
+	redirect_rule->prio = 1;
+	redirect_rule->id.cookie = ocelot->num_phys_ports;
+	redirect_rule->id.tc_offload = false;
+	redirect_rule->block_id = VCAP_IS2;
+	redirect_rule->type = OCELOT_VCAP_FILTER_OFFLOAD;
+	redirect_rule->lookup = 0;
+	redirect_rule->action.cpu_copy_ena = true;
+	if (felix->info->quirk_no_xtr_irq) {
+		/* Redirect to the tag_8021q CPU but also copy PTP packets to
+		 * the CPU port module
+		 */
+		redirect_rule->action.mask_mode = OCELOT_MASK_MODE_REDIRECT;
+		redirect_rule->action.port_mask = cpu_ports;
+	} else {
+		/* Trap PTP packets only to the CPU port module (which is
+		 * redirected to the NPI port)
+		 */
+		redirect_rule->action.mask_mode = OCELOT_MASK_MODE_PERMIT_DENY;
+		redirect_rule->action.port_mask = 0;
+	}
+
+	ret = ocelot_vcap_filter_add(ocelot, redirect_rule, NULL);
+	if (ret) {
+		ocelot_vcap_filter_del(ocelot, tagging_rule);
+		kfree(redirect_rule);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int felix_teardown_mmio_filtering(struct felix *felix)
+{
+	struct ocelot_vcap_filter *tagging_rule, *redirect_rule;
+	struct ocelot_vcap_block *block_vcap_is1;
+	struct ocelot_vcap_block *block_vcap_is2;
+	struct ocelot *ocelot = &felix->ocelot;
+	int err;
+
+	block_vcap_is1 = &ocelot->block[VCAP_IS1];
+	block_vcap_is2 = &ocelot->block[VCAP_IS2];
+
+	tagging_rule = ocelot_vcap_block_find_filter_by_id(block_vcap_is1,
+							   ocelot->num_phys_ports,
+							   false);
+	if (!tagging_rule)
+		return -ENOENT;
+
+	err = ocelot_vcap_filter_del(ocelot, tagging_rule);
+	if (err)
+		return err;
+
+	redirect_rule = ocelot_vcap_block_find_filter_by_id(block_vcap_is2,
+							    ocelot->num_phys_ports,
+							    false);
+	if (!redirect_rule)
+		return -ENOENT;
+
+	return ocelot_vcap_filter_del(ocelot, redirect_rule);
+}
+
 static int felix_setup_tag_8021q(struct dsa_switch *ds, int cpu)
 {
 	struct ocelot *ocelot = ds->priv;
@@ -292,9 +406,9 @@ static int felix_setup_tag_8021q(struct dsa_switch *ds, int cpu)
 				 ANA_PORT_CPU_FWD_BPDU_CFG, port);
 	}
 
-	/* In tag_8021q mode, the CPU port module is unused. So we
-	 * want to disable flooding of any kind to the CPU port module,
-	 * since packets going there will end in a black hole.
+	/* In tag_8021q mode, the CPU port module is unused, except for PTP
+	 * frames. So we want to disable flooding of any kind to the CPU port
+	 * module, since packets going there will end in a black hole.
 	 */
 	cpu_flood = ANA_PGID_PGID_PGID(BIT(ocelot->num_phys_ports));
 	ocelot_rmw_rix(ocelot, 0, cpu_flood, ANA_PGID_PGID, PGID_UC);
@@ -314,8 +428,14 @@ static int felix_setup_tag_8021q(struct dsa_switch *ds, int cpu)
 	if (err)
 		goto out_free_dsa_8021_ctx;
 
+	err = felix_setup_mmio_filtering(felix);
+	if (err)
+		goto out_teardown_dsa_8021q;
+
 	return 0;
 
+out_teardown_dsa_8021q:
+	dsa_8021q_setup(felix->dsa_8021q_ctx, false);
 out_free_dsa_8021_ctx:
 	kfree(felix->dsa_8021q_ctx);
 	return err;
@@ -327,6 +447,11 @@ static void felix_teardown_tag_8021q(struct dsa_switch *ds, int cpu)
 	struct felix *felix = ocelot_to_felix(ocelot);
 	int err, port;
 
+	err = felix_teardown_mmio_filtering(felix);
+	if (err)
+		dev_err(ds->dev, "felix_teardown_mmio_filtering returned %d",
+			err);
+
 	err = dsa_8021q_setup(felix->dsa_8021q_ctx, false);
 	if (err)
 		dev_err(ds->dev, "dsa_8021q_setup returned %d", err);
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index b2ea425c5803..4d96cad815d5 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -23,6 +23,19 @@ struct felix_info {
 	int				switch_pci_bar;
 	int				imdio_pci_bar;
 	const struct ptp_clock_info	*ptp_caps;
+
+	/* Some Ocelot switches are integrated into the SoC without the
+	 * extraction IRQ line connected to the ARM GIC. By enabling this
+	 * workaround, the few packets that are delivered to the CPU port
+	 * module (currently only PTP) are copied not only to the hardware CPU
+	 * port module, but also to the 802.1Q Ethernet CPU port, and polling
+	 * the extraction registers is triggered once the DSA tagger sees a PTP
+	 * frame. The Ethernet frame is only used as a notification: it is
+	 * dropped, and the original frame is extracted over MMIO and annotated
+	 * with the RX timestamp.
+	 */
+	bool				quirk_no_xtr_irq;
+
 	int	(*mdio_bus_alloc)(struct ocelot *ocelot);
 	void	(*mdio_bus_free)(struct ocelot *ocelot);
 	void	(*phylink_validate)(struct ocelot *ocelot, int port,
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 32b885fcaf90..5ff623ee76a6 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1354,6 +1354,7 @@ static const struct felix_info felix_info_vsc9959 = {
 	.num_tx_queues		= OCELOT_NUM_TC,
 	.switch_pci_bar		= 4,
 	.imdio_pci_bar		= 0,
+	.quirk_no_xtr_irq	= true,
 	.ptp_caps		= &vsc9959_ptp_caps,
 	.mdio_bus_alloc		= vsc9959_mdio_bus_alloc,
 	.mdio_bus_free		= vsc9959_mdio_bus_free,
diff --git a/net/dsa/tag_ocelot_8021q.c b/net/dsa/tag_ocelot_8021q.c
index 8991ebf098a3..190255d06bef 100644
--- a/net/dsa/tag_ocelot_8021q.c
+++ b/net/dsa/tag_ocelot_8021q.c
@@ -60,6 +60,7 @@ static const struct dsa_device_ops ocelot_8021q_netdev_ops = {
 	.xmit			= ocelot_xmit,
 	.rcv			= ocelot_rcv,
 	.overhead		= VLAN_HLEN,
+	.promisc_on_master	= true,
 };
 
 MODULE_LICENSE("GPL v2");
-- 
2.25.1

