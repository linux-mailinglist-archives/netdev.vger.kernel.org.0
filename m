Return-Path: <netdev+bounces-8175-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BE68722F9B
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 21:19:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 148ED2813CC
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 19:19:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 571FE2413F;
	Mon,  5 Jun 2023 19:19:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42E30DDC0
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 19:19:09 +0000 (UTC)
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2060d.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eb2::60d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 949301997
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 12:18:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q1zB1+QfJnnQXbMzQyHVEooLakpADZC0jGfvk8aWmmLIgFeEkYdgs8anbxwgkqArAqRW4XapPvhZ4Rm4bSLVqOxe3fw1JpccUXD66kwQZw7bf+6Hfkcj+ZWMmHVZ6fZD5/efhDRyT3aLURvfvV4kNdddVC35d4j7CCDcj1gTssGoYrGWY6+eLEby8cRSuLihjyvcE3+x9gYaFwqHFrLLT8abbsCQb5pMtHe0byObERXWUIl3eT9bLxAMXC58b1rzXxQUIKvep5Un4NTOjzyHVYS1oIWNBtypZCT+JuWcaFlxfk1Sbm96+ROHA1AdPPiYyvF1SEjPt8wU3fbmwWWuhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1bNZz0Gnq73VzDv5pQGyV5BmFy9kPDSSi2elaLP17Wo=;
 b=LJ2oV6wmQu/TDb9boOrHVn0f7DKz7pDWQot2g48dW3mcMaLpaDBQsi1XZFIpxv5FslVPEABclfxbjHwjv+KzO4U90a6dqrMohpxcSs/PBX6XCyNRtCpW7rjDG4F7g5U6iq+uPMA/zUwGQA7TTEEwO12Bj6XWVFApNjgWQWH5IVffVl4f6L4TdPlqqaUYHCH6zl1QUyblK9Kg6/iDkStLzjLJO/y8/seYAHNiihjIZsnCKLCpHid95dOsHbUttnK1WuDV6gnQrHYXm2xL+vbfRjBt2hczUWh1pXbLDDPwR3V2SlXz629/EcYYUr9227mF0lfatojGZEImfG3B/zT0rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1bNZz0Gnq73VzDv5pQGyV5BmFy9kPDSSi2elaLP17Wo=;
 b=GgfpsTOIa0XK6dLCJrN79rF91KTLVc110X5T8EJe9NR53jHD9Vx6ppzcP3OpH3zzJBSwboL+933BZ8+NreokBDiTNoZSFtdEyjMHVmY77jOz7Qfvv3mYb+m7LWJxpV1ow4nqXiW7R6OaLCf4FVlC853Bid5knPjg8MoEd9Ovk3M=
Received: from BN0PR08CA0010.namprd08.prod.outlook.com (2603:10b6:408:142::11)
 by MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Mon, 5 Jun
 2023 19:18:13 +0000
