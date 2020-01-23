Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05DC414620D
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 07:40:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727296AbgAWGkD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 01:40:03 -0500
Received: from mail-eopbgr80041.outbound.protection.outlook.com ([40.107.8.41]:42992
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727093AbgAWGkC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jan 2020 01:40:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ds835tsegJYmRBjTHMP0nvOyy1/VEXm60TKyoAVQ13zjcGUFx3vTzUgcWisoT6nNWjCbRmADseBpjmJOsVyiVAK4HVAQsJr3HlSEdpyd4v19s30XS0kdjYW1b3g0AvO9J9WvJ/gpjVRveV0YWuz6GxB9NWnmuaw0SW7OuZsUAKb68PtG5H7SZ8J9LBojIYqlvpHiI/xYEeABQcZWZmmLjnnLXc5bQZ47F4q83fu0/pEW070vDPc0jhb2ndeGhRWVpl59S+So64sCi/jmJzln3Rli3dFUfDqA/wP1jMALU8lTpvy9bnywpnHUyFeFouVdok29Nprw+vyVuKOE9FWqTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cyInPSeatm6b7dPr/sCJZkKTa/Qcj3XErx+Ic+zek7o=;
 b=m90PUwD9oZ25gCjVVFE8zk/PVqEQ0BYm97w78K9IUn8s+OCVEqLCB16L17SMXqjyy4x01zh1kvr41gLavPyRtAcyh4jlZhP5Gzvehd6qDMR0EJHphW5hN1TRrOzwmlWK9QAw7hwCjdCFi8mZf8mas1bZsQn59pHhzeTYR/2Ms4IGWvTIYy3JZlb8zGD7p8IfbFssoeugEWiQtUfKt7LD2kf7AU8Me2FRNGAbxQaQob2/ZaGSpb7kU7MLUuoM6n5LwFc3pA2RceGeC+iyUBY07y/IYdNf9hqfQqr94c+ClHSI+L4MXBGuUlkQqZxNyqQPFeMK7ijmQjlbtHtmG7VWrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cyInPSeatm6b7dPr/sCJZkKTa/Qcj3XErx+Ic+zek7o=;
 b=ADe4V5EOCweiLhtQulh5uO6C9QtRSiFZjFq7qpvfU0XUnMNhvnomsqHsTkBMNSAFg23OobfkQQ3W8GFyRVUQJSgaspG4i/KF/68+geCd3xbRq+RJB71A9HSCiTgIakf+YmBZXAuo03QKP/0ieEOdzYxyX9avUHCw6kvfkZtCzjg=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4941.eurprd05.prod.outlook.com (20.177.48.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Thu, 23 Jan 2020 06:39:51 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2644.027; Thu, 23 Jan 2020
 06:39:51 +0000
Received: from smtp.office365.com (73.15.39.150) by BYAPR21CA0027.namprd21.prod.outlook.com (2603:10b6:a03:114::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2686.5 via Frontend Transport; Thu, 23 Jan 2020 06:39:49 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Roi Dayan <roid@mellanox.com>,
        Eli Britstein <elibr@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 08/15] net/mlx5e: Move uplink rep init/cleanup code into
 own functions
Thread-Topic: [net-next 08/15] net/mlx5e: Move uplink rep init/cleanup code
 into own functions
Thread-Index: AQHV0bfpm5+dNAtW7UOOg6Cwv0G4bA==
Date:   Thu, 23 Jan 2020 06:39:51 +0000
Message-ID: <20200123063827.685230-9-saeedm@mellanox.com>
References: <20200123063827.685230-1-saeedm@mellanox.com>
In-Reply-To: <20200123063827.685230-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BYAPR21CA0027.namprd21.prod.outlook.com
 (2603:10b6:a03:114::37) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 81cfbbb9-521f-4173-7a63-08d79fcf0c67
x-ms-traffictypediagnostic: VI1PR05MB4941:|VI1PR05MB4941:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB494174D38D4DFD3AF232AE47BE0F0@VI1PR05MB4941.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2958;
x-forefront-prvs: 029174C036
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(39860400002)(376002)(346002)(366004)(199004)(189003)(5660300002)(107886003)(8936002)(6916009)(81166006)(81156014)(8676002)(186003)(6512007)(6486002)(4326008)(86362001)(1076003)(6666004)(16526019)(71200400001)(26005)(36756003)(52116002)(6506007)(2906002)(66946007)(2616005)(66556008)(956004)(64756008)(66446008)(316002)(478600001)(54906003)(66476007)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4941;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: J9bsZtBu8K0gSyB9deBVvV4V2gr2Qrf8Em77/YdBblxH8UQwo6a+jLg1JF+tupkim9z1GxKUh3fWj5VFbjhxyz47ZZStSKhxJQqJZL9sqS8xblfamzqdpFYWrzyUnQVyQHBD/sxAwJ7+TtD6/k1YVkE5vTfGVtU6TMM+c7H2uLHd+uQB71CmoOUQXzQagh+8MHn1s3i2WbsI6BYKuo/eICmLlh0HdhrVJTBXK+Hcm5B9NlxJwqTy9+PSggog08aPIC31OMVTHDkV6TmTEPR99g+Tx2wEi6cs7KAbueNS+vq15JLfx5flesi3AKBPmGvy4a24GuOEIUesTX2cIcrB+wF7VuihnwtRhka1+lLQrtPbRJtL17p3eiqdPXsMqZGARU8IWuRrBjCcTJHoXDORLS/aDaFCmcenOQ2l8F9Bce0iNBkiuRmAteucnbpsm7e/gBHC0KGNrwIeZeUu/pQO9kWM0MhIEp/vmKXAzcOOvw4WeGhFOB+JpqlKrI1KbOqKj0WGkikLa0DLmfc8dnPql/4mag2mb+NYBNtqsIXRjIA=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81cfbbb9-521f-4173-7a63-08d79fcf0c67
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2020 06:39:51.2978
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Z6QkIENDq4rs4sSJnJImKxxqsnBuuSbscla3YWJq8P5Kzqi4ye2TJsjubgkLf+6GGM59LrrcuNmBi3qgFATaAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4941
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@mellanox.com>

Clean up the code and allows to call uplink rep init/cleanup
from different location later.
To be used later for a new uplink representor mode.

Signed-off-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Eli Britstein <elibr@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  | 81 ++++++++++++-------
 1 file changed, 51 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net=
/ethernet/mellanox/mlx5/core/en_rep.c
index 446eb4d6c983..60c79123824b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1674,10 +1674,46 @@ static void mlx5e_cleanup_rep_rx(struct mlx5e_priv =
*priv)
 	mlx5e_close_drop_rq(&priv->drop_rq);
 }
=20
+static int mlx5e_init_uplink_rep_tx(struct mlx5e_rep_priv *rpriv)
+{
+	struct mlx5_rep_uplink_priv *uplink_priv;
+	struct net_device *netdev;
+	struct mlx5e_priv *priv;
+	int err;
+
+	netdev =3D rpriv->netdev;
+	priv =3D netdev_priv(netdev);
+	uplink_priv =3D &rpriv->uplink_priv;
+
+	mutex_init(&uplink_priv->unready_flows_lock);
+	INIT_LIST_HEAD(&uplink_priv->unready_flows);
+
+	/* init shared tc flow table */
+	err =3D mlx5e_tc_esw_init(&uplink_priv->tc_ht);
+	if (err)
+		return err;
+
+	mlx5_init_port_tun_entropy(&uplink_priv->tun_entropy, priv->mdev);
+
+	/* init indirect block notifications */
+	INIT_LIST_HEAD(&uplink_priv->tc_indr_block_priv_list);
+	uplink_priv->netdevice_nb.notifier_call =3D mlx5e_nic_rep_netdevice_event=
;
+	err =3D register_netdevice_notifier(&uplink_priv->netdevice_nb);
+	if (err) {
+		mlx5_core_err(priv->mdev, "Failed to register netdev notifier\n");
+		goto tc_esw_cleanup;
+	}
+
+	return 0;
+
+tc_esw_cleanup:
+	mlx5e_tc_esw_cleanup(&uplink_priv->tc_ht);
+	return err;
+}
+
 static int mlx5e_init_rep_tx(struct mlx5e_priv *priv)
 {
 	struct mlx5e_rep_priv *rpriv =3D priv->ppriv;
-	struct mlx5_rep_uplink_priv *uplink_priv;
 	int err;
=20
 	err =3D mlx5e_create_tises(priv);
@@ -1687,52 +1723,37 @@ static int mlx5e_init_rep_tx(struct mlx5e_priv *pri=
v)
 	}
=20
 	if (rpriv->rep->vport =3D=3D MLX5_VPORT_UPLINK) {
-		uplink_priv =3D &rpriv->uplink_priv;
-
-		mutex_init(&uplink_priv->unready_flows_lock);
-		INIT_LIST_HEAD(&uplink_priv->unready_flows);
-
-		/* init shared tc flow table */
-		err =3D mlx5e_tc_esw_init(&uplink_priv->tc_ht);
+		err =3D mlx5e_init_uplink_rep_tx(rpriv);
 		if (err)
 			goto destroy_tises;
-
-		mlx5_init_port_tun_entropy(&uplink_priv->tun_entropy, priv->mdev);
-
-		/* init indirect block notifications */
-		INIT_LIST_HEAD(&uplink_priv->tc_indr_block_priv_list);
-		uplink_priv->netdevice_nb.notifier_call =3D mlx5e_nic_rep_netdevice_even=
t;
-		err =3D register_netdevice_notifier(&uplink_priv->netdevice_nb);
-		if (err) {
-			mlx5_core_err(priv->mdev, "Failed to register netdev notifier\n");
-			goto tc_esw_cleanup;
-		}
 	}
=20
 	return 0;
=20
-tc_esw_cleanup:
-	mlx5e_tc_esw_cleanup(&uplink_priv->tc_ht);
 destroy_tises:
 	mlx5e_destroy_tises(priv);
 	return err;
 }
