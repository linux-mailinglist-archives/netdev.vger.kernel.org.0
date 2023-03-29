Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B31126CED24
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 17:40:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230354AbjC2PkG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 11:40:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231145AbjC2Pj4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 11:39:56 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2BAA526F;
        Wed, 29 Mar 2023 08:39:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680104391; x=1711640391;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=idh7kxpYksKTIVCfcoAl2ZjxrBH3SxhDuDXBtAtTp94=;
  b=UOXba8bQimEnmPnT3eAc55AS1uqE/8ELADhwcGYEeZWqhJffsqb/QCo+
   DNM1DYEC+SB8fpAVRuynv06ZxQfZ0DMWj5khvUTGpHcIfa0pIo7obFMlu
   HN1OjDvKF+vYAEXRZhLs0jnYgtaEHIHsf4JGwuCQqGC3Awvs7/nDX8f3A
   A0CU8Gi+4WpvWSBj+K/LVWeWEg4zPqR68Sw1zQ4OrM5xpy29KsAys16Jv
   hkqqIdZ/66DjkCLm/og2EBjD4Qyk/9cf9UONyZKbiQQX7h0430pNGjbMl
   VpZHfrmzQUoDzYCPQLmEYg64lDurSmJmJqF79RzbAmwTkrFodGczosTea
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10664"; a="338416737"
X-IronPort-AV: E=Sophos;i="5.98,301,1673942400"; 
   d="scan'208";a="338416737"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2023 08:39:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10664"; a="716920768"
X-IronPort-AV: E=Sophos;i="5.98,301,1673942400"; 
   d="scan'208";a="716920768"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga001.jf.intel.com with ESMTP; 29 Mar 2023 08:39:26 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 29 Mar 2023 08:39:22 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 29 Mar 2023 08:39:22 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 29 Mar 2023 08:39:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kw0F8uoNdI7m/psr61W1CtamgsP5D1edbUWi6FNGMa6UbGfE3GSFbVykPnZGuIeXHa2cBHX2XTFck5oQ6xQf+McJF0Tw3U0CFrr9bOoyql8VQbcFZpAgRzUfHrk0WuKGzJAjUJhWV3nOh6MEB1ul8WtPrD7ntXvvhQKmCj3dNHCrgrFpTCkCX0bxkJM2+hJCAHI+UCLG+RW3wpsO34OuoKL3Hr7BREJ1KA3Wp4ViYgGfAC9JL4MEQ3h+s4p5xrcZ+9oGL6CMoXYHB4cxZ+vj/5FhGISykXg5LojWDXWRbeWNV3sRtDe7Z1d7LvegCC5ZC3mFC0yPuLFK5iMxpDXJNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3EM8dncL3ooa1bbH0U5zcFyhqsGQtAa58SBgnbmcdJE=;
 b=fAnkV/TBFOfHQLJqqiaCb9qgLov8Acfhtw/dexz3qp3vBJXp9FSzDNva5I/4553PPan7e6QnXVnrrys6id5qx3VUra7xUZhAvx53tJEhJTP75AzL6nhs8WsnjopdSzoDvuKSzWp1qsy27w+YDcX3t1TozcJYXtXTT/qnpHhrAZnMlQZY+RlQ/3nxKUwXrLSP3//wzJHzBkBI1rw+La1Cf+FwUSlYM7qEMqkHIW3GHFEASCP41I2aZHb3WofFK6k5XBgtMocF0YMek4ZdYJJpdin4ipofXr6vb4dhnRnjtCVESa0HDayR6kmX3uOU9UVyFEC/rsHVPzJ5Ryx9vkPOQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB5776.namprd11.prod.outlook.com (2603:10b6:303:183::9)
 by SJ0PR11MB5037.namprd11.prod.outlook.com (2603:10b6:a03:2ac::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Wed, 29 Mar
 2023 15:39:14 +0000
Received: from MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::e704:474f:7205:a467]) by MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::e704:474f:7205:a467%2]) with mapi id 15.20.6222.031; Wed, 29 Mar 2023
 15:39:14 +0000
