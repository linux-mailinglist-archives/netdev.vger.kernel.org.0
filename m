Return-Path: <netdev+bounces-1040-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EAC86FBF96
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 08:52:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 320D51C20B09
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 06:52:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D01DC1C04;
	Tue,  9 May 2023 06:52:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAC7917D3
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 06:52:33 +0000 (UTC)
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58E734ECE
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 23:52:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683615152; x=1715151152;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qDoJgHGF2MKtyYzUZ++JsW9BojKNoO5oQPgSPlELFIw=;
  b=mYm0S+9SfW5Yats8KoPWFXnXin0mnvgoPxg2KR14eC+9Ji1VFqQ0L+5H
   ACo4QaCZliLMVdqjtQvCVjxVf2DtxLozkaZf/ni3DDW43FZh8gS2bwke9
   q6A2T4BKhCl2y4JxpCtGQ51DQe6PwI/JNbs246Kue7WL8uo+da2uv6IA3
   M8yPWo+PbS+QHO7oUK7Vq3jfY/aY34Ctd4ED7bDn4oYQSA0zlJSqRekEg
   egNXeEqkaRnD9XVyXJBCZmUH36jXWkO1GN72O4R6Kl5ZPSUpTPehLrktZ
   J2FIvKbQpjrJaA+KhOu63gBw5199goMYn1J7bopsqP6ujpv0FfLK2LCmU
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10704"; a="351991264"
X-IronPort-AV: E=Sophos;i="5.99,261,1677571200"; 
   d="scan'208";a="351991264"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2023 23:52:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10704"; a="649166482"
