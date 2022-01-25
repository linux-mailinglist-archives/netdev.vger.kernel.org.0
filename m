Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE8A649B9C7
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 18:10:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239971AbiAYRJF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 12:09:05 -0500
Received: from mx0c-0054df01.pphosted.com ([67.231.159.91]:40512 "EHLO
        mx0c-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239799AbiAYRFz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 12:05:55 -0500
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20PCEDgf028781;
        Tue, 25 Jan 2022 12:05:49 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2052.outbound.protection.outlook.com [104.47.61.52])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3dsvtr0y1c-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jan 2022 12:05:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bVYAYHMSdpSRddDbUCQPLbU1/523ih17hnO1WsILnQlhjGdN5KrlpF5NGM56YTdrFcCxdzgXEPt686hu8xBNvheinTAiKeZQSfgepa4iO9BUxWjH7Sc/R6pwXs4YVonibX7UsFZkhDbn1b0w4Gb/llCGSJaSv8b35I0X5sNK77X3KJeu0Y9kQlQhGYAOwdPA9DeEUatQgMbvIFEIEJRNSAFCE4aSjbDOhQmj4Uvx7r8KnD0UpQGHlQ1B0qDIKDM1iSQmpbQ1NXXKrpD4iRTHUzX0rseuCRs7eGvFegRMHQy2bCk8hJZSZL2DWaKt2cxvwI5TL/a9y/HdS+jor669og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kQ7NoiSYcO0uBl+S4luF/pktSy4roBfQJhzvthSIf7A=;
 b=OqQHVhXzqBT53PtTKo6zbF7l2OkX+JBmFMo6nHaKIdWD9k3Yb+bMOdQLz1DpFP7kTK5UuDvPVPMneEzudGKsX1ek1R96Y6lJQXjj6ApfCCSShrtFTd2HcW9IsIc3LfGTOfmxPVTGMgGWD1lCib5AKfE0206gWrIQt75u3n47Q1bco5snVqUVBbPlXatj5O1SoYu/1+mfm+SlTWcHG90OYv0UIhKUSgbsQr0IizL0zfDpTRJ/vmY90aMdZ5QQ2iUB0bfoojWojglOohY5BWNiQXTUjNeWWoUQI5jj7A5r8v2YlkMb12O1gxj9Ndyhtaax2g3HfSwcQy19GcrQWJix5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kQ7NoiSYcO0uBl+S4luF/pktSy4roBfQJhzvthSIf7A=;
 b=Qst0P+2vLvf7xc7sLbu2WmQiAR8Ikr88x3kE7B/o1AGmUTVsFARnpM+DwJJxZKlvPDrkofKZm+pFWs/Y0aUWwFaRUZrKuamsk82c4Bu7vBu/92Due5MYspLIXllOT59VDKrYzvRsUUaB8Xys5j6WE2cVP7bz1ZILeIWHCS0vvbQ=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YQXPR0101MB1144.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c00:1e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.8; Tue, 25 Jan
 2022 17:05:48 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8%2]) with mapi id 15.20.4888.020; Tue, 25 Jan 2022
 17:05:48 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        michal.simek@xilinx.com, nicolas.ferre@microchip.com,
        claudiu.beznea@microchip.com, devicetree@vger.kernel.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v2 2/3] net: macb: Added ZynqMP-specific initialization
Date:   Tue, 25 Jan 2022 11:05:32 -0600
Message-Id: <20220125170533.256468-3-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220125170533.256468-1-robert.hancock@calian.com>
References: <20220125170533.256468-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR21CA0031.namprd21.prod.outlook.com
 (2603:10b6:300:129::17) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:6a::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 42e40513-f15b-4911-5e29-08d9e024eeb2
