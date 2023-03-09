Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD62A6B2394
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 13:00:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230448AbjCIMAt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 07:00:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230429AbjCIMAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 07:00:14 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2041.outbound.protection.outlook.com [40.107.223.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3DC8DDB14
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 04:00:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OEYKarQSKKg73sflf9x8JhWUfxvGPoxciItcy7Fj+ERiAncZhowufaiJM37fgucVq/6RlAvaTf65cceJiGSXPcT3Xtdd3a7+lqQk+GO4jrVBPZMjBm41pBpCV84poJtxT6Yv6XuSNrGwvLR2drpU9TtZIsCoysqzmMvFA9m+Y0zzMr3EG7BtYN/9QtT7TLxmnb9lZ9q9+fGsniLLdVri69s1xBR1KRbpkeTvHtKT7uXtNdVEe7fhjN2hgXPdzvM0x7dewo5o9i76Mj/IrWEfUEIt0uMVcMvaramEmQkmK5qxJIdYg9EUGW8ifUoWnKIKZmEO9xqkFZmU4ALnq4skqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rxjbr89e/0OLe+Jp2eytK8VY81JXWmYOm85l+nEFUzw=;
 b=Jnzj5FblJR2WQqinhf+bW6aoN9MVB+HlEXHhp2pv5KADx6xRtAnyHYJefImDqif8MfmPaQi/lEo5EYU7ZSHP40dnfSsMeAoLdOTaZdqtUl8/Qc1GoKD7RCLqNcsOXusFzbnhv1BnEf6WaR1+rWe4/kjZJnGpVAoz3QXW4vbyly0d4eUrMRN7TLk83Vze2tUz1J+W5jp++FaCUWTMSmt3s1heUz10+TuA3DWbz7HT7cgQlCgDn7mckhd1mM5FsM0bYLE42WAedaFFRvkTEJLE7YmnRbqL8EKjqxWp7vfyOcvdnZUPksJ4s+aOvilxggxCVQhXrjDg5VcjxvwIYvvkHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rxjbr89e/0OLe+Jp2eytK8VY81JXWmYOm85l+nEFUzw=;
 b=Rp5vpO0w8cNp/NdrtADtgEXeQZUQN+MlVLLM67uNPyxbTORTr7ZciXdfXynq9Y4WeQEP7ce40WT8zGMjQEuemzGrNtEmVQWcprV/GRpAjqBuqklqMSSK/gnJ3ddwOl4DnN99rMmoH67SHL8G3+2lbF5NtdKfH5rv8BGN4I7NdEg=
Received: from BN7PR06CA0066.namprd06.prod.outlook.com (2603:10b6:408:34::43)
 by MN2PR12MB4486.namprd12.prod.outlook.com (2603:10b6:208:263::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.17; Thu, 9 Mar
 2023 12:00:08 +0000
Received: from BN8NAM11FT071.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:34:cafe::cc) by BN7PR06CA0066.outlook.office365.com
 (2603:10b6:408:34::43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19 via Frontend
 Transport; Thu, 9 Mar 2023 12:00:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT071.mail.protection.outlook.com (10.13.177.92) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6178.19 via Frontend Transport; Thu, 9 Mar 2023 12:00:07 +0000
Received: from SATLEXMB07.amd.com (10.181.41.45) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 9 Mar
 2023 06:00:07 -0600
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB07.amd.com
 (10.181.41.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 9 Mar
 2023 04:00:06 -0800
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34 via Frontend
 Transport; Thu, 9 Mar 2023 06:00:05 -0600
From:   <edward.cree@amd.com>
To:     <linux-net-drivers@amd.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@google.com>
CC:     Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>,
        <habetsm.xilinx@gmail.com>
Subject: [PATCH v3 net-next] sfc: support offloading TC VLAN push/pop actions to the MAE
Date:   Thu, 9 Mar 2023 11:59:04 +0000
Message-ID: <20230309115904.56442-1-edward.cree@amd.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT071:EE_|MN2PR12MB4486:EE_
X-MS-Office365-Filtering-Correlation-Id: d57ad265-92f0-47a9-3b3d-08db2095d3cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IvH0Ac/ajr6lE+/fzxU2HeijPOiA10jdMAnaVdctgGqwRo1epk/0yZN2xtFFQHHx6uk6K1YyEBelAGxrQiKgpOmkYYtOVw6cL4ZB3fFULGNNR3NTKLHbQqqy2NxnUf2sDvDwasNCskacMjzO96SGPpPtPxhD4Mtxdo1xYtG+zzxsWB3hhmUKqDC2IOBYldaYv2BPsIu9+6LJwfA/DRLIt3iNBvpwGo8w3TaXnUNKolQKrqjaOYJz4LXG4Qr+Q4OBfjg21SpmoCBSP9jSpX6UGpxgI2MexcrqU0HF6NjChJ/7Xn5z2mMAQhiob3CFooVIWDQy5klL0HITWoNw3+VKEcd5A2jhAYVSoo1wYwwPoM7Jc3cbZnc4SsswS+TJDNJnLJ4fTLDawH0Enz37GRTJ9GxuLVNcf2qB42r7t+iaU5C4hC2+n0M73cNF41C49FbyQMGH+Hk2LKhnvl0ClltpJgT12zvOIHFgx5ghwPwvxLr0nNFRKlyRyVP8crUaSRyg9zPuRtOd/6bJMXqvFHeKqgT7CTMRwSSSHNqUE5CLT58gMCrKe/6ILhhBLhdI5sWp3qK1ex95ahyGJUCVnZy3TC9HU0RhSQVqq4B4re2tOS5F7tQpq8GuPFcylcORj5HjrdHl8UI6DXCJcecVW8jfkZXaI9hfJovilwlbyG6JnNA1FHsH7gu5HEs2vtlLw1BjNEu2WdTu+czx2j3mf652gie1HY5Dlo1ZF/VsN5YUcvs=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(346002)(376002)(136003)(396003)(451199018)(40470700004)(36840700001)(46966006)(2906002)(70206006)(2876002)(4326008)(5660300002)(356005)(26005)(36756003)(8936002)(1076003)(41300700001)(54906003)(8676002)(110136005)(70586007)(86362001)(316002)(40480700001)(40460700003)(478600001)(2616005)(81166007)(36860700001)(82740400003)(336012)(186003)(82310400005)(47076005)(83380400001)(426003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 12:00:07.8534
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d57ad265-92f0-47a9-3b3d-08db2095d3cf
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT071.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4486
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree.xilinx@gmail.com>

EF100 can pop and/or push up to two VLAN tags.

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
Changed in v3:
 * used VLAN_VID_MASK and VLAN_PRIO_SHIFT instead of raw constants (Simon)
 * stopped checkpatch complaining about long lines (Simon, Martin)
Changed in v2: reworked act->vlan_push/pop to be counts rather than bitmasks,
 and simplified the corresponding efx_tc_action_order handling.

 drivers/net/ethernet/sfc/mae.c  | 16 +++++++++++++
 drivers/net/ethernet/sfc/mcdi.h |  5 ++++
 drivers/net/ethernet/sfc/tc.c   | 42 +++++++++++++++++++++++++++++++++
 drivers/net/ethernet/sfc/tc.h   |  4 ++++
 4 files changed, 67 insertions(+)

diff --git a/drivers/net/ethernet/sfc/mae.c b/drivers/net/ethernet/sfc/mae.c
index 2d32abe5f478..c53d354c1fb2 100644
--- a/drivers/net/ethernet/sfc/mae.c
+++ b/drivers/net/ethernet/sfc/mae.c
@@ -682,6 +682,10 @@ int efx_mae_alloc_action_set(struct efx_nic *efx, struct efx_tc_action_set *act)
 	size_t outlen;
 	int rc;
 
+	MCDI_POPULATE_DWORD_2(inbuf, MAE_ACTION_SET_ALLOC_IN_FLAGS,
+			      MAE_ACTION_SET_ALLOC_IN_VLAN_PUSH, act->vlan_push,
+			      MAE_ACTION_SET_ALLOC_IN_VLAN_POP, act->vlan_pop);
+
 	MCDI_SET_DWORD(inbuf, MAE_ACTION_SET_ALLOC_IN_SRC_MAC_ID,
 		       MC_CMD_MAE_MAC_ADDR_ALLOC_OUT_MAC_ID_NULL);
 	MCDI_SET_DWORD(inbuf, MAE_ACTION_SET_ALLOC_IN_DST_MAC_ID,
@@ -694,6 +698,18 @@ int efx_mae_alloc_action_set(struct efx_nic *efx, struct efx_tc_action_set *act)
 			       MC_CMD_MAE_COUNTER_ALLOC_OUT_COUNTER_ID_NULL);
 	MCDI_SET_DWORD(inbuf, MAE_ACTION_SET_ALLOC_IN_COUNTER_LIST_ID,
 		       MC_CMD_MAE_COUNTER_LIST_ALLOC_OUT_COUNTER_LIST_ID_NULL);
+	if (act->vlan_push) {
+		MCDI_SET_WORD_BE(inbuf, MAE_ACTION_SET_ALLOC_IN_VLAN0_TCI_BE,
+				 act->vlan_tci[0]);
+		MCDI_SET_WORD_BE(inbuf, MAE_ACTION_SET_ALLOC_IN_VLAN0_PROTO_BE,
+				 act->vlan_proto[0]);
+	}
+	if (act->vlan_push >= 2) {
+		MCDI_SET_WORD_BE(inbuf, MAE_ACTION_SET_ALLOC_IN_VLAN1_TCI_BE,
+				 act->vlan_tci[1]);
+		MCDI_SET_WORD_BE(inbuf, MAE_ACTION_SET_ALLOC_IN_VLAN1_PROTO_BE,
+				 act->vlan_proto[1]);
+	}
 	MCDI_SET_DWORD(inbuf, MAE_ACTION_SET_ALLOC_IN_ENCAP_HEADER_ID,
 		       MC_CMD_MAE_ENCAP_HEADER_ALLOC_OUT_ENCAP_HEADER_ID_NULL);
 	if (act->deliver)
diff --git a/drivers/net/ethernet/sfc/mcdi.h b/drivers/net/ethernet/sfc/mcdi.h
index b139b76febff..454e9d51a4c2 100644
--- a/drivers/net/ethernet/sfc/mcdi.h
+++ b/drivers/net/ethernet/sfc/mcdi.h
@@ -233,6 +233,11 @@ void efx_mcdi_sensor_event(struct efx_nic *efx, efx_qword_t *ev);
 	((void)BUILD_BUG_ON_ZERO(_field ## _LEN != 2),  \
 	le16_to_cpu(*(__force const __le16 *)MCDI_STRUCT_PTR(_buf, _field)))
 /* Write a 16-bit field defined in the protocol as being big-endian. */
+#define MCDI_SET_WORD_BE(_buf, _field, _value) do {			\
+	BUILD_BUG_ON(MC_CMD_ ## _field ## _LEN != 2);			\
+	BUILD_BUG_ON(MC_CMD_ ## _field ## _OFST & 1);			\
+	*(__force __be16 *)MCDI_PTR(_buf, _field) = (_value);		\
+	} while (0)
 #define MCDI_STRUCT_SET_WORD_BE(_buf, _field, _value) do {		\
 	BUILD_BUG_ON(_field ## _LEN != 2);				\
 	BUILD_BUG_ON(_field ## _OFST & 1);				\
diff --git a/drivers/net/ethernet/sfc/tc.c b/drivers/net/ethernet/sfc/tc.c
index deeaab9ee761..2b07bb2fd735 100644
--- a/drivers/net/ethernet/sfc/tc.c
+++ b/drivers/net/ethernet/sfc/tc.c
@@ -286,6 +286,8 @@ static int efx_tc_flower_parse_match(struct efx_nic *efx,
 
 /* For details of action order constraints refer to SF-123102-TC-1§12.6.1 */
 enum efx_tc_action_order {
+	EFX_TC_AO_VLAN_POP,
+	EFX_TC_AO_VLAN_PUSH,
 	EFX_TC_AO_COUNT,
 	EFX_TC_AO_DELIVER
 };
@@ -294,6 +296,20 @@ static bool efx_tc_flower_action_order_ok(const struct efx_tc_action_set *act,
 					  enum efx_tc_action_order new)
 {
 	switch (new) {
+	case EFX_TC_AO_VLAN_POP:
+		if (act->vlan_pop >= 2)
+			return false;
+		/* If we've already pushed a VLAN, we can't then pop it;
+		 * the hardware would instead try to pop an existing VLAN
+		 * before pushing the new one.
+		 */
+		if (act->vlan_push)
+			return false;
+		fallthrough;
+	case EFX_TC_AO_VLAN_PUSH:
+		if (act->vlan_push >= 2)
+			return false;
+		fallthrough;
 	case EFX_TC_AO_COUNT:
 		if (act->count)
 			return false;
@@ -393,6 +409,7 @@ static int efx_tc_flower_replace(struct efx_nic *efx,
 
 	flow_action_for_each(i, fa, &fr->action) {
 		struct efx_tc_action_set save;
+		u16 tci;
 
 		if (!act) {
 			/* more actions after a non-pipe action */
@@ -494,6 +511,31 @@ static int efx_tc_flower_replace(struct efx_nic *efx,
 			}
 			*act = save;
 			break;
+		case FLOW_ACTION_VLAN_POP:
+			if (act->vlan_push) {
+				act->vlan_push--;
+			} else if (efx_tc_flower_action_order_ok(act, EFX_TC_AO_VLAN_POP)) {
+				act->vlan_pop++;
+			} else {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "More than two VLAN pops, or action order violated");
+				rc = -EINVAL;
+				goto release;
+			}
+			break;
+		case FLOW_ACTION_VLAN_PUSH:
+			if (!efx_tc_flower_action_order_ok(act, EFX_TC_AO_VLAN_PUSH)) {
+				rc = -EINVAL;
+				NL_SET_ERR_MSG_MOD(extack,
+						   "More than two VLAN pushes, or action order violated");
+				goto release;
+			}
+			tci = fa->vlan.vid & VLAN_VID_MASK;
+			tci |= fa->vlan.prio << VLAN_PRIO_SHIFT;
+			act->vlan_tci[act->vlan_push] = cpu_to_be16(tci);
+			act->vlan_proto[act->vlan_push] = fa->vlan.proto;
+			act->vlan_push++;
+			break;
 		default:
 			NL_SET_ERR_MSG_FMT_MOD(extack, "Unhandled action %u",
 					       fa->id);
diff --git a/drivers/net/ethernet/sfc/tc.h b/drivers/net/ethernet/sfc/tc.h
index 418ce8c13a06..542853f60c2a 100644
--- a/drivers/net/ethernet/sfc/tc.h
+++ b/drivers/net/ethernet/sfc/tc.h
@@ -19,7 +19,11 @@
 #define IS_ALL_ONES(v)	(!(typeof (v))~(v))
 
 struct efx_tc_action_set {
+	u16 vlan_push:2;
+	u16 vlan_pop:2;
 	u16 deliver:1;
+	__be16 vlan_tci[2]; /* TCIs for vlan_push */
+	__be16 vlan_proto[2]; /* Ethertypes for vlan_push */
 	struct efx_tc_counter_index *count;
 	u32 dest_mport;
 	u32 fw_id; /* index of this entry in firmware actions table */
