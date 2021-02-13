Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A373431A8C3
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 01:26:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231470AbhBMA0I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 19:26:08 -0500
Received: from mx0c-0054df01.pphosted.com ([67.231.159.91]:22040 "EHLO
        mx0c-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229602AbhBMA0G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 19:26:06 -0500
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11D0H8og017843;
        Fri, 12 Feb 2021 19:18:25 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2050.outbound.protection.outlook.com [104.47.61.50])
        by mx0c-0054df01.pphosted.com with ESMTP id 36hq424aca-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Feb 2021 19:18:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rt3BwdVDaiDsw/AVzgoDf3X8zgb5GEmp1EI7HJvvlCyO12+vII31ozOrDPWANe+HtVPUbdrxiWeK5c8Nv6mUnHiasmXVr/kRnKYzz3mf9CZ74UPHT0FDpoyI1A7ZD7Fnm4mmou2bp/BaqaN7bB7CY3c8PeBaePkUDvvtV0ryRoTR+yxeotNaIZBTHZKDiwepFtbmfpT1Zi5BbXpGRy6x+WrwGv4IDfNJI985OHVedNTRdXfrkdcNVM7/w4FPo5dOfaU1TmwQqon8Af9N6q+mpy4PPzhQvtVHh9Jw4KPc3yO+6mOqjkvIr8kDNxrzBf3IJ8AI8uZPUohv69YQ1Gfq2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ryZMRhDwCXA5OLLTPHoOROE3WV9wyCt7We7sJiCt6XY=;
 b=RID/59pSGH3x+l9lfuy5FcfNKq5GbZ1QrqpS/ocNcD5/YYy0Lak4v6ntI9UZGjtzFLPxPyHhsO2ISJ2ZUm3+CzQD2EbC9LD/vtLLM9S+W6Ff3Lmat1xrgBwYa7yl00gDEDeB6CoUlPBEZZBJjHAH99yhDneRYGp/4RGMfZ6q4vJRYjwpCZztg0ya0AiYFPRTRETQ/x6Qz6oGkSWanfKSmhB8jp4gH/+YKWg+mqAR43NJYXLAEOnfP9WzC6sj90BvRra5oFEDLwY5ulG69rejGUiWDntaAz65MCYUo4IuMCXxqiI3pp4M9P07VHw2GJ9C1El58EOgUmzPMwej7YeLMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ryZMRhDwCXA5OLLTPHoOROE3WV9wyCt7We7sJiCt6XY=;
 b=4dODVHSvf3MfDn6MS6ExdAMweo1rpj4Pwoajnusx9zLkmouAf5zgJGDcSh8X1QTtBRyifVOLruzhbZMGOPP9f0wTcAxTV0vSS8zbRCOuMRXhQPRtYqWqObhwsXwufB4wjHAcA4Jm2YBlwG6LyvJZE1H/LDIyEXS9bPD+IHLPJ7k=
Authentication-Results: xilinx.com; dkim=none (message not signed)
 header.d=none;xilinx.com; dmarc=none action=none header.from=calian.com;
Received: from YTBPR01MB3551.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:1d::17)
 by YT1PR01MB3868.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19; Sat, 13 Feb
 2021 00:18:22 +0000
Received: from YTBPR01MB3551.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::3451:fadd:bf82:128]) by YTBPR01MB3551.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::3451:fadd:bf82:128%6]) with mapi id 15.20.3825.034; Sat, 13 Feb 2021
 00:18:22 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net] net: axienet: Handle deferred probe on clock properly
