Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7C901A2F49
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 08:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725828AbgDIGnn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 02:43:43 -0400
Received: from mail-db8eur05on2049.outbound.protection.outlook.com ([40.107.20.49]:20064
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725283AbgDIGnm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Apr 2020 02:43:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DwoFeItStcMVdydUGEBTwczwX7yWvDkklmBBxcl4a/Gu6rfZkDsY8siwv4ZUczxfpWHW/fT9jZKc6S+Mdm+fW7iVQ0wjKBmK8FMVgPhGthbdb7hNPpJ95DWot3JCTeF5oLQ3XSDxE4C5BIWwRmpuyG3bgDk2Now0HqYcqZ5mybekXbNBNzxvMtw/OKVH0ARP7XL+XAxKjSx3Dlvm0/HEyXVoPJy5H/jFufvC2IFsqPyX9ckJWAbDYa1pHICiaRODl6C/rGoEI6opZPiE8IlPqglcSa8P4PitolE472s+e3EUpqFHdJ4nYaOhF/c6dbjrVii7Y7O6TaioisrX33A3GA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NPjEoIizvXlAR8xZpb1S3Z7VbNm/Y3r/2YKD/ZudG44=;
 b=I2nngD0CPXfRgLFjNEmUkI9jc9NTL9HFvM9ZGuhW+RvBgyZCS6kE7gp1HV3EYjgzdwUe3N18iT2XBzP4SsbBjadFyAUIvaTgePzcIBxX1/3qfpQbmIeUu0l7x/fp+o3zAqg6JhvHyG3My4nqr8p7W1iUMq8wcOpRXyWQ8udfTflM4w6gFnj7YoM5cUN7clckRZL4mzRJteCIWGBNtvaWBnige+0yRVJKIXzcfXN/TMN3o+Vaenx2JQIlPhFYNjxVuV/t/vdpRgPb3F/eK20YLPf38xVPooYtYeXnuh+MwoDE+41Abq8+cTf0YyXuoZeeZW0gx6eA6kyn8htLynkZEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NPjEoIizvXlAR8xZpb1S3Z7VbNm/Y3r/2YKD/ZudG44=;
 b=EiSAxRbXMDVNvU63pd8SSfBa0Eun8CwOFPbis5rgpf6o3PEyVldhpJxX6tjrV+Iyp0RpA9u/wChzPxlM72QeynFM+HIekZqbxHIE3P9kI7Q3WJzAEq19SgTxEe2Dypqw6PJxHyKulozBaxsNg31zOhL/5J4grtDT1fPx52uFk2E=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (2603:10a6:208:c0::32)
 by AM0PR05MB6020.eurprd05.prod.outlook.com (2603:10a6:208:12f::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.16; Thu, 9 Apr
 2020 06:43:25 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::8c4:e45b:ecdc:e02b]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::8c4:e45b:ecdc:e02b%7]) with mapi id 15.20.2878.021; Thu, 9 Apr 2020
 06:43:25 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "magnus.karlsson@intel.com" <magnus.karlsson@intel.com>
CC:     Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Yuval Avnery <yuvalav@mellanox.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "andrew.gospodarek@broadcom.com" <andrew.gospodarek@broadcom.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Aya Levin <ayal@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Yevgeny Kliteynik <kliteyn@mellanox.com>,
        "dchickles@marvell.com" <dchickles@marvell.com>,
        "sburla@marvell.com" <sburla@marvell.com>,
        "fmanlunas@marvell.com" <fmanlunas@marvell.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        "oss-drivers@netronome.com" <oss-drivers@netronome.com>,
        "snelson@pensando.io" <snelson@pensando.io>,
        "drivers@pensando.io" <drivers@pensando.io>,
        "aelior@marvell.com" <aelior@marvell.com>,
        "GR-everest-linux-l2@marvell.com" <GR-everest-linux-l2@marvell.com>,
        "grygorii.strashko@ti.com" <grygorii.strashko@ti.com>,
        mlxsw <mlxsw@mellanox.com>, Ido Schimmel <idosch@mellanox.com>,
        Mark Zhang <markz@mellanox.com>,
        "jacob.e.keller@intel.com" <jacob.e.keller@intel.com>,
        Alex Vesker <valex@mellanox.com>,
        "linyunsheng@huawei.com" <linyunsheng@huawei.com>,
        "lihong.yang@intel.com" <lihong.yang@intel.com>,
        "vikas.gupta@broadcom.com" <vikas.gupta@broadcom.com>
