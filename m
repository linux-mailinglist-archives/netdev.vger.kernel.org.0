Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BA455429A5
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 10:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231633AbiFHIlp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 04:41:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230086AbiFHIkc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 04:40:32 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A3202065E2;
        Wed,  8 Jun 2022 01:03:46 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id z9so3689289wmf.3;
        Wed, 08 Jun 2022 01:03:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BBxQBIAksY6tZOtSnGUg3MyL1X+UULxDi9bovrMNmP0=;
        b=bjNPT7daaDxtxmU9OKHeJpubtlaj4QrRnFA5uMJs5WXVt0nOwhe5qq8Yy5dwT/bumt
         pvWFkAqtj5lMklxfdDdJwbnZ8I2ZoyEA8vF97JvfFv2cTlyoLrc+4LC67Q0sHTDQuQUZ
         9FF4Omk0Bw7vUTjIjtK0TPmGBfpl74ikrUOdPqIXWI7l2prer0CQXHerPg3deHzcd7uA
         2coUZauCsA6Kh1b/QYHvUiQsjchkeKkcnpWXZWjYrYLIilyVdui0jGLsFvlS3rhViNlo
         iy22Md6DUz1DDXvHYwrXp3SWkraP0Ul3y22qITNy7cJePJB+UoQEMkft2VjXmGZVEbR9
         ZBKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BBxQBIAksY6tZOtSnGUg3MyL1X+UULxDi9bovrMNmP0=;
        b=JOKTp0k0zAHeu0hf+iepWq2QteFEn2X+vfOi1mpboN71CfZ2g0l1vd5/w3it/gChTO
         eWjFiogaIDoG47TsySfy+010FJbaks0MEO+y3w9P9c8DaF807lIH+hUBZ8B7+9ZSMsTP
         4FkYcbNaouykQyO4uyV98wcdwPY4MLMpxtRyG7Cu3hhbhDhfMyEFm6CngdUry/vI53gg
         XS2zQYcuXs/Tuhd3Qy88iBmr/AmM6so6IqpyHCIyHa8FXMTmbvY0kX12skeGURfqx/7b
         5SOnAuJpd70MAveViJBbYA3JbGvuwr/EOXyjsXrapvLjgXkUmGw6Wdj+EA3n8WwQSboh
         k4Dg==
X-Gm-Message-State: AOAM533GKbWnIhakRF4lEU190ut7QV5JSFraBMICesBwtojyPlSM+XHG
        yaGIeAP5HgFljsSn4s2o/AI=
X-Google-Smtp-Source: ABdhPJzIA/Jtz3H6i0p+Uzjw+fQX++hulkzPcgm5FDtYv2b7QIkKkFSG3NVi3wL5OOWky7+VMUas3A==
X-Received: by 2002:a05:600c:1e8b:b0:39c:2f04:676f with SMTP id be11-20020a05600c1e8b00b0039c2f04676fmr33443018wmb.158.1654675181786;
        Wed, 08 Jun 2022 00:59:41 -0700 (PDT)
Received: from krava ([193.85.244.190])
        by smtp.gmail.com with ESMTPSA id f5-20020a5d5685000000b0020fc3e24041sm20030776wrv.106.2022.06.08.00.59.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 00:59:41 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Wed, 8 Jun 2022 09:59:39 +0200
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jiri Olsa <olsajiri@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>
Subject: Re: [PATCHv2 bpf 3/3] bpf: Force cookies array to follow symbols
 sorting
Message-ID: <YqBW65t+hlWNok8e@krava>
References: <20220606184731.437300-1-jolsa@kernel.org>
 <20220606184731.437300-4-jolsa@kernel.org>
 <CAADnVQJA54Ra8+tV0e0KwSXAg93JRoiefDXWR-Lqatya5YWKpg@mail.gmail.com>
 <Yp+tTsqPOuVdjpba@krava>
 <CAADnVQJGoM9eqcODx2LGo-qLo0=O05gSw=iifRsWXgU0XWifAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQJGoM9eqcODx2LGo-qLo0=O05gSw=iifRsWXgU0XWifAA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 07, 2022 at 09:10:32PM -0700, Alexei Starovoitov wrote:
