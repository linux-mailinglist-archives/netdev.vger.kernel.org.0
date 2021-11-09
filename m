Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 858C044A018
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 01:58:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236593AbhKIBBj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 20:01:39 -0500
Received: from mail-bn8nam12on2070.outbound.protection.outlook.com ([40.107.237.70]:3329
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236525AbhKIBBi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 20:01:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c3hOF5cdid+ZoePQIQGbbgonWVljoLtrMU05BafKmeOsLTNKGAyqRZ79eWrGDLtHNlYq+2JZay5rdlT1oO9FDJR9ubL7geH1uIATT7SmmcuDp+HSw85vMe48BraXnsIXyYrcy/3oqr5hIXVWB6fB2//CU1AQbLoeWDw4Ky44K0fRxxfX028Wl/IsnsRHjYIi/aFFANZ2nPh8WTT7eL4rNUn8MgEm68km2Ernf6uJSoBpUm0qZaePZ4/I8zLLptGsjmVn2c42KH9VFachMRI4uSySrPUw59cQM8wR0pxabG0JzIYZzA9rdAgHjj+lORpEJlCeVhBFUVIc/RoBLJe8GA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=idwKaK48VWfqqWEmZ58R4Hopw9MowLgqInf3O86+57c=;
 b=GTd93PU9eMZYGr0TQWAJ1IW0t1nuGWdbByAigji58C4hO+TGJv1zoz49Ng61CJOrME+7YtWJiaYNw7lkwR2LF2kSQ74sFuOxHGLo7cQONqrdCst+X5I75u+g/BHwupNOah4Wa95V2Z6Km1cN9wvR3SkOPCGrJjnRg7+/QuzvFPYR8S8vZyEYmnFKwa/lDmOSEvFTV7JUcAex485z1M4aZu6Pa6swCDVMT+4oswZoHHYRjrmIw/EDtg0xRNNm1bwSjlXX04GjP7EvD9kOTnCxJWTo6l1xQnDQmAxd9G+/uFpjv33h7fI3sn9/F/XfHOCehKyK38GEncdVP+x6/jotAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=idwKaK48VWfqqWEmZ58R4Hopw9MowLgqInf3O86+57c=;
 b=HgxqK3j4DDKVhvsOZnbkl/1ORNhTos9et8dBHHRywR6KEqcqAvSVv1qwgd/esyIo6360bP9Pm+Z1KNo4SFpP2cdb+g09uvjnik6DA8ZJIh77Hi0D4Bwt3nehm0gU+gad/Md1/RxtXjjyFYMKcf6vH3SM5avHiSaXW7TGVq66dZM=
Received: from BY3PR05MB8531.namprd05.prod.outlook.com (2603:10b6:a03:3ce::6)
 by BYAPR05MB4135.namprd05.prod.outlook.com (2603:10b6:a02:84::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.8; Tue, 9 Nov
 2021 00:58:48 +0000
Received: from BY3PR05MB8531.namprd05.prod.outlook.com
 ([fe80::fd9a:e92c:5d9e:9f6d]) by BY3PR05MB8531.namprd05.prod.outlook.com
 ([fe80::fd9a:e92c:5d9e:9f6d%9]) with mapi id 15.20.4690.010; Tue, 9 Nov 2021
 00:58:48 +0000
From:   Nadav Amit <namit@vmware.com>
To:     Joe Perches <joe@perches.com>
CC:     "srivatsa@csail.mit.edu" <srivatsa@csail.mit.edu>,
        Juergen Gross <jgross@suse.com>, X86 ML <x86@kernel.org>,
        Pv-drivers <Pv-drivers@vmware.com>,
        Vivek Thampi <vithampi@vmware.com>,
        Vishal Bhakta <vbhakta@vmware.com>,
        Ronak Doshi <doshir@vmware.com>,
        Linux-graphics-maintainer <Linux-graphics-maintainer@vmware.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        Zack Rusin <zackr@vmware.com>, Deep Shah <sdeep@vmware.com>,
        Alexey Makhalov <amakhalov@vmware.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Keerthana Kalyanasundaram <keerthanak@vmware.com>,
        Srivatsa Bhat <srivatsab@vmware.com>,
        Anish Swaminathan <anishs@vmware.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 2/2] MAINTAINERS: Mark VMware mailing list entries as
 private
Thread-Topic: [PATCH 2/2] MAINTAINERS: Mark VMware mailing list entries as
 private
Thread-Index: AQHX1N78hdP2HY1w7EKJ7QP4MiAOaqv6SY6AgAAMZACAAARXAIAABd+A
Date:   Tue, 9 Nov 2021 00:58:48 +0000
Message-ID: <5C24FB2A-D2C0-4D95-A0C0-B48C4B8D5AF4@vmware.com>
References: <163640336232.62866.489924062999332446.stgit@srivatsa-dev>
 <163640339370.62866.3435211389009241865.stgit@srivatsa-dev>
 <5179a7c097e0bb88f95642a394f53c53e64b66b1.camel@perches.com>
 <cb03ca42-b777-3d1a-5aba-b01cd19efa9a@csail.mit.edu>
 <dcbd19fcd1625146f4db267f84abd7412513d20e.camel@perches.com>
In-Reply-To: <dcbd19fcd1625146f4db267f84abd7412513d20e.camel@perches.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f681ab27-68ec-4ec0-cbed-08d9a31c169a
x-ms-traffictypediagnostic: BYAPR05MB4135:
x-ld-processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
x-microsoft-antispam-prvs: <BYAPR05MB41352394B811717592C965FDD0929@BYAPR05MB4135.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jiNvar6PPnnrLoIuN62K+V7IEQi7r+dnS1+H82xhg2SIbGkfRMYZCTXkXC2vCwqfNRpCs+qy6GIkatzTQ0s9OifCcDD7tSNEXE0HWUUrg//A664RegswdcfAD97CQ5z8646dFp6Gxiu3U1rpx1ufjql8QZLfnGecHoXLYZ5RQyIb5C+gYZpF1WP3D+nRmK4Ea4h+kufUCoyqugXiOLhg8ErfePaU8MuhkxGKP+hHq8U466i5P6YMcYxYxOOgUX1TDXr17U+fQ4TIxX/nNS5UCV24qMKNqrt+74H5ND9kAU6LHVdnRgpDkePy4u+rU0htjYFxlKHJGDgUep++tGJ1dGN3LHuTZUrMwTsYAhUfiC/PIUFQpZtbgHMRkaJjIPjONeP7RNsyO0sSRituUFHBwg75c+FVxK6X4vi4SIaEMSiolBmod08zDNRYitMqZuUi3k4AI259KTFPiaEoI5DSUkL7md/q9F7jsGq77XzzgpLfOOOeS4pfCjotUvtC9wQnZfOtaCi4B5WzvXJt2MNzhqTD5DXd1O0c80nKeJHDProG6ttvIbwvxs4VRkWB0ehPmdm6u59CAwP35YeTv4HkbT7H8mZs0J7ziZU6Z9EZTMGJflG+8myWgb86VYEpwxbzV5OtjwhvkPqA74agYE163MoSirhvJcWNlJhI2XgDi+mwfp5QsgQqvv42hMyYUZVHLNsSBcTCRN8YhRouwxGv8e1BxfR2AfDkqF7EavW9bHX/lxaoBi9R0Fpyb5GQ3alqS+e5t3nffjulAg/dG76IPgliCWo31tMexIyXi5anM9KpG3WLhHjv++Qd3KzYuvUC
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR05MB8531.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(122000001)(26005)(2616005)(186003)(38070700005)(83380400001)(8676002)(66476007)(66446008)(66556008)(6506007)(64756008)(76116006)(66946007)(38100700002)(5660300002)(4326008)(508600001)(6916009)(33656002)(8936002)(6512007)(86362001)(2906002)(36756003)(316002)(54906003)(6486002)(7416002)(71200400001)(53546011)(130980200001)(223123001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?iA7HQWkoaUfxP7vnv3qEDfLK1XgtrXBXRiuj2W9SStUFF16pbGAqdFx2dDJT?=
 =?us-ascii?Q?TTscTpkDPRWmhiwCalGwJW4i6d7BV2mwU/nUAhqXJqtDOVtDJFBcGj57QdQU?=
 =?us-ascii?Q?57yi9xISFxpQh8C6vP4QLjUb0QSYWG7Y7We0schRHtToL5qUVQWnPxjK1wBY?=
 =?us-ascii?Q?cWwi7/VyEUM5MlZdJqNnn2nWFOq0EctSoqc/HyTdoIbOisY7CoYHNmrQNI/C?=
 =?us-ascii?Q?TIlFWxc8ohIj4hYWjMkI3AfBOCR55wD5EOhSwxhcMibsKf9l5Jbb90DPwzcH?=
 =?us-ascii?Q?SCjctkgrVCCi5h8dqqM3jO/QDLLjNzXyk/PIzkh5pKNxaByx6ct6J1lhGDiB?=
 =?us-ascii?Q?b40Ut8DK3eKAKmNIGafxrvNPM/AKIokMoOqH9jxZ+pMaunnQVAnOEiIUizSq?=
 =?us-ascii?Q?A/63USZpgdL6OTTIKX0VClp4AOLlhqBrDPdIRLGtcrnzeeSGnQScKyVrQbNE?=
 =?us-ascii?Q?Z4tuSL0BJVT8a7y3FrTi1c+8HyuvJwvOe7Qnk0et46pahzD6zQvW5I71YQAc?=
 =?us-ascii?Q?ouE5BaSKCikaNf5e/YHhPeBJabTIyPqdJSwJp2frlMziZF0Zz2983z37ta2R?=
 =?us-ascii?Q?cK6p6G/74lImprxtswlUEnys6VdlXTK3An4mAtIt8rHo8DueAU/hxPE4gCOP?=
 =?us-ascii?Q?e3nd74XIKucQW6nhGvr9cDh/olFybGdk8U5ieHpzdSkpUSgVyp/ZbBN02aVp?=
 =?us-ascii?Q?MX8MFVkk2GdS4Cq8bRNA0V0LFz/OJjdMB59fqwX/qdNj9B07beOjpiSo5iOr?=
 =?us-ascii?Q?gkJZb4WyhNxaOqF2jQDYs9Igj6O0ppd2vYhUeXuJjfKEchBEaln3z2cTqR/Q?=
 =?us-ascii?Q?Uh6X66RDGT+k/14E/Glu22iVihNSBeB+vR/BEhlHL1YRcUfPN32B6xofs3Mb?=
 =?us-ascii?Q?lK+5FHsIX6GM0hz/QuP8cCTfF0qyVuf2++s42zG/OigDZqf9td4vx8NlOuQY?=
 =?us-ascii?Q?TodAkJ4oqhSN5xPj48x6kNTlLTQxjRxDnGYszc/hNI/qiqOxgmwuicjOcQZG?=
 =?us-ascii?Q?dAjyLWudsTlJv3yWXEkIb90RA52/AH7gqwWbJwFTm8EpIK3GO2zA75rZ5grq?=
 =?us-ascii?Q?NVYxK00+r8RMb0/tIOuiPA/2KQwaxh1JTgNCN17PD/DGawN3GEGAW4pB82z2?=
 =?us-ascii?Q?T37ephnekw/Cbn5PBObKo5IelZzIHd1X1Msmlu8Jc9x0aiwmAvKycRgPJPIE?=
 =?us-ascii?Q?YJT/6v2W5OASEG8aGElu07igkRiP8jRdxx9sii+WSZ2NOyd7mwhxJlp7G9Ka?=
 =?us-ascii?Q?Eql4UtgcoQqMHIgqx7Ce4TZco0Yzlv0yUwrIpOzIbQ3YOBcp/O5JT9FumMbs?=
 =?us-ascii?Q?9YISLTXjbxFyrBjqKhZxsUa5I6YYyEp3/bdhpxcj1kDuNZsPUshmg+l8UsvE?=
 =?us-ascii?Q?ufYQBE1HYHnwAEvlVC00kGZOcN+AFyLO9rt3bDeRfF7m1IOETgiLpg53GTpm?=
 =?us-ascii?Q?x7R10pPN7SKzj9krNt11PVVXeOHLVwC5w6w79EDk3ySoFa2im3MwWLM6fJuj?=
 =?us-ascii?Q?7xWtfkrKcVqDK5qvChbtjcyGvw/eOKfAH51Lzdn9obly7xuISgURm/ZwQnNG?=
 =?us-ascii?Q?u5PwHdke9sVrZdEWQKk/SIWX99/Ny1ljhl4214Jkc2fnzOOltrTprwITH0P6?=
 =?us-ascii?Q?MzAfi5eHQmHW5YXu2dqfjI8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <16B8E008CE2765409961D5B2A5D9FE10@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY3PR05MB8531.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f681ab27-68ec-4ec0-cbed-08d9a31c169a
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2021 00:58:48.1558
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: V55+QxNM+Ihx9kPI4L0w/7OTJt0rFh12Zenss4eegKltcZ9RYe1uZ5/fpAgR8xYK7TNzRzQlJqHkTigINUkp5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB4135
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 8, 2021, at 4:37 PM, Joe Perches <joe@perches.com> wrote:
>=20
> On Mon, 2021-11-08 at 16:22 -0800, Srivatsa S. Bhat wrote:
>=20
> So it's an exploder not an actual maintainer and it likely isn't
> publically archived with any normal list mechanism.
>=20
> So IMO "private" isn't appropriate.  Neither is "L:"
> Perhaps just mark it as what it is as an "exploder".
>=20
> Or maybe these blocks should be similar to:
>=20
> M:	Name of Lead Developer <somebody@vmware.com>
> M:	VMware <foo> maintainers <linux-<foo>-maintainers@vmlinux.com>
>=20
> Maybe something like a comment mechanism should be added to the
> MAINTAINERS file.
>=20
> Maybe #
>=20
> so this entry could be something like:
>=20
> M:	VMware <foo> maintainers <linux-<foo>-maintainers@vmlinux.com> # VMwar=
e's ever changing internal maintainers list

Admittedly, I do not care much about how it turns to be.

But if it is modified, it should be very clear who the maintainer
is, and not to entangle the mailing list and the maintainer.

I am personally not subscribed to the internal pv-drivers mailing
list, which is not just for memory ballooning, and is also listed
as a maintainer for vmmouse, pvscsi, vmxnet3 and others.

As I am the only maintainer of VMware balloon, if someone is
mistaken and sends an email only to the mailing list and not me,
he might be disappointed.

