Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D0DD3397C9
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 20:54:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234485AbhCLTxf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 14:53:35 -0500
Received: from mx0d-0054df01.pphosted.com ([67.231.150.19]:65373 "EHLO
        mx0d-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234407AbhCLTxL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 14:53:11 -0500
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12CJr0Ym003162;
        Fri, 12 Mar 2021 14:53:07 -0500
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2057.outbound.protection.outlook.com [104.47.60.57])
        by mx0c-0054df01.pphosted.com with ESMTP id 375yymhm90-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Mar 2021 14:53:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mGypSms0ePxeEJHYEkworVhvjtL7LuAPPHV/95dTaaUBzwe/zrOEv856wIl9F85t4HMqjwF7AhqwsiW4ZP3hH6wRXUrSUAz7RMyAoxTkgbsOPbWose0vM8RVgNAfH1a1wkB2KPqvNCQRvPoPL7eyAeFEUuVeOONM++hDG1vh0EgYQAXE8gSa2WFAkIeNx+yJmyi6UrSehAMvmM6PvHAe478QDtg/WjiXY+Mc73HcjJkN4izInXw7dFWRDGazjJT5t6386Q5pbqQ7TbmoEr6c8BWZ0VKoyLJVD6oR80iqlR6oxNRkQRTlDcplvjFCt/4SrL5g0XBdcD2VTpDZa/+ipw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ind9ebnemfXvdDSDofBhjoNHL7pe/ogjxBzc/AB+Tok=;
 b=mRga1nPcK9Hp7xTakkt1g66Ek9zBdw8HkhOb4k4VGqzPNt4+yZ2wbM5+agFcwV1rbxAwUs6VYeBjEZ6LrPYzr+MswL9IldoMkT/+ha4c/LjyT9sz4BBYvSUWdOKXnQilDgoEgP1U3Egh87Z0HmqTZ4yRCXrXiXkaNHJ4mh1sTZB/rl9/W1/Bl7p+g6Vo/Mw3NQoeU49QewEAEun9NTAAw6ffggmiDMhssVU4ym6V5LntBbZkd3UHFybLFz6dNMgr6tA6RjuxIi5BLc3Pop+p2WOp5mNA7jb97LfHT0dKdxMHTUeWrfwRHxP/Z5193kSwIfDbtpTnpzjAEWQFhaxOJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ind9ebnemfXvdDSDofBhjoNHL7pe/ogjxBzc/AB+Tok=;
 b=vfIR/LZYZCpDAa4FGM5Cz3UIXQRehqUdNgwPZCCP/t33wPlAYqlBsazrUksnXOKXQlPTRiJ+m0+0jr9MLirAmqSipMQJrvTrUpqU3MOM0FiD10GlAu66GjV50Wdrraqj+ae/t/yDBcxCyWd05nXCjFnM+dGtZ/sDP8JCI/8Lh+U=
Authentication-Results: xilinx.com; dkim=none (message not signed)
 header.d=none;xilinx.com; dmarc=none action=none header.from=calian.com;
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:f::20)
 by YT2PR01MB4415.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:34::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.26; Fri, 12 Mar
 2021 19:53:06 +0000
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::90d4:4d5b:b4c2:fdeb]) by YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::90d4:4d5b:b4c2:fdeb%7]) with mapi id 15.20.3912.031; Fri, 12 Mar 2021
 19:53:06 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v3 v3 1/2] dt-bindings: net: xilinx_axienet: Document additional clocks
