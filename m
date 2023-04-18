Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C5C46E55ED
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 02:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230145AbjDRAdk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 20:33:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230003AbjDRAdP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 20:33:15 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2086.outbound.protection.outlook.com [40.107.212.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4444544B4
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 17:33:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IuFaX+0EWm8zesM2eU6sDsgzZqYSO5UCnYAfFSgIkbMCvKMt1i72puTznCUP+ciJvBxFIGU2FUEBCUgRa/bMc/5JK5IQLYGg2kTcB9ks85ymu7H/vpB8utSrydQePcwVaCU1sY2t2/zjm/ITvvSpsXZrOf9mRnhylFmr0QUlKnbYYDFdO1NEwWYvLniWKo3sPL7SJwuribejjibMcx3ZDWK4Wv0e9ElRzR3T4jyqvs2zfLsktRWzY5pXb4y60hGpi9t5ZJvAO/6vGXhS9AY4IpPvawnWTbisVKSO64mDGqx7Isoembe7Kq0TapVZirewngt2ivaW+8/h0X7E8h/2OA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=doNOcgLzwQ/BOYL7R3zMxpBXPFLayFv0Gx8txjVgMy0=;
 b=eV3DT4oQtchniJHjr7uS44GKEq4TV1bGKWe57ckpGvQa1i/OURozEwVdc4PLZJLSefiTAhEp0P78ZbmJqRqlchtLVSw1nEhqnbnDv80GQwHMIFiDqIvxe3HMSnQyDGoGGRYLTdEWVTL5kzJ70v9oNvXG5K3sP/7By1vzgtmwqsldeoQ6Cuh70FqGr+NFT91aI2h5SwJLKiuq7LgpnxHUIYo5CpWc+HWar4GSU/oV78GnjCHglDfT4eDlmxTelzmFJO2N4/b/kTQMtH0ROSNKovNYl5H8zq/WUjDAcBzLwOJmDUS3b9VjPabb39gJ1qV695zdtsgRkW7Cpg6nzB2xtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=temperror (sender ip
 is 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=temperror action=none header.from=amd.com; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=doNOcgLzwQ/BOYL7R3zMxpBXPFLayFv0Gx8txjVgMy0=;
 b=bQT0wa52ztfVNRpY0a83A+RMN7pZ/iUVFdKBut5mlhvml5uL2P7cNXG8Zyi70a5ZLGZ77SDJivQVA8FGAuCvRbpKidx0TLNvt4b9lsftPHMQ/9fgbVpGOEqxaaT+qt9iiHEMFkfDyFudqqlIiMOqaE/J5/7xvaDrj59WqSbpzC4=
Received: from BN9PR03CA0143.namprd03.prod.outlook.com (2603:10b6:408:fe::28)
 by SJ2PR12MB7895.namprd12.prod.outlook.com (2603:10b6:a03:4c6::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 00:33:06 +0000
Received: from BN8NAM11FT075.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fe:cafe::d7) by BN9PR03CA0143.outlook.office365.com
 (2603:10b6:408:fe::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.46 via Frontend
 Transport; Tue, 18 Apr 2023 00:33:05 +0000
X-MS-Exchange-Authentication-Results: spf=temperror (sender IP is
 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=temperror action=none header.from=amd.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of amd.com: DNS Timeout)
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT075.mail.protection.outlook.com (10.13.176.208) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6319.20 via Frontend Transport; Tue, 18 Apr 2023 00:33:05 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 17 Apr
 2023 19:33:03 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <leon@kernel.org>, <jiri@resnulli.us>,
        <simon.horman@corigine.com>
Subject: [PATCH v10 net-next 11/14] pds_core: devlink params for enabling VIF support
Date:   Mon, 17 Apr 2023 17:32:25 -0700
Message-ID: <20230418003228.28234-12-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230418003228.28234-1-shannon.nelson@amd.com>
References: <20230418003228.28234-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT075:EE_|SJ2PR12MB7895:EE_
X-MS-Office365-Filtering-Correlation-Id: 536a2a33-3582-406f-2ba1-08db3fa479a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HWbr9PZK8zF0DzOr98TmfuRX/UuYkZAc/3TQkAXgHZcGbOK0djIg68INLoEsANETpL9IVY6wjmS3fIbMhgREHa6Mo6M5ppleA/Wkr8vrX/SLCiVmfakfc7oXRwGZzSqs+JmcXsBGdOU51wjzZfsi1mBR4maZdfkbIF4iTObJBP1MfuSzlwNuvnpkDhmAcXawuQttH39d2lyMvSqbyHm8dhK+f0D860aKM8BVhMfNTIG3xVE3tVdqQpCItIa1oncKGhfwPfSCfBsySGZQna6P2N7dLjgQgmJfBMb3tCXhokPWRu4ZlzEFJXNrvhDULeDzNfxK70uNOfFiQFiPX527Xx+vx/J9PoTApu2LeGrQ9hA5Cqlnsd3z5sscX59pVqpkW2OYZJUyer4bx1FJPhAPZjnXLQPGC/pid/IlNKQaSPd3fku2EkrFWF6irpmAGSRpEhQkyQ78G9q3EQnYEbgr2vZAYWeOuGtmD05TlmZtddW/VZZnBbakJo4EO5dK3Tj3AB4aVAo4aRvGJAN01w0SmAHujg8NhZHf7tw/PuNhLLEOL8qPu3mQnq2Cvg5k7nn/bxpo5BNdaPHkO2Yc5grJowt689RS7RJVeBUtG9H+CsBudww+lSx2hXyf8pLe3U2Z8KlP7GGNc6zrg2lr//r2n3DWc5Ti7eX9IyRSyDCyDrSkG1HVH95fOSn9KECZqv7NNMpRrmD2AT0bPD/4YOlNWN0lmNcA79eRcp80wuMxrb8=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(346002)(376002)(39860400002)(451199021)(36840700001)(46966006)(40470700004)(5660300002)(44832011)(86362001)(2616005)(426003)(336012)(82310400005)(63350400001)(47076005)(83380400001)(63370400001)(16526019)(186003)(1076003)(81166007)(356005)(82740400003)(26005)(40480700001)(36860700001)(8676002)(8936002)(478600001)(54906003)(110136005)(6666004)(316002)(41300700001)(40460700003)(36756003)(4326008)(70586007)(70206006)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2023 00:33:05.0445
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 536a2a33-3582-406f-2ba1-08db3fa479a2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT075.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7895
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
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

