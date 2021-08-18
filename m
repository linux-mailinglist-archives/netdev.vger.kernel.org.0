Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43DEE3EFF9D
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 10:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbhHRIxC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 04:53:02 -0400
Received: from dispatch1-eu1.ppe-hosted.com ([185.183.29.34]:47700 "EHLO
        dispatch1-eu1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229676AbhHRIxB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 04:53:01 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04lp2056.outbound.protection.outlook.com [104.47.13.56])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-eu1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 1FBFB6C0027;
        Wed, 18 Aug 2021 08:52:25 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jHJHB4zjqIv/wafKRLts76gbiDOgVSynJUT5gSULMtCNgAv3YkPKXjT4e1tCvN07321CXXLkeGX7ve3qQeUXsLY6X7xDDegeGkJDPKyMsIBc1w4xAoBtUNokzu+gIla2+wOQS/M9OKgjz+iNBH2QxLx8il5CTzoWeeWJtFpKZPYXqmQCRzN0z4sgV8TadvwE1MdjAMRQyeNAjtQiL+G+QptOsrUkX12Hd9ZJteYjB5OkO8O2FM4I36vIiyFU6F4HGfBOP2quDXaIML7twzirbBsmK2drBBDZVV/LwKUA9koVSOLqqgFo6Bx/TB+dcbE3Q44/o5DFBCh6tdp+AcDJzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hERxbXuSyDOsm7XP7jqeg7jDg8CGgXy0mmhjpmHuiyM=;
 b=K/T1ihqQevoFhX0sYYJzaVZmNqXAU6P9tOELABmlNTp3ZJ2eoqhUltAJ71NoRkaDAaFU8VIv8bYxr5YVKwa7Woifzotxaf0fOghzquLFiYvdkcfnriDywi9FNZbQEs/QTwGRCD2yNoV/AH5DXe6AcR7mGyxrvhIuAUpvvoMdu893R9eC/FpD2bj0W2nKvwPG5X3rlz0lCIcdMKbNLXoTV+PuUaWUylB21TfS1X5dsUZDX2DKWdX0pZix7ZlsYzszpbDsFa5sun2H6yAFcLzzP8FiEAVtG8wZI2Xk6W6VdUUQNHHgv5amRTlfgXPSNuwjgY1o9E3sdnWRqRoyOxilww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=drivenets.com; dmarc=pass action=none
 header.from=drivenets.com; dkim=pass header.d=drivenets.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=drivenets.onmicrosoft.com; s=selector2-drivenets-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hERxbXuSyDOsm7XP7jqeg7jDg8CGgXy0mmhjpmHuiyM=;
 b=u+c6JT6Zekh8BGOHVoXKUP6fQUvBs6ldxbia3e57nKarbVGRplrseKaAyMeDUtrC3kKwZOxI1uKQn/76ynsH8LqSK/tyzkmq052Oylz28bBv7u39XSB4Ysi/hp/B9M5GpH50zyipENTTAAdHI6EmWXyE0j5M31NnqGotnFjUQJQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=drivenets.com;
