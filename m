Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B35573332CC
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 02:36:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231749AbhCJBfc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 20:35:32 -0500
Received: from mga11.intel.com ([192.55.52.93]:20094 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230303AbhCJBfU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Mar 2021 20:35:20 -0500
IronPort-SDR: Ae/jfalcRN46WYgAQ1l40B6ocNpA8n/QixZSowcHkRtP+x6FOJXFPf8X1lmsvNOF0iNlMEzEg1
 l7VGlaDqgUyQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9917"; a="185002509"
X-IronPort-AV: E=Sophos;i="5.81,236,1610438400"; 
   d="scan'208";a="185002509"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2021 17:35:18 -0800
IronPort-SDR: HZkj08cN3UeBiYJY9lffK2xI8T5d/V9l2nT9aiINlV1DggA2m2ipqyRqJ7lAlLVS4kR+zAd2Yi
 f/Rno51s5eZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,236,1610438400"; 
   d="scan'208";a="409970843"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by orsmga008.jf.intel.com with ESMTP; 09 Mar 2021 17:35:18 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 9 Mar 2021 17:35:17 -0800
Received: from fmsmsx605.amr.corp.intel.com (10.18.126.85) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 9 Mar 2021 17:35:17 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Tue, 9 Mar 2021 17:35:17 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.109)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Tue, 9 Mar 2021 17:35:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bNZKlTvpbftgmIxJbiIZiocEC858/J7Ut9znDfgACImLekUVIZnDbe9NssqD8uBWakrzVBMBl4mAze4CuabZlLEDuemJxObX7QyaPdn+i6mpAJ+nPoiRGAUXaLX+qM2zbfzbkxWPJBOkQGV5cNv0IGIdutuyS7xDngH63Zjktf32P1I9UP/isrpNedUQE9J3ggoObNGybJv1D9pRbrlTMMTPdDmCmTdpAXlVHqAa6aPiRCHiJuqMFDvvtYeF3d7zYaWwVuIKT2aItvsjJgU4X9oSnpdwOuTusDtRiZgx3smS3Oe0xn6xOqO5z+IoFL952An28qWPgWPMF5ZrwLjVXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dYb8owBq47AHlzLQuojXaPNO4FhHMUKCFb8gqQxup70=;
 b=F2PdFnQ4eJOwCZQthgfgpj1I7Q2TMwDmLqTnryotyftPSgnxTCKCOJx94FrJrQ9iHuZ0VsNo9AnWRbiuOs2BqcUfNV30mNJSLLCoDrUddXjXJNCYfoveoQE2DRFG6BJpIT3G0927hw83XQzUNb2zb+kv31Ne3ar5WiQ6CVtwaLO81fgVkdEkKbC9xqEeWHlz0gzrqTGdwJuqWgKfYTQV2XgLjL7D6w+z/fV/yI+8jUpC7lKRJ4sIWjHfXB9ENKLN8Th3bfVxewMSczezD1TtGRdxcbKyB6lV3d40FRyOVo6SBqCg3I/nBwUiTivq1gIfysODuHYk9lSJijfj3a486g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dYb8owBq47AHlzLQuojXaPNO4FhHMUKCFb8gqQxup70=;
 b=EUwgauUrgUmVNSyU4cGYF1FQY/dtCYlZBog1CItCJKAkyAY9Y/sHhyCq+cajT4soa0rcxMTr4dCk417T8eEkzBqu2CmsU1pPA/pgVAdV7bklyd/s1RDJHK7b6qQFU32AdB4mjYJyE1tRc/bIAmmCZdW/6wCHC3eavDfH+JXIVLw=
