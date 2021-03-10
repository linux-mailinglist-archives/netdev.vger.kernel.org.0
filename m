Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFAE03348E3
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 21:27:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231684AbhCJU1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 15:27:07 -0500
Received: from mga14.intel.com ([192.55.52.115]:23234 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229602AbhCJU05 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 15:26:57 -0500
IronPort-SDR: YZHVYEl8uaR+jc7QUDNj816WpW0+5mhkDpxZ4asyXcuiA0v+egUmyKKfdRIPyg/940+vl7aRjV
 Rc16wKZ9ZeAA==
X-IronPort-AV: E=McAfee;i="6000,8403,9919"; a="187921312"
X-IronPort-AV: E=Sophos;i="5.81,238,1610438400"; 
   d="scan'208";a="187921312"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2021 12:26:57 -0800
IronPort-SDR: 26W0HElbVcYwUwI8+X/a5TX8eFc1HQUVZPMs3HmOovGKmmYs0AMEXtNarcUj7j7CvVGjq7bSMo
 fwP17VsQIVJA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,238,1610438400"; 
   d="scan'208";a="599941122"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by fmsmga006.fm.intel.com with ESMTP; 10 Mar 2021 12:26:57 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 10 Mar 2021 12:26:56 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Wed, 10 Mar 2021 12:26:56 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.48) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Wed, 10 Mar 2021 12:26:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L8OL1oIZDYdg0cAvLQZbddpdUGwa1KLnLKMBcCVG1/CCXHhViC2bf5ObQasyg4ZH4orzBnqo4fz0xlAHSKDSV7b/YSWyzDJM5S9+rZyX7/T8v3NGWKsNGCKFS3z1a5JOEj9UaV9t+vBwE8gFskw96Qj8AS8e3ijrSNgySQ9NS7lTYJNOrd0qT48hmAyNSYt+pWTYuCwQZpPxcCx7scg7I2Vz9z9SLXyETFC+MFi15eHquXLY9paSLkJwBXNSbBDWiZVAshgaqKj62trkHsO38O4h0iVDl8YXQsKsm1D91ZqXDS2vCMa70jxkAIILkymLnPxB60i37bPcWlZIz+c7wA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3owPz04Cz9/nwIXQJB+AMnyqeW0V50KrjiiMD991W0Q=;
 b=KwByVakgmMjBdMj+SnsWfnkeMXdCBUzR7iMO6cjcUIGWop9CA07/dN+jcnJ16fhuOCiWwNqW3UPGsO6CNsCT/oWXqpmuduC4Dzq5J4m29HwUChe6yuTuH3E4FdPPhcEV2bWEAlTrwSor3SqjuXnzsxCfY0BDeTr44J4UDXeXu3zNY/S85NnDQ1XixZhY7GJbJKZOGFFTZIrfMmetVysM7uq819ImmxGH7ioRNwU2rQ63vBPZJ0vp1FwSuCyAUF3mvs8u2/T8Omu7YqqmUpUU4wXxPEzKgIxcWqFfVVJ58Bfm38FFMRJ6qXKYFqc+h7I6Qg+AGEyN6MkYFco7/OdwFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3owPz04Cz9/nwIXQJB+AMnyqeW0V50KrjiiMD991W0Q=;
 b=OJWhXWRCLq5iGfErqslxzbFtW29RX8UW/LeZnPfY8ThdW5/GY/u9aIb68+SlHqZ0x4DxTQLLQGOlkJCB/COaNX+2atZ9uIWWxNDtmKEUibmkwA2e2hqc6kbblDCIPv8GbG4x6YZ3tt+9p0hoPOKgDxiV4F8sV2KRCxU9yLmHDgE=
