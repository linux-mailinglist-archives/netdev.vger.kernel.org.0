Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FE2159893F
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 18:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345010AbiHRQqi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 12:46:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344995AbiHRQqb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 12:46:31 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2074.outbound.protection.outlook.com [40.107.20.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3201FBC814;
        Thu, 18 Aug 2022 09:46:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FI88dG391wvkR6sZU3Q4Rl6bPetdysbjUm2VYX6vcr2BKLTNVDcr3aipcIT/4I2qliitk2m3PwlnNhVllf9wujDVOPRu7M++GSWbFVHaKN5wARtf/2uvN38ZZ/GqvwqpTaUIgteA2hwYHOrbeZ9OCfreZwMnEPpEFIGB+Mb51rsI4cbmrTssjvaeFvStNXwL0dfNObigDj3fKjxMtSvkLZil8s0Tk2A0/TMvLGnoK2YBpI4FQl4L6wipf/HIiqEjAnpcYhH2LkpkgvBoN2rqJ17kBOo7m4o0Ytk0uln610GNH/CltI4K4krwWDaBfRv6QFdLETTP2mxTHhNzbkkSwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=maoWyVm524i2Pub5sKkV1hhUqX7iv6rPUNEGkI1Ch0I=;
 b=NAx0Uy90pbQQ1NYpDL9849f3byX42eAHnqkZ3qTrQ6y77hxzOSzUNgBvfibM2d38GP3uwZnLWQAu+0jRNle05SGdTRErhgkAsNPtUsFWEQTBWn6gccDW+q9Cim3RhCMAROglzADzkFF58Fnd+y4Q4ed2EAV4DmLlUBEWpW+qFxG7eH5gUB0SDyv4WHwcmg/ceIZMrn0n+eO7B6O6zngp78hGveYHXToduBPsE6cBK2tiaZpiQB7gLsCymIzIRJtugWwBzYihd05iwhPL26xkB2GUslBNx6UV1s6EdmxH+8SmGNzuv4/iaYRo6AK0tuxA0sGOSDeMRfA/CNHo1s1HtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=maoWyVm524i2Pub5sKkV1hhUqX7iv6rPUNEGkI1Ch0I=;
 b=znUI8diekDbUV+R2VCW882tbA579dLSmvm0MneKcLd7eD+1FEdqMMV8ljuO5ayxdKUF2VbbIFpivGSBtWJRwjxWr0mnVYrTwtfAzXFQz+PdsZ0yoR0ZvNCpoCHu2idJUMv58YwUohaD//YQblIhs3kUt7cTik3Uqb/Ae+wCkBsTXcwwySBUIGoUKkE//1jswXuG3FgcPqEF8lEZT98Srinyh4KLSIib1T268m4JkmjgMYLLDU1GR0qW19XMfTXSy3rEzR4t29RnDFVOkvoE+pEJbJXEmXzMCTHik9lUR46spY310j2J7MeKm2lMp3Jg1LZZETnECcjOND4RIKsotvg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by PAXPR03MB7649.eurprd03.prod.outlook.com (2603:10a6:102:1dc::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Thu, 18 Aug
 2022 16:46:26 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5504.019; Thu, 18 Aug 2022
 16:46:26 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Sean Anderson <sean.anderson@seco.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH net-next v4 00/10] net: phy: Add support for rate adaptation
