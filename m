Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 922336729D6
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 22:02:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbjARVCB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 16:02:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230146AbjARVBa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 16:01:30 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EBA8611CE
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 13:01:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674075690; x=1705611690;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rgbQ332USCqPmK9Gs3Z7WxiXZQKnUvf3vQzQP5FZkjE=;
  b=kjKlTGExKLRfZaaK4Y79pPYGpljLBf7nfuStAZIY5LjF9aVRgIJ9lSLG
   X4NRUFUMpdQL+73ZGDIgFGIIfu5RYL4EUVlyFSNvFUe2mtJt6ds1KNATj
   M15vfmCxY4OQ3PhRw9VzQfBWOswnsxwG5EpUHFZyoGJmExs1otmlYVbNG
   ocxxLPRHRVzQG9oZrbPEQcANlHWAEArST6mczY83IzFc1WCqALury52OS
   dJlN+W84af2FaAA12QxOgFLg9q7XDpkk2Vd7T8pomW9KahAUwAZ46dIYv
   LGy6JfjAUAVQLyBQpKv/8rIgariQEOkDOgKQahuzWuP//Y9JssQeJL4zI
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="411339907"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="411339907"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2023 13:01:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="783820141"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="783820141"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga004.jf.intel.com with ESMTP; 18 Jan 2023 13:01:29 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 13:01:29 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 18 Jan 2023 13:01:29 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.49) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 18 Jan 2023 13:01:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NWIwcrEqtjFf5WSWJ7VUcViqrR1DU3lEM4ZmuDDKkKzKjbj8lepCh9f5ixE1RR9KiTfzZBBvbS/dnDHAk38dIkKBXzB6KASx/CCANv9RO2DWri0K6eVyyyMrGt9EfNmk/MpgVOOUGTuJpHsb7CTTE+OMfzP/NgBjyxWXLywKZmjlQimgNNDcX+/vHJo/7G2fpf5SfY2LXT2IqlZA4pZmou6NeM7o9J+Vd6H6PTurBvmZdF6Z9crXXvHUnVLkKHiX/JePI3uN9L5qu35INNAL587Sfr6L7s9v6TK8IJf+vi6cxdJC+pAD0pNoP/Z0EWch0vWPSOtQtEWtFGyNH/9xPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ogcn8zh+E4yiBt9k6vY5MNcZYBHn/80gXtISluO9MuI=;
 b=IcEddL9P0/xptChKkp6UzAHb5CGWTWsakx8zjY0Zpppr0AjKPn5MyiX8Auz6SUORhIEQ/tg3H0zna9RGfBncNEKm9KnqCuHcwmoIkaAgUb/bV0BsfcbyQQO0wE8qksaSGYr2Tlr+UExwaK1uvJAQUNtd5JbBZi1et3dePEhRvC77Rx8rkB2ZdHyMY4wxmgYlKkVp9/OcV7Q7RWJj5hKkUrhMeJ1bKowdBwef2mvbI+uklx2xl17DBpBH76EpqpIKytFST2kW8pl4SUbLX8CHObtS37w4LD1af8XsXwKmybEI25fb7ie7mc483llBTo87DK2b+CBhml5XNmb8VwcDvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by PH8PR11MB6729.namprd11.prod.outlook.com (2603:10b6:510:1c5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Wed, 18 Jan
 2023 21:01:20 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%5]) with mapi id 15.20.6002.024; Wed, 18 Jan 2023
 21:01:20 +0000
Message-ID: <61d558ac-8aa3-8dd4-cd18-e9bdd42650a7@intel.com>
Date:   Wed, 18 Jan 2023 13:01:18 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next] net: avoid irqsave in skb_defer_free_flush
Content-Language: en-US
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>,
        <netdev@vger.kernel.org>
CC:     <brouer@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, <edumazet@google.com>,
        <pabeni@redhat.com>
References: <167395854720.539380.12918805302179692095.stgit@firesoul>
 <937ba89a-42e1-813c-9d1e-975b8dc9616a@intel.com>
 <92a29ac2-d1c6-1d16-cf29-00c705870d96@redhat.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <92a29ac2-d1c6-1d16-cf29-00c705870d96@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0053.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::28) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|PH8PR11MB6729:EE_
