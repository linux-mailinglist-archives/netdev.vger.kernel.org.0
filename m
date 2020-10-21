Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B846B2947CD
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 07:24:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440524AbgJUFYT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 01:24:19 -0400
Received: from mail-eopbgr40057.outbound.protection.outlook.com ([40.107.4.57]:16960
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2440508AbgJUFYR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Oct 2020 01:24:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oAabtkRPRsiT7GszTGzucNuG2hcq1fQ2bbtd0TDscNxL+g29y5zzHHl/wc9uqXWpM08MUMZV2pwgYImUtgFBypummel2aLM483vcbUytL+gIzemxd1JC4jjROEi/49zWbDgKmstLSFqND16D2K8Jy493Wmf0lZRrOMEOZGCPl9zmrT+C9NytaDSD3YSQNg2Zuvg7mx7BS7gXuB7zAvSm9bOEoJQejBk0n5+RxbiiWzMxerHE0JFpz0s+b28tfyYsNzPdj2BekFJZmSzW0Kd2PugVLIFdQR9S0xrI8twUoquFQpL8xYVpuj50C09levfUqR7UxnY6BjSg3cFnNkdWrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wUOZIqE1JsQqp45rMHW0ZDhnFdxyz6s07VtATqXuNFc=;
 b=AZbQLF8bMwgueqZfHZC0ytO2waKLo3+Sd6lczm1uMbkSQHFFCN+rcoIOSzu87L/FK+37PbMDwIjdvp9+hgraoUu/JsPMCDDMRNRncK6vtBIkdG7BLqZOShM+mzglvl5jI9B1eaQfYI9hwqV6VWLkxW68czNTP0TiTSVj+7vUiXHG8w9XGvffCAQKyNQ1VDAeGh6uBMdZUb7cSz6XQOmFLyO765GC5ajl/Y4rcwua+zCa2mfpyGZ84q2+Xq2rFRlJohi9eEQ6e6lhUZ7+SEGkg4AygK6yIhlSv0tYfrg+zVMyXRfYZuDx9skKJSGrHuQO4G1UWLRk2ZYex0JTjdEmgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wUOZIqE1JsQqp45rMHW0ZDhnFdxyz6s07VtATqXuNFc=;
 b=ch5OEa9emFKiaA6OPMM3dqRZy/cqgQSlP3+UbylUPIi9oKmb3yA101ViO2faYbOLAxT3idlcZzKmQ63IPEPmzGzZLPNwh02GW2k0Xp/KYU4xBdpMZeGIwTG5j+Jcw9AWDGvmpVQSLAQcF2TyIMs4X/hMyWzV2jLY4g69/SSb/1E=
Authentication-Results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB6PR0402MB2726.eurprd04.prod.outlook.com (2603:10a6:4:94::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.27; Wed, 21 Oct
 2020 05:24:13 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc%9]) with mapi id 15.20.3477.028; Wed, 21 Oct 2020
 05:24:13 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     mkl@pengutronix.de, robh+dt@kernel.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de
