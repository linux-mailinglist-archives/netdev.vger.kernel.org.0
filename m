Return-Path: <netdev+bounces-11463-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 76E8B7332AE
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 15:57:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2E2BC2813E0
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 13:57:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59D5019BB9;
	Fri, 16 Jun 2023 13:54:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 463F91C74A
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 13:54:23 +0000 (UTC)
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2080.outbound.protection.outlook.com [40.107.6.80])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D6A13ABA;
	Fri, 16 Jun 2023 06:54:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OsGLC7KgA4wWivdGRDpchvPOhQkszkNw0y4vS1N1nq4pu3O4tCwX4ed78hmgaKxsVUPxI1YrrwJArBbkg3OXRvj1t6MPPsOu59GQ6LLBiw84ZgCl8hLcySBXiRd008/CrgWyJ+NoAqIhboNHdyXk7U+nhjHMB0z4MWruvJpgyYowM3gz19V63uway4fPJW8LKDj3vxGn79h6z7suUywDOkRckgcdUDh6zaBmV9jHtABlHf+wm/ps2vKyNUVNGQQrvL3IgtsHg73Nn2U+PaXLue0npX7/vUeGcCKBV9HpqeRdQr4B2hbD6Xg1pHb25NYtCKIrl9G6qlexkde4Sb42RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OtG08RK9NPZVmt6emuPFXOQAMFTf5p7MFoi/p0d+ZdM=;
 b=SDrZmqNvSnRdEq2RI4toVDvm7bNMk+y8tvlkLAjJpcuOHJCuwYI32OgT8sSnPuSZOsXlhrqinrnJvSr0kFbmVadsSlTkAWMW8euBJTfHpXRq4XM6ZN2lsobv8AJyISby9QSe7HcRnVi9ZYA/db3jTCy6miLM6QK++KXnNVpnBMiMshDLKugXvXL3P/FE62li3slMXWLcXG32aUiW2iCLxwEMnVzW5rySVeibkwDkT4y2Y/kr0qzI0HrdS0Tg1K47SXeMx96qR0x6s8SAzCnreGRiYjv8xCwGV6aiY6iZGiCnv6Js7BQ20AvOjNBb6um5myXH7cIo2bmt2PX65nCdew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OtG08RK9NPZVmt6emuPFXOQAMFTf5p7MFoi/p0d+ZdM=;
 b=afmAlSGw0QMPxMIahX/pQ5sXYxSe4m80XCavZT5m2Nj5CycmpznXLE+t++A7ni03vp0I6WakI2150gHTEwAkjCVdEUbfGiVYFNKUI20VNNakJ7PYovi6xUNj+pswGT92VXcgkdSQIoGsX5mV85zJQQpsJIqd+pdP5f+JGPK4ONc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com (2603:10a6:20b:409::7)
 by PA4PR04MB9318.eurprd04.prod.outlook.com (2603:10a6:102:2a5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.25; Fri, 16 Jun
 2023 13:54:03 +0000
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::5356:c79f:ef9f:dc29]) by AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::5356:c79f:ef9f:dc29%4]) with mapi id 15.20.6500.029; Fri, 16 Jun 2023
 13:54:03 +0000
From: "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
To: andrew@lunn.ch,
	hkallweit1@gmail.com,
	linux@armlinux.org.uk,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	richardcochran@gmail.com
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	sebastian.tobuschat@nxp.com,
	"Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
Subject: [PATCH net-next v1 10/14] net: phy: nxp-c45-tja11xx: handle FUSA irq
Date: Fri, 16 Jun 2023 16:53:19 +0300
Message-Id: <20230616135323.98215-11-radu-nicolae.pirea@oss.nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230616135323.98215-1-radu-nicolae.pirea@oss.nxp.com>
References: <20230616135323.98215-1-radu-nicolae.pirea@oss.nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0106.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::47) To AM9PR04MB8954.eurprd04.prod.outlook.com
 (2603:10a6:20b:409::7)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR04MB8954:EE_|PA4PR04MB9318:EE_
