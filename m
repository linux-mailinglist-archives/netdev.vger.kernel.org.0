Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 660906C5468
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 19:59:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231332AbjCVS73 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 14:59:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230353AbjCVS6N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 14:58:13 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EBD21117B
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 11:57:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bTPUNVZfXw7JTQ9PJ3AogVQU5+xTL7P9sScUXiJz9kWW0FS+6vcTT0t/GXdw1vNpERfz/7RIQCcE/xVMhMEKTyO1OAFKDEfUA+K0y5vmYDa3gDZAypd8ypbvZja3VPFgZXiNx0a5GhaZm7y5ZW8UpejlnH/DRkI7pyVdmTOEcB+u2U9WeUJzwlavJE8MnIjpqduUmut1gv2q6gjdxHo8dJ4SC0w7JDkIkV5emUHo/XlDDERmDr26kVLv0p9aCTsUvuE9IUEZVg5ZO/LjA7K5R7pXy3srtO2iiB+0Xhcn0Ka+EQwOddYyuzU/ELorwB2FbLp0+zlklAevOsUYfK+lhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=op+yOeM9JRqveneNBezoKld/POXfC6C8UuGiwJ/3/vA=;
 b=OhXWsStd8SyLiPWdJ1aV+dascD2/HCAsguAHH0sdffmeQUtRCN3XW3uzvATJQjJ4JirpP32PKenmXqhzw8wH2vww5HINSxUYvbJElzbv1YzGZ/5Jd9S7BTrSiisgzyrw2AZrSi3Ue4PjlYxpiNrrHlCW5F7vumIE4xXIq8cPr74DoX3ZN2KEtgJmBo/ywAhophhUXXMC5PtEV47p8cXZB3ZDzIiIQlWD8Hf3c0MmyZ6mwO+aNA5YFV22APJbXatd7QJt+x6jAa2Lrbbu802gGo10OcE1B8B/k18DohSmE/8lcSwvLfV7ty9NKzqVr2uQvQiYhYxcH99yJL3aMbj8oQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=op+yOeM9JRqveneNBezoKld/POXfC6C8UuGiwJ/3/vA=;
 b=y2Ijjfqb51HpqtVbmDH0mmrROsxI2nqSowyZ6GXWZS/zV54j9Aj/RHW+LViQaSimofVEs0MA0mcrhe+7fXwHW63xyjPKV+m+tkijM3YpJsJYlgFTqYJlHGgtHT0sKh5f6zkmITKStZVAHLXpvqejUprBDnQeU13bSVdM569GsuI=
