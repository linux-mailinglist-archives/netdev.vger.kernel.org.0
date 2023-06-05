Return-Path: <netdev+bounces-8178-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C069722FA1
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 21:20:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B5D97280D4A
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 19:20:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D08D24141;
	Mon,  5 Jun 2023 19:19:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AFE9DDC0
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 19:19:41 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2062c.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5a::62c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2640A10CA
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 12:19:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ti4YaA92ltCWL1r7lveBTiyhGWnTGn+3kGRT/hXNhXw3A2FvaWyOV4UomlwaAjlsBN+C0pzdN6L1+tEqBGUeZ/YcVUkqmdP6DAgKvlHwpW6oB3V0ZA/M6s8nLl2Ld8LvxdlrQ6UMWHZti2aaY6S7It45Tqx3G6qrtwxLKFhYaMN8ik5+daLNJh2/OVlRARWuAXgZPe5U8avuYr3iXvmWjR+9j4tegsuzUx8vbT9ttaPH224FMogch/on5GsX6e7ClpJC1hWgT+U87QeKgfPcfF4BOWf7WaZMHTCrGOjcYR7FlQ2CZrS+l6fJ4G6xpWWsExUWzykdU5b+lMQnp0PMzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lieuMpUfz0ZB4N/nz+YaRLn8FXyBw6IfBN+FEuDq1OY=;
 b=O2xjPABIE8XSNP5YTwfVzMBAOImoq6fji6lA/QAIn6v5Q4Q0KogxzxCNVFs8dRrqV6KEH53K5DGlKAOHm7hHGkVYjQNMb5UDr/daLvv3Hc70E/sOsybnY/MXSt8P1jy4cradfM+b/M6szbkTvC/5oxDBFikUZ1pldd3hdogbz0aEzYH0ZuID2778pcbA6s35dmVnvyLJRlFCBPp4lgWVus7eJpIhsyOwtxCIg+60pJBThhAe3Ltjymp7nqgoWwTaPJyNQHvw6mbLRo740NdUXGuLjEkftqTiyLut32qN9edYXXHL2ywVFB+P7H2FloXLx992/ltnizyGRgKOd7FdLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lieuMpUfz0ZB4N/nz+YaRLn8FXyBw6IfBN+FEuDq1OY=;
 b=iR2n1KoJp5Aky3o9kQ2rrdlenFEGHkS5xF3hVyJ5A06+cuqUbgeVq7raIhK//ufU+G3d+ddLg1ErTdUUnoLZhJsLDR2bfJ1WsHTH8ciCDsK1Jwr7zT6datWjErrIjf9ouLpSTwBGQeyhIBZ9u/BTXzf04HPJoIdiQQdN+HTOCFk=