Subject: RE: [RFC] current devlink extension plan for NICs
Thread-Topic: [RFC] current devlink extension plan for NICs
Thread-Index: AQHV/iRsiKU58im38Um7T8fyNtLerKhQ1DGAgABD54CAAOeuAIAAzAqAgAPIYYCABGpggIAAAUoAgABegoCAAL1QAIAAlFSAgAQi9ACAAMW/gIAAy84AgACkCICAAOhGEIAA1qaAgAoCRuCAAMgLAIAACeFQgACPK4CAAEV8cA==
Date:   Thu, 9 Apr 2020 06:43:25 +0000
Message-ID: <AM0PR05MB48664BACD47F08E6271C43A5D1C10@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20200319192719.GD11304@nanopsycho.orion>
        <20200326144709.GW11304@nanopsycho.orion>
        <20200326145146.GX11304@nanopsycho.orion>
        <20200326133001.1b2694c9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200327074736.GJ11304@nanopsycho.orion>
        <20200327093829.76140a98@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <35e8353f-2bfc-5685-a60e-030cd2d2dd24@mellanox.com>
        <20200330123623.634739de@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <50c0f739-592e-77a4-4872-878f99cc8b93@mellanox.com>
        <20200331103255.549ea899@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <AM0PR05MB4866E76AE83EA4D09449AF05D1C90@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20200401131231.74f2a5a8@kicinski-fedora-PC1C0HJN>
        <AM0PR05MB4866B13FF6B672469BDF4A3FD1C00@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20200408095914.772dfdf3@kicinski-fedora-PC1C0HJN>
        <AM0PR05MB4866BDC1A2CB2218E2F3D056D1C00@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20200408190701.27a4ca4b@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200408190701.27a4ca4b@kicinski-fedora-PC1C0HJN>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [106.51.29.144]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a368637b-3c71-4c4d-f62f-08d7dc514e2f
