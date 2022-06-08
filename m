Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8517D54280E
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 09:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231767AbiFHHW7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 03:22:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244536AbiFHFzR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 01:55:17 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD19943E825;
        Tue,  7 Jun 2022 21:10:45 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id h19so25461834edj.0;
        Tue, 07 Jun 2022 21:10:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YbEob6Rmm6pW1VPB8x8xhq32k/5rIyV9Dc/pG7KqAkg=;
        b=GI0jVjQZLILiQ/Tf7p28dLzb0ZGX0dmbmVrUCTCv2aaMWEzhi5C+mf6fzbOyfOfC4v
         DtND2szIO5P1xElGhFy5aC+NfmF2hW6XcM2viPgx3Wpws1oIVTxXWY8LoXy3zZ3JZWnG
         TmvY12l/YuxLstyYM4ufse+EeHFcEDuXpwfGdW4K/elO1eJa3YXKUstV5qhAuKyW20Df
         T4Z9YcBeyddwIASLSa3q9hYYTC05rTLihICtL+SZcJRb5wlPg376yg1VY32+WUEPbMMJ
         R6SKtiRIJWw6JVVUQi/7oMWf8c47eUtd6UUA+NYVKepEi8lsUrVjoqFVoHETzP3UE7o/
         /New==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YbEob6Rmm6pW1VPB8x8xhq32k/5rIyV9Dc/pG7KqAkg=;
        b=izFT4+4tqAfWO4CI9stu5zCChnYFdy42sWq9V7RCZPdmm1kZ20zk34cJS3/rSog+jM
         Ou6bgJB+Mi7GG0m68rgkrEkQZnvZjIZ4okK6r7s8xg6wQBrs/ttVBuH1wUMEdEDHXGCY
         RvI/RcwUbT/QivJoQbLdo4RvBZ0/CIHXSZi0a5SYC1ad64FmSNgTUuut+CrJ5OlO9+xS
         H+wv7YU0pCadS/+d3QVYcPF4zVvhz/ZXdrr1qsMksowTVyb2PO3Wf0/MSvGDaVuTLhB3
         jhenTu/ysnQnyD9ssdtIVulT5g8FDaUWv/rQZRbq22emZvAX90G6RJbS9r5yyI3fCJwt
         sIuw==
X-Gm-Message-State: AOAM530OBy8UjR5cdi/bORFwiBZzHzCNvMbUXB6Nqtvv/56Jrxc7RMuQ
        rhxPA5QC1FXmBjqWpRntgST1RnH5+zSGawH6zj0=
X-Google-Smtp-Source: ABdhPJyyrV1tUfSb7OpmwML/pDMXGUR0qGF5nRt4zfwZEmdiMPFDOzWptqOzQcYsX0mHPEWGhAxQDe0mSzFK59c7HWo=
X-Received: by 2002:a05:6402:5168:b0:42d:d3f6:2a1b with SMTP id
 d8-20020a056402516800b0042dd3f62a1bmr36245673ede.94.1654661444352; Tue, 07
 Jun 2022 21:10:44 -0700 (PDT)
MIME-Version: 1.0
References: <20220606184731.437300-1-jolsa@kernel.org> <20220606184731.437300-4-jolsa@kernel.org>
 <CAADnVQJA54Ra8+tV0e0KwSXAg93JRoiefDXWR-Lqatya5YWKpg@mail.gmail.com> <Yp+tTsqPOuVdjpba@krava>
