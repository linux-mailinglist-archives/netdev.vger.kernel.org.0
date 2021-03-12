Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0854233949E
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 18:25:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232697AbhCLRYg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 12:24:36 -0500
Received: from mail-dm6nam10on2083.outbound.protection.outlook.com ([40.107.93.83]:41057
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232529AbhCLRYN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 12:24:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bo9IL/egwBLb0L/sIXFBoVnzplKfpKcl31iWgiXj0zeumysLngz6Dy/HbK+HIW6QJTfuCmf+lRBx3hJQhylA70IJlaeGtO9719G2IJAPdidh8rc9188p/hQPZ099SvwqJ8vHKfcIxxhkLcnW4b3PJvwVOcELDwsOk1gSWVNvQ46xVEfO2zmL+ExJmxG1soPS56Dqv528KVF0ltWIWa+1Y9Aoc7QWAiCJoikkmlTN9r9VQm67P7CN8luidVKC4UzmIrdIAMBS3LaY158eXFftrkP9APQvQTCyxA+u3htxtTRHzg/juwJLGH/1Vdn/pvbz54UhJUa7+lQ9tOXcBIiz+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wtQ3f/DIM9vtmqmsDbAUFypOhqTRR5iXvbI8ZvYwc/c=;
 b=dOhp2OB4xgg1u0IrQRCtJRLKuyi/b9/xxGJwRHUFWr5xOYxwioA/qd9qX9iCh6U5DRDfPbDMea0sIduYVltj50y1N7zzpnTXrI0yWER7Mg7tacf4lnNJZ6fn+lb+HkVVpO0Cf1cE60nq9xsIdfnLB6ZQ10gYOPt5riaVhoxF4yPkxu1saTEWG3HWhM8xyixhFBIX0RK3p2P93NHzNjTFx51jYdWnl1toTw0bLHu28vw19EeekEHMwimyq5S2z3OxaeVEDo14HdT3+qHbNzhK4v/yDtSyWLczmXgxl/OtvVWcZRSgJA1GIw8HHRwI9o9POyF2r1+sdTSVAxjhVjxrwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wtQ3f/DIM9vtmqmsDbAUFypOhqTRR5iXvbI8ZvYwc/c=;
 b=jb1T2u8pSDG6NvCZM/UNMKEc0j4d5Uhu1FFaZa8sqqKlg2RZZxVYunRrXuMYLFicp6sYVmhvHEOzkKJmlevrQGBtZCqPVd7CL8uv5qaHxXJavaP4FmzHXZgYmcgS1iJFR+GPXdi+pV35LGA66Uj9Gts9YrTNIP44hzURACrVZVsCGnR9ZMq3ocl+Pa7bGzZELY8TS7t5dogBfNOw1OURCLJLd5zj+pwfyNRKwy5O/l/l0VY+HV1mnuQzXbD1Y4dHWlF13es3syZGKrn3kj9WTZNzQkHLQ/oAm1wZ6AbKx52mCHbS17s5ojrSJ3pyuasMQ1WK3UQOTZHFF+T4T+nl7A==
Received: from MWHPR13CA0020.namprd13.prod.outlook.com (2603:10b6:300:16::30)
 by BYAPR12MB3382.namprd12.prod.outlook.com (2603:10b6:a03:a9::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Fri, 12 Mar
 2021 17:24:06 +0000
Received: from CO1NAM11FT007.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:16:cafe::57) by MWHPR13CA0020.outlook.office365.com
 (2603:10b6:300:16::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.11 via Frontend
 Transport; Fri, 12 Mar 2021 17:24:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT007.mail.protection.outlook.com (10.13.174.131) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Fri, 12 Mar 2021 17:24:05 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 12 Mar
 2021 17:24:02 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>, <dsahern@gmail.com>,
        <stephen@networkplumber.org>
CC:     Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>
Subject: [PATCH iproute2-next 0/6] ip: nexthop: Support resilient groups
Date:   Fri, 12 Mar 2021 18:23:03 +0100
Message-ID: <cover.1615568866.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 37db6cb1-9a9b-48b7-a220-08d8e57ba362
X-MS-TrafficTypeDiagnostic: BYAPR12MB3382:
X-Microsoft-Antispam-PRVS: <BYAPR12MB33820C122B846083C33B62B9D66F9@BYAPR12MB3382.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TmjjSLDBBN4FuGJioliC+773P3/CebSsD0MHo47NvxwOfpACYMukbxxkXrYJPPeIFtN8VqaIJwanioQwF1dlHqvjrd7fhQa97xrumVb5xhhfNSAa3SFZMy634ipvD3cFNjWQCCoKdUqxjihaoouLwaf4VseB+fhxhiPCsXnPA/3yTdfjqN2Eka6YWmn00pMlqkYN4NiDvCJVsRMF7U6pFpYa0vooiYpQMjf0KAi8r2yBRws0TE7X6WUcdOetag0HaFQuD0TAcV94WJlgHhKUqPJ5qBq3MOku0AkYUDUGgqZq2jiEoy/XutLS/ytu5eu9ITpbaaOHll03v0Ovv8Qs/aD32jvz/UtHCRYXjgp5z4a9LKmIttImZzUeoAiCY90615Rhqmqb9orTME3B8gnaIRqRa+S3eeAwFGm+ICA1j/QKhnBKp5V2qlNr0vgZaUiXHKIoeMxW795iD38ThCjC39N8Lhcbv32ACxoGXNVHvPUhZIW5zmjHC4CP/E/gqzwQDbpntP8keZNq7Wpf1fPqo9dNN8t2MJy57D4ihDgxDAf/Q51YG/6R5tmd0Ko+yxmkepA/XcXPWiXnIVrMI9vHJwS0VYf6cO7evSzj+X8wU+FyEmkh5JUSycF0jqz0jBfu4RC2DHszsX1psVjcub0O2Pm20/wyfQ/TkxYvkv/wGBamXJ5oSJzFb3zUsCZwZE/1HVcHWGTmh6Ujv6t1s8NTbiWFbh/vMnXxLMJ5jk23isnXDZ9k+88Gon+s6nogctYTp2Eqz4pkGJuRujT1zJDTlA==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(346002)(396003)(136003)(39860400002)(46966006)(36840700001)(36860700001)(83380400001)(186003)(26005)(70206006)(5660300002)(4326008)(107886003)(86362001)(47076005)(316002)(110136005)(54906003)(36906005)(34020700004)(16526019)(478600001)(82310400003)(7636003)(966005)(336012)(2616005)(70586007)(82740400003)(356005)(8936002)(36756003)(8676002)(426003)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2021 17:24:05.6754
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 37db6cb1-9a9b-48b7-a220-08d8e57ba362
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT007.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3382
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

Ido Schimmel (4):
  nexthop: Synchronize uAPI files
  nexthop: Add ability to specify group type
  nexthop: Add support for resilient nexthop groups
  nexthop: Add support for nexthop buckets

Petr Machata (2):
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
 man/man8/ip-nexthop.8          | 112 +++++++-
 10 files changed, 650 insertions(+), 17 deletions(-)

-- 
2.26.2

