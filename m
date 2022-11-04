Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C065F61A5B9
	for <lists+netdev@lfdr.de>; Sat,  5 Nov 2022 00:27:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbiKDX1I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 19:27:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiKDX1G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 19:27:06 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39663267
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 16:27:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667604426; x=1699140426;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=64KMr3dhKlUOkvbY12SZccFccvNGfepz56qbaHy/TZY=;
  b=FGkeW61GpDu8E53r1Q6QXlzirSpZzVM04HAxAdrD9FriOo96FxsGfZTX
   oqBxMG49KH0T+5uzP0LlMUQRz5mg1Y2sVKgp6XHtSjH2gIJQkFNI02zkh
   NnRZ8dS9zLO1aQEnVuGADTlgGBpd7PJaQjqIiDtzdSCHRa8OUAlf/GM/l
   k4uacotv2i8LbNU64JOV2AHMO8d1AO4Jo4r6sCFNwz8IiSLseSg0vdgyk
   L+hD+lyFcHLat6MEKwg/GmtmFPZCBMDtSWQwX4y9eCUbzsAa+6MC40j83
   GaMhRW8nRFtpruTpfv6M+vbZ7q4N2t5Q4AYlfPjVfrsx4ErUh7aUShOQa
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10521"; a="310097519"
X-IronPort-AV: E=Sophos;i="5.96,139,1665471600"; 
   d="scan'208";a="310097519"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2022 16:27:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10521"; a="724516692"
