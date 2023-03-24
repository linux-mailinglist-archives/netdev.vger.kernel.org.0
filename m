Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C64DF6C8583
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 20:03:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbjCXTDf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 15:03:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230117AbjCXTDT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 15:03:19 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2608D307
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 12:03:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D6PNvyP10KqVDbQ5nLdY09FGMu0fwFox+XYgvY0TJ0RNDFxjrGXXnpuPeRUvIpAIBdckOEjnMWhhd+OkeFZYx1cWq2v5ouaZHzbSitquMmCIvzKVo76JadfmdqefXNo1Eurk8RabctPMt5eGr0HTOU7lj6PtxKuunlWUBPJseEKL9IhKAtaM7+HBL3VKCgXcvuoq6aflyrZDODNiae2iDSOMM8CTY4IZtXOAu3a2a2rJFxXJk88GqXdzjpQYsl+d/AwZ4dT8wOI+06F6XZw0FXRSnwsRuKQAe7dSWTNgqhWbhfGhnMoyNeI+mZqKGlpBxn5S7E/lN7yqD1Nnx267AA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+nzcQKG9a56ODdTtui8h6WZvdbuQsTGASWQAFcx9gIA=;
 b=ocTSIYNtXOmResygbr2oZKukFxx7MHHhNCv7PTFY1kwrQatVNGJPStmKC7hvbyyJfGZao78Alo6TAgj2Cy3wbA+2MlUS1mXMACMek+nd0luXL4AZnI7GUI8FQjFBmcddtqlmoXb/CYnNr/UpPwDaqT0IbscErwZNabmvnX2FgCsx3AeJAlPG1KDacRaRww5qci6WUXMMXwnbjYm9faN7sTpolGh0LOFgJDv+m/vRqiGAjcNILKuWCtgOsNDb5lPF5sn2+1qlL7hFV6nwc4l4kzcbuBN9vuJmqnqnL4CxOKvLRvEy2cNOMEFySdzVE8TzfBBe2sU+GZFzfUtassInIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+nzcQKG9a56ODdTtui8h6WZvdbuQsTGASWQAFcx9gIA=;
 b=DN48hS35Wklbjes4HOVKqPkzqyMfzWk/SW2F2jW+Qazwc6bjJHJycqgg8PlYgUPgLD/Hzs5VihmxKOkqqHHuO7C38ClJUxOLYoiM/CUttFqP/0x+0ShRkJwur0YdxWIt7rY0OWlXJSux6f9C8ONHboX86PeNRiylnsteGo6zVFo=
