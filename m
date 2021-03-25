Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 696B13488CE
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 07:13:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbhCYGNY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 02:13:24 -0400
Received: from mga14.intel.com ([192.55.52.115]:21780 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229519AbhCYGMu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 02:12:50 -0400
IronPort-SDR: mqMW10rqQxWUcFLBytxS19URgO8/9VIXlcacoBXtn9UzjWHJPXVqixSL9ymK7gh79rsYXJL4G4
 9XIoPqESEX+g==
X-IronPort-AV: E=McAfee;i="6000,8403,9933"; a="190285768"
X-IronPort-AV: E=Sophos;i="5.81,276,1610438400"; 
   d="scan'208";a="190285768"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2021 23:12:50 -0700
IronPort-SDR: E0vFGGjy+DUsAz+Oujfd4GGRGpvbSkRqnWJ7A1SBBgr2wppmYlZ4JKLP8ePHTcHOT9nm00TUWI
 4Ba9ilIF8QTA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,276,1610438400"; 
   d="scan'208";a="442614320"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga002.fm.intel.com with ESMTP; 24 Mar 2021 23:12:50 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 24 Mar 2021 23:12:49 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Wed, 24 Mar 2021 23:12:49 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.170)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Wed, 24 Mar 2021 23:12:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z0r478CVXw2L+j/aNquHWBZpGwpVcm9/Z1Szdqo0mJRXsOD5hPZBtoT7er0Dim2g+5Z2UhO/3F5czH/pyA5jQd4ZJ7pqZUMy7JKnx0vmXZWB1e+Nw8tDQyhoZCSjzB+1yrRPXTLhz5X1jwCULLpfywoMDdm6MJm0M5aZmROVWht1NjYA66GfPTspKJNQ0o7UwWhd6mfzaoR4Dbtq+bzvLzJQgbF/0cuQt6MBvtKO6mzyCiR8W/dtTx/lygukHPSjAjGDU9jwbrF9MRNM9s/yqORnEhNE173S5jtu2VeshM+fgR0GMbNglUQdaXDtICFet6QyaUh4UUWSLEkKj1XryQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pi0b3jsOWgjL2XHyeLI3OJwpWRO1HIbOcmD8uZvLYcg=;
 b=WaG0NTbCgVwl0x1NllYye/zVB0yWWZFM1wA6J/Aa6QcNFmE/KkfGeSIOtluP7KiL5GXZy9zXHb83h+9JVOfeeQKgNLH/Y8xbH2vSF7C8XngkJ0ycw1+eby/+r9z4a4ZCwr3qdYewlTq6XCN7a6kMdYvmYTj63DR1Z3ttD2a7MfhRORvxH2k+hl/U5u58SDS+lQYrIStw4UWapVsN/+eNdUtnwbt7TEK7dvbBe56kRwpI9pTu1sZKa6yLc6JEkdAKWjo+8AEh8MCjwo33dDm/HE5EIdgImC3/ix78hS0VIbTHPPtzJclMqUlJV+aJcjICAyIaQW7GF3nElID61+Cd+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pi0b3jsOWgjL2XHyeLI3OJwpWRO1HIbOcmD8uZvLYcg=;
 b=pJHe0AzoX+57T1YOOhuoaaJKSnCYfrAQnYlRZa5TEHe4cgWiMXPTBZ8aRTB5pJM5MBzqxriac0jyEhn+aj0VfDGQsjjimAwSQdmkzkr2SMnvkGZRzijEsYLjZ1eI8Hwn2FIkyTSiSOdoL1N0OW1hStnZdvqNTpTylayNuaF82Xo=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by MWHPR11MB1821.namprd11.prod.outlook.com (2603:10b6:300:10f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Thu, 25 Mar
 2021 06:12:38 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::75b0:a8e9:60cb:7a29]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::75b0:a8e9:60cb:7a29%9]) with mapi id 15.20.3977.026; Thu, 25 Mar 2021
 06:12:38 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Auger Eric <eric.auger@redhat.com>, Christoph Hellwig <hch@lst.de>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Will Deacon <will@kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Li Yang <leoyang.li@nxp.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "freedreno@lists.freedesktop.org" <freedreno@lists.freedesktop.org>,
        "David Woodhouse" <dwmw2@infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: RE: [PATCH 15/17] iommu: remove DOMAIN_ATTR_NESTING
