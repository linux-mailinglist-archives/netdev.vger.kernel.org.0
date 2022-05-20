Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84FC852F54E
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 23:47:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352695AbiETVrD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 17:47:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234295AbiETVrD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 17:47:03 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96FC76C552;
        Fri, 20 May 2022 14:47:01 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id a4so1921257ilr.12;
        Fri, 20 May 2022 14:47:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1ZBMik1/6QTQj/BPf0IKq3hyUY0m96ZoQKEjpAqqJBE=;
        b=DsVwANrETf0ddWyA2eJZwLfz4mUw+xFrltRyLu2TrUpkloZBT+bG8V6bSq8bxOHs0P
         RsHjLXXwxNkPRA4/m/+3a+LM1ji0Aw0phn/l79T0+BmYe9IuLPo/vcffP4VUW7FRiDUF
         u1Cjg8u6gVcTOGyUZWDZbG8JQ+SPzz1I7nm2zDHMwzqJww1vzRul2nUoSBiKj87bSOK2
         BOJsNYdZ/OFOlQhEoknmGP/305qbjh59gjjFM7hhHftbkzp5e1XnyLCFcuhkoq2nxDgF
         pZGNPEEfXP6/fAVWpodPk0pPUSH7Plb9K06s3ra8yoHAJU2M/jTeiPPujNjNJ7rgui0t
         YeJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1ZBMik1/6QTQj/BPf0IKq3hyUY0m96ZoQKEjpAqqJBE=;
        b=eCUNWx9H+cVH0R/1Iw827DqctZATS8FJ3JM5q9sIz6VgmQPxGeXSn5Rk1WETOkoORp
         RFb2RsKF/EoMCOP334V6K1IAFmHOjRaq4zG6vo3936BpvK7d7EHQQZqLfX3mBGfgPf6W
         qW1CyrgjZg/NTMHxk/qy6fOpzJs4aUKGNKY3pOseJaeOaTpkRdbV2H//YQIYvR9ydTnG
         xUbEMP7868/e9S1eEDr7DEYF33/mdB6NAEXFOyWOAOnH9a20KJEXV40RWxxlNxBtAEJs
         rdQLk6W4huc9eKChIGfU40m76YJDT8dqxAh1Wn6Xs9pCQ57PBKvqIIU5pG0Nc8uSgUAz
         a9EQ==
X-Gm-Message-State: AOAM531GqXh4h50aaTGIcbEAsCr417qlwDEIuxpy2A0RfFGAV4zCPHac
        gTDsDNuE2izYDHn9WXA/i2ml0qp4rxj14m+EfEY=
X-Google-Smtp-Source: ABdhPJyUHD91SOzGOEoo8E850KuSMicoVjRb50KAskyoApwG9rLDR0Y66EfP9db3xuLEIQD/rL7CzXE4o6vRaIcQE1g=
X-Received: by 2002:a05:6e02:1c01:b0:2d1:262e:8d5f with SMTP id
 l1-20020a056e021c0100b002d1262e8d5fmr6238661ilh.98.1653083220919; Fri, 20 May
 2022 14:47:00 -0700 (PDT)
MIME-Version: 1.0
References: <20220510074659.2557731-1-jolsa@kernel.org> <CAEf4BzbK9zgetgE1yKkCANTZqizUrXgamJa2X0f0XmzQUdFrCQ@mail.gmail.com>
 <YntnRixbfQ1HCm9T@krava> <Ynv+7iaaAbyM38B6@kernel.org> <CAEf4BzaQsF31f3WuU32wDCzo6bw7eY8E9zF6Lo218jfw-VQmcA@mail.gmail.com>
 <YoTAhC+6j4JshqN8@krava> <YoYj6cb0aPNN/olH@krava>