x-ms-traffictypediagnostic: AM0PR05MB6020:|AM0PR05MB6020:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB6020878284D920E85934C83DD1C10@AM0PR05MB6020.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0368E78B5B
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB4866.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(346002)(376002)(39850400004)(136003)(366004)(396003)(33656002)(66946007)(52536014)(66556008)(2906002)(66446008)(66476007)(64756008)(86362001)(9686003)(71200400001)(55016002)(7696005)(4326008)(186003)(6506007)(55236004)(76116006)(26005)(110136005)(8676002)(7416002)(316002)(81156014)(54906003)(8936002)(5660300002)(478600001)(81166007);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zq+hK7sb5HwPJ3SNXxRpImEepw+JHlDEZHPqc9QW6VEG6Z7QxPLyqiVCKVvUgf6qLmqkNoqy+z3hm9fR+GnMOuzf3Ds9KbIYAotFOkwcVUUCBieH4g4Vqw5HPYkga1hSOL15JMq7YqxIohu5FzSSN3FGepNX6XXP0Ee06Eo96DTQXssLbxYjjF3yKYkpk50b87R8VpE65RuX6L9fhmDNbkk82CMp1tIiTXjWWm/0FxOZw9d8cDZuwHvvozO0qeLt/6LI73tjh4wKV4W508cnplSh8zBWkRM8h8+aumym78GD3H3/6XoSKpe3e7NfI8LCLOIO8ks9BFsX2WrbiCTSaOTKzJtNTMZq0FdlykQQQoYRyMnP4430sK9rDm7HPGweaYLFJSdVIR5Su0PCFQSoqUOu9QU3oBAmeCbY9VmpOBnXuxVfj/rJpObL5KGpuKbz
x-ms-exchange-antispam-messagedata: 5qMRd4yKG/R92Dnh4INpHhJ2UMAQ6X0U/xxQiNWyG8Ahr5p9VhmVyJFmJXt1JSPR4c0b8ECuiil9Z0gYTBOVzZ1zR1oYg1z1C43bTLbseMMjnqMPmfRv3x1VC6yadkkLpi2SRRmt4v40dlCKv+HyJg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a368637b-3c71-4c4d-f62f-08d7dc514e2f
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2020 06:43:25.7053
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HQnnx2QLYmXqyncznbOsMx+rR8XhYQgkPvH/2NBW2Gcrzgn++Rrhm3lv7p8XJmjy6TKkeCezcicvhujnHLdk9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6020
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Thursday, April 9, 2020 7:37 AM
>=20
> On Wed, 8 Apr 2020 18:13:50 +0000 Parav Pandit wrote:
> > > From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org>
> On
> > > Behalf Of Jakub Kicinski
> > >
> > > On Wed, 8 Apr 2020 05:07:04 +0000 Parav Pandit wrote:
> > > > > > > > 3. In future at eswitch pci port, I will be adding dpipe
> > > > > > > > support for the internal flow tables done by the driver.
> > > > > > > > 4. There were inconsistency among vendor drivers in
> > > > > > > > using/abusing phys_port_name of the eswitch ports. This is
> > > > > > > > consolidated via devlink port in core. This provides
> > > > > > > > consistent view among all vendor drivers.
> > > > > > > >
> > > > > > > > So PCI eswitch side ports are useful regardless of slice.
> > > > > > > >
> > > > > > > > >> Additionally devlink port object doesn't go through the
> > > > > > > > >> same state machine as that what slice has to go through.
> > > > > > > > >> So its weird that some devlink port has state machine
> > > > > > > > >> and some doesn't.
> > > > > > > > >
> > > > > > > > > You mean for VFs? I think you can add the states to the A=
PI.
> > > > > > > > >
> > > > > > > > As we agreed above that eswitch side objects (devlink port
> > > > > > > > and representor netdev) should not be used for 'portion of
> > > > > > > > device',
> > > > > > >
> > > > > > > We haven't agreed, I just explained how we differ.
> > > > > >
> > > > > > You mentioned that " Right, in my mental model representor
> > > > > > _is_ a port of the eswitch, so repr would not make sense to me.=
"
> > > > > >
> > > > > > With that I infer that 'any object that is directly and
> > > > > > _always_ linked to eswitch and represents an eswitch port is
> > > > > > out of question, this includes devlink port of eswitch and
> > > > > > netdev representor. Hence, the comment 'we agree conceptually'
> > > > > > to not involve devlink port of eswitch and representor netdev
> > > > > > to represent
> > > 'portion of the device'.
> > > > >
> > > > > I disagree, repr is one to one with eswitch port. Just because
> > > > > repr is associated with a devlink port doesn't mean devlink port
> > > > > must be associated with a repr or a netdev.
> > > > Devlink port which is on eswitch side is registered with switch_id
> > > > and also
> > > linked to the rep netdev.
> > > > From this port phys_port_name is derived.
> > > > This eswitch port shouldn't represent 'portion of the device'.
> > >
> > > switch_id is per port, so it's perfectly fine for a devlink port not
> > > to have one, or for two ports of the same device to have a different =
ID.
> > >
> > > The phys_port_name argument I don't follow. How does that matter in
> > > the "should we create another object" debate?
> > >
> > Its very clear in net/core/devlink.c code that a devlink port with a
> > switch_id belongs to switch side and linked to eswitch representor
> > netdev.
> >
> > It just cannot/should not be overloaded to drive host side attributes.
> >
> > > IMO introducing the slice if it's 1:1 with ports is a no-go.
> > I disagree.
> > With that argument devlink port for eswitch should not have existed and
> netdev should have been self-describing.
> > But it is not done that way for 3 reasons I described already in this t=
hread.
> > Please get rid of devlink eswitch port and put all of it in
> > representor netdev, after that 1:1 no-go point make sense. :-)
> >
> > Also we already discussed that its not 1:1. A slice might not have devl=
ink
> port.
> > We don't want to start with lowest denominator and narrow use case.
> >
> > I also described you that slice runs through state machine which devlin=
k
> port doesn't.
> > We don't want to overload devlink port object.
> >
> > > I also don't like how
> > > creating a slice implicitly creates a devlink port in your design.
> > > If those objects are so strongly linked that creating one implies
> > > the other they should just be merged.
> > I disagree.
> > When netdev representor is created, its multiple health reporters (stro=
ngly
> linked) are created implicitly.
> > We didn't merge and user didn't explicitly created them for right reaso=
ns.
> >
> > A slice as described represents 'portion of a device'. As described in =
RFC,
> it's the master object for which other associated sub-objects gets create=
d.
> > Like an optional devlink port, representor, health reporters, resources=
.
> > Again, it is not 1:1.
> >
> > As Jiri described and you acked that devlink slice need not have to hav=
e a
> devlink port.
> >
> > There are enough examples in devlink subsystem today where 1:1 and non
> 1:1 objects can be related.
> > Shared buffers, devlink ports, health reporters, representors have such
> mapping with each other.
>=20
> I'm not going to respond to any of that. We're going in circles.
>
I don't think we are going in circle.
Its clear to me that some devlink objects are 1:1 mapped with other objects=
, some are not.
And 1:1 mapping/no-mapping is not good enough reason to avoid crisp definit=
ion of a host facing 'portion of the device'.

