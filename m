Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E723F46E395
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 08:58:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234141AbhLIIBa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 03:01:30 -0500
Received: from mail-dm3nam07on2074.outbound.protection.outlook.com ([40.107.95.74]:14432
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234124AbhLIIB3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 03:01:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VHRUt5pOdeobjA/AGVvPbjBwGN4zjsKDsBelflJfzj/xM/BCtiDMY3ZO90k5+hft9Lvryig/6p9GhovZvOA5fP8L6D9g82OXOPLUudV30T6f+GDyEdNIcwGI+N5R4/cFY2LRQ0+S70pKkJ3e5IrikpnpgMqmvnh+olHofHPwU4nL4i51xociHFmZ9f79EiA8gjInDmMAuPsvGwXxQoNG8lB/vg4evWxnNteugSchWo6MQteWhu5ORkpKkGtxdnZ4jNNiR9VURvUPEKvbbVUpYNLmYwgjU2uNnIggFsoh6Q3XYUqZqBGWN3qqQw9ZSQTZZc8wTmE7MeE+MPiwgTtWBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mQChzFtbCG0LajkUA8sURJucOpTY8B5TqXPXoPRwYGU=;
 b=dcYHB7pbMTWFW5k2Mc1kB/tVi5Or40hhWvsRKkGloaCtvwzAC+5ZZWFzIj7n0xRf2qeV4809z7oHHZku8Baw2MXBZoCR3hprvExeaqSGDE9lvvHz3qyRoWN84UTNJJLDE2H4xOTtsq0poQi7nCClbRFakTIlSHhhH2X3yp3Yr95+vehYF2aUW+//s0svd+rM+tLo7LmyRvVcDc8q8Tisb0Ssr2gN+6kfiQTmmDpq710nMzgBZvddldnUxpjSjDOZhIaTlJ86KacvyRewtFWXeU5AadbZQlxGL7cSuQ3fEwKqPo6H7nXaueJR5KCf332dd4KlQLa1wAsSuMoTZxTqyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 203.18.50.13) smtp.rcpttodomain=ovn.org smtp.mailfrom=nvidia.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mQChzFtbCG0LajkUA8sURJucOpTY8B5TqXPXoPRwYGU=;
 b=LAUfOxaZ8LALTCuap3I9mNfTVEs7b5ffiALF+923cuBPfHlRX/pJN4OU1Zg8KwQQ4FKIZATAoZ+DcFjgeRju6eeSJfhpo9Zn7UeN9RXfzYBjL5dCm22JQMCXaJa7zS5mYyxjVjEWe0Qpgg0S/a6EQc3jJk7HA6pfXgfk6KvL+PYOISpTXmoXh8RMf5BC6lpDSg+/qcSBQDSKnfEF0gejlb1kl3csQ2FBHVb/FIxRmxzGAJTYrB+259uf04zClu8znsSnXD6Ib8btP7fPQ+TdCIeqC/TlxjjOu8dNl2iDqaQ6yaV9mHEzN6PI/nvMYHhts7rBUx4eW5R1d7nqQdULxA==
Received: from DM5PR19CA0039.namprd19.prod.outlook.com (2603:10b6:3:9a::25) by
 SN6PR12MB2607.namprd12.prod.outlook.com (2603:10b6:805:6d::30) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4755.15; Thu, 9 Dec 2021 07:57:54 +0000
Received: from DM6NAM11FT066.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:9a:cafe::c9) by DM5PR19CA0039.outlook.office365.com
 (2603:10b6:3:9a::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21 via Frontend
 Transport; Thu, 9 Dec 2021 07:57:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 203.18.50.13)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 203.18.50.13 as permitted sender) receiver=protection.outlook.com;
 client-ip=203.18.50.13; helo=mail.nvidia.com;
