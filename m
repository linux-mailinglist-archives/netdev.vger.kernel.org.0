Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 317195EB0D3
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 21:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbiIZTEP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 15:04:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229896AbiIZTDw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 15:03:52 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2042.outbound.protection.outlook.com [40.107.21.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96FD292F6E;
        Mon, 26 Sep 2022 12:03:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SE8iX/jQOC+VPGVo1o+/18eE8bJSmHF+maB1DzIU1Yhk+QdNJPzegT7w1mEsC6jfyo2hNE00rnNyXTxbXXRBeMyoXQlaEwgDSpcXjVEEEd+g8Uev7X+2O2/24g1REz9wuepPkyVl+degxTWLjLNQaP3K8Hr4aFJUF6+qa5r4B17TFq6t8K85kgCgMnQXzMdh/BcQlXDYrlL94B9wcXDMDduN9VMS+vURatsa7G5N2NYB/PGM8FlFDRKsNWC8hyfHEpAwjp+4b8+eVD4zIrQwa1Nn+S0J+1Bis4RwenHsgvwLDMHylp17V0bN+4XWWhrO7PBax8kdHnOaU2CvihPQNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U8mr+E5E/bquLjHtd3y1fs2FBigd04YzSdV1VetNIuY=;
 b=N2xt9lZ1i/xN5+FIPz77DfsIF293aRm7O32zbmTumfiGyOw1bg7tzdB4MmM3H49AXTlppDnFjB7ZI+Adah9KlO7mw/bWSP4meuMVmgb1uefqVTCNABPdJmA0LFySo2qB4HUr3IeDBazyDAtGUDCN24aY80tRRJcjVbrBHqgIb1VAeBwYiFvuzUvUrkx2zAhSwRsSYuoW/N4VLz7oFg9P0D3mZ7jGh8Itiua/axYhpsdsOEHjn+rsifKlgZUegIu+PTv1ywFzRWu0PrIJy/eLZ8xBRpOHdiqXgeUum/uHucwfRy7nsGinr8UYxEsJO+WbO/LZs0JD3EafXHpx/t7ceQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U8mr+E5E/bquLjHtd3y1fs2FBigd04YzSdV1VetNIuY=;
 b=mpcZob0W06g6GUE8LuWmeJfK+BP+BskAobj7wUREANDoXl2rVgOJL5CDFSmjdgI9IKmyeftCUOKmxByoIaLOLnwMjknPJTF+uC8smxVieaHwjxudKQ1qkUG9mUqPpZE8UkMvNgw6kf5ZiE4hoZZI9qTCj627nbkXteOGPySbQQfcgfIhAGFC7uDeGPulaeQQ4gCguHUgGFzzGJJIOji4rPGOeOanG+YI12hI9e6bwgc/ByrvkU1iWTQLJq+RBBhNKIQ/tFrTAL6F27bF+XpBzsVYHUDO3y7yAKKzCwkjwtgM5r1l43EC8ytGPMxrPn9m6G0KxYgY3bXWimQBuJvvqw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by PAWPR03MB9246.eurprd03.prod.outlook.com (2603:10a6:102:342::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.25; Mon, 26 Sep
 2022 19:03:47 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d%6]) with mapi id 15.20.5654.014; Mon, 26 Sep 2022
 19:03:47 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Camelia Alexandra Groza <camelia.groza@nxp.com>,
        netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        "linuxppc-dev @ lists . ozlabs . org" <linuxppc-dev@lists.ozlabs.org>,
        Sean Anderson <sean.anderson@seco.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Li Yang <leoyang.li@nxp.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH net-next v5 9/9] arm64: dts: layerscape: Add nodes for QSGMII PCSs
Date:   Mon, 26 Sep 2022 15:03:21 -0400
Message-Id: <20220926190322.2889342-10-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220926190322.2889342-1-sean.anderson@seco.com>
References: <20220926190322.2889342-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR1501CA0019.namprd15.prod.outlook.com
 (2603:10b6:207:17::32) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB7PR03MB4972:EE_|PAWPR03MB9246:EE_
