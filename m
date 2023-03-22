Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 688D76C4EBA
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 15:59:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbjCVO7g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 10:59:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbjCVO70 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 10:59:26 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9889171F;
        Wed, 22 Mar 2023 07:59:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679497165; x=1711033165;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9doD1iNQmeBfBqD6fRh4oGxfB6H36fkuNEOmwqoDxWA=;
  b=OZRZsPc+Ghy8RrZ2mBfXOK/eBeOQ02TyfltiU2tozOj71frJxWvvRxUs
   cPge3raX1R89wPDhrfQ+reNZKgbrJxTAb+AXdEW2d2Mjj8vOcAv+PmHB2
   2Cd/yGixRU5bRLv3BYF2Ss6VjnAmCtQ772SwizHHF+72cKERuP6EM/Bl9
   B3AXgITQZIGqi2Sy3WFBmgv4ktfbo48eFmJbNo2eEvRkDzivUUGVWgkbt
   iHt++jjNF+kNBAiuuQEI/b/kXjX4lOWGSK6etxzFukpuBFuQeGP7QB7sK
   W4B3nCTUxupYTlH5UG50l6NDTpkF16WYxtHZ2EHVA1Gn5Eq209yo7cq+l
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="336738197"
X-IronPort-AV: E=Sophos;i="5.98,282,1673942400"; 
   d="scan'208";a="336738197"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2023 07:59:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="751072567"