Received: from mail.nvidia.com (203.18.50.13) by
 DM6NAM11FT066.mail.protection.outlook.com (10.13.173.179) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4755.13 via Frontend Transport; Thu, 9 Dec 2021 07:57:53 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HKMAIL102.nvidia.com
 (10.18.16.11) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 9 Dec
 2021 07:57:52 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 9 Dec
 2021 07:57:50 +0000
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (172.20.187.5) by
 mail.nvidia.com (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.18
 via Frontend Transport; Thu, 9 Dec 2021 07:57:47 +0000
From:   Paul Blakey <paulb@nvidia.com>
To:     Paul Blakey <paulb@nvidia.com>, <dev@openvswitch.org>,
        <netdev@vger.kernel.org>, Saeed Mahameed <saeedm@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "Pravin B Shelar" <pshelar@ovn.org>, <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>, wenxu <wenxu@ucloud.cn>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
CC:     Oz Shlomo <ozsh@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Roi Dayan <roid@nvidia.com>
Subject: [PATCH net v2 3/3] net: openvswitch: Fix matching zone id for invalid conns arriving from tc
Date:   Thu, 9 Dec 2021 09:57:34 +0200
Message-ID: <20211209075734.10199-4-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20211209075734.10199-1-paulb@nvidia.com>
References: <20211209075734.10199-1-paulb@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a370efa8-7924-4960-7e58-08d9bae99b0d
X-MS-TrafficTypeDiagnostic: SN6PR12MB2607:EE_
X-Microsoft-Antispam-PRVS: <SN6PR12MB26077288A60261B057481A23C2709@SN6PR12MB2607.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dpOKaE+owhcXYUb4nThPVesGC4lzUP7iTArn/Z+aZ718N2knYc+tZ0muO4e2wc1+PoKz1R/XXWZd55JmUIv6iQutCEoPV96Tfai/iB+TZlHvrxkjuxl/AT8pp52fHmMC9CU7y7rzgg+Yco/dotmTJLyjrQm6DqbVBvl9ymv5B6qJQ/tukHmYnf48DwothHPKkVsFfr4OlcAqno0IE3hsAJnGIWJNo2MgsbIVX8Y5SB3plcNPY7DkW6jbEB8vDxaaIK5vvKpegIDdagZgtzt0gQJslMn6shyFr2GFg81fhpXStH92DrSfTKwi1Wx5zgjK+lkzttBIUkv/lWsAoX7m+hv/46ak5Y8xis4nhM3b/pznR1qdQxvgZQyAPgVPWSN8cNoH4nWB09fnouHMUv/YFQG17hgxufkS3ANIKGTlwlNXmScgJAp2g4jbx+NJqXqSeqCxIezSjbZeEJBVMyed0vf7bBTdSz9W1IOHRx39grGPQU2a49HVd3wINQsYYTPkwfXwM/SLWhvDy2S55csgF+0vYcICfLZQ/HQaaAL+Ro0aLJxbt6iag2Ptdr+qqfXftVSmgnoaOQRU9FiFajo0o852PnzTUOwxMwqxuoIMgdnxZkfzjwxGB6bREC18BpPnE/k2Ku94+uiV9d+1gsnJAlO0IC3Fm0s/fWBlThc00/SzxD0K9YOYg0y4oHP0GqX3+A6/7Sr+ObT7DFvtdrN8OxE92TdMIKu6vXfZz+Lc9gSkoi2KP70B9KN6iPtmaItZuQCXMmTKomSNoSkyDNM/HsI8TrsEGR/RAay8lSPoAs01MRyP4eD+EJC4WRP23e+y
X-Forefront-Antispam-Report: CIP:203.18.50.13;CTRY:HK;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:hkhybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700001)(70586007)(86362001)(70206006)(110136005)(6666004)(186003)(921005)(4326008)(356005)(5660300002)(336012)(426003)(8936002)(2616005)(316002)(508600001)(34070700002)(26005)(8676002)(54906003)(83380400001)(7636003)(36860700001)(107886003)(40460700001)(82310400004)(47076005)(36756003)(1076003)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2021 07:57:53.6623
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a370efa8-7924-4960-7e58-08d9bae99b0d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[203.18.50.13];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT066.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2607
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
index 155eb2ec54d8..28ad0c6bd0d5 100644
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

