Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40346163AC8
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 04:06:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728323AbgBSDGj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 22:06:39 -0500
Received: from mail-eopbgr00088.outbound.protection.outlook.com ([40.107.0.88]:65095
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728202AbgBSDGh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Feb 2020 22:06:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hstSYCiBonkmxptthEmSrjHgxBdvOzSF9nacMrUE1LPMIxIxhj56ONs9Tzt3UAZ4TndCR1li4FQhqNiWNjJ3mu6S9gYmRSzrVSJ55mWUFahh5pPjs7OrIdeVYE68a36OarymrceiH1wF12D908Au7cPzzMyhNSBGxWbgNxnil/ahXqqtCgaXllNkl1ab6msJdrPrgaUrqtzXA/irRpP06JUiJgOYzo8lRBesc9SnA1QUETyaQEXoMyx1yV3vARJWPYFPX8fNaI37ReZ8A+vcTImvJIpXz9ZrFuZAHuvTkavSuoLizjn5cZjpvEFaltCP81PKJBb7ZdSYvVl0EV0/Gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AzygycI5r0bxyEcDfsIVS4PDwtzyiSBw/KKOyKc4/2E=;
 b=gDXUe+lNbIPrXGdWMrQCfql/pHDxl3n3/GjOKVbmEAXxLwH1E0Td9RG5pHbsI7F9PCr4Tm7ue7l5nwJQSMPY+xadn5o9cdGFXWLsmRyH0mVH9ZniqEevK2ZCyD0ijH7vHyWX7YPs2Cnb54uWFfdIkHWawb5Sr+aTifqFJ0STrAv+KaAUjPabXDze9slYPadUN5kAHYZ9z4tOj44e1DPsov4OOFSbUC5ZUHPmoVABrOHH+TmGaHk0iZkDPaUROplsjAPgvkLGhPq/H0p/EXI2PeK0u+XGvdDgrL69lRF9AmbPvuR7w0Zq7i+dJXV45UKmAxqdvjVy2A0AjsrgR37sOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AzygycI5r0bxyEcDfsIVS4PDwtzyiSBw/KKOyKc4/2E=;
 b=YYGgCgrRpehed5ADaPGjHjsbbL6cjrU28zjI2j9hdVYBF0hRGbelzQHmFc97A9HUhQ2VxuYMnXFu5G2Ngs/PJ8vPQ2GPKE0qG4RFRKcjGSgbukTEdnn6tYJUoiYLiUgslTMohwl6Qf1URoYwWq/CpAum7u14zwp9RF7nNcyMSLg=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5853.eurprd05.prod.outlook.com (20.178.125.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.25; Wed, 19 Feb 2020 03:06:35 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2729.028; Wed, 19 Feb 2020
 03:06:35 +0000
Received: from smtp.office365.com (73.15.39.150) by BYAPR05CA0089.namprd05.prod.outlook.com (2603:10b6:a03:e0::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.6 via Frontend Transport; Wed, 19 Feb 2020 03:06:33 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Dmytro Linkin <dmitrolin@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 5/7] net/mlx5e: Don't clear the whole vf config when switching
 modes
Thread-Topic: [net 5/7] net/mlx5e: Don't clear the whole vf config when
 switching modes
Thread-Index: AQHV5tGXujJydkMryU2Ee68OvSfyFA==
Date:   Wed, 19 Feb 2020 03:06:34 +0000
Message-ID: <20200219030548.13215-6-saeedm@mellanox.com>
References: <20200219030548.13215-1-saeedm@mellanox.com>
In-Reply-To: <20200219030548.13215-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BYAPR05CA0089.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::30) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 60dd78c6-bd4a-440b-c554-08d7b4e8ba55
x-ms-traffictypediagnostic: VI1PR05MB5853:|VI1PR05MB5853:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5853818721022D715EBB936DBE100@VI1PR05MB5853.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:366;
x-forefront-prvs: 0318501FAE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(396003)(39860400002)(366004)(346002)(189003)(199004)(956004)(2616005)(5660300002)(26005)(16526019)(81166006)(52116002)(4326008)(110136005)(316002)(6506007)(186003)(81156014)(2906002)(8936002)(66476007)(8676002)(54906003)(1076003)(64756008)(6512007)(71200400001)(478600001)(66556008)(66446008)(86362001)(36756003)(6486002)(107886003)(66946007)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5853;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vn3hX6SJ4j7/I9f2fVD+MuOHhldDwXqsftSStboV23xrcHwUGH2cmYqX9Pgq6mereE5kcz/NLuQPrNbPwkCeD1aIe8VmQrAIntJQYqa+ucYDLswBoIdU2DZY/v38Gt39OfB35ELeBBrWOrtKweC9je32QVMJojZH9aOOpwOBBwjlX0NxICoAXG+UdwQr9V6fTZpRYShBQu/A5ZiPt3uCABScegAVxrVsE/5ba4MDrSWCt4+1ewH+n5dkERZ2aodpDx+oAglZQ8Hq8lz1JxRA3dAxBXfGwNF9A6BS9RY13qGsjhexQ03DO8pGa/iizXwhqpBnZ5Emu24X7SHQNEsxloqI3randBAKBfpK4J/X0Lkb7cfn+60ftxSONDZIgmdFSZTzLNx0N9oBa53Kn6AtflW2G/sjfUDDhSTULnp7hOWnRrQBCJKSqGO34n53sLFF+hGrHlon/Hz27SS80yoSDiPaEcw/8qd+Vpn+BA4oJJWN8T0dDW379hPAINhst9ydzgAAQaM4t/2Sz9vMk7wvax3X0gQXP5rkEU1538RTvWE=
x-ms-exchange-antispam-messagedata: P+tVuQONerwHVGznZZyykLiDsrJV2iTbtXyXgTobJ+uap3JPV/Q4BTv1eHLE4LHH39CDDWdl8M+DZgNkvC6s1BdeT8U8FFHYcCBAD5YshCEQ/b+dOVZrmX50P8LDvqmLrCnz3r0ApVFBYtMjLgg0mQ==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60dd78c6-bd4a-440b-c554-08d7b4e8ba55
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Feb 2020 03:06:35.0178
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 17aIpOK6gf9CW0NUhXrJZ22EDL5X8xXI0PTy2Q2UFs7gkcYLn6gkLuLXoz8WuM36oA/ncYDfCbuVDk2EdLzI8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5853
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmytro Linkin <dmitrolin@mellanox.com>

There is no need to reset all vf config (except link state) between
legacy and switchdev modes changes.
Also, set link state to AUTO, when legacy enabled.

Fixes: 3b83b6c2e024 ("net/mlx5e: Clear VF config when switching modes")
Signed-off-by: Dmytro Linkin <dmitrolin@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c          | 6 +++++-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 4 ++--
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/eswitch.c
index 564d42605892..e49acd0c5da5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -459,12 +459,16 @@ static void esw_destroy_legacy_table(struct mlx5_eswi=
tch *esw)
=20
 static int esw_legacy_enable(struct mlx5_eswitch *esw)
 {
-	int ret;
+	struct mlx5_vport *vport;
+	int ret, i;
=20
 	ret =3D esw_create_legacy_table(esw);
 	if (ret)
 		return ret;
=20
+	mlx5_esw_for_each_vf_vport(esw, i, vport, esw->esw_funcs.num_vfs)
+		vport->info.link_state =3D MLX5_VPORT_ADMIN_STATE_AUTO;
+
 	ret =3D mlx5_eswitch_enable_pf_vf_vports(esw, MLX5_LEGACY_SRIOV_VPORT_EVE=
NTS);
 	if (ret)
 		esw_destroy_legacy_table(esw);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 979f13bdc203..1a57b2bd74b8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1172,7 +1172,7 @@ static int esw_offloads_start(struct mlx5_eswitch *es=
w,
 		return -EINVAL;
 	}
=20
-	mlx5_eswitch_disable(esw, true);
+	mlx5_eswitch_disable(esw, false);
 	mlx5_eswitch_update_num_of_vfs(esw, esw->dev->priv.sriov.num_vfs);
 	err =3D mlx5_eswitch_enable(esw, MLX5_ESWITCH_OFFLOADS);
 	if (err) {
@@ -2065,7 +2065,7 @@ static int esw_offloads_stop(struct mlx5_eswitch *esw=
,
 {
 	int err, err1;
=20
-	mlx5_eswitch_disable(esw, true);
+	mlx5_eswitch_disable(esw, false);
 	err =3D mlx5_eswitch_enable(esw, MLX5_ESWITCH_LEGACY);
 	if (err) {
 		NL_SET_ERR_MSG_MOD(extack, "Failed setting eswitch to legacy");
--=20
2.24.1

