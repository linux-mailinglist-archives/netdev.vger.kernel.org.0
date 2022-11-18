Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA1436302BC
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 00:14:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235361AbiKRXOs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 18:14:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235368AbiKRXNp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 18:13:45 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32670C68BD
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 14:57:59 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id 140so6225315pfz.6
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 14:57:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=iF04UX7VgnsmeL+hUATwcZsl2GZfxA64/NL4j+Vyp94=;
        b=WCHS5MILH/Q3GtzP0gxlKhGK8erRQaiOKtcGIqSRfWXvcGfoHrTo06zCeT5GxmB+Su
         P5rHyGs8HtOT/H7Q28s57QBLcZI0gtMyz7z9AVPDhf45RdpQB4HG8kQX5bUAVah2Ou3/
         vS3yOT7FYvGf2WwZ2uM55AGuYqok22A7xEENlitXvpqUYYsaw8wpIWA4JzCm0MLLfQh8
         87UUEsLm4m5kQLdm7u50xpieeUNL6/ybEv/ldm//XL9eoSNvxdhC4t3cmaSci7Wyz6Oj
         KWzYlLuzZbVe0SEV7p/P4Mb6p4mVdLegENA3d6MWFC5B3hsXSNTLZBvftNdbMgE+jMFH
         fdsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iF04UX7VgnsmeL+hUATwcZsl2GZfxA64/NL4j+Vyp94=;
        b=l/Kvfsy2AhTh6/T5mq6of7Vy3Ekr+28CA/KrX6adD715zS704KEKe/+3cJbNCANWVe
         IYs+HOIgx5HVPhzgtNtKKxhXig6Nu1RhZ+9+0CmoHKnjR1j5yTZPcT32wTnsaDPgdA5c
         qct7yLmMQ6x6uzylm3PHNTFmFLAUkUHkMCmVwc4G/FgvnUZ7cgSH0k/fQkjTbJ6BpGRz
         CT08+O5Sw7U2RuH/iMJ0fbPzoi1MjKarAIy5lMtXxJVDP/hXJCeSNbsKQ1/DyFOsht8E
         vqUHJmOIjDA16fN7QdPUGxdgKJnOuEvRhU7x6WZOk8ci1ecvAR7YKYLVerlChnYp5S+6
         GLMw==
X-Gm-Message-State: ANoB5pnAJLiZEDu0NQZ3YRZZKtpyo+hhrYXI3PnUoAH8HaJxONTrGXR4
        G+31lLR6qGvOK6APhavNMx4ql3n07YqwKw==
X-Google-Smtp-Source: AA0mqf7OtxkYCB+njkmk0JxO2ynJT3RTcXT2Wym4QENg5Xa/EEyUJYJnsEUlNJBgwlDjCHEDC0xQdw==
X-Received: by 2002:a63:1965:0:b0:464:a9a6:5717 with SMTP id 37-20020a631965000000b00464a9a65717mr8199147pgz.584.1668812253919;
        Fri, 18 Nov 2022 14:57:33 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id k89-20020a17090a3ee200b002005fcd2cb4sm6004818pjc.2.2022.11.18.14.57.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 14:57:33 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        mst@redhat.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [RFC PATCH net-next 16/19] pds_vdpa: add auxiliary driver
Date:   Fri, 18 Nov 2022 14:56:53 -0800
Message-Id: <20221118225656.48309-17-snelson@pensando.io>
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

The auxiliary_bus driver is registered after the PCI driver
is loaded, and when the pds_core has created a device for
it, after the VF has been enabled, this driver gets probed.
It then registers itself with the DSC through the pds_core in
order to start the firmware services for this device.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/vdpa/pds/Makefile  |   3 +-
 drivers/vdpa/pds/aux_drv.c | 123 +++++++++++++++++++++++++++++++++++++
 drivers/vdpa/pds/aux_drv.h |  28 +++++++++
 drivers/vdpa/pds/debugfs.c |  23 +++++++
 drivers/vdpa/pds/debugfs.h |   2 +
 drivers/vdpa/pds/pci_drv.c |  19 ++++++
 drivers/vdpa/pds/pci_drv.h |   1 +
 7 files changed, 198 insertions(+), 1 deletion(-)
 create mode 100644 drivers/vdpa/pds/aux_drv.c
 create mode 100644 drivers/vdpa/pds/aux_drv.h

