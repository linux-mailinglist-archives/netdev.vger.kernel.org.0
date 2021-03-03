Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3170F32C41C
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:52:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354317AbhCDALO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:11:14 -0500
Received: from mail-eopbgr140047.outbound.protection.outlook.com ([40.107.14.47]:32679
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1356724AbhCCKsM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Mar 2021 05:48:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i8cBmPdc8XIKtJ1FbC8MTQllLJ/zPTqOw8zcgn0QBszr03S8BaSZeCyFnxdM+/W3slmEmQ+0O3XOD3uf36E9i851N8FQv/dRaPQg2jX5fsg7qNHXsOEDJ4xIxgpDQD7xRiN80CacPw1cGO1heewsTc8u4ZNfPlf2zRzBskVWTtGIA1317eBCFAW3iP0InzEnmQlnrfTmmrtHpF4vZ9fhJtvZtOl2CPktAR9z2m9Mz/dZ8eQ0P/rEOk/9m76UUf0Q4c4HIRqVmll6j2vbLYTgfgwgHtTMPiffNqYqR8Ns0E88DuRGO2wm8nKZCJfOUJZqXW4l/Xtd3Dzh4e2/6nRieg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7t8mYXiuwJc5jYSNU6glW6vSUoEroNnuHeB+oIbyJUY=;
 b=GkeaBdu3S2F1TxQ1x8lBOj3CiskZVFlvere0ScsDypAVRgKu7hBIMFGw+fHD+dFAy3SNa7hYM11A8BSY2+OkAn6PTFZrrk5mIfXL9smgHZu8MvuOw6VfdgQnnUwZIp4A/gVz2SDRmCJLUQdveJEKx2eEzyh58vujbjEEjawHYZ6zMWqjFiWWjlOyQso2yOvAoHQ3yo6EVlmosRDjwEZxWfd2zvDu9hOIZv1ZhfzZ0tWLriR7Pg1pu9usRsLssaUbCDm1Uo4tIkgQnlGgdUxKGsu2nfXyFhw1I+60BMk3W8UjNuPOeF3lbspfO6HwYLgtCFbT4X0a7G8FF6+Mehq3CA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7t8mYXiuwJc5jYSNU6glW6vSUoEroNnuHeB+oIbyJUY=;
 b=Q7FE8zINBnLoB0xQEbE0vhRwK7KX4JJE/9/zqUG4qYISLTH18g0I7GrrbORHihWoDWA0dt9cHC0NKCzDTVCvWMuaenbGNf38mvmyui82Z2OSzhFSEl1gIxIm7vBUpwWST/0K78x4aipYzC7VHq/+L51TcLSUr2M1qzZJniTAf7Y=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB6PR04MB3095.eurprd04.prod.outlook.com (2603:10a6:6:11::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.28; Wed, 3 Mar
 2021 10:47:23 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978%4]) with mapi id 15.20.3890.029; Wed, 3 Mar 2021
 10:47:23 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        f.fainelli@gmail.com, andrew@lunn.ch