Received: from BYAPR11MB3095.namprd11.prod.outlook.com (2603:10b6:a03:91::26)
 by BYAPR11MB3366.namprd11.prod.outlook.com (2603:10b6:a03:7f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Wed, 10 Mar
 2021 01:35:15 +0000
Received: from BYAPR11MB3095.namprd11.prod.outlook.com
 ([fe80::e47d:c2cb:fe53:e0e6]) by BYAPR11MB3095.namprd11.prod.outlook.com
 ([fe80::e47d:c2cb:fe53:e0e6%4]) with mapi id 15.20.3890.035; Wed, 10 Mar 2021
 01:35:15 +0000
From:   "Chen, Mike Ximing" <mike.ximing.chen@intel.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "pierre-louis.bossart@linux.intel.com" 
        <pierre-louis.bossart@linux.intel.com>,
        Gage Eads <gage.eads@intel.com>
Subject: RE: [PATCH v10 05/20] dlb: add scheduling domain configuration
Thread-Topic: [PATCH v10 05/20] dlb: add scheduling domain configuration
Thread-Index: AQHW/9aPkiJ4OduCXEyNPjtr0I6jk6p7jVgAgAEMQPA=
Date:   Wed, 10 Mar 2021 01:35:15 +0000
Message-ID: <BYAPR11MB309506F9C8C5814583903048D9919@BYAPR11MB3095.namprd11.prod.outlook.com>
References: <20210210175423.1873-1-mike.ximing.chen@intel.com>
 <20210210175423.1873-6-mike.ximing.chen@intel.com>
 <YEc/prj8X12/rqVI@kroah.com>
In-Reply-To: <YEc/prj8X12/rqVI@kroah.com>
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
x-ms-office365-filtering-correlation-id: 334e0683-f9cc-405b-9b05-08d8e364c147
x-ms-traffictypediagnostic: BYAPR11MB3366:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB3366780AA9C8A2E9DDA53A65D9919@BYAPR11MB3366.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SKJj8dqJv7xUFIQfHaVOq9cZtYRrKfZzqB6rm7KPXiiIYxLAljM6KnXnfK+E/Ad1gzL3yr+ZKGA4xQkz7dYN6Sx9gxPyGYy95LYxkA8bGuNOVwCfcWlVJAtbIigA+eTIUmyR2KXEQqVxNWB7REhr8EG9cyM8qkKjOozXKxMrdvpIxKbmisvY1dWlUKvoE9l+6kbUmxhOu4/E1hUmvRyD4y18KQR8JzhKqVrQxFSGutqSgeTFHllgr6Mc2zz7iv1EMtuNM2eN5ZCOQgs9jN9y4WT9gWQFF9VoZUfNKr4cYwMNT+NZGoDwHz9G/fDHVQ/yfw1IRjfH/sdgYgSX4nkG/3uiGq8AcwArx+sMYfJyTfmU5Op5NVFOquhGfmzQAo5+xBLmBBRgASTSrs2xgSpzvhSNHWMbGbBYT/KxQ1fo6GmoL/ygh+C59xBODARs75B7VQ+kqkeKFhsva0h7pZyRFgXnE8tJI3dw90MylC8CL3DPTZZ6x3o0gnd9DYZTU0YHLAV/R/3eJmwNqskkPNT9BQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3095.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(376002)(396003)(39860400002)(346002)(6916009)(86362001)(2906002)(9686003)(66446008)(83380400001)(66946007)(186003)(52536014)(64756008)(33656002)(4326008)(66476007)(26005)(478600001)(5660300002)(76116006)(8676002)(71200400001)(8936002)(7696005)(55016002)(66556008)(316002)(54906003)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?u5eSscJQVr986T+VheMbfocrYFSVzGTWalSIGniDcNTYRgFzi1FjnUXMsJa5?=
 =?us-ascii?Q?C3gsZDT69YRvcvx+bsk9pZ4hOGRc0QRP3PIFcjyosI2g19zC+wINpxdRr8JF?=
 =?us-ascii?Q?9OXhSku1JzPmPkx0VndV+OlvnSOMrtN5Pwo0V83tUiM/iHylYXacifpOnyrr?=
 =?us-ascii?Q?rKvbgzKZzK7YEjumyY9kOMrfyt1coFb0RW8kVGABSUlSTAmB40nW8nDknWCE?=
 =?us-ascii?Q?hrPuWrOscloGfNpU6MbUpp3Xnlvjbxvcm04yhDJz18gSfme8lGyLFV177W+6?=
 =?us-ascii?Q?Z5EGZoWLMv+agoFPdCPFXmiLWd1r92jTG839u02SPnkB64mvjb6xU6893AaO?=
 =?us-ascii?Q?d2KXg2q2n/2RRVMEgWD33e9+qcJ3hlNAClXiW7FDMTo26g3bqfDM+J8aT4AH?=
 =?us-ascii?Q?mD629X7zUJttmRonBoM7FagXtpWKzC8o2HweL9sB4FR4LXSgSnKMUoQsJ107?=
 =?us-ascii?Q?uGzVLolAEKirLgALNPh+JGxO5/3FGyiVmB/XBgC79xxyStEHWbYEqEPw4fFy?=
 =?us-ascii?Q?EfT3OpKShUUUs93wuT/7ENmJhQ9edhXFC43i4YxqEwec6Ji/k3c8ii0XK5El?=
 =?us-ascii?Q?SjLniXj0sdJpSvEnNWMcrQJp9bn6y63BAy7ZNbLtg8O2Bjz/8qLTycAy6SS+?=
 =?us-ascii?Q?3lwgCUHOFixyG8j9mXGjiy+Ou/aY6K7xv7UdlGSBYSlWvbLIr63PmyGyCQAy?=
 =?us-ascii?Q?uw7jVHdxfR1NESkB8xYUV2h14iqF40dGONclmTcCRSZBjltnYwZQQQJx9w7v?=
 =?us-ascii?Q?9Tz9I2PPjTvTg2LAu+FQjBSqiSbQQieGlIiStpzWY6tsNGQvfrzBWnj5FFa+?=
 =?us-ascii?Q?7bcQpSDWlfv/T5c8xy/llK5OlMoCMt5Y7tY3TK8hkDr1hs7OB95XUaHc/1Ao?=
 =?us-ascii?Q?0MLJpuzVJmbCnD8Gp+uFIB8hcuZDZcoZxymewsqUDB80iUZxkVJOacaVUdV6?=
 =?us-ascii?Q?PCQc7JhBy7BU0gGm7KM8fJVDYYuMyPdYxAV349c0EI3dQslBGLta4WTtxKWG?=
 =?us-ascii?Q?e66HjdF1oT3akKy6mB2KuOiatEZ7B/GOEEdx8i8IP9wiukZcuXlmVZQu5MxY?=
 =?us-ascii?Q?Ql7IcUUJuDnUPFxJqW6AVJFamBeeiCrq4w8yJOMO2AH2KHMs/o93+8YYZ3ot?=
 =?us-ascii?Q?rfHwLK8ZFU3mil/IzRegHcS+71qq3YXIbvbVBSDE0C5GtlbN+V/7IKCwLW3T?=
 =?us-ascii?Q?Q06vebcUwBzWfF1gNpjP2K8RLffFTUgPM+2HsBOx/Wpj55JG4AC4FxeycLWx?=
 =?us-ascii?Q?XTJsJ7hfke6jnCFQbLAzEWWnfOz/Q6IeosjDMIgKmK5SFzfNASJA5CGG5UXD?=
 =?us-ascii?Q?PvjP6N/0siXvGs/g5YPNtKr5?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3095.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 334e0683-f9cc-405b-9b05-08d8e364c147
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Mar 2021 01:35:15.0396
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Q25oaHyQB118zRCMhqSGobj8maOkJ7xcDWUfk7k3aWBjSbH/2QdtggsK4zXHBxxfeNpsyJecA+K1II6O9tyJWQjprQWyuZhPluQLMX0jhU4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3366
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Greg KH <gregkh@linuxfoundation.org>
>=20
> On Wed, Feb 10, 2021 at 11:54:08AM -0600, Mike Ximing Chen wrote:
> > +static inline int dlb_bitmap_clear_range(struct dlb_bitmap *bitmap,
> > +					 unsigned int bit,
> > +					 unsigned int len)
> > +{
> > +	if (!bitmap || !bitmap->map)
> > +		return -EINVAL;
> > +
> > +	if (bitmap->len <=3D bit)
> > +		return -EINVAL;
> > +
> > +	bitmap_clear(bitmap->map, bit, len);
> > +
> > +	return 0;
> > +}
>=20
> Why isn't logic like this just added to the lib/bitmap.c file?
>=20
> > +static inline int dlb_bitmap_find_set_bit_range(struct dlb_bitmap *bit=
map,
> > +						unsigned int len)
> > +{
> > +	struct dlb_bitmap *complement_mask =3D NULL;
> > +	int ret;
> > +
> > +	if (!bitmap || !bitmap->map || len =3D=3D 0)
> > +		return -EINVAL;
> > +
> > +	if (bitmap->len < len)
> > +		return -ENOENT;
> > +
> > +	ret =3D dlb_bitmap_alloc(&complement_mask, bitmap->len);
> > +	if (ret)
> > +		return ret;
> > +
> > +	bitmap_zero(complement_mask->map, complement_mask->len);
> > +
> > +	bitmap_complement(complement_mask->map, bitmap->map, bitmap->len);
> > +
> > +	ret =3D bitmap_find_next_zero_area(complement_mask->map,
> > +					 complement_mask->len,
> > +					 0,
> > +					 len,
> > +					 0);
> > +
> > +	dlb_bitmap_free(complement_mask);
> > +
> > +	/* No set bit range of length len? */
> > +	return (ret >=3D (int)bitmap->len) ? -ENOENT : ret;
> > +}
>=20
> Same here, why not put this in the core kernel instead of a tiny random
> driver like this?
>=20

OK, we will put them in include/Linux/bitmap.h.

Thanks
Mike