Date:   Thu, 18 Aug 2022 12:46:06 -0400
Message-Id: <20220818164616.2064242-1-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR07CA0019.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::29) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 074701e1-7960-4599-f69d-08da81393133
X-MS-TrafficTypeDiagnostic: PAXPR03MB7649:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FU6ABQuW7D0OK9zqF2O5EyioUk52/VrHfM7IW0YZDO930wjAXEVLo18yAUknPHd8MIQpaWik2adpqkryvCJob1Jpxdk3gaWTn450fcED314gSttcoc7V7vUFPFPngRboix4tEn6+96A+LMTdn1SPlDi34IEHL1UXP3B0Es/gwHQ4ifZDo7+bpgEQeD+d1Inq1wama02ut4LqNE6AEDBzJET6/esS2mHdwVffMZOznMGBgfIiRcv1Vsb6uXPi2LKksZsB+nX8kM+VE2r1GZgyVyuKWAHkWs8Do50tTGgvFNJHnsZpU3orcwi+0TtYWzlGuFH3i+PxJxIhtmA/i0pg5K2SM36jqTawV/bTOTXPFb8dsgmIaWyv+qTmkpJSHZW5CsZgzuUR/OZ8WoO1eWjzQPwhMKSe4kzqhXgSneg2Y+OAZ+LUhM4GKpqAxltqeatQ8h/pcLeEvphK4R3h/TMe0XBFTW3hfsuzvlQ0e0ss7fLmcIJmuwtltjGsq/RR2bsxxcbqYvCQBngNJ+vOIPdPmUetIjO/Rds8wY0qoZ+aj30ob96U37/6V4EMzAzEsfoqbj/wOGs7CUUnSA+MgwbpaxOxhNfkunNC5uKYMvme2iVVpae0u82orWJdi/TJLe94D9HSXK/zXVQ4qYDQMZEnp5SqkLaomvWl4W16df6ibsrEPUsU0J2XRbWH+qAlp6SjlAfGq/rzNNgfMRaRwyVWUk03hrUl+OxB9e+UDtgb7kmMzYI/ULgsyzG26Rx5tHvBbai6+qaH77OZJbEsqcl8Hd3xExNBaF5FXEIPjy/IsYA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39850400004)(396003)(346002)(376002)(366004)(136003)(66476007)(66946007)(478600001)(66556008)(6486002)(966005)(8676002)(2906002)(41300700001)(6512007)(86362001)(52116002)(4326008)(6666004)(186003)(1076003)(2616005)(7416002)(44832011)(5660300002)(26005)(8936002)(36756003)(54906003)(110136005)(6506007)(38350700002)(38100700002)(316002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Xawif9/+PGSDn44e7eqcB470L/FW4hjq48HG7tT3XHHFAs7KhnJCCxJZtg4f?=
 =?us-ascii?Q?9k2GYSURj0rAph9uoCQA3xMOW/LE+Acl/itMJrK3HJnCIrn2Jd/OeLKN0iiR?=
 =?us-ascii?Q?mBqMK5AQvS9wjSlat1MgxaXTODJrJqX5QzT8olAJib6O7ixke6jO7w8AfNkx?=
 =?us-ascii?Q?SEsDnVshFVwnTbJtC0i0Hlpm60XCdbQJK0WP7khOzq8r0V9Pu5sgasuzITzg?=
 =?us-ascii?Q?Kss4WVVjbp2qTKAh3vF1eLKJSBmzFkEidXpKjFnqPiPI5PaHuaw7dOajM/zE?=
 =?us-ascii?Q?fu1QXR4Kl55E9simdMfIGvbgQ0vZALd05Jil6Uhlh6Fbxr5N2LWY9Bo8X+Kv?=
 =?us-ascii?Q?D9qtKIDiNw9ypQy3H2D9F+i/kT5Cox5zhHQIEOPTGZ850Dqb+hxFoiwom30t?=
 =?us-ascii?Q?wN8l8nv1ey03eXFpb/ycNsRVZCm9sl/kfMlP7hoPgvdT4qNq8e1eV4h2Y8MH?=
 =?us-ascii?Q?IHHw2BV85q99/Ns4TNtq7aJh9E6NhskZo84YQLCOTrK5qyjfjd4mhGmxRh8R?=
 =?us-ascii?Q?zu4MRjkbS7xDliYvwcoK662vRHefIZAv9TgCNNNaLdXiBj+hXXt1BjT37RND?=
 =?us-ascii?Q?OBZ9Vo2dgZn+v1taVdL93Xo4HmoXsUY4EogcMMkPXTUx09IJFiRfnRoU3huW?=
 =?us-ascii?Q?9AguOYNLp7U7DFKQ89bHo0WG3zbx5a/KWgOBpbofuexMO8J32wOHh9r2T59h?=
 =?us-ascii?Q?Oc4mFhlB6C7cW31J9lhkyEFyhOUaI0E+nSUjzkVfgs0AZxGvFTtXwtPqzavs?=
 =?us-ascii?Q?27ynNR1B5c8jOsg2uVJyRzlUYEyiPwT3ahuIfUFcT0eahEaHH/kHJ6El3ATT?=
 =?us-ascii?Q?7AFukM8OQ8kt3gzQpg213lx6AcPwvnuPLnjaaPemEQn5PsfSkKUCFGkVvV/f?=
 =?us-ascii?Q?U6XSLbHqnMqa+lkrx13GzEqeKZLHqiiNfRmnPrbst3TAWOcQLJBuXY52jLzL?=
 =?us-ascii?Q?M0xG3nHm0v0OGX/FtN9oejEgGuX8aksy2iumEj5fAkyCM7G11H7v3eI7TmNb?=
 =?us-ascii?Q?LUo8RjL0oSqDmYBDLoD/+JHOWJEmG6G0QcgbB91lcIqsALKqc9gEyeJRn4Jy?=
 =?us-ascii?Q?qfkGLm+l6j2LrEK+lvOywGPm6vE8h+R3UgZ4PcwikRAzRAgqNyea/GrpS2oc?=
 =?us-ascii?Q?AQovSM1kwrXd49FqHEQq+I3wdHju6F4zpuYjR0vzQxjFZ7UQMc9HwJbbEjac?=
 =?us-ascii?Q?P8tvv9iNDkwfxlet/2fUkVeD8Btw40iilfqi0nfwY0WpGHULxfAYUbtA1Q8h?=
 =?us-ascii?Q?wZJpCN6cITNVZUWk8Cs5tAOK4gRDGfI1M4F1dY/WNbgGJIKcnRWmDXh6tkfP?=
 =?us-ascii?Q?Z1V7TH/4ehE+uusMEozM78FzO85BDkWE1RLk3q8WwErRwMEb/7PVTyeF9ZHr?=
 =?us-ascii?Q?faWshy27uMEI6vaKain7zE8/g126sMW+yYKxMnXY+N4hiOd9LX8+WCgDuGu7?=
 =?us-ascii?Q?8N/4MvkAfTz9MNBmOJcZ0Q2PrE8+IZ0yMWc0zCiTl6v5SPwaNetqlygbklJv?=
 =?us-ascii?Q?zd/aFPqMPyT3Lns14MzKeMmL7X6M5tTeA8dOFuvfaqT0bMKi1saQ8Z3pqizi?=
 =?us-ascii?Q?e78yc63ChqSb24O4DDT8ZhHL7gaNslfrXpqgfihRH1ZR3vPtbXQzbQJH3JHF?=
 =?us-ascii?Q?wA=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 074701e1-7960-4599-f69d-08da81393133
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 16:46:26.6048
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8BWSFpQdd5rXL2KIYiAvYFFQHax+OBlBLrpOcMS5ubIfCbxZ8mih0vnk1KgP+MFIYV5U87ttx2DVSPZsVt3Adg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR03MB7649
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds support for phy rate adaptation: when a phy adapts between
differing phy interface and link speeds. It was originally submitted as
part of [1], which is considered "v1" of this series.

We need support for rate adaptation for two reasons. First, the phy
consumer needs to know if the phy will perform rate adaptation in order to
program the correct advertising. An unaware consumer will only program
support for link modes at the phy interface mode's native speed. This
will cause autonegotiation to fail if the link partner only advertises
support for lower speed link modes. Second, to reduce packet loss it may
be desirable to throttle packet throughput.

There have been several past discussions [2-4] around adding rate
adaptation support. One point is that we must be certain that rate
adaptation is possible before enabling it. It is the opinion of some
developers that it is the responsibility of the system integrator or end
user to set the link settings appropriately for rate adaptation. In
particular, it was argued that (due to differing firmware) it might not
be clear if a particular phy has rate adaptation enabled. Additionally,
upper-layer protocols must already be tolerant of packet loss caused by
differing rates. Packet loss may happen anyway, such as if a faster link
is used with a slower switch or repeater. So adjusting pause settings
for rate adaptation is not strictly necessary.

I believe that our current approach is limiting, especially when
considering that rate adaptation (in two forms) has made it into IEEE
standards. In general, when we have appropriate information we should
set sensible defaults. To consider use a contrasting example, we enable
pause frames by default for link partners which autonegotiate for them.
When it's the phy itself generating these frames, we don't even have to
autonegotiate to know that we should enable pause frames.

Our current approach also encourages workarounds, such as commit
73a21fa817f0 ("dpaa_eth: support all modes with rate adapting PHYs").
These workarounds are fine for phylib drivers, but phylink drivers cannot
use this approach (since there is no direct access to the phy).

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

Changes in v4:
- Wrap docstring to 80 columns
- Export phy_rate_adaptation_to_str
- Remove phylink_interface_max_speed, which was accidentally added
- Split off the LS1046ARDB 1G fix

Changes in v3:
- Document MAC_(A)SYM_PAUSE
- Add some helpers for working with mac caps
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

Sean Anderson (10):
  net: phy: Add 1000BASE-KX interface mode
  net: phylink: Document MAC_(A)SYM_PAUSE
  net: phylink: Export phylink_caps_to_linkmodes
  net: phylink: Generate caps and convert to linkmodes separately
  net: phylink: Add some helpers for working with mac caps
  net: phy: Add support for rate adaptation
  net: phylink: Adjust link settings based on rate adaptation
  net: phylink: Adjust advertisement based on rate adaptation
  net: phy: aquantia: Add some additional phy interfaces
  net: phy: aquantia: Add support for rate adaptation

 Documentation/networking/ethtool-netlink.rst |   2 +
 drivers/net/phy/aquantia_main.c              |  68 ++++-
 drivers/net/phy/phy-core.c                   |  16 ++
 drivers/net/phy/phy.c                        |  28 ++
 drivers/net/phy/phylink.c                    | 279 +++++++++++++++++--
 include/linux/phy.h                          |  26 +-
 include/linux/phylink.h                      |  29 +-
 include/uapi/linux/ethtool.h                 |  18 +-
 include/uapi/linux/ethtool_netlink.h         |   1 +
 net/ethtool/ioctl.c                          |   1 +
 net/ethtool/linkmodes.c                      |   5 +
 11 files changed, 439 insertions(+), 34 deletions(-)

-- 
2.35.1.1320.gc452695387.dirty

