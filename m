Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C9D82CEE4C
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 13:45:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729522AbgLDMoB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 07:44:01 -0500
Received: from nat-hk.nvidia.com ([203.18.50.4]:7702 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727385AbgLDMoA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 07:44:00 -0500
Received: from HKMAIL102.nvidia.com (Not Verified[10.18.92.9]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fca2ee60000>; Fri, 04 Dec 2020 20:43:18 +0800
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HKMAIL102.nvidia.com
 (10.18.16.11) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 4 Dec
 2020 12:43:17 +0000
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (104.47.45.58) by
 HKMAIL104.nvidia.com (10.18.16.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 4 Dec 2020 12:43:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FWBlR+w+FPi679wzeczw81R5t5pHFsnyeZUkOBrCzxulAVGyXwZ2V1lnSj7jhtwlOebHSBzk18KFeiLswTyajfsS6BIcYWSYzf+1nHIQ9K+a0W5lcCyf83k0biyO3e2DFQ5hCagoqRt+MEercUyyYypQh/BadBbhSX8v6khfTLquQBgl9Qmlmd3n/x1quX4PCwYIAtkYx8vUpRlNcEsQOXftHy8dORSWtFFD2eq1pWGfa8ia52aXayR69hIXkUSbXlYJ62SxBvwx3Duw7oWAGlX5hK7De79e1eC9sP7bCxkAIL2TTHE6urR39wVEK+1iIwOzK9QXhlVPjyMyrhOoow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kAJVaXCmFRSPxVCr/5VcNLDe4UflsgSnyxZYgxXtf6Y=;
 b=fDv45BfgWbMBeVOJr2udkfttdIAdIdtV1cTX/ZksAniLHIxNDkZZiBeZuPNg1h8/7qytR/XHrt5WcS1vUlShpVHazpS3YoMXXAReDNkT7dw7q8J1HQYn8x67qwxloXewzpG6zGoOevDIbVkpJjp9zuC0IIJK8ZIn7O04M84oETDUP75KPRT85WTvAwLOdqh6JPfDwaumHIvLVeo22Kw09j+GTG4SE3Am9esQL7m3DHOhKafRTQXVhYwUa6/QQmZcMLAfqnc4nrHIvxkZUb+2FfG8q7Fj1//XKNdt5XZkJ2iAiQPlP12hkDKXEjZqVr65zLFceQeNiJGikAzY27DGnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BY5PR12MB4901.namprd12.prod.outlook.com (2603:10b6:a03:1c5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.19; Fri, 4 Dec
 2020 12:43:12 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::a1d2:bfae:116c:2f24]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::a1d2:bfae:116c:2f24%7]) with mapi id 15.20.3632.017; Fri, 4 Dec 2020
 12:43:12 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Leon Romanovsky <leonro@nvidia.com>,
        Greg KH <gregkh@linuxfoundation.org>
CC:     Dan Williams <dan.j.williams@intel.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Kiran Patil <kiran.patil@intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Fred Oh <fred.oh@linux.intel.com>,
        "Dave Ertman" <david.m.ertman@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Parav Pandit <parav@mellanox.com>,
        Martin Habets <mhabets@solarflare.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [resend/standalone PATCH v4] Add auxiliary bus support
Thread-Topic: [resend/standalone PATCH v4] Add auxiliary bus support
Thread-Index: AQHWyQ7pd8ZxA2567EKGArqNAvDN4Knm0w0AgAANyoCAAAKFUA==
Date:   Fri, 4 Dec 2020 12:43:11 +0000
Message-ID: <BY5PR12MB4322755E1990AAAAA5EFACD1DCF10@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <160695681289.505290.8978295443574440604.stgit@dwillia2-desk3.amr.corp.intel.com>
 <X8ogtmrm7tOzZo+N@kroah.com> <20201204123207.GH16543@unreal>
