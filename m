Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AA975B827B
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 09:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbiINH4O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 03:56:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230292AbiINHzo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 03:55:44 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AEBBDD2
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 00:55:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UhkysBiDxyezvT/LDkYl1bV7HVPM7gleonG8Vi0fDUnKw+Riipxn27680pP0J45SaIWiv3xEe0kIM6RiWqC7Aq/IB67J0SGFF98/lHHbpHyZasiytpHKySBNe3kTfs+OjWUgFRV0jxhbNbEUxfCqjvfvtsmzP1tJk7EU51R91EYQLsFlrQX896AgYV6HzGIZJ+FwFJmMNJwL8S1oqZ1SLeR8LrnWq1HRh9QwQpUpsJf8jWz2VlvqRi4DayqOTL/NzoDd8Ldos3e1XWng3KQSM6+QYhNjDBgQ8lOLwQTF9nJD7s5xRar2SgowoBgZ9ReR3RKi1rWb4zf8c96acp/00A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HzUT/sSq3oG5RNb0HWdXfyLA1MrU6lhPCH8n3EyG8GI=;
 b=k+gwVdiykQPTyPr4p9E27OaFQLEYwdqHp3T53Lhw3GUi+I1mW1BCQwEfwysDIu8RtcLCxCF9nvuGnbeEettuil0W3CZb7lf5VLoYLLVJ06TDllrVC5dpXOrTVUq587HFLmrKrv9j6pBqNDwzudvZDUveZAWbg8c8pTM4ET7AVYwCFqKzqwn1fRN0n3Tm6KERDTxcomjG+lXVHUuisDgF/HKFxqKbcYD4fYfFtgjk7CJRWO+NlDUuGJL3utEdcqnfRYLPdGYOizVbmQM4ads8qnZO/seMFqsSMk6baMlID4gTsWsohtMwIgLHDfwZDN69p/nQBhjMAC81PP+gwwkcEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HzUT/sSq3oG5RNb0HWdXfyLA1MrU6lhPCH8n3EyG8GI=;
 b=IKsw2ZN8sjITePn83JbT6QccCEeX28ZZC9eWqt5wfgewuZhafn2qnBVnFOsF10ljz/6WnPA+8M8J9UIyv6/AAip/jZ1Bz8XbtNBnxMDIN07NWPz8vgiNPkRIxU4D99eBdtOFQwHvG+qF5FqZCUbYhESH9lt70p6ASMfSQAECUySj84Ow0YvEd63oU47DlkzqquLhPlbGnDU+V4cUkZlroJIevcZIUNb5xe1532deju51eGpGCgQvwCilwmVcx5fJyzueYk4x5+HnR6QBcWY3ZvTFGa8hYjvfrSdh/i8qmo9qnadk8sIcB5n5u+6iJMuzdbwVvxPNc7hISEt86FBiIQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SJ0PR12MB5454.namprd12.prod.outlook.com (2603:10b6:a03:304::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Wed, 14 Sep
 2022 07:55:04 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::18a5:7a35:3bb2:929b]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::18a5:7a35:3bb2:929b%3]) with mapi id 15.20.5612.022; Wed, 14 Sep 2022
 07:55:04 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net 2/2] selftests: forwarding: Add test cases for unresolved multicast routes
Date:   Wed, 14 Sep 2022 10:53:39 +0300
Message-Id: <20220914075339.4074096-3-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220914075339.4074096-1-idosch@nvidia.com>
References: <20220914075339.4074096-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR04CA0132.eurprd04.prod.outlook.com
 (2603:10a6:803:f0::30) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|SJ0PR12MB5454:EE_