From:   "Drewek, Wojciech" <wojciech.drewek@intel.com>
To:     Guillaume Nault <gnault@redhat.com>
CC:     Andrea Righi <andrea.righi@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: selftests: net: l2tp.sh regression starting with 6.1-rc1
Thread-Topic: selftests: net: l2tp.sh regression starting with 6.1-rc1
Thread-Index: AQHZYjl1GRPOFSRp8EO/z00nY9tXgq8RxqfwgAAajwCAAAHa8A==
Date:   Wed, 29 Mar 2023 15:39:13 +0000
Message-ID: <MW4PR11MB5776F1B04976CB59D9FE41BFFD899@MW4PR11MB5776.namprd11.prod.outlook.com>
References: <ZCQt7hmodtUaBlCP@righiandr-XPS-13-7390>
 <MW4PR11MB57763144FE1BE9756FD3176BFD899@MW4PR11MB5776.namprd11.prod.outlook.com>
 <ZCRYpDehyDxsrnfi@debian>
In-Reply-To: <ZCRYpDehyDxsrnfi@debian>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB5776:EE_|SJ0PR11MB5037:EE_
x-ms-office365-filtering-correlation-id: 19fcd8b1-c1d5-40e1-46f2-08db306bbfb8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MxBSSWzcthhYB51NaQ1Xzqwq6uYuFxsg2o5ADVsVWhUapwk4RgaHiqGcD2PYHRCFXUtXgJ8TA4y6S+pENl1wlZyNayKEAVIDEDREb7X09ioOQYYvZTqhlLQDAhsaNUhe9VCg4BqCDMh0K+4f3efknc5EAcBXaR1APzUUKloro57B+xp5AK4jE6QUPkZyUdfYOsGshhTElVyUMXwrYbppZhiXVSkfMpvMPPaqCTSosyC5X0gn9DFzpFc4b1fdsqHuUMMdYaYOav/LaWPLQmUYsAnYpuWI+L2WVjCq9ax5dvAc/52L8pctkbtRo38XnKeuvsTuympYhmR2tGwhIj2S/xiurE5gVf6vgQDztqfoxGSzPjFN7jJGHdnKVo+47nprWtq9pRxMC+wd2/mqlTHmtuwH6bywLl15c1KRwggcQvQTBNJIc8vve1hmJ/a0Af9kPdfW6JaRq2E5J4L0FUsWwui5WMwSccUKyynPNg33bmIBRohto27gDSfYokGFEKupNumLPIu0JRSWhiK+mAUlsaRzPDq8vFvPxfGkTOU2UOoC2w2ZiD9mKooZR5/R9UttmYmO5Q7tHc40rOs6JeTine3zWHg0BukhoepEqmV+Uz7XTVaOEE1r/aDiXQMOsd29
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5776.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(366004)(39860400002)(346002)(136003)(376002)(451199021)(7696005)(54906003)(53546011)(478600001)(316002)(6506007)(9686003)(26005)(71200400001)(52536014)(66476007)(66446008)(6916009)(8676002)(66946007)(4326008)(8936002)(186003)(76116006)(66556008)(41300700001)(33656002)(82960400001)(122000001)(64756008)(55016003)(5660300002)(2906002)(38070700005)(38100700002)(7416002)(86362001)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-2?Q?ncMTe9I+3G5Pl98q48d2IpYDWZkOWBZeCTfgyxp4gvD5HhCPSjFGMbRTLB?=
 =?iso-8859-2?Q?ufIMlt8LyTP7YBDM1qjjpTLplMddvoz5YNQJ3FX/xKvJJDYZYHyOywxKpc?=
 =?iso-8859-2?Q?BfxXzwu1JiaYFTlVrtqAFPoh44qiASbd3Cn9wSSJNOVrXdbA20l+YygJoE?=
 =?iso-8859-2?Q?DkxVBoIYBu6aBf2cq4A/6c56lgDX+wHqPwfSp5fK236QWValFRHlUDIVP1?=
 =?iso-8859-2?Q?cDhc00NZL7qIB2t1vSM/PYR6Xm/Ta7I7zvheVed+qZ4ufngM3ejirJ7S5X?=
 =?iso-8859-2?Q?v3IGJDN9yeUXWAwQufLlfFC1adqoi6zliVRZ0xqW2aAi4TOY9qbbPQ090W?=
 =?iso-8859-2?Q?HagtzsYS8ZQeupPce0cbH4CWOQfmNUdxaiNUyrkyNIRJUvK7eRJB9NcttT?=
 =?iso-8859-2?Q?pQ07SGBwYIK4lwhkopvztyDU9+MsXYFg6FQpt2I+AYTlsmPnFyUrpm94AR?=
 =?iso-8859-2?Q?nsoNwENV55WPnB/BIOIqJ+bCVkhgoM2AWnPEqX5xBXpQFPJe4v/PcfJMkF?=
 =?iso-8859-2?Q?R/O8+ijKQpHz5QErJy/+nrln0C+ZuYhYihpjfF9/NuS+rfaRgxRl0Js7vQ?=
 =?iso-8859-2?Q?q03G8QMs64JLbjcvkNBKpJqrgoQBbX6tpKkYrPtwqfvUnNt40ghnPC3/sr?=
 =?iso-8859-2?Q?zpVkCacjwpjRqBU7nC88YWnF9C8p79WtLgljgVL8GfUIzPtd/Tk87Oq+n3?=
 =?iso-8859-2?Q?hectWmQfRH9LpXIi/tabEECiCwvWhTjr3WX0MCpYNSL/qtswS3N/omkQGM?=
 =?iso-8859-2?Q?aoJpRhR3/5Uwzu00IwgwUEtEtHEWhouP8KFDLweE6P8noi6WvrnOgIaKcd?=
 =?iso-8859-2?Q?KoIzb7BeTf5fzRCTD4pvlpJcVEQLmfWklyf7A+NGmbeY/dpmX+NV0vhKnU?=
 =?iso-8859-2?Q?4Fcnzm2lkfAGjydWW1+c45fNlsfR923eNuF3neXcgmr+iahf1LwfagfFTj?=
 =?iso-8859-2?Q?m2IG8bJjPntIGzokJnUK84t161d41zMUvvbqfyyBOLOx7WDPQGM/RVajRK?=
 =?iso-8859-2?Q?TSE+7Qn5lo7LxTEQKlzLUOeDpaN5XU5DmNla4Vmd1vXh0TOImUhi3eWJgu?=
 =?iso-8859-2?Q?jtcmxZfkM3y/XtkD9zHItqJHz4L5RwV+nvylfdnHMbN3ARRwnMtmXoK9kC?=
 =?iso-8859-2?Q?QMm/gEjitqp0ML3Z2+kupWHGctQMteREA7n54i0M5Ug8gUz+qIJPQb9xIS?=
 =?iso-8859-2?Q?Oz43QWuMv9w9iHrHj4CSYDq1grW/pW6TrGsArqyNsIqDe6aayPZWtZs+L0?=
 =?iso-8859-2?Q?O9m/a/osg4UELg9x73ibF1Oxpq8qhyQGMioKVMvcXDvy1IzV21T95alHRz?=
 =?iso-8859-2?Q?laFaGRIW3hx6M6D0BvJF0wAC0FwTBRuQ08cGWd/bajnRF0RVm6SIW8cc2s?=
 =?iso-8859-2?Q?WBHhe0bQkKg222quzJKaqdVeVPF3qJmlWQjffuK7lImiBd8CYuZqyxNyZP?=
 =?iso-8859-2?Q?FOUo14NdtJft+m0VGDJOXQpdg2c9v1zLVze44g+argLGNlGDHeEAyazfPY?=
 =?iso-8859-2?Q?011YFvn7eOgqWIvRhgzr2iOJe/2Zo0KeBoKyZDlrnN81V2bT+d8+MBXRfS?=
 =?iso-8859-2?Q?3SU8pgg7NfNYCU9Ib8xqIxCE7QDSP4RrwyvMrYdFK7GgYeoZ403pdn3/26?=
 =?iso-8859-2?Q?oGBgkIWJe47YATUBolUZhvm3qtGM0ImiVr?=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB5776.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19fcd8b1-c1d5-40e1-46f2-08db306bbfb8
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Mar 2023 15:39:13.8768
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sW3RKaF323/Bl4OKuTPT8YdkjMW9HpwrGg1HzYJTxB2tzPYsDPqzWPXz9yQDe1FE5GsOx8xesQAWJCVrTD+3V8pugZhTDeUPJCU0U45Sh50=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5037
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Guillaume Nault <gnault@redhat.com>
> Sent: =B6roda, 29 marca 2023 17:26
> To: Drewek, Wojciech <wojciech.drewek@intel.com>
> Cc: Andrea Righi <andrea.righi@canonical.com>; David S. Miller <davem@dav=
emloft.net>; Eric Dumazet <edumazet@google.com>;
> Jakub Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>; Shuah =
Khan <shuah@kernel.org>; netdev@vger.kernel.org;
> linux-kselftest@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: selftests: net: l2tp.sh regression starting with 6.1-rc1
>=20
> On Wed, Mar 29, 2023 at 02:16:37PM +0000, Drewek, Wojciech wrote:
> > Hi,
> >
> > Modifying UAPI was not a good idea although the patch should not break =
userspace (related discussion [1]).
> > We could revert this patch with one additional change (include l2tp.h i=
n net/sched/cls_flower.c) but then again,
> > modifying UAPI. This patch was mostly cosmetic anyway.
> > Second option is to try to fix the automatic load. I'm not an expert bu=
t I think
> > MODULE_ALIAS_NET_PF_PROTO macro is somehow responsible for that. I noti=
ced some comments saying that
> > "__stringify doesn't like enums" (this macro is using _stringify) and m=
y patch defined IPPROTO_L2TP in enum.
> > We can just replace IPPROTO_L2TP with 115 (where this macro is used) in=
 order to fix this.