Date:   Fri, 12 Mar 2021 13:52:13 -0600
Message-Id: <20210312195214.4002847-2-robert.hancock@calian.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210312195214.4002847-1-robert.hancock@calian.com>
References: <20210312195214.4002847-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [204.83.154.189]
X-ClientProxiedBy: MW4PR03CA0025.namprd03.prod.outlook.com
 (2603:10b6:303:8f::30) To YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:f::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (204.83.154.189) by MW4PR03CA0025.namprd03.prod.outlook.com (2603:10b6:303:8f::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Fri, 12 Mar 2021 19:53:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: afe3a6a1-d7d3-4c19-a58d-08d8e5907483
X-MS-TrafficTypeDiagnostic: YT2PR01MB4415:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <YT2PR01MB44158C45478ADC21DAEFF40FEC6F9@YT2PR01MB4415.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kv+QHZpn9LbqW9etp2nAxqgNQCeIMHi0XN7pD+N1r41xAeAguHDfo3ucMrqT3PI0LrqA5gTEBZ6qYgW7mwAxb4om07OkvjIuN5QMqjhGcC0A0jMi1iGYpHlT6eWNLKpWlSBOlTRh4ukNSmBKwKz/O1e8K7ER3kQCnJDiH6WcLw/6O+oCtJ3gCNgwwmbfBFMcqtMQZIta60g57Sn/MfY3TaIEvSMTmnzZXYFmLSf4anAd7YoZNQGJSxMwQyE4bkzGkvouSFGFQ8EMqi1Q/lh3VpeBUlOg/nVy0KQRfJmmHcrU5/0mhE41XVOcyxYyJPGvJy4w+IqOrhpvRIzkzpcEO0U1uRJbxzvxUwvfkh/mwY3vqLtkJSB9kjmhD95NLIqCy1BORAvOW3mG4T9SESyyRB1jYQsZDh6yLfTl8twNzsD00ZC0+yBgzshihl9mmNPDTCvqEiaOArI8b7+8PoOJXl2oEjAINhnvgJ74jr1yMYIMqI5ggWS8G52XIbSHuqO3sZnwhFsr2nL7efwBNKbW7c+51jxfDKYNzS/fE5iAkr2r9FkjFEAoTIGBaYUWeTzGbPHnmcx1K62aUxlnCQLKAw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(39850400004)(376002)(346002)(396003)(6512007)(69590400012)(86362001)(66946007)(66476007)(186003)(26005)(6506007)(8936002)(66556008)(478600001)(4326008)(956004)(44832011)(5660300002)(2616005)(6666004)(6486002)(1076003)(107886003)(83380400001)(16526019)(52116002)(36756003)(8676002)(316002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?SprqLUHyfsRfDFeP8xBpGDp4GX6fj7k37f0OaXsGcKOxeyrwVHkj86mVQZF1?=
 =?us-ascii?Q?nUbIhlP/iL5o1EumJzV1R4LsssBrjcxFsJ/1a31BhQ7bYdHEyEQvrxCeK9wx?=
 =?us-ascii?Q?x2EO2oCZCvoKxGx5xRUTK/+ku1zT8DBic49aYe6ZteV7R/CDpesKzJA8PFuY?=
 =?us-ascii?Q?xI8pPs2XGhfkm1HlWfBEyWIb/9QM15QwsT8MWP9uMokbTy7Tf2vlufQ1W0kh?=
 =?us-ascii?Q?+B5XbVvr8iQWZ8Nza2E9TDvL+/qcjaS/Rb+NruxAQlrsX3BNHE9MuxsUPnyx?=
 =?us-ascii?Q?FaLsfRztH6jxXWwuLGttpa3MrKtyynyc12bZQ+UGZRkrzLCGHU5GWFRUz49I?=
 =?us-ascii?Q?KYdysGBQMBuDYmO5aIXbcTTW/2Q9UkCkq50NKrphu46SkfIpmKapdevpdEiQ?=
 =?us-ascii?Q?SDghkHLrYcwmQkSbMGFOGBX2m1diVvtuxcJ4nRVTcacuTxSZcUsP0sGdsG6+?=
 =?us-ascii?Q?0C0YN8POrGlM9zjb5gOLPVPvNY3zryLPzvO1AN5ePVww//C5RctQyozewSyO?=
 =?us-ascii?Q?qC902Nb86rgONyqLPg4YJsTdCPkvTrYNHkPzaipk6HVE5qC4qV8dDnGuFLzJ?=
 =?us-ascii?Q?VYHFD2gQUGyopnguuGgTyW4rZ5G3bfOEchLdCyx0lnHohHLITL9f8wWNYgtU?=
 =?us-ascii?Q?oEqzo6hyuivu1xuZvHYOfttUm0dvoNwPgTB8l8D0r1I3niYZ8eXQGoCea65X?=
 =?us-ascii?Q?tGrUqkPZKIjjE1X6oG4eZs6kFX3UfK1hQa4JlzCq/qCqEyJlkvDDZcxmoI23?=
 =?us-ascii?Q?uKTDlD/oKMzqBIze7pZEzMldoUYyyDqgLbirIPfmAYY3skxKpn4cUqOgcDKF?=
 =?us-ascii?Q?e3a20UrkyECtAg0p0SSHVUVquh8Pp6pLOvXFKX3fE513JXd1BqnAFzI8VT0x?=
 =?us-ascii?Q?hu+HKq72S6AeLcyKfN9a6CXClhfVRUzID+YlhRRROP0x9InJVQb6ZBo9K63r?=
 =?us-ascii?Q?j9MmFF3ptZ5bGMhIh6u2PUEXpzD3aZmt8XpGO+G4d1e2Eoly+so3Wyem649O?=
 =?us-ascii?Q?hZWlpT3ToQerPbmF4+9MhkVukBQ5ld843vqLF46v/OG138o+TWVM2nCgdknM?=
 =?us-ascii?Q?SqmHvhn7M/5iP/06yZiEXWi3m7CkMUeLSO3ge4oo5x/TWcd3XIs91Z71+Iqr?=
 =?us-ascii?Q?AHpPqNEj2zqqXZffuWx+v+S63QM17ROGYwdijs22liJByf8tE6ua9DVP11DG?=
 =?us-ascii?Q?hw5YFwWEwg8nqNc2bJav/9PHbkjFyGpq+3JiNuo0P4e3p0Dsm3Zvd86wtxpO?=
 =?us-ascii?Q?CD1MK7LThSJvIHQtv57Q10frREpM+2hlhPTz9SX8m1aOiMhVxPM2GWK5Hx2o?=
 =?us-ascii?Q?6bJ9KxScZBWpUHw+Vk2HYG0S?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afe3a6a1-d7d3-4c19-a58d-08d8e5907483
X-MS-Exchange-CrossTenant-AuthSource: YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2021 19:53:06.7170
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +MD4BYlgfN8Mc2UpODQIUJ2UIJ/Rx1cjLlo4e3ihcam0ulKQXkZ2azIg0xRqfAEXFCGcovpN7LxzGmhyegN6wCjL5AEWjZhb4xrl2GqgRK4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT2PR01MB4415
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-12_12:2021-03-12,2021-03-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 spamscore=0 suspectscore=0 phishscore=0 adultscore=0 lowpriorityscore=0
 bulkscore=0 mlxlogscore=999 impostorscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103120144
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