diff --git a/drivers/vdpa/pds/Makefile b/drivers/vdpa/pds/Makefile
index b8376ab165bc..82ee258f6122 100644
--- a/drivers/vdpa/pds/Makefile
+++ b/drivers/vdpa/pds/Makefile
@@ -3,6 +3,7 @@
 
 obj-$(CONFIG_PDS_VDPA) := pds_vdpa.o
 
-pds_vdpa-y := pci_drv.o	\
+pds_vdpa-y := aux_drv.o \
+	      pci_drv.o	\
 	      debugfs.o \
 	      virtio_pci.o
diff --git a/drivers/vdpa/pds/aux_drv.c b/drivers/vdpa/pds/aux_drv.c
new file mode 100644
index 000000000000..aef3c984dc90
--- /dev/null
+++ b/drivers/vdpa/pds/aux_drv.c
@@ -0,0 +1,123 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright(c) 2022 Pensando Systems, Inc */
+
+#include <linux/auxiliary_bus.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/vdpa.h>
+
+#include <linux/pds/pds_core_if.h>
+#include <linux/pds/pds_adminq.h>
+#include <linux/pds/pds_auxbus.h>
+#include <linux/pds/pds_vdpa.h>
+
+#include "aux_drv.h"
+#include "pci_drv.h"
+#include "debugfs.h"
+
+static const
+struct auxiliary_device_id pds_vdpa_aux_id_table[] = {
+	{ .name = PDS_VDPA_DEV_NAME, },
+	{},
+};
+
+static void
+pds_vdpa_aux_notify_handler(struct pds_auxiliary_dev *padev,
+			    union pds_core_notifyq_comp *event)
+{
+	struct device *dev = &padev->aux_dev.dev;
+	u16 ecode = le16_to_cpu(event->ecode);
+
+	dev_info(dev, "%s: event code %d\n", __func__, ecode);
+}
+
+static int
+pds_vdpa_aux_probe(struct auxiliary_device *aux_dev,
+		   const struct auxiliary_device_id *id)
+
+{
+	struct pds_auxiliary_dev *padev =
+		container_of(aux_dev, struct pds_auxiliary_dev, aux_dev);
+	struct device *dev = &aux_dev->dev;
+	struct pds_vdpa_aux *vdpa_aux;
+	struct pci_dev *pdev;
+	struct pci_bus *bus;
+	int busnr;
+	u16 devfn;
+	int err;
+
+	vdpa_aux = kzalloc(sizeof(*vdpa_aux), GFP_KERNEL);
+	if (!vdpa_aux)
+		return -ENOMEM;
+
+	vdpa_aux->padev = padev;
+	auxiliary_set_drvdata(aux_dev, vdpa_aux);
+
+	/* Find our VF PCI device */
+	busnr = PCI_BUS_NUM(padev->id);
+	devfn = padev->id & 0xff;
+	bus = pci_find_bus(0, busnr);
+	pdev = pci_get_slot(bus, devfn);
+
+	vdpa_aux->vdpa_vf = pci_get_drvdata(pdev);
+	vdpa_aux->vdpa_vf->vdpa_aux = vdpa_aux;
+	pdev = vdpa_aux->vdpa_vf->pdev;
+	if (!pds_vdpa_is_vdpa_pci_driver(pdev)) {
+		dev_err(&pdev->dev, "%s: PCI driver is not pds_vdpa_pci_driver\n", __func__);
+		err = -EINVAL;
+		goto err_invalid_driver;
+	}
+
+	dev_info(dev, "%s: id %#04x busnr %#x devfn %#x bus %p vdpa_vf %p\n",
+		 __func__, padev->id, busnr, devfn, bus, vdpa_aux->vdpa_vf);
+
+	/* Register our PDS client with the pds_core */
+	vdpa_aux->padrv.event_handler = pds_vdpa_aux_notify_handler;
+	err = padev->ops->register_client(padev, &vdpa_aux->padrv);
+	if (err) {
+		dev_err(dev, "%s: Failed to register as client: %pe\n",
+			__func__, ERR_PTR(err));
+		goto err_register_client;
+	}
+
+	pds_vdpa_debugfs_add_ident(vdpa_aux);
+
+	return 0;
+
+err_register_client:
+	auxiliary_set_drvdata(aux_dev, NULL);
+err_invalid_driver:
+	kfree(vdpa_aux);
+
+	return err;
+}
+
+static void
+pds_vdpa_aux_remove(struct auxiliary_device *aux_dev)
+{
+	struct pds_vdpa_aux *vdpa_aux = auxiliary_get_drvdata(aux_dev);
+	struct device *dev = &aux_dev->dev;
+
+	vdpa_aux->padev->ops->unregister_client(vdpa_aux->padev);
+	if (vdpa_aux->vdpa_vf)
+		pci_dev_put(vdpa_aux->vdpa_vf->pdev);
+
+	kfree(vdpa_aux);
+	auxiliary_set_drvdata(aux_dev, NULL);
+
+	dev_info(dev, "Removed\n");
+}
+
+static struct auxiliary_driver
+pds_vdpa_aux_driver = {
+	.name = PDS_DEV_TYPE_VDPA_STR,
+	.probe = pds_vdpa_aux_probe,
+	.remove = pds_vdpa_aux_remove,
+	.id_table = pds_vdpa_aux_id_table,
+};
+
+struct auxiliary_driver *
+pds_vdpa_aux_driver_info(void)
+{
+	return &pds_vdpa_aux_driver;
+}
diff --git a/drivers/vdpa/pds/aux_drv.h b/drivers/vdpa/pds/aux_drv.h
new file mode 100644
index 000000000000..a6bd644fb957
--- /dev/null
+++ b/drivers/vdpa/pds/aux_drv.h
@@ -0,0 +1,28 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright(c) 2022 Pensando Systems, Inc */
+
+#ifndef _AUX_DRV_H_
+#define _AUX_DRV_H_
+
+#include <linux/auxiliary_bus.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+
+struct pds_vdpa_pci_device;
+
+struct pds_vdpa_aux {
+	struct pds_auxiliary_dev *padev;
+	struct pds_auxiliary_drv padrv;
+
+	struct pds_vdpa_pci_device *vdpa_vf;
+	struct vdpa_mgmt_dev vdpa_mdev;
+	struct pds_vdpa_device *pdsv;
+
+	struct pds_vdpa_ident ident;
+	bool local_mac_bit;
+};
+
+struct auxiliary_driver *
+pds_vdpa_aux_driver_info(void);
+
+#endif /* _AUX_DRV_H_ */
diff --git a/drivers/vdpa/pds/debugfs.c b/drivers/vdpa/pds/debugfs.c
index f5b6654ae89b..f766412209df 100644
--- a/drivers/vdpa/pds/debugfs.c
+++ b/drivers/vdpa/pds/debugfs.c
@@ -4,10 +4,14 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/types.h>
+#include <linux/vdpa.h>
 
 #include <linux/pds/pds_core_if.h>
