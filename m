Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02E0549B9C8
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 18:10:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240346AbiAYRJI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 12:09:08 -0500
Received: from mx0c-0054df01.pphosted.com ([67.231.159.91]:41070 "EHLO
        mx0c-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240000AbiAYRF7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 12:05:59 -0500
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20PCEDgi028781;
        Tue, 25 Jan 2022 12:05:52 -0500
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2056.outbound.protection.outlook.com [104.47.60.56])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3dsvtr0y1g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jan 2022 12:05:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uf/ZIsGtJkFdAGoe5nKtCMsg1budViqnhmMsCeFbWtYkt0396buzt2LJaOwDpVuffvn4VOQ0BvQihrqqfdjyAHF4nuHTUFOiAAMVLWaMiD9obsGCQOxOSkM5UuIPU75tfi1ayY1rBLvCXPKbkgA8ypFkdZHRcicxYO/+evt9yVR3WaproXQqMdxm+evJKcJW4L1jpFXyj6ZpsEDwka/dujx+vsoJP/fUhd2e4u0F0+SpNch2HBnJgf2cUY1H3dKDEi4WlF23bMpFF/Nh3OLGylFgqlp3FXK3KWgifeDwUSq0Kxwx+vS5no7KG6a2Sey9VYJ8jt/WpVjmn32EmM4yaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aUWfhsPQjTnLOs5qHErSjEB/rY1tDWBve7TPIWAIcH0=;
 b=JJGMTCqu6TAt8hB6BLHHUoLW1ugdImtLh93QYXyVFfq/2ky7EKiazu7TEsyU45NrVghk2nx41VmBSB3n34/PQ9zqk8hvwuX02AfdRJ+gfXMKTXGffrBnS8zhSOb6nYJK9i7uqZGc51ElIIkccV/UJejiEm8y84QBY/r8upwGMLHddjfJudlOpyye+frNhhCIXHB41fVb9d5sbBPKlt/0DGmt/GS+xQcm4AFlswBJX6lsBdzlsYops/BCFpzudQIYR94ZQFXfOJaq3oYafAnOGpe0VdLwp8t88232TbXfXBTzVuC/sapaOi05aoxWdqABcSaOI9rOL9fjpAW3TeuXCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aUWfhsPQjTnLOs5qHErSjEB/rY1tDWBve7TPIWAIcH0=;
 b=k2FQPo/Gsi+/nVek3ezt8K1gNBsdu7UkShy6ljSfgYKpkSJbT7tIPINrVxgHv8QI1kh1QECNaAmkOmtPPsmUB/ceUMy0eRLfHrzjaMeRLIu+0GoiX5E7N65CrmE7++aCn30zojDVkMlMUPWzQBRJRPqheHUXbLiOCPIE1+xukk8=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YTXPR0101MB0880.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b00:9::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.8; Tue, 25 Jan
 2022 17:05:49 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8%2]) with mapi id 15.20.4888.020; Tue, 25 Jan 2022
 17:05:49 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        michal.simek@xilinx.com, nicolas.ferre@microchip.com,
        claudiu.beznea@microchip.com, devicetree@vger.kernel.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v2 3/3] arm64: dts: zynqmp: Added GEM reset definitions
