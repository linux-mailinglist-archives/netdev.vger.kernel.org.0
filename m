Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E5926D0EAA
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 21:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232086AbjC3TYJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 15:24:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231578AbjC3TXm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 15:23:42 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2070.outbound.protection.outlook.com [40.107.94.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66C90DBDB
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 12:23:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DwhChMZybC2J6oRVtWkvnSFR2F1cV+URsjkPn6Rb/+oBGOn1AWLBLJAISY+GxrnPimOVc75PlsNy0HmlkGMr8twSiPaFNI/NZ8Ho1Bq5MpJBhMN0YBdh98baGrvhKE9xtWyEgTzITTQxIg3jx2NXrJ5pxVkpqWOUI1T7MsaQn9yHJ1KrZnSiFw/EB9NbeU7wK1wR7glLqSRQIIHF/zhpOpczVKOhmRhZ5apHZG7DbW08Tq0829vEPx5KgZj0CJXM1AxUqHRAqb7oiR1Etw/r12tuIONMDdvIfmBD/4wDjeedaj9CRn3RDfWaIEwR1hL7gAgFijgzct7+TmF6kzYc0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vWhLWAPycApRjvK8mTRRA0dtolTCMgUy5TylA9HAZTk=;
 b=L8hEy7Zvcw/eOfIg6IkFTsuQ+cdVRdTkaV9X1NAKAJbjHfbSue29T6Ehwyb5mTk7TPQLFERG+XHaCCGAmb+P8dEXqDQir4q489yX2/SNXHLCLdOp2MoS6r55RSnLQC4T9Z/KztZXjMrUlhhBkFbd6KSL2V+FTPkB82y8lSuTjrYq+Qm0eQ967D50TguQH1EDisaRVBqRHk6vFsouStuqCMvQjXSouXJVxql+b3lBiTl5tab0gRAxBq9vMzfmfpwU9lirH39TA3OUEiO8lcja+upoQ73WcEsaynfIQHp0mqtQSArUIULlgIWCTwlEIoxmugVV/DFqXxg1wBFqemHUtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vWhLWAPycApRjvK8mTRRA0dtolTCMgUy5TylA9HAZTk=;
 b=mcNNuyL2Mk1VVi2EwOYPOK0u/V3qedlyE8QuxMeuI3IAL9sStgpSTA8XXrueIMorDMzIMOvTIxqpFUSlygbC05fck+bSWcwZkxBOFUwbu4aitbK8xa3Lzs1GcN2Ui3CVLb9oOzmMCYCU/uHK/kTYowNh7KnO+lTN60/Qc2a8KLM=
Received: from MW4PR03CA0032.namprd03.prod.outlook.com (2603:10b6:303:8e::7)
 by IA0PR12MB8279.namprd12.prod.outlook.com (2603:10b6:208:40c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Thu, 30 Mar
 2023 19:23:39 +0000
Received: from CO1NAM11FT114.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8e:cafe::7b) by MW4PR03CA0032.outlook.office365.com
 (2603:10b6:303:8e::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.22 via Frontend
 Transport; Thu, 30 Mar 2023 19:23:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT114.mail.protection.outlook.com (10.13.174.103) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6254.22 via Frontend Transport; Thu, 30 Mar 2023 19:23:38 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 30 Mar
 2023 14:23:36 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <leon@kernel.org>, <jiri@resnulli.us>
Subject: [PATCH v7 net-next 09/14] pds_core: add initial VF device handling
Date:   Thu, 30 Mar 2023 12:23:07 -0700
Message-ID: <20230330192313.62018-10-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230330192313.62018-1-shannon.nelson@amd.com>
References: <20230330192313.62018-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT114:EE_|IA0PR12MB8279:EE_
X-MS-Office365-Filtering-Correlation-Id: 67c9859d-96e0-4273-7d18-08db315443e5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uF//65SLBJDD9dsoBazsImPhXPxqFLHBHZcnq8h8ma2jH/sBnBWblSLzDseKn1D5vz0Uyl1Rospe55khTlLwsYa269/3ROLbLmqoYasty8c86VwUCtsh973E9MTtmsyTYZfMoY77mULwBNn3JPXyc/USRux6E2RIOzwnExxeE0T0wX9ED4U9T7dmMOKI+by3GOUXY9nybEBThFHroYV4eiAhj7rRMhnsmLRj3vmXZOhQFKXsd9xx2+uKjLavhvW4DPX3d4jFcf1RQyt0lVUqDJ0rl9j4K4N7vU2AV+kZmEhYccn5uuWTYctbZTSO299AoeMUjtKY6ULsCfd+ZcrflxoxELjx+pU+jVc1nke/p7u7tMSfjwlftzV1fy+WcdPc4GDzOyYZVScqnLQe1p6Xu97GaHUs0G3I46AEpS+rzZg83ZSK5A61BqLe1QEVDnJYtmtFnhm5acznoo/WV3pnMbffDOhHv+iaKRlkU+YJzoNqMIPjeFIf1Fy9JxhnMVze8onlCdc2vEnCvVFT6QN/zzaXHxwHwyx23brlKkzZfbiURay+Ado1pdSsRXlqcO6Kq8WK15RcFquQhiDkgg3HaXw5NeIkObFjKTd6I9hHBtOG+V6DEZD4sq8g/bwS++KQl4yIehR0AHqNGb6U3G8+Yex9sn5TqsVRb36j1hznfVBDtquePs1bVJRqOnpkAFmEd/J00RmhP+7nqp8tSBXA4Nnih6x0Z7FMAy6bgHRHWGU=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(136003)(396003)(346002)(451199021)(40470700004)(46966006)(36840700001)(16526019)(316002)(54906003)(186003)(6666004)(110136005)(26005)(1076003)(336012)(426003)(2616005)(83380400001)(47076005)(82740400003)(40460700003)(478600001)(8936002)(82310400005)(40480700001)(44832011)(86362001)(5660300002)(70206006)(81166007)(356005)(41300700001)(70586007)(8676002)(36860700001)(2906002)(4326008)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 19:23:38.7465
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 67c9859d-96e0-4273-7d18-08db315443e5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT114.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8279
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
index bfb66c633029..8eaace786efa 100644
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

