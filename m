Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1F9A3FB94F
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 17:54:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237682AbhH3PyD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 11:54:03 -0400
Received: from mail-eopbgr70058.outbound.protection.outlook.com ([40.107.7.58]:59207
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237628AbhH3PyC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Aug 2021 11:54:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lw1YbHWhjXR86kPBirbQTGVX8Qc66bf24kh8IDwReq8INugHrWx2pRB5GT0Y+jF3KkPox0DKewJwuLOIxRd4WJpqx3T/7GUYigDiqGZz4XSGeWppl8o3ETPy2Z42DdxnGhj/JDE4k+ipICMCt1h89BWrWFrW7IpebhcXiltTkPHm5VerxnEm/FECeK1rZNWkBRJgH6XpvcvyM70dZByAEjL1V8Y+uQ/cOHVGqGjCPorHHYvnVv1yH+TcNr+d3H3m35cM39oe77A0G3PyYHcAo19D210ZugBLqsb1T42m1DMXVdv273E93oqjto1VanLeE8pUvvIbScOZkSLe+wll1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vZxPOaKOs/PbF6V1hEFHG2X1QWBw6MiJUPFptzG0EEM=;
 b=m8S+fof3bIw9POfKw+bxsR3wW7MkqJilqM0yuEcyJYj3oreFPxygJfgO0w6iu1DkT7J3LBiNj/3mulk6wervPS7ZSfSyowSsazZiAkjpMfDQDIMnpBTROJ6+waw/MTMofLFC0NBCin1WlwqoXWQT4MzJupNqFBYJ0ETSDTG4hIPJEWvIaWymOYVT+RIg9eWpYBqT2xpltddNZoDuQa7aYkd4BjV9vDhlQ313APVAnsxILPfz03t4GmnHk+nLRkgOE9SjDoOLbK6BH+5drbYymMm/r92b1lr5FhCVnD2tWPV8Tz+xf6am2iOehy6HA1uJcMoxhpV9qjzb+b58mn5Gqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vZxPOaKOs/PbF6V1hEFHG2X1QWBw6MiJUPFptzG0EEM=;
 b=fw/sBFedI5SLQwU7DTcou4IexJD3aOB5Iok8M1u+YAddQaXB+KHG4Nr1atfNmOxmjxWXYGRHbwTHNMvbqN9yvjQ0PF6Vlv405IaRrf5e0kwmbAFQMJrRRTWjO009sxNWlJofBtWNd5QyuFeJxO3BcY+9DLVUo+Wm1Q9ep/4FpFI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2512.eurprd04.prod.outlook.com (2603:10a6:800:4e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.23; Mon, 30 Aug
 2021 15:53:07 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4457.024; Mon, 30 Aug 2021
 15:53:07 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Antoine Tenart <atenart@kernel.org>,
        Quentin Schulz <quentin.schulz@bootlin.com>,
        Michael Walle <michael@walle.cc>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Steen Hegelund <steen.hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com, bcm-kernel-feedback-list@broadcom.com
Subject: [RFC PATCH v2 net-next 0/5] Let phylink manage in-band AN for the PHY
Date:   Mon, 30 Aug 2021 18:52:45 +0300
Message-Id: <20210830155250.4029923-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR1P264CA0024.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:19f::11) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.78.148.104) by PR1P264CA0024.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:19f::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17 via Frontend Transport; Mon, 30 Aug 2021 15:53:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3722fe5c-31e4-41e5-55cd-08d96bce4203
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2512:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0401MB2512FC9A45E7A58B4DAAD096E0CB9@VI1PR0401MB2512.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZUbizMj0y40haLuZEa5EnOMtmXcQh9BtkJDFE1xEqVSwIZyBS8Bmhz10nOGTbpYYqKmjWiujSJPwFrQjwqTw4VLMcmZenhvJfpqD4zwf9yNo/ebC/Pyonbfz9o300152jRZiiAFG3dyWntLoGrbn8Nw7m0xxWluOUO1IDYamsgpXOXkwMaP7ovuIdbhBl7ep55KyACPub/uRLCbTQLW4ms0Se0HV9XjAeXVDLSgXLaZiGm5SLhba3ZjH2XL9jM2t8z5iK6M6oDxnWrUEqXsBgxnqYsbyIQg580dL8JmIeE4J59gLeROsDW7Jb6ZBbnT0PJ0yyZJ69s7jtiBV9VzWElYQrrp+SqtwIfJWX3Nua7IOdbAKRY09rAR2rDNJI/EfSFFKnjrqJlEiyseRikt332SxPnDI8a+lo9aAtUdq3dIwADCw2fDbZ8668RrbnKHheMNSIDvN7vUYMDS32OpyOKftIrcneZDd6iimV8wthVX3GvxZ7weWV2fKk04Koh9DB6qSOZ4A0f7CIdxl76st+hNm+uXQQ4GegBGrmZwU4NnWCxOd2yXOe2O0oXj/F7ksob6IUrcwoMPaysfMFhbJrM6Xh++Kgu15U9wzv5IoI+hPsBZgbuh/cka+h9TgvujMn/BeFNU2+Nu9OANCgCxAOhNwUF/KUz0paPIr11OMeTGygXOVJuLa6n39zUEf2WE3VCcazQXIm6QOBuszHl23X5Lb6n5/lCcf1XkqHehCYFW3fbrfy9DtUmfa+uXT0vAii+bmRziSzprO5zjIkLXlNA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(6666004)(52116002)(83380400001)(6916009)(7416002)(2616005)(44832011)(316002)(5660300002)(8936002)(8676002)(66946007)(26005)(6486002)(966005)(54906003)(6506007)(508600001)(186003)(38350700002)(86362001)(36756003)(66556008)(66476007)(38100700002)(1076003)(956004)(6512007)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mnpQ4TKl98VzixDWwElYlL0+7w6/TT3i0gzbh+zx+LMt/fiejjaqErwtHS04?=
 =?us-ascii?Q?m933I4pqgKaMtPFC42LjtSLAwLGFLlka8GGqAZtUKTYE1U6tl2ltU8W0FkBH?=
 =?us-ascii?Q?O7U1WcervLueJ45vCCLCDLNb3sa04LrABxAKFKAf4yZ/M2y8apK6ShA775wP?=
 =?us-ascii?Q?0XpPhvv2/QCQlEzOtDE+VLL3iF3yTuSlBe+VIyiLKVo1vK3V/LrwwgfJg+ox?=
 =?us-ascii?Q?UmHWAc0Sb8TVBGF2PqqbK95DkUfsRDP+VcLGspFJxsVu/NIwaLYfIZ0gMpYx?=
 =?us-ascii?Q?Ah5C+ctCWVUrKk8J0dSv1Bo1oC/mmBnEcdrmcYeuDlKRaJXMMkA5fU+o4/l5?=
 =?us-ascii?Q?cvmUwJIYcut+Xlv2atagpt3s3UsKRS/e370ZmkQXQqVUS8hD6x9Fo8X5w0tP?=
 =?us-ascii?Q?lsSIuqnzbwZFKw9W2kMqd54CeAf9ohwwtFvs4rcydwFXrqvVrintC/GCeJzT?=
 =?us-ascii?Q?rFhgZrS6WqYhstU6mKpkVcZuelHsHmPIJOCKqxDuSDEBGHLvCRSavRFEM473?=
 =?us-ascii?Q?p1NUv38s7ng9NvNEtxZvWTuhyUrF3xaR50+g+q3FN7GiPWdkLHYMDcRPeTdU?=
 =?us-ascii?Q?Va2gkfJbZxqkDryscVkq///mfbAF06o8wsiwiDYZcOUY0wa2RHsG437tWppW?=
 =?us-ascii?Q?tT7YiwWWVFzhTZhGEHwxnBocB4iEmmitPK0VQQ5PWobRwOMPYMR+LCMRQs/d?=
 =?us-ascii?Q?g0ReymDOv81jQ0JltDghwbaRCMMKztWO2o6uk+iyhO3ll0acktRRi75R+sX2?=
 =?us-ascii?Q?zyomb6inM8uOwGmrYE6a384yRAkFU+sF31mGJ7JxjA7WGiLUNsVj166SlhXJ?=
 =?us-ascii?Q?nAdBcCuCvEiJ/u7TqDUraa6hzTureu+7Jy9zZHQwhbkCpR25hRHIgxOI8CDZ?=
 =?us-ascii?Q?GN+YrKMN2cIJEZH+O5IU7q3fzpe7FEC7nxysoZ3MSdYs+6Jlez0GjswFA5cF?=
 =?us-ascii?Q?VhI1fGwspDigTsTxSFShUZmQ+hOJqYAX0ZI6v4hDbPdCr41BNiIpeZSSWCfu?=
 =?us-ascii?Q?Zz/ILyMbMDlg9NMFZHNBDyeUuWBIL7bjFhn6IEF5A1e4gn62JxWBihYQdK/L?=
 =?us-ascii?Q?YZxv70zKlmD4WpmunclAuNtALGd+R90sJqMUJCWOmbQASk3AR9YT/926oi1Z?=
 =?us-ascii?Q?MrMsfx46iqVRqgxYWO8nLNWZeLkJXXeKJAzaDNxfAg2bsvMyCpP/O0kTitmJ?=
 =?us-ascii?Q?Bhdjt/s7Fs+48MgJ3fSXujZXtb+HCtyrP+0JVz+WSvmjxPagUKm+kO35HEb7?=
 =?us-ascii?Q?dp2SIediMX+DtxjT9OhVff5FOIIx1u8b+X7ClJTIpBpYqazp4g8BCjW6RIb5?=
 =?us-ascii?Q?XD04g0jvwvMTQMwcd3MSs8Wg?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3722fe5c-31e4-41e5-55cd-08d96bce4203
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2021 15:53:07.0692
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rsUX02fxVjZZQkG/xYjq2iQMiiRNr5KXbbCrk5JDrc2EYGQUW2XG3sDgfZjBssRbHr1H6ObmvlW7RirVo5hEYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2512
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This small series creates a configuration knob for PHY drivers which use
serial MII-side interfaces and support clause 37 in-band auto-negotiation
there.

