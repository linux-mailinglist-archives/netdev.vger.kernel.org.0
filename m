Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7787D4BC937
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 16:46:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242556AbiBSPqb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Feb 2022 10:46:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234373AbiBSPq3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Feb 2022 10:46:29 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2080.outbound.protection.outlook.com [40.107.236.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5CA6606DF
        for <netdev@vger.kernel.org>; Sat, 19 Feb 2022 07:46:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WtpP5zNpkze2EwE5Su8FDujVI098zBCppg3dGf9EOIxknDjCH7txPkkjCbs7AKqnGGWpIoZ+zOeqlUA/T/k0DZ8yJRTRh4PpcgOB79Xe5kmJA22LPG2DzhafbPwce/Xw2Hvteu3Qyt3xD8QqRjWVv1nF/P/PSpSoPftaWWb7V1plglHO5AtEHRgM+J/HjNSm27y7UgEnqc2NKCaxDfTrIFAtnkkJvJ7bS/1yy/YsrJ4tI88g+YTAhraBHRbFellq18POU/mtqNrZbP/Vd4GhGzSFA50bUIU4brMYQRqAR3sXtH+z0bYVIfcRXlDMoaotlPLql64qEZxr9SY9ZXuQiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p+Vbk0pnXtDU7GsknKW6k/295NBu/l030kH2N8vGWO4=;
 b=RmONqXOTIwdOJgpfsIAZ/4ploU6KISTMuAK6NM1syVq7ONnxwK1eU07meD1iiyUutGesS6MRzJkyt4p1bpZAd6XBOs/ouZPF8DvqMVaV94QS2MVs5bki/yuyk9IcOBl0q1R62IMeSQo6mQ0jUNKvETJ97iCYv1jDRP4GmBjnFJb0skCRKtfeiPyPHMxXy2NEOz+vZaVvDANyYfsLmi/V11PIEzR6Ov2V51x3rl6ZKL8R36LfjvOtSTu/STAFdfYcFawJi70r3gHTa417320kRuY2vMuAohNp0E2M/NJdDE8rYu3K1IdhRyobIluIF3dEvBmxB/NHMCN5v/xJ6c0cXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p+Vbk0pnXtDU7GsknKW6k/295NBu/l030kH2N8vGWO4=;
 b=HeCO4wWVCKKGWWwu6puO+63PSBmbTnuo2LVvD82x+f23qwNcirYrK22hovg2hezO79nAeCzhPH7UI22DVx+DRHX9wTP34tbtytjcuPYXlJzc4i9XYOuM5skHaOCtBQw+Tvo3LJXGysy4AzmvD8qJDpCaBUM6RABD8Lsj9nDxtAY6mzGgzx1GjuYmVW5VZhL5uq94GUvC7rf8Bcn0wqOPeXR3oGQNIUei35OQKcDBrLsod8ANs58FmkIUUE+92d9yL3keOtU4GUw8hMqNZDry3RwwPVxT1aUHvYW/zHb4BvcFXR+LYGuU1UnnGzHQxkENrBVq9QFdkZakip9AHzIZfA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by DM6PR12MB4340.namprd12.prod.outlook.com (2603:10b6:5:2a8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Sat, 19 Feb
 2022 15:46:09 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581%5]) with mapi id 15.20.4995.024; Sat, 19 Feb 2022
 15:46:09 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        wanghai38@huawei.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 2/2] selftests: fib_test: Add a test case for IPv4 broadcast neighbours
