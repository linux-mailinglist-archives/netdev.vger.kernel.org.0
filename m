Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F310A4FD2
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 09:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729416AbfIBHZ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 03:25:27 -0400
Received: from mail-eopbgr70055.outbound.protection.outlook.com ([40.107.7.55]:51171
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729725AbfIBHZ1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Sep 2019 03:25:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BmZ10C9m9NDsdvqfJvHev0BokWyWVi9+HgnA8rMfZiLHA7bZN5wpLEaGQlcOWrNwO7FEji3DueF1yhyiq9l5QeplapScl2xgkatbEtu3n+yOxBixG1G+FiP8GxlyU34jAq7nHkQ2DVCpnqG6fBP4pqekc4DbrReDp2VArodImkRg+Qdgav8Qwa72tJPG7+ZW4pC6/Jd89ijTfk7j9CY5n3vSztSYFASRyESTGTKFMc33Yjc8dYlbTMMuGuqR2Q7eoffV9H4ReP2AGy9ax+fdW4u22gCR14OnXBvMMNq/zw31MTSp2H9Kc1Cyb65aM3fCUOsSZCmq+Zq/GZAEv9qD1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1y6L2RxaHd/N63+yHMJkGTqdI/Mb4uQUhvln0zNWgg0=;
 b=V0ouPCpErxdEbTBhAT/YdleI507dSD4Q9C/Fc271YYQq4LLygYWPNJuApsJmCF+I8KLaQPe+aDBu9Db1MrxHX0cNfishlfoqjAVP27UNwRkJam+afHgUkoLcEvwTl8Kbm3j4G0VrKRhhMecHC4la6Z1RuoIVagXoapvyBu1axC57ah0tA6XdbZcVQ3bOXo1zKCP7nd6/K1G5zq2LvA3CXXC7ZcbQ8XpRn4J6yrp3U2vb1lZeboQxfRVIvNz7NwbX+GVvaTn42ck8bChTtzddKB+jm7FHgI0RQLcYpBnq5vhAu1i5xSZsJJOkc4geWFXyEuROpxFVdRGHRAOH3iW4dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1y6L2RxaHd/N63+yHMJkGTqdI/Mb4uQUhvln0zNWgg0=;
 b=Y+41TvxpliMeuVCVs6/aMNDaiNT7T8u9Ml70loKt8XDBQgYIAKaAgORzKOwp06QWr+GU5EOu0QU1ioqj7E6SXqbwd0TjPV7dhGnKTZKAnqpPqJ4JOb6g/EKJ8QJp77atHTVnlqT3XI7jb3RMetSemiHVAfPCuUZeOWxYherkeX8=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2259.eurprd05.prod.outlook.com (10.165.38.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.20; Mon, 2 Sep 2019 07:23:18 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::58d1:d1d6:dbda:3576]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::58d1:d1d6:dbda:3576%4]) with mapi id 15.20.2220.021; Mon, 2 Sep 2019
 07:23:18 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alex Vesker <valex@mellanox.com>,
        Erez Shitrit <erezsh@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 12/18] net/mlx5: DR, Add required FW steering functionality
Thread-Topic: [net-next 12/18] net/mlx5: DR, Add required FW steering
 functionality
Thread-Index: AQHVYV9Ku5Gs0mLruUWFd05CvO23Aw==
Date:   Mon, 2 Sep 2019 07:23:17 +0000
Message-ID: <20190902072213.7683-13-saeedm@mellanox.com>
References: <20190902072213.7683-1-saeedm@mellanox.com>
In-Reply-To: <20190902072213.7683-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BYAPR11CA0085.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::26) To AM4PR0501MB2756.eurprd05.prod.outlook.com
 (2603:10a6:200:5c::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 94c0fc0c-6914-4a50-cc17-08d72f766d05
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR0501MB2259;
x-ms-traffictypediagnostic: AM4PR0501MB2259:|AM4PR0501MB2259:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR0501MB2259788CA71466176C73DB86BEBE0@AM4PR0501MB2259.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 01480965DA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(1496009)(39860400002)(136003)(376002)(346002)(396003)(366004)(199004)(189003)(64756008)(478600001)(66946007)(66556008)(71190400001)(71200400001)(6916009)(5660300002)(54906003)(6486002)(8676002)(14454004)(81156014)(36756003)(81166006)(76176011)(1076003)(186003)(50226002)(99286004)(25786009)(4326008)(8936002)(316002)(102836004)(386003)(6506007)(2906002)(26005)(3846002)(256004)(6116002)(2616005)(66066001)(86362001)(53936002)(52116002)(107886003)(486006)(6436002)(305945005)(7736002)(6512007)(446003)(476003)(66446008)(11346002)(66476007);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2259;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: /bA2xGI8WAV4e6TVIGEnivTi2GQ0h+zaktb0tWzznLMDrWFxnYCW3o0pVjLB3S7WTdhHIFBu6B5SElOKIk4whhmL1yt+sDqA9ySAugBC85R1WWKex8nUqkGvcBthaASxFnIh2at5H8/0Q28zYZaJhd8vyf/3XVLVFEMXOGKJ56uhzjhOnLvMJUMKDWnsVpfr7SNzGBB8j1qPbfbKxFSAd4TvMwV8uLf0RoypUtT32j2ijzIFPgQ16tP8ZTWRgiVvGLaCmnHsjguT0UGyKmnie1VTBdLDm5IKQ8AYPVrHjPt3sNBy8+z6hy8dPreejx3PaO9dLQ6WTIvL08RRxC7dnwXm7iIQTyw+HEqAreLjEeO2yop3t6v3Yst0Hha79RcH201af63JinCFtMZekFW4AQCcUGhW9Sx/9AG7jeoqn+s=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94c0fc0c-6914-4a50-cc17-08d72f766d05
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2019 07:23:17.9486
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CbjCCH1/KZ+s5ub3wUOadcuZ7irAs613wWwtFfj8FRtuJqZqImin29Vqr2LKXNy8VMCzStSizuf70zw0BO/kKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2259
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

