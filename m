Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA2ECCCF6
	for <lists+netdev@lfdr.de>; Sun,  6 Oct 2019 00:01:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726034AbfJEWBO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Oct 2019 18:01:14 -0400
Received: from mail-eopbgr140047.outbound.protection.outlook.com ([40.107.14.47]:6567
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725801AbfJEWBO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Oct 2019 18:01:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CiaeL/1XEfIFkh+1y+f4yyYwBVskUMV5fdMis5oxcfTMmkoAs7lRGuDQ+lSEqAP7GFruIFsVJ8tFSAVp1O+4ktCsT91r8gjCjSXMrG4C7mSjSXG6fg59/TyQ0Pxa9VoztrEHv0gQd2GP/3oq79q6D2Tuof9D1BOHiGLIICP8w3i+IVeG0JVI9hPt5T8qniFugtLky6EdWIOTTnP1SR9vYZRhAkcJ9WRptsNqN0Fdjzxjp3puoCvd6vtF4jjatMjmE5NO83xPcjj4lIcv1BrqU/glFCCrMEte98kgPT8raLfu/iqeDJqWwheOZ0pnqa7NfAOZlcVBVCVTIqGO0MVQsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7jBqrgDTxjCCYcf8HESJuQj0hmNoab6h7Y1XTr1sYBA=;
 b=cgnzM2+afIN3jN4qfrJzyLT4S9IyrZ+scVK3wQttyMcOKOpphy2PoD0j/HDc5VrBC/ZdBIgdYy9UJS/rOTfsh69uIeWnhG8IT3il4IPj1GAsPVMunJ4oistqkrab8PEUCVmu7PzA7FWlyKER8J/fxQ0DvK3YzSDGlQBqi1EhH6XCOS8se3/0QVDusQDH9mb7fiXzq8XMHeGX7z5TBpop3RMlAB5z4TxtAgOg/wyRE5aiQh84nXppNWRbD2oz8SgTPpFBXIrkRSNOfJqgWOd3LANzEVdmFODqWIbEf+guwb1o/hcWQXQlPeC5s6CZ4HDOgCE4I+pP+qpqy2A4/v1NGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7jBqrgDTxjCCYcf8HESJuQj0hmNoab6h7Y1XTr1sYBA=;
 b=dB3m9B4sviIe7Vl/3dP4MOIlDKv+ByIBEaJ/rgtll9E/iKimFMbZdYXEmFm2mcQRKIwvsA9NO6bSEy6hTyVpyn3WXemmxTR7GX+qGrRdR+HBh5hZTUPNgnGcrCZOeNlDf87W147xNFScE+IDnr2Va7VLz83xpR0d4LVe/Db+nZc=
Received: from DB7PR05MB4138.eurprd05.prod.outlook.com (52.135.129.16) by
 DB7PR05MB6266.eurprd05.prod.outlook.com (20.176.236.80) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.20; Sat, 5 Oct 2019 22:01:08 +0000
Received: from DB7PR05MB4138.eurprd05.prod.outlook.com
 ([fe80::18c2:3d9e:4f04:4043]) by DB7PR05MB4138.eurprd05.prod.outlook.com
 ([fe80::18c2:3d9e:4f04:4043%3]) with mapi id 15.20.2305.023; Sat, 5 Oct 2019
 22:01:08 +0000
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
CC:     Leon Romanovsky <leon@kernel.org>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Mustafa Ismail <mustafa.ismail@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Shiraz Saleem <shiraz.saleem@intel.com>
Subject: Re: [RFC 04/20] RDMA/irdma: Add driver framework definitions
Thread-Topic: [RFC 04/20] RDMA/irdma: Add driver framework definitions
Thread-Index: AQHVdInRxKc9Xqm18UKMerHkf/S7lqc+Ny4AgAy/zgCAADt/gIAAEQaAgAFkLAA=
Date:   Sat, 5 Oct 2019 22:01:08 +0000
Message-ID: <20191005220102.GJ13974@mellanox.com>
References: <20190926164519.10471-1-jeffrey.t.kirsher@intel.com>
 <20190926164519.10471-5-jeffrey.t.kirsher@intel.com>
 <20190926173046.GB14368@unreal>
 <04e8a95837ba8f6a0b1d001dff2e905f5c6311b4.camel@intel.com>
 <20191004234519.GF13974@mellanox.com>
 <cd1712dc03721a01ac786ec878701a1823027434.camel@intel.com>
In-Reply-To: <cd1712dc03721a01ac786ec878701a1823027434.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MN2PR01CA0027.prod.exchangelabs.com (2603:10b6:208:10c::40)
 To DB7PR05MB4138.eurprd05.prod.outlook.com (2603:10a6:5:23::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [142.162.113.180]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 317ed863-b899-4120-9eac-08d749df86a4
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600167)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DB7PR05MB6266;
x-ms-traffictypediagnostic: DB7PR05MB6266:
x-microsoft-antispam-prvs: <DB7PR05MB6266770DCF2DCA1888E66934CF990@DB7PR05MB6266.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0181F4652A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(396003)(136003)(376002)(39850400004)(199004)(189003)(6246003)(11346002)(2616005)(64756008)(5660300002)(446003)(33656002)(256004)(229853002)(6506007)(66446008)(66556008)(99286004)(476003)(305945005)(386003)(14444005)(2906002)(66476007)(6916009)(66946007)(25786009)(102836004)(7736002)(3846002)(36756003)(6486002)(52116002)(81156014)(81166006)(76176011)(6436002)(8936002)(54906003)(4326008)(478600001)(186003)(66066001)(86362001)(8676002)(6116002)(316002)(486006)(14454004)(71200400001)(71190400001)(6512007)(1076003)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR05MB6266;H:DB7PR05MB4138.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: qMQlv3aqQ/U8PmFyncYlsyMwhpcvMgE5lSGIHIaFVCEE8hSz5ZAsL6J5xghHBpT51tNfja2ZziFng5y53RVxHCj7X+PtWZWd2NJJ7RIPm2P048fJVipuU9OnZVZAIw2xODNfsuYESv/VyrJGi3bAtOYibTLW7pBPpfRbObiNvtWDJ9iY0JZIa92E0wAgqkTyuDT/GOin/C2581eGPWd0cxk5oR40fAVXK7IlC6/GuXDvy5D7/sPoQDfFeXAOaeoNmQhD+1yMa0YDTgNgKZKTcc5exnP7Cn7K0gUqh/nJL4/G50oy8k/aNZPrEfXifPV5GJOUu1LKV1rWUtqyxkfLKEsVkmZ60LAbmO9OK02g9HOPle8LVhWwyfCoTacGlzieNdxcPgRvuOhil1gIXx27gj72WIjOXbreGv+5EPAGu3Q=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <85A50DB784B6E14592C5A04C791D2455@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 317ed863-b899-4120-9eac-08d749df86a4
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Oct 2019 22:01:08.3433
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6gImX9dD3RlT6BF7KxiVbF+5gi2lrVht/EifS1LvbSbZpn7BOP+BUqTijC5nb2M8HsdUg0x5vPU2lIbRNq6ECw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR05MB6266
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 04, 2019 at 05:46:15PM -0700, Jeff Kirsher wrote:
> On Fri, 2019-10-04 at 23:45 +0000, Jason Gunthorpe wrote:
> > On Fri, Oct 04, 2019 at 01:12:22PM -0700, Jeff Kirsher wrote:
> >=20
> > > > > +	if (ldev->version.major !=3D I40E_CLIENT_VERSION_MAJOR ||
> > > > > +	    ldev->version.minor !=3D I40E_CLIENT_VERSION_MINOR) {
> > > > > +		pr_err("version mismatch:\n");
> > > > > +		pr_err("expected major ver %d, caller specified
> > > > > major
> > > > > ver %d\n",
> > > > > +		       I40E_CLIENT_VERSION_MAJOR, ldev-
> > > > > >version.major);
> > > > > +		pr_err("expected minor ver %d, caller specified
> > > > > minor
> > > > > ver %d\n",
> > > > > +		       I40E_CLIENT_VERSION_MINOR, ldev-
> > > > > >version.minor);
> > > > > +		return -EINVAL;
> > > > > +	}
> > > >=20
> > > > This is can't be in upstream code, we don't support out-of-tree
> > > > modules,
> > > > everything else will have proper versions.
> > >=20
> > > Who is the "we" in this context?
> >=20
> > Upstream sensibility - if we start doing stuff like this then we will
> > end up doing it everwhere.
>=20
> I see you cut out the part of my response about Linux distributions
> disagreeing with this stance.

Sure, this is an upstream decision.. I think everyone knows distros
hate the stable-api-nonsense policy?

> > I don't see how this is any different from any of the other myriad of
> > problems out of tree modules face.=20
> >=20
> > Someone providing out of tree modules has to provide enough parts of
> > their driver so that it only consumes the stable ABI from the distro
> > kernel.
> >=20
> > Pretty normal stuff really.
>=20
> Your right, if the dependency was reversed and the out-of-tree (OOT) driv=
er
> was dependent upon the RDMA driver, but in this case it is not.  The LAN
> driver does not "need" the RDMA driver to work.  So the RDMA driver shoul=
d
> at least check that the LAN driver loaded has the required version to wor=
k.

So? IMHO you have to provide both drivers if you want to have an OOT
solution as the lan driver is providing and changing kABI outside the
distro promise of kABI stability.

It is no different than replacing, say, the entire core RDMA subsystem as
many people tend to do.

> This line of thinking, "marries" the in-kernel RDMA driver with the in-
> kernel LAN driver(s) so the end users and Linux distro's can not choose t=
o
> upgrade or use any other driver than what comes with the kernel. =20

Yes, but upgrade is possible, you have to provide both.

> agree that any out-of-tree (OOT) driver needs to make sure they have all
> kernel ABI's figured out for whatever kernel they are being installed on.=
=20
> But what is the problem with the in-kernel RDMA driver to do it's own
> checks to ensure the driver it is dependent upon meets its minimum
> requirements?

It is against the upstream policy and we'd have a proliferation of
these checks if it was allowed, IMHO.
=20
> Similar checks are done in the Intel LAN driver to ensure the firmware is
> of a certain level, which is no different than what is being done here.

External dependencies are expected to check compatability.

Jason
