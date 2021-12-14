Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52B6F47493D
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 18:25:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236442AbhLNRZD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 12:25:03 -0500
Received: from mail-bn8nam11on2067.outbound.protection.outlook.com ([40.107.236.67]:36704
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236437AbhLNRZB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Dec 2021 12:25:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fyE94LdfHIdgBlKAs1IVytcPtuyUmtVVu74k3jgRus5GQ4iSeqoGQHS1QIyTQeeWHqheZwqtTFUbKDb8h7bkNM/fdVVj4FPmEImKJ63odOP42FM8O1NVG/RSAi/HI2392bj/xZJVmfofL6JzZyTLKsLCH+4CWxhG9vQOGgUFVoA7NevGJTDkeearIdAlSVsDrmZWt4ZR4WlSgbfhpng1gysSqrsvEJUSSOA227mijW47wPgtAS33SlrT0z78TG19bQeHAbT5zQaj++XiCZRPxkA/AkqBIHLO6CqwQ8ZrXPjytQpZG0k+SBXgKJN1AZbdptdJFjya2b7MCSh0cQ0WBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cGF+evTINXhfq54d8JVwPiilEbT5zDXXyh3ELFq6uTc=;
 b=Z66FyVY3zmMWu16Vioki2NjVXcroV69pTY2NQNj7SWax8WAa6yLKYZT3Xv02RqU/3dQ5R2AAQIOl/QuodkJVRC1k+nPp9+LkVMbTlsNikqQEIjuOzPXxGZ8sR4HSWLMaFED+WfQVzUBWuSlbtPqVHXztBnZyjJF1eMkip608UAjPQZlQyxPBOmQ4xpo/A7sWHPK7UOoylNBmBNKa0FVOanqZqDv5BKxxmOXEfhnlbRsy1FSurCCr5TpV183jrQsx++P7JDG2TXMDsbhOSID8wf7ccP6mi9Y/GkfYqeqZ86xttPZn/6EUrj9ncR3hRBFQC8mKeJ5dlqVSXuzGE3J13A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 203.18.50.13) smtp.rcpttodomain=ovn.org smtp.mailfrom=nvidia.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cGF+evTINXhfq54d8JVwPiilEbT5zDXXyh3ELFq6uTc=;
 b=jusejzC4PWljR5f3pIT3dR8s53DvLwg6OYv7XJb9WQx6BCoNonjmKtKbQkyNgGrTb3bun6ZRyRyfc8l1WGzLLSEjVJvkf845yZNnKJqklvb37n3ofD/x42NdXPaonWH0SBLmcpTvqxdO01cOEWchDVGbNcANX4vQmRezwjU/S2n93IaDerthPeg7NI4f2eJf5XSRcKfFVJpw6nZEwgQSj3Pw1WrjX6snjKuPpeewBVqWKp3rJYnqf0E5AJODxJLLW8Aq8pnXydS5tFWnftw7mKPl1aKNgDmWOu89dJ9BqDhe467Vbm+sEd2VTjihz0UZ16/oOtgPQkUPpAaMDP9++g==
Received: from MW4PR04CA0221.namprd04.prod.outlook.com (2603:10b6:303:87::16)
 by DM4PR12MB5120.namprd12.prod.outlook.com (2603:10b6:5:393::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.13; Tue, 14 Dec
 2021 17:24:59 +0000
Received: from CO1NAM11FT043.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:87:cafe::21) by MW4PR04CA0221.outlook.office365.com
 (2603:10b6:303:87::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14 via Frontend
 Transport; Tue, 14 Dec 2021 17:24:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 203.18.50.13)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 203.18.50.13 as permitted sender) receiver=protection.outlook.com;
 client-ip=203.18.50.13; helo=mail.nvidia.com;
