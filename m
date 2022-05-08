Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AF1451EC2A
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 10:10:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231133AbiEHINn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 04:13:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230527AbiEHINk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 04:13:40 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2053.outbound.protection.outlook.com [40.107.244.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B2D7E0B7
        for <netdev@vger.kernel.org>; Sun,  8 May 2022 01:09:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d3DlIiOA2gf7oyMetjANX6h4tH1PqFyJu/RR3aUbeKbBeUod4tS+p1QCUo3z1b/2oJ0YP2aCijO3jugcrDPQTGdvKz+ICPnzKV4WCeNl5pTpFm34NWhv0ZDG+NkFEUJVIp7Y258i4hInFBefxnmgLlTLaHVWZK33zpK4vDXPH6H8lZ2s+rOi9H4m436Sci8hlagcGEVYK3qdscS69/zkM8ilD7ZQfhkQ3R4lo2SUau++6mzGmhg1I8k0vEcnsckVJcHVhpk3QNarCJZQ0Oe867Ag6KUJjjRqWP6XYxBXIr9ORexpn6Q+7xCj1InZ7j8G006kIR6tWro9/QoY1Kkd9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J3XAfDVRD4iZBmYU7uvIELT2ObXj54thv1uTBAH0KAU=;
 b=ibsKlBkD6MmaE+VD1Aa25/rQSeOX0P0DuHThTUVoTUFRuD1WgChReH4+oZwV90bkH/k+umKLQHknhxiR5RDJZHJh2Jr9LB6DzXJ0UignsaqFpMwbkajE4NrBbPRl9ZHsno/3FTKwNDnQGQTYJTdIMN2r7CUODzVwpgbTrlj8X40MKcE6Nd2GbgWRbqCg238a7oB2c01r91HAF8GQFhZ1oNLnSifk3WcF07CK42XC69udfY6COTdDiwegdmU2WJLfG85tRfw1DDZE1rwp2EJXhKmOgn/Uubn1YhLXsnIHf7fNLfwbBaTcb+1bWFhzbDDW/d3DBPqus+vkqvi1LK1dmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J3XAfDVRD4iZBmYU7uvIELT2ObXj54thv1uTBAH0KAU=;
 b=rZmGteuerFDL9p1YZlZ7IlIYcH6e2KGtVV5uzlwxgKJQTsMY+C1sYEmQyWK2CfCYyqol5GlDKCE/IXOB1MRuDzrwQ1yo1V4B9rfV0uOvvh3qxpwUEMqPGWaM1wSCjl2KBzHdQctqFV3JcWHrVufQ4x1PsknLFHf2TiwrMMXKNIu+i1VlTBbsH6Scfe9bHOOZYWvur8qDY0yL+E8lzTGpZ/tElNk8PCot/z3KykssTPPBhz2raFfSlQeptHaB4aJ3ERbbmoitFl03dWXXG3TDTNXv14WcFdOMVEHCpqpgCmh2igC1GCPfgC+CxLBG5dGiaL7YP3UbZYndNGoKoJwMyA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by DS7PR12MB6096.namprd12.prod.outlook.com (2603:10b6:8:9b::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5227.22; Sun, 8 May 2022 08:09:49 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::45b7:af36:457d:7331]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::45b7:af36:457d:7331%7]) with mapi id 15.20.5227.023; Sun, 8 May 2022
 08:09:49 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 09/10] selftests: lib: Add a generic helper for obtaining HW stats
