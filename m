Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9224249E7E4
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 17:44:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244042AbiA0Qo2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 11:44:28 -0500
Received: from mx0c-0054df01.pphosted.com ([67.231.159.91]:20185 "EHLO
        mx0c-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243844AbiA0Qo1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 11:44:27 -0500
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20RCPRRr015054;
        Thu, 27 Jan 2022 11:44:15 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2050.outbound.protection.outlook.com [104.47.61.50])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3duu8kr6tb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Jan 2022 11:44:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UD9rOoXfYkohMqIfbog1fEosZMRkEGUiDiEWzJMjgNo27xIGPDduyB9xzsdjylU0CwKGn4T81aw9v1a1GVbtE3cZy6zE4h5D0SYz7VXEZOfyrjWiW0/Bf1HPs9SCmEMtfqtzLp55ClNBnYA/R9jjR7z0oeYlEw5gYJNN645puByno+51yju0B5R65AyEsHrte4Vt4VX3SRMKhcC3NzMG2JCk5UrnJzf5jnk0lqpur8OlUjo3OXv1Z3LwYL/RgODfFn6fQHwzJzrbCjdFBxmkFnfdNxDOoaUu1ccu7X1flqJ+dv6j5GX2srLLQ92RaEnCVy/R5d0Ou4G+RV5xGkyu1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z25PXZJpo0bQJFQ/hTDwargoXOfysmwmVRiRh2RER4o=;
 b=QMGLRyPDqRR7J0yvUr5R/FQnZJQ4r9VVD/uhjzjs2LTmKurRVsi2hYqENqA0bY5+jPRQMzcTE7jsouLr01bQBeL4DJomkMVV9LvT5uQgX65R22YrohRJuOJhgLH3RPE1EA9GusIF4Ts62+YXDDxl5vu8+UDbbkyW8z8tw7i3DomSDvzIum01wzLevbDw4jYYbFVg/mvs63+sJ+1VYqORLWz/Bh7OfZX4Kge3AVaEaQ/6uPu83VgTPfKhzyo3b56sFs3EFUsAEcVIvIdPUwJw9c6yn4JsVl1FiKIcpgxOxIsuvO9ocsp9CydHUcX/DEbaVxkjJtLHoKfVX0PhlJKFFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z25PXZJpo0bQJFQ/hTDwargoXOfysmwmVRiRh2RER4o=;
 b=4JR2mcRgdU1BEoqKh2kFQPgApreSvFkSXGelgvcKqVvU8WlOF3uNm85Qay0B0KapQKU3ApNhGZgHhLPjnxzzkrTsaXFyb3FZcGmOu8vtpnr1bMicAGIf9MAVYbu6YEv+x3Ou+cUy9G1oV6oluU3LQIfK0tKLmMIXNhwaJtZnExw=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YQBPR0101MB2258.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c00:5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17; Thu, 27 Jan
 2022 16:44:13 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8%2]) with mapi id 15.20.4888.020; Thu, 27 Jan 2022
 16:44:13 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        robh+dt@kernel.org, marex@denx.de, devicetree@vger.kernel.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v4 2/2] net: dsa: microchip: Add property to disable reference clock
Date:   Thu, 27 Jan 2022 10:41:56 -0600
Message-Id: <20220127164156.3677856-3-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220127164156.3677856-1-robert.hancock@calian.com>
References: <20220127164156.3677856-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0228.namprd03.prod.outlook.com
 (2603:10b6:610:e7::23) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:6a::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 373e5d1f-df6b-4f87-bc6a-08d9e1b43fc1
