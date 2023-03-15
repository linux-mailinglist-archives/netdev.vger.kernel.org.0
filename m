Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB5F6BB41C
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 14:13:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231563AbjCONNq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 09:13:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231437AbjCONNk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 09:13:40 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2085.outbound.protection.outlook.com [40.107.243.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05A52298CA
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 06:13:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JwHIOQCLh5f9snVjGsuN3ZzeR6do9GjNVdtieJxFdK7uLcOsFwujNjsRdoDTvDETv0UTBYoEWQ/Hxnl5oVhUfoNYvRVgd80ovEWb2P3Jw5pPFtQZiypT5X7N1troMtz0ofKhAEseuhaix61JDhSTh6VsgPGAmZw0Sq7agNZUP64QtzTJJAxFUM1ZI3w41Ox7lmvoj40Al/nTd/eD1Pu50PjT72Rvim3cIEZ4Y2RziF/otDPM3DsMmMLgdOHGIafscTAPFo1QzuSoTnbD09mp492NW4liq7V2IDnTpvWNNrDfS/MrXRfydvWRinz9LwSKS2VrsKvxB2ZvoF+IJ22iCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2zd9WrrpJfrGPvUWRX9Vl4aXE9EocAqWSQ7KmKpQD3Q=;
 b=chvoOS7oYauu8Lfa/hxP84WpXfY4ClrkBUnIaAupOlg/6avYnSi60yonWrnu2TgaQ2ZrWrRl7wKVLR7UJ3O99B/0YbXh5EqaZQRbD7k+U0iNLP8C6pcl2OKQJLrgiRJgVd9T8r1p2ewkdrmKh8HiXKiHmxSZAbm2VEHoSO7M1u6TuCOk2rMVCN8zFkefCB7xGEu4RcfNFZsolEMpg57s7bXPAIPh7wEMReBvBYXvQptaSx1QhDUSw2TYtFnhSOoKb7F9yXRgpSFB6wuooncZJNVjO6UPQrnaX6ELDLbTjczqaj3IUSZHwXT9BhP/0LK02CLHwLmQGcODwILe0c4t1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2zd9WrrpJfrGPvUWRX9Vl4aXE9EocAqWSQ7KmKpQD3Q=;
 b=jqx9RPZigW0bNUQ+XrJtXRxaQhaZ8A/hKuA27RPhok7fnBYHG/NwckvcMc7SlS51SGkO+Wu3uenEGLzrFt2S5TX+FpHnuVo1tpKwrQIxX2h4NvaGeNExlUROYUd93oTYE8+OvaLfrOpgb/lobMkrUvxoJklAeoKQT9vP/c9Ia1iDSYBC+OZUTwxzjlUbkKS8PNquILzGfk6+c0gqyUV5ZWq82X1PNtGwGp1SCDcN+YUcVBxyXctLxs5aY5HTpG6Zs3ZRVp4oZqVSTaAWbB7V3sLsGjgZv7FPETO4jhCiJxNUlomEFf7P4cGJQi33ygC821rRkd+Ri9zjK/Gfh1bJEA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DS7PR12MB6216.namprd12.prod.outlook.com (2603:10b6:8:94::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.29; Wed, 15 Mar 2023 13:13:31 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3%5]) with mapi id 15.20.6178.026; Wed, 15 Mar 2023
 13:13:31 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 05/11] vxlan: Move address helpers to private headers
Date:   Wed, 15 Mar 2023 15:11:49 +0200
Message-Id: <20230315131155.4071175-6-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20230315131155.4071175-1-idosch@nvidia.com>
References: <20230315131155.4071175-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0902CA0028.eurprd09.prod.outlook.com
 (2603:10a6:802:1::17) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|DS7PR12MB6216:EE_
