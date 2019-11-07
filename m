Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90490F3A01
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 22:03:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbfKGVDx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 16:03:53 -0500
Received: from mail-eopbgr30087.outbound.protection.outlook.com ([40.107.3.87]:43455
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725893AbfKGVDw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Nov 2019 16:03:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VBZGsVSkN9Au8tETujrsVzJDffSruavk4mUBf4wYdweQhehHUiPd9DPqY+qp8mP/+X65pYRlg81EX66HA7/F4L2lw4FgmZSaz7q4ZmptDaUURDG1HGOytjmCRlnLX8VCrEmQuJJgScfKTcSvI7pcEkc9yMsaotk2y5RBmRZ+FSj7D2xB/OXdLRJVlJFzeEvLjli+oQPYyV/miQXFQfOycPG+86GOPuUQZXywkbltNEUEp+6WxrFSfxVVC7ChBPtHVeELUarstHhUTP2NnNWDzlG6pXEBDrG4CFJVOzIboo0kh+tVMTdS33dDyJZWSSvbwVoyDFhSwxi15BBJauc6NA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1PJPHnovbBKgQHzVdIEbEWKHQdLo2KiMNLWMqDecjgo=;
 b=oYw5I52BAug6BmzcfXPIkYWC7gl242IAGMjtvf+Quqm7mn7sv5iSW3pBfpQiRgT0Me7J46qZotzntt6oLoS7HqH+7FD6RGuWywIUa9U4JUSaKAnSlBjZAAE/hzda9mRDB8H5K1qOBN9G9jsxGw5+Nme/jwWjG9TfYXj+Y14ZIExMWmpxyYmvwY+IIKcMgnXYqzwehHtxRwSZpSKS6pVqWA8AifSjrApJpvdc8mntxm4nlEuuyYA+l4F2YYToY4CHQlbUU9ArokVO9fv0TguTXwcsm4YDS3NgwFGHOqvLU/pdse1gh7qY4bdO/81CzPsJQOfgfU7rKzh00Fjzmq9Qiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1PJPHnovbBKgQHzVdIEbEWKHQdLo2KiMNLWMqDecjgo=;
 b=bYR3Bo43S2dfrjzqMBUywAhfCKwNJ3mJSsHcB2WQzYX4/tiQG6gtFE31oLNv8v8kETfyOJ7DNzVJHemqvq6dycbd9NLxuo8lw7RIw1KVKMB7xmDpa/iyN9xi2jeJ/bVXvjHY8LQO223zmxJwqvqLx03csQXQq+bcUBOZGf3/t4E=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB4690.eurprd05.prod.outlook.com (52.133.55.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Thu, 7 Nov 2019 21:03:09 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4%7]) with mapi id 15.20.2430.020; Thu, 7 Nov 2019
 21:03:09 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
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
Thread-Index: AQHVlYW+5ckj7/tyDUu1ocZ3bBFvo6eAK5wAgAAEe2A=
Date:   Thu, 7 Nov 2019 21:03:09 +0000
Message-ID: <AM0PR05MB4866963BE7BA1EE0831C9624D1780@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20191107160448.20962-1-parav@mellanox.com>
        <20191107160834.21087-1-parav@mellanox.com>
        <20191107160834.21087-12-parav@mellanox.com>
 <20191107153836.29c09400@cakuba.netronome.com>
