Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50214583DF4
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 13:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235933AbiG1Lqg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 07:46:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237247AbiG1Lqa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 07:46:30 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2076.outbound.protection.outlook.com [40.107.223.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 761F068DF8
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 04:46:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JclFOPidqS5j+pwSkp/vjTknaSRB0DfD2MB2S/wNza40SqQelOXugBNG++07eyiCeIW9OLgOzd4grI2sju+wXMkmSJ/0X1emqbU7rQHT+fQsnmcyZQQiwS6s5SCJfa7f9NlVZK6TDaMUr4xAnAyZmMlHTxIO6yHdVBZSTJTOGbrNqM6nHQo6tvquj8+0Zq52WWlvkqEiBpPOvpaCM266/mFFXAjb7NYaWtFfAevV5IWBIZ9tbjo5IJUAA7de0O6vjiIG1p4DMd1kYPGJJxjNuNqVqSqbssBB2Q5AoAGzar9Ycwhnr/BWzhGTrEiyXFbFtsdS67bGg60Ne7zS9j155A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IXIgk0I62gwNLvi8OygpYe1ZVtguYy8clhWXw9hMydY=;
 b=g1kljXdATyD6Rvwv8nJCEqzhIzzwrfFfqlKxTv2DS9TOoAITRrRaC8u9l3p1hLEI/WWKFsl+0tyb1Nll0xif0GKS5ayUhSMB9eJWjMU9NVEztDHYJgD4nRZ8z9JT+cMVsYsZBW6ag1JXDNd6KNGopBwV/3wgk1I8t9J6C591omsq4lC21DUBpk8nUW9dVBl7GNw3xX7CwaInbi+zsU1+Dk8yPchb6kVS7CngIQfJsY6MSruI8V1mjvOiqCr7ZI2ow30nxn2oTCMtvXkhunoQMYtvV3lGeM7viPr0OyQMHGrvhhtAzJoIxspRk6m3/yZeZFHLyuQghoRMDlX8VIwtFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IXIgk0I62gwNLvi8OygpYe1ZVtguYy8clhWXw9hMydY=;
 b=DXPdWnvIFOWXDI4Et5PLw2Z/LZdm5g1/z/8y2KmRE83FklNr1uqJwXoaTxPd5F9+qmT9kgcbKk0ITIqd+QCIMNH6qs9JmJWr3LiM+4MpHoLBXNFqFP2tB1vRhTIYRBgxevU1v3+QB6zo6F1NsX6hutE/VAXWydus5nUp9sBtJOTu6IZJcvwIsz+dW3r6EfBGXxCTDPCtRmQmppdU4uHHxuMrjAFfz8YRtY/ZdIOntFGjDPfvfdToDM4MrRhw4OI3xvA7dht2ydeGQcUX1k9RhegSolzPVhfIH3PICOQIoZXUvwsIuOweRrehp6V2xgsUnWoduwsGgDdC5Wm2+C/Ntg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by MW3PR12MB4505.namprd12.prod.outlook.com (2603:10b6:303:5a::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Thu, 28 Jul
 2022 11:46:23 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::2d48:7610:5ec2:2d62]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::2d48:7610:5ec2:2d62%4]) with mapi id 15.20.5482.011; Thu, 28 Jul 2022
 11:46:23 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, amcohen@nvidia.com, dsahern@gmail.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net 3/3] selftests: netdevsim: Add test cases for route deletion failure
Date:   Thu, 28 Jul 2022 14:45:35 +0300
Message-Id: <20220728114535.3318119-4-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220728114535.3318119-1-idosch@nvidia.com>
References: <20220728114535.3318119-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR06CA0087.eurprd06.prod.outlook.com
 (2603:10a6:803:8c::16) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3de647c2-5479-4f11-642e-08da708ecbe1
