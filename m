Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49AB649E7BE
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 17:39:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243872AbiA0QjN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 11:39:13 -0500
Received: from mx0c-0054df01.pphosted.com ([67.231.159.91]:16559 "EHLO
        mx0c-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231285AbiA0QjJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 11:39:09 -0500
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20RCPRRc015054;
        Thu, 27 Jan 2022 11:38:43 -0500
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2058.outbound.protection.outlook.com [104.47.60.58])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3duu8kr6pa-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Jan 2022 11:38:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UGhft7FEC4sN/PjV4WJfyFHOw74LpNqzkXacITA9hdZXMK6FYZub5m2fFsP4B/j4Se/1QFBjSm/ucSI6wiDX+4W7qLhCr7GfEPcfZPQSVPMVusK0WGQ4r6jV5wq6YD3u2y3VXuMMkJgZuAV1EDpFhjjA3pCt2TBBIUpQimhJwi55WFubWyeo5aLmUEjWbsDMuKje5Klr4owhWwAbQIeWtD+uwZEULK7wNf510fz9iAsguXGlJJCMraei0x9meDdoSq/krd3c5R1cMu7uAbo3GWOMGqsqSnxqZ0bSqNYAlggtHAun84cgt1UCQWXDRdCiwANL8KWuSdazaaBUsrB9Ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T+snoWjnx+U3hHP+/XXE8GSQF4ZEMPsCCc9+FgISqRk=;
 b=nbxDCX7vJMa8D84zmw3J95PZiKDAiFvZAa7WwS4QqYvTY6m5aJhsdvN6fSZuEe76nyiLN7TO0Zbk1NQ84cvd3pDcs6ek1SOyYI+sfIOT5Sur8GwoXGc0ZMWhuvYC/xJNDOOJe8o8DZ0RMwE6mA7M4y8w5d8k4fGEdTXOKd5xzRja2Sbyssh76zYaNrMK9AEf9+6fsEW9L8eeNJP2QFXzznprqqUlBhAmpimUe3qkMhXl7tKta/819F+Rtx19fO35SNiChMoniHOjQ3r/M1H5pQlK6NgTaoeLRed0LgsZd8TOdvnGdz0X8lhlYoW5lxfEbKxeKw1/+Lfm3NByhHVtyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T+snoWjnx+U3hHP+/XXE8GSQF4ZEMPsCCc9+FgISqRk=;
 b=AuKPQviW75b9Ejhdbll0uqkt1++5ZZXYgUITLSLkMgGUEy0hSRMCqV4tedOPrjyePNAe6LkI5u0RqG26GDpqsmJMJxh2cepvZBz4bEu6SMNy5HeNaC5jcm1ZBq09AmyJzzmdNjAMqU+lWxB1oInFSiXoEZ5yAsoLdWb6eREWbzQ=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by QB1PR01MB2531.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c00:2f::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Thu, 27 Jan
 2022 16:38:41 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8%2]) with mapi id 15.20.4888.020; Thu, 27 Jan 2022
 16:38:41 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        michal.simek@xilinx.com, nicolas.ferre@microchip.com,
        claudiu.beznea@microchip.com, devicetree@vger.kernel.org,
        linux@armlinux.org.uk, laurent.pinchart@ideasonboard.com,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v4 1/3] dt-bindings: net: cdns,macb: added generic PHY and reset mappings for ZynqMP
