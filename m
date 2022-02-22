Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B8234BF830
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 13:42:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231995AbiBVMm6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 07:42:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231993AbiBVMm4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 07:42:56 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C9FC122216;
        Tue, 22 Feb 2022 04:42:31 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id u18so36620008edt.6;
        Tue, 22 Feb 2022 04:42:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sZOLEDaGh1SF5st8EQEk8EIqOeyAcu0epbvUe7EMQfA=;
        b=CtrlfUHtFIlffb9GrntCIKuLT7AfygnrZ9E5h3v2+48NWGW4ICXVWoOLZQHj1qffo9
         NqmIXx3Mx/vKWRVk128yFnu44Mvpou1nrNMGLgffaVKOKS0Jr/eT89S2vyjmMzq27vzl
         /AUi1eYf8/8DperuLUE9ujZRdAqXWsNpLztjUcdVebtEZj1PWaMIgtBuZPBrlpSDn+XI
         /AJUQN2/hDlYrF/BJT+VUIqW8wHeOQxF02Xn572Dui+NodPgR4hlH2aiGwwo08lwcB2X
         ANlHFqZ6FNXzoXYiZZsNuZgQwSywEwkdh4kuEVfKVO2QgaoNop+eYCIbArP3vod/QkhT
         2W3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sZOLEDaGh1SF5st8EQEk8EIqOeyAcu0epbvUe7EMQfA=;
        b=eL3k29rCvoA4ymi+bQSEtcCJk1vgwozQmNtPBrBfjjk9XhiQa6NIzLvDFkZe/n6jb6
         CNhuhckUzdyI6l1AGXZb0VUDmapGmZiQJNwdsSxFYvbOvOdfspdMIuoOQGuixo0WEaWe
         zu1LFVfTNbPM2/DBU/nGmq0NcAq1gOnL8j0DvnviWi9+jDlGiP3pxiEOfMdOccE+OenJ
         5EclWcDsvwhcOyI/EN4TsmhwmxuuDOR99rG6Xncx4jcyJHQ0YVp1hNcsBywnarqY4qM4
         8zVrSEkXUSR7BXxvfnlkLMd5RA5EqPYco+VBc3F6t6RWwBrgKHRx2yKJtqxzrmgsB4cl
         jU3w==
X-Gm-Message-State: AOAM531Uh7bKbuMoJYCi9jpxIXMK4NigE3cuKGwh3WwDeSKOgQ6bHH/r
        bJSgH8K4fVuwOxjGfM+sPiU=
X-Google-Smtp-Source: ABdhPJxlzd38Mt5rRXYGTndmCY97WTXfiKT01qrwU2HkDalGwQg9uM1GFn1icvDOOboroyLwMZt0Zw==
X-Received: by 2002:a50:9b12:0:b0:410:b926:d2d3 with SMTP id o18-20020a509b12000000b00410b926d2d3mr26282285edi.331.1645533749972;
        Tue, 22 Feb 2022 04:42:29 -0800 (PST)
Received: from krava ([83.240.63.118])
        by smtp.gmail.com with ESMTPSA id bn15sm6301853ejb.93.2022.02.22.04.42.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Feb 2022 04:42:29 -0800 (PST)
Date:   Tue, 22 Feb 2022 13:42:26 +0100
From:   Jiri Olsa <olsajiri@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [PATCH 0/8] bpf: Add fprobe link
Message-ID: <YhTaMi9BN7p5FPGX@krava>
References: <YfvvfLlM1FOTgvDm@krava>
 <20220204094619.2784e00c0b7359356458ca57@kernel.org>
 <CAADnVQJYY0Xm6M9O02E5rOkdQPX39NOOS4tM2jpwRLQvP-qDBg@mail.gmail.com>
 <20220204110704.7c6eaf43ff9c8f5fe9bf3179@kernel.org>
 <CAADnVQJfq_10H0V+u0w0rzyZ9uy7vq=T-3BMDANjEN8A3-prsQ@mail.gmail.com>
 <20220203211954.67c20cd3@gandalf.local.home>
 <CAADnVQKjNJjZDs+ZV7vcusEkKuDq+sWhSD3M5GtvNeZMx3Fcmg@mail.gmail.com>
 <20220204125942.a4bda408f536c2e3248955e1@kernel.org>
 <Yguo4v7c+3A0oW/h@krava>
 <CAEf4BzYO_B51TPgUnDXUPUsK55RSczwcnhuLz9DMbfO5JCj=Cw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYO_B51TPgUnDXUPUsK55RSczwcnhuLz9DMbfO5JCj=Cw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 16, 2022 at 10:27:19AM -0800, Andrii Nakryiko wrote:

SNIP

> >
> > hi,
> > tying to kick things further ;-) I was thinking about bpf side of this
> > and we could use following interface:
> >
> >   enum bpf_attach_type {
> >     ...
> >     BPF_TRACE_KPROBE_MULTI
> >   };
> >
> >   enum bpf_link_type {
> >     ...
> >     BPF_LINK_TYPE_KPROBE_MULTI
> >   };
> >
> >   union bpf_attr {
> >
> >     struct {
> >       ...
> >       struct {
> >         __aligned_u64   syms;
> >         __aligned_u64   addrs;
> >         __aligned_u64   cookies;
> >         __u32           cnt;
> >         __u32           flags;
> >       } kprobe_multi;
> >     } link_create;
> >   }
> >
> > because from bpf user POV it's new link for attaching multiple kprobes
> > and I agree new 'fprobe' type name in here brings more confusion, using
> > kprobe_multi is straightforward
> >
> > thoguhts?
> 
> I think this makes sense. We do need new type of link to store ip ->
> cookie mapping anyways.
> 
> Is there any chance to support this fast multi-attach for uprobe? If
> yes, we might want to reuse the same link for both (so should we name
> it more generically? on the other hand BPF program type for uprobe is
> BPF_PROG_TYPE_KPROBE anyway, so keeping it as "kprobe" also would be
> consistent with what we have today).
> 
> But yeah, the main question is whether there is something preventing
> us from supporting multi-attach uprobe as well? It would be really
> great for USDT use case.

I need to check with uprobes, my understanding ends at perf/trace
code calling uprobe_register ;-)

maybe I should first try if uprobes suffer the same performance issue

I'll send another version with above interface, because there's
tons of other fixes, and by the time for next version we might
have answer for the interface change

jirka
