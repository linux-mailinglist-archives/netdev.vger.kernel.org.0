Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1643263A18
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 04:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730822AbgIJCTL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 22:19:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730599AbgIJCRa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 22:17:30 -0400
Received: from JPN01-OS2-obe.outbound.protection.outlook.com (mail-os2jpn01on0727.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe9c::727])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68179C061388;
        Wed,  9 Sep 2020 16:50:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vdf666TLQ/hH5veNW2Kld0oRsc2cgUUHbjOMT4KvpeavOYG/DmqMzOaTvqmrfB9ZY+LZ1wc0GMborSZOjE8Da36+xRWPrwuEzmxymACGT6/jGfrbwJZWI5/FIjQ6CpMpTLEGbMkIMu+ikhYgPEq0zCNJVOlu1rAn2mzrWYL6P7w2XdVS9PKfwA2u0mDDjg4xhieP2G4FsFEbXcl48un4mzwNEfOFX782jgnVB2YwdugQgauXSiYFeoyT/n5DMjKU6ThQDmIx2YKidJOdRo8zcP09o6XqhGc9JpIgn94/HCEjfX6yi21ObuWCtSNGVpUfHIosm4LKiW6bqHH/6Jb9XA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zFpCCi4Y5MXS72XzcMn7D+9TyyiEd6K0qN396mdYLVo=;
 b=UZEmmsgrkY7CeI18c+w0tOpocVTmbto/vVw1hcyJngP8SVIL6kU3G86BMSumcDg+IZkzWCz7Y1QQxufFb95dtDWdO8BJt+3MROTJ2//aDU5C+15OpuBoxyAvSv7uGSN5tThKYGpzRpynbO3KfpnzICPfrb0CDgp3xvBhE6IZHL5d9bP7z0uY3HVEJuKiwT5Oifex+VHr83GBI1J3rYXrNh/L6x1EnpX0p7gpyn+boKQC7HNzr+klRUwG22AAhhO+87pkhr2WzYpisegjI3mjLiAUON2qHcJPuaM+oTFm38m7UDHHzq0zLmH+Q8YO2+58Ubqyo3PMuIKyMP+LfbrePA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zFpCCi4Y5MXS72XzcMn7D+9TyyiEd6K0qN396mdYLVo=;
 b=rvGmNEY+Vw2wlRjpw1vKtzTvbdUMjmC51CUSN9l4KhXfEsnWP1mZuuOnzCBL+7Fa41OGDSEcxv0xgSuOOymvG75qrPfbKYf8uhI+t1Sp15DI+CpqlL7aEOlLdbWW+9Y1TIxSUqYUhoxT14FRJ6rJkeOxjvWqgY0rs+k62ZPT3KU=
