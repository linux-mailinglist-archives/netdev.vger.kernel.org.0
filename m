Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1E136892C
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 01:00:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239650AbhDVXBQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 19:01:16 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:18774 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S236949AbhDVXBO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 19:01:14 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 13MN0E63011033;
        Thu, 22 Apr 2021 16:00:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=aI6sSc4HMXsKAkgQXjdVJBOmmCx+yVjPz8tP8jytgPI=;
 b=j7vOhnuE9yaE0t3CwCBszk5WbM00IctNgJkHFSVMCk6AD4z8crbm1UuA30Y+gMoRH5hN
 hb25XXna5QCehUjgWbSIh04xImpb+dLhNpchHOrHJFcspyuy+iNVzhXOZHdUaYAI+BB+
 /EW+1nG2gvEONzeMTwcmqZr+q5p/XanhjCk= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 383h1ugf6u-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 22 Apr 2021 16:00:26 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 22 Apr 2021 16:00:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aIaUNq6ZEWlLoCwdOFb+dJTzZarmXyw9LVzHn2GhgEoNgIAr0F7pVH6pu1DFJw8YyTcRft/KMkSXdMiXU4in0jvNuDUQtdacIL+WMhl/EfrW9kvJHDPrxdOjpOjSpcDWzTFOOHUR1XukKX8VY3iu35EoS5w2Igybu4eDizsUx5zuGYyJSa+hMeCOO+doy7KK3MGsYn8T8+Q/m06BIF44i3UmoC5mTpWZawRn7u4W/SgKtGWtZgFFRVc9uXPCj3qNvpLSl8CdeRootq4T4bVGnsuPvveBk+mYhJG8JCDC3UO0/y8ZWfCkxody43j8mHJJN0RKp0ewgfZK3MSCz6A3ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aI6sSc4HMXsKAkgQXjdVJBOmmCx+yVjPz8tP8jytgPI=;
 b=EYriCtCNduYdtAnHf46MeHBG+1onphiPjGcRcBfu/Vw6D1qqyFO3PmnvuDY7X8Cy0cyKW0lvUosIZ4h3rlvGgh5ludVnDCD0FjSbWw/PXScD1UiVSOGHvrM7IvZg01IZhET2qQCBTDr5ukeHkZRlYZ+0vu4UUDadoVKIQaEPUGRXRlAupWRkJGIrXbpx/AVWdvhGHtv1cl+ptLGMW3lpZ2PcTLYgj8Ws3bngLdAy8LmrsId1HbnksPiIu4cVp8sr1pcM7699SQhxPzsK4P46Mbz3sv7sqCirVwiSj0inRdhw3hRMtLbxpTzfRn4fCimY5+jratdPcjbaD6TMpE1KVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SN6PR15MB2414.namprd15.prod.outlook.com (2603:10b6:805:24::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.23; Thu, 22 Apr
 2021 23:00:24 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912%3]) with mapi id 15.20.4065.021; Thu, 22 Apr 2021
 23:00:24 +0000
Subject: Re: [PATCH v2 bpf-next 04/17] libbpf: mark BPF subprogs with hidden
 visibility as static for BPF verifier
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
References: <20210416202404.3443623-1-andrii@kernel.org>
 <20210416202404.3443623-5-andrii@kernel.org>
 <8cde2756-e62f-7103-05b1-7d9a9d97442a@fb.com>
 <CAEf4BzYFHp8vt6rwgcZG5Lp-DQU0xrVq8QXvDqOyVOtx0gosnw@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <65869842-b1a0-5e95-9ca2-42aaf86644a8@fb.com>
