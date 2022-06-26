Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECEC055B1BC
	for <lists+netdev@lfdr.de>; Sun, 26 Jun 2022 14:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234411AbiFZMFi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jun 2022 08:05:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234235AbiFZMFg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jun 2022 08:05:36 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2046.outbound.protection.outlook.com [40.107.104.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E635F13F3C;
        Sun, 26 Jun 2022 05:05:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aY8VE6AnmOAaM+7FJRbHXVUvVwPq1/pnEaYPY1snaVQPXdksf1aG7jwTpJkbNg0dgXfqYcQeQbUousb2jVpIum79nTAMHgMMzAZ8Ctm06/UrV5s8nWbiCKqXUHOmw7MZ6U8isi/2qXJ9i6WHCScAt+DSnB7XnlWZN3NLfVt8C8A7enkkCAyf9fWplxZzz4ltUv1mb4JKDg2X/lahBn2Op1/1KfmVHUenOMPk1nmo7aW4KNpjIRyUKExwUSI9tYmzAV3WvWa2fh2F7wtplP/tHc11hfiXnMaogh4kRlHuFirOfg9owkxoRPGdPNX8h4T3Ipc8bFvrRT4bJ5TlBa0g6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jKVVN0Q9qet2+ZVQ8YsvvYgWeWQOtiYHjON23r5J1KU=;
 b=eofMiytHqISXP9FQQKbbFqlDQgwX4LQZpFabl6zLOiL4FbFQtyS2QstZ0E9gZQl5XnWGxgCKIQnKBMXu+sK8rGzZL7CouBH/CI6vo8LmBDoHLLgMeRrM7GtE0XHbVqD1JYx0+7ySwOMi92yfYclyerl7sk3wwNC7jGEOxy199kA6TvKrSnDBf8NNXAKeKNba003oWY0ZkzLuvGRygVk36M5bDhuM/F87FsUQb88k2q4wAU5zwsSSgCnvQRAScGHgjetjtL8LwgxlYUEJgl1/VDEKvnJRANppSgXkX2oiWRpWwVy0FbQUusZWsozUpwzDZ5jTzOoG/6fbYAs263ArRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jKVVN0Q9qet2+ZVQ8YsvvYgWeWQOtiYHjON23r5J1KU=;
 b=TbWz6/aVntVDjT5Zd7XQ7oIgIwpcst4qSzqbyysLbumZvIbQSG9BYukyHs2HSe5y1LIk7M7nS/WRYdOFiXzBK+QPlC8/4rFYNhknQ3+CsBySr2b9RfATJebwZHE00A47iYufv4C6cER/cQiAH924Cu8SNI66eV5v4STBDxQBTDA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB4273.eurprd04.prod.outlook.com (2603:10a6:208:67::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Sun, 26 Jun
 2022 12:05:31 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::94fe:9cbe:247b:47ea]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::94fe:9cbe:247b:47ea%7]) with mapi id 15.20.5373.018; Sun, 26 Jun 2022
 12:05:31 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        linux-kernel@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>
Subject: [PATCH net-next 0/4] Prevent permanently closed tc-taprio gates from blocking a Felix DSA switch port
Date:   Sun, 26 Jun 2022 15:05:01 +0300
Message-Id: <20220626120505.2369600-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS9PR06CA0401.eurprd06.prod.outlook.com
 (2603:10a6:20b:461::11) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 21b05dcd-6c83-428d-17b8-08da576c2af7
