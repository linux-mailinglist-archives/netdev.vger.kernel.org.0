Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58BD7339550
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 18:45:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232608AbhCLRo3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 12:44:29 -0500
Received: from mx0c-0054df01.pphosted.com ([67.231.159.91]:7152 "EHLO
        mx0c-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229959AbhCLRny (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 12:43:54 -0500
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12CHbor4013654;
        Fri, 12 Mar 2021 12:43:51 -0500
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2059.outbound.protection.outlook.com [104.47.60.59])
        by mx0c-0054df01.pphosted.com with ESMTP id 376besa2yf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Mar 2021 12:43:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e+ZUET0qRVTMM97cqKVRYFqPzzZ/4RH73ijAH5bWshtvC4vK7ZcfMDWuD3Y6FU3mOZAuEY4kULkfjdlTw6TTy4MU3eswURdervsIFu2h4jYhER4p6uyO9ry4A++qzGRymq7fCUE1fBOqRbfHw44vS5jt2Vcuk7CGYiKhrdxBntbWKgaRWUipoaX/IrYw3mjwbKsUlM4w6GjOlmzz53rrZ/f5vuoyg7AgfANCIIo25lVNNqmHyQZhBIToHcLnXXmLCiCBRCh2f2fVcqUlwj9oexqAmWVKZMNoFGWlUs2cKknhGtU55Rk0xPIVcj+GmmNowpTqHCEc876aTbCcv8Gj0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=usUls+V4fHAmc7YTudsBYGYv7kOuw0WZIc7l6O/Kyb4=;
 b=Rk6o4q02GJygYRTs/zkS03K7UStVRFQDzNQi+8SNJvGVy+ryvfjmvggcMGFrr8xwF3oDFSkyCs2gayNMfA1CQz6sR1HAtkkODz8ymOd+eSH0JpEQbEH/QvkUWHxwDxl92Ysa+X8nEBFIBMJ3zJ7GfiOKWwTXw/WYWxbaraq8xw8BWQO3ssGPqjAL6BpJ24NICDgXKZWVVg6hmA1nsFFpGaxPWLfxCcnwZqeB47zdogtBod8bgdH3bkjqAKH25A5S4Rxd0RbwJN9ZMyu2QcyQPA8/sO2LSIyY8AIkr7Ri3Mk6hQm9YFu0g8eh6mwkcGugspI441XRviaKJS+mJtItAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=usUls+V4fHAmc7YTudsBYGYv7kOuw0WZIc7l6O/Kyb4=;
 b=fpecTSlgtQjO87PgHUCHOCcV2wsjiwrR2O7YcvtsshddwapundURYYF/R/62MGoc5ejV2OCyx+ROBG2m5j/KXKo8T1erysyROdIJKn7EeMDiPne4sQliOvFuyGXFIFdGG+rHzjEbkow0OmMXAdl9aLQPSVZqPPypBA83gzYR0zk=
Authentication-Results: xilinx.com; dkim=none (message not signed)
 header.d=none;xilinx.com; dmarc=none action=none header.from=calian.com;
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:f::20)
 by YT1PR01MB4440.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:43::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.2; Fri, 12 Mar
 2021 17:43:49 +0000
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::90d4:4d5b:b4c2:fdeb]) by YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::90d4:4d5b:b4c2:fdeb%7]) with mapi id 15.20.3912.031; Fri, 12 Mar 2021
 17:43:49 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v2 1/2] dt-bindings: net: xilinx_axienet: Document additional clocks
