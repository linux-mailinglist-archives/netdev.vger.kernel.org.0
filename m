Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECE6A618A37
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 22:07:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbiKCVHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 17:07:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231390AbiKCVHK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 17:07:10 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140053.outbound.protection.outlook.com [40.107.14.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6921CB864;
        Thu,  3 Nov 2022 14:07:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TJkeCIZLAFDUWx+POs2qCF3YPiqptBPnoN2tDaF7juZG3cimsQ9M3RKwINbUHDwyDZfCeU8Du+ap2GOitrQ1MeEK/gzkJPzTRpgxfid2KEyGbBsAKYgKR1DZ4sPSWlZF9bBD6xsAg//JiE9zcajO7mNbGZ7sanBwX+4JirlQF4XL1cA4BHi8VTzobvEWAgq4kTlhOrii1s4MMWlJtnQsprHLAGN6RlKgnav7EQZIVd0IwJDltYBJjQ7eA8ce/LOsgT7HOwVBuQGPCdO7gCDFpsQjyBYwl4xs/pLZpXAowhcjJYYJLVhkjfc4TO/ZEvEiyYEtEHdb7SiRIJfintNwFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XIUBlxgCTbbA73hCtpXysikkhZl2PoB4usvcQMIuKak=;
 b=heCGDRPQ9iwfD6OnHZK+slWoo2RhRJ1eSuXoMvmTBGzRVv3ZO4tThTcs1E2O2rSZQdWlX+XfrmT1LwQmGpJpBeBrS+CCnY5C3ljBFY3JgJaQLVxnNKhYsPTZG/YqfJKk5sfTBCpv60C+4E2B0M5vAcy8dqixOiwy9Z9CnmfFcvk+KXTOE8hwfzQNNWdKb4qDtOCGMZeYkuM/O2teyEhmgkMsnf58fdYSacfMUMVwOggFXPagHb5ATGD6H75lZV1nUtTqk05pqpk+LX6+0IL5RAXJFsudZgzoNV1GdOSLLE30SmRHxkh1TBxLiKD1VMIX8tU66FpzIvW7N8Qoh/VFlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XIUBlxgCTbbA73hCtpXysikkhZl2PoB4usvcQMIuKak=;
 b=lOF558UhNzXMvR/thWm8jKSr2L5iwwNQB13cU2kitcvRoXh1vD43DKy3utAL5pmlezktGkNAkCvQPZQ7OPiGl6NjYzAG7t82UQuuH1mW0BOpyjc/AGvRzqw1UG2Xf//g1tWv1/BaJRHs09c93JOHNmJHjwzcVSVa5/OuKktdDUqk9bsv2Xpi33COfjwUvaejnqbB9KnbhNuvUZ1yO0YIY5ha3Hn5PtXA8RVmYcyjOJJan/IBghUiKAOUk7f8njt9lsZs5HXjv4CpJoxNqKxIDl6KDaU2N8i05NmdZtrNN5hjc+Dt4tDSakCuDZiMEq7jnFpwNSXl9FvGFIXDuU6Prg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by PAXPR03MB7746.eurprd03.prod.outlook.com (2603:10a6:102:208::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.15; Thu, 3 Nov
 2022 21:07:06 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::e9d6:22e1:489a:c23d]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::e9d6:22e1:489a:c23d%4]) with mapi id 15.20.5791.022; Thu, 3 Nov 2022
 21:07:06 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sean Anderson <sean.anderson@seco.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH net-next v2 02/11] powerpc: dts: Add compatible strings for Lynx PCSs
