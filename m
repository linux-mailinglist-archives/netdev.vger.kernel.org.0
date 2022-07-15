Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35CC55769AB
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 00:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232336AbiGOWHS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 18:07:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231926AbiGOWFz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 18:05:55 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2079.outbound.protection.outlook.com [40.107.20.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF1168EEE5;
        Fri, 15 Jul 2022 15:02:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=da36a3ySCNB62DfBOEziOCQ6i4+AXiKG6I5knQNCokX7IjGZ2D8dlecJceT7+0PbmMoCQ7GQlgKhsxrVwA/5lnhO+WsJvJ4fX6NHArEq9kalFYCXr0tfBugrlzQSswhzLYx7kUFyYp+LdfUfASGoBN3K3KFkmQHJkA4joVn7MOXNF4GfSY//yAIxP9JiJRkqebRqljNPASATFvX6y2ksfOvWt7YxGvWqvs5W5E2xFlk8pQ/4s4x8+0/v9EL2JMlF9i24jUwTdOUgiiZ5len9yHUjeMF8IbCqpiUi6Jmxw9/0qvuWucc0P1zAxVbrZdAAU69oth/Y1skaLiXTWHkmDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8AtSHc+YTXvYBTpaB1x2mjz6YwHiaiESxiffu5dhh4o=;
 b=N/zuM+RQHqvbPSrNr47P4Pdet4zR3kaeLDwgC7aToc8Wm9J+D2d2/yvqtbTlVGSAT829IU8lBYX/dQ9SRRVHL26lqScnL7K2EeneRhM5Khz7z59g61U/E6OokxLPF93K5S820DcQZvz//m1b+ru+Rz+DWtQK+rPe9c7D36WgWbLJUlF+wyfcLBSjdZe/2ahFD8D9glvpAOTouEbBGuR9Deqiyy1p1O2H7YXqrHFO/Js4dNbL5h2qYbQjc5QcR2hvRit6RQsRbz9+/wh7xAfsmBFnmRMZ+54FzJe1/ZOBci9CQ+dDpnySVV2yuowRPVagQA/nIIPjvpRv8+A3mkfYzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8AtSHc+YTXvYBTpaB1x2mjz6YwHiaiESxiffu5dhh4o=;
 b=ev4jfKWqBeXJJXve3LBPInvmcOTLTJPUoxSwUVnorZTqAAOfKFJvRhDama8lZvsMn2IbBDJml0cBw3h2rJQU/M4ItaPSJAOvSPShpL4NdZFI/Pt6+Tk+5woBe1tN0ulXwq9tU9nZ6d4QG76LvhDn3fn/JBlYmn/ohXwU4Zcd4KjkGkFDK9g14gXaag0t2QE49Vj9w7WPzOgI/RWhMcNF9tL6PCkNCo8fsMxZzloz99bR1X+Cp1OfsQUnFDzudBmKpB8Og8X4zpBuTCKbfQDbBojIfFeDecdS8qIYIKZ26q8xuTJxW8RDity/i6bK0ZHtZD6f++RwW5lAtOwRNshABw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com (2603:10a6:803:c5::12)
 by HE1PR03MB2857.eurprd03.prod.outlook.com (2603:10a6:7:5f::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.26; Fri, 15 Jul
 2022 22:01:48 +0000
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558]) by VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558%7]) with mapi id 15.20.5438.015; Fri, 15 Jul 2022
 22:01:48 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org,
        Sean Anderson <sean.anderson@seco.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Li Yang <leoyang.li@nxp.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>, devicetree@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH net-next v3 42/47] powerpc: dts: qoriq: Add nodes for QSGMII PCSs