Changes in v2:
Incorporated feedback from Russell, which was to consider PHYs on SFP
modules too, and unify phylink's detection of PHYs with broken in-band
autoneg with the newly introduced PHY driver methods.
https://patchwork.kernel.org/project/netdevbpf/cover/20210212172341.3489046-1-olteanv@gmail.com/

This change set is only superficially tested, hence the RFC tag. It does
what I need on the NXP boards with on-board PHYs that I have, and also
seems to behave the same as before when I use a 1G SGMII SFP module with
the Marvell 88E1111 PHY (the only thing I have). I do not have the
ability to test the Methode DM7052 SFP module for the bcm84881.c driver
change, since I don't have that.

Posting the patch series mostly to figure out whether I understood the
change request correctly.

Vladimir Oltean (5):
  net: phylink: pass the phy argument to phylink_sfp_config
  net: phylink: introduce a generic method for querying PHY in-band
    autoneg capability
  net: phy: bcm84881: move the in-band capability check where it belongs
  net: phylink: explicitly configure in-band autoneg for PHYs that
    support it
  net: phy: mscc: configure in-band auto-negotiation for VSC8514

 drivers/net/phy/bcm84881.c       | 10 ++++
 drivers/net/phy/mscc/mscc.h      |  2 +
 drivers/net/phy/mscc/mscc_main.c | 20 +++++++
 drivers/net/phy/phy.c            | 25 +++++++++
 drivers/net/phy/phylink.c        | 93 +++++++++++++++++++++++++-------
 include/linux/phy.h              | 24 +++++++++
 6 files changed, 154 insertions(+), 20 deletions(-)

-- 
2.25.1

