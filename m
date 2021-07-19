Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CDEA3CCE67
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 09:21:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234926AbhGSHV5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 03:21:57 -0400
Received: from mail-eopbgr80084.outbound.protection.outlook.com ([40.107.8.84]:53216
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234913AbhGSHVu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Jul 2021 03:21:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kz7nDZEaUln11iOAhdmx5jDgUFdvKA9ptI2cZghQdScwWx3grS+vHR7RGnUap22VvR1n56ZzQAld/VfVqQ8wC6b+of837ascQqkBKRRpJgn8W7dnL+a0Zim6XvfmJU8KzKv8Kk2RLoMkiWcuQBNRd5zE0xCF5HSm3HIAIiwlGO/lSCVpoxgKXTOtj4DJPmMPxfYFVh7QRhZ4Harca3kFK4+MZVrRGi6z1yZ//xQgYF/VPuu/DnbvxU8bx9o8eTBegoJgjAUuoLaxmy72bAkj63i6Geq4om7pnC7a7PNBkl4C+eGVaD8kfxPVuBm6n2+vsrPD0e3g7OInm7JLtzdkfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=19rkpx+g7My9PF8wiXbOZ1KWbt5dYUhAthYEDjArJ7A=;
 b=LsxDApgXiPSXCdYO7KpgWFkKHZuuK4gxTNWM+DmkfPbyLZjYsX15mdU/Yj4fg9Rvqg1j1HCmy0YrdiE41RiV67A6TlIbBLEjPBf1y2JMSmvf4dlstAxZUoSSNoXDYyD2hhxKMGE30OTXCOqj0grvwAGoGvBYEUgL+iKa7YF2kQ8FFWTE2P8SbI0Mz9bgemmIOt+sfwSMa6ndr7jTyDlWGNKfReZ+QmCvJGo/SX/xkUbReEYoNXEoMF/HZNT6wblCYiw5Eh4sZ+kz2oIeYt2/LA7PpnDW+7AjdcT6C6iX8xRyXNa6CHenhWnus+M6m6soLyq/uQT5waV6KQQYj/9ypQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=19rkpx+g7My9PF8wiXbOZ1KWbt5dYUhAthYEDjArJ7A=;
 b=kDzIl580sN8FkW1tUjvQ13eXfWZFMjwp5vkHssViIjhLz/0w0grFBN3HaFCdXC4ssIootQdrpLnS7dUCG/1oqtSgr7fx2Wtw18iCKlLhO4eIikgiX3F+vShwWQmaA/EDkBa/aajDzRS5vmrmSc9WLPGxlADD3Y+FwQANdFYvGLk=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB7100.eurprd04.prod.outlook.com (2603:10a6:10:127::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Mon, 19 Jul
 2021 07:18:48 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802%9]) with mapi id 15.20.4331.032; Mon, 19 Jul 2021
 07:18:48 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        shawnguo@kernel.org, s.hauer@pengutronix.de, festevam@gmail.com
Cc:     kernel@pengutronix.de, linux-imx@nxp.com, peppe.cavallaro@st.com,
        joabreu@synopsys.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next V1 3/3] arm64: dts: imx8mp: change interrupt order per dt-binding