Date:   Fri, 15 Jul 2022 17:59:49 -0400
Message-Id: <20220715215954.1449214-43-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220715215954.1449214-1-sean.anderson@seco.com>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR10CA0009.namprd10.prod.outlook.com
 (2603:10b6:610:4c::19) To VI1PR03MB4973.eurprd03.prod.outlook.com
 (2603:10a6:803:c5::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b5e59f55-4478-4918-5501-08da66ad9da5
X-MS-TrafficTypeDiagnostic: HE1PR03MB2857:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GlRgD3gfjb6PcOadO2SeyzSMsREX2HfbzWaKb3XVWLhZfkQLIESZm2eUv2DqBcXyG6CYPGimCJ2UToG8ha3eT1m10Cv1gbMrjt+XKUdfQ2INLr6ZziwHZ1m2u2Nx78HxVIKh4IYpZFwHR3dE/liTNmyfwkG9GG9nrvCjdhzFh3SZUmmxjXyeWEhoAlxJ60WZTgPl5pnYz9ovnoS01yIYWwWGny9eOii2U52tO3BRRQGHJz7Q1cfjrpZYFcnSWcH5g6W53SJejh8p9uXT/gnaXScSS4pN2sF3F47E2mw4jV637WXDz3ACuGqb7AP8DncPwcE0NTVK0g+5ooRWQR2JA1YKqa0OmS3GovyGKv1J5JRzMc8x93aeoRHXRaJ+f2gIEhNYmc9hs5r/t9jb8QB7Zn82/GTJHtHV4aRBGZcFLmybXk2LSZl3KwUVWPtKNrvWnBFCl/hpnk1IgPrz/4zgodbfWhAXZsn2aCz96EhlLJTT8rCKIbHg3XQTXDfCv3UjEqZ9mqSckveY45U0SO13LwtVbShXLiJ2JqqYpFT4HPmwsuKqCoLuuWthjXyRWjpfFLHNWPA+udg4P651v02wBFaFX9jrk+skN5NYwgqP7XK86sjsmUpt8PBj7F6QRPNYZyO45F6+arLT3GIw3Tner7zpVGCXVppyZqruviIhyoS1sIgkUezU/tjsxLRk8bvY22RT0TZ5f2Nywv5jAcNF/cpVeOIz5Y5N2wLSjudSl1ns1SnkMFSvKvzSCPERsfov9AS9H8yWiAaYXmGaOHOvqlekdAFskY0W3kyL3itjUcOn52NjRd9FGO0uUgvx/+4+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB4973.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(39850400004)(396003)(366004)(346002)(136003)(316002)(54906003)(38100700002)(2616005)(186003)(36756003)(30864003)(2906002)(6506007)(38350700002)(26005)(1076003)(86362001)(110136005)(5660300002)(6512007)(66476007)(4326008)(8676002)(7416002)(44832011)(66556008)(52116002)(83380400001)(8936002)(66946007)(478600001)(6486002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VDVgjrbG4kiVZ5amVfY9Hz6LIbM2gwcFE8NQGviLW2MhMDbsX6eJ1wn/VsJk?=
 =?us-ascii?Q?pBgRA62Ijr+gAiu7YyyGUP+T0fKsTzHa7v8r9cGHgU1bPepsy722+7pNsSt+?=
 =?us-ascii?Q?y2niaKol7cR24muRmLMz7zbVsaZGHspXrV3mIC25ZsckrHi2YK4rwMVYIJhU?=
 =?us-ascii?Q?ykQ221qEAMsEP1vfBSPH4vEtRXnu2cNofEP5GWjauh4ZnwiZUTqKmwKS3+PT?=
 =?us-ascii?Q?3qNO05aF2VEC+FGCPWkZ/7NIM0u2gFbvhk0OlF2FR+/LDceIn1GD4R41j7Qr?=
 =?us-ascii?Q?ntIMtV1lsjULIWOqfpDI0SZM7pFmRapegp19VIKvUUeltToKJUN8yApKaNfR?=
 =?us-ascii?Q?uPvMxB6iDQ8yp7xgONNtpWy7k1AkPs42aXPLwyUfA1GEkzwBKrkrPBpxuepR?=
 =?us-ascii?Q?/xXcXCSt8TyGddQ7gjniqPS1mktzLYs2vKSqtcardCAfur9XmE1k6e9dsSsU?=
 =?us-ascii?Q?ztzKqNXs5FLzMmhliP6Oh6fiDHaMvIhSYRNjjxr2OM9FglgFLKIdbBk6Rjuz?=
 =?us-ascii?Q?8725+PVfrv10Q6xKkfZpgL1ShhomtTLw737pLtDJuoYfqUUKUUnlV45TjaEY?=
 =?us-ascii?Q?06O8DIoCo/PyRgMXnrtleGlAW1Gs0FxdBT6Kw5i7EjQYMmTC+6KRk2TuwLbE?=
 =?us-ascii?Q?28VOWBj9qgoei3fVTfqEQHFNPMBeSLDbBWB+ghLdz9kgZzKzIHJOg9gqq1T1?=
 =?us-ascii?Q?mfISiDu9bGdp6VV5eDApZTxX6a4c002MUG19q8OZi4Y+W59jecA6LpdbftGB?=
 =?us-ascii?Q?mPDfiGkxttmvPmHGQ7vINTSXAqbw4bz5F3VAyI6m0PvmFO+LsEK3XNdpLDgt?=
 =?us-ascii?Q?Y8u4tKs9UrtuMUf7dmAeHgVYukv7inQOPf1Zz1rGoudA41aMr3q0fGTUBJAe?=
 =?us-ascii?Q?Lr4SvjhyBxYY6ilpc2pmJxzDMxVyx13281W4ah53NoZ1uAhbKGB/jD55ncLY?=
 =?us-ascii?Q?udiy51YbEXsXIL7LTZilNlIQ5qIMLjDmVTKVkIX8eR3uiUShBobiFZwbYuzc?=
 =?us-ascii?Q?FRVs05vcHnOaYffCFomhW38fCgzz82vfRS6VDfZGFGim8saanELTs6SJaPh6?=
 =?us-ascii?Q?VY/PEQukNQiUfVrERA2PQjhWHgMQS4K/FM2Lbfwj0WpKzVGFINPfFAwxY+10?=
 =?us-ascii?Q?wV9SwwcwdW5FE2u4BWwzOva866lMLtNwt1y/5Z9QORh2IFuko2kbbyxlEnw7?=
 =?us-ascii?Q?iJw0Dtg61uggM1nH/LJxs3BPyjb3iQvnldNVJ7uDhWFyhjGNXDOIY9zIszpW?=
 =?us-ascii?Q?yxMFrPR5Lfw4pOPSavD+Dzto1loyEU+dHtlyl/ah53hy8buMZYQRhrwtkn65?=
 =?us-ascii?Q?Y3ppB8ZioCtHBa8W3vKR47JgvoMu0DmUsie5ARMFtIVDA4LLFklmT9Bebegp?=
 =?us-ascii?Q?tehJYz9rBgFQSV0Ts/S5/djDCJc8wfSasGlHO4hac6n7gduO6IsrAc9GLS9/?=
 =?us-ascii?Q?itiiW9L7ogm5NMG05VLpyl6dQHg8eKfGKbcq0Tf6FcjV3mahE0m1Y89LLJ9r?=
 =?us-ascii?Q?mnfZsq7lzgP1v0+JcEHgRDjMkMGlz00thhFKZtlYJdgSId0I0Tr5Wcu/jcy4?=
 =?us-ascii?Q?MV2IKEQAVAmA9iw2NZyhjHTDfFMRhm97DeSV29CqIhwCGYgT764MhFsWYVQx?=
 =?us-ascii?Q?Tg=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5e59f55-4478-4918-5501-08da66ad9da5
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB4973.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2022 22:01:48.7517
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VyV/yuJy01Ay0+H4qFfN8TlRSyuwL+G2PbK0loomJ/Jje6nRJnPjNOFAl2CYVfpC6BkQwZgVLN8hG8foZBQm6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR03MB2857
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we actually read registers from QSGMII PCSs, it's important
that we have the correct address (instead of hoping that we're the MAC
with all the QSGMII PCSs on its bus). This adds nodes for the QSGMII
PCSs. They have the same addresses on all SoCs (e.g. if QSGMIIA is
present it's used for MACs 1 through 4).

Since the first QSGMII PCSs share an address with the SGMII and XFI
PCSs, we only add new nodes for PCSs 2-4. This avoids address conflicts
on the bus.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

Changes in v3:
- Add compatibles for QSGMII PCSs
- Split arm and powerpcs dts updates

Changes in v2:
- New

 .../boot/dts/fsl/qoriq-fman3-0-10g-0-best-effort.dtsi  |  3 ++-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0.dtsi     | 10 +++++++++-
 .../boot/dts/fsl/qoriq-fman3-0-10g-1-best-effort.dtsi  | 10 +++++++++-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1.dtsi     | 10 +++++++++-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-0.dtsi      |  3 ++-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-1.dtsi      | 10 +++++++++-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-2.dtsi      | 10 +++++++++-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-3.dtsi      | 10 +++++++++-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-4.dtsi      |  3 ++-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-5.dtsi      | 10 +++++++++-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-0.dtsi     | 10 +++++++++-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-1.dtsi     | 10 +++++++++-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-0.dtsi      |  3 ++-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-1.dtsi      | 10 +++++++++-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-2.dtsi      | 10 +++++++++-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-3.dtsi      | 10 +++++++++-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-4.dtsi      |  3 ++-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-5.dtsi      | 10 +++++++++-
 18 files changed, 127 insertions(+), 18 deletions(-)

diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0-best-effort.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0-best-effort.dtsi
index baa0c503e741..db169d630db3 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0-best-effort.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0-best-effort.dtsi
@@ -55,7 +55,8 @@ ethernet@e0000 {
 		reg = <0xe0000 0x1000>;
 		fsl,fman-ports = <&fman0_rx_0x08 &fman0_tx_0x28>;
 		ptp-timer = <&ptp_timer0>;
-		pcsphy-handle = <&pcsphy0>;
+		pcsphy-handle = <&pcsphy0>, <&pcsphy0>;
+		pcs-names = "sgmii", "qsgmii";
 	};
 
 	mdio@e1000 {
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0.dtsi
index 93095600e808..e80ad8675be8 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0.dtsi
@@ -52,7 +52,15 @@ ethernet@f0000 {
 		compatible = "fsl,fman-memac";
 		reg = <0xf0000 0x1000>;
 		fsl,fman-ports = <&fman0_rx_0x10 &fman0_tx_0x30>;
-		pcsphy-handle = <&pcsphy6>;
+		pcsphy-handle = <&pcsphy6>, <&qsgmiib_pcs2>, <&pcsphy6>;
+		pcs-names = "sgmii", "qsgmii", "xfi";
+	};
+
+	mdio@e9000 {
+		qsgmiib_pcs2: ethernet-pcs@2 {
+			compatible = "fsl,lynx-pcs";
+			reg = <2>;
+		};
 	};
 
 	mdio@f1000 {
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1-best-effort.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1-best-effort.dtsi
index ff4bd38f0645..6a6f51842ad5 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1-best-effort.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1-best-effort.dtsi
@@ -55,7 +55,15 @@ ethernet@e2000 {
 		reg = <0xe2000 0x1000>;
 		fsl,fman-ports = <&fman0_rx_0x09 &fman0_tx_0x29>;
 		ptp-timer = <&ptp_timer0>;
-		pcsphy-handle = <&pcsphy1>;
+		pcsphy-handle = <&pcsphy1>, <&qsgmiia_pcs1>;
+		pcs-names = "sgmii", "qsgmii";
+	};
+
+	mdio@e1000 {
+		qsgmiia_pcs1: ethernet-pcs@1 {
+			compatible = "fsl,lynx-pcs";
+			reg = <1>;
+		};
 	};
 
 	mdio@e3000 {
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1.dtsi
index 1fa38ed6f59e..543da5493e40 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1.dtsi
@@ -52,7 +52,15 @@ ethernet@f2000 {
 		compatible = "fsl,fman-memac";
 		reg = <0xf2000 0x1000>;
 		fsl,fman-ports = <&fman0_rx_0x11 &fman0_tx_0x31>;
-		pcsphy-handle = <&pcsphy7>;
+		pcsphy-handle = <&pcsphy7>, <&qsgmiib_pcs3>, <&pcsphy7>;
+		pcs-names = "sgmii", "qsgmii", "xfi";
+	};
+
+	mdio@e9000 {
+		qsgmiib_pcs3: ethernet-pcs@3 {
+			compatible = "fsl,lynx-pcs";
+			reg = <3>;
+		};
 	};
 
 	mdio@f3000 {
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-0.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-0.dtsi
index a8cc9780c0c4..ce76725e6eb2 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-0.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-0.dtsi
@@ -51,7 +51,8 @@ ethernet@e0000 {
 		reg = <0xe0000 0x1000>;
 		fsl,fman-ports = <&fman0_rx_0x08 &fman0_tx_0x28>;
 		ptp-timer = <&ptp_timer0>;
-		pcsphy-handle = <&pcsphy0>;
+		pcsphy-handle = <&pcsphy0>, <&pcsphy0>;
+		pcs-names = "sgmii", "qsgmii";
 	};
 
 	mdio@e1000 {
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-1.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-1.dtsi
index 8b8bd70c9382..f3af67df4767 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-1.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-1.dtsi
@@ -51,7 +51,15 @@ ethernet@e2000 {
 		reg = <0xe2000 0x1000>;
 		fsl,fman-ports = <&fman0_rx_0x09 &fman0_tx_0x29>;
 		ptp-timer = <&ptp_timer0>;
-		pcsphy-handle = <&pcsphy1>;
+		pcsphy-handle = <&pcsphy1>, <&qsgmiia_pcs1>;
+		pcs-names = "sgmii", "qsgmii";
+	};
+
+	mdio@e1000 {
+		qsgmiia_pcs1: ethernet-pcs@1 {
+			compatible = "fsl,lynx-pcs";
+			reg = <1>;
+		};
 	};
 
 	mdio@e3000 {
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-2.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-2.dtsi
index 619c880b54d8..f6d74de84bfe 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-2.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-2.dtsi
@@ -51,7 +51,15 @@ ethernet@e4000 {
 		reg = <0xe4000 0x1000>;
 		fsl,fman-ports = <&fman0_rx_0x0a &fman0_tx_0x2a>;
 		ptp-timer = <&ptp_timer0>;
-		pcsphy-handle = <&pcsphy2>;
+		pcsphy-handle = <&pcsphy2>, <&qsgmiia_pcs2>;
+		pcs-names = "sgmii", "qsgmii";
+	};
+
+	mdio@e1000 {
+		qsgmiia_pcs2: ethernet-pcs@2 {
+			compatible = "fsl,lynx-pcs";
+			reg = <2>;
+		};
 	};
 
 	mdio@e5000 {
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-3.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-3.dtsi
index d7ebb73a400d..6e091d8ae9e2 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-3.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-3.dtsi
@@ -51,7 +51,15 @@ ethernet@e6000 {
 		reg = <0xe6000 0x1000>;
 		fsl,fman-ports = <&fman0_rx_0x0b &fman0_tx_0x2b>;
 		ptp-timer = <&ptp_timer0>;
-		pcsphy-handle = <&pcsphy3>;
+		pcsphy-handle = <&pcsphy3>, <&qsgmiia_pcs3>;
+		pcs-names = "sgmii", "qsgmii";
+	};
+
+	mdio@e1000 {
+		qsgmiia_pcs3: ethernet-pcs@3 {
+			compatible = "fsl,lynx-pcs";
+			reg = <3>;
+		};
 	};
 
 	mdio@e7000 {
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-4.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-4.dtsi
index b151d696a069..e2174c0fc841 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-4.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-4.dtsi
@@ -51,7 +51,8 @@ ethernet@e8000 {
 		reg = <0xe8000 0x1000>;
 		fsl,fman-ports = <&fman0_rx_0x0c &fman0_tx_0x2c>;
 		ptp-timer = <&ptp_timer0>;
-		pcsphy-handle = <&pcsphy4>;
+		pcsphy-handle = <&pcsphy4>, <&pcsphy4>;
+		pcs-names = "sgmii", "qsgmii";
 	};
 
 	mdio@e9000 {
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-5.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-5.dtsi
index adc0ae0013a3..9106815bd63e 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-5.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-5.dtsi
@@ -51,7 +51,15 @@ ethernet@ea000 {
 		reg = <0xea000 0x1000>;
 		fsl,fman-ports = <&fman0_rx_0x0d &fman0_tx_0x2d>;
 		ptp-timer = <&ptp_timer0>;
-		pcsphy-handle = <&pcsphy5>;
+		pcsphy-handle = <&pcsphy5>, <&qsgmiib_pcs1>;
+		pcs-names = "sgmii", "qsgmii";
+	};
+
+	mdio@e9000 {
+		qsgmiib_pcs1: ethernet-pcs@1 {
+			compatible = "fsl,lynx-pcs";
+			reg = <1>;
+		};
 	};
 
 	mdio@eb000 {
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-0.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-0.dtsi
index 435047e0e250..a3c1538dfda1 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-0.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-0.dtsi
@@ -52,7 +52,15 @@ ethernet@f0000 {
 		compatible = "fsl,fman-memac";
 		reg = <0xf0000 0x1000>;
 		fsl,fman-ports = <&fman1_rx_0x10 &fman1_tx_0x30>;
-		pcsphy-handle = <&pcsphy14>;
+		pcsphy-handle = <&pcsphy14>, <&qsgmiid_pcs2>, <&pcsphy14>;
+		pcs-names = "sgmii", "qsgmii", "xfi";
+	};
+
+	mdio@e9000 {
+		qsgmiid_pcs2: ethernet-pcs@2 {
+			compatible = "fsl,lynx-pcs";
+			reg = <2>;
+		};
 	};
 
 	mdio@f1000 {
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-1.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-1.dtsi
index c098657cca0a..c024517e70d6 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-1.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-1.dtsi
@@ -52,7 +52,15 @@ ethernet@f2000 {
 		compatible = "fsl,fman-memac";
 		reg = <0xf2000 0x1000>;
 		fsl,fman-ports = <&fman1_rx_0x11 &fman1_tx_0x31>;
-		pcsphy-handle = <&pcsphy15>;
+		pcsphy-handle = <&pcsphy15>, <&qsgmiid_pcs3>, <&pcsphy15>;
+		pcs-names = "sgmii", "qsgmii", "xfi";
+	};
+
+	mdio@e9000 {
+		qsgmiid_pcs3: ethernet-pcs@3 {
+			compatible = "fsl,lynx-pcs";
+			reg = <3>;
+		};
 	};
 
 	mdio@f3000 {
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-0.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-0.dtsi
index 9d06824815f3..16fb299f615a 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-0.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-0.dtsi
@@ -51,7 +51,8 @@ ethernet@e0000 {
 		reg = <0xe0000 0x1000>;
 		fsl,fman-ports = <&fman1_rx_0x08 &fman1_tx_0x28>;
 		ptp-timer = <&ptp_timer1>;
-		pcsphy-handle = <&pcsphy8>;
+		pcsphy-handle = <&pcsphy8>, <&pcsphy8>;
+		pcs-names = "sgmii", "qsgmii";
 	};
 
 	mdio@e1000 {
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-1.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-1.dtsi
index 70e947730c4b..75cecbef8469 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-1.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-1.dtsi
@@ -51,7 +51,15 @@ ethernet@e2000 {
 		reg = <0xe2000 0x1000>;
 		fsl,fman-ports = <&fman1_rx_0x09 &fman1_tx_0x29>;
 		ptp-timer = <&ptp_timer1>;
-		pcsphy-handle = <&pcsphy9>;
+		pcsphy-handle = <&pcsphy9>, <&qsgmiic_pcs1>;
+		pcs-names = "sgmii", "qsgmii";
+	};
+
+	mdio@e1000 {
+		qsgmiic_pcs1: ethernet-pcs@1 {
+			compatible = "fsl,lynx-pcs";
+			reg = <1>;
+		};
 	};
 
 	mdio@e3000 {
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-2.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-2.dtsi
index ad96e6529595..98c1d27f17e7 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-2.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-2.dtsi
@@ -51,7 +51,15 @@ ethernet@e4000 {
 		reg = <0xe4000 0x1000>;
 		fsl,fman-ports = <&fman1_rx_0x0a &fman1_tx_0x2a>;
 		ptp-timer = <&ptp_timer1>;
-		pcsphy-handle = <&pcsphy10>;
+		pcsphy-handle = <&pcsphy10>, <&qsgmiic_pcs2>;
+		pcs-names = "sgmii", "qsgmii";
+	};
+
+	mdio@e1000 {
+		qsgmiic_pcs2: ethernet-pcs@2 {
+			compatible = "fsl,lynx-pcs";
+			reg = <2>;
+		};
 	};
 
 	mdio@e5000 {
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-3.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-3.dtsi
index 034bc4b71f7a..203a00036f17 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-3.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-3.dtsi
@@ -51,7 +51,15 @@ ethernet@e6000 {
 		reg = <0xe6000 0x1000>;
 		fsl,fman-ports = <&fman1_rx_0x0b &fman1_tx_0x2b>;
 		ptp-timer = <&ptp_timer1>;
-		pcsphy-handle = <&pcsphy11>;
+		pcsphy-handle = <&pcsphy11>, <&qsgmiic_pcs3>;
+		pcs-names = "sgmii", "qsgmii";
+	};
+
+	mdio@e1000 {
+		qsgmiic_pcs3: ethernet-pcs@3 {
+			compatible = "fsl,lynx-pcs";
+			reg = <3>;
+		};
 	};
 
 	mdio@e7000 {
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-4.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-4.dtsi
index 93ca23d82b39..9366935ebc02 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-4.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-4.dtsi
@@ -51,7 +51,8 @@ ethernet@e8000 {
 		reg = <0xe8000 0x1000>;
 		fsl,fman-ports = <&fman1_rx_0x0c &fman1_tx_0x2c>;
 		ptp-timer = <&ptp_timer1>;
-		pcsphy-handle = <&pcsphy12>;
+		pcsphy-handle = <&pcsphy12>, <&pcsphy12>;
+		pcs-names = "sgmii", "qsgmii";
 	};
 
 	mdio@e9000 {
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-5.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-5.dtsi
index 23b3117a2fd2..39f7c6133017 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-5.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-5.dtsi
@@ -51,7 +51,15 @@ ethernet@ea000 {
 		reg = <0xea000 0x1000>;
 		fsl,fman-ports = <&fman1_rx_0x0d &fman1_tx_0x2d>;
 		ptp-timer = <&ptp_timer1>;
-		pcsphy-handle = <&pcsphy13>;
+		pcsphy-handle = <&pcsphy13>, <&qsgmiid_pcs1>;
+		pcs-names = "sgmii", "qsgmii";
+	};
+
+	mdio@e9000 {
+		qsgmiid_pcs1: ethernet-pcs@1 {
+			compatible = "fsl,lynx-pcs";
+			reg = <1>;
+		};
 	};
 
 	mdio@eb000 {
-- 
2.35.1.1320.gc452695387.dirty

