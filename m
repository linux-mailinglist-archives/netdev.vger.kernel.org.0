Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D79E6421720
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 21:16:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238688AbhJDTRo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 15:17:44 -0400
Received: from mail-eopbgr60088.outbound.protection.outlook.com ([40.107.6.88]:55525
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236024AbhJDTRj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 15:17:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EQNUBS3akYODomCiN3x1ac/YYBd99+Px7xupYHvHCY1zyo+vtY8YMWxNspHp66hxfg96cZucw4G0XPBWcx5uqkzm9M86RjBVEe03ETiOnQ06PBsd7WwM7Y4jTegLyk1QRsaeTcbS2kMvyHDcjGp5pKKG3bJcSyeUKVOtu7n3zdrZcK87vlcx9k2QstDF4df3FdZfUIug99v/ek9pmEXupPF87wcCWFUZRJDr5zT5NvtpUCASFPwxEI4lbg6J3xNCvAKyyW5LHiFJSYziCIQGKylwhdQ69nFcU3bgZDAcCCecHl6TSQhaYpF4414eqj7qIIcO3RcBYjk1fpCTfWNiEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PUISQ9T9H/VOPco1fyucgWrbR4Z0SCRT5jht9oSvTOM=;
 b=k1bBmSkYTEj+vcejWca7SXI1Mrf8LwEMXtuyqrtsYa5dwHwWdcdNmiWq1L/L+qraIGjoGw6ZiNlUl0LDyeTUjOPdlkazn59wfQ97GRM9qW6stx5u/obwS39ay7WceC/aGC17diLiswrABzZgyngLFieZL9mmvH2Sp63Fgbrl+wY4LDvPEgh5fLhrL/KImJSHiFfV4A/rpWuwx7uluSjZNBSNB7k068ZqHl6nrTW9pGWrX0eHfhbh9hiiuRhNiN7brtL+/vqqT3p5nGEJLGMRZgwrphMbf1/jcazr3ndBr2S3W4VPT7APdC5ECiGiwIAQrRIInkM43xN5HxG2kyMN2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PUISQ9T9H/VOPco1fyucgWrbR4Z0SCRT5jht9oSvTOM=;
 b=vexHImE1A2+TBYWlZhXVHSnaOjPge8dooKy+lFOIkvzFoNgQqwFd9Di5H1kll+MnffarQ5MW71wYsNvrmZVKisE2Zn0UIXtGGuz+nZ2cHW7T+tYfYS0VWYNx001lf9SOqbEa5bMStTtcRms+r4dxAxMyIt4zwzOBC59oNYMbhIY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DB9PR03MB7434.eurprd03.prod.outlook.com (2603:10a6:10:22c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.19; Mon, 4 Oct
 2021 19:15:48 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf%6]) with mapi id 15.20.4566.022; Mon, 4 Oct 2021
 19:15:48 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Sean Anderson <sean.anderson@seco.com>,
        Rob Herring <robh@kernel.org>, devicetree@vger.kernel.org
Subject: [RFC net-next PATCH 01/16] dt-bindings: net: Add pcs property
Date:   Mon,  4 Oct 2021 15:15:12 -0400
Message-Id: <20211004191527.1610759-2-sean.anderson@seco.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211004191527.1610759-1-sean.anderson@seco.com>
References: <20211004191527.1610759-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR08CA0023.namprd08.prod.outlook.com
 (2603:10b6:208:239::28) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
