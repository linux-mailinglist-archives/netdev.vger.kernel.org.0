Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDFA5643511
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 20:58:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232724AbiLET6T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 14:58:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233268AbiLET5x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 14:57:53 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4088230A
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 11:57:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670270253; x=1701806253;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9p+Q2bICtJ1ys6GJNes7Wfe1eOnM3E3vc0jltKeRlWc=;
  b=YeFLmNGkGPGiV6FsWAw7M0QOBv+Af0Dm3YytL8ojuvxTBgqCCAXb5uVL
   c+m71c7TosNpDuad4QN2Uw5xE/OCM7RK8sQbUE0i4LDVTqwyjDfEoXzIm
   duJRNJ/JX47Mzxf0z+AuoKBQ39yUhCsuNRSh8bjvf+JUivMbqsTJfEfum
   PiAT2gGk3HUiCCpFeDD28R5JO3KeYm2j6KHKUlRqfTYrQ4i+TYq9aafk/
   sSlm3yqthXb7r+0BXM3mfT36JH9DB+vYBw4RwQ+tav6+BPVXHu1v9SZme
   vvwINuLcwjmbRvJ/st9kyxrkxQ3tJLYZ+rUnhtd+6tHm90YWpIpmaSYC5
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10552"; a="315155730"
X-IronPort-AV: E=Sophos;i="5.96,220,1665471600"; 
   d="scan'208";a="315155730"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2022 11:57:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10552"; a="734722655"
X-IronPort-AV: E=Sophos;i="5.96,220,1665471600"; 
   d="scan'208";a="734722655"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by FMSMGA003.fm.intel.com with ESMTP; 05 Dec 2022 11:57:32 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 5 Dec 2022 11:57:32 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 5 Dec 2022 11:57:32 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 5 Dec 2022 11:57:32 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.108)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 5 Dec 2022 11:57:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mUxsE1fQZ0IXzJrl3j+mp8K6nozIskgQ7C8PQPQ2DvP6W5nYQnIzXruDoJCp6PCDxNLD4KkkGh6+n7mZBZ7V2aZkQH5y44tzbEu+9VxiMSw6Gmn6qsD/WCdfHabAuHFznLnwG7jL6Nh2mZRQCCnzZ+7o2J9rWiUrDBJhQWgE9dp/aIxZfb1A8/8Twh41k0C9u7kUY8Q96MODYxF2FygxMkncGZ3h0OPLFXkrMQI9EzcBh+MD9awNBgP8ztrikKy4eop9Kpk1Vf4xUyO/o3a/DW41oggjbymcWQGa3m8X7nqQ1EeIBn0KWu4K9PWG6ZPJZuEwiJl5qmKOkV2exXTKzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mrdB/BJ7I55QMjjDY228RstrmFbxJYcunEkw2w+AlXU=;
 b=iMPtB0ZAi1ba/MGDmZrvlZGqA8dUBwsZ8qKDk1uei5G8oCb6oEe2GYbZ3zitFe7k8GWdCMxSDOyj8isZzX2LjH7+P/WPv4CcCvapWC+pXwP93/u/WM6mJgb9Ygjrh+ajeEZ90N5gvCIvEELrxO5Lr720Qh+MQIysylqBxztjCPOY4XMgnppAmnrV82Ws/4jNH6jgDdvmapYLeQuNa67k4cqQ1oifAvJEFRN+O0ag2DBsQpTYkQ9SKXb6qsj+W9DgjQfheZGwc2KR1hHeGUEbdxI8FbtHGtM0Meacb++wbGrVjKywGN7dhR3A9ZtRB4RGj4fq8VjQgGTD7ysP4YSmxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by SN7PR11MB6728.namprd11.prod.outlook.com (2603:10b6:806:264::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.11; Mon, 5 Dec
 2022 19:57:30 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3%4]) with mapi id 15.20.5880.013; Mon, 5 Dec 2022
 19:57:30 +0000