Thread-Topic: [PATCH 15/17] iommu: remove DOMAIN_ATTR_NESTING
Thread-Index: AQHXDnfEED2hcP0W6EKGzzYVGS5lRKqDYTAAgABXjYCAAQqdAIAPmsSQ
Date:   Thu, 25 Mar 2021 06:12:37 +0000
Message-ID: <MWHPR11MB188688125518D050E384658F8C629@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <20210301084257.945454-1-hch@lst.de>
 <20210301084257.945454-16-hch@lst.de>
 <3e8f1078-9222-0017-3fa8-4d884dbc848e@redhat.com>
 <20210314155813.GA788@lst.de>
 <3a1194de-a053-84dd-3d6a-bff8e01ebcd3@redhat.com>
In-Reply-To: <3a1194de-a053-84dd-3d6a-bff8e01ebcd3@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.219]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5bba3d53-44ef-4931-3635-08d8ef54fd63
x-ms-traffictypediagnostic: MWHPR11MB1821:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB18210272479FD443962635D78C629@MWHPR11MB1821.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +7WOZPtG/yQR8z0EWCDGhG3FLjpVszRezZqeIoyHmwTXVB8EKKIM8pC8vs8BMN3ggAyikBpi3SYox6/IfpAH+cwkif4oUUkn1DBY6xAcAI0NHREtLwgd975fw1A9F9GpDUIhjqjAT4/SRtI+vHg+H1XMOWEyKY+eYtKFS2g2oVjOBtMdJ32xAozhwiX7ZU035313cYlhuvgcJveOtp6lY+dEb8HumvABoTCkg6iVpiK/wYxBX8r/m59nyrs588FVKe6tqJjCLJZD/AZtmBB5sNeurforivnWTgdjZaNdpujaTXErgHVoGnWiSetpRBulD+evLSDpmVMjmzjQJtWnKPf8uP6TociDRjVvrstwT6Ub4YoOKhHSj65CmwmYg3+KsTn1iQ0fpWIpd0urOcM4NKIrzlyIWSQSf8brMBvnxG5EsH+D6wmjsFKLU5K9IklL+ilF9EdGmpQSVLIMYcLD63XGm57LxpocZo4AZHkW6e8Z270K6aASjtq0zHmL0KSLLRpV9LSChyLHopYq3N4bMWmrqimNZ9Mz1/0pnVSpPzVyT/T8oCfyB8igocQba2QxX6LmTTWhC5hcht6JYyF+qGIQNJx9QPDc4KHSMPk/vfKDH+JhXzhrQ0AqK33oC9OSOUQmodEiLGloeh6WA9Y/E7ygqxtiJK8ejS3LztKtUTo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(136003)(376002)(39860400002)(366004)(478600001)(2906002)(5660300002)(316002)(33656002)(6506007)(7696005)(4326008)(26005)(71200400001)(9686003)(110136005)(54906003)(7416002)(53546011)(86362001)(64756008)(8676002)(52536014)(66556008)(38100700001)(55016002)(76116006)(66946007)(107886003)(66446008)(8936002)(186003)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?fI3+iw3lagEA6pai5XRwccmrYzfA59IuBxbaVqcy0CGQh3DP3ixrrFMRWiqg?=
 =?us-ascii?Q?lgAWEUb4HS6HTNguCq3d8VHcREDTGIFDBsDuuBXo+SqGAWQWAOV1MyQwQGLu?=
 =?us-ascii?Q?wDJaUGv+L/zsFCUe3F9DwkgZuQH3L+a/YBfmJ/YZlufRKzwYvl5qcqGUMrR0?=
 =?us-ascii?Q?pYThh3dn8EczfENxen8pGKazZADYAYtNrosbTFQXWJQuHFE4tAqOoVe0PuFz?=
 =?us-ascii?Q?Y1QXVsk9Zm1o0ZklYxzwiUH5Y5n7EOWVdztSddWTGcOqoj3nG8QKQvismJWX?=
 =?us-ascii?Q?NnVdZjJ+GhbymuS6u3has78XnNB7QsrFxucPS1NX8fLbmtHCkRjsY7WpSXF+?=
 =?us-ascii?Q?iqH6sPDGPk1I0MlqAAlEDMZKMnLqsWNbJkcV0MwISmd69gk5cbt5KVGEBMna?=
 =?us-ascii?Q?vM5nsx+vo1QmMvJBVZ1n5f5aEWoONBJcmTnJo/kZFq9lAKARsMeW707qz1Qj?=
 =?us-ascii?Q?js8Tg51U5CAtbSq4IKSSkHcame3VEq7iUDIb9U7dvRUqjjGRT9Ef3YEsvP3r?=
 =?us-ascii?Q?s9SVaxsmjgzoFcqB7N5Xw2iCJFlkMCO91UttRzDQRRzcdNHy8AcxobtPUOnR?=
 =?us-ascii?Q?W9+XqtTVp7rHuKfZLGygaq7n1+tICjJ23ouZeBt0lN8JHMLr91mf+oo6SlQf?=
 =?us-ascii?Q?5TqtIFkUwsBPT4kpkIdZ9YRgHCiX5xw/AJTesJW2G0KJmj6EZYYvSjvpMwSG?=
 =?us-ascii?Q?08Q4MZ+vc2esLVB9lKeuHsUWI6EN/dRfgSSD0TBDHu8MoheBesJOeBHRUW96?=
 =?us-ascii?Q?R8XtrcpgHvbLEHQUNLmAAzDqDcARWbDraxrkMzZsjGMeLC1n/SfBft090cEZ?=
 =?us-ascii?Q?PZx8a/WSfNSH9RPv35fmjkXsmlweBbkDSTEEjBN1ih5RkxgHUy7mAIejMzuZ?=
 =?us-ascii?Q?qkoNM8Gtta+xKmT7rAXu0PuwYMfAFFFTZd27jX7Xvqk84bV49xNj3TI1hecZ?=
 =?us-ascii?Q?M57Fc227flJz04oxNesvhNf9v2LCGU7MlVVhOeFMmqFpnuEy3fR/ESNpXRWk?=
 =?us-ascii?Q?w6fAD3jlvnLBz2Jpuv/cPSn1KH/pTgezhWs2kJ7BklTE+4EjPZsUEjpa/arM?=
 =?us-ascii?Q?8CYM5irwQrY7u0lfUOzFKxUmmtljQqrPeuirrI1yj8cMCZ9YinOBxM2Xi5pv?=
 =?us-ascii?Q?M/E1bwwwDBc/SgweDf0DC4ETAXgOKTsYIy+3eHE414gbuyOkitz9embLqgv4?=
 =?us-ascii?Q?bz59GCCIA8MGfPZRpZ2CfTRqKXHRh586iv7T3ALnzB1fDLzF/sucTVegdeWg?=
 =?us-ascii?Q?pms1vTlhTlfiI0xcwZYBq1qGZxgCeu3kPk7jeUCUv3q7D+566p1N3/EZ3aBL?=
 =?us-ascii?Q?5ELP8YpBRmwyBgr10ilTAZmg?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bba3d53-44ef-4931-3635-08d8ef54fd63
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Mar 2021 06:12:37.9104
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g+9tx8yupAxEaBVTaXN+YMN+Gjh+DKeandfmUv2hiw/T4C1FrVED7BMCGrAdhj15oS8+rSSZsVH3NORAabP2Aw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1821
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Auger Eric
> Sent: Monday, March 15, 2021 3:52 PM
> To: Christoph Hellwig <hch@lst.de>
> Cc: kvm@vger.kernel.org; Will Deacon <will@kernel.org>; linuxppc-
> dev@lists.ozlabs.org; dri-devel@lists.freedesktop.org; Li Yang
> <leoyang.li@nxp.com>; iommu@lists.linux-foundation.org;
>=20
> Hi Christoph,
>=20
> On 3/14/21 4:58 PM, Christoph Hellwig wrote:
> > On Sun, Mar 14, 2021 at 11:44:52AM +0100, Auger Eric wrote:
> >> As mentionned by Robin, there are series planning to use
> >> DOMAIN_ATTR_NESTING to get info about the nested caps of the iommu
> (ARM
> >> and Intel):
> >>
> >> [Patch v8 00/10] vfio: expose virtual Shared Virtual Addressing to VMs
> >> patches 1, 2, 3
> >>
> >> Is the plan to introduce a new domain_get_nesting_info ops then?
> >
> > The plan as usual would be to add it the series adding that support.
> > Not sure what the merge plans are - if the series is ready to be
> > merged I could rebase on top of it, otherwise that series will need
> > to add the method.
> OK I think your series may be upstreamed first.
>=20

Agree. The vSVA series is still undergoing a refactor according to Jason's
comment thus won't be ready in short term. It's better to let this one
go in first.

Thanks
Kevin
