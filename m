Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D10C9327C0C
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 11:27:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234278AbhCAK0g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 05:26:36 -0500
Received: from mail-am6eur05on2077.outbound.protection.outlook.com ([40.107.22.77]:2529
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234167AbhCAK0C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Mar 2021 05:26:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g0o/TQpBQdl51zviVw5DJc6CvFMsTJwkZxNPqcN/wQnZiCZTWrY5iPrZB0aUG0qbISGkSn9glcCwT0seprAZ3/RJ0GGMG+dCxvcsW4qB6MAPFhuDUgmdPQDIqEVwJcSp7FPPBQuWKvzMkbPrWfmktjrxulJJyLugGyR7Wb4l4NGxlhD98CyBEp45nsCSUKQsHtRJY3qOhks4DUtRnzC50GEnBplAgsTkWWZfqjwbdBA9M9fffL/cn6YUHTko6G6oAKyDGK6v7f3ZplVoRztx8+NIcwNGFy1JyUwShvYWz7IBHsljD3n1fF61kXWj1SE8eDQFHHrF5PG1GXxQyPY8hQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I6un3UkewTE5Ce1GRVK3N6NFW7F1749CV9WziJ4Egmw=;
 b=Idr4A2+EkMjI2uvK+hYQDyE6aeAuxiA3uFYi+53qivsv7es9507JHJ0+cqMw57SiJ9Pms8pt3pw27gsy4PUl9gPytQYLztE9NMZRoC3NpLyR6Sp/Sa+Yp+fzWfRDhxaVCiou5NrpSxyWHkgg4Oe5U+R2f2adXCNCbiR9fYhwI7lT9QIi3iPwcOYdHwBr0GPNYlGm1ZkfosKxtN2c2pxJz0jLY1WMEbTgNImL950AXjFzvMmiMSLtvfMoiCZr9b5G1XGD3ehjh+wwDRlwYPZD+qovPBjj4DRYLxN8IhDzQKeKPn1QCHfPQ+/PxazwpcGxTOFpnfEDQSPlt9+GcATypQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I6un3UkewTE5Ce1GRVK3N6NFW7F1749CV9WziJ4Egmw=;
 b=G35PsiszA1hxBmPhBJWDnv/ltZoUl+iq+REkk6DkNV+xAucJZShAIV66ex7dMGm5v1nGvk6OLHnArBDKe69kyyBMeSHvuzVNBsyLcyhrB1ej7Aicc9DJP1GFs8GiP73EPzX9MB/KShl1+biDOAjgV0X+9A0JEhbUiegVyUvAMxQ=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB7PR04MB4953.eurprd04.prod.outlook.com (2603:10a6:10:13::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.28; Mon, 1 Mar
 2021 10:25:13 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978%4]) with mapi id 15.20.3890.028; Mon, 1 Mar 2021
 10:25:13 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        f.fainelli@gmail.com, andrew@lunn.ch
