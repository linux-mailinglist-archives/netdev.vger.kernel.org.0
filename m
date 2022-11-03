Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65B09618A8F
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 22:29:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230203AbiKCV3P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 17:29:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiKCV3N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 17:29:13 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2065.outbound.protection.outlook.com [40.107.20.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16E2855A2;
        Thu,  3 Nov 2022 14:29:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JhBoNo3xzqgcB3wVFAGO4b5i7/VnnbmRVD2nAHJUIQKYjs/VlMZGcZIpl7SWDymyZs6xqFn3EJI9rdwEZ/aZFm9aOW/2cv9n/FUP1b16XXJyT0dL0Q2J8G7hPR3FnsI5zHNOyzTRgFcDgS6DOVZgHo+sF/QKNOHcnoq4rXBhW8oVBSUrhPFQ7FfZ6BYm/MpqQuqtZZKo4Ac158+/xWbTZci7XEmTgEqqmV6oey3bHRrihWMaIsoc4NvjgXKjPonlGcToi15+8SOkmNGTIK9c1ydTrSOE97z5Jhaws4PMkVkibRMCb1tTwFi7LFsXZeSsjOiPX/cD7tVnnz7uSEskbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tntTxbXp2ELk93YtaBjulyKkUUn/7g27BaLwq9nN38w=;
 b=TfiplarKELtAO5aFMuH/6mbhmAXiiiLUsB7ZSHT2VBCALyHZB8ogZhd6j7cU02tNP486kS7tOPNWdZIvlDaMbm0xymH4sxi55ne7yLkuOmBhDFaYrmdjdTuTliZWH01cvwfCNgaCQESyzv/aZWVczgdw4YwiOkMqcHuCUL1b/Yjh0Z5b7lnGtzjzjfLFRYBrjUc5kaTXU+/MCxuj/cXByIxHmXOFpVoFPXi5Y1P/2ycoJiZGvdvIAxeLFYdAT2JgKny9O9QyCL8gubDG51W7RiRJ3OgiEdoopX3Buu3Rt3DVk8kNwvc+v6cEBMaRTyfkUxdarRbGlWowyIr5gECf/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tntTxbXp2ELk93YtaBjulyKkUUn/7g27BaLwq9nN38w=;
 b=f81VlU1rdoIAAZh828GpoFgOULOGVoUVTzeoNozZmF250SCBOaEJ2c8e/mGIPdXkHcDVdDU35YhddA7KoeZ+hb7zLcOcz8rEzm5M4PPPGx862cUPRCPm/AukC/+n6iKalwbnm2oLVfi2irC8w+P0lDVtj0/9eWiwIcgV2yRP0IFyiHOz8THi7DpxF6LXv4P5ljXu3jP+qPKVszOgD0XHKwMpwZXEHRioc+RuuDILRJwrEXbc6brY+fZf5eVi2MgPTZEOemCJhly7I+Ct7uvt73gq9JQpDmRCyRjB13IVEOqRSKMYzOHjbgwIgPSq0q4wSwD53eon1AVQAhYdAf6ubQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by PA4PR03MB7487.eurprd03.prod.outlook.com (2603:10a6:102:104::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.20; Thu, 3 Nov
 2022 21:29:09 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::e9d6:22e1:489a:c23d]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::e9d6:22e1:489a:c23d%4]) with mapi id 15.20.5791.022; Thu, 3 Nov 2022
 21:29:09 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     devicetree@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        linuxppc-dev@lists.ozlabs.org, Nicholas Piggin <npiggin@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Sean Anderson <sean.anderson@seco.com>,
        Camelia Alexandra Groza <camelia.groza@nxp.com>