X-MS-TrafficTypeDiagnostic: YQXPR0101MB1144:EE_
X-Microsoft-Antispam-PRVS: <YQXPR0101MB114492D8B5910165C2B278CEEC5F9@YQXPR0101MB1144.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gwRwu4HlNwzterg/P7ZIM0OZBzuo51UQlU7i+NlqUFvwT5kJg2LPS44QFSsxIfgjI2sFMTJS5D/R8WeeJJ3XqN3ReJ2gmNe/Kv5Iv8LGhVrX0uMwkQQY/Y248mf9WwCAwddzs84sIify58GqvecNDHSg+WheyGnRdgogfiLpugTUTEs7UODv9tEaH4HSmoDUL9GzqvhQSHja+cz+uveTOVGrWVyqj9nh7PMope2P7aiahQXPhNB4zFdpCuAOrQ4umg07f7us7NcCV+m3Hp0G0mxMIScD5DdFOqzz4lM/sHrx0AIc3Vw/auS+BMmjoDyeK+Wf5NBVJ9OjY8zRrSiCZ6YrC7x+OhkDIvGSgW9noqruB8kpQ87emeMf5UdRVi+KbQlz30Vpi/e2Zx//TXuKSswmPXebuV91vb6Vnpn1KCOEGwKFYX6BXLdr1M32qNoz2qCXaO0yE63AR30tpMK8Z+OIe1UYarCx5hDF8NbO5I4/vGOc2TQQyXyu7i8tqnuGmBcFeCqJDshqNW1OfUWO0J21FDRXBSoAsRmJKLH+QNVzIW3ZcVL+cfe9B/cZ7eU/+lnJBianohIrdyOmvEEJxXunjCdcC7op/Pptlynysfl9CqxcflNzCP3GKwOmAYJm4LkS89pHNl95RtS/YVtIS6gNPYKY1/OnubU1Z4DdCfGCIl9CpnEtDicbcx8WXiLXbfIZuFx7r2/SMweO39PUZw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(6916009)(8936002)(2616005)(66556008)(6666004)(44832011)(83380400001)(6506007)(38100700002)(8676002)(38350700002)(86362001)(2906002)(6486002)(508600001)(316002)(107886003)(6512007)(1076003)(52116002)(36756003)(4326008)(26005)(186003)(66476007)(5660300002)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Xmgm2unVh0wFiRGZLnmG/o005gf3ZizZBXee1g6HSnFs8ffrvEmlWKSEDiyu?=
 =?us-ascii?Q?RwTkzXwbQGhnGaOzXdd8LnJmsK6bdNSn8a0duPB7WLDWgmUEKa6F5AQQA4eH?=
 =?us-ascii?Q?4FtocP7az2NVjmo3M7g9kfmBJSs0ej3QPAyLefyD/Zwzingi0zng8Az5mPOO?=
 =?us-ascii?Q?GV4ij/8IcJZeiQ/koMwN9wGktpTtMmWLn3NJeVCy6zJBfdacmU+nP+ucmyjI?=
 =?us-ascii?Q?bu2yC6IKLg0ePt0bE3C+GyYcdcSulZG1FfVJZ/uQJR68szMH5ZFQbWo7UZf0?=
 =?us-ascii?Q?btU9jeoBg7eig3OBsT3I5fQor/a6Q/2eKGTWYUBwkaZ1oQcn9AUFewxMOzX2?=
 =?us-ascii?Q?lFlw6s3LvO6EcVGSUDLIS+uKoxVsK/gsXMNQPpyzfGr81OGV/VffakjZQXgh?=
 =?us-ascii?Q?PweL1ybv2oyYYeM2gY/rCNm3dZtAqEZtB71JB+c0b0sKlOfWvzU8UVkUVLe5?=
 =?us-ascii?Q?OV77AVtrxTxTXDQul5NlSSl+ooYtJ/NM5jeswkr5YD7vt87T2+ORBsvX6OEm?=
 =?us-ascii?Q?DxN5/2ZhWxNax3TViUKIfrwhbVUocNkDy7Q9Ov6286tlz2Ke5pHpH9fn13dh?=
 =?us-ascii?Q?7CsgN8pDdpu7w2kBXM2un3jn2ersnTlsjgdOSBGYrI+SCgG4DUPAxFfmZ8vZ?=
 =?us-ascii?Q?RiEYrlrcTt/bMCAqbdBRUjQg8uBpnRQi4M6ryh5w5fxBLARGr2ZLlBC4H9Ro?=
 =?us-ascii?Q?z9FxktwJMwp1SC68FU4N39Tzjn+MKdxJJZ3jcoMHHKPU9WcrpTKHsnx1+KUM?=
 =?us-ascii?Q?B9AZKsU6xQN3p6ga6rfOL4Em6sV2jpnyXH1ys7lHdaq3voouKLb54lvfyiZ8?=
 =?us-ascii?Q?rUA0+gaPE4epaP3u5ZeWYC17W740skh0hvMwdAldB2FxTZsJ9ocK7Jy/9Ndc?=
 =?us-ascii?Q?ZY8RVPzkJKSidNQD9zhBPXcAp3NJy1CEWr6M92WbwE+G1f97Arot7mdDQDln?=
 =?us-ascii?Q?3Mj0xcWsBkyHeQCFNFRuERTlVE+PSu+Ts252qU+79o+bIBCoscbZEE4CtI4O?=
 =?us-ascii?Q?WdnNXQOokfVTeDMUGxwyya+cLFqHZm5Xh0yXnHJhm6oGJ8QvhGDrMIKR1wvj?=
 =?us-ascii?Q?nkaBC82fHJZAaI/s8QygtKOnlGOixhOUZDEEf8hDUjpic1IroPXbUfCvSl4T?=
 =?us-ascii?Q?MtNU+dGJa1GxZU2l5aGpcCdddzEHJMTBhlFZYWLqnE25w7QMm+aC7N/2Kuza?=
 =?us-ascii?Q?UDYi4p/5uqt7g5x7KHqCuqtNRsrKJS0xQ4zYfEtp2WXpLY7j7SEAws3EHIau?=
 =?us-ascii?Q?yS4mZo1Jwb3wPIK3TnqhoPLNkCCPXAwL7UDndAuKmfjDcohOorimOkIJluYY?=
 =?us-ascii?Q?8ZRXzNux+2XfXichBzZLOcWuq+cHJUnF4MdYVmuPiT6CAFwPjQUMaaZpkvMV?=
 =?us-ascii?Q?tMaatcB5AzLqBQ+9Y61txiIE5gRpqCUCCHEnUim0WGDiP6uZFiu1iOXmV9tL?=
 =?us-ascii?Q?rNyes2EEtfq1jcpb3ViEIDeOMEwjdJYeqKIztNqBwIDUXUsH91kp/iBrCAq+?=
 =?us-ascii?Q?6Lfss1NHtGMCwBQMQ5EAxdl/dOtghF3B2Z9Q9GqTOHmrMdmlz/elJmUrLJcH?=
 =?us-ascii?Q?NpYfXXhRlgYWxrQDX84f7gA7RzyRp0TSryhStD70ZCEMBF9naNUZkXXrfakc?=
 =?us-ascii?Q?RXxbHNRxrqYIyxjFh8C2UuMrNwUxkfTL8pzkBNWTcFkeOUnqRUEb5As8a9i8?=
 =?us-ascii?Q?0YZpWXGFpFH98I098EUUE7mbfZ0=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42e40513-f15b-4911-5e29-08d9e024eeb2
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2022 17:05:47.9309
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4So/JnKE+K+InPzexT+01RG8+CyihF5me10ZikqLLBRHWBpsAEuH3+5tiSDjbYpHXqyxuOmBC7QTOGoxJf/tASMGmnNoRPoxyDtabdWWxgY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQXPR0101MB1144
X-Proofpoint-ORIG-GUID: YU2-yLdSkXCI-lqkYyb65OkqLibvQIN2
X-Proofpoint-GUID: YU2-yLdSkXCI-lqkYyb65OkqLibvQIN2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-25_03,2022-01-25_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 clxscore=1015 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=999
 suspectscore=0 phishscore=0 impostorscore=0 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201250106
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The GEM controllers on ZynqMP were missing some initialization steps which
are required in some cases when using SGMII mode, which uses the PS-GTR
transceivers managed by the phy-zynqmp driver.

