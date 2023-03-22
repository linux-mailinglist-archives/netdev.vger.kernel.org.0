Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 271D36C5465
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 19:59:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231386AbjCVS7J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 14:59:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231307AbjCVS6H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 14:58:07 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2079.outbound.protection.outlook.com [40.107.93.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CC7D6A9D4
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 11:57:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SFmU5pIl7VxYUPEv0GoPVEnompLevLdusvevnQ7A0kh7Td7zVfTaQnXBdBwQMwTthjYwyPkNA6JZaUMW3PcR619gIzhISB71KIMaL8nxr2Bb2i6eKRGO1lY7tou6yO7IXP8Ea0h+Iipjnx/ogKJUNhYBU59aS6BWKKDCa+tMRz3zo//oJtsaYojok/KyZZlTRQVVqJHtMoqyW4OI9QHaMsS84EqzxzDVa4aUjKJBvnU6zwrDvWaU5LsapH2mmYn0lFbZA2Tk542XVtNN1Og7s669Tk5xEYRNWSz0IGEcj7+ole1fog0HozgdGuKNAcq3LQ6sCfsaqsQyEeRLeLjhGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9FKWlCFrXx0Q/aapo3KYIvhnXABNpZ11Qb0jmW+CBa0=;
 b=ELlFoU+n4s5omizOen5ag9sJ/dNbzMSh0btALQB7tiEfo+AlMfEqVhTAlFCxjpWRLj9uNHUSjB6NEXRtuHtNjZMoL02LyXlm2OKHMC2LTD/W6jdukeYsM3IrB1aeEseEW+bM+WGKOSY/ArrRflqFbuoX9ShmQgcoDk+EuEbbZYJaGe9QlKDZb0+SqCeZjKsnzPYmbayC/3zklZO8Dz/MLkcNH7+wD14tab2igTJWZLOBC6xZSjGeEDZ+oKuvGM/t8pJQ1+RtHWUQzO4aZlcHFJM3B4cR/z+Ucj8BkXMGAFp2tL3ZrJrSqNVfC+jHCgmzqcXtzGdy9Z9+xTTIFntWAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9FKWlCFrXx0Q/aapo3KYIvhnXABNpZ11Qb0jmW+CBa0=;
 b=l/3uvFwQSO+bu9YfzqJVGOR7sjsiCl1wS4NZ+DguNpKzdrhnlpvhY2e/d8J6zR6e3QavsWxqAoMYkF7zBQJ7z5c2Dtq0l0p2PrAD6hahKSWEwqQpMJNZcZVf/6jTQwhwBUrxO7CS+IXxijzqYPqBsI082uOzJ6GOpg9kdiHu92Q=
Received: from BN9PR03CA0974.namprd03.prod.outlook.com (2603:10b6:408:109::19)
 by PH0PR12MB7959.namprd12.prod.outlook.com (2603:10b6:510:282::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 18:56:55 +0000
Received: from BN8NAM11FT051.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:109:cafe::e2) by BN9PR03CA0974.outlook.office365.com
 (2603:10b6:408:109::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37 via Frontend
 Transport; Wed, 22 Mar 2023 18:56:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT051.mail.protection.outlook.com (10.13.177.66) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6222.17 via Frontend Transport; Wed, 22 Mar 2023 18:56:54 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 22 Mar
 2023 13:56:51 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <leon@kernel.org>, <jiri@resnulli.us>
Subject: [PATCH v5 net-next 09/14] pds_core: add initial VF device handling
Date:   Wed, 22 Mar 2023 11:56:21 -0700
Message-ID: <20230322185626.38758-10-shannon.nelson@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN8NAM11FT051:EE_|PH0PR12MB7959:EE_
X-MS-Office365-Filtering-Correlation-Id: 938dad85-64be-45ac-cfca-08db2b073488
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S5SbKrRAOejvcksSiAnZtsGxaxlrGE3LGgUChmoTZGzyWf+yHkWasE2NGlkVBVXS29Tkuatlg89bXap6D9qGMI5AnZxPyZm6atgkhvw4IiFrAkPebT/m+R6+sMwwq3rWK27UhCWgtoU2EqjGDcNVPB2Ajzz3W8XeTVWWdB8WgZcq6CsUQ6HHALF+jUnmo/o1gkkPHi6K+i/yUUkcu7LIXiiu9nOlEXpIPFqxqiXRJmDijZJ68y8E58tvRBaTkAsQp9gFTTJrSumQJhaV/uMTRGblX2/6KqAYZ05goh8eBYdGzF/gFFH90ElO8z4NZAMheRnu6civiEGrHAKaQobclbeKmerTHo5kw0gkA3lR0T6u+Gh5AzKQcrbA2S96ufUBSDYg1p5wX+kFEvFoyWLYZXgDGYQeOus9oAKkxHG1zDJZq0PzLC/hxUK6QiY466MqY7/Og0xEEAp9ycTgZ9pOvvUuh+Te2jbp6f65omjtomQr7Ll9hwgSmtRLuK5aToj2S9jYRJ4BmvZFKYnvFNZuE5jrsui3n5ELmjKb6X43RUD46mbd/+rA3BeDbNomH2O3z3I2GqWINXVLIR7TFOt87dKiEOleroi4GdtZo/lbdNKUAuHfBg6u6B2w4jnTFGOzqxtcB+Jp2splMKW6dacubM0jo+uXzZ0Z1tGur1aiWXaeceFq+Jng4oido64CUj86Vmy8K4vaSNqQRyQmxWnpOCsqVa4GkWXXtZuDhADe53o=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(136003)(376002)(39860400002)(451199018)(46966006)(36840700001)(40470700004)(4326008)(41300700001)(36860700001)(70206006)(70586007)(8936002)(356005)(81166007)(40480700001)(86362001)(36756003)(44832011)(5660300002)(40460700003)(2906002)(82310400005)(82740400003)(47076005)(8676002)(186003)(26005)(1076003)(426003)(336012)(478600001)(6666004)(316002)(110136005)(2616005)(54906003)(16526019)(83380400001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 18:56:54.6860
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 938dad85-64be-45ac-cfca-08db2b073488
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT051.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7959
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED
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
 drivers/net/ethernet/amd/pds_core/core.h | 10 +++++-
 drivers/net/ethernet/amd/pds_core/main.c | 45 +++++++++++++++++++++++-
 2 files changed, 53 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/amd/pds_core/core.h b/drivers/net/ethernet/amd/pds_core/core.h
index 4704194e9bc8..97a9b4a6bdfe 100644
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
 
@@ -299,5 +308,4 @@ irqreturn_t pdsc_adminq_isr(int irq, void *data);
 
 int pdsc_firmware_update(struct pdsc *pdsc, const struct firmware *fw,
 			 struct netlink_ext_ack *extack);
-
 #endif /* _PDSC_H_ */
diff --git a/drivers/net/ethernet/amd/pds_core/main.c b/drivers/net/ethernet/amd/pds_core/main.c
index be85358ea8cb..51d7aa67ff68 100644
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
@@ -164,9 +165,48 @@ void __iomem *pdsc_map_dbpage(struct pdsc *pdsc, int page_num)
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
@@ -318,6 +358,8 @@ static void pdsc_remove(struct pci_dev *pdev)
 	pdsc_dl_unregister(pdsc);
 
 	if (!pdev->is_virtfn) {
+		pdsc_sriov_configure(pdev, 0);
+
 		del_timer_sync(&pdsc->wdtimer);
 		if (pdsc->wq) {
 			flush_workqueue(pdsc->wq);
@@ -352,6 +394,7 @@ static struct pci_driver pdsc_driver = {
 	.id_table = pdsc_id_table,
 	.probe = pdsc_probe,
 	.remove = pdsc_remove,
+	.sriov_configure = pdsc_sriov_configure,
 };
 
 static int __init pdsc_init_module(void)
-- 
2.17.1