Received: from plantagenet.inhand.com (50.195.82.171) by MN2PR08CA0023.namprd08.prod.outlook.com (2603:10b6:208:239::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.17 via Frontend Transport; Mon, 4 Oct 2021 19:15:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 84aa43d4-f72d-49bc-8864-08d9876b5f4a
X-MS-TrafficTypeDiagnostic: DB9PR03MB7434:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB9PR03MB74342653C969DDCFB92E823C96AE9@DB9PR03MB7434.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ihs9FU0ikdDxcNX2txzrar0bXj3mMTCN+L9QwOLt47NNa4Ndx46qQWjJzYSrvysYiLY0Oi0vRLFSICQn01cPJe7Hp0bkMhS4y961yntjyRLi7YZSNr3V7jctLECdX8PGWhC9TpdAybdNLyUWPl1U7EVbCQzCGFAhI0axC7e+rlOUK10X+huAXPAbYTlI49AhtOQrV2xTRgLTOROoWUeKdpQOkLymyN9oYs0JNFwhmXKRUNYzAxEmIAR+V8jpVroqsjNmElXknWA4bNjlu6ujFsjIspzyvGWJ2Eeh4Gz5HNyVjFmDDfuCwZru4yc3g6GaEqXJrsjijdHabeVfc8Jl2jpW3a8tqavoI8Ny6VKYUaxa2qQwx3fmCP4G7enpe1xThG2tE0AwezIUGKOa/NIxxi9w1ayAAQpraCJfPZPP02g9+wyQ3ndOXkFGfZa0a6SFKvKDb1bE277KCv1d6mHjhVmJ5Am7+VDQX9t+ZnkN1STj2YzRvc8BTZP/HFsblf+OuZFsUwn0Z742lW5lFv+/rU/GHHMYk42QPINx+H5iUaiYTx2uXFZvQArP3mXavWj0WskZHb8MCD/v1kMJHyE7h4wnFAe73kp/VWOW68DyF6jxjIAyriSitD/PGNrIHFW97js2+Wgx0CA30iIFvGwb/7bSajDDK4dq0xRaNzJSo82odm8n4OYQwI1IalDUEhFZuW2vxi/78egrsaT0iGMe4w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(1076003)(86362001)(4326008)(44832011)(6486002)(5660300002)(66946007)(508600001)(38350700002)(52116002)(956004)(66556008)(66476007)(38100700002)(110136005)(6506007)(2906002)(186003)(8936002)(316002)(8676002)(4744005)(2616005)(54906003)(26005)(6666004)(36756003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UqWHr7xH6EFELpxIRTYb+RqrakRl5thObZfKHXrt/NqssCqiFSU99ZVyFi5f?=
 =?us-ascii?Q?7wKZA0ZAQQFaSukefA94zYAgdPYcz/YOI7wr3ZMwBmqtZG60uPQeFpfnXnMa?=
 =?us-ascii?Q?lYECsjczOfFOIrLminDGs/dyajPQ8xkeZgA/q0M5dYz0lMfWUEJUq8ZuPkpN?=
 =?us-ascii?Q?P9zAYcT49ic0TNb5F5m7+QZZmCXMTq1Lh31hrXNx+f10iwqc1EJKW9Z+d6hS?=
 =?us-ascii?Q?mUvFbsXm97nJJf5gi87Sz/sKHXEhPh1mBE6uHWhpOHMlQ2ixqbql/aBvbTo9?=
 =?us-ascii?Q?f8vu6Z6Qy0HPyiPU0r4s5RQEWjfsXA1zHyLs4MNOHuj/XuQtOkiKux6qbD0j?=
 =?us-ascii?Q?z7Etgwdn6DLEHHWL8ZrI3NsBgFh0GQsGVifl3H4dPG4ZYlF9mitPzx/swetr?=
 =?us-ascii?Q?T5DwTOjTNgHkZuzY4rAmWm/uTOcOEwrXqbGePhg4SwWTpu8F8jj2RGlF7+y9?=
 =?us-ascii?Q?6X543GJjZ0+MciXiXLbDhr+XhjpiyX1ikkoBRUfOtkUpc0n+lRH0OI5uVsC5?=
 =?us-ascii?Q?1s5YS8SOWSCI9ArODJ8slZWcndicj9H45K3+7wBzm43ABn9c93sF27myTVYU?=
 =?us-ascii?Q?yQCWjetIde2j7vzteU07MV/Hd21dXb5SQTTgn0SiA3e9XI3oQdJQfGpufBJa?=
 =?us-ascii?Q?YjweHIS94+HHzyiFp7PhuZu0s4+CAvNrkVfok3xmRSGuIJX7geoFECHsJ/2g?=
 =?us-ascii?Q?dtzSe+ys83BtDfRdsYMqut1Tnws/Q/cveiFA9Y/zh6mB7kLhzMpiEsq+XfJB?=
 =?us-ascii?Q?2C/ctiU5qdq3UweQX8PjAu+w34zW7SAL5VvBhsp/q4i5viubwTJrf8A4c942?=
 =?us-ascii?Q?Va2CHZ7rusIrfFyP68V9KExWYZZlX/MjuUsQZY4P/ChNqbYCte2bkOgWxvNQ?=
 =?us-ascii?Q?CeWWag0KA/OAfvr0+ZXsO8c+64FMyIpVtBMqFBdX99KwxRwzr0cM1naFJ8vE?=
 =?us-ascii?Q?R9yInIsSH8IWYimii9/ZoYyz3Tc/eAys6118ceiETsiAAFL2Xclxu8qB45gm?=
 =?us-ascii?Q?JWs02mVeUOZhtUJEm2+BmFR6AN5sE7p1Xn+MEmmV1y47PtvCqnCd/jipgEtU?=
 =?us-ascii?Q?Wb4kVgWOUzjFfdSEluxivV8z6tQDRxyMJFUG7S0QaOj5b3yHn5gZAZO5oYXN?=
 =?us-ascii?Q?GkQJPIlOkgYG/W5So8JLcFN4lCkTUPZwQIreruBx+f3qX1HiZFVRUowAVy63?=
 =?us-ascii?Q?oZto3m+ptL6j5Ww0FXt8cKPAQTshYlfcOxx6GHSEwjidXSABOYIsQdNZlRdF?=
 =?us-ascii?Q?S7D1aBOdpHWWeyE7b7r6ddxwg6nLGiLK/NUg3tjtoHCBXTkadni4hMJwubZd?=
 =?us-ascii?Q?D+TFwi8I3l6S1wxbqNXpl4ff?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84aa43d4-f72d-49bc-8864-08d9876b5f4a
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2021 19:15:48.2481
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4MFKdNqQCzO/CMmw2S5kbLzpdJwsFKcTPvwAvQn8G4A16Z4VISkuQOigCVCJLlnOyuJQgCLVbxj0TwDxdrCPDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR03MB7434
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a property for associating PCS devices with ethernet controllers.
Because PCS has no generic analogue like PHY, I have left off the
-handle suffix.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

 .../devicetree/bindings/net/ethernet-controller.yaml         | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
index b0933a8c295a..def95fa6a315 100644
--- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
@@ -116,6 +116,11 @@ properties:
     $ref: "#/properties/phy-handle"
     deprecated: true
 
+  pcs:
+    $ref: /schemas/types.yaml#definitions/phandle
+    description:
+      Specifies a reference to a node representing a PCS device.
+
   rx-fifo-depth:
     $ref: /schemas/types.yaml#/definitions/uint32
     description:
-- 
2.25.1