In-Reply-To: <20191107153836.29c09400@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [208.176.44.194]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 261c235d-f4cc-488d-4bf2-08d763c5e4a9
x-ms-traffictypediagnostic: AM0PR05MB4690:|AM0PR05MB4690:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB4690611093F335DE2F31D2D3D1780@AM0PR05MB4690.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0214EB3F68
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(366004)(396003)(136003)(39860400002)(13464003)(189003)(199004)(71200400001)(6116002)(76176011)(478600001)(26005)(76116006)(316002)(2906002)(102836004)(86362001)(66066001)(66446008)(6916009)(186003)(54906003)(11346002)(64756008)(486006)(14454004)(6506007)(53546011)(446003)(66946007)(5660300002)(66476007)(476003)(8676002)(8936002)(6246003)(99286004)(33656002)(81166006)(229853002)(7696005)(256004)(305945005)(74316002)(6436002)(4326008)(55016002)(7736002)(52536014)(9686003)(25786009)(3846002)(81156014)(71190400001)(66556008);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4690;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: becxelRmcIksXwqsXf0ADeYnpCeChjDU4HK7LvtC0NmTHi0YVaE6xuDBKldsk05BJgfQ55ovZMp0zf80OvO7DgkCkwdxrUqe3taSGrGchZr7uFUKwNNaiPczhRtb4eOSBLTJ57K1/UqXhYs3972wlgbBorV1DDQM6oEYbGisylMdsb2t+LFqB+S/JYaIYNoDJSFLQB0+fD3WCSstAmWpr//UoBnVGAWycxcYPSeKOsocFxauiDrxcDyss4AwkmXeYSgBFh3FDm5F2D035LfsSI+6QDXlds68I6repxQ86NeNcRcfeLdRBKm3OkUvVVLwWe3WY23vgJr6+j97zER15FZEEfzxmzAd7vM8RPshBsmN0A354H5t/cROP5Ub72LFzQvWiUhZnrwB/RiCN8STOphKRaam6HXN2qKAyZa1fel4MlCU0gpBYZEiaol7vYMp
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 261c235d-f4cc-488d-4bf2-08d763c5e4a9
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2019 21:03:09.0662
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 74T06uCxi/hR/Xpas+f2E1MyrHXsRAbxXNf70rXSFtVIBg+m0NqBuTujToLT0QwahgjaNwCGm5yszXxkX0Qh7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4690
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: kvm-owner@vger.kernel.org <kvm-owner@vger.kernel.org> On Behalf
> Of Jakub Kicinski
> Sent: Thursday, November 7, 2019 2:39 PM
> To: Parav Pandit <parav@mellanox.com>
> Cc: alex.williamson@redhat.com; davem@davemloft.net;
> kvm@vger.kernel.org; netdev@vger.kernel.org; Saeed Mahameed
> <saeedm@mellanox.com>; kwankhede@nvidia.com; leon@kernel.org;
> cohuck@redhat.com; Jiri Pirko <jiri@mellanox.com>; linux-
> rdma@vger.kernel.org
> Subject: Re: [PATCH net-next 12/19] devlink: Introduce mdev port flavour
>=20
> On Thu,  7 Nov 2019 10:08:27 -0600, Parav Pandit wrote:
> > Introduce a new mdev port flavour for mdev devices.
> > PF.
> > Prepare such port's phys_port_name using unique mdev alias.
> >
> > An example output for eswitch ports with one physical port and one
> > mdev port:
> >
> > $ devlink port show
> > pci/0000:06:00.0/65535: type eth netdev p0 flavour physical port 0
> > pci/0000:06:00.0/32768: type eth netdev p1b0348cf880a flavour mdev
> > alias 1b0348cf880a
>=20
> Surely those devices are anchored in on of the PF (or possibly VFs) that =
should
> be exposed here from the start.
>=20
They are anchored to PCI device in this implementation and all mdev device =
has their parent device too.
However mdev devices establishes their unique identity at system level usin=
g unique UUID.
So prefixing it with pf0, will shorten the remaining phys_port_name letter =
we get to use.
Since we get unique 12 letters alias in a system for each mdev, prefixing i=
t with pf/vf is redundant.
In case of VFs, given the VF numbers can repeat among multiple PFs, and rep=
resentor can be over just one eswitch instance, it was necessary to prefix.
Mdev's devices parent PCI device is clearly seen in the PCI sysfs hierarchy=
, so don't prefer to duplicate it.

> > Signed-off-by: Parav Pandit <parav@mellanox.com>
>=20
> > @@ -6649,6 +6678,9 @@ static int
> __devlink_port_phys_port_name_get(struct devlink_port *devlink_port,
> >  		n =3D snprintf(name, len, "pf%uvf%u",
> >  			     attrs->pci_vf.pf, attrs->pci_vf.vf);
> >  		break;
> > +	case DEVLINK_PORT_FLAVOUR_MDEV:
> > +		n =3D snprintf(name, len, "p%s", attrs->mdev.mdev_alias);
>=20
> Didn't you say m$alias in the cover letter? Not p$alias?
>=20
In cover letter I described the naming scheme for the netdevice of the mdev=
 device (not the representor).
Representor follows current unique phys_port_name method.

> > +		break;
> >  	}
> >
> >  	if (n >=3D len)

