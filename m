Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54826641B63
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 08:53:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbiLDHxY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 02:53:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229931AbiLDHxT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 02:53:19 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2046.outbound.protection.outlook.com [40.107.223.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DA8917430
        for <netdev@vger.kernel.org>; Sat,  3 Dec 2022 23:53:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T2MokdnXivwXE7mXEN/ZsOw+H1PQX9cXZJjtXOLignoypKlxTLV0sVuk9/pVYE4cHEq/4mbQhx7qRCYcwDiH4fiau9UC4MBBLXvOuuOXnx6TlP8TLA6K+SqGWlBgd3+QsD5GDLZtTQSyALgjsoY2UCh6iV//MkfSrOc5QNQ3SfXBOsL0HXnc9whXqK3FJvsjVr3QBuq0N9EPhrKvlj6dJlo8HSXbyTAXETQUo9GfJvnMjoODPMaFFBMy5Iw6Q8VZikZeRSZIUK9ERMSbmyotly3b0Y4jO3i55N2CtwQOqXTp/RhGS+3wmp0WCnlSKg6QZPjgKF/wkBj8YCDL+x8Idg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0maP4dJyeFVgSiZtIlp8f5s30Rfb8aULew5u/e5LqfI=;
 b=C+JQoGURwHhr0b87dyUYAiaGW3W/pcU2AWdYUyD/JMeFteO7GItxrouqUJ8NDo6AZVnACRf034AXVVqf9a7LkReqhaI9JhkUeXpd395IHnFUa+ZSd9azyTSxS28wY2mIX7sdH5x4hVoe/FA7qADUskHsHlc+YCGGc6F/qkBCbnIi4hK32jUjfRWLkhR4aQP0+JvyEDmp3XYoJWefZcj2RAeUtTZxaKBblVAn0tck/FQZKQPZ7tD2H53TIU1yINEQKTRroLGFzSTZzAEccLfq7oJDylMybix/8N05XMITxric5kuJ6khalkDz5uAV5BaAiMuLZPMm93AZl38nEXsJWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0maP4dJyeFVgSiZtIlp8f5s30Rfb8aULew5u/e5LqfI=;
 b=JriphYlQnj+YqZzB4MDn4KsGcWYBMW0Rm2BRjZKHMak56rLANj1r6++tiZ/UKFIOOaz9VMElCZfvOKTWCxHV2kfvWbXGwj9U4SjSzdJrdzadqdtQAfDt5RO5jZlnWiYt1nNuZ370TV6o+0tNNLtgp7E1fWl6LZPGvD7cvALjyTRpciouz8KQosDQSTizr2KNuvdRsXKLAPa2KYPgxxmNE9WDQESRk7vB8gPxAoh0p0gExjqG0F9MDFqxxTQRsw8l2N0BgMhjop39GgeWS5EBtKOmZMgMNdyzXjYLCrCrHsOg2pPL38jkSc9cAJV6ZBDk8/X2b/tKfNF60i7MJ48E5Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SA1PR12MB7296.namprd12.prod.outlook.com (2603:10b6:806:2ba::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.11; Sun, 4 Dec
 2022 07:53:15 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a%3]) with mapi id 15.20.5880.013; Sun, 4 Dec 2022
 07:53:15 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, dsahern@kernel.org,
        mark.tomlinson@alliedtelesis.co.nz, sharpd@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net 2/2] ipv4: Fix incorrect route flushing when table ID 0 is used
