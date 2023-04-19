Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BF0C6E801B
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 19:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233622AbjDSRFu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 13:05:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233634AbjDSRFh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 13:05:37 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2060b.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e88::60b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DE007AB7
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 10:05:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JJsTiiuuTIkUqAOOOFygI493WotY/F9Dcea7afMBRCrTWSKJYNnV5nkbSJhok1mKquyMAGORRKwuPQUeK2LsBy747Sh49+mrfPuQGAiBLX6D3S72guKYpZvUmUAqIYG7c+hM1i29EcILVqo5m27OpqOVoFLeEhlcjhOh2wC6KPgYtT/bek80PHt2u3bgTKjTDkLOIdLcPnB5Aa9slV4coOYY+5sHbssBpRXK9rkwhUt0W/VCuPtCEHFI+pD+44nxwJRdaSo6AiCmULlZFPP6lXWJLPulj54U3GzXchjLYLQQWCZK+MvYFRYSt8mGTScU9zxD+X3Cc48J0Bat1J36cA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=doNOcgLzwQ/BOYL7R3zMxpBXPFLayFv0Gx8txjVgMy0=;
 b=nPu6rv8uvuN+kHHvKjopD5OQTfonRGf5TeOE0cT3m/f+lfYnVrhXcJye6yjYzdvWigMrfBl8kaGTlLfx8CqVWtNOd3xW/wwDuJYs4zMVur01JMYrrJbHNbvOMDWhxCcfvojEQEiyjSEaHnLm7X04dfGzd2y7BjChQAoaQ+j1gcaE38a+cbD1r/+P1/KRRlfSrP9P+uXVBxZk45hpYdTdcDzrk+h7xPk6wxlpPZ+UAnmzQ3uYfk8XxPPRGaAuNxTv811IMLVhcV0g74IKCry52D/fTQdoO2rSsGiUEZu+/p2zpyaMIB0I1TOM/06qAT3dev22Hf5XrMuKf12a1e6QYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=doNOcgLzwQ/BOYL7R3zMxpBXPFLayFv0Gx8txjVgMy0=;
 b=SX+xci94yaaDqRPDNQWxqFsNeENFCcMt+LARSgb9Tl62IoVQvo8lZr8J8aauSU7JqZYOhQocT2LwAIBaVEqG9dfGD/DK7XyKMrOrZgnXCgKnnRg5xFznD48D65iNfsxbtFhxjh6UQF+HTJNBcfyUC9sNW35iQBYSNt3QoAmWzuY=