+#include <linux/pds/pds_adminq.h>
+#include <linux/pds/pds_auxbus.h>
 #include <linux/pds/pds_vdpa.h>
 
+#include "aux_drv.h"
 #include "pci_drv.h"
 #include "debugfs.h"
 
@@ -41,4 +45,23 @@ pds_vdpa_debugfs_del_pcidev(struct pds_vdpa_pci_device *vdpa_pdev)
 	vdpa_pdev->dentry = NULL;
 }
 
+static int
+identity_show(struct seq_file *seq, void *v)
+{
+	struct pds_vdpa_aux *vdpa_aux = seq->private;
+
+	seq_printf(seq, "aux_dev:            %s\n",
+		   dev_name(&vdpa_aux->padev->aux_dev.dev));
+
+	return 0;
+}
+DEFINE_SHOW_ATTRIBUTE(identity);
+
+void
+pds_vdpa_debugfs_add_ident(struct pds_vdpa_aux *vdpa_aux)
+{
+	debugfs_create_file("identity", 0400, vdpa_aux->vdpa_vf->dentry,
+			    vdpa_aux, &identity_fops);
+}
+
 #endif /* CONFIG_DEBUG_FS */
diff --git a/drivers/vdpa/pds/debugfs.h b/drivers/vdpa/pds/debugfs.h
index ac31ab47746b..939a4c248aac 100644
--- a/drivers/vdpa/pds/debugfs.h
+++ b/drivers/vdpa/pds/debugfs.h
@@ -12,11 +12,13 @@ void pds_vdpa_debugfs_create(void);
 void pds_vdpa_debugfs_destroy(void);
 void pds_vdpa_debugfs_add_pcidev(struct pds_vdpa_pci_device *vdpa_pdev);
 void pds_vdpa_debugfs_del_pcidev(struct pds_vdpa_pci_device *vdpa_pdev);
