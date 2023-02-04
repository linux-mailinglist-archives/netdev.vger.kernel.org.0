Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5434B68AB8A
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 18:12:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232895AbjBDRMt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 12:12:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232682AbjBDRMj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 12:12:39 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2042.outbound.protection.outlook.com [40.107.96.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EDF232510
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 09:12:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N3N613xYsyyU7kGEI363acHpynJ3qe8ZQRoCTFC93q7vYU0o8V+sZyDPbyJJDH+Er86iSHVeGZVqkWTnBDTxj36FCqR9ZQ8j27nYbKpdISadoyzY/fE0/N4jqctWguRqFy0m8xZMnGnjgj3AxIVRkgumKIgli0lY4uV6yQcpeWhH4L+DSWpAuSLRaJcfoSgglGFAowi+ld1T4D5DLOWMzJGLh0q7XebLT8crypOzwVAfNVDZkMWolVoKmy4YazRIVAu871ghIRBNfqa7Xa4AGYa1Y+MC5KfiGix7VL8bDIRYJaJba/hVPkTMbAksCGEHoaVSwtT1UQghleHoXxFKpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QaDp6w1B8EvD+GP4cf4FpBO7+rXUo3RK+Z9b+7VLSPA=;
 b=efxFjKfROafDi0ykI4H70CfmML+n25nky77twtUA99G/unxfah9vOEnJCY+zEB/F6DUlKiJXpYYvkcFTumf97pxvOVxCy2i4TeSkMvczP/c0KvMT33+DGUohFPTczqsisX3avk6QGTewYurwOcO+KA3Jyn+RcuGHtjJ1T4t/1SBjefRDvMSBIVZ/HK8ui84628W+wBMSszGzgWbpIYaMfeF00zfJtNoaEouiNwp97wYxzhNrBCIjFZEvtXu6uoXTivhGbmfy9MxehRpXBItHD9f6gs0d5knCf7DXQDN5QV4PZ/NgMCHAXvkUspkGafGwZSLknnwwE23dC2p/ivxP+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QaDp6w1B8EvD+GP4cf4FpBO7+rXUo3RK+Z9b+7VLSPA=;
 b=K18h20GuxMwJWdjYSrju0ydXTRVMsO7vTbGpiUX3m96RE2qsPohrf3XPNbDJyJbYLeWF6QomppJ99PEiXM5a4MJMEnqFTuS/GYwCFMBXGAENvaBqOC32flYY2cF3WmEks8CvZaY3/702BOKyeIL9igO9w5Cln4OzCLTo7etHM6K+7T1xZydXqu6bE5qSm4suOFuPJtwHzris6qbLGQzPzsRCjE9WYINKsWDynmIkVauA7li86bCzonOCoyAqtO2JbzSyDM1nMGQLdu8dk49E0gEJ2CXIDNv/+HqFwvxOUf/OGakA4YGs1eT+adXTr7a1sm6p5mEb1fYv0pVxB1xf+A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SN7PR12MB6816.namprd12.prod.outlook.com (2603:10b6:806:264::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.31; Sat, 4 Feb
 2023 17:12:34 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::7d2c:828f:5cae:7eab]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::7d2c:828f:5cae:7eab%9]) with mapi id 15.20.6064.025; Sat, 4 Feb 2023
 17:12:34 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, razor@blackwall.org, roopa@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 08/13] vxlan: Move address helpers to private headers
Date:   Sat,  4 Feb 2023 19:07:56 +0200
Message-Id: <20230204170801.3897900-9-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20230204170801.3897900-1-idosch@nvidia.com>
References: <20230204170801.3897900-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0901CA0102.eurprd09.prod.outlook.com
 (2603:10a6:800:7e::28) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|SN7PR12MB6816:EE_
