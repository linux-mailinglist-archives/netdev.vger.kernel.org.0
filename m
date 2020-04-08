Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25CDD1A1B7C
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 07:10:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726492AbgDHFK4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 01:10:56 -0400
Received: from mail-eopbgr70087.outbound.protection.outlook.com ([40.107.7.87]:47163
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726192AbgDHFK4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Apr 2020 01:10:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d0tNNHb+qd9Bdjp3Pa+jUy5HbPHy0SlAW8Y1jeAcy9R8j4KMp6E64jlLkYayDEghnobM+BxgRO4+ZoOmuyjFbGSkxVEfdRD47zXGb+apyCgSmiXtemAS6TS3TOgkLmA3JyQtrRLdmEBn/ZALVi9KMYRUDpqDlg0qe1pHf0zjxeKvRV/LMewLxVdtzqR0k5JFwHncqfLEOG0Q3jRhkuZzIxBBbj2HY9/3f77OvYYwRMsMJ+f3Fm5jSWtMnYUcNz3U+5cTcvWBAQuhxKEpzLd/ytJiVGIYbMWXKY84RT1enMYVUj2sW2pfyIhLKe73UF2YkwY8O5ObX5J4dNglNpm5eQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CrCnIDZP+No91S4U9AABJw3T1lclr/rGoebMlulpZJg=;
 b=SvfFLkg+KyNM/RhyyjknDL4n0ErIcyC5J8JQ7cFyT+dUvamCp+y+2/4zs1iOA7wW38ZmhTTfeTiGhiscSFwSlKt0vxN4Rvkjho4KlC57D81mCYQs+saAFmXlSXcLySAVQOj/LvfvQ1+aUEDehXq5k+mTd4oWxmNhPEV668lVoPlX3kxcSOJp1f+g69Xftjo5gA8l8s8sjaIixxMBmHERPVLBnZaubtfsZZCviDO4G9fJBF+8oFj2M1c1+k++FsdMq/u9mW7RKITf/2NseqGSbKp9nOmmtsvVuCV51TXguiEAhsXAZjr4CKbWq9+yeexSF6zYOclg1lmwTF8T0aKFNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CrCnIDZP+No91S4U9AABJw3T1lclr/rGoebMlulpZJg=;
 b=UT1Gj4lt2sRPfcJ+vzdsAlq5fl/4pJgoFA0bwolVjqsq3Xqk24LbPa1TLFMlhMOKwOQRoQj9W8t3tGCUfLR+eLF9PjnDOnddsQs45K9MgXlvdPnHEjOj+wZ3kw/2pYvDJP7KTLCgIgYHXOow+G1uX2Zv4ys0GGNCvZrl3GrmCyQ=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (2603:10a6:208:c0::32)
 by AM0PR05MB6497.eurprd05.prod.outlook.com (2603:10a6:208:13f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.15; Wed, 8 Apr
 2020 05:10:50 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::8c4:e45b:ecdc:e02b]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::8c4:e45b:ecdc:e02b%7]) with mapi id 15.20.2878.021; Wed, 8 Apr 2020
 05:10:50 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Jiri Pirko <jiri@resnulli.us>, Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
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
        "vikas.gupta@broadcom.com" <vikas.gupta@broadcom.com>,
        "magnus.karlsson@intel.com" <magnus.karlsson@intel.com>
Subject: RE: [RFC] current devlink extension plan for NICs
Thread-Topic: [RFC] current devlink extension plan for NICs
Thread-Index: AQHV/iRsiKU58im38Um7T8fyNtLerKhQ1DGAgABD54CAAOeuAIAAzAqAgAPIYYCABGpggIAAAUoAgABegoCAAL1QAIAAlFSAgAQi9ACAAMW/gIAAy84AgACkCICAAOhGEIAA1qaAgACo0ICACVqdQA==
Date:   Wed, 8 Apr 2020 05:10:50 +0000
Message-ID: <AM0PR05MB4866B04EE343A12A83F1B4DAD1C00@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20200326145146.GX11304@nanopsycho.orion>
 <20200326133001.1b2694c9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200327074736.GJ11304@nanopsycho.orion>
 <20200327093829.76140a98@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <35e8353f-2bfc-5685-a60e-030cd2d2dd24@mellanox.com>
 <20200330123623.634739de@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <50c0f739-592e-77a4-4872-878f99cc8b93@mellanox.com>
 <20200331103255.549ea899@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <AM0PR05MB4866E76AE83EA4D09449AF05D1C90@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20200401131231.74f2a5a8@kicinski-fedora-PC1C0HJN>
 <20200402061643.GB2199@nanopsycho.orion>
