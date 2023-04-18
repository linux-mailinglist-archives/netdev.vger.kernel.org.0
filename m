Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB4896E55EB
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 02:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbjDRAdg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 20:33:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbjDRAdK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 20:33:10 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2086.outbound.protection.outlook.com [40.107.94.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28B594EEE
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 17:33:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RXlUpFjEgbWknUZ+XIWM5X/nYJpkWdkoBYYkBO3VxA48H9azWleqCRxlxQeUYFlYvSyORrmzHF5BKbrOU90MyAFfaJvwfyrA5lJaR3PFbWousdtB0JSVLsRhCXe0PzvW8xn8SFs2/PJfP7pBMcpORNtG8inc0kv1j0GTsvA6QXmmpoQwAzv6iYUP91jVCgnunLL/YyihoyHR3v2PMdFfNiwwCz5OT+qsJjEQTBK1cIKLo9ipaJQ9abuyPvwQPc/lGwGb+L28rWZhCrWa6SaRG2A3ScJ2EpjeMNdeYKH7B2E225ksJ0S8NDi7ZZQIbiQ2jHf42mLIlcAfDWyRXoYp9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CUaFhmTAVqhgiaC8dkC3lwauBSRKwPTQSHuthc/GZbI=;
 b=CImQT0mSY6LxZEYjKrPajTZpIFCZVMJpZrtXz0py2j7ldSQTJbmaDYENjO+kSzfjCcA5u3t/2ukVTmHGFr4NtFfdYxHGShHICIikios6opp1lJn3O5ePANGat10QTFlj7Kbi7/nOpbeg0w063cNoX0xpfZPK0KxikC7mQv3sGgsubfpoEu28YyrcoHEnjCT8LB4wSd6ggAgVMmGEdIPoNIQOavJk29HXvIBYtAZaeqz4rIxSzcq6JHwzmEefo//TYJ1hvYDOZbKQHyI7NgPnh5DfqwnWxRX8MmdB5MI8wEr/Ts5oiHfL5MbnCbkMidfDsdu204jemSd5lC7po5tuwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CUaFhmTAVqhgiaC8dkC3lwauBSRKwPTQSHuthc/GZbI=;
 b=ouEi6JbZfUdimBubN8hxQXuuUBVGfOM0BfXlpnr+HHuG0gkkDpQak6M+PBygGJKserzcfwqRKo3E7mqKwt8IFvQW87uIwSsEGvFMMYE8nqnbdZ5G5rMeQsQLq8hwSKEmYxsdwWctp1jBgavaQ6bZBINCMomyxRffOPpcLE3WKJM=
Received: from BN9PR03CA0624.namprd03.prod.outlook.com (2603:10b6:408:106::29)
 by DM4PR12MB5085.namprd12.prod.outlook.com (2603:10b6:5:388::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 00:33:04 +0000
Received: from BN8NAM11FT068.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:106:cafe::56) by BN9PR03CA0624.outlook.office365.com
 (2603:10b6:408:106::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.46 via Frontend
 Transport; Tue, 18 Apr 2023 00:33:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT068.mail.protection.outlook.com (10.13.177.69) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6319.20 via Frontend Transport; Tue, 18 Apr 2023 00:33:03 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 17 Apr
 2023 19:33:02 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <leon@kernel.org>, <jiri@resnulli.us>,
        <simon.horman@corigine.com>
Subject: [PATCH v10 net-next 10/14] pds_core: add auxiliary_bus devices
Date:   Mon, 17 Apr 2023 17:32:24 -0700
Message-ID: <20230418003228.28234-11-shannon.nelson@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN8NAM11FT068:EE_|DM4PR12MB5085:EE_
X-MS-Office365-Filtering-Correlation-Id: be765186-60e1-4255-8b9a-08db3fa478f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qJn6QIp9BZuovlli5gr0HIdEOVAT4I/1s+SQ0Wp75qOz807rdv3/vrAoteypznFNiY8TCTiGGfswXtxhRKAt/+WbW/C4M3Flf9JfzgaCB19qnXWIyi1iW/8verqRJdU9Og3W9lPx5urKHkgOKp7Bd5F5ocBj3tebaYjdyBpXcVypXL1wo52FunFzuzEjLYgh+PT3G3Um8VMWgoS8fk8OApwGqtWPZK6UazNo4XKUycTmRRK4uXXp3S5SrvAfRQPBHu0zatllps1M8TClhJze0/LPFeMWrwKUseskXScnFkJIOBKAK+x/c0K0lYiVXddLO2D7JPh6/9BKuwGJ+djhkqcP0jw7hMPBtU8jbGbdlKTA1oghppluv4eQVHxBiDZOf14ciwx7TW/kNki1OEr09Mt5BRWZgznhmr8yqZPpS8wmH3+4K6h//A8YAPsdSra8EN86mzRGvymsVTd/mP6diSQopqO5+IK/ydoeoNTEvLByAlXxDibg36tqTkcNwqrfGm3RdUxYJiKmzB6278HZziZiOZrVdZp4o5jsfqtd6tAGnI7WKounwk6Gf6gjjsbzNCcRi1Rdn13/AITo11OaFJAedfI1SOKvx5+Hhcs3Q83Yp0kyRAguPM3c4ULUNQgueOPetNNQ/ueHPeII6kWKtacQTaVnlNlldazROOKuKQauw+ncY3uR8/kGlWAv+I5NfmA7ncvvwYW4N8IP5EAz3S7qEqx9mx23c7pbfwIP0Cj+guwZhtE2suoO7os6lbLc
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(346002)(376002)(39860400002)(451199021)(36840700001)(46966006)(40470700004)(5660300002)(44832011)(86362001)(2616005)(426003)(336012)(82310400005)(47076005)(83380400001)(16526019)(186003)(1076003)(81166007)(356005)(82740400003)(26005)(40480700001)(36860700001)(8676002)(8936002)(478600001)(54906003)(110136005)(6666004)(316002)(41300700001)(40460700003)(36756003)(4326008)(70586007)(70206006)(2906002)(36900700001)(309714004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2023 00:33:03.9394
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: be765186-60e1-4255-8b9a-08db3fa478f9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT068.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5085
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

An auxiliary_bus device is created for each vDPA type VF at VF
probe and destroyed at VF remove.  The aux device name comes
from the driver name + VIF type + the unique id assigned at PCI
probe.  The VFs are always removed on PF remove, so there should
be no issues with VFs trying to access missing PF structures.

The auxiliary_device names will look like "pds_core.vDPA.nn"
where 'nn' is the VF's uid.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Acked-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/amd/pds_core/Makefile |   1 +
 drivers/net/ethernet/amd/pds_core/auxbus.c | 115 +++++++++++++++++++++
 drivers/net/ethernet/amd/pds_core/core.h   |   6 ++
 drivers/net/ethernet/amd/pds_core/main.c   |  36 ++++++-
 include/linux/pds/pds_auxbus.h             |  14 +++
 include/linux/pds/pds_common.h             |   1 +
 6 files changed, 171 insertions(+), 2 deletions(-)
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
index 000000000000..adee516b3f0c
--- /dev/null
+++ b/drivers/net/ethernet/amd/pds_core/auxbus.c
@@ -0,0 +1,115 @@
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
+static struct pds_auxiliary_dev *pdsc_auxbus_dev_register(struct pdsc *cf,
+							  struct pdsc *pf,
+							  char *name)
+{
+	struct auxiliary_device *aux_dev;
+	struct pds_auxiliary_dev *padev;
+	int err;
+
+	padev = kzalloc(sizeof(*padev), GFP_KERNEL);
+	if (!padev)
+		return ERR_PTR(-ENOMEM);
+
+	padev->vf_pdev = cf->pdev;
+
+	aux_dev = &padev->aux_dev;
+	aux_dev->name = name;
+	aux_dev->id = cf->uid;
+	aux_dev->dev.parent = cf->dev;
+	aux_dev->dev.release = pdsc_auxbus_dev_release;
+
+	err = auxiliary_device_init(aux_dev);
+	if (err < 0) {
+		dev_warn(cf->dev, "auxiliary_device_init of %s failed: %pe\n",
+			 name, ERR_PTR(err));
+		goto err_out;
+	}
+
+	err = auxiliary_device_add(aux_dev);
+	if (err) {
+		dev_warn(cf->dev, "auxiliary_device_add of %s failed: %pe\n",
+			 name, ERR_PTR(err));
+		goto err_out_uninit;
+	}
+
+	return padev;
+
+err_out_uninit:
+	auxiliary_device_uninit(aux_dev);
+err_out:
+	kfree(padev);
+	return ERR_PTR(err);
+}
+
+int pdsc_auxbus_dev_del(struct pdsc *cf, struct pdsc *pf)
+{
+	struct pds_auxiliary_dev *padev;
+	int err = 0;
+
+	mutex_lock(&pf->config_lock);
+
+	padev = pf->vfs[cf->vf_id].padev;
+	if (padev) {
+		auxiliary_device_delete(&padev->aux_dev);
+		auxiliary_device_uninit(&padev->aux_dev);
+	}
+	pf->vfs[cf->vf_id].padev = NULL;
+
+	mutex_unlock(&pf->config_lock);
+	return err;
+}
+
+int pdsc_auxbus_dev_add(struct pdsc *cf, struct pdsc *pf)
+{
+	struct pds_auxiliary_dev *padev;
+	enum pds_core_vif_types vt;
+	u16 vt_support;
+	int err = 0;
+
+	mutex_lock(&pf->config_lock);
+
+	/* We only support vDPA so far, so it is the only one to
+	 * be verified that it is available in the Core device and
+	 * enabled in the devlink param.  In the future this might
+	 * become a loop for several VIF types.
+	 */
+
+	/* Verify that the type is supported and enabled.  It is not
+	 * an error if there is no auxbus device support for this
+	 * VF, it just means something else needs to happen with it.
+	 */
+	vt = PDS_DEV_TYPE_VDPA;
+	vt_support = !!le16_to_cpu(pf->dev_ident.vif_types[vt]);
+	if (!(vt_support &&
+	      pf->viftype_status[vt].supported &&
+	      pf->viftype_status[vt].enabled))
+		goto out_unlock;
+
+	padev = pdsc_auxbus_dev_register(cf, pf,
+					 pf->viftype_status[vt].name);
+	if (IS_ERR(padev)) {
+		err = PTR_ERR(padev);
+		goto out_unlock;
+	}
+	pf->vfs[cf->vf_id].padev = padev;
+
+out_unlock:
+	mutex_unlock(&pf->config_lock);
+	return err;
+}
diff --git a/drivers/net/ethernet/amd/pds_core/core.h b/drivers/net/ethernet/amd/pds_core/core.h
index 1ec8784773f1..36099d3ac3dd 100644
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
@@ -287,6 +290,9 @@ int pdsc_start(struct pdsc *pdsc);
 void pdsc_stop(struct pdsc *pdsc);
 void pdsc_health_thread(struct work_struct *work);
 
+int pdsc_auxbus_dev_add(struct pdsc *cf, struct pdsc *pf);
+int pdsc_auxbus_dev_del(struct pdsc *cf, struct pdsc *pf);
+
 void pdsc_process_adminq(struct pdsc_qcq *qcq);
 void pdsc_work_thread(struct work_struct *work);
 irqreturn_t pdsc_adminq_isr(int irq, void *data);
diff --git a/drivers/net/ethernet/amd/pds_core/main.c b/drivers/net/ethernet/amd/pds_core/main.c
index 511cb91a295e..b848f3360fe2 100644
--- a/drivers/net/ethernet/amd/pds_core/main.c
+++ b/drivers/net/ethernet/amd/pds_core/main.c
@@ -169,6 +169,12 @@ static int pdsc_sriov_configure(struct pci_dev *pdev, int num_vfs)
 static int pdsc_init_vf(struct pdsc *vf)
 {
 	struct devlink *dl;
+	struct pdsc *pf;
+	int err;
+
+	pf = pdsc_get_pf_struct(vf->pdev);
+	if (IS_ERR_OR_NULL(pf))
+		return PTR_ERR(pf) ?: -1;
 
 	vf->vf_id = pci_iov_vf_id(vf->pdev);
 
@@ -177,7 +183,15 @@ static int pdsc_init_vf(struct pdsc *vf)
 	devl_register(dl);
 	devl_unlock(dl);
 
-	return 0;
+	pf->vfs[vf->vf_id].vf = vf;
+	err = pdsc_auxbus_dev_add(vf, pf);
+	if (err) {
+		devl_lock(dl);
+		devl_unregister(dl);
+		devl_unlock(dl);
+	}
+
+	return err;
 }
 
 static const struct devlink_health_reporter_ops pdsc_fw_reporter_ops = {
@@ -365,7 +379,19 @@ static void pdsc_remove(struct pci_dev *pdev)
 	}
 	devl_unlock(dl);
 
-	if (!pdev->is_virtfn) {
+	if (pdev->is_virtfn) {
+		struct pdsc *pf;
+
+		pf = pdsc_get_pf_struct(pdsc->pdev);
+		if (!IS_ERR(pf)) {
+			pdsc_auxbus_dev_del(pdsc, pf);
+			pf->vfs[pdsc->vf_id].vf = NULL;
+		}
+	} else {
+		/* Remove the VFs and their aux_bus connections before other
+		 * cleanup so that the clients can use the AdminQ to cleanly
+		 * shut themselves down.
+		 */
 		pdsc_sriov_configure(pdev, 0);
 
 		del_timer_sync(&pdsc->wdtimer);
@@ -402,6 +428,12 @@ static struct pci_driver pdsc_driver = {
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
 	if (strcmp(KBUILD_MODNAME, PDS_CORE_DRV_NAME))
diff --git a/include/linux/pds/pds_auxbus.h b/include/linux/pds/pds_auxbus.h
new file mode 100644
index 000000000000..493f75b1995e
--- /dev/null
+++ b/include/linux/pds/pds_auxbus.h
@@ -0,0 +1,14 @@
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
+	u16 client_id;
+};
+#endif /* _PDSC_AUXBUS_H_ */
diff --git a/include/linux/pds/pds_common.h b/include/linux/pds/pds_common.h
index b2be14ebadb6..961b3d02c69f 100644
--- a/include/linux/pds/pds_common.h
+++ b/include/linux/pds/pds_common.h
@@ -60,4 +60,5 @@ enum pds_core_logical_qtype {
 	PDS_CORE_QTYPE_MAX     = 16   /* don't change - used in struct size */
 };
 
+void *pdsc_get_pf_struct(struct pci_dev *vf_pdev);
 #endif /* _PDS_COMMON_H_ */
-- 
2.17.1

