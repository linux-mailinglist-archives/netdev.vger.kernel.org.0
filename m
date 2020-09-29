Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1978127CBF1
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 14:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732799AbgI2Mbq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 08:31:46 -0400
Received: from mail-eopbgr80055.outbound.protection.outlook.com ([40.107.8.55]:56315
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732937AbgI2Mak (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 08:30:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PzgsT0AkoDsPLtyn97g0oFkzH8dGpahramfwjiRFMdn4vAbEVjngXn4/0Wu66DA2tK8i6o2gk4f+tLoiAzFXIFiB0yXMBcj7jtVUewQGGh4U23HNWhWJDn9Q7WfJQVivDkVjLYmrI12eges81O49AtKvzKZJsl5cZ87WTQ48Yq5v/L4q456lno2N3xfxUBfnm+QhwknrR3Gb6GQhT+oHsALgCLjEEKfBYrs5RuuWaTLc7XfeRbXeyV86KLm+OC06ZfxuG/CJHGPtpEcMy6gZS2njnBEPwGJtBIlOumtUTC2IfdAa/4j/TC+OjgZhUHyiUsGDNwQWRz+Fv8iGnWErZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i3hQZtJFCvOfMLqgtgecNxJ7vID8hgh05H+qAlMqo3o=;
 b=jNyZlUdgfT1ZPdP11FRpVDNtx3q0XA9iI5AQ6wfVwA/0T355doCj0CNGmONKBnd3+mX58GNvWvYTbN+7jRQtb2fVoIwoiVw7ymAHQhuWOqVPurC35kgWsw6Z53WI05l+Fo8xk8d+1QzsYQNRFUU2n3UXV9GnAgvufLp0ErYnztQ+rTEMkvm4ToAy7e9sMVfp8tM6fyR+GpFhiSGUL3DgWe6/HwU1zBkglQpnE56Z0sw/96zBqkNdwAERfhE8DNAce3PQRyiOIycX0rapR8DMUhn8hahTev/cXFO/g/FCqOVXi9qF7mEZgd9YRWXR5Xmr1k+mCusuRY0fL5rpbmaYZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i3hQZtJFCvOfMLqgtgecNxJ7vID8hgh05H+qAlMqo3o=;
 b=hLgRPph8bAh3JPAsCwlL3wJnzO5D+pztJXidAY1v5jjlt95Co4TumbodvpE67uWbXLMZNKtJivR20/X/3rm4IuKHDl683S8s+Xeh8BUf94Lbnr9LOrxpHSmqDPAhyGmHswnpFys0RRlpAON5Xy9IkXrZmTYTuCygv0FLAd66TGw=
Authentication-Results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB7PR04MB4778.eurprd04.prod.outlook.com (2603:10a6:10:18::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32; Tue, 29 Sep
 2020 12:30:33 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::d12e:689a:169:fd68]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::d12e:689a:169:fd68%8]) with mapi id 15.20.3412.029; Tue, 29 Sep 2020
 12:30:32 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     mkl@pengutronix.de, linux-can@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH V4 2/3] can: flexcan: add flexcan driver for i.MX8MP
Date:   Wed, 30 Sep 2020 04:30:40 +0800
Message-Id: <20200929203041.29758-3-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200929203041.29758-1-qiangqing.zhang@nxp.com>
References: <20200929203041.29758-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0063.apcprd02.prod.outlook.com
 (2603:1096:4:54::27) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR02CA0063.apcprd02.prod.outlook.com (2603:1096:4:54::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.24 via Frontend Transport; Tue, 29 Sep 2020 12:30:31 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.71]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c25fd78f-184a-4937-0d3f-08d864737569
