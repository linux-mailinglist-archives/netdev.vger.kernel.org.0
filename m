Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF72950F0E1
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 08:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244209AbiDZGYd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 02:24:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235274AbiDZGYa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 02:24:30 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B15CB11D979;
        Mon, 25 Apr 2022 23:21:23 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id r11so10798873ila.1;
        Mon, 25 Apr 2022 23:21:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C04koQG1wbN44JI+UcqxASaAJw/XAs2NrTIysUPixu8=;
        b=dXXbgcbPsquEn0/nnIRGS9U3UZvH1dTQP1wBi2J4wdE4+kD7t8m0nNPhTsYgl33+Vw
         6l/aIH0Y3lUbFO6DdqqhkQdHnq5xBRBgTTflyHisDJT4SAOxoEnuN07TeRpP4q7PCbJi
         1rqUP1ZNT9HkHwfqnoBv0aO4YfTgEEIbsMszyyPrXVxv8U014kXSTirFgR0ep615BNSc
         EMIJkh2w0rlVJbQz+CVl1D1zQYHqsXbghI03RtMOyd7mSrC7XPt6498DOsFG0fbQKR66
         y6waaDTgF2WYs0KTQ9fFjo3ExfeMIJrqLjETpD+mWqj/FEP3B6vjjd4XOl7tJNY/5T9W
         qM7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C04koQG1wbN44JI+UcqxASaAJw/XAs2NrTIysUPixu8=;
        b=19VkMOLkkjm8ULCpqVJ2vyyiG4vmM0cHvi/HVpuQgkhdiuCwvwYHKQXvo9xBe0ydV2
         MLl263BD1xuG3GX6QbCyILm3piso2rvTsimPgRFTks1qeemgj7ErxTLPNwt16KZMwxr2
         aerPsM2WzEWXKVAwL+YivlqbZ1DCJKt8/8D1a2PjBR4Dfc6BcD3pSEpdEEbcZ07MHn0T
         CExttlGj+K0R9jg6u040Jv1JABqu/M/Elo3cNbkZ6LsNwaUDYi7qOyAkLbuQujyHFXxj
         u3nB+XK2tKkdzBSG3AZb+WhC1VmfOLOZ3K0vUXaf/vLpWj/p2gYmSUS50SyR4udQ1/uf
         ICgw==
X-Gm-Message-State: AOAM532Oe34nYgWmItmxFdavHas+Idoepg/bSILR4nTpeMZyIPzxinZo
        S386gvpAci0iwm/Q0V2UYFa8vJclXK9OtwcjRlQmuNV5
X-Google-Smtp-Source: ABdhPJx9Zv9yHLJz0nP3Oz8AKY6K+TmX+AZLC5hI4FzaeKaozEeZII1shM4Di+2AtT9QMjCl7BapB5m9LsVa7kFNIaU=
X-Received: by 2002:a05:6e02:1b89:b0:2cd:942d:86e3 with SMTP id
 h9-20020a056e021b8900b002cd942d86e3mr3665483ili.71.1650954083066; Mon, 25 Apr
 2022 23:21:23 -0700 (PDT)
MIME-Version: 1.0
References: <20220422100025.1469207-1-jolsa@kernel.org> <20220422100025.1469207-4-jolsa@kernel.org>
 <YmLf3PQ9ws2C/Myu@kernel.org> <YmZM0kd7uWqPOu0x@krava>
In-Reply-To: <YmZM0kd7uWqPOu0x@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 25 Apr 2022 23:21:12 -0700
Message-ID: <CAEf4BzbfghXdt4wAmRbgRiP2_jiCkRtD+AYL+CTKKY-4OPKg6w@mail.gmail.com>
Subject: Re: [PATCH perf/core 3/5] perf tools: Move libbpf init in libbpf_init function
To:     Jiri Olsa <olsajiri@gmail.com>
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "linux-perf-use." <linux-perf-users@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 25, 2022 at 12:25 AM Jiri Olsa <olsajiri@gmail.com> wrote:
>
> On Fri, Apr 22, 2022 at 02:03:24PM -0300, Arnaldo Carvalho de Melo wrote:
> > Em Fri, Apr 22, 2022 at 12:00:23PM +0200, Jiri Olsa escreveu:
> > > Moving the libbpf init code into single function,
> > > so we have single place doing that.
> >
> > Cherry picked this one, waiting for Andrii to chime in wrt the libbpf
> > changes, if its acceptable, how to proceed, i.e. in what tree to carry
> > these?
>
> I think at this point it's ok with either yours perf/core or bpf-next/master,
> I waited for them to be in sync for this ;-)

I'd rather have all the libbpf code stay in bpf-next, otherwise Github
sync process becomes very hairy. BTW, I think libbpf v0.8 release is
pretty close, I plan to add few small features before cutting it, but
that should be done pretty soon

>
> but as you pointed out there's issue with perf linked with dynamic libbpf,
> because the current version does not have the libbpf_register_prog_handler
> api that perf needs now.. also it needs the fix and api introduced in this
> patchset
>
> I'll check and perhaps we can temporirly disable perf/bpf prologue generation
> for dynamic linking..? until the libbpf release has all the needed changes
>
> jirka
>
> >
> > - Arnaldo
> >
> > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > > ---
> > >  tools/perf/util/bpf-loader.c | 27 ++++++++++++++++++---------
> > >  1 file changed, 18 insertions(+), 9 deletions(-)
> > >

[...]
