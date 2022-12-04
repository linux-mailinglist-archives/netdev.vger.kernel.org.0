Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96BDD641B61
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 08:53:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbiLDHxO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 02:53:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229922AbiLDHxM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 02:53:12 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2089.outbound.protection.outlook.com [40.107.223.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B96B7165B9
        for <netdev@vger.kernel.org>; Sat,  3 Dec 2022 23:53:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l5A3N75dFIW34Dm3qASBlYG8KYj8aJvVi4UpKo6suHM2e5bjfbqiuqdxwTaRmh2ZeEXMZnFr2ni28wC4nKwqR0eYTEbpegbuPy073pWfonqXpY3nNztn1wr15zOsb4nOIimnhEugZ4BZ5fIU5SdBrfVOybLWeQMZipxRXkhfyM/4/iSB0FfYO7zmu5sPdnTzhcBcAJ6Z96OeOI0iJStur+HlSPPiJya0MyxhwgT8yxsj6hpf7/csFTei1aM4xPR4yfEfmeAyr9A+Rqo/AQPdwXRNrVLkc9irTDIFnlcVkq0QU67Dk22jYQwAICOjfuWTe6n27rCGirPKTw8KCCUh1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hpf8Fm6tvGqXmNgm3oyM3fFLBbce3LLcngGq9YyWC9g=;
 b=Sp5BRng0PZEeUg5go+ldMiV9J3jC+fBuq8whBX3GK/4Clo8XVUHOS7RtVTutUlfi9qvJDxZsJb6qMA4fufZbfP3PXmZupLhssEW36yBErNV/MtHcAeUrYaH7xRE/cEvE3v2/ydUepgn9fWV69yf560NFOmRUOG+Luvp9FkKb2YoflNlZuubiLIO+9msY/KSKZ9UTNYls+rtjz7LDEw8lzgTmt/nVSC3MNZmAGxhlME2WXSQO+V6KaMRPO7J0ODaDOlKaWR8SLndSkA3xxoVTJS95/Lg1Tr37/GgTQkl+xuO6JrOK0WVny2TSDHq2CkwLitUo1OS/cb9YdiDPp7zTkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hpf8Fm6tvGqXmNgm3oyM3fFLBbce3LLcngGq9YyWC9g=;
 b=IrTOhRqllOR5OdmknYfWTUcFIxLU6kg8GWqIwJG0kpbo7QCm+X+h21PKV2Tg/Y8vN0AzblwhUFNZnL72HP/R5h+Q+J/N6UHb4BYm0ftm+fTcAS1AcN7ReHl6poilC7XHk6rtcxa/wfVrfB29DPguQhQrWmNz0laJtqbQhZ59CQGja1IPC2GuLpx/+kfjd8KkZ2CKGyToY3BQZnJ65kkWAZ3wemEAi8TSaKndyjj5K0x/vpSm34riWhQpdesYhRf2TEKjlepXlmYXLiMj8BamzE4Y+3hc0kHR/LaFeg+Zw4mIn7io7GNwlzEfKM7av+yJpvxLQK/9hLNjDYgXuUr8bw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SA1PR12MB7296.namprd12.prod.outlook.com (2603:10b6:806:2ba::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.11; Sun, 4 Dec
 2022 07:53:10 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a%3]) with mapi id 15.20.5880.013; Sun, 4 Dec 2022
 07:53:10 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, dsahern@kernel.org,
        mark.tomlinson@alliedtelesis.co.nz, sharpd@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net 1/2] ipv4: Fix incorrect route flushing when source address is deleted
