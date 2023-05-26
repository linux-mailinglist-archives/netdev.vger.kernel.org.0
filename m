Return-Path: <netdev+bounces-5555-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D3051712166
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 09:44:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8837628164A
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 07:44:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 018328BED;
	Fri, 26 May 2023 07:43:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E32EB79EE
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 07:43:48 +0000 (UTC)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27F8510D5
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 00:43:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685087008; x=1716623008;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=pJfPvqeqtxhTa8QUbIPMKu55KZsOxJYY3zjAwO5JGw8=;
  b=N0taqcFf+2gy0+tN3DGgOgzlI6wkasg+njyeRxt6zSh65AV/C8/tpO5p
   pBPP6dalHqcqq4QM+sG009WE0kqN9Zle4MYN4K3R2l5CSC6H4tcvgMi2l
   y++h1BAhfZ7GnsznJcryKmQ9bJ9ypRfuXnPe8vaURiiB5jqdarhsi9R3b
   zr81W41dZzrBVci0Rf/yK94oJ3ytBDK262RtKL0HJni+/RGBnfiOmb4sM
   z7WiYI3VbxHDEcO57Ok4nLJCPs+VngdUoihnvBa2S7BniALeFegvFVSSi
   oqNRjt67odBa0FR+8GabbyriaCHjGhhxQGTIa+ImdpJbJtHA46712NAal
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10721"; a="357396208"
X-IronPort-AV: E=Sophos;i="6.00,193,1681196400"; 
   d="scan'208";a="357396208"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2023 00:43:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10721"; a="829417171"
X-IronPort-AV: E=Sophos;i="6.00,193,1681196400"; 
   d="scan'208";a="829417171"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga004.jf.intel.com with ESMTP; 26 May 2023 00:43:27 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 26 May 2023 00:43:26 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 26 May 2023 00:43:26 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 26 May 2023 00:43:26 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.175)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 26 May 2023 00:43:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BicPRVQQPegjytGk5NE9fsr+reKlc2w5Z7tX5+zpBUlr/ft736oUsOSV/ZgwNSAgL235V5+0MzybJqN5CDwfJBiH9OsHa+YLbZnBI4Pzfy7lthG0M5yTZ4tlwf0z3xkBNV79wT/4qWsVdw4UGEC0O1ArfYeXxMMEZY5e7RBmG8qYuYi7zhe7s25J4ZhuFCPq5/WO2JcaTgBvC+3UUnb98i4/iFZ47c90mlu1/PDXJQdQyfpfpC76V/S+f9h+bG4tGcKKux1eoe/9v+do7s/308fGwncO07KQGgumHw/jvXr/4CTTmO4mJd4lCSr4SUJuJ2o84AfGOSbz92/p2yRWIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=waiUJxMdnhYjH0Eo2IVD3S/Anc6X4mgxljhcPpZRHPE=;
 b=Y5sJJGX55wEiSBq5fYflhO6NCvJBk+yqZ2t7cCvC8jIGAQp+rm/ZW/DS//7++FbA19D39pUpr0r67DJXna3lAK1KZZqi2zmfmMbAmtx60Um9WjzjTe2bZebG8ZMXLg91tAcFfn+jjG4/XHCZy5NqOmxDDGlcx8yBuPvTItTLpxkIbOiVjw41Hq+AFGjajrqezR8PCHwzdYhOaBrAWPWamzXQg+hYpLXnXx1n2lvFG8ds3/MDJK1sC0izSXQaruw4sMX+2TIlDJQLqfa+SYts9All6w0ooe2rIwlw7SxquJJJkn3BYHg8/enGoudafo0eD4nQmWluboTlTAsKNJBLdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO6PR11MB5603.namprd11.prod.outlook.com (2603:10b6:5:35c::12)
 by SA2PR11MB4985.namprd11.prod.outlook.com (2603:10b6:806:111::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.17; Fri, 26 May
 2023 07:43:24 +0000
Received: from CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::4287:6d31:8c78:de92]) by CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::4287:6d31:8c78:de92%6]) with mapi id 15.20.6433.015; Fri, 26 May 2023
 07:43:24 +0000
Message-ID: <13cdd150-156f-65d2-2c38-e79115efbe8e@intel.com>
Date: Fri, 26 May 2023 09:43:17 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH net-next 0/5][pull request] ice: Support 5 layer Tx
 scheduler topology
