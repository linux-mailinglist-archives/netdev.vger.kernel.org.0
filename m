Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A74BD52ADCA
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 00:03:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbiEQWDJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 18:03:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229805AbiEQWDG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 18:03:06 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A5C749F29;
        Tue, 17 May 2022 15:03:05 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id e3so316646ios.6;
        Tue, 17 May 2022 15:03:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XaC+lg6kNQzOzaKvEQSXtHYYtU/iVFLlFJMpbBidkyY=;
        b=U8SshjRqyuJ0JDF7+pse2WF/4zZzkDbrUbLXQDjLV3woV7Yj/FO1pn84lB2hKYA6Lt
         QmkagHD9wQtPXp/UzV656XNbhU69Yb5ErY6dff/okGI887Cxd5igB1pYkrSDArmAb8ck
         u2blXKRMqoPX/6Utx7yconobN8YW2pBfCkHcX+CjOr8j0CSVMR1WpBdvNA54fi84pFY8
         N62xoyKcNj6zLjPQMIsuUcjyauP6zZEUzVT9GOG6r+oFn8cBsavlrx+ERy0INKOVUSI1
         YCYQsE46WvYCqNmTHjPZK1xsJlpu9ruP980xc2uf7Jqp9Vubrcs9/nemqaa58DqXXA6u
         8+mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XaC+lg6kNQzOzaKvEQSXtHYYtU/iVFLlFJMpbBidkyY=;
        b=tXu1yCZvp/VCfsSz6j38YhiWW7QmSjQMs6rj2yl4JSNL4ACI4y7t9Sj1fhrV9ofS7A
         CC4q80y7iud/ZZHkwepCPZoZK+nAv5kDhQNv8wT/hbRzUt9DoDf/3F1WaliGMPCSeNud
         AFpzuy7dVxxyayorNOtbsZ0ppUYyaEGi59q5Yx+jUqAN0Hrv1kl+XF2OJRe2KEkps6km
         orWYIdpKaEJotlhX5TvBE7Q4OY8WeBo5tI2PHhWD++U2iDKIQHXoJupsYJusWlI5CPNx
         BP7fiQFPwZhe0IAwyUqKoSWCTkFsSNkwExuQW8MR2fyi2nkkku6o82r8s5xFBBcspFf2
         TOOQ==
X-Gm-Message-State: AOAM532IslX6Z6g9rBdUm9rRx1dEezmGTYOFeHMArfQQIesi+tsNNeqw
        H0iCQjac9W3anXlfOSy++T69RRZdrMyFfO/CB/m04ZJG
X-Google-Smtp-Source: ABdhPJz93sSJZvqwk5VRamRjZVgYfX4V2m91cPHae8WLkjVHmh+raHAi608yU8TchEaHxDgQgsnXz4kp8F4oYj8XT7s=
X-Received: by 2002:a02:9f87:0:b0:32e:69ae:23df with SMTP id
 a7-20020a029f87000000b0032e69ae23dfmr489970jam.237.1652824984799; Tue, 17 May
 2022 15:03:04 -0700 (PDT)
MIME-Version: 1.0
References: <20220510074659.2557731-1-jolsa@kernel.org> <CAEf4BzbK9zgetgE1yKkCANTZqizUrXgamJa2X0f0XmzQUdFrCQ@mail.gmail.com>
 <YntnRixbfQ1HCm9T@krava> <Ynv+7iaaAbyM38B6@kernel.org>
In-Reply-To: <Ynv+7iaaAbyM38B6@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 17 May 2022 15:02:53 -0700
Message-ID: <CAEf4BzaQsF31f3WuU32wDCzo6bw7eY8E9zF6Lo218jfw-VQmcA@mail.gmail.com>
Subject: Re: [PATCHv2 0/3] perf tools: Fix prologue generation
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Jiri Olsa <olsajiri@gmail.com>, Jiri Olsa <jolsa@kernel.org>,
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

On Wed, May 11, 2022 at 11:22 AM Arnaldo Carvalho de Melo
<acme@kernel.org> wrote:
>
> Em Wed, May 11, 2022 at 09:35:34AM +0200, Jiri Olsa escreveu:
> > On Tue, May 10, 2022 at 04:48:55PM -0700, Andrii Nakryiko wrote:
> > > On Tue, May 10, 2022 at 12:47 AM Jiri Olsa <jolsa@kernel.org> wrote:
> > > >
> > > > hi,
> > > > sending change we discussed some time ago [1] to get rid of
> > > > some deprecated functions we use in perf prologue code.
> > > >
> > > > Despite the gloomy discussion I think the final code does
> > > > not look that bad ;-)
> > > >
> > > > This patchset removes following libbpf functions from perf:
> > > >   bpf_program__set_prep
> > > >   bpf_program__nth_fd
> > > >   struct bpf_prog_prep_result
> > > >
> > > > v2 changes:
> > > >   - use fallback section prog handler, so we don't need to
> > > >     use section prefix [Andrii]
> > > >   - realloc prog->insns array in bpf_program__set_insns [Andrii]
> > > >   - squash patch 1 from previous version with
> > > >     bpf_program__set_insns change [Daniel]
> > > >   - patch 3 already merged [Arnaldo]
> > > >   - added more comments
> > > >
> > > >   meanwhile.. perf/core and bpf-next diverged, so:
> > > >     - libbpf bpf_program__set_insns change is based on bpf-next/master
> > > >     - perf changes do not apply on bpf-next/master so they are based on
> > > >       perf/core ... however they can be merged only after we release
> > > >       libbpf 0.8.0 with bpf_program__set_insns change, so we don't break
> > > >       the dynamic linking
> > > >       I'm sending perf changes now just for review, I'll resend them
> > > >       once libbpf 0.8.0 is released
> > > >
> > > > thanks,
> > > > jirka
> > > >
> > > >
> > > > [1] https://lore.kernel.org/bpf/CAEf4BzaiBO3_617kkXZdYJ8hS8YF--ZLgapNbgeeEJ-pY0H88g@mail.gmail.com/
> > > > ---
> > > > Jiri Olsa (1):
> > > >       libbpf: Add bpf_program__set_insns function
> > > >
> > >
> > > The first patch looks good to me. The rest I can't really review and
> > > test properly, so I'll leave it up to Arnaldo.
> > >
> > > Arnaldo, how do we coordinate these patches? Should they go through
> > > bpf-next (after you Ack them) or you want them in your tree?
> > >
> > > I'd like to get the bpf_program__set_insns() patch into bpf-next so
> > > that I can do libbpf v0.8 release, having it in a separate tree is
> > > extremely inconvenient. Please let me know how you think we should
> > > proceed?
> >
> > we need to wait with perf changes after the libbpf is merged and
> > libbpf 0.8.0 is released.. so we don't break dynamic linking for
> > perf
> >
> > at the moment please just take libbpf change and I'll resend the
> > perf change later if needed
>
> Ok.
>

Jiri, libbpf v0.8 is out, can you please re-send your perf patches?


> - Arnaldo
