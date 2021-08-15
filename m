Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28BDA3EC6AB
	for <lists+netdev@lfdr.de>; Sun, 15 Aug 2021 03:48:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234734AbhHOBsh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 21:48:37 -0400
Received: from mail-vi1eur05on2044.outbound.protection.outlook.com ([40.107.21.44]:33792
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230079AbhHOBse (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Aug 2021 21:48:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BdwTDAIcHvC0B7O6FbaNdxwaPj9SWKt4/7+f4NMi7zfvJ6X1LIqVWDbypFdfqjmwE2KMGdZQR0sLVuq543C1MG3XvFxFjM9i86LXsDUYq7BgrByIo4BzWwt5KwGqrarFuWhVq8FpqX6Tqk1HL+rSiM+7VVRVyLTDN29t1aiXl8VjOuI10GoxdkHy4EIf+oFXAwlEvwLE0sNNihxAEYg0UD2tiw4z1t0XgYWrKgzZJ0LngJvlyDzvfVJQuNhSIJAbsDnoMdqqvRyEZyRW83qtvFezzROMreexc9actfgNDol9oQQOR80k14YgZGXnam+Yh8gb6T7ZzC3fBM3Tu7xSVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XINnOxwWXy856Lt0v/TRKeS80vnsSKJO8qmfypuWldY=;
 b=BoIXDFX+ofkSXdOduQDw1g4KzkJaOQGKbJz91LHvu1TxKQv5SbPcWT7HfSJ0ot4l1uTpc8zAKflqhpI7jHim8PIz+FFtshZ3jyjKxj6NjwZGhizY4cOnSuFh2NT9/c+bAj1DSogUpMT/rtFjvhudXAJg1cPXEplVJdv5KU+KKuPuW6zDJ2VJkVdj2DZwMEynTK4VokwotLTFgZBM6b2Uuw6hOuS5zMt9Cd47r1VEv0jMTguJO+4gLzZdA6LqJds2mF/cEL3qfnSTONVHkSKRIaSG8oUf+PCQPdGXCYjoga0x7Z/sw8EVhYh6VEnNIfkAElLSoBN9SM7UAphX94hNLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XINnOxwWXy856Lt0v/TRKeS80vnsSKJO8qmfypuWldY=;
 b=gId4AjPVZpn7VckoLdEITDdfdebxEL47Yvy5EOxZy5CtkeIhHdTywznFgblseEWGA72aDybpq5HZjZWGAXFgp1KUvuj840Wydn5pbrktG+nSA5RcJPewmBUBe1bHKuHjK4dVuVHmrZNs4vrK+MxTE7LzT2CfXaoRfu+fNCA7v3s=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB3069.eurprd04.prod.outlook.com (2603:10a6:802:9::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.21; Sun, 15 Aug
 2021 01:48:00 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4415.022; Sun, 15 Aug 2021
 01:48:00 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Russell King <linux@armlinux.org.uk>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH v2 net-next 0/2] Convert ocelot to phylink
Date:   Sun, 15 Aug 2021 04:47:46 +0300
Message-Id: <20210815014748.1262458-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR0P264CA0087.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:18::27) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by PR0P264CA0087.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:18::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.13 via Frontend Transport; Sun, 15 Aug 2021 01:47:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6371649f-0b44-4811-c5af-08d95f8eb67d
X-MS-TrafficTypeDiagnostic: VI1PR04MB3069:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB306953F0C0CC96D1D77712EAE0FC9@VI1PR04MB3069.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: te7nmdrfLtb8CAcBJ2QXXuqPLDSypQtKkXPC+s1ADfIGLBxKC0RYxdzgV4sxai8Cpmm1gGx4t7o03iJEZSqZ/QMDyTVG8DZUyDq0jrFjyajhAEKbvh7zZO68+zWvjIGEEQPzqcexsUS93wDK5c7hTFMVamIrPzWgDle9/DIbx6KD+y6vq76XWM7HVb9gHhYQ7zez8D8BLDEhAFX/pAV+ALEaefbnomfxpGnCuxUXx8zDtcSsoBD6ek1UL6/b080xV4SMSETIILULLU0h+au864XhVC4gq9jn9rVm5Z9KItXPouxLO8Gk/BtC5WaBhFRTGh2EAhlbGQ8XE4BL1OknRNxbPSzdqFGKbMJeY8k31SgUYL9rFjYPgECkcCtWlCjXwv0enEBFbHktYjGLvfKf6j7ysrAymWB74X3oF7KEYL5pTipn0X3cW+WpIht9EgAZ/FKtZVWvkk5+EuJ5xKsZih4OGnPzRk9/mbgunoYeU/GAeI+JmJ4I0ijTYCmpMclaSTrP+mIOhgg6ijJOB7WWPjfK9C2Kl2n1Qf2JFN62T839bpmjLUYLVJNjKIM7GTsnLLFLpkcJ8P/RC9yYWy1PNRTVhqURMFvwcaMCahLXlwgxKIjQdiOQMVjfjyQytr3HCce0cONhVdc1MVmeMl/lurGEv6YKwOvgdWiYBv12wzYn9LnOc6L/Gkhtx1/cL2JicKS82rCogy7+XxL5Q5vu7w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(39850400004)(396003)(346002)(376002)(186003)(86362001)(6666004)(1076003)(26005)(66556008)(38100700002)(38350700002)(66476007)(8936002)(8676002)(83380400001)(66946007)(956004)(2616005)(110136005)(52116002)(44832011)(4326008)(478600001)(6512007)(5660300002)(2906002)(36756003)(6486002)(6506007)(54906003)(7416002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uPEl8PJJFwodsicsGMzufUTZamhcXyWc1T5QLVjAPbKzyMdL7/2eyxy0Aheh?=
 =?us-ascii?Q?tvs+G8t2+8CBp28pD74lmesJAdLzqnpztAp3wE9l13DrPi7SK8//q/CRiVn1?=
 =?us-ascii?Q?zSbYFqwP3KG+6bxKyL5s6wneAI1GCVV8Y+K9ZvLlRfgBSU9c/16eI2wSExDo?=
 =?us-ascii?Q?YFcIsTV9bWBHCeJMevLTXKw6INfpIUAxaoUyRs2ahNM2wGSsYwvl8EzYUG76?=
 =?us-ascii?Q?okmc6AoaD5hCWJoSRTRx/VcCx8XOrW2Scwjf1uu6ivicFBEaW3ItYLvOteoU?=
 =?us-ascii?Q?m1nae6TkOyAi2CMDn7gZ5Zv9Tm2m3wUbwtV2xIbkXiqMmDtEZ+RK9IIDl6UG?=
 =?us-ascii?Q?S5EmnVyZ8OlN69V2l/ZU1VtBsjxyKOTJRxmbOzUEYSmmC8ZoQCXTB255fjeS?=
 =?us-ascii?Q?6yTxOJAmKb0+hBoE1oiFjdl+Yva5xMIiCDORLh3x8t2hLCozc8xgQSTAPI3K?=
 =?us-ascii?Q?Asp2ktMiGs0fhkws6ZafXajsWuO0iD4tX6Y51yKd6o9V8sgKJpOwxnbiwSxE?=
 =?us-ascii?Q?fquAOCL/qeatN/D17L58yd4Dk8htSybmHA0iBwBOENRX8jkBuZc0FlQIxUHs?=
 =?us-ascii?Q?qilIoXufP9KjAyFsHJtipkxz0JozFW7mRA/XDmjO//kZYgncSTdg948ROeco?=
 =?us-ascii?Q?1X3rLine+S5tjQpluFkRjDxvsIuC0k6bPzggzBRViUn8izWbL0xBW25fBRcF?=
 =?us-ascii?Q?3tHvPRtz20s/y8CNQcbdTZ+ptwlEDa5Pc8iCAHtHmw06SOMwqTOCBUPTFTZA?=
 =?us-ascii?Q?b2whLUSir7NdgfHXKYiNdPAYJtqkFuq+iWWiQRZla4zjqx6+386qmyYfPJQG?=
 =?us-ascii?Q?BpGzOj23PXh0pcp4Nr2/MaDW3EV7xVwonoJE8VEVuRn4NOJKaku9VzLZuhii?=
 =?us-ascii?Q?0OWO+q7dOmYYY4jWHiXuXqA9+t6tlkDQMiUSp6OwwXzLWxGKCvTB/KkBB7t9?=
 =?us-ascii?Q?qoROa7LxOY45pyIGmEFLatsItPIp+EHl3BQgpA6tcfE2YC8iGVDuURLDSJPT?=
 =?us-ascii?Q?Q27PE3Uz1k0YpvQqR89NjrCC2vyW76tcFm02Ti75tHz4of2jw6PF/m2wIdlm?=
 =?us-ascii?Q?p+hfNdLkf4Ech+UdXCaN3l/48BL0kLOiNYoRa0lsXp8hvgiX3JkBC0UOkpJD?=
 =?us-ascii?Q?wEtFHfiDQ3GwinE/yKiVuPq5Gob4RjvXla5VmgAkgh9AW44Qjb9Su9vLiSLi?=
 =?us-ascii?Q?1rAs0h6qnUxLGzjBzVNuSEiMqW0Ys3P+qaRIbGBGe9WFpNrIKnMayR4GuSH4?=
 =?us-ascii?Q?ONC7tGP3Sdf9W0OqUcLsvJSvKhbCp0xnoidrd5h5Gixx/QDgVCKhRgTkRFwR?=
 =?us-ascii?Q?TcJswkoR1nO4ZirJVQjSDRBS?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6371649f-0b44-4811-c5af-08d95f8eb67d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2021 01:48:00.3025
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9tFCqvJTEph1XjZ9dJlqYRVubYED/U4b7PoRRm7ztL91L9x0VS5kBl9Q5ujEZTJesqaTj+3FYj7o2vrsv7PNrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3069
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ocelot switchdev and felix dsa drivers are interesting because they
target the same class of hardware switches but used in different modes.

Colin has an interesting use case where he wants to use a hardware
switch supported by the ocelot switchdev driver with the felix dsa
driver.

So far, the existing hardware revisions were similar between the ocelot
and felix drivers, but not completely identical. With identical hardware,
it is absurd that the felix driver uses phylink while the ocelot driver
uses phylib - this should not be one of the differences between the
switchdev and dsa driver, and we could eliminate it.

Colin will need the common phylink support in ocelot and felix when
adding a phylink_pcs driver for the PCS1G block inside VSC7514, which
will make the felix driver work with either the NXP or the Microchip PCS.

As usual, Alex, Horatiu, sorry for bugging you, but it would be
appreciated if you could give this a quick run on actual VSC7514
hardware (which I don't have) to make sure I'm not introducing any
breakage.

Vladimir Oltean (2):
  net: dsa: felix: stop calling ocelot_port_{enable,disable}
  net: mscc: ocelot: convert to phylink

 drivers/net/dsa/ocelot/felix.c             | 109 +--------
 drivers/net/dsa/ocelot/felix.h             |   1 +
 drivers/net/ethernet/mscc/Kconfig          |   2 +-
 drivers/net/ethernet/mscc/ocelot.c         | 173 ++++++++------
 drivers/net/ethernet/mscc/ocelot.h         |  11 +-
 drivers/net/ethernet/mscc/ocelot_net.c     | 254 +++++++++++++++++----
 drivers/net/ethernet/mscc/ocelot_vsc7514.c |  59 +----
 include/soc/mscc/ocelot.h                  |  21 +-
 8 files changed, 338 insertions(+), 292 deletions(-)

-- 
2.25.1

