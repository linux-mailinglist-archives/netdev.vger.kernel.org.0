Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E77D3383C07
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 20:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238890AbhEQSR1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 14:17:27 -0400
Received: from azhdrrw-ex02.nvidia.com ([20.64.145.131]:53248 "EHLO
        AZHDRRW-EX02.NVIDIA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234544AbhEQSR0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 14:17:26 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by mxs.oss.nvidia.com (10.13.234.37) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.858.12; Mon, 17 May 2021 11:16:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G2tF9FkRuag5joCY9R0kZBp6FcbBdfOrN9Kgb4BE1diObmb0g4mHilrNmhXaIngNa59vexTUHFZY5b31BLPzxV1MFQGTSYMPIZDy+Q9nCu2sl8F3+PRvMqnwXYr1SnOseKqUjo44a9kCQiWo1PrzYEQjr6mPMaUqf4BiNG/PBAOLJOyrlzOQ8S9fGRQCo2oCfaQhtN6IdKP3005jI7DiF9iSBxz0xRqxS2mce43TgoVhfgti0lJb6l5MmV9fxd0DsEzJnyfLWhWx5pol7o/vvihcRYdXmdbkk9t0OPJbFey063b1bmfdHs8QMEHP0xC14//NOIPOeSEB5cfhBJ5oSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SeNH7NW0MY2xUlHoA5jHM5NY78TWWDb62MndYcAImU0=;
 b=oMXeShyrhl1vvv2xD2i6GJe08DIhirXIU33KfhW9M0BxeqriXr4FLnjJR8JFOiRrIbcyS3mxKDeff8xRhizBhepreGVsk7EPU7CDiEGy8IJ2HX8liTStWTCgeq34BE7OpMXyFgrPYerztYTfnkRfdLQ1D9mhvB2rVO2xfRjopqW1/UxIkz4+dk7SOOc9lXdhLOpUVxpOKGEs4Xic7IMw5Cyu4+NKvkzUwUuBJnoL+DGiWmGCLgerZC1yxme0zfpSSD/oUn5nP1Z67ptA84DZSfMpQwfiTUo63qYHTmkkwh2s8fjAlblG6pGG1RrerbsMtdpYwBAMNEyGoYMFLLtk3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SeNH7NW0MY2xUlHoA5jHM5NY78TWWDb62MndYcAImU0=;
 b=YMDthZisluSAlE/tqDg6s/EVZNdAAsN8Fg9mXiAL7+kMcabMK/J7jlhJN6gS7QhuSeLluXxW5odEXuBsSfl0365RHgf1xY0Z37+SW4GfOCCSY8gho1sl9e5Drx+w/uCSAwHSR14dw3wbCk3oZawFzU0gFPQo458AfdGEFuD1bKX0KO6/W2ZTXa/hQ/fSHzFl5s2CG5klE+aUieNG047LrYEGK7l4WJONelV60sczfRDsyzi/BZpgk7bKBKR4j9CbzXDcrwjoSZDhoj2YSohEQznZ3Cco0KUPLCsd6heKnb59OkDRogS0UZ2FV5fPWA9ogtwhogEiKfqHU8eO1SsKAw==
Received: from BN7PR02CA0005.namprd02.prod.outlook.com (2603:10b6:408:20::18)
 by DM5PR1201MB2553.namprd12.prod.outlook.com (2603:10b6:3:eb::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Mon, 17 May
 2021 18:16:07 +0000
Received: from BN8NAM11FT058.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:20:cafe::89) by BN7PR02CA0005.outlook.office365.com
 (2603:10b6:408:20::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.24 via Frontend
 Transport; Mon, 17 May 2021 18:16:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT058.mail.protection.outlook.com (10.13.177.58) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Mon, 17 May 2021 18:16:07 +0000
Received: from shredder.mellanox.com (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 17 May
 2021 18:16:03 +0000
From:   Ido Schimmel <idosch@OSS.NVIDIA.COM>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <dsahern@gmail.com>,
        <petrm@OSS.NVIDIA.COM>, <roopa@OSS.NVIDIA.COM>,
        <nikolay@OSS.NVIDIA.COM>, <ssuryaextr@gmail.com>,
        <mlxsw@OSS.NVIDIA.COM>, Ido Schimmel <idosch@OSS.NVIDIA.COM>
Subject: [PATCH net-next 00/10] Add support for custom multipath hash
Date:   Mon, 17 May 2021 21:15:16 +0300
Message-ID: <20210517181526.193786-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fae11aef-d49b-412b-a8bc-08d9195fd764
X-MS-TrafficTypeDiagnostic: DM5PR1201MB2553:
X-Microsoft-Antispam-PRVS: <DM5PR1201MB25539DA6BD9B9C1898E5E5F0B22D9@DM5PR1201MB2553.namprd12.prod.outlook.com>
X-MS-Exchange-Transport-Forked: True
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Gu4UgYXGqgSKihj1OCa3ORRbxXFS6TgFVZtXRLiOIKUDtPugObXUe6Gg6xuFJqGQJ6A+Dwh5lJzyUWWCED+o84NF07nymGNipuTZIBXgQRTTBzyrLjOkuIOBeaiNTxknJIKCJ+T+qOtWZKthX8wUWNVcd3ZZhzu5F3Li8uHmrh+IiqhbqMu2Br6WNuJj89BrEbTrZPRPecJFwMimIhD+EW55ICQsrR6vtWOik+YYFzDHTuIFYV56yid7yh2EDeEfuWF50ihIcScvtVhDEXeXKjkEXGbekmwUYDJFHmEzoDiabuwe5w5NdH3nW94QxX+bAIooeeaejn+XREIdD5eBuTT1rXAOOV8D1DvyUgEfPKBU0vqpLdZfMFIwVrVIcxYEeJ1UQuHqaN+l/204OPH5sgr9oE9W31c34s8mCY7PP+4+PiPzGvsvr2bvGlO7rq9cTH2zw9mI06/wUhbljY7sPMhdIta9R1vmGrGKfmbHv+Q2GKVk8pTNTeEAXUH9wFLLYxijRIjJkApR1oGgoNzWFhFKRENcS7bfhztjb57UPHjPLj7YbFrI3cM0bO3LUfvY1opRudo3DF1LXCG+Ug0AxDjZn6XjV2devSL89j41BDWaqtzIFVITIfmZyZkynGBwmmnzOXl8jycQ1qmQ0S0WPG1OOTK/cMcn4+5IutbdIOmMtX/c0+/be4bBgSfyHZagLjmdmmicANePAuPU8tc+8tC5RI6+k/i9T9z+ZmpB9lM9PqJSy2l/tQCHNzKuiNFPCW1fffwMjDUd1yPjE4I58Q==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(396003)(346002)(376002)(136003)(46966006)(36840700001)(966005)(316002)(36906005)(5660300002)(107886003)(4326008)(1076003)(54906003)(26005)(6666004)(70206006)(478600001)(8676002)(336012)(2616005)(426003)(8936002)(6916009)(186003)(36756003)(82740400003)(7636003)(47076005)(36860700001)(82310400003)(83380400001)(86362001)(356005)(2906002)(16526019)(70586007);DIR:OUT;SFP:1101;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2021 18:16:07.3932
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fae11aef-d49b-412b-a8bc-08d9195fd764
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT058.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB2553
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset adds support for custom multipath hash policy for both
IPv4 and IPv6 traffic. The new policy allows user space to control the
outer and inner packet fields used for the hash computation.

Motivation
==========

Linux currently supports different multipath hash policies for IPv4 and
IPv6 traffic:

* Layer 3
* Layer 4
* Layer 3 or inner layer 3, if present

These policies hash on a fixed set of fields, which is inflexible and
against operators' requirements to control the hash input: "The ability
to control the inputs to the hash function should be a consideration in
any load-balancing RFP" [1].

An example of this inflexibility can be seen by the fact that none of
the current policies allows operators to use the standard 5-tuple and
the flow label for multipath hash computation. Such a policy is useful
in the following real-world example of a data center with the following
types of traffic:

* Anycast IPv6 TCP traffic towards layer 4 load balancers. Flow label is
constant (zero) to avoid breaking established connections

* Non-encapsulated IPv6 traffic. Flow label is used to re-route flows
around problematic (congested / failed) paths [2]

* IPv6 encapsulated traffic (IPv4-in-IPv6 or IPv6-in-IPv6). Outer flow
label is generated from encapsulated packet

* UDP encapsulated traffic. Outer source port is generated from
encapsulated packet

In the above example, using the inner flow information for hash
computation in addition to the outer flow information is useful during
failures of the BPF agent that selectively generates the flow label
based on the traffic type. In such cases, the self-healing properties of
the flow label are lost, but encapsulated flows are still load balanced.

Control over the inner fields is even more critical when encapsulation
is performed by hardware routers. For example, the Spectrum ASIC can
only encode 8 bits of entropy in the outer flow label / outer UDP source
port when performing IP / UDP encapsulation. In the case of IPv4 GRE
encapsulation there is no outer field to encode the inner hash in.

User interface
==============

In accordance with existing multipath hash configuration, the new custom
policy is added as a new option (3) to the
net.ipv{4,6}.fib_multipath_hash_policy sysctls. When the new policy is
used, the packet fields used for hash computation are determined by the
net.ipv{4,6}.fib_multipath_hash_fields sysctls. These sysctls accept a
bitmask according to the following table (from ip-sysctl.rst):

	====== ============================
	0x0001 Source IP address
	0x0002 Destination IP address
	0x0004 IP protocol
	0x0008 Flow Label
	0x0010 Source port
	0x0020 Destination port
	0x0040 Inner source IP address
	0x0080 Inner destination IP address
	0x0100 Inner IP protocol
	0x0200 Inner Flow Label
	0x0400 Inner source port
	0x0800 Inner destination port
	====== ============================

For example, to allow IPv6 traffic to be hashed based on standard
5-tuple and flow label:

 # sysctl -wq net.ipv6.fib_multipath_hash_fields=0x0037
 # sysctl -wq net.ipv6.fib_multipath_hash_policy=3

Implementation
==============

As with existing policies, the new policy relies on the flow dissector
to extract the packet fields for the hash computation. However, unlike
existing policies that either use the outer or inner flow, the new
policy might require both flows to be dissected.

To avoid unnecessary invocations of the flow dissector, the data path
skips dissection of the outer or inner flows if none of the outer or
inner fields are required.

In addition, inner flow dissection is not performed when no
encapsulation was encountered (i.e., 'FLOW_DIS_ENCAPSULATION' not set by
flow dissector) during dissection of the outer flow.

Testing
=======

Three new selftests are added with three different topologies that allow
testing of following traffic combinations:

* Non-encapsulated IPv4 / IPv6 traffic
* IPv4 / IPv6 overlay over IPv4 underlay
* IPv4 / IPv6 overlay over IPv6 underlay

All three tests follow the same pattern. Each time a different packet
field is used for hash computation. When the field changes in the packet
stream, traffic is expected to be balanced across the two paths. When
the field does not change, traffic is expected to be unbalanced across
the two paths.

Patchset overview
=================

Patches #1-#3 add custom multipath hash support for IPv4 traffic
Patches #4-#7 do the same for IPv6
Patches #8-#10 add selftests

Future work
===========

mlxsw support can be found here [3].

Changes since RFC v2 [4]:

* Patch #2: Document that 0x0008 is used for Flow Label
* Patch #2: Do not allow the bitmask to be zero
* Patch #6: Do not allow the bitmask to be zero

Changes since RFC v1 [5]:

* Use a bitmask instead of a bitmap

[1] https://blog.apnic.net/2018/01/11/ipv6-flow-label-misuse-hashing/
[2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=3acf3ec3f4b0fd4263989f2e4227bbd1c42b5fe1
[3] https://github.com/idosch/linux/tree/submit/custom_hash_mlxsw_v2
[4] https://lore.kernel.org/netdev/20210509151615.200608-1-idosch@idosch.org/
[5] https://lore.kernel.org/netdev/20210502162257.3472453-1-idosch@idosch.org/

Ido Schimmel (10):
  ipv4: Calculate multipath hash inside switch statement
  ipv4: Add a sysctl to control multipath hash fields
  ipv4: Add custom multipath hash policy
  ipv6: Use a more suitable label name
  ipv6: Calculate multipath hash inside switch statement
  ipv6: Add a sysctl to control multipath hash fields
  ipv6: Add custom multipath hash policy
  selftests: forwarding: Add test for custom multipath hash
  selftests: forwarding: Add test for custom multipath hash with IPv4
    GRE
  selftests: forwarding: Add test for custom multipath hash with IPv6
    GRE

 Documentation/networking/ip-sysctl.rst        |  58 +++
 include/net/ip_fib.h                          |  43 ++
 include/net/ipv6.h                            |   8 +
 include/net/netns/ipv4.h                      |   1 +
 include/net/netns/ipv6.h                      |   3 +-
 net/ipv4/fib_frontend.c                       |   6 +
 net/ipv4/route.c                              | 127 ++++-
 net/ipv4/sysctl_net_ipv4.c                    |  15 +-
 net/ipv6/ip6_fib.c                            |   9 +-
 net/ipv6/route.c                              | 131 ++++-
 net/ipv6/sysctl_net_ipv6.c                    |  15 +-
 .../net/forwarding/custom_multipath_hash.sh   | 364 ++++++++++++++
 .../forwarding/gre_custom_multipath_hash.sh   | 456 +++++++++++++++++
 .../ip6gre_custom_multipath_hash.sh           | 458 ++++++++++++++++++
 14 files changed, 1685 insertions(+), 9 deletions(-)
 create mode 100755 tools/testing/selftests/net/forwarding/custom_multipath_hash.sh
 create mode 100755 tools/testing/selftests/net/forwarding/gre_custom_multipath_hash.sh
 create mode 100755 tools/testing/selftests/net/forwarding/ip6gre_custom_multipath_hash.sh

-- 
2.31.1

