Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 511F1337BA6
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 19:04:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbhCKSEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 13:04:05 -0500
Received: from mail-bn7nam10on2082.outbound.protection.outlook.com ([40.107.92.82]:19031
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229883AbhCKSD6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 13:03:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lw3fnRPk/VF3MF/fi42S6/wU6J8wgHCl4pcbzXQ1L37qzj4/1/6ILW4cLznyEx5ucvHoFNV78xYAyD0E1Odq+dk1Tv1m0gCtXTolTJpFRldWO7vi6mVXglleaElPC0i2CwTrnvntgRt+y+67ySJlNIs9g3OkVDX5faw/PmvS5T4KK+ad6x4n0LzlaY4+9dv5OwjYL16P0Iq9ou/1NWukiSf6ZTNFa4rXY9c4ayqfclsXJmds1dtxKGLjGcCaxotgR3dhMcnSa5td4GNZ864mkRV4BQijEybJJsNB5MieCZJogb7Gbt80Rk/bOyP52K+KJNkenD8pzWUlzatlJdPJ1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YLcOCp93CY5JoR4ToCUtHbo+isdke2nJgjE6N+PJzio=;
 b=RrgmPD0GZ54oBPyEE8h48cRQP49/Uc2XScuipllgZDb5wJ08UUt2JPa0D8R2ZGBDz1m3U2l/hoY69dWeVCWWEcGLOdKiCayJUBb96C4AjmdyjgLel5Ow1bM/mpxpZtcpRxPVFD7XDG/4Oc/o7OZLnQMBFxOdXZAvQ05d1xmyKO5zdjzv0gI8veer35nKVTDptYZ2rZqxSsJ47RkSgvjNNCqNpnaA1RuEY9BivgEemOU6la0QTcsHCNr3sKNlQhSKiWEtRFf7U5styd8X3UsmEkLrp3Fi8f3CRZJLaUFjdEGhXyCtknqqUFCqN0jP5K3Rf1GUZtCIhSMUoBHnDWFxqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YLcOCp93CY5JoR4ToCUtHbo+isdke2nJgjE6N+PJzio=;
 b=EilmAUzYF62/mapIMlDnnaF/8Q1YWMm9DI1Q7OSPbDyhYbVgO7ttQwItbsIIwXFgcMRQK7eYF5JnFAFHQS8AOjiRrADD1g7Bruzlw2oYu74CqPPyhYDpLbin65YsN8WAj86/qkf8uji+m/o8OyvRoj5KVv4es0ulJtAAGhN4LWI/5lNUYDCJBIHgjr5G0nR/HL/Jp6jqrLM13ef6GNhxgyo260EQPU1xdhMBJd+/Xtvh7xasdkjJoA6MfK50JJTbdTOhC3WbLO4qUocovHPY8u5SQq9h6tgI6ZfaexqCdqhtuEafZ6KwOt6/CLSPUKWdtGsSpPK4PLOJd3PrBqlKvw==
Received: from BN6PR2001CA0034.namprd20.prod.outlook.com
 (2603:10b6:405:16::20) by BN8PR12MB3538.namprd12.prod.outlook.com
 (2603:10b6:408:96::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.29; Thu, 11 Mar
 2021 18:03:55 +0000
Received: from BN8NAM11FT047.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:16:cafe::29) by BN6PR2001CA0034.outlook.office365.com
 (2603:10b6:405:16::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend
 Transport; Thu, 11 Mar 2021 18:03:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT047.mail.protection.outlook.com (10.13.177.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Thu, 11 Mar 2021 18:03:55 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Mar
 2021 18:03:51 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH net-next v2 00/14] nexthop: Resilient next-hop groups
Date:   Thu, 11 Mar 2021 19:03:11 +0100
Message-ID: <cover.1615485052.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b27b2c25-8937-4011-03e7-08d8e4b8093d
X-MS-TrafficTypeDiagnostic: BN8PR12MB3538:
X-Microsoft-Antispam-PRVS: <BN8PR12MB35384675563D03BFD34E4844D6909@BN8PR12MB3538.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zvx46XY5qbjous9LeTQT0nk5PSi/Yo00WohLmgx4XQYk92UaG/mI1gmA6kHRGk+kYOt/0wjn7y1vbGeyqX39h7HnPL6g6eqLuuMNAyZPYpkqDTaVeCx472OkZzeNU92AT+kgpa7/epg66YbQ4o0gp5lx8APfZAt+bu1xP2DwkHuAPuko/HcALGpCOjUj8Adzggtz7T37nXN7suYRWOXjKshXvf83IQbERJ/le0M533vZz4k8iYGAlFRicx4BeuX7/vNwYngeaCGZWQias30/qAcsMkFjjW5rJHREtoG+SMQjBIWjFI04fbU1/B3NxNlEG4v6WS6rrMXk7Oz89CyehIcNLpMWV13FWHGpOiwFKpy5lpMzC7hC+PGutml+u6puTSNxHvLdPvk6+7lEXvqfOCWileMpJWJZQ/u/6T7bI/JPhYFbDPQ+bpUa/ntrsjJrlqpHgIbWsURXiaYX+DhpAIk66B4tvOW+ztTZ1v36AQaCtLw6+ANgmAr0Wf1rrI6HTPkbM8tNGE2lpSxgvlREHJdx6zakpxp604Ll7uJHD8moHffDHVlaX6MNs6QamdtNaNRkuZWGYtHDqJH0r1wu8Ag60zHmfdgwyI1nljRoFTZe8trARNopaG/zsBQaVxVH8PSkPLuurRGBd8XrwEugRmnk7ZQK7jlc7u88U92MUU/bUWUzAgwccZjl+UGqlG2Las/Cm7bN7fc894gBg4lYAhXwCFxMvR3I0eVROb/2vdy7d3/zcAKiuvxaGU/e06cpcYF6ql3K5pVh6M0Q9lluFw==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(396003)(346002)(376002)(136003)(46966006)(36840700001)(70206006)(26005)(5660300002)(426003)(356005)(2616005)(30864003)(54906003)(478600001)(2906002)(966005)(16526019)(186003)(6666004)(336012)(83380400001)(82740400003)(316002)(36906005)(36860700001)(86362001)(4326008)(34020700004)(36756003)(8676002)(8936002)(82310400003)(70586007)(107886003)(7636003)(6916009)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 18:03:55.0565
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b27b2c25-8937-4011-03e7-08d8e4b8093d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT047.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3538
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At this moment, there is only one type of next-hop group: an mpath group.
Mpath groups implement the hash-threshold algorithm, described in RFC
2992[1].

To select a next hop, hash-threshold algorithm first assigns a range of
hashes to each next hop in the group, and then selects the next hop by
comparing the SKB hash with the individual ranges. When a next hop is
removed from the group, the ranges are recomputed, which leads to
reassignment of parts of hash space from one next hop to another. RFC 2992
illustrates it thus:

             +-------+-------+-------+-------+-------+
             |   1   |   2   |   3   |   4   |   5   |
             +-------+-+-----+---+---+-----+-+-------+
             |    1    |    2    |    4    |    5    |
             +---------+---------+---------+---------+

              Before and after deletion of next hop 3
	      under the hash-threshold algorithm.

Note how next hop 2 gave up part of the hash space in favor of next hop 1,
and 4 in favor of 5. While there will usually be some overlap between the
previous and the new distribution, some traffic flows change the next hop
that they resolve to.

If a multipath group is used for load-balancing between multiple servers,
this hash space reassignment causes an issue that packets from a single
flow suddenly end up arriving at a server that does not expect them, which
may lead to TCP reset.

If a multipath group is used for load-balancing among available paths to
the same server, the issue is that different latencies and reordering along
the way causes the packets to arrive in the wrong order.

Resilient hashing is a technique to address the above problem. Resilient
next-hop group has another layer of indirection between the group itself
and its constituent next hops: a hash table. The selection algorithm uses a
straightforward modulo operation on the SKB hash to choose a hash table
bucket, then reads the next hop that this bucket contains, and forwards
traffic there.

This indirection brings an important feature. In the hash-threshold
algorithm, the range of hashes associated with a next hop must be
continuous. With a hash table, mapping between the hash table buckets and
the individual next hops is arbitrary. Therefore when a next hop is deleted
the buckets that held it are simply reassigned to other next hops:

             +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
             |1|1|1|1|2|2|2|2|3|3|3|3|4|4|4|4|5|5|5|5|
             +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
	                      v v v v
             +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
             |1|1|1|1|2|2|2|2|1|2|4|5|4|4|4|4|5|5|5|5|
             +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

              Before and after deletion of next hop 3
	      under the resilient hashing algorithm.

When weights of next hops in a group are altered, it may be possible to
choose a subset of buckets that are currently not used for forwarding
traffic, and use those to satisfy the new next-hop distribution demands,
keeping the "busy" buckets intact. This way, established flows are ideally
kept being forwarded to the same endpoints through the same paths as before
the next-hop group change.

This patch set adds the implementation of resilient next-hop groups.

In a nutshell, the algorithm works as follows. Each next hop has a number
of buckets that it wants to have, according to its weight and the number of
buckets in the hash table. In case of an event that might cause bucket
allocation change, the numbers for individual next hops are updated,
similarly to how ranges are updated for mpath group next hops. Following
that, a new "upkeep" algorithm runs, and for idle buckets that belong to a
next hop that is currently occupying more buckets than it wants (it is
"overweight"), it migrates the buckets to one of the next hops that has
fewer buckets than it wants (it is "underweight"). If, after this, there
are still underweight next hops, another upkeep run is scheduled to a
future time.

Chances are there are not enough "idle" buckets to satisfy the new demands.
The algorithm has knobs to select both what it means for a bucket to be
idle, and for whether and when to forcefully migrate buckets if there keeps
being an insufficient number of idle ones.

To illustrate the usage, consider the following commands:

 # ip nexthop add id 1 via 192.0.2.2 dev dummy1
 # ip nexthop add id 2 via 192.0.2.3 dev dummy1
 # ip nexthop add id 10 group 1/2 type resilient \
	buckets 8 idle_timer 60 unbalanced_timer 300

The last command creates a resilient next-hop group. It will have 8
buckets, each bucket will be considered idle when no traffic hits it for at
least 60 seconds, and if the table remains out of balance for 300 seconds,
it will be forcefully brought into balance.

If not present in netlink message, the idle timer defaults to 120 seconds,
and there is no unbalanced timer, meaning the group may remain unbalanced
indefinitely. The value of 120 is the default in Cumulus implementation of
resilient next-hop groups. To a degree the default is arbitrary, the only
value that certainly does not make sense is 0. Therefore going with an
existing deployed implementation is reasonable.

Unbalanced time, i.e. how long since the last time that all nexthops had as
many buckets as they should according to their weights, is reported when
the group is dumped:

 # ip nexthop show id 10
 id 10 group 1/2 type resilient buckets 8 idle_timer 60 unbalanced_timer 300 unbalanced_time 0

When replacing next hops or changing weights, if one does not specify some
parameters, their value is left as it was:

 # ip nexthop replace id 10 group 1,2/2 type resilient
 # ip nexthop show id 10
 id 10 group 1,2/2 type resilient buckets 8 idle_timer 60 unbalanced_timer 300 unbalanced_time 0

It is also possible to do a dump of individual buckets (and now you know
why there were only 8 of them in the example above):

 # ip nexthop bucket show id 10
 id 10 index 0 idle_time 5.59 nhid 1
 id 10 index 1 idle_time 5.59 nhid 1
 id 10 index 2 idle_time 8.74 nhid 2
 id 10 index 3 idle_time 8.74 nhid 2
 id 10 index 4 idle_time 8.74 nhid 1
 id 10 index 5 idle_time 8.74 nhid 1
 id 10 index 6 idle_time 8.74 nhid 1
 id 10 index 7 idle_time 8.74 nhid 1

Note the two buckets that have a shorter idle time. Those are the ones that
were migrated after the nexthop replace command to satisfy the new demand
that nexthop 1 be given 6 buckets instead of 4.

The patchset proceeds as follows:

- Patches #1 and #2 are small refactoring patches.

- Patch #3 adds a new flag to struct nh_group, is_multipath. This flag is
  meant to be set for all nexthop groups that in general have several
  nexthops from which they choose, and avoids a more expensive dispatch
  based on reading several flags, one for each nexthop group type.

- Patch #4 contains defines of new UAPI attributes and the new next-hop
  group type. At this point, the nexthop code is made to bounce the new
  type. As the resilient hashing code is gradually added in the following
  patch sets, it will remain dead. The last patch will make it accessible.

  This patch also adds a suite of new messages related to next hop buckets.
  This approach was taken instead of overloading the information on the
  existing RTM_{NEW,DEL,GET}NEXTHOP messages for the following reasons.

  First, a next-hop group can contain a large number of next-hop buckets
  (4k is not unheard of). This imposes limits on the amount of information
  that can be encoded for each next-hop bucket given a netlink message is
  limited to 64k bytes.

  Second, while RTM_NEWNEXTHOPBUCKET is only used for notifications at this
  point, in the future it can be extended to provide user space with
  control over next-hop buckets configuration.

- Patch #5 contains the meat of the resilient next-hop group support.

- Patches #6 and #7 implement support for notifications towards the
  drivers.

- Patch #8 adds an interface for the drivers to report resilient hash
  table bucket activity. Drivers will be able to report through this
  interface whether traffic is hitting a given bucket.

- Patch #9 adds an interface for the drivers to report whether a given
  hash table bucket is offloaded or trapping traffic.

- In patches #10, #11, #12 and #13, UAPI is implemented. This includes all
  the code necessary for creation of resilient groups, bucket dumping and
  getting, and bucket migration notifications.

- In patch #14 the next-hop groups are finally made available.

The overall plan is to contribute approximately the following patchsets:

1) Nexthop policy refactoring (already pushed)
2) Preparations for resilient next-hop groups (already pushed)
3) Implementation of resilient next-hop groups (this patchset)
4) Netdevsim offload plus a suite of selftests
5) Preparations for mlxsw offload of resilient next-hop groups
6) mlxsw offload including selftests

