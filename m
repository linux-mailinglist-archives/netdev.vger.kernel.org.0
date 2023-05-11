Return-Path: <netdev+bounces-1936-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CD9186FFAD7
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 21:50:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DC9901C21088
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 19:50:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC261946C;
	Thu, 11 May 2023 19:49:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D981EAD58
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 19:49:39 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2087.outbound.protection.outlook.com [40.107.220.87])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD44E30D5
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 12:49:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RRZ+hCMLGAuy43np6alQ0zgSRDvJTcNpU4RVqjPGItSgA5djR9DxD1lJsVU3POFDuh5ndovzX9tcskRp1JhqOYz2fLwIujf3bb0tWlpoQaEoYxyktHPsv/A+j7X8Ye/hNnKrqV5yEbnjiECsaozM/x3Kl5vl9bQZwpLuyWB0p1tZw0Dk83QZXywJqpIJupuoePuazOk91PbZv8LFDCwyewT86v44HURTSQ+MAOcAJc2WA92l7q03jIeQMjGzRuR5VIzLfWk5jFkuGoDoJcyU1NoROmak633/6Z81KXgqAplCov6Dwa8y9vjaN9R7MCUhNAJKfopdfROssXvDGjSZDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dwsWrKvkXVtmO85bxXp7a/B0bCr4/xyJ2jGtwfQgMFs=;
 b=YPOVo5sDcmvjNzcODfGrOh+vNc0Sl3wKiYn65kjFSHn6h+MWq2UtCXNeYqf9R9iDYRwh187F+nbsizwZV6fU3H1AeL/PGhJTHMI8vwx7T13PR2wC5J7pO/wPFidl7Q94u4l1xNlf31jbSWQdX2pStfbbZBIpn/+QrihHuvw4gd8iq1iWVt9l3HNKo/s3hjtmDOrGwiOhJz2aIP22VFmRdgeuGvH6ytSIhGYJu2IIrrrZLwjUoLaEMXpJixnSK4ok/m3CEkjMM7eL2B3JFk8wXUdwM9gFL5tuaUYyMyxNuVtAs0iNGBpN4nyqUNM1m+JsgeeGKQZLgr0Gb1dW4sdwQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dwsWrKvkXVtmO85bxXp7a/B0bCr4/xyJ2jGtwfQgMFs=;
 b=5X7DXjeYEPXpwbg2NEAP7BZ7T+H1JNKqzflmx3gK5WKeMldAUz+nKvg0TtQ4mGP6EF5GFxyFLt8Q3wYKQJJ9Ck+6ZRDQSMKpdQiIMJTCSVgp8UUKOfEqTZvmpCrryC9dK0/UKEmrn3cQ20zU8agJnfkljXzjE8aN/ZNDttPXSC0=
Received: from DM6PR05CA0049.namprd05.prod.outlook.com (2603:10b6:5:335::18)
 by CH3PR12MB7546.namprd12.prod.outlook.com (2603:10b6:610:149::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33; Thu, 11 May
 2023 19:48:16 +0000
Received: from DM6NAM11FT034.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:335:cafe::87) by DM6PR05CA0049.outlook.office365.com
 (2603:10b6:5:335::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.7 via Frontend
 Transport; Thu, 11 May 2023 19:48:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT034.mail.protection.outlook.com (10.13.173.47) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6387.22 via Frontend Transport; Thu, 11 May 2023 19:48:16 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 11 May
 2023 14:48:15 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 11 May
 2023 14:48:15 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34 via Frontend
 Transport; Thu, 11 May 2023 14:48:14 -0500
From: <edward.cree@amd.com>
To: <linux-net-drivers@amd.com>, <davem@davemloft.net>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <edumazet@google.com>
CC: Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>,
	<habetsm.xilinx@gmail.com>
Subject: [PATCH v2 net-next 4/4] sfc: support TC decap rules matching on enc_src_port
Date: Thu, 11 May 2023 20:47:31 +0100
Message-ID: <86d613c3e470d526ad5c58ad2b3ff34d0247171c.1683834261.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1683834261.git.ecree.xilinx@gmail.com>
References: <cover.1683834261.git.ecree.xilinx@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT034:EE_|CH3PR12MB7546:EE_
X-MS-Office365-Filtering-Correlation-Id: 003be165-0244-49c1-4078-08db5258a9f3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	uSvr2/V28+UYMy04iZXFuo7UpHuS3xK1hwcYPtuOdj/hsAhRdLk81PpXazuDsJdCneKb+o5fbF3j/8nJNDz9tKbrUGDaT6LwBCqqpJt3B+KSRJ9NGJXvEB7gPa2s2gM+TAQ4L55XZMtDqgRZcD6U9PbT/Ji61n/VVlg5u2pw5XJujFg6k1dxHRcLBqqz8yZJdXCj2lEL6GtUyQ/RBaIm/1cPiHo5+9ROjyQnZqwl565iZDVUorycIk/KFhMwNl0t24IydZ2wCWPCCrukdaqHQtHqgTRpnzla7JYp4joXhgNUFC49D/SLLxDjlNFxaUPRVTOWs9BWl6N4D9PMZJcmyxoyUIiVwvMSWUKCeNxVaJ8NWqWZPzVQT/FvMrxGkf5hYJQfD/XIhn2QLFvIEFAJ1DtbCvX8kJxuHApwKZD77xMypSCDG7epPnubyeXyIl6hJaRqzgG/TAiI5fzD9HL45AYnNPfaGXeA7/QhpI5tXEv8e44vFl7snGYXc44TGVHiFsxQkZiKGAHSowqGQsLx7GaJIOCuoETxtp+Uf8WdeqnSAwRizjW2RAjoDr8nq6bxkMrxuJv+IHNcyLphIa9J1nvbMDxYcJ1bn5oWLN95KSFX6lM7JXWJSLQlJib6wV+Xi60nZP7ueGUv8Bk1a1jpf5d4XYR+otjWrDVCaQahO2Pby7swkwTParCX4hfXS88D9zw474T6kEDdQFg86k+EvZ3aq2MR/iXuG6pnHbkzLT8=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(396003)(39860400002)(136003)(451199021)(40470700004)(36840700001)(46966006)(70206006)(70586007)(478600001)(4326008)(5660300002)(8936002)(8676002)(26005)(54906003)(110136005)(316002)(41300700001)(9686003)(6666004)(2906002)(40460700003)(83380400001)(2876002)(426003)(336012)(186003)(36860700001)(82740400003)(81166007)(40480700001)(356005)(82310400005)(47076005)(86362001)(55446002)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 19:48:16.4166
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 003be165-0244-49c1-4078-08db5258a9f3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM6NAM11FT034.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7546
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

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