Message-ID: <05b266b6-0be2-3326-2877-d26e1bd60fdf@intel.com>
Date:   Mon, 5 Dec 2022 11:57:28 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH net-next 08/14] ice: protect init and calibrating fields
 with spinlock
To:     Leon Romanovsky <leon@kernel.org>
CC:     Tony Nguyen <anthony.l.nguyen@intel.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@google.com>,
        <netdev@vger.kernel.org>, <richardcochran@gmail.com>,
        Gurucharan G <gurucharanx.g@intel.com>
References: <20221130194330.3257836-1-anthony.l.nguyen@intel.com>
 <20221130194330.3257836-9-anthony.l.nguyen@intel.com>
 <Y4hxen0fOSVnXWbf@unreal> <ba949af0-7de6-ab12-6501-46a5af06001f@intel.com>
 <bb5d4351-af35-e40f-5c2c-031c83dd82c4@intel.com> <Y4yg/91T+r4+XdSd@unreal>
Content-Language: en-US
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <Y4yg/91T+r4+XdSd@unreal>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR11CA0103.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::44) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|SN7PR11MB6728:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ea2074f-b91f-4bc4-7f4c-08dad6faf112
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: czZi0oVsWUU9MT591sQ7z91elRzUISIoj4axZ+z/O6y1fMWMgH0tE3M5oXVxO6ILFxCO4HxLv/ririIrVjp5kLcDMJVBw1ckEYXWjK8J6yiA2mbsTlNp8bCqHzU4v2t2QsyUpikrbgfKIYu1hv+QrWmq//c5FTFJnVXrIXlLSYhH+DRFBJHozUvDz+FCISS2KvR0bui6Jk6RiBduD924hHa6ee8BiH0oIYwTnlb3fFNKJNZqX+WGkr3ivodLI4T2q2o4Ru3ZUB0ncWlkTvEH1B+VmNE0hBlwIm6cHAgRKfubmcakc2u80obpfTlvZs+WVLMUgV1U+MZbN6HLJ1IfPrtsmyknP4/68+739A0oZl9D7r+2mD4l6rYNS3oHsAWWdBAahcDTGAQ3/Cs7ki3UVrHnQREz+3zv/Sv9/8JIb2qn0geqBwsdYMXd9kYpiJTDsVuqMz1e96zALPYZBd9XdeGzDBV63XX2Snm+jcAh8/2S6Ks5aAIhrDQwpP62mvSr27Tqv0+0e1k1EsdCVd+7J9WZQCSNcdATpGBlfhpysv8PZ3DSAglM89FbSiH2Vk6hxLCUd+D31QAa0hnxwZgdTH8p6R1pRo8eKmaErvknaEQT1hbyPaamwsui3Fbv82mAyp36U6m0vs54x4cQeN8I4xruABXd3l+mamjSS8bkKFOmYPptALVX4fmUNjXy9OGdPfcpjeofMJW1zMRdOBKtHPt5SgTSvHFlFF/mB39gadM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(376002)(366004)(396003)(346002)(136003)(451199015)(31686004)(36756003)(83380400001)(66556008)(31696002)(86362001)(66476007)(316002)(66946007)(6512007)(6916009)(38100700002)(82960400001)(6486002)(53546011)(54906003)(26005)(107886003)(6506007)(478600001)(8676002)(5660300002)(41300700001)(8936002)(2616005)(186003)(2906002)(4326008)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Ym9NbEdaY3AybDZKdjlpMlRZL0xoc1ovMDdLRHVuMVEyazRzbWtaa3Y4MGhD?=
 =?utf-8?B?STZJOE15ZDVVcTRPa0t2UUxxeWlyVVk3dmJSeENQbGRhM1d0VzVocmRtMHdV?=
 =?utf-8?B?M3FqU01Jb001c3k5TktUTGdqN1MyeFpPYlByWllPdkt0djhVWWxQTFRxWXYx?=
 =?utf-8?B?b2JZYjBUV2dIQ0M4T2FjdG55eTYwaTg5VXpYK3NJTGpZNnN1WTFZM244d3I4?=
 =?utf-8?B?Zi8rWjIyei9jY1dKYmt6SWdWdGFmUVNwNkI0b3NnRzM4WkhGUzJlSVRxbnFD?=
 =?utf-8?B?aGd1RWlUU0k4RU1nWDJoNytvbTViWS9VMk1ySER3QUxOdjY0ZHNaT2lkSTBT?=
 =?utf-8?B?SEJGZHUyQm1XOE4xcUEzL2xpeVJtcDYwaWw4UVk4VlJsNGFMY28rMlNrenMx?=
 =?utf-8?B?eUgzNVpxTXdab05oaEZEY3hacVA0ck1ibjR3L2VJQnU4ZjBhUmJpeFg3Wm1i?=
 =?utf-8?B?VlQvbzdaZGVtQW9KS3VxYXRsYzJsRTQ1cGlmeGJFdTdBdXBKRmJMSStLQkRN?=
 =?utf-8?B?NzIveWVBclVMOEhneUtQQWZFSExPcHBrNXpKeHhYQjZZNytyL1FKeVM0UmN2?=
 =?utf-8?B?NzNEb3l3b1AxV1ZueTQvTWJuUUpBQVFpM0I2Si8yQjBnTStCbFNiVGkvamlY?=
 =?utf-8?B?OFliL3gyV1ZrY1gzbllxbllwVVpFek1xUGFvWnJZdUhkdWNNWlgwdjhQNHFq?=
 =?utf-8?B?UllMam1KdEQrMW1FRW43Mmg0TkpsdTRvTm1mUjU1RnQ4TDRTdEpkaHRCeHhL?=
 =?utf-8?B?cW44b2FpSjlvK1BtR3lDOUd4L0Q2azQ4SGJSb2hBeElOVGhEcGprUVUrM2NJ?=
 =?utf-8?B?ZHJmSk15cFFid2diSUVmWDlCS3dVZitvZDBpeitDT1U5ckFSL3FQVmd5dlo4?=
 =?utf-8?B?YlR0dnA4UkdwcE9od2pidWkwcnl3aGEzWTBUcm9wdlQrZ0xyVFhrOFgyUkFx?=
 =?utf-8?B?L3JUVDVxUUF3M1BIOEhkVXRtYmpCVU5pYXhZWkhneTE5WWppZ0pTalp0Wnli?=
 =?utf-8?B?Vjg0VHExZHd6SGROQjQ0cy9YWFF0QXFzbXc1UlVFTktpTGVrV1pzY2xRRU1r?=
 =?utf-8?B?cGhvNTd5QWh4S3QvS0Z4aWpUeVBWdnlITEp1c1psdzJ2R3lycEZJcEJXa3Vo?=
 =?utf-8?B?Wi8zdTJNQnFXM0Z3dXdGUXBaOHR0ekR3Y0ZYR3dKYmFBS3czTTJsbkN5cHdo?=
 =?utf-8?B?Um5xNDM5bUt5RDVtRFkvQ3Z4aDhRTkZvdzNKZkxiK0FRQUZiWUdEb0l3akRX?=
 =?utf-8?B?eW02WTJUVUVTQzVYeVNvZG9VcE1pL1Q0cWtNbFdOVnV6V1JId29kWnVpT0Np?=
 =?utf-8?B?dWxINTZPL1dvV3RJaWJDNy9qQjZvMlV2RGtZYlFFbXFJSjA2OFZkMURJWWwx?=
 =?utf-8?B?WTlXMTZwT0szUGxzR0d2VGd4RGlUSVFvOStvN1JGYzFxQTlFam84Y2NBTDN3?=
 =?utf-8?B?MW1tcGxYNWREMUpnVURkR01lUjk3UVdndWlnNGVpL25kcVpJSzRhY0ZlOVBp?=
 =?utf-8?B?Qk5qYWQxVVUwTC9NcEZRM0k0blp5MEdCWStVL0tqRTFKMmJrZ3ZjMHdJRmRy?=
 =?utf-8?B?aXdiVTFOY3VvSy8yMWIvSXR0QnhBWFhXdEpUUlhobzM2ZmZlN2dRaVNabjlR?=
 =?utf-8?B?ZXpVZ1FSc2RzTjVsbk5mak9QNXNodjZHOTB5Ym9zNUtyMUsza0tCU3lxNWN5?=
 =?utf-8?B?MlA0ZXhJeWlwN0cyVDgrS2JaczZmN0FPcG9oa2RaWFFQaXAyclBNVERjYUNU?=
 =?utf-8?B?SFJ6d3Z0U0dyNjIzb25Dd3RVVnRER3FtcEpGY09aNTJOd2pTVGp3WFR0TVd4?=
 =?utf-8?B?TnVBQjljbmVXQzFWU2RkQzlucnZ3cGZrMEpxMno2TnNKeWVJRlJHVXI5ZU1a?=
 =?utf-8?B?dktMVVpQdWd0MFFEVTdQdEdtRk1Md2tDL041Q1dIVUkyVkpBSVdHUVdsZ2lV?=
 =?utf-8?B?Kzc3NXRSV0U0UHJsK0g5RGNYb0tjdXVjWG1lbTh6cnF0Nys2RnFGdEgzd3pX?=
 =?utf-8?B?TURIUWRSS1hMd283M2VmckhYQU5FdnZSemV4dTZaVlFya3JOSDZJT3RxOUkv?=
 =?utf-8?B?QkxrTU1BeGtBQjNQSmpxSzgwMEt1SkJyRlZTZnVOUVJ6NkFwdzFNVDR3NkJC?=
 =?utf-8?B?UmdFbVNjS3ErRWhrSHhWNnNSaFdvSThCd3hFK0JySUJ1MDAyOE9JaXFCWFV4?=
 =?utf-8?B?YkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ea2074f-b91f-4bc4-7f4c-08dad6faf112
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2022 19:57:30.2141
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rT3JR8XIG1QDDoE1XByZEWTL5W6nO+4xXDzzUYcrCxsk400/o0BWJqIqI55nsk86MfkFe2sA4t0Dr10gfDItd18Ugb//6q6BjcgNg1ELrEs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6728
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



