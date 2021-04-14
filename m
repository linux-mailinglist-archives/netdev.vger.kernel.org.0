Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECDE335EC38
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 07:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347213AbhDNF1x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 01:27:53 -0400
Received: from mail-dm6nam10on2068.outbound.protection.outlook.com ([40.107.93.68]:7265
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230312AbhDNF1q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 01:27:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LPP7KNzPzjfvYVZe3TKk1o0HFvl7X0yvAyH5gScEwi2LK0iQG6CnWIYHEGy1lxbhXTu7W61P+gA1viv6vRXu3CRVcXVDCzEOVNktheTrekSKztoC4fIVgb4vi8c1XKuvlxLdbBtCTOK3gpOOJLtPeM9/Liy334lZc8xeHyyVuDvzApzyswXzVvv73Rbkn9TJzHTCnAJ9IHjkH9EHpLkF3WEdCTWj/gCqpVhN4JElPHt8E4ZWXpIxsjlsYLm4lFZ2BTC7m5wBoocolENHU/2KehPCh19tZM0tIrIhytBlJXZsDgpq81XGMTF05WRfe6MeDYTgfLEuqjyIMCHAxJXwYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n0zu/QZDMFzkmd+6GrM/p0jSGkx6LmMVCi5r3Abc63I=;
 b=fI/Gii9ly2FJm5YXI6OabLYzDdMx4rMoXK3Hmm3rZ6DVutdg8OAGwWHr7bnMyxLnHd2yqIgGOxhtqJNAIKy6LThoUeApDuUxPZGScXQhZ0so0bk6qelSvG592QLLi5KVigwmzUP7kSn7CFVWJ3GCWextmNC8yk4OeN4EmvASYyLuqjZ41eLmyIkxuccZqQC0Wa+xOJDT/iY7LQRnl/fDUNXawajCeRh7cSEe64//LwZdWu4IMuPQKRdR79cCEqgtbpe9ykF1hXTTiNWWafN/nc89sY26ujxz5V7jewgv4Px57IuTM8Gd8/xSuh3kcyKZZlboWludhE62tAScJ1eFIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n0zu/QZDMFzkmd+6GrM/p0jSGkx6LmMVCi5r3Abc63I=;
 b=bLBERvi4XkxFTUPYfaEgz0KTmbGjTCRiX9GeTZ4vEHyToofZv+z+W64gzVSkn4alLq40g4n6xLPN8tsVf9zCP2u1F9eKrqOKIiM8Sd507Q//lrsmnXvWCw/dJKbgu4dZI+Zz3wbAHkIgzP+VZaxWBqxEjxyhR/RZEf6rPXm/JSJ64636n3y4Eh6e4r/IRRjzjQlBvKrCo9eFUIG/+jcLManh3Q7nq3pwqsA6Max4pXcU58tltCJYces3axtZexGkH++0V4uUXnDrOEFagg45+d63VgfQUxqg+tt6GgQFj+J/GMJ0UvlNC3NIT9tu3xr84q1mbLPx6aXlnZ12VcF5Tw==
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BY5PR12MB4324.namprd12.prod.outlook.com (2603:10b6:a03:209::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18; Wed, 14 Apr
 2021 05:27:24 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::7cec:a7fa:db2e:3073]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::7cec:a7fa:db2e:3073%9]) with mapi id 15.20.4020.023; Wed, 14 Apr 2021
 05:27:24 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
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
Thread-Index: AQHXKygnOko9SmU6R0GbDW2iBlZsF6qpJjuAgABk9YCAAB40gIAHVsKAgABDgiCAAUwCgIAALvwAgABzKgCAAExc0A==
Date:   Wed, 14 Apr 2021 05:27:23 +0000
Message-ID: <BY5PR12MB43226AFA5002D7086597AC62DC4E9@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20210406210125.241-1-shiraz.saleem@intel.com>
 <20210406210125.241-6-shiraz.saleem@intel.com>
 <20210407145705.GA499950@nvidia.com>
 <e516fa3940984b0cb0134364b923fc8e@intel.com>
 <20210407224631.GI282464@nvidia.com>
 <c5a38fcf137e49c0af0bfa6edd3ec605@intel.com>
 <BY5PR12MB43221FA2A6295C9CF23C798DDC709@BY5PR12MB4322.namprd12.prod.outlook.com>
 <8a7cd11994c2447a926cf2d3e60a019c@intel.com>
 <BY5PR12MB4322A28E6678CBB8A6544026DC4F9@BY5PR12MB4322.namprd12.prod.outlook.com>
 <4d9a592fa5694de8aadc60db1376da20@intel.com>
