Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8431A9A3E4
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 01:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726865AbfHVXgq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 19:36:46 -0400
Received: from mail-eopbgr50056.outbound.protection.outlook.com ([40.107.5.56]:39558
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726838AbfHVXgp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 19:36:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ercsbrU51NLFLlp+fczBvlJEDQpPCfK8doOdq3pW31Um0U86MgXNG81dXdxP7VWaBDNVNqsImLzvcr+nM82ia3N9ysNTq/mGBWDadGgiNiRj+scYGuhYY6VZWu40haU4Q6XOlRfk7z38Knq/EjH6/oi31vVU2kNtEOjWqoUUHm6U7PB2JV8mNsueb3eZAgkugI+7qwst10ZLv1NL70gDcYZh1Pu0NXPfM4O2F3k0OW4hzJ9TIKD2eiCSTt01Xpz19pug7joPLgzeZS+qoqh/pTxTEitnZuGgWm9kKJ6/Fn63jmljOjdRXkU6XBVgDs7HW/onkArSX3oMy6nBkrzrhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+ZeWd4AzPM9gFfA0HUYjQmoiaR3W4VSKD2K8YiScKtA=;
 b=nGLlra0XAB8gccrXkZgx72B5+PUtPERFEztsJsBPX3OrdpmBuU6owrnWidHk+u/OaiH68NgVAv4eJWRqDZuXcPISU9q5z/KRc1hW9hGqB7sX4KHlNgk4i5P8Nh3UnQlM+YOd23hNP4dj8l0GHLIJs2rPr4uBMiqNAXtw/QtNZNrLOIos58N7TAksh8iNwzetYvqdGXDUNS3LlnQOgM0ha8vE6UK1iD/vAcgHLa2w9FsB5BRju/oxXnSXv6GpPjfRilKgx05kyYiPgK0h3IyT58K8VbkRyyWasIjCnBXgBOzUF8PFGY59FOeASogwzM1Db/Wagc+bjtoDJTTgr5mCEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+ZeWd4AzPM9gFfA0HUYjQmoiaR3W4VSKD2K8YiScKtA=;
 b=hqSmrTD9ua4WwEcHBmO58FC1iDIBya5Uq53W9EYK1T7aG5GWwqS61svu888tUcsOh/jzc7ftQtHHQsXwYR/8mrUmuOibhZX3LLp4hQ6bBm8aoFr5XP8tpzqsRnMma6Jlw937LqIBqcOyQbyprbJvzsSuMGGHQPm97Boe8paAuxM=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2817.eurprd05.prod.outlook.com (10.172.215.144) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.18; Thu, 22 Aug 2019 23:35:58 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a%4]) with mapi id 15.20.2178.020; Thu, 22 Aug 2019
 23:35:58 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Marina Varshaver <marinav@mellanox.com>,
        Aya Levin <ayal@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 7/8] net/mlx5e: Improve stateless offload capability check
Thread-Topic: [net-next 7/8] net/mlx5e: Improve stateless offload capability
 check