In-Reply-To: <20200402061643.GB2199@nanopsycho.orion>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [106.51.29.144]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 48b7f13a-34b6-485b-7582-08d7db7b3474
x-ms-traffictypediagnostic: AM0PR05MB6497:|AM0PR05MB6497:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB64976F1F4C94FE90F0527D85D1C00@AM0PR05MB6497.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3044;
x-forefront-prvs: 0367A50BB1
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB4866.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(366004)(396003)(39860400002)(136003)(346002)(376002)(66476007)(66556008)(66446008)(64756008)(81156014)(66946007)(5660300002)(71200400001)(9686003)(86362001)(478600001)(8936002)(7696005)(26005)(186003)(52536014)(81166007)(2906002)(76116006)(33656002)(4326008)(55016002)(110136005)(316002)(8676002)(54906003)(7416002)(6506007)(55236004);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FmGsAeWtEvsq7fFwRmUjmdoVdtacFvxU42pOl3yc600zTyQOWqZ9yGns+omnoTrTVJskqTollvFwnXT8P06bC0h02BcDnsy+LMEEw6DOU8LujWY1FghwGojiUPo6NwKh2DI5CDfoIhvHyFL5c8bV63UeX+0gBlPn3MGsN/D1kRzoni6fZExMHRwSn6SLvqRABTtgRKQS9liNOGY1Kff/dDHnKisaHr8WL/sNLc/noR2ixwJbs9Ob+GiNoAmHcduGw9WdFa3VauOXab6LwzzohiPviuSOVunNe83U1FeIj3u+XnHDBJA+CjbyWTN5wrCNyXJp7aMu7nTv9Ox3VJSkRWZHKKBWsAqE90p/LvcaBSOIaDPau7dGMp0z32+jtngn1eQIA0kmdjZYc/yfFw41sYnni9Ouns0k1A2yECJaGN0ioND3/V2sEgb8Qc+qMNe+
x-ms-exchange-antispam-messagedata: PV4AhQiuAAWvorHkZsa1Zj17Xg4b6SrbvKXgITtBP6aR0nlKqQI+MSS75KR1eHGyZu4tfnuQsSq0QrDqa999rpkHhvZMKlsZXcmjt2lpqZzbnbP1fHEZvBuqs3Ozo3I0UUk78lQidP3gaY3f9zWHow==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48b7f13a-34b6-485b-7582-08d7db7b3474
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2020 05:10:50.1133
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0StHcX/ftxwM7a4kTH7KZeVzqgowl6YP9CqirruXMrIyxHVg4+gw/QDBQu2iJ062yuKNWQNg2G95l1ZQZHd+5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6497
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> From: Jiri Pirko <jiri@resnulli.us>
> Sent: Thursday, April 2, 2020 11:47 AM
>=20
> Wed, Apr 01, 2020 at 10:12:31PM CEST, kuba@kernel.org wrote:
> >On Wed, 1 Apr 2020 07:32:46 +0000 Parav Pandit wrote:
> >> > From: Jakub Kicinski <kuba@kernel.org>
> >> > Sent: Tuesday, March 31, 2020 11:03 PM
> >> >
> >> > On Tue, 31 Mar 2020 07:45:51 +0000 Parav Pandit wrote:
> >> > > > In fact very little belongs to the port in that model. So why
> >> > > > have PCI ports in the first place?
> >> > > >
> >> > > for few reasons.
> >> > > 1. PCI ports are establishing the relationship between eswitch
> >> > > port and its representor netdevice.
> >> > > Relying on plain netdev name doesn't work in certain pci topology
> >> > > where netdev name exceeds 15 characters.
> >> > > 2. health reporters can be at port level.
> >> >
> >> > Why? The health reporters we have not AFAIK are for FW and for
> >> > queues hanging. Aren't queues on the slice and FW on the device?
> >> There are multiple heath reporters per object.
> >> There are per q health reporters on the representor queues (and
> >> representors are attached to devlink port). Can someone can have
> >> representor netdev for an eswitch port without devlink port? No,
> >> net/core/devlink.c cross verify this and do WARN_ON. So devlink port
> >> for eswitch are linked to representors and are needed. Their
> >> existence is not a replacement for representing 'portion of the
> >> device'.
> >
> >I don't understand what you're trying to say. My question was why are
> >queues not on the "slice"? If PCIe resources are on the slice, then so
> >should be the health reporters.
>=20
> I agree. These should be attached to the slice.
>
Representor netdev has txq and rxq.
Health reporters for this queue are attached to the txq and rxq.

Txq/rxq related health reporters can be linked to a slice, if that is what =
you meant.
=20
>=20
> >
> >> > > 3. In future at eswitch pci port, I will be adding dpipe support
> >> > > for the internal flow tables done by the driver.
> >> > > 4. There were inconsistency among vendor drivers in using/abusing
> >> > > phys_port_name of the eswitch ports. This is consolidated via
> >> > > devlink port in core. This provides consistent view among all
> >> > > vendor drivers.
> >> > >
> >> > > So PCI eswitch side ports are useful regardless of slice.
> >> > >
> >> > > >> Additionally devlink port object doesn't go through the same
> >> > > >> state machine as that what slice has to go through.
> >> > > >> So its weird that some devlink port has state machine and some
> >> > > >> doesn't.
> >> > > >
> >> > > > You mean for VFs? I think you can add the states to the API.
> >> > > >
> >> > > As we agreed above that eswitch side objects (devlink port and
> >> > > representor netdev) should not be used for 'portion of device',
> >> >
> >> > We haven't agreed, I just explained how we differ.
> >>
> >> You mentioned that " Right, in my mental model representor _is_ a
> >> port of the eswitch, so repr would not make sense to me."
> >>
> >> With that I infer that 'any object that is directly and _always_
> >> linked to eswitch and represents an eswitch port is out of question,
> >> this includes devlink port of eswitch and netdev representor. Hence,
> >> the comment 'we agree conceptually' to not involve devlink port of
> >> eswitch and representor netdev to represent 'portion of the device'.
> >
> >I disagree, repr is one to one with eswitch port. Just because repr is
> >associated with a devlink port doesn't mean devlink port must be
> >associated with a repr or a netdev.
