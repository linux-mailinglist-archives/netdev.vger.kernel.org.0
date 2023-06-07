Return-Path: <netdev+bounces-8937-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FFA87265BC
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 18:20:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9A3062812F4
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 16:20:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E459A37329;
	Wed,  7 Jun 2023 16:20:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6D05C8CA;
	Wed,  7 Jun 2023 16:20:32 +0000 (UTC)
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BE0D199D;
	Wed,  7 Jun 2023 09:20:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686154831; x=1717690831;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=oATLTFPiEhxtm7BkGsGRbc8I3UyLxNW78ARqJiUpXd8=;
  b=aG19j65N5OYt//nB2EmI+7EKP2jRXgLt4P4BY2qhI/wh102pJtnIBD2n
   AVy0eEZb3S1s8Uko8C3HDU0svSyuGL6fuAlBqeWpEeZ48qNhnClef1meH
   QyScmjp1N4D/PEVhWpT/2nu4t5AHpyqSleSLgn0w1vKd3Skv2hSxjgDbX
   CFC3Cq20Bg7GJo9KAgl86bYfmGrUR46YrrRX0M3ZdmEyDp/naVhaIIt3Y
   43RqT7lQXqB0j2QPDsuifu5g6dJ8UvnWNQtS5+/QwFS+39k+nONh+SXFs
   QshB0yOzVrG1xKsSL+S1mOhIY3XfP1olEj2vZ3nW8WBhc6LiMHZJIfz9A
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="420596497"
X-IronPort-AV: E=Sophos;i="6.00,224,1681196400"; 
   d="scan'208";a="420596497"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 09:20:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="779525382"
X-IronPort-AV: E=Sophos;i="6.00,224,1681196400"; 
   d="scan'208";a="779525382"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga004.fm.intel.com with ESMTP; 07 Jun 2023 09:20:24 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 7 Jun 2023 09:20:23 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 7 Jun 2023 09:20:23 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.172)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 7 Jun 2023 09:20:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YNHBiho68GqGp9IZb9mfOa8S+6SGRVCtWZBSsKkl0gfcgvDUwdgbDpPuWA3LWpR9ePgPiVtzDEgRYNX+1sKOFLt181oxDNGxi9uCn6OfeJ1umTurdZE155B+t+5mYD+hoXSu1HITfFeHxsm+hGc+zB5T2b/4f6XWA2lZ1DfNbD87NnK8iAiWQoIKoEvChnkJVIfXEq4K0hlERU36GuqlghvwU3zFOE7E8eVwvFaZyPbsIjGCcitopeIwueu4Ls1hq0d9BNr10hmE+PoxuosOf+KmH2gim59HeII82x5mYduiwa2uwPz3By00ZtzPWCtj0KadDAJhh+lZi1DxvOTtmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U0Qr1+0jbtl8qXudQmOfbJs0JdkYWUHQxUni1924HF0=;
 b=GHcGGHK/oMgKUTW5dx2+Ht1GvQj0/6f+hje2BlD65HdGpl8UBx5INSYXB6S7e/uCUgnw7uYbkxefcZHFN3Z8HNTCXEuEBA/A+xCOrSqPC3m9VYQqDcldR0fHaIsFq3kC5h0jDWLZpdOBRiNZrVGpPttyL7aH7Z5wO9rVZgAs6mNByGsQYpOMO7OQshmWxL7GqI9HXsXjmqpz5RR8IiBkh11SZHteHzUOlADe3mZK7aRHoy70OkF/39obe+OsymgU8DK8fPh1ELTiDBSxc27bwHPbT0G+WOQdCRQcD/JMXnd27zfAIEAuWax4LnOj5ScpxJ2flQDqWND4YktQw62i4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by DM6PR11MB4611.namprd11.prod.outlook.com (2603:10b6:5:2a5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Wed, 7 Jun
 2023 16:20:21 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::82b6:7b9d:96ce:9325]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::82b6:7b9d:96ce:9325%6]) with mapi id 15.20.6455.030; Wed, 7 Jun 2023
 16:20:20 +0000