Received: from BN9PR03CA0985.namprd03.prod.outlook.com (2603:10b6:408:109::30)
 by PH8PR12MB7181.namprd12.prod.outlook.com (2603:10b6:510:22a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 18:56:54 +0000
Received: from BN8NAM11FT051.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:109:cafe::a6) by BN9PR03CA0985.outlook.office365.com
 (2603:10b6:408:109::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37 via Frontend
 Transport; Wed, 22 Mar 2023 18:56:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT051.mail.protection.outlook.com (10.13.177.66) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6222.17 via Frontend Transport; Wed, 22 Mar 2023 18:56:53 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 22 Mar
 2023 13:56:50 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <leon@kernel.org>, <jiri@resnulli.us>
Subject: [PATCH v5 net-next 08/14] pds_core: set up the VIF definitions and defaults
Date:   Wed, 22 Mar 2023 11:56:20 -0700
Message-ID: <20230322185626.38758-9-shannon.nelson@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN8NAM11FT051:EE_|PH8PR12MB7181:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c173c44-1459-4fd9-5043-08db2b0733e4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Bnlr0GywZMrZ+Y/AaKAavXqJnmFbHOMOZtaEzm9ec261XJ7n4lvuswccfpihlA9gqCV38/XChqhiandRTWOacF+3ORp07fl+8NWpjjzA9+gkoIbjVFuCqYjSjIL/tzwKaAZmgAN4ETmQ6tFjFS/5sgJWPMz45wobaxPeALpboVG5LfYx3Ku0Xxulb9z6ORpvsQjCxz2vEG57w3mBHgdfMYnv4NvlkeB+myr3zvQDv/LDCxMaGahBMXR0EehhAibgTCjhv0lUmPv4P2oDPLCP03UZTihi8xEh8CruYcLM52buZD+aNJNYZECe5OtP3z41ZakmcJxQZP5uyt0h2YoJgqQgLOY+skqXtmFYcXx/Uu2STG/ISZFdwEgasOlIc5FMMnWVlM/TswPJGtmMe92ClnaIwjs2czeofif2Qq5O/CpazDAhknq+sP8uC6b1TwbwDzIhJKy5TcNDZ79kdzfZ0URbZR9Dihu1t0tfHMhESOXHCfKev28hoKi2oaN1nPNUAPcf/+MEvS4Ty7KvsHZbq6iPZAxLJ8T/umz7p45nULrBYHRtG1JlCF2FTJI5gWPztZZygf/ZQ5zdRrD6KBZeroWnPnK6O6qMBqstCckY2LHM6Ue0uybS7HBp8guhz9HcO7VDTCcHmJjCVgJuUAugsZyN7upu1/rs69lCfmoDbhF2KE0NRxckfUH9M4s4s0CIRGiiLx6i7amWom7rJGE508OO1RppnkH5hMS7UXzX6T08sKDHF9sTweo/8DaxgDKUJ7W1ugK9ebXJuMtB3t2Y/Q==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(396003)(376002)(136003)(451199018)(36840700001)(40470700004)(46966006)(110136005)(316002)(478600001)(2906002)(83380400001)(54906003)(356005)(2616005)(426003)(86362001)(81166007)(82740400003)(36860700001)(82310400005)(47076005)(336012)(40460700003)(36756003)(40480700001)(6666004)(16526019)(4326008)(70206006)(70586007)(44832011)(8676002)(5660300002)(186003)(1076003)(41300700001)(26005)(8936002)(36900700001)(309714004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 18:56:53.6704
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c173c44-1459-4fd9-5043-08db2b0733e4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT051.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7181
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
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
 drivers/net/ethernet/amd/pds_core/core.c    | 47 +++++++++++++++++++++
 drivers/net/ethernet/amd/pds_core/core.h    | 13 ++++++
 drivers/net/ethernet/amd/pds_core/debugfs.c | 23 ++++++++++
 include/linux/pds/pds_common.h              | 19 +++++++++
 4 files changed, 102 insertions(+)

diff --git a/drivers/net/ethernet/amd/pds_core/core.c b/drivers/net/ethernet/amd/pds_core/core.c
index e770547ea84a..0e3be77d77bc 100644
--- a/drivers/net/ethernet/amd/pds_core/core.c
+++ b/drivers/net/ethernet/amd/pds_core/core.c
@@ -350,6 +350,42 @@ static int pdsc_core_init(struct pdsc *pdsc)
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
+	pdsc->viftype_status = kzalloc(sizeof(pdsc_viftype_defaults), GFP_KERNEL);
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
@@ -392,6 +428,14 @@ int pdsc_setup(struct pdsc *pdsc, bool init)
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
 
@@ -408,6 +452,9 @@ void pdsc_teardown(struct pdsc *pdsc, bool removing)
 	pdsc_qcq_free(pdsc, &pdsc->notifyqcq);
 	pdsc_qcq_free(pdsc, &pdsc->adminqcq);
 
+	kfree(pdsc->viftype_status);
+	pdsc->viftype_status = NULL;
+
 	if (pdsc->intr_info) {
 		for (i = 0; i < pdsc->nintrs; i++)
 			pdsc_intr_free(pdsc, i);
diff --git a/drivers/net/ethernet/amd/pds_core/core.h b/drivers/net/ethernet/amd/pds_core/core.h
index 19216d0cf4b7..4704194e9bc8 100644
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
 	PDSC_S_FW_DEAD,		    /* fw stopped, waiting for startup or recovery */
@@ -174,6 +183,7 @@ struct pdsc {
 	struct pdsc_qcq adminqcq;
 	struct pdsc_qcq notifyqcq;
 	u64 last_eid;
+	struct pdsc_viftype *viftype_status;
 };
 
 /** enum pds_core_dbell_bits - bitwise composition of dbell values.
@@ -228,6 +238,7 @@ struct pdsc *pdsc_dl_alloc(struct device *dev, bool is_pf);
 void pdsc_dl_free(struct pdsc *pdsc);
 int pdsc_dl_register(struct pdsc *pdsc);
 void pdsc_dl_unregister(struct pdsc *pdsc);
+int pdsc_dl_vif_add(struct pdsc *pdsc, enum pds_core_vif_types vt, const char *name);
 
 #ifdef CONFIG_DEBUG_FS
 void pdsc_debugfs_create(void);
@@ -235,6 +246,7 @@ void pdsc_debugfs_destroy(void);
 void pdsc_debugfs_add_dev(struct pdsc *pdsc);
 void pdsc_debugfs_del_dev(struct pdsc *pdsc);
 void pdsc_debugfs_add_ident(struct pdsc *pdsc);
+void pdsc_debugfs_add_viftype(struct pdsc *pdsc);
 void pdsc_debugfs_add_irqs(struct pdsc *pdsc);
 void pdsc_debugfs_add_qcq(struct pdsc *pdsc, struct pdsc_qcq *qcq);
 void pdsc_debugfs_del_qcq(struct pdsc_qcq *qcq);
@@ -244,6 +256,7 @@ static inline void pdsc_debugfs_destroy(void) { }
 static inline void pdsc_debugfs_add_dev(struct pdsc *pdsc) { }
 static inline void pdsc_debugfs_del_dev(struct pdsc *pdsc) { }
 static inline void pdsc_debugfs_add_ident(struct pdsc *pdsc) { }
+static inline void pdsc_debugfs_add_viftype(struct pdsc *pdsc) { }
 static inline void pdsc_debugfs_add_irqs(struct pdsc *pdsc) { }
 static inline void pdsc_debugfs_add_qcq(struct pdsc *pdsc, struct pdsc_qcq *qcq) { }
 static inline void pdsc_debugfs_del_qcq(struct pdsc_qcq *qcq) { }
diff --git a/drivers/net/ethernet/amd/pds_core/debugfs.c b/drivers/net/ethernet/amd/pds_core/debugfs.c
index 65d3bbd32892..11869cf92600 100644
--- a/drivers/net/ethernet/amd/pds_core/debugfs.c
+++ b/drivers/net/ethernet/amd/pds_core/debugfs.c
@@ -76,6 +76,29 @@ void pdsc_debugfs_add_ident(struct pdsc *pdsc)
 	debugfs_create_file("identity", 0400, pdsc->dentry, pdsc, &identity_fops);
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
+	debugfs_create_file("viftypes", 0400, pdsc->dentry, pdsc, &viftype_fops);
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

