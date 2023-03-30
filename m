Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DCEA6D1392
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 01:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231689AbjC3XrY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 19:47:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231669AbjC3Xq4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 19:46:56 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2049.outbound.protection.outlook.com [40.107.212.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65A7EEB57
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 16:46:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ILldmZLFntDbnqYAzm7QbVtGzWL88r3tIHW/gOwn78UmCLBETRYUOzEe/ulvh/6FoVfoJlVfP8gNCrlai8tu98SiAZ1iESA2+c+YdxXEWBY8Vqv5kPL8kPVSfDVcHji8gatUuqo8bcv3MN+TBtNRf63HKEeoDJjCO+8F/rGP99J5j7iQHSaUZDDDLaAlnYCPy8U1OMTgshTPMa//JgD7k7i8Jt2TzXKu9m5qKqLNm+Vn4LnHeYO/WofJRujmotqbK1niOEvihcfN5n3DBov/s/F96kOwxOl0lE9A1iS7E2tgdPsyOUgWQ/ih+kmFX2/OWuD9LIT6kUhNl9V68TX43Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lFcCTGodoUmaG6ObIXNH1eUS57Tpf85+8KFORDt6ua0=;
 b=aU3vIXu1CcOcG0E6+TKlbHz7ytyMAWDgQlwy4oJl4MXLTpW1QaD07EmjIzAA5hQEu9dK5Hag4I9+NewMV2rnQg9W6kEWqIvUoFsPkf1Hwa06icDIXduf6O1AbuzpG1EQ/2rizBvgGkWBZ/r/ZURwbJyg5TBuV2dX+qks+Mqc2SUGZST67kpuvm6jF/eMOzD9hETMcFqPMPltl68a6YICu+1co29w/6PdcT4FDSd5tOeRfgXlTJwMzMj50ACA9z+eyIGBLGhOGzO97wloohZkdcOK2/Z9lFunU/gVJnNRBQld6Jpnfuwj7ygDgp808lm+tUAI4zOw1NSfoMysrJThZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lFcCTGodoUmaG6ObIXNH1eUS57Tpf85+8KFORDt6ua0=;
 b=KeDpElS+Co6IuMZXf5za+Fnxjca4Fi1pbgw3RGz5DQ4He9mhZqZWneaW9CM/73s2hcU2W8OP1uhnkcKEKM7XvrJhGE2z7o+ul5l/OoPrxa17d9obdbqWbBgeCx/dLH3m/VcSypc+cuy/CenJGyQHDregfVXt/NWGqaX5AfX2X0M=
Received: from BLAPR03CA0097.namprd03.prod.outlook.com (2603:10b6:208:32a::12)
 by BL3PR12MB6570.namprd12.prod.outlook.com (2603:10b6:208:38d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.30; Thu, 30 Mar
 2023 23:46:52 +0000
Received: from BL02EPF000100D0.namprd05.prod.outlook.com
 (2603:10b6:208:32a:cafe::a6) by BLAPR03CA0097.outlook.office365.com
 (2603:10b6:208:32a::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.22 via Frontend
 Transport; Thu, 30 Mar 2023 23:46:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF000100D0.mail.protection.outlook.com (10.167.241.204) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6178.30 via Frontend Transport; Thu, 30 Mar 2023 23:46:52 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 30 Mar
 2023 18:46:51 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <leon@kernel.org>, <jiri@resnulli.us>
Subject: [PATCH v8 net-next 08/14] pds_core: set up the VIF definitions and defaults
Date:   Thu, 30 Mar 2023 16:46:22 -0700
Message-ID: <20230330234628.14627-9-shannon.nelson@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF000100D0:EE_|BL3PR12MB6570:EE_
X-MS-Office365-Filtering-Correlation-Id: 261711a0-a389-46ba-aee6-08db317909db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dqG+tqX65+XGtmr/kUvszKdVOxo+LbFUibEgro62+C6SyCUvyExfdqCozlUKqgdoqAbhef7oWrAGmt2ilrQfgvx4RVAHUVjNClpJj23VOMwYc6txwg2OEUKojdWbJjElUYnMMQmGvWm0zqMzwRH0wBMdvCbGz+aNCTACioXqUsxMVYZ+d/XKPyvTzPbf5GDFQzTnBWOEahuO0ByFasZa9wm04+ulDCzOPQiE8DWH7KOrjvFpXtjo6j83FS6AQZGsNuH20FE0ypKaleI1Pa8VvGAQuJrOP7hMJqht4OYTUK0MdAZmLZLmuvvzQVz02d0LwMwwUVi5Qcx2hfLzXimMLCr44pFpxKBrIV4U5JAYaZmP75HvoNcjhaozjWV6+6RTD/GsHDg2BlK0oauzArGK34y8UPQQkq36ShrOhgKgfqKbztQmlXnF9q0cY0Imq+YyszjANlwzbjwisHr+offMOBZOk294qo2zs8rOhF88oCG8pF1ASXpWrMW6qC7ISAF1qNuxp6p7QtA8DehvCFDkKUYDGavk6la9pp6E3mjmcYqHqowYTT98FBKDUg0OmAYTlz1ghVz8XLB+G8wnHfWdC59DX3SbD7vmh+OP08z+JE+y8nTQJArdzkn4jxtNtCTUOtoE+FGuRa2ofyaMBcG0Qo5XhrT2N3OsDnGqF8moSj6kiFlH6my46v2dTiCYXUnmB9bW09/BmXMK8raRKCjix8svzczOAXtgViJdA67Ps3Bk1RJ7a/lcLWYOgBNXwFrK
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(376002)(136003)(396003)(451199021)(36840700001)(40470700004)(46966006)(8936002)(8676002)(16526019)(40480700001)(47076005)(70206006)(83380400001)(186003)(40460700003)(336012)(5660300002)(44832011)(41300700001)(426003)(2616005)(4326008)(70586007)(81166007)(478600001)(82740400003)(6666004)(82310400005)(356005)(86362001)(110136005)(54906003)(1076003)(316002)(36756003)(26005)(2906002)(36860700001)(36900700001)(309714004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 23:46:52.8784
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 261711a0-a389-46ba-aee6-08db317909db
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF000100D0.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6570
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Virtual Interfaces (VIFs) supported by the DSC's
configuration (VFio Live Migration, vDPA, etc) are reported
in the dev_ident struct.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/net/ethernet/amd/pds_core/core.c    | 48 +++++++++++++++++++++
 drivers/net/ethernet/amd/pds_core/core.h    | 12 ++++++
 drivers/net/ethernet/amd/pds_core/debugfs.c | 24 +++++++++++
 include/linux/pds/pds_common.h              | 19 ++++++++
 4 files changed, 103 insertions(+)

diff --git a/drivers/net/ethernet/amd/pds_core/core.c b/drivers/net/ethernet/amd/pds_core/core.c
index 3b33939b9d4d..6ec9a081fcd6 100644
--- a/drivers/net/ethernet/amd/pds_core/core.c
+++ b/drivers/net/ethernet/amd/pds_core/core.c
@@ -351,6 +351,43 @@ static int pdsc_core_init(struct pdsc *pdsc)
 	return err;
 }
 
+static struct pdsc_viftype pdsc_viftype_defaults[] = {
+	[PDS_DEV_TYPE_VDPA] = { .name = PDS_DEV_TYPE_VDPA_STR,
+				.vif_id = PDS_DEV_TYPE_VDPA,
+				.dl_id = DEVLINK_PARAM_GENERIC_ID_ENABLE_VNET },
+	[PDS_DEV_TYPE_MAX] = { 0 }
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
@@ -393,6 +430,14 @@ int pdsc_setup(struct pdsc *pdsc, bool init)
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
 
@@ -409,6 +454,9 @@ void pdsc_teardown(struct pdsc *pdsc, bool removing)
 	pdsc_qcq_free(pdsc, &pdsc->notifyqcq);
 	pdsc_qcq_free(pdsc, &pdsc->adminqcq);
 
+	kfree(pdsc->viftype_status);
+	pdsc->viftype_status = NULL;
+
 	if (pdsc->intr_info) {
 		for (i = 0; i < pdsc->nintrs; i++)
 			pdsc_intr_free(pdsc, i);
diff --git a/drivers/net/ethernet/amd/pds_core/core.h b/drivers/net/ethernet/amd/pds_core/core.h
index a4ec1cb897f3..7737783a66e7 100644
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
@@ -239,6 +249,7 @@ void pdsc_debugfs_destroy(void);
 void pdsc_debugfs_add_dev(struct pdsc *pdsc);
 void pdsc_debugfs_del_dev(struct pdsc *pdsc);
 void pdsc_debugfs_add_ident(struct pdsc *pdsc);
+void pdsc_debugfs_add_viftype(struct pdsc *pdsc);
 void pdsc_debugfs_add_irqs(struct pdsc *pdsc);
 void pdsc_debugfs_add_qcq(struct pdsc *pdsc, struct pdsc_qcq *qcq);
 void pdsc_debugfs_del_qcq(struct pdsc_qcq *qcq);
@@ -248,6 +259,7 @@ static inline void pdsc_debugfs_destroy(void) { }
 static inline void pdsc_debugfs_add_dev(struct pdsc *pdsc) { }
 static inline void pdsc_debugfs_del_dev(struct pdsc *pdsc) { }
 static inline void pdsc_debugfs_add_ident(struct pdsc *pdsc) { }
+static inline void pdsc_debugfs_add_viftype(struct pdsc *pdsc) { }
 static inline void pdsc_debugfs_add_irqs(struct pdsc *pdsc) { }
 static inline void pdsc_debugfs_add_qcq(struct pdsc *pdsc,
 					struct pdsc_qcq *qcq) { }
diff --git a/drivers/net/ethernet/amd/pds_core/debugfs.c b/drivers/net/ethernet/amd/pds_core/debugfs.c
index 7168c3bd661b..803c13e2b922 100644
--- a/drivers/net/ethernet/amd/pds_core/debugfs.c
+++ b/drivers/net/ethernet/amd/pds_core/debugfs.c
@@ -73,6 +73,30 @@ void pdsc_debugfs_add_ident(struct pdsc *pdsc)
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
 static int irqs_show(struct seq_file *seq, void *v)
 {
 	struct pdsc *pdsc = seq->private;
diff --git a/include/linux/pds/pds_common.h b/include/linux/pds/pds_common.h
index e45a69178f74..350295091d9d 100644
--- a/include/linux/pds/pds_common.h
+++ b/include/linux/pds/pds_common.h
@@ -51,6 +51,25 @@ enum pds_core_driver_type {
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