X-MS-Office365-Filtering-Correlation-Id: f5d482c5-2458-4334-c09b-08db6e712526
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	zC9wPI9w6j9wFtOSsXdjH3rpDiAVEfTFtaiHjKQ/ZqbZdRNJdFsMICHzCMcHpGz1I0074BdYSFu8HW7FQWaOqDwcJV98Gfm79/QxBnYaIvRbeQ9P8Ivlns6Bu810lbKawCmrvozAk2J0tbYxfSktOCXs7EMPSLng3Pj1ZkCNFYRWhjztCWvBfEc0suBS0m1J29hP35TDcklZkbYKWaD3O9VajXibjNhQSGCdCc8riLvlu75/1fP29r3kfdASFfEEMhyWEF8ls41U0z66iVlbtVRf+GYYnbKx8GglF1SplO0obg1nUmiowXLJP0ErVJfIuU+VuAu9Vi32PPYur7/OeCUmNSuprhP1Xp2K+iEizyxa2lVVylKTklomt5hU+XyWcYLnFWH4YP65Jy6j1vPkH+uAALXI8K1QLxFWt7Y2+8QKwlhRKX4Tx5GqYgANHwBNqoBcauCMbje4kU5Vhnb0lbz803qruJIcTyb4nhSIJx+eZkQN3EkAKGldnC6aswzmRcYIDFNrXL8tpIew9NJYoeFs6km5aNvIgXProGaZgUwZLAOMbSG+huBnBbGXRBEXzmLhCerQx69BLbv0eM5dVf4c9dBKT/KT+Zgev0PxZXdS0qAVR0AmPTpXD0zMbP5V
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8954.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(366004)(346002)(136003)(376002)(451199021)(41300700001)(52116002)(86362001)(66556008)(66946007)(316002)(6486002)(8676002)(8936002)(6666004)(66476007)(4326008)(478600001)(7416002)(6512007)(5660300002)(26005)(83380400001)(6506007)(1076003)(2906002)(186003)(38350700002)(2616005)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Dmmul1HIyBfqUCt/j7mDy73oNSfNCFM7OZ5Acgq87Bt8QQYWJ2G0e5hs3Nh5?=
 =?us-ascii?Q?0OqIde3IUlh0zFDJSFQsCyDPs82xCXUJZlDTC4FiAu2HG4N5Fwe9dLW3+47o?=
 =?us-ascii?Q?GhxRFn8Q1qXQRFbQY78i5ji2w/4Smwc4nUpO6kNQxCnrn4NJGei04PUMyPm5?=
 =?us-ascii?Q?UnKkzjUiNt8ngweIlWAPV+C3IVAgvkuCPUQYd3xWbf1oVO5KkYxTJmMZ8vQ5?=
 =?us-ascii?Q?eyoAmHbhAVG/TSnXEUtPM5rPDIcdORyIJoMWgLxKRuY0PXj5FaYfXxEWtecx?=
 =?us-ascii?Q?j0QkzjAfeHGAMUX9vn0oA6P51XF9rQsvku8thCW8lzTisFxRe85TQnFkrDV7?=
 =?us-ascii?Q?zUU3KmLm6HTZf6DnyF1xsczURUyX0yO9ZAaeYnXvpGVQ3y8JeDmqXWMQ5ROV?=
 =?us-ascii?Q?6cJnzRdzkFP8Ab019FY1KXIbLBhiyQGK9w4iaA8SxnjUkDGTV6EOxqTEnEWT?=
 =?us-ascii?Q?Imu4UvbwBf08OiEreQz8aaZ2XImsXXhDXXYSIvih76kPghcr9xc4VinuUbNI?=
 =?us-ascii?Q?DRRbwncsq5D9QivI6RPCFnsjavjTN2K8LD+WB3ZwZCAfR8C8FApJs6iG4Ow2?=
 =?us-ascii?Q?t5VltwRTaRhYTKg4PmtYoTiGQEAEDlsUAJ5Z+qAOow6JARPXEPI+mjx9QMYO?=
 =?us-ascii?Q?2SpFiWhph3gJAxkfni9XgFjv8oItjiduUy2AcNOZCrsskcppPQhh0NpQQIka?=
 =?us-ascii?Q?0AANR06kxCISZn67Sbd7w/Q5fm/JEtLxhgHDAUgQwQdMfMx3sL9O1RsUjGwg?=
 =?us-ascii?Q?WtgTOyt/6VanT120bGqibQVBEJJBHrW0AFW9f2u+Gcj7nhQdY26v73tDw1eJ?=
 =?us-ascii?Q?RmPMKqllzZcxvMKV8qb8CjgLw50NxNWtmZNF42uTQvACmUCktD3tMoq4XLfh?=
 =?us-ascii?Q?FrbSAe9bjndGKDNyBq77gm8O5QS86yonj7bnK6tk6ikurkMLF2hOCNTxmgDZ?=
 =?us-ascii?Q?zTHVLmh+skVkKxMnSMKJIbn10OnBCryR33FKvj7ONzQGdZvipwzMwckW5BsT?=
 =?us-ascii?Q?IhZsv9KjTGOidiuzjOB5sWr0WpdBj2PRAGz8VqKpMvoPE6QUwGHA9c81RBhS?=
 =?us-ascii?Q?Ki2a6nYUo22nF0dn5pVQBhqFZ6qWYRuSn5TZ0Ju0E3wk1EAE2InpEwCS7Okl?=
 =?us-ascii?Q?74CFfTezqIRkixIu+uIHQu9gDSvWT5qesKe1hplCNwiWNsN59hvanKrAT2ut?=
 =?us-ascii?Q?nLdczni5lb2dkeLb1YqARNjgN3aJnqohOt1lE71t/vsmNCV+QYO1DBwVwVcX?=
 =?us-ascii?Q?yC+6H2KwZhubK3vBuBfgImuxowpoQDNCX9m2tHWdQS0Cbp2jWZQftgn5iWFC?=
 =?us-ascii?Q?OYKyG/bcBZpR0dLeQRtZcPgBbBSSz5u3hvjLg9nfP1WJnnY3bU5T8qMeQdiv?=
 =?us-ascii?Q?E/TK4HvGy7eeIvBDnSAEZo6cxG7iwq04P+gIK9pqLmhrYvwKGR6RlUOBDa6H?=
 =?us-ascii?Q?B42j2eus3Y2dH+HshABdQs79Y9PFFyQSqRvVhxv/6DaL3fTWRCQTxvBJIdwC?=
 =?us-ascii?Q?CBJX5ye3CcLAobG7FoOD/TWk2je+FVF0e9oM4+BWjjHftVeY67aF3UqRCqvr?=
 =?us-ascii?Q?VRnCQuWAVdzpvmTh+r/rGhVd1KSAHi0cQwhe/gcYDvrD+aU4aA1fv03ziABk?=
 =?us-ascii?Q?Sg=3D=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5d482c5-2458-4334-c09b-08db6e712526
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8954.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2023 13:54:03.8216
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yr4dVOAXCVSpv+zED8UK76VBJfQ4QWZGRu8yhg+Wd1KGoDWfVgf5aps6BJwKvuzgiSE2pgi9d86/iYmCeGTgbaUNWtfXwN47dXpELdTLPDs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB9318
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

