Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED91052B6FF
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 12:12:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234592AbiERJrF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 05:47:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234747AbiERJrB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 05:47:01 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CF15B0D20;
        Wed, 18 May 2022 02:46:49 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id n10so2696746ejk.5;
        Wed, 18 May 2022 02:46:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pOJXVil4VclYs2S1UBKr+b6Wwq+6/ZQ/m4OJe2PJjiU=;
        b=lEcRcmbKSlx7Y+hVEsJj354uZz2B50GQGqhZZPJA4wX2UcLmAi45O84RH+IT//MeSm
         YOMZtImgjzVyif1l/BmRUzjN0t3maDpDwg9qRCcb985v4F4n3VcuHPQ4ufNtii5uq60X
         VkvU+/mmMUSUDCdduuZc4VFrtvHdXQXW6ghRSF2ouZIs56xdajEq7rgajvqZI9MvjS0t
         nzeznId4fRW005I1OTw3u/HoeICqinl/JZTneyui8xFdsRc6v8AjYxKB3bF8+EtPmApP
         29mrVZavRlq6IonnHFEipKBhRLntRwcFJlYVA72Pe/DKtrehd3HOKosjQ/UW0Dk8iJwC
         XAYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pOJXVil4VclYs2S1UBKr+b6Wwq+6/ZQ/m4OJe2PJjiU=;
        b=5R4SKfqXWkFPe9HvKU8m2z14HRFKZE+dhxiZgp4VZvvJpC5qQwgXp0BzzacEqw96jy
         GJvXEXCIHjL1SJ7oPDdK4zh3UGlFPQTNr/O+DJ4+4KTa+fryU4R7sKasrpJo7PU04iPI
         LE4M0UqolS7rXqmbDr/UhgjnlMNVRc7ZYsTRYpMS/EBOXYUwywPsTXC5pLB7rWQFX3jY
         F4FFJS+tL6zxMRDHDpniWSusMnfYzWYnJAjVyAxFNUlqaUh3K0YOm0eaP8qTxM0L2ijc
         lniGOoDzjmly7mZZOdCCmWC0jvI9JCprR2kFP+e8aMq1vFp9G7yZ4M8b2ros5MtRBnAI
         /djQ==
X-Gm-Message-State: AOAM533myMvAfGKvTWnV8/ROnkDr0sJ9i87BaLrnv5U5U2nl10Ljz6/6
        j9asLO7/6+T0N62lHqb5GDB4Swn9AcWR2MGw
X-Google-Smtp-Source: ABdhPJykfVlIj1MzD7CGs4spJtSFJVQUfze1Ni6VwkNPe7tqbmKoNoSj5c7cl2PuRHbJgx/7MkDGow==
X-Received: by 2002:a17:907:7ba9:b0:6fe:5636:1636 with SMTP id ne41-20020a1709077ba900b006fe56361636mr9273808ejc.463.1652867207446;
        Wed, 18 May 2022 02:46:47 -0700 (PDT)
Received: from krava ([193.85.244.190])
        by smtp.gmail.com with ESMTPSA id w6-20020a05640234c600b0042ab48ea729sm1118228edc.88.2022.05.18.02.46.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 02:46:46 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Wed, 18 May 2022 11:46:44 +0200
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
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
        John Fastabend <john.fastabend@gmail.com>,
        Ian Rogers <irogers@google.com>
Subject: Re: [PATCHv2 0/3] perf tools: Fix prologue generation
Message-ID: <YoTAhC+6j4JshqN8@krava>
References: <20220510074659.2557731-1-jolsa@kernel.org>
 <CAEf4BzbK9zgetgE1yKkCANTZqizUrXgamJa2X0f0XmzQUdFrCQ@mail.gmail.com>
 <YntnRixbfQ1HCm9T@krava>
 <Ynv+7iaaAbyM38B6@kernel.org>
 <CAEf4BzaQsF31f3WuU32wDCzo6bw7eY8E9zF6Lo218jfw-VQmcA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzaQsF31f3WuU32wDCzo6bw7eY8E9zF6Lo218jfw-VQmcA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 17, 2022 at 03:02:53PM -0700, Andrii Nakryiko wrote:
> On Wed, May 11, 2022 at 11:22 AM Arnaldo Carvalho de Melo
> <acme@kernel.org> wrote:
> >
> > Em Wed, May 11, 2022 at 09:35:34AM +0200, Jiri Olsa escreveu:
> > > On Tue, May 10, 2022 at 04:48:55PM -0700, Andrii Nakryiko wrote:
> > > > On Tue, May 10, 2022 at 12:47 AM Jiri Olsa <jolsa@kernel.org> wrote:
> > > > >
> > > > > hi,
> > > > > sending change we discussed some time ago [1] to get rid of
> > > > > some deprecated functions we use in perf prologue code.
> > > > >
> > > > > Despite the gloomy discussion I think the final code does
> > > > > not look that bad ;-)
> > > > >
> > > > > This patchset removes following libbpf functions from perf:
> > > > >   bpf_program__set_prep
> > > > >   bpf_program__nth_fd
> > > > >   struct bpf_prog_prep_result
> > > > >
> > > > > v2 changes:
> > > > >   - use fallback section prog handler, so we don't need to
> > > > >     use section prefix [Andrii]
> > > > >   - realloc prog->insns array in bpf_program__set_insns [Andrii]
> > > > >   - squash patch 1 from previous version with
> > > > >     bpf_program__set_insns change [Daniel]
> > > > >   - patch 3 already merged [Arnaldo]
> > > > >   - added more comments
> > > > >
> > > > >   meanwhile.. perf/core and bpf-next diverged, so:
> > > > >     - libbpf bpf_program__set_insns change is based on bpf-next/master
> > > > >     - perf changes do not apply on bpf-next/master so they are based on
> > > > >       perf/core ... however they can be merged only after we release
> > > > >       libbpf 0.8.0 with bpf_program__set_insns change, so we don't break
> > > > >       the dynamic linking
> > > > >       I'm sending perf changes now just for review, I'll resend them
> > > > >       once libbpf 0.8.0 is released
> > > > >
> > > > > thanks,
> > > > > jirka
> > > > >
> > > > >
> > > > > [1] https://lore.kernel.org/bpf/CAEf4BzaiBO3_617kkXZdYJ8hS8YF--ZLgapNbgeeEJ-pY0H88g@mail.gmail.com/
> > > > > ---
> > > > > Jiri Olsa (1):
> > > > >       libbpf: Add bpf_program__set_insns function
> > > > >
> > > >
> > > > The first patch looks good to me. The rest I can't really review and
> > > > test properly, so I'll leave it up to Arnaldo.
> > > >
> > > > Arnaldo, how do we coordinate these patches? Should they go through
> > > > bpf-next (after you Ack them) or you want them in your tree?
> > > >
> > > > I'd like to get the bpf_program__set_insns() patch into bpf-next so
> > > > that I can do libbpf v0.8 release, having it in a separate tree is
> > > > extremely inconvenient. Please let me know how you think we should
> > > > proceed?
> > >
> > > we need to wait with perf changes after the libbpf is merged and
> > > libbpf 0.8.0 is released.. so we don't break dynamic linking for
> > > perf
> > >
> > > at the moment please just take libbpf change and I'll resend the
> > > perf change later if needed
> >
> > Ok.
> >
> 
> Jiri, libbpf v0.8 is out, can you please re-send your perf patches?

yep, just made new fedora package.. will resend the perf changes soon

jirka
