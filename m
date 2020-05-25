Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E19B1E0796
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 09:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389033AbgEYHOe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 03:14:34 -0400
Received: from mail-eopbgr70053.outbound.protection.outlook.com ([40.107.7.53]:1606
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388932AbgEYHOd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 May 2020 03:14:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=moD6U0DEaSy52PebIwxQxVQRx3qNkrqdng4GYrq3+EiFlkro/t/kcPV8532/HrX3KaW5qOEIwAakgu83OMzPI8X+3yv13S6IM3FISxlfsLY8CWHdmv1Z4dqXi99qsQXlIz/RCM929yVh3tnNwrebOXNZ4IANlA75vzB3XCzlNQ8852FcMb+k0PiL0N1EevUwz3/Kl4mPWV4CQ/9zwyvoCoxbnpjK+1Grmg1fIMQh6bWBHhYM6Dqh3zXAdOUH0cXMH8CtXkKKyhn/9syA69L/BUQyxfMHDb60/4WxPn3uWgf5cT8I/3NkoUC6DxJMZ2ftHnDczyps4UY4JnLWdGK9pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dk/r10oOGlggvwxNm1mFwelto6OD56anTW2eXX7sszY=;
 b=B8f2u0dGbBJkBEQ0FRyLGigcm/x4gbQXU37gFZ54mVjljOXctzlh/dQVuYu6zIoNlGM8HGD5m2lq3KI5Jh0vgwFj4jkDPcKyDcVEOMy9e7NIu0cB+5Btup6+jGJ5WxaGsgPrDkB0KFF+DqwJYAeMtp7nEAJJq0N7ZxxT7MvekN4If1gwxYzE7/zMU4NstqBaOQwl0r9KeEtbodx3kyF7AHoZrooUeolfDGb+qT8AAJH99Eii2NEzeLj0IqaMqr9drfKFUtNiwz/C9sGQCzaGPrOudmHRGts7iFF9cKEJ549fqFLr3P7H6EFV+p3koyZCwC8Ty9wseMphOCZr5JJM+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dk/r10oOGlggvwxNm1mFwelto6OD56anTW2eXX7sszY=;
 b=mmKwhY8DtZMTZS1Mx784BOyGqE0fEFnb9fTtDBbCKJXJDNdXEx/o636LqCrG9E7vlraD0f2feBaRRO05Ybuzl6dsnULE8/P9nvWkr+/XB//2eCXLWhixj7kb8kysxKtBOcLBOz4Rd+qe0/vKbycwCF5qV7s0FMrN49+xxpqi+Hg=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18) by AM6PR0402MB3735.eurprd04.prod.outlook.com
 (2603:10a6:209:1a::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Mon, 25 May
 2020 07:14:18 +0000
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1]) by AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1%7]) with mapi id 15.20.3021.029; Mon, 25 May 2020
 07:14:18 +0000
From:   fugang.duan@nxp.com
To:     andrew@lunn.ch, martin.fuzzey@flowbird.group, davem@davemloft.net
Cc:     netdev@vger.kernel.org, robh+dt@kernel.org, shawnguo@kernel.org,
        devicetree@vger.kernel.org, kuba@kernel.org, fugang.duan@nxp.com