> On Tue, Jun 7, 2022 at 12:56 PM Jiri Olsa <olsajiri@gmail.com> wrote:
> >
> > On Tue, Jun 07, 2022 at 11:40:47AM -0700, Alexei Starovoitov wrote:
> > > On Mon, Jun 6, 2022 at 11:48 AM Jiri Olsa <jolsa@kernel.org> wrote:
> > > >
> > > > When user specifies symbols and cookies for kprobe_multi link
> > > > interface it's very likely the cookies will be misplaced and
> > > > returned to wrong functions (via get_attach_cookie helper).
> > > >
> > > > The reason is that to resolve the provided functions we sort
> > > > them before passing them to ftrace_lookup_symbols, but we do
> > > > not do the same sort on the cookie values.
> > > >
> > > > Fixing this by using sort_r function with custom swap callback
> > > > that swaps cookie values as well.
> > > >
> > > > Fixes: 0236fec57a15 ("bpf: Resolve symbols with ftrace_lookup_symbols for kprobe multi link")
> > > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > >
> > > It looks good, but something in this patch is causing a regression:
> > > ./test_progs -t kprobe_multi
> > > test_kprobe_multi_test:PASS:load_kallsyms 0 nsec
> > > #80/1    kprobe_multi_test/skel_api:OK
> > > #80/2    kprobe_multi_test/link_api_addrs:OK
> > > #80/3    kprobe_multi_test/link_api_syms:OK
> > > #80/4    kprobe_multi_test/attach_api_pattern:OK
> > > #80/5    kprobe_multi_test/attach_api_addrs:OK
> > > #80/6    kprobe_multi_test/attach_api_syms:OK
> > > #80/7    kprobe_multi_test/attach_api_fails:OK
> > > test_bench_attach:PASS:get_syms 0 nsec
> > > test_bench_attach:PASS:kprobe_multi_empty__open_and_load 0 nsec
> > > libbpf: prog 'test_kprobe_empty': failed to attach: No such process
> > > test_bench_attach:FAIL:bpf_program__attach_kprobe_multi_opts
> > > unexpected error: -3
> > > #80/8    kprobe_multi_test/bench_attach:FAIL
> > > #80      kprobe_multi_test:FAIL
> >
> > looks like kallsyms search failed to find some symbol,
> > but I can't reproduce with:
> >
> >   ./vmtest.sh -- ./test_progs -t kprobe_multi
> >
> > can you share .config you used?
> 
> I don't think it's config related.
> Patch 2 is doing:
> 
> - if (!bsearch(&name, args->syms, args->cnt, sizeof(*args->syms), symbols_cmp))
> + sym = bsearch(&name, args->syms, args->cnt, sizeof(*args->syms), symbols_cmp);
> + if (!sym)
> + return 0;
> +
> + idx = sym - args->syms;
> + if (args->addrs[idx])
>   return 0;
> 
>   addr = ftrace_location(addr);
>   if (!addr)
>   return 0;
> 
> - args->addrs[args->found++] = addr;
> + args->addrs[idx] = addr;
> + args->found++;
>   return args->found == args->cnt ? 1 : 0;
> 
> There are plenty of functions with the same name
> in available_filter_functions.
> So
>  if (args->addrs[idx])
>   return 0;
> triggers for a lot of them.
> At the end args->found != args->cnt.

there's code in get_syms (prog_tests/kprobe_multi_test.c)
that filters out duplicates

> 
> Here is trivial debug patch:
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 601ccf1b2f09..c567cf56cb57 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -8037,8 +8037,10 @@ static int kallsyms_callback(void *data, const
> char *name,
>                 return 0;
> 
>         idx = sym - args->syms;
> -       if (args->addrs[idx])
> +       if (args->addrs[idx]) {
> +               printk("idx %x name %s\n", idx, name);
>                 return 0;
> +       }
> 
>         addr = ftrace_location(addr);
>         if (!addr)
> @@ -8078,6 +8080,7 @@ int ftrace_lookup_symbols(const char
> **sorted_syms, size_t cnt, unsigned long *a
>         err = kallsyms_on_each_symbol(kallsyms_callback, &args);
>         if (err < 0)
>                 return err;
> +       printk("found %zd cnt %zd\n", args.found, args.cnt);
>         return args.found == args.cnt ? 0 : -ESRCH;
>  }
> 
> [   13.096160] idx a500 name unregister_vclock
> [   13.096930] idx 82fb name pt_regs_offset
> [   13.106969] idx 92be name set_root
> [   13.107290] idx 4414 name event_function
> [   13.112570] idx 7d1d name phy_init
> [   13.114459] idx 7d13 name phy_exit
> [   13.114777] idx ab91 name watchdog
> [   13.115730] found 46921 cnt 47036
> 
> I don't understand how it works for you at all.
> It passes in BPF CI only because we don't run
> kprobe_multi_test/bench_attach there (yet).

reproduced after I updated the tree today.. not sure why I did
not see that before, going to check

jirka
