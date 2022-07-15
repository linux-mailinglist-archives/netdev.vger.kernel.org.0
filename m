Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB0E65769A7
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 00:08:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232642AbiGOWHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 18:07:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232653AbiGOWG0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 18:06:26 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2079.outbound.protection.outlook.com [40.107.20.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BE158EEC5;
        Fri, 15 Jul 2022 15:02:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TWVs5j9gG7SVXYmohK9FUwE/iqaIqQ9TuitxHIUPX0X9GMn3J/x6Bk7+DeScDPp91qi1loCLVvmIez8UAtH0BW2z+6qUtwNsg0sEfdreVmIR0RDzAOcE29D4R0oxNyPTaDYyQDSW6VkHqrJ40Uh9TrJvqNoKuqxKTO1i9dDAacOnGQGG3UfXw6yJ2Z0cwXtTaUWP7QotyfU/IkO578EvtMVFYa5/iXJNHTCf7Z+Go17fBrLjmx8FjUhpcW3A86tb4MgdJwTfDqcdAWEenAStrWdPyBR72gqFWKgkrYUreBGn481kjzUteFCxyycpPs00ZC+cYiYX3Qzh2lVRk7sAjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fkaQiPnuV3l+B9+GGmEaayl1/1M6ktVvaTFXKN5ZW1M=;
 b=Sp6LL5/WLF245w3ZW+us+IMAgxhULU+bex8o/j69Ck6+itKqQZpO0PeiI2Xaf7bqTxCttJQrMDz36WzxOZg+HdW5WYF+zU8547IicE9SYMAlZsk1Dd2LEW2z6Hdk/ojf6QKeAMaMULVQH6MluNdeVmzndVxs9iGoaeaVGr5PYI4kasrWeqTfplzCOfyVHqgCgeNgzvvZAEw8coxMnZxwoTGIOHVcJPGgMsZNN7GAbQcmAMH3iB40h28aaYbQA7SX7fLsJ2CFU5cSfoEaoLQAQ1E4pLoiPSS6rt0xqRYTThKllLoqX4hgp/SUcn0Ui+TiOb6X817XWqgm/ZiTb5f3EQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fkaQiPnuV3l+B9+GGmEaayl1/1M6ktVvaTFXKN5ZW1M=;
 b=JhfzuN9sYzuwPDWUO/4qD0mdIDwheBT7s7t991ncMsuo8SWM3H/qcf8iS6RWtbtVD6k94N0ztvfh2btH1mqQ5Aos6BkZrCaKRXJY9UNN/b7uumbwHbw9lkexkaFzCAj/LoN+k3CpZ7SWCL8g7Uy4AQvnjsUwICx56keQ5WQ4bjilE3dLBa3hKR5Y+A0Or8OAiXMhQPscITQNHVWRcCM7gm13vYtrbli52aqAdXFoVQjxEEH43Qw2trsBDHD/B/Kr/nV9bU+ycLpwGCQ5Ur/rywhNXP11llzvwfbKCLkXeMKm4xsdHBLvngnBBC0BqW7VJzLQMLCLBCNbKOOcEAH3Xg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com (2603:10a6:803:c5::12)
 by HE1PR03MB2857.eurprd03.prod.outlook.com (2603:10a6:7:5f::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.26; Fri, 15 Jul
 2022 22:01:52 +0000
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558]) by VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558%7]) with mapi id 15.20.5438.015; Fri, 15 Jul 2022
 22:01:52 +0000
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
Subject: [PATCH net-next v3 43/47] arm64: dts: layerscape: Add nodes for QSGMII PCSs
Date:   Fri, 15 Jul 2022 17:59:50 -0400
Message-Id: <20220715215954.1449214-44-sean.anderson@seco.com>
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
X-MS-Office365-Filtering-Correlation-Id: 1778d27c-a995-4420-73f7-08da66ad9f90
X-MS-TrafficTypeDiagnostic: HE1PR03MB2857:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h++xAtxxzOZgwqF9XoqLSej7y2drnvcROB6arB/kRBxi1WlfN9AHYc08L2yh2icwBvFLIPRI/hcSE69K8q2L5oV5xPA9HHS+Kr7QtbSdi0ckIgWyb8GR6fE8Ds2hTyidn9m3hQz28ziVoEBZVDjkJ2aLs/2Hz3sh9+IjwdJ//WvgsKdu7YbWjkhdiaI4KsmiNn+CKPWd4Og1cYKGizg9UwCfUCyaD0RIVDtIg7ADukri6KzR1IaQkoHbEoHhT5T53IZqW7cVlKBJxnCGJFlwOcdIJ7Yt1CfQUk+Irl/nxLcmLutXb6QjHEoDgeAEYKyUiXgOenydu0vJY1Y7hXW5JpFeDEWCev0ThqXfa56hkEgRfKxNUuEP3Kpaxr725KaiGGN2Ti0xQePBgVWrWkBu/r7JeleR1swyDgYlYlmUHylsCQICuOzcZyYh4bDQfuAjTSvDcazpIOul+dFjGqCCutv9v8hAH4DT4CJX1sVrizxQlMv6ahrN9AEOgSVrnO1X9HRwyzokoflurslKj4AOaW0kg6vmKH7EZ/TiOWDt/IgWQdQpCVPKu3GVAOTRa9fsmwYUSWHWbsgAg4qoPAT9kIeuAaJueY8TBBRqES3p4qDIlmg7cfguLhT/vuvnqQthOeNTCLBOE16NXeUxM7S8FXyREm2NXqzxzBDPnlhFRoVb6mFfAkXUOsJ/H0OHbcpuk4sQdM+fgiLgk+nNGFRMUb0r2P8orKPXfmxMQgdGJUsFORaOwl+1ye3kTWMhGnGUbgdIzDQrUIUJQ72qBnf4qehnSQCDQWjBI2epY9U4iBJFxqdU4Yon5E4S5NXKJLGc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB4973.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(39850400004)(396003)(366004)(346002)(136003)(316002)(54906003)(38100700002)(2616005)(186003)(36756003)(2906002)(6506007)(38350700002)(26005)(1076003)(86362001)(110136005)(5660300002)(6512007)(66476007)(4326008)(8676002)(7416002)(44832011)(66556008)(52116002)(8936002)(66946007)(478600001)(6486002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uNXeWJcRGkx7yxLTDpzyOhQGBqVcgtg8tVyjXx55hq14w0Gas2sdc9xeWOLo?=
 =?us-ascii?Q?pBQAsNXpHgxdoWq+/inSY2Yb3YalRtqO2GKDDZC4LplucSMfh5A5mFaZyC39?=
 =?us-ascii?Q?kidfhXrh1ssOu1tU7i8XfxmvRYDOq4mNhevV+xV4k0Jf6c/qZlyrR8SW9dR4?=
 =?us-ascii?Q?miZ7YURridvbugonRIIqGcJCZuL0vqUqPRbD3v7guNqE+r5Ef+I5Lbl4vjcd?=
 =?us-ascii?Q?Sf5RM1hyfoi59G5A4yKLCp+leA7JKc+7IFdt6rQZ7DK6geX75YTOXaNfgaMw?=
 =?us-ascii?Q?v/6qQJFRrRbn04S58y/PyMDPxWkAwuQy9ROYn75dbKRUBMXYnlKjeWfkO6Ul?=
 =?us-ascii?Q?f4WpdGxOSTYVZDKyEvOlZ8E53Kay6fO2H1qwPz5zPz7x9uQ0Y1l284t/W46N?=
 =?us-ascii?Q?I/v1pCMurqOhP3eczespujFSo+ISlAYqNDMl3Y+SxElRyo1S4Bmi8UhFqlEw?=
 =?us-ascii?Q?WW4aqeu8UQ44fAiIVQqIvXAuQbiB1JuO2VdIcpLLfjthKeDAf7ikgK479rUA?=
 =?us-ascii?Q?QlWij1FirsX8aIRkbCSaIVbawznAUXxvVgDgye3t1yYbcfFB4sCyD3/n/kUM?=
 =?us-ascii?Q?pURJUk9RZSZ9m/cMlmmDuYsI9/gZxYxhwdg097H15wWj6eCxh6PfZgqFwDOF?=
 =?us-ascii?Q?kA2voyjLMKG7WST24BanGizxxpKBW5M/qu0XHZp5FhOb2ga5aQVtZbhIlf8r?=
 =?us-ascii?Q?4j1wf9Hj+T8onD7MSgFsEAShq/ArD4ZyadOH58mNPVucZSCCn7YEOWwUcosn?=
 =?us-ascii?Q?GG6oCLa/I4UNrc5cVvuMuU9Sp5e1ZOLe+Vpd9G9Nga9/xaqYfZSk3fhJy98S?=
 =?us-ascii?Q?dCXjiseW7H57B+kn4Pk+80NpDLDIvhHBXvaeJ+Ci84NbIiq6ZCmk8bDDY6rW?=
 =?us-ascii?Q?TFw64+cPUmhocpCgsMrVdFSTqfA0m4or7abBCqxNA+qgWCYVe75aqB4gIdER?=
 =?us-ascii?Q?fMMdoXJzeuZjG6tV4kHLU0y/HPmWhpn26/ZJK4F1qfyXhEt41ZMfTYA9ZCRY?=
 =?us-ascii?Q?98/uyazVOIs6CO5xkk2V5gH+BYqTKDKVf2cQkwBZRrnz10KreJbUgyFoTS7F?=
 =?us-ascii?Q?DsKHHhTVd89hcwrL8eFpamSYchFso08AY9mMlt2EGneWGa9cBETo+kIIspYl?=
 =?us-ascii?Q?BTm8mj4arrT7Aggnp/+aRLTqKwt9MQaSEcir8WPNQ2s98qusg7kzGBGOHbZl?=
 =?us-ascii?Q?FOQAq4ovPvoI5ftN3EHsCg9YB9z62zm1rKL8MHzA2h683aicufIcQ5Yf/X3N?=
 =?us-ascii?Q?oXQEYfS2WQke+E56cP74c7gd7DIbIQZ3ucJ0rQVh+0MTv3l6fqt2SHZArWIo?=
 =?us-ascii?Q?zyG3UlvvcrynjKkKSa3r+UtiBlW7XW18emup6ZbjihyR2XQFxYRo8Z+7L0k1?=
 =?us-ascii?Q?JOUb57IqcwQhgVXdvYGn5SDUhdt2rLJDATTP4z5sz6fSqD8mjpP7wy2grz+o?=
 =?us-ascii?Q?E1F7PAxSuJwfeZlJzFRBawQvvUKXzC7KJL5HR08pBVzffuNtWEhs4s0e5vCq?=
 =?us-ascii?Q?QG3oqJFcsRu34rx1Ae1e7ieFJk5/jn4D24H80xuraieFJfdY7yG8Lh8fM1md?=
 =?us-ascii?Q?cx1gA3PbxrMeAfdydFuS8wJnA4qPdptRP/ewGkKckgW6nyt4ARdNZZkN8m24?=
 =?us-ascii?Q?ag=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1778d27c-a995-4420-73f7-08da66ad9f90
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB4973.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2022 22:01:51.9703
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2M1BbDNlG4ctFnpKKw/4tU8YKqhWsuXhQjv6Xnz9hKE5dD6cKGhcYSJZlW8gywCMSzYhuH62klJ9Hg/lEHsYhw==
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
PCSs.  The exact mapping of QSGMII to MACs depends on the SoC.

