Return-Path: <netdev+bounces-3702-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 11B087085D4
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 18:19:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 48E962817B5
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 16:19:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A85E623D7B;
	Thu, 18 May 2023 16:19:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93EA953A8
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 16:19:43 +0000 (UTC)
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C765819A
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 09:19:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684426781; x=1715962781;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gyYLzNfrcz3yfC/VDQ4/qNIziBgqJ0Q3IQp0pbx2MYY=;
  b=H0SsVDmPOqtyle+wTTbLk0FHUVtZjMsDq3desdZiqJ0T6uic+7iTBruq
   D2Uz0MOBu8ygD93wTG80NcBxI0sXFZU7cvSrbs9nXotmatO+GH+vm+G6z
   1dxqCq3JDdBxwobf07XDV1sNW2FToh0/p5kRm22eOSoooxuyPxBTIlUff
   ODeiTFuAXqWNucBE08mXhVKOtXRyX+BrxttzfCjUKCKcSP4HdUiZMH8eG
   i1jk+sEYXsRXcM/OuLdL/abms+Xh5fF2j5ZrGwNSki8bGuSqJG4AxbKqa
   i/AvDMKoaUuPwa8iZ5JHK9GKn0fbQsytNUR8VGlbJOMK6aZtM9VtcKCd9
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10714"; a="417798821"
X-IronPort-AV: E=Sophos;i="6.00,285,1681196400"; 
   d="scan'208";a="417798821"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2023 09:19:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10714"; a="846554348"
X-IronPort-AV: E=Sophos;i="6.00,285,1681196400"; 
   d="scan'208";a="846554348"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga001.fm.intel.com with ESMTP; 18 May 2023 09:19:37 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 18 May 2023 09:19:37 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 18 May 2023 09:19:37 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 18 May 2023 09:19:37 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.104)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 18 May 2023 09:19:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iVFoezKIqVXncENaDkLZDcHSRspwfbUJ4rW0puAH+HU+K2T6n+yd7U+Vo7thA8e4AyYfIc3zNJBNHejVvi7WPnRHuDh3XLlXaqr+5DWm9vEkwpoYOAnoDktU5J5iGqUhf5WvN41XhvEwlIh09LCb6wzj/KO9e/vtR4zTBifaVEipdRw300Y4vxqAHiGak1TUizd9mr3E6E/buGtUG0u6Fpi5MVr0DjPL8kpqxwTzTqk1DA1p/4vXIyMUz8GN4E+AiYkjjJVD7Rg/UIysundo/3tbinRmEQDPJOW+gMxMIDnrCOFfMhlgR6sCqUqbxMgN+aB7n+lOkM6KgTn0GS92Aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8Jv6hUJQzwrhTjaexFP4nHtnq1OLicd4Ps0y/Lov84I=;
 b=nkan82qwZDqZ1e4KNlWqIG/k/BBUtAszco7EcW2L7zT4ymlEsc38XBOIF4DvQgFqg9NnWP4wkDn6NoEjj0/gRqqMq552f8XxD0y24SLbi0u5m20YPy66k7M0PZ0AjHFnS4mLYOeBXe6u85ADq5YSLPaNza4bQNCQR4wD7XzuOfC/5xqJDos94KU8OAbiQ91UKPseMGkx3856ZeGxn+tYsRMH/iNsU7VpwO8f+cSL+DMkPv7R0tXBKFNaozMQYZliAsL60G99knLyhHzUcKnpq5pORhQqMAIIK/MesA6nHC3O+sVFhA9E6/bxIi075N3BJ8HS2pPbATyu4jvyKpvvrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4886.namprd11.prod.outlook.com (2603:10b6:510:33::22)
 by DM4PR11MB6503.namprd11.prod.outlook.com (2603:10b6:8:8c::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6387.33; Thu, 18 May 2023 16:19:34 +0000
Received: from PH0PR11MB4886.namprd11.prod.outlook.com
 ([fe80::bc17:d050:e04d:f740]) by PH0PR11MB4886.namprd11.prod.outlook.com
 ([fe80::bc17:d050:e04d:f740%4]) with mapi id 15.20.6411.019; Thu, 18 May 2023
 16:19:34 +0000
Message-ID: <6a900cd7-470a-3611-c88a-9f901c56c97f@intel.com>
Date: Thu, 18 May 2023 09:19:31 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH iwl-next v4 00/15] Introduce Intel IDPF driver
Content-Language: en-US
To: "Michael S. Tsirkin" <mst@redhat.com>, Emil Tantilov
	<emil.s.tantilov@intel.com>
