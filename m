Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15E9B30F048
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 11:17:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235330AbhBDKQV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 05:16:21 -0500
Received: from mail-eopbgr70072.outbound.protection.outlook.com ([40.107.7.72]:51078
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235409AbhBDKQN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 05:16:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eD+SWH6+CtMejhqN03AckiFWcqveCFjK5v7/KnG9gKjkeNN4+t5me6gOiGr9NqD5WCRsX/fQXtWTbXWf104LM4fCumdvgNlnB31P1SugPFVRSTtjTx5ow+uTKb2HkYhFydO88+g929aVZMRZ71XU6J6hWkapVhrQeT73l3Zrxd51e/uYiw7dKGamVgO5KqM65kmbuDbMhPfT2RG3AyHcB/eTCpGFeqpsBMVeWCM7EYJN0FdPOtNsKAb7Zx+GaK6bFC/007Ekt7HaG0gaNahZztkNNhG8qqigrmhJq6sM5kI5r6RcHiL17HO43ITFXyCVuYO5Lgg5fGxpBSqjieiahA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AD+fejFm1WPXbV4ozoBXoBNGaKDB9A57NVHwYlh91S4=;
 b=FTSvG0us+7xMtfzz3GeTRXGisVsz9TVfoYk/6/ligiFJEAHCq55pI7TJ7boGz/9kCTsYcar2zhK8UQVL2LGHhpVyj9JKeb4QQ7NF1HK/YhiNy75+Woy170QklWWNQx0azjYZSRy1iMK6PBE7Jx0xzXBaSz/Xk1Nbv3guWmvN+tegtsZXqLHjQ2KKSvTajuvRBSdSwTsNbYnLogsg7zd00p00nNQPf3q7LJZ4psLow9qmIpBjbm3wvsmEFz1Gwiy6xigwq2GjW1qdt0r2iMyuoPBNHZyyf4JA4QeJEGwXYqe0MmmoXgMNQFTRy7bpIEYKoMh8fO3rchMpgrwFAwli3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AD+fejFm1WPXbV4ozoBXoBNGaKDB9A57NVHwYlh91S4=;
 b=Cb6ePFrPcxwdxc1cjha+3enAnFsqhp46agGk7wPGqH4v6AD613fw5xebCJwTAP8bTmEnV1DM9IwTHT+6oOU2ojr3cBivevTX5yMwNQJg+v3Rq/D23KSpjEQfTH+af8HoFWyIgNJ3CwBHehFWbxE3SgEidwXTsNHWzXM0UVyUVAw=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB6800.eurprd04.prod.outlook.com (2603:10a6:803:133::16)
 by VE1PR04MB7407.eurprd04.prod.outlook.com (2603:10a6:800:1ab::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17; Thu, 4 Feb
 2021 10:15:24 +0000
Received: from VI1PR04MB6800.eurprd04.prod.outlook.com
 ([fe80::6958:79d5:16bf:5f14]) by VI1PR04MB6800.eurprd04.prod.outlook.com
 ([fe80::6958:79d5:16bf:5f14%9]) with mapi id 15.20.3825.019; Thu, 4 Feb 2021
 10:15:24 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        willemdebruijn.kernel@gmail.com
Subject: [PATCH net-next 0/2] patch for stmmac driver
Date:   Thu,  4 Feb 2021 18:15:48 +0800
Message-Id: <20210204101550.21595-1-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2P153CA0032.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::19)
 To VI1PR04MB6800.eurprd04.prod.outlook.com (2603:10a6:803:133::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2P153CA0032.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.1 via Frontend Transport; Thu, 4 Feb 2021 10:15:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 69ecbcf6-1564-4b42-c52c-08d8c8f5c92c
X-MS-TrafficTypeDiagnostic: VE1PR04MB7407:
X-Microsoft-Antispam-PRVS: <VE1PR04MB740755B3680D5C1B5FB36E74E6B39@VE1PR04MB7407.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Mf481DY0pUBuITbzHdp7Hw3iEdHBn56ff/dAzL9h7K2OPLwX4viNsTkNcCixgIOotooaZiy+YOtmuJL6FQHghNXK4Hq7hEQ2G1GMnCvkTZUGYt8J9Akrx2OgWnaSAwXACk3PRVehSmvcuhH3rzsg7+SaqFeZ/24q04+7Y8Kqyh4dMfD4LkgcV0BlmsWbqcgQ/KGmJyEODtHridPoYoTqklVsIMm5ReYYbifVD6jBf/47SB2hRQ1zuIQR9SPPOhXKTyU5QSvYXYNXtwapzJVUpXpzi8RcwXXlXSTt61ndJzr/ygjMqRcOZ6q7QiThqXGFVUW7N5PQO+IAbc2r7+ScTilA+9/x8U7e0C7ybYLGPEttPb2g5q8KUu6welzhb78qmUBZfOeCqv+lZzbMyRgJfuGEfeKPNqXkXmaB7v+oNyouFEa9+zlOOwsmJvnOoeUMb/UhReKAWl1h2V5bxMMuWP1qgMbRXYdj44L1iRV0/ohA3RDq1eJiwoMstV36HvDAJkIWhTTTBj7iWQ69zw+9p2c/07PrY9c0MM0qev/EeAVt3w1KjupIyeZJyh63mjKBC29MpfMCaR4dw6v9g+V3HQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB6800.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(376002)(39860400002)(136003)(366004)(16526019)(186003)(2616005)(956004)(8676002)(86362001)(2906002)(6486002)(69590400011)(6666004)(83380400001)(26005)(8936002)(6506007)(36756003)(478600001)(5660300002)(316002)(66556008)(4744005)(52116002)(66476007)(1076003)(66946007)(6512007)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?wAECU4mPb4bGJfhz28ZGiAEWjkjk1+8yH8PKL2ZWmoFtZtEVcPiRXcjP3aZI?=
 =?us-ascii?Q?5BEUfke4kVEg/0cKLTMAmOZtttAZitUNLnTuN24jaNFLZa7j0s56J2pZlpmI?=
 =?us-ascii?Q?eeEs5GW9BAgTVJRCl6GptWEXrU3RLH2GtkWZ2zDRh4b4A9kCRiqsDAhg0LPe?=
 =?us-ascii?Q?B34+wMqJZ1ReUNWLsFMXI6OdWp3DQYbgv5ib4dWGO4C2IcVsB13SFRfykZ6+?=
 =?us-ascii?Q?/dUbDA40fElHxi4l5hCgyS3Uv5mtP2wOkaNvqNUTCQo7i/VZQ2hxiITvdT7k?=
 =?us-ascii?Q?GgYSbhQ+Av/1QA62ubSrFvz9iQ/IBrksk+89l7KWPLn34OhSoHgd3OdcBXIu?=
 =?us-ascii?Q?Tk0N4Lw1Kn4+hVAZZcwHJaZrOuRMqDqyb5veV20wdGRLHMBpzlqM5X5Vd8gP?=
 =?us-ascii?Q?4unI+6vsKJbn7MeyJUypOEUYFktxrjWd+QuZwc60CdRfeHaavLYh/Vx2m0h/?=
 =?us-ascii?Q?x3V+Mxk7hTdBrbM1MpRK2pD8zQWRdvMrCjZPtOWny0FOn9D+0L8Hw9f7cs+H?=
 =?us-ascii?Q?6FBpUA3grJWKMkAlpzhDI+Q2M5yTFqEVAL3fTfD0HaQ2Ymw2IvoCKO1xp3eg?=
 =?us-ascii?Q?pZI14hK/ENmXXxPhAEyRiXRY+eV041jSAgDCzLq2J5obOJrrriPMqSgcC8vQ?=
 =?us-ascii?Q?UzfL9uxaNbGD8faRLXtm42r27SUb1sQeHFgfqASghh514v7f0h9nj8y3w9Ev?=
 =?us-ascii?Q?G5mz1EI++AazRPU4eFuol8RieD0z5IMHw2ujreq7+ykTQucLWHcSvzyMOL7n?=
 =?us-ascii?Q?nMEkUKfCB9ZdDtS0F2ngR5BOpOvciE/Yow/rMq6cWWThRkiYtuZgBGNuvsuN?=
 =?us-ascii?Q?OhyrU+GYfZj/Xj5fG+CaTScNEq42oHtlNx+JYPVYpqZuVyZkL4FIc36QyE05?=
 =?us-ascii?Q?UxKc9ECXIhA8di5UwHlj8CCARDKyxkJUDMPK0fllyFxAlLiGXzRANVnlezLi?=
 =?us-ascii?Q?HR5dvPIRnpEfDjGEG6znPWw/EIAfkqdJKnGF2o5SIO/cUvjIG1LP7qtaCM9o?=
 =?us-ascii?Q?Q0Q/X7rCx7FUP0t5LkTaOmYUxU377GGd+fFAhsJhReEXQ5FenYUwDlqjNUsr?=
 =?us-ascii?Q?VkPjXQo0?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69ecbcf6-1564-4b42-c52c-08d8c8f5c92c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB6800.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2021 10:15:24.7312
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q3Bo5WGbfJTp7KFseR7m+mjkQl9b+fr9ZBERULACg7H4VXZQAvfE81+GRRCq+38iIt9QZ6wKVqdX0I6mLbKTNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7407
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Small improvement for stmmac driver.

Reviewer think patch #1 should go into net-next repo, and add patch #2.

Joakim Zhang (2):
  net: stmmac: remove redundant null check for ptp clock
  net: stmmac: slightly adjust the order of the codes in stmmac_resume()

 .../net/ethernet/stmicro/stmmac/stmmac_main.c   | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

-- 
2.17.1