Date:   Thu,  3 Nov 2022 17:06:41 -0400
Message-Id: <20221103210650.2325784-3-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20221103210650.2325784-1-sean.anderson@seco.com>
References: <20221103210650.2325784-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAP220CA0002.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::7) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB7PR03MB4972:EE_|PAXPR03MB7746:EE_
X-MS-Office365-Filtering-Correlation-Id: ea5f4609-eac7-4b29-08ce-08dabddf5d42
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xsu6cybi0nZlYACRrt7cOiaVP6Fpp7RV1efseyzXsvH/DBJ6T2l22uxvnyQTZm9ot1Hcbmc1UmoH+kbU808UyapbwZYDUA+6gRXv5IXJTg9RUhayYVatYQ5eG6EI+ynAlJNhEQ7SRjDrXZqYcE+ADS57pF+0Idm6kKSlmVgMOtBRe9+oCYXzckpNWlonpxAyZcYpxojonE0lIn2fRE7AaTLt0tTUMUZm1XQn5BDRrOzJ/+aDfpGCDKsXfMOU7tTVV4sxwhLe66FFLGVhMzTJc7smMPEcztA4Sn3UzukxaWzIcPdb37FWXfb4pz1+B1oJCo+/Wx2jpCeN43p/pYEVkHX1Xo0FULNBYT5CBO9U8v4E22NmX1Ovq8DnEyNVkvFsRmPOlRBOQypip6y7XtVeIJJC4TM7HGA3VkQCLh2l//nLd8BLuRNQVmEjT+gdn5JuGfDnLELuEEla7XMUbrbsE8VPd0P/D+U/+lj2kjo9Y9W0UJcgZ8efYPyaovkBEPAjQ6uLYRkqdtHz/FFOp4CLzRhLb3V1eDQCfIC+0D84BmmRC825g9xiasABZEGUmztaq15PwtdupAi+vEcqSb4MI1Z8wsdNCKpH6vUkhK1YfyoL0YNxGonzQCiBowR3HQqgrd2lbyQej0UCrF+aDzhN3b0e2cduTpS+49dvQI/0bdinyE4YGXh7IszoJQzQMZxNQYsW5DdIdpe+mZHxc8Vd7rKDOJNEYF4sRg4jgmPSKlp2VRykGN61YEcu3F3Bo0T8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(39850400004)(376002)(346002)(396003)(451199015)(8936002)(86362001)(36756003)(478600001)(6486002)(44832011)(5660300002)(2906002)(52116002)(30864003)(26005)(6512007)(6506007)(1076003)(38350700002)(38100700002)(186003)(83380400001)(2616005)(7416002)(41300700001)(6666004)(66946007)(66556008)(4326008)(66476007)(8676002)(316002)(54906003)(110136005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8q2+v3I7uzaSgNeupSyhlFZgO9Qwfe7D3MITTSgYFsFzwNKP1Pn+Hu35m3HG?=
 =?us-ascii?Q?gDVsg8e71m+phavU5S4KHUkhwzka0WfOd26DkM7Fx2tKZj3VyJNhnO794VgP?=
 =?us-ascii?Q?dRbQGz/d7tugcrLGMZDF89VDs9TLA+aGl1NUYMOOpy/bwCNFadBYuyPI5nJe?=
 =?us-ascii?Q?QeiN6gU0QoHGjosDfVjaFhigr6SEz2SGvcnjaMhuxjASiw38dXMhSM/ntLLa?=
 =?us-ascii?Q?iFSqLG7eAdSvtapv+U49QuO/dCmpCaDji/y6u8nyLNx0BdXUonLQpFpM+4BT?=
 =?us-ascii?Q?JL4bGejAM0W14J7IeKS9aFfC3arfCPzNFKH18bWG9dtIgOzRzV7GR3X3JKKT?=
 =?us-ascii?Q?O0xqYRzMKCC3ffa1MmKn/p9zYIWgM2kCq/xf3kQDdcu5bFBT+uv1FbqUn89b?=
 =?us-ascii?Q?b7fnppjvVrxsFgrXHBC9laysnMuYdP0BH8M3gLFb2wjN1JkCSW0GtJQV/Sco?=
 =?us-ascii?Q?+z/Pw9tZoKUOUFMWBXeuE5lFLjBJGxZfjWy5orU4G0vHR9YT4g+uLPCUocm0?=
 =?us-ascii?Q?TFLOecbDiug6pZGmMpcD7hByM78iOzO+m+FEeETrJ+F5dUWZP6rNHnqJcWfq?=
 =?us-ascii?Q?KhlE9gCHTgQcAienfRWvNC/uN7Ru3EVnN2ZmRVHl8Rrj+SEuhTR7aEoShJPc?=
 =?us-ascii?Q?0KqBIDwsC+4GwBpa3lw8opJOgbewWfpu/A7ADRlcyrMdMw2gacJPk+x69IoR?=
 =?us-ascii?Q?scoOQfbNm91ZmBA7z1a2u+yAoFm8DkdJLZcibAkVXCsLOpp/ezR+bHrorOO2?=
 =?us-ascii?Q?wL93tI6TGEgR/KtXm13iV3r290Ebcs35EL4/XCjW7B8MMeqCyRIejntwt/Zp?=
 =?us-ascii?Q?b15iAosqmIBSqPzDQfzfHFYtfqcgqFOBhmjwlsb4fnWwjcLVh4YfwGE9zkNk?=
 =?us-ascii?Q?xQNu3NlhThANLbd9C81GtLa99u2oi0EjldHuQm9UEsHh/UrXXipE4+WFwFB0?=
 =?us-ascii?Q?iZfPyWBqqkWrWEJ1VW8QPBrC0Zaekgzk3lPzAIancmvAeNMRTgY+5KCbHCun?=
 =?us-ascii?Q?Ln9Rmg05PfqwGL0XJdOq9FvpKNfGs6CjaCo9GBjQn7UYbfxe528f/98bz6pX?=
 =?us-ascii?Q?Lr0u3cUt3kyaRnjBEUK3GOb4FztWZCIPDtC2aCJM01xhXqNf29FtsH0m9xOd?=
 =?us-ascii?Q?HESTW11yJu05AM1pRZBH4sX9dPGZUUnoQuFlEDikKIV7trM6jpgWNAlZ/ytu?=
 =?us-ascii?Q?iu0GTaOfSIKbs0QbT00LG+tTOEd3yCG10EL0Cwr9oZmHO413JOdnH8Wpg+3a?=
 =?us-ascii?Q?Jegj9Imjq6SpFnhsTevKuzLlE6oxFLqPPdZ9FqB7W/y0r+LaxpkZw/XCXMUi?=
 =?us-ascii?Q?UpTTJdCgaEcG0pGyEhk8aa5/vaEYnbsmw1x+Du++/7+GculGUcPuS9c7Sjyx?=
 =?us-ascii?Q?W7qleR3Uj/MDxqjBiwd/IdqrB78EbdjvxI5kFpCVz2IKAnUpb2hkP5wlnduv?=
 =?us-ascii?Q?G6SOnnUYQmqoHTnnl2WCvwBmwH+3ernpJWaTPgUXufr9zvUGNrdacqT6RkG6?=
 =?us-ascii?Q?6xtf4HUIwbu9shTJClYeZ1nuqpj9ML1hL6ksYxWCLswraTq91AdVhQxf485A?=
 =?us-ascii?Q?MbutqbBsfiVZ1upguByiX5tmnvNPk3l5AsvyoWjISEbOSsFFvzZp9Y4pzjJv?=
 =?us-ascii?Q?pQ=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea5f4609-eac7-4b29-08ce-08dabddf5d42
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2022 21:07:06.7718
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VBfOJ3+AEZ/+denmksPYJSKbXX6sTSoxdrvN7AcuBNlM90xQcDBqJXU/ZGz5+oGxcdTeziIMPF8mW/FSUzlSfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR03MB7746
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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

