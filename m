Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D733234D460
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 17:58:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbhC2P6O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 11:58:14 -0400
Received: from mail-dm6nam12on2056.outbound.protection.outlook.com ([40.107.243.56]:9472
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229674AbhC2P57 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 11:57:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kGpG0GCmc9sqFkaixDNqdaE0B/HtIxAx4qmGiW5Hq/6WEDXwR8K9K4ef9vimaKAW2dJY/8PGgit1yB5M+59Wf6ELJYmw+duCylX6qqYJjsw9tJMABS6agn31RSRXFo7332uWMIfNczLtmxl4AQB7IEcZKylS9wrPhDRDF9vpMxmsUbdM5G7gB83J29NoZ/VlU7A+NS5FKKl4LVUDLXeiGnOB15NukFU2c0bUZEe6+8/mzCkXZc5SZcIY0kBlKy8SyRUBDqRRphts0tsNE4BNBOm+5dyHnjAOproJqpBvX/SvX2Cb3RSu9j/C5BsmI4zzNht6ffH667ZX4kDP7KHlSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dXo78IGG0zLXaeAirSgGYDsucw9fd85rPuGia+bOg1U=;
 b=LCNsIp/4q6KQyya6M+mR4H6I8moPjJUV1kQSlMq/X16STNBkRTyY34QsUSITNfAEM8nyqhNR9adg7rw8mvm8f4WV21r0hw1ic4iESpz0Ofbc1SSncJJfIPwF172Y9SCOPnxwu2+kDpUOC6eeMvINNny7+QWa32lkK12yGpEkrepL0EIXu/BY1hrmVThMTuISz6cT4diiTpXvGEWrLlI/0Y68CP6W8fF5ED2J1UbOBGjSkygKB7n9HNkzG2ZXLdB9i9hoaV0rfWBPMvXJFoBWZDahDM6aoLD5A5rsG1uAPsNNcsVALm3tpOLDJPIDUcLAM/b2aUnF1r80K9lge420uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dXo78IGG0zLXaeAirSgGYDsucw9fd85rPuGia+bOg1U=;
 b=fNw9hi6/hk0Fksy0ViOeL6G0uUJUe1qhQmCX6502ZFgy2fNj7gsPOuUWdIZV/gia8u6jCCAndwpgCJedMyQgBx0HnL7Hbzo89NKH2t58vzSFUR8/q1DFA66k0VFX1inRq0WInXtzdwLSMpGABwrP66RjYxc0F1Wf1qkk6w19RvPt3rjS97VpaxXPI3N1+WaE+XHZEQDrz52czRmrOBfl4gIC4mVNKSDMkm9Pxhs8BWe/Gz7q27FN7XbBih0uzooyCTNNchLJZn+YvPsHkSYFPqeu+Ukr/RlYEgjxzm/R2r1X9nJT2VOyNgKUrosu//cS7Lldf31AHqgpMNM3fH3Ffw==
Received: from MW2PR2101CA0026.namprd21.prod.outlook.com (2603:10b6:302:1::39)
 by CH2PR12MB5004.namprd12.prod.outlook.com (2603:10b6:610:62::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.26; Mon, 29 Mar
 2021 15:57:57 +0000
Received: from CO1NAM11FT050.eop-nam11.prod.protection.outlook.com
 (2603:10b6:302:1:cafe::a1) by MW2PR2101CA0026.outlook.office365.com
 (2603:10b6:302:1::39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.0 via Frontend
 Transport; Mon, 29 Mar 2021 15:57:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT050.mail.protection.outlook.com (10.13.174.79) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3955.18 via Frontend Transport; Mon, 29 Mar 2021 15:57:56 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 29 Mar
 2021 15:57:54 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>,
        "David Ahern" <dsahern@gmail.com>
Subject: [PATCH net-next] Documentation: net: Document resilient next-hop groups
Date:   Mon, 29 Mar 2021 17:57:31 +0200
Message-ID: <1a164ec0cc63a0d9f5dd9a1df891b6302c8c2326.1617033033.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 43aefa1e-7270-4bb5-cbc8-08d8f2cb6b88
X-MS-TrafficTypeDiagnostic: CH2PR12MB5004:
X-Microsoft-Antispam-PRVS: <CH2PR12MB5004D2720E76924DC769480AD67E9@CH2PR12MB5004.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1NLMuj4yrz9sOutnNhpZQkUX4+htiWspWVgu0K2OFTYXYtAYyHIgq/McBN432T1Hs+r3BufqSfhhUw4XsaklLwPUtX28yXkYKWL/x/l9mXXasqMQPC1kYNQ4DjK8z3FSoou4IUcY0DMgbXnZVWAWTZWvyYQec+xTxwRPOcxk7oOwldKMkIalvCJyzradVsbJLLYcmc048VRRSwKe7tLvANu4QEXplX4S4QrQlqSMH+XsvedJTjC89mNh7Cysi7YPs88lqdOevhBGB3hwV5JuAZqgbXMb8k7sJ6TXF/9l4A6t94UBZDdRlR76pYHq3o7kiVH4htPLxj5toSnTg5L7hLryznXJTrNsbxJwJxn686AqqN9cV3T/uy5FkBQZnTrcD60MkzvlFkVxX5sVD7CW9WhY1bP5pYujC02jt875eeeA8JR4FiJO5leLAS+n94IgCG82Fl25muZ3O+LWfYxmLTIpK0hGSJf+tR2oYnU9MnHcQUq1k5Mh77+eM7Sj+f9kCDMzBpizONFV5tSYRhCgAXjO9nEOX+0fa6O7qS7/gSctOuXFwJKNLPmZfqPG6WQLX0i0333/8hXSva8Ms3vcNkXzBbO8H8V67y9yF38c9i2Yz0AzgO0IDdlqhHBS6Y4Tc+vAMbZXSQ9T0iZsvylC1idpf5WgDKHGrZfC702OWs8=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(136003)(396003)(376002)(346002)(46966006)(36840700001)(86362001)(36906005)(356005)(478600001)(47076005)(36860700001)(336012)(8676002)(70206006)(426003)(83380400001)(5660300002)(6916009)(4326008)(6666004)(82740400003)(316002)(26005)(82310400003)(70586007)(7636003)(8936002)(2616005)(2906002)(36756003)(30864003)(16526019)(54906003)(186003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2021 15:57:56.8046
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 43aefa1e-7270-4bb5-cbc8-08d8f2cb6b88
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT050.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB5004
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a document describing the principles behind resilient next-hop groups,
and some notes about how to configure and offload them.

Suggested-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
---

Notes:
    v1 (from an RFC shared privately):
    - Dropped a reference to a non-existent footnote [Ido]
    - Spell out consequences of flow redirection explicitly [Ido]
    - A handful of wording changes [Ido]
    - Kept David's R-b due to minor scope of the above fixes

 Documentation/networking/index.rst            |   1 +
 .../networking/nexthop-group-resilient.rst    | 293 ++++++++++++++++++
 2 files changed, 294 insertions(+)
 create mode 100644 Documentation/networking/nexthop-group-resilient.rst

diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index b8a29997d433..e9ce55992aa9 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -76,6 +76,7 @@ Contents:
    netdevices
    netfilter-sysctl
    netif-msg
+   nexthop-group-resilient
    nf_conntrack-sysctl
    nf_flowtable
    openvswitch
diff --git a/Documentation/networking/nexthop-group-resilient.rst b/Documentation/networking/nexthop-group-resilient.rst
new file mode 100644
index 000000000000..fabecee24d85
--- /dev/null
+++ b/Documentation/networking/nexthop-group-resilient.rst
@@ -0,0 +1,293 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=========================
+Resilient Next-hop Groups
+=========================
+
+Resilient groups are a type of next-hop group that is aimed at minimizing
+disruption in flow routing across changes to the group composition and
+weights of constituent next hops.
+
+The idea behind resilient hashing groups is best explained in contrast to
+the legacy multipath next-hop group, which uses the hash-threshold
+algorithm, described in RFC 2992.
+
+To select a next hop, hash-threshold algorithm first assigns a range of
+hashes to each next hop in the group, and then selects the next hop by
+comparing the SKB hash with the individual ranges. When a next hop is
+removed from the group, the ranges are recomputed, which leads to
+reassignment of parts of hash space from one next hop to another. RFC 2992
+illustrates it thus::
+
+             +-------+-------+-------+-------+-------+
+             |   1   |   2   |   3   |   4   |   5   |
+             +-------+-+-----+---+---+-----+-+-------+
+             |    1    |    2    |    4    |    5    |
+             +---------+---------+---------+---------+
+
+              Before and after deletion of next hop 3
+	      under the hash-threshold algorithm.
+
+Note how next hop 2 gave up part of the hash space in favor of next hop 1,
+and 4 in favor of 5. While there will usually be some overlap between the
+previous and the new distribution, some traffic flows change the next hop
+that they resolve to.
+
+If a multipath group is used for load-balancing between multiple servers,
+this hash space reassignment causes an issue that packets from a single
+flow suddenly end up arriving at a server that does not expect them. This
+can result in TCP connections being reset.
+
+If a multipath group is used for load-balancing among available paths to
+the same server, the issue is that different latencies and reordering along
+the way causes the packets to arrive in the wrong order, resulting in
+degraded application performance.
+
+To mitigate the above-mentioned flow redirection, resilient next-hop groups
+insert another layer of indirection between the hash space and its
+constituent next hops: a hash table. The selection algorithm uses SKB hash
+to choose a hash table bucket, then reads the next hop that this bucket
+contains, and forwards traffic there.
+
+This indirection brings an important feature. In the hash-threshold
+algorithm, the range of hashes associated with a next hop must be
+continuous. With a hash table, mapping between the hash table buckets and
+the individual next hops is arbitrary. Therefore when a next hop is deleted
+the buckets that held it are simply reassigned to other next hops::
+
+	    +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+	    |1|1|1|1|2|2|2|2|3|3|3|3|4|4|4|4|5|5|5|5|
+	    +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+	                     v v v v
+	    +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+	    |1|1|1|1|2|2|2|2|1|2|4|5|4|4|4|4|5|5|5|5|
+	    +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+
+	    Before and after deletion of next hop 3
+	    under the resilient hashing algorithm.
+
+When weights of next hops in a group are altered, it may be possible to
+choose a subset of buckets that are currently not used for forwarding
+traffic, and use those to satisfy the new next-hop distribution demands,
+keeping the "busy" buckets intact. This way, established flows are ideally
+kept being forwarded to the same endpoints through the same paths as before
+the next-hop group change.
+
+Algorithm
+---------
+
+In a nutshell, the algorithm works as follows. Each next hop deserves a
+certain number of buckets, according to its weight and the number of
+buckets in the hash table. In accordance with the source code, we will call
+this number a "wants count" of a next hop. In case of an event that might
+cause bucket allocation change, the wants counts for individual next hops
+are updated.
+
+Next hops that have fewer buckets than their wants count, are called
+"underweight". Those that have more are "overweight". If there are no
+overweight (and therefore no underweight) next hops in the group, it is
+said to be "balanced".
+
+Each bucket maintains a last-used timer. Every time a packet is forwarded
+through a bucket, this timer is updated to current jiffies value. One
+attribute of a resilient group is then the "idle timer", which is the
+amount of time that a bucket must not be hit by traffic in order for it to
+be considered "idle". Buckets that are not idle are busy.
+
+After assigning wants counts to next hops, an "upkeep" algorithm runs. For
+buckets:
+
+1) that have no assigned next hop, or
+2) whose next hop has been removed, or
+3) that are idle and their next hop is overweight,
+
+upkeep changes the next hop that the bucket references to one of the
+underweight next hops. If, after considering all buckets in this manner,
+there are still underweight next hops, another upkeep run is scheduled to a
+future time.
+
+There may not be enough "idle" buckets to satisfy the updated wants counts
+of all next hops. Another attribute of a resilient group is the "unbalanced
+timer". This timer can be set to 0, in which case the table will stay out
+of balance until idle buckets do appear, possibly never. If set to a
+non-zero value, the value represents the period of time that the table is
+permitted to stay out of balance.
+
+With this in mind, we update the above list of conditions with one more
+item. Thus buckets:
+
+4) whose next hop is overweight, and the amount of time that the table has
+   been out of balance exceeds the unbalanced timer, if that is non-zero,
+
+\... are migrated as well.
+
+Offloading & Driver Feedback
+----------------------------
+
+When offloading resilient groups, the algorithm that distributes buckets
+among next hops is still the one in SW. Drivers are notified of updates to
+next hop groups in the following three ways:
+
+- Full group notification with the type
+  ``NH_NOTIFIER_INFO_TYPE_RES_TABLE``. This is used just after the group is
+  created and buckets populated for the first time.
+
+- Single-bucket notifications of the type
+  ``NH_NOTIFIER_INFO_TYPE_RES_BUCKET``, which is used for notifications of
+  individual migrations within an already-established group.
+
+- Pre-replace notification, ``NEXTHOP_EVENT_RES_TABLE_PRE_REPLACE``. This
+  is sent before the group is replaced, and is a way for the driver to veto
+  the group before committing anything to the HW.
+
+Some single-bucket notifications are forced, as indicated by the "force"
+flag in the notification. Those are used for the cases where e.g. the next
+hop associated with the bucket was removed, and the bucket really must be
+migrated.
+
+Non-forced notifications can be overridden by the driver by returning an
+error code. The use case for this is that the driver notifies the HW that a
+bucket should be migrated, but the HW discovers that the bucket has in fact
+been hit by traffic.
+
+A second way for the HW to report that a bucket is busy is through the
+``nexthop_res_grp_activity_update()`` API. The buckets identified this way
+as busy are treated as if traffic hit them.
+
+Offloaded buckets should be flagged as either "offload" or "trap". This is
+done through the ``nexthop_bucket_set_hw_flags()`` API.
+
+Netlink UAPI
+------------
+
+Resilient Group Replacement
+^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
+Resilient groups are configured using the ``RTM_NEWNEXTHOP`` message in the
+same manner as other multipath groups. The following changes apply to the
+attributes passed in the netlink message:
+
+  =================== =========================================================
+  ``NHA_GROUP_TYPE``  Should be ``NEXTHOP_GRP_TYPE_RES`` for resilient group.
+  ``NHA_RES_GROUP``   A nest that contains attributes specific to resilient
+                      groups.
+  =================== =========================================================
+
+``NHA_RES_GROUP`` payload:
+
+  =================================== =========================================
+  ``NHA_RES_GROUP_BUCKETS``           Number of buckets in the hash table.
+  ``NHA_RES_GROUP_IDLE_TIMER``        Idle timer in units of clock_t.
+  ``NHA_RES_GROUP_UNBALANCED_TIMER``  Unbalanced timer in units of clock_t.
+  =================================== =========================================
+
+Next Hop Get
+^^^^^^^^^^^^
+
+Requests to get resilient next-hop groups use the ``RTM_GETNEXTHOP``
+message in exactly the same way as other next hop get requests. The
+response attributes match the replacement attributes cited above, except
+``NHA_RES_GROUP`` payload will include the following attribute:
+
+  =================================== =========================================
+  ``NHA_RES_GROUP_UNBALANCED_TIME``   How long has the resilient group been out
+                                      of balance, in units of clock_t.
+  =================================== =========================================
+
+Bucket Get
+^^^^^^^^^^
+
+The message ``RTM_GETNEXTHOPBUCKET`` without the ``NLM_F_DUMP`` flag is
+used to request a single bucket. The attributes recognized at get requests
+are:
+
+  =================== =========================================================
+  ``NHA_ID``          ID of the next-hop group that the bucket belongs to.
+  ``NHA_RES_BUCKET``  A nest that contains attributes specific to bucket.
+  =================== =========================================================
+
+``NHA_RES_BUCKET`` payload:
+
+  ======================== ====================================================
+  ``NHA_RES_BUCKET_INDEX`` Index of bucket in the resilient table.
+  ======================== ====================================================
+
+Bucket Dumps
+^^^^^^^^^^^^
+
+The message ``RTM_GETNEXTHOPBUCKET`` with the ``NLM_F_DUMP`` flag is used
+to request a dump of matching buckets. The attributes recognized at dump
+requests are:
+
+  =================== =========================================================
+  ``NHA_ID``          If specified, limits the dump to just the next-hop group
+                      with this ID.
+  ``NHA_OIF``         If specified, limits the dump to buckets that contain
+                      next hops that use the device with this ifindex.
+  ``NHA_MASTER``      If specified, limits the dump to buckets that contain
+                      next hops that use a device in the VRF with this ifindex.
+  ``NHA_RES_BUCKET``  A nest that contains attributes specific to bucket.
+  =================== =========================================================
+
+``NHA_RES_BUCKET`` payload:
+
+  ======================== ====================================================
+  ``NHA_RES_BUCKET_NH_ID`` If specified, limits the dump to just the buckets
+                           that contain the next hop with this ID.
+  ======================== ====================================================
+
+Usage
+-----
+
+To illustrate the usage, consider the following commands::
+
+	# ip nexthop add id 1 via 192.0.2.2 dev eth0
+	# ip nexthop add id 2 via 192.0.2.3 dev eth0
+	# ip nexthop add id 10 group 1/2 type resilient \
+		buckets 8 idle_timer 60 unbalanced_timer 300
+
+The last command creates a resilient next-hop group. It will have 8 buckets
+(which is unusually low number, and used here for demonstration purposes
+only), each bucket will be considered idle when no traffic hits it for at
+least 60 seconds, and if the table remains out of balance for 300 seconds,
+it will be forcefully brought into balance.
+
+Changing next-hop weights leads to change in bucket allocation::
+
+	# ip nexthop replace id 10 group 1,3/2 type resilient
+
+This can be confirmed by looking at individual buckets::
+
+	# ip nexthop bucket show id 10
+	id 10 index 0 idle_time 5.59 nhid 1
+	id 10 index 1 idle_time 5.59 nhid 1
+	id 10 index 2 idle_time 8.74 nhid 2
+	id 10 index 3 idle_time 8.74 nhid 2
+	id 10 index 4 idle_time 8.74 nhid 1
+	id 10 index 5 idle_time 8.74 nhid 1
+	id 10 index 6 idle_time 8.74 nhid 1
+	id 10 index 7 idle_time 8.74 nhid 1
+
+Note the two buckets that have a shorter idle time. Those are the ones that
+were migrated after the next-hop replace command to satisfy the new demand
+that next hop 1 be given 6 buckets instead of 4.
+
+Netdevsim
+---------
+
+The netdevsim driver implements a mock offload of resilient groups, and
+exposes debugfs interface that allows marking individual buckets as busy.
+For example, the following will mark bucket 23 in next-hop group 10 as
+active::
+
+	# echo 10 23 > /sys/kernel/debug/netdevsim/netdevsim10/fib/nexthop_bucket_activity
+
+In addition, another debugfs interface can be used to configure that the
+next attempt to migrate a bucket should fail::
+
+	# echo 1 > /sys/kernel/debug/netdevsim/netdevsim10/fib/fail_nexthop_bucket_replace
+
+Besides serving as an example, the interfaces that netdevsim exposes are
+useful in automated testing, and
+``tools/testing/selftests/drivers/net/netdevsim/nexthop.sh`` makes use of
+them to test the algorithm.
-- 
2.26.2

