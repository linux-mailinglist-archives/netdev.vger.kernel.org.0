Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 581C153AF0E
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 00:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232238AbiFAWVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 18:21:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232229AbiFAWVV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 18:21:21 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7B8B219B;
        Wed,  1 Jun 2022 15:21:19 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id j10so4946237lfe.12;
        Wed, 01 Jun 2022 15:21:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=njJsicR1yE+/aibL6omJMNQApdZ8bBro7j/h/gtmdp0=;
        b=YVtbLZFM+TJ/eDlZLyyZlPjM5j7ZlRzx9x5IVWtr5562rabm/6/ALJGNytNX/T0o5G
         YPiP6S2w66M16QECfhpMOA06nlcbuQKp1vdrHCbfFg7BoRZcez2KmLHQGSoqQC+DLPN+
         1cg6L0ugM4VAd5jWQDQIa3PLs0alDpQjJCO+JgiSAXYROnAwYV7OljqWP3OQ5dVTph97
         iI0QfmwNLrpeI/Ln1bFkfxchhwEorbef64cVMQ/bmZbGvgMOP8CwNYCnts9DPH2nmofM
         NLBS6w3o+CKV+YAImtZqVRne2rZ/9Kly/o/6GT3G7GzxNRGFydnaZgys0liMVdXlyydf
         rPlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=njJsicR1yE+/aibL6omJMNQApdZ8bBro7j/h/gtmdp0=;
        b=7vjhlDr+7kN4+hnhgEbaS8MgF+Xy6J0x3FA0E1yiUT/abGzHgKE36sZQ2WoStUDIlG
         2SJ1D12uVqrrKKPBW0QPyTRQnXOwilqd4ubYdeYr4BgiaTpixaDFrIauouEtliCa6m85
         AgPw4XULvBe9RSd0Og9/W/zCRElGt7Iq8EZO9jJ+FVVtN4PZjQeioUwkRUM5JXsTDiHj
         qdZJk/l8KRrNtHSbWdAOrHSwiqnwWT1cyKiQnzO9nTb2ixFlL4oIDxrt9cc29TLNvREv
         VItEz064XYIts2yz+U1fKSbco4b/F9mrBhRh2efQ1M6FC97Qm+kybj6/lv3h9fXlw0TS
         HqiA==
X-Gm-Message-State: AOAM5338DDJmMiPKI7UHwZVOD3jEpWPMilSF9Y/totWGpRpqjRNevumx
        zzZjMeiKm0Fx7pWgw+jlftbMPNYUbHnw2pYdDmo=
X-Google-Smtp-Source: ABdhPJyNCbpCCL6hkAZ4a+6ambKozrTo7gYQF3w3vzgixykHltcMhFSvFT1tISB6xZXeWrkNXs4WsidugAoxKCFEmF8=
X-Received: by 2002:a05:6512:2625:b0:478:5a51:7fe3 with SMTP id
 bt37-20020a056512262500b004785a517fe3mr1126311lfb.158.1654122078170; Wed, 01
 Jun 2022 15:21:18 -0700 (PDT)
MIME-Version: 1.0
References: <20220510074659.2557731-1-jolsa@kernel.org> <YpAmW/BDq4346OaI@kernel.org>
 <YperyVk8bTVT+s2U@krava>
In-Reply-To: <YperyVk8bTVT+s2U@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 1 Jun 2022 15:21:06 -0700
Message-ID: <CAEf4BzZrd4mXtGXmiH3VCCYtQacG1n9+3eJbtdAZJi5SW_Mj6A@mail.gmail.com>
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
        Ian Rogers <irogers@google.com>,
        Jakub Kicinski <kuba@kernel.org>
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

On Wed, Jun 1, 2022 at 11:11 AM Jiri Olsa <olsajiri@gmail.com> wrote:
>
> On Thu, May 26, 2022 at 10:16:11PM -0300, Arnaldo Carvalho de Melo wrote:
> > Em Tue, May 10, 2022 at 09:46:56AM +0200, Jiri Olsa escreveu:
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
> >
> > So, the first patch is already in torvalds/master, I tried applying the
> > other two patches to my local perf/core, that already is merged with
> > torvalds/master and:
> >
> > [root@quaco ~]# perf test 42
> >  42: BPF filter                                                      :
> >  42.1: Basic BPF filtering                                           : FAILED!
> >  42.2: BPF pinning                                                   : FAILED!
> >  42.3: BPF prologue generation                                       : FAILED!
> > [root@quaco ~]#
> >
> > I'll push my local perf/core to tmp.perf/core and continue tomorrow.
>
> hi,
> I just rebased my changes on top of your perf/core and it seems to work:
>
>         [root@krava perf]# ./perf test bpf
>          40: LLVM search and compile                                         :
>          40.1: Basic BPF llvm compile                                        : Ok
>          40.3: Compile source for BPF prologue generation                    : Ok
>          40.4: Compile source for BPF relocation                             : Ok
>          42: BPF filter                                                      :
>          42.1: Basic BPF filtering                                           : Ok
>          42.2: BPF pinning                                                   : Ok
>          42.3: BPF prologue generation                                       : Ok
>
> is it still a problem?
>

Ok, so I checked with Jakub, net-next will be forwarded to
linus/master tomorrow or so, so after that bpf-next will get forwarded
as well and we'll have all those patches of yours. So let's go back to
plan A: send your perf changes based on bpf-next. Thanks and sorry for
the extra noise with all the back and forth.


> jirka
