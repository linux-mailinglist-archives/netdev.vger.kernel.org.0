Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D95335D0CE
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 21:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245153AbhDLTIN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 15:08:13 -0400
Received: from mail-mw2nam10on2058.outbound.protection.outlook.com ([40.107.94.58]:9857
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236951AbhDLTIL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 15:08:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fb8hP+q9RW0QWRB3SOsB0yJOfNR7BcLNC+t6kpU8mwbs2tGubq0yqDfIO3nCu8Lo1NPMzVXeDmSAHJTg40w8G9qwZWCwbFJg4yOp5yyEKRWcDHiHIr2tExw/ROyOi8yu5hh3iPJvB+DJIT3Gy0DSwP3CIVEWknOoUmuZDxOC188Za4/RXdGsVkAuInACQEW/uPPpG8BShddJtIuzgDOCHhmJ+RUaytQVWOUL9CAU6X4HoI2PLVJ8FsFG/TSjQFZsDQr8q74Ij/8Q/u+eVr6CjhtMMVHKkTNmZW+ZN9wFJwg0Hl8Dkh3oV6GTi2rSyxWIj8O37iyWBK55SBqPEf60Aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2uT8kU0UtsJyDpB7iR4PMsR6B3zrGoHNfnACRMYL/1A=;
 b=jspkRvu1wUStUtzFXgS6y6ulXd2F7Fpy0XGpoQxxueRtS4iExEcuQwxHsCvozNpGl/0lAvZ2LL5MjfoH6g0B1D0+sI36/V6GYozFE8lOD42aHcuMzuyL24UMBnZ+9GZFOfL01Y4xy0gXAQqLi4BtJJyzCC0pnSfi8BwJzVQX94DKOZobpXn0Fr9ZQ56pvIQIjpOXQAxrNbosiNqFYnc2LBu0+wPKKOrIHlVnAE27DFKdN68TBhSXOYQnwib+36HgNi6/YsFhOSwsuJj1zJaWRdsfCOx21fqv3EQL8YtB7686L54zVNuLrVZdDeJIMcHoIOhutcukXS0pLw/R0BynfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2uT8kU0UtsJyDpB7iR4PMsR6B3zrGoHNfnACRMYL/1A=;
 b=g8oICtwQ+PRZUDS1qgJaseNxD4jid3spCPkPGuNi2OHS90RzCQsGi3Hz41Uh9XyR23WfADU0AmKUOUg0w30VhfsTvWXQ7FSH+UXJrhIa8Gtc5pj7wy0iUSCqqUnYcXGKI39Vm7z7xLRAqZxM+cnJqI4Gj4PP3x4+bc03EbuMclTZqdSfs53flgaVSru9yfzlvtqrTJltUCUtUti9M/BdgY2KmLAZX2QnS34uWYjq7Gx6+q+P2VFOhWWghB6lG5AN5+KXxhz0Am4C9SXkfB9dpPIUZhnOzO9fhHNbrtk0Mhq6t8uU58S947U84ljE5qvodbYPYtJbjbl/YnkfXYkx5g==
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BYAPR12MB4775.namprd12.prod.outlook.com (2603:10b6:a03:107::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18; Mon, 12 Apr
 2021 19:07:52 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::7cec:a7fa:db2e:3073]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::7cec:a7fa:db2e:3073%9]) with mapi id 15.20.4020.022; Mon, 12 Apr 2021
 19:07:52 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     "dledford@redhat.com" <dledford@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "Lacombe, John S" <john.s.lacombe@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Hefty, Sean" <sean.hefty@intel.com>,
        "Keller, Jacob E" <jacob.e.keller@intel.com>