Thread-Index: AQHVWUJZNja2fUSLQUmqcyjCfvjdag==
Date:   Thu, 22 Aug 2019 23:35:58 +0000
Message-ID: <20190822233514.31252-8-saeedm@mellanox.com>
References: <20190822233514.31252-1-saeedm@mellanox.com>
In-Reply-To: <20190822233514.31252-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR06CA0036.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::49) To AM4PR0501MB2756.eurprd05.prod.outlook.com
 (2603:10a6:200:5c::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a03e92a3-de62-4da2-a704-08d727597bca
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AM4PR0501MB2817;
x-ms-traffictypediagnostic: AM4PR0501MB2817:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR0501MB281778939BDFE169B23D19A0BEA50@AM4PR0501MB2817.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:95;
x-forefront-prvs: 01371B902F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(346002)(376002)(366004)(39860400002)(199004)(189003)(11346002)(446003)(486006)(1076003)(66476007)(66556008)(64756008)(66946007)(66446008)(186003)(386003)(102836004)(305945005)(476003)(66066001)(6506007)(478600001)(2616005)(26005)(2906002)(6512007)(3846002)(6116002)(7736002)(86362001)(6486002)(6916009)(36756003)(76176011)(54906003)(316002)(53936002)(256004)(8676002)(4326008)(25786009)(50226002)(81156014)(99286004)(81166006)(8936002)(14454004)(107886003)(6436002)(5660300002)(71190400001)(71200400001)(52116002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2817;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 7npu/AxjmZxfXlTugc1BLAFZ9qeetFGpm3zIo5XLZtdHYeSO259PiZ8X/VLJasEQ07Sxt0XIM8Uv20XOgHNqWdM2/3GQMGkTUgx3OiNyBgItaO2ZZ3wPXca/1KM4ZYzKfsqMKXcWhvayg+28gp0RiiF9Xl06K5XKBCi/PlAiw3qh43pJIX4FZ7v/+XbmGzrOiW2BUdcpR6XhRFPc9kXOEbcc9jCiyWItd93q/Or5qd3iteORaU08HD3Tk+JRJ3xF022jo3Crm759WjmhMCZ4/eFS9Azq2b44+bgIXcnjXIIoh9Bu861B1qR5fdvayFAt6L6doPMcd+dFpMVDUQDb/PoDvp9yAkcW4pbvSrJ7e49bIdxe7sjF0mnO71rhAqd4zNqnLsN/iztzzJTL/oWOdbZ/XneMg1YGrj3INrZOjG0=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a03e92a3-de62-4da2-a704-08d727597bca
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2019 23:35:58.0374
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hWYrGQ5Qd1yt99dqCxGKDVV0Hd41ZuH1qbveSn3XkkoN/tpTz+JvVU+4GHdiSm9u1fwULKYcnL6OL+AE3eitug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2817
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marina Varshaver <marinav@mellanox.com>

Use generic function for checking tunnel stateless offload capability
instead of separate macros.

Signed-off-by: Marina Varshaver <marinav@mellanox.com>
Reviewed-by: Aya Levin <ayal@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/fs.h   | 3 +++
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c   | 4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 4 ++--
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h b/drivers/net/=
ethernet/mellanox/mlx5/core/en/fs.h
index 5aae3a7a5497..68d593074f6c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
@@ -238,5 +238,8 @@ void mlx5e_disable_cvlan_filter(struct mlx5e_priv *priv=
);
 int mlx5e_create_flow_steering(struct mlx5e_priv *priv);
 void mlx5e_destroy_flow_steering(struct mlx5e_priv *priv);
=20
+bool mlx5e_tunnel_proto_supported(struct mlx5_core_dev *mdev, u8 proto_typ=
e);
+bool mlx5e_any_tunnel_proto_supported(struct mlx5_core_dev *mdev);
+
 #endif /* __MLX5E_FLOW_STEER_H__ */
=20
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_fs.c
index b99b17957543..15b7f0f1427c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
@@ -766,7 +766,7 @@ static struct mlx5e_etype_proto ttc_tunnel_rules[] =3D =
{
=20
 };
=20
-static bool mlx5e_tunnel_proto_supported(struct mlx5_core_dev *mdev, u8 pr=
oto_type)
+bool mlx5e_tunnel_proto_supported(struct mlx5_core_dev *mdev, u8 proto_typ=
e)
 {
 	switch (proto_type) {
 	case IPPROTO_GRE:
@@ -779,7 +779,7 @@ static bool mlx5e_tunnel_proto_supported(struct mlx5_co=
re_dev *mdev, u8 proto_ty
 	}
 }
=20
-static bool mlx5e_any_tunnel_proto_supported(struct mlx5_core_dev *mdev)
+bool mlx5e_any_tunnel_proto_supported(struct mlx5_core_dev *mdev)
 {
 	int tt;
=20
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_main.c
index b1bc0e601cc2..1c4f82842df9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4877,7 +4877,7 @@ static void mlx5e_build_nic_netdev(struct net_device =
*netdev)
 	netdev->hw_features      |=3D NETIF_F_HW_VLAN_STAG_TX;
=20
 	if (mlx5_vxlan_allowed(mdev->vxlan) || mlx5_geneve_tx_allowed(mdev) ||
-	    MLX5_CAP_ETH(mdev, tunnel_stateless_gre)) {
+	    mlx5e_any_tunnel_proto_supported(mdev)) {
 		netdev->hw_enc_features |=3D NETIF_F_HW_CSUM;
 		netdev->hw_enc_features |=3D NETIF_F_TSO;
 		netdev->hw_enc_features |=3D NETIF_F_TSO6;
@@ -4892,7 +4892,7 @@ static void mlx5e_build_nic_netdev(struct net_device =
*netdev)
 		netdev->gso_partial_features =3D NETIF_F_GSO_UDP_TUNNEL_CSUM;
 	}
=20
-	if (MLX5_CAP_ETH(mdev, tunnel_stateless_gre)) {
+	if (mlx5e_tunnel_proto_supported(mdev, IPPROTO_GRE)) {
 		netdev->hw_features     |=3D NETIF_F_GSO_GRE |
 					   NETIF_F_GSO_GRE_CSUM;
 		netdev->hw_enc_features |=3D NETIF_F_GSO_GRE |
--=20
2.21.0

