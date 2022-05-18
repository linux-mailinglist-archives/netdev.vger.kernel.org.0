Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 481BA52B744
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 12:13:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234243AbiERJsk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 05:48:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232778AbiERJsj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 05:48:39 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A583460A8F;
        Wed, 18 May 2022 02:48:37 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id t6so1904050wra.4;
        Wed, 18 May 2022 02:48:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rRc4ITj1pwxMufibbMzExSF35u5hK1P/FT4xYai9KVw=;
        b=jdcRG6I+t08rf21/JkRYHs1GdFqebk10xac5P/wNfZ2YAa0nwcLJpR0pkzA/mjTuYJ
         vSURqjSWnX0ewro8vEAhOlLKEM8WoIpG+LuwG9DKc56uzUvhZj950ZiKIhgOh+61D+ft
         hFcjxJ89RVD/iP7WyBeH67P5NqxefmdJ9c7a85JelchvHs8muJnF6HuitiR6wlL4mRgV
         8108f7jYpqE4MjuuGO+X6ld6GRphyY+XG/8quBDmnnA8R77lLzYpmkZGV3XXsyCBkhAM
         HVAHnySFC+JeXzE9j4KPB7sw5HuvfNspJ54GIwBpWhBS4ysl5gNwFt92rHvjtgodnzsc
         nkzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rRc4ITj1pwxMufibbMzExSF35u5hK1P/FT4xYai9KVw=;
        b=19BvV/8Z0z3vh8nyijcnZbxGNtj7JMnJ67iEq3+4ntDJ7jzhIWzoIbYk0LInG/J8Da
         ub6T4KqR4PqJ390XaeVMG/qGd+Ryh4yR4UitL+bwmaThGD0wlUuPOGfG0uz7BBsn78KP
         uFMJfp7HCk++/AgBW3+Xtd/RwnXF3G2wTzq6BzV8aU9nOoh2nCO+2VVTnkCMCU7mymDw
         1mFNbiRlFu/NQweo7MqGC4B0rbBhVuAcbrPHMHvMRNyLEvuuHuXkXd9JXEBeyJLkmNqy
         AfWnDSKrQsGJs4YMM4ljB23M47+97Q+ffZuE0lLR6mDDPs2augBIAtmSqaC+SOCEkBQA
         wf5Q==
X-Gm-Message-State: AOAM530PDvRGv45kHO/4iGSQnZ3JobN6nqxgIjkSC7NEoCLnYZw+cp59
        gjMJ+GjUvbIkE0BWCzWDR44=
X-Google-Smtp-Source: ABdhPJzvB2pvBpVXEzikrd+4CPwTc3drF/WEwKtb1xgMXHvqCABAuE4dnsmXiKnAiQOjyt8iyBBK5A==
X-Received: by 2002:a5d:584b:0:b0:20c:6317:1f77 with SMTP id i11-20020a5d584b000000b0020c63171f77mr22541774wrf.355.1652867316100;
        Wed, 18 May 2022 02:48:36 -0700 (PDT)
Received: from krava ([193.85.244.190])
        by smtp.gmail.com with ESMTPSA id j10-20020adfa78a000000b0020c5253d8fcsm1785705wrc.72.2022.05.18.02.48.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 02:48:35 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Wed, 18 May 2022 11:48:33 +0200
To:     Ian Rogers <irogers@google.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <olsajiri@gmail.com>,
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
        John Fastabend <john.fastabend@gmail.com>
Subject: Re: [PATCHv2 0/3] perf tools: Fix prologue generation
Message-ID: <YoTA8Q1Ij/eD8BI4@krava>
References: <20220510074659.2557731-1-jolsa@kernel.org>
 <CAEf4BzbK9zgetgE1yKkCANTZqizUrXgamJa2X0f0XmzQUdFrCQ@mail.gmail.com>
 <YntnRixbfQ1HCm9T@krava>
 <Ynv+7iaaAbyM38B6@kernel.org>
 <CAEf4BzaQsF31f3WuU32wDCzo6bw7eY8E9zF6Lo218jfw-VQmcA@mail.gmail.com>
 <CAP-5=fX6Z549my7VR0GYNW11vvXJc_4dmg8KOvaFAusjKJV=JA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAP-5=fX6Z549my7VR0GYNW11vvXJc_4dmg8KOvaFAusjKJV=JA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 17, 2022 at 09:45:56PM -0700, Ian Rogers wrote:
> On Tue, May 17, 2022 at 3:03 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
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
> We still haven't done as Andrii suggested in:
> https://lore.kernel.org/lkml/CAEf4BzbbOHQZUAe6iWaehKCPQAf3VC=hq657buqe2_yRKxaK-A@mail.gmail.com/
> so for LIBBPF_DYNAMIC I believe we're compiling against the header
> files in tools/lib rather than the installed libbpf's header files.
> This may have some unexpected consequences.

like your program is not doing what you expected.. been there ;-)
sounds good, will check

jirka
