Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7249733410B
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 16:04:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232481AbhCJPEB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 10:04:01 -0500
Received: from mail-bn7nam10on2051.outbound.protection.outlook.com ([40.107.92.51]:50657
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233029AbhCJPDx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 10:03:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aiqWBnGd4tGuYr0dxufg4Md5Np/ebh9ITzFe8AW562ZuLtl9c1uEpGIOZBL7YMlf6IE3wSkhN1VYM7p0Av2PiPXsFQhPHJLijB3u1EoplKKjY0HRkcg4r7i+CXA6Dh78p4yDONiKLwhygrR3lsCrxshFv/hAGvc0F3Q1Yl/+y48f9+Nvxxsmo8WnNmECNLZbo4uNKIoVGuvmrkztS9fKD/i8U+F5G+SjqhqPr0+BS7t59Ouys7uIaE3eUsSEtq9PmMqiOba6hJFJZlYaV5lMS8fENZ2FIWnDkJH6VY3Pn81Q+ItUehYpGaYzQXPPODLxDkfhAzmVYFeXFWWoWi9oXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JUoGV4DilhQ1CSpDJtU8Jt5EerMQg8PSkjSttWf7Kjs=;
 b=HHBvBsVpc540TDxI5d7gs7qLITr1gyz2x4TnSIFrGOgHd1KyMjj6IcPhx1Eu1dDZJZXTK7qrkq+E570qXGgYm/XbU4KatqEBxTOnM4GVO6uxJf6TKw/YQPQLgN5Q1ewRhyXDZ+itf4cSEu55anBlDeiuJBLn/+bt6AqqpTdDsRBuDl8K+aLKRegSoeFnbY11JCsiD8BPo8l5rBkm7C0slwrjLPiywaEjLsiT3o2ChT/a59Vw9IIRm2ANC5lK5BHFTY4wrkuI5l/RG0SHoc/IXjs94k+BdRaEzFDYs2MtseH0bgJffFof0FGk8dRUG5Y5L1LJW+aBmFSs+95PpJu6lQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JUoGV4DilhQ1CSpDJtU8Jt5EerMQg8PSkjSttWf7Kjs=;
 b=rWWdHqSA0fGl6cEB6QpnoRJMXDwVBKQm9iRUT4hKqdKUe0xHjz431eNlhOSxb41CAggyZeEd8cNxbqGDcGKWdHB+rsFEG80m8CAd1UQJA4Fcw3UVywDB5YSvuvc24BcbgcryaC68N7HT3O8V8/eTKMwJ+c8dUPvYIGeBtB6EXgpVPiyNDHilaoZpmHeaDNrkQGPRFNJ7909zbpRaO2YEmczdxuiDvIpxdbpM3nneCRdnqAt7U5hm3J6T+TjtUj1TuwupFSEbM7gFO46z46M4eMqCP+f5JcQARLdIwMNte50vfDgXNPKONW3EIttHJlunySh634U9CfrSqhReMD/v6Q==
Received: from DM3PR14CA0129.namprd14.prod.outlook.com (2603:10b6:0:53::13) by
 BL0PR12MB4993.namprd12.prod.outlook.com (2603:10b6:208:17e::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3912.17; Wed, 10 Mar 2021 15:03:51 +0000
Received: from DM6NAM11FT012.eop-nam11.prod.protection.outlook.com
 (2603:10b6:0:53:cafe::e6) by DM3PR14CA0129.outlook.office365.com
 (2603:10b6:0:53::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend
 Transport; Wed, 10 Mar 2021 15:03:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT012.mail.protection.outlook.com (10.13.173.109) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Wed, 10 Mar 2021 15:03:51 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 10 Mar
 2021 15:03:48 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH net-next 00/14] nexthop: Resilient next-hop groups
Date:   Wed, 10 Mar 2021 16:02:51 +0100
Message-ID: <cover.1615387786.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b01200d9-f75b-4a57-d32d-08d8e3d5b710
X-MS-TrafficTypeDiagnostic: BL0PR12MB4993:
X-Microsoft-Antispam-PRVS: <BL0PR12MB49936A239DEA992FCB38A340D6919@BL0PR12MB4993.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NAjyK8ecNOT9PnvVk2Y9/dG5zvSiwrONUxPzrWxhW2OKx16MrqEuMqVLmTUE6qtd/LB/oi55tek9Cq3ua2sJKfqETfLCYRRDOAwl6K0lG26C9H8wLJtithES7g7rtqweny1Oj68ldctVMuFxHqqMWc0kD1InOCy37RrToxvKm5KTD/7+ntNNMCRQn7LNENpakjE4gGpWI0jObyJvqJYDy1wvhFzGl/TDdNUMZs+5jxSP6bfnWvbr11+z7H0x6vEsI138zb63nOZNJvfEhjKqk0q4KM0qRJcGykivpkZVG4Ixf4DpI5Wr5rOOhz60xe0LWZy1TuBlYxEQ0RMDCgXWi+s2Yd4l8Vf/4v8nEM+6XJh7AHIKrj5kTjiLSKKMELHo9Sp7IaKiXpMAt5CkWs2qIsJgAHLD08owsaJATyQVq4jSiic+wxEjeBwz8+Skd1Hcr63YtuMfHMFXDoCGbLCf1s1vCZ01OpdFWtbIapphsZQLm3QQZcMEMdu4AGh8CiSX4gqD1mhTVzOTcCS+6W3MatG5wB6arxs2NQRoBDZ7YzfKv6Vgv7bAJaQugzfowzBR/DWj/OR8PY9Q2mx91gHo6pUAXbgcFv+J4QzGegGbjPV6gzUO7AZtMGcL2ihGTqbvbQkjCs7Wrb9Ngai44UbYvM5/FY8oYczx7bJO+R8yQAwsV3PquhNoqMmgA7H2BcZdoibkPoXIaGBTxOEsw5XsVzvywBeuVi5igFTTkc2+Vjss3n+C4SMVPuri9SJPsnS1YFzD9+i8/+jjlJPtDEP9Fg==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(39860400002)(346002)(396003)(136003)(36840700001)(46966006)(30864003)(70206006)(356005)(6666004)(70586007)(966005)(7636003)(54906003)(83380400001)(8676002)(36756003)(8936002)(47076005)(36860700001)(4326008)(2906002)(6916009)(34020700004)(82310400003)(86362001)(107886003)(316002)(336012)(426003)(26005)(478600001)(36906005)(16526019)(5660300002)(2616005)(186003)(82740400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2021 15:03:51.0078
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b01200d9-f75b-4a57-d32d-08d8e3d5b710
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT012.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4993
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
 include/uapi/linux/nexthop.h   |   43 +
 include/uapi/linux/rtnetlink.h |    7 +
 net/ipv4/nexthop.c             | 1524 ++++++++++++++++++++++++++++++--
 security/selinux/nlmsgtab.c    |    5 +-
 5 files changed, 1597 insertions(+), 54 deletions(-)

-- 
2.26.2

