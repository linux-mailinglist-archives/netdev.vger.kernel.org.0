Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4604711DC93
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 04:21:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731668AbfLMDVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 22:21:07 -0500
Received: from mail-eopbgr70071.outbound.protection.outlook.com ([40.107.7.71]:33799
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731640AbfLMDVH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Dec 2019 22:21:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gJGlbWLP8/YOYv0X4n3xN3Xlu9bpdpMtFp4OlGqjr4voBozeyORzwPeSDNbczomZEpeA00H1jEfbiQe+i1XEThdyxIjTZm3RFihM9V3u884ljOf5rEK04Xxe5rSFfYXPQEKcTmxLQYw0QP48FXSgxLWVHMxyyNtPa2W4er9ZnBXCRySCovMh6fIjyShJsSsKks67LEM2swKzfAK23SrF0lMgX6RImArD+bPg0DXwZPZyqsXNunXZGVECH46t93igE/KsaP1TWZR5bthDwo/lKBb5p45tuTsNR31ma67dTH/RUjXW0XX9m0jyFRvEK3RCUhFxSxbvSI0uqEONSJ6dbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FD0tVwVD110VoCZHWiw7wwLORTeRvyR1M8QjKhIgBFc=;
 b=K+EUbtdUdKHWngAuvVC3WESEo1d7daaRetuTgQaR6A8XmgLYH979Q2S3jlG3EEH8n/jSY7efZ1kWAJRWipdqQB6ivG1VfJoCiwyIq1Cp0vNudVlTE2/xLyMhhlzXOxpVzAUOHuhBaMnkOxsjfPY2fczm8TBHVfe05xxksx0HrugBqC6o+rREf4JivxGWNn/rI/CMnHeItNOOOo3aDljKPat9XQqlQrV/+2OscD7shl3feXrU7xw467wxvt6NbmGLcBb+vZXqUIqys8NWu3EcIJ9ZOnqxfzsvqkpPAEXhTX3CnSQd5B05TwTWKw3XJn6lj+PsYKqsdCi4jCS+kbz8Ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FD0tVwVD110VoCZHWiw7wwLORTeRvyR1M8QjKhIgBFc=;
 b=nC2kyj3vP63eWglA9ShCh7q7GArTKn3DjyWBx7Ik94KX/hH5P5Cv0y/2P0/nYNiPIIF43dag7gFt3uUw6lktMxWvk/IVNiKa4LdlgJfqD8FXnbl2rCmo2wDmMPSC2Nroeh89ClSIc0DwzDPfNP06xAXofUuVgx5H17stOjD2QSg=
Received: from AM6PR05MB5142.eurprd05.prod.outlook.com (20.177.197.210) by
 AM6PR05MB5368.eurprd05.prod.outlook.com (20.177.196.76) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.15; Fri, 13 Dec 2019 03:21:02 +0000
Received: from AM6PR05MB5142.eurprd05.prod.outlook.com
 ([fe80::e8d3:c539:7550:2fdd]) by AM6PR05MB5142.eurprd05.prod.outlook.com
 ([fe80::e8d3:c539:7550:2fdd%6]) with mapi id 15.20.2538.017; Fri, 13 Dec 2019
 03:21:02 +0000
From:   Yuval Avnery <yuvalav@mellanox.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     Jiri Pirko <jiri@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andy Gospodarek <andy@greyhouse.net>
Subject: RE: [PATCH net-next] netdevsim: Add max_vfs to bus_dev
Thread-Topic: [PATCH net-next] netdevsim: Add max_vfs to bus_dev
Thread-Index: AQHVr871nDBB5hrvy0ak2C7+9Ay1lae1Oa8AgAAB1gCAABOZgIAACO8QgAArtYCAAAxfkIAAC50AgABVJmCAAOJ/gIAAIpgggABa3ACAABH7IA==
Date:   Fri, 13 Dec 2019 03:21:02 +0000
Message-ID: <AM6PR05MB514261CD6F95F104C0353A4BC5540@AM6PR05MB5142.eurprd05.prod.outlook.com>
References: <1576033133-18845-1-git-send-email-yuvalav@mellanox.com>
        <20191211095854.6cd860f1@cakuba.netronome.com>
        <AM6PR05MB514244DC6D25DDD433C0E238C55A0@AM6PR05MB5142.eurprd05.prod.outlook.com>
        <20191211111537.416bf078@cakuba.netronome.com>
        <AM6PR05MB5142CCAB9A06DAC199F7100CC55A0@AM6PR05MB5142.eurprd05.prod.outlook.com>
        <20191211142401.742189cf@cakuba.netronome.com>
        <AM6PR05MB51423D365FB5A8DB22B1DE62C55A0@AM6PR05MB5142.eurprd05.prod.outlook.com>
        <20191211154952.50109494@cakuba.netronome.com>
        <AM6PR05MB51425B74E736C5D765356DC8C5550@AM6PR05MB5142.eurprd05.prod.outlook.com>
        <20191212102517.602a8a5d@cakuba.netronome.com>
        <AM6PR05MB5142F0F18EA6B6F16C5888CEC5550@AM6PR05MB5142.eurprd05.prod.outlook.com>
 <20191212175418.3b07b7a9@cakuba.netronome.com>
In-Reply-To: <20191212175418.3b07b7a9@cakuba.netronome.com>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yuvalav@mellanox.com; 
x-originating-ip: [70.66.202.183]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b76c19e8-0737-40f5-305d-08d77f7b7b62
x-ms-traffictypediagnostic: AM6PR05MB5368:|AM6PR05MB5368:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR05MB53684EF22A004A5C0D139660C5540@AM6PR05MB5368.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:608;
x-forefront-prvs: 0250B840C1
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(366004)(39860400002)(136003)(396003)(13464003)(199004)(189003)(6506007)(9686003)(86362001)(478600001)(26005)(6916009)(53546011)(66556008)(76116006)(66476007)(66946007)(71200400001)(66446008)(64756008)(5660300002)(7696005)(8936002)(55016002)(52536014)(186003)(81166006)(81156014)(316002)(4326008)(8676002)(2906002)(33656002)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5368;H:AM6PR05MB5142.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +PJr5L2U2nE+wQoxku3iuYD6Rb56ybB7LL3JQJv2mw2Scve+Z1qUDZTMTsCIClyEb+B39udcMtCtjlm++lS24MS2YSSSM1TCgkukrMyF5r1//3AnzTRQJmNmUSRlJmqVUqG048Rrgr5luDFEu9hXh/JrOdI9QodZsMIQd1cJGuiUI42zkocG7SS1d/P3kkX8kjxXaarQ5u6O8qZ10fTP02RQ0+N39mRecakYCR2QzMMUA9W4unNbzY+633Hbtt4+Z/qlOt++9/Eud4jaB0uE0lw9RVBiHyHyrNxKhAoWRswA2Ua4AL/ah94Zo0j0lpxtWH/wB6jSi2om489xvmbeW9vBFd8cpJnt+dkYgApamhSiuudfA0QSy7B/XpdM3RlU2j1U3d5UhsXpARGACN7A4OQrz6in8KSwJZ3oT9GiO/5O0VIRt73TcsGvd8Tr9xvWGOI5s2W75vtu6FFIhNnusTY0vlCT4lPsZUrdB/zhSNlABGl29rkuX1SrYFahsRJl
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b76c19e8-0737-40f5-305d-08d77f7b7b62
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2019 03:21:02.2242
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /Kt4SivnfR1/93IaYskkx2z4w5PKxzqGyYPurJ5mL6RE8tou0I4U2evQ2xYd3sUH4lHWCYjDokEG1nnQ4lhUyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5368
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <jakub.kicinski@netronome.com>
> Sent: Thursday, December 12, 2019 5:54 PM
> To: Yuval Avnery <yuvalav@mellanox.com>
> Cc: Jiri Pirko <jiri@mellanox.com>; davem@davemloft.net;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Andy Gospodarek
> <andy@greyhouse.net>
> Subject: Re: [PATCH net-next] netdevsim: Add max_vfs to bus_dev
>=20
> On Thu, 12 Dec 2019 20:44:31 +0000, Yuval Avnery wrote:
> > > -----Original Message-----
> > > From: Jakub Kicinski <jakub.kicinski@netronome.com>
> > > Sent: Thursday, December 12, 2019 10:25 AM
> > > To: Yuval Avnery <yuvalav@mellanox.com>
> > > Cc: Jiri Pirko <jiri@mellanox.com>; davem@davemloft.net;
> > > netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Andy
> > > Gospodarek <andy@greyhouse.net>
> > > Subject: Re: [PATCH net-next] netdevsim: Add max_vfs to bus_dev
> > >
> > > On Thu, 12 Dec 2019 05:11:12 +0000, Yuval Avnery wrote:
> > > > > > > Okay, please post v2 together with the tests. We don't
> > > > > > > accept netdevsim features without tests any more.
> > > > > >
> > > > > > I think the only test I can currently write is the enable
> > > > > > SR-IOV max_vfs enforcement. Because subdev is not in yet.
> > > > > > Will that be good enough?
> > > > >
> > > > > It'd be good to test some netdev API rather than just the
> > > > > enforcement itself which is entirely in netdevsim, I think.
> > > > >
> > > > > So max_vfs enforcement plus checking that ip link lists the
> > > > > correct number of entries (and perhaps the entries are in reset
> > > > > state after
> > > > > enable) would do IMO.
> > > >
> > > > Ok, but this is possible regardless of my patch (to enable vfs).
> > >
> > > I was being lenient :) Your patch is only really needed when the
> > > devlink API lands, since devlink will display all max VFs not enabled=
.
> > >
> > > > > My knee jerk reaction is that we should populate the values to
> > > > > those set via devlink upon SR-IOV enable, but then if user
> > > > > overwrites those values that's their problem.
> > > > >
> > > > > Sort of mirror how VF MAC addrs work, just a level deeper. The
> > > > > VF defaults to the MAC addr provided by the PF after reset, but
> > > > > it can change it to something else (things may stop working
> > > > > because spoof check etc. will drop all its frames, but nothing
> > > > > stops the VF in legacy HW from writing its MAC addr register).
> > > > >
> > > > > IOW the devlink addr is the default/provisioned addr, not
> > > > > necessarily the addr the PF has set _now_.
> > > > >
> > > > > Other options I guess are (a) reject the changes of the address
> > > > > from the PF once devlink has set a value; (b) provide some
> > > > > device->control CPU notifier which can ack/reject a request from
> > > > > device->the PF
> > > to change devlink's value..?
> > > > >
> > > > > You guys posted the devlink patches a while ago, what was your
> > > > > implementation doing?
> > > >
> > > > devlink simply calls the driver with set or get.
> > > > It is up to the vendor driver/HW if to make this address persistent=
 or
