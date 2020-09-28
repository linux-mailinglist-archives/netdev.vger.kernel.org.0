Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBEAC27AB73
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 12:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726630AbgI1KDI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 06:03:08 -0400
Received: from mail-eopbgr50054.outbound.protection.outlook.com ([40.107.5.54]:20046
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726328AbgI1KDF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 06:03:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZOCtY45FCDEGfBLb52jdhH5x9UmRD1lVNOccPImAoS0g58lIGkssKeNbFkFrBJW5raCTwMWXMcjGG5nEDn62J9Sv7sFdGgx+kyD2Z1YLJnUTFTbyioW7+Zs9mMXy8u8uVN3hcx0tvK9oQ/guoUo/EPEEUhygTe2yjUBwrRUQE7/66BdrzC8cd2P6j9t2RaG2vS1lH9NkRW3DUcYKJP2/sVQJ/RGOlC3VrPBnrVTM5O6ZwDsBjELx+GLvU0OYj5QzKuX3oDs5vPlR+kjDSbfccpMqS9C3+VkT3lKNsTk+yuodaMO/ubcLn+GfxMrcbSeir57VLgu5qG5de0dhS5VZIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RPF2fiNntz7y4HFb68prKvpXcho+Ba/VjqcokuOBnbQ=;
 b=fJydyLhgl33MLAlMXW7TWxA2cmg+eGvSjUOAECv8zIAUY7bRyGC2HaVK0GlVp6Kk43EGS9APRweFNnoWjqHzEW3UtyCuNQQ+kKlwXpMrioYp5lOqKfZLDx6Dg8J0s2xYi7gMxzqewUl9JGVWUe7vVZNsFYH5/T/Qmbf4AE32LF5FzGv/IUP+voYDLzSS1u22bxe7vgWPMtj9OYC2ToBgOtiZzXrjn45x+pLisTCLszE6MB8oc1B/uvCivv9Qrh30DetK9rnqx8bL9rIRFSi2jCuJBUA+T3hesUrEpD1SJC9XdO4jeha73pWXzUvAAFWa8u1lb71VPRVQpppf8SW7jQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RPF2fiNntz7y4HFb68prKvpXcho+Ba/VjqcokuOBnbQ=;
 b=cEIP7YyNh57y23bOOqdUsDr75hVJYjSIgRbSxbVxgMZCA4HuCavrpSFH76Vi+g+4pHMe/j9rwYsNZ1l0dcNNbcbL/DGv4Y0vEXgocoEI+4nxB2H7Din7j3tMV+qdlzcqz8SQJjzjfrK07y8kYIehs3TZU99MpoPkD+gEDmcTuvg=
Authentication-Results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB3PR0402MB3769.eurprd04.prod.outlook.com (2603:10a6:8:f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22; Mon, 28 Sep
 2020 10:03:00 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::d12e:689a:169:fd68]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::d12e:689a:169:fd68%8]) with mapi id 15.20.3412.029; Mon, 28 Sep 2020
 10:03:00 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     mkl@pengutronix.de, linux-can@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH V3 2/3] can: flexcan: add flexcan driver for i.MX8MP
Date:   Tue, 29 Sep 2020 02:02:52 +0800
Message-Id: <20200928180253.1454-3-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200928180253.1454-1-qiangqing.zhang@nxp.com>
References: <20200928180253.1454-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SGAP274CA0017.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::29)
 To DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SGAP274CA0017.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20 via Frontend Transport; Mon, 28 Sep 2020 10:02:59 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.71]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0da83f4a-4fd4-4387-4ead-08d86395aeae
