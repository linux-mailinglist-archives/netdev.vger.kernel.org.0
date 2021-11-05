Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0771C446AFB
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 23:42:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233575AbhKEWpV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 18:45:21 -0400
Received: from mail-vi1eur05on2119.outbound.protection.outlook.com ([40.107.21.119]:32992
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230400AbhKEWpT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Nov 2021 18:45:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L8cBgBz9NPQJ26786nRS0eetdXGOfwdR6cnxgCK0Bsjnw7/HAzOjsbzsFGlch/2QE7aJGwHV/lDGE4J7P72vrV0NkWgmKIxCBCQZ2tKn8gfiv77/yZ5v7xNAhrkggW7Z49SFdvJ2y0sG3KYOzTJ7uPWoYx5pO79aRszWt3gqA4/vuA+TZg/92BXZQ0DSvM0wNRI6+2IZ417PbjK4J+NEGxW2BVKM9J/q59mdf/3a0iZc3I80FxZ2HEc6fw3MvYVWrFkWwdLBqiPFwN/Ae4E0+Y75eXswWVZJ/YjNmMXBumH5Y+GLxRZ3G5e2wPsNYtbgOduFVjz6WIFVb9Dt0FA4Wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=38mp6XKa9TBRurRNeGN9gXcnvWQuNW68BmpNZ9KNvrE=;
 b=Wr+pE3uBPmYlpRRrVLhADRkwfN+9epoOUqT4sfcIhD3VRi17fNCOVgG52gbA5rw4DW5HpJlM3KiBAsIiycnW8O1VtVgXw/LgXi/wUpaXnpge9gyjaJrY3S3S+7gJJjqHSmimz1yV0v8tomzgUJObkjLW8fGKUcIoIxzsfF6tFfIIT5e4sO6IWu+/V0epCzg5VGCfUHL/f7X/zoEa27jZ0k7TWRxJci0LWZnBTBcduLtQ1D2LOGiW4CBGnQLB9jI/t0v0sQ97VQ1eRTClk5fOiwwggKeFQ1uJjVuc0eyWhGwrX7oCqv7+5u0xcD1oJuEP1CyiPS31Xk2NfxCvn4SwXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=38mp6XKa9TBRurRNeGN9gXcnvWQuNW68BmpNZ9KNvrE=;
 b=oyVTARNKYdkNPohYpjSNVpiBvV9Wcz9Bb4MTLsh/HvGx1ucRKhWxlROEL5oWQk4EM9R7lr+K3hEI3H6kxezXyoGOgCygqQTLgM2Fc4QXbesLcIEYMOBMWWwFeC6So+/Fr3zinFOLszXRWjUDHtgMSoNlgqce2jpTss7sadPQxNQ=
Received: from VI1P190MB0734.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:123::23)
 by VI1P190MB0448.EURP190.PROD.OUTLOOK.COM (2603:10a6:802:3a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.19; Fri, 5 Nov
 2021 22:42:36 +0000
Received: from VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 ([fe80::a1aa:fd40:3626:d67f]) by VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 ([fe80::a1aa:fd40:3626:d67f%6]) with mapi id 15.20.4669.013; Fri, 5 Nov 2021
 22:42:36 +0000
From:   Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
To:     Guenter Roeck <linux@roeck-us.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Andrew Lunn <andrew@lunn.ch>, Arnd Bergmann <arnd@arndb.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
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
Thread-Index: AQHX0mUuVcB8vzXrnUiS928altpGN6v1XrOAgAAmYDo=
Date:   Fri, 5 Nov 2021 22:42:36 +0000
Message-ID: <VI1P190MB0734F38F35521218A02CF2048F8E9@VI1P190MB0734.EURP190.PROD.OUTLOOK.COM>
References: <1636130964-21252-1-git-send-email-volodymyr.mytnyk@plvision.eu>
 <8a5d8e0c-730e-0426-37f1-180c78f7d402@roeck-us.net>
In-Reply-To: <8a5d8e0c-730e-0426-37f1-180c78f7d402@roeck-us.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: 70113553-262c-57b2-381a-a98b2d924c0d
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 938aa84f-3c3e-41cd-6348-08d9a0ad90a8
x-ms-traffictypediagnostic: VI1P190MB0448:
x-microsoft-antispam-prvs: <VI1P190MB04486ECC79BB0898E96570F98F8E9@VI1P190MB0448.EURP190.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pM/EIPhmlwr1VxVE153ED/YUGY3aOEmLgQ4rC5/OEC4uCG6q/2ibfVIvR5tBIu+B2bnsfIGDf3Qg4wFvTwJtUeBznlfgc3BXBrCnRM6hGeuB9D1JWKih4vDNKLGRYlOImDWYoAyJwCB+0Rpjv206o7aDQQ4veL73wJ0J32ceiBPUHKqd3XEVvAeKj1jx5WSfRAFNFttj+ASO70SeMYcgLCIA6C8W3fFmnG14EBhOoOKPtCZjL59rhfRIH7NvJySw0rBFcubAySQ0uhOfb4wRqJ8P5F1kpNR/48B1jDip/DV2uziJ0Wfmr/60kakCnjXiTK+FXlYxClx7Wg/RiZ86nyvNqXJqbljZUixEWtP9G9YG/77E2XElPR7ptxYDsZGmfaBNgmZnkN3J3TaucCrR7LMz+vbKTeJdIn2t8MAy/gcGgRwwkitsBWDtaMyuKLhMn7wKdjDmR//WSnYFHYbUu1hoG7DsdSWfYUHxd0CCVIPsk4lYQ2Q5ZXd4mnBHEXKoodhoFWPGHr9CkAOLF8eXJVxDT2kHJFzivU/abk73qxV+HVrI9f7zrHVzWkArl4RcPn/PzjRSS3jEixZAYQDswNzXTOWi8MiJVqJeP6fwOCN/G74uxj46JnyeRE2aZegmT1PeJt+llMlShFzJoIMnQ+iMwfAM/bw8ehnGbPEp/QyNn+5YrfmFCcRDdLzI53Kgye4FShORZh7sPBNJToRhxw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1P190MB0734.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(39830400003)(136003)(396003)(366004)(346002)(376002)(110136005)(71200400001)(9686003)(54906003)(66446008)(66946007)(7696005)(38070700005)(64756008)(55016002)(508600001)(6506007)(91956017)(66556008)(7416002)(76116006)(66476007)(26005)(86362001)(316002)(8676002)(44832011)(8936002)(5660300002)(122000001)(4326008)(2906002)(38100700002)(52536014)(33656002)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?vwbkr5hExQruqbm+ATLyeJZUTAxQDv00mNTeZ4VjILXRTUDG0G5I6uN45i?=
 =?iso-8859-1?Q?47gWqOqDEPMork3k35tc3af9hKY+BY7zRePbYTDeXn8o11AoGtDUa5EpUO?=
 =?iso-8859-1?Q?z94hc0++YzijlOXMtScUKRxujRl1QI0x8i+mAeFfiOyQBHFheWWXU8eq1m?=
 =?iso-8859-1?Q?RXN+ljVc/rVPN0DS6vzQc50FNK27gcBJqsRxY0fHa7mcB36umHGCMtbMmK?=
 =?iso-8859-1?Q?Okbh+ahpdP3/290PZazsjsmOE5u6B6BSUEkzJIq6003WC1+zjfhCW39awY?=
 =?iso-8859-1?Q?Oj6O/PokyD4ulcuoEFq05zmmTJbWx9AVZd0a6ZNgdRlub6yAp/VLd/xqQ0?=
 =?iso-8859-1?Q?JKV7AlMdQU0shQUJR5Y5gg7DVhsTZtRix+oCN1qxeKz9tHtA6Q6IKG7nOM?=
 =?iso-8859-1?Q?o4lw2e1ToqpCI+jnOlIB/8YoRDxqsgE+iUJZfXapSXnWLwarOchz3HpWuX?=
 =?iso-8859-1?Q?c+5Y6RBrFpdiQ4BD61QHCA8sj5uha8FULo+S91zuUj8f/dkQ3WiSaUMp1m?=
 =?iso-8859-1?Q?588/LUqPejcK5UTf9qZnqbS2cnZ69odH0SymJFXx6nggmZpfnRrgX6Gq3I?=
 =?iso-8859-1?Q?KpGUXzDZTtq/WcRcU77Z912T7/olniJvfZX9tcuuJ3QsgQSkTHxA4mOXo+?=
 =?iso-8859-1?Q?58pevNFbphnftHp/npvfQUf1f7B97lj99X3pkaAI2usy1j36INTGpClDSq?=
 =?iso-8859-1?Q?ZXoLtCi/0EurDvJqYPynyFkVdYmxp4AYBjKU9leOzjj/G6CEe19k/KIV5s?=
 =?iso-8859-1?Q?fa1+VvaMkXbrUl9tQbmLbSqdw0K1alMmLyarc0Lv7xFgwvkaZ5ZomF2zyV?=
 =?iso-8859-1?Q?DbvCLOjLZaNbAN7/epaDJxPT5rt1NMrRkhG2oRBwaNFByWS0+3HxVriMcH?=
 =?iso-8859-1?Q?JC6aW33cI1TaehIYVyFMR8e1l/+lcPxlgRgdmRUvilWm3KeDPp3vG5i4j7?=
 =?iso-8859-1?Q?5XUACUjTFmi3Ze9dEEGc3AffrAOxLXUbUy9zHMdD/zGNKQbZjED7a5ogT2?=
 =?iso-8859-1?Q?R8o/qMtGa29X6RcTJRgL7ryXjpreZojiEjd/A9tb76/HDrkO37aPv10opx?=
 =?iso-8859-1?Q?N+grOTPN9mTLOKX19XKj3LIzaYCwUZj2ckgHzBmGUIsWrdhahUFXte/wA0?=
 =?iso-8859-1?Q?xh6zluhtQ1nrirIulfKw29odnLNzVaIaswhINvLdYU8LQGpUW8f0ghqupD?=
 =?iso-8859-1?Q?jF90CRz1I5ZQalEayhGKP+SAY+COk/+g1f9JSYs31wDlLoD87+sgQsFCZd?=
 =?iso-8859-1?Q?IYcDuPMt/P3TINcPKNPSPebKJBBEkgwZoRvkp1LBpMl1q1YowgOWgeD+OL?=
 =?iso-8859-1?Q?KfPS5UFFBR0U/8KD0NtL4f/CenYds8rDUAGhqHQNQ5UbBqB2wW7ez6ulkX?=
 =?iso-8859-1?Q?7ANVblo6TUaeGMrohLSHOMr5zAu2RYDlE59QJSU4/nXcsjEIkYcDK2OxEN?=
 =?iso-8859-1?Q?8lFBXDFPH/Sfu82AqDtwzqN4UPvORdDzHts7kt5VCV9wnxdYSr6drrM55u?=
 =?iso-8859-1?Q?zRJT+4++zcFvsF5qELAST23ki4V4cfpMxbIWPmvUZFogZujwGV9bGMvEUR?=
 =?iso-8859-1?Q?53Y4xAq6aRFBDsTmyV4kNHfx3DGS+e8u1e/fNWKzUh4c3DCwREcIjh3pQa?=
 =?iso-8859-1?Q?UGksB6t1mFif+nB2R+CwDPIMf6xc7W95fI+Z1EuE8ZTsXBYTrj8ciExGd0?=
 =?iso-8859-1?Q?RWDH8TCnA2nZTI/racTLVB1QwkUM2xFcAI4RrbNX?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 938aa84f-3c3e-41cd-6348-08d9a0ad90a8
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2021 22:42:36.5291
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xavZHncxHgGoxfFhx6tdy4Fpb+/+Pd9GkqJ7brrLrIECMjUHtHUvhflS9yry9L96ccmdVpKGUEA0zEOCGhDSl7Tq2DghY18Sdb0TkcyqSp4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0448
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>=0A=
> > From: Volodymyr Mytnyk <vmytnyk@marvell.com>=0A=
> > =0A=
> > The prestera FW v4.0 support commit has been merged=0A=
> > accidentally w/o review comments addressed and waiting=0A=
> > for the final patch set to be uploaded. So, fix the remaining=0A=
> > comments related to structure laid out and build issues.=0A=
> > =0A=
> > Reported-by: kernel test robot <lkp@intel.com>=0A=
> > Fixes: bb5dbf2cc64d ("net: marvell: prestera: add firmware v4.0 support=
")=0A=
> > Signed-off-by: Volodymyr Mytnyk <vmytnyk@marvell.com>=0A=
> =0A=
> The patch does not apply to the mainline kernel, so I can not test it the=
re.=0A=
> It does apply to linux-next, and m68k:allmodconfig builds there with the =
patch=0A=
> applied. However, m68k:allmodconfig also builds in -next with this patch =
_not_=0A=
> applied, so I can not really say if it does any good or bad.=0A=
> In the meantime, the mainline kernel (as of v5.15-10643-gfe91c4725aee)=0A=
> still fails to build.=0A=
> =0A=
> Guenter=0A=
=0A=
Hi Guenter,=0A=
=0A=
	The mainline kernel doesn't have the base ("net: marvell: prestera: add fi=
rmware v4.0 support") commit yet, so the patch will not be applied.=0A=
=0A=
This patch is based on net/master, so you can try the patch there.=0A=
=0A=
To apply this patch to mainline, the following list of patches should be po=
rted from net/master first:=0A=
 - bb5dbf2cc64d ("net: marvell: prestera: add firmware v4.0 support")=0A=
 - 236f57fe1b88 ("net: marvell: prestera: Add explicit padding")=0A=
 - a46a5036e7d2 ("net: marvell: prestera: fix patchwork build problems")=0A=
=0A=
    Volodymyr=0A=
