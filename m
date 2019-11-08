Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55C2AF500D
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 16:42:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727340AbfKHPmm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 10:42:42 -0500
Received: from mail-eopbgr20069.outbound.protection.outlook.com ([40.107.2.69]:3196
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726537AbfKHPml (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 10:42:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E2nswGxE2RMJQ2oLOjyard58b/DNuuqmI3X5sX2krBoSOsqmaF0mE1sZQpeSOQawUDckDYk5eINtV5XPmY1CUZ3MLS8m1jjefF4e0rL9fbHnrjHQ6TeNomBhOlifg+Tej0OnMfR4NYbrMTL4ZY3sjCMS9dSmj7fdooTPyIFJ4tgJN/6Yd/8XidVOqQ4ROv6xhNiXt06/R50I1n18fRTYghY5TPzLfyV+D/V7xysnpb5CvjsG6EoT7GZDuUiMF8P9h8Cjf+wQx7wCQsuvPPOgqo/KEhYSvFw44z5yVmoQi4Nr0OE/Mze8Z5xAaOiShB8PRut1XXR/P2hWWdH5b0VY2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CyyLh9lHGAfQOy4xkOg7lERfB5wVpc5MHiQfX5J++oE=;
 b=f3j5Tm22QTRyrhL+WTAnPQsmpZoCXafJoEZkSK5wGwDBxdWQSUiut1whnihKRwusFvjLdNOLj4GVVenHSJkeFV5CBrM5+MaCDU4ZoSh1RNoDfhhahdtAmqjE9QLZQiWGR40UvXMMgWjsOFapz81qMiI+BhJbBIq3PRhORESGP7hk/qeEdJ2JvcE1HdMfBuV+h4PBj1Wzg3d6WbKc1WXLhaniC2jdwOfObYEXMC75cncEttKc+7bCc0CJkvBYEygEI2/qGy51NIqGf37DGe3ng4BhzeXzKWT0dwc9v689uzzsKBBpM4PP5fjDTDnY9TC98W4PSHNWltlLeRy4bZp4Rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CyyLh9lHGAfQOy4xkOg7lERfB5wVpc5MHiQfX5J++oE=;
 b=hRSUU1rfz2dtmEY/Or0BNDK2w9nsW/0dwYpGlNkrKa2Nzsv0H5wL7xfoWLJs9Q+e3cT37XOM2Ii8JBwhTpAIw7z1RMZoJoXieV6OKUdksIJAA9xE6vq0AJrh08P9NC7OuWZ8j6KmBi6F8TZlASVB2O6rvGBR9U3DFbR+ZTKavOM=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB5140.eurprd05.prod.outlook.com (20.178.19.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Fri, 8 Nov 2019 15:41:58 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4%7]) with mapi id 15.20.2430.020; Fri, 8 Nov 2019
 15:41:57 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: RE: [PATCH net-next 12/19] devlink: Introduce mdev port flavour
Thread-Topic: [PATCH net-next 12/19] devlink: Introduce mdev port flavour
Thread-Index: AQHVlYW+5ckj7/tyDUu1ocZ3bBFvo6eAK5wAgAAEe2CAAEmKAIAAA1+ggAAOHACAAHgIgIAAZ9CA
Date:   Fri, 8 Nov 2019 15:41:57 +0000
Message-ID: <AM0PR05MB4866D31D34141C85E72D4180D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20191107160448.20962-1-parav@mellanox.com>
 <20191107160834.21087-1-parav@mellanox.com>
 <20191107160834.21087-12-parav@mellanox.com>
 <20191107153836.29c09400@cakuba.netronome.com>
 <AM0PR05MB4866963BE7BA1EE0831C9624D1780@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191107201750.6ac54aed@cakuba>
 <AM0PR05MB4866BEC2A2B586AA72BAA9ABD17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191107212024.61926e11@cakuba> <20191108093001.GA6990@nanopsycho>
In-Reply-To: <20191108093001.GA6990@nanopsycho>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [2605:6000:ec82:1c00:9dfd:71f9:eb37:f669]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 04121416-2c09-496b-f069-08d764623083
x-ms-traffictypediagnostic: AM0PR05MB5140:|AM0PR05MB5140:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB5140DBBE629C98C4CDEAEEFED17B0@AM0PR05MB5140.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1417;
x-forefront-prvs: 0215D7173F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(136003)(376002)(396003)(366004)(189003)(13464003)(199004)(305945005)(53546011)(8676002)(9686003)(6506007)(316002)(81166006)(81156014)(102836004)(99286004)(25786009)(8936002)(52536014)(186003)(476003)(110136005)(6436002)(66446008)(64756008)(66476007)(54906003)(4326008)(66946007)(5660300002)(55016002)(66556008)(229853002)(76116006)(256004)(6116002)(7736002)(7696005)(74316002)(6246003)(76176011)(14454004)(11346002)(33656002)(46003)(478600001)(7416002)(486006)(2906002)(71190400001)(86362001)(71200400001)(446003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB5140;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Bx+Pg3EwX4cKBj7ONclg1cfqLYGzj3KR/aiFa4Xq2d58goGMGSyv5inoMV53bX6TfGbHIEtc9CQEYMYuZrpWL01xiPmjQsal8pZr/bh8Cu9RZhZpqTrWHWvcwS+82y12Y5n1hC8QbdBh2MIdMz5Gis5WQ3Dmd2eDOcM2Q4ZPsIcnkzPuoDCnstEiFRAX5BKR5wIyC/QtR5PR5QrdLdidb//e4jli+eN34AzyUHRXSw0ioLveVG70jSj8OkPUVt7P3XKbh/x4e+V7IItsX0fCVBAhQFbcD86+0PIzMvxoHGI/MWygol24HTiJqwXogoZx0Q0LshFX8bh0BkU10H6k9qtHueZ2Lv1lnd6eN/GkMcIh1jESLjskRIkEJM9wPc1/CMxseXYWT7N10bA+OFfHFnO0O93vRKDo+pxwYQutjmvoE+MzbaqzNWiDXYCc6lmA
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04121416-2c09-496b-f069-08d764623083
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2019 15:41:57.8690
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DxbVYoeyDHUsfVeUAQbjPNHzPQgUEGq/0E1D0QNedWlDDQNaQDJPTRx6Z56KbbeG+KWa6o8ZC04iV1gVqLIMAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5140
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jiri Pirko <jiri@resnulli.us>
> Sent: Friday, November 8, 2019 3:30 AM
> To: Jakub Kicinski <jakub.kicinski@netronome.com>
> Cc: Parav Pandit <parav@mellanox.com>; alex.williamson@redhat.com;
> davem@davemloft.net; kvm@vger.kernel.org; netdev@vger.kernel.org;
> Saeed Mahameed <saeedm@mellanox.com>; kwankhede@nvidia.com;
> leon@kernel.org; cohuck@redhat.com; Jiri Pirko <jiri@mellanox.com>; linux=
-
> rdma@vger.kernel.org
> Subject: Re: [PATCH net-next 12/19] devlink: Introduce mdev port flavour
>=20
> Fri, Nov 08, 2019 at 03:20:24AM CET, jakub.kicinski@netronome.com wrote:
> >On Fri, 8 Nov 2019 01:44:53 +0000, Parav Pandit wrote:
>=20
> [...]
>=20
> >> > > > > @@ -6649,6 +6678,9 @@ static int
> >> > > > __devlink_port_phys_port_name_get(struct devlink_port
> >> > > > *devlink_port,
> >> > > > >  		n =3D snprintf(name, len, "pf%uvf%u",
> >> > > > >  			     attrs->pci_vf.pf, attrs->pci_vf.vf);
> >> > > > >  		break;
> >> > > > > +	case DEVLINK_PORT_FLAVOUR_MDEV:
> >> > > > > +		n =3D snprintf(name, len, "p%s", attrs-
> >mdev.mdev_alias);
> >> > > >
> >> > > > Didn't you say m$alias in the cover letter? Not p$alias?
> >> > > >
> >> > > In cover letter I described the naming scheme for the netdevice
> >> > > of the mdev device (not the representor). Representor follows
> >> > > current unique phys_port_name method.
> >> >
> >> > So we're reusing the letter that normal ports use?
> >> >
> >> I initially had 'm' as prefix to make it easy to recognize as mdev's p=
ort,
> instead of 'p', but during internal review Jiri's input was to just use '=
p'.
> >
> >Let's way for Jiri to weigh in then.
>=20
> Hmm, it's been so far I can't really recall. But looking at what we have
> now:
> DEVLINK_PORT_FLAVOUR_PHYSICAL "p%u"/"p%us%u"
> DEVLINK_PORT_FLAVOUR_PCI_PF   "pf%u"
> DEVLINK_PORT_FLAVOUR_PCI_VF   "pf%uvf%u"
> For mdev, the ideal format would be:
> "pf%um%s" or "pf%uvf%um%s", but that would be too long.
> I guess that "m%s" is fine.
> "p" is probably not a good idea as phys ports already have that.
>=20
> [...]
Ok. I will revise to use "m%s".
Thanks.
