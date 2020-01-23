Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB49F146330
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 09:18:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbgAWISR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 03:18:17 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:33468 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726083AbgAWISR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 03:18:17 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00N8H3qk021339;
        Thu, 23 Jan 2020 00:18:13 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=jDu/NunEkfpQ9mrHqK/8xTAKIhoA6tM6uXFjqNBtobo=;
 b=SBRv3z03RFkQP+nO598bUh6h+sSK1MkyeFyuCmcZr4goRu+TyQrRxviInirxmmEyEIY+
 yVWPd4YuFVRDxkdffHARGz2HI0MRo9hHrsnxlhNVrYxxZU3nLnPyNu6lmlJG45SYZT2P
 YuZwaUXC2jm1PLHlo4ZmK3cwWjwXlRBXztgSUH8jy80br30/RTaZjWRTsmJnysLg4t4d
 nlxKtF8sIh8ftCHHQKQ/mC2ruowyVuCZdJqkDEVk6vI7CIe4ZDtoaFqvkTgklsuZYkr7
 xF/PttITab66hpUqJQJbAAvCev4ssKN86ZAr9keHKVeqvVU+xLpncKxKMmVNIsktapFW LQ== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 2xm2dtaw8t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 23 Jan 2020 00:18:12 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 23 Jan
 2020 00:18:10 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.176)
 by SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 23 Jan 2020 00:18:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hj9xsVIpXzVUknYzh+QRxkNwSfqYrWA0pJAYGxo2qqEU2XZtKJS7/hhpbQIimfuJd3FSctnxyGMubPQXgcgIqMQns6M8zhYpTntZrNPpxrZErlGdWe5HT6kaWU9EJxGliFreTcVJ689urFj1neZwB0KUnOM8lxnKGYoVaAknOe15+A9Gdxu4Xze7yUSChsS8ydNB9eF9khdn8akzZGRIdu52wNSbqd2Km8EnaJLeysBl+KgJ/aA8L9WJxC2vdsz0A15LmIuaAFgYXYF2fbojgiGK2Wz6QesajmdLr/dCC9P9q4ltDs7+4+K26xzIXWAZbQoMRGyulOWOjwWJswjpXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jDu/NunEkfpQ9mrHqK/8xTAKIhoA6tM6uXFjqNBtobo=;
 b=LEiqEd0ZoUvjgZ25QnpVKm8TUtIfpioFyjrB+ff1+uE7c/NWemNuGHolo8scQJ1IUX9Wd8okxFDrQG74Cq/l0/eLYXZsahkcA0Wp1lRB4HGYpwgmbW7znjzNtcasLPCOypRRfc1InGFhaEdIDXw96RJXihtNZjxXk9rXZ+w2vTysMhxsbKr8dHRwWBCwK+BSC3PFAy/mJYByui6Uqff29ptqCt7KBhV62QKGzKl8fsgCKu1+gfp4UJnhyiesPjFNi+ZSiQwxVNW0ucoDbAPTTvukmiRms54Bg0Sh7/iNYVLhSwe6G4ZejLskhSHN+optL7dElFjN8je7x7+1vWtxFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jDu/NunEkfpQ9mrHqK/8xTAKIhoA6tM6uXFjqNBtobo=;
 b=g2Y/crZZc4kIXU7BBcu8qKi2MKcRUx7p9AuLaSNoC/531fPQ9Zoczhzcykmcef/1SPRhaV/IoYYjTOKye7vNFKfO6xKJ36Zpl6zAFukIe/bIM9oROemDIkIHl0XGYXlJBzICgQDjXqx3Z+OPfR51u3h+PKusWrUGXml1UQ5MaLY=
Received: from MN2PR18MB3182.namprd18.prod.outlook.com (10.255.236.143) by
 MN2PR18MB2847.namprd18.prod.outlook.com (20.179.20.87) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.19; Thu, 23 Jan 2020 08:18:09 +0000
Received: from MN2PR18MB3182.namprd18.prod.outlook.com
 ([fe80::703e:1571:8bb7:5f8f]) by MN2PR18MB3182.namprd18.prod.outlook.com
 ([fe80::703e:1571:8bb7:5f8f%6]) with mapi id 15.20.2644.028; Thu, 23 Jan 2020
 08:18:08 +0000
From:   Michal Kalderon <mkalderon@marvell.com>
To:     Leon Romanovsky <leon@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     Ariel Elior <aelior@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH net-next 14/14] qed: bump driver version
Thread-Topic: [EXT] Re: [PATCH net-next 14/14] qed: bump driver version
Thread-Index: AQHV0ThpJrFvaqxCKkSHPokHVLLx0Kf223CAgAAFkkCAAB36gIAA5fvg
Date:   Thu, 23 Jan 2020 08:18:08 +0000
Message-ID: <MN2PR18MB31829FA8377460DDB9675596A10F0@MN2PR18MB3182.namprd18.prod.outlook.com>
References: <20200122152627.14903-1-michal.kalderon@marvell.com>
 <20200122152627.14903-15-michal.kalderon@marvell.com>
 <20200122161353.GG7018@unreal>
 <MN2PR18MB31821C711CBB377437F3EECCA10C0@MN2PR18MB3182.namprd18.prod.outlook.com>
 <20200122182107.GI7018@unreal>