In-Reply-To: <YoYj6cb0aPNN/olH@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 20 May 2022 14:46:49 -0700
Message-ID: <CAEf4Bzaa60kZJbWT0xAqcDMyXBzbg98ShuizJAv7x+8_3X0ZBg@mail.gmail.com>
Subject: Re: [PATCHv2 0/3] perf tools: Fix prologue generation
To:     Jiri Olsa <olsajiri@gmail.com>
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
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
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 19, 2022 at 4:03 AM Jiri Olsa <olsajiri@gmail.com> wrote:
>
> On Wed, May 18, 2022 at 11:46:44AM +0200, Jiri Olsa wrote:
> > On Tue, May 17, 2022 at 03:02:53PM -0700, Andrii Nakryiko wrote:
> > > On Wed, May 11, 2022 at 11:22 AM Arnaldo Carvalho de Melo
> > > <acme@kernel.org> wrote:
> > > >
> > > > Em Wed, May 11, 2022 at 09:35:34AM +0200, Jiri Olsa escreveu:
> > > > > On Tue, May 10, 2022 at 04:48:55PM -0700, Andrii Nakryiko wrote:
> > > > > > On Tue, May 10, 2022 at 12:47 AM Jiri Olsa <jolsa@kernel.org> wrote:
> > > > > > >
> > > > > > > hi,
> > > > > > > sending change we discussed some time ago [1] to get rid of
> > > > > > > some deprecated functions we use in perf prologue code.
> > > > > > >
> > > > > > > Despite the gloomy discussion I think the final code does
> > > > > > > not look that bad ;-)
> > > > > > >
> > > > > > > This patchset removes following libbpf functions from perf:
> > > > > > >   bpf_program__set_prep
> > > > > > >   bpf_program__nth_fd
> > > > > > >   struct bpf_prog_prep_result
> > > > > > >
> > > > > > > v2 changes:
> > > > > > >   - use fallback section prog handler, so we don't need to
> > > > > > >     use section prefix [Andrii]
> > > > > > >   - realloc prog->insns array in bpf_program__set_insns [Andrii]
> > > > > > >   - squash patch 1 from previous version with
> > > > > > >     bpf_program__set_insns change [Daniel]
> > > > > > >   - patch 3 already merged [Arnaldo]
> > > > > > >   - added more comments
> > > > > > >
> > > > > > >   meanwhile.. perf/core and bpf-next diverged, so:
> > > > > > >     - libbpf bpf_program__set_insns change is based on bpf-next/master
> > > > > > >     - perf changes do not apply on bpf-next/master so they are based on
> > > > > > >       perf/core ... however they can be merged only after we release
> > > > > > >       libbpf 0.8.0 with bpf_program__set_insns change, so we don't break
> > > > > > >       the dynamic linking
> > > > > > >       I'm sending perf changes now just for review, I'll resend them
> > > > > > >       once libbpf 0.8.0 is released
> > > > > > >
> > > > > > > thanks,
> > > > > > > jirka
> > > > > > >
> > > > > > >
> > > > > > > [1] https://lore.kernel.org/bpf/CAEf4BzaiBO3_617kkXZdYJ8hS8YF--ZLgapNbgeeEJ-pY0H88g@mail.gmail.com/
> > > > > > > ---
> > > > > > > Jiri Olsa (1):
> > > > > > >       libbpf: Add bpf_program__set_insns function
> > > > > > >
> > > > > >
> > > > > > The first patch looks good to me. The rest I can't really review and
> > > > > > test properly, so I'll leave it up to Arnaldo.
> > > > > >
> > > > > > Arnaldo, how do we coordinate these patches? Should they go through
> > > > > > bpf-next (after you Ack them) or you want them in your tree?
> > > > > >
> > > > > > I'd like to get the bpf_program__set_insns() patch into bpf-next so
> > > > > > that I can do libbpf v0.8 release, having it in a separate tree is
> > > > > > extremely inconvenient. Please let me know how you think we should
> > > > > > proceed?
> > > > >
> > > > > we need to wait with perf changes after the libbpf is merged and
> > > > > libbpf 0.8.0 is released.. so we don't break dynamic linking for
> > > > > perf
> > > > >
> > > > > at the moment please just take libbpf change and I'll resend the
> > > > > perf change later if needed
> > > >
> > > > Ok.
> > > >
> > >
> > > Jiri, libbpf v0.8 is out, can you please re-send your perf patches?
> >
> > yep, just made new fedora package.. will resend the perf changes soon
>
> fedora package is on the way, but I'll need perf/core to merge
> the bpf_program__set_insns change.. Arnaldo, any idea when this
> could happen?
>

Jiri, Arnaldo,

Can we land these patches through bpf-next to avoid such complicated
cross-tree dependencies? As I started removing libbpf APIs I also
noticed that perf is still using few other deprecated APIs:
  - bpf_map__next;
  - bpf_program__next;
  - bpf_load_program;
  - btf__get_from_id;

It's trivial to fix up, but doing it across few trees will delay
libbpf work as well.

So let's land this through bpf-next, if Arnaldo doesn't mind?

> thanks,
> jirka