X-MS-Office365-Filtering-Correlation-Id: 85125362-ac4f-4990-2141-08da96266eff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hzkZn2DkxJBfl4EV7H2jdQDsmSEwH5Ondr61U7KOh+eEOt8L3RNQiQ1hbWsw23y7gsYqxqed3YhiQLjJoiA2SDPtCzu7cj4T2RwntBOFpuWJNgby2CptxpZTfHTx2wzAK06uqhpREnWt2X5zAbxKovQVh2BsxMmwlYSS5A5iIev4vl5H0pUUi5XvuOAjmn1KwVVHAmFUna41PyYK+HkYsAK/cYCCYHs8cSl8Njrq/q/fNYJ9HNlGMOPe6C6ZjzpGe8CZjNsEH4iFE4oX2im4nLsgcRZg6RF+3ZFCrrFFSxvyEOXG224IocrfudQT9dggfQEla6QjE7YQp6+39yn2S8OkJkc7dyYKrLymbbOiWk2tNgklip1z2UC2jxWeY/C61U2Y2oIXT/k/PROHIKZw88LVnEsB8zZ9WZ3OFh8FZUcjLTNKBPxFedjF+IUXJdxx6gwtKjVXnTIT46uEHKpcQyKtzRibXiiaKMT6jakJz+VgmhCVL2/fXEDfrjfcRWa2BwjYUdUSzSfVZRcjY/Ip+ZxFdCBnt7j2cO2NX1bR6ep+qDIHgIDmYCvSgtIe+gZbAOE9RLVP7d3ZHhFgCKFD5H2qGsD7F77YrFrZAOqD/OHtznjOF+lBKa0a+FR6CZjKp7xKYW2BFV6QZvcxjTfyazU+M/UdUBZfnQkB8PAoEdkYcxH6lhM9StEejUF9kq/7SKDU1EsFvYBNFxGHmYvDcA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(366004)(39860400002)(136003)(346002)(376002)(451199015)(36756003)(86362001)(38100700002)(6666004)(41300700001)(107886003)(66946007)(66476007)(8936002)(4326008)(8676002)(66556008)(26005)(5660300002)(6506007)(6486002)(478600001)(6916009)(83380400001)(66574015)(2906002)(316002)(2616005)(6512007)(1076003)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ciilnHmTlVT8KuvqOjCTqVycluAlmrF2tCLG/p+0POllKZKbGzqZx+qv+DKV?=
 =?us-ascii?Q?tpB/BWc2+gUZbnylRm5mDcz8YZFSTkr1NmGoeqoljf1VR5chqyHReFCdbWdB?=
 =?us-ascii?Q?0wLerbX8FsDP+58z9uvuK+PnF1bGaxN6dFLEAdFG9sCo/Tu506N1xA9OGu1b?=
 =?us-ascii?Q?wMYTbB3vz+azpObxvIjNUlI4JSA+siJYUc7YLc5e2ec2yzL+h9Ts6MrChoOq?=
 =?us-ascii?Q?BOqRZ1pMOdNDQ7pJZrwn9VRC5wtK9RakRrgPztpHMGqN/eGd1S1CtPux4/Le?=
 =?us-ascii?Q?W4Ev1oqaSosm1FiZ6POjbxWuPf4VrGguR+aCMn8rzDPLBKgShd8qIVZmTnJa?=
 =?us-ascii?Q?3YHZ31iuZsgkuOwOk91Joq96a8z6q/2tqpzwBHHokeoAU1tADQZM9eRMOGK3?=
 =?us-ascii?Q?r3NjLmRwbbG0PHUhJ3uJHag+nkxuogC3fBj6D51doThNIEHZARE0Rjw497OR?=
 =?us-ascii?Q?LTREI+w4cxBzSeodd0vaOHM1mfTVKTqnu8JPI0PqPFyRc5SqmiNGIUhWA7L3?=
 =?us-ascii?Q?/aCpoomiM6P1WNTs7v3qoAfmpOj8I/+90ty3OR24i/hp45EtWci8CbkUBeNZ?=
 =?us-ascii?Q?M0lFmtzLg5mrGFhzSFp5ushdPOq6kmvJ8wlja+SredcPaAZFJ3vbPLzyJ6+h?=
 =?us-ascii?Q?SDueKuQAn6slAC3qD3MZEQPLl4hJczrtVELaFLeLJG49EYA1nYgpBCYCUEJA?=
 =?us-ascii?Q?XCjRQVreZMIEEGF6Pk0/ysExFdRnwk+j4hHIKPIk8UwB/8nkZFp7rOayEWBv?=
 =?us-ascii?Q?sK2aD1MUVj0sue9knpULJQwbopmVkF87QWE20i7g6bTQ3+hMA/HkvwUkqDaC?=
 =?us-ascii?Q?qBw5SuKxqUHuBnbISXdC6lcEphZeTHtSTzyL8pQQ9L/CKVsfWp/ZFNS6Qnb+?=
 =?us-ascii?Q?iKpIVuiq+x31SKLpoKck1qadZbkmAN5F1xUDZ/SSmM/xLEyipdYYqI+441ma?=
 =?us-ascii?Q?7teiRBvWaO/aH7aSxu4O/oMQ4iavqzSXm+gYsaNQhJ8WyQMeGHxuIZkcG5eJ?=
 =?us-ascii?Q?mzI3+EorFL3AvcD5I28E2ouXFhDq0WDIvaXGgOKL256Cct3pTqNarCe9XKYa?=
 =?us-ascii?Q?sZwdBuH1QZf/qw4blPkgzsPM1JXiWBwnDzwVFL6mYfe8kXI7NMHVWp3AdjvF?=
 =?us-ascii?Q?RIV9QdQ2xRhCg7XOjED6L4YBPUm8618jCJDrGyO6cVf/i31+MB9xIw+aG5PP?=
 =?us-ascii?Q?4oR5YMJHShAkZwBWXYLhloNt8KXSuQE00gVlWfM4h7OztYujljYCxgSLJmKH?=
 =?us-ascii?Q?s7cG9fERMJF0CAp1WQptEbfvsXr/ZVOlesULlb6eNjfutuDt0JOT1Mes6GH3?=
 =?us-ascii?Q?pL7j1hsS3hbtySN/3nGngMJGz4MRpslWib7QQROMlu33VeAW9ZadZUAw0maq?=
 =?us-ascii?Q?WT/2FYQXd2GS1vqey0Axq0v/3XvA7ADjqsHQ0DnGC6PbwRBMToVokNJjIPa8?=
 =?us-ascii?Q?c0Qcc9UHDdCgE9MB9wnFAwsABTRMUK7gbgcoqQe1wQttGH+pFG8PsF9/VGBs?=
 =?us-ascii?Q?vOldFrADQzqYe3d+NrFbIqxdHJK90Xtaw6VX/XVyGiqxCpX0gIPNClO8zdjd?=
 =?us-ascii?Q?XYNO87CUl8wjEaG+R2GnGgvonX/f7vSnTf+rTKLN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85125362-ac4f-4990-2141-08da96266eff
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2022 07:55:04.2265
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UyurQ3ybFUJ65GyrUrR6EIt9N2dwVDDsHQgnwafRA9Mr05N1q0Y8C0kayL6bL3wONdO1J6yNfhkDVqU/bNb9Ag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5454
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        LOTS_OF_MONEY,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add IPv4 and IPv6 test cases for unresolved multicast routes, testing
that queued packets are forwarded after installing a matching (S, G)
route.

