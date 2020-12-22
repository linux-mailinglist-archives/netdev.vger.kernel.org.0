Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 344AA2E0B1F
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 14:48:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727566AbgLVNrY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 08:47:24 -0500
Received: from mail-eopbgr70042.outbound.protection.outlook.com ([40.107.7.42]:47547
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727206AbgLVNrX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 08:47:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n8PnPN05o8UwM+XWZP0kjy40Cpu5iQYtItspklbeBeUAf1BJdMG9w0Z177rwjV2mIA8dWvTCBSAG2keXBX4+zPzFWIaVoET5cA6rMOx04o0OvDIUP8KhYh5t6YKLBevwZlik93VSyzX0n7NKNCmmubaxG3j9ZikV6i4uuppcgwJY2nJiL14K9NGHeROfea0x7jG70alT+WB3Rb5JezAFYSqjZfp2dO5BIw5JiokB94NRLq5OzN9k+SD/NNPQmpYGrLV1nzEszcsV47ZA4uVBRbaencvz78gLOLxLdWgjMkXrDjPmXTnaRt4Tjr/hwGYxdadKF8leyS7XXNHj4WEcxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jmzXs/oyVrzrP3yKPOZZiSkEqVD8MNn08SSzgLqTjnE=;
 b=keOYP+JxW2NmeRPh4V1aH232juAYGVmIsm1Pbys9shAdQVNSMhbiuc+r4ApdYB1UaXnRjYAj454JaPY9vM9MTS9Z15hGUnhWJlRS9yFw8l2F0NM0OwQ3o4mtCgQxcgUBII2JtxP/nts/EQ1ot+NIVLvZQ2aV8VfUHLPkKoHGrC20Qx9sokNE0KyBft6OcIooss9GTExNeLaB8MDw01dh24Bximd56Y8lksg9Hw+imb80X2pSh8JU3lkwqp2h8zZMPcQG6jCXVpJA0CrV8jA6c9hGOWrUAgeZnlBYu1vhf8ThE0evgWMDuNGqqGz5hee7i6J3RlBmcLTQoXzf3xbB8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jmzXs/oyVrzrP3yKPOZZiSkEqVD8MNn08SSzgLqTjnE=;
 b=M9qn5g3FmrpG+b6sEpooh20BDqLpjXPKf/W53dGGLjjLYG1kcDPiQzy21rkXQTkWq7LU4Rxg65zvuo9QrtShYxczPImd9Fz9aIZFleeez+tE1m7NN3X4X/iSrLDwP8eon6TjvZ+YZsGt97IVPbSz5+lFtGPZPSkvJNPcwj6Kd9s=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB7408.eurprd04.prod.outlook.com (2603:10a6:800:1b3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.25; Tue, 22 Dec
 2020 13:45:04 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3676.033; Tue, 22 Dec 2020
 13:45:04 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Hongbo Wang <hongbo.wang@nxp.com>, Po Liu <po.liu@nxp.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
Subject: [RFC PATCH v2 net-next 13/15] net: dsa: felix: setup MMIO filtering rules for PTP when using tag_8021q
Date:   Tue, 22 Dec 2020 15:44:37 +0200
Message-Id: <20201222134439.2478449-14-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201222134439.2478449-1-vladimir.oltean@nxp.com>
References: <20201222134439.2478449-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.120]
X-ClientProxiedBy: VI1PR08CA0169.eurprd08.prod.outlook.com
 (2603:10a6:800:d1::23) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.120) by VI1PR08CA0169.eurprd08.prod.outlook.com (2603:10a6:800:d1::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.29 via Frontend Transport; Tue, 22 Dec 2020 13:45:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 416d4351-e44a-4019-d29b-08d8a67fc9c9
X-MS-TrafficTypeDiagnostic: VE1PR04MB7408:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB740848EE3F5CC61E49800BA1E0DF0@VE1PR04MB7408.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MYL1ay0TTNNI50aG8Ext8mbBxHjIi7gLj/0Pbb2eRjUYepuxL9qLra/kKrPvMq/XYNA5wOiHpJ4Xy+ns8+kf4sm+ECmg1fkYgZHEcP9d8ORPyrzwon1tRgVB06nUsK2Xycg5kBgwmOhsfRpBKq2lwredPSvI430kzDLLe+I3msTWuw0AJNNzfjpaF8mMrWowZn7lS2BS+Ch8M1JfIQJm8j2lSgdlFZgpFz0BF0PQE9BtmYV7wcoVnmEy/An3jiYgBy8ozUskE1x6ATyWeNR9/8lWrqRGvSkRuPyXXstp87HuoID99JvU2rA2gsgswniKUXnp59oEoagF1rZ7kOacZdWT1KnHnjziQld5/Lfs4QG2yJDA6ByxD8oG3A+YeCKQ8c8CFbTw6D7PQlYixYhZOzBrhv8dIiHDy0si7B131V3nAMUoOV3eYrvaTANPOXfDEi7nFeojtHLO91gQZGNzAw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52116002)(69590400010)(8676002)(956004)(186003)(4326008)(36756003)(2616005)(6512007)(498600001)(16526019)(44832011)(2906002)(83380400001)(8936002)(110136005)(54906003)(26005)(6666004)(66476007)(5660300002)(6486002)(86362001)(6506007)(66946007)(1076003)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?hs7ogb7w8IIppnw0tb2SpxeSeErDOGPMkFM0HjKsBn5fZCN7x92bfYNeieWS?=
 =?us-ascii?Q?GHLWUvxYNoSTUlXAow49EtwTVW1zZZ7Jf/ZmgsApLpphHkQdzxi8mz/Pt3OL?=
 =?us-ascii?Q?TLPTQAwSYoynO52Qbu2CLpWMqmn5kEFc0qk1bZ55Ts0ZltaCz1Pc2IV7iZBI?=
 =?us-ascii?Q?xmf6lBWJgccgNiDXzg0kQUUwYfAdChJXEfYRRdHzQMwgVYXZZtOypzMlFFx8?=
 =?us-ascii?Q?IngOUOYdNuQvASZWaO6hNknO1xbql+7q6IAMLcp4z1DJXyTFlhPXxfKDka67?=
 =?us-ascii?Q?Cat2dhQ/g5Eb83myLHLJNpP37ffEBI4Bet03tm0s4uzoEg3Ym1lHPw8iqL+t?=
 =?us-ascii?Q?NMVMyHvRPcpmsVM/wCJkAgz3eq7aS0Y+7ZBPFBntBRJ73poDKZgl/GpCaet1?=
 =?us-ascii?Q?IiVPx1ts7j43gOsLrl41Bk2TtzySrop4yORMtMbxPy/ljg/So5atAnipz1Nl?=
 =?us-ascii?Q?S26Dazq36lml0bu0nmj+Z6ZTtrZPkekOd6ai1kORI7sdUNbCPTDDqC0qlppt?=
 =?us-ascii?Q?5h4ijH4i4FiMCtOq5y7P5Iy8YGyAOMO6ah5KPH6Y0ShsoEwBuXPVg6UQzbZF?=
 =?us-ascii?Q?9gsUhwUBR1A/8lDfAENSmJm6v8mts2ohXZ9dHFVMa8p/7W92PG3+/SIZiyKc?=
 =?us-ascii?Q?3CFwvI1aK9KgFw9srDARk5Mz4VZCsC2AAaUdgwlPrf/ulLcEQHtBCkGuznrE?=
 =?us-ascii?Q?bKDNLfflpABbzGhg0AuiFN3QjMeC2wyzBnE6yJDuAHfchZ/UiKhy4Xtg2Sc9?=
 =?us-ascii?Q?QZhvkWz44nZd+GtfZYsacCyPi5gJsLdpIiGGoeMa08nkOdiTaC6GIebfgIlZ?=
 =?us-ascii?Q?eerMx2E+0almSJaj/Gx28c4cjkuPKW8byqVwf7srlhQT0vkXzNol/ZM2DRCW?=
 =?us-ascii?Q?tc9WVOgPy0iyFiGqpdvjlyecb48J6CXsNg0hXzHIEnZE042ubiVNucfisndV?=
 =?us-ascii?Q?UCwfJUWc9R3YsCCbwIP06SHTEvY4aWt3T5phMi6l6GjnjO4osTKwKfFXjWak?=
 =?us-ascii?Q?IG3n?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2020 13:45:04.7910
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: 416d4351-e44a-4019-d29b-08d8a67fc9c9
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gb2iU5pq3OGyQMvq66APaQNYsAMEAMJhZg6y3J+gnliZgU7ZjWXC9qWRKx/FEu2GE7QaxcAS6FE6N2oGbu8/+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7408
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the tag_8021q tagger is software-defined, it has no means by
itself for retrieving hardware timestamps of PTP event messages.

