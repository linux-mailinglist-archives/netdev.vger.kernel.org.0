Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B0D8148F3E
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 21:21:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392319AbgAXUVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 15:21:01 -0500
Received: from mail-eopbgr40044.outbound.protection.outlook.com ([40.107.4.44]:63396
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387421AbgAXUU7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jan 2020 15:20:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UJccZkHSsjaYZNJ4D2Pw0LP5X5OOYX/MEe7xY5uJZ7WsH531/f4RiiNtuAjyk3g/FyLdhm2ryt/q98oDgz81GZdwcRkTl1y0gMZ13EhG2VA/n2Ik4eKBEZncv0lQWwR4vhbOHmTuKE+OihceEhiOYOQ9lK9CgKg7MUmN+ybirSafvWOirDWQnAWH2dz0Yc5Q0FtXhXMcoTlWcBCSL4ysv3NIGGKxhpzHhec8lmPAekGm4Pxcwji56mte+ss5yb37RrZk/A72V3dy+Ttd8PMqJuIwj1pj67mtcwvdQsKEdKwmJ3LusOMhEoVcFB9e7nujWUPfDeH0oFS9n+1ONHEJ9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sIWW5QaJHq2budAK2vmveIPfHs9btlT+3I5fZPIMKaQ=;
 b=I0EAftDXVXEUounfHabWA5QzhMOyscB8fT3SINtUK60JxkYglILekWaYhIER6U/cpH7yU0AM5XRcU1W9JYR60H8oBaAZn87yp5d15goB0BxW88/RycFLv5bzP/OBpW1+VgMBiozPXQzPUVDJEcigZO3u8rhMHYBt6Dh8P0ko4D0X8QlI3MngEyCl1I//kXYuQpTtEE7GCphBKyXQ8ZIhH1Zdw71fEiv8PA5VPo92JqbjLAJBbiSWpcuDur7Mw+G0XC7kmzoKdmNf06PReWwHfZwZVXWIfBkqM7iJ5n+T8iBR5+zmjwrD8cCtKGpfAzhLnkRF2RZA30lCBYKLi+pi/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sIWW5QaJHq2budAK2vmveIPfHs9btlT+3I5fZPIMKaQ=;
 b=M+Aw5n3JAJti6S5baV0CeRk2o5MrXKqgGSDFCttQTVoWDSpLkDOfq9JUHWP4rg8JiQlXUiiqclB76NI3Fy39OeZ+OtiYKel68sU8IWFIJIT1cCAEW04LzKE1FNtAlMjVTiLD1dprJTNnL2EcIpSn7iL/eS5ev8agQp7Ahxt52tw=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5552.eurprd05.prod.outlook.com (20.177.202.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.20; Fri, 24 Jan 2020 20:20:54 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2644.027; Fri, 24 Jan 2020
 20:20:54 +0000
Received: from smtp.office365.com (209.116.155.178) by BYAPR01CA0071.prod.exchangelabs.com (2603:10b6:a03:94::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.21 via Frontend Transport; Fri, 24 Jan 2020 20:20:52 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Meir Lichtinger <meirl@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 2/9] net/mlx5: Update the list of the PCI supported devices
Thread-Topic: [net 2/9] net/mlx5: Update the list of the PCI supported devices
Thread-Index: AQHV0vPHeg/Qar/QMkGruiLbZTNzSg==
Date:   Fri, 24 Jan 2020 20:20:53 +0000
Message-ID: <20200124202033.13421-3-saeedm@mellanox.com>
References: <20200124202033.13421-1-saeedm@mellanox.com>
In-Reply-To: <20200124202033.13421-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR01CA0071.prod.exchangelabs.com (2603:10b6:a03:94::48)
 To VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4017642c-56bb-4b20-773e-08d7a10ae979
x-ms-traffictypediagnostic: VI1PR05MB5552:|VI1PR05MB5552:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5552FB7F19F7E2CE3925B66ABE0E0@VI1PR05MB5552.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:257;
x-forefront-prvs: 02929ECF07
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(366004)(346002)(396003)(39850400004)(199004)(189003)(64756008)(66446008)(66946007)(4326008)(66476007)(107886003)(66556008)(316002)(1076003)(6512007)(6916009)(71200400001)(54906003)(15650500001)(16526019)(186003)(52116002)(26005)(6486002)(6506007)(956004)(2616005)(2906002)(478600001)(5660300002)(86362001)(36756003)(81156014)(81166006)(8936002)(8676002)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5552;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TX6k+NIVspUBy6vuT11ehcVQe8Vvc4Hew4XysNX8Q9F/4GY2jOZfSRHGo7bw+r0NvOPCA9qhrCGKQZ7GmqyU/0UmJTZScPx+lsDYh7HhoHJDaHdReFv40TtoTpmZONy8Ws4FWT+C+Q3oVX2CQiPe9bAgA7PHDLqsW5B9gRXK9JTS0U4ly95q8OtMsFjcZE5N36MqeL7hHrsURnYIbOsqtkKZjHSfXdW5GHXN61NmZUund/7FTX4o7bq1+eWumk05+1qnBX6qYcckztfzJB92f5FKzAa3hHcD29YtCKdIfIlPs5z3tuUDbQi5FJp8AnaS+i2t4JQdmb0RZCnVwWFltQPXUSnczXvzM/Ub3RzcZe2V2nRwpZItVbsO71ttflxvKbsAsFGFHCn+MMwFHcVOGuu7UeTN6ZbSU1HuggaGwUMYNSEBbZqnWa3xaDm1Nv17V+nOv7sgMqX69tkpSfmNpI5U4+1sfnWJYT9n1FvAqIMzhJrU77uoHpC/ksr1nP2DHAFMQrStssPcMxo2GxNFdLzrYnDrTWPB9CaPhMI7Mc8=
x-ms-exchange-antispam-messagedata: kKsvWh3o5vY5ttrFmwoiVGCyULpf+FnH5va0DCY+mzDJsUfCYPnByEEx46HRTiEf4Pk3ywvxRCDCbPO8su8U9nbV7PY6WmTlbbHt2xu+zkRlsNrf8ktOeA2tT0s6KWza/EYglnZlU/hnmyxxDet+XA==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4017642c-56bb-4b20-773e-08d7a10ae979
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jan 2020 20:20:53.8958
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6jSqNo9ZcUv2NgDGEzTqsnXp+rk1vS/2aotFOODaD0JSKq3OxH8cHl5qfVSbFo6rwxEDkP6XVBnfuemT6v5WtQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5552
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Meir Lichtinger <meirl@mellanox.com>

Add the upcoming ConnectX-7 device ID.

Fixes: 85327a9c4150 ("net/mlx5: Update the list of the PCI supported device=
s")
Signed-off-by: Meir Lichtinger <meirl@mellanox.com>
Reviewed-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/e=
thernet/mellanox/mlx5/core/main.c
index cf7b8da0f010..f554cfddcf4e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1563,6 +1563,7 @@ static const struct pci_device_id mlx5_core_pci_table=
[] =3D {
 	{ PCI_VDEVICE(MELLANOX, 0x101d) },			/* ConnectX-6 Dx */
 	{ PCI_VDEVICE(MELLANOX, 0x101e), MLX5_PCI_DEV_IS_VF},	/* ConnectX Family =
mlx5Gen Virtual Function */
 	{ PCI_VDEVICE(MELLANOX, 0x101f) },			/* ConnectX-6 LX */
+	{ PCI_VDEVICE(MELLANOX, 0x1021) },			/* ConnectX-7 */
 	{ PCI_VDEVICE(MELLANOX, 0xa2d2) },			/* BlueField integrated ConnectX-5 n=
etwork controller */
 	{ PCI_VDEVICE(MELLANOX, 0xa2d3), MLX5_PCI_DEV_IS_VF},	/* BlueField integr=
ated ConnectX-5 network controller VF */
 	{ PCI_VDEVICE(MELLANOX, 0xa2d6) },			/* BlueField-2 integrated ConnectX-6=
 Dx network controller */
--=20
2.24.1

