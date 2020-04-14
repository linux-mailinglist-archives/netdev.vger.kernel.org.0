Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 611531A72D5
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 07:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405407AbgDNFMG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 01:12:06 -0400
Received: from mail-eopbgr00060.outbound.protection.outlook.com ([40.107.0.60]:49167
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728938AbgDNFMF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Apr 2020 01:12:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y56hws9npI1Er6cYC1xYeHsgBEcog62ZYipA3fkp5C5swHn7qXhmTzMgnzQpUUWRdv4MOMxhn1CkE8zOY7+KgMgYttpVMiKBpUlR15UtZdRuC3jQ5L8IsM9rKDjsBWvCNlye8IItjv/UjlJvLLiQNOdAnAYpSUcSlRe4cFEcIkSJUBmkpSUgwdfyf8O9DRMWiSnyd3q6O/uVwIszmR9a6Pi2PgqbgPgMzFswbYtDntbRDgaC+mkAkAnw7PYLkkwUCAeYirCtXvmF8HihDLpbDKJOYQ53sNNDiyqaP0J//oGgDmuA/8BYtN5IhGTC/RLGOxqWnrhRDEIJMp8LDGHRyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dDo/pL9faYk8c4OuwzGVeOvva6q7VtFiIZh9tTE9oxs=;
 b=d2jqyrbRoOmg+UKlD53i2ek8qmevsagvPhjZcVm3BYV4lXFp6gRcqpdEldcPhYA3aiZBm6zxx5JG0K/MLhm+XGHv6towRZOEoV8V1TZXEK9hbLxkNpaKujiL94RQToaM2rwbXHAeHp+aFNgmNIAUL0/AekYoM3Erqw5G7K/lTa+MZmytGDdy+yX8fLloApxWLVP/Zf/kWAzckOYGRohycW+9OJugbE+rJCyPZF4+gyxDgcGdn5VWU5a9U7XavkcmLPPb4R19wWrwWF99Lm1N+K2UjnV/YYex9CPdcX+Utue7JfrqnT7WOWHkx8D+bG382exBtwAcf8t2E5m/9QNCyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dDo/pL9faYk8c4OuwzGVeOvva6q7VtFiIZh9tTE9oxs=;
 b=Lr956YMEDuDYwKmou/WKE1ObmN9eRGE8eVBAJ6L4Jc6h/xWVgCibkyksuM4+4AruPXYg9bpMnmYqDMSrZ1Xz7Nx9TW2f4wUxEE5XQwrVZ7FxfOfIg9Q0Lo93/4UWHUK1vaw7/CsfOtB6aOlzrRhw3JrpJHDymtAI/tHqruKh9uU=
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com (2603:10a6:803:7::18)
 by VI1PR0402MB2701.eurprd04.prod.outlook.com (2603:10a6:800:af::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.26; Tue, 14 Apr
 2020 05:12:00 +0000
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::d411:cfdb:bf:2b14]) by VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::d411:cfdb:bf:2b14%7]) with mapi id 15.20.2900.028; Tue, 14 Apr 2020
 05:12:00 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Chris Healy <Chris.Healy@zii.aero>,
        Chris Heally <cphealy@gmail.com>
Subject: RE: [EXT] [PATCH] net: ethernet: fec: Replace interrupt driven MDIO
 with polled IO
Thread-Topic: [EXT] [PATCH] net: ethernet: fec: Replace interrupt driven MDIO
 with polled IO
Thread-Index: AQHWEfYVWKKbuFIKoUCCrpamVzdoDKh37gfggAANZwCAABNdsA==
Date:   Tue, 14 Apr 2020 05:12:00 +0000
Message-ID: <VI1PR0402MB3600C15E60CB9436DFB59FCFFFDA0@VI1PR0402MB3600.eurprd04.prod.outlook.com>
References: <20200414004551.607503-1-andrew@lunn.ch>
 <VI1PR0402MB3600B82EE105E43BD20E2190FFDA0@VI1PR0402MB3600.eurprd04.prod.outlook.com>
 <20200414034920.GA611399@lunn.ch>
