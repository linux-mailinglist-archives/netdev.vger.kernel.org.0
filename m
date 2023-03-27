Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEB446CA18F
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 12:37:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233705AbjC0Khv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 06:37:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233700AbjC0Khh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 06:37:37 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2082.outbound.protection.outlook.com [40.107.94.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DB332D40
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 03:37:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zx9qLq4yzddm2xDUcdw+rRP4oQxuW3bzVwzA9jIirzDxuT8p+SB+StpWW8hC4s8hhw7ItL9kl2j7k+dAsGJrwOgAnD1Ckju/7+3ZqIAI4fcwdqvcTI4vWNK/RxW4walLTTrwrpUcqREiVEfUCbj034hnTroM/JgZb2QcrU5HbtP/khrGyHS9VQdDb4E/UBvhfhPOnUGCpPfKILZsN13cnWeIC7ZoiX3ppqJJ13nz7iXu5L+HdIBxXyD4rlcAfoyYinqOHhFJTdvaK20OnhGHSS6lZShhJod07HdtyK898Hb185e/LbTDDQP0/TODx+PH2/4lwbTxtW94rOwMc7TZxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gcIU5H8xwkCHZ9FJTLBGeqw0Os4Ij7183W6nsZOlvQ8=;
 b=CF8RTtc53SX5uSzNrmXBiwNORusTira4q7enI1FHiFxB00xJe8KePjlWOeeFOTn41CnTk1cq0krLTcyA7mncTADPNxcPF/YlBSaQiWUc7sT0oEU7+a127pS27xhAjnZeLkIi+N4GoFNiMM2bjoEq+o0qRKT9OFd035uYKOBvLjdbZsxAcVedntXa8unC3qciEaYZVZn4P2t7Ru3DVKaKzDA7DPJHhvSL60pPMF5WHABvf3rDWJUJYBU9U+pGbnAc0A6R+qkM7k9GpwmOEXyN/U02bM4HlTiVwT3U5uZxzW5Lz+zxC89BCEapqBIzn9Y2MuBVpSjuqVG0w0oFEMBHZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gcIU5H8xwkCHZ9FJTLBGeqw0Os4Ij7183W6nsZOlvQ8=;
 b=lXT5NKthhZB3U/glmCDYYpmTgRnMTQwe2NvAJ7oPAibOSylcKFWCflf5Wtp+VTea03kDpv/4spKQtuvFr2IVwOMSAStGj4pwU50WdAPt1YbN/oFUN2WkQ/kPlnpjWo/TdLYOItB89Ev6ioaSvkr/THTf5fP5SRJt4rDkr+NZ1eQ=
Received: from BN9PR03CA0448.namprd03.prod.outlook.com (2603:10b6:408:113::33)
 by PH7PR12MB6396.namprd12.prod.outlook.com (2603:10b6:510:1fc::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.30; Mon, 27 Mar
 2023 10:37:26 +0000
Received: from BN8NAM11FT086.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:113:cafe::cf) by BN9PR03CA0448.outlook.office365.com
 (2603:10b6:408:113::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41 via Frontend
 Transport; Mon, 27 Mar 2023 10:37:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT086.mail.protection.outlook.com (10.13.176.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6222.17 via Frontend Transport; Mon, 27 Mar 2023 10:37:25 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 27 Mar
 2023 05:37:17 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 27 Mar
 2023 05:37:16 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34 via Frontend
 Transport; Mon, 27 Mar 2023 05:37:15 -0500
From:   <edward.cree@amd.com>
To:     <linux-net-drivers@amd.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@google.com>
CC:     Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>,
        <habetsm.xilinx@gmail.com>, <michal.swiatkowski@linux.intel.com>,
        <simon.horman@corigine.com>
Subject: [PATCH net-next v3 5/6] sfc: add code to register and unregister encap matches
Date:   Mon, 27 Mar 2023 11:36:07 +0100
Message-ID: <c232d6577a7beba24884cf4b05c3defe2b128636.1679912088.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1679912088.git.ecree.xilinx@gmail.com>
References: <cover.1679912088.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT086:EE_|PH7PR12MB6396:EE_
X-MS-Office365-Filtering-Correlation-Id: 926212a4-6adb-4315-adb8-08db2eaf41b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Tv1YHSQFUO/GeQVtkCnq/MAphNXT8wXVto7WiUG34kS5pFJVw4jIRVCQr5YOVq6WFfb6BN9NFXCM/UGz9QdERWLK2U7qEyoNgh1ep803JTcEs1ojln7E6XUxgL3wg6ZSpPtc3K20I/9QX6XY3BU4V+TlyxQZZ7ssK0VAIYA95oRabYCTDnQgZPOLPoDB5TKHBjcKI9jGPQuCzDxUwdkeO1VOk32yY+V8YmSq0XKRO6W3gkh2ZUQddXof4Wd7990q2zs75mnC4X+mLiM5kVWF+Ce+pRn/Z+Qhu4SOivi03LyE0B1E4FI89AIFQNyMixW5EYdiKZuBlPYJnDYr+3wFX6sIuwNNgPJFJxMbkjpyPJ92GI2YK/ls8JMTfJ+MD7T0mZd3Hb2Dyli99L+YO1u/fQCzpD99VfE6/co8q1iGp3XGC3MPPs8JJDn8avQpF/Zv0IuoXESxP9b4H7f5Bd1B6zWrgBOH/FKfeTtevMWVf9lw5CQAbdWEPJ7xX4rVC0T9Q7ACx7SVqUSwMnDZ8AiP43acd13aeK1tmhPmQ6/vhDx6Sel6VEwCZ8U1m2bIlUfyAGSNs74GVHu510E9T2jd5kuF8k9cR6yFq6Az+f5Y47wKkraGcyVDa3nNZifHPE88S5efdxYNGQEu+nBeVLOy9fDcG8bc6d4gfxbb76f4733E/PGPpmYMI/tM5M1v/Cm0w9rK9IJccBLMymTDFU9nXmSVq7sjpnFo5WdB94CILxnZQJG3ZR0ouqBXncIqaglfwHtaTdZulJbjsDVTTcOhSA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(346002)(136003)(39860400002)(451199021)(46966006)(40470700004)(36840700001)(110136005)(316002)(40460700003)(36860700001)(54906003)(478600001)(356005)(81166007)(82740400003)(8936002)(5660300002)(36756003)(55446002)(86362001)(82310400005)(2906002)(2876002)(4326008)(8676002)(70206006)(70586007)(41300700001)(40480700001)(6666004)(186003)(9686003)(26005)(426003)(336012)(43170500006)(83380400001)(47076005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2023 10:37:25.9299
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 926212a4-6adb-4315-adb8-08db2eaf41b7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT086.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6396
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree.xilinx@gmail.com>

Add a hashtable to detect duplicate and conflicting matches.  If match
 is not a duplicate, call MAE functions to add/remove it from OR table.
Calling code not added yet, so mark the new functions as unused.

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
Changed in v3: initialise `ipv6` variable (Jakub, kernel test robot)
Changed in v2: replace `unsigned char ipv` with `bool ipv6`, simplifying
 code (suggested by Michal)
---
 drivers/net/ethernet/sfc/tc.c | 163 ++++++++++++++++++++++++++++++++++
 drivers/net/ethernet/sfc/tc.h |  11 +++
 2 files changed, 174 insertions(+)

diff --git a/drivers/net/ethernet/sfc/tc.c b/drivers/net/ethernet/sfc/tc.c
index 21eb79b20978..69d3ee5d23d1 100644
--- a/drivers/net/ethernet/sfc/tc.c
+++ b/drivers/net/ethernet/sfc/tc.c
@@ -57,6 +57,12 @@ static s64 efx_tc_flower_external_mport(struct efx_nic *efx, struct efx_rep *efv
 	return mport;
 }
 
+static const struct rhashtable_params efx_tc_encap_match_ht_params = {
+	.key_len	= offsetof(struct efx_tc_encap_match, linkage),
+	.key_offset	= 0,
+	.head_offset	= offsetof(struct efx_tc_encap_match, linkage),
+};
+
 static const struct rhashtable_params efx_tc_match_action_ht_params = {
 	.key_len	= sizeof(unsigned long),
 	.key_offset	= offsetof(struct efx_tc_flow_rule, cookie),
@@ -340,6 +346,144 @@ static int efx_tc_flower_parse_match(struct efx_nic *efx,
 	return 0;
 }
 
+__always_unused
+static int efx_tc_flower_record_encap_match(struct efx_nic *efx,
+					    struct efx_tc_match *match,
+					    enum efx_encap_type type,
+					    struct netlink_ext_ack *extack)
+{
+	struct efx_tc_encap_match *encap, *old;
+	bool ipv6 = false;
+	int rc;
+
+	/* We require that the socket-defining fields (IP addrs and UDP dest
+	 * port) are present and exact-match.  Other fields are currently not
+	 * allowed.  This meets what OVS will ask for, and means that we don't
+	 * need to handle difficult checks for overlapping matches as could
+	 * come up if we allowed masks or varying sets of match fields.
+	 */
+	if (match->mask.enc_dst_ip | match->mask.enc_src_ip) {
+		if (!IS_ALL_ONES(match->mask.enc_dst_ip)) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Egress encap match is not exact on dst IP address");
+			return -EOPNOTSUPP;
+		}
+		if (!IS_ALL_ONES(match->mask.enc_src_ip)) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Egress encap match is not exact on src IP address");
+			return -EOPNOTSUPP;
+		}
+#ifdef CONFIG_IPV6
+		if (!ipv6_addr_any(&match->mask.enc_dst_ip6) ||
+		    !ipv6_addr_any(&match->mask.enc_src_ip6)) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Egress encap match on both IPv4 and IPv6, don't understand");
+			return -EOPNOTSUPP;
+		}
+	} else {
+		ipv6 = true;
+		if (!efx_ipv6_addr_all_ones(&match->mask.enc_dst_ip6)) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Egress encap match is not exact on dst IP address");
+			return -EOPNOTSUPP;
+		}
+		if (!efx_ipv6_addr_all_ones(&match->mask.enc_src_ip6)) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Egress encap match is not exact on src IP address");
+			return -EOPNOTSUPP;
+		}
+#endif
+	}
+	if (!IS_ALL_ONES(match->mask.enc_dport)) {
+		NL_SET_ERR_MSG_MOD(extack, "Egress encap match is not exact on dst UDP port");
+		return -EOPNOTSUPP;
+	}
+	if (match->mask.enc_sport) {
+		NL_SET_ERR_MSG_MOD(extack, "Egress encap match on src UDP port not supported");
+		return -EOPNOTSUPP;
+	}
+	if (match->mask.enc_ip_tos) {
+		NL_SET_ERR_MSG_MOD(extack, "Egress encap match on IP ToS not supported");
+		return -EOPNOTSUPP;
+	}
+	if (match->mask.enc_ip_ttl) {
+		NL_SET_ERR_MSG_MOD(extack, "Egress encap match on IP TTL not supported");
+		return -EOPNOTSUPP;
+	}
+
+	rc = efx_mae_check_encap_match_caps(efx, ipv6, extack);
+	if (rc) {
+		NL_SET_ERR_MSG_FMT_MOD(extack, "MAE hw reports no support for IPv%d encap matches",
+				       ipv6 ? 6 : 4);
+		return -EOPNOTSUPP;
+	}
+
+	encap = kzalloc(sizeof(*encap), GFP_USER);
+	if (!encap)
+		return -ENOMEM;
+	encap->src_ip = match->value.enc_src_ip;
+	encap->dst_ip = match->value.enc_dst_ip;
+#ifdef CONFIG_IPV6
+	encap->src_ip6 = match->value.enc_src_ip6;
+	encap->dst_ip6 = match->value.enc_dst_ip6;
+#endif
+	encap->udp_dport = match->value.enc_dport;
+	encap->tun_type = type;
+	old = rhashtable_lookup_get_insert_fast(&efx->tc->encap_match_ht,
+						&encap->linkage,
+						efx_tc_encap_match_ht_params);
+	if (old) {
+		/* don't need our new entry */
+		kfree(encap);
+		if (old->tun_type != type) {
+			NL_SET_ERR_MSG_FMT_MOD(extack,
+					       "Egress encap match with conflicting tun_type %u != %u",
+					       old->tun_type, type);
+			return -EEXIST;
+		}
+		if (!refcount_inc_not_zero(&old->ref))
+			return -EAGAIN;
+		/* existing entry found */
+		encap = old;
+	} else {
+		rc = efx_mae_register_encap_match(efx, encap);
+		if (rc) {
+			NL_SET_ERR_MSG_MOD(extack, "Failed to record egress encap match in HW");
+			goto fail;
+		}
+		refcount_set(&encap->ref, 1);
+	}
+	match->encap = encap;
+	return 0;
+fail:
+	rhashtable_remove_fast(&efx->tc->encap_match_ht, &encap->linkage,
+			       efx_tc_encap_match_ht_params);
+	kfree(encap);
+	return rc;
+}
+
+__always_unused
+static void efx_tc_flower_release_encap_match(struct efx_nic *efx,
+					      struct efx_tc_encap_match *encap)
+{
+	int rc;
+
+	if (!refcount_dec_and_test(&encap->ref))
+		return; /* still in use */
+
+	rc = efx_mae_unregister_encap_match(efx, encap);
+	if (rc)
+		/* Display message but carry on and remove entry from our
+		 * SW tables, because there's not much we can do about it.
+		 */
+		netif_err(efx, drv, efx->net_dev,
+			  "Failed to release encap match %#x, rc %d\n",
+			  encap->fw_id, rc);
+	rhashtable_remove_fast(&efx->tc->encap_match_ht, &encap->linkage,
+			       efx_tc_encap_match_ht_params);
+	kfree(encap);
+}
+
 /* For details of action order constraints refer to SF-123102-TC-1§12.6.1 */
 enum efx_tc_action_order {
 	EFX_TC_AO_VLAN_POP,
@@ -974,6 +1118,18 @@ void efx_fini_tc(struct efx_nic *efx)
 	efx->tc->up = false;
 }
 
