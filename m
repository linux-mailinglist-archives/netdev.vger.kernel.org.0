Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 838FD293631
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 09:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405678AbgJTHyp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 03:54:45 -0400
Received: from mail-eopbgr30060.outbound.protection.outlook.com ([40.107.3.60]:43842
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2405636AbgJTHym (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 03:54:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d1emsZlfpWpp5Bo9DEEX2hIhfEd5RuaMqzaBvqIBF9pQIhoAZpK0mS5MiPmoVes+o4mT4JA+bWFmxX3I9qmNYiWE2YkGrzkge5Kn04MAwg5yz/XLfyX3RfSnl7mMmyS25gh3ctuSo5jzm79w3+QLuCxHK/c4OZZGI6/767BJrhBfBRTeFLTf5R68UOVUAI3SygkwFgMBSq6maH8Wa93M7fY9BS47Oc7bxt2YevgGLKgMcbmjZ4UI/09cAzg6JgcpYtBd7lCJfX5mfJBhKB6cI2yVBUSV09M0S6Ax/wpwgriyeagrW2KEUzqbkIM9KSZk10B06BkmfVW2GjqcS0ppTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wUOZIqE1JsQqp45rMHW0ZDhnFdxyz6s07VtATqXuNFc=;
 b=FN+ihYQiloSs6z4vsQRwXiA5Gh42K+m2Kv619noNAzvGAOWQW2GnX5N4USAV6xBdzeEd2m8ZO7T1Yj4hVvB622TLJKmYA3tMdRiN2b1ClJEp0xk7Asbh69uMx0HmAMP+AvD4Oc9IEhtt0GcClTasXLMWD4b001eUfuVuIEohR/AmLdGsiM0nyDcndCEsHUDG2wbBd40d6Pf3quYTRS/XbCdYsca08QeYNGMowghygCNPTgQY6OWwljA9OKSpynHtPCVLmfx/Qd/5nK7y5lDuBoujdDEWaqXKsHrNEW0KBCdl3bvsJnSssLzjBVIXWNZc6JZ5WfXmDfJ0EWFSpdMHIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wUOZIqE1JsQqp45rMHW0ZDhnFdxyz6s07VtATqXuNFc=;
 b=lYfUnIkkcYtJGinTVXHK2Z1zByED2EVam+Dj0NEe1vsRovJYWeo7RQR6QLXRBiRWFyqj/D9PCgJBfS0TXBvuPU1PK/2Mp0LZUJD28kPHxvBOi4l+/+zNXKxxWrA53VS8jZOti8LL+FlpE9zpC4e4IwOvn9Ibkmwln756zAIF97I=
Authentication-Results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB7PR04MB4106.eurprd04.prod.outlook.com (2603:10a6:5:19::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Tue, 20 Oct
 2020 07:54:41 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc%9]) with mapi id 15.20.3477.028; Tue, 20 Oct 2020
 07:54:41 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     mkl@pengutronix.de, robh+dt@kernel.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de
Cc:     kernel@pengutronix.de, linux-imx@nxp.com, victor.liu@nxp.com,
        linux-can@vger.kernel.org, pankaj.bansal@nxp.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V3 09/10] dt-bindings: firmware: add IMX_SC_R_CAN(x) macro for CAN
Date:   Tue, 20 Oct 2020 23:54:01 +0800
Message-Id: <20201020155402.30318-10-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201020155402.30318-1-qiangqing.zhang@nxp.com>
References: <20201020155402.30318-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SGBP274CA0015.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::27)
 To DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SGBP274CA0015.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21 via Frontend Transport; Tue, 20 Oct 2020 07:54:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7bd1e965-b6df-4f47-ed95-08d874cd66a2
X-MS-TrafficTypeDiagnostic: DB7PR04MB4106:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR04MB410662C6BBF76896B42746F9E61F0@DB7PR04MB4106.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1079;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ydOCnfmcPDVluprVhGm6AyBA9CsHVvVcEeTmVI3glsHD0ildkbMLtty22Y4c/9obcvrD2gsDWBkO73+qB/ma7xmOPcpmlumsgvsxx9lkvi5jBCtwzNP5XRzUxraSgXseB8ZbTaQFJZnyi6HLL5J7Cqu/d0Cit1i4GA5iDstR1ZzteQi9p68VCvg1I5Xgn7HQ45hXdIeRrKBRd/AoMALzbCp0AY0kvU7eLRSxyazxr47O4D1DLB1tvDxEYoBuqVxUvekGbu9+5QHOeVxWHxLKkC7hUJ/V/o5/c8jaRRWTcgcZ34CLvbHGRfQo2ZqRB8ujPcQbbiGVbc1wXLvXaSu6O/ew8b8FdIsAwpxrwEd7xdokiVTOfOtwGPJ0q7AZ4GsX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(366004)(346002)(376002)(396003)(36756003)(6512007)(2906002)(4744005)(69590400008)(956004)(2616005)(6666004)(5660300002)(66556008)(66476007)(66946007)(1076003)(16526019)(26005)(186003)(316002)(478600001)(6486002)(8676002)(6506007)(86362001)(4326008)(8936002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Wri46bVNaAbx8yMUW20x6BqZHhH9RYBMacaA+93Pt0Ckh2nEWSc1V50ji+Zjt55jik4AGe+sbC53CQFODuaryaRTrc0JdhNTlF/hU36mDJOYCmg0daBMZ8Z1uSMN9/oex26iMezXMPBVMmFwI291MgcGz0pUJJMygn/GYBwznpfR4EYXJAxGew4e/hgNjLL9uYMY0JEZkzcmof4DFJKvjykPUXG2gma1xwmtECrXMdoFAkKPOLLAD73AtLVQlcbTRX/AjVUD9xsQWOyQGfWducyg1/kdw+35GT51FcUKNMQnGoWgy7Y2SrDwfIPKnQqkk5BeJsFN3fo1t2eG0kK23fxwQKP/gJ7HQMwIvoVmH+wawMKd0CMsAbP83FrIrSMIinWmbHnhN9wsWflxC1mDsRXsXkgfox+hJppBQFpWP/xcQ9oHEjBFyRDe8bD42Co7J1aRuHgFGws7NvQJDP44WtSg9Q7lnKQfXVnCb+3uxWP/C0Es9BZt4CY5nfvJW+aYjat+aG/qBmRxX4SZ1Rbs0wfnQTgN7yDNrDIJhf38kBAn6AslVeliON05Kd5vZ6xvNO8uUcNJSOhFpcK+o6Saz6FCtEXyDVjOgjO6C7z8XvDgZFYHGbkfdGjQkvWhnhmSFYVehamrEhOaR2zPLJTJLA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bd1e965-b6df-4f47-ed95-08d874cd66a2
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2020 07:54:41.4764
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bC5573RIzzpF/IZ86US0zUGwje4/eeJrsZ9KyM/CkaABjMQmarglwVfGCLn0nPnGR3m9kTW9KksbPOrT3jWfMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4106
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

