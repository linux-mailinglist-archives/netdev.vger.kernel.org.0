Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB8D4638B2A
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 14:29:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbiKYN2u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 08:28:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbiKYN2p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 08:28:45 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F5342317D;
        Fri, 25 Nov 2022 05:28:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669382924; x=1700918924;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/vqCLT+dKXnHBh+7jRbjQ3LOthEHiVG4oMwTUU4fzVM=;
  b=Yo8g72Wqu/ErcmHpiV2+Ij1+NJIbeRcHk+mOizVZ6qY6MHyr+gqI1jy5
   3hai5BNYeQI7RTKWFX8PLE6nSIXedSQ9EM3ebMPg3dETYGvzyfLwbzXK0
   ADBKxvcVrcTrcl5YE2HVuGT5TtCkK8ho0DWh9BFZxcoqtzgXuccuP+5s9
   M1aIqG353FXbqXdCU0TjRxtkTyqXA8C9U1q5kKqa0Ir70i+rNiTTHOuu3
   7+aRZt4fo/MSmM4cO3hyo9aludHnv3pk/e/BR3XrwYQ/jASU/1RcN29ZA
   I+1UOngReB1YQxUTCoJ/vzJpBJ/s2VFZn/1GbtfN3RtbNtX9pbUafXnd9
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="297839272"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="297839272"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2022 05:28:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="636574520"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="636574520"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga007.jf.intel.com with ESMTP; 25 Nov 2022 05:28:43 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 25 Nov 2022 05:28:42 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 25 Nov 2022 05:28:42 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 25 Nov 2022 05:28:42 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.108)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 25 Nov 2022 05:28:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MBr4pqUXFY8x2mV/0Y3k0gOyW/TUqPrpxqBKsP2G0CCtkD2ErmhPuWHoVTxrlUb2YeGW01LHJYcGvTOqbMUhwN0GqmXTaGkedDni9Mf6wWvjEp2Q3gnuy1CO0oAae+UB3Atci1gGJ3QiIYzhovJReRt7H/xEOrRnoIkdi52fVXkiPp40C38aBK01zFeUIFOEHrKQIIcLxPEn9Uj5WaDe6iEEbsnJXnQifthyu/z1WBAAofskd6HjYP189W1bC6vkIPNEpm7JiRLZuLlFN+KEm5LEDsxSIsa5h2SRL1laXAJzUXabC1TWYERX3uew7/zPrKxZ+ySKZ/Scv/STqfnFQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IY4LpZY7zgHl1U516OI3jHg6PP2TFg9mAodK3IuCk7w=;
 b=hY99bWAawh/Ay/PzTnnUIVnazTlqhv/fkmO/Yx1E8VCLg9q8dP9v382B+5JI07l3TG68FVB9PGSxSlMVD7WonLtojQt8BIibO5eMc7FGwP0SHQyjmufWqbFxWCHZyFabGBp1un4M1EiP9NTlqvIOHPQ6PUGGRYE1FBFvv2QAGugn7Y/tTW1K1L80zmGtKELJ1HxPY5r3OwtwWefjv4JFCqn/Aon+D+wrJRI8FRQhdCweE2gTzsk4c29iMCySIkwdc1VFKnV/CRdk9taOLtcuYOjqjO9H1MHuGf/S959R5lACaAfaw54pwU9kQGtPFbX3AUOI2CJuFVEmOrsGZ0pEAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BY5PR11MB4449.namprd11.prod.outlook.com (2603:10b6:a03:1cc::23)
 by PH0PR11MB7422.namprd11.prod.outlook.com (2603:10b6:510:285::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19; Fri, 25 Nov
 2022 13:28:40 +0000
Received: from BY5PR11MB4449.namprd11.prod.outlook.com
 ([fe80::b289:7d0f:1d94:cd52]) by BY5PR11MB4449.namprd11.prod.outlook.com
 ([fe80::b289:7d0f:1d94:cd52%5]) with mapi id 15.20.5857.020; Fri, 25 Nov 2022
 13:28:40 +0000
Message-ID: <8b57320c-df41-a19f-e433-07782a709a5c@intel.com>
Date:   Fri, 25 Nov 2022 21:28:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.5.0
Subject: Re: [PATCH bpf v2] selftests/bpf: Fix "missing ENDBR" BUG for
 destructor kfunc
Content-Language: en-US
To:     Jiri Olsa <olsajiri@gmail.com>
CC:     <jpoimboe@kernel.org>, <memxor@gmail.com>, <bpf@vger.kernel.org>,
        "Pengfei Xu" <pengfei.xu@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        "KP Singh" <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Chen, Hu1" <hu1.chen@intel.com>
References: <20221122073244.21279-1-hu1.chen@intel.com>
 <Y3zTF0CjQFt/dR2M@krava>
From:   "Chen, Hu1" <hu1.chen@intel.com>
In-Reply-To: <Y3zTF0CjQFt/dR2M@krava>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR06CA0010.apcprd06.prod.outlook.com
 (2603:1096:4:186::6) To BY5PR11MB4449.namprd11.prod.outlook.com
 (2603:10b6:a03:1cc::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR11MB4449:EE_|PH0PR11MB7422:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f873cd2-fda4-4a1e-3a0e-08dacee8f72a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sLQ/PgQpL5PogIvRAamIzOWLmbp80+8CmwoIUA8HAj3aw03a93feOELQqbTwmQakJo7/+HJyRqyKybpbDYO6NNgXB9qF4bwvkm6csTuC8xmZN7BbA5+1xIO/qMIzOJLTzH7jiV56Yhwl/exABKBqr+bxSDXDVX1aswlJ1xMkVH/tP1mjZUExzhQOFdikjyhQoo81FaG88BZpOIYd5ZtM/Pm1gGq/0h0a+YnKUzNoPMchQCJZUGaqIVKNQx67lhdDwSHi9KB87a4yA5E7kfluO/OBsBurOqscNsITUCy17zGIpC+Lyp+fb0G2KDF3u+y9usTzlN2saj6zdnmaJRe3XwmmV7CzhLE5+HYgMnw3Amt0HOINlLYsYFLlgWnwEPOvfxq38uduZxdN2YrIYYGxwNd2QcK21iVGFRIFKwgEWP9oIvjmpDVjGj30r4g5mdzZ3dQ0MbewI0Ali1Y/SJvw9JD7YA/vb1cPjsUhYgMD3JLT0UYckrDXiOkFRC1RM7IWlUv9ZBSTn2vpOp2N5oZS8HTXB1XqsgaNWxMAL7Jf7KlTWIueKFRhpaD3xOTJmw7L/P1xFUeH/0S/L4JF3n95g8EPqk5Q5KMtsJBaddZgPs/U7GabTrleeoSRyOLY/NNZfgN6T/MclyNwwwChASL+RchW5U57CnEo99XXmOvah+OEYT6Th84udMjTF29VQfBTOdSybw8XQMfv9pHcwefaupGoaxN9uzDFg5jP/zNS1h7KkGJQ4ulL/cS8a8PpqZbu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4449.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(376002)(366004)(346002)(136003)(451199015)(31686004)(2906002)(36756003)(5660300002)(8936002)(7416002)(41300700001)(107886003)(6666004)(6512007)(26005)(53546011)(2616005)(66476007)(31696002)(186003)(4326008)(8676002)(6506007)(66946007)(66556008)(86362001)(6916009)(54906003)(316002)(82960400001)(478600001)(38100700002)(966005)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QUNKallyNGY1ci81TEVrRVliSVZLVDhPcUcwdFJpRk1vdGpkRDlacERDWXlo?=
 =?utf-8?B?cXd5Vm92bjZZOW9RR2w0THF5ZjFlTEdDTkFUNFE2d0JNeHhjc1pWRDdMMDJO?=
 =?utf-8?B?UC8xdlQ4VUY2bFRTRndMY1BBTzJDUDB4bUY4R1dpZFVieVNTcHNOazE4V3BU?=
 =?utf-8?B?OXZ6QXY3RWZqS1RGM0w1YVJRV2RjcUYxZU5VNG41bWIwQ3QrWUN6eEJIL2x2?=
 =?utf-8?B?SzRlZGxHTTg2K2IwVmdjNWZZWm5OcGpEdFJUemN1KzJsK2hDaXRQWHNMKzlu?=
 =?utf-8?B?a1JLR005blRHdVZnd2p6NU15RjUvb1pGWFpkZFJJY1BlVG96MkF1UnM1OUc0?=
 =?utf-8?B?d2VEVjFkSTlZME0rdG1PZHhFMXk3Ym42eHhZMjVJNm5BcmRYYmNlZk9abDlv?=
 =?utf-8?B?U3BtQXlKQVlGcUFzV2wrM3Y0U3BBQU9MeFZrYmh3bzlUUk82K2grWTM1SVNL?=
 =?utf-8?B?dHh0bk96VXBHeTh3K1k1bTl5U0czK0twZUJSVGdjVUwzeEdXVGQ5bzd2N1lm?=
 =?utf-8?B?cG5EMzJPK0ZUOG9FWXF1aHBSU0pIRGhNQkdOZE51QTFSZk1wWkR1L2MreTZh?=
 =?utf-8?B?ZEVrSmdnam54M2dMUU44bndESWZ5Tnc1Mk1neVFjRVQ5TFQ3RE54U2hadHZE?=
 =?utf-8?B?RG15ZEphMHZXMHc1SUJabGlzeGx6REVrVU5uNWF3RGpOZG9TdTR1UkEwSjVz?=
 =?utf-8?B?Y3VIc0ZkVTBTNUl3Y0RCY0JXdnU5VFlGdVBvVlM1SWMvZjNuUjBCbm1obG10?=
 =?utf-8?B?YlFSVzc5djNha2xMZWNjKzB1SFJsdm51R3JJVEVJQ3lEMUpLbWtGWWpEMk5y?=
 =?utf-8?B?ZDlKUFlSbUljb0pGUkxuYllaNVluajFFVmhXMjdwZlRpQ3ZsK3JSb1ZOcVpi?=
 =?utf-8?B?VHVUNmhpazJ5cENwbFErOEZUK0lLdGNjOHMxYXlvZzVVRGZ1QTRaMjFSd3RC?=
 =?utf-8?B?RHlpMzZJaWR6UDhNbzZWZ0dKWS80b2lQczlVR2RLbUtiMWlHSnRYYzlCaldu?=
 =?utf-8?B?TlIwTmxUL2FHOTFuQkVEZ2ZkSjgvSDl0UGh1V3ZFSVBMNWZDdXRxQjZ4MjJD?=
 =?utf-8?B?NlRtUmJsc3h6TjFhdVhRa0lCQkZFT2tMQUdrYzY1UWRPMEJsVncwOG9GZURI?=
 =?utf-8?B?UXBneWJxZ09BMGgzeTYwVWJIenBPRnNSb0RWSHlnV3hzZHJoSGJsS0hGNjBQ?=
 =?utf-8?B?cis5TDZoSEE4NHZ3ZlVDQWNuMkhVMnhJcmkwTEZMTG9RcW43S1k5SEdVZ0tE?=
 =?utf-8?B?NFQyaWVzbWJmNVp4N0J4enBoR1JyVk5TWlpmdHNpNEpoeHR0RTRtSFREaDk5?=
 =?utf-8?B?MXpNcGZmQkNuejl3NXNlS1o0Nmd4aVYzWStpWG5zQm5RWitDbG5OQ2pnY3Fr?=
 =?utf-8?B?RllDd1IwVVZYeVZJRHNZckhteG1OVTc1UmlreCtoVkhrc1dqRlFFc3Irdk1Y?=
 =?utf-8?B?Q1ZxWForYzF1c2xyaUNWTi9PMFJGTDdaV1pRQW5TUzFzTnVRcDhNZFpHUmpJ?=
 =?utf-8?B?d2FWcWRidlgzSlc4dUprb2poUWVWdVcxQjRicHZseUdYWWc0OHI2MzlpSmxr?=
 =?utf-8?B?azg5dml4cVFCWkZoKy9kOWRjZ0E0N0cxN0U5ZDRXTmZ2NjNOTU9GYUFOU0JZ?=
 =?utf-8?B?cmJ6Um80WkViMkpTNjBsNHFFbzlmbDBYOWF3NmpWYU1vSWZhMUhvYWp3UXRW?=
 =?utf-8?B?UjV1Q1RycjhqSHJNWGdVQ202aTJKallpeGJ2ZkQvMXg0THc0bW1WaVpFSTk2?=
 =?utf-8?B?QzdjVlZYUEpKSHBkbi8walpHNU8zd1ZXUHdiUDJBR3k0M3RRWEl5YUtWUTF3?=
 =?utf-8?B?SjJFcXpYMHYrZzBIcnBJOGxrR0ZpQnBuZW9lZmx3d1lrVXNEa05XL1FtSVRS?=
 =?utf-8?B?TEwrY1VJZGZQSE9DdkE2MGhNUURacHN0c0ZtUEMrVjZXMlE0dzNlMWYzdVFk?=
 =?utf-8?B?cjdVNVpkSTVjRHVuZTJrYzJtOHZzcUVleUJpcHB0aTRBaWt0VjZZWGpJU0pQ?=
 =?utf-8?B?Z3NadVBFQnRoMHZMRnUzNytURjhLQXRHK1UyL2twTVNoSE1IcU5zcHNkT2dn?=
 =?utf-8?B?YkxYaGYvYTZiVjYzc2Y4TU9pb0Z5YStHTFJKdnRSK2VaSTlXYk15ZTYvdUZT?=
 =?utf-8?Q?XqU5FwCBjDsyWd1msRLGcLFH9?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f873cd2-fda4-4a1e-3a0e-08dacee8f72a
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4449.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2022 13:28:40.3633
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vcL5AYhKbnlmDcvk1PvmCbU2FqgX1BYwpNoA7uKrQvulxvGvcZvgG2fMnNMb+innQdFmaubi2FuUP6WM1eXG3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7422
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/22/2022 9:48 PM, Jiri Olsa wrote:
> On Mon, Nov 21, 2022 at 11:32:43PM -0800, Chen Hu wrote:
>> With CONFIG_X86_KERNEL_IBT enabled, the test_verifier triggers the
>> following BUG:
>>
>>   traps: Missing ENDBR: bpf_kfunc_call_test_release+0x0/0x30
>>   ------------[ cut here ]------------
>>   kernel BUG at arch/x86/kernel/traps.c:254!
>>   invalid opcode: 0000 [#1] PREEMPT SMP
>>   <TASK>
>>    asm_exc_control_protection+0x26/0x50
>>   RIP: 0010:bpf_kfunc_call_test_release+0x0/0x30
>>   Code: 00 48 c7 c7 18 f2 e1 b4 e8 0d ca 8c ff 48 c7 c0 00 f2 e1 b4 c3
>> 	0f 1f 44 00 00 66 0f 1f 00 0f 1f 44 00 00 0f 0b 31 c0 c3 66 90
>>        <66> 0f 1f 00 0f 1f 44 00 00 48 85 ff 74 13 4c 8d 47 18 b8 ff ff ff
>>    bpf_map_free_kptrs+0x2e/0x70
>>    array_map_free+0x57/0x140
>>    process_one_work+0x194/0x3a0
>>    worker_thread+0x54/0x3a0
>>    ? rescuer_thread+0x390/0x390
>>    kthread+0xe9/0x110
>>    ? kthread_complete_and_exit+0x20/0x20
>>
>> This is because there are no compile-time references to the destructor
>> kfuncs, bpf_kfunc_call_test_release() for example. So objtool marked
>> them sealable and ENDBR in the functions were sealed (converted to NOP)
>> by apply_ibt_endbr().
>>
>> This fix creates dummy compile-time references to destructor kfuncs so
>> ENDBR stay there.
>>
>> Fixes: 05a945deefaa ("selftests/bpf: Add verifier tests for kptr")
>> Signed-off-by: Chen Hu <hu1.chen@intel.com>
>> Tested-by: Pengfei Xu <pengfei.xu@intel.com>
>> ---
>> v2:
>> - Use generic macro name and place the macro after function body as
>> - suggested by Jiri Olsa
>>
>> v1: https://lore.kernel.org/all/20221121085113.611504-1-hu1.chen@intel.com/
>>
>>  include/linux/btf_ids.h | 7 +++++++
>>  net/bpf/test_run.c      | 4 ++++
>>  2 files changed, 11 insertions(+)
>>
>> diff --git a/include/linux/btf_ids.h b/include/linux/btf_ids.h
>> index 2aea877d644f..db02691b506d 100644
>> --- a/include/linux/btf_ids.h
>> +++ b/include/linux/btf_ids.h
>> @@ -266,4 +266,11 @@ MAX_BTF_TRACING_TYPE,
>>  
>>  extern u32 btf_tracing_ids[];
>>  
>> +#if defined(CONFIG_X86_KERNEL_IBT) && !defined(__DISABLE_EXPORTS)
>> +#define FUNC_IBT_NOSEAL(name)					\
>> +	asm(IBT_NOSEAL(#name));
>> +#else
>> +#define FUNC_IBT_NOSEAL(name)
>> +#endif /* CONFIG_X86_KERNEL_IBT */
> 
> hum, IBT_NOSEAL is x86 specific, so this will probably fail build
> on other archs.. I think we could ifdef it with CONFIG_X86, but
> it should go to some IBT related header? surely not to btf_ids.h
> 
> cc-ing Peter and Josh
> 
> thanks,
> jirka
>

The lkp reports build success because X86_KERNEL_IBT alredy depends on
X86_64.

Currently, arch/x86/include/asm/ibt.h which defines macro IBT_NOSEAL is
x86 specific. How about we just put asm at test_run.c directly (ugly?):

#if defined(CONFIG_X86_KERNEL_IBT) && !defined(__DISABLE_EXPORTS)
asm(IBT_NOSEAL("bpf_kfunc_call_test_release"));
asm(IBT_NOSEAL("bpf_kfunc_call_memb_release"));
#endif

thanks
Chen Hu

> 
>> +
>>  #endif
>> diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
>> index 13d578ce2a09..07263b7cc12d 100644
>> --- a/net/bpf/test_run.c
>> +++ b/net/bpf/test_run.c
>> @@ -597,10 +597,14 @@ noinline void bpf_kfunc_call_test_release(struct prog_test_ref_kfunc *p)
>>  	refcount_dec(&p->cnt);
>>  }
>>  
>> +FUNC_IBT_NOSEAL(bpf_kfunc_call_test_release)
>> +
>>  noinline void bpf_kfunc_call_memb_release(struct prog_test_member *p)
>>  {
>>  }
>>  
>> +FUNC_IBT_NOSEAL(bpf_kfunc_call_memb_release)
>> +
>>  noinline void bpf_kfunc_call_memb1_release(struct prog_test_member1 *p)
>>  {
>>  	WARN_ON_ONCE(1);
>> -- 
>> 2.34.1
>>
