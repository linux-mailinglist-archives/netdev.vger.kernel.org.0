Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0849B449EB9
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 23:43:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230364AbhKHWpu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 17:45:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233784AbhKHWpt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 17:45:49 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0D5CC061746;
        Mon,  8 Nov 2021 14:43:04 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id y7so219932plp.0;
        Mon, 08 Nov 2021 14:43:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/gNfR6RMe3FVY6LruZzthReGaoxid6V/9E8HRbH7ZRM=;
        b=HsphAvJjQcRAJE+ab+zzFi8PgfT/SkqehoxgBoSsEsWcGlfCSlk2wfOJzxlIm4qWHR
         Xih48oMf+8vV+dEsGCeEQw93MxVLOWpCZ2bX27vJHUnNs0kRkkhRp9sKjWTSN2TVkZHY
         py9W1jvcQFJ11cRY4hhEMniHCgmJrTayaFFDFGiAvZj9YC03iIWcku05PCp8WFLmyal1
         AAtbF17upqNIoLngXRP+7NqzAQiemoyWZNqEUU74eGWAlErIo0PeoZmGDfHYJAH9Maiy
         0XClx446yJP4Z0v9CoFNOMP3h1eZ7/Ao0EHVYkoir3P7Gad2Eu0gmc13J1fFfrPO4RVS
         IK2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/gNfR6RMe3FVY6LruZzthReGaoxid6V/9E8HRbH7ZRM=;
        b=sau8SoZVwKVVUTwVvV5OqHR2B/dEm1fAxwUqX5Jzxoes7E9ICPOtuo6z/vqluUL66x
         EBf8CnBkh8AbQb/OCmJAo7LR/ckufjnTGoQoT6Cj0NY6FKwiW5AxCw0vNJok1+b6i/RN
         8j8r3fNvrI5Iga9EVQXOdei2C/Xt9ZIJ5+qSa5BH42cGjq1E91QlYCyUb2uNr1npnNCv
         AznH+OgCgQHRGrhOe0xV/lwLsfcI2TkgTk9IGjDCyXzL6cdtKIt37dn1eU5//rTwDVzn
         yB3mfnySN9R7vgkwxAqeeTreUnaJIXdcNsrOeH9KZd2vkZ/9hvl8oyrt7uIAQophKSHB
         TYhw==
X-Gm-Message-State: AOAM532BQlTzpIi5soFvx4Ek+ve0F/VXX8iCoewjlQCVcLL1dKLSsMC0
        M9Z9ARj2lYCsFhHMDN7hUeI=
X-Google-Smtp-Source: ABdhPJxvdrgpGS4oCh4U4OqxdC42vFyI3v72uDb+CLAxzM0/Rls+dREnVrsNnQYHg0snXZ1gzSJpBw==
X-Received: by 2002:a17:90b:1812:: with SMTP id lw18mr2001051pjb.96.1636411384483;
        Mon, 08 Nov 2021 14:43:04 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id mm22sm330857pjb.28.2021.11.08.14.43.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Nov 2021 14:43:04 -0800 (PST)
Subject: Re: [PATCH v5 bpf-next 1/2] bpf: introduce helper bpf_find_vma
From:   Eric Dumazet <eric.dumazet@gmail.com>
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
 <048f6048-b5ff-4ab7-29dc-0cbae919d655@gmail.com>
Message-ID: <c824244f-996e-fb0c-3090-2e217681c6a1@gmail.com>
Date:   Mon, 8 Nov 2021 14:43:02 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <048f6048-b5ff-4ab7-29dc-0cbae919d655@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/8/21 2:27 PM, Eric Dumazet wrote:
> 
> 
> On 11/8/21 1:59 PM, Song Liu wrote:
>>
>>
>>> On Nov 8, 2021, at 10:36 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>>>
>>>
>>>
>>> On 11/5/21 4:23 PM, Song Liu wrote:
>>>> In some profiler use cases, it is necessary to map an address to the
>>>> backing file, e.g., a shared library. bpf_find_vma helper provides a
>>>> flexible way to achieve this. bpf_find_vma maps an address of a task to
>>>> the vma (vm_area_struct) for this address, and feed the vma to an callback
>>>> BPF function. The callback function is necessary here, as we need to
>>>> ensure mmap_sem is unlocked.
>>>>
>>>> It is necessary to lock mmap_sem for find_vma. To lock and unlock mmap_sem
>>>> safely when irqs are disable, we use the same mechanism as stackmap with
>>>> build_id. Specifically, when irqs are disabled, the unlocked is postponed
>>>> in an irq_work. Refactor stackmap.c so that the irq_work is shared among
>>>> bpf_find_vma and stackmap helpers.
>>>>
>>>> Acked-by: Yonghong Song <yhs@fb.com>
>>>> Tested-by: Hengqi Chen <hengqi.chen@gmail.com>
>>>> Signed-off-by: Song Liu <songliubraving@fb.com>
>>>> ---
>>>
>>> ...
>>>
>>>> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
>>>> index dbc3ad07e21b6..cdb0fba656006 100644
>>>> --- a/kernel/bpf/btf.c
>>>> +++ b/kernel/bpf/btf.c
>>>> @@ -6342,7 +6342,10 @@ const struct bpf_func_proto bpf_btf_find_by_name_kind_proto = {
>>>> 	.arg4_type	= ARG_ANYTHING,
>>>> };
>>>>
>>>> -BTF_ID_LIST_GLOBAL_SINGLE(btf_task_struct_ids, struct, task_struct)
>>>> +BTF_ID_LIST_GLOBAL(btf_task_struct_ids)
>>>> +BTF_ID(struct, task_struct)
>>>> +BTF_ID(struct, file)
>>>> +BTF_ID(struct, vm_area_struct)
>>>
>>> $ nm -v vmlinux |grep -A3 btf_task_struct_ids
>>> ffffffff82adfd9c R btf_task_struct_ids
>>> ffffffff82adfda0 r __BTF_ID__struct__file__715
>>> ffffffff82adfda4 r __BTF_ID__struct__vm_area_struct__716
>>> ffffffff82adfda8 r bpf_skb_output_btf_ids
>>>
>>> KASAN thinks btf_task_struct_ids has 4 bytes only.
>>
>> I have KASAN enabled, but couldn't repro this issue. I think
>> btf_task_struct_ids looks correct:
>>
>> nm -v vmlinux | grep -A3 -B1 btf_task_struct_ids
>> ffffffff83cf8260 r __BTF_ID__struct__task_struct__1026
>> ffffffff83cf8260 R btf_task_struct_ids
>> ffffffff83cf8264 r __BTF_ID__struct__file__1027
>> ffffffff83cf8268 r __BTF_ID__struct__vm_area_struct__1028
>> ffffffff83cf826c r bpf_skb_output_btf_ids
>>
>> Did I miss something?
>>
>> Thanks,
>> Song
>>
> 
> I will release the syzbot bug, so that you can use its .config
> 
> Basically, we have
> 
> u32 btf_task_struct_ids[1];

That is, if  

# CONFIG_DEBUG_INFO_BTF is not set

> 
> xxxx = btf_task_struct_ids[2];  /* trap */
> 
> 
> 
