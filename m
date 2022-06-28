Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E60655F138
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 00:32:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232240AbiF1WTM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 18:19:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232077AbiF1WS5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 18:18:57 -0400
Received: from EUR03-VE1-obe.outbound.protection.outlook.com (mail-eopbgr50053.outbound.protection.outlook.com [40.107.5.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E1593C486;
        Tue, 28 Jun 2022 15:15:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y3HH6Dq6w1LNx2uM1AEBCzdLIM2Y9N3vPytv/mihs2gJcgn870SHka1KaiKPjZGHIcjC6tgnVoU7MTc3IQKA5xKevhtE2nKWgy0qK018voiD8JEND5UiMK9uZNGvuIFGo1unehAVwVTn26AuTGFUS09Sayf70jHBIjX+Ol9v70yrQ9ChmzGqguvsH21EwUwAp5chHMu/4H6gnJ7H8wWh7YT+82wyJNVJo9YKyYcv8XsUm/TORw1V674yMGbIb2bRtAeMcrQ55xkzV1VwgLRBuHLRBOAT1fqXdtjzfojxzAEUr54Jd9pTz8qLr2adpFxGaa99f8JoJBfgVeeMkw2iYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PcuUzxjM6Ktl104Z1vNFaPuXxflg9iQleOwtKYSqx4A=;
 b=Eqy3T67LHyJv94D/6gEL02WfaSqPZBQgBZgAgU7hPwABcNqPd5dUb2NNp28RNyjmV1S5qF60djYxFgzVFkD85NDfNmTeYfPGuox5muFm236o8fdSHc820jpOuw8d7A6tGD9CBIyzU4qEOQheTKrvOHXNsKEh1HL87HyelhmyJGV/oTWmt13cXyIXeocDADcKFR3jseZtVN4POxhvS+l/Ts5YhvejllKNjgwGn4iSdnMXJQTCqVHTzTXaCGK/aWGZKKV9EtpU9Xa8T0QwwPgKCkFWX6T7sOHe2ou/wlZwKNcIExVyvfmd/C0XuaxzjxbcMlDwRT07T7sqzEG2QK3nHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PcuUzxjM6Ktl104Z1vNFaPuXxflg9iQleOwtKYSqx4A=;
 b=jPEIBDMiQCTRhtHpFFa6maWdh5qnDFdUtDTb+1viD7duSVx8qbniXgjyxJjZ456iaIHfUAsvKHqzeShUV8EqesV6lHH7H4VxBGTraCX+C12qFVHUHVSPOdkLv+u0kpbEhEmY7cR1VdOy5u6UlMR3qy7syrwbcAwhx6VjXuAi9LltkZwapLvvhqpT4E+iZea8DgxcNiTo8RKIX4aFOx3m8GjvIGwrvp+ggvYa36pymZkb/VJpFsbDfTa5wz2kvLbuZlzT6D0PtDvCU11p9egK6sGj0l2AtkErwtYnMw8tbatD2hquyuHjhU5EImtdWdPpK6OBzZTbNAIPgid8sp3tSw==
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
Subject: [PATCH net-next v2 32/35] qoriq: Specify which MACs support RGMII
Date:   Tue, 28 Jun 2022 18:14:01 -0400
Message-Id: <20220628221404.1444200-33-sean.anderson@seco.com>
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
X-MS-Office365-Filtering-Correlation-Id: c5572a4d-d4c9-4f70-95a0-08da5953a9d9
X-MS-TrafficTypeDiagnostic: DB7PR03MB3883:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HGDUT3vul2ZSKNTJJAl+QaSRq9PV6s7GIe+GnaM2YoEfkfad97fGtiqm4vEOKN8bnNJXKSxV4Cb7AhwN1c7+1AOsL5ICtlGpjjeGcF6ZKSlBXEVpzBQSnJ6Wd8YODW1oeQwcfewFLtPGx5NlL08t1fp38PZ58HYgZ0JbQuEgbQ/JDbbW69VwuwW+BuUcor1w5v9NRVg2BT9wAqG1lAvThVqqnJSMvwLROm3nxvms6j8ShG1o0ZNYvkdjSmVFzaKf9/aVidKBa1PvJWq8UPYi6s9QWThKUyMkFRTPCD3L9SDvCsWbVaAuFZnq7HRRgoVc2Z+NhjMdSdfFiEEKv5fgV1ySiooqmKO0cDTTkeqhlnBNZfx3qMtDADzHnLDznaIdXHlvalf2TinYgGn6E4T85Zbfs41HjlCEhDA3L4RxbiPvk1/e5RmLHL6NjoU9YYTZU8IL97OxjJGOMzad4nPgbUdnVkbWg3Y5PrALJe0ICFyDJ2itIXtlD900c9cr57GkUknj2QY3gAt/Ku/eoeaheUHijA4vro/eyWT955ed4kR5LRvsn4x/sQRevL34c6XTb8/tO0s0zlMzNFIgvbr5Mw2oEZpJ9Rww4XspsFR8LAAp9k32vimvfwy8iFi0458JOroJcax7pY1loL79sTyskG7vlHU2pQa4RqyyEn63+/FCUaoDFLtxbzmVojx9RcAIkFJ12WoGGOM4hC2FjBur4DC/ikykVbXoWunmIc8C5M27cWYFzCE1MyHo9GaAShvgZZESwTtR4T7pgm86wEuWWo3Pv6XF06RrJrSRrJdArEI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(396003)(366004)(39850400004)(136003)(376002)(52116002)(6512007)(6506007)(8676002)(38100700002)(36756003)(66556008)(66946007)(38350700002)(66476007)(2906002)(26005)(1076003)(7416002)(86362001)(54906003)(41300700001)(83380400001)(2616005)(6486002)(110136005)(316002)(6666004)(186003)(4326008)(44832011)(5660300002)(478600001)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?R0TXCoG7fHTaN4qwQT5gFVbak6pVtCbmXuB69VuIKyxFW9D1VrbE0FHvzZrd?=
 =?us-ascii?Q?HmUyHme5fsdsF2w85e2Va9f8CtYsJYh4OwS2B9QFPP685SYmRlPEhhE/gR/K?=
 =?us-ascii?Q?HIykVMtFEWQI/kXLItT7PKEE72TmAMH5iXX9ZDVylHn8KePOuf9dEUAJmRM3?=
 =?us-ascii?Q?XUDOl2YsgX3gTpErGXvhUjRxJBcrJVTTp63on9PUJtoUo9n3VxjN8kP8kG9B?=
 =?us-ascii?Q?QDd4abZqzw8ei3Nr+mhlGSGMRrioWJ730CG1C96GoAy7KithWXUlYvSl4VT5?=
 =?us-ascii?Q?4NRz8UcU2Nung0PmicwlLHTcqmmsaS8UO+bNoXTxCAkSjvrInFkWXpgtmOXw?=
 =?us-ascii?Q?TG5Stby6dCG7Cehft+LeXAEOhADrIfix0oJmu53IknFRk9va/MO4UAybeE40?=
 =?us-ascii?Q?mkjKZs5wPZJX9zHTbSaLC8lDLy5n+0N+O2CeOKHInFZXuKyXq+P7bdiRhxYH?=
 =?us-ascii?Q?KG4pQ3ZyGfdSqGl8H0oO64JN4B7Umc8cVhVSONOv2ijP4M+sQ0P802Evreat?=
 =?us-ascii?Q?zTYgludMSnGF3QgMR7xEvJwinnkB/dNm6w6TyZIs3EdCjfnuxxjnVNnK4wrk?=
 =?us-ascii?Q?Cq/4MlLdhzFI6bLZHZkblc6xGOlpQ/nXaEvdS5vXxsyzT5QtPz8e3BMt30qm?=
 =?us-ascii?Q?XOnovyL4RRn0pFpHsy2Zk+6HdlMVzL9s9/KW8KFkg2xOJRLqNkN4jDO64OZt?=
 =?us-ascii?Q?7GV/8GXLcCYtFP7UUa055zh+42HB65ESdbxixKflIGmaQA8KEM2CBVJ5QiEo?=
 =?us-ascii?Q?CrbSV3oMB1wifla9LpiU9Z8Gl3Yk3/Ofm+wTITWXeWkCwD110jvMKw3cu/GL?=
 =?us-ascii?Q?+u1JwCZb6K/xW2vl/OaviNNr+92jb7sPk3dt/4sVShFZuhnA6a6Xr8uV5XLz?=
 =?us-ascii?Q?r+f0MnHQ8Ao//Qrp+hCdETOKo+PtYTTBf3wAARdWgXyvjhNBIU0DA4eyWKG3?=
 =?us-ascii?Q?UPfSIe+lcXxGEBprrEmf9S4L0XDqeOEWiLHaTshafPjOQ6OiHdQCtudTaIBP?=
 =?us-ascii?Q?pD1J78v6uaAc8BK7FjgxLWbrD+okoszqz0sug/UVH/q+106QHshyWsTpBkuJ?=
 =?us-ascii?Q?CldOHfIGmv9+5S0BZMhh7hSpsRBq3LsUvh3/RRtoN71N52CCkSF9wapvVKqE?=
 =?us-ascii?Q?qZycUCOKE12oilEzGgjcOjo25QB/8F9iKVcpmenbM+JZ7Ky6i8It8LnzYbbL?=
 =?us-ascii?Q?asT9TP21gBL4prRMEqhBn9u3XAjQyK3LCiZ8Ls3oA/E9VH0JswxttWuTtJ6+?=
 =?us-ascii?Q?1Y8zzJSXYFI7n+EdqWs8XBbIGyL100I5Xpe0kpAfi1d5ZjGJww8tLDPX7Hdf?=
 =?us-ascii?Q?8Qvr+9nCJc8MGlNAObxbvOEwpeihivnvuUOkdQwnE6wWHnDzRMBqLT6UAgBy?=
 =?us-ascii?Q?QE9T9VCcOVEC0Sx+jUH4/mAIrxtTFob/K7rWl7swBwnFvkLGHlvlbgk4oqQ1?=
 =?us-ascii?Q?WGVFnDIwhr/XfOU3XvtOM4ftKg1Kr/mdkqcs7ldvTWag/iqkTjmNze9VtnyI?=
 =?us-ascii?Q?hY7D7d4bnBYSdGiyQqoXhuvr0TG/c+l61S9TDH2WeuYXjXkf63aBj/ff3cSF?=
 =?us-ascii?Q?Qtx3hf4Uj19mJtVz+wBZ/haY2Gyp9rHthK8kF35rKF7yuAm4DQAm7hVzPNp4?=
 =?us-ascii?Q?Zw=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5572a4d-d4c9-4f70-95a0-08da5953a9d9
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 22:15:09.4675
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QNYF79gWqnI5cjC5P8GgpZ0orHXRWO7nXNCTxSood7GUSklkfcqNnJIy5n1vUYgDBIhFWnZWrUCCsePuI9RN3w==
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

For more precise link mode support, we can add a property specifying
which MACs support RGMII. This silences the warning

	missing 'rgmii' property; assuming supported

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

Changes in v2:
- Add rgmii property to all DPAA MACs

 .../boot/dts/freescale/fsl-ls1043-post.dtsi      |  7 +++++++
 .../boot/dts/freescale/fsl-ls1046-post.dtsi      |  8 ++++++++
 arch/powerpc/boot/dts/fsl/b4860si-post.dtsi      |  4 ++++
 arch/powerpc/boot/dts/fsl/b4si-post.dtsi         |  4 ++++
 arch/powerpc/boot/dts/fsl/t1023si-post.dtsi      |  4 ++++
 arch/powerpc/boot/dts/fsl/t1040si-post.dtsi      |  7 +++++++
 arch/powerpc/boot/dts/fsl/t2081si-post.dtsi      |  8 ++++++++
 arch/powerpc/boot/dts/fsl/t4240si-post.dtsi      | 16 ++++++++++++++++
 8 files changed, 58 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1043-post.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls1043-post.dtsi
index d237162a8744..f12d860a2ed4 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1043-post.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1043-post.dtsi
@@ -24,23 +24,30 @@ &fman0 {
 
 	/* these aliases provide the FMan ports mapping */
 	enet0: ethernet@e0000 {
+		rgmii = <0>;
 	};
 
 	enet1: ethernet@e2000 {
+		rgmii = <0>;
 	};
 
 	enet2: ethernet@e4000 {
+		rgmii = <1>;
 	};
 
 	enet3: ethernet@e6000 {
+		rgmii = <1>;
 	};
 
 	enet4: ethernet@e8000 {
+		rgmii = <0>;
 	};
 
 	enet5: ethernet@ea000 {
+		rgmii = <0>;
 	};
 
 	enet6: ethernet@f0000 {
+		rgmii = <0>;
 	};
 };
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1046-post.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls1046-post.dtsi
index d6caaea57d90..4bb314388a72 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1046-post.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1046-post.dtsi
@@ -23,26 +23,34 @@ &soc {
 &fman0 {
 	/* these aliases provide the FMan ports mapping */
 	enet0: ethernet@e0000 {
+		rgmii = <0>;
 	};
 
 	enet1: ethernet@e2000 {
+		rgmii = <0>;
 	};
 
 	enet2: ethernet@e4000 {
+		rgmii = <1>;
 	};
 
 	enet3: ethernet@e6000 {
+		rgmii = <1>;
 	};
 
 	enet4: ethernet@e8000 {
+		rgmii = <0>;
 	};
 
 	enet5: ethernet@ea000 {
+		rgmii = <0>;
 	};
 
 	enet6: ethernet@f0000 {
+		rgmii = <0>;
 	};
 
 	enet7: ethernet@f2000 {
+		rgmii = <0>;
 	};
 };
diff --git a/arch/powerpc/boot/dts/fsl/b4860si-post.dtsi b/arch/powerpc/boot/dts/fsl/b4860si-post.dtsi
index 868719821106..68f68f8cfa4e 100644
--- a/arch/powerpc/boot/dts/fsl/b4860si-post.dtsi
+++ b/arch/powerpc/boot/dts/fsl/b4860si-post.dtsi
@@ -264,15 +264,19 @@ rcpm: global-utilities@e2000 {
 /include/ "qoriq-fman3-0-10g-1.dtsi"
 	fman@400000 {
 		enet4: ethernet@e8000 {
+			rgmii = <0>;
 		};
 
 		enet5: ethernet@ea000 {
+			rgmii = <0>;
 		};
 
 		enet6: ethernet@f0000 {
+			rgmii = <0>;
 		};
 
 		enet7: ethernet@f2000 {
+			rgmii = <0>;
 		};
 	};
 
diff --git a/arch/powerpc/boot/dts/fsl/b4si-post.dtsi b/arch/powerpc/boot/dts/fsl/b4si-post.dtsi
index 4f044b41a776..5e50b96e6b52 100644
--- a/arch/powerpc/boot/dts/fsl/b4si-post.dtsi
+++ b/arch/powerpc/boot/dts/fsl/b4si-post.dtsi
@@ -465,15 +465,19 @@ muram@0 {
 		};
 
 		enet0: ethernet@e0000 {
+			rgmii = <0>;
 		};
 
 		enet1: ethernet@e2000 {
+			rgmii = <0>;
 		};
 
 		enet2: ethernet@e4000 {
+			rgmii = <0>;
 		};
 
 		enet3: ethernet@e6000 {
+			rgmii = <0>;
 		};
 
 		mdio@fc000 {
diff --git a/arch/powerpc/boot/dts/fsl/t1023si-post.dtsi b/arch/powerpc/boot/dts/fsl/t1023si-post.dtsi
index d552044c5afc..e2a7bf643393 100644
--- a/arch/powerpc/boot/dts/fsl/t1023si-post.dtsi
+++ b/arch/powerpc/boot/dts/fsl/t1023si-post.dtsi
@@ -508,15 +508,19 @@ sata@220000 {
 /include/ "qoriq-fman3-0-1g-3.dtsi"
 	fman@400000 {
 		enet0: ethernet@e0000 {
+			rgmii = <0>;
 		};
 
 		enet1: ethernet@e2000 {
+			rgmii = <0>;
 		};
 
 		enet2: ethernet@e4000 {
+			rgmii = <1>;
 		};
 
 		enet3: ethernet@e6000 {
+			rgmii = <1>;
 		};
 	};
 };
diff --git a/arch/powerpc/boot/dts/fsl/t1040si-post.dtsi b/arch/powerpc/boot/dts/fsl/t1040si-post.dtsi
index f58eb820eb5e..a585f5faaf9e 100644
--- a/arch/powerpc/boot/dts/fsl/t1040si-post.dtsi
+++ b/arch/powerpc/boot/dts/fsl/t1040si-post.dtsi
@@ -606,18 +606,25 @@ sata@221000 {
 /include/ "qoriq-fman3-0-1g-4.dtsi"
 	fman@400000 {
 		enet0: ethernet@e0000 {
+			rgmii = <0>;
 		};
 
 		enet1: ethernet@e2000 {
+			rgmii = <1>;
+			mii;
 		};
 
 		enet2: ethernet@e4000 {
+			rgmii = <0>;
 		};
 
 		enet3: ethernet@e6000 {
+			rgmii = <1>;
+			mii;
 		};
 
 		enet4: ethernet@e8000 {
+			rgmii = <1>;
 		};
 
 		mdio@fc000 {
diff --git a/arch/powerpc/boot/dts/fsl/t2081si-post.dtsi b/arch/powerpc/boot/dts/fsl/t2081si-post.dtsi
index ecbb447920bc..f8a52ce0b590 100644
--- a/arch/powerpc/boot/dts/fsl/t2081si-post.dtsi
+++ b/arch/powerpc/boot/dts/fsl/t2081si-post.dtsi
@@ -619,27 +619,35 @@ usb1: usb@211000 {
 /include/ "qoriq-fman3-0-10g-1.dtsi"
 	fman@400000 {
 		enet0: ethernet@e0000 {
+			rgmii = <0>;
 		};
 
 		enet1: ethernet@e2000 {
+			rgmii = <0>;
 		};
 
 		enet2: ethernet@e4000 {
+			rgmii = <1>;
 		};
 
 		enet3: ethernet@e6000 {
+			rgmii = <1>;
 		};
 
 		enet4: ethernet@e8000 {
+			rgmii = <0>;
 		};
 
 		enet5: ethernet@ea000 {
+			rgmii = <0>;
 		};
 
 		enet6: ethernet@f0000 {
+			rgmii = <0>;
 		};
 
 		enet7: ethernet@f2000 {
+			rgmii = <1>;
 		};
 
 		mdio@fc000 {
diff --git a/arch/powerpc/boot/dts/fsl/t4240si-post.dtsi b/arch/powerpc/boot/dts/fsl/t4240si-post.dtsi
index fcac73486d48..c0aa26db78b0 100644
--- a/arch/powerpc/boot/dts/fsl/t4240si-post.dtsi
+++ b/arch/powerpc/boot/dts/fsl/t4240si-post.dtsi
@@ -1018,27 +1018,35 @@ usb1: usb@211000 {
 /include/ "qoriq-fman3-0-10g-1.dtsi"
 	fman@400000 {
 		enet0: ethernet@e0000 {
+			rgmii = <0>;
 		};
 
 		enet1: ethernet@e2000 {
+			rgmii = <0>;
 		};
 
 		enet2: ethernet@e4000 {
+			rgmii = <0>;
 		};
 
 		enet3: ethernet@e6000 {
+			rgmii = <0>;
 		};
 
 		enet4: ethernet@e8000 {
+			rgmii = <1>;
 		};
 
 		enet5: ethernet@ea000 {
+			rgmii = <0>;
 		};
 
 		enet6: ethernet@f0000 {
+			rgmii = <0>;
 		};
 
 		enet7: ethernet@f2000 {
+			rgmii = <0>;
 		};
 
 		mdio@fc000 {
@@ -1061,27 +1069,35 @@ mdio@fd000 {
 /include/ "qoriq-fman3-1-10g-1.dtsi"
 	fman@500000 {
 		enet8: ethernet@e0000 {
+			rgmii = <0>;
 		};
 
 		enet9: ethernet@e2000 {
+			rgmii = <0>;
 		};
 
 		enet10: ethernet@e4000 {
+			rgmii = <0>;
 		};
 
 		enet11: ethernet@e6000 {
+			rgmii = <0>;
 		};
 
 		enet12: ethernet@e8000 {
+			rgmii = <1>;
 		};
 
 		enet13: ethernet@ea000 {
+			rgmii = <1>;
 		};
 
 		enet14: ethernet@f0000 {
+			rgmii = <0>;
 		};
 
 		enet15: ethernet@f2000 {
+			rgmii = <0>;
 		};
 
 		mdio@fc000 {
-- 
2.35.1.1320.gc452695387.dirty

