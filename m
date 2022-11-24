Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD9F63806E
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 22:11:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbiKXVL3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 16:11:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiKXVL2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 16:11:28 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2057.outbound.protection.outlook.com [40.107.243.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C00B91C29;
        Thu, 24 Nov 2022 13:11:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MKTtsvJEUkokMGckhHNU1TxE5Eq3qTP1hNotC9PaWOzzo5rU2es8DBDT9HMQCH3/jpnIpCSXSddRX2MDnJJ9sG1KjegLI+1xGHscLHY9EiVNWEXiFJxKlH2flsk6p8r+YX/fnDztj9/5DOIqpAl1X1JVMTMeo/HtGylnhaL0O+8x3v3FaEhLP7bVeG+OciVfBM+h8NxIVJ2vYLuhFvNRmXBylZJeOS2Vz2nZj/2A1OmsFTdIY/VRDSdRm9IA0Clkw1WQyC/7P+R7jOf+alikaS2nnfEhwjcSXwwGEYwK3QqQ68yFEiMNgW19zp6Ms3RcFBf14g6Gjdllw4oHkHLjrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+aCzTWjQhxHwR4p7tK015qbleJmDi8IV7K3rsB4GshM=;
 b=Ln3sScIuLmym3y0inup6m317zXVc8xUdwt3Tyhp38yg98X7hKwjmizfxSlcrKwGeok+TyhnvBey7S1dg888f/FayM+Rycs7Il1hJr2R8ocC7XVWiWNgQ0FONslPL+deQYDjIApPloF5W3WB4G+wRcxG2h3pn8it7YdFAEcGrm1e1yPPSV+qet3aNS78aON3ezFqEtBwObn5LRe/dK10hxrNOXYdRiewu5yaVFUQk7+2MhuoJfLHvEqiuF44U0Zg39H24ZO2AEhUujrQ8/OzLWQ2StcjcEDEx1+i1teID80ajaqwFvSQxdKIsnEzcnkHMuiCa1TzqG/WK8oj8lX8B6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+aCzTWjQhxHwR4p7tK015qbleJmDi8IV7K3rsB4GshM=;
 b=cEX24K3yrWLukxURDf8u1WfnlqsAjWfjY1RrB3sYhwhQwKQpZIF0wfK9QxLuBHaZtfHHproCrIS1LpUtMDubx2uKhJgAWzRFLBzxbQa5wW6ktWb2WXYRBKI7i5ZxRej61wK8CYJJceA1wtt0VyrWKRVYjP/CmiGd1DnBkycFrPmbm6zy23PcQLYkvIG5xTofkauMHcVhCgEkWfl9hFXU0OjPUFMuyt7IRLr3fu4Lt9DShVUHmKrX7n2Sx0x0BOMyuhU3OH7KEv43wZBOCvmy5taVJ0zK6f7F44YMoUpNpMQBV9bYwvn5vxQPaDUxVTAxji3QetdwrzdgwN8F09PG9g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by PH7PR12MB5654.namprd12.prod.outlook.com (2603:10b6:510:137::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Thu, 24 Nov
 2022 21:11:24 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a%3]) with mapi id 15.20.5834.015; Thu, 24 Nov 2022
 21:11:24 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, dsahern@gmail.com, razor@blackwall.org,
        jonas.gorski@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>, stable@vger.kernel.org
Subject: [PATCH net] ipv4: Fix route deletion when nexthop info is not specified
Date:   Thu, 24 Nov 2022 23:09:32 +0200
Message-Id: <20221124210932.2470010-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR09CA0128.eurprd09.prod.outlook.com
 (2603:10a6:803:12c::12) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|PH7PR12MB5654:EE_
