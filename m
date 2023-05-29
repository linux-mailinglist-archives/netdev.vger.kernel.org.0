Return-Path: <netdev+bounces-6172-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 21752715070
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 22:20:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D0FB8280F41
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 20:20:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42D3E1078D;
	Mon, 29 May 2023 20:20:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F7171095E
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 20:20:15 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2087.outbound.protection.outlook.com [40.107.223.87])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C073ECF;
	Mon, 29 May 2023 13:20:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JIuNgd1RZ+K5dj3WDMfl8O9Tx/CBR4W7qqPTZP0k1LYrIr0GiUpTSCLNl85uCnsKZW8gX5N+eKhg6Weu8zPH4ewXSoxcQs1kDXq8swAo6tKe9Y3AQyVmIDS9WDQzTkxc218QwFa5r6bEFNg7z74WcTpS6n2j/rjjkrRDevc9dMWDskquudgZcR48OmofWzmloK4ZyrwLOMR2CUniUjiOog4fShldru7zDKV9AIJ8iFGcMqmOnAP/U+dmNqSErZs5DsqDE+inWUuCBJXnbXxowPgeqtFA6f6bz3+GfSjRf/ZmvWgAeB6z2CjlrWmujs6FaRZWjc2Lkdbd+ihv3zRq0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CYPOc4jHoOnhTksCmck1pUnMPVCpbzWb7C5IJiae5kc=;
 b=PpvHPlXnWfd7E9R+gs5MW22pnblbilRR3BrOzsldVfip3FmO91IPujDiIn5/OqiLJliJNCbAEXlJ04s/NX2D93R+qXNTr4gC1MjAR7LjMaTiDgECQwjqZD+OveFMn4KONbOlxeHRjMG51rU5OC3ZuWQUXjvnkga9MGxTZ/Ho9iVejdaKIZS7vYoJk1hijqJkJdrCJH0rNARYWvoqW1ZoWiWKuLvoRJkUY37rZ78wDOvXcpD0z6zkyaGJ/av5sKjIyf1tp5yGfeaWVgFMdgwvaC4wRBW3EMcjsOoc0mDztZYxdIp59RvgxdOgrx/sY8ogs0/jLSqZ/FQQA184fmipMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CYPOc4jHoOnhTksCmck1pUnMPVCpbzWb7C5IJiae5kc=;
 b=S/ud9TMD2Fz0ycUP3OTIigJAoaiaOjKGRvv8htA7KaN8dTCD72EONW15zftz/GMRu+qh3Yc0xFtMmPgqBsD3e7BqRvI/r25EXz0cet5wBfMHLobIZxH4TzDQOYmm7wUpkSFUPM141hK+dRt6NVTznI2lYbLrwVq30vgFJ+lQyUgGDf9HpEBVLZz5kfKIhtX9SCVd8ZQooXG0R6HEO4m3H/syf+AmWHvOznUh+7n74fipBE0m9j922ux1hXxkllSjB1YkSpEREKBPukdlZYxMl1d84SGwlaDqX3Q4DM3B3ndRRDfh41Z5fQXn0wNJSoYkHFtNtF65fXIVSq299TFkHQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4373.namprd12.prod.outlook.com (2603:10b6:208:261::8)
 by IA0PR12MB8254.namprd12.prod.outlook.com (2603:10b6:208:408::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.22; Mon, 29 May
 2023 20:20:12 +0000
Received: from MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::96fe:2d5b:98bf:e1da]) by MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::96fe:2d5b:98bf:e1da%5]) with mapi id 15.20.6433.022; Mon, 29 May 2023
 20:20:12 +0000
From: Benjamin Poirier <bpoirier@nvidia.com>
To: netdev@vger.kernel.org
Cc: David Ahern <dsahern@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	linux-kselftest@vger.kernel.org,
	Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 3/4] nexthop: Do not return invalid nexthop object during multipath selection
Date: Mon, 29 May 2023 16:19:13 -0400
Message-Id: <20230529201914.69828-4-bpoirier@nvidia.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230529201914.69828-1-bpoirier@nvidia.com>
References: <20230529201914.69828-1-bpoirier@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0255.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:68::16) To MN2PR12MB4373.namprd12.prod.outlook.com
 (2603:10b6:208:261::8)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4373:EE_|IA0PR12MB8254:EE_
