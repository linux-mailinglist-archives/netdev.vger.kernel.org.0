Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1ECF3E2C78
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 16:26:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238810AbhHFOZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 10:25:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238715AbhHFOZx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 10:25:53 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 933B8C0613CF;
        Fri,  6 Aug 2021 07:25:37 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id j1so16880829pjv.3;
        Fri, 06 Aug 2021 07:25:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=q/j3Xb+QXNRlW1sZUNvztC5XQiybXR3PMONgEvC1s+k=;
        b=Yk9bG9BIee00+d4vyRk0Y5K4ZO5QOEgv5x7gOJ9COavYzXJO+zCZYbE/lvP9UzqTZo
         XY0IBIYNFYATpT3BuXN39IU35SxRcPQbafqa6KRgOk+7cFzxIK9MWWkCfZ/Tc7rXIoWj
         euPScV02xmRsuKyMoQjjV1yCNgXfAlj3YOYFvCBVkDNS5ntnRd1Y/qqIq1385OaBUdap
         ZXx4PTtZVXr0uzfhEiXTbU/I6hqJY3I6zYLjqitBtM9PJ8upOTYto2sWF0nB5be4vPzI
         IQ/pqUJCVxy6T/SWWe3A9Aok2WHwbABWmMGTmFiiSZ3+8z8BXkQI7KVVuF4KlTVbagnQ
         F8Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=q/j3Xb+QXNRlW1sZUNvztC5XQiybXR3PMONgEvC1s+k=;
        b=bNFn0YM7OqyhDnQr0RC0GWhJ8XUkcF2IpV27Lei+M/wGbq7F0n3im2qKmT6b8OMn5j
         PS5bOgE2SolPtjEfLqPkNxMinXiEC7K8mif7B/lD6k14Crq7JiX5scMDsQdqI6TmTY4H
         QPzS3wMzm+3AvMvcP13vQoauvRO8SZ3Ulpfgqzbzz0w2e0NBcS0UQx0FrZF2K8dZ6nUd
         FsmBhd4PxiC7R3dJgn5FbR3vFhPAlBWakHOrUb+8Yr1RkHp6euxblmlgbBwBNkmve8AD
         Rz9kyNLytSPCKPZ59V7qy1+0VMZV8bytkF7exDvAjZ/3WFSB0ByMzdEOdhEFTQzE3oS2
         xd7Q==
X-Gm-Message-State: AOAM530cGVKLmd/BTW08jmufJvu2WME+ZN1UfMpTRvKPIpTSf/ndSxVf
        GWCXrM9ZtQifyi4idefgsCc=
X-Google-Smtp-Source: ABdhPJxcFjX0A5zWaEjKiJb+3hMZHioagJWgs/KwFTj8HB+bbOoIUWO2YijQDuwlATUe7chMY1bfIQ==
X-Received: by 2002:aa7:9117:0:b029:35c:4791:ff52 with SMTP id 23-20020aa791170000b029035c4791ff52mr10775088pfh.76.1628259937154;
        Fri, 06 Aug 2021 07:25:37 -0700 (PDT)
Received: from ty-ThinkPad-X280 ([240b:11:82a2:3000:e2d5:fd62:ea40:4dc4])
        by smtp.gmail.com with ESMTPSA id f4sm12967400pgi.68.2021.08.06.07.25.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 07:25:36 -0700 (PDT)
Date:   Fri, 6 Aug 2021 23:25:32 +0900
From:   Tatsuhiko Yasumatsu <th.yasumatsu@gmail.com>
To:     Kees Cook <keescook@chromium.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH] bpf: Fix integer overflow involving bucket_size
Message-ID: <20210806142532.GC87387@ty-ThinkPad-X280>
References: <20210805140515.35630-1-th.yasumatsu@gmail.com>
 <202108050725.384AA3E0@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202108050725.384AA3E0@keescook>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 05, 2021 at 07:26:49AM -0700, Kees Cook wrote:
