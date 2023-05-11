Return-Path: <netdev+bounces-1932-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BDAF66FFAD3
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 21:49:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CC3DC1C2103D
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 19:49:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6579D9463;
	Thu, 11 May 2023 19:49:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50B4F206AE
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 19:49:02 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on20631.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8a::631])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D9C87ED5
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 12:48:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZKHsFjgYr+FYE/yr2dIqsrTgKcrWdG0wqRgRcabkm5A7zzfhVrornuQVgItv3938WmXrbLHi74P62LtkQTFmD41eX+TzZj1GyVJ4KQmoT1rLsCwoipCiSfQiL+XXImO1t+x2zRmfn7sfEn54DuFkMpHLeu07BwDU8vAzR12UYQKbC6o6wZmIZKWPirWN8vpg+5ZGMV2hVXODyMD7YRKE9/q8sUGVC3mFemxSWCPB/V/3LcmyW7uz24zVvgM/84X26apLYnOEZMxYh9OI7LVu0hrcjmYWK/fcQrIACF4atpzKfWH0wzHVFV6QdsRsfsQ9LF8Vl9phfaobhhMNKliRJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hAtakLEquB3CO8IJe4u4RhsYsYnyYeXCSxIfPlKM6iQ=;
 b=hi+ECvznNYeMwk1/s1MV25Z0rwDjFeUiraxS585Z5nWbtzH3ezxjyTmJUQa5E8xhD53XKBJMmvyVcZcs6F+zvWgT3T5VtfJiN61utKyjt8yJChAcA7fA6tK7s6FK5IN1etoRNuDd3xZjIkd0F75xkJB0lEPCvwPJvbluqHA6b7ebfoBXZgku7hGeX4eo/Qv4plE1la+d6hRAes6eJkLDz1eT1d+7e80YNOmui5sGPlSTiLvPGYcvQ+SO9sBPA4gAwllQcTTp+SQE4jvyjKkhwrSdkuxqe+lYRiKWhLcyYwJ/A3Nhrgc8zIWJ5pjTzUcn0IyHQ2Kdix6WIJCH7lUabQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hAtakLEquB3CO8IJe4u4RhsYsYnyYeXCSxIfPlKM6iQ=;
 b=udwN36C2JlnV5P2GjleBFUiafK1nHUlL5jBjuRgIVevnfe1+8OeyvYY3PBF90qA7eHngRB//rtyEfmQjs1vrJE4AyztUvndERkE/HIdUdv6JRs/Ys5vQyWGHtspEPcT2Vrc9pQxLnCQp+oaATrC7giI79Ee1a5exULQET2RWihs=
