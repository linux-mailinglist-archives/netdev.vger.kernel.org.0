Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A591292C49
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 19:05:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730966AbgJSRFm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 13:05:42 -0400
Received: from mail-eopbgr100119.outbound.protection.outlook.com ([40.107.10.119]:53248
        "EHLO GBR01-LO2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730635AbgJSRFm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 13:05:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g/31AFP7StXScjcvG8+66SQ7s3y/TE/S01A+ajIrlxljohFj6IFT7SnfozNDrDvGzt0n2cGwYag+PsQT4ohL7pTU03XzCP5quDoso4oSuTmEEVY/YqvVNP7u4ZtkfjHDGuBZmtdkb+7ZwP017oaFcTWqH5De9gdwxxA8IZRzxNy6/w000tMSY+zWYIy5QboCBCnMhDxOuG4O2W2vkv7eeJhmai3TKbfYOQinxWJKCm+uMp3DrUdX8BVF39gZ1Ec29STXX/u4l0Wk4VfuGCvNueZ5IPWkyAgFTZnI0yhHGaIvJdbSo4aCK5I8pgvzfoivcJywz+VdTY8p/XGIZb7mYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HTtUG9eU5ogrq5BAeiKJyErNdUX0Nu8tERjDc40yu/w=;
 b=FIRBFUkl4EX2+WuskeM9eoYeO+zroFbRZ7m1l38cTY5giZbhSYLNuT5PUqU2e1OQiIj4eZ0YI7fEQfnr4+fCcjeafEsu5NDYfq7KOpoiDKrC9+6QCiXO/ggJXB8EZOWhrr6XpXKXHAqnEPNi3VMYLBgQSsAp3Esvriq0gR+aj6YeLWOrAl0QpB0UYjp9GQRVcCwRwtu06npkx5CAIXJRe+7JklhEb2Xp2YOE/b019e5H3c2OUXGCcyUQ+MAZdRB+guLu+uIQMBgLjH4mHFb4ps/iGaCeHS+jv//Ic4CV19Dm/YMb5QHC09XGuLoLgfwu0vqRP1VcdUbmSygm2GM5Mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=purelifi.com; dmarc=pass action=none header.from=purelifi.com;
 dkim=pass header.d=purelifi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=purevlc.onmicrosoft.com; s=selector2-purevlc-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HTtUG9eU5ogrq5BAeiKJyErNdUX0Nu8tERjDc40yu/w=;
 b=RoczbaYAL9ZioNi/egnRCFBYJTuutDM8s9QDNcUZGad3I535CYhVDDfvV4vdwfa4XnqCUatWnw4msScIdoV2ZRMhn1PZB+uCsTkpzPEs7tagjXGWddODJWe4jNlL1zBO46y8cmFkItjAtmLM4OUFv7L2Wa6KK3q3pdvi9aI5Sg4=
Received: from LOYP265MB1918.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:ef::9) by
 LOYP265MB2159.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:117::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3477.21; Mon, 19 Oct 2020 17:05:39 +0000
Received: from LOYP265MB1918.GBRP265.PROD.OUTLOOK.COM
 ([fe80::b8d7:c2a7:cbbd:6c2b]) by LOYP265MB1918.GBRP265.PROD.OUTLOOK.COM
 ([fe80::b8d7:c2a7:cbbd:6c2b%7]) with mapi id 15.20.3477.028; Mon, 19 Oct 2020
 17:05:39 +0000
From:   Srinivasan Raju <srini.raju@purelifi.com>
To:     Joe Perches <joe@perches.com>,
        Krishna Chaitanya <chaitanya.mgit@gmail.com>
CC:     Mostafa Afgani <mostafa.afgani@purelifi.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING DRIVERS (WIRELESS)" 
        <linux-wireless@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>
Subject: Re: [PATCH] [v6] wireless: Initial driver submission for pureLiFi STA
 devices
Thread-Topic: [PATCH] [v6] wireless: Initial driver submission for pureLiFi
 STA devices
Thread-Index: AQHWpfNnC69OUf5kyEqGJu+7PrU+76mfGBIAgAAIROSAAATrgIAAAmDX
Date:   Mon, 19 Oct 2020 17:05:39 +0000
Message-ID: <LOYP265MB1918EC2D808645CD0675A209E01E0@LOYP265MB1918.GBRP265.PROD.OUTLOOK.COM>
References: <20201019031744.17916-1-srini.raju@purelifi.com>
         <20201019083914.10932-1-srini.raju@purelifi.com>
        ,<CABPxzYJaB5_zZshs3JCnPDgUZQZc+XRN+DuE3BjGjJKsiJh0uA@mail.gmail.com>
         <LOYP265MB1918B212C618FF60333BFD85E01E0@LOYP265MB1918.GBRP265.PROD.OUTLOOK.COM>,<b92c72c591e6657ebb7f1984959607b3949ef58a.camel@perches.com>
