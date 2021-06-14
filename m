Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E7603A6912
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 16:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233046AbhFNOgI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 10:36:08 -0400
Received: from mail-dm6nam10on2080.outbound.protection.outlook.com ([40.107.93.80]:64352
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233006AbhFNOgH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Jun 2021 10:36:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dRq4OcLaycsCvBZLXHfbd9N1Pu86J72ex4tl4pJRRSyHv3QTNmGvHXUDr/ADq5lrTF8y4GzST3Iv0ms9YQldfyFGTMr0ULDfQVjhLQojFaJ4PXiNdGQYL1YTU8Z5Ln/O6akXP7+Ii+Hj2P/HSxIF5mufNII7x6mdrAag/YA9FDB0qw6mhaoOyYmo4Kr/v9r5Yvl/lEsQStU/0uFH3K70bDK/IuPjMNqeqahJhecoXvVB1qhWQ+DYAzM0FbXWU9P2tIv0Kptb94RTuVjNM24qZ//1te37hYW1lqGaCbKg1xSp6T0bWzoUSVs+6SqYfegOejc7xoSE96LP9HI0u1hs4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bh/RrANB2+PkB+P3cUMc8O93lU9VsbCUarMP/A22EYg=;
 b=Ij7DZqVBW+/Nzp7sTKcWrCPJB/2lS4uMFPUyBwfbrXCy8Xbun2ckUS9wENECYfRYm2NLVs3+2ECT36SsEEMILqKeqWp2hN8M3B4YeXJNUL47EpI3bBYK/iFpKEZYQvyBVIYWEtU/5HytsSVo5A1KwvbT3GWBPWxr4AbKgMQKalNcCKtdyExMUKI/5+4xoUj7JWY4/w/soVYOFz41ZUVx5sGjE2+YCHuDy1lN3+PMN9mIR+K9IFgoPkTuLsTPWBslQBo3yO5ab7ydx2krU4FN1pHo/QcR9/BI+fc051WKcsM2qkmzThb3EtbyhEGPYKlfi6BDWt6cJC6W+VXc1tN7Qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bh/RrANB2+PkB+P3cUMc8O93lU9VsbCUarMP/A22EYg=;
 b=JULAjUfKqkRypD7XcSDr+SuQBUMmghPDBJ9c0y297tA0n5/VdSccQC/9vBmGpJgdh6UEGGL1z4XyI0yQis/AJ6t903wwelHvPVufGO35cuCzhSKLnAfNwi9JwS4a1bQia6emhGdwcS1WdHCKYRtcGwXJAUb43mSsnFlaIDcbXfOkSB2ufQpabU/lIA1ksxMLwc8knrzsY4fADTqoCZAT/sgWUOmvmX13rTSPHpVw2G6t7gy6kGOCK62FXs8Ws5QCc0cBiXxGHjgiNr5JGZ1av2nt3LCbhT6wspPVgB7MClwR1okFgQtY0fUvg5qT/LLKvN0WYIaQzx5/BSI966jNsw==
Received: from CO2PR05CA0066.namprd05.prod.outlook.com (2603:10b6:102:2::34)
 by MWHPR1201MB0032.namprd12.prod.outlook.com (2603:10b6:301:4f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.22; Mon, 14 Jun
 2021 14:34:02 +0000
Received: from CO1NAM11FT040.eop-nam11.prod.protection.outlook.com
 (2603:10b6:102:2:cafe::3) by CO2PR05CA0066.outlook.office365.com
 (2603:10b6:102:2::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.9 via Frontend
 Transport; Mon, 14 Jun 2021 14:34:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT040.mail.protection.outlook.com (10.13.174.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4219.21 via Frontend Transport; Mon, 14 Jun 2021 14:34:02 +0000
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 14 Jun
 2021 14:34:01 +0000
From:   Huy Nguyen <huyn@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <steffen.klassert@secunet.com>, <saeedm@nvidia.com>,
        <borisp@nvidia.com>, <raeds@nvidia.com>, <danielj@nvidia.com>,
        <yossiku@nvidia.com>, <kuba@kernel.org>, <huyn@nvidia.com>
Subject: [PATCH net-next v5 2/3] net/xfrm: Add inner_ipproto into sec_path
Date:   Mon, 14 Jun 2021 17:33:48 +0300
Message-ID: <20210614143349.74866-3-huyn@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210614143349.74866-1-huyn@nvidia.com>
References: <20210614143349.74866-1-huyn@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4f894438-15a1-49ba-7bf9-08d92f41746d
X-MS-TrafficTypeDiagnostic: MWHPR1201MB0032:
X-Microsoft-Antispam-PRVS: <MWHPR1201MB0032ED8473FB41625DCDAD37A2319@MWHPR1201MB0032.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8cq0Po9bfGOdMlEodrr2DZjt9F6HKbNwa9gAYEqtLUHxWj1Pkm1wx52Rls5pBj/xCszQ4n8NYSOJ6PJ4V3T96rPpToBJ9XkJg22Qe3+azb0SzGJw8zW9o0aosQgk57Nt6pAGyuAiNJZK5byNzZcat/m1IJr5T3CiZg/h6H5PtxzaN9SaFJkYr+CkUOwdhdlkNOZCsh48rDCB4IUWxwHYWfMCSoczDXtvrNqzTPcEJe4Ax2Z8FQpTAO8jAPKX92N9q34vassXljAQtVjUuAPmINjeDp5MKhVDUhWJIpb0tMaVYx+bfw50sz/5hv3IOK42ztaEI4iokEh7Fwmg1Q3bveQPYwa5sKV4HCm9O3qjuJw59J5Puy5v29xRoMsE0qY2L191zCheaebxVda3uSnbMB4ClegfL+COb9cu+fdlnwn9nZQPb6ereKJ/SGlCEW3yZMJ+qDu6WswIiQIoZxWHlpRX8BOLGtPZrwuMEFgDRfNU0lfRS9V0Emtyn0SGjg2Xjw+SuXDkJ4ShE5fAER852ozFFVUbMsrd2gSeSMNmD34glyPV/+Ze0uGtRCU6m7nZD8f65JD/8A90hqrHjMX2AT7zdKbAFdWkLWFJMK7Ek9qhlYOBKQDKtuUkgsENBus7aisH5CUqyO9VJeDmz3/bjQ==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(39860400002)(136003)(346002)(376002)(46966006)(36840700001)(426003)(186003)(82740400003)(336012)(36906005)(54906003)(70586007)(356005)(6916009)(8676002)(26005)(16526019)(83380400001)(2906002)(70206006)(316002)(107886003)(8936002)(36756003)(5660300002)(478600001)(36860700001)(86362001)(47076005)(82310400003)(1076003)(2616005)(4326008)(6666004)(7636003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2021 14:34:02.1278
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f894438-15a1-49ba-7bf9-08d92f41746d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT040.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0032
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The inner_ipproto saves the inner IP protocol of the plain
text packet. This allows vendor's IPsec feature making offload
decision at skb's features_check and configuring hardware at
ndo_start_xmit.

For example, ConnectX6-DX IPsec device needs the plaintext's
IP protocol to support partial checksum offload on
VXLAN/GENEVE packet over IPsec transport mode tunnel.

Signed-off-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Huy Nguyen <huyn@nvidia.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/net/xfrm.h     |  1 +
 net/xfrm/xfrm_output.c | 41 ++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 41 insertions(+), 1 deletion(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index c8890da00b8a..30e94d98005b 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1022,6 +1022,7 @@ struct xfrm_offload {
 #define CRYPTO_INVALID_PROTOCOL			128
 
 	__u8			proto;
+	__u8			inner_ipproto;
 };
 
 struct sec_path {
diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
index e14fca1fb003..1eac2c8565ed 100644
--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -640,6 +640,42 @@ static int xfrm_output_gso(struct net *net, struct sock *sk, struct sk_buff *skb
 	return 0;
 }
 
+/* For partial checksum offload, the outer header checksum is calculated
+ * by software and the inner header checksum is calculated by hardware.
+ * This requires hardware to know the inner packet type to calculate
+ * the inner header checksum. Save inner ip protocol here to avoid
+ * traversing the packet in the vendor's xmit code.
+ * If the encap type is IPIP, just save skb->inner_ipproto. Otherwise,
+ * get the ip protocol from the IP header.
+ */
+static void xfrm_get_inner_ipproto(struct sk_buff *skb)
+{
+	struct xfrm_offload *xo = xfrm_offload(skb);
+	const struct ethhdr *eth;
+
+	if (!xo)
+		return;
+
+	if (skb->inner_protocol_type == ENCAP_TYPE_IPPROTO) {
+		xo->inner_ipproto = skb->inner_ipproto;
+		return;
+	}
+
+	if (skb->inner_protocol_type != ENCAP_TYPE_ETHER)
+		return;
+
+	eth = (struct ethhdr *)skb_inner_mac_header(skb);
+
+	switch (ntohs(eth->h_proto)) {
+	case ETH_P_IPV6:
+		xo->inner_ipproto = inner_ipv6_hdr(skb)->nexthdr;
+		break;
+	case ETH_P_IP:
+		xo->inner_ipproto = inner_ip_hdr(skb)->protocol;
+		break;
+	}
+}
+
 int xfrm_output(struct sock *sk, struct sk_buff *skb)
 {
 	struct net *net = dev_net(skb_dst(skb)->dev);
@@ -669,12 +705,15 @@ int xfrm_output(struct sock *sk, struct sk_buff *skb)
 			kfree_skb(skb);
 			return -ENOMEM;
 		}
-		skb->encapsulation = 1;
 
 		sp->olen++;
 		sp->xvec[sp->len++] = x;
 		xfrm_state_hold(x);
 
+		if (skb->encapsulation)
+			xfrm_get_inner_ipproto(skb);
+		skb->encapsulation = 1;
+
 		if (skb_is_gso(skb)) {
 			if (skb->inner_protocol)
 				return xfrm_output_gso(net, sk, skb);
-- 
2.24.1

