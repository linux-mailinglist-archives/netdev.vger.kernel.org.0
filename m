Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 276C6638CB6
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 15:49:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbiKYOty (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 09:49:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbiKYOtx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 09:49:53 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E4BF2229D;
        Fri, 25 Nov 2022 06:49:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669387792; x=1700923792;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=axkc8ZKi2ibEnEjw8mPtPP+Z+HfmEOOyMRB+MfnR/gM=;
  b=IgH6+RpSSJJ2/l6j01ab49UQzERzqRUAkWVLBJAODreOYivjbA2qEmE2
   oNB7vd++aCIFdcx+33wtShioZxwwbySnkr7+O6PDQI/edQ4rIAb8zyRfR
   AKj0P/pdg2/wGcqeTJ0i1a6FAqkiAGL+VEnKU9HQC+Vz7ubPb8TBLil4O
   fgFSwTsIHUJLM9yzTm5MRr9Q/ZPKsuEe5GB/pzlrra50b4uwEwoq9R7Hj
   +1ghW8ZbtSataBoz0kDsIarTNa8wj6kKrEoJxo/3FVIc4Ud3VCZVhqQYL
   Zp+52umMuskGDqC777r6+/DTKYISQZAaRf8OMB6KnSzer7oK/ekeslh9d
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10542"; a="316316008"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="316316008"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2022 06:49:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10542"; a="767390535"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="767390535"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga004.jf.intel.com with ESMTP; 25 Nov 2022 06:49:48 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 25 Nov 2022 06:49:43 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 25 Nov 2022 06:49:43 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.171)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 25 Nov 2022 05:44:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hEAf/RMuPLOUNMHc67reUTQrGA3b1QpHvYK5LTjlYclB8vEVrYHC9FRn01r3b3VbksPvQWeqkkbPrLLBLe8dHCKbZPiBdn/n/VWH/xM7ZPX3Cxwl1JbHU+QAq68HlaXlN2HkcKEs2PKXUntVOivEu7vEOOWBN44z+L7tqhVZYtfRpWUnRCxLMCCVkl0Nn0k+951WZfX5nmPGFflW1qP7PyRAST0b3/YKjtQwo4JGWwD1ppkAiVb0FHgbHmqvkHq+UfOw2pGhOMnl8tJFD6ZlGHuZ3urXJSCJYhdGQnLcEKsIL5NlVHUuV/P6XxygUnt3pRuo1EChNvgCkXUB8Wkhvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F7epFhYKaCmytFo1LYzTXAEOGMdtJCd4kZImQAAKP4M=;
 b=UaMJ/VyBKQAaK5MGCMWVtv8xSGKcLTJ7Wf65eZ054a7wiY1Omo0NcJNaSFXRKIMw2vkG1RpMT0M9RiGVCJJ0Mjh1zqxJP6UtmORmKIGniwoPSgHZMxIdhmVCZndjCtAItE3dr2B/N94barHAdLvXCr5+UL4PYyi6m90JGX8BuCYC6VUZVprP3e/M0RrYmVc5bfo94QqJosWmS6Ap1PrxPYd2vmsxBa+jvj5MxbrJYAHwWD+KMdPMbmYgvdEW4j7604L1HxCLRvPp6Tut/WhFlQLJnttZ8wi3tUXypLltRjbsFDFrwA1BIDjgLyGz3Sbw0njehwb92+TIZbIkbif18w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BY5PR11MB4449.namprd11.prod.outlook.com (2603:10b6:a03:1cc::23)
 by IA1PR11MB7175.namprd11.prod.outlook.com (2603:10b6:208:419::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.20; Fri, 25 Nov
 2022 13:44:41 +0000
Received: from BY5PR11MB4449.namprd11.prod.outlook.com
 ([fe80::b289:7d0f:1d94:cd52]) by BY5PR11MB4449.namprd11.prod.outlook.com
 ([fe80::b289:7d0f:1d94:cd52%5]) with mapi id 15.20.5857.020; Fri, 25 Nov 2022
 13:44:41 +0000
Message-ID: <d6555f27-95bf-5474-3006-6f8d399ab556@intel.com>
Date:   Fri, 25 Nov 2022 21:44:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.5.0
Subject: Re: [PATCH bpf v2] selftests/bpf: Fix "missing ENDBR" BUG for
 destructor kfunc
Content-Language: en-US
To:     Peter Zijlstra <peterz@infradead.org>,
        Jiri Olsa <olsajiri@gmail.com>
CC:     <jpoimboe@kernel.org>, <memxor@gmail.com>, <bpf@vger.kernel.org>,
        "Pengfei Xu" <pengfei.xu@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "Martin KaFai Lau" <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        "Chen, Hu1" <hu1.chen@intel.com>
References: <20221122073244.21279-1-hu1.chen@intel.com>
 <Y3zTF0CjQFt/dR2M@krava> <Y3zZQpHNQ8cRjKQY@hirez.programming.kicks-ass.net>
From:   "Chen, Hu1" <hu1.chen@intel.com>
In-Reply-To: <Y3zZQpHNQ8cRjKQY@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0044.apcprd02.prod.outlook.com
 (2603:1096:3:18::32) To BY5PR11MB4449.namprd11.prod.outlook.com
 (2603:10b6:a03:1cc::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR11MB4449:EE_|IA1PR11MB7175:EE_
X-MS-Office365-Filtering-Correlation-Id: 88694d8d-54fc-4505-1dc9-08daceeb3418
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xVgpx5fn9wnfGRq8s+Kgfo3YBO5c3z5NbJO79AJebWtx+hbEiBz/mxZTKbjvYuhbFKw5mNYuD7e+hqbyxlhiT39Mbe2vycvsoZix7LEKb1IZN2wvWm0z/LqJqjn+HtqAIPoOUZZsNfsFTrx0xcamyI6YeCOrZjcp1ToOzC1mg7iyzQDc4AmtpYloCXxK25NHMyrcHbOkvSv3P2/A2giRnJp+8c19h6fl39KB8Efhgxk2kc6tkIzgpN1zF37MNSEjRB2ERKx6NO4spsSluC16WylToi/RmwMpGQ9u8Ji7A2Ra4xRZWbYmpAQJT3dC42+MHnJ8HB3WQV9cfaX15rMzKHxG9pMLlMNPoOafctA41EER9+0FAP9hgPGvoCzq+Fj9I8wuT+VqvWvgSIo9aGLQDk0l2ij1FxlE+NXPYYSLUzfyNnF/naZOLwtxRZX7wsBPW4AOSHfkx9AjozllM6Gn1bUxHhJZHVn/BLmzpIbDzzwqQ18CMpcFxMTrSemiHOcushfqlCkr4DKcZfgwU/VLphtHpqaVJ3rtMS7000jncyF5hZSg6T120hftzVFwnSXP/TueLHDcIRlKhrMtXIYD/MyuACHLyOVsRapmAAmUCJaBsDL4p2LsVWYGrXytJv2etuL7HMdB0KFOroLRca4BkbJq8lcp4tnq8/LHXdxaFvU8E69WL58++x68Ed7cXaeAGgZoARZqTuXZ6y4/JKhMaOtO0X90vaJeh0+XUwRi6Wc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4449.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39860400002)(136003)(376002)(396003)(366004)(451199015)(31686004)(86362001)(31696002)(110136005)(53546011)(107886003)(54906003)(6506007)(6486002)(36756003)(38100700002)(82960400001)(6512007)(186003)(2616005)(7416002)(8936002)(26005)(6666004)(478600001)(66946007)(8676002)(2906002)(66556008)(66476007)(41300700001)(5660300002)(4326008)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eHRMREVHMklVeVB1RStLM0txazRDbGV0cS9HWnM5UE05Q055ZzB6REFMRm9v?=
 =?utf-8?B?SHE1cEFGZW5DKzBNby8vZisxZXVhMmc3NHRiK2hEUjFLelJ3bXZCdXR4Snp6?=
 =?utf-8?B?YWVpWjdqMzFZZW4zQWV6Zm9obFNCbEFTTTF4QWgvQ1NTWEFqSlBoaHp4djkw?=
 =?utf-8?B?WThxNkRhZTJwN3pvYnU4QmhkWmZ6KzJFeVFlTkV4RFI2Nm1XejBrT2VBaTE3?=
 =?utf-8?B?UGd6eitRWUpCNEhBTThhdFRpR0xoNXJtZmJQL0RnY09kS3IwZlJwVkRBalFM?=
 =?utf-8?B?Zng5Zkc5UVE1b3cyV2hBQUhGMVQyeXRXNEpabFNTOUVYcHNSRFpvSjhsdTN2?=
 =?utf-8?B?SUVOY3BRM01Yc1Q0RlFWenY1NEdXL1NxUFhLWk5MeVhDUXVwU0NrdlI5Rldh?=
 =?utf-8?B?dXhtR1A5anNRZ0ZGYnV4NlZTWFpTWXJkNElKZENab2VYd2VUM04rTk5GaHN6?=
 =?utf-8?B?cGN0Z0xKZ0UxQVRITHRXRVJlSXlvM1FNU0pGTHJ3azFnLzh6NWljYW0vd1p2?=
 =?utf-8?B?ZVlUb0xqbWluRDRaUjBWdmZXMnpXK2JJOG1vdTBtZGNyOXlnbk1Ha2x6VFhs?=
 =?utf-8?B?M2JodkF0S0FJdTBzdEJMUEVveitKWFFyVjBhNkNGT2hjZVQ4N1VvSlM3RUVn?=
 =?utf-8?B?TmtHeVoyNmg1N0s2S3dLbTF4ZnpjNkpJSTBTKzY2RHJzcW5rSEQ0Sll6NEkw?=
 =?utf-8?B?TEdORVp1U2tudzVkYTRpTEhWV0RIWFVFckNseXFwRGZ0WXNGd09Db2M2UkJ4?=
 =?utf-8?B?NlQyNHBuTkZiREZyaXBDUUNFMEt2SU1BZlFRZjNZT0RoRU12czNpR0padTd1?=
 =?utf-8?B?RVNCeFB4SFdOSGdmSWxVcWlNOWRWTXhJUzR4MXltcHdoYmZDU2tjRzVOcStH?=
 =?utf-8?B?YnZhdFdGejBjblhxN0RtZU8vRVpOdExLR1Fiejd3TzZkQW4rSU82bS9OVkZq?=
 =?utf-8?B?QTVkSDZ5TngzTGx2WHdLSzNWMVpKZGJBOStua2oxa3hPMTAzU20rRGRzSnAz?=
 =?utf-8?B?RUc3RkNXZkxxalFJOEFoTGk2TjIxU2tQSG1ENFNhWlBtWWk5N2lUc2VtK05r?=
 =?utf-8?B?TlB3SFhxR0JzTFJTUUhZd0NjMW9nZmJxcmZmUGhKeGt0SllUSzlkdFR0TzU3?=
 =?utf-8?B?OHY0Rk1lYUdJbzFkZGlGeDNvVlBHZUZMZ0RZRmkxOFJENUVSS1B1VU9oVlRM?=
 =?utf-8?B?aGpzTEMrYnd0SEt2VUVGMnlJdURwcE1BMHlOQ1FldXUvbDBnZGxLTmllZ0s3?=
 =?utf-8?B?NE5XemNDYmZFTU1GTTV6K1MxcVZZZFgrQW9Ma1dzRTFIRktCK3FMSlVaUmVm?=
 =?utf-8?B?ZndqeXVvSzIwSGEvTi9EZUhReDRsS25aWFR2VkNGK0YvbktSbzdmSllXQUdK?=
 =?utf-8?B?VVdRejRMOTFvcDJWMnFZRDlOUUl1R1FJcUNDcWJQbnZCdzVRTHZlR2VQdkhv?=
 =?utf-8?B?bVFhVzBLVGVPaGJNa1gwVDBISHFWSWJZRUdsVzY1WkhZRlQ0VlljNUMyZDVE?=
 =?utf-8?B?Wko3Q0dvbTY5bU9DUW0zVkhKNERlcFp2Q2k5azZ1SXhEc1JVV042NWNmUCtr?=
 =?utf-8?B?aFdGcDA2TzE5eFoyL2o0cDkwQXU2UzhvWjRVZDZpbllKSGFlTDZST0N4WC9z?=
 =?utf-8?B?c0xDdWVEZEc4Rk04eEhIV0JDTVRURDBBQnFrNm5IdWNmdGxvaC9NWitLbER2?=
 =?utf-8?B?OEdjWXBENTdpYXFDY0NsNmNCOTI3V2x0R0dUVG5TQWxsR1RtekVCVVE4MnBj?=
 =?utf-8?B?dlJ6aUlHTWVCTUR1VzNTNXJiQ1JzenpiOXc5WGJFbkpyVU96Nm5NOHArc3Jz?=
 =?utf-8?B?WElCRUVQL3hybXNpYVhELy8xZ1RLcGxtdnc3REo4Nk9HNDZwRUVLc3hYUVo0?=
 =?utf-8?B?UlQ4ckRyVXFLaS9sbnlQNzZoNWdJaFJSbTA5OU5QTW1mNHNlUzEySDZ2Ym5l?=
 =?utf-8?B?cXRTYVZudzFja3MxUHpZcGlmVk96RVJoWkVqdGtNY1BmbTd1MkpsVE83R1hu?=
 =?utf-8?B?Y3I4RTNyREJuSHpPZVZkR01jUUZxNmVPR2JGSlBlVlVMVUc5bDYyanZ1TFdy?=
 =?utf-8?B?cTdkdE95SlIwVXlmbzB1czYvRjFqeXpaTU9vMWozbFlZU1BTSlphbkRDSkRn?=
 =?utf-8?Q?9e9LBEZQiQ+UkMeoaLxzfexMq?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 88694d8d-54fc-4505-1dc9-08daceeb3418
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4449.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2022 13:44:41.5478
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B4ehlrhFr5SJ9PvV/YLe0taMkyDrHUfeC+1LBzlCO5aBcJ75UNodqP9KpLRlbanVeRk4r6WFr9eK1iHMX7DH4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7175
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

On 11/22/2022 10:14 PM, Peter Zijlstra wrote:
> On Tue, Nov 22, 2022 at 02:48:07PM +0100, Jiri Olsa wrote:
>> On Mon, Nov 21, 2022 at 11:32:43PM -0800, Chen Hu wrote:
>>> With CONFIG_X86_KERNEL_IBT enabled, the test_verifier triggers the
>>> following BUG:
>>>
>>>   traps: Missing ENDBR: bpf_kfunc_call_test_release+0x0/0x30
>>>   ------------[ cut here ]------------
>>>   kernel BUG at arch/x86/kernel/traps.c:254!
>>>   invalid opcode: 0000 [#1] PREEMPT SMP
>>>   <TASK>
>>>    asm_exc_control_protection+0x26/0x50
>>>   RIP: 0010:bpf_kfunc_call_test_release+0x0/0x30
>>>   Code: 00 48 c7 c7 18 f2 e1 b4 e8 0d ca 8c ff 48 c7 c0 00 f2 e1 b4 c3
>>> 	0f 1f 44 00 00 66 0f 1f 00 0f 1f 44 00 00 0f 0b 31 c0 c3 66 90
>>>        <66> 0f 1f 00 0f 1f 44 00 00 48 85 ff 74 13 4c 8d 47 18 b8 ff ff ff
>>>    bpf_map_free_kptrs+0x2e/0x70
>>>    array_map_free+0x57/0x140
>>>    process_one_work+0x194/0x3a0
>>>    worker_thread+0x54/0x3a0
>>>    ? rescuer_thread+0x390/0x390
>>>    kthread+0xe9/0x110
>>>    ? kthread_complete_and_exit+0x20/0x20
>>>
>>> This is because there are no compile-time references to the destructor
>>> kfuncs, bpf_kfunc_call_test_release() for example. So objtool marked
>>> them sealable and ENDBR in the functions were sealed (converted to NOP)
>>> by apply_ibt_endbr().
> 
> If there is no compile time reference to it, what stops an LTO linker
> from throwing it out in the first place?
>

Ah, my stupid.

The only references to this function from kernel space are:
    $ grep -r bpf_kfunc_call_test_release
    net/bpf/test_run.c:noinline void bpf_kfunc_call_test_release(struct prog_test_ref_kfunc *p)
    net/bpf/test_run.c:BTF_ID_FLAGS(func, bpf_kfunc_call_test_release, KF_RELEASE)
    net/bpf/test_run.c:BTF_ID(func, bpf_kfunc_call_test_release)

Macro BTF_ID_... puts the function names to .BTF_ids section. It looks
like:
__BTF_ID__func__bpf_kfunc_call_test_release__692

When running, it uses kallsyms_lookup_name() to find the function
address via names in .BTF_ids section.


Hi jirka,
Please kindly correct me if my understanding of BTF_ids is wrong.
