Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D063B564596
	for <lists+netdev@lfdr.de>; Sun,  3 Jul 2022 09:37:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231249AbiGCHhD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jul 2022 03:37:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbiGCHhC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jul 2022 03:37:02 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20088.outbound.protection.outlook.com [40.107.2.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B5659FEF;
        Sun,  3 Jul 2022 00:37:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JyB3qJDzcAPGUT7MWoK8JmRagNApDCU1yDkUg4GJ9TgUmmeIdHycDYHPIaoajmlocq93VHBPzHqxNwEzhUeISxstDv0tQZYIeV0xW5SwKLwSsAYcmocOpNPXFT+Lv029jXaC38qB/A3r27K+pQZGpYshbUS4amc0E1VFK8JO2XEhouu+5wG6jC5F7LDDUPiTBaBBWs8+P889fC7wXI1KJcAQBn+Nit3F7oqA6IGMmgMPJH5aE+1kIh0H5zvUybj/vxbB+tZd4BqE2lW5gwAhL01qFO9h62wXGC/jgccqrGPOXW/ckWMNqKyZcF670Ec0odqB4ah1AmVM4zJJ/4I61g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eBMvgRoQCWxentnt9dkYMpKMux6duuVxRmYtZvQjmr0=;
 b=lCDPsb86xLnBga/78OaM2c7SsLj3M0LFGJiyC/k+24ika2gAxyANSGNP1T8n7U1CeZ35HYehb8FsMXYZijxHlDBfO4gNzlk8nyBO+O2rWYQSZe0wOpyGJjNaHDk5lhzVVFikKw2rKnEwtJMPzG4POJiOTj8sZdac/5MyHSYtDZMiFSvX78v7tAqiqnN5J+Lyyoko4OjWj8tHnItPYsG8L3xBq8mPiaFeA0Fj5032QzBr+JkZo971IGpbclLdDP876BKV0uoWX/BY+wXF5Fi01siP41uj1431ywxtImv0oe99dTNgTs2WGIFxJBSikXMeVlM3DlIsUfvIeKEmYrdnhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eBMvgRoQCWxentnt9dkYMpKMux6duuVxRmYtZvQjmr0=;
 b=JXC6VLRwsRZBHyifmK1lUH+KwE8JTWFhFbs9v/50F0hQjJM1S+QI1LwsfMJDPJ2fB4EP4Z0MhBnPXszyOrfA+dCX80N9f1NiDFA7RYlzxXj8/3+sHAkk+lurml7Bzsf9J2K0IoC9Hn2pNu8LcEBX6Udai1rJUPuR/SPV8WWYViE=
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
Subject: [PATCH net 2/3] selftests: forwarding: fix learning_test when h1 supports IFF_UNICAST_FLT
Date:   Sun,  3 Jul 2022 10:36:25 +0300
Message-Id: <20220703073626.937785-3-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 3cafd394-9107-478b-8223-08da5cc6cdcd
X-MS-TrafficTypeDiagnostic: AM6PR0402MB3877:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xG6bfOUomY1SiwD059rUwF3KeuwSRrYHCdct0B0f8gC31JuV7Oi3WnWM82dAlEykbhZQKcr2qbwfUWwkdMa6hif2XkTErxXSH7yqNn92lUpibCLRYBxKdHuq4k+Xfy8F1fXQLk9Gw1zE53DvWqbisI1IzWnz3YUnDzh8Jr1jykrxhR2sIGYz6CV0U+68mTkfTTVXw9xtiqk2WysMPwX4HrZQMGEFSuUR9zygTmqn0ampMhtvSbwzLjVIzIvE0CLCXwX0Tx02o3Rwe7wY2laGNDY2JuMyIzYvK6bsUzfxluHffZo4DJzD8h0cIxdiD2F6Go8/AZqEV1GBx1veYD8mDIY7BUgtqK0x9Uji/SEZLRzzB3EQfLOPJPrfR5nkLX+ahmSGvcz5X3WOpWN8Kg1z13NnUkDbeUf4iY0aRvPbGy276hS9EOT15bDoGGWcOFLkEm7UNFw3SJ7LfihzLHC3I4bspMOwxixB6THlMtw7c+9qyf8Uqjvi6BCmVKWgNHGBcMMLMeyZ6Wb3hvK1Ak7Hns/yE43FB1MmUaPDYM8MMM5XnZKlUm+98aKhn8lmGAV8a/tKKW6hcyo9LDAGc3DQ/bch4OUlN3urzYk6twmCX9elU5ngVOyfQBLh0PD5YwvcQ+2xupyyi9f+EXDk/aiT3Qaw0eQRIp6BRTe0wwdzSUVhzCYvkvgzNh6yi2bAybhq+js9qekpa6xyrSl90VWKu8j09FPCcrqcaidmGUpon20NlqmSN988cZlwmxH8tB13stef/h7rISVElO4i7iLmmetHK/4ThoJ/v/isonIKDhrrlGP9FM/4XqfSaGKKtQHh
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(396003)(346002)(376002)(136003)(39860400002)(2616005)(1076003)(5660300002)(8936002)(6916009)(54906003)(4326008)(8676002)(86362001)(316002)(66476007)(66556008)(66946007)(6506007)(41300700001)(6666004)(6512007)(26005)(38100700002)(52116002)(38350700002)(6486002)(478600001)(2906002)(44832011)(36756003)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jaCn227OJvFCf3B8jV+zPrVNJIo03nnZB7zU2ttntBNEDV1jbjo9D5o9vrta?=
 =?us-ascii?Q?L970oM7eXy5S5wl9JiCey3cjTj0QmGsOF3K1zntY5cRKxqW2D2g/atLnynaa?=
 =?us-ascii?Q?W/I7oqHcy8pzW80zXRjcFPjT8ITOblMzwUmtqhKYeXA/oEfzkmfhUvIWBO//?=
 =?us-ascii?Q?7nriZd7owrK3mLdhAa3nGxlZoGR4pkoy51RMdB6n5TdqR5caWQSzO4EaEjpg?=
 =?us-ascii?Q?+dlFicAzVA4nJbHHiiKkiNVUKmYQ98Qc+dOld7TS9egmG44P5bKJie6L0WGX?=
 =?us-ascii?Q?Qgt65cMVtL50DHVVh/GWNVRmlSQ8odyS/IaQAgK7XyS1NwFx46RpQLUunOi5?=
 =?us-ascii?Q?tNfk2tECRsyVBRp2QAn9HUtGE6ou8BM4VmbrMJBqZsM7joORdXX6JQH/4u7Y?=
 =?us-ascii?Q?5YlL1vl5lmHNLzHwXFWx4fBIy5QOaPhw/L7bWli5FdSYh1veFICnk4zIXE4O?=
 =?us-ascii?Q?hI1bgdjsi72YTPNUQERhnkH8zfXnB6lgFGp6cNTGD+ZmT/wOGk1Ya/cd+wct?=
 =?us-ascii?Q?Ntr9YUceNkKEgTOCOhJafp+y95sq+bIfEannM6R/aMF9UuT06YhM+ghF8lzC?=
 =?us-ascii?Q?twqYPs8WjydjinIP2PC1rrbPkIkh0WtiFy2l02+LF9hyZecSbqFbNMdT4eMJ?=
 =?us-ascii?Q?LLA89LOe7TMhUm2hz1YZS6JnAe8k+5Y8CvI04nF5ERBeldBNq1s7Yx9mMf3L?=
 =?us-ascii?Q?Fl2lIy2eEwbH+INgFEYcAb8LI9KfY3yVyRiCxQq8DvJ3i8cGNz7dnOrwcwRQ?=
 =?us-ascii?Q?KhCTccnGsjLpVW5pnqcJvTioB8AakAZv6/OY7/85pDTY4l2pUgYBreLTaDia?=
 =?us-ascii?Q?X6jnntdDzRx4ORvClxBmLR80H8lXlhF8TOcRqo94WX8GqeeQ/8bdD1Gy0Z+Y?=
 =?us-ascii?Q?+Ut5EO28re02tnVYLXlrXoVQ5WuJxG//1EMIQq4HmIlESF0/iKOk3xgZpkn1?=
 =?us-ascii?Q?KCgasf0crwxFnoNBme7XOjxTgHKeymV0HOBa5QaxY+PeYr2DrDi8Ud+JDFiG?=
 =?us-ascii?Q?/fjmRqHKkK9IBL1w5t3HO20e5OgMB+niy34fDfJPMfa/eEQ6eZhXu6i/TJmF?=
 =?us-ascii?Q?xJe9vvzcH65IwCm7AWq85ezxpjzS5nf48hoR9tStPVQ7FM02xma1PJQmKgMD?=
 =?us-ascii?Q?9WCbsHtPYjEGV5wkmddMfSJgp7g7MAw7ZLeZcJsmABkIPd03F2Tb4UXWzuiX?=
 =?us-ascii?Q?nxAh9JISJUpqO3/2VnMzCMLsidYQ3s0YTyFUvNhtoFkfI3EeECLUHh8elQNJ?=
 =?us-ascii?Q?ydTQzTa0Bt2Zp/qTWhUuV7nHJCtXUFiXb4T8Ho7osm0jp0ahkNMDms6hb3YA?=
 =?us-ascii?Q?fFBKCAIKyjOPTzHi4XMwFfmu1idNwmr+CNyEojthNfGdbkZMSarhbqMFQmAG?=
 =?us-ascii?Q?JbrzeoIyRXRYGiJj6EKvw5pl5MNJgXGWn5E8rAe19r4VI7xqc7bcabOgBP1p?=
 =?us-ascii?Q?kGOGjtx5DuXV+ZgBTQexX2eOo2SN0Y2fF2F5SaiX97SECgT+a75+8ck9g04D?=
 =?us-ascii?Q?TfNlqCsw2YVLfNq8tOIdDweVe7VajgPXR0ylXBYrMNbwwEpkki+f5ZNIj5qV?=
 =?us-ascii?Q?t0wuBGArjjWs4PgJaTlhDh3ZR7mR3gnIOuqUfuYyac8+nCh2hCgE3Xwo3Xap?=
 =?us-ascii?Q?UQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cafd394-9107-478b-8223-08da5cc6cdcd
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2022 07:36:55.3986
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ctd+Hiksjhjq1t4WTvivqf5BJgxk9u3oXXUgX6E2PxnJ76DngFM4UapUGk59UDDuaZvNRbVCXjQZ8KXnSWRCrg==
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

The first host interface has by default no interest in receiving packets
MAC DA de:ad:be:ef:13:37, so it might drop them before they hit the tc
filter and this might confuse the selftest.

Enable promiscuous mode such that the filter properly counts received
packets.

Fixes: d4deb01467ec ("selftests: forwarding: Add a test for FDB learning")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 tools/testing/selftests/net/forwarding/lib.sh | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index 4e69497f021f..26ba8b5d264a 100755
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -1240,6 +1240,7 @@ learning_test()
 	# FDB entry was installed.
 	bridge link set dev $br_port1 flood off
 
+	ip link set $host1_if promisc on
 	tc qdisc add dev $host1_if ingress
 	tc filter add dev $host1_if ingress protocol ip pref 1 handle 101 \
 		flower dst_mac $mac action drop
@@ -1289,6 +1290,7 @@ learning_test()
 
 	tc filter del dev $host1_if ingress protocol ip pref 1 handle 101 flower
 	tc qdisc del dev $host1_if ingress
+	ip link set $host1_if promisc off
 
 	bridge link set dev $br_port1 flood on
 
-- 
2.25.1

