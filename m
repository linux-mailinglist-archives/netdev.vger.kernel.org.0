Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C661C3C204C
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 09:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231441AbhGIH4x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 03:56:53 -0400
Received: from mail-db8eur05on2072.outbound.protection.outlook.com ([40.107.20.72]:56865
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231434AbhGIH4w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Jul 2021 03:56:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QlVoNXPf/BQnZtDHHbYhCofEcICxs+09RlJzpoIS3D0Jt11W9hTMQ5RWSd2GrUnY+P+IR6ll/ircJMDFODTvqqsV3Fsuosyp37CYODOhZUqDsyWs5ZBa7iIGeZmPWFt7nc+tAEwlGsSmRsM17KksNs4EQ9G9d8602Z2Vs7OcHQHAVlvLpPYu60NUKqlRhMMH8+u4kj0rOHnsOUebd/8wkzufftuFij6hkK+UzdVC4XCfQn3P0g+NBAEm3YvOh2bcCdMRtlLeZCfv99F+axf6MltWKHLq2qr9sFk8EnFotOkRf7nHLnLrba70jLF85tlWG5KrBfL5hhGJYg27PPaPCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dowxi3H2d10pnq22gLlhAyBp00VrgFO4i1zUQZkvSr0=;
 b=oeXhPwsShVCCP1g9UlnBbDKYe1yp71pQxKSh8Pz8tt3gGme3jLODSdegKPjBbxvJfZYrkeAQOh47STVJwCsmPgek3sgj90nLifBZ3xApFYQyH7+oWV4wOSmea+SLNJoGZZ2rMP0pKB10ZpIeBItjE7utPI0amSaso0UkrstJg7nM/+vlegflqGwXv5HLDNYx7DPquiZlrN9m6SwplzU4UXWRA9l/qmPRNNKWIVnTv+rjxC6rblvtogHVEcGOGUV4fed9Z8EUvMSMgUZUJ1IpU9XO7LIgdVWipKxLptEpfFQd8GFLDhLt0gWBGQROSQ1LaCamR9IoRaDXDEZ2hHWFKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dowxi3H2d10pnq22gLlhAyBp00VrgFO4i1zUQZkvSr0=;
 b=KxMF+kQRUi8yspreFv8s0EjGAJkmrgU4U9TEADgxWU2IkKeh2QZU1GT4t8atVKiNV9Qjozj0B0YKeqYpBwtq01dNZ74pVh/0DmChrvwCH43G5qmXf2EqFpnWHfDuxkNDlkc5B4YO4Tq7WkN7XA18uU7lN81/GCakPvLJP1BI3WA=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBBPR04MB7628.eurprd04.prod.outlook.com (2603:10a6:10:204::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.22; Fri, 9 Jul
 2021 07:54:07 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802%7]) with mapi id 15.20.4308.023; Fri, 9 Jul 2021
 07:54:06 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        andrew@lunn.ch
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH V1 3/5] net: fec: add imx8mq and imx8qm new versions support
Date:   Fri,  9 Jul 2021 15:53:53 +0800
Message-Id: <20210709075355.27218-4-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210709075355.27218-1-qiangqing.zhang@nxp.com>
References: <20210709075355.27218-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0147.apcprd06.prod.outlook.com
 (2603:1096:1:1f::25) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR06CA0147.apcprd06.prod.outlook.com (2603:1096:1:1f::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.19 via Frontend Transport; Fri, 9 Jul 2021 07:54:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e4fbeeee-1512-49a6-ac16-08d942aeba44
X-MS-TrafficTypeDiagnostic: DBBPR04MB7628:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBBPR04MB76288F120DFD22939B416691E6189@DBBPR04MB7628.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i0/Xe/GNxpNaLqAAzGQiCvq+1CzzyxEg29CJc2+2npHR6/cuWU1DxjdQEWYYy475Dfv9Mb8sxlLqHDhZa9ki/pYw1NAI1NDuSxpAAT73OOrlw82F1xssUt6AhvDi2ouYxnWJoRAIY6/IGtKM2i7v+/6e1D7s6JBZOLoSaTheIKVXFZP2OrQ0Fx0hayj7tCSFOEA5m80CNMj21iP0BvfzLOA4k4XDUCLcWiusJVjZyW0OQBhNB73VJjVs5FYbUxRBMA019tT6sz5PNGKzGDPfYu25gVTOWPLAd9H+P9WDowhqeQVg2e56jVgiFuCQhHkJU716GwPpICzpRrgjTi5vBc0IKvpvFTDQJS3aS+vvsFGro6x3j/a2gXO7LIW57vhRxoGZhAw90/cXmVEEZimjIeckCxL6EUnUswzmEB5CvN4edMUlTiv6YxwEUtP/egWHZvKY5WkbUPQANKCaqApfeFN0MiLbcfr6kXJGkB60qHOrxl2q8IFmfaAPyNW6YQFAYMYy5PwXV5fmOwEVXJZ2rWuL2ZCXA4nMJpBIUAaVIypQNVOxy+OFlqKdQ7+IFNs4hPfipGhJFXkPqnlWSmuyGc8QzCQfnoxf2YbZSP1sCrmaaTHkyd7vhtWFWVik0/BZdNzW/n9ex5plPFZ6tSHl+5ie3U1z1i3MNCr8k+J/bgRJRGwgFJa7AcEMM6xC3wugnxPnUl4wDBP2RePxcYfPWbFQVwXP8m0BzgzAfSV/wkY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(396003)(346002)(366004)(39860400002)(4326008)(478600001)(6512007)(36756003)(38100700002)(316002)(52116002)(6486002)(26005)(6506007)(956004)(8936002)(8676002)(83380400001)(38350700002)(66946007)(1076003)(186003)(66476007)(2616005)(66556008)(6666004)(86362001)(2906002)(5660300002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?e3mOqyKmMpqMt5kS1vsaNYfqpk7bt3cELpDLNKbD+9/HuZ3FsgyjaTPa//rM?=
 =?us-ascii?Q?lRZ1UeDqPDlkQaK9INaFnzkBkLE/e1P1VbnczLWme7uwVGH2O7O2t590slGA?=
 =?us-ascii?Q?jr15CbzNcWZRxvQcKYbdX77z/zFeLrfRcJbaVBS9S/DvZyb6bAZVQIx31K44?=
 =?us-ascii?Q?95YMRGwXyWo2WBzTnkJAru9ZatFnOlK2lUcyYPmQqTvuBec36YwlcVl43Djk?=
 =?us-ascii?Q?iPeUJYKEkT1eeeUB7Zoza05BjP7wGoZDg1QBKS9CTjJ9FeiOQLu4L0dutcVq?=
 =?us-ascii?Q?znPsjGcbbE6+LEFyl88nNyW9VeNq4a8IFXMIoH46mUAqXMe53JUeUvJ3Fva3?=
 =?us-ascii?Q?8Qy1JMQ/NkuRWd6X0rJE7l4g3DH/gt8Xtkao4PCkiVKWYCJoUx1ZV8zci90E?=
 =?us-ascii?Q?8l3mJn9+yneEvOy/ocQ+k7PqETv2EHYhdgZeyvm9Lf61U2AdS3dPMfRoj8VR?=
 =?us-ascii?Q?8QaU6JosiOLc0rkeqDqIHVZ/ebjqOZl0ijC0lrZ+bjA7WDpbcTn1xpPEamFy?=
 =?us-ascii?Q?Ae9BCVE6mkr8PU+uUx6hVtBzBoEGNNCxZiPk5fQafEoNiwdIADI9/e9ek9l2?=
 =?us-ascii?Q?AC/Qwalib+RiBSK84mvkWoUyPfqCDtzghUcR36iD7/bIqOB1Xy4ywtO6ra2n?=
 =?us-ascii?Q?jaTDl8r0UogZkmtpL/Olao1jqDK5CnKdG15GtwqJcxiApRvUAb1ylWJYQt8d?=
 =?us-ascii?Q?SoXpokQjHpgs74H7V0CsrJ+24hDoykZHfuVBYTAC/2uivDrzYBFm4kb1B4gr?=
 =?us-ascii?Q?wvpF8PeFVKZXCAInDPCzHJ5KFQDYsl+RkYNlKiEgawO9l759Kl7OrgbTMx8P?=
 =?us-ascii?Q?gKRatKZ6fYjPPRI9kPi6IqtzbWOPfcgzEk/ek9mRvXlMiuItkjL9vOEtj04B?=
 =?us-ascii?Q?olhyA6YGK3Gxuo2rrfgvtWs1N+1bWBQF5YrmkhaX/QfIL6bUhLLjnIJN4GJD?=
 =?us-ascii?Q?c6MbwgesnNoP7EHl2fqSI+MIdNV1WR+GH7W5+zb4hAcvikGEa4mmcSraahf7?=
 =?us-ascii?Q?LJxvnN9d7/VI2sYMVmhUSaRt/s7xRF2brgfOIzTZLNmvIxs1tfieEOsxf6uR?=
 =?us-ascii?Q?OZdlBBxfVTb6qCvzE0xkqu37gfJ7KnmAvAkdQ6X2e/cFBfEcNJXjwF6ebgCn?=
 =?us-ascii?Q?weVlo61inE38Wt3xmD9C88lL6wOhceqiXDs9lD+yLhxyp727BSsbvXSTciNl?=
 =?us-ascii?Q?jd/YkAKochnWXko5HqX64DqVEKp/nmfy+8iCrgyv5OEXcgJLNz2a1TOeoolN?=
 =?us-ascii?Q?UguDIDfyt3w3twRgGfb/61elKUH3F4weQsSf8QmRNdtpOO2R179rLzbTrLPF?=
 =?us-ascii?Q?id+YUPsQ20aQ8/QGw5VNFm+6?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4fbeeee-1512-49a6-ac16-08d942aeba44
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2021 07:54:06.9229
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HOiit8BeCPF/WLx2lxeR9lcDQvNHVYBzSfGm6vao5GsEW8FHUphK2aRsbfZkQZA5ASN9Ga+E1Uc5iOXiyqr2og==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7628
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fugang Duan <fugang.duan@nxp.com>

The ENET of imx8mq and imx8qm are basically the same as imx6sx,
but they have new features support based on imx6sx, like:
- imx8mq: supports IEEE 802.3az EEE standard.
- imx8qm: supports RGMII mode delayed clock.

Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/ethernet/freescale/fec.h      | 13 ++++++++++
 drivers/net/ethernet/freescale/fec_main.c | 30 +++++++++++++++++++++++
 2 files changed, 43 insertions(+)

diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
index 2e002e4b4b4a..c1f93aa79d63 100644
--- a/drivers/net/ethernet/freescale/fec.h
+++ b/drivers/net/ethernet/freescale/fec.h
@@ -472,6 +472,19 @@ struct bufdesc_ex {
  */
 #define FEC_QUIRK_HAS_MULTI_QUEUES	(1 << 19)
 
+/* i.MX8MQ ENET IP version add new feature to support IEEE 802.3az EEE
+ * standard. For the transmission, MAC supply two user registers to set
+ * Sleep (TS) and Wake (TW) time.
+ */
+#define FEC_QUIRK_HAS_EEE		(1 << 20)
+
+/* i.MX8QM ENET IP version add new feture to generate delayed TXC/RXC
+ * as an alternative option to make sure it works well with various PHYs.
+ * For the implementation of delayed clock, ENET takes synchronized 250MHz
+ * clocks to generate 2ns delay.
+ */
+#define FEC_QUIRK_DELAYED_CLKS_SUPPORT	(1 << 21)
+
 struct bufdesc_prop {
 	int qid;
 	/* Address of Rx and Tx buffers */
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 8aea707a65a7..dd0b8715e84e 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -135,6 +135,26 @@ static const struct fec_devinfo fec_imx6ul_info = {
 		  FEC_QUIRK_HAS_COALESCE | FEC_QUIRK_CLEAR_SETUP_MII,
 };
 
+static const struct fec_devinfo fec_imx8mq_info = {
+	.quirks = FEC_QUIRK_ENET_MAC | FEC_QUIRK_HAS_GBIT |
+		  FEC_QUIRK_HAS_BUFDESC_EX | FEC_QUIRK_HAS_CSUM |
+		  FEC_QUIRK_HAS_VLAN | FEC_QUIRK_HAS_AVB |
+		  FEC_QUIRK_ERR007885 | FEC_QUIRK_BUG_CAPTURE |
+		  FEC_QUIRK_HAS_RACC | FEC_QUIRK_HAS_COALESCE |
+		  FEC_QUIRK_CLEAR_SETUP_MII | FEC_QUIRK_HAS_MULTI_QUEUES |
+		  FEC_QUIRK_HAS_EEE,
+};
+
+static const struct fec_devinfo fec_imx8qm_info = {
+	.quirks = FEC_QUIRK_ENET_MAC | FEC_QUIRK_HAS_GBIT |
+		  FEC_QUIRK_HAS_BUFDESC_EX | FEC_QUIRK_HAS_CSUM |
+		  FEC_QUIRK_HAS_VLAN | FEC_QUIRK_HAS_AVB |
+		  FEC_QUIRK_ERR007885 | FEC_QUIRK_BUG_CAPTURE |
+		  FEC_QUIRK_HAS_RACC | FEC_QUIRK_HAS_COALESCE |
+		  FEC_QUIRK_CLEAR_SETUP_MII | FEC_QUIRK_HAS_MULTI_QUEUES |
+		  FEC_QUIRK_DELAYED_CLKS_SUPPORT,
+};
+
 static struct platform_device_id fec_devtype[] = {
 	{
 		/* keep it for coldfire */
@@ -161,6 +181,12 @@ static struct platform_device_id fec_devtype[] = {
 	}, {
 		.name = "imx6ul-fec",
 		.driver_data = (kernel_ulong_t)&fec_imx6ul_info,
+	}, {
+		.name = "imx8mq-fec",
+		.driver_data = (kernel_ulong_t)&fec_imx8mq_info,
+	}, {
+		.name = "imx8qm-fec",
+		.driver_data = (kernel_ulong_t)&fec_imx8qm_info,
 	}, {
 		/* sentinel */
 	}
@@ -175,6 +201,8 @@ enum imx_fec_type {
 	MVF600_FEC,
 	IMX6SX_FEC,
 	IMX6UL_FEC,
+	IMX8MQ_FEC,
+	IMX8QM_FEC,
 };
 
 static const struct of_device_id fec_dt_ids[] = {
@@ -185,6 +213,8 @@ static const struct of_device_id fec_dt_ids[] = {
 	{ .compatible = "fsl,mvf600-fec", .data = &fec_devtype[MVF600_FEC], },
 	{ .compatible = "fsl,imx6sx-fec", .data = &fec_devtype[IMX6SX_FEC], },
 	{ .compatible = "fsl,imx6ul-fec", .data = &fec_devtype[IMX6UL_FEC], },
+	{ .compatible = "fsl,imx8mq-fec", .data = &fec_devtype[IMX8MQ_FEC], },
+	{ .compatible = "fsl,imx8qm-fec", .data = &fec_devtype[IMX8QM_FEC], },
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, fec_dt_ids);
-- 
2.17.1

