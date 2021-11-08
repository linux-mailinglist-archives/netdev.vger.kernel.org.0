Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0132449BB9
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 19:36:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232018AbhKHSjG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 13:39:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230269AbhKHSjG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 13:39:06 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B00C3C061570;
        Mon,  8 Nov 2021 10:36:21 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id n36-20020a17090a5aa700b0019fa884ab85so9492454pji.5;
        Mon, 08 Nov 2021 10:36:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Pe1bWLXlIi/2zH+f+tSQAtO/51QNXQXJBH+pOwSHeKQ=;
        b=Ug3VXcIVP7QId+X/LluYtSipQRCwoKj+uwYaaEQEo21LVVdguxNhN6/nhel16lgEHh
         mfLxowE57m6nwDvxJWFmlfVvDH60XJxg/i2RG1xesjKV8iM+ZdY/1BzRLSHowtN9XrhU
         ZvTKLMZZpFrRxCyirHOaNRMXCXeNV8+G4pRtTI+OM+WTwhmREeN4D4D24wjX8GLfeUK6
         kWQFfLWoO/+mYLSkispBOZwsZsqs3t6O0innQNvEo6yq9jX7jDwmVp2frGlQB5P22dio
         eK/HwQ8/mrxoV4iXwAWugF3v36Wbbw5D/sRV78L3cM5WyW2i+AbMKmhmVXCA2sSTrPsw
         r2PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Pe1bWLXlIi/2zH+f+tSQAtO/51QNXQXJBH+pOwSHeKQ=;
        b=szJNP1oTwJ7SqwJyzcMGz54I6NdxDVNtyqstOe+CPxYUhs2aXRcrGmTfZcrJ3m24Iz
         xAChhrIOsAIHfgbPr1lwAfd/QyWKRhtMGo9MCXwcyYIrM7sq8EusJAtlp3KtZYYbDdBK
         k6E+GqZVSy8RJRKOciREIFGlTXzGSDLgOizxDCyXjI9F6OGvFBQabRWVkbUathdSKTgP
         moRjNTI+pDbVILsHlG2th4NBUnB8N0j8fqW2JlUawdzoIfZs5TmjsK7GsboAR9BNzbxF
         AHh0RD8EInU3iLyPGUkrOb2fKsA/YUx3u/ozjtNjg4PBCpJh4X3C8pvj2M1P8VFXTSbf
         5pKQ==
X-Gm-Message-State: AOAM531wjJ6kYoEMFOWa2VPweg8jcoFcpwQh4Lc6bnlkGJr0hdxrK/1c
        fCbO4stCW+Ipps6kR4XCAX1Jxgj4PzQ=
X-Google-Smtp-Source: ABdhPJwZRoAmRuFHDQpo+XfoZIfq/HK0Ql63fB5CUylRJ3HkiDhafG4IcLvFhWoUZwjdtRUjUfPuaw==
X-Received: by 2002:a17:902:714f:b0:142:892d:a46 with SMTP id u15-20020a170902714f00b00142892d0a46mr1263538plm.39.1636396581261;
        Mon, 08 Nov 2021 10:36:21 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id h130sm4993293pfe.85.2021.11.08.10.36.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Nov 2021 10:36:20 -0800 (PST)
Subject: Re: [PATCH v5 bpf-next 1/2] bpf: introduce helper bpf_find_vma
To:     Song Liu <songliubraving@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kernel-team@fb.com, kpsingh@kernel.org, hengqi.chen@gmail.com,
        Yonghong Song <yhs@fb.com>
References: <20211105232330.1936330-1-songliubraving@fb.com>
 <20211105232330.1936330-2-songliubraving@fb.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <0ee9be06-6552-d8e3-74c7-7a96a46c8888@gmail.com>
Date:   Mon, 8 Nov 2021 10:36:19 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211105232330.1936330-2-songliubraving@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/5/21 4:23 PM, Song Liu wrote:
> In some profiler use cases, it is necessary to map an address to the
> backing file, e.g., a shared library. bpf_find_vma helper provides a
> flexible way to achieve this. bpf_find_vma maps an address of a task to
> the vma (vm_area_struct) for this address, and feed the vma to an callback
> BPF function. The callback function is necessary here, as we need to
> ensure mmap_sem is unlocked.
> 
> It is necessary to lock mmap_sem for find_vma. To lock and unlock mmap_sem
> safely when irqs are disable, we use the same mechanism as stackmap with
> build_id. Specifically, when irqs are disabled, the unlocked is postponed
> in an irq_work. Refactor stackmap.c so that the irq_work is shared among
> bpf_find_vma and stackmap helpers.
> 
> Acked-by: Yonghong Song <yhs@fb.com>
> Tested-by: Hengqi Chen <hengqi.chen@gmail.com>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---

...

> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index dbc3ad07e21b6..cdb0fba656006 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -6342,7 +6342,10 @@ const struct bpf_func_proto bpf_btf_find_by_name_kind_proto = {
>  	.arg4_type	= ARG_ANYTHING,
>  };
>  
> -BTF_ID_LIST_GLOBAL_SINGLE(btf_task_struct_ids, struct, task_struct)
> +BTF_ID_LIST_GLOBAL(btf_task_struct_ids)
> +BTF_ID(struct, task_struct)
> +BTF_ID(struct, file)
> +BTF_ID(struct, vm_area_struct)

$ nm -v vmlinux |grep -A3 btf_task_struct_ids
ffffffff82adfd9c R btf_task_struct_ids
ffffffff82adfda0 r __BTF_ID__struct__file__715
ffffffff82adfda4 r __BTF_ID__struct__vm_area_struct__716
ffffffff82adfda8 r bpf_skb_output_btf_ids

KASAN thinks btf_task_struct_ids has 4 bytes only.

BUG: KASAN: global-out-of-bounds in task_iter_init+0x212/0x2e7 kernel/bpf/task_iter.c:661
Read of size 4 at addr ffffffff90297404 by task swapper/0/1

CPU: 1 PID: 1 Comm: swapper/0 Not tainted 5.15.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description.constprop.0.cold+0xf/0x309 mm/kasan/report.c:256
 __kasan_report mm/kasan/report.c:442 [inline]
 kasan_report.cold+0x83/0xdf mm/kasan/report.c:459
 task_iter_init+0x212/0x2e7 kernel/bpf/task_iter.c:661
 do_one_initcall+0x103/0x650 init/main.c:1295
 do_initcall_level init/main.c:1368 [inline]
 do_initcalls init/main.c:1384 [inline]
 do_basic_setup init/main.c:1403 [inline]
 kernel_init_freeable+0x6b1/0x73a init/main.c:1606
 kernel_init+0x1a/0x1d0 init/main.c:1497
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
 </TASK>

The buggy address belongs to the variable:
 btf_task_struct_ids+0x4/0x40
