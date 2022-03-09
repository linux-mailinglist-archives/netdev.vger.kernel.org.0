Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2F994D37E0
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 18:45:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237135AbiCIR3c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 12:29:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237172AbiCIR30 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 12:29:26 -0500
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10078.outbound.protection.outlook.com [40.107.1.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17AAB8EB7A;
        Wed,  9 Mar 2022 09:28:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BBnmYvjyKIsF2f9ao28pPiJIB3hI0xv5LQKlVeTDxp9FFgRgsP1dXbCR6SSJlqzuSq9sVwO2gUFO7yallOyt7pgJ+yL/nANcxH+SQB7a6YOwikIFoh88nZ3o2EdNTzfwGrSBnIHnQcgJuEX4swDl2S8I/dhLBNvFT7VpbhRU1fwpvUBAcD4uS/NSz2yNEudA/A4LMq2fl5agY2bKKio4o69srL/Ubx7Hhf40BPYUf266YeJrVIsUToS9LRSMqxRwJN1bnpfNtN0qbL3iR9ScoAbxGtCudcSPqkFoepRzGpnVnJq9L81K1Kqj6UEptyuCYXyd2SdDQjhpodsMNL8srA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MXX8DLTYy+heR8x5i7HHBQNGgaeAs/W7i31nc5oL6T8=;
 b=E2VQjgDwoQJLr2i1z8WT3jEu+bcnjMUidFRCaNFJN0ngARvaXhYoz/QKdr4LBBbp41Vp7/iwKz56YlmQZaK2/Ciq9YBCRuUydxHANQjxx/Mou4QYQANh5MGM3dzpZhhcTP3skX8/I+7+ss4U5srKFeZWnNZmKCZE8u3N5WCDpa3QrTHBWK23IPfWJN/f5sPdseD3ZupuVr2ftCUc7uXZHLujm8j4sPmsdDqvnv90Gkaw6q/+nrvQh9xvj4OSKxab8rZOm+3ZEw2mt/7Ts/4IFWxvG05rrxHfSbFMxnqZtlnf4bO/3G8+lZbHJSvaHO/Y2o0cBa54K+bPBBN+7hz35A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MXX8DLTYy+heR8x5i7HHBQNGgaeAs/W7i31nc5oL6T8=;
 b=hzd5YY/exrVr177409GOzYeqrbOyFWPbUO8OTtIIdzKhLZH+k5yg5g+cOejJvkz9Hs3ZAP9mUIS8sBul/XtWLI6KxK2Ycgn7gaFKpSNxhr9iIgGXtJUjL0/zWD8/EsL1qtw2PIRnCWTpSoseRFf6lyhJuvAvvTcdXxb1HA/4sYk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com (2603:10a6:20b:436::16)
 by PAXPR04MB9422.eurprd04.prod.outlook.com (2603:10a6:102:2b4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.19; Wed, 9 Mar
 2022 17:28:16 +0000
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579]) by AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579%7]) with mapi id 15.20.5038.027; Wed, 9 Mar 2022
 17:28:16 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     kishon@ti.com, vkoul@kernel.org, robh+dt@kernel.org,
        leoyang.li@nxp.com, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux@armlinux.org.uk,
        shawnguo@kernel.org, hongxing.zhu@nxp.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v2 8/8] arch: arm64: dts: lx2160a: describe the SerDes block #1