Cc:     kernel@pengutronix.de, linux-imx@nxp.com, victor.liu@nxp.com,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V4 5/6] dt-bindings: firmware: add IMX_SC_R_CAN(x) macro for CAN
Date:   Wed, 21 Oct 2020 13:24:36 +0800
Message-Id: <20201021052437.3763-6-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201021052437.3763-1-qiangqing.zhang@nxp.com>
References: <20201021052437.3763-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR03CA0157.apcprd03.prod.outlook.com
 (2603:1096:4:c9::12) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR03CA0157.apcprd03.prod.outlook.com (2603:1096:4:c9::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.9 via Frontend Transport; Wed, 21 Oct 2020 05:24:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 42fc110b-fe88-4d8d-c78d-08d875818bbe
X-MS-TrafficTypeDiagnostic: DB6PR0402MB2726:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0402MB27269AD566D61DD4807EC4AEE61C0@DB6PR0402MB2726.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1079;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GVlGqBYS8yf29jfiaYHLOfJZNLSH2IKYUD1Ervct6PA9g0k4nEAbKT0cOhBm7U1IhL8Z92qQhV9Q6EA5onw2EChDvmUqCp2fmIgsHl4+GzuRLFQ+vagPP3UzE1O8ePl6hwQiGVER4HClvI/oAbBBlgY7HxCpdnO8P0nGNbXsATsiAbqEE0vOcqBYQDtQXCPosBF4CjScr6DJvlYyjIFBO9oTuL3JZTWXXgR/BnyzpFHXM7JFTFkSQ3p99W4gBwP9Uy59GMr6hZxO3d6zoS2Qk/NtkM5nYHi0ECxtnWhbBxt0nC95xahTmLE7OuuMqsZCLQZ4CnSuP4UXfR3zDIVRJS2e7jD9sfeRMLyVvQPc7rfoc6scOrRyVGSAdGu4fkJN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(376002)(136003)(396003)(366004)(478600001)(8676002)(186003)(16526019)(6506007)(316002)(26005)(52116002)(86362001)(36756003)(4326008)(66476007)(66946007)(66556008)(2616005)(5660300002)(6512007)(6486002)(2906002)(8936002)(6666004)(956004)(69590400008)(4744005)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: qQ9putH91+gxCF3Z31msNQ16Ml7caTgsDlCMs6M98IcXKYqLttSQEqrU5kSxlQ8+BYQilPRK+VIz4rRpfCJ4WTGfBhuJQ+VSdkztgXotD0wO2Ty6m4ZLzdigag9jLEdrFH8hT49S3tAjOsygC0fuRZ2w03zZ/QtJO7PwcvlcE7H4gFWWQjNslauE7hL3agzPjA1QpDEpvB2jS7FG+1AUIR2qOTjiSqXtL+loTifrn+EjqA0EjjpI+eioR6FMNiVkAxZu8XUMXgMx97wHAU5EsUHNxVj/gAcurhSnTLBVde3cQ0dT+CocjAYmGkcxwUX5gu3GXWh6yvUaH9UNB1SlicXT42E6FH1BQVyxiDeAd/+B1ZUnK1VHF4h/owaOUYanqXKe8hZT2OpeTYfk1eJHR+o+vvavtUeSb7IcFJivepMJTtir9ZSf4CSJOsk7X7xH16p9+71zEw0+yzmYuI2t9XOGLCcgxsc/O8KgB2EE9LUzK1Da0PRokHeDwSefoZfA3fbb+YJuePO0JPJOMhycHEooGwLQ7lBL0gFHJMEkn4OKN13KPlK3rwW/Rjor1SPN5CzpBBHZkG2KpS+Fsl775zDOPbtSEN4T02V57nI3Pip37g06VrH3H7FEEpt5xRChb7tD/kEZa4Vs2qveCtZPmw==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42fc110b-fe88-4d8d-c78d-08d875818bbe
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2020 05:24:13.2087
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D05KR88zCFB/dUGmG6NO3UX7x50cY9xpi1cvYkdO6mcbcHaZmEA7VNLxeB1BJs3jlHTvt1MxSsZUbEG4N3KaKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0402MB2726
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add IMX_SC_R_CAN(x) macro for CAN.

Suggested-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 include/dt-bindings/firmware/imx/rsrc.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/dt-bindings/firmware/imx/rsrc.h b/include/dt-bindings/firmware/imx/rsrc.h
index 54278d5c1856..43885056557c 100644
--- a/include/dt-bindings/firmware/imx/rsrc.h
+++ b/include/dt-bindings/firmware/imx/rsrc.h
@@ -111,6 +111,7 @@
 #define IMX_SC_R_CAN_0			105
 #define IMX_SC_R_CAN_1			106
 #define IMX_SC_R_CAN_2			107
+#define IMX_SC_R_CAN(x)			(IMX_SC_R_CAN_0 + (x))
 #define IMX_SC_R_DMA_1_CH0		108
 #define IMX_SC_R_DMA_1_CH1		109
 #define IMX_SC_R_DMA_1_CH2		110
-- 
2.17.1