Since the first QSGMII PCSs share an address with the SGMII and XFI
PCSs, we only add new nodes for PCSs 2-4. This avoids address conflicts
on the bus.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

Changes in v3:
- Split this patch off from the previous one

Changes in v2:
- New

 .../boot/dts/freescale/fsl-ls1043-post.dtsi   | 24 ++++++++++++++++++
 .../boot/dts/freescale/fsl-ls1046-post.dtsi   | 25 +++++++++++++++++++
 2 files changed, 49 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1043-post.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls1043-post.dtsi
index d237162a8744..02c51690b9da 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1043-post.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1043-post.dtsi
@@ -24,9 +24,12 @@ &fman0 {
 
 	/* these aliases provide the FMan ports mapping */
 	enet0: ethernet@e0000 {
+		pcs-names = "qsgmii";
 	};
 
 	enet1: ethernet@e2000 {
+		pcsphy-handle = <&pcsphy1>, <&qsgmiib_pcs1>;
+		pcs-names = "sgmii", "qsgmii";
 	};
 
 	enet2: ethernet@e4000 {
@@ -36,11 +39,32 @@ enet3: ethernet@e6000 {
 	};
 
 	enet4: ethernet@e8000 {
+		pcsphy-handle = <&pcsphy4>, <&qsgmiib_pcs2>;
+		pcs-names = "sgmii", "qsgmii";
 	};
 
 	enet5: ethernet@ea000 {
+		pcsphy-handle = <&pcsphy5>, <&qsgmiib_pcs3>;
+		pcs-names = "sgmii", "qsgmii";
 	};
 
 	enet6: ethernet@f0000 {
 	};
+
+	mdio@e1000 {
+		qsgmiib_pcs1: ethernet-pcs@1 {
+			compatible = "fsl,lynx-pcs";
+			reg = <0x1>;
+		};
+
+		qsgmiib_pcs2: ethernet-pcs@2 {
+			compatible = "fsl,lynx-pcs";
+			reg = <0x2>;
+		};
+
+		qsgmiib_pcs3: ethernet-pcs@3 {
+			compatible = "fsl,lynx-pcs";
+			reg = <0x3>;
+		};
+	};
 };
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1046-post.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls1046-post.dtsi
index d6caaea57d90..1ce40c35f344 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1046-post.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1046-post.dtsi
@@ -23,6 +23,8 @@ &soc {
 &fman0 {
 	/* these aliases provide the FMan ports mapping */
 	enet0: ethernet@e0000 {
+		pcsphy-handle = <&qsgmiib_pcs3>;
+		pcs-names = "qsgmii";
 	};
 
 	enet1: ethernet@e2000 {
@@ -35,14 +37,37 @@ enet3: ethernet@e6000 {
 	};
 
 	enet4: ethernet@e8000 {
+		pcsphy-handle = <&pcsphy4>, <&qsgmiib_pcs1>;
+		pcs-names = "sgmii", "qsgmii";
 	};
 
 	enet5: ethernet@ea000 {
+		pcsphy-handle = <&pcsphy5>, <&pcsphy5>;
+		pcs-names = "sgmii", "qsgmii";
 	};
 
 	enet6: ethernet@f0000 {
 	};
 
 	enet7: ethernet@f2000 {
+		pcsphy-handle = <&pcsphy7>, <&qsgmiib_pcs2>, <&pcsphy7>;
+		pcs-names = "sgmii", "qsgmii", "xfi";
+	};
+
+	mdio@eb000 {
+		qsgmiib_pcs1: ethernet-pcs@1 {
+			compatible = "fsl,lynx-pcs";
+			reg = <0x1>;
+		};
+
+		qsgmiib_pcs2: ethernet-pcs@2 {
+			compatible = "fsl,lynx-pcs";
+			reg = <0x2>;
+		};
+
+		qsgmiib_pcs3: ethernet-pcs@3 {
+			compatible = "fsl,lynx-pcs";
+			reg = <0x3>;
+		};
 	};
 };
-- 
2.35.1.1320.gc452695387.dirty

