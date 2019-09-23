Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 570EEBB3FE
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 14:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2501896AbfIWMkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Sep 2019 08:40:20 -0400
Received: from mail-eopbgr30068.outbound.protection.outlook.com ([40.107.3.68]:45569
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2438917AbfIWMkU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Sep 2019 08:40:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WVjohGC2EV3hBqsC0OXSPLymiuK92EfIDJaKnGR7aOg0ulnvnblMpJ0iaszmU2r19wEaEKtEnktjZ1kUfyeN4O4R9vv7Vi/7K5OfsauoW4EwMp7EaiiokdabUDRJdsTDsnIJnFYqf4IKtKUYWaHUWvxTFy5iM5JYNV4UM6gzLtMz/PZbnrkWWGeHUtHUYJfkUEkOKTPqL1Pnx4QCe8LjNuOOKw3bFQv9FpSfID2DdoO6XqRIQl9fCI7HmWkRvdbUZ1SGCWxQaYlNmP/f37soGtxUNnkg+aMSipeWYNURWULW9dxFYydFMtdSSlq441lFbbQN9JWEDG69FoGptVsvNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0rC9i9/KqhY62pb4F+xksskOeFoesp5CKivWwY/nyew=;
 b=YCTTKEiib36RWfwOgIC7T9poNTHzbPT2TUZyMSJaYa0ckjtEJZ1DSXU9nCBdeLzmtC2LkP8m6Sfc/qXP8vdl54Jq77S4SOZe6amchOA7+YLGNwn6mLrzyU0wigeBn4FoRDzcQ4sAaOuitJK8HFjEbk3e6VDq1YkhdRvCfEjRDTb4qELB+yvktlDmOJ8Cx7UfIseohxL7WOugA9rwOP3ho10VQg+CLMF5ddyXiD5V6NVzeGui0W4EM3sjDCLa/EctQe5YghxG+Kmj7GsGMtp1q/bMmih84FlNNpRrkKAzyakXpgXLm6ZZolyKf5/yBU8j0HpzyJSQZEd5VafCHyo++w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0rC9i9/KqhY62pb4F+xksskOeFoesp5CKivWwY/nyew=;
 b=VfsNvYoZrFMLNr/+Zoluxok2IUV9OatGhjv/I+gi8grKnajtbN3gXt1uELQxcg0GdW25jwmCvDA51axn8Nha9JQDX4DHy5p9YjbnISNA4Y8nS7wgBBBJrxEjElT0edlW+eroGLNAjg8WlbKn/KM6x7difeDthPgZ1B/qTHdqZo8=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2339.eurprd05.prod.outlook.com (10.165.45.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.25; Mon, 23 Sep 2019 12:40:16 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::dd87:8e2c:f7ed:e29b]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::dd87:8e2c:f7ed:e29b%9]) with mapi id 15.20.2284.023; Mon, 23 Sep 2019
 12:40:16 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 4.19-stable 4/7] net/mlx5e: Allow reporting of checksum
 unnecessary
Thread-Topic: [PATCH 4.19-stable 4/7] net/mlx5e: Allow reporting of checksum
 unnecessary
Thread-Index: AQHVcgwNThqQmqrQd0Gr0xQ4kNqdjg==
Date:   Mon, 23 Sep 2019 12:40:16 +0000
Message-ID: <20190923123917.16817-5-saeedm@mellanox.com>
References: <20190923123917.16817-1-saeedm@mellanox.com>
In-Reply-To: <20190923123917.16817-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [89.138.141.98]
x-clientproxiedby: BYAPR03CA0036.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::49) To AM4PR0501MB2756.eurprd05.prod.outlook.com
 (2603:10a6:200:5c::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 32a0c572-cf96-4b4d-01d1-08d740232f7f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600167)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR0501MB2339;