> > I'm going to give it a try and will let you know.
>=20
> Yes, the modules aliases now have symbolic names:
>=20
> $ modinfo l2tp_ip l2tp_ip6 | grep alias
> alias:          net-pf-2-proto-IPPROTO_L2TP
> alias:          net-pf-2-proto-2-type-IPPROTO_L2TP
> alias:          net-pf-10-proto-IPPROTO_L2TP
> alias:          net-pf-10-proto-2-type-IPPROTO_L2TP
>=20
> Therefore, 'request_module("net-pf-%d-proto-%d-type-%d")' can't find
> them.
>=20
> My personal preference is for the second option: fix module loading by
> using plain numbers in MODULE_ALIAS_*. We can always keep the symbolic
> names in comments.
>=20
> ---- >8 ----
>=20
> diff --git a/net/l2tp/l2tp_ip.c b/net/l2tp/l2tp_ip.c
> index 4db5a554bdbd..afe94a390ef0 100644
> --- a/net/l2tp/l2tp_ip.c
> +++ b/net/l2tp/l2tp_ip.c
> @@ -680,5 +680,5 @@ MODULE_VERSION("1.0");
>  /* Use the value of SOCK_DGRAM (2) directory, because __stringify doesn'=
t like
>   * enums
>   */
> -MODULE_ALIAS_NET_PF_PROTO_TYPE(PF_INET, 2, IPPROTO_L2TP);
> -MODULE_ALIAS_NET_PF_PROTO(PF_INET, IPPROTO_L2TP);
> +MODULE_ALIAS_NET_PF_PROTO_TYPE(PF_INET, 2, 115 /* IPPROTO_L2TP */);
> +MODULE_ALIAS_NET_PF_PROTO(PF_INET, 115 /* IPPROTO_L2TP */);
> diff --git a/net/l2tp/l2tp_ip6.c b/net/l2tp/l2tp_ip6.c
> index 2478aa60145f..65d106b41951 100644
> --- a/net/l2tp/l2tp_ip6.c
> +++ b/net/l2tp/l2tp_ip6.c
> @@ -809,5 +809,5 @@ MODULE_VERSION("1.0");
>  /* Use the value of SOCK_DGRAM (2) directory, because __stringify doesn'=
t like
>   * enums
>   */
> -MODULE_ALIAS_NET_PF_PROTO_TYPE(PF_INET6, 2, IPPROTO_L2TP);
> -MODULE_ALIAS_NET_PF_PROTO(PF_INET6, IPPROTO_L2TP);
> +MODULE_ALIAS_NET_PF_PROTO_TYPE(PF_INET6, 2, 115 /* IPPROTO_L2TP */);
> +MODULE_ALIAS_NET_PF_PROTO(PF_INET6, 115 /* IPPROTO_L2TP */);

Btw, am I blind or the alias with type was wrong the whole time?
pf goes first, then proto and type at the end according to the definition o=
f MODULE_ALIAS_NET_PF_PROTO_TYPE
and here type (2) is 2nd and proto (115) is 3rd