Date:   Thu, 22 Apr 2021 16:00:20 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
In-Reply-To: <CAEf4BzYFHp8vt6rwgcZG5Lp-DQU0xrVq8QXvDqOyVOtx0gosnw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:83f]
X-ClientProxiedBy: MW4PR04CA0353.namprd04.prod.outlook.com
 (2603:10b6:303:8a::28) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::17f2] (2620:10d:c090:400::5:83f) by MW4PR04CA0353.namprd04.prod.outlook.com (2603:10b6:303:8a::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.22 via Frontend Transport; Thu, 22 Apr 2021 23:00:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 467c6392-024c-4e11-09c5-08d905e269d2
X-MS-TrafficTypeDiagnostic: SN6PR15MB2414:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR15MB2414D11600A1A68EDAAEC370D3469@SN6PR15MB2414.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 270EvYxGm0XyB9wHIcG+IWaF83YVdfLEyfjs/omasfam+CbTRXrazMmMbmtxC59eL5+uNMX/JZ977KrTxGqBS6FqJZMGUVV3Cnn8Li/LXZOBKEgdxKACUz5ScsofwyuUfjx6u+YqLM/W6jEzzWe+Vq33YYKqB5l7trmAM3WoTQBLBnrt/6D0vXwMCvzcEbLl/NcK00/T4WBBtNe28kjiwOwoFnmSu0XKOY56d6PIaVhWCAq3ax/08K02FhOsBVuLUU2/B9swCY3xs2INc5uni0FhAyT6PjtfBW9F2dMRqe6l5a0/rV6NDZQQDAAYYg6nDAiXLhta5QGMYR45/Vwe9j1n7BkJBm+r+Zn3+vhY43TiXBf+4Hs3aEX1Orz9UhDrsWWtUrS2Lc0vDfzRDza24csqsZuqrwbEjrq3N/fov+rAyY0p1UGVF0tCckDW7O0DFiWG1Yb3jkBlDgCTxsmO36+3x9AO3wlMxTlEG0fz1zv7b+JAaThcFxtrldWtG6JH2UlzG4bxQGwXwJ7QIgv7ERvQIE/f6fuO/obw8h7/jthNzslUWWL5OkuAEIKjVuGJIGYVQ4S1jrE1tFoOEHaEeTpHebaaezWcQrPAbM0PW0nuf+zQRIRfDAIalKtlTa3ffedUXqfq8nDpDJIevSQKT3Q395r8CSNR87S+p8erf54Dbun4X9W00U+Q/rix+ABP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(366004)(346002)(376002)(396003)(83380400001)(316002)(54906003)(66946007)(66556008)(66476007)(53546011)(6916009)(36756003)(478600001)(52116002)(31686004)(4326008)(8676002)(6486002)(8936002)(31696002)(186003)(5660300002)(16526019)(2616005)(2906002)(86362001)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TlNneWJ2YkRua3pwTjEzVnlscm9iblpOTmQ5cWs2ZHc1dFJtYjQrMUZFZ2sx?=
 =?utf-8?B?QkVvS3ZhR1pXaHFzZHFWNmZpUkxiMVFXbTZkZkcwVXVJYmtRM3M1dHJZTjJm?=
 =?utf-8?B?Vm5qaFdaSEpOUUIwbWRtU2VxQWpRZWc5RGljenRXLzVJUWZlU1dhTUtpY3kx?=
 =?utf-8?B?Yzk3T2VDdFhXeXFlK3B5SEFyR0Q3cCtYUGxaWWJHUUlxSFpaUi9hNnlXSHRp?=
 =?utf-8?B?RW5sNG92MDFJeVNXbEd0ZXFhV0g4UXc2QmhqQWw3eUZtWVZERGhsbUNQRlYw?=
 =?utf-8?B?YXVyMGI4dWdyUTE3M1E5T0NyY0ZnUDdGVUtjYjFUOHRJdzRQdyt3YXJlNjlv?=
 =?utf-8?B?TnZqTWptakRVdGNzdUdHQURXcDlvNnZzYm9kMklUL1JMUFlEQmVlWUh6dHhh?=
 =?utf-8?B?Q0hsd3ZJbjNiMDZXRk9UZkNwQVpNeEgxYmpnaHFjcFIzUVRoaS9SK1h4cC9Y?=
 =?utf-8?B?Zk5MeVBRM3IvTXdKUElMZ0l3ZWlwUytJVHZHNjNkK3pJM3dTanpoMS9BU2hU?=
 =?utf-8?B?SDlMdzF5Q3JoS2xKUlJwejJCemNad2M2dHAwMUNqa1RaOUZkeXBiS0dBRVJm?=
 =?utf-8?B?a0d4b1lCS2QwYlJrYkJ2RXRlUGc5eUZTUmhVUG5JM3ZKVXpramdtcG5RMUpy?=
 =?utf-8?B?WTluL2RrZWV6M1JSWDVGWmRUZTgvdzYrM2VKSUlGd1dNZHVjTDNhQmhDYkd2?=
 =?utf-8?B?aTh5VGd3eTV6UlFwa1B5bGdIMThudGxFS1A3VlRQOVRtL3pTaDNpbnNPNkt5?=
 =?utf-8?B?SUo5RDNoRnNZM0xrMmRlRXUrN2dWeWpGbTNKT05TZGRwc01FTlN4OGlvR0Va?=
 =?utf-8?B?dmhoUm5keXpLTVZTUXNyOTBYL1hGMzVDcWxKQ3ZWTGdBM3FURU1VYkpHaFc0?=
 =?utf-8?B?b3Y1K2xrYWUzOE1ucjFsY21RMHdjVmhCUGpveDFjeGJYVVNhUnZ2ckNybW5Y?=
 =?utf-8?B?clNGMGxNVEVuRGxJODVxaThYZlJLZ0VWUzFjcDE1VGpXZnJPSStISGsveTg4?=
 =?utf-8?B?L3M2M1BacHhjTmVKaC9RakNyRG1uNk9mS3FQeE1qbXN2Z2s4WkJadkZicGtO?=
 =?utf-8?B?RkVZSGdueUxWOXY3bjZLallRcFE1Vk5Mc3ZOTVlhSXFqSk5wOFZqeVNTTDR5?=
 =?utf-8?B?WTNHQXBIUVozaFhnaHh6RCtmL3FXSmV6VzFlRnRPM295M0NyL2dhSzZGT2Z6?=
 =?utf-8?B?MzVDOFg5MDVEUjV0OFc2c3pTbjF0bTNmYnNydElTcW1VbGNhN0tabktIZFc5?=
 =?utf-8?B?b1VGdkYvaUhmNVJkdHhlSHBDZ3pSMmxjVEhGeWdYZFpOQTFLeGVmeGlrZjlN?=
 =?utf-8?B?QzY1eXlzb05vdjVjMkhJbkpwaEtHWnk5Mmd3czBkcVRSeERuczJrdk1Ock9Y?=
 =?utf-8?B?NzRLdm9pZ2YrZ1UxYXZUK2RaUW5TQ1d4emdCZThOWWlsaTJsRDFzVzFqaTVY?=
 =?utf-8?B?SFJHS1NEOWdGRmxiRkpNejNsNXJkU0t3TnVhNXdRYmlybzFCWXhGMUlsUUZQ?=
 =?utf-8?B?cnJqWTFJL1NZRXhNNUV3U3VpZUZVVnVEOE9RTFpqaUs2Q29xOGl2WWx1a0dI?=
 =?utf-8?B?MmoyN1NRSkJxN01MeVI5eStiV1o1MThmZVZndU44TGJPUkF5c0UwUWUyU1g0?=
 =?utf-8?B?WEtpbHE1YWdaWVkwZjRCQ0pvSkJya0FpQzhVam1KQ211K3g0Z0ZxcGZZNGM5?=
 =?utf-8?B?dWNhSENLVVlpMWRuZUc0RE5lYndOVitBZ3d4ZHIyM1J4VlpiYTQyZVVlc0Ji?=
 =?utf-8?B?STh1VkdtRCt1ekZQVEhwajRIZFNDQ0JFUnlyNHJKZC9MalFiSzJOKzN2SElL?=
 =?utf-8?Q?8QqpUqKftQgNKh0IcYZu5xPoR9kfJB6miImTA=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 467c6392-024c-4e11-09c5-08d905e269d2
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2021 23:00:24.6615
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L2NhKTv5/9R6ZROroGxtxfqqICmqnmmMKJE7Q3u3c24e+yAmJdanbi0RM0+RgDv9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR15MB2414
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: mP5LUgHv02LfIvoi0D3NjmWFzr1Zkll5
X-Proofpoint-ORIG-GUID: mP5LUgHv02LfIvoi0D3NjmWFzr1Zkll5
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-22_15:2021-04-22,2021-04-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 adultscore=0 malwarescore=0 mlxscore=0 spamscore=0 bulkscore=0
 phishscore=0 impostorscore=0 priorityscore=1501 lowpriorityscore=0
 mlxlogscore=999 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104060000 definitions=main-2104220168
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/22/21 11:09 AM, Andrii Nakryiko wrote:
> On Wed, Apr 21, 2021 at 10:43 PM Yonghong Song <yhs@fb.com> wrote:
>>
>>
>>
>> On 4/16/21 1:23 PM, Andrii Nakryiko wrote:
>>> Define __hidden helper macro in bpf_helpers.h, which is a short-hand for
>>> __attribute__((visibility("hidden"))). Add libbpf support to mark BPF
>>> subprograms marked with __hidden as static in BTF information to enforce BPF
>>> verifier's static function validation algorithm, which takes more information
>>> (caller's context) into account during a subprogram validation.
>>>
>>> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
>>> ---
>>>    tools/lib/bpf/bpf_helpers.h     |  8 ++++++
>>>    tools/lib/bpf/btf.c             |  5 ----
>>>    tools/lib/bpf/libbpf.c          | 45 ++++++++++++++++++++++++++++++++-
>>>    tools/lib/bpf/libbpf_internal.h |  6 +++++
>>>    4 files changed, 58 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
>>> index 75c7581b304c..9720dc0b4605 100644
>>> --- a/tools/lib/bpf/bpf_helpers.h
>>> +++ b/tools/lib/bpf/bpf_helpers.h
>>> @@ -47,6 +47,14 @@
>>>    #define __weak __attribute__((weak))
>>>    #endif
>>>
>>> +/*
>>> + * Use __hidden attribute to mark a non-static BPF subprogram effectively
>>> + * static for BPF verifier's verification algorithm purposes, allowing more
>>> + * extensive and permissive BPF verification process, taking into account
>>> + * subprogram's caller context.
>>> + */
>>> +#define __hidden __attribute__((visibility("hidden")))
>>
>> To prevent potential external __hidden macro definition conflict, how
>> about
>>
>> #ifdef __hidden
>> #undef __hidden
>> #define __hidden __attribute__((visibility("hidden")))
>> #endif
>>
> 
> We do force #undef only with __always_inline because of the bad
> definition in linux/stddef.h And we check #ifndef for __weak, because
> __weak is defined in kernel headers. This is not really the case for
> __hidden, the only definition is in
> tools/lib/traceevent/event-parse-local.h, which I don't think we
> should worry about in BPF context. So I wanted to keep it simple and
> fix only if that really causes some real conflicts.
> 
> And keep in mind that in BPF code bpf_helpers.h is usually included as
> one of the first few headers anyways.

That is fine. Conflict of __hidden is a low risk and we can deal with it
later if needed.

> 
> 
>>> +
>>>    /* When utilizing vmlinux.h with BPF CO-RE, user BPF programs can't include
>>>     * any system-level headers (such as stddef.h, linux/version.h, etc), and
>>>     * commonly-used macros like NULL and KERNEL_VERSION aren't available through
> 
> [...]
> 
>>> @@ -698,6 +700,15 @@ bpf_object__add_programs(struct bpf_object *obj, Elf_Data *sec_data,
>>>                if (err)
>>>                        return err;
>>>
>>> +             /* if function is a global/weak symbol, but has hidden
>>> +              * visibility (or any non-default one), mark its BTF FUNC as
>>> +              * static to enable more permissive BPF verification mode with
>>> +              * more outside context available to BPF verifier
>>> +              */
>>> +             if (GELF_ST_BIND(sym.st_info) != STB_LOCAL
>>> +                 && GELF_ST_VISIBILITY(sym.st_other) != STV_DEFAULT)
>>
>> Maybe we should check GELF_ST_VISIBILITY(sym.st_other) == STV_HIDDEN
>> instead?
> 
> It felt like only STV_DEFAULT should be "exported", semantically
> speaking. Everything else would be treated as if it was static, except
> that C rules require that function has to be global. Do you think
> there is some danger to do it this way?
> 
> Currently static linker doesn't do anything special for STV_INTERNAL
> and STV_PROTECTED, so we could just disable those. Do you prefer that?

Yes, let us just deal with STV_DEFAULT and STV_HIDDEN. We already
specialized STV_HIDDEN, so we should not treat STV_INTERNAL/PROTECTED
as what they mean in ELF standard, so let us disable them for now.

> 
> I just felt that there is no risk of regression if we do this for
> non-STV_DEFAULT generically.
> 
> 
>>
>>> +                     prog->mark_btf_static = true;
>>> +
>>>                nr_progs++;
>>>                obj->nr_programs = nr_progs;
>>>
> 
> [...]
> 
