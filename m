Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B3FD52F1A8
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 19:31:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352149AbiETRat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 13:30:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244696AbiETRar (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 13:30:47 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73BFA17D383
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 10:30:43 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id t2so3178003qkb.12
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 10:30:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CPavKVkR8bELd7v5gex0nX0RA6A8QGn+WltRM5Og+4g=;
        b=MSLFYCHCp/SZxn9cm5CoWu+3FpwqYMeTrBILRT4T9npnAg/BaxF/9YpOt/8BpfCeIi
         QNFKHiQ8wH5t6TjjD362O2oxnfrihMLlQiPFrrUH+NDukCfPWUuGOvL3+zuu3fi7AGdj
         qgdT4/2uMNS7DYiZi6YKk9IXmhduvHlRP/0woJyAJMNWtD0YS0jrjWL0wPpxdQM3uspA
         vJgbRI25KoLUFPhjSaZoBEnuSQDq+i0ze73pH1kri1TDLTflSDd6UyZwXBxmu5eVfBh6
         UxiMZ9l7YRjsNMFPzIyBLQzKMTq6kkJMswyxyU98m9mX63TaYJcYhQG5GnSYZ1S/bTgH
         STSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CPavKVkR8bELd7v5gex0nX0RA6A8QGn+WltRM5Og+4g=;
        b=Y9/ePyDFiE4/8wGpr3zPi6e/R3vizDHLTeN+kdKQjTHwCOn8COr/xbONfogsx5nG2X
         odaadl84fVMMAHPQr5K3isnGGIb/6t9Uxmyio6PncrsnwsgadBGGA+VKVEtLE7mgZSH5
         PMOz5UmmgVjWo4X2PPgYMAD07GZRWtFsF0NMI4Fd60J2ufUQjN5BQIOk6V/CKq6VPQEc
         ELd5QceZMtvBJHR8pt4B8+Fat1tZmbih1Yx5LdtjgR5V84QvBrDbXNJ/UU9e80mOsALV
         MnjxstrJXIpwkiVrzMtvSN5H9pSTq5XZ3+QN6tCseROIv8C8gZhWduJZsgdwbKfCmxEN
         lg4Q==
X-Gm-Message-State: AOAM533tiMFdOUWSlv236uB87ZGFClVYja0fsuIo6PNU0QiIgjWU5Lr6
        P5/K7+rR4OG1ABqad3FWhlhSqajkwGjBMWAI7Spq0w==
X-Google-Smtp-Source: ABdhPJz5Mikyb2ZCSmg67TYUBBxgrBCM373X9eLBJ7/2D7arGeeYjmMXzqAYDcgIFIxH6qSqWi8VtqwbhGeWuNrgTig=
X-Received: by 2002:a05:620a:2849:b0:687:651:54ee with SMTP id
 h9-20020a05620a284900b00687065154eemr7084966qkp.446.1653067842202; Fri, 20
 May 2022 10:30:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220520012133.1217211-1-yosryahmed@google.com>
 <20220520012133.1217211-4-yosryahmed@google.com> <YodGI73xq8aIBrNM@slm.duckdns.org>
 <CAJD7tkbvMcMWESMcWi6TtdCKLr6keBNGgZTnqcHZvBrPa1qWPw@mail.gmail.com> <YodNLpxut+Zddnre@slm.duckdns.org>
In-Reply-To: <YodNLpxut+Zddnre@slm.duckdns.org>
From:   Hao Luo <haoluo@google.com>
Date:   Fri, 20 May 2022 10:30:30 -0700
Message-ID: <CA+khW7iN_=9yg6r9wSX5T3biWgUyAZ6quUUjsVp=hXBY9meJ9Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 3/5] bpf: Introduce cgroup iter
To:     Tejun Heo <tj@kernel.org>
Cc:     Yosry Ahmed <yosryahmed@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
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
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Tejun,