Date:   Fri, 12 Feb 2021 18:17:48 -0600
Message-Id: <20210213001748.2556885-1-robert.hancock@calian.com>
X-Mailer: git-send-email 2.27.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [204.83.154.189]
X-ClientProxiedBy: DM5PR21CA0053.namprd21.prod.outlook.com
 (2603:10b6:3:129::15) To YTBPR01MB3551.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:1d::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (204.83.154.189) by DM5PR21CA0053.namprd21.prod.outlook.com (2603:10b6:3:129::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.4 via Frontend Transport; Sat, 13 Feb 2021 00:18:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 919f12d6-dbbd-4c36-8124-08d8cfb4df55
X-MS-TrafficTypeDiagnostic: YT1PR01MB3868:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <YT1PR01MB3868F5C74759F30F75A9DCECEC8A9@YT1PR01MB3868.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oMg1LCw+8XRWjluZfBVPK/7U2JNPslnM8UCRLYEe1XdOiDFBf81YmY0oTsdg/O8FGp7sEEbih96t8cxSM4tXLPuii5lLQYpt6rkB7OYQU+RFZdKpWnOtgbwAfTNmlqT2YjYrlfvrzU4Qs8sf1TFjuanc7cUhhqc5lg+X6Rh91GF9UlDF3CDVmewUTpNf8Mcgk4pPHBza+nsO8RrTBOPgbcKLUzm5DcUUm9eEMc1YTi354Z5v12ZQc8ZDeiyIFo739+M2jEUq7H0+Yz4rfJKzAKgB1h/1ygpaANUfhwwA+3HKsP0P5GgTu0/wAPfIhoa/7O1QtEtfUcu9wzLUoGxIz9lN1w7H7+ewbFH83nOfqzwRWsjoYTECT/OlaiwbdmeYgkPcVQkIL7qKvN94I4xrpTDqvjaHyjTSv4vJI0YJVDDFlz2J/YvUlaHBBW5Qwm015YmZlbGZ2npkHvLLv/Sa4rlRMzFNUSG1UOfN5S6SqFYQTV8nG8y9QrVawORD5SfaM8981AtV6H/kv9HqE18jeVarqWLJ3quko7jAjx8OkvLfOqVa0YM3jmSRwERAIz39W02/2z2t21qd6xvl1zNf7g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YTBPR01MB3551.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(376002)(39850400004)(136003)(396003)(5660300002)(52116002)(83380400001)(26005)(316002)(478600001)(86362001)(69590400012)(8676002)(4326008)(6512007)(107886003)(2616005)(186003)(956004)(6486002)(36756003)(16526019)(2906002)(1076003)(6666004)(8936002)(66946007)(6506007)(66556008)(66476007)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?2rhcqWlpp6j+fy9PhOma344FlxPtvpEbUmAgtdmWPHmHEV5VtzYwkz1Okk8D?=
 =?us-ascii?Q?vBP6WkNP6q18l/1cMg1kfnFkvT2s7tBsRIBIXiQ74nfulWBiOSTasHlqfX/B?=
 =?us-ascii?Q?NQWf0P4Hu/3rDkZpUMHD/d1f9upQhsGot7nZ/6e1pfKwBb2NuvBrzI0wdXRX?=
 =?us-ascii?Q?5cuZMp5GTpJe4te1jvKNIF0PP9knfv12H9ctoH0PkGWSRgV8UIQPdrhbedra?=
 =?us-ascii?Q?O6ptjBYCq49vzkoCEfIZ2p1MO5TiMq8/BLVrG3Z+ZKU6++r7RPFtWXmbko7O?=
 =?us-ascii?Q?MSPeprErZL7qaoCMwIzWVsNXwxYqrbVCalsfQ7CU2DVdj4MHL9Vz9DvMLZLs?=
 =?us-ascii?Q?oiIiRbROkgKZ+QKYwRWbHhJQzbVKio71kzkAngcFHtQKlKTTh3hYMi1ZkpfW?=
 =?us-ascii?Q?vQQyoWI1wORvFqpEEgS12e4VzUIq4bBN+Hsajn4HJZetBTmkwWDs00NL7SNF?=
 =?us-ascii?Q?B1w2hCf91bBuGj+RGZa/Jsp81IXegmYyt55QqehQ14GxPAn6RsvgS2NLkZBt?=
 =?us-ascii?Q?E82i1AZ86ruKkXJkfehfxDphHvpREazX4yUyCG0ywhV9ftrmKqdqgolnqEOH?=
 =?us-ascii?Q?+ZKG5pqUmCO5G8qJemAvNoAvWJTOtgo1bC730CSpd0sY4aIiGjKsImgBEL57?=
 =?us-ascii?Q?MH5zSVRwpk/O6puSw47NhsfUHC+7t/Arze5JtwrsJDJ0k27W08zw5da9JsvD?=
 =?us-ascii?Q?8kcsHKD38GxMz9hq8tUL8qvnZ3OfVF0zVUiRIisRNNb4sp0vcCsDyandU0ld?=
 =?us-ascii?Q?hYrbzHLTTFZqspMsetty13lHGVrhoPJX6xmXAVRi309m19zwoHgEgm2w4zEN?=
 =?us-ascii?Q?cP+nExotQTK+ZwlhFmQgdfUYySLcmGlK9WQF3OY584ALAEm3r8VKCi4W+vaZ?=
 =?us-ascii?Q?klPw0vRJjtZMTDdeSWuQcQaoannFPyN0xfPqgUO4FYXwypgt7VlZsDJP9g0K?=
 =?us-ascii?Q?y6S+10LX9WFt3D93U3aNOohnW+J1F+J6dJYlCsCsh28Ek7ZPqQq6y5agKAbW?=
 =?us-ascii?Q?ASnfSKn12Iqfrh+fnZgB6yZy55lj8iF2bYBvarFjAPe0t3bTDxntDaLmXij0?=
 =?us-ascii?Q?aFYf5M+xeyFTEKe0dryUaLLzdNqHjgQIFZ6v6HLr8yuv3cn/DbxvKJO6V4rk?=
 =?us-ascii?Q?pA9cZcUfkNh251aCixSQ/skwnEE0aJ74dgVRb1CoPq6BC8uhpz/3l4utKWHg?=
 =?us-ascii?Q?tvS+1plHjJM4LfDuTAxCPC/Y77N6JhoBI4T6ZtGobo5RWDsueoKB96lRzfgx?=
 =?us-ascii?Q?JgLFozL0g9VZHCQu9UdJAoPkbEEYkT1BwKIB4vPwXBgzbYzGXxAzPCLOsWbF?=
 =?us-ascii?Q?cd5S6Ys8/kdX8dxciM6yTtx2?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 919f12d6-dbbd-4c36-8124-08d8cfb4df55
X-MS-Exchange-CrossTenant-AuthSource: YTBPR01MB3551.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2021 00:18:22.3229
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6wpzPOnUemc10lSvaCIIK7fyqOumqLkpOcZATqOetVD1/SZYpDJcjJAu6u0AOo1dMJoWeLgNYv1OdoBdlWahLxUKANRX65c1QobALLdBKfA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT1PR01MB3868
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-12_10:2021-02-12,2021-02-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1011
 impostorscore=0 adultscore=0 malwarescore=0 phishscore=0 suspectscore=0
 mlxlogscore=737 spamscore=0 priorityscore=1501 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102130000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This driver is set up to use a clock mapping in the device tree if it is
present, but still work without one for backward compatibility. However,
if getting the clock returns -EPROBE_DEFER, then we need to abort and
return that error from our driver initialization so that the probe can
be retried later after the clock is set up.

Move clock initialization to earlier in the process so we do not waste as
much effort if the clock is not yet available. Switch to use
devm_clk_get_optional and abort initialization on any error reported.
Also enable the clock regardless of whether the controller is using an MDIO
bus, as the clock is required in any case.

Fixes: 09a0354cadec267be7f ("net: axienet: Use clock framework to get device clock rate")
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 26 +++++++++----------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 6fea980acf64..b4a0bfce5b76 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1817,6 +1817,18 @@ static int axienet_probe(struct platform_device *pdev)
 	lp->options = XAE_OPTION_DEFAULTS;
 	lp->rx_bd_num = RX_BD_NUM_DEFAULT;
 	lp->tx_bd_num = TX_BD_NUM_DEFAULT;
+
+	lp->clk = devm_clk_get_optional(&pdev->dev, NULL);
+	if (IS_ERR(lp->clk)) {
+		ret = PTR_ERR(lp->clk);
+		goto free_netdev;
+	}
+	ret = clk_prepare_enable(lp->clk);
+	if (ret) {
+		dev_err(&pdev->dev, "Unable to enable clock: %d\n", ret);
+		goto free_netdev;
+	}
+
 	/* Map device registers */
 	ethres = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	lp->regs = devm_ioremap_resource(&pdev->dev, ethres);
@@ -1992,20 +2004,6 @@ static int axienet_probe(struct platform_device *pdev)
 
 	lp->phy_node = of_parse_phandle(pdev->dev.of_node, "phy-handle", 0);
 	if (lp->phy_node) {
-		lp->clk = devm_clk_get(&pdev->dev, NULL);
-		if (IS_ERR(lp->clk)) {
-			dev_warn(&pdev->dev, "Failed to get clock: %ld\n",
-				 PTR_ERR(lp->clk));
-			lp->clk = NULL;
-		} else {
-			ret = clk_prepare_enable(lp->clk);
-			if (ret) {
-				dev_err(&pdev->dev, "Unable to enable clock: %d\n",
-					ret);
-				goto free_netdev;
-			}
-		}
-
 		ret = axienet_mdio_setup(lp);
 		if (ret)
 			dev_warn(&pdev->dev,
-- 
2.27.0