In-Reply-To: <4d9a592fa5694de8aadc60db1376da20@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [136.185.184.152]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 71dc43b9-6000-43bf-fc50-08d8ff05fc09
x-ms-traffictypediagnostic: BY5PR12MB4324:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB4324C1BAA0CA6CFECF65C18FDC4E9@BY5PR12MB4324.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fIv7ywHN1VJRKrKca0NNFQYOfXBXRS1n++n0SOBCBkqIowzXMWZ3DqzX5U0eV3fwniJjiH7TZax0B7n0kpLCnPkhCkv3k02mvgenBTZKIUzMI6Jzve66tJdC3oX9IgEE937ITecISCpMx20N/6agPlC3mOZ/UnZ7jMV4aAhv2yj/Y7Tub8xh58sSR6oTcOLVIu3hiE2WT8ZEVrlQ/vNZljhj1cR9g66gdv8RaZ+EYWxAhmFOBC+fEmp+0/2h+bcltZ9Y0CoH0KcsNsxPyPT31okkVHdQtuyMnIZLFA0/Rw+URUFRHhdyq732pkebz/VGhAigRBy2cewi4x1V7Q7Q2X8Cnsb2tQb3PdEbv7//RDEg6s669hn1Ffa1Ugpd2ROz5zLezHDxhAe+FUwr8XWnc0KqVogX/tvf6SJdqSFxJLA8YnLOxRqSVt32+78iRO2ijnZwcIjze6TsRpM8gHIBwOJr6iYBhfFzZGoRcWcgFzX2qo4s4HDnoDX1RvpJOEjGd+oJTOLsWGzzV0c+mbImBugST9UpiTSS+Vh03NxJ+TlLUOqPM8KUEPHZqsvFiCPhezyaBWXoJE+F/IEALRdwhJHq6E2dL2LClux/gA6s6CJaz1R30NTeFWEfNqLNBH9BYAzg5Tw7KnrOGC8qqu257Y8oxSdWRSeDmAnRfg4J6C4IdOpJ811uhuk7tyhBq6mR
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(39860400002)(136003)(346002)(376002)(6506007)(7696005)(76116006)(9686003)(64756008)(66446008)(66476007)(66946007)(66556008)(4326008)(53546011)(316002)(54906003)(8676002)(55016002)(7416002)(6636002)(52536014)(5660300002)(122000001)(83380400001)(26005)(110136005)(186003)(38100700002)(71200400001)(966005)(8936002)(86362001)(33656002)(2906002)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?UTYB7kH+eV4RM5yBQYPiDa0BaCLjhFNWlgxo/1yTCTZWBZUOLFqlLHxAffX2?=
 =?us-ascii?Q?gOXCEKP5EqmaOvx42GGDPt4+lzj64m461xhd+u1TULzwDOUG/BZoxYtEo2vd?=
 =?us-ascii?Q?w0S5GXGpU3GF1Fi/PyQSLJ9jfRNRSBTF/PcxZ5zOXmePz1cYWhLBbImqp6ow?=
 =?us-ascii?Q?FPHJsXMlKSksqrAyGvu9jHPFIAWoVhaIhKdNyfWaodNAJfHP5WR6e0mZ0ihr?=
 =?us-ascii?Q?ZeK5cbOvWFfnPCED70DYplyJnS4/kMio3INJJ7JjywAJqID0fZ7Dp3PK6hO1?=
 =?us-ascii?Q?wGi6gpOSOoKXiZIBtFNMm6ELe9Yxal/cImfHzbNcmSOYC3hmlZQOifoO3nps?=
 =?us-ascii?Q?3mWXJwDMhXgkSq00FC8BZ2QASQz0tJfXKQTrbYSUMplsS3foIsfjDvLuyU1o?=
 =?us-ascii?Q?YXr8kQRtlIZUcf0jcLoiO54HyV7hwBhzQmR9AYOwRKywShuQNGhwKbRK/p5J?=
 =?us-ascii?Q?lBldZSj0mgRffV8JiJqxtxBdMby+qDGXuploEblvu3KfK8WvbQfjkmdJoFDg?=
 =?us-ascii?Q?2txyFm4ZTReWSaE8/7xDA8b8sXC/aSWO7AL+src0EEuBGvDULP5n+HyPq/UF?=
 =?us-ascii?Q?xScS8OaSac5hJKsILxfAtzvBjm4F6LCrNG2JiL4IAZcDURuO3w8FPpBZqE3r?=
 =?us-ascii?Q?QBfMkQdPEOXt1fSZHekYRFd6Gd7vqIn1hTK6UvdzQcmu6cOIfOoEnIznX3W5?=
 =?us-ascii?Q?/lQPJnKhYWqcUnjPiHw/+tNgow8dxgZhR/ugYbg7XiKExVf/Iqw16zWkswWr?=
 =?us-ascii?Q?W1h4MtYyuKdYqEFIoF4a4nUQ7tJYlWWuu2MRorNqYUFZO/H4KG87ZJXuvgPE?=
 =?us-ascii?Q?PlPUTqyqnYzXsrRZ+ZRKMnaGuX120tBKFJPOZszGLWFiCui2CXO90tFHmbQS?=
 =?us-ascii?Q?fu+MwSS6pBvHeqhn8On8SvYA4jjWhHoVxwWG+9GcOYX8ERHPm52UKr146BIB?=
 =?us-ascii?Q?AjRlJ5Ce0yRmWofrl22cXUVQrMM9hqgIMQ+Inp9f/sVwpEAlpj4bCWERnPLk?=
 =?us-ascii?Q?6lXJ3cpaRCApKw6N9voZwNyT1CkH4XEuKQqfose2o2fivVCeuMHKF9o7ZMmI?=
 =?us-ascii?Q?ImKwwyIuxaZxnLuEWiOZa03fnyJWsjq5EOpVXHIsgv2Mqu4MYBC2R2msEBqL?=
 =?us-ascii?Q?ThDScpPxrAD85/XX2FflnH8m/DsLVoDczwyQ2iuhjvJK38N/lWeEVa8IMZY3?=
 =?us-ascii?Q?APB1zwAeYZ31JpP3rtvwF+gXpfG8PsrumI2TMsxu1VefPtrWwnxfhSuEH7J4?=
 =?us-ascii?Q?msZYj0M1aoTvkFuaKjlaOr8DXpwcUO2+Eoo/95+qrydQq/G3bPkLZkYd08dm?=
 =?us-ascii?Q?gEfVdAkDZCBnl9+hf88iVvf+?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71dc43b9-6000-43bf-fc50-08d8ff05fc09
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2021 05:27:23.9415
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VtZLR2N+6R9K0shu1ucT/HDoDz2tYlrecnu0J9Vpw8H43aQyFoA6BVKVI3rrVvoejvwp5zkg0/9+giWTC6gEOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4324
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+ Jiri.

