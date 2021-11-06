Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFB0C446D80
	for <lists+netdev@lfdr.de>; Sat,  6 Nov 2021 11:54:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234016AbhKFK45 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Nov 2021 06:56:57 -0400
Received: from mail-eopbgr150112.outbound.protection.outlook.com ([40.107.15.112]:8487
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229500AbhKFK44 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Nov 2021 06:56:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L+gjbYCOvgMIaxV2nmOmTjHnPRlmlyDhHGiQF8vGcVoGARfRkQZo6mlOW28ioydMVNLMKmFSCLs6hV5hrmMhCn2lh71NyWVdy1dKsT4rYTgc9oy8yH4e3hkjIuCa1Y9vcBr/2kF/G4GcvTsacW8pRI0S9/gfYo55daPSssP/HKFJ8IlDRMJw/ttQIjY0cHPuc6Coqh4tFCiSfJIsJ2m9oyryHA1Z0BAKwseTvxGEd6jvYp3a/GpFlpv/LpeF8iZsRmXzBuVR8hIIaXJ3QWDstU+HNCgrln5hwS5D1rN4ENczVBTWqhXmg3ZVxi1iBdmFpN7YOtXUDzL7RQP0dR6+Kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jM1l+G68XXIEmhSqcXfi+6uPUPVOjc4H3y2+AutcgxQ=;
 b=JhdgYLDY4ObWkCW44ecZxq7cSftPEq0N/uCTjrRtHT9+Tbgjn0gUylBIQbpxgOkHkLsHK4U3PkFFsXb+d95wUVyR3JoSPm0zPXzIt7hWPL9Nujbd55GmkEjheXyiNZuAlIDzeBS0VrizDsb91zOxYiOw+7/p10DZYKdRhuSMNQ2UnWj6pCg88L0o5tHwJP+aXWwe/d8xSZOnC8SHRvKPIrOlX2Gq5LC5zC0odWT3D9fEp25/3IpZfP3CnK9DXM10bdWwf3day3FAdRGGT4sN1NQWkNYUzRLT5QK/0s+5IYxUThafzOTU45ra5iUNQTxG5yPPAmvAa2dYEWIHvSDVKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jM1l+G68XXIEmhSqcXfi+6uPUPVOjc4H3y2+AutcgxQ=;
 b=rG7LsEBn9bhXT6KCXxZ+FFToldy3xBxeX8GAGAKGOjkbI77/n2Q/pFfXpTusNARCP38VpDXNu5dkkT3s7HmzfaAlWoG2mEI1Gi0WAanijSrTyV6eklByKlB2rQY2PCwI6VyN9mfpGgbm1SAF/TA7cFmIIsogh2J/p4tAlj1L2yg=
Received: from VI1P190MB0734.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:123::23)
 by VI1P190MB0477.EURP190.PROD.OUTLOOK.COM (2603:10a6:802:3a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.13; Sat, 6 Nov
 2021 10:54:11 +0000
Received: from VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 ([fe80::a1aa:fd40:3626:d67f]) by VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 ([fe80::a1aa:fd40:3626:d67f%6]) with mapi id 15.20.4669.013; Sat, 6 Nov 2021
 10:54:11 +0000
From:   Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
To:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Guenter Roeck <linux@roeck-us.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Andrew Lunn <andrew@lunn.ch>, Arnd Bergmann <arnd@arndb.de>,
        Denis Kirjanov <dkirjanov@suse.de>,
        Volodymyr Mytnyk <vmytnyk@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vadym Kochan <vkochan@marvell.com>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net v4] net: marvell: prestera: fix hw structure laid out
