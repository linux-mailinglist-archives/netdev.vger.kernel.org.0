Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9632E98AB3
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 07:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731335AbfHVFGA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 01:06:00 -0400
Received: from mail-eopbgr810109.outbound.protection.outlook.com ([40.107.81.109]:28619
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729109AbfHVFF7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 01:05:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MOC0k64VcqJ6G955mBpNWt2hpPxCnoUI+Hwqk+vpx0zGzLPj793QDXAie+2wdOJcXAqy9wfXhLzCzq01EsvfdKpz3/OWFAz6aDsMjRSmwMLgWKfdtTmjTzKpCkuMgx9qe3pr2c9mtMqhMR5eHShysHzi6jJ7DEJOpc4E9qEhk7do+L7EfoiIcLhm73Ej5IAQlovMWZGBj9azAi/F621xfGnzx79niMI/W8OJwxTKeV4t9pbCe+xP1J4crNAoR7DYndjaiR7y7gHnyHrhcFFblrVFg5zyDZb6aVIuqMM91+x5FVLjJK5R20+MWzt41KXJMAj35NDYB1Be4P8iR2xCBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W/t4pIzRFPa12ok2+YyJfBuO/icDpX+o8XSe5rTFbEY=;
 b=apQO9nEXIzvpkggNQDCfug0+QwUQdziPNSWkxPjb4zYZiP3CG8sDJZf7QTO8WsJ1t2+oyenYrlCksaEp7YDwa7JvHuLpfOYQJ8WSpqMb9PonHzxn2CS4yLQKqN5Rv46D/gOHHlc0FqOkqrUOs88O9ID+j7N3ohr2QpeqzahMAzH3JHE34vtz2yMavCFC6ne1XMd2K4Zwg4IaQw4vOFyNNzH3bsRnCq6uFpfbFfDx3XY4xYO52hj3srwBy1+bvNCp42/LchgUzIHCTMg+jnJ+pEyzJTAd0FJLDbnh9S6xtFNewvQppKFGZGiWGOVYx1aQvYZI0GriK5vllA0qKErghA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W/t4pIzRFPa12ok2+YyJfBuO/icDpX+o8XSe5rTFbEY=;
 b=ZhjIMyj76Av5Op/QmpX2ah84QsAI72fd3VJRFOAhOPvNtIDl941l2UJ14x7pKfUVxhn7KhvA2WLKSqWOHnqxH3P21EgWlfOaXFgfuQDHyxMZ7Ngurc+G5vrQ7alJsoO+if3hUKdh/rsjU7R3sK0MlGAscPG8pcfUm0Xr3zpmSpE=
Received: from MN2PR21MB1248.namprd21.prod.outlook.com (20.179.20.225) by
 MN2PR21MB1279.namprd21.prod.outlook.com (20.179.21.91) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.4; Thu, 22 Aug 2019 05:05:47 +0000
Received: from MN2PR21MB1248.namprd21.prod.outlook.com
 ([fe80::147a:ea1f:326d:832e]) by MN2PR21MB1248.namprd21.prod.outlook.com
 ([fe80::147a:ea1f:326d:832e%3]) with mapi id 15.20.2199.011; Thu, 22 Aug 2019
 05:05:47 +0000
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
Subject: [PATCH net-next,v4, 3/6] net/mlx5: Add wrappers for HyperV PCIe
 operations
Thread-Topic: [PATCH net-next,v4, 3/6] net/mlx5: Add wrappers for HyperV PCIe
 operations
Thread-Index: AQHVWKdC+LfkKjDVuEa1rKdzWh1oFA==
Date:   Thu, 22 Aug 2019 05:05:47 +0000
Message-ID: <1566450236-36757-4-git-send-email-haiyangz@microsoft.com>
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
x-ms-office365-filtering-correlation-id: d02e305d-e3af-4260-33bc-08d726be64bb
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600158)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MN2PR21MB1279;
x-ms-traffictypediagnostic: MN2PR21MB1279:|MN2PR21MB1279:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR21MB12796AC2C90B64943A76949CACA50@MN2PR21MB1279.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2449;
x-forefront-prvs: 01371B902F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(396003)(136003)(366004)(376002)(346002)(189003)(199004)(71200400001)(71190400001)(186003)(446003)(66066001)(2616005)(4326008)(36756003)(6392003)(6436002)(256004)(53936002)(7846003)(7416002)(6512007)(26005)(6486002)(11346002)(316002)(2906002)(2201001)(110136005)(22452003)(54906003)(10090500001)(476003)(25786009)(386003)(7736002)(64756008)(81156014)(66946007)(66446008)(8936002)(10290500003)(478600001)(66476007)(2501003)(102836004)(4720700003)(6116002)(3846002)(6506007)(305945005)(5660300002)(486006)(99286004)(66556008)(81166006)(14454004)(50226002)(8676002)(52116002)(76176011)(142933001)(921003)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR21MB1279;H:MN2PR21MB1248.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: e6EfDSFjMJWc5CXfvhe7UnA4zoinHJwxFs5JR/zi0xyNzf9Mm4eI72TKe6rhsJ875YfhsOu2/tIjHOOcOonxjPMnEphutxr4WHqWK/BoL5dXLidgia8BIKZWVqPXiqB27Tf61OTUG23PIHjO3NEYwpXTUcU0nmeb4Fa1HbIcb3Rfsp9I4aTXOLaKgWryePNSqBe7l+MGQdSjoLuSQ/+19CQkyNUFaCO+HDiZbqsi9WTBV7IzuU2eDYUiIeeOUfTWhwV9mrq/EDJMi+t64Hnh+NgegXDNvsMJjy0d28TrjfpfAlOSkNvAEKo6oEStCIkKarjnYR9zsGCPvuotZIXl5Er0mFnwI8zZrpsp1boXtClFlyfyEwdU6bUcNTikWsirXFNJv7uadNFvfGtaY6y9xHCl9tgSJFxJ5xJrsYYTDxA=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d02e305d-e3af-4260-33bc-08d726be64bb
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2019 05:05:47.3945
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qB4LYSMUczPlE/pQgjYddxDbu82GvF5vxkdJcL8I74erF1VCBU2SbkgPil6EHuvumJZA1eHDi4JXgvqO4A+jbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR21MB1279
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
index 0000000..cf08d02
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
+	if (read)
+		rc |=3D !(len =3D=3D bytes_returned);
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

