Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E41EB6CA18C
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 12:37:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233673AbjC0Kh3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 06:37:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233665AbjC0KhV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 06:37:21 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2056.outbound.protection.outlook.com [40.107.92.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3D9C2727
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 03:37:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W6QfIZLkhOgP1MBa7CXQ6KsUuOxNBovREdp7gWLjbOcK0nWl9d219NP/bwt3GCOh2RoJOXH24VyDhI+KBPuvrC9wL61VbfS4KX/TnXwcoYmXU000O/i4gc2nPIMBaE8CS96R/4loZQh2BoZjzQBktJI/kEVm0QJl6Po/WQUBaZEckJAJB2vGCf8F270deaJLCP5dkPE2oQCL7vQnlVx+8rIkwEXrrCQ73Q0IE4i+T2chBX4a/EM02vYM/iNRSWyWgr7YQtr2r08P90l0vX2TtCtjBfqlHjI3qkRyrlNTUy2XbMfWiy9e4wRBaEOt3KXz58ADA3mCC4s3+MVl5JUp0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TlT8XzWY1IbNqC6p03g2kuHcxGIgOVm/OXsfB0sYca0=;
 b=R/ABO0YQ7hQxvPoX+MYzAWJX7k5YdCJ5aAKfvCDFCqw2WYiqawWJQ7frzNW2bpt9ZgzFE8F5X1hZXPaUgkuzRLN/E6RdxqjqcsY9zTjQ+lMue+FQ2OCCNlA6GJkoS5Hvjt08OZqgQ6V6aGnBBb4WE4LPyJqaE6DtqZe9TWx9YnJOkgdc5sL1TkloxBp1pMsIFtUgT2brR5CNqp6b9WSHypvrm+R4pa0g2I2SASqWsA8Yzl4kqhZjHMjoxszhTsxCs07bV1XOAa1SxNcWP6Yz0NrPGcbusUlS1bwEeDa72uwWjzh2Mj3KOALRlvL6Rdzq6qtqeEwwSECn8j0BugEe/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TlT8XzWY1IbNqC6p03g2kuHcxGIgOVm/OXsfB0sYca0=;
 b=Yoj3eJlyjGzULUVCMEvO3jNDV5iHV5luljgUsgS1IuMbUyPxHpdMa+9xf2wGnbKw4WnB+yFKhQ0bc8M7KRAh1QjVwV04i3c+5GiyCgLAd/GHjSSj1y8WeOMXxn7oWY8kvzddGjRiasBUmWDPncjIyEdEhlcoCHC+ks8mJ+j8LPU=
Received: from BN9PR03CA0572.namprd03.prod.outlook.com (2603:10b6:408:10d::7)
 by DS0PR12MB6534.namprd12.prod.outlook.com (2603:10b6:8:c1::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.30; Mon, 27 Mar
 2023 10:37:16 +0000
Received: from BL02EPF000100D0.namprd05.prod.outlook.com
 (2603:10b6:408:10d:cafe::76) by BN9PR03CA0572.outlook.office365.com
 (2603:10b6:408:10d::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41 via Frontend
 Transport; Mon, 27 Mar 2023 10:37:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BL02EPF000100D0.mail.protection.outlook.com (10.167.241.204) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6178.30 via Frontend Transport; Mon, 27 Mar 2023 10:37:16 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 27 Mar
 2023 05:37:15 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34 via Frontend
 Transport; Mon, 27 Mar 2023 05:37:13 -0500
From:   <edward.cree@amd.com>
To:     <linux-net-drivers@amd.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@google.com>
CC:     Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>,
        <habetsm.xilinx@gmail.com>, <michal.swiatkowski@linux.intel.com>,
        <simon.horman@corigine.com>
Subject: [PATCH net-next v3 4/6] sfc: add functions to insert encap matches into the MAE
Date:   Mon, 27 Mar 2023 11:36:06 +0100
Message-ID: <88f67546ea63c9695e7c228d06d0f129dd383530.1679912088.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1679912088.git.ecree.xilinx@gmail.com>
References: <cover.1679912088.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF000100D0:EE_|DS0PR12MB6534:EE_
X-MS-Office365-Filtering-Correlation-Id: 890839ea-cc86-4734-f91e-08db2eaf3bd9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3FayBBEKmi/D2BjPzMTUkdap7TI5kFJwVj5NMy9loZTKKK4srtS6B3C59jCvheiMeHaduipa4Gi53ZmlEso/KBgTxCH92IPfE+d6p0d5EXdTHngfM4FGXAse+VAzCwo8MUMt9SzB099x+Vg9JW106j87rEju8KhxmImz181n4T8Xs+KCl91mSdiwm2wCz+9JH3/H2Je6dNDCZq6m8wOjwuMLaMUrBs98lQbZ0SyJkXenEEua0PcQZOOokP/ss/DwzrtEAqfWVv+YPnnJWi55UaeG8DS5HYscoN/0nVU+N2HWX9yeXiWLmxxSOSrMXQAw376A8lTpYtHcrthF70T+alMekwuCi9BVHSXR7utVYfxuw2xNsYKp/INxtmY2mqThhTINitQfhdg2ztfLaa29V6ZwyUt3rkYxMvzMcwR0bG51BWF3t7lTMDjOV2kPVgwIfF9TKebtjYJBOqrFm8AEig48AtDai8YzNrGyT7IlHPNA1n9GFn4sXJPk6sigeUofzzSueWOanHcEJ5TEYF0IrWJaeKQlQjFkPVXoUjWijDMCL0g2vHA125+8xPR2x91pkiloMopllEmIOuwuWttOUoO+26f1aBYwcjrbuw8Q5KZNfdcQhfrHrRA3kTTcyIn8sYV7qBfx6o/QTs9vgWieWdYXoi4Y5rP5t7uHh44cQJ70mxPxLdfTb7Lw8zimERwDK1T5XujiNquuZpqF0cNaoVS7xwAPBz8SMfNgxFmwg8E=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(346002)(136003)(39860400002)(451199021)(46966006)(40470700004)(36840700001)(110136005)(316002)(40460700003)(36860700001)(54906003)(478600001)(356005)(81166007)(82740400003)(8936002)(5660300002)(36756003)(55446002)(86362001)(82310400005)(2906002)(2876002)(4326008)(8676002)(70206006)(70586007)(41300700001)(40480700001)(6666004)(186003)(9686003)(26005)(426003)(336012)(83380400001)(47076005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2023 10:37:16.0883
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 890839ea-cc86-4734-f91e-08db2eaf3bd9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF000100D0.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6534
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

An encap match corresponds to an entry in the exact-match Outer Rule
 table; the lookup response includes the encap type (protocol) allowing
 the hardware to continue parsing into the inner headers.

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
Changed in v3: use enum for tun_type field (Simon)
---
 drivers/net/ethernet/sfc/mae.c | 105 +++++++++++++++++++++++++++++++++
 drivers/net/ethernet/sfc/mae.h |   5 ++
 drivers/net/ethernet/sfc/tc.h  |   1 +
 3 files changed, 111 insertions(+)

diff --git a/drivers/net/ethernet/sfc/mae.c b/drivers/net/ethernet/sfc/mae.c
index 2290a63908c5..92f1383ee4b9 100644
--- a/drivers/net/ethernet/sfc/mae.c
+++ b/drivers/net/ethernet/sfc/mae.c
@@ -558,6 +558,20 @@ int efx_mae_free_counter(struct efx_nic *efx, struct efx_tc_counter *cnt)
 	return 0;
 }
 
+static int efx_mae_encap_type_to_mae_type(enum efx_encap_type type)
+{
+	switch (type & EFX_ENCAP_TYPES_MASK) {
+	case EFX_ENCAP_TYPE_NONE:
+		return MAE_MCDI_ENCAP_TYPE_NONE;
+	case EFX_ENCAP_TYPE_VXLAN:
+		return MAE_MCDI_ENCAP_TYPE_VXLAN;
+	case EFX_ENCAP_TYPE_GENEVE:
+		return MAE_MCDI_ENCAP_TYPE_GENEVE;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 int efx_mae_lookup_mport(struct efx_nic *efx, u32 vf_idx, u32 *id)
 {
 	struct ef100_nic_data *nic_data = efx->nic_data;
@@ -915,6 +929,97 @@ int efx_mae_free_action_set_list(struct efx_nic *efx,
 	return 0;
 }
 
+int efx_mae_register_encap_match(struct efx_nic *efx,
+				 struct efx_tc_encap_match *encap)
+{
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_MAE_OUTER_RULE_INSERT_IN_LEN(MAE_ENC_FIELD_PAIRS_LEN));
+	MCDI_DECLARE_BUF(outbuf, MC_CMD_MAE_OUTER_RULE_INSERT_OUT_LEN);
+	MCDI_DECLARE_STRUCT_PTR(match_crit);
+	size_t outlen;
+	int rc;
+
+	rc = efx_mae_encap_type_to_mae_type(encap->tun_type);
+	if (rc < 0)
+		return rc;
+	match_crit = _MCDI_DWORD(inbuf, MAE_OUTER_RULE_INSERT_IN_FIELD_MATCH_CRITERIA);
+	/* The struct contains IP src and dst, and udp dport.
+	 * So we actually need to filter on IP src and dst, L4 dport, and
+	 * ipproto == udp.
+	 */
+	MCDI_SET_DWORD(inbuf, MAE_OUTER_RULE_INSERT_IN_ENCAP_TYPE, rc);
+#ifdef CONFIG_IPV6
+	if (encap->src_ip | encap->dst_ip) {
+#endif
+		MCDI_STRUCT_SET_DWORD_BE(match_crit, MAE_ENC_FIELD_PAIRS_ENC_SRC_IP4_BE,
+					 encap->src_ip);
+		MCDI_STRUCT_SET_DWORD_BE(match_crit, MAE_ENC_FIELD_PAIRS_ENC_SRC_IP4_BE_MASK,
+					 ~(__be32)0);
+		MCDI_STRUCT_SET_DWORD_BE(match_crit, MAE_ENC_FIELD_PAIRS_ENC_DST_IP4_BE,
+					 encap->dst_ip);
+		MCDI_STRUCT_SET_DWORD_BE(match_crit, MAE_ENC_FIELD_PAIRS_ENC_DST_IP4_BE_MASK,
+					 ~(__be32)0);
+		MCDI_STRUCT_SET_WORD_BE(match_crit, MAE_ENC_FIELD_PAIRS_ENC_ETHER_TYPE_BE,
+					htons(ETH_P_IP));
+#ifdef CONFIG_IPV6
+	} else {
+		memcpy(MCDI_STRUCT_PTR(match_crit, MAE_ENC_FIELD_PAIRS_ENC_SRC_IP6_BE),
+		       &encap->src_ip6, sizeof(encap->src_ip6));
+		memset(MCDI_STRUCT_PTR(match_crit, MAE_ENC_FIELD_PAIRS_ENC_SRC_IP6_BE_MASK),
+		       0xff, sizeof(encap->src_ip6));
+		memcpy(MCDI_STRUCT_PTR(match_crit, MAE_ENC_FIELD_PAIRS_ENC_DST_IP6_BE),
+		       &encap->dst_ip6, sizeof(encap->dst_ip6));
+		memset(MCDI_STRUCT_PTR(match_crit, MAE_ENC_FIELD_PAIRS_ENC_DST_IP6_BE_MASK),
+		       0xff, sizeof(encap->dst_ip6));
+		MCDI_STRUCT_SET_WORD_BE(match_crit, MAE_ENC_FIELD_PAIRS_ENC_ETHER_TYPE_BE,
+					htons(ETH_P_IPV6));
+	}
+#endif
+	MCDI_STRUCT_SET_WORD_BE(match_crit, MAE_ENC_FIELD_PAIRS_ENC_ETHER_TYPE_BE_MASK,
+				~(__be16)0);
+	MCDI_STRUCT_SET_WORD_BE(match_crit, MAE_ENC_FIELD_PAIRS_ENC_L4_DPORT_BE,
+				encap->udp_dport);
+	MCDI_STRUCT_SET_WORD_BE(match_crit, MAE_ENC_FIELD_PAIRS_ENC_L4_DPORT_BE_MASK,
+				~(__be16)0);
+	MCDI_STRUCT_SET_BYTE(match_crit, MAE_ENC_FIELD_PAIRS_ENC_IP_PROTO, IPPROTO_UDP);
+	MCDI_STRUCT_SET_BYTE(match_crit, MAE_ENC_FIELD_PAIRS_ENC_IP_PROTO_MASK, ~0);
+	rc = efx_mcdi_rpc(efx, MC_CMD_MAE_OUTER_RULE_INSERT, inbuf,
+			  sizeof(inbuf), outbuf, sizeof(outbuf), &outlen);
+	if (rc)
+		return rc;
+	if (outlen < sizeof(outbuf))
+		return -EIO;
+	encap->fw_id = MCDI_DWORD(outbuf, MAE_OUTER_RULE_INSERT_OUT_OR_ID);
+	return 0;
+}
+
+int efx_mae_unregister_encap_match(struct efx_nic *efx,
+				   struct efx_tc_encap_match *encap)
+{
+	MCDI_DECLARE_BUF(outbuf, MC_CMD_MAE_OUTER_RULE_REMOVE_OUT_LEN(1));
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_MAE_OUTER_RULE_REMOVE_IN_LEN(1));
+	size_t outlen;
+	int rc;
+
+	MCDI_SET_DWORD(inbuf, MAE_OUTER_RULE_REMOVE_IN_OR_ID, encap->fw_id);
+	rc = efx_mcdi_rpc(efx, MC_CMD_MAE_OUTER_RULE_REMOVE, inbuf,
+			  sizeof(inbuf), outbuf, sizeof(outbuf), &outlen);
+	if (rc)
+		return rc;
+	if (outlen < sizeof(outbuf))
+		return -EIO;
+	/* FW freed a different ID than we asked for, should also never happen.
+	 * Warn because it means we've now got a different idea to the FW of
+	 * what encap_mds exist, which could cause mayhem later.
+	 */
+	if (WARN_ON(MCDI_DWORD(outbuf, MAE_OUTER_RULE_REMOVE_OUT_REMOVED_OR_ID) != encap->fw_id))
+		return -EIO;
+	/* We're probably about to free @encap, but let's just make sure its
+	 * fw_id is blatted so that it won't look valid if it leaks out.
+	 */
+	encap->fw_id = MC_CMD_MAE_OUTER_RULE_INSERT_OUT_OUTER_RULE_ID_NULL;
+	return 0;
+}
+
 static int efx_mae_populate_match_criteria(MCDI_DECLARE_STRUCT_PTR(match_crit),
 					   const struct efx_tc_match *match)
 {
diff --git a/drivers/net/ethernet/sfc/mae.h b/drivers/net/ethernet/sfc/mae.h
index 2ccbc62d79b9..79d315a129ab 100644
--- a/drivers/net/ethernet/sfc/mae.h
+++ b/drivers/net/ethernet/sfc/mae.h
@@ -94,6 +94,11 @@ int efx_mae_alloc_action_set_list(struct efx_nic *efx,
 int efx_mae_free_action_set_list(struct efx_nic *efx,
 				 struct efx_tc_action_set_list *acts);
 
+int efx_mae_register_encap_match(struct efx_nic *efx,
+				 struct efx_tc_encap_match *encap);
+int efx_mae_unregister_encap_match(struct efx_nic *efx,
+				   struct efx_tc_encap_match *encap);
+
 int efx_mae_insert_rule(struct efx_nic *efx, const struct efx_tc_match *match,
 			u32 prio, u32 acts_id, u32 *id);
 int efx_mae_delete_rule(struct efx_nic *efx, u32 id);
diff --git a/drivers/net/ethernet/sfc/tc.h b/drivers/net/ethernet/sfc/tc.h
index c1485679507c..fff73960698a 100644
--- a/drivers/net/ethernet/sfc/tc.h
+++ b/drivers/net/ethernet/sfc/tc.h
@@ -70,6 +70,7 @@ struct efx_tc_encap_match {
 	__be32 src_ip, dst_ip;
 	struct in6_addr src_ip6, dst_ip6;
 	__be16 udp_dport;
+	enum efx_encap_type tun_type;
 	u32 fw_id; /* index of this entry in firmware encap match table */
 };
 
