Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF9D3CCE5F
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 09:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234867AbhGSHVn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 03:21:43 -0400
Received: from mail-eopbgr60043.outbound.protection.outlook.com ([40.107.6.43]:63374
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234853AbhGSHVj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Jul 2021 03:21:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VP1DygM3KvTYCjCklrJO4aQei9WtoLO+BA01sytYs5buSOiOrS9FZgxHo20nWf2d2sMcX2fFxbhh4XVdpsE57W/A7U6jrj8Y5HO2J4PrelraxFj+j9e5iYqYeHOv6Z4YJMEiNZymSsW6z1tbG9udMY+zFQFu2MNemMG4JKvGEnseBPMAjBqifAcCPLVpiz3Agtw6w5k1bTQ5NjOHsLW6shwKwUYBs9AxoZZuERILaIo40WSEF3XhQDg5R0ZnKEWGDmjFom2VE9QyTb15zmkJ7T9Xoj536iYRyAWbxRAmLzTsq4R0UzdWY+cL3az4BaMpAPOg/cGC6+wb+prV7tIqfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wvNj4Xx03q9YCNHPmJRFxAAcK6DGYny5K5jd0lrCMuQ=;
 b=N5iGirXdk45r8JZJAOxBRzUxhd3wn/kfnqclwo+nwv4AE97B/pF+qL8g8o8BTboWkpdajdMv7aUrgH5Ly/9pkS6WRTG8z4EwfXllVujD+IVQ/GMwfViNAIrTH6QPo9vPTARQf+TN7dc/iNVlJQBzqAuevF++p2/rkyA4vNCd38bkrqPutK/TBDnM08h7yvFuNCV9jZyVJxcfqP0HSrqSHsZJvImzMQ30WbFRQ3y5HjubMUDMpcGwtAOKpBy4/Q2E3TWrV29f+RiaBwVmLqX3553iM2FKRSR2UvY60sRrg6lqnSMPSIIlPmEBnjsIRE56veZueynrc212Jd3U3DIMtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wvNj4Xx03q9YCNHPmJRFxAAcK6DGYny5K5jd0lrCMuQ=;
 b=T5uyDqGjJ1dmYBSOt/wPhuFuVZ09AITlkdK1tiva/R0P+kenAJ66CXCATkujnBGWDHcfSMapwYoYCES88ItOO3Et+XxjT0DmIW3Qi+lHvbqYpqQL0QOtF84PFY2XnwtWqUadaF7s7MTSd6BJTGu4qM1mBf4mD1QZoDeaeH8Rv1k=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB7100.eurprd04.prod.outlook.com (2603:10a6:10:127::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Mon, 19 Jul
 2021 07:18:39 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802%9]) with mapi id 15.20.4331.032; Mon, 19 Jul 2021
 07:18:39 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        shawnguo@kernel.org, s.hauer@pengutronix.de, festevam@gmail.com
Cc:     kernel@pengutronix.de, linux-imx@nxp.com, peppe.cavallaro@st.com,
        joabreu@synopsys.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next V1 1/3] dt-bindings: net: snps,dwmac: add missing DWMAC IP version
