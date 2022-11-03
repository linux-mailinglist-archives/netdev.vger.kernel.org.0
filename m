Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 822CD6182C5
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 16:28:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232196AbiKCP2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 11:28:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232223AbiKCP2G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 11:28:06 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2085.outbound.protection.outlook.com [40.107.95.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9105C1B9D4
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 08:28:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GqCdHvDp669YsdY5IFrWrsDgWsBDGYeFrepsTgD7FxjXRg+J9V5sFuOZD0hSa6gi6nTgWNLNuNSV2HlqqhVQFetEpdtz24KbrKQT5TBwqbwc2r+gjROksiFzWJ9sXcrT5cvnN9zWadHYXMH8eTm8ThzV3QhaGFOjXN/YUjFE+PbrB1TbrIXI++DDkVNlgueks6+FMZsHyDM+DsPMRrIcbQ4SsR1bvzJXhuCJ+NX+dlD3sbUQbQer0IQHAIRq6RD0T6DnWzJGQDHLXdpNJU60jJgmVyvsGJT8PTn73S2W96sdnD+QGho4fbULnbRA8HH9oRmNYkE/u2kNjAu6OLBPWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CqY2f3SFbaMJhbZrCV85Kf/pLnLp4y+Nx+B4oFzVjpg=;
 b=jdaRvM16dYc/SsjhihX+82HykVHEToM1AL+/rKyr6iG+acGNUs1lpYNDYmS/+4/fgJI3o0MAUySyp4WH/X1y+4u66y4l8pJmAmdPaCpd5agvGExSwMGOizAyQYxuPHzzcP+NQzsZXhiXSilyQhUSqZ22hbsoKtV/fQ84VH0NBmPnNbBHfDZo0y7kuFTEDljFXbAWkGRTxyLIbl4xYy/Z9mrh2wSUeLMQZ8xPlSM8IrFwbmLfdCu2ACvPxFoRf7zW7GOua81YxvJfwB6Uy06JwXSvQBvYA0dvT+DCqVG+ms7DLZm/bCBMDE+mchYQJXti3V3j0DYPdpaxZN5gPgiKlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CqY2f3SFbaMJhbZrCV85Kf/pLnLp4y+Nx+B4oFzVjpg=;
 b=LHnHvgyeM9JUaVTGVq+YLPlfYqMDulT76srxs7Xd5ZLFKsWBGF9g08JikgvUIMiULTOn78jU1iGdavVCSjjV/Z+Zm0Xa26oq7h67PrgdAVDwgIhilep4jCoMASTcK9aRB5Je9Z725Zy/VMxp8nD3r1vegcUzVGpxJTveDveT/pg=
Received: from DM6PR07CA0068.namprd07.prod.outlook.com (2603:10b6:5:74::45) by
 MN0PR12MB5906.namprd12.prod.outlook.com (2603:10b6:208:37a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.16; Thu, 3 Nov
 2022 15:28:03 +0000
Received: from DM6NAM11FT008.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:74:cafe::ee) by DM6PR07CA0068.outlook.office365.com
 (2603:10b6:5:74::45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22 via Frontend
 Transport; Thu, 3 Nov 2022 15:28:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT008.mail.protection.outlook.com (10.13.172.85) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5791.20 via Frontend Transport; Thu, 3 Nov 2022 15:28:02 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 3 Nov
 2022 10:28:02 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 3 Nov
 2022 08:28:02 -0700
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31 via Frontend
 Transport; Thu, 3 Nov 2022 10:28:00 -0500
From:   <edward.cree@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH v2 net-next 2/5] sfc: add Layer 2 matches to ef100 TC offload
Date:   Thu, 3 Nov 2022 15:27:28 +0000
Message-ID: <251c83113eb4caa9f8b628ce5b14983f6ebc23ea.1667412458.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1667412458.git.ecree.xilinx@gmail.com>
References: <cover.1667412458.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT008:EE_|MN0PR12MB5906:EE_
X-MS-Office365-Filtering-Correlation-Id: 5707cb2e-4b71-4feb-8b54-08dabdafff74
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p0MRscwvvOF9+c4j6kbXArMrkfq8t1vwzoUaTMVPVM6haYreVMxeoPKmAvkAo5XxVM/1wPwYCEGVFQAOTxcw9aMF1QSsJkXwcxO4yyN0ainFzXyfT/GXgwJ37tYIg0gcqVYonomRuzGJnKtAiYWFy7vppuf7IijVNQt2v9P7W2bBRBcQYzQ6CLL7Mq3ithhylyuJHQjJf9p1DW/Bckg8R4x/VTYHJcrt4JTOa7gAFMRB/30wfU3QXLJ3cN9X6l31xOMO2l8+MaAm/2BzmzaKnrVMSBN1mxMajLkVsxWFLWyfKrerTp3N95w7j0ArnV8d9p6nDxsKDho52bXKWmwJ0/mty6NP8dzbtmEjsW1eRiF4Am6SwOtQ3gIxdAPTwGa1Rv/0oLOzKRJKwz1qA/wNRdEW3NM6xbSLgMvFGL388yqoMtxxlTiGTl3eD/ZAegF9bGDzm+PfwsoJRW99XcvZTUJjJZqgOZh8TNccHEF8wQ1fdYomjbzE93jXLRm3hssrKI5zGWTbFKQaB6f/i7AUOedTM+K9HJmM6aGxiSrDsVvHTpKxxNn9I8VwiBlOJAAPilQ3j6vdCqezLgiTuNwuhO8CLJaxHfFvFQNa+9WK64k9SqPXe31mC3vJIXqvOG5c+qhLRbHmj18lqptO/k+qgvxFLk77tji8sjG8NiPKFwmitGqMjNmQvLiR814eTRSYdWiZ/laZ/yCerDC22O292vXLbRCmWECISjeRvcyevrOmE/nAIAgwIxVPgM4MA5/cW49VDUwlR0KWbh6/hHa4zZhEoS2xTj8mW1pGGIkFvNxgdr8HVGou0uglvvk+saoz
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(396003)(136003)(376002)(451199015)(46966006)(40470700004)(36840700001)(82740400003)(36860700001)(36756003)(86362001)(40480700001)(81166007)(356005)(70206006)(83380400001)(8676002)(4326008)(110136005)(70586007)(40460700003)(2876002)(41300700001)(426003)(54906003)(8936002)(6636002)(316002)(47076005)(478600001)(9686003)(186003)(336012)(5660300002)(55446002)(82310400005)(26005)(6666004)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2022 15:28:02.8475
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5707cb2e-4b71-4feb-8b54-08dabdafff74
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT008.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5906
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree.xilinx@gmail.com>

Support matching on EtherType, VLANs and ethernet source/destination
 addresses, with masking if supported by the hardware.

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/mae.c  | 37 +++++++++++++++++++-
 drivers/net/ethernet/sfc/mcdi.h |  6 ++++
 drivers/net/ethernet/sfc/tc.c   | 62 ++++++++++++++++++++++++++++++---
 drivers/net/ethernet/sfc/tc.h   |  4 +++
 4 files changed, 103 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/sfc/mae.c b/drivers/net/ethernet/sfc/mae.c
index cd014957a236..6dfcf87f9659 100644
--- a/drivers/net/ethernet/sfc/mae.c
+++ b/drivers/net/ethernet/sfc/mae.c
@@ -283,7 +283,14 @@ int efx_mae_match_check_caps(struct efx_nic *efx,
 				       mask_type_name(ingress_port_mask_type));
 		return rc;
 	}
