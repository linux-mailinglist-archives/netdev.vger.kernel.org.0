Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A374496E4A
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 02:24:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbfHUAXk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 20:23:40 -0400
Received: from mail-eopbgr680114.outbound.protection.outlook.com ([40.107.68.114]:56135
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726327AbfHUAXi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 20:23:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LfF3rTAp+6AmSdbH9V+fcswzeZ+D2UtqHCfvpTW/EUkSOmC6aO7NdtXjYGWXxcnrwEfWpBUzPmiftgYDGEG5A0irQhB2SEUeErbMgNVVqFrgpEol9edMm/qAeZ1JvjvS5ODVzYbUXU4i8hhLl1A4SRo8XHmSRoyd1n10BtfStZdhaE/sq6ZNcwVTO9m8ucD5wduxOQWidfOHN/uxsk5pLitfj5KpNrJwKfQod7nrKvQSA1oiUXJVSn7pebzZHDbhwahEvGQZ8bvfaAnJLP3rwmKRV2q7sCuohkN0KnMN8qSlPXfR0MfBTGl2U/rNRRjq+Vk0gcGcXTcZTAI9m7JuMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oFZZ4diWljvlc20ZEICjYDsjPSJzxnBOllgrHtDKK6A=;
 b=XKaZNmCqwfP2apVYpf/Xn8Ah47qFwFSGIZODsydm1LAllIIenSNV1CvRl4c2lryMqX0k4cqdq+Z/tSgadioNXwUfj9QQgsd4kuArS2StyTEF6G43x09jndmSTdW6dYvTWD6HWgTrQv9WqhPdFsS9PcmyV+sDleKEmq5XK+4/Y4Illrdvc8aP4yrVfE6KzpV1mVuA8RelMk/Mp2aulyvfR1MiskvZWLJL9ndc/BWMBCKPtyTHi+iNffOZ3sCj+J4rklW3vRHppkIfp7AYL9UjQ2AUMoCKKT5Plpln4MsUHQE7EAOGuCTKM4slMm0jgoc8XJLTyD5JRgXasgdSzK0h3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oFZZ4diWljvlc20ZEICjYDsjPSJzxnBOllgrHtDKK6A=;
 b=HGiQhOZ0yNFJdj4quCRmetLfIul24MO/eWkZesDpI1l+Cl6FmQPuGFRNhQFBwQUjuq01YSlJhom4xk7797Ap3c2o2xf/y4BYbmjhu2Kw2TTbwYR2+HzPdTDJm0Iaph3QP/DGWuqJxQCFKnQAxkM7RCIl1ZSnXYcS8iy75LBCFmw=
Received: from DM6PR21MB1242.namprd21.prod.outlook.com (20.179.50.86) by
 DM6PR21MB1450.namprd21.prod.outlook.com (10.255.109.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.3; Wed, 21 Aug 2019 00:23:33 +0000
Received: from DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::ddd:8e5b:2930:6726]) by DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::ddd:8e5b:2930:6726%9]) with mapi id 15.20.2178.006; Wed, 21 Aug 2019
 00:23:33 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     "sashal@kernel.org" <sashal@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "eranbe@mellanox.com" <eranbe@mellanox.com>,
        "lorenzo.pieralisi@arm.com" <lorenzo.pieralisi@arm.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Haiyang Zhang <haiyangz@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next,v3, 2/6] PCI: hv: Add a Hyper-V PCI interface driver
 for software backchannel interface
Thread-Topic: [PATCH net-next,v3, 2/6] PCI: hv: Add a Hyper-V PCI interface
 driver for software backchannel interface
