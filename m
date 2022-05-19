Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBF2252D115
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 13:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237231AbiESLDO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 07:03:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237187AbiESLDL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 07:03:11 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14EB23A5F3;
        Thu, 19 May 2022 04:03:10 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id t6so6638006wra.4;
        Thu, 19 May 2022 04:03:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gXGKvrxbHJV3I8yg1mV9yWVFPv2HTYtrEzxLyQt8eLg=;
        b=SqKNGJ6hMqBJSagUicT++5RTS2FFFIgWO8EWkU5ferPqO06ANhP/hBjOvWdcVm5fVA
         jaCs0j1fKs7uD0tVS2KFhXaNNOyYvvXRftzWd9hTbsI1x4c5e/RJGhskw4cHBX/cyCl2
         3NaLcVsOhLTQ1Q+hhRvf12r2RTjJYhKbr06T2yUUz++X/erSzb+mwUI+4CURVtaMf4n5
         ravx0aRzyTdbmtVdtp+d9HnjKW0nfI7xhkWlVqRKfMFpkkukLQfX9LN3QWPAYHnOLDCy
         VXbbABZhI8kha0F0Tb9GAB4idZb9oVel7QGMpEuXl/DVexUcdgwELW1LmxgdWK5H6SNK
         le8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gXGKvrxbHJV3I8yg1mV9yWVFPv2HTYtrEzxLyQt8eLg=;
        b=JI27YZm/HF+Dtgx8WpABK6HMRWLfI9Rav8c83nWCaAIJdbt4lBMZxIfh+/c8KyHyuk
         sjDnZSarp62S/8tLJXsyLWOE6rj+lce9BkRKGHImiv24hPbSzQf34AaoL8bAccY+qYpg
         /zISfioburYiLTG782PSNBU5jdyt61E5TcY30SRjzOCc+jcYrDYFSwAY/+cHitqSK8Gq
         scUxiPZKL7u+fllrVCYu84t6RW80cYecZXz7GY8wtJ89Dky52Vh+mHOdvtaxnivNH8mY
         q7EZqRCUS4C6Ey1rDMdrE0Bm97P3nm4lH6/fqb3/xYr6vZZ3/VO0ZhvcVjqdRV5MypJh
         O/kw==
X-Gm-Message-State: AOAM5320dTXSyj2/ftSyEctBPC6XphlZmF7eb7cQJ5Zp1DhPtu28lfkS
        NGqbtOsA8BjB3SeE+qWcYDQ=
X-Google-Smtp-Source: ABdhPJx/UHpBMXNEqLPm2PKDYlqcOHyIBzCi24Jdyhhp3HywmcRtD3ikB96pfLEHvXb1mTqXPztGLQ==
X-Received: by 2002:a5d:64a1:0:b0:20e:5bac:1aa7 with SMTP id m1-20020a5d64a1000000b0020e5bac1aa7mr3399266wrp.667.1652958188489;
        Thu, 19 May 2022 04:03:08 -0700 (PDT)
Received: from krava ([193.85.244.190])
        by smtp.gmail.com with ESMTPSA id m64-20020a1ca343000000b003942a244ee4sm4359217wme.41.2022.05.19.04.03.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 04:03:07 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Thu, 19 May 2022 13:03:05 +0200
To:     Jiri Olsa <olsajiri@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
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
Subject: Re: [PATCHv2 0/3] perf tools: Fix prologue generation
Message-ID: <YoYj6cb0aPNN/olH@krava>
References: <20220510074659.2557731-1-jolsa@kernel.org>
 <CAEf4BzbK9zgetgE1yKkCANTZqizUrXgamJa2X0f0XmzQUdFrCQ@mail.gmail.com>
 <YntnRixbfQ1HCm9T@krava>
 <Ynv+7iaaAbyM38B6@kernel.org>
 <CAEf4BzaQsF31f3WuU32wDCzo6bw7eY8E9zF6Lo218jfw-VQmcA@mail.gmail.com>
 <YoTAhC+6j4JshqN8@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YoTAhC+6j4JshqN8@krava>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 18, 2022 at 11:46:44AM +0200, Jiri Olsa wrote:
