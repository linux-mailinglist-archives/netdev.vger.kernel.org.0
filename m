Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0495058D83B
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 13:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242464AbiHILe2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 07:34:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242744AbiHILeM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 07:34:12 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2085.outbound.protection.outlook.com [40.107.220.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 927CC24BC6
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 04:33:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D4GbIfOJJnJxScIlsqQnobexPsgTNiGP2vQ3ZjIhfQeS+DIGoMyNihzuWd/pWLwqdeAjktH8ayT6NVv83MOYfVREbmx4F/6nE1RYpB48b++qQobFCAz13a3km7T4FG/NQqDtDhjwuaJS/T1oeTQkH0UB5bDI9iOzXKVTBoMjidIn+EQrqKOXs4RDa5/OcoC4u5X+tvHGB6R7v+ssbdYsgmvEKTwHQ9GEo2ifTIFOcY6mWutRY0Ak97tLFkAzTyyyecO7tao0QNFE+4JUFCrdR7IOin4+yYypwqgXOFfCHhBudkavh7P3f2of1M17a5iuDHF53GwOOmvuHhvrSF85Jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+zG8kvx1XVoJE+t7BUm/UyU7mW+Z+T3Mk9TjECwgWnE=;
 b=J8DYAOfNCksPJ3oINLqzAg2RZ1D/VzyX6j1bbKmKKSIIrq6KehWalnqIDgTL+Y4t0zW3jaUAay3TTtBkT2PbtAUm5CYHIOsglf+o0wHADJkNunVjxkJmjQnChNiGLBwythjgJJtHgivVvKpyH2Tts69xDzl8lbaShcTx+tR8RqpL5p59h7/Vw5555zGchA4aryA0nEj52+cxQKzWelxAlO/PWDk6B3AEdxFaIThb5w3k2wmdNcHGPNCiOIFCo3dK9ieRJ1T2f1RDOO5X07o37FH+AfQBaWf6c1b+A3hj9xCpbuo8O9VbyE1bqVUEJZbI6V+SK3/n4b9DZp0IY0ocvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+zG8kvx1XVoJE+t7BUm/UyU7mW+Z+T3Mk9TjECwgWnE=;
 b=EOtAh+6FQS8NoTHGA7p0m4TnBstLycg3S8i3vT0LJL9PKt6jGKMP8bWvl5hljW5v7TmsaBCXw1thhE4RG15AW9l8n7JJQwFdu6/OODGPeG6IaxMcBLFROtWINLHk5IagNd8IGV/MnobAk/C3phyKowJQenLOL2SQVTsMVp5WtbTsEUamyAOWgC+gFgVS9w90OAwARfBVl0u8RPqrrzo9GEGKYmLmaAi+nGZNRYXAnCxYIpWeglDwR/0J/YLbfkbta7eJegBg7gYWC/htwIH2Z5n0KSBlKlfhc+fh8fa4UMDAZmcFNxTfc9kHTk2s+z3MwgszTmal9tP9acjDfZAcJQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA1PR12MB6163.namprd12.prod.outlook.com (2603:10b6:208:3e9::22)
 by MN2PR12MB4000.namprd12.prod.outlook.com (2603:10b6:208:16b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.19; Tue, 9 Aug
 2022 11:33:45 +0000
Received: from IA1PR12MB6163.namprd12.prod.outlook.com
 ([fe80::a52c:c6f5:f9f4:59cc]) by IA1PR12MB6163.namprd12.prod.outlook.com
 ([fe80::a52c:c6f5:f9f4:59cc%5]) with mapi id 15.20.5504.014; Tue, 9 Aug 2022
 11:33:44 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, amcohen@nvidia.com, dsahern@gmail.com,
        ivecera@redhat.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net] selftests: forwarding: Fix failing tests with old libnet
Date:   Tue,  9 Aug 2022 14:33:20 +0300
Message-Id: <20220809113320.751413-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0269.eurprd07.prod.outlook.com
 (2603:10a6:803:b4::36) To IA1PR12MB6163.namprd12.prod.outlook.com
 (2603:10b6:208:3e9::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 62c1c5d6-90f1-4744-c740-08da79fb048b
X-MS-TrafficTypeDiagnostic: MN2PR12MB4000:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z4I+aaLCL2mn1eJ3PwP4Bqf/QXjLYP/08yunTgHRwuCxQrYhX7dawhIBoBcMmQsIvIkp+jJng6/DmPDHZizj02MxEzEI6eAJYAKbD7skG5xYVV9KRQx+lLXKmkC8bPCpap7Z+p+553DJPB4IbRDrbtmu1qmTnD+26ITVCEIyzKYUA0x6yUpDBA6s22URgncHc72Giig1QXTa9zZMWLHj4uLGHgtW+vKYirM2/k35lEMR6INyPzZyeHlutcIfRw5bjWxr2Bm5l718WUyKuhoM2prMlyTgjjlPC6fHmm57QIX1t8K/F5JYR3tAoDkI2ByRWzpgj0i72fXcuTeAFA3qNRpQKOZD1Pcs6BZgMvCDfm69FPU2O3E377TAgM4YmJbXBbWLxqibGO3IKQ9mLW5A+0As8qD4pF1KUgm7Sjw3yIhVvvlitFnay0mlUiZ4sED9pOKVnNhVteHuv3W0EeHQaR5LboZ7/4/ZYRbkUVnxDVMyh3tdp47EKI3Y3Ev3brUbi/EqQU0Te+bti/+6Bo4VyJ3dOJDE35tuyzqVvrODbdLQTAfT3+elpa4RndAmBw9+RKr8dTFI448m2a8RzkboM8im1idb9GVLwQKUlCuJV/wBS8u0T6GeDZbJXsJwdX1+stXSFVkZkfDM3CA8rZFOvOFcI0BfZc9YMS/fyUGlsTABfTDc8rqID+LrJLbyv+mxd7bNuIpsd1V9PFvWS+KjNeQ0j8e+Byyf2zGKF5OMiwV6JYtjIccNf75uWWQHnA6Q
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6163.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(136003)(396003)(366004)(346002)(376002)(26005)(38100700002)(6666004)(6506007)(6512007)(41300700001)(6486002)(1076003)(107886003)(83380400001)(2616005)(186003)(5660300002)(8936002)(86362001)(66946007)(66476007)(66556008)(2906002)(4326008)(8676002)(36756003)(6916009)(316002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?U16VqTZ3oq9v1hHB+S87CPPOQjFE6sfoCuFPKNSMA1axL000OjeFmvHuLBEQ?=
 =?us-ascii?Q?bq+Jz8d3/ncl2GdEc8kuYsDljqkqSSUYigJAVSBUMOJCmsdvLKGQFGR+EJoZ?=
 =?us-ascii?Q?AmOfRu9eVaBRDRrusotRQFoLqvKUiWemLB5jFAj0DcOLE6cv5sjC3o1ro5ia?=
 =?us-ascii?Q?fhcUdK0JA+2zC0JbV7PO46bbZsRUUt2qDYDuI/Fnn6y/F0tXNIchWzfrh/rd?=
 =?us-ascii?Q?3eq/nWS88v0fCllXO2qnFEIP0wrWPrwJ87Mi/zHCsJi3fnHVpM67aKl76i+w?=
 =?us-ascii?Q?h+QAAbVHHx6pTQnUVb6UYwlWJWwm8mZhLelJvko6uuOKfB5cWlruQV6y3pSM?=
 =?us-ascii?Q?a56dKAghGxV2JNzUujhXj8NJMRg9xsjH0cZOzM4Zpg9rA98gcvjMhuKfp3Iq?=
 =?us-ascii?Q?fHPDqW0y4nMDI/zfAwLSFyrP+DfrZjg3XYaGV8XRDvIp2/HOQSH/jK7btVy4?=
 =?us-ascii?Q?2zFu/oFlU94YOjqi3tw4MyvyL/S8NKRF3G5fFhOyqK854/QUSb6pz9vSChiF?=
 =?us-ascii?Q?pb7FMpm4zA51ZPzl1BC7FTLrB2M16V+AzB6ILep3D83pwyysPy7TR6UsGUlm?=
 =?us-ascii?Q?xTh31Q/kpzRjAMBThno14EDDPuuWJqHWiX3znN76iZ86rSVaz79DngHmH+KQ?=
 =?us-ascii?Q?mNnubbCYpVR8xs5enFqT/fICYT97b6rSkMF41ZuzbpniszxKtsVvRS5TAT+Q?=
 =?us-ascii?Q?PWCIYTUhr0XGYcr15CospSd6aDXpbZrDzLuxbOZauU3BUDQ980H4EQjA9gwy?=
 =?us-ascii?Q?1ScznhH5qgwMkIRDpeCUghqnOyJSv02PUzzOursKsk/NgmIGuDjwBtDBsvAi?=
 =?us-ascii?Q?WjZrcCeJDnZnxkrrKTWuJJJkuhZlDrRNJRZE+52N5mHHZiFeJdcBxDWvjIK6?=
 =?us-ascii?Q?JZAiVSNi4GbX+3PvdY+PbXCyfnO67Ax5iBa1vZwR3pawwa82CWQpWrsypyAb?=
 =?us-ascii?Q?cA433fcBWEycW5molrztYS4cuLGvVsYkskgSS5Ah9J+qHxeoPjFQvymbBLI8?=
 =?us-ascii?Q?MuNOIgGjPePiw7j69QXPw/SYFc10V4V2FAFofkEpGvrLvRBaSnfeY7Lhjjui?=
 =?us-ascii?Q?J7lGC1iPItywVXmo7qyuRNCwRyfzpRe8xoIQvgPybu33r7MWnCA7+TZvd6zT?=
 =?us-ascii?Q?3FI8t/aDj94rKCacrgZsL3MHkoYO+sQPwsE++d2RyAv9v9w4BVkd8kTQlwy9?=
 =?us-ascii?Q?jQsLorc8hlQPpqf4UBF5r5yrSCqjMGYv1KE0+TK5yCnLUrlaVw6rkRHvP2xI?=
 =?us-ascii?Q?NQH/eC++w0d++mz59O9eXoLCfrrDssByAJSlOElOYOhqZ7gleGvGbyH1RH+1?=
 =?us-ascii?Q?G4rTiqSfK5JrKRKJipoySo/qNrytbVITBVzpXpN3/hozHC5lYgnLEMrCB5Bp?=
 =?us-ascii?Q?YaOd4/Gqhx4ngTiBqFJNSaolyWVY2stcukeqmdaT0ML0aeg8NHmBOnQTPgr8?=
 =?us-ascii?Q?QKTcCxl8nEUnrDB+MmWb6WJyPouvCNjrYRd9dRmFoS9+mzFWYsJGy35FpvRY?=
 =?us-ascii?Q?J6jFxC/5u7EsuLwPPUyjaT3/boOiSVLBcEIwtdiMmA7WzQkYIf3R+lsI1GVZ?=
 =?us-ascii?Q?x1EYV+EhDSHO60+GPNdedxOOIQSnniv39n9tPrhm?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62c1c5d6-90f1-4744-c740-08da79fb048b
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6163.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2022 11:33:44.8555
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a5vshF7awDsjyGA9hslKIkI6D1ccwxJH9jVINMhYv/xGLexKAV0kHxm9NRvkVIOyIjA1mpbF9d2k/E0/segIng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4000
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The custom multipath hash tests use mausezahn in order to test how
changes in various packet fields affect the packet distribution across
the available nexthops.

The tool uses the libnet library for various low-level packet
construction and injection. The library started using the
"SO_BINDTODEVICE" socket option for IPv6 sockets in version 1.1.6 and
for IPv4 sockets in version 1.2.

When the option is not set, packets are not routed according to the
table associated with the VRF master device and tests fail.

Fix this by prefixing the command with "ip vrf exec", which will cause
the route lookup to occur in the VRF routing table. This makes the tests
pass regardless of the libnet library version.

Fixes: 511e8db54036 ("selftests: forwarding: Add test for custom multipath hash")
Fixes: 185b0c190bb6 ("selftests: forwarding: Add test for custom multipath hash with IPv4 GRE")
Fixes: b7715acba4d3 ("selftests: forwarding: Add test for custom multipath hash with IPv6 GRE")
Reported-by: Ivan Vecera <ivecera@redhat.com>
Tested-by: Ivan Vecera <ivecera@redhat.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Amit Cohen <amcohen@nvidia.com>
---
 .../net/forwarding/custom_multipath_hash.sh   | 24 ++++++++++++-------
 .../forwarding/gre_custom_multipath_hash.sh   | 24 ++++++++++++-------
 .../ip6gre_custom_multipath_hash.sh           | 24 ++++++++++++-------
 3 files changed, 48 insertions(+), 24 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/custom_multipath_hash.sh b/tools/testing/selftests/net/forwarding/custom_multipath_hash.sh
index a15d21dc035a..56eb83d1a3bd 100755
--- a/tools/testing/selftests/net/forwarding/custom_multipath_hash.sh
+++ b/tools/testing/selftests/net/forwarding/custom_multipath_hash.sh
@@ -181,37 +181,43 @@ ping_ipv6()
 
 send_src_ipv4()
 {
-	$MZ $h1 -q -p 64 -A "198.51.100.2-198.51.100.253" -B 203.0.113.2 \
+	ip vrf exec v$h1 $MZ $h1 -q -p 64 \
+		-A "198.51.100.2-198.51.100.253" -B 203.0.113.2 \
 		-d 1msec -c 50 -t udp "sp=20000,dp=30000"
 }
 
 send_dst_ipv4()
 {
-	$MZ $h1 -q -p 64 -A 198.51.100.2 -B "203.0.113.2-203.0.113.253" \
+	ip vrf exec v$h1 $MZ $h1 -q -p 64 \
+		-A 198.51.100.2 -B "203.0.113.2-203.0.113.253" \
 		-d 1msec -c 50 -t udp "sp=20000,dp=30000"
 }
 
 send_src_udp4()
 {
-	$MZ $h1 -q -p 64 -A 198.51.100.2 -B 203.0.113.2 \
+	ip vrf exec v$h1 $MZ $h1 -q -p 64 \
+		-A 198.51.100.2 -B 203.0.113.2 \
 		-d 1msec -t udp "sp=0-32768,dp=30000"
 }
 
 send_dst_udp4()
 {
-	$MZ $h1 -q -p 64 -A 198.51.100.2 -B 203.0.113.2 \
+	ip vrf exec v$h1 $MZ $h1 -q -p 64 \
+		-A 198.51.100.2 -B 203.0.113.2 \
 		-d 1msec -t udp "sp=20000,dp=0-32768"
 }
 
 send_src_ipv6()
 {
-	$MZ -6 $h1 -q -p 64 -A "2001:db8:1::2-2001:db8:1::fd" -B 2001:db8:4::2 \
+	ip vrf exec v$h1 $MZ -6 $h1 -q -p 64 \
+		-A "2001:db8:1::2-2001:db8:1::fd" -B 2001:db8:4::2 \
 		-d 1msec -c 50 -t udp "sp=20000,dp=30000"
 }
 
 send_dst_ipv6()
 {
-	$MZ -6 $h1 -q -p 64 -A 2001:db8:1::2 -B "2001:db8:4::2-2001:db8:4::fd" \
+	ip vrf exec v$h1 $MZ -6 $h1 -q -p 64 \
+		-A 2001:db8:1::2 -B "2001:db8:4::2-2001:db8:4::fd" \
 		-d 1msec -c 50 -t udp "sp=20000,dp=30000"
 }
 
@@ -226,13 +232,15 @@ send_flowlabel()
 
 send_src_udp6()
 {
-	$MZ -6 $h1 -q -p 64 -A 2001:db8:1::2 -B 2001:db8:4::2 \
+	ip vrf exec v$h1 $MZ -6 $h1 -q -p 64 \
+		-A 2001:db8:1::2 -B 2001:db8:4::2 \
 		-d 1msec -t udp "sp=0-32768,dp=30000"
 }
 
 send_dst_udp6()
 {
-	$MZ -6 $h1 -q -p 64 -A 2001:db8:1::2 -B 2001:db8:4::2 \
+	ip vrf exec v$h1 $MZ -6 $h1 -q -p 64 \
+		-A 2001:db8:1::2 -B 2001:db8:4::2 \
 		-d 1msec -t udp "sp=20000,dp=0-32768"
 }
 
diff --git a/tools/testing/selftests/net/forwarding/gre_custom_multipath_hash.sh b/tools/testing/selftests/net/forwarding/gre_custom_multipath_hash.sh
index a73f52efcb6c..0446db9c6f74 100755
--- a/tools/testing/selftests/net/forwarding/gre_custom_multipath_hash.sh
+++ b/tools/testing/selftests/net/forwarding/gre_custom_multipath_hash.sh
@@ -276,37 +276,43 @@ ping_ipv6()
 
 send_src_ipv4()
 {
-	$MZ $h1 -q -p 64 -A "198.51.100.2-198.51.100.253" -B 203.0.113.2 \
+	ip vrf exec v$h1 $MZ $h1 -q -p 64 \
+		-A "198.51.100.2-198.51.100.253" -B 203.0.113.2 \
 		-d 1msec -c 50 -t udp "sp=20000,dp=30000"
 }
 
 send_dst_ipv4()
 {
-	$MZ $h1 -q -p 64 -A 198.51.100.2 -B "203.0.113.2-203.0.113.253" \
+	ip vrf exec v$h1 $MZ $h1 -q -p 64 \
+		-A 198.51.100.2 -B "203.0.113.2-203.0.113.253" \
 		-d 1msec -c 50 -t udp "sp=20000,dp=30000"
 }
 
 send_src_udp4()
 {
-	$MZ $h1 -q -p 64 -A 198.51.100.2 -B 203.0.113.2 \
+	ip vrf exec v$h1 $MZ $h1 -q -p 64 \
+		-A 198.51.100.2 -B 203.0.113.2 \
 		-d 1msec -t udp "sp=0-32768,dp=30000"
 }
 
 send_dst_udp4()
 {
-	$MZ $h1 -q -p 64 -A 198.51.100.2 -B 203.0.113.2 \
+	ip vrf exec v$h1 $MZ $h1 -q -p 64 \
+		-A 198.51.100.2 -B 203.0.113.2 \
 		-d 1msec -t udp "sp=20000,dp=0-32768"
 }
 
 send_src_ipv6()
 {
-	$MZ -6 $h1 -q -p 64 -A "2001:db8:1::2-2001:db8:1::fd" -B 2001:db8:2::2 \
+	ip vrf exec v$h1 $MZ -6 $h1 -q -p 64 \
+		-A "2001:db8:1::2-2001:db8:1::fd" -B 2001:db8:2::2 \
 		-d 1msec -c 50 -t udp "sp=20000,dp=30000"
 }
 
 send_dst_ipv6()
 {
-	$MZ -6 $h1 -q -p 64 -A 2001:db8:1::2 -B "2001:db8:2::2-2001:db8:2::fd" \
+	ip vrf exec v$h1 $MZ -6 $h1 -q -p 64 \
+		-A 2001:db8:1::2 -B "2001:db8:2::2-2001:db8:2::fd" \
 		-d 1msec -c 50 -t udp "sp=20000,dp=30000"
 }
 
@@ -321,13 +327,15 @@ send_flowlabel()
 
 send_src_udp6()
 {
-	$MZ -6 $h1 -q -p 64 -A 2001:db8:1::2 -B 2001:db8:2::2 \
+	ip vrf exec v$h1 $MZ -6 $h1 -q -p 64 \
+		-A 2001:db8:1::2 -B 2001:db8:2::2 \
 		-d 1msec -t udp "sp=0-32768,dp=30000"
 }
 
 send_dst_udp6()
 {
-	$MZ -6 $h1 -q -p 64 -A 2001:db8:1::2 -B 2001:db8:2::2 \
+	ip vrf exec v$h1 $MZ -6 $h1 -q -p 64 \
+		-A 2001:db8:1::2 -B 2001:db8:2::2 \
 		-d 1msec -t udp "sp=20000,dp=0-32768"
 }
 
diff --git a/tools/testing/selftests/net/forwarding/ip6gre_custom_multipath_hash.sh b/tools/testing/selftests/net/forwarding/ip6gre_custom_multipath_hash.sh
index 8fea2c2e0b25..d40183b4eccc 100755
--- a/tools/testing/selftests/net/forwarding/ip6gre_custom_multipath_hash.sh
+++ b/tools/testing/selftests/net/forwarding/ip6gre_custom_multipath_hash.sh
@@ -278,37 +278,43 @@ ping_ipv6()
 
 send_src_ipv4()
 {
-	$MZ $h1 -q -p 64 -A "198.51.100.2-198.51.100.253" -B 203.0.113.2 \
+	ip vrf exec v$h1 $MZ $h1 -q -p 64 \
+		-A "198.51.100.2-198.51.100.253" -B 203.0.113.2 \
 		-d 1msec -c 50 -t udp "sp=20000,dp=30000"
 }
 
 send_dst_ipv4()
 {
-	$MZ $h1 -q -p 64 -A 198.51.100.2 -B "203.0.113.2-203.0.113.253" \
+	ip vrf exec v$h1 $MZ $h1 -q -p 64 \
+		-A 198.51.100.2 -B "203.0.113.2-203.0.113.253" \
 		-d 1msec -c 50 -t udp "sp=20000,dp=30000"
 }
 
 send_src_udp4()
 {
-	$MZ $h1 -q -p 64 -A 198.51.100.2 -B 203.0.113.2 \
+	ip vrf exec v$h1 $MZ $h1 -q -p 64 \
+		-A 198.51.100.2 -B 203.0.113.2 \
 		-d 1msec -t udp "sp=0-32768,dp=30000"
 }
 
 send_dst_udp4()
 {
-	$MZ $h1 -q -p 64 -A 198.51.100.2 -B 203.0.113.2 \
+	ip vrf exec v$h1 $MZ $h1 -q -p 64 \
+		-A 198.51.100.2 -B 203.0.113.2 \
 		-d 1msec -t udp "sp=20000,dp=0-32768"
 }
 
 send_src_ipv6()
 {
-	$MZ -6 $h1 -q -p 64 -A "2001:db8:1::2-2001:db8:1::fd" -B 2001:db8:2::2 \
+	ip vrf exec v$h1 $MZ -6 $h1 -q -p 64 \
+		-A "2001:db8:1::2-2001:db8:1::fd" -B 2001:db8:2::2 \
 		-d 1msec -c 50 -t udp "sp=20000,dp=30000"
 }
 
 send_dst_ipv6()
 {
-	$MZ -6 $h1 -q -p 64 -A 2001:db8:1::2 -B "2001:db8:2::2-2001:db8:2::fd" \
+	ip vrf exec v$h1 $MZ -6 $h1 -q -p 64 \
+		-A 2001:db8:1::2 -B "2001:db8:2::2-2001:db8:2::fd" \
 		-d 1msec -c 50 -t udp "sp=20000,dp=30000"
 }
 
@@ -323,13 +329,15 @@ send_flowlabel()
 
 send_src_udp6()
 {
-	$MZ -6 $h1 -q -p 64 -A 2001:db8:1::2 -B 2001:db8:2::2 \
+	ip vrf exec v$h1 $MZ -6 $h1 -q -p 64 \
+		-A 2001:db8:1::2 -B 2001:db8:2::2 \
 		-d 1msec -t udp "sp=0-32768,dp=30000"
 }
 
 send_dst_udp6()
 {
-	$MZ -6 $h1 -q -p 64 -A 2001:db8:1::2 -B 2001:db8:2::2 \
+	ip vrf exec v$h1 $MZ -6 $h1 -q -p 64 \
+		-A 2001:db8:1::2 -B 2001:db8:2::2 \
 		-d 1msec -t udp "sp=20000,dp=0-32768"
 }
 
-- 
2.37.1