X-MS-TrafficTypeDiagnostic: DB7PR04MB4778:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR04MB4778AE256627C13A3F7D8205E6320@DB7PR04MB4778.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1122;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b3cUPyugexovAvgLlDrc9nWkjHcXZmAotMUMDYXTtfCOPb3nIpvxe+eeHaFji5bNk9swpn7rk31y5S2gQSumODIHW5o6Rb0CxSkXbdaAF49yNN4QOJQjIzi5xyT7u6RI5P9qJVB6yFSv3y26p9qysR8NtMASH3FeJFoIDEH6P45Vne6BWa3lXPqH2CqZ7X89tKG+lvq/0B53hQF1jke1eQXkqCVbDp42wb5ILDHgFrM+gd3t+knrvLyryLznxEkBpgIasviaUzA6zsLxJO1UkBhZtUIuKGyudK8tqsh0j80xPYZyOTDb2zQzFLALZitGh+vONrXoy5cqT8Aa9gHMMikCe3pBcuzgRBrwccfIqti/RxI+ZQksKfHj5F948v5W
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(5660300002)(36756003)(52116002)(6512007)(69590400008)(8936002)(498600001)(2906002)(4326008)(2616005)(956004)(16526019)(186003)(66556008)(66476007)(66946007)(26005)(86362001)(6486002)(8676002)(1076003)(6666004)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 7IpYCsGXdGzbgSxS0M+yzI/qa/sJ2OJ53RSw93+EcH0Ua7FfimnVzRpNY9fCEqqC0ptpALD5NT9agDE6Xqgf0f6wzywiB5ijYJZ+ElRj3QgxHAQv/kVqEO5kU+6xmwEIlEAlWc4pRHifqSHPUK5aX1gbuth+3yLUj3ZhWBCN7r+EjrRkS2gRxqk9OVJkMP/8RzORlKmDz6YrjLIBOUCzLZJZYB5NB/oeK1zDGeGA31LgcJvxpIpGPBMDVqQk5rNFBq/ZkpDThyYQBHW1f9OtWOk5bZcrNL9Xnwuz66alW69W0mtxSv2/527Wl3glWPHAwQQvClBhVw8qJni1GY3XzqPDvbWZxiK0S+j9x6kEQGMNEIYL2uq8WlD7xk8aCoWfT1JhIygLpXdVSlHKU1G+23O4fRGkFw8rQoEdq4zE6LwwRrbGKN/SF9nh0k8ccrG/+jKAWnMkk3UFocLHYZEfPI2Eix4scdfOzty00edAnJUhxtN07Fz1ByVzYJvtA0dmxzMyDWmKAmcKty6dbym7JLE7eSoBZ5ncCox+hK6WWQyt3e2RU412dwwj85BUV/rLw/bvmYY3yQL20jr0B0t5SqKJLN6H7XTe1m82Cw238/CC5ZEL8gW6M6inkpST4i7IflGcaq9srJLE0Y8xLFS/2g==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c25fd78f-184a-4937-0d3f-08d864737569
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2020 12:30:32.9070
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QGW0ZFjzjqhPrClFN8Y8/UYUveu1BB3vwXwWQZt/Pmk3wO6oHoWB3m98yNHhMXYvcVkoLNaYbfVIf0uvoKuY3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4778
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add flexcan driver for i.MX8MP, which supports CAN FD and ECC.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
ChangeLogs:
V1->V2:
	* sort the order of the quirks by their value.
V2->V3:
	* add FLEXCAN_QUIRK_SUPPORT_ECC for i.MX8MP.
V3->V4:
	* no changes.
---
 drivers/net/can/flexcan.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index ede25db42e87..1dc088984125 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -214,6 +214,7 @@
  *   MX53  FlexCAN2  03.00.00.00    yes        no        no       no        no           no
  *   MX6s  FlexCAN3  10.00.12.00    yes       yes        no       no       yes           no
  *   MX8QM FlexCAN3  03.00.23.00    yes       yes        no       no       yes          yes
+ *   MX8MP FlexCAN3  03.00.17.01    yes       yes        no      yes       yes          yes
  *   VF610 FlexCAN3  ?               no       yes        no      yes       yes?          no
  * LS1021A FlexCAN2  03.00.04.00     no       yes        no       no       yes           no
  * LX2160A FlexCAN3  03.00.23.00     no       yes        no       no       yes          yes
@@ -391,6 +392,13 @@ static const struct flexcan_devtype_data fsl_imx8qm_devtype_data = {
 		FLEXCAN_QUIRK_SUPPORT_FD,
 };
 
+static struct flexcan_devtype_data fsl_imx8mp_devtype_data = {
+	.quirks = FLEXCAN_QUIRK_DISABLE_RXFG | FLEXCAN_QUIRK_ENABLE_EACEN_RRS |
+		FLEXCAN_QUIRK_DISABLE_MECR | FLEXCAN_QUIRK_USE_OFF_TIMESTAMP |
+		FLEXCAN_QUIRK_BROKEN_PERR_STATE | FLEXCAN_QUIRK_SETUP_STOP_MODE |
+		FLEXCAN_QUIRK_SUPPORT_FD | FLEXCAN_QUIRK_SUPPORT_ECC,
+};
+
 static const struct flexcan_devtype_data fsl_vf610_devtype_data = {
 	.quirks = FLEXCAN_QUIRK_DISABLE_RXFG | FLEXCAN_QUIRK_ENABLE_EACEN_RRS |
 		FLEXCAN_QUIRK_DISABLE_MECR | FLEXCAN_QUIRK_USE_OFF_TIMESTAMP |
@@ -1892,6 +1900,7 @@ static int flexcan_setup_stop_mode(struct platform_device *pdev)
 
 static const struct of_device_id flexcan_of_match[] = {
 	{ .compatible = "fsl,imx8qm-flexcan", .data = &fsl_imx8qm_devtype_data, },
+	{ .compatible = "fsl,imx8mp-flexcan", .data = &fsl_imx8mp_devtype_data, },
 	{ .compatible = "fsl,imx6q-flexcan", .data = &fsl_imx6q_devtype_data, },
 	{ .compatible = "fsl,imx28-flexcan", .data = &fsl_imx28_devtype_data, },
 	{ .compatible = "fsl,imx53-flexcan", .data = &fsl_imx25_devtype_data, },
-- 
2.17.1

