Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFDC663B2EA
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 21:22:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233421AbiK1UW5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 15:22:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233055AbiK1UWz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 15:22:55 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C80721181F
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 12:22:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669666974; x=1701202974;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dlxTfx3MDuVNYsZHGv42AlenF78/lErzm0wqoM9rw/M=;
  b=El9UVYBAFsco9J/cVDmgTzr5eJJKY9z5qGcYZmhTT1jJR2dKuodY/FY/
   pVegY4dKp+Jyi4iEjQx00DQxHwpPU+Mj1GQZ6ZR37x1Bp6DGVCLK61dns
   BM3x6i1syiRw+o4dxtbya0Ulhgo8Xp+vQfREgoFJ+/kMB+ZBSW/sg1LHU
   5jeEp2r2XC+rjdEJcDUd5z/JhiNZ8ZNi3pmqYo1modroC5FXFkBCnVXE8
   xpUwzvDJUXPOUzRsmFK+ERFQeIXDP7VqPWjc0rusFHDUKqG5bxs8y6rfI
   J0R8c9R5lEGUxuGpaaMaVEenZtLYpkXI28cM0epOa2wp4l2Jax3HWTf1X
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="377087778"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="377087778"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 12:22:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="594003035"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="594003035"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga003.jf.intel.com with ESMTP; 28 Nov 2022 12:22:45 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 12:22:45 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 12:22:45 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 28 Nov 2022 12:22:45 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 28 Nov 2022 12:22:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q3t1hf0Evp/+7RmMltcYrRWpuRjwq1Ud6YKL78tTfjb/IXamIDM0BaOWJXEe34A59PKSF7VRu62B8iI/RrGiPqLKpmQzlegKR1RnsLipvB2b/Z+y0+uw+vjP4kE2Om2fOEr4tgdw4QpUQv5mGenLf56Uer0WPSDDqyzBX9HjmgfGXf0sHpHoKs4DMBs8jBLa6IbcKMPYn3UFzLGcpU2cBSn39DR46EUebFzDfig2ozEN5pCeA6Bnaw1CkIsi+uigWtLCUp2PzH6QCXdi4sh9D41n7VjRuVFT1ZpzTozl6ZWljxR+8QVUXydUZLIzRvD+JPf5DjEoWKpu0ZoUoISWaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zSsZhZROS/k3etjwMWa1ybZ/CTKWTrCz2fomJI9EHeY=;
 b=LkP7g8kyhOtK5N99RUMbV310pvm7LBEiUrLPLrLWqTBrKmbeo9BullB7ouC4cuNu7daOGT1OANm8JvPxt2umysC89VGQ9aIvbHapfwD2o6rWPiQewRfG20Xo6oFAFtyKcCC8G0kRvQXxX1SrpEXeRpNZ0UawAK02ee6wdP1JyeZtPHJQTlv9DZ9x1ms7wu2Ie4CMWp4x0AIn1J5eusvGZCd4qXZswr83O0sdAPBL2YqpOPSQVaHJIsrS/gW0sNc+AJShqNyqORhC+nRF2G9DtvoqOuYPgAUD4rpVjZPP7YHPfPf2wavgQu6zZsiG8VJez9uMrjDFHDAgVzoY/7rQ5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW3PR11MB4764.namprd11.prod.outlook.com (2603:10b6:303:5a::16)
 by IA1PR11MB6123.namprd11.prod.outlook.com (2603:10b6:208:3ed::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Mon, 28 Nov
 2022 20:22:43 +0000
Received: from MW3PR11MB4764.namprd11.prod.outlook.com
 ([fe80::d585:716:9c72:fbab]) by MW3PR11MB4764.namprd11.prod.outlook.com
 ([fe80::d585:716:9c72:fbab%6]) with mapi id 15.20.5857.023; Mon, 28 Nov 2022
 20:22:43 +0000
Message-ID: <3d1d16b8-72c8-ef49-fc58-52bcae2ad42e@intel.com>
Date:   Mon, 28 Nov 2022 12:22:40 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v2 net-next 1/6] ch_ktls: Use memcpy_from_page() instead
 of k[un]map_atomic()