Date:   Sat, 19 Feb 2022 17:45:20 +0200
Message-Id: <20220219154520.344057-3-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220219154520.344057-1-idosch@nvidia.com>
References: <20220219154520.344057-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P193CA0009.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:800:bd::19) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ec3c121a-95e4-4c64-c81f-08d9f3bef2e3
X-MS-TrafficTypeDiagnostic: DM6PR12MB4340:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB4340E1EAE27B3A69C8079D1CB2389@DM6PR12MB4340.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dAtYQJSgL/51CXheES+faA27Y7ctcX7Jg98Dvh+mSh6tb3t3EiDhxKGD+lR0TcgGXXiAKYvMxbV68lxjV9Y2MmzNg0CVQLKvt4o6KzaX9Mx/PE0ly4UvqReqqJ75IWnnHiK7Flu1t3JUEyjulemVN3omvfa2uzRY9J1Z++xQN8OYEn/UbKFyzv8CCVFebk/iEf1ClsaVNedGzqnWs7+1XAk4YkAAumvmvA7QGalvUe/EpbGPQgjQGzWwKI76fzq2/pzaBNTVd+NKClKqP1ZDX/fHu5JN16QJ7sOuizT3hwIINS72H12HdZg5k+8ueGqhs2pD38vJ7KNZWTRyweAnL7RQNGQUDdCZI1n39/k9WjyXSv+082x2K7dtrAAVbV6htJ/QvVKTWGImxkYsawE/PtouDFyU/s0gZuukojUZiiYEE/RdhDQkzBsF2MiO6x9123xtg1iNHjI6IYP8Qjl/o5iMi2RXJwWbSEpkiBJ+Z6qeaXpGxpqvhf9rtPcoDiyT5iw2UotWANyGm8VokovOKkUh4NrqCa9ePoY5J4y0k1C0EypP7q/9/CfRp/j3jIITJvcQ41tKZ6nevwngDrMBc4bYJshiKDTCkdBKfvMhwuex5Fy5ikF/ZA5G+h0rJpTILUceNj0oexEvHjmvubjPUA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(86362001)(38100700002)(6486002)(5660300002)(6916009)(8936002)(66476007)(66946007)(2906002)(66556008)(4326008)(8676002)(83380400001)(107886003)(6666004)(6512007)(6506007)(508600001)(2616005)(1076003)(186003)(26005)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tZToswBhw8LjcxqneHSQZthlmmQV9ZmVQxMKfanQItVpsaJaRSv6R+SYSajn?=
 =?us-ascii?Q?RyrWYn17bYpfwp6vdYv4cZLpYsce0THKgfcI4SwGWHci6oB/efHsGzSw/KSf?=
 =?us-ascii?Q?15J948NKWhPav5BMRrTT6/CVO9YlffT2mIrxrpUN1QAWhmTGJ6otUguYNwga?=
 =?us-ascii?Q?RyJW7r0JhMqGG5drTrXGdFLxN12KrA/OQAG7yd+6aWuUBaPm0ARdyLWssfrW?=
 =?us-ascii?Q?IQz5npi0uXZRkN+RykscAzjA/6kyoLPVb/VFCqc8M957/5MaQ8BwjDnWhJab?=
 =?us-ascii?Q?bvxERUBOHtg6OCnMNjbn3Ro3c1n3++1zJUxZepdO7wjG7fXWBxWFdLtNToGq?=
 =?us-ascii?Q?HiawCQO2FEvvGSDnyonS9VDi7CsLEXTw5LdkN7p25DBAPJk6IQHP57B22XbY?=
 =?us-ascii?Q?KOEhBT7ZZM+C1tDMPm8TfbfARM3wg2Yvs0zrLBYpvrnUTPiQH1t8iEcZPn/b?=
 =?us-ascii?Q?BUd2doPYnO+pUEo5jVvqh8s32n7WnkoDWutRO+7QKeTgrD/ADZOV+elDXZtw?=
 =?us-ascii?Q?sltiYcG5HGy43EdBz8c99kxV57IBbaGEQEKOrDlOGwQ280HwJxPZ9DmjHpeN?=
 =?us-ascii?Q?j3J3/AnOcjX5VLEVj2N305Yj/aJSpSojfvsDDLCfWfhD5clvtWVnG+XiX3iH?=
 =?us-ascii?Q?qHyCHrzKDu6H77nUxBkkrvlv8E2RHbH8kGVTyBc/bkoh0TT3uiKzisMbmgV2?=
 =?us-ascii?Q?789vcHK91d8aLwYMk16RVClvtsq6RKxNlUbI9eW2w77RDsFbBqX77nf/Ilyv?=
 =?us-ascii?Q?52ctPiH2QWDMD5Vr+IMaq23CUVjSkAvc/zE6udpXW0ukE8gILVnwqNtT/tDm?=
 =?us-ascii?Q?ZRAhNOKrC+KvHxLM6HcjOwddVKVxDWvH200Q9wORNKe16tzEI6TzqGEgtwa+?=
 =?us-ascii?Q?TxFTlHn4rJIAHDuGJR+ydVxL5rF9Lm+WczM17/iTveT7NNO02hy+swMdyKkb?=
 =?us-ascii?Q?/0+upzdFcCTJo9vvnU7GHKN1yTaiTc0+KXOHyE+iYa79OHuSCwxAyZ85nMOX?=
 =?us-ascii?Q?4FCOJIsBwJNA9CJhs/yuSBkT6pdqMNn9xtmRMZCD8iTJzCpcqZ3gXBcOAjv3?=
 =?us-ascii?Q?rbs0MAeHTX1nG1rglCgjePQzWTT7C498HjqvfDJqA7acc3UZXqa86PNZprpL?=
 =?us-ascii?Q?FQ6zmJgLb6NrqUtBtC1mMfEUg3mRm6DE457UTUgt7qafRJdfOkkV6R2W6s7B?=
 =?us-ascii?Q?r0WlNcpYmGB5sGsDh0mYwhzE8vOTjgBSxNYlSOSgL+Sb4CJT212uknu6R9A8?=
 =?us-ascii?Q?P7MJ+xMc+p54gDEELoNLS7WSdqfOE5uB27NXTBm2v59PMpQ8kq/fte6a3eBF?=
 =?us-ascii?Q?95XLJkH+GlJhoLSL6ei6ZnPRBRQ/SJSQt87O3TtpamzULXdPFa7JROjm01IJ?=
 =?us-ascii?Q?WEbP2RwsV9z8jPdYbgHNJh7NDwDwOqEoW04i5+H9ckiy3VqD5z1CpokQjA0y?=
 =?us-ascii?Q?mU9XSM/nAmyTWeMDCycOzFEfFxH/tcEVXEtabmweYXJYD58gjCYIhE4b2Xu2?=
 =?us-ascii?Q?qWns3ShW6jCmZVnajjtJ5fBuVz7EyRAtVXEXyKjf8V20sVLwpbAALnKs2glw?=
 =?us-ascii?Q?2CxK+Bmicw1do5t/TuTHZ9csz5J4ewXRt5w6vDzzqf4Z3DpEKfjaRF5u4epW?=
 =?us-ascii?Q?QGkhwWEOJ9SKrvYDFB/MDRE=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec3c121a-95e4-4c64-c81f-08d9f3bef2e3
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2022 15:46:09.4610
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wgZJOnnU0BKDVYcfryPr3te1NoFU+C8hChxcrA54gvKLyQqof0se+AmqzUVv78FowifSNuZtxm72QiEvBFeHgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4340
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Test that resolved neighbours for IPv4 broadcast addresses are
unaffected by the configuration of matching broadcast routes, whereas
unresolved neighbours are invalidated.

