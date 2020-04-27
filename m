Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9538C1BA7F6
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 17:29:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727077AbgD0P3e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 11:29:34 -0400
Received: from mail-am6eur05on2068.outbound.protection.outlook.com ([40.107.22.68]:6245
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726292AbgD0P3e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 11:29:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lYI//tsp2qLs8apup6/2gInaXmLyYLyUBK9K0eWlo7JtKw5or4bZzzZLW1OWwobSxF0dsNfxcuQrSO/A7JEfo+lSQTJGKAPRH9AZpv3CiJchimjIrLYSWBDJEw2KHeLpXwF+LcxPE9RApNpoDtN1BlbG6NZAm6Nywh6krAidVJHB5VaFP8V4uNj4myAQEmbCo9WVbt0clejRfh/QCZQa3Hp+gdwTshcfB6/HEaBuX7/rYlc/VOU7GIZqs2ex77f9kktU7vkcRbSP5DWSHvKyG+IBK9crjumKCIS0+LaeOQ/LusDnhCPM0l7O853KTLECAmFKuAtxQaB3bGpFnQ/X9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ppHxhTCIVN6acldVyS/z0JtVlUpYzT7pALHVIEqiGM0=;
 b=MR/0MtOPEstJvZaruAaBsUfXGZVw624cWM4rqztEPmJq8q+dQSB44cJUb6QWuaALfaDUjzS9/bUbZ3bP6yKMjER0uPJaXCoTq8dMWLzXstHxTh8cXuiX5g0q4UWjet+RfSmZZBtbevWzz0ftzuSemF6+otmQnjS0nauf/JKFk21nb+hi3Y+hPWcmkciseLd6YC5sCq7MOO2js80F3Wh7579RkOtx5kC2BvqcnWDpTWIHcHl4/2e6hYNFaTQdhMKl1sgG5PoaPuBv6m/ysNOmusNt6s3fbJi0W2cXa0KnXG1nnkGUhgfqkLNo0iykEfLfDA/hv/5jT2j9DDhwaFZZBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ppHxhTCIVN6acldVyS/z0JtVlUpYzT7pALHVIEqiGM0=;
 b=tAVbi3VtgKk4KOF4wM4AelavOR1ol3IrL0KzbWILcfO55rbVon9oPuxuXhp+qYIxAM0kIrNibaqmzEqQGYZit1FPxTANPHKlTq9fePEpAZP1rDsSRRe27aUf7w5LNtuJnFQUDVv5Jh++/Rcmvaq/osg1SJbXg7SVhLjONJwavVY=
Received: from HE1PR0402MB2745.eurprd04.prod.outlook.com (2603:10a6:3:d7::12)
 by HE1PR0402MB2876.eurprd04.prod.outlook.com (2603:10a6:3:d5::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Mon, 27 Apr
 2020 15:29:30 +0000
Received: from HE1PR0402MB2745.eurprd04.prod.outlook.com
 ([fe80::e802:dffa:63bb:2e3d]) by HE1PR0402MB2745.eurprd04.prod.outlook.com
 ([fe80::e802:dffa:63bb:2e3d%10]) with mapi id 15.20.2937.020; Mon, 27 Apr
 2020 15:29:29 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Leonard Crestez <leonard.crestez@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>
CC:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Chris Healy <Chris.Healy@zii.aero>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: RE: [PATCH] net: ethernet: fec: Replace interrupt driven MDIO with
 polled IO
Thread-Topic: [PATCH] net: ethernet: fec: Replace interrupt driven MDIO with
 polled IO
Thread-Index: AQHWHKdPfuK8So8PpU2iwth6Yyw7gKiNF5Zw
Date:   Mon, 27 Apr 2020 15:29:29 +0000
Message-ID: <HE1PR0402MB27454D43767F864FA3CA8D08FFAF0@HE1PR0402MB2745.eurprd04.prod.outlook.com>
References: <20200414004551.607503-1-andrew@lunn.ch>
 <VI1PR04MB6941D611F6EF67BB42826D4EEEAF0@VI1PR04MB6941.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR04MB6941D611F6EF67BB42826D4EEEAF0@VI1PR04MB6941.eurprd04.prod.outlook.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fugang.duan@nxp.com; 
x-originating-ip: [101.86.0.144]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b39b7b7f-b006-4ab4-96f2-08d7eabfc751
x-ms-traffictypediagnostic: HE1PR0402MB2876:|HE1PR0402MB2876:|HE1PR0402MB2876:
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <HE1PR0402MB2876965F6B9BC6A5105C27D4FFAF0@HE1PR0402MB2876.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2657;
x-forefront-prvs: 0386B406AA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0402MB2745.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(396003)(39860400002)(136003)(346002)(366004)(55016002)(64756008)(66476007)(4744005)(81156014)(76116006)(8676002)(33656002)(316002)(6506007)(9686003)(86362001)(66946007)(110136005)(66556008)(66446008)(2906002)(4326008)(478600001)(8936002)(71200400001)(54906003)(26005)(5660300002)(7696005)(52536014)(186003);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AXBUf0KgWqvKpLDdgbG0rE6h9vqsiMOAQahrRlE9Kh0FtnQoYhdw93WPoI3HpLuHBNTM5e78XHsYaCX8SAd93ENx2ap5Q5tkR3D/rptJAU/UCOdgW+5M/YI48R176tQYaVXcOmQwnBAcGAxO0yfO0SZWYADXe7G1I7dVBUUCJ6s80t0AvTV6Ug5TZYUUpnsDJVYE5jk11hyvZF2A5h00mMV2Iw/LIX+IigT2QXKR7XZR2NtV0wUV5WZLe1YlZPySj7CjQ2pL9sXB8zXtAZslIv9U7/H39ocsr0rTwEN+dppGSoD6uxYNuT0yP7OEayfSt9Qmq2v52Jl4uq+XpCYZBCJaLvqTAif1/6wXvEMB6lgH0/hRARV5XCnoq79TCsz619IMnqQnH2f1bVC7rT+VVpEYLmkzyo69vzKK1kZHuehb/7LWumo54xmuVgTxIweR
x-ms-exchange-antispam-messagedata: 1j/qvNl8A1KBJoQPgiEe+i1C0Helaw3e3qMxzrKQr71vMASdX85uOmK/VHz74bjIMskxLacbZqmxI2dcexmfrwHix1aQ5psnWHliwswOKUgQs//UCWGTSs6SBhcw0OQ3H4Y7SzhN6Njir4f5MpwC5kP99dst1Cim1dh5Rvwm2LWNR2czLTEJuBsPLvqlF+yvWFdX6naVWixY+DX/bop7w6gOBhaUC2TKPFT8Bdq1x5kHR/e6dHtmkC67UYKoCFcuXBKg4zpjd4jg6/OkOrgvJGtYI4Ap1+WLY9V7S/X5aOGBeQqpbvNY0/fPyqGWwUm2Cyl3xGkT+sPykborPy61cQBH279rJ9079XFK2QX0oEWxCN6sY7qrjSLKar3KRmlGDVJ7Oec6kJGJ+WzUCg2ll/kh2GHBIzNaKjbSbxUr3k/JYqc9IKK2y+dJhLv+s90LBtWRtMNYMi9Mq3htgZ+TPgZhWrtwdXHXtjCb9zVx+koI5kQZ848yPWz6jGBJWvS7T0mATjU3o5YMuK+M8KuNNI6gywc7w+V5zx0m/HVMSuhZHmODJF6Sp4d2ZN1owb8LZkqg6M8Qy34bjUy5cVWVOA27YhffcAM1zal8S7nltKFgnbJtyaJlaNv2qg9DH6Y+v9wuEECANvIryzWR34xmiBvErK9VWwkPG4NMoM6y5MYfyyq+DBAxK8EGnr9RPNXopFRN1MlubFuIwkTvTRXqdMCNyr1nQ9pQqKLr0jT8Qyf/6RIGhXtGAIIQDDlEs7R7ZaHVdDC0GGake8AFVSuWjpmRMyL1/MkDJzB37oFt0cI=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b39b7b7f-b006-4ab4-96f2-08d7eabfc751
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Apr 2020 15:29:29.8541
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hVjw9bB1zPmlV7UN2s6G4Y54/L2vZa+ntOzpobAnBbr3XjzmD0TucVxvq1Hfte2Q/3NefS4jgWc81n7cA/Qo+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0402MB2876
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leonard Crestez <leonard.crestez@nxp.com> Sent: Monday, April 27, 202=
0 11:20 PM
> Hello,
>=20
> This patch breaks network boot on at least imx8mm-evk. Boot works if I
> revert just commit 29ae6bd1b0d8 ("net: ethernet: fec: Replace interrupt
> driven MDIO with polled IO") on top of next-20200424.
>=20
> Running with tp_printk trace_event=3Dmdio:* shows the phy identifier is n=
ot
> read correctly:
>=20
> BAD:
> [    9.058457] mdio_access: 30be0000.ethernet-1 read  phy:0x00
> reg:0x02
> val:0x0000
> [    9.065857] mdio_access: 30be0000.ethernet-1 read  phy:0x00
> reg:0x03
> val:0x0000
>=20
> GOOD:
> [    9.100485] mdio_access: 30be0000.ethernet-1 read  phy:0x00
> reg:0x02
> val:0x004d
> [    9.108271] mdio_access: 30be0000.ethernet-1 read  phy:0x00
> reg:0x03
> val:0xd074
>=20
> I don't have the original patch in my inbox, hope the manual In-Reply-To
> header is OK.
>=20
> --
> Regards,
> Leonard

Leonard, I already sent out the revert patch to net mail list today.
Thanks for report this issue.

Regards,
Andy
