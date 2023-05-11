Return-Path: <netdev+bounces-1956-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FA266FFB7F
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 22:53:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2BF211C20FE7
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 20:53:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1ACF2BA25;
	Thu, 11 May 2023 20:53:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F942918
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 20:53:52 +0000 (UTC)
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EC3A4C12;
	Thu, 11 May 2023 13:53:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683838431; x=1715374431;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xMR5BBjZpxebrE79pgDF2k4qSTkJlXsuSvPGzVWHjY0=;
  b=R7VeX5gSL5iAo9pEwTki3owaMHkgBUInad7CnZJnaHL80LmgLOfhdKoT
   uBVrtiJYvCx6E48TXz87nu9ZnTa6m1UjnJz547d/EInCa6m2LGU0Z+jeh
   lRAhK+iXhvboybdjRlWtHCUA0DIYwffHM/1jO8vzxczEl5i5AmqpYb3IB
   YX/3ieiAYfpY/qe4sysMRkKz9XtxpreMOLuXm6tprQs8zyn/6le3tjEYc
   bOtPRlHW2O4EtYY3DpFvyPcMfT8X7dDRwbi2pQmkjl1cU2JAGtHCXVnYv
   lY5eprnVRcn+dhUzAUlm7T4v8uli5QPo94zBi4f21bnEUtZA0rAOuIblv
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="330249243"
X-IronPort-AV: E=Sophos;i="5.99,268,1677571200"; 
   d="scan'208";a="330249243"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 13:53:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="650375127"
X-IronPort-AV: E=Sophos;i="5.99,268,1677571200"; 
   d="scan'208";a="650375127"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga003.jf.intel.com with ESMTP; 11 May 2023 13:53:48 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 11 May 2023 13:53:48 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 11 May 2023 13:53:48 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 11 May 2023 13:53:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gOAocadssS0eQU+KGLtfAKETaIGxIebvrNyW6pRu0g0KvK1kkEUmDVusiH81umuEtz2uN/ynyisAJHKArR/uBmR8sR/HVxze3EqUlytDAacDcEypieMQUDvuGM0Hi15P1/xa+08qYo8TKJOl0ccQgjozSTb4C+MMhVLpEaDire2K6EuLkHAFpDfx8sOM90qQCOaIp+p1hRGiVWiDW6BCJLr2GA3APve5PADg1RgEOLc2gC/0SRy5oSqc2cWaWuDcBsG2gcxFC/tbSVYuCgQ4zVBw4wdWFlXGO/aCIJY0L7J9JcmEnXXMrdPSocYYnaMDhJCkMnvcwze0ImeHFOwv5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sIU1FpWApjhCjjKl98lJnHnzL2yln2BntLKFqtTjVBo=;
 b=IdeueXRfB6TbwJdkFG9bz4X0APhmEAAh0A0+7CmC6/92uZIgsYtbqYT8K2firZB/G5TeJ9UenpDNLoDkswzScL7TFRk1udN7TslN42KWyzFRlsuBBqYJISvDwnNi8+xIkTbyisoSYvJaDNSsLpLjQbOqXxbfzJekdEPRlYopuzPKs3KB50lLQbJMmRAS6l6Vby9t9aAFcAnveJEPaH/rvTAwds64hgz+XueHBWfgrk7SSbGKDN+WxdWApV57QqAOq8dHLjBxiW8mq8JpIEBhDExUGYwCXNyAC0ufZEcdGIiUCLRqwg2Jg/tUrgX675Bh04WtkHxIgtA/DwQ3yQv++A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 PH7PR11MB6932.namprd11.prod.outlook.com (2603:10b6:510:207::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6387.21; Thu, 11 May 2023 20:53:40 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::7887:a196:2b04:c96e]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::7887:a196:2b04:c96e%5]) with mapi id 15.20.6387.022; Thu, 11 May 2023
 20:53:40 +0000
From: "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To: Jakub Kicinski <kuba@kernel.org>
CC: Vadim Fedorenko <vadfed@meta.com>, Jiri Pirko <jiri@resnulli.us>, Jonathan
 Lemon <jonathan.lemon@gmail.com>, Paolo Abeni <pabeni@redhat.com>, "Olech,
 Milena" <milena.olech@intel.com>, "Michalik, Michal"
	<michal.michalik@intel.com>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, poros <poros@redhat.com>, mschmidt
	<mschmidt@redhat.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>, Vadim Fedorenko
	<vadim.fedorenko@linux.dev>