Without previous patch:

 # ./fib_tests.sh -t ipv4_bcast_neigh

 IPv4 broadcast neighbour tests
     TEST: Resolved neighbour for broadcast address                      [ OK ]
     TEST: Resolved neighbour for network broadcast address              [ OK ]
     TEST: Unresolved neighbour for broadcast address                    [FAIL]
     TEST: Unresolved neighbour for network broadcast address            [FAIL]

 Tests passed:   2
 Tests failed:   2

With previous patch:

 # ./fib_tests.sh -t ipv4_bcast_neigh

 IPv4 broadcast neighbour tests
     TEST: Resolved neighbour for broadcast address                      [ OK ]
     TEST: Resolved neighbour for network broadcast address              [ OK ]
     TEST: Unresolved neighbour for broadcast address                    [ OK ]
     TEST: Unresolved neighbour for network broadcast address            [ OK ]

 Tests passed:   4
 Tests failed:   0

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 tools/testing/selftests/net/fib_tests.sh | 58 +++++++++++++++++++++++-
 1 file changed, 57 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/fib_tests.sh b/tools/testing/selftests/net/fib_tests.sh
index e2690cc42da3..2271a8727f62 100755
--- a/tools/testing/selftests/net/fib_tests.sh
+++ b/tools/testing/selftests/net/fib_tests.sh
@@ -9,7 +9,7 @@ ret=0
 ksft_skip=4
 
 # all tests in this script. Can be overridden with -t option