CC: <intel-wired-lan@lists.osuosl.org>, <shannon.nelson@amd.com>,
	<simon.horman@corigine.com>, <leon@kernel.org>, <decot@google.com>,
	<willemb@google.com>, <jesse.brandeburg@intel.com>,
	<anthony.l.nguyen@intel.com>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <netdev@vger.kernel.org>
References: <20230508194326.482-1-emil.s.tantilov@intel.com>
 <20230512023234-mutt-send-email-mst@kernel.org>
From: "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
In-Reply-To: <20230512023234-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0362.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::7) To PH0PR11MB4886.namprd11.prod.outlook.com
 (2603:10b6:510:33::22)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4886:EE_|DM4PR11MB6503:EE_
X-MS-Office365-Filtering-Correlation-Id: efb7e6a8-499d-4b12-86e6-08db57bbab0f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jM6d4c4H6ZaXjl5YPLWtR+8TpL01rgmr5AScHTyG08mrW4CySp0VApHVWggPp7w+ttiZ7BFMkfc6xGVyEBF4zWfFpwZXvlORutdnxFfhS/AW67ocApl36TmTNJ80Z/BL39JDo73/luTkEam+4A+9+0/Xx5Rh1R8uBgNyLMmqwwCkZqO2jfn6OfQgl+1/boNe1NpWAihUEJiNE3RpBPKfm5mF4Yoxpa5QNDnZxX8BJn3L+47o7mE08kfYqVIsi3Q83hgMWjAyGZiNr0v8MDBzqxZ0hZ+r6WtQ0CwHf/mp3/l8f2sAAwnk78nkXH8oe1QxlcqwAgloVz25qYkEH3sW5l63jlDjPa/5I0jx/Q15QdIVXJ2eQa88JzWHytbIlnLygTYHUDrEvJmyN25l+6t0ceo3fUVWqsgZ4fMS7nhom07e6NAsZnwpi8kAY7r1gY9Ulwpa9smYyeDxL3KNopAx+dXfY6PuiIf8ZJBzTBgBFQKBKcVZoKGOoKuItYlWHo25R/G8MSk1EbDPiqu2jLdMY5/GvgLNkAkdhad1CvPRrD1Wdnt0QOJV/bFFEZmFEMQbqIQvyYU7KcAVVnZXe/u2hnFMiX9ADIN02Zh2kbw8vctSvCGAZVnAZ7e6u1XLbgKYsxVP64yvv+AP+yQ5uM+v3vUDK43iZQbQro7MMBVo1rs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(346002)(136003)(396003)(366004)(376002)(451199021)(7416002)(5660300002)(6512007)(6506007)(38100700002)(2616005)(82960400001)(186003)(83380400001)(53546011)(26005)(8936002)(2906002)(41300700001)(8676002)(66476007)(6636002)(478600001)(110136005)(66556008)(66946007)(36756003)(31696002)(6486002)(4326008)(86362001)(316002)(6666004)(966005)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UEUwdTRCWHJqRjZNd2lTK3dZeFYxQmxjVGlRN3JEalduNm5laXo3RENxZXVF?=
 =?utf-8?B?V3ZqTE9FTUFrajdUTDhiZkM3Y0pGR2EyTTVTM2NQdVFESVBWcGVuL3Vhai9R?=
 =?utf-8?B?SG0yd1gvNVpHQjZKQUp0Z3ZuSFRLUDBxbCs4Q3NobG05QXFqVUttbk9nN004?=
 =?utf-8?B?ekUzMHRYanNvbWRzTU5oZnp5TzRUNWVlak0rQWRqWVFsaktiUVpScFNqWmR3?=
 =?utf-8?B?N1pWVjdyZlVCVkdXdGNWcnFyVGd0clNZQ2RQTHYyR2YyMVhFVFVrTTZvOXR2?=
 =?utf-8?B?RWFjU1dIbDNtY2psRElsdmVkckZ0WWFPQ2dIL3F5clpGbXBGNCtMVDVZOUwz?=
 =?utf-8?B?Zlg5cnZXYXJhSGo4bXJNMTdRODU1UEE0ZlBlMW56bTdYb0hmMWorMW1uL3RP?=
 =?utf-8?B?Tit3RVNPQzBWNFZaMTBSelJIQnVWWnp5TjJINEp3Y1hzUlVsYkZuSEZoV2hl?=
 =?utf-8?B?UVYvYjRjYjgyaHdpSWJvOHBaTzBuTWlHM3ZZTXhGbm5VQkM2cnRjTWxxMW9l?=
 =?utf-8?B?NjBDSEhFR2p4enp5VzVpbzV5RlNIUUFvWnF5VXdnODN0RklaanF6cGpPclhj?=
 =?utf-8?B?Q1NnK1JBd3IvOWNrVTJyNTlCT3E0MTA4WTI1TUw3TU9qUVIwd3Mvc0NsNjJG?=
 =?utf-8?B?NDhDU09RRnRWVHZxVS83S1BrNS8zQy8wSVJqN1pUcnNiTGdLYXNNY2ZVdkVK?=
 =?utf-8?B?SkV5NWYzM1N1UWFJVFpuR2VYaStwYnM3YktpNzd2MkNKZzRtZ2x4K1NuR2VR?=
 =?utf-8?B?UXlUd3ZaRTZVSVJ1alp4a05zSkVMS1VoSlcrMzdYMU9aWll0bWE4dGRHV0xr?=
 =?utf-8?B?NVpHMjBHemVOdGxBaWtNc0lkak1MbHd5eEl4NnNQUVB1djBxM3kxYkJ6Ukcr?=
 =?utf-8?B?S0dUYTJEdWZrYWs3dGxOQUFhSmFrczNZeUFwR1YzUE9hTks5SlVmTEkvUm1D?=
 =?utf-8?B?SzF5cTR2LzRwOFVLWTc2aXZWakhZdHREekpvMDdKYUxDTmxlMjBrQmJjQmNG?=
 =?utf-8?B?Q3djdjVramk0cysvK3RSU3QwZVFyL2tPZmEyQjI0UmFXZUVzOGV3N1NCa2hn?=
 =?utf-8?B?bkJ4dXJ5SXk5T2xFUWJwNEc2ZUdneU5RVFh4V3g5Nk1Pa0FIeGdWUUtXSXJt?=
 =?utf-8?B?WmNZaE93TUNzOEE1VnJEZW5NL3Z1L1hkcDU3NDVrYnFUMVQ0ajZJZU9WODlG?=
 =?utf-8?B?bFpCSStyS0ZuM3hQck9lSzY5dWtPeVBCcTNySmh6MEc4YVBBUGNPSXJXV0VB?=
 =?utf-8?B?Wm5SL09NSU9PK21nT2hNckNsWC90V0ZzaEVOeHJET0x1dzVxQmNQeE1KK3BX?=
 =?utf-8?B?ZGNVNDRodVljeUYzMVJ2NCtPVFpZcWludXlsWUw2RUp0UW1mMDdpUWJXMWxm?=
 =?utf-8?B?dmluUEJCQ3pjZjRQZG9yYWIwME9iSktqUjBXWlluY3NLNGtnOUt6Szdkb1I1?=
 =?utf-8?B?cUxzTzJzUlJZa3U1R2ZYR0RrOEFlc0tLUnovY2FneU5nZ0U0WjhDVWZMcGQy?=
 =?utf-8?B?Vm1TNWtEREdGSGlubnAwb1hUNUpzaCs1aVk2RHRUdytTbFllYnh0NHl0Qjlm?=
 =?utf-8?B?cHQ1RjdHUXc5NnpCT2ovY3FZVTF0bGF4bnRaRXl2amx5NGhCRUlQSGJQdnZT?=
 =?utf-8?B?Wmp4YzZ2MXBIY09oZFhJd2lMU0Jya2x4azMvNmhnQWJpOFh2SXhUcHlHdEow?=
 =?utf-8?B?cEt3REVvdjdIVVBtQnlCYUpSSGNpdHpHLzYwaG95bkV5WThLT2QrVkpBYms3?=
 =?utf-8?B?TkNhQ0tIblZEeUZvYmRDZ3czOU41Q3F3MzBaZFJuVHBMOGVUb3VrdVJvSU1s?=
 =?utf-8?B?eStPYzVicXNCRlhZS1NuTjB6NldtSHl6dFhJS1pHUFM1RE0wZ0xIaEo2NWJX?=
 =?utf-8?B?Q2trdWU0ZFhTZnlhVHhhRk0zL09zeWM4Y01aZ0hwVmxiMTJERng1Z0FBNUZZ?=
 =?utf-8?B?YUwzbTMwQnYveDI5Y3FpSHJEL3A5ZVRua2tpaWVhWHZFdjdCcHcrYUt4cVFE?=
 =?utf-8?B?by9jM2xDZHV2SjRNQjZCc0haczI4SFg4OEtoelpuZHhuN2dISTllWEpMbTNm?=
 =?utf-8?B?NlJIL2FKalVFTUZSSXpxMXp2T1hCR3ZKaUVaWndFaHI0SHJRK0t3RHRUdWIx?=
 =?utf-8?B?byt5TE9abE5Qb21rdVpROGxoNWdIcU1pUVZWQjVpajV5M3cvUjVZa3h4M2RP?=
 =?utf-8?B?U2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: efb7e6a8-499d-4b12-86e6-08db57bbab0f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2023 16:19:34.6443
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0Or8aUK728gfW7VzRjgu5K7d4jRHHFNVM9USlGwPdZLN/wX3BBCWlAFbQV2nVjY1BVBTtOW03PwWv+L5Hdz6ibw5Y3qfqAEGb+fKfeeSq60=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6503
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 5/11/2023 11:34 PM, Michael S. Tsirkin wrote:
> On Mon, May 08, 2023 at 12:43:11PM -0700, Emil Tantilov wrote:
>> This patch series introduces the Intel Infrastructure Data Path Function
>> (IDPF) driver. It is used for both physical and virtual functions. Except
>> for some of the device operations the rest of the functionality is the
>> same for both PF and VF. IDPF uses virtchnl version2 opcodes and
>> structures defined in the virtchnl2 header file which helps the driver
>> to learn the capabilities and register offsets from the device
>> Control Plane (CP) instead of assuming the default values.
> 
> So, is this for merge in the next cycle?  Should this be an RFC rather?
> It seems unlikely that the IDPF specification will be finalized by that
> time - how are you going to handle any specification changes?

Yes. we would like this driver to be merged in the next cycle(6.5).
Based on the community feedback on v1 version of the driver, we removed 
all references to OASIS standard and at this time this is an intel 
vendor driver.

Links to v1 and v2 discussion threads
https://lore.kernel.org/netdev/20230329140404.1647925-1-pavan.kumar.linga@intel.com/
https://lore.kernel.org/netdev/20230411011354.2619359-1-pavan.kumar.linga@intel.com/

The v1->v2 change log reflects this update.
v1 --> v2: link [1]
  * removed the OASIS reference in the commit message to make it clear
    that this is an Intel vendor specific driver

Any IDPF specification updates would be handled as part of the changes 
that would be required to make this a common standards driver.

