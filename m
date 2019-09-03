Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2DBCA7438
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 22:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbfICUFe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 16:05:34 -0400
Received: from mail-eopbgr140044.outbound.protection.outlook.com ([40.107.14.44]:24054
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726946AbfICUFc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Sep 2019 16:05:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y0GvzWKBCrzNr3V2/fx1w5SnATnpgrJsjtBkgYIDM6Mr7oHpZnUP/zbEcZAdAAzyuAj8WOMc8DPxq4pFngkgFXMAtkHQv9bBXmZMBxpXwTPXg27LXX5WcEVhCrpi9Moblh8OPFu7iE1/EDSDNDQ9AIGYQNQf4u+dcGwvzgMV+AEk9FXFIrTc/wP0NiHIAssnnmX4jqI6rl7eC+Zpz0PjS4TDtsochgX7VX678hyzgWSHeCBFdMuwJb2+aStgZLiFisQYeoX8LuprSdRMbzLvFCwC6HJy3uFdeCcLYMG1WLJogGdU0r0C1humsKwHtUw8SZEos+F6uBLTg6J3MeYIeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1y6L2RxaHd/N63+yHMJkGTqdI/Mb4uQUhvln0zNWgg0=;
 b=OPXM7MhxOgWazcMH7Zz6Zi/hBXK2DMoB4JRmAAUYjI/31ctcFULidTEntYfTi7RNncEVai7M/ItRyJyh/S1mPNmSiW9UowfVTQjq4z9ewRiLH9/CsFACnYAIbbQzMxSBDqUbAxLJXH4hWNnd/fg0iEOO71gghIeEA1CRI05BsDpbXl0sjHGRr3+fq1U4OXyvdwI32uU68EwpVZgTDN/NCaX/JLqDDKZSt2fWuK2OoJONzrYYBUEN8xpPzJIMvvA/9QYYHC0nT9cw7M6z01ImvCK9aOEjmFDKzGTbkW0ATwTS8RVTk/zRiOpUfejcNnDgUj/AalQ2RGKznBCrzcf2GA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1y6L2RxaHd/N63+yHMJkGTqdI/Mb4uQUhvln0zNWgg0=;
 b=YZfIgW6l/liEqTH1vJGmZlzsrhgZfk0EKPURgkVI5seNBHXmPavVB2LjxZ2APi/c0d9uzIDKYsg441SgRD8sx70TbYWuQNbIQWlxmHWo4CUxENwuuv8f3xo8S7DUKZn5DOpWaS8iXhCZqdzIWyTioHaG6sU/Dkhxa/l73nGC/7k=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2706.eurprd05.prod.outlook.com (10.172.221.142) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.21; Tue, 3 Sep 2019 20:04:53 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::58d1:d1d6:dbda:3576]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::58d1:d1d6:dbda:3576%4]) with mapi id 15.20.2220.021; Tue, 3 Sep 2019
 20:04:53 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alex Vesker <valex@mellanox.com>,
        Erez Shitrit <erezsh@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V2 12/18] net/mlx5: DR, Add required FW steering
 functionality
Thread-Topic: [net-next V2 12/18] net/mlx5: DR, Add required FW steering
 functionality
