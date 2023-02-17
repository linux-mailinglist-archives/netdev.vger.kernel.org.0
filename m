Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C379A69B5C7
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 23:57:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbjBQW5q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 17:57:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229814AbjBQW5V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 17:57:21 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2082.outbound.protection.outlook.com [40.107.220.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D078C67451
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 14:56:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OaW7hG9iUvd2U5i8bEhvCiWBFzcdj33T8yXZnJvoTQp8KvUmRo4yfclpnksoPl9wOzB2V9x/Pd8V8tBa51yzbYCR1y8dnijVEHSjiQiWxOy8p+h95dyqMYhZ8nNKrf2JaPH6dFHFpFs7gA99hLlIE8o4Dpfkl+50Gs6aLP66Mmlu+3POZRnS5KIQ3WrewgvobulyygJTXJAtSs2WVujMi9W+4S4BPoMgKpH+0s1xyUi9shbI70LsK89WAZy9xvT0+e/xMXmXntT7Qgo0LTTyK7ouhgJXpmgMPehG0zEIQO7CbJEcSQ/U/3S5zHLTo1oH+jL7Ykj5xV8f/Yose/oS5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HAIkdzsDk+YYCfojLYG8z/2HkopA+h4uJ1mr8RZJD2U=;
 b=XVRDjpIpUYcccBdRiLJrV6wt8Qz4lPcnWJH/Hs3E1PNHw8nr77MK5Q3oz13vbfg0y17GgW+aVpIbYjEQq7oM7QPSMDZMJa1pWHOO9lbt4na6R1zHwnumSBKJBsnxqMSTqLeq6qsVo9+D2SBzc8k6m7Fw1VifF1jbuFw15VFY1DLjuF0ZOUEDZLFcDJXDFWT5iXImE2iyVAw0XQLO2LH+YkKQM/+T/qTDc9crpVNwNumjESNQKwJBTVh6P8fAs6wErABrkNnVsbey2VaCVx1xh37KlGv3tT+/Gsga1z+qfDqYyj/tuJxnv2WLf1h2k2K139GfG9mzR6zxAMSqHxRXRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HAIkdzsDk+YYCfojLYG8z/2HkopA+h4uJ1mr8RZJD2U=;
 b=c4+qykAkHDzeZY0450v8H580ck/IQJhThtg5L1YNH9Rj5xb9UAnTXVUCCSVCKvnWySSCH+63SbH9EMgq8YZzVtPR6EQtmRuAdxcyg/Uw1nzl8p7b04ByYwTmiwrAeuM1d+rOM3KZAlbj6lm4O4Z1qV4iWRMLltxXk8E928ANkjQ=
Received: from DS7PR05CA0007.namprd05.prod.outlook.com (2603:10b6:5:3b9::12)
 by MN0PR12MB5785.namprd12.prod.outlook.com (2603:10b6:208:374::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Fri, 17 Feb
 2023 22:56:47 +0000
Received: from CO1PEPF00001A63.namprd05.prod.outlook.com
 (2603:10b6:5:3b9:cafe::8f) by DS7PR05CA0007.outlook.office365.com
 (2603:10b6:5:3b9::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.11 via Frontend
 Transport; Fri, 17 Feb 2023 22:56:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF00001A63.mail.protection.outlook.com (10.167.241.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6134.14 via Frontend Transport; Fri, 17 Feb 2023 22:56:47 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 17 Feb
 2023 16:56:45 -0600
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <brett.creeley@amd.com>,
        Shannon Nelson <shannon.nelson@amd.com>
Subject: [PATCH v3 net-next 11/14] pds_core: devlink params for enabling VIF support
Date:   Fri, 17 Feb 2023 14:55:55 -0800
Message-ID: <20230217225558.19837-12-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230217225558.19837-1-shannon.nelson@amd.com>
References: <20230217225558.19837-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF00001A63:EE_|MN0PR12MB5785:EE_
X-MS-Office365-Filtering-Correlation-Id: 5486bb70-fa40-4068-121d-08db113a3f8c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gRa6T6UukG/iZOufx4rx+ADRx5aBwT/8RtFiQE2Vf75k8xxa/YMBbd3WCT418CXkgGMS8lzY/mF6TGOxEvBVWip9VSq4FCdyZ0psZdOig9eOrnBe1ziEd6KfD7jSsBDwweikQXaeql2ZAuL5voF5XUQiW3D/oknRQURXbSNrpBq+StPSCF8LXaDXJKJtpSlTbQkNOhsbkTrgaLTueN9cINVs+Mc8sbZNwFBVXcOdSTcyL8ubEuCtkmcxLeqib3CxtJuTJoflaj6AuICR4Qz+5oHgAsegkmTBiy3L2BxJQFzPQAO7twSVcox6BW0T1ddo/XmGu/LMH+znURd/CT5BaCT5pOrD19C2xyP5C46x46GkPl7BU3n0Tp4aKJIBCJ2Ybhh6Ij4n9KIpb/bd55H/epj8GtgdPZuxw8QAHMGPkUWuetUpdNTu1jmbkvYN3CL0b8Cy0zzhAMrqfDe5lE/aaiA2x36GL6k1pyxbVQTAuiESEj3Sc4VKSdTjU3jIahiZFSfnsno4wqV4ChudDza5YkyxmuElPVSjdpR/eaLsz1oD8uhO4OEJhmUwjCfI2/9dtgE0ndGGLKOOmF6NIZTI2en1enJaE8gHRXWDS/tZ9wfChgKXGg0BpXXpp+J/Y1MoMbErBaXzT96hgnIfoXzBlbBu9ez2DqrGJ7Rkl5z6MnqEUT3+Qhh5pPD5h5gitl94NC0YJG9tVw7YCnSunoi0nc+CA6jsm2wYSwavlVpw90k=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(39860400002)(136003)(376002)(451199018)(36840700001)(46966006)(40470700004)(478600001)(6666004)(1076003)(2906002)(26005)(16526019)(186003)(82740400003)(2616005)(40460700003)(110136005)(47076005)(82310400005)(44832011)(36756003)(336012)(426003)(356005)(36860700001)(86362001)(8936002)(41300700001)(5660300002)(81166007)(316002)(54906003)(83380400001)(40480700001)(8676002)(70586007)(4326008)(70206006)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2023 22:56:47.3414
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5486bb70-fa40-4068-121d-08db113a3f8c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1PEPF00001A63.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5785
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the devlink parameter switches so the user can enable
the features supported by the VFs.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/net/ethernet/amd/pds_core/devlink.c | 88 +++++++++++++++++++++
 1 file changed, 88 insertions(+)

diff --git a/drivers/net/ethernet/amd/pds_core/devlink.c b/drivers/net/ethernet/amd/pds_core/devlink.c
index df125ed0aa8c..bd673cbf07c4 100644
--- a/drivers/net/ethernet/amd/pds_core/devlink.c
+++ b/drivers/net/ethernet/amd/pds_core/devlink.c
@@ -8,6 +8,88 @@
 
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
+static const struct devlink_param pdsc_dl_params[] = {
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
+};
+
 static int pdsc_dl_flash_update(struct devlink *dl,
 				struct devlink_flash_update_params *params,
 				struct netlink_ext_ack *extack)
@@ -97,6 +179,12 @@ void pdsc_dl_free(struct pdsc *pdsc)
 int pdsc_dl_register(struct pdsc *pdsc)
 {
 	struct devlink *dl = priv_to_devlink(pdsc);
+	int err;
+
+	err = devlink_params_register(dl, pdsc_dl_params,
+				      ARRAY_SIZE(pdsc_dl_params));
+	if (err)
+		return err;
 
 	devlink_register(dl);
 
-- 
2.17.1