X-MS-TrafficTypeDiagnostic: AM0PR04MB4273:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QGFrK4drBdvQq+LjXQDaNKM1yKRA0PnQe2Y8ew8fjubkUMoZbBpoR8joDc37nfrDzpdV5DPy7sxeC7hcvTn39fCETAW9ZySDDuXIl8/Xwc+ofp/yTtpqVOY57+jLoWrXkWz37sfaZTwLh+BdCRJ5RbE0eGCVREofGnX1EV12azVOdIf9XGtUVQ35d/lxgUWgRjPp3zAwWv/a+5Xv3NCnsw+vSeFs5E0Vs/C1h2D3cRK6cdLLHsr51Z+/L0B+f8op10Cwudq+mjlFOnxwu0xpg5dxI+ckZobioYhlDj8UVFctoiVmfkzAZwZfG87D36qQ3FYJmRdz1vzhpczDbCN1vxlrI7nmiOhQuYp88irY+P7j+b1RYkh3JNdRBrKFR7jpksOjK+2YhJG/eA4zXdd7uPfpUD01NA8ZCW/aaoaBVuvQmpMFdC4T4zTmtPFBx4/w7M9RfJvmCurCYUovKHuKrnNtvpIN9fdY7UPrY2idmdd2+ROa5E3w2TMGQRMfxI4uyrfMCOUaoKJ4aJ+FTr6FYwGr3YurtR5nzUOmxyp6xSSf9sr+9lal/83olEsqMRUPvU4fjfmpe6+DptUspMKgw35G7KRf3Kt7B+1+OrvzCy9Q1Jbo2vqrKhnUmqcmQfnt3OJyupVKjlNpvuSLS6QOQ6PyiV4AemfQ+X9rGNzMV1obgWXi0/m4VEFak74gvPSyjC1E23FH9DEworSP9V/JMLq6hHuZsEJPbpXoIa6Cx1bvH0wpKsWoXuTR78txCqVQeZPf6yy2swIPq+uJLJmDd6sq+HGN/Rnls7gQjWr801sorcCi6goUpq0dQB404yGMYmLMbIAHeqdK9Cirpg8uvA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(39860400002)(396003)(366004)(376002)(38100700002)(316002)(83380400001)(86362001)(52116002)(2616005)(36756003)(6506007)(38350700002)(66556008)(66476007)(66946007)(4326008)(8676002)(5660300002)(8936002)(7416002)(1076003)(186003)(41300700001)(54906003)(2906002)(966005)(26005)(478600001)(6512007)(6666004)(6486002)(6916009)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sYcPsaTSIcDWjRWzR6qilanM+dXMexYUk1zV2recODRfvZUxvNZVeAtkWdVb?=
 =?us-ascii?Q?MghtNaJwb4i7PEOkPWomhmEzVTiHB7mASADfDpYRnK2ON9yXUTIWcAwSMXqM?=
 =?us-ascii?Q?Bapro2L5Cm2ZJuuNcRZy+UUoAMtzLcYsm2uqUGd8OncQQmhbz33S69JAqLFr?=
 =?us-ascii?Q?e0mxJe3nPrAkK8af9EgySBZmHP2S0jtsMI+Cb79hWNHO09Xh8P1QobGtFyHY?=
 =?us-ascii?Q?Yqvwg03LwGjHIXxT3fsJH5xAlO62mSq+/PPw1+Sm+n71XE/JRlrRyUb4B+9h?=
 =?us-ascii?Q?GwciVJTfWQpFD5z3GP7/89vBrcPGkkl5Q7LDpAgALmvG94tmkhiMdluo/WDY?=
 =?us-ascii?Q?1MJAWOZTtRAoE9+6gV9ytMAd0KzoauSn9SUmznIrSLSg7XvXKQw6ZxX0Vr56?=
 =?us-ascii?Q?rx+vGsw8VUJBxkOOizRbO1yzlBcsZvUNNuFNkqqlbKRcFu3AtMuo5CmtOohu?=
 =?us-ascii?Q?y5lhxCO5oDyXhQXHDOBW70IZJT8EzdPCjEQPsQFzvdQpyLhh0ktEREHxeHJ+?=
 =?us-ascii?Q?JGtZaj4pb+rkWcSG81bhvSHlzjNGKBBFYe8stcJ5Hnf41P9xrdeYVrXCgQ2o?=
 =?us-ascii?Q?ymc1yUXwkTFW5vl3iCWc7WYovq/MGD3tW0HGT87HVs24X30uda09IRt7w68L?=
 =?us-ascii?Q?tTnI/6dsfFf9hs1Rc/4XalVCHaZaMIovsq3C2gQhRnOdigFj4DxbkaXs5PP5?=
 =?us-ascii?Q?NmD+UMqBbd+KsaNt5BaaFSe9fmkE525nSmW4B04AksALxrW6Sy1SOyDQnJYt?=
 =?us-ascii?Q?0TezmJO2HbZejHWOmgCgL6bqWIlrMMb8EkJruPqoTvVVBD4KXP+zvwpHWx0v?=
 =?us-ascii?Q?VRjjhD433IL7e7u5NVKkj7ph4CLMq6kk7z/kDMphgRM1CdvJM6xXd+dMVoKU?=
 =?us-ascii?Q?pJ6b4+wVDujOLgSwZLqcYURN4WdymA3QVM5Vd1HtMYYzgcH/Q6rVVrcL0vjS?=
 =?us-ascii?Q?zdPjdMC5WcxdYbuQQJEfxfXDxQlmxpFDU32SB1Yo/4YMWkiG6NLPNOzNNJG9?=
 =?us-ascii?Q?y4KjwrfCmkP6E+slRDAraJ3dDo7qK5U2K29Q+XRuIhA2IG3qWoG68TyIIxcN?=
 =?us-ascii?Q?zF7FoUKABH4wKbNPNjh/r25ju+wHPQgqMMiHXEX8z1zjInXTCwahPDcTjl6j?=
 =?us-ascii?Q?Y7EFThVmv6BHDOHQCUEguvj/QwQ9DQUtQDYqXvlulad/gKKq7r6Bu1nzkJEz?=
 =?us-ascii?Q?HZBjdUuDFNv8SkKTIVmZVk5tzUIazn9sprYdBMVLvga33GuWxCkKviEPIwPh?=
 =?us-ascii?Q?0Nmoxm8NKDObLn2UKj3VWSm2kRuMrBG+6/+E/6nwjmh24raIUh3/ro2/LMv8?=
 =?us-ascii?Q?DFYvzp6uxzbfv9zMMxgWTEju3JzyolVY+I+PJIwmDm5M6dQpgOwa/aOdEe4i?=
 =?us-ascii?Q?M6BT7A4DCHznZl7krc/r+tsCWk/U9jmn0KDByK3Cmx//liqIOs1o7fDTZ0xr?=
 =?us-ascii?Q?24eQ4F0Zchnbl5wMvYtw/SpQ0tWbRfYBsdk2zNkW/0y69hCnZEmtjXKvG4yH?=
 =?us-ascii?Q?5Vg7RLBhUcrVteq9c9rsPYhGL3emNTnFPdGxyb3uTcZM7eW4N+jABHbHzfNj?=
 =?us-ascii?Q?KYr+p6aVmrG0KR7tSUoS4hjwDStFy6KoV7fqWxFPFVNo9iySw6ir8JxqD3SR?=
 =?us-ascii?Q?Zw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21b05dcd-6c83-428d-17b8-08da576c2af7
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2022 12:05:31.7454
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y3QoiTC5clwt4q+53o8jZ3E8YwB8XdM8pYkJs9SgynCwnui4oPR7dBZzeffbhIu5Lbv9byOyenDhfX2ZTlnAOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4273
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Richie Pearn reports that if we install a tc-taprio schedule on a Felix
switch port, and that schedule has at least one gate that never opens
(for example TC0 below):

