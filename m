Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92E5F53D243
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 21:12:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348869AbiFCTMe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 15:12:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348811AbiFCTMc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 15:12:32 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7F9439B82;
        Fri,  3 Jun 2022 12:12:30 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id y29so9394220ljd.7;
        Fri, 03 Jun 2022 12:12:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s9H/2G67jjwwNRYeTE9y1UIake4ZPkc4A7dULW7T4YQ=;
        b=KUmC6aDPHo7NEcOzM22l6XWST1a6GmF0lgIr4syhOJFztcCTOS4HWi8fFmavsI8oiw
         x0AVco1dvYi0dHFkF97Gx6vdDFUVesOmkWluGriV2sIJTfYYsUinjdpPUEsfEu/q0ycJ
         09B7m/o3Ve/ec5mb3YVLe7GId53U/eBRhSD2pmRvqYzC1fE9QS2zPZVTQB9s9Xe7uTht
         X6Sb3/VxMGGjAHi1J1JlZoY0lC1WHH3wO8p0qjMVcHbKUCX92yiYSAX234MUgDPwgP6K
         d8xJt3d2IPb4S4glMkLLLiPKiljF7+/3LKwm0bbuFUABxpSE3z3WlJgMXZi8eU42V5Cj
         3WsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s9H/2G67jjwwNRYeTE9y1UIake4ZPkc4A7dULW7T4YQ=;
        b=EN9eOkzBoZDfrzQuIpEGb1BK9i0DqZKEktrP9zCbpy3hBJ2Wi9M/TUuYJE7qx+H5u+
         ECM4unjo0RsLDXBu71MNYFSZaifJIFr6vzO+RI4Mq3Ci+8hm99zwvDgWTe9PnKePr6b0
         PVDAg8bKbXSrcHwQ1Au+8kcIyblVlTc+8TAkylXueJgfLNp0QO67WtnXa/ixKPkLmdvF
         j/yqh3rCBGdqhaCqHld9+ovWTjkc1hE0Km14n7mMWa38Z0p6QBEHO23ZU5G0bjPCbweJ
         CDP1onGhz5ZQHuqHu63kKFh7Cqg4nWTCA/ceAzi7fjtP92bB+u+IKM0S3RAALeQgOmum
         u4bw==
X-Gm-Message-State: AOAM531GLZsKhpUHI6Uc7xoiCYTR+SivjDi/8Sxj1Xxmy08Jxj7H0DMF
        zvBQlc1y9dOOEy+JXqfoF1ZA9RjwGLzVaDhHZmI=
X-Google-Smtp-Source: ABdhPJwGXQxFgTK2T/bv5P8x3Kz0T1dUVfNZfOmtvJ1Qw7A98pFPzvyoUQEECwQKpYhS6Sh3aCQ+W+zB/33Qx88s9oM=
X-Received: by 2002:a2e:a7c5:0:b0:253:ee97:f9b7 with SMTP id
 x5-20020a2ea7c5000000b00253ee97f9b7mr33481530ljp.472.1654283549239; Fri, 03
 Jun 2022 12:12:29 -0700 (PDT)
MIME-Version: 1.0
References: <20220527205611.655282-1-jolsa@kernel.org> <20220527205611.655282-3-jolsa@kernel.org>
 <CAEf4BzbfbPA-U+GObZy2cEZOn9qAHqRmKtKq-rPOVM=_+DGVww@mail.gmail.com> <YpnfldPKcEqesioK@krava>
In-Reply-To: <YpnfldPKcEqesioK@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 3 Jun 2022 12:12:17 -0700
Message-ID: <CAEf4BzZury5Tnm1xmAadeOqNEtbTifNZ7065C4ax-GkXaz6dog@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/3] ftrace: Keep address offset in ftrace_lookup_symbols
To:     Jiri Olsa <olsajiri@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
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

On Fri, Jun 3, 2022 at 3:16 AM Jiri Olsa <olsajiri@gmail.com> wrote:
>
> On Thu, Jun 02, 2022 at 03:52:03PM -0700, Andrii Nakryiko wrote:
> > On Fri, May 27, 2022 at 1:56 PM Jiri Olsa <jolsa@kernel.org> wrote:
> > >
> > > We want to store the resolved address on the same index as
> > > the symbol string, because that's the user (bpf kprobe link)
> > > code assumption.
> > >
> > > Also making sure we don't store duplicates that might be
> > > present in kallsyms.
> > >
> > > Fixes: bed0d9a50dac ("ftrace: Add ftrace_lookup_symbols function")
> > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > > ---
> > >  kernel/trace/ftrace.c | 13 +++++++++++--
> > >  1 file changed, 11 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> > > index 674add0aafb3..00d0ba6397ed 100644
> > > --- a/kernel/trace/ftrace.c
> > > +++ b/kernel/trace/ftrace.c
> > > @@ -7984,15 +7984,23 @@ static int kallsyms_callback(void *data, const char *name,
> > >                              struct module *mod, unsigned long addr)
> > >  {
> > >         struct kallsyms_data *args = data;
> > > +       const char **sym;
> > > +       int idx;
> > >
> > > -       if (!bsearch(&name, args->syms, args->cnt, sizeof(*args->syms), symbols_cmp))
> > > +       sym = bsearch(&name, args->syms, args->cnt, sizeof(*args->syms), symbols_cmp);
> > > +       if (!sym)
> > > +               return 0;
> > > +
> > > +       idx = sym - args->syms;
> > > +       if (args->addrs[idx])
> >
> > if we have duplicated symbols we won't increment args->found here,
> > right? So we won't stop early. But we also don't want to increment
> > args->found here because we use it to check that we don't have
> > duplicates (in addition to making sure we resolved all the unique
> > symbols), right?
> >
> > So I wonder if in this situation should we return some error code to
> > signify that we encountered symbol duplicate?
>
> hum, this callback is called for each kallsyms symbol and there
> are duplicates in /proc/kallsyms.. so even if we have just single
> copy of such symbol in args->syms, bsearch will find this single
> symbol for all the duplicates in /proc/kallsyms and we will endup
> in here.. and it's still fine, we should continue
>

ah, ok, duplicate kallsyms entries, right, never mind then

> jirka
>
> >
> >
> > >                 return 0;
> > >
> > >         addr = ftrace_location(addr);
> > >         if (!addr)
> > >                 return 0;
> > >
> > > -       args->addrs[args->found++] = addr;
> > > +       args->addrs[idx] = addr;
> > > +       args->found++;
> > >         return args->found == args->cnt ? 1 : 0;
> > >  }
> > >
> > > @@ -8017,6 +8025,7 @@ int ftrace_lookup_symbols(const char **sorted_syms, size_t cnt, unsigned long *a
> > >         struct kallsyms_data args;
> > >         int err;
> > >
> > > +       memset(addrs, 0x0, sizeof(*addrs) * cnt);
> > >         args.addrs = addrs;
> > >         args.syms = sorted_syms;
> > >         args.cnt = cnt;
> > > --
> > > 2.35.3
> > >
