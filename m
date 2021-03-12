Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9ADA3393E5
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 17:52:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231928AbhCLQvr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 11:51:47 -0500
Received: from mail-dm6nam10on2079.outbound.protection.outlook.com ([40.107.93.79]:7808
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231346AbhCLQvS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 11:51:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lNqUYQ2Nh4GsfgOShpRza/1u5VgTdL4mUPh48QiHJP0LGjVsl6Nsv2vekKgrDNgIguryZathj53y78JKuoDdpQoAMv6efVrH++wwe1S5QT8PWmtGU6snIK7vnGOuyUDfwnOm/oNiB07hfZYcv5P55jGYSk2nx6iIfCIHuYy3ZeRPWDJUkoeI2h9PCKbd4H4vqhGSxw7/Sr306paNpr30uQoYwrqa8hhAP8kBhV+lh8kuzJgWVyaUHcO99zBXFL79jK+GAoP0fC6pIHEBVOstGZLkNebOJIcnW5YNIPt7kFMfc2x7LjzNekVvjsZdUY8P/JiSCFP4727qTY1qbBaphg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=miqk23DoUrOiQlTcs6VOZekMuHtf79wVliAvuLh/6hk=;
 b=WOl9R2FEXsGHksrezmClM/agrq9ZRhRkzyX6I9GrdIPLwLI3p7kq/ihLLTZfSc9h4S8Hi8vhPM2PqXCZUcyMe7X8hioNNPaAQXvoe8MxYy2hYN3g/mGvh662X6qPq14eyp1CSQ4cdbSdjIIDIXMyex/Xa0nj4pSurbxdOPUVz+L/aY33iPe7XX0GXpbjqziqhlTvWabXRhV0xS6919nIt6UN+/VBXmv53Vdt5dVUXoJSDXgvIzyIPzOzXhjb8OqHnN2ONT1oo1Xp3aI2CmfM8vXy5F5gXxyMp/m8R0xaHyCp0k7AqJcYOS1Afc6Q/+HvYkEzDZy1+7J7RfG5YEDMEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=miqk23DoUrOiQlTcs6VOZekMuHtf79wVliAvuLh/6hk=;
 b=Ba61MlxoBLlD4X71l17o5iwx1+swEh6MRQ5U/gb9zeIJjDdGIshizkYLpLjqk1MTLB/RSf2T9xJ9swbBPI1gHxAxU5w7l+pK/Cm9jhfkLWNzN9qmTL3tXysnp+aUH9rO/bU5F1MGmiQq+WkpbyTkHgmBCfrn9fbEqJiqTgDFKdbigJ9H7nG8LzpISfzmw9VbJxCV9s5AJRyLGYNehyRp07qr//zmibdSJyVMNw9/mcrf7xrvkJAdRKj+wYZlq8Y+iA6laC7mjCF2b4J/FO8aFJ47SKgisToTtMtLPGIXfV7u8QlrBawR4kCXjOFEG7yaPKQl09t3bjCYdS2OyE5KXA==
Received: from DM6PR06CA0017.namprd06.prod.outlook.com (2603:10b6:5:120::30)
 by MN2PR12MB4640.namprd12.prod.outlook.com (2603:10b6:208:38::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Fri, 12 Mar
 2021 16:51:16 +0000
Received: from DM6NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:120:cafe::db) by DM6PR06CA0017.outlook.office365.com
 (2603:10b6:5:120::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.18 via Frontend
 Transport; Fri, 12 Mar 2021 16:51:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT060.mail.protection.outlook.com (10.13.173.63) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Fri, 12 Mar 2021 16:51:15 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 12 Mar
 2021 16:51:12 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH net-next 00/10] net: Resilient NH groups: netdevsim, selftests
Date:   Fri, 12 Mar 2021 17:50:16 +0100
Message-ID: <cover.1615563035.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9895567c-5eda-4608-9a76-08d8e5770d16
X-MS-TrafficTypeDiagnostic: MN2PR12MB4640:
X-Microsoft-Antispam-PRVS: <MN2PR12MB46406141FE78CFB19A7F86F3D66F9@MN2PR12MB4640.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JOOTavVVmI9BO6VKDse7LuRhduAltTb/ghIHBqoMO+mVQKTryYZQVZTftfAe7R1VH+5fIZ+LciZgr+gzkfLcL36DiBxnRxtkmSOxZieiBvuLjrja+IFa2Gu4K2B7mN0BU7nwstH+zob+pNqLhI+5FeprsFdnbqLWOltFuU355KtDmzCzvY+zgC7vX/rzMKHaQYEDVT9zPSStnXCWeL+V1LUsavPbk07yKtDyp7XZaTGpBgxn0/rgXiWGnrtBC96FO3tXQ92q932//NYGHGtQs5exM1PnwNfmIONiRHBM7d8mHbnidfap1+IaW4QUZ0w47AXT7vSV9k3oR927Cil9qaU/FKXdhDMH8wvhPytJmaBgIQ0a8Rkd/sq/EK4rbbta5zW16RAmT5smEJ+TEoddq9qarlQxSa/hLROuko2nYhpJnTNtLlCIP+nxJfNixfYfEhVVzP2sI3vRYyld+G7yd/clBdzKw9dgJMg/EI8HpFIrR0Ppl7620YxWi5vcWGuyi6ZQv1SxxgLoraEC39p9592MtKLqjRHX8QzIl9zQU/GY2gYqAwfj7b3paqSmjf3/vtM2efBrYKAUZmVcWOTAlEbmzVfpm2uFZ1KLX8vkmH95AEIwIWeznVpeqlQiIS/hmvzbCPiZPw/+yMgFS0vQDnuaNxYR54WUIWCjq/zGEqRWmvub2i/rRyHtEkOhg/JAu6QNPH1ObUaiUQ7Fig3VgvSnZZotAzL3+TSClMeNmihKvk2eQdvWMeN8oMG0HdMQA+J0NQdy2fpBhPjlQ3sP1Q==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(346002)(376002)(136003)(39860400002)(46966006)(36840700001)(5660300002)(7636003)(356005)(70206006)(70586007)(34020700004)(36860700001)(82310400003)(36756003)(47076005)(66574015)(82740400003)(83380400001)(8676002)(426003)(4326008)(2616005)(6916009)(966005)(54906003)(478600001)(86362001)(316002)(336012)(107886003)(16526019)(186003)(36906005)(8936002)(26005)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2021 16:51:15.5299
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9895567c-5eda-4608-9a76-08d8e5770d16
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4640
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support for resilient next-hop groups was added in a previous patch set.
Resilient next hop groups add a layer of indirection between the SKB hash
and the next hop. Thus the hash is used to reference a hash table bucket,
which is then used to reference a particular next hop. This allows the
system more flexibility when assigning SKB hash space to next hops.
Previously, each next hop had to be assigned a continuous range of SKB hash
space. With a hash table as an intermediate layer, it is possible to
reassign next hops with a hash table bucket granularity. In turn, this
mends issues with traffic flow redirection resulting from next hop removal
or adjustments in next-hop weights.

This patch set introduces mock offloading of resilient next hop groups by
the netdevsim driver, and a suite of selftests.

- Patch #1 adds a netdevsim-specific lock to protect next-hop hashtable.
  Previously, netdevsim relied on RTNL to maintain mutual exclusion.
  Patch #2 extracts a helper to make the following patches clearer.

- Patch #3 implements the support for offloading of resilient next-hop
  groups.

- Patch #4 introduces a new debugfs interface to set activity on a selected
  next-hop bucket. This simulates how HW can periodically report bucket
  activity, and buckets thus marked are expected to be exempt from
  migration to new next hops when the group changes.

- Patches #5 and #6 clean up the fib_nexthop selftests.

- Patches #7, #8 and #9 add tests for resilient next hop groups. Patch #7
  adds resilient-hashing counterparts to fib_nexthops.sh. Patch #8 adds a
  new traffic test for resilient next-hop groups. Patch #9 adds a new
  traffic test for tunneling.

- Patch #10 actually leverages the netdevsim offload to implement a suite
  of algorithmic tests that verify how and when buckets are migrated under
  various simulated workload scenarios.

The overall plan is to contribute approximately the following patchsets:

1) Nexthop policy refactoring (already pushed)
2) Preparations for resilient next hop groups (already pushed)
3) Implementation of resilient next hop group (already pushed)
4) Netdevsim offload plus a suite of selftests (this patchset)
5) Preparations for mlxsw offload of resilient next-hop groups
6) mlxsw offload including selftests