x-ms-traffictypediagnostic: AM4PR0501MB2339:|AM4PR0501MB2339:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR0501MB2339966CA4BFF67BDC83B688BE850@AM4PR0501MB2339.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:124;
x-forefront-prvs: 0169092318
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(136003)(39860400002)(396003)(366004)(189003)(199004)(6436002)(11346002)(81156014)(81166006)(54906003)(71200400001)(2616005)(1076003)(476003)(6512007)(71190400001)(305945005)(66066001)(446003)(36756003)(486006)(316002)(478600001)(102836004)(7736002)(66946007)(52116002)(186003)(66476007)(8936002)(76176011)(6916009)(107886003)(14454004)(26005)(14444005)(50226002)(5660300002)(99286004)(256004)(64756008)(3846002)(6486002)(2906002)(66446008)(8676002)(86362001)(25786009)(6116002)(66556008)(4326008)(6506007)(386003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2339;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: pPZrcLbxnVqVhaXnullQlGf6RxrYCMuymHcUMEDx+cd+doNg7t3zDZWgxV7i38IK0kzSN1QjoWtRHc3GF8P4/iyFxnqm08IQB4DGfxngOIdEKBd7qnGi8mMRNHH4cWrUf3oWT8WLellrSZR6FKSLcJJtIl9tXdiwbXv7IG1mME08L4WXHVVp5LQmf3U8ljuiP3V4hNtU9FMFPpplLL7f7wLLmMhB9tQYhnoaeEQWXRnmfAXLBeHjily2+O6EUxhOJ0B/WHu5nZK4jPbJFUdb95nufxZG67EQfOw+vwC9g3AsuHsQlR5LmpjPLXbOVgfENcBplptxcdMipJ1cm5zjsLPU3RqjfeiaTxPP0sMzj7lIgmLPvuT8DFuXdzO9cstX4MvtrvZKtF43L4aKi++P2msxeQ+RAtc0KR9zEkiUdCk=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32a0c572-cf96-4b4d-01d1-08d740232f7f
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2019 12:40:16.4918
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0xADIVuMQz59/JSpifvEvy8ykxZ94+nHWMF12c63nil+V2F6eEuIRwID/Mbpnkx5xAaRs2p+6u0CldrxG7KDcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2339
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Or Gerlitz <ogerlitz@mellanox.com>

[ Upstream commit b856df28f9230a47669efbdd57896084caadb2b3 ]

Currently we practically never report checksum unnecessary, because
for all IP packets we take the checksum complete path.

Enable non-default runs with reprorting checksum unnecessary, using
an ethtool private flag. This can be useful for performance evals
and other explorations.

Required by downstream patch which fixes XDP checksum.

Fixes: 86994156c736 ("net/mlx5e: XDP fast RX drop bpf programs support")
Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  3 +++
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  | 27 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  4 +++
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |  3 +++
 4 files changed, 37 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/eth=
ernet/mellanox/mlx5/core/en.h
index da52e60d4437..d79e177f8990 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -210,6 +210,7 @@ static const char mlx5e_priv_flags[][ETH_GSTRING_LEN] =
=3D {
 	"tx_cqe_moder",
 	"rx_cqe_compress",
 	"rx_striding_rq",
+	"rx_no_csum_complete",
 };
=20
 enum mlx5e_priv_flag {
@@ -217,6 +218,7 @@ enum mlx5e_priv_flag {
 	MLX5E_PFLAG_TX_CQE_BASED_MODER =3D (1 << 1),
 	MLX5E_PFLAG_RX_CQE_COMPRESS =3D (1 << 2),
 	MLX5E_PFLAG_RX_STRIDING_RQ =3D (1 << 3),
+	MLX5E_PFLAG_RX_NO_CSUM_COMPLETE =3D (1 << 4),
 };
=20
 #define MLX5E_SET_PFLAG(params, pflag, enable)			\
@@ -298,6 +300,7 @@ struct mlx5e_dcbx_dp {
 enum {
 	MLX5E_RQ_STATE_ENABLED,
 	MLX5E_RQ_STATE_AM,
+	MLX5E_RQ_STATE_NO_CSUM_COMPLETE,
 };
=20
 struct mlx5e_cq {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers=
/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 2b9350f4c752..cb79aaea1a69 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -1510,6 +1510,27 @@ static int set_pflag_rx_striding_rq(struct net_devic=
e *netdev, bool enable)
 	return 0;
 }
=20
+static int set_pflag_rx_no_csum_complete(struct net_device *netdev, bool e=
nable)
+{
+	struct mlx5e_priv *priv =3D netdev_priv(netdev);
+	struct mlx5e_channels *channels =3D &priv->channels;
+	struct mlx5e_channel *c;
+	int i;
+
+	if (!test_bit(MLX5E_STATE_OPENED, &priv->state))
+		return 0;
+
+	for (i =3D 0; i < channels->num; i++) {
+		c =3D channels->c[i];
+		if (enable)
+			__set_bit(MLX5E_RQ_STATE_NO_CSUM_COMPLETE, &c->rq.state);
+		else
+			__clear_bit(MLX5E_RQ_STATE_NO_CSUM_COMPLETE, &c->rq.state);
+	}
+
+	return 0;
+}
+
 static int mlx5e_handle_pflag(struct net_device *netdev,
 			      u32 wanted_flags,
 			      enum mlx5e_priv_flag flag,
@@ -1561,6 +1582,12 @@ static int mlx5e_set_priv_flags(struct net_device *n=
etdev, u32 pflags)
 	err =3D mlx5e_handle_pflag(netdev, pflags,
 				 MLX5E_PFLAG_RX_STRIDING_RQ,
 				 set_pflag_rx_striding_rq);
+	if (err)
+		goto out;
+
+	err =3D mlx5e_handle_pflag(netdev, pflags,
+				 MLX5E_PFLAG_RX_NO_CSUM_COMPLETE,
+				 set_pflag_rx_no_csum_complete);
=20
 out:
 	mutex_unlock(&priv->state_lock);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_main.c
index 83ab2c0e6b61..5e98b31620c1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -934,6 +934,9 @@ static int mlx5e_open_rq(struct mlx5e_channel *c,
 	if (params->rx_dim_enabled)
 		__set_bit(MLX5E_RQ_STATE_AM, &c->rq.state);
=20
+	if (params->pflags & MLX5E_PFLAG_RX_NO_CSUM_COMPLETE)
+		__set_bit(MLX5E_RQ_STATE_NO_CSUM_COMPLETE, &c->rq.state);
+
 	return 0;
=20
 err_destroy_rq:
@@ -4533,6 +4536,7 @@ void mlx5e_build_nic_params(struct mlx5_core_dev *mde=
v,
 		params->rx_cqe_compress_def =3D slow_pci_heuristic(mdev);
=20
 	MLX5E_SET_PFLAG(params, MLX5E_PFLAG_RX_CQE_COMPRESS, params->rx_cqe_compr=
ess_def);
+	MLX5E_SET_PFLAG(params, MLX5E_PFLAG_RX_NO_CSUM_COMPLETE, false);
=20
 	/* RQ */
 	/* Prefer Striding RQ, unless any of the following holds:
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_rx.c
index 8323534f075a..4851fc575185 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -754,6 +754,9 @@ static inline void mlx5e_handle_csum(struct net_device =
*netdev,
 		return;
 	}
=20
+	if (unlikely(test_bit(MLX5E_RQ_STATE_NO_CSUM_COMPLETE, &rq->state)))
+		goto csum_unnecessary;
+
 	/* CQE csum doesn't cover padding octets in short ethernet
 	 * frames. And the pad field is appended prior to calculating
 	 * and appending the FCS field.
--=20
2.21.0

