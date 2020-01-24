Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71A92149088
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 22:55:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729154AbgAXVzc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 16:55:32 -0500
Received: from mail-eopbgr40047.outbound.protection.outlook.com ([40.107.4.47]:56737
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726204AbgAXVzb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jan 2020 16:55:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D7CEjj+Mn9xg2xfi6T1dPs/B6j1wkQOsSdzzGE/JaBQA7F0m8WLmJbFO5mHIZ+IOAdQH4RZr597u1Kuck30kW5v++Z8JSE07I69maMfO9FlMN27ggfIBMqzVi+TKPV8vZrJeno27wTApO0vVQ7lNelTK0BifVshNawOEBOPUSd7Lj//Q3tUNm+8AWc4gfCNhmh8wk9GOJmTPprePLiSYoV5qzDeITkkeufvLQuABE1bvgVfY7+nrw26usab7NVO2O4ip1JtYHUduCET+WZhS0S5TvLT2yLMElGYA8dL47Jq0z4D3eff7yOKkdR9L6zDeRfXyNFIfjqw4HK+YkoF4Cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+WuHPmnXiQaUwNh5Inz6nFjAZBag46v+DqDSkkQV0Lo=;
 b=aXYbuG84sb8BzBj5nQ4X1TLhNMTyEzY5c6UM4W9u719XP+WIuFXL4RLw5hX5Bvyp8EJx7RssJ/pgSbYENJfhjr44eFP/VsH26POSXLhYCeAZ7TmhcyCZE4YpOu2k1kIq9qMi2pCRp6BXI/nOxMUHNob0FVIsM5zvYfAkxahQcPOGOvXFyc12Q//3j4Fv/ZwgbganAYPUceP4rxP150yii+/h4G1PGws57l49fCs2BBGd4ixzLP3tWEz7KmyIXGLZ7/0zi4fMPsEy3opxjzHKStqhml3QXRyhCJZ0SOa71a1R2dr8wfqhGmKEtWei1MYMRC1A0aGcV0UuXcz4def/hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+WuHPmnXiQaUwNh5Inz6nFjAZBag46v+DqDSkkQV0Lo=;
 b=cwpcScF/twOfYd8mr2pclSAoEC+kQgizYpjW6uqmWwVpkdCxjv3AZT3Q1qtuHIQBlEp5Hr/wDO6qGOwPwYGeb8nujEERPeDg6KZ8qoOFlD9341ACf0QK9GmudeeVlBlzx36Ps2voiPXzMYPiDZUa8UOV/DaJu5HfHJ4lGLXoRdI=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5456.eurprd05.prod.outlook.com (20.177.201.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.19; Fri, 24 Jan 2020 21:55:19 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2644.027; Fri, 24 Jan 2020
 21:55:19 +0000
Received: from smtp.office365.com (209.116.155.178) by BY5PR17CA0038.namprd17.prod.outlook.com (2603:10b6:a03:167::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.21 via Frontend Transport; Fri, 24 Jan 2020 21:55:18 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Erez Shitrit <erezsh@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 13/14] net/mlx5: DR, Handle reformat capability over
 sw-steering tables
Thread-Topic: [net-next 13/14] net/mlx5: DR, Handle reformat capability over
 sw-steering tables
Thread-Index: AQHV0wD4x1cgrNILwE2KqW1dhgt9pw==
Date:   Fri, 24 Jan 2020 21:55:19 +0000
Message-ID: <20200124215431.47151-14-saeedm@mellanox.com>
References: <20200124215431.47151-1-saeedm@mellanox.com>
In-Reply-To: <20200124215431.47151-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BY5PR17CA0038.namprd17.prod.outlook.com
 (2603:10b6:a03:167::15) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3469fb47-ee40-45b0-efd2-08d7a1181a9f
x-ms-traffictypediagnostic: VI1PR05MB5456:|VI1PR05MB5456:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5456783AF32C0420BA892001BE0E0@VI1PR05MB5456.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 02929ECF07
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(366004)(376002)(136003)(39860400002)(199004)(189003)(956004)(4326008)(107886003)(5660300002)(316002)(54906003)(478600001)(8936002)(2616005)(6916009)(26005)(52116002)(6506007)(36756003)(8676002)(81166006)(81156014)(86362001)(16526019)(186003)(1076003)(66946007)(66476007)(66556008)(64756008)(66446008)(2906002)(6486002)(71200400001)(6512007)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5456;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JAsjkU6W8lgKmmqUMfRh3kdrLQ/BKapUk4xuDc/wLc4HRRTbX/MP0PLYQpt9j7vye3FQ/C2uwUZBJnrSXIjvscGB4fRkFY+zP+N24jjRCNPWEjXfHoDUtzScLBsYENmQJb5CdyyxdstzByxIdcI67d1O/8M0En2OfqLPuA19ChIVsXHMuhKtScu77EARG3fb01mdzRwfLebIKpjzXtJX/DdNgk4Amxw9egreuVF/81fh89ouFbGZTgwiseCI2pmFXffodksZq3pmjzLgQ+h9l3a3gHY6oQ2zK6+vFpC4utos5LWZ8PrRsFj7lP+MXzZUtdombZ1ocuRGm8JISqLiP7vvzLa7CyS54Oux8vOz7pr3B2NxQ/5c2DPPNi9q6RYAXndEmD307rkfVQ4wuZcU2RfBXvMAdDdknoKrb+/TjTdPi6DCYjePR07NkqMi8Toi7WMhnczJG4spdI9DAdKkwEP5YnChnayR/heueGRwXY8vZ0ZK9lebKHbiosz2WnOwB1MtjtLoV1WXG47OONmVC/57OFt9ZTirp0Aq0KOLOs0=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3469fb47-ee40-45b0-efd2-08d7a1181a9f
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jan 2020 21:55:19.6109
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BXqFwkoRoG3V2/wcvfRuc58ycUpyxVcYkQQnotTHNmJSYpD7zj7avzYtEuiFs7S9iT9ueQiNy3hj5WUzeZFr3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5456
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Erez Shitrit <erezsh@mellanox.com>

On flow table creation, send the relevant flags according to what the FW
currently supports.
When FW doesn't support reformat option over SW-steering managed table,
the driver shouldn't pass this.

Fixes: 988fd6b32d07 ("net/mlx5: DR, Pass table flags at creation to lower l=
ayer")
Signed-off-by: Erez Shitrit <erezsh@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c b/dri=
vers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
index b43275cde8bf..5e277cc81054 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
@@ -66,15 +66,20 @@ static int mlx5_cmd_dr_create_flow_table(struct mlx5_fl=
ow_root_namespace *ns,
 					 struct mlx5_flow_table *next_ft)
 {
 	struct mlx5dr_table *tbl;
+	u32 flags;
 	int err;
=20
 	if (mlx5_dr_is_fw_table(ft->flags))
 		return mlx5_fs_cmd_get_fw_cmds()->create_flow_table(ns, ft,
 								    log_size,
 								    next_ft);
+	flags =3D ft->flags;
+	/* turn off encap/decap if not supported for sw-str by fw */
+	if (!MLX5_CAP_FLOWTABLE(ns->dev, sw_owner_reformat_supported))
+		flags =3D ft->flags & ~(MLX5_FLOW_TABLE_TUNNEL_EN_REFORMAT |
+				      MLX5_FLOW_TABLE_TUNNEL_EN_DECAP);
=20
-	tbl =3D mlx5dr_table_create(ns->fs_dr_domain.dr_domain,
-				  ft->level, ft->flags);
+	tbl =3D mlx5dr_table_create(ns->fs_dr_domain.dr_domain, ft->level, flags)=
;
 	if (!tbl) {
 		mlx5_core_err(ns->dev, "Failed creating dr flow_table\n");
 		return -EINVAL;
--=20
2.24.1

