Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E36676D1396
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 01:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231722AbjC3Xro (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 19:47:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231716AbjC3XrV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 19:47:21 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2060b.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e88::60b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B822CEB51
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 16:46:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LnwfOhKmJoyhyLcSqyUIs2kZmohBhV30Z7sTXjWwDf0w1ucOqup/YmFxSH+2hDiLSqDrUMJ+0rb3BAa3VI/b371KhIkTiMsxE0USeKireNKqdNHk3Vq4FUlnM28dAGVbbZ0MsqwVMVT5Mv7q7pZ0a+CfTfsTPXo3mD8sBFSJUk7/2URSq9+jLteNb5GdnkrUr+zkJgViHtP/ugaowwWg9tdJT9OjRAkAKZQBE2ZF0V3F7Lrx9joT6+B666WJJYAWMvEis1YZ+LlAGF2hTV6dfdVDBR4ACQl1RaTajjQ074FN5V9VdQZUeeCt0/5WexmcIee7EnSup3JzggTGK1DmmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=34081/fuOtgnZqSj22GARtXu9JVcBIdGORU9V/xFns0=;
 b=lACPFMlalcnm4Kk8a3tJHbnBMI/knFe4rBlAVoWuyEOPGiVTTmDXlikekaK6Ge9Rya+gSxWdZquYVNiOtZJ0mIwTNSB+Cs9oCmuszg79afW/gtib5qCEFljShTW2+8znFR81D7v5guXsPOftFfmeieLIANvOjE1wIS1bIXytbDRisDejF1A4O17nekjpuqnXLYtZMHc9pyv2rcOwNpDbNTL6Zred0ZCztwUssX962dRWvVH7W4sHWR+SyzKbaW66yMyU17Sa18LhBNfN904D8Oc8jSPrJQZ8dUsktf+5Xr/wrelV3NuuMHuQPiRrhWybVWqaBcp/kpcLFBBAMj95oQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=34081/fuOtgnZqSj22GARtXu9JVcBIdGORU9V/xFns0=;
 b=XBFeRBkNZqGxWYqGHBprhtkZj6SSJgtHRB8qHbRQgxi2BoJovhysphGQLsiiYEe1uGLSTz/lYwV9OAMcsko4GLGxML3heDKCzS428mIyZR4PDAyoMu97uC/5Xecj9z0FNZLQkkOInXa8jxCoBWMESfybAAXXbSCJEJRY+T+bFzo=
Received: from MN2PR15CA0018.namprd15.prod.outlook.com (2603:10b6:208:1b4::31)
 by PH0PR12MB5466.namprd12.prod.outlook.com (2603:10b6:510:d7::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Thu, 30 Mar
 2023 23:46:54 +0000
Received: from BL02EPF000100D2.namprd05.prod.outlook.com
 (2603:10b6:208:1b4:cafe::76) by MN2PR15CA0018.outlook.office365.com
 (2603:10b6:208:1b4::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.22 via Frontend
 Transport; Thu, 30 Mar 2023 23:46:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF000100D2.mail.protection.outlook.com (10.167.241.206) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6178.30 via Frontend Transport; Thu, 30 Mar 2023 23:46:53 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 30 Mar
 2023 18:46:52 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <leon@kernel.org>, <jiri@resnulli.us>
Subject: [PATCH v8 net-next 09/14] pds_core: add initial VF device handling
Date:   Thu, 30 Mar 2023 16:46:23 -0700
Message-ID: <20230330234628.14627-10-shannon.nelson@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF000100D2:EE_|PH0PR12MB5466:EE_
X-MS-Office365-Filtering-Correlation-Id: f62c56ad-cf78-460d-194a-08db31790a78
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qineDILBbk9iLfKsygmQXVgR/krAJfiLZ1E3Ieel6pPD37ioThjp48WaoJqUGx+oy7+cL+FL+ui3hUC5pKPEeQXhm633kqHnHowcKcV5ZMlz2PzqSEUG7rrXn5l7iYzJp4wHJx8cJLmJ6skKqE3RC+U6DhPNMMBHXVLO1xRAhpFv2H/+vDbiiVNZZo0HrtsyfmdvppUgyDHpaNO+xhEGV86BGkQnpTVT92JhCWpm1PZnEyoysP3cFUcmgVD6QIDt1sgQnHVrSdAKAYlhuUSP9AywSq//U4CqXfoJNX8g6xqfpa23/zfz3gksqDpvAPkk/+OTq41jW/l81hFVMc5tsfg//h6zZEN9FpE4OCy9Me0zV+80uN8kKwA7z9nxV7Cn+8OLlEiPdeiwWQF3hDypUfDkO2sScfZYAwpA5x74RMoJv8BkdiXLW+AxJCC9rY+2itd7jlOu37EgkqSRhwdBs6Qp38qq6TjkReCbl81ucvncp2UR228UZKsUwsGb/Vbn6U3SRWiqJ+rFVPmjRe0Y6xV41JsEnTE4GNBd9++CfF1/deo3Oylt+zjbaTrWlv9QFd9qyubAnOtubLeEp7sOlBu1eAdZT8fUiwCr4uLlVUtdIFmv8LjNJwD+VIBZ88aVT8FQ3wDBxeijl75OlqHbf2L6JujerBNyZwsjfzquf3BUMde5gSldJxwMEHu1rxjt2pqxzx+j2yus34r0EmMjXN8ENHQ1ABJ4ufe/BJQI0/M=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(39860400002)(396003)(376002)(451199021)(40470700004)(46966006)(36840700001)(336012)(83380400001)(47076005)(36756003)(2616005)(16526019)(186003)(426003)(1076003)(82310400005)(6666004)(86362001)(316002)(478600001)(54906003)(110136005)(36860700001)(26005)(41300700001)(4326008)(40460700003)(82740400003)(356005)(70586007)(8676002)(40480700001)(70206006)(81166007)(44832011)(8936002)(2906002)(5660300002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 23:46:53.9191
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f62c56ad-cf78-460d-194a-08db31790a78
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF000100D2.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5466
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
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
---
 drivers/net/ethernet/amd/pds_core/core.h |  9 +++++
 drivers/net/ethernet/amd/pds_core/main.c | 48 +++++++++++++++++++++++-
 2 files changed, 56 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amd/pds_core/core.h b/drivers/net/ethernet/amd/pds_core/core.h
index 7737783a66e7..bfe0274942d1 100644
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
 	int id;
 
diff --git a/drivers/net/ethernet/amd/pds_core/main.c b/drivers/net/ethernet/amd/pds_core/main.c
index 4194940e4000..313057a57deb 100644
--- a/drivers/net/ethernet/amd/pds_core/main.c
+++ b/drivers/net/ethernet/amd/pds_core/main.c
@@ -23,6 +23,7 @@ MODULE_LICENSE("GPL");
 /* Supported devices */
 static const struct pci_device_id pdsc_id_table[] = {
 	{ PCI_VDEVICE(PENSANDO, PCI_DEVICE_ID_PENSANDO_CORE_PF) },
+	{ PCI_VDEVICE(PENSANDO, PCI_DEVICE_ID_PENSANDO_VDPA_VF) },
 	{ 0, }	/* end of table */
 };
 MODULE_DEVICE_TABLE(pci, pdsc_id_table);
@@ -164,9 +165,51 @@ void __iomem *pdsc_map_dbpage(struct pdsc *pdsc, int page_num)
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
@@ -358,6 +401,8 @@ static void pdsc_remove(struct pci_dev *pdev)
 	devl_unlock(dl);
 
 	if (!pdev->is_virtfn) {
+		pdsc_sriov_configure(pdev, 0);
+
 		del_timer_sync(&pdsc->wdtimer);
 		if (pdsc->wq) {
 			flush_workqueue(pdsc->wq);
@@ -392,6 +437,7 @@ static struct pci_driver pdsc_driver = {
 	.id_table = pdsc_id_table,
 	.probe = pdsc_probe,
 	.remove = pdsc_remove,
+	.sriov_configure = pdsc_sriov_configure,
 };
 
 static int __init pdsc_init_module(void)
-- 
2.17.1

