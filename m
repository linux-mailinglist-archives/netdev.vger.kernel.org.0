Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72E306C5466
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 19:59:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231401AbjCVS7P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 14:59:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231261AbjCVS6J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 14:58:09 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2081.outbound.protection.outlook.com [40.107.220.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCBE967029
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 11:57:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lbv5afNY3Abu2sk2wgFM6ot6Ll65y4zqPursXXzLM0REu4z18Vh6xWv7Abj/aGxsT+0ukjWlgIqCWCxt7FZDJWxfsiDnjHA8Sy1fPp30atULJf38y0Niwnumrpf52xGbZJDeVacNVeVAHpdGJqYQ12xra1laB7B6GNPj03rpP62hSf7VrrP7OcjF+ULz2G2G3VXX3uj2krPIfbSuuOeWFXD/oDg/kOL7/awD8ZOJPem5uH27S1uAUF3oBu7G+JFUkUy73p9m7b/BdDjRqFK4oZjkA/Fzn6lz6MqiIYNmDJmKNLQMJLJ0eHQ0xNHlRCcIsZmdKgoLI6lmLuEE9Q0cpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VDvca2fTwfM7RUW9qFrpU1BBfqgFkQIY+2Llwuxmxs0=;
 b=H9hdSbvcmVi13MdMfk9wUXpwXamMLK8AZcr5zq0X1SHWGaapLcMjeLFJcnIb14NW8QrwNMMu6KsTfZcW2CukYuuWjErrlySUZNDjNwt5QBtu+klOXrdq7XGGj3ifKYdFCFFcuDLhuA2JCkZwbwHYS4nemewUD/wLDqkkywRJIsNgTqKIyWbmLHkDtf01jluoFy2Rl6Ue2LbncPJmRv+D+DWb/f6YnT1EOU2++9Ynk+z68b39j6pi1BiBef6uqyWKDFRagtzJDGKN9nHKyiy5pjw1IadMW7dEi5Zk78TD52V/oGbIzBKrZwFdm8oOKca3wexdja1G9CzW1jSDavIcoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VDvca2fTwfM7RUW9qFrpU1BBfqgFkQIY+2Llwuxmxs0=;
 b=swd2xtQkZmEAtlTEDS3/zds8w6Dl6wVvMknkAxjjBP53FZ/DU7g/AdnZguti3s+Lp/7uF9PCCVnf3uu31oG+QKt8fOwWKb/xRQ/LfJSdhmMSmzWJXATxYTqgG3r1yRPguzOKeoRhmZo6E/LaktLaWRiqaKsKPBHAZs8isBYZA40=
Received: from BN9PR03CA0974.namprd03.prod.outlook.com (2603:10b6:408:109::19)
 by SN7PR12MB7299.namprd12.prod.outlook.com (2603:10b6:806:2af::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 18:56:57 +0000
Received: from BN8NAM11FT051.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:109:cafe::e2) by BN9PR03CA0974.outlook.office365.com
 (2603:10b6:408:109::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37 via Frontend
 Transport; Wed, 22 Mar 2023 18:56:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT051.mail.protection.outlook.com (10.13.177.66) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6222.17 via Frontend Transport; Wed, 22 Mar 2023 18:56:57 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 22 Mar
 2023 13:56:53 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <leon@kernel.org>, <jiri@resnulli.us>
Subject: [PATCH v5 net-next 11/14] pds_core: devlink params for enabling VIF support
Date:   Wed, 22 Mar 2023 11:56:23 -0700
Message-ID: <20230322185626.38758-12-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230322185626.38758-1-shannon.nelson@amd.com>
References: <20230322185626.38758-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT051:EE_|SN7PR12MB7299:EE_
X-MS-Office365-Filtering-Correlation-Id: 3185829d-6df0-4622-2a30-08db2b073631
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: va2zpT2Y/8KZCJt68qEnlwaET4iect0MZdCe3XOxRTrRPYWyfZXHblFdY6/7JY+6PRjaT6OajUdD+kB2WOsnOmt8ou1ZWwlv5CKjTceXUqLl4C6Eme+uMyNF97iAkf9ByeVnopyk+A8rL+cVUJZfmXuOLaLnwtB8cVopawkMue5/uP3ubTYFhAQkGSCbccm3gxiV2WfHYlIGUaCFnvVh1bULL1NbieKfCZXZn01erGekzOWFsoKxI+1i1Ycj2Fhv5D6CGE6FdNL3U9MhH+GKvBWAcPIQIMwIlC67iudOTi9r20/FaeZrmlbCI7HTSURmvn8KuRG71ZDx60HeG5eTmMy5Jq9Is4BcODuSOcLA5hwCL8ngMUnVNgiwRylv7IGMuoBFRweWNdhsS9lxOTVvvFREFJ0FeV0X9JXaz0Up4Cwcn82ee9T95pU8VGDbcONBidTNB3mFNU4Q+y+Uy++um6Sw8F8xP5r+fRg+kdyCBeVR76ciZxDVnGD2zm23rl4wgXxqRC6stdV53vflk1gkZ6k/qZ7okCtPafDKy4cx1ygYx0xCJ/YyT/f8Wz1HRCphL71VM/GZpDA0eNinHGTMx2o+gH+V3P1ch7JslQx6PmfCvJCtmWhfA+OQ3ZPkY1uZG1xFcAKF7adeo1V2zUrPvXIYa5ZgBdyF4W7pDzma6G8A9jlPqTzwaxVKB9mCiWSP8qS9Z0PP+lQ41LBE0CX9+gTZDHGofrIteQNaByKEAII=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(136003)(39860400002)(396003)(451199018)(46966006)(36840700001)(40470700004)(316002)(54906003)(6666004)(81166007)(70586007)(4326008)(8676002)(110136005)(478600001)(336012)(70206006)(47076005)(2906002)(82740400003)(2616005)(83380400001)(41300700001)(356005)(40460700003)(426003)(186003)(26005)(16526019)(8936002)(36860700001)(86362001)(1076003)(82310400005)(36756003)(40480700001)(5660300002)(44832011)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 18:56:57.4670
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3185829d-6df0-4622-2a30-08db2b073631
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT051.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7299
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the devlink parameter switches so the user can enable
the features supported by the VFs.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/net/ethernet/amd/pds_core/devlink.c | 89 ++++++++++++++++++++-
 1 file changed, 88 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amd/pds_core/devlink.c b/drivers/net/ethernet/amd/pds_core/devlink.c
index aa8625f77d79..0aa8bbd281a6 100644
--- a/drivers/net/ethernet/amd/pds_core/devlink.c
+++ b/drivers/net/ethernet/amd/pds_core/devlink.c
@@ -7,6 +7,86 @@
 #include <linux/pci.h>
 
 #include "core.h"
+#include <linux/pds/pds_auxbus.h>
+
+static struct pdsc_viftype *pdsc_dl_find_viftype_by_id(struct pdsc *pdsc,
+						       enum devlink_param_type dl_id)
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
+static int pdsc_dl_enable_get(struct devlink *dl, u32 id,
+			      struct devlink_param_gset_ctx *ctx)
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
+static int pdsc_dl_enable_set(struct devlink *dl, u32 id,
+			      struct devlink_param_gset_ctx *ctx)
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
+static int pdsc_dl_enable_validate(struct devlink *dl, u32 id,
+				   union devlink_param_value val,
+				   struct netlink_ext_ack *extack)
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
+
+static const struct devlink_param pdsc_dl_params[] = {
+	DEVLINK_PARAM_GENERIC(ENABLE_VNET,
+			      BIT(DEVLINK_PARAM_CMODE_RUNTIME),
+			      pdsc_dl_enable_get,
+			      pdsc_dl_enable_set,
+			      pdsc_dl_enable_validate),
+};
 
 static int pdsc_dl_flash_update(struct devlink *dl,
 				struct devlink_flash_update_params *params,
@@ -157,9 +237,16 @@ void pdsc_dl_free(struct pdsc *pdsc)
 int pdsc_dl_register(struct pdsc *pdsc)
 {
 	struct devlink *dl = priv_to_devlink(pdsc);
+	int err;
+
+	if (!pdsc->pdev->is_virtfn) {
+		err = devlink_params_register(dl, pdsc_dl_params,
+					      ARRAY_SIZE(pdsc_dl_params));
+		if (err)
+			return err;
 
-	if (!pdsc->pdev->is_virtfn)
 		pdsc_dl_reporters_create(pdsc);
+	}
 
 	devlink_register(dl);
 
-- 
2.17.1

