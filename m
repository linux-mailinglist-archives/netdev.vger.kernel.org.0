Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07846564594
	for <lists+netdev@lfdr.de>; Sun,  3 Jul 2022 09:37:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231684AbiGCHhC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jul 2022 03:37:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231351AbiGCHhB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jul 2022 03:37:01 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20088.outbound.protection.outlook.com [40.107.2.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54A019FF4;
        Sun,  3 Jul 2022 00:37:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fMQt7hAlLrwGvNFLbwBV50QOpnCJrAY7kORoRCNLr6Jastdu4msv4bT1LeqiqvtQB6Cn/Q7sS0o6hrRFLIJOmmjQ5jHWXhoP/m2ZYFIPMlqcb7tIHf4P0+NAqyJTiVWwLyOth/eVZMwH/GZUVfno8FHXdwKRFpKc5o+tRLcvFQsJChnDs+qS+s23GW5K7NYA9Jrv+9YAKhBEktb3jyGXkOX4s7oPcQAn83oSpfQ9a30557FEmkN+Xom+Kf+GIpB1XMjHy0R5MgFcEZRr20kzud9Q5FPoXF+7W9N/DBPsdCo69otSuNNXCGwj0xpu3YM1r5bXT9cxACHengWiee0B2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pKLcDKPFIFlVrO8oFVa5Ngz1zZZ6bYh2DYPsh+kBMpw=;
 b=I24ytFN+hHQDEqOvUrA50MiVUjahjHK4X0T3V3y58JGWV7NcBSQFTbq8QCM2ILgOaoqdq8GF1ly+cyAr2ZwWU7pTmv0uQVxSFSpsxslYzSpRJ6bBCiBNHWO640tnTFgqIRku6MPhqWP3BOTa1XxuEGEblvLFbhJ/K93vek+aRDohOkqQd8C3xfv/AoWqiOdCeb6E8IV3AXvwwUzfVhlfunJb79I7ICKw1S358dGO4omAP+nFRTml3L/eX4xGq8sZ5uM/ph3Yj2NVUAcEDYPMwiddJ16RjpmKL35k5bj309nqSYcanGtImcODZqBDyduU5zr1L0HusTB+AP2joL6Lzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pKLcDKPFIFlVrO8oFVa5Ngz1zZZ6bYh2DYPsh+kBMpw=;
 b=s0Bbtvv82WCOc+ZG4civegvU3ScFWPuMBRhLUH0JW472Vzp1DdSXmnEWzqNE+LJlRkXFjvMrhOtSOsBPM+jVb7sWwxZFJMeyrAPvfET4Ax+opFkID8xfrKJUPysJ5Y7PF6YfEWh9dIhSBCXx1NLZr047mAUwHwwM+tvrWz8hwRQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM6PR0402MB3877.eurprd04.prod.outlook.com (2603:10a6:209:1d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.19; Sun, 3 Jul
 2022 07:36:55 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5395.019; Sun, 3 Jul 2022
 07:36:55 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        linux-kselftest@vger.kernel.org
Subject: [PATCH net 1/3] selftests: forwarding: fix flood_unicast_test when h2 supports IFF_UNICAST_FLT
Date:   Sun,  3 Jul 2022 10:36:24 +0300
Message-Id: <20220703073626.937785-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220703073626.937785-1-vladimir.oltean@nxp.com>
References: <20220703073626.937785-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0018.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:15::23) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f305750b-2aff-480b-00de-08da5cc6cd48
X-MS-TrafficTypeDiagnostic: AM6PR0402MB3877:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sMDP20kX8rrMFySAnRphpHuDHafCU3kv2kga7A+xmVz0bgeSw3e+MamCh3xGIvxeaFXDEJ+Y91GWC5Z9g9S4FAEFsIX3DqfTzzA8is7Fam05zVVS9DnqUIpK7Evt3ZJpO52OyNYx7JLGfc3Kh+Dl5f6RH5Lx+cQgUrvtPUwR6uEA1lSa3jT7r4Y0xoxeqepID/l06AE707WKCV6FPmtVxlmqO9QCQoQAtukB5EP+ZkK4zEsfX7Isjma9bRu+iiZpzq7o+4Kz+5NFtFvmdZ0fpHsRgGMFGyjD7tAfiesS39GfjOcNHJMPQNVbDvsLl3R1DTI0yO10B+iLt9LmVhJc0wUTzNDzzyjWPfPJOcwaPmTJ6rLLB2POBxoRZQogg7MYM01biUcOfsaBMTx3TBNOap0dNitGMmKNvaAm7zqECCv4s+syjzPzr7l2ouajm/H8Ommp8a5SoqHBovWIcF6piF7fyawShvis63tLZfB7cFznP09Iut/s9NNxjOwmVnBHen08/Cu59OCr2oahV02RUxhlxr0xuEfGgV1cMPqEBKN78bvm8jCL5YHfbTV/1pKsKNMdUjBPe3UKtnrwxE8MfYTRZXJMew9BB7rBBgHz0Q3a3mi+ozM7bAf9RFf+PcRc+9mUQmUlcd60AXagU5T2hj115qYOPSzep5qxwZ0lNd5tPi3H6mi1zIvQJZ3SGytqg2m8RcbM+6+A2MC3taidaSHaN6c9Q4RbGkRcEVutwouOpJH3qLYTt/wQ4jnMAyTnIWlmDp9lXfcwYcPNk1C4JK2vqPftM8FJ+rVlf8NqG62Wd/xcpC0/MngEyEV4Edlj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(396003)(346002)(376002)(136003)(39860400002)(2616005)(1076003)(5660300002)(8936002)(6916009)(54906003)(4326008)(8676002)(86362001)(316002)(66476007)(66556008)(66946007)(6506007)(41300700001)(6666004)(6512007)(26005)(38100700002)(52116002)(38350700002)(6486002)(478600001)(83380400001)(2906002)(44832011)(36756003)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?D7NHI88Mh4jd3iS5Z6KTOFSNA8pQBbSkzyymaX/We1XyggbBYJicSHuG/tsB?=
 =?us-ascii?Q?5CXHWBQU1Le8emuxAjV7spTOJAblMgA4QpSIInnMYpA8haD7814Z5JhO5Tcm?=
 =?us-ascii?Q?Nw5QDAIf99WfXLF+1UXQCPhDC6Jxy61pEDwM8zOf8w67TmtH/q77IAzacdlk?=
 =?us-ascii?Q?QnkRKRkLRp08yxLstkcf6cleAPwJlYB4BT1R49lJoobRhAX2HHGsFhTjr0M7?=
 =?us-ascii?Q?fg1tlttvcCvdk6QPEBRXyMw8M0QE+kvHfXp3CGnlGJg3choGakVkQmnwBFdI?=
 =?us-ascii?Q?tzFhrWTulcsetwEHMlZqsTc9d6j+I8x1/IiUnEZtL42QBRs0BneQ84S8WkD8?=
 =?us-ascii?Q?P673VC/I2J2JwEuaOELPTsRm03fUBE6B0pXUoX43C8GVaoy8LMxS9s7MLa7I?=
 =?us-ascii?Q?bWixGzLzvxpCrIFUjDSFPmD3TaUW1eS5js0M/T1DNOBtu9JHH8uvYGMOIfj4?=
 =?us-ascii?Q?Qi/HEG3JgqqwyQftocPHWa2Icycan/nOJOtWFs0/z8tYDqbTSIISLo5JXB1N?=
 =?us-ascii?Q?+GYyc4FuHk2YDdHf71DkIM8TXF3CVGUoHuzpKKF3lZbu4H644Wj2aICOlvxw?=
 =?us-ascii?Q?o3y3Ej46yY+2MzPztpyZr/UUjv/Lbthvs5a2EN+Lp/QKJg4DTJ0fUhbyPPQu?=
 =?us-ascii?Q?GQYNAelgib4bo811qujDhGjnE/82HmpgJbcTPn42xhBdEsf/4YKApySCPBIr?=
 =?us-ascii?Q?Oc4YkzqqZR2NVhIuHBJh1jwdKJr1KJabwwzqnqnKM6bW0dAZbFs5i2rOiovQ?=
 =?us-ascii?Q?+agY4KSu6/tc+BohsmLEywLwwgMDW1ntERffEdx/iEQdNeAl0bA2q4yQZOZz?=
 =?us-ascii?Q?vtM+fnDfb4zeMF/R7XGm2A6+vhexjyWy37383k+mNFPgHmhdwP9p7pl/mHX3?=
 =?us-ascii?Q?2/VW6N41BNdzNWmZ0zoBmIHhNhZG+amBqY3NmoBv2eKwp05A43ouFglzEY1E?=
 =?us-ascii?Q?ifaHm7rpLSugItd1xyJJfLuILJL3Pciv4df9uat2uVjUj5W5PPjC4Sm2acEJ?=
 =?us-ascii?Q?vVOzlKjCEm8KTK9d/7OJRSqWC9jdx7kR930rNE3H8CpHSfgum0g+Jo2/5SFS?=
 =?us-ascii?Q?fWt3kVisAYH0ERwTCfF9UO5cHGcAvDWDo7hAzDe6odMTgnhEPtdq9Ns1rzbx?=
 =?us-ascii?Q?pIu3/K+DiaPt1aMt1JWNm0FydPbXR2qjH64Wu1s2omTkSsi+IQxAcosNlBT6?=
 =?us-ascii?Q?GIbrShNWzfNYVMlG6A4mLYYvbqebnd5OlFsQgU7Hv1wT52cDvTn7+/s75y/n?=
 =?us-ascii?Q?/pTrbAA5qpMjmeENJtAz/4OQaMMqw299jiai/1KRRAVX4iE26pDNX/dR4f7U?=
 =?us-ascii?Q?HoF8/kvhnbzZAiAwr2EzEmKrS7FteO8k79FH2PNBhmqQiygOsK0DC7Lp7Gh+?=
 =?us-ascii?Q?K2F3Nik4XZ4N/uG08E6eAk/ueE1rYVbxqWpGXlekbWnTozssXHfV7ttTwxeM?=
 =?us-ascii?Q?e6yGWsejxnh6kUilvequoPAYqSrROZuMMbKYMg/eY1T53uesefE8RbqpAR8j?=
 =?us-ascii?Q?e81rm09LK6F5gBSA3OEwDz+IAChB24bwN0/9NCzxwHRA23pCeR2vdYRHe2ol?=
 =?us-ascii?Q?3sCxsbJuKv3qHmnfqZN+ZROHqtl8vkgh22knq8mTg69qLT/s+tNuPx8AmAwd?=
 =?us-ascii?Q?6Q=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f305750b-2aff-480b-00de-08da5cc6cd48
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2022 07:36:54.5705
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k9/LyhqLZICxJPwSESovpRNncymdg/CEMRhFCDdc1L3BjTlsd6mgqH2omtfytoLEK+UR+LvvVXPuvGJ+aBcYeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3877
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As mentioned in the blamed commit, flood_unicast_test() works by
checking the match count on a tc filter placed on the receiving
interface.

But the second host interface (host2_if) has no interest in receiving a
packet with MAC DA de:ad:be:ef:13:37, so its RX filter drops it even
before the ingress tc filter gets to be executed. So we will incorrectly
get the message "Packet was not flooded when should", when in fact, the
packet was flooded as expected but dropped due to an unrelated reason,
at some other layer on the receiving side.

Force h2 to accept this packet by temporarily placing it in promiscuous
mode. Alternatively we could either deliver to its MAC address or use
tcpdump_start, but this has the fewest complications.

This fixes the "flooding" test from bridge_vlan_aware.sh and
bridge_vlan_unaware.sh, which calls flood_test from the lib.

Fixes: 236dd50bf67a ("selftests: forwarding: Add a test for flooded traffic")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 tools/testing/selftests/net/forwarding/lib.sh | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index 37ae49d47853..4e69497f021f 100755
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -1306,6 +1306,7 @@ flood_test_do()
 
 	# Add an ACL on `host2_if` which will tell us whether the packet
 	# was flooded to it or not.
+	ip link set $host2_if promisc on
 	tc qdisc add dev $host2_if ingress
 	tc filter add dev $host2_if ingress protocol ip pref 1 handle 101 \
 		flower dst_mac $mac action drop
@@ -1323,6 +1324,7 @@ flood_test_do()
 
 	tc filter del dev $host2_if ingress protocol ip pref 1 handle 101 flower
 	tc qdisc del dev $host2_if ingress
+	ip link set $host2_if promisc off
 
 	return $err
 }
-- 
2.25.1