Date:   Sun,  4 Dec 2022 09:50:45 +0200
Message-Id: <20221204075045.3780097-3-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221204075045.3780097-1-idosch@nvidia.com>
References: <20221204075045.3780097-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P123CA0081.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:138::14) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|SA1PR12MB7296:EE_
X-MS-Office365-Filtering-Correlation-Id: 66935f21-5e6d-4f42-c8cd-08dad5cc99cd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kf7fnmEnpq4PuoZInl0jkFUe8s3Y/vVLCo8v5G5ZwSvE4jeQq06ffW/wZGRwbOq2cT1nkWpIBDuoKXgZ18iAdRp6r3Cwl42yb7MDFXC5pkTUuWxZZ1wzCX3TSX6YvGYvuAvy+UYBqsslH2ukrbskVPoQe6ipd4YntuxpVyIF16bDehOjyRYMHnmuFJiNsxRjqiVZ7ooUrLZYaVAXrMXop8DA+BOMQH20TZdcrYZ+Fwg7Lv/QDyYfk1fUX62slOzPNQPKPCR7W9wOhimixvY2Nhnf78JGtLVCv3NLq8wtlhZbqEMQL0u2Mx2Eo2yYCysZOT9pMWeTkvPOovfMSRBMuTragXrZMxXGdOuHOA41JUDG+WBjD4LDJtZO8cMzYviBpRpxY7CB1icy372iliTok4ZS3y5rPe/ZJ7wGjKn0371l8agq7b0OpmnLLIL2GPnDK0B/C5N4dDSKLjGRCQ0CW6C/ePIq428qefaiHlsqVdslg60foA4pJaOdvuKxkBuK2vQhW2Afu0fjou+iM439JDIfEYvSvwt0vh17TiNwU5sWUBxQzISrlayeDxbM4Ky0rPTi4m+H8ebX4QbMBZTrg0sVYcaaku3+YgXutIzWzk7EOPMpxAh7Sy85i+kLcMEnZmGwBoWNGR/pKhuyS13O4Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(376002)(136003)(396003)(346002)(39860400002)(451199015)(36756003)(316002)(83380400001)(6506007)(186003)(6512007)(6486002)(1076003)(26005)(6666004)(6916009)(107886003)(2906002)(86362001)(66476007)(66556008)(66946007)(38100700002)(4326008)(8676002)(478600001)(2616005)(8936002)(41300700001)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CfugF8iyJmzNE9cfcGA3dW6IJBSEshJO/plnYDG6qUdqa9AGt325lV1M9M7x?=
 =?us-ascii?Q?gkvI2u8mPdMoV+CLqvwrZ4EHJt4Lrf9PTqZ9fmgs/Jz2Xd9uK9fzmwRwEVj/?=
 =?us-ascii?Q?wvllQ+zKXTW+xCYaSMHioW1nNl5cmtX3jD3ZZlg6ubZaagh+wgWUJud97h9B?=
 =?us-ascii?Q?GU0WW6nggoLdjKUkCb2UqeFPr12xkM2iEI/L275R0r3cXjf+F0KXf2Ar5rtk?=
 =?us-ascii?Q?y/dJumoKHVkGp3meVZdesMp04iLnVcoCZf+rNMVV1yB+DnH02yHVBB24b59K?=
 =?us-ascii?Q?n5Xy4OOqKhhqEkmusmoSFiay02mCZUGIOT3r20XtEePac52G+wJBcIednOhG?=
 =?us-ascii?Q?M7nSYKd8P5G787aFmv/kUOZzd8BGltvCldcim7Mfgn6W1BAnW2vNTd+GL8SC?=
 =?us-ascii?Q?LNvT4rj7k3uNcHLNJbPX3w2G1TcYJTHKe2xoFa03sJHQ6O+rorpvAe1oGzEG?=
 =?us-ascii?Q?tYFq0+noznLI1Q0+UiYPCjr+j/zvmTWVvjJ65toTBUum5eD8lrXwy34cZ1ya?=
 =?us-ascii?Q?zz8ZXeJc0cHPrjrcgr/MAkIi4YGxxckiBLqIJclbx/VHKgbXRSglR2+yJvYH?=
 =?us-ascii?Q?pCGk87/O2IwVQ1p5hatcbdOArPuFjna6Z2BxORoD3dit4evE6MAxRTj7/y19?=
 =?us-ascii?Q?UY65HmqCxKWSLIjDr9qHQ5PBEfpuLBj5uoZAGThrjQEIGJDaXPBpR7Ue673u?=
 =?us-ascii?Q?RSEio/m4hyuWc4IElAiPAu5Awk3AKHQEQOFJ5Gdb/xMDOGRgx9+nV+jQjs81?=
 =?us-ascii?Q?aw/+TbKAqoK0EkzdH0M+MwJzbcOsG7mIlLOAL+J8tBlOFkshnc3bccsUe4G7?=
 =?us-ascii?Q?xvn4NGRJF0iqA69c7H/LoYeSkP5Ya74TH1Qb4/QyGwjvMBhsNrY5RP1TJC13?=
 =?us-ascii?Q?3WLx8BjGH2asPPGC7mGVgFZT85i6rSHIkwrVcRjSy8DS44rAYFc/iq9f9DT4?=
 =?us-ascii?Q?nIQ5B3bxWSpMA9vrIzTc1+OLwZSpZsaCU5LhEAGtBYlM4L7ZzRuDQ3191uC/?=
 =?us-ascii?Q?V1SzjaqxDQYVt4mBBWBL/dOMLZvb7wXQni0ArOP3R7a/IXujolk195MEE8wh?=
 =?us-ascii?Q?QOB3ONYqQk5BD3K3P+WLc6rGPbM3Q01ICUTxQ6Pt8k25X8lUNwCK7XcYrn8K?=
 =?us-ascii?Q?eZRyzmuYtARv98jvNv3Rk1JM0s6ZZkf6W4ICmTcz7t/277KU7MlFDaD/KAQM?=
 =?us-ascii?Q?pavQHmxbABV/DlHasIwNqSezf+2zjHCjv/CEomXS46OtwLfFzlVVhw3pLgL/?=
 =?us-ascii?Q?fPHKe6/gChd/mFqKIvOBzE9Kxh08MBAHujolY+JabjqMPzpNDDFLlNidVSbh?=
 =?us-ascii?Q?6lTW+SsgOlDHNzzLGISczlfhrt7KVztlNvQZbMlgRq3yMC+N6nkerylERMdv?=
 =?us-ascii?Q?YjIVKDdyf9pFz9IR6lvz2UR0ivBaFzb8FLtiSn0ee7Xg5Xdco4SYgz1fSF4k?=
 =?us-ascii?Q?U1BLP0vKc9vSh1cqjub9KeOiQsOr9qYj6/6q18OHKNQet3RqbhcOnzc7sNKf?=
 =?us-ascii?Q?M8ulx/MMlAF9v8qD3lgd8876n/8qYcXIgPT8/7LxdWqy3ay7bEScDuLLHNCF?=
 =?us-ascii?Q?szsBiqROh0P8PvTiZhEnibhxIQ7oOnioq3YhaWwo?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66935f21-5e6d-4f42-c8cd-08dad5cc99cd
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2022 07:53:15.8822
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mpHuJOkM40EKMsYSCOiz3G7Lv9ZA7w9+TSSEZBJw/Ob9Xwab/gz+ieLavUbU3Qxl28p0HfUQewl5tC+ULuwjZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7296
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        LOTS_OF_MONEY,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cited commit added the table ID to the FIB info structure, but did not
properly initialize it when table ID 0 is used. This can lead to a route
in the default VRF with a preferred source address not being flushed
when the address is deleted.

