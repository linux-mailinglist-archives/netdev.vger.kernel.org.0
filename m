Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2A2655F136
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 00:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232259AbiF1WUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 18:20:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232035AbiF1WTk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 18:19:40 -0400
Received: from EUR03-VE1-obe.outbound.protection.outlook.com (mail-eopbgr50053.outbound.protection.outlook.com [40.107.5.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13E493D1D9;
        Tue, 28 Jun 2022 15:16:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=azTHfPclRpcqGQVZ3ZR8FuQwjQVMiNGv9Gmw1iV3fvkaNnqIKhUQ3OBwgMFa6dR/JvqfhUJn52njcYKasb+RxOOd3g8sdYZEwDBHIHrv6vjbRv1UfFGzUYkPbw76bltxMXkAQuYNgWUnNRME3SSG2SGZr7KTtN90TZI9g7JQ9/qrfvlxvaHI61wpo0Y1kgjSp/2MCPhDd4VRMNVJ/UQs1lvZgIq8xMQqDUiligS9bhOYF47gA3pOaWlyfErV7nWHcCXnrNBdYV7oDyOBbiNUjilTdUZJvq5RVD8RFqsg4ZFZxg5nDXhQcOEPuKQZDL4sm0C1mhOFFZ0ivgMbZ5pi2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M+CFiU6qVhtFTr6M+oOeVnxPczmwKKewaBRv0WHqQyM=;
 b=GZqWQB9aM6AKIw6FQ1712Vc5CLOOTQEcnTCNGBpu5/ZJp3sBSIzFn3Si5/3rAMF3Cg2M5JDDVg5B0cIzSHZN3b+oJvjcdRX+/uqeWz7VK8rsUiJvZ5/TeVUIJcA5/St+XSXG1xP3XvCFCeVU/pPm9mdT0W0I3rTk6O+BMwAhy3md8pJ9cvT0b49IktpxQIa3wrrFy+ICjzuqBDvP9X2cCoK4NSoJLWmgKdQ9068+ElgG+8vMrCK8d0g60BtkF5w/y4ljp/XnTiJDK7xujISm+FoQeOXvt5nE+ohzOwpF7T42gKN4fmz8Vbl9ks0hC5xVQeNgcvDtQ1mfcHSJkwSeHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M+CFiU6qVhtFTr6M+oOeVnxPczmwKKewaBRv0WHqQyM=;
 b=yMd5uLNtlcyePTU3z882Yg2CGvFBQtE8ze6FRcYg4RJO3crPKJOTw/yNagHXlwvbQNQBes9Gd6Fwpp2hjRwsOxcEVrLxdeG3jsoNz/yxxDcoL1IEv8JTpLhGV3L5YFWftuN9Mih0CgEUiUYu9xXku7qPlcstIAiw525XKEEqm/ONm3ZrtYoJDbTkGSQiiDRxXDJ2r/fRSa/ywBTX1SpSCH+WHsghjooxU7hNhPUw/hF540g0g4tthxDUcAuF3G+xKlOUyDXrEyk35mWUFDmBPRM/VDEdwp36pHUbquBUJV6QlkQIWCtrQQ6xtgwbknK6mJAD7mmt8EGGDySgLbb2nQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB7PR03MB3883.eurprd03.prod.outlook.com (2603:10a6:5:34::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Tue, 28 Jun
 2022 22:15:36 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 22:15:36 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-arm-kernel@lists.infradead.org,
        Eric Dumazet <edumazet@google.com>,
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
Subject: [PATCH net-next v2 33/35] qoriq: Add nodes for QSGMII PCSs
Date:   Tue, 28 Jun 2022 18:14:02 -0400
Message-Id: <20220628221404.1444200-34-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220628221404.1444200-1-sean.anderson@seco.com>
References: <20220628221404.1444200-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P222CA0011.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::16) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b64bb631-6dfc-4b5a-e258-08da5953ab30
X-MS-TrafficTypeDiagnostic: DB7PR03MB3883:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vBIZvPtGpaxP4Ir2AQ3yVs8ImQw1TFft7DWup/RKAEgBKyWSgQGskfa4EqddaOK3lSvdGhm0S5JuiVdaUCUMZ3cLL/o3HKK0MacLWC2bWH7r76GhzLpTdtLmUs99wJVJ+PvT/KtauMjJRj4DWSM61KijpuUNGTr2URo6MqxTlOGji/mOEonTr/PVkU5nAJr1x1N/WFoKMsuFdffkDp/RU9T6iYW4rFPmuM1/67ujFuJaddxditxPs6dL/Srqp+qQQWUaZFz6fpdbuNekWatNZIzzOoTBO0MRAb1EnR8Xoh53aLN3HG28CJIpcOAO6nDMarLx93guRdB+8hTe1h6S0AimAdFCz0Z45q047aTnPhZTdvzI4tPjxBvnsSfUx+t+bEqAix5KOiwX6m6myqR999Di0I6buDdeqvVXUtuj9ksgRDrPicWKRQL/KIkcAbzBLPXOhuSsktWwEneJVztVHpI/bJ9h+6pQddy4W2vWa5+KHHmheZUr0MAcNllLADwwsiUKQPk0YQ91IiaNFewNyPVwQVMmaq/6KkLZqgSl89lUvTh76Cvkh5YNwTIRm7jb8fwQNaGC156JJXsftGh1JK041mfQ7uKhXRHRUFpR75ibZS7Fg/RtAoI9BQ3b+XeKfXTCCU/gO/sCbZLsoHTSdtAeAs5tQyTj+PcAIaFmAx3GCCqEaHomt7r8D9c/CjHw2TeoIQxETHIiWZcaLAQQ3JyqR5MGx/A40g5qc6tDBFaUE5ogzoe/mE6WGNUr+r1p2kItomDb4dpT2IgVKVN45Wd+oe3agCmK0Nh3LWNPzZU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(396003)(366004)(39850400004)(136003)(376002)(52116002)(6512007)(6506007)(8676002)(38100700002)(36756003)(66556008)(66946007)(38350700002)(66476007)(2906002)(26005)(1076003)(7416002)(86362001)(54906003)(41300700001)(83380400001)(2616005)(6486002)(110136005)(316002)(6666004)(186003)(4326008)(44832011)(5660300002)(478600001)(8936002)(30864003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?T8CY4rJ1Y/7wVsMsqsk7lVMzhPaffotZKrk3FFDFbWTMo3rBUnSk/PlniM2e?=
 =?us-ascii?Q?J3ZCEN+5fJAGjZnEoWXwqVPhLHEnPGH2l2Msc9zMb0k1/57OG6hAy1HTUX/Y?=
 =?us-ascii?Q?xxvUWMWgQBMmmLL3K63pzQUSnWaRDkY5A+B93NS9+dLSNxzfgXx8NbUKbMfR?=
 =?us-ascii?Q?udaQtDscHTj/wF3Pgu+aSWBor3WjPX35RC/T9qmE2pyFSJ2QDU6I0wHtyQnq?=
 =?us-ascii?Q?/u3QnXCjzvoCzdO2vszAXHF3OFi1/UasT9NRlTjzQQK54sT1sy0+p5vL5v76?=
 =?us-ascii?Q?BKx3J5vy4aQfCrkc9UDboMVXT0CwCfEIhxsWo1faOkqdmBQdT8ZRpmgHO0u0?=
 =?us-ascii?Q?N+0ciU8vKIEktikKJSfxQrI/Ug3t+oFeObcWipBg43PEbEV0hV3ZJhJ/Us3s?=
 =?us-ascii?Q?7eS5totwhvke0wNJExE82PHQ4ruo0ttWrAKginyZsicJ4BP/6d+hWXM/QYKT?=
 =?us-ascii?Q?nU6LduEL58eXmSoOGvYFG9bOgNwT4kqGyNngStlTrbTIXTNaoGwz/GjZdRA2?=
 =?us-ascii?Q?2BKWKlAKp6mslwCN4MJGZMWGl0NDUCfHcGmBra1V7mgtX3gUtubxsYDqEq8p?=
 =?us-ascii?Q?Db3wqybZBfA9p6YMBRkWEp1XHrztogqsFd0DZ5xx4Nm9KRMyF+ASQ1duKv2z?=
 =?us-ascii?Q?BiaKjQGPAvaemeloGefthX/SPhPhixVFQOTqrYlQ9hpDiHqdfGHql6QZoRLu?=
 =?us-ascii?Q?ytC5EK89RScoQhMEgQPjCBrVTLb8LrXetZ6HX6W3YAbRY85AMpE0JjR2D4Ao?=
 =?us-ascii?Q?WO2ANqI9U37YplaNp8VlyopFy7mFIZ/kluGeZnruxBODxLZnfLQC3KmRSgns?=
 =?us-ascii?Q?DOMdeHcdHTYHhsxH2eVkzG4t2UahyNB5WNYSA78+uoN9Jl1f2pxqP8Or3CSu?=
 =?us-ascii?Q?P+peDvWeYhPSdttgdLxvZ264tvGEKiScNIS87LSESpa6bqYmE2lGra0w1yzL?=
 =?us-ascii?Q?+M9vaFc5HDxJh7UqpVG30JiTnuckygfUTPiaFvWgfKX44xRzFl7RA6ina+/f?=
 =?us-ascii?Q?qohpca8S35cJdXsPB4tESk2yFdlmpGD4566aHVtcJooGq2JU8vbDr4a6aL9L?=
 =?us-ascii?Q?3sG9k1f/TmDA/ypbbbifSu/fl6Y2V69PNegliiPE3pviSyubAJ8AQPgIBUj7?=
 =?us-ascii?Q?urJYS7gt2dHVOD97nhObYZpusAEv+9Y3KPoFAcQ1vXis92m38ykldfc58UcF?=
 =?us-ascii?Q?TJq3XpeQZjlhBo1i+ibXyhvHDZgnXa2idTSt/M6KDfhNOuOqEQCF0KI5Ffy6?=
 =?us-ascii?Q?iho2ASUhpao9V+Rog2VQMRmjr+GLfWWeKIFHe1+LcgECu1P0shIWkWyAB4bY?=
 =?us-ascii?Q?Oitldzyr6Tmc2GvZsvX1PH1/rHZWR/KcHyjAUhgmq+MXkgND6mRXZre0OgfS?=
 =?us-ascii?Q?9RqPIWAT1EOPG79KKqJYGx6Ok7HY0WBSkY13KYCghOpBzaLLMzAeIpCuXJMN?=
 =?us-ascii?Q?cHxE4syFhNuGGODTzX1qp/ogNRngdciE4gR/eGjLp1elvyfzcH4mWgmtX8Sp?=
 =?us-ascii?Q?IoM96FJkeUCmcMyK/Y0rFShsR/UidNxJHmmvhfqOEYQzpdkTqANgSpP1B3R9?=
 =?us-ascii?Q?1o32t9V1qcIIyiOUemY4DUXsISdmvbHO5WPZ8O6pr9WjcQgR6TLbA0+009MC?=
 =?us-ascii?Q?zA=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b64bb631-6dfc-4b5a-e258-08da5953ab30
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 22:15:11.7330
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c/kOLXVFYrjo9iuhtMG79mVnQQh9UhGNDZXskDuH2rc1bm0s0mfSqC4/H0+epxydhfWiA+FcYmphSjRpSQFmUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB3883
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we actually read registers from QSGMII PCSs, it's important
that we have the correct address (instead of hoping that we're the MAC
with all the QSGMII PCSs on its bus). Add nodes for the QSGMII PCSs.

On the PowerPC platforms, all the QSGMII PCSs have the same structure
(e.g. if QSGMIIA is present it's used for MACs 1 through 4). On ARM
platforms, the exact mapping of QSGMII to MACs depends on the SoC.

Since the first QSGMII PCSs share an address with the SGMII and XFI
PCSs, we only add new nodes for PCSs 2-4. This avoids address conflicts
on the bus.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

Changes in v2:
- New

 .../boot/dts/freescale/fsl-ls1043-post.dtsi   | 21 ++++++++++++++++
 .../boot/dts/freescale/fsl-ls1046-post.dtsi   | 25 +++++++++++++++++++
 .../fsl/qoriq-fman3-0-10g-0-best-effort.dtsi  |  3 ++-
 .../boot/dts/fsl/qoriq-fman3-0-10g-0.dtsi     |  9 ++++++-
 .../fsl/qoriq-fman3-0-10g-1-best-effort.dtsi  |  9 ++++++-
 .../boot/dts/fsl/qoriq-fman3-0-10g-1.dtsi     |  9 ++++++-
 .../boot/dts/fsl/qoriq-fman3-0-1g-0.dtsi      |  3 ++-
 .../boot/dts/fsl/qoriq-fman3-0-1g-1.dtsi      |  9 ++++++-
 .../boot/dts/fsl/qoriq-fman3-0-1g-2.dtsi      |  9 ++++++-
 .../boot/dts/fsl/qoriq-fman3-0-1g-3.dtsi      |  9 ++++++-
 .../boot/dts/fsl/qoriq-fman3-0-1g-4.dtsi      |  3 ++-
 .../boot/dts/fsl/qoriq-fman3-0-1g-5.dtsi      |  9 ++++++-
 .../boot/dts/fsl/qoriq-fman3-1-10g-0.dtsi     |  9 ++++++-
 .../boot/dts/fsl/qoriq-fman3-1-10g-1.dtsi     |  9 ++++++-
 .../boot/dts/fsl/qoriq-fman3-1-1g-0.dtsi      |  3 ++-
 .../boot/dts/fsl/qoriq-fman3-1-1g-1.dtsi      |  9 ++++++-
 .../boot/dts/fsl/qoriq-fman3-1-1g-2.dtsi      |  9 ++++++-
 .../boot/dts/fsl/qoriq-fman3-1-1g-3.dtsi      |  9 ++++++-
 .../boot/dts/fsl/qoriq-fman3-1-1g-4.dtsi      |  3 ++-
 .../boot/dts/fsl/qoriq-fman3-1-1g-5.dtsi      |  9 ++++++-
 20 files changed, 160 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1043-post.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls1043-post.dtsi
index f12d860a2ed4..6fd77ce41466 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1043-post.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1043-post.dtsi
@@ -24,10 +24,13 @@ &fman0 {
 
 	/* these aliases provide the FMan ports mapping */
 	enet0: ethernet@e0000 {
+		pcs-names = "qsgmii";
 		rgmii = <0>;
 	};
 
 	enet1: ethernet@e2000 {
+		pcsphy-handle = <&pcsphy1>, <&qsgmiib_pcs1>;
+		pcs-names = "sgmii", "qsgmii";
 		rgmii = <0>;
 	};
 
@@ -40,14 +43,32 @@ enet3: ethernet@e6000 {
 	};
 
 	enet4: ethernet@e8000 {
+		pcsphy-handle = <&pcsphy4>, <&qsgmiib_pcs2>;
+		pcs-names = "sgmii", "qsgmii";
 		rgmii = <0>;
 	};
 
 	enet5: ethernet@ea000 {
+		pcsphy-handle = <&pcsphy5>, <&qsgmiib_pcs3>;
+		pcs-names = "sgmii", "qsgmii";
 		rgmii = <0>;
 	};
 
 	enet6: ethernet@f0000 {
 		rgmii = <0>;
 	};
+
+	mdio@e1000 {
+		qsgmiib_pcs1: ethernet-pcs@1 {
+			reg = <0x1>;
+		};
+
+		qsgmiib_pcs2: ethernet-pcs@2 {
+			reg = <0x2>;
+		};
+
+		qsgmiib_pcs3: ethernet-pcs@3 {
+			reg = <0x3>;
+		};
+	};
 };
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1046-post.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls1046-post.dtsi
index 4bb314388a72..6a80accd4845 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1046-post.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1046-post.dtsi
@@ -23,6 +23,8 @@ &soc {
 &fman0 {
 	/* these aliases provide the FMan ports mapping */
 	enet0: ethernet@e0000 {
+		pcsphy-handle = <&qsgmiib_pcs3>;
+		pcs-names = "qsgmii";
 		rgmii = <0>;
 	};
 
@@ -39,10 +41,14 @@ enet3: ethernet@e6000 {
 	};
 
 	enet4: ethernet@e8000 {
+		pcsphy-handle = <&pcsphy4>, <&qsgmiib_pcs1>;
+		pcs-names = "sgmii", "qsgmii";
 		rgmii = <0>;
 	};
 
 	enet5: ethernet@ea000 {
+		pcsphy-handle = <&pcsphy5>, <&pcsphy5>;
+		pcs-names = "sgmii", "qsgmii";
 		rgmii = <0>;
 	};
 
@@ -51,6 +57,25 @@ enet6: ethernet@f0000 {
 	};
 
 	enet7: ethernet@f2000 {
+		pcsphy-handle = <&pcsphy7>, <&qsgmiib_pcs2>, <&pcsphy7>;
+		pcs-names = "sgmii", "qsgmii", "xfi";
 		rgmii = <0>;
 	};
+
+	mdio@eb000 {
+		qsgmiib_pcs1: ethernet-pcs@1 {
+			compatible = "fsl,lynx-10g-qsgmii-pcs";
+			reg = <0x1>;
+		};
+
+		qsgmiib_pcs2: ethernet-pcs@2 {
+			compatible = "fsl,lynx-10g-qsgmii-pcs";
+			reg = <0x2>;
+		};
+
+		qsgmiib_pcs3: ethernet-pcs@3 {
+			compatible = "fsl,lynx-10g-qsgmii-pcs";
+			reg = <0x3>;
+		};
+	};
 };
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
index 93095600e808..fc709261c672 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0.dtsi
@@ -52,7 +52,14 @@ ethernet@f0000 {
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
+			reg = <2>;
+		};
 	};
 
 	mdio@f1000 {
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1-best-effort.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1-best-effort.dtsi
index ff4bd38f0645..dca4702777ef 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1-best-effort.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1-best-effort.dtsi
@@ -55,7 +55,14 @@ ethernet@e2000 {
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
+			reg = <1>;
+		};
 	};
 
 	mdio@e3000 {
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1.dtsi
index 1fa38ed6f59e..220a8fe67fc1 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1.dtsi
@@ -52,7 +52,14 @@ ethernet@f2000 {
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
index 8b8bd70c9382..4e54516aea2f 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-1.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-1.dtsi
@@ -51,7 +51,14 @@ ethernet@e2000 {
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
+			reg = <1>;
+		};
 	};
 
 	mdio@e3000 {
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-2.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-2.dtsi
index 619c880b54d8..0c7459f9efa9 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-2.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-2.dtsi
@@ -51,7 +51,14 @@ ethernet@e4000 {
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
+			reg = <2>;
+		};
 	};
 
 	mdio@e5000 {
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-3.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-3.dtsi
index d7ebb73a400d..2c138ebaa6fc 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-3.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-3.dtsi
@@ -51,7 +51,14 @@ ethernet@e6000 {
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
index adc0ae0013a3..8c5e70da4450 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-5.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-5.dtsi
@@ -51,7 +51,14 @@ ethernet@ea000 {
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
+			reg = <1>;
+		};
 	};
 
 	mdio@eb000 {
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-0.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-0.dtsi
index 435047e0e250..24ab7fc89a87 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-0.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-0.dtsi
@@ -52,7 +52,14 @@ ethernet@f0000 {
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
+			reg = <2>;
+		};
 	};
 
 	mdio@f1000 {
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-1.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-1.dtsi
index c098657cca0a..16a437edda9a 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-1.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-1.dtsi
@@ -52,7 +52,14 @@ ethernet@f2000 {
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
index 70e947730c4b..32af9ed28094 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-1.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-1.dtsi
@@ -51,7 +51,14 @@ ethernet@e2000 {
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
+			reg = <1>;
+		};
 	};
 
 	mdio@e3000 {
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-2.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-2.dtsi
index ad96e6529595..bf830e5b084a 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-2.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-2.dtsi
@@ -51,7 +51,14 @@ ethernet@e4000 {
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
+			reg = <2>;
+		};
 	};
 
 	mdio@e5000 {
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-3.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-3.dtsi
index 034bc4b71f7a..0fe2c962f72e 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-3.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-3.dtsi
@@ -51,7 +51,14 @@ ethernet@e6000 {
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
index 23b3117a2fd2..b05e7a46e2e3 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-5.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-5.dtsi
@@ -51,7 +51,14 @@ ethernet@ea000 {
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
+			reg = <1>;
+		};
 	};
 
 	mdio@eb000 {
-- 
2.35.1.1320.gc452695387.dirty