In-Reply-To: <20201204123207.GH16543@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.223.255]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1c94ec3d-2210-41c6-ec88-08d898522956
x-ms-traffictypediagnostic: BY5PR12MB4901:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB4901BDDF5B52EC3A25C42877DCF10@BY5PR12MB4901.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KTIVQlR+vjVLor9mcgRoVHOWtrJAz5NjKNqXci0izJH/SlxDXR7egRktrAdBCSl/DyjKZgzhv6acoJjxw3LIs+Yi5CMYiBc5XzpAtYB3qhH2OlIkIdmRuhuDOG8AGgtKWZslLHt7v9f0AfpDJqhWJZPWS31mBok5kMt6SOEkYR2IKH+HSX1HohAyq7+Vs/kPBshJC16CvzRGM1Y7deDAE2lEaJjISfsED8m5b0+GHoU6oKeUYfb23O4Iico+fL/2vmHQpGiTuC3QX1JrNF92zF14WEiVmqhtTyKphcLHf9HoOButGrEo9AYp9RKqLb41gI/ogbbQk5YmC5XuGumL7gHnenp4Qh/tEcmYPY/W1FWgkBw8jG4ZCRaoZG2OBFV59guru3bZaC3UfPYVAIGp4A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(39860400002)(396003)(366004)(8676002)(5660300002)(54906003)(66946007)(110136005)(966005)(66446008)(64756008)(66556008)(55236004)(186003)(8936002)(52536014)(6506007)(26005)(316002)(76116006)(2906002)(33656002)(7696005)(71200400001)(66476007)(478600001)(4326008)(86362001)(55016002)(83380400001)(9686003)(7416002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?bChCJPtVqkl6F+2hxMCajEnYVYwQjjxL2PKKTVn4z3koGB6cS0eBaXxvq7IY?=
 =?us-ascii?Q?G/A/cQSfwZaew4vYMt3AZMMKLY6xNjI9Uhe7+i3lCzabfZjQCqbtrfRYAq9U?=
 =?us-ascii?Q?8WCQGbo4V7hKyfVREsRL+trHmRB2qygcJtSZIslJvyRTIfKbEa7DAIDOLrwG?=
 =?us-ascii?Q?jva7FoXK59fhRCtKzIWOKB0280Gk4fC4nsoCTFBH0C5By50WtQM/vsYJMi5v?=
 =?us-ascii?Q?DRzeFzaiEr7yP7p3CXGcORlCZcnBgxb4DoQYi9up+zmyS7lwlz9YhU2skW+k?=
 =?us-ascii?Q?Fd5TJ2BH3lKNi5+6CK/bQBGz3q+XgHkUrfkeccrCbeJ73L56QQPx5gV5E3/l?=
 =?us-ascii?Q?Q4irbaKhBHsJyDi6YRt7G6DulmJdeE1C++uyoU34wj9DBuKPuWudjKDcvoTy?=
 =?us-ascii?Q?10jwEb/z4dl/S2DmFXUFqv2Pa+XvzMWQcdFQL57iiK1yh7hHOmwdMiwZTPRs?=
 =?us-ascii?Q?n+JOLBMj3OxWr5o4JQq02zeC7AmPbpYIkCrv+CGzI+mTkhOFBfjszLR2Ok+w?=
 =?us-ascii?Q?iv7u6dod/4yVzKE40awG+tNpxmzbahayU65w2nISpBJwwv++ssT7UzIqANBF?=
 =?us-ascii?Q?gMoOsuLkYvWSrnLVACWTL5O7lTXsDV8A8tUnRy1uB0sNGJUKPtJWprfSAXqi?=
 =?us-ascii?Q?YG0JQierw65N9DWYu2bFE71c9cCcH8R8n8hUR4CDZ8SWamieSlv+Qmqy21/R?=
 =?us-ascii?Q?18FYtqb3XXPQRy/YBxMFnT/MaCzHMIUZFUnhuJAnR2g8Ot7wwM2h9epgeyvu?=
 =?us-ascii?Q?io+efzbUxov/c1fFpgCf3uoGonBy6mzgiWmcxfCLy0XjFQK/DfQ+Ojz1NfVk?=
 =?us-ascii?Q?RvOkh6tpPKKavP+GF6bsnPHUsl+XtWQgIRktl/F4fQJPID1xHx1DAsBHoKcd?=
 =?us-ascii?Q?zkcCuh22UMq8fszkHx7PtpDXu9B9GjmRtfp5WM2YNu1mnVsp+6bGHFb14jYs?=
 =?us-ascii?Q?sKpvBczf/3Jlu/9OKwKhu4QFpxr15046+cM9prudkMI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c94ec3d-2210-41c6-ec88-08d898522956
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2020 12:43:11.9704
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RSqvW1hoM/vlcZiZadrXT1DOWKofK3zVUwFH10xmPgckXwmaRrJvGKVC/EhzwwsAFriMU9+W1A254VN6HG9Kfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4901
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1607085798; bh=kAJVaXCmFRSPxVCr/5VcNLDe4UflsgSnyxZYgxXtf6Y=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
         In-Reply-To:Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-ms-exchange-transport-forked:
         x-microsoft-antispam-prvs:x-ms-oob-tlc-oobclassifiers:
         x-ms-exchange-senderadcheck:x-microsoft-antispam:
         x-microsoft-antispam-message-info:x-forefront-antispam-report:
         x-ms-exchange-antispam-messagedata:Content-Type:
         Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=WUYw/GSg3zzY+n1SNK+WIe0KOBpUCHspTe3Ipgt1Mm1Xmi+v4qN1SXjE8LXZmh5Ng
         ZA2hywdTE/agkXYGuvfa5o55tG2Gy2MaHpbtCaToHb7o5oTvpVxDzCSTUTuBM6RNHb
         wMMa5iaLr4hffibJSVyM2U1zFcmeE27nPTG57uXMdksJ1T/oAmvRakWdI2pa+Q8c58
         NVm+o3yEdDqGe+emDmeZh/ghBWvKWAYrifEg1mHyl2Nca2t1hxhZxhpNezEAfifT8w
         rDtzToLCgOgkA0hFQZI8dmm1SefmtZ2rq6AHthCPtFNckWO12MJwHO3KEPyZVD3fLm
         NnaozDJVIXtUg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> From: Leon Romanovsky <leonro@nvidia.com>
> Sent: Friday, December 4, 2020 6:02 PM
>=20
> On Fri, Dec 04, 2020 at 12:42:46PM +0100, Greg KH wrote:
> > On Wed, Dec 02, 2020 at 04:54:24PM -0800, Dan Williams wrote:
> > > From: Dave Ertman <david.m.ertman@intel.com>
> > >
> > > Add support for the Auxiliary Bus, auxiliary_device and auxiliary_dri=
ver.
> > > It enables drivers to create an auxiliary_device and bind an
> > > auxiliary_driver to it.
> > >
> > > The bus supports probe/remove shutdown and suspend/resume
> callbacks.
> > > Each auxiliary_device has a unique string based id; driver binds to
> > > an auxiliary_device based on this id through the bus.
> > >
> > > Co-developed-by: Kiran Patil <kiran.patil@intel.com>
> > > Co-developed-by: Ranjani Sridharan
> > > <ranjani.sridharan@linux.intel.com>
> > > Co-developed-by: Fred Oh <fred.oh@linux.intel.com>
> > > Co-developed-by: Leon Romanovsky <leonro@nvidia.com>
> > > Signed-off-by: Kiran Patil <kiran.patil@intel.com>
> > > Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
> > > Signed-off-by: Fred Oh <fred.oh@linux.intel.com>
> > > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > > Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
> > > Reviewed-by: Pierre-Louis Bossart
> > > <pierre-louis.bossart@linux.intel.com>
> > > Reviewed-by: Shiraz Saleem <shiraz.saleem@intel.com>
> > > Reviewed-by: Parav Pandit <parav@mellanox.com>
> > > Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> > > Reviewed-by: Martin Habets <mhabets@solarflare.com>
> > > Link:
> > > https://lore.kernel.org/r/20201113161859.1775473-2-david.m.ertman@in
> > > tel.com
> > > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > > ---
> > > This patch is "To:" the maintainers that have a pending backlog of
> > > driver updates dependent on this facility, and "Cc:" Greg. Greg, I
> > > understand you have asked for more time to fully review this and
> > > apply it to driver-core.git, likely for v5.12, but please consider
> > > Acking it for v5.11 instead. It looks good to me and several other
> stakeholders.
> > > Namely, stakeholders that have pressure building up behind this
> > > facility in particular Mellanox RDMA, but also SOF, Intel Ethernet,
> > > and later on Compute Express Link.
> > >
> > > I will take the blame for the 2 months of silence that made this
> > > awkward to take through driver-core.git, but at the same time I do
> > > not want to see that communication mistake inconvenience other
> > > parties that reasonably thought this was shaping up to land in v5.11.
> > >
> > > I am willing to host this version at:
> > >
> > > git://git.kernel.org/pub/scm/linux/kernel/git/djbw/linux
> > > tags/auxiliary-bus-for-5.11
> > >
> > > ...for all the independent drivers to have a common commit baseline.
> > > It is not there yet pending Greg's Ack.
> > >
> > > For example implementations incorporating this patch, see Dave
> > > Ertman's SOF series:
> > >
> > > https://lore.kernel.org/r/20201113161859.1775473-2-david.m.ertman@in
> > > tel.com
> > >
> > > ...and Leon's mlx5 series:
> > >
> > > http://lore.kernel.org/r/20201026111849.1035786-1-leon@kernel.org
> > >
> > > PS: Greg I know I promised some review on newcomer patches to help
> > > with your queue, unfortunately Intel-internal review is keeping my
> > > plate full. Again, I do not want other stakeholder to be waiting on
> > > me to resolve that backlog.
> >
> > Ok, I spent some hours today playing around with this.  I wrote up a
> > small test-patch for this (how did anyone test this thing???).
>=20
> We are running all verifications tests that we have over our
> mlx5 driver. It includes devices reloads, power failures, FW reconfigurat=
ion to
> emulate different devices with and without error injections and many more=
.
> Up till now, no new bugs that are not known to us were found.
>=20
Subfunction patchset [1] that is using auxiliary bus in mlx5 driver is also=
 been used by verification and performance tests.

[1] https://lore.kernel.org/linux-rdma/20201112192424.2742-1-parav@nvidia.c=
om/
