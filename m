Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3A049B9C4
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 18:10:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239482AbiAYRJE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 12:09:04 -0500
Received: from mx0c-0054df01.pphosted.com ([67.231.159.91]:54701 "EHLO
        mx0c-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241838AbiAYRFz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 12:05:55 -0500
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20PCEDge028781;
        Tue, 25 Jan 2022 12:05:49 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2052.outbound.protection.outlook.com [104.47.61.52])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3dsvtr0y1c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jan 2022 12:05:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W1D6lZh8MFkg/5p/NJEySP+X4F0Uz/4mnay+VLEIee6zu5I0R4evzT2p7aDrt5lbcDGMYdQNN9DiN6qHqYuwkfUde83s4JIEAjnP+9mx+UTM2RvovZVOx2to3MuWCIYqa3enC8PKRcDufkFdkLnBVJGurTX7edcFY88z4BfxWxJqqggnL74PGHPAb2uePqy7yr4sk5gm5v56yMTYKxTJOjqHvmYJ8WfcnpXmwv0Z2hNwh2CXhsr2UXFBSAJDz6SchZUlRvApQUxmL3ep310VKG9E1UMrC7rmQkPpSPvy8bIYU7UiXhGdejb/3NQRWBPaJgnSWLBMGMGiaAliywCZdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A6He1RJ5IHND7KBTAPhW32Ur5TrYIoxd8nOhj0HGIi8=;
 b=aHKlsVT78hOTNKQHKeqVBzb6JzyDY+68z8i+jMwAwugQteqAZuoCRPdQbpAbm1x6BjLz92VwbIZKbiuCPW3W+YquoSEl8p4Cg/s6ZqX7ozpgh99J/tOgiacY592KV4XdGIDyJPyqXIg10HE6UP7tfH5mgvBDIFI0Bttcw7kLHLEHfvDLM6KvR20OgCXz/uQGMdlRR8R5dUYQlLLzeEJVEuUiuNIcGjggl0AZ9t5efHgALRclaWUVUqB6P6aOCh1d+xHjlRgNYRo7I7p64+ONaMWhx2XK9lQhi2O8uDV2Z1teCryMuOhbfjz6RBPckl/kdiLZJrqLnzzNZ2YlQaF2Lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A6He1RJ5IHND7KBTAPhW32Ur5TrYIoxd8nOhj0HGIi8=;
 b=bXngZVgVI8BLSjuL94Hgw8SgOpaf7uIwomdg86TypDBfe572I7QMQHYpCn/H3oAx+cH100rpGiZeG/hhMi04ORy7wTc50sX1xtsNLWHJqvYqHpec9XW/FnXa/Ck1Ib71qdIHg5NuF9nvyX2ZOJYVR1Gx7vU7vEso8XjBOyuwiNk=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YQXPR0101MB1144.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c00:1e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.8; Tue, 25 Jan
 2022 17:05:46 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8%2]) with mapi id 15.20.4888.020; Tue, 25 Jan 2022
 17:05:46 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        michal.simek@xilinx.com, nicolas.ferre@microchip.com,
        claudiu.beznea@microchip.com, devicetree@vger.kernel.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v2 1/3] dt-bindings: net: cdns,macb: added generic PHY and reset mappings for ZynqMP
