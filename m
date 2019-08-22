Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37CD598AC3
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 07:06:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731316AbfHVFF7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 01:05:59 -0400
Received: from mail-eopbgr810109.outbound.protection.outlook.com ([40.107.81.109]:28619
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731265AbfHVFF6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 01:05:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TkPtwYFnYZI/Tw4k7pPQtxCvNqnyyON489wgbNGDI4jV+JLfNPEWztCdk6Ui4j0tM+Tay7vr4Oi/eZtI6YNGcZcgUtrUnw7WkL3sDGiZw4h636wbwiFCPWXf6a6LnWfXBei5ilfpsJDu0fYvrqM+7SF2Xb9BFXgEMXMlEAYvZHnMqV8kRCqeNnZZqlWsBgOVQ4hUKdx+v4dj+gKOKzpeQQ7Yz1BM7EbJQIBT3FwqHLqAkd066GZTRU9suBSff3yrgbtdBR+1xbndQ4/Th4iOHY7BJQIzfm528ZenNivK1+kRGpwcaqd1ThYxnq2Nw/JEndYGsCAXSpqJVW4B9ekicg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=49pCCLY0UQGnJr+msFhZ/lhUbgof+155r2+qubA1C+M=;
 b=jDoBaVB25UbAHKXDbaMS/agrHDlkKxo9EizbOS3w9cp8acb5OPGxn/QBboR4NLXPVLhmWqECsUEhFYZwftwWv8WRVr8gvs0G5Il/vzd74lLwjv32baK9C3ZdC96SlFzfeGVsxMtZnaz5WdM264tpQsHIpapOQnB7QcG/2hrebrFEYEcH17QCNTjrOJmPyvf1eAkka9sPnrJgA40lFXaa/zYZ4r7rLxvqR9ABCE56FDVko92Lj34sjOeY8c1yZAxIl9qMbuiNOVnuh5Ptq6hzkQ2exfx/oYlB9l9Ip/e1TLWQV7y9jtHF2H29hBHztjgctqQ1F4dItZvaDwFAtl55lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=49pCCLY0UQGnJr+msFhZ/lhUbgof+155r2+qubA1C+M=;
 b=LJSQO+uYHJpdU/1w7GHsK3EaRQe99OQFpEF7x57EbR5z7QfUltwzd2sRqVfH+frDVGUAFfF7Q5U44TqNHYVYgW+SJRI5wiP3uT070qsL3+aFrh0BrwOjgmPV4ktLnSXaImGJURCDHCakCgcAqO4//G8o3q+nvo8wYU5z1pPBSmY=
Received: from MN2PR21MB1248.namprd21.prod.outlook.com (20.179.20.225) by
 MN2PR21MB1279.namprd21.prod.outlook.com (20.179.21.91) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.4; Thu, 22 Aug 2019 05:05:41 +0000
Received: from MN2PR21MB1248.namprd21.prod.outlook.com
 ([fe80::147a:ea1f:326d:832e]) by MN2PR21MB1248.namprd21.prod.outlook.com
 ([fe80::147a:ea1f:326d:832e%3]) with mapi id 15.20.2199.011; Thu, 22 Aug 2019
 05:05:41 +0000
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
Subject: [PATCH net-next,v4, 2/6] PCI: hv: Add a Hyper-V PCI interface driver
 for software backchannel interface
Thread-Topic: [PATCH net-next,v4, 2/6] PCI: hv: Add a Hyper-V PCI interface
 driver for software backchannel interface
Thread-Index: AQHVWKc+GNFRZDxadEKTuhFzjn601Q==
Date:   Thu, 22 Aug 2019 05:05:41 +0000
Message-ID: <1566450236-36757-3-git-send-email-haiyangz@microsoft.com>
References: <1566450236-36757-1-git-send-email-haiyangz@microsoft.com>
In-Reply-To: <1566450236-36757-1-git-send-email-haiyangz@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR14CA0039.namprd14.prod.outlook.com
 (2603:10b6:300:12b::25) To MN2PR21MB1248.namprd21.prod.outlook.com
 (2603:10b6:208:3b::33)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=lkmlhyz@microsoft.com; 
x-ms-exchange-messagesentrepresentingtype: 2
x-mailer: git-send-email 1.8.3.1
x-originating-ip: [13.77.154.182]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6cc3dabc-c434-4b75-a945-08d726be60fb
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600158)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MN2PR21MB1279;
x-ms-traffictypediagnostic: MN2PR21MB1279:|MN2PR21MB1279:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR21MB1279BADAEE59C4AD531A7106ACA50@MN2PR21MB1279.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 01371B902F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(396003)(136003)(366004)(376002)(346002)(189003)(199004)(71200400001)(71190400001)(186003)(446003)(66066001)(2616005)(4326008)(36756003)(6392003)(6436002)(256004)(53936002)(7846003)(7416002)(6512007)(26005)(6486002)(11346002)(316002)(2906002)(2201001)(110136005)(22452003)(54906003)(10090500001)(476003)(25786009)(386003)(7736002)(64756008)(81156014)(66946007)(66446008)(8936002)(10290500003)(478600001)(66476007)(2501003)(102836004)(4720700003)(6116002)(3846002)(6506007)(305945005)(5660300002)(486006)(99286004)(66556008)(81166006)(14454004)(50226002)(8676002)(52116002)(76176011)(142933001)(921003)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR21MB1279;H:MN2PR21MB1248.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 72v0/CFGN8vThzVMTEhTdEdxs/E/tKB6nRzM6iykUNo4cEGmzfBkG9uF25cFTlpQBf7pgSjHhbE73mEExtYpLJPOAx+uYf4s2e/TZ17OPQiIjrlj2eV/78M9hY8DN09KhP/cXSQQc9KhsyIm9qiiHm5++wH+2WBITzUBp58mGRNPKpXMHmvsHlX3k5HEx/Bk3KcWX8XqOwddGHeVWpQTMD+bS3F/7luEjeYEjQUYcYkywg9mf+LLodiqZT35KcA0Eqkuv8sQK5PRaHHYK7JDMRIney95HOrsjVbnSBrqaQmxbbT9gz8ZdlQWacYoCMXFCHe/DRDDploZAWPVL+x+zOrDJ5B/vFCd5e/aKe5xm9/h+puwY4erTioe4Ard4OshjHTxPwl2JcSJLpzF6sP8672jC9JZy/HeZJ2oCN+OPik=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cc3dabc-c434-4b75-a945-08d726be60fb
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2019 05:05:41.1020
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TaUir6IjTJRJOpq7UNeP5OJE0+rky/6WYXoU0LxdrcCIgK3zTTLhYb+hFOCFUP3ESxTrOyN1zw3kAKEWegWTqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR21MB1279
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
index a406947..9860853 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7469,6 +7469,7 @@ F:	drivers/hid/hid-hyperv.c
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