Received: from MW4P223CA0020.NAMP223.PROD.OUTLOOK.COM (2603:10b6:303:80::25)
 by CH0PR12MB5348.namprd12.prod.outlook.com (2603:10b6:610:d7::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.20; Wed, 19 Apr
 2023 17:05:32 +0000
Received: from CO1NAM11FT035.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:80:cafe::d8) by MW4P223CA0020.outlook.office365.com
 (2603:10b6:303:80::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.23 via Frontend
 Transport; Wed, 19 Apr 2023 17:05:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT035.mail.protection.outlook.com (10.13.175.36) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6319.23 via Frontend Transport; Wed, 19 Apr 2023 17:05:31 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 19 Apr
 2023 12:05:22 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <leon@kernel.org>, <jiri@resnulli.us>,
        <simon.horman@corigine.com>
Subject: [PATCH v11 net-next 11/14] pds_core: devlink params for enabling VIF support
Date:   Wed, 19 Apr 2023 10:04:24 -0700
Message-ID: <20230419170427.1108-12-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230419170427.1108-1-shannon.nelson@amd.com>
References: <20230419170427.1108-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT035:EE_|CH0PR12MB5348:EE_
X-MS-Office365-Filtering-Correlation-Id: 862ab66d-6641-449b-8d4d-08db40f848c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j5z/gin7MpbnnCiufxkxx2Aew0R3FoCjCbRIrQqdqCM8Md1+0cUgIWaD19lxN8AYsIdNzpK9mTPOojEZ5RkOPUA3QYlKh8T8lgPt1a6lYyQtK2InrdeLQodBXPBvLmIcTCf0Y2UuIBKn3++kiMMQVY/mL8vZFhqFN/MoAZDmw9N5gzUt5hpsUKMnZD9zqqS6xgvxjVnB/W2sVpLH5bKVX6sFpmK7rnGdrmO5uGF4tF8TEicpJC/rTbBgsHgsPSTNgaeUm3PvK8L7zaDeVFbVeYcG1fs1bxJUy9PZtIe3ABBdiYpOihmVD5Gs7GagIzp45xR972cIH3mGYYExZ5AOZ8awTS+FCvRHRmOKGggTxNEuDJsNeZGqPLxmSw1ibt1uthfVzkGQ6g6TkUmMUusywO015Hi0zCpd4nySvJimMZS87T3u2sLPL0yye6x+a1oWqWdH47E50GLGrYNTc/Ou2mJHij0Xw+eOLzV3tpGoGzIG+GYIu4aWSIe82SVo3WTCOTrOgMa/WLtBhqzONVrbMP9WNbmoJ90+UX7whKyvaub3O9ThfqSGivA7PeGTEZNCaLJjcviPDYNF4HPdMFsU7jjYkTYIyMSIIVD6ob8AGFfxwQkx7nFjNn/bXULfhTyls0yNlyTIX6aCIh1FqYh49p6Rm59etzHVshLxLR6HxiiTGkZk3nkSsKhAgV5pzMcgA3Xp2eyWSTrsp1/tWGE8owecV+cDKJn5APD2q9SF2tc=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(39860400002)(346002)(136003)(451199021)(40470700004)(46966006)(36840700001)(86362001)(36756003)(82310400005)(2906002)(40460700003)(40480700001)(2616005)(47076005)(36860700001)(186003)(426003)(83380400001)(16526019)(336012)(26005)(1076003)(4326008)(478600001)(70586007)(70206006)(81166007)(316002)(41300700001)(110136005)(356005)(82740400003)(54906003)(44832011)(5660300002)(8676002)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2023 17:05:31.8886
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 862ab66d-6641-449b-8d4d-08db40f848c9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT035.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5348
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the devlink parameter switches so the user can enable
the features supported by the VFs.  The only feature supported
at the moment is vDPA.

Example:
    devlink dev param set pci/0000:2b:00.0 \
	    name enable_vnet cmode runtime value true

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Acked-by: Jakub Kicinski <kuba@kernel.org>
---
 .../device_drivers/ethernet/amd/pds_core.rst  | 19 +++++
 drivers/net/ethernet/amd/pds_core/core.h      |  7 ++
 drivers/net/ethernet/amd/pds_core/devlink.c   | 73 +++++++++++++++++++
 drivers/net/ethernet/amd/pds_core/main.c      | 34 +++++++--
 4 files changed, 127 insertions(+), 6 deletions(-)

diff --git a/Documentation/networking/device_drivers/ethernet/amd/pds_core.rst b/Documentation/networking/device_drivers/ethernet/amd/pds_core.rst
index 932ac03a3359..b9f310de862e 100644
--- a/Documentation/networking/device_drivers/ethernet/amd/pds_core.rst
+++ b/Documentation/networking/device_drivers/ethernet/amd/pds_core.rst
@@ -73,6 +73,25 @@ The ``pds_core`` driver reports the following versions
      - fixed
      - The revision of the ASIC for this device
 
+Parameters
+==========
+
+The ``pds_core`` driver implements the following generic
+parameters for controlling the functionality to be made available
+as auxiliary_bus devices.
+
+.. list-table:: Generic parameters implemented
+   :widths: 5 5 8 82
+
+   * - Name
+     - Mode
+     - Type
+     - Description
+   * - ``enable_vnet``
+     - runtime
+     - Boolean
+     - Enables vDPA functionality through an auxiliary_bus device
+
 Firmware Management
 ===================
 
diff --git a/drivers/net/ethernet/amd/pds_core/core.h b/drivers/net/ethernet/amd/pds_core/core.h
index 36099d3ac3dd..9e01a9ee6868 100644
--- a/drivers/net/ethernet/amd/pds_core/core.h
+++ b/drivers/net/ethernet/amd/pds_core/core.h
@@ -251,6 +251,13 @@ int pdsc_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
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
index f91d65cc78b5..9c6b3653c1c7 100644
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
+		err = ctx->val.vbool ? pdsc_auxbus_dev_add(vf, pdsc) :
+				       pdsc_auxbus_dev_del(vf, pdsc);
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
index b848f3360fe2..e2d14b1ca471 100644
--- a/drivers/net/ethernet/amd/pds_core/main.c
+++ b/drivers/net/ethernet/amd/pds_core/main.c
@@ -199,6 +199,14 @@ static const struct devlink_health_reporter_ops pdsc_fw_reporter_ops = {
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
@@ -246,13 +254,19 @@ static int pdsc_init_pf(struct pdsc *pdsc)
 
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
 
@@ -264,7 +278,11 @@ static int pdsc_init_pf(struct pdsc *pdsc)
 
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
@@ -373,9 +391,13 @@ static void pdsc_remove(struct pci_dev *pdev)
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