-	if (CHECK(RECIRC_ID, recirc_id))
+	if (CHECK(ETHER_TYPE, eth_proto) ||
+	    CHECK(VLAN0_TCI, vlan_tci[0]) ||
+	    CHECK(VLAN0_PROTO, vlan_proto[0]) ||
+	    CHECK(VLAN1_TCI, vlan_tci[1]) ||
+	    CHECK(VLAN1_PROTO, vlan_proto[1]) ||
+	    CHECK(ETH_SADDR, eth_saddr) ||
+	    CHECK(ETH_DADDR, eth_daddr) ||
+	    CHECK(RECIRC_ID, recirc_id))
 		return rc;
 	return 0;
 }
@@ -460,6 +467,34 @@ static int efx_mae_populate_match_criteria(MCDI_DECLARE_STRUCT_PTR(match_crit),
 			     match->value.recirc_id);
 	MCDI_STRUCT_SET_BYTE(match_crit, MAE_FIELD_MASK_VALUE_PAIRS_V2_RECIRC_ID_MASK,
 			     match->mask.recirc_id);
+	MCDI_STRUCT_SET_WORD_BE(match_crit, MAE_FIELD_MASK_VALUE_PAIRS_V2_ETHER_TYPE_BE,
+				match->value.eth_proto);
+	MCDI_STRUCT_SET_WORD_BE(match_crit, MAE_FIELD_MASK_VALUE_PAIRS_V2_ETHER_TYPE_BE_MASK,
+				match->mask.eth_proto);
+	MCDI_STRUCT_SET_WORD_BE(match_crit, MAE_FIELD_MASK_VALUE_PAIRS_V2_VLAN0_TCI_BE,
+				match->value.vlan_tci[0]);
+	MCDI_STRUCT_SET_WORD_BE(match_crit, MAE_FIELD_MASK_VALUE_PAIRS_V2_VLAN0_TCI_BE_MASK,
+				match->mask.vlan_tci[0]);
+	MCDI_STRUCT_SET_WORD_BE(match_crit, MAE_FIELD_MASK_VALUE_PAIRS_V2_VLAN0_PROTO_BE,
+				match->value.vlan_proto[0]);
+	MCDI_STRUCT_SET_WORD_BE(match_crit, MAE_FIELD_MASK_VALUE_PAIRS_V2_VLAN0_PROTO_BE_MASK,
+				match->mask.vlan_proto[0]);
+	MCDI_STRUCT_SET_WORD_BE(match_crit, MAE_FIELD_MASK_VALUE_PAIRS_V2_VLAN1_TCI_BE,
+				match->value.vlan_tci[1]);
+	MCDI_STRUCT_SET_WORD_BE(match_crit, MAE_FIELD_MASK_VALUE_PAIRS_V2_VLAN1_TCI_BE_MASK,
+				match->mask.vlan_tci[1]);
+	MCDI_STRUCT_SET_WORD_BE(match_crit, MAE_FIELD_MASK_VALUE_PAIRS_V2_VLAN1_PROTO_BE,
+				match->value.vlan_proto[1]);
+	MCDI_STRUCT_SET_WORD_BE(match_crit, MAE_FIELD_MASK_VALUE_PAIRS_V2_VLAN1_PROTO_BE_MASK,
+				match->mask.vlan_proto[1]);
+	memcpy(MCDI_STRUCT_PTR(match_crit, MAE_FIELD_MASK_VALUE_PAIRS_V2_ETH_SADDR_BE),
+	       match->value.eth_saddr, ETH_ALEN);
+	memcpy(MCDI_STRUCT_PTR(match_crit, MAE_FIELD_MASK_VALUE_PAIRS_V2_ETH_SADDR_BE_MASK),
+	       match->mask.eth_saddr, ETH_ALEN);
+	memcpy(MCDI_STRUCT_PTR(match_crit, MAE_FIELD_MASK_VALUE_PAIRS_V2_ETH_DADDR_BE),
+	       match->value.eth_daddr, ETH_ALEN);
+	memcpy(MCDI_STRUCT_PTR(match_crit, MAE_FIELD_MASK_VALUE_PAIRS_V2_ETH_DADDR_BE_MASK),
+	       match->mask.eth_daddr, ETH_ALEN);
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/sfc/mcdi.h b/drivers/net/ethernet/sfc/mcdi.h
index 1f18e9dc62e8..883a4db695e2 100644
--- a/drivers/net/ethernet/sfc/mcdi.h
+++ b/drivers/net/ethernet/sfc/mcdi.h
@@ -224,6 +224,12 @@ void efx_mcdi_sensor_event(struct efx_nic *efx, efx_qword_t *ev);
 #define MCDI_WORD(_buf, _field)						\
 	((u16)BUILD_BUG_ON_ZERO(MC_CMD_ ## _field ## _LEN != 2) +	\
 	 le16_to_cpu(*(__force const __le16 *)MCDI_PTR(_buf, _field)))
+/* Write a 16-bit field defined in the protocol as being big-endian. */
+#define MCDI_STRUCT_SET_WORD_BE(_buf, _field, _value) do {		\
+	BUILD_BUG_ON(_field ## _LEN != 2);				\
+	BUILD_BUG_ON(_field ## _OFST & 1);				\
+	*(__force __be16 *)MCDI_STRUCT_PTR(_buf, _field) = (_value);	\
+	} while (0)
 #define MCDI_SET_DWORD(_buf, _field, _value)				\
 	EFX_POPULATE_DWORD_1(*_MCDI_DWORD(_buf, _field), EFX_DWORD_0, _value)
 #define MCDI_STRUCT_SET_DWORD(_buf, _field, _value)			\
diff --git a/drivers/net/ethernet/sfc/tc.c b/drivers/net/ethernet/sfc/tc.c
index b21a961eabb1..b469a1263211 100644
--- a/drivers/net/ethernet/sfc/tc.c
+++ b/drivers/net/ethernet/sfc/tc.c
@@ -124,6 +124,20 @@ static void efx_tc_flow_free(void *ptr, void *arg)
 	kfree(rule);
 }
 
+/* Boilerplate for the simple 'copy a field' cases */
+#define _MAP_KEY_AND_MASK(_name, _type, _tcget, _tcfield, _field)	\
+if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_##_name)) {		\
+	struct flow_match_##_type fm;					\
+									\
+	flow_rule_match_##_tcget(rule, &fm);				\
+	match->value._field = fm.key->_tcfield;				\
+	match->mask._field = fm.mask->_tcfield;				\
+}
+#define MAP_KEY_AND_MASK(_name, _type, _tcfield, _field)	\
+	_MAP_KEY_AND_MASK(_name, _type, _type, _tcfield, _field)
+#define MAP_ENC_KEY_AND_MASK(_name, _type, _tcget, _tcfield, _field)	\
+	_MAP_KEY_AND_MASK(ENC_##_name, _type, _tcget, _tcfield, _field)
+
 static int efx_tc_flower_parse_match(struct efx_nic *efx,
 				     struct flow_rule *rule,
 				     struct efx_tc_match *match,
@@ -144,26 +158,64 @@ static int efx_tc_flower_parse_match(struct efx_nic *efx,
 	}
 	if (dissector->used_keys &
 	    ~(BIT(FLOW_DISSECTOR_KEY_CONTROL) |
-	      BIT(FLOW_DISSECTOR_KEY_BASIC))) {
+	      BIT(FLOW_DISSECTOR_KEY_BASIC) |
+	      BIT(FLOW_DISSECTOR_KEY_ETH_ADDRS) |
+	      BIT(FLOW_DISSECTOR_KEY_VLAN) |
+	      BIT(FLOW_DISSECTOR_KEY_CVLAN))) {
 		NL_SET_ERR_MSG_FMT_MOD(extack, "Unsupported flower keys %#x",
 				       dissector->used_keys);
 		return -EOPNOTSUPP;
 	}
 
+	MAP_KEY_AND_MASK(BASIC, basic, n_proto, eth_proto);
 	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_BASIC)) {
 		struct flow_match_basic fm;
 
 		flow_rule_match_basic(rule, &fm);
-		if (fm.mask->n_proto) {
-			NL_SET_ERR_MSG_MOD(extack, "Unsupported eth_proto match");
-			return -EOPNOTSUPP;
-		}
 		if (fm.mask->ip_proto) {
 			NL_SET_ERR_MSG_MOD(extack, "Unsupported ip_proto match");
 			return -EOPNOTSUPP;
 		}
 	}
 
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_VLAN)) {
+		struct flow_match_vlan fm;
+
+		flow_rule_match_vlan(rule, &fm);
+		if (fm.mask->vlan_id || fm.mask->vlan_priority || fm.mask->vlan_tpid) {
+			match->value.vlan_proto[0] = fm.key->vlan_tpid;
+			match->mask.vlan_proto[0] = fm.mask->vlan_tpid;
+			match->value.vlan_tci[0] = cpu_to_be16(fm.key->vlan_priority << 13 |
+							       fm.key->vlan_id);
+			match->mask.vlan_tci[0] = cpu_to_be16(fm.mask->vlan_priority << 13 |
+							      fm.mask->vlan_id);
+		}
+	}
+
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_CVLAN)) {
+		struct flow_match_vlan fm;
+
+		flow_rule_match_cvlan(rule, &fm);
+		if (fm.mask->vlan_id || fm.mask->vlan_priority || fm.mask->vlan_tpid) {
+			match->value.vlan_proto[1] = fm.key->vlan_tpid;
+			match->mask.vlan_proto[1] = fm.mask->vlan_tpid;
+			match->value.vlan_tci[1] = cpu_to_be16(fm.key->vlan_priority << 13 |
+							       fm.key->vlan_id);
+			match->mask.vlan_tci[1] = cpu_to_be16(fm.mask->vlan_priority << 13 |
+							      fm.mask->vlan_id);
+		}
+	}
+
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ETH_ADDRS)) {
+		struct flow_match_eth_addrs fm;
+
+		flow_rule_match_eth_addrs(rule, &fm);
+		ether_addr_copy(match->value.eth_saddr, fm.key->src);
+		ether_addr_copy(match->value.eth_daddr, fm.key->dst);
+		ether_addr_copy(match->mask.eth_saddr, fm.mask->src);
+		ether_addr_copy(match->mask.eth_daddr, fm.mask->dst);
+	}
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/sfc/tc.h b/drivers/net/ethernet/sfc/tc.h
index 4373c3243e3c..272efbabd6be 100644
--- a/drivers/net/ethernet/sfc/tc.h
+++ b/drivers/net/ethernet/sfc/tc.h
@@ -26,6 +26,10 @@ struct efx_tc_match_fields {
 	/* L1 */
 	u32 ingress_port;
 	u8 recirc_id;
+	/* L2 (inner when encap) */
+	__be16 eth_proto;
+	__be16 vlan_tci[2], vlan_proto[2];
+	u8 eth_saddr[ETH_ALEN], eth_daddr[ETH_ALEN];
 };
 
 struct efx_tc_match {
