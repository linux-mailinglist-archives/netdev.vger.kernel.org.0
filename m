Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6DAE79D0A
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 01:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729892AbfG2Xu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 19:50:29 -0400
Received: from mail-eopbgr130078.outbound.protection.outlook.com ([40.107.13.78]:57824
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728062AbfG2Xu2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 19:50:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Og7ck22HACUkJlems8vLoq4ehV3C/Rh3H6tXq+STkK5ZQ95VZKtrCKr/OSGykNjmdyOBF9CHEZIilannXqhcf3LuPaVd6MeZg7o+3WIgFXHp4qo2JT+A68xNSFwrVQNkD7ZGZcpYOjZGmJvSxGgp7pLW990xmvfxfDgGLODnHsRzICbP2iB46U4RBowrua0SvJF0GQrBrGSoM+v42c6r0cGtQ0VSY+1vmkRvDf1KXis2HYgGL5rz1QWeIxkV2xucJ1HacP7wR+acPLHA9ffNd7G6oulzgTl7/G/YciElgmJMTVAZRT9QXMJIR+DIYdXpyiWNhbFjs4Z2OeGvf+/kxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RTt5iPyrpo4J/blQENWRBa3Qy1Ji7jkVOSnu9cxmH+A=;
 b=foOvC8yDJJBKjQdvroeRiKIf2bLKDEii1NAXcA8EfFY3y9rs7EYD9W+zVKoFlyp/qHNghbU7VJYMpGPRKwHSjmDNb6c4YTnZZkVwnJdLUNMW4icThtp08TItmdUPg30CugiSgp01YtNl4mkdPWjGUT7tF65UiVV7gGDsYVgWwLLVK4k3+shRz6/A+qlMYtDBdE/n4QEqXCcbkCyDaMFiGBxj2zX9+Rq6TVoq99RHzGITUsTlCvpCQY4Rc/KHie5K8HqFzmtGjQXWUNdtmk+WqJV2NBiFC2zfrDoY9L3bBOOhSW8BkYldVRJmg/jfczt4uYmDZe3gdi1xhQpxgwpx5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RTt5iPyrpo4J/blQENWRBa3Qy1Ji7jkVOSnu9cxmH+A=;
 b=bnJd2kUVs8zsCQ3tsRxFczKYEKGTMM8EWy6Ku1eGefO6VOQ0Zuckv5AcUfT89bNcVCS6kSFI8ZT2uCVQ3iJ9zcqYe3x0MKgnExJ22HjF0fFFuXnuty9A4ETIWYbX+4NJodO0vE+Bt9s6m81HUXe81Ouw3kyPHrZxnuDHWRfv868=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2343.eurprd05.prod.outlook.com (10.168.56.136) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Mon, 29 Jul 2019 23:50:18 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2115.005; Mon, 29 Jul 2019
 23:50:18 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: [net-next 02/13] net/mlx5e: Avoid warning print when not required
Thread-Topic: [net-next 02/13] net/mlx5e: Avoid warning print when not
 required
Thread-Index: AQHVRmhgX5OKIWGrvkabbYCGFqeoQg==
Date:   Mon, 29 Jul 2019 23:50:18 +0000
Message-ID: <20190729234934.23595-3-saeedm@mellanox.com>
References: <20190729234934.23595-1-saeedm@mellanox.com>
In-Reply-To: <20190729234934.23595-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR05CA0015.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::28) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7ec59563-5376-4719-d2c1-08d7147f8288
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2343;
x-ms-traffictypediagnostic: DB6PR0501MB2343:
x-microsoft-antispam-prvs: <DB6PR0501MB23431C7F04AE51C9BF9960ABBEDD0@DB6PR0501MB2343.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:556;
x-forefront-prvs: 01136D2D90
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(346002)(39860400002)(376002)(136003)(199004)(189003)(14454004)(25786009)(71190400001)(71200400001)(386003)(6506007)(6512007)(81166006)(81156014)(76176011)(8936002)(6436002)(8676002)(6486002)(316002)(102836004)(54906003)(6916009)(7736002)(478600001)(52116002)(186003)(26005)(99286004)(14444005)(256004)(476003)(5660300002)(1076003)(66446008)(66066001)(66556008)(66476007)(64756008)(36756003)(53936002)(486006)(86362001)(305945005)(107886003)(66946007)(68736007)(446003)(2616005)(11346002)(50226002)(6116002)(3846002)(4326008)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2343;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: EyGT3+ZVFXaHxtpZt3Y843pPQaJDbk577Ftoh7hNtBF4XPl9nUTtj9TpegzFU18uK5j0kcBJCFSQyUhkdF6VR94LXEe2vN8y/GgTDte0IX8Bf6peZe41gfc5+8eLlv2iWeEhBZ7svOOfT+fMHTmPg0UD7kmqXG8zv42HlSp5nTp3E6t9uyLKnYOINZWkto3ph9/+MtRLH9cOJoUVOl4O5xcU0CJtvH4ruqDn4UYWgDrfcX9iuG9OOcvhyFN3a8NEoHI6wtMZOAUGdrphc210c3cNnvJxjCX5+31YzeIxAX4zcCm0yJiywsnLipjfuYEjE/pYzNcMMr051j2FxobOSWioA+9mFTdDaLkDzJl4nMPSwAJJGhuKcv48RcNz+6yG6HXrMCXkdobCIII1NBJacDpoQVJprThfVX8YkFhbwhw=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ec59563-5376-4719-d2c1-08d7147f8288
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2019 23:50:18.3579
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2343
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When disabling CQE compression in favor of time-stamping, don't show a
warning when CQE compression is already disabled.

Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_main.c
index 776eb46d263d..266783295124 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3958,7 +3958,8 @@ int mlx5e_hwstamp_set(struct mlx5e_priv *priv, struct=
 ifreq *ifr)
 	case HWTSTAMP_FILTER_PTP_V2_DELAY_REQ:
 	case HWTSTAMP_FILTER_NTP_ALL:
 		/* Disable CQE compression */
-		netdev_warn(priv->netdev, "Disabling cqe compression");
+		if (MLX5E_GET_PFLAG(&priv->channels.params, MLX5E_PFLAG_RX_CQE_COMPRESS)=
)
+			netdev_warn(priv->netdev, "Disabling RX cqe compression\n");
 		err =3D mlx5e_modify_rx_cqe_compression_locked(priv, false);
 		if (err) {
 			netdev_err(priv->netdev, "Failed disabling cqe compression err=3D%d\n",=
 err);
--=20
2.21.0