X-MS-TrafficTypeDiagnostic: MW3PR12MB4505:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: baX6KIElrRU6W4M4uAOyUbiVI6BcTYQz3kdUDWaIdH6WBrLZ7IGblFk68ArG9UKE40UUrAS4glhrYvz3rQiR2aKWSLb3gSV5TJt+pJnO9acqLMYs1VIEkfH4BUYCeM6aO9d+HJ13txq1PC2T8vk88KVJxfT+W2rNHSuQh3JibGSAyQ5YqKkTMzF2OP5YPE6pPhREMYVNzVz5OTuxgBTffejOToajFiFySiHI21Sl4oC8iOGi0BcNqF7fkVajKlpnJDmNSicFAiidJxxwv1tUEbO+4W0+HcMzmjtEf5tkxXNTTqEZUqsa3N4jCfzoTtQxmgpyz4cMONUjEz11H46KSvj0aeimGGfqm1XXG4jXyuLoNHJaEZxHt0qaOMDP9vTlJ/zcBGPqWDMuBPI4yByu8B7aebZda61MLaOj3TttTWFxUP8eHqjFpF6znyK/6LwirpinhZ2EkjLNuB3XtxXddVrFS6XtZnaKgiA8DOEkRx++Ncg8p9Hi6kE3gpMs/h0pfKTnACgtl9XYKU+KKDy6u617RWpwOusg6IKAC0x/t7HI/7KLeONJWQ8lcIaDzi3gwh0mxGO6cssaRaxLY5mBS7SmWj1ei3U6apx1kpTglkUKeHncu2RM1bRYw5qwMS245w24ExT9dLJ1VtcxBTIx10HeygBid9+Yk9pYM6NtG+1LEKCsFDEcgqiLiDsJ7mHvicbgP4p/Eyj+YkZLquOjZr+5TdacKh1BVBUdL3O3jjzI69Sphiy9iEyKrpS0WvKz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(346002)(39860400002)(396003)(366004)(376002)(6512007)(41300700001)(186003)(83380400001)(6506007)(6666004)(8936002)(2906002)(66476007)(478600001)(6486002)(38100700002)(6916009)(5660300002)(107886003)(36756003)(4326008)(316002)(1076003)(26005)(86362001)(66946007)(8676002)(66556008)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?N1u6qM2A9Zk5Mn4niYvrWbaHwWdt1ewsstiETLRnQtWxZFjvNqvaXUnr770V?=
 =?us-ascii?Q?nVNASqR45qgo0DeVxilRoAXWAbEiegUSgPpCnjU/kG+4YLGoh3uqBAAELt8q?=
 =?us-ascii?Q?CH3EsaweP2azJpLeOW46+OJJowQZl3/hg9CQdQYkwHwsJe9cjr8pX2oSz3Bi?=
 =?us-ascii?Q?9GyYJ7t2vFxdCTAha8/G11XbdVcvNXH7f53ZsIneu/ARHE9oNWv/DC5bO7jc?=
 =?us-ascii?Q?U0gDX2+Q2ZVXrjc1GYxz/V++PczmrLr0kpeMyYEsTpkuAwvO1LfXTC92m1vX?=
 =?us-ascii?Q?vhqGUrEPIt+G4n4Fy8a1BrNx7jbdVKx0Kx9qO1IZF2SD6ZG7q7BrTgq29BNr?=
 =?us-ascii?Q?lqptkXThGnPbIxee2S4YfpW+Zn00MCMNHu52k9GWfbt3Azdyhrhd87T4sMlt?=
 =?us-ascii?Q?u35UY0uzqukQHtctk2NRYWk4TGg+rGTl1ZL+Nx6EoSQCvvKGsjz1ZtOyznCx?=
 =?us-ascii?Q?JqRzs1r0MamQ/qeO6/e8wZazdQnr/iHmRJ0peksqdqfuqSnGOLDWKFepe6RM?=
 =?us-ascii?Q?PoAzbUC6KVH0DfpXXFupusdDibKXWoWat9/j7jXx1FH4oso48hwKkUlhQ6nD?=
 =?us-ascii?Q?0m2LjFBIkJsh1TSbg7ya7BgqFGI21vsUJuVM2g2SCHXp/kZhG5dSOL1AtP6d?=
 =?us-ascii?Q?xMxJUWkUgylqqwX/WEU8tQmeFPZx+/PV0shyBKcBJYAxUlx/uAzqQTZb8QF4?=
 =?us-ascii?Q?yLhy6F9uyL46KDD36X3KK+1WMuFCbuMalxfu6JcVK4IhQMiu5pOCQ9Hy1smH?=
 =?us-ascii?Q?nGxWvIBtqmanRgGoBiClGfqo3HW7tbxDLobrKn0kiEwblyScoNy4WVfQYIY9?=
 =?us-ascii?Q?z4kJKRLv5G9ICT3qieaW51gKKy2CWTlm26mRacRw3B2SIgiCodT7xbZJZfu2?=
 =?us-ascii?Q?ZFp740SgiezkCB3HC2sDHu0nza4sYw2DpLKAKC9jfVCySy3CAT3YAdbXTQuq?=
 =?us-ascii?Q?78VgVa3i91vYFnNVCu8xNecz6SW5JSlvsyPt+v5Rxfg06AotgWzQCa/jjEC0?=
 =?us-ascii?Q?oxfNHC5d5yyA2L9TC48HL5bF1Qk6eJuRYI0XKDkIWWsEuDzI4T13VUEtPgZb?=
 =?us-ascii?Q?TTVR8IO0fFOcadMpLBVEz8cK+7jB1JPLMrK6WFxtShTz7kRbxm1kFMYSoPjv?=
 =?us-ascii?Q?f6xYb1XAHPb9qaeOdl3rCYUIUPxA4Oud0eWcqVYWYKQTF4uKC5puf3mMAuuq?=
 =?us-ascii?Q?PXMPTGzjt8O9EpaoAFIAbYJoJcweATQKpQJDeGAby+fLqA9BGGZpFwIogWIq?=
 =?us-ascii?Q?55u+LzcOhml3ri5lPDH/5BzsVEpY7oW25DV1rNdyERVQFCcg0x/3tPCoyyCB?=
 =?us-ascii?Q?7qupwQ97ObyfqLZhnFiYg9jI0jRC2toJCVFtPS9yUxJTO55VSRIKIR2+H41I?=
 =?us-ascii?Q?2v3Bgf8aAtv3U9ei4J46dHmwgqy2xzPRA2AAnACjo6a28o+pSyEjFf4Wtv8v?=
 =?us-ascii?Q?tgY1xfZ9EyEaAtTLMyMlJ1Jo6qIOCxosBt0tzPSK531BNrQj5UV656KiLbLB?=
 =?us-ascii?Q?9fquTVZ+t7p3vg+OHoSZninNFL3T/KoraOeBICVkAtajHRoP8cZi3w8FJ2Vo?=
 =?us-ascii?Q?JBPo9xSoDNXjeLqmkaFqZ1rQLmtDAhpBXj8GQm1u?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3de647c2-5479-4f11-642e-08da708ecbe1
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2022 11:46:23.5496
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2Q6ky1MuaboFqVMYm/qPopFRyZbW2MmrQ07NbM2z3fKNHDSJsOXPNG74U7dDKZEPZrWfrEtwPLQ+RHIc6IK6Ww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4505
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add IPv4 and IPv6 test cases that ensure that we are not leaking a
reference on the nexthop device when we are unable to delete its
associated route.

