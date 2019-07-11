Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9988265FCD
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 20:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728657AbfGKSyi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 14:54:38 -0400
Received: from mail-eopbgr140083.outbound.protection.outlook.com ([40.107.14.83]:22784
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726116AbfGKSyh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Jul 2019 14:54:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nnL/rFbXyv5Zsk4TgDu0U5ooRY1LcPg0B6FTtNzGhze3kDCTTlF/4lZsSjjJXeFHo7RM8HwXOS4cPZkmxgWT5L0uBwBNp8aydrWdTeqNrbj+sq/eJ/Aq6llsADcflFoMlJJGom8Wy/KqhmHp5kHeE94BdG4wzAY1VXh7vp7n8pW4c7pzkAEH34coZu5R3swUfIfayBvWmTueK/DgxM2m/CneGZnV0IG9CZrZ5QwT1qMl1I0DV1VUPNFd4+7h7l7LiP/EmoxVs8CXPrxZaffNRgAsPIxqLyzIypbeEKxEsWEer49lm1i6hHV4ah9NwWeBU7DOrb9u4CvuvvdEYuLEhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KqOkdDDokDAKMx//A4JTszqIoE09oIgHQqIu8ojXIxM=;
 b=dkbeqUhBiYe8xzHGARk71LRwuh0sigvtj4VZyMPOTebDbynWdmu8sX7OxbAxDq0y3mQ/KujLnvZy/ybrVXKnXKv3HdvwXG5W6DPDu115fmvlHlk29HtP6nqEaDhftstQeP6u5ZlXSH/PAyuVU+q2Whp1/NTbFV+W6kT99WfiJxgn20Pj2rP5R4FL4+Im0mnfC+0QTQkGzHm3e9xekCzm9m1Y17WdxDoz1Qb//MLoHcx58R5dwS/ePmdPYO8lOCUJEg2RH1DPrPlH08f99PvgYfjJ4nYLDBFS2181Pb/D47pPCpdd9pF206QvoAuUWRh4ZfEbkaG+2US8CH40XUNUxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KqOkdDDokDAKMx//A4JTszqIoE09oIgHQqIu8ojXIxM=;
 b=fwrZhAsFUB8iLEifuYRs5XAE3FjpqsAapW1E04ka/Q6Z8k9I+WKf+Ws4pUTfOq8v2OXFh9aujnhDTBwoJ2OojqgzS4OPCRAesM92uB96lMQdoJoXjvyDfO7GJJ89Ff0FFx0wu4W7Rhb2A5ZcubLL1GADMfEJzDN85xMGgApBuEg=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2770.eurprd05.prod.outlook.com (10.172.218.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.10; Thu, 11 Jul 2019 18:54:21 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::4828:eda7:c6d:69e1]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::4828:eda7:c6d:69e1%9]) with mapi id 15.20.2052.022; Thu, 11 Jul 2019
 18:54:21 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>,
        Feras Daoud <ferasda@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 6/6] net/mlx5e: IPoIB, Add error path in mlx5_rdma_setup_rn
Thread-Topic: [net 6/6] net/mlx5e: IPoIB, Add error path in mlx5_rdma_setup_rn
Thread-Index: AQHVOBoMYzPywOQ540yOpl2PhdHiKw==
Date:   Thu, 11 Jul 2019 18:54:21 +0000
Message-ID: <20190711185353.5715-7-saeedm@mellanox.com>
References: <20190711185353.5715-1-saeedm@mellanox.com>
In-Reply-To: <20190711185353.5715-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR07CA0083.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::24) To AM4PR0501MB2756.eurprd05.prod.outlook.com
 (2603:10a6:200:5c::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 72475c0c-267e-4501-2641-08d706312ee2
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR0501MB2770;
x-ms-traffictypediagnostic: AM4PR0501MB2770:
x-microsoft-antispam-prvs: <AM4PR0501MB2770ED96DCD6A956A6764420BEF30@AM4PR0501MB2770.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:38;
x-forefront-prvs: 0095BCF226
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(39860400002)(346002)(396003)(366004)(199004)(189003)(68736007)(6116002)(3846002)(1076003)(86362001)(446003)(81166006)(8676002)(486006)(53936002)(71190400001)(25786009)(66476007)(66446008)(64756008)(66556008)(11346002)(66946007)(14454004)(81156014)(6916009)(2616005)(476003)(36756003)(5024004)(14444005)(7736002)(99286004)(6506007)(50226002)(66066001)(52116002)(386003)(4326008)(76176011)(478600001)(5660300002)(2906002)(6436002)(6486002)(316002)(305945005)(102836004)(8936002)(26005)(186003)(54906003)(256004)(107886003)(71200400001)(6512007);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2770;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: FSLpiltzRE9FBawalTpEx4UuDgObRQfh7W1daUXZVBm7Ze3VxZaU4trbq/p5TX4CU4UGSVy5YiUrKlTcCaD+oaXXjKvqulVyOuirUOF+D6dGJHRmrGE/MmPyL7F3S5xFxbEIw+CXIr32L3llw2aiUFyAkty4MjsFMobREDgW7RU/oy7ALMcUvunlqqgjJgHvIf8NbGizYw9oFytW5tK1xKLuAn1Vp59L9cSbsUqlYMOiRwZyKkKVRh5LTj1bG3cOoofTQjB3RmKSTh+48QULteEpTtJFv8GB8j55av/IeOz/WEcPFR9cFtHKJV3gXug3KRHswFgx1rn35PRPvFMvopYTTRds21Q86iaD+QucKJ0Uw3M9ebAqUsRTVEn0CXs7VpZZ5TC1T6njKaYJLbwUHloHjReg2WDiAqU95CYG+MY=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72475c0c-267e-4501-2641-08d706312ee2
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2019 18:54:21.3118
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2770
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Check return value from mlx5e_attach_netdev, add error path on failure.

Fixes: 48935bbb7ae8 ("net/mlx5e: IPoIB, Add netdevice profile skeleton")
Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Feras Daoud <ferasda@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c b/driver=
s/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
index 9ca492b430d8..603d294757b4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -698,7 +698,9 @@ static int mlx5_rdma_setup_rn(struct ib_device *ibdev, =
u8 port_num,
=20
 	prof->init(mdev, netdev, prof, ipriv);
=20
-	mlx5e_attach_netdev(epriv);
+	err =3D mlx5e_attach_netdev(epriv);
+	if (err)
+		goto detach;
 	netif_carrier_off(netdev);
=20
 	/* set rdma_netdev func pointers */
@@ -714,6 +716,11 @@ static int mlx5_rdma_setup_rn(struct ib_device *ibdev,=
 u8 port_num,
=20
 	return 0;
=20
+detach:
+	prof->cleanup(epriv);
+	if (ipriv->sub_interface)
+		return err;
+	mlx5e_destroy_mdev_resources(mdev);
 destroy_ht:
 	mlx5i_pkey_qpn_ht_cleanup(netdev);
 	return err;
--=20
2.21.0