+void pds_vdpa_debugfs_add_ident(struct pds_vdpa_aux *vdpa_aux);
 #else
 static inline void pds_vdpa_debugfs_create(void) { }
 static inline void pds_vdpa_debugfs_destroy(void) { }
 static inline void pds_vdpa_debugfs_add_pcidev(struct pds_vdpa_pci_device *vdpa_pdev) { }
 static inline void pds_vdpa_debugfs_del_pcidev(struct pds_vdpa_pci_device *vdpa_pdev) { }
+static inline void pds_vdpa_debugfs_add_ident(struct pds_vdpa_aux *vdpa_aux) { }
 #endif
 
 #endif /* _PDS_VDPA_DEBUGFS_H_ */
diff --git a/drivers/vdpa/pds/pci_drv.c b/drivers/vdpa/pds/pci_drv.c
index 10491e22778c..54a73ae023f9 100644
--- a/drivers/vdpa/pds/pci_drv.c
+++ b/drivers/vdpa/pds/pci_drv.c
@@ -6,11 +6,15 @@
 #include <linux/aer.h>
 #include <linux/types.h>
 #include <linux/vdpa.h>
+#include <linux/auxiliary_bus.h>
 
 #include <linux/pds/pds_core_if.h>
+#include <linux/pds/pds_adminq.h>
+#include <linux/pds/pds_auxbus.h>
 #include <linux/pds/pds_vdpa.h>
 
 #include "pci_drv.h"
+#include "aux_drv.h"
 #include "debugfs.h"
 
 static void
@@ -118,9 +122,16 @@ pds_vdpa_pci_driver = {
 	.remove = pds_vdpa_pci_remove
 };
 
+bool
+pds_vdpa_is_vdpa_pci_driver(struct pci_dev *pdev)
+{
+	return (to_pci_driver(pdev->dev.driver) == &pds_vdpa_pci_driver);
+}
+
 static void __exit
 pds_vdpa_pci_cleanup(void)
 {
+	auxiliary_driver_unregister(pds_vdpa_aux_driver_info());
 	pci_unregister_driver(&pds_vdpa_pci_driver);
 
 	pds_vdpa_debugfs_destroy();
@@ -140,8 +151,16 @@ pds_vdpa_pci_init(void)
 		goto err_pci;
 	}
 
+	err = auxiliary_driver_register(pds_vdpa_aux_driver_info());
+	if (err) {
+		pr_err("%s: aux driver register failed: %pe\n", __func__, ERR_PTR(err));
+		goto err_aux;
+	}
+
 	return 0;
 
+err_aux:
+	pci_unregister_driver(&pds_vdpa_pci_driver);
 err_pci:
 	pds_vdpa_debugfs_destroy();
 	return err;
diff --git a/drivers/vdpa/pds/pci_drv.h b/drivers/vdpa/pds/pci_drv.h
index 15f3b34fafa9..97ba75a7ce50 100644
--- a/drivers/vdpa/pds/pci_drv.h
+++ b/drivers/vdpa/pds/pci_drv.h
@@ -43,6 +43,7 @@ struct pds_vdpa_pci_device {
 	struct virtio_pci_modern_device vd_mdev;
 };
 
+bool pds_vdpa_is_vdpa_pci_driver(struct pci_dev *pdev);
 int pds_vdpa_probe_virtio(struct virtio_pci_modern_device *mdev);
 void pds_vdpa_remove_virtio(struct virtio_pci_modern_device *mdev);
 #endif /* _PCI_DRV_H */
-- 
2.17.1

