Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 843046E55EA
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 02:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbjDRAdf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 20:33:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbjDRAdI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 20:33:08 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2062c.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e83::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D269E4EFE
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 17:33:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C/CRVtLCM6V/aaUkphGHFh1vVj7C+3WSEwXXoF425qMBMm3ECrEoFOt8T4gswoMZ+3DsOjZCGr40DFG7TYM/ZW57h7dHsFcRSdOpvuCOX89m6JahpVUqnQdYeovO08WeTKQ9kk3Oy9xRcM2IxpboOb+6HXfXDqLf0RJ64wSKGsMNey1VXBX1zoRh8GfRkrbczU3qjt9IzgKBa8vcn+YV0cPkwdf54NN28y4ji+k0tmnwSrK3uRF2/by39k5CcEORQa2fw9cpY6jT32czaG43dMM0CzJl3iFyhl9TP1mwK903eBUkvrFV+lVrMlthKiu4mPdyS4YBtLTjtr1YhT4Cpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Guz4jmSs/1RD9y4gk31Uob+xHShOlWkuCSZ/mPFRfSY=;
 b=I2FdTaQ27FHAqMnojXRxrVYCnpG0KP5NUYnnHUZjkDiQnIMbCAxV53V32HRIeMy5RVMBO9pjx3M58Y0BE7NOERAfOFCZD0XJeLMBxrgwW9C7sK0n2Sbs2MqDr17jpsJSArn53RnY4lOoDU6SY/kc9arkoif8VN7EYE9lIy01wiD18is1Tz/WIqnxp77vrsYQ6iRonCqnYXiWku2fIMh/D6lzeUwk+jFkY3Zh6Ihz5PFGFT2eooNMN0MQAA4ZCXlU+SBrWUgKELKbkJLkcg8D8yvljNAFizoLJy5lcZVw4AwRlm093eTI4yNqX9wD0ay7xPiR/V09P4jskERrCD9+Bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Guz4jmSs/1RD9y4gk31Uob+xHShOlWkuCSZ/mPFRfSY=;
 b=Z/SPXjQm9kTJHktevfU2gUx/EmmOA32pK6y7sf7VSiaXXPc+iNAfHz94ybtzByAWjPMxIdxgka3C1KjWcgyqygw9J3gUgzqws1A1ghXtG1UfgApunVE+nGHXUC5q3U1YigJNsMSa4SEyEhhxzP/M/GCKtPWh5S2SIt6mhflrOIk=
