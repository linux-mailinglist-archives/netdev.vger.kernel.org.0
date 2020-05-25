Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 830AB1E12B6
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 18:32:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731495AbgEYQcJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 12:32:09 -0400
Received: from mail-eopbgr60065.outbound.protection.outlook.com ([40.107.6.65]:15847
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729338AbgEYQcI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 May 2020 12:32:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a821ByGBUhBzNuXa9tA8YwKJ49mzlJEclQ4ZcivmL2ohzHaKasMph26TF9llkm4eU2ncGXMusnudDI0Kvb/VfT+7DYtWqxV2n1hovEbNZCemEdhxmmvtTIbv0t4wtK9vU4GR2KqhASrfYM1CM7EKzkTMSoHcywrCYL880ywi0tXSA3b8qkY6BzUwbZq+IJmdHrkG76YA4fZFPuS9AeRSEjHtfgWNKB3EOkNcoumLeOmE3GkFx+ypyIlcOLV101dd3wWZTDWhpO0Xcaz8+0xvNHsL8dU1XV0ex6c/r5vuz2dUGtBklF6PeYg6W519C9Rapn5yJudY+a046wISF4VTcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qx3HlQSEGvPlfVepfmhd/RzxIYm4q/1y422NOQBkQVk=;
 b=V3zwRrlme2u26L0YSf5r0JyMGEgEk9AgVgG36y+3pWgeE4nEnq6XORDBsnFIoCO1bQKmEMyENPIwC4tQRZR+HK1PoEWkrtGWS490XAsifXxMMdN9WzQgUornldE12sOV+iPsuGkV7gJnMK9R9VL6/ThbmIylHH0cOopDYjuJz6varsnv8XAsoykjDHQZ6nOSxN56KRwcMVi3c38A432sqytspg/SkBEZLq6HDpknfF4E3c75pHvSd4WrmVQnSGexRMT6zyzhfiEb/1gfMLYadeN2/J1TKVzVE0Jp0ztTKzfec3+MKLnatGU4kicncNz6rzGbXcPrCrAlb0huHyMcmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qx3HlQSEGvPlfVepfmhd/RzxIYm4q/1y422NOQBkQVk=;
 b=WGeyvs4nl5VYH6LD8KImnbNoeySPNAzLxTbigw3L9zX5b0sLjqbYoJi0ChhN5gByPCdVMbVik3cyrdk4J7rlwGbDCKedDJhaN0yzN2j0PUWMAaAiTQdzZqdQ+7MBF2X/r5UdI/ny/c+0ZYFrN8BrZzJ+hxdj4R42UcXamLMKEjU=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18) by AM6PR0402MB3384.eurprd04.prod.outlook.com
 (2603:10a6:209:6::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Mon, 25 May
 2020 16:32:05 +0000
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1]) by AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1%7]) with mapi id 15.20.3021.029; Mon, 25 May 2020
 16:32:05 +0000
From:   fugang.duan@nxp.com
To:     andrew@lunn.ch, martin.fuzzey@flowbird.group, davem@davemloft.net,
        s.hauer@pengutronix.de
Cc:     netdev@vger.kernel.org, robh+dt@kernel.org, shawnguo@kernel.org,
        devicetree@vger.kernel.org, kuba@kernel.org, fugang.duan@nxp.com