X-MS-Office365-Filtering-Correlation-Id: da5b0098-6f91-4411-101e-08da9ff1d741
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9MRqKUxBh3eOoeSeqePcaxD3izVybL2lpzrNukwKWyApabokDVRxaFI/hUSHZ4RgZB5daY95xANyTCa/RitwvmW8ZO1QulsCh3Dw4/GTtfTl1eVNG8LOGDAyeOTUaOpVye6KGkNlis92ICQe0sXMLrKvUwMsVUf7YKs6yyBsGCinuLz2LneaUQJI0olJOUucscAisUv/r8hGL7iQ2JgYI/DbmbwVOpWC6Skv8bo/L37g9ns8pWUQSFfhmMi0k7Wv6Dt/fkugeR4UNvNuwjFMLtbUfUYDBCPe7ZaK07cbYusi5Hs/dmcIw3nHuKjDjX6c0rZpEv3VRLiZl/EKjKTNOeZX5WdkecLZ8sB9zGbNhmRNvEHa+i8aqeZiaNM/n0eU32QL7c3ItlSMRHvzcnN4Go2yTkUF0YKFZLpvs7FUiScKCXxNPiQYxo7fahTXcvMfc+2d/+wUBovoPuj/Xh+aNU/u91pucoCjgJ+COBjU/uerrnk7GsN9N+xJKNfWW2RZ61QkoO9q0iEpWO79pH2Vn9O7W9OdUUqjK2TQvypA36a/KfHHNo4OUR+/FJLQ37bkXvjXvWL5EYw67I+j9GHJOHnlTZ8x5WPIoYtmI7YUQYzymG4fbIvXLpTmkGHlVmXeKSPXHgD7CbYVbanos4goW1/K1aDJOI8Rwz56hGORXU/qjw3GHBzndMZxyVtatUIUBTeQkkuxhZoFi5XWAy0pR8xowLRTx/ev43FnunDB8+MlS+ro0X7TbrAJfwuDUVrzP5/hXF5ICyQ3k2M9tECfMw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(136003)(376002)(39850400004)(346002)(451199015)(36756003)(86362001)(66946007)(66476007)(66556008)(6486002)(110136005)(54906003)(4326008)(316002)(478600001)(38350700002)(38100700002)(41300700001)(6666004)(8676002)(5660300002)(7416002)(44832011)(6512007)(26005)(2616005)(2906002)(1076003)(186003)(8936002)(6506007)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?W+32iPuRYzIy6Qdyhwg3ltMAlNUu1eT0+aIUU85MR3GBLX9pdqdddiV0PkOo?=
 =?us-ascii?Q?rX0avehXNoF2NTGimuNCUY06wBjCmY2zjovpDwk1akpyDhJ16LAWEYCVGsal?=
 =?us-ascii?Q?7+BfLu3cI6Cu17zVs6QsVxDFyX5sLpfLVkokiVV3K7X+5MaXzDIZaUzRBdgv?=
 =?us-ascii?Q?tMs98SDTRs8X9SsLpwDc5IXu+9PZb74c8ZlL8DWyFwkAM4/Fv2Gfv+lyY70p?=
 =?us-ascii?Q?iHjSdjsL6DqqrUFTWrOjbPczLC2vXYhKCHbJIXKvwR9AqIq1C/C1V8hJHBUx?=
 =?us-ascii?Q?oroCm1hjNH/SqnDEKojlilCLCNSGAd3fzZdtDQM9pqS5hcYrLIQFRMSET75w?=
 =?us-ascii?Q?yceraIQPF5yQPn1hvxUdnCDZ5roMezNDZ8yAST92KqQnUsjPn+Ls/NDSjVpJ?=
 =?us-ascii?Q?MU6NcSHNI+a9yupx4CS7AGi9imM6UYQmx8HUKabUmJHLbyEv0fTyqXkiWZd4?=
 =?us-ascii?Q?It9QclVsM+vtSXl3ahswxKkg26RQMbmwvIuAy51l7wF4QpX9n3bIZuZpQJ31?=
 =?us-ascii?Q?Nq1CTofBbI+nzxiwgiPXb0TbE9NDqFq34YsYs6nywotP3wqAwBUPNOkQoNMo?=
 =?us-ascii?Q?+ENGamnCxGaHiMGn4dGWcU29ER880CEVRAs6TnBooZf+W+yVf+XWJJJcE3N8?=
 =?us-ascii?Q?tihTbphLpd3xXPoa4O7veZrT92TWvB86plx/ChB0yMKbKmrNwFSWA5gKaort?=
 =?us-ascii?Q?yZFiLoDCgsop1nj+DBAUQ64h/3X5IAhCXd35PYreLtL6kQ+CBcH1uVUlY6FP?=
 =?us-ascii?Q?mVC4GCYwt0aE10+TS5Ei1guNDDLXCn3pempyZxbzNg6AZT7aKiJy+umfxKu1?=
 =?us-ascii?Q?ua6H2BySqa99qF2ZPSGKQqkTuRkTRGHFRnotNXeBoA6/MJpFBab/EaeB5ARK?=
 =?us-ascii?Q?R8hN5LRfmjo3VAb7YCpvQUQkzGOfpkDL/X6M6H5PZvtfVlvArpCH1C8mFsaZ?=
 =?us-ascii?Q?AWfESth2munfEKu5yAzp38qU0n7L5y9Zj8dXLR8FrqxyLtT/ragYtAmFfqnJ?=
 =?us-ascii?Q?g3eC8x7fGGfF8rVdhqegwVI3OgkGTN5YyyW+eiZo9Pj0mk6tp7bzLb87J/0J?=
 =?us-ascii?Q?8mSNMxO5xROd9Tg+rcZO2gzsoyDjrkAO7uomMn5f/tf0tI/c+hQWhArr6RKP?=
 =?us-ascii?Q?eJ0CjP7cbAIIYWKSOXRTbYvrkl/DwrQBkFGRhTG3fvah4EqKembsF6QjEuI3?=
 =?us-ascii?Q?xm+zWqL8wtsKUW+ZJX6l/MlCtLEWLTSKv7VqSWIJsomX9oT92YnPGyCSWzrV?=
 =?us-ascii?Q?XUyLVx2dm+9xNcltRyCTZFtJFpaDQ3i1vz3RXdct2Exqvms4+KZPvTjb5WRl?=
 =?us-ascii?Q?YpSbp3+F8MJAi9mPyvJWxuvflgX6/tM16DDG70PcWloOlqKaVY56BsXDLYuZ?=
 =?us-ascii?Q?kgC6kzSlxrtPLzT3hivkdn4xGnHoLYAQ7hRBEgkpuFMbEMQm+EpR2eDWVQdt?=
 =?us-ascii?Q?/2K74KkV1USzWomSDHR9SAMZr2+vKIu0e1TktPXlOD+Z57tKqIRKa6Pgd/SK?=
 =?us-ascii?Q?gY/D5Tx28RMUPHJYLfo2VVRdC86vPTbB28A2bmjOR9IwNPh6EZ635DElGUjm?=
 =?us-ascii?Q?Cnp8iItkQ657MNuPEWRJ2PMyaabcBUBFSxmPjWTSch868nDq4sp68WnZzCc4?=
 =?us-ascii?Q?fw=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da5b0098-6f91-4411-101e-08da9ff1d741
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2022 19:03:47.4896
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9BYMX+o1n0nzIgoxbxIR8ekEboP7yjupZ/9zti6549uilEXgTatMaS9dCyUZAk/X/5OYGgTS3mNQLRr2IZsqMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR03MB9246
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

