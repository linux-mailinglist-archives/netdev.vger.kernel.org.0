Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E46947C9A7
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 00:22:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234989AbhLUXWZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 18:22:25 -0500
Received: from mga14.intel.com ([192.55.52.115]:33532 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232112AbhLUXWY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 18:22:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640128944; x=1671664944;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qnsYP5spvI0cuGaq2YqQXheL0l4mBALyBfX4HrCoNms=;
  b=Z03bCxqTyYwDOrgx9ElVoVLp6zfi8nfsdwsdlMFjXharbdFmaMh6vms7
   +XdbkOGyi1DDxqWA8fvotbCSRkr0ic8vRzk9i8l2BGq6JDwP29M5gKW46
   efpPMwQNbDN7KKLGv+yUaPq6bwmtQ6sUnV3ydghLfJs1+0cmPdJZ/UOJU
   zYH2t3AXsTts26Oe0HZpnmxKD98wY1EUXfrko3NRsyotsthoReZaLxEPZ
   weWfw3IjWuxnIXwBL0PH1MbsleRwFOBw8wOExmTadgnk5kD6ciwZowDXm
   4i7mdo2ryzN0dyzmEs06isLHq8ILa0VJSxzE+db1vBPFxIiH+C7LkkC25
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10205"; a="240734293"
X-IronPort-AV: E=Sophos;i="5.88,224,1635231600"; 
   d="scan'208";a="240734293"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2021 15:22:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,224,1635231600"; 
   d="scan'208";a="664097444"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga001.fm.intel.com with ESMTP; 21 Dec 2021 15:22:23 -0800
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 21 Dec 2021 15:22:23 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 21 Dec 2021 15:22:22 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Tue, 21 Dec 2021 15:22:22 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Tue, 21 Dec 2021 15:22:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nrpu2oN9c0Q5sZAPXHwhsJPOVL/mbcm0ysnWvQVX9zjvlkwHS+A7gelP5jAP3gzBNe9DdIFtkIJa7e2A3MEoSVt6jT0FXLMpkfG5EF4GHtTVNlwUEDhVWlmP82qFQcFe1Aw7BVJf1xHf0CvjSWjq0RL9RgQxi7kc4og5cxLN3GaiL8FF/hnN+A8CFlTN13UyFo8zJ1RWa47A/E5aLwC2PVMkhbzOgi5Vbw8YoikpayUCtxVS9ekCmouHjZjWYmEANetCypAl3dsskJzKTNVHvK6JGybT+zjFGFneSvp28+IFteRottHgo9g3qlnpo01GmStLRb19bDDuUsHgga9j0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sb63dncIPzle/cvHbZb0HEqpClJoSki60wMx/5FjGv8=;
 b=bI/6iit9qmtM8XLetmIpgu103mjnAAj44uG98y6tN8dvoM8gPqCkYjcLsSK+v1qzGqhpaIOnZFTFYinNW20IRwQrcFE/goBQDdz8IhE55A3VnaXSKPLe/8lgCSLKCSc6r05DMuhQlYxiDeEYC259oViCtbBc9UgNdKXlw5x1s9Wb0+gV+E8mF7ntW+L/eZ0Nd3pOU4JxFEAhrC7W4rT3YMVNBxzZDvZLRIwa/S9LQiXKIU2mBBom7J/8f+Y591gd3NeBpk66RzwqzNBwpq5QS389MkPxNtzJrjA0m/NsnmlEp+eUrKNPwaUdfGS9V5XxvaY3ZgHbL4ekZkIAa1DCWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ0PR11MB5181.namprd11.prod.outlook.com (2603:10b6:a03:2de::10)
 by BYAPR11MB3415.namprd11.prod.outlook.com (2603:10b6:a03:81::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.18; Tue, 21 Dec
 2021 23:22:21 +0000
Received: from SJ0PR11MB5181.namprd11.prod.outlook.com
 ([fe80::71d4:f7b9:12fe:d9cd]) by SJ0PR11MB5181.namprd11.prod.outlook.com
 ([fe80::71d4:f7b9:12fe:d9cd%4]) with mapi id 15.20.4801.022; Tue, 21 Dec 2021
 23:22:21 +0000
From:   "Chen, Mike Ximing" <mike.ximing.chen@intel.com>
To:     Joe Perches <joe@perches.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "arnd@arndb.de" <arnd@arndb.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "pierre-louis.bossart@linux.intel.com" 
        <pierre-louis.bossart@linux.intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: RE: [RFC PATCH v12 01/17] dlb: add skeleton for DLB driver
Thread-Topic: [RFC PATCH v12 01/17] dlb: add skeleton for DLB driver
Thread-Index: AQHX9jcKOP1y1O92CEC3pIeygh1pI6w8hGUAgAER9fA=
Date:   Tue, 21 Dec 2021 23:22:21 +0000
Message-ID: <SJ0PR11MB51812066CF2DD4458231F280D97C9@SJ0PR11MB5181.namprd11.prod.outlook.com>
References: <20211221065047.290182-1-mike.ximing.chen@intel.com>
         <20211221065047.290182-2-mike.ximing.chen@intel.com>
 <60d35206a67a98a0d0fd58d6f47c8dd1312e168e.camel@perches.com>
In-Reply-To: <60d35206a67a98a0d0fd58d6f47c8dd1312e168e.camel@perches.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.200.16
dlp-reaction: no-action
dlp-product: dlpe-windows
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9ca5ccee-da49-4501-ebed-08d9c4d8bcfb
x-ms-traffictypediagnostic: BYAPR11MB3415:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-microsoft-antispam-prvs: <BYAPR11MB34153AC7A2513CAE191C686CD97C9@BYAPR11MB3415.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2ES2MKl+Gyd4R5DLq56oONLLiErqw/0DYwNpPR4IRVnxxT8syEJ2IQh4Thi9egJKbOWrsRExTuww1cQXNDKF/pFHzZ4ul/3ePDJLgs7mIBA6QvWPrLZtiPKg9Fobo9COHQyrN8srf71qH8qEml2yfDUIjYaEjgtEjcBvhLwSRcdgPrdFu9KRla6K/9Oisy9E2g1GVixaIjAQd+R2wlOriFa/hvYfn5csc51V7u34xULBsrYx/5U5v/Xs7DPKS5Qp7VVw67m7iuIDFg5pILUtcJ8YWv0JgCNSylL5JrbChkOe9Jd0wvYr1f02u5zL2hO/ZSP3yRz+HkJLCBegzoSaBNnLGbT3tJl9e8gpVnXwYXYnrcJVXdAy6oP2GsfkhStfXnJXtZ/U0ROo5NyvZaECFORGSyQfNS8cbGkDiZzzr/Xw+8SvhlRsIlO9h5oUd4Hm0TCFR9/MZ3CGT+kM8sjaVVB+Yse7YMis75KjSqNZD09KAW1XuvV7VUA1GWsnK2peKSq17cfmHcYX/xqfRO744bnv9qAFIeE7gDysV4GKTeF5HPbCTugiap4xi2oFJ2h2kEXDFmIiiRHvsqTBZvXUSidu5VNxnKnCU7nARFUqzauusc3kxY6Dlak1AyyHoqCjijX83Lw+ubmvPWSskV+2Gl79ftuatZK0YFqbwFdm5Ee1KGNjGu5PSjGJQnW2PCmNgQsR8mCJSfzsgw2dvWFfCtabzlf4Lu+nkLVqy6Y5dBXwKloS+mgFfge0PlSadWyxY8/7KIQGaNa7at9KSzkppuW+AhRd+ka/Yo1ykJP4GcM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5181.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(53546011)(52536014)(4326008)(7696005)(9686003)(6506007)(2906002)(5660300002)(38100700002)(186003)(122000001)(54906003)(71200400001)(8676002)(86362001)(508600001)(76116006)(55016003)(8936002)(26005)(33656002)(966005)(66476007)(66556008)(38070700005)(82960400001)(66946007)(4001150100001)(64756008)(110136005)(66446008)(83380400001)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?8CS+3Zx1kiDK6150yXGU+dTqfTn6y2CRRpwpbBXlfN4dbml2vru/lvVmJCn+?=
 =?us-ascii?Q?pooXOxvTKdihYOXrPDKxFcuCtQNEsZvA+EDQjwWeuCXf0cJRpGQYwaf4vLRg?=
 =?us-ascii?Q?0QSbV9+bGPLu006G1YV8qzJpDgHMp0ExoUwd3SK69/qviwBXQJLudUyfu+Lr?=
 =?us-ascii?Q?5dJi30dbrwwSZgRBhZ2A96s8XRBAp3L6bGaiywcpGghbvpekML9gYnLkgxMk?=
 =?us-ascii?Q?yo5ZU0KeKeuofTF7e0lv1eIzukaU6EiWOdy8MvBiWJUPPXH867dEBtPiXiB5?=
 =?us-ascii?Q?rsa7ONW/CNVw/BZ90EcD9EF/FEIYN3zsc/DPsSZ8faKf1ID0aaGnW156irw4?=
 =?us-ascii?Q?JLMLUl1EGxqmzA0EqJbCMWn4yY4keO6MaLqJ7To9Al6rga/abIlMmw+Id7JW?=
 =?us-ascii?Q?Rf/JCPs8KYhG6OwNndMnX7g1U0VS5XtWNiIwz078OqtSKJW/Nr5Pte0PrWhE?=
 =?us-ascii?Q?OhuoXG7SuEdeLfoVskFEZo5Zc2FZ+TD0Co0RyJ09NrD55uoVtn28I5SbjkHC?=
 =?us-ascii?Q?yZx6yaaazlMfop5zeG4yKHopuLvobx/6JPM1mlRQQ27WQYwYRrYTFIJiWIie?=
 =?us-ascii?Q?1oDFgyCxoFbzoun2jUehr1yiWgM7FWWI6hkOBQuwAnStC/DUlJjbUHnah/yZ?=
 =?us-ascii?Q?Gle3neor/lJ3bLlQn5JqrRW6S/Ufz4PmGe01bedY+Bv6Cd87a6acgwT3FXF5?=
 =?us-ascii?Q?SPoj4ZsY+UX6XVXeDwnozuWzELsnFsyYy0J4tk3GKj8WCjOeojm/RIEpng0D?=
 =?us-ascii?Q?O6xifqjziiILjQsR6kVNTsQi0n8ug25zv+vr4pKoSrZRv9w72kilw/vtmf1l?=
 =?us-ascii?Q?eWF26k//FJZnqTSkMhylp8Xn4i4ChUR7jMoHWAGwGHebV65RcMNiwXRbOslg?=
 =?us-ascii?Q?CaYTxIs46YZbVCOlbuvuvr2MnRl11I5Xs/CTHDMItEroBse6WUbiN7hURNac?=
 =?us-ascii?Q?7KcfykeGg+LgGxQRhufcpffkhj2NGtbMneZQqpOXb9WOr5JGSBvZA1axORmo?=
 =?us-ascii?Q?Wp0NnfLgfpNw3wsgxZ4gjx28cucL15nXgV0HJglj2mIEZGpTSqAmF4A/m/wD?=
 =?us-ascii?Q?VCTW8l5GQOAIy/qdtWPP3rZMn4dUPiwgaZ52k2weRSQBhdQWs+lnqXbxmlQP?=
 =?us-ascii?Q?M4vb8CBn8vMCsGw6VHQBw6bUi6IxzU9oVMsPYCLru60HTk7uIpObSYH95L6y?=
 =?us-ascii?Q?BiWoG7alxaRESwgz1lRDmLH2qkbUE26+/eh6ucyWoNCwJyb/mTgrkP76UmAC?=
 =?us-ascii?Q?XqMw9AueqH+WnMpy4FfoWuYIXbVappBti5bHq3+Lc3YAFjTfPNKN2wpGaETd?=
 =?us-ascii?Q?8I/aDwrNgwWk8OR8BVcMAm79OjMeJI9faSftXvsrVs+6GMb3fAWwGkStP+6R?=
 =?us-ascii?Q?F7ljz08nFK0H8EvC5z3zkFMSyDtsEp246ehMibdsj6CIp8Y/sJCoFDK0EH/Z?=
 =?us-ascii?Q?w8HlKzJxHoK/Aegqmt7yCOfGRGE8PzTDMNxwu57hb15JMn6nCnfoZ6+83HVG?=
 =?us-ascii?Q?RCp6DpO0IGlafwbw3sO8RbESiE88NXPzzWVQoFNte7dNJIL0tnP0AvKhFTp4?=
 =?us-ascii?Q?DHq/q6p+ij2Cz1Cz3TWMhvDzBf8fitLuAF8C+rkR/GJIwoYtiI0uD4P1NzfV?=
 =?us-ascii?Q?BGZHXI/73WXv0TzE0hXw7Njv5yhfYEp589V/4f9V7I5F7oJjE/qR7LfXBn4a?=
 =?us-ascii?Q?LXppZw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5181.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ca5ccee-da49-4501-ebed-08d9c4d8bcfb
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Dec 2021 23:22:21.1617
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Rm9uSEHmExz+/N4cNbU1xPaqX0Z/fAqJTKxRA9nPV7sget3vyk5klZUSo/5sqCTbw1ipTTsSsvbe3QSe3kyoTuvt5xpPBxaQ2UHCLRzKNP4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3415
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Joe Perches <joe@perches.com>
> Sent: Tuesday, December 21, 2021 2:00 AM
> To: Chen, Mike Ximing <mike.ximing.chen@intel.com>; linux-kernel@vger.ker=
nel.org
> Cc: arnd@arndb.de; gregkh@linuxfoundation.org; Williams, Dan J <dan.j.wil=
liams@intel.com>; pierre-
> louis.bossart@linux.intel.com; netdev@vger.kernel.org; davem@davemloft.ne=
t; kuba@kernel.org
> Subject: Re: [RFC PATCH v12 01/17] dlb: add skeleton for DLB driver
>=20
> On Tue, 2021-12-21 at 00:50 -0600, Mike Ximing Chen wrote:
> > Add a DLB entry to the MAINTAINERS file.
>=20
> btw: Nice documentation
>=20
> > diff --git a/MAINTAINERS b/MAINTAINERS
> []
> > @@ -9335,6 +9335,13 @@ L:	linux-kernel@vger.kernel.org
> >  S:	Supported
> >  F:	arch/x86/include/asm/intel-family.h
> >
> > +INTEL DYNAMIC LOAD BALANCER DRIVER
> > +M:	Mike Ximing Chen <mike.ximing.chen@intel.com>
> > +S:	Maintained
> > +F:	Documentation/ABI/testing/sysfs-driver-dlb
> > +F:	drivers/misc/dlb/
> > +F:	include/uapi/linux/dlb.h
> > +
> >  INTEL DRM DRIVERS (excluding Poulsbo, Moorestown and derivative chipse=
ts)
> >  M:	Jani Nikula <jani.nikula@linux.intel.com>
> >  M:	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
>=20
> Section is not in the appropriate alphabetic order.
>=20
> dynamic should be after drm
>=20
Thanks. Will fix.

> > diff --git a/drivers/misc/dlb/dlb_main.c b/drivers/misc/dlb/dlb_main.c
> []
> > +// SPDX-License-Identifier: GPL-2.0-only
> []
> > +MODULE_LICENSE("GPL v2");
>=20
> Should use "GPL" not "GPL v2".
>=20
> https://lore.kernel.org/lkml/alpine.DEB.2.21.1901282105450.1669@nanos.tec=
.linutronix.de/
>=20
We support v2 only.

*      "GPL"                           [GNU Public License v2 or later]
 *      "GPL v2"                        [GNU Public License v2]
