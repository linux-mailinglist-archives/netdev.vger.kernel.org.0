Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9387645098
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 01:46:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229511AbiLGApi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 19:45:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbiLGApZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 19:45:25 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2047.outbound.protection.outlook.com [40.107.237.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FE56490B1
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 16:45:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OpAkaZSAa0gvxxlmNGeQ1DmbYRfKOJGq60rzSmTwwdGqLUhxyyIUxJW3fz1qvInaOClZNwKLurpJfRgO/oylE2qU0nrtfvA56PMY4I8yCo9YenQJk/PrWJEDi4UFau4i7Sh969q9+q6vQ+bL/DXlBXdXCHT8Xfpvg4/NIRJUBSRoUIX5K/e8PUIdRz45Tb9kaadmLBLaKPHV/1HLbpQuzT+4iGHS3TzFHySQNn2ZAsDL3hIBrGgSmVRv/exA7poIm6qvt9rg5NnHBcTAt0PcK5bK+Li/zSo8Q/PnoMBbGW+SQz559HrxRUSrtSrH3gWZgUAbW3ZR0Pg6Mpr0pfeCsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SCRL4m4dDeLGllexvaltPaOpxyrqzaWYvk1JaSDAksg=;
 b=L9qTyM1w1JcqfyxWqbeXRUjaraR29NGVEZzwRNHi3C9rLcGP+HlHigT3tRALlMTvtm4lFl5HY6RgLZuLftwA4o9DEq54ecCrumD5jIziGn7RdjjU6lVZ7FDpyka07U6WKysT6AnOFCWoRDCOPfaKO/5Ec6WsQ2amCeZhp6jnpP/4g81kpOzWXGNn1z7ytXbQgT4ApxBcbJb+HXlA+k+GfvJFQg9VF3cmNrM07yVSq87XhxOIuDeUJQd+xwTGsGBcidkfiOb6xlDHpR5pZL0JL9TxFO9hoZxEBMNLJEEgDZdVSCYaJSGg25606bUGWKIPblKvKPH9t4uUOUrJ8aCvow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SCRL4m4dDeLGllexvaltPaOpxyrqzaWYvk1JaSDAksg=;
 b=l0JoCal7pTojZCTg0L9fk6jlQMibmEh/SkSV0WiOKarYJ2YD+W/I1NZEB85h5Itgsq4EVpdcEcfGT5Kp/GG6dABHxngT42WiOe6w6Y2fxbiDR8BTiljbKlsOdWaRBL4STBBU5mqJj33ZVxhyapb1b4MG9rQ+NL0X0axOsGsqrFE=
Received: from BN9PR03CA0142.namprd03.prod.outlook.com (2603:10b6:408:fe::27)
 by BN9PR12MB5100.namprd12.prod.outlook.com (2603:10b6:408:119::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Wed, 7 Dec
 2022 00:45:15 +0000
Received: from BN8NAM11FT073.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fe:cafe::df) by BN9PR03CA0142.outlook.office365.com
 (2603:10b6:408:fe::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14 via Frontend
 Transport; Wed, 7 Dec 2022 00:45:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT073.mail.protection.outlook.com (10.13.177.231) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5901.14 via Frontend Transport; Wed, 7 Dec 2022 00:45:15 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 6 Dec
 2022 18:45:13 -0600
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, Shannon Nelson <shannon.nelson@amd.com>
Subject: [PATCH v2 net-next 13/16] pds_core: devlink params for enabling VIF support
Date:   Tue, 6 Dec 2022 16:44:40 -0800
Message-ID: <20221207004443.33779-14-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221207004443.33779-1-shannon.nelson@amd.com>
References: <20221207004443.33779-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT073:EE_|BN9PR12MB5100:EE_
X-MS-Office365-Filtering-Correlation-Id: 10dc3e47-e8cb-4fdf-38b8-08dad7ec4e85
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n35XT5TNIeOTjlfr+4Bo83mTwHNdE5/GppSirichD+ZF6Vdv7LZP9VSzGcE2g1YFZ1YyIyOwFyaWxlRDLDxqKGovuTEmUt8Z6YBaJ1Nxof5ElIlKzFZNgiEjQhai5j92yUmAH/t1ue2qvBQ6MOEiHhn3R0FyAgNy5HXr0icpoDEcLMVPxALYlBXq22XW1dZr/JkgCofzkpDsnV6dtcTjijVu3mRdMX3WS99lwiZ9525GmNoKD1XWLfKLsSbCvXezUQxnHBr6DMcemcwgqJpyph6ulsQyrdVEiKjIQf5ECBnjvNxNjueJaMbxsX3Bi2bgLXd5VOYPx7/n7aCJ1GK9ZEwQU0QpQbnMRHDUCqWG1gR7O3YhbVKRHmBDDHTfQKVqAwnVj83N94kXCAqRggrHziKBIpdl/mBDsZPmYT0AZktS5Lp+HzHJY3jaS8ViQBAAXk9EcSoOB489rV/ImLs6Y+GJHTHB9jOWXaOnlV/Y5ZGhJs++fxH3glVj3v+Epa7ZDruj57/RXv2WQfluqp71Z/Hc2YVg0ZFOAxoTwE44b8sqSf4mBRIK//e9oE2sDUX7qtzd7n6ZGYkO0JBodRMeegOOaICI6cioU/3WKZPMoG7NHp0wLhgRYqavmk/Cto981UxR3PsGvgJd8QBkQ+YxUpSoWrjQbDHO2VDittTU6AYksKs4HZxXYUMy+sEo8WqoNZ52Uw3uj6MYLOLnY5lUe+sDaW/U3b0wCavq/JShKxY=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(376002)(346002)(39860400002)(451199015)(40470700004)(36840700001)(46966006)(83380400001)(36860700001)(86362001)(356005)(5660300002)(81166007)(44832011)(4326008)(8936002)(2906002)(82740400003)(40460700003)(41300700001)(70206006)(82310400005)(8676002)(40480700001)(26005)(6666004)(426003)(336012)(47076005)(1076003)(186003)(16526019)(110136005)(316002)(2616005)(54906003)(70586007)(478600001)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 00:45:15.5485
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 10dc3e47-e8cb-4fdf-38b8-08dad7ec4e85
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT073.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
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
 .../net/ethernet/pensando/pds_core/devlink.c  | 97 +++++++++++++++++++
 1 file changed, 97 insertions(+)

diff --git a/drivers/net/ethernet/pensando/pds_core/devlink.c b/drivers/net/ethernet/pensando/pds_core/devlink.c
index 0ba4bbbe5f7f..f3df806f7e6b 100644
--- a/drivers/net/ethernet/pensando/pds_core/devlink.c
+++ b/drivers/net/ethernet/pensando/pds_core/devlink.c
@@ -8,6 +8,75 @@
 
 #include "core.h"
 
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
+	int vf;
+
+	vt_entry = pdsc_dl_find_viftype_by_id(pdsc, id);
+	if (!vt_entry || !vt_entry->supported)
+		return -EOPNOTSUPP;
+
+	if (vt_entry->enabled == ctx->val.vbool)
+		return 0;
+
+	vt_entry->enabled = ctx->val.vbool;
+	for (vf = 0; vf < pdsc->num_vfs; vf++) {
+		err = ctx->val.vbool ? pdsc_auxbus_dev_add_vf(pdsc, vf) :
+				       pdsc_auxbus_dev_del_vf(pdsc, vf);
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
 static int pdsc_dl_fw_bank_get(struct devlink *dl, u32 id,
 			       struct devlink_param_gset_ctx *ctx)
 {
@@ -69,8 +138,35 @@ static const struct devlink_param pdsc_dl_params[] = {
 			      pdsc_dl_fw_bank_get,
 			      pdsc_dl_fw_bank_set,
 			      pdsc_dl_fw_bank_validate),
+	DEVLINK_PARAM_GENERIC(ENABLE_VNET,
+			      BIT(DEVLINK_PARAM_CMODE_RUNTIME),
+			      pdsc_dl_enable_get,
+			      pdsc_dl_enable_set,
+			      pdsc_dl_enable_validate),
+	DEVLINK_PARAM_GENERIC(ENABLE_MIGRATION,
+			      BIT(DEVLINK_PARAM_CMODE_RUNTIME),
+			      pdsc_dl_enable_get,
+			      pdsc_dl_enable_set,
+			      pdsc_dl_enable_validate),
 };
 
+static void pdsc_dl_set_params_init_values(struct devlink *dl)
+{
+	struct pdsc *pdsc = devlink_priv(dl);
+	union devlink_param_value value;
+	int vt;
+
+	for (vt = 0; vt < PDS_DEV_TYPE_MAX; vt++) {
+		if (!pdsc->viftype_status[vt].dl_id)
+			continue;
+
+		value.vbool = pdsc->viftype_status[vt].enabled;
+		devlink_param_driverinit_value_set(dl,
+						   pdsc->viftype_status[vt].dl_id,
+						   value);
+	}
+}
+
 static int pdsc_dl_flash_update(struct devlink *dl,
 				struct devlink_flash_update_params *params,
 				struct netlink_ext_ack *extack)
@@ -166,6 +262,7 @@ int pdsc_dl_register(struct pdsc *pdsc)
 				      ARRAY_SIZE(pdsc_dl_params));
 	if (err)
 		return err;
+	pdsc_dl_set_params_init_values(dl);
 
 	devlink_register(dl);
 
-- 
2.17.1

