Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 804C796A5C
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 22:25:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731141AbfHTUZc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 16:25:32 -0400
Received: from mail-eopbgr50051.outbound.protection.outlook.com ([40.107.5.51]:14918
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730996AbfHTUYh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 16:24:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nbn1SReGvG5Flh1n52wmF+Y8mjYzgtS5UAjPvvJAiXi546Xwde9lgjtHy3EPz4MuVzbccB5bG0H4ajiM4RJ0nK+5yXyGeQbkFesONLrFVSKBA06wWf6Jc7b2KaFfVPaNfufiYoaQ1DdQkHquYSWGUxeNsHSSIlpwcANkmmvLFjd0I3+13rK03dimC1vBI5sFGcm/hIS721NR3wP6kCCerdUYebQhlYnU2whwXAPYJRRbkyqT3WLXJLJjE18/2JlwVCAiNd99DZ+46e+630ObDAadfIAiZG2go7zNWKu//zfsepX9u0fRdfe5PPlOYP+VXAcasbbWEbROorrh5XagSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zfjKxD8pB+ofdJ3BbjGAgCVVz9GW21do2WKbqU05L88=;
 b=ZK0wKjuNx+ihbqCuwM4YJ6zoDfkBP+EQKOy2A56FplRMhyuoDVB8fDWwa5syIFiKbhMBdP4fVChLlZ8Zo6kHjjUKOUqANShjXTlFt7dL48mku9WBjrK0Y3IeuBAsu8wTMciDmulvKss9mHztCpO10wBe2QognNvkLyLTrvx1jI5ipCMcitrbNkvbWfodPDcXgLGGIEziyCQRfjcWxv67U/q0cDKoENUn8U0S87MbCojla4Ymcv0eQdjb58FOdlDI3aj3ozAbLLBrSCBPasAdmHwCnALguKm+jf3H6i927YRle2bP9c2xrKxAA28fFi9ljA1rGpyu195pKDXUJSyyvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zfjKxD8pB+ofdJ3BbjGAgCVVz9GW21do2WKbqU05L88=;
 b=jtJVBfqZ/Fbfykrzy52l57G4Jw380WvLvPhS1E5YUarZICqttR0nI8dh7jj7LRUqpvz2gJqvvDIefK194g+oeM0uCmn79ji9hIg1RwUBoyuFnaK6dhCTFQW+x9ybBXON16sxS35qSNdyYFk8zZw4PCOl3qIsTPi+5Y8C08TtdTI=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2680.eurprd05.prod.outlook.com (10.172.226.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.18; Tue, 20 Aug 2019 20:24:24 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2178.018; Tue, 20 Aug 2019
 20:24:24 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next v2 07/16] net/mlx5e: Add helper functions for reporter's
 basics
Thread-Topic: [net-next v2 07/16] net/mlx5e: Add helper functions for
 reporter's basics
Thread-Index: AQHVV5VBna3VS3yJo0il2VW3vJG7jA==
Date:   Tue, 20 Aug 2019 20:24:24 +0000
Message-ID: <20190820202352.2995-8-saeedm@mellanox.com>
References: <20190820202352.2995-1-saeedm@mellanox.com>
In-Reply-To: <20190820202352.2995-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR02CA0046.namprd02.prod.outlook.com
 (2603:10b6:a03:54::23) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 21062c7a-c95c-4582-78c5-08d725ac6442
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2680;
x-ms-traffictypediagnostic: DB6PR0501MB2680:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0501MB2680BDD65C95E0B428C1836BBEAB0@DB6PR0501MB2680.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1122;
x-forefront-prvs: 013568035E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(366004)(346002)(39860400002)(396003)(199004)(189003)(446003)(11346002)(486006)(86362001)(476003)(8676002)(14454004)(81156014)(8936002)(25786009)(26005)(6486002)(102836004)(386003)(53936002)(6506007)(5660300002)(36756003)(6436002)(478600001)(7736002)(186003)(52116002)(99286004)(76176011)(6512007)(81166006)(66066001)(2906002)(2616005)(50226002)(4326008)(14444005)(1076003)(64756008)(66556008)(256004)(66446008)(6116002)(66946007)(3846002)(6916009)(66476007)(316002)(71190400001)(71200400001)(107886003)(305945005)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2680;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: SmqDYChpkYYPNbvgH7IQ+sFczaXJzbhyF66lanvS4BdYLaJ4echQyNxwrRe6HhQWaLbW0V8flyOev6lTDoFWCYM55SO1GS/nBbo87twmoGm20kwhw57oJ9p7n35Dnv+60Ft374b7qf6giv89ckxFV+J3xhahVnYuvKuKmvvisAPaJqmktdJqSbGrcwOSZykz4ZlSQL7DQN7y7YqPHxCXXPK5b0iMhpzPrTmt+SRYuN4VPLJ8VkfZsyZ/gVBDTx93TewiNMtiG4kURicJxFFV6LhPyxWYB4gYbRJlx0sB9hNfo9MxM1ppa/InPruChgdCJ+7wkni/I6n2puk0S6T0eLzxutvVO9xK2yqxrAkqK7C1HHZHYUN4qZPzuKZDfiKWmHG3avj6pZaR4bNcA8iVFq+H1KXOKS9Ha/x6J/+FtXM=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21062c7a-c95c-4582-78c5-08d725ac6442
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2019 20:24:24.3974
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uE4DcbHZlsD5i6zsubWYTKbxZqEFGwKvit2KCw0JTXk4RqEFqYhigLicINvmAdV8qJtPW89MlKCcnna9WhVhiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2680
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Introduce helper functions for create and destroy reporters and update
channels. In the following patch, rx reporter is added and it will use
these helpers too.

Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/health.c | 17 +++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en/health.h |  4 ++++
 .../net/ethernet/mellanox/mlx5/core/en_main.c   |  9 +++------
 3 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/health.c b/drivers/=
net/ethernet/mellanox/mlx5/core/en/health.c
index ffd9a7a165a2..c11d0162eaf8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
@@ -96,6 +96,23 @@ int mlx5e_reporter_cq_common_diagnose(struct mlx5e_cq *c=
q, struct devlink_fmsg *
 	return 0;
 }
=20
+int mlx5e_health_create_reporters(struct mlx5e_priv *priv)
+{
+	return  mlx5e_reporter_tx_create(priv);
+}
+
+void mlx5e_health_destroy_reporters(struct mlx5e_priv *priv)
+{
+	mlx5e_reporter_tx_destroy(priv);
+}
+
+void mlx5e_health_channels_update(struct mlx5e_priv *priv)
+{
+	if (priv->tx_reporter)
+		devlink_health_reporter_state_update(priv->tx_reporter,
+						     DEVLINK_HEALTH_REPORTER_STATE_HEALTHY);
+}
+
 int mlx5e_health_sq_to_ready(struct mlx5e_channel *channel, u32 sqn)
 {
 	struct mlx5_core_dev *mdev =3D channel->mdev;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/health.h b/drivers/=
net/ethernet/mellanox/mlx5/core/en/health.h
index 6725d417aaf5..b2c0ccc79b22 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
@@ -29,5 +29,9 @@ int mlx5e_health_recover_channels(struct mlx5e_priv *priv=
);
 int mlx5e_health_report(struct mlx5e_priv *priv,
 			struct devlink_health_reporter *reporter, char *err_str,
 			struct mlx5e_err_ctx *err_ctx);
+int mlx5e_health_create_reporters(struct mlx5e_priv *priv);
+void mlx5e_health_destroy_reporters(struct mlx5e_priv *priv);
+void mlx5e_health_channels_update(struct mlx5e_priv *priv);
+
=20
 #endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_main.c
index 695c75a8d1ab..f3bcb9ddca58 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2323,10 +2323,7 @@ int mlx5e_open_channels(struct mlx5e_priv *priv,
 			goto err_close_channels;
 	}
=20
-	if (priv->tx_reporter)
-		devlink_health_reporter_state_update(priv->tx_reporter,
-						     DEVLINK_HEALTH_REPORTER_STATE_HEALTHY);
-
+	mlx5e_health_channels_update(priv);
 	kvfree(cparam);
 	return 0;
=20
@@ -3201,7 +3198,6 @@ static void mlx5e_cleanup_nic_tx(struct mlx5e_priv *p=
riv)
 {
 	int tc;
=20
-	mlx5e_reporter_tx_destroy(priv);
 	for (tc =3D 0; tc < priv->profile->max_tc; tc++)
 		mlx5e_destroy_tis(priv->mdev, priv->tisn[tc]);
 }
@@ -4969,12 +4965,14 @@ static int mlx5e_nic_init(struct mlx5_core_dev *mde=
v,
 		mlx5_core_err(mdev, "TLS initialization failed, %d\n", err);
 	mlx5e_build_nic_netdev(netdev);
 	mlx5e_build_tc2txq_maps(priv);
+	mlx5e_health_create_reporters(priv);
=20
 	return 0;
 }
=20
 static void mlx5e_nic_cleanup(struct mlx5e_priv *priv)
 {
+	mlx5e_health_destroy_reporters(priv);
 	mlx5e_tls_cleanup(priv);
 	mlx5e_ipsec_cleanup(priv);
 	mlx5e_netdev_cleanup(priv->netdev, priv);
@@ -5077,7 +5075,6 @@ static int mlx5e_init_nic_tx(struct mlx5e_priv *priv)
 #ifdef CONFIG_MLX5_CORE_EN_DCB
 	mlx5e_dcbnl_initialize(priv);
 #endif
-	mlx5e_reporter_tx_create(priv);
 	return 0;
 }
=20
--=20
2.21.0

