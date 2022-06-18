Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 061DA5506CB
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 23:21:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232328AbiFRVR1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jun 2022 17:17:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232078AbiFRVR0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jun 2022 17:17:26 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41D2626E1;
        Sat, 18 Jun 2022 14:17:25 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id o8so9782467wro.3;
        Sat, 18 Jun 2022 14:17:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=F9zHQ5BDlESv+EJld7HTiBi3G93zCJ7miFrzqyCk/Ys=;
        b=dfQzXNEvZ6jMhwDtZrRIQghsVUkY4XdSbUtJaOIebJgfW4IgNmRiLfaEhzJU4kvSkO
         sFGsrmX//kn1dE9Bjik5X0Gqj4kkRtbgb909R3uFbLgYislj8kqwg8zHPtQObYDMBaQh
         tKgbJy+nnhZRmDNFnc4nrztEwpSVWA5XwGknqDulxOnmSGVtZUKIbC3VY4K9kfpGR4Oo
         hr+44L1/lMe/zAjrL+0z9zQ2OwpHYZez1rtyejk+mvoKuGsr6ik8ly6rJfCv5gF1e085
         RVJCUbn83HPcmECcolCEoB062RAMl1yHgJ7JReOx/pSx9C+5gn9kW6CyyjdhCsXI/giA
         CAWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=F9zHQ5BDlESv+EJld7HTiBi3G93zCJ7miFrzqyCk/Ys=;
        b=Px8v82h76Oau3FQiTQ3H9yRVcVtZv21iOTZB/dP5floUEVLHBHUpyRcqt+gQW5dIVN
         r+J3KrKXY+gizGnjQEFxwDeO5cc6UtWLL7uClLwtocVByUmuSZmMQRvH/NKw3roJswGM
         6oWS9MUU9IvET9xuhaUDaHMhmDFWafYAwV//D1x/ALJ0HLlJ3BztAUsLiM3tnpx7PLt/
         /KEb5jqmaJ8QKf73HEvBeEQkH/LNEdF6EOAK9SlGSTS/HrkmJk0Fx0FlSy6yfoA7Ic0C
         zvjV0oUa+WAbVG++xnT2N9wGOE/9RDJJQzDuuIRgbOTs5SzGfdso7odGVskLwihpALzh
         qyEw==
X-Gm-Message-State: AJIora9Oetw7gZlj40Xq1lCZrv/vA7hidmwrSOY5Eb3Nfv9P/hcOsYAK
        vKKhqc0wYvF3gJO9JlDiOIvhxyyDH6fQOw==
X-Google-Smtp-Source: AGRyM1t/JX5RywE/NQdTYsk48Ow61saXwVBAj7MztKbhguVyPqtnjprupf+48GYsrEubjrq1po0PwQ==
X-Received: by 2002:adf:e648:0:b0:210:bac2:c6cf with SMTP id b8-20020adfe648000000b00210bac2c6cfmr15201246wrn.310.1655587043663;
        Sat, 18 Jun 2022 14:17:23 -0700 (PDT)
Received: from krava (94.113.247.30.static.b2b.upcbusiness.cz. [94.113.247.30])
        by smtp.gmail.com with ESMTPSA id n5-20020a05600c4f8500b0039c18d3fe27sm9921639wmq.19.2022.06.18.14.17.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jun 2022 14:17:23 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Sat, 18 Jun 2022 23:17:20 +0200
To:     chuang <nashuiliang@gmail.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Jingren Zhou <zhoujingren@didiglobal.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <mhiramat@kernel.org>
Subject: Re: [PATCH] libbpf: Remove kprobe_event on failed kprobe_open_legacy
Message-ID: <Yq5A4Cln4qeTaAeM@krava>
References: <20220614084930.43276-1-nashuiliang@gmail.com>
 <62ad50fa9d42d_24b34208d6@john.notmuch>
 <CACueBy7NqRszA3tCOvLhfi1OraUrL_GD9YZ9XOPNHzbR1=+z7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACueBy7NqRszA3tCOvLhfi1OraUrL_GD9YZ9XOPNHzbR1=+z7g@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 18, 2022 at 01:31:01PM +0800, chuang wrote:
> Hi John,
> 
> On Sat, Jun 18, 2022 at 12:13 PM John Fastabend
> <john.fastabend@gmail.com> wrote:
> >
> > Chuang W wrote:
> > > In a scenario where livepatch and aggrprobe coexist, the creating
> > > kprobe_event using tracefs API will succeed, a trace event (e.g.
> > > /debugfs/tracing/events/kprobe/XX) will exist, but perf_event_open()
> > > will return an error.
> >
> > This seems a bit strange from API side. I'm not really familiar with
> > livepatch, but I guess this is UAPI now so fixing add_kprobe_event_legacy
> > to fail is not an option?
> >
> 
> The legacy kprobe API (i.e. tracefs API) has two steps:
> 
> 1) register_kprobe
> $ echo 'p:mykprobe XXX' > /sys/kernel/debug/tracing/kprobe_events
> This will create a trace event of mykprobe and register a disable
> kprobe that waits to be activated.
> 
> 2) enable_kprobe
> 2.1) using syscall perf_event_open
> as the following code, perf_event_kprobe_open_legacy (file:
> tools/lib/bpf/libbpf.c):
> ---
> attr.type = PERF_TYPE_TRACEPOINT;
> pfd = syscall(__NR_perf_event_open, &attr,
>               pid < 0 ? -1 : pid, /* pid */
>               pid == -1 ? 0 : -1, /* cpu */
>               -1 /* group_fd */,  PERF_FLAG_FD_CLOEXEC);
> ---
> In the implementation code of perf_event_open, enable_kprobe() will be executed.
> 2.2) using shell
> $ echo 1 > /sys/kernel/debug/tracing/events/kprobes/mykprobe/enable
> As with perf_event_open, enable_kprobe() will also be executed.
> 
> When using the same function XXX, kprobe and livepatch cannot coexist,
> that is, step 2) will return an error (ref: arm_kprobe_ftrace()),

just curious.. is that because of ipmodify flag on ftrace_ops?
AFAICS that be a poblem just for kretprobes, cc-ing Masami

thanks,
jirka


> however, step 1) is ok!
> However, the new kprobe API (i.e. perf kprobe API) aggregates
> register_kprobe and enable_kprobe, internally fixes the issue on
> failed enable_kprobe.
> But above all, for the legacy kprobe API, I think it should remove
> kprobe_event on failed add_kprobe_event_legacy() in
> perf_event_kprobe_open_legacy (file: tools/lib/bpf/libbpf.c).
