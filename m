Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C05F0292330
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 09:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728324AbgJSH5y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 03:57:54 -0400
Received: from mail-db8eur05on2066.outbound.protection.outlook.com ([40.107.20.66]:13280
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728310AbgJSH5x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 03:57:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QSU3PXhtgA/NGesEuRvR9K5a7JxAdomeKDzEl6DSlIPnSQP4ybV8YIOdkknn9w3L13c+IgtegJYFoTHlIHPGYJ1p1t+mMYq+HeeRe+jucN9G4ICVgCLUaR1wDWoayu5rwSuiSI0W13FTnESV5PyW2ciphtb8AYu31qTT05sjTk6kYz4feBkI5MC4DrJyjxexzsg2C8nbSx5TLDDkJK6eJqQbcp+ccwl5J7cHryaNlSMI9riGE1baenXYnTv8NQVfA5PFtaa+vyQWH0q2QGY+amO3M0NaVy9hb9V45sAcvcpiz4lJNky/PDJBTrR5zq1f0xuh7emtG4rOlxmIobHkbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=peiX8UE9p5cXI2sL73kSBj0XwcJcL5uwALVe1rW5XNU=;
 b=dWYsv8XMJhyU6LvEs1A6bhng/oKegzhjs3BH7lf12dxY73vd+4ry8htEeECW0ODWeshV/rb60pxzlvRc7z80KwB62fmCv+Q0TWBPZ7Hf76PFBihAqFjx4Neh8zPeXlaL0t9e+sVrHk5F5x7WDIp8CF4tVVMniRASSkutZtufH3Ur08KPjup5+LFSucyV1m6hZOVK+8EvvOuDcFix2xMQxJ5yZ2ctyZT+RQQ1rg9o01Tx+y2BDo1xVWKAo3E2vHjcP913so/mf+3QlNvO98MO4hYar4auzeB0oYaK50ZdJVDdmxbA21bkskK/a6At1HRmrusIloiyzRWBh7sJK43Rrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=peiX8UE9p5cXI2sL73kSBj0XwcJcL5uwALVe1rW5XNU=;
 b=SgzvNON//7ERxjsxN/YM2RBOEKf3DYmkPcNsXvxv3gdO49tdiKdG7/Eo9hd7RoMp6dpJ4L3eQQg2UrobvGdGJwBfG2mUH1BPVfykeAqdLZojUN1Eb3JmtVfZ5CTdJxW5ZwRiwh06Kgu2+MkboxseD1LjliULUe6sh0TrUSjxbDI=
Authentication-Results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBAPR04MB7430.eurprd04.prod.outlook.com (2603:10a6:10:1aa::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.22; Mon, 19 Oct
 2020 07:57:49 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc%9]) with mapi id 15.20.3477.028; Mon, 19 Oct 2020
 07:57:49 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     mkl@pengutronix.de, robh+dt@kernel.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de
Cc:     kernel@pengutronix.de, linux-imx@nxp.com, victor.liu@nxp.com,
        linux-can@vger.kernel.org, pankaj.bansal@nxp.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V2 3/8] can: flexcan: remove FLEXCAN_QUIRK_DISABLE_MECR quirk for LS1021A