Date:   Tue, 25 Jan 2022 11:05:33 -0600
Message-Id: <20220125170533.256468-4-robert.hancock@calian.com>
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
X-MS-Office365-Filtering-Correlation-Id: a8591f51-e885-4caa-a00e-08d9e024ef9e
X-MS-TrafficTypeDiagnostic: YTXPR0101MB0880:EE_
X-Microsoft-Antispam-PRVS: <YTXPR0101MB08809AC15A9E1E5CF178959DEC5F9@YTXPR0101MB0880.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fc2oYLBy60QGWyYb0154jK0TfiE7JZmf/a93MBjgYsaR2dJWcjkba2iSD1ohA/etLZDRt04qMG2dTpeXksCBOr/HzfMwOOTr5J2Kn+LwEr/GvSbRh0uOpzjnTFlOIw0Ocr0zJA/LWj6k4DQjT2o9xpwakZjh30Mx4lNkpPowbkhJyD+33YXVhFhmTQWk72TqwRxFYWfJT0LFbHQlx3v1qg3lhZlocoqCS7gKLWHIYfa9Mp04zqB4FTZWy0lyBmooCuHwaSTcKDDCeT/AguQt5srMzTuarMkHVic1Z40+8Jc6PF8jlQNTDyPB544K7aHpvuBtYvZwODvMlZgeaya6CzOJyTd6ru2CTLk8rlj73+TewalgCAowvSvEkP0/9m23Qd0cg3ICHStFJOXtN/+eUkVyUtd/W/HxBWtCxQvNC1OZs9L5vS6V78D6XaUAZiBL+cKS1aba6YVuDJWLweUvX8K2GI2QYAxAzd6EunkTk2oViVqyxDyMMOZD7RpMR4rgOFKDFXgiQExx9JllEI53SZvjqvQmwVdBs5PWiAg4R5p9161z6X/dPid+xbIe/Hrn4ZUZ3CKFsp8HGmPWpoS56pW7KUNn5tQX6sr10kdL0bDvfU/WmBA65FS4StMnl0wXwD6cJwY1lnBMapI9awjvg//rXWzaRdsZuMBMzruqMLpFHe2svddLFCVLFytEf5/wKaIfiWksIXsWFX+hQjV4Ng==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(86362001)(66556008)(508600001)(66476007)(66946007)(44832011)(6666004)(4326008)(38350700002)(1076003)(2616005)(316002)(36756003)(2906002)(8676002)(38100700002)(6506007)(186003)(26005)(6486002)(6916009)(107886003)(6512007)(5660300002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HE3pPoA41zqP1kVS1RocISdc0Sj+x+1xZZibbKY342FudF+qoW9o927tKRay?=
 =?us-ascii?Q?TGZtRL7ctagTpoZEGxu2CIJ2D43SPsLNuD2Yi0rlMdLiQ35IgN8RgjgxpjPW?=
 =?us-ascii?Q?v4wFKnDg6eDZ5xZs/La6JD/plYvzgeajlPIAyPiUKXhfjLyBdGp9GvaZW2Z6?=
 =?us-ascii?Q?RRUp56CVHVmsIZCjK42wv/Bw9vMq6kILYy1fRLgwt7CXjzPysMtzeHQSlHBt?=
 =?us-ascii?Q?UR6dB1buOI/rEjuG/pCpXgEp2exibci0dJwixHjFBcdeUgWxkPiNeW97Bmbk?=
 =?us-ascii?Q?2T2+z+HjrofllI3rqLCUKptSS2K71GdI1lB8aVvBEBkZp0FyGq25RRZxvqIJ?=
 =?us-ascii?Q?yLYAkmfaPlMHZ9qSSSBqCTrQb3pwakb6skg9TVsXhg9R5mvI2IjTdUCju0eR?=
 =?us-ascii?Q?3kn0DXixgI73852t2Otk8n4+87934/AHJek9Hd336K0m/MVRgns+8gIhqZnY?=
 =?us-ascii?Q?CCTWMnurbwyN8KyHhZQdRsgwKqK4OOwupppz5XLbmrMBpZQSGlLeWixxRCdj?=
 =?us-ascii?Q?Z9smEb+KpnYp1T8YpXtOr7s1lMKB2+iV/kkM+QeGCcv8Ug3bZPrO/6BMtNLk?=
 =?us-ascii?Q?vij99QOf9FFQPRz9KQZqKbHunV/IpNDjkt1mMyOz9C8lK7Z1tTAU9+6ZhcqK?=
 =?us-ascii?Q?WZuw90FTqQIMBDA7o0Y0vPL4BizTnW4zI1NLuytFwARujnKwOtRs+aC9ecks?=
 =?us-ascii?Q?EtDSewQ6tEW0GwdCzJSaBPhEhID28flbdBeMyO8XHD+pxDd7q4iO+j9yCyKg?=
 =?us-ascii?Q?Bmt0rqigNPSFHo6527tZR5izPTlSTZL4E5c5KWwnZsOuJU4Nbq4fuDBtYfnR?=
 =?us-ascii?Q?XOYw/UfxffISJ4S6Xv9jsNMoXTJssuNq5FU5la/nHdF9adHh0u1qcZqefC2O?=
 =?us-ascii?Q?3xvGP+mfXw+QEdRw4JybHCW/oElWBTk3rsGADMiGjwXEgbp+cWT8GWiPj3PM?=
 =?us-ascii?Q?5sfdcv8IXN72Feq40jSFP5G31nPmrrAYcaENxYe3srTU+kBNiv0uxkCWTsQY?=
 =?us-ascii?Q?Ctz4qJMNR+bRxDz9AWqNQvvUCkbEEtkBb6n9jHotuoanWP+pqTzejCB6Le0k?=
 =?us-ascii?Q?CxJ2/74fDjGaHb7Kdz4E4RRdAl32tS9dvHiYa8Zn2jbC4QDjk9kpZw5KpVz3?=
 =?us-ascii?Q?0yutWsELNxYc2J9BpGBxBfiBFqgdil4wiRD5X3XaTe+HPoq9LS6lCS4Aw3L1?=
 =?us-ascii?Q?ks+Ph4efAOlC2oUdaWA6XOY28AnjqAbpzBcjRUnQsZG0Ta0WLb9hbuRlBFoK?=
 =?us-ascii?Q?D69au9rU9nRhTTm7qUredx2AAU4FlVF8E2IjxQ1GcSd2Nl19++daedZHbVoA?=
 =?us-ascii?Q?PphKBT+/Zq5lgQ/IDNdXMEAFyf0z68VqUOov/DIAxKeObEOlnR9sHGZqRtna?=
 =?us-ascii?Q?2I8VSFSntCj6++SWAKy+StX1Ve1LF4MsivKobBrlQjptk+Dh6dDWX8SQtlgC?=
 =?us-ascii?Q?66ilaIlylXIGw2BHoDe+KQOZlUZmS5HYzAhrWenllkjpGC1UCAFFfI9OvZSv?=
 =?us-ascii?Q?igJSCuMOrL8TFYyTzymGhqtCvA+LSEmMXfU9vdscVAMdSf4VM5zBpGUeaDm0?=
 =?us-ascii?Q?1R2BpsPQO2Zdp68pbBvBIo60t/VeUC5Gped0HnfU0kI/Vtx6JvbZ/YhJErzl?=
 =?us-ascii?Q?XwN+88AZQzMeNfLwYxaJUZs3Ar0YaWpoIYGSE+b0yul+7FlkhZIzxWYZN4Fr?=
 =?us-ascii?Q?Y4kKewGRg3qw21tROrX9vwSjDl8=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8591f51-e885-4caa-a00e-08d9e024ef9e
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2022 17:05:49.4480
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YJY/wBmizaH1PqSGekOJVR88mXiMhwu6TbtSbnokuv7Gwhw7Giq36/Cmw01XQznOoJAenrRLKipQ1xAS9SwjXD1wDo+BmFT6ezvIFBwb/Cw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YTXPR0101MB0880
X-Proofpoint-ORIG-GUID: lR9x-5hZCa3K2kshbj8nW_wGw3Bn2QKy
X-Proofpoint-GUID: lR9x-5hZCa3K2kshbj8nW_wGw3Bn2QKy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-25_03,2022-01-25_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 clxscore=1015 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=924
 suspectscore=0 phishscore=0 impostorscore=0 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201250106
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