Date:   Tue, 25 Jan 2022 11:05:31 -0600
Message-Id: <20220125170533.256468-2-robert.hancock@calian.com>
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
X-MS-Office365-Filtering-Correlation-Id: ca156ce5-dd22-450f-307f-08d9e024edc6
X-MS-TrafficTypeDiagnostic: YQXPR0101MB1144:EE_
X-Microsoft-Antispam-PRVS: <YQXPR0101MB114457FA8E282FC5B86A8C37EC5F9@YQXPR0101MB1144.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:2512;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LvtMmQhogBC5w/eAKfvpE0IdQLOfGhqtHHXOLTjx+lAbs4dELeK+zM8md2Ai1bt+fiwxQEXk7d+HXfnDqd0IF+FvcPCK8wj/wcGk+rICBh810yYHAEUrG3WfEgwaxp1VTdIhFHE7HNMoJ73X9YVsgXET1K5dQglV1D5/d3ZoUWKuXnkkcSAzTcdGa8MvLhY0c/YFh3QubwLb+JIupsVuJ/1K2T7PxF5BT0lF66XAuFz6ztefUMkUUDm9X7niC9vufFyPmTCpaWRkGlxrcB2eLW0KMw2UGIvhL1s4QF7n52JT+xiFB+hSBC+16cUO4joUvvSEh/sG6YsXhnhbPwsUBB6dBuXuD9mvTefG33LbR02utyDoTnGtl8TNCCuOyqIlpsfLVRG1K2R29raW7OhJLh1Jrre8E3sSXKbLmrwD9xF064jPYh50Z7nBeMj4l33DC/EPqQI+GetVfslnSasnvABqOgYn8B1AYNwlZa+BLVTo4gFJI0/ivdfSFwdItYpkQMlBXLh5sRnmfiQzCTSo1AoI6Mg1OkKKSyLj0uXq8DXuqwhuw0aSfmctwJ22rMsgxYLqsQGf3S6cQKCwsmxMVROxthJo9XHY0n0m4VyJL6Gi3Y7f0cFxRn9sWjmhuxZfNRANM5YZUSWpgSBKd1N/Ruo+KLhoOgRtes7QNKCzDblBoll4zkQvfHvJ7Ylh+hieTZeVoEfvI/Ocv95L9yKw3uAT5+V84ThYkKBSpiNqgoU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(6916009)(8936002)(2616005)(66556008)(6666004)(44832011)(83380400001)(6506007)(38100700002)(8676002)(38350700002)(86362001)(2906002)(6486002)(508600001)(316002)(107886003)(6512007)(1076003)(52116002)(36756003)(4326008)(26005)(186003)(66476007)(5660300002)(66946007)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6G5UTfe+x62KIGQVlW2jmV8ORMu1nPTdzKMYcRHYYCabB656en6Z61XrQmCb?=
 =?us-ascii?Q?h0HEwmOKkLXQPqOFirc1jafxPLXSH2uWIpp3XKsyRFZ1NXx7/SNIDuqR3Tdw?=
 =?us-ascii?Q?sI7F15XbC+YuihjoRQmPhBoTcNaQrP2w0hQP8IkLnftLIAiGGe/4nxOUksiI?=
 =?us-ascii?Q?gq1VDxsS4/zVnwo7SAauMbwPF5nNiGYH34rURlVFPGmK++2DnRSDlJ5vheas?=
 =?us-ascii?Q?7MMbdPwTH58hqJVT+wwl/HEHqJesym7nnjv0xpeWq4C86K+/8zlesJgDZipg?=
 =?us-ascii?Q?iGz/71gx3Ky2RvamIIUE6mUXKaMCCmGxhI0UUtdb7bdDPKQPVYxDpuKM1R5K?=
 =?us-ascii?Q?VSSjHhvTSd+P0EMoOnsnKyXW27CLp9WSw4KvmlkyPSzJ0Gykp0e9vy1xxUzt?=
 =?us-ascii?Q?5e2YAHnouwpLndM9DpACZWB2Kju8IpqFgkO0LKfuy4XO/3Bk9XISchB5v93q?=
 =?us-ascii?Q?/bPczRDjERH6MFK/1lCmLlNzrdmr7/dnWz+PZw8EKoojYBJ092uvNHTugntW?=
 =?us-ascii?Q?h9ucNo9M/jBzAhAAMYE84mHuqaq6ebgU+lsqdaFXSKGyUp+QAoOAJD8Y0cVq?=
 =?us-ascii?Q?IMgsVsG9Hxbx7sTob+rHsiuXsyg5YHO74rNKqdIVFTLSjwDca4BbiUfYqHDw?=
 =?us-ascii?Q?o4O9gSg9MraDaT/DXshQNFr1ReqIHMjaA6obQIqIF8eZ89jQy6kZ+77e5SMb?=
 =?us-ascii?Q?PAbRWxO6R68CJEoxlSIns2J0r4BUu2MZS6rJeg0S0M9fBPQoWII21Ec4pEdi?=
 =?us-ascii?Q?6+ru3WlJz0WxxEVlpaqI4b9eU2dE4+wNmg8a4dQVC9oe84X1m8qpYOYtrtRC?=
 =?us-ascii?Q?hTBtu8p1kliSOcUlhyWwY9o9EidnGTITmg+BqzaAPXaN4GCjeS3mL1O1q2/U?=
 =?us-ascii?Q?7zdeQ7wYTDGOA5H0mW5aF5JmK7ir1u8JFAaBRsKj0KfX4Tw21gsZxh3vcYYF?=
 =?us-ascii?Q?dtD+vWDxMugZfdQVb6JykOv7B/mpifBtfJZJkbmg6VmnSzU2NVw3AD/K1axD?=
 =?us-ascii?Q?jtZU2s1wFCNa/5cYWdTK3Pkabjng5D+2XVZY/IhkCuML/Wi6SREEfSHtOHiB?=
 =?us-ascii?Q?6oOZMGvXoSKc4tFuwGNq2bKjU2ojuW4/eKCDIlDUj4nRfDuNus4K/c/vliCy?=
 =?us-ascii?Q?H7dOhE1G9wpFKKdJYr/g/Ey2Tu8ztJOitRNQEnW3Vvg2mGsKWOr5iGZ3d3qa?=
 =?us-ascii?Q?KvyfjCdrELf5Z6+XrYWT5dmYHVXZA3EGgaEXLqHL/b9zQ8a843NmsEZFA6P6?=
 =?us-ascii?Q?bnO+BSbQLMIVQEiTD2wfv0wB1h/KqDDcOPPIzO9sVOsgQV/M1Oln/eF1O2kq?=
 =?us-ascii?Q?RJfb/Uk8GaVaZwUBHNlnW6XW2vTh8/VYurtyySoos1ZzTkC0duNs7bAUp5St?=
 =?us-ascii?Q?2u3h2G8dKa0bPb5pA9EyzNqd/ZMfcRxb1qQIsYF7rlcp+/Dls9zs1ARhY0Xz?=
 =?us-ascii?Q?NNk30wR24e1LXppNh554EwF3Yu93PMsBxiHq80tpZli2rnT2VLo5wMWvkCV5?=
 =?us-ascii?Q?w8WGvy0H75/RG+tmHLxLj5gzwNCQBgXIegVMVBQRcJmuHmEPaL8XYaJp4k/G?=
 =?us-ascii?Q?9DnZh4UV7ePuz/JacbCllDQkmbVOofrf/jj2QzKBwH2kDmt3ToeX/geIX1Mp?=
 =?us-ascii?Q?R+wIdPqm7H8YndU2d9PNCMO7DbX0UUUYD0hKVbl5hqA5VqaaehAO+mEiFaNh?=
 =?us-ascii?Q?4vQl3fSt2ob8J6+rebW9xaqTgOw=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca156ce5-dd22-450f-307f-08d9e024edc6
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2022 17:05:46.3518
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D0KC1xeQTxQRhi0kY6ycz249GQdmJRltMYXB+lqwqdvIv5nWto1vjNXa14lq8+09MsewpLJCRwKmVdMGxxUWYl02Aflpe2OgvJ5/9UcvpKU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQXPR0101MB1144
X-Proofpoint-ORIG-GUID: J5PIIBhl1Cp7ddkIdYKEqUBEWBl9Rb8V
X-Proofpoint-GUID: J5PIIBhl1Cp7ddkIdYKEqUBEWBl9Rb8V
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

