Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A72A626C0F6
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 11:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbgIPJqp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 05:46:45 -0400
Received: from mail-eopbgr00062.outbound.protection.outlook.com ([40.107.0.62]:43246
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726794AbgIPJqY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Sep 2020 05:46:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YOGz2icBpkA1Jwm4Y95PoqWdhoENF3ypCg0E32zro6AaKjy2KkcszQ4OBgwkBb/OCSVEZfOw/OtBAveVbUZ7hj0vMOIJKfQckqzcaQnTYB99QwOhJRkvFONCHCCihSqJEu/L+Z8HAZN6FFC+y0iyr9UTNTg/e3sbhynRr5bzjGoaaiXCzGnnE5SdpT2Witw72RntsAMzCXGqD6V4rtp8/tgkpg4fl8/ypFLWmno3mtCohiFAvL5lR/PXm5czxJaxnXJE3CjcxZKQdvJvN4wUkn2ndbn69ssoA1Ny8sUqO8oMpcWOxQgoBP0aZ0X+gjWIeQ+tTxTdXNh6fhBccYeowA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oeRm0/kiV1AxVrYap4Liis9t62dhd9aumvUOve1il48=;
 b=CzkYwHY8t+YyY/OmYPACUc74M6BAGvKfQzbICaA/osdkGqMYCD/7foEwsxgVGar6NIJ8erxFqwVZYLJzqFuKVt57JEhXAWl7gS2QKp3l1BMgx8KIJrgyxECzDAYMkvzVzpNfILxrtyqeTJ6xiOQM4gio4gG96YAyKGAIxsSJ5KcEJOFiGWQDHmmgrvNWLiUWykw0DD6biEI5Wlxb+3ZW2Ro08H08s6HEBvt5xElPiWjgO0TaZotAvcaGuObNO1bqOd5ov5go7xQSwsPuxDcsFQc2iM3rdJx52PklDYtxf+YU1CjLWqcd2lXr/sZv5UTXEIAT8NnqNuFwsxF0F7YaSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oeRm0/kiV1AxVrYap4Liis9t62dhd9aumvUOve1il48=;
 b=SbJbHBpvqV6oG6StmBzFalkCsQyIL2CJLQ0vWPAzvG2KZ7dGGuyDwDmyO3jp7hwsryuBrdJnE4ZfZU5J04HlofBvMT4NVzkBGca0Gt8QvWH/b8beylNchBkULujCRtCYGSTiazG2i9ks0iXufsWSY7OQdTxOaUnHpSlvO17OF+g=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5677.eurprd04.prod.outlook.com (2603:10a6:803:ed::22)
 by VI1PR04MB6078.eurprd04.prod.outlook.com (2603:10a6:803:f2::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Wed, 16 Sep
 2020 09:46:19 +0000
Received: from VI1PR04MB5677.eurprd04.prod.outlook.com
 ([fe80::c99:9749:3211:2e1f]) by VI1PR04MB5677.eurprd04.prod.outlook.com
 ([fe80::c99:9749:3211:2e1f%5]) with mapi id 15.20.3370.019; Wed, 16 Sep 2020
 09:46:19 +0000
From:   hongbo.wang@nxp.com
To:     xiaoliang.yang_1@nxp.com, po.liu@nxp.com, mingkai.hu@nxp.com,
        allan.nielsen@microchip.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, vladimir.oltean@nxp.com,
        leoyang.li@nxp.com, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, davem@davemloft.net, jiri@resnulli.us,
        idosch@idosch.org, kuba@kernel.org, vinicius.gomes@intel.com,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        horatiu.vultur@microchip.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, ivecera@redhat.com
Cc:     "hongbo.wang" <hongbo.wang@nxp.com>
Subject: [PATCH v6 3/3] net: dsa: ocelot: Add support for QinQ Operation
Date:   Wed, 16 Sep 2020 17:48:45 +0800
Message-Id: <20200916094845.10782-4-hongbo.wang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200916094845.10782-1-hongbo.wang@nxp.com>
References: <20200916094845.10782-1-hongbo.wang@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0091.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:15::44) To VI1PR04MB5677.eurprd04.prod.outlook.com
 (2603:10a6:803:ed::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from whb-OptiPlex-790.ap.freescale.net (119.31.174.73) by AM0PR10CA0091.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:15::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.14 via Frontend Transport; Wed, 16 Sep 2020 09:46:09 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.73]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f85f356c-f88c-4688-9fbd-08d85a255c74
X-MS-TrafficTypeDiagnostic: VI1PR04MB6078:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB60782F011ABD2BE6A51C7616E1210@VI1PR04MB6078.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q0cAejkHE3I1qbzc98eO1bY5M7SkSRRIvyiVU8t6voEd4aKHrIDlVUid3LNrUiiTmNRnuzDQYgTO0F32H1paYvLrUM4cQVBiYCghnyMLirOjJYP9QNJfRUJ/H2rx/McbTxKaHwntIod4PWqCqAM1fvXplFmNirQO7TsC0RfUBiD5S9rHLanuRsuaqZIsPlTlv3KefpnNeFzAVWiC7wl2z/yuDm0SOpFaa5PZGdCvNR5s21Z6QgqyUggjbK8b6bWqmMtnPGTE467dPT0EfqaNuWHD+MmhOpCK4JCb69Rg09W2Z9bbI7qekZ4Fy3xdSI2INgK0vGhmvu1iLeK7Fq+gVo2aJh5OYL/6r3ZWn4fpd2pHEllmTwskSurpnry0mUQ2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5677.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(376002)(346002)(396003)(366004)(136003)(8936002)(83380400001)(6506007)(9686003)(186003)(16526019)(52116002)(8676002)(36756003)(316002)(66476007)(66556008)(66946007)(6512007)(478600001)(2906002)(4326008)(7416002)(1076003)(26005)(6666004)(6486002)(86362001)(5660300002)(956004)(2616005)(921003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: JYnuRrw9yabgX+kqc+Y7EJf/eZxI0y+4qwBh+lWvy5WfY0/E+MeaeGJHeyqRa/+jMh2chUOueqyOyzl2tO9o82pjXBgwqXPaZjxOu9AO39mkSdPkwNr1sDCx439ouDh1Wxz5TOfSvpynWyM2Pt7XGwVirAF5Tv9oPdk+kkvPsx7hGbc5qPckg/kSFL2u6D5hwWWutco04GE4KLU4srz6Osj/cYXAeJ9CP1S1LJ+da70Hq2NHsuzD5rpHut16URFLrKPi5hGFZXpmAJP1Gl46day6XqG29zbir/miVkAFCscGEmtrqqaSTmbBdaGZMABnhUq0hN3W///TENSVbNv8/sEKIlcPTc92rb98Y8hBCBxT4jKeUQylXEph8J1i/Rm3x+S6QmaUF4Xlf+JYVLbIvQMIVwR9VZuhwjyLDhogeU45ubGSWSTIOXwz7SIo5H2g6IDN+GhMIIEgT9vdHelJUhMJoMz9vdE067SG2e3dFuIGXbAKCRhlBrA/s+WFgl0KRw3frUiVHQ1MND8DizD4xN0E5WVpTEOJYX4fYFB4/B2/h8UEyScM4YTDsuTMIIy0eAIj+Q0gR31G6GKDnuSLgMUNP++eaNi4IfRmKonNvPwcKjMoR67+gZNrPbY+IJLXdcSk3SCjsxdWGBSjd9tTVA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f85f356c-f88c-4688-9fbd-08d85a255c74
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5677.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2020 09:46:19.2407
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TdQeOG8qLw7JxsW5Wsu+Ic12n9BAOwWVMNLjdrzRkSLy/bUwJAuachKK9/fYVFHRfsjOcKZUezSAfJRWdbGZgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6078
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "hongbo.wang" <hongbo.wang@nxp.com>

This feature can be test in the following case:
Customer <-----> swp0  <-----> swp1 <-----> ISP

Customer will send and receive packets with single VLAN tag(CTAG),
ISP will send and receive packets with double VLAN tag(STAG and CTAG).
This refers to "4.3.3 Provider Bridges and Q-in-Q Operation" in
VSC99599_1_00_TS.pdf.

The related test commands:
1.
devlink dev param set pci/0000:00:00.5 name qinq_port_bitmap \
value 2 cmode runtime
2.
ip link add dev br0 type bridge vlan_protocol 802.1ad
ip link set dev swp0 master br0
ip link set dev swp1 master br0
ip link set dev br0 type bridge vlan_filtering 1
3.
bridge vlan del dev swp0 vid 1 pvid
bridge vlan add dev swp0 vid 100 pvid untagged
bridge vlan add dev swp1 vid 100
Result:
Customer(tpid:8100 vid:111) -> swp0 -> swp1 -> ISP(STAG \
            tpid:88A8 vid:100, CTAG tpid:8100 vid:111)
ISP(tpid:88A8 vid:100 tpid:8100 vid:222) -> swp1 -> swp0 ->\
            Customer(tpid:8100 vid:222)

Signed-off-by: hongbo.wang <hongbo.wang@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c     | 123 +++++++++++++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot.c |  39 +++++++--
 include/soc/mscc/ocelot.h          |   4 +
 3 files changed, 160 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index a1e1d3824110..5888b0fa5669 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -148,9 +148,26 @@ static void felix_vlan_add(struct dsa_switch *ds, int port,
 				vid, port, err);
 			return;
 		}
+
+		if (vlan->proto == ETH_P_8021AD) {
+			if (!ocelot->qinq_enable) {
+				ocelot->qinq_enable = true;
+				kref_init(&ocelot->qinq_refcount);
+			} else {
+				kref_get(&ocelot->qinq_refcount);
+			}
+		}
 	}
 }
 
