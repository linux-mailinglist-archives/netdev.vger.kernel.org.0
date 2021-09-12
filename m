Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFCE3407D1F
	for <lists+netdev@lfdr.de>; Sun, 12 Sep 2021 14:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235097AbhILMLB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Sep 2021 08:11:01 -0400
Received: from mail-db8eur05on2061.outbound.protection.outlook.com ([40.107.20.61]:24243
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229635AbhILMLA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 Sep 2021 08:11:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=koqW7DAtBVUofxHOVjFIha4sISckO0ExGIRGgr4/5FYBwuAbHCtdVQ9/+fpDIRgmCzlgKKoSzI2QMNE9OdVfIxBGqjJevRFvNp8qL3G3lCg4/RwqBlqjs3w2E7dgMiY9ijv2HRmdVWswog6tiYCFHsV9x72WpXq6tOIWK0IkLzkpq6A68HxjpOPmFhirzSQWChRL6z4dwt/WvpgBrzgR1TZWRp9qR92E3/AaIFS73MyEyMnGYFcE+OGuMkr/KkMT6CVOjU5QD0GlBpVzwoXKF4bl8OmN9RgM4B1YVF6Uxb/bSZ/q/BhnYITaeocpUTuWEr+NcypHUEwC1auku4wZVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=HtGlGFm5gtv+2STUTI6SBYrj2xowlIwdh2cbpl7CkL4=;
 b=JANRhGjg0m8WnsZErJPirjy3KWi//fYtEoE0XXMgBt7AmG3AMfFYMkIHGVZtZK3GRFTZwKFHlqe+T5kNdWFky54cfyT38QxmiGu4jEYTopGUP4cgO7l/h8HhpBdrg+GJYViAfsZoPCnr6keTtnCGT4Kd3ONOIM/PgyCCQKJ6Rd1LXNGibcgJAhJg1qbavi4z0ADArzZmeD/moDqHU/9TeoCKZSvTapjGLHy+oL/XJNdyTqpY/SMX2aaVo9Kt01v+99VJSyKMP8neIi3c/nGPYigP86rNQymcmJ50NUijPK+oBqRFJHGAGm/k45KnTCM3Igga7TltpAAN0JPXcLSAyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HtGlGFm5gtv+2STUTI6SBYrj2xowlIwdh2cbpl7CkL4=;
 b=La+rl7rLdxTHIZZYzHKXLUlTwD2GSjMSiSNGA8BTKZAJfyEBpZ5wTHaVcwx07Obk2jXKFx7/4yySav8Uv6jlH2WFkVhcYxnguW+BxjYLJ8g3ZZciPVZdPwYkG11Z0v//wvECzzo6ViMSiWXZOoiwVbgMx7ERnRfRwlY043HUC6E=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5854.eurprd04.prod.outlook.com (2603:10a6:803:e2::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19; Sun, 12 Sep
 2021 12:09:44 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4500.018; Sun, 12 Sep 2021
 12:09:44 +0000
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
Subject: [RFC PATCH net 0/5] Make DSA switch drivers compatible with masters which unregister on shutdown
Date:   Sun, 12 Sep 2021 15:09:27 +0300
Message-Id: <20210912120932.993440-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0173.eurprd07.prod.outlook.com
 (2603:10a6:802:3e::21) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.78.148.104) by VI1PR07CA0173.eurprd07.prod.outlook.com (2603:10a6:802:3e::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.9 via Frontend Transport; Sun, 12 Sep 2021 12:09:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4a99e9a2-b6ad-410c-4d97-08d975e634c8
X-MS-TrafficTypeDiagnostic: VI1PR04MB5854:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB58546369401665C2D5166B83E0D89@VI1PR04MB5854.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y9ZKruYCZ+uaWlqdnCeCdUYAyUNjytJbxMvzAg2AQf5rwlXzfMKTCILRE24Z4VtQjOb2OoPknkt1hgeEBAGT88kdKT09aC83NAS71pj/VvC2eJrrK1sP5wpaC9Cpx3ie3i3XEyYGbJrLS4WMQmPUX1N6rYvDCTFgcO6qJcsj1F8es1cmPslEdxnPEs0t81bSKY1uL2FPeE/5Hv0poMPXrm1YRXVKmQlzRxPTGrOPzVPQTlosnsXQ902WM56xwCTF/s2Enz8zfXDVTmkEAaaS4h9RS4ap8LNQRczuQTP3ndYP98DTV+bETOG1lfiKy06gwiH5BiCikPHRzvdBPMZYYLxvSQhQvgu7herIZ/2LcHK7EeKS436Li/bLoIAEU5jmhKCHRQCg06hGgmw8B+SatsEqAdfhRKwkOk4EOyI8/jekB3TM0dErl+ALpuIAM7aiXOtu/QCEkDIBnZ6ny/fjx1u58WuN/Xyp4r1nEH0siaSbheJxzZr8cZCX90bMRZaWBcywW/hfVk+SwY6WikHzv7v1s+IMWpz2br4YUNUXU6aiCIhpPb5KfP1rOqlHgIZJAZ30IpKF628UCDHDRcV6N2J8CGqFQxGB3Yfsle3WNxp7g8E7nnE0lEo+c5PvazCdDK0LsW57xZgEIneNXE3swYYiB5sOezEvo5KbHhdVAms9An47Rv/oISr9HeOUDlw0+a99O+17fv1sHs9TQQ0Vuj1LzxE1Z3s2Nl9eIUGg3mwSkLnOG/h4EOTqxye+6yUX1oioiV+xe+Rk21/z7HGTMy2hv2vWBB8MXB87LUNGWQU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(346002)(136003)(376002)(39860400002)(966005)(316002)(83380400001)(4326008)(6506007)(86362001)(6512007)(26005)(44832011)(186003)(38100700002)(8936002)(5660300002)(478600001)(54906003)(2616005)(1076003)(7416002)(36756003)(6486002)(66946007)(2906002)(38350700002)(8676002)(6666004)(66476007)(66556008)(52116002)(6916009)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hdzkKVJdJBht+q5Mv4ftzz7jKRkmPvI7PPSVm0oC/xdCatL57oiPyDt1JsQJ?=
 =?us-ascii?Q?LJI6sP84nH8vIaXTPHYrQFyeGNYMFhWi8Eioe8K55EZOSeRNHQBIXGm74Lte?=
 =?us-ascii?Q?Ah8WZ+RVYGJv4UMSZkK29hEgfL5o5lTlTs+7i2eg1nVqTJjEngfv63Um4ahF?=
 =?us-ascii?Q?q721afrw8JWsJahNQucGGvTymHQM7byvFdHcEm6GR2pwMTbM5vht/uZjDyE9?=
 =?us-ascii?Q?uz/Wlk6N9PF0kpYWWLYZMXkBf+apxPE5YPXWXsuB779znBwRFBTuDRqXx/u1?=
 =?us-ascii?Q?YbNllSyIw6uaXjofOsaRpsWhmRx3XsYLtBVL9rUZpczhbYW88Iy1pCglK3TK?=
 =?us-ascii?Q?jyFlXY3HvPwG3p/bF0PsSO11i91nRUe4BrkJ7U023xSaewf4yagOXlq0EOid?=
 =?us-ascii?Q?wZwPU9OCS+7f8r6eHhraEWneRS5/4vr5Quv11RYwb1zY73op8TuEAMR+/H8C?=
 =?us-ascii?Q?tHF3X8K1R5pLUfqT+UI1snAgGPGYqIUO2r/u7zfb8B3HcqvniwE+XN3a6Fvx?=
 =?us-ascii?Q?OWN9cuRAn2S++/zzl2pONtiOvcREN13k/EIroEYxBl/VWRBBePLz3cq9eZiL?=
 =?us-ascii?Q?SoduvxoxVDmmA2rBsWKrT0H6dYx5uhEI5rxsV+UTFmtwj8HnambAMpP0SYVX?=
 =?us-ascii?Q?17vs1/GdexG+UwahyY5RUtMKwSr/u3fUK7FnSzT8eIquSRXC/VYW5TUcMELo?=
 =?us-ascii?Q?txX1DhqqliSnG4O8elh5bMlaNlCujV3S1PhpO15UKYCUFYRdMccuDAYKMAXu?=
 =?us-ascii?Q?s3AANJwDcgvWirFNlLmYZLx4eTaPiSoQQjGNgdbC5/qKMmfJ7vSk4v5384Fd?=
 =?us-ascii?Q?n+pReNjJe/pzGivNDr7TS9Nwed07ni0IB8QvPLsBxCjJB4+4+feuj/OFnPMU?=
 =?us-ascii?Q?iB0I4RqTEvikfQraGXO6obSdjZ46Ym21PqrMowm85O0SdVtsidqGIglcLUZj?=
 =?us-ascii?Q?1+kXvLp4HRCok5hN71SUbWWqR8+MesjJR8dNPtB2vnLbosn8rctGnOB7U8NP?=
 =?us-ascii?Q?Jesan5LUCEnpTXJznFructNhQOoHJtJENdnt5elooUvHhQzYlnz9CpLjQ4VN?=
 =?us-ascii?Q?+iFNTHfUQCHvMOxE7fm02ZPMqNfC2J4VLiTyWYWVOsiBS0iRhRJ8AywpeaoD?=
 =?us-ascii?Q?wat2s2vdHU66WZ05ZwIxyZdatFeJtWS9ADz+ZyRo464Q0AA4hJtTq2sQwetl?=
 =?us-ascii?Q?ELRkqddAtTwT7dAZ+rqX7Nt22omxCpE79KQaEyt9gfqBsnd2DjQwFsnLclUr?=
 =?us-ascii?Q?wYbD6vcnZCCLEHC8RhVriFU4AxO8TrVPBwATUdpyM0LR7CLpwLt1w1xPbgcH?=
 =?us-ascii?Q?ZaC5NYfBoa6XXZCb4PhdwXgr?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a99e9a2-b6ad-410c-4d97-08d975e634c8
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2021 12:09:44.0314
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3rrFWiJGDqbhB6IHogXb/rUw53mDeMV3OFSasyysB4g5TEXkk/6ltBfykYM16QiuCDU8ZGaybg9fq2/Fu0VXPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5854
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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

 drivers/net/dsa/b53/b53_mdio.c             | 21 +++++++++-
 drivers/net/dsa/b53/b53_mmap.c             | 13 ++++++
 drivers/net/dsa/b53/b53_priv.h             |  5 +++
 drivers/net/dsa/b53/b53_spi.c              | 13 ++++++
 drivers/net/dsa/b53/b53_srab.c             | 21 +++++++++-
 drivers/net/dsa/bcm_sf2.c                  | 12 ++++++
 drivers/net/dsa/dsa_loop.c                 | 22 ++++++++++-
 drivers/net/dsa/hirschmann/hellcreek.c     | 16 ++++++++
 drivers/net/dsa/lan9303-core.c             |  6 +++
 drivers/net/dsa/lan9303.h                  |  1 +
 drivers/net/dsa/lan9303_i2c.c              | 24 +++++++++--
 drivers/net/dsa/lan9303_mdio.c             | 15 +++++++
 drivers/net/dsa/lantiq_gswip.c             | 18 +++++++++
 drivers/net/dsa/microchip/ksz8795_spi.c    | 11 +++++-
 drivers/net/dsa/microchip/ksz8863_smi.c    | 13 ++++++
 drivers/net/dsa/microchip/ksz9477_i2c.c    | 14 ++++++-
 drivers/net/dsa/microchip/ksz9477_spi.c    |  8 +++-
 drivers/net/dsa/mt7530.c                   | 18 +++++++++
 drivers/net/dsa/mv88e6060.c                | 18 +++++++++
 drivers/net/dsa/mv88e6xxx/chip.c           | 22 ++++++++++-
 drivers/net/dsa/ocelot/felix_vsc9959.c     | 20 +++++++++-
 drivers/net/dsa/ocelot/seville_vsc9953.c   | 20 +++++++++-
 drivers/net/dsa/qca/ar9331.c               | 18 +++++++++
 drivers/net/dsa/qca8k.c                    | 18 +++++++++
 drivers/net/dsa/realtek-smi-core.c         | 20 +++++++++-
 drivers/net/dsa/sja1105/sja1105_main.c     | 21 +++++++++-
 drivers/net/dsa/vitesse-vsc73xx-core.c     |  6 +++
 drivers/net/dsa/vitesse-vsc73xx-platform.c | 22 ++++++++++-
 drivers/net/dsa/vitesse-vsc73xx-spi.c      | 22 ++++++++++-
 drivers/net/dsa/vitesse-vsc73xx.h          |  1 +
 drivers/net/dsa/xrs700x/xrs700x.c          |  6 +++
 drivers/net/dsa/xrs700x/xrs700x.h          |  1 +
 drivers/net/dsa/xrs700x/xrs700x_i2c.c      | 18 +++++++++
 drivers/net/dsa/xrs700x/xrs700x_mdio.c     | 18 +++++++++
 drivers/net/phy/mdio_device.c              | 11 ++++++
 include/linux/mdio.h                       |  3 ++
 include/net/dsa.h                          |  1 +
 net/dsa/dsa2.c                             | 46 ++++++++++++++++++++++
 38 files changed, 539 insertions(+), 24 deletions(-)

-- 
2.25.1

