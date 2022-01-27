Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B2EB49E7BD
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 17:39:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238545AbiA0QjM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 11:39:12 -0500
Received: from mx0c-0054df01.pphosted.com ([67.231.159.91]:47301 "EHLO
        mx0c-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229477AbiA0QjJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 11:39:09 -0500
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20RCHCF2005960;
        Thu, 27 Jan 2022 11:38:44 -0500
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2055.outbound.protection.outlook.com [104.47.60.55])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3duu8kr6pb-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Jan 2022 11:38:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S0zudl6sAUYT3xsIOjHV2lJ0rUJ0nWAbKX6uApxkhgiYA1qzf24qweZKPz6WfoYGRquBcIPpIgtPcWX/McWPMolPnEHhGhWdMqNzc1d0tD/unKawEVkOM3vVvhPcH+t9F2mq91KzR9Yck8AFJOa2qJCoe2IOkuKUEqyaTJQM+qm34h11HnItAzVZuEzJ8W9qZ3SANdZEsKg0HpWzh8LSSy9RY22gPE+juSeYDpWOlvtEFgPkk9+YZy577sX6q1P8qGq4U8N2J1UIe96BLytG8uc40NbbMcY1le+fS3V+F4uD9oYomjJCNtKpr7kgzxuuznt3Cw09+naiPW0S+VyRpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aUWfhsPQjTnLOs5qHErSjEB/rY1tDWBve7TPIWAIcH0=;
 b=lQ3dYQXCMNfJwz2OXpzIftXJ5fqro8RvdU97akEWP/1tom30tlbwn7Xwt0VMnlpZyY15zi2yl6dfRZZF1XFq6Kha+XUQwoUTft/N0dsXVQ66nRhq3kwcC7ifhbkm380pDe6HZGMeventYfkITbWi6ME3FpSPYWny+7QGLg06VENW8tDecOZcDeAUohZ5uH7/9SQmndbWkt0zV68ogGKranxcMwKNze+ytMg1dOT7PR6NnhmawL++vCcCDGjT11G1S62TuHQS8DhdqizFiWx6Zb7iBlI6bziuzujQOoeknaVzRg+VLIuaf9xT9I2SfkECcv1vApG4uqURq11a8vgfEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aUWfhsPQjTnLOs5qHErSjEB/rY1tDWBve7TPIWAIcH0=;
 b=z3wbUOOKEMRbvUSmrRYNdSpUcCKi3lCZIu9WxoT3mLkFNEa9h1x9cRlp11spZtMi3fcPCB6ZrfDRdNSpDvGpRm5U74BzIkYDZPQgSeTb4c0Z+fsbJmHUUCJiduCrlOamofIZjM1pGxgz7wHWHXAm86a0mkJHnqIruadEfmVkto0=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by QB1PR01MB2531.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c00:2f::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Thu, 27 Jan
 2022 16:38:43 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8%2]) with mapi id 15.20.4888.020; Thu, 27 Jan 2022
 16:38:43 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        michal.simek@xilinx.com, nicolas.ferre@microchip.com,
        claudiu.beznea@microchip.com, devicetree@vger.kernel.org,
        linux@armlinux.org.uk, laurent.pinchart@ideasonboard.com,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v4 3/3] arm64: dts: zynqmp: Added GEM reset definitions
Date:   Thu, 27 Jan 2022 10:37:36 -0600
Message-Id: <20220127163736.3677478-4-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220127163736.3677478-1-robert.hancock@calian.com>
References: <20220127163736.3677478-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR02CA0005.namprd02.prod.outlook.com
 (2603:10b6:610:4e::15) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:6a::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1fed17da-c377-419a-5a23-08d9e1b37b26