+/* At teardown time, all TC filter rules (and thus all resources they created)
+ * should already have been removed.  If we find any in our hashtables, make a
+ * cursory attempt to clean up the software side.
+ */
+static void efx_tc_encap_match_free(void *ptr, void *__unused)
+{
+	struct efx_tc_encap_match *encap = ptr;
+
+	WARN_ON(refcount_read(&encap->ref));
+	kfree(encap);
+}
+
 int efx_init_struct_tc(struct efx_nic *efx)
 {
 	int rc;
@@ -996,6 +1152,9 @@ int efx_init_struct_tc(struct efx_nic *efx)
 	rc = efx_tc_init_counters(efx);
 	if (rc < 0)
 		goto fail_counters;
+	rc = rhashtable_init(&efx->tc->encap_match_ht, &efx_tc_encap_match_ht_params);
+	if (rc < 0)
+		goto fail_encap_match_ht;
 	rc = rhashtable_init(&efx->tc->match_action_ht, &efx_tc_match_action_ht_params);
 	if (rc < 0)
 		goto fail_match_action_ht;
@@ -1008,6 +1167,8 @@ int efx_init_struct_tc(struct efx_nic *efx)
 	efx->extra_channel_type[EFX_EXTRA_CHANNEL_TC] = &efx_tc_channel_type;
 	return 0;
 fail_match_action_ht:
+	rhashtable_destroy(&efx->tc->encap_match_ht);
+fail_encap_match_ht:
 	efx_tc_destroy_counters(efx);
 fail_counters:
 	mutex_destroy(&efx->tc->mutex);
@@ -1030,6 +1191,8 @@ void efx_fini_struct_tc(struct efx_nic *efx)
 			     MC_CMD_MAE_ACTION_RULE_INSERT_OUT_ACTION_RULE_ID_NULL);
 	rhashtable_free_and_destroy(&efx->tc->match_action_ht, efx_tc_flow_free,
 				    efx);
