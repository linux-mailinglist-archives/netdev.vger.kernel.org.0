Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2F4F51EC29
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 10:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231163AbiEHINv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 04:13:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231145AbiEHINq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 04:13:46 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2052.outbound.protection.outlook.com [40.107.244.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42A02E0C1
        for <netdev@vger.kernel.org>; Sun,  8 May 2022 01:09:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cDZ8vwkVcPpnw98rp8ZpbR3WcV6+vLe/Euu0Xeey8+INJG334mE6SzetMTqSmTyn3gdvGuG72ohDNNRKG+82QbI+/0+oBZyrM+t/fbbSJzw3j39gXJwljBDkxOUV7aHHQNv+0Eh6D3kzkP8XhzJQSiMFWAvkqvwVZowgL6sLSahnQq3UNPKDkirIqRoK4vBJZvA1Cbdiop09HZd6WidfBkroqAUuCaEbwJ8lNqHqdiVcNBtloI6AxFLX3V8xkS49bnNABJUn5olXIJXF+npUKczsEtiJBa4sWRaUWdkSrHh1vOCWYla+swfmJc81VbJ0mXln6DSKVz/nTUQ8p4N0AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h01OWDnkZ487yE9hntlZnhLz3uKucu73jQsQC6SYsEg=;
 b=kcnwcZ7cgEMoF+np4ObKv9oAxhgr+gsnxxOPWHzX3lE0pRXvCoVBc8xPqgAuf3nxo86wn65Juual/01OUy3d92dv3iQMAIUWy5jyi2GOqnVeKILqDXFSw3NGtwMpl55Yv617JkcPaoUxf76uMAwMb31AMUS/vpOoowj3YknDEw0S+HwBuM7Z/3LbOW1MRbsq4j5c9qTsIuEi7YakjiPp/lmlW25RazqUmuYl629LbherPASub5cDx7yRgeXjnTfGRgDacVPALZDg76kqc6yM4OOgkUcB5gx0QcRzJyPHlGHStIhPC097UYjoIxkEQlwd0k/BlbECQpEp49W61XQG7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h01OWDnkZ487yE9hntlZnhLz3uKucu73jQsQC6SYsEg=;
 b=qyGQnEalNQLYi5zL1qfT/w6UezLsqFeefgR252d/OpRp7BD6kfvYNBPl62a776Y8lqMhrajggjoqDjj9uRvMLy8nplDAuTIPKXwbFsa7tby7M6WDjjrxQLMB4MxWrjT+P7nHZAr1GNjvDb8ya1RCH343z3be7k/7FuxSHWNNieBvrh2wQ7bZ8n5f5isEOU6H2fh/yZxkcarQZ7nkQgPkPX1zM6/HcABQgVIQKrB7i5KbergRQ4HaFOa+Yxrsho/apU3VIdBB2nK6RBlqqig2jJZoKXg4XgoAKHq38eLH8KDCpI6GLIFxcUIl5s2nRUB5I92oYduZ4QTGAzQ2kYLYog==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by DS7PR12MB6096.namprd12.prod.outlook.com (2603:10b6:8:9b::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5227.22; Sun, 8 May 2022 08:09:55 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::45b7:af36:457d:7331]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::45b7:af36:457d:7331%7]) with mapi id 15.20.5227.023; Sun, 8 May 2022
 08:09:55 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 10/10] selftests: forwarding: Add a tunnel-based test for L3 HW stats
