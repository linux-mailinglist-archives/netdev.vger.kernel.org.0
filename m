Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F20E453C879
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 12:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243493AbiFCKRC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 06:17:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242867AbiFCKRA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 06:17:00 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D110BC2E;
        Fri,  3 Jun 2022 03:16:57 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id h5so9846701wrb.0;
        Fri, 03 Jun 2022 03:16:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/77dZPgSUoE0SYO0JlE+nz8jz/dM6461hDUeKKkiK0s=;
        b=kElUmYPu2WBSWkfGdPIbo+gojVPSl0jt0cDt9so0uWBN/m2z2RDc+zIbLHSzoHY7vY
         +bO/wYZJ0Km6ODvQkY6tK1XDnQJidCmvMfaj41NWfNmTrhJ7oLCHZwocQPa2uY+CR4IA
         5af46pQmv0JicSIvE6FHu6nQhhIgBGd4Gz/t5Xz591iWxGGgpvbyGIoqW9pNY8sux0yO
         EYO3rZSjCvYcoDfH0BKK+b5Nea/g1kJq2SIzahPbFB9ZcMsKXbIisPG8yN76p6KpmbOE
         tYeMf0p4bSB+3OqM6wyPJU+Zp8hA5Xa1LVK1dLTpHYD7T1gK4LMuie7DqX6NMCxom4SO
         C7Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/77dZPgSUoE0SYO0JlE+nz8jz/dM6461hDUeKKkiK0s=;
        b=I2Lotal3i+uQr6Y6D2LQnR5iKBbV2po5reLC7nZ7jief+0NaxNhV/bWM6lnW/npAhb
         xDZCvRi4s7mC6qQmdDEgntCzBjZawxVYGTp1bT6CQZ3YkiShSFnjUJvsJznoC6ic6QHh
         JsCUHUQ31CcSj3/gIizU7LAkM5RQEFrgtrqUxiQiNYCnv6gztsgZtRdf/8h7nyLDA2bN
         sgbbrWl5lfunmMt42MndrflsdMuuXWSifIsoVu3V6aFreMRAe6p7MpP7AxKhpAJujYFi
         SMqch8qiN9HvLX/1pW6bWys7v/bmEx5jUTJOMDJ7P0ucwWfHj7dnCjLwRw6VDiGhRq9y
         XwPg==
X-Gm-Message-State: AOAM5305FiJKO3KxD/llrBJ8TslnRX81X3qs3jGNfZBwP48r0N5lcaOp
        lwQWZc6byjHovN9EEgbBBG4=
X-Google-Smtp-Source: ABdhPJxFlN7EwKPN65Ha7ej7Ny5RlrEjR5WPck7DmZIeb7VnVC7DAw1c3pUZYfma4V/da4LcaMMyPQ==
X-Received: by 2002:adf:f110:0:b0:210:78bd:7ea5 with SMTP id r16-20020adff110000000b0021078bd7ea5mr7258471wro.459.1654251416418;
        Fri, 03 Jun 2022 03:16:56 -0700 (PDT)
Received: from krava ([193.85.244.190])
        by smtp.gmail.com with ESMTPSA id h4-20020adffd44000000b002102d4ed579sm6826665wrs.39.2022.06.03.03.16.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jun 2022 03:16:55 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Fri, 3 Jun 2022 12:16:53 +0200
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
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
Subject: Re: [PATCH bpf-next 2/3] ftrace: Keep address offset in
 ftrace_lookup_symbols
Message-ID: <YpnfldPKcEqesioK@krava>
References: <20220527205611.655282-1-jolsa@kernel.org>
 <20220527205611.655282-3-jolsa@kernel.org>
 <CAEf4BzbfbPA-U+GObZy2cEZOn9qAHqRmKtKq-rPOVM=_+DGVww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzbfbPA-U+GObZy2cEZOn9qAHqRmKtKq-rPOVM=_+DGVww@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 02, 2022 at 03:52:03PM -0700, Andrii Nakryiko wrote:
> On Fri, May 27, 2022 at 1:56 PM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > We want to store the resolved address on the same index as
> > the symbol string, because that's the user (bpf kprobe link)
> > code assumption.
> >
> > Also making sure we don't store duplicates that might be
> > present in kallsyms.
> >
> > Fixes: bed0d9a50dac ("ftrace: Add ftrace_lookup_symbols function")
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  kernel/trace/ftrace.c | 13 +++++++++++--
> >  1 file changed, 11 insertions(+), 2 deletions(-)
> >
> > diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> > index 674add0aafb3..00d0ba6397ed 100644
> > --- a/kernel/trace/ftrace.c
> > +++ b/kernel/trace/ftrace.c
> > @@ -7984,15 +7984,23 @@ static int kallsyms_callback(void *data, const char *name,
> >                              struct module *mod, unsigned long addr)
> >  {
> >         struct kallsyms_data *args = data;
> > +       const char **sym;
> > +       int idx;
> >
> > -       if (!bsearch(&name, args->syms, args->cnt, sizeof(*args->syms), symbols_cmp))
> > +       sym = bsearch(&name, args->syms, args->cnt, sizeof(*args->syms), symbols_cmp);
> > +       if (!sym)
> > +               return 0;
> > +
> > +       idx = sym - args->syms;
> > +       if (args->addrs[idx])
> 
> if we have duplicated symbols we won't increment args->found here,
> right? So we won't stop early. But we also don't want to increment
> args->found here because we use it to check that we don't have
> duplicates (in addition to making sure we resolved all the unique
> symbols), right?
> 
> So I wonder if in this situation should we return some error code to
> signify that we encountered symbol duplicate?

hum, this callback is called for each kallsyms symbol and there
are duplicates in /proc/kallsyms.. so even if we have just single
copy of such symbol in args->syms, bsearch will find this single
symbol for all the duplicates in /proc/kallsyms and we will endup
in here.. and it's still fine, we should continue

jirka

> 
> 
> >                 return 0;
> >
> >         addr = ftrace_location(addr);
> >         if (!addr)
> >                 return 0;
> >
> > -       args->addrs[args->found++] = addr;
> > +       args->addrs[idx] = addr;
> > +       args->found++;
> >         return args->found == args->cnt ? 1 : 0;
> >  }
> >
> > @@ -8017,6 +8025,7 @@ int ftrace_lookup_symbols(const char **sorted_syms, size_t cnt, unsigned long *a
> >         struct kallsyms_data args;
> >         int err;
> >
> > +       memset(addrs, 0x0, sizeof(*addrs) * cnt);
> >         args.addrs = addrs;
> >         args.syms = sorted_syms;
> >         args.cnt = cnt;
> > --
> > 2.35.3
> >
