Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1635448306B
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 12:20:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232930AbiACLUf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 06:20:35 -0500
Received: from mail-bn8nam12on2069.outbound.protection.outlook.com ([40.107.237.69]:18816
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232984AbiACLTj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jan 2022 06:19:39 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lb85/faZx3YI1vEC0UIPMIMlFpWIxAFeyJ9iY6TYh63S+hHk5QtXU8b5KzOAVDVAIsK79wzSaTvBZ1wt5wK+20gahMZy0d4kuU29AySYxLSaSXP8JBU7vx2dtHeGJGiMDHrkhE3HlAM8d3JnsYyQ0MD7XKBICThbYLmM05zMMCBLAwiznskW7Xtrj/sqSncreb+vsDWPGx9ulXP0b59zWag4XaOLFhZbJxUhgUxe5auMoiGnJK8NIFV4kwjVKpSPMq3O7zhaLrsjC8U+pkEgQ2INcb/5eqIOxIz5leJvgW8NvDzbP8v4HoTHpKOZ0Bm7iUkFu0eTtzZx4PmM5QcxxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nqdnHYsAkyFxNNTgHoQHhkULFrP9X2hoesv70OgAgCM=;
 b=MzL4RXckv1+3CgspD6y8kaQkiNfKST/TGKgL50f+CMlay+8qeIXJy835T4HvXwWJL1Mnqv3OUeuMvQHQZBcFFYa5gN03Q3KurGgM2wmDc/haL1QRD/E6Scz0SMEgTQcpdC1jZQ6Dj40nN71HNSxFj5mTX8iDpMXVARd0PEunVZHsSqPrYlRA6WkFqweFu3zeE7xFFcZaT2zhC0/j7y8v6zUozMkhtbc29y1yHbkuj37/O3dQfdjvYkNhoN/E/7IozcuvjU+ChddCD8ib/+tLQV4IOsMbWYpQEEI6x4dGf2qZ666hu6eUpxh4Gg+01bVat5mk3TtQG4530VPSx7F7iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=secunet.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nqdnHYsAkyFxNNTgHoQHhkULFrP9X2hoesv70OgAgCM=;
 b=W8Efq62AXt3xh+xssYnbsVP/F60eESthftzXB4bSc6W3VKrjXol6X1MXyGRlo91ntxeP0jIqYM6immu2G14oRWfg9SG0psuL1/+9Z7PODsw9LLxjRdjZ4oi+JQK2RLwcjMK/ov7dVydklrVEB1QciKjVpY5Z13pgkrRquKbD4fsY0Bc0rM2gXkYvnFS5kL58tsWCH1vLbm4p4FH+nXfWtpbOuhDrF91e/UB98udIZI2nah6i9NSkb8GmmyCKqvGVRf0aYpkkvQmcbpYZo2Lz3iL0P0Dw5lReraL2GqPNBCBpyPvX7Z/Tvq6OQCX7lvTcasLIGy2gbDxkX1rIXuERzA==
Received: from MW3PR05CA0008.namprd05.prod.outlook.com (2603:10b6:303:2b::13)
 by DM5PR12MB1865.namprd12.prod.outlook.com (2603:10b6:3:10b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.15; Mon, 3 Jan
 2022 11:19:37 +0000
Received: from CO1NAM11FT050.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:2b:cafe::7f) by MW3PR05CA0008.outlook.office365.com
 (2603:10b6:303:2b::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.4 via Frontend
 Transport; Mon, 3 Jan 2022 11:19:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT050.mail.protection.outlook.com (10.13.174.79) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4844.14 via Frontend Transport; Mon, 3 Jan 2022 11:19:36 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 3 Jan
 2022 11:19:36 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 3 Jan
 2022 03:19:35 -0800
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 3 Jan 2022 11:19:33 +0000
From:   Raed Salem <raeds@nvidia.com>
To:     <steffen.klassert@secunet.com>, <herbert@gondor.apana.org.au>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <huyn@nvidia.com>,
        <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Raed Salem <raeds@nvidia.com>
Subject: [PATCH v2 net] net/xfrm: IPsec tunnel mode fix inner_ipproto setting in sec_path
Date:   Mon, 3 Jan 2022 13:19:29 +0200
Message-ID: <20220103111929.11563-1-raeds@nvidia.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 105be2ee-bf01-4162-4adf-08d9ceaaed3e
X-MS-TrafficTypeDiagnostic: DM5PR12MB1865:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB1865DEF93495392EED70E3AAC9499@DM5PR12MB1865.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1923;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /5MO9FxfF7NFf7nhqdtqr6XxCqztregVOct7tnipZHuHWIcOAE6H+CxbUtwX3L++sk0J8kcmJ1gVjuuVzcrE9S2u/7Q0oVNhmCEJGPiuPJLIv+QGRUtaR+4/Q1JiE+aWXA1IUTOlX/a/38X6CALGOxZIz859UOIMpfocPPkBn3clv6Ozo/8JcVueP7yAa4FN38uPMKQn+oBXfnIrZlMDygXaGLMEGkkLdizocF+R5Fs+KTmvDy4G6w62tzLeYS/4bFCQt4pBi5lDz2JrYGlLN1Y3qBkjRoqS0vUeMWir4zTZCKRlGFk4jxQoRyKVir9oKA0uYjbXloa7x/U7Xl+HA5fTGmDIvGSWHHJ7ZpSarBjXMPBj9KFioooHTUBAPZaJhIihuxu6JKd0TngBt5H5+dWVjPLtWoa4g4DF7wkaFg/2wLB2BKe3woVrd0TA4IIBAebaPbw6badgLtxVSTCEbqTpHsygwl5l0iudtMMoLdvjzkfAS/EDAEIEZH3Cc4wAPqDAda0dcMmTmiIEG441+sheBKiGzglKWxV01CGmCrmgpdfEZsVmUpSPlom9Yo+ry1fzpg+EXxczqmTPKuLZ/eERXS6lkUnQsSKE2MMM49+3KojGOJ2bka5cGvZHlE1ebm+PBpsVNQbhpat/V7hPHlWXXS3MA4DZegrvUvlWJVy/D3CW5KoIVnHyIkcxE9uziavu8GRtI7/mvfjvWv/czCImnYTVcy+8qJnsdSyKrCnFBmbkGhFQDlyB44zTHIQQTKcXr/p1Z6D/aqcL1nvUp85W03MNg74c00+I/ZMAsFI=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:ErrorRetry;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700002)(26005)(336012)(70586007)(107886003)(2906002)(36756003)(83380400001)(7696005)(47076005)(186003)(36860700001)(81166007)(8676002)(70206006)(54906003)(110136005)(356005)(6666004)(82310400004)(5660300002)(426003)(86362001)(40460700001)(1076003)(8936002)(4326008)(2616005)(316002)(508600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jan 2022 11:19:36.8430
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 105be2ee-bf01-4162-4adf-08d9ceaaed3e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT050.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1865
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
Signed-off-by: Raed Salem <raeds@nvidia.com>
---
v2 changes:
Remove Change-Id from commit message

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

