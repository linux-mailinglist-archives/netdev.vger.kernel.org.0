Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD91E8DDBD
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 21:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729277AbfHNTJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 15:09:09 -0400
Received: from mail-eopbgr800097.outbound.protection.outlook.com ([40.107.80.97]:42124
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728464AbfHNTJI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Aug 2019 15:09:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J8HRpINqQ8zM0UzCmM86FzDdfgFf+vVkjZC6y9r1ZF5MpK+1ocz/bK7X1tocATORwN1RVPPm2H/PPpInAat1Snwv+dEekZrHhmbYjY8yfaLjPZ7cUx1SBO3Aea0FusfLx7kOoRxSvnMskDMHTkc75urzAJ+5/HYfaFMwosoa+DirBHA0DURFBIozbePs1VRfp5BlLQF2WTpcU/HLUTOAnk+61XYLNBSYaqY7e4xO0aSr+dDth7xdFQ5PC8jFhlyc4vSagh53c9PvMnY8Im5yAv2Juc4+m13FRVk3Wm0qJMl0ZO8Hg7X70vu0FcRYag514UeEc3q61LbDUQK5EXWodg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bGzmrXcmA3867kwAbh6q5CDhxd2V5F2FxSXbpUMEpKA=;
 b=FUDeKZjjVfGK7tRQeA+Mr+2NQAEH4HhqGF/7wBqgDEkoaJX5jZ0TQB80qYrAEotj3tKILr03s5C2InsrpSpALoF52cWkbgSEuSKZjuUPIENcysn4ylXURmymkSjiKKUuCWqwvARLODL+HFbH5XFFSn0cAXpYBvT2T6G3JqVga1D6XZXY/9HFac4qIglQzZ1hmn+0efFzEtoIGr0x68FoQ76SkM1kgsT9gFvWzr7AVapVUAifdICo7YV23qACa/u7wD7HrmHLm4x92eD/mC2N2M64B9puXS7MOs0eBsBIYt8y8Z3/DAmeF/i/5zN7gMXE6QpeshjasF5N2ZysuvE9Pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bGzmrXcmA3867kwAbh6q5CDhxd2V5F2FxSXbpUMEpKA=;
 b=Wx2SN8XgAatye3n1urG2r9q5gzr5s8cHzISshup5XLLj6Ao8FoaEoGq5qCvlbEC4GCbv8V65LpBHt1R4MYN1s8s0BqpVMqaLLcwuGfe8AmnnlvtHISrN2OF+cQ3nA5/Nq2ylEeXOoJV2g57cTDqquCf20mXY85UK98Z3bhG2GBI=
Received: from DM6PR21MB1242.namprd21.prod.outlook.com (20.179.50.86) by
 DM6PR21MB1338.namprd21.prod.outlook.com (20.179.53.81) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.6; Wed, 14 Aug 2019 19:08:57 +0000
Received: from DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::ddd:8e5b:2930:6726]) by DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::ddd:8e5b:2930:6726%9]) with mapi id 15.20.2178.006; Wed, 14 Aug 2019
 19:08:57 +0000
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
Subject: [PATCH net-next, 3/6] net/mlx5: Add wrappers for HyperV PCIe
 operations
Thread-Topic: [PATCH net-next, 3/6] net/mlx5: Add wrappers for HyperV PCIe
 operations
