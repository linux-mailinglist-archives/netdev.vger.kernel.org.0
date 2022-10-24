Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B8F0609E09
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 11:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbiJXJao (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 05:30:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230225AbiJXJaa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 05:30:30 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2054.outbound.protection.outlook.com [40.107.244.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3BE0422EA
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 02:30:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FZ3UcBOUptpWLwQvP2DwQwkK9RFGTK+gqVy61Mp2s8rvo1h/wrAe+0hvBfkXpgbHenhrc7MrHnyLVsuB/EkI6AkQlWvuy6CM308fiMQSNKOAol1as2CK8Qa74EbrcXsDsAWnh7A/wUXzY9hyWxUF7e98FRRIJTGeyXr4oADzxeRK4iraR6tnOWOtqbnbgkKkZ5fuCVJczjGyNQ8d4E1zwApzcSHDqGD7C0kfwCRmWQObJpH4a5RuRrzYuSb0PvEDKjPx1uOCZ5z56YjRX8JINaodPt1yaVbpuqBnPu357MWC+5RAyjCIQvgKI2WOw+g0pnIDxFr3bEjh1AyXrm3S7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LZxHy6eKplb8v/O94DvXQNv0FAXFyx6A3GSv752+kYw=;
 b=TId1uh5Wea70Xn5sv7rAYNMg5HDHASyV7XdQ3+62KwnOwR6p9rfrD5Akn92Oem68aLDo4CgKl24WfuMOFvKmBYQQCysLB/7jyBjKwwxY1U+vFoUrX8vQX/AvteNlrv1llyi5I0MDUOnfinG8M19ANT4b96wyj8dQYpIUhQEHN5HBZImbKDTJtzo0bpi/3jzNB381LF4vDlNtY262RgCNZk9HjnEgInLA1y618sxW8xNsjEv2nUlzTvXDK03mqU28u4iz65bfpamM3op5nVs+ECkp+NakYyOp+Eaf+lozi1bVvRJqJoCcSHhaQsLasTGW3QffRx4FWFAkG21kccqLPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LZxHy6eKplb8v/O94DvXQNv0FAXFyx6A3GSv752+kYw=;
 b=oKTdbwpE7xijnmWJWRyZyLIFSgWqDoirMtTXdzKCtdK+hdTR4GDMOqWNgvkewOjZks73k5ES5nVIiOF8+kbQ4seznWpckbGFaQXQ+XoNXMfQHHgTpyIkulG3F0dH3acQrA/qzvq46pjApE0CNjlpqCwfil3pKJgReNnYv88Ff10=
Received: from BN9PR03CA0495.namprd03.prod.outlook.com (2603:10b6:408:130::20)
 by DM6PR12MB4957.namprd12.prod.outlook.com (2603:10b6:5:20d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.31; Mon, 24 Oct
 2022 09:30:26 +0000
Received: from BN8NAM11FT111.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:130:cafe::2d) by BN9PR03CA0495.outlook.office365.com
 (2603:10b6:408:130::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.26 via Frontend
 Transport; Mon, 24 Oct 2022 09:30:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN8NAM11FT111.mail.protection.outlook.com (10.13.177.54) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5746.16 via Frontend Transport; Mon, 24 Oct 2022 09:30:26 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 24 Oct
 2022 04:30:25 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31 via Frontend
 Transport; Mon, 24 Oct 2022 04:30:24 -0500
From:   <edward.cree@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH net-next 2/5] sfc: add Layer 2 matches to ef100 TC offload
Date:   Mon, 24 Oct 2022 10:29:22 +0100
Message-ID: <a550c4f3f8c406f6b5162ff378e0ec08ae9d0eaa.1666603600.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1666603600.git.ecree.xilinx@gmail.com>
References: <cover.1666603600.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT111:EE_|DM6PR12MB4957:EE_
X-MS-Office365-Filtering-Correlation-Id: c411d695-dc05-49fa-1ff2-08dab5a26250
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Pk+8Eyj6Tmn3fA05dlLv0K2iD+EZnJw4L2BGHoK+twOgqsFnn+RETNHzvqN564vyXXiGH9VZILoRTyP7w2la+VPXRvghj47vvQCMlZT0aaUbK+R6JZwBRki/AiAUwyA1zDRDjynYGDVNthbDtVl1Hwk8bjsDjUfMZ2rlgXrRllSW1Bh5y0T9R2hmkqNBiO00kMQrZ582chuGaW3jjDzwd4aX+7QAb2Pfz7F71RNpWCyuGNxhzMScYOlgvqmhj5HfEuPx7HOofiT5cgVBVxkVt7IXAMVClEz617XphNyHErVoNduKz+i5AGsfQPdZIJf3R9Gfhs22GXZKYZS5KQBy5xfnk1Jq7QAJC36ePn5SPUC9dXEHLPwBLT+RMUnbsOVhrVKrC2ZzabT2rkWWnwnyWm/oDEYK8Mty/4myNYOu5TX+417aJlIT9MRnC+Uu3uh6DVL4Qfros93ncwVpzYfR0mzpt446m0ePQ7YdRiSMxU3no/zj4u1WQim+9GlK6U8dbv7artMdZvfFcV0DcGHYbMXmPXC3aBfYo1TFptSDGyOalgVBqwDvokfNDlNgf4NC1WLW1eF08jt491AlbMBnujHTcAT5opSjHw5AA2Z/qcCTKu/JJP1cyQ+jeyCPdmip8Lx1AG3iJBRTqnCsLIsQb004QXf1qA562Gh5DhdsezXoiCF1mi+cmtSiJDm9fD97D+BADdQglkiWDlS7wFhaqkyPlwDwoRJBSiMXAHkk9l+gI+A729xa1BTvcoZdKL5WFuU9zMfUt1Xj+aza5OSv5yJX0bLjOytz0r32EYh1aXVq+UJsCX2q0uQbBx35ez1m
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(396003)(346002)(376002)(451199015)(40470700004)(46966006)(36840700001)(86362001)(55446002)(83380400001)(478600001)(4326008)(8676002)(41300700001)(9686003)(26005)(5660300002)(316002)(6636002)(70586007)(110136005)(70206006)(54906003)(8936002)(336012)(2876002)(82310400005)(426003)(47076005)(40480700001)(186003)(81166007)(36756003)(40460700003)(2906002)(36860700001)(356005)(82740400003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2022 09:30:26.4625
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c411d695-dc05-49fa-1ff2-08dab5a26250
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT111.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4957
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
 drivers/net/ethernet/sfc/mae.c  | 36 +++++++++++++++++++
 drivers/net/ethernet/sfc/mcdi.h |  6 ++++
 drivers/net/ethernet/sfc/tc.c   | 62 ++++++++++++++++++++++++++++++---
 drivers/net/ethernet/sfc/tc.h   |  4 +++
 4 files changed, 103 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/sfc/mae.c b/drivers/net/ethernet/sfc/mae.c
index 4ceb8c8f5548..e119bc61ced7 100644
--- a/drivers/net/ethernet/sfc/mae.c
+++ b/drivers/net/ethernet/sfc/mae.c
@@ -284,9 +284,17 @@ int efx_mae_match_check_caps(struct efx_nic *efx,
 				       mask_type_name(ingress_port_mask_type));
 		return rc;
 	}
+	CHECK(ETHER_TYPE, eth_proto);
+	CHECK(VLAN0_TCI, vlan_tci[0]);
+	CHECK(VLAN0_PROTO, vlan_proto[0]);
+	CHECK(VLAN1_TCI, vlan_tci[1]);
+	CHECK(VLAN1_PROTO, vlan_proto[1]);
+	CHECK(ETH_SADDR, eth_saddr);
+	CHECK(ETH_DADDR, eth_daddr);
 	CHECK(RECIRC_ID, recirc_id);
 	return 0;
 }
+#undef CHECK
 
 static bool efx_mae_asl_id(u32 id)
 {
@@ -459,6 +467,34 @@ static int efx_mae_populate_match_criteria(MCDI_DECLARE_STRUCT_PTR(match_crit),
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
