Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 977776E55E6
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 02:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230282AbjDRAdb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 20:33:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbjDRAdI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 20:33:08 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2058.outbound.protection.outlook.com [40.107.223.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B00949DA
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 17:33:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PRW7TU/Y5R4KY4qAdQMuox+2KIaOBMnWzzyRo1IHvyUO9xoTyfLLWkV0UORXzdAt5MldRZVi+4I0tLWBK/NMaywpwkciXOykPkOs+UfwZgKqtlXuaHneB1E6rUmIvFvvXoiOU4G/WHEh3PboRn4ogCtqVICr8QD8YCVUicSJTdo+u/6zIgP00TZc2sTSwACu9jSM7KeTqPWhjNrnCWh4veOrV+oYYhqBwcovBmCv1zp6FOvNtG+XTZgiiMegkZr0qveHkVQ3HufrQCe+VoQFG/MlXWYVZgKVFG3bhEXNUPI7BRear6OwwRsLmLC1MZLizEQ/phSi2SsOtvqFo0YVaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H25JUGQ5MyDYsbse+Oz/+N9KLrneT07Gw2nCwgxXh/o=;
 b=UHpf++/8unqe5eo7J7ki6yQXDzsioUgdB8BhzhH7GxgpJwJQm+sd0wAaqx6rmaBC8uCn1vI/vlOw0bhR8tQ6FpFkPd05OJQ7RferfGPLD5+Mg/aMZuhVmTKvioCyYcXFSyc98mcZEX0J6atJ2Sed1RI0wF/4bOqY37MQIIlLQ43UeUhKHR3PmP6F238MEpliCT2MrofYvdAvNboHXOhL3ZXGzBbrpn3DKkD1lSiJeo6LiClT3q61fztcI+y5XbXR9FXGd8xkzVsu3hFB91z5iOUMuOr3+w+bd6eeIPJaUhNoR8/ymjI7UcGGJhS/V1uK/C14KwteofvRcQ4l7ahsOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H25JUGQ5MyDYsbse+Oz/+N9KLrneT07Gw2nCwgxXh/o=;
 b=zoswTNFz7vAMKerUPp4eZsrvW/P7XlCt+iCOSg8zAoTsDjRC4OQ9j8K+hBlPfFK8rOap12kvQ0h6WFzHV2kxVRUfdr0t5YEKc17Wnuien246bSjz5ernU6sqYwuW/EL/p7UcV8RnT2bMUFKV6rKq8y3y4KiKsih0VbCazqoM4UM=
Received: from BN0PR02CA0032.namprd02.prod.outlook.com (2603:10b6:408:e5::7)
 by SA3PR12MB8440.namprd12.prod.outlook.com (2603:10b6:806:2f8::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Tue, 18 Apr
 2023 00:33:03 +0000
Received: from BN8NAM11FT091.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e5:cafe::20) by BN0PR02CA0032.outlook.office365.com
 (2603:10b6:408:e5::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.47 via Frontend
 Transport; Tue, 18 Apr 2023 00:33:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT091.mail.protection.outlook.com (10.13.176.134) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6319.20 via Frontend Transport; Tue, 18 Apr 2023 00:33:02 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 17 Apr
 2023 19:33:01 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <leon@kernel.org>, <jiri@resnulli.us>,
        <simon.horman@corigine.com>
Subject: [PATCH v10 net-next 09/14] pds_core: add initial VF device handling
Date:   Mon, 17 Apr 2023 17:32:23 -0700
Message-ID: <20230418003228.28234-10-shannon.nelson@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN8NAM11FT091:EE_|SA3PR12MB8440:EE_
X-MS-Office365-Filtering-Correlation-Id: bff2176e-601c-4499-87b6-08db3fa47851
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: elG6sUJTJZLwCW+RZaYXiNvIMIqRFLBUqZIi2ryxLB1WcT60IOKocQ1Xa1wJyP0/krsQVOdW0b7Mg6BWm+xXQ2Da3H/73TZfZrv5UBdbzTk27VjI4a4w3vNYO1ddbB6tjYJRpI1Io/xCH7N5w9iFpl+hVEMDL4P5lBBg9uSk+nTREfziCJioedftFPJkpNpzd2vjHHsEqH0gSCgRHspCUG/t7fmOrHpRwI8jCrhQ9lis/jCYSF3yLShHPwYIjRxqpCUIwN2pGuMRZSllUCktL5Xku6iidm6WdZ5UYrMnHGeD4CxqhVBooBX/eRycAPVIRtbY/4dByYzGsB7HF26Y6YYm3nD+fuwdbysGsqo0/r54MXvArdFKB2ALq8iq91JUnifaoDocHIimSCEmmRXWlPZPhw6JkbGjLlfB8offOrDJK14VV9D+//TWxpBqmcVl2Ar8f/8risqJHvQDCdFhXXDCH7M8Qo3Oj5/NJnAqWeLDFEd/beBeaGwvhxEiJv4Fcm2CzUAsUrR5sxGxUHZLxICy6uBaq40OqjTPzR9wu/8ZkEXn5RzHgODoQCcLicIyU69WaeoSpJTcjeJM6m8zaD0NfLW2ep1zG69pApfjspjL2kzNOpeOMVf5p6Kf+wfRfeqtlQEbAJAQX/pqWNIJWpBQZOFTl1tZFDAYVbMGbHJgiL3D55rY0PYjDilVuiW2vozofvpshKqngKss16pbmixcsYNOsNrcXe8+Ota4ASI=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(346002)(376002)(39860400002)(451199021)(36840700001)(46966006)(40470700004)(5660300002)(40460700003)(2906002)(70586007)(4326008)(36756003)(70206006)(44832011)(86362001)(8936002)(81166007)(41300700001)(82310400005)(6666004)(478600001)(316002)(356005)(8676002)(82740400003)(40480700001)(54906003)(110136005)(26005)(1076003)(336012)(426003)(36860700001)(2616005)(16526019)(47076005)(186003)(83380400001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2023 00:33:02.8383
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bff2176e-601c-4499-87b6-08db3fa47851
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT091.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8440
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

