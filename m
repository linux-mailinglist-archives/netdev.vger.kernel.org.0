Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BCC6457DAF
	for <lists+netdev@lfdr.de>; Sat, 20 Nov 2021 12:59:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237276AbhKTMCY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Nov 2021 07:02:24 -0500
Received: from mail-eopbgr150072.outbound.protection.outlook.com ([40.107.15.72]:55687
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237208AbhKTMCX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 20 Nov 2021 07:02:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iMXLw8TRTGOOIwcFw8ylKwQzLpSEN1PPFFbymARxuwzB9fSDQKlId2OmA4eR6l8+6tZtvQzuiKFp19ErfhDGLd7HrwwCuJy3UYnlr29okMLhWhTVZQWTZHaYxq5dJ0nZqxN1C1NCdYhIhzYv2CRQWZDG/DSEBZTNu0CNN9zm7r6DkvUT4K52eXIrdEbIWhCEdGKZuLfIvoG9e0gxdxVbVAtefnmaoIpGmDrbKTVgeo2+orkYXNnj7LS5KazvWIVqm489CVOsIy/IBzj4soRWLloTzY4MiyBNmBBo3MB3eIzWQpusn5Lg1wdgrvV142TJ7sAdKt9lM2eOFBU/OVIDZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AuObwltDZ3wk2rqyWhu/LyWlnJ3hl8PHJ/V2eF5GAxk=;
 b=XEsltkFekxY/zxCnK6SO569yZtElBv/4BpCcIA0kHnU2mY+Z0JRad4S5VD2ybrq8huG00w5Vb/zzI3gia4guZi+TXl43ZfjVTk7c/zXVYXT7EdK9GgoznChmSs36tmh0FMZeX1kxjDSgio1hbx5rUTe1SF/eI+DfGNo+hWQjK+aRDSHDr767SxXhHJGFxGKFUrJU7yhVVUxkVtZEjDTmRjcQG2i2tr+8O0RHuyNkseZc16+WNQGlUh9Hz9dzqPfHWo+3qN2ALN6Kt/gNhnZn7k87o8S+dR810E6Vi9GXpbmi38gScHTMVt3XtzJqlAPyhlheDVePfSO438DFRZBwsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AuObwltDZ3wk2rqyWhu/LyWlnJ3hl8PHJ/V2eF5GAxk=;
 b=KU+Fi8zLuB7dbI6ftMf50HvZrhbWUhGStY3xL3OLHsVXl9eJCcqlV9TDZ8RpKSDaY+4oAkX8Gaxqksbvl6jv19tmYSE1dPhVn4YwM7ZaDdMVbz/BKpucUmZoiqP27GNaHNvKAUcW+4CRvFZpIPu96OU0tgERut+mwT76JhsZAWw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from DU0PR04MB9417.eurprd04.prod.outlook.com (2603:10a6:10:358::11)
 by DU2PR04MB9082.eurprd04.prod.outlook.com (2603:10a6:10:2f1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21; Sat, 20 Nov
 2021 11:59:17 +0000
Received: from DU0PR04MB9417.eurprd04.prod.outlook.com
 ([fe80::82e:6ad2:dd1d:df43]) by DU0PR04MB9417.eurprd04.prod.outlook.com
 ([fe80::82e:6ad2:dd1d:df43%9]) with mapi id 15.20.4669.016; Sat, 20 Nov 2021
 11:59:17 +0000
From:   "Peng Fan (OSS)" <peng.fan@oss.nxp.com>
To:     robh+dt@kernel.org, aisheng.dong@nxp.com, qiangqing.zhang@nxp.com,
        davem@davemloft.net, kuba@kernel.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de
Cc:     kernel@pengutronix.de, festevam@gmail.com, linux-imx@nxp.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Peng Fan <peng.fan@nxp.com>
Subject: [PATCH 0/4] dt-bindings/dts: add i.MX8ULP FEC
Date:   Sat, 20 Nov 2021 19:58:21 +0800
Message-Id: <20211120115825.851798-1-peng.fan@oss.nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR04CA0012.apcprd04.prod.outlook.com
 (2603:1096:4:197::14) To DU0PR04MB9417.eurprd04.prod.outlook.com
 (2603:10a6:10:358::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.66) by SI2PR04CA0012.apcprd04.prod.outlook.com (2603:1096:4:197::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend Transport; Sat, 20 Nov 2021 11:59:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 82918217-75b2-45e7-5835-08d9ac1d2d87
X-MS-TrafficTypeDiagnostic: DU2PR04MB9082:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-Microsoft-Antispam-PRVS: <DU2PR04MB908214671EEAEBC09CC07B4DC99D9@DU2PR04MB9082.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2512;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tQZfxiQNwL9CpDfTBrK4h03FUerb30SO9CLY/QKj4jJpevzZlq2B6njy61dCZz/VWE3goddBfrLmpo8SkBPBJYyBrcXhuXGYTj4nsxOA7B98TCol7xahv9GurxWNXwhF6/nW5VtQObrX/IIZX4VXIwlrmYleSImDSJptnDDdtzPbqi9Y9Imq5606hyvWKecyloGE0NIEZYJcGxo0wdhMEu1jSIfKa9t/WsXlJbWjAp3AwPAh7QXt8/sEc1yGqTpqvgTvZAdMSCZi4ctWrShPXHDW0w4xqrNNFuTkFJzihk7BL8GFInM1VZxsLT1cfG0tL291b0CTRqxbVU/nj0DcHmV1OburZ5Tz5/52Bo0GqrD6MqGpGIQQPnResp00X16d8Xps7p3NthCzSENCp0Qd0Q1bKX99kGVHAZK7dFH7s7T7TExGo/SV1sA3hW8wQko3rp40NlsDpnqgJ8j5y9l4c19QFbyjGlWgs7tdwOJdk7soa+ZYSIhxtPj35pErB4O2PantQ0F0zZ5Xb5gH+vKKHjh/SayMceCtASuZTZgdfWNjZRUAQGV0AGHI2bmqQ/9iH7tjx9/m57rkh8KV4l/wdKxGPqF5iuTAYSWClmKc8Md0FFdFv/N2uEVuNuAxlq2p8MPn905momLGMU4hl1UwvBSVMOnRpMsXcWJC8GMyOK//asTAMsKwy2NWcoZJrkbcqrq3AUCAFT/cP6ELopuer9fTpz81/OJ6QJTZMfE/bITx3Lubcg7R6kYug6gKSFI8vrWhVz3Rfs1z3QBEbhnIB86LMVZ7VEg1QrXdFAlbAqc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR04MB9417.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66476007)(6486002)(83380400001)(4326008)(5660300002)(7416002)(66556008)(8936002)(52116002)(2906002)(86362001)(66946007)(4744005)(966005)(1076003)(316002)(956004)(186003)(6666004)(6506007)(2616005)(26005)(38350700002)(6512007)(8676002)(508600001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iC7A2mpI6WkAgo46CBgc90PbxJOLmsYd0nHdBzbZXFqVNAjTdiOzAOsKURgA?=
 =?us-ascii?Q?pXILw9gfdEos62oO+LPyMcigoXUQTrL8oW1gwY821CgqsmBiWmgKRq1njysy?=
 =?us-ascii?Q?9KvatcMiPyFxHzTDWV420u4cStcd/j18Cvm5XzSUl2pVNdfbDlsqN70OJYSx?=
 =?us-ascii?Q?RLono1zoziJ8VJsU91NvHs030iwzFZtxjcssfDkgBREUa6qxRSjPLoF/9Rcq?=
 =?us-ascii?Q?2hv3mWu79ynS1wI5KMJ7ACHQZAfZTA1TkkXYUkysFcDLEEz80Hbq2bvKbeH6?=
 =?us-ascii?Q?OmKpFvXqVVBU4meKMH1P45PJh59Oa8eD+5e36fMpdYYEWx/pDdx2ppursW8v?=
 =?us-ascii?Q?g33ws5AA7hS+X62Yi8HTq8fYAnq0nK1eBpOXyeq5vCsISRXNfpHrOLk9ztFv?=
 =?us-ascii?Q?+/OnHr3qD4TRvsPJpRsRrZA+w9KcgK3z0i8OeeJMqQTRfjyqOFgwAagbg8Xp?=
 =?us-ascii?Q?zHf8qbjdc4WszZkrXdZfUlAvAJws8EW/l06xgDBEcO42htNUF0P1dc2c1Fwx?=
 =?us-ascii?Q?xYCBxyW84DwLhtIev76hoF+AEChqWHHP0gxY8TZVi+kG+DJWVzdIJqdlPeoa?=
 =?us-ascii?Q?Rvfy6xrRcMA2n/iffD7FCgQc9zECcrlwMcQpLLeYTUquX9+KC9m9frlH1d+j?=
 =?us-ascii?Q?3dGDFoLRA5ZemgGb5ajyE90iBPSnjDNtgj+eSWtbWFhZ5gsl/fYqk2ghH6Z4?=
 =?us-ascii?Q?YRdSXsgfGYaZV7KhUFuuApjNhBR3V/iM5fmWet6o2dcJvtzZcy+ydq7ENl7T?=
 =?us-ascii?Q?mJBF2yJTfy/noS+Mw9Ci1r6uKJPBcF2lz12IyM+jJkbeSxI6bkMLvAEa+rqs?=
 =?us-ascii?Q?6/Z3q3TtmFTWBd/hk/Lpg9Nbd6Uo+3xjLsBi2ryz43Q7jZ17e/RXXokX3R3/?=
 =?us-ascii?Q?xNEbQt6NNsx81sJtodYyKg1smf5fY+cLIWGeMwFxiYAYUeX3MeFI5DH7yf/o?=
 =?us-ascii?Q?hm/2pITiDni3Xh8sabpaTgmcQzojHoAeIxOlGOuxHcKi93eAesCjqH40HtNj?=
 =?us-ascii?Q?7noNACfSke/JvnDMUHgWMzLoB9BSc3OtdfzO9VNKXOPKQvg9TrmBmBWsYe3R?=
 =?us-ascii?Q?C5AEje+/5hlmzlAG7Db1kYov0SVKnQx2ozJ8Z54qkmuIJ4ICrlrJtlK3zZ7W?=
 =?us-ascii?Q?sAinP8/Q9UtQuK3ysbktSqmAhvxeU6DCYbS0SPMJGdCDI6Yx8/YXiHaF5/IY?=
 =?us-ascii?Q?y0KZMY42jqBAl/MbVJGYEyQ6+WDIqy3pjrbvufc7m0HeLraRLvWezPWhP+aM?=
 =?us-ascii?Q?THxOw9KaURVsAXnZDwCregzPjD21cSmI4aD0XsfA3QGDXf62AlbIbpLTuN8M?=
 =?us-ascii?Q?0AbA9TVNcPKaFogsv66ZeuvRxEEngbRbfkwaijbjzG79fK2vTwnVQIIAO9K+?=
 =?us-ascii?Q?pHnF9YViClNmFWMy6f6zrdSEviBMZXFSQOFSJhM1gcCuG0kVbCwJ7V+bGzm9?=
 =?us-ascii?Q?lb3cBrU4dS1dHzzqUc+qeVvOCvbgGtKFptBX4tAvqsiYBkWcdl+KKgVCt4ul?=
 =?us-ascii?Q?gBe2nDsisjESqY69T/XVxsZ2Si7YPJ3XsVsy1h6jE4qyWGM0ciE3q4PXQbVu?=
 =?us-ascii?Q?m3qLpbdEKAemt+N1f1F3GKJ+UgZnnXuCFouzX93P3o0ij6RZIC1UkVE8mj+O?=
 =?us-ascii?Q?zbg5AHezssUVxpP7k+ZjAw4=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82918217-75b2-45e7-5835-08d9ac1d2d87
X-MS-Exchange-CrossTenant-AuthSource: DU0PR04MB9417.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2021 11:59:17.0466
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7dFjpwYjgPntbOU49h8cOVRoL5n92Wq1oi0dpTekHXPNhQUnJff3Wznxq8NUHuWRzyEuK26ro+6jfeEEov8ypA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB9082
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Fan <peng.fan@nxp.com>

Patchset based on
https://lists.infradead.org/pipermail/linux-arm-kernel/2021-November/697704.html

This patchset is to enable FEC for i.MX8ULP-EVK
Patch 1 is simplify ymal
Patch 2 is add dt-bindings
Patch 3 is add fec node
Patch 4 is enable fec

Peng Fan (4):
  dt-bindings: net: fec: simplify yaml
  dt-bindings: net: fec: Add imx8ulp compatible string
  arm64: dts: imx8ulp: add fec node
  arm64: dts: imx8ulp-evk: enable fec

 .../devicetree/bindings/net/fsl,fec.yaml      | 12 +++----
 arch/arm64/boot/dts/freescale/imx8ulp-evk.dts | 34 +++++++++++++++++++
 arch/arm64/boot/dts/freescale/imx8ulp.dtsi    | 18 ++++++++++
 3 files changed, 58 insertions(+), 6 deletions(-)

-- 
2.25.1

