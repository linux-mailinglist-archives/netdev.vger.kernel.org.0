Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CA9E349D41
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 01:06:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230170AbhCZAFk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 20:05:40 -0400
Received: from mx0c-0054df01.pphosted.com ([67.231.159.91]:5607 "EHLO
        mx0c-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229920AbhCZAFY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 20:05:24 -0400
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12Q01FDZ029344;
        Thu, 25 Mar 2021 20:05:20 -0400
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2059.outbound.protection.outlook.com [104.47.61.59])
        by mx0c-0054df01.pphosted.com with ESMTP id 37h14tg3yg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Mar 2021 20:05:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mjrQ34Xz6W49aEOJQUyzBOz/NvsX4b0I8ZLBN3EXtL0jgnBW9UovSg2fryxIiKxs1un3WK+CbrPxabSqS7zSsUHiOuK6/IN+1J+wCoGNllkC/vzh13vkw4HBn3HCHIeujWyFxGW5HGmfsUjTt+8WMzBHZtGfTj8D9cfo6XPTDTVCiqkI7ivAsuD/jh1wEWMIGLlLtZwSDPScFvCE7NsJY0IaodG3svj71J15mZPWK/fRHIm6P53ak0zsmOK01xsYk7B+cov1GGiBVQRLPHVmVDRFU5JBQEzvgHBbQaa6eAnG0r7VNPD00TtyTm++tIlh/GleSrxH4Kher1Q95Go2dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jsptKJ8mYBkT9ZpU1kMzSs7KCj8h5r4L3aMrgYTDu/w=;
 b=OBIOiSnki7tdRvQrKFqGj+BAcyyMyzbK7tVQfPHcr9rjpWCYsHRt0gZ5nWimxKoRR+xU4U/XgASl01i2bAZ7ICrdEXaDqWFTcq4orbVdb3KIKvk9orTsrB4Phxdih68tsGH9hgSkUkbtzeDSlR0CjiYlG08rcKvpiM8kEQVp9ly+rkQXcO3KCHAxiGKbPILTEKbphywxOiTX62vRl5BHJ3alW5b56kZNAnPu219u5zX2akXM9ThVpENcKyhUJDI2PMbzO7do8ZF5y9L1qNgNBeG3H3sSlyNUUHSWYkvkQvgX2jsIuIieuP6mVcJE6i9+4cIC32iin0374c4etaFIeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jsptKJ8mYBkT9ZpU1kMzSs7KCj8h5r4L3aMrgYTDu/w=;
 b=V8Z0qKvVf9oxEJjgSHYPVWW596DIk8tziSysXwU7LQjyf0SfrkksP0roQYttN35jfYduP0xBiYWDLcqd42j02sDzfeN+LXale2mWNU6v/wt2/DxBmODkjSK41aadtuwjCZv4z+6YNVMV1cEuEHPatGyx9gYOw/oexgKXjpL5jrs=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=calian.com;
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:f::20)
 by YT2PR01MB4302.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:35::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Fri, 26 Mar
 2021 00:05:18 +0000
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::90d4:4d5b:b4c2:fdeb]) by YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::90d4:4d5b:b4c2:fdeb%7]) with mapi id 15.20.3955.027; Fri, 26 Mar 2021
 00:05:18 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     davem@davemloft.net, kuba@kernel.org,
        radhey.shyam.pandey@xilinx.com
