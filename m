Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6B2B620B4D
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 09:36:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233567AbiKHIgP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 03:36:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233453AbiKHIgM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 03:36:12 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5812F62C3
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 00:36:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667896571; x=1699432571;
  h=message-id:date:subject:from:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=aTsSITSQIyr4mhWXxPkG6h30maY9QipIrLjHWZwC/PA=;
  b=aC12TLHWoCbYmMSsXUODL2yiepsggINELN1I+c7GwAmwBHz2Wy6lBVP5
   c+K6A+53ySzUuUMnOfD5qJUYZezdXGSn1CB9Pyvc5dgDT1EfFkBGosjSN
   9itF72ZJ+c7x9jSJPAl/kb5mBccH2Ip2D8+UyciZoBGMKXW2vYKzkqKh/
   Pr8dLAysvjUcLBppNHIb9VVF9EDRHyw5w0RwhNo/OjxFvsRQLh28ixG0y
   PHoeqTqtb0+1ra4Cp4YmcKYY8CrsFegUHX7EvaYSZBNNn5Sg6Uc3V7ckb
   0/kfl6TfDHeoEfXus5e4pnFMemYBsjCbVtzqeWfRtgoPMVM4IH7OOVvgY
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="290360699"
X-IronPort-AV: E=Sophos;i="5.96,147,1665471600"; 
   d="scan'208";a="290360699"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2022 00:36:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="636257743"
X-IronPort-AV: E=Sophos;i="5.96,147,1665471600"; 
   d="scan'208";a="636257743"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga002.jf.intel.com with ESMTP; 08 Nov 2022 00:36:10 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 8 Nov 2022 00:36:10 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 8 Nov 2022 00:36:10 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 8 Nov 2022 00:36:10 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.172)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 8 Nov 2022 00:36:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OKGAIvJpmAP98VDZuwdLtIctQqunU0Vr91g7tEYYkZ8XxhV0NT7Cp371ylN3yTertZdbVwyWixXessmxw7kBqhZ7p45JSxeg51o2pkViVeu5wK89o8meGbUUQWBS56aW6CXx5RrGa07NwZJWEmBLZqWD646eb04JzFS/LSCw/F6vl4g59iKR7fgYnSzUqDXDIxCK5riPe3UKA0NThDdxvrQEaiDZy9FUjrbrYnWgrXVvkGo96Cq9aAc2YT+Gzp77wbzxH43ouusPsaib9BslwDDBzuOu9cz9591o+xIZEcwXx1BcGovIKISkV06kfYC0pN0hFgRHMyEiKWJweELjow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aTsSITSQIyr4mhWXxPkG6h30maY9QipIrLjHWZwC/PA=;
 b=E5no0dZ2SbA17s46K3/7LB3lTEjhW9cu7RTKEPLHgmwTwrffuQFdta1Egu6VOvOTwZDnbQ5FeeBRbMylNL2lMQbF91vSpHwlzCr7Uoq9cgdVaMfFFRBBBs82N4zURHbOPlrGUgxTfJsTSQFfzKd8uTe17wQT9Iu9YjjF/4OBojaKWlfUScmZTeanTwa3RlWMsNVJckJ4F1ZjK2wYxozOVvMY8+9aAJJ/r+o33XqM+wGeBA+oyCi2QVRcQ8YWTtkdEShYy8S3vk15zmScRN5CQSykVHhU9k77I6pSD2Kx/kRS5sZfCZ3eXVGyhnoxCxgPJ5xHCalvpyuwQTORbdt22A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO6PR11MB5603.namprd11.prod.outlook.com (2603:10b6:5:35c::12)
 by CH0PR11MB5539.namprd11.prod.outlook.com (2603:10b6:610:d6::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Tue, 8 Nov
 2022 08:36:08 +0000
Received: from CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::712e:208e:f167:1634]) by CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::712e:208e:f167:1634%8]) with mapi id 15.20.5791.027; Tue, 8 Nov 2022
 08:36:08 +0000
