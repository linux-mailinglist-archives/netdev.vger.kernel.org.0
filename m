Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 813A340BD36
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 03:27:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231629AbhIOB2r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 21:28:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbhIOB2q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 21:28:46 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40169C061574;
        Tue, 14 Sep 2021 18:27:28 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id u13-20020a17090abb0db0290177e1d9b3f7so3712185pjr.1;
        Tue, 14 Sep 2021 18:27:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GoGm5O+ow90Cqr/E9L3Yu+JTMAfV8eUNl67kocs7XI0=;
        b=IXeGBVgHIKJKRUxsB4YmR9UUS7g7PzbogEmIMR1Lt1ODl20BSXgX3o2+a7bc84V2bV
         jnRFDxl6lqQsa0f2s9zkPg2BCZ2BaP6RBq3heuTHBI7QMZhDrMD2OxLf+d6Q89CLu+zU
         r8XSI/BIKos5vWi8h6oOu2Gg5O0lNz9P4BM5jfxoyb3xS6nGcUFFCWmD3TnI2uZxQJqM
         +Qr/1pozTTfFNnDMDaDhpUu61+pE02DXMKtCbU8UGAIB0M7K9xmFIpWwDIy2joZ907Ln
         OLOn06P9S+3/P6rct3LCCVXsPPr6LGJFbC94uT82ch4d6PXkbIUe/1QtYpxoTh+jO2yb
         wfdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GoGm5O+ow90Cqr/E9L3Yu+JTMAfV8eUNl67kocs7XI0=;
        b=y+4fEMM012vL5X5Gnmi0TqtDB6JmBcA5Yc71I8k6G47IZB7nPtnY/aepZVQH5DkQ52
         /pf33s1Dt2jF804X1SGojBkune+SxwarD+SbfOpr7jaWWj9Gkx43eTLFVmMWepyYg8rQ
         yUDUu32Vw4jD28PxmuzrlIPcpqm+pznQplRsOHpofSrK3sc2KN4pF4yYdjwO9hQ79RuA
         iJ0aK/57XLDz5nNonxBxB2j6umlykMiDaqVBatw2MME/Zv0wbzt/K/T42onQVCuXJFTP
         h7pdt1G6jJuoQl1/KaWU803YepzM26gYD/BK7qESWsRjzMcjMamj2A5UrLK+2h1/dQE8
         D7Ug==
X-Gm-Message-State: AOAM5318F1FE8CoM4tW+DmBMn6DJGnaTB1QFf0YFj743zAbXN8Ku5NG7
        iJksnnJZyvPEzANlKQEI5CH/4EuOJ1LRaZppe6k=
X-Google-Smtp-Source: ABdhPJxvXMhLMoML9XwXRfP2Ig/+hvEJrImw8ZxFolAWBLxVqlzX6kJ6+yST1YYOva7wgpiHScvnezNtAKtpqu5BkUg=
X-Received: by 2002:a17:90a:450d:: with SMTP id u13mr5438352pjg.138.1631669247645;
 Tue, 14 Sep 2021 18:27:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210914113730.74623156@canb.auug.org.au> <CAEf4BzYt4XnHr=zxAEeA2=xF_LCNs_eqneO1R6j8=PMTBo5Z5w@mail.gmail.com>
 <20210915093802.02303754@canb.auug.org.au> <CAEf4BzZ7LKNZ8w8=6PGTUxfp2ea_HOBJL=dZocdsyWjKqZ2LhQ@mail.gmail.com>
 <20210915095942.3f8c2dcc@canb.auug.org.au>
In-Reply-To: <20210915095942.3f8c2dcc@canb.auug.org.au>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 14 Sep 2021 18:27:16 -0700
Message-ID: <CAADnVQJOiGaWq+HtVuGuMszb6e+9bKYcFybs0J-C6cjPTsKSeQ@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the bpf-next tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 14, 2021 at 4:59 PM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Hi Andrii,
>
> On Tue, 14 Sep 2021 16:40:37 -0700 Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> >
> > On Tue, Sep 14, 2021 at 4:38 PM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > >
> > > Hi Andrii,
> > >
> > > On Tue, 14 Sep 2021 16:25:55 -0700 Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> > > >
> > > > On Mon, Sep 13, 2021 at 6:37 PM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > > > >
> > > > > After merging the bpf-next tree, today's linux-next build (perf) failed
> > > > > like this:
> > > > >
> > > > > util/bpf-event.c: In function 'btf__load_from_kernel_by_id':
> > > > > util/bpf-event.c:27:8: error: 'btf__get_from_id' is deprecated: libbpf v0.6+: use btf__load_from_kernel_by_id instead [-Werror=deprecated-declarations]
> > > > >    27 |        int err = btf__get_from_id(id, &btf);
> > > > >       |        ^~~
> > > > > In file included from util/bpf-event.c:5:
> > > > > /home/sfr/next/next/tools/lib/bpf/btf.h:54:16: note: declared here
> > > > >    54 | LIBBPF_API int btf__get_from_id(__u32 id, struct btf **btf);
> > > > >       |                ^~~~~~~~~~~~~~~~
> > > > > cc1: all warnings being treated as errors
> > > > >
> > > > > Caused by commit
> > > > >
> > > > >   0b46b7550560 ("libbpf: Add LIBBPF_DEPRECATED_SINCE macro for scheduling API deprecations")
> > > >
> > > > Should be fixed by [0], when applied to perf tree. Thanks for reporting!
> > > >
> > > >   [0] https://patchwork.kernel.org/project/netdevbpf/patch/20210914170004.4185659-1-andrii@kernel.org/
> > >
> > > That really needs to be applied to the bpf-next tree (presumably with
> > > the appropriate Acks).
> > >
> >
> > This is perf code that's not in bpf-next yet.
>
> Then you need to think of a solution for the bpf-next tree, as it will
> not build (allmodconfig) when combined with Linus' current tree.  And
> when it is merged into the net-next tree, that tree will be broken as
> well.

It's not a problem of bpf-tree and it cannot be fixed in bpf-tree.
The bug is in perf tree.
