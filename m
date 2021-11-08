Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E8FF449EA8
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 23:27:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240443AbhKHWad (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 17:30:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239746AbhKHWad (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 17:30:33 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F3C2C061570;
        Mon,  8 Nov 2021 14:27:48 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id x131so12245152pfc.12;
        Mon, 08 Nov 2021 14:27:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TEAxq3JIdlIzfkxo4sUaMQmwtn3StYyrUjBS94KK3yA=;
        b=p80Ndzg8l95z/0GUFikccrB+rErEHrKlhpEMBzVVzZ8T01LetS3HUrLY5AgJEXXEB0
         dt2ynSivZkZM9LOqtnYOqmLgsL8bgrE5CP7JeRLEWwTnw81gxewu44B9NPcKkAIUJXOU
         RfIfox+veYaeGvfR7YX//oihJGGbleN7NfUMnnNjA0ARN11Vmnm4Vt4/nyafUMb/Ie28
         oUtY1NiaqGv3suBUtX2J6FWUwZ4GXZ+q47cpf9md2KkAfOeTq2qQqdF+zGowqG36My1z
         OCAdeyY3UbZe2sN3IJc6TWic4IVu7B0eEP2r3ezONnswRu0iJusr0i+GQML35+7Puc5p
         pjOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TEAxq3JIdlIzfkxo4sUaMQmwtn3StYyrUjBS94KK3yA=;
        b=reuuYyUrdY/phE6cbwisiyjTZ6F5cYNVpxO8lzpaQo01XlCeodsSsHQ4WzPhpjVU61
         IeMJXF0DhBshUqDhqyNkQQIxQLcX/E1moQWQC2SpcNFbpKW2Q+3lTCmkjhdNuWZqcTN/
         UBtuYBB3dV+p+1s2WOZBldKO2NLgmH1P3hymjyhS8xtqsXjulMAPJKeZz1Lq22/VqsW3
         1Zj9GoqRM45H4jX3PijIftgpwnXqjIUoGCHCeCzgK0pkGxpJvgLFGVO4wjXWmnQEBF/p
         rE63oqMWTi6pvUyGb4We4AA4LvnekTGf86lUk/F7BxtensZaVYUPcJAGIyK+EW97DWaZ
         mFKQ==
X-Gm-Message-State: AOAM532ip3fwpWVAJ7DCR3Cb+RQ2XDjU8qlKSvPd4feVV9wGwGSG03JJ
        W/krVMW8QOiAt4NHbcn+wzQ=
X-Google-Smtp-Source: ABdhPJwHqG5kA7Z9rKmWG/8nSiaj/kaY11vbDmlWwerb5Tay3E1c3Ws5EPh4KWe/IjSWoC3NPwchmA==
X-Received: by 2002:a63:6a05:: with SMTP id f5mr2198740pgc.97.1636410467878;
        Mon, 08 Nov 2021 14:27:47 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id g1sm7062980pfm.25.2021.11.08.14.27.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Nov 2021 14:27:47 -0800 (PST)
Subject: Re: [PATCH v5 bpf-next 1/2] bpf: introduce helper bpf_find_vma
To:     Song Liu <songliubraving@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "hengqi.chen@gmail.com" <hengqi.chen@gmail.com>,
        Yonghong Song <yhs@fb.com>
References: <20211105232330.1936330-1-songliubraving@fb.com>
 <20211105232330.1936330-2-songliubraving@fb.com>
 <0ee9be06-6552-d8e3-74c7-7a96a46c8888@gmail.com>
 <099A4F8E-0BB7-409B-8E40-8538AAC04DC5@fb.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <048f6048-b5ff-4ab7-29dc-0cbae919d655@gmail.com>
Date:   Mon, 8 Nov 2021 14:27:45 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <099A4F8E-0BB7-409B-8E40-8538AAC04DC5@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/8/21 1:59 PM, Song Liu wrote:
> 
> 
>> On Nov 8, 2021, at 10:36 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>>
>>
>>
>> On 11/5/21 4:23 PM, Song Liu wrote:
>>> In some profiler use cases, it is necessary to map an address to the
>>> backing file, e.g., a shared library. bpf_find_vma helper provides a
>>> flexible way to achieve this. bpf_find_vma maps an address of a task to
>>> the vma (vm_area_struct) for this address, and feed the vma to an callback
>>> BPF function. The callback function is necessary here, as we need to
>>> ensure mmap_sem is unlocked.
>>>
>>> It is necessary to lock mmap_sem for find_vma. To lock and unlock mmap_sem
>>> safely when irqs are disable, we use the same mechanism as stackmap with
>>> build_id. Specifically, when irqs are disabled, the unlocked is postponed
>>> in an irq_work. Refactor stackmap.c so that the irq_work is shared among
>>> bpf_find_vma and stackmap helpers.
>>>
>>> Acked-by: Yonghong Song <yhs@fb.com>
>>> Tested-by: Hengqi Chen <hengqi.chen@gmail.com>
>>> Signed-off-by: Song Liu <songliubraving@fb.com>
>>> ---
>>
>> ...
>>
>>> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
>>> index dbc3ad07e21b6..cdb0fba656006 100644
>>> --- a/kernel/bpf/btf.c
>>> +++ b/kernel/bpf/btf.c
>>> @@ -6342,7 +6342,10 @@ const struct bpf_func_proto bpf_btf_find_by_name_kind_proto = {
>>> 	.arg4_type	= ARG_ANYTHING,
>>> };
>>>
>>> -BTF_ID_LIST_GLOBAL_SINGLE(btf_task_struct_ids, struct, task_struct)
>>> +BTF_ID_LIST_GLOBAL(btf_task_struct_ids)
>>> +BTF_ID(struct, task_struct)
>>> +BTF_ID(struct, file)
>>> +BTF_ID(struct, vm_area_struct)
>>
>> $ nm -v vmlinux |grep -A3 btf_task_struct_ids
>> ffffffff82adfd9c R btf_task_struct_ids
>> ffffffff82adfda0 r __BTF_ID__struct__file__715
>> ffffffff82adfda4 r __BTF_ID__struct__vm_area_struct__716
>> ffffffff82adfda8 r bpf_skb_output_btf_ids
>>
>> KASAN thinks btf_task_struct_ids has 4 bytes only.
> 
> I have KASAN enabled, but couldn't repro this issue. I think
> btf_task_struct_ids looks correct:
> 
> nm -v vmlinux | grep -A3 -B1 btf_task_struct_ids
> ffffffff83cf8260 r __BTF_ID__struct__task_struct__1026
> ffffffff83cf8260 R btf_task_struct_ids
> ffffffff83cf8264 r __BTF_ID__struct__file__1027
> ffffffff83cf8268 r __BTF_ID__struct__vm_area_struct__1028
> ffffffff83cf826c r bpf_skb_output_btf_ids
> 
> Did I miss something?
> 
> Thanks,
> Song
> 

I will release the syzbot bug, so that you can use its .config

Basically, we have

u32 btf_task_struct_ids[1];

xxxx = btf_task_struct_ids[2];  /* trap */