Received: from DM6PR06CA0017.namprd06.prod.outlook.com (2603:10b6:5:120::30)
 by IA1PR12MB6139.namprd12.prod.outlook.com (2603:10b6:208:3e9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Mon, 5 Jun
 2023 19:18:26 +0000
Received: from DM6NAM11FT047.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:120:cafe::30) by DM6PR06CA0017.outlook.office365.com
 (2603:10b6:5:120::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33 via Frontend
 Transport; Mon, 5 Jun 2023 19:18:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT047.mail.protection.outlook.com (10.13.172.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6455.33 via Frontend Transport; Mon, 5 Jun 2023 19:18:25 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 5 Jun
 2023 14:18:24 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 5 Jun
 2023 14:18:13 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34 via Frontend
 Transport; Mon, 5 Jun 2023 14:18:12 -0500
From: <edward.cree@amd.com>
To: <linux-net-drivers@amd.com>, <davem@davemloft.net>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <edumazet@google.com>
CC: Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>,
	<habetsm.xilinx@gmail.com>
Subject: [PATCH net-next 2/6] sfc: some plumbing towards TC encap action offload
Date: Mon, 5 Jun 2023 20:17:35 +0100
Message-ID: <8664a34d8286c166c6058527374c11058019591b.1685992503.git.ecree.xilinx@gmail.com>
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT047:EE_|IA1PR12MB6139:EE_
X-MS-Office365-Filtering-Correlation-Id: 717e74ec-523d-491e-cb3d-08db65f9a305
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	rP2LuTl0mH7H6iQHT1LjLmZ5BfsBZeo2ytcddwX045LNLXt+pH3OvNMweSLL92h6NbmhuYEpkjlDNDT5ouiJtljN+G4fxIK+XKMnFplP2rJlRWNRwnJAlWq6j5BGl8sEpzelG18YP1hcx+hFLArlBtAk+yRBciVDOPMEmnbbuaiSHFNpIakpXyGHZFmwPL4sTAGqN6q8iIxPH9dYEFodccwtcGpHm2qmqVz6SuT6ddMs5CdoAwVcBXSzUiXJ3rkDbOr5+QNemvKIARpqqfW2T0Uxs+GYakxlVIqpBLXCqiM4UDTfu2/eQpow0IObIGxWTudoPnYS1s0bGBNjpDdv6tXAxNMDPNVDqktngQxvR3IsneJCYRZdjD5XXvpPRsp1p9WdhFzQ0/tcErdD0orPn6Ij6k+YquUjmnYYa3GMehvsHC5uYm/RBomJCLMukSeSRRIhvNXWiLMOTWNvrrpLdTYRb/Un+rEBhGdpbqITdCjs6GarotfNLg5moT8T2hxtqhK1AWVk3d0Lot+1VNrWrvQ2kREuSYYhdF6KIWAh1BGIJ5kLJx+nho2nDkAnQRJMyX7DksO4YXOVuX2UxUn4M+sjsGkFOhkFQYmEAokS8S3zlNZLNc7M82Wr5c7EPx+1JOLe/o5jGlBmhfpYTL2wyZB5EBLzauFnB8PJRzMG4g9OhY+k1E/b6MuKRJlS1cZGTwR8+2wZd8qMPoadQiepI8NF6sF3yyzAHNT9j6/Z6pcbqAvtN8ptKxnAoOiOI26cR4IbK9lW/3iksP+ahu4jotZsM5kgger2D+6TrT8PRms=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(376002)(39860400002)(396003)(451199021)(40470700004)(36840700001)(46966006)(36756003)(110136005)(54906003)(40460700003)(2906002)(30864003)(2876002)(82310400005)(478600001)(55446002)(86362001)(41300700001)(8936002)(8676002)(5660300002)(82740400003)(316002)(356005)(81166007)(40480700001)(4326008)(70586007)(70206006)(83380400001)(47076005)(9686003)(26005)(186003)(336012)(426003)(36860700001)(6666004)(2004002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2023 19:18:25.8603
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 717e74ec-523d-491e-cb3d-08db65f9a305
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM6NAM11FT047.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6139
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Edward Cree <ecree.xilinx@gmail.com>

Create software objects to manage the metadata for encap actions that
 can be attached to TC rules.  However, since we don't yet have the
 neighbouring information (needed to generate the Ethernet header),
 all rules with encap actions are marked as "unready" and thus insert
 the fallback action into hardware rather than actually offloading the
 encapsulation action.

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/Makefile           |   3 +-
 drivers/net/ethernet/sfc/tc.c               | 104 +++++++++++++++-
 drivers/net/ethernet/sfc/tc.h               |   7 ++
 drivers/net/ethernet/sfc/tc_encap_actions.c | 126 ++++++++++++++++++++
 drivers/net/ethernet/sfc/tc_encap_actions.h |  47 ++++++++
 5 files changed, 284 insertions(+), 3 deletions(-)
 create mode 100644 drivers/net/ethernet/sfc/tc_encap_actions.c
 create mode 100644 drivers/net/ethernet/sfc/tc_encap_actions.h

diff --git a/drivers/net/ethernet/sfc/Makefile b/drivers/net/ethernet/sfc/Makefile
index 55b9c73cd8ef..16293b58e0a8 100644
--- a/drivers/net/ethernet/sfc/Makefile
+++ b/drivers/net/ethernet/sfc/Makefile
@@ -10,7 +10,8 @@ sfc-y			+= efx.o efx_common.o efx_channels.o nic.o \
 			   efx_devlink.o
 sfc-$(CONFIG_SFC_MTD)	+= mtd.o
 sfc-$(CONFIG_SFC_SRIOV)	+= sriov.o ef10_sriov.o ef100_sriov.o ef100_rep.o \
-                           mae.o tc.o tc_bindings.o tc_counters.o
+                           mae.o tc.o tc_bindings.o tc_counters.o \
+                           tc_encap_actions.o
 
 obj-$(CONFIG_SFC)	+= sfc.o
 
diff --git a/drivers/net/ethernet/sfc/tc.c b/drivers/net/ethernet/sfc/tc.c
index 24c67a163910..4177feced3e6 100644
--- a/drivers/net/ethernet/sfc/tc.c
+++ b/drivers/net/ethernet/sfc/tc.c
@@ -14,11 +14,12 @@
 #include <net/geneve.h>
 #include "tc.h"
 #include "tc_bindings.h"
+#include "tc_encap_actions.h"
 #include "mae.h"
 #include "ef100_rep.h"
 #include "efx.h"
 
-static enum efx_encap_type efx_tc_indr_netdev_type(struct net_device *net_dev)
+enum efx_encap_type efx_tc_indr_netdev_type(struct net_device *net_dev)
 {
 	if (netif_is_vxlan(net_dev))
 		return EFX_ENCAP_TYPE_VXLAN;
@@ -111,6 +112,8 @@ static void efx_tc_free_action_set(struct efx_nic *efx,
 	}
 	if (act->count)
 		efx_tc_flower_put_counter_index(efx, act->count);
+	if (act->encap_md)
+		efx_tc_flower_release_encap_md(efx, act->encap_md);
 	kfree(act);
 }
 
@@ -594,6 +597,7 @@ enum efx_tc_action_order {
 	EFX_TC_AO_VLAN_POP,
 	EFX_TC_AO_VLAN_PUSH,
 	EFX_TC_AO_COUNT,
+	EFX_TC_AO_ENCAP,
 	EFX_TC_AO_DELIVER
 };
 /* Determine whether we can add @new action without violating order */
@@ -623,6 +627,10 @@ static bool efx_tc_flower_action_order_ok(const struct efx_tc_action_set *act,
 		if (act->count)
 			return false;
 		fallthrough;
+	case EFX_TC_AO_ENCAP:
+		if (act->encap_md)
+			return false;
+		fallthrough;
 	case EFX_TC_AO_DELIVER:
 		return !act->deliver;
 	default:
@@ -918,11 +926,13 @@ static int efx_tc_flower_replace(struct efx_nic *efx,
 {
 	struct flow_rule *fr = flow_cls_offload_flow_rule(tc);
 	struct netlink_ext_ack *extack = tc->common.extack;
+	const struct ip_tunnel_info *encap_info = NULL;
 	struct efx_tc_flow_rule *rule = NULL, *old;
 	struct efx_tc_action_set *act = NULL;
 	const struct flow_action_entry *fa;
 	struct efx_rep *from_efv, *to_efv;
 	struct efx_tc_match match;
+	u32 acts_id;
 	s64 rc;
 	int i;
 
@@ -1087,6 +1097,46 @@ static int efx_tc_flower_replace(struct efx_nic *efx,
 		case FLOW_ACTION_MIRRED:
 			save = *act;
 
+			if (encap_info) {
+				struct efx_tc_encap_action *encap;
+
+				if (!efx_tc_flower_action_order_ok(act,
+								   EFX_TC_AO_ENCAP)) {
+					rc = -EOPNOTSUPP;
+					NL_SET_ERR_MSG_MOD(extack, "Encap action violates action order");
+					goto release;
+				}
+				encap = efx_tc_flower_create_encap_md(
+						efx, encap_info, fa->dev, extack);
+				if (IS_ERR_OR_NULL(encap)) {
+					rc = PTR_ERR(encap);
+					if (!rc)
+						rc = -EIO; /* arbitrary */
+					goto release;
+				}
+				act->encap_md = encap;
+				act->dest_mport = encap->dest_mport;
+				act->deliver = 1;
+				rc = efx_mae_alloc_action_set(efx, act);
+				if (rc) {
+					NL_SET_ERR_MSG_MOD(extack, "Failed to write action set to hw (encap)");
+					goto release;
+				}
+				list_add_tail(&act->list, &rule->acts.list);
+				act = NULL;
+				if (fa->id == FLOW_ACTION_REDIRECT)
+					break; /* end of the line */
+				/* Mirror, so continue on with saved act */
+				save.count = NULL;
+				act = kzalloc(sizeof(*act), GFP_USER);
+				if (!act) {
+					rc = -ENOMEM;
+					goto release;
+				}
+				*act = save;
+				break;
+			}
+
 			if (!efx_tc_flower_action_order_ok(act, EFX_TC_AO_DELIVER)) {
 				/* can't happen */
 				rc = -EOPNOTSUPP;
@@ -1150,6 +1200,37 @@ static int efx_tc_flower_replace(struct efx_nic *efx,
 			act->vlan_proto[act->vlan_push] = fa->vlan.proto;
 			act->vlan_push++;
 			break;
+		case FLOW_ACTION_TUNNEL_ENCAP:
+			if (encap_info) {
+				/* Can't specify encap multiple times.
+				 * If you want to overwrite an existing
+				 * encap_info, use an intervening
+				 * FLOW_ACTION_TUNNEL_DECAP to clear it.
+				 */
+				NL_SET_ERR_MSG_MOD(extack, "Tunnel key set when already set");
+				rc = -EINVAL;
+				goto release;
+			}
+			if (!fa->tunnel) {
+				NL_SET_ERR_MSG_MOD(extack, "Tunnel key set is missing key");
+				rc = -EOPNOTSUPP;
+				goto release;
+			}
+			encap_info = fa->tunnel;
+			break;
+		case FLOW_ACTION_TUNNEL_DECAP:
+			if (encap_info) {
+				encap_info = NULL;
+				break;
+			}
+			/* Since we don't support enc_key matches on ingress
+			 * (and if we did there'd be no tunnel-device to give
+			 * us a type), we can't offload a decap that's not
+			 * just undoing a previous encap action.
+			 */
+			NL_SET_ERR_MSG_MOD(extack, "Cannot offload tunnel decap action without tunnel device");
+			rc = -EOPNOTSUPP;
+			goto release;
 		default:
 			NL_SET_ERR_MSG_FMT_MOD(extack, "Unhandled action %u",
 					       fa->id);
@@ -1193,8 +1274,21 @@ static int efx_tc_flower_replace(struct efx_nic *efx,
 		NL_SET_ERR_MSG_MOD(extack, "Failed to write action set list to hw");
 		goto release;
 	}
+	if (from_efv == EFX_EFV_PF)
+		/* PF netdev, so rule applies to traffic from wire */
+		rule->fallback = &efx->tc->facts.pf;
+	else
+		/* repdev, so rule applies to traffic from representee */
+		rule->fallback = &efx->tc->facts.reps;
+	if (!efx_tc_check_ready(efx, rule)) {
+		netif_dbg(efx, drv, efx->net_dev, "action not ready for hw\n");
+		acts_id = rule->fallback->fw_id;
+	} else {
+		netif_dbg(efx, drv, efx->net_dev, "ready for hw\n");
+		acts_id = rule->acts.fw_id;
+	}
 	rc = efx_mae_insert_rule(efx, &rule->match, EFX_TC_PRIO_TC,
-				 rule->acts.fw_id, &rule->fw_id);
+				 acts_id, &rule->fw_id);
 	if (rc) {
 		NL_SET_ERR_MSG_MOD(extack, "Failed to insert rule in hw");
 		goto release_acts;
@@ -1609,6 +1703,9 @@ int efx_init_struct_tc(struct efx_nic *efx)
 
 	mutex_init(&efx->tc->mutex);
 	init_waitqueue_head(&efx->tc->flush_wq);
+	rc = efx_tc_init_encap_actions(efx);
+	if (rc < 0)
+		goto fail_encap_actions;
 	rc = efx_tc_init_counters(efx);
 	if (rc < 0)
 		goto fail_counters;
@@ -1635,6 +1732,8 @@ int efx_init_struct_tc(struct efx_nic *efx)
 fail_encap_match_ht:
 	efx_tc_destroy_counters(efx);
 fail_counters:
+	efx_tc_destroy_encap_actions(efx);
+fail_encap_actions:
 	mutex_destroy(&efx->tc->mutex);
 	kfree(efx->tc->caps);
 fail_alloc_caps:
@@ -1662,6 +1761,7 @@ void efx_fini_struct_tc(struct efx_nic *efx)
 	rhashtable_free_and_destroy(&efx->tc->encap_match_ht,
 				    efx_tc_encap_match_free, NULL);
 	efx_tc_fini_counters(efx);
+	efx_tc_fini_encap_actions(efx);
 	mutex_unlock(&efx->tc->mutex);
 	mutex_destroy(&efx->tc->mutex);
 	kfree(efx->tc->caps);
diff --git a/drivers/net/ethernet/sfc/tc.h b/drivers/net/ethernet/sfc/tc.h
index ae182553514d..5a8f701b05c5 100644
--- a/drivers/net/ethernet/sfc/tc.h
+++ b/drivers/net/ethernet/sfc/tc.h
@@ -25,6 +25,8 @@ static inline bool efx_ipv6_addr_all_ones(struct in6_addr *addr)
 }
 #endif
 
+struct efx_tc_encap_action; /* see tc_encap_actions.h */
+
 struct efx_tc_action_set {
 	u16 vlan_push:2;
 	u16 vlan_pop:2;
@@ -33,6 +35,7 @@ struct efx_tc_action_set {
 	__be16 vlan_tci[2]; /* TCIs for vlan_push */
 	__be16 vlan_proto[2]; /* Ethertypes for vlan_push */
 	struct efx_tc_counter_index *count;
+	struct efx_tc_encap_action *encap_md; /* entry in tc_encap_ht table */
 	u32 dest_mport;
 	u32 fw_id; /* index of this entry in firmware actions table */
 	struct list_head list;
@@ -127,6 +130,7 @@ struct efx_tc_flow_rule {
 	struct rhash_head linkage;
 	struct efx_tc_match match;
 	struct efx_tc_action_set_list acts;
+	struct efx_tc_action_set_list *fallback; /* what to use when unready? */
 	u32 fw_id;
 };
 
@@ -144,6 +148,7 @@ enum efx_tc_rule_prios {
  * @mutex: Used to serialise operations on TC hashtables
  * @counter_ht: Hashtable of TC counters (FW IDs and counter values)
  * @counter_id_ht: Hashtable mapping TC counter cookies to counters
+ * @encap_ht: Hashtable of TC encap actions
  * @encap_match_ht: Hashtable of TC encap matches
  * @match_action_ht: Hashtable of TC match-action rules
  * @reps_mport_id: MAE port allocated for representor RX
@@ -173,6 +178,7 @@ struct efx_tc_state {
 	struct mutex mutex;
 	struct rhashtable counter_ht;
 	struct rhashtable counter_id_ht;
+	struct rhashtable encap_ht;
 	struct rhashtable encap_match_ht;
 	struct rhashtable match_action_ht;
 	u32 reps_mport_id, reps_mport_vport_id;
@@ -194,6 +200,7 @@ struct efx_tc_state {
 
 struct efx_rep;
 
+enum efx_encap_type efx_tc_indr_netdev_type(struct net_device *net_dev);
 int efx_tc_configure_default_rule_rep(struct efx_rep *efv);
 void efx_tc_deconfigure_default_rule(struct efx_nic *efx,
 				     struct efx_tc_flow_rule *rule);
diff --git a/drivers/net/ethernet/sfc/tc_encap_actions.c b/drivers/net/ethernet/sfc/tc_encap_actions.c
new file mode 100644
index 000000000000..c41493e659a3
--- /dev/null
+++ b/drivers/net/ethernet/sfc/tc_encap_actions.c
@@ -0,0 +1,126 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/****************************************************************************
+ * Driver for Solarflare network controllers and boards
+ * Copyright 2023, Advanced Micro Devices, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation, incorporated herein by reference.
+ */
+
+#include "tc_encap_actions.h"
+#include "tc.h"
+#include "mae.h"
+#include <net/vxlan.h>
+#include <net/geneve.h>
+
+static const struct rhashtable_params efx_tc_encap_ht_params = {
+	.key_len	= offsetofend(struct efx_tc_encap_action, key),
+	.key_offset	= 0,
+	.head_offset	= offsetof(struct efx_tc_encap_action, linkage),
+};
+
+static void efx_tc_encap_free(void *ptr, void *__unused)
+{
+	struct efx_tc_encap_action *enc = ptr;
+
+	WARN_ON(refcount_read(&enc->ref));
+	kfree(enc);
+}
+
+int efx_tc_init_encap_actions(struct efx_nic *efx)
+{
+	return rhashtable_init(&efx->tc->encap_ht, &efx_tc_encap_ht_params);
+}
+
+/* Only call this in init failure teardown.
+ * Normal exit should fini instead as there may be entries in the table.
+ */
+void efx_tc_destroy_encap_actions(struct efx_nic *efx)
+{
+	rhashtable_destroy(&efx->tc->encap_ht);
+}
+
+void efx_tc_fini_encap_actions(struct efx_nic *efx)
+{
+	rhashtable_free_and_destroy(&efx->tc->encap_ht, efx_tc_encap_free, NULL);
+}
+
+bool efx_tc_check_ready(struct efx_nic *efx, struct efx_tc_flow_rule *rule)
+{
+	struct efx_tc_action_set *act;
+
+	/* Encap actions can only be offloaded if they have valid
+	 * neighbour info for the outer Ethernet header.
+	 */
+	list_for_each_entry(act, &rule->acts.list, list)
+		if (act->encap_md) /* neigh bindings not implemented yet */
+			return false;
+	return true;
+}
+
+struct efx_tc_encap_action *efx_tc_flower_create_encap_md(
+			struct efx_nic *efx, const struct ip_tunnel_info *info,
+			struct net_device *egdev, struct netlink_ext_ack *extack)
+{
+	enum efx_encap_type type = efx_tc_indr_netdev_type(egdev);
+	struct efx_tc_encap_action *encap, *old;
+	s64 rc;
+
+	if (type == EFX_ENCAP_TYPE_NONE) {
+		/* dest is not an encap device */
+		NL_SET_ERR_MSG_MOD(extack, "Not a (supported) tunnel device but tunnel_key is set");
+		return ERR_PTR(-EOPNOTSUPP);
+	}
+	rc = efx_mae_check_encap_type_supported(efx, type);
+	if (rc < 0) {
+		NL_SET_ERR_MSG_MOD(extack, "Firmware reports no support for this tunnel type");
+		return ERR_PTR(rc);
+	}
+	/* No support yet for Geneve options */
+	if (info->options_len) {
+		NL_SET_ERR_MSG_MOD(extack, "Unsupported tunnel options");
+		return ERR_PTR(-EOPNOTSUPP);
+	}
+	switch (info->mode) {
+	case IP_TUNNEL_INFO_TX:
+		break;
+	case IP_TUNNEL_INFO_TX | IP_TUNNEL_INFO_IPV6:
+		type |= EFX_ENCAP_FLAG_IPV6;
+		break;
+	default:
+		NL_SET_ERR_MSG_FMT_MOD(extack, "Unsupported tunnel mode %u",
+				       info->mode);
+		return ERR_PTR(-EOPNOTSUPP);
+	}
+	encap = kzalloc(sizeof(*encap), GFP_KERNEL_ACCOUNT);
+	if (!encap)
+		return ERR_PTR(-ENOMEM);
+	encap->type = type;
+	encap->key = info->key;
+	old = rhashtable_lookup_get_insert_fast(&efx->tc->encap_ht,
+						&encap->linkage,
+						efx_tc_encap_ht_params);
+	if (old) {
+		/* don't need our new entry */
+		kfree(encap);
+		if (!refcount_inc_not_zero(&old->ref))
+			return ERR_PTR(-EAGAIN);
+		/* existing entry found, ref taken */
+		return old;
+	}
+
+	/* ref and return */
+	refcount_set(&encap->ref, 1);
+	return encap;
+}
+
+void efx_tc_flower_release_encap_md(struct efx_nic *efx,
+				    struct efx_tc_encap_action *encap)
+{
+	if (!refcount_dec_and_test(&encap->ref))
+		return; /* still in use */
+	rhashtable_remove_fast(&efx->tc->encap_ht, &encap->linkage,
+			       efx_tc_encap_ht_params);
+	kfree(encap);
+}
diff --git a/drivers/net/ethernet/sfc/tc_encap_actions.h b/drivers/net/ethernet/sfc/tc_encap_actions.h
new file mode 100644
index 000000000000..1a3679e81f09
--- /dev/null
+++ b/drivers/net/ethernet/sfc/tc_encap_actions.h
@@ -0,0 +1,47 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/****************************************************************************
+ * Driver for Solarflare network controllers and boards
+ * Copyright 2023, Advanced Micro Devices, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation, incorporated herein by reference.
+ */
+
+#ifndef EFX_TC_ENCAP_ACTIONS_H
+#define EFX_TC_ENCAP_ACTIONS_H
+#include "net_driver.h"
+
+#include <linux/refcount.h>
+#include <net/tc_act/tc_tunnel_key.h>
+
+/* This limit is arbitrary; current hardware (SN1022) handles encap headers
+ * of up to 126 bytes, but that limit is not enshrined in the MCDI protocol.
+ */
+#define EFX_TC_MAX_ENCAP_HDR	126
+struct efx_tc_encap_action {
+	enum efx_encap_type type;
+	struct ip_tunnel_key key; /* 52 bytes */
+	u32 dest_mport; /* is copied into struct efx_tc_action_set */
+	u8 encap_hdr_len;
+	u8 encap_hdr[EFX_TC_MAX_ENCAP_HDR];
+	struct rhash_head linkage; /* efx->tc_encap_ht */
+	refcount_t ref;
+	u32 fw_id; /* index of this entry in firmware encap table */
+};
+
+/* create/uncreate/teardown hashtables */
+int efx_tc_init_encap_actions(struct efx_nic *efx);
+void efx_tc_destroy_encap_actions(struct efx_nic *efx);
+void efx_tc_fini_encap_actions(struct efx_nic *efx);
+
+struct efx_tc_flow_rule;
+bool efx_tc_check_ready(struct efx_nic *efx, struct efx_tc_flow_rule *rule);
+
+struct efx_tc_encap_action *efx_tc_flower_create_encap_md(
+			struct efx_nic *efx, const struct ip_tunnel_info *info,
+			struct net_device *egdev, struct netlink_ext_ack *extack);
+void efx_tc_flower_release_encap_md(struct efx_nic *efx,
+				    struct efx_tc_encap_action *encap);
+
+#endif /* EFX_TC_ENCAP_ACTIONS_H */

