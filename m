Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 982319A2D1
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 00:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405098AbfHVW0i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 18:26:38 -0400
Received: from mail-eopbgr710095.outbound.protection.outlook.com ([40.107.71.95]:36096
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404932AbfHVW0h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 18:26:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TEwkD24+695bf32Pi2DkjIM7pHp5DxaqR6CJ9S6iQ0D4+lerWAy3z35FLhIncjNGyriviMAIqYtPnAYQEKtsm/F9aA9p5gwv/GpjtqPZVhTpGuxKY3b1VyFzXpxQY8QrZBndobbzfj7ABA3yCsa0iEBleEN2e7nUJ3800KUV/2gBOZ/2N4Ur637jAfNF8di/xCcoUBgig1jOj2M6q7XiC8k7JNLfxGlAWHL/2IVHZnNJrFSQKSRz/AO5p/CasE+bXDs1tA0hwRndkhcpIU25LPc8H3clMYCoRNqnRKe4OHg1GN/FexG5rJA9wTelJeFwIpZTfjq41vJutPQnEPGoOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vFpWVYVOJ/+F+1i8ZZyZZQbKt7GmHXpaAjE52mcQGf4=;
 b=RRj2X5pgJM8j91NjGuP5tYR4rLNfPrJSyld6SkciQjQVnIRtVm+QP+Czfk0KhTYpmH64NCl+aGgO+Wzykr5oA5OwEfn7SeAiMYeOSKbq6HhTureKLyaYVdLife4znjbUIBl1pqeXKxi1sUAKfr5vLlybgTJHXw+VAAzh6fFUpOLY/p7Y5O+xyz9WMmOPz1bES8ALheEm3YV5lIefSQXE7QU1kJRqkxvgkT8MEddosg1A8s11WYq++21nbHw7+YzMFlkw+WZrA4QGW4vNv/cr7totxkyYNZz1ZvVLCQrECB7UzBmw5Jpdg0WvHDfDJ+oLAdOKEh9xsDBsGhuJ9QpI7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vFpWVYVOJ/+F+1i8ZZyZZQbKt7GmHXpaAjE52mcQGf4=;
 b=EqnCY4e7l9/8lIV3i0vsXWLUpQMZ3sapLS4YmtWQ2lZxEScmdewGwLDpd9Vr8CEicdHdZb61QCQUcm5EOaekRFdW6GvCgNM4BQ31YJ56TaMjkZoR/OUGKpXmBs+I+UUr/Hf1YeSeLkjB1IsRn/U9q+pMwMO9WrqeYObdPS9B8R8=
Received: from DM6PR21MB1242.namprd21.prod.outlook.com (20.179.50.86) by
 DM6PR21MB1449.namprd21.prod.outlook.com (20.180.23.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.3; Thu, 22 Aug 2019 22:26:34 +0000
Received: from DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::d44f:19d0:c437:5785]) by DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::d44f:19d0:c437:5785%7]) with mapi id 15.20.2220.009; Thu, 22 Aug 2019
 22:26:34 +0000
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
Subject: [PATCH net-next,v5, 3/6] net/mlx5: Add wrappers for HyperV PCIe
 operations
Thread-Topic: [PATCH net-next,v5, 3/6] net/mlx5: Add wrappers for HyperV PCIe
 operations