Thread-Index: AQHVUtO4SBmL6Cl+r0K6zfGuHhNO0w==
Date:   Wed, 14 Aug 2019 19:08:57 +0000
Message-ID: <1565809632-39138-4-git-send-email-haiyangz@microsoft.com>
References: <1565809632-39138-1-git-send-email-haiyangz@microsoft.com>
In-Reply-To: <1565809632-39138-1-git-send-email-haiyangz@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR05CA0107.namprd05.prod.outlook.com
 (2603:10b6:104:1::33) To DM6PR21MB1242.namprd21.prod.outlook.com
 (2603:10b6:5:169::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=lkmlhyz@microsoft.com; 
x-ms-exchange-messagesentrepresentingtype: 2
x-mailer: git-send-email 1.8.3.1
x-originating-ip: [13.77.154.182]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7c98039a-fc85-432e-1c83-08d720eadb51
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600158)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DM6PR21MB1338;
x-ms-traffictypediagnostic: DM6PR21MB1338:|DM6PR21MB1338:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR21MB133853ED8F2256F71DD9A5CDACAD0@DM6PR21MB1338.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2449;
x-forefront-prvs: 01294F875B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(39860400002)(366004)(346002)(396003)(376002)(189003)(199004)(6486002)(110136005)(6392003)(54906003)(4326008)(10090500001)(26005)(14454004)(256004)(2906002)(53936002)(6116002)(66066001)(6436002)(3846002)(6512007)(7416002)(66476007)(66446008)(76176011)(66556008)(2201001)(64756008)(66946007)(8936002)(22452003)(71200400001)(7736002)(71190400001)(50226002)(102836004)(5660300002)(81166006)(4720700003)(446003)(316002)(478600001)(305945005)(7846003)(186003)(99286004)(2501003)(36756003)(81156014)(8676002)(25786009)(476003)(11346002)(52116002)(6506007)(2616005)(486006)(10290500003)(386003)(921003)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR21MB1338;H:DM6PR21MB1242.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: fwblQcpR+IhKPPifyWWqBl3PfGdO6sKsLE8eGa/Tvx4z+AQXy49nlzI4E6vsCEOZORydFOl4QtrkoiPHThsAAYdsruBdNZxKsFR7nUw/pj8u0xcxHu8VBpbTlqSdiJl/2Vh0/IaNbitKZvvmTwyOaa+jvsU3EQGEgueZ8NaQ0zTkWMwr/C2Fzfs3UM5nGHUSoQdRfTBTOaDTM6C2De33CyDc2u9Rsb/koIiR6Wn+q7d9DTYpyodBYVwMWDdEDnSq22QIPaQgR+mZ2sO/CpgFabEHcGz0cjQTOEIqr/BLeq6EFDKkjbFdHSgnpN+cVIP/XWpIu41fziI+gJf/gkR9lhkduLdmtVpMq+s52d76DVYpSJMSABZx/vJrfqbc9Ntzh94Kjqon2uTw/TY1FOeGM2rHr5lRy9G+qbG2E4IzwmA=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c98039a-fc85-432e-1c83-08d720eadb51
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Aug 2019 19:08:57.1735
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bkXshs/EffKHrAtU6NhvHWi8AgJNMn7hQkdpM7xJ6zazgqEjTE5LUYuT9Dk6G+w755MjfnxKBPXQ0YNd8GEo3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1338
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eran Ben Elisha <eranbe@mellanox.com>

Add wrapper functions for HyperV PCIe read / write /
block_invalidate_register operations.  This will be used as an
infrastructure in the downstream patch for software communication.

This will be enabled by default if CONFIG_PCI_HYPERV_MINI is set.

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
index 8b7edaa..a8950b1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -45,6 +45,7 @@ mlx5_core-$(CONFIG_MLX5_ESWITCH)   +=3D eswitch.o eswitch=
_offloads.o eswitch_offlo
 mlx5_core-$(CONFIG_MLX5_MPFS)      +=3D lib/mpfs.o
 mlx5_core-$(CONFIG_VXLAN)          +=3D lib/vxlan.o
 mlx5_core-$(CONFIG_PTP_1588_CLOCK) +=3D lib/clock.o
+mlx5_core-$(CONFIG_PCI_HYPERV_MINI)     +=3D lib/hv.o
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
index 0000000..7f69771
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/hv.h
@@ -0,0 +1,22 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2019 Mellanox Technologies. */
+
+#ifndef __LIB_HV_H__
+#define __LIB_HV_H__
+
+#if IS_ENABLED(CONFIG_PCI_HYPERV_MINI)
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

