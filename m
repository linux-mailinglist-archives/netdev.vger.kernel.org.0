Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3760764252B
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 09:56:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232386AbiLEI40 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 03:56:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232294AbiLEIzs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 03:55:48 -0500
X-Greylist: delayed 399 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 05 Dec 2022 00:54:41 PST
Received: from dispatch1-eu1.ppe-hosted.com (dispatch1-eu1.ppe-hosted.com [185.132.181.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D8141835A
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 00:54:41 -0800 (PST)
Received: from dispatch1-eu1.ppe-hosted.com (localhost.localdomain [127.0.0.1])
        by dispatch1-eu1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id B4E30163B5C
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 08:48:02 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04lp2057.outbound.protection.outlook.com [104.47.14.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-eu1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id BFA8580090;
        Mon,  5 Dec 2022 08:47:59 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oIxDT/GQ82W+5r7mkWgmumIAK+T2ZuN4L2+0ry98Uig2BTWJ+kx9Xdo0pjxmHOeSPZ2Xv466cKzKpd6tSPrRAhaphVwKw+Se8wMMWv0L3ERAcqqg6Tgn04xN5OYpZuSVFboaaiFfUFezotobszs27VzP6/gSnKXSPU6QwD5YU/2Msr9kj0/nSudQWgHPV7V+W9vT6kh6T4ZZJqi1GzuffZpA7kZk9VcOY2sUf1qa3R7M28TvzSSaW4cxi5nbrGGwHikdXQkwosZy7xq85/xLNmimbgjLlhgU/VXB20EL0Av2a7uplXfOt1UAzhKyjM+fmR9Jaum5wkAiRvkDdrgByA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dJQ53A5TTn1s+wnrXF1FK57q9TmF9LWW3sdhPcAoZGw=;
 b=ksh3tpZcgv1P1dWuv5bedj6nBkSYCtnUG6d7QQDnBgVkaN64dUsIZVIMuMLE4Z2Poejj4YxTN14eS/TErMB8gcl8bsPEON2C7uUGPto8o//U815aRoZ4kG3yv0+JgYBDRtVMeKWKp01qbn1Fz/9v8ykFTeOTkkYpX87n9ZfFTKHNXa47pPe8qWvmqqTQbw1ElIwqPjDWTBGUgcLgTPKVwzpQG5/B7DlD2TGYROa4sq6Hkw2TainbUhqZYpVq82yl9eA00X3m4Sdv+U1WzRMpE0m8TcJQz4VZrk4x3HamaG1xcfYtELnwthMxfGeAd+l1DgBqGD5PyB4llOSxHyqmvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=drivenets.com; dmarc=pass action=none
 header.from=drivenets.com; dkim=pass header.d=drivenets.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=drivenets.onmicrosoft.com; s=selector2-drivenets-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dJQ53A5TTn1s+wnrXF1FK57q9TmF9LWW3sdhPcAoZGw=;
 b=iSK/44GUQz1ZWyzcPPrP5cT3p7FBrGZ3JrWYp5wcGc3dlSjih6WzPU8KTSR+hm10YTs8633EIwiAeaTx3lbKbn0vTWdluVMwi7G/4tSvBpe5kEat0wQIzl4O8pkO9LaVYdmr9UueIxDTOSdMlqhz/fivcgXPhPSDeRUtbN5emyQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=drivenets.com;
Received: from AM6PR08MB4118.eurprd08.prod.outlook.com (2603:10a6:20b:aa::25)
 by DB5PR08MB10255.eurprd08.prod.outlook.com (2603:10a6:10:4a5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.13; Mon, 5 Dec
 2022 08:47:57 +0000
Received: from AM6PR08MB4118.eurprd08.prod.outlook.com
 ([fe80::978d:4c38:f2c9:e40f]) by AM6PR08MB4118.eurprd08.prod.outlook.com
 ([fe80::978d:4c38:f2c9:e40f%4]) with mapi id 15.20.5880.013; Mon, 5 Dec 2022
 08:47:57 +0000
From:   Gilad Naaman <gnaaman@drivenets.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     "netdev @ vger . kernel . org" <netdev@vger.kernel.org>,
        Lahav Schlesinger <lschlesinger@drivenets.com>,
        Gilad Naaman <gnaaman@drivenets.com>
Subject: [PATCH iproute2] libnetlink: Fix memory leak in __rtnl_talk_iov()
Date:   Mon,  5 Dec 2022 10:47:41 +0200
Message-Id: <20221205084741.3426393-1-gnaaman@drivenets.com>
X-Mailer: git-send-email 2.37.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: ZR0P278CA0109.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:20::6) To AM6PR08MB4118.eurprd08.prod.outlook.com
 (2603:10a6:20b:aa::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM6PR08MB4118:EE_|DB5PR08MB10255:EE_
X-MS-Office365-Filtering-Correlation-Id: d682f9f6-087e-46a6-c317-08dad69d6842
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SJznWMjTOc9yXNdpUHwRCpQqEotKtR3L/zY9MqQ75VVqyu03m6zWmU9eyivHQqS0oLldw+HBkKxMf16tXDm3KvA2eo8d7H/KCmg70kLy/s7G7smJyLTIS7hBnyn+jhyvookfFLOAKOFcoB55qpwg12bKxankPymNuPFpc7t3sE8xGaJDI8VDoT2ROTkJ54B40yxEbTDL7VEBYgcLfSMBEAUaDpgb92Ac9JV40d8Dh4ouDCZK2M4vEODo+uZAdvpcT6oLAknkwdjTnZK1XYhzhWI/qwwaMe24HkLCTgeXsB2cJBz2R9IZRL5s8msCJS4qaYVuwn2aI+QCuR9RE2Lw/dHVQVOCNupcSMQ/S9uV9/EEr5ZKM4RiMgoscM0G9JvwMGwK9JcTdOPgW33b7wqk68ye5O51vCIxUvoRe3L/o4ahABzqRBs2KKrIqnLV9QPmrGfYItc9Kdre8HXg5Di1D8qwAeVZAJqb6bLK4e07/01xMwL8se7tTQJRBRLhKvX+Bi0oEVnBL2i0a4zFl/YlgsT4416AkjFGdnTcSaPjUXokRF00RqbgyQwgmcxIsJUmtyYefdsEVncOJeyE602ipKXzc1XLGg6m0kvx1G9cbgoXOjnuDfzpM2Aa6FkIbf6bRWbmASh8MZoCdH3+NzN21c+mrsMwhWWArnmZGlzsNG7JcjNLvSq/RW0sfmK0I3Ug42w9Pfb0qA4DjkLzE1KyHw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB4118.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(396003)(39840400004)(366004)(376002)(451199015)(36756003)(4326008)(54906003)(66556008)(66946007)(66476007)(8676002)(86362001)(38350700002)(38100700002)(6486002)(478600001)(6506007)(6666004)(107886003)(26005)(52116002)(6512007)(41300700001)(5660300002)(6916009)(8936002)(316002)(83380400001)(186003)(2616005)(1076003)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eL8Xo47bKOfsMyPOUblh5e91lQj0YSA93WLmRalOUenVKj7MvtGkWv5kxKZv?=
 =?us-ascii?Q?zNKX3/FR2PyQaSd14aoSPhL7PPQKErjsOTWcKPvrhh0tW6ygNB8ExMmXakT/?=
 =?us-ascii?Q?6nUNQAtGOFHZdkTooEQX60my+HZiJ4rM7JPUmM44lx5zo1z3OQThSAy4TcUg?=
 =?us-ascii?Q?Ct0o/qIP9Kcbvpha1Cvr4gpIn2Wmi+jvPJQyb9Vj/hwH1w5fFQYx8D531t/A?=
 =?us-ascii?Q?5Q69aM3tns/bEp5NazIGBU4GhGZtUjdyRD0ifrXxsCYFzRW2akqAjoHWtjhp?=
 =?us-ascii?Q?WDYZ+ps0MoZucauEyZGoBYdsQTrb1MfMOFd/NaX34I7PIoYYzY93q3LZLxRz?=
 =?us-ascii?Q?4ZIHp4XR08JvR6LMc9G5dWAqo1BQNEc7ncLUhR0ClKc3Fh0Bae7aEGMGUZyU?=
 =?us-ascii?Q?Qm0kBql4sAK9CzvQRejDDyn7oOq4y0QC7Y1/uGw2J6Qz5l9mgAWuv/Od/Z2F?=
 =?us-ascii?Q?2DPsC3DJw2W3He6/Go1N/TYnB2XbVpxvIX87zLI4h/p4D1GNJ4oSo/LFWGRA?=
 =?us-ascii?Q?O2Mx570ywUCOJRUz16+fJSy/XtM8sUX8z01tDPQ/f289lJH+ufUJvJ15v4Dx?=
 =?us-ascii?Q?arvQKmQrFkJYCXcWJXIMfLOssS7YpIvmb40FgfFvXPnsCcQGiEfIa6GM6r5E?=
 =?us-ascii?Q?I5XvfOQ0QE8QDcIkdg+pGzygLz4AX4Jt7TIzF0G4IbmYJU+XMg5HAJP8cufa?=
 =?us-ascii?Q?Ly+OjPRX91mLxwgepXgxQApny4TxDp8VyrAIYLyEPOeyrderDh5RsLPZa7D8?=
 =?us-ascii?Q?iCKOYvLScQfLTHatHy1Yq4KlI2QpkPQV5H5N1K4yikSLYLqwQOeTrsr9B4Ad?=
 =?us-ascii?Q?j02Zj587IlYvXbG0i8r2VWIQ3sxWtBaLZhK57+9bbCc45fX8zUIvk5uYfMYl?=
 =?us-ascii?Q?PXoy2QXDo8Ztq8bBQzuR4VRJqgK/6crE67YZzjXXuZdTFkrcTcDH+/tNqkgw?=
 =?us-ascii?Q?po8TU6MSZagEf3uicYfWbrXrOsczpxqeUJ/ZTCgubySSQyN8mmxu4s+/HO5e?=
 =?us-ascii?Q?I/SHZcPE8ANeSDlOGzLdYnoe0oeFOtk+vQuyCNTOSBLUY8tOD0wwPpWTOm8M?=
 =?us-ascii?Q?BKL/57CqgTIVM0i6wczVBhMPUQKEXO7VkE1YIsEr4fyUp5K/3qIHJSbCk49j?=
 =?us-ascii?Q?5d/+CEsCPu3fU5ExBxB5J3jmFyxjq0GuG8OY1BSNfR77KqHGomAf0fMU3vDd?=
 =?us-ascii?Q?tiSbs/8CvAaC/hjJdCfgFngu4Bv6PKfQWxrtJSLWAdoM1ZSLpzIdzQFC3sFX?=
 =?us-ascii?Q?PkKNQa4+hbsXcrANvIfZ+Rqv/SCt6LO5b28MIYWrKqrxx185amtCEkOkzalj?=
 =?us-ascii?Q?JLTysef1ldWen9S0t4dHNA5VqhXsvAGvUIMkw7ygI93Ei5RQsr9EvrQftcUO?=
 =?us-ascii?Q?+rE88DtXeGeQyGPft1JvhJGUFqWZ7cR78s3gN8cnyYLn3O6F5kmsD/2XNwax?=
 =?us-ascii?Q?fgz0XCXbvuaPQ0PTd7iouAMatDDTA4o8l2GjqKt/h7wBYE2maRuf4oTSiUeX?=
 =?us-ascii?Q?iI2V2zyonIEY0WvtrnBkLLcTgHSQLXuVMb3FqDajGdIjfQgHPDK9u8LsYi1A?=
 =?us-ascii?Q?FAaa4uD25hZ6rfX62fPGPA6OB5uL5Ml7beX6K8ARc51uVivzZsJANAJQ+pN1?=
 =?us-ascii?Q?CA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: d9y3ID1wQBAjv0jotYmZB0vhZfAKy0b/cktU5hM3wnHgMxIl8laXlpDE5FN2XANbz8DwDtsNQU92FNnNLSiDIKVWDPlOCNWnFWgJFk7x92N+rh3zcNFbJhusrupdkL/rkwx2CJII6p99qKtfjYGkrW96Myl7TXYeBh6lOYYPDqig0oMkh5WLy2KHabk/dOPaf/3JL6h7sgOg+ncqmUqp31omDTFcLUxdbZNvfj7lqRvVwu2auCPX7V7otgyKnFWiJ627qM//mTN2+tDLwlq3uv/NflggC2GLmHIkHoFWO5iN5pkelCLHJQSvVEBWWy9lbvrh6pvVx+jrJyrXXrpJ9V3QcmtqIcWzyKgmyxdjdv5dSwR32MgZVH4IeavdYSE0hZWUdDjLf6TvRjVGb80XwG2VUK5B/QJfYBBBbwuSRjPnZ7PkBGTbQyVzTlM1kHCxnXvsfqwExV95c6EFmTnq30XaV37/DqLzN5u+lF/YariTIcGkDY01iu9dLGs88mMkoklrWbfIemQ39SJnmGVHfBAm7/oM+ki9BpswbGT+al048o/bHR8YwihpoN0tdUIzYBe9Ii0uQ2J+81882bck4te5vUMp8BPOse9MiVzZtL9h5LZP/2VbXkg/2Z9lU9QMCwLNGLagxyzZ3YbqhJ4qM+R6KLiKcV48zlZlYzMBLmKPWhqc5iZbmgQ0NLf+fbyVh02IIJdGhgZYYl+NElCvCNHqb+/bcBrAUsv3r4Gyyhzt0BvEVhdByPQBn9AyxsBMC36eVnzy4/8B3UKIPr6KMoP0kNLRwkqFrRYwsbfO37Hxoj0EYXSD/RDixbpmuTDU
X-OriginatorOrg: drivenets.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d682f9f6-087e-46a6-c317-08dad69d6842
X-MS-Exchange-CrossTenant-AuthSource: AM6PR08MB4118.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2022 08:47:57.5480
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 662f82da-cf45-4bdf-b295-33b083f5d229
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cryACDJ508bayw0VNj2dRlHPLq3RMD2a+tjBRHmehFMVu+3Xfaurv4Rmg+OGRFM4BBk5+vBzAlron4MfmnQAAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB5PR08MB10255
X-MDID: 1670230080-LJCtCkHmQXPs
X-MDID-O: eu1-fra-1670230080-LJCtCkHmQXPs
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lahav Schlesinger <lschlesinger@drivenets.com>

If `__rtnl_talk_iov` fails then callers are not expected to free `answer`.

Currently if `NLMSG_ERROR` was received with an error then the netlink
buffer was stored in `answer`, while still returning an error

This leak can be observed by running this snippet over time.
This triggers an `NLMSG_ERROR` because for each neighbour update, `ip`
will try to query for the name of interface 9999 in the wrong netns.
(which in itself is a separate bug)

 set -e

 ip netns del test-a || true
 ip netns add test-a
 ip netns del test-b || true
 ip netns add test-b

 ip -n test-a netns set test-b auto
 ip -n test-a link add veth_a index 9999 type veth \
  peer name veth_b netns test-b
 ip -n test-b link set veth_b up

 ip -n test-a monitor link address prefix neigh nsid label all-nsid \
  > /dev/null &
 monitor_pid=$!
 clean() {
  kill $monitor_pid
  ip netns del test-a
  ip netns del test-b
 }
 trap clean EXIT

 while true; do
  ip -n test-b neigh add dev veth_b 1.2.3.4 lladdr AA:AA:AA:AA:AA:AA
  ip -n test-b neigh del dev veth_b 1.2.3.4
 done

Fixes: 55870dfe7f8b ("Improve batch and dump times by caching link lookups")
Signed-off-by: Lahav Schlesinger <lschlesinger@drivenets.com>
Signed-off-by: Gilad Naaman <gnaaman@drivenets.com>
---
 lib/libnetlink.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/lib/libnetlink.c b/lib/libnetlink.c
index 9af06232..001efc1d 100644
--- a/lib/libnetlink.c
+++ b/lib/libnetlink.c
@@ -1092,14 +1092,19 @@ next:
 						rtnl_talk_error(h, err, errfn);
 				}
 
-				if (answer)
-					*answer = (struct nlmsghdr *)buf;
-				else
+				if (i < iovlen) {
 					free(buf);
-
-				if (i < iovlen)
 					goto next;
-				return error ? -i : 0;
+				}
+
+				if (error) {
+					free(buf);
+					return -i;
+				}
+
+				if (answer)
+					*answer = (struct nlmsghdr *)buf;
+				return 0;
 			}
 
 			if (answer) {
-- 
2.37.1

