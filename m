Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DFA55819F8
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 20:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239689AbiGZSuA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 14:50:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237717AbiGZSt7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 14:49:59 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9ED233A1E
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 11:49:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658861398; x=1690397398;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ZCDNkZPGM3neyr0hpq78YF0/bT60DnlqpZ0KErwlLA8=;
  b=PmSytmzGmD5zXUmsXs3Xvi64BtPw/4S4ypy2UPSConU6nzbbYV4qLNWg
   WNF0keciKFCWjvlgNcuTYRetF4nJKzd15IoqSVygs5xtBPSYNQ/2zQW6c
   MRiD8M2zIr3X/JiMb2CCmv6LhLexrKXkqxYMkWw5O3G7iTn+4QfxiV+zD
   ADqETe2mnTB3axJ89/2g3Ah/66h7Otf9gYFBXifaCZ8sm7QW6WTkQglfx
   sxuTtUIBmJQUrT7PwKoZhjqaRGAnh7msr1JzVsLL7/0QvjHAmJWyW7q2F
   PfiIGUEC6WkhZa/HBZB5Cwv0KsxiK7kokRNlnXjV6AEVqEU0WojLiQdCc
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10420"; a="288794257"
X-IronPort-AV: E=Sophos;i="5.93,194,1654585200"; 
   d="scan'208";a="288794257"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2022 11:49:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,194,1654585200"; 
   d="scan'208";a="575611410"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga006.jf.intel.com with ESMTP; 26 Jul 2022 11:49:58 -0700
