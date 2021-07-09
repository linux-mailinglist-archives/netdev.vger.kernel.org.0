Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFB853C20AB
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 10:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231640AbhGIIUg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 04:20:36 -0400
Received: from mail-eopbgr80084.outbound.protection.outlook.com ([40.107.8.84]:6131
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231605AbhGIIUe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Jul 2021 04:20:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CYUl89xucj/D+0KkgRMN5Q9j7IhGYXroaMy2qzXrkACatwQb09LWNSGLijbwPbRHHTSdZ5iOPXgc79YliSIKtDiH/XtUF7vfpAC517V2cQ9cuQeiaGs1gyBzWlv3IYdBh/u0wj/P64ZhvCrY2hqGKWrFAERQ9v6JwaMxmKN5VNtKTg3R1hkQu8BsJifxGcP242BNHL8OGxmvYM0NmuLAe3ctoMzCS7srwBfu5NSyixUe3n8jJTo+ynX7vjjjcRi3KUWsYYQ0QuDoqUrboZA6FVF8KetdOETSDfhg9KaNeCoAmMFRj4PK+Qdqd2l/2Y6M3dJaXOjR42BNyYF34ok39Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ke5/7c7ZfiREk8dq3+OmByrM4xqkPJ3/1VXAQItaDTY=;
 b=GMZtTJN3gzaVhZIHHPPeNERjvt8XKahQSdmQvAQ5mMg+s0LD7hq/qSxeBUvH6g2p8RCo4iUQz2Z9VYQaLMlyOuowsty9U8pvy0GrI89KwCNYKOhjGNOScxVXXSc7GfXWCIMvPVt3U/Y6HJlvMiHHuv4stkpVPTN5ptP5djK7JnWUbtec8T+/EWfq4aD3Qm8KzMT6FKxbTgb/OBXnUradQZYxxCpbpbZGja8zk0BPtPZVtaJhvO1ywiqNNs6IQuxML/VNo5dg51V6GRjgjESus6oLfn84cmWK0hKQi/GObp16k2ZPviZ0xlnpkUSXcIq8KaZAB0RpUx7mZAIwCGk5Yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ke5/7c7ZfiREk8dq3+OmByrM4xqkPJ3/1VXAQItaDTY=;
 b=C5cJ9OcTI2+HAs8eJM4kLzruuJ+LqYHrj84/pjHk0YmxSGPrFdVmpkdXCKDrkqIkDMhfDIAXB5DwPWDTHNhXtZ+S+jGRL3utr3Ty8se2nxS5m60dhyY6+COWV9oFcRzpVQ/iw3tOSD4Mdsw+/0scUnb/hqmaRqHuYPCCbQ3LIHE=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBBPR04MB6140.eurprd04.prod.outlook.com (2603:10a6:10:c7::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.31; Fri, 9 Jul
 2021 08:17:49 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802%7]) with mapi id 15.20.4308.023; Fri, 9 Jul 2021
 08:17:49 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        andrew@lunn.ch
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH V1 net-next 2/5] dt-bindings: fec: add RGMII delayed clock property
Date:   Fri,  9 Jul 2021 16:18:20 +0800
Message-Id: <20210709081823.18696-3-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210709081823.18696-1-qiangqing.zhang@nxp.com>
References: <20210709081823.18696-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0021.apcprd02.prod.outlook.com
 (2603:1096:3:17::33) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR02CA0021.apcprd02.prod.outlook.com (2603:1096:3:17::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend Transport; Fri, 9 Jul 2021 08:17:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2ebce0d5-bfa8-4d8f-fc44-08d942b209e4
X-MS-TrafficTypeDiagnostic: DBBPR04MB6140:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBBPR04MB6140A416BD4D7BA0E9EC969CE6189@DBBPR04MB6140.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hJkQlK+yl1jnVKNva/nH93VJNQ2J7LnNX2X0ZjOuorxdEq0eQ5XC2wcKHEWNfLAHHmjpDQWyeCQRIB6TFLv/Hm1dprKvOLJsoL5ngcJNs52b6vGIBXsYXkIhAHfUVdcP7l7E3f6OMFy38XAC1wOgUxSRzofjY7LJ82WzOXF8KLk6n3xCUqD5F1pSgqHWkvl8OrvzM/WI5TD1oB4WJZ+l6AGxKfBRM7iHbWw1Uz7lhLKvL5L0y+1ga2ezm/WtJoNkWLm3gTt75z+ajsREmZH6AhDyXPf5ciHsAHhdR+4AlMmfc+yGUEqygg6ntzOI369NzevA7hPTC0nxDmOieJi92UfvahnPsoTgT008LiM3lrFQsnCsQsZDnKrVbHoB/JnIRQaJwqTMow6RKSoL6lp7kGUCbvvh68mkTBnqpfYROG8AKrQTEHfTpmtnbXJFlgx3OYgMtScH+iAjmtNfePt2/ooMzJMcCccNnz46zSBBrEdGD8DdH/KDDTN5fTuNadGeIwkax2SaHQ5RkbZE8m7/yZ/wWCzJqMOSsIkPt1nZkbAvvC2Cmx7kBQwnBB2ETuc/PUq8XRLxZj/M8ayh6jgegP5rjCUedR9s0yd6wxpR4Gb05F3AKcG8Kgz0JtDKJrp1alEW4nLsOXFHLZkUqrJiIbJNNVy5FYWWdhBxAizdVk3fvRvk5rrwIsxLbx9vRAjMH8hEtzlB3yonRN+dPKMFMw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(136003)(39860400002)(346002)(396003)(478600001)(6506007)(38350700002)(316002)(956004)(8676002)(6666004)(6512007)(66946007)(6486002)(186003)(2616005)(26005)(66556008)(36756003)(8936002)(52116002)(2906002)(38100700002)(1076003)(5660300002)(83380400001)(4326008)(66476007)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Tc54sg869qkl129eUNPmIiE5mkA3MqBDJDXqAaxyZIkvcoCifHvTFOKa0Mby?=
 =?us-ascii?Q?psxHLpyO6s19mw/aP4W8hCzBacCdIZw8YS9iSrjE9dicN8aqHcM2ycUbS+yY?=
 =?us-ascii?Q?UN8VqzeMBQ1JrhYbjABZqmfdq335BnLL4hCYrCRer1VQWShuFRirwzQjVEPB?=
 =?us-ascii?Q?+XcJ/2So4FDwmg92+IfLzmqFNAlReQblB3R7AB5wxiYC3ok7gQKYEmFT2ohE?=
 =?us-ascii?Q?Jw8B0tBkRDC9HcfuFVj2qowRdzB6FBmPreVQn/Hv1dS690ATFBeHJ3jUFMl2?=
 =?us-ascii?Q?1yw+Es6ma2sDVqE3JJ7NVtq7/DJK3uxBDt4rKu/PaKMfHNm2fNx9yITBTI3R?=
 =?us-ascii?Q?+Sz0yKapKW55+dwq63ViRiJwQCNcDQO/gbQXwxGpTy0C+q5J7BTX1tBpBnhv?=
 =?us-ascii?Q?HKY1aPHXx4SdxkfchTjTbzgIPD1k4c9w9B2G8axZ7B6WAKGNgRcUfF2ntDT2?=
 =?us-ascii?Q?75bYicFsJ8Hez5AgDTUg8qWQg7KTmj+aXPGbKdLgwltqRV/xt0m02JqzuOwe?=
 =?us-ascii?Q?DCjOVJ053QM+zYanSBbHKZv7xHCIn3w7LXJXd+E5FAYRE4H5PGrV5QpNNjV+?=
 =?us-ascii?Q?8Uz0wp3VJNgV9h6pHBi7OZ5AxUJFmoL68UVBsTJ21yCvOZP37C34DJ6adUKW?=
 =?us-ascii?Q?98gT+zHrbrbEuwR2pYqPfP3jks09G/RgA4miwuNS0WXcvCWLvt+iCCz3bgVO?=
 =?us-ascii?Q?oBPxt7lOXcg1J+kHCicjtoVZ3Lpp2LLuDRbeCRx4coWY3a0fmf0Dt5mBLzCW?=
 =?us-ascii?Q?ovoEbdaL59q0Me6TKnBAcdKeXx9H/UGfAyr6jYG46b9IT33TI/jx3x9VYvIj?=
 =?us-ascii?Q?VJt1B/++EX/CB3Byc7h3YL8Ti0ZJd0UdT5Ux3lHc7pIYNTVSEEV5ZDoPWIid?=
 =?us-ascii?Q?jqLgtjF080wGGAtdfUzKbQ35O9cua6rl/6mFp28o1ndcjWdLOGGd71KKe+qp?=
 =?us-ascii?Q?/gPbCO86AuchmHgCVurn+yzgQ7Zi81BhzgfiN/BEQCaxTCbLo4zXCz3d5GI4?=
 =?us-ascii?Q?H7NtJwE5YczN2o0LBSLeTFFpJDtTOnIVisRgLAJV5ir25uH7J3umz29UAiJr?=
 =?us-ascii?Q?N9ScXQ/AG9LdjHbNrCdCyt+ZjAuHg1ibb3P2pMew4klFblOORExDyyNHd2o5?=
 =?us-ascii?Q?h9HZypD4jmujeB7bE0J/Rk0ToCy5lVZLhfRebdHJ9mMGIAqbmTsicl1pwDDG?=
 =?us-ascii?Q?bqjKA+0LboZB8/Vv9iXHyG0QlK8hl/C60J/R9FF2zx9WwAH4Y2Yj4ga82A03?=
 =?us-ascii?Q?km5N7OgocESqS2YfKexxGTwjr0NythZ3gZB9SdJubvZ59rILZ6CdwqeJ3yvJ?=
 =?us-ascii?Q?ggNtck954tw+vahNjXgHt9Hp?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ebce0d5-bfa8-4d8f-fc44-08d942b209e4
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2021 08:17:49.0296
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i565T3KPvEgzkpNhxPW2pk4oT0M4cvJH5PIKD37CIaiFaDTDjpaUU0ze1ZSOf/8SxQLVkg0SjRxF76wR7Uc+vg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB6140
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fugang Duan <fugang.duan@nxp.com>

Add property for RGMII delayed clock.

Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 Documentation/devicetree/bindings/net/fsl-fec.txt | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/fsl-fec.txt b/Documentation/devicetree/bindings/net/fsl-fec.txt
index 6754be1b91c4..f93b9552cfc5 100644
--- a/Documentation/devicetree/bindings/net/fsl-fec.txt
+++ b/Documentation/devicetree/bindings/net/fsl-fec.txt
@@ -50,6 +50,10 @@ Optional properties:
     SOC internal PLL.
   - "enet_out"(option), output clock for external device, like supply clock
     for PHY. The clock is required if PHY clock source from SOC.
+  - "enet_2x_txclk"(option), for RGMII sampleing clock which fixed at 250Mhz.
+    The clock is required if SOC RGMII enable clock delay.
+- fsl,rgmii_txc_dly: add RGMII TXC delayed clock from MAC.
+- fsl,rgmii_rxc_dly: add RGMII RXC delayed clock from MAC.
 
 Optional subnodes:
 - mdio : specifies the mdio bus in the FEC, used as a container for phy nodes
-- 
2.17.1

