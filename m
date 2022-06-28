Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2101955E657
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 18:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347399AbiF1OxA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 10:53:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347380AbiF1Ow4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 10:52:56 -0400
Received: from EUR03-AM5-obe.outbound.protection.outlook.com (mail-eopbgr30049.outbound.protection.outlook.com [40.107.3.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0492A326DA;
        Tue, 28 Jun 2022 07:52:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BTX9ZgMxT+6pPeG6WUPFURUv5R4L645n2RI2ZYEPXsPsB0NPZCtrvM0k/uxoNmwmXAmfw/Nx8T+6lL4YM6UO+z70bKsBL3rkYP+joR9JY/WNlolRN2s0TvyOu6/KkSep+qg22ANnz5rYchqr+DKs3BfcksyRVKMzt4dYnCNmLFOBgv/8mi2/HJpckj+QmXKMXTGPh1yXrZ+WreiGJF7PpRaL8JW1Lnm8Y0cvAOS9/7e/pV4ekcfUGksPufuyU38D1G7rYOVIDzFUW/w0b3Pqa6YOJhaqTv5LLDdo9QlWkFl2GiKUNc1nnhziFubY+ubnqstdxZC0wxDpe9GGK2bzWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aArLl/hFze0FELKNg2HCr2tQMPwQ1NFB0ZtoBxbbu1I=;
 b=hi4dExhcGFD8rgNQEzX7mhMQcS4+bTqwW97zn1e/J1PPiNZDxNA9psIfboz0KMVWV5sqcu+KETfHr6+pr7/mK3FZw//OaGTfZuZ7ZlpOWoYJY1KeHYRiu01L+HAYMjhcNKxfBzOXEmWijoje8jdHDP8FBaapn/IM3aARY7KB5sMPsevKC9omckNQu2YkOgd6+kV1sCzABK/2Duz0NWmSIK7T9vFYeiqczpkTNPUuf9R657TWDrEc8ceRMXkYrpxX3w6EiVi6A6FZrPPJ6CQQ5f4VYFCcPqDa6/7otKaP3e8GgNagY0BWwy/6n5/7ik+NEO1sZFuKoch87HEqQzsWSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aArLl/hFze0FELKNg2HCr2tQMPwQ1NFB0ZtoBxbbu1I=;
 b=g8xsnJV7wEglOqsKiHUzuIum0/QHsATymrXWvGUqeUo9mCXNy4O3JP9BsvMJJsPmaxfqr6Aus7YGQs6xnzIEN2dllGdgasfK/vUcw+pkkCaw8g0zTXNZs9L82fclFFRcluh+ImXMhTDqiviS2o8/MOP7rk2oRr0bE4WEz11JQUc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR0402MB3810.eurprd04.prod.outlook.com (2603:10a6:208:e::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Tue, 28 Jun
 2022 14:52:52 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::94fe:9cbe:247b:47ea]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::94fe:9cbe:247b:47ea%7]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 14:52:52 +0000
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
Subject: [PATCH v2 net-next 0/4] Prevent permanently closed tc-taprio gates from blocking a Felix DSA switch port
Date:   Tue, 28 Jun 2022 17:52:34 +0300
Message-Id: <20220628145238.3247853-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0104.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c3::8) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1b465885-935f-4670-b222-08da5915e080
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3810:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9fk5lLVOGmJp5Y7dnZVQLTw9j0Qt7yHtftM3BX96gYyv2QCckY1iqbicGDtASOHJZE+aUTBpUNCU1Lg46fTe6rUVoJDr0OPYyuVI06xwNxbxokh6h6mK7jJiP4kEhvbItQwPYfezQlPzWDKaP6UgdaKSJi0fLzF//8229xt2ghfFcWcBX4FFHczeET3eQU7Pg853dkFeG09y2Jr19dTCoN5K7fy0lUekGF728dIRLcSVLGOWVA3PfmEHak9RES7LdwetBOjFtsEw/IW5+euHHW5hPLOsNZSkE1uWhV6TFJgU4NBktA3hDy89dqfzgPPdf5wyhY/5ahVU0Bt4YfodpOdt+tC3XxbyQ3GQVthSJfmE/TLppGSYxMclAP18hAgSUSmWXooCe50KfrXHHSsn98j39BPUsrzS++UwSTwusjcAwXBDQPV87yjElFee3yHLvI8eM+y4EcwOHR2Ps4v65GyMTEvybijd1G6CkrK7WtzuYWrzqmqZHfqnuPVfvIgGkB8Su/X+19gSbjvEe92LfbchA606aSErQudBTf3liOPk8NlgxciD3kUQ9vCH4CmsNa1xSCw3+z9QA5otWOr+imOjFNPS+2Cq+lCRbqL5E+ZGn+GPb7oK3uSn2US2We60Zgd7KeOhRE8ARpf2UEj/mwrmlAGTPmgP6lVDddmqnpMM9hkZdvCC2n44lfWnRNGz/SaRYle5cMMKpak0KdIaBL9bYcSQooj6Z77940Qqq2GM6CVTJGDdcjrZkPhFwNqp9wPbj3viYpbv5pL94y2ry8P1h2Ac7Clg8H4yvLN6d+HC0wRfxe+sJ/zkbb9Ne0AyEV7gVqvmVHZ3PWsAoo96xA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(346002)(396003)(376002)(39860400002)(2616005)(38350700002)(38100700002)(41300700001)(54906003)(316002)(7416002)(44832011)(1076003)(26005)(66946007)(66476007)(6916009)(66556008)(8676002)(36756003)(4326008)(966005)(6486002)(86362001)(6512007)(2906002)(186003)(52116002)(8936002)(6666004)(478600001)(83380400001)(5660300002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?30ofE2UT+Wz9UXCJs5nWHw4fGYJ9xpnDN1krgZpxxPzRldWyXllQqy1nVtWS?=
 =?us-ascii?Q?piuEGoxkN/zktXMy0Z3qBfnC0s9hSuCOB6X8lwdPp4cI5YPa0LVW6314eM0+?=
 =?us-ascii?Q?Dp11LMkCJzKR9799buh7HKSYPCZ6fVrAKGiVs/T36jgAszTeqz+RFgxuQG3w?=
 =?us-ascii?Q?02j+Xrqi6F4orrYP1LXLk6Om0k0aC4R8BIz2fRoJXJnhfqyzXye0lHw7kaHS?=
 =?us-ascii?Q?fSgGJNCtD93DZJjZwJhcs8l9nP0XMrYryOkF+T4HHgGl1/rh7d5q8vKGZwNR?=
 =?us-ascii?Q?DVcLUncqC1BQfG76r9qD/segAfyWLwzwtZYKYjQrvjWlTql9JbzowpuE6a/v?=
 =?us-ascii?Q?urkbP9XSa49LrU0UY7odlhZHvwyYRHJxFNL3PeG3vtNzcu8fKUr06/RBilOi?=
 =?us-ascii?Q?401q1sttZtJWf0Aj9SSkO0EkPnFWOn/Fw+CCyxIvQKF6X5oXqZwaUcyxz0uy?=
 =?us-ascii?Q?PySzoYXBX3XXa+C6BBkUNC5S5yQ0deTJZpH6iOpLqHVBbDZFl0lE6E2IkBCG?=
 =?us-ascii?Q?HOVHkXKaabXspy1sG8gIW6FTPUi0Gnj5qXWg6Ao+i4noQBMMZeXGULewZv8v?=
 =?us-ascii?Q?0PTBm/3GG/DxFEgco9gFMw948hWCt+C5SLqeHvTvf1gNPHCURaRFDn5Eulbj?=
 =?us-ascii?Q?nHrCf49DZNzhlnNO6TQlmOMw+OEP3DQm1zV3lVYS9peKFMeMuGSsYoEYSivq?=
 =?us-ascii?Q?5joRYZ5vxSCFYYzfNrfrV+paOcioAjgg2oTtJMC/vQ/20PUJlTrqHnDEluL2?=
 =?us-ascii?Q?+o3iezSho3u++LaJkMATtp9m86kGwigoSxwsxAhubk37PrrXqmi4dPA9Dr9Q?=
 =?us-ascii?Q?cwcHCVMYB3cplWAsn24ZreS/GcaUa/L+AQDb1NHvLENF1HxekAtBRUphMmx5?=
 =?us-ascii?Q?H95pQJHZc4glus7xFxDoZBhQ7u/ue9U4fRdPaAolLz2bfS1+NotDUiSo1jEh?=
 =?us-ascii?Q?Qeo2Ol9i+vDMzdLvp051ibc2q/ZKJto35OzOYvqag6phrJZTev4FoOV3IIka?=
 =?us-ascii?Q?+SBYnga1WwWbRIdH2NJM5x8b/BBe0WwyVrbmbml1wPDyG/GwGDZ3c4/lyFpE?=
 =?us-ascii?Q?Xk6odiTHrAscBnNuY/naFnVUpriwZLqh8AO8yNVxr8DW1uG7pWoqDsyOH17p?=
 =?us-ascii?Q?5a8GMywfbfpN3zZ3sospoWk95cx4BlCyIzwzNRWuUyygctKDcmhx+mY2zdMs?=
 =?us-ascii?Q?Un53mRU6JZ/aG1n2W/ifb+5wQpRRdtZiF235wufsOCD7jioBYkhJFT6xvWnr?=
 =?us-ascii?Q?+yQjOKTlq6SHF3mjrJuiG/y32M4XVmKNLn7tuW9At+j5Zl6jpkTo46PL8BU2?=
 =?us-ascii?Q?FnwYtiJOe7xN7Io7T62q6rLhp3NpfZELBcoG16mYoET7dmXYF48iUcfUeFpB?=
 =?us-ascii?Q?V94IfEwSxP+t4J0ykbxBElFiT77dOj1yQztgn3v/SYLVITc6712LPhTeXW9G?=
 =?us-ascii?Q?XQrFWsvnQcR5kq2hydqnpUcQwRAiM2WuQbJraLgLiSWrmGgbs/JraQpqbtwC?=
 =?us-ascii?Q?LUbLmfb+xbLGK5oQuNZo8ATNJordJ3DQOoUNbo7LFTsaOQF8dBZ8gneyf/Kz?=
 =?us-ascii?Q?27BjoZEwuyiAznRyp5lif2cu4zNt/fsMm1XAqJ/8W1GIcrCzvESFCyOdZKLx?=
 =?us-ascii?Q?Qg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b465885-935f-4670-b222-08da5915e080
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 14:52:52.3781
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bp/5nXStvhF2B5F3J4iDZ0K2U03HHQsaug1LmYRIkwvIRSkTaeKBJ+kqCwXP0tXr/lfKgf4LW6W9M12Zj16TIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3810
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v1->v2:
- define PSEC_PER_NSEC in include/linux/time64.h rather than
  include/vdso/time64.h
