Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7A7A5F712F
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 00:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231356AbiJFWfr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 18:35:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbiJFWfn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 18:35:43 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 266149258A
        for <netdev@vger.kernel.org>; Thu,  6 Oct 2022 15:35:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665095742; x=1696631742;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vcnBvxcMzelz8UHDKW1nFgU7j+dqXXX9AhEohmFvlLE=;
  b=f6+39ZwVsLS+oEQTqzznKWArykmzPkgSTJ4Je+etDbP6PBvCAFSEYvXf
   rQbHkauhbuZcmZ16j42coEgS44hqA3g+/ViN1eNLlaNYGONx0tGe+Rkv2
   J607d3LwslHAV0I2YwJjfEW1N6Y5u7GdZJz2r2EacI/NtOtsGdCRolpsN
   rzGYJQC+QW2fLijS8e+VhCuv1aQ/RrxJ7WWvxqZVFwSDyCLpfdUeY4VVd
   x7tOCgzJWFjqRSqLbQ4WCjBvaxWCLbSIEK21JdEh+WrVncDFrKe60Yomi
   AfpLePyNXcjgHeMmiUkfZ3HrqVLNNQkzJGsZxUb2DPZpHQ7THz084Vdch
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10492"; a="304588849"
X-IronPort-AV: E=Sophos;i="5.95,164,1661842800"; 
   d="scan'208";a="304588849"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2022 15:35:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10492"; a="767334860"
X-IronPort-AV: E=Sophos;i="5.95,164,1661842800"; 
   d="scan'208";a="767334860"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga001.fm.intel.com with ESMTP; 06 Oct 2022 15:35:41 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 6 Oct 2022 15:35:41 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 6 Oct 2022 15:35:40 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 6 Oct 2022 15:35:40 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 6 Oct 2022 15:35:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b2jCvPW5/fBHHmQZJ4Oxl2pIwoUDIv/1JSKRKz4ZPHbMf9oekcqf9eiHHM6xSKcf4nHiULXPyEvZdRaEhHDxUhl3RPW2CzxNMY6PxObpFK+wAi2tQPUValN7zFhpgKW/EA6q/z3vtslN9aNpyAdqXRW1kogV/p2dtJKhg1bYVeokhVmBPmtNsyZtZNSxcbQO7U9bsY6vKal1g1oYmn4HrQe7L3nu4BCN7oKWtWriEJNUrAN5CD6rv0fGsVA+FRjBcZfIGzaQIXYI5pJ475NVn57LjsvoiulK//4hs1gveiuuDhEYWUngVioXX+EcUBSwf4D4RB2f/4cooyLMlQ7yVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JREVEXvUQK5M787GuJPbV83JzArLQ9+BIyEWa0OJPMg=;
 b=Op1LaXXZbpe0rPBXi0H7XVzRL5mTwMvmvMa6PGyrK+B/XT5xDginVZiDfzCMMPtjSPKyRbcu24Bq7gHrcL9gDYEX9dKacYOzXgYU7HkAb0aIQJ+trDx3h50ovv73YLH2dyg5n9fN+JKm1V66mnpHXpWhhGegnnKgcz2maJ2GcMqulPQbxLl1yHawn2ohF5kT1RYypzDIRo0M98uQ1qiac8f2BLdnWxvo3ycM8Nw6AAERktgnM5b5MNCL5FdjQ1/PnWpWcUjOpaLzdMZUJr3roaNnXo3peFuiWkRIMsFCmJuokv7NIO8wEgMa8KAQ0GaVskD0eiw0Mg3EzdP4FeXmCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
 by CY5PR11MB6140.namprd11.prod.outlook.com (2603:10b6:930:28::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.31; Thu, 6 Oct
 2022 22:35:38 +0000
Received: from CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::a3c0:b3ec:db67:58d1]) by CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::a3c0:b3ec:db67:58d1%7]) with mapi id 15.20.5676.036; Thu, 6 Oct 2022
 22:35:38 +0000