+static void felix_vlan_qinq_release(struct kref *ref)
+{
+	struct ocelot *ocelot;
+
+	ocelot = container_of(ref, struct ocelot, qinq_refcount);
+	ocelot->qinq_enable = false;
+}
+
 static int felix_vlan_del(struct dsa_switch *ds, int port,
 			  const struct switchdev_obj_port_vlan *vlan)
 {
@@ -165,6 +182,9 @@ static int felix_vlan_del(struct dsa_switch *ds, int port,
 				vid, port, err);
 			return err;
 		}
+
+		if (ocelot->qinq_enable && vlan->proto == ETH_P_8021AD)
+			kref_put(&ocelot->qinq_refcount, felix_vlan_qinq_release);
 	}
 	return 0;
 }
@@ -173,9 +193,13 @@ static int felix_port_enable(struct dsa_switch *ds, int port,
 			     struct phy_device *phy)
 {
 	struct ocelot *ocelot = ds->priv;
+	struct net_device *slave;
 
 	ocelot_port_enable(ocelot, port, phy);
 
+	slave = dsa_to_port(ds, port)->slave;
+	slave->features |= NETIF_F_HW_VLAN_STAG_FILTER;
+
 	return 0;
 }
 
@@ -555,6 +579,97 @@ static struct ptp_clock_info ocelot_ptp_clock_info = {
 	.enable		= ocelot_ptp_enable,
 };
 
