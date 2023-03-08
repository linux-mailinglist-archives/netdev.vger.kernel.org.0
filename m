Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CC626AFE22
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 06:13:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbjCHFN4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 00:13:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbjCHFNo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 00:13:44 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2040.outbound.protection.outlook.com [40.107.95.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84ACB87369
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 21:13:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Au9WyqjSzScyu7uNtpkz6OC2JrcCiIe0rZs3LC0nm8JltsKNbdFdu56YkjMQrEHaJo5Ka/ozKhjjbZMelq+sKsjvCyqwYY0aLI8dWhXIbzlbQqNdE4jSFjqAtLV3ydvyo6JFivsxJNpiwc8l7kLr6Cy7SH8/ENY4KKC14I5bMtWLJGbQt4ZQJqCft2FAgu/j/75bEd3gszbR6yZ+MgmonFuq7tyKq0mZlXEHNq6LJ7XSEQUGHb41QdpfjHbTiRzOzwSj/X/TQ45L9K+xn1vPHuuosSdpYy2t3s5D0Rv2nDECbSBF9+mcnp3iF2iy6LP+sRKTtTVhtxV72ls6njNTmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lwFnWmNVCxL7zSvsLoAoJGygDCqPQyqnmHBgzU1QPIQ=;
 b=hbnloQt5We1EfAy8weZkGGhg25+wB6ByXsmG6F6KFZ2DHptWF3OHBt1KMLts9th9hvWSW0nuKO/X+udVT/dPnYzF0hP6SdXGdda7EYaeCzICDJ1p9gOYt4AwCq5HZvndKeB9vdFY+6axKTzeD7tSlypEY7VHOUiCyZXRrPbPUjzNUR36X2UKnxVQcvyf7DCulndHOGSgmZazvOGSqjBXXFpuv6QWkqakSmf+Q3qAzuqGBRPme4BvhLATB3dgz3VB4mpw3ny26uOJp8D77Z0m+/DVT3djvYBqUace1RMwZzJk8oajuJ0hupFrFhBMplTnD2fxrzWd95Yd03l14H4uIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lwFnWmNVCxL7zSvsLoAoJGygDCqPQyqnmHBgzU1QPIQ=;
 b=UcYvjz7XaZplQ1ZtLZxv7CA8R+m24CoSyZ1yZoyisZEnr39mYUAGIXQ2jJuyJoWc+7e7KVWL+qV+A/Mt9Tb73vbDu1FijYKDtFQe6I2OvvekIwaW1Z+f0ghvtPla/kFDZvFXyjN9/eaxUTV8f3nM5KjQsRUjycwZPniOrCirsCI=
Received: from BN9PR03CA0400.namprd03.prod.outlook.com (2603:10b6:408:111::15)
 by IA1PR12MB7493.namprd12.prod.outlook.com (2603:10b6:208:41b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Wed, 8 Mar
 2023 05:13:41 +0000
Received: from BN8NAM11FT110.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:111:cafe::1) by BN9PR03CA0400.outlook.office365.com
 (2603:10b6:408:111::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.17 via Frontend
 Transport; Wed, 8 Mar 2023 05:13:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT110.mail.protection.outlook.com (10.13.176.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6178.17 via Frontend Transport; Wed, 8 Mar 2023 05:13:40 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 7 Mar
 2023 23:13:39 -0600
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <leon@kernel.org>, <jiri@resnulli.us>
Subject: [PATCH RFC v4 net-next 08/13] pds_core: add initial VF device handling
Date:   Tue, 7 Mar 2023 21:13:05 -0800
Message-ID: <20230308051310.12544-9-shannon.nelson@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN8NAM11FT110:EE_|IA1PR12MB7493:EE_
X-MS-Office365-Filtering-Correlation-Id: e58371b6-51ea-4ea2-ab50-08db1f93e1a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +PihCcUXtrIpBMB+de6LCQWRK4naP5Y/0Q4CZJ6b3QDmZEHtwWN3l8e76Qe+by0PrVMKrSrB78+JwnCLugWitPmN+qaH1q/fvpV/IgWP/zHEL2XqvH9MiB3G/Fkk4osDmPWGeBgyXMV33MMK48EPaNwmyP/QECAkSUxIFhZZg+Awke2qW1qIkTBLpespH09shgARBq89BaEpFbBxf8YfHFTFme/dS1Q0WqJtIzqFs6bF5nVtB2WsTZXAV2/zcKu4YMnH6rc91YD02G6inRNIHo/i/4Zv/kj0AFL+jPvarNJ1+WKET+GcQwYwUpIn+ma6dS1xgEqiRZiamnSG/3Z98lOZAlSV6c16B3xibEUjBdKIZtB3lJGwiCvuGUHPVMqQI5rCsLrKc8l0FSAZ2CU3w0rmy6HF6DxMwB01CymCI70bB7ShbF4fD1AOPLN4ydgxaxMQ+4VYiSSNOwkYouMvJBFnCdG88gXN1THU6NkMD8nEpbGGARtGSWRfkyMrxHM0gNCd6NDvfVaeSIK4OljSPHqJKv4rnfzD/5b1mcEmngaElArf9E3f3E1QeZDJeSlpjtjFY8lMHGpswge1+ZeREn9mo1pw9xKmlYcHk2TakiGipLieuypyrB9LJk3Jc6f0eGHxD/O3hSoz72zYfwhTChlzf2u9qKvqOkxccd1Cvp1GUoCIDOHaq0yvWVv4VoUgopZsNaG8FnMoL1ktPuv0o0GGE6kvNzxzS/jFQE/veAk=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(39860400002)(396003)(136003)(451199018)(36840700001)(46966006)(40470700004)(36756003)(40460700003)(356005)(40480700001)(54906003)(316002)(110136005)(2906002)(478600001)(5660300002)(8936002)(70586007)(44832011)(70206006)(8676002)(4326008)(41300700001)(6666004)(82740400003)(36860700001)(186003)(81166007)(86362001)(2616005)(26005)(16526019)(83380400001)(82310400005)(1076003)(47076005)(336012)(426003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2023 05:13:40.8645
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e58371b6-51ea-4ea2-ab50-08db1f93e1a0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT110.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7493
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the initial VF PCI driver framework for the new
pds_vdpa VF device, which will work in conjunction with an
auxiliary_bus client of the pds_core driver.  This does the
very basics of registering for the new PCI device 1dd8:100b,
setting up debugfs entries, and registering with devlink.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/net/ethernet/amd/pds_core/main.c | 45 +++++++++++++++++++++++-
 include/linux/pds/pds_core.h             | 10 +++++-
 include/linux/pds/pds_core_if.h          |  1 +
 3 files changed, 54 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/amd/pds_core/main.c b/drivers/net/ethernet/amd/pds_core/main.c
index 3cc8f693313a..db260fe149ff 100644
--- a/drivers/net/ethernet/amd/pds_core/main.c
+++ b/drivers/net/ethernet/amd/pds_core/main.c
@@ -21,6 +21,7 @@ MODULE_LICENSE("GPL");
 /* Supported devices */
 static const struct pci_device_id pdsc_id_table[] = {
 	{ PCI_VDEVICE(PENSANDO, PCI_DEVICE_ID_PENSANDO_CORE_PF) },
+	{ PCI_VDEVICE(PENSANDO, PCI_DEVICE_ID_PENSANDO_VDPA_VF) },
 	{ 0, }	/* end of table */
 };
 MODULE_DEVICE_TABLE(pci, pdsc_id_table);
@@ -162,9 +163,48 @@ void __iomem *pdsc_map_dbpage(struct pdsc *pdsc, int page_num)
 			       (u64)page_num << PAGE_SHIFT, PAGE_SIZE);
 }
 
+static int pdsc_sriov_configure(struct pci_dev *pdev, int num_vfs)
+{
+	struct pdsc *pdsc = pci_get_drvdata(pdev);
+	struct device *dev = pdsc->dev;
+	int ret = 0;
+
+	if (num_vfs > 0) {
+		pdsc->vfs = kcalloc(num_vfs, sizeof(struct pdsc_vf), GFP_KERNEL);
+		if (!pdsc->vfs)
+			return -ENOMEM;
+		pdsc->num_vfs = num_vfs;
+
+		ret = pci_enable_sriov(pdev, num_vfs);
+		if (ret) {
+			dev_err(dev, "Cannot enable SRIOV: %pe\n", ERR_PTR(ret));
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
 static int pdsc_init_vf(struct pdsc *pdsc)
 {
-	return -1;
+	int err;
+
+	pdsc->vf_id = pci_iov_vf_id(pdsc->pdev);
+
+	err = pdsc_dl_register(pdsc);
+	if (err)
+		return err;
+
+	return 0;
 }
 
 #define PDSC_WQ_NAME_LEN 24
@@ -316,6 +356,8 @@ static void pdsc_remove(struct pci_dev *pdev)
 	pdsc_dl_unregister(pdsc);
 
 	if (!pdev->is_virtfn) {
+		pdsc_sriov_configure(pdev, 0);
+
 		mutex_lock(&pdsc->config_lock);
 		set_bit(PDSC_S_STOPPING_DRIVER, &pdsc->state);
 
@@ -350,6 +392,7 @@ static struct pci_driver pdsc_driver = {
 	.id_table = pdsc_id_table,
 	.probe = pdsc_probe,
 	.remove = pdsc_remove,
+	.sriov_configure = pdsc_sriov_configure,
 };
 
 static int __init pdsc_init_module(void)
diff --git a/include/linux/pds/pds_core.h b/include/linux/pds/pds_core.h
index 274c899bbc55..7f59b3fbe451 100644
--- a/include/linux/pds/pds_core.h
+++ b/include/linux/pds/pds_core.h
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
 
@@ -298,5 +307,4 @@ irqreturn_t pdsc_adminq_isr(int irq, void *data);
 
 int pdsc_firmware_update(struct pdsc *pdsc, const struct firmware *fw,
 			 struct netlink_ext_ack *extack);
-
 #endif /* _PDSC_H_ */
diff --git a/include/linux/pds/pds_core_if.h b/include/linux/pds/pds_core_if.h
index f780b58c785f..1caafcb8c3eb 100644
--- a/include/linux/pds/pds_core_if.h
+++ b/include/linux/pds/pds_core_if.h
@@ -8,6 +8,7 @@
 
 #define PCI_VENDOR_ID_PENSANDO			0x1dd8
 #define PCI_DEVICE_ID_PENSANDO_CORE_PF		0x100c
+#define PCI_DEVICE_ID_PENSANDO_VDPA_VF		0x100b
 
 #define PDS_CORE_BARS_MAX			4
 #define PDS_CORE_PCI_BAR_DBELL			1
-- 
2.17.1

