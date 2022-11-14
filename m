Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0F45628111
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 14:17:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237942AbiKNNRS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 08:17:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237992AbiKNNQ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 08:16:57 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF94C2C101
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 05:16:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B37tPj9zY+pf1XNkLV1ms66RTFr8kOdZATHF4uV4n3G6VJYPRsxENcg+KvkHA6LGalmfvkFEas0JiRQkNqc5T3pjPE478PboR0AKzz+JCUTCIa0TtNQf6H1mimJy3HBd22u3yb6PB8+a51pMf0mC8QiuAJ2phv5BGU3xOkNOAhQ4u5l/6gBG3gkuIlh1AeKkaltbNl6tMewrfgE9dDme4mXrJrPs/k+Ei28WMkFxzHNBXPmzUHRqykDu6aOAZnazo+Eu7adTIHUXumjG82uBpCFbHuhJFN+U75KS2rZb00NPulfDAKrdgbul++9Ya5XwwzDQ0o7ntAzml9cy7Q8nAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TGbFE90OGRjXfO9F94XuGIR3qOHb4ykwxgjQ3899dZA=;
 b=B6UZ4KoQih9jtEk/Tj/bHdsASK/v3DzVB/WXJlB8WeqBgdQKgIlneh3mh+H4zHXzzYtbxKo0Xc4Ih1+mkHwwgMABTec6t4vJ+vXd3ykxzQ9ShwBJbBkdsVXX7nsVa7akeN5d4neGeshpalrmOCqdaMxH7kW9iZ+v5gFXNQj7eYSDBjDj1yN78KKQtH6+REkNuMLzR/Dr3gBO9wesC50aDasro83T21Vje9/acvI/qoXp2Io/UE6keaCh25QV6l2fIHATqXpIz0chil/FVK7GQ6FokB0ylKonzMoWoZtEjcQrL/4SVIF2c65ksSw0EjLNXZSNTGSfpzlMNkzfH+STWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TGbFE90OGRjXfO9F94XuGIR3qOHb4ykwxgjQ3899dZA=;
 b=D42fPyEb4Kqa5DUwal0MX8Sol+gV8hOljKnHQffnGVc5UmXdLOt9e5y4WGBQTakwrpt772EKZm7UErMQJvUQBowJvGwtuUNvKvTeOT8e0bJVogaZnQYcpgheuPUe327N18+vEmP6d693A1ATeXn/D2CyQQ1WDWZXn383xePD1+0=
Received: from BN9PR03CA0327.namprd03.prod.outlook.com (2603:10b6:408:112::32)
 by DS7PR12MB6333.namprd12.prod.outlook.com (2603:10b6:8:96::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Mon, 14 Nov
 2022 13:16:32 +0000
Received: from BN8NAM11FT100.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:112:cafe::9e) by BN9PR03CA0327.outlook.office365.com
 (2603:10b6:408:112::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17 via Frontend
 Transport; Mon, 14 Nov 2022 13:16:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN8NAM11FT100.mail.protection.outlook.com (10.13.177.100) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5813.12 via Frontend Transport; Mon, 14 Nov 2022 13:16:32 +0000
Received: from SATLEXMB07.amd.com (10.181.41.45) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 14 Nov
 2022 07:16:29 -0600
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB07.amd.com
 (10.181.41.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 14 Nov
 2022 05:16:29 -0800
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34 via Frontend
 Transport; Mon, 14 Nov 2022 07:16:27 -0600
From:   <edward.cree@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH v2 net-next 10/12] sfc: attach an MAE counter to TC actions that need it
Date:   Mon, 14 Nov 2022 13:15:59 +0000
Message-ID: <7a8004a914c9010677b2f058d473a84652f1851d.1668430870.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1668430870.git.ecree.xilinx@gmail.com>
References: <cover.1668430870.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT100:EE_|DS7PR12MB6333:EE_
X-MS-Office365-Filtering-Correlation-Id: b8c1c1d3-845e-45f7-97ef-08dac6427313
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: akGX+36qfyvczBiEL+CtpZ7xSrVg9/GfAsMBUvvYydpHHK0iVso4PeebUanbG/Q4kVMTsw0aKCTV934927eGrNh2qhZamRGxTcvqEe5bfGjuMVT5hiFXm0P3a8T9CgLerK7duVe4sd4T/wpkds7ikEwt/3ZcQ/K9Zf4I/UaJU+U1w2OfqU1T+ypjWawrbzaYrNKqUJQGf8k0RcH9+avI4CL/s0vrDU+qx3gFs5psZTX01GrKAETfYbRsLUv/swW/uoI1wQStS38ygUp78iLyl0rS8ULaqLJx4uLomsP4k7GBxGXg7c0mNXl7xZblDQHooM0j6EAXNRCpkOv8eUjq6tGRzUk+7F1VODIfzI+jEinQR4o6OtdITCoiIntEUO5taVTNKupUsE1z6MEXjvg/2mNrfNnvQ3LGTP+5LACJRx2IuebQAIANz0Fla0bjdeJ6stY8NiZM9QAlLyZelonMA5LHomHURkd/zYOA7WgcWF145sXeyWDfmBxzWbNI8DHy/cm6YgDnX3oFFYOUqn7uAxhLrqBnbs8w/rUoqFpGknezZckvZUTQ2E4FSYs5hOkMKKROusBb4NOBmdIjEomqsOPoNBoCvtdRwzBhFweTlnxqtfgUTl6Xo6EBCZDaAeszQ1g8sbTFvTVw0Dg9qIl0Yx4pVRA24LHrzG3QzKa4gysdS/PhTmyF+e6yc0OyKJpWQs98wpJTQicT/NZsFZVcZTC0hMEub0P5JWCiB30h+6NQ/pWBtmY1IsZ2O1femja2owL0n7NiPvECwQpc5sy0AWR10wU6C7L9gRpW6XiaQTI=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(346002)(396003)(136003)(451199015)(36840700001)(40470700004)(46966006)(36756003)(40480700001)(8676002)(4326008)(41300700001)(47076005)(82310400005)(5660300002)(2906002)(8936002)(186003)(336012)(426003)(70586007)(9686003)(26005)(70206006)(86362001)(2876002)(83380400001)(36860700001)(82740400003)(55446002)(316002)(40460700003)(81166007)(356005)(478600001)(6636002)(110136005)(54906003)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2022 13:16:32.6839
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b8c1c1d3-845e-45f7-97ef-08dac6427313
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT100.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6333
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
