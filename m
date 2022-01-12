Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B676848CAC2
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 19:13:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356126AbiALSNb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 13:13:31 -0500
Received: from mx0d-0054df01.pphosted.com ([67.231.150.19]:14763 "EHLO
        mx0d-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1356105AbiALSNK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 13:13:10 -0500
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20CGT5OQ010873;
        Wed, 12 Jan 2022 13:13:00 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2059.outbound.protection.outlook.com [104.47.61.59])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3dj2j2g20t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jan 2022 13:13:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wi5PvUP1ssoLgmBiD2mA3AdMo4Iny6dXcAchsgEg5tkWazeVLuWN4MA9CO7UXYK9kw0nky/Cdl6wsAz+0jzUGBcHVrKeR+WqJjHYf6o0wSR1i/A5QsfRr4A41xn4iRlORa1MjaGcSpy9yaAa58S9+F6MNGfOM6/ZNr7tbrJW/xg9WRvY2fEZWlAIRiRCnvcb2F/SFT1AwtXPhHFXB/849FOpNuILE1CgzO9Wne4M7JJKRJUquyuKhE1lo5nQ0YNCPBQbqQRFCu0bFzynLiMwC4YHLmJJXvW9ZgV644CETPEBItLn1U3hEVv59YTfyLTiag1CtVRZpanAW71BwPLdnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aUWfhsPQjTnLOs5qHErSjEB/rY1tDWBve7TPIWAIcH0=;
 b=l/U4/UTZJ6HrHVpdQkexZsdsuCkT71Cq+L5nbZTCA1byt0D+6g1OgbHTYl7yqZslsImPzLTAUy8MIJ0nPCuPk4MdX9M8a4IvJOeaMiMCndbj68y8bKjSEfqBdpgftW2z99W6NXqhpbHLBBSK4lkh2eju2SGa1o9aPiIcFE3tsmnwa16Dilvnc6LU0nICEiNNEae0kI5ZfCwZuZMsneRLmg4rqGED/SpcRjr89kOC75HJ1wUDFKl1JbffQNB7MA28grWV/GegDKVui26Cza6RZRCGBq1kTX+Wi8Hh9fXcsx2/vkfw+9YA2kwDGK/LusV3E6P5G9PWSHCpph/mEp+BJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aUWfhsPQjTnLOs5qHErSjEB/rY1tDWBve7TPIWAIcH0=;
 b=U8inMWtynlcFpC3wvv6Ab4FMsiaTjWxiUF3PK4I9TCxmAm3Bfe7Tz7TxslWhpeqkDUav6iDYbBGkrd34xHJh2VZ7uRUd6+/Cvlkmm/aIqs5lrJT4YLfyIqExHrq2M2MD0RYuGUrkewSOMTG8PXH98PHrENkEgodyUoqBnX3Ohl8=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YT1PR01MB3516.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Wed, 12 Jan
 2022 18:12:59 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8%2]) with mapi id 15.20.4888.010; Wed, 12 Jan 2022
 18:12:59 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        michal.simek@xilinx.com, nicolas.ferre@microchip.com,
        claudiu.beznea@microchip.com, devicetree@vger.kernel.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next 3/3] arm64: dts: zynqmp: Added GEM reset definitions
Date:   Wed, 12 Jan 2022 12:11:13 -0600
Message-Id: <20220112181113.875567-4-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220112181113.875567-1-robert.hancock@calian.com>
References: <20220112181113.875567-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CO2PR05CA0092.namprd05.prod.outlook.com
 (2603:10b6:104:1::18) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:6a::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 07acaa93-148a-4a86-e2f4-08d9d5f72a34