Received: from DM6PR21CA0027.namprd21.prod.outlook.com (2603:10b6:5:174::37)
 by SA1PR12MB8721.namprd12.prod.outlook.com (2603:10b6:806:38d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Fri, 24 Mar
 2023 19:03:14 +0000
Received: from DM6NAM11FT076.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:174:cafe::b5) by DM6PR21CA0027.outlook.office365.com
 (2603:10b6:5:174::37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.9 via Frontend
 Transport; Fri, 24 Mar 2023 19:03:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT076.mail.protection.outlook.com (10.13.173.204) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6254.9 via Frontend Transport; Fri, 24 Mar 2023 19:03:14 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 24 Mar
 2023 14:03:12 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <leon@kernel.org>, <jiri@resnulli.us>
Subject: [PATCH v6 net-next 09/14] pds_core: add initial VF device handling
Date:   Fri, 24 Mar 2023 12:02:38 -0700
Message-ID: <20230324190243.27722-10-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230324190243.27722-1-shannon.nelson@amd.com>
References: <20230324190243.27722-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT076:EE_|SA1PR12MB8721:EE_
X-MS-Office365-Filtering-Correlation-Id: f911271d-fbf9-4831-0ed2-08db2c9a6b77
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +NoYsa10+qRd9fIf1h0ZqPEgr2AbA5N9r5MGoyoxfgX0Na8dfCk8sY1UDmbeBIyliQDWhCR/9QyH6QCNXTpOYDJbcDLaTc6AOVlSgwLIzUTL6UAwAE7xnNLMZgUY3J4hqvRzGghi+RURSMj20l37FgL5Yn8doebrtln+oKI0lKB9zOTj+ji4EEGF7L/zr1DmID42TS3yKvaajh6qELoWhdaQYhc+gt3SGNA/A0zLLw6lLquIj+N+qY3MWgzdDrg/+/bG8SyxCm+QQJrQt4lM4C5W2ro3D31U6OdCWFJzxZzZzjW5LaNB+HVJSEJwsyJOLn7MJJ55DLal5IDbjAuuR+ehtnJ52C9Ohntcgo2TLaKCkHJEnqlXrJPNVRkb1lijwt1R/1leRlNjq4qB3QMnKa90RuFUUTGj45Dz98jpjK007S1eq/rFl2cp8M2/jScufQQaWni5v0pK4vA3sAaQlrNP/gbbH3Kn4ZCjOqcach+vwIT3t9SPIbkwIyaeQ0emNkMcTy6q7+ylhuVerJzLMVaZfqlnB8K0TF6fECf/rNomKwwYerFa3IvCo+XNrcrtIBe3mb2j39M9lJ6sTpV5iQnXCR994IZEztAf9BaW+YA/0GxQl4wMEGdCYpS5Lxh01MwlrPBBz6d4+Xjv6dmgNk1VgosK1VH41KwyWad3SsFDwbZDwZczz3P8Y55OxY3OGtgOS0VejwjhBYnKXpb9HD2MQsNQZB2rhRLzRa7G2nI=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(376002)(136003)(346002)(451199021)(36840700001)(46966006)(40470700004)(81166007)(8676002)(5660300002)(41300700001)(4326008)(8936002)(83380400001)(426003)(40480700001)(82310400005)(70586007)(316002)(478600001)(70206006)(2616005)(16526019)(186003)(36756003)(1076003)(47076005)(26005)(336012)(54906003)(44832011)(40460700003)(82740400003)(356005)(110136005)(6666004)(2906002)(86362001)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2023 19:03:14.1670
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f911271d-fbf9-4831-0ed2-08db2c9a6b77
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT076.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8721
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=unavailable
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
 drivers/net/ethernet/amd/pds_core/core.h | 10 ++++-
 drivers/net/ethernet/amd/pds_core/main.c | 47 +++++++++++++++++++++++-
 2 files changed, 55 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/amd/pds_core/core.h b/drivers/net/ethernet/amd/pds_core/core.h
index 46dd869b60a5..74f80af53067 100644
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
 
@@ -296,5 +305,4 @@ irqreturn_t pdsc_adminq_isr(int irq, void *data);
 
 int pdsc_firmware_update(struct pdsc *pdsc, const struct firmware *fw,
 			 struct netlink_ext_ack *extack);
-
 #endif /* _PDSC_H_ */
diff --git a/drivers/net/ethernet/amd/pds_core/main.c b/drivers/net/ethernet/amd/pds_core/main.c
index 9dcc8f4f247d..486eb87a0520 100644
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
@@ -164,9 +165,50 @@ void __iomem *pdsc_map_dbpage(struct pdsc *pdsc, int page_num)
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
+	int err;
+
+	vf->vf_id = pci_iov_vf_id(vf->pdev);
+
+	err = pdsc_dl_register(vf);
+	if (err)
+		return err;
+
+	return 0;
 }
 
 #define PDSC_WQ_NAME_LEN 24
@@ -320,6 +362,8 @@ static void pdsc_remove(struct pci_dev *pdev)
 	pdsc_dl_unregister(pdsc);
 
 	if (!pdev->is_virtfn) {
+		pdsc_sriov_configure(pdev, 0);
+
 		del_timer_sync(&pdsc->wdtimer);
 		if (pdsc->wq) {
 			flush_workqueue(pdsc->wq);
@@ -354,6 +398,7 @@ static struct pci_driver pdsc_driver = {
 	.id_table = pdsc_id_table,
 	.probe = pdsc_probe,
 	.remove = pdsc_remove,
+	.sriov_configure = pdsc_sriov_configure,
 };
 
 static int __init pdsc_init_module(void)
-- 
2.17.1