Received: from VI1PR08MB3518.eurprd08.prod.outlook.com (2603:10a6:803:7a::23)
 by VE1PR08MB4926.eurprd08.prod.outlook.com (2603:10a6:802:a9::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Wed, 18 Aug
 2021 08:52:23 +0000
Received: from VI1PR08MB3518.eurprd08.prod.outlook.com
 ([fe80::cdfb:774a:b053:7b]) by VI1PR08MB3518.eurprd08.prod.outlook.com
 ([fe80::cdfb:774a:b053:7b%6]) with mapi id 15.20.4436.019; Wed, 18 Aug 2021
 08:52:23 +0000
From:   Lahav Schlesinger <lschlesinger@drivenets.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@kernel.org, kuba@kernel.org, shuah@kernel.org
Subject: [PATCH] selftests: vrf: Add test for SNAT over VRF
Date:   Wed, 18 Aug 2021 08:52:12 +0000
Message-Id: <20210818085212.2810249-1-lschlesinger@drivenets.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0429.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a0::33) To VI1PR08MB3518.eurprd08.prod.outlook.com
 (2603:10a6:803:7a::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (199.203.244.232) by LO2P265CA0429.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:a0::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Wed, 18 Aug 2021 08:52:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 75052eb9-8989-45b6-229c-08d962257ec9
X-MS-TrafficTypeDiagnostic: VE1PR08MB4926:
X-Microsoft-Antispam-PRVS: <VE1PR08MB492627F71FFDA56843E261A7CCFF9@VE1PR08MB4926.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:483;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AqT8taKBw694efcI9LvgKgxmHuHmBNlR6wyhkEsUx18czLqakemBHcgv9Gofmz0XLfk6gWK9VJ9f++fwfJnO8vTGcRAMj5ocLK4bC6/x5tr28QPnzSTltESWkzgbIR9CzhUJ62hW2KZr3A2isNz3lW0IixNAIfzfwrcgovlVONP8XKcE72JkkXOw56xNByuEajQTQr95zvd4rsfQFJjUS1iRUqEWwHiDS1+enMk4BgFpv8+bjTRa3b25/wbF3rCuE1+kKW4BsQ8EUUreZsUoAJI8fGrvnzZM6YvH0FptDyObHJpH+U5TRe6loO3myBLvYWS4KIz6FC/67w0Z82Yyze8svVZ5rJh2LeIRMy6Slq9tjHBHgzavIwMQjI2BmNxxjfZP5/iJkwAJnaAmUJ3Y2lT/Jx9pYkXm73x549j7JrF9oFYLfhPiZInhfoALX0vNHQc1N5QU6ZB3RbES1pQqddPjrZL6Gu7BecOCBfNW2OJj9IO0QxyTcede3yrNHBruZtyVkxjtT/Id7HrIJy11G/9oDDQnE7BSvZoTjlsMcPJHSH6ulBya/I/nbf4G1MO449u/bhY3ogiyKUr1c7PtU6p8kJDZDSmyMxqPyCDPwkWLaj46jTPy9OmtO6GLGMNVQAc+ZCd2aRYyVI6zHWVmX/ClifrReId1TqwCyFZ1Bhh+5LLg5ENJS9xxDhY5kaek
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3518.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(376002)(39830400003)(366004)(396003)(5660300002)(6916009)(66556008)(478600001)(4326008)(66476007)(52116002)(26005)(6512007)(2616005)(316002)(66946007)(1076003)(6486002)(956004)(6506007)(186003)(36756003)(38100700002)(38350700002)(8936002)(2906002)(86362001)(8676002)(83380400001)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZSEzK9nLaCk74gO9S0D1v+JA+Y9I5/Dqj0V8/sXB+s1XW4qt4fmXosMgdXuE?=
 =?us-ascii?Q?yynOVAOQ5PbTXq7wE1X1a55A8ZUaU7yudvWqU3bV4y1xPg/cwPz7OSLmwRLW?=
 =?us-ascii?Q?maLuvjj8buu8GiMaSCPuvjwOowmi0y6WYCd7a9w9RU8AAjSe+WIf0ylnsf3m?=
 =?us-ascii?Q?ytfbuTepmW67CrsLVazEiY67iVGy5O2xr5Y7PFhXVFpolJovsGxPSEtytxD0?=
 =?us-ascii?Q?/ZdSESZBzcrT2lN0eq+X3P/Je4Lr5yDY3apLAlkY/baEE1ScHn0rgZE8/zJi?=
 =?us-ascii?Q?jsDDarJqYn4YU/5C/x/LlSxSzuRh5GQjDmUuPK12dFYaUKxcZdBP2gvXQhis?=
 =?us-ascii?Q?q9qMxnKU8ZSDgABYrH8d4bXpsHVK9BMZCTRZfnj0nhlMM0bxC+ayATSyb3+r?=
 =?us-ascii?Q?vHMl4T4b4PUxo6TAFX0sywOE+bpzLWygQja9bTdvz380mxMytOupPQ897njN?=
 =?us-ascii?Q?XlZZ6BG/bUJBO46DOV5nwEN3YDKlkROtNqpbkfzyHRTy2YNU23CYxYjBvXTT?=
 =?us-ascii?Q?ntuaK5a3H4TExVBiRJjiy8zvrkUwxq0mKmu72bkl0V9ij516DaZ2YUs0+Yt8?=
 =?us-ascii?Q?prFjOxSCt//ElBGrUVnt/bjqd1NGye1QyPsprkERJ1OGx3U8IlE3FoeHicvG?=
 =?us-ascii?Q?7fdrHisjGARRaPLn4l2L/vU9UXK9NgjOcl05BMkHkCbvyb2JxR7HJZpUOoli?=
 =?us-ascii?Q?7TZmFyEy80gBe4xCGnyBsza8sZ1llhmredc1BcKgceI8GTncZsX/SbVkAMIz?=
 =?us-ascii?Q?5CvbVQIitxosM8cEB8KACKpsXPx/Aw5imIPtRB95lwRbhPDF3MZZvBxprlhm?=
 =?us-ascii?Q?LfTZvB4Nawqy1fjRXJ34LWQgXNHXFYaIgpqabaluyE59r3H2W4m1u+BakxFn?=
 =?us-ascii?Q?UyJ6nKMshALOn2pMeNtpYBwWmIHbiFFQQZzVI9mVosTF59KBPWDGwXA2kr43?=
 =?us-ascii?Q?zmxDe/4FGr/j/12OUA+tMizP0pQiJ2QH3bgl7hVuo5tj9HvipRhsKptHWfup?=
 =?us-ascii?Q?DxLOqit2FCieupyy8+lNuF7FjWD7SMTLzXIcekNhbfmHau+4YKFAnQrVp19G?=
 =?us-ascii?Q?/JJzAWDLVo5vMVwYD/AJ1gsID1fl+2i0qKXgVpjznCCHRVyY2q1RDDtHzVw1?=
 =?us-ascii?Q?/Fn3CH+FZ90YFvKHu/d//NVBwMSTm80n7w6JiKb3BnUKhQYiijkB5jVMKnxx?=
 =?us-ascii?Q?vIe/cf0g5hLQVYfuwNysDguVbEHBtTSjtt1PQNtYiC02c3k6MntSMkTRedFW?=
 =?us-ascii?Q?GM0RERmH6i/XSluZxunlGvedNnriUqKCibfV9UQEPhfJvQdgA9NUuQpkx0SS?=
 =?us-ascii?Q?WA9FgGPlw+wrdLiHEzDhTW+X?=
X-OriginatorOrg: drivenets.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75052eb9-8989-45b6-229c-08d962257ec9
X-MS-Exchange-CrossTenant-AuthSource: VI1PR08MB3518.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2021 08:52:23.2267
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 662f82da-cf45-4bdf-b295-33b083f5d229
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3LgPpXvq989oRh7zuXclL1q3dGoNZNKGrHgCfwiYA1UqYoQvpgR462Jl/UaBLwai9PvI50OfvZmfkQ2UqqIB9Yg9naL+JGQnOTOPCTRKG88=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB4926
X-MDID: 1629276745-tTQjYJdCQnsS
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 09e856d54bda ("vrf: Reset skb conntrack connection on VRF rcv")
fixes the "reverse-DNAT" of an SNAT-ed packet over a VRF.

This patch adds a test for this scenario.

Signed-off-by: Lahav Schlesinger <lschlesinger@drivenets.com>
---
 tools/testing/selftests/net/fcnal-test.sh | 28 +++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index a8ad92850e63..162e5f1ac36b 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -3879,6 +3879,32 @@ use_case_ping_lla_multi()
 	log_test_addr ${MCAST}%${NSC_DEV} $? 0 "Post cycle ${NSA} ${NSA_DEV2}, ping out ns-C"
 }
 
