Return-Path: <netdev+bounces-461-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B98A76F7759
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 22:48:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CDD86280F43
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 20:48:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97DE7156E5;
	Thu,  4 May 2023 20:48:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 844397C
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 20:48:11 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on20621.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e89::621])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AA705FD7;
	Thu,  4 May 2023 13:47:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hULjoIsUejwfA3eccefplv/VbrU4vP3jFfKFfpRJNCk2cPVKzrrMbIx7xgYHyMEmdXrLLa2tVplS7EEYZWfjm6mcuwguCz/j20o87f2Gr1cafnMli+Z+mCvGg3Aig+2CF1hVXoO4472wmT27fZlTRIyh19DxqWVwFBne1+ap//RQq6uNfT4g+Hu+xjQjGGZ9IeDo9NCNf3iRGPIV+hyqwARJjMZBCOXy4pYbBKLQXel1kcJFD5doWTGPUqKS+8jcJq6p9inRKcuCZKsKXwCEzAOaVH7zDAmqYU3z1bV4Actx0u2CJ1PteJ0yMj0rAsHlK1CZwQkX0alBoRFVCyNZog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Am6h2LgmlMRCdaJDoYrBoHXzQEbiHhDGENGj1NPidLs=;
 b=XlXO2S8s0qVtjLsxvJF/KRxMAFeAC18PIUcqg7yTFZlTBAhtRY1vBGvseZCTmL8bLGa4YwaCA/ixYy/iJndYIytShYrGsNzcE3Zt3t3ydiLT3Omm5ILco8mgOLha58RPozI8G+VuMhQEHbUSnp0jee9+hUyi545rZjeWtDvU4crCeb9x9mFb6r6WC27CJDyt1UNjfqw9/b6pqxQzvnLKUjHgdhQzAn4rfrnRXK+62ip0oY9l5qqN2Nfwz9en1aKPIkBFG5mBPNdbtPCEUs44zU4gdcIu27dmHAak1kSd45Bh9tCs22MgkVWw7auuHrCPqN7v+wjq4Syg0j2wtUWGHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Am6h2LgmlMRCdaJDoYrBoHXzQEbiHhDGENGj1NPidLs=;
 b=ecTtE3ITYkSuU7io+oV8kY59aGcGrCzOfgnt8KdxQvpOBSXbxVAPQBO2iC+R6iO6prUKtvl59GUjKfFL/l5Mu1dffLc10iScwvr6aBWJd0aYqc7D+hpxI0V8TPfD1MUEBmT+9q4uUk8SEFTo3M7VfSxZZ2LPvGY8FOGWdiRq9As=
