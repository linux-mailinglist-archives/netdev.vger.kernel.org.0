Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8C4953AC81
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 20:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354377AbiFASL1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 14:11:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230345AbiFASL0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 14:11:26 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E58816A076;
        Wed,  1 Jun 2022 11:11:24 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id rq11so5416355ejc.4;
        Wed, 01 Jun 2022 11:11:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vD3acUwrnvCDNzsw6CVDjDJdTYe7I/67xtDcmDRh9WM=;
        b=iAwFOoctnI2pHGQt2d7qlsaLocofuzUJ2It0EaiuRyr2OSU7Oap9cvKDCxz1+lpZ4G
         cajNdAdrsL5uyCiy4yg5u++fz7B/Q8RAYzw69GintttzI7v7YhOsCx/l4ii3SnVLSNj7
         dx8e1UCFXgNTCD0MIOlTvgG/mG+6HCR6M98DysnfXqCnGnvTXVldMuAW8GbV/ZkCpxep
         eTMkMKN5sbgRdBJY6utl3aRLRQXCsL9e76v9YUsqUzWx4vJXT9JkbDyQv1kOEVRqojFl
         L/RKRaOvRhcEu/6+uKKEAXpWjZY+kSCYzymyfz8L9XIFjGZz/ulDS7X9jP2K1XO/QRh1
         IQbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vD3acUwrnvCDNzsw6CVDjDJdTYe7I/67xtDcmDRh9WM=;
        b=wdBwwqlI7NYMU8+A+erRHrSbGhAxRKBhXP2d2JoyRc4KWqUOwGjF5Erq3u/ymDkS35
         XMc+W9ThRM1GZDo/pM6Ej9U01dFsYW/f5dvUD06FJJUPLSuyPYzY+hk+jERqhGdopk4v
         F3If0NA2mT13OkoLV/lHHbd2V61Yv10/Ug4l9XzcwimFfXODvy8ahRL2Hh8uy2zvWqd1
         +CdEa6vFhoRSgQJJ52E8qKyz9E0TdmaBUhnLq22i9dWw2/WAruhhqrtZm9xF8ofM7Yzz
         xlwYcLb6btfye8dx8ilWEJTeokofn8IegKW2Xnwd6M4bQ8K4suo1P2+XTvvGKzKDBh1p
         N8LA==
X-Gm-Message-State: AOAM531432Qsloe51w9O4i/0+jN/J64mC7SWDdlwxJe2TedY7J5uyHac
        cxgFyHxSBPjnukaEnivx040=
X-Google-Smtp-Source: ABdhPJxJPetCioCFfRp6wOhkl6YLSYLtQ7EzBUCTON3lZZC63W+7hHEcENgLz+SFwYCD4t6XWZNB6A==
X-Received: by 2002:a17:907:7f94:b0:708:272:6a99 with SMTP id qk20-20020a1709077f9400b0070802726a99mr672594ejc.537.1654107083476;
        Wed, 01 Jun 2022 11:11:23 -0700 (PDT)
Received: from krava ([193.85.244.190])
        by smtp.gmail.com with ESMTPSA id d22-20020a50fb16000000b0042617ba6389sm1310058edq.19.2022.06.01.11.11.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jun 2022 11:11:22 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Wed, 1 Jun 2022 20:11:21 +0200
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        linux-perf-users@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Ian Rogers <irogers@google.com>
Subject: Re: [PATCHv2 0/3] perf tools: Fix prologue generation
Message-ID: <YperyVk8bTVT+s2U@krava>
References: <20220510074659.2557731-1-jolsa@kernel.org>
 <YpAmW/BDq4346OaI@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YpAmW/BDq4346OaI@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 26, 2022 at 10:16:11PM -0300, Arnaldo Carvalho de Melo wrote:
> Em Tue, May 10, 2022 at 09:46:56AM +0200, Jiri Olsa escreveu:
> > hi,
> > sending change we discussed some time ago [1] to get rid of
> > some deprecated functions we use in perf prologue code.
> > 
> > Despite the gloomy discussion I think the final code does
> > not look that bad ;-)
> > 
> > This patchset removes following libbpf functions from perf:
> >   bpf_program__set_prep
> >   bpf_program__nth_fd
> >   struct bpf_prog_prep_result
> 
> So, the first patch is already in torvalds/master, I tried applying the
> other two patches to my local perf/core, that already is merged with
> torvalds/master and:
> 
> [root@quaco ~]# perf test 42
>  42: BPF filter                                                      :
>  42.1: Basic BPF filtering                                           : FAILED!
>  42.2: BPF pinning                                                   : FAILED!
>  42.3: BPF prologue generation                                       : FAILED!
> [root@quaco ~]#
> 
> I'll push my local perf/core to tmp.perf/core and continue tomorrow.

hi,
I just rebased my changes on top of your perf/core and it seems to work:

	[root@krava perf]# ./perf test bpf
	 40: LLVM search and compile                                         :
	 40.1: Basic BPF llvm compile                                        : Ok
	 40.3: Compile source for BPF prologue generation                    : Ok
	 40.4: Compile source for BPF relocation                             : Ok
	 42: BPF filter                                                      :
	 42.1: Basic BPF filtering                                           : Ok
	 42.2: BPF pinning                                                   : Ok
	 42.3: BPF prologue generation                                       : Ok

is it still a problem?

jirka
