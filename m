Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01F9B2FC47F
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 00:12:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729483AbhASXJz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 18:09:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727874AbhASXJH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 18:09:07 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99AA2C06179C
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 15:08:23 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id d22so12550294edy.1
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 15:08:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LyxXxRvUi0bAhOVvWuRP0bt/YzjpiLdip9bHEJV8C+U=;
        b=uq4tuAZpesYvLbyALjIIVFU8pwdB8e9dEXffFz8ylANfdWBSrwhws7z/hHDVuYvl6a
         EvuDX2W46DsHn6f5dS2hnPKwy6jnF6pVgyZK6tHFW0f/RFG8VExvRFd7+g/HThwP8xeI
         lA+fKfZXJMuSBP3qep/DgCWLAkd7b4MVC63LK1KKTPBrJWS8hqIy355q5/jSV4U61oWO
         i38gcNdhXuuaGGGXD7APanpnsYs6Ij3OYFVRTH6n1iN8oyQ0DoMuq0cwtSROTsO+NuGv
         CQOLLlwuVrT3bqGZpWwCQ89+q1nzgqxi5E6fddbV6odRo1dPHSBqfeG31JXxCiAubqIF
         nhLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LyxXxRvUi0bAhOVvWuRP0bt/YzjpiLdip9bHEJV8C+U=;
        b=s5K7QgRo7W+2DU1iXZJy+1z3i4ou63KoDIiecd8NsKSNQ/mVwPwhR4r8ECUPt0b7jx
         fPCTx0NUh1KBYmq3d2nBswjyRspl6HDyyHLGmVxI9VtSqS5Mn4QvnwlYaBRq9lPSmy2M
         72k6qhY4Z1S6w1NQSBKNsr1LGadhOppvbghj6NmCaGi5eEC5obouSXOQx2cfV8bbmXZE
         YHpU5LMdZuVuNwN3gizcByOuga6Q2njQ14EtuJ7mTf5JrCg0iVOi42XkFSNkqRXv20tD
         FktTK3RPwd3FNnX7lnNZP5IXPatIOGCs33SOfDgXl2bgbxZzDGLQczQgxTMcq1taSv5Y
         deCw==
X-Gm-Message-State: AOAM532XPrpHsG0vQ2G4Fy3a+Wpm1gQvSAjmKhie7fuD8Z/DtXpfEimr
        8JaROHByjyggQaSmjvBTswU=
X-Google-Smtp-Source: ABdhPJwPBYRMZy4KmKPYGRMR/0H5d5lvLEHyJ/xPqdTscV8wYQoaJOfsudjVM5j4Ufpy/A6vZSxGlA==
X-Received: by 2002:a05:6402:34c5:: with SMTP id w5mr5227889edc.65.1611097702242;
        Tue, 19 Jan 2021 15:08:22 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id lh26sm94197ejb.119.2021.01.19.15.08.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 15:08:21 -0800 (PST)
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
        Andrey L <al@b4comtech.com>, UNGLinuxDriver@microchip.com
Subject: [PATCH v4 net-next 15/16] net: dsa: felix: setup MMIO filtering rules for PTP when using tag_8021q
Date:   Wed, 20 Jan 2021 01:07:48 +0200
Message-Id: <20210119230749.1178874-16-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210119230749.1178874-1-olteanv@gmail.com>
References: <20210119230749.1178874-1-olteanv@gmail.com>
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
Changes in v4:
- Actually perform teardown.
- Squash with next one-line patch "net: dsa: felix: use promisc on
  master for PTP with tag_8021q".

Changes in v3:
Make as much use as possible of dsa_is_cpu_port and dsa_upstream_port as
possible instead of ocelot->dsa_8021q_cpu.

Changes in v2:
Patch is new.

 drivers/net/dsa/ocelot/felix.c         | 127 ++++++++++++++++++++++++-
 drivers/net/dsa/ocelot/felix.h         |  13 +++
 drivers/net/dsa/ocelot/felix_vsc9959.c |   1 +
 net/dsa/tag_ocelot_8021q.c             |   1 +
 4 files changed, 138 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index df43f4a40f83..cb05d795ef05 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -231,6 +231,120 @@ static const struct dsa_8021q_ops felix_tag_8021q_ops = {
 	.vlan_del	= felix_tag_8021q_vlan_del,
 };
 
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
+	*(u16 *)tagging_rule->key.etype.etype.value = htons(ETH_P_1588);
+	*(u16 *)tagging_rule->key.etype.etype.mask = 0xffff;
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
 static enum dsa_tag_protocol felix_get_tag_protocol(struct dsa_switch *ds,
 						    int port,
 						    enum dsa_tag_protocol mp)
@@ -370,9 +484,9 @@ static int felix_setup_tag_8021q(struct dsa_switch *ds, int cpu)
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
@@ -393,7 +507,7 @@ static int felix_setup_tag_8021q(struct dsa_switch *ds, int cpu)
 	err = dsa_8021q_setup(felix->dsa_8021q_ctx, true);
 	rtnl_unlock();
 
-	return err;
+	return felix_setup_mmio_filtering(felix);
 }
 
 static void felix_teardown_tag_8021q(struct dsa_switch *ds, int cpu)
@@ -402,6 +516,11 @@ static void felix_teardown_tag_8021q(struct dsa_switch *ds, int cpu)
 	struct felix *felix = ocelot_to_felix(ocelot);
 	int err, port;
 
+	err = felix_teardown_mmio_filtering(felix);
+	if (err)
+		dev_err(ds->dev, "felix_teardown_mmio_filtering returned %d",
+			err);
+
 	rtnl_lock();
 	err = dsa_8021q_setup(felix->dsa_8021q_ctx, false);
 	rtnl_unlock();
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index 9d4459f2fffb..eb85eac361db 100644
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
index e944868cc120..38224c0169c0 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1379,6 +1379,7 @@ static const struct felix_info felix_info_vsc9959 = {
 	.num_tx_queues		= OCELOT_NUM_TC,
 	.switch_pci_bar		= 4,
 	.imdio_pci_bar		= 0,
+	.quirk_no_xtr_irq	= true,
 	.ptp_caps		= &vsc9959_ptp_caps,
 	.mdio_bus_alloc		= vsc9959_mdio_bus_alloc,
 	.mdio_bus_free		= vsc9959_mdio_bus_free,
diff --git a/net/dsa/tag_ocelot_8021q.c b/net/dsa/tag_ocelot_8021q.c
index 09e10ade11f7..7bd45b66e9a4 100644
--- a/net/dsa/tag_ocelot_8021q.c
+++ b/net/dsa/tag_ocelot_8021q.c
@@ -60,6 +60,7 @@ static struct dsa_device_ops ocelot_netdev_ops = {
 	.xmit			= ocelot_xmit,
 	.rcv			= ocelot_rcv,
 	.overhead		= VLAN_HLEN,
+	.promisc_on_master	= true,
 };
 
 MODULE_LICENSE("GPL v2");
-- 
2.25.1

