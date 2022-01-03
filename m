Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C42148302A
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 12:04:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232814AbiACLE4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 06:04:56 -0500
Received: from mail-bn7nam10on2087.outbound.protection.outlook.com ([40.107.92.87]:15745
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229651AbiACLEz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jan 2022 06:04:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iAuNXfqLTS2ZaqfmTNinGPd0HCcIavOxirYhabbTRHxcc18+G+SAutBVlDrTBuv9dQ/BM6njahAdLA3WhzVPzkqU/usq4GBlU/jFg173s+vMwAQOgEy7ekCCanV2FHFoajoO4SbtR5+n8rF2ab6OvTYtGRRQo1kvK+kYKU9WDAuCRmSVGu0/L9Jlqkx5baFj8X1HyPpimvnOaA3spyMDC6a/vEoi/zDjbisl0U9RuNayffGa1gxpwgQJ97xm8XasCb/2MrHv5wCcgrop69uKbzrHU+lLq6DvQ+dj+GfOSDKZfGliUtvqde8j5dLnXxATQQ3H0lU4cDgxQdUEnnNW/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=agd7bUwMhbbV9ucMFdQiYr8eGxQEktx7I5Pzfng2YCc=;
 b=muLf97OzbO1okc8IyNfUlP+lgbf6r/83+pZMpzMRbZIEoLBxRkJEd+nWKNnvFdEqttTVEmTx2Dzr3ADINuVXbxMccYaK7xx/zAEUpkplIndiSukYqApq3yYyQ3vdIwNHwYlb9eaXcbNoyaCr9iMI3w+lC/Grqh9yunCxjAPHfHTx7+nxsClUVdSxc1DBGjGWfXZbk/DS2lxxDsoIQ2xIHNPSw9vTJWOm6LpZE8+arZRF5elpXnUJE6WnpCEJ2Lf4R5aD9RTJqd4uxu9T0Io/mPWTTn/WKkXIallRo6wO0douNyBrwet0NQl5smWs1Rg/GotlHhfR/Fqg3CfpQ1A7fA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=secunet.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=agd7bUwMhbbV9ucMFdQiYr8eGxQEktx7I5Pzfng2YCc=;
 b=Q/ibNCV4EHIRpTXAlPXsuuYLCkrUCL++wmMT27F8wJRpXydnqNGgxBzlE5vOt8h9gVFZehed89cs2N17EV6LUFXFas7ahbE1KsE7DxXtXCIVzfFr0jKFObFGGPOxrODReli1FIkRh4S55CP0IxPr8OhuRD7chtqeUwX/he/DNUSJ2ShdBCmkI9zwQDsrdA60VxgA6dAD1X08GULwhSNX6M7CRWkS/X1q/+BfEb8s0QFyZpt5EHjQ+3ZdwTl2+GB2vPj1ZIo41iQk4TUO3/OI6grWClHspG0aCgRAKdv/TBwwMfo1+FoJR1EJ4AXA4xmvgNsMKXe749QO+M+cWxwmZw==
Received: from DM3PR14CA0133.namprd14.prod.outlook.com (2603:10b6:0:53::17) by
 MN2PR12MB3903.namprd12.prod.outlook.com (2603:10b6:208:15a::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.15; Mon, 3 Jan
 2022 11:04:53 +0000
Received: from DM6NAM11FT012.eop-nam11.prod.protection.outlook.com
 (2603:10b6:0:53:cafe::9f) by DM3PR14CA0133.outlook.office365.com
 (2603:10b6:0:53::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.13 via Frontend
 Transport; Mon, 3 Jan 2022 11:04:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT012.mail.protection.outlook.com (10.13.173.109) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4844.14 via Frontend Transport; Mon, 3 Jan 2022 11:04:52 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 3 Jan
 2022 11:04:51 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 3 Jan
 2022 03:04:50 -0800
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 3 Jan 2022 11:04:48 +0000
From:   Raed Salem <raeds@nvidia.com>
To:     <steffen.klassert@secunet.com>, <herbert@gondor.apana.org.au>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <huyn@nvidia.com>,
        <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Raed Salem <raeds@nvidia.com>
Subject: [PATCH net] net/xfrm: IPsec tunnel mode fix inner_ipproto setting in sec_path
Date:   Mon, 3 Jan 2022 13:04:44 +0200
Message-ID: <20220103110444.10964-1-raeds@nvidia.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 75983761-93c9-43e6-950a-08d9cea8dde9
X-MS-TrafficTypeDiagnostic: MN2PR12MB3903:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB39036A2716C5B7F98DAF0FC3C9499@MN2PR12MB3903.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SDgk3OlQZJkffLYlnisJKcz6ISEE2AVBJB6T+K1EzY3PrSVEaozfCEnoeabYIZDliIE18BGSYUJU5UL7/W+mY9cfHP7NTG24XquHET82RmowY1f81r0KSdPPCSGFAWp5kuD5zBPMAU87XxHgTI9M6KWMog4Mk2/V+ab3liMqF4yvHB3rbxgGZQ+EjgZQF5B8k99sDLrtxRVtp5kKz9Hp8RVcb+y1ynSS/OtJ6RksQTi2wlJKYhUVkasetsGePOmCaSIbLzPzhwz8WbiRz68HpAV0IOdwydaHNkjD8/ImNK72VNoPy0meTfniBMSCEz80xrPyVFzYScRV55E0GwQ1yg6b/0nxXLWTO0tUj4yHd9173I23w7+Dj5AF9cwJVLl+K+TjYxR8q0OtR3i7b6XyqY/HZCWnRuAIbLWAjxcQiX2AQE2kYL7oEsKMzlO8Li8OMD+H6Biq6wAv8rHL1VXuVizQJwqAbklUronyO/BHO9KLoJULGkRTSXbxSUcXB8OEfWJktEpXKI/XroH3kOHXVX3W4rffdHIyIP/3GOdvKoJ9jBv/GBmR2Uu9vNx9tfNU5Uqkq+mKAlFB6LPPLjuXDRv3eANShpGbmDNhGjKFVdsWyBOoFy7mgzEPX6xsFTuPuHKfam9Zqgr25328OLjSfEBHj2uVHr3LMj0Ho5x9e280mk3t+n95LfS7X+wTzSOwy4xHkRFwYuWAuV+FrLloAr97lax0LpWq9NWKPD76hvx8OEMCvR+W5x9G3Hb85RsM8Y3S3kjjOg18Sxzz16bzkH5DUp/SVfMx02ajnjr6GNs=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(40470700002)(46966006)(36840700001)(86362001)(316002)(8676002)(26005)(70206006)(5660300002)(70586007)(4326008)(8936002)(54906003)(36756003)(110136005)(2906002)(356005)(508600001)(107886003)(6666004)(36860700001)(82310400004)(2616005)(1076003)(336012)(81166007)(186003)(47076005)(7696005)(83380400001)(426003)(40460700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jan 2022 11:04:52.1286
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 75983761-93c9-43e6-950a-08d9cea8dde9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT012.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3903
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The inner_ipproto saves the inner IP protocol of the plain
text packet. This allows vendor's IPsec feature making offload
decision at skb's features_check and configuring hardware at
ndo_start_xmit, current code implenetation did not handle the
case where IPsec is used in tunnel mode.

Fix by handling the case when IPsec is used in tunnel mode by
reading the protocol of the plain text packet IP protocol.

Fixes: fa4535238fb5 ("net/xfrm: Add inner_ipproto into sec_path")
Change-Id: I8c109cd3f1de1d983b2f49ea5f8f7a403c6023a5
Signed-off-by: Raed Salem <raeds@nvidia.com>
---
 net/xfrm/xfrm_output.c | 30 +++++++++++++++++++++++++-----
 1 file changed, 25 insertions(+), 5 deletions(-)

diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
index 229544b..4dc4a7b 100644
--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -647,10 +647,12 @@ static int xfrm_output_gso(struct net *net, struct sock *sk, struct sk_buff *skb
  * This requires hardware to know the inner packet type to calculate
  * the inner header checksum. Save inner ip protocol here to avoid
  * traversing the packet in the vendor's xmit code.
- * If the encap type is IPIP, just save skb->inner_ipproto. Otherwise,
- * get the ip protocol from the IP header.
+ * For IPsec tunnel mode save the ip protocol from the IP header of the
+ * plain text packet. Otherwise If the encap type is IPIP, just save
+ * skb->inner_ipproto in any other case get the ip protocol from the IP
+ * header.
  */
-static void xfrm_get_inner_ipproto(struct sk_buff *skb)
+static void xfrm_get_inner_ipproto(struct sk_buff *skb, struct xfrm_state *x)
 {
 	struct xfrm_offload *xo = xfrm_offload(skb);
 	const struct ethhdr *eth;
@@ -658,6 +660,25 @@ static void xfrm_get_inner_ipproto(struct sk_buff *skb)
 	if (!xo)
 		return;
 
+	if (x->outer_mode.encap == XFRM_MODE_TUNNEL) {
+		switch (x->outer_mode.family) {
+		case AF_INET:
+			xo->inner_ipproto = ip_hdr(skb)->protocol;
+			break;
+		case AF_INET6:
+			xo->inner_ipproto = ipv6_hdr(skb)->nexthdr;
+			break;
+		default:
+			break;
+		}
+
+		return;
+	}
+
+	/* non-Tunnel Mode */
+	if (!skb->encapsulation)
+		return;
+
 	if (skb->inner_protocol_type == ENCAP_TYPE_IPPROTO) {
 		xo->inner_ipproto = skb->inner_ipproto;
 		return;
@@ -712,8 +733,7 @@ int xfrm_output(struct sock *sk, struct sk_buff *skb)
 		sp->xvec[sp->len++] = x;
 		xfrm_state_hold(x);
 
-		if (skb->encapsulation)
-			xfrm_get_inner_ipproto(skb);
+		xfrm_get_inner_ipproto(skb, x);
 		skb->encapsulation = 1;
 
 		if (skb_is_gso(skb)) {
-- 
1.8.3.1