+# Perform IPv{4,6} SNAT on ns-A, and verify TCP connection is successfully
+# established with ns-B.
+use_case_snat_on_vrf()
+{
+	setup "yes"
+
+	local port="12345"
+
+	run_cmd iptables -t nat -A POSTROUTING -p tcp -m tcp --dport ${port} -j SNAT --to-source ${NSA_LO_IP} -o ${VRF}
+	run_cmd ip6tables -t nat -A POSTROUTING -p tcp -m tcp --dport ${port} -j SNAT --to-source ${NSA_LO_IP6} -o ${VRF}
+
+	run_cmd_nsb nettest -s -l ${NSB_IP} -p ${port} &
+	sleep 1
+	run_cmd nettest -d ${VRF} -r ${NSB_IP} -p ${port}
+	log_test $? 0 "IPv4 TCP connection over VRF with SNAT"
+
+	run_cmd_nsb nettest -6 -s -l ${NSB_IP6} -p ${port} &
+	sleep 1
+	run_cmd nettest -6 -d ${VRF} -r ${NSB_IP6} -p ${port}
+	log_test $? 0 "IPv6 TCP connection over VRF with SNAT"
+
+	# Cleanup
+	run_cmd iptables -t nat -D POSTROUTING -p tcp -m tcp --dport ${port} -j SNAT --to-source ${NSA_LO_IP} -o ${VRF}
+	run_cmd ip6tables -t nat -D POSTROUTING -p tcp -m tcp --dport ${port} -j SNAT --to-source ${NSA_LO_IP6} -o ${VRF}
+}
+
 use_cases()
 {
 	log_section "Use cases"
@@ -3886,6 +3912,8 @@ use_cases()
 	use_case_br
 	log_subsection "Ping LLA with multiple interfaces"
 	use_case_ping_lla_multi
+	log_subsection "SNAT on VRF"
+	use_case_snat_on_vrf
 }
 
 ################################################################################
-- 
2.25.1

