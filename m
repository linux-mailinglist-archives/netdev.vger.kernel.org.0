Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8375412DAC0
	for <lists+netdev@lfdr.de>; Tue, 31 Dec 2019 18:51:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727111AbfLaRvu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Dec 2019 12:51:50 -0500
Received: from mail-dm6nam10on2092.outbound.protection.outlook.com ([40.107.93.92]:27119
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726060AbfLaRvt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Dec 2019 12:51:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X36cYJJJ2lapdxXXjHBL47VuJXoRCmxw5mF7u1kGNQcAuk3bh+1dxOTkfk2cGEGIK2VuuHeaYtVnoEx36zZGjL/59xvE+5e+1UhROLlFiG33UgUoTjTfMEAPDsmzxPSwRZ1ECrnzaeihZ7WwaBh12P0ZJFSKZbAJHbS+5HI7PnaOaSqGkyYqcNjE1xwElE18D+PmAiVEpW9agswEd4KLbLBDr3uRjchHWTyZujxFWD5YJEK88nLxYDRCFP79Qy+lo015sKwWOo+/1uIGH33nh0ZxOWfQ2AjAf1rVl2wNiIXCm8mN/+7OZDZ9XXPg2wYkTFdlQ1To6GZlxsNb0FLKxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WpTj8PgisKVo158jRnHrQHyeVr9hcVVjLEFeu77NQbY=;
 b=I4jOOSbNnB8Fi/eyTeuH9EL1hZ9YgYnihyztbAJTkI/3Axljgois4zJQnUg7KhNbWDt12cTAw+40Gps5mPVNqDqkfw0eD5iMR88KPaFXnBauUCYcKr+1vnygkBbB7Nop/p4xC79aITT5lndbLemdOjG5jPtb128Pymk3knCfwaRI7fR/fstIM4ZKwNWCNvrv1OZ8z/Hs29vmxMMiarZCY9SYIzXasE7iZ6gAs4ej6DtgfyB5Nv/0b7p2513On+u1VrrTR1TJdKF5TnHh/rCwkvgB8KGgn2mv4mMDfbYi2sfFu29zdRHHwdx5eV0BVSZXDB3OHF6WdY91QLykOB5xwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WpTj8PgisKVo158jRnHrQHyeVr9hcVVjLEFeu77NQbY=;
 b=GTg+G8Psjl3PMJnFsN/6FW+Q3gxIyLHvzGPZmqfg9E9GPVz5QAd1SMpnQsmZx8tXfkBwG4Mw+N+qAREtHRcNOm4epa5myS/SQGNRineh+Ttdbj32YUNwXPSsmiDj8FFScJQvtRqJH7PsHTthpzTpeoZhdXXC/4RTHiWtmsvTQWI=
Received: from MN2PR21MB1375.namprd21.prod.outlook.com (20.179.23.160) by
 MN2PR21MB1248.namprd21.prod.outlook.com (20.179.20.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.1; Tue, 31 Dec 2019 17:51:43 +0000
Received: from MN2PR21MB1375.namprd21.prod.outlook.com
 ([fe80::6de3:c062:9e55:ffc4]) by MN2PR21MB1375.namprd21.prod.outlook.com
 ([fe80::6de3:c062:9e55:ffc4%5]) with mapi id 15.20.2623.002; Tue, 31 Dec 2019
 17:51:43 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     Roman Kagan <rkagan@virtuozzo.com>,
        "sashal@kernel.org" <sashal@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>, vkuznets <vkuznets@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH V2,net-next, 3/3] hv_netvsc: Name NICs based on vmbus
 offer sequence and use async probe
Thread-Topic: [PATCH V2,net-next, 3/3] hv_netvsc: Name NICs based on vmbus
 offer sequence and use async probe
Thread-Index: AQHVv027GHCeFuKLhUO4V+gfj0XECKfUHfwAgABK1lCAABorAIAAA1Zg
Date:   Tue, 31 Dec 2019 17:51:43 +0000
Message-ID: <MN2PR21MB1375505C4C5E132B161FB4BFCA260@MN2PR21MB1375.namprd21.prod.outlook.com>
References: <1577736814-21112-1-git-send-email-haiyangz@microsoft.com>
        <1577736814-21112-4-git-send-email-haiyangz@microsoft.com>
        <20191231113440.GA380228@rkaganb.sw.ru>
        <MN2PR21MB1375D41039A8A68A2117DDFCCA260@MN2PR21MB1375.namprd21.prod.outlook.com>
 <20191231093614.75da9bea@hermes.lan>
In-Reply-To: <20191231093614.75da9bea@hermes.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=haiyangz@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-12-31T17:51:41.7454401Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=bf1bf49b-1a5d-4997-b143-2364eb4c7d81;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=haiyangz@microsoft.com; 
x-originating-ip: [96.61.92.94]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: fd387e9b-a39e-4798-7fd2-08d78e1a18cd
x-ms-traffictypediagnostic: MN2PR21MB1248:|MN2PR21MB1248:|MN2PR21MB1248:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MN2PR21MB12485BBDD052EE9DED3D482BCA260@MN2PR21MB1248.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0268246AE7
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(376002)(39860400002)(136003)(346002)(396003)(189003)(13464003)(199004)(10290500003)(8676002)(9686003)(71200400001)(8990500004)(33656002)(8936002)(66476007)(66556008)(64756008)(66446008)(66946007)(53546011)(55016002)(76116006)(6506007)(86362001)(4326008)(81156014)(478600001)(81166006)(6916009)(2906002)(54906003)(26005)(7696005)(316002)(52536014)(186003)(5660300002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR21MB1248;H:MN2PR21MB1375.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xqSHFrRL9YckkA4MshXvnv3V59W7o1Ja2DCYV+8axUsQV5eVAFO8FJAG5JbYduqGQxeZ7UqO9PncM8CFOjEAgiAaY8r/a16jhg1OwSMS5AUyc6pzr8RUFAwt9Lu/Mcvfd3phUII/5NB2cCfXAMHi0ztvtWVd00xAJWEDTi6Lh8HX4mMpT3wW462qJTw0oZlRv1bwbcJYktz/PJhP3w0+vKQNe6NBo7iJl3B1EVO/NGQCRTN1MkqpFi49qavBBvnIZfA4RfevWF4qIlq5hn/1gViOKQoSUEaee40SZzHRarR5fW3pPkxy/2uzJQc8pkh7zSCC+ge/ibpMXjyWithXA3PakaAmNW/+Rox/75i5X5HwEG321JXoqa4kNxHie/Sv34AowV5yfjei51vZA7y56yapyVQmmRZ9iHcsGbXYJaleuNEqNfC17md8r2E5m/62v8L3QZYAxy5wY16jwmFyZ11OUdFgoWPqynqVF7W9CKvoSh2jSLCERlC+IxeMviF2
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd387e9b-a39e-4798-7fd2-08d78e1a18cd
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Dec 2019 17:51:43.0930
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8+6K7CpvM+my8h8jGFIkElkR5SAdsNGyFkzwBHb8nb4KsXhiEP34cB19BgAEt+JQtOQSJC7lacTjvLzimiJRog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR21MB1248
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: linux-hyperv-owner@vger.kernel.org <linux-hyperv-
> owner@vger.kernel.org> On Behalf Of Stephen Hemminger
> Sent: Tuesday, December 31, 2019 12:36 PM
> To: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: Roman Kagan <rkagan@virtuozzo.com>; sashal@kernel.org; linux-
> hyperv@vger.kernel.org; netdev@vger.kernel.org; KY Srinivasan
> <kys@microsoft.com>; Stephen Hemminger <sthemmin@microsoft.com>;
> olaf@aepfle.de; vkuznets <vkuznets@redhat.com>; davem@davemloft.net
> Subject: Re: [PATCH V2,net-next, 3/3] hv_netvsc: Name NICs based on vmbus
> offer sequence and use async probe
>=20
> On Tue, 31 Dec 2019 16:12:36 +0000
> Haiyang Zhang <haiyangz@microsoft.com> wrote:
>=20
> > > -----Original Message-----
> > > From: Roman Kagan <rkagan@virtuozzo.com>
> > > Sent: Tuesday, December 31, 2019 6:35 AM
> > > To: Haiyang Zhang <haiyangz@microsoft.com>
> > > Cc: sashal@kernel.org; linux-hyperv@vger.kernel.org;
> netdev@vger.kernel.org;
> > > KY Srinivasan <kys@microsoft.com>; Stephen Hemminger
> > > <sthemmin@microsoft.com>; olaf@aepfle.de; vkuznets
> > > <vkuznets@redhat.com>; davem@davemloft.net; linux-
> kernel@vger.kernel.org
> > > Subject: Re: [PATCH V2,net-next, 3/3] hv_netvsc: Name NICs based on
> vmbus
> > > offer sequence and use async probe
> > >
> > > On Mon, Dec 30, 2019 at 12:13:34PM -0800, Haiyang Zhang wrote:
> > > > The dev_num field in vmbus channel structure is assigned to the fir=
st
> > > > available number when the channel is offered. So netvsc driver uses=
 it
> > > > for NIC naming based on channel offer sequence. Now re-enable the
> > > > async probing mode for faster probing.
> > > >
> > > > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > > > ---
> > > >  drivers/net/hyperv/netvsc_drv.c | 18 +++++++++++++++---
> > > >  1 file changed, 15 insertions(+), 3 deletions(-)
> > > >
> > > > diff --git a/drivers/net/hyperv/netvsc_drv.c
> > > > b/drivers/net/hyperv/netvsc_drv.c index f3f9eb8..39c412f 100644
> > > > --- a/drivers/net/hyperv/netvsc_drv.c
> > > > +++ b/drivers/net/hyperv/netvsc_drv.c
> > > > @@ -2267,10 +2267,14 @@ static int netvsc_probe(struct hv_device *d=
ev,
> > > >  	struct net_device_context *net_device_ctx;
> > > >  	struct netvsc_device_info *device_info =3D NULL;
> > > >  	struct netvsc_device *nvdev;
> > > > +	char name[IFNAMSIZ];
> > > >  	int ret =3D -ENOMEM;
> > > >
> > > > -	net =3D alloc_etherdev_mq(sizeof(struct net_device_context),
> > > > -				VRSS_CHANNEL_MAX);
> > > > +	snprintf(name, IFNAMSIZ, "eth%d", dev->channel->dev_num);
> > >
> > > How is this supposed to work when there are other ethernet device typ=
es on
> the
> > > system, which may claim the same device names?
> > >
> > > > +	net =3D alloc_netdev_mqs(sizeof(struct net_device_context), name,
> > > > +			       NET_NAME_ENUM, ether_setup,
> > > > +			       VRSS_CHANNEL_MAX, VRSS_CHANNEL_MAX);
> > > > +
> > > >  	if (!net)
> > > >  		goto no_net;
> > > >
> > > > @@ -2355,6 +2359,14 @@ static int netvsc_probe(struct hv_device *de=
v,
> > > >  		net->max_mtu =3D ETH_DATA_LEN;
> > > >
> > > >  	ret =3D register_netdevice(net);
> > > > +
> > > > +	if (ret =3D=3D -EEXIST) {
> > > > +		pr_info("NIC name %s exists, request another name.\n",
> > > > +			net->name);
> > > > +		strlcpy(net->name, "eth%d", IFNAMSIZ);
> > > > +		ret =3D register_netdevice(net);
> > > > +	}
> > >
> > > IOW you want the device naming to be predictable, but don't guarantee=
 this?
> > >
> > > I think the problem this patchset is trying to solve is much better s=
olved with
> a
> > > udev rule, similar to how it's done for PCI net devices.
> > > And IMO the primary channel number, being a device's "hardware"
> > > property, is more suited to be used in the device name, than this com=
pletely
> > > ephemeral device number.
> >
> > The vmbus number can be affected by other types of devices and/or
> subchannel
> > offerings. They are not stable either. That's why this patch set keeps =
track of
> the
> > offering sequence within the same device type in a new variable "dev_nu=
m".
> >
> > As in my earlier email, to avoid impact by other types of NICs, we shou=
ld put
> them
> > into different naming formats, like "vf*", "enP*", etc. And yes, these =
can be
> done in
> > udev.
> >
> > But for netvsc (synthetic) NICs, we still want the default naming forma=
t "eth*".
> And
> > the variable "dev_num" gives them the basis for stable naming with Asyn=
c
> probing.
> >
> > Thanks,
> > - Haiyang
> >
>=20
> The primary requirements for network naming are:
>   1. Network names must be repeatable on each boot. This was the original
> problem
>      that PCI devices discovered back years ago when parallel probing was
> enabled.
>   2. Network names must be predictable. If new VM is created, the names
> should
>      match a similar VM config.
>   3. Names must be persistent. If a NIC is added or deleted, the existing=
 names
>      must not change.
>=20
> The other things which are important (and this proposal breaks):
>   1. Don't break it principle: an existing VM should not suddenly get int=
erfaces
>      renamed if kernel is upgraded. A corrallary is that a lot of current=
 userspace
>      code expects eth0. It doesn't look like first interface would be gua=
ranteed
>      to be eth0.
>=20
>   2. No snowflakes principle: a device driver should follow the current p=
ractice
>      of other devices. For netvsc, this means VMBus should act like PCI a=
s much
>      as possible. Is there another driver doing this already?
>=20
>   3. Userspace policy principle: Every distribution has its own policy by=
 now.
>      The solution must make netvsc work reliably on Redhat (udev), Ubuntu
> (netplan), SuSE (Yast)
>      doing something in the kernel violates #2.
>=20
> My recommendation would be to take a multi-phase approach:
>   1. Expose persistent value in sysfs now.
>   2. Work with udev/netplan/... to use that value.
>   3. Make parallel VMBus probing an option. So that when distributions ha=
ve
> picked up
>      the udev changes they can enable parallel probe. Some will be quick =
to
> adopt
>      and the enterprise laggards can get to it when they feel the heat.
>=20
> Long term wish list (requires host side changes):
>    1. The interface index could be a host side property; the host network=
ing
>        already has the virtual device table and it is persistent.
>    2. The Azure NIC name should be visible as a property in guest.
>       Then userspace could do rename based on that property.
>       Having multiple disconnected names is leads to confusion.

Thank you for the detailed recommendations!
I will do the step 1. Expose persistent value in sysfs now.
And work on other changes in the future.

Thanks,
- Haiyang