X-MS-TrafficTypeDiagnostic: DB3PR0402MB3769:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB3PR0402MB37691E4FCFC174A0564A85EBE6350@DB3PR0402MB3769.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1122;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6Ymxef283Gg/XgWkaCInUMWGIS+V5dXITRsgyNuaFPC4bGSr3Tz4SZ4Gw56qVdMLM2fAG1L4gBEGpLBoh6uUUaoaPgcBaMY6iB22gPlJ0vfBmmZWm/zl7LcFrmaBHIX023ZVEgQamZmT8XfmAhH18ysfWYt11SKkWdjT4ijyWcM0MH8JCqRdjNOtnpiC145fsT6G2KXS0QJkbAh0VAYgvbShXx84A8r8P55MOk+i18zLI+4MV5iyhpaLslplnPu4wgPwfi7uNrbOq/SxQr98l+U2D2C+71CwU3qTN2D4ShjrgBMlFwTeaCD3G/xFLl47oFQGGo+nhAcmgR5nwBNrO6D6FwVh62CbCFqjOLJZI1AS3DXsaOtxNwDrsngj94kzUGN8/k2LrjMtDvIA01aiHuRCEoasxxE3qzhoJcys7Om5BpFy59fCL9WguXCAE/pF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(346002)(376002)(39860400002)(396003)(6506007)(52116002)(2906002)(478600001)(956004)(2616005)(186003)(16526019)(5660300002)(66556008)(6512007)(66476007)(4326008)(316002)(8676002)(83380400001)(8936002)(66946007)(86362001)(36756003)(26005)(69590400008)(6666004)(6486002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: +VBSfrewP6WrxJZDFKcfZ/IkfL1xBs8ERWmWi9Xj3Xo+BorFGynk6FVZnSQZhkUT66SeaHoZa8JIRE5pC2uONGnQesKxgb0D3FS84qvOWW8FaP7tIiQObP9KhISiV3RSifgnbNVOhvbJp9boBDkGH0HRziYaFCWinYX5uH8mLkRSIm9kbIhmy8JWx2HUw81ommAgpRJOl9JTP46mD5hDAcHIEibwySjpaaZ2yBcXJ9qGCy7VuQ+d8hUiKton5x1AoByEnXMKF8ajY0xKKTAFhkwTMzKwa6bwCCNInaRoGcwfupSIAqWAHeaL1IkJHnjWDoHcRZOIW6qidBML6TNAPa8qvvZNmCytzWUNUeHzjRTtQhj0kimPOYptH7mtU3pTEurVOVDZ8WuLdhAVTaubrO5jrB4XaS3GOQsCcgltRaaOrStDZ8Wnv4y4aL4iZVX+PC/piB3GajMrkmGVfHCv+iAcSHjRQXBqhIfm8ecxRVePbs7g/8R46o+/bW9kPeBlwRoAHz6pVZkHgQe/uflem8wR+eCJvcrl1/Ae6X31VxEWi4TowPZy4UEs7um1pRWl2FxejgJI24mdGc7V6tNmtIDu39XBEUtb0M2sUIzq4FYgQV/uM6oRqtYUdcwPWsnDQfzvQ7ISL+ie3M72n5R0Ug==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0da83f4a-4fd4-4387-4ead-08d86395aeae
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2020 10:03:00.7170
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Maa6TkF+vZPM+IquXNpjtGaYHj0VBxNYEsey5KNenmxH7UrhwzSUVFo/r5rBt6KbBqqUWLrX7+fSITS+5CX1KA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0402MB3769
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
---
 drivers/net/can/flexcan.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 0ae7436ee6ef..925efc986b6b 100644
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
@@ -378,6 +379,13 @@ static const struct flexcan_devtype_data fsl_imx8qm_devtype_data = {
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
@@ -1895,6 +1903,7 @@ static int flexcan_setup_stop_mode(struct platform_device *pdev)
 
 static const struct of_device_id flexcan_of_match[] = {
 	{ .compatible = "fsl,imx8qm-flexcan", .data = &fsl_imx8qm_devtype_data, },
+	{ .compatible = "fsl,imx8mp-flexcan", .data = &fsl_imx8mp_devtype_data, },
 	{ .compatible = "fsl,imx6q-flexcan", .data = &fsl_imx6q_devtype_data, },
 	{ .compatible = "fsl,imx28-flexcan", .data = &fsl_imx28_devtype_data, },
 	{ .compatible = "fsl,imx53-flexcan", .data = &fsl_imx25_devtype_data, },
-- 
2.17.1

