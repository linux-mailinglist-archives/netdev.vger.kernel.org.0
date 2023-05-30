Return-Path: <netdev+bounces-6559-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B76A0716E9F
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 22:26:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 610C7281258
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 20:26:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DA1931EFD;
	Tue, 30 May 2023 20:26:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FE5331EFB
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 20:26:31 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2049.outbound.protection.outlook.com [40.107.237.49])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BF8EFC
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 13:26:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=muVs7tb6NPjWufFmQGsvK1PjTSV8LXsoOTdXEwekXrFhYavczHll9VGI276rsTuY46wO4yuxPDNjSlQt1yMB523vHxxG6Mz3ImQdaO8FN7SXfiDX4E90dKy3SzCTgv+XYB8eSkWVMkxp4Oc45fLqQsjHte1oqU+Oq27TFicFnUeHi7Or47OjR4oX+DTb4+nvwTt9b7y7Xn/U+WaxrS7Dt5Vo8Gxkagn75aaIjoMI/w9s+i741uWWu7Jx3BssTLHhhNqpbwYS9Gc7+p3rQF2OnEP0wsyQkbk6zX8gaPYBjOx31UJH71RGDdg45InyyUsNvS+iY5ZnleV6mDajanswhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OHztWEHWTUGlnp/G7LdyxHlNSr5fxdXrVxj8sRvTPEA=;
 b=P8DVAyYJ3gc/WaNlI+lKs1lIGKM47iWXIkoRXNyzEwXviRJV228DjBHXR6NC8dIBiad7pv0tdX3cHoVZR+ndwh68bts0jlyUpZHt/zA2xwKfY5GN7yjUxqsAJfkTVB9p3CgfVCPTfc3rXG2y4o/8mYMYbAAoMwaApT4hrCwcgiUiPRMxA5UbRrT4GOD5tiCpp3EsRHFiDiG7UooA7cScrY0C3NnYzSMD/XDlBYdlDD0Vg0bOxz3NfMg6clIU2U5LNWSYVTwg8WfwZeq+6uVm8a4T7g4kk1VYMKmRcchn04Qy+j1yQdSa35ntHyqB2QAME8SQfUuYQ0PU3+dKaB07Yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OHztWEHWTUGlnp/G7LdyxHlNSr5fxdXrVxj8sRvTPEA=;
 b=m0prt3KETr779aUQhnGonNL8m2mPZL9u0AgHcJVZVNlH/u4BHHJx4w5uph1Y6qV6rO0dbL71Z8SdGsS9fIYOm/BlSZ2el9pkcpkZF2IhAt8Tsb+Ew93TB2CiJyM0r3XIj7rgkTo9akKy/9535qOODIBwOkYwKWN29wnSl3/9Q3o=