X-IronPort-AV: E=Sophos;i="5.96,139,1665471600"; 
   d="scan'208";a="724516692"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by FMSMGA003.fm.intel.com with ESMTP; 04 Nov 2022 16:27:05 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 4 Nov 2022 16:27:05 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Fri, 4 Nov 2022 16:27:05 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 4 Nov 2022 16:27:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VLuZGBm9W9mSGgFqavUpZqAQkazGmCtuPee0lZuRlA4ou4KVTbbm0i0tvAuUu8jsqJi36anPgTMVDDh9JfU9suA+wnLdrqQgs+1IbzXsF2pIrvISaKdGjvh0pBISlaWDnkfUcO82R0gScqdnl5BeALmols7DcluTPVvzflCRgJS15G/AdH+8XTQARhIUjpIp0dGgIzTU/Lj2BY7TPK2MSMdDW3h16jfV0Q7X36HtcEqc4siXVP5byULptkA5ZTqNUyNh0e0hHvUYsJVWsVm1ybOhAcnNxLnuJq1OXyNPak8X6+Rrug0UqIwOcuJ/9VuM68xZu5wDqJqtsdP7oObvxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OJp8jpQfHg9z7gSmQmDwueeYjV80Vm0xzVb10olEnOU=;
 b=blkjsmVRbD6Ono1L8liiv2tL+1b/PUkC8EQDngGi7PglmD1eB7KRlBIAPMrKYEyHLUYVr9d3skvUt53y1SnQf3PJ5Wgy+FBG+tXDFRSa/w59iwNT4B/Nve89KwI2t/OEmv98ov0hZKG0j125kASAliMcxwKEleq1G++4D2nZ8i8RN/lZAFMgqTgpa0S/IUNxUJgr/3Ngc53t9hUusf6w0kyoTusxCJ9rWfv0I5S7bmuTwQJ9YWvd8r5OwnkYfg9yMVBIabwEK1GFgyr0LqO16BYqznKWUCL+FFlwJXpAMrjZQUCeaZ3iZ/5fHHaaT+HIEzSzMjAQxz/4BGvYGRBc1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from IA1PR11MB6266.namprd11.prod.outlook.com (2603:10b6:208:3e6::12)
 by PH7PR11MB6698.namprd11.prod.outlook.com (2603:10b6:510:1ac::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.24; Fri, 4 Nov
 2022 23:27:03 +0000
Received: from IA1PR11MB6266.namprd11.prod.outlook.com
 ([fe80::c669:1d22:cfd3:da07]) by IA1PR11MB6266.namprd11.prod.outlook.com
 ([fe80::c669:1d22:cfd3:da07%7]) with mapi id 15.20.5791.022; Fri, 4 Nov 2022
 23:27:03 +0000
From:   "Mogilappagari, Sudheer" <sudheer.mogilappagari@intel.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Subject: RE: [PATCH net-next] ethtool: add netlink based get rxfh support
Thread-Topic: [PATCH net-next] ethtool: add netlink based get rxfh support
Thread-Index: AQHY78m0wgcJEiaCt0SS8duS6dhOvq4txmAAgAE7EHCAACn4AIAAOssg
Date:   Fri, 4 Nov 2022 23:27:03 +0000
Message-ID: <IA1PR11MB62668A4445C791151B657ACCE43B9@IA1PR11MB6266.namprd11.prod.outlook.com>
References: <20221103211419.2615321-1-sudheer.mogilappagari@intel.com>
 <Y2Q/gmS0v8i6SNi4@lunn.ch>
 <IA1PR11MB62668635AB345ADA118BA9BCE43B9@IA1PR11MB6266.namprd11.prod.outlook.com>
 <Y2VrAh4hha0y95Lv@lunn.ch>
In-Reply-To: <Y2VrAh4hha0y95Lv@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.500.17
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA1PR11MB6266:EE_|PH7PR11MB6698:EE_
x-ms-office365-filtering-correlation-id: 86a61c85-2f59-4218-3be8-08dabebc149f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DS5vKcC5M1fA5KrdhGSr/urcPApmZkwcjiZQegn4I37o0pTbytqljLIbYv/LBnHGv78E7AMypShscaR8tJ0E21PGpO2WJ2Ro4TGBfNdwszQ3oMoXjLrBnZvkP3yUVrGx1J0b9KC0ehur8GzhFnMvp4Us80PUOnu9lORLiw57KtMwu+Cd08heiQQ0veeaK5jP+wVuESd2pP19wnih3ezhIF+5KtokHSRq8rDJIuBCPMMSsxzuCJNzwy42Bib2rfLCXQDutdyxjORF6/u6PHg9YOb+n3QB/u5EFwMZNQGLlV/Ah1CDNaPsKqjKgsjqAMxHVwyS+0RxC1eYmM/UAPjfQYAjL7ewtXbkm8zuhNij/8gM64xsdEIDzuznlynAekgeczYtlBOgjaRao20a5yrWRFf0A/Pl/Px+XJCrZyuO3o7xXD5bdz7TKMp59C52Z6PafW9phpWrDPoxgUxZ71FpjgIY1NZG6RNXlwNoSuStPy2o36Dw/GRoHXu0zeZTk+M9pJIqc+VWhgj/z47QL3DMm5fjXYHhxRbBVsLs/favZbe7vcmRB4s1gcw6at99gMwpl87wBjrK+KBMcwbGWdbipDBaPDXBYYpmm88kmcua+jJodmz5wMxpVL9ic8XR9Dr1A/+Q4hD1U6kW1IyB1B8/B6dw2M7R0sjdrDmRNKnmpJ71XyHHDS62YyTAiI4+E0OJF8wT8Og89WWz0eQoPEej1OD/AX3YER3PbRYvkWx7AJrQznmnrUpekDYK7+elGBq2+1biS3TAJZdqgId6wEigqw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR11MB6266.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(376002)(346002)(396003)(136003)(39860400002)(451199015)(71200400001)(55016003)(8676002)(4326008)(107886003)(54906003)(6916009)(316002)(86362001)(6506007)(7696005)(66446008)(64756008)(66946007)(66556008)(66476007)(76116006)(33656002)(478600001)(41300700001)(122000001)(2906002)(26005)(9686003)(38100700002)(52536014)(38070700005)(82960400001)(4744005)(186003)(83380400001)(8936002)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?DrRGVA0QzdcYUs7j0/9/uMOPtT/GZbDcLq4d6kB7Dmr8glJ/hxQXX5ZlKVhk?=
 =?us-ascii?Q?X5S3kydaiOuYtth54MPpQ52vPUxK1H1uKyudrlxKlXPgewF+tg9GPl/Hm7sE?=
 =?us-ascii?Q?lKKaBjh3s6R0EoLshs6YIZWAtQ39J2Bbj/UIiQIiBOkhQ34lKvs5mcdj2bZR?=
 =?us-ascii?Q?ClTEP4Tj3F20oDS9Idzm4nNghHMDQAohFK7L1lRwPmyBSo9PxM0PDMnz6/oJ?=
 =?us-ascii?Q?2qfAc/agFCBEOhAwLz6IFYr7bKNlcvaxs7rWK5Go/vq4Zl2JpQ/iJNnu62CA?=
 =?us-ascii?Q?X/3W8QOSnK+T7EGXTopFuGdgUyQi3s2G/FOs4qPjAfLWZn+NAtOAWl1u0mgW?=
 =?us-ascii?Q?d4mhefHnwzZAkWfpJeh1mCcDkN+n++spQG++dHfKDx6bctTKcdgLXL3y5g/W?=
 =?us-ascii?Q?hYHrTRDIINtNcLuoirJxvZNDMJK+eaAp+rtoR8aHmd23cI31YlPLqyJCKJra?=
 =?us-ascii?Q?36pg5K96dCIK0QAeQ7bTpVasxnMvmn+UIwgQvJjPCztG8XuGVpNZDzPIopNM?=
 =?us-ascii?Q?UOHkOCQ1DzM6iJU91ES4BQ6tpkhyQFhpLxAjK8Q4BrRh3IOEOVTFugwhfCRA?=
 =?us-ascii?Q?5D8CmUqcTNVsG/JoYrykHsHjutTUDArIwdVGa7Fj9qkzaOHY65Xyd0AsGpN8?=
 =?us-ascii?Q?UcWhMzvHD3323IwU2cLMDdNDp+OlZKWh9i2YYb2ft4SxhTeltdNfMAnr8d2E?=
 =?us-ascii?Q?w33rv96xSkFwolA0VDmhuR2upOL/6n3Ij845OtXoVp6nLxiIZ1CkVoZ9UTht?=
 =?us-ascii?Q?/EyQYvvKfSsSzyM18ZXuJ4YrEiSA9BT1nMro8lpOqDwQam9b4LsVoBmMfmKo?=
 =?us-ascii?Q?ZPzhtRfLwufP3fYwAoFa1C8TDi5QTQcQyEthL/A4Ea0BlfvtnKYe04/MyLna?=
 =?us-ascii?Q?A6twtXDvk+C8F814jk0+tLPtxdyRb/W191neldGH+5cq+//TOCfZgP1x/ocD?=
 =?us-ascii?Q?ey5OttmFIb6b1HZ447t1ljGXfZIygWHX1GRSEe0i8hBiRvuQwfkxgUHjwn4I?=
 =?us-ascii?Q?wVJGc1lLrQ6WEQIQHagv9/IR2tBeM+u8GB+UE/aM0IVi3ffl3GSuSbEjVTvR?=
 =?us-ascii?Q?c7tZVi15uUgCDUt+yoSCTKF8mU2GzEN589i/Lrt1peRQ+xiC7ohCGdaVJgLh?=
 =?us-ascii?Q?6Un8UA2gPpDXQpVaGZsUu52fO7iHtDVGSQJggs4Raf0vDASew9Q7FI+At3vV?=
 =?us-ascii?Q?/TmVJJsd7Vo4Mgrx0KzBC7CbixQcne9zmidXLk1FwIMS0nT9rtjDsYOMJlDW?=
 =?us-ascii?Q?nd/nZyeCziG6OjsebZxdAaOUZI8MB9drf/z9ls6Eip350+N5qB8OquvlzoMg?=
 =?us-ascii?Q?Stg6Eh6LJYg5VRRaLM+nh0NMHo14fNgAn17MyfE0PId51H7wFFO3XJfb6c+0?=
 =?us-ascii?Q?lCGlIE/BOMvDzm8iwwRQ2jkQsncXzgw2iHTSrs1KP2DR713+ghvyVyCFzgoa?=
 =?us-ascii?Q?zfUBtjpl72caltvZdaW7LiiopVWUJiN6nkk5waUD5cAXgXCkh8JlD97zSTwP?=
 =?us-ascii?Q?WpWnpr5jzD2pDSdK5AbkKMSvdJUWGtBISUx1Db4o8amfxcK/0suhghLee/km?=
 =?us-ascii?Q?f70SStEZOpaF087ZJ5HHW490Sq9zAq0+HZpEaMFMH7d3icIPxFDERIr/U+Da?=
 =?us-ascii?Q?XA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA1PR11MB6266.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86a61c85-2f59-4218-3be8-08dabebc149f
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2022 23:27:03.4987
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4g78FfJ7NIqB201bjm1iA4PGHJLOHFR1rxgS/9xt98VoMZ+M8hh2slGzF8U0A9NXXus4AJFO89IEKubD8rBKK5Y5K7TjbfyMZykjWTBBQFg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6698
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Subject: Re: [PATCH net-next] ethtool: add netlink based get rxfh
> support
>=20
> > Got a question wrt rtnl_lock usage. I see lock is acquired for SET
> > operations and not for GET operations. Is rtnl_lock needed in this
> > case due to slightly different flow than rest of GET ops?
>=20
> The ioctl path takes the lock, so i don't see why the netlink code
> should not take the lock.
>=20
>        Andrew

Hi Andrew,
Added locking changes but testing failed. Looks like locking is taken care =
of earlier in the flow for GET requests. ethnl_default_doit is acquiring rt=
nl_lock for GET.=20

Thanks
Sudheer=20