Content-Language: en-US
To:     Ayush Sawal <ayush.sawal@chelsio.com>, <netdev@vger.kernel.org>
CC:     Ira Weiny <ira.weiny@intel.com>,
        "Fabio M . De Francesco" <fmdefrancesco@gmail.com>
References: <20221123205219.31748-1-anirudh.venkataramanan@intel.com>
 <20221123205219.31748-2-anirudh.venkataramanan@intel.com>
 <84b22219-20e1-4b18-cbab-0b77b47f9051@chelsio.com>
From:   Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
In-Reply-To: <84b22219-20e1-4b18-cbab-0b77b47f9051@chelsio.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY3PR05CA0028.namprd05.prod.outlook.com
 (2603:10b6:a03:254::33) To MW3PR11MB4764.namprd11.prod.outlook.com
 (2603:10b6:303:5a::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR11MB4764:EE_|IA1PR11MB6123:EE_
X-MS-Office365-Filtering-Correlation-Id: a5cf6c27-f7f4-4f41-08b8-08dad17e4dd5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9uw9fFbh85TAK+3R9DowplOHMzy1UBd9A76rFBewlxRhvTQn0iMB79eKidn6gij8GBrMkTBaI84OPQHvVcKwMJ/PDPmSIWXqA6JhjVVwxhJ69JKS1+joI0hh3QwSvagcP6NybFD4iJG6Hvi77K9OvHExobBxWZd68NX9vHTN5eCbJSrjQffoHdlWAtEBNJWmpFF0yvagjWZLkhVEI5OWiUs0tofs/EqrDWPW8C0Fhhn3wauF8/unZZ1eYetm53Pt6qWz/iCAyYZ886Mfbj/aUsPwgnbjKKkD+ubxleG5Fe9HRU1fFxr5ek6o+4uEOdOxg44PqPh4jjDzCSkirWLARU0ZRkgCYLArgBue3g+Rjooxf7BF0UAb0OFAJtdGYs/e5MLrTsG4mZatseEWuHMgSSGa9n4Dxhz60eUKxVj2YUbkuVqbWHuWdGwa22yRFo9+tj7C0LNdAg6lLORGQmLi7B2a8bwPTE10tAEB3fDDFP2dykkeMblMaJgOsnOdZWrIoyZj4ceYLTUxHYcf4h5qLOdIIepVLYrEPB+6JYMVAh9Imy+2JwVmglhsffloU5AKGNYU+XX/53hwKICZobwyOYyXq88iuPAxTfZ62cqWllwwosgSs+hKnaPV4q9xci7sR+YXY4xbnOQlYE2Wy/uGT7QOvM3Tb5qT8U3NTtNysC4/4W0jBixLUXUy1Pux+nhCppsgOC3hklD8cQyJcDDet4I2K6Axa4Jr5cxvN7vTBQQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4764.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(346002)(39860400002)(366004)(136003)(451199015)(82960400001)(36756003)(86362001)(31696002)(316002)(54906003)(478600001)(6486002)(2906002)(44832011)(41300700001)(66556008)(66946007)(8676002)(66476007)(8936002)(5660300002)(4326008)(83380400001)(38100700002)(6512007)(6506007)(26005)(53546011)(186003)(2616005)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WTRNTDNaaUxERExhWDJOeW9SK0lIaTc3ekFSd2QyUlN6OWFyRlJzaSsxM05M?=
 =?utf-8?B?QkxCeHh5VTF6eDZDS0tNRldjck9qSnNHWlh3aURpdXFTc29XV1VFbzVabzNs?=
 =?utf-8?B?YldyOUNyOGhnQUkrV3E0d1pLSkM5REVEbklTTXlzajgxQVVWWlR0WFQ4TWI0?=
 =?utf-8?B?eE9CK3ZQVzcvWlBqdCtDRHYySUU0S3hsQnBsSUV5TmQzVUh1bDhJS0xSK2ZT?=
 =?utf-8?B?ZVU0OEp6VmpxZ3VwaWZvd0h3ckNNbUtwOHEvWk03NWZMSjBwS0Z3WVdYMEdV?=
 =?utf-8?B?YjMxTStFaE1zY1BFLzFWMVVvN1BBN3ZMQ2xpZjBDZXFsQUxlOERrd2xXN0ZO?=
 =?utf-8?B?cUNzOFZnN3pkZ0UyZU4xVXR0a0hnYmRjYWJDMXVsUmpMUEpLN0R0VVk5Y0gw?=
 =?utf-8?B?NG02RFVlck0zd3paWVdtNVUwdjBEK0VkN0d2ZzE0V296Mkh5RWs4aVAxbW5K?=
 =?utf-8?B?N25ocnlPN0gxRk55NFl6eVVDYVNZNXA2R29jOUxCV091alVtZzB3eFd5V3Jv?=
 =?utf-8?B?dzUyMmh2SVN3MWhFMDhqSHJ0ZHE4Q1Y5cHhKejg0MGJTcWx0Y0VQeHlUOHpt?=
 =?utf-8?B?V2lWZjZoMVpFQ3BBTnpoYUZnRTdyMU8rd1hnUGVkKzJuZkhTTkhTaTRwTjVv?=
 =?utf-8?B?bzdvT2dUTXd5WUtMbTdZRHlJUGhBd3pkYnBDNjdSTnZlOHhneEZqejhVRFlC?=
 =?utf-8?B?T20vNllRQWsydlVpQ250ZWJnZnRxRmpHazZoZjJFZGlnVTJISVQyWGxWeTVB?=
 =?utf-8?B?d0JTVFUwS3VMNjRCRXBRNTg4QzVjdzFnRVRXSWJqcW03MVdMNm00QndxbUZL?=
 =?utf-8?B?eHZNZFFQSUU2M2I1SXBZUi96bzYrLzNBMXZ0N2w5WDBoVkt1N216WkFCRmFN?=
 =?utf-8?B?WTZEN2I0Q0ZoRkxQVWxCajlnc0t3My9RMVlxeVVCSTRRSkkwUnJHS1RuQUtB?=
 =?utf-8?B?MitSc0xCdGUwQm90SWNhdHNYR0dkM0NpMXJaV0dnOERZa0NPN2FvOUFWemJJ?=
 =?utf-8?B?VHg4V0RYOVpLbGl2TGI4NHdjTjNaL01SUzJFdDFDQXVTNjB3eUM5a0xwUDNn?=
 =?utf-8?B?WjJXZ2JLemMvdlQ0cWVLTHlnVDFzWnljM2c5K0FNYWVYOVVzY3hqS1F5V1lD?=
 =?utf-8?B?YmkybWNwVVE2eXZEUk9KSks3UjZPUXErZkJ6UzdheEhZY3F3S2Q4SDlQbS8x?=
 =?utf-8?B?OWpxb0NHYW5RMGVEbkN6dXhva2xPTFVKUnpFTGRYdkRwVlBHOUVQdE5Tejlm?=
 =?utf-8?B?R3I3SWVndWxDV3h2S0hSM2dkL0pjOExNNEFDbkVpeVNwY0RIbXZxeTZSSnlN?=
 =?utf-8?B?QWplN2tuY3RHcVNvRGtpTmNBNnpQSThJcEtxMEU4VnJxdlFqZU45V0JKeGxB?=
 =?utf-8?B?UGVCb25yN3h0bCtlano4bjhwa21IZkYwTVQ3OHNKSC9CTVZZT08yaGNRcllH?=
 =?utf-8?B?S0lFU1RqbXR2NFNFdUkrc1dwSnhPemM5QVByUFRpVUhlcVdmU3g0Mzc4cy9s?=
 =?utf-8?B?TzYwWWgzbUtaRW1LbWxUMDZ5bS9DSHpUdGx2VmhzQnNkVCthTGhVTFVBYXBq?=
 =?utf-8?B?MHpIbWhQZWNLWVNQTXY1ZEs1VGVmcTlhdEJWKy8vUUJuTUF6b21pZlZ0R0Nm?=
 =?utf-8?B?T1VxNVp1QWVTNTNyTVhtOWxxVWs2cytSbk82NUFqODJ5Q1RaQUo5ZmhKVVlq?=
 =?utf-8?B?dHllVlIxUXJSTFdXczROd0tZOVN0WGx3V1UzNmJ1N0dLQ05RaHlGbEUyUUhG?=
 =?utf-8?B?bXllWDYzZFkzNE8rTS9MQU1YakJNeHNKdVlQTFJxVm4zYjlHTXdLM3paZUI4?=
 =?utf-8?B?MnM4ZkdGaUNhYzRWQk9HU1RnbmQ4Ny9HTXQwSmhuMmVhMWdVTWVLR2M3eFBj?=
 =?utf-8?B?Mm1hSjVoZURPQlZKT1JGMVFJcS9tMmVjWjRlRDJzWTVFek1vSjhkOUpRSmxM?=
 =?utf-8?B?N2NpeDVobHlJeko3bCtrd0w3Ym1RR2VQcHhJMXBPWlVUYVRGcjk0R3BzOExr?=
 =?utf-8?B?eHg3NEpoVXdNRXpkQVJNVjRRQnExbVZGT0NnVmRGOHdpSWx6UzAwSTczMlBa?=
 =?utf-8?B?Qm9DUzZZcFdTaEFCYXhpVncxUStVTUhIRUJaNCs4RytDNUt2MHM4c1lGUFJP?=
 =?utf-8?B?cUQrNHJhd2taM0ZtRkVmQXB0Y25Ed1JJd0J5WnhZSGFjVTc1cTNpQ1VWWFVT?=
 =?utf-8?Q?zhoPqS/FoB3jEc816Mfd32w=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a5cf6c27-f7f4-4f41-08b8-08dad17e4dd5
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4764.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2022 20:22:42.9800
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7w+J4kwYI5wOzogTIuxtSTblcYClcLWIYJGZZdmWX6SC7P9AbkLOqVRoa3p01peAQ00lgkOLFPtZjJ080ZRP9h30xTkOgYlB/PNoPa/rmu8T1MUiOvTLpNOTMIJzmElp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6123
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/24/2022 2:56 AM, Ayush Sawal wrote:
> 
> On 11/24/2022 2:22 AM, Anirudh Venkataramanan wrote:
>> kmap_atomic() is being deprecated in favor of kmap_local_page(). Replace
>> the map-memcpy-unmap usage pattern (done using k[un]map_atomic()) with
>> memcpy_from_page(), which internally uses kmap_local_page() and
>> kunmap_local(). This renders the variables 'data' and 'vaddr' 
>> unnecessary,
>> and so remove these too.
>>
>> Note that kmap_atomic() disables preemption and page-fault processing, 
>> but
>> kmap_local_page() doesn't. When converting uses of kmap_atomic(), one has
>> to check if the code being executed between the map/unmap implicitly
>> depends on page-faults and/or preemption being disabled. If yes, then 
>> code
>> to disable page-faults and/or preemption should also be added for
>> functional correctness. That however doesn't appear to be the case here,
>> so just memcpy_from_page() is used.
>>
>> Also note that the page being mapped is not allocated by the driver, 
>> and so
>> the driver doesn't know if the page is in normal memory. This is the 
>> reason
>> kmap_local_page() is used (via memcpy_from_page()) as opposed to
>> page_address().
>>
>> I don't have hardware, so this change has only been compile tested.
>>
>> Cc: Ayush Sawal <ayush.sawal@chelsio.com>
>> Cc: Ira Weiny <ira.weiny@intel.com>
>> Cc: Fabio M. De Francesco <fmdefrancesco@gmail.com>
>> Suggested-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
>> Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
>> ---
>> v1 -> v2:
>>   Use memcpy_from_page() as suggested by Fabio
>>   Add a "Suggested-by" tag
>>   Rework commit message
>>   Some emails cc'd in v1 are defunct. Drop them. The MAINTAINERS file for
>>   Chelsio drivers likely needs an update
>> ---
> 
> 
> Thanks for the patch.
> 
> Acked-by: Ayush Sawal <ayush.sawal@chelsio.com>

Thanks Ayush.

Please update the maintainers file for Chelsio drivers?

Ani
