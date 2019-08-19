Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63A4394E29
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 21:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728566AbfHSTav (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 15:30:51 -0400
Received: from mail-eopbgr810137.outbound.protection.outlook.com ([40.107.81.137]:27275
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728348AbfHSTau (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Aug 2019 15:30:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c3tPWKT68cwmXVajWzjDYqAKpAfvcM7GMqOHzb0P47eJR1llqMRWbKTNyfrhp+rcwTldc/ALNlU9HyHB2yCyoc/KokdEvCjJJY4EvIqvA1clWbeqAIfwk7qLnx/lEqk3GsS8hBnL6IWUgrqRn5lmnklUQfe4ls/d+K9ThVCvkZfSodsCAd5K3a3RQZnEGY3faHwCSts3/ONXIqilfs0a3Y2Yi51QeiLg6tUfExRPebTjrp/d6KDHJSHuW4v7QvQvycEWcQBbWzfFLMG1tTbovovS85SQ869I0SzfJ449UmvrZpQUGIjlPo0OWoMgAu6yc41xfqwt2ALcdcMSz6pn2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=meFRSjrkfQ5GM1raLipnx6xLgcdL7PzQxOHfmcGNbL4=;
 b=n3nuwYX5ufCb3Z2hqsqAXvFyTb7ENgLOJa9kFk/L1XuBLTPpwXHStvAw0nFd2QDJNaKCtAwkOsqljpKDZzhmktZA7p2jX6Tt+ohIqDKqF0YZqiWs61GfbGLROiQAOGFgwivlqFWvbgfu2kgFjDP7aKz3nJEq74uCt6/SiNmzyoTrhJrhyzY93JObiL3P46lsm4JsjUvR3hnL6i9YEkGC7xW+NYWnkhRs5JeSHrSAy3F8md2kgoV5QEYjD8D2gBsxYHPEcfCqHSC7aESZhspLRBI2FEpmMouNxHTca79jwnmh7sXmG1gw24CeajXRsQ01Vq6d0p0pKEZksTc5aXOfyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=meFRSjrkfQ5GM1raLipnx6xLgcdL7PzQxOHfmcGNbL4=;
 b=W+UbysZBL8p3bL270otAgx1yv1ly/dqwlPaGki3E/hYsOTm6KJiIJAs/PzBpKpuqo62IgjSVVCAVj4jjHGlLelf5851zhaDjom44AGQo/RSfDAoRYO0WBQu7Zlio3bNgmvMJQfCE8HRLcTgvi1wridJrMEsnSaprGRXSCbfgQZQ=
Received: from DM6PR21MB1242.namprd21.prod.outlook.com (20.179.50.86) by
 DM6PR21MB1145.namprd21.prod.outlook.com (20.179.50.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.11; Mon, 19 Aug 2019 19:30:47 +0000
Received: from DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::ddd:8e5b:2930:6726]) by DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::ddd:8e5b:2930:6726%9]) with mapi id 15.20.2178.006; Mon, 19 Aug 2019
 19:30:47 +0000
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
Subject: [PATCH net-next,v2 2/6] PCI: hv: Add a Hyper-V PCI interface driver
 for software backchannel interface
Thread-Topic: [PATCH net-next,v2 2/6] PCI: hv: Add a Hyper-V PCI interface
 driver for software backchannel interface
