Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2B6D1BE315
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 17:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbgD2PtE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 11:49:04 -0400
Received: from mail.eaton.com ([192.104.67.6]:10400 "EHLO simtcimsva03.etn.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726519AbgD2PtA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Apr 2020 11:49:00 -0400
Received: from simtcimsva03.etn.com (simtcimsva03.etn.com [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B10F4A40D4;
        Wed, 29 Apr 2020 11:48:58 -0400 (EDT)
Received: from simtcimsva03.etn.com (simtcimsva03.etn.com [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9AAE7A40D0;
        Wed, 29 Apr 2020 11:48:58 -0400 (EDT)
Received: from SIMTCSGWY03.napa.ad.etn.com (simtcsgwy03.napa.ad.etn.com [151.110.126.189])
        by simtcimsva03.etn.com (Postfix) with ESMTPS;
        Wed, 29 Apr 2020 11:48:58 -0400 (EDT)
Received: from LOUTCSHUB05.napa.ad.etn.com (151.110.40.78) by
 SIMTCSGWY03.napa.ad.etn.com (151.110.126.189) with Microsoft SMTP Server
 (TLS) id 14.3.468.0; Wed, 29 Apr 2020 11:48:58 -0400
Received: from USLTCSEXHET02.NAPA.AD.ETN.COM (151.110.240.152) by
 LOUTCSHUB05.napa.ad.etn.com (151.110.40.78) with Microsoft SMTP Server (TLS)
 id 14.3.468.0; Wed, 29 Apr 2020 11:48:57 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.104)
 by hybridmail.eaton.com (151.110.240.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1591.10; Wed, 29 Apr 2020 11:48:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hzdTZo1tuN/CdslGqdjUzpx9oP1Nx4pjoxfpGwdIQS18V3Jid+GXplniGYyOB/7Vna3Fu9P6C6I6J3tCrkggPfXIPbQrI2lBLWpFRQT5TyhO5UxzEN7ysWaUOni7p8uB4yy5osq8r8UE159NVGB12d5zmLCYozZ+DDHgDw8qQhIBYJgmzgmswnsz36OV+AK4XYhbnr0C2PojzSWwR01IYFb0Z/rhl0fIzXrj5VwE6j1W976wo2BVBFC+C66u07gIz841eMPJ8Cm0MgwN+aEbUxKYELRz2/SedLw4IgAZ2L0EiDmE6FoPcgbIJ0DoT12hxOyZa3/sZCqx++Vq9v1EaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4qKLtQ+omtzPA4G1ISxjAK0UJDyoPsacGFX/5A/dUK0=;
 b=JEeWcL39kDlrWYt0GtfXcVRJiRz6+R86+Kz3v72ehQs6F1Zm8Z2JVqJO6ZP5EfsCVI0naCGSJcQgPNxZXCcWCaMpxTdBqcqIizYPDd6RO9Ay0qmFAyni7e1p/Aj1vY6YcfrEHIeCHrLSipsZ25rIQUYk3Gl3/eNBORPwCLzZxhzwHE29sYkEk3SU6dpkstsQrOLXOS3hB8lq0bLHkdyelHv3PG8ymvmq9uIz9cOy/NWgMvK7kEjrFfdCI27b4exBCIdVlE8N46arAGmA3/e19Ik5Hg1shYi7aZgObVkNXpkJSuSYa/2Xq8cDmM+rnR2MDeBdFqHkDWkexETT3bMscg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=eaton.com; dmarc=pass action=none header.from=eaton.com;
 dkim=pass header.d=eaton.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Eaton.onmicrosoft.com;
 s=selector1-Eaton-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4qKLtQ+omtzPA4G1ISxjAK0UJDyoPsacGFX/5A/dUK0=;
 b=066GGwKhiqLaui4eZAjjx9lgm0LbOTaqMSHboUE3NG7YnyI46xo8jLnsgy62INAy3GJMLtxKH9evPS75dJ6TkmmLtblwDuvurcuu78PuusewRtAdfgunNDRq1RlulZmsqnBe6EJ0GvL6OjWMY9QVz4qAbuSaq80cv+1nea32AWI=
Received: from CH2PR17MB3542.namprd17.prod.outlook.com (2603:10b6:610:40::24)
 by CH2PR17MB3749.namprd17.prod.outlook.com (2603:10b6:610:5d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20; Wed, 29 Apr
 2020 15:48:56 +0000
Received: from CH2PR17MB3542.namprd17.prod.outlook.com
 ([fe80::684d:3302:3158:502c]) by CH2PR17MB3542.namprd17.prod.outlook.com
 ([fe80::684d:3302:3158:502c%5]) with mapi id 15.20.2937.023; Wed, 29 Apr 2020
 15:48:56 +0000
From:   "Badel, Laurent" <LaurentBadel@eaton.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "fugang.duan@nxp.com" <fugang.duan@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "richard.leitner@skidata.com" <richard.leitner@skidata.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "alexander.levin@microsoft.com" <alexander.levin@microsoft.com>,
        "Quette, Arnaud" <ArnaudQuette@Eaton.com>
Subject: RE: [EXTERNAL]  Re: [PATCH 1/2] Revert commit
 1b0a83ac04e383e3bed21332962b90710fcf2828
Thread-Topic: [EXTERNAL]  Re: [PATCH 1/2] Revert commit
 1b0a83ac04e383e3bed21332962b90710fcf2828
Thread-Index: AdYeHY7rY3M9YncCRBykPeyQlUA9mwAHNUqAAAC9YgA=
Date:   Wed, 29 Apr 2020 15:48:56 +0000
Message-ID: <CH2PR17MB35423A4698E4068CDE3E18A6DFAD0@CH2PR17MB3542.namprd17.prod.outlook.com>
References: <CH2PR17MB3542DCD8D9825EE6B88BC5FCDFAD0@CH2PR17MB3542.namprd17.prod.outlook.com>
 <20200429152519.GB66424@lunn.ch>
In-Reply-To: <20200429152519.GB66424@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=eaton.com;
x-originating-ip: [178.39.126.98]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b45dc0ee-1c15-4261-1363-08d7ec54d373
x-ms-traffictypediagnostic: CH2PR17MB3749:
x-ld-processed: d6525c95-b906-431a-b926-e9b51ba43cc4,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH2PR17MB37496366AD033EE615ACD382DFAD0@CH2PR17MB3749.namprd17.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:843;
x-forefront-prvs: 03883BD916
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IKiwNWOBPKv+edqz5k50fkLvZq/OWlgmuvkBFbQ+UsCiZ4IItgtUjwmpihpL2cUUJt4PpQLkgBAtI2qHuF4Vh0qXtBNsMfQ+HmCbNSPN9Kok4xXfbutgpX1FdOUotMjeZs4HbcB/0A4I7GTrdS/8f4JlmvzAsEnT4QxfYfb5wS8iPJtjmdzB8ZmrR6mNjosrJQP6wyDJ0ih5tW0EhV0/NntFSBiW9NV6519MeTEBKvUbrirDUM+t1TByjh0OJVaTgH12zESXK/q+j18J5FwhRHLknTaFx0eN+4MfkTlmZk7Gs9VVZ89vPeHrMVeWK2KYijBNfm5nE2z1PmqgkS/ZWzQPIYjU24kq65HQxAfE3hwdi2+L6m4f05R9UYjD9v0qMEj5Ox/BWEooEWSjZmbSuklfEWmpmKGnXZy58UiowFl2m6xoS1TXJlZDsyxgI420
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR17MB3542.namprd17.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(39860400002)(136003)(366004)(376002)(396003)(5660300002)(8936002)(71200400001)(45080400002)(316002)(54906003)(86362001)(107886003)(9686003)(55016002)(76116006)(66446008)(66946007)(8676002)(66556008)(478600001)(33656002)(7696005)(64756008)(66476007)(7416002)(186003)(52536014)(4326008)(6506007)(26005)(53546011)(2906002)(6916009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 5fTf6dm/AYyFdYjDzYjwy54t3ovOM4pyx99arzbCJYyAVWKvao4yNscZRTCdrN1wqThtxvr3XACSpgp7LGw1vr6mK5ffpXqQVlHxh/AzQncWwaB1kj2ZI/GT2xS/j1n6KNE/UUR7k+8s1bfFRlAJhp48JjNkjsmPRHiIT+rLnL7LNv/1IifoR1yzDEq4TcSJR4vpXmCfMC1NIg5cl6Zs+eyYnQZbBvc8+YZjFPCFh9x9rDmWdbOw2vfpvqdH6soMnQaWIxkWXYlvJJ461OXaMXDVpyFWlq53NJn4xA1MntHFtpZ3pQtjIsdvMKLvuNuPjhnufVeTboK8Nz1lipM2qjaNIa3lvqyvnAvlA8HawDUuIhbvp7Hcy9+OfE1GliXbJfAfXEI/kR5l4fs0xNjQb8KoLS7SdNgZKqIp41kPrIrytzzQqhC55iCRw9OEVfIvN/9OPyOGc5KpFOnp6MfmmozNgcQKcfI3LHHJG7f62dxwMmFz7VdYJSLH2gCWRRaM0fcDIzxNHfYfbFP0JS7k46Hx2F59r00V2FUmmdSq8NGYOkAdHp+vC+yZV8q0WBLBMHlEd2l+o3H7UqJrfte5m31O9mp3egIlmk2Pz2QF3q2izSrFo7CGb5YAFs8+MAU0OVznNJmvf3UDXcYpzAusY2yjsqhi8fbVtZ6QXl0/Ngxko8yEK04SvyfVbiVY48yutTg6teGsNumOtspEYCvnjpWRYx37gDR4gbvvoSA6oAT/lO+AHb3hGkT/xQOmoPyMsXlxDLuw5eq/jXkhXa1R7Mk3YiVfA9eX4dVKpp8cpns=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: b45dc0ee-1c15-4261-1363-08d7ec54d373
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2020 15:48:56.4137
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d6525c95-b906-431a-b926-e9b51ba43cc4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OHwJwEgmgyslJWjMT+1MuV+Rc36GZEQUuq8UN5/0a9ye915A5X3ur2sQ6FJyncFTBKC68MOgGrKScOTK7T89ZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR17MB3749
X-TM-SNTS-SMTP: EB3FAFA0C2B6BEA54D5D66F52DABE0B6DFDA66FBC2E62A2DAA74F2DB3D407F382002:8
X-OriginatorOrg: eaton.com
X-EXCLAIMER-MD-CONFIG: 96b59d02-bc1a-4a40-8c96-611cac62bce9
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSVA-9.1.0.1988-8.5.0.1020-25386.000
X-TM-AS-Result: No--23.755-10.0-31-10
X-imss-scan-details: No--23.755-10.0-31-10
X-TMASE-Version: IMSVA-9.1.0.1988-8.5.1020-25386.000
X-TMASE-Result: 10--23.755200-10.000000
X-TMASE-MatchedRID: qDftgE+/1EYpwNTiG5IsEldOi7IJyXyI8SHVXrj1HSihEEjLknSXwP57
        N+iDW4XTJEy5P8a4U8B9vbt/FxIBNAFRQdtmxCKAnFVnNmvv47tdA4rYaKGKwpiQXtm0V8JTbXk
        7Z0VEQXCPvH61hKfdN5Kp2P0iif+HrjwZVDJcDJ8dDctFr7spHFHewY36PuY0R64C5ZrYJjR+Nx
        1ftYxL8AYzNjwA0Gq8PfVuXKfMUAX5V22kT3/19iX+a5eEMES4lNc2tyboPcL5+tteD5RzhfhjD
        LddOaI8WxUo1x72P6Dic+2pUF+sfiZ7yAgScddfN19PjPJahlJF/jSlPtma/mQVBIfp9YqSnptr
        8PnHpylAjzdPjuttgK/dq3PF0Qgr3QfwsVk0Ubv+efAnnZBiLyF6bSSak9kx
X-TMASE-SNAP-Result: 1.821001.0001-0-1-12:0,22:0,33:0,34:0-0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=EF=BB=BFHi Andrew,=20

Thanks for the reply. It's the mainline tree, was 5.6.-rc7 at the time.
There's no tree mentioned for the ethernet PHY library in the maintainers f=
iles,=20
but am I expected to test against net/ or net-next/ ?=20
I'm happy to do so but should I use rather use net/ since this is more of a=
 bugfix?=20

Best regards,

Laurent

>=20

-----------------------------
Eaton Industries Manufacturing GmbH ~ Registered place of business: Route d=
e la Longeraie 7, 1110, Morges, Switzerland=20

-----------------------------

-----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Wednesday, April 29, 2020 5:25 PM
> To: Badel, Laurent <LaurentBadel@eaton.com>
> Cc: gregkh@linuxfoundation.org; fugang.duan@nxp.com;
> netdev@vger.kernel.org; f.fainelli@gmail.com; hkallweit1@gmail.com;
> linux@armlinux.org.uk; richard.leitner@skidata.com;
> davem@davemloft.net; alexander.levin@microsoft.com; Quette, Arnaud
> <ArnaudQuette@Eaton.com>
> Subject: [EXTERNAL] Re: [PATCH 1/2] Revert commit
> 1b0a83ac04e383e3bed21332962b90710fcf2828
>=20
> > Test results: using an iMX28-EVK-based board, this patch successfully
> > restores network interface functionality when interrupts are enabled.
> > Tested using both linux-5.4.23 and latest mainline (5.6.0) kernels.
>=20
> Hi Laurent
>=20
> What tree are these patches against?
>=20
> That is why i pointed you to the netdev FAQ.
>=20
> Also, for a multi-part series, you should add a cover latter.
>=20
>      Andrew