> not.
> > > > The address is not saved in the devlink layer.
> > >
> > > It'd be preferable for the behaviour of the kernel API to not be
> > > vendor specific. That defeats the purpose of having an operating
> > > system as a HW abstraction layer. SR-IOV devices of today are so FW
> > > heavy we can make them behave whatever way we choose makes most
> sense.
> > >
> > > > The MAC address in mlx5 is stored in the HW and persistent (until
> > > > PF
> > > > reset) , whether it is set by devlink or ip link.
> > >
> > > Okay, let's see if I understand. The devlink and ip link interfaces
> > > basically do the same thing but one reaches from control CPU and the
> > > other one from the SR-IOV host? And on SR-IOV host reset the addresse=
s
> go back to 00:00..
> > > i.e. any?
> >
> > No,
> > This will work only in non-SmartNic mode, when e-switch manager is on
> > the host, MAC will be accessible through devlink and legacy tools..
> > For smartnic, only devlink from the embedded OS will work. Ip link from
> the host will not work.
>=20
> I see, is this a more fine grained capability or all or nothing for SR-IO=
V control?
> I'd think that if the SmartNIC's eswitch just encapsulates all the frames=
 into a
> L4 tunnel it shouldn't care about L2 addresses.

People keep saying that, but there are customers who wants this capability =
:)

