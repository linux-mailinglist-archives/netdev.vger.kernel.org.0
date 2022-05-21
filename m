Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 331B452F7AC
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 04:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239442AbiEUCn0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 22:43:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231826AbiEUCnZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 22:43:25 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E6E8170F28
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 19:43:24 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id v14so9144013qtc.3
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 19:43:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ndrz/Orvp7gcBGGOOLwcGhWh997j9sWnxKmSb6IuujM=;
        b=BDgF8vyyA+xZnKQeleXK8QqAnjkCiXSY0NYaUoybbPy5lZReZm4LJLJRAB4oDF1E0J
         Ppe2rcbKXC2oj8Qi4MWBmYtHr1ikoaxG+mKJjuPFQ/rngPWYy4Q/NtPmoINXtIUrgBHp
         WdXsJgie3zycP4uG1rKtTn/E01eKwZ7sCXWGgkNqIGT/ZYIdB07JqIc7XPl4VfxGyS62
         c/k4oZqOXhjMkzb4cYRFlbPiBfv+JIrAm3Z3As4kkIabRD+ZXVZaF0qz7Xj0Qvgjhzyn
         wuMxjbep3l3CRiPhTcXqgQ2rz36IvwoT9pvEuYEXuX5XJeeKGbLCQCwuaUnrre94oQD1
         hz5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ndrz/Orvp7gcBGGOOLwcGhWh997j9sWnxKmSb6IuujM=;
        b=Qr1QR35ShiM6j65XI/XyWvJKSYYiHT3ro/LmiHrHFAbYrzzB8JS7dzsmjP58kBeXsp
         cizDmyQOmu6ew2t9H0UDFeCtfrl4Qgkw0m24hZNhutmMYSGbUPZeAvkOGVD3Xo/lrwd2
         nI9pH2aCjORDLXKWBCensDbKGYrEL1vfYoUhqRE/PLI/ovdwhhqFOIsLHiRonpKWk8s9
         3Bot9yRrcenjKbRtUCYjosjFU1yZaBs0FpHP4LQJuTnDRIUtFJBRQt4TEla3VRQlFq/i
         RWA0rs51qk76IBs+UXVfnaMx8m2WC2Q+UtfT/TBJ3PzA0BfUpaRohS74XNIky7CLRD2k
         Wy/w==
X-Gm-Message-State: AOAM532E9IPtyQPBHAL9s5Z7h56ujhnM2gOB7oPlKf3bro6keqgCqyxW
        /5BeHz+GqmylNuZoKcgC8Ame+HktM7/A5UxyOyI5+Q==
X-Google-Smtp-Source: ABdhPJy7qk5AkC7mPrQlU5XMbGy3TMIZ5unJtuwmwn9G6zlIPcpstv/bXZB69IiBHE4ipIOYfDHIjGXZr48xnITTgeM=
X-Received: by 2002:a05:622a:54e:b0:2f3:c9db:c512 with SMTP id
 m14-20020a05622a054e00b002f3c9dbc512mr9752878qtx.478.1653101003376; Fri, 20
 May 2022 19:43:23 -0700 (PDT)
MIME-Version: 1.0
References: <20220520012133.1217211-1-yosryahmed@google.com>
 <20220520012133.1217211-4-yosryahmed@google.com> <YodGI73xq8aIBrNM@slm.duckdns.org>
 <CAJD7tkbvMcMWESMcWi6TtdCKLr6keBNGgZTnqcHZvBrPa1qWPw@mail.gmail.com>
 <YodNLpxut+Zddnre@slm.duckdns.org> <73fd9853-5dab-8b59-24a0-74c0a6cae88e@fb.com>
 <YofFli6UCX4J5YnU@slm.duckdns.org> <CA+khW7gjWVKrwCgDD-4ZdCf5CMcA4-YL0bLm6aWM74+qNQ4c0A@mail.gmail.com>
 <CA+khW7iDDkO3h5WQixEA=nUL-tBmCTh7fMAf3iwNy98UfM-k9g@mail.gmail.com> <4cbdd3e9-c6fe-d796-5560-cd09c9220868@fb.com>
In-Reply-To: <4cbdd3e9-c6fe-d796-5560-cd09c9220868@fb.com>
From:   Hao Luo <haoluo@google.com>
Date:   Fri, 20 May 2022 19:43:12 -0700
Message-ID: <CA+khW7hGcrvihbb1CV4c4o6yO_3Ju3oU4_04G_A+TKh0vLHY3w@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 3/5] bpf: Introduce cgroup iter
To:     Yonghong Song <yhs@fb.com>
Cc:     Tejun Heo <tj@kernel.org>, Yosry Ahmed <yosryahmed@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
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
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 20, 2022 at 5:58 PM Yonghong Song <yhs@fb.com> wrote:
> On 5/20/22 2:49 PM, Hao Luo wrote:
> > Hi Tejun and Yonghong,
> >
> > On Fri, May 20, 2022 at 12:42 PM Hao Luo <haoluo@google.com> wrote:
> >>
> >> Hi Tejun and Yonghong,
> >>
> >> On Fri, May 20, 2022 at 9:45 AM Tejun Heo <tj@kernel.org> wrote:
> >>> On Fri, May 20, 2022 at 09:29:43AM -0700, Yonghong Song wrote:
> >>>>     <various stats interested by the user>
> >>>>
> >>>> This way, user space can easily construct the cgroup hierarchy stat like
> >>>>                             cpu   mem   cpu pressure   mem pressure ...
> >>>>     cgroup1                 ...
> >>>>        child1               ...
> >>>>          grandchild1        ...
> >>>>        child2               ...
> >>>>     cgroup 2                ...
> >>>>        child 3              ...
> >>>>          ...                ...
> >>>>
> >>>> the bpf iterator can have additional parameter like
> >>>> cgroup_id = ... to only call bpf program once with that
> >>>> cgroup_id if specified.
> >>
> >> Yep, this should work. We just need to make the cgroup_id parameter
> >> optional. If it is specified when creating bpf_iter_link, we print for
> >> that cgroup only. If it is not specified, we iterate over all cgroups.
> >> If I understand correctly, sounds doable.
> >>
> >
> > Yonghong, I realized that seek() which Tejun has been calling out, can
> > be used to specify the target cgroup, rather than adding a new
> > parameter. Maybe, we can pass cgroup_id to seek() on cgroup bpf_iter,
> > which will instruct read() to return the corresponding cgroup's stats.
> > On the other hand, reading without calling seek() beforehand will
> > return all the cgroups.
>
> Currently, seek is not supported for bpf_iter.
>
> const struct file_operations bpf_iter_fops = {
>          .open           = iter_open,
>          .llseek         = no_llseek,
>          .read           = bpf_seq_read,
>          .release        = iter_release,
> };
>
> But if seek() works, I don't mind to remove this restriction.
> But not sure what to seek. Do you mean to provide a cgroup_fd/cgroup_id
> as the seek() syscall parameter? This may work.

Yes, passing a cgroup_id as the seek() syscall parameter was what I meant.

Tejun previously requested us to support seek() for a proper iterator.
Since Alexei has a nice solution that all of us have ack'ed, I am not
sure whether we still want to add seek() for bpf_iter as Tejun asked.
I guess not.

>
> But considering we have parameterized example (map_fd) and
> in the future, we may have other parameterized bpf_iter
> (e.g., for one task). Maybe parameter-based approach is better.
>

Acknowledged.

> >
> > WDYT?
