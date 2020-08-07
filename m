Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0BCF23EC03
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 13:11:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728338AbgHGLLr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 07:11:47 -0400
Received: from mail-am6eur05on2045.outbound.protection.outlook.com ([40.107.22.45]:38465
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728282AbgHGLLl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Aug 2020 07:11:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N6E/O5eVZ4Nor3l4mqpMsdCCistvpDdsgcx2OcquJuwhkci24Q/5TjQTfTxRb+P2dRc0Hi/SeSkZtCu13f/d89eOYL61FFtLtvWP+YoRcvVN9Yl/RvXg1vf6pwDnqD0b3cbnnjIAomVIxRXZuzqIXY+s0WxmXTOHTXnGOJqtKeeUXLbucrc3f9XFe/Mg2/vxZDGaOmtv3Wg4nQ7vzTuz38lMPawHndzjzaGSjzlghM7SxHeDYrrEbeCXxV7D7JIdkParQENd2QsHKoP3EDQzZxXpctF6CPSEq0EncrLJOvieqClH+AfHTsZpWfvnjqdITsOzUUpelR3F9OvVbC6o3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+/GzhHuePm5IiAiULZNl0s5SFMXqSfpf1woYQbyHmvI=;
 b=J2dXZWPuo40hF8Ozq/MlBdnAdnEjMCtRFYsHRLEciYvZYMHyIuCShrE0zWs+prL2mnr8rGAyUa7hMJzkjSS9GneRqnQ/VyjZ0nB2TGu8LQ/KNQ7aOs6g2eaXm/Vw3WzGcK0LcjJunjT12yfAXqhhQawtjN5n7fKyFF708Etuj4A1MQ2J0pLMKaCzOrqPAEXFDqrGsdKvk7l2Ihb1bWCUSEPAw9qujo8oI1FsyBJNvxTV50COkpN+QpmOAD1hKgC/3d6Cy9mDb3GVM58+2gO8c3JrwBXKfitREyqZprvZ+XgvXx554MPZZip6sONWiacCBETQ9V+uWfcuXV1GNJTejg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+/GzhHuePm5IiAiULZNl0s5SFMXqSfpf1woYQbyHmvI=;
 b=mA1ODnaSyjqYodJyQHpcGZuQ9LFdbWzAZhLA8sO7PuybeMU5ydA3cktg36TpsJ5zh42M7ixWklbt9MwrudVNN7WOcZtBvJNPFpYFlXSCFR0qW2WJk9oEe6AdvQJEpOPQUwILQsEzrDPDnHJsiirxNaDaBBcBnz2p11TLoISUTkY=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5103.eurprd04.prod.outlook.com (2603:10a6:803:51::19)
 by VI1PR04MB5725.eurprd04.prod.outlook.com (2603:10a6:803:e3::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.15; Fri, 7 Aug
 2020 11:11:31 +0000
Received: from VI1PR04MB5103.eurprd04.prod.outlook.com
 ([fe80::2c2c:20a4:38cd:73c3]) by VI1PR04MB5103.eurprd04.prod.outlook.com
 ([fe80::2c2c:20a4:38cd:73c3%7]) with mapi id 15.20.3261.020; Fri, 7 Aug 2020
 11:11:31 +0000
From:   hongbo.wang@nxp.com
To:     xiaoliang.yang_1@nxp.com, allan.nielsen@microchip.com,
        po.liu@nxp.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, vladimir.oltean@nxp.com,
        leoyang.li@nxp.com, mingkai.hu@nxp.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, jiri@resnulli.us, idosch@idosch.org,
        kuba@kernel.org, vinicius.gomes@intel.com,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        horatiu.vultur@microchip.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, ivecera@redhat.com
Cc:     "hongbo.wang" <hongbo.wang@nxp.com>
Subject: [PATCH v5 2/2] net: dsa: ocelot: Add support for QinQ Operation
Date:   Fri,  7 Aug 2020 19:13:49 +0800
Message-Id: <20200807111349.20649-3-hongbo.wang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200807111349.20649-1-hongbo.wang@nxp.com>
References: <20200807111349.20649-1-hongbo.wang@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0218.apcprd06.prod.outlook.com
 (2603:1096:4:68::26) To VI1PR04MB5103.eurprd04.prod.outlook.com
 (2603:10a6:803:51::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from whb-OptiPlex-790.ap.freescale.net (119.31.174.73) by SG2PR06CA0218.apcprd06.prod.outlook.com (2603:1096:4:68::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.19 via Frontend Transport; Fri, 7 Aug 2020 11:11:24 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.73]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 47cf1010-51b3-464c-75e3-08d83ac2a333
X-MS-TrafficTypeDiagnostic: VI1PR04MB5725:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB57259F5DA8BA8029D948EACBE1490@VI1PR04MB5725.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V1K81abGPJTLXg5Ctdo6efv4tcMHtCftP2fir0EHwj1b1dSMXvfkyz1WzFTnem101poOkcwRdUxbcehD5ReId/qE0Mbd+frZ7F54SA4fPzNH/xZ2s6zwMlxivq7kHq6QWNNIBOQWzo0tN1vABtWI8bFGpb4h1JMELT+ynZt7sgO1laK/3YP7iFv3hAYdEgcWQiAOyA6cyLWc+TfrixkO+SgvD8/jQSgPkRFXClP/+GmYpJ+xKZrKuKFjb8n6MsOgNRmKx2zwBHzLj3X13VaXRXuqd0aU95OhnNifxOxU4SSQc+lzIzzdYTXXDFl10jW4JLDJZM/8oK3OuwL+LNco+udbq+hWfyxQi9HPEUAhKrjTpOE9GW0SPIUzE6LcNRmx
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5103.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(376002)(346002)(396003)(366004)(956004)(4326008)(2616005)(7416002)(5660300002)(6512007)(9686003)(8936002)(8676002)(6486002)(2906002)(478600001)(52116002)(26005)(66946007)(6506007)(316002)(16526019)(36756003)(186003)(6666004)(1076003)(86362001)(83380400001)(66476007)(66556008)(921003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 2HI+/GGiWFsOORsIRwl7R5PhFiTk3EShSQ+I7bVwVf1csj/fYtTh3DjR5JWEwbY/oqc/cDzGN4aKl07ggI1yT1PO/ogRzkVrAgYpWyT+6DFnOrB2NHM/2T4QBSiJ2SFjz1n7Du+Sm22BNIw+VTg+emzJghs95Y3Wl8bbo+6w6JYblOYzQWW6w9f/5QDznQTXgr1xzvNMv7+gkx6SNgxqhSxJT1rVofg/uSY3zC+pD/LoDtO7ExwsNKFEGOd+F5AXFBMivdNWIroVM7Vi2/PvnyZiZYjf8BP9z9kmBELGeYabJFxGV5qQEQhPPo0D8dWUEoGo+kppiN8QvVl8aFbB5+1xe9NXDbVTnMAnKiMxUXze4OKwnAgu544G5ZrqFWW5/ZWy9bYTwNHZqAhDOTYhELwwAC+lstogd8vl0tOY2loqZRQhGjF6k41BJodP1jNHs88NIE0PyzmpTwpbvXnz86V7vAn5Py6wsmNdj+rCO8WczP6TqofDkeCYDKiIjJsZ5G3FupM9dXFAVOS+HOISIEauLvreMMpT3S5K/uzVNzX3VlN8kIXYqLeLRKfsYpXLtlYqvXNdNO5/TeaDbzPHsFE4+23Nij0DrFf0hwz/eNmchK0px+7Vcpizg0N/7/d2ntXsC2ERk7wXWDfegvPzjw==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47cf1010-51b3-464c-75e3-08d83ac2a333
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5103.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2020 11:11:31.1968
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sHwpKpm1eAK+gh0bXekWnDfbHO9dmdhHAFU0VNONmeB3TQ95O9t+uOsTxfbhMUBMOXuu3qHY8YJG17gSOyjn/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5725
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

ip link add dev br0 type bridge vlan_protocol 802.1ad
ip link set dev swp0 master br0
ip link set dev swp1 master br0

2.
ip link set dev br0 type bridge vlan_filtering 1
bridge vlan add dev swp0 vid 100 pvid
bridge vlan add dev swp1 vid 100
Result:
Customer(tpid:8100 vid:111) -> swp0 -> swp1 -> ISP(STAG \
                tpid:88A8 vid:100, CTAG tpid:8100 vid:111)

3.
bridge vlan del dev swp0 vid 1 pvid
bridge vlan add dev swp0 vid 100 pvid untagged
Result:
ISP(tpid:88A8 vid:100 tpid:8100 vid:222) -> swp1 -> swp0 ->\
		Customer(tpid:8100 vid:222)

Signed-off-by: hongbo.wang <hongbo.wang@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c     | 124 +++++++++++++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot.c |  40 ++++++++--
 include/soc/mscc/ocelot.h          |   4 +
 3 files changed, 162 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index c69d9592a2b7..f9d50af4be65 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -147,9 +147,26 @@ static void felix_vlan_add(struct dsa_switch *ds, int port,
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
@@ -164,7 +181,11 @@ static int felix_vlan_del(struct dsa_switch *ds, int port,
 				vid, port, err);
 			return err;
 		}
+
+		if (ocelot->qinq_enable && vlan->proto == ETH_P_8021AD)
+			kref_put(&ocelot->qinq_refcount, felix_vlan_qinq_release);
 	}
+
 	return 0;
 }
 
@@ -172,9 +193,13 @@ static int felix_port_enable(struct dsa_switch *ds, int port,
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
 
@@ -568,6 +593,97 @@ static struct ptp_clock_info ocelot_ptp_clock_info = {
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
@@ -632,6 +748,10 @@ static int felix_setup(struct dsa_switch *ds)
 	 */
 	ds->pcs_poll = true;
 
+	err = felix_setup_devlink_params(ds);
+	if (err < 0)
+		return err;
+
 	return 0;
 }
 
@@ -643,6 +763,8 @@ static void felix_teardown(struct dsa_switch *ds)
 	if (felix->info->mdio_bus_free)
 		felix->info->mdio_bus_free(ocelot);
 
+	felix_teardown_devlink_params(ds);
+
 	ocelot_deinit_timestamp(ocelot);
 	/* stop workqueue thread */
 	ocelot_deinit(ocelot);
@@ -817,6 +939,8 @@ const struct dsa_switch_ops felix_switch_ops = {
 	.cls_flower_del		= felix_cls_flower_del,
 	.cls_flower_stats	= felix_cls_flower_stats,
 	.port_setup_tc          = felix_port_setup_tc,
+	.devlink_param_get	= felix_devlink_param_get,
+	.devlink_param_set	= felix_devlink_param_set,
 };
 
 static int __init felix_init(void)
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 867c680f5917..073c08989e21 100644
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
@@ -180,12 +188,19 @@ static int ocelot_port_set_native_vlan(struct ocelot *ocelot, int port,
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
+
+	ocelot_rmw_gix(ocelot, val | tag_tpid,
+		       REW_TAG_CFG_TAG_CFG_M | REW_TAG_CFG_TAG_TPID_CFG_M,
 		       REW_TAG_CFG, port);
 
 	return 0;
@@ -204,6 +219,15 @@ void ocelot_port_vlan_filtering(struct ocelot *ocelot, int port,
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
@@ -217,10 +241,14 @@ EXPORT_SYMBOL(ocelot_port_vlan_filtering);
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