Date:   Mon, 19 Oct 2020 23:57:32 +0800
Message-Id: <20201019155737.26577-4-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201019155737.26577-1-qiangqing.zhang@nxp.com>
References: <20201019155737.26577-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR02CA0107.apcprd02.prod.outlook.com
 (2603:1096:4:92::23) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR02CA0107.apcprd02.prod.outlook.com (2603:1096:4:92::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20 via Frontend Transport; Mon, 19 Oct 2020 07:57:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4a95f0ed-9389-4146-2143-08d87404ac74
X-MS-TrafficTypeDiagnostic: DBAPR04MB7430:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBAPR04MB74303641E09094DB5FB443B8E61E0@DBAPR04MB7430.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1468;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8/wOdOEa8weo7IXXHCGIboLlFc6aaUlUq7/RKtZfmriLUkDP2equSZx4bDplY/ZdOw0MOio7vI5wyK200xf72LheRDCzZHfJxjCZFY8fdlvBu/QCuYAxS1Bm2qxI1PMGSC824lMzLovaTpLvwFekTvUcM2HJ0/6C+f1n14+TOCIrqyzO/liVuExfrs2FeeN/XSCHm2ZX5QVdbhJAymUeeNI/oqyMBFrxJXJ+dl66WYGwV8N9ACyBeh6oI4OoVI6eV878v8QV/AzbsnrD1reI5UhI14vq677CHpzDVX4nbIDgJ2zqylCafZD0LjVlMvsRIYGYiHKtiEDuucQEv/ZS2HMGEC6zhF4SNL1XGMwI6CnOMy4vPK5B5DvVC2hNu6KI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(39860400002)(376002)(346002)(136003)(1076003)(6666004)(2906002)(4326008)(956004)(2616005)(316002)(5660300002)(52116002)(36756003)(8676002)(8936002)(6512007)(6486002)(6506007)(16526019)(26005)(186003)(86362001)(66946007)(66556008)(478600001)(66476007)(83380400001)(69590400008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: fSK1HbAaeVUsdCGnxSvUgS9ZbY0u5vJnorgGlOVoJWOYXnJEy/rPcrT+eA35JfNhbjMhvTxSSUlJPn/or1dSNr4NMG7DADtLUbshNq2TcFywDTrmMpYAZ2svUrwGt8ou+g0TYAPlWC5IgVyfYecOWcrfzBYCQ7bKXnymWGyBUeVL0FcvwANdezfWd0PBORgw+yKJdIqjRnYX8JrDjXXSgY7o6dK0Fc7tmeJfO3BonmA66RytTBJbPNRvxn7eMbLADpE5uAaRj4J2JcKw0Nes/aZHYVcvMiy343iScMyk+7XeDj9IzqX3pCpFZ0rb8numRQll1wK5Zu6YQPmvD1RkI3UASPwSZ064iCh5jFyP236jiT41RqXQcxUCrowFw3/azuM7rR6gbv3B1PyGoJnXRncVPqgaVl+XfZuAC492QrhqJcAOBhzy7GIb6hPE32UpBhnainRPLqhuxETZCTW7mG5+lDfDn7Ujlq94RaNm/4D+AA4WFA+snF0Ab8XyH64agaRNjC4Mn2hxiY662V5z1C+RlqPWnAppgjbkhV7c6gyUGhPFrGf3deJfACoBEgYk17wy1VnEtcEkSC4Zbvfc+2muugrHMOhSYsJQTyLLLWiWgBp9IL0IkUeTkIGVoJk7No6Xj7zznzGjC0OXMe4Wcg==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a95f0ed-9389-4146-2143-08d87404ac74
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2020 07:57:49.8372
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IhDAjhzPgJZCXjI/oy5QwC918xzNyRWaW65jK6w50GNRDXNESlsJhZzn9XtcEBddVDwfzokuEvzQMLRgxfl5uw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7430
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After double check with Layerscape CAN owner (Pankaj Bansal), confirm that
LS1021A doesn't support ECC feature, so remove FLEXCAN_QUIRK_DISABLE_MECR
quirk.

Fixes: 99b7668c04b27 ("can: flexcan: adding platform specific details for LS1021A")
Cc: Pankaj Bansal <pankaj.bansal@nxp.com>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/can/flexcan.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 4d594e977497..586e1417a697 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -405,8 +405,7 @@ static const struct flexcan_devtype_data fsl_vf610_devtype_data = {
 
 static const struct flexcan_devtype_data fsl_ls1021a_r2_devtype_data = {
 	.quirks = FLEXCAN_QUIRK_DISABLE_RXFG | FLEXCAN_QUIRK_ENABLE_EACEN_RRS |
-		FLEXCAN_QUIRK_DISABLE_MECR | FLEXCAN_QUIRK_BROKEN_PERR_STATE |
-		FLEXCAN_QUIRK_USE_OFF_TIMESTAMP,
+		FLEXCAN_QUIRK_BROKEN_PERR_STATE | FLEXCAN_QUIRK_USE_OFF_TIMESTAMP,
 };
 
 static const struct flexcan_devtype_data fsl_lx2160a_r1_devtype_data = {
-- 
2.17.1

