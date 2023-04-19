Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE1F6E8016
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 19:05:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233574AbjDSRFn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 13:05:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233478AbjDSRFc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 13:05:32 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2081.outbound.protection.outlook.com [40.107.237.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC47F7EC3
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 10:05:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GfuI0/FC8ngXCfa9/RbmqwAd/kGdmtV4bnJad0VWhmOX+8fQGrLjiw8jD35cxblLh0CzNXc1YejpvMPLTGvl0lG0QirmCdU73gPNNaWrex7dchKJ0bBL8kQSKjO6pr6/3gFF5bhrLC2NMGwHg5bd0lL2aD9WLmyJSnBzNFOkaE1AjTyms9dZlv82vN3BsU2Hm1mKxQYt228EnvhXmmFAbqi82dgLvaC7ucYKM6XWNlvYFPIE8bMBPHndsbMRGQYJ5UJ+jtX6xwOkOcWuymjavNoxy+vegMv+o3SOUyZfBcwbo/LLBARWxIDBPl2Mti7GAVFs9sCoTTO+9jVY11uR3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H25JUGQ5MyDYsbse+Oz/+N9KLrneT07Gw2nCwgxXh/o=;
 b=jy+O9LMhk353bJzePLeV/wu+q3kbiJHGcuUxeHM1eTnuVh46lw8l8hGN5+kxzLkYwLhEhW/oCzhE1xYofPhD+Tvtn5PIuYcBEFs7pfQjyP4XLmPa0OsHlXHvT8CT0oNspkyQHaW0VaMDgwdHcC3G4LxCasgx4kazafZB2/cq4Q5bJVYMQn1iPs7DKmQqvrb+A+iVW/iRU3WtdnQFDbub2J738vXvKGu6XKqjrtDGCVmAXYhiQgY9pvI0dYeQ048alDDhqMjIklTp26ih6jIHaruEZeH2on2r3EuurgFPQ/G5YREJYHUDdigSwAQWPRIJirHVHcb79q3pbWZBGOdeKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H25JUGQ5MyDYsbse+Oz/+N9KLrneT07Gw2nCwgxXh/o=;
 b=PlvoKObFxrrby6LOkvCfSgTUVgQNqyjYQ0HvD7/PErtB5OqtfD37R7Wp4vtzMpA5kY4t/tEdCCGsyWKDUEHBlZ9+QY+YDrY0igprtj+yOgznSk9NP/8HtkR91aAIgio4r0ibREiJvEDzXpco5gaxr8yrV4KPSDgHFvFTts4v4e0=
Received: from MW2PR16CA0032.namprd16.prod.outlook.com (2603:10b6:907::45) by
 PH8PR12MB6675.namprd12.prod.outlook.com (2603:10b6:510:1c2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Wed, 19 Apr
 2023 17:05:28 +0000
Received: from CO1NAM11FT071.eop-nam11.prod.protection.outlook.com
 (2603:10b6:907:0:cafe::49) by MW2PR16CA0032.outlook.office365.com
 (2603:10b6:907::45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22 via Frontend
 Transport; Wed, 19 Apr 2023 17:05:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT071.mail.protection.outlook.com (10.13.175.56) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6319.23 via Frontend Transport; Wed, 19 Apr 2023 17:05:27 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 19 Apr
 2023 12:05:20 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <leon@kernel.org>, <jiri@resnulli.us>,
        <simon.horman@corigine.com>
Subject: [PATCH v11 net-next 09/14] pds_core: add initial VF device handling
Date:   Wed, 19 Apr 2023 10:04:22 -0700
Message-ID: <20230419170427.1108-10-shannon.nelson@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1NAM11FT071:EE_|PH8PR12MB6675:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a5bd957-19e2-408e-c926-08db40f84677
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m8bvnFvvWbgt2W/LUxQZg5N4lPxAq51Q+cnVCsKcNul8P2fpw0fi3onSLnIGCIGG8vJR84CMvX4vZ+J6HF/YAalxa/LcQGFDpuSBizepwAy6Sa4XNbDEPyVEc7yRX0kiBktyCjtg5QgNrn0WiPQJHZUPsPi1RkRK/67SbRQQ2kRlb5Ja2y1k77akOhDCWCgs1w0AmEOnAMAyWZuf8wq0t4O10rSg0J6tUmTX6gE7fbYSewww7dCNlC8QP35HW5Ytfog4q4B98A6alo+sNh6W2AHy8zz4saJYse/k3hl3lWCPZWcvm1qnxDp0QpfgE3uTkmWR4fIl55lj8uGqsG2c8UcMgZk9q3KP2XuZXJQ2IproSirYptNRWVjrYOmubwLsxcYIl2uswMHN3tW7ZX8OZQUE8xcvdT+pG9CQDEit8gC1l61UmeHtTtqkPYoMaySgsw27kq9cNAybQ1DYZ0+Sc3l2pElf7TQRV/VeQ/ZZDhxZ6tmA3YmNB0EYkXyEKUerEjRLQuO5rCAMJ8UajHRN40AbULf6Cp10AUz/KlF0qNzYRCEKghJHAMPUYhdwGqaJEYK2iwgxG3VRbTFMazz5VsU7aGRFpLUaEQTLYEEH3ngyvO4JMX2tXhHtr0Yaw+TsGB/SzbMm5wGJ/tfI+N/9yz/YFZOcgGXgmSWzJKzPrj19O50U13PZKU6G+taeQY0eMd6u/dPqlAypvXaothYZtmXOz46FcXqJoQLHvJmqnf4=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(39860400002)(346002)(396003)(376002)(451199021)(36840700001)(46966006)(40470700004)(26005)(86362001)(1076003)(2906002)(186003)(16526019)(70586007)(4326008)(8676002)(70206006)(478600001)(81166007)(2616005)(36756003)(36860700001)(82740400003)(356005)(83380400001)(426003)(47076005)(336012)(44832011)(5660300002)(40460700003)(8936002)(82310400005)(110136005)(316002)(41300700001)(40480700001)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2023 17:05:27.9817
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a5bd957-19e2-408e-c926-08db40f84677
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT071.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6675
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

This is the initial VF PCI driver framework for the new
pds_vdpa VF device, which will work in conjunction with an
auxiliary_bus client of the pds_core driver.  This does the
very basics of registering for the new VF device, setting
up debugfs entries, and registering with devlink.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Acked-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/amd/pds_core/core.h |  9 +++++
 drivers/net/ethernet/amd/pds_core/main.c | 48 +++++++++++++++++++++++-
 2 files changed, 56 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amd/pds_core/core.h b/drivers/net/ethernet/amd/pds_core/core.h
index ac0480d7f0f1..1ec8784773f1 100644
--- a/drivers/net/ethernet/amd/pds_core/core.h
+++ b/drivers/net/ethernet/amd/pds_core/core.h
@@ -30,6 +30,12 @@ struct pdsc_dev_bar {
 	int res_index;
 };
 
+struct pdsc_vf {
+	struct pds_auxiliary_dev *padev;
+	u16     index;
+	__le16  vif_types[PDS_DEV_TYPE_MAX];
+};
+
 struct pdsc_devinfo {
 	u8 asic_type;
 	u8 asic_rev;
@@ -147,6 +153,9 @@ struct pdsc {
 	struct dentry *dentry;
 	struct device *dev;
 	struct pdsc_dev_bar bars[PDS_CORE_BARS_MAX];
+	struct pdsc_vf *vfs;
+	int num_vfs;
+	int vf_id;
 	int hw_index;
 	int uid;
 
diff --git a/drivers/net/ethernet/amd/pds_core/main.c b/drivers/net/ethernet/amd/pds_core/main.c
index 54aaf213679f..511cb91a295e 100644
--- a/drivers/net/ethernet/amd/pds_core/main.c
+++ b/drivers/net/ethernet/amd/pds_core/main.c
@@ -16,6 +16,7 @@ MODULE_LICENSE("GPL");
 /* Supported devices */
 static const struct pci_device_id pdsc_id_table[] = {
 	{ PCI_VDEVICE(PENSANDO, PCI_DEVICE_ID_PENSANDO_CORE_PF) },
+	{ PCI_VDEVICE(PENSANDO, PCI_DEVICE_ID_PENSANDO_VDPA_VF) },
 	{ 0, }	/* end of table */
 };
 MODULE_DEVICE_TABLE(pci, pdsc_id_table);
@@ -132,9 +133,51 @@ void __iomem *pdsc_map_dbpage(struct pdsc *pdsc, int page_num)
 			       (u64)page_num << PAGE_SHIFT, PAGE_SIZE);
 }
 
+static int pdsc_sriov_configure(struct pci_dev *pdev, int num_vfs)
+{
+	struct pdsc *pdsc = pci_get_drvdata(pdev);
+	struct device *dev = pdsc->dev;
+	int ret = 0;
+
+	if (num_vfs > 0) {
+		pdsc->vfs = kcalloc(num_vfs, sizeof(struct pdsc_vf),
+				    GFP_KERNEL);
+		if (!pdsc->vfs)
+			return -ENOMEM;
+		pdsc->num_vfs = num_vfs;
+
+		ret = pci_enable_sriov(pdev, num_vfs);
+		if (ret) {
+			dev_err(dev, "Cannot enable SRIOV: %pe\n",
+				ERR_PTR(ret));
+			goto no_vfs;
+		}
+
+		return num_vfs;
+	}
+
+no_vfs:
+	pci_disable_sriov(pdev);
+
+	kfree(pdsc->vfs);
+	pdsc->vfs = NULL;
+	pdsc->num_vfs = 0;
+
+	return ret;
+}
+
 static int pdsc_init_vf(struct pdsc *vf)
 {
-	return -1;
+	struct devlink *dl;
+
+	vf->vf_id = pci_iov_vf_id(vf->pdev);
+
+	dl = priv_to_devlink(vf);
+	devl_lock(dl);
+	devl_register(dl);
+	devl_unlock(dl);
+
+	return 0;
 }
 
 static const struct devlink_health_reporter_ops pdsc_fw_reporter_ops = {
@@ -323,6 +366,8 @@ static void pdsc_remove(struct pci_dev *pdev)
 	devl_unlock(dl);
 
 	if (!pdev->is_virtfn) {
+		pdsc_sriov_configure(pdev, 0);
+
 		del_timer_sync(&pdsc->wdtimer);
 		if (pdsc->wq)
 			destroy_workqueue(pdsc->wq);
@@ -354,6 +399,7 @@ static struct pci_driver pdsc_driver = {
 	.id_table = pdsc_id_table,
 	.probe = pdsc_probe,
 	.remove = pdsc_remove,
+	.sriov_configure = pdsc_sriov_configure,
 };
 
 static int __init pdsc_init_module(void)
-- 
2.17.1