Date:   Sun,  4 Dec 2022 09:50:44 +0200
Message-Id: <20221204075045.3780097-2-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221204075045.3780097-1-idosch@nvidia.com>
References: <20221204075045.3780097-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P123CA0108.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:139::23) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|SA1PR12MB7296:EE_
X-MS-Office365-Filtering-Correlation-Id: f1307169-29a8-49bf-fa2b-08dad5cc9680
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M5nTMHa219nc0RU3eWTLFCHX1ozPjxmrEQBW7V3n2y3qJ0bfch2WfY2NJsC8ZpnoduX3ZJzcQpcoWEiicclRAaWdmlNPa8SIa5BnZ5M0rh5REJNxiMZhslOk1sPq4gp6teA6pxeyRkeDOmRCs39Rnxb3didYMRuCKh5f5LsTC8yiUAs/aj9+JbYs+/smMHKTbCpxXPP9Gpdb3ZEH4cf+YsE2C2AwSZtr7WcqbCCnarbZNrCcrLaHH2hGbOIcAEOfdpyiBlmoH9RX3J4OYKnrCdFk8VYsYVmqgCQk5cm2LcFx9nBtKllfzfOzKT6q6AoQp6/GuQGMAgp8f/z1xOZeJgauVKyfqbLwYUMjURZwtVHnJgXr8+R0En3AznQqVh2/dczVOCfvnvNVQDkkdFGM/7Hc8Yu99fEUE8t8iQbaG+4B7IgVP6JhfeQyAt/qpw8mEsSnP0CAsBRDDCOmEXH6kgVzbsN8Q6VhYAXH+h+Br/bFJBRJ+Lh5IMW1JegKBcVefNDCfrCE7qqfguoCEX4SgV6b3C67Rx1gp18Naw+m7elYZJoHi4E88CaX4yw923zuUdoQzj4qX2GlZiA1TQOaXd7mrfY7dw0e764/F7dDaihI7znAP2/0kWuUH3SdptN2IhQfsETfEYqp5M8SZXeYoQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(376002)(136003)(396003)(346002)(39860400002)(451199015)(36756003)(316002)(83380400001)(6506007)(186003)(6512007)(6486002)(1076003)(26005)(6666004)(6916009)(107886003)(2906002)(86362001)(66476007)(66556008)(66946007)(38100700002)(4326008)(8676002)(478600001)(2616005)(8936002)(41300700001)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GVsRP/CBD8t6TD/7ReiiBD3Qeuzl/+Ca6GJlScoLrU46S1L8m0GnZ7C025Wo?=
 =?us-ascii?Q?6Xrgilz2VwoKrC35qAmXzQBEB/olAz5d/ln3E01n0Qj39eFOZmRz3jFK6vvp?=
 =?us-ascii?Q?hFrHV5qkPuvMLoDKg/9HR0UGcDPcbA9yr13kMKwu7Yiw2kcfzbGfrs6rmuy0?=
 =?us-ascii?Q?LwGiXPbGAcgUtypOHCWNroreLLkJYQhVkBlBm+lsRYFjXhvBXuAJJ2HNX2jV?=
 =?us-ascii?Q?dsSiSj6iqqLEb8mRJuEsYklfhqiqMaFMlgV6p7EfgD7u/P30BYaaghOuSB5Q?=
 =?us-ascii?Q?zIT8c39NRXLTf423p/rGdTvu+Pz9tSaJXt7Px96QdqMK7CtCubdMtnuoxJx3?=
 =?us-ascii?Q?i7Eud+Agk3X62Zy7+SNFSlM7qrm6DLDHIzazBDB/Wf+2PToObZqfH5JABl9B?=
 =?us-ascii?Q?BKxg2t4vFRXESpdDjDavEhmS1YgVIP3nrznvW2stkg0JjECg1bArOwyifLyp?=
 =?us-ascii?Q?2rj2PGeMhoO/bum4KMRc/d6y1i8IvcWXl9O0Oa/CHwgQwyvOXglOQ5UGWTzK?=
 =?us-ascii?Q?5yTy2iheMvyQxm59n3xZtN5KaRuzFY43pi4pRcRsNA+in9ucOMcYpRjD+aXA?=
 =?us-ascii?Q?drdPBq4oVHv4RotMAuznFpR7FexkdTqfRyxSbGEGj6Eouaxfrvgw46Mcprna?=
 =?us-ascii?Q?cq4JGf+48SiRJGkEhctMR5z6hn70/FI1CQCEyCUQNPo4sxUwNUgntk7ZI5tI?=
 =?us-ascii?Q?uBVZU2F0/fgUe5+kvVR28iFec3M5VVt8QHAbTSSsCsQd382vAO8jM7bfIZcE?=
 =?us-ascii?Q?6He2rFHBkMlHp67SIbu1wDGjWZMs5y0QqGj/WAKsbVLJ6RVcUt9nuaBprv3C?=
 =?us-ascii?Q?2OK7GJenn20gZIviCa/sD1PAUCyt6R5gK9rRmxYRnrgll+t6petW1q4ptM47?=
 =?us-ascii?Q?J2UkgEKBaohmUyxeABVIJKTEya/LdwGTYdvtwJJQ+htCEcZ5vtBQ5yJ9T6hm?=
 =?us-ascii?Q?U9GjuTK6eg5wxxJ/SRt9oPl9WuB/rUhtcVAx6JcQbgO6ntrdV+MmeFxQELq1?=
 =?us-ascii?Q?x5glUU0/cCvvrv2vfjFIpJ2Hi+riqRxF3ww+u3cR9Q+/x5fOjigLlmlyhpNo?=
 =?us-ascii?Q?Dl3SjSKovbM77aJCNZW3d9/wfwxMptVaRboenmac/q7A/dE1X8MwOCJUchUp?=
 =?us-ascii?Q?dPP18XxoU22TL7Zf720iWJAEs3DVnt81hVF4g8vQU1WgdmI7HN2VoXxxEN0o?=
 =?us-ascii?Q?WpEfkAga5WIDGO2TKdOmIbP9ammRb+kzSFtWs80/JRMuGoMTEkhV1gOFEsgi?=
 =?us-ascii?Q?1FwTncwlWUQ06nG86rmmVno0gG3xx/hWBiB4qH8twVEBfJ7yhGpe2AEvPvcd?=
 =?us-ascii?Q?pwcM6ZkXq6CbkD6/YsJRgT2YnF1FCqFW5k6FKvhECj9GPW9qLhK+VVqclKYz?=
 =?us-ascii?Q?pR7OrIddsLDhISRKyuRkhymMWB84BpCLKxElLFBqch58TSQr+XtU2YtVZwnH?=
 =?us-ascii?Q?lmbeKSYcPAwnQPfRkrJ/dhXWyRPcoaff5ZvhZf1vlIdr/gKD5D7ZxdJeMH4m?=
 =?us-ascii?Q?ySmc3T75gTJT3b68mcEFWY9wfMIkeXALt9QqkayTU0hs8TXSa7zocbKCXilh?=
 =?us-ascii?Q?spcUZsw2LG8XrGbIEZD7QNa4S3rLpjP0JM7adqmC?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1307169-29a8-49bf-fa2b-08dad5cc9680
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2022 07:53:10.2207
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lGbpVQ1IlZjn6zRtITeukEsj9QD5y0KgcHjAWhaOoE6jfZlCNsW0qbxUSa5hE9btKz/Ao8/V5OMYBE9JDica/w==
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
prevent structures with different table IDs from being consolidated.
This can lead to routes being flushed from a VRF when an address is
deleted from a different VRF.