Subject: RE: [PATCH v4 05/23] ice: Add devlink params support
Thread-Topic: [PATCH v4 05/23] ice: Add devlink params support
Thread-Index: AQHXKygnOko9SmU6R0GbDW2iBlZsF6qpJjuAgABk9YCAAB40gIAHVsKAgABDgiA=
Date:   Mon, 12 Apr 2021 19:07:51 +0000
Message-ID: <BY5PR12MB43221FA2A6295C9CF23C798DDC709@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20210406210125.241-1-shiraz.saleem@intel.com>
 <20210406210125.241-6-shiraz.saleem@intel.com>
 <20210407145705.GA499950@nvidia.com>
 <e516fa3940984b0cb0134364b923fc8e@intel.com>
 <20210407224631.GI282464@nvidia.com>
 <c5a38fcf137e49c0af0bfa6edd3ec605@intel.com>
In-Reply-To: <c5a38fcf137e49c0af0bfa6edd3ec605@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [136.185.184.152]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4f9525c5-d864-4281-31a1-08d8fde6455a
x-ms-traffictypediagnostic: BYAPR12MB4775:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB47750AF80E69FECB9691B386DC709@BYAPR12MB4775.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iSv7H+yq5Zjxn5j2+J+pmaVL8XU9IQurgIxIUoRTCdqAZpqRGXCaj7YsfZyn3PK6YJ8r9qcoEQZ8hS3IE+KhRaJXb8/Ivba0JuPJZzet2gzItc9tje1uL1xS8dZo7YYDAabneuraaheT7SUtsYJbMFG7O7djPawXYWG0WQnmgg5qpAXIUVZRTH6iyDKsgKYVCF6abf1EIN8koggqb4CJXxv3QncBSzKDh+2uRwOA2da6dcc+XS7pxVfLgryAh/IvB2oWSC7w0pxqcso237T0m/7aHZdnDymfgARzgLHmgZPz4xUQrpmp3uz2QBPhkSmRolVjy5oCoB3zUJXxAE/YFO1b7HuxNZFRMoRsqF/MBhulkbQ2zYQk4scm2h/q3Xh9Bgid3vjwpEfZZQ+hPCHMshNNFxZH8GB+xcMdI7JkMb+nW7KGIWKOJUKh4DdsEPdgiveTOBb+rk9hU+12x8uCyb7OMLdEL7T9b2ZaaoB0QTR65UBF5X/xYGt2kXM+xzpBFSuPQ4JyrKEc57+Z/m5GRnKSlEmArRmDakuzc4eX95NNUe1YZDHa0YCSXcdBzYh5rueq1AbuAjs/ol4zWZnlbLqNht8nZAvyMXJWhEkX+OM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(376002)(396003)(366004)(136003)(33656002)(26005)(83380400001)(8936002)(6506007)(66476007)(66946007)(5660300002)(186003)(478600001)(53546011)(86362001)(66556008)(54906003)(110136005)(55016002)(9686003)(2906002)(71200400001)(64756008)(66446008)(76116006)(7416002)(7696005)(52536014)(6636002)(316002)(8676002)(38100700002)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?po1zoAaYTCVnyqLM6f26RNKO8rEp0U34U304KNVIG97o6+Tm0/2q75qiW71D?=
 =?us-ascii?Q?kZmHMORxygnyXXCPn3Lbp7goCIfLXtVvvf2MhidGpo7cs8bwVYk9ocOb83Zc?=
 =?us-ascii?Q?mJrlhV9f/5/xgPTF9EjE3njvoz0E+cAYVSHiLmnhNN7DzASDLTxnMs1qhliV?=
 =?us-ascii?Q?mFS0E8q14orFJN6qqSwhBU7PbioBzQmTjKwV9AHOoDUUFSmNJPyfiLmh+Mpb?=
 =?us-ascii?Q?Iz4V8BxGOjYMTCOpps/PjxiX03okKocCr/waiT/Vn5pt6EPoL60nSSr9+nMc?=
 =?us-ascii?Q?z9dF0+XKFSHNE21O4/9iTaki/3hCYHNDMVDFwCP5XmDLHlFL+lFAvnvvxQrT?=
 =?us-ascii?Q?ZpqAuSpTzxsz8kLWqqhqXJXZTZZ5DBbLcZVkk4cLRdzer4pQ7P+oo6CwdzCY?=
 =?us-ascii?Q?/0xMkcS8g4wai4F52Ui6Yc1cHsi69WkrgwXIjvLjgJ1XO00QcjeOXvgIV/jP?=
 =?us-ascii?Q?9MN0e7CqHcBywbTNiyCf2ol0yUYxCxeLR0h3sqKWD1M/wOQjdvtvnOpziMhI?=
 =?us-ascii?Q?k6gjZoaNbkLumnvRHgAm95EjLmerlibZbPt2JyD3DbtDUbFisGvBzu92T2DL?=
 =?us-ascii?Q?IJ3gQ1Q1t7mmEW8ThrpyTwwc7kmVziLo6yk6NVZDtiLEnM49R7/Ug+5Zk4lr?=
 =?us-ascii?Q?Kz9Y9HZejGqS++qDZ0OfqX+Wk8htVL4ZfECgx/nSdV85KzJ4D8SEiM9FBI2E?=
 =?us-ascii?Q?bG6gu73K3F/jZ/XEUXYuUWnOeFkR0HJRlMuvhc8ZQ+131PIpegZROzFBTmpe?=
 =?us-ascii?Q?wGffxjKhm6nw2Q1JGfpq7wn4shH45J+XDL93Ctnj8GFpxBntsac2pwQ+fdm/?=
 =?us-ascii?Q?yeTwpyghVc2oZI2NsYGx4S3SSPrfs4Tcj13Uis5jIOl1Xx/xUOjAqRcoy1sW?=
 =?us-ascii?Q?brT1iSs4rvcygH6qsr2+CsGrsHM5hFgIbqnwtztZTownSzqm/zestwG1dI9F?=
 =?us-ascii?Q?t1q07jXnlOLlhgzsX6GR4Fx+GVNsDCZuO1Mqz31CBCDmWW/7qUyCYX9DHcqE?=
 =?us-ascii?Q?qI68ghPVnyVIRzIE4h6FbKyC/RuXeffyJM+Fmm72XmUlJ1Je/c4UVYXbW5OU?=
 =?us-ascii?Q?c/ret078Woto2qytJGpzH79v1Q5TSxjoSSZGiLS+9Hw5xfZANvWviMFmZvxg?=
 =?us-ascii?Q?NBPDG1gIlRdI5AUIopSkurDMAvpBnkV/1q7xbxyBuwpQM9EGrBxoxn6FvCDA?=
 =?us-ascii?Q?/KDN+iVkwziIJhbgbac5qDk5J7Lurcv25ZgZAiwEoxqijjbmglYHFO5tupJG?=
 =?us-ascii?Q?SrqSOtWP4lFaNLen0ZSWZ4ceLa5th7MvceZuz2KrU9DMnNZzlUN7iHeuaZZ8?=
 =?us-ascii?Q?K4k6NsZFio3lYfjwCfF5VAJG?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f9525c5-d864-4281-31a1-08d8fde6455a
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2021 19:07:51.8618
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B7zrYq2i5PGy9hcJT60WZxD2RTzAqcG2+EJHoMn0FYON2cBknXv+9kOb22AkK/E+Nim4P0G5Ico1dZfBBXIbyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB4775
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> From: Saleem, Shiraz <shiraz.saleem@intel.com>
> Sent: Monday, April 12, 2021 8:21 PM
>=20
> > Subject: Re: [PATCH v4 05/23] ice: Add devlink params support
> >
> > On Wed, Apr 07, 2021 at 08:58:25PM +0000, Saleem, Shiraz wrote:
> > > > Subject: Re: [PATCH v4 05/23] ice: Add devlink params support
> > > >
> > > > On Tue, Apr 06, 2021 at 04:01:07PM -0500, Shiraz Saleem wrote:
> > > > > Add a new generic runtime devlink parameter 'rdma_protocol'
> > > > > and use it in ice PCI driver. Configuration changes result in
> > > > > unplugging the auxiliary RDMA device and re-plugging it with
> > > > > updated values for irdma auxiiary driver to consume at
> > > > > drv.probe()
> > > > >
> > > > > Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> > > > >  .../networking/devlink/devlink-params.rst          |  6 ++
> > > > >  Documentation/networking/devlink/ice.rst           | 13 +++
> > > > >  drivers/net/ethernet/intel/ice/ice_devlink.c       | 92
> > +++++++++++++++++++++-
> > > > >  drivers/net/ethernet/intel/ice/ice_devlink.h       |  5 ++
> > > > >  drivers/net/ethernet/intel/ice/ice_main.c          |  2 +
> > > > >  include/net/devlink.h                              |  4 +
> > > > >  net/core/devlink.c                                 |  5 ++
> > > > >  7 files changed, 125 insertions(+), 2 deletions(-)
> > > > >
> > > > > diff --git a/Documentation/networking/devlink/devlink-params.rst
> > > > > b/Documentation/networking/devlink/devlink-params.rst
> > > > > index 54c9f10..0b454c3 100644
> > > > > +++ b/Documentation/networking/devlink/devlink-params.rst
> > > > > @@ -114,3 +114,9 @@ own name.
> > > > >         will NACK any attempt of other host to reset the device. =
This
> parameter
> > > > >         is useful for setups where a device is shared by differen=
t hosts,
> such
> > > > >         as multi-host setup.
> > > > > +   * - ``rdma_protocol``
> > > > > +     - string
> > > > > +     - Selects the RDMA protocol selected for multi-protocol dev=
ices.
> > > > > +        - ``iwarp`` iWARP
> > > > > +	- ``roce`` RoCE
> > > > > +	- ``ib`` Infiniband
> > > >
> > > > I'm still not sure this belongs in devlink.
> > >
> > > I believe you suggested we use devlink for protocol switch.
> >
> > Yes, devlink is the right place, but selecting a *single* protocol
> > doesn't seem right, or general enough.
> >
> > Parav is talking about generic ways to customize the aux devices
> > created and that would seem to serve the same function as this.
>=20
> Is there an RFC or something posted for us to look at?
I do not have polished RFC content ready yet.
But coping the full config sequence snippet from the internal draft (change=
d for ice example) here as I like to discuss with you in this context.

