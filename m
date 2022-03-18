Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2616F4DD704
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 10:22:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234399AbiCRJYK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 05:24:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234377AbiCRJYJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 05:24:09 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D61B72C57B2;
        Fri, 18 Mar 2022 02:22:50 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id a17so8487631edm.9;
        Fri, 18 Mar 2022 02:22:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=W2BhzbMIByCZCKGXGolyoW4FwzuuDiEDyr4ehhR2zyc=;
        b=HgFmGCQP2uTDIsl/xFIfE3vd5PETPCWDs5LQ3H64TKvccSJQeJoaCj43JkWIJF3DJW
         1rtlolw3oz5oaytS7J/v9VJuEk4wbKgxq4hBMKl3j8ZGeZ/JnsYjK+8M/mFh7jNCbm/t
         wiJFEyIXgCCsb519wE3RHEb331heGql31QY6EhR5yLjq597xCAkV30bHCkc/qyH0Htrx
         wdtxcxRvPrksfCGxgih6UZTuZEuApZq8uVpomJD1XPbWjPvbrpE+c9Rbmb+OYQwC5L9U
         Th1KwQRPna9N3GM/mXUgWDJmIwUSh3c4zNCrLpOkrFBa+rEaVVE98xKcSCKHivQVvtE/
         a2Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=W2BhzbMIByCZCKGXGolyoW4FwzuuDiEDyr4ehhR2zyc=;
        b=d7JT2aB7jcIWvU4+0E/g/N9ynNrvdcuOxMFKPah4+8YfjUVfz0MZMXGRLvxdZELFPT
         jyTJ92gIdhDytogPc1unpfiysuFz3QKdR67IhWCCybhgXlhfnb7g6u3o5xh6vWIGM6YY
         SQqKitAEPZXNNMzhi/fUVyYygBijFe/NKHpWGDrsuJvLwSWuOaJjbj6UHthsLK0SHfYD
         v1HuS8h/rMCbk5QsdK+gJ1BqamePXk34jFx38spT+LfvBAAithISBo9VbjMogkkqX6FE
         33cGqbRMvDo9RRlq0RqAOlQkMUj9vsKS1lBZBqd/NM93F5ZF4FzB8mIpLQHG2MqFsLGY
         CgaQ==
X-Gm-Message-State: AOAM531/PRf1EklM01eai1KTqYzqGS3B3+3evD1Qb+PMdohbNScSvT7S
        RarFnyrLmkE+Op9JtBsbsxjgkQz4p8KW1A==
X-Google-Smtp-Source: ABdhPJxy4bt20DgxAxj4YsKg7TlYGZk8fXVnHcX4FUnQ8m6rjF8wTHhqAqGKwF19CkbU/q18ww4waw==
X-Received: by 2002:a05:6402:d7:b0:413:673:ba2f with SMTP id i23-20020a05640200d700b004130673ba2fmr8456637edu.29.1647595369200;
        Fri, 18 Mar 2022 02:22:49 -0700 (PDT)
Received: from krava ([193.85.244.190])
        by smtp.gmail.com with ESMTPSA id bn14-20020a170906c0ce00b006c5ef0494besm3430520ejb.86.2022.03.18.02.22.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 02:22:48 -0700 (PDT)
Date:   Fri, 18 Mar 2022 10:22:46 +0100
From:   Jiri Olsa <olsajiri@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Nick Alcock <nick.alcock@oracle.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: Re: [PATCHv3 bpf-next 09/13] libbpf: Add
 bpf_program__attach_kprobe_multi_opts function
Message-ID: <YjRPZj6Z8vuLeEZo@krava>
References: <20220316122419.933957-1-jolsa@kernel.org>
 <20220316122419.933957-10-jolsa@kernel.org>
 <CAADnVQ+tNLEtbPY+=sZSoBicdSTx1YLgZJwnNuhnBkUcr5xozQ@mail.gmail.com>
 <CAEf4BzZtQaiUxQ-sm_hH2qKPRaqGHyOfEsW96DxtBHRaKLoL3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZtQaiUxQ-sm_hH2qKPRaqGHyOfEsW96DxtBHRaKLoL3Q@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 17, 2022 at 10:14:28PM -0700, Andrii Nakryiko wrote:

SNIP

> > But the above needs more work.
> > Currently test_progs -t kprobe_multi
> > takes 4 seconds on lockdep+debug kernel.
> > Mainly because of the above loop.
> >
> >     18.05%  test_progs       [kernel.kallsyms]   [k]
> > kallsyms_expand_symbol.constprop.4
> >     12.53%  test_progs       libc-2.28.so        [.] _IO_vfscanf
> >      6.31%  test_progs       [kernel.kallsyms]   [k] number
> >      4.66%  test_progs       [kernel.kallsyms]   [k] format_decode
> >      4.65%  test_progs       [kernel.kallsyms]   [k] string_nocheck
> >
> > Single test_skel_api() subtest takes almost a second.
> >
> > A cache inside libbpf probably won't help.
> > Maybe introduce a bpf iterator for kallsyms?
> 
> BPF iterator for kallsyms is a great idea! So many benefits:

>   - it should be significantly more efficient *and* simpler than
> parsing /proc/kallsyms;
>   - there were some upstream patches recording ksym length (i.e.,
> function size), don't remember if that ever landed or not, but besides
> that the other complication of even exposing that to user space were
> concerns about /proc/kallsyms format being an ABI. With the BPF
> iterator we can easily provide that symbol size without any breakage.
> This would be great!

yes, great idea.. I was cc-ed on patches adding extra stuff to kallsyms:
  https://lore.kernel.org/lkml/20220208184309.148192-7-nick.alcock@oracle.com/

this could be way out ;-) cc-ing Nick

>   - we can allow parameterizing iterator with options like: skip or
> include module symbols, specify a set of types of symbols (function,
> variable, etc), etc. This would speed everything up in common cases by
> not even decompressing irrelevant names.
> 
> In short, kallsyms iterator would be an immensely useful for any sort
> of tracing tool that deals with kernel stack traces or kallsyms in
> general.

I wonder we could make some use of it in perf as well, there's some
guessing wrt symbol sizes when we parse kallsyms, so we could get
rid of it.. I will work on that and try to add this

> 
> But in this particular case, kprobe_multi_resolve_syms()
> implementation is extremely suboptimal. I didn't realize during review
> that kallsyms_lookup_name() is a linear scan... If that's not going to
> be changed to O(log(N)) some time soon, we need to reimplement
> kprobe_multi_resolve_syms(), probably.
> 
> One way would be to sort user strings lexicographically and then do a
> linear scan over all kallsyms, for each symbol perform binary search
> over a sorted array of user strings. Stop once all the positions were
> "filled in" (we'd need to keep a bitmap or bool[], probably). This way
> it's going to be O(MlogN) instead of O(MN) as it is right now.

ok, I did something similar in multi-trampoline patchset that you
suggested, I think that will work here as well

> 
> BTW, Jiri, libbpf.map is supposed to have an alphabetically ordered
> list of functions, it would be good to move
> bpf_program__attach_kprobe_multi_opts a bit higher before libbpf_*
> functions.

ah right, sry.. I'll send fix with follow up changes

thanks,
jirka
