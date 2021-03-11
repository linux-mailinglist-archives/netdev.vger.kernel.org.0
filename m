Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A788337EC8
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 21:12:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230300AbhCKUMC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 15:12:02 -0500
Received: from mx0d-0054df01.pphosted.com ([67.231.150.19]:35430 "EHLO
        mx0d-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229868AbhCKULx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 15:11:53 -0500
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12BK2cx4031497;
        Thu, 11 Mar 2021 15:11:48 -0500
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2055.outbound.protection.outlook.com [104.47.60.55])
        by mx0c-0054df01.pphosted.com with ESMTP id 375yymh7q7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Mar 2021 15:11:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dh6CnM/3khZImAvS5daBy3hn5hiYCXV+zxzr5Ow2FyQxMyUhWsGcYR3UKkeAaRKx283IaQHTWfWPk6JPBqqYfszU26LkyzMu4vH0F3eHgXYj6BNoAeVG+nxuJC1VXzPeZKsYyj2WzZXhTMJWTO6vi2pdxktr8KxsMzgLQENJVYpBQtJsoxmiAu0L6v9bJp6Gz61mUSsu/TmQlH8NTA4npYlPT8t/nGXWRnJbfFj/8oHHB8VUEhiFQYzdZmziiMLbQjIryBQtu5XgxyKRx9iFC8tHMXyTurcVJxiSBEfCh1a/dHbYAJqVIT0TY1ZqayfLuA8t2JvvbvQeMNCiVr9AKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AzSrWy5AmBK0M57+siTXW/i56xWb17Xa7Z2fS8p3iig=;
 b=XUaKoM8a3IziqbC90RnYLFQK/spuiHb/po9RIVD1lHk3A7vrT8+mwLAQSSZ25CAJ3aO6c7NKHhp8N8nH+kUjovGcmDDvNa09RSvwAZMKqexlgV8x84QchWTL5eYTGvdWDsQp83UIAvRxHTSYsoNJyLhkKmxf5BUJpqv1AxCbeCUTCA5ZnlgaY6f/xxOS5AuculzDpbX82h9mWdOmRMp+KYm014329QaDMUxLobeBFdegN0ANBue0IvUz9ZgIhZyRM1vlmKHn5QBiIr+Zb7EMlkFa6xQVLArFGCPIGGSoMULdVt1pkgtCfc6OJNI47PUbUVlkkIicHJf8mMCgGRtRRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AzSrWy5AmBK0M57+siTXW/i56xWb17Xa7Z2fS8p3iig=;
 b=z25F2z/24jA1ru+AxruTLFBI6utbt2mc0Lzp+x/24qpLuPl/y1i8w7sGXl+qAErf22p3btbSYsu67C2wO7S5Ce53F0L+sCugMT6dNIwKbwJZehY2du/i4OYjX6X6EVH7IbZp39f6ExZFwZ/XNRcVeymaP8e5PZ0tbtmM6fBJ4j8=
Authentication-Results: xilinx.com; dkim=none (message not signed)
 header.d=none;xilinx.com; dmarc=none action=none header.from=calian.com;
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:f::20)
 by YTBPR01MB3983.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:1d::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.26; Thu, 11 Mar
 2021 20:11:46 +0000
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::90d4:4d5b:b4c2:fdeb]) by YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::90d4:4d5b:b4c2:fdeb%7]) with mapi id 15.20.3912.027; Thu, 11 Mar 2021
 20:11:46 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next 1/2] dt-bindings: net: xilinx_axienet: Document additional clocks
