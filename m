Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4758618A34
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 22:07:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231392AbiKCVHL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 17:07:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230526AbiKCVHJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 17:07:09 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140053.outbound.protection.outlook.com [40.107.14.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09CD32DC9;
        Thu,  3 Nov 2022 14:07:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D6S+7/kO3138QuyqxU8viFgV5D9i295gJrd3lmsJ8CSSvCNuQCDEOd8ozQ0DkXhvAaasqzGvZSMOlYp+1fJ/p8M80FX+07V03MHpsnn/WSH2A8nMIJBvyeTVzeeluaAT/d8OPAqzHP1p3vq63npOfmhnSBKgT0aBLCltbZayGuxFk7brPg3aR9uZxjUhLUKuX5Gxmzc2M6pp2KmfPlJ9XOJ+qlXZYBePu+DtNKXbSQja9IivrVKrpTj0pU233tXLo9clW91qQXfMbQNciFKAnU44C7jaWo6tAoepqgnD8AS8s00gyG9YMqGD7MOnuO3ZHaqcwy3kzqNP8LjE157imA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JafJjLT0Fxzr2HeAil9LH6NrO1QPb5BMqNDiKrmCkc8=;
 b=gK2P3lDiolWg1krc7EVl/9ELBiwEV0+8vNY36W+pW9EEqvQ8RJ1jIDXSgchvo/2pq2JZXxqbytS+bO8VDnCXDNndcKafNFPSia0raU0+IfEIarbE8Ky9wRnjSU+3MHuyZRwN0YwYBwocsxyh/lBM6mrFCj4TVUtHq0i/gKT6O/vDaCG7ETVbbIyQMqUM7ajvvbYSJHYdScjogN7B0iBHINhP+/NhdstszlFsuv2Om98eFG7hYFWnnhIW1NYysrkZ4zNWbnWaehhnQpxKbqk2GoEChxeM2a4HsNqvjllb7wkOWryTmQqE6KGrfugDkiQX9+LUQnWFPxOX31dO9vFgcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JafJjLT0Fxzr2HeAil9LH6NrO1QPb5BMqNDiKrmCkc8=;
 b=yrnD1nigGQXyoFsnUVpp4YzHM9XArMDUsYTbPIfDYu7xoufpKrWnXOJTIHvzSSAzoOYZ8iiWG4SnPul7MmUP6QSEORKhSTEZU2r1rzFaFt1t+HwT+npKfhcNKFZj5ZRbTp0SuGwsabkdvpOiK4oM7kYqdtYBlf78irQFzZ3nvwVCKaVhSBwzL+iu8J3abFnU8veDMS6lQH5VazCBwWyw2SDCNyEX5Nmdkv9PqLUKV7aT3qkv3khPp0ZtlFRPJW8vwAPOnvOhf9unHAoJ5nMOOTfASMmWXOK8Uc+xMkrqbQMxPjFfkXhUcjlSdQT9lPUiEWm53riXWavAXkqlMFtgKQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by PAXPR03MB7746.eurprd03.prod.outlook.com (2603:10a6:102:208::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.15; Thu, 3 Nov
 2022 21:07:04 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::e9d6:22e1:489a:c23d]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::e9d6:22e1:489a:c23d%4]) with mapi id 15.20.5791.022; Thu, 3 Nov 2022
 21:07:04 +0000
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
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Li Yang <leoyang.li@nxp.com>, Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH net-next v2 01/11] arm64: dts: Add compatible strings for Lynx PCSs
Date:   Thu,  3 Nov 2022 17:06:40 -0400
Message-Id: <20221103210650.2325784-2-sean.anderson@seco.com>
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
X-MS-Office365-Filtering-Correlation-Id: b7b08589-9c72-407b-7ec6-08dabddf5c0e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z2DOfFpxHSnXQvvJBP4Y8hN0CgpdBjlu+97bFMBNOgmDUdnd1TZbzNnsmDuLq4tb7fUPH2yRwtw+CnexCzHjKYPUVRHbGSJOlpmWx9m4YXqlFiD6W15PrWL5KaSBt9e/AOTA0PURKuHJujTGB5fA4YqoojeO6qWqoon9jFaUi5tElBUp/yTBX88fMQStdYoPhSXWx2rP9SZ2Xr1IE5ZYPOKqphleCE3RJSrODmeSyXH6NT563vpeF1JGfZfYi4fLtdODv5jRoBoAXYfe0v75INZn9k+sNdmyB9sMKxpaqD+RpozXjucmqRpo946UMH70D0nRp04DM3AxfUKU/Uj1imMDsInzTiYB3eKI1QAabP+xWa83E1sI+p4wNyNwRyJbZa9r8XQ4EFtX7DSoLOjpncwTgQiERYTpogLJTaGCMiV6ts+7/HyeALNsMKNbbadMHLRZ5SoJMNIvo5dSAhxoIZxAnTkBwcJ1Je5AMSrP2V0IJRVxt8k6Ofgg1EZGjUak3xuSzL5PJ8mXWD0g2vSj3ZJZvqldb4/WrjalxSyDfrBP1CrNmwJ5a9Wwu065SOQ9ugE1wja1BwGprKDse76YF00sfipgtTodJA5KLUCCRwJHkKpn0TEFJ88ju8vfEP95dyjspDXa6Bft5aXiheaFb7SL37gBzdVmEaDq4RHq3c+mXi5miFV0h+P5CT+FxLCgMA8akdWZpRLG9tgzyLzbfJqYTXMObmHPCcnmwVfxHlKJSDsSDnKsQ1dRqmgQz3fH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(39850400004)(376002)(346002)(396003)(451199015)(8936002)(86362001)(36756003)(478600001)(6486002)(44832011)(5660300002)(2906002)(52116002)(30864003)(26005)(6512007)(6506007)(1076003)(38350700002)(38100700002)(186003)(83380400001)(2616005)(7416002)(41300700001)(6666004)(66946007)(66556008)(4326008)(66476007)(8676002)(316002)(54906003)(110136005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pKEP9QGubrBaAMXVkN8ZjklfHO28BQe2dAPMiyHXku+oY1SqKVdVqo7LYEQT?=
 =?us-ascii?Q?EmL+oY96HVMAq4fKDklAL7U3dGsrrvWutuQJhjgeG5n0G8E+8o0t4CNrWgmP?=
 =?us-ascii?Q?db983Gn579uW5Qfy7iEMOfdV1kbNDJ+akxh8vHt35KpZjZsUQqqCLllLZmss?=
 =?us-ascii?Q?ZesuFVAelUipQKmC7LPcwnV2ctwcGp007STui4cEKEDCpA8Bqu8/Ha9CltIL?=
 =?us-ascii?Q?vIWAwhmPNchxwAVptq3UP73Wp0RekpDACNrsMWYB32FvgUyb3G98SGau5/DA?=
 =?us-ascii?Q?2Ob6Oaq60IzoOlcZdR9Ay8d+2u6eHkB5lsy82CZcE9WUFgS4xdpge7Oy06Br?=
 =?us-ascii?Q?E7SGUkuTKDY8DNYVEIUoGNrq/cSiWU+adt+IhfKS61u7iRwrBY88k4fAdeYJ?=
 =?us-ascii?Q?Aj2dXMl5WF/ILIDevXhZ8ONVhHMk8S4SFnm9nVLUHwisHLqE2otSXg4kLdug?=
 =?us-ascii?Q?U+4o4lZmbrAx2U4f2XbWmRUzlOkFgGyC2uZXG5f/AC3dK07a6pqtFHQZtc2/?=
 =?us-ascii?Q?3WhAHp4vQufhjOA+4GAUzJa57B8fvAfDVPmNBbsJFNMeuIUAzgk6dMEaysTX?=
 =?us-ascii?Q?G3yiBA3rgoJwq2k9O9ztGK4Bhvl3fiCqdUY32F+3g1TfIwkQ4rAQrqDcNfoz?=
 =?us-ascii?Q?SGq2bxPTc5KqTf9WnfttQvsAUWgkuTCmhzhJFnxP/umtim+Lt1g775mEqeai?=
 =?us-ascii?Q?heFtn4KyXHz3f1eMDJCE2GyqextgMviqt1o6WTnUgylz7wRzhGjx+DGxD1z4?=
 =?us-ascii?Q?WM6WRZ+C5cgwyM/Li5dsPdMJ8Gp3HJSNRw0ee9Wov/8f1AEOY6oXRFqAVpgz?=
 =?us-ascii?Q?wZFVXJIjozDCqmF9lRjykCJxk8o+FOPOp9gPtkfBZ5lePWDE0WWrA4kKuaXf?=
 =?us-ascii?Q?6+S0n9X35scIrGDt0s70Sw79bJ1Ny9UrdauSZwW9v+JSK/+kknvM2Dh/45AH?=
 =?us-ascii?Q?kUqAE4sLNsDJtl9iG9XEXyCzb/hKmsdDvFbCZ4dJ8PQAycsdZvqIE6OOzkUY?=
 =?us-ascii?Q?WeT8fQAD6dClADX5+Zx/1HBjALiUzzSJAEfzJkpXz+i+Ws+JBhsGbckcD74J?=
 =?us-ascii?Q?gXYrGKMh9Xz1+cYvb4wdDy4f4gC0s4a1H9sg28WkMhUyiO365Ut1dFL4FvON?=
 =?us-ascii?Q?AGXO0BFNz44irjYKQLkY76Ukzn+k7bOR+xdB/l7DnuoghRPlxG147hKlc2n4?=
 =?us-ascii?Q?kBHtNeW1XeIp2b3pw0Wtp/bgYU3uSAS3MJ1KNpqLNEqS096YBjFlA+bFICfv?=
 =?us-ascii?Q?xz0JWXk6jyd+P3jU+8szxjuOVVbEFnEORZ44ujz8JcE5vSI0vVhiO2i/dPQo?=
 =?us-ascii?Q?wDOt9vd/J+ksitwBaxiaL7Rk6VFdPGqcLC23lLAZWQqSjtiaU/Sno0/qNzHL?=
 =?us-ascii?Q?nEh8ouVy0FtHFDLlHBctjchZncF0m5ZXYm1UKh7YOVaBlu446B8DGAXu6IIy?=
 =?us-ascii?Q?G+pXrrpdgJ23DEKM2QMPASB5FtAGufXSszZHTjKH8z8S84TamYL/5oc3FBNn?=
 =?us-ascii?Q?pztXtUnenGx2/1sbenhXks4ClDUObYt5rV5fSRcy/UTIQEnZ6nYOObwOVmXy?=
 =?us-ascii?Q?fOTEmk9k91KYiCp/vZ5d14Nzg8my6RPUbms0sdmKOZ6A+BngYDG4i27pEjJ1?=
 =?us-ascii?Q?hQ=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7b08589-9c72-407b-7ec6-08dabddf5c0e
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2022 21:07:04.7875
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WddpRqMUf+dY7/0L0T0utPE175OhBAzKXMSLTt17jNMOHTw3fBfsPvgqEquFMmp4LjYXqBP0dnNJ/dmLnev6Fg==
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

This adds appropriate compatible strings for Lynx PCSs on arm64 QorIQ
platforms. This also changes the node name to avoid warnings from
ethernet-phy.yaml.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

(no changes since v1)

 .../arm64/boot/dts/freescale/fsl-ls208xa.dtsi | 48 +++++++++++------
 .../arm64/boot/dts/freescale/fsl-lx2160a.dtsi | 54 ++++++++++++-------
 .../dts/freescale/qoriq-fman3-0-10g-0.dtsi    |  3 +-
 .../dts/freescale/qoriq-fman3-0-10g-1.dtsi    |  3 +-
 .../dts/freescale/qoriq-fman3-0-1g-0.dtsi     |  3 +-
 .../dts/freescale/qoriq-fman3-0-1g-1.dtsi     |  3 +-
 .../dts/freescale/qoriq-fman3-0-1g-2.dtsi     |  3 +-
 .../dts/freescale/qoriq-fman3-0-1g-3.dtsi     |  3 +-
 .../dts/freescale/qoriq-fman3-0-1g-4.dtsi     |  3 +-
 .../dts/freescale/qoriq-fman3-0-1g-5.dtsi     |  3 +-
 10 files changed, 84 insertions(+), 42 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi
index f1b9cc8714dc..148061b9828f 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi
@@ -552,7 +552,8 @@ pcs_mdio1: mdio@8c07000 {
 			#size-cells = <0>;
 			status = "disabled";
 
-			pcs1: ethernet-phy@0 {
+			pcs1: ethernet-pcs@0 {
+				compatible = "fsl,lynx-pcs";
 				reg = <0>;
 			};
 		};
@@ -565,7 +566,8 @@ pcs_mdio2: mdio@8c0b000 {
 			#size-cells = <0>;
 			status = "disabled";
 
-			pcs2: ethernet-phy@0 {
+			pcs2: ethernet-pcs@0 {
+				compatible = "fsl,lynx-pcs";
 				reg = <0>;
 			};
 		};
@@ -578,7 +580,8 @@ pcs_mdio3: mdio@8c0f000 {
 			#size-cells = <0>;
 			status = "disabled";
 
-			pcs3: ethernet-phy@0 {
+			pcs3: ethernet-pcs@0 {
+				compatible = "fsl,lynx-pcs";
 				reg = <0>;
 			};
 		};
@@ -591,7 +594,8 @@ pcs_mdio4: mdio@8c13000 {
 			#size-cells = <0>;
 			status = "disabled";
 
-			pcs4: ethernet-phy@0 {
+			pcs4: ethernet-pcs@0 {
+				compatible = "fsl,lynx-pcs";
 				reg = <0>;
 			};
 		};
@@ -604,7 +608,8 @@ pcs_mdio5: mdio@8c17000 {
 			#size-cells = <0>;
 			status = "disabled";
 
-			pcs5: ethernet-phy@0 {
+			pcs5: ethernet-pcs@0 {
+				compatible = "fsl,lynx-pcs";
 				reg = <0>;
 			};
 		};
@@ -617,7 +622,8 @@ pcs_mdio6: mdio@8c1b000 {
 			#size-cells = <0>;
 			status = "disabled";
 
-			pcs6: ethernet-phy@0 {
+			pcs6: ethernet-pcs@0 {
+				compatible = "fsl,lynx-pcs";
 				reg = <0>;
 			};
 		};
@@ -630,7 +636,8 @@ pcs_mdio7: mdio@8c1f000 {
 			#size-cells = <0>;
 			status = "disabled";
 
-			pcs7: ethernet-phy@0 {
+			pcs7: ethernet-pcs@0 {
+				compatible = "fsl,lynx-pcs";
 				reg = <0>;
 			};
 		};
@@ -643,7 +650,8 @@ pcs_mdio8: mdio@8c23000 {
 			#size-cells = <0>;
 			status = "disabled";
 
-			pcs8: ethernet-phy@0 {
+			pcs8: ethernet-pcs@0 {
+				compatible = "fsl,lynx-pcs";
 				reg = <0>;
 			};
 		};
@@ -656,7 +664,8 @@ pcs_mdio9: mdio@8c27000 {
 			#size-cells = <0>;
 			status = "disabled";
 
-			pcs9: ethernet-phy@0 {
+			pcs9: ethernet-pcs@0 {
+				compatible = "fsl,lynx-pcs";
 				reg = <0>;
 			};
 		};
@@ -669,7 +678,8 @@ pcs_mdio10: mdio@8c2b000 {
 			#size-cells = <0>;
 			status = "disabled";
 
-			pcs10: ethernet-phy@0 {
+			pcs10: ethernet-pcs@0 {
+				compatible = "fsl,lynx-pcs";
 				reg = <0>;
 			};
 		};
@@ -682,7 +692,8 @@ pcs_mdio11: mdio@8c2f000 {
 			#size-cells = <0>;
 			status = "disabled";
 
-			pcs11: ethernet-phy@0 {
+			pcs11: ethernet-pcs@0 {
+				compatible = "fsl,lynx-pcs";
 				reg = <0>;
 			};
 		};
@@ -695,7 +706,8 @@ pcs_mdio12: mdio@8c33000 {
 			#size-cells = <0>;
 			status = "disabled";
 
-			pcs12: ethernet-phy@0 {
+			pcs12: ethernet-pcs@0 {
+				compatible = "fsl,lynx-pcs";
 				reg = <0>;
 			};
 		};
@@ -708,7 +720,8 @@ pcs_mdio13: mdio@8c37000 {
 			#size-cells = <0>;
 			status = "disabled";
 
-			pcs13: ethernet-phy@0 {
+			pcs13: ethernet-pcs@0 {
+				compatible = "fsl,lynx-pcs";
 				reg = <0>;
 			};
 		};
@@ -721,7 +734,8 @@ pcs_mdio14: mdio@8c3b000 {
 			#size-cells = <0>;
 			status = "disabled";
 
-			pcs14: ethernet-phy@0 {
+			pcs14: ethernet-pcs@0 {
+				compatible = "fsl,lynx-pcs";
 				reg = <0>;
 			};
 		};
@@ -734,7 +748,8 @@ pcs_mdio15: mdio@8c3f000 {
 			#size-cells = <0>;
 			status = "disabled";
 
-			pcs15: ethernet-phy@0 {
+			pcs15: ethernet-pcs@0 {
+				compatible = "fsl,lynx-pcs";
 				reg = <0>;
 			};
 		};
@@ -747,7 +762,8 @@ pcs_mdio16: mdio@8c43000 {
 			#size-cells = <0>;
 			status = "disabled";
 
-			pcs16: ethernet-phy@0 {
+			pcs16: ethernet-pcs@0 {
+				compatible = "fsl,lynx-pcs";
 				reg = <0>;
 			};
 		};
diff --git a/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi b/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
index 6680fb2a6dc9..9315d4ed0454 100644
--- a/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
@@ -1406,7 +1406,8 @@ pcs_mdio1: mdio@8c07000 {
 			#size-cells = <0>;
 			status = "disabled";
 
-			pcs1: ethernet-phy@0 {
+			pcs1: ethernet-pcs@0 {
+				compatible = "fsl,lynx-pcs";
 				reg = <0>;
 			};
 		};
@@ -1419,7 +1420,8 @@ pcs_mdio2: mdio@8c0b000 {
 			#size-cells = <0>;
 			status = "disabled";
 
-			pcs2: ethernet-phy@0 {
+			pcs2: ethernet-pcs@0 {
+				compatible = "fsl,lynx-pcs";
 				reg = <0>;
 			};
 		};
@@ -1432,7 +1434,8 @@ pcs_mdio3: mdio@8c0f000 {
 			#size-cells = <0>;
 			status = "disabled";
 
-			pcs3: ethernet-phy@0 {
+			pcs3: ethernet-pcs@0 {
+				compatible = "fsl,lynx-pcs";
 				reg = <0>;
 			};
 		};
@@ -1445,7 +1448,8 @@ pcs_mdio4: mdio@8c13000 {
 			#size-cells = <0>;
 			status = "disabled";
 
-			pcs4: ethernet-phy@0 {
+			pcs4: ethernet-pcs@0 {
+				compatible = "fsl,lynx-pcs";
 				reg = <0>;
 			};
 		};
@@ -1458,7 +1462,8 @@ pcs_mdio5: mdio@8c17000 {
 			#size-cells = <0>;
 			status = "disabled";
 
-			pcs5: ethernet-phy@0 {
+			pcs5: ethernet-pcs@0 {
+				compatible = "fsl,lynx-pcs";
 				reg = <0>;
 			};
 		};
@@ -1471,7 +1476,8 @@ pcs_mdio6: mdio@8c1b000 {
 			#size-cells = <0>;
 			status = "disabled";
 
-			pcs6: ethernet-phy@0 {
+			pcs6: ethernet-pcs@0 {
+				compatible = "fsl,lynx-pcs";
 				reg = <0>;
 			};
 		};
@@ -1484,7 +1490,8 @@ pcs_mdio7: mdio@8c1f000 {
 			#size-cells = <0>;
 			status = "disabled";
 
-			pcs7: ethernet-phy@0 {
+			pcs7: ethernet-pcs@0 {
+				compatible = "fsl,lynx-pcs";
 				reg = <0>;
 			};
 		};
@@ -1497,7 +1504,8 @@ pcs_mdio8: mdio@8c23000 {
 			#size-cells = <0>;
 			status = "disabled";
 
-			pcs8: ethernet-phy@0 {
+			pcs8: ethernet-pcs@0 {
+				compatible = "fsl,lynx-pcs";
 				reg = <0>;
 			};
 		};
@@ -1510,7 +1518,8 @@ pcs_mdio9: mdio@8c27000 {
 			#size-cells = <0>;
 			status = "disabled";
 
-			pcs9: ethernet-phy@0 {
+			pcs9: ethernet-pcs@0 {
+				compatible = "fsl,lynx-pcs";
 				reg = <0>;
 			};
 		};
@@ -1523,7 +1532,8 @@ pcs_mdio10: mdio@8c2b000 {
 			#size-cells = <0>;
 			status = "disabled";
 
-			pcs10: ethernet-phy@0 {
+			pcs10: ethernet-pcs@0 {
+				compatible = "fsl,lynx-pcs";
 				reg = <0>;
 			};
 		};
@@ -1536,7 +1546,8 @@ pcs_mdio11: mdio@8c2f000 {
 			#size-cells = <0>;
 			status = "disabled";
 
-			pcs11: ethernet-phy@0 {
+			pcs11: ethernet-pcs@0 {
+				compatible = "fsl,lynx-pcs";
 				reg = <0>;
 			};
 		};
@@ -1549,7 +1560,8 @@ pcs_mdio12: mdio@8c33000 {
 			#size-cells = <0>;
 			status = "disabled";
 
-			pcs12: ethernet-phy@0 {
+			pcs12: ethernet-pcs@0 {
+				compatible = "fsl,lynx-pcs";
 				reg = <0>;
 			};
 		};
@@ -1562,7 +1574,8 @@ pcs_mdio13: mdio@8c37000 {
 			#size-cells = <0>;
 			status = "disabled";
 
-			pcs13: ethernet-phy@0 {
+			pcs13: ethernet-pcs@0 {
+				compatible = "fsl,lynx-pcs";
 				reg = <0>;
 			};
 		};
@@ -1575,7 +1588,8 @@ pcs_mdio14: mdio@8c3b000 {
 			#size-cells = <0>;
 			status = "disabled";
 
-			pcs14: ethernet-phy@0 {
+			pcs14: ethernet-pcs@0 {
+				compatible = "fsl,lynx-pcs";
 				reg = <0>;
 			};
 		};
@@ -1588,7 +1602,8 @@ pcs_mdio15: mdio@8c3f000 {
 			#size-cells = <0>;
 			status = "disabled";
 
-			pcs15: ethernet-phy@0 {
+			pcs15: ethernet-pcs@0 {
+				compatible = "fsl,lynx-pcs";
 				reg = <0>;
 			};
 		};
@@ -1601,7 +1616,8 @@ pcs_mdio16: mdio@8c43000 {
 			#size-cells = <0>;
 			status = "disabled";
 
-			pcs16: ethernet-phy@0 {
+			pcs16: ethernet-pcs@0 {
+				compatible = "fsl,lynx-pcs";
 				reg = <0>;
 			};
 		};
@@ -1614,7 +1630,8 @@ pcs_mdio17: mdio@8c47000 {
 			#size-cells = <0>;
 			status = "disabled";
 
-			pcs17: ethernet-phy@0 {
+			pcs17: ethernet-pcs@0 {
+				compatible = "fsl,lynx-pcs";
 				reg = <0>;
 			};
 		};
@@ -1627,7 +1644,8 @@ pcs_mdio18: mdio@8c4b000 {
 			#size-cells = <0>;
 			status = "disabled";
 
-			pcs18: ethernet-phy@0 {
+			pcs18: ethernet-pcs@0 {
+				compatible = "fsl,lynx-pcs";
 				reg = <0>;
 			};
 		};
diff --git a/arch/arm64/boot/dts/freescale/qoriq-fman3-0-10g-0.dtsi b/arch/arm64/boot/dts/freescale/qoriq-fman3-0-10g-0.dtsi
index dbd2fc3ba790..4cf65e40126f 100644
--- a/arch/arm64/boot/dts/freescale/qoriq-fman3-0-10g-0.dtsi
+++ b/arch/arm64/boot/dts/freescale/qoriq-fman3-0-10g-0.dtsi
@@ -35,7 +35,8 @@ mdio@f1000 {
 		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
 		reg = <0xf1000 0x1000>;
 
-		pcsphy6: ethernet-phy@0 {
+		pcsphy6: ethernet-pcs@0 {
+			compatible = "fsl,lynx-pcs";
 			reg = <0x0>;
 		};
 	};
diff --git a/arch/arm64/boot/dts/freescale/qoriq-fman3-0-10g-1.dtsi b/arch/arm64/boot/dts/freescale/qoriq-fman3-0-10g-1.dtsi
index 6fc5d2560057..de483c7e9ae0 100644
--- a/arch/arm64/boot/dts/freescale/qoriq-fman3-0-10g-1.dtsi
+++ b/arch/arm64/boot/dts/freescale/qoriq-fman3-0-10g-1.dtsi
@@ -35,7 +35,8 @@ mdio@f3000 {
 		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
 		reg = <0xf3000 0x1000>;
 
-		pcsphy7: ethernet-phy@0 {
+		pcsphy7: ethernet-pcs@0 {
+			compatible = "fsl,lynx-pcs";
 			reg = <0x0>;
 		};
 	};
diff --git a/arch/arm64/boot/dts/freescale/qoriq-fman3-0-1g-0.dtsi b/arch/arm64/boot/dts/freescale/qoriq-fman3-0-1g-0.dtsi
index 4e02276fcf99..9c31b3b2292d 100644
--- a/arch/arm64/boot/dts/freescale/qoriq-fman3-0-1g-0.dtsi
+++ b/arch/arm64/boot/dts/freescale/qoriq-fman3-0-1g-0.dtsi
@@ -34,7 +34,8 @@ mdio@e1000 {
 		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
 		reg = <0xe1000 0x1000>;
 
-		pcsphy0: ethernet-phy@0 {
+		pcsphy0: ethernet-pcs@0 {
+			compatible = "fsl,lynx-pcs";
 			reg = <0x0>;
 		};
 	};
diff --git a/arch/arm64/boot/dts/freescale/qoriq-fman3-0-1g-1.dtsi b/arch/arm64/boot/dts/freescale/qoriq-fman3-0-1g-1.dtsi
index 0312fa43fa77..72dbb26c7fd4 100644
--- a/arch/arm64/boot/dts/freescale/qoriq-fman3-0-1g-1.dtsi
+++ b/arch/arm64/boot/dts/freescale/qoriq-fman3-0-1g-1.dtsi
@@ -34,7 +34,8 @@ mdio@e3000 {
 		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
 		reg = <0xe3000 0x1000>;
 
-		pcsphy1: ethernet-phy@0 {
+		pcsphy1: ethernet-pcs@0 {
+			compatible = "fsl,lynx-pcs";
 			reg = <0x0>;
 		};
 	};
diff --git a/arch/arm64/boot/dts/freescale/qoriq-fman3-0-1g-2.dtsi b/arch/arm64/boot/dts/freescale/qoriq-fman3-0-1g-2.dtsi
index af2df07971dd..e7aa07964d1c 100644
--- a/arch/arm64/boot/dts/freescale/qoriq-fman3-0-1g-2.dtsi
+++ b/arch/arm64/boot/dts/freescale/qoriq-fman3-0-1g-2.dtsi
@@ -34,7 +34,8 @@ mdio@e5000 {
 		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
 		reg = <0xe5000 0x1000>;
 
-		pcsphy2: ethernet-phy@0 {
+		pcsphy2: ethernet-pcs@0 {
+			compatible = "fsl,lynx-pcs";
 			reg = <0x0>;
 		};
 	};
diff --git a/arch/arm64/boot/dts/freescale/qoriq-fman3-0-1g-3.dtsi b/arch/arm64/boot/dts/freescale/qoriq-fman3-0-1g-3.dtsi
index 4ac98dc8b227..fb6b8d4eb786 100644
--- a/arch/arm64/boot/dts/freescale/qoriq-fman3-0-1g-3.dtsi
+++ b/arch/arm64/boot/dts/freescale/qoriq-fman3-0-1g-3.dtsi
@@ -34,7 +34,8 @@ mdio@e7000 {
 		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
 		reg = <0xe7000 0x1000>;
 
-		pcsphy3: ethernet-phy@0 {
+		pcsphy3: ethernet-pcs@0 {
+			compatible = "fsl,lynx-pcs";
 			reg = <0x0>;
 		};
 	};
diff --git a/arch/arm64/boot/dts/freescale/qoriq-fman3-0-1g-4.dtsi b/arch/arm64/boot/dts/freescale/qoriq-fman3-0-1g-4.dtsi
index bd932d8b0160..1d9cc79bf7e2 100644
--- a/arch/arm64/boot/dts/freescale/qoriq-fman3-0-1g-4.dtsi
+++ b/arch/arm64/boot/dts/freescale/qoriq-fman3-0-1g-4.dtsi
@@ -34,7 +34,8 @@ mdio@e9000 {
 		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
 		reg = <0xe9000 0x1000>;
 
-		pcsphy4: ethernet-phy@0 {
+		pcsphy4: ethernet-pcs@0 {
+			compatible = "fsl,lynx-pcs";
 			reg = <0x0>;
 		};
 	};
diff --git a/arch/arm64/boot/dts/freescale/qoriq-fman3-0-1g-5.dtsi b/arch/arm64/boot/dts/freescale/qoriq-fman3-0-1g-5.dtsi
index 7de1c5203f3e..b6151d6f6859 100644
--- a/arch/arm64/boot/dts/freescale/qoriq-fman3-0-1g-5.dtsi
+++ b/arch/arm64/boot/dts/freescale/qoriq-fman3-0-1g-5.dtsi
@@ -34,7 +34,8 @@ mdio@eb000 {
 		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
 		reg = <0xeb000 0x1000>;
 
-		pcsphy5: ethernet-phy@0 {
+		pcsphy5: ethernet-pcs@0 {
+			compatible = "fsl,lynx-pcs";
 			reg = <0x0>;
 		};
 	};
-- 
2.35.1.1320.gc452695387.dirty