Thread-Index: AQHVYpLZlDZhCNHdJUi7lXuO7OHjow==
Date:   Tue, 3 Sep 2019 20:04:52 +0000
Message-ID: <20190903200409.14406-13-saeedm@mellanox.com>
References: <20190903200409.14406-1-saeedm@mellanox.com>
In-Reply-To: <20190903200409.14406-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR02CA0049.namprd02.prod.outlook.com
 (2603:10b6:a03:54::26) To AM4PR0501MB2756.eurprd05.prod.outlook.com
 (2603:10a6:200:5c::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e200f4a9-6344-4f74-d43b-08d730a9fb9e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR0501MB2706;
x-ms-traffictypediagnostic: AM4PR0501MB2706:|AM4PR0501MB2706:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR0501MB27063D699F754CBA8723EF8BBEB90@AM4PR0501MB2706.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 01494FA7F7
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(1496009)(4636009)(376002)(346002)(136003)(39860400002)(396003)(366004)(199004)(189003)(2906002)(102836004)(256004)(26005)(11346002)(50226002)(186003)(66446008)(386003)(6506007)(64756008)(66556008)(66476007)(71190400001)(66946007)(2616005)(476003)(76176011)(71200400001)(5660300002)(8936002)(66066001)(446003)(81166006)(81156014)(478600001)(54906003)(6916009)(8676002)(486006)(36756003)(3846002)(7736002)(53936002)(6436002)(305945005)(14454004)(6116002)(52116002)(6512007)(86362001)(316002)(99286004)(1076003)(6486002)(4326008)(107886003)(25786009);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2706;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: iB3I18TStIf36/vRwfU1tskEAhvOxLf8NNt1Y82+SnZL1uyJDDm/up45517vWASw6oDUzRglkDVl5wgTY+nRYjQCx1/pif/X2tbYQK8pibcaf4FVrcakmqCR46CINAU6Wbam/wvtgjSVA0GO26v7/YljYl22DIuKiOVGCrJneIEIaFmdunGrtm9TQs9+/wIyMWpyySf9u34WyTH+TNHzQtC0RDuyj6T1aToYp7lHkpl/2iXC43X4j+GPyOulQHXcf8D8rPg/RmxxJmJ8knXHHK/r7zWvMvNd5r6IT0H5fbN3nyAdlUUswmx2ulRN+B8ynA3bkZDlBlJ0E7rm04QRbiU6yKW4Hmyf37LVVBd0z+Lmp48nP/nuzqz2GxDdsNq0Zj1qTFZ9GrQqekVrWAV5JIpZub5XT1iqUjSHi+Ceqcs=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e200f4a9-6344-4f74-d43b-08d730a9fb9e
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Sep 2019 20:04:52.9619
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: p85REDlEgzdpw8EqV/UQqc7lyXbOqqeLmjqBnYC3a+aJ200DTTza/gCVaOWyORvmElNcYY0r64KTHN2GkpY1qA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2706
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Vesker <valex@mellanox.com>

SW steering is capable of doing many steering functionalities
but there are still some functionalities which are not exposed
to upper layers and therefore performed by the FW.

This is the support for recalculating checksum using a hairpin QP.
The recalculation is required after a modify TTL action which skips
the needed CS calculation in HW.

Signed-off-by: Alex Vesker <valex@mellanox.com>
Reviewed-by: Erez Shitrit <erezsh@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mellanox/mlx5/core/steering/dr_fw.c       | 93 +++++++++++++++++++
 1 file changed, 93 insertions(+)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_fw.=
c

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_fw.c b/dri=
vers/net/ethernet/mellanox/mlx5/core/steering/dr_fw.c
new file mode 100644
index 000000000000..60ef6e6171e3
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_fw.c
@@ -0,0 +1,93 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2019 Mellanox Technologies. */
+
+#include <linux/types.h>
+#include "dr_types.h"
+
+struct mlx5dr_fw_recalc_cs_ft *
+mlx5dr_fw_create_recalc_cs_ft(struct mlx5dr_domain *dmn, u32 vport_num)
+{
+	struct mlx5dr_fw_recalc_cs_ft *recalc_cs_ft;
+	u32 table_id, group_id, modify_hdr_id;
+	u64 rx_icm_addr, modify_ttl_action;
+	int ret;
+
+	recalc_cs_ft =3D kzalloc(sizeof(*recalc_cs_ft), GFP_KERNEL);
+	if (!recalc_cs_ft)
+		return NULL;
+
+	ret =3D mlx5dr_cmd_create_flow_table(dmn->mdev, MLX5_FLOW_TABLE_TYPE_FDB,
+					   0, 0, dmn->info.caps.max_ft_level - 1,
+					   false, true, &rx_icm_addr, &table_id);
+	if (ret) {
+		mlx5dr_err(dmn, "Failed creating TTL W/A FW flow table %d\n", ret);
+		goto free_ttl_tbl;
+	}
+
+	ret =3D mlx5dr_cmd_create_empty_flow_group(dmn->mdev,
+						 MLX5_FLOW_TABLE_TYPE_FDB,
+						 table_id, &group_id);
+	if (ret) {
+		mlx5dr_err(dmn, "Failed creating TTL W/A FW flow group %d\n", ret);
+		goto destroy_flow_table;
+	}
+
+	/* Modify TTL action by adding zero to trigger CS recalculation */
+	modify_ttl_action =3D 0;
+	MLX5_SET(set_action_in, &modify_ttl_action, action_type, MLX5_ACTION_TYPE=
_ADD);
+	MLX5_SET(set_action_in, &modify_ttl_action, field, MLX5_ACTION_IN_FIELD_O=
UT_IP_TTL);
+
+	ret =3D mlx5dr_cmd_alloc_modify_header(dmn->mdev, MLX5_FLOW_TABLE_TYPE_FD=
B, 1,
+					     &modify_ttl_action,
+					     &modify_hdr_id);
+	if (ret) {
+		mlx5dr_err(dmn, "Failed modify header TTL %d\n", ret);
+		goto destroy_flow_group;
+	}
+
+	ret =3D mlx5dr_cmd_set_fte_modify_and_vport(dmn->mdev,
+						  MLX5_FLOW_TABLE_TYPE_FDB,
+						  table_id, group_id, modify_hdr_id,
+						  vport_num);
+	if (ret) {
+		mlx5dr_err(dmn, "Failed setting TTL W/A flow table entry %d\n", ret);
+		goto dealloc_modify_header;
+	}
+
+	recalc_cs_ft->modify_hdr_id =3D modify_hdr_id;
+	recalc_cs_ft->rx_icm_addr =3D rx_icm_addr;
+	recalc_cs_ft->table_id =3D table_id;
+	recalc_cs_ft->group_id =3D group_id;
+
+	return recalc_cs_ft;
+
+dealloc_modify_header:
+	mlx5dr_cmd_dealloc_modify_header(dmn->mdev, modify_hdr_id);
+destroy_flow_group:
+	mlx5dr_cmd_destroy_flow_group(dmn->mdev,
+				      MLX5_FLOW_TABLE_TYPE_FDB,
+				      table_id, group_id);
+destroy_flow_table:
+	mlx5dr_cmd_destroy_flow_table(dmn->mdev, table_id, MLX5_FLOW_TABLE_TYPE_F=
DB);
+free_ttl_tbl:
+	kfree(recalc_cs_ft);
+	return NULL;
+}
+
+void mlx5dr_fw_destroy_recalc_cs_ft(struct mlx5dr_domain *dmn,
+				    struct mlx5dr_fw_recalc_cs_ft *recalc_cs_ft)
+{
+	mlx5dr_cmd_del_flow_table_entry(dmn->mdev,
+					MLX5_FLOW_TABLE_TYPE_FDB,
+					recalc_cs_ft->table_id);
+	mlx5dr_cmd_dealloc_modify_header(dmn->mdev, recalc_cs_ft->modify_hdr_id);
+	mlx5dr_cmd_destroy_flow_group(dmn->mdev,
+				      MLX5_FLOW_TABLE_TYPE_FDB,
+				      recalc_cs_ft->table_id,
+				      recalc_cs_ft->group_id);
+	mlx5dr_cmd_destroy_flow_table(dmn->mdev,
+				      recalc_cs_ft->table_id,
+				      MLX5_FLOW_TABLE_TYPE_FDB);
+
+	kfree(recalc_cs_ft);
+}
--=20
2.21.0