X-IronPort-AV: E=Sophos;i="5.98,282,1673942400"; 
   d="scan'208";a="751072567"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga004.fm.intel.com with ESMTP; 22 Mar 2023 07:59:25 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 22 Mar 2023 07:59:24 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 22 Mar 2023 07:59:24 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.48) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 22 Mar 2023 07:59:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K+TvZ6Hprw88CracB+L0yjE1lSrPjb+KG01jkVOOWxhXU2vp1u2Us3Ueo+75FOKGN8VJIsKBFpZ5VY+oVmKpSNw+/rx82zGAtBnMJz8d9OjYvXulvsIQRgg1DYYu2pnO3uWyf1qLQ3bviCXuA2neW+0YCOqhbPW2RGQAlzNhculQasq2GTyDLoREDpdmAJ2lmmxByAt5HvFKGBNIUzxvgXogAwh3datXZcEgz0TyKe2naOe8LxgNG2kWUYhyJ4fIgd9dLpMtE2U+Rky3ITUx47MgVYq+HKMDUkOVtKk6a0mpkhUkTTotOiWjLxQXpV9vQ+huYxMM9pVhjtz8S61FNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Faiw98dCSEAT3FusmkF2P4ZLBTDMrkCVGFDSIH+8IkY=;
 b=n8UKGlLoAPsnBIcvEPTQ40QNBMqCyjdBW+JJ6BRnxM6IhN8430OS+rhi1ipuPqh74wkgmiD7CoMJPCgM7JtYeNpTHNhfYkHXj0iER5Cej0rYfkia12yfRQBn7GdU5Q3IfuJMgS+L/MXVYGiSu2P+pZdogj+k3roFI4rTO9zIJbdgCAii3xN5M5fOunx+axKm11GYhGnaniUlfx1qpHEN9baqk8hNaZ/e+9CDuO8Ch5yUuhppO6NwH/jLUOljgTbFa6cTTj52P+L8rUyI8qE0/fDQWCJPtt/vjeEFJ9xiIxoZbmJzRO+69/is8LV+5qtK5jccGd+4hXnmC4Ff3ffHMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5483.namprd11.prod.outlook.com (2603:10b6:408:104::10)
 by PH7PR11MB7570.namprd11.prod.outlook.com (2603:10b6:510:27a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 14:59:22 +0000
Received: from BN9PR11MB5483.namprd11.prod.outlook.com
 ([fe80::af70:de56:4a6f:b2cc]) by BN9PR11MB5483.namprd11.prod.outlook.com
 ([fe80::af70:de56:4a6f:b2cc%7]) with mapi id 15.20.6178.037; Wed, 22 Mar 2023
 14:59:21 +0000
From:   "Zhang, Tianfei" <tianfei.zhang@intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
CC:     "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-fpga@vger.kernel.org" <linux-fpga@vger.kernel.org>,
        "ilpo.jarvinen@linux.intel.com" <ilpo.jarvinen@linux.intel.com>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "pierre-louis.bossart@linux.intel.com" 
        <pierre-louis.bossart@linux.intel.com>,
        "Pagani, Marco" <marpagan@redhat.com>,
        "Weight, Russell H" <russell.h.weight@intel.com>,
        "matthew.gerlach@linux.intel.com" <matthew.gerlach@linux.intel.com>,
        "nico@fluxnic.net" <nico@fluxnic.net>,
        "Khadatare, RaghavendraX Anand" 
        <raghavendrax.anand.khadatare@intel.com>
Subject: RE: [PATCH v2] ptp: add ToD device driver for Intel FPGA cards
Thread-Topic: [PATCH v2] ptp: add ToD device driver for Intel FPGA cards
Thread-Index: AQHZXMpv4Yo9zQ8HK06ZEDUXfqbNWq8G4UeAgAACPlA=
Date:   Wed, 22 Mar 2023 14:59:21 +0000
Message-ID: <BN9PR11MB54839A3B9CBE7BB679FBFE4CE3869@BN9PR11MB5483.namprd11.prod.outlook.com>
References: <20230322143547.233250-1-tianfei.zhang@intel.com>
 <ZBsVWWe33FJgoj9A@smile.fi.intel.com>
In-Reply-To: <ZBsVWWe33FJgoj9A@smile.fi.intel.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5483:EE_|PH7PR11MB7570:EE_
x-ms-office365-filtering-correlation-id: fce62128-ed27-488e-0e7c-08db2ae60504
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: n3eiVJCOnGcMLFdKToOzFs9/s2kiB/yHLJlN+hDMhxqwCtRU7TYuaYSIQwCkmx5a1WMZDn+LR4XnUyu1OMESz4ws2evF8nApXiVJOe1X8C4fVsO3AjZmqK0T3A9e3rm+d1S3AChjAMeyLx9kTHlW7Uqmoo34WoYzqUIlHeVwu7qTHoN+XaS81pjdUhxHrW1uQWvQyi4lOekQIlu4rzD9OjjD+zE7v6dkaw8buPPfISR3onZps7cQQWCBVUs685RGmPhCr97SrJyKUiimjcGqyqvUZYzmcMAEFDOt36FXwxxs58dpJkMXkBmJ7oNOy/P7f3t/Iug/dUVizst/lP2VTUEK3NpDRU7E7Fpm/u+i46E/Ea6ujqSPX8ahbMd7AWVFUbsEYuLgaa6nPvglijGagu4O4hvK676hY3bXfgJl38bxcS8s1q4YrXvdQ/goPaVSJPkGIuBgVe9J3u6JHZTryqTyeKrkB7bxOSyv5Cinjw9u3r3jAlOYB7AezMy+zgk2VCYpAGrzyMa6BY0uiYuDQsPujeAXpER0VdX8U2LwDAbt7J4VM1Em4B5BBAnOwtZMLzMI13gQVmoBZU1XMeN3nnBjac03WEYh6Q6mZiCnVmmv/ZWkN+YpH04KDWUKRHop2x/uln1GQde4FzwBX8cQQh3ikh4K5p1sXjvR6LjdxMOZDgO99HYcAOAZG/SW2U2VogBl/p4J/OwY6sYgfHATaA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5483.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(366004)(39860400002)(396003)(346002)(136003)(451199018)(7696005)(38070700005)(41300700001)(71200400001)(8936002)(52536014)(5660300002)(55016003)(122000001)(9686003)(186003)(82960400001)(2906002)(38100700002)(478600001)(66556008)(316002)(33656002)(6506007)(83380400001)(53546011)(86362001)(54906003)(4326008)(66476007)(66446008)(64756008)(6916009)(66946007)(76116006)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?h2+Bro01BoP6lWZK9dhFzkAhZ1gudZgNw6lMNaMISGGp5nkkayDPwr7fxjxO?=
 =?us-ascii?Q?/S8S/ynSi3tCa3WsqNODHP8kgmxYISZBCg5CZTX8xWr5ME+d5cnLGWT9uklq?=
 =?us-ascii?Q?xu7xcbEEk9MKUnmcogxLqI5JzTujXz3EXwqxUGr05CsQ/uk00A/YkV5ym4lA?=
 =?us-ascii?Q?ynQ0oAuEYUFJbOJfIyKdKl/LZlSmeEIrRJdcvRXVx203b6OqZerhKSFCTgKK?=
 =?us-ascii?Q?mmQ9vGhGvQ44DIG5SvTqWvAsPGM2XCtx25TCHaa1m6RgnP0FC18ZSYGekJsR?=
 =?us-ascii?Q?J5GKZLuo8EfQS3W/YDrympp268Izks8y1NMNFg7TcUAjNDc9hQJO+4UIUltV?=
 =?us-ascii?Q?uJKbHwl7Dauspf1YE0UjwKZ+rXa/hjM051TYYIINcAhhGKN6wXRttSvTw5D4?=
 =?us-ascii?Q?kL9PeLhQZnpkP591NEkK3rbOWN4EUln4EqsqBU8Xb7k9GniRex2QEaBMqnae?=
 =?us-ascii?Q?2CNuVvPZ7NRIsmmWvgbP/3RlBP6lBOqCeNjnr8RFXDqJiMwRmxo8V5or+KSo?=
 =?us-ascii?Q?z5yaeEK3FfrzRis/ICZf/pvBQOu6IfzKN/fIdfaWf//Lv3DhdioFmz/ee3TV?=
 =?us-ascii?Q?kOK1EKP3QoclqTeY5bPF7ok7dDB6NslDj6vQy4AcOru4yuKpJ2NRhTV6zKz+?=
 =?us-ascii?Q?e4m1u4CYGFRHOacDYA6r9vh3dkpKA0u26tIZikRggy1iECcOoEdXbqWshAdW?=
 =?us-ascii?Q?c2ZaikWWfJyObf1sRVkDi5InG3Zpr22RZIS0S1SG/3Wp+PrAXLiZZPEIWer+?=
 =?us-ascii?Q?CFTVi6RQOAbRXIQfUhlT2bGlJvavK5Sb+qYOh7EwdMkeSgsvyMaOCgnks+yi?=
 =?us-ascii?Q?uoeMcMS0gMLLTErRU66aIdXAWxJvOHfI6t9BeNpWlsl8txBj/gDHyApfNuI5?=
 =?us-ascii?Q?qtQ1MpslRIoagKe4WGWECif89pI5NITMGz5VLGDJlQd+15Xl8vRr1B+WVL1T?=
 =?us-ascii?Q?f4FSAC0KcQsT+8EXjdoatPylkpZZyZXqfYGHmZ1Q+HrqVJeqpUkNHksm/3e8?=
 =?us-ascii?Q?Eqsw6xQby2Vv0wdEElKQFklnYXEOjrFoac2V8mxmmkJzvhhBZ+OVW19sQ5/d?=
 =?us-ascii?Q?HbHdClv6tCIRdsENo3mRNy66Ue8gGTnPXDUNCklGOU8zgQesxYH65gDrlkun?=
 =?us-ascii?Q?U2dGUZ5Xy/ZMMTlklrdoHfZPMy4VUvJWr3S/jlJ9S4gMuDERXShGt1if6/SA?=
 =?us-ascii?Q?QDfSWO08ufBuXlEKQv/lIB7Uc2yILHqJKLJ3QNU7nkFULDwB+GA3hbpPijAN?=
 =?us-ascii?Q?Lq94M9uuCfFdO1B11fT77QTocIgE9/3oHG/IY0O9uoNL6n8jGVsMK5pyDHrA?=
 =?us-ascii?Q?dhVv/r8MmvDinUX/2/QnmCn7M/H907kqVwPjRnDJiPiMENtIkdHuW4Qv9k3L?=
 =?us-ascii?Q?ayBE+BVsX3WNuwZkobpvn+IuwssMmmAGRnf9zArhoCf2t/q/iaHZTYEZHOf8?=
 =?us-ascii?Q?kfYOWCTE3PAkH2+gFFc2xXvnTPC2lh85xk5gjMNdElkGFvge4N5VuQygnxlz?=
 =?us-ascii?Q?EZ+g+LLQwLrcM8vTWJ7/Sa0fs/ND0yJ5jo2K0BjNuMKD1ahV4Pp5tRH62bO+?=
 =?us-ascii?Q?Dm+kD0wdeAyhM2b3MdvEmnCFLNsVIJlxw4kMeyi398WwShthLWAukKa7SbcC?=
 =?us-ascii?Q?0rQNOdMHrNIjhQL1Xri9k1m7ntGjvOSDi1zm0jQyBW+N?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5483.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fce62128-ed27-488e-0e7c-08db2ae60504
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Mar 2023 14:59:21.7897
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 97xErRV9jI9lL5wpWNatUAzCdjyRqY+dFXjzFp9sdqCNr6rCZsPzlblUhU/oBhKiy75ZwiaSWWbM5d5I5kDLtw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7570
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Sent: Wednesday, March 22, 2023 10:49 PM
> To: Zhang, Tianfei <tianfei.zhang@intel.com>
> Cc: richardcochran@gmail.com; netdev@vger.kernel.org; linux-
> fpga@vger.kernel.org; ilpo.jarvinen@linux.intel.com; Gomes, Vinicius
> <vinicius.gomes@intel.com>; pierre-louis.bossart@linux.intel.com; Pagani,=
 Marco
> <marpagan@redhat.com>; Weight, Russell H <russell.h.weight@intel.com>;
> matthew.gerlach@linux.intel.com; nico@fluxnic.net; Khadatare, Raghavendra=
X
> Anand <raghavendrax.anand.khadatare@intel.com>
> Subject: Re: [PATCH v2] ptp: add ToD device driver for Intel FPGA cards
>=20
> On Wed, Mar 22, 2023 at 10:35:47AM -0400, Tianfei Zhang wrote:
> > Adding a DFL (Device Feature List) device driver of ToD device for
> > Intel FPGA cards.
> >
> > The Intel FPGA Time of Day(ToD) IP within the FPGA DFL bus is exposed
> > as PTP Hardware clock(PHC) device to the Linux PTP stack to
> > synchronize the system clock to its ToD information using phc2sys
> > utility of the Linux PTP stack. The DFL is a hardware List within
> > FPGA, which defines a linked list of feature headers within the device
> > MMIO space to provide an extensible way of adding subdevice features.
>=20
> ...
>=20
> > +	dt->ptp_clock =3D ptp_clock_register(&dt->ptp_clock_ops, dev);
> > +	if (IS_ERR_OR_NULL(dt->ptp_clock))
> > +		return dev_err_probe(dt->dev, PTR_ERR_OR_ZERO(dt->ptp_clock),
> > +				     "Unable to register PTP clock\n");
> > +
> > +	return 0;
>=20
> Can be as simple as:
>=20
> 	ret =3D PTR_ERR_OR_ZERO(dt->ptp_clock);
> 	return dev_err_probe(dt->dev, ret, "Unable to register PTP clock\n");

            This should be :
           ret =3D PTR_ERR_OR_ZERO(dt->ptp_clock);
           if (ret)
                    return dev_err_probe(dt->dev, ret, "Unable to register =
PTP clock\n");
           return 0;

        But this will be introduced one more local variable "ret" in this f=
unction.