Message-ID: <a45e22d7-9178-ebb5-ef4b-691606dd7560@intel.com>
Date: Wed, 7 Jun 2023 18:18:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v2 bpf 03/11] bpftool: use a local bpf_perf_event_value to
 fix accessing its fields
Content-Language: en-US
To: Nick Desaulniers <ndesaulniers@google.com>
CC: Alexander Lobakin <alobakin@pm.me>, Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>, Song Liu
	<songliubraving@fb.com>, Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	<bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <tpgxyz@gmail.com>
References: <20220421003152.339542-1-alobakin@pm.me>
 <20220421003152.339542-4-alobakin@pm.me> <ZH+e9IYk+DIZzUFL@google.com>
From: Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <ZH+e9IYk+DIZzUFL@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0182.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a4::7) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|DM6PR11MB4611:EE_
X-MS-Office365-Filtering-Correlation-Id: 8aef559c-224e-4f32-f78a-08db67731661
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KfnqP7W5oS9kSd2AcHbRxmw4NG17Usuiy/9YacmGMt2uhaI5q2Uqm+PzPrIUcNMYhNckV95p68zioy8JklM7694uN9+vwJ3ZeZF43j56u+HOL4036OXpG7pPG6h+/BwyWDE4hiqte/gEVQTC+xj5p8kABNFb1puuSJYgPjTjiB9zgzm/tBSgbDddlD930g4w3ZZnRk8MdPJduQ4vlFOND9c7DkrRfVFkZ1XxC5lw5vdwiUv/aiBS8fGmVk3r1PUgQW2REUrXceHXKIh5nofOCJhuP/u9qewyycJ5JAHxdnLRuy9XKKDZyH89/iKfA1ED9wiufzYj2F/pLH19c4vppt8nxLHypDTW2Dm+MUeVsqlpTLBmD6zsRf6wZDOLYPIsnf44m34CxYcMXGosTIuk00jLihG7FGVor5/uPpG3cwAZIz1dUxTAjsKCIOoxRoHfbz3BsRKf0k5tlnYFNBHq8aoXfwvyBcfByryQIigIjNGYMWsk7YKMqgZxoPxdTTSN4AZ973NtZaUKvzgQRB3AYdGdZJOjSbRDp1JT+06q+Xv9nmeTYSv8H67pgeVVGy76oxWn0iSdF3mgKvxgTQA4lPlwN3S4JHBIi5hNPhIR5SnjyAw9YURze01AlE+mAxM/pxbFWWlRb2qoJLU0fPV3zA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(366004)(396003)(136003)(346002)(39860400002)(451199021)(83380400001)(7416002)(478600001)(82960400001)(8936002)(8676002)(316002)(4326008)(66556008)(66476007)(6916009)(5660300002)(31696002)(38100700002)(86362001)(41300700001)(66946007)(2906002)(6486002)(54906003)(36756003)(6512007)(966005)(186003)(6506007)(26005)(31686004)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y05KU0V6bG9wdWhFUWtSUS83YTVXdjdVZ1lKeHJUN2JCSW5TS01MbkNkRXRV?=
 =?utf-8?B?QXdlZUtEWk8rRFZEKzgwd2dNR2xwZHJNTi9OVm5UdkF2Y2Vkc1pvUm9nck9s?=
 =?utf-8?B?L3praDBzWnkxeUdqYVF5QUVlUUkxMHNtQTUwdGtLRzFrMEd3THFFK2NnbEEr?=
 =?utf-8?B?RmhDeW5EbzNMZXUvazUxellnemg3TURFaEJsWE5TYXNKOEtha0tPSjFZQmx2?=
 =?utf-8?B?Qy9SRlZJOCtZb2d6UlpIdDMxWmM5WG8zY01KY0FXRWlCbW5EeHQ0MjJFWW52?=
 =?utf-8?B?SXdJbGZFYTA3bkZVd0o1eFhoVzlNY2JPUXJ1VUl5amFKa0gvZXZHNEkvU2g5?=
 =?utf-8?B?bmVpQkdxbHBIUDFKR1NjeFRpT2lxNjBHc2lMeXhuUUhPVDZVOGFuRE5kUnRF?=
 =?utf-8?B?SUNBMUlrb1BxSk5pWGZ4aG5IVjFJbmZyMUxKM0I5blZxb3d4ckFLc1NvQTJm?=
 =?utf-8?B?b3dvZ3hjZHBWbW12akpYYjVqRVlZdFZyYXY5TDEvckNBc0l3Qml1OUFWeEF1?=
 =?utf-8?B?SU5VYzVZVXMwenJEMnRBZVRnaSttSVdUNjd4WVl2aVRSOXBtZ1IxbVdtMGtR?=
 =?utf-8?B?OEZmK0FlVXQ1bDVBTWVmRVhvdE8rQW5YZmdML0lVbzZEdFhwZTVaNEVteFRZ?=
 =?utf-8?B?a05pTE9yWkpPUHRFVUVnazVkT1dMbzFPY0YrSTlnb1hmMkx1ZlVTK0N3R29H?=
 =?utf-8?B?OW9YaTlHOVdTNk1PQlpKZzluZ3ZUTjkyNmpPNGY4a3hpUllFWElTTWMwUDJN?=
 =?utf-8?B?T3NJV2QvcUlyeU5QbFFoR0daZVFZdnJaZWE5MWRhTHExQUhZUVQ0cWZjdVEz?=
 =?utf-8?B?NmIrczRjSmJSR2V4czIxRm1CUWIrclV6SmQxQ0JXc3BSdCtYTmdhSmt6aEly?=
 =?utf-8?B?Q2grQlJsekpuWmo3djRSZzNyZ0RkQ0Y0M0JOYWc1elBhRW5WU3NieTVzL0JZ?=
 =?utf-8?B?a0FRZjBuaDBmSmtLTkQ5UFJsQm9XUCtFcjAyU05lQ0VBdDJmdVpCUnNmbk9Y?=
 =?utf-8?B?d0wvcnlPV3Q3QzBlRE1sNS9mUnNSdUtVM1RxOVZuVmhSdjZRck5TYm5mL0tx?=
 =?utf-8?B?Y0FFU2w5NGltaEh4VFNrb1FWK0x3OHk0YkV6UDd1TU9USmhIM1V2OEEvb2Ry?=
 =?utf-8?B?N0xBN0VqcEZMQjJBWHJKcWc3RkZ6NkRwc05weWFaRmxRVERIZFlSb2wrWFNG?=
 =?utf-8?B?bVF2bUxEZEM2YkQ4b1pCVVRXdkE3S3krVGNEcGZVaUxyOUJ6SHZ3bGxRTkpk?=
 =?utf-8?B?VEJYKzRUOW9JRERQZ3ZKeW91QVpmcFMvSzk5UWNGVEZRVUl5bHY1bXY4c1dj?=
 =?utf-8?B?MFQ5NUtNS0FpbUMzWS80c1pMd1l4Tk1IWVJiVTJKNVpWcGVCRXlDSXQ0Tlhw?=
 =?utf-8?B?LzVQNXJ1cVhFWFJqTjB5Nng2V2QyekZRc3JGVGo0N3JDRkFPL1N1QjZuKzNY?=
 =?utf-8?B?d2h1VXJ2MTVMTGs1VG9aMHVMdXJTNlBveE95ckhCV3BlV20raHp5MEk2MnEy?=
 =?utf-8?B?aXVhN0hWeVB4bkRNelZoZHY1WE9jc09tNGh2V1lRakQyK1krdkZ6MklueTM2?=
 =?utf-8?B?dEdIQnJ3MkpKZ3lGdmlRc2w0VWlSaExRWXZzS1JmRmRVUitQdDBFUjVTYmhP?=
 =?utf-8?B?YmRneFBLZm0vdEJlZHBZRDZRUHhVZ1NpWjNnYSt1UHZVZW55YnI4N0FPMGp4?=
 =?utf-8?B?TndWc1pMaGxwSjFmbEROeHpSRTJYV3oxS1U2enI4aXFsOHFMa1NsSDh6ZXB5?=
 =?utf-8?B?YjZMUDZ1UXJKR3BYd1A5WnJIZFJlZFQvdlo4S0RXR2dqTFdDaWY2YkF6Skcz?=
 =?utf-8?B?cFgrWmp4L3pHWHM4WmVhL0U2M0QwUUw0VGZacyswaDNEMjMwVDUxdlYyaHhN?=
 =?utf-8?B?T3gvbFZNRnFvcVFlRTJTUnhHQ1pEekxKUnFuTlVkcVJVYk1wb05ST3pKdU0w?=
 =?utf-8?B?aUQwem4rRG9nMDY3bnlOa3dmRGlwV2hRVXJXYmZsS0FGMUxLNngwU0hvaXpB?=
 =?utf-8?B?UFM5aEZadEF3M0MrODRzSE9Ha0EzeG5GMmZqemc5Y2E0YlZxbDJJa0Jjc2lS?=
 =?utf-8?B?ZkhvL3FlR0lma0ovZURaL2ROVDlCcnBqU2hVMUc1RWZ4b0NmR2Zmc01GaGww?=
 =?utf-8?B?WFZVLzkzWVZ1QkZ2b0ltaUthVWpxYmNEZ0JWV2Q5dHlTaXBkT3ZNaFZGTm9n?=
 =?utf-8?B?b1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8aef559c-224e-4f32-f78a-08db67731661
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2023 16:20:19.9863
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s4efYJnKxClm9lr2aLaVxG9ScJok9/aHH9ZOzAQ6ebTdp7pJQ2NjboPb+uIFtyTfEidbt+tGgoMNmPysOUWhpPpNT4C+ksj9Ue+ME+VsW/0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4611
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Nick Desaulniers <ndesaulniers@google.com>
Date: Tue, 6 Jun 2023 14:02:44 -0700

