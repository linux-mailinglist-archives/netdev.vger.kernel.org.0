Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74C2A542CD4
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 12:15:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236358AbiFHKNL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 06:13:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236221AbiFHKL5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 06:11:57 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 191BCDD8;
        Wed,  8 Jun 2022 02:57:53 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id p10so27618050wrg.12;
        Wed, 08 Jun 2022 02:57:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AgfMNBib7UM3nkWKGRMYqmPSG5BAh7VGLgNwYuJlSAU=;
        b=jkVbvK19uq3VC2QQwiHQs0mPnLK1lCn7GozXRnhHgAZvgQr+HRR++kmeC9lo5K0Pgi
         9FnyL/rJ4uYdluugTD/Xzaq5GUKRAfMQh5r0DJU8r0K6OkO/XvhlaIyZITbKhAV0DODN
         KXK2wW3a+HaZxLugSQRjqzNM4R+oR7HP9rurbQbhvHqU89VTNXz1WJ5BvIL58cEx4Eyy
         74qDjISJZZBfQbCmVBcUldYi0fxkM066tEubagPAMSxgx3k/rjExnHTM9KlXlTjE03pW
         oDk2UP/wno8/iW+es9L07+tJG8HEnVeMx4H/HiksBpFK9aJrKeGTbk2oBP8XRIRNqyMJ
         hkfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AgfMNBib7UM3nkWKGRMYqmPSG5BAh7VGLgNwYuJlSAU=;
        b=Q/ZFPILKlOD924u0oRfn5CK2gFA1stjQRv1bzFuBuJnYGoI8DzsX8sSz6yxS3zocCf
         qqXkDU0h3B8f03tUkQhBqpovV5W6zQJ9ftAhX1Ls8jouK3Z9Dj76lN1aIfL+/2LxLhv6
         dg5wiptRDXU/Ltofr4SkS6vmM4FUmjk3ZHt+4NwPlMZT+fz8huwIXfr2hPkcre1obir6
         F68qg3WjR4e5w3MkQ9olMdPHFMuZr1iwBG9ZUzGbXqEZBr1nnp0cfEx0gE6gm/f47p8X
         g8Ge38vXgS0Jyz4ocwU2YuuQdtNDF1c9EWlM+N1VgKxejQBDUoQsY9gjbfQsuz/CJGNG
         +G3A==
X-Gm-Message-State: AOAM532YCwiBWQiQBF5yt6GqTwnQVlB3/Q2gePRZ78dsBLIAIcf4hYRk
        bW7uQ/c+AoGRun0be6O3qUo=
X-Google-Smtp-Source: ABdhPJw1u3psXI4E3ncjpcqP6MvDb4PfKsC3SbFsCjjZ7phT5drV6+EJ9Xah5fkbu2YwXIzdZHj6Fw==
X-Received: by 2002:a5d:624e:0:b0:210:a42:f29d with SMTP id m14-20020a5d624e000000b002100a42f29dmr31837340wrv.615.1654682271423;
        Wed, 08 Jun 2022 02:57:51 -0700 (PDT)
Received: from krava ([193.85.244.190])
        by smtp.gmail.com with ESMTPSA id m3-20020a05600c3b0300b003942a244f2fsm28377154wms.8.2022.06.08.02.57.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 02:57:50 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Wed, 8 Jun 2022 11:57:48 +0200
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
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
        Masami Hiramatsu <mhiramat@kernel.org>
Subject: Re: [PATCHv2 bpf 3/3] bpf: Force cookies array to follow symbols
 sorting
Message-ID: <YqBynO64am32z13X@krava>
References: <20220606184731.437300-1-jolsa@kernel.org>
 <20220606184731.437300-4-jolsa@kernel.org>
 <CAADnVQJA54Ra8+tV0e0KwSXAg93JRoiefDXWR-Lqatya5YWKpg@mail.gmail.com>
 <Yp+tTsqPOuVdjpba@krava>
 <CAADnVQJGoM9eqcODx2LGo-qLo0=O05gSw=iifRsWXgU0XWifAA@mail.gmail.com>
 <YqBW65t+hlWNok8e@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YqBW65t+hlWNok8e@krava>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 08, 2022 at 09:59:41AM +0200, Jiri Olsa wrote:
