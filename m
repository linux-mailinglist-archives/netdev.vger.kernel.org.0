Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99A016B9D27
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 18:36:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229909AbjCNRgi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 13:36:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbjCNRgg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 13:36:36 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 141C4ABB1D
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 10:36:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fzvoAPlG7IU/Ms/nxe8fO+Rp+mitNNPamqoQ7XyQVsEhjF+3mEHL3v4oGX7MxmOL8YrZFI3eJ3BzK1s4ITEbyJuXgyrKZYViRCoJjdvWL1l036Oh6w/vQH84iGhUZolwgq0z7pGdC1+USfChvBFGulOitOMlpsdD1TrtXV6rfixNCKWdLtqZPKz9AsqzHcJV1ciraouo8V4S4j0tV7GPwu49rG+V1GLRi1RIFhxxdNKhFNRRcJcOGuZxtyMRQ2wZ7bOyNkRlAyU/4VX6ndSV2PJPrfENXdFfMxn8UVoWBBR3GzpzxonDb7Ok9ROrF3B4R5FD0eOGwSML/w6cZFKcOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vAWZ9EmPWx3wj1rSvXkuxZr9vtiPe20yEqWBNbkKDTs=;
 b=Zb9pRr8zFc6kjnvzGBTts/rkLBlZ/JemQvC+JcQFrIxcTb145AENxTZ4Jwk7mCtm4O8aB0hCvCwWVHQcHRdA/lFzWrNHc7VtAeMz7RzWIfuDwtfz23K/u1jjSmLG7El3iXNm/oOlJfD1Xy96/6/nikHOT//aWSfPIrN1O+PoyPRO/Hm86j3m4ua0YQXXsaDnbOF8n9OLY/PuQP0RxeLocTxYbBA+PrKhslgpZSCRGlOWem0Nyla5twh0SwPHN9TCBhG+cxHXWc1gIkuc78U6Q9hnOX9860wYCNDZboHOPoG/D54EYsbW2ZoHPD7+1AeHlFnB4BZjPh4foFbK8FkFKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vAWZ9EmPWx3wj1rSvXkuxZr9vtiPe20yEqWBNbkKDTs=;
 b=N5XCPlTNP1oDVoqZQsHb1PajhfolcV2yA2JlIYWs39KdMdiHHBXa+9KgfMpOPrQSgrKSWdA1EmD4D905in/LPiKncpQD5ENZrU/GMGy6R9JQ4cWqRgJer6sLHgSdEqZhoCrVxeEAuXr/IfKq4igQ+OyIs3Z8W6glrSz0I4DcADw=
