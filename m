Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40ADF3570AF
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 17:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353691AbhDGPos (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 11:44:48 -0400
Received: from mail-dm6nam12on2077.outbound.protection.outlook.com ([40.107.243.77]:46432
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234273AbhDGPor (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 11:44:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W/oXBHaHZfQUCo5ue2ifjO9leCdW+iRJOVfWg02zXu5LvRnnJO/SHoaa+xgWAfRIJfrpoJxHwWhpNcqMvhtekVF8rWNZaA92BeuEPp9H4anYhz8Q7SP3O6AgszI9tmS97bJ2A6TMfvuijNsmf17HhRRIaO9N/8RG2VzJNz3foF/KnOiZ0QSBybLivAc83jo4IWpp1gjuPaQ29ZbKOMyMep8iOvewfl+ZYczMBB/byUUQmdcKkcet4TQAK/2KSYunoD4fJfaSV1g+31bexoz6eBg4GAjq7EyMOkqp7s5nl1b3vBKiO+3RRoszxPRji/NST1tbz5JDPsOk4aWdoNWYgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RYZiurcn1tPeaeSIn7sp/7e22khogcpXLYolSNsBXKA=;
 b=P7/q8qWMiDxNBjk5d18yMG7M6/iPjfjkt3jft82HSv/ADULiWG/Kh5urdh8oRoc4e629amVMXi1mSVGu8QONFovq7vpBTMNWWdQdb4PS26c5KwMBWZGUdSl08hu1LKnexBoweV9C0YWL6/pKdpYNQA76UqRrdzO9JRUEEUuXNGJVclGCq3FCDWlDblZND2H0rSPIQEPCURQ/LWR8xsw88xwtTLsYJwIAb4rLD5CDgVD11+6/vfpBB5cALXxWbhuhv/wjUoPx0eoRVhpZpU2WOstCW35cbVSfGDNtDEgNkurROqqHxQhiH3fNoCnI+11tH3IaMykj46axzyvdP3SuXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RYZiurcn1tPeaeSIn7sp/7e22khogcpXLYolSNsBXKA=;
 b=bzzpxExsdtXJ+lV2fps/QXx2NsZlvRS8xegQcmf7Ec4JKTDL9hrf3JpEkbuhmt23idy7g2kn2dz2jCO7wEgHvcg21Pfpaz8WFiQ0Wag6P8uQ2G/UPbqqjpw2XDw/JcmNxEE5rV5csqwVAboGrJvirQwauE8LYwKx2ABKBoUnOH+u2/iIJ7bCUHQk0eGhpTnumadnhCuuvyfO/MBB32WnSB5sTecSRG7PUMAm9ljzA5z/eERb2lZhFZ3VhP1e5URUDgeQXGUrSoUtbGWPOP4I5TEvNpAhjbQY4nT7vaZAx0UhoWu97VN2aa0icRgz/bAs9PC/2lsOxJ0l22oJC1ehXA==
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BY5PR12MB4949.namprd12.prod.outlook.com (2603:10b6:a03:1df::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Wed, 7 Apr
 2021 15:44:36 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::7cec:a7fa:db2e:3073]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::7cec:a7fa:db2e:3073%9]) with mapi id 15.20.3999.032; Wed, 7 Apr 2021
 15:44:36 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Karsten Graul <kgraul@linux.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "rds-devel@oss.oracle.com" <rds-devel@oss.oracle.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>
Subject: RE: [PATCH rdma-next 4/8] IB/core: Skip device which doesn't have
 necessary capabilities
Thread-Topic: [PATCH rdma-next 4/8] IB/core: Skip device which doesn't have
 necessary capabilities
Thread-Index: AQHXKd+XJ6WIY5+vZk6+h+s0LuIetKqnpFkAgAGBvmCAAAdugIAABvxw
Date:   Wed, 7 Apr 2021 15:44:35 +0000
Message-ID: <BY5PR12MB4322B39A132397E661680A4BDC759@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20210405055000.215792-1-leon@kernel.org>
 <20210405055000.215792-5-leon@kernel.org> <20210406154646.GW7405@nvidia.com>
 <BY5PR12MB4322E477DA2334233EAD5173DC759@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20210407151359.GI7405@nvidia.com>
In-Reply-To: <20210407151359.GI7405@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [136.185.184.152]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2c25be7f-1f1c-4697-2de1-08d8f9dc0be3
x-ms-traffictypediagnostic: BY5PR12MB4949:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB4949468C5F8992889F78C953DC759@BY5PR12MB4949.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:935;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9f5RMlzYBqFr/t6Fmz6d7cpvzRMdm2Qn9Ay+suizSIgo+s0bYdnbDfRo5x7b6GjvlVQNrkt5En1hdrYjSNmqBeaJcZVyyN+VzTYv1PQA2jF53Ijw4W0n09L0QgzdtwDHf5ewfZ3H3U3BmJJsTkS2UPIlIyaYC5VfAInBr8LmBhhT90392SA2QIWuGFr4YrJb7Xq/bXa3XYrvVKJIO5ZaiJmAR01QsUFmmjgI7lTEubt57f7LyigLUeq4UD/G/Z2ljrEBowHv9E/MVRXZGRjNssd6AWen2oBNyqs7jbz1dj4iG76Ao0j259ijE+rOx7Bb87ciUkklguxMuzMThJI+4SfwwbyqkNoC5elnrZHODna6hVD3S/BckAe+5VRYCkKcaeACYBdHp8nm0R0nAsOk4onVvd2PE9OdPLbV5nNMAy2UEEOj/n50j2K5hFp/N1jZ1Wk8mIOmBWdIfDnh4avEQuITBT8sgNqXy5hyqeupPue6r5ogg1/9dqiW8SCMH/PI96Xx6NanLNGc0P1RLrmpR1/QhTFaQkdYw/QM6CwMYimZTlfiFGCzcILv0H0zGFn1LRtKi8S0mzdrv39AAA5X7DC/GhH/UvwitAzTj/ogKo2SovRxaO6qa/VFR5h4U7xQvw61pKcAvOsrwfJsUfLpjfsUSpKBlFQAhlT9Puv8HIM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(39860400002)(366004)(396003)(376002)(7416002)(66446008)(5660300002)(6506007)(64756008)(66946007)(7696005)(4326008)(66556008)(186003)(71200400001)(9686003)(76116006)(478600001)(2906002)(38100700001)(8676002)(54906003)(6636002)(55016002)(8936002)(316002)(66476007)(33656002)(26005)(6862004)(86362001)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?nw1KSlT2ckmEAxbfj8g8mAuVthVicth9yQ8Kf70qys7+x5sSiLrgcNxdYbM9?=
 =?us-ascii?Q?4RpSjN3DBsREqShDhuBG07h9wizuIZbOykAdmHb7AG/Mf+aWZIJbnfJLndmQ?=
 =?us-ascii?Q?XS6LW1oA/mES+5yc7fjw7mvj1APatJxdcbGuQxGwya7dbab01u7Jwxk20DOS?=
 =?us-ascii?Q?rlxf+AQdeXjqmvEbauoV6SzD/OQwNPWjFJSt0Yp+iJGbkWbnxXzcD5GqNHDU?=
 =?us-ascii?Q?ZKYGSSgqui+vSz4u8tFRSPHL15UonUQgdr4rDO6dEbO6HWcMJmJfzvXiCrVN?=
 =?us-ascii?Q?gAqzXuY/q+sDrwBYSceZoJazPgi14tOMLimIPhsjFTth4MpX+iR5FLmviyYk?=
 =?us-ascii?Q?x8XvgvQ0AHHS25uZDnbTe5/cXsseXzE5NYSSeKR/Vsu/tLG/gDEALhocm46/?=
 =?us-ascii?Q?fOagh8DsTQqIkWikOxUWoDzkQQky1gxFMs3/lHdTkrXwqebeFcoPElOTV6/O?=
 =?us-ascii?Q?jbvuwNuiWWwFujRYulDhP2PXDu7MP2Vb1vP1ae6l6b88mhN4eT5+utBGuuqY?=
 =?us-ascii?Q?2y6jc5hKI/gTrEb1SuTe7d2IkIi0rBkivDtX5wtPqr8Y2apVkBa0qrS5du9u?=
 =?us-ascii?Q?XjTj+9MP6nbTto43Xs8uJfW9g+xt9tr5QoZRnVZDqMrdbQyoQ/91IYLQXUCV?=
 =?us-ascii?Q?RjBmXiPaCT2b3UqGSO7SMnlN6tYl3gqGmXmPT7Ro6PkJux7AZwZRZpZ36i9A?=
 =?us-ascii?Q?UmjF5vSiizwxknzMoifwQ9Q2Bd8Pe+PfzScRl3YhUmxgHN4/xlUi7Cch9NKf?=
 =?us-ascii?Q?WGUaxvAJFqxGzX3praxXfkmNlm/mZp+IUf5ZP26Qeh+NNrLpCdmAEI7Pqfl1?=
 =?us-ascii?Q?HkgfemnTtMXb0UxwUkNlN6/Jfzjc7J/MZkU9D1ZcHrJlaOgZFA/pjnt7M+Km?=
 =?us-ascii?Q?PH1Rb9N5fbCTKDNwZt8+F2dHw6Yw/4050Y964n7ycnQ37+q+cCJ7gbrZlWz7?=
 =?us-ascii?Q?NHQimerrICcDN6MbIZoM1GTrxyiXMYOT1tcEQbbUk2DvFXHKTTHGjCgUSdfY?=
 =?us-ascii?Q?uXcEhBtnf0lsxpodTpO2MR1cRr/Tg/E00I5MSBlHSx4/s9qSOyC/+cyHd70o?=
 =?us-ascii?Q?6GFprbQqUaGWiPQFAXDZ0POQDLwI5AXbS70aVM9YfVPXGt8+In/wofRwzJb7?=
 =?us-ascii?Q?Z04LmUw6BpIHoqyi0cjAO3+nuSsPTXQnoDM9TNzwkinZUbnhXVWI4z/f0J+X?=
 =?us-ascii?Q?GFGh0Fw8Xf7l5h4q+WDzt76hETyuVTlyeoALKf3xLb3KZDqReGkj7ZfWx5XZ?=
 =?us-ascii?Q?Iw3pfSvQ91MeDDZgTO/K/tvkocc3sh9vDcUPUa9Y1LxH6nEdmwMile52SaHm?=
 =?us-ascii?Q?Eovv/zxCYcdMFBcUF8ncTz1K?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c25be7f-1f1c-4697-2de1-08d8f9dc0be3
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Apr 2021 15:44:35.9757
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ptQasQV48VV2ngKaeamGiKTOPEmfbf7/YNvLoKG/2v1wH9ukqjuyLKGC9Xco7mXzbWed0lMrF6lRTmcKcOI9cA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4949
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, April 7, 2021 8:44 PM
>=20
> On Wed, Apr 07, 2021 at 03:06:35PM +0000, Parav Pandit wrote:
> >
> >
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Tuesday, April 6, 2021 9:17 PM
> > >
> > > On Mon, Apr 05, 2021 at 08:49:56AM +0300, Leon Romanovsky wrote:
> > > > @@ -2293,6 +2295,17 @@ static void ib_sa_event(struct
> > > > ib_event_handler
> > > *handler,
> > > >  	}
> > > >  }
> > > >
> > > > +static bool ib_sa_client_supported(struct ib_device *device) {
> > > > +	unsigned int i;
> > > > +
> > > > +	rdma_for_each_port(device, i) {
> > > > +		if (rdma_cap_ib_sa(device, i))
> > > > +			return true;
> > > > +	}
> > > > +	return false;
> > > > +}
> > >
> > > This is already done though:
>=20
> > It is but, ib_sa_device() allocates ib_sa_device worth of struct for
> > each port without checking the rdma_cap_ib_sa().  This results into
> > allocating 40 * 512 =3D 20480 rounded of to power of 2 to 32K bytes of
> > memory for the rdma device with 512 ports.  Other modules are also
> > similarly wasting such memory.
>=20
> If it returns EOPNOTUPP then the remove is never called so if it allocate=
d
> memory and left it allocated then it is leaking memory.
>=20
I probably confused you. There is no leak today because add_one allocates m=
emory, and later on when SA/CM etc per port cap is not present, it is unuse=
d left there which is freed on remove_one().
Returning EOPNOTUPP is fine at start of add_one() before allocation.

> If you are saying 32k bytes of temporary allocation matters during device
> startup then it needs benchmarks and a use case.
>=20
Use case is clear and explained in commit logs, i.e. to not allocate the me=
mory which is never used.

> > > The add_one function should return -EOPNOTSUPP if it doesn't want to
> > > run on this device and any supported checks should just be at the
> > > front - this is how things work right now
>=20
> > I am ok to fold this check at the beginning of add callback.  When
> > 512 to 1K RoCE devices are used, they do not have SA, CM, CMA etc caps
> > on and all the client needs to go through refcnt + xa + sem and unroll
> > them.  Is_supported() routine helps to cut down all of it. I didn't
> > calculate the usec saved with it.
>=20
> If that is the reason then explain in the cover letter and provide benchm=
arks
I doubt it will be significant but I will do a benchmark.
