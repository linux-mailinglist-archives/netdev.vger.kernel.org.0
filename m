Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5605554FEEF
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 23:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383486AbiFQUik (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 16:38:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383321AbiFQUhw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 16:37:52 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150041.outbound.protection.outlook.com [40.107.15.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB7DD6338A;
        Fri, 17 Jun 2022 13:34:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QOISVLc0FOQFCUSxCca5XTOVWFB1623N6jG1+h2nnrHwSdEepru02Yx/QIMZ0mMDeF/SdTlkKfMHcOS84IXEblJr8Is8l7zbPF72YcwNfslVIevU9VyfFOe4vPepVIaTs16C9QZKRpIPgxEGGjGleXrRmQ/h/+0RgeIZL0zTG1B+3SmsLnryQtSpgWomSvP79MaDr8HUnR17Fwaye0gI0pD3/+9FRm/mLwe9Cy88pRHgxDCF8B2sg+5EH4kEYSAuaurt/hBw9Pp2BQ2BUhulhiWpsdkJvbNbhhrkMppSpr6tikjjpGo76G8HRHgf1fU4WKKb8z4om+U4ns4eJ4gEYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XsPPXgKz/RlY5QS5MieFAOEm9miesXI+xxfIAF0y488=;
 b=bHA8GZoSVsxOkPhU9Cik8y0iIbdRWYYijPL7ex9uZcGrilbOzlF/kQWE4jehoGhzEToy61qfsxhm8jbXwtoDLF3Ry+sUYp5nfrCZaJd/0SmjkDtuWHwO04T1pRI9216c0jn1OnzcDIf0gb+k23QrQRFHm9GzTUrR9ro9IVHcI1L4osMrg0fRznfRnJdpJ613sPxJwvdC7kq+1qZlVKfCfyIc64knI/4OsY69Wv3g7YkKzAGcuEyOTPleAZ5zI19zcrqOQW1lolgR0opumCe9ioI2+L2gAj/IBwsCsm6gvTYcQwP6sFImjfCsef3we66+e3Y3ofwYKJUXqF9oFb3U1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XsPPXgKz/RlY5QS5MieFAOEm9miesXI+xxfIAF0y488=;
 b=uz7awzSGsqMcNz3GNgerznbdf3liRQa8zPayPPQoYoTO5Gw3Sd3atS4JDZh3H/LANBY44SufSZHcQpvBW0kyS316XzKyXYA++ZvC3uoq0s2SWnyYboUii7nogQoWrOzhVxADq/JyNUtCz+m1eCawQqX5KbIRP5I2OIQusT7Pas15RsLoOeGimAQFN21uuWeJYttD4VAJEK4y69hHVPjMS/vih6z5l09/kED1bKZuQHobFgW090Xu/JNPUnE6hRC36+9oVfpm/8V7K98ruse4Cuv0K2TQlJj6I3ZEp0ABMg9sC7ebhFx2ywVaQmUIMlHHvfT92ICASZVlSL56BMTCtw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com (2603:10a6:803:c5::12)
 by AS8PR03MB6838.eurprd03.prod.outlook.com (2603:10a6:20b:29b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.16; Fri, 17 Jun
 2022 20:34:26 +0000
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::d18f:e481:f1fa:3e8d]) by VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::d18f:e481:f1fa:3e8d%7]) with mapi id 15.20.5353.016; Fri, 17 Jun 2022
 20:34:26 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        Sean Anderson <sean.anderson@seco.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Li Yang <leoyang.li@nxp.com>, Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH net-next 26/28] arm64: dts: ls1046ardb: Add serdes bindings