> From: Saleem, Shiraz <shiraz.saleem@intel.com>
> Sent: Wednesday, April 14, 2021 5:51 AM
>=20
> > Subject: RE: [PATCH v4 05/23] ice: Add devlink params support
> >
> >
> >
> > > From: Saleem, Shiraz <shiraz.saleem@intel.com>
> > > Sent: Tuesday, April 13, 2021 8:11 PM
> > [..]
> >
> > > > > > Parav is talking about generic ways to customize the aux
> > > > > > devices created and that would seem to serve the same function =
as
> this.
> > > > >
> > > > > Is there an RFC or something posted for us to look at?
> > > > I do not have polished RFC content ready yet.
> > > > But coping the full config sequence snippet from the internal
> > > > draft (changed for ice
> > > > example) here as I like to discuss with you in this context.
> > >
> > > Thanks Parav! Some comments below.
> > >
> > > >
> > > > # (1) show auxiliary device types supported by a given devlink devi=
ce.
> > > > # applies to pci pf,vf,sf. (in general at devlink instance).
> > > > $ devlink dev auxdev show pci/0000:06.00.0
> > > > pci/0000:06.00.0:
> > > >   current:
> > > >     roce eth
> > > >   new:
> > > >   supported:
> > > >     roce eth iwarp
> > > >
> > > > # (2) enable iwarp and ethernet type of aux devices and disable roc=
e.
> > > > $ devlink dev auxdev set pci/0000:06:00.0 roce off iwarp on
> > > >
> > > > # (3) now see which aux devices will be enable on next reload.
> > > > $ devlink dev auxdev show pci/0000:06:00.0
> > > > pci/0000:06:00.0:
> > > >   current:
> > > >     roce eth
> > > >   new:
> > > >     eth iwarp
> > > >   supported:
> > > >     roce eth iwarp
> > > >
> > > > # (4) now reload the device and see which aux devices are created.
> > > > At this point driver undergoes reconfig for removal of roce and
> > > > adding
> > > iwarp.
> > > > $ devlink reload pci/0000:06:00.0
> > >
> > > I see this is modeled like devlink resource.
> > >
> > > Do we really to need a PCI driver re-init to switch the type of the
> > > auxdev hanging off the PCI dev?
> > >
> > I don't see a need to re-init the whole PCI driver. Since only aux
> > device config is changed only that piece to get reloaded.
>=20
> But that is what mlx5 and other implementations does on reload no? i.e. a
> PCI driver reinit.
Currently yes, reload does PCI re-init.
However I am not seeing the value of reload if no config (param, resource, =
auxdev) is changed.