Without the fix in a previous patch ("netdevsim: fib: Fix reference
count leak on route deletion failure") both test cases get stuck,
waiting for the reference to be released from the dummy device [1][2].

[1]
unregister_netdevice: waiting for dummy1 to become free. Usage count = 5
leaked reference.
 fib_check_nh+0x275/0x620
 fib_create_info+0x237c/0x4d30
 fib_table_insert+0x1dd/0x1d20
 inet_rtm_newroute+0x11b/0x200
 rtnetlink_rcv_msg+0x43b/0xd20
 netlink_rcv_skb+0x15e/0x430
 netlink_unicast+0x53b/0x800
 netlink_sendmsg+0x945/0xe40
 ____sys_sendmsg+0x747/0x960
 ___sys_sendmsg+0x11d/0x190
 __sys_sendmsg+0x118/0x1e0
 do_syscall_64+0x34/0x80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

[2]
unregister_netdevice: waiting for dummy1 to become free. Usage count = 5
leaked reference.
 fib6_nh_init+0xc46/0x1ca0
 ip6_route_info_create+0x1167/0x19a0
 ip6_route_add+0x27/0x150
 inet6_rtm_newroute+0x161/0x170
 rtnetlink_rcv_msg+0x43b/0xd20
 netlink_rcv_skb+0x15e/0x430
 netlink_unicast+0x53b/0x800
 netlink_sendmsg+0x945/0xe40
 ____sys_sendmsg+0x747/0x960
 ___sys_sendmsg+0x11d/0x190
 __sys_sendmsg+0x118/0x1e0
 do_syscall_64+0x34/0x80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Amit Cohen <amcohen@nvidia.com>
---
 .../selftests/drivers/net/netdevsim/fib.sh    | 45 +++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/netdevsim/fib.sh b/tools/testing/selftests/drivers/net/netdevsim/fib.sh
index fc794cd30389..6800de816e8b 100755
--- a/tools/testing/selftests/drivers/net/netdevsim/fib.sh
+++ b/tools/testing/selftests/drivers/net/netdevsim/fib.sh
@@ -16,6 +16,7 @@ ALL_TESTS="
 	ipv4_replay
 	ipv4_flush
 	ipv4_error_path
+	ipv4_delete_fail
 	ipv6_add
 	ipv6_metric
 	ipv6_append_single
@@ -29,11 +30,13 @@ ALL_TESTS="
 	ipv6_replay_single
 	ipv6_replay_multipath
 	ipv6_error_path
+	ipv6_delete_fail
 "
 NETDEVSIM_PATH=/sys/bus/netdevsim/
 DEV_ADDR=1337
 DEV=netdevsim${DEV_ADDR}
 SYSFS_NET_DIR=/sys/bus/netdevsim/devices/$DEV/net/
+DEBUGFS_DIR=/sys/kernel/debug/netdevsim/$DEV/
 NUM_NETIFS=0
 source $lib_dir/lib.sh
 source $lib_dir/fib_offload_lib.sh
@@ -157,6 +160,27 @@ ipv4_error_path()
 	ipv4_error_path_replay
 }
 