X-MS-TrafficTypeDiagnostic: YQBPR0101MB2258:EE_
X-Microsoft-Antispam-PRVS: <YQBPR0101MB2258B7560A2BC39262BEE63CEC219@YQBPR0101MB2258.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:2000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yUtugslRGESQsoDTncyc2vA0rpH/ZAgzP/e02mfobHyaQKLw1OXyK/lgpChroOsvJZJGhO2bYLZ7qvt1FcwyfkhcWCP2ZnbmYelNV8OIOzsVpL1onJXnFLWnKpTJi4izngY5bPv66Yqz2PCb9eXac8BwkQ1dUrnVC9JWuk+hnxhn75YQOdt+v6cIwmNj3M2wLH4NC+aqqe/lEuOH0aaNSslWrxJF3gGx7YvetNLA21b+swDU/ElxjAZQD+7QV0H+yJ3wQwKHdeJMQ4t3kV5q2cPedVF8ySPa9CI9gYUXVjQQ2X+hlqWiGNOjhE+8i+SGnTSRZS/42L+kEyqTRiWQ0kmIJr39CrNwt8ytTHpWDBdJiICIugTXDfR+k4Ptnh8UrnxmrhKRELXx5jGfpi7ex2QT9cWWdtVPLvV9GlsCvWkQL/SzVBLEH//hMT8VSpVoiHR/c4AU3DyeuhGEeCcZgzB9xI0GZ8tWwMJfv09ZkSROaPafi1GL9eh2FhOSrWheriepXHujwBHtcSYv3uuErecOhEu/r5nP2PRuCTp7YDezDSAWfoDxZmLgC/huL5PPvWhiVitQIqlTAveiT2MmlHVmbRin8JJFKb222QbOZAP84tSBGUCWGThX9xk2OOSN9tuwNpvnd+4MFIvQ7w1krHwGH63RAkvi3MPgDYDdF9LJePArJke4sZ1P6vyay+eR/XGUG6XEep16ndChSPePDg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(44832011)(5660300002)(1076003)(66476007)(66556008)(26005)(7416002)(6916009)(8936002)(66946007)(186003)(8676002)(4326008)(52116002)(6512007)(6506007)(86362001)(6666004)(38350700002)(316002)(508600001)(38100700002)(2616005)(107886003)(6486002)(2906002)(83380400001)(36756003)(20210929001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?T+gbR1PMCKxo9aZPvmSS9uEJXoXY6+LfOuTu5Grzfy0s1zQsRuJE0DWRGIiT?=
 =?us-ascii?Q?4OnsjH2S0wqUICUIlgfmsCWiYdtfDuOsYwpBeBiWxXKyNu2cElc2hkp4o7IL?=
 =?us-ascii?Q?M+1MSwnrO2YGPHgNvN0xqtkwZK03Ai/wAd7wHOQlzjkg8iRKo5Dcj+YufO2i?=
 =?us-ascii?Q?+Jo37oKbLWRIochtxegBK0T3G+xoD/ZCwOw0YRd2rPD74XR6N8nOA+139IG+?=
 =?us-ascii?Q?awz0hSyJ6Q7NdkXftjF4cB5vRxFI6IsVTAeDfHLeSL7sCQIObiiAPGNRQl03?=
 =?us-ascii?Q?Kdzo8JK87O6uSYC6TSq4xV1gL46uV0+JaYqLSn7TQwGOEKLRvXjjXExZ+Ghm?=
 =?us-ascii?Q?rxyevkwhnr0aDguPIbTNLuLjoYQJHHSwWZdBeG9oBeCJ1KIUK3NwDmT6hfvj?=
 =?us-ascii?Q?eAjajprlDa2xdLrw2DpHeTvwYC9FCUnkorqI4NLMETfX5TuOH5tAT7kgFl6s?=
 =?us-ascii?Q?Nb0RLFcUjKhGvcGaBDUBFghSJPyiO5w6vB3LZvCs5Q/9/yP9J1wlBuAO1piN?=
 =?us-ascii?Q?0OUV9Sl1NJ0GL+Op4WCAm6VBtdLVieNi/nCQ1JRV62fVepvsHxIgh3n7WziH?=
 =?us-ascii?Q?PkJZL+JdgeEWuWU/TquspwybbKH2yyHwx5STLy8S5sPlUxUwhm/oSidqp7gO?=
 =?us-ascii?Q?bMHqqOeyJSEskIft1YWh9K8kKcy0lTOFfqHMkxRoKNwOFGpqCCw0Bdc1KcDJ?=
 =?us-ascii?Q?kS1aQKD2BoraQMiejsr8mtEnkn/QjLeM5mT0MTCrjc79V/XXFivOHFyr97lD?=
 =?us-ascii?Q?VJS+Awwizobp1C/Wzsh6d3Fl+B+J84B8EMpVsugYhrPEqlF7jT9zerKadmb7?=
 =?us-ascii?Q?euMQzvzmxLBBVszHwves6XJ7FMGZpzzCc4/0Zhsx6H6pr8JjfO1gPo/psB2v?=
 =?us-ascii?Q?qq1MgYk85/rAwT9tMpW71uNW8qyJZqF2/Ga3xD+phGAiNqC8IEwZl1sYF9rZ?=
 =?us-ascii?Q?swZ3Nssx2CCXCyMd2mzBn0enSyLT6o5U5olWw0vI0xe/N6+b7G0KchRD0uRh?=
 =?us-ascii?Q?YwhfwdhfqrDZLAizuzNlDp9RKe2gg0dOG7Dzf4qqf1+Nl/TzbKh3lWdF351V?=
 =?us-ascii?Q?FOTCPiPD6FBBMnPpO7tR79BaEqggmzHmYO23DrILr3L+/bvza6bkjWnMQxKT?=
 =?us-ascii?Q?sWJmHyc/QbxDRt78MQSDa5WAEvq2xTVoq0s+WgKbGBY4girNFtiwqTqbqrF4?=
 =?us-ascii?Q?Jd+wYUn0mESbIPFLLl46byWViV9jnsbE0eaHfUiXxA0KhJ6vUfLciuH1hqb3?=
 =?us-ascii?Q?A+o6LPzI+XXh4gcDAtikCgq9roNoL7IGwbsTTT8RZXVlD/N4wKP5YnzzV23i?=
 =?us-ascii?Q?BwRLEaySfqcbKgBHsNWsz/XmfNJuJ9rX3dPNjk8Z7n19Osy5VpNzqISbTaAw?=
 =?us-ascii?Q?4bmduRGYexf5nP2707lcm04Wxse5jtlLxV2dtFUCn07EpZZbt7d4BU/0BK6c?=
 =?us-ascii?Q?oMfIJlIm25BARw1YNJKVAAIRJczc5JC+vGSq/xJ69A1EYBL1LmJgWGj9Jp8J?=
 =?us-ascii?Q?2Rv/uEPKcF1DXnclfZyDVP/Q7c4e7G64e51jrbF5Nt5ZhY0xEcGC/GeRd/7q?=
 =?us-ascii?Q?X+flLDxSMVu9Y4IxUycDLU0AQjxuunVI4FPHOJRO4ZFW2bCg3x6sBJKlce5z?=
 =?us-ascii?Q?/Q9ZaYxLzN9pDRcI0gQh9mvgkK7oOywVV1lsHDmU0UQqVCwPY8ede6d57mU7?=
 =?us-ascii?Q?2JY/YGmthTHB2wFUiCgeLMJVwfs=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 373e5d1f-df6b-4f87-bc6a-08d9e1b43fc1
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2022 16:44:13.0753
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SQoZFbgqLYD2CyAbfv7i/nIHw7jxV8UwEixfBlkP+v+RUcWtTxDrWnfOrKD+JS3xhYOu8LUJWopKIrJ/sqrGX2+bYviD8EeN0ySqOEJ+IsI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQBPR0101MB2258
X-Proofpoint-GUID: -02vfFn9t0cJSoRMoJP38Pemm247lxMa
X-Proofpoint-ORIG-GUID: -02vfFn9t0cJSoRMoJP38Pemm247lxMa
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-27_03,2022-01-27_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 bulkscore=0 impostorscore=0 phishscore=0 adultscore=0 lowpriorityscore=0
 priorityscore=1501 mlxlogscore=698 malwarescore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201270100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new microchip,synclko-disable property which can be specified
