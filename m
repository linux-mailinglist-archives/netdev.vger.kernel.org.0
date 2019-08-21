Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71AA196E46
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 02:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbfHUAXl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 20:23:41 -0400
Received: from mail-eopbgr680114.outbound.protection.outlook.com ([40.107.68.114]:56135
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726141AbfHUAXk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 20:23:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EShL0ZDSBfGwO8Qgvcd2TFn3boLUaEBe4QEkGAAQ8eLXVcCNkYMUpFSdv03qWB6nmKiDNSce6pqRpJ6upWOCP5hA9BBgSSS2d5plOHHoEmf85vEpdyO+29vQCWLW9v1ri24XsAtYx9JyegOIjxAu8FkfpdLRHNirc/5hV2Ty+3Sh4oL1bTek/GiZW8p8lVZjrsr1gCSnykwmEJNpqFwRyAkRYL2ktWbTI6woZ3OZDvRq6Za7UeTXZb6kcngkD96t1s7SKJQRfmjd/3D6V6pPAz6aKqwKCtP8gjANyVwwQ6eP0twA2Twl5rF/KLxOm1YmpwQIuKXYpYFYsFRk3nFLrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f95h9yNoJs6M/KfkEg5vCUlvrsdMDngwiSz2vZA6iSo=;
 b=LGpjcx9OCQF+oH8SolGkDkfRGKppW6ZSym9imEgxy2h6CMmimbh72fNBAFTnd1RUGvglWGHOTG/cvg58MsYHbB784rkNUUl7gOQISbazPxNjKBNQWFn8qnXYwYyZtcJSNdwlFOUH/xBjAPho5HCPv6ILMNuB8fHtmt3bElD3WuCYwoJRW12W7l8kzpb8AFdRq5MlX/Bdtuc2AKq7CpY0uVtp+aA7LoFD15yk/WXREWK1UWii0pTw+ChYS+r73hhpnEVBCrqGU+b7tvctwIUs/UCz2JexbxWgnhJS5iARgU06Nhzgrgod7bWpy3mKPlqGty0VO23UCY+jYVMEgFxENw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f95h9yNoJs6M/KfkEg5vCUlvrsdMDngwiSz2vZA6iSo=;
 b=GM2M9DJeYMfsfOuwvXVR6sCE6AvL6hhe/3lhpoGhS7ev7Lkv79p06IwpJ57Cz6uL0qVLuxAb/yg6U6sKQp/G1yiFNnF2cIaf+MrSyRbk2QLjgGVix0y2DZv8vFXvMgGOTsjv8YN7FEACmcHfTl57WYnidRQ/diAGukA808a1O6s=
Received: from DM6PR21MB1242.namprd21.prod.outlook.com (20.179.50.86) by
 DM6PR21MB1450.namprd21.prod.outlook.com (10.255.109.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.3; Wed, 21 Aug 2019 00:23:35 +0000
Received: from DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::ddd:8e5b:2930:6726]) by DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::ddd:8e5b:2930:6726%9]) with mapi id 15.20.2178.006; Wed, 21 Aug 2019
 00:23:35 +0000
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
Subject: [PATCH net-next,v3, 3/6] net/mlx5: Add wrappers for HyperV PCIe
 operations
Thread-Topic: [PATCH net-next,v3, 3/6] net/mlx5: Add wrappers for HyperV PCIe
 operations
Thread-Index: AQHVV7ar9gXApn0byUGqBSTGbqhmBQ==
Date:   Wed, 21 Aug 2019 00:23:34 +0000
Message-ID: <1566346948-69497-4-git-send-email-haiyangz@microsoft.com>
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
x-ms-office365-filtering-correlation-id: 075aba91-86c9-4968-a3f7-08d725cdcdcc
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600158)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DM6PR21MB1450;
x-ms-traffictypediagnostic: DM6PR21MB1450:|DM6PR21MB1450:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR21MB1450F970CF6167209330E9FDACAA0@DM6PR21MB1450.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2449;
x-forefront-prvs: 0136C1DDA4
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(39860400002)(136003)(366004)(346002)(396003)(189003)(199004)(26005)(2906002)(71190400001)(71200400001)(6512007)(50226002)(186003)(36756003)(54906003)(8676002)(110136005)(6436002)(6392003)(7846003)(8936002)(99286004)(446003)(6506007)(81166006)(81156014)(2201001)(386003)(6486002)(76176011)(7416002)(66066001)(5660300002)(52116002)(102836004)(11346002)(316002)(53936002)(6116002)(3846002)(22452003)(478600001)(4326008)(256004)(66946007)(66476007)(66556008)(64756008)(66446008)(2616005)(476003)(486006)(305945005)(25786009)(10090500001)(4720700003)(14454004)(10290500003)(2501003)(7736002)(921003)(142933001)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR21MB1450;H:DM6PR21MB1242.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: xHi5st3kGC4kshDcu48oQdapDUcRNoDMh26RH/nOPxkJpsMLjIReNc9jIKGOo3H3JOYAeYoSK+SJmJMNFU6y459e5s3Oikg2Ze036lwDG/4t0mGaKZ6ZLMOe9fZZMgHjEbe9+ZfzYBjvquUmPJ5cyNMm3B5Vh+QmDgbGwnuTT6gqT+R61jBBomFibOU+9xVFiR8k9nn7e/Gt1OoN+PVI2sVN6l8zd5FALYEOLk0hOZtAoAzg+BufanmYnOvhr8oyeDrxYPI343BcbTn+D7utOP+pcsH0rLh9pPVMX6d2PjrGbdlwJ/in+rfuF47o4vdBzsah7rZXS6M2qg0rDClFz/SkUo76ZItI5wEt9bQLe85z+TBUbtoEhWKoPT0O5cBaNVKbdMKht9U4oH6triYItty5qMt5Jq/xIQS1ZQldWC4=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 075aba91-86c9-4968-a3f7-08d725cdcdcc
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Aug 2019 00:23:34.9487
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9op4h0+nE/vGGXKqVZiXonkCVNhReeAF0pQszJRi4JLpgS96ftGepdEdSUYQTkp3fUdD19GegyVS9al4X1rYUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1450
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
index 8b7edaa..247295b 100644
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

