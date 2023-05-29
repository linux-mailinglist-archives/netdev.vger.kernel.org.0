Return-Path: <netdev+bounces-6171-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EB0D871506F
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 22:20:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8D1501C20A5B
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 20:20:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE695107A7;
	Mon, 29 May 2023 20:20:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1500101DC
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 20:20:09 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2047.outbound.protection.outlook.com [40.107.223.47])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93087CF;
	Mon, 29 May 2023 13:20:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CRhgk1uZ3skJ8sASOw1YDrBkg71HX6c0aePBEtHmlQgCg2sNRdSqQhIkBhW3tOyK2blyJ4RP6NVxo0+BQYwiQYbG331nGNUbUaBDzdXX3FZTrykjAo6NkYSGncyqFLxbWGQmJjoUSXiZaSqqc8K5Qoha2eE3/6bL5cH7SBFV4YmJ53Mdf+W7CUeJEPJU77AiD5YximABfqnB1oBde9O0kvDSvFOHYdBayXdY8bYmKZszi6aiB3sqnI1ClxSIdaYckgvdNZ36pfzvF5kt/rQB639sZkR2OrHpO0mmQZFLdK0HEiMceekkTY6EJoAWy8l8JXI2KrXKaVUtwIYi+qmlTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vq2fa6OTzuQ+2tamIGkYzqhpzVAaKTxY4b5Pb6+tnEQ=;
 b=nOAkA5g03RX5O5Bq6mRZhLFZ8Qpm8zesfvfuCejQe0cVeBCnfk0/b0fNRb8NKGYauSh8xfal9yWTmYml8bLaidi87F/+81xkA8zD8tpX7gg3mK2rs0DiFHnSVQgx6i+kFxgqpjR8K6YmfpNF+Mer33fxSa2NOERB3/FD0+CGuYU6QGz0lHDZ5EIdtkWZQJ3ZS8l7hGDFE/PNXdp0lWbUVm7qrNk9twUpudW62hs8smk/m81Vh5U21vZ7jS3SL95EWVanHvP7ElyzB1Y4pfNirRq7fKvxnW/kWRdWL4AxHT/RwzLD9cWfPrVIo/Z4XOtTRR4a7dye8ALXYLeP8DdhHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vq2fa6OTzuQ+2tamIGkYzqhpzVAaKTxY4b5Pb6+tnEQ=;
 b=i9NoyxD5jWV6kYCaOpetctBQ7Q6d2coC9sC7SbVu7BQJ6OJ8e5v51M7s/kIbu2NobtD17rv7OzrC8oG1+Qc/y9ahRAunvUmAziz2VBB6UqJEB13N5+63yqpdeoHMtkCgXkgX+SY7kr+wYJCBaA/O0L6MDO4y7Cqn/bynH/aRcHgnkq2t+OnihgiFbcdg+TNTrI/PhdHUywjuxj7NwWYRrcm68z7GEtwr1pYxLqboaeOOiij5VGzWV2M+/06LEzJtptmEDtEeRktFowo76n9DdbA2Q7GFoIFrzzlK9Qij1vOmKkjgDGS9PvMMgLthxhIdOgue001a+Jw+GqJcoFEDgA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4373.namprd12.prod.outlook.com (2603:10b6:208:261::8)
 by IA0PR12MB8254.namprd12.prod.outlook.com (2603:10b6:208:408::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.22; Mon, 29 May
 2023 20:20:06 +0000
Received: from MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::96fe:2d5b:98bf:e1da]) by MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::96fe:2d5b:98bf:e1da%5]) with mapi id 15.20.6433.022; Mon, 29 May 2023
 20:20:06 +0000
From: Benjamin Poirier <bpoirier@nvidia.com>
To: netdev@vger.kernel.org
Cc: David Ahern <dsahern@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	linux-kselftest@vger.kernel.org,
	Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 2/4] nexthop: Factor out neighbor validity check
Date: Mon, 29 May 2023 16:19:12 -0400
Message-Id: <20230529201914.69828-3-bpoirier@nvidia.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230529201914.69828-1-bpoirier@nvidia.com>
References: <20230529201914.69828-1-bpoirier@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0295.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:6d::20) To MN2PR12MB4373.namprd12.prod.outlook.com
 (2603:10b6:208:261::8)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4373:EE_|IA0PR12MB8254:EE_