Interested parties can look at the complete code at [2].

[1] https://tools.ietf.org/html/rfc2992
[2] https://github.com/idosch/linux/commits/submit/res_integ_v1

Ido Schimmel (9):
  netdevsim: Create a helper for setting nexthop hardware flags
  netdevsim: Add support for resilient nexthop groups
  netdevsim: Allow reporting activity on nexthop buckets
  selftests: fib_nexthops: Declutter test output
  selftests: fib_nexthops: List each test case in a different line
  selftests: fib_nexthops: Test resilient nexthop groups
  selftests: forwarding: Add resilient hashing test
  selftests: forwarding: Add resilient multipath tunneling nexthop test
  selftests: netdevsim: Add test for resilient nexthop groups offload
    API

Petr Machata (1):
  netdevsim: fib: Introduce a lock to guard nexthop hashtable

 drivers/net/netdevsim/fib.c                   | 139 +++-
 .../drivers/net/netdevsim/nexthop.sh          | 620 ++++++++++++++++++
 tools/testing/selftests/net/fib_nexthops.sh   | 549 +++++++++++++++-
 .../net/forwarding/gre_multipath_nh_res.sh    | 361 ++++++++++
 .../net/forwarding/router_mpath_nh_res.sh     | 400 +++++++++++
 5 files changed, 2059 insertions(+), 10 deletions(-)
 create mode 100755 tools/testing/selftests/net/forwarding/gre_multipath_nh_res.sh
 create mode 100755 tools/testing/selftests/net/forwarding/router_mpath_nh_res.sh

-- 
2.26.2