Received: from SJ0PR05CA0002.namprd05.prod.outlook.com (2603:10b6:a03:33b::7)
 by CY5PR12MB6299.namprd12.prod.outlook.com (2603:10b6:930:20::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.22; Tue, 30 May
 2023 20:26:26 +0000
Received: from DM6NAM11FT101.eop-nam11.prod.protection.outlook.com
 (2603:10b6:a03:33b:cafe::b3) by SJ0PR05CA0002.outlook.office365.com
 (2603:10b6:a03:33b::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.22 via Frontend
 Transport; Tue, 30 May 2023 20:26:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT101.mail.protection.outlook.com (10.13.172.208) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6455.22 via Frontend Transport; Tue, 30 May 2023 20:26:25 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 30 May
 2023 15:26:25 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 30 May
 2023 13:26:24 -0700
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34 via Frontend
 Transport; Tue, 30 May 2023 15:26:22 -0500
From: <edward.cree@amd.com>
To: <linux-net-drivers@amd.com>, <davem@davemloft.net>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <edumazet@google.com>
CC: Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>,
	<habetsm.xilinx@gmail.com>, <dan.carpenter@linaro.org>,
	<oe-kbuild-all@lists.linux.dev>, kernel test robot <lkp@intel.com>, "Dan
 Carpenter" <error27@gmail.com>
Subject: [PATCH net] sfc: fix error unwinds in TC offload
Date: Tue, 30 May 2023 21:25:27 +0100
Message-ID: <20230530202527.53115-1-edward.cree@amd.com>
X-Mailer: git-send-email 2.27.0
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT101:EE_|CY5PR12MB6299:EE_
X-MS-Office365-Filtering-Correlation-Id: 52680f6e-f09b-4565-503b-08db614c243a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	TQ6g03sr7/6Ne/r3aiGzw2TR5Zq761VFB8Gm5MIdF/caDuY8s1o2MRTmhaZHAn9ZOayajDd+Lyz2lRdBLqvPC3KtxLkEvhcpov7uQQma9cjzkuD1ew7FIhiIMC388GD7sO5K9HexJzhgjjWzoMSguSy/zAcCz+zoBAtBDkbIdbNAQDm5jh9hFpnQ1Qi08f+rKF6DhkwDmz/efLzWRlQ3hPhnyY62Ze9ljHkltNRdXO6HBVUdm/vUVHT3Q8B5hkVlWdafCLaRltx/u28Su5UYJh3YPitdyjMtMQKneLKSLo3Tg258sATbjUMLb5PnUdjhsRZF9GtdQuOQzlQS+0R75OfGL7C4cXvN0FlzDWutqDw4RHACW3Q+jbnw4SQJZXmFHgViiUgQ2fI4Qdo4BakldBPpOwgjPF0hCIsYODsKesTaVq/saohOx36Gf7PjsI/wZH95+80cO64+T3Opz9fZer6fafj3QrHMty1tndQQV5Xio4cX/Fxj9hiDgZ5am6jVp/bxVwzdk3aeciFk3aISxhLPeqyY7ozafLi3P5Tgnx6X75Z2/DZiRONr/jio3gw87wFJuHFGkoV1UJaep/Vrn0HviOF0/DOYe31IDcskz5uv5QxRfEWXjFe8aPfqPvFNo6Ngbp96BRRLM5Vw2R4/Xpcwi+a2LzxYCpbW6o3JGPUSQOboa+F+GiQ7ZOnIx8eu7i/MchrCafmap4xRR063bEo2FGKZdulFmd+ooPH1KzVRgfuZVXlAurDUqbcN7wijNniUfov+dKN2hGmadbUQyg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(396003)(376002)(136003)(451199021)(46966006)(36840700001)(40470700004)(36860700001)(83380400001)(36756003)(47076005)(86362001)(426003)(478600001)(2876002)(336012)(70206006)(70586007)(4326008)(110136005)(2616005)(54906003)(2906002)(186003)(81166007)(966005)(1076003)(356005)(316002)(82310400005)(7416002)(40460700003)(26005)(5660300002)(8676002)(82740400003)(40480700001)(8936002)(41300700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 20:26:25.5486
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 52680f6e-f09b-4565-503b-08db614c243a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM6NAM11FT101.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6299
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Edward Cree <ecree.xilinx@gmail.com>

Failure ladders weren't exactly unwinding what the function had done up
 to that point; most seriously, when we encountered an already offloaded
 rule, the failure path tried to remove the new rule from the hashtable,
 which would in fact remove the already-present 'old' rule (since it has
 the same key) from the table, and leak its resources.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/r/202305200745.xmIlkqjH-lkp@intel.com/
Fixes: d902e1a737d4 ("sfc: bare bones TC offload on EF100")
Fixes: 17654d84b47c ("sfc: add offloading of 'foreign' TC (decap) rules")
Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/tc.c | 27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/sfc/tc.c b/drivers/net/ethernet/sfc/tc.c
index 0327639a628a..c004443c1d58 100644
--- a/drivers/net/ethernet/sfc/tc.c
+++ b/drivers/net/ethernet/sfc/tc.c
@@ -624,13 +624,12 @@ static int efx_tc_flower_replace_foreign(struct efx_nic *efx,
 	if (!found) { /* We don't care. */
 		netif_dbg(efx, drv, efx->net_dev,
 			  "Ignoring foreign filter that doesn't egdev us\n");
-		rc = -EOPNOTSUPP;
-		goto release;
+		return -EOPNOTSUPP;
 	}
 
 	rc = efx_mae_match_check_caps(efx, &match.mask, NULL);
 	if (rc)
-		goto release;
+		return rc;
 
 	if (efx_tc_match_is_encap(&match.mask)) {
 		enum efx_encap_type type;
@@ -639,8 +638,7 @@ static int efx_tc_flower_replace_foreign(struct efx_nic *efx,
 		if (type == EFX_ENCAP_TYPE_NONE) {
 			NL_SET_ERR_MSG_MOD(extack,
 					   "Egress encap match on unsupported tunnel device");
-			rc = -EOPNOTSUPP;
-			goto release;
+			return -EOPNOTSUPP;
 		}
 
 		rc = efx_mae_check_encap_type_supported(efx, type);
@@ -648,25 +646,24 @@ static int efx_tc_flower_replace_foreign(struct efx_nic *efx,
 			NL_SET_ERR_MSG_FMT_MOD(extack,
 					       "Firmware reports no support for %s encap match",
 					       efx_tc_encap_type_name(type));
-			goto release;
+			return rc;
 		}
 
 		rc = efx_tc_flower_record_encap_match(efx, &match, type,
 						      extack);
 		if (rc)
-			goto release;
+			return rc;
 	} else {
 		/* This is not a tunnel decap rule, ignore it */
 		netif_dbg(efx, drv, efx->net_dev,
 			  "Ignoring foreign filter without encap match\n");
-		rc = -EOPNOTSUPP;
-		goto release;
+		return -EOPNOTSUPP;
 	}
 
 	rule = kzalloc(sizeof(*rule), GFP_USER);
 	if (!rule) {
 		rc = -ENOMEM;
-		goto release;
+		goto out_free;
 	}
 	INIT_LIST_HEAD(&rule->acts.list);
 	rule->cookie = tc->cookie;
@@ -678,7 +675,7 @@ static int efx_tc_flower_replace_foreign(struct efx_nic *efx,
 			  "Ignoring already-offloaded rule (cookie %lx)\n",
 			  tc->cookie);
 		rc = -EEXIST;
-		goto release;
+		goto out_free;
 	}
 
 	act = kzalloc(sizeof(*act), GFP_USER);
@@ -843,6 +840,7 @@ static int efx_tc_flower_replace_foreign(struct efx_nic *efx,
 				       efx_tc_match_action_ht_params);
 		efx_tc_free_action_set_list(efx, &rule->acts, false);
 	}
+out_free:
 	kfree(rule);
 	if (match.encap)
 		efx_tc_flower_release_encap_match(efx, match.encap);
@@ -899,8 +897,7 @@ static int efx_tc_flower_replace(struct efx_nic *efx,
 		return rc;
 	if (efx_tc_match_is_encap(&match.mask)) {
 		NL_SET_ERR_MSG_MOD(extack, "Ingress enc_key matches not supported");
-		rc = -EOPNOTSUPP;
-		goto release;
+		return -EOPNOTSUPP;
 	}
 
 	if (tc->common.chain_index) {
@@ -924,9 +921,9 @@ static int efx_tc_flower_replace(struct efx_nic *efx,
 	if (old) {
 		netif_dbg(efx, drv, efx->net_dev,
 			  "Already offloaded rule (cookie %lx)\n", tc->cookie);
-		rc = -EEXIST;
 		NL_SET_ERR_MSG_MOD(extack, "Rule already offloaded");
-		goto release;
+		kfree(rule);
+		return -EEXIST;
 	}
 
 	/* Parse actions */

