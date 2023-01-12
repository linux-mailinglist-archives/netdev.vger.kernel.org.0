Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 661B4666773
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 01:14:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235333AbjALAOA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 19:14:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230325AbjALAN7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 19:13:59 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1C145F4A
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 16:13:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673482438; x=1705018438;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zbWaZrnUuEcZ2JARg9aZ5qefcIaP8OhmlJ+NtmeOWKU=;
  b=OovXzYGHLsgw/J66h2POEJolvag0IVdhzprsN03xzrwcsRl4IV1uQJhZ
   esUvw4cD9u9Gw1HHqABB3lV4o8qz2324MDqHMsnm77+xpPfeJAw9R3tXZ
   EJm9eP3Uvx/x+Srcs/mgdGtHWNeWUMJFhjm2jiNID1mzfe0IRXV9wI8Dc
   cVB0lOQjc0bFVPr36+LZnfjVaCSudCNLRvxoVEXSiqhq+FTaAb1PVsXcI
   qMSGKAAdXy4KVABgoI35FXZZVFlvuwuI9PV0/PC52RKTB59kblhQSEr1s
   1/x++5aAu+05Ko6Et791f4jpx2yIIK6cum3ZkmrEc34FKJlHH5nNWdBwG
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="388040030"
X-IronPort-AV: E=Sophos;i="5.96,318,1665471600"; 
   d="scan'208";a="388040030"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2023 16:13:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="650924242"
