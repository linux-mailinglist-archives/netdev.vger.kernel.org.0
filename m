Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FF3FF3E19
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 03:31:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728415AbfKHCbH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 21:31:07 -0500
Received: from mail-eopbgr00060.outbound.protection.outlook.com ([40.107.0.60]:15620
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725928AbfKHCbH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Nov 2019 21:31:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cZWCLYZgrG4LU3NompQJzjzf3t+8ne4voTAFS+VyMJf9/be33e4t36kz6JnfQFeKOxPlP4bgxsSfnZ4/5D+SH5JG8oK9UcjUVeIDXSnECNVTUcBS/Nlh6DGX2Vf199I3gvDuuPICJtT7QFNtJASrlLBuLn/f0sQXxiBgCcf8UkIDkPtthL8KPqJqgi5en/Cj7oqv6jS/nXqdcZEHUlvM8LtwmYD1kA2StmF394V4I0npNIcmRF1Myrk1b6s4JbVThfu2oARugMEG4L/G+8EkH04LW6+wc1pPhnomCkc8gix2gRtkI3GWo46J8goqhpd+f6wQ3rmgo9NBMxdUR3UqBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x94Qy8cJQV7ZeHa8iQi+qaoJ5w4dEHmUZZ0w+ue/Gr4=;
 b=jOKGPa+53+FGi59NRtTW8z6IpTt4tCAu+8xt/QRma5Ku8D7Iz+bFqcYljotyf5TBWYRP2fj7UNWyIyrWaVR7cRf/lm0TS5VedZPUetLlP6ZksmLZGKl0tM/vN4FKXg4UoMzO76Jz7bgJBl/kYc6dI6KdVToGKcD0SEvCM2jQwXM801LdciZ4Vj6zgyU8o8kNlrh5npXzMz94s86Tu2Z0oevNjFUIY4Ebm40sN8ZkGzE2UBBAsjA47u6d1qL4VTqVYsBhZiuq04HCT3QhEv2srh1pviH0LkJUP/7k4/L1VG5xoX/+TodNCWplnNjTqRjoRy819B/VXYwGS9LbsVNYlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x94Qy8cJQV7ZeHa8iQi+qaoJ5w4dEHmUZZ0w+ue/Gr4=;
 b=X+hNPcyabZWUUHsk6c0S1TN7MEnqeabxOkvaQYzVpVIR5keEubXfXVECZ3xM13CNXUYlvjo9+7TUSePQMK+Tde+ZGSgoAez1VTQuUw+bcE/EQEu3b720hKADi1gP1//PI9N2KymL9eXALEVUiCkBPHNhKYIhVube4nzOll5RNbA=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB4420.eurprd05.prod.outlook.com (52.134.91.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Fri, 8 Nov 2019 02:31:02 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4%7]) with mapi id 15.20.2430.020; Fri, 8 Nov 2019
 02:31:02 +0000
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
Thread-Index: AQHVlYW+5ckj7/tyDUu1ocZ3bBFvo6eAK5wAgAAEe2CAAEmKAIAAA1+ggAAOHACAAAFAIA==
Date:   Fri, 8 Nov 2019 02:31:02 +0000
Message-ID: <AM0PR05MB4866C0798EA5746EE23F2D2BD17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20191107160448.20962-1-parav@mellanox.com>
        <20191107160834.21087-1-parav@mellanox.com>
        <20191107160834.21087-12-parav@mellanox.com>
        <20191107153836.29c09400@cakuba.netronome.com>
        <AM0PR05MB4866963BE7BA1EE0831C9624D1780@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20191107201750.6ac54aed@cakuba>
        <AM0PR05MB4866BEC2A2B586AA72BAA9ABD17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191107212024.61926e11@cakuba>
In-Reply-To: <20191107212024.61926e11@cakuba>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [2605:6000:ec82:1c00:4df9:9131:e74:fff7]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d3e5919c-f7bb-46af-65e3-08d763f3b2cc
x-ms-traffictypediagnostic: AM0PR05MB4420:|AM0PR05MB4420:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB44209488F8A63BDD88F8ACF8D17B0@AM0PR05MB4420.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0215D7173F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(366004)(396003)(346002)(376002)(13464003)(199004)(189003)(74316002)(99286004)(6916009)(305945005)(76176011)(186003)(256004)(5024004)(55016002)(6246003)(4326008)(9686003)(6436002)(229853002)(7696005)(5660300002)(52536014)(66946007)(64756008)(76116006)(7736002)(446003)(71190400001)(11346002)(66556008)(66446008)(66476007)(316002)(54906003)(476003)(71200400001)(2906002)(8936002)(81156014)(14454004)(6506007)(486006)(33656002)(102836004)(53546011)(86362001)(46003)(478600001)(8676002)(25786009)(6116002)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4420;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EMwGKU6SG9YCbiaNUQfCkBpAv7KYNCA1qXBR1hu9JtcU9ylOXeWDJ4iCxiBwNcOLYIULEquy4TYTRgyI/c/CYGWD6oOIMTi1K6KksOLIBGdTUsgEckyDp5MR9fhsZiAZTYtkdKtPayBPxjoERCfW2G3VRzO1SCU5kHh+kuyq3xqr3BgidyZw8L7XgVkC0VMZhZBc3tKTi8dtMnFLVcL9M0BQSG/EMEKL5R3lznxSpTS6FVzsam+gsUAPAOGbjHBY9It7MmE+Fd4G0ICdJM1Rt/yKqgLingj8IRPcbPB3wLEpjF8UU9X7C8KAGuUl0s1I6LxaWSBFiaRUkt2Jb7/rFPLX4UqS/bKCDDdI+XV5aK3LQ7rM4N70olfjiQlZfW6r80ytBoz8gcOaV8ggNus8CbqyNqeQWVcBvEv3xTZTSZ4G5+X799lfo1dx3vZCt8Wr
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3e5919c-f7bb-46af-65e3-08d763f3b2cc
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2019 02:31:02.2588
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uT98BGm+vnqI7H4ZhXKd8PC0pLDApBz90ZajQyAXLMOWzX/tu3Qbyxg1arVAhXDIu8cbdJNAgm+QCLWt2ueJWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4420
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <jakub.kicinski@netronome.com>
> Sent: Thursday, November 7, 2019 8:20 PM
> To: Parav Pandit <parav@mellanox.com>
> Cc: alex.williamson@redhat.com; davem@davemloft.net;
> kvm@vger.kernel.org; netdev@vger.kernel.org; Saeed Mahameed
> <saeedm@mellanox.com>; kwankhede@nvidia.com; leon@kernel.org;
> cohuck@redhat.com; Jiri Pirko <jiri@mellanox.com>; linux-
> rdma@vger.kernel.org
> Subject: Re: [PATCH net-next 12/19] devlink: Introduce mdev port flavour
>=20
> On Fri, 8 Nov 2019 01:44:53 +0000, Parav Pandit wrote:
> > > I'm talking about netlink attributes. I'm not suggesting to sprintf
> > > it all into the phys_port_name.
> > >
> > I didn't follow your comment. For devlink port show command output you
> > said,
> >
> > "Surely those devices are anchored in on of the PF (or possibly VFs)
> > that should be exposed here from the start."
> > So I was trying to explain why we don't expose PF/VF detail in the
> > port attributes which contains
> > (a) flavour
> > (b) netdev representor (name derived from phys_port_name)
> > (c) mdev alias
> >
> > Can you please describe which netlink attribute I missed?
>=20
> Identification of the PCI device. The PCI devices are not linked to devli=
nk
> ports, so the sysfs hierarchy (a) is irrelevant, (b) may not be visible i=
n multi-
> host (or SmartNIC).
>

It's the unique mdev device alias. It is not right to attach to the PCI dev=
ice.
Mdev is bus in itself where devices are identified uniquely. So an alias su=
ffice that identity.

> > > > > > Signed-off-by: Parav Pandit <parav@mellanox.com>
> > > > >
> > > > > > @@ -6649,6 +6678,9 @@ static int
> > > > > __devlink_port_phys_port_name_get(struct devlink_port
> > > > > *devlink_port,
> > > > > >  		n =3D snprintf(name, len, "pf%uvf%u",
> > > > > >  			     attrs->pci_vf.pf, attrs->pci_vf.vf);
> > > > > >  		break;
> > > > > > +	case DEVLINK_PORT_FLAVOUR_MDEV:
> > > > > > +		n =3D snprintf(name, len, "p%s", attrs-
> >mdev.mdev_alias);
> > > > >
> > > > > Didn't you say m$alias in the cover letter? Not p$alias?
> > > > >
> > > > In cover letter I described the naming scheme for the netdevice of
> > > > the mdev device (not the representor). Representor follows current
> > > > unique phys_port_name method.
> > >
> > > So we're reusing the letter that normal ports use?
> > >
> > I initially had 'm' as prefix to make it easy to recognize as mdev's po=
rt,
> instead of 'p', but during internal review Jiri's input was to just use '=
p'.
>=20
> Let's way for Jiri to weigh in then.

Yeah.
I remember his point was to not confuse the <en><m> prefix in the persisten=
t device name with 'm' prefix in phys_port_name.
Hence, his input was just 'p'.

>=20
> > > Why does it matter to name the virtualized device? In case of other
> > > reprs its the repr that has the canonical name, in case of
> > > containers and VMs they will not care at all what hypervisor identifi=
er
> the device has.
> > >
> > Well, many orchestration framework probably won't care of what name is
> picked up.
> > And such name will likely get renamed to eth0 in VM or container.
> > Unlike vxlan, macvlan interfaces, user explicitly specify the netdevice=
 name,
> and when newlink() netlink command completes with success, user know the
> device to use.
> > If we don't have persistent name for mdev, if a random name ethX is
> picked up, user needs refer to sysfs device hierarchy to know its netdev.
> > Its super easy to do refer that, but having persistent name based out o=
f
> alias makes things aligned like naming device on PCI bus.
> > This way devices can be used without VM/container use cases too, for
> example user is interested in only 4 or 8 mdev devices in system and its
> setup is done through systemd.service.
