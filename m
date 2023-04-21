Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B84666EACB6
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 16:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232476AbjDUOVP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 10:21:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231936AbjDUOVK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 10:21:10 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2083.outbound.protection.outlook.com [40.107.243.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BD3A13864
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 07:20:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xjy8hD/2cvIied3mbCMiny+poaCJIMDyi/AZhal/qc4EwszNYA9DsdnPxCjCWcZ01kaiwcMJla0joPKSkSM3PR47dZK1eMPwBywsa1VMj5ORYo2T9bok9qzldrENkFrmLjgINxQs4Q5pZdH7lwlOeg1lxlfBZDEsIYOjEQg7sp88qemuORFOucp/0lqlz8v1tJnbJbsfMOPm3CtVSo0HvIo+HvqVADQ+20VwFeN+Rae30R7u29S5gQXSS0H3LGPRxCaY49jhJj2eUO/NveXNl00voD0S+AKkOz41wTgjAHQfSAU90U5o8xdxjCXBn89I7AUG7DHWbQqHws/NIkkKXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7O8Po+om7lcdCUVxMsrmqeQURMsD8b5sBvru0vtdgwQ=;
 b=VLuuMPRaSFSCW4guISUBYTPIxQ2vxuEyA+uZvf8H30UcLsrecOMBY+mKbHQdBgbTJkKFdvY0YkHJeFPSKId0Thwnpx/AgRTAqThtSACHUeeP5PEZ/XJnO6RNr5S6sMr34e4Ykr5p0/E5RJsZsgmaYspxKyTogxQAAQsCvm7xjlGmNOSlsggFr7o0mFGOeNA9I+80s/nVN1tKmJJT5EcF3xy/acJ50Ja7IBCseUT5IYOFleT9e4v6xrm84sSclwObCmivtnuVJWXu8yKSleugEuj7owQtTinMXUP9E3cBMXvZ8MTqLDQWK7/A2/0xl6AVy1CEdL9GTyP/sbs2uICBng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7O8Po+om7lcdCUVxMsrmqeQURMsD8b5sBvru0vtdgwQ=;
 b=PsDH2wxMn5EG05AxK2j5Cu6JLrP54IMxxZL5jEqgrCdxL8mjRnxRofU5VXYvk4sZvSubqSIm3PetYDqqyEqcvfXnGliFAqOS43ye33akTZhGprpr5hm+Kb1W+mWQBlhQYGxkCCEjnFrtNEvtRLIPjj9Qyi1DsTV8dBSbOQ33C8w=
Received: from BN8PR04CA0062.namprd04.prod.outlook.com (2603:10b6:408:d4::36)
 by MN2PR12MB4550.namprd12.prod.outlook.com (2603:10b6:208:24e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Fri, 21 Apr
 2023 14:20:54 +0000
Received: from BN8NAM11FT036.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:d4:cafe::43) by BN8PR04CA0062.outlook.office365.com
 (2603:10b6:408:d4::36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.25 via Frontend
 Transport; Fri, 21 Apr 2023 14:20:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT036.mail.protection.outlook.com (10.13.177.168) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6319.27 via Frontend Transport; Fri, 21 Apr 2023 14:20:54 +0000
Received: from SATLEXMB07.amd.com (10.181.41.45) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 21 Apr
 2023 09:20:52 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB07.amd.com
 (10.181.41.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 21 Apr
 2023 07:20:51 -0700
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34 via Frontend
 Transport; Fri, 21 Apr 2023 09:20:50 -0500
From:   <edward.cree@amd.com>
To:     <linux-net-drivers@amd.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@google.com>
CC:     Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>,
        <habetsm.xilinx@gmail.com>,
        Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
Subject: [PATCH net-next 3/4] sfc: support TC decap rules matching on enc_ip_tos
Date:   Fri, 21 Apr 2023 15:19:53 +0100
Message-ID: <a95d2c95ca00a4986123ca1a46d263c312590594.1682086533.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1682086533.git.ecree.xilinx@gmail.com>
References: <cover.1682086533.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT036:EE_|MN2PR12MB4550:EE_
X-MS-Office365-Filtering-Correlation-Id: b8522769-c392-4398-c84a-08db42739e0d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kZJE//ZOz/OPgyvnJqebqkGwJB0S1N9VJFG9vYNjCaTr10O8HddvjslfDtPBImUIYqHNxrms4uJEB9gvgyIm6APbqHspUAtin2lp4TbzVJH0bQMo8MwTRowRfqJ4JDT/Y9YH4asN1qV+10HJQO1ay1gvUSnCtLsIRif/A84auFmHf7fRL2aZw8HeHs8wMYjbkf3FQ5X4UgTdV29IPlRsYeuourzCm4ERoSORpigXcDFlimi/0lRxYZIazLwKSH0InghgZh/WyV6oyN/SV5I6I3QtRQjm9JIi9Fzs12sRKLB0RQHQzC8AuP7e4Z43/vDL0EY99L16iGhcvOb9lSkkrA9cUD97g8sn7ELyF3JjZizogGQGro9pNZZGUmTkeC53WPYnsRXqcM6e6OUWCcnHFTGU3zujHY60KKvXWHP2/SDF8qRMIpEZ77SiYoghIhX2ol45bGxidHXPT1AYr7+E0wh5Z9L6jdH4FXyHVfaWKCND9PZeOJ+1tipSFjDtQGWtHgkfNGDbw0E173zcHE7UqmDsB/57YuRHXuqfz++NrMXT3cWR4+w5w7UoX5ZJvf77b8mFXPH8WH3fpMnLMVW452RZ96S6Sh0ozxLRLaHe/yHojfpkSBxWL1MtPNMxetXqn10GPTncJC5l/hhrIgPkYa0Rx7+jIbTmjIrH+jc5Cl3pe7i0WkYg0cVZHQ97ULFwxTK032tDXuHmae6hBPMNg6CpUT5HSwey5Ba5qHYELkc=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(39860400002)(346002)(396003)(451199021)(36840700001)(40470700004)(46966006)(54906003)(110136005)(83380400001)(478600001)(36860700001)(40480700001)(26005)(41300700001)(356005)(82740400003)(81166007)(9686003)(47076005)(336012)(426003)(316002)(70586007)(70206006)(4326008)(186003)(2906002)(5660300002)(8676002)(2876002)(8936002)(40460700003)(82310400005)(55446002)(86362001)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2023 14:20:54.2964
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b8522769-c392-4398-c84a-08db42739e0d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT036.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4550
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

Reviewed-by: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/tc.c | 145 +++++++++++++++++++++++++---------
 drivers/net/ethernet/sfc/tc.h |  25 ++++++
 2 files changed, 134 insertions(+), 36 deletions(-)

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
index 04cced6a2d39..0f14481d2d9e 100644
--- a/drivers/net/ethernet/sfc/tc.h
+++ b/drivers/net/ethernet/sfc/tc.h
@@ -74,14 +74,39 @@ static inline bool efx_tc_match_is_encap(const struct efx_tc_match_fields *mask)
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
 	__be16 udp_dport;
+	u8 ip_tos, ip_tos_mask;
 	struct rhash_head linkage;
 	enum efx_encap_type tun_type;
+	u8 child_ip_tos_mask;
 	refcount_t ref;
+	enum efx_tc_em_pseudo_type type;
 	u32 fw_id; /* index of this entry in firmware encap match table */
+	struct efx_tc_encap_match *pseudo; /* Referenced pseudo EM if needed */
 };
 
 struct efx_tc_match {