X-MS-Office365-Filtering-Correlation-Id: cf55c36e-8834-4a3d-d49d-08db608217ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	jsaAoHj1SMVfmLSY4m8yZUK7gsoLKkmlB0t01klBj/9oCwFzdRGQd+hAA3CRD9DZtpzbZLoGHMk17/bn/nOvvV6xs3seS0Ok9fcrVpnKuLQ9jcrMetx7pOJujaWiUDeBDKKfw8uj9wSDY8r2kdlXf+/HCFdARiI8ybvcBaZlgPWeFvWTc2tQAIxbHHUHTBUOddHuJ2PsvCVt+zm6p5+7Hqo9DzQXAhlRcoA0negOhMfTGP/YUOsWRdDMf1hv0GCqH2XuK9kkZ3MRMAEY7l+84Dd6/8n12oVMifyeKegCLSvx5mkFmjKS2Qkc4lPMnqSWYtey5WxSLUkeqwbCOHQ88MMykBN3arQDLCnBgRREq1unkKhCdPkWiYLhIL9/qe8at2ZGuiOl7pT2Ro9MZkEZ3FKd0e9r6XUiucwNcEH9Ew/ONiOQxDGMMRbNAjHSiBPazfM2vjNS9QSJWga8WxTeOzH2HBss5fAQ3K8k83nVIRK6dMIPaCIM8nwa+CUqWeK9o80wuezV71gE4jnzbR3uRalUS0PAkfKPbV0cFf9lOxCyIZcKRD/+nswRgEWUY+Va
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4373.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(346002)(396003)(376002)(136003)(39860400002)(451199021)(38100700002)(478600001)(2616005)(66556008)(83380400001)(66476007)(66946007)(54906003)(86362001)(4326008)(6916009)(2906002)(6666004)(6512007)(6506007)(186003)(6486002)(26005)(1076003)(316002)(41300700001)(36756003)(5660300002)(107886003)(8676002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rRcj/z4/kRC0Z4WZaM1uUXEU/5DcFvYtzQga8342p9QKFyrB9HgV73pL1utq?=
 =?us-ascii?Q?WMU8HpAzRYpOugqn2NjO+weAvD6SlSDYdzeDI2dAqWayBtG4rgO8UAXT2sqP?=
 =?us-ascii?Q?JzeWj+LH6mSYo95jY1k3zsT/8oqRsWUMZtQ5M1OTDCxCnvq4CEsEHpmE64u5?=
 =?us-ascii?Q?uQaGlDWrQ7wp96PasIN/a1TH3ls/yipgl/Sw5T1pcViLNumq9HhawsE0m5qH?=
 =?us-ascii?Q?v8OfVPQTvUvrBAiJpWyV7IcsQDlUYA7vHzxwqL8LsDIYgQ9CGhMERnVDmVll?=
 =?us-ascii?Q?Ovh5AsPyEBcHwLePy3Hse1m4zf8RDDbGx9WaiopcT+XWrbSCBjpYdSwwnGar?=
 =?us-ascii?Q?y5yqOoe3Pv+OkazQLN8Xqj0k0hhoh9vw1aNKCJH0FhWL8wGMgQ1/pfHPK9Za?=
 =?us-ascii?Q?N+SHNOobE7lpa1i1rbN3i2Fc1+OC7eCG1c5LAnoClNouLo0vErbmtDVjUaIK?=
 =?us-ascii?Q?ssRTQRIZHpuXNM9rzK0N6k+g7sSB8me2rZaLZeFbuZsR0iABiUNm9f35UQG6?=
 =?us-ascii?Q?8o4GBia7nhauC1hBrPY7I8exEW9y4nzuP1gd3NQr9qeiKmkpyVsu6HwcWpaJ?=
 =?us-ascii?Q?/iClLqvPJKPppojjHuw09S1yzpgxCihGST66CYjTxb5ApD2TtcbZsCM6H0rv?=
 =?us-ascii?Q?mjKbNoUt02VOwE/sW3scrGSS53zAvkvsyYmFnXFj7QlM5t94wbb0DgDlL+HZ?=
 =?us-ascii?Q?0V8jptPI1v2SMY3glhjNMYBM4xg9OYzNrwyfAjVOTvxsGzfAQ48kzQ2Jwi+w?=
 =?us-ascii?Q?ogOq6qm9+bR3ndfl5ao64siMhExSosDKQvgc+ZVms/Hkcl3OgxixqdN2/9m6?=
 =?us-ascii?Q?aZgS0+sxzsRJderhhuvzDOTx0bFry6ihjm5ev9g/emfOnMc87IvOkTIi1nDC?=
 =?us-ascii?Q?sgFNTF6HYx0CJCJPq7eJcLSCv5yVhj2joOxj67bbpDzma9KaWao3IQ6VZ5vn?=
 =?us-ascii?Q?AIg945NpEzczOkiP4Z0JNQCLzxL28U+EaK93gtXxRN1QQt9GBNbMbpNYAJnl?=
 =?us-ascii?Q?vSI8DecRvcDXguBg/l0Q452w4zW7Qu+hBJRuP017htjUOIglwx/0zRsGzxs2?=
 =?us-ascii?Q?dPDObH1/D30fX3wSk5bqChAI3OJK8C7lGEP5RfqPUiwBaW+dfyG55rW/Su16?=
 =?us-ascii?Q?nDa1aOUtfWCPjPRf/dWsfLmu1AWhBbKBTairUDbl5RitXokywJgWKVBvJwoB?=
 =?us-ascii?Q?qu9+nNtzcbdfXHanZvofKAi8vxdpD0lVFUO91uzjZtSpWkjwyxOc/nRlP5XH?=
 =?us-ascii?Q?iXR39GwWmIZ5lx47U/azxx9Z0f0Wqdzobs8BPDmK40aiqx7vMnAMXopO+4H6?=
 =?us-ascii?Q?SU+uQCDREshHJdgBa1+My/mhOeGpstrOwqHg5X4a8+ijx3TPjWIdqEKJEurz?=
 =?us-ascii?Q?2u8b2m+Ms5bQdXRhfzGtCtuI+AucYCaRTYGZrmQDPAkHYFFlPLARV7reEKZE?=
 =?us-ascii?Q?IWcQm57KeVtHmTn+hitsz/Q2z9Sbb6rRM4eaJHctxPK2En90ooWqQG6GGQp3?=
 =?us-ascii?Q?jCjJ7sJcdc+RIceIjIJ31T4+6w6+biPk4RUrmWu1k7NMnK7X9pEyNuiJzK0J?=
 =?us-ascii?Q?yY541iMj5BiZZ9VD1DmxZDMbrIKFYCJ47TTjzXnI?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf55c36e-8834-4a3d-d49d-08db608217ee
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4373.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2023 20:20:06.7893
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r8wOpevwnlndfx189bJLhvHCte9Mn7i8jq1Vu0uX6x2CrqTDVkjDkojrZ2EYjFxW5Ou5wLeWyHVyOwNBXCWUrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8254
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

For legacy nexthops, there is fib_good_nh() to check the neighbor validity.
In order to make the nexthop object code more similar to the legacy nexthop
code, factor out the nexthop object neighbor validity check into its own
function.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Benjamin Poirier <bpoirier@nvidia.com>
---
 net/ipv4/nexthop.c | 29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 27089dea0ed0..c12acbf39659 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -1152,6 +1152,20 @@ static bool ipv4_good_nh(const struct fib_nh *nh)
 	return !!(state & NUD_VALID);
 }
 
