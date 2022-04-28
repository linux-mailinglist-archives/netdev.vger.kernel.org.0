Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4236951329B
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 13:40:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235253AbiD1Lmx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 07:42:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231307AbiD1Lmw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 07:42:52 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D75526C969
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 04:39:37 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id l62-20020a1c2541000000b0038e4570af2fso2851901wml.5
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 04:39:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:references
         :content-language:to:cc:from:in-reply-to:content-transfer-encoding;
        bh=Jwxc7f9tYsq5UrzSrvxux9qT8n8vz/18aQLO/C9sXTc=;
        b=qAFOy+EtyMSnfCM5TNoovKr7vFFIuL0XjTT01SYRaQ6OXuexf993fuqZtMn0pqFflY
         kb5VzW/xXXB8cYD92C751jwok0PbQKEuvMBWVvF2zIDnDxrMW+L/R/P/clH9p8DnHZu0
         0sJvQKuLXcOMn/8BTZIiuGet2fzb3LLXWaudQ+iBCrblJTRRt+Fyw4ay3iN87GygHVIh
         yAPBrSJQ3yI2urDN3CoD3yM6c5c8NXSOV/HIRsnA8DyNqgUYTDOljvyTBuF8xmr1yyHQ
         ZMngxZdi3BNj54YTRBkC7s1OgTzscyZq79AjAnvIpFBapWc6nMIpVSTDCGyXiX7Sk73v
         NAzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :references:content-language:to:cc:from:in-reply-to
         :content-transfer-encoding;
        bh=Jwxc7f9tYsq5UrzSrvxux9qT8n8vz/18aQLO/C9sXTc=;
        b=6hJTIx7LUcwGlMEDj8htXwQjegBdPrLV5YDbyZ+B8t9YsFceoi4oKZUUmHycvx2IFz
         omChPaPKVJgZMDc72HSV0fpElexXBacaKpAdxKXaFQrmKgC3XSGCKjTovPneJHWuPvnd
         p1cHX5QyPqN9FRFWiAu3mKDZG3PCFa25eboAnb0779maqRJK3yarsCsux9j1n5cc8sP9
         BYQuPD+QFtVuOVTED4MvWsz42IodCInar1mA7JgxvzC9niYHR7BLKnpKSOlXjxriO2p6
         0vLOow1fZURwK81THkP+Ty/yV6u86+vqsroeHRsFsvB4zWcoxlMMbH7b2f3vJ1JUXP+O
         O7Fg==
X-Gm-Message-State: AOAM533OTXLNKEn3zy2MhcVD6GZX5W6zC0yuuFKT2whoSrhGQ/iPx6vY
        +Yn+H0AwFToya3ReyONZZDM=
X-Google-Smtp-Source: ABdhPJxrBNM43M3bwC+BogZIxouMrgLXpXoAtBxp4xa1zoxnqxUUjGJ+BfmR5KvEua/0s8bDeZZTSQ==
X-Received: by 2002:a05:600c:4fd0:b0:393:eb2e:fb04 with SMTP id o16-20020a05600c4fd000b00393eb2efb04mr19620894wmq.167.1651145976253;
        Thu, 28 Apr 2022 04:39:36 -0700 (PDT)
Received: from [10.108.8.172] ([149.199.80.128])
        by smtp.gmail.com with ESMTPSA id p14-20020a05600c1d8e00b0038ecb2d2feasm3903277wms.4.2022.04.28.04.39.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Apr 2022 04:39:35 -0700 (PDT)
Message-ID: <75e74d9e-14ce-0524-9668-5ab735a7cf62@gmail.com>
Date:   Thu, 28 Apr 2022 12:39:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: [PATCH net-next] sfc: add EF100 VF support via a write to
 sriov_numvfs
References: <20220426091929.10748-1-pieter.jansen-van-vuuren@amd.com>
Content-Language: en-GB
To:     davem@davemloft.net, pabeni@redhat.com, kuba@kernel.org,
        edumazet@google.com
Cc:     pieter.jansen-van-vuuren@amd.com, netdev@vger.kernel.org,
        habetsm.xilinx@gmail.com
From:   Edward Cree <ecree.xilinx@gmail.com>
In-Reply-To: <20220426091929.10748-1-pieter.jansen-van-vuuren@amd.com>
X-Forwarded-Message-Id: <20220426091929.10748-1-pieter.jansen-van-vuuren@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>