In-Reply-To: <20200414034920.GA611399@lunn.ch>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fugang.duan@nxp.com; 
x-originating-ip: [119.31.174.67]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 2c7473bb-8f2f-4962-60ba-08d7e0325ca9
x-ms-traffictypediagnostic: VI1PR0402MB2701:|VI1PR0402MB2701:
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-microsoft-antispam-prvs: <VI1PR0402MB2701354B76163425A1414B3CFFDA0@VI1PR0402MB2701.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 0373D94D15
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3600.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(366004)(6506007)(86362001)(2906002)(8936002)(52536014)(66556008)(64756008)(66446008)(66476007)(71200400001)(7696005)(8676002)(76116006)(5660300002)(66946007)(498600001)(4326008)(33656002)(9686003)(26005)(55016002)(186003)(81156014)(54906003)(6916009);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nRe7Nry9EP4s8PliLcCT1mZS2Or+jIPsux+43aNjFDbZoJUbCntPHRF9fJPfWKJ127+ycAum+k+63ZkVRtgvrUeMSdv+sG5HX3OnY4JUBxc1BOwAaRQPUllCZb2wfOdz8BuQAlcYrTfK/Yl6CNhCFIUvXGLOR/Hrjzwo2/n44LXR4H4Vi+7YPcuY2/WFoCR2J3luoJFJftyUwacyOi/6N2ofBNoB47190CqWk2gPXdN+8iP0k3reDbgulCOKs5neRkoXxI11y2BgONoUHBrE4VofHpwMFry82pzFd548b4dGj9P8wL+uvjY4fBT2BeEosngHbwPLiCy46GGpPwQGiwz+vozKFNUi9sXffwv4w1bYhOx06aCiuQbDhUdWvuhQwG31v1QEijydIZywl+CbQugN/OtC7SHkGuGV82Bb8FHIvIOP62Bwnk5nSwxqBeSV
x-ms-exchange-antispam-messagedata: Sd1lD2PkiyRF1VzxbDI209elUbNuji9tFUnoreDvEbEEVU0NnV08E4FwHfEZKylJg54Q/l4ico3tduapKP/hEG5bsh0LltGl44BOY2Fr8q0wO/zBX4YJ/quWlFk02YnY9/ItXiwWEtEdnR/bulNwVA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c7473bb-8f2f-4962-60ba-08d7e0325ca9
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2020 05:12:00.2905
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oTTCvk2ePGXgFvajh9+6FR0Ee1Q/qydvJJwW/Gyd0vrb7/iKrJxK+BUD79CWnusGr7/eF0/2eF94n6Um4fbSEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2701
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch> Sent: Tuesday, April 14, 2020 11:49 AM
> On Tue, Apr 14, 2020 at 03:07:09AM +0000, Andy Duan wrote:
> > From: Andrew Lunn <andrew@lunn.ch> Sent: Tuesday, April 14, 2020 8:46
> > AM
> > > Measurements of the MDIO bus have shown that driving the MDIO bus
> > > using interrupts is slow. Back to back MDIO transactions take about
> > > 90uS, with 25uS spent performing the transaction, and the remainder
> > > of the time the bus is idle.
> > >
> > > Replacing the completion interrupt with polled IO results in back to
> > > back transactions of 40uS. The polling loop waiting for the hardware
> > > to complete the transaction takes around 27uS. Which suggests
> > > interrupt handling has an overhead of 50uS, and polled IO nearly
> > > halves this overhead, and doubles the MDIO performance.
> > >
> >
> > Although the mdio performance is better, but polling IO by reading
> > register cause system/bus loading more heavy.
>=20
> Hi Andy
>=20
> I actually think is reduces the system bus load. With interrupts we have =
27uS
> waiting for the interrupt when the bus is idle, followed by 63uS the CPU =
is
> busy handling the interrupt and setting up the next transfer, which will =
case
> the bus to be loaded. So the system bus is busy for 63uS per transaction.=
 With
> polled IO, yes the system bus is busy for 27uS polling while the transact=
ion
> happens, and then another 13uS setting up the next transaction. But in to=
tal,
> that is only 40uS.
>
We cannot calculate the bus loading like this number. As you know, interrup=
t handler
may cost many instructions on cacheable memory accessing, but IO register
accessing is non-cacheable, which bring heavy AIPS bus loading when a flood=
 of
MDIO read/write operations.  But I don't deny your conclusion that system b=
us
is more busy in interrupt mode than polling mode.=20

> So with interrupts we have 63uS of load per transaction, vs 40uS of load =
per
> transaction for polled IO. Polled IO is better for the bus.
If we switch to polling mode, it is better to add usleep or cpu relax betwe=
en IO
Polling.

>=20
> I also have follow up patches which allows the bus to be run at higher sp=
eeds.
> The Ethernet switch i have on the bus is happy to run a 5MHz rather than =
the
> default 2.5MHz.=20

Please compatible with 2.5Hz for your following patches.

Thanks,
Andy=20