Received: from DM6PR13CA0037.namprd13.prod.outlook.com (2603:10b6:5:134::14)
 by MN2PR12MB4271.namprd12.prod.outlook.com (2603:10b6:208:1d7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.20; Thu, 11 May
 2023 19:48:15 +0000
Received: from DM6NAM11FT005.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:134:cafe::5e) by DM6PR13CA0037.outlook.office365.com
 (2603:10b6:5:134::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.20 via Frontend
 Transport; Thu, 11 May 2023 19:48:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT005.mail.protection.outlook.com (10.13.172.238) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6387.21 via Frontend Transport; Thu, 11 May 2023 19:48:14 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 11 May
 2023 14:48:14 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34 via Frontend
 Transport; Thu, 11 May 2023 14:48:13 -0500
From: <edward.cree@amd.com>
To: <linux-net-drivers@amd.com>, <davem@davemloft.net>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <edumazet@google.com>
CC: Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>,
	<habetsm.xilinx@gmail.com>
Subject: [PATCH v2 net-next 3/4] sfc: support TC decap rules matching on enc_ip_tos
Date: Thu, 11 May 2023 20:47:30 +0100
Message-ID: <acc9f66562f7a82b2b033bc3ee3470e580036b81.1683834261.git.ecree.xilinx@gmail.com>
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT005:EE_|MN2PR12MB4271:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c97f09e-ff2e-45fe-1a17-08db5258a903
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Da/qBV36aj+b9Q1k0Nx9F3NEzTOUHDiZd7mCa43MO0XI4iWqDAl3HdajbKqS79dc0/C0Psa8WSmWtxqWPLntPxdsx5H1RhTtof20oNaqDyNe3sZzNNoQzDPjs+WZkR9WYIRGosKtV/LJGkgUV/FVW0C8zSoKMHIZ1F08FQH4rWZmwJInxVP1tv18dzSbJNGszO+tadBkjIPOyXqbitUn+6V8BNB5vIsq2gUpbEtex1pGFjoszYOM1gvSrHojTpJnwfjsh4cAL4D+4f9FQx4/IjE6CauHNQfVzav6vrcvtSTBzdTu5DdcLHQrgPZ1giIA5XgPZ+Ln424P0999goKKLjU1wwpFtUztpzULClTa9cJpI+X0Q9PAOAHTHUy3Am49PgsE949s5DScYtzQN++fMD01pzFXmKlwfUpDDlDnQkSiHbg9Aib4w192bXk8eZmZyk/loeuD9b18kMomTm6nFuFoTKLZcGghuk2Y/ztBLyiDOAh6MPwGCJDIUEyy1950sK6yKQGEcOJgivLvjYxSgRqH4CAQBrUWRl806Wpc5cITYMMvRBIGqTeGxE+hQuTxzxDnmnabMkfHIzwe8NfA8WBy3/IjH72bRXlId3VrMa7GCzUiyO2MfiUpcHrRFrTDSfmUKFjANzs2tfJP4bOPzIdPKC8Qa6qxQGTiP08bHz0v0toqVoSwTOt2qW71YZRL6buIwsJIRiugF59nzHyRUYCzSfuiSQhAp2uPH3RnpliUV9oWIaGyAR2so2igdyts45ABYdrw5UyOY6lU66e5/Q==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(136003)(376002)(396003)(346002)(451199021)(40470700004)(36840700001)(46966006)(55446002)(86362001)(8936002)(6666004)(8676002)(186003)(36756003)(2906002)(2876002)(82310400005)(5660300002)(40480700001)(40460700003)(26005)(478600001)(316002)(356005)(47076005)(9686003)(81166007)(83380400001)(82740400003)(110136005)(54906003)(4326008)(70206006)(426003)(336012)(36860700001)(70586007)(41300700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 19:48:14.8584
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c97f09e-ff2e-45fe-1a17-08db5258a903
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM6NAM11FT005.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4271
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Edward Cree <ecree.xilinx@gmail.com>

Allow efx_tc_encap_match entries to include an ip_tos and ip_tos_mask.
To avoid partially-overlapping Outer Rules (which can lead to undefined
 behaviour in the hardware), store extra "pseudo" entries in our
 encap_match hashtable, which are used to enforce that all Outer Rule
 entries within a given <src_ip,dst_ip,udp_dport> tuple (or IPv6
 equivalent) have the same ip_tos_mask.
The "direct" encap_match entry takes a reference on the "pseudo",
 allowing it to be destroyed when all "direct" entries using it are
 removed.
efx_tc_em_pseudo_type is an enum rather than just a bool because in
 future an additional pseudo-type will be added to support Conntrack
 offload.

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/tc.c | 145 +++++++++++++++++++++++++---------
 drivers/net/ethernet/sfc/tc.h |  24 ++++++
 2 files changed, 133 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/sfc/tc.c b/drivers/net/ethernet/sfc/tc.c
index c2dda3ae5492..8e1769d2c4ee 100644
--- a/drivers/net/ethernet/sfc/tc.c
+++ b/drivers/net/ethernet/sfc/tc.c
@@ -202,6 +202,7 @@ static int efx_tc_flower_parse_match(struct efx_nic *efx,
 	      BIT(FLOW_DISSECTOR_KEY_ENC_KEYID) |
 	      BIT(FLOW_DISSECTOR_KEY_ENC_IPV4_ADDRS) |
 	      BIT(FLOW_DISSECTOR_KEY_ENC_IPV6_ADDRS) |
+	      BIT(FLOW_DISSECTOR_KEY_ENC_IP) |
 	      BIT(FLOW_DISSECTOR_KEY_ENC_PORTS) |
 	      BIT(FLOW_DISSECTOR_KEY_ENC_CONTROL) |
 	      BIT(FLOW_DISSECTOR_KEY_TCP) |
@@ -346,20 +347,47 @@ static int efx_tc_flower_parse_match(struct efx_nic *efx,
 	return 0;
 }
 
+static void efx_tc_flower_release_encap_match(struct efx_nic *efx,
+					      struct efx_tc_encap_match *encap)
+{
+	int rc;
+
+	if (!refcount_dec_and_test(&encap->ref))
+		return; /* still in use */
+
+	if (encap->type == EFX_TC_EM_DIRECT) {
+		rc = efx_mae_unregister_encap_match(efx, encap);
+		if (rc)
+			/* Display message but carry on and remove entry from our
+			 * SW tables, because there's not much we can do about it.
+			 */
+			netif_err(efx, drv, efx->net_dev,
+				  "Failed to release encap match %#x, rc %d\n",
+				  encap->fw_id, rc);
+	}
+	rhashtable_remove_fast(&efx->tc->encap_match_ht, &encap->linkage,
+			       efx_tc_encap_match_ht_params);
+	if (encap->pseudo)
+		efx_tc_flower_release_encap_match(efx, encap->pseudo);
+	kfree(encap);
+}
+
 static int efx_tc_flower_record_encap_match(struct efx_nic *efx,
 					    struct efx_tc_match *match,
 					    enum efx_encap_type type,
+					    enum efx_tc_em_pseudo_type em_type,
+					    u8 child_ip_tos_mask,
 					    struct netlink_ext_ack *extack)
 {
-	struct efx_tc_encap_match *encap, *old;
+	struct efx_tc_encap_match *encap, *old, *pseudo = NULL;
 	bool ipv6 = false;
 	int rc;
 
 	/* We require that the socket-defining fields (IP addrs and UDP dest
-	 * port) are present and exact-match.  Other fields are currently not
-	 * allowed.  This meets what OVS will ask for, and means that we don't
-	 * need to handle difficult checks for overlapping matches as could
-	 * come up if we allowed masks or varying sets of match fields.
+	 * port) are present and exact-match.  Other fields may only be used
+	 * if the field-set (and any masks) are the same for all encap
+	 * matches on the same <sip,dip,dport> tuple; this is enforced by
+	 * pseudo encap matches.
 	 */
 	if (match->mask.enc_dst_ip | match->mask.enc_src_ip) {
 		if (!IS_ALL_ONES(match->mask.enc_dst_ip)) {
@@ -402,21 +430,37 @@ static int efx_tc_flower_record_encap_match(struct efx_nic *efx,
 		return -EOPNOTSUPP;
 	}
 	if (match->mask.enc_ip_tos) {
-		NL_SET_ERR_MSG_MOD(extack, "Egress encap match on IP ToS not supported");
-		return -EOPNOTSUPP;
+		struct efx_tc_match pmatch = *match;
+
+		if (em_type == EFX_TC_EM_PSEUDO_MASK) { /* can't happen */
+			NL_SET_ERR_MSG_MOD(extack, "Bad recursion in egress encap match handler");
+			return -EOPNOTSUPP;
+		}
+		pmatch.value.enc_ip_tos = 0;
+		pmatch.mask.enc_ip_tos = 0;
+		rc = efx_tc_flower_record_encap_match(efx, &pmatch, type,
+						      EFX_TC_EM_PSEUDO_MASK,
+						      match->mask.enc_ip_tos,
+						      extack);
+		if (rc)
+			return rc;
+		pseudo = pmatch.encap;
 	}
 	if (match->mask.enc_ip_ttl) {
 		NL_SET_ERR_MSG_MOD(extack, "Egress encap match on IP TTL not supported");
-		return -EOPNOTSUPP;
+		rc = -EOPNOTSUPP;
+		goto fail_pseudo;
 	}
 
 	rc = efx_mae_check_encap_match_caps(efx, ipv6, match->mask.enc_ip_tos, extack);
 	if (rc)
-		return rc;
+		goto fail_pseudo;
 
 	encap = kzalloc(sizeof(*encap), GFP_USER);
-	if (!encap)
-		return -ENOMEM;
+	if (!encap) {
+		rc = -ENOMEM;
+		goto fail_pseudo;
+	}
 	encap->src_ip = match->value.enc_src_ip;
 	encap->dst_ip = match->value.enc_dst_ip;
 #ifdef CONFIG_IPV6
@@ -425,12 +469,56 @@ static int efx_tc_flower_record_encap_match(struct efx_nic *efx,
 #endif
 	encap->udp_dport = match->value.enc_dport;
 	encap->tun_type = type;
+	encap->ip_tos = match->value.enc_ip_tos;
+	encap->ip_tos_mask = match->mask.enc_ip_tos;
+	encap->child_ip_tos_mask = child_ip_tos_mask;
+	encap->type = em_type;
+	encap->pseudo = pseudo;
 	old = rhashtable_lookup_get_insert_fast(&efx->tc->encap_match_ht,
 						&encap->linkage,
 						efx_tc_encap_match_ht_params);
 	if (old) {
 		/* don't need our new entry */
 		kfree(encap);
+		if (pseudo) /* don't need our new pseudo either */
+			efx_tc_flower_release_encap_match(efx, pseudo);
+		/* check old and new em_types are compatible */
+		switch (old->type) {
+		case EFX_TC_EM_DIRECT:
+			/* old EM is in hardware, so mustn't overlap with a
+			 * pseudo, but may be shared with another direct EM
+			 */
+			if (em_type == EFX_TC_EM_DIRECT)
+				break;
+			NL_SET_ERR_MSG_MOD(extack, "Pseudo encap match conflicts with existing direct entry");
+			return -EEXIST;
+		case EFX_TC_EM_PSEUDO_MASK:
+			/* old EM is protecting a ToS-qualified filter, so may
+			 * only be shared with another pseudo for the same
+			 * ToS mask.
+			 */
+			if (em_type != EFX_TC_EM_PSEUDO_MASK) {
+				NL_SET_ERR_MSG_FMT_MOD(extack,
+						       "%s encap match conflicts with existing pseudo(MASK) entry",
+						       encap->type ? "Pseudo" : "Direct");
+				return -EEXIST;
+			}
+			if (child_ip_tos_mask != old->child_ip_tos_mask) {
+				NL_SET_ERR_MSG_FMT_MOD(extack,
+						       "Pseudo encap match for TOS mask %#04x conflicts with existing pseudo(MASK) entry for TOS mask %#04x",
+						       child_ip_tos_mask,
+						       old->child_ip_tos_mask);
+				return -EEXIST;
+			}
+			break;
+		default: /* Unrecognised pseudo-type.  Just say no */
+			NL_SET_ERR_MSG_FMT_MOD(extack,
+					       "%s encap match conflicts with existing pseudo(%d) entry",
+					       encap->type ? "Pseudo" : "Direct",
+					       old->type);
+			return -EEXIST;
+		}
+		/* check old and new tun_types are compatible */
 		if (old->tun_type != type) {
 			NL_SET_ERR_MSG_FMT_MOD(extack,
 					       "Egress encap match with conflicting tun_type %u != %u",
@@ -442,10 +530,12 @@ static int efx_tc_flower_record_encap_match(struct efx_nic *efx,
 		/* existing entry found */
 		encap = old;
 	} else {
-		rc = efx_mae_register_encap_match(efx, encap);
-		if (rc) {
-			NL_SET_ERR_MSG_MOD(extack, "Failed to record egress encap match in HW");
-			goto fail;
+		if (em_type == EFX_TC_EM_DIRECT) {
+			rc = efx_mae_register_encap_match(efx, encap);
+			if (rc) {
+				NL_SET_ERR_MSG_MOD(extack, "Failed to record egress encap match in HW");
+				goto fail;
+			}
 		}
 		refcount_set(&encap->ref, 1);
 	}
@@ -455,30 +545,12 @@ static int efx_tc_flower_record_encap_match(struct efx_nic *efx,
 	rhashtable_remove_fast(&efx->tc->encap_match_ht, &encap->linkage,
 			       efx_tc_encap_match_ht_params);
 	kfree(encap);
+fail_pseudo:
+	if (pseudo)
+		efx_tc_flower_release_encap_match(efx, pseudo);
 	return rc;
 }
 
-static void efx_tc_flower_release_encap_match(struct efx_nic *efx,
-					      struct efx_tc_encap_match *encap)
-{
-	int rc;
-
-	if (!refcount_dec_and_test(&encap->ref))
-		return; /* still in use */
-
-	rc = efx_mae_unregister_encap_match(efx, encap);
-	if (rc)
-		/* Display message but carry on and remove entry from our
-		 * SW tables, because there's not much we can do about it.
-		 */
-		netif_err(efx, drv, efx->net_dev,
-			  "Failed to release encap match %#x, rc %d\n",
-			  encap->fw_id, rc);
-	rhashtable_remove_fast(&efx->tc->encap_match_ht, &encap->linkage,
-			       efx_tc_encap_match_ht_params);
-	kfree(encap);
-}
-
 static void efx_tc_delete_rule(struct efx_nic *efx, struct efx_tc_flow_rule *rule)
 {
 	efx_mae_delete_rule(efx, rule->fw_id);
@@ -632,6 +704,7 @@ static int efx_tc_flower_replace_foreign(struct efx_nic *efx,
 		}
 
 		rc = efx_tc_flower_record_encap_match(efx, &match, type,
+						      EFX_TC_EM_DIRECT, 0,
 						      extack);
 		if (rc)
 			goto release;
diff --git a/drivers/net/ethernet/sfc/tc.h b/drivers/net/ethernet/sfc/tc.h
index 8d2abca26c23..0f14481d2d9e 100644
--- a/drivers/net/ethernet/sfc/tc.h
+++ b/drivers/net/ethernet/sfc/tc.h
@@ -74,6 +74,27 @@ static inline bool efx_tc_match_is_encap(const struct efx_tc_match_fields *mask)
 	       mask->enc_ip_ttl || mask->enc_sport || mask->enc_dport;
 }
 
+/**
+ * enum efx_tc_em_pseudo_type - &struct efx_tc_encap_match pseudo type
+ *
+ * These are used to classify "pseudo" encap matches, which don't refer
+ * to an entry in hardware but rather indicate that a section of the
+ * match space is in use by another Outer Rule.
+ *
+ * @EFX_TC_EM_DIRECT: real HW entry in Outer Rule table; not a pseudo.
+ *	Hardware index in &struct efx_tc_encap_match.fw_id is valid.
+ * @EFX_TC_EM_PSEUDO_MASK: registered by an encap match which includes a
+ *	match on an optional field (currently only ip_tos), to prevent an
+ *	overlapping encap match _without_ optional fields.
+ *	The pseudo encap match may be referenced again by an encap match
+ *	with a different ip_tos value, but all ip_tos_mask must match the
+ *	first (stored in our child_ip_tos_mask).
+ */
+enum efx_tc_em_pseudo_type {
+	EFX_TC_EM_DIRECT,
+	EFX_TC_EM_PSEUDO_MASK,
+};
+
 struct efx_tc_encap_match {
 	__be32 src_ip, dst_ip;
 	struct in6_addr src_ip6, dst_ip6;
@@ -81,8 +102,11 @@ struct efx_tc_encap_match {
 	u8 ip_tos, ip_tos_mask;
 	struct rhash_head linkage;
 	enum efx_encap_type tun_type;
+	u8 child_ip_tos_mask;
 	refcount_t ref;
+	enum efx_tc_em_pseudo_type type;
 	u32 fw_id; /* index of this entry in firmware encap match table */
+	struct efx_tc_encap_match *pseudo; /* Referenced pseudo EM if needed */
 };
 
 struct efx_tc_match {

