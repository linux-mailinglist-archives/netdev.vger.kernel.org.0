Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 799944C2D3A
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 14:35:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234501AbiBXNea (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 08:34:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232992AbiBXNe3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 08:34:29 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2044.outbound.protection.outlook.com [40.107.236.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6BFB16DAEB
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 05:33:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fIWuziY1FHgbd/uj+k5aTys7zyXxvOoDBiV6gNEHKvfFUvMmSYHNpgXU3CCAdE/Gjh+98bL0k6to05TnbY4dwEhNpSb+ie3N/l7pSXdpSW0RdrEEN4mS8X31tmmqkFgCR8XADzn8Ps1Guc8aeWLE249NgVhIxyz8GLAr5MJ9sw4M0k1JGt5ob/4s3NdcKaj53NAFE1yFPjCFM24tINZeMjYSiSUARpREugtEbOie3ip2QCpE0sAsS3Q9O6wPv+PqMPhmbDDupVppYA9Pn3j7MjEOgb0//zgPznTea4YvBm6VXmmKCK0FceehTR8IsfpPEerTHL49cIcbcX6Llr7IJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w6kNZHciZPKkljgrTIg8f8jIY5eObCgaWu6PCY3WsSQ=;
 b=lWJ7PhcSb5WLUlBYfdkftw73wvYsA+QDESqMclOYIOcQwV8K0B/XzfG4KxAEjAzHku7YXrBzcSHkPde0YSUluwQhnASQroFn2FCTw6aBGdEIURxa+tirOmTRJzghL/bfdGCsbTi7AXLHhYeXO6tMcu/HBn6g+2UC2nvNMgoxD8+7GVXgh9zSpl6zFAzmTAeSD4TuooIwWOlTJeAt2f/jo9/Q+ByACoBvxQVsYVcCU0BZsB2A2x332eaBWDqa6z71bpLBP6cmImBanCrArXboDLpj1YUgMA3Yax6qY69lEgP/4XYhV+gqAnDto9i0ekKh4FAdP6X8P2cxj0rWysyRaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w6kNZHciZPKkljgrTIg8f8jIY5eObCgaWu6PCY3WsSQ=;
 b=OwjJW7ReDjsM8S3GUOSQwCCJaNeDCwZYvld6FHXat5208DuqsKX6NnG75jxPnQPWs0ZwHNbFh69Jg44AKSWnW1yTgylTmMD9LJ//yZ96YWTa5Q+rNJH2bfL9+wQvZuF9YlsjfDoR5agU3hOYWiAU6QsATDZ07bq9uWlW3qJofm4cCZXWZM8gYMM3+qM43eMCp4JnkDMVkSjsc8QosmGn3SeUDt4HXs+sGdxURCzcQwK6Nb/0gvMKniAM08+aPhvEMGCNJvNEHIpOuPjXgZyl59dO+CdGH41XmwxU4j7oUTHy/3ULKdR0bq2XDwQ4uUqzcXtSdfewgNcg+OXmpsTohQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by DM8PR12MB5416.namprd12.prod.outlook.com (2603:10b6:8:28::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Thu, 24 Feb
 2022 13:33:57 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581%7]) with mapi id 15.20.5017.025; Thu, 24 Feb 2022
 13:33:57 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        jiri@nvidia.com, razor@blackwall.org, roopa@nvidia.com,
        dsahern@gmail.com, andrew@lunn.ch, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 00/14] HW counters for soft devices
Date:   Thu, 24 Feb 2022 15:33:21 +0200
Message-Id: <20220224133335.599529-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0202CA0025.eurprd02.prod.outlook.com
 (2603:10a6:803:14::38) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1b0a4d2d-02d0-4465-c186-08d9f79a4f0c