TJA1120 and TJA1103 have a set of functional safety hardware tests
executed after every reset, and when the tests are done, the IRQ line is
asserted. For the moment, the purpose of these handlers is to acknowledge
the IRQ and not to check the FUSA tests status.

Signed-off-by: Radu Pirea (NXP OSS) <radu-nicolae.pirea@oss.nxp.com>
---
 drivers/net/phy/nxp-c45-tja11xx.c | 72 ++++++++++++++++++++++++++++++-
 1 file changed, 70 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/nxp-c45-tja11xx.c b/drivers/net/phy/nxp-c45-tja11xx.c
index 838bd4a638bc..0a17a1e80a2b 100644
--- a/drivers/net/phy/nxp-c45-tja11xx.c
+++ b/drivers/net/phy/nxp-c45-tja11xx.c
@@ -29,6 +29,11 @@
 
 #define TJA1120_VEND1_EXT_TS_MODE	0x1012
 
+#define TJA1120_GLOBAL_INFRA_IRQ_ACK	0x2C08
+#define TJA1120_GLOBAL_INFRA_IRQ_EN	0x2C0A
+#define TJA1120_GLOBAL_INFRA_IRQ_STATUS	0x2C0C
+#define TJA1120_DEV_BOOT_DONE		BIT(1)
+
 #define TJA1120_EGRESS_TS_DATA_S	0x9060
 #define TJA1120_EGRESS_TS_END		0x9067
 #define TJA1120_TS_VALID		BIT(0)
