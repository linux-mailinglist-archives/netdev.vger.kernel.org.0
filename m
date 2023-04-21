Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93F9B6EACB9
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 16:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232402AbjDUOVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 10:21:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232358AbjDUOVL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 10:21:11 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2049.outbound.protection.outlook.com [40.107.92.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5EB39030
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 07:20:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UjA0oTqtroVgav1OaDRDHA919Vy2agqsX44tIW/b7dEcRxamPanMSIUp9ieqvQl5vOH9M1WE/sw1U/EvlU1XMc2XYXAjx/6i2xI0FYlsTcQHWKaMC8Vsl/JqCCjgVvihUJ+V//FBH+wdz18qs/Opk9rws8kJmh91QFrKG80jqCN37oOu3n/oYqDF77oP/QiGtrZpfRd1TvGShUKV4iAPknBWP3S9zcui3pbMZVctuNdFOrJnPbxeV/9YWaTg+B10X0P6j0PiKgzHkciC/XSn1bDPv8NwGfv0jxwo/BiX3wGUnbhxqY3rB6CGTIqd79w1LPvQpTsFuvcx2P5aXeVq/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VsM5vNb1oVusfKoDHDyvuZMFaLP8Ttv2yz2NoPnYLFw=;
 b=f5dxIWFos2KWm0Cf8pXmHhfDCIJQHLE2MFfIbuy8JozwSJNW+PQ7+NBZ5Xe4M3PLWyAhyPd5cMSWTxiVLnrskB1W0DrtsJMeDF4MLt0jtyEdObxmJ55ljL3dZvB5ntz5g7maLzGAu3Zv2G2bEjuWIb67AWHmZr3TsN9m1nRrw/4E9rPMYu7wDN3EPIdB225P+zVuTCOPsc5gEQ5IaH6xbWR1jHEeJ/T/GGzo/F6I47KclaDoYoYYahd/2tjNIXCKT2fiWmWNEZ5veumcr9yLxHI6xCfZr1vfHb40YlOvYs8JNxS5uJ//PdfJndMudjVTgzpvXVG1jByUnpliPcg5hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VsM5vNb1oVusfKoDHDyvuZMFaLP8Ttv2yz2NoPnYLFw=;
 b=NcPmu76nGz6UhR0B+mflTkM8FuziIuZdWQl0Z42vZKduW7+IgAZ7n+E0wRsPLuIZTC9FBqlpGNiRMba/eyDmS1Zk/Zs4cuRGDH0P5V9YickOtI1VmCB2H8YDGp6PdYUDaKhHtXxhDUVBUhfwVhpHT+HZCe7PmZ3AYWzPEk/I7I8=
Received: from DS7PR05CA0052.namprd05.prod.outlook.com (2603:10b6:8:2f::30) by
 CY5PR12MB6528.namprd12.prod.outlook.com (2603:10b6:930:43::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6319.22; Fri, 21 Apr 2023 14:20:55 +0000
Received: from DM6NAM11FT101.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2f:cafe::a1) by DS7PR05CA0052.outlook.office365.com
 (2603:10b6:8:2f::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.14 via Frontend
 Transport; Fri, 21 Apr 2023 14:20:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT101.mail.protection.outlook.com (10.13.172.208) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6319.27 via Frontend Transport; Fri, 21 Apr 2023 14:20:54 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 21 Apr
 2023 09:20:53 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 21 Apr
 2023 09:20:53 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34 via Frontend
 Transport; Fri, 21 Apr 2023 09:20:51 -0500
From:   <edward.cree@amd.com>
To:     <linux-net-drivers@amd.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@google.com>
CC:     Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>,
        <habetsm.xilinx@gmail.com>,
        Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
Subject: [PATCH net-next 4/4] sfc: support TC decap rules matching on enc_src_port
Date:   Fri, 21 Apr 2023 15:19:54 +0100
Message-ID: <5b1166f0213e433669805d17586a219a3f593130.1682086533.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1682086533.git.ecree.xilinx@gmail.com>
References: <cover.1682086533.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT101:EE_|CY5PR12MB6528:EE_
X-MS-Office365-Filtering-Correlation-Id: e71f7394-a151-4804-ec5f-08db42739e16
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wNEJuSCAgShIfdSpW1yf/DG/VPBJ4GwURuqk4WkouvIZK4ImtIZ/4xIlO+NSOCKqDjF/joayHoZVCWClXdzXoX20pqXdJoXtnp5L0ZSJe5H4XnaVltOm7g5fuHLdMy5s29NsXnKPO+Mg/lRbi+V89ygkC//rciqQ4rC1UZ4RaBCyOs2guHgm/WASEkDyHxMDsMmZ7aTuvye+++ekSEZatZzPmZyPSncDhYukODn/oU1VRTenig0R8ZTppj2FzcvfVEh+7Rqq4LmSfswbEY/cVX4lEHfw4SHPvdgukCK1VDsmwu8r4DPf1cOT/xlW6006nJdKMLBOC9COPoLuyHcQLe4gFrhbOzSCSOYp4kZxTgsmkX6il5d2v5G4NKVDqwjBaicL+Nn4mcbBs0kjW1CgQlbUhx9vJpEl6TnEnk/UdQoNPtuEi/0bbtspFooix94AMFjbN+50MbeXDWqBv1rM4/FCrZIQHTGM3CGCAR2XoRSjGz+KS6rg94AGf4Rt/1TA9W0BpwOzjOoDcXn64NznQkST6+tG3osZRN4udW1ZBzdV6Z+NyVMBFCPs6pXr/EYw+suUgYwy0IofVn4z0tpbG35feZhjxhJllzoxYiB0FOyKF9PJP7QZ5z8reTw+GdCV6bQRMbUwCx3+nwKSR6FQlvWq8/6EXWS6WKQT3NsfCMKE7ao7cMAxzsOOEnl+KlyDX7aA7YZ2lXaqEXSx80EZU7KqiGMXaO/rBn1suA+YEbg=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(376002)(396003)(39860400002)(451199021)(46966006)(40470700004)(36840700001)(36860700001)(47076005)(83380400001)(478600001)(36756003)(40480700001)(40460700003)(356005)(82740400003)(81166007)(55446002)(86362001)(2906002)(5660300002)(2876002)(54906003)(110136005)(8676002)(8936002)(70586007)(70206006)(316002)(4326008)(41300700001)(186003)(82310400005)(336012)(426003)(26005)(9686003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2023 14:20:54.3250
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e71f7394-a151-4804-ec5f-08db42739e16
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT101.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6528
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree.xilinx@gmail.com>

Allow efx_tc_encap_match entries to include a udp_sport and a
 udp_sport_mask.  As with enc_ip_tos, use pseudos to enforce that all
 encap matches within a given <src_ip,dst_ip,udp_dport> tuple have
 the same udp_sport_mask.
Note that since we use a single layer of pseudos for both fields, two
 matches that differ in (say) udp_sport value aren't permitted to have
 different ip_tos_mask, even though this would technically be safe.
Current userland TC does not support setting enc_src_port; this patch
 was tested with an iproute2 patched to support it.

Reviewed-by: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/mae.c | 14 +++++++++++++-
 drivers/net/ethernet/sfc/mae.h |  2 +-
 drivers/net/ethernet/sfc/tc.c  | 31 +++++++++++++++++++++----------
 drivers/net/ethernet/sfc/tc.h  | 10 ++++++----
 4 files changed, 41 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/sfc/mae.c b/drivers/net/ethernet/sfc/mae.c
index 8f4bb5d36ad8..37a4c6925ad4 100644
--- a/drivers/net/ethernet/sfc/mae.c
+++ b/drivers/net/ethernet/sfc/mae.c
@@ -485,7 +485,7 @@ int efx_mae_match_check_caps(struct efx_nic *efx,
  * MAE.  All the fields are exact-match, except possibly ENC_IP_TOS.
  */
 int efx_mae_check_encap_match_caps(struct efx_nic *efx, bool ipv6,
-				   u8 ip_tos_mask,
+				   u8 ip_tos_mask, __be16 udp_sport_mask,
 				   struct netlink_ext_ack *extack)
 {
 	u8 *supported_fields = efx->tc->caps->outer_rule_fields;
@@ -506,6 +506,14 @@ int efx_mae_check_encap_match_caps(struct efx_nic *efx, bool ipv6,
 	if (CHECK(ENC_L4_DPORT) ||
 	    CHECK(ENC_IP_PROTO))
 		return rc;
+	typ = classify_mask((const u8 *)&udp_sport_mask, sizeof(udp_sport_mask));
+	rc = efx_mae_match_check_cap_typ(supported_fields[MAE_FIELD_ENC_L4_SPORT],
+					 typ);
+	if (rc) {
+		NL_SET_ERR_MSG_FMT_MOD(extack, "No support for %s mask in field %s",
+				       mask_type_name(typ), "enc_src_port");
+		return rc;
+	}
 	typ = classify_mask(&ip_tos_mask, sizeof(ip_tos_mask));
 	rc = efx_mae_match_check_cap_typ(supported_fields[MAE_FIELD_ENC_IP_TOS],
 					 typ);
@@ -1011,6 +1019,10 @@ int efx_mae_register_encap_match(struct efx_nic *efx,
 				encap->udp_dport);
 	MCDI_STRUCT_SET_WORD_BE(match_crit, MAE_ENC_FIELD_PAIRS_ENC_L4_DPORT_BE_MASK,
 				~(__be16)0);
+	MCDI_STRUCT_SET_WORD_BE(match_crit, MAE_ENC_FIELD_PAIRS_ENC_L4_DPORT_BE,
+				encap->udp_sport);
+	MCDI_STRUCT_SET_WORD_BE(match_crit, MAE_ENC_FIELD_PAIRS_ENC_L4_DPORT_BE_MASK,
+				encap->udp_sport_mask);
 	MCDI_STRUCT_SET_BYTE(match_crit, MAE_ENC_FIELD_PAIRS_ENC_IP_PROTO, IPPROTO_UDP);
 	MCDI_STRUCT_SET_BYTE(match_crit, MAE_ENC_FIELD_PAIRS_ENC_IP_PROTO_MASK, ~0);
 	MCDI_STRUCT_SET_BYTE(match_crit, MAE_ENC_FIELD_PAIRS_ENC_IP_TOS,
diff --git a/drivers/net/ethernet/sfc/mae.h b/drivers/net/ethernet/sfc/mae.h
index cec61bfde4d4..1cf8dfeb0c28 100644
--- a/drivers/net/ethernet/sfc/mae.h
+++ b/drivers/net/ethernet/sfc/mae.h
@@ -82,7 +82,7 @@ int efx_mae_match_check_caps(struct efx_nic *efx,
 			     const struct efx_tc_match_fields *mask,
 			     struct netlink_ext_ack *extack);
 int efx_mae_check_encap_match_caps(struct efx_nic *efx, bool ipv6,
-				   u8 ip_tos_mask,
+				   u8 ip_tos_mask, __be16 udp_sport_mask,
 				   struct netlink_ext_ack *extack);
 int efx_mae_check_encap_type_supported(struct efx_nic *efx,
 				       enum efx_encap_type typ);
diff --git a/drivers/net/ethernet/sfc/tc.c b/drivers/net/ethernet/sfc/tc.c
index 8e1769d2c4ee..da684b4b7211 100644
--- a/drivers/net/ethernet/sfc/tc.c
+++ b/drivers/net/ethernet/sfc/tc.c
@@ -377,6 +377,7 @@ static int efx_tc_flower_record_encap_match(struct efx_nic *efx,
 					    enum efx_encap_type type,
 					    enum efx_tc_em_pseudo_type em_type,
 					    u8 child_ip_tos_mask,
+					    __be16 child_udp_sport_mask,
 					    struct netlink_ext_ack *extack)
 {
 	struct efx_tc_encap_match *encap, *old, *pseudo = NULL;
@@ -425,11 +426,7 @@ static int efx_tc_flower_record_encap_match(struct efx_nic *efx,
 		NL_SET_ERR_MSG_MOD(extack, "Egress encap match is not exact on dst UDP port");
 		return -EOPNOTSUPP;
 	}
-	if (match->mask.enc_sport) {
-		NL_SET_ERR_MSG_MOD(extack, "Egress encap match on src UDP port not supported");
-		return -EOPNOTSUPP;
-	}
-	if (match->mask.enc_ip_tos) {
+	if (match->mask.enc_sport || match->mask.enc_ip_tos) {
 		struct efx_tc_match pmatch = *match;
 
 		if (em_type == EFX_TC_EM_PSEUDO_MASK) { /* can't happen */
@@ -438,9 +435,12 @@ static int efx_tc_flower_record_encap_match(struct efx_nic *efx,
 		}
 		pmatch.value.enc_ip_tos = 0;
 		pmatch.mask.enc_ip_tos = 0;
+		pmatch.value.enc_sport = 0;
+		pmatch.mask.enc_sport = 0;
 		rc = efx_tc_flower_record_encap_match(efx, &pmatch, type,
 						      EFX_TC_EM_PSEUDO_MASK,
 						      match->mask.enc_ip_tos,
+						      match->mask.enc_sport,
 						      extack);
 		if (rc)
 			return rc;
@@ -452,7 +452,8 @@ static int efx_tc_flower_record_encap_match(struct efx_nic *efx,
 		goto fail_pseudo;
 	}
 
-	rc = efx_mae_check_encap_match_caps(efx, ipv6, match->mask.enc_ip_tos, extack);
+	rc = efx_mae_check_encap_match_caps(efx, ipv6, match->mask.enc_ip_tos,
+					    match->mask.enc_sport, extack);
 	if (rc)
 		goto fail_pseudo;
 
@@ -472,6 +473,9 @@ static int efx_tc_flower_record_encap_match(struct efx_nic *efx,
 	encap->ip_tos = match->value.enc_ip_tos;
 	encap->ip_tos_mask = match->mask.enc_ip_tos;
 	encap->child_ip_tos_mask = child_ip_tos_mask;
+	encap->udp_sport = match->value.enc_sport;
+	encap->udp_sport_mask = match->mask.enc_sport;
+	encap->child_udp_sport_mask = child_udp_sport_mask;
 	encap->type = em_type;
 	encap->pseudo = pseudo;
 	old = rhashtable_lookup_get_insert_fast(&efx->tc->encap_match_ht,
@@ -493,9 +497,9 @@ static int efx_tc_flower_record_encap_match(struct efx_nic *efx,
 			NL_SET_ERR_MSG_MOD(extack, "Pseudo encap match conflicts with existing direct entry");
 			return -EEXIST;
 		case EFX_TC_EM_PSEUDO_MASK:
-			/* old EM is protecting a ToS-qualified filter, so may
-			 * only be shared with another pseudo for the same
-			 * ToS mask.
+			/* old EM is protecting a ToS- or src port-qualified
+			 * filter, so may only be shared with another pseudo
+			 * for the same ToS and src port masks.
 			 */
 			if (em_type != EFX_TC_EM_PSEUDO_MASK) {
 				NL_SET_ERR_MSG_FMT_MOD(extack,
@@ -510,6 +514,13 @@ static int efx_tc_flower_record_encap_match(struct efx_nic *efx,
 						       old->child_ip_tos_mask);
 				return -EEXIST;
 			}
+			if (child_udp_sport_mask != old->child_udp_sport_mask) {
+				NL_SET_ERR_MSG_FMT_MOD(extack,
+						       "Pseudo encap match for UDP src port mask %#x conflicts with existing pseudo(MASK) entry for mask %#x",
+						       child_udp_sport_mask,
+						       old->child_udp_sport_mask);
+				return -EEXIST;
+			}
 			break;
 		default: /* Unrecognised pseudo-type.  Just say no */
 			NL_SET_ERR_MSG_FMT_MOD(extack,
@@ -704,7 +715,7 @@ static int efx_tc_flower_replace_foreign(struct efx_nic *efx,
 		}
 
 		rc = efx_tc_flower_record_encap_match(efx, &match, type,
-						      EFX_TC_EM_DIRECT, 0,
+						      EFX_TC_EM_DIRECT, 0, 0,
 						      extack);
 		if (rc)
 			goto release;
diff --git a/drivers/net/ethernet/sfc/tc.h b/drivers/net/ethernet/sfc/tc.h
index 0f14481d2d9e..24e9640c74e9 100644
--- a/drivers/net/ethernet/sfc/tc.h
+++ b/drivers/net/ethernet/sfc/tc.h
@@ -84,11 +84,11 @@ static inline bool efx_tc_match_is_encap(const struct efx_tc_match_fields *mask)
  * @EFX_TC_EM_DIRECT: real HW entry in Outer Rule table; not a pseudo.
  *	Hardware index in &struct efx_tc_encap_match.fw_id is valid.
  * @EFX_TC_EM_PSEUDO_MASK: registered by an encap match which includes a
- *	match on an optional field (currently only ip_tos), to prevent an
- *	overlapping encap match _without_ optional fields.
+ *	match on an optional field (currently ip_tos and/or udp_sport),
+ *	to prevent an overlapping encap match _without_ optional fields.
  *	The pseudo encap match may be referenced again by an encap match
- *	with a different ip_tos value, but all ip_tos_mask must match the
- *	first (stored in our child_ip_tos_mask).
+ *	with different values for these fields, but all masks must match the
+ *	first (stored in our child_* fields).
  */
 enum efx_tc_em_pseudo_type {
 	EFX_TC_EM_DIRECT,
@@ -99,10 +99,12 @@ struct efx_tc_encap_match {
 	__be32 src_ip, dst_ip;
 	struct in6_addr src_ip6, dst_ip6;
 	__be16 udp_dport;
+	__be16 udp_sport, udp_sport_mask;
 	u8 ip_tos, ip_tos_mask;
 	struct rhash_head linkage;
 	enum efx_encap_type tun_type;
 	u8 child_ip_tos_mask;
+	__be16 child_udp_sport_mask;
 	refcount_t ref;
 	enum efx_tc_em_pseudo_type type;
 	u32 fw_id; /* index of this entry in firmware encap match table */
