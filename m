Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43C406302B4
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 00:14:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbiKRXOT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 18:14:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235382AbiKRXNN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 18:13:13 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A91E5C6897
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 14:57:52 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id jn7so3952964plb.13
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 14:57:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Sa4g7JEJTlMMkz+etsgwaIWDb2cyAuNszgwvThHqFYE=;
        b=zUKfQ0AMdjrj9rvHLQxL7eI8CNXe8f4EkHDz+LWIxrfQ8wKZVvvKuvit/mwVKDix7j
         gmsc8+NoBAuXRMDiA17i6wNKG/qMethXPbaALlmXqUrcGKeJte+Kq2Ecagp9V34eoHYL
         CqhNB/mgA762rS2GgZuBW6g49ODRocqSVrN+bgMcoCOZr3JUXltmJ8wDk8q8JCjUk6oM
         COKdq3TvOm3UlZX4WnUZOK0P1EmwjZahkkwwy8FxAVdmTF1Ah7kNysq4O2G/TrclK8qu
         yy9GJUANvyQzOCsO2BCqk2YYFKLg86PHGU6pSwHyKRs/PvU7RVg0HK9RccGFpNix0ps9
         olwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Sa4g7JEJTlMMkz+etsgwaIWDb2cyAuNszgwvThHqFYE=;
        b=ISiGndnXJxU7nYfw3SQAhEAP5jri516tdN/+crvHYtSBIqlye040rpo0rQWlgzZsCZ
         W7ryQD4sd5e+iqdOLWys8cwB1KrBTi3+C6DIzcqZjkdCQGCJETkL5Z74CkDmGarDzc8M
         avdncqzoZF6oPCsnmHETeU9AGu4WEwx6BOx+H+zhavs53Y57C/JeURw02OoLNMD4yQG0
         AChbz2jsXAyvKHviKlbKwwV10ZO/ehX+1tPEJSV/dvQtyzLddpPe+H924yvDE/w1RPfR
         KUclBOYeM6zIM1XDTle7VGDDQULzeE5eJ+kTCkqG4jsmaxne7GrRsHqzqjtZVIyA5V4l
         FWHQ==
X-Gm-Message-State: ANoB5plqow7/gODXFrtbHpnLRHIaI8eah7+wlzc2BluijQMWHisFlBID
        Oc2TJ7u3iOFuftfIYe9PbhvBRXl4UjG8VQ==
X-Google-Smtp-Source: AA0mqf4z7ahPTxt0pKfEDLwys9pL84Tiv0xXduj6l8Ox5tv1durnxC2vT7eF/nOzDDTq5Sh+gUNqvg==
X-Received: by 2002:a17:90a:1a11:b0:213:f398:ed51 with SMTP id 17-20020a17090a1a1100b00213f398ed51mr9727753pjk.216.1668812244551;
        Fri, 18 Nov 2022 14:57:24 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id k89-20020a17090a3ee200b002005fcd2cb4sm6004818pjc.2.2022.11.18.14.57.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 14:57:24 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        mst@redhat.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [RFC PATCH net-next 09/19] pds_core: add auxiliary_bus devices
Date:   Fri, 18 Nov 2022 14:56:46 -0800
Message-Id: <20221118225656.48309-10-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221118225656.48309-1-snelson@pensando.io>
References: <20221118225656.48309-1-snelson@pensando.io>
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

An auxiliary_bus device is created for each VF, and the device
name is made up of the PF driver name, VIF name, and PCI BDF
of the VF.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/pds_core/Makefile   |   1 +
 .../net/ethernet/pensando/pds_core/auxbus.c   | 126 ++++++++++++++++++
 drivers/net/ethernet/pensando/pds_core/core.h |   3 +
 drivers/net/ethernet/pensando/pds_core/main.c |  18 +++
 include/linux/pds/pds_auxbus.h                |  37 +++++
 5 files changed, 185 insertions(+)
 create mode 100644 drivers/net/ethernet/pensando/pds_core/auxbus.c
 create mode 100644 include/linux/pds/pds_auxbus.h

diff --git a/drivers/net/ethernet/pensando/pds_core/Makefile b/drivers/net/ethernet/pensando/pds_core/Makefile
index ee794cc08fda..22f23874354e 100644
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
index 000000000000..9b67cb4006d9
--- /dev/null
+++ b/drivers/net/ethernet/pensando/pds_core/auxbus.c
@@ -0,0 +1,126 @@
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
+		/* TODO: EXPORT pci_iov_virtfn_bus()
+		 *       so we don't need to assume the VF is on the same bus
+		 */
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
index 07499a8aae21..3ab314217464 100644
--- a/drivers/net/ethernet/pensando/pds_core/core.h
+++ b/drivers/net/ethernet/pensando/pds_core/core.h
@@ -321,6 +321,9 @@ int pdsc_start(struct pdsc *pdsc);
 void pdsc_stop(struct pdsc *pdsc);
 void pdsc_health_thread(struct work_struct *work);
 
+int pdsc_auxbus_dev_add_vf(struct pdsc *pdsc, int vf_id);
+int pdsc_auxbus_dev_del_vf(struct pdsc *pdsc, int vf_id);
+
 void pdsc_process_adminq(struct pdsc_qcq *qcq);
 void pdsc_work_thread(struct work_struct *work);
 irqreturn_t pdsc_adminq_isr(int irq, void *data);
diff --git a/drivers/net/ethernet/pensando/pds_core/main.c b/drivers/net/ethernet/pensando/pds_core/main.c
index 36e330c49360..95d2d25a0919 100644
--- a/drivers/net/ethernet/pensando/pds_core/main.c
+++ b/drivers/net/ethernet/pensando/pds_core/main.c
@@ -170,6 +170,8 @@ static int pdsc_sriov_configure(struct pci_dev *pdev, int num_vfs)
 	struct pds_core_vf_setattr_cmd vfc = { .attr = PDS_CORE_VF_ATTR_STATSADDR };
 	struct pdsc *pdsc = pci_get_drvdata(pdev);
 	struct device *dev = pdsc->dev;
+	enum pds_core_vif_types vt;
+	bool enabled = false;
 	struct pdsc_vf *v;
 	int ret = 0;
 	int i;
@@ -200,9 +202,21 @@ static int pdsc_sriov_configure(struct pci_dev *pdev, int num_vfs)
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
 
@@ -362,6 +376,10 @@ static void pdsc_remove(struct pci_dev *pdev)
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