X-MS-TrafficTypeDiagnostic: YT1PR01MB3516:EE_
X-Microsoft-Antispam-PRVS: <YT1PR01MB35169B4E54BD388B35C3CD8CEC529@YT1PR01MB3516.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rt2L9fMu2qNfC1f6Pe6K0SZR8LncO9bvK39E+qL+R1+Z1ngGcmdZ+r6TfUTJcApI1/psdOUK8nD6uEaetF2ljY6d+z0GWuERIYHMacW5X+YvGH52ZXl1gb1Iyyu0KBorG9oW4/8PIMMWpNsHyFCgE53upPzD6Fk+AwN+GEpbPQOh2Qb77Ta5mk1pgycRlng1vh4mPAXcz8I3Fk3xF97UWgsISGIFiO42nNbZEbCx8Zl/7pcgeZ7Xakzcg0+7ei+j2sI0YPg0QOMrWNhKpz4bmzGqDymQrmhnOGYQYbzfT8cYxb8hzTWJnkUDy+RXqIO/QWwk3gwARN2R/lkOIdIKBt3HRpoSTviZ7yowoJ6K4ozqU6eX/k66P6pikYagv3azCobc9/4VdYInud4EHReblTe7XShGuEx0ESpfMotbKmVUDfVos19qyN1Vho5UU0hiVRWu2KyNPjtdhNSUli1PYsKUIwh4WfM9f4haQzyWecJ8zhJsAVxJW6rzF1S8zgUSoBQxFUe3RKIduQIKgL1M6RB3XlwdB+k8TKBeksjZQuN0L4DPjV6Mx+FLk1xzWZfcdA5V9pIuD52M5EgAeOtndKQ7RJRaydzn9ashX0X+a/Z6spqe+Lf8MalQo05s6AI7d1mSCiyjThZwfN/nvhs80o8f+k3++SP5f/TY7XXDDMyEZCZTOOHG/6qNNXXX0HuBLHqKczy1ys2foGWhLfEbyA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(44832011)(186003)(8936002)(38350700002)(6512007)(38100700002)(8676002)(66946007)(4326008)(2906002)(2616005)(107886003)(26005)(6916009)(508600001)(1076003)(86362001)(5660300002)(66556008)(66476007)(52116002)(36756003)(6506007)(6486002)(316002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3u2hddYXvY9f8zJkNkM4cLyMK9ZcbAVYYQJvzLLqRfrK64xvZLe6smOrorqI?=
 =?us-ascii?Q?k520n6n3FhKeBjIpy4IQmRYey5fpo4lCI8Skr9SfVDAjDklVAo4HW1+iv3TH?=
 =?us-ascii?Q?16Eu1kkHccbPbxwZHCp6bSmAorK1OU9SIhYmM7l5bIxxpgvlt34Z3CrNMlbq?=
 =?us-ascii?Q?LWWRTjkJKBJ7jnIwJYKaMzNpdw/LmE4lCTRDTS3uG1Lbv8ZQzpdnuqKBRbfV?=
 =?us-ascii?Q?NfpPbv0KgMIMS65d7uID+xQ44QchOZc4p4bZLiWxIRU0mAQ2uAJUfVuOXGhr?=
 =?us-ascii?Q?Tvr/OukiFoBhbi0keov/ZiLrWjDdshYgQEkCBrBWiNfsC0aLW050ttHSxx2I?=
 =?us-ascii?Q?gbGE0WKk70HezxafbwjilH50KliaNv3ECNRDKgpSFELI0YzQVKlzRLViVa2/?=
 =?us-ascii?Q?KazXCN9+trFEYeW+Wu5ymJRGJs3myRV9DNnmiRS3rn91SI71lyn1YD45an5d?=
 =?us-ascii?Q?1tcbrbUZvH8EQYYHW/6AeTWgXrqQ2b0/rBkeEVQLCzwNcbgoBo1JUFR6Wx2z?=
 =?us-ascii?Q?qa6K0p1RGHScKbhbcLhCgUKmcHRDhDiJCswUxnFAtCTY4gxC/vLUv94J4E8s?=
 =?us-ascii?Q?0B+yo0tIWeA7Olowf4QndPJMbCYYHgAgY5tFD02YAj9jH4D1GUTvsRm8Qu1c?=
 =?us-ascii?Q?Ws4YxBJpaEpU9b0wVC3cQYPSf4cQyeGB8Wx5yacddxbsWv4nJ2dOpOO8kVj3?=
 =?us-ascii?Q?Qxzggq4LDfoXS5S6nsfqtWW02xLz3u/V0mSQWkjogJqSkXKAzgQd8uYfBPSi?=
 =?us-ascii?Q?rlRYZgvAxChFHYGRQYGGOerFSOpTTu6JMmimgVhGLQxRwcZzXoV9Q/hz/lbG?=
 =?us-ascii?Q?bBw/+O8m6e3vYXH31WdeAx0ojpCdn/V4h0WDWFEv9pR0I0A05WcStxskPWXp?=
 =?us-ascii?Q?UO6dCVRs0sY9zk+yrT4QNty0WRh4+J52ai8Fm8HABD1lkdpQTeKOXm0iNyiC?=
 =?us-ascii?Q?yzOCtJ/r1VLG+unnIAfiXEiEVoF5mcAp7rKGHN9PONNXP5bHFvvmcp96DN61?=
 =?us-ascii?Q?uvEjjM0Pr1W/8sIsJoHVRzMt9wvZAfzxi52Zc6PKWbl8L5ISWnp8390vJtnt?=
 =?us-ascii?Q?S1+GVC+8YxFC3chBBU81QTR4fL9dyslrF5GczPXp/T+CRWbGdmM1LWkmyTCf?=
 =?us-ascii?Q?QlxJJDp733oAbGWHLRO7VrIkg7Y5hmEDI40cVjmHvD9nw1hSfGmaEuG6O6ky?=
 =?us-ascii?Q?/bKKHZMhhvenTwy4XzvOQYJAZUyBKdPZjyjyZvYVzE2tbw3KyLKv+Jqb2TeB?=
 =?us-ascii?Q?Pwb0WaMvDO7OsReohD/Q2nHSXtERGGoVz9R3A9LEFbl0iM9EqdMgmQu5dqwK?=
 =?us-ascii?Q?MhS6+xCGIf6CskvpYvqM9DDWy6r/B63kksiK0+P69nqhrtckYazKcOz1M4AV?=
 =?us-ascii?Q?zAp1y6YD+KXXYRoM/c9vOxM3Cy9y4demM4JU79zVe3/p1AKttTrSVjcIaPHq?=
 =?us-ascii?Q?2Y1W+VjAQB84Z8EvBzPFqwhZHwtoS5ahxgD2iFJuCBM74DTu8G4ThZp6Enwm?=
 =?us-ascii?Q?lDgeHKmYXPk5sCfGIfwom7qqJpBEhRujVNfH9pazDvMkR/XhDP5UQI6/XRbQ?=
 =?us-ascii?Q?Nb8Uo9luRmN11YtAZ80HFZlPgHs7hJYmNbY2ArxGTg4f0xumwyoFwZl3T8jI?=
 =?us-ascii?Q?s7t1zbUtwbggRo55Yyew5oeNoO2qaNY9JH9Jq9nK8iq1J5MjLc7jwAr2v6cY?=
 =?us-ascii?Q?ttXB2JQZWUmpg2ce4w4TO4Sra4w=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07acaa93-148a-4a86-e2f4-08d9d5f72a34
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2022 18:12:59.3570
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zDqopRhTd2pBWp94tLybDLYJlWkiWYVhj4XQMoYWNc+zD7KCmwATnRzdZX/hS1Gs2l+kr93kIjzmNBteT+MRXXh8phhNXvqJjIeJEpnumSk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT1PR01MB3516
X-Proofpoint-GUID: YCINyspN1wIQDw4yB4CHITNqQyg3584Y
X-Proofpoint-ORIG-GUID: YCINyspN1wIQDw4yB4CHITNqQyg3584Y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-12_05,2022-01-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 malwarescore=0 bulkscore=0 priorityscore=1501 mlxlogscore=960
 lowpriorityscore=0 spamscore=0 phishscore=0 adultscore=0 suspectscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201120110
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