Received: from TY2PR01MB3692.jpnprd01.prod.outlook.com (2603:1096:404:d5::22)
 by TYAPR01MB4080.jpnprd01.prod.outlook.com (2603:1096:404:c9::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Wed, 9 Sep
 2020 23:50:33 +0000
Received: from TY2PR01MB3692.jpnprd01.prod.outlook.com
 ([fe80::9055:525d:2d64:b625]) by TY2PR01MB3692.jpnprd01.prod.outlook.com
 ([fe80::9055:525d:2d64:b625%5]) with mapi id 15.20.3348.019; Wed, 9 Sep 2020
 23:50:33 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     David Miller <davem@davemloft.net>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Jisheng.Zhang@synaptics.com" <Jisheng.Zhang@synaptics.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH v2] net: phy: call phy_disable_interrupts() in
 phy_attach_direct() instead
Thread-Topic: [PATCH v2] net: phy: call phy_disable_interrupts() in
 phy_attach_direct() instead
Thread-Index: AQHWhjuP2LLijL80K0uCr5i8hwAHvKlfpT4AgAAJ/xCAAKOTAIAAp/Nw
Date:   Wed, 9 Sep 2020 23:50:33 +0000
Message-ID: <TY2PR01MB36922D77FB05038E45E5180FD8260@TY2PR01MB3692.jpnprd01.prod.outlook.com>
References: <1599609338-17732-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
 <20200908.202524.1861811044367438406.davem@davemloft.net>
 <TY2PR01MB36921A4404E47B78C42CF2DED8260@TY2PR01MB3692.jpnprd01.prod.outlook.com>
 <20200909134638.GF3290129@lunn.ch>
In-Reply-To: <20200909134638.GF3290129@lunn.ch>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=renesas.com;
x-originating-ip: [240f:60:5f3e:1:29e4:1562:227f:bbc3]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: eddc4e8e-daa1-4c53-efa9-08d8551b2473
x-ms-traffictypediagnostic: TYAPR01MB4080:
x-microsoft-antispam-prvs: <TYAPR01MB4080740523624270B30FDAAAD8260@TYAPR01MB4080.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ppp+5+SW3I0fA6srCoGouDhq+Xx9+yHKXeiumPPfyVseJz5yLsZwC9oa19a/ZTc84TzQdrJpKqi/4pWegsV5bSQV7F8kMHRzSIfX5jpPRcOOK/SntqEa/wSd6Zzrbc6mvI0W9rWFwQgpxCzkVpnTKqRnEXC/VUkluWWiZ8mGlmejuIl4iApKaUDtp1avXWbiwi5V3WcUZAcEI1A563fiRVKj4k0x9FVxdr2u/xm6HnIKGNDSWoGGdOrNAJZVRwPA5878btnd2EMQguuixFMMdtLgcDC9jeYdlEps8TNlagtMGx5emMqaTL5OhYqT9daSQPRZb8Ijb6bm/nvVYBdr6g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR01MB3692.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(366004)(346002)(39860400002)(376002)(2906002)(7696005)(8676002)(52536014)(6506007)(55016002)(5660300002)(33656002)(83380400001)(478600001)(9686003)(4326008)(8936002)(86362001)(54906003)(316002)(71200400001)(64756008)(66556008)(6916009)(66476007)(76116006)(66446008)(186003)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: CYj3Yl1Ifue02F82HngnNOSInW/CwsNK+K+JTDOUpE0+z3X0+BZQVdFx5sgfl9sZrzhP0s8GWmGI0IJhqofxHsbyfzy2VLBEzGBKqBxLpf2nrZQc5eVvEoN+xkHHDq/NWOsVaip1R+P8McvVIFY5pwcagy89Tv19tFwvyNYwwz1nYM0XvOfxLHlU1kaFMCZPpSalNX0LTjZoyrL9LSUsZJDozCXgCdZGdcw3/0eA4e+e61CJ0DrH1OnSIRCUFEqEgdsKgMVQOW+UXwZrsIG8F+K+ltqzkZDtRbhQ69mMjuTJ9wHS7UU8ZKPMGt0izlXxtcwtx+zQWYIKz05tn+72fjuI2/vGDWa5P91Ht8vvsjlexOCDugUb6MlrlUne5AY+yUK3kaFwuQJeFV7yiiCJLgvlS6E1rBK8pwSYmxGS7Sx/HGOdKNd2HNR1JAVo4/8y12/QO6GETmKSc+lPI9mAKn3UtsA0ocuyViVztHymIPe2yXgvNZsBgx7yVBUg8PlAd5IC3KNM/GJt0mN5PAakFh1AI294aMh29agRcSxeLLFOn9YrVy7dzXyfSKnnerpO4nBneGpPcPgWf2orZg9UBENchvvFqH3920FR62Ydt31PIripU3fzpab5DdBsUQRU2kUVUPd5Qzyj1fpSJmrF3nZQraeoDZ4b0qIy8sqcUVlSCXK7ZCcWX1PCVxiTff4fX4Aaxq/jOUght2/OO0W3VA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY2PR01MB3692.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eddc4e8e-daa1-4c53-efa9-08d8551b2473
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2020 23:50:33.5111
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: clu7yClWJmY5QnF6upIeMQall6BZeBYKnkyqAlBtPf0pLYMJMnDiPXuCpvOxW/s+goYjAEaZW0gN0k2TxZL9cJ0TmH7gGXgZvB7imIwh1ngNSPdlXFX9YX39aJzmXfAh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB4080
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

> From: Andrew Lunn, Sent: Wednesday, September 9, 2020 10:47 PM
>=20
> On Wed, Sep 09, 2020 at 04:18:56AM +0000, Yoshihiro Shimoda wrote:
> > Hi David,
> >
> > > From: David Miller, Sent: Wednesday, September 9, 2020 12:25 PM
> > >
> > > From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> > > Date: Wed,  9 Sep 2020 08:55:38 +0900
> > >
> > > >  Changes from v1:
> > > >  - Fix build error.
> > >
> > > When such a fundamental build failure is fixed (it could never have
> > > built for anyone, even you), I want it explained why this happened
> > > and how this was functionally tested if it did not even compile.
> >
> > I'm sorry about this. I used two PCs now:
> >  PC 1 =3D for testing at local
> >  PC 2 =3D for submitting patches at remote (because corporate network s=
ituation)
> >
> > I tested on the PC 1.
> > But, after that, I modified the code on the PC 2 again. And, it seemed
> > I didn't do a compile.
>=20
> This sort of split setup is always a bad idea. Always do the git
> format-patch on PC 1 and somehow get the patch files off it, and use
> PC 2 only for git send-email, never any development work. That way you
> will avoid issues like this.

Thank you for your comment! I agree with you. I'll use such setup.

Best regards,
Yoshihiro Shimoda

