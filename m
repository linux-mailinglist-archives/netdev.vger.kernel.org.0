Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDC076B7B45
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 15:57:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231588AbjCMO5t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 10:57:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231542AbjCMO5p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 10:57:45 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on20625.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8b::625])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74BB674A72
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 07:57:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R6BVBrknnti7MpTyxkcNLVx1QpdgLd02BmuFjzBDksIof3nRFmXOb+ZW8YhOxUF+NqS39d23CNV/7k4CHdCMXbJjJ2wCNx0fInarPHM3pBvx6YKwg7MfZA1f5MTvlMAEKjdFYE2L0z232Ivr0bZgcNG6a7YTOkIZXkwIyaqPUq6Sqyx0JsvQn79zih8h/Kn6Gz/QARdy7VsLy92XNQyXL0vXjJ8asGD6kGYvQ4p72s4OVC2d53qTdELIHs2SCpqtByebQQEtzFO9IxaPY7tXxKfu5pTdRso9Xcayo4jW1c7XQgkOB/hvLWeY8e4LAo1Kstz7AHRiwBTapb1CmOl5YA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QaDp6w1B8EvD+GP4cf4FpBO7+rXUo3RK+Z9b+7VLSPA=;
 b=DToz8CrngXkQwi0K/qMuo6qzo8a4ekhy9qKM4cS1j9OU0NDlpieqH67nlyKR1/n7Di2g0k7UM9kvLwz2MfHCKVYErKmwIO+bJcEHUgkhahDI2o5ths+UonX+ZJf/Yz/ivare4QGDiGWNoWMnO0QozCQpzBnS0H2jnLyTRbVhdCA1PLq7Ouqt6x4DTXrsbAuMcsEutP6PjdnIgETsrleba9QaHrbzFIdLMBMxKLCNDq771d1ufsNTedEO/hX5M/VeP8o7FnYnVlfR/KZD7WTNum3V/6yn5YMZM7LxYQV2nELqmqvaBfEZy++RgA/S8nRWfmDbk253kr/DvXN4s1H05w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QaDp6w1B8EvD+GP4cf4FpBO7+rXUo3RK+Z9b+7VLSPA=;
 b=YGgYqVrEAopRVHT2SClJyXuYpos1ptTrOHf62CMKDR2oIWe4mDnPAhiuyRrJkAfxg6EbNHiyC6JyZGDBfR2EtvqH3OcZzYpJeH314w6b1c8qNMsClfiLKfYPT4Lol6Im7jsFoy4Nhv84nNQQHqZ2+2ti8CXuQ+lyU4NXMxjvJMCcs9Z5vsM43Iwht6jNb7iaP60Zo08ZMk9iNiHME33bmeS297oeFjJHQ6gYd9mLfx/uzIUiF1BafO44cZu2m0JowGOQTVCez0Irmsfu+B31cmtPoAOfRvPDaA0kgYU9glfC8N2+CJGAG/n36SHfJVlDU6PO4a+ZzOBVJ5ikMt3frg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by MN2PR12MB4550.namprd12.prod.outlook.com (2603:10b6:208:24e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Mon, 13 Mar
 2023 14:55:41 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3%6]) with mapi id 15.20.6178.022; Mon, 13 Mar 2023
 14:55:41 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 05/11] vxlan: Move address helpers to private headers
Date:   Mon, 13 Mar 2023 16:53:43 +0200
Message-Id: <20230313145349.3557231-6-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20230313145349.3557231-1-idosch@nvidia.com>
References: <20230313145349.3557231-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0502CA0013.eurprd05.prod.outlook.com
 (2603:10a6:803:1::26) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|MN2PR12MB4550:EE_
