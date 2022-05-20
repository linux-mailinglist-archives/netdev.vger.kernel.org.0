Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AAF252F0F0
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 18:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351783AbiETQpP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 12:45:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiETQpN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 12:45:13 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73D5D178567;
        Fri, 20 May 2022 09:45:12 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d22so7803215plr.9;
        Fri, 20 May 2022 09:45:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=u22Vdb8ad4QsGUpvqDD4jw8opLANlipXffF4J28OkDw=;
        b=alC71XCAjWLZ2L+MKQYDKx3KTDbWUY+ds3nxi6wLqgO7s9wjvHmeS0X4mp5EnSoUUl
         5azRlTmtfw/UqAiUwhI5sZANOPrUEC/QVcgidBJjdj4vzvuMoqNBW3nF9tMw2moyZlgN
         8wyQDt0+i8Ada0za5PsJuWKfV+qMDHHHk2GretQeRaKoVLkVf0wFl6lveJrSxek6tugV
         CGXMeMWuv7bzSJ5ekUqL6IxWkCb1TWH3HxYnZOseiU6svnyorwth8UX8rb5PIV8m9KMA
         KOP4TMl/Nnd2YqrNvrxDocxEl3yX1fsJgCEhZhQWU9/MAB/jhNnUTNVoxy08eGE2Tu0V
         r/5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=u22Vdb8ad4QsGUpvqDD4jw8opLANlipXffF4J28OkDw=;
        b=IOtTvcJiQ8WXVNaJploMVtDsmP/0ioJ8LIo6qbOKA8PBVzkaqhbGsSnzlqr3PPAmx1
         HTZdskCfxZ6kobIxp/pLmmnUAQLTocSwwSVTPRT+mUnskJLEQSZW/5/F2AILMVbVo+Bn
         abQ4kEBLSnYUf8IeeQEorU6IyQ427T1twq7712qCViQXHEb280Epndgd77zPb/QPavRa
         PG8Z2+8cD0nG59V3KA6mRVXUsEUtIW162uujDcNf8rx4rwDKRqtgl2+o5RqJwjPGvOng
         DMNEAft2AsCC4I3D+eRE7UuxFGp4FmBPLJvRMZIgmiQ9j9naXZPe3PfQQ7b2fxlAYO7R
         mdBQ==
X-Gm-Message-State: AOAM533unz4xbJLttFEap9bNm7IAS1QM4dwHhSsG7XxbrVHYAv7LqyLv
        ZeL2It1tQCf5NmXZwXJCsLg=
X-Google-Smtp-Source: ABdhPJyP4R45XL7Ygkc11JWnS15dH4cQ+zV/iI/2vxrlGm1gisg0ogaD4Bj036lBydbUC7eRTm8umQ==
X-Received: by 2002:a17:90a:cc02:b0:1df:257a:5396 with SMTP id b2-20020a17090acc0200b001df257a5396mr12031837pju.190.1653065111792;
        Fri, 20 May 2022 09:45:11 -0700 (PDT)
Received: from localhost ([2620:10d:c090:400::4:1761])
        by smtp.gmail.com with ESMTPSA id j7-20020a170902690700b001616b71e5e6sm5917456plk.175.2022.05.20.09.45.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 May 2022 09:45:11 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Fri, 20 May 2022 06:45:10 -1000
From:   Tejun Heo <tj@kernel.org>
To:     Yonghong Song <yhs@fb.com>
Cc:     Yosry Ahmed <yosryahmed@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shuah Khan <shuah@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Michal Hocko <mhocko@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        David Rientjes <rientjes@google.com>,
        Greg Thelen <gthelen@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH bpf-next v1 3/5] bpf: Introduce cgroup iter
Message-ID: <YofFli6UCX4J5YnU@slm.duckdns.org>
References: <20220520012133.1217211-1-yosryahmed@google.com>
 <20220520012133.1217211-4-yosryahmed@google.com>
 <YodGI73xq8aIBrNM@slm.duckdns.org>
 <CAJD7tkbvMcMWESMcWi6TtdCKLr6keBNGgZTnqcHZvBrPa1qWPw@mail.gmail.com>
 <YodNLpxut+Zddnre@slm.duckdns.org>
 <73fd9853-5dab-8b59-24a0-74c0a6cae88e@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <73fd9853-5dab-8b59-24a0-74c0a6cae88e@fb.com>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello, Yonghong.

On Fri, May 20, 2022 at 09:29:43AM -0700, Yonghong Song wrote:
> Maybe you can have a bpf program signature like below:
> 
> int BPF_PROG(dump_vmscan, struct bpf_iter_meta *meta, struct cgroup *cgrp,
> struct cgroup *parent_cgrp)
> 
> parent_cgrp is NULL when cgrp is the root cgroup.
> 
> I would like the bpf program should send the following information to
> user space:
>    <parent cgroup dir name> <current cgroup dir name>

I don't think parent cgroup dir name would be sufficient to reconstruct the
path given that multiple cgroups in different subtrees can have the same
name. For live cgroups, userspace can find the path from id (or ino) without
traversing anything by constructing the fhandle, open it open_by_handle_at()
and then reading /proc/self/fd/$FD symlink -
https://lkml.org/lkml/2020/12/2/1126. This isn't available for dead cgroups
but I'm not sure how much that'd matter given that they aren't visible from
userspace anyway.

>    <various stats interested by the user>
> 
> This way, user space can easily construct the cgroup hierarchy stat like
>                            cpu   mem   cpu pressure   mem pressure ...
>    cgroup1                 ...
>       child1               ...
>         grandchild1        ...
>       child2               ...
>    cgroup 2                ...
>       child 3              ...
>         ...                ...
> 
> the bpf iterator can have additional parameter like
> cgroup_id = ... to only call bpf program once with that
> cgroup_id if specified.
> 
> The kernel part of cgroup_iter can call cgroup_rstat_flush()
> before calling cgroup_iter bpf program.
> 
> WDYT?

Would it work to just pass in @cgrp and provide a group of helpers so that
the program can do whatever it wanna do including looking up the full path
and passing that to userspace?

Thanks.

-- 
tejun