X-MS-TrafficTypeDiagnostic: DM8PR12MB5416:EE_
X-Microsoft-Antispam-PRVS: <DM8PR12MB541696EB3E39C6367336BDEEB23D9@DM8PR12MB5416.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4/RluH+A/CK/9U1DSADFlPzbrGrO9EgNHNTEpu3D2lvMvtMYWKBHKC9PM0/qvXUQEWU2UwWclX++y3LRLWXbGlal6Ra/PKeqJ61KoeTaFX6RD4a1/Z80IORTG7/zi9lvX/pRsenyMA+Osn4br99ASWmJ4faHHgZf6aiaJQTruC4/hBsOKg+dnOvCXCpNiJelpjP2EejIpoO42KCRGL5R5cC4qSkp7OY+DfyLtwxZ/FzYY8/1vq8ELB1QEVAhDWE1aPNFJyqFOpd7fOxFesvhg3JGitBueaRJBKrpYlzWDpEvDmz667ywkfSzYj4qEnVktdletd20anLMqVwl9IG98+mHrgFRw8vmgO3bLikr0z125gv2pONQYKSO0y2bUWo/vw8B+AM73Vx2GI0a6vtFKF9+U5J/pO7h1n0uqvsoCvdFyjAcownMelsuUiCouwgCXltxgX7sAV8RKi5Y2Xc3fHpi7uGz71ZwQYQD8/ymlU2ezMoRvDI2msXux+zMzTBAtfd27psd2ISYcjRVGZJg0DuwmZFpWqhtT5fPcQYxSsmVALRxdJCF57Occ/bn6YfdY5vrnVrDy7aDkRxIrhhhnn0s0D5R1TEzkAzFrDwG9I/DmNJS9hBDzW2DolP2ULv4d5blj69eVbYzRcnUQxmIOr86K5/BTdDHAw6xEv34DqC5jZkubmkx9eaBCgW4sTHIrdxYMjZFJ8Etoon8XcvhBePGUE/j2dYY09yl10sSzGH1/wICOwAb5yKu4p/kJRoJDNjcM05vGpdUlpCjX/A7+Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(6512007)(1076003)(107886003)(186003)(26005)(5660300002)(2616005)(2906002)(36756003)(66574015)(8936002)(6486002)(38100700002)(966005)(508600001)(316002)(6506007)(6666004)(66946007)(66476007)(8676002)(86362001)(66556008)(6916009)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DAi8s2SwNdAqrCMHoyJjlhJNqxJ3GUXSixefrrGsDGcJYpkYw5g3BqXHp8q+?=
 =?us-ascii?Q?47oTbbS1fXVSg8yQjNBKSdNRWjdjYX6yBDdOgsZ5CdbxDrj1+rv6q6jTea7Q?=
 =?us-ascii?Q?vq3lxv3b/y3E8ogiXUF/toT7iOqnwask3u0mWEi7AsK532GF7rqhMKSWLeu7?=
 =?us-ascii?Q?SoVyEZD6mCFZCGagzCjUEYJUqkZeU9dSN4GzqBA+MtNjFq+rfXGb2dL9i0ve?=
 =?us-ascii?Q?Sfs/BsWVtDlq8C0dOoXUGIB3imUvULF0xtBGCtk7+Zas1s/gFtwR2Y4rEncK?=
 =?us-ascii?Q?9WmyuicVGKFilxxduK6IJheSINczIiXDtOzmyBnGS+eN5ZVdpjiwyYbOQYcy?=
 =?us-ascii?Q?BKtWZbkNeoXT6SX7agpj341N1Uh+xcdvhKr0Wo/UgLbkeX1h4kjflszd4qIk?=
 =?us-ascii?Q?yBrlCWDWwsaTonz+uxZqBTmIKBKgI90I3cN2Mp9W3QFK1Ti5nuF4JRxCDfXk?=
 =?us-ascii?Q?C8oyk4Fqx0M9VJAXqQkjPp0h3+rliRfl+7S733uLloeUQztyDM4IoM27uyzD?=
 =?us-ascii?Q?K2HzaofLt2o3Mt1RLXoy92LjeO4MgMb2tGJkdtG1FSspgSD9XxL5xr7lwmEH?=
 =?us-ascii?Q?DcJ7odedKsV4xbeXUt3jfG5N3RFFh6QilwpgBJmVsx8A++gdSqk6jWwlWYhk?=
 =?us-ascii?Q?nnV61jj0qnDJ60qfv3MOTYdCc5DidoZmnfEp/Ns3Xfb/tCMG6oCu8ozS3n1H?=
 =?us-ascii?Q?bkOCKeZCob7tzonbjSAQFyfJbqA2ZpX5BR1W0NioDm7qkNHIOYgPqOqtQ+gV?=
 =?us-ascii?Q?zFpsC4qlF2iYnscuU+QKv8GsKRNqPtcOvOJ8oBj4OOKi8k10+sm2kNALE6KC?=
 =?us-ascii?Q?Y8I7h4UETpqinfWV/Sd2FhIUywyFTMwjNYQ9CtpcoAuG2bTls+onHdDDnEHF?=
 =?us-ascii?Q?aC5eJoXlImQabo0p8s+S42kvCApvIJdnaK45Jf4SIFHhKHpNBXft9rC5pW4N?=
 =?us-ascii?Q?LEzCl+mNybjA3xTX3djzz+uLg2cIQAnBbghCJZs66WlusKRNF0ljIPnhBGu6?=
 =?us-ascii?Q?8lQhCKjImTfg6RPP7QChfCcLHRTt9dTpi7b6VhJweRVLygs7Nzs+5bqJuN+q?=
 =?us-ascii?Q?gOcMtOv88KKr6Wwj/n/PmyUzaWps0NgHzuJlwoPDRVGOeNcszHS+yy+Kc2qd?=
 =?us-ascii?Q?FbVmfhoatGijyf/U85FVSHbi2HCiWF8eXb2iO/l31n8zxlM8WFNixqYeirT4?=
 =?us-ascii?Q?Yfo+0T5SMueSqGhISo3PsHdo07oh72kgAl+7cUqZCoOjMWRiJryovknHWqss?=
 =?us-ascii?Q?hQDR8givLmASz+LehH3QsfljeraN7sDM0EirxaTvLoiZw6UhoVGmUr/y329B?=
 =?us-ascii?Q?Xj4T8fwfF11JIk8O2sFIqDEzHdufg7TqLacNVdbgDP076wCao6aibcgd60VJ?=
 =?us-ascii?Q?rCQ2kHVCXoZ3Mj+ZhEq2+i6PGANDed7wrI7QOmNCZNCrYVWYAePSThBXnaZr?=
 =?us-ascii?Q?xkqJFiR4vnLkNrMOICeTIW5zk0LOlziGeQuy+B5ZZQdKEK/K1xAHMI0O//vO?=
 =?us-ascii?Q?Wd4dEk+wAbjtwWY9bTC02UvdpNbRaXEZ430X8qKX0pWYeed1NGKekLgLW8FU?=
 =?us-ascii?Q?FseWcn2xfcy/H8+FN1HJBSPSl5ibCnauMKkAO4Qb4gqExfPcGLs9uKet/JQ8?=
 =?us-ascii?Q?y59yDthrObtDX52wniNV4ZY=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b0a4d2d-02d0-4465-c186-08d9f79a4f0c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 13:33:57.3833
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ub3r8ZgXhlaOwvprQIzOivPTByJAHBL/PMGivfXHi9DRGGQ4jEb9x7qTiEIz39Mz8/sYuYCgbVTVbu7kuO5bNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5416
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Petr says:

