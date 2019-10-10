Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F35FD211F
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 08:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733012AbfJJGzJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 02:55:09 -0400
Received: from mail-eopbgr80081.outbound.protection.outlook.com ([40.107.8.81]:40695
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726840AbfJJGzJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Oct 2019 02:55:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U2Axo0tBiuzEgKIHAh7bh/oSPClWx2K6H4Z0ZuFqwZ4ie9nRGvosB7lluW9wi1Eo2LqG1wy5WOZtLoT3qSkt9HALaMMlzuCJAS1UDVOSUy0zM5DEAWnzaEJ6XacZI8jkLqzlwzBttQfUvC/gsrPbWn4lyvXmjE5XV11ljMiDZz+dm5aV1ycmyZgAv7NkXEyxabj51DUCSHZVilVR6wdHpwQxB3uZqv45KsVTcrvhmKdF5j+hLifu+E9kYGyZQA+qZCU/G0Y7oeeGBVNnlns4dXpEsYThle/6ARAY+Ceue0myZQwSzWIMfBHTB2hOLSzaVRoegyd/zJxIpWuhX4JD5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RNAsWnubDpx7pJMgSstDQIOwJ0Xw3RLpk6m684MYQic=;
 b=WT1zVhBB7Ta+bxMTniSks7EXIf8T9tyhSICuyhSBsHr6VQ7PW7pOr6uwwKD7GapuSIDByMqTt+s3odEwPw+nTKPe2LjFH9GGFp0S+UlG1ZmHk7FoRG5nkXvNXpe1kOzCFC+1DzhtQ8ibsaxvvVzQw9inpHPKRFifqHRuWUgrAfU9WJCCTkUuZh0QjD57tamAJ1NExPchjtJ3woFt7N6znSN53y7fdkiSX2w+kdBg9EG3Iwi4cKNbjUo32G4kh7vJeG5YmUThEbneEhsMg65GzthlL0wY6EhcNxG0A2r0/lrtH7i7QAQRtLW3P5qcBWfA4cvf7iy9EL0fi2GMNC1ZmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RNAsWnubDpx7pJMgSstDQIOwJ0Xw3RLpk6m684MYQic=;
 b=Ke7VzbDmH4aC4LiMocR3q2H6W4CVBhslEH0oAmD/Rrxs+MY8kh19UV72otKob0i5r9mVp9h+dfmxte4S72CXZKOdgy4bmXx2iR1+34qGu9VJeEcQrmgJ+4KL4KOgjxLFI5ltHlflbhjaEQT6ohekAo/8I+houRGG4kG4qzYw2wI=
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com (52.134.5.23) by
 VI1PR0402MB2925.eurprd04.prod.outlook.com (10.175.24.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2327.23; Thu, 10 Oct 2019 06:55:05 +0000
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::9024:93e:5c3:44b2]) by VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::9024:93e:5c3:44b2%7]) with mapi id 15.20.2347.016; Thu, 10 Oct 2019
 06:55:05 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Anson Huang <anson.huang@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "andy.shevchenko@gmail.com" <andy.shevchenko@gmail.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "swboyd@chromium.org" <swboyd@chromium.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     dl-linux-imx <linux-imx@nxp.com>
Subject: RE: [PATCH 1/2] net: fec_main: Use platform_get_irq_byname_optional()
 to avoid error message
Thread-Topic: [PATCH 1/2] net: fec_main: Use
 platform_get_irq_byname_optional() to avoid error message
