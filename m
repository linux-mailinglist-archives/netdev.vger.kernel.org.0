Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D443278141
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 09:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727249AbgIYHKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 03:10:36 -0400
Received: from mail-eopbgr150084.outbound.protection.outlook.com ([40.107.15.84]:22663
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726990AbgIYHKd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 03:10:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f2B+U1AFoLpXAuYMULc4ZgwzwtqDlrfClkVgUSwCynM5JQiVhIcFi2sV/uPC9NUTRht22IOyEjVejvDqpBmzDINS3hQXT6B0Ed8HFnMIEUCTZuWLRVf+SP/6Q9ik3tmus5fJbgBtKeFFx8sGmK9dR1i5R9OWDnS1lFCfmAAf9YLRlxLkbn4zJ7uOTzhNeaVSLteAn7TkXKCj/AU0jzc40UpWRXnKNZcc+J2pUOFTztfPpTevnLm/AoyT1hsWb7Vujawrxmkn3AyeWJjOjGN+gs3HUNFf4RYLobhCnEuwhNp7hxoLrSiS7NCmWEENgUGQUcjv2/pBzQlEoGMJnvGYbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VlNaanxVZcYm2DxR5uZpIpC8QKzljpwMEtT8PpvMQxE=;
 b=eKOFiabQG2eFO/JAo3G6omJUGn4m8tzNvzjFYGaF+Ghq1yD0nBE9zOWY+FWH3AYF8IL1yhKOAjITu8AfByZT6srETV8n5BcIg/df0hOsYGg/ncf4ScX8IhHgfVqcf2jdyX+HTR1Gah81bIKGnaRw2M6s7V3FqxhA4IG90XzsrBvfMK26c3DW6YLlDId7K+BmS4eMbZAYQdshZ27i+F/iNeCXwV/EMb0yh4qfW5q8wpNSmDamMEYiIFLJ7YPZeV79phN3MZCeL+UaaGg4SZflcVAFdBH9Hif4v0em7lxjc9ff7hJT/9EUU+UGT4RLDzXLIltznEZBgi5K0v5/tg9IvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VlNaanxVZcYm2DxR5uZpIpC8QKzljpwMEtT8PpvMQxE=;
 b=jo87j+l//AEYzz4jhjZsTg1l1fk0f8iJapuiNX6LgHGmHXnYR2rY2ZvkYCslTRhSliZSySbsH0PmBoIXCuMFbo07AEchFwaGRQiKjb3vXfwg9KQIEUhZaxcM3yJF+nBSDPPeIkytik8IljEI9XLSkUQo5gGY/tSUgmNd4BRepG0=
Authentication-Results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB6971.eurprd04.prod.outlook.com (2603:10a6:10:113::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.23; Fri, 25 Sep
 2020 07:10:28 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::d12e:689a:169:fd68]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::d12e:689a:169:fd68%8]) with mapi id 15.20.3412.022; Fri, 25 Sep 2020
 07:10:28 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     mkl@pengutronix.de, linux-can@vger.kernel.org
Cc:     linux-imx@nxp.com, netdev@vger.kernel.org
Subject: [PATCH linux-can-next/flexcan 2/4] can: flexcan: add flexcan driver for i.MX8MP
Date:   Fri, 25 Sep 2020 23:10:26 +0800
Message-Id: <20200925151028.11004-3-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200925151028.11004-1-qiangqing.zhang@nxp.com>
References: <20200925151028.11004-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0240.apcprd06.prod.outlook.com
 (2603:1096:4:ac::24) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR06CA0240.apcprd06.prod.outlook.com (2603:1096:4:ac::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20 via Frontend Transport; Fri, 25 Sep 2020 07:10:26 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.71]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e368ec2b-ceb9-492d-d2e4-08d8612214de
