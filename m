Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41AC81DAD9F
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 10:36:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbgETIg4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 04:36:56 -0400
Received: from mail-vi1eur05on2060.outbound.protection.outlook.com ([40.107.21.60]:39376
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726510AbgETIgz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 04:36:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QcjNcnIKpPq9RGUAg5+DKWx+UpdYH1O7N7/YjbPErIDe+F1If20vj96NdfPM962L2jZBy8m/Yqm53rpgjjQ3A9O3v8dtkLcXZar/GyE/S5u7+F8dR0eMhJJkvaoCWCoO2Bi7Mnx3m/VjUA0U1Lm5v7jso9CVayumvgzQ9XDjfZXJ6nXq88gUaA58oLDGOtUJiNgMr+C3OKG5W+XYDPBdvvNWz4x2HU72Ir5KaRVglo+TtqASessQuqj4SIltRh+1jCb1T4ziHrbmWdLv/aHXgg1gETCfHFPmftZtqoWZFUEjC0vdx3VYaoQ5vKzsP6zieR7tawOBGX8nyd7MLSaTFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BC/6xyZivY0BBzKKhmkREsqU1DqNc8XAYC6oFmZNwQw=;
 b=iMSVkaTySMUuFXiLfpaTOIMjrzx1ADAGXBwabGsKXk6IWN6RfbDAw2oZ8d3QxNzyJcBdaWjUY1J66IjtLVE814SQNe5ACb83EQuPzYv8XOnkTIiXSnBAIpvQiy8cSFT49rfNDnmKGFwFed5eGVgqUWeguFu7nQvem0BSkoMdud+lim3BKRNvsS4hSEbsISk1QhaB7klLM7AHECvyy2xdzeho6iNyu60EdF/8YJGKhZ5bsQlOi12kSU6PEzcR6MptC7O8/w7hPyeQsXLEcYaOumDov+GiWTVVvQL+W+8NLHXubrcirP4eyHo6Q1uMfiRaQuCNzy6tM3G2FhEKPdFwSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BC/6xyZivY0BBzKKhmkREsqU1DqNc8XAYC6oFmZNwQw=;
 b=G2O7IK7/bl9R6tqyqXBPgdW6xL8+RKFxNHp47w1ELHPMkHTAEcGEeHAiMmblLzNeQ74vasjmxQFeR0UhP0uy0QgbveouJGhZM/tZ8Qi0MlEQFVDw8atVsm/MKq/HVYUbUTuq4jCdRtPKIWNkmmmQ3weVJHUzjadL0Z14qO1GaxU=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18) by AM6PR0402MB3926.eurprd04.prod.outlook.com
 (2603:10a6:209:23::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20; Wed, 20 May
 2020 08:36:51 +0000
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1]) by AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1%7]) with mapi id 15.20.3000.034; Wed, 20 May 2020
 08:36:51 +0000
From:   fugang.duan@nxp.com
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, martin.fuzzey@flowbird.group,
        robh+dt@kernel.org, shawnguo@kernel.org,
        devicetree@vger.kernel.org, fugang.duan@nxp.com
