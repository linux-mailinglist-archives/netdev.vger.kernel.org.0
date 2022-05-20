Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7AC752E6FF
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 10:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346826AbiETILf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 04:11:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235949AbiETILa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 04:11:30 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4385252E49;
        Fri, 20 May 2022 01:11:29 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id n8so6786361plh.1;
        Fri, 20 May 2022 01:11:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XsDbXLkM/SD1gIqolJSdHpOWgyWe8lXWJA+Qz0s6McE=;
        b=eg8vz0xPF3x92KYNdkg2qpQTecRdTZDTj8Ub+NAl8OeO1ep1lDeLuB5jO2uc44xHth
         xpwlne//yPNs9kG4mTLlIEPZJmrhO/MS0PuUrLv7y6aPdrWiymowlgpfaiOaFW3+hc5n
         3Lgy4Sza/h7jiHNbKvwxlSkJ5ooWCHBYeqfqJwSO9n6kPjKtXTjF4jvUN9d+dom2vbw0
         0mcz7iJK85ZnCQUCNimQ6pRDzmRb1zZHbgZ7+B3tpFRHgg+ttjx0FayzwJHeNUCmMcZt
         LWwWfyDllBEwk0ddMgg7PJkSbV62gDDLHYEqIrLEHPSU2/F2u8QGvFEYxcwCv7WtQH6M
         dPYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=XsDbXLkM/SD1gIqolJSdHpOWgyWe8lXWJA+Qz0s6McE=;
        b=WrXdP7jl5Gram+BbnD0LdKKAWbfp7ausynKZni/Aj6bRWmxIP+pN/Y2KYdyj3ZTtrB
         jYcCe3rIeuyXx9QiNbRgJOwGmG7g/E23zWJC6ufxHIwsjSuv5JXuQV26l8Bf9gNU92+t
         XyQsgPUPNCE4ZDky0EHEqZIv6S/uFHJzpR7VbTmPMZT8oqoGo7CLK7FJhmEyV0LTIhTe
         0DK6g2Vj1Nw9NSbHDkNlkvfr7ygbasKuWvXx96ePPgntSiaH/PqO6Lh2gra43mw9tZh6
         uUzZN1TNEZL3ACxC/oUzU+Nzy8mkEpDNHeZyxTDWhk4l3RUL39NblPGiBmahVgp3224p
         ql3g==
X-Gm-Message-State: AOAM530/WcCpNUa/Fy3mtrkgcluQQjUi/Gvx6B8lHCkaGtEfJ/icXbUI
        EJeXbJBTVrAou5b+6OXnPnE=
X-Google-Smtp-Source: ABdhPJypatUyV/ufYREcR4VO4QOd+pO6wNuURAzg0PEZLZdQILYK8o5WgCQ/hpzFvG4VIwbJRIURtQ==
X-Received: by 2002:a17:902:a502:b0:151:8289:b19 with SMTP id s2-20020a170902a50200b0015182890b19mr8683368plq.149.1653034288294;
        Fri, 20 May 2022 01:11:28 -0700 (PDT)
Received: from localhost ([2620:10d:c090:400::4:1761])
        by smtp.gmail.com with ESMTPSA id p6-20020a170902780600b0015e8d4eb299sm5038111pll.227.2022.05.20.01.11.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 May 2022 01:11:27 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Thu, 19 May 2022 22:11:26 -1000
From:   Tejun Heo <tj@kernel.org>
To:     Yosry Ahmed <yosryahmed@google.com>
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
        Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH bpf-next v1 3/5] bpf: Introduce cgroup iter
Message-ID: <YodNLpxut+Zddnre@slm.duckdns.org>
References: <20220520012133.1217211-1-yosryahmed@google.com>
 <20220520012133.1217211-4-yosryahmed@google.com>
 <YodGI73xq8aIBrNM@slm.duckdns.org>
 <CAJD7tkbvMcMWESMcWi6TtdCKLr6keBNGgZTnqcHZvBrPa1qWPw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJD7tkbvMcMWESMcWi6TtdCKLr6keBNGgZTnqcHZvBrPa1qWPw@mail.gmail.com>
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

Hello,

On Fri, May 20, 2022 at 12:58:52AM -0700, Yosry Ahmed wrote:
> On Fri, May 20, 2022 at 12:41 AM Tejun Heo <tj@kernel.org> wrote:
> >
> > On Fri, May 20, 2022 at 01:21:31AM +0000, Yosry Ahmed wrote:
> > > From: Hao Luo <haoluo@google.com>
> > >
> > > Introduce a new type of iter prog: cgroup. Unlike other bpf_iter, this
> > > iter doesn't iterate a set of kernel objects. Instead, it is supposed to
> > > be parameterized by a cgroup id and prints only that cgroup. So one
> > > needs to specify a target cgroup id when attaching this iter. The target
> > > cgroup's state can be read out via a link of this iter.
> > >
> > > Signed-off-by: Hao Luo <haoluo@google.com>
> > > Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> >
> > This could be me not understanding why it's structured this way but it keeps
> > bothering me that this is adding a cgroup iterator which doesn't iterate
> > cgroups. If all that's needed is extracting information from a specific
> > cgroup, why does this need to be an iterator? e.g. why can't I use
> > BPF_PROG_TEST_RUN which looks up the cgroup with the provided ID, flushes
> > rstat, retrieves whatever information necessary and returns that as the
> > result?
> 
> I will let Hao and Yonghong reply here as they have a lot more
> context, and they had previous discussions about cgroup_iter. I just
> want to say that exposing the stats in a file is extremely convenient
> for userspace apps. It becomes very similar to reading stats from
> cgroupfs. It also makes migrating cgroup stats that we have
> implemented in the kernel to BPF a lot easier.

So, if it were upto me, I'd rather direct energy towards making retrieving
information through TEST_RUN_PROG easier rather than clinging to making
kernel output text. I get that text interface is familiar but it kinda
sucks in many ways.

> AFAIK there are also discussions about using overlayfs to have links
> to the bpffs files in cgroupfs, which makes it even better. So I would
> really prefer keeping the approach we have here of reading stats
> through a file from userspace. As for how we go about this (and why a
> cgroup iterator doesn't iterate cgroups) I will leave this for Hao and
> Yonghong to explain the rationale behind it. Ideally we can keep the
> same functionality under a more descriptive name/type.

My answer would be the same here. You guys seem dead set on making the
kernel emulate cgroup1. I'm not gonna explicitly block that but would
strongly suggest having a longer term view.

If you *must* do the iterator, can you at least make it a proper iterator
which supports seeking? AFAICS there's nothing fundamentally preventing bpf
iterators from supporting seeking. Or is it that you need something which is
pinned to a cgroup so that you can emulate the directory structure?

Thanks.

-- 
tejun