Received: from BN8PR16CA0011.namprd16.prod.outlook.com (2603:10b6:408:4c::24)
 by PH8PR12MB7304.namprd12.prod.outlook.com (2603:10b6:510:217::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.22; Thu, 4 May
 2023 20:46:32 +0000
Received: from BN8NAM11FT007.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:4c:cafe::7e) by BN8PR16CA0011.outlook.office365.com
 (2603:10b6:408:4c::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.26 via Frontend
 Transport; Thu, 4 May 2023 20:46:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT007.mail.protection.outlook.com (10.13.177.109) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6363.27 via Frontend Transport; Thu, 4 May 2023 20:46:31 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 4 May
 2023 15:45:28 -0500
From: Shannon Nelson <shannon.nelson@amd.com>
To: <shannon.nelson@amd.com>, <brett.creeley@amd.com>, <davem@davemloft.net>,
	<netdev@vger.kernel.org>, <kuba@kernel.org>, <dan.carpenter@linaro.org>
CC: <drivers@pensando.io>, <kernel-janitors@vger.kernel.org>
Subject: [PATCH net] pds_core: fix mutex double unlock in error path
Date: Thu, 4 May 2023 13:44:59 -0700
Message-ID: <20230504204459.56454-1-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT007:EE_|PH8PR12MB7304:EE_
X-MS-Office365-Filtering-Correlation-Id: df73849b-5e14-43fe-d861-08db4ce0a426
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	+8XDapRwtm1Nx7J0cn0G1PU9KAbGa7OTU+5t8ZDxhQFewznQ0PC4MeZyWnUdoyN2Rj8epdDRjbFnTEw/I70YfbUj552/L0wGE8wpMppJjs24jWoLgfma3v8KYk4ZSZKHjg2MmUCdXD4qOLggyyCW04ut9yqo49rt1RlevZrJmqpftWWFwUJaKRAfx/ZFq0pqoHxNyU5B607VNRnh31jgpywWuKk1wcgb4yp4JOBhrg7h8fEM2Hk3LarTdY0sJ4ls7mv58gbiu5PfmvnCtBiMFoHcCDMawi19hzHbUM2vmn1oVpEeMsF5kt260veRwCTYvElspzbChDvD/FwFtXN/ajLi/PpOgwKZ2rtWJ/2IQXlqHu+pdi6ngYNj+g+sjSUxRhwcJG0IVmY10gHgPqBQaRVTcy3NMGgWrN9IuMkSuRAi5l7pSJ9ckIS5lJoAxB+I+vb3iUcEiTiORt4iD5dyA8pvmZwpLJMHZx/gfIQxfwP7sIeaAofRDh4mbZzzvPwEakRWAXco1rSUpStjzHQqJeyuUQrwFzcvvtDFVTsZbcsoehMDyVVkyEH9VBTFJwda7ApwS2m6wDdudyfPp1ltmicXT8TnofkYGShCDxMj0tPE43WAQJy2RMX5//X2pYwdFdi41tn8kVEQ7zzv+XqylEL+4oXZcjRXyOgJ95dJpxt4ShtiTnS1dqW6j9Qr+WAysMHwa9g8q90YjB5ttz/HXhwDkpf+vQe25iUY3BV6Oio=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(39860400002)(136003)(346002)(396003)(451199021)(46966006)(36840700001)(40470700004)(40460700003)(1076003)(26005)(8676002)(966005)(2616005)(336012)(426003)(36756003)(40480700001)(356005)(8936002)(47076005)(83380400001)(44832011)(82310400005)(4326008)(16526019)(478600001)(186003)(70586007)(6666004)(41300700001)(70206006)(316002)(82740400003)(5660300002)(110136005)(54906003)(86362001)(2906002)(36860700001)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2023 20:46:31.3139
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: df73849b-5e14-43fe-d861-08db4ce0a426
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN8NAM11FT007.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7304
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Fix a double unlock in an error handling path by unlocking as soon as
the error is seen and removing unlocks in the error cleanup path.

Link: https://lore.kernel.org/kernel-janitors/209a09f6-5ec6-40c7-a5ec-6260d8f54d25@kili.mountain/
Fixes: 523847df1b37 ("pds_core: add devcmd device interfaces")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/net/ethernet/amd/pds_core/main.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/amd/pds_core/main.c b/drivers/net/ethernet/amd/pds_core/main.c
index e2d14b1ca471..672757932246 100644
--- a/drivers/net/ethernet/amd/pds_core/main.c
+++ b/drivers/net/ethernet/amd/pds_core/main.c
@@ -244,11 +244,16 @@ static int pdsc_init_pf(struct pdsc *pdsc)
 	set_bit(PDSC_S_FW_DEAD, &pdsc->state);
 
 	err = pdsc_setup(pdsc, PDSC_SETUP_INIT);
-	if (err)
+	if (err) {
+		mutex_unlock(&pdsc->config_lock);
 		goto err_out_unmap_bars;
+	}
+
 	err = pdsc_start(pdsc);
-	if (err)
+	if (err) {
+		mutex_unlock(&pdsc->config_lock);
 		goto err_out_teardown;
+	}
 
 	mutex_unlock(&pdsc->config_lock);
 
@@ -257,13 +262,15 @@ static int pdsc_init_pf(struct pdsc *pdsc)
 	err = devl_params_register(dl, pdsc_dl_params,
 				   ARRAY_SIZE(pdsc_dl_params));
 	if (err) {
+		devl_unlock(dl);
 		dev_warn(pdsc->dev, "Failed to register devlink params: %pe\n",
 			 ERR_PTR(err));
-		goto err_out_unlock_dl;
+		goto err_out_stop;
 	}
 
 	hr = devl_health_reporter_create(dl, &pdsc_fw_reporter_ops, 0, pdsc);
 	if (IS_ERR(hr)) {
+		devl_unlock(dl);
 		dev_warn(pdsc->dev, "Failed to create fw reporter: %pe\n", hr);
 		err = PTR_ERR(hr);
 		goto err_out_unreg_params;
@@ -279,15 +286,13 @@ static int pdsc_init_pf(struct pdsc *pdsc)
 	return 0;
 
 err_out_unreg_params:
-	devl_params_unregister(dl, pdsc_dl_params,
-			       ARRAY_SIZE(pdsc_dl_params));
-err_out_unlock_dl:
-	devl_unlock(dl);
+	devlink_params_unregister(dl, pdsc_dl_params,
+				  ARRAY_SIZE(pdsc_dl_params));
+err_out_stop:
 	pdsc_stop(pdsc);
 err_out_teardown:
 	pdsc_teardown(pdsc, PDSC_TEARDOWN_REMOVING);
 err_out_unmap_bars:
-	mutex_unlock(&pdsc->config_lock);
 	del_timer_sync(&pdsc->wdtimer);
 	if (pdsc->wq)
 		destroy_workqueue(pdsc->wq);
-- 
2.17.1


