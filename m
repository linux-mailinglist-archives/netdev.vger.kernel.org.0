Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F4112F1195
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 12:37:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729709AbhAKLhF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 06:37:05 -0500
Received: from mail-eopbgr40076.outbound.protection.outlook.com ([40.107.4.76]:22789
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728731AbhAKLhE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 06:37:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KUp4nEOk0/gUPbe7kId/inOB/DwX7TDD24v5pXLwnNrG6sAGsaC1aOKQ4Ah2XmWN9qLUCbJtlyu43qrVVgZgLWnJnUbHvGNNR7ov0Dz3h0ZIdxSrKgzQ/IJ0LdUNTIDunm9unoXMXp3l+DBGj/sCZvgmXUx6FvzQKkBe1ZE2QLZyGjqRlJ4eqg5Ixmm3jLQOHxrv3kbSiG284rNRvG7KVX5FSWkjsVyWRiR+dabod56H38enMJirSx7/BcA34wAxTQWr8xecGagHEKYsNCbnCjhzUOeRwxnlYweKPqYaCghra7xyN+gRVZb1Hw5ZqzQkUNTu2TEzkdL0j1SBqKB4jA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AlzVO8Kt0ONplWOoKEftUU/8LQUqBUYNgLcHBysvSNw=;
 b=QG8HGXZE8BDElzPVynJeRVlhtO2GEs0z2vr/S2vWV1sZ58/t09nwu4JvGDzGoBhlIdDonKGzLlBcc9JguktGsa2DUKbROVdank3iGG4I/oq5B2ZgNB//Tj6nuVMm7el1Qajk8cc/1S7ocw1WlIiupQjTRe2Scuv1lXgVMEozZY7sFVmTh70i26d0Ext8vjfsWK1wvh2JOYcBp0hx044oZcCvMqFyCpJ/XAgxi3lZBW41GJCOGhU7saGiNIMpsKWjYj5KpZtW9Wzxev3zNxjG6tDQ6ftkrjHnuwYh5rE/zNWQ0Rt41QtiRbBVc8BdVx2kF83yiFN7v0fAT38BFugDPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AlzVO8Kt0ONplWOoKEftUU/8LQUqBUYNgLcHBysvSNw=;
 b=h2S5LqNQw8tv6pWJv+9S/puKZ1pN6K9O+LqfmsURccfMLlliPRNVD/xeGhMErSlQmYX3EDhHbd9A0+7+91sQbAqR0HWhHExAASk9iY2CWiXEWTccAcQELmc37d1SOerYLw6v+JhicVOVlH6PrDqgrP4AgecLCBO1v9SDfBkn+Lk=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB6PR0401MB2326.eurprd04.prod.outlook.com (2603:10a6:4:47::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.12; Mon, 11 Jan
 2021 11:36:15 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666%5]) with mapi id 15.20.3742.012; Mon, 11 Jan 2021
 11:36:15 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH 0/6] ethernet: fixes for stmmac driver