In-Reply-To: <b92c72c591e6657ebb7f1984959607b3949ef58a.camel@perches.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: perches.com; dkim=none (message not signed)
 header.d=none;perches.com; dmarc=none action=none header.from=purelifi.com;
x-originating-ip: [103.8.116.148]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f490258d-2054-478b-d755-08d874513449
x-ms-traffictypediagnostic: LOYP265MB2159:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <LOYP265MB215937625505C045DD601B9BE01E0@LOYP265MB2159.GBRP265.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: handP74GqXYClccJKo6D5N3938jG5qJtPFzePUK2VDWk49HFYerS+5yWJ8AMbRlhl2lPWLIAFOG0TbRN1n84WI0NrotAc8e/oqKaXg1RmeHXm4hKlXNUbBW2qUpQFe5kEC37+IIlxZaRw0y5OxZH4IQBqy0jj6J67jdqNllU3Si85BbhtPA6RT8/SH60DO/EbrTVDS/a2O+o8fF293YIeCFlp5j3neqBU+PHIoUYo+yc5cHMVg57jG8VsWNZb6aWMtk6rzAS/sbRn3QcAAQYOBVcUXUIrem+0ZGb/NU/oN5stKp5e3u3JVuHauZSqzqNCzfHy+E+LSz7n7ckweCTrA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LOYP265MB1918.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(6029001)(4636009)(39840400004)(136003)(366004)(396003)(376002)(346002)(4326008)(8936002)(478600001)(558084003)(71200400001)(2906002)(7416002)(86362001)(9686003)(5660300002)(64756008)(316002)(26005)(52536014)(54906003)(110136005)(66946007)(7696005)(55016002)(83380400001)(33656002)(186003)(8676002)(66446008)(91956017)(6506007)(66556008)(76116006)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: pJRU94IbuMBh6KK4ig7cyEAd2FcRKiaVC9uULSZun7j3LYoEBExM/ajAkftFfEMoj6UZTKbmWeJ232JD6rKHKL+hdeFrW/njNH7fwXjLcejy3J/s6MEXQarYkS7JO0EfXKMuxs9xGMtcO+mhRYqYHIuyN1QQ67dNZEEMuyZYGp3NjiItFs0wUCepXw0C1L4SN/oedZwV/FctCcdvmIBfNW03R9Bo5WwMoEe0jQtZ0R5S4iwKXSoWT+ftPvEV1kEKx/riYEjcIXfDvs9y8R7AIDVy8qJjNcXMYfX9E+yypA5uzbGJMrVBlNbxWns2sOky+ZC1DDlsXJqm6mVA9lk+GTS0rCE643AVnx7hnFAdr+A+6ld2h1j4nqmORcgPUVMYYToW2+G2kiquJHUWP10E/DxCtGTY/kDMcvNdhuGbu53ZNKXLv6vUoaMY8XAIRlBK8PTb16LNuOVScpsxYtaPuQaH+hE6TWM71u5PHCtVMx379drckHeDJGvuqEwdBaa8j7QKQG1CxuMGLwbMbvhV+tA7tOA0RAn9+Nj+EZA/GdmkrrKO2XVjGuCbj0I1x9JRaWb36EU36hOjJ/YyP29eAjQZu37y0x7aneHh+xKiguzeGXVTF6jg43mBOFxXczA1SYd53ImuvDeyRnsdJSTYMw==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: purelifi.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LOYP265MB1918.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: f490258d-2054-478b-d755-08d874513449
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Oct 2020 17:05:39.0118
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5cf4eba2-7b8f-4236-bed4-a2ac41f1a6dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 09hl95Sn1gPXZC2TTua2uUZxI3oPZv04i92VToY2E/Zezd8rYj9Ny5qNwtfxbICJHovffaqSrdGkUevhEwPYjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LOYP265MB2159
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=0A=
> When you do, please start adding=0A=
> changelog information below the=0A=
> ---=0A=
> line to your patches.=0A=
>=0A=
> It's quite a chore to figure out=0A=
> what changed between revisions.=0A=
=0A=
Ok, will add version logs to future revisions.=0A=
=0A=
Thanks=0A=
Srini=0A=
=0A=