Changes in v2:
- Add compatibles for qoriq-fman3-0-10g-2/3.dtsi as well

 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0-best-effort.dtsi | 3 ++-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0.dtsi             | 3 ++-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1-best-effort.dtsi | 3 ++-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1.dtsi             | 3 ++-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi             | 3 ++-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi             | 3 ++-
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
 20 files changed, 40 insertions(+), 20 deletions(-)

diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0-best-effort.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0-best-effort.dtsi
index 7e70977f282a..61d52044e7b4 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0-best-effort.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0-best-effort.dtsi
@@ -66,7 +66,8 @@ mdio@e1000 {
 		reg = <0xe1000 0x1000>;
 		fsl,erratum-a011043; /* must ignore read errors */
 
-		pcsphy0: ethernet-phy@0 {
+		pcsphy0: ethernet-pcs@0 {
+			compatible = "fsl,lynx-pcs";
 			reg = <0x0>;
 		};
 	};
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0.dtsi
index 5f89f7c1761f..78d6e49655f4 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0.dtsi
@@ -70,7 +70,8 @@ mdio@f1000 {
 		reg = <0xf1000 0x1000>;
 		fsl,erratum-a011043; /* must ignore read errors */
 
-		pcsphy6: ethernet-phy@0 {
+		pcsphy6: ethernet-pcs@0 {
+			compatible = "fsl,lynx-pcs";
 			reg = <0x0>;
 		};
 	};
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1-best-effort.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1-best-effort.dtsi
index 71eb75e82c2e..5ffd1c2efaee 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1-best-effort.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1-best-effort.dtsi
@@ -73,7 +73,8 @@ mdio@e3000 {
 		reg = <0xe3000 0x1000>;
 		fsl,erratum-a011043; /* must ignore read errors */
 
-		pcsphy1: ethernet-phy@0 {
+		pcsphy1: ethernet-pcs@0 {
+			compatible = "fsl,lynx-pcs";
 			reg = <0x0>;
 		};
 	};
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1.dtsi
index fb7032ddb7fc..e0325f09ce5f 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1.dtsi
@@ -70,7 +70,8 @@ mdio@f3000 {
 		reg = <0xf3000 0x1000>;
 		fsl,erratum-a011043; /* must ignore read errors */
 
-		pcsphy7: ethernet-phy@0 {
+		pcsphy7: ethernet-pcs@0 {
+			compatible = "fsl,lynx-pcs";
 			reg = <0x0>;
 		};
 	};
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi
index 6b3609574b0f..8e6f6c5f0f2e 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi
@@ -38,7 +38,8 @@ mdio@e1000 {
 		reg = <0xe1000 0x1000>;
 		fsl,erratum-a011043; /* must ignore read errors */
 
-		pcsphy0: ethernet-phy@0 {
+		pcsphy0: ethernet-pcs@0 {
+			compatible = "fsl,lynx-pcs";
 			reg = <0x0>;
 		};
 	};
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi
index 28ed1a85a436..2cd3f0688cb1 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi
@@ -38,7 +38,8 @@ mdio@e3000 {
 		reg = <0xe3000 0x1000>;
 		fsl,erratum-a011043; /* must ignore read errors */
 
-		pcsphy1: ethernet-phy@0 {
+		pcsphy1: ethernet-pcs@0 {
+			compatible = "fsl,lynx-pcs";
 			reg = <0x0>;
 		};
 	};
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-0.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-0.dtsi
index 1089d6861bfb..9f8c38a629cb 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-0.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-0.dtsi
@@ -62,7 +62,8 @@ mdio@e1000 {
 		reg = <0xe1000 0x1000>;
 		fsl,erratum-a011043; /* must ignore read errors */
 
-		pcsphy0: ethernet-phy@0 {
+		pcsphy0: ethernet-pcs@0 {
+			compatible = "fsl,lynx-pcs";
 			reg = <0x0>;
 		};
 	};
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-1.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-1.dtsi
index a95bbb4fc827..248a57129d40 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-1.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-1.dtsi
@@ -69,7 +69,8 @@ mdio@e3000 {
 		reg = <0xe3000 0x1000>;
 		fsl,erratum-a011043; /* must ignore read errors */
 
-		pcsphy1: ethernet-phy@0 {
+		pcsphy1: ethernet-pcs@0 {
+			compatible = "fsl,lynx-pcs";
 			reg = <0x0>;
 		};
 	};
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-2.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-2.dtsi
index 7d5af0147a25..73cef28db890 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-2.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-2.dtsi
@@ -69,7 +69,8 @@ mdio@e5000 {
 		reg = <0xe5000 0x1000>;
 		fsl,erratum-a011043; /* must ignore read errors */
 
-		pcsphy2: ethernet-phy@0 {
+		pcsphy2: ethernet-pcs@0 {
+			compatible = "fsl,lynx-pcs";
 			reg = <0x0>;
 		};
 	};
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-3.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-3.dtsi
index 61e5466ec854..4657b6a8fb78 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-3.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-3.dtsi
@@ -69,7 +69,8 @@ mdio@e7000 {
 		reg = <0xe7000 0x1000>;
 		fsl,erratum-a011043; /* must ignore read errors */
 
-		pcsphy3: ethernet-phy@0 {
+		pcsphy3: ethernet-pcs@0 {
+			compatible = "fsl,lynx-pcs";
 			reg = <0x0>;
 		};
 	};
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-4.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-4.dtsi
index 3ba0cdafc069..ac322e5803c2 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-4.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-4.dtsi
@@ -62,7 +62,8 @@ mdio@e9000 {
 		reg = <0xe9000 0x1000>;
 		fsl,erratum-a011043; /* must ignore read errors */
 
-		pcsphy4: ethernet-phy@0 {
+		pcsphy4: ethernet-pcs@0 {
+			compatible = "fsl,lynx-pcs";
 			reg = <0x0>;
 		};
 	};
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-5.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-5.dtsi
index 51748de0a289..68ffa2c65e03 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-5.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-5.dtsi
@@ -69,7 +69,8 @@ mdio@eb000 {
 		reg = <0xeb000 0x1000>;
 		fsl,erratum-a011043; /* must ignore read errors */
 
-		pcsphy5: ethernet-phy@0 {
+		pcsphy5: ethernet-pcs@0 {
+			compatible = "fsl,lynx-pcs";
 			reg = <0x0>;
 		};
 	};
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-0.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-0.dtsi
index ee4f5170f632..caf28fcbd55c 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-0.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-0.dtsi
@@ -70,7 +70,8 @@ mdio@f1000 {
 		reg = <0xf1000 0x1000>;
 		fsl,erratum-a011043; /* must ignore read errors */
 
-		pcsphy14: ethernet-phy@0 {
+		pcsphy14: ethernet-pcs@0 {
+			compatible = "fsl,lynx-pcs";
 			reg = <0x0>;
 		};
 	};
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-1.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-1.dtsi
index 83d2e0ce8f7b..6128b9fb5381 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-1.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-1.dtsi
@@ -70,7 +70,8 @@ mdio@f3000 {
 		reg = <0xf3000 0x1000>;
 		fsl,erratum-a011043; /* must ignore read errors */
 
-		pcsphy15: ethernet-phy@0 {
+		pcsphy15: ethernet-pcs@0 {
+			compatible = "fsl,lynx-pcs";
 			reg = <0x0>;
 		};
 	};
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-0.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-0.dtsi
index 3132fc73f133..a7dffe6bbe5b 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-0.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-0.dtsi
@@ -62,7 +62,8 @@ mdio@e1000 {
 		reg = <0xe1000 0x1000>;
 		fsl,erratum-a011043; /* must ignore read errors */
 
-		pcsphy8: ethernet-phy@0 {
+		pcsphy8: ethernet-pcs@0 {
+			compatible = "fsl,lynx-pcs";
 			reg = <0x0>;
 		};
 	};
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-1.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-1.dtsi
index 75e904d96602..d0ad92f2ca2d 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-1.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-1.dtsi
@@ -69,7 +69,8 @@ mdio@e3000 {
 		reg = <0xe3000 0x1000>;
 		fsl,erratum-a011043; /* must ignore read errors */
 
-		pcsphy9: ethernet-phy@0 {
+		pcsphy9: ethernet-pcs@0 {
+			compatible = "fsl,lynx-pcs";
 			reg = <0x0>;
 		};
 	};
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-2.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-2.dtsi
index 69f2cc7b8f19..b4b893eead2a 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-2.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-2.dtsi
@@ -69,7 +69,8 @@ mdio@e5000 {
 		reg = <0xe5000 0x1000>;
 		fsl,erratum-a011043; /* must ignore read errors */
 
-		pcsphy10: ethernet-phy@0 {
+		pcsphy10: ethernet-pcs@0 {
+			compatible = "fsl,lynx-pcs";
 			reg = <0x0>;
 		};
 	};
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-3.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-3.dtsi
index b3aaf01d7da0..6c15a6ff0926 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-3.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-3.dtsi
@@ -69,7 +69,8 @@ mdio@e7000 {
 		reg = <0xe7000 0x1000>;
 		fsl,erratum-a011043; /* must ignore read errors */
 
-		pcsphy11: ethernet-phy@0 {
+		pcsphy11: ethernet-pcs@0 {
+			compatible = "fsl,lynx-pcs";
 			reg = <0x0>;
 		};
 	};
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-4.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-4.dtsi
index 18e020432807..14fa4d067ffd 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-4.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-4.dtsi
@@ -62,7 +62,8 @@ mdio@e9000 {
 		reg = <0xe9000 0x1000>;
 		fsl,erratum-a011043; /* must ignore read errors */
 
-		pcsphy12: ethernet-phy@0 {
+		pcsphy12: ethernet-pcs@0 {
+			compatible = "fsl,lynx-pcs";
 			reg = <0x0>;
 		};
 	};
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-5.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-5.dtsi
index 55f329d13f19..64737187a577 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-5.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-5.dtsi
@@ -69,7 +69,8 @@ mdio@eb000 {
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

