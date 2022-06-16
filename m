Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1231854DF64
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 12:45:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376498AbiFPKpW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 06:45:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376576AbiFPKo5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 06:44:57 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2087.outbound.protection.outlook.com [40.107.212.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D847D5DD03
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 03:44:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DSPletLT3DAYBq8rfgPybfjC8OffVRvhbC8eKKvtmj0Y/Pbo3aaxJXwWpP9DOjwLwQGtujDqtltW5OKKEK+yN+AwndXTvA/I5pjU9GK/TsDOaFef5q0X4KlJgpyxbBNweGuThcvS7+yXuvJWz+FUAKm8tHjQJYaK5w/z4MEUAk9Q8a5L+J1OHl8EqWkuI+QL/2Fp2vybptqAHi/NJ1OPLFexHuLqRLPuAxinhF+JA7DRrk0coYglJby4Epw1YmPjWpOiCQa1R5BX5+ZaeOxr7sg0WyGIjqWOvzxyUywxqCfn7scyg2xhBECK33RMhTvpBVchqp6+zXqm1ujYmYro5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tcus+HX71PrpRvH5u5EA6mRwMnHkJwturuzrPet+PPI=;
 b=jPX/kVUG40HlQweq1webiHgWVt1HCzD3UGXPyQnFDaV7s1WdF20wp64O5NBhc1PsETpDP5iTPjCzluuTnpveXUt55T8RtBMBaWLEPcrGGNCQKCqJDNwEXK6OIz5FdtXeSnc97A+QtkXK3jE0p2OTqTFSa3+i1mqbFmjtmmMHqiylDoQWBRZKOjVwqMSFfa5rnoLNIN6CY7T/htHMQcDnxNqCnFbnqWTEXeuedh7q9ycgroA5x0vym47D9XWtIaBal/LLAzBasQdCUrFRAXk0lE1J1EM/ZTGe88hT3ofUbs6lKc3QX6h3L/AFele+LXadZ3rGUOnqNim/RqfjMeGnBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tcus+HX71PrpRvH5u5EA6mRwMnHkJwturuzrPet+PPI=;
 b=HWftp57cQL1TJt0Qvps8X2HbEaCje4AHK1NlHL626jwadHCdnACzTKE1bJ4ePgeCplyN0qms4DLeyNQ0dveg6N1iQuGz1xdIR42N2dQpfGeEY77tD4i742ymmrmzPSz05YBueWxKclvRisheKNmvJZA9aqELYx58wpQFEsfXePiyMfM6KJUVaTpWioceqZ+hcbeAMp5kn3Q5af99ppwAB05xpvJp0ErAvUioVzWGs0IMQbcczGUa3EoA4PgS1E3/l1ddfbVTeEBTjlR1iiZN6jccffm+AsefYlOaVDi5Eh/bsdIsmuTqLM++AOGZ3ODSh5rABUYQpS2XhIe7BIM9Lg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM5PR1201MB2504.namprd12.prod.outlook.com (2603:10b6:3:e3::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.16; Thu, 16 Jun
 2022 10:44:34 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190%9]) with mapi id 15.20.5353.014; Thu, 16 Jun 2022
 10:44:34 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 11/11] selftests: spectrum-2: tc_flower_scale: Dynamically set scale target
