Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA35A46D928
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 18:03:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237503AbhLHRGi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 12:06:38 -0500
Received: from mail-bn8nam08on2061.outbound.protection.outlook.com ([40.107.100.61]:24929
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237502AbhLHRGi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Dec 2021 12:06:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nXc1jR//kQxc24cgWKjpWa05nvgV0s7CqLsDv5CgmtbG92NlpkggG0RxG07kzVigru/H+uH5Y2Ctyzr/X+2/RpYjvgcOAmuG7SyuVY1dccgalfHSgaTtmyVFNAK8IzatNsCISbVMwK317sOZ8JxS+el8ygiFyeR+EagPLxPvWZoikW6We3xJ83kEcS0Ed76d7EdDHnxYKn0eSyYqYuTlr4T+blI/EJwJzPKe9laPFzfgDl08IxHiXB6Lq3+ajmRL8pzi6mH5w66flQY+XLggb6vXSDiRUkeKir7gJQ5eSB8Ol+tRyWLCfCx7YfHqxXyMP2+OqR6sQQaWu0EPM5KHbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mQChzFtbCG0LajkUA8sURJucOpTY8B5TqXPXoPRwYGU=;
 b=FIeuMLEP37vKCbvgcJAHIEAJ6ogP81+sKWv9Ct+559stozdJEz8IHEQjqRYAB0NNs0L6kKYzmavl6BK47zOUUsAZwN1MfDN2AjcP07CE4L5D7ejICIOJkururRt5i1WelWpvviWMj2rOOsuPRb0unM1sU4Ovsmk/A27XWdXpq5PnpAk2V/qvtNfHH45CjnTnGlF2BJF7SU4t4E+bfrms496oQIqGAhjXtYEyKl1rj6gdJn7DbGZn313HhRxk3RnhlSXvHRnoA2djfMh4C8fujSLIdPJ+1cFiWDldhXDj9jVm7+JvDd4yUmy9TIsNrBuenB9MM5X7ujSxS8NvMqL1JQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 203.18.50.13) smtp.rcpttodomain=openvswitch.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mQChzFtbCG0LajkUA8sURJucOpTY8B5TqXPXoPRwYGU=;
 b=muth8NSlHvZzU+RMwWBcBPEYCAIe2JMzTFCE1zOv4lfM2vV8sdC2PlSkWEuIumECF6XDfeV6xWUUjDPHcZArXf1IM+12+LSTlOW1Gt7LRpnrLvlRP7KnUQuip7nxfI0bkD8AxE/nnrNarpgys3D9ZdG6tdDk5CjARVMe1xUKHjBPaAyQdErML8z2iJ7GOsdGAodTGXEDfCKq0yp0FPV1jMYpnhcly9J2rcDaH764yTKy0fv7HheuoQoGV9jI0XZEVTNw4VH6JJ9/ec480VR05OSSVkWVGX13FN9rMxHNVGUxdsvmBmtRfw56fr8Fd8eT0VnwbbcGbUxw+oGjMq0L+w==
Received: from MW4P222CA0010.NAMP222.PROD.OUTLOOK.COM (2603:10b6:303:114::15)
 by BL0PR12MB4931.namprd12.prod.outlook.com (2603:10b6:208:17e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.11; Wed, 8 Dec
 2021 17:03:03 +0000
Received: from CO1NAM11FT005.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:114:cafe::f3) by MW4P222CA0010.outlook.office365.com
 (2603:10b6:303:114::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.12 via Frontend
 Transport; Wed, 8 Dec 2021 17:03:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 203.18.50.13)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 203.18.50.13 as permitted sender) receiver=protection.outlook.com;
 client-ip=203.18.50.13; helo=mail.nvidia.com;