Subject: RE: [RFC PATCH v7 1/8] dpll: spec: Add Netlink spec in YAML
Thread-Topic: [RFC PATCH v7 1/8] dpll: spec: Add Netlink spec in YAML
Thread-Index: AQHZeWdNus9yie+T1ke/i4FdVA4f5K9KDcsAgACdH4CAChnlwIAAgLyAgAA0FNA=
Date: Thu, 11 May 2023 20:53:40 +0000
Message-ID: <DM6PR11MB4657EF0A57977C56264BC7A99B749@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20230428002009.2948020-1-vadfed@meta.com>
	<20230428002009.2948020-2-vadfed@meta.com>	<ZFOe1sMFtAOwSXuO@nanopsycho>
	<20230504142451.4828bbb5@kernel.org>
	<MN2PR11MB46645511A6C93F5C98A8A66F9B749@MN2PR11MB4664.namprd11.prod.outlook.com>
 <20230511082053.7d2e57e3@kernel.org>
In-Reply-To: <20230511082053.7d2e57e3@kernel.org>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4657:EE_|PH7PR11MB6932:EE_
x-ms-office365-filtering-correlation-id: 9ce3987a-3da4-402e-e345-08db5261cca5
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BkhVvFym+rB3xeZNPO0v9J8waYABi8ULP2V4oYOE/xgzcRHpSu+9liu9tro1Qn3jDGtjzxqo1SzWlt/P0ad2y2TacFuN4/WJuMVhcD2+5oBo0Ue0kRwlFy+W7vRkB5vb47ntX/u8cd0A8vgqAk/rub5jpnaHHsu3LicaMK6djDrhY+G5oJeAiDBK/KEjRguBLG4aX9gMymjCUNHkUtMCvGD++yXM+8rEnrHnJ99a2f69m2mK6Ck2NL+cLJcvfvGCQ3/IIfwvvG0rY63Uki8VsW9+M9RzK86uvOXSus1ExwjkaQ1Xatj3xQ3rSDauTS+NEq7vU5Ichu5rM60TBxrEd01QBAh9CF31nUjgWxuFjsWEbhsCXg/8LEOyCSOq2B9bJv+HOS3E0EoJBDdCvAbkWS+voECeccxrWi6gLMNX9gipe9UPuBZSfIeQR9DVVbY0b2b9XLidxSYXjaW4S8MDgG5/qNua+JH3/XNZCY6X+X5U35lR/p4ozxeJFuDWAEygDjwj57B92n4wT8I3XZHXqQT9iVqmM3cc0ot2h1e1PBGizQiUtIS6CqjPxTPM/lCtlqDeWrs+JnybusmX0QKbKcjuXqpKbG8qW1GisAg3elIGm8rzuH/64vAEQ3GxQuKr
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(346002)(376002)(396003)(136003)(39860400002)(451199021)(6916009)(5660300002)(41300700001)(52536014)(66946007)(76116006)(4326008)(316002)(66446008)(64756008)(66556008)(66476007)(8676002)(7416002)(8936002)(478600001)(54906003)(86362001)(2906002)(55016003)(38100700002)(83380400001)(7696005)(6506007)(9686003)(71200400001)(38070700005)(82960400001)(186003)(33656002)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?8Inu4qkB56ZvTIAre0IMe650DgTm5/NeCRByyjM5ccirTe/Kk2DJpZnM54c6?=
 =?us-ascii?Q?lLGj+qraGPU0WIzw8Xco08M2MGPg53z4B8lUxmmFpHg/Fuh/R89dpmMUTlZP?=
 =?us-ascii?Q?43a5tgW0H+iE5tKNlz4V8o/whtui8ebisUhl7jUERChbbtCo/R92nfLxcgFt?=
 =?us-ascii?Q?HjRxzCHs9z4TTH46CxztcFY4YzAFs88p6H2+zlmu3I/jvP3f5lZFsAk2AZdH?=
 =?us-ascii?Q?RZg2jyxcx7o6gT7zmJ4aq8L1Oc4YTUMX0+pQgDqIMW+thVtwjkoP2iQ6UxU9?=
 =?us-ascii?Q?AD5VI9SmR3JmYauihJVRiVDqt8zgQ4+HPPxA7GpK+N2NIZVrhqP++wVxqUQR?=
 =?us-ascii?Q?Qvl8FZ9lVhlWi267x1H+y7p+4A3x6B3+nB9aSY+dMR3FXyVVIyKQErFsotKl?=
 =?us-ascii?Q?OXhXK16W6/XIHEKRxiq/FiO5jeyYBrTg3wBGF38yhwvnOuWF//E2JlZyDQpp?=
 =?us-ascii?Q?xGNlbmpphw7f7DkV8i4/0hrLIl9jASExFexjUn0T76dKsB22ouz17bQBnm2r?=
 =?us-ascii?Q?+Yb+q3HR2PMPIRLcJ63WnWwMRPofkVZ3lUErbFq5T3hLn9PuG5MKuzvglfDM?=
 =?us-ascii?Q?JsDpyb7LqTSMvOaJBeXbFUzYiaCtcGzDR2lB0JDqmB8Qqof2llgwLgA5hJBX?=
 =?us-ascii?Q?0HO4HRjGKPZAvAoX+VDSjiK840Lc90r8db6G8gmbw0WdhnIdFqIjod4G6y6E?=
 =?us-ascii?Q?LTkSaHm8uxplePkRyXGhCOGbKpAQydptDoUT1kE5YELGetcngi6q12SbDwC4?=
 =?us-ascii?Q?JwyZ7ypukwii+Yv6cCED8IujYtGHfwa+f+iGDyxCW/qmU7av7RMf+v0nezz6?=
 =?us-ascii?Q?x+DYtAVdb1im+HmMRjSLYBpj9mTVw3Mm8DpTzZsNYGHOAx/8K3IVyVrAv8Fg?=
 =?us-ascii?Q?0iycwJYlVkTxmroauAZaw1eUIs5sHm0G/El2PRkVwKrCZeOg2qFzZR3VUEpc?=
 =?us-ascii?Q?nuPQpaD+Rn1YGhJ/UUM8pZU8fozK1n5Es7NkDp1WCM4nEAKMG7f0SLCWNauw?=
 =?us-ascii?Q?7P71hu4YzXB4TnEpohZ4s4hwZ4ZjvuZn9U7W1mm/4SSVbe35j29khJlhNkN4?=
 =?us-ascii?Q?uPFlLGkKudi3Y7JLDl+o7VaGfRwuKjxolZxIrJO3wLIXyFV1k5aXrYyG57se?=
 =?us-ascii?Q?Qcam8A9y0PCP4tH4UtueiL1oRFEqNwd9eVYpLhb79zrmf4XB6CfLqtE0wVEB?=
 =?us-ascii?Q?ybaF1mKqqJ2lbQK5NYTDA2EqjNoT5DzgQ8pa68shJLvO5UCx13K2G2/JGnS0?=
 =?us-ascii?Q?QZ1kUiZ9GZbYjtVHYERgnf0Vn2DPegijInegtffoRqZ0arSLSCeSa/c+Zgp3?=
 =?us-ascii?Q?VD7UmsIK6A/qcqxZ38tITzaUyKxg3SXjN93R9/w4kINf0mlyXg5ENhkw6rmW?=
 =?us-ascii?Q?DjkV8zmprJSTio6rbuyihMB81pNK2KYGiFgDMl15HZq64bYGGoxJ7EDljL/0?=
 =?us-ascii?Q?QZIHzmfejHoa5iwoi8z4k1rzfhZtlQE1py67ZvGtPOR4z8rTlEzloJjwOafL?=
 =?us-ascii?Q?LUIC1zApo1OuWf3Q4aOw2ZSso4/jboAyOdXEQcsGJycoeHaWwtnv3WxVzKaw?=
 =?us-ascii?Q?FF0Z5Of1YxMKb2tgut+fSlxvAvI6LADTRsH7Y93t?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ce3987a-3da4-402e-e345-08db5261cca5
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 May 2023 20:53:40.1781
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EbQIPT9d5tEY8/Noa4ABOYzm+B0zIoTZCVMm1+BtY7U3scfPJjLv1ctA0fB0RZKMgAw16nEwKiINWo4UO+bFkypzpoNNCXYIP+eZJdlFg9E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6932
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