X-IronPort-AV: E=Sophos;i="5.99,261,1677571200"; 
   d="scan'208";a="649166482"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga003.jf.intel.com with ESMTP; 08 May 2023 23:52:18 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 8 May 2023 23:52:17 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 8 May 2023 23:52:17 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 8 May 2023 23:52:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B7gaRzQlZCHoLNcFnY6EOzmRjXXJ872Gncxi1ve8X7v6fbnKG6xOVgmssslrY96XuzwOzRLb9oIsZk9VzZWCn5ezq9abpB8J883iL9y+eLYS8kU2SvssCt9SsA2D5OpcL33eTNdFrH1tY0TEttXqXdaHTwmiSj72JPDkhfmMRThCTQP0WNHgkSeezCnGvvl05CEP6yTLLURJm9B+ifsWFXbpUTHx2aTuhgDKbP6BYMFvfxMo4+nQGp4mNzNqZ79Dwj1JldVJMdR+UQGu+SQeOItMVWAvMhHXIksgueQ6uiFjewlOvgWgtVGioirjyc9D49ohxiXPxl4RU8g/gj+rEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TOHJfCq2mHPLWYgrGipW/HjW+Oy8eZBx1fWs9OwU6xo=;
 b=ZuNo9ou9Y+8xu79NK29LNWBh94J0y/LpEx7sOU5DN9Q/69/Z7LEM4GlGTlpu3/S7vS2BCJcBW0z1kAPS0Fswjq0C6mFCSON3HSCljn4JblmJWRmSNtGhke4w6vtT2CpodBk4kFmdws23+yQxooGcSiAt/ZKnn1i4ElVlV605FZJz/4KK7fAD0fU6Yl03PE/hxuRXbRxsR4npx+XfaF+Mca4UDFetlfHGbtSpygs5BrvxIsw7OA7BakDVjCQFLoage4WSwaaYrSHryr+SGRa3I9f9KWtMZgntaya1hJcaL2g6xQvknGjw1LCflukKsF7AbdS3SSrWJEpwQVnwhZUb7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CH3PR11MB7345.namprd11.prod.outlook.com (2603:10b6:610:14a::9)
 by SJ0PR11MB6624.namprd11.prod.outlook.com (2603:10b6:a03:47a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Tue, 9 May
 2023 06:52:14 +0000
Received: from CH3PR11MB7345.namprd11.prod.outlook.com
 ([fe80::242e:f580:7242:f039]) by CH3PR11MB7345.namprd11.prod.outlook.com
 ([fe80::242e:f580:7242:f039%5]) with mapi id 15.20.6363.033; Tue, 9 May 2023
 06:52:14 +0000
From: "Zhang, Cathy" <cathy.zhang@intel.com>
To: Jakub Kicinski <kuba@kernel.org>
CC: "edumazet@google.com" <edumazet@google.com>, "davem@davemloft.net"
	<davem@davemloft.net>, "pabeni@redhat.com" <pabeni@redhat.com>, "Brandeburg,
 Jesse" <jesse.brandeburg@intel.com>, "Srinivas, Suresh"
	<suresh.srinivas@intel.com>, "Chen, Tim C" <tim.c.chen@intel.com>, "You,
 Lizhen" <lizhen.you@intel.com>, "eric.dumazet@gmail.com"
	<eric.dumazet@gmail.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper
 size
Thread-Topic: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper
 size
Thread-Index: AQHZgVHu7/SNtT9IvkyNelU1xcwWA69RMdiAgABQ49A=
Date: Tue, 9 May 2023 06:52:13 +0000
Message-ID: <CH3PR11MB734541690249524820B618A6FC769@CH3PR11MB7345.namprd11.prod.outlook.com>
References: <20230508020801.10702-1-cathy.zhang@intel.com>
	<20230508020801.10702-2-cathy.zhang@intel.com>
 <20230508190201.121fb4d9@kernel.org>
In-Reply-To: <20230508190201.121fb4d9@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR11MB7345:EE_|SJ0PR11MB6624:EE_
x-ms-office365-filtering-correlation-id: cbda176c-8529-4679-2349-08db5059eb80
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WkrGtkMw0hOaZlsS7bggpsUZT8EGXwZ9FKtpDkTldTvPx3JUcz90n/hl55DV2gv0XvDC7YPwK7o54mNJUH/sbQjKCS120MEAcGIYlr1CJ+gv4fsIQfkVJadlsF4fe7Zp3jbSO+OFOz4h43CYFdTEmWPAGs+cj0fYkW33lrV2klx/03ALydHseBZX44IyNRc54NEXf9wUfFsoq2NHz/N17ssmA8jPwsdnKXd5cqNS58SScXtwzUwbri4gH54dkpPxM3KnCLUHAHm+7yMiwA12klCzc94vTtCMUqXUdIJZc7hQ9dBjugjre5IlnU9oUu+AieCd5U8+clAytCO+sfKJ8NzPRIsQucNbi+9cUlyIQN7m7BmFq/gTLDi1T5vyq/MDShxCINaoPNWh6jIz7bCtWad5ZcV7DeeANT0ztDwPdepV99514n5sOsKUOaMtaDe3D91gj36tzfLcX5UFXEWRnDwsVq97ujP5jX420z/lKZ/FflfspBO95hm+yXSlHTdS4+H+fhT69wKwGsanWFDE8j2HUNviZDXUzzLEF0C2djyn9VJhj2fljQ2eo1uv+aa+hqWF8gHV+nt+SvnOg/ix+gq7wj07iGVcH7wGInRX4kJpSj2GId65vzy5Rh3prWte
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB7345.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(396003)(136003)(39860400002)(346002)(376002)(451199021)(66556008)(66446008)(64756008)(6916009)(4326008)(316002)(478600001)(76116006)(86362001)(7696005)(66946007)(54906003)(66476007)(53546011)(33656002)(83380400001)(6506007)(26005)(9686003)(52536014)(2906002)(71200400001)(5660300002)(41300700001)(8936002)(4744005)(8676002)(55016003)(82960400001)(38100700002)(122000001)(38070700005)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?AW2JlvbxShNDqzeK4sjyoFeJal+rsTGafo5mykIQfLchTVNVdZKI47tkpIsp?=
 =?us-ascii?Q?iDHviMsKkzaoYy9mVfclG2Xs8rDTyUvO9UrkYeTEwutoAGLMvq1FcrMMMO+N?=
 =?us-ascii?Q?VtRtnUCwD1t1IjDjYBCaNlwMzk8DoJAml72b54DaXpm6t20ES88X/wyO3zGv?=
 =?us-ascii?Q?Y4Ka3VnIhMJ2hmIp1VLPjX+dvYA/JxXjE3CzDZjFDc6vnsUrynb7V5f7AVjU?=
 =?us-ascii?Q?JitZLS94WvCyrknvjW9AItM7aSIBKjMH7NCC4pzcxmx1aO78O38P8QcyAift?=
 =?us-ascii?Q?lAjQgUaH8PXX4ZKgs6c7vhAdt+5tsVRgBjL0td0JBvNM2DC3Mg/D8JZw4wjx?=
 =?us-ascii?Q?J9xeVeoajgy8jCTTlymo2FRvhjJZISsIMHClfVbcayXSPrImXWmXOtXbs9he?=
 =?us-ascii?Q?itrBj7gJjBKj0XBVdGEuVaj1oO/cVJvg8IhJU49+asdtGPLdq7Zmt/zvIguk?=
 =?us-ascii?Q?hSAKKhVNanrz9CxDN0xKN/4EZ0aDqjzkxKI1diR39ACwBcekU8o3KDBILaPN?=
 =?us-ascii?Q?XnCfX0DwtdKyv/l/4lUbE/6kkthfKihzE4jVBsyBkfZBg6/qcsUM0rjfFP2b?=
 =?us-ascii?Q?ffGf1NHHE9ZYrQ1c0W/KlqKkQjZZyBAfaOY3V5BwPMvGgdsQIv5jHh40KOg4?=
 =?us-ascii?Q?EGFL1CSYCssUwssA7ve2Va2KwJin8nVXzsPG+t0vabVpX5fJVIMqe2k2B47P?=
 =?us-ascii?Q?R5JXHoZVyYyv2XkiVGqXp1GvSjrg39BeyvtgEDJdRJIFKCFv5JHns0r0SW7i?=
 =?us-ascii?Q?fw+FqV8iNdhZJWQKr0nHvGjxpCcIIsbBfGcWkDfDb8fV8ASdRtW6fH+gPXe9?=
 =?us-ascii?Q?IKql0c2Sri46OnpKOm4WA6OYCAPfNOvSVjBv5Zsk6yO4WB0tQRS/qeGXcD5O?=
 =?us-ascii?Q?U7YydwI1LIig5BSpeWsaJpDvSClAJfxqmy3oAkElPyYoxSK+mzZcH2h/9Uxz?=
 =?us-ascii?Q?4iVNBjTUzfWZk5j9QrMiK6M4GaocMeZzgv9To43f0lE28kMDpyzGmc0+LROw?=
 =?us-ascii?Q?FtyIp+F1Gauban+30ZHzVdeGTIFWs/RoE5CUd8i4v+OH7J01Wy6P7LygHbin?=
 =?us-ascii?Q?/7xfsoSETyQ8ZvbyIbEhUnDCRhUnj0pAAtu/Bo+WScjCp6jLLrTwXnq+c3J+?=
 =?us-ascii?Q?9x1CevUJyzMOhwhqWlwheAg26ebMOrnF/9+CMYnufqceIgVsJgdeNlc+H156?=
 =?us-ascii?Q?Kp/toBZvp8biOLUlLKeyz6fcZ2Qmld9j+bGY8hLBdFQLAJUdhZhw7ie5fAQU?=
 =?us-ascii?Q?58CxWGvStDXd2VRc8fCejSIzfCQ+5UZw8EfkDSkVDmtn4BpNJ/+yOi8nzJsm?=
 =?us-ascii?Q?Wb0/cl4g2QxSN597FTu71Vqtcuaj22OF2AqI+FcWzi2kzImlAeaL6EgmylDp?=
 =?us-ascii?Q?C6AdD+aMrOdtJR4OThrW5UHOGA28LM70DV9oJm0N1bik414462S7j41bXSrq?=
 =?us-ascii?Q?wik9tt6OVEJQSqbO5frg+4uAYP7+ByxgeSqJiq4knODvgOQ5RDtJsIS+ThVT?=
 =?us-ascii?Q?Zo1nPlLArrbKro6ORnpRPq0gzvIhGA643P4E7xegIa8nidvfSACBI8vEACwy?=
 =?us-ascii?Q?w6sFTzT/cTml27FaY90wdAcSi5L0HUqyn8lIjjpW?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB7345.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cbda176c-8529-4679-2349-08db5059eb80
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 May 2023 06:52:13.6353
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DjtHi/oqwpoQDgDbNQn+0f+cbInXAd4jfbXR0oAU29GqKWy8OOLJoewOqB+0PdT+to++wku9F7dFSTAakoYZXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6624
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Thanks for helping review, Jakub!

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Tuesday, May 9, 2023 10:02 AM
> To: Zhang, Cathy <cathy.zhang@intel.com>
> Cc: edumazet@google.com; davem@davemloft.net; pabeni@redhat.com;
> Brandeburg, Jesse <jesse.brandeburg@intel.com>; Srinivas, Suresh
> <suresh.srinivas@intel.com>; Chen, Tim C <tim.c.chen@intel.com>; You,
> Lizhen <lizhen.you@intel.com>; eric.dumazet@gmail.com;
> netdev@vger.kernel.org
> Subject: Re: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a pro=
per
> size
>=20
> On Sun,  7 May 2023 19:08:00 -0700 Cathy Zhang wrote:
> > +#define SK_RECLAIM_THRESHOLD	(1 << 16)
>=20
> nit: SZ_64K

The change is done!