Date:   Mon, 19 Jul 2021 15:18:21 +0800
Message-Id: <20210719071821.31583-4-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210719071821.31583-1-qiangqing.zhang@nxp.com>
References: <20210719071821.31583-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0067.apcprd02.prod.outlook.com
 (2603:1096:4:54::31) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR02CA0067.apcprd02.prod.outlook.com (2603:1096:4:54::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.22 via Frontend Transport; Mon, 19 Jul 2021 07:18:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6cef6dea-82c8-4662-67b8-08d94a857377
X-MS-TrafficTypeDiagnostic: DB8PR04MB7100:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR04MB71002F6D66B2DCB2B003EDBDE6E19@DB8PR04MB7100.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1824;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Jyqcb7LEOh+SNmLXJ8onoQ1Fwyw2V4bIV3zZlikighhWDea4H7JwyfvUGoHf+Cm+DnfLp6YfvFyp78zetB/8Tk7JVTxiJMGc82EK5JN36z20ARfhKI7OVrozkiv3kA0PA0ZUCyt6Kqj2TOtkzZ2jRw4zX1WbebhLDCbFXSo94EB97TbfTCYM/DBZLmXe609hlBhVoTRi2ebQ+2wSQLxySl6N699v4w9oYbq5/YqpZ3RcIfC4GCwCuxXKMWmStAfXOTsN32epSkevYz3O17cvccGdpM0lEKJOR7WWtBO1HWka3wTHXgiKfqZN6ZGqAzqXFVwQiV42JSR60cQztMsOaKnUIF95/amwhjqdUITCg3DYv1KFHU937HxVwMfxlsUUPzkFkP4x0Uj2IRrj0xUC2u5ugUnPagQGhaq33hnLHYMNKf+urJSGhmlYkkjEQ0eWoEgpHyD7y+xv7kR8pstmK9FauQ/7q7WiJ62TmexpZsGrDv7x1FFyk19K5smWlh/rWargNHjPMMcQStTBnKvzx73xECp/XVnVBkUN/2ni6ce6OITmNHjDkocQovhLXmLPWowmCblQSldsCFoNU803pXIHWp1ZyNcaCcHCu3AlxkGYQz/EEoXspTu4VQ5uMBNKBvEroAeHfvyjygLVN6Aq83jkmL3I8+9xS0fNBNF+rTtlvz2WgXIVQYnlQPmhUXZEg2J7GKI8Tedeh2bqKyji25nZpR3Ojz+IC1XjWNGrxcw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(52116002)(1076003)(5660300002)(956004)(2616005)(6512007)(4326008)(7416002)(66476007)(38350700002)(38100700002)(6666004)(26005)(8676002)(66556008)(8936002)(36756003)(6486002)(66946007)(83380400001)(508600001)(186003)(2906002)(86362001)(6506007)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ke2BLXXN5Q/B4+d0jnIcgH0KvRYIi5jMlYDUguG56DH2nQ95iuJcPCwI47AK?=
 =?us-ascii?Q?WAFRinrG8YXf8PnZw3df8sWgjgVnwfTUbsOnadA4kXn0ZgxzXVITCzvLx9V9?=
 =?us-ascii?Q?YfxhSjbFfZZtmiJ1JHZY4qPrt+fqeifbYEhyNden20MDce8kQyGmPVOB5BCU?=
 =?us-ascii?Q?/lXtwqF9A14xckORRXkWhSgWCuCM+XKzJxLHbf4HdX+ZaZxusXpXODp5L6mh?=
 =?us-ascii?Q?jPvbE5A14E/Cs0zcKBuoftLoTyKRUIQlW/0DtSZBEqQRhepSMCVa4nxnu/x1?=
 =?us-ascii?Q?VwU3bsL94XmZ1o/ypUwu2kEWdISF94yjSartKp7+GShzB5C6qwlW04u0q7uO?=
 =?us-ascii?Q?unEL7Jf500YLgYf8h0EOj9qMmMH+6t1Um7atkDLOzd321TZO30xISeytgDuY?=
 =?us-ascii?Q?qgYlrRuoxbuUwPJ+5xESF/wo0CishmSWfBnHmwDF2aOGTiPP+qA7lOZXoIYv?=
 =?us-ascii?Q?a3WA9INPOWVTMY2NzcQzZIOZ0XCs0+f7LKFFQe7foscELTqhyK4blKBIWWzk?=
 =?us-ascii?Q?Q/5b6GUpE+P31dxDyyduvQXn0g0xV9raZjZkQYIXhiEY5AjXUBR2lMPoxytb?=
 =?us-ascii?Q?nzTTtul08wopWJoqhqkhJFKc7bBDu9NRq14Iz37NPZukJO5RG+hsBpwuJlb3?=
 =?us-ascii?Q?Pr0p3zIDveg+hZBlGHrMBoyz+fvdy1JlYg6e7LWdEsSibTfA8kC24Yf1aLfv?=
 =?us-ascii?Q?8Kz0azFcEYciovfXxKaWjNDoEeOb5nalhM1wvLc0Mf27A0VmMk29AAYxO5WV?=
 =?us-ascii?Q?h8mgXCjuKQflITlgZojwnWwePZ68i5Z7HGYNl0Xf/WIrx+IQoLOrFQnDAo5m?=
 =?us-ascii?Q?rHyJnZIWkIejgzS3CpN81rOGMNcesYUi4qWFOEN7CIEnHcilFhwyuRxQGG52?=
 =?us-ascii?Q?VDl6JQKl0cx1+q1Pph97xOTBMJ68g0y2xaGMP39i96clIYYdPqY4V5q/nbGZ?=
 =?us-ascii?Q?i4AQhDvBR6ZzTagOOFH1lqbcjIRhZfMOdnScX3O0NMQVisOekRJ4mZV1Bmyy?=
 =?us-ascii?Q?VRnARBJUkvj4I6Zk7zR8SXYHLKXdo/ZuMdq/a2MtXoAJEGAoWnVFQmpt6cNa?=
 =?us-ascii?Q?Lv87+CMZcHWhOeGnJdpJTXVfmtgd3SayGWKCfx4tazIb1Xv3Bxhwd0qmKnwe?=
 =?us-ascii?Q?BKMhSHS+IBcqwolcQifdyMLjUZktn17h5i/kJ0UqX7yZzt11FCEeqJDcXhi8?=
 =?us-ascii?Q?ogw0LUfSjR9Us5eTBIkbrw3DdfnutZ9UCbaLCaG4uj1cHpLfPiCXeGKoUvYx?=
 =?us-ascii?Q?w5znkCQYKN4pTEjBNOdtJVHRHljRqY9Bbi3hk5SNxa1iko3EV8BwzdcgIvDH?=
 =?us-ascii?Q?JMwRVfDOYIcMmF5RJwWcJT1x?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cef6dea-82c8-4662-67b8-08d94a857377
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2021 07:18:47.9569
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gb8evlCxOG4yGMxAQnZUwB9tI+hVx7DVB3QpbegatSboe7FEUdw5QFYskCENkzcmWJTyZH/4tJq6/uQ0L1oTDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB7100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch changs interrupt order which found by dtbs_check.

$ make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- dtbs_check DT_SCHEMA_FILES=Documentation/devicetree/bindings/net/nxp,dwmac-imx.yaml
arch/arm64/boot/dts/freescale/imx8mp-evk.dt.yaml: ethernet@30bf0000: interrupt-names:0: 'macirq' was expected
arch/arm64/boot/dts/freescale/imx8mp-evk.dt.yaml: ethernet@30bf0000: interrupt-names:1: 'eth_wake_irq' was expected

According to Documentation/devicetree/bindings/net/snps,dwmac.yaml, we
should list interrupt in it's order.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 arch/arm64/boot/dts/freescale/imx8mp.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp.dtsi b/arch/arm64/boot/dts/freescale/imx8mp.dtsi
index 9f7c7f587d38..ca38d0d6c3c4 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp.dtsi
@@ -821,9 +821,9 @@
 			eqos: ethernet@30bf0000 {
 				compatible = "nxp,imx8mp-dwmac-eqos", "snps,dwmac-5.10a";
 				reg = <0x30bf0000 0x10000>;
-				interrupts = <GIC_SPI 134 IRQ_TYPE_LEVEL_HIGH>,
-					     <GIC_SPI 135 IRQ_TYPE_LEVEL_HIGH>;
-				interrupt-names = "eth_wake_irq", "macirq";
+				interrupts = <GIC_SPI 135 IRQ_TYPE_LEVEL_HIGH>,
+					     <GIC_SPI 134 IRQ_TYPE_LEVEL_HIGH>;
+				interrupt-names = "macirq", "eth_wake_irq";
 				clocks = <&clk IMX8MP_CLK_ENET_QOS_ROOT>,
 					 <&clk IMX8MP_CLK_QOS_ENET_ROOT>,
 					 <&clk IMX8MP_CLK_ENET_QOS_TIMER>,
-- 
2.17.1