X-MS-Office365-Filtering-Correlation-Id: b0c2acc8-3d07-4a9b-75c7-08db06d30230
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +FYxyaNK4EVCNlrL8x51CMqq4BeAYCfCE/FIMgJIHRJoqItcUd7HEPbCKAEm1CvB5c0sWUTxnXgMuusCBvWyFYCt7t5YopyMUM6Tok/ZqAJPquFlHe+uVn2z4f7caeu8IsxSfgK70+t8pR5cD/17tPJd1go1SSPymGCcPdkpfTR5NgkUT4DGdCRGVSbL/KsrXAPPacOXmAXOFNLCw7b1V0b+Iu0bOhy2MGljmge3RpwAtCdVjX+WYDZEvKWOSkOXwc7zmDnLAak7dQW11VqN8uLFPNZ/DYrQW2jKQT3WdEZB+Yiin1WH+DjiBwjb6Jgt7CoimIv1tJTHASejaTD/LlqLghzfFiVW4LvpJ8Ew3K0HjnOtVUygjkl6dnIoE+OsNnn5xB+tKyOuJFarLjpCc3grjK9E9f97VUc5fNbMjVZL7ggxMdODt5ffOhwrYT+P70og1J2JuW6tAdGIDJvzh4Tt9APlpdtPfJprDpomGzc9qxPT2fHyKsv6pLsTHWXE/+vC5a/MZUc5/3HISjUVb+nFKYqBnIHogvEXsrq3CWEwPGEOzcXknHVWKNH1HFpo/KOB3SI0qHvBr76ObU/E/QQnLjXDswTV7Tp5a+ZvyoeFRSeD2xSh69EPK2Q2isa6NwiLfW7Yb0mj9AZU5KZoAQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(39860400002)(136003)(376002)(396003)(451199018)(8936002)(36756003)(5660300002)(107886003)(1076003)(6666004)(316002)(6506007)(478600001)(38100700002)(6486002)(66476007)(4326008)(8676002)(66946007)(2616005)(83380400001)(66556008)(41300700001)(86362001)(186003)(2906002)(6512007)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?v7zNculMokLq4kNTv7Xq/JQRev8qvfwh+BKSS/+2LwbF1SLmgi8xtWmUGI8L?=
 =?us-ascii?Q?QeOcQ1UUJEk0rr93yKog4O0QRjWmZ8whAbGZ1SjZkLtEmE6UGK076jKtFW5E?=
 =?us-ascii?Q?5p4TeErX0UBKVbr5JDkOW+axdZm0b0oDvZ6eDsjGXSRp9qk0FR+T9nwruZhn?=
 =?us-ascii?Q?fHC8o+noELn9g5TerFxEr3k0fG0VvAmb0NX9kIaAy9MZypDTbWFakVDYSHT6?=
 =?us-ascii?Q?FuXxP2aOS2ij+dClfcLP5F1QR7KYpz0jTsq2E5iYio/SF8dj1nxvlo8QaOTZ?=
 =?us-ascii?Q?DTvX864rjoGsejJLWpfHQ/wE5H7264ExhzoiZl9+a6/bKP0ILXyTL2clSuk5?=
 =?us-ascii?Q?aGTfOvB5JLxwqZzgXhsQvXUsmIoaUrETXtm1s42h8uK6dWjFucHn+d1A03Fl?=
 =?us-ascii?Q?zzdskq59cKWXWRo4tFjNzFYYIYYxzDEIyJG4ylB8fQHymbkhkgqNAQax4vBF?=
 =?us-ascii?Q?csQBbNKs7QNXOA/jMEFYj1V83Go441Hfw8Mgw9w0hosnhMMvohZcs6ZI/0TW?=
 =?us-ascii?Q?DNUgWEGKOVfi/Eyz6Ti619VdwHdr4qTkwmXFBbirIiZyZgNX6Qy2bD2LxT8l?=
 =?us-ascii?Q?RzxXBpSD2OVt4XpCftu2+HYaGEmLR3SEBIL3nn8rtiVVyGk00d3LDRj2HRbR?=
 =?us-ascii?Q?rkM40PS09j/h+DE1xd+W2Gsny1kwDc0psVT9iCJOW9VD9veAiCFYqFqeVZ0W?=
 =?us-ascii?Q?bqjYuyD+yeKviTzuxaGR/rRynYxYcf8RpKhm4LhAZPsPTeZZWlIbtf2uAclE?=
 =?us-ascii?Q?kKHEElV2jHzM8LgUVGhv7isnOAws+UfFN0PRk9t+CH3DjicEqJN/2mdR47pc?=
 =?us-ascii?Q?IEVDKiBRQmrAqZcF4NwSQ8r6BsEuH7PGR8ADVyuBpZul5Onc39Boz6TXxZZH?=
 =?us-ascii?Q?NB/DSwgeS4Fo0OLs+dyy9S/kVXnFFHCERi4dPUSXzqrdVft8VaKXJglIi6xS?=
 =?us-ascii?Q?0NQBMNqUw+p5vULlgq17xnlQX6LvWY1IBn9Y0ahtiNmmUuGam+X8foVy3gMy?=
 =?us-ascii?Q?YQ0OZ6mdvzE9JdTcooFKcTd3/+3So18bARWEWUNJpg9prnOa8jKMRVuSBrgz?=
 =?us-ascii?Q?hSHCHsM5xgCLMsdzMCGRQaKXyMRVC1ghYp7tCvdLcW7g94NlJXXqt42r2w/U?=
 =?us-ascii?Q?f9siU94dLAeAVd7jADh469eo/XMu8vo8cUE+yR03KF1tJzqEFxcpbLDAkyay?=
 =?us-ascii?Q?ppuXPc45vjiKKzCKWu/xclHBmaV52y/Rm83geoa3RoZ6pkO4uTM2klSC2SW5?=
 =?us-ascii?Q?hOGmPiPVz1G+WzUjkx5hX7bA5HPWdyD5f3ppczAkhKDBPR412aXo/rhpRs2P?=
 =?us-ascii?Q?9d8yY22a0YMMQdwqvt2Si1aUdGl/hwZrK1R7zC1U0FVepO7+iFsfqzmbXKVh?=
 =?us-ascii?Q?yCuKQtc4xvw6kXOED5CK+epDF/kyhWjvg6LoVVnsUy449gOV3dFQdAYkG1Xh?=
 =?us-ascii?Q?nZws2jVIvqj+4DPK5HUaOKFdpZOdfG+fuItGGAYYOVg2XkMRT9Wt4TLMPWW8?=
 =?us-ascii?Q?W88HyOgGOQC80iIY0ZIT2N1LKRUrKwK69CzMofPkuPNOmH9K7j8o2dOfXJHV?=
 =?us-ascii?Q?oCneLmQd/J5O8cl5HWXPV4kEmlf24PRSsR1GbDvY?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0c2acc8-3d07-4a9b-75c7-08db06d30230
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2023 17:12:34.8452
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JfwWNbwd3jvJp7R9PspLLPovyXhPgxDAsoJjPsQ34oZ9Uti2+xWmAu/fPwaK7bpidnuBt8EGaKnwaukJoM43Jw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6816
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the helpers out of the core C file to the private header so that
they could be used by the upcoming MDB code.

While at it, constify the second argument of vxlan_nla_get_addr().

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/vxlan/vxlan_core.c    | 47 -------------------------------
 drivers/net/vxlan/vxlan_private.h | 45 +++++++++++++++++++++++++++++
 2 files changed, 45 insertions(+), 47 deletions(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index b1b179effe2a..a3106abc2b52 100644
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