>From: Jakub Kicinski <kuba@kernel.org>
>Sent: Thursday, May 11, 2023 5:21 PM
>
>On Thu, 11 May 2023 07:40:26 +0000 Kubalewski, Arkadiusz wrote:
>> >> Remove "no holdover available". This is not a state, this is a mode
>> >> configuration. If holdover is or isn't available, is a runtime info.
>> >
>> >Agreed, seems a little confusing now. Should we expose the system clk
>> >as a pin to be able to force lock to it? Or there's some extra magic
>> >at play here?
>>
>> In freerun you cannot lock to anything it, it just uses system clock fro=
m
>> one of designated chip wires (which is not a part of source pins pool) t=
o
>> feed
>> the dpll. Dpll would only stabilize that signal and pass it further.
>> Locking itself is some kind of magic, as it usually takes at least ~15
>> seconds
>> before it locks to a signal once it is selected.
>
>Okay, I guess that makes sense.
>
>I was wondering if there may be a DPLLs which allow other input clocks
>to bypass the PLL logic, and output purely a stabilized signal. In
>which case we should model this as a generic PLL bypass, FREERUN being
>just one special case where we're bypassing with the system clock.
>
>But that may well be a case of "software guy thinking", so if nobody
>thinks this can happen in practice we can keep FREERUN.
>