Received: from BN8NAM11FT112.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:142:cafe::ea) by BN0PR08CA0010.outlook.office365.com
 (2603:10b6:408:142::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33 via Frontend
 Transport; Mon, 5 Jun 2023 19:18:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN8NAM11FT112.mail.protection.outlook.com (10.13.176.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6455.33 via Frontend Transport; Mon, 5 Jun 2023 19:18:13 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 5 Jun
 2023 14:18:12 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34 via Frontend
 Transport; Mon, 5 Jun 2023 14:18:11 -0500
From: <edward.cree@amd.com>
To: <linux-net-drivers@amd.com>, <davem@davemloft.net>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <edumazet@google.com>
CC: Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>,
	<habetsm.xilinx@gmail.com>
Subject: [PATCH net-next 1/6] sfc: add fallback action-set-lists for TC offload
Date: Mon, 5 Jun 2023 20:17:34 +0100
Message-ID: <096d731b63e7edbec1a64283387ec5da378664c9.1685992503.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1685992503.git.ecree.xilinx@gmail.com>
References: <cover.1685992503.git.ecree.xilinx@gmail.com>
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
X-MS-TrafficTypeDiagnostic: BN8NAM11FT112:EE_|MN2PR12MB4192:EE_
X-MS-Office365-Filtering-Correlation-Id: e2c5d960-e492-4ed6-d9e6-08db65f99b76
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	6ZaYlj64GLACG8fkqpHf8owmgoPeQWtn0oWQYeRmhJUGSd9DO4xIenGDZ5XQGwcK7VN+rk68W2Qkx/4N8UUtryihoPA2RgqSH4+0ftTrlFI1csAdts1ibLRNF2IcM/H7qrvmkbirRFoFnjfHEXQYTv9yv4huWzh54Kl/Me5AnYWFO7PPlMcB+52apBNw3ra8gUO/gs8PFHNuaqN3n56SrbbZdQBoRd1nDxtwHNIXQrAwgONfUYu9Ge4sJKc5o1tjUow1gMT8QFFFUP6fThP1m7wW3e3K2Gs5w3To3GN9RjQgs9SBie5sSFYtDv7aGgFT67QWUu8mHq1+9PX779pF+5yWM1sRlFYGOd7ETliwEcDkiZaTa5AOFR1sh/lk9dK3iFWsFcHYYMbA9n1SbudYtUC/PeQ7XLWzMM0Q4qQXNfu7IR599HGuPPcPdyhebch+DuCP49vpAlIheEJp/cXrdvpOTYTkGmT4LVSp5Dg8z2AyoJMHOPNAc2UljfowzlWmL3MeWZmMvMakDjBCuJGgYNr34nsVk4scGGtRyeoyAOsB+Hck4g1+LkJ/ERWJDiL8tc28TdatXf+PSsbYy72xgjNZZ88aqSxxGRLF1dgDSRZC4qr+DSlyscJKREu+OZlkrca++sKfCugjearLdTj8Bwdgxs75GGMe2H6xv3oTUj8moapZ+5sYQAwJ5ZRohzafvFLNtEo4dMOYzqDGCRaMKAH3gCc9+LrGVqV4dzf3MBrWGLmMGWspbRvsQYNdKoNaeBqLqQD/TS4gzgy5zfn14w==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(39860400002)(396003)(136003)(346002)(451199021)(36840700001)(46966006)(40470700004)(47076005)(83380400001)(336012)(426003)(110136005)(82740400003)(54906003)(40480700001)(478600001)(40460700003)(8936002)(8676002)(316002)(41300700001)(70586007)(70206006)(356005)(81166007)(5660300002)(55446002)(86362001)(4326008)(6666004)(36756003)(2906002)(36860700001)(2876002)(82310400005)(26005)(186003)(9686003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2023 19:18:13.2108
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e2c5d960-e492-4ed6-d9e6-08db65f99b76
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN8NAM11FT112.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4192
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Edward Cree <ecree.xilinx@gmail.com>

When offloading a TC encap action, the action information for the
 hardware might not be "ready": if there's currently no neighbour entry
 available for the destination address, we can't construct the Ethernet
 header to prepend to the packet.  In this case, we still offload the
 flow rule, but with its action-set-list ID pointing at a "fallback"
 action which simply delivers the packet to its default destination (as
 though no flow rule had matched), thus allowing software TC to handle
 it.  Later, when we receive a neighbouring update that allows us to
 construct the encap header, the rule will become "ready" and we will
 update its action-set-list ID in hardware to point at the actual
 offloaded actions.
This patch sets up these fallback ASLs, but does not yet use them.

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/tc.c | 68 +++++++++++++++++++++++++++++++++++
 drivers/net/ethernet/sfc/tc.h |  9 +++++
 2 files changed, 77 insertions(+)

diff --git a/drivers/net/ethernet/sfc/tc.c b/drivers/net/ethernet/sfc/tc.c
index bb9ec1e761d3..24c67a163910 100644
--- a/drivers/net/ethernet/sfc/tc.c
+++ b/drivers/net/ethernet/sfc/tc.c
@@ -1391,6 +1391,58 @@ void efx_tc_deconfigure_default_rule(struct efx_nic *efx,
 	rule->fw_id = MC_CMD_MAE_ACTION_RULE_INSERT_OUT_ACTION_RULE_ID_NULL;
 }
 
+static int efx_tc_configure_fallback_acts(struct efx_nic *efx, u32 eg_port,
+					  struct efx_tc_action_set_list *acts)
+{
+	struct efx_tc_action_set *act;
+	int rc;
+
+	act = kzalloc(sizeof(*act), GFP_KERNEL);
+	if (!act)
+		return -ENOMEM;
+	act->deliver = 1;
+	act->dest_mport = eg_port;
+	rc = efx_mae_alloc_action_set(efx, act);
+	if (rc)
+		goto fail1;
+	EFX_WARN_ON_PARANOID(!list_empty(&acts->list));
+	list_add_tail(&act->list, &acts->list);
+	rc = efx_mae_alloc_action_set_list(efx, acts);
+	if (rc)
+		goto fail2;
+	return 0;
+fail2:
+	list_del(&act->list);
+	efx_mae_free_action_set(efx, act->fw_id);
+fail1:
+	kfree(act);
+	return rc;
+}
+
+static int efx_tc_configure_fallback_acts_pf(struct efx_nic *efx)
+{
+	struct efx_tc_action_set_list *acts = &efx->tc->facts.pf;
+	u32 eg_port;
+
+	efx_mae_mport_uplink(efx, &eg_port);
+	return efx_tc_configure_fallback_acts(efx, eg_port, acts);
+}
+
+static int efx_tc_configure_fallback_acts_reps(struct efx_nic *efx)
+{
+	struct efx_tc_action_set_list *acts = &efx->tc->facts.reps;
+	u32 eg_port;
+
+	efx_mae_mport_mport(efx, efx->tc->reps_mport_id, &eg_port);
+	return efx_tc_configure_fallback_acts(efx, eg_port, acts);
+}
+
+static void efx_tc_deconfigure_fallback_acts(struct efx_nic *efx,
+					     struct efx_tc_action_set_list *acts)
+{
+	efx_tc_free_action_set_list(efx, acts, true);
+}
+
 static int efx_tc_configure_rep_mport(struct efx_nic *efx)
 {
 	u32 rep_mport_label;
@@ -1481,6 +1533,12 @@ int efx_init_tc(struct efx_nic *efx)
 	if (rc)
 		return rc;
 	rc = efx_tc_configure_rep_mport(efx);
+	if (rc)
+		return rc;
+	rc = efx_tc_configure_fallback_acts_pf(efx);
+	if (rc)
+		return rc;
+	rc = efx_tc_configure_fallback_acts_reps(efx);
 	if (rc)
 		return rc;
 	efx->tc->up = true;
@@ -1500,6 +1558,8 @@ void efx_fini_tc(struct efx_nic *efx)
 	efx_tc_deconfigure_rep_mport(efx);
 	efx_tc_deconfigure_default_rule(efx, &efx->tc->dflt.pf);
 	efx_tc_deconfigure_default_rule(efx, &efx->tc->dflt.wire);
+	efx_tc_deconfigure_fallback_acts(efx, &efx->tc->facts.pf);
+	efx_tc_deconfigure_fallback_acts(efx, &efx->tc->facts.reps);
 	efx->tc->up = false;
 }
 
@@ -1564,6 +1624,10 @@ int efx_init_struct_tc(struct efx_nic *efx)
 	efx->tc->dflt.pf.fw_id = MC_CMD_MAE_ACTION_RULE_INSERT_OUT_ACTION_RULE_ID_NULL;
 	INIT_LIST_HEAD(&efx->tc->dflt.wire.acts.list);
 	efx->tc->dflt.wire.fw_id = MC_CMD_MAE_ACTION_RULE_INSERT_OUT_ACTION_RULE_ID_NULL;
+	INIT_LIST_HEAD(&efx->tc->facts.pf.list);
+	efx->tc->facts.pf.fw_id = MC_CMD_MAE_ACTION_SET_ALLOC_OUT_ACTION_SET_ID_NULL;
+	INIT_LIST_HEAD(&efx->tc->facts.reps.list);
+	efx->tc->facts.reps.fw_id = MC_CMD_MAE_ACTION_SET_ALLOC_OUT_ACTION_SET_ID_NULL;
 	efx->extra_channel_type[EFX_EXTRA_CHANNEL_TC] = &efx_tc_channel_type;
 	return 0;
 fail_match_action_ht:
@@ -1589,6 +1653,10 @@ void efx_fini_struct_tc(struct efx_nic *efx)
 			     MC_CMD_MAE_ACTION_RULE_INSERT_OUT_ACTION_RULE_ID_NULL);
 	EFX_WARN_ON_PARANOID(efx->tc->dflt.wire.fw_id !=
 			     MC_CMD_MAE_ACTION_RULE_INSERT_OUT_ACTION_RULE_ID_NULL);
+	EFX_WARN_ON_PARANOID(efx->tc->facts.pf.fw_id !=
+			     MC_CMD_MAE_ACTION_SET_LIST_ALLOC_OUT_ACTION_SET_LIST_ID_NULL);
+	EFX_WARN_ON_PARANOID(efx->tc->facts.reps.fw_id !=
+			     MC_CMD_MAE_ACTION_SET_LIST_ALLOC_OUT_ACTION_SET_LIST_ID_NULL);
 	rhashtable_free_and_destroy(&efx->tc->match_action_ht, efx_tc_flow_free,
 				    efx);
 	rhashtable_free_and_destroy(&efx->tc->encap_match_ht,
diff --git a/drivers/net/ethernet/sfc/tc.h b/drivers/net/ethernet/sfc/tc.h
index 24e9640c74e9..ae182553514d 100644
--- a/drivers/net/ethernet/sfc/tc.h
+++ b/drivers/net/ethernet/sfc/tc.h
@@ -160,6 +160,11 @@ enum efx_tc_rule_prios {
  *	%EFX_TC_PRIO_DFLT.  Named by *ingress* port
  * @dflt.pf: rule for traffic ingressing from PF (egresses to wire)
  * @dflt.wire: rule for traffic ingressing from wire (egresses to PF)
+ * @facts: Fallback action-set-lists for unready rules.  Named by *egress* port
+ * @facts.pf: action-set-list for unready rules on PF netdev, hence applying to
+ *	traffic from wire, and egressing to PF
+ * @facts.reps: action-set-list for unready rules on representors, hence
+ *	applying to traffic from representees, and egressing to the reps mport
  * @up: have TC datastructures been set up?
  */
 struct efx_tc_state {
@@ -180,6 +185,10 @@ struct efx_tc_state {
 		struct efx_tc_flow_rule pf;
 		struct efx_tc_flow_rule wire;
 	} dflt;
+	struct {
+		struct efx_tc_action_set_list pf;
+		struct efx_tc_action_set_list reps;
+	} facts;
 	bool up;
 };
 

