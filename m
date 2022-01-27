Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09A8649D6B1
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 01:27:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233864AbiA0A1z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 19:27:55 -0500
Received: from mx0d-0054df01.pphosted.com ([67.231.150.19]:60981 "EHLO
        mx0d-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229609AbiA0A1z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 19:27:55 -0500
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20QK9ps8002638;
        Wed, 26 Jan 2022 19:27:48 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2059.outbound.protection.outlook.com [104.47.61.59])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3dud3cr3qe-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Jan 2022 19:27:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JOXMsAvUGFKEn1PnSUULwng2RR/GM7rQsNvGRkAqEGTLY87mW4KyOVrmBHVzSq0FE6KxgHjbLWJ+rmQjiv6ir3qMh8ySJVr6nhGODMEEUvhhTi1W53sY+qqZl9/+LxXWGvn0r8kuh75WiyNbcOEyGm+QMnDzvcz3GFwXocNoJKn/biQNG2oqAvMux0RmoiSOvNC6CG+QazN83wm8GwEz4OglrWvH/bl8Fo1zWrZU6tgKLOQK3cV+hhndWdjf84EO125lqLv20Msn+z1HTFkDGOcQlJSEgl2S+dfTwzNreXsqXOBl6lmS663bUJEDnn6cayT7Ucoi0smams9dW7W7yQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aUWfhsPQjTnLOs5qHErSjEB/rY1tDWBve7TPIWAIcH0=;
 b=kT6KreBYWofIiLBXaQeYl2C5MFZgkbxNrp1ZvmOyBP6O6J+j75vSeMFnP+1rHlHZ0qP5kyPfOWZ3+LCCAVnzSJl/Dn/RIL/Z2PrzJQAIqyhRX+wib04QKcivIYeNICgK2VRtU6xSWVF7EUTMyPLWJhTHKUCyzv1XeX6RfStyNWZw4uEB5n1+JUzJdthLQSvlxuIFdwcLGv0oDSk6o+Ksl7wFS6NyvjecvyJxB6+kM74RY1MZkUCrefFLxN/P1bHRenoVHyeMnk+KyDqnjJ8rMFpr8N0e8M5pnMEz4MABJRuk5TATV7ir8eQuGRzZImWRWuWrEN9s7M1pdU5t3ROCcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aUWfhsPQjTnLOs5qHErSjEB/rY1tDWBve7TPIWAIcH0=;
 b=jzZql9nZEbBv2EuRBOGewVyonHfaJ3irV7wo2g7V6+SyC4QA55CZNEzLDLckLT2GjMh4HfDiOz/AvuO/nSk8K2BC2an8RdSdBcWMP+luliP8m6UEv01ixyRFsLWa6roKgeGV7x2ywRnjylwlNksvIhBNQ+A7f0gDinPtjJxD71Y=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YQXPR01MB5578.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01:2f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.17; Thu, 27 Jan
 2022 00:27:46 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8%2]) with mapi id 15.20.4888.020; Thu, 27 Jan 2022
 00:27:46 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        michal.simek@xilinx.com, nicolas.ferre@microchip.com,
        claudiu.beznea@microchip.com, devicetree@vger.kernel.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v3 3/3] arm64: dts: zynqmp: Added GEM reset definitions
