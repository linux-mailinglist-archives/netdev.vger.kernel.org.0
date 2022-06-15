Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCD2B54D1B6
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 21:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349062AbiFOTgi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 15:36:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348813AbiFOTgh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 15:36:37 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39BBD4C43A;
        Wed, 15 Jun 2022 12:36:36 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id c2so17659057edf.5;
        Wed, 15 Jun 2022 12:36:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VvNrl1qIZ7QjwGn1p8grj8G4avQd4JwfaXvIgRnwt/A=;
        b=XdJCz4NqeMUuVACaqDP/ajWeM22aRypRPvgr/IGNfLpAoqEo9zGYhos58kutmuFBEF
         7D6nLPqm7YmnfLuGCPQgbuyW7M7gPTHFVRasbgmGgXu+a3UMPfAYbgsvZLfrg4omeVIM
         kDAjzPCdpotcvfN5cxjN/pMGLm59+YsRknN9B+4ZsGoQ5P6S8EHwWHtsExbf0vQZEaRb
         6TpXp/E7E6KWoyVv53KJ/wkcUWaZ6QP7DkeUIpPdCjWM/pzbycdZu4enfApqQCZ5dpAE
         wMR0ainBo6OeScNSrWFKQGgFBOW4sUP0qeU4WRz1gcY+Ot2U8NgRgqwWTw0QWixRzps7
         NjdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VvNrl1qIZ7QjwGn1p8grj8G4avQd4JwfaXvIgRnwt/A=;
        b=1zMJEcO/pwiGcISjKaDKpxgpjYIvn8G9U/sf5wk2oKoATGaGQf4l0RcxNTlDcEJ8j7
         0yyL9LFewi3urqjynPRLWj42gzhLumoIuFxXp1ZRMHOMXv70mGVYjy9lVWOvw8Ylc45I
         HVeHt+8LWQpD6pnKTQReNKMh/wb0W/KnoTU7JDpntm9xfNKGEarR2B3VjJRwvASvOS5l
         YIJvz2/eLyj+IgfU7PQEEuly9j5ZNL4YvPbm+PFPDRCKO7/WHB40YB2cBvoSLOp4uPF+
         Pbel4vYjSw6Gc/YFh8qp30/yUcr4pm+4VP1LTBB1a/gqKFePWa5Zyg4TujJHISua5q2g
         EUdg==
X-Gm-Message-State: AJIora/S1GGCszy7UigrfHq6ZwG6mRpjAsKgM0psryJmr5508l+bwWDu
        vQsEG23CTFCekINYnpyZVrE=
X-Google-Smtp-Source: AGRyM1tltrcxSMuKIzv3wKCaikT0S09DjDKhN+HJSKQk0rOZ2PGVyPn1e1ertCwAPbokM9ouEAZ3Tw==
X-Received: by 2002:a05:6402:1e8b:b0:41c:59f6:2c26 with SMTP id f11-20020a0564021e8b00b0041c59f62c26mr1754577edf.156.1655321794640;
        Wed, 15 Jun 2022 12:36:34 -0700 (PDT)
Received: from krava ([83.240.63.226])
        by smtp.gmail.com with ESMTPSA id h7-20020a05640250c700b004315f96fd24sm42257edb.31.2022.06.15.12.36.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 12:36:34 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Wed, 15 Jun 2022 21:36:32 +0200
To:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc:     Jiri Olsa <olsajiri@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
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
Subject: Re: [PATCHv4 bpf-next 0/2] perf tools: Fix prologue generation
Message-ID: <Yqo0wMcrUmcZR0f3@krava>
References: <20220603204509.15044-1-jolsa@kernel.org>
 <CAEf4BzbT4Z=B2hZxTQf1MrCp6TGiMgP+_t7p8G5A+RdVyNP+8w@mail.gmail.com>
 <YqOOsL8EbbO3lhmC@kernel.org>
 <CAEf4BzaKP8MHtGZDVSpwbCxNUD4zY9wkjEa4HKR0LWxYKW5cGQ@mail.gmail.com>
 <YqOvYo1tp32gKviM@krava>
 <YqYTZVa44Y6RQ11W@krava>
 <Yqn6R2BA12U6Ftzt@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yqn6R2BA12U6Ftzt@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 15, 2022 at 12:27:03PM -0300, Arnaldo Carvalho de Melo wrote:
> Em Sun, Jun 12, 2022 at 06:25:09PM +0200, Jiri Olsa escreveu:
> > so the problem is that we prepend init proglogue instructions
> > for each program not just for the one that needs it, so it will
> > mismatch later on.. the fix below makes it work for me
> 
> > Arnaldo,
> > I squashed and pushed the change below changes to my bpf/depre
> > branch, could you please retest?
> 
> Before:
> 
> [acme@quaco perf-urgent]$ git log --oneline -5
> e2cf9d315f90670f (HEAD -> perf/urgent, five/perf/urgent) perf test topology: Use !strncmp(right platform) to fix guest PPC comparision check
> 42e4fb08ff987b50 perf test: Record only user callchains on the "Check Arm64 callgraphs are complete in fp mode" test
> 819d5c3cf75d0f95 perf beauty: Update copy of linux/socket.h with the kernel sources
> ebdc02b3ece8238b perf test: Fix variable length array undefined behavior in bp_account
> 8ff58c35adb7f118 libperf evsel: Open shouldn't leak fd on failure
> [acme@quaco perf-urgent]$ sudo su -
> [root@quaco ~]# perf -v
> perf version 5.19.rc2.ge2cf9d315f90
> [root@quaco ~]# perf test bpf
>  40: LLVM search and compile                                         :
>  40.1: Basic BPF llvm compile                                        : Ok
>  40.3: Compile source for BPF prologue generation                    : Ok
>  40.4: Compile source for BPF relocation                             : Ok
>  42: BPF filter                                                      :
>  42.1: Basic BPF filtering                                           : Ok
>  42.2: BPF pinning                                                   : Ok
>  42.3: BPF prologue generation                                       : Ok
>  63: Test libpfm4 support                                            :
>  96: perf stat --bpf-counters test                                   : Ok
> [root@quaco ~]#
> 
> After your first patch:
> 
> [acme@quaco perf-urgent]$ git log --oneline -5 jolsa/bpf/depre
> 9317b879db422632 (jolsa/bpf/depre) perf tools: Rework prologue generation code
> 4d40831f29f2c9ad perf tools: Register fallback libbpf section handler
> f913ad6559e337b4 libbpf: Fix is_pow_of_2
> f175ece2e3436748 selftests/bpf: Fix tc_redirect_dtime
> 7b711e721234f475 bpf, test_run: Remove unnecessary prog type checks
> [acme@quaco perf-urgent]$ git cherry-pick 4d40831f29f2c9ad
> [perf/urgent ab39fb6880b57507] perf tools: Register fallback libbpf section handler
>  Author: Jiri Olsa <jolsa@kernel.org>
>  Date: Thu Apr 21 15:22:25 2022 +0200
>  1 file changed, 65 insertions(+), 11 deletions(-)
> [acme@quaco perf-urgent]$
> [acme@quaco perf-urgent]$ alias m='rm -rf ~/libexec/perf-core/ ; perf stat -e cycles:u,instructions:u make -k BUILD_BPF_SKEL=1 PYTHON=python3 O=/tmp/build/perf-urgent -C tools/perf install-bin && perf test python'
> [acme@quaco perf-urgent]$ rm -rf /tmp/build/perf-urgent ; mkdir -p /tmp/build/perf-urgent ; m
> <SNIP>
>  19: 'import perf' in python                                         : Ok
> [acme@quaco perf-urgent]$
> [acme@quaco perf-urgent]$ sudo su -
> [sudo] password for acme:
> [root@quaco ~]# perf test bpf
>  40: LLVM search and compile                                         :
>  40.1: Basic BPF llvm compile                                        : Ok
>  40.3: Compile source for BPF prologue generation                    : Ok
>  40.4: Compile source for BPF relocation                             : Ok
>  42: BPF filter                                                      :
>  42.1: Basic BPF filtering                                           : Ok
>  42.2: BPF pinning                                                   : Ok
>  42.3: BPF prologue generation                                       : FAILED!
>  63: Test libpfm4 support                                            :
>  96: perf stat --bpf-counters test                                   : Ok
> [root@quaco ~]#
> 
> perf test -v bpf later, lets see if landing the second patch fixes
> things and this bisection problem is justified:
> 
> [acme@quaco perf-urgent]$ git log --oneline -5 jolsa/bpf/depre
> 9317b879db422632 (jolsa/bpf/depre) perf tools: Rework prologue generation code
> 4d40831f29f2c9ad perf tools: Register fallback libbpf section handler
> f913ad6559e337b4 libbpf: Fix is_pow_of_2
> f175ece2e3436748 selftests/bpf: Fix tc_redirect_dtime
> 7b711e721234f475 bpf, test_run: Remove unnecessary prog type checks
> [acme@quaco perf-urgent]$ git remote update jolsa
> Fetching jolsa
> [acme@quaco perf-urgent]$ git cherry-pick 9317b879db422632
> [perf/urgent 9a36c7c94e1f596d] perf tools: Rework prologue generation code
>  Author: Jiri Olsa <jolsa@kernel.org>
>  Date: Mon May 9 22:46:20 2022 +0200
>  1 file changed, 110 insertions(+), 18 deletions(-)
> [acme@quaco perf-urgent]$
> [acme@quaco perf-urgent]$ rm -rf /tmp/build/perf-urgent ; mkdir -p /tmp/build/perf-urgent ; m
> <SNIP>
>  19: 'import perf' in python                                         : Ok
> [acme@quaco perf-urgent]$ sudo su -
> [root@quaco ~]# perf test bpf
>  40: LLVM search and compile                                         :
>  40.1: Basic BPF llvm compile                                        : Ok
>  40.3: Compile source for BPF prologue generation                    : Ok
>  40.4: Compile source for BPF relocation                             : Ok
>  42: BPF filter                                                      :
>  42.1: Basic BPF filtering                                           : Ok
>  42.2: BPF pinning                                                   : Ok
>  42.3: BPF prologue generation                                       : Ok
>  63: Test libpfm4 support                                            :
>  96: perf stat --bpf-counters test                                   : Ok
> [root@quaco ~]#
> 
> So it works in the end, can it be made to work after the first step? I
> didn't check that.

heya,
so the first patch is preparation and the last one is the real fix

at the moment it does not work without this change, so I don't
think it's a problem for the bisect, is it?

jirka