Interested parties can look at the current state of the code at [2] and
[3].

[1] https://tools.ietf.org/html/rfc2992
[2] https://github.com/idosch/linux/commits/submit/res_integ_v1
[3] https://github.com/idosch/iproute2/commits/submit/res_v1

v2:
- Patch #4:
    - Comment at NEXTHOP_GRP_TYPE_MPATH that it's for the hash-threshold
      groups.

v1 (changes since RFC):
- Patch #3:
    - This patch is new
- Patches #4-#13:
    - u32 -> u16 for bucket counts / indices
- Patch #5:
    - set the new flag is_multipath for resilient groups

Ido Schimmel (4):
  nexthop: Add netlink defines and enumerators for resilient NH groups
  nexthop: Add data structures for resilient group notifications
  nexthop: Allow setting "offload" and "trap" indication of nexthop
    buckets
  nexthop: Allow reporting activity of nexthop buckets

Petr Machata (10):
  nexthop: Pass nh_config to replace_nexthop()
  nexthop: __nh_notifier_single_info_init(): Make nh_info an argument
  nexthop: Add a dedicated flag for multipath next-hop groups
  nexthop: Add implementation of resilient next-hop groups
  nexthop: Implement notifiers for resilient nexthop groups
  nexthop: Add netlink handlers for resilient nexthop groups
  nexthop: Add netlink handlers for bucket dump
  nexthop: Add netlink handlers for bucket get
  nexthop: Notify userspace about bucket migrations
  nexthop: Enable resilient next-hop groups

 include/net/nexthop.h          |   72 +-
 include/uapi/linux/nexthop.h   |   47 +-
 include/uapi/linux/rtnetlink.h |    7 +
 net/ipv4/nexthop.c             | 1524 ++++++++++++++++++++++++++++++--
 security/selinux/nlmsgtab.c    |    5 +-
 5 files changed, 1600 insertions(+), 55 deletions(-)

-- 
2.26.2

