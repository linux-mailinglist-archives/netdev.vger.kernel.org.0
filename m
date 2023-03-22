Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CEA46C5462
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 19:59:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231204AbjCVS7K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 14:59:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231316AbjCVS6I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 14:58:08 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2051.outbound.protection.outlook.com [40.107.237.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B23736A9D0
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 11:57:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Os+r7vUUXT7qcXIWlucbnIL5bQcjzHhpP2HRi1jAkepLPq3jz/zulT6R7Xshr5Br8qTtgjsyPDzcSa0DbLz7Cla2Fg6IfSO81FzvAcmnEONbVoBY4C0gpcyQe2hK2uIzsKq8phznLmaw93JP7N2fqcPTvwsjvyLJUjWpVHM/Lk2iMch5wyGgqtwyKnDGX/0AwmkXWaNEPXxjLBjQxNkoRCJFH2Ue4zg5VjnV1n+SQxenB6jh3YEP9RmaBO8pz0lzaY968y0pweQW7I+ch/rmhxm6DlYiKZ2kP0kMhpb+UA7nUzsp00LacCJovBcD6/gN4nc7pZWITy7ewCLXAHapVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hf596pF7aZPq0cTWZXLhY7bo9sMmbMXPAIrtkLUPej0=;
 b=byOkGowxTx/Ok+haKzHbi6yQZZNpMhBDBdVHhqtPBrDjgL06CqCl3yXbwVgYplZ3XLdOd0TQJiQNtLXzDN8AXb3iVl3u5kvSe4CC7yHxUf4+MH1+/BzSuE07ZiMgW/bRepXKJAWa/YmnR3igqCe9cMLWBpYnw9pnVAJOH+hHeJfT0JMg8eNFsV8AkCtacCByTJLECWZzT9sqtu82lCb8WZ7on+GWvi0NdXYTiCdosUJo7RMVZW6wnWMjUqBB0vSnN9qLnXa+Iabc5yyYcVS7KgsOEW1eMqTp1+hKz5q/IUx/Oblbv31hnbepq1KnGUxAVJ98vWLZQnNlM9U2tXJdYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hf596pF7aZPq0cTWZXLhY7bo9sMmbMXPAIrtkLUPej0=;
 b=p7AwJpukRFnsnRG42GU2/586fHOAOLeSznLy+7ekITeiTzPXXWhT1NPHsU+IXux1F4bUk+BKGlsfOrzk1/nk1555s1X3deQT8UCWUxkEsMegDTUyS2DFi/lJvawiZLn6pcrEdZJY3NFN7Rz1mUFGTn4MlYPRh/oobevxM6m/M4Y=
Received: from BN9PR03CA0983.namprd03.prod.outlook.com (2603:10b6:408:109::28)
 by DM4PR12MB7670.namprd12.prod.outlook.com (2603:10b6:8:105::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 18:56:57 +0000
Received: from BN8NAM11FT051.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:109:cafe::aa) by BN9PR03CA0983.outlook.office365.com
 (2603:10b6:408:109::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37 via Frontend
 Transport; Wed, 22 Mar 2023 18:56:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT051.mail.protection.outlook.com (10.13.177.66) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6222.17 via Frontend Transport; Wed, 22 Mar 2023 18:56:55 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 22 Mar
 2023 13:56:52 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <leon@kernel.org>, <jiri@resnulli.us>
Subject: [PATCH v5 net-next 10/14] pds_core: add auxiliary_bus devices
Date:   Wed, 22 Mar 2023 11:56:22 -0700
Message-ID: <20230322185626.38758-11-shannon.nelson@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN8NAM11FT051:EE_|DM4PR12MB7670:EE_
X-MS-Office365-Filtering-Correlation-Id: f1360f13-aa3d-48a6-6529-08db2b073502
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mRjoezrCGST75BJkFxYGQN6g+ETML3u9+K4bbz+6y0aZEWLEntSnqOXh4I1wQMvHRsOeQPuUO28M/gn+YN7r2v6Lik+pc6O2GBQJ2YjUi7XUdWgnrxarBFz24f83Owr43LFjsMUgQsG3MyB8HGn7HTqUQ7gZIVsF1dJod/eTTTPSnEDo4rSWfVmCYjaBXpEdEGgFKbADucuPOGYpZRF4mu3WAt9SWkXocmV8gxvcDq1SKtPdKiHiKAQsG74E17PTXcrJCj67Jahspeik4hZXpHOECCWrz3sA6Ti+vXolqUOCJUNxPUR5yjtUsiq5Tv7AXz+VBda6N860dY0HsJLhkYxAjvsRoIebEqidJFju4zki7JgTvOdKARQZtYM0BrqYhACaxEuYOQ3dbmJ9IgDczJ+x9P0qwv/xEujX4WXc1veDziXuz9WA7KHoYRK7VA5GhHsSW0cZHkPYHBivzlcj/f6UZ7iRGJg+s6LmdOysaZS0HzzZ02gDE2Hf8qs1Zo2dii9bZ+w4vcUSJ0mIST/fTlEAMpj3a8HvRp+vumQC6NKHgoxnIWlIoJ4HLKq0aLrq4HQJQFh/ukGw8zgvhOxjd4zy+EzwZ82724oKb0J6/DIFGHbIusMLIWtY9yfyArWBm0YnhIefJXrpJSTa2ip+BhLQ7gYmnDi6hqbFFsIKOH2DcC1BzLPG4msRbgdBtwJq8PHqqnuwwLVK+UuGxQw99PAAkLJ2pTFvp/IGlM0ZNhmDzTxC/FP57aVXwsVDbxC3
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(396003)(376002)(346002)(136003)(451199018)(46966006)(36840700001)(40470700004)(356005)(478600001)(81166007)(2616005)(110136005)(316002)(82310400005)(16526019)(186003)(2906002)(70206006)(82740400003)(8676002)(70586007)(26005)(83380400001)(54906003)(4326008)(86362001)(1076003)(36756003)(44832011)(6666004)(40480700001)(41300700001)(5660300002)(47076005)(36860700001)(336012)(40460700003)(426003)(8936002)(36900700001)(309714004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 18:56:55.4828
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f1360f13-aa3d-48a6-6529-08db2b073502
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT051.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7670
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

An auxiliary_bus device is created for each VF at VF probe and destroyed
at VF remove.  The VFs are always removed on PF remove, so there should
be no issues with VFs trying to access missing PF structures.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/net/ethernet/amd/pds_core/Makefile |   1 +
 drivers/net/ethernet/amd/pds_core/auxbus.c | 137 +++++++++++++++++++++
 drivers/net/ethernet/amd/pds_core/core.h   |   7 ++
 drivers/net/ethernet/amd/pds_core/main.c   |  37 +++++-
 include/linux/pds/pds_auxbus.h             |  16 +++
 include/linux/pds/pds_common.h             |   1 +
 6 files changed, 197 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ethernet/amd/pds_core/auxbus.c
 create mode 100644 include/linux/pds/pds_auxbus.h

diff --git a/drivers/net/ethernet/amd/pds_core/Makefile b/drivers/net/ethernet/amd/pds_core/Makefile
index 6d1d6c58a1fa..0abc33ce826c 100644
--- a/drivers/net/ethernet/amd/pds_core/Makefile
+++ b/drivers/net/ethernet/amd/pds_core/Makefile
@@ -5,6 +5,7 @@ obj-$(CONFIG_PDS_CORE) := pds_core.o
 
 pds_core-y := main.o \
 	      devlink.o \
+	      auxbus.o \
 	      dev.o \
 	      adminq.o \
 	      core.o \
diff --git a/drivers/net/ethernet/amd/pds_core/auxbus.c b/drivers/net/ethernet/amd/pds_core/auxbus.c
new file mode 100644
index 000000000000..cb5bc65ca3c2
--- /dev/null
+++ b/drivers/net/ethernet/amd/pds_core/auxbus.c
@@ -0,0 +1,137 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2023 Advanced Micro Devices, Inc */
+
+#include <linux/pci.h>
+
+#include "core.h"
+#include <linux/pds/pds_auxbus.h>
+
+static void pdsc_auxbus_dev_release(struct device *dev)
+{
+	struct pds_auxiliary_dev *padev =
+		container_of(dev, struct pds_auxiliary_dev, aux_dev.dev);
+
+	kfree(padev);
+}
+
+static struct pds_auxiliary_dev *pdsc_auxbus_dev_register(struct pdsc *vf,
+							  struct pdsc *pf,
+							  char *name)
+{
+	struct auxiliary_device *aux_dev;
+	struct pds_auxiliary_dev *padev;
+	int err;
+
+	padev = kzalloc(sizeof(*padev), GFP_KERNEL);
+	if (!padev)
+		return NULL;
+
+	padev->vf_pdev = vf->pdev;
+	padev->pf_pdev = pf->pdev;
+
+	aux_dev = &padev->aux_dev;
+	aux_dev->name = name;
+	aux_dev->id = vf->id;
+	aux_dev->dev.parent = vf->dev;
+	aux_dev->dev.release = pdsc_auxbus_dev_release;
+
+	err = auxiliary_device_init(aux_dev);
+	if (err < 0) {
+		dev_warn(vf->dev, "auxiliary_device_init of %s id %d failed: %pe\n",
+			 name, vf->id, ERR_PTR(err));
+		goto err_out;
+	}
+
+	err = auxiliary_device_add(aux_dev);
+	if (err) {
+		dev_warn(vf->dev, "auxiliary_device_add of %s id %d failed: %pe\n",
+			 name, vf->id, ERR_PTR(err));
+		auxiliary_device_uninit(aux_dev);
+		goto err_out;
+	}
+
+	return padev;
+
+err_out:
+	kfree(padev);
+	return NULL;
+}
+
+int pdsc_auxbus_dev_del_vf(struct pdsc *vf, struct pdsc *pf)
+{
+	struct pds_auxiliary_dev *padev;
+	int err = 0;
+
+	mutex_lock(&pf->config_lock);
+	if (pf->state) {
+		dev_warn(vf->dev, "%s: PF in a transition state (%lu)\n",
+			 __func__, pf->state);
+		err = -EBUSY;
+	} else if (vf->vf_id >= pf->num_vfs) {
+		dev_warn(vf->dev, "%s: vfid %d out of range\n",
+			 __func__, vf->vf_id);
+		err = -ERANGE;
+	}
+	if (err)
+		goto out_unlock;
+
+	padev = pf->vfs[vf->vf_id].padev;
+	if (padev) {
+		auxiliary_device_delete(&padev->aux_dev);
+		auxiliary_device_uninit(&padev->aux_dev);
+	}
+	pf->vfs[vf->vf_id].padev = NULL;
+
+out_unlock:
+	mutex_unlock(&pf->config_lock);
+	return err;
+}
+
+int pdsc_auxbus_dev_add_vf(struct pdsc *vf, struct pdsc *pf)
+{
+	struct pds_auxiliary_dev *padev;
+	enum pds_core_vif_types vt;
+	int err = 0;
+
+	mutex_lock(&pf->config_lock);
+	if (pf->state) {
+		dev_warn(vf->dev, "%s: PF in a transition state (%lu)\n",
+			 __func__, pf->state);
+		err = -EBUSY;
+	} else if (!pf->vfs) {
+		dev_warn(vf->dev, "%s: PF vfs array not ready\n",
+			 __func__);
+		err = -ENOTTY;
+	} else if (vf->vf_id >= pf->num_vfs) {
+		dev_warn(vf->dev, "%s: vfid %d out of range\n",
+			 __func__, vf->vf_id);
+		err = -ERANGE;
+	} else if (pf->vfs[vf->vf_id].padev) {
+		dev_warn(vf->dev, "%s: vfid %d already running\n",
+			 __func__, vf->vf_id);
+		err = -ENODEV;
+	}
+	if (err)
+		goto out_unlock;
+
+	for (vt = 0; vt < PDS_DEV_TYPE_MAX; vt++) {
+		u16 vt_support;
+
+		/* Verify that the type is supported and enabled */
+		vt_support = !!le16_to_cpu(pf->dev_ident.vif_types[vt]);
+		if (!(vt_support &&
+		      pf->viftype_status[vt].supported &&
+		      pf->viftype_status[vt].enabled))
+			continue;
+
+		padev = pdsc_auxbus_dev_register(vf, pf, pf->viftype_status[vt].name);
+		pf->vfs[vf->vf_id].padev = padev;
+
+		/* We only support a single type per VF, so jump out here */
+		break;
+	}
+
+out_unlock:
+	mutex_unlock(&pf->config_lock);
+	return err;
+}
diff --git a/drivers/net/ethernet/amd/pds_core/core.h b/drivers/net/ethernet/amd/pds_core/core.h
index 97a9b4a6bdfe..9d991c0bca05 100644
--- a/drivers/net/ethernet/amd/pds_core/core.h
+++ b/drivers/net/ethernet/amd/pds_core/core.h
@@ -30,8 +30,11 @@ struct pdsc_dev_bar {
 	int res_index;
 };
 
+struct pdsc;
+
 struct pdsc_vf {
 	struct pds_auxiliary_dev *padev;
+	struct pdsc *vf;
 	u16     index;
 	__le16  vif_types[PDS_DEV_TYPE_MAX];
 };
@@ -240,6 +243,7 @@ static inline void pds_core_dbell_ring(u64 __iomem *db_page,
 	writeq(val, &db_page[qtype]);
 }
 
+void *pdsc_get_pf_struct(struct pci_dev *vf_pdev);
 void pdsc_queue_health_check(struct pdsc *pdsc);
 void __iomem *pdsc_map_dbpage(struct pdsc *pdsc, int page_num);
 
@@ -302,6 +306,9 @@ int pdsc_start(struct pdsc *pdsc);
 void pdsc_stop(struct pdsc *pdsc);
 void pdsc_health_thread(struct work_struct *work);
 
+int pdsc_auxbus_dev_add_vf(struct pdsc *vf, struct pdsc *pf);
+int pdsc_auxbus_dev_del_vf(struct pdsc *vf, struct pdsc *pf);
+
 void pdsc_process_adminq(struct pdsc_qcq *qcq);
 void pdsc_work_thread(struct work_struct *work);
 irqreturn_t pdsc_adminq_isr(int irq, void *data);
diff --git a/drivers/net/ethernet/amd/pds_core/main.c b/drivers/net/ethernet/amd/pds_core/main.c
index 51d7aa67ff68..43e4d8ce6001 100644
--- a/drivers/net/ethernet/amd/pds_core/main.c
+++ b/drivers/net/ethernet/amd/pds_core/main.c
@@ -198,15 +198,36 @@ static int pdsc_sriov_configure(struct pci_dev *pdev, int num_vfs)
 
 static int pdsc_init_vf(struct pdsc *vf)
 {
+	struct pdsc *pf;
 	int err;
 
+	pf = pdsc_get_pf_struct(vf->pdev);
+	if (IS_ERR_OR_NULL(pf))
+		return PTR_ERR(pf) ?: -1;
+
 	vf->vf_id = pci_iov_vf_id(vf->pdev);
 
 	err = pdsc_dl_register(vf);
 	if (err)
 		return err;
 
-	return 0;
+	pf->vfs[vf->vf_id].vf = vf;
+	err = pdsc_auxbus_dev_add_vf(vf, pf);
+	if (err)
+		pdsc_dl_unregister(vf);
+
+	return err;
+}
+
+static void pdsc_del_vf(struct pdsc *vf)
+{
+	struct pdsc *pf;
+
+	pf = pdsc_get_pf_struct(vf->pdev);
+	if (IS_ERR(pf))
+		return;
+	pdsc_auxbus_dev_del_vf(vf, pf);
+	pf->vfs[vf->vf_id].vf = NULL;
 }
 
 #define PDSC_WQ_NAME_LEN 24
@@ -357,7 +378,13 @@ static void pdsc_remove(struct pci_dev *pdev)
 	 */
 	pdsc_dl_unregister(pdsc);
 
-	if (!pdev->is_virtfn) {
+	if (pdev->is_virtfn) {
+		pdsc_del_vf(pdsc);
+	} else {
+		/* Remove the VFs and their aux_bus connections before other
+		 * cleanup so that the clients can use the AdminQ to cleanly
+		 * shut themselves down.
+		 */
 		pdsc_sriov_configure(pdev, 0);
 
 		del_timer_sync(&pdsc->wdtimer);
@@ -397,6 +424,12 @@ static struct pci_driver pdsc_driver = {
 	.sriov_configure = pdsc_sriov_configure,
 };
 
+void *pdsc_get_pf_struct(struct pci_dev *vf_pdev)
+{
+	return pci_iov_get_pf_drvdata(vf_pdev, &pdsc_driver);
+}
+EXPORT_SYMBOL_GPL(pdsc_get_pf_struct);
+
 static int __init pdsc_init_module(void)
 {
 	pdsc_debugfs_create();
diff --git a/include/linux/pds/pds_auxbus.h b/include/linux/pds/pds_auxbus.h
new file mode 100644
index 000000000000..aa0192af4a29
--- /dev/null
+++ b/include/linux/pds/pds_auxbus.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2023 Advanced Micro Devices, Inc */
+
+#ifndef _PDSC_AUXBUS_H_
+#define _PDSC_AUXBUS_H_
+
+#include <linux/auxiliary_bus.h>
+
+struct pds_auxiliary_dev {
+	struct auxiliary_device aux_dev;
+	struct pci_dev *vf_pdev;
+	struct pci_dev *pf_pdev;
+	u16 client_id;
+	void *priv;
+};
+#endif /* _PDSC_AUXBUS_H_ */
diff --git a/include/linux/pds/pds_common.h b/include/linux/pds/pds_common.h
index 350295091d9d..898f3c7b14b7 100644
--- a/include/linux/pds/pds_common.h
+++ b/include/linux/pds/pds_common.h
@@ -91,4 +91,5 @@ enum pds_core_logical_qtype {
 	PDS_CORE_QTYPE_MAX     = 16   /* don't change - used in struct size */
 };
 
+void *pdsc_get_pf_struct(struct pci_dev *vf_pdev);
 #endif /* _PDS_COMMON_H_ */
-- 
2.17.1