-TESTS="unregister down carrier nexthop suppress ipv6_rt ipv4_rt ipv6_addr_metric ipv4_addr_metric ipv6_route_metrics ipv4_route_metrics ipv4_route_v6_gw rp_filter ipv4_del_addr ipv4_mangle ipv6_mangle"
+TESTS="unregister down carrier nexthop suppress ipv6_rt ipv4_rt ipv6_addr_metric ipv4_addr_metric ipv6_route_metrics ipv4_route_metrics ipv4_route_v6_gw rp_filter ipv4_del_addr ipv4_mangle ipv6_mangle ipv4_bcast_neigh"
 
 VERBOSE=0
 PAUSE_ON_FAIL=no
@@ -1954,6 +1954,61 @@ ipv6_mangle_test()
 	route_cleanup
 }
 
+ip_neigh_get_check()
+{
+	ip neigh help 2>&1 | grep -q 'ip neigh get'
+	if [ $? -ne 0 ]; then
+		echo "iproute2 command does not support neigh get. Skipping test"
+		return 1
+	fi
+
+	return 0
+}
+
+ipv4_bcast_neigh_test()
+{
+	local rc
+
+	echo
+	echo "IPv4 broadcast neighbour tests"
+
+	ip_neigh_get_check || return 1
+
+	setup
+
+	set -e
+	run_cmd "$IP neigh add 192.0.2.111 lladdr 00:11:22:33:44:55 nud perm dev dummy0"
+	run_cmd "$IP neigh add 192.0.2.255 lladdr 00:11:22:33:44:55 nud perm dev dummy0"
+
+	run_cmd "$IP neigh get 192.0.2.111 dev dummy0"
+	run_cmd "$IP neigh get 192.0.2.255 dev dummy0"
+
+	run_cmd "$IP address add 192.0.2.1/24 broadcast 192.0.2.111 dev dummy0"
+
+	run_cmd "$IP neigh add 203.0.113.111 nud failed dev dummy0"
+	run_cmd "$IP neigh add 203.0.113.255 nud failed dev dummy0"
+
+	run_cmd "$IP neigh get 203.0.113.111 dev dummy0"
+	run_cmd "$IP neigh get 203.0.113.255 dev dummy0"
+
+	run_cmd "$IP address add 203.0.113.1/24 broadcast 203.0.113.111 dev dummy0"
+	set +e
+
+	run_cmd "$IP neigh get 192.0.2.111 dev dummy0"
+	log_test $? 0 "Resolved neighbour for broadcast address"
+
+	run_cmd "$IP neigh get 192.0.2.255 dev dummy0"
+	log_test $? 0 "Resolved neighbour for network broadcast address"
+
+	run_cmd "$IP neigh get 203.0.113.111 dev dummy0"
+	log_test $? 2 "Unresolved neighbour for broadcast address"
+
+	run_cmd "$IP neigh get 203.0.113.255 dev dummy0"
+	log_test $? 2 "Unresolved neighbour for network broadcast address"
+
+	cleanup
+}
+
 ################################################################################
 # usage
 
@@ -2028,6 +2083,7 @@ do
 	ipv4_route_v6_gw)		ipv4_route_v6_gw_test;;
 	ipv4_mangle)			ipv4_mangle_test;;
 	ipv6_mangle)			ipv6_mangle_test;;
+	ipv4_bcast_neigh)		ipv4_bcast_neigh_test;;
 
 	help) echo "Test names: $TESTS"; exit 0;;
 	esac
-- 
2.33.1