Subject: [PATCH net 1/4] net: ethernet: fec: move GPR register offset and bit into DT
Date:   Wed, 20 May 2020 16:31:53 +0800
Message-Id: <1589963516-26703-2-git-send-email-fugang.duan@nxp.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1589963516-26703-1-git-send-email-fugang.duan@nxp.com>
References: <1589963516-26703-1-git-send-email-fugang.duan@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0233.apcprd06.prod.outlook.com
 (2603:1096:4:ac::17) To AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from b38611.ap.freescale.net (119.31.174.66) by SG2PR06CA0233.apcprd06.prod.outlook.com (2603:1096:4:ac::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.3021.23 via Frontend Transport; Wed, 20 May 2020 08:36:49 +0000
X-Mailer: git-send-email 2.7.4
X-Originating-IP: [119.31.174.66]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: fd563716-7c06-4828-6895-08d7fc98f16a
X-MS-TrafficTypeDiagnostic: AM6PR0402MB3926:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR0402MB3926583A67B8FC4A67C116F5FFB60@AM6PR0402MB3926.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:390;
X-Forefront-PRVS: 04097B7F7F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R/FrUQPiC0keFL9RYYgjdhi8NlpgQXiciy+h8mtbHZ8h+yL4KYmdxVHj7kJMQzUnx8FOJBe3EF6breHPGvGEXaAHqZMGMM4nlIPVPzvUfSiJ+sTG/NALgJq4eGlzGQiGUiHDIRl9FA+ZZfeG7TcK9PTCnbe5pjgf6TxrfQQBIYmh0Wgjsi9rZUus8HwvERGs0M1d7AWbFHunlovybtjYr82BlaqNFLZKiluW3AfSaCaalPHfzS3v4zrubC72bmpPbzhM0it12Oe5WzTAdp4Ot9GHDAvcMtuWaJJuHA6rq67kIoIf3dcvUq4L9Bv3M8WCkNiM4zW4zg8fgU1gaHHIaF19m1fAVeQ534/bwzb5y4M9TEkWIuKbvTEXrQKUHY4vyphJk7OPQnosNpl/4Qo8f9N/KDK93qPkU35p1e9CjjVNfhZVSGaH6I9/qbjxdvxI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0402MB3607.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(136003)(346002)(376002)(39860400002)(6916009)(8936002)(66476007)(8676002)(66946007)(86362001)(66556008)(316002)(2616005)(16526019)(478600001)(186003)(36756003)(26005)(4326008)(956004)(6512007)(6666004)(6486002)(9686003)(52116002)(6506007)(2906002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: oetMZ3sX4NdOtXUfaq0NTYHwQTSkl4jgRLTa3TqhftypKCmhjBIwlj85duGIFpd9W9opqTi7tumMsLvuECTX2dJ8dWjRnonTBf88OKIZJmuwOnGOlJ+MgDkwYZtypTJzDAS2rqGyHgb3MtMWulKySu+9QLAvyxCiOsR/xvNqeAESny3y2e8m+mdwb4WR6JzZDw+ZfgAyU348E2dhWcPIs3ykwjTSA28D/BUaCnv0YKIBEVHvsV/ZFrpRGEN/Q50CLPN7hV69WaOqg28bK+1hND+QQ8lDK5OyQri0Yx9s9Ghkj23ZPA25tZws+UCwG9fGCGPTTF/XUc7L44TK+vZhi3Tok3gTRfHSwKg8sFESi8S7kJ/iWIezgBWkfEpvD1xuglUUu5rZtPcaNtaJcIs8PodIbOr0LsI3JvB7ZhhkwDku2D88JUd068mwjwSVK9QO2hqUD9RHTJh0SmQY+kYpLpIt5X+TvDhkcXXLKC6Sj6E=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd563716-7c06-4828-6895-08d7fc98f16a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2020 08:36:51.3474
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DXu62j3W9Rttx/+GOaktvp5jJUnBm8RU2tWvdP6ceP7eCsK9xGr5/Z/khUxXgGLilzpyVD85hz8nNd2w1YULnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3926
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fugang Duan <fugang.duan@nxp.com>

The commit da722186f654(net: fec: set GPR bit on suspend by DT
configuration) set the GPR reigster offset and bit in driver for
wake on lan feature.

But it introduces two issues here:
- one SOC has two instances, they have different bit
- different SOCs may have different offset and bit

So to support wake-on-lan feature on other i.MX platforms, it should
configure the GPR reigster offset and bit from DT.

Fixes: da722186f654(net: fec: set GPR bit on suspend by DT configuration)
Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
---
 drivers/net/ethernet/freescale/fec_main.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 2e20914..9606411 100644
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
 	gpr_np = of_parse_phandle(np, "gpr", 0);
 	if (!gpr_np)
 		return 0;
 
+	ret = of_property_read_u32_array(np, "gpr", out_val,
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