X-MS-Office365-Filtering-Correlation-Id: ca736795-66ec-412b-6750-08db23d303da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dbep/mUDPpeucsd7tDqc83jOZLfv7ZCm+sXrGUA9+L/2IpUnlR6RX4nJfW1oUL2lzeJm1AIaIlmkqCgHkrgeny8EOSKWaedhsmXOdZvk6CF9vcxTTg4Xz/RfH/cwPa/a91yq7xAxLW9so4QVRo50VVFB/r010wGVXe1gZ5IK30t4AFr7WsHpeTPP4V7DtdhD16axrHt5vVsfIread50vnHHXZsk+4SyVihRS71zK4j78UnzG136JeJwcAi4lzOc8RJ0gsCmOJQwr2kR/W/5wG4WDxZfAWPIel1d+PRL+vDU8LNwjOi8s+mi7xNhFZ3MvuaPGYka6z5jWnQnuUtr8GqiDfX4yk4xRTKjGc3ODEeiurrfC5xR3y3pZQvKF9btsOxvams/ZBpXOtJdDeUT7UJXyzaMqZ2boO45eaArQtrjVpEiviX+FPWiX6eu4+1ZEDepR5bL4M7lg48dMSkq4npovDgCJi+noOjlqWFEiM2I/1M6sBvDzI0AjnKlkas3ta2BLGo9piTuSInR9XdUXmg8221DvILcpP41hdx+uo63/DShpY39US35M1sl7cwCpi/cURxH7VOICBmSFv0uNvFf229sBWMwQvpD87VaIIlF4bNmIQEreIg36CbWLGIsN3WbCPais44xxJGT4CX2xfw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(366004)(136003)(346002)(396003)(39860400002)(451199018)(38100700002)(2906002)(66946007)(41300700001)(66476007)(66556008)(8676002)(4326008)(316002)(478600001)(86362001)(36756003)(6486002)(5660300002)(1076003)(6512007)(6506007)(26005)(2616005)(186003)(107886003)(8936002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FrMYoGD7chA0G+ilRjviapKz1HP17lywxBH5sM4rIYawGmZZ8eTCjh+ICYLL?=
 =?us-ascii?Q?y6IT24TO3Scp2aSc7A8xZeVWsVUPZkh5bWHSbvCjJpfrECrb61KXQrGhd79Q?=
 =?us-ascii?Q?6dY7rdX2eBG003qzDtcQJYEYTnTt4S4xLTtBWAoXmTGFwTQ5RuGVuSxcOYRS?=
 =?us-ascii?Q?KolLAd5IxVreAu9PtYrTyXwyOE6t9Rf+k7POKpPaiFrquFBr53lr1M3ZxEnv?=
 =?us-ascii?Q?vC60vRWUvtXQu65RjGvRZWJaWCHDMDruj0T5jtzQORxkjjrcw2tb8Q4VT8XO?=
 =?us-ascii?Q?BiCfcaTaEE2dcpIy8I5l3bzU3C0WYYEKl1e1PlK2CnIdha2aENpuiJ6H860o?=
 =?us-ascii?Q?FgZ3tGgXvLXK1wVyVyALs1fA3QnCcK46ojoXCvMzBIq4YhFDk56089w0L4Hg?=
 =?us-ascii?Q?hDxKF6ETJinDFSsRlg9F4UyakTOB8m4ztISYzkkPNLQasMB8xIVXVUrx48k2?=
 =?us-ascii?Q?gvKo9vx/orHf0rFA3WsIsmuKGLJCBxr4U1GQ/mZ8ffFYahGCH0RWvDTqUVnn?=
 =?us-ascii?Q?mOKu1wOXlueKg6A+7YslevT9y/vRHXWyYBcsxmvobOe9pt9MyopjldM339AS?=
 =?us-ascii?Q?rUDs3WMqm+M3Zjhf0D4XaWmDN20zFGPTf/uQFlMfKBs9fErASU2UI/loEqBp?=
 =?us-ascii?Q?KhSI2gN0w4NVq8vn/jCo7Iqw1opk0Npo+9AtzYGV5mAzj014MfZLgylI2SrV?=
 =?us-ascii?Q?86ejap9KYiWZ6RpVecPbHKviU5gKB5CdxMxniX8easkKFd3ieWzMv+Zkqlt/?=
 =?us-ascii?Q?WCxlcbMEu/QWGgNE40Tconip+BAFGEUix9rlAbfBA7lfdeiJpYQzulh8PCR4?=
 =?us-ascii?Q?G4YC/5N0EFBVW7R9+DOOx4Y7BKwty2h1+WZJpQqc8Q9qoo/X87nCz5AjHhhC?=
 =?us-ascii?Q?wEc5Gy1Z3Dnok/vZyAC5NkDGfybQ4X5ZMUeFMxtuuXxOq3Eq/YKsDfG6xWym?=
 =?us-ascii?Q?Ab4wqXlOBjCAoxledOFARvC5XRBM1qyvd0oITooIye5m+EQgxtwC7tEjWMED?=
 =?us-ascii?Q?vc2sw4Q/3bGUmfmCVm0ktC4b4k599bIhUUZG5SFCmDRoYNsJITvVMVdLjo0o?=
 =?us-ascii?Q?1f8pDIcr6y/TJTttRN/Re0c+0mCoY8QYYLZUSiq7vDNyD97hwDRNUq+yIssm?=
 =?us-ascii?Q?ko25Wq8gQdICWtom0yB7FrKOXgxO0F9wXybb2Kaz5ft+Rd/jKofrues8b+DK?=
 =?us-ascii?Q?MFpMCIXZnfbXP3NmgyzGwUCPo/D39d9mqea/OA+7BVXjUCrOrvYipntIIj8H?=
 =?us-ascii?Q?C3WM45+cSgC2OUTZUz1nq5HynhBIl/dbsBEoAEgDehlu4u+FWHhqiDL+FiRn?=
 =?us-ascii?Q?TN7BQXWIY+K9TzjHjPta6IxFLrp4x8I4Dgg4yK/yWzaq9KS7h1aJScFgVJlU?=
 =?us-ascii?Q?+OxKsPgrhIB6WArfZvGUkjxjEzqRmzF3w3O4AfyjpV7GnyzYHPg8ceScsaXU?=
 =?us-ascii?Q?IXP6iQ9rNEqG+YB7lyIRAQmdY1V1yygqf/7i3Epe7hIRS6pEwhUBb2IgcOnK?=
 =?us-ascii?Q?ZbAKNucNHXSRRzG9wVaMLx+T7f+E71IeUBvL6sW961KsqPlynntpfG8TfPa7?=
 =?us-ascii?Q?8jBf14M4Ypp1d/xhM1uxLE2EbU2OHiyOZRv4XfrB?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca736795-66ec-412b-6750-08db23d303da
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2023 14:55:41.3867
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N7EkEcCIX7rGdW8w+jztD/lZwfuZnOK8xP8NVyJjZj91ty5edjlA0R4Vrz1lpxznEpI+d/n7KkcDyx40zbJyUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4550
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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

