Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48DF66D1394
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 01:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231735AbjC3Xrk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 19:47:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231668AbjC3XrT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 19:47:19 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2053.outbound.protection.outlook.com [40.107.92.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FD1AAD27
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 16:46:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gDxDGCzvGImmBly0z+d9o458oed/qYXdie8GJqJTZiZUoUiIx8FD66O8iXutKjGSwuAxkv6bE7gVSwMWUrw3Ub+zo7eVU8WATytmo4maVbI9O3evqMPCI0daNAk2WfHWiTSEa6xlZ92fEjdhYD3rgJ8nfAxzii+aQZ4QPSQlBOKHJ4tpzTZrQkgn7EQJ/8wCmoHMZq92cCJmTWwf/cGgzx7yO+If0QKw3QkTFV+7wZzuCed6VlVEwH227lpvtx+oRX+YgtfFsSu6AEzDB0gpq1pJViO+yvNxahUE/lgq3VNWa7Lf2spnUcqqmfKhU6e6GvekdyWE2dRVKBEk3WnPWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A8673ZOIQfA2QAfpdsuQynCHPvejS0tu8jbtkOXgpGc=;
 b=IK9orPTJpnPOm7tOeUssV3cvdVaVNvKKpB1iz7t5inO2dDtKRWLiYd58lLEV/3c4V9ufsDwpRzKdJiiyjr853sIKDBqbpgEc1Bn5u7v71yFj9WfKrZMvxg3Zpzbq72Rpy3lsA0FWe5y7NfMXbhEyyciuyy7M88nOz3OxNTnz+g9wfvO8U5gbf/EjSZkaXxiafHK5LPjq+cWJWbGsM43Qjq5x6+aTPebUKWRvOhwqq3iqmzQ8Hl+wfbGs6McPEiQ8hos7XcjQPG3XNSWLvl6sxNEKfT+WJqvjuXjQusd5EQTMXzfGLRjLoaYTKopl5T9sFhODRkIUwvlHCvXjxijRPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A8673ZOIQfA2QAfpdsuQynCHPvejS0tu8jbtkOXgpGc=;
 b=SXsgNZnq0fwWWoa6Hik5CpeJe1lEAgtiVLXxPbNeF1ZmhtW+vhU9XLMusvkHuJY17OAcNvY9AvEv0TlnybODMxE74nTZWR71kgpqHhMqvg36ivt12v46BP/TnVWhU1uArFB6A4Ie7g4PM+4rclAIj7Kkn1OxGgF6m9d8mvVH2No=
Received: from MN2PR15CA0017.namprd15.prod.outlook.com (2603:10b6:208:1b4::30)
 by DM4PR12MB5167.namprd12.prod.outlook.com (2603:10b6:5:396::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.35; Thu, 30 Mar
 2023 23:46:55 +0000
Received: from BL02EPF000100D2.namprd05.prod.outlook.com
 (2603:10b6:208:1b4:cafe::c4) by MN2PR15CA0017.outlook.office365.com
 (2603:10b6:208:1b4::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.22 via Frontend
 Transport; Thu, 30 Mar 2023 23:46:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF000100D2.mail.protection.outlook.com (10.167.241.206) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6178.30 via Frontend Transport; Thu, 30 Mar 2023 23:46:55 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 30 Mar
 2023 18:46:54 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <leon@kernel.org>, <jiri@resnulli.us>
Subject: [PATCH v8 net-next 11/14] pds_core: devlink params for enabling VIF support
Date:   Thu, 30 Mar 2023 16:46:25 -0700
Message-ID: <20230330234628.14627-12-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230330234628.14627-1-shannon.nelson@amd.com>
References: <20230330234628.14627-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF000100D2:EE_|DM4PR12MB5167:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a3a5896-560c-48a6-974c-08db31790b79
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zFF70Hi5ZZ+JovCXFr4957zh6ybXVoZfagA2wodyoYrds2X9h4eg/1GM2MgLT26FoYdpWjkJVPsMpc5do9tGNfnren5mYziD3hFHZ9rs5ypdIGMqoq7MfBAbzv4eKXsUHqNBcJlQgLVBcM/guY3ZM9Dgf3gySbnf/Dg3w35yWI/a2ME6nnSwMg49V2qLd3ThxXCNssvV6+/vpYbnDC5yw9Th8HglO+khNe5j4zECe7GR1y10+0QatBizK3d7r4N+y+HNtwDIR3UFy3tdyoiod1P8iyFvxYHnzvEh4kP9BhK46x4GwrrM+SxwsQobQFL188MA0Pq63EM4D/4s7brDVPyCMrSwZIgnqaBJbaNWh0Y5jXOM7gmkk6J15DK4nV5QpnqotHO2mqmv8gBmyUQHcsWHFlJz7Sob2IYOJgYIu1Zi5ETCSdJPj866326u3DQNFGpkTszVZ3fh6VVJY2q4zfC/EJ931GBXF0vEyFrX5kBBSkXuoXzACrmC6dnYC2OTzTGaND7bZJlNu+bSji0KlcpQg3w8rFOutpoidKiuRdIc8tUEtj4lJw4WGryAALkOy3PBKTeomTzmEGULvi7Bydq7JknGTSIMksdCC/RoCmy4H94XdhNBawX/Fb/NBW0UYVbv6VZguTcPdc6wQfwTua1/5oekcFE7oV0P2o8LDi8fWAkucMmsXU5NwJEFW2gj9NHcIu54s2QAtEVbi3xjagw3CdKEWExj4bjjB1VDgNU=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(376002)(396003)(39860400002)(451199021)(46966006)(36840700001)(40470700004)(40480700001)(40460700003)(36860700001)(110136005)(81166007)(4326008)(356005)(8676002)(316002)(186003)(82740400003)(70206006)(70586007)(41300700001)(336012)(26005)(16526019)(83380400001)(1076003)(47076005)(2616005)(426003)(478600001)(6666004)(8936002)(86362001)(82310400005)(36756003)(2906002)(44832011)(5660300002)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 23:46:55.5910
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a3a5896-560c-48a6-974c-08db31790b79
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF000100D2.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5167
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the devlink parameter switches so the user can enable
the features supported by the VFs.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/net/ethernet/amd/pds_core/core.h    |  7 ++
 drivers/net/ethernet/amd/pds_core/devlink.c | 73 +++++++++++++++++++++
 drivers/net/ethernet/amd/pds_core/main.c    | 34 ++++++++--
 3 files changed, 108 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/amd/pds_core/core.h b/drivers/net/ethernet/amd/pds_core/core.h
index 27aaffdc5056..c5e3ca7e4b08 100644
--- a/drivers/net/ethernet/amd/pds_core/core.h
+++ b/drivers/net/ethernet/amd/pds_core/core.h
@@ -252,6 +252,13 @@ int pdsc_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
 int pdsc_dl_flash_update(struct devlink *dl,
 			 struct devlink_flash_update_params *params,
 			 struct netlink_ext_ack *extack);
+int pdsc_dl_enable_get(struct devlink *dl, u32 id,
+		       struct devlink_param_gset_ctx *ctx);
+int pdsc_dl_enable_set(struct devlink *dl, u32 id,
+		       struct devlink_param_gset_ctx *ctx);
+int pdsc_dl_enable_validate(struct devlink *dl, u32 id,
+			    union devlink_param_value val,
+			    struct netlink_ext_ack *extack);
 
 void __iomem *pdsc_map_dbpage(struct pdsc *pdsc, int page_num);
 
diff --git a/drivers/net/ethernet/amd/pds_core/devlink.c b/drivers/net/ethernet/amd/pds_core/devlink.c
index 5a192b85f8a2..0f1f0acd95b5 100644
--- a/drivers/net/ethernet/amd/pds_core/devlink.c
+++ b/drivers/net/ethernet/amd/pds_core/devlink.c
@@ -2,6 +2,79 @@
 /* Copyright(c) 2023 Advanced Micro Devices, Inc */
 
 #include "core.h"
+#include <linux/pds/pds_auxbus.h>
+
+static struct
+pdsc_viftype *pdsc_dl_find_viftype_by_id(struct pdsc *pdsc,
+					 enum devlink_param_type dl_id)
+{
+	int vt;
+
+	for (vt = 0; vt < PDS_DEV_TYPE_MAX; vt++) {
+		if (pdsc->viftype_status[vt].dl_id == dl_id)
+			return &pdsc->viftype_status[vt];
+	}
+
+	return NULL;
+}
+
+int pdsc_dl_enable_get(struct devlink *dl, u32 id,
+		       struct devlink_param_gset_ctx *ctx)
+{
+	struct pdsc *pdsc = devlink_priv(dl);
+	struct pdsc_viftype *vt_entry;
+
+	vt_entry = pdsc_dl_find_viftype_by_id(pdsc, id);
+	if (!vt_entry)
+		return -ENOENT;
+
+	ctx->val.vbool = vt_entry->enabled;
+
+	return 0;
+}
+
+int pdsc_dl_enable_set(struct devlink *dl, u32 id,
+		       struct devlink_param_gset_ctx *ctx)
+{
+	struct pdsc *pdsc = devlink_priv(dl);
+	struct pdsc_viftype *vt_entry;
+	int err = 0;
+	int vf_id;
+
+	vt_entry = pdsc_dl_find_viftype_by_id(pdsc, id);
+	if (!vt_entry || !vt_entry->supported)
+		return -EOPNOTSUPP;
+
+	if (vt_entry->enabled == ctx->val.vbool)
+		return 0;
+
+	vt_entry->enabled = ctx->val.vbool;
+	for (vf_id = 0; vf_id < pdsc->num_vfs; vf_id++) {
+		struct pdsc *vf = pdsc->vfs[vf_id].vf;
+
+		err = ctx->val.vbool ? pdsc_auxbus_dev_add_vf(vf, pdsc) :
+				       pdsc_auxbus_dev_del_vf(vf, pdsc);
+	}
+
+	return err;
+}
+
+int pdsc_dl_enable_validate(struct devlink *dl, u32 id,
+			    union devlink_param_value val,
+			    struct netlink_ext_ack *extack)
+{
+	struct pdsc *pdsc = devlink_priv(dl);
+	struct pdsc_viftype *vt_entry;
+
+	vt_entry = pdsc_dl_find_viftype_by_id(pdsc, id);
+	if (!vt_entry || !vt_entry->supported)
+		return -EOPNOTSUPP;
+
+	if (!pdsc->viftype_status[vt_entry->vif_id].supported)
+		return -ENODEV;
+
+	return 0;
+}
 
 int pdsc_dl_flash_update(struct devlink *dl,
 			 struct devlink_flash_update_params *params,
diff --git a/drivers/net/ethernet/amd/pds_core/main.c b/drivers/net/ethernet/amd/pds_core/main.c
index 900158135938..ce0855e79913 100644
--- a/drivers/net/ethernet/amd/pds_core/main.c
+++ b/drivers/net/ethernet/amd/pds_core/main.c
@@ -231,6 +231,14 @@ static const struct devlink_health_reporter_ops pdsc_fw_reporter_ops = {
 	.diagnose = pdsc_fw_reporter_diagnose,
 };
 
+static const struct devlink_param pdsc_dl_params[] = {
+	DEVLINK_PARAM_GENERIC(ENABLE_VNET,
+			      BIT(DEVLINK_PARAM_CMODE_RUNTIME),
+			      pdsc_dl_enable_get,
+			      pdsc_dl_enable_set,
+			      pdsc_dl_enable_validate),
+};
+
 #define PDSC_WQ_NAME_LEN 24
 
 static int pdsc_init_pf(struct pdsc *pdsc)
@@ -278,13 +286,19 @@ static int pdsc_init_pf(struct pdsc *pdsc)
 
 	dl = priv_to_devlink(pdsc);
 	devl_lock(dl);
+	err = devl_params_register(dl, pdsc_dl_params,
+				   ARRAY_SIZE(pdsc_dl_params));
+	if (err) {
+		dev_warn(pdsc->dev, "Failed to register devlink params: %pe\n",
+			 ERR_PTR(err));
+		goto err_out_unlock_dl;
+	}
 
 	hr = devl_health_reporter_create(dl, &pdsc_fw_reporter_ops, 0, pdsc);
 	if (IS_ERR(hr)) {
 		dev_warn(pdsc->dev, "Failed to create fw reporter: %pe\n", hr);
 		err = PTR_ERR(hr);
-		devl_unlock(dl);
-		goto err_out_stop;
+		goto err_out_unreg_params;
 	}
 	pdsc->fw_reporter = hr;
 
@@ -296,7 +310,11 @@ static int pdsc_init_pf(struct pdsc *pdsc)
 
 	return 0;
 
-err_out_stop:
+err_out_unreg_params:
+	devl_params_unregister(dl, pdsc_dl_params,
+			       ARRAY_SIZE(pdsc_dl_params));
+err_out_unlock_dl:
+	devl_unlock(dl);
 	pdsc_stop(pdsc);
 err_out_teardown:
 	pdsc_teardown(pdsc, PDSC_TEARDOWN_REMOVING);
@@ -408,9 +426,13 @@ static void pdsc_remove(struct pci_dev *pdev)
 	dl = priv_to_devlink(pdsc);
 	devl_lock(dl);
 	devl_unregister(dl);
-	if (pdsc->fw_reporter) {
-		devl_health_reporter_destroy(pdsc->fw_reporter);
-		pdsc->fw_reporter = NULL;
+	if (!pdev->is_virtfn) {
+		if (pdsc->fw_reporter) {
+			devl_health_reporter_destroy(pdsc->fw_reporter);
+			pdsc->fw_reporter = NULL;
+		}
+		devl_params_unregister(dl, pdsc_dl_params,
+				       ARRAY_SIZE(pdsc_dl_params));
 	}
 	devl_unlock(dl);
 
-- 
2.17.1

