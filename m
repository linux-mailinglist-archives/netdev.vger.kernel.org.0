Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23599523C67
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 20:22:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346202AbiEKSWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 14:22:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346198AbiEKSWo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 14:22:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83CE2166475;
        Wed, 11 May 2022 11:22:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 17577B825E9;
        Wed, 11 May 2022 18:22:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8235FC340EE;
        Wed, 11 May 2022 18:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652293360;
        bh=xTkJ7hCldhqfQm7/paFj5vKnMjCleEcRs+asiWSm+T0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=u4c2lZE0GGyxKdOs+mCCjcLY3HibLrQzdFO+bmtL7XnBggFtrDiBtup6R7fxe9dxT
         1rdX6cnFRJx4aLhybBk9e2PgQbuD8xI5hUz4ehupQzsAjF7F93kD4cIWciyOQqJ8pF
         WSawUtJi6rLL/eY69RQ0yKoDnRwb/W2uNb/EmfdooJjNW67jjmhrhwuJFYezQovfdp
         99RMxjD/aOgO8Bi2D3K8smUKAaDkdiyko4blIpV+Kc23Tw2mTKC1eZarHmH/c6gwGt
         PlKbs6gVcimaPpVPXvfuL78EhjDhhaBborMmSb6hW71qh2zah4gRO8Q4DOS9lkrKyS
         ZXwOvYbl6ONmA==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 42EC1400B1; Wed, 11 May 2022 15:22:38 -0300 (-03)
Date:   Wed, 11 May 2022 15:22:38 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Jiri Olsa <olsajiri@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
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
Subject: Re: [PATCHv2 0/3] perf tools: Fix prologue generation
Message-ID: <Ynv+7iaaAbyM38B6@kernel.org>
References: <20220510074659.2557731-1-jolsa@kernel.org>
 <CAEf4BzbK9zgetgE1yKkCANTZqizUrXgamJa2X0f0XmzQUdFrCQ@mail.gmail.com>
 <YntnRixbfQ1HCm9T@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YntnRixbfQ1HCm9T@krava>
X-Url:  http://acmel.wordpress.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Wed, May 11, 2022 at 09:35:34AM +0200, Jiri Olsa escreveu:
> On Tue, May 10, 2022 at 04:48:55PM -0700, Andrii Nakryiko wrote:
> > On Tue, May 10, 2022 at 12:47 AM Jiri Olsa <jolsa@kernel.org> wrote:
> > >
> > > hi,
> > > sending change we discussed some time ago [1] to get rid of
> > > some deprecated functions we use in perf prologue code.
> > >
> > > Despite the gloomy discussion I think the final code does
> > > not look that bad ;-)
> > >
> > > This patchset removes following libbpf functions from perf:
> > >   bpf_program__set_prep
> > >   bpf_program__nth_fd
> > >   struct bpf_prog_prep_result
> > >
> > > v2 changes:
> > >   - use fallback section prog handler, so we don't need to
> > >     use section prefix [Andrii]
> > >   - realloc prog->insns array in bpf_program__set_insns [Andrii]
> > >   - squash patch 1 from previous version with
> > >     bpf_program__set_insns change [Daniel]
> > >   - patch 3 already merged [Arnaldo]
> > >   - added more comments
> > >
> > >   meanwhile.. perf/core and bpf-next diverged, so:
> > >     - libbpf bpf_program__set_insns change is based on bpf-next/master
> > >     - perf changes do not apply on bpf-next/master so they are based on
> > >       perf/core ... however they can be merged only after we release
> > >       libbpf 0.8.0 with bpf_program__set_insns change, so we don't break
> > >       the dynamic linking
> > >       I'm sending perf changes now just for review, I'll resend them
> > >       once libbpf 0.8.0 is released
> > >
> > > thanks,
> > > jirka
> > >
> > >
> > > [1] https://lore.kernel.org/bpf/CAEf4BzaiBO3_617kkXZdYJ8hS8YF--ZLgapNbgeeEJ-pY0H88g@mail.gmail.com/
> > > ---
> > > Jiri Olsa (1):
> > >       libbpf: Add bpf_program__set_insns function
> > >
> > 
> > The first patch looks good to me. The rest I can't really review and
> > test properly, so I'll leave it up to Arnaldo.
> > 
> > Arnaldo, how do we coordinate these patches? Should they go through
> > bpf-next (after you Ack them) or you want them in your tree?
> > 
> > I'd like to get the bpf_program__set_insns() patch into bpf-next so
> > that I can do libbpf v0.8 release, having it in a separate tree is
> > extremely inconvenient. Please let me know how you think we should
> > proceed?
> 
> we need to wait with perf changes after the libbpf is merged and
> libbpf 0.8.0 is released.. so we don't break dynamic linking for
> perf
> 
> at the moment please just take libbpf change and I'll resend the
> perf change later if needed

Ok.

- Arnaldo
