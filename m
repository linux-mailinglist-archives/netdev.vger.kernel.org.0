Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B483132F22
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 20:14:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728791AbgAGTOc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 14:14:32 -0500
Received: from mail-vi1eur05on2055.outbound.protection.outlook.com ([40.107.21.55]:6105
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728778AbgAGTOb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jan 2020 14:14:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OthJvl4QvEkp5H0uy9wBRu4smp1ECA+soPWP8Y13RyIIXwOhl0D/V1VKY3xXEeaOGl5Cz5/fnrE8JU/iW8YgHBubXXzdt5k0TUQ1eFLPstjTY6YHT/2ip6NhT1A7rYzrIL+7RnLffBUgDUjdXYMIjZwQLLkO36rN5gEctLRzmaazUAnydDto7b3RrrM0BMcl6yZ2x2hQhMlJUWi2YwEBO0QIUONiA+dOYHemX3L7SdytmmgHa1EgfzN8hQYBw+yd7NhYAzlyxb6qc+A/SZ86XiInGfUK6Lp/xPn9N5Etyac6MGNW/+Wv4xp+1BYnSzEtYfG6fPVypdI21/pBS0o8+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QVqXSD7tsHPMG3NDxC7zlLE9/38uAwuOsuT9izcoQiQ=;
 b=ElRa5Ql+n6pJHNTmrrVUu7Oaw0PlWvfcATxZhNfOqvM16nW/i3Mi4gErT+I6st8jxO7hQvwtrgjGDAYPbIH5x8TWLmTF9haFmCLuRCu0otPKI/cFKAwJuD3QOfwuc56Sgk7YhW7NXgkS2wG36gM26BmV5b//lo9ChRZ4GDOCXOEamgy9hUkyuZ45CgQ4EZbmhyPuqq/8rQvRfBwEwiZHLQgLNrWMQFR3vyPN677fvK4GURXWq78ViXGxqqCQ6NSbhL6cxU6XYnhXhEJAnbJA6ZQ5ufPrFLR4eALKzj2m6UuZDdAFAKsyn+g6kGNftex+NaEyq2YjKJjRBITWjc0M6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QVqXSD7tsHPMG3NDxC7zlLE9/38uAwuOsuT9izcoQiQ=;
 b=HsFN0sptGzsW5x9gYwS1N4mE/tHof8CjiB5er1vSr0AMPU34rV/4KbBSCu7sJGmDuei3JE75PICPkxM1IU9V34Y35dBXMnj5cmgVgnXSliq6nSNuGmB7sUU3A+EBaEk8yGITjxJnFajP9a2ip7wBvVQdxWrcdoT1NOZwpgv6VVI=
Received: from AM6PR05MB5094.eurprd05.prod.outlook.com (20.177.34.93) by
 AM6PR05MB5411.eurprd05.prod.outlook.com (20.177.189.90) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.11; Tue, 7 Jan 2020 19:14:20 +0000
Received: from AM6PR05MB5094.eurprd05.prod.outlook.com
 ([fe80::d9f3:f3b8:86b2:a40a]) by AM6PR05MB5094.eurprd05.prod.outlook.com
 ([fe80::d9f3:f3b8:86b2:a40a%7]) with mapi id 15.20.2602.015; Tue, 7 Jan 2020
 19:14:20 +0000
Received: from smtp.office365.com (209.116.155.178) by BYAPR06CA0068.namprd06.prod.outlook.com (2603:10b6:a03:14b::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2581.12 via Frontend Transport; Tue, 7 Jan 2020 19:14:18 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Erez Shitrit <erezsh@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 09/13] net/mlx5: DR, Create multi-destination table for
 SW-steering use
Thread-Topic: [net-next 09/13] net/mlx5: DR, Create multi-destination table
 for SW-steering use
Thread-Index: AQHVxY6pfyA9TBpWcUu3VqhrBDAFDg==
Date:   Tue, 7 Jan 2020 19:14:20 +0000
Message-ID: <20200107191335.12272-10-saeedm@mellanox.com>
References: <20200107191335.12272-1-saeedm@mellanox.com>
In-Reply-To: <20200107191335.12272-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR06CA0068.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::45) To AM6PR05MB5094.eurprd05.prod.outlook.com
 (2603:10a6:20b:9::29)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f2274f0d-4c45-4fd9-46af-08d793a5cc04