Thread-Index: AQHVV7aqTXaW6mDaBE2Uols+NDE8ew==
Date:   Wed, 21 Aug 2019 00:23:32 +0000
Message-ID: <1566346948-69497-3-git-send-email-haiyangz@microsoft.com>
References: <1566346948-69497-1-git-send-email-haiyangz@microsoft.com>
In-Reply-To: <1566346948-69497-1-git-send-email-haiyangz@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR02CA0034.namprd02.prod.outlook.com
 (2603:10b6:301:60::23) To DM6PR21MB1242.namprd21.prod.outlook.com
 (2603:10b6:5:169::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=lkmlhyz@microsoft.com; 
x-ms-exchange-messagesentrepresentingtype: 2
x-mailer: git-send-email 1.8.3.1
x-originating-ip: [13.77.154.182]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b1281573-a2a9-4d35-06f5-08d725cdcca4
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600158)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DM6PR21MB1450;
x-ms-traffictypediagnostic: DM6PR21MB1450:|DM6PR21MB1450:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR21MB1450D3823F123267ACA47209ACAA0@DM6PR21MB1450.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0136C1DDA4
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(39860400002)(136003)(366004)(346002)(396003)(189003)(199004)(26005)(2906002)(71190400001)(71200400001)(6512007)(50226002)(186003)(36756003)(54906003)(8676002)(110136005)(6436002)(6392003)(7846003)(8936002)(99286004)(446003)(6506007)(81166006)(81156014)(2201001)(386003)(6486002)(76176011)(7416002)(66066001)(5660300002)(52116002)(102836004)(11346002)(316002)(53936002)(6116002)(3846002)(22452003)(478600001)(4326008)(256004)(66946007)(66476007)(66556008)(64756008)(66446008)(2616005)(476003)(486006)(305945005)(25786009)(10090500001)(4720700003)(14454004)(10290500003)(2501003)(7736002)(921003)(142933001)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR21MB1450;H:DM6PR21MB1242.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: m7p6oUHLvOpPXk6jkSuwjQqvXYML2EkyaAb3Fl9DdasUnjfJOttwrbiPZr49NXkYroVypLda+GbVVnm8puSqWhFUtS4UdS0lWjwYQo7UhZ95Duilq/OLnHJgcMzEyPoZJxLxDEVph2WT0nPA9+UOrtq/1ORj5atomSPxXGW4sTJ3N68Nn9FxxWBYEIy7iJAg0fF1kttRIXeI4sJHJvY/DvDRcPz85SbbLY8HoYRFy5Teh2myD4lXqkylX4Mg8DvUm2DZiYEvzt3mr1KJfmir5mt5+TDJr7g8DJpfDfSC7ZybI1zeNoyuRBip6rQJOmTr43J1QUhpVL+WYllF59S4tZEmv+qKSTX8E1lKGQnKOdUG4WoTJZ6t5agujDnK4Jc01scYeYWnV6QAKIL371IdMmCoOQgWUgLHRMARXaNu4Rg=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1281573-a2a9-4d35-06f5-08d725cdcca4
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Aug 2019 00:23:32.9778
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0Tn5dp5QosrciQRlwO086N9L5GukNR2t75QJxcN4m1VqQuLc9yzg7+9O0RysOqfSNJPQ7Mi9AC8UwKKzfaOpRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1450
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This interface driver is a helper driver allows other drivers to
have a common interface with the Hyper-V PCI frontend driver.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 MAINTAINERS                              |  1 +
 drivers/pci/Kconfig                      |  1 +
 drivers/pci/controller/Kconfig           |  7 ++++
 drivers/pci/controller/Makefile          |  1 +
 drivers/pci/controller/pci-hyperv-intf.c | 67 ++++++++++++++++++++++++++++=
++++
 drivers/pci/controller/pci-hyperv.c      | 12 ++++--
 include/linux/hyperv.h                   | 30 ++++++++++----
 7 files changed, 108 insertions(+), 11 deletions(-)
 create mode 100644 drivers/pci/controller/pci-hyperv-intf.c

diff --git a/MAINTAINERS b/MAINTAINERS
index e352550..866ae88 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7453,6 +7453,7 @@ F:	drivers/hid/hid-hyperv.c
 F:	drivers/hv/
 F:	drivers/input/serio/hyperv-keyboard.c
 F:	drivers/pci/controller/pci-hyperv.c
+F:	drivers/pci/controller/pci-hyperv-intf.c
 F:	drivers/net/hyperv/
 F:	drivers/scsi/storvsc_drv.c
 F:	drivers/uio/uio_hv_generic.c
diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
index 2ab9240..c313de9 100644
--- a/drivers/pci/Kconfig
+++ b/drivers/pci/Kconfig
@@ -182,6 +182,7 @@ config PCI_LABEL
 config PCI_HYPERV
         tristate "Hyper-V PCI Frontend"
         depends on X86 && HYPERV && PCI_MSI && PCI_MSI_IRQ_DOMAIN && X86_6=
4
+	select PCI_HYPERV_INTERFACE
         help
           The PCI device frontend driver allows the kernel to import arbit=
rary
           PCI devices from a PCI backend to support PCI driver domains.