+static bool nexthop_is_good_nh(const struct nexthop *nh)
+{
+	struct nh_info *nhi = rcu_dereference(nh->nh_info);
+
+	switch (nhi->family) {
+	case AF_INET:
+		return ipv4_good_nh(&nhi->fib_nh);
+	case AF_INET6:
+		return ipv6_good_nh(&nhi->fib6_nh);
+	}
+
+	return false;
+}
+
 static struct nexthop *nexthop_select_path_fdb(struct nh_group *nhg, int hash)
 {
 	int i;
@@ -1179,26 +1193,15 @@ static struct nexthop *nexthop_select_path_hthr(struct nh_group *nhg, int hash)
 
 	for (i = 0; i < nhg->num_nh; ++i) {
 		struct nh_grp_entry *nhge = &nhg->nh_entries[i];
-		struct nh_info *nhi;
 
 		if (hash > atomic_read(&nhge->hthr.upper_bound))
 			continue;
 
-		nhi = rcu_dereference(nhge->nh->nh_info);
-
 		/* nexthops always check if it is good and does
 		 * not rely on a sysctl for this behavior
 		 */
-		switch (nhi->family) {
-		case AF_INET:
-			if (ipv4_good_nh(&nhi->fib_nh))
-				return nhge->nh;
-			break;
-		case AF_INET6:
-			if (ipv6_good_nh(&nhi->fib6_nh))
-				return nhge->nh;
-			break;
-		}
+		if (nexthop_is_good_nh(nhge->nh))
+			return nhge->nh;
 
 		if (!rc)
 			rc = nhge->nh;
-- 
2.40.1