The GEM core appears to need a hardware-level reset in order to work
properly in SGMII mode in cases where the GT reference clock was not
present at initial power-on. This can be done using a reset mapped to
the zynqmp-reset driver in the device tree.

Also, when in SGMII mode, the GEM driver needs to ensure the PHY is
initialized and powered on when it is initializing.

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 drivers/net/ethernet/cadence/macb_main.c | 48 +++++++++++++++++++++++-
 1 file changed, 47 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index a363da928e8b..80882908a68f 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -34,7 +34,9 @@
 #include <linux/udp.h>
 #include <linux/tcp.h>
 #include <linux/iopoll.h>
+#include <linux/phy/phy.h>
 #include <linux/pm_runtime.h>
+#include <linux/reset.h>
 #include "macb.h"
 
 /* This structure is only used for MACB on SiFive FU540 devices */
@@ -4455,6 +4457,50 @@ static int fu540_c000_init(struct platform_device *pdev)
 	return macb_init(pdev);
 }
 
+static int zynqmp_init(struct platform_device *pdev)
+{
+	struct net_device *dev = platform_get_drvdata(pdev);
+	struct macb *bp = netdev_priv(dev);
+	int ret;
+
+	if (bp->phy_interface == PHY_INTERFACE_MODE_SGMII) {
+		/* Ensure PS-GTR PHY device used in SGMII mode is ready */
+		struct phy *sgmii_phy = devm_phy_get(&pdev->dev, "sgmii-phy");
+
+		if (IS_ERR(sgmii_phy)) {
+			ret = PTR_ERR(sgmii_phy);
+			dev_err_probe(&pdev->dev, ret,
+				      "failed to get PS-GTR PHY\n");
+			return ret;
+		}
+
+		ret = phy_init(sgmii_phy);
+		if (ret) {
+			dev_err(&pdev->dev, "failed to init PS-GTR PHY: %d\n",
+				ret);
+			return ret;
+		}
+
+		ret = phy_power_on(sgmii_phy);
+		if (ret) {
+			dev_err(&pdev->dev, "failed to power on PS-GTR PHY: %d\n",
+				ret);
+			return ret;
+		}
+	}
+
+	/* Fully reset GEM controller at hardware level using zynqmp-reset driver,
+	 * if mapped in device tree.
+	 */
+	ret = device_reset_optional(&pdev->dev);
+	if (ret) {
+		dev_err_probe(&pdev->dev, ret, "failed to reset controller");
+		return ret;
+	}
+
+	return macb_init(pdev);
+}
+
 static const struct macb_usrio_config sama7g5_usrio = {
 	.mii = 0,
 	.rmii = 1,
@@ -4550,7 +4596,7 @@ static const struct macb_config zynqmp_config = {
 			MACB_CAPS_GEM_HAS_PTP | MACB_CAPS_BD_RD_PREFETCH,
 	.dma_burst_length = 16,
 	.clk_init = macb_clk_init,
-	.init = macb_init,
+	.init = zynqmp_init,
 	.jumbo_max_len = 10240,
 	.usrio = &macb_default_usrio,
 };
-- 
2.31.1