Content-Language: en-US
To: Jakub Kicinski <kuba@kernel.org>
CC: Jiri Pirko <jiri@resnulli.us>, Tony Nguyen <anthony.l.nguyen@intel.com>,
	<davem@davemloft.net>, <pabeni@redhat.com>, <edumazet@google.com>,
	<netdev@vger.kernel.org>, <lukasz.czapnik@intel.com>,
	<przemyslaw.kitszel@intel.com>
References: <20230523174008.3585300-1-anthony.l.nguyen@intel.com>
 <ZG367+pNuYtvHXPh@nanopsycho>
 <98366fa5-dc88-aa73-d07b-10e3bc84321c@intel.com>
 <20230524092607.17123289@kernel.org>
 <7ece1ba9-03bf-b836-1c55-c57f5235467c@intel.com>
 <20230524130240.24a47852@kernel.org>
 <e5a3edb9-1f6b-d7af-3f3a-4c80ee567c6b@intel.com>
 <20230525084139.7e381557@kernel.org>
From: "Wilczynski, Michal" <michal.wilczynski@intel.com>
In-Reply-To: <20230525084139.7e381557@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0060.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:93::16) To CO6PR11MB5603.namprd11.prod.outlook.com
 (2603:10b6:5:35c::12)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR11MB5603:EE_|SA2PR11MB4985:EE_