Date:   Sun,  8 May 2022 11:08:23 +0300
Message-Id: <20220508080823.32154-11-idosch@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220508080823.32154-1-idosch@nvidia.com>
References: <20220508080823.32154-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MRXP264CA0027.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:14::15) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ce8d48d0-67e9-4959-9eb0-08da30ca22b9
X-MS-TrafficTypeDiagnostic: DS7PR12MB6096:EE_
X-Microsoft-Antispam-PRVS: <DS7PR12MB6096EBEAC3E139356CE3CA8CB2C79@DS7PR12MB6096.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MHPnUQYtAGn68TGhL0uMI1KtKLmlJhgsZ0tcNfwW/Pz9Uua9DETD/HPZ90wG2IiK5DvSaB/eCz1KhLMS3crXqEimmtZ1xhiuDeHp2R9POdfGDu60xOSQzN9hVPYug2Lz1GMzapk3b2LkbXMDws1I3s8va5bSW+k1Fiw5JJuHeT/+AHG5jpTCuV35ObrKhofQqBVgFgzx9HjxPKSVgzANHOn0KsBJZtETEfz/gwacHtYG+42v6MrRWpEZvBXslpAkC8xF0ZtgkO0BHADZYp7QoIXbGP4nwZIb16eIXjTTkrO5zkhp7NYTxe13DYFZvsjWJN6iVjd7+L61CpFA6JbVlUhuAW63zLFKtd1eU0KStKFX7X5CKzDkO/F2wKgt5qQDLm95FIxGUnF+QU1iARn5BmCpdA6RjjP7srFTSZQFVNaMq9NvdK7XDeAGqKdZLBadKplaQVlRCF2msoIV3edvqSlkcpf6H+jExRgbGw5wcu5LR8fmiOaLerU+r+gaIi4hWhZflEO6GnLsXM5EwJy2ryQz+2Sl226WhnctdZbi1rRPA/mmy+1Kh/mCwSVhdlZdbmiPz9X8XP9efxtbDRVMt8rPBZFcb77C09kDS0bu0vtuh+cC1eSdD+7CRDKPjHL1fv+1qxD3Xdfv9JNUSLhBDV9tSfoFYPFLVsZhx57LyMR3VDioIV5tHmc0mvZhT/On5W+Iwa3YLBNf5h1WRcdkTw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(1076003)(6916009)(2616005)(36756003)(316002)(6666004)(83380400001)(186003)(107886003)(8936002)(86362001)(4326008)(26005)(66476007)(66556008)(6512007)(8676002)(66946007)(38100700002)(508600001)(2906002)(6486002)(5660300002)(6506007)(473944003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1eDLcKG32pF0Fur3aO/98kz4XE27F4jbMUhCVMjXZrqJgpeWCLtYz8A/hx9h?=
 =?us-ascii?Q?+wO2R332XbCNRgfGJ1N5WEMUrTor/x+naiEI41acouw13QWSZVWyZB/N9kNy?=
 =?us-ascii?Q?lhPLUVD2mwDp98Vo7z5+RnzCZND6O7PHTCB8ZRoKmPw4o/kMrOhipk9ln4PH?=
 =?us-ascii?Q?u1jMXUOf6JYvuq2ecuehomAuZbLsRLoVkGOawyIkn4qfyv4HYG82nAFBUhOj?=
 =?us-ascii?Q?0+JiyZGUulC6qwnQ7mNVLtSbtbwi7+qwI6PqO36aJ68RzoNKjfCqqfXfH/Ga?=
 =?us-ascii?Q?UwUzmjoXtAPAKJjos8mxKaSNktAo2PPL9BPWlVvGs52cPwod8SDeNEOW0E4v?=
 =?us-ascii?Q?79ppS8QPaCjO4uZwsYUpuJ5CxBHFjdbTHglVXCMHNzY5taB9ojHDFDrcjP3n?=
 =?us-ascii?Q?2HItgs7RrRELzTpVKGgyZ4lYbFujlJBNYcTqBsg2KajaDQADLkn+1P2fvIAQ?=
 =?us-ascii?Q?YW5rGOfktcGE+dE0hY/VvtBAsXxMCNYgCaAkeg7bBtJLQ9nKXkGYUPJhvRjz?=
 =?us-ascii?Q?7L4YD/FplnMEEftUkH2ifTyn999KVhFCl7ssW4DnsmPBGSiHet2s/b6Anl5U?=
 =?us-ascii?Q?OftqaF6xCbK/5NlY16oA6wi/SeI4qsD5/EG6JZB/whMIB5Ba1ejb+Y4FIk8W?=
 =?us-ascii?Q?+cZber7a77yGUGksHxmsx9c+44abLM+0EqxTIkQAmxxBLr/mxSV3ZpoWZFAU?=
 =?us-ascii?Q?VBkh24BIGPwy2umLdehVxzqkfk+wsxhlgvinnSGGF5Vmsz8jbNKm2iK9JBRY?=
 =?us-ascii?Q?WlBUMAXiNi6hZl4ev6SL8LLaUAY7ya5TYWChsX+m9g1rMc0eYxd5X/QyY43v?=
 =?us-ascii?Q?AiCpPIx9PmRCqmCGN76nAI6dVC1j0NfCg/aUxJRQneif4Te19HpQClkINUMF?=
 =?us-ascii?Q?Z1Nc5NVHfvTIu6L7+ZAYDxPUAGHu5bjxNX48ueodserQE+W8U80bOsaR7Sjk?=
 =?us-ascii?Q?rjKjg4ru79wCXZkdyiWU9lSoASOJed197vaiEVloHw1UEP0AT26EBYtNZ6xg?=
 =?us-ascii?Q?GqfcwA4TEu9XSuHV6pJLe8VPRscEWE8G4pCSi5wms62/RhtNg5Ee5R5CCq4m?=
 =?us-ascii?Q?ofhgt8+H1X2P7IlTvHr03MmlSaciug7PlOzq7vb/PLwWqOD1OUox0tNJHpUb?=
 =?us-ascii?Q?CzXEDqCr6H64VtVSvEIFPF8gnYypqNxgvNDHXxk85PjbDvoXujvue0KxRO8K?=
 =?us-ascii?Q?dY2V3REDprtIFVL0XZQ1JsQU76bZzF1vwbtIV0sBlSItM9cmDxWrGLACnsaP?=
 =?us-ascii?Q?TIZj202/UZavc/VxXurEl30stmudZJB5wqh8Eiciteqw7I4+bFjvB7L3c0ZR?=
 =?us-ascii?Q?xKDAlvBJl6KCQRDPewcDtnPmdfKRYG6pq+8GJABUEI5xx5drNLSEvQ3WLMRK?=
 =?us-ascii?Q?c9yguyLZcyt3dX2prwLcqr9yi6T3uWJDZx6QJqRinUTOuLRW3rmGOkmrp0cQ?=
 =?us-ascii?Q?i/j8jAoJXkP8HL4N7eN48IF6ikEIXG/qa0sZk3+9tq7hPoOMKSWk2/6g0eUY?=
 =?us-ascii?Q?fhNdsGH5kPvX6wcQwELxNpo26qL5o1Ace+JYCqwm5XDtVIZf8WZn7ckAGLb7?=
 =?us-ascii?Q?0aQCu4O9iATaKSJ2WBfw+LxkllHzw3bUtPR4YUAoUhusqKjs2peeqrRvHHD4?=
 =?us-ascii?Q?qSiUSpQBCWqzlDl5FT0hNzI6ms18IiHYYqSISkTfR0Xhi4aMIkhtQ3tVU1Tl?=
 =?us-ascii?Q?cV4N3Qe3cgRXnfNxfvBTMe6fDRbg4jYaZ+JcYjbvRTiz2r70VATBpTEbvrxW?=
 =?us-ascii?Q?TUWf2mjyuA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce8d48d0-67e9-4959-9eb0-08da30ca22b9
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 08:09:55.1400
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nqH/RxtoZP9aZ9qkcoNhAeVYrrS9cpgGEQE5iiVA/KzUk4HKqPM+rFgHjruQBqmcjSCyomng4iTFnoxzUBCDQw==
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

Add a selftest that uses an IPIP topology and tests that L3 HW stats
reflect the traffic in the tunnel.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../testing/selftests/net/forwarding/Makefile |   1 +
 .../net/forwarding/hw_stats_l3_gre.sh         | 109 ++++++++++++++++++
 2 files changed, 110 insertions(+)
 create mode 100755 tools/testing/selftests/net/forwarding/hw_stats_l3_gre.sh

diff --git a/tools/testing/selftests/net/forwarding/Makefile b/tools/testing/selftests/net/forwarding/Makefile
index 0912f5ae7f6b..b5181b5a8e29 100644
--- a/tools/testing/selftests/net/forwarding/Makefile
+++ b/tools/testing/selftests/net/forwarding/Makefile
@@ -20,6 +20,7 @@ TEST_PROGS = bridge_igmp.sh \
 	gre_multipath_nh.sh \
 	gre_multipath.sh \
 	hw_stats_l3.sh \
+	hw_stats_l3_gre.sh \
 	ip6_forward_instats_vrf.sh \
 	ip6gre_custom_multipath_hash.sh \
 	ip6gre_flat_key.sh \
diff --git a/tools/testing/selftests/net/forwarding/hw_stats_l3_gre.sh b/tools/testing/selftests/net/forwarding/hw_stats_l3_gre.sh
new file mode 100755
index 000000000000..eb9ec4a68f84
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/hw_stats_l3_gre.sh
@@ -0,0 +1,109 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+# Test L3 stats on IP-in-IP GRE tunnel without key.
+
+# This test uses flat topology for IP tunneling tests. See ipip_lib.sh for more
+# details.
+
+ALL_TESTS="
+	ping_ipv4
+	test_stats_rx
+	test_stats_tx
+"
+NUM_NETIFS=6
+source lib.sh
+source ipip_lib.sh
+
+setup_prepare()
+{
+	h1=${NETIFS[p1]}
+	ol1=${NETIFS[p2]}
+
+	ul1=${NETIFS[p3]}
+	ul2=${NETIFS[p4]}
+
+	ol2=${NETIFS[p5]}
+	h2=${NETIFS[p6]}
+
+	ol1mac=$(mac_get $ol1)
+
+	forwarding_enable
+	vrf_prepare
+	h1_create
+	h2_create
+	sw1_flat_create gre $ol1 $ul1
+	sw2_flat_create gre $ol2 $ul2
+	ip stats set dev g1a l3_stats on
+	ip stats set dev g2a l3_stats on
+}
+
+cleanup()
+{
+	pre_cleanup
+
+	ip stats set dev g1a l3_stats off
+	ip stats set dev g2a l3_stats off
+
+	sw2_flat_destroy $ol2 $ul2
+	sw1_flat_destroy $ol1 $ul1
+	h2_destroy
+	h1_destroy
+
+	vrf_cleanup
+	forwarding_restore
+}
+
+ping_ipv4()
+{
+	RET=0
+
+	ping_test $h1 192.0.2.18 " gre flat"
+}
+
+send_packets_ipv4()
+{
+	# Send 21 packets instead of 20, because the first one might trap and go
+	# through the SW datapath, which might not bump the HW counter.
+	$MZ $h1 -c 21 -d 20msec -p 100 \
+	    -a own -b $ol1mac -A 192.0.2.1 -B 192.0.2.18 \
+	    -q -t udp sp=54321,dp=12345
+}
+
+test_stats()
+{
+	local dev=$1; shift
+	local dir=$1; shift
+
+	local a
+	local b
+
+	RET=0
+
+	a=$(hw_stats_get l3_stats $dev $dir packets)
+	send_packets_ipv4
+	b=$(busywait "$TC_HIT_TIMEOUT" until_counter_is ">= $a + 20" \
+		     hw_stats_get l3_stats $dev $dir packets)
+	check_err $? "Traffic not reflected in the counter: $a -> $b"
+
+	log_test "Test $dir packets: $prot"
+}
+
+test_stats_tx()
+{
+	test_stats g1a tx
+}
+
+test_stats_rx()
+{
+	test_stats g2a rx
+}
+
+trap cleanup EXIT
+
+setup_prepare
+setup_wait
+
+tests_run
+
+exit $EXIT_STATUS
-- 
2.35.1