tc qdisc add dev swp1 root taprio num_tc 8 map 0 1 2 3 4 5 6 7 \
	queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 \
	base-time 0 sched-entry S fe 1000000 flags 0x2

then packets classified to the permanently closed traffic class will not
be dequeued by the egress port. They will just remain in the queue
system, to consume resources. Frame aging does not trigger either,
because in order for that to happen, the packets need to be eligible for
egress scheduling in the first place, which they aren't. If that port is
allowed to consume the entire shared buffer of the switch (as we
configure things by default using devlink-sb), then eventually, by
sending enough packets, the entire switch will hang.

If we think enough about the problem, we realize that this is only a
special case of a more general issue, and can also be reproduced with
gates that aren't permanently closed, but are not large enough to send
an entire frame. In that sense, a permanently closed gate is simply a
case where all frames are oversized.

The ENETC has logic to reject transmitted packets that would overrun the
time window - see commit 285e8dedb4bd ("net: enetc: count the tc-taprio
window drops").

The Felix switch has no such thing on a per-packet basis, but it has a
register replicated per {egress port, TC} which essentially limits the
max MTU. A packet which exceeds the per-port-TC MTU is immediately
discarded and therefore will not hang the port anymore (albeit, sadly,
this only bumps a generic drop hardware counter and we cannot really
infer the reason such as to offer a dedicated counter for these events).

This patch set calculates the max MTU per {port, TC} when the tc-taprio
config, or link speed, or port-global MTU values change. This solves the
larger "gate too small for packet" problem, but also the original issue
with the gate permanently closed that was reported by Richie.

Q: Bug fix patch sent to net-next?
A: Yeah, after Xiaoliang started sending bug fixes to net-next himself
   (see https://patchwork.kernel.org/project/netdevbpf/patch/20220617032423.13852-1-xiaoliang.yang_1@nxp.com/)
   there is absolutely no gain in targeting "net" here - I am modifying
   the same areas of code, that have already diverged from 5.18 and
   earlier. So this is why I am also taking the opportunity to introduce
   cleanup patches 1-3, to leave things as clean as possible after the
   rework. I'd be interested if there is a better approach to this.

Cc: Andy Lutomirski <luto@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>

Vladimir Oltean (4):
  time64.h: define PSEC_PER_NSEC and use it in tc-taprio
  net: dsa: felix: keep reference on entire tc-taprio config
  net: dsa: felix: keep QSYS_TAG_CONFIG_INIT_GATE_STATE(0xFF) out of rmw
  net: dsa: felix: drop oversized frames with tc-taprio instead of
    hanging the port

 drivers/net/dsa/ocelot/felix.c         |   9 +
 drivers/net/dsa/ocelot/felix.h         |   1 +
 drivers/net/dsa/ocelot/felix_vsc9959.c | 241 ++++++++++++++++++++++---
 include/soc/mscc/ocelot.h              |   5 +-
 include/vdso/time64.h                  |   1 +
 net/sched/sch_taprio.c                 |   4 +-
 6 files changed, 234 insertions(+), 27 deletions(-)

-- 
2.25.1

