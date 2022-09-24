Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 149D15E87E8
	for <lists+netdev@lfdr.de>; Sat, 24 Sep 2022 05:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233097AbiIXDUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 23:20:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232776AbiIXDUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 23:20:22 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F2D91A399;
        Fri, 23 Sep 2022 20:20:20 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id l10so1717097plb.10;
        Fri, 23 Sep 2022 20:20:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date;
        bh=zdaZUg3/Ml2ij6XPZD2qg9IOy8atuUvae1lDmHhGEaU=;
        b=UnG1HqbKS/mgMg2dkwoqyo9cxa/2p7p+q8MDbzDOgljy0JmBKN0AWL+/mahBJ/oE4b
         /9QD89ZRZ9yccoJzfPy1SQYt46FZAHzGDAXYLKiMDDVay1UH7uAAzk0Pnp4PMrM/DYFA
         qct+9CeD/c4KcYv4qvhJlG7CUUdSyifL0o4iXE3JixbsRu10MtIcZU1pnh/dg3IaJDGW
         l/o4f/rGLnfGtadyK68xaOvEpWZxNrSqawqgdBi7N/MUUR7Q7HiQSxZMg6C29UfLCrcf
         Cc6YLDBbmkNwdTZc1eALtudTSBzGRjfP7tPAUl52zchsEqh82XFo68pJm7Ob1HOBZZ7b
         +ttA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date;
        bh=zdaZUg3/Ml2ij6XPZD2qg9IOy8atuUvae1lDmHhGEaU=;
        b=f/uXecO7C25VG6UFoogqSScDLMKiKV09tIurppSCAlMrKksQl6sij36gIbKzfEfL4N
         DfUTUE4PFR+ZY/NjwbntGGA9pdakB/rWIFMREX14TQr0Un5d8SE9sI+8T7xAdsvqpMRF
         pPwvz0B/DU0nP3USeXHza9jh1zhsisw8o0Zlishei3xKXu4l7Km0PkTPOp87sHqUbiGr
         mLiNZy/Z9TvAh2q9R139GYNHiLVx9Y+OjKIMrIztYxq+ZFWqPjHdhTTOrHeLV1jnP8sM
         rLQdcpdRgXXiv5ND0wVG2h8M1YKgthYAXKBL8UY1JAvQNtceLIYSkga0H0Jm1xn6BXZb
         GwEw==
X-Gm-Message-State: ACrzQf1iUhQm/ts0uILeI+LFAEg9cC4IOBvQLJgce2zAHbt25pzAs+cW
        1M4KR8esVjFDS5MInP1ILY0=
X-Google-Smtp-Source: AMsMyM5q0D4IBPE+GYfOG2nQqyklGERs9XUlFfWm9EZr1G063EsXvtnS95wpHmmMGpSeA2bakubf+g==
X-Received: by 2002:a17:903:22c2:b0:178:3c7c:18af with SMTP id y2-20020a17090322c200b001783c7c18afmr11513864plg.134.1663989619818;
        Fri, 23 Sep 2022 20:20:19 -0700 (PDT)
Received: from localhost (2603-800c-1a02-1bae-a7fa-157f-969a-4cde.res6.spectrum.com. [2603:800c:1a02:1bae:a7fa:157f:969a:4cde])
        by smtp.gmail.com with ESMTPSA id y10-20020a17090a2b4a00b001fab208523esm2302079pjc.3.2022.09.23.20.20.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 20:20:19 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Fri, 23 Sep 2022 17:20:18 -1000
From:   Tejun Heo <tj@kernel.org>
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, hannes@cmpxchg.org,
        mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org,
        lizefan.x@bytedance.com, cgroups@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH bpf-next 10/10] bpf, memcg: Add new item bpf into
 memory.stat
Message-ID: <Yy53cgcwx+hTll4R@slm.duckdns.org>
References: <20220921170002.29557-1-laoar.shao@gmail.com>
 <20220921170002.29557-11-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220921170002.29557-11-laoar.shao@gmail.com>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Wed, Sep 21, 2022 at 05:00:02PM +0000, Yafang Shao wrote:
> A new item 'bpf' is introduced into memory.stat, then we can get the memory
> consumed by bpf. Currently only the memory of bpf-map is accounted.
> The accouting of this new item is implemented with scope-based accouting,
> which is similar to set_active_memcg(). In this scope, the memory allocated
> will be accounted or unaccounted to a specific item, which is specified by
> set_active_memcg_item().

Imma let memcg folks comment on the implementation. Hmm... I wonder how this
would tie in with the BPF memory allocator Alexei is working on.

> The result in cgroup v1 as follows,
> 	$ cat /sys/fs/cgroup/memory/foo/memory.stat | grep bpf
> 	bpf 109056000
> 	total_bpf 109056000
> After the map is removed, the counter will become zero again.
>         $ cat /sys/fs/cgroup/memory/foo/memory.stat | grep bpf
>         bpf 0
>         total_bpf 0
> 
> The 'bpf' may not be 0 after the bpf-map is destroyed, because there may be
> cached objects.

What's the difference between bpf and total_bpf? Where's total_bpf
implemented? It doesn't seem to be anywhere. Please also update
Documentation/admin-guide/cgroup-v2.rst.

> Note that there's no kmemcg in root memory cgroup, so the item 'bpf' will
> be always 0 in root memory cgroup. If a bpf-map is charged into root memcg
> directly, its memory size will not be accounted, so the 'total_bpf' can't
> be used to monitor system-wide bpf memory consumption yet.

So, system-level accounting is usually handled separately as it's most
likely that we'd want the same stat at the system level even when cgroup is
not implemented. Here, too, it'd make sense to first implement system level
bpf memory usage accounting, expose that through /proc/meminfo and then use
the same source for root level cgroup stat.

Thanks.

-- 
tejun