> On Thu, Apr 21, 2022 at 12:39:04AM +0000, Alexander Lobakin wrote:
>> Fix the following error when building bpftool:
>>
>>   CLANG   profiler.bpf.o
>>   CLANG   pid_iter.bpf.o
>> skeleton/profiler.bpf.c:18:21: error: invalid application of 'sizeof' to an incomplete type 'struct bpf_perf_event_value'
>>         __uint(value_size, sizeof(struct bpf_perf_event_value));
>>                            ^     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> tools/bpf/bpftool/bootstrap/libbpf/include/bpf/bpf_helpers.h:13:39: note: expanded from macro '__uint'
>> tools/bpf/bpftool/bootstrap/libbpf/include/bpf/bpf_helper_defs.h:7:8: note: forward declaration of 'struct bpf_perf_event_value'
>> struct bpf_perf_event_value;
>>        ^
>>
>> struct bpf_perf_event_value is being used in the kernel only when
>> CONFIG_BPF_EVENTS is enabled, so it misses a BTF entry then.
>> Define struct bpf_perf_event_value___local with the
>> `preserve_access_index` attribute inside the pid_iter BPF prog to
>> allow compiling on any configs. It is a full mirror of a UAPI
>> structure, so is compatible both with and w/o CO-RE.
>> bpf_perf_event_read_value() requires a pointer of the original type,
>> so a cast is needed.
>>
> 
> Hi Alexander,
> What's the status of this series? I wasn't able to find a v3 on lore.

Hi,

Sorry, I haven't been working on my private/home kernel projects for
quite a long. As Quentin mentioned, he took some patches from the series
into his own set. I'd support that one rather than mine.

> 
> We received a report that OpenMandriva is carrying around this patch.
> https://github.com/ClangBuiltLinux/linux/issues/1805.
> 
> + Tomasz
> 
> Tomasz, do you have more info which particular configs can reproduce
> this issue? Is this patch still necessary?
> 
>> Fixes: 47c09d6a9f67 ("bpftool: Introduce "prog profile" command")
>> Suggested-by: Andrii Nakryiko <andrii@kernel.org>
>> Signed-off-by: Alexander Lobakin <alobakin@pm.me>
Thanks,
Olek

