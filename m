Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 582E74FF4CB
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 12:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234988AbiDMKhZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 06:37:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233801AbiDMKhQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 06:37:16 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60087.outbound.protection.outlook.com [40.107.6.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BABF613D1E;
        Wed, 13 Apr 2022 03:34:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cFIUzwAzGUZgUOZSZYWfXmcazRjR3R3JXDZpnXbC9hGqApp7yhPtsgiBgVaej55GE00fzLtL/d8R7d1XU5FhSeqjgIamXjs5t9ta1d64EimtWM4VztunCJ9nlLgYIVBUCXOlNGeAIBjpPq9FHD8shLBQnNHPjVDRcFYilUKG0/LmCMrGg1w4IIuBDuhT/rlDBjazU+M3jbGboCnQ+QojehxvDddj6d4O6t0qdyyBlycutCl/ownedTjmKiY33IMo+l9/CQkc91k6B2xJzP60R+Wzmaip0qYZOkGU/YjHnYeKnFtx78Ez5cHNtilJP69jAKIcrA4CsQEtvBSB35XfuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jJ1zyprXyaDqs2f/1Gpp6qOrzuHRbM+I4B5BwmIUfgE=;
 b=EdwUtMUPmEAr6m9QWu1WjXmRJ6Bh21H83Wf0WySQ3UlsmV1odtoboOYwwajgKNaWnyjTbyIVfxKOjf455mfrs/upmV0HnkYdZXu7ZSN4qLGvNtCJY01VHurNcibStwDdV1mnWdvg5agRVKTY/ad1yO16byes0z/LNV6KD87xVZovv4rVSOTRvEKdM2TNsNsJzjXFEjEz7fp7UV4xux8sK2QnqKBc2uWyaBkwvGWRlU26A8LrVr5z9HZ24fAewRQzgLqny87YQ/mVTiqEwOqWK/9kuuz69NFSGaD8i2PSME4OgbcenCcd2wejBcbSbDFvOsMih4rSD8xoxcnTitAOgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jJ1zyprXyaDqs2f/1Gpp6qOrzuHRbM+I4B5BwmIUfgE=;
 b=ovA1/ZnvemEN0Q+RtDxezFp9dg5+346I1LkAG9+yWsGr7rGjPLCFJKjWhPxUsrNpPop3o2tcjxN0WL3uVqJ+a2cHF4jZhR/nCCRY9k8agCj1EIO3dqL5XZM97d45A2bEwKwXg/2A9iidZSFJvQaFrrVTAuQCJU/qAxZVZCqMc/o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com (2603:10a6:803:6a::30)
 by AS8PR04MB8691.eurprd04.prod.outlook.com (2603:10a6:20b:42a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Wed, 13 Apr
 2022 10:34:43 +0000
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f]) by VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f%6]) with mapi id 15.20.5144.029; Wed, 13 Apr 2022
 10:34:43 +0000