So lets focus on technical aspects below.
=20
> I bet you remember the history of PCI ports, and my initial patch set.
>=20
> We even had a call about this. Clearly all of it was a waste of time.
>=20
> > > I'm also concerned that the slice is basically a non-networking port.
> > What is the concern?
>=20
> What I wrote below, but you decided to split off in your reply for whatev=
er
> reason.
>=20
> > How is shared-buffer, health reporter is attributed as networking objec=
t?
>=20
> By non-networking I mean non-ethernet, or host facing. Which should be
> clear from what I wrote below.
Ok. I agree, host facing is good name.

>=20
> > > I bet some of the things we add there will one day be useful for
> > > networking or DSA ports.
> > >
> > I think this is mis-interpretation of a devlink slice object.
> > All things we intent to do in devlink slice is useful for networking an=
d non-
> networking use.
> > So saying 'devlink slice is non networking port, hence it cannot be use=
d for
> networking' -> is a wrong interpretation.
> >
> > I do not understand DSA port much, but what blocks users to use slice i=
f it
> fits the need in future.
> >
> > How is shared buffer, health reporter are 'networking' object which exi=
sts
> under devlink, but not strictly under devlink port?
>=20
> E.g. you ad rate limiting on the slice. That's something that may be usef=
ul for
> other ingress points of the device. But it's added to the slice, not the =
port. So
> we can't reuse the API for network ports.
>=20
To my knowledge, there is no user API existed in upstream kernel for device=
 (VF/PF) ingress rate limiting.
So in future if user wants to do ingress rate limiting, it should better us=
e rich eswitch and representor with tc.

Device egress rate limiting at slice level is mainly coming from users who =
are migrating from using 'ip link set vf rate'.
And grouping those VFs further as Jiri described.

May be at this junction, we migrate users to start using tc as,

tc filter add dev enp59s0f0_0 root protocol ip matchall action police rate =
1mbit burst 20k

Is there already a good way to group set of related netdevs and issuing tc =
filter to their grouped netdev?
Or should we create one?
Is tc block sharing good for that purpose?

With that we have cleaner slice interface leaving legacy behind.

Jiri, Jakub,
What is your input on grouping eswitch ports and configuring their ingress =
rate limiting as individual port as group/block/team/something else?

> > > So I'd suggest to maybe step back from the SmartNIC scenario and try
> > > to figure out how slices are useful on their own.
> > I already went through the requirements, scenario, examples and use
> > model in the RFC extension that describes
> > (a) how slice fits smartnic and non smartnic both cases.
> > (b) how user gets same experience and commands regardless of use cases.
> >
> > A 'good' in-kernel example where one object is overloaded to do multipl=
e
> things would support a thought to overload devlink port.
> > For example merge macvlan and vlan driver object to do both
> functionalities.
> > An overloaded recently introduced qdisc to multiple things as another.