Fix by taking the table ID into account when looking for a matching FIB
info. This is already done for FIB info structures backed by a nexthop
object in fib_find_info_nh().

Add test cases that fail before the fix:

 # ./fib_tests.sh -t ipv4_del_addr

 IPv4 delete address route tests
     Regular FIB info
     TEST: Route removed from VRF when source address deleted            [ OK ]
     TEST: Route in default VRF not removed                              [ OK ]
     TEST: Route removed in default VRF when source address deleted      [ OK ]
     TEST: Route in VRF is not removed by address delete                 [ OK ]
     Identical FIB info with different table ID
     TEST: Route removed from VRF when source address deleted            [FAIL]
     TEST: Route in default VRF not removed                              [ OK ]
 RTNETLINK answers: File exists
     TEST: Route removed in default VRF when source address deleted      [ OK ]
     TEST: Route in VRF is not removed by address delete                 [FAIL]

 Tests passed:   6
 Tests failed:   2

And pass after:

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

 Tests passed:   8
 Tests failed:   0

Fixes: 5a56a0b3a45d ("net: Don't delete routes in different VRFs")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/ipv4/fib_semantics.c                 |  1 +
 tools/testing/selftests/net/fib_tests.sh | 27 ++++++++++++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index 19a662003eef..ce9ff3c62e84 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -423,6 +423,7 @@ static struct fib_info *fib_find_info(struct fib_info *nfi)
 		    nfi->fib_prefsrc == fi->fib_prefsrc &&
 		    nfi->fib_priority == fi->fib_priority &&
 		    nfi->fib_type == fi->fib_type &&