- add missing #include <linux/time.h> to users of PSEC_PER_NSEC
- move the PSEC_PER_NSEC consolidation to the last patch

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
   the same areas of code, that have already diverged from "net", 5.19
   and earlier. So this is why I am also taking the opportunity to
   introduce cleanup patches, to leave things as clean as possible after
   the rework. I'd be interested if there is a better approach to this.

Cc: Andy Lutomirski <luto@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>

Vladimir Oltean (4):
  net: dsa: felix: keep reference on entire tc-taprio config
  net: dsa: felix: keep QSYS_TAG_CONFIG_INIT_GATE_STATE(0xFF) out of rmw
  net: dsa: felix: drop oversized frames with tc-taprio instead of
    hanging the port
  time64.h: consolidate uses of PSEC_PER_NSEC

 drivers/net/dsa/ocelot/felix.c         |   9 +
 drivers/net/dsa/ocelot/felix.h         |   1 +
 drivers/net/dsa/ocelot/felix_vsc9959.c | 242 ++++++++++++++++++++++---
 include/linux/time64.h                 |   3 +
 include/soc/mscc/ocelot.h              |   5 +-
 net/sched/sch_taprio.c                 |   5 +-
 6 files changed, 238 insertions(+), 27 deletions(-)

-- 
2.25.1