x-ms-traffictypediagnostic: AM6PR05MB5411:|AM6PR05MB5411:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR05MB5411134742226CDF1A133E32BE3F0@AM6PR05MB5411.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2733;
x-forefront-prvs: 027578BB13
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(136003)(346002)(39860400002)(376002)(199004)(189003)(81166006)(52116002)(6916009)(8936002)(81156014)(8676002)(26005)(86362001)(36756003)(316002)(5660300002)(107886003)(6506007)(4326008)(478600001)(1076003)(16526019)(956004)(2616005)(2906002)(66446008)(64756008)(66556008)(66476007)(71200400001)(6666004)(66946007)(6486002)(6512007)(54906003)(186003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5411;H:AM6PR05MB5094.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2Q3pGtrG3unz2BWp+MtuNqVE6CwLA30mD4c7gly9Ka0wy9T3OaCPCMbqOjOBSFpS1XXClOmAU4unHIMjHH+zvayzJ/NRQvHAA3DN7aXaAKgR76P/bTiAlLxGSbh5wru28PWqjJhVMf+4KVcT8FMT2C4H+BMh703kHugAYhG44q2JBMB3KNgQcBk9HeQK634WFcZGRGs3gkfE9c1dYSERJ0zdZ1yWQA1rs8Qitn8EAUmd02ASzgTF86+JU8VyP+anMh5cvM3XdcozeXntwZJIB9DMQ30lbZ5D28mx/Rnt4R1vTlB7IdhBTwrr7hYJTEoCYiHbz9HAQoVfoc4t9xDhK1UgUF5QfwxC8N0pGXUEQBm2im4fM+p4CI0UoF5MIW+02ZNLZkGdIgPdKz0XjFStvCjDHLPZwLoOpY5fEKZ+9YE9dM0W6YooJgPl2ccgRRX0NX4neEe9g6AoG0tquAh/waCSZZM+Lw86iwSfuRdS6h3xwPoX/ag7O8D7hlDXfnzy3RIaIuT8ac+SPhDFuq81yfr71Brb10SDRawDWndZoOc=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2274f0d-4c45-4fd9-46af-08d793a5cc04
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jan 2020 19:14:20.0452
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Pu6J0rkg7TtT1yaNY0wF1XAURBHMh06C7p33aNwRnbm44er5C4qR30VQX7Fc8NqorBPEemXpHERyuUHA0Pifzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5411
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Erez Shitrit <erezsh@mellanox.com>

Currently SW steering doesn't have the means to access HW iterators to
support multi-destination (FTEs) flow table entries.

In order to support multi-destination FTEs for port-mirroring, SW
steering will create a dedicated multi-destination FW managed flow table
and FTEs via direct FW commands that we introduced in the previous patch.

Signed-off-by: Erez Shitrit <erezsh@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mellanox/mlx5/core/steering/dr_fw.c       | 67 +++++++++++++++++++
 .../mellanox/mlx5/core/steering/dr_types.h    |  8 +++
 2 files changed, 75 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_fw.c b/dri=
vers/net/ethernet/mellanox/mlx5/core/steering/dr_fw.c
index 9d2180cb095f..1fbcd012bb85 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_fw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_fw.c
@@ -97,3 +97,70 @@ void mlx5dr_fw_destroy_recalc_cs_ft(struct mlx5dr_domain=
 *dmn,
=20
 	kfree(recalc_cs_ft);
 }
+
+int mlx5dr_fw_create_md_tbl(struct mlx5dr_domain *dmn,
+			    struct mlx5dr_cmd_flow_destination_hw_info *dest,
+			    int num_dest,
+			    bool reformat_req,
+			    u32 *tbl_id,
+			    u32 *group_id)
+{
+	struct mlx5dr_cmd_create_flow_table_attr ft_attr =3D {};
+	struct mlx5dr_cmd_fte_info fte_info =3D {};
+	u32 val[MLX5_ST_SZ_DW_MATCH_PARAM] =3D {};
+	struct mlx5dr_cmd_ft_info ft_info =3D {};
+	int ret;
+
+	ft_attr.table_type =3D MLX5_FLOW_TABLE_TYPE_FDB;
+	ft_attr.level =3D dmn->info.caps.max_ft_level - 2;
+	ft_attr.reformat_en =3D reformat_req;
+	ft_attr.decap_en =3D reformat_req;
+
+	ret =3D mlx5dr_cmd_create_flow_table(dmn->mdev, &ft_attr, NULL, tbl_id);
+	if (ret) {
+		mlx5dr_err(dmn, "Failed creating multi dest FW flow table %d\n", ret);
+		return ret;
+	}
+
+	ret =3D mlx5dr_cmd_create_empty_flow_group(dmn->mdev,
+						 MLX5_FLOW_TABLE_TYPE_FDB,
+						 *tbl_id, group_id);
+	if (ret) {
+		mlx5dr_err(dmn, "Failed creating multi dest FW flow group %d\n", ret);
+		goto free_flow_table;
+	}
+
+	ft_info.id =3D *tbl_id;
+	ft_info.type =3D FS_FT_FDB;
+	fte_info.action.action =3D MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
+	fte_info.dests_size =3D num_dest;
+	fte_info.val =3D val;
+	fte_info.dest_arr =3D dest;
+
+	ret =3D mlx5dr_cmd_set_fte(dmn->mdev, 0, 0, &ft_info, *group_id, &fte_inf=
o);
+	if (ret) {
+		mlx5dr_err(dmn, "Failed setting fte into table %d\n", ret);
+		goto free_flow_group;
+	}
+
+	return 0;
+
+free_flow_group:
+	mlx5dr_cmd_destroy_flow_group(dmn->mdev, MLX5_FLOW_TABLE_TYPE_FDB,
+				      *tbl_id, *group_id);
+free_flow_table:
+	mlx5dr_cmd_destroy_flow_table(dmn->mdev, *tbl_id,
+				      MLX5_FLOW_TABLE_TYPE_FDB);
+	return ret;
+}
+
+void mlx5dr_fw_destroy_md_tbl(struct mlx5dr_domain *dmn,
+			      u32 tbl_id, u32 group_id)
+{
+	mlx5dr_cmd_del_flow_table_entry(dmn->mdev, FS_FT_FDB, tbl_id);
+	mlx5dr_cmd_destroy_flow_group(dmn->mdev,
+				      MLX5_FLOW_TABLE_TYPE_FDB,
+				      tbl_id, group_id);
+	mlx5dr_cmd_destroy_flow_table(dmn->mdev, tbl_id,
+				      MLX5_FLOW_TABLE_TYPE_FDB);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/=
drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 09ac9aadad1a..c37226a14311 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -1108,4 +1108,12 @@ void mlx5dr_fw_destroy_recalc_cs_ft(struct mlx5dr_do=
main *dmn,
 int mlx5dr_domain_cache_get_recalc_cs_ft_addr(struct mlx5dr_domain *dmn,
 					      u32 vport_num,
 					      u64 *rx_icm_addr);
+int mlx5dr_fw_create_md_tbl(struct mlx5dr_domain *dmn,
+			    struct mlx5dr_cmd_flow_destination_hw_info *dest,
+			    int num_dest,
+			    bool reformat_req,
+			    u32 *tbl_id,
+			    u32 *group_id);
+void mlx5dr_fw_destroy_md_tbl(struct mlx5dr_domain *dmn, u32 tbl_id,
+			      u32 group_id);
 #endif  /* _DR_TYPES_H_ */
--=20
2.24.1

