Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76BAD6E8017
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 19:05:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233669AbjDSRFk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 13:05:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233574AbjDSRFc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 13:05:32 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6A0C7DA0
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 10:05:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ny3xlGJlkpBimBfGEdDDZMnAkpd3I2+Faw6wzgqT3wRYxXL+Ap6TaJVHVGFf6g3BkwpK0XQcnPo/V0ItbAD8GYbKDYH7L/6zW+SrUtbJC8dUuWAQQxZYBQ8hszNGmQXQDy/u3MQ6WfmnkbQRYQS+TdyjKy6+5MwsM79l0NFI2VV4L7KbGLURZExVmShgz7anTRDF8YpUuIkzl9mXr9JSB50+l1JUaOSNL7GWS6L0+7cO60rqcBhtTna/MUqyOuU+5H2neWpMzJkf68N9n3Q+xROwxbZa5d2t9xdYY4VuYumCjA1OoGzYUOxkWChFEmHoH1tb5swmkJGJ9rc95XyUvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Guz4jmSs/1RD9y4gk31Uob+xHShOlWkuCSZ/mPFRfSY=;
 b=Ue4nRJwuKJCTRfuCqfCvZ+26jepvMu4vrxm6JWj26pwtUAWCAD/IcGQUph08Jn48RSIY/C8VssOsHaJxOlzkMATneIjkwqmbEVT4Xftw88pMweTR+uQH8bwlb4eKvxclmP5RJKKmEFo2j1Bkh/OaiazE2pXz4QJvd9XgWjJ+vaFML2e+Vryb3HUgVFwTevmhqKDsYGH8zu58o+N17pQKfNjR9DV5Ru+Te8Lpv06nnf7HfDcr7bD3mximPoYYLQbaeebXUBApzDAZGg11xea1szhKfFKduDRawlToR5fE8ihKaIu5NCtpDsiJZeM2RdoRz4lRBySdF5XVvjmTbsd1rQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Guz4jmSs/1RD9y4gk31Uob+xHShOlWkuCSZ/mPFRfSY=;
 b=YbjrMgnI85wA7ZriXiZL1QvSQHDSpIy20Yljg9I37bgAUYma2FQs7Qzf8b6LZNFgyDVQWTCVbSX4ndgt2cq2cKi9eUWtJG6jJVTNE/x+YSsSXLyVOdauasp+iJ2+UGNFXg8VFtbKhRW+Ck/sF+SA+H2r2eXEs84clNZVD+Iu9P4=
Received: from BN9PR03CA0394.namprd03.prod.outlook.com (2603:10b6:408:111::9)
 by DS0PR12MB6488.namprd12.prod.outlook.com (2603:10b6:8:c3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Wed, 19 Apr
 2023 17:05:27 +0000
Received: from BN8NAM11FT066.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:111:cafe::77) by BN9PR03CA0394.outlook.office365.com
 (2603:10b6:408:111::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.47 via Frontend
 Transport; Wed, 19 Apr 2023 17:05:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT066.mail.protection.outlook.com (10.13.177.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6319.23 via Frontend Transport; Wed, 19 Apr 2023 17:05:27 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 19 Apr
 2023 12:05:19 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <leon@kernel.org>, <jiri@resnulli.us>,
        <simon.horman@corigine.com>
Subject: [PATCH v11 net-next 08/14] pds_core: set up the VIF definitions and defaults
Date:   Wed, 19 Apr 2023 10:04:21 -0700
Message-ID: <20230419170427.1108-9-shannon.nelson@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN8NAM11FT066:EE_|DS0PR12MB6488:EE_
X-MS-Office365-Filtering-Correlation-Id: 4aaae408-d6c5-402b-9dff-08db40f845e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1XISG2h4x535KQX8hcyj7427VI6rCcHQtXd1e8PjaBTU01DYSJA47UGAjn/dHQXmps0K0Vyo55rU10njF+uQBkapUxBY3KVJ+NJkj2UPVoHkZxoadkJnJgsMO6o0MKyHr1KYb3iKc2W+7pQNJDZ/eu8ZnSUQRhPPgeXkMENGlvSBBzlUuOO44W3aFkkavPIKvOkVaUjSLqK4EkfBKEi6Y6IZvqHUdNDhKbnavfbGITp0iXAznBRqgm2Qw5DEjXprIQpNbAo2PyfUR5RkZ6mRylh3qji3YJain9y9sSNYKl9YJLCOIjRCatZAce2TEA8cesmG6WPonhHjtDg50f8mo4J5a3Us7kvH9U2OjFSlM4/bk5hX0Pn1vljF2TfeUPgBHefxWUwdGtcAonmmNv1gn66ojy9geb+BzanSxrrWSPF2Gc28ZW4yL/Mn0qxUbAJOYybBjCUQMS+EJ3E8y6dRZToVh9jax4wZjOC+IKkya4JBZFh2E7kEYg2ogYdLNMetYwBSRGYEV5fBv25F4sUXzpxDzEOuUXQjes9Ac21XqsMq5NfvrbMrYx8PAZJq+OTA3cqqp9Vd7A0bSHaXolMq7D2WfPVyV3w9QXPMWEqo/VcjJ1084u6SiEvjHwpVX64g2PRnT5YNfAzMNCC2Z89ohemvk5aEwSgGABcK80Sq9EOy3HvVyu/twg2m/WiN6cJRlKugmzl1tcnye2ATubm3/fFBC7/tMwYhZ5Z3Sw/GZZQXSfjSXPYZ1Z/YmFdYcurGAfvKEHyQ1nMti0wQz2u2cw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(39860400002)(376002)(346002)(451199021)(40470700004)(46966006)(36840700001)(86362001)(336012)(47076005)(1076003)(83380400001)(26005)(426003)(82310400005)(186003)(356005)(16526019)(40460700003)(2906002)(36756003)(44832011)(5660300002)(2616005)(36860700001)(6666004)(8676002)(8936002)(478600001)(54906003)(81166007)(110136005)(82740400003)(316002)(70206006)(40480700001)(70586007)(4326008)(41300700001)(36900700001)(309714004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2023 17:05:27.1069
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4aaae408-d6c5-402b-9dff-08db40f845e1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT066.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6488
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

