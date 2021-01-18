Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AAFE2FA5ED
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 17:20:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406573AbhARQTx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 11:19:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406517AbhARQTT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 11:19:19 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF51CC061796
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 08:18:01 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id hs11so22138451ejc.1
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 08:18:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JxuhIcfZGAh8VQ5o5GLOfRTzORwBDEhXrs7w1DLvGpg=;
        b=e/mau1us+oHJddPMHKO/dUmwBvPwqaTTXiYo698o62CgujhwOhd2h5sR32z1qwT6Ob
         dArZUxC6ormkkyejFEeZvvGB1jBM7AGxrVPTMTvhtTtTD4SvBs5RDe0QRz87SxQLAvie
         U0lINXpZcgFnaQwWbuSG8tWTmxqXqdFdcLXSd06AFEQznEgecVMpRIew/++VtKKU4Vlj
         qdiu1nwjQUBAFam9JVyqL4zYN4ofUAmnCISyfi5wy+H4bQQTjBX8vb/3HYeG6dwm/CCZ
         qA2Wmj8jKg59EGPxEaLe6RxEEmLz714lKIkzESCafS5Np4We29RLv2O23FCQEsIXtkXr
         GMUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JxuhIcfZGAh8VQ5o5GLOfRTzORwBDEhXrs7w1DLvGpg=;
        b=ayYFeXIqfd/Jdnmuq4HpXAjvqRtl2qZtrPh51btJEqETbr+eDenDymlBlOrWNhMZRZ
         lSYy3gkiKJfcEsLUgXmRVbkVzJroop0iiiCWVziTLb+tSQ0Lbrqlner/DtYPChb05nQM
         tFtgnNo3q3tyrc8J0Br/4dhNfo/h7jEyMFTTbfw4qXwtWaelmXNKgCJQn+kPudOBjkP8
         vj5jYSZrnsQIZ20CK7xoKfIPnHfTRV6nNmr/rTTDFKF79mRSasPPAqlUdJPzL26zSPLP
         jQCQ+Um4NreMV1JrNU+WRSMssckowWTjHWDIzj7yZpFCvyR65DAYVJERC+LPfE43VyjC
         8mxQ==
X-Gm-Message-State: AOAM532nionIW7SjBkLPviOa2GhAgqvGTSGhtNtqVAyTPJHF8+mrF6M8
        hyqwR6pl3S2dI4btkiCgKKY=
X-Google-Smtp-Source: ABdhPJyqH32siY4ib4xv5pWyROXdSIux9TQjIzm3ZEw1suyA3KEdSK3HMwBZmVUSZEpBgOTjlTV71g==
X-Received: by 2002:a17:906:a453:: with SMTP id cb19mr275608ejb.459.1610986680470;
        Mon, 18 Jan 2021 08:18:00 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id u23sm6093781edt.78.2021.01.18.08.17.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 08:17:59 -0800 (PST)
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
Subject: [PATCH v3 net-next 13/15] net: dsa: felix: setup MMIO filtering rules for PTP when using tag_8021q
Date:   Mon, 18 Jan 2021 18:17:29 +0200
Message-Id: <20210118161731.2837700-14-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210118161731.2837700-1-olteanv@gmail.com>
References: <20210118161731.2837700-1-olteanv@gmail.com>
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

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v3:
Make as much use as possible of dsa_is_cpu_port and dsa_upstream_port as
possible instead of ocelot->dsa_8021q_cpu.

Changes in v2:
Patch is new.

 drivers/net/dsa/ocelot/felix.h           | 13 ++++
 drivers/net/dsa/ocelot/felix_tag_8021q.c | 88 +++++++++++++++++++++++-
 drivers/net/dsa/ocelot/felix_vsc9959.c   |  1 +
 3 files changed, 101 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index a2b579f4b6a5..8069e10ff9da 100644
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
diff --git a/drivers/net/dsa/ocelot/felix_tag_8021q.c b/drivers/net/dsa/ocelot/felix_tag_8021q.c
index 0cbe5c19cc48..84abfd2eb8a7 100644
--- a/drivers/net/dsa/ocelot/felix_tag_8021q.c
+++ b/drivers/net/dsa/ocelot/felix_tag_8021q.c
@@ -149,6 +149,90 @@ static const struct dsa_8021q_ops felix_tag_8021q_ops = {
 	.vlan_add	= felix_tag_8021q_vlan_add,
 };
 
+/* Set up a VCAP IS2 rule for delivering PTP frames to the CPU port module.
+ * If the NET_DSA_TAG_OCELOT_QUIRK_NO_XTR_IRQ is in place, then also copy those
+ * PTP frames to the tag_8021q CPU port.
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
 int felix_setup_8021q_tagging(struct ocelot *ocelot)
 {
 	struct felix *felix = ocelot_to_felix(ocelot);
@@ -168,6 +252,8 @@ int felix_setup_8021q_tagging(struct ocelot *ocelot)
 	rtnl_lock();
 	ret = dsa_8021q_setup(felix->dsa_8021q_ctx, true);
 	rtnl_unlock();
+	if (ret)
+		return ret;
 
-	return ret;
+	return felix_setup_mmio_filtering(felix);
 }
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index f9711e69b8d5..2f459f17fce3 100644
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
-- 
2.25.1

