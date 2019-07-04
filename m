Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 438C15FCC3
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 20:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727225AbfGDSQG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 14:16:06 -0400
Received: from mail-eopbgr60046.outbound.protection.outlook.com ([40.107.6.46]:28482
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726794AbfGDSQE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jul 2019 14:16:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p01KFn+evn9XRy4BZZy7/Ibmk5U0o5s5UeoOA/gcg3c=;
 b=mWXc19bIN7wSDprTHp6/09IC8ma1sjgQ+HOHUzLtoLG7x1QZJwR0vIB38Zd6ElThDaaVhpRh3qOtKY0Ukhu9ttP6sRpvlOgFKkf7dqvHdpiyQlhOSxTFbS2uTevxoX++EmMIL36/LQ3nny7H3oqbXcOyMQDnTQ+hhjkWdyo/BNc=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2584.eurprd05.prod.outlook.com (10.168.74.135) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.20; Thu, 4 Jul 2019 18:15:50 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::c1b3:b3a8:bced:493c]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::c1b3:b3a8:bced:493c%4]) with mapi id 15.20.2032.019; Thu, 4 Jul 2019
 18:15:50 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 03/14] net/mlx5: Accel, Expose accel wrapper for IPsec FPGA
 function
Thread-Topic: [net-next 03/14] net/mlx5: Accel, Expose accel wrapper for IPsec
 FPGA function
Thread-Index: AQHVMpSCMkpLX8gw80q1mP1mRMSyAw==
Date:   Thu, 4 Jul 2019 18:15:50 +0000
Message-ID: <20190704181235.8966-4-saeedm@mellanox.com>
References: <20190704181235.8966-1-saeedm@mellanox.com>
In-Reply-To: <20190704181235.8966-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.148.53.10]
x-clientproxiedby: BYAPR06CA0061.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::38) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c02967d3-49a9-4e6a-6707-08d700aba4df
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2584;
x-ms-traffictypediagnostic: DB6PR0501MB2584:
x-microsoft-antispam-prvs: <DB6PR0501MB2584F4513C2CAD70FF7340C3BEFA0@DB6PR0501MB2584.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2958;
x-forefront-prvs: 0088C92887
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(136003)(39860400002)(366004)(396003)(199004)(189003)(486006)(14454004)(186003)(305945005)(26005)(6916009)(71200400001)(6486002)(7736002)(86362001)(256004)(14444005)(8936002)(81156014)(386003)(76176011)(8676002)(81166006)(6116002)(52116002)(2906002)(6436002)(3846002)(102836004)(71190400001)(2616005)(476003)(446003)(11346002)(6506007)(99286004)(73956011)(25786009)(1076003)(107886003)(66946007)(66556008)(66476007)(68736007)(66446008)(64756008)(5660300002)(478600001)(4326008)(50226002)(6512007)(54906003)(66066001)(316002)(36756003)(53936002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2584;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: CjuxwQpix5zkhnfaDPbzXvgENGBdXkTfxEnWB0pVVx1f3D78m+sMotnQMXeF1xnIp7wFpNi2HEtl+n+bw7k45fv7pZPrBaS7hYA+AK5yuS/ynzwxdDrDzvepcHlVVdp8Zty9LH8W6glcnH8/RJlnD0YMvhX4/W6lAH+5jA4BZLTn0zv53GrTlQND0HwHPcr/MtJ9xVlaDLQ5b6tUhNnJlGq/4QF6vwYkYLoM8O5emg15yBHYWzJC6zh25mOVzLn4f/qkiE6caOoO7ON9Sf+TrwI1VBjUVSM1dqgB90SRO8kVi5m+mjE/+b4WjbFJouyZRuhrs+tLhSRExIa25ggoN9ISRQY2/GwE03BRN/28avkWd5MHt8hbP9s/xC7E08TZv7wHxqPWiT7N0IlL7WLPOjfSnvvSj+JGKxdrdLwZMT8=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c02967d3-49a9-4e6a-6707-08d700aba4df
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2019 18:15:50.7361
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2584
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

Do not directly call fpga version of IPsec function from main.c.
Wrap it by an accel version, and call the wrapper.

This will allow deprecating the FPGA IPsec stubs in downstream
patch.

Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Boris Pismenny <borisp@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec.c | 5 +++++
 drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec.h | 5 +++++
 drivers/net/ethernet/mellanox/mlx5/core/main.c        | 2 +-
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec.c b/driver=
s/net/ethernet/mellanox/mlx5/core/accel/ipsec.c
index 9f1b1939716a..d1e76d5a413b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec.c
@@ -74,6 +74,11 @@ int mlx5_accel_ipsec_init(struct mlx5_core_dev *mdev)
 	return mlx5_fpga_ipsec_init(mdev);
 }
=20
+void mlx5_accel_ipsec_build_fs_cmds(void)
+{
+	mlx5_fpga_ipsec_build_fs_cmds();
+}
+
 void mlx5_accel_ipsec_cleanup(struct mlx5_core_dev *mdev)
 {
 	mlx5_fpga_ipsec_cleanup(mdev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec.h b/driver=
s/net/ethernet/mellanox/mlx5/core/accel/ipsec.h
index 024dbd22a89b..93b3f5faddb5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec.h
@@ -54,6 +54,7 @@ void *mlx5_accel_esp_create_hw_context(struct mlx5_core_d=
ev *mdev,
 void mlx5_accel_esp_free_hw_context(void *context);
=20
 int mlx5_accel_ipsec_init(struct mlx5_core_dev *mdev);
+void mlx5_accel_ipsec_build_fs_cmds(void);
 void mlx5_accel_ipsec_cleanup(struct mlx5_core_dev *mdev);
=20
 #else
@@ -79,6 +80,10 @@ static inline int mlx5_accel_ipsec_init(struct mlx5_core=
_dev *mdev)
 	return 0;
 }
=20
+static inline void mlx5_accel_ipsec_build_fs_cmds(void)
+{
+}
+
 static inline void mlx5_accel_ipsec_cleanup(struct mlx5_core_dev *mdev)
 {
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/e=
thernet/mellanox/mlx5/core/main.c
index 4084c4e74fb7..b15b27a497fc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1600,7 +1600,7 @@ static int __init init(void)
 	get_random_bytes(&sw_owner_id, sizeof(sw_owner_id));
=20
 	mlx5_core_verify_params();
-	mlx5_fpga_ipsec_build_fs_cmds();
+	mlx5_accel_ipsec_build_fs_cmds();
 	mlx5_register_debugfs();
=20
 	err =3D pci_register_driver(&mlx5_core_driver);
--=20
2.21.0

