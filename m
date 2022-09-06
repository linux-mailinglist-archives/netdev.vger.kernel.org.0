Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 505FB5AF0E2
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 18:45:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233918AbiIFQlO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 12:41:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232939AbiIFQkl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 12:40:41 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2076.outbound.protection.outlook.com [40.107.104.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FDA5861EE;
        Tue,  6 Sep 2022 09:19:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y+RjPJSSu5QJfTR/fUMucjT7CmNWOx/CIO5+wir8TH+i9o+/u8z5U5cLXDhcMRlQWS07Kgdz8h1foIzIhuRWR6grKfVnWW5sy45+vTnYCaA2iLQqZ85Vhb9MeKMYdfxM3SSp3KvT7XUbUAkAa7XmpjnoPhtEgOo6lVD0Y4ET80DCwHtsVS4aPnXk9dPJ7BbaTGARXDMx56JWsUBUTdYgkenNj1rpoaqojPNdbl9UqpRxiIR2KQnMgI5rweCbSJUkSw237gevJFFhiFn47sG9U0ENzB606ns2lwl5hMZZCyBg5O18Jo428Y+hKp8mTSpr5ZZReWVKdvkUUw7TMdMDOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8gBEJ9RRqAgYhsNBak1w7XwC5WTPlnMFCdTEh4XGJhw=;
 b=cl5r4lNZK1TlX0JYfkR1QiCa9jowh0nzGVSa4AUryIGVgk8EYQMf4XA9akef5ZsQ7bQvBkES5agA4QRSLZRZzaV2iKpQdSOSY/ujOFbc9Kr/3cP+02UPGBNlGfbpLpZbpIDR+QaUoDLUjKposDWhg/iYQayqP4zGnInJahj2m4Xy33YgpMw8jWw/f9MUiOoUF7jGBNlNQrAw9Qmk1qkS5O2y+3d+jpbg1YIhQQs7uGA3Jrx/ng6x30IpMEc5vm+n2NvhNBIoRRJXJOHPkbdjtysQgfOiOXOpBo4Y/huXAsOdP3tGqA4leCb9XrpWF+TdGXpyzi5VZI3xK0rLB87HtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8gBEJ9RRqAgYhsNBak1w7XwC5WTPlnMFCdTEh4XGJhw=;
 b=Y9UjCRAzFrPj4R1stMoJBMSIkpqUUGM9NUZ1lgxTxQpSekm1aF1rn3pISfPy4z+i0LC+AwMFPNLl9ZbaV7GFupqow/v8gYhCYtljGjB3HSU8hV3+VXw4RnlirnchOqM/Z2otNNE/YuVuNQP71eclYvescr6NqIGoMAhAVjYaAVaikSOC1eix6fA5C7WJPeM1uUbjj7t6/6dS7+zcn9lcdAUKPMVzWYcKk12ySeJjLNUAItrGhZkCT25Rv4BDEYtO/Je4inQ3FeH3cWIRbLB8pxBs4r28d2NnxVEKszC/jR3kwc25FO03on+rmkwEAoXr4KpAvEbIqFvcbuPP/8bRoQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by VI1PR0301MB2254.eurprd03.prod.outlook.com (2603:10a6:800:29::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.18; Tue, 6 Sep
 2022 16:19:10 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5588.018; Tue, 6 Sep 2022
 16:19:04 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Sean Anderson <sean.anderson@seco.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH net-next v5 0/8] net: phy: Add support for rate adaptation
Date:   Tue,  6 Sep 2022 12:18:44 -0400
Message-Id: <20220906161852.1538270-1-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR02CA0046.namprd02.prod.outlook.com
 (2603:10b6:207:3d::23) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fccd6fc6-f182-44f7-86c0-08da902383fc
X-MS-TrafficTypeDiagnostic: VI1PR0301MB2254:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Fc9MOg3GfWQkyfI4ckq7hAf3L57eaXwAsgQKXvYz4L4LRJrnNySDJwFEJl0VCPqnvr1g5MPXFYsMdt3ABqHIsfC6ZTooQ/MbP/n0uaX2PrN1hLd7bMUiQulbEmg7wt200SenD4kh44eocrwpTthhvv52KDKLyhg+TEb8zwVFGsLhxcaByyn/1WCUn+w8w+4Reb+mXru3sxuxEa+qJuACdUa7xUHUOHProad0jaexW9o88rJk3TAIyKZICU4OEY3VwMg2in6WwnmLFq7FIOg/zCwL7uBhXVUn6hbyC3hNtn2neCfpX/SM8nmSylksBshI9nFkbCIU9yjAAXAzWUuN50cSCXGDbLylWJgzjcblzhWvDPWy4SU8PKOrXoWwYVrgUk1FX6tyuGZMDCxlugh9JHAoLIby7IZVpqEx3f2QwqOjB4KfiX5qb42g0a4ML1rroH+EujrwDQ3xLR+6zrcb4AWwqCajhzGp3TU73No56YiS8qnq5TzjlCO7XJGxjnjFvFCstRrpQapjJWpviCEbjmTLw/STGnRtRL04WSYSBGM4kWi9zHSjvcEZmKouDG0ikUeSW0JYiF7jF0ICYYtPCx4J0wnEbbWC9gKrWb3tMOhDnzI7yYcmQQaZa++DXxEUhZ+Vy7Xx1OFYIAG+bU1WbhccqKu8fJ3mozne/fHhFPY/pEnaY5RYQAdlaEhmCKIfSDUMg9fUlWWsMiMy8cWNTmVdnASakLxu0r5mPol4f2H8uygGvAB1dvNuN6nC9OQ/nGE5aQqGA0DZVT9F747qnSmALeIUQHQYafi2BGcxeEs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(346002)(366004)(396003)(136003)(39850400004)(38100700002)(54906003)(38350700002)(110136005)(83380400001)(316002)(4326008)(8676002)(66556008)(66476007)(66946007)(2906002)(44832011)(7416002)(8936002)(6506007)(5660300002)(2616005)(1076003)(52116002)(186003)(478600001)(41300700001)(6666004)(966005)(86362001)(6512007)(26005)(6486002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?foSdWoY7vK6qHLoEtK/CqyK31Ibbg8AhPR2NVQdDLMmZVToS0NooAt/x9+nj?=
 =?us-ascii?Q?hZEGdvWTH0LdOunovSzCgnRuLjNWjngaUzyx63TlD+XIrs4Mos+F5RFY1H3b?=
 =?us-ascii?Q?X8e8cmuWrdC04KvzUs0sFH5tNX5Jk+YqRTtzfm0FlVIUsDcIMdN1/G5MEvtN?=
 =?us-ascii?Q?mY/Vyt7NjtCo3f9YarMdmNnw6mp3jlh17vVXazlBB19mjLpVQF1UIHRTZeUq?=
 =?us-ascii?Q?gC+AEzPLkzix+18+KQBaXodDyK0nqpmppAhXyQypo6nzxL5Hwm7G0zySsZ/e?=
 =?us-ascii?Q?LIxYuYZRxIPva3sLhGHYR2tfW1fHbJm2/evjaUHs3fPRmGDKd/1vjOlZhaGG?=
 =?us-ascii?Q?1Mb/lwM+gKUCd5fFlH+c9eEA3Sb78ybS6mhcIHl+bD2Xv3Rch/HONvlAYlXp?=
 =?us-ascii?Q?/t3amMCUeP7G35Si+Ih0pncBridtggwydWZgCAwyB3OuPaSTvS7fS2hJayAJ?=
 =?us-ascii?Q?cciELNG/Xk3TQ5ua/gQo2D/xYmNMhmap47Vgb4M2rAG2ivfaGLxrTC2d73Zo?=
 =?us-ascii?Q?PJt+mz4jiOlfJS2JzfpOLnIcNs8E8nlFmXGPhNfQa3ZOs0ru+wCvsq5RfKFp?=
 =?us-ascii?Q?YIevynoiX0VMDnk3QemLb3cPkC19zVaqM52kuNUR8Ynej4y6BvENsIeex2yf?=
 =?us-ascii?Q?adTg0qaDa6diWNq8AL2d+jP81kgkldDgk0Rktyx2/syWjK158k4arGZj0W7h?=
 =?us-ascii?Q?QXlsIs0jaN4unpVFVPJnPk6WAnQlmp0zSPQDPvt6X8NZ2w6xFzR2nQhuYq3y?=
 =?us-ascii?Q?7GxAhbk1Rx9JTYhduuyYvEmegFAz8v2z+V+NlkRDOhMO52OlapX7+NB4IcIw?=
 =?us-ascii?Q?E407yCIqoEmQW3vMu9k+18PZHuNyl3GG7xkXfl9I32FtT0fubkV+rQj40TLl?=
 =?us-ascii?Q?mVO6lH0Ef/aMZvEqG+FMwNT2QvLOx/ZfwBglu4AJobIO2A0e3u8K1Q55b51s?=
 =?us-ascii?Q?KLBHOZ+nJZlWeI8maast5B0JIMZNNDFS3+d107mr8cKnnkRx4/kEFQWk0NHO?=
 =?us-ascii?Q?SVXSLmtpmpQsRwAZ75IW2H72tZDUS2qhSYGVpCSK5rMwGoYUTy/0zNRpHdw8?=
 =?us-ascii?Q?laS84MgTNNxVWUxgqb7ttclC84opr/v5BRS2EUF37tBYGb/PFon/MKPFjbMF?=
 =?us-ascii?Q?DQOsdaLOjHTEgt81fyMHMjQ0TjbOycVjLdOCIeOJgMzQyWpcrxNXgxTuaNP+?=
 =?us-ascii?Q?fF13R7L8PXT6EAKvrPzpTT5nmlVNgnvqxqYWX9JrbAbMr+EcfAYCijcmB7DK?=
 =?us-ascii?Q?4p7LLoCGontHbQebBAbbvidY945xTZpoO1pv7olKyqPmx8gbIOBPRBhQtb6V?=
 =?us-ascii?Q?Q0iXclcDXR23S8SBAN40q/63TdonMqCMH442e51lEe4Dzq/FB4XvTyKqs6Vm?=
 =?us-ascii?Q?iaz7fyCI8kaXQuWP2T+CbJ3VxVGSAYJYCM0yBa6sdigtk6n2o+75ydUIyUg0?=
 =?us-ascii?Q?fFSXJc+QehyBU8cZiKMpWQDqXJyOTbVlISevgfZihu4Aj4J65OOGzEnNjmzG?=
 =?us-ascii?Q?ncERnVZqPNHwAuD6CSAqcSMPhgYtq0NNBj2JDR5RZxiA/84fiqsl/f/Q5U7C?=
 =?us-ascii?Q?/WzBAvEGp/YACkgJaJUtYwyzwaUIEYQIKaYpuNIiLHN3kpiYQjjzBY9pM5dI?=
 =?us-ascii?Q?IA=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fccd6fc6-f182-44f7-86c0-08da902383fc
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2022 16:19:04.0685
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rx8HBapcpMyPaO33neMrXM8DnP5abkNkgcnpyPSM3AJkH33swZH2DyHH/vjITDLTwdsWcklebUaCn8BdOnzKcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0301MB2254
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds support for phy rate adaptation: when a phy adapts between
differing phy interface and link speeds. It was originally submitted as
part of [1], which is considered "v1" of this series.

Several past discussions [2-4] around adding rate adaptation provide
some context.

Although in earlier versions of this series, userspace could disable
rate adaptation, now it is only possible to determine the current rate
adaptation type. Disabling or otherwise configuring rate adaptation has
been left for future work. However, because currently only
RATE_ADAPT_PAUSE is implemented, it is possible to disable rate
adaptation by modifying the advertisement appropriately.

[1] https://lore.kernel.org/netdev/20220715215954.1449214-1-sean.anderson@seco.com/T/#t
[2] https://lore.kernel.org/netdev/1579701573-6609-1-git-send-email-madalin.bucur@oss.nxp.com/
[3] https://lore.kernel.org/netdev/1580137671-22081-1-git-send-email-madalin.bucur@oss.nxp.com/
[4] https://lore.kernel.org/netdev/20200116181933.32765-1-olteanv@gmail.com/

Changes in v5:
- Document phy_rate_adaptation_to_str
- Remove unnecessary comma
- Move phylink_cap_from_speed_duplex to this commit
- Drop patch "Add some helpers for working with mac caps"; it has been
  incorperated into the autonegotiation patch.
- Break off patch "net: phy: Add 1000BASE-KX interface mode" for
  separate submission.
- Rebase onto net-next/master

Changes in v4:
- Export phy_rate_adaptation_to_str
- Remove phylink_interface_max_speed, which was accidentally added
- Split off the LS1046ARDB 1G fix

Changes in v3:
- Document MAC_(A)SYM_PAUSE
- Modify link settings directly in phylink_link_up, instead of doing
  things more indirectly via link_*.
- Add phylink_cap_from_speed_duplex to look up the mac capability
  corresponding to the interface's speed.
- Include RATE_ADAPT_CRS; it's a few lines and it doesn't hurt.
- Move unused defines to next commit (where they will be used)
- Remove "Support differing link/interface speed/duplex". It has been
  rendered unnecessary due to simplification of the rate adaptation
  patches. Thanks Russell!
- Rewrite cover letter to better reflect the opinions of the developers
  involved

Changes in v2:
- Use int/defines instead of enum to allow for use in ioctls/netlink
- Add locking to phy_get_rate_adaptation
- Add (read-only) ethtool support for rate adaptation
- Move part of commit message to cover letter, as it gives a good
  overview of the whole series, and allows this patch to focus more on
  the specifics.
- Use the phy's rate adaptation setting to determine whether to use its
  link speed/duplex or the MAC's speed/duplex with MLO_AN_INBAND.
- Always use the rate adaptation setting to determine the interface
  speed/duplex (instead of sometimes using the interface mode).
- Determine the interface speed and max mac speed directly instead of
  guessing based on the caps.
- Add comments clarifying the register defines
- Reorder variables in aqr107_read_rate

Sean Anderson (8):
  net: phylink: Document MAC_(A)SYM_PAUSE
  net: phylink: Export phylink_caps_to_linkmodes
  net: phylink: Generate caps and convert to linkmodes separately
  net: phy: Add support for rate adaptation
  net: phylink: Adjust link settings based on rate adaptation
  net: phylink: Adjust advertisement based on rate adaptation
  net: phy: aquantia: Add some additional phy interfaces
  net: phy: aquantia: Add support for rate adaptation

 Documentation/networking/ethtool-netlink.rst |   2 +
 drivers/net/phy/aquantia_main.c              |  68 ++++-
 drivers/net/phy/phy-core.c                   |  21 ++
 drivers/net/phy/phy.c                        |  28 ++
 drivers/net/phy/phylink.c                    | 270 +++++++++++++++++--
 include/linux/phy.h                          |  22 +-
 include/linux/phylink.h                      |  27 +-
 include/uapi/linux/ethtool.h                 |  18 +-
 include/uapi/linux/ethtool_netlink.h         |   1 +
 net/ethtool/ioctl.c                          |   1 +
 net/ethtool/linkmodes.c                      |   5 +
 11 files changed, 429 insertions(+), 34 deletions(-)

-- 
2.35.1.1320.gc452695387.dirty