Date:   Mon, 19 Jul 2021 15:18:19 +0800
Message-Id: <20210719071821.31583-2-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210719071821.31583-1-qiangqing.zhang@nxp.com>
References: <20210719071821.31583-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0067.apcprd02.prod.outlook.com
 (2603:1096:4:54::31) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR02CA0067.apcprd02.prod.outlook.com (2603:1096:4:54::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.22 via Frontend Transport; Mon, 19 Jul 2021 07:18:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 12061142-28d1-4526-0d95-08d94a856e32
X-MS-TrafficTypeDiagnostic: DB8PR04MB7100:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR04MB71008DF1B65D7D052B4C911FE6E19@DB8PR04MB7100.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1284;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MWWkqQuj8rB/aI7VzIqfW3hMdLYIcoqywT5mkrkbfdH2m24lU7Pl2QDORrO1Kwk5DtKX0c3wQhLBg/EwQ3u40NmAN70RqGiwT61ba7Nj7KPAM8B7URH4T1yf1fWH5aKmYNwZpYZWPPJIlmnzniq1LMNG0ZCsKOOv22naU+vCqNxNzdPXjWHFjLNWiwGp+Cv7lY4dJNfEWRQqlYwYRE9G0QHHLQNj+yqDRjBad0/Yk3rFwXpMA9FFsaW3jF4K8O/6ZgS20kdX8gi6aQ5mOAzuXN4qTyozmCQk0zIFXiiCrcNwRG7D7XDovuTGhKlLY+VVfeOJ7ij0fZi8lWwgUOooxtaXQQR+l/YLHWWi74JIMLjHGxqxndsRTsGnZmVHPd0P4dzYtXIPHhYlFLx3a/PKxcXEvyiXDzsHFjAOH7LQC8SjdueOdKF5PsblNhIaUPFK52bZ/dPrBORpuyfvCzpYX6BJtFuiKSUtNi9sIZFrqU7bsX5SqpUq8YcRPKhpEH3zYd7xPcnIlJUCapxurKGJNVc+lZBVTbfnDG723Gd3ovQfFuWg9szh+diVcBj27M89Qs4qHAtpgtf80Jg2kg+OS4+LPM0ZF2zx6fLiJcFeyFqk6kmGRQVuiOG1PE3Htx3jGxT07wjxzUlOf54cL7xWj+raStKrHeuYWWWgvNRCWvUmVLfdBQ0zkMO1J/ovX3NLtrBIKRO0CBHl2ybyVKLU4w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(52116002)(1076003)(5660300002)(956004)(2616005)(6512007)(4326008)(7416002)(66476007)(38350700002)(38100700002)(6666004)(26005)(8676002)(66556008)(8936002)(36756003)(6486002)(66946007)(508600001)(186003)(2906002)(86362001)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Z3rVtg0jkdztScCOKjKn1pCdOhfrWRuz/fjN6GsjkEFetL8kKxsT221V8jI/?=
 =?us-ascii?Q?hDqlwylzJVPn2ou6lWLC7TWxEz4PPATDDxRhwFceG7tdPsiaX2b04JONbRA4?=
 =?us-ascii?Q?2Sd/VWRrhcSa7T81GIplMtYRsmhiZbxkzm6z/YZfjXlWz5B5uH5eSQY+3c3f?=
 =?us-ascii?Q?HTdzkbJwcD8/CVQBWh+HhieOiifn0Kq70ekz5qP62RSDjPXkEn0NcNNyUftU?=
 =?us-ascii?Q?ZFCo4EoCIjZ6+HxykjucT+rktFsTDVb0yiEGjTHLpDnH64HxaeXpZ7lqe/ta?=
 =?us-ascii?Q?9u38rLXBBDqgvPqV04mWBN30ua3vk+mB9hRQAn1we+l3pruY41FiS1hNd9e+?=
 =?us-ascii?Q?6ASFCxomN8bXJCGeZaRvGgH4FYPauqqRoohE48C03vhiynu8cdCOcBCwgFlq?=
 =?us-ascii?Q?T9+Re/HLWwwMVx1VB2G8nv3zR3oJiBfwN13HJNzxsxXMDLRGqQn1VJLHg3n3?=
 =?us-ascii?Q?tlL+sUp7EdgUUkl5SlRdvfwqrI2I07HpK7huiQkrfTeMq5YK5gSJ1WJ3Sw4p?=
 =?us-ascii?Q?9fXbi0aE/v87fsyQPoDV9YHtv3R3zXzQ0A0L2U+4d/METZBFt4WuEY+n4CpC?=
 =?us-ascii?Q?hA2arSKjIbl8T+BMwYDNuFMYEsOcLWLL1eVdwmbemRJRPevOrZKcWf5fyCOM?=
 =?us-ascii?Q?gVjeAFdJWWc3r0gTn5L9hT6O8xWXp98e5tm7YEEOKHnDVY4blK7AxSPL8KK7?=
 =?us-ascii?Q?6Zd8+0tivWsQF8sqyzqTNBCXSYIYr2zji8Qau3JLzRZ79uaDb1lugEpX/tme?=
 =?us-ascii?Q?1qGR+fryEJ47pKaAmlaYJRnIWb9Is7ZNlqCCdEXKaouwtPk2A8yhP5ES21bN?=
 =?us-ascii?Q?37/DZxVk0GMBIlhoySzZZKRO5FU/GjGzWptWWo3RprYqx1gNan7s8AaoP7Eo?=
 =?us-ascii?Q?6Lm0k6iZCuB3IISnFiEwPsDffWKRXwLIxsGLUVlTpImox7h8goLgxNShrC25?=
 =?us-ascii?Q?qVjwanqpjUORrqYN9yDWCYj7zPMP6IM5psgdZsBnY2RAF5jTpayqpXKFG1VD?=
 =?us-ascii?Q?VgT3o7KOh9TyXGLCGAnRKqYpzw0Cs3q7H1rLqWr8Zgq9orVXMw0fGuSBAp+Y?=
 =?us-ascii?Q?QcJFCvgfbJA6Hw6IG1yJUO9wwWQOaUBTF82q3lseeMKJ35ghHvyRNqEOF4IE?=
 =?us-ascii?Q?BImVflXXTIojfxltHHhFY6UuQn+7gVOrzsZfLj48eQINsLn2GJ5xsjg8ayQB?=
 =?us-ascii?Q?EqhSHDYRRoGzw/SP2iqEKQ6i2qQN5wT5FVD81RxCgHvKtAgSMC42iXHXDF5h?=
 =?us-ascii?Q?bxGCiSd9IraGFy0puoNI2jWIYa3XABE2kf7AyqaIxanDj7CAFf1HbbZLfX90?=
 =?us-ascii?Q?8y4mtE7yBIiBlKfNT9CKVAR+?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12061142-28d1-4526-0d95-08d94a856e32
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2021 07:18:39.1128
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CHMsJQBsoXDLa6tVAzFeNES8+lkMto4Q03enXHRHcEZSqEcDf4jLn5qblaT6Bw2v3OnGIJM7flmOG3VHxS2Rjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB7100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add missing DWMAC IP version in snps,dwmac.yaml which found by below
command, as NXP i.MX8 families support SNPS DWMAC 5.10a IP.

$ make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- dt_binding_check DT_SCHEMA_FILES=Documentation/devicetree/bindings/net/nxp,dwmac-imx.yaml
Documentation/devicetree/bindings/net/nxp,dwmac-imx.example.dt.yaml:
ethernet@30bf0000: compatible: None of ['nxp,imx8mp-dwmac-eqos', 'snps,dwmac-5.10a'] are valid under the given schema

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 Documentation/devicetree/bindings/net/snps,dwmac.yaml | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
index d7652596a09b..42689b7d03a2 100644
--- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
@@ -28,6 +28,7 @@ select:
           - snps,dwmac-4.00
           - snps,dwmac-4.10a
           - snps,dwmac-4.20a
+          - snps,dwmac-5.10a
           - snps,dwxgmac
           - snps,dwxgmac-2.10
 
@@ -82,6 +83,7 @@ properties:
         - snps,dwmac-4.00
         - snps,dwmac-4.10a
         - snps,dwmac-4.20a
+        - snps,dwmac-5.10a
         - snps,dwxgmac
         - snps,dwxgmac-2.10
 
@@ -375,6 +377,7 @@ allOf:
               - snps,dwmac-4.00
               - snps,dwmac-4.10a
               - snps,dwmac-4.20a
+              - snps,dwmac-5.10a
               - snps,dwxgmac
               - snps,dwxgmac-2.10
               - st,spear600-gmac
-- 
2.17.1

