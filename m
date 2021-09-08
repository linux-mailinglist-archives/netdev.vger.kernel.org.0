Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA436403E5E
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 19:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352480AbhIHRcA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 13:32:00 -0400
Received: from mga01.intel.com ([192.55.52.88]:37419 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350241AbhIHRcA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Sep 2021 13:32:00 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10101"; a="242849696"
X-IronPort-AV: E=Sophos;i="5.85,278,1624345200"; 
   d="scan'208";a="242849696"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2021 10:30:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,278,1624345200"; 
   d="scan'208";a="465752682"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga007.fm.intel.com with ESMTP; 08 Sep 2021 10:30:48 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 8 Sep 2021 10:30:44 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 8 Sep 2021 10:30:43 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Wed, 8 Sep 2021 10:30:43 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.172)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Wed, 8 Sep 2021 10:30:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QNp0iNmrBQ81O25eZGY4PFw/nrXqJYCYIBQQWEVHc5D88rdw92PUlF+A5LO712y0hMgc4q4lMwKsjhxjObnfWIJSyivspH9bcFxecepaIeKeXBM1ML949rOtW8b1VU8MCswuisx6DtUtE7XVvgHzRWjh2ASLQBjxuhHrzp+i9Sa/3n/dXY/P3YBlkJmofvwPNHXWRfHIip8xnKsP1Pas725RRal89Fkn2JiahuPYo17w6/9/oaUYjXO1H3azwUlRjO3P7JKF96PH4L/6Llkcz5uwIx6ecNpKRMemzUCaTYQUJjLDfjQZXzlmRYbufPX98n5e40rx484Q4JqQpcKkwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=eWbRq4lJ+e+P+M7k/mFzxWo6PXhnAoInnWzIQrMOe6A=;
 b=HEtUblPgVdQZx1w2mysvpzm873quRW1iscLAwZnJDs0/meHvrjpO1gsVRc4nw6Oko9rDKD1io1ntndESNkWUg/UddLjZv9YFA+49YRi93JwwPZmgezKk9QsRGcDoibv2n8yrAUtGkHDp/myN1fT2EKK/Sb+4K+vhlYciculfNzySbFq8Vks2V63P7F1gJem+Lj/ZM/fKXrOaHTJ5UVxhARyxgylikGEgeq8tS60bsHG1EjwgrhXgXb6EAJuwtsm0VpThv6JmYyBBcsnHC48NEiw229/6tNdKGqJHJ+HwsmKcJOmL/GQab6ftSkISELyqDpsP0KD4mHSV4RDHiZydyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eWbRq4lJ+e+P+M7k/mFzxWo6PXhnAoInnWzIQrMOe6A=;
 b=Cb43xZtnb8QmCMI+zuJJTzYRvZDxKwQHTXemCdnhOckl5k2feNE6vEMAGapJmWRsDuE/acM+wPd6MyD+/uOKZ8RrCerEeUXDLFvmZ2Xwrv+yjsC/Uh/m9W6QuUQZHBtC2oHLc5FCLy08wxzfQrZt+zW2nbaqbPTAI2TamPh6mtQ=