> On Tue, May 17, 2022 at 03:02:53PM -0700, Andrii Nakryiko wrote:
> > On Wed, May 11, 2022 at 11:22 AM Arnaldo Carvalho de Melo
> > <acme@kernel.org> wrote:
> > >
> > > Em Wed, May 11, 2022 at 09:35:34AM +0200, Jiri Olsa escreveu:
> > > > On Tue, May 10, 2022 at 04:48:55PM -0700, Andrii Nakryiko wrote:
> > > > > On Tue, May 10, 2022 at 12:47 AM Jiri Olsa <jolsa@kernel.org> wrote:
> > > > > >
> > > > > > hi,
> > > > > > sending change we discussed some time ago [1] to get rid of
> > > > > > some deprecated functions we use in perf prologue code.
> > > > > >
> > > > > > Despite the gloomy discussion I think the final code does
> > > > > > not look that bad ;-)
> > > > > >
> > > > > > This patchset removes following libbpf functions from perf:
> > > > > >   bpf_program__set_prep
> > > > > >   bpf_program__nth_fd
> > > > > >   struct bpf_prog_prep_result
> > > > > >
> > > > > > v2 changes:
> > > > > >   - use fallback section prog handler, so we don't need to
> > > > > >     use section prefix [Andrii]
> > > > > >   - realloc prog->insns array in bpf_program__set_insns [Andrii]
> > > > > >   - squash patch 1 from previous version with
> > > > > >     bpf_program__set_insns change [Daniel]
> > > > > >   - patch 3 already merged [Arnaldo]
> > > > > >   - added more comments
> > > > > >
> > > > > >   meanwhile.. perf/core and bpf-next diverged, so:
> > > > > >     - libbpf bpf_program__set_insns change is based on bpf-next/master
> > > > > >     - perf changes do not apply on bpf-next/master so they are based on
> > > > > >       perf/core ... however they can be merged only after we release
> > > > > >       libbpf 0.8.0 with bpf_program__set_insns change, so we don't break
> > > > > >       the dynamic linking
> > > > > >       I'm sending perf changes now just for review, I'll resend them
> > > > > >       once libbpf 0.8.0 is released
> > > > > >
> > > > > > thanks,
> > > > > > jirka
> > > > > >
> > > > > >
> > > > > > [1] https://lore.kernel.org/bpf/CAEf4BzaiBO3_617kkXZdYJ8hS8YF--ZLgapNbgeeEJ-pY0H88g@mail.gmail.com/
> > > > > > ---
> > > > > > Jiri Olsa (1):
> > > > > >       libbpf: Add bpf_program__set_insns function
> > > > > >
> > > > >
> > > > > The first patch looks good to me. The rest I can't really review and
> > > > > test properly, so I'll leave it up to Arnaldo.
> > > > >
> > > > > Arnaldo, how do we coordinate these patches? Should they go through
> > > > > bpf-next (after you Ack them) or you want them in your tree?
> > > > >
> > > > > I'd like to get the bpf_program__set_insns() patch into bpf-next so
> > > > > that I can do libbpf v0.8 release, having it in a separate tree is
> > > > > extremely inconvenient. Please let me know how you think we should
> > > > > proceed?
> > > >
> > > > we need to wait with perf changes after the libbpf is merged and
> > > > libbpf 0.8.0 is released.. so we don't break dynamic linking for
> > > > perf
> > > >
> > > > at the moment please just take libbpf change and I'll resend the
> > > > perf change later if needed
> > >
> > > Ok.
> > >
> > 
> > Jiri, libbpf v0.8 is out, can you please re-send your perf patches?
> 
> yep, just made new fedora package.. will resend the perf changes soon

fedora package is on the way, but I'll need perf/core to merge
the bpf_program__set_insns change.. Arnaldo, any idea when this
could happen?

thanks,
jirka
