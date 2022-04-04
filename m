Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 939CA4F0D3C
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 02:22:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376805AbiDDAYq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 20:24:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235549AbiDDAYo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 20:24:44 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74471326CD;
        Sun,  3 Apr 2022 17:22:49 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id b16so9495689ioz.3;
        Sun, 03 Apr 2022 17:22:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aRWK0On/yQrY9JPjv44yF0LPcIjibwFg2byMQWbxmME=;
        b=m7QLUo7hQJc1gPKTRFWKJMyYxQRJoEUmN6fETczH5jCn8d4R/oKkYo4UWK5g0IY8VI
         p3ASRZ02UvqPNVj+uwGFqGiODMN6dX6xYvtxF/oHx0i35GLATYzqXnBFSkFxu9M+VwmT
         xb3/PdwR/s2kmyLi8ZTlpA/KcTv06dxnrjjglAUHXQxajJSS8bnqhbz2FmR6/t8zypGb
         rWAs86RwysW+2t2E+czeksUfo2S/bXGIkEc033ZcgZqbViqFeZFRNYHaiLflYRTwulO1
         ZWtK+SF68AjzHfD8eqQz6vsUP5GICjDbkWh+xyUyzHSFtaNFAsqcM27Y0U6kks0IQu+2
         Mq4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aRWK0On/yQrY9JPjv44yF0LPcIjibwFg2byMQWbxmME=;
        b=DGsTerQtAAe5fUrlSs9IuAJKE6jVg3+ghoHO6OMHadRcCmznqDZHhizh7EFso/XVW6
         QYBjZMIH17aXUlrGB9CzKzu4LeZJZY7aLSHaYUnqFEZBar+WjV5N/jH5fiHuaCzs0BR7
         F4kWoJLShOdDSuozwB+47l6KrbPaFla7ODqRh5fzGneDUli2UU+2l8UCVjyDD7Vowxv4
         JldHYDFTr6IuVO431P+CTnkzmBkY6fdwstZd3OUyGmZmf1insP4z1Tlr91CJsiSq9Yl4
         3v4oCmHHFkIctSMwAt5HHFdx3CQDbxcqY6tbukN9KaxlRshn+9ovgSnDKA640i16F5Z3
         GbcA==
X-Gm-Message-State: AOAM532sidG7ISiK++nBHF/Wflqy0ZkuMZdHb6u1e6uA/Gskz1Wrc6L1
        Z/V1R+vDftvP7wiFRNsJ7Z9O1Quw77GwWBPKGbs=
X-Google-Smtp-Source: ABdhPJw3GVx6VRlTw8pIT6ieOqU7bki+fDz8/uu6pPoGbccqm8oEHB/k+fnnlta0vSZ4NcUV23zKg08MWe65dXoOuPU=
X-Received: by 2002:a05:6638:2105:b0:323:68db:2e4e with SMTP id
 n5-20020a056638210500b0032368db2e4emr11000299jaj.234.1649031768898; Sun, 03
 Apr 2022 17:22:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220328175033.2437312-1-roberto.sassu@huawei.com>
 <20220328175033.2437312-6-roberto.sassu@huawei.com> <CAEf4BzY9d0pUP2TFkOY41dbjyYrsr5S+sNCpynPtg_9XZHFb-Q@mail.gmail.com>
 <4621def6171f4ca5948a59a7e714d25f@huawei.com>
In-Reply-To: <4621def6171f4ca5948a59a7e714d25f@huawei.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sun, 3 Apr 2022 17:22:38 -0700
Message-ID: <CAEf4BzZB=aLA23xysFBm50AKZ72p0PBDeL5j1d0mmNCGW2VKwA@mail.gmail.com>
Subject: Re: [PATCH 05/18] bpf-preload: Generate static variables
To:     Roberto Sassu <roberto.sassu@huawei.com>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
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

On Wed, Mar 30, 2022 at 12:44 AM Roberto Sassu <roberto.sassu@huawei.com> wrote:
>
> > From: Andrii Nakryiko [mailto:andrii.nakryiko@gmail.com]
> > Sent: Wednesday, March 30, 2022 1:52 AM
> > On Mon, Mar 28, 2022 at 10:52 AM Roberto Sassu
> > <roberto.sassu@huawei.com> wrote:
> > >
> > > The first part of the preload code generation consists in generating the
> > > static variables to be used by the code itself: the links and maps to be
> > > pinned, and the skeleton. Generation of the preload variables and
> > methods
> > > is enabled with the option -P added to 'bpftool gen skeleton'.
> > >
> > > The existing variables maps_link and progs_links in bpf_preload_kern.c
> > have
> > > been renamed respectively to dump_bpf_map_link and
> > dump_bpf_prog_link, to
> > > match the name of the variables in the main structure of the light
> > > skeleton.
> > >
> > > Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> > > ---
> > >  kernel/bpf/preload/bpf_preload_kern.c         |  35 +-
> > >  kernel/bpf/preload/iterators/Makefile         |   2 +-
> > >  .../bpf/preload/iterators/iterators.lskel.h   | 378 +++++++++---------
> > >  .../bpf/bpftool/Documentation/bpftool-gen.rst |   5 +
> > >  tools/bpf/bpftool/bash-completion/bpftool     |   2 +-
> > >  tools/bpf/bpftool/gen.c                       |  27 ++
> > >  tools/bpf/bpftool/main.c                      |   7 +-
> > >  tools/bpf/bpftool/main.h                      |   1 +
> > >  8 files changed, 254 insertions(+), 203 deletions(-)
> > >
> >
> > [...]
> >
> > > +__attribute__((unused)) static void
> > > +iterators_bpf__assert(struct iterators_bpf *s)
> > > +{
> > > +#ifdef __cplusplus
> > > +#define _Static_assert static_assert
> > > +#endif
> > > +#ifdef __cplusplus
> > > +#undef _Static_assert
> > > +#endif
> > > +}
> > > +
> > > +static struct bpf_link *dump_bpf_map_link;
> > > +static struct bpf_link *dump_bpf_prog_link;
> > > +static struct iterators_bpf *skel;
> >
> > I don't understand what is this and what for? You are making an
> > assumption that light skeleton can be instantiated just once, why? And
> > adding extra bpftool option to light skeleton codegen just to save a
> > bit of typing at the place where light skeleton is actually
> > instantiated and used doesn't seems like a right approach.
>
> True, iterator_bpf is simple. Writing the preloading code
> for it is simple. But, what if you wanted to preload an LSM
> with 10 hooks or more?

I suppose you'd write a straightforward code to do pinning ten times
for ten different programs to ten different paths. But with this you
don't have to establish a random set of conventions that might not
apply in all the situations to anyone that would try to use this
feature.

Worst case, light skeleton can be extended to provide a way to iterate
all programs programmatically.

>
> Ok, regarding where the preloading code should be, I will
> try to move the generated code to the kernel module instead
> of the light skeleton.
>
> Thanks
>
> Roberto
>
> HUAWEI TECHNOLOGIES Duesseldorf GmbH, HRB 56063
> Managing Director: Li Peng, Zhong Ronghua
>
> > Further, even if this is the way to go, please split out bpftool
> > changes from kernel changes. There is nothing requiring them to be
> > coupled together.
> >
> > [...]
