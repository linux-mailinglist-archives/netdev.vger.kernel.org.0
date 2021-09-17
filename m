Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1152140F957
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 15:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344427AbhIQNge (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 09:36:34 -0400
Received: from mail-eopbgr80082.outbound.protection.outlook.com ([40.107.8.82]:4832
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244662AbhIQNgN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Sep 2021 09:36:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n+PlaIi9j8fWHPH3lEECH5H/AcUC35WfCZBeq8FrbHo3+Yr9w64jezNZfgrKLwPBWyyOtkw2EOwUOLU8wA/R2AUyJl1xFYfsTHRGQXrXH0vKCk1pVYBEuy35p0V2804bZlNqojvXLGGxPmUaMqj62chZWyXYZfZn5RS15EX8irw/uk9U1NPhm7pbTuU4fIUv4Vd3Z6hDUmfRXqiGIF8muvrF8mG7ZrQ51nqZ5TWKgeTYuW1Shqz0nn0r7AcpClDIG3vJoEXh6oH9lXrl+S1oaKjIoaGI9+5fILUgpJRvIJ2CrbmP4dD5s6IafqYlc2kmy4J0h503VT7axWvpIfDgEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=LwJ59Yi5GcAxZQXwokAFNKOBXp7/+wq5dkINbobpu/0=;
 b=k8CwbDBNpMcBdR4wwCXeF7JVfL+dvY0DsCxngiyO8hZpQMEb94AI62eEIeEesd9csdswGjS8YBRH5JKQaNRFGBAuAwpD9xLYOvpUtAv61t2guNCqIQ1pJOW2YsP0R64J3At/ezZJfmIUZO61ObFxIp5+pKhsSjiIm/HoVzUnEL4acppcCTKC3/yA0jurybOwIhdSbAp39faxfwZzNYwXnyUnqnKESJpJWGNvzgm5QVl9aZl0vb32aCPjSYk/NCGlNanIjmR65IxME0g3b10ZL1ceOMr29XrO4XHBWI/v38tzFKWenwqaVRMZa9b5c9QFjjUx62wDtmwYrjDfN4jlaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LwJ59Yi5GcAxZQXwokAFNKOBXp7/+wq5dkINbobpu/0=;
 b=H6jI6dAH8UKFTvd246b2+o+TBnns/uIzpJKomuHQIEkrzzJNkak07A6SzdFUP5FcuX4L/cJIEeJGLCJjg6r+PzVf/ORI1J1uLTuroJe/1yLB46BtkfOht1Jws2XuwKv2mylJi7MS609o6fvulhK1AUBlbMuMkedjKbnLlbIEBgw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7341.eurprd04.prod.outlook.com (2603:10a6:800:1a6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.16; Fri, 17 Sep
 2021 13:34:50 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4500.019; Fri, 17 Sep 2021
 13:34:49 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        George McCollister <george.mccollister@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>
Subject: [PATCH v2 net 0/5] Make DSA switch drivers compatible with masters which unregister on shutdown
Date:   Fri, 17 Sep 2021 16:34:31 +0300
Message-Id: <20210917133436.553995-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0199.eurprd02.prod.outlook.com
 (2603:10a6:20b:28f::6) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.78.148.104) by AM0PR02CA0199.eurprd02.prod.outlook.com (2603:10a6:20b:28f::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Fri, 17 Sep 2021 13:34:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f0877e87-c970-44a4-c9fa-08d979dfec33
X-MS-TrafficTypeDiagnostic: VE1PR04MB7341:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB7341A23347C4BCA4090AC5AAE0DD9@VE1PR04MB7341.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pA5rVuGRVWwTPFsCruyyEbMKABYdPTfH+tVSetcF+tKfBdeCKBF9hXbWEtDUp9iY8CXHC31CgFvN4zg8p19BMNBAW+t6uNZC+kHREhGR59GhvA5sc8/YSfPM6sQISKeKeTNy4KN6NzrOXMv0nBbibsejqr17Eq83orkANDH6itayQ0ACxIdhdYuPhm+Bn9vM7kD2MhFGyPRxa1ElOAFtVucfR4gGk1nqCYy2L/xofiZxZCu1gJD4JN5r4OZ5woKCsKKkSNKYHy8bBwctFI3Dmj1Z8EnouN3mEh7TwV+CFmMlLWfXV+HYjr8OjDGQGODlVUUrC5rqcUabGqe7gkwUMWf7wsLsrt8HHzfHSmiytdGvE0qmAUOtI32SyBswdcq0cUADZE3rK9y2lxoinTCsBX18shn0K1mwJALenP4bXjLFKE+6EviMdkHLDORIGwGLshrstkNK70BQSmn9cfE3VOmTuAQkjBmOiQG8pat/Gfjw/S60sIeRa0e0o5HAlxMlQ3KYmRbYU3b2wtawc+5Ajil8Dc/DLNrEyEm7MFr6Y9E+gF5hN7QuKI1a1na3znpVD/dkoLO4bqn0StZu/nhOkvH/oRywjpm905yeA3ax6fQZwkDMWu4BdIChTwXeoTyNldSSVsupLMRN1lRKobM0z9nnNz22agiih5dxfVbFBe9azgk5EY1t+piEQFa5/aHJLNCM372anugfR1p6oAJ9E6/q6ynOfsBdpO2Qa0k2T1qibCZENGNYIz/pd94Goa4o4W/Cc3Fs1nFs5VdgyLpJkn8eBIAV2A8QXnHfPp5yLtM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(376002)(136003)(39860400002)(346002)(54906003)(316002)(38100700002)(38350700002)(36756003)(44832011)(2616005)(86362001)(6916009)(66556008)(478600001)(6512007)(6666004)(966005)(6486002)(8936002)(8676002)(26005)(1076003)(5660300002)(6506007)(52116002)(186003)(83380400001)(2906002)(4326008)(7416002)(66946007)(66476007)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XMMrQTp5K6ZGssd76fTOirnwT4YE75zHdQPyA562bCQikv2KIKRNtn5Lbp85?=
 =?us-ascii?Q?lQZ+Ra/JvznuqMi6gx1cd/so/rBdRL7zQ6UkiBeZvfnbNdiHNIS3ToerbFIu?=
 =?us-ascii?Q?d07ZQgdzcFoJXoJeXNhTEmczYO2HmMFZS6VOw7axjStRwLnxE8v4MxssvGvf?=
 =?us-ascii?Q?wA1/0/Tr/Dvw3iTwcLwWyNKQqe4pTWT2P+bVKncx09aiY4kSXcCElswSXhdX?=
 =?us-ascii?Q?SFAX/gldmeXCwVfZ56vgJShm/JioyHgsPlpuof88u0n604nlBsLrOT5aMly2?=
 =?us-ascii?Q?Pyesw97EQPY+RoPTeTPts3lbEckWI+lUzktg+PCNRRO+OfCIngX338aml75I?=
 =?us-ascii?Q?r1WWBt5dkEYnLMAtSgZewlJprefle09vETlltwpH9Lzk0z/dFy9wbcwllv+6?=
 =?us-ascii?Q?oVdEqpzUiOc0IW3OZRZyv8pOGy+c4rxQxCjH/PDEgDG3v8TkyFMY4ZywnlXN?=
 =?us-ascii?Q?qscOpFBJYelHh5Erabozljhj6yvsdWq5SCgE/9XWUxbcAMVHTO7I5eYIm1Qg?=
 =?us-ascii?Q?CrXOM5Nx86Jclnl0GTdDA2R8kjnB1aoJRO1MUFXrn3LOdzQubPteuxgpm169?=
 =?us-ascii?Q?8pckwaXCICOR6Y9EOAXSrmbusRDMTp1+XDpimzG9Y5iAS1mWcd8pYeP0Q+/G?=
 =?us-ascii?Q?67xJA7sfblkTFYn/BKY2RfFGWd2+YWeL1DTZe1g9rOAGBqZMHYGunTHl9U7Y?=
 =?us-ascii?Q?iUqZRmtbGnr7/Ryh6DD3itndXvQoueSr01MHGJjp3DSG7pDGeECOOTXDhNjb?=
 =?us-ascii?Q?rsmN8SdUBoq6FQbw27RZH6nEoRTX8HJpm6Vhmv1sP/4951kat4/8VQfysZ7/?=
 =?us-ascii?Q?Wt+//mMxAthx0B69dtXx4forJiBul+QHg+7hGsFaG+wz8WucX8q5fdhYSQyz?=
 =?us-ascii?Q?80Z7YckhoDvZJ6yxrHitAYrYsZR+oG//lzYdDDRS3qySHhdQ2xF3UN1n+9NQ?=
 =?us-ascii?Q?lZQ3hDGPgIInKtrzSFFF2sK9iFejbX7A7HJT01++EOwsQt0zs5wLBanLVHzQ?=
 =?us-ascii?Q?vF6TxFOTrK9pTHusVMXPw64ZUj33aq/QwcBR7FD7bWOrQAPICMhul/Q1LcLd?=
 =?us-ascii?Q?wKDXfMvnubQk46Hytfn6AiOJ2PcakDXu3HeRAwxSfzB9flRcr9fY0lRGi4aG?=
 =?us-ascii?Q?gvcl7SPCCSdKmSWp+ni6weg9v4w0Zs9o2aq614ObTLoOU6OtFI9B2nSrDTcw?=
 =?us-ascii?Q?Ja8cA93f6phLPB15RKe58S/lq2o9A+hHOxziYczxuAuu1JBBy/DLHJOb+1QS?=
 =?us-ascii?Q?1CdEBvEYO+XK/oFvFqMqJVjg2PSlx36NRFnfZsF42zgLPZAKKNeFgH3QK8vu?=
 =?us-ascii?Q?qzW/QvAZkXly6BF8723Nn9Af?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0877e87-c970-44a4-c9fa-08d979dfec33
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2021 13:34:49.9119
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: koGjziAXM2XA+C6m/NmJ5uFamo/WrHSw+cyIKDNp9nijr4Q6q7CdUOGcyeJUx0UwRWG8dbzZtviwcAkT90vb3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7341
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes in v2:
- fix build for b53_mmap
- use unregister_netdevice_many

It was reported by Lino here:

https://lore.kernel.org/netdev/20210909095324.12978-1-LinoSanfilippo@gmx.de/

that when the DSA master attempts to unregister its net_device on
shutdown, DSA should prevent that operation from succeeding because it
holds a reference to it. This hangs the shutdown process.

This issue was essentially introduced in commit 2f1e8ea726e9 ("net: dsa:
link interfaces with the DSA master to get rid of lockdep warnings").
The present series patches all DSA drivers to handle that case,
depending on whether those drivers were introduced before or after the
offending commit, a different Fixes: tag is specified for them.

The approach taken by this series solves the issue in essentially the
same way as Lino's patches, except for three key differences:

- this series takes a more minimal approach in what is done on shutdown,
  we do not attempt a full tree teardown as that is not strictly
  necessary. I might revisit this if there are compelling reasons to do
  otherwise

- this series fixes the issues for all DSA drivers, not just KSZ9897

- this series works even if the ->remove driver method gets called for
  the same device too, not just ->shutdown. This is really possible to
  happen for SPI device drivers, and potentially possible for other bus
  device drivers too.

Vladimir Oltean (5):
  net: mdio: introduce a shutdown method to mdio device drivers
  net: dsa: be compatible with masters which unregister on shutdown
  net: dsa: hellcreek: be compatible with masters which unregister on
    shutdown
  net: dsa: microchip: ksz8863: be compatible with masters which
    unregister on shutdown
  net: dsa: xrs700x: be compatible with masters which unregister on
    shutdown

 drivers/net/dsa/b53/b53_mdio.c             | 21 ++++++++-
 drivers/net/dsa/b53/b53_mmap.c             | 13 ++++++
 drivers/net/dsa/b53/b53_priv.h             |  5 +++
 drivers/net/dsa/b53/b53_spi.c              | 13 ++++++
 drivers/net/dsa/b53/b53_srab.c             | 21 ++++++++-
 drivers/net/dsa/bcm_sf2.c                  | 12 ++++++
 drivers/net/dsa/dsa_loop.c                 | 22 +++++++++-
 drivers/net/dsa/hirschmann/hellcreek.c     | 16 +++++++
 drivers/net/dsa/lan9303-core.c             |  6 +++
 drivers/net/dsa/lan9303.h                  |  1 +
 drivers/net/dsa/lan9303_i2c.c              | 24 +++++++++--
 drivers/net/dsa/lan9303_mdio.c             | 15 +++++++
 drivers/net/dsa/lantiq_gswip.c             | 18 ++++++++
 drivers/net/dsa/microchip/ksz8795_spi.c    | 11 ++++-
 drivers/net/dsa/microchip/ksz8863_smi.c    | 13 ++++++
 drivers/net/dsa/microchip/ksz9477_i2c.c    | 14 +++++-
 drivers/net/dsa/microchip/ksz9477_spi.c    |  8 +++-
 drivers/net/dsa/mt7530.c                   | 18 ++++++++
 drivers/net/dsa/mv88e6060.c                | 18 ++++++++
 drivers/net/dsa/mv88e6xxx/chip.c           | 22 +++++++++-
 drivers/net/dsa/ocelot/felix_vsc9959.c     | 20 ++++++++-
 drivers/net/dsa/ocelot/seville_vsc9953.c   | 20 ++++++++-
 drivers/net/dsa/qca/ar9331.c               | 18 ++++++++
 drivers/net/dsa/qca8k.c                    | 18 ++++++++
 drivers/net/dsa/realtek-smi-core.c         | 20 ++++++++-
 drivers/net/dsa/sja1105/sja1105_main.c     | 21 ++++++++-
 drivers/net/dsa/vitesse-vsc73xx-core.c     |  6 +++
 drivers/net/dsa/vitesse-vsc73xx-platform.c | 22 +++++++++-
 drivers/net/dsa/vitesse-vsc73xx-spi.c      | 22 +++++++++-
 drivers/net/dsa/vitesse-vsc73xx.h          |  1 +
 drivers/net/dsa/xrs700x/xrs700x.c          |  6 +++
 drivers/net/dsa/xrs700x/xrs700x.h          |  1 +
 drivers/net/dsa/xrs700x/xrs700x_i2c.c      | 18 ++++++++
 drivers/net/dsa/xrs700x/xrs700x_mdio.c     | 18 ++++++++
 drivers/net/phy/mdio_device.c              | 11 +++++
 include/linux/mdio.h                       |  3 ++
 include/net/dsa.h                          |  1 +
 net/dsa/dsa2.c                             | 50 ++++++++++++++++++++++
 38 files changed, 543 insertions(+), 24 deletions(-)

-- 
2.25.1