Date:   Thu, 11 Mar 2021 14:11:16 -0600
Message-Id: <20210311201117.3802311-2-robert.hancock@calian.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210311201117.3802311-1-robert.hancock@calian.com>
References: <20210311201117.3802311-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [204.83.154.189]
X-ClientProxiedBy: CO2PR04CA0101.namprd04.prod.outlook.com
 (2603:10b6:104:6::27) To YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:f::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (204.83.154.189) by CO2PR04CA0101.namprd04.prod.outlook.com (2603:10b6:104:6::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Thu, 11 Mar 2021 20:11:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1ce61e29-b8b1-491e-b3ad-08d8e4c9e549
X-MS-TrafficTypeDiagnostic: YTBPR01MB3983:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <YTBPR01MB3983981FFE9F47C5E1FFAEA0EC909@YTBPR01MB3983.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C3Tnx2bPl0pzLh1lVo1C4mqoBOLTN4WRCk75+yuXUppFUMnLjeZ6H0vINW4GGFrXMAUvTsDREWpvwwl7F01tnuoBEjdDVb2EzyyU5TYGJaRktDBI+kEusZtvtbR8dbICBOnEW2cbJseZw44TZgKCDFpSZ6BqwaN3bbYu6+gnhgFlgrmTBfFu409N5yaVJ4qYSWh7zbml4gwIvyQygCde8+KU2w/UFPa6/z3adRni9DM02plT2kp8KuScvRcE88xo3g2XwIgB2/Ukn6kuXJVkUeiRc0gmPQsRhLUVxhgiUZ8wL4BR3bJU1M2GBG8+NloXODTlVjxSxuFy5J9Ikpk8chEzVKtPu3Rep8AAGAxCF5REVTp9vxkCpiCpXsVYbNJ/wPjdxuvcRGnqHzV9QZSdEHNfIbuZ/YLUl2P7EhVie2h6hww2aBb9IKpz9ZHIM2l8iaUpYfwTrkDwHMchNmBqlFTuYktjIH+xwAVK8WtlVPNdQr5zqy3+5LgEEAoDdrXKhOHHIwVo53wtGtzTS6QSseEgZtvlOIhfL/NW1XT2iPS1LSitWxd7o8L/v7zbmQpUjT4YLptLo0TMajEDUA5KCw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(136003)(366004)(396003)(346002)(376002)(69590400012)(2906002)(66476007)(52116002)(316002)(66556008)(44832011)(4326008)(6486002)(5660300002)(86362001)(66946007)(16526019)(6666004)(2616005)(6506007)(1076003)(83380400001)(186003)(26005)(6512007)(8676002)(107886003)(8936002)(36756003)(956004)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?dE4X1VJ2sUpBEGzXAaZks1k2gln8z7758CQNaN2+GXX3MTJ0tYUIgGxc8wb5?=
 =?us-ascii?Q?WOtKI+TmqW6nVRrVwZQi9AClMCiXCkd1dNkd0xOBzZYm69VT/J+134vINFl8?=
 =?us-ascii?Q?wsK51lkTHeFn+81xARF8jo8sHt8udXZioMhcSn/9USMt7vlrOxruUY51i1Lq?=
 =?us-ascii?Q?RTPiB7GNTJAXCSRsB5OBfYeVv8owj+I0/VvxXl6JRl4/dHkph/uNxoWHKlUd?=
 =?us-ascii?Q?1ULQNJU9/j2LEm/jtRO3MP6Fm306yogSu06lMLfwnxppV5Vsd1Dpicce3W1J?=
 =?us-ascii?Q?P3x79SgiOKV9XZ9z1/qYaFv5zu5FRsQ4jxPwiEcay2Sx7Me9lmKZplzAv6CS?=
 =?us-ascii?Q?4JNZDIMLyAe+Hbgm5bwG7/rnRebW/s9Eel/ePYE6hYL80vexYJs3WYxWrM/W?=
 =?us-ascii?Q?cKCpKdEzDCxHPlxQ0yedxkTPhBiOOHAuPYvpfiIqQKUW1Cf7DxYTaLkhsqS6?=
 =?us-ascii?Q?or4iWp4COwmxlX2J/wjtkAF2M/4z4Jr0sd82q4NtH+O4Qk0RXROGrelqOwuA?=
 =?us-ascii?Q?T9+oXSPBKZv8L2OLi9CmnELQG1Zmm85cyYBUnMebjMUN7DUVjGKVrgl0ZSUV?=
 =?us-ascii?Q?6RLcEJxjlzEy7BpdR06+yKfp0SmTQC/WozbsvQptKMd2BviUeXeOoCPfr9cc?=
 =?us-ascii?Q?FbGuimQClaamWtM4YuUlcSOfOiD0muHUEgbpy+JKU0q2u/oUxJXEGq/zvr+l?=
 =?us-ascii?Q?TdUYDCun6uu24is7SFYGXBWtYzV8q5OLZUGwSKaTOqNHHTtrZeOYCPmX47nX?=
 =?us-ascii?Q?PDdHozWyAL5CDYBN1Qcnta5/kFswvFq7XDGwQyx0Qe5FU2flrCz64uAllsjP?=
 =?us-ascii?Q?8OLVqTQM3UgacVXX3HtUHJmI23/OUMWZc8c+bxZTl4e9voit2+LgIuPBZIX1?=
 =?us-ascii?Q?VVKITkCrwTvqPGyARx/MqNQNsWu1g/f3akvQYmOhTAAyOt5fVmF7g9Goi8ft?=
 =?us-ascii?Q?C6ufgGccTv+kNyvjbsZgqnRJTWqfxFI10250n9dKWZFejhAy+yu/Nv+z83tt?=
 =?us-ascii?Q?NFv9YT+W8Ta7bFkcEerQIDxmci7w4aie+KvXEPdKrAVPmRWjYX+1w5w3pQDK?=
 =?us-ascii?Q?84T3Hz2YfMG2mlLr3+N0zlZvVCOE/T3O2mdM3ABukGB1+zOWIElHLlmSo2Ec?=
 =?us-ascii?Q?LlT6W5D1zS5zv5cBckZksWUcvcsPNT/Cp0fL5rUJ7vVpUpPIKRjAVdI7+arP?=
 =?us-ascii?Q?Wp40TevdyurlgN1lTDZWTvP9mpVxuGWyeQeznl5Z4v+BtPs2Ac9a8ZRL9lG2?=
 =?us-ascii?Q?qq/wd6oGRFqVFOoQDGyUrzUEF+r/5p5jBHK7aTn0ERIjXI76rNB2CIpLZX5x?=
 =?us-ascii?Q?Cc0AadWz+YXYqW7l0A+PFA/k?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ce61e29-b8b1-491e-b3ad-08d8e4c9e549
X-MS-Exchange-CrossTenant-AuthSource: YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 20:11:46.1186
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CgEUE4j6BaiPkqGQlhYzxFW7B3YOLT/EUAmx/j3g1YzWls5qPkuEuY5guY6mmPlqiKZWMYqZ4OpaAyckAYKE96zH9oEYPj9lbNeM2Yr4AJs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YTBPR01MB3983
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-11_08:2021-03-10,2021-03-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 spamscore=0 suspectscore=0 phishscore=0 adultscore=0 lowpriorityscore=0
 bulkscore=0 mlxlogscore=999 impostorscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103110103
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update DT bindings to describe all of the clocks that the axienet
driver will now be able to make use of.

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 .../bindings/net/xilinx_axienet.txt           | 23 ++++++++++++++-----
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/xilinx_axienet.txt b/Documentation/devicetree/bindings/net/xilinx_axienet.txt
index 2cd452419ed0..1ee1c6c5fc66 100644
--- a/Documentation/devicetree/bindings/net/xilinx_axienet.txt
+++ b/Documentation/devicetree/bindings/net/xilinx_axienet.txt
@@ -42,11 +42,21 @@ Optional properties:
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
+		  axis_clk: AXI stream clock for DMA block
+		  ref_clk: Ethernet reference clock
+		  mgt_clk: MGT reference clock (used by internal PCS/PMA PHY)
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
@@ -62,7 +72,8 @@ Example:
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

