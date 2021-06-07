Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2E3239E619
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 20:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231460AbhFGSDT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 14:03:19 -0400
Received: from mail-dm6nam10on2043.outbound.protection.outlook.com ([40.107.93.43]:20448
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231415AbhFGSDR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 14:03:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UbKukMaGSfSK4nJTDZedfPD525pfZkaPKdYkZwFiwNLzUr+RcFWTN/G5n1iazdsr94NPNXpyZCGBdB8HGCFKehmZogK6Bfy21HYbvkgYjvvXHY8pi87Rwey/Jmpte5/LFchG5zdr1KDh6keZB/cKpcj927PJNg7c+uBeJxi9E9h2aPxQ65fUfVagxMJv7UX51u+a9knYQgM+P9oKwBi/fyo/E9AqTC7IBvCu31XlT+E/j/XXSJCmXCezov4TBh1ScJxuwxcYqzKhoCIpB3yQvoR2amo1edfffxhncgQx8Xcc83kC7pMyYboiDwsVD3se4VgLHOh1iBG4vVtoMVXy8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wFIHDHVBeug4GibnJQYQzQ5k/c9d9w/PXxyMt+3gjXk=;
 b=DMQXlBpTjYj3AieNkzVD3Ay7nZKQZ/X/lFqBeMocQKqdcH6RxHi4kl8GEMFSnFeE+QiB09je0fDFjxPpBFfVv5t4ksWn2tjmR9f5gt3l4D7iX8tLM3jsuu8bnZ0c2yHAFPSxdtIKrTF6DzEC2Jphskoq329GTc+9v/JVsRsNtADc/ZYT3gLS+TnMaye/mhWrOM+pr/nuMEznxMOu4NcL6+yj7SpWSAMqkJfiHS+Q6IcSih9E+YnRRh/fPwy0YxtWmLsP6iKDKbfESa3qR6OwActo2gPOVPu1zFPKbPFyYjUV7rMtw8EmenioqQNscXUVUeNEO1jGOpLkxrdLUnOPKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wFIHDHVBeug4GibnJQYQzQ5k/c9d9w/PXxyMt+3gjXk=;
 b=tsVi0PKR7q0w0iEiFHoUAoNTapSVlEICs6K3KJaZmRO5Am1n2HqTncBHwhvnSGmkSCczx0mJQqlObNUJtWFYL93p6QvLsTPeSHaEowMlezDobZfe69OBmzDdbHxxFxD9iICsrK13WtKSgIIigkDsuSVcU7obgOfgcb9KNKhYOWzKDfhtkDt3GJc9e3MqlHQpmBOJexUl0a/aks5nvpGShwkqg+5d0VzgN6aYhUaObEbE3kjRSfzShsOhtX/c9WyEkt7II+oNuvXDct1PucEZZ4bb60c9EwCiimE6hk9ImZX+EDCMaDZKZSHJl/YBLIcrMMMxfDS2A5yqRdFXWOn9XQ==
Received: from DS7PR03CA0214.namprd03.prod.outlook.com (2603:10b6:5:3ba::9) by
 BL0PR12MB2353.namprd12.prod.outlook.com (2603:10b6:207:4c::31) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4195.24; Mon, 7 Jun 2021 18:01:24 +0000
Received: from DM6NAM11FT011.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3ba:cafe::8a) by DS7PR03CA0214.outlook.office365.com
 (2603:10b6:5:3ba::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.21 via Frontend
 Transport; Mon, 7 Jun 2021 18:01:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT011.mail.protection.outlook.com (10.13.172.108) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4195.22 via Frontend Transport; Mon, 7 Jun 2021 18:01:24 +0000
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 7 Jun
 2021 18:01:01 +0000
From:   Huy Nguyen <huyn@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <steffen.klassert@secunet.com>, <saeedm@nvidia.com>,
        <borisp@nvidia.com>, <raeds@nvidia.com>, <danielj@nvidia.com>,
        <yossiku@nvidia.com>, <kuba@kernel.org>, <huyn@nvidia.com>
Subject: [PATCH net-next v4 2/3] net/xfrm: Add inner_ipproto into sec_path
Date:   Mon, 7 Jun 2021 21:00:45 +0300
Message-ID: <20210607180046.13212-3-huyn@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210607180046.13212-1-huyn@nvidia.com>
References: <20210607180046.13212-1-huyn@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b6e40196-137a-4cd9-0d2a-08d929de43ee
X-MS-TrafficTypeDiagnostic: BL0PR12MB2353:
X-Microsoft-Antispam-PRVS: <BL0PR12MB235332158CA33A2C517516A8A2389@BL0PR12MB2353.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KmdyOUrfYO08RBxS0gIcjhSZz7XL5F0/bqf6jq0JpGi8ExSVyaIUabIYHmRY9jkclnFE8aL05hF9ksYMERrWaMUnPDtw0LX/TvqdWf6WxFxqhkjQ6d0M6x+iqzVxunCCi3ZXbu+amGfSHZusYG5MpaoTEC0tsDC4eNRO1qIdBT7TZuOMqMyEI/HX/a16ZNp3Fk09WW7gkkZiwCd3BZ/VKleGONNin7BZTTltjuM+yXtJRulCKKtr+k3gHJLqnLpk6IshfmZC29in/nX3G2jm/etKVXE2Lp7nx/msu7WZoRItcnfIELZ6GSPEY+Vl4HGzcwnZTrq7fB2D6f8UpDnx/0G+RDTPhjzarMxzavnWxNzm8wr07ZZqSxrIHdB/zdgrfhr69Z1aPqHPYIWp3VR2y2EA9ilhmT6+ZAt6wSn4aIHUDSNByZZn3PokoPea8LWDyTKCNi7mp0TXOSZwVPQmbIwU4FXmsaAuCvaPZOL5vKJnf605lwlWG4NgScnxGoAc4iEoZRFScskd7Uaoihj/gVzsORj+3eE65/LbVKHcmcQ4AnqfuFzgYUtlmE6bu2LmGaAPeGNNcHpLrWGcoPFiUNsM6w61Ii+pbkZAzBMtj8t5yWVdZW4tOAtZTBhl89fjxaGp2xHRr7a/7AD2KE1IgA==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(54906003)(36906005)(86362001)(498600001)(336012)(426003)(4326008)(16526019)(186003)(2616005)(26005)(6916009)(82310400003)(83380400001)(107886003)(6666004)(47076005)(2906002)(8676002)(8936002)(36860700001)(1076003)(36756003)(70206006)(70586007)(5660300002)(7636003)(356005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2021 18:01:24.7516
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b6e40196-137a-4cd9-0d2a-08d929de43ee
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT011.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2353
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
 net/xfrm/xfrm_output.c | 42 +++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 42 insertions(+), 1 deletion(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index c58a6d4eb610..1d803e890c76 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1024,6 +1024,7 @@ struct xfrm_offload {
 #define CRYPTO_INVALID_PROTOCOL			128
 
 	__u8			proto;
+	__u8			inner_ipproto;
 };
 
 struct sec_path {
diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
index e4cb0ff4dcf4..e80377535de0 100644
--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -565,6 +565,43 @@ static int xfrm_output_gso(struct net *net, struct sock *sk, struct sk_buff *skb
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
@@ -594,12 +631,15 @@ int xfrm_output(struct sock *sk, struct sk_buff *skb)
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

