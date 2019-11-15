Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EAF5FDF72
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 14:57:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727503AbfKON5H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 08:57:07 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:43321 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727380AbfKON5H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 08:57:07 -0500
Received: by mail-pl1-f195.google.com with SMTP id a18so4711589plm.10
        for <netdev@vger.kernel.org>; Fri, 15 Nov 2019 05:57:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=5fRrTg/vhAwT1fmQQ8btG004QGt2nYF+M9QxTu9sTWA=;
        b=RcEy7KwUZydagXfYUZ2++g2nSi9WV8Ma+cw4lqwUnkyV+/lmAGo3r0YLod1CewxhkS
         g8Eo1y2PZgBJ8VgJm0yv839WGxkfFKNvCqLzrRW8zcQtUZawz1GYU3h/zXP/CAHpoXz4
         Wyoza7KbgtGjuoJxpJ17i0SeJrZD/xGG8zdy5Z1olhTmbVfpku4PtRN5FRkeTkC5Rv7l
         k+FXtjwKnox3KQCv4xQwDduZETiKFcovvIc7SPZ9VkHWt/Ou/B0FsV2i4jHy68Z+2NTg
         T0KFiyLac//Y80tw2etZ9rrvDXaxtJUmxQDQZ8CuoWrtoBiG4CVzD7K1hhSC2+oUgV4Y
         iiCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=5fRrTg/vhAwT1fmQQ8btG004QGt2nYF+M9QxTu9sTWA=;
        b=s/ZiNmFwjE/gnetwgWFv6AyChP679bWBYu2uSnauKOqXpc5fv+Pk1l1gQptP5S7QxV
         wjLABVyCt8t9n5sJUlUrBO1ks7Mjj7CWMiqB30EC+gBk6KeVzACKxVexph/nZuKQ9KOU
         8k6VrYme0vPAkrc8O6beLVv/vi27zkM2a6LJVatRZ09cOj9RHF21daEXPYA2w46PKjyZ
         /ZWwh608G97tbWMaA3ltSdQEbeV5gmuxgR2Zh1na9N/qfiTEmRSLXjRkEmqDHoFSLDN1
         v40RmERmXY9BoweLWX9vDYhzCrteCI5uFUDrtUjr74U4pQqs4iRwFb3ipE8GYsJ8uuXp
         /9kA==
X-Gm-Message-State: APjAAAXlRE8oYMjudrZRkdBt+cXm577NKu5dt7ETUKlzVntPYVsNRQv1
        eNNwF5j4w3AHUzvjxB3Q0chC5A==
X-Google-Smtp-Source: APXvYqxMZJAbje2U8MlpKS6E4KT497xnMsIsmDC2+Ryy/8kslK0/GaAXloCNb0nXTxcqofJSjEKBBg==
X-Received: by 2002:a17:90a:7bcc:: with SMTP id d12mr19825661pjl.63.1573826225906;
        Fri, 15 Nov 2019 05:57:05 -0800 (PST)
Received: from localhost ([2620:10d:c090:180::a9db])
        by smtp.gmail.com with ESMTPSA id p3sm12009787pfb.163.2019.11.15.05.57.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2019 05:57:05 -0800 (PST)
Date:   Fri, 15 Nov 2019 08:57:03 -0500
From:   Johannes Weiner <hannes@cmpxchg.org>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, andrii.nakryiko@gmail.com,
        kernel-team@fb.com, Rik van Riel <riel@surriel.com>
Subject: Re: [PATCH v4 bpf-next 2/4] bpf: add mmap() support for
 BPF_MAP_TYPE_ARRAY
Message-ID: <20191115135703.GA309457@cmpxchg.org>
References: <20191115040225.2147245-1-andriin@fb.com>
 <20191115040225.2147245-3-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191115040225.2147245-3-andriin@fb.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
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

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
