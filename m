Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02344148F42
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 21:21:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404317AbgAXUVL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 15:21:11 -0500
Received: from mail-eopbgr40044.outbound.protection.outlook.com ([40.107.4.44]:63396
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387421AbgAXUVJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jan 2020 15:21:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xp2r4lF7RgWKHo8bHE4fPY0uuiA6+RMyWskyyzWaBYsvy+xTiB5NoqedWkJxVKWq7WPPEDZWVCPKzNKcTEaZf7/frKW/J81ciWyk1XLq+zSdMOx62ee+Rjdp+VxVaJHHxcIMg7BYEH8ACA33omKtP3FASFX+sCPVZAHuBQUOg9KR1nlSgWPxVyqojQqFj3XSKRriycyAS5XSnG8DwrBy4egbwQWWi7/iYT3cd2sYHwUIQaJ389E1o4F/XJm6fk1BQnFSBCXfrjs6BMVBNDUM7JLV0H0lyk+pY8rS/jt0W2DS86o87TCm8Y+NphPpgWsZJKxXeVP4tk/MBd5UF1Zh4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3SYjvROxU/D4lupCHkrM6m/OamfzhKBtEjqBFkZaosw=;
 b=Tmkiw2HtrWlKrvddosCsOfziYMsyUvYFGO56mkpLZZ9nSwJHgxk/14FOLXTv5smDF3N1iP3eAqR7Q78xQjbyDjJeSUTaKye9agfAF78Ici1PV7oRJE8LC/T4z1SYgHf0jnibCs9v/C54z1b08Ja1ktDc2Xi+sJma3Z5mfGOvVaZQ/xvCpObiNSCRuAJ2ZWZDE9c+KVVFnDsIzlhKyW6WZo7hwVHs5hTGzse8v9q8CNjmGMmVDX/O22T+bqVbLF20o4Hinc8CX89yK69Vorw+IUElJtUCdoNs1hTZ4CJpSgXNCZie1JhyY+dwBxam5UDxzbbN6MApzGP02JZnkJhfsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3SYjvROxU/D4lupCHkrM6m/OamfzhKBtEjqBFkZaosw=;
 b=KzJIAEYOqETP20jMCq1rcFhQEGl4+c7k8w4WS2/ZOiPkNOxbWenY5wezgUTlH8mMwp15ObZC+UbhAvPsRDo7Y+CpbPB0PAdCfOH80NC5ik+7rEUCQM71rf+GncqpQU86/yc9E0DhwDtRyE9YsgKBH7/fT80D2JNScnZtmtvrBew=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5552.eurprd05.prod.outlook.com (20.177.202.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.20; Fri, 24 Jan 2020 20:21:00 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2644.027; Fri, 24 Jan 2020
 20:21:00 +0000
Received: from smtp.office365.com (209.116.155.178) by BYAPR01CA0071.prod.exchangelabs.com (2603:10b6:a03:94::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.21 via Frontend Transport; Fri, 24 Jan 2020 20:20:59 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Dmytro Linkin <dmitrolin@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 6/9] net/mlx5e: Clear VF config when switching modes
Thread-Topic: [net 6/9] net/mlx5e: Clear VF config when switching modes
Thread-Index: AQHV0vPL21kxKt3DMESIU1mp1WRTUg==
Date:   Fri, 24 Jan 2020 20:21:00 +0000
Message-ID: <20200124202033.13421-7-saeedm@mellanox.com>
References: <20200124202033.13421-1-saeedm@mellanox.com>
In-Reply-To: <20200124202033.13421-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR01CA0071.prod.exchangelabs.com (2603:10b6:a03:94::48)
 To VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e40795ae-97e5-4e68-616f-08d7a10aed93
x-ms-traffictypediagnostic: VI1PR05MB5552:|VI1PR05MB5552:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB55520F9045DA12409D0469C3BE0E0@VI1PR05MB5552.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2089;
x-forefront-prvs: 02929ECF07
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(366004)(346002)(396003)(39850400004)(199004)(189003)(64756008)(66446008)(66946007)(4326008)(66476007)(107886003)(66556008)(316002)(1076003)(6512007)(6916009)(71200400001)(54906003)(16526019)(186003)(52116002)(26005)(6486002)(6506007)(956004)(2616005)(2906002)(478600001)(5660300002)(86362001)(36756003)(81156014)(81166006)(8936002)(8676002)(6666004)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5552;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: R2DTJOK1VYoVdnI+xuliOBiWdU3duLVL9mI6+47c/mBsVB/BB9vcn0M/ku/aBhi0MmNMoHYSVQ2pG7kxX+PsBSIxrWyFfIv33zg2OjaOQvXTSP8YHnDPAK0GyZjhmDKhvCSbnKkg46zWAPJZOgfvbiCGp4CAWFw59FpnmD/BDwc3Ue4tHweQmlDh/QMJv4F9aVUQpk5ViFiO1VYkane+n1uDiG2k7ujQfwrYDkCDGpbZjsul0dZ9MyNCAVtWYWIQZ8kfRbfDjzxqigSClkCmERARawqHmuXbIynPRn4YlSznpUUiHAImr/R7RS/tL5RpYy9/BfFR1wCSNspHCJOoVp7V5EXVMagQlLpvmlSBdg0vufrYfPyOj/bJx1MPWNWw9gGmzjNc5JlYMnuHW5qXSnfsCdXQmbXesR8Z9FWFyh1VeUmPDbysIKUNnSAUlbslzYqlbIKmKuCVaDLBjV9ggEt3CKHuYaOUUL5qV1MNZP2bHMjGSTEBtEcD9wD6kkDQ/IXOOtzdFogli9A27QT6i+IRIvZ+XbxcCrOszlIPQOU=
x-ms-exchange-antispam-messagedata: IVk43fTNo2DzbEG4DVkMd4Wn0jXUKQWsnRUqZpQnHF0Q4uWD9+962odp37ZAavec57iNQ75kbzf4ukUUGZ/eM49q+910VcSHUO+oB5hhiN9y6U2SHqBsYIjPQH/qb2AMw9VsHMRqcEFaAz1XmMpdqg==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e40795ae-97e5-4e68-616f-08d7a10aed93
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jan 2020 20:21:00.5987
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 87L8aUb1ktfaSMwpimdVQ4/p3sbZ0SiYqpQJVmOBgC1N0T6OXYNNZcGddDdc2RIXlhrVMR7PgqonWl5zmhLZoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5552
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmytro Linkin <dmitrolin@mellanox.com>

Currently VF in LEGACY mode are not able to go up. Also in OFFLOADS
mode, when switching to it first time, VF can go up independently to
his representor, which is not expected.
Perform clearing of VF config when switching modes and set link state
to AUTO as default value. Also, when switching to OFFLOADS mode set
link state to DOWN, which allow VF link state to be controlled by its
REP.

Fixes: 1ab2068a4c66 ("net/mlx5: Implement vports admin state backup/restore=
")
Fixes: 556b9d16d3f5 ("net/mlx5: Clear VF's configuration on disabling SRIOV=
")
Signed-off-by: Dmytro Linkin <dmitrolin@mellanox.com>
Signed-off-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c     |  4 +++-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c    | 11 ++++++++---
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/eswitch.c
index 2c965ad0d744..3df3604e8929 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1928,8 +1928,10 @@ static void mlx5_eswitch_clear_vf_vports_info(struct=
 mlx5_eswitch *esw)
 	struct mlx5_vport *vport;
 	int i;
=20
-	mlx5_esw_for_each_vf_vport(esw, i, vport, esw->esw_funcs.num_vfs)
+	mlx5_esw_for_each_vf_vport(esw, i, vport, esw->esw_funcs.num_vfs) {
 		memset(&vport->info, 0, sizeof(vport->info));
+		vport->info.link_state =3D MLX5_VPORT_ADMIN_STATE_AUTO;
+	}
 }
=20
 /* Public E-Switch API */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index b8fe44ea44c3..3e6412783078 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1377,7 +1377,7 @@ static int esw_offloads_start(struct mlx5_eswitch *es=
w,
 		return -EINVAL;
 	}
=20
-	mlx5_eswitch_disable(esw, false);
+	mlx5_eswitch_disable(esw, true);
 	mlx5_eswitch_update_num_of_vfs(esw, esw->dev->priv.sriov.num_vfs);
 	err =3D mlx5_eswitch_enable(esw, MLX5_ESWITCH_OFFLOADS);
 	if (err) {
@@ -2220,7 +2220,8 @@ int mlx5_esw_funcs_changed_handler(struct notifier_bl=
ock *nb, unsigned long type
=20
 int esw_offloads_enable(struct mlx5_eswitch *esw)
 {
-	int err;
+	struct mlx5_vport *vport;
+	int err, i;
=20
 	if (MLX5_CAP_ESW_FLOWTABLE_FDB(esw->dev, reformat) &&
 	    MLX5_CAP_ESW_FLOWTABLE_FDB(esw->dev, decap))
@@ -2237,6 +2238,10 @@ int esw_offloads_enable(struct mlx5_eswitch *esw)
 	if (err)
 		goto err_vport_metadata;
=20
+	/* Representor will control the vport link state */
+	mlx5_esw_for_each_vf_vport(esw, i, vport, esw->esw_funcs.num_vfs)
+		vport->info.link_state =3D MLX5_VPORT_ADMIN_STATE_DOWN;
+
 	err =3D mlx5_eswitch_enable_pf_vf_vports(esw, MLX5_VPORT_UC_ADDR_CHANGE);
 	if (err)
 		goto err_vports;
@@ -2266,7 +2271,7 @@ static int esw_offloads_stop(struct mlx5_eswitch *esw=
,
 {
 	int err, err1;
=20
-	mlx5_eswitch_disable(esw, false);
+	mlx5_eswitch_disable(esw, true);
 	err =3D mlx5_eswitch_enable(esw, MLX5_ESWITCH_LEGACY);
 	if (err) {
 		NL_SET_ERR_MSG_MOD(extack, "Failed setting eswitch to legacy");
--=20
2.24.1

