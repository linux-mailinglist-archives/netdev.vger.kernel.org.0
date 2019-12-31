Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B90AE12DA2E
	for <lists+netdev@lfdr.de>; Tue, 31 Dec 2019 17:12:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbfLaQMl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Dec 2019 11:12:41 -0500
Received: from mail-co1nam11on2109.outbound.protection.outlook.com ([40.107.220.109]:50689
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727071AbfLaQMl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Dec 2019 11:12:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mfpMXs7L8ZyZtu3yrPtfPephUmqBb4UItFIIeDEGWT3yd1LYueTO/IO3uqVtY/kz3Wtw1pXlQILHGcqGN5gg28+FQMLxO/O3TfMBeH3rCN+Jbp0WmM3cfxM1QcDV92lkK6G+XmADB60tAh3Nih1zzxO8aTUYtAvKUONmqPLvz6455JtYnr/neSfkJ9t9ryONCFsDySxr8NIeRmuXOdyGFDWoHLBix/etjacMunq0ftT6lZEfrYJtHO4ngzsGjBwm9Z2tPmUH96g7bjrp/A3S9lf/Pkcp8YV5rqZd/XB5csG9B9Lhv5Ydm+j5RvZ/PTKac1BTkG6TZI6FGJSogWViiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DFcOrsJWnhnWYE1Bm2mQ89IikbOPI+LdbnjuXoMNZUU=;
 b=fk91IKmEXZPmYrI5+GwfkzJdUCOJaNBKwnYuRWO/mvA1vDuKAJYRUDMsk7wEMTrSzj870K2dfvwM3FbXjxMex83th/CFyTGgOnfoNK0w4wAMMt9H2Z1/KdE1Q8tHDhxWklvjWm9Eodvwn+RP7wisNo0SRWArKA2wFNfwJpg4EffbQeZIx+7KBtZriUTxW2Zi9XllqtLaBhl7yOOpDj4nqiGRseCkQpKxPmifSn7nfRm2KHWoSVQgSu0UK6sfKluf8S819jLl/lFG3O1KGqtzv3HTgWMHLDH9TmUUTtCTwVbd9tjgnafH6rIh7ciosh6lYOWEQgUHkKrH8EZF6MxJuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DFcOrsJWnhnWYE1Bm2mQ89IikbOPI+LdbnjuXoMNZUU=;
 b=IFjjpyeFG+agROQP5Z/qmHFNTQyVSzR100qtA7/OTEF/MAH1sFh/tqvYVYA3sA2xUWeCKjygSWhTmOJ3o7WnngoxCyvmZoBU4Sox1+KSDoZZA5/5OhbHOh9tOAv2CLxeAvX08+LJCJ2NoPKfcfwcdT2IjdJ/Sz733vLGPlpHzAk=
Received: from MN2PR21MB1375.namprd21.prod.outlook.com (20.179.23.160) by
 MN2PR21MB1215.namprd21.prod.outlook.com (20.179.20.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.8; Tue, 31 Dec 2019 16:12:36 +0000
Received: from MN2PR21MB1375.namprd21.prod.outlook.com
 ([fe80::6de3:c062:9e55:ffc4]) by MN2PR21MB1375.namprd21.prod.outlook.com
 ([fe80::6de3:c062:9e55:ffc4%5]) with mapi id 15.20.2623.002; Tue, 31 Dec 2019
 16:12:36 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Roman Kagan <rkagan@virtuozzo.com>
CC:     "sashal@kernel.org" <sashal@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>, vkuznets <vkuznets@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH V2,net-next, 3/3] hv_netvsc: Name NICs based on vmbus
 offer sequence and use async probe
Thread-Topic: [PATCH V2,net-next, 3/3] hv_netvsc: Name NICs based on vmbus
 offer sequence and use async probe
Thread-Index: AQHVv027GHCeFuKLhUO4V+gfj0XECKfUHfwAgABK1lA=
Date:   Tue, 31 Dec 2019 16:12:36 +0000
Message-ID: <MN2PR21MB1375D41039A8A68A2117DDFCCA260@MN2PR21MB1375.namprd21.prod.outlook.com>
References: <1577736814-21112-1-git-send-email-haiyangz@microsoft.com>
 <1577736814-21112-4-git-send-email-haiyangz@microsoft.com>
 <20191231113440.GA380228@rkaganb.sw.ru>
In-Reply-To: <20191231113440.GA380228@rkaganb.sw.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=haiyangz@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-12-31T16:12:35.0522984Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=4b094d31-eadc-468c-a104-560efbd636a0;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=haiyangz@microsoft.com; 
x-originating-ip: [96.61.92.94]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 7b083eab-7ba7-40c9-9d05-08d78e0c406a
x-ms-traffictypediagnostic: MN2PR21MB1215:|MN2PR21MB1215:|MN2PR21MB1215:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MN2PR21MB12153412C5C71AFF16615EB0CA260@MN2PR21MB1215.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0268246AE7
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(346002)(376002)(136003)(396003)(366004)(13464003)(199004)(189003)(66446008)(66946007)(64756008)(66556008)(66476007)(81166006)(8936002)(8676002)(81156014)(33656002)(10290500003)(4326008)(9686003)(55016002)(5660300002)(71200400001)(54906003)(76116006)(316002)(8990500004)(2906002)(6916009)(52536014)(6506007)(186003)(7696005)(478600001)(86362001)(26005)(53546011);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR21MB1215;H:MN2PR21MB1375.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: reKVrnE/IFhKI/yltPr9es2FQS+C1eBSnS/kP4a2UKDhCxWOYSBbMhH2vI5bMSjzMsNtoluZJsLk7qmIDmR0EqCHmeKZE5OvPlrYUrcobofA+6wZiuxvKMB1uREb4XUy2UyV5hRo4O0Ue2Ha+m5S9szmVoSZ4+qedUAZAFUhTWbt5IASrlMdvL8rtD34T14wnPFcJEMkGQHXSeOZpNbZmHlNHYI5gwALg/J+f1/0w9jVixil+8epNWsVb/2xl1tudJ1IrExZp0loJKxKTAYp6IloWDWmd9l9j9l5Z2atw2jPorJ3Zg8+3I/uom0DiSOJuv2mUYkd3AeRmHWZmjuhiX2BEF90DSEGez7pFTl79W/lOzkvIiBQN8eE0mFf5V1vRXj6XlT33uDS7ugHO5GBlA4KbiiM4R5gelv11AyfNNs7Njj516848XaUE+TaccYmBaB74pEvpXtFqL+MmHZe/WTPpRJVVIRH3NUr3bnvxOJaYGCwJvsvYUZr98oxFhre
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b083eab-7ba7-40c9-9d05-08d78e0c406a
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Dec 2019 16:12:36.5346
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tlH+l21cTlzIAzjJs2gJzOo4/jeJF1T2JSvjUHdaxgqwiuWRaeJJs+93ud1+opWT+/yn+EUBs0lLHenvo5FuVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR21MB1215
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Roman Kagan <rkagan@virtuozzo.com>
> Sent: Tuesday, December 31, 2019 6:35 AM
> To: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: sashal@kernel.org; linux-hyperv@vger.kernel.org; netdev@vger.kernel.o=
rg;
> KY Srinivasan <kys@microsoft.com>; Stephen Hemminger
> <sthemmin@microsoft.com>; olaf@aepfle.de; vkuznets
> <vkuznets@redhat.com>; davem@davemloft.net; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH V2,net-next, 3/3] hv_netvsc: Name NICs based on vmbus
> offer sequence and use async probe
>=20
> On Mon, Dec 30, 2019 at 12:13:34PM -0800, Haiyang Zhang wrote:
> > The dev_num field in vmbus channel structure is assigned to the first
> > available number when the channel is offered. So netvsc driver uses it
> > for NIC naming based on channel offer sequence. Now re-enable the
> > async probing mode for faster probing.
> >
> > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > ---
> >  drivers/net/hyperv/netvsc_drv.c | 18 +++++++++++++++---
> >  1 file changed, 15 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/net/hyperv/netvsc_drv.c
> > b/drivers/net/hyperv/netvsc_drv.c index f3f9eb8..39c412f 100644
> > --- a/drivers/net/hyperv/netvsc_drv.c
> > +++ b/drivers/net/hyperv/netvsc_drv.c
> > @@ -2267,10 +2267,14 @@ static int netvsc_probe(struct hv_device *dev,
> >  	struct net_device_context *net_device_ctx;
> >  	struct netvsc_device_info *device_info =3D NULL;
> >  	struct netvsc_device *nvdev;
> > +	char name[IFNAMSIZ];
> >  	int ret =3D -ENOMEM;
> >
> > -	net =3D alloc_etherdev_mq(sizeof(struct net_device_context),
> > -				VRSS_CHANNEL_MAX);
> > +	snprintf(name, IFNAMSIZ, "eth%d", dev->channel->dev_num);
>=20
> How is this supposed to work when there are other ethernet device types o=
n the
> system, which may claim the same device names?
>=20
> > +	net =3D alloc_netdev_mqs(sizeof(struct net_device_context), name,
> > +			       NET_NAME_ENUM, ether_setup,
> > +			       VRSS_CHANNEL_MAX, VRSS_CHANNEL_MAX);
> > +
> >  	if (!net)
> >  		goto no_net;
> >
> > @@ -2355,6 +2359,14 @@ static int netvsc_probe(struct hv_device *dev,
> >  		net->max_mtu =3D ETH_DATA_LEN;
> >
> >  	ret =3D register_netdevice(net);
> > +
> > +	if (ret =3D=3D -EEXIST) {
> > +		pr_info("NIC name %s exists, request another name.\n",
> > +			net->name);
> > +		strlcpy(net->name, "eth%d", IFNAMSIZ);
> > +		ret =3D register_netdevice(net);
> > +	}
>=20
> IOW you want the device naming to be predictable, but don't guarantee thi=
s?
>=20
> I think the problem this patchset is trying to solve is much better solve=
d with a
> udev rule, similar to how it's done for PCI net devices.
> And IMO the primary channel number, being a device's "hardware"
> property, is more suited to be used in the device name, than this complet=
ely
> ephemeral device number.

The vmbus number can be affected by other types of devices and/or subchanne=
l
offerings. They are not stable either. That's why this patch set keeps trac=
k of the=20
offering sequence within the same device type in a new variable "dev_num".

As in my earlier email, to avoid impact by other types of NICs, we should p=
ut them
into different naming formats, like "vf*", "enP*", etc. And yes, these can =
be done in
udev.

But for netvsc (synthetic) NICs, we still want the default naming format "e=
th*". And
the variable "dev_num" gives them the basis for stable naming with Async pr=
obing.

Thanks,
- Haiyang