Date:   Wed,  9 Mar 2022 19:27:48 +0200
Message-Id: <20220309172748.3460862-9-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220309172748.3460862-1-ioana.ciornei@nxp.com>
References: <20220309172748.3460862-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR07CA0014.eurprd07.prod.outlook.com
 (2603:10a6:205:1::27) To AM9PR04MB8555.eurprd04.prod.outlook.com
 (2603:10a6:20b:436::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d20dfdeb-0280-42a7-46c1-08da01f23218
X-MS-TrafficTypeDiagnostic: PAXPR04MB9422:EE_
X-Microsoft-Antispam-PRVS: <PAXPR04MB94227421FC89A77324EE3D2FE00A9@PAXPR04MB9422.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vq6evTEMLDuFN8qMzq4PuKJIAVpvFINcuKyQ8JmphfAQKjvRaa/wGAZzcAQ5DYwpYp79TDlJXhVM7WugQ3gDbkuE8kU9w2yh9FWaDvC5Y1nz3erDAA47Dzfh9viGUeOCNb9LBY10aDOEWOoajvBVIJWhLdATBlMI/NIn+oXMz1um6/EZsdZwWR1VHs9s4guLuOrTa6GFq+VzqV5lnqb0QArJuOk6Kd3WpWbADjsFcUxA5R9sWR8VfHLbFBdfCmP/qBWAhjYfo+GA7vdFg0g1qO6HitY2hHxAYjm3UfIg5p1SUej0bPBuDMOBv4R2DxfW8kWvc6SO2lX2tjLHICQFTiBWxr1Cb+mrBxLXqx3ZnbPWiS90RJJWH4cAcpyNq69WhsA+RfCD/X8xpPTd7I4O4oscltNqRoRWf9kNGLwYdXH07EkRQy9pX57d526fDAN+OmAfRNF+J45ESDJIEwzg6N38RQ3ua7fAJW31S5u6sEeYoumCi15tg5X3HYh3ZyugFksNVtH4vKm6kz8gEtS4s4JEuIqXIG9EdXCnOxKzS53uU1jNWmzUteyY280S5MVWFj8MGp3XWvjt1+/jmXbS+eWpkv597ipVtuBOFYcGp+JZWB9WAjLJsaxQXy59xFNIjpooEAhAEl5LVHk/DnfH6RSNGePFcQnz/Q6ZjVFz4/U0HmyJcipDTvI0vOcwsY5HVsADjyVOfn1lsW0ufSBbvMfAgmKTLBudwZZbQkvA9SU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8555.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(8936002)(52116002)(2616005)(6666004)(6512007)(498600001)(6506007)(5660300002)(66946007)(7416002)(36756003)(86362001)(38350700002)(38100700002)(2906002)(1076003)(44832011)(66476007)(66556008)(4326008)(83380400001)(8676002)(186003)(26005)(17413003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Mzc7um0+BZkx4qeB+/Ota3SU8zYpLQDUWMPRHhhrMCbULalYltSKdvrXYjK1?=
 =?us-ascii?Q?UAmldO4ymVRqi5/wplOYL/0eiP6w9At5HstczJVRkr+BIrZ355uVH804aami?=
 =?us-ascii?Q?/yhATMro+bUTbqvuOTR5j1Z+htjy++e8N/CBmHge87a2CmD8EwUkzKzBl/5k?=
 =?us-ascii?Q?1VVZtQmU0vdK9bCSIfR+AYvib9fNnpbapW9x7Fh+gnG79wtU6CnZAOhvciEo?=
 =?us-ascii?Q?fFeto9xkKeEtPh1X38bzWE1b10saS7B8xUhdJ3rzDYOUwkf0OzS/sWTRbBUP?=
 =?us-ascii?Q?EGgV1W1i0AqFotdY7M2HeWFxo5eXOaJ+Xiq3Wt3+WjWHcjHbYskr82p4iKRs?=
 =?us-ascii?Q?HtpxY1FuJeLU2YniMr7i2+mlli52S3uQUdXhQnnDQnFvzk19XP/0j3xi9jxA?=
 =?us-ascii?Q?La0AeY4stFtsL5R495HNXg6OcEteZuGOH5a7xqZSWhirf7aErucMGYYKJ7PV?=
 =?us-ascii?Q?ODhtxlMgvNdIIys5cXRevaNZdoOq3ThRSUBu1kAlLu6t7jwkerTJqMX13G9h?=
 =?us-ascii?Q?27YvvAs8UCDMtiHi0SjsGoW+C5OsIp/F+P5LWj6s2xR/kAWXeVO5SJiZKJXD?=
 =?us-ascii?Q?yOKMDG6rNJbFd5mdht3i6SkZLqdOHF5805+ib7n+aj7y0loBi9rFKEC0K1wJ?=
 =?us-ascii?Q?W6oojOJV/rNb91J5lwomyOtKR/OWMAqqCki4b073r7rY04FFOQZI1zPQIHA8?=
 =?us-ascii?Q?3JOBSjwbDyfKVEe20z+W3E4TsH8WyQy7lxfwJ9E91K3E4/qbTpy/7S63riIr?=
 =?us-ascii?Q?Q9pQm1dbri55Yl6bnMPvJapr9igEKLgLrVn0kPOHu2SqiYWCgr0Rlwlxd4uW?=
 =?us-ascii?Q?dhih5iP4PkWJQKC+ZaDnO0OogYUIlaTHBXsGubS/JMp7KIqMkR8Pepl8LEQy?=
 =?us-ascii?Q?2+P+5ASZZfmcppwEMJrFQLidQp5Okbq0LUf1g+jvk8S9uedAaP0oNJEope0C?=
 =?us-ascii?Q?ao1ZNTy9ZrVGYwxDbcut/+sHNedICyPLGOEY2QOwekFON3wIg0HMeBV0hu+C?=
 =?us-ascii?Q?uB6B4FOC9gsWfii1a6NOX/Z5Q5Xifct3PCIBjtqKe0/U6nuXbiKLYPkLEFzc?=
 =?us-ascii?Q?vViqtjFUlDtX5xLtIoBhbHYw4K4TPjGDTdzqXYjZVZB65y9PNWRm2xAovsbr?=
 =?us-ascii?Q?to/RxPFZt0PhJHjGG1ZjBzAPeLQ3KxdfaH5Rmm6Ru5lI5jrS2nHjiX28LTkc?=
 =?us-ascii?Q?fkA7Cu93Uc08F3vbqDXNLDcbqPFJnHcZWs/cQvuW+BcI52ULbI8Xb9Y6jqEF?=
 =?us-ascii?Q?FKRWWLAUnVsB+PV98aPi/gkj4lQK9OCMQhCllrc4ybA1TSP72phn66YP2A8a?=
 =?us-ascii?Q?qwziB+uADN0USyTBV7eLBQxpxl3f8J6Zw7twxPAwOwcz6oCq5DqRmX+nLnwR?=
 =?us-ascii?Q?lVbsvfODf/lDvEwRRNVheb3UQfrbx789cEYh9tIT1LcHhOkQShOXPzOEIkRy?=
 =?us-ascii?Q?kiROzNjaCFhr7QjHnevTPTkTigbtYcnSNYzPqv9Fr84SYh5qpKvEpRdL+w+c?=
 =?us-ascii?Q?VD+tFAV/D5Pj6Z+kw4bDZf8EQ/MEqDIbycRZXPFL7xIKEwnKDmD7Ki+vSCHa?=
 =?us-ascii?Q?55viIGeBjm4urTJMSAoQRq5VMOAaPi5X0UHFyy98Zakk4dZy3Y5uaUyutXu0?=
 =?us-ascii?Q?UMDPAUV4lzl7BDFIiyDPYd0=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d20dfdeb-0280-42a7-46c1-08da01f23218
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2022 17:28:16.2074
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Kls2c83sULA/12wEcpFlAo4G9mixCq8q3tSg4q+HBTThSbtzUDqdKGoyl2fODob8y5Zhjy9nEOMxrKmRkYZRIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9422
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Describe the SerDes block #1 using the generic phys infrastructure. This
way, the ethernet nodes can each reference their serdes lanes
individually using the 'phys' dts property.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
	- none

 .../freescale/fsl-lx2160a-clearfog-itx.dtsi   |  4 ++
 .../arm64/boot/dts/freescale/fsl-lx2160a.dtsi | 41 +++++++++++++++++++
 2 files changed, 45 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/fsl-lx2160a-clearfog-itx.dtsi b/arch/arm64/boot/dts/freescale/fsl-lx2160a-clearfog-itx.dtsi
index 17f8e733972a..14a6334adff2 100644
--- a/arch/arm64/boot/dts/freescale/fsl-lx2160a-clearfog-itx.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-lx2160a-clearfog-itx.dtsi
@@ -63,21 +63,25 @@ sfp3: sfp-3 {
 &dpmac7 {
 	sfp = <&sfp0>;
 	managed = "in-band-status";
+	phys = <&serdes1_lane_d>;
 };
 
 &dpmac8 {
 	sfp = <&sfp1>;
 	managed = "in-band-status";
+	phys = <&serdes1_lane_c>;
 };
 
 &dpmac9 {
 	sfp = <&sfp2>;
 	managed = "in-band-status";
+	phys = <&serdes1_lane_b>;
 };
 
 &dpmac10 {
 	sfp = <&sfp3>;
 	managed = "in-band-status";
+	phys = <&serdes1_lane_a>;
 };
 
 &emdio2 {
diff --git a/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi b/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
index 7032505f5ef3..04f29c086512 100644
--- a/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
@@ -612,6 +612,47 @@ soc {
 		ranges;
 		dma-ranges = <0x0 0x0 0x0 0x0 0x10000 0x00000000>;
 
+		serdes_1: serdes_phy@1ea0000 {
+			compatible = "fsl,lynx-28g";
+			reg = <0x00 0x1ea0000 0x0 0x1e30>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			#phy-cells = <1>;
+
+			serdes1_lane_a: phy@0 {
+				reg = <0>;
+				#phy-cells = <0>;
+			};
+			serdes1_lane_b: phy@1 {
+				reg = <1>;
+				#phy-cells = <0>;
+			};
+			serdes1_lane_c: phy@2 {
+				reg = <2>;
+				#phy-cells = <0>;
+			};
+			serdes1_lane_d: phy@3 {
+				reg = <3>;
+				#phy-cells = <0>;
+			};
+			serdes1_lane_e: phy@4 {
+				reg = <4>;
+				#phy-cells = <0>;
+			};
+			serdes1_lane_f: phy@5 {
+				reg = <5>;
+				#phy-cells = <0>;
+			};
+			serdes1_lane_g: phy@6 {
+				reg = <6>;
+				#phy-cells = <0>;
+			};
+			serdes1_lane_h: phy@7 {
+				reg = <7>;
+				#phy-cells = <0>;
+			};
+		};
+
 		crypto: crypto@8000000 {
 			compatible = "fsl,sec-v5.0", "fsl,sec-v4.0";
 			fsl,sec-era = <10>;
-- 
2.33.1