Date:   Fri, 12 Mar 2021 11:43:25 -0600
Message-Id: <20210312174326.3885532-2-robert.hancock@calian.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210312174326.3885532-1-robert.hancock@calian.com>
References: <20210312174326.3885532-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [204.83.154.189]
X-ClientProxiedBy: DM5PR21CA0003.namprd21.prod.outlook.com
 (2603:10b6:3:ac::13) To YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:f::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (204.83.154.189) by DM5PR21CA0003.namprd21.prod.outlook.com (2603:10b6:3:ac::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.3 via Frontend Transport; Fri, 12 Mar 2021 17:43:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 77aabece-b980-43bb-126e-08d8e57e64f5
X-MS-TrafficTypeDiagnostic: YT1PR01MB4440:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <YT1PR01MB44406F3BDB709E7ED01107C8EC6F9@YT1PR01MB4440.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7nAZ1PVOQ2u7LZzAks9JlMTFU1qoNJmCdSDq2bn2JVaOFpzRVDJ0zzpyUG+iD2SNORatHwwrcEN7sM/2atMCV8+K/cL4/akyMdZjOI59nqIPirt7JiVHfW6euPFkZ0aYdJoj8dCXCFnThzcQV8s/1RzwnR+XAjUcDT+0DkTvxVZqU1e3HlwLhcUIC6n+5glw7m/SXr8ONUoLXloQ/bmElPEZr3s7dj5rTRfC+rZUojb2o8biuItQMbzm+HTorkjZdQjAYZ5u3NNzh5DsmOUpSlnac9dimvSvDOVE+BH3Wo6fEXo3SK/gKdqkiqqEHOILbJ7d/9XBaO2SWSPO4y4vnUm+W9gpj0xPwsrbiz3DIgxjhbQKic/djmZ4cPHoE6HDvoTlAnjTqQM7eB4jj6s0gzpVKOSkvSrd/zuU2iZoSa0sf3DEuv7X8HYsHTiit1318AX54jMebwmYpjMIrABlnE5IS0zLNv9h5VOg72sp0Pnkmz2VADMyXbBvuxllBTJb+e1wlQjkUxyPwkYLU1E021T4n6rTpn7aqd0tULBgnHGqAzxB1oes6y1GnwoDmVVObabTCNbDKQmY4EZBjtgFpw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(136003)(39850400004)(346002)(376002)(366004)(396003)(8936002)(26005)(2616005)(8676002)(16526019)(107886003)(44832011)(4326008)(36756003)(956004)(186003)(83380400001)(2906002)(6486002)(69590400012)(5660300002)(6666004)(316002)(478600001)(6512007)(66946007)(86362001)(66476007)(66556008)(52116002)(1076003)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?r3Fe6tPAdv8PJZxOIAUAJY2iqtMYEvzbkifFE/ef/PQPZy4KiK2of6RGTTZ8?=
 =?us-ascii?Q?EdI7hV6Ix92nNMdg/qfh5ZQAc9OrKGj0XJf8C2wO0ckJ+c6rdtW2uYEda+RO?=
 =?us-ascii?Q?lmmqKZHaypwQHufKsCxupOY9cImJ6dc5ju4XN6FOy9veOkZCN2sizhZfDaBm?=
 =?us-ascii?Q?GdWWEs15JxOYrlB3ttHql8OQLiANE6CEw0M4U4R45VybZakBch7gLxiMxIQx?=
 =?us-ascii?Q?fzWhqnJGN+SBDXcTlh7xy4bmzCiG5bdBkt2CEuxO961DrWLEiiYgXA5Ruq2z?=
 =?us-ascii?Q?cpVOWSsUCA9A3yDGN+unOaEdP6PWFLSZF/fnCaVPRkuvMUwPQ1vF+tZwWLGy?=
 =?us-ascii?Q?4pa/uH9jHRywOgRI2oekG2c9k8cxgypOdBAX+Ju5GDK2EUUyVnsEjruu9QTe?=
 =?us-ascii?Q?3DI0+zDXT2WCDKmwLT1fn4JO5gmkN3PaWPUZe3QyyIWwG6yo9z2FPa7cgwRK?=
 =?us-ascii?Q?lcNCsPxljMRuB/YP5Lw288WM30mUOFJZ6lgoa3vQfgzxZao3FyYQwVhU30L0?=
 =?us-ascii?Q?WU7WjHFpjzN3+H/mLsyQYT+x3ly5AavyLm0tW89ldBaXPVbAdwE2n2/uhvkr?=
 =?us-ascii?Q?HzyH/RexTEB+J6uE0QFrYMx6ytu4QK5eD3LKMJd+LFsPomPJFmE14HxtSNsj?=
 =?us-ascii?Q?8WMH2fjepfJKBGT+h5N21QB/UV5NBGRjRdyIH853cCnQ+8Wf19wKVp1bz7vn?=
 =?us-ascii?Q?bSAh5e9CCkiYtvMY8f2QpeVJSVat9u8l4xXhSzUb8Su2DpT+MctELt/dSRdA?=
 =?us-ascii?Q?+pPaMI1rDyg89rnjXRLoWt5v69xN0y3ajSrqKMqAkBRW8237nh4OQa/99dlg?=
 =?us-ascii?Q?w9clDSF25VuNfBbf5iWEEXUlH7UIO3W9p2IHNlJiFuXT32A4t1Sq3wB/RN1K?=
 =?us-ascii?Q?d4tRA/QRXrhDpBPoAtOteyUTUHu/YkgGp9E1jpkB56HAymjZkFTR3F8haCez?=
 =?us-ascii?Q?4+ZKdB++UNAl18D1XKBjqfacwLnl73GwiEcAH3e+cR7JmVufouqMkQbp1/4+?=
 =?us-ascii?Q?TjHNHu2Pj2WhoKYC7uJBVWh6UEBrdkuT2cmVzxrE/Z3/WMInLDcHUy90i/8I?=
 =?us-ascii?Q?zzDYRmQ3kfIg40gxKg5dvmA6UsOvCLSorqsT/nWYZg5lvTaBfxADWTloicJC?=
 =?us-ascii?Q?ADlHrpC5mph/351tX76d/wCC0NtKBkIrvUOEPf74ECgg9dfe/10fhbPJvO5U?=
 =?us-ascii?Q?nB8lm4O3T9CYKNwHzw7Rom8bUxDq2yL/UonRuCVqJ2PBWBUeqw1e4bxekA70?=
 =?us-ascii?Q?HcYlY2N+0fZ6Bnp1SctKzNoWOPVGmgHf8mUCdEGRLbPFS9P/YVwpQBLFHn/k?=
 =?us-ascii?Q?e8VUsPHKtasqHkmR93ajpgrA?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77aabece-b980-43bb-126e-08d8e57e64f5
X-MS-Exchange-CrossTenant-AuthSource: YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2021 17:43:49.7016
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SP+KzNU2VEiGpjre3iJ8hh/w63m0AzGlRIPpRFPXFLjZG9O9moInHZh9jXrdm/+nMAskcq6zv6/VzjI8yEWjqyLR+tUO02jiDZQ4fseTQ5M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT1PR01MB4440
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-12_06:2021-03-12,2021-03-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 phishscore=0
 priorityscore=1501 adultscore=0 spamscore=0 lowpriorityscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 suspectscore=0 clxscore=1015 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103120129
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update DT bindings to describe all of the clocks that the axienet
driver will now be able to make use of.

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 .../bindings/net/xilinx_axienet.txt           | 25 ++++++++++++++-----
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/xilinx_axienet.txt b/Documentation/devicetree/bindings/net/xilinx_axienet.txt
index 2cd452419ed0..5df5ba449b8f 100644
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
+		  axis_clk: AXI stream clock for DMA block
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