Date:   Sun,  8 May 2022 11:08:22 +0300
Message-Id: <20220508080823.32154-10-idosch@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220508080823.32154-1-idosch@nvidia.com>
References: <20220508080823.32154-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MR2P264CA0101.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:33::17) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cf47e658-40ed-46f0-8ea5-08da30ca1f50
X-MS-TrafficTypeDiagnostic: DS7PR12MB6096:EE_
X-Microsoft-Antispam-PRVS: <DS7PR12MB609679F0412984703A1B1983B2C79@DS7PR12MB6096.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +SgMTM5kb+c26Imlkf3itU2fRzbMjtvvWYQLHN9arDTdkknbKcXjkiXUHCso9KUNut1OpEBBa1T1AsRd9BXC0f23kA8b5hMJOIBMdsgvCVGOt0Ngx6lXr3qgZKdXgxgnvA7iwakXcEuVhSLajG8mZNKL/LP+BnYWLtRL5D+JD0+euGoCCMODADqy9EtVv3ftlI9HVYF876r9Sz5Jf34M/SgtjqyoDJ6m58Is05O2PkpHAz7VvJJmdyYwqvOzZg6Vf2hIyBC/MNhW5/ZDvkVUc5ZuggbDPi29ndI8FDjuQoC6YTE1zdS7eTTdz9+AnRRAf7W/PIcaEd7cxsSVSxyfcNI77qn+P17Vt1IyfdgrsqQJ2SNrVNEDU4jNb6BezNZdfE/paeBhExmvc98c8MXXwm5ZKL0dgRKoPL80K5Gr00NWi/fBrYzaSA76lfPWIGnD/CS+e5kyeiB6NVD3T8iewpROcqP0R0RBlCzy0p1ecFLKeeMHiMT3FTUxa0z34MbBmwVv7OQjaSRd4EBYIRHeIdzrRrCd9rkZfYnuK8vIM21gV7CZ6HkGHRG2oXZtfKywWHJmE9+utAPc+hbVsKC77jVS6wZsnEoQ6IsZyg+HaRsvGoGe0hDO577FptOFSAy0ayR92NtoOunMs2NgrbjExGTAiMYysoyRF7iJi5QLlgR8wBiMdufwz6AGIjSexP9gxXOUsl+BykEvIv/29pP11A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(1076003)(6916009)(2616005)(36756003)(316002)(6666004)(83380400001)(186003)(107886003)(8936002)(86362001)(4326008)(26005)(66476007)(66556008)(6512007)(8676002)(66946007)(38100700002)(508600001)(2906002)(6486002)(5660300002)(6506007)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sCkk9J7TQRGKe4mRS6cyToLE3mCzIAsw+Slm18a1iKSF1wDgKxMo7ZyyKVtm?=
 =?us-ascii?Q?qSDkaQmRIudcRz3vriiBi2AMMo5812me327LR+lv1Ptu3c9BA9dmATx9WSmZ?=
 =?us-ascii?Q?u5CjkXx8MNE4ysJh7pjA1BlTAtbSHNAF/n8h6IWWBSnDbU+a3iEyvuCenbHT?=
 =?us-ascii?Q?HgeYWpjjpn65iIajRqxpsPEKWe3ATqW6iDAwFXRVT+e9Icm24XB4p4xzkLK/?=
 =?us-ascii?Q?NEfrOqgFMnzf2Z+eR7llfa2aCfrqpmzMEEuzq3u1NuORmK3M6NqnuDKq1zSy?=
 =?us-ascii?Q?C3r+sYcSW4SNdWkV16nK7wl1VC/nO9yqShu0Vni78FAKHtFzLYF9YyEOAYvV?=
 =?us-ascii?Q?ObZ+Xyg9RbGYPKnzFqTF1DzGCYOy1Ohm1m8XMjriFp5tnG2pF1R7yIrQMAQq?=
 =?us-ascii?Q?eGnbJP0AnVI/ppxhhN5VLVxzqmq+CX4vUmPzxe7q06PAypS7TsWynP+sTtAy?=
 =?us-ascii?Q?4PfA8L8HzBVuvdB6BMCbZ4+BVdbaUFvcyxwo2FBElMnGG7lWO7J8SVPHovBZ?=
 =?us-ascii?Q?nKk05pg8kMHyaXE+2golP/ZXmrZFFysDs1NS+PQsqlFJUEO2SDdIKpZqxniM?=
 =?us-ascii?Q?gfotxxqhMgt4czwL3u4Pn/0q8T5lJVdaXdWlUS0Es8IRK00IPosxLbl/gEkQ?=
 =?us-ascii?Q?4BhhbeS+kvhGoefqUlBgVbxZubEwSIhXXUbMU/wuProEs5dSeZ1U9he3K3u4?=
 =?us-ascii?Q?Y67qfmRCr48p1iWzq69eDcaz7pGyDC4GQDlz4uy6DVLnRSzO4tm/dI8zqQVD?=
 =?us-ascii?Q?+6TvxygdyOO3tO+Su1mLCidtKF95rM8j8bcFk0X+ojWJbWNfWhIRvZZOm6fF?=
 =?us-ascii?Q?QtPz7NK6CvGrJ2YkCbifh99s4O3FZG81O2fAudQsJOJj2zN+esOkN9RFYCIs?=
 =?us-ascii?Q?8tSahp61uX/YSAdQsFc050Se85W7zUZjH4m8dnLbtqKRtItJSwBhdnXeI+fG?=
 =?us-ascii?Q?VVyfNc+eiG8R4bfpbHcixpzRZkOsPZYB5WC3YD5p/HCPY5pOeSVMWyUJpuzG?=
 =?us-ascii?Q?Ay5lfQVkRk8DHTeZ/fud3IzF7/3bw9QCe5bBiKy/tKJ4fuJu9YiHhTX+3pmv?=
 =?us-ascii?Q?b4sIsIstaAKS1qjLTnrG/GCMXT648zimdAD7uZXcOp8btr0FZevbF/2J/CbG?=
 =?us-ascii?Q?ii6r4fPi5nlXybnBJx2de/Gzf4hlBHJZtis+L4a3+B+lods/b8t0o9wSGLbr?=
 =?us-ascii?Q?U1uVluo1qEPXtVQc0vS83hsAH0A5bFyaCBR0us1oA2S0MTJNH6D+4PNVfdir?=
 =?us-ascii?Q?0KgIA40+3G+tuwfF846qa7s+0u28QsSbmXZiwPJm9dRTvG3ouhbLAMY5esHn?=
 =?us-ascii?Q?G5o4N8tjecEMuTpiMZeJr2wCngfdjIBCP2olC95+fR23pWKV1CEp23u+ehnn?=
 =?us-ascii?Q?5RNGSqFrq4SANRI0ouB3z7RFCssT64g7cXb2ATUXsP5sGKy3lNACGKvS8FBB?=
 =?us-ascii?Q?qHJT5y6n4ijMR8ucAlDMjCg7RgprdNyMdLiwmHfTHGaxkcFXV/ycA6W39Bq2?=
 =?us-ascii?Q?gNG18uVjwaqUoKGQYsbsLCdORYzMVtRpAotcVtixoofjB+ASSp2+YEyF8km+?=
 =?us-ascii?Q?2JJ3rdc78ksQXUPUfg/bAOhlGx1IC644chVWXk1gxqXJIWHQgPtcRzN02TpL?=
 =?us-ascii?Q?03Tw7Yr1QUV+L4rppxzOLL8eB7INA6d/lHLaXTXWJu+Fa4CrtlXA2tBqg5h2?=
 =?us-ascii?Q?Cgv33GJZO6sWWP+d1jKlltSrXlzh0q/H8dPzqX+0wqot/yQvP8puPbQJJL14?=
 =?us-ascii?Q?dJtUQpHArw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf47e658-40ed-46f0-8ea5-08da30ca1f50
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 08:09:49.4183
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QIBF3GhhsFkZb2blz1VpC3szH1kSnsfQK4iXR88zHm1+pXE810YPhmfN8yv26pNlzzl69KE8+bCUMa7ki44VMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6096
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