Date:   Fri, 17 Jun 2022 16:33:10 -0400
Message-Id: <20220617203312.3799646-27-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220617203312.3799646-1-sean.anderson@seco.com>
References: <20220617203312.3799646-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0384.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::29) To VI1PR03MB4973.eurprd03.prod.outlook.com
 (2603:10a6:803:c5::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7d4e5ddf-79f5-461a-2581-08da50a0c525
X-MS-TrafficTypeDiagnostic: AS8PR03MB6838:EE_
X-Microsoft-Antispam-PRVS: <AS8PR03MB683814D286DFD29FEEE0E5CB96AF9@AS8PR03MB6838.eurprd03.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mCC0LmC7OV8le8kGuy4kEa3L4L76EULh9fK6Ed1p5/8JWgWEif6tLMPokALbTqlSHRZpzyRf+/4Joj7hrSoEfnSkn3AUqo5T+X8+uD+8d6WMcVtTEavktFBoNxpu5mnZ3veb0uQ/TzFDxZLSSreOg8usv4LDM3ql6hwTclnCRk27+malF1fIIUlTySUXo4j3ODcH0cxunoBh88l9VqDW7gKwQ9XEEb0C3tRQre7YpLWrzulSbHJKsTeD1Z3gTTOLHiduFc60fm13r7lYMicgKKtQwpmLqZ9nGfW1sBWQ3GnbgBk8jAYP1Ol6Mqchb82+zCmyx1oSbcwZAZgnICKRup8PVm6KrM3vYO/nhbszJYLu73EVHuDj3RklEIMsigekY8HRrsnOa/yXwKwwDPcQQ1/a3kdVXVb1aITJ2CN4GaemVBpL1Dtd+Lu8usJIrKTe1fnKcYp47AElK+ikkuVhMdPJRjlbPqIHneF7P5ncFaqYFtOc8h/GqbkuM5K/coGfsObj19Lz1n4riXfLQFA+iy4/lUkasbH5jn34plr5uMwQB4QtzvIxWKpgjBU54CttyjpgGZWdd78oswmQmzNoGmrGxMDhQD3JSieY5Bl0QAgnzpbUS9A/R5oplQBoS51SH0KsSZm/sN/KO35coi8RzC71iHoM+r0glg9oGd7be5/ExZsIagW/ZS1MMQ0fnyJ+K1RGIUDDM/zgS73ERxrMyw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB4973.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(44832011)(2616005)(38100700002)(38350700002)(8936002)(52116002)(26005)(316002)(36756003)(7416002)(6512007)(2906002)(4326008)(66476007)(6486002)(66556008)(6506007)(5660300002)(83380400001)(8676002)(86362001)(186003)(66946007)(6666004)(1076003)(54906003)(110136005)(498600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Kc+/MCQ9aG2z7eeQLRu0BZlNvjTpKgsZWYTTg8Jf7hF0LnrVhkHFDc54zDHL?=
 =?us-ascii?Q?bCRneZA/l6I+umXTsJiVUOmyUNg1TeT+78oRYYPdmc6nB0SYzDYaMsJXlObp?=
 =?us-ascii?Q?fwMawmCmVuoTMoUU02KAZF3iLiPLd9kVx914EiLHjaVWWFnupSs69q8ywsY0?=
 =?us-ascii?Q?alWph6xGTdLZxmZ2V3balL/fFIvpeM57v2esGsoqhaosI85POySW05IaFxd2?=
 =?us-ascii?Q?NxueV6wCWp6e+nd7f+7yWUF9PZJh/j0MvoFRoxEgfmpJLWmZMhqApxzTw5Yt?=
 =?us-ascii?Q?fcTeP+2wiDE7qg2yak4A4HCvJF/92SkVupiuyzbbJzHB4kUH9QAVPQSId8wp?=
 =?us-ascii?Q?q8jtykHfs5wVvVzON1EzrCCPbUPp6rNXv5efxJlYbfepZHT6CcXdrQWMJkp1?=
 =?us-ascii?Q?jKdKCqACSBIZN4sM4Lke60d8Dup6qF6v9rKaX1jconmrG1vjvcw7D/PqoWHP?=
 =?us-ascii?Q?V/T2AcPfb9KcNdfhb0j6MchyM38bTmRpiOXq28NPHX7D+2otL1QeoHxXC42N?=
 =?us-ascii?Q?nyuUQ9nrDEiO+BjGYVVJzS1MlSUCI+D0b+I2SBQTOR/0jp1a6Wm0g2NeSasN?=
 =?us-ascii?Q?jkeY0/Kftgk/jq129IS1C1BHxrdtYrUBD7PnXRdeCvjEGlHI4QDnsasc5HYD?=
 =?us-ascii?Q?iZQFECdi3cieCe1FrEPbSqnBfRhzjHsP6EQave9I1fPzfL3YqYLzu5oM26CW?=
 =?us-ascii?Q?AzHYHaP4E0PsaKcE2t9FV3VvfTCOx9pzFx2F9C/5p+2yf0Nq4dhsJJ4WTv+8?=
 =?us-ascii?Q?v2ZCBNmygOev6hnQSqpK/bfLCAwdCz+TMZZnzfLQah5XLixMdBmqLoWDRg2J?=
 =?us-ascii?Q?X8rKsxKnFS+TOxv8jZ+3EfhmHS+qhdWbAYJkNPiGuj1QnxGAcxSFxHKTVP3C?=
 =?us-ascii?Q?/pzG5mJft79OWOZQBY+DI+OyQD5Emcoe5c05p0CUBZwRlrKzXuHMhpcdRRK8?=
 =?us-ascii?Q?XQp5vtIiOMqGdr9oP3pFTcaVo2NU8NXciwdYwLeuTq6rzVKag+3d3vk976VZ?=
 =?us-ascii?Q?r7rZCqlw7lNouAF54507Gyo+yBWVh+OdUbNNQH/PfJ1OZBD06Nsks2P2OC8T?=
 =?us-ascii?Q?dR3MTmLeFupl5jPZAx4t5KiKovl4MTzVVZQ3tcqqNG5oOmsMX6Zk4iJerb9z?=
 =?us-ascii?Q?svUsxhLdR6wXJA24UvtJlfkaKOTSA2iAQK12lximX6ZAfGnwwHvCAV/LLYMp?=
 =?us-ascii?Q?Zw5ZPvZIs2JRuDjekDO2Fzs3MnfMagx9J+lc3dHp+D0hAzpDQJSpujZ0rthJ?=
 =?us-ascii?Q?SwCpmpRpmsEMgw6lOmLi4n/ss1uy+cpESRan4pGYOJyQ7E0z3l1T/tPavCo+?=
 =?us-ascii?Q?/XY7MR6WzLXGeFNVcV1Ei2+7GWf07b8W2Q8Y/T+t+HWeEXlmv1VwZzE01YSL?=
 =?us-ascii?Q?ufL1QMuQe5GwwSWrf7BfQv5QlYivrR+q2U4+JOoBV2oy57k/okBAU4i035Qi?=
 =?us-ascii?Q?QWPPirrDb49IvsBd/CYfIOpIUyFGxNwQJcQvOnpr4AJsmvvF/QUZKxB60fcF?=
 =?us-ascii?Q?AhpbyL0Exmr5lGmpfJdapHWffw1Sh9XFjcFF16KeExXJ1RdR7oJS9OGWi4x1?=
 =?us-ascii?Q?ky6gpyxYdT/zxAWbSSnGndSMCGORMZKKiEZmq/wYAIE7ZLjsWhpwD1OimtFV?=
 =?us-ascii?Q?gfDDOaOLYgCvTtaktGe+XGuFa/UChw2XoW+En8QEURNIlAd2x6w+ffoAAumN?=
 =?us-ascii?Q?LXXsdxso5VSybIWqG+YiD1jd9xUFKI94yxO71Se5Go860ViL6PH/ITaVMKts?=
 =?us-ascii?Q?nSbspT4nGytRIEoL3QpURtjvYyFoWYk=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d4e5ddf-79f5-461a-2581-08da50a0c525
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB4973.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2022 20:34:26.0131
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Whh4rhK0b8L+uE2PJKsQ8hwFvTTJROoKTQZZGMrp3BR5bV2Holl3kQf1qZ1iBlc5wz/W3jU/j2yWZ3NabqfbpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR03MB6838
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds appropriate bindings for the macs which use the SerDes. The
156.25MHz fixed clock is a crystal. The 100MHz clocks (there are
actually 3) come from a Renesas 6V49205B at address 69 on i2c0. There is
no driver for this device (and as far as I know all you can do with the
100MHz clocks is gate them), so I have chosen to model it as a single
fixed clock.

Note: the SerDes1 lane numbering for the LS1046A is *reversed*.
This means that Lane A (what the driver thinks is lane 0) uses pins
SD1_TX3_P/N.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

 .../boot/dts/freescale/fsl-ls1046a-rdb.dts    | 32 +++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts b/arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts
index 7025aad8ae89..21a153349359 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts
@@ -26,6 +26,30 @@ aliases {
 	chosen {
 		stdout-path = "serial0:115200n8";
 	};
+
+	clocks {
+		clk_100mhz: clock-100mhz {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <100000000>;
+		};
+
+		clk_156mhz: clock-156mhz {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <156250000>;
+		};
+	};
+};
+
+&serdes1 {
+	clocks = <&clk_100mhz>, <&clk_156mhz>;
+	clock-names = "ref0", "ref1";
+};
+
+&serdes2 {
+	clocks = <&clk_100mhz>, <&clk_100mhz>;
+	clock-names = "ref0", "ref1";
 };
 
 &duart0 {
@@ -140,21 +164,29 @@ ethernet@e6000 {
 	ethernet@e8000 {
 		phy-handle = <&sgmii_phy1>;
 		phy-connection-type = "sgmii";
+		phys = <&serdes1 1 1>;
+		phy-names = "serdes";
 	};
 
 	ethernet@ea000 {
 		phy-handle = <&sgmii_phy2>;
 		phy-connection-type = "sgmii";
+		phys = <&serdes1 0 0>;
+		phy-names = "serdes";
 	};
 
 	ethernet@f0000 { /* 10GEC1 */
 		phy-handle = <&aqr106_phy>;
 		phy-connection-type = "xgmii";
+		phys = <&serdes1 3 3>;
+		phy-names = "serdes";
 	};
 
 	ethernet@f2000 { /* 10GEC2 */
 		fixed-link = <0 1 1000 0 0>;
 		phy-connection-type = "xgmii";
+		phys = <&serdes1 2 2>;
+		phy-names = "serdes";
 	};
 
 	mdio@fc000 {
-- 
2.35.1.1320.gc452695387.dirty