Received: from MN2PR06CA0019.namprd06.prod.outlook.com (2603:10b6:208:23d::24)
 by MW3PR12MB4587.namprd12.prod.outlook.com (2603:10b6:303:5d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Tue, 14 Mar
 2023 17:36:30 +0000
Received: from BL02EPF000108E9.namprd05.prod.outlook.com
 (2603:10b6:208:23d:cafe::de) by MN2PR06CA0019.outlook.office365.com
 (2603:10b6:208:23d::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26 via Frontend
 Transport; Tue, 14 Mar 2023 17:36:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BL02EPF000108E9.mail.protection.outlook.com (10.167.241.202) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6178.12 via Frontend Transport; Tue, 14 Mar 2023 17:36:30 +0000
Received: from SATLEXMB07.amd.com (10.181.41.45) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 14 Mar
 2023 12:36:30 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB07.amd.com
 (10.181.41.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 14 Mar
 2023 10:36:29 -0700
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34 via Frontend
 Transport; Tue, 14 Mar 2023 12:36:28 -0500
From:   <edward.cree@amd.com>
To:     <linux-net-drivers@amd.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@google.com>
CC:     Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>,
        <habetsm.xilinx@gmail.com>
Subject: [PATCH net-next 1/5] sfc: add notion of match on enc keys to MAE machinery
Date:   Tue, 14 Mar 2023 17:35:21 +0000
Message-ID: <cc70de55f816fe885fcb73003a9822961d1c5dfd.1678815095.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1678815095.git.ecree.xilinx@gmail.com>
References: <cover.1678815095.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF000108E9:EE_|MW3PR12MB4587:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a36d0c7-84c5-498d-19ca-08db24b2a5a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 902LRMy+/xF7B3tb7lssAwa7pqN9zwLbFwoluUZN7uIm1gGvcY2bnOGFq8+Hesbg+AuQ1TfMRcOL6gbGWme7g5LxB5G5cViVN8gkGcgM3hp1UZGCRQitU9Qq7CDDwU5vFdLk0R5478SdrjvjB59ZI2qQf6XYk00ir5ERf42MjA6qV2hdaCqz58QT5elBt6gjjEetrNqlcgbkJNbVVgfwdsgTIM2+3ibqQAc6zSEmAecjIU/NDN/585SydFD6yphG/2Mo1kpG+zcc3J69P4+aL+1PWRSk/nAOknJUGdk/+ECtXEzKLCc7hy4D/wy0ueCNBv3uJVnc9oNnAk1f/S7hitiiJYMuz/N3t+tC/6Pr1xfF3O177VsBPGu0pqbdJ6V6je0Ss9K4S/Yok0ovnFuGeSJct4mEcIEpTDWP40cXbOIuiBHyI6mx6JLJR0qYmpMoZlWxc5d4n2oS3WZfNzmTYtBWjifCqsWOyDh98a8Do7s++TbHYTfBV30ssHdRDrtSEZ9LUELEiwGmEk6WDmuxq8qpD6RNyfrAqKB50Ga0p6kVCEKYXLH9g6tzP0sflErRw7LbO5WjPOtmgr6e9KR16fyk4paP1b7Qa2yLpBzBt0outzZ3QNpIa/R3Vyn72bTQAPkP+tnA2R480nGNkfLv5vmEv6w7gsMwTtZxcqP4KVIsPw3T3R+qsIjr6C+jtaQFHFrvBOacvwITIlSIOGWhLYvQIzoxeoCpuc8rlg4XGN0=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(396003)(346002)(376002)(136003)(451199018)(36840700001)(46966006)(40470700004)(2876002)(2906002)(83380400001)(6666004)(36756003)(426003)(26005)(47076005)(9686003)(5660300002)(41300700001)(40460700003)(8936002)(186003)(55446002)(8676002)(86362001)(40480700001)(356005)(4326008)(70206006)(70586007)(336012)(478600001)(81166007)(110136005)(82740400003)(316002)(82310400005)(54906003)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 17:36:30.4689
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a36d0c7-84c5-498d-19ca-08db24b2a5a9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF000108E9.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4587
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree.xilinx@gmail.com>

Extend the MAE caps check to validate that the hardware supports used
 outer-header matches.
Extend efx_mae_populate_match_criteria() to fill in the outer rule ID
 and VNI match fields.
Nothing yet populates these match fields, nor creates outer rules.

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/mae.c | 104 ++++++++++++++++++++++++++++++++-
 drivers/net/ethernet/sfc/mae.h |   3 +
 drivers/net/ethernet/sfc/tc.h  |  24 ++++++++
 3 files changed, 129 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/sfc/mae.c b/drivers/net/ethernet/sfc/mae.c
index c53d354c1fb2..1a285facda34 100644
--- a/drivers/net/ethernet/sfc/mae.c
+++ b/drivers/net/ethernet/sfc/mae.c
@@ -254,13 +254,23 @@ static int efx_mae_get_rule_fields(struct efx_nic *efx, u32 cmd,
 	size_t outlen;
 	int rc, i;
 
+	/* AR and OR caps MCDIs have identical layout, so we are using the
+	 * same code for both.
+	 */
+	BUILD_BUG_ON(MC_CMD_MAE_GET_AR_CAPS_OUT_LEN(MAE_NUM_FIELDS) <
+		     MC_CMD_MAE_GET_OR_CAPS_OUT_LEN(MAE_NUM_FIELDS));
 	BUILD_BUG_ON(MC_CMD_MAE_GET_AR_CAPS_IN_LEN);
+	BUILD_BUG_ON(MC_CMD_MAE_GET_OR_CAPS_IN_LEN);
 
 	rc = efx_mcdi_rpc(efx, cmd, NULL, 0, outbuf, sizeof(outbuf), &outlen);
 	if (rc)
 		return rc;
+	BUILD_BUG_ON(MC_CMD_MAE_GET_AR_CAPS_OUT_COUNT_OFST !=
+		     MC_CMD_MAE_GET_OR_CAPS_OUT_COUNT_OFST);
 	count = MCDI_DWORD(outbuf, MAE_GET_AR_CAPS_OUT_COUNT);
 	memset(field_support, MAE_FIELD_UNSUPPORTED, MAE_NUM_FIELDS);
+	BUILD_BUG_ON(MC_CMD_MAE_GET_AR_CAPS_OUT_FIELD_FLAGS_OFST !=
+		     MC_CMD_MAE_GET_OR_CAPS_OUT_FIELD_FLAGS_OFST);
 	caps = _MCDI_DWORD(outbuf, MAE_GET_AR_CAPS_OUT_FIELD_FLAGS);
 	/* We're only interested in the support status enum, not any other
 	 * flags, so just extract that from each entry.
@@ -278,8 +288,12 @@ int efx_mae_get_caps(struct efx_nic *efx, struct mae_caps *caps)
 	rc = efx_mae_get_basic_caps(efx, caps);
 	if (rc)
 		return rc;
-	return efx_mae_get_rule_fields(efx, MC_CMD_MAE_GET_AR_CAPS,
-				       caps->action_rule_fields);
+	rc = efx_mae_get_rule_fields(efx, MC_CMD_MAE_GET_AR_CAPS,
+				     caps->action_rule_fields);
+	if (rc)
+		return rc;
+	return efx_mae_get_rule_fields(efx, MC_CMD_MAE_GET_OR_CAPS,
+				       caps->outer_rule_fields);
 }
 
 /* Bit twiddling:
@@ -432,11 +446,73 @@ int efx_mae_match_check_caps(struct efx_nic *efx,
 	    CHECK_BIT(IP_FIRST_FRAG, ip_firstfrag) ||
 	    CHECK(RECIRC_ID, recirc_id))
 		return rc;
+	/* Matches on outer fields are done in a separate hardware table,
+	 * the Outer Rule table.  Thus the Action Rule merely does an
+	 * exact match on Outer Rule ID if any outer field matches are
+	 * present.  The exception is the VNI/VSID (enc_keyid), which is
+	 * available to the Action Rule match iff the Outer Rule matched
+	 * (and thus identified the encap protocol to use to extract it).
+	 */
+	if (efx_tc_match_is_encap(mask)) {
+		rc = efx_mae_match_check_cap_typ(
+				supported_fields[MAE_FIELD_OUTER_RULE_ID],
+				MASK_ONES);
+		if (rc) {
+			NL_SET_ERR_MSG_MOD(extack, "No support for encap rule ID matches");
+			return rc;
+		}
+		if (CHECK(ENC_VNET_ID, enc_keyid))
+			return rc;
+	} else if (mask->enc_keyid) {
+		NL_SET_ERR_MSG_MOD(extack, "Match on enc_keyid requires other encap fields");
+		return -EINVAL;
+	}
 	return 0;
 }
 #undef CHECK_BIT
 #undef CHECK
 
+#define CHECK(_mcdi)	({						       \
+	rc = efx_mae_match_check_cap_typ(supported_fields[MAE_FIELD_ ## _mcdi],\
+					 MASK_ONES);			       \
+	if (rc)								       \
+		NL_SET_ERR_MSG_FMT_MOD(extack,				       \
+				       "No support for field %s", #_mcdi);     \
+	rc;								       \
+})
+/* Checks that the fields needed for encap-rule matches are supported by the
+ * MAE.  All the fields are exact-match.
+ */
+int efx_mae_check_encap_match_caps(struct efx_nic *efx, unsigned char ipv,
+				   struct netlink_ext_ack *extack)
+{
+	u8 *supported_fields = efx->tc->caps->outer_rule_fields;
+	int rc;
+
+	if (CHECK(ENC_ETHER_TYPE))
+		return rc;
+	switch (ipv) {
+	case 4:
+		if (CHECK(ENC_SRC_IP4) ||
+		    CHECK(ENC_DST_IP4))
+			return rc;
+		break;
+	case 6:
+		if (CHECK(ENC_SRC_IP6) ||
+		    CHECK(ENC_DST_IP6))
+			return rc;
+		break;
+	default: /* shouldn't happen */
+		EFX_WARN_ON_PARANOID(1);
+		break;
+	}
+	if (CHECK(ENC_L4_DPORT) ||
+	    CHECK(ENC_IP_PROTO))
+		return rc;
+	return 0;
+}
+#undef CHECK
+
 int efx_mae_allocate_counter(struct efx_nic *efx, struct efx_tc_counter *cnt)
 {
 	MCDI_DECLARE_BUF(outbuf, MC_CMD_MAE_COUNTER_ALLOC_OUT_LEN(1));
@@ -941,6 +1017,30 @@ static int efx_mae_populate_match_criteria(MCDI_DECLARE_STRUCT_PTR(match_crit),
 				match->value.tcp_flags);
 	MCDI_STRUCT_SET_WORD_BE(match_crit, MAE_FIELD_MASK_VALUE_PAIRS_V2_TCP_FLAGS_BE_MASK,
 				match->mask.tcp_flags);
+	/* enc-keys are handled indirectly, through encap_match ID */
+	if (match->encap) {
+		MCDI_STRUCT_SET_DWORD(match_crit, MAE_FIELD_MASK_VALUE_PAIRS_V2_OUTER_RULE_ID,
+				      match->encap->fw_id);
+		MCDI_STRUCT_SET_DWORD(match_crit, MAE_FIELD_MASK_VALUE_PAIRS_V2_OUTER_RULE_ID_MASK,
+				      (u32)-1);
+		/* enc_keyid (VNI/VSID) is not part of the encap_match */
+		MCDI_STRUCT_SET_DWORD_BE(match_crit, MAE_FIELD_MASK_VALUE_PAIRS_V2_ENC_VNET_ID_BE,
+					 match->value.enc_keyid);
+		MCDI_STRUCT_SET_DWORD_BE(match_crit, MAE_FIELD_MASK_VALUE_PAIRS_V2_ENC_VNET_ID_BE_MASK,
+					 match->mask.enc_keyid);
+	} else {
+		/* No enc-keys should appear in a rule without an encap_match */
+		if (WARN_ON_ONCE(match->mask.enc_src_ip) ||
+		    WARN_ON_ONCE(match->mask.enc_dst_ip) ||
+		    WARN_ON_ONCE(!ipv6_addr_any(&match->mask.enc_src_ip6)) ||
+		    WARN_ON_ONCE(!ipv6_addr_any(&match->mask.enc_dst_ip6)) ||
+		    WARN_ON_ONCE(match->mask.enc_ip_tos) ||
+		    WARN_ON_ONCE(match->mask.enc_ip_ttl) ||
+		    WARN_ON_ONCE(match->mask.enc_sport) ||
+		    WARN_ON_ONCE(match->mask.enc_dport) ||
+		    WARN_ON_ONCE(match->mask.enc_keyid))
+			return -EOPNOTSUPP;
+	}
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/sfc/mae.h b/drivers/net/ethernet/sfc/mae.h
index bec293a06733..a45d1791517f 100644
--- a/drivers/net/ethernet/sfc/mae.h
+++ b/drivers/net/ethernet/sfc/mae.h
@@ -72,6 +72,7 @@ struct mae_caps {
 	u32 match_field_count;
 	u32 action_prios;
 	u8 action_rule_fields[MAE_NUM_FIELDS];
+	u8 outer_rule_fields[MAE_NUM_FIELDS];
 };
 
 int efx_mae_get_caps(struct efx_nic *efx, struct mae_caps *caps);
@@ -79,6 +80,8 @@ int efx_mae_get_caps(struct efx_nic *efx, struct mae_caps *caps);
 int efx_mae_match_check_caps(struct efx_nic *efx,
 			     const struct efx_tc_match_fields *mask,
 			     struct netlink_ext_ack *extack);
+int efx_mae_check_encap_match_caps(struct efx_nic *efx, unsigned char ipv,
+				   struct netlink_ext_ack *extack);
 
 int efx_mae_allocate_counter(struct efx_nic *efx, struct efx_tc_counter *cnt);
 int efx_mae_free_counter(struct efx_nic *efx, struct efx_tc_counter *cnt);
diff --git a/drivers/net/ethernet/sfc/tc.h b/drivers/net/ethernet/sfc/tc.h
index 542853f60c2a..c1485679507c 100644
--- a/drivers/net/ethernet/sfc/tc.h
+++ b/drivers/net/ethernet/sfc/tc.h
@@ -48,11 +48,35 @@ struct efx_tc_match_fields {
 	/* L4 */
 	__be16 l4_sport, l4_dport; /* Ports (UDP, TCP) */
 	__be16 tcp_flags;
+	/* Encap.  The following are *outer* fields.  Note that there are no
+	 * outer eth (L2) fields; this is because TC doesn't have them.
+	 */
+	__be32 enc_src_ip, enc_dst_ip;
+	struct in6_addr enc_src_ip6, enc_dst_ip6;
+	u8 enc_ip_tos, enc_ip_ttl;
+	__be16 enc_sport, enc_dport;
+	__be32 enc_keyid; /* e.g. VNI, VSID */
+};
+
+static inline bool efx_tc_match_is_encap(const struct efx_tc_match_fields *mask)
+{
+	return mask->enc_src_ip || mask->enc_dst_ip ||
+	       !ipv6_addr_any(&mask->enc_src_ip6) ||
+	       !ipv6_addr_any(&mask->enc_dst_ip6) || mask->enc_ip_tos ||
+	       mask->enc_ip_ttl || mask->enc_sport || mask->enc_dport;
+}
+
+struct efx_tc_encap_match {
+	__be32 src_ip, dst_ip;
+	struct in6_addr src_ip6, dst_ip6;
+	__be16 udp_dport;
+	u32 fw_id; /* index of this entry in firmware encap match table */
 };
 
 struct efx_tc_match {
 	struct efx_tc_match_fields value;
 	struct efx_tc_match_fields mask;
+	struct efx_tc_encap_match *encap;
 };
 
 struct efx_tc_action_set_list {