>=20
> > > What happens if the SR-IOV host changes the MAC? Is it used by HW or
> > > is the MAC provisioned by the control CPU used for things like spoof
> check?
> >
> > Host shouldn't have privileges to do it.
> > If it does, then it's under the host ownership (like in non-smartnic mo=
de).
>=20
> I see so the MAC is fixed from bare metal host's PoV? And it has to be se=
t

Yes

> through some high level cloud API (for live migration etc)?
> Do existing software stacks like libvirt handle not being able to set the=
 MAC
> happily?

I am not sure what you mean.
What we are talking about here is the E-switch manager setting a MAC to ano=
ther VF.
When the VF driver loads it will query this MAC from the NIC. This is the w=
ay
It works today with "ip link set _vf_ mac"

Or in other words we are replacing "ip link set _vf_ mac" and not "ip link =
set address"
So that it can work from the SmartNic embedded system.
There is nothing really new here, ip link will not work from a SmartNic,
this is why need devlink subdev.

Hope that answers you question.

>=20
> > > Does the control CPU get a notification for SR-IOV host reset? In
> > > that case the control CPU driver could restore the MAC addr.
> >
> > Yes, but this is irrelevant here, the MAC is already stored in HW/FW.
> > The MAC will reset only when the E-switch manager (on the control CPU)
> reset.
> >
> > > > So from what I understand, we have the freedom to choose how
> > > > netdevsim behave in this case, which means non-persistent is ok.
> > >
> > > To be clear - by persistent I meant that it survives the SR-IOV
> > > host's resets, not necessarily written to NVRAM of any sort.
> >
> > Yes, this is my view as well.
> > For non-smartnic it will survive VF disable/enable.
> > MAC is not stored on NVRAM, it will disappear once the driver on the
> control CPU resets.
> >
> > > I'd like to see netdevsim to also serve as sort of a reference model
> > > for device behaviour. Vendors who are not first to implement a
> > > feature always complain that there is no documentation on how things
> should work.
> >
> > Yes, this is a good idea.
> > But it seems we are always held back by legacy tools with no well-defin=
ed
> behavior.