Date:   Thu, 27 Jan 2022 10:37:34 -0600
Message-Id: <20220127163736.3677478-2-robert.hancock@calian.com>
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
X-MS-Office365-Filtering-Correlation-Id: 7567706b-f6cc-46b1-579d-08d9e1b37a04
X-MS-TrafficTypeDiagnostic: QB1PR01MB2531:EE_
X-Microsoft-Antispam-PRVS: <QB1PR01MB2531A4EA6332E910258E22D8EC219@QB1PR01MB2531.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:2512;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wRcmIFLCl4rb0czC2rjXKy/5YCHMVl0l3ZcLFeWMn16VhF13g7Zw6yGKb6dasRZi2O97aekkCfQFiy0SAJlSyUupTuurmPjj9ikrBji8KHC8ObqaWLiF9drSXjCZrRd36DvJKBMhtGOew0dSdIHSXoZArPXJjY5/yXdEldIBccGiY8BJGWsNWPMsdsX64fT6ECzjBRcrJRGz6v4pm7Sa5hDn1kt5pSutFw13TViuDrU4HSyHm1qyS7t3OKmtpjVQHo3mqg6LRNHddWDKbQLzrmfPqmggR/4Uy9DErI+N+1QK7irva2BcD1A8PyrVjzmC/01EqVg7w30JLvIX9eZr+rT15JYNqGJngeBMFqyszBA9UoS+5yLDB2G2hkTcwxqjd+rMGC0EtXwnyA+yOFQuOX1HdXwTIjxDvYxjih/ge4JLyIJQFTO0EZ7QNpIQEK4l1035J7DXUBUVanw8nWFiE/hakCDKruTFkukv9sWSJGSIykDNfWBLWO1GApqvHv/lM7cF1XxEYZotpnGJIlgiE/0mQuLPn6uGhftF66x/O8SaTze/190NUhG7KFKTsT5ZFjUmkoALDgKpF6gqePYZZb98FO3lk+Sft1i76UaY9I7MfSGm+ITdlP0y2aM9Y/zpucV9bbKMfbXQx91g2QbaQ767Y9MXjWobmUINjhfxbgRObYEovWR5bPeMT0HAeFOu8D6phbPM/IlJadfj8+cuS/nDIxau1uTEinedrXXGGVM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(1076003)(186003)(36756003)(38350700002)(26005)(107886003)(52116002)(6506007)(44832011)(6666004)(2906002)(2616005)(316002)(8676002)(8936002)(4326008)(66556008)(66946007)(508600001)(66476007)(6486002)(6916009)(7416002)(5660300002)(6512007)(86362001)(83380400001)(41533002)(20210929001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6dKOjbzTaNLSE6IrFjl0i8koGPjXFl/wwpTPSx4+Odo7qAXrPeJrY67KGAKI?=
 =?us-ascii?Q?FTb277qbT5Ks5vXgMzvORq4LbPwnaBrX6h0rdxKGMLS9PW1j3B/qUoUuShPK?=
 =?us-ascii?Q?PM12Bk9WJdDSq9RIKaXuxVLu85MJqdtyKS4/zSJQnVPCzAoQVB6eNewcobzB?=
 =?us-ascii?Q?B+kgG+O7cAwIHqsUO6jfWFsMEA96xwylIjzPZfMzYqBLKD+VEXZSgCIUPm96?=
 =?us-ascii?Q?Omo5KsCKTMZtQSRZesloUvlNFzGJrkWOFjeY3/ubIQ1ZfCofCRb8qYvZRLm5?=
 =?us-ascii?Q?Si/DEgJ0oU9FQhbVDtZjX5wA8kakK1FGrbfOX+CifxUHENyYyKs1SnXvCJ6O?=
 =?us-ascii?Q?Wp+oPl28VUULH4SpOemFSukaBT/eNPbvHitsdpqHDa1EONAnoThK5echnewi?=
 =?us-ascii?Q?qSDLZYNNarIe/WG+19IRvzZkZcUMr+8hTSsOPLn9yhRWF1SPMBsPoD6+xni1?=
 =?us-ascii?Q?m7xtKcfQSyEleDX21i5cwj1UORWaqEAoYgW5PlYoFlTC3LTBp4nv26rnqsV0?=
 =?us-ascii?Q?uPD3eOa52Sh4LCiJU4JfJP6J7GWzC2pecSYU7sDN/pf0VCb1CjvFUwsRj7Q8?=
 =?us-ascii?Q?iXTce1G5utussksQH24WcBo3L/9O50AK1wNh+BysJ8vgo+WVmK6R6yJgcspp?=
 =?us-ascii?Q?Hde8RiitXe7ObAtW57tWdGIFl/rmrdjGyYJz3bTf2LYTIKxV8cOMV413hFIm?=
 =?us-ascii?Q?HCwLmgO5/QxZC37Blim7NfvVb9zcxn3aU7MsgkgJ4SRkYxZNEWaBXQ4W0LOh?=
 =?us-ascii?Q?zWCA33MzOTJRi6mTMjvedFo9q9pzAiN+QTtvF0ST0PVSWZ0n6et4VWdVl8Py?=
 =?us-ascii?Q?O2r6lxDhbppv/kkTt8eehimVIVw8Xx5oHAgGjCNH7Fd4Ime6W+IyUfXlBfV/?=
 =?us-ascii?Q?M6jN+rmyXGkjnIR3GAIf1fWjqkSuz0ls4dRscT8bVWg3jIcEmRfoxLprnYYW?=
 =?us-ascii?Q?UBWQ+qC8GIPYBrpGqYYitsJUYRMBhoPnInqD6XdExemdDqXFmPDBLC7XwP6u?=
 =?us-ascii?Q?JLWpBJ6AX5RPyGB+Lbjed/f8LVjkAmpD+5ZrRuviC/eaqHn6bnKTyj76PIEW?=
 =?us-ascii?Q?iWviyLc8AD6KmIZpmSZMAL6c59tcoFaivhclYOgi7GaM/5mM9yXyhImteXvI?=
 =?us-ascii?Q?rQuMM4XF6ugsFKXvBpJy6bHYwLHQqsVEWhgvJhjEOefIFHqzuDa8yXmsFaat?=
 =?us-ascii?Q?MzrG+kOFI0JySZj7d8h7xV5J3N0I+rpj38Kuv4bDZ9/mLLwMWUumFGi1WfFM?=
 =?us-ascii?Q?Ysd8FR7g9sdwf4ifx0x8a3po+4VSicgD3KJA7npst1kmMMGkJ9Xzl8fOmLIK?=
 =?us-ascii?Q?5vkH0TNEjwlUkbaU1M+/JHpH8/EiIPc4Z6vPiglvWimwOI1CRzTp6dbboE+1?=
 =?us-ascii?Q?LAr19k4ZCOEYRHwywRkX5hyPq3pEUdRDW8orTEmbUydFf2X4JfTFdhRCjrGS?=
 =?us-ascii?Q?uOaYmxN6uOB1Mko4gynDN3CUEoXsaDPS2gBRiEPpFzOHkZ6hgzQTDiknEDZy?=
 =?us-ascii?Q?sk7iqVANfyiGenQYXB9iNf2nekTQ3+Oq0Sqwra+LOfp/zmEcPXqHAVzk0LQD?=
 =?us-ascii?Q?X74llofQi5L9TZkDThWTzm1NSJrrj44ZDopnRofOiE5U9UYYO21NmidUF1lW?=
 =?us-ascii?Q?rDWGp9YcM8hCqTHUR1t67V6CH1JOW9B3wCZRtVH4w1UsYuJrnLrE3TdYEso4?=
 =?us-ascii?Q?Hde7zYBktMO6JYh2ZqiiIkGU+9I=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7567706b-f6cc-46b1-579d-08d9e1b37a04
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2022 16:38:41.4011
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OHTN/KwY3ssfC+HAlwr+GdDIwIktMBHNcof6qFc/FcEFEVsep4PE05ba4vPmUJoJqlrfwN/cMhSR/spqvD7kH8rVlkbWamwiyZLQy3Dx/P4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: QB1PR01MB2531
X-Proofpoint-GUID: EYSR4hDtk9fhCgrQAwGNtmiHwLySEMkL
X-Proofpoint-ORIG-GUID: EYSR4hDtk9fhCgrQAwGNtmiHwLySEMkL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-27_03,2022-01-27_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 bulkscore=0 impostorscore=0 phishscore=0 adultscore=0 lowpriorityscore=0
 priorityscore=1501 mlxlogscore=999 malwarescore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201270100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Updated macb DT binding documentation to reflect the phy-names, phys,
resets, reset-names properties which are now used with ZynqMP GEM
devices, and added a ZynqMP-specific DT example.

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 .../devicetree/bindings/net/cdns,macb.yaml    | 56 +++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/cdns,macb.yaml b/Documentation/devicetree/bindings/net/cdns,macb.yaml
index 8dd06db34169..6cd3d853dcba 100644
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
@@ -157,3 +176,40 @@ examples:
                     reset-gpios = <&pioE 6 1>;
             };
     };