> On Tue, Jun 07, 2022 at 09:10:32PM -0700, Alexei Starovoitov wrote:
> > On Tue, Jun 7, 2022 at 12:56 PM Jiri Olsa <olsajiri@gmail.com> wrote:
> > >
> > > On Tue, Jun 07, 2022 at 11:40:47AM -0700, Alexei Starovoitov wrote:
> > > > On Mon, Jun 6, 2022 at 11:48 AM Jiri Olsa <jolsa@kernel.org> wrote:
> > > > >
> > > > > When user specifies symbols and cookies for kprobe_multi link
> > > > > interface it's very likely the cookies will be misplaced and
> > > > > returned to wrong functions (via get_attach_cookie helper).
> > > > >
> > > > > The reason is that to resolve the provided functions we sort
> > > > > them before passing them to ftrace_lookup_symbols, but we do
> > > > > not do the same sort on the cookie values.
> > > > >
> > > > > Fixing this by using sort_r function with custom swap callback
> > > > > that swaps cookie values as well.
> > > > >
> > > > > Fixes: 0236fec57a15 ("bpf: Resolve symbols with ftrace_lookup_symbols for kprobe multi link")
> > > > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > > >
> > > > It looks good, but something in this patch is causing a regression:
> > > > ./test_progs -t kprobe_multi
> > > > test_kprobe_multi_test:PASS:load_kallsyms 0 nsec
> > > > #80/1    kprobe_multi_test/skel_api:OK
> > > > #80/2    kprobe_multi_test/link_api_addrs:OK
> > > > #80/3    kprobe_multi_test/link_api_syms:OK
> > > > #80/4    kprobe_multi_test/attach_api_pattern:OK
> > > > #80/5    kprobe_multi_test/attach_api_addrs:OK
> > > > #80/6    kprobe_multi_test/attach_api_syms:OK
> > > > #80/7    kprobe_multi_test/attach_api_fails:OK
> > > > test_bench_attach:PASS:get_syms 0 nsec
> > > > test_bench_attach:PASS:kprobe_multi_empty__open_and_load 0 nsec
> > > > libbpf: prog 'test_kprobe_empty': failed to attach: No such process
> > > > test_bench_attach:FAIL:bpf_program__attach_kprobe_multi_opts
> > > > unexpected error: -3
> > > > #80/8    kprobe_multi_test/bench_attach:FAIL
> > > > #80      kprobe_multi_test:FAIL
> > >
> > > looks like kallsyms search failed to find some symbol,
> > > but I can't reproduce with:
> > >
> > >   ./vmtest.sh -- ./test_progs -t kprobe_multi
> > >
> > > can you share .config you used?
> > 
> > I don't think it's config related.
> > Patch 2 is doing:
> > 
> > - if (!bsearch(&name, args->syms, args->cnt, sizeof(*args->syms), symbols_cmp))
> > + sym = bsearch(&name, args->syms, args->cnt, sizeof(*args->syms), symbols_cmp);
> > + if (!sym)
> > + return 0;
> > +
> > + idx = sym - args->syms;
> > + if (args->addrs[idx])
> >   return 0;
> > 
> >   addr = ftrace_location(addr);
> >   if (!addr)
> >   return 0;
> > 
> > - args->addrs[args->found++] = addr;
> > + args->addrs[idx] = addr;
> > + args->found++;
> >   return args->found == args->cnt ? 1 : 0;
> > 
> > There are plenty of functions with the same name
> > in available_filter_functions.
> > So
> >  if (args->addrs[idx])
> >   return 0;
> > triggers for a lot of them.
> > At the end args->found != args->cnt.
> 
> there's code in get_syms (prog_tests/kprobe_multi_test.c)
> that filters out duplicates
> 
> > 
> > Here is trivial debug patch:
> > diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> > index 601ccf1b2f09..c567cf56cb57 100644
> > --- a/kernel/trace/ftrace.c
> > +++ b/kernel/trace/ftrace.c
> > @@ -8037,8 +8037,10 @@ static int kallsyms_callback(void *data, const
> > char *name,
> >                 return 0;
> > 
> >         idx = sym - args->syms;
> > -       if (args->addrs[idx])
> > +       if (args->addrs[idx]) {
> > +               printk("idx %x name %s\n", idx, name);
> >                 return 0;
> > +       }
> > 
> >         addr = ftrace_location(addr);
> >         if (!addr)
> > @@ -8078,6 +8080,7 @@ int ftrace_lookup_symbols(const char
> > **sorted_syms, size_t cnt, unsigned long *a
> >         err = kallsyms_on_each_symbol(kallsyms_callback, &args);
> >         if (err < 0)
> >                 return err;
> > +       printk("found %zd cnt %zd\n", args.found, args.cnt);
> >         return args.found == args.cnt ? 0 : -ESRCH;
> >  }
> > 
> > [   13.096160] idx a500 name unregister_vclock
> > [   13.096930] idx 82fb name pt_regs_offset
> > [   13.106969] idx 92be name set_root
> > [   13.107290] idx 4414 name event_function
> > [   13.112570] idx 7d1d name phy_init
> > [   13.114459] idx 7d13 name phy_exit
> > [   13.114777] idx ab91 name watchdog
> > [   13.115730] found 46921 cnt 47036
> > 
> > I don't understand how it works for you at all.
> > It passes in BPF CI only because we don't run
> > kprobe_multi_test/bench_attach there (yet).
> 
> reproduced after I updated the tree today.. not sure why I did
> not see that before, going to check

ok, I'm not completely crazy ;-) it's the weak functions fix:

  b39181f7c690 ftrace: Add FTRACE_MCOUNT_MAX_OFFSET to avoid adding weak function

I should have noticed this before (from changelog):

    A worker thread is added at boot up to scan all the ftrace record entries,
    and will mark any that fail the FTRACE_MCOUNT_MAX_OFFSET test as disabled.
    They will still appear in the available_filter_functions file as:
    
      __ftrace_invalid_address___<invalid-offset>
    
    (showing the offset that caused it to be invalid).


Steven,
is there a reason to show '__ftrace_invalid_address___*' symbols in
available_filter_functions? it seems more like debug message to me

I can easily filter them out, but my assumption was that any symbol
in available_filter_functions could be resolved in /proc/kalsyms

with the workaround patch below the bench test is passing for me

thanks,
jirka


---
diff --git a/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c b/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
index 586dc52d6fb9..88086ac23ef3 100644
--- a/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
+++ b/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
@@ -364,6 +364,8 @@ static int get_syms(char ***symsp, size_t *cntp)
 			continue;
 		if (!strncmp(name, "rcu_", 4))
 			continue;
+		if (!strncmp(name, "__ftrace_invalid_address__", sizeof("__ftrace_invalid_address__") - 1))
+			continue;
 		err = hashmap__add(map, name, NULL);
 		if (err) {
 			free(name);
