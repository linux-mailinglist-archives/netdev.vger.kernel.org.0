Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2D4C3C2049
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 09:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231388AbhGIH4u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 03:56:50 -0400
Received: from mail-eopbgr50066.outbound.protection.outlook.com ([40.107.5.66]:8519
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231367AbhGIH4t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Jul 2021 03:56:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O+iR79hYndCF6bBuc3TvCR3tXfe8iFEAGPVrjFgAoHzNRpp3rT769aeksTNK9mEKr/lW9C2s2EWcM2IPkzaumNMb3dzhLW1k4lJPhUMg0j18QnGIYrij5IG2V0TBfAqpGTmsQGZBT1N1rxvbymrtyqpHQ1x9Ifqq9WTVlUarz8mCsD08cMz6Su1g4z92kACJQFzrsxxTeKo7pgSnpgwODQLK1Jg7lQqcM1FjGUnwgYEIkfVe7HaBulfc0PORRBMmoLNFbltE3gQ6xn7g7TblJK2ALDQRJ/TI1yMcxkSg3bx/0N4MLE/OA/oWbqXphbGyPCEl0olfEz/96H7rarftqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ke5/7c7ZfiREk8dq3+OmByrM4xqkPJ3/1VXAQItaDTY=;
 b=jowbaIxuekVBiadqypxb2Ba9MsO4xN311+mUuH6g7VTAzENnhPeyTWGhNW3SSpJ8skSj1bKbUhh4lC/TUUV7dbTcphbLbSFi6WlvOoEinawrVQuJI+IWtY66I9ynCvNI/87fKHMORZ6NdOmVKLwt05hmG20zKqybigjchF7s4/CsLyjLP8RA0+YVtXW5+FWUJJ5JFzHgc5xawWkNSMcCkNEjwPZQgXTiLaF49v423InoqDAeiUhHQ9CEeZc4H1vTn3HoNDZbSUCKbgZWmhL+nevzN3sVJAhI+1cvQAq4Mex67IfeS/Xs64262mBRcFC+iP6RzjmTpIHJFjjuphfSnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ke5/7c7ZfiREk8dq3+OmByrM4xqkPJ3/1VXAQItaDTY=;
 b=CFduxrJXzgOmQn+ag5Dr/P0e3dNDdTu72BM+u9c8P0H70Cv+vjP5LTiKwizr82sz6qth90nsGEz9gM93K8EPdSl/ZFDz5kboGfpXnERfRAOLXrb+czGVYYG25nMklB/0JjQ2pD1KjXx45X9GpRL3f1L+KPw41zR6FLNG9zSIrMA=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB6PR0401MB2502.eurprd04.prod.outlook.com (2603:10a6:4:37::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.22; Fri, 9 Jul
 2021 07:54:03 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802%7]) with mapi id 15.20.4308.023; Fri, 9 Jul 2021
 07:54:03 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        andrew@lunn.ch
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH V1 2/5] dt-bindings: fec: add RGMII delayed clock property
Date:   Fri,  9 Jul 2021 15:53:52 +0800
Message-Id: <20210709075355.27218-3-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210709075355.27218-1-qiangqing.zhang@nxp.com>
References: <20210709075355.27218-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0147.apcprd06.prod.outlook.com
 (2603:1096:1:1f::25) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR06CA0147.apcprd06.prod.outlook.com (2603:1096:1:1f::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.19 via Frontend Transport; Fri, 9 Jul 2021 07:54:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bf827d59-e31d-4d8c-0c32-08d942aeb86c
X-MS-TrafficTypeDiagnostic: DB6PR0401MB2502:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0401MB25026823AF1E719D5EF9003FE6189@DB6PR0401MB2502.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QOsMDg/xgheaPyJz/qGmyNhu77yZ/Ydh0YSTaj1Czn3LiZb8TqusJtiaJ05rzgNFRWo6X/O/rQnd3laKbK9c+qGteJjQt7Jp3yRv7zQ7v/a/Ra9IzhhrxQjm+QtDPJz3jx2h8dtJ3kSyQPsAsfpym2/IeBwUJxtoRxUMQS6rifFAVBehweXiKlIAuNQXk5qzCKMyp3SZjN7qiDcl8HNr47u9HCY/MSajOo8aPXUjNnXcHqg5I+52D85l7QQ9KdvY/u3oUPwXKlR3qytzxKhXUwP5ocN0zerNQUaPMpGtsVXH3xx+r8VfGoC6I34gZyhEQE1w9OCv3Xr1wxFhXCnmIK2KtfYMCuVnKfSqDg14CqQdVvmDUuWWUepz7rwk+PgfI4QNsqBQzF8VcfFKPxEn93XIyL/plSaVtjutVIpQErhbr78X24E1QfLomB3rgOYQLIYqi8daD4ar1/J+JwqWoAptCvOg3i45YiT3iyqoXoIpT52+/hsEDfdBGDjjIMJBQuHDUJFxHzhD771yfhocXXTqOLz01sHnYKvo+syfx/rVHkluJUBoY09o6DOqg+QahpgFgoFOlx/D5QHPQhp6gLphCZh6uM8+ymBk2onS1Qqe9qsSdUNdPp7fq+S4VEv6wsGIwBEeTAmx0/HQGdgrZrpAYWl07xVMSe2yYM4o14HBYwoRQvrmJiJXNNB05MBJlNqNr42MZccqGaKIfRkU1g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(346002)(39860400002)(376002)(136003)(956004)(8676002)(86362001)(2906002)(6512007)(1076003)(8936002)(83380400001)(6486002)(4326008)(36756003)(2616005)(5660300002)(6666004)(38350700002)(316002)(66946007)(66476007)(38100700002)(52116002)(6506007)(66556008)(478600001)(186003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+2Afkm2uGeEC15l9yw68CV2uSveQ1gWz8Ft4zx7OxIyA7v6FdM2k/ntvPtP4?=
 =?us-ascii?Q?ANi59dgW7ZjyoEY2PwhynrZCieUNNt1A6rS6G7PbldDNpRV5PQ2GFUVpI79u?=
 =?us-ascii?Q?5WTboNguArtnFwn4GXF8fZ/jv5Ie12lvkqf68aHCCjYgSEA97T8lWSNE/AIt?=
 =?us-ascii?Q?YCSpfKHz/D0EQjEq7+xn1TXs9p4IBiItusa0O63938W4iZBvLzNkFHfJsioi?=
 =?us-ascii?Q?3GU5lZkhL/Eu8IsOf7bIEHR6l3EgBmkxtCqnnAoJC8NfVxRUBOf41yczwP3G?=
 =?us-ascii?Q?eJzA93aUGrkpjlvV8Lsj9sLK8JRvp1XZdhzYe0Th9dEQt9VrDe+yjvvNdQlR?=
 =?us-ascii?Q?IWumAunm9BJ7wAarM1oaEdkF0rbDzcDEZTTSvG1hshbhK3jxLlTwvCQ/wQ9/?=
 =?us-ascii?Q?mLnw4eGrhW1NY94GsDuoQ9x/EvWzIWrj+C7399/3KEEz4y35TSVdfcW/nico?=
 =?us-ascii?Q?Z/Byug/AmRSy2yHNaNb9v+wYPe849gY/tjXNy04ZBDp4g/xwT2VCZ7Lcblne?=
 =?us-ascii?Q?0TTSojZyksl5kk7wFMxsGNVDsZK43MVUXdVZW5Non+8E6RS5LtjGdP5tmQwN?=
 =?us-ascii?Q?Mj1JDeVgNpB45CKtE/jgiTrfKG30XZ9/jg7XHVqKaOTvhdw/7t7O05hzJpcH?=
 =?us-ascii?Q?vNST5EytW7ZKibWNtr4Ng5Pf155fcKiX960xMkOYidQdI/CUvkuzHpVl288y?=
 =?us-ascii?Q?SxdUr4XHwkKpY2C6SlEDGxY6kfNKU0sSGN5CG1iqtZwS07+GqY9HHG84EUb2?=
 =?us-ascii?Q?VM9TSTNtveu/ZkGRqtfPQkYBar8a03FpymTiCorUQd3ViVFgmL6PARS/TkR3?=
 =?us-ascii?Q?MQEsDfmadoea4OKPnrlWGV034p17alkFFOV3FYGgkSUzeNtI4UDrjYMGLIHo?=
 =?us-ascii?Q?GYCWljjs2ExIw6YXDFkHFjOAK760sdKPtFz12dVlXy7eU3Y3OughnuTTZf53?=
 =?us-ascii?Q?xQNZISWgTWDgie//w/ITKH+1MW1q4Y7sGfakNoGXNLCM2X+OihSAEXDmJICd?=
 =?us-ascii?Q?ZZC3CHPpdKTtXBHGpb3kncUwRA2yxo3qOMypShHG+faRUK1TF8keSJHWuFJY?=
 =?us-ascii?Q?XaSnpkUsABjKSPiEW0m7EaYpkjxFHCAtMMLgy2PdCDBbVKF72FfIg6u/qW9L?=
 =?us-ascii?Q?Mj3nwjHvrZ3RGIeSy4oBSETSxsQAzqdYkxYZcayQ2hqC/Toq0ft4G9Q/TX8F?=
 =?us-ascii?Q?ea6dRWnWfce3OxWMwpAi7fPXOusXO4DLGDoKRojqUEkL5C6Ba4ZILWz9VWmD?=
 =?us-ascii?Q?0P9+XYcVsMs557TyfmJ7+J/F8Pgq9AwdH1o9ptTXxYVahR8mzoRN4U/QJQUc?=
 =?us-ascii?Q?mQ2ntupakbv421vnWxyNLt3L?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf827d59-e31d-4d8c-0c32-08d942aeb86c
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2021 07:54:03.8543
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wiYBy86Tr67QPgPAJ1qFG/jmndrRpki5uPqnA2T2FtRz8Wl/BxKnhgVsaaEZq9GQofqg/ES2ZTfKRmUJTDWxkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0401MB2502
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

