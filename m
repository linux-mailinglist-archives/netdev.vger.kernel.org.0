Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09D6E6DA630
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 01:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238795AbjDFXmt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 19:42:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238715AbjDFXmc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 19:42:32 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2083.outbound.protection.outlook.com [40.107.244.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98519AD0D
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 16:42:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GkY7zjyKGOs6chRuHgy7c6qRiI0vKf8J6ZTA7bX1aGcXtdKX732WotlmGnCFSxE+TnCS5shqN6eH/Lu0dI01n8fIcnMh1bEaGXlshQdS2TfkNzieTDP0iaoWjdJgGl3Gzbv64EYFnM/uIqY0hTYEob+aseTXMy+/0Fk2QLQMuiluqk6LSgFONJoEqg+7ff5gQ9nEOpaSXtHZk8upiMus0PWiRkda+pUXgCSC+R0llLnaAx3aKE94bFsGCX10JMFgZ3b8hBPTKcVnM7C450+amVcrEYZu1cDrZBUKIWh/8i3lTwepRpxYUhjUgH2H41slho7dpy5BjvjXl0CmfP7pSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jp70WsdwE63Btu7y0VE8Iv+EvpXEjlKBwLL+GdMBars=;
 b=F38bloSf83o/KXySFd0lTP56bUEYXWr7ZeiUsMuuF/p9w9mTrwUVkXcTrx55cnYXVX+Lm0NB0UilGCOc5S/+XbCfBYDhd9lb4LnNAJe1bw1VLvyU+nfaAAgc+/7IVbgZ+RgwOtrTK8A2lBxkogNZ9MkU74u3ecHEGe3fkOJJEDZ+leLlGjM1VeYmmp8wyj9PPr5YmGnquJbVFbd9g02Cm3nxbIZXvbndasME1+OWMT38HDVhG2yibKoOsGPaV0w9qLeeI+9ZfOZ/vVvF4CEe3GF+dEckkFCIFPP4r6EfrKXTcx78RfkRpwAf8xDXe9aN8sGkBxC74D2ETBnMcufEQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jp70WsdwE63Btu7y0VE8Iv+EvpXEjlKBwLL+GdMBars=;
 b=FvTtUFU1dsxwhlAcy49bbXceaSCrwYpuXV35vHpr6PHl8uv0KvsYNmDq3vUNAPqiPha3xySLcg0tHG4pdpStxLJUCUt2YlMh1PvZTLBF8K68RmcQjFosxAvj0TET8vM3o2MbJFN9XtvdjWpDRR0AtjVWxbf/4YHmxgAyitjcr+Q=
Received: from DM6PR04CA0017.namprd04.prod.outlook.com (2603:10b6:5:334::22)
 by MN2PR12MB4406.namprd12.prod.outlook.com (2603:10b6:208:268::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Thu, 6 Apr
 2023 23:42:25 +0000
Received: from DM6NAM11FT011.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:334:cafe::88) by DM6PR04CA0017.outlook.office365.com
 (2603:10b6:5:334::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35 via Frontend
 Transport; Thu, 6 Apr 2023 23:42:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT011.mail.protection.outlook.com (10.13.172.108) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6277.31 via Frontend Transport; Thu, 6 Apr 2023 23:42:25 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 6 Apr
 2023 18:42:23 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <leon@kernel.org>, <jiri@resnulli.us>
Subject: [PATCH v9 net-next 09/14] pds_core: add initial VF device handling
Date:   Thu, 6 Apr 2023 16:41:38 -0700
Message-ID: <20230406234143.11318-10-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230406234143.11318-1-shannon.nelson@amd.com>
References: <20230406234143.11318-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT011:EE_|MN2PR12MB4406:EE_
X-MS-Office365-Filtering-Correlation-Id: 34884404-dcb4-4804-a15f-08db36f8932e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2HnjIKlhiadvV3psEUIUF/YElqvvvGe4d2VP0xJvEaPmar+rv8C/HnAMiljDh3x/Ir7cX3PkvhMVXhL8gvhyEWbcPaEEcVKXMopA5J5P6Zh4cwbncHiVJyDZVZ+csMKOj6Hd7TLtgNFkEhg2C5sv3mVnun4GLOcnfQ/aWFRrT9FUBoHs/VVoujOeBtUy0FG2A00Tq6LONHTFEJW65QMMsKyCtcBH0zHapnZ7qyU48j0NMmm2H9zU2uyBcczIH5fq3N42lPFGqEMIFMTnD5LtR2hRqgXUzcJ84gIPw+SqcGmyKXQ10nv7xISVMB9eEocL8JZEAoRPKKvrLgd63Qlme+UfzIy2koE85hnHKjgddQ5zDTS6DF/PBGYfT5UPYBVvBMf2+Cxlanq69f91QTkLyMrsXHXSwLyVeAPX0W1jzR7ThwJHHPkDT/U3dQClXcpxtwIa8hStN8v1eTNyLQ4WHZcFfFRJHmsaRhrxCL3V9UdKq01/9ZZwYKpt8R6iejyDIZkx4YJUg8SNSppiq8lAgn1nznyqbnEd2qk1hEEwPIIIwFYgwDwZQ9tDmMv4qooVZdtSy3sbrzBRvQzJ5PrcCklJsQai7ByC+f42A3xlVPx+oKdhXLFxFBW7zZMqQK7WuPwDvYfnZu4E0OHQaYp3VRqeo05XmH5YFDRkv8zafBG3IQ/0+uGtGqglrF6doHQwSqoBZpkiIyBfL52Y3aAI75HfCRF4sGnaJi0mNpGRauw=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(136003)(39860400002)(346002)(451199021)(46966006)(36840700001)(40470700004)(336012)(8676002)(478600001)(70206006)(316002)(70586007)(110136005)(54906003)(4326008)(6666004)(82310400005)(2906002)(8936002)(81166007)(44832011)(82740400003)(5660300002)(41300700001)(40480700001)(36860700001)(86362001)(356005)(16526019)(1076003)(186003)(426003)(47076005)(36756003)(83380400001)(2616005)(40460700003)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2023 23:42:25.1371
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 34884404-dcb4-4804-a15f-08db36f8932e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT011.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4406
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
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
index 0133bc45913c..5be2b986c4d9 100644
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
index d5edce8480d7..5bda66d2a0df 100644
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
@@ -143,9 +144,51 @@ void __iomem *pdsc_map_dbpage(struct pdsc *pdsc, int page_num)
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
@@ -337,6 +380,8 @@ static void pdsc_remove(struct pci_dev *pdev)
 	devl_unlock(dl);
 
 	if (!pdev->is_virtfn) {
+		pdsc_sriov_configure(pdev, 0);
+
 		del_timer_sync(&pdsc->wdtimer);
 		if (pdsc->wq) {
 			flush_workqueue(pdsc->wq);
@@ -371,6 +416,7 @@ static struct pci_driver pdsc_driver = {
 	.id_table = pdsc_id_table,
 	.probe = pdsc_probe,
 	.remove = pdsc_remove,
+	.sriov_configure = pdsc_sriov_configure,
 };
 
 static int __init pdsc_init_module(void)
-- 
2.17.1