Subject: [PATCH net-next] powerpc: dts: t208x: Disable 10G on MAC1 and MAC2
Date:   Thu,  3 Nov 2022 17:28:53 -0400
Message-Id: <20221103212854.2334393-1-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0258.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::23) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB7PR03MB4972:EE_|PA4PR03MB7487:EE_
X-MS-Office365-Filtering-Correlation-Id: f92286f3-645b-45c5-fcde-08dabde2718c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FC+9QgjecyYYF9UDWSbhjaUiCHgTZOisLCrFMCSRs8LQTjgnA75jWUPTDMXU8RAv+qfgCJjs9/KTDms7NAm44PfjJUvpmxoJYDRo/Gngo4zQIGgbgmy0hnOFbWxSum7R0X0Gmvj9mNSZ+LJqmAcYDxB8dVs28T2EsvCt7psdQISqC7BtGubdp7HxCuSkmav2OStdmyDxZ4YrHs5rFfmF+qvg8PG60+cEDhWr0cg9crLfxKtfydQkmFd7YZKD61lszK9Jg1Lq/IdNjTGLsj3bqKrkVZf0L/8lOEG/qGY/hjQKmRY6YqooyCK9sAc0wr9wMuX7rs7Ha5wRYXCA5Wo0DnWREJvwlDkco7Vy76hDnaeAz+IXOSYzpnsEKnFB4SvYqdnQpTx59dDlQXgSymYyaMI76qdS/tY7soBJK4hxiP140EdYj3UQFjitwtxCBV/Xt99hKj6LwBX9JBr1+XADvaZ34x7jrLEIXpwesomyB9cDrceQdkoVbdb4aku/x6RmQpDjwzJ31vJY+W+qUasZw7aiwl/LH6YvhErXOX3lWnrER0lo3/bXyexzlpRivN/AjY+8ZmTTpXSARno5d9T2VOZIXQ2UwkXAYwyRt+w+71qXpsMnTdwpoJ1wKfvrGOvv2ihcJG2iOhCGIthh+yAzvRBdkuMRPOqORJVZnAtE6mfVOYoEq1sri5MwvT9CWIaXOxnnW6jbB8cSsUCgr3q+cKcXg8CZvbcxUuj5hk+M6T+sHAGugxC3hg85JvdcS41P
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(396003)(39850400004)(346002)(376002)(451199015)(41300700001)(316002)(44832011)(2906002)(66556008)(66946007)(66476007)(8936002)(186003)(8676002)(6486002)(478600001)(83380400001)(54906003)(4326008)(7416002)(26005)(5660300002)(1076003)(86362001)(38350700002)(52116002)(6506007)(6666004)(38100700002)(6512007)(2616005)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lT7YGlVEk5WhvueHuiiBMK+GxDvRKF9O/93TEn7JzQKOg+uuewpttytfdkhm?=
 =?us-ascii?Q?WZXUJuBrb0Vrn0w5IbSA7EnqOQcBH18dGWQBoWkvmAclWswxBlXbm12ycLdI?=
 =?us-ascii?Q?zDrS40VcZtFop55GUEyvH9m1dh4jYnTR6eggOroL3dQO/7lpiK4KI5VcB9DC?=
 =?us-ascii?Q?jsPnpkMjuUcRhaPKwrsbwUf84g/nPXOO25Aj0aPhUgtzi5jEGjPZogDCImwQ?=
 =?us-ascii?Q?nyWOt3yb3SAybSXm48ASjUSk86d7m3d1X5jmoxuyKgJ7rYDsk3iClNc1hH27?=
 =?us-ascii?Q?Mgx//XxS8opAvJEs+9P7SmliiX5Ol7qntE6z/s/ssYNMoF3ZN1EDMeySkVc6?=
 =?us-ascii?Q?OQ0oBrBw3LEo1JnChRGXErYGF4SQtWcc6PjEElPpfS+5wAVddPVoq4SziTGL?=
 =?us-ascii?Q?BGCW+D80Zx/7+KDM8mtzT9OIFqLjI2xv7yGsYbOcYBulaw9ANWVLAzuKmyOD?=
 =?us-ascii?Q?EmcY7nePFwOp4n4qmLpbRbhfo1r7wMvoK5kSHaafX/5U/h8lV7LbCXt18trq?=
 =?us-ascii?Q?sVPUDc3K1XagBUzwG6GCFhz4uB+XeswZii6rhqGiZarX50LjifqtyRumOqPA?=
 =?us-ascii?Q?w6VSe0BMfjDou64ljSgWyzlYXfP0igVHJxFtN03aVNe9kyAJv8M29u+bmVyz?=
 =?us-ascii?Q?pImpfUEJXvVhfJe/rEn6jxPwMNuPVhcamuOVcLINJ8hrygfv8G3lkju1FF0y?=
 =?us-ascii?Q?Oi4px3mSK2L/0nKk8ZDw+LB40NBxsoki+MoWOuLN9eMlYK4pqCvzZSA7B5Fc?=
 =?us-ascii?Q?X74UonBQrnK10R5sadQdHQSK98RS1+exD8SNQSVOeWB97d8rmK4tzl3/T4Ii?=
 =?us-ascii?Q?7GwRsUlg4jHwxC6MoEMqFISCng6+ZW2IEhojEJP4BVL4yd04zVAxIhyM8DcC?=
 =?us-ascii?Q?k5yvi18FjqNzBbZkSeAiyQdfiWpuGG9Sg4RyJ6twDmUWhnDC6ohJum7nfgyv?=
 =?us-ascii?Q?TDSvpT8nOkw46LPaPkb5tiVjIgpWiCgM4gJWDZkU2PVSpwwsPVCT4hupKma4?=
 =?us-ascii?Q?ay9xxX3DeJfiUkS2CFbTtSp+c60HrDtaTLHFY6/yKyw49RFPnMTVYJfYsZ7m?=
 =?us-ascii?Q?0KuKTiMbsheIwoHZxY88xQ0awYYKiT5o8+9Y8i8YYuBUrNME02l9HgecCv0X?=
 =?us-ascii?Q?Z71euvc4W6lxDfSEm6oWUDWvvFwov6DReAGONJlbJWH+1izP2YarWlE+KWW+?=
 =?us-ascii?Q?KmCbhlxuygP7BcCDZEU24hJFUJaAUgMzA98vjCfQipNKyVQnOFUpq1YbcAft?=
 =?us-ascii?Q?w9ZxgGs32VGLojgEXM5JpozGNeSgaNPgOGXJ+WZqHiD3YHnn5iWjQQmIDx5h?=
 =?us-ascii?Q?qItj9J/MDCBZtePk//Ms7be8PgvUzxk7n++WzY2WxkXgz+KP8bEl0Y1W+TWF?=
 =?us-ascii?Q?0f7aT4K0cJutn+CENKp/lOWPy5x6+uRh+kJs/ofDavSjkeKFg3D0VhXBHa+u?=
 =?us-ascii?Q?N44AIFQTPO/CY8i/x24d+nWbx1gitl43qt8QVAYuR2U1YVrGdmWhtZ2joJ1u?=
 =?us-ascii?Q?uCUsz1Gy7mi3h1hRH7j/Fq+So8FZ0KSMu9T0rezRjXqRf2wvxkq3y5D1FefS?=
 =?us-ascii?Q?ZP6SuIENkCBjKx/FYkXSka+IRX+LspaspBYj8sSof9CvFf7Zsik4eoEThcYU?=
 =?us-ascii?Q?0Q=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f92286f3-645b-45c5-fcde-08dabde2718c
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2022 21:29:09.3545
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZPRGK+9/b6Aws5r4iFEy/sqnqBXH8P7NSGMhO5Taxqu5X5ZjBiLWyM3Ew2kC0placpHLEkehqY91dH/9HxK/8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR03MB7487
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There aren't enough resources to run these ports at 10G speeds. Just
keep the pcs changes, and revert the rest. This is not really correct,
since the hardware could support 10g in some other configuration...