# (1) show auxiliary device types supported by a given devlink device.
# applies to pci pf,vf,sf. (in general at devlink instance).
$ devlink dev auxdev show pci/0000:06.00.0
pci/0000:06.00.0:
  current:
    roce eth
  new:
  supported:
    roce eth iwarp

# (2) enable iwarp and ethernet type of aux devices and disable roce.
$ devlink dev auxdev set pci/0000:06:00.0 roce off iwarp on

# (3) now see which aux devices will be enable on next reload.
$ devlink dev auxdev show pci/0000:06:00.0
pci/0000:06:00.0:
  current:
    roce eth
  new:
    eth iwarp
  supported:
    roce eth iwarp

# (4) now reload the device and see which aux devices are created.
At this point driver undergoes reconfig for removal of roce and adding iwar=
p.
$ devlink reload pci/0000:06:00.0

# (5) verify which are the aux devices now activated.
$ devlink dev auxdev show pci/0000:06:00.0
pci/0000:06:00.0:
  current:
    roce eth
  new:
  supported:
    roce eth iwarp

Above 'new' section is only shown when its set. (similar to devlink resourc=
e).
In command two vendor driver can fail the call when iwarp and roce both ena=
bled by user.
mlx5_core doesn't have iwarp, but its vdpa type of device. And for other ca=
ses we just want to enable roce disabling eth and vdpa.