+static int felix_qinq_port_bitmap_get(struct dsa_switch *ds, u32 *bitmap)
+{
+	struct ocelot *ocelot = ds->priv;
+	struct ocelot_port *ocelot_port;
+	int port;
+
+	*bitmap = 0;
+	for (port = 0; port < ds->num_ports; port++) {
+		ocelot_port = ocelot->ports[port];
+		if (ocelot_port->qinq_mode)
+			*bitmap |= 0x01 << port;
+	}
+
+	return 0;
+}
+
+static int felix_qinq_port_bitmap_set(struct dsa_switch *ds, u32 bitmap)
+{
+	struct ocelot *ocelot = ds->priv;
+	struct ocelot_port *ocelot_port;
+	int port;
+
+	for (port = 0; port < ds->num_ports; port++) {
+		ocelot_port = ocelot->ports[port];
+		if (bitmap & (0x01 << port))
+			ocelot_port->qinq_mode = true;
+		else
+			ocelot_port->qinq_mode = false;
+	}
+
+	return 0;
+}
+
+enum felix_devlink_param_id {
+	FELIX_DEVLINK_PARAM_ID_BASE = DEVLINK_PARAM_GENERIC_ID_MAX,
+	FELIX_DEVLINK_PARAM_ID_QINQ_PORT_BITMAP,
+};
+
+static int felix_devlink_param_get(struct dsa_switch *ds, u32 id,
+				   struct devlink_param_gset_ctx *ctx)
+{
+	int err;
+
+	switch (id) {
+	case FELIX_DEVLINK_PARAM_ID_QINQ_PORT_BITMAP:
+		err = felix_qinq_port_bitmap_get(ds, &ctx->val.vu32);
+		break;
+	default:
+		err = -EOPNOTSUPP;
+		break;
+	}
+
+	return err;
+}
+
+static int felix_devlink_param_set(struct dsa_switch *ds, u32 id,
+				   struct devlink_param_gset_ctx *ctx)
+{
+	int err;
+
+	switch (id) {
+	case FELIX_DEVLINK_PARAM_ID_QINQ_PORT_BITMAP:
+		err = felix_qinq_port_bitmap_set(ds, ctx->val.vu32);
+		break;
+	default:
+		err = -EOPNOTSUPP;
+		break;
+	}
+
+	return err;
+}
+
+static const struct devlink_param felix_devlink_params[] = {
+	DSA_DEVLINK_PARAM_DRIVER(FELIX_DEVLINK_PARAM_ID_QINQ_PORT_BITMAP,
+				 "qinq_port_bitmap",
+				 DEVLINK_PARAM_TYPE_U32,
+				 BIT(DEVLINK_PARAM_CMODE_RUNTIME)),
+};
+
+static int felix_setup_devlink_params(struct dsa_switch *ds)
+{
+	return dsa_devlink_params_register(ds, felix_devlink_params,
+					   ARRAY_SIZE(felix_devlink_params));
+}
+
+static void felix_teardown_devlink_params(struct dsa_switch *ds)
+{
+	dsa_devlink_params_unregister(ds, felix_devlink_params,
+				      ARRAY_SIZE(felix_devlink_params));
+}
+
 /* Hardware initialization done here so that we can allocate structures with
  * devm without fear of dsa_register_switch returning -EPROBE_DEFER and causing
  * us to allocate structures twice (leak memory) and map PCI memory twice
@@ -614,6 +729,10 @@ static int felix_setup(struct dsa_switch *ds)
 	ds->mtu_enforcement_ingress = true;
 	ds->configure_vlan_while_not_filtering = true;
 
+	err = felix_setup_devlink_params(ds);
+	if (err < 0)
+		return err;
+
 	return 0;
 }
 
@@ -625,6 +744,8 @@ static void felix_teardown(struct dsa_switch *ds)
 	if (felix->info->mdio_bus_free)
 		felix->info->mdio_bus_free(ocelot);
 
+	felix_teardown_devlink_params(ds);
+
 	ocelot_deinit_timestamp(ocelot);
 	/* stop workqueue thread */
 	ocelot_deinit(ocelot);