The function get_l3_stats() from the test hw_stats_l3.sh will be useful for
any test that wishes to work with L3 stats. Furthermore, it is easy to
generalize to other HW stats suites (for when such are added). Therefore,
move the code to lib.sh, rewrite it to have the same interface as the other
stats-collecting functions, and generalize to take the name of the HW stats
suite to collect as an argument.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../selftests/net/forwarding/hw_stats_l3.sh      | 16 ++++------------
 tools/testing/selftests/net/forwarding/lib.sh    | 11 +++++++++++
 2 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/hw_stats_l3.sh b/tools/testing/selftests/net/forwarding/hw_stats_l3.sh
index 1c11c4256d06..9c1f76e108af 100755
--- a/tools/testing/selftests/net/forwarding/hw_stats_l3.sh
+++ b/tools/testing/selftests/net/forwarding/hw_stats_l3.sh
@@ -162,14 +162,6 @@ ping_ipv6()
 	ping_test $h1.200 2001:db8:2::1 " IPv6"
 }
 
-get_l3_stat()
-{
-	local selector=$1; shift
-
-	ip -j stats show dev $rp1.200 group offload subgroup l3_stats |
-		  jq '.[0].stats64.'$selector
-}
-
 send_packets_rx_ipv4()
 {
 	# Send 21 packets instead of 20, because the first one might trap and go
@@ -208,11 +200,11 @@ ___test_stats()
 	local a
 	local b
 
-	a=$(get_l3_stat ${dir}.packets)
+	a=$(hw_stats_get l3_stats $rp1.200 ${dir} packets)
 	send_packets_${dir}_${prot}
 	"$@"
 	b=$(busywait "$TC_HIT_TIMEOUT" until_counter_is ">= $a + 20" \
-		       get_l3_stat ${dir}.packets)
+		       hw_stats_get l3_stats $rp1.200 ${dir} packets)
 	check_err $? "Traffic not reflected in the counter: $a -> $b"
 }
 
@@ -281,11 +273,11 @@ __test_stats_report()
 
 	RET=0
 
-	a=$(get_l3_stat ${dir}.packets)
+	a=$(hw_stats_get l3_stats $rp1.200 ${dir} packets)
 	send_packets_${dir}_${prot}
 	ip address flush dev $rp1.200
 	b=$(busywait "$TC_HIT_TIMEOUT" until_counter_is ">= $a + 20" \
-		       get_l3_stat ${dir}.packets)
+		       hw_stats_get l3_stats $rp1.200 ${dir} packets)
 	check_err $? "Traffic not reflected in the counter: $a -> $b"
 	log_test "Test ${dir} packets: stats pushed on loss of L3"
 
diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index 66681a2bcdd3..37ae49d47853 100755
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -828,6 +828,17 @@ ipv6_stats_get()
 	cat /proc/net/dev_snmp6/$dev | grep "^$stat" | cut -f2
 }
 
+hw_stats_get()
+{
+	local suite=$1; shift
+	local if_name=$1; shift
+	local dir=$1; shift
+	local stat=$1; shift
+
+	ip -j stats show dev $if_name group offload subgroup $suite |
+		jq ".[0].stats64.$dir.$stat"
+}
+
 humanize()
 {
 	local speed=$1; shift
-- 
2.35.1