diff --git a/drivers/pci/controller/Kconfig b/drivers/pci/controller/Kconfi=
g
index fe9f9f1..70e0782 100644
--- a/drivers/pci/controller/Kconfig
+++ b/drivers/pci/controller/Kconfig
@@ -281,5 +281,12 @@ config VMD
 	  To compile this driver as a module, choose M here: the
 	  module will be called vmd.
=20
+config PCI_HYPERV_INTERFACE
+	tristate "Hyper-V PCI Interface"
+	depends on X86 && HYPERV && PCI_MSI && PCI_MSI_IRQ_DOMAIN && X86_64
+	help
+	  The Hyper-V PCI Interface is a helper driver allows other drivers to
+	  have a common interface with the Hyper-V PCI frontend driver.
+
 source "drivers/pci/controller/dwc/Kconfig"
 endmenu
diff --git a/drivers/pci/controller/Makefile b/drivers/pci/controller/Makef=
ile
index d56a507..a2a22c9 100644
--- a/drivers/pci/controller/Makefile
+++ b/drivers/pci/controller/Makefile
@@ -4,6 +4,7 @@ obj-$(CONFIG_PCIE_CADENCE_HOST) +=3D pcie-cadence-host.o
 obj-$(CONFIG_PCIE_CADENCE_EP) +=3D pcie-cadence-ep.o
 obj-$(CONFIG_PCI_FTPCI100) +=3D pci-ftpci100.o
 obj-$(CONFIG_PCI_HYPERV) +=3D pci-hyperv.o
+obj-$(CONFIG_PCI_HYPERV_INTERFACE) +=3D pci-hyperv-intf.o
 obj-$(CONFIG_PCI_MVEBU) +=3D pci-mvebu.o
 obj-$(CONFIG_PCI_AARDVARK) +=3D pci-aardvark.o
 obj-$(CONFIG_PCI_TEGRA) +=3D pci-tegra.o
diff --git a/drivers/pci/controller/pci-hyperv-intf.c b/drivers/pci/control=
ler/pci-hyperv-intf.c
new file mode 100644
index 0000000..cc96be4
--- /dev/null
+++ b/drivers/pci/controller/pci-hyperv-intf.c
@@ -0,0 +1,67 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) Microsoft Corporation.
+ *
+ * Author:
+ *   Haiyang Zhang <haiyangz@microsoft.com>
+ *
+ * This small module is a helper driver allows other drivers to
+ * have a common interface with the Hyper-V PCI frontend driver.
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/hyperv.h>
+
+struct hyperv_pci_block_ops hvpci_block_ops;
+EXPORT_SYMBOL_GPL(hvpci_block_ops);
+
+int hyperv_read_cfg_blk(struct pci_dev *dev, void *buf, unsigned int buf_l=
en,
+			unsigned int block_id, unsigned int *bytes_returned)
+{
+	if (!hvpci_block_ops.read_block)
+		return -EOPNOTSUPP;
+
+	return hvpci_block_ops.read_block(dev, buf, buf_len, block_id,
+					  bytes_returned);
+}
+EXPORT_SYMBOL_GPL(hyperv_read_cfg_blk);
+
+int hyperv_write_cfg_blk(struct pci_dev *dev, void *buf, unsigned int len,
+			 unsigned int block_id)
+{
+	if (!hvpci_block_ops.write_block)
+		return -EOPNOTSUPP;
+
+	return hvpci_block_ops.write_block(dev, buf, len, block_id);
+}
+EXPORT_SYMBOL_GPL(hyperv_write_cfg_blk);
+
+int hyperv_reg_block_invalidate(struct pci_dev *dev, void *context,
+				void (*block_invalidate)(void *context,
+							 u64 block_mask))
+{
+	if (!hvpci_block_ops.reg_blk_invalidate)
+		return -EOPNOTSUPP;
+
+	return hvpci_block_ops.reg_blk_invalidate(dev, context,
+						  block_invalidate);
+}
+EXPORT_SYMBOL_GPL(hyperv_reg_block_invalidate);
+
+static void __exit exit_hv_pci_intf(void)
+{
+}
+
+static int __init init_hv_pci_intf(void)
+{
+	return 0;
+}
+
+module_init(init_hv_pci_intf);
+module_exit(exit_hv_pci_intf);
+
+MODULE_DESCRIPTION("Hyper-V PCI Interface");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/pci/controller/pci-hyperv.c b/drivers/pci/controller/p=
ci-hyperv.c
index 57adeca..9c93ac2 100644
--- a/drivers/pci/controller/pci-hyperv.c
+++ b/drivers/pci/controller/pci-hyperv.c
@@ -983,7 +983,6 @@ int hv_read_config_block(struct pci_dev *pdev, void *bu=
f, unsigned int len,
 	*bytes_returned =3D comp_pkt.bytes_returned;
 	return 0;
 }