Consider the following example:

 # ip address add dev dummy1 192.0.2.1/28
 # ip address add dev dummy1 192.0.2.17/28
 # ip route add 198.51.100.0/24 via 192.0.2.2 src 192.0.2.17 metric 100
 # ip route add table 0 198.51.100.0/24 via 192.0.2.2 src 192.0.2.17 metric 200
 # ip route show 198.51.100.0/24
 198.51.100.0/24 via 192.0.2.2 dev dummy1 src 192.0.2.17 metric 100
 198.51.100.0/24 via 192.0.2.2 dev dummy1 src 192.0.2.17 metric 200

Both routes are installed in the default VRF, but they are using two
different FIB info structures. One with a metric of 100 and table ID of
254 (main) and one with a metric of 200 and table ID of 0. Therefore,
when the preferred source address is deleted from the default VRF,
the second route is not flushed:

 # ip address del dev dummy1 192.0.2.17/28
 # ip route show 198.51.100.0/24
 198.51.100.0/24 via 192.0.2.2 dev dummy1 src 192.0.2.17 metric 200

Fix by storing a table ID of 254 instead of 0 in the route configuration
structure.

Add a test case that fails before the fix:

 # ./fib_tests.sh -t ipv4_del_addr

 IPv4 delete address route tests
     Regular FIB info
     TEST: Route removed from VRF when source address deleted            [ OK ]
     TEST: Route in default VRF not removed                              [ OK ]
     TEST: Route removed in default VRF when source address deleted      [ OK ]
     TEST: Route in VRF is not removed by address delete                 [ OK ]
     Identical FIB info with different table ID
     TEST: Route removed from VRF when source address deleted            [ OK ]
     TEST: Route in default VRF not removed                              [ OK ]
     TEST: Route removed in default VRF when source address deleted      [ OK ]
     TEST: Route in VRF is not removed by address delete                 [ OK ]
     Table ID 0
     TEST: Route removed in default VRF when source address deleted      [FAIL]

 Tests passed:   8
 Tests failed:   1

