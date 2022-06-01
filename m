Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D547053AC7B
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 20:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354371AbiFASJr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 14:09:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230345AbiFASJp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 14:09:45 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6EB46A076;
        Wed,  1 Jun 2022 11:09:44 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id h19so3324534edj.0;
        Wed, 01 Jun 2022 11:09:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qJkyUXY8x9EIR3mTw1Vm7BUt+f3Dj3q32F+KNT2VkuQ=;
        b=QCUtR3vQbTjYmM7uZ5JIWeJAg0M1EQvQkVQJoxYD6iWWtsycG6w+QCruDWZ7v1viRR
         tZld0a3KhdyH5dHGZA6u0/RlAwhoLWTuv5IT9LuhU+VRILElDGP+lQFDcEt709EQZ9Cq
         CPkWv4e3PDr0A/60PYROzhp97gy7oZPzjgG4O16rtPl1nBAY6Y8hgcIi5io7m7hEoecB
         DrGIoEDw+H9+9ctzIBno+LK8ehjw5ddN6Xv7noN3Jwjh4pYF0lzc8O/twmmdwsEnDP0D
         39pjSs2Ntu+IPV4lE+nMG/V39KOrYHf2eQFdI3QVExwOdhgEpOTUlpi24EedmcP/ItAZ
         t/KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qJkyUXY8x9EIR3mTw1Vm7BUt+f3Dj3q32F+KNT2VkuQ=;
        b=cGzG+H+cWb1hyAVRw7vuHvsJXwgGeKt5P77ctALcqAPIj6YXDHotW5TEVE50bPcX1p
         M1iFYzVB4rj3tdYtqndZZ67K6SkrNnG/RmbV56Ul7yjLGbUz3vQseAXqnXwkaIgnoCEB
         zY/rF9qwK9tLQh4m6J9OcNjeYdyDaLqoT4S0d67q7TOWoTXTz1Mcd7WfunJdAzLiyKho
         Afyg91LJwjXPE8rPQZE1w8sLdgM0ScV6z9YlW4xoRq9pI6Wn7pMUjw9JZPIbaUZPLe/B
         IFTNBZfU7f8bIewP8JazW9t3unzy/1nlS1ALX6T/nnra/qYa7Npxf90ooJgwJt9mxbvH
         vcfA==
X-Gm-Message-State: AOAM533n7EEeZW7XliMimlsCu4/W6L5P0LRdaSaubM5Uxba3vqHUrakK
        KzBXP4QoFDFoW3RL4BlNq3I=
X-Google-Smtp-Source: ABdhPJyZJd4aR0TcVeVo+RIf7YtPAvMsp+WjGLp9Hy1FQXnNDG2u5Y9OBxmSMesWWJKcj2KaekeoxQ==
X-Received: by 2002:a05:6402:2999:b0:428:bb4d:6cea with SMTP id eq25-20020a056402299900b00428bb4d6ceamr1054625edb.29.1654106983174;
        Wed, 01 Jun 2022 11:09:43 -0700 (PDT)
Received: from krava ([193.85.244.190])
        by smtp.gmail.com with ESMTPSA id g8-20020a056402114800b0042dd109b212sm1327662edw.3.2022.06.01.11.09.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jun 2022 11:09:42 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Wed, 1 Jun 2022 20:09:40 +0200
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <olsajiri@gmail.com>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
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
Message-ID: <YperTPAIgqdPs01R@krava>
References: <Ynv+7iaaAbyM38B6@kernel.org>
 <CAEf4BzaQsF31f3WuU32wDCzo6bw7eY8E9zF6Lo218jfw-VQmcA@mail.gmail.com>
 <YoTAhC+6j4JshqN8@krava>
 <YoYj6cb0aPNN/olH@krava>
 <CAEf4Bzaa60kZJbWT0xAqcDMyXBzbg98ShuizJAv7x+8_3X0ZBg@mail.gmail.com>
 <Yokk5XRxBd72fqoW@kernel.org>
 <Yos8hq3NmBwemoJw@krava>
 <CAEf4BzYRJj8sXjYs2ioz6Qq7L2UshZDi4Kt0XLsLtwQSGCpAzg@mail.gmail.com>
 <YoyXRij2LaxxTicC@krava>
 <CAEf4Bzbxo7_dbBzjeBu8FeB6MFBpgqn1Cwq_om-mGuz-gJH6CA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bzbxo7_dbBzjeBu8FeB6MFBpgqn1Cwq_om-mGuz-gJH6CA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 01, 2022 at 10:39:08AM -0700, Andrii Nakryiko wrote:
> On Tue, May 24, 2022 at 1:28 AM Jiri Olsa <olsajiri@gmail.com> wrote:
> >
> > On Mon, May 23, 2022 at 03:43:10PM -0700, Andrii Nakryiko wrote:
> > > On Mon, May 23, 2022 at 12:49 AM Jiri Olsa <olsajiri@gmail.com> wrote:
> > > >
> > > > On Sat, May 21, 2022 at 02:44:05PM -0300, Arnaldo Carvalho de Melo wrote:
> > > > > Em Fri, May 20, 2022 at 02:46:49PM -0700, Andrii Nakryiko escreveu:
> > > > > > On Thu, May 19, 2022 at 4:03 AM Jiri Olsa <olsajiri@gmail.com> wrote:
> > > > > > > On Wed, May 18, 2022 at 11:46:44AM +0200, Jiri Olsa wrote:
> > > > > > > > On Tue, May 17, 2022 at 03:02:53PM -0700, Andrii Nakryiko wrote:
> > > > > > > > > Jiri, libbpf v0.8 is out, can you please re-send your perf patches?
> > > > >
> > > > > > > > yep, just made new fedora package.. will resend the perf changes soon
> > > > >
> > > > > > > fedora package is on the way, but I'll need perf/core to merge
> > > > > > > the bpf_program__set_insns change.. Arnaldo, any idea when this
> > > > > > > could happen?
> > > > >
> > > > > > Can we land these patches through bpf-next to avoid such complicated
> > > > > > cross-tree dependencies? As I started removing libbpf APIs I also
> > > > > > noticed that perf is still using few other deprecated APIs:
> > > > > >   - bpf_map__next;
> > > > > >   - bpf_program__next;
> > > > > >   - bpf_load_program;
> > > > > >   - btf__get_from_id;
> > > >
> > > > these were added just to bypass the time window when they were not
> > > > available in the package, so can be removed now (in the patch below)
> > > >
> > > > >
> > > > > > It's trivial to fix up, but doing it across few trees will delay
> > > > > > libbpf work as well.
> > > > >
> > > > > > So let's land this through bpf-next, if Arnaldo doesn't mind?
> > > > >
> > > > > Yeah, that should be ok, the only consideration is that I'm submitting
> > > > > this today to Linus:
> > > > >
> > > > > https://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git/commit/?h=tmp.perf/urgent&id=0ae065a5d265bc5ada13e350015458e0c5e5c351
> > > > >
> > > > > To address this:
> > > > >
> > > > > https://lore.kernel.org/linux-perf-users/f0add43b-3de5-20c5-22c4-70aff4af959f@scylladb.com/
> > > >
> > > > ok, we can do that via bpf-next, but of course there's a problem ;-)
> > > >
> > > > perf/core already has dependency commit [1]
> > > >
> > > > so either we wait for perf/core and bpf-next/master to sync or:
> > > >
> > > >   - perf/core reverts [1] and
> > > >   - bpf-next/master takes [1] and the rest
> > > >
> > > > I have the changes ready if you guys are ok with that
> > >
> > > So, if I understand correctly, with merge window open bpf-next/master
> > > will get code from perf/core soon when we merge tip back in. So we can
> > > wait for that to happen and not revert anything.
> > >
> > > So please add the below patch to your series and resend once tip is
> > > merged into bpf-next? Thanks!
> >
> > ok
> 
> Hm.. Ok, so I don't see your patches in tip yet. I see them in
> perf/core only. Which means things won't happen naturally soon. How
> should we proceed? I'm sitting on a pile of patches removing a lot of
> code from libbpf and I'd rather get it out soon, but I can't because
> of them breaking perf in bpf-next without Jiri's changes.

sorry it's merged in linus master, Arnaldo no longer goes through tip tree

> 
> Arnaldo, what's your suggestion? Can we land remaining Jiri's patches
> into perf/core and then you can create a tag for us to merge into
> bpf-next, so that we avoid any conflicts later? Would that work? I
> think we did something like that with other trees (e.g., RCU), when we
> had dependencies like this before.

either way is fine for me.. I just rebased those changes on top of perf/core

jirka