In-Reply-To: <Yp+tTsqPOuVdjpba@krava>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 7 Jun 2022 21:10:32 -0700
Message-ID: <CAADnVQJGoM9eqcODx2LGo-qLo0=O05gSw=iifRsWXgU0XWifAA@mail.gmail.com>
Subject: Re: [PATCHv2 bpf 3/3] bpf: Force cookies array to follow symbols sorting
To:     Jiri Olsa <olsajiri@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
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
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 7, 2022 at 12:56 PM Jiri Olsa <olsajiri@gmail.com> wrote:
>
> On Tue, Jun 07, 2022 at 11:40:47AM -0700, Alexei Starovoitov wrote:
> > On Mon, Jun 6, 2022 at 11:48 AM Jiri Olsa <jolsa@kernel.org> wrote:
> > >
> > > When user specifies symbols and cookies for kprobe_multi link
> > > interface it's very likely the cookies will be misplaced and
> > > returned to wrong functions (via get_attach_cookie helper).
> > >
> > > The reason is that to resolve the provided functions we sort
> > > them before passing them to ftrace_lookup_symbols, but we do
> > > not do the same sort on the cookie values.
> > >
> > > Fixing this by using sort_r function with custom swap callback
> > > that swaps cookie values as well.
> > >
> > > Fixes: 0236fec57a15 ("bpf: Resolve symbols with ftrace_lookup_symbols for kprobe multi link")
> > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> >
> > It looks good, but something in this patch is causing a regression:
> > ./test_progs -t kprobe_multi
> > test_kprobe_multi_test:PASS:load_kallsyms 0 nsec
> > #80/1    kprobe_multi_test/skel_api:OK
> > #80/2    kprobe_multi_test/link_api_addrs:OK
> > #80/3    kprobe_multi_test/link_api_syms:OK
> > #80/4    kprobe_multi_test/attach_api_pattern:OK
> > #80/5    kprobe_multi_test/attach_api_addrs:OK
> > #80/6    kprobe_multi_test/attach_api_syms:OK
> > #80/7    kprobe_multi_test/attach_api_fails:OK
> > test_bench_attach:PASS:get_syms 0 nsec
> > test_bench_attach:PASS:kprobe_multi_empty__open_and_load 0 nsec
> > libbpf: prog 'test_kprobe_empty': failed to attach: No such process
> > test_bench_attach:FAIL:bpf_program__attach_kprobe_multi_opts
> > unexpected error: -3
> > #80/8    kprobe_multi_test/bench_attach:FAIL
> > #80      kprobe_multi_test:FAIL
>
> looks like kallsyms search failed to find some symbol,
> but I can't reproduce with:
>
>   ./vmtest.sh -- ./test_progs -t kprobe_multi
>
> can you share .config you used?

I don't think it's config related.
Patch 2 is doing:

- if (!bsearch(&name, args->syms, args->cnt, sizeof(*args->syms), symbols_cmp))
+ sym = bsearch(&name, args->syms, args->cnt, sizeof(*args->syms), symbols_cmp);
+ if (!sym)
+ return 0;
+
+ idx = sym - args->syms;
+ if (args->addrs[idx])
  return 0;

  addr = ftrace_location(addr);
  if (!addr)
  return 0;

- args->addrs[args->found++] = addr;
+ args->addrs[idx] = addr;
+ args->found++;
  return args->found == args->cnt ? 1 : 0;

There are plenty of functions with the same name
in available_filter_functions.
So
 if (args->addrs[idx])
  return 0;
triggers for a lot of them.
At the end args->found != args->cnt.

Here is trivial debug patch:
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 601ccf1b2f09..c567cf56cb57 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -8037,8 +8037,10 @@ static int kallsyms_callback(void *data, const
char *name,
                return 0;

        idx = sym - args->syms;
-       if (args->addrs[idx])
+       if (args->addrs[idx]) {
+               printk("idx %x name %s\n", idx, name);
                return 0;
+       }

        addr = ftrace_location(addr);
        if (!addr)
@@ -8078,6 +8080,7 @@ int ftrace_lookup_symbols(const char
**sorted_syms, size_t cnt, unsigned long *a
        err = kallsyms_on_each_symbol(kallsyms_callback, &args);
        if (err < 0)
                return err;
+       printk("found %zd cnt %zd\n", args.found, args.cnt);
        return args.found == args.cnt ? 0 : -ESRCH;
 }

[   13.096160] idx a500 name unregister_vclock
[   13.096930] idx 82fb name pt_regs_offset
[   13.106969] idx 92be name set_root
[   13.107290] idx 4414 name event_function
[   13.112570] idx 7d1d name phy_init
[   13.114459] idx 7d13 name phy_exit
[   13.114777] idx ab91 name watchdog
[   13.115730] found 46921 cnt 47036

I don't understand how it works for you at all.
It passes in BPF CI only because we don't run
kprobe_multi_test/bench_attach there (yet).
