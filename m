Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 429CC6C71D7
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 21:48:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231615AbjCWUr6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 16:47:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231535AbjCWUry (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 16:47:54 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2088.outbound.protection.outlook.com [40.107.220.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9D3A31BCE
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 13:47:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LhPikW5gi544qwefizBupRmFqKnzYyh99iKDJpLi4SV76Bo7ZEbXcm0Dd2t9B0e6ptjIEZQKVgyyWYbtGx8WGD+DnX4vfQBNIZo3P62w60d5NWAjLdJIk4PTWto4OhSOguiP3X7laDvJoXCw0kPMVnmOw0LkFs05AT6697oko/H9DUhl0h7dVmVkLOsPdG0EgZFV0PHj2BB3cSqmn8TVtAIaJLcaKpSXTsxGSja2IWIZBVNaAxrn+knz3O+MekDly9ADpB7/iPOjKRCezK4hwPTCIlN6lS37mWjx5vNCpTR36o8nOI4Mf7gZLOMsR28rcGIiTb4I77RrrjvnDm9jyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iGaF4HHd8kySwJA50iHlG4fJkkmoTMtXg4UGJ20oBlY=;
 b=Ezy34TXPz3AYU1Hw6nPgaHqQRwvg9A9e0nUHVQGtc3mn6xgQd8/8SSe9/cLPfNoY0gGSZECqeo6oEfI4D3KsUBrNmhH5fz25N6w9QDy0VnaZjlY6inhR+I+tylWdg98p2Obe0jHpse01HcG5j2495FJlojIJm8mi6cBmyI8ELJkchoXUgYhdo8BTebqpw8goPfzBVLglMZJTAF6U1oayutrdApx/7cTt25OtOBzBgozyyHdZ94VFOmcHFXNjZ74eGbCHZ7v8ECY1ohfPoBMwrSsijh91oaikWW6tBhHjRdvRJR2rUPhEsz/XPsvhKsoR06VougZJJ7BiuIfh7Ks4ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iGaF4HHd8kySwJA50iHlG4fJkkmoTMtXg4UGJ20oBlY=;
 b=u1nrbe7g4LwRrpLT7Xb0T3/cZRU6FiNPJbBHPhqE45IBEqw5h6uI1citjIBpINPQT9dCXEa+dTIeuhNfl9qBp2d50PA4fXIqCdNZ/jwU9tA3CIrkVBoOzoxxW+8wmcb7CY/qEFt4gi1qlciJLM1Hch+NoxBRwQAfqzuKCiRZOsI=
Received: from BN0PR10CA0003.namprd10.prod.outlook.com (2603:10b6:408:143::35)
 by DS0PR12MB8787.namprd12.prod.outlook.com (2603:10b6:8:14e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Thu, 23 Mar
 2023 20:47:41 +0000
Received: from BN8NAM11FT034.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:143:cafe::71) by BN0PR10CA0003.outlook.office365.com
 (2603:10b6:408:143::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38 via Frontend
 Transport; Thu, 23 Mar 2023 20:47:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT034.mail.protection.outlook.com (10.13.176.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6222.22 via Frontend Transport; Thu, 23 Mar 2023 20:47:41 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 23 Mar
 2023 15:47:40 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 23 Mar
 2023 15:47:40 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34 via Frontend
 Transport; Thu, 23 Mar 2023 15:47:39 -0500
From:   <edward.cree@amd.com>
To:     <linux-net-drivers@amd.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@google.com>
CC:     Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>,
        <habetsm.xilinx@gmail.com>, <michal.swiatkowski@linux.intel.com>
Subject: [PATCH net-next v2 5/6] sfc: add code to register and unregister encap matches
Date:   Thu, 23 Mar 2023 20:45:13 +0000
Message-ID: <57c4e599df3fff7bf678c1813445bd6016c6db79.1679603051.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1679603051.git.ecree.xilinx@gmail.com>
References: <cover.1679603051.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT034:EE_|DS0PR12MB8787:EE_
X-MS-Office365-Filtering-Correlation-Id: 951877f3-a5a8-4209-6462-08db2bdfd87d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XRmracvtDyVXUCJyk5AsM8iTsoFoRNyLERGnUfWH0R7ENv9dfVgkuBsKRb5coSgwFVOotIWlMUgOJ1E5C418lGHZ9ooss2D5jL+yaqKfTc15g8et58KJmnWo+zFeAKXEtKzuZoLh1IRaT5/K0P/xSqfNINnTrJNxf0BOS1j7P8Dk1icsO1FtZPw7LqzFLnSsrDRbu3vc/PX8Ff1aw/V120qk50cjvmY+r9mpcO4imHSB92kxplSXJNQ09+b8bL3BoP9YPaNBFpzTyAZW3blDmf5o39pgEF74NwbjDFJlPUcpreQcoKMQgMuZ0iWOAuJMUlwrn4UrPetbxqz4FlSwl78Vq2r73QePrwXocEiclP5SRjBxsTsAxlBoiWSSfZDIyOmg0fx4ScP9cP0CS5bx8C3/+muSB9yUkLIFJ0kncS1X5UuAswkWMmJHXB4IoKeuoVcAx+9pLRjPcGRRBnj9s07ykwZRjSM0cM/UbMOdxquku91Wq4PUszFQdO4WoRwUKAVLGPo8jo08IKhV/T59nY3xtrpaHlT0ISv4hkJOKtRnjEm3vHuitfkRpgIpPz08uPjRcCT1At0tfRkGougQcW0KtLIouR3qW11Z+tKm7Ldrxtfp+5h8n3WnfzuS4NS6rWKWuHf/qLtMdH9KcdYZ5iuFd8ep+DIIKRnRWGFGP8XoW69dooNOBpgCyzph93JjbJlaa0n1eCaejdg5DBKJ4gFRWRz1OqkgwMlZt/TYvrxfNR04N1zC5UM0ke6vJcOCMp7lQ4tz8oMEm7gYbX9SPw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(136003)(376002)(396003)(346002)(451199018)(40470700004)(36840700001)(46966006)(40460700003)(36860700001)(43170500006)(5660300002)(70586007)(8676002)(4326008)(70206006)(54906003)(81166007)(41300700001)(82740400003)(316002)(8936002)(47076005)(6666004)(426003)(26005)(9686003)(186003)(478600001)(83380400001)(336012)(110136005)(86362001)(82310400005)(55446002)(36756003)(40480700001)(2876002)(2906002)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2023 20:47:41.2386
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 951877f3-a5a8-4209-6462-08db2bdfd87d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT034.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8787
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
Changed in v2: replace `unsigned char ipv` with `bool ipv6`, simplifying
 code (suggested by Michal)
---
 drivers/net/ethernet/sfc/tc.c | 163 ++++++++++++++++++++++++++++++++++
 drivers/net/ethernet/sfc/tc.h |  11 +++
 2 files changed, 174 insertions(+)

diff --git a/drivers/net/ethernet/sfc/tc.c b/drivers/net/ethernet/sfc/tc.c
index 21eb79b20978..f18ac2a7697a 100644
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
+	bool ipv6;
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
index 19782c9a4354..d70c0ba86669 100644
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
 	u16 tun_type; /* enum efx_encap_type */
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
