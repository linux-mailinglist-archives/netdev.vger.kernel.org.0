Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6B3D59841D
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 15:26:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245036AbiHRNYa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 09:24:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245033AbiHRNY1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 09:24:27 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2073.outbound.protection.outlook.com [40.107.220.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 925BC3B971
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 06:24:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UUBPJSCoiWCsTrF+YE3rdNvu1KQMP2L2HEI+EuCFrq9/wqNzC7cwLMbnJ5E1BPxfMGL2qiWJO+qhBfUuvufsiaji/8penWB7Xjyu9eIYb5kBZsr9sjMmSbuG99LKJ2Kslwrxfs52rj5eWBnOwyZNwZVXC+mP4Bd86wdk+JggZ+wGQSJA2W1/Le1E03QYQ1p7ZQ5BkQdUedD0U7ru8YpcUMlbo6rqLZraJjgiI0mP7oK4GBcX6DIGdY0gA/jprp8EiWU9EqrDybYxOv49BmOwWNfxXevcmpcNQ69FbqwYbWqRN+mZ708jR0j2yBQYTYikAI2jNgotzGJyzuT/7slTlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t96AmpkvnOs9JsHTHkia549KHCyhSuRDbJt49BApqRs=;
 b=CFvLk8Y7IN0j+3KQgJOOWOkj/fMrnUzfnSWCuvRq+G3ZzpCgJthlFG1x+LC/RL7arzjM7As+xZrKrZu61AqjH0/VSq+Gzv/+1QMXNtVpj/hdBAEBJLp/MbGkl17DfMdLSn81VBaoX5q/PheNvCpkOhee0YaBjV7v1RuqfOghYKm+Vqi9GV9uS80Hx10mPzURIH43YO0CVfuV+KJX8BhW5ngT4f1tHQlPDfV/lByHPvC7SDPN29uGALYXGD8nT3OdYzm5/bv9LdFbzxccCCG52jeMxQkyT2y0G6WnveuCvTSujPNXTT6vuzweGMH62aqxE4psIKZ1cN2eeUF87B/8cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t96AmpkvnOs9JsHTHkia549KHCyhSuRDbJt49BApqRs=;
 b=geS90nukRiFD+RNUfvZd+MgCB+oLcMxFo570GRZ5QCGsslLhTAmPf5DZCSyqWP3EY7jeDeHjstL4h6F2T4dwFwl2S7OZBzC3fAbky5MFP/T0n4rdSdMoX2pgB03LnklAtjivS/yOtw1ZQaWjdnZkDRKBhDQUvbEdZ+IqjM+wAZK3nHch1to0CPuaftdc9+ppNheLPxuTmJbOTjwTLISQKdjmRb94QZJQ6PvlnOzcRg3QKzSqXPrEC+VknibSfxdUECkIIywkmrvlLCEpvUKPQiu11twJ85zc/qK8/UWBUPVO8H3OzNHgu6L9u8io2STCX+9A1cwAbCDePi5HIL4bMw==
Received: from DM6PR13CA0023.namprd13.prod.outlook.com (2603:10b6:5:bc::36) by
 BYAPR12MB3126.namprd12.prod.outlook.com (2603:10b6:a03:df::28) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5525.11; Thu, 18 Aug 2022 13:24:24 +0000
Received: from DM6NAM11FT105.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:bc:cafe::57) by DM6PR13CA0023.outlook.office365.com
 (2603:10b6:5:bc::36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.14 via Frontend
 Transport; Thu, 18 Aug 2022 13:24:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT105.mail.protection.outlook.com (10.13.173.164) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5546.7 via Frontend Transport; Thu, 18 Aug 2022 13:24:23 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Thu, 18 Aug
 2022 13:24:22 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Thu, 18 Aug
 2022 06:24:22 -0700
Received: from nps-server-31.mtl.labs.mlnx (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server id 15.2.986.29 via Frontend
 Transport; Thu, 18 Aug 2022 06:24:19 -0700
From:   Lior Nahmanson <liorna@nvidia.com>
To:     <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Lior Nahmanson <liorna@nvidia.com>,
        Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 1/3] net/macsec: Add MACsec skb_metadata_dst Tx Data path support
Date:   Thu, 18 Aug 2022 16:24:09 +0300
Message-ID: <20220818132411.578-2-liorna@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20220818132411.578-1-liorna@nvidia.com>
References: <20220818132411.578-1-liorna@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f3fa9425-aaab-4f64-a923-08da811cf754
X-MS-TrafficTypeDiagnostic: BYAPR12MB3126:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qMaLdAIMKMi1nXU4FQYuIWSSAF01LWyl7vQWBgJ55duJT0q66Izc8l5BvFVTJU0MjdT0Bq7Qb3L7Fs9EKAYO+OQck5Zqnx4Qt5tbXegeaTa3QpCGHYHil9bgmFUrwY/e0hoOt3BtTLgNQU2GNJSqtfPpG2NdNvwrtmPFdAweYzdXc8o/iedpek+PxsVEpxCkvHVK2FOLhhiWKVo++FPKoCzucfcXdx/oF4DabB3uKsnkROzROQ1osahmO2kWRvBYhhLkg60QLKSQ81wY3ZvMEzp4U8axgNXr7GFMpp+oT7Uf7/kx3kwQCMr5Euxt9hYP2KvlksT64EjAaDQzGTQ6x9HDbRLj6W0nipzic7B8ZFCNnlDAxslW/zei2g1MXmec11HImyeFwvnNcdMLbVXmxaf5O+BEmlvEhClCWmtXF9ic62msXjHMJxX5OYBpwJDMXZxwQ5xViVzPT2nC26zu9fvfLMLy+FgPs1P7WqnPNDeJbkvmUuqqS8xU0RdjQtqAE5dbtLP5UqDt7ksaPCwMeXEfls1lLk9vh1R6ENiLvyo0sm23cL0cvEtcPRym+R8TdHJ+Hh9nzVpCXZSUFrNIm0mgwSfG9r1ainmhbPcCB3YklbU9zSVBBccI//LCkEemMlOzYUoe/TnD6paRCzT9ffWnfg1Cd420jJfbfoyfIjpUcKMwR10OjXMN3kMmPAe+KlyhcCXB0xLXwwQJQtK7DxGHn/nheFGbHs1lICVF5PlYCqPmYKUi71uqO5Yz/jS/qMMKCwaLyr+HYN2pnsS+kluJNfSr7mSY77CQt/wTQEk=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(376002)(39860400002)(346002)(396003)(40470700004)(46966006)(36840700001)(4326008)(54906003)(8676002)(36756003)(2906002)(36860700001)(83380400001)(110136005)(70206006)(316002)(5660300002)(70586007)(478600001)(40480700001)(40460700003)(26005)(6666004)(186003)(81166007)(47076005)(86362001)(2616005)(336012)(107886003)(82310400005)(1076003)(426003)(8936002)(356005)(82740400003)(41300700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 13:24:23.3840
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f3fa9425-aaab-4f64-a923-08da811cf754
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT105.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3126
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the current MACsec offload implementation, MACsec interfaces shares
the same MAC address by default.
Therefore, HW can't distinguish from which MACsec interface the traffic
originated from.

MACsec stack will use skb_metadata_dst to store the SCI value, which is
unique per MACsec interface, skb_metadat_dst will be used later by the
offloading device driver to associate the SKB with the corresponding
offloaded interface (SCI) to facilitate HW MACsec offload.

Signed-off-by: Lior Nahmanson <liorna@nvidia.com>
Reviewed-by: Raed Salem <raeds@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/macsec.c       | 15 +++++++++++++++
 include/net/dst_metadata.h | 10 ++++++++++
 include/net/macsec.h       |  3 +++
 3 files changed, 28 insertions(+)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index f1683ce6b561..4bf7f9870b91 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -18,6 +18,7 @@
 #include <net/sock.h>
 #include <net/gro_cells.h>
 #include <net/macsec.h>
+#include <net/dst_metadata.h>
 #include <linux/phy.h>
 #include <linux/byteorder/generic.h>
 #include <linux/if_arp.h>
@@ -3381,6 +3382,11 @@ static netdev_tx_t macsec_start_xmit(struct sk_buff *skb,
 	int ret, len;
 
 	if (macsec_is_offloaded(netdev_priv(dev))) {
+		struct metadata_dst *md_dst = secy->tx_sc.md_dst;
+
+		skb_dst_drop(skb);
+		dst_hold(&md_dst->dst);
+		skb_dst_set(skb, &md_dst->dst);
 		skb->dev = macsec->real_dev;
 		return dev_queue_xmit(skb);
 	}
@@ -3708,6 +3714,7 @@ static void macsec_free_netdev(struct net_device *dev)
 {
 	struct macsec_dev *macsec = macsec_priv(dev);
 
+	metadata_dst_free(macsec->secy.tx_sc.md_dst);
 	free_percpu(macsec->stats);
 	free_percpu(macsec->secy.tx_sc.stats);
 
@@ -3975,6 +3982,13 @@ static int macsec_add_dev(struct net_device *dev, sci_t sci, u8 icv_len)
 		return -ENOMEM;
 	}
 
+	secy->tx_sc.md_dst = metadata_dst_alloc(0, METADATA_MACSEC, GFP_KERNEL);
+	if (!secy->tx_sc.md_dst) {
+		free_percpu(secy->tx_sc.stats);
+		free_percpu(macsec->stats);
+		return -ENOMEM;
+	}
+
 	if (sci == MACSEC_UNDEF_SCI)
 		sci = dev_to_sci(dev, MACSEC_PORT_ES);
 
@@ -3988,6 +4002,7 @@ static int macsec_add_dev(struct net_device *dev, sci_t sci, u8 icv_len)
 	secy->xpn = DEFAULT_XPN;
 
 	secy->sci = sci;
+	secy->tx_sc.md_dst->u.macsec_info.sci = sci;
 	secy->tx_sc.active = true;
 	secy->tx_sc.encoding_sa = DEFAULT_ENCODING_SA;
 	secy->tx_sc.encrypt = DEFAULT_ENCRYPT;
diff --git a/include/net/dst_metadata.h b/include/net/dst_metadata.h
index adab27ba1ecb..22a6924bf6da 100644
--- a/include/net/dst_metadata.h
+++ b/include/net/dst_metadata.h
@@ -4,11 +4,13 @@
 
 #include <linux/skbuff.h>
 #include <net/ip_tunnels.h>
+#include <net/macsec.h>
 #include <net/dst.h>
 
 enum metadata_type {
 	METADATA_IP_TUNNEL,
 	METADATA_HW_PORT_MUX,
+	METADATA_MACSEC,
 };
 
 struct hw_port_info {
@@ -16,12 +18,17 @@ struct hw_port_info {
 	u32 port_id;
 };
 
+struct macsec_info {
+	sci_t sci;
+};
+
 struct metadata_dst {
 	struct dst_entry		dst;
 	enum metadata_type		type;
 	union {
 		struct ip_tunnel_info	tun_info;
 		struct hw_port_info	port_info;
+		struct macsec_info	macsec_info;
 	} u;
 };
 
@@ -82,6 +89,9 @@ static inline int skb_metadata_dst_cmp(const struct sk_buff *skb_a,
 		return memcmp(&a->u.tun_info, &b->u.tun_info,
 			      sizeof(a->u.tun_info) +
 					 a->u.tun_info.options_len);
+	case METADATA_MACSEC:
+		return memcmp(&a->u.macsec_info, &b->u.macsec_info,
+			      sizeof(a->u.macsec_info));
 	default:
 		return 1;
 	}
diff --git a/include/net/macsec.h b/include/net/macsec.h
index d6fa6b97f6ef..aae6c510df05 100644
--- a/include/net/macsec.h
+++ b/include/net/macsec.h
@@ -20,6 +20,8 @@
 typedef u64 __bitwise sci_t;
 typedef u32 __bitwise ssci_t;
 
+struct metadata_dst;
+
 typedef union salt {
 	struct {
 		u32 ssci;
@@ -193,6 +195,7 @@ struct macsec_tx_sc {
 	bool scb;
 	struct macsec_tx_sa __rcu *sa[MACSEC_NUM_AN];
 	struct pcpu_tx_sc_stats __percpu *stats;
+	struct metadata_dst *md_dst;
 };
 
 /**
-- 
2.21.3

