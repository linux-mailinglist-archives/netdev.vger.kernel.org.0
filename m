Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F21563C725
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 19:26:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235551AbiK2S0N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 13:26:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230410AbiK2S0M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 13:26:12 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8B1561BA2;
        Tue, 29 Nov 2022 10:26:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669746371; x=1701282371;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RewHFpYl4dtNcQN+QHlEWgmono4gMuL2rlOIACz0Uvg=;
  b=RTGmdn1zxkRAj08e1r2Qfb+a2+TXvz0ypMhvLhSXagcrvU4IDrV/1g6k
   Iw7JYupw+m3hjgXkfTPf+5PpPl6lVWJx0AE5HfjAckv+DHwcIPd0B/3Ha
   nuYHR9DAE5MAd4xbsdnFXRW7QH1RMcCOL6066IRJjQ4yfWqbbdJNztfMy
   iUOcIr6yAHa/mj6QtYAI8iTInO+7BgHttlzIHbChylrBdaExx8imy4/XE
   NPYXldngrfEPEQqyIpQ59IpTcK83RhnBaWIITJzmPYkf0kgJd94mpSvW4
   7yIDoQPBJQF7s/xQYDjJbzCX072Z+fgf6wrsRuCnu7NFXd8Ji660mvvnq
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10546"; a="342116294"
X-IronPort-AV: E=Sophos;i="5.96,204,1665471600"; 
   d="scan'208";a="342116294"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2022 10:25:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10546"; a="768529852"
X-IronPort-AV: E=Sophos;i="5.96,204,1665471600"; 
   d="scan'208";a="768529852"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga004.jf.intel.com with ESMTP; 29 Nov 2022 10:25:19 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 29 Nov 2022 10:25:18 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 29 Nov 2022 10:25:18 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 29 Nov 2022 10:25:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MQRCHBhuWPfuyeeiQzdcPlL7FqFXfyRcFS0L0mbrVRfFpc96KMrwKZM8UtGuNmiLKH4y7todrwwjW50QVxPThBM6nMyiHWLS+W7fRF6XgE2n507oTwBQgIQ8ACCXiYPd5rM1p2bp413BnfBKBCEMMB/GuER/We++2vU3Cbh5egS2bOoCEUwiOELbub3izATxxCWVIfF29549VstUd1hrUcEXTE/sqDkm2VeqcLInMhFi1udRbMinaiX8ZnflkWyCxhE6bDCv/GVBOuXeTEFzdTclI1kCNq25KlLOioc1Huq1iM8xLBYlv2+2c61uAGsdYjkH0O0b1AxsZj76+XCzNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LYitZ7ZZV1Rwai0kDnCdZPi32NJ0YHOTXnT/1BAQPLQ=;
 b=a8/33PRJpJGiK1ic9qtL0tKC+DiPHjAG+2CJFAw1uDjaSQM2YxEmtvLP94fN63B1iKPfy5mzaYvJWf5cTFgfnj+99fQtI8Dzjn3jugFWW76DdCVKOk9qwrxvDD/8CJCuk0Y7mE08weiitVguDtIjNO5lH6fXb1NzlOgKVLFOGtzWY5cdG8vuMbToCYBHy4VjhJs6Z9yzJF8ZFehdgENiMRCy3epXif9GkE0t06baNDpFcjqGoCjYOBMcTEl+nm5WleSavvvlKiUyccrPKTvKrYvja7QmCN96dUmTnY6Zh+4ACJ945aJKXFKh7C+FwM0ZxeHMkr8mkbviqUdmifdfhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by DS7PR11MB7808.namprd11.prod.outlook.com (2603:10b6:8:ee::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.18; Tue, 29 Nov 2022 18:25:16 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3%6]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 18:25:16 +0000
