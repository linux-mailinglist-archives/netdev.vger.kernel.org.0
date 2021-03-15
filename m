Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EEFC33BD86
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 15:38:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237291AbhCOOg4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 10:36:56 -0400
Received: from mail-dm6nam10on2049.outbound.protection.outlook.com ([40.107.93.49]:32896
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236210AbhCOOfy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 10:35:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YZanrQHTYPZ6gtAMNpjQTgRU/2FASmRqy7pGNEHfACDUQBXyKerKABQvmxutEylBLXbK7WW8laQqj9vmidhpS4dTyez+UEehg9oZ1gHfNN6HMTn3fg6tbHE16S1xX+XIq5ycye/p5IzLfG2Zot+1fnGkuhSa2N0YjCRzzVFvUxuecs2Srl6yqDMk+qj4cM4mAkd2rBjMci4w6fi1VBffF+btE5TZT8D9V1xK3C1ksUbiIqa0R/KmWr1jt9ufUD4CojOkctDg3DYLh7OTFx5uJuf4Z9WP9ZEF7CMv5S7HjWu5krIcfyvb74WYudEeYPCTt0pd40VXbP+dvzFM71w0mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+b1Rmpp4nMFzV6hOr1K5NGgCjk5Ky/dk6grnHlQ0Eq0=;
 b=B79j+v0vURHQERA8puK8gFa3ckz6XvvxtzokOkuLuBbWjfzbjQ1daUUaEI7s21nUevtQWOtmqhswCcQjpZVeC4f1NNUjx3CsroodQ6+x2sV++G7UcS2ZxAWm3dIXGsHpCCtYMbmaSrFZMSeFKrifIQ2TkpgXAiTxdmfkKYHGou2Cbkc34YIdU6XvUUON1NHLc4ktXBvlRTwM3cC90WrHDygFcIWRPQocQLClqi8SHlfPhlw+Lky24/NbqhrsenYXveJWvmeZ6437ew3uvB8ClKtHcQk0J5cnotmL+e9REufRPciZERSGJ5lwLKMxqS1NJKi3cqYtws76jrI9wxiShw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+b1Rmpp4nMFzV6hOr1K5NGgCjk5Ky/dk6grnHlQ0Eq0=;
 b=bq1yYg4qJDtnEjSa61mMIEnq6Hd027ilTWQ7n0aJ7Ic8yQ5qX9p4VCx2bFcY6jPxlBGr9vjVaH2kancyqpz+xSgn8UrSigcQJmlFt+UtmTJNqdz7UUIaQIiQj04aYNf8RT0xcVHH0RoZ603Xb8chAWhmfuab77DUrJSEBnT03MytLwyWqC9cd/qBibOFREFrrePedDeVYZHb7MLiSV1/kEhXGcsIZKFlUUuqVGbgAYTWi0B+SzfxQ9VLssyrNTUpotO4rQjyTpjHt1TYB1Pcik/jpWP6JVZIVUVqbZX/5VcIZmJvXp64xnPOeGLpcgqaw/FOxNo/6Qy5WmCGUWLayw==
Received: from DM5PR18CA0073.namprd18.prod.outlook.com (2603:10b6:3:3::11) by
 BN8PR12MB3091.namprd12.prod.outlook.com (2603:10b6:408:44::29) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3933.32; Mon, 15 Mar 2021 14:35:50 +0000
Received: from DM6NAM11FT042.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:3:cafe::eb) by DM5PR18CA0073.outlook.office365.com
 (2603:10b6:3:3::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32 via Frontend
 Transport; Mon, 15 Mar 2021 14:35:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT042.mail.protection.outlook.com (10.13.173.165) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Mon, 15 Mar 2021 14:35:50 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 15 Mar
 2021 14:35:47 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>, <dsahern@gmail.com>,
        <stephen@networkplumber.org>
CC:     Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>
Subject: [PATCH iproute2-next v2 0/6] ip: nexthop: Support resilient groups
Date:   Mon, 15 Mar 2021 15:34:29 +0100
Message-ID: <cover.1615818031.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a2421784-83b9-4f20-1006-08d8e7bfa146
X-MS-TrafficTypeDiagnostic: BN8PR12MB3091:
X-Microsoft-Antispam-PRVS: <BN8PR12MB3091DE55CD2F45FF896AABC2D66C9@BN8PR12MB3091.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3+wavY13sRt6q3+eD6RpbcRpeURghK/1h16cSLMMo2ylt79ne1wPQCkAteWCANHm1BCBFKyLVka2864Zpdcif8PYYjve1r4ZPXvIn4Kmf0vF/V1uW+iIakd40MzablA8INLmZsvhdUwOCnk+LnbtZb/VBosgL4grydTZAAc5AoZi/+WzmpKIY+ZKHj7JZI2QaRiTkzfLugKxfRLeMQ/OkJMXbvxNd0WnyrYwYyj67j0WbWyJK0FTIxfZTbWAZ0eW/coa08MIAHKwEG2HpqGmaPRGSNTXzJfxdCD6byZdW+j8C+eDiIXlMRHRtt+h1JsCkjHKNsc+C0eP1m0qyCpr0VTdimteezgGvca4bFGC15Qz4qzvS/ZYWEPOYX7xjn3umNVH/teeU0PIdWuh7AIAN3NrVnt3FtnfmRgIxAzVymuG/iWDKHZ0ez5dFnCyX52Am4vuFBWgN4h6z188wRIMwLY7RdahBUFXnCf6PxLnWH+vRg/5U++RNC7Y3+zPolP7909VFrDnCbzkWJe4a/o/Uy1APm0ah3JjR/wvNPKIAEQsBPo53Zq+vjmyHu0N/wh5abbJH/8FLZbfBqmBtXIxzUWNccKSBLprT7GPx2+LWn/urlId5Oq4EvqS3ftGzwhoBCxG0/xFtdR8XWzwjiru3eqzpaJ8758WMrcXzjhnxROHmuDP17ixznfKRQ2jMc8swsuY6Y0VoTUlnRLjyhxZg38maEqnbWpoUiQbzBCC2YT6HCEm7rxbmfmTQ8D16XV8+uX1K2MfdSYU51dep68Zqw==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(396003)(136003)(376002)(346002)(46966006)(36840700001)(426003)(7636003)(82740400003)(70206006)(8936002)(2616005)(36756003)(4326008)(186003)(107886003)(316002)(336012)(16526019)(70586007)(82310400003)(8676002)(2906002)(26005)(36906005)(34020700004)(54906003)(110136005)(83380400001)(86362001)(47076005)(356005)(966005)(36860700001)(478600001)(6666004)(5660300002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2021 14:35:50.2408
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a2421784-83b9-4f20-1006-08d8e7bfa146
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT042.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3091
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

