Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7681A39A533
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 18:01:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbhFCQCv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 12:02:51 -0400
Received: from mail-bn8nam11on2072.outbound.protection.outlook.com ([40.107.236.72]:6817
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229597AbhFCQCt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 12:02:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=No6tEjX8/6/qmQ+5CKK04AA8bqg9hemXoENWR7er7Msk6Q3bcYIlP5EMIJQw/9czxuQDqfophtp6PeVfMaruGMQMPhjF9ctc05WlPOupUd6qxv2g6uvXYJEVIt82j6oqpBo1TGSDMNP8hZESu282HW/Sa8lTOGGWcyrvxpRxlA9aTd7z51hXGdS5Ae73PFRJ0UkSEs4EdmOvAwdlvNu9i06KZC7p4o9kSdXYRxYY4Sz7Nw1kUZQzwRNLaBXGOdRsqKsJZp/zzBxBevWSrN6g/xkfjVOy9vrb/d564asLd15ZNl7y1feTOWTqEEchRX2kyzQdciiannlWAZV3fCTM8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dfytfx5zh+NQO/nUfitWTX6VIGQ0ANIycYXylTSL4gM=;
 b=e0bsNDBlCiMVESKzhR4mgDLV1QRtEoKmoFQj0ssRpm+K8Cg4jEwddRGh1B42KbB3y2Fy22y054DcwAO8JjQR/sNVCBlQ56BcQ9k59DLkd9J5l8+RbXI2V6bYmf48kKZUuplNjeF34BQ76abfqgmZvuPIkndMIxeYmeRvVP+S47dSCSx23Zw+lOD8DWxrbCW5wVKrOJXoBcEFTkTt/OoUpZAk/7BscpG6Qs5cT/JBN3EPbQ4GVb/U08v/w90pmlmVGUR2EUcqCrq+ypy+CA4+uN/LLsMbAy03qjaMhlK3s90XyNtoN7VXR9v4T5RAG7EFdiGONmRHDCC0WdQHuViY+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dfytfx5zh+NQO/nUfitWTX6VIGQ0ANIycYXylTSL4gM=;
 b=mFz0ibYL4UQai12/P+W94g4QMy/bX8n3afBpAGfTvZYe2srCo1DovTjELoiOhNqfCVcumTbwbvJRuwYM19iKXB2V7GnNjuZkny8M4imUeFACpv+aOfxl98ldOtY1+xEj7DXogl2ykLoEr9dM/JW3+o9BnBL1Pru8HOuXdp7B39D1m7JVecQ4c8jCk3v+PGl9FhL9Cbi8hwU0M4CqxTJQZcgBrm7zfxIRMfAfhXlJeoIt39mrsB9eZKMCrD1Un+mF3c6RLkYNSbFi03IZrPCHRh2PZeZD++oEv2nDkNxQg81gf1LgROCN2/Qm6RFN0z6G8cONnCdNxUyb5uHlD+bcjw==
Received: from CO2PR04CA0193.namprd04.prod.outlook.com (2603:10b6:104:5::23)
 by BL0PR12MB2466.namprd12.prod.outlook.com (2603:10b6:207:4e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Thu, 3 Jun
 2021 16:01:03 +0000
Received: from CO1NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:104:5:cafe::9c) by CO2PR04CA0193.outlook.office365.com
 (2603:10b6:104:5::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.15 via Frontend
 Transport; Thu, 3 Jun 2021 16:01:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT010.mail.protection.outlook.com (10.13.175.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4195.22 via Frontend Transport; Thu, 3 Jun 2021 16:01:03 +0000
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 3 Jun
 2021 16:00:59 +0000
From:   Huy Nguyen <huyn@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <steffen.klassert@secunet.com>, <saeedm@nvidia.com>,
        <borisp@nvidia.com>, <raeds@nvidia.com>, <danielj@nvidia.com>,
        <yossiku@nvidia.com>, <kuba@kernel.org>, <huyn@nvidia.com>
Subject: [RESEND PATCH net v3 2/3] net/xfrm: Add inner_ipproto into sec_path
Date:   Thu, 3 Jun 2021 19:00:44 +0300
Message-ID: <20210603160045.11805-3-huyn@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210603160045.11805-1-huyn@nvidia.com>
References: <20210603160045.11805-1-huyn@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 45efb2be-de08-4fae-304a-08d926a8ca22
X-MS-TrafficTypeDiagnostic: BL0PR12MB2466:
X-Microsoft-Antispam-PRVS: <BL0PR12MB24666E78EE627EEC1A3DD212A23C9@BL0PR12MB2466.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WF2rvSXUJe3GZjTxpFcrhxKkD+6FY1jaSHPlOC82DjfiZ/ysxwEQ/r2lO3l59DYArr2vxaY/bgU0Zrh23Oyeuw9V4Dn8jQh/2muXxT/byUT8ZLpUw8APickq2QxR7iwMMNxIMi8gOpeuyvHwnbJNQMjIkDCEO8yf4gyvs0wVvD6I0gomsYooIpAJvIpeDGs2jseM16NmJSQG2pn/LMEuQIed6Uska1qtKs7JAatbexYzp7lvwf6I1i2OLDAp8ae+Rk6zUkwM59JONV5FzOfFXFdoAikoQrlBPMq/RtXcHKwU4tUAdJ/nWPEihYEpxOZOs98ltFZoHjNdaA2kuiGjtt4AZOWdwj7iz4Iofmaurptyb0vTT7MZWgBluPvecv2AeyYDXj7qfTRSF1qOo8EWxbpzGlbC63dlvBYq/EJmd0QmGG92dOySFxqYd1/nUu19m1Uu467bjARmeKwGmG086m5m7GgKe3ptorXKal/eMH/qBC/p0VVIRQnFv7cOk4+zboGUJUFVv/oBbdTfuJcnLEMLEWeUDXXhjJyGU7Ykfrz5VYQsabvVYIQXRnkJsDpOIkXfdhXIc546aQs7G9Nhbf3YfXdbrNQSQuIGnSDFmzUhR3TASG9em04/4I2iqga01twilcnt0DAoeuM1nS9Iq7IQCNw2T1AhuEhMNvfntug=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(39860400002)(396003)(346002)(376002)(36840700001)(46966006)(4326008)(36756003)(70586007)(6916009)(2906002)(26005)(8936002)(5660300002)(8676002)(107886003)(70206006)(478600001)(54906003)(426003)(316002)(36906005)(2616005)(86362001)(36860700001)(1076003)(336012)(82310400003)(83380400001)(16526019)(186003)(356005)(7636003)(82740400003)(47076005)(6666004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2021 16:01:03.6125
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 45efb2be-de08-4fae-304a-08d926a8ca22
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2466
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
 net/xfrm/xfrm_output.c | 44 +++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 6e11db6fa0ab..c51da30d2542 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1025,6 +1025,7 @@ struct xfrm_offload {
 #define CRYPTO_INVALID_PROTOCOL			128
 
 	__u8			proto;
+	__u8			inner_ipproto;
 };
 
 struct sec_path {
diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
index e4cb0ff4dcf4..cd70d2ea5d8b 100644
--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -565,6 +565,46 @@ static int xfrm_output_gso(struct net *net, struct sock *sk, struct sk_buff *skb
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
+	if (!skb->inner_protocol)
+		return;
+
+	xo = xfrm_offload(skb);
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
@@ -594,12 +634,14 @@ int xfrm_output(struct sock *sk, struct sk_buff *skb)
 			kfree_skb(skb);
 			return -ENOMEM;
 		}
-		skb->encapsulation = 1;
 
+		skb->encapsulation = 1;
 		sp->olen++;
 		sp->xvec[sp->len++] = x;
 		xfrm_state_hold(x);
 
+		xfrm_get_inner_ipproto(skb);
+
 		if (skb_is_gso(skb)) {
 			if (skb->inner_protocol)
 				return xfrm_output_gso(net, sk, skb);
-- 
2.24.1

