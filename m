Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33FD03C2043
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 09:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231316AbhGIH4o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 03:56:44 -0400
Received: from mail-eopbgr50079.outbound.protection.outlook.com ([40.107.5.79]:11279
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231146AbhGIH4n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Jul 2021 03:56:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HS39AITu1X73fPllmSuBb0IvmzyGeUlK/+Ffg/iwhIZM4QVi9sLvGHwtwp75ONuqzRcDj3RGQRqAPwjg997QF3u5wxcbLfaaCtfJq3+4aj/n78IgpmbMJK3KLhxe6shaf4VXA5IiG8H5gqlO1NoSStc+8pKTdok0ZdgRQ0i/lEZN8kic0UxnhN6hN2zkHwrmFvzDtVgPrOdC2QQGNA+XbIiW+YUzXFhNX9u0MHn9qt8PYXPGC7PSoVBUU2UrSeIv3wU0FIZtEXloDV11ujSbpchGSLyqj8Zde/RDoJ061Jh764iOJkEsJ2co8uLdkv+ZT71ikOFUFfmz2ZKwSIyF8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zRm0hj0wwoznHzCt/t5M1rx1J4ZzJ7URN7nOfFYV2Kw=;
 b=g2N3DpPQo6sW+PBv0EJRqGQQ2wz1xX0z/xjry7hJ+/VhwW76NuK9wmZ9l5P2zsBW41xNTMjM34AnRtHFJ8V4uJGKYW4Wci8s1E2T/IHtXSnQPSKWm/kNgevGzGRnERJDu5y6MAllj8HAG1dP0kDYOgDTVLmIClfK9Zf5evzabNdRmK+N13fLHEYyVKiIwhZU5jQ0HMyDpOFN9d2tLBc7F400rGk3jLJTkaaUV9CEmZ9rQ0AxcOf7fYVddM7ufcbpV1OwZUbq+dVsUorDbr3oqLlUlz9gz7bKheuAoM9SeMoPPiif6R9qByGHTy6639z6/B8FFjzvNOaN5UceCQv9gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zRm0hj0wwoznHzCt/t5M1rx1J4ZzJ7URN7nOfFYV2Kw=;
 b=QVtDcx1pYEHVip4CXKitja9KQo3lnDA/isLs/Z2jG+UCIOiZagDZ9gwmbD9Eh9CAzrHEnc/QTMuEw/EvDerUps+pu1YH5h1E6o9ZZJURc7C7F0qMqxTXyp3JecFIxBrYNU76ZcSQMOI2ML8ibPq42ZRxL7j5hTJPhavAvwVoxnM=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB6PR0401MB2502.eurprd04.prod.outlook.com (2603:10a6:4:37::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.22; Fri, 9 Jul
 2021 07:53:57 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802%7]) with mapi id 15.20.4308.023; Fri, 9 Jul 2021
 07:53:57 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        andrew@lunn.ch
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH V1 0/5] net: fec: add support for i.MX8MQ and i.MX8QM
Date:   Fri,  9 Jul 2021 15:53:50 +0800
Message-Id: <20210709075355.27218-1-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0147.apcprd06.prod.outlook.com
 (2603:1096:1:1f::25) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR06CA0147.apcprd06.prod.outlook.com (2603:1096:1:1f::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.19 via Frontend Transport; Fri, 9 Jul 2021 07:53:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8db556aa-73c4-48f7-a3c7-08d942aeb4cd
X-MS-TrafficTypeDiagnostic: DB6PR0401MB2502:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0401MB25029CEF6F3EF8B05025A345E6189@DB6PR0401MB2502.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sW8LwEAQfk9XWg7M7sqtRg564n920oBQT2a0/TlIveCsKyMFBQ2VwYSJlU0tIUN/w8lyaWbqJ66mX/jR9j1/6VMRegbrsgkY+u7rfnrCO4A6hvN2PPTP1Ybxqn6nhJaQXGFxPTWGXinU3HytIOmqvVl78YcgjVMhwP6KU9Y9zTU2qvQuEfXipOREy9qpn5Fbui8prCnkQhetnMD0+HngtGjirhGjTTRTwUKoBAysnRoH7Nzt5Z0Uh4xxbaG6oOiJiR1ta2Dx8XaHcL4/h9I/F+m8QQZMDGfINjhYBOhvGPtQw+IH0rYDjbehf6NX6cY2XxVbR50dpsjR/RSuWKgItYqI2eUe3kxZ+FNWlkax3MXeDiUgGyxAMbQwZ0FpvwxuETK1PuqOWmr8Z/ZXFdFqMT4eIjbnm0QlAgn8c01a5jo19UkzYs/ZMpBe4326nYJ/P1zueCewB3kWPNUIG8tUts8qfzj+50JjJ0pZeCCpdOK4Cj+Wf8cuAG1NPAOeezJ0Za6E91+ueAMSigbYPgs2s2jLaW171BHUnO5vUq5RF7TGHjyPONWior/CZHBmScLwOcir4f/+cZm8U58Dj+uGBXd9nSAjSgzqr74ODKlK0rEuViKiLIjE0+Eoal4NGghM3qfKFhAqRhxTIYe2SmAuaWgywHYtQkdRQiQvB6FWAuyYLRWS0U0e7tBS5jN7KxDxzE01PjrqbQslozjmo2Q99Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(346002)(39860400002)(376002)(136003)(956004)(8676002)(86362001)(2906002)(6512007)(1076003)(8936002)(4744005)(83380400001)(6486002)(4326008)(36756003)(2616005)(5660300002)(6666004)(38350700002)(316002)(66946007)(66476007)(38100700002)(52116002)(6506007)(66556008)(478600001)(186003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aU+K9SDMhL7qgMgqOB/npXTeXKIUnHLH7vlm7NX6AOijHsHYTvtGfPt8fViL?=
 =?us-ascii?Q?m5NgIfm0ASV6VWC408qCpSSEW+ApvpbYVuNIS96XgdYuC9J5JNaROWc1jdQN?=
 =?us-ascii?Q?J/ZV4/UB+sm80G25kqxDCdmaWHljZ+5bX40u36z95eycvBBHGuiUWEk1HmI4?=
 =?us-ascii?Q?xg/1Z40Khi6AZ1XeMTwiC0ZgqNsSjuLCCHojtyM70N9HjpsAPnxD2RtgJpkP?=
 =?us-ascii?Q?uYtKaBxfOh8A3xUgFmm4ZFuKHuAu2RFJuHgh5tUdH1Zh4LeYxtvf0siKhLOt?=
 =?us-ascii?Q?FxuI2dGxs91vuNW1IC2iuhYdjOyOz0gEuN9jPf9IAvccXsEG6SXXh3Bf6j7Z?=
 =?us-ascii?Q?1icbyN1AdU8/h/CzMim/nu8YqJQcoc2R0tJ+zYcIZswsTNfg4yByqc3xgSF4?=
 =?us-ascii?Q?fHiqTG/eQOaRd5sdNhibNqWnz013qnIw9c8w4b4VqKDSQYmIyXwHYclxVdtk?=
 =?us-ascii?Q?GRuLM4dsM2nXeAZx3pb21ulfMttsmitRuTfcYlcJNaTGwxhQj1UjMSBpd9Rg?=
 =?us-ascii?Q?nSR93PJLlyUJCQMdAh+Pi/T9ijI6AYUxzbr40HffdeNF6QGpH8Bh+difibc3?=
 =?us-ascii?Q?xvlTQZQ2fnKiT4xrASGBSXcRTGYLpX/QGLeS91IYL+vQrH00MVal8A4+lQmP?=
 =?us-ascii?Q?1GgPoRSozW/MMofPcsrWa179QEei9NbhdM3uECvMMTFiEgyPUB2GFYmYxYPe?=
 =?us-ascii?Q?NI0iwceszNl/CCNiJ0ejwEnz9Vta9YCB14CS6X+0TncFR1RVG+tBKBhtw+Iq?=
 =?us-ascii?Q?eimIqbsOklWZClIiRfCO5QIQ3B+BUPXj2Fq04RFsbDcZzAoUTTQRgHl5Ithp?=
 =?us-ascii?Q?r3y5+eUA2E4cB8nNKmJZHI8h2xVGP9ExqJDqbvjNDOFWplqoxmBUkeWLELEk?=
 =?us-ascii?Q?5h2nV41nBBBD09qynYI/tBKVFLFgyU6jUTZ63H+Y7MVforF04nQraVJ0MfzI?=
 =?us-ascii?Q?Mxn5uq8l4X+jMt/kickW1vT8cXfhCt2CWZG6mbGhT0qsyELQOes69UJ84rgu?=
 =?us-ascii?Q?SkIBsax7Jo2K/TJ0Rf6LBteOfHn0eC1i7RoTD/qJK6PTc5SByxKCpe6icvTn?=
 =?us-ascii?Q?L3YXrTskrBKJZqIMlnGfUwjKnAUlYsRaLQn+8brAsfIesjG/TDwq44JS2MqJ?=
 =?us-ascii?Q?atDzoqDgNT+/GJn5aI3YO3wwI3kQRvPsQ51Cu7B7TQxQZJJrSyw+rRWOq9Z7?=
 =?us-ascii?Q?Te1uBQUt0hrPvwUHUilPLO8qhU966HEA52KNOH/B+NP4ozv1lWLXDiNvjEls?=
 =?us-ascii?Q?Q7N9T2ZNNY+POSN2jfJ3pXG6Ju9ECTonTNxhgHNbxIOTQKg62TH9ORs98FE6?=
 =?us-ascii?Q?lFtfj/B9SRFOnrPmUhO8GyyK?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8db556aa-73c4-48f7-a3c7-08d942aeb4cd
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2021 07:53:57.8109
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: crg12CbysOhLEKHLxAM3mAwnQPDHXIPLFp4FXUtxmAjew3KDBFO2Dx5BZhb9IWMWdWqMHzLODtcOmtMMA45Ccw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0401MB2502
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set adds supports for i.MX8MQ and i.MX8QM, both of them
extend new features.

Fugang Duan (5):
  dt-bindings: fec: add the missing clocks properties
  dt-bindings: fec: add RGMII delayed clock property
  net: fec: add imx8mq and imx8qm new versions support
  net: fec: add eee mode tx lpi support
  net: fec: add MAC internal delayed clock feature support

 .../devicetree/bindings/net/fsl-fec.txt       |  15 ++
 drivers/net/ethernet/freescale/fec.h          |  25 +++
 drivers/net/ethernet/freescale/fec_main.c     | 145 ++++++++++++++++++
 3 files changed, 185 insertions(+)

-- 
2.17.1