> I can see an ice implementation of reload morphing to similar over time t=
o
> support a new config that requires a true reinit of PCI driver entities.
>=20
Sure.

> >
> > > Why not just allow the setting to apply dynamically during a 'set'
> > > itself with an unplug/plug of the auxdev with correct type.
> > >
> > This suggestion came up in the internal discussion too.
> > However such task needs to synchronize with devlink reload command and
> > also with driver remove() sequence.
> > So locking wise and depending on amount of config change, it is close
> > to what reload will do.
>=20
> Holding this mutex across the auxiliary device unplug/plug in "set" wont =
cut
> it?
> https://elixir.bootlin.com/linux/v5.12-
> rc7/source/drivers/net/ethernet/mellanox/mlx5/core/main.c#L1304
>=20
Currently devlink reload for mlx5 is source of lockdep assert, use after fr=
ee access and a deadlock in net ns. :-(
Multiple of us (Leon, Saeed, Moshe) working on it resolve it.
So I want to stay away from intf_mutex for now.

> > For example other resource config or other params setting also to take
> effect.
> > So to avoid defining multiple config sequence, doing as part of
> > already existing devlink reload, it brings simple sequence to user.
> >
> > For example,
> > 1. enable/disable desired aux devices
> > 2. configure device resources
> > 3. set some device params
> > 4. do devlink reload and apply settings done in #1 to #3
>=20
> Sure. But a user might also just want to operate on just an auxiliary dev=
ice
> configuration change. As in #1.
> And he ends up having everything hanging off the PF to get blown out,
> including potentially the VFs. That feels like too big a hammer.
This is certainly not desired.

If we want aux device enable/disable to take effect when its done without r=
eload than above flow should be redefined as,

1. configure device resources (optional)
2. set some device params (optional)
3. enable/disable desired aux devices

Step-3 needs to apply the settings of (1) and (2) without user doing devlin=
k reload.
devlink core doesn't know on step #3, that reload_down() and reload_up() to=
 be done.
So driver internally needs to implement reload_down(), up() on callback of =
#3.
This builds parallel framework to devlink reload.

Jiri,
What do you think of it?
