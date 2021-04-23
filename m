Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A59A336957C
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 17:02:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243520AbhDWPCN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 11:02:13 -0400
Received: from mail-eopbgr20047.outbound.protection.outlook.com ([40.107.2.47]:7938
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243514AbhDWPBn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 11:01:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BqtYCBU6xKZXall1jvNidehXbW2qlvWMBXsURBkElZJT866EfXw5QuqOAAhROnPidpyfAe3vM4eKdHtPbD4qehr8kDiYR957z6tzDgbAifMUVVyN9QwJLojZgPGfky/tVXemSPkSoygxtwAqFrYA9s+0RWxgFW9fv7Oio4BCjF5oEEW+FNGOnJtrtbt1DW2g1kzm2z3QXIM9BLRkafM1ODeahyQvmr350v1z6rAaJm6GZkoza2yfTkBZLShkBJCUmp2NWz/q6U/f27pD2P2I/LevPcumj/U4dN8C7UxYA+eMcCi5JOy0G5LuTTjVBYzsd6ELvQSoJTjfl9gFZ58MSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mpbUpwpVqA5enuQomRYBOFq7zUUBa+qw2krnBrme4rg=;
 b=Bh7PoSz8UlQrmLvYLFmGKAmM4OFIBNfFxSBaRyFIjKsrXSBMpfJlx2nqPPBFLnCF4aEZoGyAUlGQabpDL4joo3YMQ9qXSX99yZvuzRfXBRuRC0jVoA4pFjcemLVH7phZHDdPxRpN9SaHgRAtcgBBYw/HaYrFLiJomzSDzaS+gZU9FDwPgkj67yJuKRWCpFhDziit+i5E4y6mzBeAwaqkf346QH9soVBegeKkm9u/i8U6+vJbHXgAaDPPuB09x4p+9x73JxmuVavzaNjOjVr7AzLVRa0Zidd5wP9GE99hBQEZmPB8IN5FkFUBhhIN4mV8Xvv84UWrEQpUZBLc3kOAqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mpbUpwpVqA5enuQomRYBOFq7zUUBa+qw2krnBrme4rg=;
 b=AIluh28Gf1268Mw4fgjSUhYhHJjDDVNE6+9e7nlFfAC3WVxylK8XFPQLnpyLt0f+mPqsLfzEEHEQML5b6Ca0F5hYB6gByVNA54JwaJWcywlewz/MOpQW7w4D9nLdMxKzCyjYc0TkvlvFa9c6GfLWlLuHbd1iRL6TKTnBysfNQhg=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=oss.nxp.com;
Received: from VI1PR04MB5101.eurprd04.prod.outlook.com (2603:10a6:803:5f::31)
 by VI1PR0401MB2589.eurprd04.prod.outlook.com (2603:10a6:800:4f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.19; Fri, 23 Apr
 2021 15:01:03 +0000
Received: from VI1PR04MB5101.eurprd04.prod.outlook.com
 ([fe80::1d18:6e9:995c:1945]) by VI1PR04MB5101.eurprd04.prod.outlook.com
 ([fe80::1d18:6e9:995c:1945%6]) with mapi id 15.20.4042.024; Fri, 23 Apr 2021
 15:01:03 +0000
From:   "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
Subject: [PATCH v2 1/1] phy: nxp-c45-tja11xx: add interrupt support
Date:   Fri, 23 Apr 2021 18:00:50 +0300
Message-Id: <20210423150050.1037224-1-radu-nicolae.pirea@oss.nxp.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [89.45.21.213]
X-ClientProxiedBy: AM0PR02CA0176.eurprd02.prod.outlook.com
 (2603:10a6:20b:28e::13) To VI1PR04MB5101.eurprd04.prod.outlook.com
 (2603:10a6:803:5f::31)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (89.45.21.213) by AM0PR02CA0176.eurprd02.prod.outlook.com (2603:10a6:20b:28e::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.22 via Frontend Transport; Fri, 23 Apr 2021 15:01:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bca26882-c943-407a-8889-08d906689d11
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2589:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0401MB2589AF750DE157F86BBE0EBB9F459@VI1PR0401MB2589.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:124;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bAoV1GKimLg/ba8y//q9LLmWNGBojFVpxdb8yGOWlS4BEuQLf3ulkLdsqfKaxnFL0HZqBBQWEt3g0NtageXd7bUPhF1QljW8VtTc6eGY8LWWqWVvdzZ3NsLya3CPCCxpOAVZVUZZNIyYdxPjwdCx+GmkvfCprOGN+G7PhT00pDuNXvbl0oYXu7zpxDnEGlMHd7gvmBluQlVlCd9S4211tdodhqSCgzd1q1y+eVLUcJv6F4H4HxLNzAjsBGzbCKmMt2BZR9Oy0Qx7jDMlnCuDOzHlrrGqEo8YXzh5WaxyR8FbHsYwnBBrz9t989h9e1kuGkkhL3E+vm86yr1HYuVOHlbDxsFfI/Jde5IfGL+QiQHnkJ/Ka226042kQry809wwiNr7rmeNEnvuq0H+YCMRgNeb3LbSU0q0LWqsjBiGamEMw3Kg+tc4rGsqCbO3vzG+Z1c4Xd2ATGu8h+JqtoMXlZ4KS1UuIaPSDibYyWSnDYulRZp/IjGqX3CuZaIAiax+NL7BDmTwdYOne4zmP8Gfllwgjd8BXQphrdyMjzoJYuJ9+aJntm61y3me2m5ZzwXLok+Wgw1SPrF9pL3znKaDOPRXTvBxKvnontDRlexCD1pfJsqG8tAJ8g7W90G5CsNjKM6z9vaRETg7zxSNw6kgoUoo5OCIjNB0eVXyxALXLxQFIx3F31R+l8QnyfCP8VaNucOJA/0hBQopq957QWuhgJ5pzY6yv1BRDjrFHY4RbuY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5101.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(39850400004)(366004)(376002)(66946007)(478600001)(52116002)(16526019)(6512007)(2616005)(186003)(8676002)(83380400001)(8936002)(38350700002)(5660300002)(2906002)(26005)(316002)(66556008)(4326008)(86362001)(6506007)(956004)(38100700002)(6486002)(66476007)(6666004)(1076003)(69590400013)(41350200001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?vKFBzqu+sh+/RnU3m3PVg3oq38vXxerA3oOCx7F97g9HQnWCHAngE+ZctJ4r?=
 =?us-ascii?Q?pjpCQzxYR70hF1WfQP16AHS9ATk+jFJK7dAiQ/b2OZpQh7qoiUTbFKHYOJQP?=
 =?us-ascii?Q?3XCu/hTl8dp9/vQ7DISieoydMIMw+DNWQNavY/hqmC6Osz3+967q8aymzVJW?=
 =?us-ascii?Q?1x+mJJl59pudAskWpybzGWrxjXrjSUkELxTTKaL+TIEMzQeqBSGBwUc9nKq+?=
 =?us-ascii?Q?7WbiF0ZkVmII3SVExnvPSamM2l5QZRVfdNQWjrn8D29wh4QlQRhs4mfxxpmd?=
 =?us-ascii?Q?hkUuPrlRrgHfb4nUD8lxtzFX24mQaAEpsp1+6F3Fb45g7ApBxwawRb3VfCj7?=
 =?us-ascii?Q?gVsFLl1iRHLpg7eN2LWv4m935hdE3xkzi6Ae1RxK7ovDtJT9RibZNH+NPAkI?=
 =?us-ascii?Q?jeK5yN9b12F6H1DLMgNq/3jXj4dCI9IkMcT+cdrcSt4bE+en9QfcWjAFAFmD?=
 =?us-ascii?Q?VjjxCqvPtvpb9cGtmKB17iz1n1MoUggRMinP4TViu3NVTz5PMqkHezQ3KFuA?=
 =?us-ascii?Q?64TZqzfuMskGnhY6XhRsNntNmS4DT3iXK/zspMPoBFE5pWi4nHeRnqmV2l5s?=
 =?us-ascii?Q?BZ1DI5LyZUO9rn2K9RNyF5JwyZVzBzTKhZngu+JsrZVj5ikmBDkPZZSfm3P6?=
 =?us-ascii?Q?iim1ZlbpqFREA+Zc/5tPCBnp7K3biV9mOir09OBR+jSGhFSoSLRTGVRCbuMm?=
 =?us-ascii?Q?m05Qnqt8bIhHBejWQZJGuF/gOOu+PMKwWR4EBG0wTPSwUb1HAjber9/ntv3D?=
 =?us-ascii?Q?LpQub1JVzzXqfvwHs2KWGloQ63sJTQvIcfnxgelbXmkci7nqxtpAcSPrDiTy?=
 =?us-ascii?Q?NbJZM5zqU/q4Ze2qm0pnMOqq9qAChkvsfaTlTd7WsZt80HmlQ2sKSo4N8z56?=
 =?us-ascii?Q?inHtZt+EmexSWy05pqMNpWCUFIlNm26ov74qS4MtSmfRnzYHZQeoKt3/Ky1X?=
 =?us-ascii?Q?SMrE40Ih0Wnfl+cgCWK3u4JfwxSHHmwTTzjIAqqvx2LUEieltM+8XZ2ew52y?=
 =?us-ascii?Q?zrakH/dHskFUxdbxryUGnYc0sTcXI3mPL+fZm/yx0A4xcHpsRsyPQxAK1NGw?=
 =?us-ascii?Q?n2oijQr/QJFouADUjaZX7MWrCUA0sBmsNylV+e7bZ6/dfRyhUtb1mppHPt64?=
 =?us-ascii?Q?G+UodmKEiImOSaS7Q8OtT2LXvWcLolksewD8S4cl8v67t3V6zM6x4clDD6fJ?=
 =?us-ascii?Q?4BSbkkrcC2j2q9n0njg/wi86BsU9qiqc4zVg4NkLfxAygGXBZzoBV8A/Xxhc?=
 =?us-ascii?Q?/zOKvTIUNNiBAJMOXXw6862zRO1kDEtTxjswD1fj1VxBknjaM+jAoi7R+i36?=
 =?us-ascii?Q?3XIeQM8/tyw1ccs302bSSclX?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bca26882-c943-407a-8889-08d906689d11
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5101.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2021 15:01:03.4791
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sFxIxmSYZsJZV35r/fIGw7F1N3J5ztIJwutpbLmzID6KjoO6jxwwcFQh5roFn2hKWQm8LLx1W/8yKA2kPH4AZyZ16yuI3F5sctup97bEkaw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2589
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added .config_intr and .handle_interrupt callbacks.

Link event interrupt will trigger an interrupt every time when the link
goes up or down.

Signed-off-by: Radu Pirea (NXP OSS) <radu-nicolae.pirea@oss.nxp.com>
---
 drivers/net/phy/nxp-c45-tja11xx.c | 33 +++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/drivers/net/phy/nxp-c45-tja11xx.c b/drivers/net/phy/nxp-c45-tja11xx.c
index 95307097ebff..26b9c0d7cb9d 100644
--- a/drivers/net/phy/nxp-c45-tja11xx.c
+++ b/drivers/net/phy/nxp-c45-tja11xx.c
@@ -28,6 +28,11 @@
 #define DEVICE_CONTROL_CONFIG_GLOBAL_EN	BIT(14)
 #define DEVICE_CONTROL_CONFIG_ALL_EN	BIT(13)
 
+#define VEND1_PHY_IRQ_ACK		0x80A0
+#define VEND1_PHY_IRQ_EN		0x80A1
+#define VEND1_PHY_IRQ_STATUS		0x80A2
+#define PHY_IRQ_LINK_EVENT		BIT(1)
+
 #define VEND1_PHY_CONTROL		0x8100
 #define PHY_CONFIG_EN			BIT(14)
 #define PHY_START_OP			BIT(0)
@@ -188,6 +193,32 @@ static int nxp_c45_start_op(struct phy_device *phydev)
 				PHY_START_OP);
 }
 
+static int nxp_c45_config_intr(struct phy_device *phydev)
+{
+	if (phydev->interrupts == PHY_INTERRUPT_ENABLED)
+		return phy_set_bits_mmd(phydev, MDIO_MMD_VEND1,
+					VEND1_PHY_IRQ_EN, PHY_IRQ_LINK_EVENT);
+	else
+		return phy_clear_bits_mmd(phydev, MDIO_MMD_VEND1,
+					  VEND1_PHY_IRQ_EN, PHY_IRQ_LINK_EVENT);
+}
+
+static irqreturn_t nxp_c45_handle_interrupt(struct phy_device *phydev)
+{
+	irqreturn_t ret = IRQ_NONE;
+	int irq;
+
+	irq = phy_read_mmd(phydev, MDIO_MMD_VEND1, VEND1_PHY_IRQ_STATUS);
+	if (irq & PHY_IRQ_LINK_EVENT) {
+		phy_write_mmd(phydev, MDIO_MMD_VEND1, VEND1_PHY_IRQ_ACK,
+			      PHY_IRQ_LINK_EVENT);
+		phy_trigger_machine(phydev);
+		ret = IRQ_HANDLED;
+	}
+
+	return ret;
+}
+
 static int nxp_c45_soft_reset(struct phy_device *phydev)
 {
 	int ret;
@@ -560,6 +591,8 @@ static struct phy_driver nxp_c45_driver[] = {
 		.soft_reset		= nxp_c45_soft_reset,
 		.config_aneg		= nxp_c45_config_aneg,
 		.config_init		= nxp_c45_config_init,
+		.config_intr		= nxp_c45_config_intr,
+		.handle_interrupt	= nxp_c45_handle_interrupt,
 		.read_status		= nxp_c45_read_status,
 		.suspend		= genphy_c45_pma_suspend,
 		.resume			= genphy_c45_pma_resume,

base-commit: cad4162a90aeff737a16c0286987f51e927f003a
-- 
2.31.1