@@ -798,6 +919,8 @@ const struct dsa_switch_ops felix_switch_ops = {
 	.cls_flower_del		= felix_cls_flower_del,
 	.cls_flower_stats	= felix_cls_flower_stats,
 	.port_setup_tc          = felix_port_setup_tc,
+	.devlink_param_get	= felix_devlink_param_get,
+	.devlink_param_set	= felix_devlink_param_set,
 };
 
 static int __init felix_init(void)
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 5abb7d2b0a9e..9186501cef03 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -143,6 +143,8 @@ static int ocelot_port_set_native_vlan(struct ocelot *ocelot, int port,
 				       u16 vid)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
+	u32 port_tpid = 0;
+	u32 tag_tpid = 0;
 	u32 val = 0;
 
 	if (ocelot_port->vid != vid) {
@@ -156,8 +158,14 @@ static int ocelot_port_set_native_vlan(struct ocelot *ocelot, int port,
 		ocelot_port->vid = vid;
 	}
 
-	ocelot_rmw_gix(ocelot, REW_PORT_VLAN_CFG_PORT_VID(vid),
-		       REW_PORT_VLAN_CFG_PORT_VID_M,
+	if (ocelot->qinq_enable && ocelot_port->qinq_mode)
+		port_tpid = REW_PORT_VLAN_CFG_PORT_TPID(ETH_P_8021AD);
+	else
+		port_tpid = REW_PORT_VLAN_CFG_PORT_TPID(ETH_P_8021Q);
+
+	ocelot_rmw_gix(ocelot, REW_PORT_VLAN_CFG_PORT_VID(vid) | port_tpid,
+		       REW_PORT_VLAN_CFG_PORT_VID_M |
+		       REW_PORT_VLAN_CFG_PORT_TPID_M,
 		       REW_PORT_VLAN_CFG, port);
 
 	if (ocelot_port->vlan_aware && !ocelot_port->vid)
@@ -180,12 +188,18 @@ static int ocelot_port_set_native_vlan(struct ocelot *ocelot, int port,
 		else
 			/* Tag all frames */
 			val = REW_TAG_CFG_TAG_CFG(3);
+
+		if (ocelot->qinq_enable && ocelot_port->qinq_mode)
+			tag_tpid = REW_TAG_CFG_TAG_TPID_CFG(1);
+		else
+			tag_tpid = REW_TAG_CFG_TAG_TPID_CFG(0);
 	} else {
 		/* Port tagging disabled. */
 		val = REW_TAG_CFG_TAG_CFG(0);
+		tag_tpid = REW_TAG_CFG_TAG_TPID_CFG(0);
 	}
-	ocelot_rmw_gix(ocelot, val,
-		       REW_TAG_CFG_TAG_CFG_M,
+	ocelot_rmw_gix(ocelot, val | tag_tpid,
+		       REW_TAG_CFG_TAG_CFG_M | REW_TAG_CFG_TAG_TPID_CFG_M,
 		       REW_TAG_CFG, port);
 
 	return 0;
@@ -204,6 +218,15 @@ void ocelot_port_vlan_filtering(struct ocelot *ocelot, int port,
 		      ANA_PORT_VLAN_CFG_VLAN_POP_CNT(1);
 	else
 		val = 0;
+
+	/* if switch is enabled for QinQ, the port for LAN should set
+	 * VLAN_CFG.VLAN_POP_CNT=0 && VLAN_CFG.VLAN_AWARE_ENA=0.
+	 * the port for MAN should set VLAN_CFG.VLAN_POP_CNT=1 &&
+	 * VLAN_CFG.VLAN_AWARE_ENA=1. referring to 4.3.3 in VSC9959_1_00_TS.pdf
+	 */
+	if (ocelot->qinq_enable && !ocelot_port->qinq_mode)
+		val = 0;
+
 	ocelot_rmw_gix(ocelot, val,
 		       ANA_PORT_VLAN_CFG_VLAN_AWARE_ENA |
 		       ANA_PORT_VLAN_CFG_VLAN_POP_CNT_M,
@@ -217,10 +240,14 @@ EXPORT_SYMBOL(ocelot_port_vlan_filtering);
 static void ocelot_port_set_pvid(struct ocelot *ocelot, int port, u16 pvid)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
+	u32 tag_type = 0;
+
+	if (ocelot->qinq_enable && ocelot_port->qinq_mode)
+		tag_type = ANA_PORT_VLAN_CFG_VLAN_TAG_TYPE;
 
 	ocelot_rmw_gix(ocelot,
-		       ANA_PORT_VLAN_CFG_VLAN_VID(pvid),
-		       ANA_PORT_VLAN_CFG_VLAN_VID_M,
+		       ANA_PORT_VLAN_CFG_VLAN_VID(pvid) | tag_type,
+		       ANA_PORT_VLAN_CFG_VLAN_VID_M | tag_type,
 		       ANA_PORT_VLAN_CFG, port);
 
 	ocelot_port->pvid = pvid;
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index da369b12005f..8d0f9f9ec0b2 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -556,6 +556,7 @@ struct ocelot_port {
 	struct regmap			*target;
 
 	bool				vlan_aware;
+	bool				qinq_mode;
 
 	/* Ingress default VLAN (pvid) */
 	u16				pvid;
@@ -632,6 +633,9 @@ struct ocelot {
 	/* Protects the PTP clock */
 	spinlock_t			ptp_clock_lock;
 	struct ptp_pin_desc		ptp_pins[OCELOT_PTP_PINS_NUM];
+
+	bool				qinq_enable;
+	struct kref			qinq_refcount;
 };
 
 struct ocelot_policer {
-- 
2.17.1