Received: from orsmsx605.amr.corp.intel.com (10.22.229.18) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 26 Jul 2022 11:49:58 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Tue, 26 Jul 2022 11:49:58 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.172)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Tue, 26 Jul 2022 11:49:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jQ/c+718z7uCpWvrIbE52Ln69Hz3/QJagVwdvWfoscdYrmxn2wSKa3l117Xf2eJEYtT4sYCaffgbF6pb88i/c8dr8TfTjQWY3s/XIGyW26lnbXrMKphMukRJeRrAQKunXDDuX6bpwk9arJL/BArdB8VqDN/dL4RiFezgdUz/3I1sWFItu0FPX6vsiF9NjFCcCbArhNNVANIQBbcKP0BkTnEb9VgGbgqbDaar2cyww1bpLElgTOIK+3YRRDJMHuNqTipLTEfqdtLhf7gCsnb32dClwoMYZxKvslzSwwydVEujxlEt769FJhpXLOhjsjOQcYbbCfMtZEUlm831LZq0nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZCDNkZPGM3neyr0hpq78YF0/bT60DnlqpZ0KErwlLA8=;
 b=h34LRN7YrNNVk+GXG/xuDNJ4hF9HLVVWmzCPC/9aL28JfegSCNPrcaqUXe6+HP0ovOoRgpQDnHrekTP0TOVVMoc6Na0GNiHU5npoSn9qLhL12dUMnvFEB1M6LhhNIZJZ0eJ3DcKuu6gHsgokJG1834Vjc+VGYEXUwODrdnSW8SLOMlq/7j2d+er5Ft5IFaD4x2JJPZtC9T2u9vpYUkl3CGXVKDoZ4P9A71s4BgXz3j9vtbkJAOZnZk189VssPQ7mfbH3QlnCn8yRTMYhUNcWxZ5Op5UyBhubFeCETx6OFbmWsg7EBww2IkDiHUooXypzt10Kx6PrPvNPJZLFqKrWKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA2PR11MB5100.namprd11.prod.outlook.com (2603:10b6:806:119::11)
 by DM4PR11MB5408.namprd11.prod.outlook.com (2603:10b6:5:397::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Tue, 26 Jul
 2022 18:49:56 +0000
Received: from SA2PR11MB5100.namprd11.prod.outlook.com
 ([fe80::f97c:8114:1f0c:f811]) by SA2PR11MB5100.namprd11.prod.outlook.com
 ([fe80::f97c:8114:1f0c:f811%6]) with mapi id 15.20.5458.025; Tue, 26 Jul 2022
 18:49:56 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [net-next PATCH 1/2] devlink: add dry run attribute to flash
 update
Thread-Topic: [net-next PATCH 1/2] devlink: add dry run attribute to flash
 update
Thread-Index: AQHYnGds4JyoDr5oaE22k7ooTa/97q2IU/QAgAD0rTCAAKRdgIAA9+uwgAE35ICAA1xV4IAACoOAgAAM5bCAAAIMAIAAACQQgABOTYCAAQ5cIIAAGHcAgAAANwA=
Date:   Tue, 26 Jul 2022 18:49:56 +0000
Message-ID: <SA2PR11MB5100B65B8C20D5F2EAC5E438D6949@SA2PR11MB5100.namprd11.prod.outlook.com>
References: <20220720183433.2070122-1-jacob.e.keller@intel.com>
        <20220720183433.2070122-2-jacob.e.keller@intel.com>
        <YtjqJjIceW+fProb@nanopsycho>
        <SA2PR11MB51001777DC391C7E2626E84AD6919@SA2PR11MB5100.namprd11.prod.outlook.com>
        <YtpBR2ZnR2ieOg5E@nanopsycho>
        <CO1PR11MB508957F06BB96DD765A7580FD6909@CO1PR11MB5089.namprd11.prod.outlook.com>
        <YtwW4aMU96JSXIPw@nanopsycho>
        <SA2PR11MB5100E125B66263046B322DC1D6959@SA2PR11MB5100.namprd11.prod.outlook.com>
        <20220725123917.78863f79@kernel.org>
        <SA2PR11MB5100005E9FEB757A6364C2CFD6959@SA2PR11MB5100.namprd11.prod.outlook.com>
        <20220725133246.251e51b9@kernel.org>
        <SA2PR11MB510047D98AFFDEE572B375E0D6959@SA2PR11MB5100.namprd11.prod.outlook.com>
        <20220725181331.2603bd26@kernel.org>
        <SA2PR11MB5100E4F6642CCF2CD44773A4D6949@SA2PR11MB5100.namprd11.prod.outlook.com>
 <20220726114844.25183a99@kernel.org>
In-Reply-To: <20220726114844.25183a99@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b8243f00-240f-44a9-5d86-08da6f37a260
x-ms-traffictypediagnostic: DM4PR11MB5408:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GO04IFFooT7eWLijyUGd0xIPx6vPJ5T3WZ0NNLPni5aSyFEQVTCIM25LFfu8linp9S72RRKE1qDhwPbLkBbGhdQ1b+Sc+0kII8K1TBx5/IjSmhMwbi8AbJ6lj0vVHvRVHspcXTjIvwT63fsRKfKW8jEzDJ87zkFqjzxoXsT03/fQD1iHj77qbOlmKbpY43n2GOfzNUHeJXrWChV06HJADOP51UzXjxGB4yIpmkBQw8sQM76Ej7MpK4SbFjh9Y8rhmkJn7GZOmgvZUEvioF5U9ailUHHkX/ANmVat0e7aPXUQB3LrM2dynQ7BLhbyx95Qt9SdEDYfmid2Wyf0dGPlvAmh4y7f8SBvFMWNgY/YjYQlCVGokd64UpTereK+dB0R+SWiEJanhfvEOtVTqdXV8AWo4/273aMdWl7/PlambPwJbhNQvAHvLnAPNUMNGbvxDrYC4u6SNFn9/AI6fCvln9mKgVsw1Qlh14rEVs40fNmMsGatz8CjrRlG96tomSdX6ukuile1gNGeqqsvrwABzEHzy6H3I5RYryUDtRylpKgqYr15UQPsXRTx7O8nwaKddUkQxmVMqrlv82UfIrTgFFDP9v146DCaRBw3GkDYjjGaliveO73W84MLGxdScoHZm6309az+UEVrh0h6/fHOIrLKNxr4EKaGtizTNmqQ2ptJpFTpICdujlKxyRsZLKoelu18Myzxhr9ceXGxCtGxAa3hlZuzM/BKZGnTpla/pPRlDdIa9Rbo+RVBwq/IBF+1L+SbFtI5D+rFuM6xdk+NYUbFOpo9GhtIZIPkxlm6UMEyFBT8ODKwFCW+ncrB16lg
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR11MB5100.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(376002)(396003)(346002)(39860400002)(366004)(54906003)(316002)(53546011)(7696005)(9686003)(41300700001)(2906002)(66556008)(478600001)(15650500001)(6916009)(6506007)(55016003)(66946007)(66446008)(71200400001)(4326008)(4744005)(66476007)(5660300002)(26005)(8676002)(64756008)(8936002)(52536014)(76116006)(83380400001)(122000001)(82960400001)(38100700002)(38070700005)(86362001)(33656002)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?HSTCYwtBZelo3NUJfwEyN610fCJnTPvHYCTwQv9QK0sbfVrQ/fQ33dLzR4TE?=
 =?us-ascii?Q?XsXnWcKatNeEC46dbgk+9WWNdsnthxOtS2otnFCIYnV58N/xRkga5I5daQrJ?=
 =?us-ascii?Q?ZKOvDph1H4eSCmPUozpLuscsOzaMDAe9yr3PGB7XCF7RB7x237kBZ/3SYBt1?=
 =?us-ascii?Q?8cN3hbBNaPhdWaUhTq8Q9wg7VoB6DK3g0ZFnC2czwEd6ew21HKp4KH36/umT?=
 =?us-ascii?Q?ZMKT5gnD0YZVVlTpkembUA9xw4vukw/5AsrzGrfF1VdykhBr0MyNjR2VFAP5?=
 =?us-ascii?Q?RF+N1HrKlLN4z1CGZQU/Ntmi6AyPREPFc7hhupvm7GeE5nviQBUkRMN/c6ru?=
 =?us-ascii?Q?fsHmBwwmmrQdgn0eEJErtt1Bw6u/pySkny9Mx3OSzzFEvitg4YivKOC1K0ml?=
 =?us-ascii?Q?ZB/hg/WeKWai5/TOcLVTRM14F8jH0BrmhERxinuWh4Yf6G0RFw7VeTPmiDeI?=
 =?us-ascii?Q?7pk1FKMbcWIxpamMz2oNobC30/ZCed2UtBY1zLx8kwDrp/A75sbzw2jQSjDv?=
 =?us-ascii?Q?gpXT3pVe00axa3i4ZE3KDQvc4F580637uNr5kR+v8i76k0472/O2XxvmN6Mr?=
 =?us-ascii?Q?KK26yask/gYNEeGCEikqR+0Q3rdUaU7IdqSLb6bzpATmSVUoz/RmApyGRnS+?=
 =?us-ascii?Q?I7DpWxZUIM2whupyHVySH+po0f90dhi+fhTHBHRLwIrNNMZYDt3BhP+BrMAb?=
 =?us-ascii?Q?vxrZ/P1EDMKkivTD1LOE1rATj3cSC45O0NHCbiSutxMmY8tYA1UJgQCgmCf8?=
 =?us-ascii?Q?Q35LrAQ1RUxyOMw7rFAgM1JRp3bNyQchHCDwPzfsSUt5l7yhRSftYjK9AByy?=
 =?us-ascii?Q?WC7EzqrsPqWlIFiJYfEYq3N+JVra0qUNjMi51ZSOCMz5HbGCx8Jq7cAClanj?=
 =?us-ascii?Q?YfNT5Aqlkc6uslJDfcTQhBPNcE53a6ZAxz8OubuoV6S9igWenLZ4aKvBEgwr?=
 =?us-ascii?Q?E0c4N1kQxIHIY6bQZoaLtiJnMNcYCnuMDGm0L4xqnCOQGXZU60p7NxZO/iwA?=
 =?us-ascii?Q?NaKfFMv1jyeJdR8cTUOd2EFdg6/OpOB8kwM0NhhVH5KDVmTEYhTz3xRyNcWK?=
 =?us-ascii?Q?nS+si+qSxJjzb6xhaINwQBOEmBgi/geUiMocm23hXOClyxABv0n7t/E0vUem?=
 =?us-ascii?Q?bxHQWt79Ag7Zuq8FS+MrwU+ex9kOmE+jAtUiR/8y5xt1nWpCNil/RebiFcJm?=
 =?us-ascii?Q?fq0ydF5Di+oYyCOsTAB8NGTtWWwltQff92u1aYj4/JI+7ATwkKIuA01L0Ytd?=
 =?us-ascii?Q?47HUe9NvphfTHJopf8pCvRVGxOUSejGLKa1UAjJgt7+UdbFarhtxKDQDQAtK?=
 =?us-ascii?Q?bIrGYZ9B0aQY1wEj1xJiLIpU3SakfKx6cF/MMvWtr0aH6BEWe1ij2XY0Hh6l?=
 =?us-ascii?Q?pniK7QE5Mlr2HOTYct51BzFimUvr9fpGbL4Hgn2moaAr83DcVm4AmhQj/OYb?=
 =?us-ascii?Q?Ak3riI6161RMVcLsq85ASem5k+vXpaqhaphZfwmAF1zA3BSdcTPWOB0vAnvC?=
 =?us-ascii?Q?mcGzw2yX72YXH+wDfvJK8gHHyS+lkjVgYLWFUtXPkSvxxROXZY350CCEH6q/?=
 =?us-ascii?Q?xlLctJ1f1fMiah16QF9Gw4kjkqWog7WGI5m7HWLb?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR11MB5100.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8243f00-240f-44a9-5d86-08da6f37a260
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jul 2022 18:49:56.4142
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2F0doYHSstBHtIKg0+VosyItZZ/ssSgyBa8D0Un/w8n+dJPUKcGKdTQ0obiTvlChYTaETBLsyW32Bw6cX+ogDY5GszfjIQQfM7vz7dtgYkQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5408
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Tuesday, July 26, 2022 11:49 AM
> To: Keller, Jacob E <jacob.e.keller@intel.com>
> Cc: Jiri Pirko <jiri@resnulli.us>; netdev@vger.kernel.org
> Subject: Re: [net-next PATCH 1/2] devlink: add dry run attribute to flash=
 update
>=20
> On Tue, 26 Jul 2022 17:23:53 +0000 Keller, Jacob E wrote:
> > > For now maybe just fork the policies into two -
> > > with and without dry run attr. We'll improve the granularity later
> > > when doing the YAML conversion.
> >
> > Not quite sure I follow this. I guess just add a separate policy
> > array with dry_run and then make that the policy for the flash update
> > command? I don't think flash update is strict yet, and I'm not sure
> > what the impact of changing it to strict is in terms of backwards
> > compatibility with the interface.
>=20
> Strictness is a separate issue, the policy split addresses just
> the support discoverability question.

Right, ok.