Message-ID: <861c292e-aa26-0bd7-1d1d-39f50d5ef904@intel.com>
Date:   Tue, 29 Nov 2022 10:25:14 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v3] epoll: use refcount to reduce ep_mutex contention
Content-Language: en-US
To:     Paolo Abeni <pabeni@redhat.com>, <linux-fsdevel@vger.kernel.org>
CC:     Soheil Hassas Yeganeh <soheil@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Jason Baron <jbaron@akamai.com>, <netdev@vger.kernel.org>,
        Carlos Maiolino <cmaiolino@redhat.com>,
        Eric Biggers <ebiggers@kernel.org>
References: <1aedd7e87097bc4352ba658ac948c585a655785a.1669657846.git.pabeni@redhat.com>
 <477f3642-608f-f710-9eed-6312a6e3f2d8@intel.com>
 <e9767b9d708db2593805e8507d3ca43532dad59e.camel@redhat.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <e9767b9d708db2593805e8507d3ca43532dad59e.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0200.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::25) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|DS7PR11MB7808:EE_
X-MS-Office365-Filtering-Correlation-Id: b9c0c705-e774-4ddc-1b17-08dad2371025
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nwuGeEp6jOi23KJirOegVIW5Z9RQsiZYpGf+awY5ozwr8fn+PsC6EIB2BegFR7jRMVuTWFkO/jk/b1HHZAluKgBgbVEyJlPnisd6OZZcC+9uAGfw1fRP4b1kwpfvyxoTl8kKZByiTKjkBPsOJeVI6fFDzS/y+vQ6mUwG2qiPQ+NgCrNPZ5hVX1jCn9VRL5ISs1o+dO8/+2YS9gxq19LeIfSjOvBKV4EhqcaSmmFzgjkadNrsNDVNaTln2RuGMIsBipzhD6oW1NvpovMPMbB+qW5jT/+OMqeOJNA3PcKnRc2xBdxLOh+FedeSyyqyh6ymg3oaNvYqb6NbflwHLGQ117EozNNKa+o0GM1QP2KaRWd8EdgZn7VntVqj9yzGtocYbm2tPICHk4xPjFBlns+ZbxFMUNkC4lwpwW1MHNQZmjWjZjGfZnyOywgKSxxl7miEdHHG71KVRoPLc/bjuFUKE6IMY3evMeVPgHLPu1xGjpi6fvG+0g0wnFi4TNLsMxhsKLG+fsKwmyVOKZBqxctMv+E8jSZRn1cGORVznSI7SYqQKbg6bHv1ZNpizw4fvZOde67MwTDvxyJsg77IfHUH5wiDtvxYdS4EgEDvGmVD4cWWV3kovkimwuYp/qWkDEyFJ9v67bRyQ3XEW/l6AB+lxkJr2Z7bQNMAPjf8rSqX/wZ4yEFCsu+w0WxMzOKt6vMFufGpxi6auLzBr4KSVDsNlR6u8nY7wGXVqCRogkd2LcE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39860400002)(346002)(366004)(136003)(396003)(451199015)(31686004)(186003)(2616005)(316002)(478600001)(54906003)(86362001)(31696002)(82960400001)(36756003)(38100700002)(83380400001)(26005)(6512007)(53546011)(6506007)(4001150100001)(5660300002)(6486002)(4326008)(41300700001)(66946007)(8936002)(66556008)(66476007)(8676002)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RGY0SmJZc3NxYUVJUSs2TlBkZXhmZkNrZytxcVZvdnFJSE5OdWg4QSsyZGFY?=
 =?utf-8?B?NDdRQjlxbFF3VnZXSXJrSWRzeU04aHlhUWt3NHNvcXkxaDJGNGpVSVh5NWo3?=
 =?utf-8?B?Z1FoSllUMG1IL1V0cUhKNDNyVmNtaXlVcWdMSFdRbmM2N09LMjlwQ1QyTmpP?=
 =?utf-8?B?Tk9CU282Z0VzQ2FBdTFUZmExa0lBM3RpaFoweUpxMjF5WEZ1eHkxM3JXQ3Jn?=
 =?utf-8?B?VHJHcXdhUDZoQzd6WUtNdzZlQ2ZZeHZpek5KV3BwcWhRTlpwUm1ndGhrUWFT?=
 =?utf-8?B?Uzg2MlhwUTdoVFdwbGdTQzRQOW9JRXVuNFFnd3BZbzNJcWYzbWtiQzRzZkd4?=
 =?utf-8?B?c1N1SkxWN0VIb1dkN1ZwZHRGK3FNZ1pBWnBwZy9xYm12RWk1RTJ5LzdVSkNF?=
 =?utf-8?B?QW01ZW1hK2pkY1BuTG1tR1VOTEhOa3c5WGN3UzgzWXVIYWxlV05OSWFjVTY2?=
 =?utf-8?B?YzJHZUVhQVJGQlZWYVRqN1I5ZENicUZoVnQ1WUIzRWRqZTZYY0oxamxEUkdG?=
 =?utf-8?B?VnlxZkJleGd3dzVGYzQrYzZqOXRkV1I1cHBKelF1eWhxbFFqZmxaNUJXSVA0?=
 =?utf-8?B?SzBWS1RGelF5N2FuSGJRYzFqdmJGR1JDVnR5RDFjSnl0RWZLQmM0SzVQcDJF?=
 =?utf-8?B?OE1NK3pVa014NTZacWlMYUtPWGxFbXRXaGs3KzBOVnVEbDF1ZUwrK3pJTTk3?=
 =?utf-8?B?TkViNVcrQkt4L0RaL2pVOEt1Yk1rM3RLWUEyM3daQSt1cjl4MGNRemwvRHh1?=
 =?utf-8?B?RFZUZUlFdEk2Z3BTK1hTN0I3ZitxOW1yK2tYUENOc0V2RDdFSlVCR1E0RmtO?=
 =?utf-8?B?dFVLbkRCSFEyOHAxTHVDL1MwVVFOZnpldTZydy9vZ2xqVzJ2SDY2U29Xd3hx?=
 =?utf-8?B?YS9XbFhhQ0U2ZmxUTGo1LzBKa1B2Ylh1RDVkM1ZBMHdxWHhqaFBiRk8yUHd2?=
 =?utf-8?B?NEY5SWhaOXZYRnhFZENrSzFIVzdQcU95bVlZNGVQajFKYkN2WDFueWlFTm5r?=
 =?utf-8?B?Z0xvVU4rWUlZclVLbW9lTDJ0bWIwTjZUcU90b0d1WVAwR2RQaGFqQ0FLNGll?=
 =?utf-8?B?MVhaa3JSdTh5eG55ODFqelBEWGlhQzMwWWp1aER6SWVsNzFFVXRYRTNSMVd4?=
 =?utf-8?B?QkpwN1Q1bzgrWlg3OGxlTzhBeW1ZdGtHM1B1eEJhZ044Tm9PRkh3WEE3ZEhZ?=
 =?utf-8?B?czdrUER2L0pvWERpN2pLQmppcEdqUnlSblhwRDRyTEt1ZlRaQkVnMmhZaGg2?=
 =?utf-8?B?ZThvc1NlSHh1VWZlUnc3RHNtc2Y3Y09zVjZJRnBFMDdXS3U0K1NGaHBpdmtl?=
 =?utf-8?B?YjZENkk4WFdkZGVOQzM1NkJzYTJmZWhUZnlaYUxydmN5aFAvc3NlcXMxbFI5?=
 =?utf-8?B?TXMzM2ZtSVNtQmtVZEpBUWp4VDdjZE16OW1OZVY5VkVVaUZjS2JUQ1FzaGRa?=
 =?utf-8?B?SCtORUluVmMwRS8xUndIVUlDMEtNdzBTeW1CVVl5cUtuZ05NOHg5TXA2RlR5?=
 =?utf-8?B?bEZCbThsU3JjTXFPTmlXbWQ3QXhVWWE2eU82dlZyVHpaaC9JTXJSUDFBR2pY?=
 =?utf-8?B?ZjR5MFVBbEYreWllZGtQRUU1UjlTNEtpdWFtWXM4MEpWK2NwWjBScWk0YUQx?=
 =?utf-8?B?cEdoc3hyYUVRZTlmUFFJN0R1ck53VjlKZUJqZFpYQjRKcmZUdEI5d3c1RUEx?=
 =?utf-8?B?TjR1TEM3QlMxclVyVGhweHdPSkVxMmVYcCtKRUFGTzZpOElkRGo4NmdjYVhY?=
 =?utf-8?B?VzhVbERZb3BST0FOdmN4eWxCenNMYk5YNE8rVFlCQkdFbklRaHpZS295WW5t?=
 =?utf-8?B?WlRQSGpFYjZCb3JBTVFUWm1vR24weVB2c0RQdldyVGlEdkdxTkU0anhTbXpn?=
 =?utf-8?B?WWV5eGN6ZFE0K1paT25nNkdGS1NTOXBPdTZGQnFjTzYrcnlPUW9hc3NraU9z?=
 =?utf-8?B?UHFITDQzbGk2UGFKQy9mUEhmUkh2Q0JrUkRlSmlUNm9BUjJzVkJFMVJwQVFM?=
 =?utf-8?B?NFJ5UTZ6ZDBKWTdaM2lNeGtlKzRrNE1udWpoRXdPWUIvWjdnMXh5N3dQcC80?=
 =?utf-8?B?Wk9IYzhKVlFCaWdRVGhkRFlDLzAwY2JxOUwwenNDcnVYTDMzSFRrRXVKSGpZ?=
 =?utf-8?B?QWNOeHN6VktZbXBhUllqdzVrL1I2SHBOUlhkTGZlbmQ5QktqUEs5VjJ1dXFF?=
 =?utf-8?B?OWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b9c0c705-e774-4ddc-1b17-08dad2371025
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 18:25:16.6165
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jdvtOEvPDBa1G+U1R7DIio5QWMff/jmwqDrKWVRQJBtL5ik7mOjVaqY7QabZ86TauEuUBjXzIf6JfjVED+Np0nSvf1/stsWQGzNhihsC2VY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7808
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/29/2022 1:05 AM, Paolo Abeni wrote:
> Hello,
> 
> On Mon, 2022-11-28 at 16:06 -0800, Jacob Keller wrote:
>>> @@ -217,6 +218,12 @@ struct eventpoll {
>>>    	u64 gen;
>>>    	struct hlist_head refs;
>>>    
>>> +	/*
>>> +	 * usage count, protected by mtx, used together with epitem->dying to
>>> +	 * orchestrate the disposal of this struct
>>> +	 */
>>> +	unsigned int refcount;
>>> +
>>
>> Why not use a kref (or at least struct refcount?) those provide some
>> guarantees like guaranteeing atomic operations and saturation when the
>> refcount value would overflow.
> 
> Thank you for the feedback!
> 
> I thought about that options and ultimately opted otherwise because we
> can avoid the additional atomic operations required by kref/refcount_t.
> The reference count is always touched under the ep->mtx mutex.
> Reasonably this does not introduce performance regressions even in the
> stranger corner case.
> 
> The above was explicitly noted in the previous revisions commit
> message, but I removed it by mistake while updating the message for v3.
> 
> I can switch to kref if there is agreement WRT such performance trade-
> off. Another option would be adding a couple of additional checks for
> wrap-arounds in ep_put() and ep_get() - so that we get similar safety
> guarantees but no additional atomic operations.
> 

If its already been assessed and discarded for a good reason then I 
don't have a problem with sticking with this version. I didn't see any 
reference to this before and krefs feel like the natural choice for 
refcounting since it seems easier to follow getting the implementation 
correct.

>>>    #ifdef CONFIG_NET_RX_BUSY_POLL
>>>    	/* used to track busy poll napi_id */
>>>    	unsigned int napi_id;
>>> @@ -240,9 +247,7 @@ struct ep_pqueue {
>>>    /* Maximum number of epoll watched descriptors, per user */
>>>    static long max_user_watches __read_mostly;
>>>    
>>> -/*
>>> - * This mutex is used to serialize ep_free() and eventpoll_release_file().
>>> - */
>>> +/* Used for cycles detection */
>>>    static DEFINE_MUTEX(epmutex);
>>>    
>>>    static u64 loop_check_gen = 0;
>>> @@ -555,8 +560,7 @@ static void ep_remove_wait_queue(struct eppoll_entry *pwq)
>>>    
>>>    /*
>>>     * This function unregisters poll callbacks from the associated file
>>> - * descriptor.  Must be called with "mtx" held (or "epmutex" if called from
>>> - * ep_free).
>>> + * descriptor.  Must be called with "mtx" held.
>>>     */
>>>    static void ep_unregister_pollwait(struct eventpoll *ep, struct epitem *epi)
>>>    {
>>> @@ -679,11 +683,38 @@ static void epi_rcu_free(struct rcu_head *head)
>>>    	kmem_cache_free(epi_cache, epi);
>>>    }
>>>    
>>> +static void ep_get(struct eventpoll *ep)
>>> +{
>>> +	ep->refcount++;
>>> +}
>> This would become something like "kref_get(&ep->kref)" or maybe even
>> something like "kref_get_unless_zero" or some other form depending on
>> exactly how you acquire a pointer to an eventpoll structure.
> 
> No need for kref_get_unless_zero here, in all ep_get() call-sites we
> know that at least onother reference is alive and can't go away
> concurrently.
> 

Fair, yea.

>>> +
>>> +/*
>>> + * Returns true if the event poll can be disposed
>>> + */
>>> +static bool ep_put(struct eventpoll *ep)
>>> +{
>>> +	if (--ep->refcount)
>>> +		return false;
>>> +
>>> +	WARN_ON_ONCE(!RB_EMPTY_ROOT(&ep->rbr.rb_root));
>>> +	return true;
>>> +}
>>
>> This could become kref_put(&ep->kref, ep_dispose).
> 
> I think it would be necessary releasing the ep->mtx mutex before
> invoking ep_dispose()...
> 

Yes you'd have to refactor things a bit since ep_dispose wouldn't 
actually get called until all outstanding references get dropped.

>>> +
>>> +static void ep_dispose(struct eventpoll *ep)
>>> +{
>>> +	mutex_destroy(&ep->mtx);
>>> +	free_uid(ep->user);
>>> +	wakeup_source_unregister(ep->ws);
>>> +	kfree(ep);
>>> +}
>> This would takea  kref pointer, use container_of to get to the eventpoll
>> structure, and then perform necessary cleanup once all references drop.
>>
>> The exact specific steps here and whether it would still be safe to call
>> mutex_destroy is a bit unclear since you typically would only call
>> mutex_destroy when its absolutely sure that no one has locked the mutex.
> 
> ... due to the above. The current patch code ensures that ep_dispose()
> is called only after the ep->mtx mutex is released.
> 

Correct, because you use the dying flag, yep.

> 
>> See Documentation/core-api/kref.rst for a better overview of the API and
>> how to use it safely. I suspect that with just kref you could also
>> safely avoid the "dying" flag as well, but I am not 100% sure.
> 
> I *think* we will still need the 'dying' flag, otherwise ep_free()
> can't tell if the traversed epitems entries still held a reference to
> struct eventpoll - eventpoll_release_file() and ep_free() could
> potentially try to release the same reference twice and kref could
> detect that race only for the last reference.
> 
> Thanks!
> 
> Paolo
> 

Right. Switching to krefs would require some thinking to go through the 
various cases of what gets a ref and how.

I'm not sure I follow how that would work it sounds like something weird 
with the way references are being counted here. Its likely that I simply 
don't understand the full context.

Either way, if there is good reason to avoid kref due to cost of atomics 
in this case and the fact that we need the mutex anyways I suppose I 
have no objections. I'm not sure what the perf cost of an atomic vs a 
simple integer is in practice though.
