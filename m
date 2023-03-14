Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE0F26B9D2A
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 18:36:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230493AbjCNRgq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 13:36:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230164AbjCNRgj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 13:36:39 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2086.outbound.protection.outlook.com [40.107.101.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B227ACBA3
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 10:36:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GHyYpKeNajY1rlRjWPPZ1J0x2g2NmIoGWzaiQm8UQo7/5bESwpBKqWcsQ3uRAaOZbZQdHnioDOJo6LJ2n8WzJzGb17kD/jsseInBnsNXeZUjYTLBRFFFWT8h3Lrd00EvtWVmrhQ90Z6bdqjTCDS+KQXVibTgX1dFIv3UGNaaE0wQtBVmuQOxAQTe9ZZJOnFzWO4hcd7JRaFVjgDFp/aFsw4cvr2iPF6Liy72wsP6ChuoqtymmkmkxGKGlNExcZddDDjdaLxgrtCYsuHOkC7mOmgwqnRw3IvAQidL46jQNBS8Rgxzk1pIjAS7SKtynTct/6HXfWgG2PHjz83o37EzKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eDj1BeF+xIZeB6zQo0RZvYxI4kYcVrcMd4BeKqRhgCI=;
 b=WEmUflvQqZMe7b3iXntAM1yPLMjkgqiWNobk535yvpWN86welHscKtgTqQw7aFcUOD9D1ItUgSfilB4oHdRtBEzTL3oTv9inDFlX2LPAvj0xWnf66nh4nGRVUNyOptHB9BDJqWQpwoYBSMHIhwdwMBWfcFgoLoa6fDHGdyLZnARFsjDEh96syVDjdxO7aG6UP9z7o2GRs09zDOhlgthLskkhKKte5tGTrdEokqd6QltDV2jBJPHQPleyO4s43mqQCkSRVSUxU2OFTm3mgAQIwiO0lRUEuaoSGi+Z1CX/rJ4lvKUqGNtyR056yDqSclb+fk2lcF55hdjExDbSEUwj/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eDj1BeF+xIZeB6zQo0RZvYxI4kYcVrcMd4BeKqRhgCI=;
 b=s50vllREqWww6awbVdlTF6xSN5gxlDuq7TtSge6e2as+rSWHoBO3Ew9O8KVgMa26s1mDRfsz7meCySb0r3CMepwMNuJ1/sXLLXnQUZzVTFU0jW6BASzIHhZPp0mTsS5ThoKYZVzsxbUKR8A7a69/QduHD8vyAEShxMfGXhbBi+I=
Received: from BL0PR02CA0038.namprd02.prod.outlook.com (2603:10b6:207:3d::15)
 by SN7PR12MB7369.namprd12.prod.outlook.com (2603:10b6:806:298::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Tue, 14 Mar
 2023 17:36:33 +0000
Received: from BL02EPF000108EA.namprd05.prod.outlook.com
 (2603:10b6:207:3d:cafe::eb) by BL0PR02CA0038.outlook.office365.com
 (2603:10b6:207:3d::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.25 via Frontend
 Transport; Tue, 14 Mar 2023 17:36:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BL02EPF000108EA.mail.protection.outlook.com (10.167.241.203) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6178.13 via Frontend Transport; Tue, 14 Mar 2023 17:36:32 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 14 Mar
 2023 12:36:32 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34 via Frontend
 Transport; Tue, 14 Mar 2023 12:36:31 -0500
From:   <edward.cree@amd.com>
To:     <linux-net-drivers@amd.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@google.com>
CC:     Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>,
        <habetsm.xilinx@gmail.com>
Subject: [PATCH net-next 3/5] sfc: add functions to insert encap matches into the MAE
Date:   Tue, 14 Mar 2023 17:35:23 +0000
Message-ID: <cae6e259972a00e4785a6d92f71d43bece0858a8.1678815095.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1678815095.git.ecree.xilinx@gmail.com>
References: <cover.1678815095.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF000108EA:EE_|SN7PR12MB7369:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b80dac4-720a-4bff-ea42-08db24b2a6fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JNv+HC83Q0BZbmKAhOcDZ0yAWszQ0yBj39RRz6216jkR1lMs384fgo3wxt7WnR+V13L8PqLl1HtYvqB9YKtsZamQ8+fksfCEtFppJMM+4aa+QQmg2WEC7DCOwelyGgMbL/3JsiqLAuPEhziqaMDCV938m+ua8WBf0xgpOj9on6eGEbvRaqs1emGppTTSLGXLzMfdZ//d2jxXSZEUv4abJGroHZ6clpTSfUZU83rXiCqyIqiwyEknAl6iOIbN6d+FJsXH/ZNFrvAJwfoRXbCtxpF6JTH1Mtqqo9EMbSwilqazoGyo2GppWyDw6jjWlXFV/Z3P5/pha2N4grsMthc33HG8hyGW7D+NG5gnpnXPH+65+oDERXjO/57/uNHOS9+mPQ33EX9S3Y3jv9n1ajnemo6RsJ0GwDt+9zbc5GVU8GJKxd92RzMqmRUXsj6JPh5ZiGKIF3k60N7V3HC2345+8xkkq28xoM/7aXcwZVm6sl0ARJ4hOB7MiHsW7RTCS4CHyabEMrTm2GbrsU27GNKeqcW1gcXtMJNhbF77wu1l3edgaPuB/E383GvFE1Mjk1x21kPcvGS352jr9wCl/Mp1QHxJYqXXmZc7WVl1PhnJGD7eOOH7Ns3dVuuwmY1JNNP+9Bbut1JJzEbKMqAQDVIeFzMjWJa/jXrd1CgpBwfw9E2Y9se/9218Mgat36KSi+QjRm52ZzXszqOHN6Y8HETKxQ1rSfQFV98gFqMmHvwf9oA=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(376002)(39860400002)(396003)(136003)(346002)(451199018)(40470700004)(46966006)(36840700001)(55446002)(86362001)(356005)(36860700001)(36756003)(82740400003)(81166007)(8936002)(2876002)(2906002)(41300700001)(5660300002)(40480700001)(40460700003)(4326008)(82310400005)(186003)(26005)(9686003)(83380400001)(47076005)(426003)(336012)(54906003)(316002)(110136005)(8676002)(70586007)(6666004)(478600001)(70206006)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 17:36:32.7091
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b80dac4-720a-4bff-ea42-08db24b2a6fe
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF000108EA.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7369
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

An encap match corresponds to an entry in the exact-match Outer Rule
 table; the lookup response includes the encap type (protocol) allowing
 the hardware to continue parsing into the inner headers.

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/mae.c | 105 +++++++++++++++++++++++++++++++++
 drivers/net/ethernet/sfc/mae.h |   5 ++
 drivers/net/ethernet/sfc/tc.h  |   1 +
 3 files changed, 111 insertions(+)

diff --git a/drivers/net/ethernet/sfc/mae.c b/drivers/net/ethernet/sfc/mae.c
index 1a285facda34..754391eb575f 100644
--- a/drivers/net/ethernet/sfc/mae.c
+++ b/drivers/net/ethernet/sfc/mae.c
@@ -564,6 +564,20 @@ int efx_mae_free_counter(struct efx_nic *efx, struct efx_tc_counter *cnt)
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
@@ -921,6 +935,97 @@ int efx_mae_free_action_set_list(struct efx_nic *efx,
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
index a45d1791517f..5b45138aaaf4 100644
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
index c1485679507c..19782c9a4354 100644
--- a/drivers/net/ethernet/sfc/tc.h
+++ b/drivers/net/ethernet/sfc/tc.h
@@ -70,6 +70,7 @@ struct efx_tc_encap_match {
 	__be32 src_ip, dst_ip;
 	struct in6_addr src_ip6, dst_ip6;
 	__be16 udp_dport;
+	u16 tun_type; /* enum efx_encap_type */
 	u32 fw_id; /* index of this entry in firmware encap match table */
 };
 
