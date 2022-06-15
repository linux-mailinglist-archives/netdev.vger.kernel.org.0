Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 823C054D447
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 00:12:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345411AbiFOWMY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 18:12:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244186AbiFOWMW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 18:12:22 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8900562D1;
        Wed, 15 Jun 2022 15:12:21 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id y19so25865494ejq.6;
        Wed, 15 Jun 2022 15:12:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4xTyERPA39iUjeUW7Z+SYRw6OKvwLTV66kGbsFvVjDQ=;
        b=HO6+SKTn9pBKukQkKcHQ22SzvyF0ZCBxBF2AxICtJmOAdMgSoE3wnsHKYyewxOQ3G+
         AuJSHEaCOFlnY0Uflos0UeQLMlsKm2G7/k+ZoOb9/dsdpbR5ikV7ttscmLTN23CNw+xh
         b5pZ6sojdZncuUTKkqMY4y6HVEwak8+lbQdNvaP2Q2NH0pYdyELmtkxRIoBu1EOrafd0
         b44gKnq0/pdo8cxzRq4kfEIhIttF9IYdZbqbL6/jh5ZoXTEtueAMB5ux0n1iqI2BSK1X
         viT8CX/3UbrUFSELtp7vuxkefDzz8lNl81KHEqpWEYHoyUpz/tvn0IFcojs5KxTvTDlf
         CyOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4xTyERPA39iUjeUW7Z+SYRw6OKvwLTV66kGbsFvVjDQ=;
        b=28THMqfP/A9fr1j2rg4MF0QdNw+RJBJ578tQgcZwWUUDHm4raE3tP3SwXAUbLmA0Ji
         4XzA2XJcgebZhQciQckosNxHTKY1QLiP8FdTddAzUJy2EAAvbK4WMkYtunKVkZEwZZB2
         e75r6bfNAgkoNXiIFc54cJD8Tm0czigTFyk3pNSnd7CanSVf+uVKmdZ+3U5alkUctFeu
         bNSOe5PzGUuCXhekgO9DTTmT9+vKsgei4b6KoWBwW/S8Y6Hoth+bmpzeuP9OJl10O56X
         W9vpBRqFFdQrwiPfcVJsLy97P9dYnoTzL1YHY/b+/ExE7D+LE0oV1PNcQgG16L3TN8oq
         41ug==
X-Gm-Message-State: AJIora9IZJIa9kxl5lFHYSJOyib2x/LUCQRrWDP7au+EkEW3w9z6rqoB
        /lpMHhrrr+fPsyGYk4O4lGQ=
X-Google-Smtp-Source: AGRyM1vYuj8eZbo1R67Y5m7pYOJ+FGYBcwDnaUCfZ6kd5zdHIvc3rqLiJ0tboxgtfn8joRK46EZNAg==
X-Received: by 2002:a17:906:2b8e:b0:718:cd1e:88cf with SMTP id m14-20020a1709062b8e00b00718cd1e88cfmr1837091ejg.11.1655331140094;
        Wed, 15 Jun 2022 15:12:20 -0700 (PDT)
Received: from krava ([83.240.63.226])
        by smtp.gmail.com with ESMTPSA id ee15-20020a056402290f00b0042dd3bf1403sm288778edb.54.2022.06.15.15.12.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 15:12:19 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Thu, 16 Jun 2022 00:12:10 +0200
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
Message-ID: <YqpZOtkwxB28UbRU@krava>
References: <20220603204509.15044-1-jolsa@kernel.org>
 <CAEf4BzbT4Z=B2hZxTQf1MrCp6TGiMgP+_t7p8G5A+RdVyNP+8w@mail.gmail.com>
 <YqOOsL8EbbO3lhmC@kernel.org>
 <CAEf4BzaKP8MHtGZDVSpwbCxNUD4zY9wkjEa4HKR0LWxYKW5cGQ@mail.gmail.com>
 <YqOvYo1tp32gKviM@krava>
 <YqYTZVa44Y6RQ11W@krava>
 <Yqn6R2BA12U6Ftzt@kernel.org>
 <Yqo0wMcrUmcZR0f3@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yqo0wMcrUmcZR0f3@krava>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 15, 2022 at 09:36:34PM +0200, Jiri Olsa wrote:
> On Wed, Jun 15, 2022 at 12:27:03PM -0300, Arnaldo Carvalho de Melo wrote:
> > Em Sun, Jun 12, 2022 at 06:25:09PM +0200, Jiri Olsa escreveu:
> > > so the problem is that we prepend init proglogue instructions
> > > for each program not just for the one that needs it, so it will
> > > mismatch later on.. the fix below makes it work for me
> > 
> > > Arnaldo,
> > > I squashed and pushed the change below changes to my bpf/depre
> > > branch, could you please retest?
> > 
> > Before:
> > 
> > [acme@quaco perf-urgent]$ git log --oneline -5
> > e2cf9d315f90670f (HEAD -> perf/urgent, five/perf/urgent) perf test topology: Use !strncmp(right platform) to fix guest PPC comparision check
> > 42e4fb08ff987b50 perf test: Record only user callchains on the "Check Arm64 callgraphs are complete in fp mode" test
> > 819d5c3cf75d0f95 perf beauty: Update copy of linux/socket.h with the kernel sources
> > ebdc02b3ece8238b perf test: Fix variable length array undefined behavior in bp_account
> > 8ff58c35adb7f118 libperf evsel: Open shouldn't leak fd on failure
> > [acme@quaco perf-urgent]$ sudo su -
> > [root@quaco ~]# perf -v
> > perf version 5.19.rc2.ge2cf9d315f90
> > [root@quaco ~]# perf test bpf
> >  40: LLVM search and compile                                         :
> >  40.1: Basic BPF llvm compile                                        : Ok
> >  40.3: Compile source for BPF prologue generation                    : Ok
> >  40.4: Compile source for BPF relocation                             : Ok
> >  42: BPF filter                                                      :
> >  42.1: Basic BPF filtering                                           : Ok
> >  42.2: BPF pinning                                                   : Ok
> >  42.3: BPF prologue generation                                       : Ok
> >  63: Test libpfm4 support                                            :
> >  96: perf stat --bpf-counters test                                   : Ok
> > [root@quaco ~]#
> > 
> > After your first patch:
> > 
> > [acme@quaco perf-urgent]$ git log --oneline -5 jolsa/bpf/depre
> > 9317b879db422632 (jolsa/bpf/depre) perf tools: Rework prologue generation code
> > 4d40831f29f2c9ad perf tools: Register fallback libbpf section handler
> > f913ad6559e337b4 libbpf: Fix is_pow_of_2
> > f175ece2e3436748 selftests/bpf: Fix tc_redirect_dtime
> > 7b711e721234f475 bpf, test_run: Remove unnecessary prog type checks
> > [acme@quaco perf-urgent]$ git cherry-pick 4d40831f29f2c9ad
> > [perf/urgent ab39fb6880b57507] perf tools: Register fallback libbpf section handler
> >  Author: Jiri Olsa <jolsa@kernel.org>
> >  Date: Thu Apr 21 15:22:25 2022 +0200
> >  1 file changed, 65 insertions(+), 11 deletions(-)
> > [acme@quaco perf-urgent]$
> > [acme@quaco perf-urgent]$ alias m='rm -rf ~/libexec/perf-core/ ; perf stat -e cycles:u,instructions:u make -k BUILD_BPF_SKEL=1 PYTHON=python3 O=/tmp/build/perf-urgent -C tools/perf install-bin && perf test python'
> > [acme@quaco perf-urgent]$ rm -rf /tmp/build/perf-urgent ; mkdir -p /tmp/build/perf-urgent ; m
> > <SNIP>
> >  19: 'import perf' in python                                         : Ok
> > [acme@quaco perf-urgent]$
> > [acme@quaco perf-urgent]$ sudo su -
> > [sudo] password for acme:
> > [root@quaco ~]# perf test bpf
> >  40: LLVM search and compile                                         :
> >  40.1: Basic BPF llvm compile                                        : Ok
> >  40.3: Compile source for BPF prologue generation                    : Ok
> >  40.4: Compile source for BPF relocation                             : Ok
> >  42: BPF filter                                                      :
> >  42.1: Basic BPF filtering                                           : Ok
> >  42.2: BPF pinning                                                   : Ok
> >  42.3: BPF prologue generation                                       : FAILED!
> >  63: Test libpfm4 support                                            :
> >  96: perf stat --bpf-counters test                                   : Ok
> > [root@quaco ~]#
> > 
> > perf test -v bpf later, lets see if landing the second patch fixes
> > things and this bisection problem is justified:
> > 
> > [acme@quaco perf-urgent]$ git log --oneline -5 jolsa/bpf/depre
> > 9317b879db422632 (jolsa/bpf/depre) perf tools: Rework prologue generation code
> > 4d40831f29f2c9ad perf tools: Register fallback libbpf section handler
> > f913ad6559e337b4 libbpf: Fix is_pow_of_2
> > f175ece2e3436748 selftests/bpf: Fix tc_redirect_dtime
> > 7b711e721234f475 bpf, test_run: Remove unnecessary prog type checks
> > [acme@quaco perf-urgent]$ git remote update jolsa
> > Fetching jolsa
> > [acme@quaco perf-urgent]$ git cherry-pick 9317b879db422632
> > [perf/urgent 9a36c7c94e1f596d] perf tools: Rework prologue generation code
> >  Author: Jiri Olsa <jolsa@kernel.org>
> >  Date: Mon May 9 22:46:20 2022 +0200
> >  1 file changed, 110 insertions(+), 18 deletions(-)
> > [acme@quaco perf-urgent]$
> > [acme@quaco perf-urgent]$ rm -rf /tmp/build/perf-urgent ; mkdir -p /tmp/build/perf-urgent ; m
> > <SNIP>
> >  19: 'import perf' in python                                         : Ok
> > [acme@quaco perf-urgent]$ sudo su -
> > [root@quaco ~]# perf test bpf
> >  40: LLVM search and compile                                         :
> >  40.1: Basic BPF llvm compile                                        : Ok
> >  40.3: Compile source for BPF prologue generation                    : Ok
> >  40.4: Compile source for BPF relocation                             : Ok
> >  42: BPF filter                                                      :
> >  42.1: Basic BPF filtering                                           : Ok
> >  42.2: BPF pinning                                                   : Ok
> >  42.3: BPF prologue generation                                       : Ok
> >  63: Test libpfm4 support                                            :
> >  96: perf stat --bpf-counters test                                   : Ok
> > [root@quaco ~]#
> > 
> > So it works in the end, can it be made to work after the first step? I
> > didn't check that.
> 
> heya,
> so the first patch is preparation and the last one is the real fix
> 
> at the moment it does not work without this change, so I don't
> think it's a problem for the bisect, is it?

ah I just checked that thing worked before :)) ok.. I think the only
way here is to squash them together.. doesn't look that bad

jirka