+		    nfi->fib_tb_id == fi->fib_tb_id &&
 		    memcmp(nfi->fib_metrics, fi->fib_metrics,
 			   sizeof(u32) * RTAX_MAX) == 0 &&
 		    !((nfi->fib_flags ^ fi->fib_flags) & ~RTNH_COMPARE_MASK) &&
diff --git a/tools/testing/selftests/net/fib_tests.sh b/tools/testing/selftests/net/fib_tests.sh
index 2271a8727f62..11c89148b19f 100755
--- a/tools/testing/selftests/net/fib_tests.sh
+++ b/tools/testing/selftests/net/fib_tests.sh
@@ -1711,13 +1711,19 @@ ipv4_del_addr_test()
 
 	$IP addr add dev dummy1 172.16.104.1/24
 	$IP addr add dev dummy1 172.16.104.11/24
+	$IP addr add dev dummy1 172.16.104.12/24
 	$IP addr add dev dummy2 172.16.104.1/24
 	$IP addr add dev dummy2 172.16.104.11/24
+	$IP addr add dev dummy2 172.16.104.12/24
 	$IP route add 172.16.105.0/24 via 172.16.104.2 src 172.16.104.11
+	$IP route add 172.16.106.0/24 dev lo src 172.16.104.12
 	$IP route add vrf red 172.16.105.0/24 via 172.16.104.2 src 172.16.104.11
+	$IP route add vrf red 172.16.106.0/24 dev lo src 172.16.104.12
 	set +e
 
 	# removing address from device in vrf should only remove route from vrf table
+	echo "    Regular FIB info"
+
 	$IP addr del dev dummy2 172.16.104.11/24
 	$IP ro ls vrf red | grep -q 172.16.105.0/24
 	log_test $? 1 "Route removed from VRF when source address deleted"
@@ -1735,6 +1741,27 @@ ipv4_del_addr_test()
 	$IP ro ls vrf red | grep -q 172.16.105.0/24
 	log_test $? 0 "Route in VRF is not removed by address delete"
 
+	# removing address from device in vrf should only remove route from vrf
+	# table even when the associated fib info only differs in table ID
+	echo "    Identical FIB info with different table ID"
+
+	$IP addr del dev dummy2 172.16.104.12/24
+	$IP ro ls vrf red | grep -q 172.16.106.0/24
+	log_test $? 1 "Route removed from VRF when source address deleted"
+
+	$IP ro ls | grep -q 172.16.106.0/24
+	log_test $? 0 "Route in default VRF not removed"
+
+	$IP addr add dev dummy2 172.16.104.12/24
+	$IP route add vrf red 172.16.106.0/24 dev lo src 172.16.104.12
+
+	$IP addr del dev dummy1 172.16.104.12/24
+	$IP ro ls | grep -q 172.16.106.0/24
+	log_test $? 1 "Route removed in default VRF when source address deleted"
+
+	$IP ro ls vrf red | grep -q 172.16.106.0/24
+	log_test $? 0 "Route in VRF is not removed by address delete"
+
 	$IP li del dummy1
 	$IP li del dummy2
 	cleanup
-- 
2.37.3

