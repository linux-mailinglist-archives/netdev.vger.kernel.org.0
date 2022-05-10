Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE5FF520A7C
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 03:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234083AbiEJBJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 21:09:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234077AbiEJBJJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 21:09:09 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E68D5297403
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 18:05:11 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id k126so9278836wme.2
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 18:05:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KWU2Ie7CLoGUJm4eKIboU9cuPF4R+pcVY2OmQlQkvqM=;
        b=otwm5O7b+Cs+c/aJt5BGIr83OuJhOFQ+EMC0G8wlyaaPZowgDFt4HzUfoBEvfjN2aY
         Yv4/Jg9DgzI5XFWIElJz9Tb7HhvTQRjoc+y5rrgMW7Rn9cwKP24ucRVlHfh88sRpAFZH
         fKMYCJT4wx/aqhlflEQ3xcCLS5OeGO3gaVMUkhVwQDLhzrERSs2lTGN9YrRdp+Mmo2yr
         mdfz0IqlWT0mzXP+aoCd4SAADN0+/Jz7sk3mKoI01VjDPDte/svmeTmqEWlT5AYyc5zF
         7ZKdydGd3+TR7wyMLg6FCEOlo5vZ/+/NRZYm1D0tOaODkAV90tX/5L9EAl8JwyblQd4C
         /JIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KWU2Ie7CLoGUJm4eKIboU9cuPF4R+pcVY2OmQlQkvqM=;
        b=XhfZUH7ciykPhqbkTax90Jl+loePcZ7SMvplVhfTFou7eksp5ab8tFugGd5Ufk9pRh
         AjUklPopmU3DVJ3hLCZf/998xAobZinKRrzbWcQH28u8NxWLWf+1r87t0drdhWGeC2Ma
         CbktZConDbN50QjygU4d8blAP1FPyAieqCm8Z8v4UJrB1pyeSM6gIDfUNNoBOmBVFk7j
         XKfS/rcMkwQ+Qz/+T2GktFWe4fh4IU7Hei253ynaQ7lTkDiN+SlDCB22845FCqxnIxoX
         0wm4XNM2PdCQOSH55qQuFFxj+h1yBMRbEaSiwm5d8AIgsnIL6rfzibnIUTpN7jaq6/g6
         Hk9Q==
X-Gm-Message-State: AOAM533eVwe1RslG4hdGfxVAUodjw0685IqxSxpt+C+r5bElBcpum3v5
        npHTTWD4Hi5Q+vHRS7RfHCZQ02wlGV8KwSfHkLxRIA==
X-Google-Smtp-Source: ABdhPJxsM1M7GsdDp/lB/ItrtIwDET4ES/Y6Q0ul+CoEnC+3p/f+ETtL6JGwXfvrKvj4KjxP5g910tnq2NWXWh4sLVw=
X-Received: by 2002:a05:600c:4ecc:b0:394:790d:5f69 with SMTP id
 g12-20020a05600c4ecc00b00394790d5f69mr19448042wmq.196.1652144710286; Mon, 09
 May 2022 18:05:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220507024840.42662-1-zhoufeng.zf@bytedance.com> <CAEf4BzZD5q2j229_gL_nDFse2v=k2Ea0nfguH+sOA2O1Nm5sQw@mail.gmail.com>
In-Reply-To: <CAEf4BzZD5q2j229_gL_nDFse2v=k2Ea0nfguH+sOA2O1Nm5sQw@mail.gmail.com>
From:   Yosry Ahmed <yosryahmed@google.com>
Date:   Mon, 9 May 2022 18:04:34 -0700
Message-ID: <CAJD7tkbd8qA-4goUCVW6Tf0xGpj2OSBXncpWhrWFn5y010oBMw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: add bpf_map_lookup_percpu_elem for percpu map
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Feng zhou <zhoufeng.zf@bytedance.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joanne Koong <joannekoong@fb.com>,
        Geliang Tang <geliang.tang@suse.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        duanxiongchun@bytedance.com,
        Muchun Song <songmuchun@bytedance.com>,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        zhouchengming@bytedance.com
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

On Mon, May 9, 2022 at 5:34 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Fri, May 6, 2022 at 7:49 PM Feng zhou <zhoufeng.zf@bytedance.com> wrote:
> >
> > From: Feng Zhou <zhoufeng.zf@bytedance.com>
> >
> > Trace some functions, such as enqueue_task_fair, need to access the
> > corresponding cpu, not the current cpu, and bpf_map_lookup_elem percpu map
> > cannot do it. So add bpf_map_lookup_percpu_elem to accomplish it for
> > percpu_array_map, percpu_hash_map, lru_percpu_hash_map.
> >
> > The implementation method is relatively simple, refer to the implementation
> > method of map_lookup_elem of percpu map, increase the parameters of cpu, and
> > obtain it according to the specified cpu.
> >
>
> I don't think it's safe in general to access per-cpu data from another
> CPU. I'd suggest just having either a ARRAY_OF_MAPS or adding CPU ID
> as part of the key, if you need such a custom access pattern.

I actually just sent an RFC patch series containing a similar patch
for the exact same purpose. There are instances in the kernel where
per-cpu data is accessed from other cpus (e.g.
mem_cgroup_css_rstat_flush()). I believe, like any other variable,
percpu data can be safe or not safe to access, based on the access
pattern. It is up to the user to coordinate accesses to the variable.

For example, in my use case, one of the accessors only reads percpu
values of different cpus, so it should be safe. If a user accesses
percpu data of another cpu without guaranteeing safety, they corrupt
their own data. I understand that the main purpose of percpu data is
lockless (and therefore fast) access, but in some use cases the user
may be able to safely (and locklessly) access the data concurrently.

>
> > Signed-off-by: Feng Zhou <zhoufeng.zf@bytedance.com>
> > ---
> >  include/linux/bpf.h            |  2 ++
> >  include/uapi/linux/bpf.h       |  9 +++++++++
> >  kernel/bpf/arraymap.c          | 15 +++++++++++++++
> >  kernel/bpf/core.c              |  1 +
> >  kernel/bpf/hashtab.c           | 32 ++++++++++++++++++++++++++++++++
> >  kernel/bpf/helpers.c           | 18 ++++++++++++++++++
> >  kernel/bpf/verifier.c          | 17 +++++++++++++++--
> >  kernel/trace/bpf_trace.c       |  2 ++
> >  tools/include/uapi/linux/bpf.h |  9 +++++++++
> >  9 files changed, 103 insertions(+), 2 deletions(-)
> >
>
> [...]