Fixes: 36926a7d70c2 ("powerpc: dts: t208x: Mark MAC1 and MAC2 as 10G")
Reported-by: Camelia Alexandra Groza <camelia.groza@nxp.com>
Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

 .../boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi     | 45 -------------------
 .../boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi     | 45 -------------------
 arch/powerpc/boot/dts/fsl/t2081si-post.dtsi   |  6 ++-
 3 files changed, 4 insertions(+), 92 deletions(-)
 delete mode 100644 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi
 delete mode 100644 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi

diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi
deleted file mode 100644
index 6b3609574b0f..000000000000
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi
+++ /dev/null
@@ -1,45 +0,0 @@
-// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0-or-later
-/*
- * QorIQ FMan v3 10g port #2 device tree stub [ controller @ offset 0x400000 ]
- *
- * Copyright 2022 Sean Anderson <sean.anderson@seco.com>
- * Copyright 2012 - 2015 Freescale Semiconductor Inc.
- */
-
-fman@400000 {
-	fman0_rx_0x08: port@88000 {
-		cell-index = <0x8>;
-		compatible = "fsl,fman-v3-port-rx";
-		reg = <0x88000 0x1000>;
-		fsl,fman-10g-port;
-	};
-
-	fman0_tx_0x28: port@a8000 {
-		cell-index = <0x28>;
-		compatible = "fsl,fman-v3-port-tx";
-		reg = <0xa8000 0x1000>;
-		fsl,fman-10g-port;
-	};
-
-	ethernet@e0000 {
-		cell-index = <0>;
-		compatible = "fsl,fman-memac";
-		reg = <0xe0000 0x1000>;
-		fsl,fman-ports = <&fman0_rx_0x08 &fman0_tx_0x28>;
-		ptp-timer = <&ptp_timer0>;
-		pcsphy-handle = <&pcsphy0>, <&pcsphy0>;
-		pcs-handle-names = "sgmii", "xfi";
-	};
-
-	mdio@e1000 {
-		#address-cells = <1>;
-		#size-cells = <0>;
-		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
-		reg = <0xe1000 0x1000>;
-		fsl,erratum-a011043; /* must ignore read errors */
-
-		pcsphy0: ethernet-phy@0 {
-			reg = <0x0>;
-		};
-	};
-};
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi
deleted file mode 100644
index 28ed1a85a436..000000000000
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi
+++ /dev/null
@@ -1,45 +0,0 @@
-// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0-or-later
-/*
- * QorIQ FMan v3 10g port #3 device tree stub [ controller @ offset 0x400000 ]
- *
- * Copyright 2022 Sean Anderson <sean.anderson@seco.com>
- * Copyright 2012 - 2015 Freescale Semiconductor Inc.
- */
-
-fman@400000 {
-	fman0_rx_0x09: port@89000 {
-		cell-index = <0x9>;
-		compatible = "fsl,fman-v3-port-rx";
-		reg = <0x89000 0x1000>;
-		fsl,fman-10g-port;
-	};
-
-	fman0_tx_0x29: port@a9000 {
-		cell-index = <0x29>;
-		compatible = "fsl,fman-v3-port-tx";
-		reg = <0xa9000 0x1000>;
-		fsl,fman-10g-port;
-	};
-
-	ethernet@e2000 {
-		cell-index = <1>;
-		compatible = "fsl,fman-memac";
-		reg = <0xe2000 0x1000>;
-		fsl,fman-ports = <&fman0_rx_0x09 &fman0_tx_0x29>;
-		ptp-timer = <&ptp_timer0>;
-		pcsphy-handle = <&pcsphy1>, <&pcsphy1>;
-		pcs-handle-names = "sgmii", "xfi";
-	};
-
-	mdio@e3000 {
-		#address-cells = <1>;
-		#size-cells = <0>;
-		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
-		reg = <0xe3000 0x1000>;
-		fsl,erratum-a011043; /* must ignore read errors */
-
-		pcsphy1: ethernet-phy@0 {
-			reg = <0x0>;
-		};
-	};
-};
diff --git a/arch/powerpc/boot/dts/fsl/t2081si-post.dtsi b/arch/powerpc/boot/dts/fsl/t2081si-post.dtsi
index 74e17e134387..fed3879fa0aa 100644
--- a/arch/powerpc/boot/dts/fsl/t2081si-post.dtsi
+++ b/arch/powerpc/boot/dts/fsl/t2081si-post.dtsi
@@ -609,8 +609,8 @@ usb1: usb@211000 {
 /include/ "qoriq-bman1.dtsi"
 
 /include/ "qoriq-fman3-0.dtsi"
-/include/ "qoriq-fman3-0-10g-2.dtsi"
-/include/ "qoriq-fman3-0-10g-3.dtsi"
+/include/ "qoriq-fman3-0-1g-2.dtsi"
+/include/ "qoriq-fman3-0-1g-3.dtsi"
 /include/ "qoriq-fman3-0-1g-2.dtsi"
 /include/ "qoriq-fman3-0-1g-3.dtsi"
 /include/ "qoriq-fman3-0-1g-4.dtsi"
@@ -619,9 +619,11 @@ usb1: usb@211000 {
 /include/ "qoriq-fman3-0-10g-1.dtsi"
 	fman@400000 {
 		enet0: ethernet@e0000 {
+			pcs-handle-names = "sgmii", "xfi";
 		};
 
 		enet1: ethernet@e2000 {
+			pcs-handle-names = "sgmii", "xfi";
 		};
 
 		enet2: ethernet@e4000 {
-- 
2.35.1.1320.gc452695387.dirty