Offloading switch device drivers may be able to collect statistics of the
traffic taking place in the HW datapath that pertains to a certain soft
netdevice, such as a VLAN. In this patch set, add the necessary
infrastructure to allow exposing these statistics to the offloaded
netdevice in question, and add mlxsw offload.

Across HW platforms, the counter itself very likely constitutes a limited
resource, and the act of counting may have a performance impact. Therefore
this patch set makes the HW statistics collection opt-in and togglable from
userspace on a per-netdevice basis.

Additionally, HW devices may have various limiting conditions under which
they can realize the counter. Therefore it is also possible to query
whether the requested counter is realized by any driver. In TC parlance,
which is to a degree reused in this patch set, two values are recognized:
"request" tracks whether the user enabled collecting HW statistics, and
"used" tracks whether any HW statistics are actually collected.

In the past, this author has expressed the opinion that `a typical user
doing "ip -s l sh", including various scripts, wants to see the full
picture and not worry what's going on where'. While that would be nice,
unfortunately it cannot work:

- Packets that trap from the HW datapath to the SW datapath would be
  double counted.

  For a given netdevice, some traffic can be purely a SW artifact, and some
  may flow through the HW object corresponding to the netdevice. But some
  traffic can also get trapped to the SW datapath after bumping the HW
  counter. It is not clear how to make sure double-counting does not occur
  in the SW datapath in that case, while still making sure that possibly
  divergent SW forwarding path gets bumped as appropriate.

  So simply adding HW and SW stats may work roughly, most of the time, but
  there are scenarios where the result is nonsensical.

- HW devices will have limitations as to what type of traffic they can
  count.

  In case of mlxsw, which is part of this patch set, there is no reasonable
  way to count all traffic going through a certain netdevice, such as a
  VLAN netdevice enslaved to a bridge. It is however very simple to count
  traffic flowing through an L3 object, such as a VLAN netdevice with an IP
  address.

  Similarly for physical netdevices, the L3 object at which the counter is
  installed is the subport carrying untagged traffic.

  These are not "just counters". It is important that the user understands
  what is being counted. It would be incorrect to conflate these statistics
  with another existing statistics suite.

To that end, this patch set introduces a statistics suite called "L3
stats". This label should make it easy to understand what is being counted,
and to decide whether a given device can or cannot implement this suite for
some type of netdevice. At the same time, the code is written to make
future extensions easy, should a device pop up that can implement a
different flavor of statistics suite (say L2, or an address-family-specific
suite).

For example, using a work-in-progress iproute2[1], to turn on and then list
the counters on a VLAN netdevice:

    # ip stats set dev swp1.200 l3_stats on
    # ip stats show dev swp1.200 group offload subgroup l3_stats
    56: swp1.200: group offload subgroup l3_stats on used on
	RX:  bytes packets errors dropped  missed   mcast
		0       0      0       0       0       0
	TX:  bytes packets errors dropped carrier collsns
		0       0      0       0       0       0

The patchset progresses as follows:

- Patch #1 is a cleanup.

- In patch #2, remove the assumption that all LINK_OFFLOAD_XSTATS are
  dev-backed.

  The only attribute defined under the nest is currently
  IFLA_OFFLOAD_XSTATS_CPU_HIT. L3_STATS differs from CPU_HIT in that the
  driver that supplies the statistics is not the same as the driver that
  implements the netdevice. Make the code compatible with this in patch #2.

- In patch #3, add the possibility to filter inside nests.

  The filter_mask field of RTM_GETSTATS header determines which
  top-level attributes should be included in the netlink response. This
  saves processing time by only including the bits that the user cares
  about instead of always dumping everything. This is doubly important
  for HW-backed statistics that would typically require a trip to the
  device to fetch the stats. In this patch, the UAPI is extended to
  allow filtering inside IFLA_STATS_LINK_OFFLOAD_XSTATS in particular,
  but the scheme is easily extensible to other nests as well.

- In patch #4, propagate extack where we need it.
  In patch #5, make it possible to propagate errors from drivers to the
  user.

- In patch #6, add the in-kernel APIs for keeping track of the new stats
  suite, and the notifiers that the core uses to communicate with the
  drivers.

- In patch #7, add UAPI for obtaining the new stats suite.

- In patch #8, add a new UAPI message, RTM_SETSTATS, which will carry
  the message to toggle the newly-added stats suite.
  In patch #9, add the toggle itself.

At this point the core is ready for drivers to add support for the new
stats suite.

- In patches #10, #11 and #12, apply small tweaks to mlxsw code.

- In patch #13, add support for L3 stats, which are realized as RIF
  counters.

- Finally in patch #14, a selftest is added to the net/forwarding
  directory. Technically this is a HW-specific test, in that without a HW
  implementing the counters, it just will not pass. But devices that
  support L3 statistics at all are likely to be able to reuse this
  selftest, so it seems appropriate to put it in the general forwarding
  directory.

We also have a netdevsim implementation, and a corresponding selftest that
verifies specifically some of the core code. We intend to contribute these
later. Interested parties can take a look at the raw code at [2].

[1] https://github.com/pmachata/iproute2/commits/soft_counters
[2] https://github.com/pmachata/linux_mlxsw/commits/petrm_soft_counters_2

Petr Machata (14):
  net: rtnetlink: Namespace functions related to IFLA_OFFLOAD_XSTATS_*
  net: rtnetlink: Stop assuming that IFLA_OFFLOAD_XSTATS_* are
    dev-backed
  net: rtnetlink: RTM_GETSTATS: Allow filtering inside nests
  net: rtnetlink: Propagate extack to rtnl_offload_xstats_fill()
  net: rtnetlink: rtnl_fill_statsinfo(): Permit non-EMSGSIZE error
    returns
  net: dev: Add hardware stats support
  net: rtnetlink: Add UAPI for obtaining L3 offload xstats
  net: rtnetlink: Add RTM_SETSTATS
  net: rtnetlink: Add UAPI toggle for IFLA_OFFLOAD_XSTATS_L3_STATS
  mlxsw: reg: Fix packing of router interface counters
  mlxsw: spectrum_router: Drop mlxsw_sp arg from counter alloc/free
    functions
  mlxsw: Extract classification of router-related events to a helper
  mlxsw: Add support for IFLA_OFFLOAD_XSTATS_L3_STATS
  selftests: forwarding: hw_stats_l3: Add a new test

 drivers/net/ethernet/mellanox/mlxsw/reg.h     |   8 +-
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  20 +-
 .../ethernet/mellanox/mlxsw/spectrum_dpipe.c  |   4 +-
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 305 +++++++++-
 .../ethernet/mellanox/mlxsw/spectrum_router.h |   6 +-
 include/linux/netdevice.h                     |  42 ++
 include/linux/rtnetlink.h                     |   3 +
 include/uapi/linux/if_link.h                  |  23 +
 include/uapi/linux/rtnetlink.h                |   4 +
 net/core/dev.c                                | 282 +++++++++-
 net/core/rtnetlink.c                          | 524 +++++++++++++++---
 security/selinux/nlmsgtab.c                   |   1 +
 .../selftests/net/forwarding/hw_stats_l3.sh   | 332 +++++++++++
 13 files changed, 1461 insertions(+), 93 deletions(-)
 create mode 100755 tools/testing/selftests/net/forwarding/hw_stats_l3.sh

-- 
2.33.1

