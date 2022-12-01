Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27FD663EAD6
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 09:08:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbiLAIIb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 03:08:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbiLAII0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 03:08:26 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAF921F60B;
        Thu,  1 Dec 2022 00:08:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669882099; x=1701418099;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2gFs3W7MYkk1B5SD9I2EbsOSrbW0y4TVb+KifNieP/4=;
  b=Jt51JekTxm8Pau1fMX97rntnj8w0Sllq70pNhQAFfY4in+OgJMzz3DZb
   Oz9t5vDEmwslTbpDCJiOQAe9daDlRH47H0nuWg6Z92F3rAKUDRsBxONBm
   YdorD/9jxEoEH5SrlkLlhHwmzX8iP9meoX/k9zwoqhs69zDo/76MOeQ5u
   IM6o6vbVQDTQiZV26xw1D/zEgUoT5RoYABrY0FQjYECXHuGYVToXsN0X4
   B1pwkSmG7YDlwIUxsx+0965+Spp0PskdSykVxo/BZNqpslm9IFEDBgEdQ
   YpHRs+HHxdR0jIL4ycJWXRKRx8P0/TguAAvpHRyhUOivF2/MIBS9me3pj
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="295314768"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="295314768"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 00:08:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="707975210"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="707975210"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga008.fm.intel.com with ESMTP; 01 Dec 2022 00:08:14 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 1 Dec 2022 00:08:14 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 1 Dec 2022 00:08:14 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.105)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 1 Dec 2022 00:08:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dFZxgyYuuauHZX2FgyRb/uTV7O0TpeXhTNH83KH2dko2tQVS/+6V5v2PT1cjUuCbIgEAMOFb1rclfdBEzhHHkj/gx7A8YFG8ohP+t6oyI8GxNBtbkRl5jay4DM/GogUbtuBMpBA7jRhPnHQ2EVsGdRS6iV2xO0MlW7RGE3MJPCZCniW1veJaO4zE1mGn2yARr4LXj5KMcUfig9tP6iWbni/Rcm13XtTUUE7ChGllRVPCCCWmzFxh+UTa0KaE4SeLaMxGEZHoAWRG5VnAjBt8brpIrjcfozQhNKW0jkGtRFyCbAj3RIjVhZm9iOsM/KG3WNSD50RdUaDKTqzp7LU/Qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sNsyP6/qFsOfwZpGO/5tL2QQYccXRJTMG1K87O2ea80=;
 b=NbK7JZ8mq99JQJ75qCMZwb7GbkEJAX8HlBvj1SGAjAqOSTIi8/3rVXpa46qbOZF76jYmX8h0Dznoxalsq1exbLq5aVVL2h7qICuH1qMsqYFuu5Kp7FnCVphIavoxeAA/rIHUyPaiwD30Fo75Mcjy7zyoQAqx0M3dF6BwPy3oO+vpWgnSi1lH+oyXQmAs7wpw26P+x1VI/K1LdjcWcsgws/L/CnckkmJHk5KBzSx9uwrxvggtTngj0B9ydGSvTR3AYGJDEpJnT/N4KVWKhFyuut7BgzCpaaDqVolGboQZUtTbxcuPaNFVXMPfHENQqt7obr6dooPvz7emOKcwQTs6/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BY5PR11MB4449.namprd11.prod.outlook.com (2603:10b6:a03:1cc::23)
 by SJ1PR11MB6274.namprd11.prod.outlook.com (2603:10b6:a03:457::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Thu, 1 Dec
 2022 08:08:11 +0000
Received: from BY5PR11MB4449.namprd11.prod.outlook.com
 ([fe80::b289:7d0f:1d94:cd52]) by BY5PR11MB4449.namprd11.prod.outlook.com
 ([fe80::b289:7d0f:1d94:cd52%5]) with mapi id 15.20.5857.023; Thu, 1 Dec 2022
 08:08:11 +0000
Message-ID: <aadf45b9-b6e1-256d-c618-31b65e9f7161@intel.com>
Date:   Thu, 1 Dec 2022 16:07:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.5.0
Subject: Re: [PATCH bpf v3] selftests/bpf: Fix "missing ENDBR" BUG for
 destructor kfunc
Content-Language: en-US
To:     Yonghong Song <yhs@meta.com>
CC:     <jpoimboe@kernel.org>, <memxor@gmail.com>, <bpf@vger.kernel.org>,
        "Pengfei Xu" <pengfei.xu@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Kees Cook <keescook@chromium.org>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>
References: <20221130101135.26806-1-hu1.chen@intel.com>
 <a1745d9b-4bfc-50d2-8da6-7631ae2b24d0@meta.com>
From:   "Chen, Hu1" <hu1.chen@intel.com>
In-Reply-To: <a1745d9b-4bfc-50d2-8da6-7631ae2b24d0@meta.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SGAP274CA0011.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::23)
 To BY5PR11MB4449.namprd11.prod.outlook.com (2603:10b6:a03:1cc::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR11MB4449:EE_|SJ1PR11MB6274:EE_
X-MS-Office365-Filtering-Correlation-Id: b453079a-d770-452b-b041-08dad373302a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mEMvqDOphRTRlNbwTKKzjbfm0+NFl9/J3hb1xTfy1o5MmFGq9WDfIBz3vC0ZIfCmNt/UvgtGWfYrhI3WWXvsd/OBklLi5elnOwHMMKaHgMRGARKoWNJXWNBzmK2DJuE8WchHVEjY/QzqpLEwUWV4RoUSwrBTUqH1cXYydDpdyHbFzvGDFL9VYi5ItEICEIBWNqtw6VEOOz/gbsxQ8kydpTRvETA80ZvI8JfeWKTqVayoz3+N6z0W8zmQHuW5Jx9iJBSuTBukQBUqtiEHSGtHKctz9hbeW6lZ1WPUEHWE9KUfxLMtOy8DP0DTn0MmwR73YWlYIOdL0cJ64yG0VUYk7y6PIP2J2x8BSj7ZlmhzUFbW+EqNmjar92pts7mgBXd+P8IbHGUIfE97WXaXvzfm1Vf2qYu+T+lWN5NVlfEjM7PZcg9D/URksCoJj2dQOScU8W+RVLa6A4oXXEkUqFVoL/KrCLFTk837jMrUmtdOF3lrTCOaOooXfIyNSZTsWJKVHHTcJUJ78JoYonZcIU04sAhfTaDNTNbgeBDGnnxFmqH83tiE27riN7iYxzc6Nqa+f7BP3h89sySrWklFoavzGQZ+MxnN7loGVLwdjygNiqWZ4EH0HpTqWuEeToJXvK6/hIBkD3R7Y+QeGl0tarNOQc+a8Jxv8yTZXGdW4ccEm/dvootpIGooMSwDT6vgY9QWLWbja6DIqzhbkVuM6ZrTTeL6i7lhJNec2k7B3TliAzmyTbuUjlrOWFVBCZIt2gHjXYyuIaQmHzR7MYVUQ9w6uUDPI/Hpli0KoEzqg0yMva5JveQyAuUuhE4hKqWOb9dL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4449.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(346002)(396003)(376002)(136003)(451199015)(86362001)(31696002)(41300700001)(83380400001)(38100700002)(2906002)(7406005)(66476007)(6916009)(7416002)(82960400001)(6506007)(5660300002)(6666004)(8676002)(4326008)(53546011)(8936002)(6512007)(186003)(26005)(2616005)(316002)(966005)(66946007)(478600001)(6486002)(54906003)(66556008)(36756003)(31686004)(21314003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eVdObEc3RVIwaTJEeFdHQUJvbkJwOUUrdEozR2JVQUYyVzV1Njhqc1RaL3dF?=
 =?utf-8?B?WC9OVmZQbVdBYWJLTWVhdjNrbDk4c0lXSUZJM3RtREVXQVBmTUhhajhMU3Uz?=
 =?utf-8?B?T1NqVDlmMmwxa3dKbGtNNDFYWmNLek52aGMrbnYrbnhiUnFadXN1VzU5aTdZ?=
 =?utf-8?B?dFl4NVpEL0lNby9RTkQxSTlMRXNaeG0vZVlVVUozL1NlSTFKQ3RXR2FQTzZX?=
 =?utf-8?B?QkJZM0MvVkZpMllPdWQ5WHZ5R0MwVXZjTC9MNlZjTXdjZzUvWGw4OUZocnVI?=
 =?utf-8?B?N0Z0K21LL3RrMUZla2xpMUQrSjNuZldDS2ltb0RnOFg1QVRnbm5tNjZCVVJO?=
 =?utf-8?B?dHZjTmV0NXNYbHE3TVJZaXdvYS94TzBQNXhiSkNJU2RRVkE0QzJhOFJUNnF1?=
 =?utf-8?B?RXFWdGJaMlZ1akNJbHBuVWlWWFQxcVFoYlpTTWtzZmlHeWwwbHpvdDNiRmlw?=
 =?utf-8?B?dHI5dXZLZkFTS1pKa0xtUEZxWXdtSSs4TUpaWGlZbFR1eWNvT3Qrcm10U3JS?=
 =?utf-8?B?MVNuMTgwaWVDbUN3ZTFIMjliS3NJaGV6bmRLTmVVYmhHaXBNTVNzVTV3Z3JC?=
 =?utf-8?B?YVBocExPNjd3aDJ0dnZaSDU5V1AvMmptMG5YZytHc0FMd3U4R3Bja0N5N1dG?=
 =?utf-8?B?RzN3S3YxZVpkYi9oSjNLVldIZzUvdVRxbTIraG41TjZFenNwQzJ2QWw2Vzl6?=
 =?utf-8?B?cUZuc2R1bk44cC93a28rd3pmVkRLY0ExTmFmYUJNYjd2cG9Jakw4YjFLOGFT?=
 =?utf-8?B?RWszVlh5U0ZxcERDQ1oxcndwMDExYTJVMXZJVW9RVEZtb3F3VEYwcVBKQVdC?=
 =?utf-8?B?SmFpTHFGL21oeEZmZ0N4QWlsVXlxY0xlMG9uNW5DS1d0cmN3SVRhQWp6RERR?=
 =?utf-8?B?SDExVm5MQnNkODFad2RUMnRVUTd3ay9RdWI0Zy9Sck01T1ZNQlJGQzI2Qzk1?=
 =?utf-8?B?NEc2NEROWVAxS0lxWTBONlkvblhlUXNXV3VON2toaldtUy9uZG9PQ3E4KzNU?=
 =?utf-8?B?bS9adDJYSGtIZzhHbkdWQTVkQ29MTU01M2NKMDhSWGdxaWh0NGRyZlpuMmNN?=
 =?utf-8?B?ZjdzaUxobWVHbElkeWZSaldVSmY3bDBYa296ZDN1ZDBXSkxvSm04bElMWkpY?=
 =?utf-8?B?OUFrdVBIUm1RK1YxOXhYQ2U1TVo2Q2NKOUNuZTJXL0ZlZDB6QmJGZUxZNll1?=
 =?utf-8?B?NkRCa0plZUh0c01MLzRCd25vUkg1MjNqbDRnY1ZHT2w2cThnOTBBNTY4Y3Nn?=
 =?utf-8?B?RE56akFPRXpQdWg4a3drR1d2VVNZeHBTNGZUcHhrVUVYVmdFL20zUlYzZkxu?=
 =?utf-8?B?aW1HQ2x5YklXZWNSRzVjNFhCQnZnNEJyOTJFUDN0Qmc3N1JDT1pLd0tOOEdG?=
 =?utf-8?B?amxPaDVYbnpEMGFYQ0s5dlFRbWk0eGJBeHJFTjljcjR3QVltZG9ROEdRYlZQ?=
 =?utf-8?B?T1JKckhVMGNqeTVLMGo1ejFtSVpsVVg3ejNBYjZUWTZWR2E0b2VIZnVJRUs3?=
 =?utf-8?B?d1BzN2FSQXoxWHYxZUpUdndUVHhlaEtuWFpHem5INC9RRnduNXFCc2MyVm5L?=
 =?utf-8?B?ZUdzSUZ3RnlEUHlzR2swNVMvSnBXVllKUmFzd3d3NUEvay92a3NSNjEvQnVu?=
 =?utf-8?B?bzdjT3owRndqYWg2SXVQamNuZlVybVBMQndGTER2Vkg2RkhrYlBwN2JQeW5a?=
 =?utf-8?B?WkY0YXQ0Zzh5TW8zalBHM1QyYnUyQWJCSDVSWnkycVNSN0U0MDlJYjkxeGZm?=
 =?utf-8?B?cE05dkpEdXMwTXdWTlIxd2c1Q3VISFRCalJWSWFwY0U1WFVtSzM3QXNHUDdW?=
 =?utf-8?B?aFQxMFRWaXltRDJHN1YySnJtUEp0M25BSXd2Q2JscjBkK3B3bzR3VWNOTkJM?=
 =?utf-8?B?WXNscXVvOVcrT1NacitYODF6NDNuc2M4Ui94eERuTEUxNGxIbWNnQnFMbCth?=
 =?utf-8?B?Tk5ST3JGTTcvK1FMRE51eXpGNEhWOFV1RVh1Tnp4eW0vZy9Nb21GblEydkhV?=
 =?utf-8?B?WEwxd2YzSTlYbVpwN3J5OFVEczZ3N2owZHJlRG0zVGhlM1dzUUpyQjNXNGtL?=
 =?utf-8?B?RXpEclJjU1lPd3pCLytLS251R0pFV1NRN24zcnozMW5HdkwrakpOV2hXOUxD?=
 =?utf-8?Q?1TI2r/oHBkMprDsN5LfFN6wVw?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b453079a-d770-452b-b041-08dad373302a
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4449.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2022 08:08:11.3681
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dlBwyKA12CauRR9046yawyBTaZronrFdvkCpCf+INd/Ar1zTa5tE3SVRsMkM6u2E+gARskqD/U69KyLsT0Jl2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6274
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/1/2022 12:52 AM, Yonghong Song wrote:
>  
>  
>  On 11/30/22 2:11 AM, Chen Hu wrote:
> > With CONFIG_X86_KERNEL_IBT enabled, the test_verifier triggers the
> > following BUG:
> >
> >    traps: Missing ENDBR: bpf_kfunc_call_test_release+0x0/0x30
> >    ------------[ cut here ]------------
> >    kernel BUG at arch/x86/kernel/traps.c:254!
> >    invalid opcode: 0000 [#1] PREEMPT SMP
> >    <TASK>
> >     asm_exc_control_protection+0x26/0x50
> >    RIP: 0010:bpf_kfunc_call_test_release+0x0/0x30
> >    Code: 00 48 c7 c7 18 f2 e1 b4 e8 0d ca 8c ff 48 c7 c0 00 f2 e1 b4 c3
> >     0f 1f 44 00 00 66 0f 1f 00 0f 1f 44 00 00 0f 0b 31 c0 c3 66 90
> >         <66> 0f 1f 00 0f 1f 44 00 00 48 85 ff 74 13 4c 8d 47 18 b8 ff ff ff
> >     bpf_map_free_kptrs+0x2e/0x70
> >     array_map_free+0x57/0x140
> >     process_one_work+0x194/0x3a0
> >     worker_thread+0x54/0x3a0
> >     ? rescuer_thread+0x390/0x390
> >     kthread+0xe9/0x110
> >     ? kthread_complete_and_exit+0x20/0x20
> >
> > It turns out that ENDBR in bpf_kfunc_call_test_release() is converted to
> > NOP by apply_ibt_endbr().
> >
> > The only text references to this function from kernel side are:
> >
> >    $ grep -r bpf_kfunc_call_test_release
> >    net/bpf/test_run.c:noinline void bpf_kfunc_call_test_release(...)
> >    net/bpf/test_run.c:BTF_ID_FLAGS(func, bpf_kfunc_call_test_release, ...)
> >    net/bpf/test_run.c:BTF_ID(func, bpf_kfunc_call_test_release)
>  
>  We have some other function like this. For example, some newly added
>  functions like bpf_obj_new_impl(), bpf_obj_drop_impl(), do they have
>  the same missing endbr problem? If this is the case, we need a
>  general solution.
>

bpf_obj_new_impl(), bpf_obj_drop_impl() also miss the ENDBR. Below is
the disassembly on bpf-next kernel:

(gdb) disas bpf_obj_drop_impl
Dump of assembler code for function bpf_obj_drop_impl:
   0xffffffff81288e40 <+0>:     nopw   (%rax)
   0xffffffff81288e44 <+4>:     nopl   0x0(%rax,%rax,1)
   0xffffffff81288e49 <+9>:     push   %rbp
   ...

(gdb) disas bpf_obj_new_impl
Dump of assembler code for function bpf_obj_new_impl:
   0xffffffff81288cd0 <+0>:     nopw   (%rax)
   0xffffffff81288cd4 <+4>:     nopl   0x0(%rax,%rax,1)
   0xffffffff81288cd9 <+9>:     push   %rbp
   ...

The first insn in the bpf_obj_new_impl has been converted from ENDBR to
nopw by objtool. If the function is indirectly called on IBT enabled CPU
(Tigerlake for example), #CP raise.

Looks like the possible fix in this patch is general?
If we don't want to seal a funciton, we use macro IBT_NOSEAL to claim.
IBT_NOSEAL just creates throwaway dummy compile-time references to the
functions. The section is already thrown away when kernel run. See
commit e27e5bea956c by Josh Poimboeuf.

> >
> > but it may be called from bpf program as kfunc. (no other caller from
> > kernel)
> >
> > This fix creates dummy references to destructor kfuncs so ENDBR stay
> > there.
> >
> > Also modify macro XXX_NOSEAL slightly:
> > - ASM_IBT_NOSEAL now stands for pure asm
> > - IBT_NOSEAL can be used directly in C
> >
> > Signed-off-by: Chen Hu <hu1.chen@intel.com>
> > Tested-by: Pengfei Xu <pengfei.xu@intel.com>
> > ---
> > v3:
> > - Macro go to IBT related header as suggested by Jiri Olsa
> > - Describe reference to the func clearly in commit message as suggested
> >    by Peter Zijlstra and Jiri Olsa
> >   v2: https://lore.kernel.org/all/20221122073244.21279-1-hu1.chen@intel.com/
> >
> > v1: https://lore.kernel.org/all/20221121085113.611504-1-hu1.chen@intel.com/
> >
> >   arch/x86/include/asm/ibt.h | 6 +++++-
> >   arch/x86/kvm/emulate.c     | 2 +-
> >   net/bpf/test_run.c         | 5 +++++
> >   3 files changed, 11 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/ibt.h b/arch/x86/include/asm/ibt.h
> > index 9b08082a5d9f..be86dc31661c 100644
> > --- a/arch/x86/include/asm/ibt.h
> > +++ b/arch/x86/include/asm/ibt.h
> > @@ -36,11 +36,14 @@
> >    * the function as needing to be "sealed" (i.e. ENDBR converted to NOP by
> >    * apply_ibt_endbr()).
> >    */
> > -#define IBT_NOSEAL(fname)                \
> > +#define ASM_IBT_NOSEAL(fname)                \
> >       ".pushsection .discard.ibt_endbr_noseal\n\t"    \
> >       _ASM_PTR fname "\n\t"                \
> >       ".popsection\n\t"
> >   +#define IBT_NOSEAL(name)                \
> > +    asm(ASM_IBT_NOSEAL(#name))
> > +
> >   static inline __attribute_const__ u32 gen_endbr(void)
> >   {
> >       u32 endbr;
> > @@ -94,6 +97,7 @@ extern __noendbr void ibt_restore(u64 save);
> >   #ifndef __ASSEMBLY__
> >     #define ASM_ENDBR
> > +#define ASM_IBT_NOSEAL(name)
> >   #define IBT_NOSEAL(name)
> >     #define __noendbr
> > diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> > index 4a43261d25a2..d870c8bb5831 100644
> > --- a/arch/x86/kvm/emulate.c
> > +++ b/arch/x86/kvm/emulate.c
> > @@ -327,7 +327,7 @@ static int fastop(struct x86_emulate_ctxt *ctxt, fastop_t fop);
> >       ".type " name ", @function \n\t" \
> >       name ":\n\t" \
> >       ASM_ENDBR \
> > -    IBT_NOSEAL(name)
> > +    ASM_IBT_NOSEAL(name)
> >     #define FOP_FUNC(name) \
> >       __FOP_FUNC(#name)
> > diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
> > index fcb3e6c5e03c..9e9c8e8d50d7 100644
> > --- a/net/bpf/test_run.c
> > +++ b/net/bpf/test_run.c
> > @@ -601,6 +601,11 @@ noinline void bpf_kfunc_call_memb_release(struct prog_test_member *p)
> >   {
> >   }
> >   +#ifdef CONFIG_X86_KERNEL_IBT
> > +IBT_NOSEAL(bpf_kfunc_call_test_release);
> > +IBT_NOSEAL(bpf_kfunc_call_memb_release);
> > +#endif
> > +
> >   noinline void bpf_kfunc_call_memb1_release(struct prog_test_member1 *p)
> >   {
> >       WARN_ON_ONCE(1);