to disable the reference clock output from the device if not required
by the board design.

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 drivers/net/dsa/microchip/ksz9477.c    | 9 ++++++---
 drivers/net/dsa/microchip/ksz_common.c | 6 ++++++
 drivers/net/dsa/microchip/ksz_common.h | 1 +
 3 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 353b5f981740..a85d990896b0 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -222,9 +222,12 @@ static int ksz9477_reset_switch(struct ksz_device *dev)
 			   (BROADCAST_STORM_VALUE *
 			   BROADCAST_STORM_PROT_RATE) / 100);
 
-	if (dev->synclko_125)
-		ksz_write8(dev, REG_SW_GLOBAL_OUTPUT_CTRL__1,
-			   SW_ENABLE_REFCLKO | SW_REFCLKO_IS_125MHZ);
+	data8 = SW_ENABLE_REFCLKO;
+	if (dev->synclko_disable)
+		data8 = 0;
+	else if (dev->synclko_125)
+		data8 = SW_ENABLE_REFCLKO | SW_REFCLKO_IS_125MHZ;
+	ksz_write8(dev, REG_SW_GLOBAL_OUTPUT_CTRL__1, data8);
 
 	return 0;
 }
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 55dbda04ea62..7e33ec73f803 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -434,6 +434,12 @@ int ksz_switch_register(struct ksz_device *dev,
 			}
 		dev->synclko_125 = of_property_read_bool(dev->dev->of_node,
 							 "microchip,synclko-125");
+		dev->synclko_disable = of_property_read_bool(dev->dev->of_node,
+							     "microchip,synclko-disable");
+		if (dev->synclko_125 && dev->synclko_disable) {
+			dev_err(dev->dev, "inconsistent synclko settings\n");
+			return -EINVAL;
+		}
 	}
 
 	ret = dsa_register_switch(dev->ds);
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index df8ae59c8525..3db63f62f0a1 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -75,6 +75,7 @@ struct ksz_device {
 	u32 regs_size;
 	bool phy_errata_9477;
 	bool synclko_125;
+	bool synclko_disable;
 
 	struct vlan_table *vlan_cache;
 
-- 
2.31.1

