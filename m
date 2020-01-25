Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D597614937B
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 06:17:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729367AbgAYFMW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 00:12:22 -0500
Received: from mail-db8eur05on2084.outbound.protection.outlook.com ([40.107.20.84]:50912
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727322AbgAYFMU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Jan 2020 00:12:20 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BTVmeRiqJ28TXoQXoEAKiPTAOHoGS7yAfFP/HokjPoLEfchmig+okHTrzGUdrjGWFTlSMP0UxeAo4INHHrSMqnUzNhdhZcLd0mk3IOa8CeoszjFrVYDwodpHPvPt8O3q3PF7epbRY6X512yJFqzckQq7SFnTxP1duHh/60aGU9EEBxG9Lc1pI8Wuo9ID8CCBE7hr80qZXbIBbyNkovj3z0F5/xpaGPQPN3jPXYs0D2uyTR4EOaqQBrg1KFsAnf9CGlR1UNMqoHGOIgWP1fmMAvLTDMyuJpI+pqpU45i+WLIKil2ULXsKEebIcJogUWtBu4PEwcKr6raH4OIE3hVBZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vT6tGO7Fm1WNB2N7cyzEYfJ66iDK0/bWzAV4XoiH8LA=;
 b=a/rl8EbYzPbHUx1l9/QbPXlhv+P2RA40QnzOeVuccazUqJF9UdGkSJI1Z2FL3k0o78gG8WwzvJc6lfhTGpKh0KMAtPBG3cB2/eP9nsYQuAO+IJnzZElzMYluBAtQ+TbxXBuFAsFQg5czobQRNXXOaNFMdk1srX5J6OMGX1ae7DXbPzaoZm9LZult6Y+e99pUmQHasj4v+JcwQcoA0boIOxOFF/P+dnqd2DooBAxHs1rCWH72BW+qcSxr37UmQ5sp3Ng5TGwe/Dfow4uWIBNcmhMEmgVbtM6fAmt18gwWwP8IdBPZdy2n11PrPTIsrIqG9AwsNsBZzTWxiJkz8nyDEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vT6tGO7Fm1WNB2N7cyzEYfJ66iDK0/bWzAV4XoiH8LA=;
 b=WRhGqDuvnWksyFxg/KtWUJ474Z7O+x1aMsvUfK16C29SbSyf1m0aTJnt+2zm/qUP+dVYXRrSe3QRFk1LiuUl+vUFqE6gEqbYpHO6Z+9OjljfMbh4av279rC0fEhkwPSqORgfeBMxi305q7hCra6NogWyOgR3dCbiZ9PcshUc7YY=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1SPR01MB0394.eurprd05.prod.outlook.com (10.186.159.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.22; Sat, 25 Jan 2020 05:12:02 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2644.027; Sat, 25 Jan 2020
 05:12:02 +0000
Received: from smtp.office365.com (73.15.39.150) by BY5PR16CA0025.namprd16.prod.outlook.com (2603:10b6:a03:1a0::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.20 via Frontend Transport; Sat, 25 Jan 2020 05:11:59 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Paul Blakey <paulb@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V2 14/14] net/mlx5: Fix lowest FDB pool size
Thread-Topic: [net-next V2 14/14] net/mlx5: Fix lowest FDB pool size
Thread-Index: AQHV0z35Vf2X5SXWF0qVJyzTFn43Ig==
Date:   Sat, 25 Jan 2020 05:12:01 +0000
Message-ID: <20200125051039.59165-15-saeedm@mellanox.com>
References: <20200125051039.59165-1-saeedm@mellanox.com>
In-Reply-To: <20200125051039.59165-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BY5PR16CA0025.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::38) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: bde6b2b9-c917-4164-0ed1-08d7a1551c2a
x-ms-traffictypediagnostic: VI1SPR01MB0394:|VI1SPR01MB0394:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1SPR01MB039474C80906245CBEDE7838BE090@VI1SPR01MB0394.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0293D40691
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(376002)(346002)(39860400002)(136003)(199004)(189003)(1076003)(71200400001)(8936002)(316002)(16526019)(6916009)(186003)(2616005)(956004)(478600001)(54906003)(5660300002)(6486002)(4326008)(107886003)(86362001)(52116002)(2906002)(36756003)(66946007)(66476007)(81166006)(66446008)(64756008)(8676002)(6666004)(26005)(81156014)(6506007)(66556008)(6512007)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1SPR01MB0394;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QiQkMt2J5UvppbenJs/+clpDjZZ7YZEHSzooxe/vFJrZTYSl462vgnEYT9maC54yHujEfP/2/sRodVBgzCxMmRu8mCVQ4wcyfV5U0rCWFpeo2WXK39AG1MnC+DmtTJXBZoZis8mzBEKIZK9FV2rzMbNZs82ZC1ygM/a6hf/kjaBLd/PbNd6MDjhn5tiY6KL9cWPE9qWGPtJ1kbsxaIwhCfDumIhCD7OkC2Zz253aT5DXFZBwWMHhvmE16IweFW2eACUp+Re1sY5LV7AR1mnG0xjIEOMcg193srHCmEcckWYpemg8TJd/wk/6lsxxwRNNakJtZ3tCm58yOTP9hs/S6l+c1kTqx8h35qH/N2K+fEP14pItgc1beh9ELKuTOvbAS2PKSBJlLdze3nIfgC9Z7GNy2UgCf+2HjkzsLCpUQYnpRPHxoo0dUXwiVdVm4a5/14kn/U/KanQFMZ0251sP+s10g+StiemnSaaX9hS2qEtDneSjrSKKK6DJCnqzxcQqzu7rUaSSegt+Z0CezFEYm1p8lYq5A7AlLEfGD14LG8o=
x-ms-exchange-antispam-messagedata: 9MLNPrwL6y2/csnXxrZBZoE3o/tNnHsdDBCpUl1O460NlSKKpUiMZzICzfrUp04aT098X7aomlv16eg9va2olHhqAOsHebRXvgHaxSt9D/v8cD5sNjoqkpDvdiqwjoOPKFukqqp/P7g7BzLqM4FCWw==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bde6b2b9-c917-4164-0ed1-08d7a1551c2a
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jan 2020 05:12:01.9951
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cK1HZn8gTqKKyvmCH8Ojum54jFwjSe4wVWNZ1P+vNUIezmm4zSTpap/mIqIp7RCeXdEJsv6XGzqLHgpuWu/5Sw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1SPR01MB0394
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@mellanox.com>

The pool sizes represent the pool sizes in the fw. when we request
a pool size from fw, it will return the next possible group.
We track how many pools the fw has left and start requesting groups
from the big to the small.
When we start request 4k group, which doesn't exists in fw, fw
wants to allocate the next possible size, 64k, but will fail since
its exhausted. The correct smallest pool size in fw is 128 and not 4k.

Fixes: 39ac237ce009 ("net/mlx5: E-Switch, Refactor chains and priorities")
Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c   | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chain=
s.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c
index c5a446e295aa..4276194b633f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c
@@ -35,7 +35,7 @@
 static const unsigned int ESW_POOLS[] =3D { 4 * 1024 * 1024,
 					  1 * 1024 * 1024,
 					  64 * 1024,
-					  4 * 1024, };
+					  128 };
=20
 struct mlx5_esw_chains_priv {
 	struct rhashtable chains_ht;
--=20
2.24.1

