Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F177EA3757
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 14:58:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728309AbfH3M6L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 08:58:11 -0400
Received: from mail-eopbgr50056.outbound.protection.outlook.com ([40.107.5.56]:43394
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727522AbfH3M6K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Aug 2019 08:58:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KKoq/ODJ5q/KS9bm3ybTf0PViBncm3HJFqDvaAelIB5C6b29Hv1zXkVcVVLZJv2iHsxlIKz4i736VgolrMcLduL2ky8x+l6D/eiun+SWEEn/2TjBLeez8sfQHuL4nGH858ZlDIQTBWhxHq5wN4GlEUUDnqg2Qau9aybI7OMSNBPpjnrpCPjzkAc7dQsTavhVhdMoccXcjQrichmMVDFJWzdxVsNmzLPg75MQW1dldLXPElF2OvNQx9grQ3tooo+T7VkmImfnyYEtmIySoDuL0JFocyKKcP6GQeaXTTI7D1yDp9I4Mc5G2mDYPjU40opvVbmLvOdPYM1zpStkocjziw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Jolp1iyK7NthqB+jqvU8rvtbpFpc5s7V7ehQjJ2KBQ=;
 b=cCO6vA8Y/EOWFYdScrPIcSTlTYgI2maJsH2xAb+1pY/JQ5hjdTlHSLbzrwnj6O331mKglUI3JffU+O02wwyK/O5SpYWQZc1ISRpLUqBBcTj2q/oeWkDREgch94kx5LbHLGkpxjfRINQCaxuhv8yzCzW865UuqKOqxo90FJ7KKVwgWvXp5Eo4FvB1/ejYTI/I5OVgUT9gjt858AAd81hfnvxNYgWrOyXZKZHdTpuW1yjj2HTTma489Pz/H7qhj4V+9ZaEKWeC9fRJXzCNOIZZcfiUQShsPMRQfE2+w3W8lXfRjY5m+t9/8B0Q/CmR4NLp9erz4az9Dm5xONNvA8RyJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Jolp1iyK7NthqB+jqvU8rvtbpFpc5s7V7ehQjJ2KBQ=;
 b=QWPmo3CZOhxViOiIdEIoCf2nNdgOuP8XbKfFxszWl/EkWp6sq9MNSxIV2/I4PSQ7CnyL4J8wmaYHPP2tSeP4Prd5SOwd7Dze7TVYTuZMP1Y6UVPCooE10qEEA9iUUIOpl3kTrX/3p+lBSDt8ppJxnEy8dV7Ti9VWonYq1kfJ5KI=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB5620.eurprd05.prod.outlook.com (20.178.112.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.21; Fri, 30 Aug 2019 12:58:04 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea%6]) with mapi id 15.20.2199.021; Fri, 30 Aug 2019
 12:58:04 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Cornelia Huck <cohuck@redhat.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v2 1/6] mdev: Introduce sha1 based mdev alias
Thread-Topic: [PATCH v2 1/6] mdev: Introduce sha1 based mdev alias
Thread-Index: AQHVXluia2ak8fbBtkW+HkGgDQ+zpacTarsAgAA0s9CAAAPGgIAAA/ow
Date:   Fri, 30 Aug 2019 12:58:04 +0000
Message-ID: <AM0PR05MB486621283F935B673455DA63D1BD0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190826204119.54386-1-parav@mellanox.com>
        <20190829111904.16042-1-parav@mellanox.com>
        <20190829111904.16042-2-parav@mellanox.com>
        <20190830111720.04aa54e9.cohuck@redhat.com>
        <AM0PR05MB48660877881F7A2D757A9C82D1BD0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190830143927.163d13a7.cohuck@redhat.com>