+	rhashtable_free_and_destroy(&efx->tc->encap_match_ht,
+				    efx_tc_encap_match_free, NULL);
 	efx_tc_fini_counters(efx);
 	mutex_unlock(&efx->tc->mutex);
 	mutex_destroy(&efx->tc->mutex);
diff --git a/drivers/net/ethernet/sfc/tc.h b/drivers/net/ethernet/sfc/tc.h
index fff73960698a..7d06c5031b56 100644
--- a/drivers/net/ethernet/sfc/tc.h
+++ b/drivers/net/ethernet/sfc/tc.h
@@ -18,6 +18,13 @@
 
 #define IS_ALL_ONES(v)	(!(typeof (v))~(v))
 
+#ifdef CONFIG_IPV6
+static inline bool efx_ipv6_addr_all_ones(struct in6_addr *addr)
+{
+	return !memchr_inv(addr, 0xff, sizeof(*addr));
+}
+#endif
+
 struct efx_tc_action_set {
 	u16 vlan_push:2;
 	u16 vlan_pop:2;
@@ -70,7 +77,9 @@ struct efx_tc_encap_match {
 	__be32 src_ip, dst_ip;
 	struct in6_addr src_ip6, dst_ip6;
 	__be16 udp_dport;
+	struct rhash_head linkage;
 	enum efx_encap_type tun_type;
+	refcount_t ref;
 	u32 fw_id; /* index of this entry in firmware encap match table */
 };
 
@@ -107,6 +116,7 @@ enum efx_tc_rule_prios {
  * @mutex: Used to serialise operations on TC hashtables
  * @counter_ht: Hashtable of TC counters (FW IDs and counter values)
  * @counter_id_ht: Hashtable mapping TC counter cookies to counters
+ * @encap_match_ht: Hashtable of TC encap matches
  * @match_action_ht: Hashtable of TC match-action rules
  * @reps_mport_id: MAE port allocated for representor RX
  * @reps_filter_uc: VNIC filter for representor unicast RX (promisc)
@@ -130,6 +140,7 @@ struct efx_tc_state {
 	struct mutex mutex;
 	struct rhashtable counter_ht;
 	struct rhashtable counter_id_ht;
+	struct rhashtable encap_match_ht;
 	struct rhashtable match_action_ht;
 	u32 reps_mport_id, reps_mport_vport_id;
 	s32 reps_filter_uc, reps_filter_mc;