+
+  - |
+    #include <dt-bindings/clock/xlnx-zynqmp-clk.h>
+    #include <dt-bindings/power/xlnx-zynqmp-power.h>
+    #include <dt-bindings/reset/xlnx-zynqmp-resets.h>
+    #include <dt-bindings/phy/phy.h>
+
+    bus {
+            #address-cells = <2>;
+            #size-cells = <2>;
+            gem1: ethernet@ff0c0000 {
+                    compatible = "cdns,zynqmp-gem", "cdns,gem";
+                    interrupt-parent = <&gic>;
+                    interrupts = <0 59 4>, <0 59 4>;
+                    reg = <0x0 0xff0c0000 0x0 0x1000>;
+                    clocks = <&zynqmp_clk LPD_LSBUS>, <&zynqmp_clk GEM1_REF>,
+                             <&zynqmp_clk GEM1_TX>, <&zynqmp_clk GEM1_RX>,
+                             <&zynqmp_clk GEM_TSU>;
+                    clock-names = "pclk", "hclk", "tx_clk", "rx_clk", "tsu_clk";
+                    #address-cells = <1>;
+                    #size-cells = <0>;
+                    #stream-id-cells = <1>;
+                    iommus = <&smmu 0x875>;
+                    power-domains = <&zynqmp_firmware PD_ETH_1>;
+                    resets = <&zynqmp_reset ZYNQMP_RESET_GEM1>;
+                    reset-names = "gem1_rst";
+                    status = "okay";
+                    phy-mode = "sgmii";
+                    phy-names = "sgmii-phy";
+                    phys = <&psgtr 1 PHY_TYPE_SGMII 1 1>;
+                    fixed-link {
+                            speed = <1000>;
+                            full-duplex;
+                            pause;
+                    };
+            };
+    };
-- 
2.31.1

