Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3577C3CC044
	for <lists+netdev@lfdr.de>; Sat, 17 Jul 2021 02:38:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232624AbhGQAlq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 20:41:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbhGQAlo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 20:41:44 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B936FC06175F;
        Fri, 16 Jul 2021 17:38:47 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id p22so17644141yba.7;
        Fri, 16 Jul 2021 17:38:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qKGW0l32ov6Qx3nXhQmv4CGkVBvPl3fyq9GCbjnP0/Q=;
        b=hhhP6dsNV5ZEKIrH/JpKnBVZs9oOFCZW/NB/DI9j7K9/rD1a8g7ZiofB+X+4RT6mSh
         NXpQkGSv8qpF4Et3FoM7Vdv738Jy6LfVRxotaBLE+Ui9Ni+JpPU2FU+BSAThwnHVv2Iw
         nQA7b4cbjSKYnxVXZKoIP/qnqONr+d4uVd+bPSbvlAAFJGo7iEJN44S2954YOQ2tGE7s
         R6f35pxQzyF/JdwUDWnOkg7MUTr+jPQBArG57isbnjlpBVDD1EpUuSDR4pdTIJfehuzr
         FfzPzcLpatVd0YjLHxD7zkY3BTPqmutq/Ockiv92NxAPS5ZCx77bWyjq6RvP5u5whJ/g
         ol+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qKGW0l32ov6Qx3nXhQmv4CGkVBvPl3fyq9GCbjnP0/Q=;
        b=JF0ReQ08D+wNq1rvBQKV8XUpzgBYCuz4/2eOqT+cVXRRXjR1sr/t1DQzKPqonMADL4
         S+7Cgcz+HqW3Bzu46L5k+mW9OTrke6T5Tq9Ekk7octr1//OLc3AsogPBQ6SDyunIYSqg
         n2apAJlsQuzOkloyokEwFQLJjIAaskW4wPSuRo7hkNED0/Hsyd36JjJIQj04X+gEpSyv
         GHCwhCI9/BGr/Tc2XXFEScmGq6S/cLp9uNr/T5ejbwwDsiRQNMmk7T17jjITaUiA9ye6
         Q8qdkQyF3Bcu1po9nA9527aW4rAr4/M+iZuEcwQ4IPu0Wq0M0etLJjaPS9JuaoOkwCWk
         EYRQ==
X-Gm-Message-State: AOAM532zQprSqj9MQOK41VYCsI9AQNnVowO+nom8M21cEurxoRBdZt1W
        K2K6h/NN31DP8qKewSREtzyso/hHFYYdyaykZz8=
X-Google-Smtp-Source: ABdhPJyrHI4fO7K3ahDDb2pptRxXBudXKwfV2ntU1n8rcTkwMbG5BiRXZVKCrkzXEGoLcr0tl2psO3GrAssblQEBtvs=
X-Received: by 2002:a25:1455:: with SMTP id 82mr16229676ybu.403.1626482327090;
 Fri, 16 Jul 2021 17:38:47 -0700 (PDT)
MIME-Version: 1.0
References: <1626475617-25984-1-git-send-email-alan.maguire@oracle.com> <CAEf4BzbCYhJnvrEOvbYt3vbhr23BytbfDPkc=GUgkzneVJVJMQ@mail.gmail.com>
In-Reply-To: <CAEf4BzbCYhJnvrEOvbYt3vbhr23BytbfDPkc=GUgkzneVJVJMQ@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 16 Jul 2021 17:38:36 -0700
Message-ID: <CAEf4BzYYeaB2jJTHP+gwgFvNpdrrbgrK5akmetBP7YHTMtz0VQ@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 0/3] libbpf: BTF typed dump cleanups
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Bill Wendling <morbo@google.com>,
        Shuah Khan <shuah@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 16, 2021 at 5:32 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Fri, Jul 16, 2021 at 3:47 PM Alan Maguire <alan.maguire@oracle.com> wrote:
> >
> > Fix issues with libbpf BTF typed dump code.  Patch 1 addresses handling
> > of unaligned data. Patch 2 fixes issues Andrii noticed when compiling
> > on ppc64le.  Patch 3 simplifies typed dump by getting rid of allocation
> > of dump data structure which tracks dump state etc.
> >
> > Changes since v1:
> >
> >  - Andrii suggested using a function instead of a macro for checking
> >    alignment of data, and pointed out that we need to consider dump
> >    ptr size versus native pointer size (patch 1)
> >
> > Alan Maguire (3):
> >   libbpf: clarify/fix unaligned data issues for btf typed dump
> >   libbpf: fix compilation errors on ppc64le for btf dump typed data
> >   libbpf: btf typed dump does not need to allocate dump data
> >
> >  tools/lib/bpf/btf_dump.c | 39 ++++++++++++++++++++++++++++++---------
> >  1 file changed, 30 insertions(+), 9 deletions(-)
> >
> > --
> > 1.8.3.1
> >
>
> Thank you for the quick follow up. But see all the comments I left and

One more thing. Please do reply to the rest of my questions and
concerns on the original patch set. You tend to just address most of
the feedback in the next revision, but I'd appreciate it if you could
reply at least with a simple "ok" or more elaborate answer where
warranted. It makes the code reviewing process a bit easier.

There are still big-endian concerns and an error propagation question
at least that you haven't addressed neither in the follow up patches
nor in an email reply. Please do so, preferably both.

> the fix ups I had to do. Just because the changes are small doesn't
> mean you should get sloppy about making them. Please be a bit more
> thorough in future patches.
>
> Applied to bpf-next.
