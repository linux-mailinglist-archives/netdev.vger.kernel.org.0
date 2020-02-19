Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33DB0163B0D
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 04:23:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbgBSDXL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 22:23:11 -0500
Received: from mail-db8eur05on2089.outbound.protection.outlook.com ([40.107.20.89]:22272
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726346AbgBSDXK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Feb 2020 22:23:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WPcpffIwHKaWTUYB9BIpCgYUYsRGGNdvd0KNRYjaHwFiNhDmrnK8SMKKKaBYoGwdAD/aE1NpTUyOOyFnoPkqe9XfOPW7bYFWreCAjyhHRG0FbGORFmykBgrAunBK8nYv6712kYy0S1Bh/BzOwDhHBEQLMhUH7Dj00jbVlDz53cqz5CdwkbboqEX23ai8TWehqAZUivLnxG/gJ7hjZ8JdtEflwzRKhYlmBk2np0UCTn7xyoTfOQsC+YsQcKYqnaJkkfQufBWfM1iXNPOhuIjZPHWCLu+L/uou84YhXbIktyvvsoBfaR9R2q6eOPscfl2voPGMbkGaq4qPH6PFYTDjPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=odq9fTf3Q00xH33RYuBqMfj80YUg69Y+9gr7R6vBqUs=;
 b=dj2awrWXYGLOc0glKrFj8fCZ0Hw4YiS03SJ7Y5Aa01u1yE3dsg5vRBDuEbHJme9JCIOtkGGgqVsL4fgBhbG5f6fjZVt47TErQQEJVwPoVEdBJi+YOazk4UjUd9ydsmEi3ZDdkbep6YQY3Exh1yYTtv7hAXdHl/1ZzxD/MK703vfa2hsijReJ/W4TVY9EyIZaU+ywo9K3S9SyXmTWB4nSQrU7xHWcUeyjxVRlmFoj7jdmfcwF3XB4ECfx7Em6iXoIbOIJ4SsCYgzzlR523fv2+XSojObZYByqyV0osnBXQ+B8jy3phoIpFPXnstoI/oUv6e05HVP/0c2KsMwA3PEzyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=odq9fTf3Q00xH33RYuBqMfj80YUg69Y+9gr7R6vBqUs=;
 b=qHwt2XcmqxVAmcE/ooOvrmxtddtQVwJiP/YXZXNAynccT0eCFaD2aGK3EEbJqUmII4mcXaRwsfrNp3D027bc0/FfojLmh2QjnV/Js+8J7PgT9CCDlC+0zCAOuEndcv6UKzKCkMjieaHHGNeb6xNmrDLkbhwjaoy0LY+xPqqxHPE=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4590.eurprd05.prod.outlook.com (20.176.5.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.27; Wed, 19 Feb 2020 03:23:03 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2729.028; Wed, 19 Feb 2020
 03:23:03 +0000
Received: from smtp.office365.com (73.15.39.150) by BYAPR02CA0001.namprd02.prod.outlook.com (2603:10b6:a02:ee::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.22 via Frontend Transport; Wed, 19 Feb 2020 03:23:01 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V4 02/13] net/mlx5: Add support for resource dump
Thread-Topic: [net-next V4 02/13] net/mlx5: Add support for resource dump
Thread-Index: AQHV5tPlAkz8JWkyeUyUjGAuJOyIMA==
Date:   Wed, 19 Feb 2020 03:23:03 +0000
Message-ID: <20200219032205.15264-3-saeedm@mellanox.com>
References: <20200219032205.15264-1-saeedm@mellanox.com>
In-Reply-To: <20200219032205.15264-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BYAPR02CA0001.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::14) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d1932a73-b99b-48f4-a066-08d7b4eb07a1
x-ms-traffictypediagnostic: VI1PR05MB4590:|VI1PR05MB4590:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB4590600A82761CD96A6073DDBE100@VI1PR05MB4590.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1332;
x-forefront-prvs: 0318501FAE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(376002)(396003)(136003)(39860400002)(189003)(199004)(2616005)(956004)(16526019)(186003)(478600001)(66446008)(66556008)(71200400001)(26005)(86362001)(66946007)(66476007)(6512007)(36756003)(6486002)(64756008)(107886003)(4326008)(110136005)(8676002)(2906002)(5660300002)(316002)(54906003)(8936002)(52116002)(30864003)(81156014)(81166006)(6506007)(1076003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4590;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bTcDXEx26FnmbKweOjMkMixMi/vEbAvP4FwUZc9JouIu1M6CIewK3mZkb68mmgDIB28zylQZlTIggIK+3CFc97ehXLck7ccXbYN+EhSUZJMB+s7LJM/Rr0HpRq5ltZRL3chruHdDfkdA7Cgq7RkrpYEJUmBXMVZADwsuVZ3j5pVcPPzCog2i0VjLnmuiBY6+psKKvBiAY7kCtrFQOp15iKybwswLKXLeBEJ/6P/frtQmsVAaRBo+Ad8ccdSsxIr+JgE0nW8YxfW7YlE79OVLR5LsYCnD3OhEskOVmw7Lw+jZ5eko/4YNqiCvmXf67i45u8NgZmYu+QwGclcylZB7/upDO/PyULkJDoosvlUnGO1JrPx9G+mu6zJQ6TI2eM+qiWvkQKbGbBYKLrZUYqBbs2ELmxxGchC4CFjooV8CDH3WTQsvPO8yU41PAN5zrSNqHQH6SBl20MMhYUK+g/sh7BotG3u0IAu4vtAZy4ZM6iXrjEBfa2NxHj4EI+ivk6J+zjgkzM0CVUfQuifS6opfMn1qwP14rjKxDuqTdfEeasQ=
x-ms-exchange-antispam-messagedata: 4xwJ9QTC0Klj6OYxqX6jpp4NsrJ0aKwjTftEv21mnCb40NxLc+X4nrTYLU5pdkb38ZqYYZcfw5uQQHpjJmkB8g1Luo5MGbP/9ZYfWsqsL89/FnDfTVUrxuq2d6ybi3y/cQhyk0QqR1srq2hcBU5vnQ==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1932a73-b99b-48f4-a066-08d7b4eb07a1
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Feb 2020 03:23:03.5870
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OlCawkKttvJQPSVnyc9Ri3w/jymm1Cc+k/bpOpn5AAzp2SVWRKRUtJ+kfkGFoCha7dIOfN/WpQtaop73BCfEIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4590
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

On driver load:
- Initialize resource dump data structure and memory access tools (mkey
  & pd).
- Read the resource dump's menu which contains the FW segment
  identifier. Each record is identified by the segment name (ASCII).

During the driver's course of life, users (like reporters) may request
dumps per segment. The user should create a command providing the
segment identifier (SW enumeration) and command keys. In return, the
user receives a command context. In order to receive the dump, the user
should supply the command context and a memory (aligned to a PAGE) on
which the dump content will be written. Since the dump may be larger
than the given memory, the user may resubmit the command until received
an indication of end-of-dump. It is the user's responsibility to destroy
the command.

Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
 .../mellanox/mlx5/core/diag/rsc_dump.c        | 286 ++++++++++++++++++
 .../mellanox/mlx5/core/diag/rsc_dump.h        |  58 ++++
 .../net/ethernet/mellanox/mlx5/core/main.c    |  12 +
 include/linux/mlx5/driver.h                   |   1 +
 5 files changed, 358 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net=
/ethernet/mellanox/mlx5/core/Makefile
index d3e06cec8317..e0bb8e12356e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -16,7 +16,7 @@ mlx5_core-y :=3D	main.o cmd.o debugfs.o fw.o eq.o uar.o p=
agealloc.o \
 		transobj.o vport.o sriov.o fs_cmd.o fs_core.o pci_irq.o \
 		fs_counters.o rl.o lag.o dev.o events.o wq.o lib/gid.o \
 		lib/devcom.o lib/pci_vsc.o lib/dm.o diag/fs_tracepoint.o \
-		diag/fw_tracer.o diag/crdump.o devlink.o
+		diag/fw_tracer.o diag/crdump.o devlink.o diag/rsc_dump.o
=20
 #
 # Netdev basic
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.c b/driv=
ers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.c
new file mode 100644
index 000000000000..17ab7efe693d
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.c
@@ -0,0 +1,286 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2019 Mellanox Technologies. */
+
+#include "rsc_dump.h"
+#include "lib/mlx5.h"
+
+#define MLX5_SGMT_TYPE(SGMT) MLX5_SGMT_TYPE_##SGMT
+#define MLX5_SGMT_STR_ASSING(SGMT)[MLX5_SGMT_TYPE(SGMT)] =3D #SGMT
+static const char *const mlx5_rsc_sgmt_name[] =3D {
+	MLX5_SGMT_STR_ASSING(HW_CQPC),
+	MLX5_SGMT_STR_ASSING(HW_SQPC),
+	MLX5_SGMT_STR_ASSING(HW_RQPC),
+	MLX5_SGMT_STR_ASSING(FULL_SRQC),
+	MLX5_SGMT_STR_ASSING(FULL_CQC),
+	MLX5_SGMT_STR_ASSING(FULL_EQC),
+	MLX5_SGMT_STR_ASSING(FULL_QPC),
+	MLX5_SGMT_STR_ASSING(SND_BUFF),
+	MLX5_SGMT_STR_ASSING(RCV_BUFF),
+	MLX5_SGMT_STR_ASSING(SRQ_BUFF),
+	MLX5_SGMT_STR_ASSING(CQ_BUFF),
+	MLX5_SGMT_STR_ASSING(EQ_BUFF),
+	MLX5_SGMT_STR_ASSING(SX_SLICE),
+	MLX5_SGMT_STR_ASSING(SX_SLICE_ALL),
+	MLX5_SGMT_STR_ASSING(RDB),
+	MLX5_SGMT_STR_ASSING(RX_SLICE_ALL),
+};
+
+struct mlx5_rsc_dump {
+	u32 pdn;
+	struct mlx5_core_mkey mkey;
+	u16 fw_segment_type[MLX5_SGMT_TYPE_NUM];
+};
+
+struct mlx5_rsc_dump_cmd {
+	u64 mem_size;
+	u8 cmd[MLX5_ST_SZ_BYTES(resource_dump)];
+};
+
+static int mlx5_rsc_dump_sgmt_get_by_name(char *name)
+{
+	int i;
+
+	for (i =3D 0; i < ARRAY_SIZE(mlx5_rsc_sgmt_name); i++)
+		if (!strcmp(name, mlx5_rsc_sgmt_name[i]))
+			return i;
+
+	return -EINVAL;
+}
+
+static void mlx5_rsc_dump_read_menu_sgmt(struct mlx5_rsc_dump *rsc_dump, s=
truct page *page)
+{
+	void *data =3D page_address(page);
+	enum mlx5_sgmt_type sgmt_idx;
+	int num_of_items;
+	char *sgmt_name;
+	void *member;
+	void *menu;
+	int i;
+
+	menu =3D MLX5_ADDR_OF(menu_resource_dump_response, data, menu);
+	num_of_items =3D MLX5_GET(resource_dump_menu_segment, menu, num_of_record=
s);
+
+	for (i =3D 0; i < num_of_items; i++) {
+		member =3D MLX5_ADDR_OF(resource_dump_menu_segment, menu, record[i]);
+		sgmt_name =3D  MLX5_ADDR_OF(resource_dump_menu_record, member, segment_n=
ame);
+		sgmt_idx =3D mlx5_rsc_dump_sgmt_get_by_name(sgmt_name);
+		if (sgmt_idx =3D=3D -EINVAL)
+			continue;
+		rsc_dump->fw_segment_type[sgmt_idx] =3D MLX5_GET(resource_dump_menu_reco=
rd,
+							       member, segment_type);
+	}
+}
+
+static int mlx5_rsc_dump_trigger(struct mlx5_core_dev *dev, struct mlx5_rs=
c_dump_cmd *cmd,
+				 struct page *page)
+{
+	struct mlx5_rsc_dump *rsc_dump =3D dev->rsc_dump;
+	struct device *ddev =3D &dev->pdev->dev;
+	u32 out_seq_num;
+	u32 in_seq_num;
+	dma_addr_t dma;
+	int err;
+
+	dma =3D dma_map_page(ddev, page, 0, cmd->mem_size, DMA_FROM_DEVICE);
+	if (unlikely(dma_mapping_error(ddev, dma)))
+		return -ENOMEM;
+
+	in_seq_num =3D MLX5_GET(resource_dump, cmd->cmd, seq_num);
+	MLX5_SET(resource_dump, cmd->cmd, mkey, rsc_dump->mkey.key);
+	MLX5_SET64(resource_dump, cmd->cmd, address, dma);
+
+	err =3D mlx5_core_access_reg(dev, cmd->cmd, sizeof(cmd->cmd), cmd->cmd,
+				   sizeof(cmd->cmd), MLX5_REG_RESOURCE_DUMP, 0, 1);
+	if (err) {
+		mlx5_core_err(dev, "Resource dump: Failed to access err %d\n", err);
+		goto out;
+	}
+	out_seq_num =3D MLX5_GET(resource_dump, cmd->cmd, seq_num);
+	if (out_seq_num && (in_seq_num + 1 !=3D out_seq_num))
+		err =3D -EIO;
+out:
+	dma_unmap_page(ddev, dma, cmd->mem_size, DMA_FROM_DEVICE);
+	return err;
+}
+
+struct mlx5_rsc_dump_cmd *mlx5_rsc_dump_cmd_create(struct mlx5_core_dev *d=
ev,
+						   struct mlx5_rsc_key *key)
+{
+	struct mlx5_rsc_dump_cmd *cmd;
+	int sgmt_type;
+
+	if (IS_ERR_OR_NULL(dev->rsc_dump))
+		return ERR_PTR(-EOPNOTSUPP);
+
+	sgmt_type =3D dev->rsc_dump->fw_segment_type[key->rsc];
+	if (!sgmt_type && key->rsc !=3D MLX5_SGMT_TYPE_MENU)
+		return ERR_PTR(-EOPNOTSUPP);
+
+	cmd =3D kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (!cmd) {
+		mlx5_core_err(dev, "Resource dump: Failed to allocate command\n");
+		return ERR_PTR(-ENOMEM);
+	}
+	MLX5_SET(resource_dump, cmd->cmd, segment_type, sgmt_type);
+	MLX5_SET(resource_dump, cmd->cmd, index1, key->index1);
+	MLX5_SET(resource_dump, cmd->cmd, index2, key->index2);
+	MLX5_SET(resource_dump, cmd->cmd, num_of_obj1, key->num_of_obj1);
+	MLX5_SET(resource_dump, cmd->cmd, num_of_obj2, key->num_of_obj2);
+	MLX5_SET(resource_dump, cmd->cmd, size, key->size);
+	cmd->mem_size =3D key->size;
+	return cmd;
+}
+
+void mlx5_rsc_dump_cmd_destroy(struct mlx5_rsc_dump_cmd *cmd)
+{
+	kfree(cmd);
+}
+
+int mlx5_rsc_dump_next(struct mlx5_core_dev *dev, struct mlx5_rsc_dump_cmd=
 *cmd,
+		       struct page *page, int *size)
+{
+	bool more_dump;
+	int err;
+
+	if (IS_ERR_OR_NULL(dev->rsc_dump))
+		return -EOPNOTSUPP;
+
+	err =3D mlx5_rsc_dump_trigger(dev, cmd, page);
+	if (err) {
+		mlx5_core_err(dev, "Resource dump: Failed to trigger dump, %d\n", err);
+		return err;
+	}
+	*size =3D MLX5_GET(resource_dump, cmd->cmd, size);
+	more_dump =3D MLX5_GET(resource_dump, cmd->cmd, more_dump);
+
+	return more_dump;
+}
+
+#define MLX5_RSC_DUMP_MENU_SEGMENT 0xffff
+static int mlx5_rsc_dump_menu(struct mlx5_core_dev *dev)
+{
+	struct mlx5_rsc_dump_cmd *cmd =3D NULL;
+	struct mlx5_rsc_key key =3D {};
+	struct page *page;
+	int size;
+	int err;
+
+	page =3D alloc_page(GFP_KERNEL);
+	if (!page)
+		return -ENOMEM;
+
+	key.rsc =3D MLX5_SGMT_TYPE_MENU;
+	key.size =3D PAGE_SIZE;
+	cmd  =3D mlx5_rsc_dump_cmd_create(dev, &key);
+	if (IS_ERR(cmd)) {
+		err =3D PTR_ERR(cmd);
+		goto free_page;
+	}
+	MLX5_SET(resource_dump, cmd->cmd, segment_type, MLX5_RSC_DUMP_MENU_SEGMEN=
T);
+
+	do {
+		err =3D mlx5_rsc_dump_next(dev, cmd, page, &size);
+		if (err < 0)
+			goto destroy_cmd;
+
+		mlx5_rsc_dump_read_menu_sgmt(dev->rsc_dump, page);
+
+	} while (err > 0);
+
+destroy_cmd:
+	mlx5_rsc_dump_cmd_destroy(cmd);
+free_page:
+	__free_page(page);
+
+	return err;
+}
+
+static int mlx5_rsc_dump_create_mkey(struct mlx5_core_dev *mdev, u32 pdn,
+				     struct mlx5_core_mkey *mkey)
+{
+	int inlen =3D MLX5_ST_SZ_BYTES(create_mkey_in);
+	void *mkc;
+	u32 *in;
+	int err;
+
+	in =3D kvzalloc(inlen, GFP_KERNEL);
+	if (!in)
+		return -ENOMEM;
+
+	mkc =3D MLX5_ADDR_OF(create_mkey_in, in, memory_key_mkey_entry);
+	MLX5_SET(mkc, mkc, access_mode_1_0, MLX5_MKC_ACCESS_MODE_PA);
+	MLX5_SET(mkc, mkc, lw, 1);
+	MLX5_SET(mkc, mkc, lr, 1);
+
+	MLX5_SET(mkc, mkc, pd, pdn);
+	MLX5_SET(mkc, mkc, length64, 1);
+	MLX5_SET(mkc, mkc, qpn, 0xffffff);
+
+	err =3D mlx5_core_create_mkey(mdev, mkey, in, inlen);
+
+	kvfree(in);
+	return err;
+}
+
+struct mlx5_rsc_dump *mlx5_rsc_dump_create(struct mlx5_core_dev *dev)
+{
+	struct mlx5_rsc_dump *rsc_dump;
+
+	if (!MLX5_CAP_DEBUG(dev, resource_dump)) {
+		mlx5_core_dbg(dev, "Resource dump: capability not present\n");
+		return NULL;
+	}
+	rsc_dump =3D kzalloc(sizeof(*rsc_dump), GFP_KERNEL);
+	if (!rsc_dump)
+		return ERR_PTR(-ENOMEM);
+
+	return rsc_dump;
+}
+
+void mlx5_rsc_dump_destroy(struct mlx5_core_dev *dev)
+{
+	if (IS_ERR_OR_NULL(dev->rsc_dump))
+		return;
+	kfree(dev->rsc_dump);
+}
+
+int mlx5_rsc_dump_init(struct mlx5_core_dev *dev)
+{
+	struct mlx5_rsc_dump *rsc_dump =3D dev->rsc_dump;
+	int err;
+
+	if (IS_ERR_OR_NULL(dev->rsc_dump))
+		return 0;
+
+	err =3D mlx5_core_alloc_pd(dev, &rsc_dump->pdn);
+	if (err) {
+		mlx5_core_warn(dev, "Resource dump: Failed to allocate PD %d\n", err);
+		return err;
+	}
+	err =3D mlx5_rsc_dump_create_mkey(dev, rsc_dump->pdn, &rsc_dump->mkey);
+	if (err) {
+		mlx5_core_err(dev, "Resource dump: Failed to create mkey, %d\n", err);
+		goto free_pd;
+	}
+	err =3D mlx5_rsc_dump_menu(dev);
+	if (err) {
+		mlx5_core_err(dev, "Resource dump: Failed to read menu, %d\n", err);
+		goto destroy_mkey;
+	}
+	return err;
+
+destroy_mkey:
+	mlx5_core_destroy_mkey(dev, &rsc_dump->mkey);
+free_pd:
+	mlx5_core_dealloc_pd(dev, rsc_dump->pdn);
+	return err;
+}
+
+void mlx5_rsc_dump_cleanup(struct mlx5_core_dev *dev)
+{
+	if (IS_ERR_OR_NULL(dev->rsc_dump))
+		return;
+
+	mlx5_core_destroy_mkey(dev, &dev->rsc_dump->mkey);
+	mlx5_core_dealloc_pd(dev, dev->rsc_dump->pdn);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.h b/driv=
ers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.h
new file mode 100644
index 000000000000..3b7573461a45
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.h
@@ -0,0 +1,58 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2019 Mellanox Technologies. */
+
+#ifndef __MLX5_RSC_DUMP_H
+#define __MLX5_RSC_DUMP__H
+
+#include <linux/mlx5/driver.h>
+#include "mlx5_core.h"
+
+enum mlx5_sgmt_type {
+	MLX5_SGMT_TYPE_HW_CQPC,
+	MLX5_SGMT_TYPE_HW_SQPC,
+	MLX5_SGMT_TYPE_HW_RQPC,
+	MLX5_SGMT_TYPE_FULL_SRQC,
+	MLX5_SGMT_TYPE_FULL_CQC,
+	MLX5_SGMT_TYPE_FULL_EQC,
+	MLX5_SGMT_TYPE_FULL_QPC,
+	MLX5_SGMT_TYPE_SND_BUFF,
+	MLX5_SGMT_TYPE_RCV_BUFF,
+	MLX5_SGMT_TYPE_SRQ_BUFF,
+	MLX5_SGMT_TYPE_CQ_BUFF,
+	MLX5_SGMT_TYPE_EQ_BUFF,
+	MLX5_SGMT_TYPE_SX_SLICE,
+	MLX5_SGMT_TYPE_SX_SLICE_ALL,
+	MLX5_SGMT_TYPE_RDB,
+	MLX5_SGMT_TYPE_RX_SLICE_ALL,
+	MLX5_SGMT_TYPE_MENU,
+	MLX5_SGMT_TYPE_TERMINATE,
+
+	MLX5_SGMT_TYPE_NUM, /* Keep last */
+};
+
+struct mlx5_rsc_key {
+	enum mlx5_sgmt_type rsc;
+	int index1;
+	int index2;
+	int num_of_obj1;
+	int num_of_obj2;
+	int size;
+};
+
+#define MLX5_RSC_DUMP_ALL 0xFFFF
+struct mlx5_rsc_dump_cmd;
+struct mlx5_rsc_dump;
+
+struct mlx5_rsc_dump *mlx5_rsc_dump_create(struct mlx5_core_dev *dev);
+void mlx5_rsc_dump_destroy(struct mlx5_core_dev *dev);
+
+int mlx5_rsc_dump_init(struct mlx5_core_dev *dev);
+void mlx5_rsc_dump_cleanup(struct mlx5_core_dev *dev);
+
+struct mlx5_rsc_dump_cmd *mlx5_rsc_dump_cmd_create(struct mlx5_core_dev *d=
ev,
+						   struct mlx5_rsc_key *key);
+void mlx5_rsc_dump_cmd_destroy(struct mlx5_rsc_dump_cmd *cmd);
+
+int mlx5_rsc_dump_next(struct mlx5_core_dev *dev, struct mlx5_rsc_dump_cmd=
 *cmd,
+		       struct page *page, int *size);
+#endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/e=
thernet/mellanox/mlx5/core/main.c
index f554cfddcf4e..204a26bf0a5f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -70,6 +70,7 @@
 #include "diag/fw_tracer.h"
 #include "ecpf.h"
 #include "lib/hv_vhca.h"
+#include "diag/rsc_dump.h"
=20
 MODULE_AUTHOR("Eli Cohen <eli@mellanox.com>");
 MODULE_DESCRIPTION("Mellanox 5th generation network adapters (ConnectX ser=
ies) core driver");
@@ -880,6 +881,7 @@ static int mlx5_init_once(struct mlx5_core_dev *dev)
=20
 	dev->tracer =3D mlx5_fw_tracer_create(dev);
 	dev->hv_vhca =3D mlx5_hv_vhca_create(dev);
+	dev->rsc_dump =3D mlx5_rsc_dump_create(dev);
=20
 	return 0;
=20
@@ -909,6 +911,7 @@ static int mlx5_init_once(struct mlx5_core_dev *dev)
=20
 static void mlx5_cleanup_once(struct mlx5_core_dev *dev)
 {
+	mlx5_rsc_dump_destroy(dev);
 	mlx5_hv_vhca_destroy(dev->hv_vhca);
 	mlx5_fw_tracer_destroy(dev->tracer);
 	mlx5_dm_cleanup(dev);
@@ -1079,6 +1082,12 @@ static int mlx5_load(struct mlx5_core_dev *dev)
=20
 	mlx5_hv_vhca_init(dev->hv_vhca);
=20
+	err =3D mlx5_rsc_dump_init(dev);
+	if (err) {
+		mlx5_core_err(dev, "Failed to init Resource dump\n");
+		goto err_rsc_dump;
+	}
+
 	err =3D mlx5_fpga_device_start(dev);
 	if (err) {
 		mlx5_core_err(dev, "fpga device start failed %d\n", err);
@@ -1134,6 +1143,8 @@ static int mlx5_load(struct mlx5_core_dev *dev)
 err_ipsec_start:
 	mlx5_fpga_device_stop(dev);
 err_fpga_start:
+	mlx5_rsc_dump_cleanup(dev);
+err_rsc_dump:
 	mlx5_hv_vhca_cleanup(dev->hv_vhca);
 	mlx5_fw_tracer_cleanup(dev->tracer);
 err_fw_tracer:
@@ -1155,6 +1166,7 @@ static void mlx5_unload(struct mlx5_core_dev *dev)
 	mlx5_accel_ipsec_cleanup(dev);
 	mlx5_accel_tls_cleanup(dev);
 	mlx5_fpga_device_stop(dev);
+	mlx5_rsc_dump_cleanup(dev);
 	mlx5_hv_vhca_cleanup(dev->hv_vhca);
 	mlx5_fw_tracer_cleanup(dev->tracer);
 	mlx5_eq_table_destroy(dev);
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 277a51d3ec40..f99cbe249425 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -722,6 +722,7 @@ struct mlx5_core_dev {
 	struct mlx5_clock        clock;
 	struct mlx5_ib_clock_info  *clock_info;
 	struct mlx5_fw_tracer   *tracer;
+	struct mlx5_rsc_dump    *rsc_dump;
 	u32                      vsc_addr;
 	struct mlx5_hv_vhca	*hv_vhca;
 };
--=20
2.24.1

