Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E28242A373
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 13:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233691AbhJLLm7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 07:42:59 -0400
Received: from mail-vi1eur05on2084.outbound.protection.outlook.com ([40.107.21.84]:31201
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232665AbhJLLm6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 07:42:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L3s3UvNngXra1mGrk8GkgIGYqaLXSwoeWa8lg7Ugof3696CVg8LjD0OcdqcT1J0/sE6SWxxDg96H1aItzicbyaAsgzSVpY9SoHAfX7LalfPfy3N9IjqjI7oZzYs792T5g0q2O+lrWHOnsI6DR/0L4AdcNmhOorUg+BezNgFTAxTkM4e5BajXzTmH1Aodm0HxLrGZyapJa8w0U5O0MmZA+L5rinNqJKAoWOUEJ3M0BO0woMuMi4m0G6RDbgysW+lyKOUA9rn15iUt3S82ZpkR6RQGvIMZzgT+XS8MNO1oU+HLf4z2RX7VVuA4Uo/dsbBwZ/NWgGUmufRUbxW4HkrOFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/lOtI4JeizQvv6haFOE5V2QgHLBTYFHSE+1TRxkNElk=;
 b=PvOvAjphJaLDG4sxRuT9jft0Sti4vipu42RkUiMhm/TVyKfrsx9z6QervNosD+FLGjUGpUsFG71mrSdE9JexJhGv0Ll3l1HW78qflgCO8/cbHYHbJznnwrrms5+7gerQCJ/LHJ9KXqD5mLR7VMpcz4B6WqFTjGzOu+KNfHRVeMwzgTom7d+NxEsjj355xvS4jmmGUKk1Dbxhq6dXV34OoTkJ93Vsow14g8g+lTi8Y+wXowljoQntTHjKKuAVhu2jmNUqkZSRFDs6ZnAXBsKig86tmSXHXI+FJnwGoanScGBF8+6PZPRQUYtZJ9H4pwjNWemJfWpJOHJ2A9b3NqEBnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/lOtI4JeizQvv6haFOE5V2QgHLBTYFHSE+1TRxkNElk=;
 b=qZml2pVQyOvIFiGRUMgepkOm979aUXHHUzJelgTGYrQwM2WA3Od1gcmzkyN6B9GEGH2q9RsVb5Gc3Qp4VU1AvBOmlXdhZIjOGocg4uO5ou9l8QEPJCAiIwo/l6wMFIH6dmwYsZgl/mx4ARXEvWyNYYhDL03g2Eten8ozksVLgIU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3709.eurprd04.prod.outlook.com (2603:10a6:803:1e::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Tue, 12 Oct
 2021 11:40:55 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4587.026; Tue, 12 Oct 2021
 11:40:54 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, Po Liu <po.liu@nxp.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Rui Sousa <rui.sousa@nxp.com>, Yangbo Lu <yangbo.lu@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH v2 net 00/10] Felix DSA driver fixes
Date:   Tue, 12 Oct 2021 14:40:34 +0300
Message-Id: <20211012114044.2526146-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0150.eurprd07.prod.outlook.com
 (2603:10a6:802:16::37) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.26.53.217) by VI1PR07CA0150.eurprd07.prod.outlook.com (2603:10a6:802:16::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.14 via Frontend Transport; Tue, 12 Oct 2021 11:40:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b339fdb6-9156-455a-cd94-08d98d752679
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3709:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3709FF911C8FF9D160444CBFE0B69@VI1PR0402MB3709.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1vYh8G14/QM3jnjR1sxSW/T34DfOHXTBk/W2uA4gW3Qq3zYcGLD50cOvY/qgrMXOP1/dGrutGT4oVuoxtJTImnE3+wd/CZfBy2tDhUtbgRiQZV06xQaxG3AKWrCZ39JYRnWEBc3fWbpxgB7yzN0MwnzdjrPtKbdIEJbxkvDHr+XhWQc7kTqpdD0NiW9BfpAyCJMN0VDyjQ15CDJizmMgKXCzzSblPBT1UycfquH/CkGUmOjJVW0SsGmEXI8tFo0cGBTgKuuD83EIXeA6cCxPUP+QZwDU1J3RX55yMaNetRwKcVQV7lVklxArcScY1ljizzVcC5ahl/44Lh5LFIUBzbZuA9SItLfEBqlRbRwp4WXj+kms9Bh13XpvNmiAwTpD6zEd+57mcbt8KcY2DsOqkUjh4FGh+nra5cICHGpE8g0URyMEbsRRSFxfqhsxXxvZHPM37JRtIgvwtxBcIQ/ps2X/Pqlv3pk9BMdkXShV+7EnPeRIuzZlMZwN5VonAPKSJPJd0ISTZg5lu9q+KsrvB7KjCLtw4NXLFq5ouuhwipfXfeA698lywMmeAnMcA+gacCmbcS0u4nR3yU5pY9uFaOkQneGsAqMChu164WvtNgHrHmWxX0Kw5PcCsZVCrIacT+za1sFOecP+9K29Qy/JhTSBa69QGVFafD6597J3NblX23Omfdw547u/bVoguDqtq0cdvyZNBG/4jHiFuL6g4ZH9bcfHh1NqoMB1EMOWvDRjelAesK+RTYLYEJmsjYoQBzr4tVu4cTCfzCwKkd9L6481qm5/rN1Oz9o5JkSMPoc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(2906002)(83380400001)(2616005)(44832011)(38350700002)(38100700002)(956004)(508600001)(52116002)(4326008)(6486002)(966005)(6506007)(66946007)(36756003)(6512007)(1076003)(186003)(26005)(8936002)(8676002)(54906003)(110136005)(6636002)(5660300002)(6666004)(66556008)(66476007)(316002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lu/mqzMhmdOwYU0tWtLCAGFc8zPqM17yi7ibUZf52Ywe/HhPmeTbiiKM6UjQ?=
 =?us-ascii?Q?MDxfn5ZVd+hDIIqoePKjMqEn+NHnFryxdvXjCD7J8KnwyitJzsrEAlihx1P6?=
 =?us-ascii?Q?96BRUczyhBZI+ImGSHNPxhsvCgPr0Micrv31cJaSRdqwQ9eJ79yz8RoOA7Ng?=
 =?us-ascii?Q?550Vwh7cWkXemw03X4af9ipLGLOS3cSFrkAuEcfNgq5rWdiCYM2T2Aw03ZgT?=
 =?us-ascii?Q?W6R1gtVJsmtsd7HTKgCU+m0thWKGEq8GmDDGxRvfJrHDWM6fG8LZcSW7MfsZ?=
 =?us-ascii?Q?YWfHh/EvsvNmam4H4lrAPcLiaaA3u6FbFb2tah1GhUGIRSKQj4qjmYfm+DzN?=
 =?us-ascii?Q?ujoe/4t83jnNd/433l99rH8RacUFT7pze4cDfagDmo1J397XCpBk2Mb7FhlR?=
 =?us-ascii?Q?cvpv8VTxTU6BLhGZd1w5w0N+Z1KpAEjDFwYnJhXFai3/+679r5AsBeWIWhkf?=
 =?us-ascii?Q?l5DSop8bg6JToQ1i8yFTxwOAzisn9ijvCyY79sms+4jaGhbKARMpmJ9xw2Pz?=
 =?us-ascii?Q?hjfwxw5Uz1F42KCbiIeC/XWnt6sm7flNRpjVgoJXKHXnBWgzjzrgTFd0AMr6?=
 =?us-ascii?Q?8GPFZDQb6zqEzqJivxt2A5HzCF/W/uS52hq4gU9Ja0xq0ed1IaNHMi0mPJJ2?=
 =?us-ascii?Q?sIfqhW3qC0+nyzLjf/ZcUXZJGQiGinWDLx2smkhi0Hu550KgEpuMEB9LFoAs?=
 =?us-ascii?Q?omim9+IqeHmtfI+/K5RjC6Nx8kliM7+2kT530pp2U44BxjAfUbIxF59L9N61?=
 =?us-ascii?Q?0k7qjGa6HK50Geiq9cz+/usl0DzB8D0EncY+aQrLq5w7mGu1T48BjX2i1rvN?=
 =?us-ascii?Q?bMhSD7htUsIrm2DKLK08A9PakhLEziLbSy36liWlvitlcrNAzSkD0V6HgQ80?=
 =?us-ascii?Q?cELj7F/vxDiXtZZyTZJ7Wp7kjppGfWepJrfG5+m5vRvTaw5TwjfLCbpePKSJ?=
 =?us-ascii?Q?FjX0RegpKNVHlUysTUJ0lfizI0MawW8kCx9Zo3H2TIlnhTVyDkwKTeegFhdP?=
 =?us-ascii?Q?bnEu0v4DYKbfk4ivktqzWxvMHwfieS9kv/nH8tpRNxnzqhhfLHBi0zBehpKs?=
 =?us-ascii?Q?vXOSAI3LZjlZcnvCOAaQYsiICgEYmC/6j7TFdKTbU7NpR9W+VKRnBeB4ILIr?=
 =?us-ascii?Q?WBT0WRn9qkTjqjalTeeL/bd5BiPpjDGMYw1LB34I5w3bSkp/JGJbPN9xwqLZ?=
 =?us-ascii?Q?lmwWW5akf6z8AAisbJcj4GnLfbNktQBR+W+JrV1Uo5lru4UITxG4NV9d50Ov?=
 =?us-ascii?Q?/p9IYq25y8mRgVfVVQU+doRMNEd2PiKSbVZ1dfOyiHDu1jbEAGEEtZha0kQq?=
 =?us-ascii?Q?IGOtrMacKiRioHg2zD/zD2kN?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b339fdb6-9156-455a-cd94-08d98d752679
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2021 11:40:54.7881
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7PgC/Ml9rhkMOn/Re87GSU+DMFyUVi53F/5xZQMtAe0aXx8UNBP9sgKv6fnBHFMk+myhSK0ZoxRRq/xM8LvVXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3709
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an assorted collection of fixes for issues seen on the NXP
LS1028A switch.

- PTP packet drops due to switch congestion result in catastrophic
  damage to the driver's state
- loops are not blocked by STP if using the ocelot-8021q tagger
- driver uses the wrong CPU port when two of them are defined in DT
- module autoloading is broken* with both tagging protocol drivers
  (ocelot and ocelot-8021q)

*I did notice that a similar fix but for a different driver did get
applied to "net-next" instead of "net" despite my deliberate targeting
of the branch that goes towards "stable". I don't know why, it is an
issue that is really bothering some people.
https://patchwork.kernel.org/project/netdevbpf/cover/20210922143726.2431036-1-vladimir.oltean@nxp.com/

Changes in v2:
- Stop printing that we aren't going to take TX timestamps if we don't
  have TX timestamping anyway, and we are just carrying PTP frames for a
  cascaded DSA switch.
- Shorten the deferred xmit kthread name so that it fits the 16
  character limit (TASK_COMM_LEN)

Vladimir Oltean (10):
  net: mscc: ocelot: make use of all 63 PTP timestamp identifiers
  net: mscc: ocelot: avoid overflowing the PTP timestamp FIFO
  net: mscc: ocelot: warn when a PTP IRQ is raised for an unknown skb
  net: mscc: ocelot: deny TX timestamping of non-PTP packets
  net: mscc: ocelot: cross-check the sequence id from the timestamp FIFO
    with the skb PTP header
  net: dsa: tag_ocelot: break circular dependency with ocelot switch lib
    driver
  net: dsa: tag_ocelot_8021q: break circular dependency with ocelot
    switch lib
  net: dsa: felix: purge skb from TX timestamping queue if it cannot be
    sent
  net: dsa: tag_ocelot_8021q: fix inability to inject STP BPDUs into
    BLOCKING ports
  net: dsa: felix: break at first CPU port during init and teardown

 drivers/net/dsa/ocelot/felix.c         | 149 +++++++++++++++++++++++--
 drivers/net/dsa/ocelot/felix.h         |   1 +
 drivers/net/ethernet/mscc/ocelot.c     | 103 +++++++++++------
 drivers/net/ethernet/mscc/ocelot_net.c |   1 +
 include/linux/dsa/ocelot.h             |  49 ++++++++
 include/soc/mscc/ocelot.h              |  55 +--------
 include/soc/mscc/ocelot_ptp.h          |   3 +
 net/dsa/Kconfig                        |   4 -
 net/dsa/tag_ocelot.c                   |   1 -
 net/dsa/tag_ocelot_8021q.c             |  40 ++++---
 10 files changed, 291 insertions(+), 115 deletions(-)

-- 
2.25.1

