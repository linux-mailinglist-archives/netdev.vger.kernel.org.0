Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C30BF4F6208
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 16:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235213AbiDFOvI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 10:51:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235317AbiDFOun (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 10:50:43 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2065.outbound.protection.outlook.com [40.107.236.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A33D5540FD
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 04:23:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AfA41Mr8fmkMmxgI+buPlMdHVIb4Ef8SitT3G4NtqQgdAzFFV9fi32fQXDYUDS8RuDmNVe0uwVeL5egLlF5bHMo4Jam37L9BYFGey7PFZSif3NRtwBP3gGe41vs1Qy7dGE/RxyPHQsC+jmZXmxPxqpQZwokpOHmogJOkm6238nT/SAD9sztKHBtxUxAOjU4R69aMCeIYw0A+m9Feiy7hWLv9C6Mlk8r5HQPUg+b73jU7WUDw3/GOJw9Lsk9vQdfwssVKLbH22kz0vxZnbn4pUZteW5qCRA2Cwmy4YjZQjl5G4+ZByXLZhZhEONpTPOxKjgv4fvkYLR3h5GehKlYHxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BoHVuEilx+ak6KC7nhye6ETlsRoAqqGeblaRno8E2BE=;
 b=T5HuMGmxowXCLJOJahVihhCqtLNwVGp5p25VMzHOFUCxbBbw8xi45UMQsQa/thWLzUt8n9XeAJvTp+oFYv1aPRjqVnooiKaSqFZM56Wsts6hNN98r1QneTEhv5BXDKNN6+A6AxlLnSbR7KV/+CEsfjnOzlCaVQ2YwlLGpWicjpcM/qfN+XG2Wl8SMtNhS2fW9ZxMMWlC7RKj3/qoqh7unll0y5qQqzN+pQa4a+SeNd/9fGQ6yKJFlQIIOQwNW6MTr8jdiK3MGF+C6zCKHfXOG+1ujJhqgsauvgkKcazLdi3hCDoHiP6ZLCxne/UFh3rqgg/SzzaJqNtfecwUByT/fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=mojatatu.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BoHVuEilx+ak6KC7nhye6ETlsRoAqqGeblaRno8E2BE=;
 b=L1nfMrBkAHyzY9QJ6HY/fiQCyPoFnJwdTZHJaUJEAIRCOyBvHOkqIIhj7CXmADZTu4KQ/eVqDWa1VEqPjARiTBL/2lNEz6KozFiJNTcMtH5/JzkqxB6d1PLCyUHGXn3csFxNa4bbjN+WSNVFfH8GxBy+eyh1jkqU6WqJVpKEclbsGyVEgsMqsoBp4Tk1b6KZRk75vg3Euib7AsLt04ctovTUPLfZWBM8cg5oOGdRXoAix1F3VmMzP4jJpduxG1lg45ky9prMkonW9O5Gd/DGr2aXjDLbSaBD7B6i6xaXDvEhhP/3z3icOpTEIYtnzsaZsX/YpyceGDbo+FZkJXxJKA==
Received: from BN6PR16CA0010.namprd16.prod.outlook.com (2603:10b6:404:f5::20)
 by DM5PR12MB1370.namprd12.prod.outlook.com (2603:10b6:3:76::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Wed, 6 Apr
 2022 11:23:16 +0000
Received: from BN8NAM11FT022.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:f5:cafe::94) by BN6PR16CA0010.outlook.office365.com
 (2603:10b6:404:f5::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31 via Frontend
 Transport; Wed, 6 Apr 2022 11:23:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 BN8NAM11FT022.mail.protection.outlook.com (10.13.176.112) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5144.20 via Frontend Transport; Wed, 6 Apr 2022 11:23:15 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 6 Apr
 2022 11:23:14 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Wed, 6 Apr 2022
 04:23:14 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.986.22 via Frontend Transport; Wed, 6 Apr
 2022 04:23:11 -0700
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <xiyou.wangcong@gmail.com>, <jhs@mojatatu.com>, <jiri@resnulli.us>,
        <netdev@vger.kernel.org>, <maord@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net] net/sched: flower: fix parsing of ethertype following VLAN header
Date:   Wed, 6 Apr 2022 14:22:41 +0300
Message-ID: <20220406112241.724452-1-vladbu@nvidia.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 40519408-dd0c-417c-21b3-08da17bfd830
X-MS-TrafficTypeDiagnostic: DM5PR12MB1370:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB13704FCD487BE759E9C5E2BDA0E79@DM5PR12MB1370.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DP7cdE6Nj/2U1Wj3tq02SuYZycPCW/A62xm7M1bhpzaJd1fwXJczkxSI6FRqUu8jXJJVgCsLZ9FXHJEEbe3rE9qF3zRlLi411XQ4XnMt+a844HfbszfhBcvi3zbDJkWvGjeI7HPp83+YlaqSARmcSs4W3nlVHe4SvyFjGlKENpqVvtLj0WcEerciXJYkJP2O45qUf+pP55gXB26Nst/5ueVP8Fg8RxhSQrKPhub7vvt7bT+Zau0iSxx4SxXwcT6NtF9GI52J/p46v/69UB0PZ5/BngaQREio36CuH594tXW8sBW9IJfn9TJV9Gp7JNlcm0eOpALfYzRjNmSqrMuP0LsTm6afKVUZiX6Y0a9A1dYbZze2C6DxzXmUlIKjd4AdkoQIgsJaY7OXvOmvMPKCs9q1+TK41N0R2jJNCvunJEaxV/tUDOgBh2LmcoqoMZD9dCbjAn57xexFHNdIk8iWHdZvi69KZPzeef/XCQVZ5oE7jpNJZD67f1PJKn6VuhCw+3eW+fbecXZm5EchfADQByCdui6lNiIi+A6OC9X+ru5rm29ygtacVv2GtlNlTq8LZ2v53f41/tz1zpJBkD8pkAyrfnuZQObhoNBsaxQODgNMPp2Uey/qKLdwvrCPsxMSnsyMqXwnrGjtAeUFqOU/wVTLxqz2L7UrSoRbMu+W7u1vKEHXz33iDThMsT8ays5gdeAXxU1HcnMfBj8qDCMZOwfIj7VDCO4pFjKovxy6XXjogvVhGuJVUQ/VZ3KsilUKHcRceWXqdIyLGWSkkoLQ6tTijrUlru9rWuLPfNqPjeM=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(40460700003)(86362001)(6666004)(83380400001)(186003)(47076005)(1076003)(2906002)(336012)(426003)(26005)(8936002)(36756003)(7696005)(2616005)(5660300002)(107886003)(356005)(82310400005)(966005)(54906003)(70586007)(36860700001)(508600001)(81166007)(8676002)(316002)(4326008)(110136005)(70206006)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2022 11:23:15.7853
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 40519408-dd0c-417c-21b3-08da17bfd830
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT022.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1370
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A tc flower filter matching TCA_FLOWER_KEY_VLAN_ETH_TYPE is expected to
match the L2 ethertype following the first VLAN header, as confirmed by
linked discussion with the maintainer. However, such rule also matches
packets that have additional second VLAN header, even though filter has
both eth_type and vlan_ethtype set to "ipv4". Looking at the code this
seems to be mostly an artifact of the way flower uses flow dissector.
First, even though looking at the uAPI eth_type and vlan_ethtype appear
like a distinct fields, in flower they are all mapped to the same
key->basic.n_proto. Second, flow dissector skips following VLAN header as
no keys for FLOW_DISSECTOR_KEY_CVLAN are set and eventually assigns the
value of n_proto to last parsed header. With these, such filters ignore any
headers present between first VLAN header and first "non magic"
header (ipv4 in this case) that doesn't result
FLOW_DISSECT_RET_PROTO_AGAIN.

Fix the issue by extending flow dissector VLAN key structure with new
'vlan_eth_type' field that matches first ethertype following previously
parsed VLAN header. Modify flower classifier to set the new
flow_dissector_key_vlan->vlan_eth_type with value obtained from
TCA_FLOWER_KEY_VLAN_ETH_TYPE/TCA_FLOWER_KEY_CVLAN_ETH_TYPE uAPIs.

Link: https://lore.kernel.org/all/Yjhgi48BpTGh6dig@nanopsycho/
Fixes: 9399ae9a6cb2 ("net_sched: flower: Add vlan support")
Fixes: d64efd0926ba ("net/sched: flower: Add supprt for matching on QinQ vlan headers")
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 include/net/flow_dissector.h |  2 ++
 net/core/flow_dissector.c    |  1 +
 net/sched/cls_flower.c       | 18 +++++++++++++-----
 3 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/include/net/flow_dissector.h b/include/net/flow_dissector.h
index aa33e1092e2c..9f65f1bfbd24 100644
--- a/include/net/flow_dissector.h
+++ b/include/net/flow_dissector.h
@@ -59,6 +59,8 @@ struct flow_dissector_key_vlan {
 		__be16	vlan_tci;
 	};
 	__be16	vlan_tpid;
+	__be16	vlan_eth_type;
+	u16	padding;
 };
 
 struct flow_dissector_mpls_lse {
diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 03b6e649c428..9bd887610c18 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -1183,6 +1183,7 @@ bool __skb_flow_dissect(const struct net *net,
 					 VLAN_PRIO_MASK) >> VLAN_PRIO_SHIFT;
 			}
 			key_vlan->vlan_tpid = saved_vlan_tpid;
+			key_vlan->vlan_eth_type = proto;
 		}
 
 		fdret = FLOW_DISSECT_RET_PROTO_AGAIN;
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index c80fc49c0da1..ed5e6f08e74a 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -1013,6 +1013,7 @@ static int fl_set_key_mpls(struct nlattr **tb,
 static void fl_set_key_vlan(struct nlattr **tb,
 			    __be16 ethertype,
 			    int vlan_id_key, int vlan_prio_key,
+			    int vlan_next_eth_type_key,
 			    struct flow_dissector_key_vlan *key_val,
 			    struct flow_dissector_key_vlan *key_mask)
 {
@@ -1031,6 +1032,11 @@ static void fl_set_key_vlan(struct nlattr **tb,
 	}
 	key_val->vlan_tpid = ethertype;
 	key_mask->vlan_tpid = cpu_to_be16(~0);
+	if (tb[vlan_next_eth_type_key]) {
+		key_val->vlan_eth_type =
+			nla_get_be16(tb[vlan_next_eth_type_key]);
+		key_mask->vlan_eth_type = cpu_to_be16(~0);
+	}
 }
 
 static void fl_set_key_flag(u32 flower_key, u32 flower_mask,
@@ -1602,8 +1608,9 @@ static int fl_set_key(struct net *net, struct nlattr **tb,
 
 		if (eth_type_vlan(ethertype)) {
 			fl_set_key_vlan(tb, ethertype, TCA_FLOWER_KEY_VLAN_ID,
-					TCA_FLOWER_KEY_VLAN_PRIO, &key->vlan,
-					&mask->vlan);
+					TCA_FLOWER_KEY_VLAN_PRIO,
+					TCA_FLOWER_KEY_VLAN_ETH_TYPE,
+					&key->vlan, &mask->vlan);
 
 			if (tb[TCA_FLOWER_KEY_VLAN_ETH_TYPE]) {
 				ethertype = nla_get_be16(tb[TCA_FLOWER_KEY_VLAN_ETH_TYPE]);
@@ -1611,6 +1618,7 @@ static int fl_set_key(struct net *net, struct nlattr **tb,
 					fl_set_key_vlan(tb, ethertype,
 							TCA_FLOWER_KEY_CVLAN_ID,
 							TCA_FLOWER_KEY_CVLAN_PRIO,
+							TCA_FLOWER_KEY_CVLAN_ETH_TYPE,
 							&key->cvlan, &mask->cvlan);
 					fl_set_key_val(tb, &key->basic.n_proto,
 						       TCA_FLOWER_KEY_CVLAN_ETH_TYPE,
@@ -3002,13 +3010,13 @@ static int fl_dump_key(struct sk_buff *skb, struct net *net,
 		goto nla_put_failure;
 
 	if (mask->basic.n_proto) {
-		if (mask->cvlan.vlan_tpid) {
+		if (mask->cvlan.vlan_eth_type) {
 			if (nla_put_be16(skb, TCA_FLOWER_KEY_CVLAN_ETH_TYPE,
 					 key->basic.n_proto))
 				goto nla_put_failure;
-		} else if (mask->vlan.vlan_tpid) {
+		} else if (mask->vlan.vlan_eth_type) {
 			if (nla_put_be16(skb, TCA_FLOWER_KEY_VLAN_ETH_TYPE,
-					 key->basic.n_proto))
+					 key->vlan.vlan_eth_type))
 				goto nla_put_failure;
 		}
 	}
-- 
2.31.1