On Fri, May 20, 2022 at 1:11 AM Tejun Heo <tj@kernel.org> wrote:
>
> Hello,
>
> On Fri, May 20, 2022 at 12:58:52AM -0700, Yosry Ahmed wrote:
> > On Fri, May 20, 2022 at 12:41 AM Tejun Heo <tj@kernel.org> wrote:
> > >
> > > On Fri, May 20, 2022 at 01:21:31AM +0000, Yosry Ahmed wrote:
> > > > From: Hao Luo <haoluo@google.com>
> > > >
> > > > Introduce a new type of iter prog: cgroup. Unlike other bpf_iter, this
> > > > iter doesn't iterate a set of kernel objects. Instead, it is supposed to
> > > > be parameterized by a cgroup id and prints only that cgroup. So one
> > > > needs to specify a target cgroup id when attaching this iter. The target
> > > > cgroup's state can be read out via a link of this iter.
> > > >
> > > > Signed-off-by: Hao Luo <haoluo@google.com>
> > > > Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> > >
> > > This could be me not understanding why it's structured this way but it keeps
> > > bothering me that this is adding a cgroup iterator which doesn't iterate
> > > cgroups. If all that's needed is extracting information from a specific
> > > cgroup, why does this need to be an iterator? e.g. why can't I use
> > > BPF_PROG_TEST_RUN which looks up the cgroup with the provided ID, flushes
> > > rstat, retrieves whatever information necessary and returns that as the
> > > result?
> >
> > I will let Hao and Yonghong reply here as they have a lot more
> > context, and they had previous discussions about cgroup_iter. I just
> > want to say that exposing the stats in a file is extremely convenient
> > for userspace apps. It becomes very similar to reading stats from
> > cgroupfs. It also makes migrating cgroup stats that we have
> > implemented in the kernel to BPF a lot easier.
>
> So, if it were upto me, I'd rather direct energy towards making retrieving
> information through TEST_RUN_PROG easier rather than clinging to making
> kernel output text. I get that text interface is familiar but it kinda
> sucks in many ways.
>

Tejun, could you explain more about the downside of text interfaces
and why TEST_RUN_PROG would address the problems in text output? From
the discussion we had last time, I understand that your concern was
the unstable interface if we introduce bpf files in cgroupfs, so we
are moving toward replicating the directory structure in bpffs. But I
am not sure about the issue of text format output

> > AFAIK there are also discussions about using overlayfs to have links
> > to the bpffs files in cgroupfs, which makes it even better. So I would
> > really prefer keeping the approach we have here of reading stats
> > through a file from userspace. As for how we go about this (and why a
> > cgroup iterator doesn't iterate cgroups) I will leave this for Hao and
> > Yonghong to explain the rationale behind it. Ideally we can keep the
> > same functionality under a more descriptive name/type.
>
> My answer would be the same here. You guys seem dead set on making the
> kernel emulate cgroup1. I'm not gonna explicitly block that but would
> strongly suggest having a longer term view.
>

The reason why Yosry and I are still pushing toward this direction is
that our user space applications rely heavily on extracting
information from text output for cgroups. Please understand that
migrating them from the traditional model to a new model is a bigger
pain. But I agree that if we have a better, concrete solution (for
example, maybe TEST_RUN_PROG) to convince them and help them migrate,
I really would love to contribute and work on it.

> If you *must* do the iterator, can you at least make it a proper iterator
> which supports seeking? AFAICS there's nothing fundamentally preventing bpf
> iterators from supporting seeking. Or is it that you need something which is
> pinned to a cgroup so that you can emulate the directory structure?
>

Yonghong may comment on adding seek for bpf_iter. I would love to
contribute if we are in need of that. Right now, we don't have a use
case that needs seek for bpf_iter, I think. My thought: for cgroups,
we can seek using cgroup id. Maybe, not all kernel objects are
indexable, so seeking doesn't apply there?

Hao
