Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19CFA140090
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 01:07:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732697AbgAQAHh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 19:07:37 -0500
Received: from mail-eopbgr70079.outbound.protection.outlook.com ([40.107.7.79]:19560
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388259AbgAQAH2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 19:07:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L/4C6bfU5T1wt0R75F8MGc0FHuIBcQaVsxAlCP7EFd7bTX1nXncbjJbKMkpvGMQgWJ1IGuWE2zkUwS81F4hsCArQfXFxigw0BHRPjcfkECVZJjN/3YWxc2YvlYp5y0cbyXqgV7MsjIiaO7atlSsOuIWRFjSB6kG/kYpz/jGhXIjQZiHxpayVPBePCgnOzU/uOZ2m9ovbwuOOK5e6kxZQW5SotW/1okhbj6nFYXf9RYnYj2c0xBxQDC+4xjt0AdXKlVSFMn1sTLowkaUTJApwaDsxY7y1zbxnNL3Yrt00t/WWTg5U3j5sUoZpAhwhQVPgHBFEH0/WETWd+C2omoQriA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7NWR4iJLtcGwKwaK12wrcSzNjGeUYsJVQekZCftgLtk=;
 b=WX4AGTV6C9Uribih1J+69eqAL9utjQbn2ZNrQgWuT8RHWmScu9qt+jbsQKatOqcX7pa9bgg6pSV3AyiZrR1H4uBa0/85QnP8x/MQHl+5Vx5CXQYJaO+gWxfvCTdE4QgEdOvQEsy6vWxO6gpHs+7ugBnve5H93erq8K6CIi0wlAPkVxCbZoNSQcmgJYcxp9gWiFGQmdyQ2ShxvT9odl2uAQi0OBFyG/U0N1pph6ttl2j1p+IsqRYC4U20TYlKQ5dMD/QVsKytWSOHTN+lwdyHYVLUyIqm9TESscfAGZlatsrj9YQhkSCAtIeyURp9CDvRHqry3shq9gHNvm2HxRcZwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7NWR4iJLtcGwKwaK12wrcSzNjGeUYsJVQekZCftgLtk=;
 b=kTYh4zWWLgFf/dGXN6QfKsQXAr3RhXTxmRgJIu/4QO63XfZDRZVHnwAQBH/WAIXo07J5YyYSJlZfl9G6j0EuXuEbH7PnmXGZe5/1NWFZHMpGLosLWQRc2GooKaxy+0WbZyg8YdmxcMZoiVhh/A1ncqxqmueRYM1V2yLs7BPiX7g=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4990.eurprd05.prod.outlook.com (20.177.49.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.10; Fri, 17 Jan 2020 00:07:18 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2644.015; Fri, 17 Jan 2020
 00:07:18 +0000
Received: from smtp.office365.com (209.116.155.178) by BYAPR03CA0003.namprd03.prod.outlook.com (2603:10b6:a02:a8::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Fri, 17 Jan 2020 00:07:16 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Paul Blakey <paulb@mellanox.com>,
        Roi Dayan <roid@mellanox.com>, Oz Shlomo <ozsh@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 12/16] net/mlx5: Allow creating autogroups with reserved
 entries
Thread-Topic: [net-next 12/16] net/mlx5: Allow creating autogroups with
 reserved entries
Thread-Index: AQHVzMoUGEsEpjlwp0eHF8JU3SzhgA==
Date:   Fri, 17 Jan 2020 00:07:18 +0000
Message-ID: <20200117000619.696775-13-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: afe1ba1e-819e-4b2c-5844-08d79ae13730
x-ms-traffictypediagnostic: VI1PR05MB4990:|VI1PR05MB4990:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB49909B75E56B2AB9446F5A2DBE310@VI1PR05MB4990.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2803;
x-forefront-prvs: 0285201563
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(189003)(199004)(64756008)(6512007)(52116002)(66476007)(26005)(81166006)(86362001)(16526019)(81156014)(8676002)(2616005)(66556008)(186003)(6486002)(956004)(71200400001)(498600001)(36756003)(66446008)(54906003)(1076003)(5660300002)(2906002)(6506007)(4326008)(110136005)(8936002)(66946007)(107886003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4990;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: W7T4dIIbB4aOyQP3MLyXXXi67sOID/JuZoEl/SLxN1tS1uLZHrA93kRja/lFLBY4HGF6PikFaxiRdBTy/SzBz5bHIshO/ceAyge+2msNezFXOFsRzJlu+vQxpYSfU7FmTIw31azTUi0Wo9nui44lxoGqMfVU4oN78yC4QDR6oPyUfdSbelf6xyKKyHsonh2gY/sKIxiDHslvmr706PiGimeUS7kOeShzvrrBRMZJYoR4fj+Q9wm0on2YvK82Ib8oewITlg+uoiR3LkgG5RMDdpFNyWJu5OaGYNYKJNr+2Qr62GreN2bbYIBNuFt+NORvL382tSHjltY4nw28o4VDJ8fZ0VfX7Ay9WAycopIEnT4+Jw3zF6Xz5d+dJ+Lg+CCpcr+da1wlM7PisXh6iHv+91waQH6Bmuyac5unYaqC6YGCNfTemtINHxq3avK78J8gA3KZ97rNnRCJa+iq+JUrIDMTzW0yKh2Voy+b8mwka2QqqXgzf8fctAoKMeiGMeHdh+8kZ/utNrfKGmD5+tm+Wehi+EwDTPIv/t2Fqa+fmVQ=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afe1ba1e-819e-4b2c-5844-08d79ae13730
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2020 00:07:18.5395
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1mS6PRrT8UaU6T2pDRER94a72QmWMd6hj9QE3uh9cNGSA+58ZpiQNRa8WtQwp3jtDXAgnVTv725hOsiFdgqhBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4990
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@mellanox.com>

Exclude the last n entries for an autogrouped flow table.

Reserving entries at the end of the FT will ensure that this FG will be
the last to be evaluated. This will be used in the next patch to create
a miss group enabling custom actions on FT miss.

Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/fs_core.c | 26 ++++++++++++-------
 .../net/ethernet/mellanox/mlx5/core/fs_core.h |  1 +
 include/linux/mlx5/fs.h                       |  1 +
 3 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/fs_core.c
index 355a424f4506..c7a16ae05fa8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -579,7 +579,9 @@ static void del_sw_flow_group(struct fs_node *node)
=20
 	rhashtable_destroy(&fg->ftes_hash);
 	ida_destroy(&fg->fte_allocator);
-	if (ft->autogroup.active && fg->max_ftes =3D=3D ft->autogroup.group_size)
+	if (ft->autogroup.active &&
+	    fg->max_ftes =3D=3D ft->autogroup.group_size &&
+	    fg->start_index < ft->autogroup.max_fte)
 		ft->autogroup.num_groups--;
 	err =3D rhltable_remove(&ft->fgs_hash,
 			      &fg->hash,
@@ -1121,9 +1123,14 @@ struct mlx5_flow_table*
 mlx5_create_auto_grouped_flow_table(struct mlx5_flow_namespace *ns,
 				    struct mlx5_flow_table_attr *ft_attr)
 {
+	int num_reserved_entries =3D ft_attr->autogroup.num_reserved_entries;
+	int autogroups_max_fte =3D ft_attr->max_fte - num_reserved_entries;
+	int max_num_groups =3D ft_attr->autogroup.max_num_groups;
 	struct mlx5_flow_table *ft;
=20
-	if (ft_attr->autogroup.max_num_groups > ft_attr->max_fte)
+	if (max_num_groups > autogroups_max_fte)
+		return ERR_PTR(-EINVAL);
+	if (num_reserved_entries > ft_attr->max_fte)
 		return ERR_PTR(-EINVAL);
=20
 	ft =3D mlx5_create_flow_table(ns, ft_attr);
@@ -1131,10 +1138,10 @@ mlx5_create_auto_grouped_flow_table(struct mlx5_flo=
w_namespace *ns,
 		return ft;
=20
 	ft->autogroup.active =3D true;
-	ft->autogroup.required_groups =3D ft_attr->autogroup.max_num_groups;
+	ft->autogroup.required_groups =3D max_num_groups;
+	ft->autogroup.max_fte =3D autogroups_max_fte;
 	/* We save place for flow groups in addition to max types */
-	ft->autogroup.group_size =3D ft->max_fte /
-				   (ft->autogroup.required_groups + 1);
+	ft->autogroup.group_size =3D autogroups_max_fte / (max_num_groups + 1);
=20
 	return ft;
 }
@@ -1156,7 +1163,7 @@ struct mlx5_flow_group *mlx5_create_flow_group(struct=
 mlx5_flow_table *ft,
 	struct mlx5_flow_group *fg;
 	int err;
=20
-	if (ft->autogroup.active)
+	if (ft->autogroup.active && start_index < ft->autogroup.max_fte)
 		return ERR_PTR(-EPERM);
=20
 	down_write_ref_node(&ft->node, false);
@@ -1329,9 +1336,10 @@ static struct mlx5_flow_group *alloc_auto_flow_group=
(struct mlx5_flow_table  *ft
 						     const struct mlx5_flow_spec *spec)
 {
 	struct list_head *prev =3D &ft->node.children;
-	struct mlx5_flow_group *fg;
+	u32 max_fte =3D ft->autogroup.max_fte;
 	unsigned int candidate_index =3D 0;
 	unsigned int group_size =3D 0;
+	struct mlx5_flow_group *fg;
=20
 	if (!ft->autogroup.active)
 		return ERR_PTR(-ENOENT);
@@ -1339,7 +1347,7 @@ static struct mlx5_flow_group *alloc_auto_flow_group(=
struct mlx5_flow_table  *ft
 	if (ft->autogroup.num_groups < ft->autogroup.required_groups)
 		group_size =3D ft->autogroup.group_size;
=20
-	/*  ft->max_fte =3D=3D ft->autogroup.max_types */
+	/*  max_fte =3D=3D ft->autogroup.max_types */
 	if (group_size =3D=3D 0)
 		group_size =3D 1;
=20
@@ -1352,7 +1360,7 @@ static struct mlx5_flow_group *alloc_auto_flow_group(=
struct mlx5_flow_table  *ft
 		prev =3D &fg->node.list;
 	}
=20
-	if (candidate_index + group_size > ft->max_fte)
+	if (candidate_index + group_size > max_fte)
 		return ERR_PTR(-ENOSPC);
=20
 	fg =3D alloc_insert_flow_group(ft,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h b/drivers/ne=
t/ethernet/mellanox/mlx5/core/fs_core.h
index c2621b911563..be5f5e32c1e8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
@@ -164,6 +164,7 @@ struct mlx5_flow_table {
 		unsigned int		required_groups;
 		unsigned int		group_size;
 		unsigned int		num_groups;
+		unsigned int		max_fte;
 	} autogroup;
 	/* Protect fwd_rules */
 	struct mutex			lock;
diff --git a/include/linux/mlx5/fs.h b/include/linux/mlx5/fs.h
index 81f393fb7d96..4cae16016b2b 100644
--- a/include/linux/mlx5/fs.h
+++ b/include/linux/mlx5/fs.h
@@ -155,6 +155,7 @@ struct mlx5_flow_table_attr {
=20
 	struct {
 		int max_num_groups;
+		int num_reserved_entries;
 	} autogroup;
 };
=20
--=20
2.24.1