X-MS-Office365-Filtering-Correlation-Id: 399a3904-04b7-44e6-1380-08db5dbce2aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NMouJjwE2yUFRju4lDhu+O6qrTqnq9tfQUTmR19xrL5XmCqKYDH0gU0tJdA1CAO1RBx8IV2uUWqJlWXSzocSuwDjzgf2FW3KcYJM/FeQBF2JYfBGHADX3GYwoq72JlG/lYRgHt7blRrx1wvF8L7G58cO9x6Xxd4xgz17abX/RWoGTCQU5TNKnA3wQYHlEjIGKZp2yjD86O1PvMb/BsM1FAsvLh2RezJdsiMoSVL766uKm0ZrJeYZ27kqFiOt0tFOr+1xdwzcHSYSS+PdKCXI90p/Vv9/2ENe/70M07oF8rCvkRvF9wG9gEUyizp22N+DlRaEibtxKB6AD/rRaYMU7bEwgnL4WOqrxjUgWhRqnJhoqa4KNI9jbjinSVJdKAf0EfN+hCN/6eKv0f+Y6SM4xWxBl8kaLwgYwkhCiaT3YEN7bg8XPQZru6AIQ7nVXFZoU8iqoiGUm4siWT2j6pdYrzlio1yms7+CkSfzL+cAbOvMR1Lr0M9iv68ST1iOluICtI+7CrgfQmocsFkKya0l59mtGmp++V7WRYRXVeugLJY6YJp1adkkd009c6kpys2ZVh8cJcPVlauli8nnhV859w/+ZpYwqrR2hHvnrY7Uvk8vkpatIpqBEUkHNCwOAM2VeGnxkh3/U+DFj3mavUuWMw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(346002)(366004)(396003)(376002)(136003)(451199021)(86362001)(8936002)(8676002)(316002)(31686004)(5660300002)(41300700001)(66476007)(6916009)(66556008)(66946007)(4326008)(2906002)(54906003)(478600001)(2616005)(82960400001)(6666004)(36756003)(6486002)(38100700002)(107886003)(26005)(53546011)(6512007)(186003)(6506007)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MWVKVXEvOXlDaGFGakVBWW11R3JtWXJ1UU9EOWpVRlA1RTUzUVk3Z2FoVVIv?=
 =?utf-8?B?QlAzb3c5RVdZNzd3NUtGMThDWVYzMThEcXdVWEhKRW1hYzhYbDhOVy9sMXVx?=
 =?utf-8?B?MGdhWkFJM0FydHB2cG1YbStHbXh2WVRjS0pqeS8yVW5FVmxzREJEMTZTK3Bp?=
 =?utf-8?B?UGY0TW9lenlGMGQxeUpZdTFURlB0a2M0NjhralZPbGlHUUwreE51bHVtUWk1?=
 =?utf-8?B?Sk56U3BrODRoQXpRRitVa2dSZzhwNTZSbEpPOXlSZGxad0FyVURxcEVodlRC?=
 =?utf-8?B?cDNXdjhISmNqdkhKYWFSUStNWDI1c2l5WE5VRWI3OWdnd1lZSUF5bFdLc2Vp?=
 =?utf-8?B?ZGVOUldPQUFlM1kwQUowTTArRE5CSmtTL29uRm9DNXZTU0R6eWEvaVFXdTVa?=
 =?utf-8?B?Q1h6SktEN2dONUF3SnBsajJDcy8rOWlQV0VId1loamsyNThrZ2VNdW9oUk96?=
 =?utf-8?B?bzRieWFEUUo1OHVBV1NzclpZR05relFuQjdOajVkdW15QUVVdURIdmE3ejU5?=
 =?utf-8?B?amNoZGJjTXFGUnh2SWJvR1krZlV6eWxhK1owdWk4VEpkeHdvVDk2QTgvbVVP?=
 =?utf-8?B?VFY3S2J4TGlrMjdOeEgweEdjbWNmKzBzd0d1Q2VRb0U2clJmdmZBV1JsR0hl?=
 =?utf-8?B?Z3BHbHRWNUlaLzE0TmNKaEFjNDBNMXgzUkZwcmx1VlRkZkZBeTRGWXpMdndy?=
 =?utf-8?B?YTFOTDZxNmlCdk9kUXFDYXRoNFk3TU5leUdUWFRZVnZEMWFBVkwydXV3c3BO?=
 =?utf-8?B?WU1MeXJFVzVERmdOVm43SFkza3JpMkZYTUlkVnhsQ1dQWEEwbC9wZGN4NW1S?=
 =?utf-8?B?MnRtMkM1MWQ1c0FTMVhTY1lhTEYvdjJZWjllbVVJS3NQMitSOTkxZzJrNUJ4?=
 =?utf-8?B?bWRrRmR3MjEzZTJ6bE9iQnAxYWM4ajQySytBSWpVUVVTU0pKTXI0UmsxYWhj?=
 =?utf-8?B?ZWZuZDc4NDJBU1ZEVzNNZ1BWN2Y0TDF6UDdDWGwxb2FLQnYzVzBsNTh1aklv?=
 =?utf-8?B?N0llakxENUFxMXF5dTZZOUhsMHhvZ2FVN29uTkxSQmRBeHhibFQ0czgwSGpJ?=
 =?utf-8?B?bzcrMGZSR3RZYWFJMHhKK3ozQ2p2NitqQkJDQUczQ0lwQ1EybEhER0VKZC9p?=
 =?utf-8?B?NTBpcTVIdEVoalR5YVE3NEkwUzVhblEwZ0U5RDZRb21pSzhOZGxzREs4dW1i?=
 =?utf-8?B?QU9lQklYU3hKVnptL0h0dGh6ODBNeGFvUW91STJaUytxV0dCZFI1REtqMldD?=
 =?utf-8?B?ZUdhdWhyTUtqVk9GR1gvMXlXREZuZVBtWlRkb1ZQQ3laaFd5ZXJVTDhZbWJZ?=
 =?utf-8?B?dEw2YXVCa1hQejZiS1h6eGlWZzdnbVJ5dUthb3R2UWtPbE1BZXIvanpyc0Ev?=
 =?utf-8?B?dEZsenZHM3ZHbENDYllzbEdUZWVNWjM3WUFtb2xDTkdtQXFnT0ltMDdaeGx2?=
 =?utf-8?B?NWxFYWMxVHJxKytQL3dGZTg5SGRETDRWZTIrZmlTakk5TzJTdXhsclQwMmhx?=
 =?utf-8?B?VWF6L283ZGdWUmhSL1c3cStrTEF1WXZZZW9MbTU4WFJZZUxHQlB4dWY5TnlF?=
 =?utf-8?B?MVhIWjJhRVlZN0lpaERaRnUxYXJwL3pvRFNWQzN1K1h5MkcyTnRIejlmVEU4?=
 =?utf-8?B?Y2VEelhBOE9HY1VEb1BMRFFQenovc0k5QmhyUHNrRXZBejJqUGVkMXNVVkFr?=
 =?utf-8?B?ekxKVFh3aS9LbjN6dnhpK1NWNlVMeGNiZm54R2kvN3E5bDdFdWJMSVlUZTVm?=
 =?utf-8?B?Q28yZk0veEt3WW1RV0JrRTFONytpMXdZelYxYmMwRmZzZ2VHTHNVU2wyYm5T?=
 =?utf-8?B?b1h3SmdlaXdKZjFVbThjYmZ3QllQVmdDV1lTeHBISFJkNFRrUlV2dlpkN3pG?=
 =?utf-8?B?dUV0bDRLYVl4Y1hUbWowWkJxUGNOblU0SUVqdHZpbkNjbHU2ZStLcXhTSmc4?=
 =?utf-8?B?YzFXMlNyemZ6WjBCQW1CUkk5VU12WTVCUmF5L2JkZ1M2QVhlejQ0Vkkrelpa?=
 =?utf-8?B?MllmYTRSTTZiZlN0Z2xCUTZlT3NIbjNkOG1DOHNidFVvVGNHSHU4VUY0ZytC?=
 =?utf-8?B?cEZyMk9hRTJsdFlUaUhzOWpRRzZnb0I5Y2pWNjJNUUp3b3pHbFp6WWNjOWo3?=
 =?utf-8?B?QlNleUY0VExpcllwREhsS1IrUDh2WGloWkFldzJzUHlKSGNZMkt3WlRhVG9s?=
 =?utf-8?B?YXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 399a3904-04b7-44e6-1380-08db5dbce2aa
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2023 07:43:24.4196
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vnDX9pPImfFa+5tqIRb77DloOUl87753XkiFz+5BVaDBkRSKnHX4PKwvc1HZN4BOu1DOkltUjPyOXHktvfGDGCoD/P+kAevgZw3qD7e3W9s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4985
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 5/25/2023 5:41 PM, Jakub Kicinski wrote:
> On Thu, 25 May 2023 09:49:53 +0200 Wilczynski, Michal wrote:
>> On 5/24/2023 10:02 PM, Jakub Kicinski wrote:
>>> On Wed, 24 May 2023 18:59:20 +0200 Wilczynski, Michal wrote:  
>>>> Sorry about that, I gave examples from the top of my head, since those are the
>>>> features that potentially could modify the scheduler tree, seemed obvious to me
>>>> at the time. Lowering number of layers in the scheduling tree increases performance,
>>>> but only allows you to create a much simpler scheduling tree. I agree that mentioning the
>>>> features that actually modify the scheduling tree could be helpful to the reviewer.  
>>> Reviewer is one thing, but also the user. The documentation needs to be
>>> clear enough for the user to be able to confidently make a choice one
>>> way or the other. I'm not sure 5- vs 9-layer is meaningful to the user
>>> at all.  
>> It is relevant especially if the number of VF's/queues is not a multiply of 8, as described
>> in the first commit of this series - that's the real-world user problem. Performance was
>> not consistent among queues if you had 9 queues for example.
>>
>> But I was also trying to provide some background on why we don't want to make 5-layer
>> topology the default in the answers above.
> What I'm saying is that 5- vs 9-layer is not meaningful as 
> a description. The user has to (somehow?!) know that the number 
> of layers in the hierarchy implies the grouping problem.
> The documentation doesn't mention the grouping problem!
>
> +     - This parameter gives user flexibility to choose the 5-layer
> +       transmit scheduler topology, which helps to smooth out the transmit
> +       performance. The default topology is 9-layer. Each layer represents
> +       a physical junction in the network. Decreased number of layers
> +       improves performance, but at the same time number of network junctions
> +       is reduced, which might not be desirable depending on the use case.
>
>>>  In fact, the entire configuration would be better defined as
>>> a choice of features user wants to be available and the FW || driver
>>> makes the decision on how to implement that most efficiently.  
>> User can change number of queues/VF's 'on the fly' , but change in topology
>> requires a reboot basically, since the contents of the NVM are changed.
>>
>> So to accomplish that we would need to perform topology change after each
>> change to number of queues to adapt, and it's not feasible to reboot every time
>> user changes number of queues.
>>
>> Additionally 5-layer topology doesn't disable any of the features mentioned
>> (i.e. DCB/devlink-rate) it just makes them work a bit differently, but they still
>> should work.
>>
>> To summarize: I would say that this series address specific performance problem
>> user might have if their queue count is not a power of 8. I can't see how this can
>> be solved by a choice of features, as the decision regarding number of queues can
>> be made 'on-the-fly'.
> Well, think among yourselves. "txbalancing" and a enigmatic
> documentation talking about topology and junctions is a no go.


Sure, thank you for your feedback, we'll fix the documentation and figure out a better
name instead of "txbalancing"




