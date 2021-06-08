Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFC583A076F
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 01:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235172AbhFHXHu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 19:07:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232310AbhFHXHs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 19:07:48 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1239CC061574;
        Tue,  8 Jun 2021 16:05:41 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id v27-20020a056830091bb02903cd67d40070so18946929ott.1;
        Tue, 08 Jun 2021 16:05:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rmpqNyoSPpV2gAR13cGS3P/kngTI8mdR9jTSkuOZMTc=;
        b=Ei2kC/AdViXkFYvtr5auiQGqbZBwAonWCDZEO5hw9M2st6RExu7xbjd/QjA1o0fd0d
         g/7Epu2dQAqRZI2zlgZLjOP/5EKSuaf8doVyz118IbLINLo2DtC0tv2ICuMqI+eYqIXT
         8lMeh++DG+EdxeyfqVyo3G5H77Zt0ttg8u7+TFmhqL6tVHPzrotrBbP3h3i7AjFBUm1m
         fRvSZLRiwnXhwgNFr8gV+94S7vSlkiaeSR4ACVBulB55Sg5vrcc40lVV/pfQcsoGLuJl
         akx5VTDSpbJfs1PPN3pHnryc2UvPf2+kRo76/5GC0/gozr+mfsBG6aY+IrWDkb0zy+yb
         RLAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rmpqNyoSPpV2gAR13cGS3P/kngTI8mdR9jTSkuOZMTc=;
        b=memfdjQYUpNi26LSViUjsxk+TZoKsrlVYQImgKECqUcRB6JvZua6wRsgOFAstOGT9y
         gzsnwmYfhUsltiu183PUs0tnol6eA5uXgTeizNcaLuY3sZlw1QgRQdE9K9/p+eAHcWYg
         ZD5hJ/pbaO7xvHwfEYIhuG2f51d1uEkYDRfe9nUYmBQZLECufRXg+Ba1I0A3J4BHP8RA
         Cc3lZSFBVsEmgNNMhJoedDHgetwHxpWCLCVgpMxLExPF8M/J9+hwMSIVpXWNlmTzb2Wb
         okGSpzRirfCFDeDH2lFSMtF5iASj78Bkjg+flfm3Qu1t97SQOyQOWIZUgU1UuTnJRIt6
         ICkg==
X-Gm-Message-State: AOAM53320uKXO5tZ1g2M3ctaIflvlQDEusybe/l7z7jEfTPJmxjBjTsJ
        vTnHTtNJKo6q9UZe8Zjc8JXTeWDJNu9oi9rWHLU=
X-Google-Smtp-Source: ABdhPJxX61JEX94cF+jruVq6oInUOzZyLFOaNS4woYk689fsz262JuicEn6sUv+Jdx8h1bl/5xMwsgi+o3LzElKwNGU=
X-Received: by 2002:a9d:5d14:: with SMTP id b20mr20198404oti.307.1623193540441;
 Tue, 08 Jun 2021 16:05:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210605111034.1810858-1-jolsa@kernel.org> <20210605111034.1810858-14-jolsa@kernel.org>
 <CAADnVQJV+0SjqUrTw+3Y02tFedcAaPKJS-W8sQHw5YT4XUW0hQ@mail.gmail.com>
 <YL+0HLQ9oSrNM7ip@krava> <20210608184903.rgnv65jimekqugol@ast-mbp.dhcp.thefacebook.com>
 <YL/cIBArrCjhgyXt@krava>
In-Reply-To: <YL/cIBArrCjhgyXt@krava>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 8 Jun 2021 16:05:29 -0700
Message-ID: <CAADnVQ+zEdv8BfNHGYO=xi-ePwfoKQUd_yxmRB3jHByPmYxCWw@mail.gmail.com>
Subject: Re: [PATCH 13/19] bpf: Add support to link multi func tracing program
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Viktor Malik <vmalik@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 8, 2021 at 2:07 PM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Tue, Jun 08, 2021 at 11:49:03AM -0700, Alexei Starovoitov wrote:
> > On Tue, Jun 08, 2021 at 08:17:00PM +0200, Jiri Olsa wrote:
> > > On Tue, Jun 08, 2021 at 08:42:32AM -0700, Alexei Starovoitov wrote:
> > > > On Sat, Jun 5, 2021 at 4:11 AM Jiri Olsa <jolsa@kernel.org> wrote:
> > > > >
> > > > > Adding support to attach multiple functions to tracing program
> > > > > by using the link_create/link_update interface.
> > > > >
> > > > > Adding multi_btf_ids/multi_btf_ids_cnt pair to link_create struct
> > > > > API, that define array of functions btf ids that will be attached
> > > > > to prog_fd.
> > > > >
> > > > > The prog_fd needs to be multi prog tracing program (BPF_F_MULTI_FUNC).
> > > > >
> > > > > The new link_create interface creates new BPF_LINK_TYPE_TRACING_MULTI
> > > > > link type, which creates separate bpf_trampoline and registers it
> > > > > as direct function for all specified btf ids.
> > > > >
> > > > > The new bpf_trampoline is out of scope (bpf_trampoline_lookup) of
> > > > > standard trampolines, so all registered functions need to be free
> > > > > of direct functions, otherwise the link fails.
> > > >
> > > > Overall the api makes sense to me.
> > > > The restriction of multi vs non-multi is too severe though.
> > > > The multi trampoline can serve normal fentry/fexit too.
> > >
> > > so multi trampoline gets called from all the registered functions,
> > > so there would need to be filter for specific ip before calling the
> > > standard program.. single cmp/jnz might not be that bad, I'll check
> >
> > You mean reusing the same multi trampoline for all IPs and regenerating
> > it with a bunch of cmp/jnz checks? There should be a better way to scale.
> > Maybe clone multi trampoline instead?
> > IPs[1-10] will point to multi.
> > IP[11] will point to a clone of multi that serves multi prog and
> > fentry/fexit progs specific for that IP.
>
> ok, so we'd clone multi trampoline if there's request to attach
> standard trampoline to some IP from multi trampoline
>
> .. and transform currently attached standard trampoline for IP
> into clone of multi trampoline, if there's request to create
> multi trampoline that covers that IP

yep. For every IP==btf_id there will be only two possible trampolines.
Should be easy enough to track and transition between them.
The standard fentry/fexit will only get negligible slowdown from
going through multi.
multi+fexit and fmod_ret needs to be thought through as well.
That's why I thought that 'ip' at the end should simplify things.
Only multi will have access to it.
But we can store it first too. fentry/fexit will see ctx=r1 with +8 offset
and will have normal args in ctx. Like ip isn't even there.
While multi trampoline is always doing ip, arg1,arg2, .., arg6
and passes ctx = &ip into multi prog and ctx = &arg1 into fentry/fexit.
'ret' for fexit is problematic though. hmm.
Maybe such clone multi trampoline for specific ip with 2 args will do:
ip, arg1, arg2, ret, 0, 0, 0, ret.
Then multi will have 6 args, though 3rd is actually ret.
Then fexit will have ret in the right place and multi prog will have
it as 7th arg.