Received: from mail.nvidia.com (203.18.50.13) by
 CO1NAM11FT043.mail.protection.outlook.com (10.13.174.193) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4778.13 via Frontend Transport; Tue, 14 Dec 2021 17:24:59 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HKMAIL102.nvidia.com
 (10.18.16.11) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 14 Dec
 2021 17:24:58 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 14 Dec
 2021 17:24:56 +0000
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (172.20.187.6) by
 mail.nvidia.com (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.18
 via Frontend Transport; Tue, 14 Dec 2021 17:24:53 +0000
From:   Paul Blakey <paulb@nvidia.com>
To:     Paul Blakey <paulb@nvidia.com>, <dev@openvswitch.org>,
        <netdev@vger.kernel.org>, Saeed Mahameed <saeedm@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "Pravin B Shelar" <pshelar@ovn.org>, <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>, wenxu <wenxu@ucloud.cn>,
        Jakub Kicinski <kuba@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
CC:     Oz Shlomo <ozsh@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Roi Dayan <roid@nvidia.com>
Subject: [PATCH net v3 3/3] net: openvswitch: Fix matching zone id for invalid conns arriving from tc
Date:   Tue, 14 Dec 2021 19:24:35 +0200
Message-ID: <20211214172435.24207-4-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20211214172435.24207-1-paulb@nvidia.com>
References: <20211214172435.24207-1-paulb@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: df39aa5a-43c8-4e70-1cde-08d9bf26a7fd
X-MS-TrafficTypeDiagnostic: DM4PR12MB5120:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB5120D851BB835DF5A95984A1C2759@DM4PR12MB5120.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cIPuuq+047UqjEEAeufGHRpIG0e6O65HqN3f0AzDLJxVVBjLkmSwFI1A9FZBj9ZlOOO74brRKsgyN+fttnFrCOElUyLpqSq2Dx1KuR5Qmh/Wj+H597ki1xtM9KoLPsXNUTgnJ8el76OxZ3qWKeivdvXYOrYCJfe6zjI9NuiwefbQUQ1TG7Dog0ipOdsXoPnpxVYuljiSerOSf533jZ7g5iF+copUQZANAJKMX24HnHZ1DH37X+B7LqyC3CGba6S53IGRrkoQzzrKVuUfvS1A/fy4WCpzyGzKDxQq+R9Zw2WBZhuXw9SRU8s/8ehnMH5LWJlfkLDra9j5AxOkKEzBit8kNxYkB+olQoe+YTQdcXCXfAFvBTTmqPtXaa5kve9OBmPwZSoDT1tNc5vjnMoGCAynBHrvq/LhX9PXLg8Fn2rPmU3g5FZnhQSmTz5CnXP1LrIV9RgVfcgev1he0PQ6Jz02J3ejkFJvzdMdy7JasZcAN0b1oPTqEWeQFwUNj6gpoBwe8rJi1doZhHTnuSQwtYLx2RxMrSENvWiOwrwgvkdbXaB8GieN3MuxrFyJxXiE5PLDRSDru8lea0bOsQxP6uA4OPdzUKNe32LA8bbJWGwkmP01XVU3YusbFxBNWwReJumyniw6XkxKR8KB20jVfRAYRgNKtvo3K3R57vl3QC7L+GlZoMK23CfFlpih9GZtfagWUVCvYZM4rbQutpXtdx6gDqmibeGTisyNFbqgeZncj+Z7+Ywsx2102yNl8VDoWR/LtZ5UkoyunpzvJGxkRUSlEwVGeg0O6onAv2gdzoHizmDUKURuAOsdvt2+Z1e5
X-Forefront-Antispam-Report: CIP:203.18.50.13;CTRY:HK;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:hkhybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700001)(70586007)(26005)(186003)(70206006)(7636003)(36756003)(34020700004)(508600001)(336012)(8936002)(86362001)(47076005)(6666004)(356005)(921005)(1076003)(2616005)(426003)(5660300002)(83380400001)(107886003)(82310400004)(8676002)(2906002)(36860700001)(4326008)(316002)(40460700001)(54906003)(110136005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 17:24:59.3931
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: df39aa5a-43c8-4e70-1cde-08d9bf26a7fd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[203.18.50.13];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT043.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5120
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zone id is not restored if we passed ct and ct rejected the connection,
as there is no ct info on the skb.

Save the zone from tc skb cb to tc skb extension and pass it on to
ovs, use that info to restore the zone id for invalid connections.

Fixes: d29334c15d33 ("net/sched: act_api: fix miss set post_ct for ovs after do conntrack in act_ct")
Signed-off-by: Paul Blakey <paulb@nvidia.com>
---
 include/linux/skbuff.h | 1 +
 net/openvswitch/flow.c | 8 +++++++-
 net/sched/cls_api.c    | 1 +
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 2ecf8cfd2223..4507d77d6941 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -286,6 +286,7 @@ struct nf_bridge_info {
 struct tc_skb_ext {
 	__u32 chain;
 	__u16 mru;
+	__u16 zone;
 	bool post_ct;
 };
 #endif
diff --git a/net/openvswitch/flow.c b/net/openvswitch/flow.c
index 9713035b89e3..6d262d9aa10e 100644
--- a/net/openvswitch/flow.c
+++ b/net/openvswitch/flow.c
@@ -34,6 +34,7 @@
 #include <net/mpls.h>
 #include <net/ndisc.h>
 #include <net/nsh.h>
+#include <net/netfilter/nf_conntrack_zones.h>
 
 #include "conntrack.h"
 #include "datapath.h"
@@ -860,6 +861,7 @@ int ovs_flow_key_extract(const struct ip_tunnel_info *tun_info,
 #endif
 	bool post_ct = false;
 	int res, err;
+	u16 zone = 0;
 
 	/* Extract metadata from packet. */
 	if (tun_info) {
@@ -898,6 +900,7 @@ int ovs_flow_key_extract(const struct ip_tunnel_info *tun_info,
 		key->recirc_id = tc_ext ? tc_ext->chain : 0;
 		OVS_CB(skb)->mru = tc_ext ? tc_ext->mru : 0;
 		post_ct = tc_ext ? tc_ext->post_ct : false;
+		zone = post_ct ? tc_ext->zone : 0;
 	} else {
 		key->recirc_id = 0;
 	}
@@ -906,8 +909,11 @@ int ovs_flow_key_extract(const struct ip_tunnel_info *tun_info,
 #endif
 
 	err = key_extract(skb, key);
-	if (!err)
+	if (!err) {
 		ovs_ct_fill_key(skb, key, post_ct);   /* Must be after key_extract(). */
+		if (post_ct && !skb_get_nfct(skb))
+			key->ct_zone = zone;
+	}
 	return err;
 }
 
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index a5050999d607..bede2bd47065 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -1625,6 +1625,7 @@ int tcf_classify(struct sk_buff *skb,
 		ext->chain = last_executed_chain;
 		ext->mru = cb->mru;
 		ext->post_ct = cb->post_ct;
+		ext->zone = cb->zone;
 	}
 
 	return ret;
-- 
2.30.1