Message-ID: <8d4faf31-ea3a-97ba-9a0b-394705dba617@intel.com>
Date:   Tue, 8 Nov 2022 09:36:01 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next v9 0/9] Implement devlink-rate API and extend it
Content-Language: en-US
From:   "Wilczynski, Michal" <michal.wilczynski@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <alexandr.lobakin@intel.com>,
        <jacob.e.keller@intel.com>, <jesse.brandeburg@intel.com>,
        <przemyslaw.kitszel@intel.com>, <anthony.l.nguyen@intel.com>,
        <ecree.xilinx@gmail.com>, <jiri@resnulli.us>
References: <20221104143102.1120076-1-michal.wilczynski@intel.com>
 <20221104190533.266e2926@kernel.org>
 <561f25bc-40dc-78c7-0a2c-e7e0fe74ebde@intel.com>
 <20221107103145.585558e2@kernel.org>
 <f0075083-8a11-a2f4-a927-7cd5f255bde4@intel.com>
In-Reply-To: <f0075083-8a11-a2f4-a927-7cd5f255bde4@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0104.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a1::20) To CO6PR11MB5603.namprd11.prod.outlook.com
 (2603:10b6:5:35c::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR11MB5603:EE_|CH0PR11MB5539:EE_
X-MS-Office365-Filtering-Correlation-Id: 28018d99-19ee-41a8-0733-08dac1644838
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BqOCw/6M2EXWkABGazjvvpVVWuyeTk96uJjmbfDfsslRbSuvpzDqiWEc4KQfJzNjOra3BrGR+FrR6C7C3f8Cli/af1tvfVPO/Yq9jazw4xTU3lucqz7HB+sZ+wRngABS2PK2uMsmtpSZ4OIZfPvgUF2NG9D0F9GAhmGU0BWE5yTvsWaHBN2Tw4s/mMy46KtJoCGYe5le/Huh30KdlDlN+dwABvoF0NcrnF5lKt1r5r26DphrVfjR3KRLS4qwPITaylLq0eZp4/nP8HgNsDHuiUF5j/dY7IpwMHrG3W/0ZeeGP0jwJ18HVQy9b6ZTMpcQ4ev1JaZl9+zqGJ2pbpTUOD+OrFrKC1DfV9dNnjNyKnPXHJ3MezBiBk9hQ3wtPuuIabVVuY4v0KakhSRaLHpEeYoX3kC/CqxKeVFChmJnW0m7h6eqQl+Ia/OILI0ZNC5EKP438g9ayfBCQcaey3kjZAVNiVvW8V5DJRyUHGbY+455qoXVND+DN6h1EONcZMYR/coB311o4Xh1zs/nBiLoJ+KfZtlujksxh8J5Z6PeemPs2fNbBRd68XvMELFs+HEDyUeCdbhto+N6u1NwYclVJ6h3AtEmVpehLLZC4IYpR9VmPFsM/QKq2sFY9S++2dfQQLVhRz2Nx+CEd8o4S8T9kG0VJZ+5MBxjH22KeMk9GeFM9kXKBu1F2cy4RHhb/mlhCIfw2zggzBKrlmzUKv8KC+qsVvpWuVAIvy8IxvsSeEvO/ULneLF+xbXBo5Keq2u6qUmyhAl6CvwMbcv+d97ym9HhTHjch5wufyia0A/DDy4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(376002)(366004)(346002)(136003)(451199015)(83380400001)(86362001)(31696002)(38100700002)(478600001)(6486002)(8936002)(5660300002)(66476007)(66946007)(66556008)(41300700001)(8676002)(4326008)(186003)(316002)(6916009)(2616005)(6512007)(26005)(6666004)(2906002)(6506007)(53546011)(82960400001)(36756003)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TVArVzlVMHZQT2t2MWtkZFl2NzZycURuc2F5VFhVTktXb1FzUVdLZytNeGtl?=
 =?utf-8?B?bk11WE1QbVVvS2Q1cHVvRkc4dWUxc01QcGV1V0RiTTIwUzV1eEFSUWRCc2FZ?=
 =?utf-8?B?OEttWWM4UVcxR1FmU25WVlFubEZoYVpZZ2MrazJjczl2RlNxUVBteTdFWUYx?=
 =?utf-8?B?MkF3TmxicFhCblgzeW5WNURneFA3dU1zZFJyRnRRQmptUUwvaXorbTNQTFl4?=
 =?utf-8?B?akJlV1B5MGlEcjJGN3ZCRG03ZHg0Uy94WHZPTmFOZkc1WEhMNGh6NG5GcDJJ?=
 =?utf-8?B?V2dSbFBhL2RLbEJtb1BmcEFZb2hVV294RUZnai84R1dDaXJjK2twRzErYk1V?=
 =?utf-8?B?Yzl3SGhPVUtHNng4NGJsQTg0cVZ0VWI2bzFDUTNHeVloaDdWRlBSazNwVFFv?=
 =?utf-8?B?Q0ZjeGVXRE9SdytDRmh4dnFXdXBWUXZ1dytYRWhDYXBVSGVIb2JmdTh3TGpY?=
 =?utf-8?B?bHZ2RHAybFdNNWhnVWMzQkw0VzVLWkpvS2hkZGJYbDZoOS9BaEkwWU5DK2FE?=
 =?utf-8?B?ajU4UldoV3dHcTZCbFpmZUplMUc4dHo5VENaSmNFTzBPUkk2ZGVidnh6SDZu?=
 =?utf-8?B?cjYzZG9PVnhSaklaemxuYXovUkFYdi9weldhdVAxMHBPUDk4cm1xUjVTaUhr?=
 =?utf-8?B?S3NwWFBaOW5FcFcvNU16MGJhbjNhWWFmT1lJeGlRWFRZbEg2K1BCMU1CWUVC?=
 =?utf-8?B?U3Q1cWdrbkpuR212eWM3cE1DS25iNisxSGZibjZ0MzJ5em16M3oyVGtSTWtr?=
 =?utf-8?B?R2FYTmZmc01zZ3RPcHh5UEtvRkVwYlk1WFVycTFIalNPaG1FQmJ5VXpxU01T?=
 =?utf-8?B?VjlyVUJIVnBBa2lHVVluT0ZoRTVheFQzVjc4Y2ZaSXR3YWhVR1oxcGRZdXNI?=
 =?utf-8?B?WWxnSFVJS3BVWldCaUZVazJGRk5ucldnUnZMWmVrM2JORDNVbUJjQnB6bmIz?=
 =?utf-8?B?SXVaMm9zU0gyYjBrTUVNSDRoQ0Z3ekpSMlBiNjBBSktTMFNyZHlDbnY2VEVP?=
 =?utf-8?B?SU1FSHZtYTU1YXZWNXArZzNOK0NmdmJVR2FoRGR5ZkRzNlpXa0tUN29FYU5T?=
 =?utf-8?B?ZVgrSkJrWDc2Q2VpWCtmck5ycGw5Mis1U0xsVHZTS0IvaHRIUUZoRm5Qbk9r?=
 =?utf-8?B?SnlRVVE1Q0NYNGVIc01QNkdsTkp4MzBuUWNZdEJUWlA1OTJ6R3V3dUVPc1pX?=
 =?utf-8?B?MWV6UFNreGxMamgzamVWa3JoYjZZZVUvemNIWTNMbTVUQWg2dzNrZnZQSUtm?=
 =?utf-8?B?VnVmLzlna251S0ZTSUtNdVR5K2dNYmp3cUIwVVJidjFCblhjRk5KWjIrM3c4?=
 =?utf-8?B?Y3VYZXJHZ01SbkZwWkpYWUZXMUxJZmYyQkpvNXBiZkwyUU9jY01sdmJoU2pM?=
 =?utf-8?B?QU5WQVdPZUhoTnZLb29vckZvSWFHQXRBRlZqODBLUlJReUFRcmZaK1JYMm9u?=
 =?utf-8?B?M3M0bzFKL2VhNlNPc3RxbWdlWDdtek1JYzFobGdtbDUxVWlUZ1UvcGNZZkFw?=
 =?utf-8?B?aU8wNDMyVFBlWFg5cjU5Z1ZwVXpNK09BZXJWYXZFNEt5VE4va0w3dEtTVUJq?=
 =?utf-8?B?SmwvOW51SHJBR0hNcmwyK1BxQmVHaWp4WFJ3bGFPOTlpTi9ZdlFhZWdlTkd2?=
 =?utf-8?B?Ly9zZVM1SzVLUDdwQ0hjV0ZSN0tjVmlta0cxYTlEY1ZlRTd5WnVIN3UvTDA1?=
 =?utf-8?B?d3hkMTN3MGFlcTdhVHozQXJUaW1RWlZrZks3cGd1dFNkcUFSWGF4bThJTUlT?=
 =?utf-8?B?cTBmT3pMdHA5RUxXOUlWbzllU1BIdTRMb3hXQ2c1eEc5SjBKNVF2dlZQNEJh?=
 =?utf-8?B?LzNqNTBRMXNlRWpSb09aVXVYZjNYM01ieHdlL1ZSZU5mV2c0aDY5enNjUGJv?=
 =?utf-8?B?RGZDMDUxQXo1QlFFRzc2ek9mU1FYb3F3cGF6R0QyNmRidUN3ZTdTWm1zSWFY?=
 =?utf-8?B?L3JBRkJZUlR4UDN3b2c3WkxwWEQ0dyt4MUMvL1NsdlVNdTJ4SG05L081M210?=
 =?utf-8?B?TlJ4MzVxdDVVOEI3MittN3Q3emttK3hvL2c5aXA1bXB2ZE0xTFJ3V1RTa2lB?=
 =?utf-8?B?TjVJMENuTUNJa2szaWdQTmlwcWY3MVpoWExiVmpGcWVZUUlKYlNsY0MzUlVG?=
 =?utf-8?B?VXNxb0dTR0M5RWl0Qko5Rnowb0NzNVhLUTYweGR4OW4yWWZzQnljdHVYMGR6?=
 =?utf-8?B?RVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 28018d99-19ee-41a8-0733-08dac1644838
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2022 08:36:08.1055
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hKStQgzDqB3GKSJHcJHnO++Dnmz2Y95NZfWfW4iL7x8iVGJoAVK+p9QS+AcPyc6IFF3R0PMRx9y9MTne1zYss0zz7s+0DwW4CEbEngC4kvk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5539
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/8/2022 9:08 AM, Wilczynski, Michal wrote:
>
>
> On 11/7/2022 7:31 PM, Jakub Kicinski wrote:
>> On Mon, 7 Nov 2022 19:18:10 +0100 Wilczynski, Michal wrote:
>>> I provided some documentation in v10 in ice.rst file.
>>> Unfortunately there is no devlink-rate.rst as far as I can
>>> tell and at some point we even discussed adding this with Edward,
>>> but honestly I think this could be added in a separate patch
>>> series to not unnecessarily prolong merging this.
>> You can't reply to email and then immediately post a new version :/
>> How am I supposed to have a conversation with you? Extremely annoying.
>
> I'm sorry if you find this annoying, however I can't see any harm here ?
> I fixed some legit issues that you've pointed in v9, wrote some
> documentation and basically said, "I wrote some documentation in
> the next patchset, is it enough ?". I think it's better to get feedback
> for smaller commits faster, this way I send the updated patchset
> quickly.
>
>>
>> I'm tossing v10 from patchwork, and v11 better come with the docs :/
>
> I will however create a new devlink-rate.rst file if you insist.
>
> BR,
> Michał

There is however a mention about rate-object management in
devlink-port.rst. Would it be okay to extend devlink-por.rstt with new
attributes tx_priority, tx_weight instead of creating a new
devlink-rate.rst ?

BR,
Michał

>
>

