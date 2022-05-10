Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9E7C522685
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 23:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233176AbiEJV43 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 17:56:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235048AbiEJV4N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 17:56:13 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF6B45712A
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 14:56:10 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id e24so402770wrc.9
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 14:56:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IwUgKUFNj7ibkuKWy6cspfPFQL3X6FyIq81DUZlFReI=;
        b=pvu4vmnNkxBfNPaw9v92a2w+TVqfwi+iTgvjgFvjq+ssgXnL2/XxuczeCjzFigw6Fp
         LdrwiJrm5va3fTljcIrhm2cCN2U3mHlAeGm/YCKUXs8GdTX9I68G+Bkv1+NDR1Vt5YAL
         b0Oy+hcWXfNh68+frvkkZEUFC4PBzALS5U5cfl6+gErj5JV6cqdOWZypd5vUtHNf1ZvG
         S5ld+Bo59W0iXbrlJP/mnDfnhgKqL6sJExvTb1S/4mzhTBYEDX1kSPUfTU+4U7XvOULp
         BlWx/yzcaO3KNO9uZIsiptBfq34GgjqYlMOzrHkqYyBggfOuj6Q3k2CYVGzEXWLPerlF
         PpIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IwUgKUFNj7ibkuKWy6cspfPFQL3X6FyIq81DUZlFReI=;
        b=dBKf77NX+jLu6YdicVwV4Hd31LjLoVCntKzoJ7B7vDiYkOAbEqqeenDNro47Cffjv+
         foxn2oovq/vsZ7vKb7Mm9umVJ+1f2Sb1SXxk2HJLTaqAPyIaf5pQadWuqx4ZfFTxSCtA
         PzoACZZS3k0j8zVazVyGTcOgkF/MhxwYhzlnFQqobDnlSAYZkfwXQIHCmLMBga0fvtRS
         3o0v4zt23R/zGhqdKgmDfbOJ+1ic0U4LiCP/2nE0srcMYSJsS52/UbEJrJIfuZvSPgJY
         uXmukKF7XBAVGeJReMKWpfMQSWR0U/jBg5UXp91hqRHEy4G8q27H8WQoYJ0393XfyycJ
         OdFg==
X-Gm-Message-State: AOAM531m5lJPB9kpuVCtRake7vnD6LiKJi7lzamI71EIRkSBfVlLaCIp
        O8IigFXzHt1yxiseQLXZ3WcZJUziWeGxyXMwYo5ieQ==
X-Google-Smtp-Source: ABdhPJyvhf5tHo+7ymkHhZKRFq0olhspXHd8enDR9DXvVol++Jwbk6xZofLsCZBaS03E9VdsgNBSy5whbtz0QVbHtl8=
X-Received: by 2002:a05:6000:154a:b0:20c:7e65:c79e with SMTP id
 10-20020a056000154a00b0020c7e65c79emr20365907wry.582.1652219768969; Tue, 10
 May 2022 14:56:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220510001807.4132027-1-yosryahmed@google.com>
 <20220510001807.4132027-2-yosryahmed@google.com> <Ynqyh+K1tMyNCTUW@slm.duckdns.org>
 <CAJD7tkZVXJY3s2k8M4pcq+eJVD+aX=iMDiDKtdE=j0_q+UWQzA@mail.gmail.com>
 <YnrEDfZs1kuB1gu5@slm.duckdns.org> <CAJD7tkahC1e-_K0xJMu-xXwd8WNVzYDRgJFua9=JhNRq7b+G8A@mail.gmail.com>
 <YnrSrKFTBn3IyUfa@slm.duckdns.org>
In-Reply-To: <YnrSrKFTBn3IyUfa@slm.duckdns.org>
From:   Yosry Ahmed <yosryahmed@google.com>
Date:   Tue, 10 May 2022 14:55:32 -0700
Message-ID: <CAJD7tkbeZPH9UJXtGeopPnTSVPYN-GzzM51SE_QNuLmiaVNpeA@mail.gmail.com>
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
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 10, 2022 at 2:01 PM Tejun Heo <tj@kernel.org> wrote:
>
> Hello,
>
> On Tue, May 10, 2022 at 01:43:46PM -0700, Yosry Ahmed wrote:
> > I assume if we do this optimization, and have separate updated lists
> > for controllers, we will still have a "core" updated list that is not
> > tied to any controller. Is this correct?
>
> Or we can create a dedicated updated list for the bpf progs, or even
> multiple for groups of them and so on.
>
> > If yes, then we can make the interface controller-agnostic (a global
> > list of BPF flushers). If we do the optimization later, we tie BPF
> > stats to the "core" updated list. We can even extend the userland
> > interface then to allow for controller-specific BPF stats if found
> > useful.
>
> We'll need that anyway as cpustats are tied to the cgroup themselves rather
> than the cpu controller.
>
> > If not, and there will only be controller-specific updated lists then,
> > then we might need to maintain a "core" updated list just for the sake
> > of BPF programs, which I don't think would be favorable.
>
> If needed, that's fine actually.
>
> > What do you think? Either-way, I will try to document our discussion
> > outcome in the commit message (and maybe the code), so that
> > if-and-when this optimization is made, we can come back to it.
>
> So, the main focus is keeping the userspace interface as simple as possible
> and solving performance issues on the rstat side. If we need however many
> updated lists to do that, that's all fine. FWIW, the experience up until now
> has been consistent with the assumptions that the current implementation
> makes and I haven't seen real any world cases where the shared updated list
> are problematic.
>

Thanks again for your insights and time!

That's great to hear. I am all in for making the userspace interface
simpler. I will rework this patch series so that the BPF programs just
attach to "rstat" and send a V1.
Any other concerns you have that you think I should address in V1?

> Thanks.
>
> --
> tejun