Well I am not saying such use-case doesn't exist, but haven't heard about i=
t.

>> >Noob question, what is NCO in terms of implementation?
>> >We source the signal from an arbitrary pin and FW / driver does
>> >the control? Or we always use system refclk and then tune?
>> >
>>
>> Documentation of chip we are using, stated NCO as similar to FREERUN, an=
d it
>> runs on a SYSTEM CLOCK provided to the chip (plus some stabilization and
>> dividers before it reaches the output).
>> It doesn't count as an source pin, it uses signal form dedicated wire fo=
r
>> SYSTEM CLOCK.
>> In this case control over output frequency is done by synchronizer chip
>> firmware, but still it will not lock to any source pin signal.
>
>Reading wikipedia it sounds like NCO is just a way of generating
>a waveform from synchronous logic.
>
>Does the DPLL not allow changing clock frequency when locked?
>I.e. feeding it one frequency and outputting another?

Well our dpll (actually synchronizer chip) does that in AUTOMATIC/MANUAL mo=
des,
i.e. you feed 1 PPS from gnss and output feed for PHY's ~156 MHZ, so I gues=
s
this is pretty common for complex synchronizer chips, although AFAIK this i=
s
achieved with additional signal synthesizers after the PLL logic.

>Because I think that'd be done by an NCO, no?

From docs I can also see that chip has additional designated dpll for NCO m=
ode,
and this statement:
"Numerically controlled oscillator (NCO) behavior allows system software to=
 steer
DPLL frequency or synthesizer frequency with resolution better than 0.005 p=
pt."

I am certainly not an expert on this, but seems like the NCO mode for this =
chip
is better than FREERUN, since signal produced on output is somehow higher q=
uality.

>
>> >> Is it needed to mention the holdover mode. It's slightly confusing,
>> >> because user might understand that the lock-status is always "holdove=
r"
>> >> in case of "holdover" mode. But it could be "unlocked", can't it?
>> >> Perhaps I don't understand the flows there correctly :/
>> >
>> >Hm, if we want to make sure that holdover mode must result in holdover
>> >state then we need some extra atomicity requirements on the SET
>> >operation. To me it seems logical enough that after setting holdover
>> >mode we'll end up either in holdover or unlocked status, depending on
>> >lock status when request reached the HW.
>> >
>>
>> Improved the docs:
>>         name: holdover
>>         doc: |
>>           dpll is in holdover state - lost a valid lock or was forced
>>           by selecting DPLL_MODE_HOLDOVER mode (latter possible only
>>           when dpll lock-state was already DPLL_LOCK_STATUS_LOCKED,
>> 	  if it was not, the dpll's lock-status will remain
>>           DPLL_LOCK_STATUS_UNLOCKED even if user requests
>>           DPLL_MODE_HOLDOVER)
>> Is that better?
>
>Yes, modulo breaking it up into sentences, as Jiri says.
>

Sure, will do.

>> What extra atomicity you have on your mind?
>> Do you suggest to validate and allow (in dpll_netlink.c) only for 'unloc=
ked'
>> or 'holdover' states of dpll, once DPLL_MODE_HOLDOVER was successfully
>> requested by the user?
>
>No, I was saying that making sure that we end up in holdover (rather
>than unlocked) when user requested holdover is hard, and we shouldn't
>even try to implement that.

Okay.

Thank you!
Arkadiusz