Cc:     linux-imx@nxp.com, netdev@vger.kernel.org
Subject: [RFC V2 resend net-next 0/3] net: stmmac: implement clocks management
Date:   Mon,  1 Mar 2021 18:25:26 +0800
Message-Id: <20210301102529.18573-1-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: HK2PR04CA0045.apcprd04.prod.outlook.com
 (2603:1096:202:14::13) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by HK2PR04CA0045.apcprd04.prod.outlook.com (2603:1096:202:14::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19 via Frontend Transport; Mon, 1 Mar 2021 10:25:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e4a52419-f4ff-44b6-d074-08d8dc9c4cc5
X-MS-TrafficTypeDiagnostic: DB7PR04MB4953:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR04MB495317951BBF35E873860341E69A9@DB7PR04MB4953.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q55BgFyoxpG8mslNLhxtQjngskdEvPdU9iLCam5weEwjhjvxs9XlezG6BwznlWQQNCmUX8UxXhyViFzbVmEWheNIkrUsbG3qDdPHo5I3IwyuCleQr58MFZhCs0RVWCZfSpLJTTfYLmozorfglN23LoHJ0kyPsz4Z7EMVU8wYO4a3jqMmvRgfHOcbFwpKYqVg+0/UPzQFE0ma4FE+TQwxqb8Mvyv5D9+3rdFq/9Yl7TY6mpB0j1v4kNwt15sAWSFRFNfwVvaR+x9t4pCDGqLtaXjC+Duaahi9t3A4xf+MLsKecRqL6FcBxVopDtecOMXxxBfFAcTt5MEvqBzRm1SIe451nNOTBOm16d0OZeVmtZnq7sbNcbARqv4TEKu/H98+JbgPildENeQEG/6+8bUwv+GdBWjminxQMpBCxaE9rLf3lWEO7K/uzxIj5A+ugOuawv+ZL5u+YMPC5z8zjlrXsbBC2AZwF+ckP/EnnK6Up7dhNfxN4bOOwasvPw32BQoAPQx7dxoadDpNVNulpGmTTPJizZaHZrAby8IZLMsmbZ2I2XBuj434HKX3xkbrkomTje0Dz6coAsl4IkAi9NUpow==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(136003)(376002)(366004)(346002)(5660300002)(4744005)(6666004)(6512007)(2906002)(1076003)(86362001)(52116002)(6506007)(36756003)(478600001)(6486002)(26005)(69590400012)(186003)(66476007)(8676002)(316002)(16526019)(4326008)(2616005)(956004)(83380400001)(8936002)(66556008)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?4Yc4Mxv57vd1vj56hZSdzt+G01rS2+f6lKyd3PFDS8OBozKxaWREulnmv6Xb?=
 =?us-ascii?Q?0T4gRpUTFu2QZYM7QAd7+GbZ/YelQ2EURmuhLWlIPLI/U8c3g++QBd1NwU8I?=
 =?us-ascii?Q?86gBST27MBUgO+MXHZYw2oQaO0ZQusI/inAAICWQNNJbCDwem2F/dUdLUw9m?=
 =?us-ascii?Q?gtRKh0oumK/11Wtjms0hWYX6hutxoIm+6R3Z4ui2/UhorlhzQrJE3F+gYWlf?=
 =?us-ascii?Q?/7MshNWh/tcS1FjNMe9tPMafNYxDaPo0RABbSBmu6B1UwZk1vJzaiBJxf3Cg?=
 =?us-ascii?Q?ZH1YLBN8cQMvFZrAI6Ofj2ZHTeAZPSqIku5Bo7GBRhcQwsiQGCc7R5ogsvOx?=
 =?us-ascii?Q?pHrYC9wLUoF4XWTwN6mz0/5nOBC5ZwpAukY18krwklK/HFMCWfQeWMWqZ9eB?=
 =?us-ascii?Q?C6YYCcOwly9lcPAJJOoAbrN742oYYCvEYfLCHCMgctLNCI8fyB0j2xPu/oGn?=
 =?us-ascii?Q?9Fsdn8yjfXjzNK6keHNfVKR/5JTlC4ZJevpxdZOgsU4GR1jWHO/H9CcGRiMt?=
 =?us-ascii?Q?1xpbH7KQGRiIOqk+TRUrbXn3iFVf7Kkc4vqtEiaUuqOXEyJQnhNqeg3+NZGb?=
 =?us-ascii?Q?WkH9Epwn4WY6+61n3AOBRycI8ixAu0WbLn/Dkq81ZrHRgDJ+R5OUqU+TgOIZ?=
 =?us-ascii?Q?zShrLBXfmYebLP64lRQi/tWEBERgs3mMRgXrCXRj0Qu8wKwAwmd9H6SFC1YS?=
 =?us-ascii?Q?/ricfME5gP/fc4LJRLXY5Rg49F/zOXvl2NciJf2O6KUyH1dnJXOMfPW1Hkhk?=
 =?us-ascii?Q?5ZZizM/M4Ac5auDrHCDlXszGOcWYtbfzLovEr047OYxx1vPDpeZjkzU6bxRB?=
 =?us-ascii?Q?RSg8OkNQPxSsWqgH0MwNagxxfrt1dH/3BCKGmLkWv9vXyhQhV/ugqBMsgHjB?=
 =?us-ascii?Q?FpEKUg6Yxj4TtjCdVYVJDLKbfBj/pePoBO1kQgYcGRjEEpUU/KRQxhANC7xv?=
 =?us-ascii?Q?Dg7dMRtk/hKsWCntdeZI/yvwtezMl6SYVpQJTlFCqUWl7dBBcpZbfTtSvn35?=
 =?us-ascii?Q?vV3ZjTGbCt7yf/iLVq1BWTe7Fu9ny27V1MZ1cXXjNTyjUQ2BRGMNjGHJkeN2?=
 =?us-ascii?Q?xoq5TcO/XOSCWrBaIf8WYzpWSP4wq1PlFo1EFh+c00ZRpge4hiN3ArJ8w79b?=
 =?us-ascii?Q?y5Xh0ajDK5/9CpjcfF/8Y7ghUjgfK/m2vgJzsJRl+kkYJTVgrKmG4M7b3fgs?=
 =?us-ascii?Q?4ijxSNnocd30wj738723xNAZiN7GyeJT9H+h3Ce4u4Gb3z+H1yg20oa+SBQG?=
 =?us-ascii?Q?0x3vLwPWu2b8AMaibyUMsBVvPFXeRAxvd5sBPMUxA9sUAhNvCjwrtZD/7cd1?=
 =?us-ascii?Q?/0dFzNdTsuLGtmuik9zWpHix?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4a52419-f4ff-44b6-d074-08d8dc9c4cc5
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2021 10:25:13.7998
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S9/vxyYQzOeygBOV9QVM9EoobUgwVrQmbdiwGwSa1q82o7vQKTJUpXlEIawSEKg73wt2ZOVW1Vz7k5M/0kxmpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4953
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set tries to implement clocks management, and takes i.MX
platform as an example.

---
ChangeLogs:
V1->V2:
	* change to pm runtime mechanism.
	* rename function: _enable() -> _config()
	* take MDIO bus into account, it needs clocks when interface
	is closed.
	* reverse Christmass tree.

Joakim Zhang (3):
  net: stmmac: add clocks management for gmac driver
  net: stmmac: add platform level clocks management
  net: stmmac: dwmac-imx: add platform level clocks management for i.MX

 .../net/ethernet/stmicro/stmmac/dwmac-imx.c   |  60 +++++----
 drivers/net/ethernet/stmicro/stmmac/stmmac.h  |   1 +
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  85 ++++++++++--
 .../net/ethernet/stmicro/stmmac/stmmac_mdio.c | 123 ++++++++++++++----
 .../ethernet/stmicro/stmmac/stmmac_platform.c |  24 +++-
 include/linux/stmmac.h                        |   1 +
 6 files changed, 231 insertions(+), 63 deletions(-)

-- 
2.17.1

