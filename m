Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 834DD33D1AE
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 11:21:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236525AbhCPKV1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 06:21:27 -0400
Received: from mail-mw2nam12on2079.outbound.protection.outlook.com ([40.107.244.79]:41185
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234139AbhCPKVE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 06:21:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LVE9y3rTrxNM3eoKk73/+pkLIAzEemcpKO1S2q5/6WXOnL5661I4k/uxM3vQOkJj5cSxxS0elPyR0RqEN1avV9S8urU4dvT9YqT3ZOlNjO7Q2QeGN09B8+eSGwz8ZXPzqsU3G64CQ/n0HkkXBbCvKEVm+kUIv0cG89mWpz952x7uRp80k6QyM8pSIXrvFJedetL/jZJc+9EC5CU+hN/SH0Dt5Uvd1t2eXdTsLWc9ixzDHTuyD6VMb6aYL+bkSIQfgrQKMEgeLDqwP9tpipiX6ChbIkF50ReytHNZ5sBTHJw56ICv7NBJHkeBdA81DFb8B+QqG6x8B7VH/kewR7UEww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qRfQLoLJS4K4VB1RCx7TPpAJpPkjcI6nzqR85JuXufI=;
 b=nUqG2QX8WMlNBn41yHad6fvLiNVesnPPmaAppiLWMsrZQMOvUQdbInl9ce4CXDo6F8p6joAQkdK2E6PeC3iJGgHdIsxAYxafIKuc4V02dqPQsJ6yoZGgfZ/Cczl6LH7/ockaTFGkNNOQ+vgpioMtm4Kl0wH0+8fcxNg3j65TwQvfeN8n1zVB+9OKt9EsUL96SlPwuDsS7Tj8+7V3itJlSoZ41+j40v3Tfcq83zdF2eKRINLGJVQcgffhuj3+Uaw5tGLyTal9RP/bCa8gc07j2aBDqo+uZ0uLHN5yRUdradn7I+6IXRxIYAEQ/pIgDFnqFJ3ZR+YVsjt9JLZ9tC2mkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qRfQLoLJS4K4VB1RCx7TPpAJpPkjcI6nzqR85JuXufI=;
 b=D01OWZck5Jh7zrXIc0vzWK/asUrZiZTyICWa9+Wgi5oIGaF/yrDuA+jxrdlWx1BI7r1H5tyH8qq2ulDev6AyR6+vLelk7tAlL2uGeZuwjQS55oDba6SG946rKvGuLhEgXwEz6HMdqa+vi/JWXNd6GxIHZmnZdfHHl/ab0L61ecfW7mB1QiJubqOamd3cBrmR4GOcs3mjBMLtJtjFl8JKc3oqJjQ26OHl/wPxhiJURSM4UclwNzVUoOcBJXw/JndBUX94D3CErp94lCtREzbleOpUh3Pqh4RvsnEDNZ0mNaVmRuyYA70dVBDhBQUl5Ux/uddrPT+Pv76Vn3NRAwoqvQ==
Received: from BN6PR21CA0013.namprd21.prod.outlook.com (2603:10b6:404:8e::23)
 by BYAPR12MB3512.namprd12.prod.outlook.com (2603:10b6:a03:134::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Tue, 16 Mar
 2021 10:20:59 +0000
Received: from BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:8e:cafe::c1) by BN6PR21CA0013.outlook.office365.com
 (2603:10b6:404:8e::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.2 via Frontend
 Transport; Tue, 16 Mar 2021 10:20:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT019.mail.protection.outlook.com (10.13.176.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Tue, 16 Mar 2021 10:20:59 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 16 Mar
 2021 10:20:53 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>, <dsahern@gmail.com>,
        <stephen@networkplumber.org>
CC:     Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>
Subject: [PATCH iproute2-next v3 0/6] ip: nexthop: Support resilient groups
Date:   Tue, 16 Mar 2021 11:20:10 +0100
Message-ID: <cover.1615889875.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1c29b941-01ac-4550-73b7-08d8e865317a
X-MS-TrafficTypeDiagnostic: BYAPR12MB3512:
X-Microsoft-Antispam-PRVS: <BYAPR12MB35126E943059D1D6B7F8C201D66B9@BYAPR12MB3512.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8u6A7weOvl98X25UvCdfBRqt4we6Lh+ewrv6PNz5XwkFE8lROXHB5UE2D7m8VXnqsxpA9mFWvcV3LgCMvSeU9xWDSdtsVyNniRrGfqZTr/1acNwfTzzSSE8kMCtgwB1BsRAbFpsmtuFLyScleYSNvwziyN8pQ6spLtw9JqrBBNHZHyXlB92W3BFLm/dseOMpN36J1A0fqRhDiNz3SFswGyN0z/3NFefT0CZKfeHEQvCUlPxJp3xErObletQ2pr2g+No+gp1FoPrVcmHpdZzrxXWn3CY47BKrQUUIO9ziah+Li2H3a8p+3dDJKor1Yd5wrYOMTXsz7cCMiTJiNnme0R75ZZjxXYHyLd27Q1b6x9HUIqHZG7OM/p4MuGY0AA9+kDiiB+WgB92Jd2YfQvcBqsTo5iLALQTL1KTyNXqLSE+MljaZ/v4MMGEGY933m02Gd9tWwe3QDqPc51oekn9PGH6uVzIraU9FQc3kVvH0pBFP4aEeD+ExtXcC/aGwNeUGctxNPR8Z+72iMf1CKNaPZzSyD+KOS8E5DOxsNxdk9JjY1HbnTRI5LDs2c0I9DlAZJjX8AcJU99Hx8o4he6U8MJ0IJzQmnSBP8b+kfJutsV8K3rQCNMz07Lzk8FO6VONquyEeWg6sJZhURDQZOGwodY3nB+PujG8O5ah/JAhMbHuSnnSrKmSrNfoSL1p6DMEVdKZo37pgMHTpJn3fe7TZeB+hii+rpvcawLoVI2dwsLgY/XVmrL2WXk3QP3rqDK8hnVJId/HtBuH6NST2N2Ct8g==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(136003)(346002)(376002)(39860400002)(46966006)(36840700001)(356005)(5660300002)(2616005)(966005)(110136005)(8676002)(426003)(86362001)(2906002)(70206006)(36906005)(186003)(54906003)(316002)(16526019)(83380400001)(26005)(70586007)(478600001)(107886003)(4326008)(36860700001)(36756003)(336012)(6666004)(47076005)(7636003)(8936002)(34020700004)(82740400003)(82310400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2021 10:20:59.0685
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c29b941-01ac-4550-73b7-08d8e865317a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3512
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support for resilient next-hop groups was recently accepted to Linux
kernel[1]. Resilient next-hop groups add a layer of indirection between the
SKB hash and the next hop. Thus the hash is used to reference a hash table
bucket, which is then used to reference a particular next hop. This allows
the system more flexibility when assigning SKB hash space to next hops.
Previously, each next hop had to be assigned a continuous range of SKB hash
space. With a hash table as an intermediate layer, it is possible to
reassign next hops with a hash table bucket granularity. In turn, this
mends issues with traffic flow redirection resulting from next hop removal
or adjustments in next-hop weights.

In this patch set, introduce support for resilient next-hop groups to
iproute2.

- Patch #1 brings include/uapi/linux/nexthop.h and /rtnetlink.h up to date.

- Patches #2 and #3 add new helpers that will be useful later.

- Patch #4 extends the ip/nexthop sub-tool to accept group type as a
  command line argument, and to dispatch based on the specified type.

- Patch #5 adds the support for resilient next-hop groups.

- Patch #6 adds the support for resilient next-hop group bucket interface.

To illustrate the usage, consider the following commands:

 # ip nexthop add id 1 via 192.0.2.2 dev dummy1
 # ip nexthop add id 2 via 192.0.2.3 dev dummy1
 # ip nexthop add id 10 group 1/2 type resilient \
	buckets 8 idle_timer 60 unbalanced_timer 300

The last command creates a resilient next-hop group. It will have 8
buckets, each bucket will be considered idle when no traffic hits it for at
least 60 seconds, and if the table remains out of balance for 300 seconds,
it will be forcefully brought into balance.

And this is how the next-hop group bucket interface looks:

 # ip nexthop bucket show id 10
 id 10 index 0 idle_time 5.59 nhid 1
 id 10 index 1 idle_time 5.59 nhid 1
 id 10 index 2 idle_time 8.74 nhid 2
 id 10 index 3 idle_time 8.74 nhid 2
 id 10 index 4 idle_time 8.74 nhid 1
 id 10 index 5 idle_time 8.74 nhid 1
 id 10 index 6 idle_time 8.74 nhid 1
 id 10 index 7 idle_time 8.74 nhid 1

[1] https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=2a0186a37700b0d5b8cc40be202a62af44f02fa2

v3:
- Add missing S-o-b's.

v2:
- Patch #4:
    - Add a missing example command to commit message
    - Mention in the man page that mpath is the default

Ido Schimmel (3):
  nexthop: Add ability to specify group type
  nexthop: Add support for resilient nexthop groups
  nexthop: Add support for nexthop buckets

Petr Machata (3):
  nexthop: Synchronize uAPI files
  json_print: Add print_tv()
  nexthop: Extract a helper to parse a NH ID

 include/json_print.h           |   1 +
 include/libnetlink.h           |   3 +
 include/uapi/linux/nexthop.h   |  47 +++-
 include/uapi/linux/rtnetlink.h |   7 +
 ip/ip_common.h                 |   1 +
 ip/ipmonitor.c                 |   6 +
 ip/ipnexthop.c                 | 451 ++++++++++++++++++++++++++++++++-
 lib/json_print.c               |  13 +
 lib/libnetlink.c               |  26 ++
 man/man8/ip-nexthop.8          | 113 ++++++++-
 10 files changed, 651 insertions(+), 17 deletions(-)

-- 
2.26.2