Thread-Index: AQHVWTinwT5aaCHK/UKITvctTZLxMQ==
Date:   Thu, 22 Aug 2019 22:26:34 +0000
Message-ID: <1566512708-13785-4-git-send-email-haiyangz@microsoft.com>
References: <1566512708-13785-1-git-send-email-haiyangz@microsoft.com>
In-Reply-To: <1566512708-13785-1-git-send-email-haiyangz@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR19CA0092.namprd19.prod.outlook.com
 (2603:10b6:320:1f::30) To DM6PR21MB1242.namprd21.prod.outlook.com
 (2603:10b6:5:169::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=lkmlhyz@microsoft.com; 
x-ms-exchange-messagesentrepresentingtype: 2
x-mailer: git-send-email 1.8.3.1
x-originating-ip: [13.77.154.182]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2ff4ca92-b0e6-4788-145e-08d7274fca3e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR21MB1449;
x-ms-traffictypediagnostic: DM6PR21MB1449:|DM6PR21MB1449:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR21MB1449BCE64BE14E1DBFAD9389ACA50@DM6PR21MB1449.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2449;
x-forefront-prvs: 01371B902F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(136003)(396003)(366004)(376002)(39860400002)(199004)(189003)(186003)(71200400001)(2201001)(52116002)(305945005)(8676002)(5660300002)(102836004)(81156014)(6436002)(6506007)(36756003)(386003)(7846003)(99286004)(8936002)(10090500001)(53936002)(81166006)(2501003)(76176011)(66066001)(478600001)(4720700003)(6486002)(7736002)(26005)(2906002)(25786009)(11346002)(446003)(2616005)(256004)(14454004)(10290500003)(486006)(54906003)(110136005)(3846002)(6116002)(6392003)(66446008)(64756008)(66556008)(66476007)(66946007)(50226002)(7416002)(71190400001)(316002)(4326008)(22452003)(6512007)(476003)(921003)(142933001)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR21MB1449;H:DM6PR21MB1242.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: nJ2DBPqNCLl8nAPb/kZlbkqN1sLeP43j9V+H2eF4A0TUurV/qUoMQBBL/VlMQpqu3DPI9lrQrTfkessrIrEIoWtINXo1x3y3MellTD0KyfRB+S/jbDegfyDSVfzMXVfz4QdlNRlpBBoCWw+6621UCkaxT+5pnnqatx0eHhxDgU+gVLNuUz0aKR98HO+nc69AMTC899+j5JL7D5tguc7YagKZaQEGBIhD9E6B7cLIXxZgDfonucSc9BKK8ZdrPDrZAUP5biYObu/EG67oisS/Qi2OdyGV85yMrlmQIy20/4Rb4UnPdc1ykfZnWHqkJZjKmz137C6ZLqx8QICMIV6BwjVGFY2wiGXG6z2N9eW70cKqg1nJgAmxTd899i2WZmnP/IEmqfnmsMw2STuH1QO2D9bTBVqrcb9ql063CbHKZ+A=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ff4ca92-b0e6-4788-145e-08d7274fca3e
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2019 22:26:34.7588
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: x4D36cYMNXl2RpcdslokSn1d8dcNj58meNDjAPyDNKEND0k1wmbs9MxEPSgkmNZkncyCl2vEXks3YQ11azTNOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1449
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eran Ben Elisha <eranbe@mellanox.com>

Add wrapper functions for HyperV PCIe read / write /
block_invalidate_register operations.  This will be used as an
infrastructure in the downstream patch for software communication.

This will be enabled by default if CONFIG_PCI_HYPERV_INTERFACE is set.

Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/Makefile |  1 +
 drivers/net/ethernet/mellanox/mlx5/core/lib/hv.c | 64 ++++++++++++++++++++=
++++
 drivers/net/ethernet/mellanox/mlx5/core/lib/hv.h | 22 ++++++++
 3 files changed, 87 insertions(+)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/hv.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/hv.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net=
/ethernet/mellanox/mlx5/core/Makefile
index bcf3655..fd32a5b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -45,6 +45,7 @@ mlx5_core-$(CONFIG_MLX5_ESWITCH)   +=3D eswitch.o eswitch=
_offloads.o eswitch_offlo
 mlx5_core-$(CONFIG_MLX5_MPFS)      +=3D lib/mpfs.o
 mlx5_core-$(CONFIG_VXLAN)          +=3D lib/vxlan.o
 mlx5_core-$(CONFIG_PTP_1588_CLOCK) +=3D lib/clock.o
+mlx5_core-$(CONFIG_PCI_HYPERV_INTERFACE) +=3D lib/hv.o
=20
 #
 # Ipoib netdev
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/hv.c b/drivers/net=
/ethernet/mellanox/mlx5/core/lib/hv.c
new file mode 100644
index 0000000..fb19008
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/hv.c
@@ -0,0 +1,64 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+// Copyright (c) 2018 Mellanox Technologies
+
+#include <linux/hyperv.h>
+#include "mlx5_core.h"
+#include "lib/hv.h"
+
+static int mlx5_hv_config_common(struct mlx5_core_dev *dev, void *buf, int=
 len,
+				 int offset, bool read)
+{
+	int rc =3D -EOPNOTSUPP;
+	int bytes_returned;
+	int block_id;
+
+	if (offset % HV_CONFIG_BLOCK_SIZE_MAX || len % HV_CONFIG_BLOCK_SIZE_MAX)
+		return -EINVAL;
+
+	block_id =3D offset / HV_CONFIG_BLOCK_SIZE_MAX;
+
+	rc =3D read ?
+	     hyperv_read_cfg_blk(dev->pdev, buf,
+				 HV_CONFIG_BLOCK_SIZE_MAX, block_id,
+				 &bytes_returned) :
+	     hyperv_write_cfg_blk(dev->pdev, buf,
+				  HV_CONFIG_BLOCK_SIZE_MAX, block_id);
+
+	/* Make sure len bytes were read successfully  */
+	if (read && !rc && len !=3D bytes_returned)
+		rc =3D -EIO;
+
+	if (rc) {
+		mlx5_core_err(dev, "Failed to %s hv config, err =3D %d, len =3D %d, offs=
et =3D %d\n",
+			      read ? "read" : "write", rc, len,
+			      offset);
+		return rc;
+	}
+
+	return 0;
+}
+
+int mlx5_hv_read_config(struct mlx5_core_dev *dev, void *buf, int len,
+			int offset)
+{
+	return mlx5_hv_config_common(dev, buf, len, offset, true);
+}
+
+int mlx5_hv_write_config(struct mlx5_core_dev *dev, void *buf, int len,
+			 int offset)
+{
+	return mlx5_hv_config_common(dev, buf, len, offset, false);
+}
+
+int mlx5_hv_register_invalidate(struct mlx5_core_dev *dev, void *context,
+				void (*block_invalidate)(void *context,
+							 u64 block_mask))
+{
+	return hyperv_reg_block_invalidate(dev->pdev, context,
+					   block_invalidate);
+}
+
+void mlx5_hv_unregister_invalidate(struct mlx5_core_dev *dev)
+{
+	hyperv_reg_block_invalidate(dev->pdev, NULL, NULL);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/hv.h b/drivers/net=
/ethernet/mellanox/mlx5/core/lib/hv.h
new file mode 100644
index 0000000..f9a4557
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/hv.h
@@ -0,0 +1,22 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2019 Mellanox Technologies. */
+
+#ifndef __LIB_HV_H__
+#define __LIB_HV_H__
+
+#if IS_ENABLED(CONFIG_PCI_HYPERV_INTERFACE)
+
+#include <linux/hyperv.h>
+#include <linux/mlx5/driver.h>
+
+int mlx5_hv_read_config(struct mlx5_core_dev *dev, void *buf, int len,
+			int offset);
+int mlx5_hv_write_config(struct mlx5_core_dev *dev, void *buf, int len,
+			 int offset);
+int mlx5_hv_register_invalidate(struct mlx5_core_dev *dev, void *context,
+				void (*block_invalidate)(void *context,
+							 u64 block_mask));
+void mlx5_hv_unregister_invalidate(struct mlx5_core_dev *dev);
+#endif
+
+#endif /* __LIB_HV_H__ */
--=20
1.8.3.1