Message-ID: <3e78ef0a-db8a-0380-0a7a-ca8571513355@intel.com>
Date:   Thu, 6 Oct 2022 15:35:36 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [next-queue v2 2/4] i40e: Record number TXes cleaned during NAPI
Content-Language: en-US
To:     Joe Damato <jdamato@fastly.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
CC:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <kuba@kernel.org>, <davem@davemloft.net>,
        <anthony.l.nguyen@intel.com>
References: <1665004913-25656-1-git-send-email-jdamato@fastly.com>
 <1665004913-25656-3-git-send-email-jdamato@fastly.com>
 <0cdcc8ee-e28d-f3cc-a65a-6c54ee7ee03e@intel.com>
 <20221006003104.GA30279@fastly.com> <20221006010024.GA31170@fastly.com>
 <Yz7SHod/GPxKWmvw@boxer> <481f7799-0f1c-efa3-bf2c-e22961e5f376@intel.com>
 <20221006173248.GA51751@fastly.com>
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
In-Reply-To: <20221006173248.GA51751@fastly.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0065.namprd07.prod.outlook.com
 (2603:10b6:a03:60::42) To CO1PR11MB4914.namprd11.prod.outlook.com
 (2603:10b6:303:90::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB4914:EE_|CY5PR11MB6140:EE_
X-MS-Office365-Filtering-Correlation-Id: 2107cbd6-5ae6-493d-83df-08daa7eb17da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VtHTrpzqO5zgf2n3Y/dVA0bMlxNaJsgk00ABAw9OdDHrhzg2bHIPbn9ACpcfD0c3SbbYnNAwi6zOnqZ2jzppgkufnBS/jX1XjZ/j3NgJEyVt43TdGVwOpjl9CaGMb/xdA6/1XFyA/jJKIOJR5uK4afOsm0uc/kLL44W0YLV6qNZBibhEmH7rh+DIx4XVqAM2zGxNxGb0d/V5MTBGzYGfYs68qTk3bGEuccd+ABAaUN7unQRoliSBdsjn//qX7t2XuEX2O1dY31Gwor8Y7OXVJzLxJwjqhZ0vY+THQQAfm1SSAZSeUhdRBGRjnP8VSItFbOQiVha2V/1Ak8aM+ybmBnewWcbNth7UE18EqbGK8GGqe029w2ZRp+bI98FUas/9L8GeVkfYsqaMHHLeYiwu63TrVsjIEjJOSTEdfmMntnkPPjZbv1xnFSfr1FfKPzKaRtrQW7Cg80LZcyrFBHOHFXFZA3tQ+YRP8vjCcSLt9f0R6d3g+lzgwGCZJZdDqDFq0vfZHC0Zwb8arG955tdEa+l1HCc98MoMBquIm3+f+vuFqY/Z96tkc9b2DgSjqb3UekqXUM0THTBvtmGW6GvwIJ/OhS9mR4HChl5m6SyopEHmybgLmTnd86mi2iqvIPNYU6S50/UqvOfNmCgrL2rcQFCaKuxYy0Lcky+DibYJodlWdS2hAmndSjFSIZYIonAznA9MVcPFVdzb6MIQiMpcW61AFr0cZ93tdXY0w9jdeojgR3aYmvd7oOt6zcVqw5e+QGqC4dCf0oCtvNvGB6nD38Mn37WkGwTIUcCqdeR3pYA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(376002)(346002)(396003)(39860400002)(451199015)(38100700002)(6486002)(36756003)(8676002)(110136005)(316002)(6636002)(186003)(83380400001)(2616005)(6506007)(53546011)(6512007)(107886003)(478600001)(26005)(82960400001)(86362001)(41300700001)(66556008)(8936002)(66476007)(66946007)(2906002)(4326008)(44832011)(31696002)(5660300002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UExOaEl2UXRrS0VjTmhGWThKcXRQN2daQ1hWWm53dXNjL0xiOFEybEtsQ3FL?=
 =?utf-8?B?ZnpyRHlFajE0UElvak85MDRYdk52QkIxK2Q0KytiU1BpdERtSEN2ekNkVDVW?=
 =?utf-8?B?b3ZrQWxwTWk2a0V6ZVRaVThtUHNRbjhWTkNiMXlqb2U2OWk3eDVyL29yR1dp?=
 =?utf-8?B?UHNRNTlDU0JoZTVONmNJZ2NpK2NKcW90YXdSdFdTZEYyclZ3OGpuUnFWTVht?=
 =?utf-8?B?NWIzUUN0cHVxU3FQZGZBNnNJdXdsKzJTelBRWkZjNGZrYmF2bElSWndxV1Z6?=
 =?utf-8?B?cmdRMm45KzhnZlJhNFF2b3JSTE55QVRSN3h3OStWSDJDbFlDTHpPMGIramtE?=
 =?utf-8?B?STN2eGpleHhJWndKZm9XeUpnMXk4UnNBTzByaXFHaUt0L3JEUmVFZDlaT1dt?=
 =?utf-8?B?dFFBSk8vUlFKd2MzUCtXOU5NU21WcXJKdUlzK0dZQjNaK1JibGcwUFVnV2cx?=
 =?utf-8?B?aERPZzVqWm9EMVJhVmtFMDltejliZ0pTQUI4T2dNejhid2d2cmdjU0FORy9r?=
 =?utf-8?B?QjVuRkZFWDZjSFdhdmxlRnZvVHBXeGtYbGZLSG4veWZlWmlhQkxsN3Vvd2hM?=
 =?utf-8?B?K2dGdDkxdVFwazNRWlpJWVRnSFpmdko4M2RRcndmZHQ0UGs5YW85SDlnV0VN?=
 =?utf-8?B?czFGTmwrYU1wWEJ2d1pQV2IzVW1ZbTJKeGhVSkVWOGU1U09PSDFBMGsxSXlE?=
 =?utf-8?B?dVNwTkZtL055K0NsVHBHM2p3d3NJbFo3MXNKcVdrYk8wdElXQU9CL3FzbW5N?=
 =?utf-8?B?WXFWMXZUSWFLUFltYTJMbzFWUkhCVFB3TGlXSVVONFU2NjdoalFHRVh5WEww?=
 =?utf-8?B?cDdVcDNKTWJvUEVzWmhidUNqZWowZlZHVHZ6a3JuMlByMDhDNm15ZmJxRE9i?=
 =?utf-8?B?eGw4RjB0NlQ2elNRK3NIZ1YwMjN2U3Vid1dNZUlmM2E5YVpWY2N1K2l0ZWJS?=
 =?utf-8?B?QktvZGhHL210YmVMaUc5UFhRaWhBWXFSVzQyMjU5bGtXRWxiNVR6ZUNPeE9J?=
 =?utf-8?B?VVB1QW8rWlB6UDg1UUdTVitMM3JZZ2lBUUc5Y1ZFTmNTaFgwMFNUMGhQVnVN?=
 =?utf-8?B?VXBsVU83cThhSUpxUlZ6VU90WGVuUGYvaDBMZWNjOHVNWUdjZEpNdTRKOE5i?=
 =?utf-8?B?VnhFMnFSNURoNG1kbXQrUFdEdS8zdmZtaGVTRDRueHB6dlBhWThUa3ZpcEh5?=
 =?utf-8?B?NWkyQmgrU3hQTGFETGVQK0VacFVsT2J6b05nNjhKTWdISGRKV01nd3Bib1pF?=
 =?utf-8?B?VUFYZm03aG9LTkM1WDQxWDdQTXpURmRpZVVoVWYwKzNSQmJUeE1BRUlrbkVp?=
 =?utf-8?B?NlloRlp6VjlUelljeGcrVXg1dXF1WTY0SWh6RUhUUVpQUVhpczdYdVIzRGZD?=
 =?utf-8?B?YSs2SkFIYXpMK0NrNXIzdFpta1Y2cGZvZURUZXJjMjFydHVBU21kcDFlQmd2?=
 =?utf-8?B?UHhIeUxCZXdCenFIenpDYVZZSFFwNGhOa2JyTUJhQTFWUWFSdFhDWVJHYXYz?=
 =?utf-8?B?Sml4dVcrdWlUZHZpeE8rWXlzZTIzMVltN3FrVy9xVW8yS0dZaVpXZVdXR29v?=
 =?utf-8?B?M3p6VWViSUZ6d25HeGVud1VRYVRkc1N4bThWaFJpRjFoZGVoVmtKSUdiZnhZ?=
 =?utf-8?B?TG92K29HNTFaWU5uUnNhb3kycHdsdFU1NGxzd0RiOExvYlBYNVFJV0VLTVFt?=
 =?utf-8?B?b3NqblIrZ1U1OVA2M0UrV3NQYy9CUFFkUHJsUmhwVmlQU3NPK09ZY0hPNlJ5?=
 =?utf-8?B?eEtXVzRzWHlOL1NIVkR0YS9wSmR6Rkx6UjJPQ2JkcWp1Qkx6Ym1oWFIveUh0?=
 =?utf-8?B?NWtvR2JsUE5DejVMT2ErYlM3emJCTXBEeTRmdm1hbU8xVmpZcEhzcjdxMWU1?=
 =?utf-8?B?aWt4aUhsME5SZzZjU3V1dDlrRTB3aTBkNlZrd2QvNmJWVzRTVjMzeXkvSEVR?=
 =?utf-8?B?NVdNZnBNSkdmbHVvN2pRaXBraGwyMVZYLzNPY0dyeW1RTnR2RGJZUFlySTlX?=
 =?utf-8?B?MlNicFNEYnNrUWxuMFdUSDl5M0Vid3JlRHRuUnRDTVp6S0dlTG5ZcmxtaGpC?=
 =?utf-8?B?UUNuR2Y4c1ZaZkp3eTV2Wm45cm9EZ3V5N2t3RWw4R3huRCt0RisvZ0xJWlZ0?=
 =?utf-8?B?cXRPSGtyMjdqcnlLV3hNcmZ2bHlBZXJPMXc3NS9wQTQ0b0JBMFFvek45L202?=
 =?utf-8?B?ZUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2107cbd6-5ae6-493d-83df-08daa7eb17da
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2022 22:35:38.6945
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wKBOwgX2XyNvmU3VpyXIJQet3kTsWny7wXqVmEJvQ/M3OW6+5rXKKmAe0xukMVJI2QMXEv2wFUHlQEiynzQb9UL9qw6PdFOJH//TmizFRLs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6140
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/6/2022 10:32 AM, Joe Damato wrote:
> Sorry, but I don't see the value in the second param. NAPI decides what to
> do based on nb_pkts. That's the only parameter that matters for the purpose
> of NAPI going into poll mode or not, right?
> 
> If so: I don't see any reason why a second parameter is necessary.

Sridhar and I talked about this offline. We agree now that you can just 
proceed with the single parameter.

> 
> As I mentioned earlier: if it's just that the name of the parameter isn't
> right (e.g., you want it to be 'tx_processed' instead of 'tx_cleaned') then
> that's an easy fix; I'll just change the name.

I think the name change isn't necessary, since we're not going to extend 
this patch with full XDP events printed (see below)

> 
> It doesn't seem helpful to have xsk_frames as an out parameter for
> i40e_napi_poll tracepoint; that value is not used to determine anything
> about i40e's NAPI.
> 
>> I am not completely clear on the reasoning behind setting clean_complete
>> based on number of packets transmitted in case of XDP.
>>>
>>>> That might reduce the complexity a bit, and will probably still be pretty
>>>> useful for people tuning their non-XDP workloads.
>>
>> This option is fine too.
> 
> I'll give Jesse a chance to weigh in before I proceed with spinning a v3.

I'm ok with the patch you have now, that shows nb_pkts because it's the 
input to the polling decision. We can add the detail about XDP transmits 
cleaned in a later series or patch that is by someone who wants the XDP 
details in the napi poll context.

