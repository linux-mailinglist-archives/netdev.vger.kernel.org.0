Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44B1C94E31
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 21:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728611AbfHSTa5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 15:30:57 -0400
Received: from mail-eopbgr700099.outbound.protection.outlook.com ([40.107.70.99]:43875
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728348AbfHSTa4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Aug 2019 15:30:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gNr6bb89O8qP9ZuQcUr0hEp/tDMBdHWNVeoLqmtvSHJGsKMWk4TXmE6EOgPFWWJyvPpNIFfZ3EyYsxTRq36evaD/GJqIA2DaKHyvmBu4MtgVAVZ4l8kQ3uISzZTI8tOxKRqcaHU/ZWfjhGQJdIbqRM+eV5rCd3mUFicfV2kjDswUmwfePf3U7zalDyGDm6JMQ075Wq1Iein4osP0qqyb3IwV8nMUn1vSWqwb5GNoy/ODUQS4XDNaiGHEEK4D63efWFjrRAJdZg2N0gMlbz+HeQGPlUm8lOf9lfSDrgbd/vqmWtMJtRerB6ndD+gYESwiC65LdFwdQ4p8fLfZDiZfyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f95h9yNoJs6M/KfkEg5vCUlvrsdMDngwiSz2vZA6iSo=;
 b=TDY3LnDtr7Zar+7K34fxurLggzgr2Jy+ZjQiHR+D0wJMmJ/RPk6+B2YX/HHRiJy7sR22WqvK7ZHVd+40GkmOELoChSm6J3QYA32erXE+3vw53iAdKemrp4zsSyCs0zc3hoB+SubzHKkXXFOdkT/KrOEF8bDa6A5JKV8Z601KIMjlk67Eay+VeVuf2GQqNHZjwh5GgQYjxDzGcBKX4jbBuTUyJrkukC/HMa3sePH8Pj9TUFR/R+Z9ZJ5sSBVixfOTIuMtwnxWG3T3sDL1WZv7pRpvdVhtRtPZeXKi9a7KfE6axVkhOzevQrvCOA9yVwdbEdPBWv3AB5p2s8JSd8WLXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f95h9yNoJs6M/KfkEg5vCUlvrsdMDngwiSz2vZA6iSo=;
 b=X+b6qErfZrU+nFTe90/Mb3jboA6HtMwnth8yw5FZjS9arZwgGUzWp8fQuwhdsNsnsZUIg3cqaXZ9PxiXKhWhUblexI+lAdUtgIPwkqi5wbkWJDMySVUkZ4tTxyeRLI0muI/ZLxpHyOvX5l/wG8gvKGIVQlEA6OAh+hTo0d3aML8=
Received: from DM6PR21MB1242.namprd21.prod.outlook.com (20.179.50.86) by
 DM6PR21MB1145.namprd21.prod.outlook.com (20.179.50.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.11; Mon, 19 Aug 2019 19:30:52 +0000
Received: from DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::ddd:8e5b:2930:6726]) by DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::ddd:8e5b:2930:6726%9]) with mapi id 15.20.2178.006; Mon, 19 Aug 2019
 19:30:52 +0000
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
Subject: [PATCH net-next,v2 3/6] net/mlx5: Add wrappers for HyperV PCIe
 operations
Thread-Topic: [PATCH net-next,v2 3/6] net/mlx5: Add wrappers for HyperV PCIe
 operations
Thread-Index: AQHVVsSdJ36dPGYgDEegIU5DCBZYUw==
Date:   Mon, 19 Aug 2019 19:30:52 +0000
Message-ID: <1566242976-108801-4-git-send-email-haiyangz@microsoft.com>
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
x-ms-office365-filtering-correlation-id: b22b323f-8fc4-4f52-4c99-08d724dbbf86
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600158)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DM6PR21MB1145;
x-ms-traffictypediagnostic: DM6PR21MB1145:|DM6PR21MB1145:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR21MB1145F4138F9C7860D038D100ACA80@DM6PR21MB1145.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2449;
x-forefront-prvs: 0134AD334F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(346002)(39860400002)(366004)(396003)(136003)(199004)(189003)(52116002)(99286004)(110136005)(76176011)(2201001)(386003)(186003)(6506007)(476003)(71190400001)(10090500001)(11346002)(22452003)(6116002)(7846003)(6512007)(6392003)(71200400001)(256004)(53936002)(81156014)(8676002)(81166006)(6436002)(4326008)(102836004)(305945005)(4720700003)(26005)(7416002)(7736002)(36756003)(6486002)(486006)(66066001)(3846002)(54906003)(66446008)(66946007)(66556008)(25786009)(14454004)(2501003)(50226002)(8936002)(64756008)(2906002)(5660300002)(2616005)(66476007)(478600001)(10290500003)(316002)(446003)(921003)(142933001)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR21MB1145;H:DM6PR21MB1242.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 5/ZubkahAYktCzVv/CB7Gt9MAf0Kz2aW3Aq8sYI4mMAq6u38QTSx+k+7ShGKjwy5FL9dzD3rJDTXNkImeow9jVKOxyPwI2WbSjDD8sYpv52YZOKCDX3/F4SpsSrxlgpinWRRpx0iHvRGsHqfKduui5RoXpXSdahpFoB+TMLPEH6ZTwrWLAwQDhrQG1/TSZ1Gq43iDcGj/Yty+SrcNlgYXNOjyfnkXbUB8WThfjtgst0YZ+KbR1tJ5r+/vbrqs7p9wd+hMlhYZFdGOTpxm3A4LRrjzkP4742Gu7KT7moA8gCxQAsoyfJhecN4cWPuWoAITJFv6HeyR8uYiIetmulY19qTIz/nQDWHTvVOfzhBgRSiMGaP578gihh26ENWcqj2RJGYf1AgM9tJ4F6Z5fH9VuHPwFgdKahHxCypKLuaLOM=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b22b323f-8fc4-4f52-4c99-08d724dbbf86
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2019 19:30:52.7151
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YLmMh6VOp/ZysTQhWHYu46FHBF8yk8OOnc4CykWFUJaB8oFvkz0eUttvfNvQQ+dL58H9ZnKTNLrikiGJE5rwSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1145
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

