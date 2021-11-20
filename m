Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1202C457DB2
	for <lists+netdev@lfdr.de>; Sat, 20 Nov 2021 12:59:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237354AbhKTMC2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Nov 2021 07:02:28 -0500
Received: from mail-eopbgr150047.outbound.protection.outlook.com ([40.107.15.47]:23998
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237208AbhKTMC1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 20 Nov 2021 07:02:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NTYYR/IjCDicKtL3fC/tKOw6plmVSgz3x7g8ddJxDGYjsh/GVdxw84feZSLXxGwK+qiuPT/pVM8gQIUJdawul28vUtstS51qLjXxrSnXrHwheexAY+5Oeur5a21JgKdYvDxE4ynV4YU/N9Mm6ph94H/JfngNGaiMm2QrG0AJWK2xSQzRwepBvYh2sIDgIsh+iiXAXLi4bFRNgYTtmYJ7eOff4xSHgLd0hVtOFvYfmMlTKYPFfX4AJ01r83QG3MEwMse7htuRks7NKhAkQjQ0QqTOJXlB7/53EO/rOJlVYne4XnQF/9yWutSXR/MHvNBGxARH2C9IxzLbZHx6dWD5aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Po5rmCEhBOTu0dkEButs2DIZYAUSVG98B7xOoGkzA7Y=;
 b=c2NUpaSmtD0+PJuIWc3T12jAbpK6U9Ai8mN9XQ+LUXRFRjPsDaIpxtRkDN/+5jKTLHpnVUeDFxR4We+sZ48sRh6rd1amOoq0sabDmKWteRHHLVdFU/rAWN67JhMGCu1AEya9vMp4lT2tQ0xfooTN4OoH1r+wZrFBeMBrHyGpyg8abGLiI+lFTzlrcCO2Fkk0T/mZ2EcOiT7hc6/6KAvTkw2hYugOd3NmEj67c+UCN6eSvLHb3DDC5ogHZqKJOLbrdONESHSvsfqh8xdCrRZHCcv/dLxX5Cg3QqirowWqNXXUvwNyzEanvN0UH512R8ztwSIZ90AepaPx7i7BjnIBpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Po5rmCEhBOTu0dkEButs2DIZYAUSVG98B7xOoGkzA7Y=;
 b=kwBK8ERRH8VFvmeV7F1GMLJwra17HLkhiwrsjCcYHuo88tyEL2Snmg36Iis7aafkvZsSjsbdVFS+j/f2LgQHcRsfwpcnMxW1LpXlzxCCsTWWtUH7rHYFh/3zvHuu+XGu7g9vd/BEmI3LvP3NQDKwKAhqrINxmHyDjD+lCX6a3O4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from DU0PR04MB9417.eurprd04.prod.outlook.com (2603:10a6:10:358::11)
 by DU2PR04MB9082.eurprd04.prod.outlook.com (2603:10a6:10:2f1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21; Sat, 20 Nov
 2021 11:59:22 +0000
Received: from DU0PR04MB9417.eurprd04.prod.outlook.com
 ([fe80::82e:6ad2:dd1d:df43]) by DU0PR04MB9417.eurprd04.prod.outlook.com
 ([fe80::82e:6ad2:dd1d:df43%9]) with mapi id 15.20.4669.016; Sat, 20 Nov 2021
 11:59:22 +0000
From:   "Peng Fan (OSS)" <peng.fan@oss.nxp.com>
To:     robh+dt@kernel.org, aisheng.dong@nxp.com, qiangqing.zhang@nxp.com,
        davem@davemloft.net, kuba@kernel.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de
Cc:     kernel@pengutronix.de, festevam@gmail.com, linux-imx@nxp.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Peng Fan <peng.fan@nxp.com>
Subject: [PATCH 1/4] dt-bindings: net: fec: simplify yaml
Date:   Sat, 20 Nov 2021 19:58:22 +0800
Message-Id: <20211120115825.851798-2-peng.fan@oss.nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211120115825.851798-1-peng.fan@oss.nxp.com>
References: <20211120115825.851798-1-peng.fan@oss.nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR04CA0012.apcprd04.prod.outlook.com
 (2603:1096:4:197::14) To DU0PR04MB9417.eurprd04.prod.outlook.com
 (2603:10a6:10:358::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.66) by SI2PR04CA0012.apcprd04.prod.outlook.com (2603:1096:4:197::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend Transport; Sat, 20 Nov 2021 11:59:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 69385520-e970-43c1-b4ed-08d9ac1d30b1
X-MS-TrafficTypeDiagnostic: DU2PR04MB9082:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-Microsoft-Antispam-PRVS: <DU2PR04MB9082ACEE0FC3D89D34899593C99D9@DU2PR04MB9082.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:206;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QbD+k6ADZKjF9ql7S7sarwrIEmmv43sroPnB3mZLi9SmkCvXd8UolzQUpqyrq2Yv9ZHuRqo1zC925NoH6NjLrnQQ/qCPCtUT2PYpxYhO1IZOdtsw/HO92cnCMNctQ08U5jVxcS3bYNJo82N9C8u+UE0s2F7IZ5J6DOl1iD3ct0yVfWQTrMcfJedsomX2HceSzAXqXe/ikxBlhT9FaIkv9+xNt1Yr741lQLfuUVKULwKHmjuzn7l3PZAQhpiOrM43s4O73kLp75weFg++L6Ny6vdqLrbQNQW9dMvrYYqkJV/5Kft5bX5uatwDkpd/m+3YtHweb6bDoPtLpqh/FuIvJN5sNuFpL2lbOAKm/7T58P2adhOXTOrAFN929r31rRvlpvrMdthl2poECSMhxGuKQqRxtF6LX/+TJBBy8f8uCfcZRHa1k7nGK6r35fffWqzb8Cgr/Xg9umnbgnsB0ezoxvMmkkQixZtnS8ktn/62f66qUwXQFwSJN3NPvclhES07ZR/S8jNfKAW6E8ntTMZGXrBncobHwzgx6evWPESyaqpgeqjEFdtVv4wCuygkASaGVrZL2vGSiMXTXxTN0eOvfc3B1taPuoylD1bFdoO6CrBnhevqWMa0bpysqSkLecBW4kUamAxRjNI5kJkpYIQ/ihnOqTTF8ol0VipHBhCOqgL09sa259l7J19/w+2aTAwAll4sgQ11p6EMV0vs8Zs4tg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR04MB9417.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66476007)(6486002)(83380400001)(4326008)(5660300002)(7416002)(66556008)(8936002)(52116002)(2906002)(86362001)(66946007)(4744005)(1076003)(316002)(956004)(186003)(6666004)(6506007)(2616005)(26005)(38350700002)(6512007)(8676002)(508600001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?82QqQrK/GzLb3xcglx7A8hGxrxjBUE7uTSgm73KA0qMK1aaisf9F9X28/eOj?=
 =?us-ascii?Q?jwVo0kCV/Zn0xNFoV5RW6T0HIWmao6TNO+f+ugWx/wLET0CTU2YwhcxJrTps?=
 =?us-ascii?Q?5zcCB4sqYSdDcxb+E/qEo7kp5Z8s4qS00WdF0vBVYzyGiXlGxbcG3heH83iB?=
 =?us-ascii?Q?2Lon0Acc/70zmFkj527zOccAG4ncFGVHQDDrWCYWMp6KN6RbtbL6Vn0lbwjL?=
 =?us-ascii?Q?l6Y5F2rgTZL7LgwFrd7P/EMkTpGd+ygoxfQ4h8NvSEQGVfPYppo0gsAeacst?=
 =?us-ascii?Q?EaqFu8sdbwVeFG1JlyMFpZV4W/5NAy3kUz1G4SmAB7P+ZiCU/vjvwhmSw56s?=
 =?us-ascii?Q?eG2V6ZNjE7s3p320vnRyBr0VQd/+gGBbc9TnYCAMTJIGjs6eHxQVfOgSU2qR?=
 =?us-ascii?Q?5w9OWM1TbgD+VMGcoDQE8ZGlCMloZNGCXanltfyonXi+Rnxjv5tcZGZeF+yV?=
 =?us-ascii?Q?2bMLGedEXpcrUSNIzyEmbeJkGGRj1KBU8OtLweoGU2F5Y5LhZih2UyhYLLRq?=
 =?us-ascii?Q?n8o6RHOyj4npJQ7BYNdLfAZGuVTNcoZWa98n5NtCjFDT9tQIeppn1FKcCSYB?=
 =?us-ascii?Q?C0Le2vvMCdpRMSxiiE7MiRt8Ln3c684DsFSgHnU0XXZqRqHdik7sZjdR62rC?=
 =?us-ascii?Q?3vlEau+19zY768vbGQziCW1Xa1kbl/LVFm3yKiUIPT5vSLEz0jGs7mVwPv+c?=
 =?us-ascii?Q?6RY+gAe1d1tRxobdDSBP7CuDXGLalIAxOe+F0PB1Rbk7AWGFbtM166YTFJdm?=
 =?us-ascii?Q?mUKJsTL+cMoLjKKqOtYtDrOKbiNG1Dq1dcAVbFuU9yyt/Pl5UD5mjQ4GoB6h?=
 =?us-ascii?Q?2sbgzEllsj3KPoEWvvJJupgVJurob+BdfYStCFu/6OEhgBhvXkevD8T6/+jZ?=
 =?us-ascii?Q?ranbRaDSVFOHFkqFjpSjxa6fWvolWQ3HBbUYeKWu0HYXlcgnYr58qsT7qGWP?=
 =?us-ascii?Q?SDQp9PsV9BI6iX3CsaNXJeGJW097/MfEdLAtZg0qVjtnbkmcknZXgkkz3o8c?=
 =?us-ascii?Q?NmWIfFo0fvmWmC7GRNflSExy2QvotSHIq8m154nrU3lO+zzLTOwILT785U6p?=
 =?us-ascii?Q?lMl7v3GpADgGr1+mdrJBO5/qXp/CAEBlnpcDxUlkYc4Bb5wGAowpXa4IfETG?=
 =?us-ascii?Q?xQMG+5ceZ0vZHAiI3w8b0ix0O0z0TYaKjV98y9o8z6EtB7npL+3dSBtQ+m6L?=
 =?us-ascii?Q?CoH72jwr7V9Sol0ynkyA3IvUtofU66yLZcGKj1BQh/tI80dwInrdzoDcr5CR?=
 =?us-ascii?Q?8QSJXnWDVquA6BMqDX9r7+ZxEnB6KIhGV6f4oIGpFRJcf/psMLlDWDTWO1Bl?=
 =?us-ascii?Q?+zoy9T4HG9Uc62Y0iju77N0UVqNSbfAW9wQ2iQKF7f38Z+TH1KwCe+2uwv7s?=
 =?us-ascii?Q?eYIKFgyPuM3g2pwTzqxGsM00biPhGFo/Pzy5CQvnRngHC4e8DN3KXfnvSoN7?=
 =?us-ascii?Q?63O2a+96kAlvBLfIpzCgzmr4MioTZ44XtPyLJvbvlje3z6MfB7XmKPFOEvUc?=
 =?us-ascii?Q?bjlTU3oLPOAbgVPRJ86IZyLFG5z57QySOThtAUxFtjMnea2XeruQrd8q8QdR?=
 =?us-ascii?Q?x5unOFnWXgz+V81FZVbSQ3JyckesS5nWD8s5HnbX48hiTZX/MLFshipoi2P6?=
 =?us-ascii?Q?+i2hSjeVSJADL8n5D0aPouY=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69385520-e970-43c1-b4ed-08d9ac1d30b1
X-MS-Exchange-CrossTenant-AuthSource: DU0PR04MB9417.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2021 11:59:22.3684
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gBIXLou8E7LZK40QgL9m1m+2m3YlC0h2W5m+UQ/olKShQd5XRPMBbO0/jNBO4Frx+vrsL3h2cTqwAOU0qUyEuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB9082
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Fan <peng.fan@nxp.com>

i.MX7D, i.MX8MQ and i.MX8QM are compatible with i.MX6SX, so no need
to split them into three items.

Signed-off-by: Peng Fan <peng.fan@nxp.com>
---
 Documentation/devicetree/bindings/net/fsl,fec.yaml | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/fsl,fec.yaml b/Documentation/devicetree/bindings/net/fsl,fec.yaml
index eca41443fcce..dbf63a9c2a46 100644
--- a/Documentation/devicetree/bindings/net/fsl,fec.yaml
+++ b/Documentation/devicetree/bindings/net/fsl,fec.yaml
@@ -39,9 +39,8 @@ properties:
       - items:
           - enum:
               - fsl,imx7d-fec
-          - const: fsl,imx6sx-fec
-      - items:
-          - const: fsl,imx8mq-fec
+              - fsl,imx8mq-fec
+              - fsl,imx8qm-fec
           - const: fsl,imx6sx-fec
       - items:
           - enum:
@@ -50,9 +49,6 @@ properties:
               - fsl,imx8mp-fec
           - const: fsl,imx8mq-fec
           - const: fsl,imx6sx-fec
-      - items:
-          - const: fsl,imx8qm-fec
-          - const: fsl,imx6sx-fec
       - items:
           - enum:
               - fsl,imx8qxp-fec
-- 
2.25.1

