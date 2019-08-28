Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61E11A0A1D
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 20:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbfH1S6J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 14:58:09 -0400
Received: from mail-eopbgr50085.outbound.protection.outlook.com ([40.107.5.85]:52486
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726618AbfH1S6I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Aug 2019 14:58:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WsAme7/o0noVxHztMT8ZRmeF/x6TLQfqM6fngyHzb+aoZrSsUIOYl4DwfCAP8qUqJgKlIpI7+3zclkj274S3dV2rV+TcNZ4wQUjfTu9FjrnHWnRg7TgxXfHairlXzQhaurpY5k4F+jIq5x5DmTP+Jae0XMVDxhWrD5cVELbU6Gc8xlCdPXQ0yr2baKI0+wSCUqvIe3/W6zDOAuQQfBMPlL1jH/wIeZ3pXsfRMe4neer5cA8pBzkzInvbICA99jXwsjkkS5+aqz2wdSiXIs/3Tvu1RSILocaF9tZvg9o4XO3E1Q2/hrshEk9lBAgX80F4m/XjKKLVtWTGpgAuRDZwyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fjeMUBkcs0vmuAclO+yCGCVQ0aomEswc81GX4TTvLNE=;
 b=C7gqf6NMOc33j4mg9+cBcdsGaBV3E7pIlleRM0e9CQgyhb/vG5QKY/o5mO/lcUTSJL3lowKVkFFQx8BD9bqWG9OoSE451A7NRVUpXEmP7ly57XFlH01PtKWQt3wTFwhsRlQAd3ekNuzegpg7ygNUDcsPJtlq0rYnOzhb5eKwA+JhtkNVpwCTDokFCPmiI0SP1prUyT8cTn+8d0cXvItexv3eP404iWx1gq298bMkX0QhZ28pgDHDkvJOElS0Kzqe+vBGE3MgGU9d13l0m/pGLFOrQyCt2lVB0z+VkAcc9bd8P/ImEfP1SNO+qlQGLKd++TUb6UqJrDSIelLj748AMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fjeMUBkcs0vmuAclO+yCGCVQ0aomEswc81GX4TTvLNE=;
 b=DGmKxIvLE3QCIKwd9nPa8MRbhXfkv5o6+CPtk2fpvCNMa1fsz0fZvGMoL8te5I96CMLm/zAQ7/N4FefEIojHn1nKhleTezfxV1gEtIgweNWo/xRR1GOO7+ptYTpCM/fsQViJW0bUJYHz5a9AZOaQ1hOItLBix2TVRzkZIFYYogo=
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com (10.172.11.140) by
 VI1PR0501MB2638.eurprd05.prod.outlook.com (10.172.80.136) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.21; Wed, 28 Aug 2019 18:57:53 +0000
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::5cab:4f5c:d7ed:5e27]) by VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::5cab:4f5c:d7ed:5e27%6]) with mapi id 15.20.2199.021; Wed, 28 Aug 2019
 18:57:53 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Marina Varshaver <marinav@mellanox.com>,
        Aya Levin <ayal@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next v2 7/8] net/mlx5e: Improve stateless offload capability
 check
Thread-Topic: [net-next v2 7/8] net/mlx5e: Improve stateless offload
 capability check
Thread-Index: AQHVXdJ/CQh3NFWSBU+qDma2sL2uyg==
Date:   Wed, 28 Aug 2019 18:57:53 +0000
Message-ID: <20190828185720.2300-8-saeedm@mellanox.com>
References: <20190828185720.2300-1-saeedm@mellanox.com>
In-Reply-To: <20190828185720.2300-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR06CA0069.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::46) To VI1PR0501MB2765.eurprd05.prod.outlook.com
 (2603:10a6:800:9a::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ecd6c6f2-e728-48f6-81cf-08d72be9a18c
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0501MB2638;
x-ms-traffictypediagnostic: VI1PR0501MB2638:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0501MB2638565C719F535621933188BEA30@VI1PR0501MB2638.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:95;
x-forefront-prvs: 014304E855
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(366004)(346002)(396003)(39860400002)(189003)(199004)(8676002)(6512007)(107886003)(6486002)(54906003)(1076003)(25786009)(3846002)(316002)(186003)(8936002)(5660300002)(6116002)(53936002)(81156014)(6436002)(478600001)(86362001)(14454004)(2906002)(6916009)(4326008)(81166006)(36756003)(7736002)(50226002)(66446008)(305945005)(256004)(66946007)(486006)(476003)(11346002)(2616005)(66066001)(446003)(66556008)(66476007)(71200400001)(52116002)(26005)(6506007)(386003)(102836004)(71190400001)(76176011)(64756008)(99286004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0501MB2638;H:VI1PR0501MB2765.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: sm8KOiz7MLrqyTV0e0+5p0BPAQdXTJ1TrLsyO3ukuMzxM8tMmFCwgspnUP8MuSufShEsIUxiYkOXhjl4UE4Ok6YKCs7vQFPwVhbU6rNyZkCTnyXsocqKtcRa0uTNqAwweNTyqzNLnWH6dW8dQJbfd/zMsFvgIY0ck4OycitxYghZIy5oIEW+YkgRgbfloY8MUQLSNf6uTZeO0OLYV3jLbJm9za2IlyAlw+zY/nBQImE+DZtT6nh67zHaJmhLKT+2zp4HrMK3waXf8YKn+RC59fgoPvoYtesCkf7liSojuznheoNnaswGo0bgq7Z6+Kw2ttUNOola2x8OjrubvhFmVXxm83zIlYd7xQsxYKz5Y5DYXS1kg4qoTuW6+U0dqohAZi5rUe58U4Nk0LEBaw69kxbd7Qp0bVcZ4ux7mbJ3cBw=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ecd6c6f2-e728-48f6-81cf-08d72be9a18c
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Aug 2019 18:57:53.7387
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WYX82eX9rjh2epJcWcTqiOVB91lc7IvXcBlATaNfy483bpb/I5RsUo8JiOrlSK5S9ZwXnPRiboByUMGMapURNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2638
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
index 2786f5b8057d..327c90d936e9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4879,7 +4879,7 @@ static void mlx5e_build_nic_netdev(struct net_device =
*netdev)
 	netdev->hw_features      |=3D NETIF_F_HW_VLAN_STAG_TX;
=20
 	if (mlx5_vxlan_allowed(mdev->vxlan) || mlx5_geneve_tx_allowed(mdev) ||
-	    MLX5_CAP_ETH(mdev, tunnel_stateless_gre)) {
+	    mlx5e_any_tunnel_proto_supported(mdev)) {
 		netdev->hw_enc_features |=3D NETIF_F_HW_CSUM;
 		netdev->hw_enc_features |=3D NETIF_F_TSO;
 		netdev->hw_enc_features |=3D NETIF_F_TSO6;
@@ -4894,7 +4894,7 @@ static void mlx5e_build_nic_netdev(struct net_device =
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