X-MS-Office365-Filtering-Correlation-Id: 75a43014-b3e6-4402-6e2e-08db255712b1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rhO5AGjEJmTUGruudsi20AU9Ck2IThtnS+EXts9OB+g6B061K33sQOIG9KSRUMn804ef4U7X7Otd9FB8LcJ2LlqjRg0b7zibJFfUyugyuC+vaw71lVcQ5qBnlR+RnlsxbR8i0nvVsZJLwbsqliL+/8iHhG+DjIs5M9KMyJVpsuYV8XTdMJTUOpIhrWm44SqeSEnnpnseIRthcflKXWMJdDs82A5X57hCFDtateKgJKT7rey729jzJ93WCQLWljwOUF1KgkhGTgYott4lAUak88Ohblz+gRpTEVRZKcvEwoFO2SD5d2sdmdQ6VZ/5EOWJfKxxflvTbkzeHU0kO16VHEL59X5ev05rQdsRSTsNddWeHaCLw8EeyvPwWzzZ0e6phcku2SFT8sKrKRWWEPPoZF+JXnhk6xx3wQ1OCSL7ea6K4FSBWLkkMpiWwDppftE1ycuoLj5mcsB6sSGy6nThSZM8wehog/oYUYfgTNyu0wp5snIz5+6AsxVNEnhBogKdH0wEP/ns5X4WAGnt2r0l0JCzCSgOiP+x+fQmgBYJ5Aht9vFx7Mif7OYJX38eNKgxPWQvSSzuz9yJ96rIDGMjX6N1g3SA0GlL6kqC3o95V3BmNG9DNrcWEvuL34eD3pTqRQZ7xskXWKmlZlMh03cypg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(366004)(376002)(136003)(346002)(39860400002)(451199018)(86362001)(36756003)(38100700002)(2906002)(8936002)(5660300002)(41300700001)(4326008)(2616005)(1076003)(6512007)(186003)(6506007)(83380400001)(26005)(316002)(66476007)(8676002)(66946007)(66556008)(107886003)(6666004)(6486002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HovgUEJj2WQ1MB0J4yOdrh+RmU+MjXtrN3J70V8pCqkhRZhA95Il0C23IbC4?=
 =?us-ascii?Q?+owg0+8hVpbRTJ3mQgNQamNhbtd9eyxe1PAKILR1HP7EJPengzx9+8rCIe+J?=
 =?us-ascii?Q?Cc93xcrfBF+Wy4LXBphuMYEa8730JusgCPfFX/6eishvI0Eot4LqLLOUnnK9?=
 =?us-ascii?Q?h9bNriWNOSQKNRTXkRMAgImiaDYoQJ37HDnvSyyECEdeu/qfmvhWUmIMsRSb?=
 =?us-ascii?Q?2n5xwC0xXut+3R4KMhzgjPum3tQfa/2Trp4hM3IPbSi+PVRVcDhFiiQotR74?=
 =?us-ascii?Q?UBjQopLV/RQiGu9tCOEBB5uBZ8BN9LUGyoSjZtzltFCQqeFVM2vn0+ad9wlK?=
 =?us-ascii?Q?Sd6vfXBCLq2bYWp2QY9TwiDYOglAzCULlS81WyfJdW1BNchigE92SJaTsVTM?=
 =?us-ascii?Q?2qXaX0mpkTP2XpQRBIHvnWWUATQYtoI5GJbgPYfGr9E5VHMmeGQ/usY7x1LA?=
 =?us-ascii?Q?miHiuVLvQ18O02Ra9bp1Cs/R/1B2MY77QmzaPKxklGBgl0aJgyE442/Ko+WB?=
 =?us-ascii?Q?w/WfA3TRmEl1gz6JFDfBTqHY0ESBfI4cQ8VRKhkzOvl977AJBrkX+/VtDw01?=
 =?us-ascii?Q?sbFNUCSMVqF+IzyIzIjC6rm7bUZgBYr56KNjF2wsZ4sSLq/mCaMo2XqrjhLH?=
 =?us-ascii?Q?TbDvdS7w9VXWDh8pt+E6OE9PXhOXx2vd0hCs+fzsDZn5Ir9AHYHx40vrvo1j?=
 =?us-ascii?Q?8ji5AdgqZg1JneyIz+nZ+4NVH6jZkqr9Rg7aEdTzfnzzBSqm/v+PxtztZRZm?=
 =?us-ascii?Q?Zr0SkGeutK/QyCbFddPR/zXeu0jGj5PEAS+ObE1JWGaQlTvgYTFfcNx6RddG?=
 =?us-ascii?Q?jj5YS09XLnlxXsHm2kuvvN2ZHjLOOUpjLQUj7AlW+/o8YdDXBYB7FskO9+E5?=
 =?us-ascii?Q?i3IpppBQ4wyIpOezLjIWnRJ80j4tSO6AIKlD3NHc6DMp9T6N+cS/7wNJW6kn?=
 =?us-ascii?Q?xuisoJANTXEdYtji8aOMFWd9o1Ms4XY8qE3cGl5eqAR1X3p6ZuhaQPyJ85jZ?=
 =?us-ascii?Q?RJvgQfKiTrb4Ub4AopWiIKn65Nnx4O6NDSdOefF0zIDJejxaOMFbN6LNERiL?=
 =?us-ascii?Q?5H3sn7yzBX2OJV4SjAWTfDbv4T4WckZh+y/OAtarKiLcGuKTEzHU0XHD45JM?=
 =?us-ascii?Q?rR1sKOgmOcqBO17YBf8Tl7BOO44L7LQxwk6K0K+e4jLwOtG7McojKOu2ACSV?=
 =?us-ascii?Q?HuloJjkCozZ3oD5n2FnEq0DqRKFUnMnwxSrMrfXkErrUm9UHiOJUM5syKkFM?=
 =?us-ascii?Q?NZ+6p0e7maPWc3gGjK/3AmCrzg9WMEA8eRV9Pg2pkC/rSeXosqkTTtR02vzz?=
 =?us-ascii?Q?ChOXKs4mdwfZ3bt3cYLOE3Q4j1OxtIlkQs761+siiJQu2qCKHTvMzcOQcGvK?=
 =?us-ascii?Q?6cyA36rlb1UR049itR7NmqCY6qtiyUISvNsvSR25hHkfmw8uzML19ySDNCBH?=
 =?us-ascii?Q?kc01TIxOe5d4k88RInqrCmBnm0TpnZ+2vV6+NES5c0FoGnQ7agqqozdKeypo?=
 =?us-ascii?Q?20v8MFX+C4wDFeHFtiQ67OoUfzMQmov3n6S5JlNEqTX+gnjDmLRtGFyDZcYx?=
 =?us-ascii?Q?S+JTTWAcwYWqNHmUqIrkE91W1aOpZ9cLlV4d6Akk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75a43014-b3e6-4402-6e2e-08db255712b1
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 13:13:31.0619
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EneGdhKXXTNWLbs2NvOAvNAcMGOyHxj1gZsoNUb8w2JFH0tZQqMgyEFOMCgm9l5896fGu7yGzVFdZf70ojYbjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6216
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the helpers out of the core C file to the private header so that
they could be used by the upcoming MDB code.

While at it, constify the second argument of vxlan_nla_get_addr().

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
---
 drivers/net/vxlan/vxlan_core.c    | 47 -------------------------------
 drivers/net/vxlan/vxlan_private.h | 45 +++++++++++++++++++++++++++++
 2 files changed, 45 insertions(+), 47 deletions(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index f2c30214cae8..2c65cc5dd55d 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -71,53 +71,6 @@ static inline bool vxlan_collect_metadata(struct vxlan_sock *vs)
 	       ip_tunnel_collect_metadata();
 }
 
-#if IS_ENABLED(CONFIG_IPV6)
-static int vxlan_nla_get_addr(union vxlan_addr *ip, struct nlattr *nla)
-{
-	if (nla_len(nla) >= sizeof(struct in6_addr)) {
-		ip->sin6.sin6_addr = nla_get_in6_addr(nla);
-		ip->sa.sa_family = AF_INET6;
-		return 0;
-	} else if (nla_len(nla) >= sizeof(__be32)) {
-		ip->sin.sin_addr.s_addr = nla_get_in_addr(nla);
-		ip->sa.sa_family = AF_INET;
-		return 0;
-	} else {
-		return -EAFNOSUPPORT;
-	}
-}
-
-static int vxlan_nla_put_addr(struct sk_buff *skb, int attr,
-			      const union vxlan_addr *ip)
-{
-	if (ip->sa.sa_family == AF_INET6)
-		return nla_put_in6_addr(skb, attr, &ip->sin6.sin6_addr);
-	else
-		return nla_put_in_addr(skb, attr, ip->sin.sin_addr.s_addr);
-}
-
-#else /* !CONFIG_IPV6 */
-
-static int vxlan_nla_get_addr(union vxlan_addr *ip, struct nlattr *nla)
-{
-	if (nla_len(nla) >= sizeof(struct in6_addr)) {
-		return -EAFNOSUPPORT;
-	} else if (nla_len(nla) >= sizeof(__be32)) {
-		ip->sin.sin_addr.s_addr = nla_get_in_addr(nla);
-		ip->sa.sa_family = AF_INET;
-		return 0;
-	} else {
-		return -EAFNOSUPPORT;
-	}
-}
-
-static int vxlan_nla_put_addr(struct sk_buff *skb, int attr,
-			      const union vxlan_addr *ip)
-{
-	return nla_put_in_addr(skb, attr, ip->sin.sin_addr.s_addr);
-}
-#endif
-
 /* Find VXLAN socket based on network namespace, address family, UDP port,
  * enabled unshareable flags and socket device binding (see l3mdev with
  * non-default VRF).
diff --git a/drivers/net/vxlan/vxlan_private.h b/drivers/net/vxlan/vxlan_private.h
index 599c3b4fdd5e..038528f9684a 100644
--- a/drivers/net/vxlan/vxlan_private.h
+++ b/drivers/net/vxlan/vxlan_private.h
@@ -85,6 +85,31 @@ bool vxlan_addr_equal(const union vxlan_addr *a, const union vxlan_addr *b)
 		return a->sin.sin_addr.s_addr == b->sin.sin_addr.s_addr;
 }
 
+static inline int vxlan_nla_get_addr(union vxlan_addr *ip,
+				     const struct nlattr *nla)
+{
+	if (nla_len(nla) >= sizeof(struct in6_addr)) {
+		ip->sin6.sin6_addr = nla_get_in6_addr(nla);
+		ip->sa.sa_family = AF_INET6;
+		return 0;
+	} else if (nla_len(nla) >= sizeof(__be32)) {
+		ip->sin.sin_addr.s_addr = nla_get_in_addr(nla);
+		ip->sa.sa_family = AF_INET;
+		return 0;
+	} else {
+		return -EAFNOSUPPORT;
+	}
+}
+
+static inline int vxlan_nla_put_addr(struct sk_buff *skb, int attr,
+				     const union vxlan_addr *ip)
+{
+	if (ip->sa.sa_family == AF_INET6)
+		return nla_put_in6_addr(skb, attr, &ip->sin6.sin6_addr);
+	else
+		return nla_put_in_addr(skb, attr, ip->sin.sin_addr.s_addr);
+}
+
 #else /* !CONFIG_IPV6 */
 
 static inline
@@ -93,6 +118,26 @@ bool vxlan_addr_equal(const union vxlan_addr *a, const union vxlan_addr *b)
 	return a->sin.sin_addr.s_addr == b->sin.sin_addr.s_addr;
 }
 
+static inline int vxlan_nla_get_addr(union vxlan_addr *ip,
+				     const struct nlattr *nla)
+{
+	if (nla_len(nla) >= sizeof(struct in6_addr)) {
+		return -EAFNOSUPPORT;
+	} else if (nla_len(nla) >= sizeof(__be32)) {
+		ip->sin.sin_addr.s_addr = nla_get_in_addr(nla);
+		ip->sa.sa_family = AF_INET;
+		return 0;
+	} else {
+		return -EAFNOSUPPORT;
+	}
+}
+
+static inline int vxlan_nla_put_addr(struct sk_buff *skb, int attr,
+				     const union vxlan_addr *ip)
+{
+	return nla_put_in_addr(skb, attr, ip->sin.sin_addr.s_addr);
+}
+
 #endif
 
 static inline struct vxlan_vni_node *
-- 
2.37.3