X-MS-TrafficTypeDiagnostic: QB1PR01MB2531:EE_
X-Microsoft-Antispam-PRVS: <QB1PR01MB253111098EF6357B97D6ECECEC219@QB1PR01MB2531.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G1lZYUHm3iIPOCth3LbTJ1FKm58n4oFcSIwO0GCzfzRjL5Ia9UbTSNM995IKVdpsnmmxZajpyz7XQMTjb6Fzjoc7Dk2sNjQokiZGmN+VUxGhC4NfdsKKQAvkrvWwau1jZdoURnOCroL6LRVyuhsdJ0btKLqllekdgb77Xb3RmV/nnl1iE3JXk6sNVCHdwTmd7+oFtl1Sspfskbz+YhWH5acSyTAg32RYK6m+EyAKJntl3uD4Nk6DFZpvJ4hcc8fPi97EaAnXBJmpqzqT/SRh4vOwh0hanlL6yle91e7sw7JX7fU5wwVYRO77uqVGoilnzgtfZFhyvrAa8UUpoOAW1spKxx4iSwKsfgm7uQ60PKsHauvDtCIZrxzhmJDPkxCJ7QnIJiEVbQPDLMNjjdy3r3LtNlBZUvZbTWt5ytdW8DUDvpQ+XZn0T70WAtdo6fK8hJ9EZhNk2tuQEEaDG2zIfLrgDcgD0vZi2D7xV7y5LQcX+7eJQa2uOOeBzcAcHUf4yoBtUWDmYQxWsD1G4lSJz+pxuVFc8tf11tBqSPeHKJak9y+dx4vmjlvgFpv2zgvvpUk0jpMif15YC4cUV0aSJn+fIMH98RlB0kRL4NzRJEihRFan+1/DWny6BreE4ySlkNTFn/kbpZ2zy88KPPj4cCNEKAWFnZbN6ShT+K7qCaS1NNC6LJMMj7yrbvZQ1WM99KxiIVRSQQoAFzNUr1OWjg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(1076003)(186003)(36756003)(38350700002)(26005)(107886003)(52116002)(6506007)(44832011)(6666004)(2906002)(2616005)(316002)(8676002)(8936002)(4326008)(66556008)(66946007)(508600001)(66476007)(6486002)(6916009)(7416002)(5660300002)(6512007)(86362001)(20210929001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hv3f/j3dz6GSzJbS+hS1irra/oKGKaBrTYTRtrUUoS5zfuBjBrI5U7uPyvSY?=
 =?us-ascii?Q?0/x0/OvK0XJZaseU5dWJ/hwETcGgvjOgh6bJ6udaEbeZ/lIBeflmZzlK2EdY?=
 =?us-ascii?Q?esWhkpBQ0xFsNtPS9B5LVr096Ft1EH4IP0y643AEcMFQkG/G+7wqACqymaLd?=
 =?us-ascii?Q?YoC0GEgulI9RjWfw7we4NPexDRNkmUdC7YxhIaEiylcuevcqJG06u5HLwnhY?=
 =?us-ascii?Q?SqEZD3co2c8fyDVDlrlvKs4wasOp+BsEOM20dSVVWdi9AjXyGI4WhSKrbR6b?=
 =?us-ascii?Q?BQfVQa1OzSzbzP9bYs4qUivCUTNqqGTuyVllrlYOo8REvErnBIT1JGS7Q+mj?=
 =?us-ascii?Q?b6TPwFopmv70+bIBhbdMgq2WgDjFtloMCG85Fk/wbgZKffadqLkMbgOYoBFv?=
 =?us-ascii?Q?tQjJqiYUTwLi5gju4fnU2iGrmE0jlqwPp6FhG3AmV7ODrNKuuGl/M8680lby?=
 =?us-ascii?Q?d7TzI9iT8FwJAG3yUXSOPAVW/QcKTzdPKnM3bIPNNuUltPOMxjh4rAs3u/O7?=
 =?us-ascii?Q?hhiTPzN9GE0zyfWJCXQOn17X8jZOOi51sjCx1CEGnHfZD7jMHTww11mj1oBq?=
 =?us-ascii?Q?5+BC9Lyj7pHFSIVPbwtaybmf3GDehbOFdBYndtzVHEtql65cvlb7Ppj4qCmv?=
 =?us-ascii?Q?PRl4R2ZXmSraelnLhGSzjToQlzPvToC4m22ScSbbrNSye7Kg1qdd0AMwxxj5?=
 =?us-ascii?Q?JC1psuEwekk3bfMFzpVAYbfAQAxf0jdx7GITvRsmYCrZnHATpRftBee4qb/W?=
 =?us-ascii?Q?IERx1ZkiqAZH/WhMejxzK9rlL0X94S518ZBW0QcaaxMDxq+aDC/TCn0n0vKB?=
 =?us-ascii?Q?M/rw7/alFq5JMgIABxKqcK+A7z6vkpHHxVZA3OfakU5reJpeP2BD2tgrCuiT?=
 =?us-ascii?Q?xb4RmHiY/P6fd99PPlWjgRgb9H1oRVo7VHszdI88Gat6Fk/DxLPui7Wnq46S?=
 =?us-ascii?Q?5BbdEoHYsLi0mrIdO2tVln3UWg9gXzhCsRxlaOQbUAWXf31P0UfOHPk6mfPk?=
 =?us-ascii?Q?IXOouvGERTvcVqan3JxiDR6XlDJghIrV8fLrtTbrgsjLfqH/ur7cPYAMHlaB?=
 =?us-ascii?Q?E3NbcNtdVKoMkbKvbPHE1kKtD0GzKf2rSW6TMhypXxE+NwmGHadghIGfHy0S?=
 =?us-ascii?Q?dO2YFOlZcThxxnyyyzQ3zU6d53p7ImNjTT3asOACJPYzZxZR812u/ak+L6+q?=
 =?us-ascii?Q?z/jjbhq0jNOboucVloyJqcV5aDlM0NQ52KZzuhIcjeyMZybMJM6Pb3H7fM0B?=
 =?us-ascii?Q?nOyAhxa8RsnOvsCRDugiFkq99+NcBirLTtvPP/PpN7VDcKs57YFZOK3uQaGt?=
 =?us-ascii?Q?1+SW+1eIKkuXcwQn2HA/mdAkiBxVV9VNOmghQ9HzhNohFV49yUQDxyKFiEKJ?=
 =?us-ascii?Q?JHNUxST6cc2T7cRMf7SOTpZkRRXkhlqVcLd3V6FM2Ur29uEpvlf6IxvsxA2a?=
 =?us-ascii?Q?T0U/tdRiyouMQvTOVco+2tJ0wbcwlo1ROBvLGBU716mhOQo7Tu53rgEolyPe?=
 =?us-ascii?Q?VIY0VtqIBy2c0sw60Q3JQuHW/rEC/8lQoHW8UXq9HUD0bLaiGEGyW0STNJKW?=
 =?us-ascii?Q?1ofuAf0LAehW1Om9AthGsxfo2K4fiFxN+Fvfw9xtR7mm12vvThA8feMlgROj?=
 =?us-ascii?Q?ZQx7WghiMs3jq1OHA+1bDwnyooapw2c8XzfKrNZKe+tT+UWGX/yo4YppKDNu?=
 =?us-ascii?Q?5UVWdqINlloz1u5LFY84Wmc3g4k=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fed17da-c377-419a-5a23-08d9e1b37b26
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2022 16:38:43.2392
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jahUkMAwMMV2tjt+uLmZjO9NzsM7ytotLrZVWqpLlgL1kTL/shoo9dJgYwSP6V+jVVyrm+klNk1ecRKNpSwjEotrnkf2tYSHCNxkmMEcBGs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: QB1PR01MB2531
X-Proofpoint-GUID: U8K4pgwdSzB-ZomJPlOHgX-sHY21bgxa
X-Proofpoint-ORIG-GUID: U8K4pgwdSzB-ZomJPlOHgX-sHY21bgxa
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-27_03,2022-01-27_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 bulkscore=0 impostorscore=0 phishscore=0 adultscore=0 lowpriorityscore=0
 priorityscore=1501 mlxlogscore=921 malwarescore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201270100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Cadence GEM/MACB driver now utilizes the platform-level reset on the
ZynqMP platform. Add reset definitions to the ZynqMP platform device
tree to allow this to be used.

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 arch/arm64/boot/dts/xilinx/zynqmp.dtsi | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm64/boot/dts/xilinx/zynqmp.dtsi b/arch/arm64/boot/dts/xilinx/zynqmp.dtsi
index 74e66443e4ce..9bec3ba20c69 100644
--- a/arch/arm64/boot/dts/xilinx/zynqmp.dtsi
+++ b/arch/arm64/boot/dts/xilinx/zynqmp.dtsi
@@ -512,6 +512,8 @@ gem0: ethernet@ff0b0000 {
 			#stream-id-cells = <1>;
 			iommus = <&smmu 0x874>;
 			power-domains = <&zynqmp_firmware PD_ETH_0>;
+			resets = <&zynqmp_reset ZYNQMP_RESET_GEM0>;
+			reset-names = "gem0_rst";
 		};
 
 		gem1: ethernet@ff0c0000 {
@@ -526,6 +528,8 @@ gem1: ethernet@ff0c0000 {
 			#stream-id-cells = <1>;
 			iommus = <&smmu 0x875>;
 			power-domains = <&zynqmp_firmware PD_ETH_1>;
+			resets = <&zynqmp_reset ZYNQMP_RESET_GEM1>;
+			reset-names = "gem1_rst";
 		};
 
 		gem2: ethernet@ff0d0000 {
@@ -540,6 +544,8 @@ gem2: ethernet@ff0d0000 {
 			#stream-id-cells = <1>;
 			iommus = <&smmu 0x876>;
 			power-domains = <&zynqmp_firmware PD_ETH_2>;
+			resets = <&zynqmp_reset ZYNQMP_RESET_GEM2>;
+			reset-names = "gem2_rst";
 		};
 
 		gem3: ethernet@ff0e0000 {
@@ -554,6 +560,8 @@ gem3: ethernet@ff0e0000 {
 			#stream-id-cells = <1>;
 			iommus = <&smmu 0x877>;
 			power-domains = <&zynqmp_firmware PD_ETH_3>;
+			resets = <&zynqmp_reset ZYNQMP_RESET_GEM3>;
+			reset-names = "gem3_rst";
 		};
 
 		gpio: gpio@ff0a0000 {
-- 
2.31.1

