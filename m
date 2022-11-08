Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 514D9621A81
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 18:26:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234504AbiKHR0f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 12:26:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234483AbiKHR03 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 12:26:29 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2081.outbound.protection.outlook.com [40.107.223.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C07731E705
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 09:26:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XQR9IQL8lHwWeVnbEegJFwwTTWl5aPYFLDUFkBjt/swbJ4ZmCFJ6IvYe+x4j9MWZoG1VDLUNnIBFcfsIHlrPQqVhcDf4sex6XkI2BHcX0it7a465Bh3WzMLl99RUPoTW4KxwKljv4i/KQSKIgqIS+nQbswPkZrGpiRoyr7CUcr7W6FBb0ClEKiXqZktEuf+HgsB2XJdXnKsFrKW/yQre6gMYkzIm8WuKUUk8Y6s/t4BLFUh8pJE4SOIUZtxwrIP+vvSNytcKK6+xuM+OUDWPtY0YbCeAM3h+KqDbCgoGKDCL8QjqFVTMsh6q8x9fyrw0gy54t1vCJWpFOQ0hNdsx0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TGbFE90OGRjXfO9F94XuGIR3qOHb4ykwxgjQ3899dZA=;
 b=cOt2fDilHhqvuuG41z/mA/4t8fbpzpeTiujxM+/u1ujc1blbgWPXBu72yRgkX94fIurnIceKMitjzUzI6ZiupyFol1XqgltjDu5BDwT+eNjA5hvK3w97StdlnaYB0W4xx16Hc+bkhwhkMNsDrtZXrW7rWVJmc2ExIyTj7R+/q1Yex09NrEfgmY0o5yfh8iN/XxEqPTZVJkuNZeOylFcz4KpI9v3MFWDA9yg68kDpIJWc43isztg4ru6pbpYQyAPbtG7olEomGI5mKY3EaTTcdGD7JTYR+2zsWDzCUgEwDVhpGToQjsUk28rGpv13xCHdF8I1vADxMVlRkA92lPJXtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TGbFE90OGRjXfO9F94XuGIR3qOHb4ykwxgjQ3899dZA=;
 b=4g3TaCe0alAPu4kifJw2jdjbN7dj8YJ7xEkcwL0ZiI9QK3vfzEzJt2lR/1SlJT8EBO4iOBylnRXHXAClI/gdgoqEivo42p45RD3EV1JSVmd4hGQs27ERtZukjjHARlMJhng0XlnjmbwRzITjo5R6318QMhqR8p9jnVHYFbof7ds=
Received: from MW4PR02CA0003.namprd02.prod.outlook.com (2603:10b6:303:16d::30)
 by CO6PR12MB5475.namprd12.prod.outlook.com (2603:10b6:5:354::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Tue, 8 Nov
 2022 17:26:24 +0000
Received: from CO1NAM11FT047.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:16d:cafe::39) by MW4PR02CA0003.outlook.office365.com
 (2603:10b6:303:16d::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27 via Frontend
 Transport; Tue, 8 Nov 2022 17:26:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT047.mail.protection.outlook.com (10.13.174.132) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5791.20 via Frontend Transport; Tue, 8 Nov 2022 17:26:24 +0000
Received: from SATLEXMB07.amd.com (10.181.41.45) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 8 Nov
 2022 11:26:24 -0600
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB07.amd.com
 (10.181.41.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 8 Nov
 2022 09:26:23 -0800
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31 via Frontend
 Transport; Tue, 8 Nov 2022 11:26:22 -0600
From:   <edward.cree@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH net-next 09/11] sfc: attach an MAE counter to TC actions that need it
Date:   Tue, 8 Nov 2022 17:24:50 +0000
Message-ID: <71a61a05259ecd0390ccf0e38ccf2bd755697b37.1667923490.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1667923490.git.ecree.xilinx@gmail.com>
References: <cover.1667923490.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT047:EE_|CO6PR12MB5475:EE_
X-MS-Office365-Filtering-Correlation-Id: 92cd9fe4-c7c5-4702-7674-08dac1ae5ca0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xx+T9u3V+BVBeIGGhS3diNaW5KDyWQFwBYjpuonhRN26Wz02+ANLAwetBOZyptG1toeDxusq4USUb4w2usrU00+vuwKkyKMPxsKJ8guNl5KAJ/Bq36BeSdVMAjR0zLjWZbt88tLGCe/FwTmlAClwRFPx3B1Ojctwce0GFrkdyMDKErovs9hilIcIA+rZyUTyTQvPWzW92qHFoG4pl6krHIiCTjKkdUlaWKJ1ghV7PmwP+a3RNxI1+uyX038T2WxEHIvCD4CVzeIsbGj5jPB9lkF8Z48xE5EwW2nRfke+JaO53LZNX5yaEZe3NO0jPJUUAmFkHVar8ZuXof+48c7QQ2NLYKkTq2rCme5+7SEPEgAGrUN/MHq/sZ3Bg2YYhGL2fMspsEgsvB3/SK2QMaYuw4FZ6Efuo4jf8Q1cwziXby1zQrqoQibjeL+0n6hq1Tv/cdAEKwb5j9SZaL1GYox7W4ExDQQgVgY1B32wudkZMSiAR87RreXtmCa8MjBhqaXf/i+hVeAQZntZX9jD2CzeXCNajAuULJhFeQkLvRAHr75G5tXCyOO8AxtfuLq2YCoMZ2vnpYnVZuCpHgyue344h7vRG66cm8CGNamqIWoBYP+DEfGgM6O2o48SS8kago47b0sDTnwbLGhIT9kbYuhCFJ5hL9CqkcBKgb1O4WgItWgnDeyZzFEBXf1yhqMXOnp54psUOpVjZdnbia+2WH3N14w46WOZ94Kc4YVI5Um7/dpclO5hXvfcwhL2M81dNp2p/BabHWEBe0vjiRs8yIAl/XkBBA7RG5XwFYPDNXQXuIk=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(39860400002)(346002)(136003)(451199015)(36840700001)(46966006)(40470700004)(82740400003)(186003)(336012)(426003)(47076005)(26005)(9686003)(36860700001)(2876002)(83380400001)(2906002)(5660300002)(40460700003)(54906003)(110136005)(82310400005)(6636002)(40480700001)(6666004)(8676002)(4326008)(8936002)(41300700001)(478600001)(316002)(70586007)(70206006)(81166007)(356005)(55446002)(86362001)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2022 17:26:24.7430
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 92cd9fe4-c7c5-4702-7674-08dac1ae5ca0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT047.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5475
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

The only actions that expect stats (that sfc HW supports) are gact shot
 (drop), mirred redirect and mirred mirror.  Since these are 'deliverish'
 actions that end an action-set, we only require at most one counter per
 action-set.

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/mae.c |  8 ++++++--
 drivers/net/ethernet/sfc/tc.c  | 25 +++++++++++++++++++++++++
 drivers/net/ethernet/sfc/tc.h  |  1 +
 3 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/sfc/mae.c b/drivers/net/ethernet/sfc/mae.c
index f227b4f2a9a0..583baf69981c 100644
--- a/drivers/net/ethernet/sfc/mae.c
+++ b/drivers/net/ethernet/sfc/mae.c
@@ -501,8 +501,12 @@ int efx_mae_alloc_action_set(struct efx_nic *efx, struct efx_tc_action_set *act)
 		       MC_CMD_MAE_MAC_ADDR_ALLOC_OUT_MAC_ID_NULL);
 	MCDI_SET_DWORD(inbuf, MAE_ACTION_SET_ALLOC_IN_DST_MAC_ID,
 		       MC_CMD_MAE_MAC_ADDR_ALLOC_OUT_MAC_ID_NULL);
-	MCDI_SET_DWORD(inbuf, MAE_ACTION_SET_ALLOC_IN_COUNTER_ID,
-		       MC_CMD_MAE_COUNTER_ALLOC_OUT_COUNTER_ID_NULL);
+	if (act->count && !WARN_ON(!act->count->cnt))
+		MCDI_SET_DWORD(inbuf, MAE_ACTION_SET_ALLOC_IN_COUNTER_ID,
+			       act->count->cnt->fw_id);
+	else
+		MCDI_SET_DWORD(inbuf, MAE_ACTION_SET_ALLOC_IN_COUNTER_ID,
+			       MC_CMD_MAE_COUNTER_ALLOC_OUT_COUNTER_ID_NULL);
 	MCDI_SET_DWORD(inbuf, MAE_ACTION_SET_ALLOC_IN_COUNTER_LIST_ID,
 		       MC_CMD_MAE_COUNTER_LIST_ALLOC_OUT_COUNTER_LIST_ID_NULL);
 	MCDI_SET_DWORD(inbuf, MAE_ACTION_SET_ALLOC_IN_ENCAP_HEADER_ID,
diff --git a/drivers/net/ethernet/sfc/tc.c b/drivers/net/ethernet/sfc/tc.c
index 8ea7f5213049..1cfc50f2398e 100644
--- a/drivers/net/ethernet/sfc/tc.c
+++ b/drivers/net/ethernet/sfc/tc.c
@@ -77,6 +77,8 @@ static void efx_tc_free_action_set(struct efx_nic *efx,
 		 */
 		list_del(&act->list);
 	}
+	if (act->count)
+		efx_tc_flower_put_counter_index(efx, act->count);
 	kfree(act);
 }
 
@@ -376,6 +378,28 @@ static int efx_tc_flower_replace(struct efx_nic *efx,
 			goto release;
 		}
 
+		if ((fa->id == FLOW_ACTION_REDIRECT ||
+		     fa->id == FLOW_ACTION_MIRRED ||
+		     fa->id == FLOW_ACTION_DROP) && fa->hw_stats) {
+			struct efx_tc_counter_index *ctr;
+
+			if (!(fa->hw_stats & FLOW_ACTION_HW_STATS_DELAYED)) {
+				NL_SET_ERR_MSG_FMT_MOD(extack, "hw_stats_type %u not supported (only 'delayed')",
+						       fa->hw_stats);
+				rc = -EOPNOTSUPP;
+				goto release;
+			}
+
+			ctr = efx_tc_flower_get_counter_index(efx, tc->cookie,
+							      EFX_TC_COUNTER_TYPE_AR);
+			if (IS_ERR(ctr)) {
+				rc = PTR_ERR(ctr);
+				NL_SET_ERR_MSG_MOD(extack, "Failed to obtain a counter");
+				goto release;
+			}
+			act->count = ctr;
+		}
+
 		switch (fa->id) {
 		case FLOW_ACTION_DROP:
 			rc = efx_mae_alloc_action_set(efx, act);
@@ -412,6 +436,7 @@ static int efx_tc_flower_replace(struct efx_nic *efx,
 			if (fa->id == FLOW_ACTION_REDIRECT)
 				break; /* end of the line */
 			/* Mirror, so continue on with saved act */
+			save.count = NULL;
 			act = kzalloc(sizeof(*act), GFP_USER);
 			if (!act) {
 				rc = -ENOMEM;
diff --git a/drivers/net/ethernet/sfc/tc.h b/drivers/net/ethernet/sfc/tc.h
index 6c8ebb2d79c0..418ce8c13a06 100644
--- a/drivers/net/ethernet/sfc/tc.h
+++ b/drivers/net/ethernet/sfc/tc.h
@@ -20,6 +20,7 @@
 
 struct efx_tc_action_set {
 	u16 deliver:1;
+	struct efx_tc_counter_index *count;
 	u32 dest_mport;
 	u32 fw_id; /* index of this entry in firmware actions table */
 	struct list_head list;