From:   Abel Vesa <abel.vesa@nxp.com>
To:     Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>
Cc:     Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mmc@vger.kernel.org, <netdev@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, Jacky Bai <ping.bai@nxp.com>
Subject: [PATCH v6 05/13] arm64: dts: freescale: Add lsio subsys dtsi for imx8dxl
Date:   Wed, 13 Apr 2022 13:33:48 +0300
Message-Id: <20220413103356.3433637-6-abel.vesa@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220413103356.3433637-1-abel.vesa@nxp.com>
References: <20220413103356.3433637-1-abel.vesa@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6PR04CA0047.eurprd04.prod.outlook.com
 (2603:10a6:20b:f0::24) To VI1PR04MB4688.eurprd04.prod.outlook.com
 (2603:10a6:803:6a::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 719d7553-e1e6-45b1-acd0-08da1d393939
X-MS-TrafficTypeDiagnostic: AS8PR04MB8691:EE_
X-Microsoft-Antispam-PRVS: <AS8PR04MB8691488CDCC2838A8DF58487F6EC9@AS8PR04MB8691.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m6oOsQDfDfcBrIQiuKiv7J4fC4PcupTghy14h+ePvivI+V/hQX+KSHv+uoTCEOgHnqg9LOZhVEF90uF95usBiZrgKd961w4xd01H9XW78QfXltPe7Dsc8cVjq1A+Y7Vs1lr/9Xa+e3EaLor7HT4u63pgQPfsAFzKm4v8LKR1eOC43ssSAo/DD6w22ymAY6pFueXKql50z2wZZw9NYJjKkvtz6piYIFcVgzc/nrpvQbRJhg7EgXIyHP15gwl8JvCUne6P/fqjStGsFfYey+YeofkysIO1EWmKebG29HUySA8wxAxdjwWaKKM+Q59HUADqjsN0UTKA6AimFpwmvRpm8Zxs3Ff55EHNKlXVHAwAUchNpSjcWScw+/k31Ex3HsBRjkt1NvHOMQZNF+ipriiNjUqR8FYaRrFsZ2HRVP7meAI7oOaEc8nba04LIAQXtkVUdg8QbcKsc8XX9G28U/kneuzTSjLYJIYAVw5IJbAxSNrLp/Z1NDQLVh5xDzn1VJQRNaGlThSIEGoYZEXmolx874ce+jfDisyWMJhpgYfyQwucopnRNBNsPg2r7+9qV9Wgq42RjCy4HB8mSeDi/rWsREEdMpSKpW18t1hT9z1Y1BAs1CeE+CCf8Qrv35r4Dc9i7vLVQAsDGsdEJICoDC36xIPHnrCqTzkcEE9rfgH7qN28s/8h86fHALMC1/asM7ogAKv6F/mDLWHQI3KwYPShaCMU9ohow4+CVgJKTxJVb+w=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4688.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(38350700002)(38100700002)(4326008)(66476007)(66946007)(66556008)(316002)(54906003)(110136005)(508600001)(1076003)(8676002)(26005)(186003)(2616005)(52116002)(6512007)(6506007)(86362001)(2906002)(44832011)(7416002)(5660300002)(36756003)(8936002)(83380400001)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xy9H3SwphUkFDVaBxS4uRQp8r9sf2WjKenzy+I/joF9hpczLZMAOPbuDP08q?=
 =?us-ascii?Q?XgVT6GIxYTTkXn75z0uqqMJ0NNAjAv4UGbIE3vxmBHjQDJBJ0YKw23F6+h/e?=
 =?us-ascii?Q?jyYr5jg52j3yxgsgc4mt1wRoKySO5uD+vgiWS6YO8d1BIGHcEV8RGblxoNsZ?=
 =?us-ascii?Q?upZrNZouoVafsYEgVIqJ7SCGy26P4Ck4nNAHHsgzeiJmxXR5uSiUrvuQdBT/?=
 =?us-ascii?Q?e44hLOeHpu+AMi3YmaHogXWEtkyDCSDTe7v0KS2IMuELBBeHh5yXtTNOLJMG?=
 =?us-ascii?Q?39vhFycRMh2KZfgnHyB/AqQQAaMhN3BpBr6dZEpCzQTwGIi7ylOVj1yP4qUm?=
 =?us-ascii?Q?1NUZ7QZsNe9srtoTRUsWvJZ0oQDnWnmnId+2G9V7b94umCJJZ49845i/nwSj?=
 =?us-ascii?Q?M1PEEZPHIBiQl0KiaxMXYJ06B/IBpSnl31RABVtrwzUtlSV7qf7wJ0O05k6l?=
 =?us-ascii?Q?5GwMuFgXM5BHVxKl8uFajolPyikvQ9sX5Y/V+e7IWug2MLuOYt6i0atB626q?=
 =?us-ascii?Q?OwTkIXNI4Txbstdnuys4DFh3/P7IZScrJ6wDnCchq2p4Zm1RUTIrCxACuLQT?=
 =?us-ascii?Q?q5shk3MDcokJCbgNaEMeSqmF97Cs9bWbKPnfgn+FTK4jQGcaFO/KsWWTzPGj?=
 =?us-ascii?Q?VmRddUDtf/Ls8aJ+g0LwDNx9l1r3Y4janrO73MhhTwk3z0QPTL3oHGaWUa+R?=
 =?us-ascii?Q?msXOc3L2LJYXQrkQwvP+idrq3zegd9limmToaovAz+JByeBGMelE2vJ9n1MB?=
 =?us-ascii?Q?UOzHy52RXwFIznsRKpZKEoMyxO7xteRzIjCbcElGlkFtNWXhrj+KtRR8MMGe?=
 =?us-ascii?Q?eWedZEAM3NZ1Qtv+N6DXWucxbU6zMOFHzorsGVdOu2BnqloIO5sk5A0wGS3u?=
 =?us-ascii?Q?XxHm6XOqmU9xRp4FjmHrtRIjTjGUINuFLVx0j1WbIlbx2r6ne3w3gXnvHQ6s?=
 =?us-ascii?Q?ebbVtK/we7DaXgpZr1mwRP2H/niDAlXPqUKyFKsTUxqmdUKyy1d2BQhC5zzD?=
 =?us-ascii?Q?/6wKp11G1XTIjPzgUHQTfKOyDL1PjuL9Y6ntBL8J3gkNn5HQ6nwHVo0Vhr22?=
 =?us-ascii?Q?aoZlK6WwRv2WBaIpjA4BpVaWHzyV7tG/abujwPGQVgJFNTnSuWqAkg7U/zod?=
 =?us-ascii?Q?mfXo2KW4TGz5wtQ51dPXdh8+MgM6VP2j+Tzbs7/uhXTLur09dMTOwExphHEv?=
 =?us-ascii?Q?FhcMjJ/ERD0kSj8E76rF7NU7e1jhEHnqez42FlZHYYuUZ+6Ycnak2fCt5PfO?=
 =?us-ascii?Q?Rz6yiDMLp5zBnqIFxlmDa2PKnDZqEu3SPV4yR/0+PAnza2PY5oTFU0HxV7sh?=
 =?us-ascii?Q?j8tMYk/HxaNvxUkKXSbJpFNtDhFychI9xJ/QFo8T02FOtLo/vcxVv3JVFArS?=
 =?us-ascii?Q?4qRqLA/l9zka4CXdRwJ8HKF0tFuOjZbQXapBn7/bOx4V8PAzD/6BTRUATF7v?=
 =?us-ascii?Q?EV72cYeLf9A0Q4IvIqrQ29z4vimQj3jHNpExMRVD+TxP6FxIEqDHoncimhmX?=
 =?us-ascii?Q?EvvykHNuHYQfl8vziqNYhGJafinkeDC1LWHu69+8pOveQoHjpdIeVHwKMk+b?=
 =?us-ascii?Q?4aRV4aFU1pXyFQ61WwQuvf5PeeZbLuU4SCZMd1ADmp0Q5aeUqFtBUc0DeaTY?=
 =?us-ascii?Q?j+T/RjUUVxc1Eoclrhoe3L1sW/93F+RDeCaA6J3EEpzDQ2+gBJZbov+0Svcq?=
 =?us-ascii?Q?YdVWvPH/gdLRRB4tchXbI0BpOKUz65WOqaT+ZfKfFh4IckqBNl7wL+6cTrN6?=
 =?us-ascii?Q?gtF7Jx/jXw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 719d7553-e1e6-45b1-acd0-08da1d393939
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4688.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2022 10:34:43.7862
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BzhHiU35aWfs2BPprDEd96aJXucNxa53SCdlncvoMBviylk6JCE4jr9VK1GbZAWSsKmPjx3JsHHmwX8BRX+gEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8691
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacky Bai <ping.bai@nxp.com>

On i.MX8DXL, the LSIO subsystem includes below devices:

1x Inline Encryption Engine (IEE)
1x FlexSPI
4x Pulse Width Modulator (PWM)
5x General Purpose Timer (GPT)
8x GPIO
14x Message Unit (MU)
256KB On-Chip Memory (OCRAM)

compared to the common imx8-ss-lsio dtsi, some nodes' interrupt
property need to be updated.

Signed-off-by: Jacky Bai <ping.bai@nxp.com>
Signed-off-by: Abel Vesa <abel.vesa@nxp.com>
---
 .../boot/dts/freescale/imx8dxl-ss-lsio.dtsi   | 78 +++++++++++++++++++
 1 file changed, 78 insertions(+)
 create mode 100644 arch/arm64/boot/dts/freescale/imx8dxl-ss-lsio.dtsi

diff --git a/arch/arm64/boot/dts/freescale/imx8dxl-ss-lsio.dtsi b/arch/arm64/boot/dts/freescale/imx8dxl-ss-lsio.dtsi
new file mode 100644
index 000000000000..6aec2ec3a848
--- /dev/null
+++ b/arch/arm64/boot/dts/freescale/imx8dxl-ss-lsio.dtsi
@@ -0,0 +1,78 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Copyright 2019-2021 NXP
+ */
+&lsio_gpio0 {
+	compatible = "fsl,imx8dxl-gpio", "fsl,imx35-gpio";
+	interrupts = <GIC_SPI 78 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&lsio_gpio1 {
+	compatible = "fsl,imx8dxl-gpio", "fsl,imx35-gpio";
+	interrupts = <GIC_SPI 79 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&lsio_gpio2 {
+	compatible = "fsl,imx8dxl-gpio", "fsl,imx35-gpio";
+	interrupts = <GIC_SPI 80 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&lsio_gpio3 {
+	compatible = "fsl,imx8dxl-gpio", "fsl,imx35-gpio";
+	interrupts = <GIC_SPI 81 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&lsio_gpio4 {
+	compatible = "fsl,imx8dxl-gpio", "fsl,imx35-gpio";
+	interrupts = <GIC_SPI 82 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&lsio_gpio5 {
+	compatible = "fsl,imx8dxl-gpio", "fsl,imx35-gpio";
+	interrupts = <GIC_SPI 83 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&lsio_gpio6 {
+	compatible = "fsl,imx8dxl-gpio", "fsl,imx35-gpio";
+	interrupts = <GIC_SPI 84 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&lsio_gpio7 {
+	compatible = "fsl,imx8dxl-gpio", "fsl,imx35-gpio";
+	interrupts = <GIC_SPI 85 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&lsio_mu0 {
+	compatible = "fsl,imx8-mu-scu", "fsl,imx8qxp-mu", "fsl,imx6sx-mu";
+	interrupts = <GIC_SPI 86 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&lsio_mu1 {
+	compatible = "fsl,imx8-mu-scu", "fsl,imx8qxp-mu", "fsl,imx6sx-mu";
+	interrupts = <GIC_SPI 87 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&lsio_mu2 {
+	compatible = "fsl,imx8-mu-scu", "fsl,imx8qxp-mu", "fsl,imx6sx-mu";
+	interrupts = <GIC_SPI 88 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&lsio_mu3 {
+	compatible = "fsl,imx8-mu-scu", "fsl,imx8qxp-mu", "fsl,imx6sx-mu";
+	interrupts = <GIC_SPI 89 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&lsio_mu4 {
+	compatible = "fsl,imx8-mu-scu", "fsl,imx8qxp-mu", "fsl,imx6sx-mu";
+	interrupts = <GIC_SPI 90 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&lsio_mu5 {
+	compatible = "fsl,imx8-mu-scu", "fsl,imx8qxp-mu", "fsl,imx6sx-mu";
+	interrupts = <GIC_SPI 94 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&lsio_mu13 {
+	compatible = "fsl,imx8-mu-scu", "fsl,imx8qxp-mu", "fsl,imx6sx-mu";
+	interrupts = <GIC_SPI 98 IRQ_TYPE_LEVEL_HIGH>;
+};
-- 
2.34.1

