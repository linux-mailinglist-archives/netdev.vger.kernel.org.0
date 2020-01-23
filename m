Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7733146213
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 07:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728799AbgAWGkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 01:40:15 -0500
Received: from mail-eopbgr80074.outbound.protection.outlook.com ([40.107.8.74]:3150
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728665AbgAWGkM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jan 2020 01:40:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JEKXptQ0oh2fShILhUdb/+xITKkzMT5hZZn8HgMmQuiJUmJDj1/nqzLmkdrLlICSoKfUq5lCfL7wz98Q2j1AiaxI6R4aIcfQ9lELesrsFZ0oGiablSd0+lJy/cAHVv2DcX9smooPSJ4B+kCoWUGgWsrU7Z5pqJE3vxLfIHLBQaRm2DM6FEpx0L3FDJ0TdD8QXDy5zblHEVJk9MbshSQ2F2qH0IumY+Xf9jMNBWNvOD9eqNZF57U2vp0PEOF7XJ4WDN6M2+K6IT6kcEPAy6VFCp4QDTbbeniqHz3CCPavcn/yA6Bzm2BCbRIUnup84NFNdM4Cu7B46r1sDSOyWgscQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vQn8qaqPvrCj0DOH8JFittBfDWVGPPt+bHlT2mEBTy0=;
 b=VILjL9ZOhVOwQWyyTDs6KYSK3NOtS4IL3opsikJC/44K/Tapwy6oI/D+xvPQjVuK3vXKaotUHDSgBLUeRi3YjHV67xiYrHSs8CTQzz/vatz2LxuTO8BBMzANe7XaGHSIVyGx/6NMjpmDekoOl2og68A0T6UsOm9BP72pjUvXH9kMoAnliM576emaMrQ38yN2yNOvWzeu1A6VMT2IyCqJwS69h3V84OqMcUFFF9tVcpcPnzqwGtQP+NNKNtADAXTTrOaSPwpjeFj29r9EpbH7olalgvxcWwyg5nGBMuqIkSm7zEnhkomL+w7vZOtOOSRprCWrkjHvRpJb9+o7aDkQGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vQn8qaqPvrCj0DOH8JFittBfDWVGPPt+bHlT2mEBTy0=;
 b=iIyWfR8yReDq1KGzz/dpaBHInPEn3hKlPUc+aTD4QEmJopLbbaXY+ql1/UaED7ETfNuqYmW6960jeeoIzQhIjrpOoBRrKHE9HPUVZd/avLyQfU0j+vU87ZM9BAgyvhEGZfc4cmNvpTxISM4eRYDxP+HQbDwSzj2jiMLi84gqnV0=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4941.eurprd05.prod.outlook.com (20.177.48.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Thu, 23 Jan 2020 06:40:02 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2644.027; Thu, 23 Jan 2020
 06:40:02 +0000
Received: from smtp.office365.com (73.15.39.150) by BYAPR21CA0027.namprd21.prod.outlook.com (2603:10b6:a03:114::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2686.5 via Frontend Transport; Thu, 23 Jan 2020 06:40:01 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vlad Buslov <vladbu@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 14/15] net/mlx5e: Create q counters on uplink representors
Thread-Topic: [net-next 14/15] net/mlx5e: Create q counters on uplink
 representors
Thread-Index: AQHV0bfwgqfHZ7UgxkKFaBZ4i6CEnA==
Date:   Thu, 23 Jan 2020 06:40:02 +0000
Message-ID: <20200123063827.685230-15-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: e21ff19b-60f6-4c39-5014-08d79fcf1327
x-ms-traffictypediagnostic: VI1PR05MB4941:|VI1PR05MB4941:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB49412300A88889633719D5CDBE0F0@VI1PR05MB4941.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2201;
x-forefront-prvs: 029174C036
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(39860400002)(376002)(346002)(366004)(199004)(189003)(5660300002)(107886003)(8936002)(6916009)(81166006)(81156014)(8676002)(186003)(6512007)(6486002)(4326008)(86362001)(1076003)(16526019)(71200400001)(26005)(36756003)(52116002)(6506007)(2906002)(66946007)(2616005)(66556008)(956004)(64756008)(66446008)(316002)(478600001)(54906003)(66476007)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4941;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UHT7gEGri4IdSL3CSiw2lCPnCdbRtI0zUxiiHUHDS9kbBhtjqoG1t4qmFVpX2F8XXH6BBfsitvkkyHcZ+gz8zWqCjOtAZhdOCKTjKZO+zJwInUZBqtrdjyvjSjGJen9UfuNFEFd8IIfHVzxwrLxa4l/X1FsMZhYTNK811CYlNLccu+iVcRJYhB173DxeXNNDEZuicyOpQfWSbJnGVf5ZWSi/F9zGJ7gVUQa0CwOSnW25NoXxTVDcWMy9GDPA33VOrIc1F68iye95Pi0Ax/yxWjOe4zFSYbcmsRSQu7uHzwBbcU8LwMwel54vq26aRgx+f5N8NdyiAHdDtE53ofqMi7ZvaIVIvdXY3yuFcKUXg4fo19TrBcDD0VW/ZQbwZ/P65QRe3e6v2jyStJOuesvpAYY6nNYbmz/4+EA/RYaqrbY1Rxu6k0cxKerPfuLq86LnZApIDaBfiJkDHqA+6lhTdAj0gNVhmA7e7GvX7d0aZfJ2cHoFL3zkbgyGUW8i/+3sWKRa6/MCYdKsyvZHwBTMAIeCnwxfHxnWcOYZuPcyCeI=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e21ff19b-60f6-4c39-5014-08d79fcf1327
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2020 06:40:02.8102
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7t2xzT6eyDwgBvLqxFqYc0CdD4qT8e2OKoncWWC8NR3yoT/M4g3jPYEJLTZW0y5WOw/90VfV1hrySvYxYi4Uqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4941
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>

Q counters were disabled for all types of representors to prevent an issue
where there is not enough resources to init q counters for 127 representor
instances. Enable q counters only for uplink representors to support
"rx_out_of_buffer", "rx_if_down_packets" counters in ethtool.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  | 21 +++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net=
/ethernet/mellanox/mlx5/core/en_rep.c
index 01745941a11f..f11c86d1b9b7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1716,6 +1716,23 @@ static void mlx5e_cleanup_rep_rx(struct mlx5e_priv *=
priv)
 	mlx5e_close_drop_rq(&priv->drop_rq);
 }
=20
+static int mlx5e_init_ul_rep_rx(struct mlx5e_priv *priv)
+{
+	int err =3D mlx5e_init_rep_rx(priv);
+
+	if (err)
+		return err;
+
+	mlx5e_create_q_counters(priv);
+	return 0;
+}
+
+static void mlx5e_cleanup_ul_rep_rx(struct mlx5e_priv *priv)
+{
+	mlx5e_destroy_q_counters(priv);
+	mlx5e_cleanup_rep_rx(priv);
+}
+
 static int mlx5e_init_uplink_rep_tx(struct mlx5e_rep_priv *rpriv)
 {
 	struct mlx5_rep_uplink_priv *uplink_priv;
@@ -1921,8 +1938,8 @@ static const struct mlx5e_profile mlx5e_rep_profile =
=3D {
 static const struct mlx5e_profile mlx5e_uplink_rep_profile =3D {
 	.init			=3D mlx5e_init_rep,
 	.cleanup		=3D mlx5e_cleanup_rep,
-	.init_rx		=3D mlx5e_init_rep_rx,
-	.cleanup_rx		=3D mlx5e_cleanup_rep_rx,
+	.init_rx		=3D mlx5e_init_ul_rep_rx,
+	.cleanup_rx		=3D mlx5e_cleanup_ul_rep_rx,
 	.init_tx		=3D mlx5e_init_rep_tx,
 	.cleanup_tx		=3D mlx5e_cleanup_rep_tx,
 	.enable		        =3D mlx5e_uplink_rep_enable,
--=20
2.24.1