This patch extends the EF100 PF driver by adding .sriov_configure()
which would allow users to enable and disable virtual functions
using the sriov sysfs.

Signed-off-by: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/Makefile      |  2 +-
 drivers/net/ethernet/sfc/ef100.c       | 27 ++++++++++++-
 drivers/net/ethernet/sfc/ef100_nic.c   |  6 ++-
 drivers/net/ethernet/sfc/ef100_sriov.c | 56 ++++++++++++++++++++++++++
 drivers/net/ethernet/sfc/ef100_sriov.h | 14 +++++++
 5 files changed, 102 insertions(+), 3 deletions(-)
 create mode 100644 drivers/net/ethernet/sfc/ef100_sriov.c
 create mode 100644 drivers/net/ethernet/sfc/ef100_sriov.h

diff --git a/drivers/net/ethernet/sfc/Makefile b/drivers/net/ethernet/sfc/Makefile
index 8bd01c429f91..5ba98769b52b 100644
--- a/drivers/net/ethernet/sfc/Makefile
+++ b/drivers/net/ethernet/sfc/Makefile
@@ -8,7 +8,7 @@ sfc-y			+= efx.o efx_common.o efx_channels.o nic.o \
 			   ef100.o ef100_nic.o ef100_netdev.o \
 			   ef100_ethtool.o ef100_rx.o ef100_tx.o
 sfc-$(CONFIG_SFC_MTD)	+= mtd.o
-sfc-$(CONFIG_SFC_SRIOV)	+= sriov.o siena_sriov.o ef10_sriov.o
+sfc-$(CONFIG_SFC_SRIOV)	+= sriov.o siena_sriov.o ef10_sriov.o ef100_sriov.o
 
 obj-$(CONFIG_SFC)	+= sfc.o
 
diff --git a/drivers/net/ethernet/sfc/ef100.c b/drivers/net/ethernet/sfc/ef100.c
index ffdb36715a49..173f0ecebc70 100644
--- a/drivers/net/ethernet/sfc/ef100.c
+++ b/drivers/net/ethernet/sfc/ef100.c
@@ -2,7 +2,7 @@
 /****************************************************************************
  * Driver for Solarflare network controllers and boards
  * Copyright 2005-2018 Solarflare Communications Inc.
- * Copyright 2019-2020 Xilinx Inc.
+ * Copyright 2019-2022 Xilinx Inc.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License version 2 as published
@@ -17,6 +17,7 @@
 #include "io.h"
 #include "ef100_nic.h"
 #include "ef100_netdev.h"
+#include "ef100_sriov.h"
 #include "ef100_regs.h"
 #include "ef100.h"
 
@@ -436,6 +437,10 @@ static void ef100_pci_remove(struct pci_dev *pci_dev)
 	 * blocks, so we have to do it before PCI removal.
 	 */
 	unregister_netdevice_notifier(&efx->netdev_notifier);
+#if defined(CONFIG_SFC_SRIOV)
+	if (!efx->type->is_vf)
+		efx_ef100_pci_sriov_disable(efx);
+#endif
 	ef100_remove(efx);
 	efx_fini_io(efx);
 	netif_dbg(efx, drv, efx->net_dev, "shutdown successful\n");
@@ -524,6 +529,23 @@ static int ef100_pci_probe(struct pci_dev *pci_dev,
 	return rc;
 }
 