Cc:     netdev@vger.kernel.org, linux-imx@nxp.com
Subject: [RFC V3 net-next 0/3] net: stmmac: implement clocks management
Date:   Wed,  3 Mar 2021 18:47:21 +0800
Message-Id: <20210303104724.1316-1-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: HK2PR04CA0068.apcprd04.prod.outlook.com
 (2603:1096:202:15::12) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by HK2PR04CA0068.apcprd04.prod.outlook.com (2603:1096:202:15::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Wed, 3 Mar 2021 10:47:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 230606c7-2802-4361-1580-08d8de31b9cb
X-MS-TrafficTypeDiagnostic: DB6PR04MB3095:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR04MB309560C2F8CB02859544EC3FE6989@DB6PR04MB3095.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3lBCavLRdylqRNgN7bO6dlf72avSYlo0FvXNfXDopz3L/3tXGUjW5RhYj7kIrJ8e2/qPCLrD0TDfy8IlNYAJ1FoPNFdfFwPXdCMkxHDrc1fK0sSNB8ZRBGfixviUih4sWysgN9Gkp5X5qKnmjvneWy2FWTPT73bQ5VlenStgFv7s3K5ENVmDl/TvWx3viCtVy1o9lAfM4EGx+L71k0I+QSdw6so9DUZ+k8lnkV7j3jX1fura4pVacQ4sUFthzs+gvuzIOIhNle1rD6sfaREx0RGg8DcrmJCCvUySw+A71uiPivkI4TojpQ4Hr0uTsXwHUXGKhdufH5uZ2pDInL/5XJfZuTEEPK7e/yriGdCLI8Yd7h+2ZXbHuKbgXjcQ4QSQ7xHJiO2SOI/IOeDjSy2F159w4BrSPz8fxAgxlBO+k9aA87m3AEsu4uE6dMfT+HenmpB4oQX/Tn9qsDVW9kF2NGhljKAuxsyAKf1u4AcQ9vVy9mruvygPy8FzRIH+zELNaPvp01zZVky3IFHwif32Ew2KbPHiicGuYLd7/VMu30VsLXX/7206yB98oIgziXMqjtFBYQgRFcVB5LJAtVbkEQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(39860400002)(396003)(366004)(346002)(6512007)(478600001)(316002)(66476007)(66556008)(8936002)(83380400001)(66946007)(69590400012)(1076003)(5660300002)(6486002)(86362001)(186003)(6506007)(26005)(52116002)(4326008)(36756003)(2616005)(8676002)(16526019)(6666004)(956004)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Hoq0elAhnfMdkMzWDNzGMdi/i83eXjKA9SkFx3W0I0EE3zN/+nADw+qn/XUH?=
 =?us-ascii?Q?dS/9xaJPy6gAJNqiWsQlAJZmAvV2bNCJj/9Jvbdih61zd6+5Bx15QG8OVpA6?=
 =?us-ascii?Q?zy9/+z+hAUivybNgFrc8ftVws/1xmSOefRpvf0CcxjDLgY2MO87k6O8SsZGw?=
 =?us-ascii?Q?hWlFsYtTQlYb401AowtV9waWM7aLRXByzWBCe1of5f5EM+Nlbl3x2hy85NEa?=
 =?us-ascii?Q?VS78Q2phr+8GPT+MPFbALc/kWnToFJcq7GJQQIkWQkDjuZ21d9ec2zdprqKe?=
 =?us-ascii?Q?EVcExSI1fG6MT4jlxVIk0srg6KnvEPn+W7+xqgpZCSCLpkPqrRi1cjA/rNsv?=
 =?us-ascii?Q?uyifEtHiZ1WRrjAEX13BTN1yGOOSy/zNUaj00Ik3QW+9R/NwUbjOu+34cVYt?=
 =?us-ascii?Q?1Yns7HdTbwfS12gl66lUph33cw53G/aaHBLK0ohXaRcldOlKVPVRPv7AN1/u?=
 =?us-ascii?Q?Rg8LulN5blTrT4dEdHb363Seaw8ruv3526nkL4paSVpXLN+Q/q0BuPGCQ8Ob?=
 =?us-ascii?Q?fz3bPYH85tg+I8K4mQIvJk/PC4gEuW4bJXtoxlyrJLufxmH8oPqGgbJSgB1v?=
 =?us-ascii?Q?87YKyq4J9sKIqiQf6U3z/WCPEx70cGpzOj+yUgid3ZA4Q0Oc1iPMFhMwxH/S?=
 =?us-ascii?Q?ZcKn7J0QU4bEX50pOwr4waWt/iIIbGNUta72VAEhNYf8UO/nRpdQMtnoA3tV?=
 =?us-ascii?Q?TVzuq+EhU6CAT0X2R3eU3jhAmsY3hbGdwu4vFqTKuCoU/NeSJrPhzJN2tUKE?=
 =?us-ascii?Q?9vixMDJtpYDSpj0F9cXAfaY5XO2OSYh4gtDATOcawvq4oOBhpvobuyMs92bt?=
 =?us-ascii?Q?wLSdOh5yvEq1957JBRxd/5mFx10FGAxcAgW4bUr8biYdsW7A1jdYmvDravRc?=
 =?us-ascii?Q?2Uq+LJzMXQhSZDNnIv2Ps6khGTc2PM/9e2+I4dAEr7/ExBYzNDmBeNhoAn3H?=
 =?us-ascii?Q?TU72WnPAoVftVxrjrtSaSBrRBN7zLCvkkVZWkslKb43i1HoirWlIdkdsQzJ5?=
 =?us-ascii?Q?buTl5+mKj3evKJ8YVZTp2Wgwkn+1cY9/FdIckBAoCORGTctKeCpVoFiCsxw2?=
 =?us-ascii?Q?Io1Xn0oGmmK5FdbqLxNjntQUj5dCbURG5Fd+JjX/BepFc+vfb5xA1Nm9uh0O?=
 =?us-ascii?Q?nwCMvAt7Ie/asi0nWSOmkTMvu9GJuqq+dx3zu42frvrgFJz8q5ovl3xjD8ry?=
 =?us-ascii?Q?UnERPym6KvxgMoG3nh2Km6dS/XDHWaW2VD2tlkJ1MIvNPcXLZz/EAfTVQC8l?=
 =?us-ascii?Q?WB4vfs2v7fINU8AAa73bSlsoogRoYU9zsp7EMYrqLOG0rsQuheEURP/qEjcc?=
 =?us-ascii?Q?jaU9zR9goQlfTaqfnuEkw2xP?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 230606c7-2802-4361-1580-08d8de31b9cb
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2021 10:47:22.8636
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F7keBBd5KkSMssieJ4+cJf01XacAaC4355BDlGkN3B5ernLO+GdQN8GPis/Qur9PDQVUxRpkjh71qgXz+2fEig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR04MB3095
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set tries to implement clocks management, and takes i.MX platform as an example.

---
ChangeLogs:
V1->V2:
	* change to pm runtime mechanism.
	* rename function: _enable() -> _config()
	* take MDIO bus into account, it needs clocks when interface
	is closed.
	* reverse Christmass tree.
V2->V3:
	* slightly simple the code according to Andrew's suggesstion
	and also add tag: Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Joakim Zhang (3):
  net: stmmac: add clocks management for gmac driver
  net: stmmac: add platform level clocks management
  net: stmmac: dwmac-imx: add platform level clocks management for i.MX

 .../net/ethernet/stmicro/stmmac/dwmac-imx.c   |  60 ++++++----
 drivers/net/ethernet/stmicro/stmmac/stmmac.h  |   1 +
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  85 ++++++++++++--
 .../net/ethernet/stmicro/stmmac/stmmac_mdio.c | 111 ++++++++++++++----
 .../ethernet/stmicro/stmmac/stmmac_platform.c |  24 +++-
 include/linux/stmmac.h                        |   1 +
 6 files changed, 221 insertions(+), 61 deletions(-)

-- 
2.17.1

