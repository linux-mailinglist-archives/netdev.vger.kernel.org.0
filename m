Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05BB9FD3C9
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 05:45:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727166AbfKOEp0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 23:45:26 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:43984 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726549AbfKOEpZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 23:45:25 -0500
Received: by mail-pl1-f193.google.com with SMTP id a18so3774889plm.10;
        Thu, 14 Nov 2019 20:45:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=zp0EkuTAfCyU3TOfat2tURAscamqJyiKCYFYh95KC9Y=;
        b=Uvvx12ulSsuclHGxLxRKcbnX1hvkC6X1UJh37k7o2EvM6pnQD4eGuh9h+yu6rQwwAw
         6H3Ut7ImmPx6yZeuc9tKV1W8BuFADKpW9Wv43cqlqSUTnj5KrIa1af6RUx62us68aSpO
         QsdikKljQbjsOHYWg4WJKepz4cekERzdRhN3QAwR/gcdUkA0hzvdbBbQVvQgVwko5Z5G
         rH4TXAeWX1xfitVZetm7oruJWoyjazVBxTGa2lHLCvFKbrE2C7mCzio0ckRmgI165wDD
         f01BgU2ZH79St/CEGT3SZ9nzXGvSKRXvm7uIixhmRzhAbtkpLsLsxOKbpcANH6v6uxQ3
         hiPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=zp0EkuTAfCyU3TOfat2tURAscamqJyiKCYFYh95KC9Y=;
        b=sOXBBfLXdQ6gYanWkHPtDJFwc6280UT2ETi3p4Nc3CB7gVudy2C0RJ7/d3yho3RZy3
         Okgf4EEdV1IU6SxErjZ+b8ltJGmef+i1rvlaZc0aIWiqf5AJyS8gcZSuhdy2d1w7piT/
         kb1ptRN+0t+xLZv7mgkV167hCAoyoZ2B0GxQQpxfSdm8kw/cGYYvZofDy4KNLLo5V8D5
         6/Q5O2U9YqTJWlCB4pmGpEMw9m2+SoI2CfIhDJ4975/GbPunjhMu/tgCEMvatPLQK15P
         7cVSBFx79Vla91UH+Plxp815xATEUBbaHQ0ISKMc2BrC+SOVcWC+BpNAciuiahCY+dIX
         xZFw==
X-Gm-Message-State: APjAAAWr0FJNbj2JwBPQi/+dxKgcrfo7QqXG7Rhe/njxmjnJfL+UIO9G
        9hPViY1xv6Qk+Lt2yzZL23FlG7Cd
X-Google-Smtp-Source: APXvYqyl3v1j86ODq4j7anq/8l4nn+UMXP3KQxfoQSp2iuxylztQpzNW2oQeQMLjFl5iXPHrOk3tAw==
X-Received: by 2002:a17:90a:f496:: with SMTP id bx22mr17357298pjb.101.1573793122887;
        Thu, 14 Nov 2019 20:45:22 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::a328])
        by smtp.gmail.com with ESMTPSA id z18sm8395241pgv.90.2019.11.14.20.45.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Nov 2019 20:45:22 -0800 (PST)
Date:   Thu, 14 Nov 2019 20:45:19 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, andrii.nakryiko@gmail.com,
        kernel-team@fb.com, Johannes Weiner <hannes@cmpxchg.org>,
        Rik van Riel <riel@surriel.com>
Subject: Re: [PATCH v4 bpf-next 2/4] bpf: add mmap() support for
 BPF_MAP_TYPE_ARRAY
Message-ID: <20191115044518.sqh3y3bwtjfp5zex@ast-mbp.dhcp.thefacebook.com>
References: <20191115040225.2147245-1-andriin@fb.com>
 <20191115040225.2147245-3-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191115040225.2147245-3-andriin@fb.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 14, 2019 at 08:02:23PM -0800, Andrii Nakryiko wrote:
