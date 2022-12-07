Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B3AB645091
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 01:46:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbiLGApg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 19:45:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbiLGApZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 19:45:25 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2059.outbound.protection.outlook.com [40.107.94.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8193B326F2
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 16:45:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H/YCclBZ4iDzeRYS4Eb6Xm4pPt30gqAex3l28lrR0bx9yuobMKT825VE7fAHvwANOag5TqfD/fw2DbZsEcsUyU17qMLLODKvDaOss3avsl1sLpkEpJ+jLtyAVYAjWmiiFa61HAURviDpwzoyW4au9boHYF4d6g+qlTsPD2I0ZmtOeVNwpVJAvBTJGJVlUn8p2HZpQXd19FQknuDihUMKmdvEhm5KpfaHeBzpGvLMn+1hqZzloCEawub4UTgywq1zWT8oZmCm7kQpQxy7Xih0DnDbMJe8KyBH+3m3bhWxeVUnScKx10CcHqVL4EfSigHGzggBWh52VTIK/6/Fi+Z1Gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vUcPBe1tIy/npRLAgIcH87sIjalZf58mWjLHliYRVmc=;
 b=W9En56u2m/N0ZSTWDNgAkos81VuwoPELWHVKHTz3UiDgQd9T9dRGlP1e3FAPqV0gq6+e3d5axDvXZS2blOG2znoXfje7YI0OcUQQLWEZxYJnqgwHWFUh4Goo41eI1MmgzRMofY5DCCeOLX0a5KV6LqPA3Ke+okvRccRAWXIqc/GRhzewDcfU0U65E4ar9PmkY1/UEyBxgAMpVvagQaat2IhTrKqskwmivQa6XFdoI1biFlt8NXt3KvYMhg8DQICLbM+l7LbpZgUOgxxUPC8Q8u2XNikgbB7+W3Ss+RHJ2HevWG5aZElG7+6tOC5gUJ9ifmw/76EoKjNS1gqhVr9bCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vUcPBe1tIy/npRLAgIcH87sIjalZf58mWjLHliYRVmc=;
 b=qEbRMUU6qO7MsqUAO7bdcfZmNDelm97n1u62TL0dL4fn57ooZJRWKD0Xq1PQad+0kOCefksLhVtu3xwKgV2xD3pNQO9QtS9huuasNbr0+J3wngABpNzKkyBXyL4e+/ajOCzJxLnX9ORhMbpcbwnSIZkBnfHJKPX0aqk9qf/2TjQ=
Received: from BN9PR03CA0256.namprd03.prod.outlook.com (2603:10b6:408:ff::21)
 by DM4PR12MB5392.namprd12.prod.outlook.com (2603:10b6:5:39f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Wed, 7 Dec
 2022 00:45:12 +0000
Received: from BN8NAM11FT003.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ff:cafe::5a) by BN9PR03CA0256.outlook.office365.com
 (2603:10b6:408:ff::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14 via Frontend
 Transport; Wed, 7 Dec 2022 00:45:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT003.mail.protection.outlook.com (10.13.177.90) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5901.14 via Frontend Transport; Wed, 7 Dec 2022 00:45:12 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 6 Dec
 2022 18:45:11 -0600
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, Shannon Nelson <shannon.nelson@amd.com>
Subject: [PATCH v2 net-next 11/16] pds_core: initial VF configuration
Date:   Tue, 6 Dec 2022 16:44:38 -0800
Message-ID: <20221207004443.33779-12-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221207004443.33779-1-shannon.nelson@amd.com>
References: <20221207004443.33779-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT003:EE_|DM4PR12MB5392:EE_
X-MS-Office365-Filtering-Correlation-Id: c1ad0ee6-a727-4215-bd85-08dad7ec4cd2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nycDxTZ9d7BisdQm5fG2nE0b9OYWMSULyOwIk/x2Fb64W1f208GSpEI3id173nQiuDzz2g3BjXfmTSy7k4MEpA5oKzrpREKbiYP5Tl0+aIPWY1Xhbv2qq8zdsDDX3WWntBa+v0NB6TPct0P7Qi0oU16u4qd30V0wAjvnAKdxyNCHwoQLGHswEYh14q9zjYYhUxLyyuchW/OUErhSxrqsaw5Yk9Baelb+4Y8TYse06cDg/gL3Rbf1aHyUKsf/DkjXowt9iIDTK0PMsj4htCMiwwORddJV1PS3rK2+trQDdKdsD7S9DrmipDMWzQoIW4eQwtNHcPKB5924BanWvbXJSLo3n+5TF3PENEpPT9tBkSxPLSIZuMakJFMbKJ/NA2f7iQpCDJzbI+rTsx8NcFJPWdL1c34XkSmAC49IRVKjiRJ+Ynwp0Vy0NzDTjyS/zcRhLFNLz9hjlhCy7gl045sHUaXGkdi9F7RldbXcZEHmzAi/7HtSybMjccCKY/CFSyio95u9fPmY6p4R4m+5BbDrrF12YTjLEppgFXDalESeMlEiGten616so7bCVC0bfAKlxBO3yizruH6GJVjO/HHzzpcFwHfnQ1rjZ5dKWlyS9w9lsBud54S/jdsSqHyEzJUOhourODDLmQCYOOftU5VlL5x3IZIZ/yagPMFqu8rcMCZQnchA+27XYo7y8HoNfOS+6OK5qEpCzn+UQXnEA+647FuGXi4mAdwloO2Mo0ESi3Q=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(39860400002)(136003)(346002)(451199015)(36840700001)(40470700004)(46966006)(40480700001)(81166007)(36756003)(356005)(82740400003)(86362001)(40460700003)(316002)(110136005)(6666004)(54906003)(478600001)(44832011)(2906002)(5660300002)(8936002)(70586007)(41300700001)(36860700001)(4326008)(8676002)(70206006)(83380400001)(47076005)(2616005)(426003)(82310400005)(26005)(1076003)(336012)(16526019)(186003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 00:45:12.7010
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c1ad0ee6-a727-4215-bd85-08dad7ec4cd2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT003.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5392
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set up the VF control and management

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/net/ethernet/pensando/pds_core/core.h | 10 +++++-
 drivers/net/ethernet/pensando/pds_core/main.c | 35 +++++++++++++++++++
 2 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/pensando/pds_core/core.h b/drivers/net/ethernet/pensando/pds_core/core.h
index bdcfd5f0da60..83a7f7ebcc4b 100644
--- a/drivers/net/ethernet/pensando/pds_core/core.h
+++ b/drivers/net/ethernet/pensando/pds_core/core.h
@@ -30,6 +30,13 @@ struct pdsc_dev_bar {
 	int res_index;
 };
 
+struct pdsc_vf {
+	u16     index;
+	__le16  vif_types[PDS_DEV_TYPE_MAX];
+
+	struct pds_auxiliary_dev *padev;
+};
+
 struct pdsc_devinfo {
 	u8 asic_type;
 	u8 asic_rev;
@@ -147,6 +154,7 @@ struct pdsc {
 	struct dentry *dentry;
 	struct device *dev;
 	struct pdsc_dev_bar bars[PDS_CORE_BARS_MAX];
+	struct pdsc_vf *vfs;
 	int num_vfs;
 	int hw_index;
 	int id;
@@ -166,6 +174,7 @@ struct pdsc {
 	struct pdsc_intr_info *intr_info;	/* array of nintrs elements */
 
 	struct workqueue_struct *wq;
+	struct rw_semaphore vf_op_lock;	/* lock for VF operations */
 
 	unsigned int devcmd_timeout;
 	struct mutex devcmd_lock;	/* lock for dev_cmd operations */
@@ -299,5 +308,4 @@ irqreturn_t pdsc_adminq_isr(int irq, void *data);
 
 int pdsc_firmware_update(struct pdsc *pdsc, const struct firmware *fw,
 			 struct netlink_ext_ack *extack);
-
 #endif /* _PDSC_H_ */
diff --git a/drivers/net/ethernet/pensando/pds_core/main.c b/drivers/net/ethernet/pensando/pds_core/main.c
index 856704f8827a..1ff63a4339d8 100644
--- a/drivers/net/ethernet/pensando/pds_core/main.c
+++ b/drivers/net/ethernet/pensando/pds_core/main.c
@@ -165,6 +165,37 @@ void __iomem *pdsc_map_dbpage(struct pdsc *pdsc, int page_num)
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
 static DEFINE_IDA(pdsc_pf_ida);
 
 #define PDSC_WQ_NAME_LEN 24
@@ -237,6 +268,7 @@ static int pdsc_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	spin_lock_init(&pdsc->adminq_lock);
 
 	mutex_lock(&pdsc->config_lock);
+	init_rwsem(&pdsc->vf_op_lock);
 	err = pdsc_setup(pdsc, PDSC_SETUP_INIT);
 	if (err)
 		goto err_out_unmap_bars;
@@ -300,6 +332,8 @@ static void pdsc_remove(struct pci_dev *pdev)
 	 */
 	pdsc_dl_unregister(pdsc);
 
+	pdsc_sriov_configure(pdev, 0);
+
 	/* Now we can lock it up and tear it down */
 	mutex_lock(&pdsc->config_lock);
 	set_bit(PDSC_S_STOPPING_DRIVER, &pdsc->state);
@@ -337,6 +371,7 @@ static struct pci_driver pdsc_driver = {
 	.id_table = pdsc_id_table,
 	.probe = pdsc_probe,
 	.remove = pdsc_remove,
+	.sriov_configure = pdsc_sriov_configure,
 };
 
 static int __init pdsc_init_module(void)
-- 
2.17.1

