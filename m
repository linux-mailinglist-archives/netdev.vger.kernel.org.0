Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F171312322F
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 17:21:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728968AbfLQQUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 11:20:51 -0500
Received: from mail-eopbgr150048.outbound.protection.outlook.com ([40.107.15.48]:52522
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728527AbfLQQUu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 11:20:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i2UojAiDsy05J8kA9Ldu7b/TyjdpZIMJW/vXJYsyO+UIDXU1UoCunBTh3FOhc1YNodMCvnwC4yerPRx5bvKU9F4PCU56qky2KAay68IfeOvCGZHUMjA09pBUv359RRnEoZ65Vv3q81w2BTkR/k6BzdhOixdY45zt8N7nSGigTapGUXoZV9BzWyezyJWPMQy0nqQ0qC4Wu6AZKXHk0xHSsCGYnHed/43ZmZKnraHu5cCBRyufGNvBaIuy2x2fS6o5zuDOJulVM7kr9nB0Yo9BrT/jrd1eXiR1tjM/0sHnGfmPqgxpBq33A8Fxmu1/oSqGjej/Oo2fqkkcXCu1aEWC+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8FbGVRrWKgt/aiHjekJVSyf+v0jxpLu9iTbYLzOJK+4=;
 b=QPQhL0sJtqFQ7vovwys5FsP90IZLAM78g/PB1pK17KFr3NBsbGmIbsUqkCWcKVN+mAizxKN0UERscG9p7ugl/fCGz40HxobGbey9puC6yvTK31YwoaWVj/Yp5kh09hyPiERl7IXsFnzeNIJ0QxIP5h9ZWkIAXoB71XwDtO7AT9b1aTgg03sbAwhlY1YPF9aHADXII5lRgcpeFMNMTk+5F2gEevw7sAjJZrGQF6D9jdrJEshf81t3rno0gSjDQgQzCEOHgZHXUrXzFKgxhxnQ0VJ0EbVU8CVACzNAaYEl+AKxSLtO6gPIyhIJYazpzBiERF/IzJiqVGOukJwIyA6RKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8FbGVRrWKgt/aiHjekJVSyf+v0jxpLu9iTbYLzOJK+4=;
 b=VUMW68VcWbz6YVr8I6kl+Cm/vF7X0U1yUjNf7mjdGijS9Shhm4KI8Qe/ciqWLLGcHpi/xlLhbH0Mnt7DGS1yElc1eLTS2HWvi+i+Y5gpOPVvD21oPCTSJAJrBv9RjkqhKTkAno4FxLXLtrq74uJU9rs6iWAYfXyF6ZtAIXOIAHw=
Received: from AM0PR05MB5875.eurprd05.prod.outlook.com (20.178.119.159) by
 AM0PR05MB4259.eurprd05.prod.outlook.com (52.134.126.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.18; Tue, 17 Dec 2019 16:20:44 +0000
Received: from AM0PR05MB5875.eurprd05.prod.outlook.com
 ([fe80::259f:70b4:dab1:8f2]) by AM0PR05MB5875.eurprd05.prod.outlook.com
 ([fe80::259f:70b4:dab1:8f2%5]) with mapi id 15.20.2538.019; Tue, 17 Dec 2019
 16:20:44 +0000
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>
Subject: [PATCH bpf v2 2/4] net/mlx5e: Fix concurrency issues between config
 flow and XSK
Thread-Topic: [PATCH bpf v2 2/4] net/mlx5e: Fix concurrency issues between
 config flow and XSK
Thread-Index: AQHVtPXuHjKFWBVcckaSWrxy0C/Tdw==
Date:   Tue, 17 Dec 2019 16:20:44 +0000
Message-ID: <20191217162023.16011-3-maximmi@mellanox.com>
References: <20191217162023.16011-1-maximmi@mellanox.com>
In-Reply-To: <20191217162023.16011-1-maximmi@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR02CA0106.eurprd02.prod.outlook.com
 (2603:10a6:208:154::47) To AM0PR05MB5875.eurprd05.prod.outlook.com
 (2603:10a6:208:12d::31)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=maximmi@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.20.1
x-originating-ip: [94.188.199.18]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5a461aa0-de15-4050-fb58-08d7830d10fa
x-ms-traffictypediagnostic: AM0PR05MB4259:|AM0PR05MB4259:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB4259E7C61828FA402BF035BDD1500@AM0PR05MB4259.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:538;
x-forefront-prvs: 02543CD7CD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(136003)(366004)(346002)(396003)(39860400002)(199004)(189003)(54906003)(26005)(66556008)(6506007)(110136005)(66476007)(2906002)(7416002)(64756008)(186003)(5660300002)(66446008)(36756003)(52116002)(1076003)(8676002)(81166006)(71200400001)(86362001)(81156014)(6486002)(107886003)(2616005)(478600001)(316002)(66946007)(6512007)(8936002)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4259;H:AM0PR05MB5875.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0uZ/Mel7IdwKMb1Jq9WBVJErdCyQrQ4++TB8NwfwtNBkGxeBBNVgM2dhPhqpjco8y3Vps+rMAk/CoPGa8cxUXRw1nskFQyDJvc5cZa8Yq+MjTPJ+jNKQfZzixCRfM7A5q3PIlgpyfnFFhYGkpmdiW5R1NW3oUFWfMxTVbNkGcjUxlxJuIn8skXGxNtBfkjm/A031LyXJq0Sss9uvd02jVlnqmh3z06hcLrFgV6C5wdOBhNYsKtxeXDgN7aWCWcgVpftD3YKDKDnGNN05Hp2r6DJYz7ljYe8nbm1c5CcE6j33TtnxZ2NO2TFmDsbLZWMehno9efxaeAeJ/Y/bhyJA7w9hoN/cSCMLeZTnC0PqNsXXUlJy0dbMvX6kM/R1sTTR0VhRSRg945+D9bJ1ai5dQPJY5WnfcSJfiy0kwKRnZemsUPw29V4iqt8pHHlqF8r8
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a461aa0-de15-4050-fb58-08d7830d10fa
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2019 16:20:44.0970
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: v/Un0KQukfTGgkC+qS0IVI9E0h0f6SwH4AEqVx11MSQ6aASBhn1yz3TFYSyXsIk2INA+/rhtqmQPgp2WAGUVlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4259
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After disabling resources necessary for XSK (the XDP program, channels,
XSK queues), use synchronize_rcu to wait until the XSK wakeup function
finishes, before freeing the resources.

Suspend XSK wakeups during switching channels. If the XDP program is
being removed, synchronize_rcu before closing the old channels to allow
XSK wakeup to complete.

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en/xdp.h  | 22 ++++++++-----------
 .../mellanox/mlx5/core/en/xsk/setup.c         |  1 +
 .../ethernet/mellanox/mlx5/core/en/xsk/tx.c   |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 19 +---------------
 5 files changed, 13 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/eth=
ernet/mellanox/mlx5/core/en.h
index 2c16add0b642..9c8427698238 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -760,7 +760,7 @@ enum {
 	MLX5E_STATE_OPENED,
 	MLX5E_STATE_DESTROYING,
 	MLX5E_STATE_XDP_TX_ENABLED,
-	MLX5E_STATE_XDP_OPEN,
+	MLX5E_STATE_XDP_ACTIVE,
 };
=20
 struct mlx5e_rqt {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h b/drivers/net=
/ethernet/mellanox/mlx5/core/en/xdp.h
index 36ac1e3816b9..d7587f40ecae 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
@@ -75,12 +75,18 @@ int mlx5e_xdp_xmit(struct net_device *dev, int n, struc=
t xdp_frame **frames,
 static inline void mlx5e_xdp_tx_enable(struct mlx5e_priv *priv)
 {
 	set_bit(MLX5E_STATE_XDP_TX_ENABLED, &priv->state);
+
+	if (priv->channels.params.xdp_prog)
+		set_bit(MLX5E_STATE_XDP_ACTIVE, &priv->state);
 }
=20
 static inline void mlx5e_xdp_tx_disable(struct mlx5e_priv *priv)
 {
+	if (priv->channels.params.xdp_prog)
+		clear_bit(MLX5E_STATE_XDP_ACTIVE, &priv->state);
+
 	clear_bit(MLX5E_STATE_XDP_TX_ENABLED, &priv->state);
-	/* let other device's napi(s) see our new state */
+	/* Let other device's napi(s) and XSK wakeups see our new state. */
 	synchronize_rcu();
 }
=20
@@ -89,19 +95,9 @@ static inline bool mlx5e_xdp_tx_is_enabled(struct mlx5e_=
priv *priv)
 	return test_bit(MLX5E_STATE_XDP_TX_ENABLED, &priv->state);
 }
=20
-static inline void mlx5e_xdp_set_open(struct mlx5e_priv *priv)
-{
-	set_bit(MLX5E_STATE_XDP_OPEN, &priv->state);
-}
-
-static inline void mlx5e_xdp_set_closed(struct mlx5e_priv *priv)
-{
-	clear_bit(MLX5E_STATE_XDP_OPEN, &priv->state);
-}
-
-static inline bool mlx5e_xdp_is_open(struct mlx5e_priv *priv)
+static inline bool mlx5e_xdp_is_active(struct mlx5e_priv *priv)
 {
-	return test_bit(MLX5E_STATE_XDP_OPEN, &priv->state);
+	return test_bit(MLX5E_STATE_XDP_ACTIVE, &priv->state);
 }
=20
 static inline void mlx5e_xmit_xdp_doorbell(struct mlx5e_xdpsq *sq)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c b/drive=
rs/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
index 631af8dee517..c28cbae42331 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
@@ -144,6 +144,7 @@ void mlx5e_close_xsk(struct mlx5e_channel *c)
 {
 	clear_bit(MLX5E_CHANNEL_STATE_XSK, c->state);
 	napi_synchronize(&c->napi);
+	synchronize_rcu(); /* Sync with the XSK wakeup. */
=20
 	mlx5e_close_rq(&c->xskrq);
 	mlx5e_close_cq(&c->xskrq.cq);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c b/drivers/=
net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
index 87827477d38c..fe2d596cb361 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
@@ -14,7 +14,7 @@ int mlx5e_xsk_wakeup(struct net_device *dev, u32 qid, u32=
 flags)
 	struct mlx5e_channel *c;
 	u16 ix;
=20
-	if (unlikely(!mlx5e_xdp_is_open(priv)))
+	if (unlikely(!mlx5e_xdp_is_active(priv)))
 		return -ENETDOWN;
=20
 	if (unlikely(!mlx5e_qid_get_ch_if_in_group(params, qid, MLX5E_RQ_GROUP_XS=
K, &ix)))
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_main.c
index 4980e80a5e85..4997b8a51994 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3000,12 +3000,9 @@ void mlx5e_timestamp_init(struct mlx5e_priv *priv)
 int mlx5e_open_locked(struct net_device *netdev)
 {
 	struct mlx5e_priv *priv =3D netdev_priv(netdev);
-	bool is_xdp =3D priv->channels.params.xdp_prog;
 	int err;
=20
 	set_bit(MLX5E_STATE_OPENED, &priv->state);
-	if (is_xdp)
-		mlx5e_xdp_set_open(priv);
=20
 	err =3D mlx5e_open_channels(priv, &priv->channels);
 	if (err)
@@ -3020,8 +3017,6 @@ int mlx5e_open_locked(struct net_device *netdev)
 	return 0;
=20
 err_clear_state_opened_flag:
-	if (is_xdp)
-		mlx5e_xdp_set_closed(priv);
 	clear_bit(MLX5E_STATE_OPENED, &priv->state);
 	return err;
 }
@@ -3053,8 +3048,6 @@ int mlx5e_close_locked(struct net_device *netdev)
 	if (!test_bit(MLX5E_STATE_OPENED, &priv->state))
 		return 0;
=20
-	if (priv->channels.params.xdp_prog)
-		mlx5e_xdp_set_closed(priv);
 	clear_bit(MLX5E_STATE_OPENED, &priv->state);
=20
 	netif_carrier_off(priv->netdev);
@@ -4371,16 +4364,6 @@ static int mlx5e_xdp_allowed(struct mlx5e_priv *priv=
, struct bpf_prog *prog)
 	return 0;
 }
=20
-static int mlx5e_xdp_update_state(struct mlx5e_priv *priv)
-{
-	if (priv->channels.params.xdp_prog)
-		mlx5e_xdp_set_open(priv);
-	else
-		mlx5e_xdp_set_closed(priv);
-
-	return 0;
-}
-
 static int mlx5e_xdp_set(struct net_device *netdev, struct bpf_prog *prog)
 {
 	struct mlx5e_priv *priv =3D netdev_priv(netdev);
@@ -4415,7 +4398,7 @@ static int mlx5e_xdp_set(struct net_device *netdev, s=
truct bpf_prog *prog)
 		mlx5e_set_rq_type(priv->mdev, &new_channels.params);
 		old_prog =3D priv->channels.params.xdp_prog;
=20
-		err =3D mlx5e_safe_switch_channels(priv, &new_channels, mlx5e_xdp_update=
_state);
+		err =3D mlx5e_safe_switch_channels(priv, &new_channels, NULL);
 		if (err)
 			goto unlock;
 	} else {
--=20
2.20.1

