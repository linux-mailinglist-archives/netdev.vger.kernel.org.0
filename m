Return-Path: <netdev+bounces-9292-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B799B7285B6
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 18:47:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 19F5A1C21077
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 16:47:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC8661DCC4;
	Thu,  8 Jun 2023 16:45:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAD5D1DCC1
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 16:45:15 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2082.outbound.protection.outlook.com [40.107.94.82])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 476483586
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 09:44:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kUUnfOPJ97AGLRLiayept4FQaKnu9kyfKhGoG8MUuZl8IYYcejTwJ8CN/T/zPRDDzW/Z/fcUaWIk+rm21n3rUn3nCjDJ7pdDtWs+mzr3IezjtqUS3xNsL5QATVUKIRUEoJ25bwcuUhOElBDnI0Qy/A+IdFC9BNy/lPYOfMEvkwpqCsm7H1qJBAguCFHT42T+zEMe0+NI0ZOBA3Gh5v5k2Czs0B3WzKhHICsqGEbPnrQgE68SMfDtk2eFLIHOJLaQF3OD1brH+wSAHddXBf8wYEbjDrXp0p3CITbhUIaAEEHl8UvpYOXpJi6zmZBE4zdukHjknN/gosFoF9YBHRwXMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IQBQvT4klU5/HZnLAsw1SDXC7w+3RGfGS8zYNRMZ79Q=;
 b=nzSnHTR9RGRCumv6D3K23lnG4Ey7hXfF5aOYIgzyWoJayWP8SygE32NzxJnexTELikcWAdRTgvY5P7mGa1qctpauTjn+dKD00UipkbKgXRowf9wh2DPoTFhqbdjUSVBjjHU9UYVCKOS4czlo3DyL0U9t9lqcL3w+bxhChIVhAg0FXSdqlb+pTCZ/qd2dfv+6xpcBxF2xsgEuNWUl9ad0GmEfAnCyHYYg/8hjgJx2cFehhJ+C1xHPg77CpMG2Mml6qEVMU3grFBLMLSIZeDUEFH5v1fGMsMxxuWW/AlohZEUav2pH9zPFxCNwpoJYFpsDa6pHE5FHT9JuhqLegu7IJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IQBQvT4klU5/HZnLAsw1SDXC7w+3RGfGS8zYNRMZ79Q=;
 b=lPHBCJjSlDmGC3mCYxWZ1ySuJpD7Q/54C0SttMH7bmdBdD48GQFpkSi/STrtOj24V4RtQFFIKD4KjYyPCvo/y1FphZYKCAbnFqgKs7CGjfoA0u9hOb/QozkvJazeC5MEvs7vqRU6wTi2alLgh2x4Qj1bNtT0uuw++gBdFZV+ti8=
Received: from BN0PR04CA0051.namprd04.prod.outlook.com (2603:10b6:408:e8::26)
 by DM4PR12MB5213.namprd12.prod.outlook.com (2603:10b6:5:394::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.19; Thu, 8 Jun
 2023 16:44:13 +0000
Received: from BN8NAM11FT109.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e8:cafe::7e) by BN0PR04CA0051.outlook.office365.com
 (2603:10b6:408:e8::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.36 via Frontend
 Transport; Thu, 8 Jun 2023 16:44:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT109.mail.protection.outlook.com (10.13.176.221) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6477.26 via Frontend Transport; Thu, 8 Jun 2023 16:44:13 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 8 Jun
 2023 11:44:12 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34 via Frontend
 Transport; Thu, 8 Jun 2023 11:44:11 -0500
From: <edward.cree@amd.com>
To: <linux-net-drivers@amd.com>, <davem@davemloft.net>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <edumazet@google.com>
CC: Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>,
	<habetsm.xilinx@gmail.com>, Pieter Jansen van Vuuren
	<pieter.jansen-van-vuuren@amd.com>
Subject: [PATCH v2 net-next 1/6] sfc: add fallback action-set-lists for TC offload
Date: Thu, 8 Jun 2023 17:42:30 +0100
Message-ID: <096d731b63e7edbec1a64283387ec5da378664c9.1686240142.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1686240142.git.ecree.xilinx@gmail.com>
References: <cover.1686240142.git.ecree.xilinx@gmail.com>
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
X-MS-TrafficTypeDiagnostic: BN8NAM11FT109:EE_|DM4PR12MB5213:EE_
X-MS-Office365-Filtering-Correlation-Id: 18ed6585-b744-46ff-3158-08db683f973d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	t+6t5y2Wcfp0pn/EOEDT72Bq9V9YTwtcLPlG6I16ZwH6LTIOf2ZVkvG+YsGWrZzqutGjI3IwCACWw6At7I1g3gGvcwbJxCO4xfFwecq7QHGozaKd4ouRt8d86RIURwyMHEEGKVZbNeZYHh7zTTVhWppBhQsJ3WyBKeCGCfB8UYj5F4qh3eyzk3d1xPWlnM/0bYD3NU28Rn3JM35ZOB5m4L2Db2aiLhb7qdQcYYtmunrZoDvqyg+AHcZs8kOBSlSUq1Ss8twa9m6iG+SARmx/iiZPX4MxPNzaU4C+re1aVNXCrvZtIXuoUjfGa1s5nT8wK1XdoGqofcoRmOC8CVuzfzFVOjmvWUvcJO1adYv9g+L7jCwLZHsbZh850wCUKa/y5WUViW71wr6C6hVLvBLfYq81xWxS+nBU8s8sMnym+c5N19bchjjdCgvjVA6MvB6WynOtgBskk9bHI1KoSZgNe0JUgMyoBQbaDwiJ+mjeFmXoPmFMOfy20NZQIHufCJ1gd/5pCaMB7w9f1Ec2z4jqf8d4Qezw/36uCeBl04SWlHpKd2BOVdxFaLmNVhaX4c6PSn0hnfslqWr6MOCniEgUpVQ7tPF4VbYDS0OCSk910Nlap0EhUOgWh+6V6L+5cOYWSXBACI29bJZ6d+k1Msm6kxsyQ69LenqZce8v9dj3ykwqYnqIa923jpoqkpWEzA6W0Jp+h2e10I5AEQOi6AZRn94wvfK18y4twx1k54VMO0Dg8jcn8Rn5YjD/p1W1/GJ+oE6LCQxOgvDPtA3yOK0G0g==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(136003)(376002)(396003)(346002)(451199021)(36840700001)(40470700004)(46966006)(40460700003)(70586007)(70206006)(316002)(4326008)(54906003)(110136005)(478600001)(86362001)(55446002)(36756003)(47076005)(83380400001)(36860700001)(26005)(9686003)(426003)(336012)(186003)(41300700001)(82310400005)(8936002)(8676002)(5660300002)(2906002)(6666004)(40480700001)(2876002)(356005)(81166007)(82740400003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2023 16:44:13.2186
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 18ed6585-b744-46ff-3158-08db683f973d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN8NAM11FT109.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5213
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
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

Reviewed-by: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
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
 

