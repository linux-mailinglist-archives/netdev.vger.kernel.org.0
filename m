Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 601FC6D0EAF
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 21:24:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232148AbjC3TYO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 15:24:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231613AbjC3TXp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 15:23:45 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2055.outbound.protection.outlook.com [40.107.212.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD6A5CDD4
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 12:23:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jPE3wYAKl5jtb/lmuVs0jv+3xmeBOVT92AGB9birFbKRp+0lp0PKkNHGig9Q4zvLMsDckMMnn9O4NByne2CuklTNbOPXZUv9NF2zRXeQlzxz9y7c0hQjHXBBT+dLDdBQF6+vM5KxTJEH4Dyd601yaaI5+Qp9711zbKdKRGKvsP5EcfvTQQUwEl0eDoRFKPLL0NO5DayLpN0Cj/Nz9i5fE++SIdEl4+oOFAEdw1GcXtcqCzV6eNbeMQPQDLyPFaPkj7suoVck0Qf3mYNkKCzEnIlYQkiH/OcliVLXq6hv2rI7xr1qpR4HtLn+LpLLzW7unRvZQ4SbhL1YtJDBjUuU/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=utsI82DGOri7nFmZWIwrdjy1MjwEJK4yZ2eQxiVSkMA=;
 b=U44CL8AHteU0PIn1pAtqsworCAeo+TwBR9PrdOqG7oXFYUPU+DWXodbqSY93iYhkkCGBdVZyK2oJBd50hnnqLZtukoiY688/cO3IJC5Sx3nOUg80Bph48p0j8RNr8xKGabHpjTj1NZ3AbGI2atEWrwOS+83tuV5g5nLpSiU7TWjcwfI0396AnXXABCEtc1N7HErHrNCLxLKtoXRENHEGN5zNrOKarWs8UxRTph5hd4UlF+sao9gaol7uEfrBUsU7Ze/Wp+mH6bCEYclyIx0JBpQv3ZCdh394TJuqltX/A7tvThjEJTBqRN7ar+VQEqROWlMJkcMvtrHa9NldFxCd/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=utsI82DGOri7nFmZWIwrdjy1MjwEJK4yZ2eQxiVSkMA=;
 b=TUPwLqdhJl7y/U/bYANWL7OFsDkNlQ4btNBSXD9z2rptkC5NXJUE9DoGpdmASk4yl3JeCv5AMAjO/JaLznQFzMYhqpUXK2gUdYVytdVhbVdfFdA653DySkn7cjrJ39Wto0IThoElSVn7EuI5JuB4RHAS7/nQCfM8uLpKK8vKSdQ=
Received: from MW4PR03CA0032.namprd03.prod.outlook.com (2603:10b6:303:8e::7)
 by IA1PR12MB8520.namprd12.prod.outlook.com (2603:10b6:208:44d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.35; Thu, 30 Mar
 2023 19:23:41 +0000
Received: from CO1NAM11FT114.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8e:cafe::f3) by MW4PR03CA0032.outlook.office365.com
 (2603:10b6:303:8e::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.22 via Frontend
 Transport; Thu, 30 Mar 2023 19:23:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT114.mail.protection.outlook.com (10.13.174.103) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6254.22 via Frontend Transport; Thu, 30 Mar 2023 19:23:40 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 30 Mar
 2023 14:23:38 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <leon@kernel.org>, <jiri@resnulli.us>
Subject: [PATCH v7 net-next 11/14] pds_core: devlink params for enabling VIF support
Date:   Thu, 30 Mar 2023 12:23:09 -0700
Message-ID: <20230330192313.62018-12-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230330192313.62018-1-shannon.nelson@amd.com>
References: <20230330192313.62018-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT114:EE_|IA1PR12MB8520:EE_
X-MS-Office365-Filtering-Correlation-Id: 95122d6e-8107-41ed-e137-08db315444f2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +28zt1uqTd2CxXucBPgbXwatEOFdelG7L7hHeUg6ovRG/DoKSoHws8lPmWOnS4FM7I8wAVR9zvKGCBMQ2lAECr5VIZcmsFP95codYRCTSJsG8VssxFZCM+7wYYgierWUxa9ghaEvurB9YEVwdfjDI/1MZB425Vmuim30xBVA3MsPkSfocTNhuRgWyjapcwvJKP+MaNP34b0PxSjonaKS943JacM/vbdfboNp2hqOAKMfuq6zcbWyQf5jvznPJO17etU39NAxa078UDEbl3V+aGTvsVvvSSUd3KBu739BtGjPLGabG7L/Ka4SdquvYcc9UkookPGDNONHpHKRmk/Yr7JHDo208QcjEpbyfr1R5BpLEB7GgYxSaKF/HfhH9sDiLLcuVDiT0cB+7QLY9KiiooqmHg/lbfmqpG51xFNvbLYwSPpuXKd7PC9iCKncYTzmDVr/dWf5cESyHsdUnyxe+F7YsQXM4nPkXl+jHkD4K9SF38b8evgZT4ab+9d8nL3fweHGgA9t/hU2yK7E2BlvZwEmRJOxj7Pqrbi8QDJfcaV8dX9ZuqhQLylsAd4I4fLoSBcs0Z21jLnez2vl/mU8rG/+PY6va0Jx4R8rFnlDsyQY8NrYcwDSNrdbGHmosYx6rCQzvDhoMtVob+sCseTu3/6T3QfPacrdVR3puxD3wtvyXViTljmT8ZhZ7kMV1FyNfv/bZjyDSJSVbdoxV+/b0l9gtDHB3XN3G9dW/MEP3f4=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(376002)(396003)(136003)(451199021)(40470700004)(46966006)(36840700001)(2906002)(336012)(41300700001)(83380400001)(2616005)(426003)(44832011)(5660300002)(110136005)(478600001)(6666004)(36756003)(8936002)(54906003)(8676002)(4326008)(40460700003)(316002)(70586007)(70206006)(82310400005)(81166007)(40480700001)(16526019)(356005)(186003)(82740400003)(47076005)(26005)(1076003)(36860700001)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 19:23:40.5120
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 95122d6e-8107-41ed-e137-08db315444f2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT114.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8520
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
index 0ca5399314a2..ae8bf67753d7 100644
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
-		devlink_health_reporter_destroy(pdsc->fw_reporter);
-		pdsc->fw_reporter = NULL;
+	if (!pdev->is_virtfn) {
+		if (pdsc->fw_reporter) {
+			devlink_health_reporter_destroy(pdsc->fw_reporter);
+			pdsc->fw_reporter = NULL;
+		}
+		devl_params_unregister(dl, pdsc_dl_params,
+				       ARRAY_SIZE(pdsc_dl_params));
 	}
 	devl_unlock(dl);
 
-- 
2.17.1