Updated macb DT binding documentation to reflect the phy-names, phys,
resets, reset-names properties which are now used with ZynqMP GEM
devices, and added a ZynqMP-specific DT example.

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 .../devicetree/bindings/net/cdns,macb.yaml    | 46 +++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/cdns,macb.yaml b/Documentation/devicetree/bindings/net/cdns,macb.yaml
index 8dd06db34169..efc759e052c4 100644
--- a/Documentation/devicetree/bindings/net/cdns,macb.yaml
+++ b/Documentation/devicetree/bindings/net/cdns,macb.yaml
@@ -81,6 +81,25 @@ properties:
 
   phy-handle: true
 
+  phys:
+    maxItems: 1
+
+  phy-names:
+    const: sgmii-phy
+    description:
+      Required with ZynqMP SoC when in SGMII mode.
+      Should reference PS-GTR generic PHY device for this controller
+      instance. See ZynqMP example.
+
+  resets:
+    maxItems: 1
+    description:
+      Recommended with ZynqMP, specify reset control for this
+      controller instance with zynqmp-reset driver.
+
+  reset-names:
+    maxItems: 1
+
   fixed-link: true
 
   iommus:
@@ -157,3 +176,30 @@ examples:
                     reset-gpios = <&pioE 6 1>;
             };
     };
+
+    gem1: ethernet@ff0c0000 {
+            compatible = "cdns,zynqmp-gem", "cdns,gem";
+            interrupt-parent = <&gic>;
+            interrupts = <0 59 4>, <0 59 4>;
+            reg = <0x0 0xff0c0000 0x0 0x1000>;
+            clocks = <&zynqmp_clk LPD_LSBUS>, <&zynqmp_clk GEM1_REF>,
+                     <&zynqmp_clk GEM1_TX>, <&zynqmp_clk GEM1_RX>,
+                     <&zynqmp_clk GEM_TSU>;
+            clock-names = "pclk", "hclk", "tx_clk", "rx_clk", "tsu_clk";
+            #address-cells = <1>;
+            #size-cells = <0>;
+            #stream-id-cells = <1>;
+            iommus = <&smmu 0x875>;
+            power-domains = <&zynqmp_firmware PD_ETH_1>;
+            resets = <&zynqmp_reset ZYNQMP_RESET_GEM1>;
+            reset-names = "gem1_rst";
+            status = "okay";
+            phy-mode = "sgmii";
+            phy-names = "sgmii-phy";
+            phys = <&psgtr 1 PHY_TYPE_SGMII 1 1>;
+            fixed-link {
+                    speed = <1000>;
+                    full-duplex;
+                    pause;
+            };
+    };
-- 
2.31.1