Because we do want to support PTP on ocelot even with tag_8021q, we need
to use the CPU port module for that. The RX timestamp is present in the
Extraction Frame Header. And because we can't use NPI mode which redirects
the CPU queues to an "external CPU" (meaning the ARM CPU), then we need
to poll the CPU port module through the MMIO registers to retrieve TX
and RX timestamps.

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
Changes in v2:
Patch is new.

 drivers/net/dsa/ocelot/felix.h           | 13 ++++
 drivers/net/dsa/ocelot/felix_tag_8021q.c | 83 +++++++++++++++++++++++-
 drivers/net/dsa/ocelot/felix_vsc9959.c   |  1 +
 3 files changed, 96 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index 71f343326c00..c75a934c3e0b 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -25,6 +25,19 @@ struct felix_info {
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
index f209273bbf69..5243e55a8054 100644
--- a/drivers/net/dsa/ocelot/felix_tag_8021q.c
+++ b/drivers/net/dsa/ocelot/felix_tag_8021q.c
@@ -142,6 +142,85 @@ static const struct dsa_8021q_ops felix_tag_8021q_ops = {
 	.vlan_add	= felix_tag_8021q_vlan_add,
 };
 
+/* Set up a VCAP IS2 rule for delivering PTP frames to the CPU port module.
+ * If the NET_DSA_TAG_OCELOT_QUIRK_NO_XTR_IRQ is in place, then also copy those
+ * PTP frames to the tag_8021q CPU port.
+ */
+static int felix_setup_mmio_filtering(struct felix *felix)
+{
+	struct ocelot_vcap_filter *redirect_rule;
+	struct ocelot_vcap_filter *tagging_rule;
+	struct ocelot *ocelot = &felix->ocelot;
+	unsigned long ingress_port_mask;
+	int cpu = ocelot->dsa_8021q_cpu;
+	int ret;
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
+	ingress_port_mask = GENMASK(ocelot->num_phys_ports - 1, 0) & ~BIT(cpu);
+
+	tagging_rule->key_type = OCELOT_VCAP_KEY_ETYPE;
+	*(u16 *)tagging_rule->key.etype.etype.value = htons(ETH_P_1588);
+	*(u16 *)tagging_rule->key.etype.etype.mask = 0xffff;
+	tagging_rule->ingress_port_mask = ingress_port_mask;
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
+	redirect_rule->ingress_port_mask = ingress_port_mask;
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
+		redirect_rule->action.port_mask = BIT(cpu);
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
@@ -161,6 +240,8 @@ int felix_setup_8021q_tagging(struct ocelot *ocelot)
 	rtnl_lock();
 	ret = dsa_8021q_setup(felix->dsa_8021q_ctx, true);
 	rtnl_unlock();
+	if (ret)
+		return ret;
 
-	return ret;
+	return felix_setup_mmio_filtering(felix);
 }
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 2e5bbdca5ea4..3bbc500f28ea 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1362,6 +1362,7 @@ static const struct felix_info felix_info_vsc9959 = {
 	.num_tx_queues		= FELIX_NUM_TC,
 	.switch_pci_bar		= 4,
 	.imdio_pci_bar		= 0,
+	.quirk_no_xtr_irq	= true,
 	.ptp_caps		= &vsc9959_ptp_caps,
 	.mdio_bus_alloc		= vsc9959_mdio_bus_alloc,
 	.mdio_bus_free		= vsc9959_mdio_bus_free,
-- 
2.25.1

