Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F4D55225B8
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 22:44:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235680AbiEJUof (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 16:44:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236996AbiEJUo3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 16:44:29 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E818B2A3743
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 13:44:24 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id bg25so51848wmb.4
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 13:44:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=H+z42sapPI1YBphYIrh6dW0GFMAVRokw99cL8ZqGxg8=;
        b=CTpiNl02mk2asLHcnBsuNAVd8tR5UxljFjwGWN7EPCdyw8jw1qTJN8Kj958PoCw+f9
         C32LJd3iJyAPIc7JnhsDf3F+CLv0mIznaGhwzjGKAYcrkMmcqX0unecnaIRY4eg2RdS/
         0wpRZMze08BUkQN9Kfpmmxj4PSmOnYIqgNxsMT/R3rkcd0HxVerVL26sQmKyCcoM0a/m
         s7JJXvfYmJef+dh/gZmajmQP15BB/zKpZ1gNodzL0OvqccJTjiHJ10N8+lrMEhpadzdu
         fFFf+dHjfdsLLT+W0V8q1dm0F4FO7Oj3L3kgVi1f9Ro2JBTKBHwIl+3Ypo+uOj1B/r4q
         F3zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=H+z42sapPI1YBphYIrh6dW0GFMAVRokw99cL8ZqGxg8=;
        b=WuQRcqpRluluKbULOMjZgAj1YXCS4jl/AMy9GorvrakVCSf3lNDllwkLCFyqeQOzY3
         x6mXzzC3JqswxIQnmSV54dLnwQlFV9pIWCS/EmXudQl/TBJUHvgagXGfdZhJFoEBExTQ
         VD6BKL2gYknXV24RHu8HreQOpMXs0vFVlI+KjYTbSe80Swx1avcuAhL2B0gEFbHpZFsZ
         wK3J+odtx5dudq7vEKklrgKjV5bPAdYgIXig2hnw22ha1nJLkMzcu5lwdCg5rac8vrhZ
         g5Jo4GEDSlbrwmOuU9l/pv8uy6vvk45RpKhdo9C5sobhDqpmLC36qQtpDSdtO7AjXyw2
         BFbg==
X-Gm-Message-State: AOAM531HfQk75Fa4ffLZA5uHi4n21yBj/ZuYjgUXD5UBFRMZdwx2x4Zw
        C5Xj5jO6MhuPW9weupaRe90Gk81IxdHns4JiYNfR7Q==
X-Google-Smtp-Source: ABdhPJwliUlItsrpLn1+I5hrd9rEc+YvxNDiJSj3yNhjvh/mpLFiO4d78N2zmuNH2esxan4r8P2KPApz87peJAW0mPs=
X-Received: by 2002:a05:600c:4ecc:b0:394:790d:5f69 with SMTP id
 g12-20020a05600c4ecc00b00394790d5f69mr1691105wmq.196.1652215462895; Tue, 10
 May 2022 13:44:22 -0700 (PDT)
MIME-Version: 1.0
References: <20220510001807.4132027-1-yosryahmed@google.com>
 <20220510001807.4132027-2-yosryahmed@google.com> <Ynqyh+K1tMyNCTUW@slm.duckdns.org>
 <CAJD7tkZVXJY3s2k8M4pcq+eJVD+aX=iMDiDKtdE=j0_q+UWQzA@mail.gmail.com> <YnrEDfZs1kuB1gu5@slm.duckdns.org>
In-Reply-To: <YnrEDfZs1kuB1gu5@slm.duckdns.org>
From:   Yosry Ahmed <yosryahmed@google.com>
Date:   Tue, 10 May 2022 13:43:46 -0700
Message-ID: <CAJD7tkahC1e-_K0xJMu-xXwd8WNVzYDRgJFua9=JhNRq7b+G8A@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 1/9] bpf: introduce CGROUP_SUBSYS_RSTAT
 program type
To:     Tejun Heo <tj@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
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
        cgroups@vger.kernel.org
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

On Tue, May 10, 2022 at 12:59 PM Tejun Heo <tj@kernel.org> wrote:
>
> Hello,
>
> On Tue, May 10, 2022 at 12:34:42PM -0700, Yosry Ahmed wrote:
> > The rationale behind associating this work with cgroup_subsys is that
> > usually the stats are associated with a resource (e.g. memory, cpu,
> > etc). For example, if the memory controller is only enabled for a
> > subtree in a big hierarchy, it would be more efficient to only run BPF
> > rstat programs for those cgroups, not the entire hierarchy. It
> > provides a way to control what part of the hierarchy you want to
> > collect stats for. This is also semantically similar to the
> > css_rstat_flush() callback.
>
> Hmm... one major point of rstat is not having to worry about these things
> because we iterate what's been active rather than what exists. Now, this
> isn't entirely true because we share the same updated list for all sources.
> This is a trade-off which makes sense because 1. the number of cgroups to
> iterate each cycle is generally really low anyway 2. different controllers
> often get enabled together. If the balance tilts towards "we're walking too
> many due to the sharing of updated list across different sources", the
> solution would be splitting the updated list so that we make the walk finer
> grained.
>
> Note that the above doesn't really affect the conceptual model. It's purely
> an optimization decision. Tying these things to a cgroup_subsys does affect
> the conceptual model and, in this case, the userland API for a performance
> consideration which can be solved otherwise.
>
> So, let's please keep this simple and in the (unlikely) case that the
> overhead becomes an issue, solve it from rstat operation side.
>
> Thanks.

I assume if we do this optimization, and have separate updated lists
for controllers, we will still have a "core" updated list that is not
tied to any controller. Is this correct?

If yes, then we can make the interface controller-agnostic (a global
list of BPF flushers). If we do the optimization later, we tie BPF
stats to the "core" updated list. We can even extend the userland
interface then to allow for controller-specific BPF stats if found
useful.

If not, and there will only be controller-specific updated lists then,
then we might need to maintain a "core" updated list just for the sake
of BPF programs, which I don't think would be favorable.

What do you think? Either-way, I will try to document our discussion
outcome in the commit message (and maybe the code), so that
if-and-when this optimization is made, we can come back to it.


>
> --
> tejun