X-IronPort-AV: E=Sophos;i="5.96,318,1665471600"; 
   d="scan'208";a="650924242"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga007.jf.intel.com with ESMTP; 11 Jan 2023 16:13:57 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 11 Jan 2023 16:13:56 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 11 Jan 2023 16:13:56 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.105)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 11 Jan 2023 16:13:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S1mTY4DBGzvYCcKjcKdBksBNbiNhPqRnOldXHsjkajfdGgE9FBbQ/6jyybl6LWsG37Pw8vB1iHjHsfkbPEtnSMkwF81DdL/3TlpsPEa1JUqA/TNwtA0MUFIbFgofdgxQRGj5qXxk9+dUlaFsrif5pk7kM8Jk1q3Krav1SaUsforhzCxoti1Xe6Eq4QfkV+KzdT6e1FHqFNUr+mp45gKHgDQpNiZqKUZHWGFaAKJd4QAUlej1b5spAiRWLR3WO6cO4VOLN1Cp2NVlJti6B7KemA/d5lB1kGvz2U89G7e0KRZNj+4wkwzTeLYlqUvP8KjHs7+SZuGtH5GPsqDGR1XjRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y7wVI1uVbZn99tIB5/lWQ2WGmmmWfJzDIfw3F7GSH3U=;
 b=gWUNMqVLEZ+I+LD8u2iHN7dD6YUXYMiuKOYirUz9dANy1zdOeZj7lIKV9F7t4XTnrlhqzXan7JXJHOou468CtgA7DdIbm9EuJP8R8taJYvXDqUg8h8Jawf2SMCHcjWHoi1QNNMsTLttDxci/U5/nKqJquYFfBjgVBolr/p5PntWsw+OpAEaouHYTyMHer+1qG1bh20aQvXbNMXa6EKd/1V0yNiY+lLp4lmMYLBi5lACJnPqbXhRgpQgPZGIuxodR32znYxaBc4YCX3Hk1yd8te7AjULQ0ebzUv0AyaxHDI2okpLenaxDjsPLg30mfLvvLotV6mJVUU8B7s/+HxsAyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB5095.namprd11.prod.outlook.com (2603:10b6:510:3b::14)
 by DM4PR11MB5278.namprd11.prod.outlook.com (2603:10b6:5:389::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Thu, 12 Jan
 2023 00:13:54 +0000
Received: from PH0PR11MB5095.namprd11.prod.outlook.com
 ([fe80::ef17:4bdc:4fdd:9ac8]) by PH0PR11MB5095.namprd11.prod.outlook.com
 ([fe80::ef17:4bdc:4fdd:9ac8%6]) with mapi id 15.20.5986.018; Thu, 12 Jan 2023
 00:13:54 +0000
Message-ID: <b5f12323-1e27-358c-46cf-e4df57ac5849@intel.com>
Date:   Wed, 11 Jan 2023 16:13:52 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next 13/14] devlink: add by-instance dump infra
Content-Language: en-US
To:     Jiri Pirko <jiri@resnulli.us>, Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>
References: <20230104041636.226398-1-kuba@kernel.org>
 <20230104041636.226398-14-kuba@kernel.org> <Y7WuWd2jfifQ3E8A@nanopsycho>
 <20230104194604.545646c5@kernel.org> <Y7aSPuRPQxxQKQGN@nanopsycho>
 <20230105102437.0d2bf14e@kernel.org> <Y7fiRHoucfua+Erz@nanopsycho>
 <20230106131214.79abb95c@kernel.org> <Y7k6JLAiqMQFKtWt@nanopsycho>
 <20230109114949.547f5c9e@kernel.org> <Y712uDIgr/f1vveL@nanopsycho>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <Y712uDIgr/f1vveL@nanopsycho>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR08CA0005.namprd08.prod.outlook.com
 (2603:10b6:a03:100::18) To PH0PR11MB5095.namprd11.prod.outlook.com
 (2603:10b6:510:3b::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB5095:EE_|DM4PR11MB5278:EE_
X-MS-Office365-Filtering-Correlation-Id: 202cb823-69dd-411d-3129-08daf431e401
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c986yCTxKzHASAX0qosQz5ix/2QXmyX+4lPybQKjxzzH+RjPH/le0Rzo4TeMS6C8xrY3du8belCXsogbx4W7UvTGiU80FJ8p4NegUvecJkXHVcKi7Q3LaKykrlxqKamT8kjZuEKpCihWaYVxeqv8/X/ImGS7PmG9gIgk2l8AHe0gDtEAar6aR7UOzWJJFE+TswL5d/nACAt/8Px5b1icB/nX59G8cxdeDzQO9WvinkM1PxxENEqWMTtbFkkqtvFjZeCKHWi1mdI1Z7ebBMLX8zeBBuswzr1eGSjatNN6t2imoSx5+nvqyay3y/rXnmEvosb/JfyjCn2ob5+cm3j3sIfJw7MlqpqePRzf4p6fx4sHyleFKTtztBAPY3Laso6sJoLDqvPoJ+M0RantbG3YmZVgAIzKYxQ6tl1T06/XmJINTGDbkO8RdocdfR0AXTjfTaPDy0n/T3kJ+OMeqzacDktiDs5xifZoY9hJZGBOlZN7ZAtD+UN/qd2ZHh/oI1Nny0vW8BDbUdwVjSmvYfSSJU22Ca4rJ2FNGDZZPxTt1tRCEqWCkO7QbFHkSxCHROsIq3XwrnoPh2v3scFxCX80LwLeRNQEtkdba7Wl8oGxUePwO8z20sDSnqPZemPrsGefZUQQTCe2UYnMiHWmlIZAsp/8ojE+hAoy/eYHRIUlNuMcO4v+nsHWzKPMZWIgUMXtfxoXtO/r8ylNaj/T9CBkfM/ZCtVOWCFi8vAnyGw3kXQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5095.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(376002)(346002)(39860400002)(396003)(451199015)(8676002)(186003)(316002)(26005)(5660300002)(6512007)(86362001)(6486002)(478600001)(2616005)(31696002)(41300700001)(66556008)(110136005)(4326008)(66476007)(66946007)(36756003)(8936002)(83380400001)(31686004)(6506007)(82960400001)(38100700002)(66899015)(2906002)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QXBPcHRXbXVjZnpxMzZycGpla3pQZGk1VUZxUDNzVHYzN1haNjdyQnMraG5U?=
 =?utf-8?B?THpMSTFGamRoY3dSUzBRb08vL0R6b2g3WnFRYXoyVmg3MldHQTFKVzlxZFVV?=
 =?utf-8?B?VjduUjU3WTFTbUwzWGYzOEVGQXhMaEZjdlAweVVWTTYxdklCY2tFR3FTNW12?=
 =?utf-8?B?b1pJWDRWSFBDWkx6aUlFSlpXRlB1M2JmWkNCQW1URTBZSGtqNUhxbHF0YXBJ?=
 =?utf-8?B?WU5vQkNWVURWK1NjOE9nY2t0WWxkc3ZoV0VqWHhiTFozT3hZamUyV3krVTBx?=
 =?utf-8?B?WDVvMjJEb0pkcUFVcDdVV0d2eEZ3Z0N5T1NmdVA3OVIxTlM4WDF6YzQ4a25k?=
 =?utf-8?B?WVFjbGJwSUVDS0VOSU9NTkpYbjhqWnhIVXhjdUw4SzNmYUxwQWxEanN3UHJY?=
 =?utf-8?B?MDkvYVRwNnFwQy9IblpjbUxFNlR1cm9Vbkt1cjJPYk1tb0hEeW5McFJ5VlRK?=
 =?utf-8?B?RG1neHhrMHNwdHNCbTEvVTYyamFDTmRlWER0czg1VEpxdHZmdEE2Q3lGbXJu?=
 =?utf-8?B?Q09CWHc1QlVlc3o3c3lBdGJoN1R5SDZXWndKMmtTWjR4UWVEU1NkYXZIK01J?=
 =?utf-8?B?aFlaMzFuTWV6Y2Y0RGFJNEp1M2k3MFBCSXQ1Y3NZem9SS013WERuV1QwTjAx?=
 =?utf-8?B?dkpROTJRSThnUFJDMlV3bUVGUWd1QWErdHZpS1R1djcrR3IyeGRJQzJHNGNX?=
 =?utf-8?B?eEljd25icStNOGlWVmo5YThVNVhLcWVGMk1XeXVaekZZeTliUFVoY0dQNmxK?=
 =?utf-8?B?dS9rOGFHSUZEcEt0SUFUVldkRkM3cEgyVEFtUlo3Y1VORTNjamkrZVhiaXFF?=
 =?utf-8?B?eEtrZTBVWWpBWW9VWnE5bTJxVmNZN3J2Nms0QW9oVEo4U1lnc21NWVVPaVBm?=
 =?utf-8?B?NkRIQ3M0cGp6SlFNSDJaVFd5V1Fqd3d1Y2VFTXg4Zld0dGhQZXFNN2Q1cnFT?=
 =?utf-8?B?cjVqajJ1TTYvRDJqcWV5TU9MWFRmcHFlNjRuSndHNUh4L0RXVTM3ZlFGbUNM?=
 =?utf-8?B?aFFNcytsUVJXMEk1Q0hsbjkvUk5EZ1ZxVzF3WTI3aTRYZG1Fc0JpV25LeXg5?=
 =?utf-8?B?YTVwVUd1ZElOakcvZmRYV2tNUEUyVGFCczNmNXBsbHZhbG9VYTIzb2lWRWs3?=
 =?utf-8?B?Y1dzRFlPTTdBTFF2YUhaTHRHMlI1VmlYSFFXbVZsekVETUFhd3pvQmxvMFdv?=
 =?utf-8?B?VklISnRQQjVuTTMzemNQWmlacTJTVnk4ZWFUVXNRR0ZnMlRHbzZKNm9wMDV0?=
 =?utf-8?B?VHkvNXJHY1FCUFB4VUJIdTMrT1R5NFBxRSszMlJPOSt0WW5SdDFib1VpM1Ju?=
 =?utf-8?B?bHl6MXRESlJsQm0rYnJ4WEs2VjZZVFphbWNNM3NlVnFpUi9mVUZJQ2VMc1Z4?=
 =?utf-8?B?WURNeEprelJqU3dLSWhWcjNHRGpVZGJuT3BPUDllRTNvMzd5UCtWZHlzbHVP?=
 =?utf-8?B?ay9rVUVzYUNjZnlIQmhXZVY2aHhGaE1SNStPbDNpa3B2cWhyZ2E1dHBER3lH?=
 =?utf-8?B?bHJFUWI1dkRqUklQb01Fenl6NHJrQlNHNUZRUGluNk9WNTg3RTBnQmhFQ0Z2?=
 =?utf-8?B?QXpqT2RoTWIydEZEVXhDUGx6aHQyeS9kRkVpZDllcXQ5WGIxN0R2Q3lhUUJR?=
 =?utf-8?B?STBvaWl2VWo1UUJvZG5kVnRrMjRPNWNvbWlKOWg0TnVpSkd6NmZBY3BEdi94?=
 =?utf-8?B?cXdvRXR3ZlhQMGx5TmllaitlOFhuZUtCYWtmTnZCbTdCU1lpYkNHWXNvNE5L?=
 =?utf-8?B?NmNuUW43TmMxQXRxT3ZEb2hOeVIrL2VnQVVpUHBXdmppSnEyWEF0Y1hKUW9T?=
 =?utf-8?B?TStWNEJFSDBnRzlJankzanJvUkg3dXJKdjA1TTBpdEdXZlVWZndUdlBYaWZh?=
 =?utf-8?B?aG8yckhXWm1KVWNEQzhEWmRMa29adlZycUpvcDMvKzVrR0R1RGlhOEU5VHIv?=
 =?utf-8?B?ajh0bWpvazJoa3R0bHRQdUhQMTlQK1hEUmplaFFIMzJIRUR6RkVEVGFHYmVn?=
 =?utf-8?B?QVpubkROYUJReTVXQ2M4WWNCR2g4TGkwWUZhQXNWd2k5ZVhtM0pQVmR2MVYz?=
 =?utf-8?B?NUV1a0s0OWYzK0lxVUptekNhb25MdHE2cjVlRXNJOFBiQkhPMzVzRUtYd3Yv?=
 =?utf-8?B?OUZ6bTIxSURLQnozbUZadHZwMVBaSHBYSTl2Y29BdGFCTndBbHFic0VNcVVI?=
 =?utf-8?B?a3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 202cb823-69dd-411d-3129-08daf431e401
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5095.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 00:13:54.4527
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Kn/65AUMW0B2K5pXyY2WyE9D32rJe6BfQtNthz5rJym3xlC/ZLFsRg4ri+XIffbMvv8Yg6vxdSdOLsXmo1RSS9bdJqOUokUWgZLfYcp9upI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5278
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/10/2023 6:31 AM, Jiri Pirko wrote:
> Mon, Jan 09, 2023 at 08:49:49PM CET, kuba@kernel.org wrote:
>> On Sat, 7 Jan 2023 10:23:48 +0100 Jiri Pirko wrote:
>>> Hmm.
>>> 1) What is wrong of having:
>>>    .dumpit = devlink_instance_iter_dumpit
>>>    instead of
>>>    .dumpit = devlink_instance_iter_dump
>>>    ?
>>>    How exactly that decreases readability?
>>
>> The "it" at the end of the function name is there because do is a C
>> keyword, so we can't call the do callback do, we must call it doit.
>>
>> The further from netlink core we get the more this is an API wart 
>> and the less it makes sense. 
>> instance iter dump is closer to plain English.
> 
> Hmm, I guess if you are not happy about the callback name, you should
> change it, to ".dump" in this case. My point the the naming consistency
> between the callback name and the function assigned. But nevermind.

+1 for having the callback part and the name match. I don't particularly
care if its .dump or .dumpit, but I do like having the callback match
the struct member. That being said, its not really a huge deal.

Thanks,
Jake