In-Reply-To: <20200122182107.GI7018@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [212.199.69.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9caf3ca2-c327-47e4-180d-08d79fdcc79f
x-ms-traffictypediagnostic: MN2PR18MB2847:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR18MB28471A0325F8C309EF20C227A10F0@MN2PR18MB2847.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 029174C036
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(346002)(39850400004)(366004)(376002)(189003)(199004)(316002)(478600001)(54906003)(26005)(186003)(2906002)(66446008)(110136005)(8936002)(33656002)(64756008)(66476007)(8676002)(6506007)(53546011)(66946007)(71200400001)(66556008)(81166006)(81156014)(76116006)(86362001)(52536014)(4326008)(5660300002)(9686003)(55016002)(7696005);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB2847;H:MN2PR18MB3182.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: il20s9c5k78408StcpAgwu6GoenVEfBkjaKzOMGOQWx4YkGom+EFGN4giVbdENrcakrMVDlNM0vJbVscHCcSnxAwFzuv/n27X+4wimjt48/jF6NYwCRORnSp8EmYRkRih/tXHuyX0pMOyx9UFbcV729X9R04fungaT5/RWrqgr1nNAhDwaWbw52MyHO2rRUc/kwyiPKdXEJezzHon5ypo1bQPqO4rv01dTbzS8yJu0d7mSBqEVkxcTCbWys65wS+vtoPqV6peZ/WHmxWwyTvFkgetXgM1qeE7MsWqD/aj6i33+IwV50tBJ1tTnaAK8/l0wsBQZqyNEWr+k6RFwg9H/7lVx8SfCZE1nIjpgxsj1hz6fRv4yge3golH+2RltDPFnX1ks/W+fJw132DVjdoIORex4sQXXa3rSr9Dx0gjk3QzFb+q/WU9gnFObW+FyXS
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 9caf3ca2-c327-47e4-180d-08d79fdcc79f
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2020 08:18:08.5878
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: H7IQ3HGz/1gAVfr5U4hikwlen9+EtbjYBymYQuEySsscifU9hYQKMbWgyo/eRtWhHfX7Aw18lv6D0rLH4125kA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2847
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-22_08:2020-01-22,2020-01-22 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: linux-rdma-owner@vger.kernel.org <linux-rdma-
> owner@vger.kernel.org> On Behalf Of Leon Romanovsky
> Sent: Wednesday, January 22, 2020 8:21 PM
> To: Michal Kalderon <mkalderon@marvell.com>
> Cc: Ariel Elior <aelior@marvell.com>; davem@davemloft.net;
> netdev@vger.kernel.org; linux-rdma@vger.kernel.org; linux-
> scsi@vger.kernel.org
> Subject: Re: [EXT] Re: [PATCH net-next 14/14] qed: bump driver version
>=20
> On Wed, Jan 22, 2020 at 04:39:26PM +0000, Michal Kalderon wrote:
> > > From: Leon Romanovsky <leon@kernel.org>
> > > Sent: Wednesday, January 22, 2020 6:14 PM
> > >
> > > --------------------------------------------------------------------
> > > -- On Wed, Jan 22, 2020 at 05:26:27PM +0200, Michal Kalderon wrote:
> > > > The FW brings along a large set of fixes and features which will
> > > > be added at a later phase. This is an adaquete point to bump the
> > > > driver
> > > version.
> > > >
> > > > Signed-off-by: Ariel Elior <ariel.elior@marvell.com>
> > > > Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
> > > > ---
> > > >  drivers/net/ethernet/qlogic/qed/qed.h | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > >
> > >
> > > We discussed this a lot, those driver version bumps are stupid and
> > > have nothing close to the reality. Distro kernels are based on some
> > > kernel version with extra patches on top, in RedHat world this "extra=
"
> > > is a lot. For them your driver version say nothing. For users who
> > > run vanilla kernel, those versions are not relevant too, because
> > > running such kernels requires knowledge and understanding.
> > >
> > > You definitely should stop this enterprise cargo cult of "releasing
> software"
> > > by updating versions in non-controlled by you distribution chain.
> > >
> > > Thanks
> > Due to past discussions on this topic, qedr driver version was not adde=
d
> and not bumped.
> > However, customers are used to seeing a driver version for qed/qede We
> > only bump major version changes (37 -> 42)  and not the minor versions
> anymore.
> > This does give a high-level understanding of the driver supports, helps=
 us
> and the customers.
>=20
> It is worth to talk with customers instead of adding useless work for
> everyone involved here.
Hi Leon,=20

I understand your arguments, and for new drivers I agree it is best to star=
t without a driver version, having said that
Customers are used to what is already out there.=20

Ethtool displays a driver version, and  customers go by driver version, not=
 kernel version.=20
Mlx drivers haven't bumped the driver version, but it is still displayed wh=
en running ethtool.=20

Having this version in upstream driver also helps us to understand the leve=
l of changes in the inbox driver.
As you mentioned, in some distributions like RHEL, kernel version has no me=
aning as they backport much newer functionality from upstream.
It is difficult to know based on RedHat kernel/driver, how the driver compa=
res with the upstream driver or what functionality is there.
We have seen that the driver version greatly helps customers here.

Of course if a decision is taken to remove all ethernet driver versions fro=
m all vendors and remove the version display from ethtool
We won't object, but since it is still there, and the driver version until =
now does correlate in the high-level sense to functionality,
I don't see the harm in this single patch.

Dave, what is your take on this ?=20
Thanks,
Michal

>=20
> Thanks
>=20
> >