Received: from BYAPR11MB3095.namprd11.prod.outlook.com (2603:10b6:a03:91::26)
 by BYAPR11MB3574.namprd11.prod.outlook.com (2603:10b6:a03:b1::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Wed, 10 Mar
 2021 20:26:52 +0000
Received: from BYAPR11MB3095.namprd11.prod.outlook.com
 ([fe80::e47d:c2cb:fe53:e0e6]) by BYAPR11MB3095.namprd11.prod.outlook.com
 ([fe80::e47d:c2cb:fe53:e0e6%4]) with mapi id 15.20.3890.035; Wed, 10 Mar 2021
 20:26:52 +0000
From:   "Chen, Mike Ximing" <mike.ximing.chen@intel.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "pierre-louis.bossart@linux.intel.com" 
        <pierre-louis.bossart@linux.intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
Subject: RE: [PATCH v10 14/20] dlb: add start domain ioctl
Thread-Topic: [PATCH v10 14/20] dlb: add start domain ioctl
Thread-Index: AQHW/9cf51qMHKbbbEiK3J9lquEWHqp7jbCAgAEXzwCAAGWrAIAAywBA
Date:   Wed, 10 Mar 2021 20:26:52 +0000
Message-ID: <BYAPR11MB30954DC43BD80B7214C15A7BD9919@BYAPR11MB3095.namprd11.prod.outlook.com>
References: <20210210175423.1873-1-mike.ximing.chen@intel.com>
 <20210210175423.1873-15-mike.ximing.chen@intel.com>
 <YEc/8RxroJzrN3xm@kroah.com>
 <BYAPR11MB3095CCF0E4931A4DB75AB3F7D9919@BYAPR11MB3095.namprd11.prod.outlook.com>
 <YEh/8kGCXx6VIweA@kroah.com>
In-Reply-To: <YEh/8kGCXx6VIweA@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-reaction: no-action
dlp-product: dlpe-windows
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=intel.com;
x-originating-ip: [69.141.163.46]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 84db9cc6-0d9f-4e8f-296d-08d8e402d76b
x-ms-traffictypediagnostic: BYAPR11MB3574:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB3574C387F57843A2899A072FD9919@BYAPR11MB3574.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eiu0iopUlG1J569EiF3K0W1gDn1nr5x56kqAERG0xOATshkS903QffauEBWnrOoWSNt7qPhghUI1r/6idJ6x1Y+gYFA1TvTXoakIacGNVd7oQSBiHwfB+Z1sPWNgZUwF1jLT5qYc6cvs7XyaTBfRcZmMub72ShCRxiFMUCQcET/3onDWtNRpq3EbqDhyTrQM7ZFuOJxNMfOGZnL3TmitCazYzG/jkSl//xnmtE+6sM6CmEIILo8NcpLbudIFpcGF0Czit1vJVoHwv4HdyrdIyJIYQqT+MSMzRbQK1AExYJ8+SZrRBXl0c88ZyoLjn4FItD2bi/IEE9BnaXGNM95xf7o2FxHmwWxEdZ7NUqZH52cchMkx2WSihm8JFf3IVn4E7pTs2ceMgf6YosCiJGhuZzrcr9VHEADEtT7gacGJ7/dZh7NvXEIgESDHTWtMJw3Zf7SsKYUOy+5aPSC4RmvfUa9oLG3GqI3ojHVeKpNMFJnAij3klfzRl70IqfSkYFCT8Q19HRsvaeCR4HTDIZh2cw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3095.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(396003)(376002)(136003)(39860400002)(66556008)(33656002)(6506007)(66946007)(55016002)(8676002)(54906003)(76116006)(5660300002)(9686003)(64756008)(186003)(2906002)(6916009)(66446008)(26005)(52536014)(8936002)(4326008)(66476007)(71200400001)(478600001)(86362001)(7696005)(316002)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?bEyJdzRao76nBH3vDuRhyAerlA+/8sDShM2nrJ/YUm/oJI0cbv6HZarSdQ1t?=
 =?us-ascii?Q?JaCR39qgyMgVfqeMye/09u/Cxei2MitaWueDTMDUVkzzdDxQY8US9KVRHvE/?=
 =?us-ascii?Q?eQH5hPicEgzIQ1wPnq9NR1+0/PQTi3Ksjb74COQweo8Mr4nYxvXbU9y7PaPW?=
 =?us-ascii?Q?noJqEeZIwKB6GQofHJjbpqoTvVidurIopOtLwPr2JhL3QvxZ2B8QquuDIla0?=
 =?us-ascii?Q?rK+T4I2PdpU6mEyn1ZPswAw+rzazF3Fm/7Pw64OG+AN1gv5ADm0eg4Vp5act?=
 =?us-ascii?Q?n5arl5sFDJjsdqm46Wb/TQP7JOU5R7DLUZ9JDLnp9yWUDqFDyZLz1npcST6s?=
 =?us-ascii?Q?3QPCFFqznZVvyofNkeg3FTi3OobEeL7xe6Ia/9boSGW6RpYRCw0yQ66z1CNB?=
 =?us-ascii?Q?4UM/qzI1xE1lnKLxHSe2YSjE1R1FBD3psr3lQufHUsXskEeNWwu2L2hOCXy8?=
 =?us-ascii?Q?h9EpGzAmTAwU3KtwOJjFIMbewYfrkZwZZZUlQ8MjvkrCOVAg0qFHtjhYAaaQ?=
 =?us-ascii?Q?7D/0CO4sEjIBl2oWxD++upgCjkZ9qhltxdIjZqaDgGSLdwlgDz8Uy2WoDJlK?=
 =?us-ascii?Q?JYeTf0l7gr9SzgWPqkKBWOjEv/0A3x8tUODkDF+IYcLAHogLObcrUyeC3bLY?=
 =?us-ascii?Q?Pr9Kj/P/rexrlFvJR79fM7EzZ/vZefx2pD/vb1AXKRSNdvzbeviQPqORwBDz?=
 =?us-ascii?Q?WURqwxP9wGoWW9mCOAe8is+7C4Jo5UDFi3hju/DycsGLdTmus58fvmdpsE7g?=
 =?us-ascii?Q?PvRIu+U9mh8l7fy3KCam8wwAbuPygN0wzh/SftLwZ3OPG2DPlgF/zE42txkD?=
 =?us-ascii?Q?iEdAcjPftCwS47NtgUsSyfPmutEYhJF6VA34yxbt23bdpGg42znS30rgfj81?=
 =?us-ascii?Q?fJqXPFNk2Sd7D9Pf4FT5CI2EGq39S1LrHyiFpWC0mTsQvtbiHxZN+LpmI26M?=
 =?us-ascii?Q?ZmnnvZQPboOT2cMSP9ZEMsTO9XYbFIgLg62AsPfVF3EoCxbOW+KkWqY1BQVN?=
 =?us-ascii?Q?EfhaAzKY2Wreqry81zy6ipGz69lAvALgi0mRoD7xdGQD95G2kiwgtuUkjNwZ?=
 =?us-ascii?Q?7FWxEyYNRsWSiGh7tFgpmThmo54w19Eg/GFeY/mMMPMxXP2J//NbVmddbFp7?=
 =?us-ascii?Q?H+xEMmbj/+NAsnUacv2uVoNjic7vm84oB92ZA03wBBxRgpYOiofBvhSVykVA?=
 =?us-ascii?Q?620qqUIuKljg6vLXVhINV3YYU1l0omNj9gdceuIpbtH/xhW+nTrIPRZz3dlS?=
 =?us-ascii?Q?SjrXnaCkNeATxngYUQ5JuXjtLonMEwiteZUsz8JnjcpxEAzxEQw3Umr8B99T?=
 =?us-ascii?Q?AA41yVp2UPvhXCXTrf7dvmy2?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3095.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84db9cc6-0d9f-4e8f-296d-08d8e402d76b
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Mar 2021 20:26:52.6697
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GPwFZ5rxGFKrR+nAwJd0A1KuA9yUd7BYPS3VP+ivRzrRv9ajT4rUQJLnrCYHX9wbef8jstQJZzH6Z/EeWG021r8YTPOfjo4F1t2zsPfV8uA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3574
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: Greg KH <gregkh@linuxfoundation.org>
>=20
> On Wed, Mar 10, 2021 at 02:45:10AM +0000, Chen, Mike Ximing wrote:
> >
> >
> > > -----Original Message-----
> > > From: Greg KH <gregkh@linuxfoundation.org>
> > > On Wed, Feb 10, 2021 at 11:54:17AM -0600, Mike Ximing Chen wrote:
> > > >
> > > >  {
> > > > @@ -232,6 +240,7 @@ struct dlb_device_ops dlb_pf_ops =3D {
> > > >  	.create_dir_queue =3D dlb_pf_create_dir_queue,
> > > >  	.create_ldb_port =3D dlb_pf_create_ldb_port,
> > > >  	.create_dir_port =3D dlb_pf_create_dir_port,
> > > > +	.start_domain =3D dlb_pf_start_domain,
> > >
> > > Why do you have a "callback" when you only ever call one function?  W=
hy
> > > is that needed at all?
> > >
> > In our next submission, we are going to add virtual function (VF) suppo=
rt. The
> > callbacks for VFs are different from those for PF which is what we supp=
ort in this
> > submission. We can defer the introduction of  the callback structure to=
 when we
> > add the VF support. But since we have many callback functions, that app=
roach
> > will generate many changes in then "existing" code. We thought that put=
ting
> > the callback structure in place now would make the job of adding VF sup=
port easier.
> > Is it OK?
>=20
> No, do not add additional complexity when it is not needed.  It causes
> much more review work and I and no one else have any idea that
> "something might be coming in the future", so please do not make our
> lives harder.
>=20
> Make it simple, and work, now.  You can always add additional changes
> later, if it is ever needed.
>=20

Sure. We will remove the callback structure from this patch set.

Thanks for reviewing

Mike
