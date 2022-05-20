Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A807552F5C0
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 00:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353931AbiETWh0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 18:37:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234482AbiETWhZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 18:37:25 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F34B18542F
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 15:37:24 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id f2so13262739wrc.0
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 15:37:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rjHRlb1I3VbpwM5vlx4HP72yEGIAgQZNiDcXaK4IrWE=;
        b=CqWaIRBYO4RMPakxBtGQr0gF0h+doHGHgL6p8/uY/2bT1FSn5s8z8EPF3lDt9rHVYn
         5itjBBvHeFp2Vo1o45+HjsRWft6V3cBTf5aRQI4gxDIoCJ+CfcA90Ir0c7oNRAloniK1
         1YxLAnp74KeRbPRxZxm8rr9oSTbEUR5wTuxgh1Kc4peUuKD2q70w//S4s5rdx9mdkq8z
         lEHEdSjqR540R7Ak9Rtm+TwYGHdLqdEiAK1p52r+Zl82Ri960sciviRPXFw93JTz39Dp
         zZpJ44VH6SOPhSaFZAGCztGyQ/4jt7oyJpC4KD463XIDqi89CL5o476rYfInHk4PdGNz
         MWRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rjHRlb1I3VbpwM5vlx4HP72yEGIAgQZNiDcXaK4IrWE=;
        b=rozlgMLKKsXEnGQ6CbxRkSk3z1VbrZwpIxqW9fO8QCULg/eYr2iH4M11YkhtaNIeY3
         n50QhWwlGZOTG+sJRVo3wtJ6MgV5ZHg59aJTj+WpD5P1xC4LOyALktCOYVeAybAdXwfI
         W5K0Lhk8NvDLJAIg31MaFpebQ2h6JEdl1yFfT2UUK8Nw5mjAXKtpuVovKEXdvYOyKIr0
         +CuUqHBF7q1MjSO8nGZdi1n1XsQ1dvbiWgAnJGMjjndxxf/SqX00ZKcU1C/Ww8Wdq6dm
         EkE2e4mfOi2REP+mXBFe9TVC/BL4MRHIVJoJ0yUsa87dIRQasmRHcvhB2GoMPy74bDxK
         Q8xA==
X-Gm-Message-State: AOAM531uddBg6oQdPMtGXTcyt/0h8qgUL73G6BmE2YdIg39uAd1qsJuT
        L5oI+m3BHMAOlIkNUHKBPLyFSUirtPKBHTJaA1l9tg==
X-Google-Smtp-Source: ABdhPJypRPOYtIiBfhWElJxzVoZrGRTDuStikkjFn5DjehwLSBWHm7H0Z8zWY4JT6S0WJ5gnLML2CYTyrTe1nVMkUmQ=
X-Received: by 2002:a05:6000:154a:b0:20c:7e65:c79e with SMTP id
 10-20020a056000154a00b0020c7e65c79emr10148218wry.582.1653086242817; Fri, 20
 May 2022 15:37:22 -0700 (PDT)
MIME-Version: 1.0
References: <20220520012133.1217211-1-yosryahmed@google.com>
 <20220520012133.1217211-4-yosryahmed@google.com> <YodGI73xq8aIBrNM@slm.duckdns.org>
 <CAJD7tkbvMcMWESMcWi6TtdCKLr6keBNGgZTnqcHZvBrPa1qWPw@mail.gmail.com>
 <YodNLpxut+Zddnre@slm.duckdns.org> <73fd9853-5dab-8b59-24a0-74c0a6cae88e@fb.com>
 <YofFli6UCX4J5YnU@slm.duckdns.org> <CA+khW7gjWVKrwCgDD-4ZdCf5CMcA4-YL0bLm6aWM74+qNQ4c0A@mail.gmail.com>
 <CAJD7tkaJQjfSy+YARFRkqQ8m7OGJHO9v91mSk-cFeo9Z5UVJKg@mail.gmail.com> <20220520221919.jnqgv52k4ajlgzcl@MBP-98dd607d3435.dhcp.thefacebook.com>
In-Reply-To: <20220520221919.jnqgv52k4ajlgzcl@MBP-98dd607d3435.dhcp.thefacebook.com>
From:   Yosry Ahmed <yosryahmed@google.com>
Date:   Fri, 20 May 2022 15:36:46 -0700
Message-ID: <CAJD7tkaa946SOBDksCzPto+7SzF+fDM=KMMOUMj2Ru+MBq5TEA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 3/5] bpf: Introduce cgroup iter
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Hao Luo <haoluo@google.com>, Tejun Heo <tj@kernel.org>,
        Yonghong Song <yhs@fb.com>,
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

On Fri, May 20, 2022 at 3:19 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Fri, May 20, 2022 at 02:18:42PM -0700, Yosry Ahmed wrote:
> > >
> > > The userspace needs to specify the identity of the cgroup, when
> > > creating bpf_iter. This identity could be cgroup id or fd. This
> > > identity needs to be converted to cgroup object somewhere before
> > > passing into bpf program to use.
> >
> >
> > Let's sum up the discussion here, I feel like we are losing track of
> > the main problem. IIUC the main concern is that cgroup_iter is not
> > effectively an iterator, it rather dumps information for one cgroup. I
> > like the suggestion to make it iterate cgroups by default, and an
> > optional cgroup_id parameter to make it only "iterate" this one
> > cgroup.
>
> We have bpf_map iterator that walks all bpf maps.
> When map iterator is parametrized with map_fd the iterator walks
> all elements of that map.
> cgroup iterator should have similar semantics.
> When non-parameterized it will walk all cgroups and their descendent
> depth first way. I believe that's what Yonghong is proposing.
> When parametrized it will start from that particular cgroup and
> walk all descendant of that cgroup only.
> The bpf prog can stop the iteration right away with ret 1.
> Maybe we can add two parameters. One -> cgroup_fd to use and another ->
> the order of iteration css_for_each_descendant_pre vs _post.
> wdyt?

So basically extend the current patch so that cgroup_id (or cgroup_fd)
is optional, and it specifies where the iteration starts. If not
provided, then we start at root. For our use case where we want the
iterator to only be invoked for one cgroup we make it return 1 to stop
after the first iteration.

I assume an order parameter is also needed to specify "pre" for our
use case to make sure we are starting iteration at the top cgroup (the
one whose cgroup_id is the parameter of the iterator).

Is my understanding correct? If yes, then this sounds very good. It is
generic enough, actually iterates cgroups, and works for our use case.