X-MS-Office365-Filtering-Correlation-Id: 8b5d93c2-d6ec-4fee-ae43-08dace607177
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Dqfely8kSwSjqTvaq/+je8HgJ82ogGCGvk3jSfacHRK2AEPFTtF4ovK+/wdYIbUBS7wCnk3+chNnyRbcsQdoKr3XQzwTClDYTr/9Rrm6nb0NIk6mH80uqfUNLWaWZZmhvCNPPfg4hglIZ1vMKLYgRqLw6r7TlpsMbm9YpC6OXHJoPvUV2k6Ov7bjDOSfvuJwU4uECHZIkMqd1uKRJrHgMw0l4UVWw7mriIW3vDIAIfRD+GnB47JBu2/sD6dmbIKGFwZnuLmiC+bA5ZoTO9rQGxvBuuTt/H8f8s29AnnCa0II5w6ENDyhAD5UyJHC9y1JAjX9vnt9lB/IBqp90qKOBdaxmla+hwAq1H8PouLhGaPgf4MsraFtGsyA/0v6XAKBzaWU6i7pf/I32uDLXOfPNVwIUmpoaP8XdPogyDaWwF7htVd6BWCXoq4ljtoWr4efJKshBPmRWikgXTa6kS6Iok1ndU8T5t9LOMiBQakC14WjGNjtO7BbcGYqy++X0FK2GooK8ggETS8H6HjYzFbD94xNnhAij05FREHyJ8C9go0Apc9ojH+IBWjwSdWH5ejIY+QK6yo/i+VqcjjEVbqJDujqMaD6yRNSqudXmN/kMstox8w+31blgAG3QQY7iNINL3upjDjlfTU0RGQyFvxK6g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(366004)(346002)(376002)(396003)(39860400002)(451199015)(8676002)(6666004)(8936002)(6916009)(4326008)(36756003)(26005)(66476007)(6512007)(316002)(6506007)(66556008)(38100700002)(5660300002)(66946007)(86362001)(6486002)(41300700001)(83380400001)(478600001)(186003)(2616005)(2906002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ESQyvDWN3OQOK97XOnrokGc9IRYi9ooS/Vf0hI4gLRO/o5HROwUfiSJ0nx0A?=
 =?us-ascii?Q?2f3SzeO6yvDpkdDyaplMreZBX2+53g7VWF69OYRsaoDBF7wB+PTLLTg1Uy5t?=
 =?us-ascii?Q?M0fFCJXCQTMRrQ9puJejZpmOHkrpVG+mEOMwNjqvkR002U25aTC77Yro/Joe?=
 =?us-ascii?Q?NtymHrl8M9KxHvI8vj/Ji7jruKWZFvlwY9s3NTsmimGjRv/tnQjL4FJL6r67?=
 =?us-ascii?Q?oP0d21wtaeBk6DfMqxELkdE1UDIqZTLUHpAt8EOkitCgs2Q+D4oQdmdRVfb6?=
 =?us-ascii?Q?97mbeFX74pVL/ZXxkImMhBQfgFy5ibng7rqVqNmiJ/vE1bdscrB1HgLE8x8Y?=
 =?us-ascii?Q?bdh0SBGKpg3iifnFfyQZE/9rwWquxYQJBLMcNVc1r57QRXjYkfznCnxtBvFS?=
 =?us-ascii?Q?UkWj9IGXs8tRqwL6DJ/4BgAk7SRkl7NdsCN6BBcn+m5WvEnu0iqrWPWVDZnr?=
 =?us-ascii?Q?CMJzWq8Tkjmf8zUAiBPpQHsiguBVQ9TYbeYX6nSwpvqc0qjJkW+wRb152Lgm?=
 =?us-ascii?Q?EmXZFi907MMZruyTVx5ZHsiS2Wss73+w9miM6v3VPn4VbUKK4MfkDsF2o2FB?=
 =?us-ascii?Q?Y3jxdEIetMj8acWsSVenMCEXIkNFlmBTR/+MOAkQJs+Q6fo8rhZ++Ob0QArE?=
 =?us-ascii?Q?274MFh24J+UWLTWsKKRi1NH67Lr6qXnJx+bd0nTS3tUQ4ROF3bT3YBVv2D6E?=
 =?us-ascii?Q?w4hsSB7en2WPE7rz9GN0vmPePGNKDt3eNBeHwOUkE2Km4K7Tb9mSSOQDluEV?=
 =?us-ascii?Q?zSnaVmqDP5a+ids78DD96IPs6AvNTww/MT9eD//FPobFh3Nkr5JV/dFAyLHq?=
 =?us-ascii?Q?AAUjD4mM6sVJ0g2KUCUzKfpR7IXHbsBHtxd4BOJ0NCOHeEfRYK/3b63gno7R?=
 =?us-ascii?Q?OpUply+I3H9Of7CuH8Kf/OgMBcIBsA3Cjo3z/0WSc5NwU9CQ4EMQo8XRXIUF?=
 =?us-ascii?Q?C+jXKq8Y2eAf7a/5yIF+d/zacgNE6ZMnls+5S5KKQMI184ISr5G8mE5eMeGG?=
 =?us-ascii?Q?/mMQUV9qQ7zruAPaihZIfWwCVP0wOvMpdRTK8iEveKxxq/SXe+eLmb5kHsq8?=
 =?us-ascii?Q?2zT7V62T1EsAFX9tyR7nUFO5SCHGwMqdC8YwLyhOquNdNIYAvMIhFCziEEh5?=
 =?us-ascii?Q?PHcUveCjLxYMcA412b4hvtlZRBd6MI00IkyHddtV2k9t450+s77EI9NYwzpg?=
 =?us-ascii?Q?E1cqJc9mxBo++p6n1MHoaOsDPTL2nlBu44RxBozvfmKQeV81oY17ooQHJISh?=
 =?us-ascii?Q?aBZ6RJbunDRrQZGU7lQOJvs9BNe069tZTqAKcZUgVpYQrZbJG3vHWdYMNcgy?=
 =?us-ascii?Q?PPbtlRLQOqYQ9QlLctswzGVB/4F/oLPH/68iQzNqY2armKcdhv+IHrQd8tta?=
 =?us-ascii?Q?r0KirLFiQdMwQZTddPNWSuPtH2L+8+8aE4Ivl6pvMH2Ck7o10AHgpTehwr3j?=
 =?us-ascii?Q?kUmRxTRhU8ypL+i5ifHEicDiqDaS+81eJb7eLKdfrdXdrzELnHVUnKQic1qS?=
 =?us-ascii?Q?PRi5K21psQ3RygQ8O//gtgIy4ETra3eY/dAcx743uBryTIgwZQvBJQ2MwM0t?=
 =?us-ascii?Q?anAgjSZFuhMIH5YE32FdystA9pWFseSFLCDXv8ih?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b5d93c2-d6ec-4fee-ae43-08dace607177
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2022 21:11:24.3291
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tb1UmqKw4NvcWLVnERJloynxxufSImKbxaJVXX0Osd09FGsBpd6yf9XbjMsSBHp1sEFM4/8eG+N6kLxJIysHeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5654
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the kernel receives a route deletion request from user space it
tries to delete a route that matches the route attributes specified in
the request.

If only prefix information is specified in the request, the kernel
should delete the first matching FIB alias regardless of its associated
FIB info. However, an error is currently returned when the FIB info is
backed by a nexthop object:

 # ip nexthop add id 1 via 192.0.2.2 dev dummy10
 # ip route add 198.51.100.0/24 nhid 1
 # ip route del 198.51.100.0/24
 RTNETLINK answers: No such process

Fix by matching on such a FIB info when legacy nexthop attributes are
not specified in the request. An earlier check already covers the case
where a nexthop ID is specified in the request.

Add tests that cover these flows. Before the fix:

 # ./fib_nexthops.sh -t ipv4_fcnal
 ...
 TEST: Delete route when not specifying nexthop attributes           [FAIL]

 Tests passed:  11
 Tests failed:   1

After the fix:

 # ./fib_nexthops.sh -t ipv4_fcnal
 ...
 TEST: Delete route when not specifying nexthop attributes           [ OK ]

 Tests passed:  12
 Tests failed:   0

No regressions in other tests:

 # ./fib_nexthops.sh
 ...
 Tests passed: 228
 Tests failed:   0

 # ./fib_tests.sh
 ...
 Tests passed: 186
 Tests failed:   0

Cc: stable@vger.kernel.org
Reported-by: Jonas Gorski <jonas.gorski@gmail.com>
Tested-by: Jonas Gorski <jonas.gorski@gmail.com>
Fixes: 493ced1ac47c ("ipv4: Allow routes to use nexthop objects")
Fixes: 6bf92d70e690 ("net: ipv4: fix route with nexthop object delete warning")
Fixes: 61b91eb33a69 ("ipv4: Handle attempt to delete multipath route when fib_info contains an nh reference")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/ipv4/fib_semantics.c                    |  8 +++++---
 tools/testing/selftests/net/fib_nexthops.sh | 11 +++++++++++
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index f721c308248b..19a662003eef 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -888,9 +888,11 @@ int fib_nh_match(struct net *net, struct fib_config *cfg, struct fib_info *fi,
 		return 1;
 	}
 
-	/* cannot match on nexthop object attributes */
-	if (fi->nh)
-		return 1;
+	if (fi->nh) {
+		if (cfg->fc_oif || cfg->fc_gw_family || cfg->fc_mp)
+			return 1;
+		return 0;
+	}
 
 	if (cfg->fc_oif || cfg->fc_gw_family) {
 		struct fib_nh *nh;
diff --git a/tools/testing/selftests/net/fib_nexthops.sh b/tools/testing/selftests/net/fib_nexthops.sh
index ee5e98204d3d..a47b26ab48f2 100755
--- a/tools/testing/selftests/net/fib_nexthops.sh
+++ b/tools/testing/selftests/net/fib_nexthops.sh
@@ -1228,6 +1228,17 @@ ipv4_fcnal()
 	run_cmd "$IP ro add 172.16.101.0/24 nhid 21"
 	run_cmd "$IP ro del 172.16.101.0/24 nexthop via 172.16.1.7 dev veth1 nexthop via 172.16.1.8 dev veth1"
 	log_test $? 2 "Delete multipath route with only nh id based entry"
+
+	run_cmd "$IP nexthop add id 22 via 172.16.1.6 dev veth1"
+	run_cmd "$IP ro add 172.16.102.0/24 nhid 22"
+	run_cmd "$IP ro del 172.16.102.0/24 dev veth1"
+	log_test $? 2 "Delete route when specifying only nexthop device"
+
+	run_cmd "$IP ro del 172.16.102.0/24 via 172.16.1.6"
+	log_test $? 2 "Delete route when specifying only gateway"
+
+	run_cmd "$IP ro del 172.16.102.0/24"
+	log_test $? 0 "Delete route when not specifying nexthop attributes"
 }
 
 ipv4_grp_fcnal()
-- 
2.37.3