> Add ability to memory-map contents of BPF array map. This is extremely useful
> for working with BPF global data from userspace programs. It allows to avoid
> typical bpf_map_{lookup,update}_elem operations, improving both performance
> and usability.
> 
> There had to be special considerations for map freezing, to avoid having
> writable memory view into a frozen map. To solve this issue, map freezing and
> mmap-ing is happening under mutex now:
>   - if map is already frozen, no writable mapping is allowed;
>   - if map has writable memory mappings active (accounted in map->writecnt),
>     map freezing will keep failing with -EBUSY;
>   - once number of writable memory mappings drops to zero, map freezing can be
>     performed again.
> 
> Only non-per-CPU plain arrays are supported right now. Maps with spinlocks
> can't be memory mapped either.
> 
> For BPF_F_MMAPABLE array, memory allocation has to be done through vmalloc()
> to be mmap()'able. We also need to make sure that array data memory is
> page-sized and page-aligned, so we over-allocate memory in such a way that
> struct bpf_array is at the end of a single page of memory with array->value
> being aligned with the start of the second page. On deallocation we need to
> accomodate this memory arrangement to free vmalloc()'ed memory correctly.
> 
> One important consideration regarding how memory-mapping subsystem functions.
> Memory-mapping subsystem provides few optional callbacks, among them open()
> and close().  close() is called for each memory region that is unmapped, so
> that users can decrease their reference counters and free up resources, if
> necessary. open() is *almost* symmetrical: it's called for each memory region
> that is being mapped, **except** the very first one. So bpf_map_mmap does
> initial refcnt bump, while open() will do any extra ones after that. Thus
> number of close() calls is equal to number of open() calls plus one more.
> 
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Rik van Riel <riel@surriel.com>
> Acked-by: Song Liu <songliubraving@fb.com>
> Acked-by: John Fastabend <john.fastabend@gmail.com>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  include/linux/bpf.h            | 11 ++--
>  include/linux/vmalloc.h        |  1 +
>  include/uapi/linux/bpf.h       |  3 ++
>  kernel/bpf/arraymap.c          | 59 +++++++++++++++++---
>  kernel/bpf/syscall.c           | 99 ++++++++++++++++++++++++++++++++--
>  mm/vmalloc.c                   | 20 +++++++
>  tools/include/uapi/linux/bpf.h |  3 ++
>  7 files changed, 184 insertions(+), 12 deletions(-)
> 
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 6fbe599fb977..8021fce98868 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -12,6 +12,7 @@
>  #include <linux/err.h>
>  #include <linux/rbtree_latch.h>
>  #include <linux/numa.h>
> +#include <linux/mm_types.h>
>  #include <linux/wait.h>
>  #include <linux/u64_stats_sync.h>
>  
> @@ -66,6 +67,7 @@ struct bpf_map_ops {
>  				     u64 *imm, u32 off);
>  	int (*map_direct_value_meta)(const struct bpf_map *map,
>  				     u64 imm, u32 *off);
> +	int (*map_mmap)(struct bpf_map *map, struct vm_area_struct *vma);
>  };
>  
>  struct bpf_map_memory {
> @@ -94,9 +96,10 @@ struct bpf_map {
>  	u32 btf_value_type_id;
>  	struct btf *btf;
>  	struct bpf_map_memory memory;
> +	char name[BPF_OBJ_NAME_LEN];
>  	bool unpriv_array;
> -	bool frozen; /* write-once */
> -	/* 48 bytes hole */
> +	bool frozen; /* write-once; write-protected by freeze_mutex */
> +	/* 22 bytes hole */
>  
>  	/* The 3rd and 4th cacheline with misc members to avoid false sharing
>  	 * particularly with refcounting.
> @@ -104,7 +107,8 @@ struct bpf_map {
>  	atomic64_t refcnt ____cacheline_aligned;
>  	atomic64_t usercnt;
>  	struct work_struct work;
> -	char name[BPF_OBJ_NAME_LEN];
> +	struct mutex freeze_mutex;
> +	u64 writecnt; /* writable mmap cnt; protected by freeze_mutex */
>  };

Can the mutex be moved into bpf_array instead of being in bpf_map that is
shared across all map types?
If so then can you reuse the mutex that Daniel is adding in his patch 6/8
of tail_call series? Not sure what would the right name for such mutex.
It will be used for your map_freeze logic and for Daniel's text_poke.

