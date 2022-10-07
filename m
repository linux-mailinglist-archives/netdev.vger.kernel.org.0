Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C59145F78E8
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 15:26:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbiJGN0F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 09:26:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbiJGN0B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 09:26:01 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2060.outbound.protection.outlook.com [40.107.220.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76E718049C
        for <netdev@vger.kernel.org>; Fri,  7 Oct 2022 06:26:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nipVv59nm9X5qr5wh49ygMVBnZBheHB2HjGcfT/gXmo5HMYEsGdGkj9UAqQOUaxotzGnv709CLaIXbaDK2oaa8v92gzUQOa5Q2jpriTkm+JdbGjNKxReTW7mRGMP8Cemu3FGyEWkZW/PUgSBbNSpqlgvO1tKfOK4PWpHWdaiaedHPC8eVdzy3Cd1+lUqdD3kUAOlBpa9JmkycbMkfm91lQlzDOSVbHgBVggSAe+DpEcXyrRRYV9KZ0SJ6iTlIEZHWdDSvCzKtq6YP0gv0bJzIH9KW/f8iVJmfruj1M/oOrKXJoiZVtIRttWHYgk1UGMim29rHB6O9OH+yLtqMsw+pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IN1+DzckYapOyI+NPaAyLDe9yRI66HV6A853PYDkZU4=;
 b=NdH//rwisjoMnjM3wRP5xHCTPmTPzay/gDc1+pFYvxQekam/63F0p8qtQGR25h1zYfk/+GvCSpCtbJgcrTOBNi/AaqUF+aMj+TuaYKUnMHy+CIJ0VnprpM9JFGGbV1inaSjUtTCXXj0PXpY8pkozDKh6Id/jP/WsERxvvSRQubl52UZRPIynmc5QLl1hyfQsobUORL8C6UyGugbd3o5/8v9HIVK0p5w/1vcbmUlJ04Q7qVkD75+qF/hAC1RmimVfJTzEp+v2aAHh//n3DUMKMwGbxx6pAQFN51iD61/lrUMdiOFpZGdMn3uY5VMpJpHVPgU8+jhlS9zHp+1J8i8X6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IN1+DzckYapOyI+NPaAyLDe9yRI66HV6A853PYDkZU4=;
 b=izbxSocgjuwcaE0RshHZFDzBxWofUKCqij3aoM2QaD2fpX8z2dcQpiOTT7c5YxHVy+vXi1yXPl/aqMo1ajHiXPLAHz+UASxG8BojMbol4LeHCT/4seH5n3MvI6hxoOhNYz0OxGPrfst7eZIZpbugveOg52G8me7EPfBVm8zspo8m8IxqgWpmHb6DCD7/ZFdByXtOCPKn0JGR4oEEwz3WEogCq8dtdChpWam6qpbOptIsX0gF/qFztyoVcqgTSHBzH0swESkDm6g+lAxAL2ILHUeQPPd3GiFjuUHk22dDwDsbOKhkR3Rssw2WVjUMND+bLlXsYGOoCQ91M92wlo8OKw==
Received: from DS7PR03CA0274.namprd03.prod.outlook.com (2603:10b6:5:3ad::9) by
 DM4PR12MB7624.namprd12.prod.outlook.com (2603:10b6:8:107::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.20; Fri, 7 Oct 2022 13:25:58 +0000
Received: from DM6NAM11FT029.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3ad:cafe::af) by DS7PR03CA0274.outlook.office365.com
 (2603:10b6:5:3ad::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.24 via Frontend
 Transport; Fri, 7 Oct 2022 13:25:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT029.mail.protection.outlook.com (10.13.173.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5709.10 via Frontend Transport; Fri, 7 Oct 2022 13:25:58 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Fri, 7 Oct
 2022 08:25:57 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Fri, 7 Oct
 2022 08:25:57 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Fri, 7 Oct 2022 08:25:55 -0500
From:   <ecree@xilinx.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        <johannes@sipsolutions.net>, <marcelo.leitner@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>
Subject: [RFC PATCH net-next 2/3] sfc: use formatted extacks instead of efx_tc_err()
Date:   Fri, 7 Oct 2022 14:25:13 +0100
Message-ID: <ec31be4462834cd36d11456b5eff7b1cf207efe6.1665147129.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1665147129.git.ecree.xilinx@gmail.com>
References: <cover.1665147129.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT029:EE_|DM4PR12MB7624:EE_
X-MS-Office365-Filtering-Correlation-Id: ae7b0a5e-4fbc-422f-54af-08daa8677878
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V2rq1hIfpCEIjchaLdZEtxT4tySPYBWiRDrIOPgnZNcFcRFF03YoCvmL5NG9ovnuAmKcc9QL7y77RugZYrjSe6V7Hd4SoAyeCepv6G5ItnkPABuA2q1ynASKkQIwi++Xje/6vvagzH6Q442JoG0P1ITSCfTG6q6FhN9day5B7EaLCiZSXG4FKXjEzQ9y5Ob1An+nKugON9F5ZBlyEz8fHtpgRoBn4zqPsfuxqTnfmkdbqUx0F/XVxpQ9zA4k+9ygsl1tAmCMUzKwuc9GvEIVbKf6Ay4pjVZzu463aI/Rx79idyrEuV6slG0RMo7fKzoCSuU6CRLTPVHrIaaR4GaY3HyqhXAL02CvA0GcqL6Q78ObaELLF2q4hq3HX63TF3yKhp2by785kuStHFTXor8T02bKeUqNOl1iFhVvotAsD8YQtsCbsV20OtCdbTtdGbQ+OwWUeoPvdo6h3URJB6eGgfgHFWVlM6WilkU5mcPxEpbqwswXshEPYiz9BZ2IQ9hpMzachTGiiMws3tkf/nFkAQ3vuL99TOA3TZVmoskuBhRs+pIJogOv3pEk4KfwPD4T4DVCBfXHkwWus06GeBZaeiZIeBefw4/bltR33FhznsqTZAeUyVID/g+tT6Da0PqfEdaKjU9HVz34Jc7bVRXQ4HZ0AD5VsZQxcdB1G8ZUuL+dCOpkI88Rzu4nEe6TXcmTwG4a2+ZdWYE/Pe11s3ed1cmu6Z/uaJvITj9qBjbvIPQlDgWVhR38R+kca5aRvMj0SDuMEITWtoYHAJrAlaIf6/cplMuxyTXblFWm1ROoxwg=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(376002)(346002)(136003)(451199015)(40470700004)(46966006)(36840700001)(55446002)(186003)(336012)(83380400001)(47076005)(82740400003)(81166007)(83170400001)(36860700001)(356005)(5660300002)(42882007)(9686003)(2906002)(8936002)(54906003)(110136005)(41300700001)(70206006)(40480700001)(40460700003)(6666004)(4326008)(8676002)(316002)(26005)(478600001)(70586007)(82310400005)(2876002)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2022 13:25:58.1658
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ae7b0a5e-4fbc-422f-54af-08daa8677878
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT029.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7624
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=no
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