X-MS-TrafficTypeDiagnostic: DB8PR04MB6971:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR04MB6971BB5591CE4B756C7C4F56E6360@DB8PR04MB6971.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:431;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T/D2FponImtU+GVf6sA9iNvNXf2WmwC3WDI0D7T6Np/dDELsuRFgOiFi+a+YT/icOTSSgqCtbM2YnxFx21/Xl8Juj2gnFPJ7Frav6YVTZmYC6i1th1yuq8s6w4N3UInTL8zFSpZBfQ7X3AzNBWTiFOExB4xJxqHsSDX3WluzfxOyRQKRm68r3ikx0ZEaihJl7rF649fIZzWgD5B24Iq2ETQEeFlJlXd7T0w2JW9OsGWOhV2SimiE6qxUX1N8796Hm4BCeLMOQd2QtRdytBZdliNurWs8G0OrAMuhi0k8b/20gQ7gT+dhJhPVX0mZ8wim1C3SNQ0/UD/VK3Wur6lylidv9k51NmUHEhagha6k6YKDEgp+yRvR5+QAbWmoRm/h7m7F7cO/YLoPyWymCrsJ+QtQmkAFl6XyYvDqy/ohiL2kPIHxcLRN4mnoSkbov23K
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(366004)(136003)(396003)(39860400002)(478600001)(6486002)(66556008)(956004)(2616005)(1076003)(66476007)(36756003)(16526019)(186003)(5660300002)(26005)(66946007)(69590400008)(316002)(8936002)(6506007)(4326008)(2906002)(86362001)(6512007)(52116002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: swy5hT9B2dFHsggKu4pffX+XkT9akEJK4dsZoKo6yJS0iEZxzS4R/GQT3PPhpYleyvT57SKU6liKqF4i8Blq3WRQiQ0iIu6GrPMeUbX4+zLnFxwnuWDltvovaheOeqWczbwP2rX+ES/EmyAeJ0KWzDm0DhlqDBc+gna3g7Pp6gdqV7R+OIc9SOfbQM6p47ePpV2NcgVlPLh+2a90PAsFyL7iwcmCu9SIe4LfQS2s3C1Td5mZokfw27vXE34pi4zCN2CWCqibH+4ckyQ2lkYMFkeF+lyuPTMk/EglGgYHIJCuzYPi3hcZR3vYr0kJBBBUCJUPnpC80P8j1Z/RT5Dg7EcQjmyWze6DICE8oVV/sw9kF6rifU22HA9B8VO54gWnD0DH9VkzEznUxL0dnLMw+n7NhGaETE3KpKAQG1RGQ2uLcySbOrQJRkbiFnsut+9cb/o+YbZbO50eFM+F296mQb2SPPhZWtN1upq2Kuja4vtCTfC2uYPj8EBbyLTKmHtIY7u5evUHf0V3avg40M9g7YrX9yEKZ2sG9MTkDXs8gJ0/Uwfo2Hi8okWuCtsGp9ZI6zhga8xCJqPfWuQ6sJWvpMPFE3OvSR9JWRoavjPLMm2JQXOW/NtYP0IevNWUYemeXYvS4YrX2jNnQvzYLtALCg==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e368ec2b-ceb9-492d-d2e4-08d8612214de
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2020 07:10:28.1666
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5RmGrHK8hSSKY6yVuGrMWSNWXgE08+EuYsUkgduInkJGiuVS8Nt1V8IjlTU299W1pJN0zmn2JWY2L0rVpaYsUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6971
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add flexcan driver for i.MX8MP, which supports CAN FD and ECC.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/can/flexcan.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index f02f1de2bbca..8c8753f77764 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -214,6 +214,7 @@
  *   MX53  FlexCAN2  03.00.00.00    yes        no        no       no        no           no
  *   MX6s  FlexCAN3  10.00.12.00    yes       yes        no       no       yes           no
  *  MX8QM  FlexCAN3  03.00.23.00    yes       yes        no       no       yes          yes
+ *  MX8MP  FlexCAN3  03.00.17.01    yes       yes        no      yes       yes          yes
  *   VF610 FlexCAN3  ?               no       yes        no      yes       yes?          no
  * LS1021A FlexCAN2  03.00.04.00     no       yes        no       no       yes           no
  * LX2160A FlexCAN3  03.00.23.00     no       yes        no       no       yes          yes
@@ -389,6 +390,13 @@ static const struct flexcan_devtype_data fsl_imx8qm_devtype_data = {
 		FLEXCAN_QUIRK_SUPPORT_FD,
 };
 
+static struct flexcan_devtype_data fsl_imx8mp_devtype_data = {
+	.quirks = FLEXCAN_QUIRK_DISABLE_RXFG | FLEXCAN_QUIRK_ENABLE_EACEN_RRS |
+		FLEXCAN_QUIRK_USE_OFF_TIMESTAMP | FLEXCAN_QUIRK_BROKEN_PERR_STATE |
+		FLEXCAN_QUIRK_SUPPORT_FD | FLEXCAN_QUIRK_SETUP_STOP_MODE |
+		FLEXCAN_QUIRK_DISABLE_MECR,
+};
+
 static const struct flexcan_devtype_data fsl_vf610_devtype_data = {
 	.quirks = FLEXCAN_QUIRK_DISABLE_RXFG | FLEXCAN_QUIRK_ENABLE_EACEN_RRS |
 		FLEXCAN_QUIRK_DISABLE_MECR | FLEXCAN_QUIRK_USE_OFF_TIMESTAMP |
@@ -1932,6 +1940,7 @@ static int flexcan_setup_stop_mode(struct platform_device *pdev)
 }
 
 static const struct of_device_id flexcan_of_match[] = {
+	{ .compatible = "fsl,imx8mp-flexcan", .data = &fsl_imx8mp_devtype_data, },
 	{ .compatible = "fsl,imx8qm-flexcan", .data = &fsl_imx8qm_devtype_data, },
 	{ .compatible = "fsl,imx6q-flexcan", .data = &fsl_imx6q_devtype_data, },
 	{ .compatible = "fsl,imx28-flexcan", .data = &fsl_imx28_devtype_data, },
-- 
2.17.1