On 12/4/2022 5:30 AM, Leon Romanovsky wrote:
> On Fri, Dec 02, 2022 at 03:07:16PM -0800, Jacob Keller wrote:
>>
>>
>> On 12/2/2022 10:36 AM, Jacob Keller wrote:
>>> I am not sure what the best way to fix c) is. Perhaps an additional flag
>>> of some sort which indicates that the timestamp thread function is
>>> processing so that tear down can wait until after the interrupt function
>>> completes. Once init is cleared, the function will stop re-executing,
>>> but we need a way to wait until it has stopped. That method in tear down
>>> can't hold the lock or else we'd potentially deadlock... Maybe an
>>> additional "processing" flag which is set under lock only if the init
>>> flag is set? and then cleared when the function exits. Then the tear
>>> down can check and wait for the processing to be complete? Hmm.
>>>
>>
>> For what its worth, I think this is an issue regardless of whether this
>> series is applied, since the change from kthread to threaded IRQ was done a
>> while ago.
> 
> Sorry, I can't say anything clear without deep dive into ice code. But this specific
> patch is not correct.
> 
> Thanks

I understand. Its rather complicated :( I appreciate the review. I've 
got a new version we're testing now that drops the changes around 
tx->init for the ice_ptp_tx_tstamp function and adds a call to 
synchronize_irq in the teardown path to ensure that we wait for any 
outstanding interrupt before continuing teardown. I believe that should 
address your concerns. Hopefully we can send a fixed version of the 
series soon once it completes some internal testing.

Thanks,
Jake
