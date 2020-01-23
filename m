Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17790146210
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 07:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728609AbgAWGkI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 01:40:08 -0500
Received: from mail-eopbgr80074.outbound.protection.outlook.com ([40.107.8.74]:3150
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726968AbgAWGkH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jan 2020 01:40:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T/qsv2FqQoAewaOrGq5Wn4JkRz5Tzn3m3OFScD7TImnZPcaWI/+x9emj0Ry9t0nbzHjg0QgRAJe5tEdqnl4gs1QX+W7LYw8lK1Sle6rBQkxtyDwPGjzn0sF2DXBOztm89ha38r9qBQiwXjVZ+O71Dmq6cMf6L5OpZstidkHFxCfN/MKqt2F1EyOc51DH9bKWQ5uoUYKDbPoAdgrGKd61bFhY/UvkaXQGCmvWdLwBkh6Q0z3n7iFSeuW7YD7wJAuxM+1g0W8k/n/UImUX2fSQtROgUuva5Is4oTyADrZLMUHGtqJlaptC17A2UBeYb7WpPWJK+w2cWDbJWqEghdtLMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dy8Eu8WZXgqvaQEwdHYcDWScZLt2YIaJWBknUOxTSCQ=;
 b=Fn7SSIallXfOEmZpVevanyLlynNsWvso9CObjk2AABCF2rfyflk4NRtgBQ7HZT7jtKJ/wmI1brzv8NnzN+Y9tKNthiW5cIsOb3CtVjapV4qH1ESTClc2y/1ZojqvymFSIcOBCRqTKYKQZ3u9C2oPxzpb7aFISp0Ae/Cp2ymSCTDl80W7Ie5uhN1bM9T4/rO++qWywGBQzh3RxDHhvEFPRfZRhNXreFRBd4121hHo1Ve+s4A2HqvobAq2mybLrtsNQXV7k8348l+RmuPGddidXlYF2LP8yhXiQFH+QXvMFGxrlL2oN3pPTv1hOLXEqUJets7s4OixDhekFnNVZROzLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dy8Eu8WZXgqvaQEwdHYcDWScZLt2YIaJWBknUOxTSCQ=;
 b=DRud9FbicK27SdHs0YiQJz6X1NpSIPL4mlgCQGF3I+0MtepJn5znozSCsfCljaob0CHEAFN+TSG2CzFtdShLEWnBktJ8dv5fEvz5838pEcFe9MBuRxLbKb9qARw2tm4YsP1bmlaYcQnoQnvApxNlY1SYpfnGIsFaV6+qpOKl2TI=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4941.eurprd05.prod.outlook.com (20.177.48.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Thu, 23 Jan 2020 06:39:58 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2644.027; Thu, 23 Jan 2020
 06:39:58 +0000
Received: from smtp.office365.com (73.15.39.150) by BYAPR21CA0027.namprd21.prod.outlook.com (2603:10b6:a03:114::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2686.5 via Frontend Transport; Thu, 23 Jan 2020 06:39:57 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 12/15] net/mlx5e: IPoIB, use separate stats groups
Thread-Topic: [net-next 12/15] net/mlx5e: IPoIB, use separate stats groups
Thread-Index: AQHV0bfubW3CG7Nhfki8ZCkDAc8tKA==
Date:   Thu, 23 Jan 2020 06:39:58 +0000
Message-ID: <20200123063827.685230-13-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 5f1644f9-7e97-408f-4e82-08d79fcf1091
x-ms-traffictypediagnostic: VI1PR05MB4941:|VI1PR05MB4941:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB494119204435D95A36CC6BA3BE0F0@VI1PR05MB4941.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:989;
x-forefront-prvs: 029174C036
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(39860400002)(376002)(346002)(366004)(199004)(189003)(5660300002)(107886003)(8936002)(6916009)(81166006)(81156014)(8676002)(186003)(6512007)(6486002)(4326008)(86362001)(1076003)(16526019)(71200400001)(26005)(36756003)(52116002)(6506007)(2906002)(66946007)(2616005)(66556008)(956004)(64756008)(66446008)(316002)(478600001)(54906003)(66476007)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4941;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5BCMsRowMqXikMmyH4TJ8HZrzX+pPXk1Yk6lurdrAifQ18lG+A/Uqbymplo0z9sxo2Qt57K3YTPC32uX3ylxW+Lj9reuX7f2IcsFPBXV35hi6Y/ePXj4JUofiC/wuVZjLWmXUME1liF3pbwnMykz5DRPxguihC8ksGX+MqcltRYOe6nos16uqwiHC3nzneiiMzZ8jt+D+POqMbelG3xOoP05Hwzi7GRCo0d/iiet6pokuavAX8b4rDr27jVMFhP5Dxt/6zOiGhQ+lkZPpbCEjJmMCSTiELRjE7vpx/vDLL6dpTAEISrHlRCrCXAWwXdWV9eQbynJr2ibA5qwbNpglRSCYoWbqPRcs9/VnnoCd05unK1C2K3lUD1UGiruuF31Cfl61JDv2OFIjO3khGtAsqcJ/CBOe52BIgqD5Ari/OwibydNw3DOLzToJ4yPk2ZQPJkZ2a5WS7HnKtRzUfEGfwrk5VpcFpuNTF12Sz1YNiA8UNY5/qxB/wi+leBRAYZLJh48j7lI0QlsW/w8p8C20c+1VKE/l29tfEDkcM3Vu+k=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f1644f9-7e97-408f-4e82-08d79fcf1091
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2020 06:39:58.5846
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6Wmuk/laF0roa2FWv2M6q9MKs2meusZCVUbIyBbo+IBSmZSQJ40RXDtkHOI2Bmoa8mXPGY8C+R+VfCPpIKK7Nw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4941
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Don't copy all of the stats groups used for mlx5e ethernet NIC profile,
have a separate stats groups for IPoIB with the set of the needed stats
only.

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/en_stats.c    | 26 +++++++++----------
 .../ethernet/mellanox/mlx5/core/en_stats.h    | 14 ++++++++++
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib.c | 26 +++++++++++++++++--
 3 files changed, 51 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/n=
et/ethernet/mellanox/mlx5/core/en_stats.c
index 85730a8899c1..ee5041747575 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -1700,19 +1700,19 @@ static MLX5E_DECLARE_STATS_GRP_OP_FILL_STATS(channe=
ls)
=20
 static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(channels) { return; }
=20
-static MLX5E_DEFINE_STATS_GRP(sw, 0);
-static MLX5E_DEFINE_STATS_GRP(qcnt, MLX5E_NDO_UPDATE_STATS);
-static MLX5E_DEFINE_STATS_GRP(vnic_env, 0);
-static MLX5E_DEFINE_STATS_GRP(vport, MLX5E_NDO_UPDATE_STATS);
-static MLX5E_DEFINE_STATS_GRP(802_3, MLX5E_NDO_UPDATE_STATS);
-static MLX5E_DEFINE_STATS_GRP(2863, 0);
-static MLX5E_DEFINE_STATS_GRP(2819, 0);
-static MLX5E_DEFINE_STATS_GRP(phy, 0);
-static MLX5E_DEFINE_STATS_GRP(pcie, 0);
-static MLX5E_DEFINE_STATS_GRP(per_prio, 0);
-static MLX5E_DEFINE_STATS_GRP(pme, 0);
-static MLX5E_DEFINE_STATS_GRP(channels, 0);
-static MLX5E_DEFINE_STATS_GRP(per_port_buff_congest, 0);
+MLX5E_DEFINE_STATS_GRP(sw, 0);
+MLX5E_DEFINE_STATS_GRP(qcnt, MLX5E_NDO_UPDATE_STATS);
+MLX5E_DEFINE_STATS_GRP(vnic_env, 0);
+MLX5E_DEFINE_STATS_GRP(vport, MLX5E_NDO_UPDATE_STATS);
+MLX5E_DEFINE_STATS_GRP(802_3, MLX5E_NDO_UPDATE_STATS);
+MLX5E_DEFINE_STATS_GRP(2863, 0);
+MLX5E_DEFINE_STATS_GRP(2819, 0);
+MLX5E_DEFINE_STATS_GRP(phy, 0);
+MLX5E_DEFINE_STATS_GRP(pcie, 0);
+MLX5E_DEFINE_STATS_GRP(per_prio, 0);
+MLX5E_DEFINE_STATS_GRP(pme, 0);
+MLX5E_DEFINE_STATS_GRP(channels, 0);
+MLX5E_DEFINE_STATS_GRP(per_port_buff_congest, 0);
 static MLX5E_DEFINE_STATS_GRP(eth_ext, 0);
 static MLX5E_DEFINE_STATS_GRP(ipsec, 0);
 static MLX5E_DEFINE_STATS_GRP(tls, 0);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h b/drivers/n=
et/ethernet/mellanox/mlx5/core/en_stats.h
index 29ad89f66bf7..4dc0b6e083f8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
@@ -378,4 +378,18 @@ unsigned int mlx5e_nic_stats_grps_num(struct mlx5e_pri=
v *priv);
=20
 MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(802_3);
=20
+extern MLX5E_DECLARE_STATS_GRP(sw);
+extern MLX5E_DECLARE_STATS_GRP(qcnt);
+extern MLX5E_DECLARE_STATS_GRP(vnic_env);
+extern MLX5E_DECLARE_STATS_GRP(vport);
+extern MLX5E_DECLARE_STATS_GRP(802_3);
+extern MLX5E_DECLARE_STATS_GRP(2863);
+extern MLX5E_DECLARE_STATS_GRP(2819);
+extern MLX5E_DECLARE_STATS_GRP(phy);
+extern MLX5E_DECLARE_STATS_GRP(pcie);
+extern MLX5E_DECLARE_STATS_GRP(per_prio);
+extern MLX5E_DECLARE_STATS_GRP(pme);
+extern MLX5E_DECLARE_STATS_GRP(channels);
+extern MLX5E_DECLARE_STATS_GRP(per_port_buff_congest);
+
 #endif /* __MLX5_EN_STATS_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c b/driver=
s/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
index bd870ffeb1be..56078b23f1a0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -419,6 +419,28 @@ static void mlx5i_cleanup_rx(struct mlx5e_priv *priv)
 	mlx5e_destroy_q_counters(priv);
 }
=20
+/* The stats groups order is opposite to the update_stats() order calls */
+static mlx5e_stats_grp_t mlx5i_stats_grps[] =3D {
+	&MLX5E_STATS_GRP(sw),
+	&MLX5E_STATS_GRP(qcnt),
+	&MLX5E_STATS_GRP(vnic_env),
+	&MLX5E_STATS_GRP(vport),
+	&MLX5E_STATS_GRP(802_3),
+	&MLX5E_STATS_GRP(2863),
+	&MLX5E_STATS_GRP(2819),
+	&MLX5E_STATS_GRP(phy),
+	&MLX5E_STATS_GRP(pcie),
+	&MLX5E_STATS_GRP(per_prio),
+	&MLX5E_STATS_GRP(pme),
+	&MLX5E_STATS_GRP(channels),
+	&MLX5E_STATS_GRP(per_port_buff_congest),
+};
+
+static unsigned int mlx5i_stats_grps_num(struct mlx5e_priv *priv)
+{
+	return ARRAY_SIZE(mlx5i_stats_grps);
+}
+
 static const struct mlx5e_profile mlx5i_nic_profile =3D {
 	.init		   =3D mlx5i_init,
 	.cleanup	   =3D mlx5i_cleanup,
@@ -435,8 +457,8 @@ static const struct mlx5e_profile mlx5i_nic_profile =3D=
 {
 	.rx_handlers.handle_rx_cqe_mpwqe =3D NULL, /* Not supported */
 	.max_tc		   =3D MLX5I_MAX_NUM_TC,
 	.rq_groups	   =3D MLX5E_NUM_RQ_GROUPS(REGULAR),
-	.stats_grps        =3D mlx5e_nic_stats_grps,
-	.stats_grps_num    =3D mlx5e_nic_stats_grps_num,
+	.stats_grps        =3D mlx5i_stats_grps,
+	.stats_grps_num    =3D mlx5i_stats_grps_num,
 };
=20
 /* mlx5i netdev NDos */
--=20
2.24.1