Thread-Topic: [PATCH net v4] net: marvell: prestera: fix hw structure laid out
Thread-Index: AQHX0mUuVcB8vzXrnUiS928altpGN6v1XrOAgAAmYDqAAKqBgIAAIrHY
Date:   Sat, 6 Nov 2021 10:54:11 +0000
Message-ID: <VI1P190MB07348408440226486210A5018F8F9@VI1P190MB0734.EURP190.PROD.OUTLOOK.COM>
References: <1636130964-21252-1-git-send-email-volodymyr.mytnyk@plvision.eu>
 <8a5d8e0c-730e-0426-37f1-180c78f7d402@roeck-us.net>
 <VI1P190MB0734F38F35521218A02CF2048F8E9@VI1P190MB0734.EURP190.PROD.OUTLOOK.COM>
 <CAMuHMdWXLU64wxnJe82ede0ALrQM6ie+7czy4WtUfGLDufWX4g@mail.gmail.com>
In-Reply-To: <CAMuHMdWXLU64wxnJe82ede0ALrQM6ie+7czy4WtUfGLDufWX4g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: 009cd834-0cb1-73fc-5c15-63763309b437
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bcbfe157-0466-44c1-9a04-08d9a113c424
x-ms-traffictypediagnostic: VI1P190MB0477:
x-microsoft-antispam-prvs: <VI1P190MB0477B241F27F96CEDB38D85A8F8F9@VI1P190MB0477.EURP190.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:2201;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xQ8Cr+CNmvQibExvTdtmVh9Sz+VOPtW7wz/Y8fYm0Tu8mTaBY83gme6wvrNxVyxdgTwAf6015Ydi56zKZAg1hg4q+FPJ+2rWrZJlrwdjcfO4jgLZuM0Tfbhs6XunyCYA1cVCKsIqdQ78bQpkJICRsAH6jGIPmf8HCsSLGzOgAJAaTG4GvyfbHBhwj/0pmUHLrGqOnJGvKA1TyHj1Zju7bnO2OS1uF6hh+TMD81rzRZPn/DTbkj5TtOt9NKYKzteCX871BmMUfWRxYt+pjZuWkSUHp1WwYo2Z1Zkv5xUnmqCjiOxBq3Xfsd7e3+O9qenqkbWODBOn3FukzJRFgqVMjE9CeG4layEqpG2TD5b5BTd/G3zOLEgSjIuUcnggFcjMkd8ua/q5Hl1ctEAVXtamEThAaJ1l/4nxRiRWDYAurz6ygUTW3z8zsu6G8c7eN90K+nz6OznwbzC6Ba7HWcie7edY3YZFNzSxPL3+dXtDzxvzCSbKrh1XiOhZp4Tv3tb5GuZ78y/Uhycy7wgA+e3yTZRZiJUq9OtA4br3C2RSWdM229dmJ0zL4N8qcaA66XlFwxk+mZHZ7OzX3HMwXRdJ0kQhdYdkYIW4SraqnXnxoAT+hG4cm4ZvTqAIZyfyHSS68ADGPW/nt3Hh36cIAR/32Y8lJGb3e+KBozIAtj2SPlFNzOxDwE/uZEvnnfDfzHXTWEXjodBNRDV5nbLhTiyFoZTcMXnz+Y+V/G039+GH8vO7t0aMZSFOnekwnEY4SAgDC+3qpiLYKX1ww0SjQCXRsIYLqObhKG8xqwH/i1URAXQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1P190MB0734.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(376002)(396003)(136003)(366004)(346002)(39830400003)(33656002)(54906003)(66946007)(508600001)(110136005)(76116006)(86362001)(186003)(966005)(316002)(38070700005)(55016002)(66556008)(9686003)(71200400001)(66446008)(53546011)(66476007)(6506007)(52536014)(64756008)(8676002)(8936002)(5660300002)(4326008)(2906002)(7696005)(122000001)(38100700002)(44832011)(26005)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?fVjJ5HCwKxVZPYePNDrFZHnb4+xqhl230+LbsXqSVuWR3nfinV1gcGkI9P?=
 =?iso-8859-1?Q?QUE7Vi0FUm8SKNFkGItq/aIZaVN389xk2P21I03Zipz1X/wKBM50m+itXo?=
 =?iso-8859-1?Q?FIp+xDyrlJpAHyBViynbaeTrSyFeCzWFa/sBveQp/aZQVSIiUJdaGn7RTT?=
 =?iso-8859-1?Q?3/IZV1DhI2f61DqBEWEiNd8tnhpHeXbxiM0LSa45vE369OAR+NKw5/1GXo?=
 =?iso-8859-1?Q?JQlUQcuOxqSNBqtwNBcOqY5sVVMLsZfgITEYzwJIv/t8ox3PN6MXywu3yj?=
 =?iso-8859-1?Q?mWmQHKOWpCskuhBj+2Ct94aeKZXq4wMDWka3IRmNawGYx7gt++oCQFYq9f?=
 =?iso-8859-1?Q?kqu9TVZ3PT5jNADQipSeiPh1gfZNTuK4zORI3TAT91UfVggjUfaaGjILrA?=
 =?iso-8859-1?Q?p1vbKS3KEhA2NH2h7yYe6avt55Ct7O+/G24OtklBomzGJedXWykKF+aRPQ?=
 =?iso-8859-1?Q?K1Sa8pDOlOCpbu/EI+ViFyc6rEKSg7VcO92Kj4EAAeSAKzGI6BtOgcRRuP?=
 =?iso-8859-1?Q?jkCaitSW6t23sZmqbclI59Spg1H0s9Mf+ZcbtSuaL4fzc/rdhdxGSoRWU/?=
 =?iso-8859-1?Q?YlNz1psXeJNonIIpXcI4+SC7fE/46QlCDJk4ZpIHlj65Bs8g/zUkiyt8Mx?=
 =?iso-8859-1?Q?3KFRzNjZzCD1f3dmpePhPkMH0PwoSrKdiSb8LPbOAVtXfb18VJI1dJQ3WB?=
 =?iso-8859-1?Q?egOlC+edIhXMt2pCjdXKY/nYhWy1iwidUFtfKESTqtz5jnZjcNYvnGmen3?=
 =?iso-8859-1?Q?pl9cQbIPmEb2EtMovH5NAV2NNOJBRLVDAkmxjUNOLLZL00xh7xdfPiq9y/?=
 =?iso-8859-1?Q?zZ2YApSOxg6Lg5RZcXw7nttHNmqIM28XUrbkcW7BGiYmuWLw3tBOzk0TQk?=
 =?iso-8859-1?Q?Ny6GVoLpDOJ1bVRliSNEwtIEsRzfehHC6JlA3/jfqHiYbCteHBHRK8XzHW?=
 =?iso-8859-1?Q?AjcvmBr1x5G0iA43gggS30c6ixJvUSisGQBPX7fDqM4KqLludVLvJBNv3n?=
 =?iso-8859-1?Q?ynqA2sTFh1XTM0GwrStNHLTm5ZKKOkrM/b6aFT2aJQsS9sCooRqA2NR4wD?=
 =?iso-8859-1?Q?LCr/6Xfk+tXATUz7ThnZy6VforhCpzcIUeNjaGMkJ7ZvbXvy8yfuRdvRKU?=
 =?iso-8859-1?Q?AxDYU0xyW2oGGxq46Ia/dfvZHgFdnU98N0mvP2glbFFf0rLBsuFA6tBn3i?=
 =?iso-8859-1?Q?Bl4oZ3GTEBTitXiOJbWfN+9AAlgiLKbyCm8/H/uuGqWA0/4AE0ofENbKva?=
 =?iso-8859-1?Q?JIPuokH5rwjQ4S+C2dNhqiDeUWkiZ6XjTAHcQwTjDwvnWBe3HnvQOjeLTt?=
 =?iso-8859-1?Q?lR/qqG0gNDyc+ISRhqZD+tLSOR9AaIoeLrxyx1vw7SzEsvRPIKGuT6o3Rl?=
 =?iso-8859-1?Q?rmSLaHQIejDedCRCoea0CBlLzG3UOKCxN0QyKWKZnwfBj+aDitPToYst8X?=
 =?iso-8859-1?Q?JOoJy880xK1EjWYA/WTXmm1/jAqe6zWkEL7JY5JeuDxJraXyv+TZUYwcet?=
 =?iso-8859-1?Q?T8MBKHGvUm8a86aCd6TbHvDexL/kxd8fUtC25/tX+gYFQLlwP06UJy0hl2?=
 =?iso-8859-1?Q?mqoSbwCgyV+pT4FF64HBZvvLRdqvdC/rmVbB2JN8/2lEMAuqd6zSJTrABc?=
 =?iso-8859-1?Q?8xvMJlkNDTccj/tnjawxro7emQJDjJiTTendxvYXelaZL02xEtjMWmBVBr?=
 =?iso-8859-1?Q?El4FvtCulmV5yETLGlq03Y1vXoonaePSmT2fS3XK?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: bcbfe157-0466-44c1-9a04-08d9a113c424
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2021 10:54:11.4051
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kojYbeSsLmuQf+Kyf/jTjsRXNVT5RKE/IBHpQuDOhZUV7A27r3Yhr46WdjgVzTKaKunAECUDFw5DNb61DYeVb+2fIQhaUyT59TJRZ16fnTU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0477
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Fri, Nov 5, 2021 at 11:42 PM Volodymyr Mytnyk=0A=
> <volodymyr.mytnyk@plvision.eu> wrote:=0A=
> > > > From: Volodymyr Mytnyk <vmytnyk@marvell.com>=0A=
> > > >=0A=
> > > > The prestera FW v4.0 support commit has been merged=0A=
> > > > accidentally w/o review comments addressed and waiting=0A=
> > > > for the final patch set to be uploaded. So, fix the remaining=0A=
> > > > comments related to structure laid out and build issues.=0A=
> > > >=0A=
> > > > Reported-by: kernel test robot <lkp@intel.com>=0A=
> > > > Fixes: bb5dbf2cc64d ("net: marvell: prestera: add firmware v4.0 sup=
port")=0A=
> > > > Signed-off-by: Volodymyr Mytnyk <vmytnyk@marvell.com>=0A=
> > >=0A=
> > > The patch does not apply to the mainline kernel, so I can not test it=
 there.=0A=
> > > It does apply to linux-next, and m68k:allmodconfig builds there with =
the patch=0A=
> > > applied. However, m68k:allmodconfig also builds in -next with this pa=
tch _not_=0A=
> > > applied, so I can not really say if it does any good or bad.=0A=
> > > In the meantime, the mainline kernel (as of v5.15-10643-gfe91c4725aee=
)=0A=
> > > still fails to build.=0A=
> =0A=
> >         The mainline kernel doesn't have the base ("net: marvell: prest=
era: add firmware v4.0 support") commit yet, so the patch will not be appli=
ed.=0A=
> =0A=
> Mainline has this broken commit as of Nov 2.=0A=
=0A=
Hi Geert,=0A=
=0A=
	Right, this one is it there. My fault, thx.=0A=
=0A=
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/d=
rivers/net/ethernet/marvell/prestera/prestera_hw.c?id=3Dbb5dbf2cc64d5cfa696=
765944c784c0010c48ae8=0A=
	=0A=
So, only 236f57fe1b88 ("net: marvell: prestera: Add explicit padding") from=
 net/master is needed to fix the build and to be able to apply this patch.=
=0A=
=0A=
Sorry for confusion.=0A=
=0A=
    Volodymyr=0A=
=0A=
> =0A=
> Gr{oetje,eeting}s,=0A=
> =0A=
>                         Geert=0A=
> =0A=
> --=0A=
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m6=
8k.org=0A=
> =0A=
> In personal conversations with technical people, I call myself a hacker. =
But=0A=
> when I'm talking to journalists I just say "programmer" or something like=
 that.=0A=
>                                 -- Linus Torvalds=