X-MS-Office365-Filtering-Correlation-Id: 47993212-8973-4c97-01ac-08db60821b0b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	q4XqoK8/ExjvdbqJ0qiG6ci0/WfZa+hBfSerOsrC4DViWiAA3vLGNlaDv/oOMmWaaX/xqRiJY9oYkSvY/Awg3gD4ZXfkMKTKL5XRmbESIaFEsX1XlecPk1AkCSo6zXLXFMmteJu+BszJ/pkF0xDbeKpafU7sDTpD4lZfRiWoKwZE8Md+fdmot5WxiA0BBJfxAYmbcRDaxKHHko1jofagnO0J/i1QmG2FPq6BgoUu9EUsISFQAQQepkwHql63phUcP69+ezIAm5co5jmDVDqmXxo9azVmdx5VT/3V1KVHspkHyJdlx3Ppg21+QsPer6wAcib1/Lts4JDv112p4hXTjbfFxKdV1oInOhLkK5eYMZ8kPd1Pe6xTZoO3HnFW5DPp8wN8xyuF55tfdbigniVApXefGPN7adoKrndu4g9LuQUNS03uQhNB24/FQNgTeJkZozc6HZxMXV7H7R3Re+mJMwp/82dC/kWsaHMir5AEtmoOr6wMQqcH1vQTl85s0kOvU0JzhcKA4l/tOCTd6BpiESKabh46qLf8S2/sloDqpRRQGn/jGfKbZmxStH6UEF9P
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4373.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(346002)(396003)(376002)(136003)(39860400002)(451199021)(38100700002)(478600001)(2616005)(66556008)(83380400001)(66476007)(66946007)(54906003)(86362001)(4326008)(6916009)(2906002)(6512007)(6506007)(186003)(6486002)(26005)(1076003)(316002)(41300700001)(36756003)(5660300002)(107886003)(8676002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?EIjDcq8LUAaD+7CJq6vcAshNPj34OnPBiI0m3EImxtfrOyLKBBPv1ChqqX0P?=
 =?us-ascii?Q?uthu9P8WFjZTAPGmEmA+tuF+/lweSadsBq+PxoP3XD5TqNbb7Y7fDehcpOIF?=
 =?us-ascii?Q?MGjto6JJOaEeU4rzrg7ZVFsXzjbpS4h+1WccP83JqqbWIXxNKZo3c3/4mPY4?=
 =?us-ascii?Q?wxMXpUleNegGxEjHX7RJLPlbs0wH7/0/uvMxJ57r3MlTL6CzK+zl3B9soKhs?=
 =?us-ascii?Q?7NMSOYLQde9BG1ldmhayPa/BTBJpNSDJJRA6fGoau0xKw9gKB5lrnB8EO0Xx?=
 =?us-ascii?Q?2TkwkzJbXwW21MwEXJrjXwHsRzm1cIM/FB1h4aSMhEqo/y3H1YiPhiVP9fdC?=
 =?us-ascii?Q?mrMjTJ+aR1mEbQXBTCoLSwB/D5eZ3JXJmpcVqxWg1cQfHqlNS2vPiGLt5q3Q?=
 =?us-ascii?Q?JY0JCuYiS9UpIuSPCCbpVyDIx0UTKpu++H39aNTf69qNxRgjQjJfzFiTNcEg?=
 =?us-ascii?Q?IW4QHfGJl77ZtLWU7yVh+HPjuRTKWU5IwYCB7M29UyF3uTG7Uzh3CGg2W5cK?=
 =?us-ascii?Q?ou1FXYcSd10CCDr1kI+O44cgUIbUecAGCX1g5OOW3uHmD5ydfYA7sNMohqOn?=
 =?us-ascii?Q?4l/DbL3X3p5i7toMWk6RzYBzqzxM8uvInFZvCydDREwb4l8ufQBvs7zDnDRf?=
 =?us-ascii?Q?oeg9vv/pOX6VqCIa95tHmN7ZECJ1X1+7k8owrBaa0nC86/Ym1iP0INU56qJS?=
 =?us-ascii?Q?dogJbMf4ipMonYmnOZeZfq0BtbLHZsB6m+f3JlRLcjogB7VIY0jHPWcZp8zC?=
 =?us-ascii?Q?/y2ChcIJc4aA+Q8DT9xkDsCOjhj7sNP7gfAiAdJi0Pg6oVfiRfVzkH5yojBX?=
 =?us-ascii?Q?nhYCH2kwJyLsgwqHjRs/xsydns5jXLndoU9DDh65VJbfIhSUDL6AWqJ5AoMh?=
 =?us-ascii?Q?2dODVkx5/UpBRQA0TgWNa8wBDwBOi2IH+KRafv4A1Ov3oWWFa7RXqhP/F+JB?=
 =?us-ascii?Q?7nyXc8uuuBAyRAEYgJB2rWa2XExsHBA39AxisW8Vc0Cy/QFRkxTwEheW0xLW?=
 =?us-ascii?Q?BkI3R8mxmj+1BLONC03cN2CxJknDTELqVbTbKahAlbrHniwlInGTiY+XdZr6?=
 =?us-ascii?Q?xp06/J52rGGtNCNCC893gCuJ8GxWYRLkCbOOASZH4UDUawXtSWkXnnq3gWVt?=
 =?us-ascii?Q?IRqtwqngTRL4p7x+R1zVtAgRHGYCXVnVJqpkMxrU1hv8TxDWMx3P84ka7Mek?=
 =?us-ascii?Q?6ayJh+Q8mjYsSfJiEmmKVadZeM8rBYNuIPSaxe+ECp1Ad9mCASsxhiGwxioc?=
 =?us-ascii?Q?1B4pDzazW0kRtdZV4s7EcHIMK0l2Y59/6netudk7M06KvXH4D9jukeI0ECId?=
 =?us-ascii?Q?0Z5AHQmasCdYOWOAMXEKa2vh7GmF4B7f2m/Emss2LIZ+BDDD2EJ+Phl1sO+Y?=
 =?us-ascii?Q?EUxeg9fK//qlCwfBL0DCChTH/pIUiMyPaA9M4dbIUxOYZE/KWsM5UHys/zM4?=
 =?us-ascii?Q?GuqedqkGfNhJu99nsLRzQcRbUCqXjcBd4lqlptWSxssc50edIyFZq4gqhHSD?=
 =?us-ascii?Q?n2IsQHVxSOKlLDiU6BKl+RpeAtLXB18X86bcqaG3VRpJPrIb2bh5i0EK7RKe?=
 =?us-ascii?Q?fDzxen1geyNr05UBjLq6TTHww2QmNLnMrVdLGUvs?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47993212-8973-4c97-01ac-08db60821b0b
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4373.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2023 20:20:11.9932
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MNipSiCg0pIbI/KGA+Z/Tge4tqgBRw+fVsDHRmNdxAOslVDGa9OeUP82M0x8e4AhZ8H/oR6k1YYhv0bybR7KDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8254
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

With legacy nexthops, when net.ipv4.fib_multipath_use_neigh is set,
fib_select_multipath() will never set res->nhc to a nexthop that is not
good (as per fib_good_nh()). OTOH, with nexthop objects,
nexthop_select_path_hthr() may return a nexthop that failed the
nexthop_is_good_nh() test even if there was one that passed. Refactor
nexthop_select_path_hthr() to follow a selection logic more similar to
fib_select_multipath().

The issue can be demonstrated with the following sequence of commands. The
first block shows that things work as expected with legacy nexthops. The
last sequence of `ip rou get` in the second block shows the problem case -
some routes still use the .2 nexthop.

sysctl net.ipv4.fib_multipath_use_neigh=1
ip link add dummy1 up type dummy
ip rou add 198.51.100.0/24 nexthop via 192.0.2.1 dev dummy1 onlink nexthop via 192.0.2.2 dev dummy1 onlink
for i in {10..19}; do ip -o rou get 198.51.100.$i; done
ip neigh add 192.0.2.1 dev dummy1 nud failed
echo ".1 failed:"  # results should not use .1
for i in {10..19}; do ip -o rou get 198.51.100.$i; done
ip neigh del 192.0.2.1 dev dummy1
ip neigh add 192.0.2.2 dev dummy1 nud failed
echo ".2 failed:"  # results should not use .2
for i in {10..19}; do ip -o rou get 198.51.100.$i; done
ip link del dummy1

ip link add dummy1 up type dummy
ip nexthop add id 1 via 192.0.2.1 dev dummy1 onlink
ip nexthop add id 2 via 192.0.2.2 dev dummy1 onlink
ip nexthop add id 1001 group 1/2
ip rou add 198.51.100.0/24 nhid 1001
for i in {10..19}; do ip -o rou get 198.51.100.$i; done
ip neigh add 192.0.2.1 dev dummy1 nud failed
echo ".1 failed:"  # results should not use .1
for i in {10..19}; do ip -o rou get 198.51.100.$i; done
ip neigh del 192.0.2.1 dev dummy1
ip neigh add 192.0.2.2 dev dummy1 nud failed
echo ".2 failed:"  # results should not use .2
for i in {10..19}; do ip -o rou get 198.51.100.$i; done
ip link del dummy1

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Benjamin Poirier <bpoirier@nvidia.com>
---
 net/ipv4/nexthop.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index c12acbf39659..ca501ced04fb 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -1186,6 +1186,7 @@ static struct nexthop *nexthop_select_path_fdb(struct nh_group *nhg, int hash)
 static struct nexthop *nexthop_select_path_hthr(struct nh_group *nhg, int hash)
 {
 	struct nexthop *rc = NULL;
+	bool first = false;
 	int i;
 
 	if (nhg->fdb_nh)
@@ -1194,20 +1195,24 @@ static struct nexthop *nexthop_select_path_hthr(struct nh_group *nhg, int hash)
 	for (i = 0; i < nhg->num_nh; ++i) {
 		struct nh_grp_entry *nhge = &nhg->nh_entries[i];
 
-		if (hash > atomic_read(&nhge->hthr.upper_bound))
-			continue;
-
 		/* nexthops always check if it is good and does
 		 * not rely on a sysctl for this behavior
 		 */
-		if (nexthop_is_good_nh(nhge->nh))
-			return nhge->nh;
+		if (!nexthop_is_good_nh(nhge->nh))
+			continue;
 
-		if (!rc)
+		if (!first) {
 			rc = nhge->nh;
+			first = true;
+		}
+
+		if (hash > atomic_read(&nhge->hthr.upper_bound))
+			continue;
+
+		return nhge->nh;
 	}
 
-	return rc;
+	return rc ? : nhg->nh_entries[0].nh;
 }
 
 static struct nexthop *nexthop_select_path_res(struct nh_group *nhg, int hash)
-- 
2.40.1