Thread-Index: AQHVVsSZxbD4Awaly0aTwWdbXM5+xQ==
Date:   Mon, 19 Aug 2019 19:30:47 +0000
Message-ID: <1566242976-108801-3-git-send-email-haiyangz@microsoft.com>
References: <1566242976-108801-1-git-send-email-haiyangz@microsoft.com>
In-Reply-To: <1566242976-108801-1-git-send-email-haiyangz@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR12CA0059.namprd12.prod.outlook.com
 (2603:10b6:300:103::21) To DM6PR21MB1242.namprd21.prod.outlook.com
 (2603:10b6:5:169::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=lkmlhyz@microsoft.com; 
x-ms-exchange-messagesentrepresentingtype: 2
x-mailer: git-send-email 1.8.3.1
x-originating-ip: [13.77.154.182]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 395a0cee-10c2-490a-b9d4-08d724dbbc2b
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600158)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DM6PR21MB1145;
x-ms-traffictypediagnostic: DM6PR21MB1145:|DM6PR21MB1145:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR21MB1145DB9D314D331645C5C915ACA80@DM6PR21MB1145.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0134AD334F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(346002)(39860400002)(366004)(396003)(136003)(199004)(189003)(52116002)(99286004)(110136005)(76176011)(2201001)(386003)(186003)(6506007)(476003)(71190400001)(10090500001)(11346002)(22452003)(6116002)(7846003)(6512007)(6392003)(71200400001)(256004)(53936002)(81156014)(8676002)(81166006)(6436002)(4326008)(102836004)(305945005)(4720700003)(26005)(7416002)(7736002)(36756003)(6486002)(486006)(66066001)(3846002)(54906003)(66446008)(66946007)(66556008)(25786009)(14454004)(2501003)(50226002)(8936002)(64756008)(2906002)(5660300002)(2616005)(66476007)(478600001)(10290500003)(316002)(446003)(921003)(142933001)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR21MB1145;H:DM6PR21MB1242.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: fx5Jl440ZGliAFKxYmPflC60gua9x7CNaPNR1z/L+SLQyYzOPDWtmWhYcEuZFIO9OCbWY5NvcKFp6SnyaZE/Em0Z1mMbX8tHU8+W/KCcdCG48EaHSsFYmN8D05H537wS3eHYx+831awJEoIdTFBNIIt9YtkuyuTNFAcMi7phRZL8xCEdjpdp5rTNPL1DfUAn/5A6n3t98aXDPQUxVT0bZBiirLrsHm2nCaSh/d9YVP+9I3LDSsfuWwJTrfhGtwoIPXi0GuN2GgzNV8d+FT0devpaWSegFpio2KSceHBrI7acACVlUHQj7t6zRlzt3mlR/WTXQJ/Xf9Ni+mazbYY8EjMNNfGU++NQayhHOMQ5eRK37EQQSleO9mnsJbbnHDZ3L9sjEClkk9CFwaHEHY9nY5rNiX8/GZ1EvueSRei1Fmc=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 395a0cee-10c2-490a-b9d4-08d724dbbc2b
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2019 19:30:47.0494
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Pmdf91izEaz+DIVOuJb7V94cEXrY6hZH9ITth6u3XlW+kMCN1JaOEg0jc2ZkUKgJEz9Mb2JG0uSPIKjyWJMqsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1145
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
 drivers/pci/controller/pci-hyperv-intf.c | 70 ++++++++++++++++++++++++++++=
++++
 drivers/pci/controller/pci-hyperv.c      | 12 ++++--
 include/linux/hyperv.h                   | 30 ++++++++++----
 7 files changed, 111 insertions(+), 11 deletions(-)
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
index 0000000..087b7eb
--- /dev/null
+++ b/drivers/pci/controller/pci-hyperv-intf.c
@@ -0,0 +1,70 @@
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
+EXPORT_SYMBOL(hvpci_block_ops);
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
+EXPORT_SYMBOL(hyperv_read_cfg_blk);
+
+int hyperv_write_cfg_blk(struct pci_dev *dev, void *buf, unsigned int len,
+			 unsigned int block_id)
+{
+	if (!hvpci_block_ops.write_block)
+		return -EOPNOTSUPP;
+
+	return hvpci_block_ops.write_block(dev, buf, len, block_id);
+}
+EXPORT_SYMBOL(hyperv_write_cfg_blk);
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
+EXPORT_SYMBOL(hyperv_reg_block_invalidate);
+
+static void __exit exit_hv_pci_intf(void)
+{
+	pr_info("unloaded\n");
+}
+
+static int __init init_hv_pci_intf(void)
+{
+	pr_info("loaded\n");
+
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