Received: from mail.nvidia.com (203.18.50.13) by
 CO1NAM11FT005.mail.protection.outlook.com (10.13.174.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4755.13 via Frontend Transport; Wed, 8 Dec 2021 17:03:03 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HKMAIL102.nvidia.com
 (10.18.16.11) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 8 Dec
 2021 17:03:01 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 8 Dec
 2021 17:03:00 +0000
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (172.20.187.6) by
 mail.nvidia.com (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.18
 via Frontend Transport; Wed, 8 Dec 2021 17:02:57 +0000
From:   Paul Blakey <paulb@nvidia.com>
To:     Paul Blakey <paulb@nvidia.com>, <dev@openvswitch.org>,
        <netdev@vger.kernel.org>, Saeed Mahameed <saeedm@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "Pravin B Shelar" <pshelar@ovn.org>, <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>
CC:     Oz Shlomo <ozsh@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Roi Dayan <roid@nvidia.com>
Subject: [PATCH net 3/3] net: openvswitch: Fix matching zone id for invalid conns arriving from tc
Date:   Wed, 8 Dec 2021 19:02:40 +0200
Message-ID: <20211208170240.13458-4-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20211208170240.13458-1-paulb@nvidia.com>
References: <20211208170240.13458-1-paulb@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9cd1c7be-736e-4c1b-c3c8-08d9ba6c990b
X-MS-TrafficTypeDiagnostic: BL0PR12MB4931:EE_
X-Microsoft-Antispam-PRVS: <BL0PR12MB493138FCDE4236CBE364B897C26F9@BL0PR12MB4931.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nDBjgOJXEgNpfdo0wwTwGnLNHyZBScOcnTXCmpUgH8qbdOAlC+UmIJtSpNkePh0FXuJjmOrIZijKjuip+LS1o/K/Pyx21z0nRLjWBRJOI8QupvD27oV77gy6dvk1IyqiLJVpSgaNkaG48CMJqbTvweRtaJx4jKOJAjYt03im24HeRaPOyqOIF7AE8EVLdMqpwI83rQYtY+EAfkuWEWNmEtWoV/oQqDBTUPgxWeyjW3HasF9qaUomOUgpyOp1EtrAPyJm5YZyT9spbdQPycgBCbVy4XResh6BE0jQTy4+kY2gjCMQUEm0xZfRrZPOxyPCT41z/fNlOlj6pueO3N+gN8/jAmTbYmMxEhCVYH9JgQgm2KaalGwLj7AXONvD8iNEwT7/xo+IfoKH2iwLnCsEmEVRxGJC966qUexV98BIKrxlBXImDOpW4wM1O0t0qpiSTez52heXScCvthqdFiLHWj/2oPYvyJs6Sk5QReRplMu2soJ+z1UxFUOCtfsITM+BW7735VaUUmmmE7GR+y6LAfvPxtlrtQI/+afHxDBnSmv7Ue42p6Ab9LYI83DqGlsJ4rwpzbuiyJzmQSwz9f+Bf50HRqFSdtQrMFJlJHzt36HUO5Xht0xKwP87y8EYOaEfb/BlJMxV3mNzs8iX+3CmzaAuXJND0fqDyOIB2sS8OdrTxRHNE3uwj7iSFS1M8svNe9rsjzW0qC9z54ui0S6vjlpHydzimv6KmW1bnjHKDt0ATqU2tHAMMAkZfAqz8ac5DelMyRiloQ6Jr4Sis1by3qL6cO64CpwIY9mAO3z29hk=
X-Forefront-Antispam-Report: CIP:203.18.50.13;CTRY:HK;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:hkhybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700001)(36860700001)(70586007)(70206006)(1076003)(7636003)(83380400001)(36756003)(356005)(34070700002)(508600001)(86362001)(336012)(6666004)(2906002)(6636002)(2616005)(47076005)(26005)(186003)(54906003)(40460700001)(107886003)(5660300002)(82310400004)(110136005)(8676002)(426003)(4326008)(8936002)(316002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2021 17:03:03.3117
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cd1c7be-736e-4c1b-c3c8-08d9ba6c990b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[203.18.50.13];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT005.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4931
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

