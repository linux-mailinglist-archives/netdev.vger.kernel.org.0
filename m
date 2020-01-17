Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F254114008C
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 01:07:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388427AbgAQAHb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 19:07:31 -0500
Received: from mail-eopbgr70079.outbound.protection.outlook.com ([40.107.7.79]:19560
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387998AbgAQAH0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 19:07:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YcWbCSfzNSS4Hv0nCyT9T2sohNEuHK9kd6hKvU56EcKMZcaQhQdQHeTzcoNElqaNFCIpIXeInaT7YZkM6NqrOp0xtvUm1Blml4OSeEnDCF/9qLYJkeT+UYIf78hleRthzNSy+nm41U34FjQKrmgXPMgrsLOEZCGn4Y3rRlR5jziwmAP9RL5yafpQc2wbQnEVb8ody9hqHYT1w/Rzo8f4KS9raAAeo+lbYyjxw3WpqMHXT9NLWzaH4EkIZj91GmCOzEYICP3j5h6kWRAKuUJZjqYQbn0nNyrv2+dbJch8UwZS5oUOAFhbRdlw+QwIjvote7Ljx9er1flYlr1EdmHNVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uuSsrTThchLxgpbQD5c3Zq488Vi55cYUKCzbRITDPRY=;
 b=lLILzFeMgMvArAiBlzOrQ9KNha2/6w+VoyNi1+Ah7kdb/Ww2blArUHyb04Nj2xd1HejzqYa2cz1NAj1aR0+kaUSI9/1I/TSmbV5nOwhjV5gOKiP8G2KzVZn4TIdOk2KGB4HDk56Gi1Sx/EtDhgJuU4YP9I6iVR7eGNokofuabyPvEt6w5KRyHljnApd+2vsOQUHnviFgYxoQJfTFddQuKO5rcUt3q8zSje7n53Qc+mzynofdq9vNLAkNX0IFQrVnN2OIhOpg+YaVl9eLRK71pdGQH4rZ7A3xgUljAc1MMZiLQRKhlbi0832Y/93OGyoG6imzyn1WGZJ39kqpntNXFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uuSsrTThchLxgpbQD5c3Zq488Vi55cYUKCzbRITDPRY=;
 b=mF3675hchklJs+6FXfQ7YqvZ+R39IRMlRkPvwcT1EFf4LfyAuXl0gCB8uF6EJOElBgqLTG4hYlgn5M5PW0g8hP7jCOYKWWSIYai/4Zpzwjh+ex818MrTKkXGz4qeuktGU2sGQcsZe4xMvCLsQqwPCmbc2+tIToY2XdtRNjjoP7c=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4990.eurprd05.prod.outlook.com (20.177.49.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.10; Fri, 17 Jan 2020 00:07:15 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2644.015; Fri, 17 Jan 2020
 00:07:15 +0000
Received: from smtp.office365.com (209.116.155.178) by BYAPR03CA0003.namprd03.prod.outlook.com (2603:10b6:a02:a8::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Fri, 17 Jan 2020 00:07:14 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Paul Blakey <paulb@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 11/16] net/mlx5: Add ignore level support fwd to table
 rules
Thread-Topic: [net-next 11/16] net/mlx5: Add ignore level support fwd to table
 rules
Thread-Index: AQHVzMoT9OuS9xYOFUOXWAmGnCEkdg==
Date:   Fri, 17 Jan 2020 00:07:15 +0000
Message-ID: <20200117000619.696775-12-saeedm@mellanox.com>
References: <20200117000619.696775-1-saeedm@mellanox.com>
In-Reply-To: <20200117000619.696775-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR03CA0003.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::16) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6dbcd3d0-cfde-4e3b-6e6c-08d79ae135ca
x-ms-traffictypediagnostic: VI1PR05MB4990:|VI1PR05MB4990:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB49909C2A9B29E5364A434125BE310@VI1PR05MB4990.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0285201563
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(189003)(199004)(64756008)(6512007)(52116002)(66476007)(26005)(81166006)(86362001)(16526019)(81156014)(8676002)(2616005)(66556008)(186003)(6486002)(956004)(71200400001)(498600001)(36756003)(66446008)(54906003)(1076003)(5660300002)(2906002)(6506007)(4326008)(110136005)(8936002)(66946007)(107886003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4990;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HT2+OOVLucpQQT3CZq03hCIJLaBF7PyXEUgkICz74kXGEkMeRJLc7I5P8+FuhODr1R3esQjTOwcM28RP4tvlojw9+yPHTjo0NEiBeVelQGQPO0HGuWe/XJUz9JZjCwPLNgHuhVt/KD+eiT9uXmbK8Ns1briqv0XIJzer/8DyhFgd7PSqjsQhg3eADYb+zuFdrpgCkGX3i5hNH3mThCOErjEh42kSAq7DoGjbDt3p9hDbqoZmws97KHIAgrEl5perkHp+VuISkX43E4/2j6Vsri9WDrFLtNSUqmPsNTK1Gs5hNeVzOYvDBfXXAljBL3yaqsqRUhEulkIchwUSGPIRaVb9puVlUFTDpoJjyJ4oSmu+8JUaPgvKco34rcglE55awSTvSpw8ZvimoB2pfNQBSq2jTOiTSwRjf+Ng7TbWE3g0ZejGLqdBiuA/RND11zdRe7UQ+vcoHZwLeoF4TGZnDIkg8UsbTFtL3JQr2m9d5yGbG0izTSLYr0NzRP2XvuxpWw0RlI//WuBLFDV0G8sTHjlFDwMbqA3lKM9OwGtudg4=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6dbcd3d0-cfde-4e3b-6e6c-08d79ae135ca
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2020 00:07:15.8701
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SRrz5DBRYhY+X5ipw70utkpxG+ypRHWwYiyk6oz75w2epe0O0ytwTnNdKAEaJhztUgvpkSL/Zo05X9/flQtceg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4990
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@mellanox.com>

If user sets ignore flow level flag on a rule, that rule can point to
a flow table of any level, including those with levels equal or less
than the level of the flow table it is added on.

This with unamanged tables will be used to create a FDB chain/prio
hierarchy much larger than currently supported level range.

Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/fs_cmd.c   |  3 +++
 .../net/ethernet/mellanox/mlx5/core/fs_core.c  | 18 +++++++++++++++---
 include/linux/mlx5/fs.h                        |  1 +
 3 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c b/drivers/net=
/ethernet/mellanox/mlx5/core/fs_cmd.c
index 3c816e81f8d9..b25465d9e030 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
@@ -432,6 +432,9 @@ static int mlx5_cmd_set_fte(struct mlx5_core_dev *dev,
 	MLX5_SET(set_fte_in, in, table_type, ft->type);
 	MLX5_SET(set_fte_in, in, table_id,   ft->id);
 	MLX5_SET(set_fte_in, in, flow_index, fte->index);
+	MLX5_SET(set_fte_in, in, ignore_flow_level,
+		 !!(fte->action.flags & FLOW_ACT_IGNORE_FLOW_LEVEL));
+
 	if (ft->vport) {
 		MLX5_SET(set_fte_in, in, vport_number, ft->vport);
 		MLX5_SET(set_fte_in, in, other_vport, 1);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/fs_core.c
index 456d3739b166..355a424f4506 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -1536,18 +1536,30 @@ static bool counter_is_valid(u32 action)
 }
=20
 static bool dest_is_valid(struct mlx5_flow_destination *dest,
-			  u32 action,
+			  struct mlx5_flow_act *flow_act,
 			  struct mlx5_flow_table *ft)
 {
+	bool ignore_level =3D flow_act->flags & FLOW_ACT_IGNORE_FLOW_LEVEL;
+	u32 action =3D flow_act->action;
+
 	if (dest && (dest->type =3D=3D MLX5_FLOW_DESTINATION_TYPE_COUNTER))
 		return counter_is_valid(action);
=20
 	if (!(action & MLX5_FLOW_CONTEXT_ACTION_FWD_DEST))
 		return true;
=20
+	if (ignore_level) {
+		if (ft->type !=3D FS_FT_FDB)
+			return false;
+
+		if (dest->type =3D=3D MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE &&
+		    dest->ft->type !=3D FS_FT_FDB)
+			return false;
+	}
+
 	if (!dest || ((dest->type =3D=3D
 	    MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE) &&
-	    (dest->ft->level <=3D ft->level)))
+	    (dest->ft->level <=3D ft->level && !ignore_level)))
 		return false;
 	return true;
 }
@@ -1777,7 +1789,7 @@ _mlx5_add_flow_rules(struct mlx5_flow_table *ft,
 		return ERR_PTR(-EINVAL);
=20
 	for (i =3D 0; i < dest_num; i++) {
-		if (!dest_is_valid(&dest[i], flow_act->action, ft))
+		if (!dest_is_valid(&dest[i], flow_act, ft))
 			return ERR_PTR(-EINVAL);
 	}
 	nested_down_read_ref_node(&ft->node, FS_LOCK_GRANDPARENT);
diff --git a/include/linux/mlx5/fs.h b/include/linux/mlx5/fs.h
index de2c838bae90..81f393fb7d96 100644
--- a/include/linux/mlx5/fs.h
+++ b/include/linux/mlx5/fs.h
@@ -196,6 +196,7 @@ struct mlx5_fs_vlan {
=20
 enum {
 	FLOW_ACT_NO_APPEND =3D BIT(0),
+	FLOW_ACT_IGNORE_FLOW_LEVEL =3D BIT(1),
 };
=20
 struct mlx5_flow_act {
--=20
2.24.1

