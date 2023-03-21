Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB65A6C3437
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 15:29:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230476AbjCUO3B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 10:29:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230047AbjCUO24 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 10:28:56 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A0F640C6;
        Tue, 21 Mar 2023 07:28:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679408899; x=1710944899;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=n0c1S+0bDjeO9WUJ3gjWBbNos2rb2UaxqoUveF+REGE=;
  b=YUN+MXVv/mybtErW769/pbM5zeTujdu8V1YxGVsh9haG4eMEDgs4pKI0
   FaLVPMe1pkJ5PA6G6zLdpZK+bMYkigD1Bo/6g2BKwr7qYysitQxO+0dtc
   7thKWiX/efGRboroDgSJJknH2QybLDy6uaBNXbq2BISZ235IVcl+nFKJs
   XSa7m567h2rMEmUQDn3bHaZ2vqSYLVcwuwOy04YdOXhPWTuPrBmuJzT+F
   orLvV76Inc93zB1dzM4l2nUQSKYtM4GAYoHvLvkgdlNlpG6Rr3ndLK34o
   9Kkr3BOeDhu8du4tS1v9QigV6PSSviRHoqZXwx2MVC+rAxcNjWYVmWTRh
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="322794534"
X-IronPort-AV: E=Sophos;i="5.98,279,1673942400"; 
   d="scan'208";a="322794534"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2023 07:28:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="711813928"