@@ -39,6 +44,9 @@
 #define VEND1_PHY_IRQ_STATUS		0x80A2
 #define PHY_IRQ_LINK_EVENT		BIT(1)
 
+#define VEND1_ALWAYS_ACCESSIBLE		0x801F
+#define FUSA_PASS			BIT(4)
+
 #define VEND1_PHY_CONTROL		0x8100
 #define PHY_CONFIG_EN			BIT(14)
 #define PHY_START_OP			BIT(0)
@@ -261,6 +269,8 @@ struct nxp_c45_phy_data {
 			     struct nxp_c45_hwts *hwts);
 	void (*ptp_init)(struct phy_device *phydev);
 	void (*ptp_enable)(struct phy_device *phydev, bool enable);
+	void (*nmi_handler)(struct phy_device *phydev,
+			    irqreturn_t *irq_status);
 };
 
 struct nxp_c45_phy {
@@ -1148,6 +1158,29 @@ static int nxp_c45_config_intr(struct phy_device *phydev)
 	}
 }
 
+static int tja1103_config_intr(struct phy_device *phydev)
+{
+	/* We can't disable the FUSA IRQ for TJA1103, but we can clean it up. */
+	phy_write_mmd(phydev, MDIO_MMD_VEND1, VEND1_ALWAYS_ACCESSIBLE,
+		      FUSA_PASS);
+
+	return nxp_c45_config_intr(phydev);
+}
+
+static int tja1120_config_intr(struct phy_device *phydev)
+{
+	if (phydev->interrupts == PHY_INTERRUPT_ENABLED)
+		phy_set_bits_mmd(phydev, MDIO_MMD_VEND1,
+				 TJA1120_GLOBAL_INFRA_IRQ_EN,
+				 TJA1120_DEV_BOOT_DONE);
+	else
+		phy_clear_bits_mmd(phydev, MDIO_MMD_VEND1,
+				   TJA1120_GLOBAL_INFRA_IRQ_EN,
+				   TJA1120_DEV_BOOT_DONE);
+
+	return nxp_c45_config_intr(phydev);
+}
+
 static irqreturn_t nxp_c45_handle_interrupt(struct phy_device *phydev)
 {
 	struct nxp_c45_phy *priv = phydev->priv;
@@ -1184,6 +1217,9 @@ static irqreturn_t nxp_c45_handle_interrupt(struct phy_device *phydev)
 		ret = IRQ_HANDLED;
 	}
 
+	if (data->nmi_handler)
+		data->nmi_handler(phydev, &ret);
+
 	return ret;
 }
 