Date:   Wed, 26 Jan 2022 18:27:11 -0600
Message-Id: <20220127002711.3632101-4-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220127002711.3632101-1-robert.hancock@calian.com>
References: <20220127002711.3632101-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT3PR01CA0038.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:82::9) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:6a::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 01b734b1-0cf6-472e-aa87-08d9e12bd780
X-MS-TrafficTypeDiagnostic: YQXPR01MB5578:EE_
X-Microsoft-Antispam-PRVS: <YQXPR01MB557882C74AC2542F03A9C920EC219@YQXPR01MB5578.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PvIyRc4j8gTF4ECNcwaJya1seuoWUheBJAKSKB/ZJElq5+xu2nQxT3Dm/iiqiWPc5XXjkEAlhHOPgM/Q1TcnW4apO6rYf+egrscynCrbvjXDNea1IW9zGHawd/ecKn+nH6EnIM/SAvCOFaDSLA4kWdlSvDw0o2lUHHs/HjrzdVDaafdLHABlxLb3lNrB/N61JsC+o9xB3gukLxCYsfsUk5aY3FeWsUDDVJjcbK5MtFBocN/IA7yyDp3Z3GesRP+W5k9J535YdVS2yyt/J8q12aJJWgKgdW97L6WBw8kA1oZNXWlRTsqK7j0cVAbil5t+ZeowZxkpY/3C4K3g/vkFYI8TfGT4Qm7/xMvjWIksQIwOMOljiGiL2068yQGkP4i7OFIQFCToqrW+Z7HLLMJ+Xgog3EVrQR03VVWUKPxsEueMjBHVRi6edmtveO+qDXYvE83tKKfZJVmyrRfQlV472VV5ENS0VMZ4K7Yv3BvxAh9GPOVb0ksAoiVPWuXB1Jy2T2WKJ022WWHOoc91nLeYm8qT81AQ+AYSpC968v1OYrcql3d1T23I1aJsIo+Ofd1FuSaap+NWNxIMBQtGENyU1nwbLNflvH3uehix7WjYJ81qTc8zlmm1GYvciQc3pi0dY+8cEoAUxkffOnc/lShyPs4hdj/9XLBxEpUmOOXBGJFmm/9qwEiBlj7zocdfAGSUoeA9mJkZ7MtEO+KQ+9rarw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(38350700002)(107886003)(66556008)(8676002)(66476007)(38100700002)(66946007)(4326008)(508600001)(6506007)(44832011)(2616005)(52116002)(26005)(186003)(86362001)(2906002)(8936002)(6512007)(36756003)(1076003)(6486002)(6916009)(316002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?M1Se3KtMDfIYJS6Ts7cvY8+1oblB/tLZCX9q3eJmo/Ha+QHsemoAqMejbagf?=
 =?us-ascii?Q?LbR58shwPOKUpVDPzjxTbV68oeURu+278qaq2x16Jx+XFkGncnpMqovL0Ssn?=
 =?us-ascii?Q?gK8i6XpHHnm+ox2arj250BspaAWpkQsOFsZdFKADziPSZgWdThk0EVKVY7E4?=
 =?us-ascii?Q?0S/qkaDn7rmbw5xjsSRhDoMbn9qn/fjRl9IMT0WD8bc/eTYDmRf7xB7he6WI?=
 =?us-ascii?Q?/fYp8+09SWX/HQoZOGG/dZCj8KiFFHq/tFrMbWI82DP5RO9AppRwgfW2W357?=
 =?us-ascii?Q?UZu5zdvayvo8Mea2BsFc7BsY/isZ2IO66dslEL9CdsIUuexz7h7VEMzk09x5?=
 =?us-ascii?Q?gorsVcxbSAAkZFH6in56tM9qMmZffdBtRF+OkFl35bFRBCyLURiVKmAFy+48?=
 =?us-ascii?Q?2J4XtjsdPKKmBP0SN80Ao8YOSD+sQoNF1Ela+U7HHrvScpE8Jtb/0pZLjmey?=
 =?us-ascii?Q?UXQctRyeQrsmjAml6u3j/9OiP/XrB7hLZNkoVtaOHuW+ezWjImNvCH0G+QML?=
 =?us-ascii?Q?Sjn3jfUqsE9s+KO3EvTO5JPAWJVTsfdYb4q3gRAft+T1KWRk8GMBBbVaYVBO?=
 =?us-ascii?Q?gLHwilrgtBUCd8O/OhRL3RADLsulvTduMxQ8BUJ6HgcaxHnCkOMHJ6IDKaXm?=
 =?us-ascii?Q?s3AeYz9IqqEZ17bRSpkY4V5kQ0R70uK5N8nXa5J4hrMFCfiSlw3zS0j13Tmm?=
 =?us-ascii?Q?+3J81ZcrLH4KO/rZDMhGiSjtSzEyevV2R5zleKont1z/RuL5PCJCXx1rUm4y?=
 =?us-ascii?Q?R5MIdj4BA0BwoWgY+VNYtftilcbopXQ2OLA/JJiNXpa4yw8VJIVgckx+lIbH?=
 =?us-ascii?Q?Uvysq9vLLzW+dsuzwca/OIDeOe/y84M6tnELcbMCACEPlTezBNFQ7q28Q+o9?=
 =?us-ascii?Q?JVtXlEwhoIfaivo76GXAv5W9pprz65q8/+Jd7WlcmOwZmc98D18awBCrNFTx?=
 =?us-ascii?Q?B0cm1+v6pHFuNX3iAqj2lF9uAtrWAWj74RYqi+Xk8YLa5WldslOqHJghHUQu?=
 =?us-ascii?Q?AeaJRI7SKWN9yzkgHK5Muqt9aQ2I8EOr4eIcOqeaUr2FiGETLog05G56id8H?=
 =?us-ascii?Q?ge6jmMI8j7py0XRijTDY/9oDovTR9+/ZfNpygRDfXP8jajKRnvAyWyFHAXqI?=
 =?us-ascii?Q?2smu6tjNYxb+d4dw41hm0gvCGKSnOgdTGeRLDBVg3zB0NwRX/4zuX1PrfN4z?=
 =?us-ascii?Q?j+obqE3NmGN37TikLe99I4scDmj/MWqs7OTCOmTMFuenHGbuxQ1f7+ieN1VP?=
 =?us-ascii?Q?VpErLKuGFyf7alSMecdSCRQk+NS9jsx0M2hnDzsNJvYaWCjHLlWdO8dVRRPv?=
 =?us-ascii?Q?3xAxDhTBAbncFUetp9wssnv7Qy/0XruFZNuqf3I263s6wGffZIzbb1JBnPMa?=
 =?us-ascii?Q?fCAv3ISCH5VuDA2HgYdlvGb0clRGVNDi3hHWcU1EifdXpOwdSMvYwEAzmWHM?=
 =?us-ascii?Q?8tuaQLvqHKpjxQ4IIH4yCVZHg0z4GB83sIEfOZjP9PqeqzoMFyRiza+pHP49?=
 =?us-ascii?Q?PacSPMk6az7o7dknsXpffESBSJUeOrcFyrvHAkRFgmexZg5j2YVHPejT1C4l?=
 =?us-ascii?Q?CEAsDR3MweTjMOgLnVZDBlh7o3FnyvsSUXRJC1PGExWORCgdPC+yDY6R5xY3?=
 =?us-ascii?Q?uv9FWgFe3JfjG2bAnPLd4NPAi5HHSsltPXGEoGr9U8v/4Bano9PYedzmDbt4?=
 =?us-ascii?Q?5SDTDyrGN+y0S6QGDuae3v83qkg=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01b734b1-0cf6-472e-aa87-08d9e12bd780
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2022 00:27:46.6276
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /rhKHvX2dFeUq+HcGQJvOi4gfrxjSZ75fTllBNTw5nqXHSW3Xaqb/fMUxPQIiiYR0h0eQeGOKEmBRiQyloM7OHrG8psB22Q/OebneHntPLc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQXPR01MB5578
X-Proofpoint-ORIG-GUID: KuTMpXHioz8JvpZtOH8AXZuc6Hid1ApP
X-Proofpoint-GUID: KuTMpXHioz8JvpZtOH8AXZuc6Hid1ApP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-26_09,2022-01-26_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 malwarescore=0
 bulkscore=0 mlxlogscore=926 spamscore=0 lowpriorityscore=0 clxscore=1015
 mlxscore=0 impostorscore=0 phishscore=0 suspectscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201270000
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

