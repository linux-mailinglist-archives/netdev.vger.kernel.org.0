Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28FBFF5164
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 17:44:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727033AbfKHQo1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 11:44:27 -0500
Received: from mail-eopbgr40051.outbound.protection.outlook.com ([40.107.4.51]:23463
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726095AbfKHQo1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 11:44:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a84yxZBxzPtxNX9Vo2kDKM143JEW4C6pXXa7VkdwfE91rYV3dfDmC353t5iGsr5ByorCgJD+wrGXttDJSRwhELGWb3sJMUDpv3C5XJ9P0lqIUMFxpTCh1Oue85JEInP4XVUBo0blhhosYsHBO+GHJK5wQX1uP3TKQs6xU7IehRut0z5+5xAil8afljvzDVIdVefgM89Fs4PY6Fqn2fM2d3zEBMF23SBFD/ZFshEiCZw9EyjBNJTPXuTHBpo1OUrYRPhv5QEbhF5wYhsg1ATR71eEZ41NPT97XGGNE+rlFFuERMwh9u1ZNAEgWE0Yd6SMSSLBtS8u6n0MRLkhFAOaiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jSjMRTdqrq+6u2kNutGNTtHjdyHl9eHejNHj8hH/NyU=;
 b=AnX7oQ+acDZcpCzLCcyRdYAdJqRYmEXb5gRhi3tPtCvFTkRTdVjURsINi/VRogKusXdXXuobfQcpeOsO5X5lkrk9UXUvhMJKK65dN+K9GFDL0dPFkHY1PqheV3HnE8Wwtn7XjSG0a9beCfc9QCDxNiCUHNDOD5Ph2SEmEI++L4DNY2qDV+N0hMHhrPz1JjvXEXwmNlVRihhUq760Ii5q9vW2+51Joe4CRK8khc5aXJ1uk+MS4fLvCIIG0DJI3o5mIV5QfTTXdEZTWe3Dp9fEyOjh1PCzTzCLrKV8duKOcboYSo1X9xmr6ih9wILdikuP/D+E/7hIagOz4CO33zr0Gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jSjMRTdqrq+6u2kNutGNTtHjdyHl9eHejNHj8hH/NyU=;
 b=YIFyGoOJDKkKfBhVdpvbv57rfhuQmczot087Wl+WvkQDejTItvgFv166PATxTovHVai93+1J7+3CXUL4oQfQlHEuhZXpEfIlEe8N207DKDt6SZ0Ih+2giWZ7VbSVugMrD4Sv9mJDw0dTxRCIz4aFo5E9K08Hyo+OM2nzJYGKqh4=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB6049.eurprd05.prod.outlook.com (20.178.202.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Fri, 8 Nov 2019 16:43:43 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4%7]) with mapi id 15.20.2430.020; Fri, 8 Nov 2019
 16:43:43 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Jiri Pirko <jiri@resnulli.us>
CC:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
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
Thread-Index: AQHVlYW+5ckj7/tyDUu1ocZ3bBFvo6eAK5wAgAAEe2CAAEmKAIAAA1+ggAAOHACAAAFAIIAAe3YAgABjcxCAAA2tgIAAAeXA
Date:   Fri, 8 Nov 2019 16:43:43 +0000
Message-ID: <AM0PR05MB48669A9AE494CCCE8E07C367D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20191107160834.21087-1-parav@mellanox.com>
 <20191107160834.21087-12-parav@mellanox.com>
 <20191107153836.29c09400@cakuba.netronome.com>
 <AM0PR05MB4866963BE7BA1EE0831C9624D1780@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191107201750.6ac54aed@cakuba>
 <AM0PR05MB4866BEC2A2B586AA72BAA9ABD17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191107212024.61926e11@cakuba>
 <AM0PR05MB4866C0798EA5746EE23F2D2BD17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191108094646.GB6990@nanopsycho>
 <AM0PR05MB4866969D18877C7AAD19D236D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191108163139.GQ6990@nanopsycho>