> On Thu, Aug 05, 2021 at 11:05:15PM +0900, Tatsuhiko Yasumatsu wrote:
> > In __htab_map_lookup_and_delete_batch(), hash buckets are iterated over
> > to count the number of elements in each bucket (bucket_size).
> > If bucket_size is large enough, the multiplication to calculate
> > kvmalloc() size could overflow, resulting in out-of-bounds write
> > as reported by KASAN.
> > 
> > [...]
> > [  104.986052] BUG: KASAN: vmalloc-out-of-bounds in __htab_map_lookup_and_delete_batch+0x5ce/0xb60
> > [  104.986489] Write of size 4194224 at addr ffffc9010503be70 by task crash/112
> > [  104.986889]
> > [  104.987193] CPU: 0 PID: 112 Comm: crash Not tainted 5.14.0-rc4 #13
> > [  104.987552] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
> > [  104.988104] Call Trace:
> > [  104.988410]  dump_stack_lvl+0x34/0x44
> > [  104.988706]  print_address_description.constprop.0+0x21/0x140
> > [  104.988991]  ? __htab_map_lookup_and_delete_batch+0x5ce/0xb60
> > [  104.989327]  ? __htab_map_lookup_and_delete_batch+0x5ce/0xb60
> > [  104.989622]  kasan_report.cold+0x7f/0x11b
> > [  104.989881]  ? __htab_map_lookup_and_delete_batch+0x5ce/0xb60
> > [  104.990239]  kasan_check_range+0x17c/0x1e0
> > [  104.990467]  memcpy+0x39/0x60
> > [  104.990670]  __htab_map_lookup_and_delete_batch+0x5ce/0xb60
> > [  104.990982]  ? __wake_up_common+0x4d/0x230
> > [  104.991256]  ? htab_of_map_free+0x130/0x130
> > [  104.991541]  bpf_map_do_batch+0x1fb/0x220
> > [...]
> > 
> > In hashtable, if the elements' keys have the same jhash() value, the
> > elements will be put into the same bucket. By putting a lot of elements
> > into a single bucket, the value of bucket_size can be increased to
> > trigger the integer overflow.
> > 
> > Triggering the overflow is possible for both callers with CAP_SYS_ADMIN
> > and callers without CAP_SYS_ADMIN.
> > 
> > It will be trivial for a caller with CAP_SYS_ADMIN to intentionally
> > reach this overflow by enabling BPF_F_ZERO_SEED. As this flag will set
> > the random seed passed to jhash() to 0, it will be easy for the caller
> > to prepare keys which will be hashed into the same value, and thus put
> > all the elements into the same bucket.
> > 
> > If the caller does not have CAP_SYS_ADMIN, BPF_F_ZERO_SEED cannot be
> > used. However, it will be still technically possible to trigger the
> > overflow, by guessing the random seed value passed to jhash() (32bit)
> > and repeating the attempt to trigger the overflow. In this case,
> > the probability to trigger the overflow will be low and will take
> > a very long time.
> > 
> > Fix the integer overflow by casting 1 operand to u64.
> > 
> > Fixes: 057996380a42 ("bpf: Add batch ops to all htab bpf map")
> > Signed-off-by: Tatsuhiko Yasumatsu <th.yasumatsu@gmail.com>
> > ---
> >  kernel/bpf/hashtab.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
> > index 72c58cc516a3..e29283c3b17f 100644
> > --- a/kernel/bpf/hashtab.c
> > +++ b/kernel/bpf/hashtab.c
> > @@ -1565,8 +1565,8 @@ __htab_map_lookup_and_delete_batch(struct bpf_map *map,
> >  	/* We cannot do copy_from_user or copy_to_user inside
> >  	 * the rcu_read_lock. Allocate enough space here.
> >  	 */
> > -	keys = kvmalloc(key_size * bucket_size, GFP_USER | __GFP_NOWARN);
> > -	values = kvmalloc(value_size * bucket_size, GFP_USER | __GFP_NOWARN);
> > +	keys = kvmalloc((u64)key_size * bucket_size, GFP_USER | __GFP_NOWARN);
> > +	values = kvmalloc((u64)value_size * bucket_size, GFP_USER | __GFP_NOWARN);
> 
> Please, no open-coded multiplication[1]. This should use kvmalloc_array()
> instead.
> 
> -Kees
> 
> [1] https://www.kernel.org/doc/html/latest/process/deprecated.html#open-coded-arithmetic-in-allocator-arguments
> 
> >  	if (!keys || !values) {
> >  		ret = -ENOMEM;
> >  		goto after_loop;
> > -- 
> > 2.25.1
> > 
> 
> -- 
> Kees Cook
Thank you for pointing out.
I'll modify the patch.

Regards,
Tatsuhiko Yasumatsu