+#ifdef CONFIG_SFC_SRIOV
+static int ef100_pci_sriov_configure(struct pci_dev *dev, int num_vfs)
+{
+	struct efx_nic *efx = pci_get_drvdata(dev);
+	int rc;
+
+	if (efx->type->sriov_configure) {
+		rc = efx->type->sriov_configure(efx, num_vfs);
+		if (rc)
+			return rc;
+		else
+			return num_vfs;
+	}
+	return -ENOENT;
+}
+#endif
+
 /* PCI device ID table */
 static const struct pci_device_id ef100_pci_table[] = {
 	{PCI_DEVICE(PCI_VENDOR_ID_XILINX, 0x0100),  /* Riverhead PF */
@@ -538,6 +560,9 @@ struct pci_driver ef100_pci_driver = {
 	.id_table       = ef100_pci_table,
 	.probe          = ef100_pci_probe,
 	.remove         = ef100_pci_remove,
+#ifdef CONFIG_SFC_SRIOV
+	.sriov_configure = ef100_pci_sriov_configure,
+#endif
 	.err_handler    = &efx_err_handlers,
 };
 
diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index a07cbf45a326..b04911bc8c57 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -2,7 +2,7 @@
 /****************************************************************************
  * Driver for Solarflare network controllers and boards
  * Copyright 2018 Solarflare Communications Inc.
- * Copyright 2019-2020 Xilinx Inc.
+ * Copyright 2019-2022 Xilinx Inc.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License version 2 as published
@@ -22,6 +22,7 @@
 #include "mcdi_filters.h"
 #include "ef100_rx.h"
 #include "ef100_tx.h"
+#include "ef100_sriov.h"
 #include "ef100_netdev.h"
 #include "rx_common.h"
 
@@ -787,6 +788,9 @@ const struct efx_nic_type ef100_pf_nic_type = {
 	.update_stats = ef100_update_stats,
 	.pull_stats = efx_mcdi_mac_pull_stats,
 	.stop_stats = efx_mcdi_mac_stop_stats,
+#ifdef CONFIG_SFC_SRIOV
+	.sriov_configure = efx_ef100_sriov_configure,
+#endif
 
 	/* Per-type bar/size configuration not used on ef100. Location of
 	 * registers is defined by extended capabilities.
diff --git a/drivers/net/ethernet/sfc/ef100_sriov.c b/drivers/net/ethernet/sfc/ef100_sriov.c
new file mode 100644
index 000000000000..664578176bfe
--- /dev/null
+++ b/drivers/net/ethernet/sfc/ef100_sriov.c
@@ -0,0 +1,56 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/****************************************************************************
+ * Driver for Solarflare network controllers and boards
+ * Copyright 2019 Solarflare Communications Inc.
+ * Copyright 2020-2022 Xilinx Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation, incorporated herein by reference.
+ */
+
+#include "ef100_sriov.h"
+#include "ef100_nic.h"
+
+static int efx_ef100_pci_sriov_enable(struct efx_nic *efx, int num_vfs)
+{
+	struct pci_dev *dev = efx->pci_dev;
+	int rc;
+
+	efx->vf_count = num_vfs;
+	rc = pci_enable_sriov(dev, num_vfs);
+	if (rc)
+		goto fail;
+
+	return 0;
+
+fail:
+	netif_err(efx, probe, efx->net_dev, "Failed to enable SRIOV VFs\n");
+	efx->vf_count = 0;
+	return rc;
+}
+
+int efx_ef100_pci_sriov_disable(struct efx_nic *efx)
+{
+	struct pci_dev *dev = efx->pci_dev;
+	unsigned int vfs_assigned;
+
+	vfs_assigned = pci_vfs_assigned(dev);
+	if (vfs_assigned) {
+		netif_info(efx, drv, efx->net_dev, "VFs are assigned to guests; "
+			   "please detach them before disabling SR-IOV\n");
+		return -EBUSY;
+	}
+
+	pci_disable_sriov(dev);
+
+	return 0;
+}
+
+int efx_ef100_sriov_configure(struct efx_nic *efx, int num_vfs)
+{
+	if (num_vfs == 0)
+		return efx_ef100_pci_sriov_disable(efx);
+	else
+		return efx_ef100_pci_sriov_enable(efx, num_vfs);
+}
diff --git a/drivers/net/ethernet/sfc/ef100_sriov.h b/drivers/net/ethernet/sfc/ef100_sriov.h
new file mode 100644
index 000000000000..c48fccd46c57
--- /dev/null
+++ b/drivers/net/ethernet/sfc/ef100_sriov.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/****************************************************************************
+ * Driver for Solarflare network controllers and boards
+ * Copyright 2019 Solarflare Communications Inc.
+ * Copyright 2020-2022 Xilinx Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation, incorporated herein by reference.
+ */
+#include "net_driver.h"
+
+int efx_ef100_sriov_configure(struct efx_nic *efx, int num_vfs);
+int efx_ef100_pci_sriov_disable(struct efx_nic *efx);
-- 
2.17.1