In-Reply-To: <20191108163139.GQ6990@nanopsycho>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [2605:6000:ec82:1c00:9dfd:71f9:eb37:f669]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 39c6e869-a1e5-4204-2f94-08d7646ad110
x-ms-traffictypediagnostic: AM0PR05MB6049:|AM0PR05MB6049:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB6049B082AAF0D98460DAEB80D17B0@AM0PR05MB6049.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0215D7173F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(39860400002)(376002)(136003)(396003)(13464003)(189003)(199004)(9686003)(229853002)(74316002)(102836004)(6916009)(305945005)(46003)(99286004)(446003)(476003)(33656002)(316002)(14454004)(7736002)(486006)(11346002)(76176011)(86362001)(186003)(8936002)(25786009)(256004)(7696005)(7416002)(6246003)(6116002)(478600001)(54906003)(6506007)(81156014)(81166006)(52536014)(5024004)(71200400001)(71190400001)(76116006)(4326008)(6436002)(66556008)(64756008)(66446008)(66946007)(55016002)(5660300002)(8676002)(66476007)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB6049;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 83ipESw0173vCNBR4DsrbQ3YODHqjirECLTbbGkMUUrtRFuADKOq4p16kiNIgkNSbsBrC2LWSSrHJpR1aMU45ls0WcU2EJDlCOIJKF8G/jmIbPQx7++yyb609lGZV7tzvIN1qmKjOuuPX6lpvAA5b/YvEXSeKRD/Neko9eXHfaURqWl4JKNntFnwsdjOMozTHAA07bMZFXTjaONUxx/YdZkiQKj8nk5iSXJrklVs9iIV2A8wv23FNAJID1DjgRqCGSJoHofia+Hvd3EPB30UBO5ESKzN56c4EZjJSBqYJnfivyShJEe+yvUhf+NmU5Fqi1KTBV3qFQxj0HdNuLwlV2I7P5fWkzHYnyv+9pOhLOPd90hm2M72BZoYn3OReAszSsTKbcLQWvI2VP57F2JanI4F9lk1Cb1G/r0g01lnwENphMoRQ1gp8AeWBfZ4Nyub
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39c6e869-a1e5-4204-2f94-08d7646ad110
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2019 16:43:43.1475
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JFnBOJZdceitpZaH9Q2Xld4EOAdvDrkOD8WZG6XkoYGy4zqvDeu7xGJwwY3ql2FYOPK/Lr12EQtMkTpAIq31wg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6049
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jiri Pirko <jiri@resnulli.us>
> >> >> On Fri, 8 Nov 2019 01:44:53 +0000, Parav Pandit wrote:
> >> >> > > I'm talking about netlink attributes. I'm not suggesting to
> >> >> > > sprintf it all into the phys_port_name.
> >> >> > >
> >> >> > I didn't follow your comment. For devlink port show command
> >> >> > output you said,
> >> >> >
> >> >> > "Surely those devices are anchored in on of the PF (or possibly
> >> >> > VFs) that should be exposed here from the start."
> >> >> > So I was trying to explain why we don't expose PF/VF detail in
> >> >> > the port attributes which contains
> >> >> > (a) flavour
> >> >> > (b) netdev representor (name derived from phys_port_name)
> >> >> > (c) mdev alias
> >> >> >
> >> >> > Can you please describe which netlink attribute I missed?
> >> >>
> >> >> Identification of the PCI device. The PCI devices are not linked
> >> >> to devlink ports, so the sysfs hierarchy (a) is irrelevant, (b)
> >> >> may not be visible in multi- host (or SmartNIC).
> >> >>
> >> >
> >> >It's the unique mdev device alias. It is not right to attach to the P=
CI
> device.
> >> >Mdev is bus in itself where devices are identified uniquely. So an
> >> >alias
> >> suffice that identity.
> >>
> >> Wait a sec. For mdev, what you say is correct. But here we talk about
> >> devlink_port which is representing this mdev. And this devlink_port
> >> is very similar to VF devlink_port. It is bound to specific PF (in
> >> case of mdev it could be PF-VF).
> >>
> >But mdev port has unique phys_port_name in system, it incorrect to use
> PF/VF prefix.
>=20
> Why incorrect? It is always bound to pf/vf?
>=20
Because mdev device already identified using its unique alias. Why does it =
need prefix?
Mdev core generating the alias is not aware of the prefixes applied devlink=
. it shouldn't be.
We want more letters towards uniqueness of the alias and filling it up with=
 such prefixes doesn't make sense.

> >What in hypothetical case, mdev is not on top of PCI...
>=20
> Okay, let's go hypothetical. In that case, it is going to be on top of so=
mething
> else, wouldn't it?
Yes, it will be. But just because it is on top of something, doesn't mean w=
e include the whole parent dev, its bridge, its rc hierarchy here.
There should be a need.
It was needed in PF/VF case due to overlapping numbers of VFs via single de=
vlink instance. You probably missed my reply to Jakub.
Here it is no overlap.

