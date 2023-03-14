Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B4496B9D2C
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 18:36:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230461AbjCNRgu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 13:36:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbjCNRgm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 13:36:42 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2062.outbound.protection.outlook.com [40.107.243.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F6D5ACE3F
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 10:36:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b41zDj92kX9t0M3r9+zWSzBTAfEzh5quLGY77eUdJ9XVQbkF7/aNQ7TSJDEvjJDytGOE5/tazgFeU31cFfXuQcCKJwAVO+azGHc7yyFhYFgN4OLsOxvgwUw1V28W4W2dMfR+g7p/wnfW76AECLi5JBY8WKl57w9vrtMUf8kRmeODTbqLbeKoNBfZoHuv45OQq83zMUtN/MhERgUqBUzs2btqCAwqQAJ+OMhEMcwwz5Y91y7u6RcOTOU7cv6UWke3P3KSXFgCHP4pxDbYV0mtv1Cldx7ERXzzj1d1p+UbrbGV2s1d7Ov3xgCyenU4AvRDCza/riMXt/BLFrEd+4+YgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lhjw9Rp5yGU0StwsRJm0cqOSqh+17lafIVvLHGeKnWI=;
 b=TcIHaIwdI/CQycvAQ7D9Dsl2NHeTsx2JVsIMUEQpDCmrT6qVGEe3ydByvroGQUtHkWgsziRB3A4TFxuvyM9MMD3ebdi9dB1T09KlhtVSXNIqwQAa+VblgfPQPpomw/4pZcmn6htutW7Y7ptpjTftrveyivU4KYKTKPI9qUzoEAqpmCogZ/yQYGz6vXXiIOGuFFCF8IeN8vhtM9uWkt/S1RDH06ssC1SMIkA6vSkO67XJQSqNOnhmVTPE+TdesIMZmczGmjyNGAKI7P8PYncb7CMDXSGYlc80tCaTt+VQgxfALqvJTWc6rFatKCfVhp82bueyRQglha22j1EZJQ/Pug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lhjw9Rp5yGU0StwsRJm0cqOSqh+17lafIVvLHGeKnWI=;
 b=C0SfNbSSc4mnDEYQcsCRtx85WHINiq+6L/v4kKd8YIVhTSjGOB3DG5Z1jmyfH4nf+GYYVTduemQAlwjIjtvVIBVIb0AhYus6f+VEOwKAUoiC+ezMmJ9eljQMKj8bjPPJfJA2Nq/O11A7p51U6L0xlifW/tMZroIh6oBRwJJzqOM=
Received: from DS7PR03CA0179.namprd03.prod.outlook.com (2603:10b6:5:3b2::34)
 by IA1PR12MB7638.namprd12.prod.outlook.com (2603:10b6:208:426::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Tue, 14 Mar
 2023 17:36:36 +0000
Received: from DS1PEPF0000E62E.namprd02.prod.outlook.com
 (2603:10b6:5:3b2:cafe::d5) by DS7PR03CA0179.outlook.office365.com
 (2603:10b6:5:3b2::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26 via Frontend
 Transport; Tue, 14 Mar 2023 17:36:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF0000E62E.mail.protection.outlook.com (10.167.17.132) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6178.13 via Frontend Transport; Tue, 14 Mar 2023 17:36:35 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 14 Mar
 2023 12:36:35 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 14 Mar
 2023 12:36:34 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34 via Frontend
 Transport; Tue, 14 Mar 2023 12:36:33 -0500
From:   <edward.cree@amd.com>
To:     <linux-net-drivers@amd.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@google.com>
CC:     Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>,
        <habetsm.xilinx@gmail.com>
Subject: [PATCH net-next 5/5] sfc: add offloading of 'foreign' TC (decap) rules
Date:   Tue, 14 Mar 2023 17:35:25 +0000
Message-ID: <a7aabdb45290f1cd50681eb9e1d610893fbce299.1678815095.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1678815095.git.ecree.xilinx@gmail.com>
References: <cover.1678815095.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E62E:EE_|IA1PR12MB7638:EE_
X-MS-Office365-Filtering-Correlation-Id: 4951c8b2-82e0-4816-ae00-08db24b2a8cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cDc+giC2vAhdKwRX8K+d86Idzg96222g9ejNlZtg9SBfk9pR8sXiW83HyXdLz6CPus+DaenkJgtoFFmftp6MLYHS7/BPOfwcpaPKdGg8HLyUiDEWINWbWVopxMy+aVRbmjgIduXijQBqt7jr6thvz65OC5agEuvEdwOhvFe06UISNlKu5NGr30xbNQt+P3YF3ymTkzIeYE/5iM9U7tUmVB/I3s1eujey4/rYDqyN7/OLUqwtNED7QkNRZ7RbvyIwiydeTwrpbrPWWpdoim0t0xtTdGSH/o4vqXrhRREhoSbymXw+ZMNd/R3Q5MUQeqdLcvKF/hkec9nMP6pXWj1A79/d3Ihqt6fiO7Y+fQ4W7Cc/X5oJAGg73A34wGr211wZxJN8kv+1W4tHQd7BQFoZOjVQOHls4N+9YK8/+HV7aF6iYE3dG0BCvVWXrgxyg3X4GoGl1yZmdppDjZOx4qruRjrtTboQMU38zyn8E++fig+cHANU8Pm0sbhQirtmcKyBMUK+2+OPsrM8NtT5aQzVNTY4rv47dGhwEtbunr0FEGEKSZ+FZrqEYr7r3ySK51f6DyBHTG2aLTF31tV6Femyi6xBNxYyc9dpfP+oLmIq+GuMWknx3HOvLg7sBFJtysjm76dUY+g8JeqhVvFy1dly3Sws7gNaUhc3m9y7YGY69qTwCVtdQkB7vjCl96EYwy3oyTTSlWCc9kDfoPdEA0hu4AvPSKi4KY2Ab9bQajQrbsc=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(376002)(39860400002)(346002)(451199018)(40470700004)(46966006)(36840700001)(2906002)(81166007)(82740400003)(41300700001)(2876002)(83380400001)(36756003)(30864003)(5660300002)(40460700003)(8936002)(40480700001)(70206006)(54906003)(8676002)(316002)(356005)(4326008)(55446002)(36860700001)(86362001)(110136005)(70586007)(82310400005)(478600001)(336012)(47076005)(426003)(186003)(9686003)(6666004)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 17:36:35.7237
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4951c8b2-82e0-4816-ae00-08db24b2a8cf
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E62E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7638
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

A 'foreign' rule is one for which the net_dev is not the sfc netdevice
 or any of its representors.  The driver registers indirect flow blocks
 for tunnel netdevs so that it can offload decap rules.  For example:

    tc filter add dev vxlan0 parent ffff: protocol ipv4 flower \
        enc_src_ip 10.1.0.2 enc_dst_ip 10.1.0.1 \
        enc_key_id 1000 enc_dst_port 4789 \
        action tunnel_key unset \
        action mirred egress redirect dev $REPRESENTOR

When notified of a rule like this, register an encap match on the IP
 and dport tuple (creating an Outer Rule table entry) and insert an MAE
 action rule to perform the decapsulation and deliver to the representee.

Move efx_tc_delete_rule() below efx_tc_flower_release_encap_match() to
 avoid the need for a forward declaration.

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/mae.c |  28 ++-
 drivers/net/ethernet/sfc/mae.h |   3 +
 drivers/net/ethernet/sfc/tc.c  | 359 +++++++++++++++++++++++++++++++--
 drivers/net/ethernet/sfc/tc.h  |   1 +
 4 files changed, 374 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/sfc/mae.c b/drivers/net/ethernet/sfc/mae.c
index 754391eb575f..e8139076fcb0 100644
--- a/drivers/net/ethernet/sfc/mae.c
+++ b/drivers/net/ethernet/sfc/mae.c
@@ -241,6 +241,7 @@ static int efx_mae_get_basic_caps(struct efx_nic *efx, struct mae_caps *caps)
 	if (outlen < sizeof(outbuf))
 		return -EIO;
 	caps->match_field_count = MCDI_DWORD(outbuf, MAE_GET_CAPS_OUT_MATCH_FIELD_COUNT);
+	caps->encap_types = MCDI_DWORD(outbuf, MAE_GET_CAPS_OUT_ENCAP_TYPES_SUPPORTED);
 	caps->action_prios = MCDI_DWORD(outbuf, MAE_GET_CAPS_OUT_ACTION_PRIOS);
 	return 0;
 }
@@ -513,6 +514,28 @@ int efx_mae_check_encap_match_caps(struct efx_nic *efx, unsigned char ipv,
 }
 #undef CHECK
 
+int efx_mae_check_encap_type_supported(struct efx_nic *efx, enum efx_encap_type typ)
+{
+	unsigned int bit;
+
+	switch (typ & EFX_ENCAP_TYPES_MASK) {
+	case EFX_ENCAP_TYPE_VXLAN:
+		bit = MC_CMD_MAE_GET_CAPS_OUT_ENCAP_TYPE_VXLAN_LBN;
+		break;
+	case EFX_ENCAP_TYPE_NVGRE:
+		bit = MC_CMD_MAE_GET_CAPS_OUT_ENCAP_TYPE_NVGRE_LBN;
+		break;
+	case EFX_ENCAP_TYPE_GENEVE:
+		bit = MC_CMD_MAE_GET_CAPS_OUT_ENCAP_TYPE_GENEVE_LBN;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+	if (efx->tc->caps->encap_types & BIT(bit))
+		return 0;
+	return -EOPNOTSUPP;
+}
+
 int efx_mae_allocate_counter(struct efx_nic *efx, struct efx_tc_counter *cnt)
 {
 	MCDI_DECLARE_BUF(outbuf, MC_CMD_MAE_COUNTER_ALLOC_OUT_LEN(1));
@@ -772,9 +795,10 @@ int efx_mae_alloc_action_set(struct efx_nic *efx, struct efx_tc_action_set *act)
 	size_t outlen;
 	int rc;
 
-	MCDI_POPULATE_DWORD_2(inbuf, MAE_ACTION_SET_ALLOC_IN_FLAGS,
+	MCDI_POPULATE_DWORD_3(inbuf, MAE_ACTION_SET_ALLOC_IN_FLAGS,
 			      MAE_ACTION_SET_ALLOC_IN_VLAN_PUSH, act->vlan_push,
-			      MAE_ACTION_SET_ALLOC_IN_VLAN_POP, act->vlan_pop);
+			      MAE_ACTION_SET_ALLOC_IN_VLAN_POP, act->vlan_pop,
+			      MAE_ACTION_SET_ALLOC_IN_DECAP, act->decap);
 
 	MCDI_SET_DWORD(inbuf, MAE_ACTION_SET_ALLOC_IN_SRC_MAC_ID,
 		       MC_CMD_MAE_MAC_ADDR_ALLOC_OUT_MAC_ID_NULL);
diff --git a/drivers/net/ethernet/sfc/mae.h b/drivers/net/ethernet/sfc/mae.h
index 5b45138aaaf4..6cc96f8adfea 100644
--- a/drivers/net/ethernet/sfc/mae.h
+++ b/drivers/net/ethernet/sfc/mae.h
@@ -70,6 +70,7 @@ void efx_mae_counters_grant_credits(struct work_struct *work);
 
 struct mae_caps {
 	u32 match_field_count;
+	u32 encap_types;
 	u32 action_prios;
 	u8 action_rule_fields[MAE_NUM_FIELDS];
 	u8 outer_rule_fields[MAE_NUM_FIELDS];
@@ -82,6 +83,8 @@ int efx_mae_match_check_caps(struct efx_nic *efx,
 			     struct netlink_ext_ack *extack);
 int efx_mae_check_encap_match_caps(struct efx_nic *efx, unsigned char ipv,
 				   struct netlink_ext_ack *extack);
+int efx_mae_check_encap_type_supported(struct efx_nic *efx,
+				       enum efx_encap_type typ);
 
 int efx_mae_allocate_counter(struct efx_nic *efx, struct efx_tc_counter *cnt);
 int efx_mae_free_counter(struct efx_nic *efx, struct efx_tc_counter *cnt);
diff --git a/drivers/net/ethernet/sfc/tc.c b/drivers/net/ethernet/sfc/tc.c
index dc092403af12..8ccf25260312 100644
--- a/drivers/net/ethernet/sfc/tc.c
+++ b/drivers/net/ethernet/sfc/tc.c
@@ -10,12 +10,24 @@
  */
 
 #include <net/pkt_cls.h>
+#include <net/vxlan.h>
+#include <net/geneve.h>
 #include "tc.h"
 #include "tc_bindings.h"
 #include "mae.h"
 #include "ef100_rep.h"
 #include "efx.h"
 
+enum efx_encap_type efx_tc_indr_netdev_type(struct net_device *net_dev)
+{
+	if (netif_is_vxlan(net_dev))
+		return EFX_ENCAP_TYPE_VXLAN;
+	if (netif_is_geneve(net_dev))
+		return EFX_ENCAP_TYPE_GENEVE;
+
+	return EFX_ENCAP_TYPE_NONE;
+}
+
 #define EFX_EFV_PF	NULL
 /* Look up the representor information (efv) for a device.
  * May return NULL for the PF (us), or an error pointer for a device that
@@ -43,6 +55,20 @@ static struct efx_rep *efx_tc_flower_lookup_efv(struct efx_nic *efx,
 	return efv;
 }
 
+/* Convert a driver-internal vport ID into an internal device (PF or VF) */
+static s64 efx_tc_flower_internal_mport(struct efx_nic *efx, struct efx_rep *efv)
+{
+	u32 mport;
+
+	if (IS_ERR(efv))
+		return PTR_ERR(efv);
+	if (!efv) /* device is PF (us) */
+		efx_mae_mport_uplink(efx, &mport);
+	else /* device is repr */
+		efx_mae_mport_mport(efx, efv->mport, &mport);
+	return mport;
+}
+
 /* Convert a driver-internal vport ID into an external device (wire or VF) */
 static s64 efx_tc_flower_external_mport(struct efx_nic *efx, struct efx_rep *efv)
 {
@@ -106,15 +132,6 @@ static void efx_tc_free_action_set_list(struct efx_nic *efx,
 	/* Don't kfree, as acts is embedded inside a struct efx_tc_flow_rule */
 }
 
-static void efx_tc_delete_rule(struct efx_nic *efx, struct efx_tc_flow_rule *rule)
-{
-	efx_mae_delete_rule(efx, rule->fw_id);
-
-	/* Release entries in subsidiary tables */
-	efx_tc_free_action_set_list(efx, &rule->acts, true);
-	rule->fw_id = MC_CMD_MAE_ACTION_RULE_INSERT_OUT_ACTION_RULE_ID_NULL;
-}
-
 static void efx_tc_flow_free(void *ptr, void *arg)
 {
 	struct efx_tc_flow_rule *rule = ptr;
@@ -350,7 +367,6 @@ static int efx_tc_flower_parse_match(struct efx_nic *efx,
 	return 0;
 }
 
-__always_unused
 static int efx_tc_flower_record_encap_match(struct efx_nic *efx,
 					    struct efx_tc_match *match,
 					    enum efx_encap_type type,
@@ -479,7 +495,6 @@ static int efx_tc_flower_record_encap_match(struct efx_nic *efx,
 	return rc;
 }
 
-__always_unused
 static void efx_tc_flower_release_encap_match(struct efx_nic *efx,
 					      struct efx_tc_encap_match *encap)
 {
@@ -501,8 +516,38 @@ static void efx_tc_flower_release_encap_match(struct efx_nic *efx,
 	kfree(encap);
 }
 
+static void efx_tc_delete_rule(struct efx_nic *efx, struct efx_tc_flow_rule *rule)
+{
+	efx_mae_delete_rule(efx, rule->fw_id);
+
+	/* Release entries in subsidiary tables */
+	efx_tc_free_action_set_list(efx, &rule->acts, true);
+	if (rule->match.encap)
+		efx_tc_flower_release_encap_match(efx, rule->match.encap);
+	rule->fw_id = MC_CMD_MAE_ACTION_RULE_INSERT_OUT_ACTION_RULE_ID_NULL;
+}
+
+static const char *efx_tc_encap_type_name(enum efx_encap_type typ, char *buf,
+					  size_t n)
+{
+	switch (typ) {
+	case EFX_ENCAP_TYPE_NONE:
+		return "none";
+	case EFX_ENCAP_TYPE_VXLAN:
+		return "vxlan";
+	case EFX_ENCAP_TYPE_NVGRE:
+		return "nvgre";
+	case EFX_ENCAP_TYPE_GENEVE:
+		return "geneve";
+	default:
+		snprintf(buf, n, "type %u\n", typ);
+		return buf;
+	}
+}
+
 /* For details of action order constraints refer to SF-123102-TC-1§12.6.1 */
 enum efx_tc_action_order {
+	EFX_TC_AO_DECAP,
 	EFX_TC_AO_VLAN_POP,
 	EFX_TC_AO_VLAN_PUSH,
 	EFX_TC_AO_COUNT,
@@ -513,6 +558,10 @@ static bool efx_tc_flower_action_order_ok(const struct efx_tc_action_set *act,
 					  enum efx_tc_action_order new)
 {
 	switch (new) {
+	case EFX_TC_AO_DECAP:
+		if (act->decap)
+			return false;
+		fallthrough;
 	case EFX_TC_AO_VLAN_POP:
 		if (act->vlan_pop >= 2)
 			return false;
@@ -540,6 +589,288 @@ static bool efx_tc_flower_action_order_ok(const struct efx_tc_action_set *act,
 	}
 }
 
+static int efx_tc_flower_replace_foreign(struct efx_nic *efx,
+					 struct net_device *net_dev,
+					 struct flow_cls_offload *tc)
+{
+	struct flow_rule *fr = flow_cls_offload_flow_rule(tc);
+	struct netlink_ext_ack *extack = tc->common.extack;
+	struct efx_tc_flow_rule *rule = NULL, *old = NULL;
+	struct efx_tc_action_set *act = NULL;
+	bool found = false, uplinked = false;
+	const struct flow_action_entry *fa;
+	struct efx_tc_match match;
+	struct efx_rep *to_efv;
+	s64 rc;
+	int i;
+
+	/* Parse match */
+	memset(&match, 0, sizeof(match));
+	rc = efx_tc_flower_parse_match(efx, fr, &match, NULL);
+	if (rc)
+		return rc;
+	/* The rule as given to us doesn't specify a source netdevice.
+	 * But, determining whether packets from a VF should match it is
+	 * complicated, so leave those to the software slowpath: qualify
+	 * the filter with source m-port == wire.
+	 */
+	rc = efx_tc_flower_external_mport(efx, EFX_EFV_PF);
+	if (rc < 0) {
+		NL_SET_ERR_MSG_MOD(extack, "Failed to identify ingress m-port for foreign filter");
+		return rc;
+	}
+	match.value.ingress_port = rc;
+	match.mask.ingress_port = ~0;
+
+	if (tc->common.chain_index) {
+		NL_SET_ERR_MSG_MOD(extack, "No support for nonzero chain_index");
+		return -EOPNOTSUPP;
+	}
+	match.mask.recirc_id = 0xff;
+
+	flow_action_for_each(i, fa, &fr->action) {
+		switch (fa->id) {
+		case FLOW_ACTION_REDIRECT:
+		case FLOW_ACTION_MIRRED: /* mirred means mirror here */
+			to_efv = efx_tc_flower_lookup_efv(efx, fa->dev);
+			if (IS_ERR(to_efv))
+				continue;
+			found = true;
+			break;
+		default:
+			break;
+		}
+	}
+	if (!found) { /* We don't care. */
+		netif_dbg(efx, drv, efx->net_dev,
+			  "Ignoring foreign filter that doesn't egdev us\n");
+		rc = -EOPNOTSUPP;
+		goto release;
+	}
+
+	rc = efx_mae_match_check_caps(efx, &match.mask, NULL);
+	if (rc)
+		goto release;
+
+	if (efx_tc_match_is_encap(&match.mask)) {
+		enum efx_encap_type type;
+
+		type = efx_tc_indr_netdev_type(net_dev);
+		if (type == EFX_ENCAP_TYPE_NONE) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Egress encap match on unsupported tunnel device");
+			rc = -EOPNOTSUPP;
+			goto release;
+		}
+
+		rc = efx_mae_check_encap_type_supported(efx, type);
+		if (rc) {
+			char errbuf[16];
+
+			NL_SET_ERR_MSG_FMT_MOD(extack,
+					       "Firmware reports no support for %s encap match",
+					       efx_tc_encap_type_name(type, errbuf,
+								      sizeof(errbuf)));
+			goto release;
+		}
+
+		rc = efx_tc_flower_record_encap_match(efx, &match, type,
+						      extack);
+		if (rc)
+			goto release;
+	} else {
+		/* This is not a tunnel decap rule, ignore it */
+		netif_dbg(efx, drv, efx->net_dev,
+			  "Ignoring foreign filter without encap match\n");
+		rc = -EOPNOTSUPP;
+		goto release;
+	}
+
+	rule = kzalloc(sizeof(*rule), GFP_USER);
+	if (!rule) {
+		rc = -ENOMEM;
+		goto release;
+	}
+	INIT_LIST_HEAD(&rule->acts.list);
+	rule->cookie = tc->cookie;
+	old = rhashtable_lookup_get_insert_fast(&efx->tc->match_action_ht,
+						&rule->linkage,
+						efx_tc_match_action_ht_params);
+	if (old) {
+		netif_dbg(efx, drv, efx->net_dev,
+			  "Ignoring already-offloaded rule (cookie %lx)\n",
+			  tc->cookie);
+		rc = -EEXIST;
+		goto release;
+	}
+
+	/* Parse actions */
+	act = kzalloc(sizeof(*act), GFP_USER);
+	if (!act) {
+		rc = -ENOMEM;
+		goto release;
+	}
+
+	/* Parse actions.  For foreign rules we only support decap & redirect */
+	flow_action_for_each(i, fa, &fr->action) {
+		struct efx_tc_action_set save;
+
+		switch (fa->id) {
+		case FLOW_ACTION_REDIRECT:
+		case FLOW_ACTION_MIRRED:
+			/* See corresponding code in efx_tc_flower_replace() for
+			 * long explanations of what's going on here.
+			 */
+			save = *act;
+			if (fa->hw_stats) {
+				struct efx_tc_counter_index *ctr;
+
+				if (!(fa->hw_stats & FLOW_ACTION_HW_STATS_DELAYED)) {
+					NL_SET_ERR_MSG_FMT_MOD(extack,
+							       "hw_stats_type %u not supported (only 'delayed')",
+							       fa->hw_stats);
+					rc = -EOPNOTSUPP;
+					goto release;
+				}
+				if (!efx_tc_flower_action_order_ok(act, EFX_TC_AO_COUNT)) {
+					rc = -EOPNOTSUPP;
+					goto release;
+				}
+
+				ctr = efx_tc_flower_get_counter_index(efx,
+								      tc->cookie,
+								      EFX_TC_COUNTER_TYPE_AR);
+				if (IS_ERR(ctr)) {
+					rc = PTR_ERR(ctr);
+					NL_SET_ERR_MSG_MOD(extack, "Failed to obtain a counter");
+					goto release;
+				}
+				act->count = ctr;
+			}
+
+			if (!efx_tc_flower_action_order_ok(act, EFX_TC_AO_DELIVER)) {
+				/* can't happen */
+				rc = -EOPNOTSUPP;
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Deliver action violates action order (can't happen)");
+				goto release;
+			}
+			to_efv = efx_tc_flower_lookup_efv(efx, fa->dev);
+			/* PF implies egdev is us, in which case we really
+			 * want to deliver to the uplink (because this is an
+			 * ingress filter).  If we don't recognise the egdev
+			 * at all, then we'd better trap so SW can handle it.
+			 */
+			if (IS_ERR(to_efv))
+				to_efv = EFX_EFV_PF;
+			if (to_efv == EFX_EFV_PF) {
+				if (uplinked)
+					break;
+				uplinked = true;
+			}
+			rc = efx_tc_flower_internal_mport(efx, to_efv);
+			if (rc < 0) {
+				NL_SET_ERR_MSG_MOD(extack, "Failed to identify egress m-port");
+				goto release;
+			}
+			act->dest_mport = rc;
+			act->deliver = 1;
+			rc = efx_mae_alloc_action_set(efx, act);
+			if (rc) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Failed to write action set to hw (mirred)");
+				goto release;
+			}
+			list_add_tail(&act->list, &rule->acts.list);
+			act = NULL;
+			if (fa->id == FLOW_ACTION_REDIRECT)
+				break; /* end of the line */
+			/* Mirror, so continue on with saved act */
+			save.count = NULL;
+			act = kzalloc(sizeof(*act), GFP_USER);
+			if (!act) {
+				rc = -ENOMEM;
+				goto release;
+			}
+			*act = save;
+			break;
+		case FLOW_ACTION_TUNNEL_DECAP:
+			if (!efx_tc_flower_action_order_ok(act, EFX_TC_AO_DECAP)) {
+				rc = -EINVAL;
+				NL_SET_ERR_MSG_MOD(extack, "Decap action violates action order");
+				goto release;
+			}
+			act->decap = 1;
+			/* If we previously delivered/trapped to uplink, now
+			 * that we've decapped we'll want another copy if we
+			 * try to deliver/trap to uplink again.
+			 */
+			uplinked = false;
+			break;
+		default:
+			NL_SET_ERR_MSG_FMT_MOD(extack, "Unhandled action %u",
+					       fa->id);
+			rc = -EOPNOTSUPP;
+			goto release;
+		}
+	}
+
+	if (act) {
+		if (!uplinked) {
+			/* Not shot/redirected, so deliver to default dest (which is
+			 * the uplink, as this is an ingress filter)
+			 */
+			efx_mae_mport_uplink(efx, &act->dest_mport);
+			act->deliver = 1;
+		}
+		rc = efx_mae_alloc_action_set(efx, act);
+		if (rc) {
+			NL_SET_ERR_MSG_MOD(extack, "Failed to write action set to hw (deliver)");
+			goto release;
+		}
+		list_add_tail(&act->list, &rule->acts.list);
+		act = NULL; /* Prevent double-free in error path */
+	}
+
+	rule->match = match;
+
+	netif_dbg(efx, drv, efx->net_dev,
+		  "Successfully parsed foreign filter (cookie %lx)\n",
+		  tc->cookie);
+
+	rc = efx_mae_alloc_action_set_list(efx, &rule->acts);
+	if (rc) {
+		NL_SET_ERR_MSG_MOD(extack, "Failed to write action set list to hw");
+		goto release;
+	}
+	rc = efx_mae_insert_rule(efx, &rule->match, EFX_TC_PRIO_TC,
+				 rule->acts.fw_id, &rule->fw_id);
+	if (rc) {
+		NL_SET_ERR_MSG_MOD(extack, "Failed to insert rule in hw");
+		goto release_act;
+	}
+	return 0;
+
+release_act:
+	efx_mae_free_action_set_list(efx, &rule->acts);
+release:
+	/* We failed to insert the rule, so free up any entries we created in
+	 * subsidiary tables.
+	 */
+	if (act)
+		efx_tc_free_action_set(efx, act, false);
+	if (rule) {
+		rhashtable_remove_fast(&efx->tc->match_action_ht,
+				       &rule->linkage,
+				       efx_tc_match_action_ht_params);
+		efx_tc_free_action_set_list(efx, &rule->acts, false);
+	}
+	kfree(rule);
+	if (match.encap)
+		efx_tc_flower_release_encap_match(efx, match.encap);
+	return rc;
+}
+
 static int efx_tc_flower_replace(struct efx_nic *efx,
 				 struct net_device *net_dev,
 				 struct flow_cls_offload *tc,
@@ -564,10 +895,8 @@ static int efx_tc_flower_replace(struct efx_nic *efx,
 
 	from_efv = efx_tc_flower_lookup_efv(efx, net_dev);
 	if (IS_ERR(from_efv)) {
-		/* Might be a tunnel decap rule from an indirect block.
-		 * Support for those not implemented yet.
-		 */
-		return -EOPNOTSUPP;
+		/* Not from our PF or representors, so probably a tunnel dev */
+		return efx_tc_flower_replace_foreign(efx, net_dev, tc);
 	}
 
 	if (efv != from_efv) {
diff --git a/drivers/net/ethernet/sfc/tc.h b/drivers/net/ethernet/sfc/tc.h
index d70c0ba86669..47b6e9e35808 100644
--- a/drivers/net/ethernet/sfc/tc.h
+++ b/drivers/net/ethernet/sfc/tc.h
@@ -28,6 +28,7 @@ static inline bool efx_ipv6_addr_all_ones(struct in6_addr *addr)
 struct efx_tc_action_set {
 	u16 vlan_push:2;
 	u16 vlan_pop:2;
+	u16 decap:1;
 	u16 deliver:1;
 	__be16 vlan_tci[2]; /* TCIs for vlan_push */
 	__be16 vlan_proto[2]; /* Ethertypes for vlan_push */
