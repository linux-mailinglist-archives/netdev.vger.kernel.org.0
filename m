Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82A076AFE28
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 06:14:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbjCHFOc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 00:14:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbjCHFNv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 00:13:51 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2042.outbound.protection.outlook.com [40.107.237.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCD1294F53
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 21:13:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UmA8Nrn+JbIxIC+deoDN6vUxshR2tpCsPdRTLLOVZhVeUw5Dpoyntu9dSaIUdA/gL3dgkgLhKQtxt6b0FrEyQzs0hwVB3qB9+Vg38PcSLNZB4L1PnoBV28dKpzPIOycmo/hnlaPRCl5SleiwpKa7aiXBW7nUZYsxrQJnzHukoyhrKb4x6kGlNzBBhTZX0zWT1Au6dS5foHTdD91wAkBU2QeD/xFwLII18XMwPb/M9utITVr33c2HNIlzV/Ri622F+DQ7j06A4yHt9WUN0sUY+eKrgG9XFERzT6nrLLwS1In0QjKh4B5J6iUxNVxzLK1uMozJCUEpjKdfoEhZNttYdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YrXgj2cby6AvVhetP/phib1xEt5X175l9Bn6I1bZCLE=;
 b=EWOoldWMP1TuoC144X1vTqJKWumY0JcBo/zRQGPHdAoi7T9Cn499gpQx94finBdK5qIESfjkB6OL2q3ZHyRx9yhOprLiRUPGEXb0KN5VN64wU4rUthUryP7vXEIeDRtR/6lHGj1t7BLGo5Q0H8kEw3tj22+hsZow8C2bsXCRF8jYnl6XqPv+1J3AitPPoswGaJUTqcISJUBc9YhjFzC2UbmcEXqJa9KAh2WDQPAfPm1gkESB1l8gNf4hN2o6osHqbAh8uDWDx6eR2rT0zzkDMRbqDxv4CMLzn8XVNfhGhFwsNZrN8NS9C3NRtirvEqLsb1Rdg+KIih7qsrVHRXgDYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YrXgj2cby6AvVhetP/phib1xEt5X175l9Bn6I1bZCLE=;
 b=K64ILilrs9z3T/YnuvQY1fPay1GJ78d13PT995onXopUuD+FFCLWdV557I+tmAHZ7wgiwDfDUXh+MEhLCKcoDaFlnJxHSH59rxP/teXQpH8i6S58hpERlixfMthcmEsVXHYTNhz79c1S41W89WcDXdItP94YAyqLa3sKjKiEOkg=
Received: from BN9P223CA0019.NAMP223.PROD.OUTLOOK.COM (2603:10b6:408:10b::24)
 by DS0PR12MB6486.namprd12.prod.outlook.com (2603:10b6:8:c5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.26; Wed, 8 Mar
 2023 05:13:43 +0000
Received: from BN8NAM11FT080.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10b:cafe::c6) by BN9P223CA0019.outlook.office365.com
 (2603:10b6:408:10b::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.17 via Frontend
 Transport; Wed, 8 Mar 2023 05:13:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT080.mail.protection.outlook.com (10.13.176.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6178.17 via Frontend Transport; Wed, 8 Mar 2023 05:13:43 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 7 Mar
 2023 23:13:41 -0600
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <leon@kernel.org>, <jiri@resnulli.us>
Subject: [PATCH RFC v4 net-next 10/13] pds_core: devlink params for enabling VIF support
Date:   Tue, 7 Mar 2023 21:13:07 -0800
Message-ID: <20230308051310.12544-11-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230308051310.12544-1-shannon.nelson@amd.com>
References: <20230308051310.12544-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT080:EE_|DS0PR12MB6486:EE_
X-MS-Office365-Filtering-Correlation-Id: a3024755-1ad4-422a-370a-08db1f93e339
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sYu72EQRCnaPLJTXl0+WiS8YLT6ZSdpruXLEuAQCdQ55ol5s6ogSDf2tLDvV79zCd9Np4NVbT6Eg2NGpMotWDhXZcpxkyqCygQD7FxA/ptYoR5K5YE9yogY6hLnk3Ur95717WVoAZtwcNIyBDPb1WG0dEJNil6YlcEyRtKdDqJzUHNRVFwB6H0RbtSzJyAIutMZKA4vlivvIMGW+Hap5ASxkiXwwZygktEHh/vvGUQeKwvh0hhUTt3K5UdxUiC/nnKWnYRsnU07UeB/5AMQtrPQblQL5gKinKaQEB/8Krs8nzn3x/M3DFRwXawZUhBSHBfLEo7wCwTb9EMJFm8gBTLgRIKzig46bp2H3IKkXQrPNnrnMeJ8grDto/STryqKP5xnGg3EvoAoZ2bPkLYpgn64Kge7lbhgxSSFl46VNmf6SUDCaXlmiP83IXC7vFBLpBsQY3rJCeOrzCvwOZzlXTw1ta4n3SMKZO90tHHIBacurGhmgIyJ11a6ON0iGdUFjmXSEBtT85ApXhLbFOQ48Doqm75eBhCT/ynuOp41NU0wX3Nrpe6OqcZ+ll2IIY1XSee9d65LwJE6lLL4d9Te7oWBUnUNlvPmeYHIwJGhkzFneQ4tHBZR6MD/n2ssf3l6i7v5Q3gAtPbpbUMWDJoU+K7LaVPPdcMHwt7J5MlK3Ae8RXz+Hkb21qq8aUeQ3rlYG7mmQFMwqt8QGh+QlZIknR6tQZCEFBiEua1349tfTFeY=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(346002)(136003)(396003)(376002)(451199018)(36840700001)(46966006)(40470700004)(1076003)(6666004)(36860700001)(36756003)(47076005)(426003)(82310400005)(86362001)(40460700003)(81166007)(356005)(186003)(83380400001)(40480700001)(82740400003)(16526019)(336012)(26005)(41300700001)(70206006)(70586007)(4326008)(2906002)(8676002)(8936002)(2616005)(5660300002)(44832011)(478600001)(316002)(54906003)(110136005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2023 05:13:43.5575
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a3024755-1ad4-422a-370a-08db1f93e339
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT080.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6486
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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
index 7f2016807e5e..693702403018 100644
--- a/drivers/net/ethernet/amd/pds_core/devlink.c
+++ b/drivers/net/ethernet/amd/pds_core/devlink.c
@@ -7,6 +7,86 @@
 #include <linux/pci.h>
 
 #include <linux/pds/pds_core.h>
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
@@ -100,6 +180,14 @@ void pdsc_dl_free(struct pdsc *pdsc)
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
+	}
 
 	devlink_register(dl);
 
-- 
2.17.1