Subject: [PATCH net v3 1/4] net: ethernet: fec: move GPR register offset and bit into DT
Date:   Tue, 26 May 2020 00:27:10 +0800
Message-Id: <1590424033-16906-2-git-send-email-fugang.duan@nxp.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1590424033-16906-1-git-send-email-fugang.duan@nxp.com>
References: <1590424033-16906-1-git-send-email-fugang.duan@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0102.apcprd01.prod.exchangelabs.com
 (2603:1096:3:15::28) To AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from b38611.ap.freescale.net (119.31.174.66) by SG2PR01CA0102.apcprd01.prod.exchangelabs.com (2603:1096:3:15::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.3021.23 via Frontend Transport; Mon, 25 May 2020 16:32:02 +0000
X-Mailer: git-send-email 2.7.4
X-Originating-IP: [119.31.174.66]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4f3f5519-f52f-4392-81d9-08d800c9292c
X-MS-TrafficTypeDiagnostic: AM6PR0402MB3384:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR0402MB3384D8203F99E0D02967C35DFFB30@AM6PR0402MB3384.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:514;
X-Forefront-PRVS: 0414DF926F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HT/UP/zYKsOE7VK2nNwQltoyHB6iHt7zzkcF3hcHmgLaGM6mqF24B+UWDNCFIXXM6GLj7+g2u7qRbMy/A5HJECrh2YKO96vnSqnZ/uPlpYSOl9qlYtm5XaIQrQMnaS7on0ELWJIZr3cl9sTQe4quLmEL+h3fqAWsKqBzU4KfdpUZ73DpTiD6zCHnclh8pIs0jF3IJ8VOvK/VCP4fnladLW1ZTGKhXh/NuY6G+2vU2ywLSpi11oEt/DyRT2Np1OUGT9IDZotyr6gSAdpdvNTUqX6eFeQWfindLBCurDapISx6sY70J0bVhMe9366B9ixZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0402MB3607.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(366004)(136003)(396003)(39860400002)(346002)(66946007)(66556008)(66476007)(186003)(16526019)(6506007)(6486002)(6666004)(8676002)(86362001)(26005)(8936002)(52116002)(478600001)(36756003)(956004)(2616005)(2906002)(316002)(9686003)(5660300002)(4326008)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: n7t+1BWmTw0DAdaXDj8QHt192/akOgrc6DfdrfVqRw3fTfgM85aq/gwdAlnDdKtgD3iIGlV/kPs6HhQ/etJyHxZpwomRI341d6WegkTomBHmd6t/YaNqWkUZ6NZj4tk5Ot4P4A+TbITcLDBoeYTOa2Nw0RP3SagqwkkDUzgTZsZCNLU0uqsVPwh84hkSoam7g6kHzRFlMqDNslpeaytc/qWrSDQlFe/XEAWg8T/gMeSyQefuvlxkqBRMvH2gtoO2WwVMRACSl8sOsFXlE6Lr7Js6IspmAsKtm2fHiQ0p08O9RYbW5XAVTaxWheTHX/Pj8eT1JbmF130PsES6kLNS6L2esMF7aR9/fVm6/yfEN+N9c4dr2qG8S2IbPt84FrIPJ2W5kxPzgKdIQ4ymw+jYN0xQ6wQDN0KQBnXT2oXHsdbRHuQZhGEAcczbRodxazaPimoXhF6p6HqegImXo5pNgt4sdc8AejOj9gxp4b6C+QrqSE55RBimSoVsVwHOqlC0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f3f5519-f52f-4392-81d9-08d800c9292c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2020 16:32:05.3823
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8OLcA1hahGyJAQugZZvfT3EY+kYM5R1siH+5jhqxegjfudPnUv+n1xunXJ7MdwAcUK9y4dMf1wbq/e9whutPYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3384
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fugang Duan <fugang.duan@nxp.com>

The commit da722186f654 (net: fec: set GPR bit on suspend by DT
configuration) set the GPR reigster offset and bit in driver for
wake on lan feature.

But it introduces two issues here:
- one SOC has two instances, they have different bit
- different SOCs may have different offset and bit

So to support wake-on-lan feature on other i.MX platforms, it should
configure the GPR reigster offset and bit from DT.

So the patch is to improve the commit da722186f654 (net: fec: set GPR
bit on suspend by DT configuration) to support multiple ethernet
instances on i.MX series.

v2:
 * switch back to store the quirks bitmask in driver_data
v3:
 * suggested by Sascha Hauer, use a struct fec_devinfo for
   abstracting differences between different hardware variants,
   it can give more freedom to describe the differences.

Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
---
 drivers/net/ethernet/freescale/fec_main.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 2e20914..4acb91d 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -88,8 +88,6 @@ static void fec_enet_itr_coal_init(struct net_device *ndev);
 
 struct fec_devinfo {
 	u32 quirks;
-	u8 stop_gpr_reg;
-	u8 stop_gpr_bit;
 };
 
 static const struct fec_devinfo fec_imx25_info = {
@@ -112,8 +110,6 @@ static const struct fec_devinfo fec_imx6q_info = {
 		  FEC_QUIRK_HAS_BUFDESC_EX | FEC_QUIRK_HAS_CSUM |
 		  FEC_QUIRK_HAS_VLAN | FEC_QUIRK_ERR006358 |
 		  FEC_QUIRK_HAS_RACC,
-	.stop_gpr_reg = 0x34,
-	.stop_gpr_bit = 27,
 };
 
 static const struct fec_devinfo fec_mvf600_info = {
@@ -3476,19 +3472,23 @@ static int fec_enet_get_irq_cnt(struct platform_device *pdev)
 }
 
 static int fec_enet_init_stop_mode(struct fec_enet_private *fep,
-				   struct fec_devinfo *dev_info,
 				   struct device_node *np)
 {
 	struct device_node *gpr_np;
+	u32 out_val[3];
 	int ret = 0;
 
-	if (!dev_info)
-		return 0;
-
-	gpr_np = of_parse_phandle(np, "gpr", 0);
+	gpr_np = of_parse_phandle(np, "fsl,stop-mode", 0);
 	if (!gpr_np)
 		return 0;
 
+	ret = of_property_read_u32_array(np, "fsl,stop-mode", out_val,
+					 ARRAY_SIZE(out_val));
+	if (ret) {
+		dev_dbg(&fep->pdev->dev, "no stop mode property\n");
+		return ret;
+	}
+
 	fep->stop_gpr.gpr = syscon_node_to_regmap(gpr_np);
 	if (IS_ERR(fep->stop_gpr.gpr)) {
 		dev_err(&fep->pdev->dev, "could not find gpr regmap\n");
@@ -3497,8 +3497,8 @@ static int fec_enet_init_stop_mode(struct fec_enet_private *fep,
 		goto out;
 	}
 
-	fep->stop_gpr.reg = dev_info->stop_gpr_reg;
-	fep->stop_gpr.bit = dev_info->stop_gpr_bit;
+	fep->stop_gpr.reg = out_val[1];
+	fep->stop_gpr.bit = out_val[2];
 
 out:
 	of_node_put(gpr_np);
@@ -3575,7 +3575,7 @@ fec_probe(struct platform_device *pdev)
 	if (of_get_property(np, "fsl,magic-packet", NULL))
 		fep->wol_flag |= FEC_WOL_HAS_MAGIC_PACKET;
 
-	ret = fec_enet_init_stop_mode(fep, dev_info, np);
+	ret = fec_enet_init_stop_mode(fep, np);
 	if (ret)
 		goto failed_stop_mode;
 
-- 
2.7.4