Received: from SJ0PR11MB4975.namprd11.prod.outlook.com (2603:10b6:a03:2d0::23)
 by SJ0PR11MB5104.namprd11.prod.outlook.com (2603:10b6:a03:2db::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Wed, 8 Sep
 2021 17:30:41 +0000
Received: from SJ0PR11MB4975.namprd11.prod.outlook.com
 ([fe80::21cb:c69a:c3ac:273e]) by SJ0PR11MB4975.namprd11.prod.outlook.com
 ([fe80::21cb:c69a:c3ac:273e%3]) with mapi id 15.20.4436.024; Wed, 8 Sep 2021
 17:30:41 +0000
From:   "Ertman, David M" <david.m.ertman@intel.com>
To:     Leon Romanovsky <leon@kernel.org>,
        Yongxin Liu <yongxin.liu@windriver.com>
CC:     "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: RE: [PATCH net] ice: check whether AUX devices/drivers are supported
 in ice_rebuild
Thread-Topic: [PATCH net] ice: check whether AUX devices/drivers are supported
 in ice_rebuild
Thread-Index: AQHXoGNHpbh0/1u4tkqJ3u1jLU2pq6uVDRoAgAVUI9A=
Date:   Wed, 8 Sep 2021 17:30:41 +0000
Message-ID: <SJ0PR11MB49752B60CA91811492A9341EDDD49@SJ0PR11MB4975.namprd11.prod.outlook.com>
References: <20210903012500.39407-1-yongxin.liu@windriver.com>
 <YTRweH4JMbzUtxLf@unreal>
In-Reply-To: <YTRweH4JMbzUtxLf@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.200.16
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e00bcefb-fe44-4f2f-5c0d-08d972ee6169
x-ms-traffictypediagnostic: SJ0PR11MB5104:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR11MB51043D45C1BE46F1D4734E49DDD49@SJ0PR11MB5104.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uXdei2SWBaqEh4K9vQTO5FAr/hizD36+4puNgvyspzXyNiQXezXKx8hMBmQkoi1e+kumtP578EPOoIKBt5kdeq5PapPF/gxxhv7ZvwBQWrilqU/hhjfzQOOCPePzENbPtL+ImuDJZy+Gz8HPdIjcEqybgFNnxIbGq3CKY2eq9Qud8RVetozK68MfgGY2Jxyr4kWal2FAsrpWm5OEqSzc1lcDKhpp1frOgheA8+nIvYpOgPFuJDFr/dmfjmnFsJKlQQ3wPNzAOZPJlwBIuHQirtLgLtlUGjsQuKbo5M6i6Xc7HFWUxc2b33/Y4JRBB5LKbAZ3esqD9ojohTrUr7y31r+3PuaLNy/lmy2SPpzN+AcxCDQYnssI2sRIMXo+bK7X1kvM2ANqQ/goQya6YNUuTdB/+ueGe7fYBNAi0//SF5x8I4K9I7PIfrJk7bpb3bfGGSCeuuyNh/3j5aAegPqOrJq78OkDhiBj35bX3ysT/fuj2o1YhtA6FDc+1TEfYZBOA7N782Ag8t1s1HUQrQJK81EwbbLg92SLvzZPmIOJ3NedC6nztrBphUMSnv0PpNTCiIVCG8SNHcufnrIAvhF0B6KHfYKFCsU/cfrDVQA6vJBXNiPKFQ1MmZbuJnaQ9viz2Yk2kYnoNI+ErFr3zE1SI3bpj3oO1n57qcL5l/Dl3NlLCcQLKoq+jtMc56jMo4IyID3INMZZxuRzsRUxnoz2CQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB4975.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(7696005)(83380400001)(53546011)(6506007)(110136005)(316002)(54906003)(33656002)(5660300002)(2906002)(52536014)(55016002)(9686003)(66476007)(66446008)(64756008)(66556008)(508600001)(66946007)(76116006)(186003)(4326008)(26005)(8676002)(122000001)(86362001)(38070700005)(38100700002)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?J0r5M9306zLaqdnNbM0XrsKCmnIogueuCkDXHcGZeTQqaFOhXHO2pm6428sY?=
 =?us-ascii?Q?vFwsYWD5SC1LccifHn9BsQVljfFf8qNx3mspWvJh0UQ/sz8T2Q/VPbJt1vH2?=
 =?us-ascii?Q?G7Frndth58K3vZosVhhMxgKNooRP5UYlIyqgAnzsS880+cK44t5TxZYMchu5?=
 =?us-ascii?Q?tIHUNs2d0Bb4xOJtTz0HBo7LbXTAqM68bD4sHJDmI+8dIqoO8PX8lvV5g9+W?=
 =?us-ascii?Q?7ixUNcg+ijCdJYrl+/8E555uGhkkicZ2Nrf46Sq63AL8G7soJPEANFrEBkwZ?=
 =?us-ascii?Q?UDQ36p1ZpjwC1PxZcrd7mZPWmA3G8n4cK5D+qoPsMfSOcgjcVZcnEcat6toK?=
 =?us-ascii?Q?TWbaVcaPbprYD8sANVmrYSnjPO17FLM0jkiuVkj+nVzPmmbvQa2t+WKL4ywS?=
 =?us-ascii?Q?nQWdd33h7hVMkRunerpMvNlSogwVvgNEY+otUNE1tOG26bsizIl04Qga+/sj?=
 =?us-ascii?Q?yc0rczCvZVvNmGN3hnu4JqvYiaXIYw9xzhT8j/EgJMmueCmPa79zJPHSXxFR?=
 =?us-ascii?Q?AMK4SovO5Zqw1/yXUXo9YawwQXAwkJzxeZ6vmhQi5f8IPeNpGfNDlmyKORMv?=
 =?us-ascii?Q?R1SpuMLwJDewWYIqNKzTLiJ8vEWzH28PmTsUCbVhd882e5wkwACG7vnKufV4?=
 =?us-ascii?Q?PFBiqxHAIRQktEBxgzeOIJTwmTPeytj2StlYbqjilBo6l+ky+1TQufb3TCRL?=
 =?us-ascii?Q?uMacaugHmc6jG2kwl7G9YU9jtOhQxpZi0JlFloK6+gN52zCpot0PMIBunclw?=
 =?us-ascii?Q?0nSsXgsXP6D3m0wvS399+l+8sZp8GtGUXGh6ujqg/MBunRJpB6XxYIde3UFK?=
 =?us-ascii?Q?AQ8s0WGBy7vO01fPK7jvJjmo0FrM04e4ovApS1aXeh44wZdQOAU3y5Wm5HLM?=
 =?us-ascii?Q?X8th10WpD3KbAKHPORvZ8FzERQPfyfuRJrh6de9q5pWzaXuQDCB1pt5d1b8b?=
 =?us-ascii?Q?VmDgnRELaUBu1yO/CtwSAj3tZ1ErDzbLILy3zMtL4QK22FQ+xuwK9MrmU/ZA?=
 =?us-ascii?Q?2zrFXq905uxxsFgjy0a1L5Ot+LCXDJdsp+h9rcGNLqrCh8WwGxEm0SEuXEpl?=
 =?us-ascii?Q?01/VCrTUMKd8TcGkgyzR6QTNLMtXssGBHtMbS/rrlHU9edLhNemyIziEJaY9?=
 =?us-ascii?Q?E+D0pKsINxFvb6u2vFqCUmWzS7oFR531eeKQBBQDQ0UTEyklDSM+GeuDUNjm?=
 =?us-ascii?Q?wGe1D1TuvDoXn+hNZtKNLZ6nAw/U52LrY0uoU39eM9EOJY7eKdnqvwwR07jo?=
 =?us-ascii?Q?8IozGh4S3WXa2QppmjJDFe/tYI0g3xJmXECkceFPMrz5W7EdQkJXj6VFMnPo?=
 =?us-ascii?Q?mMg=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB4975.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e00bcefb-fe44-4f2f-5c0d-08d972ee6169
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Sep 2021 17:30:41.0439
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VwfcKm9AIM+x3EEzIjTTkop4bJW/Fl/Fe4w5VRemLXYDK280dbmPoZsG2tNzlY4OxBIIrbodr53UB0NnNRtSywefF96Vw199Y+Y/cu1thSE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5104
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Leon Romanovsky <leon@kernel.org>
> Sent: Sunday, September 5, 2021 12:24 AM
> To: Yongxin Liu <yongxin.liu@windriver.com>
> Cc: Ertman, David M <david.m.ertman@intel.com>; Saleem, Shiraz
> <shiraz.saleem@intel.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; davem@davemloft.net; Brandeburg, Jesse
> <jesse.brandeburg@intel.com>; intel-wired-lan@lists.osuosl.org;
> kuba@kernel.org
> Subject: Re: [PATCH net] ice: check whether AUX devices/drivers are
> supported in ice_rebuild
>=20
> On Fri, Sep 03, 2021 at 09:25:00AM +0800, Yongxin Liu wrote:
> > In ice_rebuild(), check whether AUX devices/drivers are supported or no=
t
> > before calling ice_plug_aux_dev().
> >
> > Fix the following call trace, if RDMA functionality is not available.
> >
> >   auxiliary ice.roce.0: adding auxiliary device failed!: -17
> >   sysfs: cannot create duplicate filename '/bus/auxiliary/devices/ice.r=
oce.0'
> >   Workqueue: ice ice_service_task [ice]
> >   Call Trace:
> >    dump_stack_lvl+0x38/0x49
> >    dump_stack+0x10/0x12
> >    sysfs_warn_dup+0x5b/0x70
> >    sysfs_do_create_link_sd.isra.2+0xc8/0xd0
> >    sysfs_create_link+0x25/0x40
> >    bus_add_device+0x6d/0x110
> >    device_add+0x49d/0x940
> >    ? _printk+0x52/0x6e
> >    ? _printk+0x52/0x6e
> >    __auxiliary_device_add+0x60/0xc0
> >    ice_plug_aux_dev+0xd3/0xf0 [ice]
> >    ice_rebuild+0x27d/0x510 [ice]
> >    ice_do_reset+0x51/0xe0 [ice]
> >    ice_service_task+0x108/0xe70 [ice]
> >    ? __switch_to+0x13b/0x510
> >    process_one_work+0x1de/0x420
> >    ? apply_wqattrs_cleanup+0xc0/0xc0
> >    worker_thread+0x34/0x400
> >    ? apply_wqattrs_cleanup+0xc0/0xc0
> >    kthread+0x14d/0x180
> >    ? set_kthread_struct+0x40/0x40
> >    ret_from_fork+0x1f/0x30
> >
> > Fixes: f9f5301e7e2d ("ice: Register auxiliary device to provide RDMA")
> > Signed-off-by: Yongxin Liu <yongxin.liu@windriver.com>
> > ---
> >  drivers/net/ethernet/intel/ice/ice_main.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/ethernet/intel/ice/ice_main.c
> b/drivers/net/ethernet/intel/ice/ice_main.c
> > index 0d6c143f6653..98cc708e9517 100644
> > --- a/drivers/net/ethernet/intel/ice/ice_main.c
> > +++ b/drivers/net/ethernet/intel/ice/ice_main.c
> > @@ -6466,7 +6466,9 @@ static void ice_rebuild(struct ice_pf *pf, enum
> ice_reset_req reset_type)
> >  	/* if we get here, reset flow is successful */
> >  	clear_bit(ICE_RESET_FAILED, pf->state);
> >
> > -	ice_plug_aux_dev(pf);
> > +	if (ice_is_aux_ena(pf))
> > +		ice_plug_aux_dev(pf);
> > +
>=20
> The change is ok, but it hints that auxiliary bus is used horribly wrong
> in this driver. In proper implementation, which should rely on driver/cor=
e,
> every subdriver like ice.eth, ice.roce e.t.c is supposed to be retriggere=
d
> by the code and shouldn't  ave "if (ice_is_aux_ena(pf))" checks.
>=20
> Thanks

Hi Leon and Liu -

First of all, thanks Liu for tracking this down - it is an issue that needs=
 to be fixed.  The ice_is_aux_ena() functions only
purpose is to determine if this PF supports RDMA functionality.  In probe()=
, the aux devices are not even initialized if
this test returns false.  If this check fixed the issue for you, the PF you=
 are on does not currently support RDMA.
The bit this test is based on is only set one place in the driver currently=
 - at probe time when we are checking the
capabilities (common_caps) of the device.

That being said, the call to check this should be in ice_plug_aux_dev funct=
ion itself.  That way it is taken into account for all
attempts to create the auxiliary device.  There is another consideration ab=
out disabling RDMA that needs to also needs to be
taken into account to avoid a similar situation.

If it is acceptable, I will create a new patch today and get it out either =
this afternoon or tomorrow.

Thanks,
Dave E

>=20
> >  	return;
> >
> >  err_vsi_rebuild:
> > --
> > 2.14.5
> >