X-MS-Office365-Filtering-Correlation-Id: 877aa8d4-6d34-4759-ae62-08daf9972627
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gq7JoEh59rVD9ka/N2HfSFLvqWeYIw1/zIiO7Wnh1TvIgsvSrz62+QNXU/j18L+LHJnJslAQ6RlUReY4e/MmIdH1BZV4igtleUQV2290aCrdDzjPzpqTm0nTtF822Nbl9Fi8tkMI1rOrqedIfS+dz+qsoMpCv1nX7/q4E+XglbmIVNuLePFBkvPZRJZuFjQQmMY/r3ungsM4TffeDTff2OYSMRi4JaW+nwUcuTVz4fuvRzZ1oAwxmvIigiF/v+RYt9MxY/mk75/AzcjZTCR9RWTYTpbIS9JZ+5LC9Lym7phmU9nENNuX2KyP2DB6AKOYRHtrco5C/nxMSf8zSep1DE2DH8/RpeHaBCNP3cnY3rc9V6opVR+OvugWB2/KyVnL+e/+S4vHXaMm7xMqCI44lCjFk7Li4OiyQQfCop7BW85OJ9lnTLIF1z5t1zQNmWtk+k6u75hT3DiWy+ILEYWwBCbTZLVHBeGTF7bqPkGOFFSeFJ6eMQzGJ9W8iue/8OUh+VmsbstRpgg0Q46+AAfaJpo0nLtqNkv0jjqbBuvoDMM0tWjQTue0KsyQgAJS9Iv9Qg4VrTCtAHAPFloN0LAc4+6csOPKXNJHU4GbZGwDNZLn+/rSdcqFeAR8DxxXwLY4o9SurGqdQk5mry2ibFTTnHEYYlueEjWi4GDvD7ayWU90PHcCUjakFdDRZkhtXt3Cgqr1XFx4LwSl+gUHsIUGUusYsANbCmZnpkUBsYiTOU0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(39860400002)(376002)(346002)(396003)(366004)(451199015)(31686004)(86362001)(2906002)(66946007)(66556008)(8936002)(5660300002)(82960400001)(31696002)(66476007)(38100700002)(316002)(54906003)(53546011)(6486002)(6506007)(478600001)(36756003)(8676002)(4326008)(41300700001)(26005)(186003)(83380400001)(6512007)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q3JBa0pNK1YwbXVBMFJsL1hPSmZsNUJ2RnJDa29ONUs2bVBJSWpZeHVRWi9n?=
 =?utf-8?B?VmRnM3QxQ3ZIbGp6ZkV0b2lqQzJJd293K1I1djhiMmpvNWs0WkdsODJDblhV?=
 =?utf-8?B?TkM5YW9HYjFwcG94cW1MUjFWVHdYeFJlclU1VU5RTGp4NE1yNlhaYlVHZUJr?=
 =?utf-8?B?aStZemJOcFdYcU43ZFQ4V2tvZDRhdlQ2eDBzYzl0dkJWYzNzZm53Zkc3cTk5?=
 =?utf-8?B?ZXpwb3F6WEhKaG5OcDU2K1IrcUE5QVV0dHVucUtCY1lZcVVISkxzRGZjOEhm?=
 =?utf-8?B?YUUwS245RElVck4zWmJnczRhRnMwRG9tUzYxZ0NwOWpDMU9TaWVQRmI5MTUv?=
 =?utf-8?B?SHJ2NDFhWEh6YThoWlFnVElkU3JqZi9jak5icFlObW1VOFlXaTRIdDB3Qmpa?=
 =?utf-8?B?bGtzOTdUTDBJQm5GdzJuaTJOcitHTlFkOWRKYk5jVFd4ODRmU040RGRsSitq?=
 =?utf-8?B?cW5GVmo5bkJFT1lYeCt6L2sxYUJiOWVJYkZIaUxPcXFRdDNZU3YraWwzVEhP?=
 =?utf-8?B?Z3RVNXBHeUUwVmtLWXRGRENIN2I5QjZuOFJpQlVsMjVsRDRhcy9XVEtZZ1ps?=
 =?utf-8?B?QlFjQjJCUUpITkZHTjhPclpzVUZBNWZNakVSUGFMbS9kZHJWcTFXRmE2T1Bj?=
 =?utf-8?B?RlBpclVzZXFIbFJSYWs0dVcxeDJ2MUhEZFBMaTdiODZCc0xpY2Y3bkJPN0xy?=
 =?utf-8?B?ekJiZmRyYUVVRFFMV2ZRdmc1M3A5dUUvdGlxMkFPVS8ra2crRGZDM2J0TytN?=
 =?utf-8?B?Q3VMaFppK3cwc3V6VFVLMDhXUzRzd1F0ZjUvRU1BUXZYOVBsa2wwSFdleTJG?=
 =?utf-8?B?Q1FXS2ZxUkVWSmU0MEZCbUdvbnpCczYrbk9OeGN1eTM4UmdQM2R6YzFNK3Yv?=
 =?utf-8?B?WndFUk5KdklYVnNFK1JYV2VEc25raldGYis5blExcE5vbzdnSkpTZUlTTSsx?=
 =?utf-8?B?Zmw3T3R3d0JKNy9uQ1hLZUJaZmwzY3N4SDl0YjNESDFEK2pFTVR5M3BtSWcy?=
 =?utf-8?B?MXAyZW8ySkJmM0lOeVM4VytGM0cyOW9oc1hMdkxBZEFySTVmdDg5RjI2RG9m?=
 =?utf-8?B?dmtKSUxpaDZlQlkvczFxVzhOWGNhN3NoaDVaNndBZktPWEMrZGkwdHYzdTdp?=
 =?utf-8?B?YVhOZ1V1bWdib0RCdjh5aTg0QjdFbktRelFVam5mRkFFaDNDMm5QeE5CU0hY?=
 =?utf-8?B?NFJhVWpYSEROUHkxeDNYOHFEc0Y4dFp3RUJoSkt1TmE2WUJlUElyTFgyajVF?=
 =?utf-8?B?bjVXc0NHNENmV2hwUVBWc3F4Z2s3WTg2SVY3cUhFR2NGQVNaSHIyL0lVV3Jj?=
 =?utf-8?B?NkNQYnlDRS9UNW5taFJ6QW9qajQ2Q0EyQXNQSExidWZCbTZyK0ZUbTVHNjMw?=
 =?utf-8?B?NFMwZDJxcnRrU3Y5Y01jUHBCVDlqN1p5M3llTnpQbHRBVGVmQWwwYjlab1pQ?=
 =?utf-8?B?SWxhemNEczFOejJ3T2NxTFhLcXZ2a25YWXlBNkFlS3NFQ1U4a09iaDNKMStj?=
 =?utf-8?B?blEzanZUcHpNZVNGL0l2UEwwSEdFN1NXQlZEa0swQ2J0Z3JXNWY5QVdpSjAr?=
 =?utf-8?B?aVRySGVOSy9TSUxtUFB5R3dzVVRxM05BU01hTkNRenQzbDQ0OEl1VUp4cEw1?=
 =?utf-8?B?TG54VjdrVElEYlQrNEVjMUF1SUExb3FLNHJlcC9jV2llZ1hxWU55djhxaDFC?=
 =?utf-8?B?WWFoR3kraVNnckc5K3U4MWVRMi9mOGhmTEgySUlFRUJWZE4wcThQM3RsTGkx?=
 =?utf-8?B?UDk4clFuUlZTdGJxU1p6ZXFldUozWDlrZi82aW50bHE4VkdFbEVVTk9lMktp?=
 =?utf-8?B?cDh4R3ZCYkxQODJ1OCtOcU5yUE5uZXRMbmlJYkprZStoQzhJZ0VBVEEyTGZM?=
 =?utf-8?B?REpteGR4YVBtd25kQUUxZ1lucktFUk05blFDRkpnQjNqanhUVkVOa0Z6UmhK?=
 =?utf-8?B?eGVVeUQ4MmJYSjRTaXluc0FhY2tXcWZQL3dsbFd1b1lwd1orZFcyWlBGRHQy?=
 =?utf-8?B?bjZha1BvNEJsc0RTQ1RRcnZtalZLQjhvWnZFelI5RmRwUFpPbm1tTzRuN09o?=
 =?utf-8?B?TTBreUx5YithcCsxcW1JQzZkQkFLQXlZSUxkaCtpZG10OEQ2YkYvQS85NEJ3?=
 =?utf-8?B?WUc0bnJFMm01VHRXRDVyWmlxdWRYUUJqQ202Tjdlb2xBSHVsQnRtVU5xZGFZ?=
 =?utf-8?B?SGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 877aa8d4-6d34-4759-ae62-08daf9972627
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 21:01:20.4514
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9CM4W8m/04E8iijYoTQddilweVim4raIpZ0G0ePfkKYKwMpi90Ch2VS2ZuI0qUgWE7U02nr98jl4hntzEU6H9bTgwWOs6KLVzzRuX81i5gE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6729
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/18/2023 11:19 AM, Jesper Dangaard Brouer wrote:
> 
> On 17/01/2023 20.29, Jacob Keller wrote:
>>
>> On 1/17/2023 4:29 AM, Jesper Dangaard Brouer wrote:
>>> The spin_lock irqsave/restore API variant in skb_defer_free_flush can
>>> be replaced with the faster spin_lock irq variant, which doesn't need
>>> to read and restore the CPU flags.
>>>
>>> Using the unconditional irq "disable/enable" API variant is safe,
>>> because the skb_defer_free_flush() function is only called during
>>> NAPI-RX processing in net_rx_action(), where it is known the IRQs
>>> are enabled.
>>>
>>
>> Did you mean disabled here? If IRQs are enabled that would mean the
>> interrupt could be triggered and we would need to irqsave, no?
> 
> I do mean 'enabled' in the text here.
> 
> As you can see in net_rx_action() we are allowed to perform code like:
> 
> 	local_irq_disable();
> 	list_splice_init(&sd->poll_list, &list);
> 	local_irq_enable();
> 
> Disabling local IRQ without saving 'flags' and unconditionally enabling
> local IRQs again.  Thus, in skb_defer_free_flush() we can do the same,
> without saving 'flags'.  Hope it makes it more clear.
> 

Ahh, that makes sense.

In that case, no further nits and:

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