(no changes since v3)

Changes in v3:
- Split this patch off from the previous one

Changes in v2:
- New

 .../boot/dts/freescale/fsl-ls1043-post.dtsi   | 24 ++++++++++++++++++
 .../boot/dts/freescale/fsl-ls1046-post.dtsi   | 25 +++++++++++++++++++
 2 files changed, 49 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1043-post.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls1043-post.dtsi
index d237162a8744..5c4d7eef8b61 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1043-post.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1043-post.dtsi
@@ -24,9 +24,12 @@ &fman0 {
 
 	/* these aliases provide the FMan ports mapping */
 	enet0: ethernet@e0000 {
+		pcs-handle-names = "qsgmii";
 	};
 
 	enet1: ethernet@e2000 {
+		pcsphy-handle = <&pcsphy1>, <&qsgmiib_pcs1>;
+		pcs-handle-names = "sgmii", "qsgmii";
 	};
 
 	enet2: ethernet@e4000 {
@@ -36,11 +39,32 @@ enet3: ethernet@e6000 {
 	};
 
 	enet4: ethernet@e8000 {
+		pcsphy-handle = <&pcsphy4>, <&qsgmiib_pcs2>;
+		pcs-handle-names = "sgmii", "qsgmii";
 	};
 
 	enet5: ethernet@ea000 {
+		pcsphy-handle = <&pcsphy5>, <&qsgmiib_pcs3>;
+		pcs-handle-names = "sgmii", "qsgmii";
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
index d6caaea57d90..4e3345093943 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1046-post.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1046-post.dtsi
@@ -23,6 +23,8 @@ &soc {
 &fman0 {
 	/* these aliases provide the FMan ports mapping */
 	enet0: ethernet@e0000 {
+		pcsphy-handle = <&qsgmiib_pcs3>;
+		pcs-handle-names = "qsgmii";
 	};
 
 	enet1: ethernet@e2000 {
@@ -35,14 +37,37 @@ enet3: ethernet@e6000 {
 	};
 
 	enet4: ethernet@e8000 {
+		pcsphy-handle = <&pcsphy4>, <&qsgmiib_pcs1>;
+		pcs-handle-names = "sgmii", "qsgmii";
 	};
 
 	enet5: ethernet@ea000 {
+		pcsphy-handle = <&pcsphy5>, <&pcsphy5>;
+		pcs-handle-names = "sgmii", "qsgmii";
 	};
 
 	enet6: ethernet@f0000 {
 	};
 
 	enet7: ethernet@f2000 {
+		pcsphy-handle = <&pcsphy7>, <&qsgmiib_pcs2>, <&pcsphy7>;
+		pcs-handle-names = "sgmii", "qsgmii", "xfi";
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

