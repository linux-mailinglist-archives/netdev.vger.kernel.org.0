Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B550C6DA652
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 01:47:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237098AbjDFXnZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 19:43:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238745AbjDFXmd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 19:42:33 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2048.outbound.protection.outlook.com [40.107.243.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0952F7ED2
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 16:42:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O4l4jW9S/ji+aDway+TdbqdF8yjsT25zVsATEZcdY9FfpOdLZss4fU31xuV7Byi9TyEy5h0dkbp/qKsX1Tm/0iYxdB/PCVGracTZ4fUdZoEmVCpSC72wIdLwl/fGnTA2lRwuCgCx8nG7i1g+OKKJkKYCHzHKo1rNU6wWamlufNZP+OArv+hF0k9QLJ2x7FNPQSzQxBnqQnTofrSuGYAOFKxnoIaNNvi39XKtjjt55VMHGqYUY7/GLr6YN0zCx7vzE/ERExy/NoUm4fZD+xl9Uupo+GTDvjlirWf/XBeSKNNQWF+op8j44i3cplwvkNJCdtQ//iCb9EOZdoCpSzjGtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mgdTu13yGRSLeqgcPzLHrHN9XM+GVQPL7/guCrpAcEI=;
 b=XRGkplddrbxqSR+IhloWX8L/7sQGbVwz27pJJQpPQAGnblPlelZf3K19GDlHd5ty/9K2Qq9We12h2mGPBebzKQrLWU+sEWvg9X04ZJLM6sVroMa6nrLK+FdR9vnUAndrv09vzikRa8Ao0QrIaZzTVZSuZQ+CCKaqSwojHNKcC5bLu0NIk5udZqevlrLPXQlhRbBd3PqFWmMZtvbWlfC1OlHgqcdzomyUt9YhEDxA5R0fVOch//aFOdqnujtM08KE4KRK+Hx/5yPXri8ote7FL9T2rR6jGt41JB+zBjREsjXMLYomuQDBskYZrOMDokVgHu2Ea32o3Yb0bVM6+u6sQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mgdTu13yGRSLeqgcPzLHrHN9XM+GVQPL7/guCrpAcEI=;
 b=DyedjtAvu8IaufgQCRXBLbvbdUGH0VYkOs5CaoWvJ7F/qZsXxLi3IDEAK4mLscd5h/D06eT7ruKFRCHphYyu1KWSUPSlFNLvFRXu97vWhjX5TEJy7A6fvkRzWLP11B4Gp3ZV9xwfDTGhbEOkx5tyvrCSNX2/DpsFf0dxc92J8Aw=
Received: from DM5PR07CA0118.namprd07.prod.outlook.com (2603:10b6:4:ae::47) by
 PH7PR12MB6787.namprd12.prod.outlook.com (2603:10b6:510:1ad::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.33; Thu, 6 Apr
 2023 23:42:27 +0000
Received: from DM6NAM11FT067.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:ae:cafe::d8) by DM5PR07CA0118.outlook.office365.com
 (2603:10b6:4:ae::47) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.31 via Frontend
 Transport; Thu, 6 Apr 2023 23:42:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT067.mail.protection.outlook.com (10.13.172.76) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6298.19 via Frontend Transport; Thu, 6 Apr 2023 23:42:26 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 6 Apr
 2023 18:42:25 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <leon@kernel.org>, <jiri@resnulli.us>
Subject: [PATCH v9 net-next 11/14] pds_core: devlink params for enabling VIF support
Date:   Thu, 6 Apr 2023 16:41:40 -0700
Message-ID: <20230406234143.11318-12-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230406234143.11318-1-shannon.nelson@amd.com>
References: <20230406234143.11318-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT067:EE_|PH7PR12MB6787:EE_
X-MS-Office365-Filtering-Correlation-Id: 60c663d3-4fc9-4c61-9e11-08db36f89443
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XMnzn3nfz83Gq4iFC+aIhsEa/LAppikLIr0uhHyVLNPdIAUthAaZX2sZPgWLdLEIPqULAjFd1Kj7qhafRRH8SJXXOWtv7FkGQsY2rIO3COZCu/T3VCT2pO02/495Q3IJ7PgF84EB4rsscUwgZmr0EFn7JrmkTs1NT8tkR6S4MH/l7t/NNO7/zoyM2/+HFSLRyc2VyExnBsc6xLk36vVSTZpj1QrEoCAg12p2nWBOzlHjtxtNWQLUu5BcGrO0gE8K/uLYQzO/Hb4emm6VgJuwhIDXsjkth6p3tDqdsAyT6h48NZcMPsoaeiDN8KbtT9LXQvuLEmvfoDrjV4sN0Vv68hUe/vgchO9ENQh6xrdJz2Izo/ib/ObbHCd6HMO5tG88/5e9tGwtZmFXUmmZXN8rmKN7sWyOHlFTM1kgmi2QM93uQAXRX3i6qGmARbOthA4yEsEAMagYCKPJu5MJsdmPTZ+ep+m2IiRdmMXrCS5g2t+P/8NLE0EFrNdwWCcWU9gxV2lpD1TuYo2GKac3XotgsEvul6Tylx3xnAsLknpIAggw5auAs6cxjX9mHsehC0IYsIZ+T7+0mGAypWgIO+Zb9ChZuuTm3LV6qyTgBW0uuHxT4LziO/O2+2TrJE6vZWN/bN1v7xbGhC/0CVQcQez8j5oMj7bIITdaZq0X2/e49H63E2AI6M3VJtoWuYW+fKvpq34sG6E4cmgI+O6j5dSaveiZucEXdH5j3eIkMe+oGdk=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(346002)(396003)(39860400002)(451199021)(36840700001)(40470700004)(46966006)(2906002)(70586007)(44832011)(82310400005)(336012)(426003)(5660300002)(8936002)(4326008)(8676002)(36756003)(40460700003)(6666004)(40480700001)(70206006)(316002)(41300700001)(110136005)(54906003)(478600001)(186003)(16526019)(82740400003)(356005)(81166007)(26005)(1076003)(86362001)(2616005)(83380400001)(47076005)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2023 23:42:26.9524
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 60c663d3-4fc9-4c61-9e11-08db36f89443
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT067.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6787
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=no
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
---
 .../device_drivers/ethernet/amd/pds_core.rst  | 19 +++++
 drivers/net/ethernet/amd/pds_core/core.h      |  7 ++
 drivers/net/ethernet/amd/pds_core/devlink.c   | 73 +++++++++++++++++++
 drivers/net/ethernet/amd/pds_core/main.c      | 34 +++++++--
 4 files changed, 127 insertions(+), 6 deletions(-)

diff --git a/Documentation/networking/device_drivers/ethernet/amd/pds_core.rst b/Documentation/networking/device_drivers/ethernet/amd/pds_core.rst
index 6faf46390f5f..9449451b538f 100644
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
index 16b20bd705e4..aab4986007b9 100644
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
index 0e98137cf69b..550ae52eee85 100644
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
index 16a2d8a048a3..38c5e902b200 100644
--- a/drivers/net/ethernet/amd/pds_core/main.c
+++ b/drivers/net/ethernet/amd/pds_core/main.c
@@ -210,6 +210,14 @@ static const struct devlink_health_reporter_ops pdsc_fw_reporter_ops = {
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
@@ -257,13 +265,19 @@ static int pdsc_init_pf(struct pdsc *pdsc)
 
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
 
@@ -275,7 +289,11 @@ static int pdsc_init_pf(struct pdsc *pdsc)
 
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
@@ -387,9 +405,13 @@ static void pdsc_remove(struct pci_dev *pdev)
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

