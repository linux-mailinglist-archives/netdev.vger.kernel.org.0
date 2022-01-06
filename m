Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7B94866CF
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 16:38:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240511AbiAFPiO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 10:38:14 -0500
Received: from mail-mw2nam12on2056.outbound.protection.outlook.com ([40.107.244.56]:36928
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240507AbiAFPiO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jan 2022 10:38:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IPnAh7J0DIl/Nyg/84csM3VL8J89z4jJWfQgbyUq08pA/uEiNsoI++RBiWOnX7yA8xFYm/VAexpQwPG9s2JgH0EI79cOYFG2jiUuk1+1itoMNy4e2Do4eLA6gcTfeGIS9oiQhvJw7EG56Gs21xqu0qjRJGrRF8om0QfyS0xDlceNK19IXoHGQa+1dXz8loxdD+CExZyt6ZXK8aoPCq96YwK5tO3i0OWaREpKFBErX4ctsVG8M8LHWrrunRKszC0X0UBILhl2Rcs1QP9gK5zxpkDx6n+QwjneC79PGHGy2GhL3n0iXLg+dEX+RAbm4211QiZUX4g7zuBpsEKJqP+FQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eJgvO7roB33NVt/UZMMI5f4GiEPKvaOUbd/qtkB7+Vo=;
 b=fU3nDitvxxU39OOzB9Jem8Hu1jIw0IWC0T2Y+/IqyvtLktftwan9G7VQgvWYDkz69jxttB0xnftIE/7WssNVt5NgQr1CEx5AO9RJmksUsxbUsaGqGleddLz+naJ2WHA6Ub84wc6uKac09K90j9TskbwdRDSM5YnCRi2KaB3NUxjY4GrytD0wK/+qtAakym9cCbVWRVCM96qD7T5+m/5r5GadPqjGAlus2KDf+4tMIzrODaWbPNLhE//pFpPKr3SPBjyeEHWHUS2faPrdvWyc8GP1cjgAi+OwuJ5x0uNmCEI/gqlhVqmXB9ZG9vQ/3iO17b860viP97ZTWMDx1lBUow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=ovn.org smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eJgvO7roB33NVt/UZMMI5f4GiEPKvaOUbd/qtkB7+Vo=;
 b=CbRObZTWoIcOofFObhpt1DHys+4ws/l+0loXMXcwhRDIziKI9N0FgFtJDSbXmFeQZlVVzdYwShy5lkf3/envSeQdO+/Qw5XLF6PQtvEPYy4zBcvMZSPlrcxQY1yw8UKdvGoZnq7Wxa8e+pYAoxyTkj70cf0M4gRqwEVMb7GOpqPTckE+X1Ltxfsgf8ji0q0lrYrTPdBbhbqvLnNHbkWS0VJ7TK+v0XE3ngjckDTMj9ox79nl8zyNFp8NmpQ4XZiLmj7ZRHJh4dmx3V+OdJ2IQxO6Ndwn9K0nIGfVCq08iVybepTE2LLaE0Ss0LyL7MmFrpz8bDWevlfDQ86b76o8jA==
Received: from DM3PR14CA0132.namprd14.prod.outlook.com (2603:10b6:0:53::16) by
 BL1PR12MB5063.namprd12.prod.outlook.com (2603:10b6:208:31a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Thu, 6 Jan
 2022 15:38:11 +0000
Received: from DM6NAM11FT038.eop-nam11.prod.protection.outlook.com
 (2603:10b6:0:53:cafe::8d) by DM3PR14CA0132.outlook.office365.com
 (2603:10b6:0:53::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9 via Frontend
 Transport; Thu, 6 Jan 2022 15:38:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT038.mail.protection.outlook.com (10.13.173.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4867.9 via Frontend Transport; Thu, 6 Jan 2022 15:38:10 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 6 Jan
 2022 15:38:09 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 6 Jan
 2022 07:38:09 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (172.20.187.5) by
 mail.nvidia.com (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.18
 via Frontend Transport; Thu, 6 Jan 2022 15:38:06 +0000
From:   Paul Blakey <paulb@nvidia.com>
To:     Paul Blakey <paulb@nvidia.com>, <dev@openvswitch.org>,
        <netdev@vger.kernel.org>, Cong Wang <xiyou.wangcong@gmail.com>,
        "Jamal Hadi Salim" <jhs@mojatatu.com>,
        Pravin B Shelar <pshelar@ovn.org>, <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
CC:     Saeed Mahameed <saeedm@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        "Vlad Buslov" <vladbu@nvidia.com>, Roi Dayan <roid@nvidia.com>
Subject: [PATCH net v2 1/1] net: openvswitch: Fix ct_state nat flags for conns arriving from tc
Date:   Thu, 6 Jan 2022 17:38:04 +0200
Message-ID: <20220106153804.26451-1-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7b8bfb4f-d509-44f8-fe56-08d9d12a8b77
X-MS-TrafficTypeDiagnostic: BL1PR12MB5063:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB5063C3BA133803887512B197C24C9@BL1PR12MB5063.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uCBl1KGInv7AqjiOH42oXHfMmnXnT/tmyOIhFvazOMYwOq/mbgW8mleInOjXyMBCPqGIoSzbTvtw1CSz3PsQLH9fSgIf/02nCHDsIu6Vus2mSiA3UyC/M/FZdOvVaLtH5hPdDhvcnEiNE6zZn5BlSqWNGNmSfTudayqxEs3MqSvpSNr4reF36impToiNlJEQXjc6NeDnaM3vQsZfiboPY77hVq7r6bwv2mb58NDftlmZ9wp2Nq+zolB2IafDYWDKrG2OJu+HlLKWdTPmWVtpjg0F+T+Z+4TxC80snN23/+74NdhQy//Hy0D08vMtPz1+FImf8jeZq8f+zXqgLS21grB2Mhf+Rclo9yn/RQ3CDEutk57JhFgDDeVHuUXgbyUffNU47w6FYp7/VSBpqYOY0qi1ov1NoVP4nNrDXE5JSb/x9j9MVsKgv5ISoFdoypZiV+BcMVZaGA8c4LTJrhXzdvW3DxENR5CN1LSpyGzkJjkBZfvubL3klwdiREQ+ie5zRLArHYNDr8p3djXLxTGm2a0nzQe8oDu267uXlwSbkDs0A74gaHivVwVOrEEMYJ5r6wUVMXes3l6TZFFv2gVTVqR79HzBiD1cGErzDZUPosOcxJsVbQGs2eqsga/9t/0nJ7EluEB4OJryNa1bHdygFCIs4nZv6QbOkQR00dUcW+Wvz7ranCrFSdn34FpKlB8eNmDcpDbZfAHXyLSLd6tYZlsv4TFdCJgDDaqgWNCHxAHzuMiAuTsFpaQE4X248zYSUnIfzqTZPHziCp1ATGnzHLpJz8yp0V4CE5btIa4rBA4=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700002)(4326008)(2616005)(1076003)(316002)(70586007)(70206006)(8936002)(2906002)(86362001)(107886003)(8676002)(426003)(83380400001)(82310400004)(81166007)(336012)(356005)(110136005)(54906003)(36756003)(186003)(5660300002)(40460700001)(508600001)(26005)(47076005)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2022 15:38:10.5239
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b8bfb4f-d509-44f8-fe56-08d9d12a8b77
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT038.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5063
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Netfilter conntrack maintains NAT flags per connection indicating
whether NAT was configured for the connection. Openvswitch maintains
NAT flags on the per packet flow key ct_state field, indicating
whether NAT was actually executed on the packet.

When a packet misses from tc to ovs the conntrack NAT flags are set.
However, NAT was not necessarily executed on the packet because the
connection's state might still be in NEW state. As such, openvswitch
wrongly assumes that NAT was executed and sets an incorrect flow key
NAT flags.

Fix this, by flagging to openvswitch which NAT was actually done in
act_ct via tc_skb_ext and tc_skb_cb to the openvswitch module, so
the packet flow key NAT flags will be correctly set.

Fixes: b57dc7c13ea9 ("net/sched: Introduce action ct")
Signed-off-by: Paul Blakey <paulb@nvidia.com>
---
 Changelog:
   v1->v2:
     changed bool bitfield to u8
     removed extra space in struct
     added fixes line

 include/linux/skbuff.h  |  4 +++-
 include/net/pkt_sched.h |  4 +++-
 net/openvswitch/flow.c  | 16 +++++++++++++---
 net/sched/act_ct.c      |  6 ++++++
 net/sched/cls_api.c     |  2 ++
 5 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 4507d77d6941..60ab0c2fe567 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -287,7 +287,9 @@ struct tc_skb_ext {
 	__u32 chain;
 	__u16 mru;
 	__u16 zone;
-	bool post_ct;
+	u8 post_ct:1;
+	u8 post_ct_snat:1;
+	u8 post_ct_dnat:1;
 };
 #endif
 
diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
index 9e71691c491b..9e7b21c0b3a6 100644
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -197,7 +197,9 @@ struct tc_skb_cb {
 	struct qdisc_skb_cb qdisc_cb;
 
 	u16 mru;
-	bool post_ct;
+	u8 post_ct:1;
+	u8 post_ct_snat:1;
+	u8 post_ct_dnat:1;
 	u16 zone; /* Only valid if post_ct = true */
 };
 
diff --git a/net/openvswitch/flow.c b/net/openvswitch/flow.c
index 6d262d9aa10e..02096f2ec678 100644
--- a/net/openvswitch/flow.c
+++ b/net/openvswitch/flow.c
@@ -859,7 +859,7 @@ int ovs_flow_key_extract(const struct ip_tunnel_info *tun_info,
 #if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
 	struct tc_skb_ext *tc_ext;
 #endif
-	bool post_ct = false;
+	bool post_ct = false, post_ct_snat = false, post_ct_dnat = false;
 	int res, err;
 	u16 zone = 0;
 
@@ -900,6 +900,8 @@ int ovs_flow_key_extract(const struct ip_tunnel_info *tun_info,
 		key->recirc_id = tc_ext ? tc_ext->chain : 0;
 		OVS_CB(skb)->mru = tc_ext ? tc_ext->mru : 0;
 		post_ct = tc_ext ? tc_ext->post_ct : false;
+		post_ct_snat = post_ct ? tc_ext->post_ct_snat : false;
+		post_ct_dnat = post_ct ? tc_ext->post_ct_dnat : false;
 		zone = post_ct ? tc_ext->zone : 0;
 	} else {
 		key->recirc_id = 0;
@@ -911,8 +913,16 @@ int ovs_flow_key_extract(const struct ip_tunnel_info *tun_info,
 	err = key_extract(skb, key);
 	if (!err) {
 		ovs_ct_fill_key(skb, key, post_ct);   /* Must be after key_extract(). */
-		if (post_ct && !skb_get_nfct(skb))
-			key->ct_zone = zone;
+		if (post_ct) {
+			if (!skb_get_nfct(skb)) {
+				key->ct_zone = zone;
+			} else {
+				if (!post_ct_dnat)
+					key->ct_state &= ~OVS_CS_F_DST_NAT;
+				if (!post_ct_snat)
+					key->ct_state &= ~OVS_CS_F_SRC_NAT;
+			}
+		}
 	}
 	return err;
 }
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index ab3591408419..2a17eb77c904 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -839,6 +839,12 @@ static int ct_nat_execute(struct sk_buff *skb, struct nf_conn *ct,
 	}
 
 	err = nf_nat_packet(ct, ctinfo, hooknum, skb);
+	if (err == NF_ACCEPT) {
+		if (maniptype == NF_NAT_MANIP_SRC)
+			tc_skb_cb(skb)->post_ct_snat = 1;
+		if (maniptype == NF_NAT_MANIP_DST)
+			tc_skb_cb(skb)->post_ct_dnat = 1;
+	}
 out:
 	return err;
 }
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 35c74bdde848..cc9409aa755e 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -1625,6 +1625,8 @@ int tcf_classify(struct sk_buff *skb,
 		ext->chain = last_executed_chain;
 		ext->mru = cb->mru;
 		ext->post_ct = cb->post_ct;
+		ext->post_ct_snat = cb->post_ct_snat;
+		ext->post_ct_dnat = cb->post_ct_dnat;
 		ext->zone = cb->zone;
 	}
 
-- 
2.30.1

