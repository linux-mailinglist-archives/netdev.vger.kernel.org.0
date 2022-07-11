Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 412FE5707F8
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 18:07:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231907AbiGKQG6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 12:06:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230150AbiGKQGj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 12:06:39 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2059.outbound.protection.outlook.com [40.107.22.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 041B670E67;
        Mon, 11 Jul 2022 09:06:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KEwhWuZDy6gjvPnMsEYHNQT5fcFG4V06fidvuDlLYWrRtImZJQN13nHeBSxUHZqdgxpKEVUVOlPD3KG3Ximc9W1z2hxVMdSr+z21QGimFEUWrWjTyn1VnhFCM3ga7skrjZ9N/YpOegBGXbjbknzsEBFdJQVVW2SxtzeOQ/cuSAxfJTOalZQiv4VtgixgE2Q7Le4y0/euPtG16GUGYsCwA+y99wG53Z75WZNjkEx3dLYInAb2j6yr72GtyocMjXh64NSAZdJp3Wfr7o6t8p/j3/FqxJnVXdCTEJ3ozbqhVMrQoTBcQzP+w3vwUxoA4NGSfjHZX5gGTmzmZ2HkxPmMsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=37YWCy9jRz6TqCG7bmXi+Z4wefx1d4OKtFt1N83LAtw=;
 b=fOY7JBfxyj+saEwyTFRk6bhH7LLflEFuzCv4avVcJpX/lVI0wt1OaJFTQMW3BgZN7EEffbB/2ngF+xDly729UtYQa0bKGaOtKdExceIpsTuSEnnEWlPMWJiCX1wAdwP/lQ6iYU4LQqg4F+4QIJIfyxbvwmzn0nj3pmwgjju9feoOf6036c7IpHmZfae4pcDwzvpxcHGOAlAF8aJI/EyLhjzXjKTu2uzdjpxPZWFHxKAzPjFMO7JVtOV2L229ZrSHZLUZulQrvR4jtgS2F5SMDYjxVhCEohG73VpyG5EbBsNdsSonvQbZF/vZuA7uL9Y3BsCrdYUfGxXyhFDuzTxlmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=37YWCy9jRz6TqCG7bmXi+Z4wefx1d4OKtFt1N83LAtw=;
 b=IOkTp+6rE1C1uvbf0zZSbE3kwrYKz9HjqHsivjWnBLHoUUixfMf5Tku1Han47G5qweazI+nSDRnBlCpkm4/mLH8AUItjN2xf+DIkOmjIKpO2UkAX04qSgl7FXhBnSBDBLiGVI4nmyfhSwq++F01xjgILOPHV2rgbecdiCK2joKEQpHDR60F6NoNUjRBeutnBlUZTK7PH3BG6+Sih1fe2p7NNY+lR1WYNlck5UNLIQBUrbkERCslcF8Jx/h8dpY5iGv/7nfIn9E1upht3/WTiJkPQmGcdsGNZaE7wZNYq4okTGF5wAxSfgSs+TA9s6XV0OYxxYI9U061y5WVUcPaZ4A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB7PR03MB5113.eurprd03.prod.outlook.com (2603:10a6:10:77::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.26; Mon, 11 Jul
 2022 16:05:57 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5417.026; Mon, 11 Jul 2022
 16:05:57 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Sean Anderson <sean.anderson@seco.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [RFC PATCH net-next 8/9] powerpc: dts: Add compatible strings for Lynx PCSs
Date:   Mon, 11 Jul 2022 12:05:18 -0400
Message-Id: <20220711160519.741990-9-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220711160519.741990-1-sean.anderson@seco.com>
References: <20220711160519.741990-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR16CA0056.namprd16.prod.outlook.com
 (2603:10b6:208:234::25) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2fd540a4-2e76-4156-da14-08da63573d66
X-MS-TrafficTypeDiagnostic: DB7PR03MB5113:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: azXGz15jR1qmKnoAoA52nufStXxQtE+IHbZ/sJbosAZGIMqEhS0vrU/xLYNZYQTq7IgK6lo4dMC2HOLA6gqePI1w8I7GJSrJ6jBTGbJx3rxgHbHfl71nQvlq4x/s9geb5kkCFcno2R+iqJV6RvS3XxMNQA/ua1vYkAjEkGGTZ7zQeZkeZLT3AZrn5pdbUQ69oz5md2kwKDtdqFzaBrYvjihB0A/ueLzjGakm8qXtpLlC/SarNZ+UvPsSBI2pQ02bsh8QYYCRP5OEWCKSzsS9ZloetqmUn5sNc3JBYDGJJxF/rX3EihQ80963tnwjZX0uuGjvIC5rwJE4Wwwwa/+SxW9ozjwrjb0vONh917BnZJrihc+0XiZbJDYOt+sZI6wU7aiABKUxzgfBT/VGvso++sH6UcppH3uO/n+NUswF8TZDa5tCST4IG3f/Pwui/1pCrY2vvO515siPqcZ6UomxNPZurr66nCJg5iRuqRWZ9953VFCPE2VY4gR1IC6dLLV4o50wYIBZIOl6+OaIud99JuL/1WnYfwfVXe+hWgksiP062ZOa9iSCfTp3VPAdmb8rsjqW8MbEsvmX8MxTEmc0j8GEZx0F8i9GRtqOVgey8rMaNM5DockucpbNkNfOMU1I35be2LoADfXbEEby/je8Gn8o7vLH5HUZAn5OntFmF480Dfd0CTg0IZ2XBJBfdlYBjyYdjhYo6BDGwZoVnRNmME3u5E+FWv6Bs0CxCWFbB7LHfW87mCuIiAYVCILbTG8qt5Acn3bSJDwcavyTT422oRPOE6CFzWIhcLzO9ucbqN8RM6lDugBScVGBdrXb/Afu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(136003)(396003)(376002)(39850400004)(366004)(83380400001)(86362001)(38350700002)(66946007)(38100700002)(4326008)(8936002)(66556008)(66476007)(8676002)(36756003)(6512007)(316002)(54906003)(30864003)(5660300002)(44832011)(6666004)(7416002)(2906002)(6506007)(41300700001)(26005)(6486002)(52116002)(478600001)(110136005)(186003)(1076003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tgEVHvCgATT06zsLf1qbIS1iUo6JNzv5SAtCwLxxrt/9ZQN7FrhOjcqOXPWw?=
 =?us-ascii?Q?k/Sp85+6OVp5cgShmTv69UXycvR+MOeXxoCEbOUm4/1wWzTp9aiB27xlH0JE?=
 =?us-ascii?Q?rKebq4kZk0IvtP0AXe0mvCNY9Dk+fWD4VCgdEQ0DKn6kjx0JkK0gFcUJvBHP?=
 =?us-ascii?Q?CI8jhojnsk92IHpdReYOhse2KlOpM0BbFZSItnQGmrpTkEYtwODtpB30WFf7?=
 =?us-ascii?Q?aGvx2V39PxxVXcw6OgUGELg4UPbL4+hTk8RbnAWiZjVzzyndQok6oj1NLgM/?=
 =?us-ascii?Q?J04OcV3aHA8U3p7kXdmTw+msH5bZjYGjF7pIuH0NhNYFoiDFDpRcoQ/7bHLw?=
 =?us-ascii?Q?m2tEiDSkLjfBisnmToK+Qx5rbpFKUguyBuAIMmyc8rhSMV7RRnaCo1dUk6OI?=
 =?us-ascii?Q?Ha8myjgu0lqBaHRYocOh4sfv0Si/Fa471kCqvn8X6ox32vzfoIUkyBA1SGe7?=
 =?us-ascii?Q?IVhCZGIdOCcUoJ4kWJM97O63O1KeLg93ZiVM0JNuGTaimgGHqhZzQYZbgt1f?=
 =?us-ascii?Q?H6C+xgH7yDkRtefiJ+4uJxAhdkT/YYg730tMe7YhU7J+qqwBb5jtqvgneJGB?=
 =?us-ascii?Q?E/uWZrGX0Ti9CmNu4fiDvDkowgOJjCrRYkoAKkgKv0za1vWA9Usy0WMVNR9f?=
 =?us-ascii?Q?64JmWAYZpfD7xctBNDD//nDrkY4WH037I/z/k+8hLm5AyeSTRsQiQfmY5D9d?=
 =?us-ascii?Q?w1goZW8L5aGExhd++cGLOY/1RqxuZ+SqfpiXkx6aOuWw+PGrA+6HcxuQv89G?=
 =?us-ascii?Q?kxmzvgAICbshYh1DPVSN1mKmJ7MTprGgxH630/NrLaCY9uWLaUAEtyCnBuZG?=
 =?us-ascii?Q?EvHzrNoXVYIoYd2G8wa9wFzPsLlvQapRh4ztq/FxjWmWUDiq+jaX3VNyGniq?=
 =?us-ascii?Q?g0iEc3kzP+unzdKeOy7dgtXufdwpNA/Piy+YfrGU8+52iLNLlixCdmaVRsx/?=
 =?us-ascii?Q?kg0/2pXqMWX/e/WxOPs7bron37WgYAGlywd2mIM906NEtNrha8buy8pMT1nf?=
 =?us-ascii?Q?KO4n81IyIJBeHqNsbqrLSiuKaPLUdfYlQjtCLWzS2nNQ+LyhgYSaHfnJ8cdx?=
 =?us-ascii?Q?OmHqJ+Mnz+vZD5OY3wWc9/ajyOKtH6wn255mBdHqvxaw7+c6z/jbgh9qSr40?=
 =?us-ascii?Q?Z79ZM4pejd0lNnB3xI1P6I2HaEGZymexpoLzxDqVojNCmJ4t9rrlbkYR3Drw?=
 =?us-ascii?Q?ruhXhj8WvWa45fz3AHkAGMQvfsbsCVgYNTkXwXks2VMWNaZADSYgQBxZNQsS?=
 =?us-ascii?Q?83mGo34uBEoJGVvu/5tyLIHwuU8YA1fRQZLpumNp401EKF4CjNJq1EIGTr7Q?=
 =?us-ascii?Q?lPcY+BuYYz4CfJ4lLcbzVQkRczHCAsvxbNdlMXlUuytJyrwVy10H6cH8N4y5?=
 =?us-ascii?Q?TmJbWKQICeXV/1py2pyCe0BQhlMAdbxBH+YBLMk8aKI23njeiPrltd+EBgoc?=
 =?us-ascii?Q?hdfP6qDowDsELMe6p51ag0vnulyB2NwKc5VqpiL26UI8axKtHodjWv1jqgKO?=
 =?us-ascii?Q?ua+E5/uOe7rAJ4bKs3dnsNbBJZMrBSJgaN8lhk4rl5wwzvBxcFNNjhVswOhu?=
 =?us-ascii?Q?usDUBx8QA2/LbyPoLi2O9Zvajzt4BI0YWkrZGzRkG8VXWiPwM5qk0Tpce6ua?=
 =?us-ascii?Q?Yw=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fd540a4-2e76-4156-da14-08da63573d66
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2022 16:05:57.1364
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kurvTXOqib125dMSagdWi4qRyZZfhTf+kcd9qihqFoZ/X9RH/EbnfxRPZwcc0HjPdG0yeEg6EXgAYlymZkcQ+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB5113
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds appropriate compatible strings for Lynx PCSs on PowerPC QorIQ
platforms. This also changes the node name to avoid warnings from
ethernet-phy.yaml.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0-best-effort.dtsi | 3 ++-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0.dtsi             | 3 ++-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1-best-effort.dtsi | 3 ++-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1.dtsi             | 3 ++-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-0.dtsi              | 3 ++-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-1.dtsi              | 3 ++-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-2.dtsi              | 3 ++-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-3.dtsi              | 3 ++-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-4.dtsi              | 3 ++-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-5.dtsi              | 3 ++-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-0.dtsi             | 3 ++-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-1.dtsi             | 3 ++-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-0.dtsi              | 3 ++-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-1.dtsi              | 3 ++-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-2.dtsi              | 3 ++-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-3.dtsi              | 3 ++-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-4.dtsi              | 3 ++-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-5.dtsi              | 3 ++-
 18 files changed, 36 insertions(+), 18 deletions(-)

diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0-best-effort.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0-best-effort.dtsi
index baa0c503e741..b0bb58121440 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0-best-effort.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0-best-effort.dtsi
@@ -65,7 +65,8 @@ mdio@e1000 {
 		reg = <0xe1000 0x1000>;
 		fsl,erratum-a011043; /* must ignore read errors */
 
-		pcsphy0: ethernet-phy@0 {
+		pcsphy0: ethernet-pcs@0 {
+			compatible = "fsl,lynx-pcs";
 			reg = <0x0>;
 		};
 	};
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0.dtsi
index 93095600e808..67765c49c6dd 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0.dtsi
@@ -62,7 +62,8 @@ mdio@f1000 {
 		reg = <0xf1000 0x1000>;
 		fsl,erratum-a011043; /* must ignore read errors */
 
-		pcsphy6: ethernet-phy@0 {
+		pcsphy6: ethernet-pcs@0 {
+			compatible = "fsl,lynx-pcs";
 			reg = <0x0>;
 		};
 	};
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1-best-effort.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1-best-effort.dtsi
index ff4bd38f0645..5b5f1768507f 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1-best-effort.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1-best-effort.dtsi
@@ -65,7 +65,8 @@ mdio@e3000 {
 		reg = <0xe3000 0x1000>;
 		fsl,erratum-a011043; /* must ignore read errors */
 
-		pcsphy1: ethernet-phy@0 {
+		pcsphy1: ethernet-pcs@0 {
+			compatible = "fsl,lynx-pcs";
 			reg = <0x0>;
 		};
 	};
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1.dtsi
index 1fa38ed6f59e..c1b4a9cf8435 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1.dtsi
@@ -62,7 +62,8 @@ mdio@f3000 {
 		reg = <0xf3000 0x1000>;
 		fsl,erratum-a011043; /* must ignore read errors */
 
-		pcsphy7: ethernet-phy@0 {
+		pcsphy7: ethernet-pcs@0 {
+			compatible = "fsl,lynx-pcs";
 			reg = <0x0>;
 		};
 	};
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-0.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-0.dtsi
index a8cc9780c0c4..f4f7445a261c 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-0.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-0.dtsi
@@ -61,7 +61,8 @@ mdio@e1000 {
 		reg = <0xe1000 0x1000>;
 		fsl,erratum-a011043; /* must ignore read errors */
 
-		pcsphy0: ethernet-phy@0 {
+		pcsphy0: ethernet-pcs@0 {
+			compatible = "fsl,lynx-pcs";
 			reg = <0x0>;
 		};
 	};
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-1.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-1.dtsi
index 8b8bd70c9382..78bf1c1e09c2 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-1.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-1.dtsi
@@ -61,7 +61,8 @@ mdio@e3000 {
 		reg = <0xe3000 0x1000>;
 		fsl,erratum-a011043; /* must ignore read errors */
 
-		pcsphy1: ethernet-phy@0 {
+		pcsphy1: ethernet-pcs@0 {
+			compatible = "fsl,lynx-pcs";
 			reg = <0x0>;
 		};
 	};
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-2.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-2.dtsi
index 619c880b54d8..432e3da63584 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-2.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-2.dtsi
@@ -61,7 +61,8 @@ mdio@e5000 {
 		reg = <0xe5000 0x1000>;
 		fsl,erratum-a011043; /* must ignore read errors */
 
-		pcsphy2: ethernet-phy@0 {
+		pcsphy2: ethernet-pcs@0 {
+			compatible = "fsl,lynx-pcs";
 			reg = <0x0>;
 		};
 	};
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-3.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-3.dtsi
index d7ebb73a400d..a92d88685b91 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-3.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-3.dtsi
@@ -61,7 +61,8 @@ mdio@e7000 {
 		reg = <0xe7000 0x1000>;
 		fsl,erratum-a011043; /* must ignore read errors */
 
-		pcsphy3: ethernet-phy@0 {
+		pcsphy3: ethernet-pcs@0 {
+			compatible = "fsl,lynx-pcs";
 			reg = <0x0>;
 		};
 	};
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-4.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-4.dtsi
index b151d696a069..af70c159d030 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-4.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-4.dtsi
@@ -61,7 +61,8 @@ mdio@e9000 {
 		reg = <0xe9000 0x1000>;
 		fsl,erratum-a011043; /* must ignore read errors */
 
-		pcsphy4: ethernet-phy@0 {
+		pcsphy4: ethernet-pcs@0 {
+			compatible = "fsl,lynx-pcs";
 			reg = <0x0>;
 		};
 	};
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-5.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-5.dtsi
index adc0ae0013a3..da46fd9aab2e 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-5.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-5.dtsi
@@ -61,7 +61,8 @@ mdio@eb000 {
 		reg = <0xeb000 0x1000>;
 		fsl,erratum-a011043; /* must ignore read errors */
 
-		pcsphy5: ethernet-phy@0 {
+		pcsphy5: ethernet-pcs@0 {
+			compatible = "fsl,lynx-pcs";
 			reg = <0x0>;
 		};
 	};
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-0.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-0.dtsi
index 435047e0e250..50c1b75c073f 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-0.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-0.dtsi
@@ -62,7 +62,8 @@ mdio@f1000 {
 		reg = <0xf1000 0x1000>;
 		fsl,erratum-a011043; /* must ignore read errors */
 
-		pcsphy14: ethernet-phy@0 {
+		pcsphy14: ethernet-pcs@0 {
+			compatible = "fsl,lynx-pcs";
 			reg = <0x0>;
 		};
 	};
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-1.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-1.dtsi
index c098657cca0a..03ed8d83adde 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-1.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-1.dtsi
@@ -62,7 +62,8 @@ mdio@f3000 {
 		reg = <0xf3000 0x1000>;
 		fsl,erratum-a011043; /* must ignore read errors */
 
-		pcsphy15: ethernet-phy@0 {
+		pcsphy15: ethernet-pcs@0 {
+			compatible = "fsl,lynx-pcs";
 			reg = <0x0>;
 		};
 	};
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-0.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-0.dtsi
index 9d06824815f3..ced05a914e36 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-0.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-0.dtsi
@@ -61,7 +61,8 @@ mdio@e1000 {
 		reg = <0xe1000 0x1000>;
 		fsl,erratum-a011043; /* must ignore read errors */
 
-		pcsphy8: ethernet-phy@0 {
+		pcsphy8: ethernet-pcs@0 {
+			compatible = "fsl,lynx-pcs";
 			reg = <0x0>;
 		};
 	};
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-1.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-1.dtsi
index 70e947730c4b..de6be3e6db36 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-1.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-1.dtsi
@@ -61,7 +61,8 @@ mdio@e3000 {
 		reg = <0xe3000 0x1000>;
 		fsl,erratum-a011043; /* must ignore read errors */
 
-		pcsphy9: ethernet-phy@0 {
+		pcsphy9: ethernet-pcs@0 {
+			compatible = "fsl,lynx-pcs";
 			reg = <0x0>;
 		};
 	};
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-2.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-2.dtsi
index ad96e6529595..053cb568529e 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-2.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-2.dtsi
@@ -61,7 +61,8 @@ mdio@e5000 {
 		reg = <0xe5000 0x1000>;
 		fsl,erratum-a011043; /* must ignore read errors */
 
-		pcsphy10: ethernet-phy@0 {
+		pcsphy10: ethernet-pcs@0 {
+			compatible = "fsl,lynx-pcs";
 			reg = <0x0>;
 		};
 	};
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-3.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-3.dtsi
index 034bc4b71f7a..448a73c24d1c 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-3.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-3.dtsi
@@ -61,7 +61,8 @@ mdio@e7000 {
 		reg = <0xe7000 0x1000>;
 		fsl,erratum-a011043; /* must ignore read errors */
 
-		pcsphy11: ethernet-phy@0 {
+		pcsphy11: ethernet-pcs@0 {
+			compatible = "fsl,lynx-pcs";
 			reg = <0x0>;
 		};
 	};
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-4.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-4.dtsi
index 93ca23d82b39..5d388ab4268b 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-4.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-4.dtsi
@@ -61,7 +61,8 @@ mdio@e9000 {
 		reg = <0xe9000 0x1000>;
 		fsl,erratum-a011043; /* must ignore read errors */
 
-		pcsphy12: ethernet-phy@0 {
+		pcsphy12: ethernet-pcs@0 {
+			compatible = "fsl,lynx-pcs";
 			reg = <0x0>;
 		};
 	};
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-5.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-5.dtsi
index 23b3117a2fd2..fb262d9e0c01 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-5.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-5.dtsi
@@ -61,7 +61,8 @@ mdio@eb000 {
 		reg = <0xeb000 0x1000>;
 		fsl,erratum-a011043; /* must ignore read errors */
 
-		pcsphy13: ethernet-phy@0 {
+		pcsphy13: ethernet-pcs@0 {
+			compatible = "fsl,lynx-pcs";
 			reg = <0x0>;
 		};
 	};
-- 
2.35.1.1320.gc452695387.dirty

