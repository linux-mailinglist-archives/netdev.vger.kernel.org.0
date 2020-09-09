Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE0F8262625
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 06:19:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725840AbgIIETD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 00:19:03 -0400
Received: from mail-eopbgr1400133.outbound.protection.outlook.com ([40.107.140.133]:27072
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725767AbgIIETB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 00:19:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ik/n45hrKs23vPTBXsS2Fw/WSDMl5+J85xjH+oR+Ew+rChPHj7oLyTDb7gB52jljqEUWjUIKHKcLfNgDVuq+Dq12AefyBvJdpRDlqITHCzhwwxfOmj51wa81nZXLpCbF2U8zoHH1hdsJYaOVLg48WlQE5feTewk1cOA6Y9IwaBOv9kuCvDtAzGRAjmg32urLyxmuPdAHnBYWYLlmFRZwlFlgWWnyezQHg+MTDGhXZXTmkVolnflrlidkZ6O3WKrd395uycAsJSoB6ixBR7ozK03W2U/BRF7j8OHbOg9s45wOpBrQa1uAV9NDOk2j9DzNeGadKSyXduMbc0e9rv2A1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fR7POyO2asCK/C6XhZIrtKCKWa+Y1KO6NzI6I+TCewg=;
 b=GrZYG4PTuRRaGPMPlK8bzLR3eCKaYPjtdGACUJMd64sKI3ki40elro6gkPdP7/pQsvmxW8eFzX3YfYrF44OegKOZmfwmqIt/3rYbIqmMLSSeaf1xxiJ2K5g+ZOMv1Q2t3epOvPYVQCajw9UI0mw6t7WbyJubUrQQKv3np4lz9lQr2kF2Ulu9L13pR2/sYWsEhzCItT2bOSLfFuu3RTebzOBv1uQ6jH3Sc7CxKGziHXHdXra5GY4t4cj0vwbmYZAKx2+oqtvOi3xUaNPrcyTk5uhEqKEFxv5towztnfgfXbgeP6TRRywQOT3THYkUsYS+k6ohI7My/LwoG1dR92t5Dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fR7POyO2asCK/C6XhZIrtKCKWa+Y1KO6NzI6I+TCewg=;
 b=bVAYenLBCWzE6sObJ3Qc1oMVI7bcOtA5H8KLcpEU7hDtPaYSM+U899Di8TrrofnUqHdmKNBk+HNoprDTy0zvQ0yrg7zdgSnk3/Adsd0HCtnKHqnrMy9vJK0bnUFEN5lfMteNChMPvcDPQgfKyj5+PA0QJXnbFUd8Rah4Y0NIaZY=
Received: from TY2PR01MB3692.jpnprd01.prod.outlook.com (2603:1096:404:d5::22)
 by TYAPR01MB3646.jpnprd01.prod.outlook.com (2603:1096:404:cc::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Wed, 9 Sep
 2020 04:18:56 +0000
Received: from TY2PR01MB3692.jpnprd01.prod.outlook.com
 ([fe80::9055:525d:2d64:b625]) by TY2PR01MB3692.jpnprd01.prod.outlook.com
 ([fe80::9055:525d:2d64:b625%5]) with mapi id 15.20.3348.019; Wed, 9 Sep 2020
 04:18:56 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     David Miller <davem@davemloft.net>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
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
Thread-Index: AQHWhjuP2LLijL80K0uCr5i8hwAHvKlfpT4AgAAJ/xA=
Date:   Wed, 9 Sep 2020 04:18:56 +0000
Message-ID: <TY2PR01MB36921A4404E47B78C42CF2DED8260@TY2PR01MB3692.jpnprd01.prod.outlook.com>
References: <1599609338-17732-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
 <20200908.202524.1861811044367438406.davem@davemloft.net>
In-Reply-To: <20200908.202524.1861811044367438406.davem@davemloft.net>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=renesas.com;
x-originating-ip: [124.210.22.195]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 7915527c-c006-4712-5c36-08d8547777ec
x-ms-traffictypediagnostic: TYAPR01MB3646:
x-microsoft-antispam-prvs: <TYAPR01MB3646CAF8782E487F7E1B367ED8260@TYAPR01MB3646.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bafScpdD5B62PUxrwjsLeiIrx7S3o3xwJS2gQyze/TbI6EacyqtxrEWLU0GuHhbo2m/pprIa6WHJSWpQiSnO2fgCA/NEwk/kMwzzDY6RROd8kax9jJLg1U88Q5pr5j73Y6EE4+Kba2fEcPZIA6Pzm3d6rlWJAIPRXPJz1CBHbr2WIDAzTZO5rSj4ECqiyUy5I2PXdGzlY8LM9S9D4+jDFN3sSGhVg0bUcX9PNaZhr+e0vKA6KzXt1+w7Sz8HMILZiZhCqxBgBv3VPDeRhQ+hfw2r0a3ubdXi07kuuuzsuwlbNwmsBNFFkhiNXzrmzCp6NiAK3J3Z+wufmssfKZROzw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR01MB3692.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(396003)(39860400002)(366004)(346002)(55236004)(33656002)(6506007)(83380400001)(52536014)(316002)(2906002)(76116006)(9686003)(8936002)(478600001)(54906003)(186003)(6916009)(86362001)(26005)(71200400001)(8676002)(66446008)(7696005)(66556008)(64756008)(66476007)(66946007)(4326008)(5660300002)(55016002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: g48GJXAHC5vF+joF3O0I3aMxGLwvrEtS66jMfFd8DOAluriQ2ZHPwcO8DDoE5PVMSrw6deroyA8CNFNiYedWqvez5scy3t2h+sVg0NLkFwxUK3clSxMMrjR5emduFaTFiCtY9ZJ3401/7HV1vCucCXwRLIikzJwuO4kzAGQ520p/tBxygX447HbRrb57ydwc1Auf8Vw/uPFpMIhdtafIPowhZfmxzPg15pAC14F4aOzPGS1Y+7mb3nCklFKgBYjNm2p5YPAvhhSkKA9qvGDzGzy9IcyjEjcD0cFKqnLVdDItuuNVaEf5X5WzhG3/cxa/6tLeLuliM+Lwf59AyvPipTgs/bQRHQlEL12S2Zy7FbysqKZAghNgbxhGIO7S2Vx/5FxWlPaAg3iXF37yjNUAG73VWJqQA/J2Q57A03WOivK00850sFgUOJEfqt3IzMyE2rVafwvELeLC/XPjI3Vv9G1VuzWTPoTGoJmIt5b5WbN3Yi9VpFVeyr8ciVERq46N7g0cswF6N5gv+c2vzqDlgU55LU5IJ2N5A9b9XLnYfnndh3oc/l8+HT26An8qf1sqnLxkwZWNoHrFu+Yj6xSb8KxVHg5hGUdEhqpiQcSe1KFkLR02lyX/cuHqGIBCDQrqMs1tns8G4vlG2P26hzVniA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY2PR01MB3692.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7915527c-c006-4712-5c36-08d8547777ec
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2020 04:18:56.0946
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TP6rVMFfnLVnYejNzzFTrrGDyrKtncrXPJFqssNP0P3J1GuHe6yzowcn9tWhKxAz4j/Ra0kU5fNU1QhEuxp8dV14p0skPztlAK1itgkOLn57IezRCFCmsJVkFuP4FVj3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB3646
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

> From: David Miller, Sent: Wednesday, September 9, 2020 12:25 PM
>=20
> From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> Date: Wed,  9 Sep 2020 08:55:38 +0900
>=20
> >  Changes from v1:
> >  - Fix build error.
>=20
> When such a fundamental build failure is fixed (it could never have
> built for anyone, even you), I want it explained why this happened
> and how this was functionally tested if it did not even compile.

I'm sorry about this. I used two PCs now:
 PC 1 =3D for testing at local
 PC 2 =3D for submitting patches at remote (because corporate network situa=
tion)

I tested on the PC 1.
But, after that, I modified the code on the PC 2 again. And, it seemed
I didn't do a compile. Today, I got some emails from kernel test bot.
So, I realized I had submitted a bad patch...

> I'm not applying this patch, you must resubmit it again after
> explaining what happened here instead of just quietly fixing
> the build failure.

Since the kernel test bot sent emails, I assumed I didn't need to
reply by myself. I should have replied anyway...

Best regards,
Yoshihiro Shimoda

> Thank you.