+ipv4_delete_fail()
+{
+	RET=0
+
+	echo "y" > $DEBUGFS_DIR/fib/fail_route_delete
+
+	ip -n testns1 link add name dummy1 type dummy
+	ip -n testns1 link set dev dummy1 up
+
+	ip -n testns1 route add 192.0.2.0/24 dev dummy1
+	ip -n testns1 route del 192.0.2.0/24 dev dummy1 &> /dev/null
+
+	# We should not be able to delete the netdev if we are leaking a
+	# reference.
+	ip -n testns1 link del dev dummy1
+
+	log_test "IPv4 route delete failure"
+
+	echo "n" > $DEBUGFS_DIR/fib/fail_route_delete
+}
+
 ipv6_add()
 {
 	fib_ipv6_add_test "testns1"
@@ -304,6 +328,27 @@ ipv6_error_path()
 	ipv6_error_path_replay
 }
 
+ipv6_delete_fail()
+{
+	RET=0
+
+	echo "y" > $DEBUGFS_DIR/fib/fail_route_delete
+
+	ip -n testns1 link add name dummy1 type dummy
+	ip -n testns1 link set dev dummy1 up
+
+	ip -n testns1 route add 2001:db8:1::/64 dev dummy1
+	ip -n testns1 route del 2001:db8:1::/64 dev dummy1 &> /dev/null
+
+	# We should not be able to delete the netdev if we are leaking a
+	# reference.
+	ip -n testns1 link del dev dummy1
+
+	log_test "IPv6 route delete failure"
+
+	echo "n" > $DEBUGFS_DIR/fib/fail_route_delete
+}
+
 fib_notify_on_flag_change_set()
 {
 	local notify=$1; shift
-- 
2.36.1