Date:   Thu, 16 Jun 2022 13:42:45 +0300
Message-Id: <20220616104245.2254936-12-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220616104245.2254936-1-idosch@nvidia.com>
References: <20220616104245.2254936-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P194CA0058.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:803:3c::47) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 488ecb79-a8ed-4f2f-a2be-08da4f8533f8
X-MS-TrafficTypeDiagnostic: DM5PR1201MB2504:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1201MB2504024DFB36529526CA47FAB2AC9@DM5PR1201MB2504.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pcFozT9ZQxM64ZCjhpQUwl6wrwGlD8r6ne5RINmgI5eqD5+BXZw7LemLgD3fow5CgcbxeJayK69z6T0VcEiukOBwieSTyolg06xiclgWjn1CH6XwLR25FI4NwU9+a1xcOUlYYBGg9ezp0ovXAXR/Yxjgo99qi30HNf8hQHjHt42byjeJU2MM9FWDAroV/7psCMr/dGwo+BImNL5ZzrV2yQOsSQuJ/9cK4NN07I9HuL2C1NbOIU7NtsBblE1jBBvlVxVPWIGaeQW7u5mmrb+4zYkXHAAxC12n1k9zSlRnO/nF9due91PPq1ioVsCIQlIr+vYtQXRgT01g/NoqqoWwUkP7bXXJ0yOMwejcvoAB0C0MPbpvfHuAjhae4pqzMzOdyLNIhOMQ9VcBxQfSe1M33oKOna8SQFT5ZBnfgkAZ2K+FS15y80GWOkF0XgfbhoCP9E4tsuTl1QQh/vVH9lu3HSafID842nFb2lnV74rUvwod6RHYWw6b8OXrBZOd6x1u24NQR6VcKvyJDIUKUtxt4+fUKEK/pSbLvINWMKD19OsWD0C19qVFHj55E1elRDY58jorayMIX/JFCIKq1GQzd9F6mcwGQxFaBTimHnvqtH0HbOEddf3J+KPFpvMnwAv7H16neJZd+6kmtWFyToKzHQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(107886003)(66476007)(6666004)(83380400001)(1076003)(6506007)(66946007)(6512007)(2906002)(186003)(36756003)(8936002)(5660300002)(86362001)(66556008)(8676002)(26005)(6916009)(4326008)(6486002)(508600001)(38100700002)(2616005)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PMkJYIT9unebyw175vMqKdIcBeEMuZD4maOK0fDlgjq1CoUNBVKsK+DfDZw9?=
 =?us-ascii?Q?+RGwX6OvLCstqaTMvReBoC5xvW85j4y6WF+eUQjpcjt5Dl8owz/LLELh2Kzw?=
 =?us-ascii?Q?Zrq7FmZEyKeuf6jjuiEzx3Xz8156/PT80MhsJ92qZhD6jc6w1n/z28E53PoK?=
 =?us-ascii?Q?JsZjj0Guuut+j1qnkwtbcFXvaZ+Sb2zrYvQnGztkXfOcU7obixQqbx61T88m?=
 =?us-ascii?Q?ZofSIVvvYXBZL0Sz17xfkPvmbcHAyFChaG9fOntaNx6KQadcTMl2VVd2xqkR?=
 =?us-ascii?Q?VE8KqLtO3UUJMUP9j2+ZfUuq29EE8SHKI8qt1D5OP91y9A57kBmyBg+EyaRa?=
 =?us-ascii?Q?1iYbDx3w5d8j/wS1oxhIeev/6i19p0lJB8Awi39JyQY32YDx1Tsop4FNxJA+?=
 =?us-ascii?Q?/c/tb13bOlJkd6/gQrhEsGM0Yya0Hi+Sj57B1ZQb85n5Y2BpBQ6Z/xbt7Z07?=
 =?us-ascii?Q?CPxC+uFVdpWOGmoGak+9SnV6amSmIWSVZ0DmaBEw4gybXDCgYBbA+00RW+Ws?=
 =?us-ascii?Q?QnEwga8OJtlapPpYxcQrU+KwizvU6wGFHLpuaS97dMdGmmGv08sXghHLSgSD?=
 =?us-ascii?Q?BYvfPWSvNjKYGnhyHzZbGCEa7KXmKDltTa+VfIQxR+jzbbk93loEPqqLtbOx?=
 =?us-ascii?Q?AiXFxElyVHvwKiX5YP8SJTY2v9hbk3EbolfqfwfpfyJYkl/JKI4ydRrsH6wa?=
 =?us-ascii?Q?CVn2p+ZQ4Qv007rpxWlwx6dhsq8pHKMqu1vCuepVmBiE7wL3scjyx60fkvUL?=
 =?us-ascii?Q?CTkobJMrL/mHhPJEU8zEk+3qzGN4Ux2xvpbLby/1f9w4max0Mgfs3yhK8kL/?=
 =?us-ascii?Q?oVCD9YB4OCZ1rqwMYB4FvgT1yLr/dAlpQlF3FUfWKwhXsdXSjBTkZRgFmNsy?=
 =?us-ascii?Q?4+0LVW5S82UUUopzNlt1E5jXTGeJOgpYDYsU19OCffXYmVgFI2l1GU8hSRw5?=
 =?us-ascii?Q?IS5OYEyAi7y/Hn04L5TPj58z0z6ORi7gNjrGMAVsRCmZGapxdf5YoCTEEChr?=
 =?us-ascii?Q?5F4DnCRSMc3AMATjRkbekQRgYOFryg2dDz2S2cjYk/jdoKdDC8Jp4ta7aHsJ?=
 =?us-ascii?Q?v+ttokW30KqxIyLHxqrHt9GCVVnDc41Pm+PMVQxpCrH8pzlQzQbB7dHRJRZP?=
 =?us-ascii?Q?1oD1+LkrbBg01Mt4U1Ns1et77w02UFfTLugzHMtJTVZVPq+Wxg8YM5P7kYOC?=
 =?us-ascii?Q?NqaJUTLu4XErHak+yp6UDRk2u1wqzHlY7Uqa3FjSAYotjBdHJ2qe5tryIGTD?=
 =?us-ascii?Q?llLoCyE6JfjDr2WcefNwQ4uauRQikL1QFD6bABwwC7mxqCdSo4d/gWFv8wMw?=
 =?us-ascii?Q?xEY2/fPt8bOfAI9LG6gq1oCF5ohLDJOEdVG5hev3WY8Mz5Qz81SkgSTutnBj?=
 =?us-ascii?Q?I012mbK5tXNHqxnuk8ZZN7P9NPugv/j/gkFOLaBX67gjm8+6z3FpdLxX/7mf?=
 =?us-ascii?Q?GlFXbV6PSEoSWiBv3Mwys5fF+ZXJwvBU2Gb44nr6DTXcztKGW/ldV9tN1K7q?=
 =?us-ascii?Q?kr02gCxMUl7NZqIwKze+JNUUs2UjG2HhACTPwSwrH7SCuNBm6/k4+ZYghO/n?=
 =?us-ascii?Q?5WnYkcKCnhXyr7NKrVcy/BG9KHjn2B/I9deRlp2juoEcMalhx4PIQnH/vtQS?=
 =?us-ascii?Q?uSDwbEOv9wdqCLyhVkQl3/Q3fKKSuQjZxR6B2ZWV3puB7escgwcuIV8023P/?=
 =?us-ascii?Q?HI+RsUz72crPMm3apdQ7avLb6p3g1/OhkG8dBbD6D074pqBpKmlWpBhXlGVa?=
 =?us-ascii?Q?D448mu8t9w=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 488ecb79-a8ed-4f2f-a2be-08da4f8533f8
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2022 10:44:34.8461
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qVHKLl8w4E4+3QkmK6sINgFKJGyRxE8G83b9RsaXXr+6FQHZmNN5Ah8HyUY4oBLJdPi3cFqyftiBVmjZ6+J77g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB2504
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of hard coding the scale target in the test, dynamically set it
based on the maximum number of flow counters and their current
occupancy.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 .../net/mlxsw/spectrum-2/tc_flower_scale.sh       | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/tc_flower_scale.sh b/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/tc_flower_scale.sh
index efd798a85931..4444bbace1a9 100644
--- a/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/tc_flower_scale.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/tc_flower_scale.sh
@@ -4,17 +4,22 @@ source ../tc_flower_scale.sh
 tc_flower_get_target()
 {
 	local should_fail=$1; shift
+	local max_cnts
 
 	# The driver associates a counter with each tc filter, which means the
 	# number of supported filters is bounded by the number of available
 	# counters.
-	# Currently, the driver supports 30K (30,720) flow counters and six of
-	# these are used for multicast routing.
-	local target=30714
+	max_cnts=$(devlink_resource_size_get counters flow)
+
+	# Remove already allocated counters.
+	((max_cnts -= $(devlink_resource_occ_get counters flow)))
+
+	# Each rule uses two counters, for packets and bytes.
+	((max_cnts /= 2))
 
 	if ((! should_fail)); then
-		echo $target
+		echo $max_cnts
 	else
-		echo $((target + 1))
+		echo $((max_cnts + 1))
 	fi
 }
-- 
2.36.1