Date:   Mon, 11 Jan 2021 19:35:32 +0800
Message-Id: <20210111113538.12077-1-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR0601CA0018.apcprd06.prod.outlook.com (2603:1096:3::28)
 To DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR0601CA0018.apcprd06.prod.outlook.com (2603:1096:3::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Mon, 11 Jan 2021 11:36:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 18a79402-c934-4be0-a772-08d8b6251ac5
X-MS-TrafficTypeDiagnostic: DB6PR0401MB2326:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0401MB23267BB22D426AF8478C3BA0E6AB0@DB6PR0401MB2326.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2089;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2XDLpdiO8WLlnBovzf8CN11HR2KIhc9ww0nI14Buo8DC6vkEf4Sb7SQVc03YsdakXqFPlhc128Z5wryN2amJQVQTKCym2UVwg4hEAxZslEB+NDRU+xo5EP0wRi8U3MV4nmYQyYqHD4rxEv/LkCWhgC9BvRRgpezQ2X2IbtIWkKbdGRGAc+ijOekMlu7B6RtUg7FNmNJSCS4lgo+VT2+VJVmWQ6UpX6o33BBbCJeX/j+4gIATL5QtqrjFlUwQCKg+QM8Ez2O1p/YId+lbXaKB6lQB54uyhuTmuWGfL/cIwnQ0GPJC4jGF40yYkF6WNQLmnWzHapX+2czieA9y8sphj1xBHO2ox7Cy9Zlyunb6qmzt5IccfyoyU4PNppMu0AM2kvOu+UhBgUwa5srM40GEE3DNQgj0TEn/Gc3ImYC+r3goSTaXbmjeQEq3JFH1O2nwCvQ6OdJyShK/r1xmyvaNzw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(396003)(136003)(366004)(346002)(66476007)(4326008)(66556008)(8676002)(4744005)(86362001)(316002)(1076003)(69590400011)(6512007)(6486002)(52116002)(5660300002)(36756003)(478600001)(8936002)(16526019)(956004)(186003)(2616005)(26005)(2906002)(6506007)(83380400001)(6666004)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?oCtmh/HzgVppzOtkCZgno8IOA+CW8DsvCQeNvFLcthiD2xj4kqpxD1Kh9QsC?=
 =?us-ascii?Q?X7akUytyN3ilqXKPofQoqszbS6gzUpVKoi2FWdqtoEC8H9BWqzaJzJezXg/s?=
 =?us-ascii?Q?XIZl/s5Zk+Hi+IGP40Euxmau6xrNQS6yMDkd6bxyMUhp7hRl+wZbtnqDME2e?=
 =?us-ascii?Q?XZ4yLK1IChyZz8VC7YqWpXc2w54K+Fm2TwRsjSRi8leI6GzmPkrj9AI2G9PK?=
 =?us-ascii?Q?aebV5z3mW/ZH93qOOZKYQZC1CP1MRF+wdCShoRaajMQ86mjpEEZcQFZFU6AJ?=
 =?us-ascii?Q?bnQAbaY2dQcHnCzVugAneiwTPwYDzwcizyKPxFLtPDIPzM3xJHvz91kniegy?=
 =?us-ascii?Q?EYDkheVGiM87wQnultULlby8Hw3MbcV5btYcqv9KLzh1Zczg+oDSLNqL7n2Y?=
 =?us-ascii?Q?20kpHoREwAg/pRCCSjkiR2m2oqpgy0RD8ZFcasPtBpjAMdYJUFzMNmY62dPA?=
 =?us-ascii?Q?k/q2qaeVKNlrw2ns5+vDJ3bak5iaMTYulf6M9Wx0pZy4Mi3hEMkVmJV0oW3W?=
 =?us-ascii?Q?fcjF92RPkOktaFjCv2K35Ly4mkellnQYFvCGxYZyXX/KRfim4pur1PyFNioX?=
 =?us-ascii?Q?vdu5bBKxCO4mEwlRGx84cXUX9pYPuITwqC3td9xvuQpUMIBwjx6tEJJnEkPO?=
 =?us-ascii?Q?PguePuOXBECBJPsjtRwy03gwJz8O4GjMHwQ+d/3ARPbxIQQGEDxMRVCDQktJ?=
 =?us-ascii?Q?wJ8LYlqVrUwC466b2tWC4sgpU0QqFct3ER5Q7tj+r9yzRLaaNyg7NaN3AS8U?=
 =?us-ascii?Q?3upOilvJ6S1d0tadtIjMUZ5lrvD5a4SUZAQGn061kY7LQBA60N/rBi+WupNb?=
 =?us-ascii?Q?DW0Pytc4sefaEkz1BdmlOBz9EMt35GXHHANUhIHQ+WVyKznWVAmYMP9mEfG1?=
 =?us-ascii?Q?oGfmM2YMsSO807avXve//bT07Np62P3A5amOOiwH79Yorux6SELRjSJf5sp9?=
 =?us-ascii?Q?WF/bKrjPIfC9UMCur6XJhx3+mi3LxpmAYAdHzFMAUjW6CbK9VIqUY/IMnQvn?=
 =?us-ascii?Q?aYWD?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2021 11:36:15.1434
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: 18a79402-c934-4be0-a772-08d8b6251ac5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hGxqkttaFkE5Gz5PEAiv7rxwnhnP6pAN/aoYyaG29uzuD5KU9ancOs3dQqL3JPScqNlxS90UjlywIjo0p/C1ZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0401MB2326
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes for stmmac driver.

Joakim Zhang (6):
  ethernet: stmmac: remove redundant null check for ptp clock
  ethernet: stmmac: stop each tx channal independently
  ethernet: stmmac: fix watchdog timeout during suspend/resume stress
    test
  ethernet: stmmac: fix dma physical address of descriptor when display
    ring
  ethernet: stmmac: fix wrongly set buffer2 valid when sph unsupport
  ethernet: stmmac: re-init rx buffers when mac resume back

 .../ethernet/stmicro/stmmac/dwmac4_descs.c    |  14 +-
 .../net/ethernet/stmicro/stmmac/dwmac4_lib.c  |   4 -
 .../ethernet/stmicro/stmmac/dwxgmac2_descs.c  |   2 +-
 .../net/ethernet/stmicro/stmmac/enh_desc.c    |   5 +-
 drivers/net/ethernet/stmicro/stmmac/hwif.h    |   5 +-
 .../net/ethernet/stmicro/stmmac/norm_desc.c   |   5 +-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 136 +++++++++++++++---
 7 files changed, 134 insertions(+), 37 deletions(-)

-- 
2.17.1