Subject: [PATCH net v2 1/4] net: ethernet: fec: move GPR register offset and bit into DT
Date:   Mon, 25 May 2020 15:09:26 +0800
Message-Id: <1590390569-4394-2-git-send-email-fugang.duan@nxp.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1590390569-4394-1-git-send-email-fugang.duan@nxp.com>
References: <1590390569-4394-1-git-send-email-fugang.duan@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0213.apcprd06.prod.outlook.com
 (2603:1096:4:68::21) To AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from b38611.ap.freescale.net (119.31.174.66) by SG2PR06CA0213.apcprd06.prod.outlook.com (2603:1096:4:68::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.3021.23 via Frontend Transport; Mon, 25 May 2020 07:14:15 +0000
X-Mailer: git-send-email 2.7.4
X-Originating-IP: [119.31.174.66]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 84bbd32c-7867-4323-0b40-08d8007b3d55
X-MS-TrafficTypeDiagnostic: AM6PR0402MB3735:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR0402MB37353C8B0B7C667BC8B3D84AFFB30@AM6PR0402MB3735.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2000;
X-Forefront-PRVS: 0414DF926F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vq87qQQp4wn+QEV8Z+XXWtgj0C+aGSl657Fj2pwY01N1AvNr22D7iAHhnxjpklECJvSieVDG7p9dROJI900VM74OQk36TL3PEQGX9XkSfvRMRo+naMS97rGEgk9YVxiY2JgyZHE0GzVAP32pxiAAlJ1ARlv4YJf5WtdO6t1AQvL+WNu6I+Pml1o4mARXwlhkUjOJb9yoik5ZcL4hG+oRqux3bRJyh0Vgrfl/mol+YZlzEJ+RxVsO7CHYnw1NQ/o9d7rmM6NSpA5lDuTCF4DzQhjT2XA4i8DF+WrHhcTU9H/VVejBUDHcs3MNqgOB9qsN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0402MB3607.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(39860400002)(136003)(346002)(376002)(366004)(316002)(956004)(2616005)(66476007)(52116002)(6506007)(66556008)(66946007)(86362001)(36756003)(26005)(5660300002)(6486002)(16526019)(186003)(6512007)(2906002)(8676002)(9686003)(478600001)(8936002)(4326008)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: gbmvivzRwQz1LZkfmPbDk5tfpmWX8adzkVZx25LBlFx9kT3XDeBTnexFi4iLs5W3C2bA+FM9tPy1HOM6uGr2MNOlZTZMdqJ6KBX6jVN8tdlvIBpeR3RM//v9VaLudlOraFyMHdN/wnYcRMd6alVRcyZy6J/uBhX42iO3mEdA70rP7mfakr+jO6zPlaMpSXpmbAIhEMpRiPjX5g022GxGXln+l3NbG5hpd6RqCgKWP6bZfeIlE8aRqJZOwuroPaFhEIYX0kVxEMwcoTilX8P3Ey5qRCw3jMMDq8rpJANJyf8nVlOlGiUsiDwTwsvS6SW7SWlbQH3nSkdtVQOK+60JdgS39oNop/yCkrxbxgiX5upHfPvaqAP0/ojE1QqD3kWE6GJsshMmG3DVRrvvWGYT3OjgZUKQaw1I+Gbg1fL4lmnZ1+93+oz9Kl4Nd+et/av7uAn4yiHfcHKGPc3mDyNIlcNCxdNPe5+/hAvz+sLFkjI=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84bbd32c-7867-4323-0b40-08d8007b3d55
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2020 07:14:18.6434
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E+FxINdAT4q+9WTYZoPr+fuvQEBN/Jgr3m9uYOrpJFj2vSHGX4t9+C8nR8CVLeTz8FyJg54TPXza5cpaM1AkhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3735
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

Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
---
 drivers/net/ethernet/freescale/fec_main.c | 103 ++++++++++--------------------
 1 file changed, 34 insertions(+), 69 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 2e20914..4f55d30 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -86,56 +86,6 @@ static void fec_enet_itr_coal_init(struct net_device *ndev);
 #define FEC_ENET_OPD_V	0xFFF0
 #define FEC_MDIO_PM_TIMEOUT  100 /* ms */
 
-struct fec_devinfo {
-	u32 quirks;
-	u8 stop_gpr_reg;
-	u8 stop_gpr_bit;
-};
-
-static const struct fec_devinfo fec_imx25_info = {
-	.quirks = FEC_QUIRK_USE_GASKET | FEC_QUIRK_MIB_CLEAR |
-		  FEC_QUIRK_HAS_FRREG,
-};
-
-static const struct fec_devinfo fec_imx27_info = {
-	.quirks = FEC_QUIRK_MIB_CLEAR | FEC_QUIRK_HAS_FRREG,
-};
-
-static const struct fec_devinfo fec_imx28_info = {
-	.quirks = FEC_QUIRK_ENET_MAC | FEC_QUIRK_SWAP_FRAME |
-		  FEC_QUIRK_SINGLE_MDIO | FEC_QUIRK_HAS_RACC |
-		  FEC_QUIRK_HAS_FRREG,
-};
-
-static const struct fec_devinfo fec_imx6q_info = {
-	.quirks = FEC_QUIRK_ENET_MAC | FEC_QUIRK_HAS_GBIT |
-		  FEC_QUIRK_HAS_BUFDESC_EX | FEC_QUIRK_HAS_CSUM |
-		  FEC_QUIRK_HAS_VLAN | FEC_QUIRK_ERR006358 |
-		  FEC_QUIRK_HAS_RACC,
-	.stop_gpr_reg = 0x34,
-	.stop_gpr_bit = 27,
-};
-
-static const struct fec_devinfo fec_mvf600_info = {
-	.quirks = FEC_QUIRK_ENET_MAC | FEC_QUIRK_HAS_RACC,
-};
-
-static const struct fec_devinfo fec_imx6x_info = {
-	.quirks = FEC_QUIRK_ENET_MAC | FEC_QUIRK_HAS_GBIT |
-		  FEC_QUIRK_HAS_BUFDESC_EX | FEC_QUIRK_HAS_CSUM |
-		  FEC_QUIRK_HAS_VLAN | FEC_QUIRK_HAS_AVB |
-		  FEC_QUIRK_ERR007885 | FEC_QUIRK_BUG_CAPTURE |
-		  FEC_QUIRK_HAS_RACC | FEC_QUIRK_HAS_COALESCE,
-};
-
-static const struct fec_devinfo fec_imx6ul_info = {
-	.quirks = FEC_QUIRK_ENET_MAC | FEC_QUIRK_HAS_GBIT |
-		  FEC_QUIRK_HAS_BUFDESC_EX | FEC_QUIRK_HAS_CSUM |
-		  FEC_QUIRK_HAS_VLAN | FEC_QUIRK_ERR007885 |
-		  FEC_QUIRK_BUG_CAPTURE | FEC_QUIRK_HAS_RACC |
-		  FEC_QUIRK_HAS_COALESCE,
-};
-
 static struct platform_device_id fec_devtype[] = {
 	{
 		/* keep it for coldfire */
@@ -143,25 +93,39 @@ static struct platform_device_id fec_devtype[] = {
 		.driver_data = 0,
 	}, {
 		.name = "imx25-fec",
-		.driver_data = (kernel_ulong_t)&fec_imx25_info,
+		.driver_data = FEC_QUIRK_USE_GASKET | FEC_QUIRK_MIB_CLEAR |
+			       FEC_QUIRK_HAS_FRREG,
 	}, {
 		.name = "imx27-fec",
-		.driver_data = (kernel_ulong_t)&fec_imx27_info,
+		.driver_data = FEC_QUIRK_MIB_CLEAR | FEC_QUIRK_HAS_FRREG,
 	}, {
 		.name = "imx28-fec",
-		.driver_data = (kernel_ulong_t)&fec_imx28_info,
+		.driver_data = FEC_QUIRK_ENET_MAC | FEC_QUIRK_SWAP_FRAME |
+				FEC_QUIRK_SINGLE_MDIO | FEC_QUIRK_HAS_RACC |
+				FEC_QUIRK_HAS_FRREG,
 	}, {
 		.name = "imx6q-fec",
-		.driver_data = (kernel_ulong_t)&fec_imx6q_info,
+		.driver_data = FEC_QUIRK_ENET_MAC | FEC_QUIRK_HAS_GBIT |
+				FEC_QUIRK_HAS_BUFDESC_EX | FEC_QUIRK_HAS_CSUM |
+				FEC_QUIRK_HAS_VLAN | FEC_QUIRK_ERR006358 |
+				FEC_QUIRK_HAS_RACC,
 	}, {
 		.name = "mvf600-fec",
-		.driver_data = (kernel_ulong_t)&fec_mvf600_info,
+		.driver_data = FEC_QUIRK_ENET_MAC | FEC_QUIRK_HAS_RACC,
 	}, {
 		.name = "imx6sx-fec",
-		.driver_data = (kernel_ulong_t)&fec_imx6x_info,
+		.driver_data = FEC_QUIRK_ENET_MAC | FEC_QUIRK_HAS_GBIT |
+				FEC_QUIRK_HAS_BUFDESC_EX | FEC_QUIRK_HAS_CSUM |
+				FEC_QUIRK_HAS_VLAN | FEC_QUIRK_HAS_AVB |
+				FEC_QUIRK_ERR007885 | FEC_QUIRK_BUG_CAPTURE |
+				FEC_QUIRK_HAS_RACC | FEC_QUIRK_HAS_COALESCE,
 	}, {
 		.name = "imx6ul-fec",
-		.driver_data = (kernel_ulong_t)&fec_imx6ul_info,
+		.driver_data = FEC_QUIRK_ENET_MAC | FEC_QUIRK_HAS_GBIT |
+				FEC_QUIRK_HAS_BUFDESC_EX | FEC_QUIRK_HAS_CSUM |
+				FEC_QUIRK_HAS_VLAN | FEC_QUIRK_ERR007885 |
+				FEC_QUIRK_BUG_CAPTURE | FEC_QUIRK_HAS_RACC |
+				FEC_QUIRK_HAS_COALESCE,
 	}, {
 		/* sentinel */
 	}
@@ -3476,19 +3440,23 @@ static int fec_enet_get_irq_cnt(struct platform_device *pdev)
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
@@ -3497,8 +3465,8 @@ static int fec_enet_init_stop_mode(struct fec_enet_private *fep,
 		goto out;
 	}
 
-	fep->stop_gpr.reg = dev_info->stop_gpr_reg;
-	fep->stop_gpr.bit = dev_info->stop_gpr_bit;
+	fep->stop_gpr.reg = out_val[1];
+	fep->stop_gpr.bit = out_val[2];
 
 out:
 	of_node_put(gpr_np);
@@ -3521,7 +3489,6 @@ fec_probe(struct platform_device *pdev)
 	int num_rx_qs;
 	char irq_name[8];
 	int irq_cnt;
-	struct fec_devinfo *dev_info;
 
 	fec_enet_get_queue_num(pdev, &num_tx_qs, &num_rx_qs);
 
@@ -3539,9 +3506,7 @@ fec_probe(struct platform_device *pdev)
 	of_id = of_match_device(fec_dt_ids, &pdev->dev);
 	if (of_id)
 		pdev->id_entry = of_id->data;
-	dev_info = (struct fec_devinfo *)pdev->id_entry->driver_data;
-	if (dev_info)
-		fep->quirks = dev_info->quirks;
+	fep->quirks = pdev->id_entry->driver_data;
 
 	fep->netdev = ndev;
 	fep->num_rx_queues = num_rx_qs;
@@ -3575,7 +3540,7 @@ fec_probe(struct platform_device *pdev)
 	if (of_get_property(np, "fsl,magic-packet", NULL))
 		fep->wol_flag |= FEC_WOL_HAS_MAGIC_PACKET;
 
-	ret = fec_enet_init_stop_mode(fep, dev_info, np);
+	ret = fec_enet_init_stop_mode(fep, np);
 	if (ret)
 		goto failed_stop_mode;
 
-- 
2.7.4