=20
+static void mlx5e_cleanup_uplink_rep_tx(struct mlx5e_rep_priv *rpriv)
+{
+	/* clean indirect TC block notifications */
+	unregister_netdevice_notifier(&rpriv->uplink_priv.netdevice_nb);
+	mlx5e_rep_indr_clean_block_privs(rpriv);
+
+	/* delete shared tc flow table */
+	mlx5e_tc_esw_cleanup(&rpriv->uplink_priv.tc_ht);
+	mutex_destroy(&rpriv->uplink_priv.unready_flows_lock);
+}
+
 static void mlx5e_cleanup_rep_tx(struct mlx5e_priv *priv)
 {
 	struct mlx5e_rep_priv *rpriv =3D priv->ppriv;
=20
 	mlx5e_destroy_tises(priv);
=20
-	if (rpriv->rep->vport =3D=3D MLX5_VPORT_UPLINK) {
-		/* clean indirect TC block notifications */
-		unregister_netdevice_notifier(&rpriv->uplink_priv.netdevice_nb);
-		mlx5e_rep_indr_clean_block_privs(rpriv);
-
-		/* delete shared tc flow table */
-		mlx5e_tc_esw_cleanup(&rpriv->uplink_priv.tc_ht);
-		mutex_destroy(&rpriv->uplink_priv.unready_flows_lock);
-	}
+	if (rpriv->rep->vport =3D=3D MLX5_VPORT_UPLINK)
+		mlx5e_cleanup_uplink_rep_tx(rpriv);
 }
=20
 static void mlx5e_rep_enable(struct mlx5e_priv *priv)
--=20
2.24.1