Cc:     robh@kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v4 1/2] dt-bindings: net: xilinx_axienet: Document additional clocks
Date:   Thu, 25 Mar 2021 18:04:37 -0600
Message-Id: <20210326000438.2292548-2-robert.hancock@calian.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210326000438.2292548-1-robert.hancock@calian.com>
References: <20210326000438.2292548-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [204.83.154.189]
X-ClientProxiedBy: DS7PR03CA0070.namprd03.prod.outlook.com
 (2603:10b6:5:3bb::15) To YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:f::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (204.83.154.189) by DS7PR03CA0070.namprd03.prod.outlook.com (2603:10b6:5:3bb::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend Transport; Fri, 26 Mar 2021 00:05:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 964bf5e8-3986-4815-3cb2-08d8efead741
X-MS-TrafficTypeDiagnostic: YT2PR01MB4302:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <YT2PR01MB4302F4E2874C29C4FDF9C431EC619@YT2PR01MB4302.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PbaJO/HVxcvA7hWLAtfMES3497m2CGrzlKDqtu/Ij/teC8k4XsYb2mBu+Crb4CDUkCIl2cQRCk9l4J/VdIVusUiW+1KaLG1yzhfV5CVzSI05VqpgqKgGn0SxqqTTwc+vlAxeqI4QfU9ji6ZeHrOQ07Kct//rcDN74a6zTPMD+pCXrqPDmzf5aR+px78h6PrDmXJn7/zl0TiSVs6LZ+QzIO23mvll9nzC/2bn1o5L5k4lEtYSgQRDP3lC+JI1dtwfFRrhTQZ51d4sX4KTYOL6McfywZ3yx4sv+F+/iHI+QkYc6wRScKVbsPSN8t5VW+uWeIHNrwWyipi5mOtLHAQWKLVzkplit+P89x6FWtnx1j1T2uPYNw2gZG9QTjZpK8ZXZRTB1Cs3wu5XneLYVHGCVi4NYXF6bw7ihZwN4IX3TK5yiJdSKmHUu1nfcw+9ehEN7cbw6v5cJx1oneiEPBv3OadItWUgrXTnEyiP09hZAZ47tGI6E9u+s46V5md1ZM2LYRAh9xg0IQhjIEyaR+bD4mICpYynJn9NmysASK4nxU5tLvQvCv2a638oInaF+6hz0ERGCCNtmjmO5/pD7/CcQGR/Tjp33CU9URlpRdtB2IR+vip2shGuVTywJoua4Ktxm8ttsFk4Lhs4SLxqLMMFF1qC6XVssLpEUcVcCPja95HdMJVBnOBxBMWuCH/eWoQ2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(39850400004)(396003)(136003)(366004)(6506007)(6666004)(316002)(66946007)(52116002)(107886003)(38100700001)(86362001)(36756003)(1076003)(956004)(6512007)(5660300002)(2906002)(44832011)(186003)(83380400001)(16526019)(69590400012)(2616005)(66556008)(66476007)(8676002)(4326008)(478600001)(26005)(8936002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?XhBhacENOoQNqkTaD2gKDnz70PJjTbyBVjYMPgUt5VSQQjSaExwXqlDHDO6B?=
 =?us-ascii?Q?pHPvloc/riiV6k5RdaqsAaLAJzaJ3BGWIepCNMZiN6NK9/Rkf0gZHPGD5gbK?=
 =?us-ascii?Q?3nBIg28VFYWrKTO5T4+H/vUYYx8bkrxJJ58UT9cGTdgamg70v0+HA2jZXKir?=
 =?us-ascii?Q?bsFfORE57cy85Ny7yT6dx1uL0X7aanXuENtqreljfm7HP+r1fsBuAKRu3i1g?=
 =?us-ascii?Q?4jlhF3bniVzK7rHZxbaoVGMmi7Xj02cpEoQ0rQtSnCCfIxHJUq85AAQtsi3/?=
 =?us-ascii?Q?tAabgocm1WrX8qn7o5BHgVtXDkYy7tgjCQheePlLC+a9NDPqbEdYL/7xm8KY?=
 =?us-ascii?Q?i9OBfID6wF4z6YWciaQWv0DEeuX96N4WLdjjavmvA8U9Y02lFKFpf7plEeGQ?=
 =?us-ascii?Q?inGRBRPX/Z36ZkyosAdCwvJhtjZdebfT57nCJmnJ4u2zx5hU5oaERJZeMtuc?=
 =?us-ascii?Q?V8u/3od7W/OsnfuZ6z3g1+AacSN9wn/QC4ajYEb8QbI1w554suMaQABN47cH?=
 =?us-ascii?Q?zzKQkr0sfcspIa5zYt0sWDszsQYXdJ8I6hzujwJMlQmGBPGaqyPvfd2ngDRn?=
 =?us-ascii?Q?ChK3BhIh8xyLj0LRuRvsbh4RyoxeJRpoNv8yLUTl2X5RqiVLXEIrwLYeRByU?=
 =?us-ascii?Q?B0umqOTEjKhQw8Gt5VH8I8jv0SeS7jYt4TVjpwDCrqcGrFxFg1EQ1ZF7RAux?=
 =?us-ascii?Q?w69mGgSkEhzbnzPrkehtLPvlwhEafQjIAeid7SjQwvRHbKtUAhdrSnH8JoDN?=
 =?us-ascii?Q?mbIgqOYayNFSbGhRNszHkbwPVg9AuO49jF7az5JYXPiDJ38BHOE5Cv6A8fKR?=
 =?us-ascii?Q?5MIMuUk0Y19TNq1zsbXlw4zE6khrCFLXt+W2HYvocDIN6w03zjm6bQdyROmJ?=
 =?us-ascii?Q?rjVlE3oEGkHdt+t3peMI9vYiNHFZ2AUgmQY/LY3TG9hpkTu/ekv9Jd773kPI?=
 =?us-ascii?Q?c3gpaPa0RhwssyIjwxnfI3tZze5vubeCl9DWz11ku3ERrvtD8DM+0hIygi7u?=
 =?us-ascii?Q?7cSU48tENoNNz9QdiQuaHOk4gDlZ3bVz1AZHqvAf6f6R+tTx8HcOipe60XZR?=
 =?us-ascii?Q?+3Y4WqBCsKWFAL7AD01DTFY/BIsVat/RbplMJlQ6u0jn7n1AM6OarxqyhRna?=
 =?us-ascii?Q?FTHu6hGawJWcPWgbedlAOLdy4hhGLOYP0Ub8jC6swKxN1ntCvgL6Ku9iHbQ+?=
 =?us-ascii?Q?Qwer78VANuDwpbvTR6g1iSklNEwQO+vQBsRPmKnjSO+uWuJ4jyV5XmxnERxX?=
 =?us-ascii?Q?1YlF5KZ2JwhFktic7c2dVwZ7oLdz/M9Bo3th6H4SvehmQ16K0gOTeMlSXori?=
 =?us-ascii?Q?VNE/MIGry9acywl5qdxJi+PQ?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 964bf5e8-3986-4815-3cb2-08d8efead741
X-MS-Exchange-CrossTenant-AuthSource: YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2021 00:05:18.7056
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hVLgfdjY4mT7POxCv/zP+3VLzCdgyHmSz9mf1/KWUWWoOey0m37EEx/n+eejFkw8eflvhvcVVRP82xcWOpdI4YpzvJwADGIyRZVTlElJULA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT2PR01MB4302
X-Proofpoint-ORIG-GUID: MQ7KtmvEpx5EZhzPgXtPGXXbmU_Tq3hW
X-Proofpoint-GUID: MQ7KtmvEpx5EZhzPgXtPGXXbmU_Tq3hW
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-25_10:2021-03-25,2021-03-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 priorityscore=1501 bulkscore=0 phishscore=0 impostorscore=0
 adultscore=0 malwarescore=0 clxscore=1015 mlxlogscore=999 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103250179
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update DT bindings to describe all of the clocks that the axienet
driver will now be able to make use of.

Acked-by: Rob Herring <robh@kernel.org>
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 .../bindings/net/xilinx_axienet.txt           | 25 ++++++++++++++-----
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/xilinx_axienet.txt b/Documentation/devicetree/bindings/net/xilinx_axienet.txt
index 2cd452419ed0..b8e4894bc634 100644
--- a/Documentation/devicetree/bindings/net/xilinx_axienet.txt
+++ b/Documentation/devicetree/bindings/net/xilinx_axienet.txt
@@ -42,11 +42,23 @@ Optional properties:
 		  support both 1000BaseX and SGMII modes. If set, the phy-mode
 		  should be set to match the mode selected on core reset (i.e.
 		  by the basex_or_sgmii core input line).
-- clocks	: AXI bus clock for the device. Refer to common clock bindings.
-		  Used to calculate MDIO clock divisor. If not specified, it is
-		  auto-detected from the CPU clock (but only on platforms where
-		  this is possible). New device trees should specify this - the
-		  auto detection is only for backward compatibility.
+- clock-names: 	  Tuple listing input clock names. Possible clocks:
+		  s_axi_lite_clk: Clock for AXI register slave interface
+		  axis_clk: AXI4-Stream clock for TXD RXD TXC and RXS interfaces
+		  ref_clk: Ethernet reference clock, used by signal delay
+			   primitives and transceivers
+		  mgt_clk: MGT reference clock (used by optional internal
+			   PCS/PMA PHY)
+
+		  Note that if s_axi_lite_clk is not specified by name, the
+		  first clock of any name is used for this. If that is also not
+		  specified, the clock rate is auto-detected from the CPU clock
+		  (but only on platforms where this is possible). New device
+		  trees should specify all applicable clocks by name - the
+		  fallbacks to an unnamed clock or to CPU clock are only for
+		  backward compatibility.
+- clocks: 	  Phandles to input clocks matching clock-names. Refer to common
+		  clock bindings.
 - axistream-connected: Reference to another node which contains the resources
 		       for the AXI DMA controller used by this device.
 		       If this is specified, the DMA-related resources from that
@@ -62,7 +74,8 @@ Example:
 		device_type = "network";
 		interrupt-parent = <&microblaze_0_axi_intc>;
 		interrupts = <2 0 1>;
-		clocks = <&axi_clk>;
+		clock-names = "s_axi_lite_clk", "axis_clk", "ref_clk", "mgt_clk";
+		clocks = <&axi_clk>, <&axi_clk>, <&pl_enet_ref_clk>, <&mgt_clk>;
 		phy-mode = "mii";
 		reg = <0x40c00000 0x40000 0x50c00000 0x40000>;
 		xlnx,rxcsum = <0x2>;
-- 
2.27.0