Received: from BN9PR03CA0572.namprd03.prod.outlook.com (2603:10b6:408:10d::7)
 by MW4PR12MB7000.namprd12.prod.outlook.com (2603:10b6:303:20a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Tue, 18 Apr
 2023 00:33:02 +0000
Received: from BN8NAM11FT051.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10d:cafe::3f) by BN9PR03CA0572.outlook.office365.com
 (2603:10b6:408:10d::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.46 via Frontend
 Transport; Tue, 18 Apr 2023 00:33:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT051.mail.protection.outlook.com (10.13.177.66) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6319.20 via Frontend Transport; Tue, 18 Apr 2023 00:33:01 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 17 Apr
 2023 19:33:00 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <leon@kernel.org>, <jiri@resnulli.us>,
        <simon.horman@corigine.com>
Subject: [PATCH v10 net-next 08/14] pds_core: set up the VIF definitions and defaults
Date:   Mon, 17 Apr 2023 17:32:22 -0700
Message-ID: <20230418003228.28234-9-shannon.nelson@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN8NAM11FT051:EE_|MW4PR12MB7000:EE_
X-MS-Office365-Filtering-Correlation-Id: 73006e26-06c8-4d4c-30bd-08db3fa477bb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i/c/vChtBNxzCnpMXx2THKxHxXXTD4IfrnrJu7+1z4K39Nx6AewJJcdW3ZsOt5ibli+PPc4oXHKIBuoqNS74hnhwCQT40jEazdDp9DiMoz2VUG591mysdprdiF0XTrO/OMqvr/ZcTR0aZ8fDaJy1xo/rePcXefUvD36JKqPV7BVCgc5izg7i2bXwgC7KSyqtxfzqZomrjFpT3ermZYEaB2EyX2l6zE+YY9mgLArVaXwnAdEcOg3OpQfVJeGNex72oPVemCxN7K6hjrPS+GLs1V5CmRLevJJk6jA4p9LL9M84SR+8rZqMJaSoZNmMOGE6yRPysAMEb9H2Vxx1v9elxgifrQepPRQUDnacJ9xyB0+To+Oj0o1c1uE55rymD/oRB70WS5SB122X9RrkC19vn7gptdjElpEAf2tx4d6DkNnXn9wYOyjWNjq2wSLmrNoMq27COOKzIa0GbR1ptlcUdyt3n8XdoRoj9Qi+rYSzJ1/rpDqeLRN3WhMii4qMI4TQYYg2RryRl/uTBzpxYYYR7s6bZ/KER2dpYSL9Z1dKdJ5Bz+5RQ5Z8sdQW4UDaTmQBwHO9Ak6nWbXwjxQpeTXi66HBUER0T6QPeIneXb5GCB/tmOdGc7TM3O9xeIrCziEaPr9nw1uWGAVGyE5vVB+HKMOsbIPa+gk1XGAC34Snm4U98pDqAiFwxIxCBDYsDRKId2K6hQEg02wmesK7K8qXIX/cooWKY64lrzEbICgNh9M6UjLcxOZuv5Fn1DPwHkjm1h3dCDylCEGACo1a7pVNmw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(346002)(376002)(39860400002)(451199021)(36840700001)(46966006)(40470700004)(5660300002)(40460700003)(2906002)(70586007)(4326008)(36756003)(70206006)(44832011)(86362001)(8936002)(81166007)(41300700001)(82310400005)(6666004)(478600001)(316002)(356005)(8676002)(82740400003)(40480700001)(54906003)(110136005)(26005)(1076003)(336012)(426003)(36860700001)(2616005)(16526019)(47076005)(186003)(83380400001)(36900700001)(309714004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2023 00:33:01.8531
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 73006e26-06c8-4d4c-30bd-08db3fa477bb
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT051.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7000
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Virtual Interfaces (VIFs) supported by the DSC's
configuration (vDPA, Eth, RDMA, etc) are reported in the
dev_ident struct and made visible in debugfs.  At this point
only vDPA is supported in this driver so we only setup
devices for that feature.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Acked-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/amd/pds_core/core.c    | 48 +++++++++++++++++++++
 drivers/net/ethernet/amd/pds_core/core.h    | 11 +++++
 drivers/net/ethernet/amd/pds_core/debugfs.c | 24 +++++++++++
 include/linux/pds/pds_common.h              | 19 ++++++++
 4 files changed, 102 insertions(+)

diff --git a/drivers/net/ethernet/amd/pds_core/core.c b/drivers/net/ethernet/amd/pds_core/core.c
index 59daf8a67ac6..b2fca3b99f02 100644
--- a/drivers/net/ethernet/amd/pds_core/core.c
+++ b/drivers/net/ethernet/amd/pds_core/core.c
@@ -346,6 +346,43 @@ static int pdsc_core_init(struct pdsc *pdsc)
 	return err;
 }
 
+static struct pdsc_viftype pdsc_viftype_defaults[] = {
+	[PDS_DEV_TYPE_VDPA] = { .name = PDS_DEV_TYPE_VDPA_STR,
+				.vif_id = PDS_DEV_TYPE_VDPA,
+				.dl_id = DEVLINK_PARAM_GENERIC_ID_ENABLE_VNET },
+	[PDS_DEV_TYPE_MAX] = {}
+};
+
+static int pdsc_viftypes_init(struct pdsc *pdsc)
+{
+	enum pds_core_vif_types vt;
+
+	pdsc->viftype_status = kzalloc(sizeof(pdsc_viftype_defaults),
+				       GFP_KERNEL);
+	if (!pdsc->viftype_status)
+		return -ENOMEM;
+
+	for (vt = 0; vt < PDS_DEV_TYPE_MAX; vt++) {
+		bool vt_support;
+
+		if (!pdsc_viftype_defaults[vt].name)
+			continue;
+
+		/* Grab the defaults */
+		pdsc->viftype_status[vt] = pdsc_viftype_defaults[vt];
+
+		/* See what the Core device has for support */
+		vt_support = !!le16_to_cpu(pdsc->dev_ident.vif_types[vt]);
+		dev_dbg(pdsc->dev, "VIF %s is %ssupported\n",
+			pdsc->viftype_status[vt].name,
+			vt_support ? "" : "not ");
+
+		pdsc->viftype_status[vt].supported = vt_support;
+	}
+
+	return 0;
+}
+
 int pdsc_setup(struct pdsc *pdsc, bool init)
 {
 	int numdescs;
@@ -388,6 +425,14 @@ int pdsc_setup(struct pdsc *pdsc, bool init)
 	if (err)
 		goto err_out_teardown;
 
+	/* Set up the VIFs */
+	err = pdsc_viftypes_init(pdsc);
+	if (err)
+		goto err_out_teardown;
+
+	if (init)
+		pdsc_debugfs_add_viftype(pdsc);
+
 	clear_bit(PDSC_S_FW_DEAD, &pdsc->state);
 	return 0;
 
@@ -404,6 +449,9 @@ void pdsc_teardown(struct pdsc *pdsc, bool removing)
 	pdsc_qcq_free(pdsc, &pdsc->notifyqcq);
 	pdsc_qcq_free(pdsc, &pdsc->adminqcq);
 
+	kfree(pdsc->viftype_status);
+	pdsc->viftype_status = NULL;
+
 	if (pdsc->intr_info) {
 		for (i = 0; i < pdsc->nintrs; i++)
 			pdsc_intr_free(pdsc, i);
diff --git a/drivers/net/ethernet/amd/pds_core/core.h b/drivers/net/ethernet/amd/pds_core/core.h
index 7eb02b359f3a..ac0480d7f0f1 100644
--- a/drivers/net/ethernet/amd/pds_core/core.h
+++ b/drivers/net/ethernet/amd/pds_core/core.h
@@ -123,6 +123,15 @@ struct pdsc_qcq {
 	struct dentry *dentry;
 };
 
+struct pdsc_viftype {
+	char *name;
+	bool supported;
+	bool enabled;
+	int dl_id;
+	int vif_id;
+	struct pds_auxiliary_dev *padev;
+};
+
 /* No state flags set means we are in a steady running state */
 enum pdsc_state_flags {
 	PDSC_S_FW_DEAD,		    /* stopped, wait on startup or recovery */
@@ -174,6 +183,7 @@ struct pdsc {
 	struct pdsc_qcq adminqcq;
 	struct pdsc_qcq notifyqcq;
 	u64 last_eid;
+	struct pdsc_viftype *viftype_status;
 };
 
 /** enum pds_core_dbell_bits - bitwise composition of dbell values.
@@ -237,6 +247,7 @@ void pdsc_debugfs_destroy(void);
 void pdsc_debugfs_add_dev(struct pdsc *pdsc);
 void pdsc_debugfs_del_dev(struct pdsc *pdsc);
 void pdsc_debugfs_add_ident(struct pdsc *pdsc);
+void pdsc_debugfs_add_viftype(struct pdsc *pdsc);
 void pdsc_debugfs_add_irqs(struct pdsc *pdsc);
 void pdsc_debugfs_add_qcq(struct pdsc *pdsc, struct pdsc_qcq *qcq);
 void pdsc_debugfs_del_qcq(struct pdsc_qcq *qcq);
diff --git a/drivers/net/ethernet/amd/pds_core/debugfs.c b/drivers/net/ethernet/amd/pds_core/debugfs.c
index b83e5016644b..8ec392299b7d 100644
--- a/drivers/net/ethernet/amd/pds_core/debugfs.c
+++ b/drivers/net/ethernet/amd/pds_core/debugfs.c
@@ -68,6 +68,30 @@ void pdsc_debugfs_add_ident(struct pdsc *pdsc)
 			    pdsc, &identity_fops);
 }
 
+static int viftype_show(struct seq_file *seq, void *v)
+{
+	struct pdsc *pdsc = seq->private;
+	int vt;
+
+	for (vt = 0; vt < PDS_DEV_TYPE_MAX; vt++) {
+		if (!pdsc->viftype_status[vt].name)
+			continue;
+
+		seq_printf(seq, "%s\t%d supported %d enabled\n",
+			   pdsc->viftype_status[vt].name,
+			   pdsc->viftype_status[vt].supported,
+			   pdsc->viftype_status[vt].enabled);
+	}
+	return 0;
+}
+DEFINE_SHOW_ATTRIBUTE(viftype);
+
+void pdsc_debugfs_add_viftype(struct pdsc *pdsc)
+{
+	debugfs_create_file("viftypes", 0400, pdsc->dentry,
+			    pdsc, &viftype_fops);
+}
+
 static const struct debugfs_reg32 intr_ctrl_regs[] = {
 	{ .name = "coal_init", .offset = 0, },
 	{ .name = "mask", .offset = 4, },
diff --git a/include/linux/pds/pds_common.h b/include/linux/pds/pds_common.h
index f0798ce01acf..b2be14ebadb6 100644
--- a/include/linux/pds/pds_common.h
+++ b/include/linux/pds/pds_common.h
@@ -20,6 +20,25 @@ enum pds_core_driver_type {
 	PDS_DRIVER_ESXI    = 6,
 };
 
+enum pds_core_vif_types {
+	PDS_DEV_TYPE_CORE	= 0,
+	PDS_DEV_TYPE_VDPA	= 1,
+	PDS_DEV_TYPE_VFIO	= 2,
+	PDS_DEV_TYPE_ETH	= 3,
+	PDS_DEV_TYPE_RDMA	= 4,
+	PDS_DEV_TYPE_LM		= 5,
+
+	/* new ones added before this line */
+	PDS_DEV_TYPE_MAX	= 16   /* don't change - used in struct size */
+};
+
+#define PDS_DEV_TYPE_CORE_STR	"Core"
+#define PDS_DEV_TYPE_VDPA_STR	"vDPA"
+#define PDS_DEV_TYPE_VFIO_STR	"VFio"
+#define PDS_DEV_TYPE_ETH_STR	"Eth"
+#define PDS_DEV_TYPE_RDMA_STR	"RDMA"
+#define PDS_DEV_TYPE_LM_STR	"LM"
+
 #define PDS_CORE_IFNAMSIZ		16
 
 /**
-- 
2.17.1