In-Reply-To: <20190830143927.163d13a7.cohuck@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [106.51.18.188]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7f18345b-a617-4032-b09c-08d72d49b273
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB5620;
x-ms-traffictypediagnostic: AM0PR05MB5620:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB56204AFBBFBA08692E8F1E63D1BD0@AM0PR05MB5620.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0145758B1D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(346002)(376002)(396003)(136003)(54534003)(13464003)(199004)(189003)(6916009)(71190400001)(66066001)(256004)(33656002)(81156014)(14444005)(6116002)(55016002)(52536014)(4326008)(7696005)(9686003)(486006)(446003)(3846002)(81166006)(66476007)(6506007)(66446008)(66556008)(64756008)(54906003)(476003)(55236004)(8936002)(6436002)(53936002)(26005)(74316002)(66946007)(2906002)(305945005)(11346002)(53546011)(102836004)(25786009)(86362001)(76176011)(76116006)(186003)(316002)(7736002)(6246003)(508600001)(229853002)(9456002)(5660300002)(8676002)(14454004)(71200400001)(99286004)(79990200002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB5620;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: IyzJ69MOzH8CkGWIFd3PYMhMpQkHVmPK4UGpUutYqOiTdg6asLb1vUoKqL9yKEyo2YCmWX8pfwpNBYWHP4ErEs4HT3dB3x5GEH4xK1vweL/SRCaU6gnJL4MW388rrpAw/C1xbNmwG5DgH+Xfit/P6l5x9j0xJXsuYvHh1moIRBCPWDdoDFw1R2k9/FjrU2bj114JShOeDkpuecrWBWIDxd/Mi85WNzxj2omEpxzQPHQADCT6JvNFj76qrl0OGTA91zqJuEOSy95GOQk8hD13EawsJFBOcnIFLmF/1Abec/clZ8oRkOz7Y58y4LsZdwwuqM0rHOjr7OYZQxWYY6Mh7PndcU0pV2WeZCLInTaCIUiZY1BPVFwiHaImRjwfc3oPX3HENoMSRvQ3/MhGOXGa8gj6gOBRUIxt/f5g7zRTkJNax1VjsrvuFgJdprkQbXtMWOf5iOKnxbjz+PeY12GHjg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f18345b-a617-4032-b09c-08d72d49b273
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2019 12:58:04.4764
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: J+awbT8NBpCtyPtLCEu+FBaGSBUSyYJwCVJqPtjh9qnr19oNHPO0BJJ7BVDf+qIPQ3b6SIcRHRgxhUq5BUo7Sg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5620
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Cornelia Huck <cohuck@redhat.com>
> Sent: Friday, August 30, 2019 6:09 PM
> To: Parav Pandit <parav@mellanox.com>
> Cc: alex.williamson@redhat.com; Jiri Pirko <jiri@mellanox.com>;
> kwankhede@nvidia.com; davem@davemloft.net; kvm@vger.kernel.org; linux-
> kernel@vger.kernel.org; netdev@vger.kernel.org
> Subject: Re: [PATCH v2 1/6] mdev: Introduce sha1 based mdev alias
>=20
> On Fri, 30 Aug 2019 12:33:22 +0000
> Parav Pandit <parav@mellanox.com> wrote:
>=20
> > > -----Original Message-----
> > > From: Cornelia Huck <cohuck@redhat.com>
> > > Sent: Friday, August 30, 2019 2:47 PM
> > > To: Parav Pandit <parav@mellanox.com>
> > > Cc: alex.williamson@redhat.com; Jiri Pirko <jiri@mellanox.com>;
> > > kwankhede@nvidia.com; davem@davemloft.net; kvm@vger.kernel.org;
> > > linux- kernel@vger.kernel.org; netdev@vger.kernel.org
> > > Subject: Re: [PATCH v2 1/6] mdev: Introduce sha1 based mdev alias
> > >
> > > On Thu, 29 Aug 2019 06:18:59 -0500
> > > Parav Pandit <parav@mellanox.com> wrote:
> > >
> > > > Some vendor drivers want an identifier for an mdev device that is
> > > > shorter than the UUID, due to length restrictions in the consumers
> > > > of that identifier.
> > > >
> > > > Add a callback that allows a vendor driver to request an alias of
> > > > a specified length to be generated for an mdev device. If
> > > > generated, that alias is checked for collisions.
> > > >
> > > > It is an optional attribute.
> > > > mdev alias is generated using sha1 from the mdev name.
> > > >
> > > > Signed-off-by: Parav Pandit <parav@mellanox.com>
> > > >
> > > > ---
> > > > Changelog:
> > > > v1->v2:
> > > >  - Kept mdev_device naturally aligned
> > > >  - Added error checking for crypt_*() calls
> > > >  - Corrected a typo from 'and' to 'an'
> > > >  - Changed return type of generate_alias() from int to char*
> > > > v0->v1:
> > > >  - Moved alias length check outside of the parent lock
> > > >  - Moved alias and digest allocation from kvzalloc to kzalloc
> > > >  - &alias[0] changed to alias
> > > >  - alias_length check is nested under get_alias_length callback
> > > > check
> > > >  - Changed comments to start with an empty line
> > > >  - Fixed cleaunup of hash if mdev_bus_register() fails
> > > >  - Added comment where alias memory ownership is handed over to
> > > > mdev device
> > > >  - Updated commit log to indicate motivation for this feature
> > > > ---
> > > >  drivers/vfio/mdev/mdev_core.c    | 123
> > > ++++++++++++++++++++++++++++++-
> > > >  drivers/vfio/mdev/mdev_private.h |   5 +-
> > > >  drivers/vfio/mdev/mdev_sysfs.c   |  13 ++--
> > > >  include/linux/mdev.h             |   4 +
> > > >  4 files changed, 135 insertions(+), 10 deletions(-)
>=20
> > > ...and detached from the local variable here. Who is freeing it? The
> > > comment states that it is done by the mdev, but I don't see it?
> > >
> > mdev_device_free() frees it.
>=20
> Ah yes, I overlooked the kfree().
>=20
> > once its assigned to mdev, mdev is the owner of it.
> >
> > > This detour via the local variable looks weird to me. Can you either
> > > create the alias directly in the mdev (would need to happen later in
> > > the function, but I'm not sure why you generate the alias before
> > > checking for duplicates anyway), or do an explicit copy?
> > Alias duplicate check is done after generating it, because duplicate al=
ias are
> not allowed.
> > The probability of collision is rare.
> > So it is speculatively generated without hold the lock, because there i=
s no
> need to hold the lock.
> > It is compared along with guid while mutex lock is held in single loop.
> > And if it is duplicate, there is no need to allocate mdev.
> >
> > It will be sub optimal to run through the mdev list 2nd time after mdev
> creation and after generating alias for duplicate check.
>=20
> Ok, but what about copying it? I find this "set local variable to NULL af=
ter
> ownership is transferred" pattern a bit unintuitive. Copying it to the md=
ev (and
> then unconditionally freeing it) looks more obvious to me.
Its not unconditionally freed. Its freed in the error unwinding path.
I think its ok along with the comment that describes this error path area.
