Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A8025FD6F1
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 11:23:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbiJMJXq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 05:23:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbiJMJXc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 05:23:32 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2056.outbound.protection.outlook.com [40.107.243.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86B51F53FF
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 02:23:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E+7wTalCYRSPFoa7nAhCW2eTW6vFOayR3kZmTBkpDKE+3Wpz3oVoITeNgMv8KsHDwtWtA79n590SsNOsq78HBdTQWHtc1dSoBgNCpPKMBGAkV/4+pWYBJkH1aX6+ybNC6PAmyqICHgbqACdh1KbMOtgynq15wjqn8krDxaxxJZtYxQfsQQySjcLnF/lLyRIzOqicRvx/C9BtqVjOJzYpSp6NkwPqre8IPAC2tLebZymPWPrvlskaq9RhqtXTW3h+bDPu/ir4MXyOeKCQP2h+EGqTITr+UujTCagkJ4Ia8Wq+/Tm2YuWwoP0q2uZaE9VQ9moVn29vH88++G53KMWECg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IN1+DzckYapOyI+NPaAyLDe9yRI66HV6A853PYDkZU4=;
 b=OqYMoieY8UzHUv+v3M5F7Sexed9iSr+0c0oYX4HWWShwSzRTDMk8LndzTrotQouvZ5Ym/guW8fVvTpZTS/9+AnfwxJSAtCwuMG2qOc7GdqQSIIuXjpZrycESGx7DfrYGQhuFuTprFWLYbvaRIZu6aXYH66gS+9FfR2hfHdFGsNfnbkjdEL7OUGWP9kXnY2LUXpLNjBWvs+mr+k9ALYJSGk2bBSwwH8n8sHLrG3zXL+gkxdbEpdT5Hxth2TsK5SkdjmFlHka6qoB0vOHiAFBaYK5RtPCf6QHnwCuV/FNgJyydvl+8N0n27M3FiBQJNYsCPavCXi5K+B4RbXKLHVH5Ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IN1+DzckYapOyI+NPaAyLDe9yRI66HV6A853PYDkZU4=;
 b=VxQR68n7AvNoOpWo/h+zUtFeWD6KYN/sicPR7jj+e9ImB5ZGgmFdbWWoiObQBL5BhX3RxK2wWNmulIYkPfqspqwo2VWPItIgAPq3n75YNVnj26ylwSuCozgtb9WQCkbJdbKEE1BHxQwv0AcuXtnYh/MT0ac+g0j9qA7wy3/J3es=
Received: from DM6PR13CA0009.namprd13.prod.outlook.com (2603:10b6:5:bc::22) by
 PH0PR12MB5452.namprd12.prod.outlook.com (2603:10b6:510:d7::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5709.21; Thu, 13 Oct 2022 09:23:29 +0000
Received: from DM6NAM11FT009.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:bc:cafe::4) by DM6PR13CA0009.outlook.office365.com
 (2603:10b6:5:bc::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.6 via Frontend
 Transport; Thu, 13 Oct 2022 09:23:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT009.mail.protection.outlook.com (10.13.173.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5723.20 via Frontend Transport; Thu, 13 Oct 2022 09:23:28 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Thu, 13 Oct
 2022 04:23:28 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Thu, 13 Oct
 2022 04:23:27 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Thu, 13 Oct 2022 04:23:26 -0500
From:   <edward.cree@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        <johannes@sipsolutions.net>, <marcelo.leitner@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>
Subject: [RFC PATCH v2 net-next 2/3] sfc: use formatted extacks instead of efx_tc_err()
Date:   Thu, 13 Oct 2022 10:23:01 +0100
Message-ID: <05f7c539b45e1a496c8c678e1c4d46d4ee985005.1665567166.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1665567166.git.ecree.xilinx@gmail.com>
References: <cover.1665567166.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT009:EE_|PH0PR12MB5452:EE_
X-MS-Office365-Filtering-Correlation-Id: 4432275d-a0e4-42c6-75d4-08daacfc96ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vAJ+MlNQh2sOnHayZSZwV3Nswx3h3RJZGZ2MvHuAfmEehsGj6e2AOo78MYDgJLiiaui1e+uo7LxJ4ZBVXIVvtNxjjKxZd7eIpJaOUABSkCr/H8NpAfci+L48m6oItmJ+eKaZQFzH++VVDt3/SbMXapD5gy1RTzJbTVgztWckEcKTzHa+URdm2wcftLKJtmBB/t040XJnIEUkWwaDgU3ZW2f6HNMVGx0LbDTOtAerueDcbDVI+tle1W2QzWrj/yuDjIeWPhPVQs/6/GK/ZGl9QB884Zzdu0Zf3KGzQq0E1DbkWyJTmkJqpE/k8fhouajf6zOAGB85OHLQLtd8H7FrwHkVwnpnQ1Mh4tN7IOpmMRPfRxkX4oawQakUNlYJb57WUG6M2QRfcOFZDV/0lgA6sWZlfcqLRpKzmSRGMGiRjkRLjWB2qnGVTRXUQ2/kjnQnUDHbZG9zTDesC15lqgamJSkOUTpvIldlbTKGi42hpMPSiBo0xe7IOdiH7jrzl54QvOabZUdT+JXlgwPIdGu5ubufu1ijxaYt84XOzv+3Ajo9wfTw0LSPTxgtWSZkGIBPDSnuONKNPTRMPW07Yjjn9ZR7Ir3R9tGxWn6fubiCGKr7PjQJk2dDecuOxTRZj67wBiYaPwidKffechBPb0X0Hz8V+Qoxzv4kzxzk5lWp1KGBvd5Wc4cXEz2IHrxkNC6ZixYfQQl6gPm1V1Lyjf13HqspUeBb6jLaulDUD55sCjot55sWJJTghmAKkYRwZZQ9plj6Ngq1CmejR7KIV5QdXt6yEFzfKewCeUBdqNtqtdA=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(39860400002)(376002)(396003)(451199015)(40470700004)(36840700001)(46966006)(70206006)(336012)(6636002)(8676002)(54906003)(83380400001)(478600001)(110136005)(426003)(36756003)(82310400005)(316002)(356005)(36860700001)(40480700001)(86362001)(55446002)(2876002)(81166007)(47076005)(82740400003)(5660300002)(2906002)(70586007)(4326008)(41300700001)(40460700003)(9686003)(26005)(8936002)(186003)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2022 09:23:28.5317
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4432275d-a0e4-42c6-75d4-08daacfc96ae
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT009.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5452
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree.xilinx@gmail.com>

Since we can now get a formatted message back to the user with
 NL_SET_ERR_MSG_FMT_MOD(), there's no need for our special logging.

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/mae.c |  5 ++--
 drivers/net/ethernet/sfc/tc.c  | 47 +++++++++++++++-------------------
 drivers/net/ethernet/sfc/tc.h  | 18 -------------
 3 files changed, 23 insertions(+), 47 deletions(-)

diff --git a/drivers/net/ethernet/sfc/mae.c b/drivers/net/ethernet/sfc/mae.c
index 874c765b2465..6f472ea0638a 100644
--- a/drivers/net/ethernet/sfc/mae.c
+++ b/drivers/net/ethernet/sfc/mae.c
@@ -265,9 +265,8 @@ int efx_mae_match_check_caps(struct efx_nic *efx,
 	rc = efx_mae_match_check_cap_typ(supported_fields[MAE_FIELD_INGRESS_PORT],
 					 ingress_port_mask_type);
 	if (rc) {
-		efx_tc_err(efx, "No support for %s mask in field ingress_port\n",
-			   mask_type_name(ingress_port_mask_type));
-		NL_SET_ERR_MSG_MOD(extack, "Unsupported mask type for ingress_port");
+		NL_SET_ERR_MSG_FMT_MOD(extack, "No support for %s mask in field ingress_port",
+				       mask_type_name(ingress_port_mask_type));
 		return rc;
 	}
 	return 0;
diff --git a/drivers/net/ethernet/sfc/tc.c b/drivers/net/ethernet/sfc/tc.c
index 3478860d4023..b21a961eabb1 100644
--- a/drivers/net/ethernet/sfc/tc.c
+++ b/drivers/net/ethernet/sfc/tc.c
@@ -137,17 +137,16 @@ static int efx_tc_flower_parse_match(struct efx_nic *efx,
 		flow_rule_match_control(rule, &fm);
 
 		if (fm.mask->flags) {
-			efx_tc_err(efx, "Unsupported match on control.flags %#x\n",
-				   fm.mask->flags);
-			NL_SET_ERR_MSG_MOD(extack, "Unsupported match on control.flags");
+			NL_SET_ERR_MSG_FMT_MOD(extack, "Unsupported match on control.flags %#x",
+					       fm.mask->flags);
 			return -EOPNOTSUPP;
 		}
 	}
 	if (dissector->used_keys &
 	    ~(BIT(FLOW_DISSECTOR_KEY_CONTROL) |
 	      BIT(FLOW_DISSECTOR_KEY_BASIC))) {
-		efx_tc_err(efx, "Unsupported flower keys %#x\n", dissector->used_keys);
-		NL_SET_ERR_MSG_MOD(extack, "Unsupported flower keys encountered");
+		NL_SET_ERR_MSG_FMT_MOD(extack, "Unsupported flower keys %#x",
+				       dissector->used_keys);
 		return -EOPNOTSUPP;
 	}
 
@@ -156,11 +155,11 @@ static int efx_tc_flower_parse_match(struct efx_nic *efx,
 
 		flow_rule_match_basic(rule, &fm);
 		if (fm.mask->n_proto) {
-			EFX_TC_ERR_MSG(efx, extack, "Unsupported eth_proto match\n");
+			NL_SET_ERR_MSG_MOD(extack, "Unsupported eth_proto match");
 			return -EOPNOTSUPP;
 		}
 		if (fm.mask->ip_proto) {
-			EFX_TC_ERR_MSG(efx, extack, "Unsupported ip_proto match\n");
+			NL_SET_ERR_MSG_MOD(extack, "Unsupported ip_proto match");
 			return -EOPNOTSUPP;
 		}
 	}
@@ -200,13 +199,9 @@ static int efx_tc_flower_replace(struct efx_nic *efx,
 
 	if (efv != from_efv) {
 		/* can't happen */
-		efx_tc_err(efx, "for %s efv is %snull but from_efv is %snull\n",
-			   netdev_name(net_dev), efv ? "non-" : "",
-			   from_efv ? "non-" : "");
-		if (efv)
-			NL_SET_ERR_MSG_MOD(extack, "vfrep filter has PF net_dev (can't happen)");
-		else
-			NL_SET_ERR_MSG_MOD(extack, "PF filter has vfrep net_dev (can't happen)");
+		NL_SET_ERR_MSG_FMT_MOD(extack, "for %s efv is %snull but from_efv is %snull (can't happen)",
+				       netdev_name(net_dev), efv ? "non-" : "",
+				       from_efv ? "non-" : "");
 		return -EINVAL;
 	}
 
@@ -214,7 +209,7 @@ static int efx_tc_flower_replace(struct efx_nic *efx,
 	memset(&match, 0, sizeof(match));
 	rc = efx_tc_flower_external_mport(efx, from_efv);
 	if (rc < 0) {
-		EFX_TC_ERR_MSG(efx, extack, "Failed to identify ingress m-port");
+		NL_SET_ERR_MSG_MOD(extack, "Failed to identify ingress m-port");
 		return rc;
 	}
 	match.value.ingress_port = rc;
@@ -224,7 +219,7 @@ static int efx_tc_flower_replace(struct efx_nic *efx,
 		return rc;
 
 	if (tc->common.chain_index) {
-		EFX_TC_ERR_MSG(efx, extack, "No support for nonzero chain_index");
+		NL_SET_ERR_MSG_MOD(extack, "No support for nonzero chain_index");
 		return -EOPNOTSUPP;
 	}
 	match.mask.recirc_id = 0xff;
@@ -261,7 +256,7 @@ static int efx_tc_flower_replace(struct efx_nic *efx,
 
 		if (!act) {
 			/* more actions after a non-pipe action */
-			EFX_TC_ERR_MSG(efx, extack, "Action follows non-pipe action");
+			NL_SET_ERR_MSG_MOD(extack, "Action follows non-pipe action");
 			rc = -EINVAL;
 			goto release;
 		}
@@ -270,7 +265,7 @@ static int efx_tc_flower_replace(struct efx_nic *efx,
 		case FLOW_ACTION_DROP:
 			rc = efx_mae_alloc_action_set(efx, act);
 			if (rc) {
-				EFX_TC_ERR_MSG(efx, extack, "Failed to write action set to hw (drop)");
+				NL_SET_ERR_MSG_MOD(extack, "Failed to write action set to hw (drop)");
 				goto release;
 			}
 			list_add_tail(&act->list, &rule->acts.list);
@@ -281,20 +276,20 @@ static int efx_tc_flower_replace(struct efx_nic *efx,
 			save = *act;
 			to_efv = efx_tc_flower_lookup_efv(efx, fa->dev);
 			if (IS_ERR(to_efv)) {
-				EFX_TC_ERR_MSG(efx, extack, "Mirred egress device not on switch");
+				NL_SET_ERR_MSG_MOD(extack, "Mirred egress device not on switch");
 				rc = PTR_ERR(to_efv);
 				goto release;
 			}
 			rc = efx_tc_flower_external_mport(efx, to_efv);
 			if (rc < 0) {
-				EFX_TC_ERR_MSG(efx, extack, "Failed to identify egress m-port");
+				NL_SET_ERR_MSG_MOD(extack, "Failed to identify egress m-port");
 				goto release;
 			}
 			act->dest_mport = rc;
 			act->deliver = 1;
 			rc = efx_mae_alloc_action_set(efx, act);
 			if (rc) {
-				EFX_TC_ERR_MSG(efx, extack, "Failed to write action set to hw (mirred)");
+				NL_SET_ERR_MSG_MOD(extack, "Failed to write action set to hw (mirred)");
 				goto release;
 			}
 			list_add_tail(&act->list, &rule->acts.list);
@@ -310,9 +305,9 @@ static int efx_tc_flower_replace(struct efx_nic *efx,
 			*act = save;
 			break;
 		default:
-			efx_tc_err(efx, "Unhandled action %u\n", fa->id);
+			NL_SET_ERR_MSG_FMT_MOD(extack, "Unhandled action %u",
+					       fa->id);
 			rc = -EOPNOTSUPP;
-			NL_SET_ERR_MSG_MOD(extack, "Unsupported action");
 			goto release;
 		}
 	}
@@ -334,7 +329,7 @@ static int efx_tc_flower_replace(struct efx_nic *efx,
 		act->deliver = 1;
 		rc = efx_mae_alloc_action_set(efx, act);
 		if (rc) {
-			EFX_TC_ERR_MSG(efx, extack, "Failed to write action set to hw (deliver)");
+			NL_SET_ERR_MSG_MOD(extack, "Failed to write action set to hw (deliver)");
 			goto release;
 		}
 		list_add_tail(&act->list, &rule->acts.list);
@@ -349,13 +344,13 @@ static int efx_tc_flower_replace(struct efx_nic *efx,
 
 	rc = efx_mae_alloc_action_set_list(efx, &rule->acts);
 	if (rc) {
-		EFX_TC_ERR_MSG(efx, extack, "Failed to write action set list to hw");
+		NL_SET_ERR_MSG_MOD(extack, "Failed to write action set list to hw");
 		goto release;
 	}
 	rc = efx_mae_insert_rule(efx, &rule->match, EFX_TC_PRIO_TC,
 				 rule->acts.fw_id, &rule->fw_id);
 	if (rc) {
-		EFX_TC_ERR_MSG(efx, extack, "Failed to insert rule in hw");
+		NL_SET_ERR_MSG_MOD(extack, "Failed to insert rule in hw");
 		goto release_acts;
 	}
 	return 0;
diff --git a/drivers/net/ethernet/sfc/tc.h b/drivers/net/ethernet/sfc/tc.h
index 196fd74ed973..4373c3243e3c 100644
--- a/drivers/net/ethernet/sfc/tc.h
+++ b/drivers/net/ethernet/sfc/tc.h
@@ -15,24 +15,6 @@
 #include <linux/rhashtable.h>
 #include "net_driver.h"
 
-/* Error reporting: convenience macros.  For indicating why a given filter
- * insertion is not supported; errors in internal operation or in the
- * hardware should be netif_err()s instead.
- */
-/* Used when error message is constant. */
-#define EFX_TC_ERR_MSG(efx, extack, message)	do {			\
-	NL_SET_ERR_MSG_MOD(extack, message);				\
-	if (efx->log_tc_errs)						\
-		netif_info(efx, drv, efx->net_dev, "%s\n", message);	\
-} while (0)
-/* Used when error message is not constant; caller should also supply a
- * constant extack message with NL_SET_ERR_MSG_MOD().
- */
-#define efx_tc_err(efx, fmt, args...)	do {		\
-if (efx->log_tc_errs)					\
-	netif_info(efx, drv, efx->net_dev, fmt, ##args);\
-} while (0)
-
 struct efx_tc_action_set {
 	u16 deliver:1;
 	u32 dest_mport;