Thread-Index: AQHVforZmuVq6TTHS0KnaARU9zwWm6dTcdBA
Date:   Thu, 10 Oct 2019 06:55:04 +0000
Message-ID: <VI1PR0402MB3600008424832B5A8145F3BFFF940@VI1PR0402MB3600.eurprd04.prod.outlook.com>
References: <1570616148-11571-1-git-send-email-Anson.Huang@nxp.com>
In-Reply-To: <1570616148-11571-1-git-send-email-Anson.Huang@nxp.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fugang.duan@nxp.com; 
x-originating-ip: [119.31.174.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 11b8935c-3364-444b-a6e4-08d74d4ec7c4
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: VI1PR0402MB2925:|VI1PR0402MB2925:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB29257B3CE5E559C5042FB696FF940@VI1PR0402MB2925.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-forefront-prvs: 018632C080
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(136003)(396003)(366004)(39860400002)(189003)(199004)(229853002)(446003)(7736002)(66066001)(55016002)(11346002)(64756008)(76176011)(9686003)(7696005)(2501003)(15650500001)(66446008)(14454004)(186003)(478600001)(305945005)(26005)(74316002)(486006)(476003)(52536014)(110136005)(6436002)(71200400001)(71190400001)(8936002)(81166006)(81156014)(66476007)(33656002)(86362001)(14444005)(2201001)(4326008)(25786009)(6506007)(8676002)(5660300002)(66556008)(3846002)(316002)(66946007)(76116006)(99286004)(6116002)(102836004)(2906002)(6246003)(256004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2925;H:VI1PR0402MB3600.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kpGAF2tNjCoYpYpXOO6B71ajjQnlhVkL2vVUkWiRCsfFXwR1dDNuWcl14jFZJVpGOmqkulDTpCosemMh6oJRwS5cCWcVHagikAtYVfxKafDevHXb3TXa7r+KOy7sVAh4BuVI18Vrriqth1T1/EUK2YbFmfteb+t5ViWHfMxIsRy9f3jogN/1zOriXa3+/c0jTHf+fUltUvA/05x1pjc/qY3nJ8UDwoUZgRBjUKYsJbx1+evO7OVN/WzHf0ROnJNZypqvu9s0ZgvbELsdrB78eNeXfSK5CI4+OzFJPiuxsL5KRBN+Vnrg7tW78Q9g2D5Ko7V6+v7jR5XD3e/hD1aTaiRLXbF629G/1wHt2kKN2ViJ+l7YJsuJ4CkirNmI4Ub2t6M4Lcjpv5HHJU+ErXleAyOVPNqMVsi3PAB5dG/9XOY=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11b8935c-3364-444b-a6e4-08d74d4ec7c4
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Oct 2019 06:55:04.9017
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ia1c0wh0DcycR2wwLaXyfnF/z/cMAlJYdj+1dmSi5g5eA+Tr0PkdSf/qS9/PL2mblm/0I3+VywJdjFiH0ckC+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2925
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anson Huang <Anson.Huang@nxp.com> Sent: Wednesday, October 9, 2019 6:=
16 PM
> Failed to get irq using name is NOT fatal as driver will use index to get=
 irq
> instead, use platform_get_irq_byname_optional() instead of
> platform_get_irq_byname() to avoid below error message during
> probe:
>=20
> [    0.819312] fec 30be0000.ethernet: IRQ int0 not found
> [    0.824433] fec 30be0000.ethernet: IRQ int1 not found
> [    0.829539] fec 30be0000.ethernet: IRQ int2 not found
>=20
> Fixes: 7723f4c5ecdb ("driver core: platform: Add an error message to
> platform_get_irq*()")
> Signed-off-by: Anson Huang <Anson.Huang@nxp.com>

Acked-by: Fugang Duan <fugang.duan@nxp.com>

> ---
>  drivers/net/ethernet/freescale/fec_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/freescale/fec_main.c
> b/drivers/net/ethernet/freescale/fec_main.c
> index d4d4c72..22c01b2 100644
> --- a/drivers/net/ethernet/freescale/fec_main.c
> +++ b/drivers/net/ethernet/freescale/fec_main.c
> @@ -3558,7 +3558,7 @@ fec_probe(struct platform_device *pdev)
>=20
>  	for (i =3D 0; i < irq_cnt; i++) {
>  		snprintf(irq_name, sizeof(irq_name), "int%d", i);
> -		irq =3D platform_get_irq_byname(pdev, irq_name);
> +		irq =3D platform_get_irq_byname_optional(pdev, irq_name);
>  		if (irq < 0)
>  			irq =3D platform_get_irq(pdev, i);
>  		if (irq < 0) {
> --
> 2.7.4

