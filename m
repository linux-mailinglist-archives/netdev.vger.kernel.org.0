Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2D2F33F0BB
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 13:56:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230228AbhCQMza (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 08:55:30 -0400
Received: from mail-dm6nam11on2067.outbound.protection.outlook.com ([40.107.223.67]:3264
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230006AbhCQMzH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Mar 2021 08:55:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NKxbxicwvLlEbGPI6Xh9WVrCve8fiA01Qg/lgTfC7q0v7MuaYU9nDUhcquaWotFV8GKAjQKfIM//snP3XJ/Blp+la3YDf6YwwcUSIHv51SHVI87BB9Jbph58hANGYcGrv1S2K9DImqXP/klrF3/iJaFrBmGSVNLmsQNt72vCjQO5nxppeqLcSzhyDXWWIMkc4PJhoVXrPYjK8Ik80b7wX8DSu7O6x3N7REEPijrsQfqoDmeWph/0o3Vm76ANdeabI5fV1SmgFESU5M8NGZ8jQULgDf/YJM5UCfUipatPlWsaBEh1udpQ1xWC5dR5QbI2iNJB6gRS/8cjF6ZX8nqItQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h0iexg9szKs7KkY6W8y3ZjySuGoA+C60G590wWKm3jM=;
 b=AwC4aNZyc99iWdp3QYqB9eB4JXLSqamyp0otbe7TjItbafrLw8znecrbfV6sVpbkY6Mxe1MCJEomDwKjqXsOTwvrANpHyFUHjSGTouJ7QWeqiLq6ncH8UVp7CzvLVAoyWSiTiDoDOSshSx+pKYwukFvKJV8dHh/7pcRmoCet0RaU3e89yjwq0x3szDc7UKLYag3HkOf73wFZ1IdwpAWfgwB3OQ+KJ6WP/MfXHxrlGEvdXUA1Mx2NVORd8cwYnFoYPKzbq2yZSd4zDGPHKbD8qC4AbEc8q79xkNnz2LoibPifJMA7RG5xZq4Pd0urhkgG6JlsTzVLQV3siay/Pdqdww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h0iexg9szKs7KkY6W8y3ZjySuGoA+C60G590wWKm3jM=;
 b=hMsL4U1F3n0o9fIciI6vysfft5c4bQRQKfl0xBbCSjUthU4YAldNx+3M0gV/k8M8WMABKpDX8GVWB0IOWu2lDKfwCnrT3wO9uFH21cy739AN3DqfBo6osrBec9nTamtsP1iJwMuKcd8uM4qtwCR0SD3nc1Gm6tg8aatZlSz5cKaAn1W0fjuQvhuWIJOFb5isPfO7ekiuNwq/63GF7TcSRIE92eqW7agN7X2mQSroCzdazrrHf+JPP3xMRQvgIDZeQwne9RRDoW6pim2FXBhMu8DZmGe3qnh2BmY7yTu7QRNX/ve/EhdTCeM+aeSRmusbHkOgNbRiwq1/8IysRE5D8w==
Received: from DM5PR16CA0041.namprd16.prod.outlook.com (2603:10b6:4:15::27) by
 DM6PR12MB2827.namprd12.prod.outlook.com (2603:10b6:5:7f::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3955.18; Wed, 17 Mar 2021 12:55:03 +0000
Received: from DM6NAM11FT050.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:15:cafe::9b) by DM5PR16CA0041.outlook.office365.com
 (2603:10b6:4:15::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend
 Transport; Wed, 17 Mar 2021 12:55:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT050.mail.protection.outlook.com (10.13.173.111) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3955.18 via Frontend Transport; Wed, 17 Mar 2021 12:55:02 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 17 Mar
 2021 12:55:00 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>, <dsahern@gmail.com>,
        <stephen@networkplumber.org>
CC:     Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>
Subject: [PATCH iproute2-next v4 0/6] ip: nexthop: Support resilient groups
Date:   Wed, 17 Mar 2021 13:54:29 +0100
Message-ID: <cover.1615985531.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a884bb73-ef9f-424d-248e-08d8e943e19c
X-MS-TrafficTypeDiagnostic: DM6PR12MB2827:
X-Microsoft-Antispam-PRVS: <DM6PR12MB28276BA082C4EF2B30D0A203D66A9@DM6PR12MB2827.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s6lQl3E0XZ0bzWXAvzoL0s8prBYDIHrh6gSqi6jRgBPDgsOPsI6o2ojdKFPAwuW6kDYXgzYF2ireu7GdPnhzKsDAvdYqG2Q4dPGYs/m3S+EqwEXiYA7QFlKZaJsPHuhA8gvvqySwgJv4OA8uz4SHa9SM0YdUnCSZu6XnuZd1gdZbNhb3J8ZoM+Le23r3GcBcH5p9FPcoVVHe1CQQRVvBTv0n9JuvjmhWRh2tyF62GiIT+J0sft1BaiRImbrY+9crCtS2AKB5sIxIVVl16UybaQNGL+RZ5KE3nQMaMhFmMyPd55wslJ/1YUUBr4h/XamU9LNlxjV7wHWNj84r7Y4Kv4+zUiuoCVpiEeILgfdI+8hPm1RNY5Cgvg5VoK+d8iZiL6rZdoEKq18f/SalcoWfIUR4WSkOS5hdibKehAB8W0iw8x7BhkoUlWT/FYb+OSCUfQzic6x+uveVWXP4z6lPd1CuY6nAAo56EK5sT/gK9C5fmZOadr2FinmG02hLtfhX5nI+BYWMQRsE/efpss7LQtpWRnbSryrXN+q9B/C99rpwFDH9mxVe3VqtsO7DQ1wlFUVzoKIY59q5gbh13xb7zT3nB9ZZXcA8BuxgK16yyzVq3Wqy7uwhLatAhTXwy4Nqo5sAJOP1TcEPPcEDs06GdEl8fDcloeWYaCuC2LtGSafa3K3q2gqEC4vKd22n9f5mcmJDntVaUfFhLOuXdfowQ6lDDRlAakZMe9YRED4tcc12xIXj9lzUfIUMT2mVrkAnJAB5AK2m0GUnadPv0Onywg==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(396003)(136003)(46966006)(36840700001)(8676002)(316002)(36860700001)(54906003)(356005)(2906002)(5660300002)(186003)(7636003)(36756003)(8936002)(16526019)(70586007)(36906005)(83380400001)(4326008)(82740400003)(107886003)(2616005)(110136005)(6666004)(336012)(86362001)(478600001)(34020700004)(966005)(82310400003)(70206006)(26005)(426003)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2021 12:55:02.9152
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a884bb73-ef9f-424d-248e-08d8e943e19c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT050.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2827
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

v4:
- Patch #2:
    - Make print_tv() take a const*.

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