-EXPORT_SYMBOL(hv_read_config_block);
=20
 /**
  * hv_pci_write_config_compl() - Invoked when a response packet for a writ=
e
@@ -1070,7 +1069,6 @@ int hv_write_config_block(struct pci_dev *pdev, void =
*buf, unsigned int len,
=20
 	return 0;
 }
-EXPORT_SYMBOL(hv_write_config_block);
=20
 /**
  * hv_register_block_invalidate() - Invoked when a config block invalidati=
on
@@ -1101,7 +1099,6 @@ int hv_register_block_invalidate(struct pci_dev *pdev=
, void *context,
 	return 0;
=20
 }
-EXPORT_SYMBOL(hv_register_block_invalidate);
=20
 /* Interrupt management hooks */
 static void hv_int_desc_free(struct hv_pci_dev *hpdev,
@@ -3045,10 +3042,19 @@ static int hv_pci_remove(struct hv_device *hdev)
 static void __exit exit_hv_pci_drv(void)
 {
 	vmbus_driver_unregister(&hv_pci_drv);
+
+	hvpci_block_ops.read_block =3D NULL;
+	hvpci_block_ops.write_block =3D NULL;
+	hvpci_block_ops.reg_blk_invalidate =3D NULL;
 }
=20
 static int __init init_hv_pci_drv(void)
 {
+	/* Initialize PCI block r/w interface */
+	hvpci_block_ops.read_block =3D hv_read_config_block;
+	hvpci_block_ops.write_block =3D hv_write_config_block;
+	hvpci_block_ops.reg_blk_invalidate =3D hv_register_block_invalidate;
+
 	return vmbus_driver_register(&hv_pci_drv);
 }
=20
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index 9d37f8c..2afe6fd 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -1579,18 +1579,32 @@ struct vmpacket_descriptor *
 	    pkt =3D hv_pkt_iter_next(channel, pkt))
=20
 /*
- * Functions for passing data between SR-IOV PF and VF drivers.  The VF dr=
iver
+ * Interface for passing data between SR-IOV PF and VF drivers. The VF dri=
ver
  * sends requests to read and write blocks. Each block must be 128 bytes o=
r
  * smaller. Optionally, the VF driver can register a callback function whi=
ch
  * will be invoked when the host says that one or more of the first 64 blo=
ck
  * IDs is "invalid" which means that the VF driver should reread them.
  */
 #define HV_CONFIG_BLOCK_SIZE_MAX 128
-int hv_read_config_block(struct pci_dev *dev, void *buf, unsigned int buf_=
len,
-			 unsigned int block_id, unsigned int *bytes_returned);
-int hv_write_config_block(struct pci_dev *dev, void *buf, unsigned int len=
,
-			  unsigned int block_id);
-int hv_register_block_invalidate(struct pci_dev *dev, void *context,
-				 void (*block_invalidate)(void *context,
-							  u64 block_mask));
+
+int hyperv_read_cfg_blk(struct pci_dev *dev, void *buf, unsigned int buf_l=
en,
+			unsigned int block_id, unsigned int *bytes_returned);
+int hyperv_write_cfg_blk(struct pci_dev *dev, void *buf, unsigned int len,
+			 unsigned int block_id);
+int hyperv_reg_block_invalidate(struct pci_dev *dev, void *context,
+				void (*block_invalidate)(void *context,
+							 u64 block_mask));
+
+struct hyperv_pci_block_ops {
+	int (*read_block)(struct pci_dev *dev, void *buf, unsigned int buf_len,
+			  unsigned int block_id, unsigned int *bytes_returned);
+	int (*write_block)(struct pci_dev *dev, void *buf, unsigned int len,
+			   unsigned int block_id);
+	int (*reg_blk_invalidate)(struct pci_dev *dev, void *context,
+				  void (*block_invalidate)(void *context,
+							   u64 block_mask));
+};
+
+extern struct hyperv_pci_block_ops hvpci_block_ops;
+
 #endif /* _HYPERV_H */
--=20
1.8.3.1

