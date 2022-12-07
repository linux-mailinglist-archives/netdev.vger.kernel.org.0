Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86712645094
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 01:46:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbiLGApz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 19:45:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbiLGAp0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 19:45:26 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2043.outbound.protection.outlook.com [40.107.93.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C00E4D5E9
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 16:45:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YG2i5Fl/2BL2emhHRm+X27Lq+ZDDiheN6Oy4cU5LR1z8pZpwc8BKTGSvLQi/ethhZZc9ogGftbycMS9nI2iW9OxRYrzo0yvF7Q/4RzNrxrFF070NCenFnugZ60q1nfmC4t2ISqwrBPfw0FxWr5vKY+kAHde2f50uL9YUQffEJd7KPow74sRZZp6geisToz2ZKTaSqB9bLcGLbGk0WWv32gAl/FJg1S1qkrqgeXjW9F5SgMR/iJz66rNqOgGi7D+/4jlPrmbIU6TZW0Sp8oPn8e4/5rhmOgrA6rb3ib9LwhGqrUQ0iLPKgXCtQdsH0xymshTSpn+KZCkPaz0Bvu7U5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FJ0jN4lv/NuWpsMgTPdamEJkZW+f8y6P/ofrQL0aEwI=;
 b=Ucg9UPauscGADQrY5ARud8vP7KamijEdxWGGUjhvjChLGHAEAbMiD3uthCahoTsIu13H5sgdBN/1NkpiLSVXozIKYeCJb1Z+IMcVT80QeWFHq41affBXb3smANCyNWocYUPIlql1m7qDBKxazS6SL97IQsjR20PWiRles+YYrQ0/7TyflOcMDtdA06fwzIA0wdH71iW3w1iMRZY/fVvKy7xfrpgbBKnzPfuZemAtYqI5Hwu3UGmzvr9UmBfs7+lsmTiYk0YLMuK5jc+u1+UciSzTaAtnGuGSjlihPX57WMc6vd3lEwEKcbEDG+WDJmLrNU4Sp4ieRm31K6t0PfS+rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FJ0jN4lv/NuWpsMgTPdamEJkZW+f8y6P/ofrQL0aEwI=;
 b=2C4dtTBDPn4uGQ/XtkgXtyaRIes4Hc6Larg3t2KF8il8JzBhhYd3o1DhTnrsVNHf/+I8W2tskaaEHttA6SwO6pk209TeaPkv2x4TK4ZPomY02aORuhnfK7zJU55s5IBmLzWYPnTk9BON8uLpdQ1g427DG7Cs372iVGLkzZfkFxg=
Received: from BN9PR03CA0132.namprd03.prod.outlook.com (2603:10b6:408:fe::17)
 by DM6PR12MB4332.namprd12.prod.outlook.com (2603:10b6:5:21e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Wed, 7 Dec
 2022 00:45:15 +0000
Received: from BN8NAM11FT073.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fe:cafe::84) by BN9PR03CA0132.outlook.office365.com
 (2603:10b6:408:fe::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14 via Frontend
 Transport; Wed, 7 Dec 2022 00:45:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT073.mail.protection.outlook.com (10.13.177.231) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5901.14 via Frontend Transport; Wed, 7 Dec 2022 00:45:13 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 6 Dec
 2022 18:45:12 -0600
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, Shannon Nelson <shannon.nelson@amd.com>
Subject: [PATCH v2 net-next 12/16] pds_core: add auxiliary_bus devices
Date:   Tue, 6 Dec 2022 16:44:39 -0800
Message-ID: <20221207004443.33779-13-shannon.nelson@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN8NAM11FT073:EE_|DM6PR12MB4332:EE_
X-MS-Office365-Filtering-Correlation-Id: e216ae8d-2e0f-4f3c-d890-08dad7ec4d39
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wbzugpMAsVu+wWfekI/ml45o1Aqd3GK4OAf/c7k6ViTqy5dVGzXjaZ7FWJtTW12RyRUonasy41MfFhco3o3piJCq9JUsvsr8wQnmiSYbKpVyIY6aaNIws7oXQ1OjT1uJGdhcKaBbEow9YQoHoWAhVG5hFXigjhN6NXS8NVpiiMpkXyHTBfCR1e19/ptpoxFiMEffD26aqePUhhDqwGlotNEKhx8YNZZhn//mLeCkagBZSHw6eZJ2OdWig4rrXZ0gQ7tPUPzp8v0kPaSBmEABUoKdumOHcX1PSt2wRszJz5sA/Uo2jurykZm+xaM7gRn7VBqZMGRnBx+nGrIgReZ8wNMZsOP5DQ6F/n9GKS5FHecO1l6NIca4GW/er75/I/sf7HKn0fmfeaYw533k1HJcccI3mvdkkJALwog76eNY/KIIuXVPDstaAi7oNLWO/QI+nOvb0G64JuOWmQ5+s3i4rKN4hx6n5UHCJ8sr96fM7Qus4o3XZW0NCs+ssuhuFKX2zg3I0G6lL6duxP2SA0VWVL6AA0ME6uiBk7CjggotIt7lVAz046cF2WAgoN9qBkphNEO3p3AmGUW6J/U6Vu9RtT1zdX65aN1sVLUj0ySpTd2DpKfKpws9tHL83Z82Re7ipVHEkQIYjr1u19lrYPUrevUytYsfjkHYV8f1GsaJeyXLukBnp4pkP9YobN7tyCNA6BCT5IlfvQ4xV5voH9ionJotX4+enqBfKV8gStHbCyL07OHektEs6OebzoD5npW+5CKDzWNTJ2oILdOyLyr1BA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(376002)(396003)(346002)(451199015)(40470700004)(36840700001)(46966006)(2616005)(1076003)(26005)(110136005)(186003)(336012)(16526019)(36860700001)(316002)(83380400001)(6666004)(4326008)(40460700003)(8676002)(82310400005)(41300700001)(356005)(44832011)(2906002)(478600001)(82740400003)(70206006)(70586007)(426003)(47076005)(81166007)(36756003)(54906003)(8936002)(5660300002)(40480700001)(86362001)(36900700001)(309714004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 00:45:13.3768
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e216ae8d-2e0f-4f3c-d890-08dad7ec4d39
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT073.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4332
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

An auxiliary_bus device is created for each VF, and the device
name is made up of the PF driver name, VIF name, and PCI BDF
of the VF.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 .../net/ethernet/pensando/pds_core/Makefile   |   1 +
 .../net/ethernet/pensando/pds_core/auxbus.c   | 123 ++++++++++++++++++
 drivers/net/ethernet/pensando/pds_core/core.h |   3 +
 drivers/net/ethernet/pensando/pds_core/main.c |  19 +++
 include/linux/pds/pds_auxbus.h                |  37 ++++++
 5 files changed, 183 insertions(+)
 create mode 100644 drivers/net/ethernet/pensando/pds_core/auxbus.c
 create mode 100644 include/linux/pds/pds_auxbus.h

diff --git a/drivers/net/ethernet/pensando/pds_core/Makefile b/drivers/net/ethernet/pensando/pds_core/Makefile
index 06bd3da8c38b..c8b9208d2c0d 100644
--- a/drivers/net/ethernet/pensando/pds_core/Makefile
+++ b/drivers/net/ethernet/pensando/pds_core/Makefile
@@ -5,6 +5,7 @@ obj-$(CONFIG_PDS_CORE) := pds_core.o
 
 pds_core-y := main.o \
 	      devlink.o \
+	      auxbus.o \
 	      dev.o \
 	      adminq.o \
 	      core.o \
diff --git a/drivers/net/ethernet/pensando/pds_core/auxbus.c b/drivers/net/ethernet/pensando/pds_core/auxbus.c
new file mode 100644
index 000000000000..331944a4d1a0
--- /dev/null
+++ b/drivers/net/ethernet/pensando/pds_core/auxbus.c
@@ -0,0 +1,123 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2022 Pensando Systems, Inc */
+
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/errno.h>
+#include <linux/pci.h>
+
+#include "core.h"
+
+#include <linux/pds/pds_adminq.h>
+#include <linux/pds/pds_auxbus.h>
+
+static void pdsc_auxbus_dev_release(struct device *dev)
+{
+	struct pds_auxiliary_dev *padev =
+		container_of(dev, struct pds_auxiliary_dev, aux_dev.dev);
+
+	devm_kfree(dev->parent, padev);
+}
+
+static struct pds_auxiliary_dev *pdsc_auxbus_dev_register(struct pdsc *pdsc,
+							  char *name, u32 id,
+							  struct pci_dev *client_dev)
+{
+	struct auxiliary_device *aux_dev;
+	struct pds_auxiliary_dev *padev;
+	int err;
+
+	padev = devm_kzalloc(pdsc->dev, sizeof(*padev), GFP_KERNEL);
+	if (!padev)
+		return NULL;
+
+	padev->pcidev = client_dev;
+
+	aux_dev = &padev->aux_dev;
+	aux_dev->name = name;
+	aux_dev->id = id;
+	padev->id = id;
+	aux_dev->dev.parent = pdsc->dev;
+	aux_dev->dev.release = pdsc_auxbus_dev_release;
+
+	err = auxiliary_device_init(aux_dev);
+	if (err < 0) {
+		dev_warn(pdsc->dev, "auxiliary_device_init of %s id %d failed: %pe\n",
+			 name, id, ERR_PTR(err));
+		goto err_out;
+	}
+
+	err = auxiliary_device_add(aux_dev);
+	if (err) {
+		auxiliary_device_uninit(aux_dev);
+		dev_warn(pdsc->dev, "auxiliary_device_add of %s id %d failed: %pe\n",
+			 name, id, ERR_PTR(err));
+		goto err_out;
+	}
+
+	dev_dbg(pdsc->dev, "%s: name %s id %d pdsc %p\n",
+		__func__, padev->aux_dev.name, id, pdsc);
+
+	return padev;
+
+err_out:
+	devm_kfree(pdsc->dev, padev);
+	return NULL;
+}
+
+int pdsc_auxbus_dev_add_vf(struct pdsc *pdsc, int vf_id)
+{
+	struct pds_auxiliary_dev *padev;
+	enum pds_core_vif_types vt;
+	int err = 0;
+
+	if (!pdsc->vfs)
+		return -ENOTTY;
+
+	if (vf_id >= pdsc->num_vfs)
+		return -ERANGE;
+
+	if (pdsc->vfs[vf_id].padev) {
+		dev_info(pdsc->dev, "%s: vfid %d already running\n", __func__, vf_id);
+		return -ENODEV;
+	}
+
+	for (vt = 0; vt < PDS_DEV_TYPE_MAX; vt++) {
+		u16 vt_support;
+		u32 id;
+
+		/* Verify that the type supported and enabled */
+		vt_support = !!le16_to_cpu(pdsc->dev_ident.vif_types[vt]);
+		if (!(vt_support &&
+		      pdsc->viftype_status[vt].supported &&
+		      pdsc->viftype_status[vt].enabled))
+			continue;
+
+		id = PCI_DEVID(pdsc->pdev->bus->number,
+			       pci_iov_virtfn_devfn(pdsc->pdev, vf_id));
+		padev = pdsc_auxbus_dev_register(pdsc, pdsc->viftype_status[vt].name, id,
+						 pdsc->pdev);
+		pdsc->vfs[vf_id].padev = padev;
+
+		/* We only support a single type per VF, so jump out here */
+		break;
+	}
+
+	return err;
+}
+
+int pdsc_auxbus_dev_del_vf(struct pdsc *pdsc, int vf_id)
+{
+	struct pds_auxiliary_dev *padev;
+
+	dev_info(pdsc->dev, "%s: vfid %d\n", __func__, vf_id);
+
+	padev = pdsc->vfs[vf_id].padev;
+	pdsc->vfs[vf_id].padev = NULL;
+	if (padev) {
+		auxiliary_device_delete(&padev->aux_dev);
+		auxiliary_device_uninit(&padev->aux_dev);
+	}
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/pensando/pds_core/core.h b/drivers/net/ethernet/pensando/pds_core/core.h
index 83a7f7ebcc4b..dbf1fe5135ad 100644
--- a/drivers/net/ethernet/pensando/pds_core/core.h
+++ b/drivers/net/ethernet/pensando/pds_core/core.h
@@ -302,6 +302,9 @@ int pdsc_start(struct pdsc *pdsc);
 void pdsc_stop(struct pdsc *pdsc);
 void pdsc_health_thread(struct work_struct *work);
 
+int pdsc_auxbus_dev_add_vf(struct pdsc *pdsc, int vf_id);
+int pdsc_auxbus_dev_del_vf(struct pdsc *pdsc, int vf_id);
+
 void pdsc_process_adminq(struct pdsc_qcq *qcq);
 void pdsc_work_thread(struct work_struct *work);
 irqreturn_t pdsc_adminq_isr(int irq, void *data);
diff --git a/drivers/net/ethernet/pensando/pds_core/main.c b/drivers/net/ethernet/pensando/pds_core/main.c
index 1ff63a4339d8..b3418e32da63 100644
--- a/drivers/net/ethernet/pensando/pds_core/main.c
+++ b/drivers/net/ethernet/pensando/pds_core/main.c
@@ -169,7 +169,10 @@ static int pdsc_sriov_configure(struct pci_dev *pdev, int num_vfs)
 {
 	struct pdsc *pdsc = pci_get_drvdata(pdev);
 	struct device *dev = pdsc->dev;
+	enum pds_core_vif_types vt;
+	bool enabled = false;
 	int ret = 0;
+	int i;
 
 	if (num_vfs > 0) {
 		pdsc->vfs = kcalloc(num_vfs, sizeof(struct pdsc_vf), GFP_KERNEL);
@@ -183,9 +186,21 @@ static int pdsc_sriov_configure(struct pci_dev *pdev, int num_vfs)
 			goto no_vfs;
 		}
 
+		/* If any VF types are enabled, start the VF aux devices */
+		for (vt = 0; vt < PDS_DEV_TYPE_MAX && !enabled; vt++)
+			enabled = pdsc->viftype_status[vt].supported &&
+				  pdsc->viftype_status[vt].enabled;
+		if (enabled)
+			for (i = 0; i < num_vfs; i++)
+				pdsc_auxbus_dev_add_vf(pdsc, i);
+
 		return num_vfs;
 	}
 
+	i = pci_num_vf(pdev);
+	while (i--)
+		pdsc_auxbus_dev_del_vf(pdsc, i);
+
 no_vfs:
 	pci_disable_sriov(pdev);
 
@@ -332,6 +347,10 @@ static void pdsc_remove(struct pci_dev *pdev)
 	 */
 	pdsc_dl_unregister(pdsc);
 
+	/* Remove the VFs and their aux_bus connections before other
+	 * cleanup so that the clients can use the AdminQ to cleanly
+	 * shut themselves down.
+	 */
 	pdsc_sriov_configure(pdev, 0);
 
 	/* Now we can lock it up and tear it down */
diff --git a/include/linux/pds/pds_auxbus.h b/include/linux/pds/pds_auxbus.h
new file mode 100644
index 000000000000..7ad66d726b01
--- /dev/null
+++ b/include/linux/pds/pds_auxbus.h
@@ -0,0 +1,37 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2022 Pensando Systems, Inc */
+
+
+#ifndef _PDSC_AUXBUS_H_
+#define _PDSC_AUXBUS_H_
+
+#include <linux/auxiliary_bus.h>
+
+struct pds_auxiliary_dev;
+
+struct pds_auxiliary_drv {
+
+	/* .event_handler() - callback for receiving events
+	 * padev:  ptr to the client device info
+	 * event:  ptr to event data
+	 * The client can provide an event handler callback that can
+	 * receive DSC events.  The Core driver may generate its
+	 * own events which can notify the client of changes in the
+	 * DSC status, such as a RESET event generated when the Core
+	 * has lost contact with the FW - in this case the event.eid
+	 * field will be 0.
+	 */
+	void (*event_handler)(struct pds_auxiliary_dev *padev,
+			      union pds_core_notifyq_comp *event);
+};
+
+struct pds_auxiliary_dev {
+	struct auxiliary_device aux_dev;
+	struct pci_dev *pcidev;
+	u32 id;
+	u16 client_id;
+	void (*event_handler)(struct pds_auxiliary_dev *padev,
+			      union pds_core_notifyq_comp *event);
+	void *priv;
+};
+#endif /* _PDSC_AUXBUS_H_ */
-- 
2.17.1