The test cases can be used to reproduce the bugs fixed in "ipmr: Always
call ip{,6}_mr_forward() from RCU read-side critical section".

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/forwarding/router_multicast.sh        | 92 ++++++++++++++++++-
 1 file changed, 91 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/forwarding/router_multicast.sh b/tools/testing/selftests/net/forwarding/router_multicast.sh
index 57e90c873a2c..5a58b1ec8aef 100755
--- a/tools/testing/selftests/net/forwarding/router_multicast.sh
+++ b/tools/testing/selftests/net/forwarding/router_multicast.sh
@@ -28,7 +28,7 @@
 # +------------------+       +------------------+
 #
 
-ALL_TESTS="mcast_v4 mcast_v6 rpf_v4 rpf_v6"
+ALL_TESTS="mcast_v4 mcast_v6 rpf_v4 rpf_v6 unres_v4 unres_v6"
 NUM_NETIFS=6
 source lib.sh
 source tc_common.sh
@@ -406,6 +406,96 @@ rpf_v6()
 	log_test "RPF IPv6"
 }
 
+unres_v4()
+{
+	# Send a multicast packet not corresponding to an installed route,
+	# causing the kernel to queue the packet for resolution and emit an
+	# IGMPMSG_NOCACHE notification. smcrouted will react to this
+	# notification by consulting its (*, G) list and installing an (S, G)
+	# route, which will be used to forward the queued packet.
+
+	RET=0
+
+	tc filter add dev $h2 ingress protocol ip pref 1 handle 1 flower \
+		dst_ip 225.1.2.3 ip_proto udp dst_port 12345 action drop
+	tc filter add dev $h3 ingress protocol ip pref 1 handle 1 flower \
+		dst_ip 225.1.2.3 ip_proto udp dst_port 12345 action drop
+
+	# Forwarding should fail before installing a matching (*, G).
+	$MZ $h1 -c 1 -p 128 -t udp "ttl=10,sp=54321,dp=12345" \
+		-a 00:11:22:33:44:55 -b 01:00:5e:01:02:03 \
+		-A 198.51.100.2 -B 225.1.2.3 -q
+
+	tc_check_packets "dev $h2 ingress" 1 0
+	check_err $? "Multicast received on first host when should not"
+	tc_check_packets "dev $h3 ingress" 1 0
+	check_err $? "Multicast received on second host when should not"
+
+	# Create (*, G). Will not be installed in the kernel.
+	create_mcast_sg $rp1 0.0.0.0 225.1.2.3 $rp2 $rp3
+
+	$MZ $h1 -c 1 -p 128 -t udp "ttl=10,sp=54321,dp=12345" \
+		-a 00:11:22:33:44:55 -b 01:00:5e:01:02:03 \
+		-A 198.51.100.2 -B 225.1.2.3 -q
+
+	tc_check_packets "dev $h2 ingress" 1 1
+	check_err $? "Multicast not received on first host"
+	tc_check_packets "dev $h3 ingress" 1 1
+	check_err $? "Multicast not received on second host"
+
+	delete_mcast_sg $rp1 0.0.0.0 225.1.2.3 $rp2 $rp3
+
+	tc filter del dev $h3 ingress protocol ip pref 1 handle 1 flower
+	tc filter del dev $h2 ingress protocol ip pref 1 handle 1 flower
+
+	log_test "Unresolved queue IPv4"
+}
+
+unres_v6()
+{
+	# Send a multicast packet not corresponding to an installed route,
+	# causing the kernel to queue the packet for resolution and emit an
+	# MRT6MSG_NOCACHE notification. smcrouted will react to this
+	# notification by consulting its (*, G) list and installing an (S, G)
+	# route, which will be used to forward the queued packet.
+
+	RET=0
+
+	tc filter add dev $h2 ingress protocol ipv6 pref 1 handle 1 flower \
+		dst_ip ff0e::3 ip_proto udp dst_port 12345 action drop
+	tc filter add dev $h3 ingress protocol ipv6 pref 1 handle 1 flower \
+		dst_ip ff0e::3 ip_proto udp dst_port 12345 action drop
+
+	# Forwarding should fail before installing a matching (*, G).
+	$MZ $h1 -6 -c 1 -p 128 -t udp "ttl=10,sp=54321,dp=12345" \
+		-a 00:11:22:33:44:55 -b 33:33:00:00:00:03 \
+		-A 2001:db8:1::2 -B ff0e::3 -q
+
+	tc_check_packets "dev $h2 ingress" 1 0
+	check_err $? "Multicast received on first host when should not"
+	tc_check_packets "dev $h3 ingress" 1 0
+	check_err $? "Multicast received on second host when should not"
+
+	# Create (*, G). Will not be installed in the kernel.
+	create_mcast_sg $rp1 :: ff0e::3 $rp2 $rp3
+
+	$MZ $h1 -6 -c 1 -p 128 -t udp "ttl=10,sp=54321,dp=12345" \
+		-a 00:11:22:33:44:55 -b 33:33:00:00:00:03 \
+		-A 2001:db8:1::2 -B ff0e::3 -q
+
+	tc_check_packets "dev $h2 ingress" 1 1
+	check_err $? "Multicast not received on first host"
+	tc_check_packets "dev $h3 ingress" 1 1
+	check_err $? "Multicast not received on second host"
+
+	delete_mcast_sg $rp1 :: ff0e::3 $rp2 $rp3
+
+	tc filter del dev $h3 ingress protocol ipv6 pref 1 handle 1 flower
+	tc filter del dev $h2 ingress protocol ipv6 pref 1 handle 1 flower
+
+	log_test "Unresolved queue IPv6"
+}
+
 trap cleanup EXIT
 
 setup_prepare
-- 
2.37.1

