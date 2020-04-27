Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0FA81B9A12
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 10:25:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726566AbgD0IZs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 04:25:48 -0400
Received: from mail-mw2nam12on2076.outbound.protection.outlook.com ([40.107.244.76]:6234
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726003AbgD0IZs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 04:25:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ao+AowwJPLLVfhl5PFHleTNEuDPJObK3vW89msAzlNUkSPDvGvhoR36HTVoPq0mBO5sOmw/T5aS/9MD9i9p5DsbzbyBoI090qXq9NJH1VGUBnSl+iKMrW2xHxR/uISMTUU5zGWb1WYPi+VtOl+9qJASWqLSJ2o7hk9m7B5VcN6wi3tWx2rt0U5OUft9x39EznJK9Qbx3XWNSkeCXdU0rAcbu5+Y2aueVA55sRnXqUThjdLtUzagICkPBKr6TZyedv4NxFsq1VZfxf8ctYd0ha4LtHE2j0+v2JfrVPv4UJjOdc1TP5dOUkluQYohJNcmeNcRF1hb8avJKJC3eNh+Q0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J6cDoOE+3VVVEUh7yArzrcotYL0J3qPFmMJAOMKlWyI=;
 b=WiK4owEFQF38x7b/GMZVV3fxsbwdM7T+7Mu5pKZkndaj33GxwMQA1UI1MU7C+tnXtaIKL6aSYSuWBLfiAfZghWtLMn3paK2adZ2BdM28EKM2niButn4eDyys5F0DPgLKADpghh7bFgO3fqtIfaGRkLg9UCEJIXChbYAzLVpeRPLBZWiMgEtZyPt8ymBotobkLf0MNGoXig2Qj897G29WMBXWip4g+d9b58VQLAQdhnuCCxoEC9oRUL+Cd2p6AoVAVhklLUIsefZ5dL2OyhcgAvy1LDZhqldYia61lYWXRhvDeZ1u7L8lw8sfCUdPoMQnmGdIr8ArXjSghZYNmvKgRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sifive.com; dmarc=pass action=none header.from=sifive.com;
 dkim=pass header.d=sifive.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sifive.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J6cDoOE+3VVVEUh7yArzrcotYL0J3qPFmMJAOMKlWyI=;
 b=a6g+uTQWAGRN5STP1xD3avZRQ+Xqis5fABGNeGje5h5Pv2oPpWDoOLC9bgI512L2p1c4NXGJbdnyLoCbjSZDrCDx0xV7zvBm4YKLcBzVIfdULYMeIhZS9wjZu2aX16PcwSCrjWLZr00sIWfnjgNg0p+HvIutEbylF++hFWizbO0=
Received: from MN2PR13MB3552.namprd13.prod.outlook.com (2603:10b6:208:16f::22)
 by MN2PR13MB3309.namprd13.prod.outlook.com (2603:10b6:208:15a::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.14; Mon, 27 Apr
 2020 08:25:43 +0000
Received: from MN2PR13MB3552.namprd13.prod.outlook.com
 ([fe80::9926:3966:5cbe:41e7]) by MN2PR13MB3552.namprd13.prod.outlook.com
 ([fe80::9926:3966:5cbe:41e7%7]) with mapi id 15.20.2958.014; Mon, 27 Apr 2020
 08:25:42 +0000
From:   Yash Shah <yash.shah@sifive.com>
To:     Dejin Zheng <zhengdejin5@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        "palmer@dabbelt.com" <palmer@dabbelt.com>,
        "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: RE: [PATCH net v1] net: macb: fix an issue about leak related system
 resources
Thread-Topic: [PATCH net v1] net: macb: fix an issue about leak related system
 resources
Thread-Index: AQHWGwEgfqTJAKgECUicL9uwKoHGBqiMpFLw
Date:   Mon, 27 Apr 2020 08:25:41 +0000
Message-ID: <MN2PR13MB355263F89012F7D742DAE5FA8CAF0@MN2PR13MB3552.namprd13.prod.outlook.com>
References: <20200425125737.5245-1-zhengdejin5@gmail.com>
In-Reply-To: <20200425125737.5245-1-zhengdejin5@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yash.shah@sifive.com; 
x-originating-ip: [120.138.124.57]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e14d683b-d13b-4ad4-87f1-08d7ea849393
x-ms-traffictypediagnostic: MN2PR13MB3309:
x-ld-processed: 22f88e9d-ae0d-4ed9-b984-cdc9be1529f1,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR13MB33095DE22B3D3BB3D2FCC7D58CAF0@MN2PR13MB3309.namprd13.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 0386B406AA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR13MB3552.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(346002)(136003)(39840400004)(396003)(366004)(8936002)(7696005)(6506007)(53546011)(81156014)(186003)(33656002)(110136005)(54906003)(71200400001)(8676002)(316002)(5660300002)(86362001)(2906002)(26005)(55016002)(66476007)(66946007)(76116006)(478600001)(9686003)(44832011)(4326008)(66446008)(52536014)(64756008)(66556008);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: sifive.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: A66dnmiLkSzNkwBDR0CqVWZPt+yEf/dE2Q4XJqcERgxZ9Wn8/i9dBj0fhFPJPqgwo6BxfmLHOtR2q3jPoYgpnZPOnGNkwu3AoirbXitE1xGbg9BTZU53QLjzgCXFzebuaKUVFBIEWPWH2wIlgeRX7sphFqw0yefDk82bEeUjKX/ZujPvOPf+Y5XKWkTdS0JxAcf6/cs+SnDQ5G4J4yT8BZ84bh72Qltl50KvWFBh3r0WO/lW7RJa1QNIxOM/IyriP2m7Qnsk01/0qV1banKmlnh1xgKxOXhYl3o/7qJVgcSRu6KLav4oOpwZrVjV76r70WMiYH1c6NRkI139/iw7fN1jOguRj8SVj45JgBSRT+eJ3MEllKvBpSfeKEnxbTq+aTD34IVm0/Om5QWr67GqO6g31W7ROvdAKNBKzUvc1CeZu6GvwiXXNzNWSUjmruqL
x-ms-exchange-antispam-messagedata: eCLwM2W88UWMRJ5ICPAhaixTV+u2k3mmKkzzIW6gZPZ0cuSnF76+0a1+TVEreazNxe1KaaSVimeP7/MlfTyVSBuL1CpME7V4VbQrMh5nYxgkyDKTHQt8yoYTD64B1VUwW2xvteLM+NZIPGDC2IWiDK+suHgGVkeOT9OjGMUmnKHNGufgun+bPzeeCJlY6fy76EUckY3UTUUwIBSs3S6Me6BkePWQ0RMkXvqce1EDwTVwRGHKbzqHIVpCGXf/P6uTfUfPq6P6dHQORcoPg3ii+QTbRghkyB6mirJiSi8vh+6niLgUzDXOl9KD1q9glPFfRisz5G6ymzpRamcmB4Xsu32EH7lTUZT/SdIJQrlvkRgWPxM4w4fsvstv1TNRCqTv64raE0E9ssGWGC7WzvLvOHasKzH7UyjrGfr7r/HuN9lVmHjHPopy/fH3a5xufrfSgm6y9NNl9CE2gv2t/95DegyNN13dQLm3RI1oGIRAeto+BC81rz57lg5V7xGjdGSeEJtXvnVzH7BediNaK0+k8U1w4UDWxJHzOB4VKQZndfuGwiXT8/emnprP5FZ6S/BHW3eSQqPJ4AjYW3NgG+BgYT1qZQXDibzFHLEEpe7F9tLgXp5gKiiWU40tJIkQ2eo4nyyKcNZxNgot3jujf6yluvsY7G4x0k7kdair4bw4Z0K0rr2g/zt7AhDxGAKvCOks2pKWehO9LR77kJP3jRxkZZD/1Lb74jvDu1X5XrMZpgJFHPoBm0BgThPAjcXAQTirihTfSmcqmkj0dWUaJ5jCdgeLI8uj7QxLMq6JsyzEFBw=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sifive.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e14d683b-d13b-4ad4-87f1-08d7ea849393
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Apr 2020 08:25:42.5298
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 22f88e9d-ae0d-4ed9-b984-cdc9be1529f1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cX74N57vdGxpgQ9I4jvk/pap/vjL+GWduhT6BlLl5zThatH1eQXodZRZcuC4k6gGJmaiGnLr0cyFgoxVQ3eT2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB3309
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Dejin Zheng <zhengdejin5@gmail.com>
> Sent: 25 April 2020 18:28
> To: davem@davemloft.net; Paul Walmsley <paul.walmsley@sifive.com>;
> palmer@dabbelt.com; nicolas.ferre@microchip.com; Yash Shah
> <yash.shah@sifive.com>; netdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org; Dejin Zheng <zhengdejin5@gmail.com>;
> Andy Shevchenko <andy.shevchenko@gmail.com>
> Subject: [PATCH net v1] net: macb: fix an issue about leak related system
> resources
>=20
> [External Email] Do not click links or attachments unless you recognize t=
he
> sender and know the content is safe
>=20
> A call of the function macb_init() can fail in the function fu540_c000_in=
it. The
> related system resources were not released then. use devm_ioremap() to
> replace ioremap() for fix it.
>=20
> Fixes: c218ad559020ff9 ("macb: Add support for SiFive FU540-C000")
> Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
> Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
> ---
>  drivers/net/ethernet/cadence/macb_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/cadence/macb_main.c
> b/drivers/net/ethernet/cadence/macb_main.c
> index a0e8c5bbabc0..edba2eb56231 100644
> --- a/drivers/net/ethernet/cadence/macb_main.c
> +++ b/drivers/net/ethernet/cadence/macb_main.c
> @@ -4178,7 +4178,7 @@ static int fu540_c000_init(struct platform_device
> *pdev)
>         if (!res)
>                 return -ENODEV;
>=20
> -       mgmt->reg =3D ioremap(res->start, resource_size(res));
> +       mgmt->reg =3D devm_ioremap(&pdev->dev, res->start,
> + resource_size(res));
>         if (!mgmt->reg)
>                 return -ENOMEM;
>=20
> --
> 2.25.0

The change looks good to me.
Reviewed-by: Yash Shah <yash.shah@sifive.com>

- Yash