And passes after:

 # ./fib_tests.sh -t ipv4_del_addr

 IPv4 delete address route tests
     Regular FIB info
     TEST: Route removed from VRF when source address deleted            [ OK ]
     TEST: Route in default VRF not removed                              [ OK ]
     TEST: Route removed in default VRF when source address deleted      [ OK ]
     TEST: Route in VRF is not removed by address delete                 [ OK ]
     Identical FIB info with different table ID
     TEST: Route removed from VRF when source address deleted            [ OK ]
     TEST: Route in default VRF not removed                              [ OK ]
     TEST: Route removed in default VRF when source address deleted      [ OK ]
     TEST: Route in VRF is not removed by address delete                 [ OK ]
     Table ID 0
     TEST: Route removed in default VRF when source address deleted      [ OK ]

 Tests passed:   9
 Tests failed:   0

Fixes: 5a56a0b3a45d ("net: Don't delete routes in different VRFs")
Reported-by: Donald Sharp <sharpd@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/ipv4/fib_frontend.c                  |  3 +++
 tools/testing/selftests/net/fib_tests.sh | 10 ++++++++++
 2 files changed, 13 insertions(+)

diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index f361d3d56be2..b5736ef16ed2 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -841,6 +841,9 @@ static int rtm_to_fib_config(struct net *net, struct sk_buff *skb,
 		return -EINVAL;
 	}
 
+	if (!cfg->fc_table)
+		cfg->fc_table = RT_TABLE_MAIN;
+
 	return 0;
 errout:
 	return err;
diff --git a/tools/testing/selftests/net/fib_tests.sh b/tools/testing/selftests/net/fib_tests.sh
index 11c89148b19f..5637b5dadabd 100755
--- a/tools/testing/selftests/net/fib_tests.sh
+++ b/tools/testing/selftests/net/fib_tests.sh
@@ -1712,11 +1712,13 @@ ipv4_del_addr_test()
 	$IP addr add dev dummy1 172.16.104.1/24
 	$IP addr add dev dummy1 172.16.104.11/24
 	$IP addr add dev dummy1 172.16.104.12/24
+	$IP addr add dev dummy1 172.16.104.13/24
 	$IP addr add dev dummy2 172.16.104.1/24
 	$IP addr add dev dummy2 172.16.104.11/24
 	$IP addr add dev dummy2 172.16.104.12/24
 	$IP route add 172.16.105.0/24 via 172.16.104.2 src 172.16.104.11
 	$IP route add 172.16.106.0/24 dev lo src 172.16.104.12
+	$IP route add table 0 172.16.107.0/24 via 172.16.104.2 src 172.16.104.13
 	$IP route add vrf red 172.16.105.0/24 via 172.16.104.2 src 172.16.104.11
 	$IP route add vrf red 172.16.106.0/24 dev lo src 172.16.104.12
 	set +e
@@ -1762,6 +1764,14 @@ ipv4_del_addr_test()
 	$IP ro ls vrf red | grep -q 172.16.106.0/24
 	log_test $? 0 "Route in VRF is not removed by address delete"
 
+	# removing address from device in default vrf should remove route from
+	# the default vrf even when route was inserted with a table ID of 0.
+	echo "    Table ID 0"
+
+	$IP addr del dev dummy1 172.16.104.13/24
+	$IP ro ls | grep -q 172.16.107.0/24
+	log_test $? 1 "Route removed in default VRF when source address deleted"
+
 	$IP li del dummy1
 	$IP li del dummy2
 	cleanup
-- 
2.37.3