@@ -1584,6 +1620,21 @@ static void tja1103_ptp_enable(struct phy_device *phydev, bool enable)
 				 PORT_PTP_CONTROL_BYPASS);
 }
 
+static void tja1103_nmi_handler(struct phy_device *phydev,
+				irqreturn_t *irq_status)
+{
+	int ret;
+
+	ret = phy_read_mmd(phydev, MDIO_MMD_VEND1,
+			   VEND1_ALWAYS_ACCESSIBLE);
+	if (ret & FUSA_PASS) {
+		phy_write_mmd(phydev, MDIO_MMD_VEND1,
+			      VEND1_ALWAYS_ACCESSIBLE,
+			      FUSA_PASS);
+		*irq_status = IRQ_HANDLED;
+	}
+}
+
 static const struct nxp_c45_regmap tja1103_regmap = {
 	.vend1_ptp_clk_period	= 0x1104,
 	.vend1_event_msg_filt	= 0x1148,
@@ -1648,6 +1699,7 @@ static const struct nxp_c45_phy_data tja1103_phy_data = {
 	.get_egressts = nxp_c45_get_hwtxts,
 	.ptp_init = tja1103_ptp_init,
 	.ptp_enable = tja1103_ptp_enable,
+	.nmi_handler = tja1103_nmi_handler,
 };
 
 static void tja1120_counters_enable(struct phy_device *phydev)
@@ -1682,6 +1734,21 @@ static void tja1120_ptp_enable(struct phy_device *phydev, bool enable)
 				   PTP_ENABLE);
 }
 
+static void tja1120_nmi_handler(struct phy_device *phydev,
+				irqreturn_t *irq_status)
+{
+	int ret;
+
+	ret = phy_read_mmd(phydev, MDIO_MMD_VEND1,
+			   TJA1120_GLOBAL_INFRA_IRQ_STATUS);
+	if (ret & TJA1120_DEV_BOOT_DONE) {
+		phy_write_mmd(phydev, MDIO_MMD_VEND1,
+			      TJA1120_GLOBAL_INFRA_IRQ_ACK,
+			      TJA1120_DEV_BOOT_DONE);
+		*irq_status = IRQ_HANDLED;
+	}
+}
+
 static const struct nxp_c45_regmap tja1120_regmap = {
 	.vend1_ptp_clk_period	= 0x1020,
 	.vend1_event_msg_filt	= 0x9010,
@@ -1746,6 +1813,7 @@ static const struct nxp_c45_phy_data tja1120_phy_data = {
 	.get_egressts = tja1120_get_hwtxts,
 	.ptp_init = tja1120_ptp_init,
 	.ptp_enable = tja1120_ptp_enable,
+	.nmi_handler = tja1120_nmi_handler,
 };
 
 static struct phy_driver nxp_c45_driver[] = {
@@ -1758,7 +1826,7 @@ static struct phy_driver nxp_c45_driver[] = {
 		.soft_reset		= nxp_c45_soft_reset,
 		.config_aneg		= genphy_c45_config_aneg,
 		.config_init		= nxp_c45_config_init,
-		.config_intr		= nxp_c45_config_intr,
+		.config_intr		= tja1103_config_intr,
 		.handle_interrupt	= nxp_c45_handle_interrupt,
 		.read_status		= genphy_c45_read_status,
 		.suspend		= genphy_c45_pma_suspend,
@@ -1782,7 +1850,7 @@ static struct phy_driver nxp_c45_driver[] = {
 		.soft_reset		= nxp_c45_soft_reset,
 		.config_aneg		= genphy_c45_config_aneg,
 		.config_init		= nxp_c45_config_init,
-		.config_intr		= nxp_c45_config_intr,
+		.config_intr		= tja1120_config_intr,
 		.handle_interrupt	= nxp_c45_handle_interrupt,
 		.read_status		= genphy_c45_read_status,
 		.suspend		= genphy_c45_pma_suspend,
-- 
2.34.1