X-IronPort-AV: E=Sophos;i="5.98,279,1673942400"; 
   d="scan'208";a="711813928"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga008.jf.intel.com with ESMTP; 21 Mar 2023 07:28:18 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 21 Mar 2023 07:28:18 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 21 Mar 2023 07:28:17 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 21 Mar 2023 07:28:17 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 21 Mar 2023 07:28:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DFovqbIQJInTeaRO29H2N8gSXld+oOsINZcO5mIxCjqmFKxOUCc4NV/nG9kCUyACMXWxLMPHEmlOhVf1ZuJuQeCshWTiPYCJwZBkKRTNT7RbMfO1gQzlhAVB5BR8B07y2FKkLGGZXtR6IzfJYBK62yqVHU8NQrINL+93N1d1HBcNjwnl+dspwCEROeSnjOQau196S3cQIPTxPxRuDfsSMt21Fi1mgsGSduKmRKkSXfWp1nuGkNYx/NHYZ5Qa4k+9URvDP5UZVDq899y8Sxa3icmimCglpCA1cJXAl48ngRC3Ddx/RkaP0Rxf2jqIQf9stavqZZKb+SHN0J8C5BMrpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vTEZqkaJASVF9by39M5SuQ93vniuURmb6h5hmQpIzB4=;
 b=ZzRpXgyoKi239zxxXAhCjsHosua9Y9vyy7Y+YvAt4o0wNPtcNZBowCRA9qdY3CT7CeyxbQzIoP1rjBCThO1UPEFmvVHUo4ctTJAppvxv+yGxBg0Y0qqEv09TTCmAuZYSTJJw3PXgAzQbgXR0HMMKMPnW6cbJo33UKr0Nmnj9mToE5imZzUAYW3SVTcBzXvUh5MZY3AKHXSYP0kPYGdaEMC8PjzcYjcZRy4XDEBQcABYFn9oUjf/T3jv6ggkh3VvhKvEr1xX3QJREpCpwLili5OHOyMlYpLf701XfgG9Q0aNuNnTV2Sh9ZcWySt6ggVluxUziCRQbfsScXH5IL4Nnow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5483.namprd11.prod.outlook.com (2603:10b6:408:104::10)
 by SA2PR11MB5003.namprd11.prod.outlook.com (2603:10b6:806:11e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Tue, 21 Mar
 2023 14:28:15 +0000
Received: from BN9PR11MB5483.namprd11.prod.outlook.com
 ([fe80::af70:de56:4a6f:b2cc]) by BN9PR11MB5483.namprd11.prod.outlook.com
 ([fe80::af70:de56:4a6f:b2cc%7]) with mapi id 15.20.6178.037; Tue, 21 Mar 2023
 14:28:15 +0000
From:   "Zhang, Tianfei" <tianfei.zhang@intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Nicolas Pitre <nico@fluxnic.net>
CC:     Richard Cochran <richardcochran@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-fpga@vger.kernel.org" <linux-fpga@vger.kernel.org>,
        "ilpo.jarvinen@linux.intel.com" <ilpo.jarvinen@linux.intel.com>,
        "Weight, Russell H" <russell.h.weight@intel.com>,
        "matthew.gerlach@linux.intel.com" <matthew.gerlach@linux.intel.com>,
        "pierre-louis.bossart@linux.intel.com" 
        <pierre-louis.bossart@linux.intel.com>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "Khadatare, RaghavendraX Anand" 
        <raghavendrax.anand.khadatare@intel.com>
Subject: RE: [PATCH v1] ptp: add ToD device driver for Intel FPGA cards
Thread-Topic: [PATCH v1] ptp: add ToD device driver for Intel FPGA cards
Thread-Index: AQHZVVb9Plq7k2o7S0K9BdoAv1tvk675DoOAgAELboCAAJbOAIABMVyAgAAKrwCAB8YEAIAABm0AgABj+4CAABQNgIABDuWAgAAWIRA=
Date:   Tue, 21 Mar 2023 14:28:15 +0000
Message-ID: <BN9PR11MB548394F8DCE5AEC4DA553EB6E3819@BN9PR11MB5483.namprd11.prod.outlook.com>
References: <20230313030239.886816-1-tianfei.zhang@intel.com>
 <ZA9wUe33pMkhMu0e@hoboy.vegasvil.org> <ZBBQpwGhXK/YYGCB@smile.fi.intel.com>
 <ZBDPKA7968sWd0+P@hoboy.vegasvil.org> <ZBHPTz8yH57N1g8J@smile.fi.intel.com>
 <73rqs90r-nn9o-s981-9557-q70no2435176@syhkavp.arg>
 <ZBhdnl1OAPcrLdHD@smile.fi.intel.com>
 <4752oq01-879s-0p0p-s8qq-sn48q27sp1r7@syhkavp.arg>
 <ZBi24erCdWSy1Rtz@hoboy.vegasvil.org>
 <40o4o5s6-5oo6-nn03-r257-24po258nq0nq@syhkavp.arg>
 <ZBmq8cW36e8pRZ+s@smile.fi.intel.com>
In-Reply-To: <ZBmq8cW36e8pRZ+s@smile.fi.intel.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5483:EE_|SA2PR11MB5003:EE_
x-ms-office365-filtering-correlation-id: 0fa99d38-2606-42a6-e020-08db2a18825b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Pxoio5Iq+YK2XwMl/UfLcAWieh8KX4ggLRJJKS5sq5e9STkUt+UKoCkjbr9de2vTTLjWfuY4OZLPulW4RQwjtEg5TyawUStXWy6RzFALcjh3qeUFK8VZ0AF3FqNcfCxtTneh8v69gYjWsWB5bGQ+c8SyBrR6BhUZkvvvzxsGinq3itsdymRo9vMaRjD+P55SZd9RFfe12IcD5Fz3iKTABl4cuweEy0cFJhj8Y5DQ/MjC3xWUTy+E+dzttM9NnnGA5Vd+miev/OGAIuAle+Mge4sqqvmtvxAqHqG+27uXW8M3K7YU2KsF/BHsgo8sL4ivQFX+WiEYKIhIxAH2HClDWxzkzHRH8R17LROD3vlXtgSMFNfujiiAvhkbdOULK1ReB8QJyAR//RiIml9gIFxLDkccblxx2sY7qyB6eIJuw8xvG9MJeXpYoDNB2quiDJStlDFwfpc76rHVee5gX1gyrwhKyesgYYowwVpRS0+y40ni7RZXqs+E8cJGgIlm2xyE33hNNKvZ6HrYEUIGVpIefiOZre3eltsbMdIxbVW3VknQL4Qbib/sdklQQESjjAxbvf8wQUeRYm2/4SklrVs9n3AsEjn9wL1Xpppa3pnP86/aurQTWqKkK3TRrG+p7NThngT5bMsUAqwNNQ+Sa0KEVObSO6DiLQGsXLoIwrznDlFt+Ueq555KXLYcYt2NgWvV5Tls1ducRg2jeFQAI+fueg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5483.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(376002)(396003)(346002)(39860400002)(366004)(451199018)(82960400001)(9686003)(53546011)(38070700005)(6506007)(186003)(71200400001)(110136005)(55016003)(7696005)(38100700002)(52536014)(478600001)(2906002)(83380400001)(86362001)(122000001)(33656002)(66946007)(316002)(54906003)(8676002)(4326008)(64756008)(8936002)(41300700001)(66446008)(5660300002)(76116006)(66476007)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jnLlQ7qlz63SMjdcuNkIzMigW0bIv8LoZ/JukOFdP8zrTY/WQs0ISy9ou9T4?=
 =?us-ascii?Q?ZZtKh7r5XsXce1dJR6YJsDseI1gJOL4b8t32z0N10IZqx/TZkv7liSAurF0v?=
 =?us-ascii?Q?ie767It5E0N2MLvw82DQUhf+M5OprV02LSWoYZNvSI0GU/Gcr1GbZpGb4twb?=
 =?us-ascii?Q?/1thKrSmQmZQt7YmvF5rXeGO2X8ThXB49w+eUE9PEXt2nXfC/lljognCDbvv?=
 =?us-ascii?Q?lvZr4fqD8JHcuYKun5cCsEk3yylT4F4BIvNZ/EHG1Rsp2J01dn0kLeV/HHj+?=
 =?us-ascii?Q?S6/3s6aEmXnjKRJgAG5FmHks8D30HopJcImbS/wbUz5J6KkhvjnfK5aeBVp6?=
 =?us-ascii?Q?w4uTcMPPjYixZC0nDsZv5AvPk1yYKym92baib15ZuxrH3y/QWgNkqozzZPFG?=
 =?us-ascii?Q?3MafSuk8qehhu+Xn/oL7p/ZycEvtHc7ObdtCX8AkAIeu4+U2vh3BRiaSt/Wz?=
 =?us-ascii?Q?dqD7hyc9JYxof8UKRGXikWK+Br7Wj+dmXhs4yHjYRiHTSqV39pUWtpeiodz8?=
 =?us-ascii?Q?p8EgUofbi9tXkAtmmtiwX0MKdAxfLvrJ/JSYNYem2YUnXQ5srfhKX57JOEkF?=
 =?us-ascii?Q?Ue3CzCLeU29cRySG8gn4oh9uf+m52p0vKURZJ4fVLljnoBPPDUpwWsEKtczt?=
 =?us-ascii?Q?D5Q3TYbdWJh/Cq0jYWml//4gg78+h+RRCQlvc+vdo90Onbxhb+6exBKb3G9s?=
 =?us-ascii?Q?tsGCSj7d07jOntQJoisY6rJ4VE41cWL5Y3ze/WBMIlidxgWCsPG0mZsJYjE7?=
 =?us-ascii?Q?2ZmLRk65DdrVhg8vnto7ViJ/l4UOIIvIztpmhNTZ5n+O4gqQq6HVGjCXeKt6?=
 =?us-ascii?Q?pr0BGiXg+svLWPA6mNZ77rdQ979gAiyYdkVwee5ZMgEX/mEFigylYc2fnvgN?=
 =?us-ascii?Q?gd2jSqNZ0jRyniA/5oUWHIqs939pzBXRsQFnPPLY+o2OvqeNZJI4DmIXIXtE?=
 =?us-ascii?Q?6ldsSLB2zD3FMsAaQs/zM6rtL+AB8XAxlIxXUsZGncnPMVV84TDlG+DmU7+y?=
 =?us-ascii?Q?SJNywpcC0pzgQlXgSQCval4rDHy+n9rF8jgCS13xbd3p8RVYH2hz+zP7le08?=
 =?us-ascii?Q?l2gMbNMlAxxzDbIooS5R3VqKBK7QOigsAR/X0YnX6xCXNOtUoFAvu4ZaIFy2?=
 =?us-ascii?Q?c4FXSAOqEaQJCf12ptZG6zgPdV5HBWOan2qqLct1NIb8pwgg8y+iW63zOGuN?=
 =?us-ascii?Q?c7hXft7OtZhhynhV5KzoxKAdM2YXQEoSYt3h0OPqATWbvhpLK4tDeoBI/hM+?=
 =?us-ascii?Q?w2JcJ2rCQqXB7P0qMlJCbsUCqVbheojGr3LdjOFimoNSGNp0t3tS6758HGmC?=
 =?us-ascii?Q?+d0l8osQR/SwKtyZKOUZ32uGGHOzodlMuZoycR8Vf5e1sat6uFGDmMY2RWCB?=
 =?us-ascii?Q?6Ol54TWsauFQQXrfXyjwOnjE81ehH6GT8F7hZI60nwx5tqZZl7ur7mpSwGSI?=
 =?us-ascii?Q?6BISRSAIYmf022IqSIyiOCRmsCyCxI1HgHkcB9Vr3AyVIn5WHc+r0MtofEet?=
 =?us-ascii?Q?Rqpoy1UxGZiI7cySLdHFqLDglPipijzvVEhHAvZNnXStLGvEaH09NdxAQbmh?=
 =?us-ascii?Q?gFS4V+nKqLkE3nJCWp3GZ+n5YUKNGYAow904j76ioJfSrYxEmRdgsKKZeWHr?=
 =?us-ascii?Q?LXAicEgX+qfNz54Gfya6OIfZGgGAuHuJ6tUUkM11a8z4?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5483.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fa99d38-2606-42a6-e020-08db2a18825b
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Mar 2023 14:28:15.7542
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6R3WqSHktrn33Z4VeSdwrB1e5FgbAOrSuI0pABMo6Q6JP5zOUP39xHAr/goXbSGsF6tbdTNpzLoMq3TxHFelqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5003
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Sent: Tuesday, March 21, 2023 9:03 PM
> To: Nicolas Pitre <nico@fluxnic.net>
> Cc: Richard Cochran <richardcochran@gmail.com>; Zhang, Tianfei
> <tianfei.zhang@intel.com>; netdev@vger.kernel.org; linux-fpga@vger.kernel=
.org;
> ilpo.jarvinen@linux.intel.com; Weight, Russell H <russell.h.weight@intel.=
com>;
> matthew.gerlach@linux.intel.com; pierre-louis.bossart@linux.intel.com; Go=
mes,
> Vinicius <vinicius.gomes@intel.com>; Khadatare, RaghavendraX Anand
> <raghavendrax.anand.khadatare@intel.com>
> Subject: Re: [PATCH v1] ptp: add ToD device driver for Intel FPGA cards
>=20
> On Mon, Mar 20, 2023 at 04:53:07PM -0400, Nicolas Pitre wrote:
> > On Mon, 20 Mar 2023, Richard Cochran wrote:
> >
> > > On Mon, Mar 20, 2023 at 09:43:30AM -0400, Nicolas Pitre wrote:
> > >
> > > > Alternatively the above commit can be reverted if no one else
> > > > cares. I personally gave up on the idea of a slimmed down Linux
> > > > kernel a while ago.
> > >
> > > Does this mean I can restore the posix clocks back into the core
> > > unconditionally?
> >
> > This only means _I_ no longer care. I'm not speaking for others (e.g.
> > OpenWRT or the like) who might still rely on splitting it out.
> > Maybe Andy wants to "fix" it?
>=20
> I would be a good choice, if I have an access to the hardware at hand to =
test.
> That said, I think Richard himself can try to finish that feature (option=
al PTP) and on
> my side I can help with reviewing the code (just Cc me when needed).
>=20

Hi Richard, Andy,

Handle NULL as a valid parameter (object) to their respective APIs looks a =
good idea, but this will be a big change and need fully test for all device=
s,
we can add it on the TODO list. So for this patch, are you agree we continu=
e use the existing ptp_clock_register() API, for example, change my driver =
like below:

      dt->ptp_clock =3D ptp_clock_register(&dt->ptp_clock_ops, dev);
        if (IS_ERR_OR_NULL(dt->ptp_clock))
                return dev_err_probe(dt->dev, IS_ERR_OR_NULL(dt->ptp_clock)=
,
                                     "Unable to register PTP clock\n");

