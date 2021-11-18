Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8752A455237
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 02:29:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242260AbhKRBch (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 20:32:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236932AbhKRBcf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 20:32:35 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E354C061570;
        Wed, 17 Nov 2021 17:29:35 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id v64so13032118ybi.5;
        Wed, 17 Nov 2021 17:29:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ct4GMWGFgozZC6Txr52d+Z20moSGzGly/2mNAQo+ggM=;
        b=P4ciEPPET63ojRqAl4nAgz9ina1JprDflQSSRxdDerlfQjPQaZOullXQ28Yjkab/op
         RUgElmgdaEWDhEJp8wFIpycHodtQVMk4mBKZ31uWVUbrH/R/SISQCe4+HZkj4skbtPP9
         K5017PKMeMybYmDt/fxNOUY9BZvTGwKRIPwl8Lgu//fgg4KBKxbFvNHoyYtudzHT3u7F
         yJ+OfYVqiu9JwaDNz8xF8RoyodVaG5EDIi6eo6sA8UxngRWvZvcq2EBvhlR5lrfJ+fzP
         2OfT+rNj68H/4Vkb/cDRd5p9oJxUd99QqHyWZ1wWpw5Tqfx1/TtqcBuhjXxOTQ3VuvKP
         DiwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ct4GMWGFgozZC6Txr52d+Z20moSGzGly/2mNAQo+ggM=;
        b=JtGyjuyJK9giTsUHDlTLbNcwsBDg3c5hoDi/uP+JAY++k8B7m4DJAX7DD0pDG7prfw
         MYb7kB914bG05JyE+utNK0reY0xwCrdM4KmZGSTPFOqd08TwfsxzNnDpnhaEi7A9EsVu
         V92l/tTEuMAoL2lebIuAj0JAXrg9ilL+2XBSjr/l8iB7jsYUN7IdUBCcdLHFkZDcdZu3
         eQeVNhCa/INe0W7xySwyM/RzKsT6M31yZm4dssnenykmoGrjyt764iXCnwLxPGk7+pEW
         TzpUr9Z9iGLhEXQQvJJprx74p0mLCeJpFH48G8VckrkUWgDAP3CvRyaTyRMNmDTXi/zo
         fn0g==
X-Gm-Message-State: AOAM530lphugTmxZwN0X6hZMaw5g84Zm8BWZLuyaU+8eNoBwyFXEpxwo
        U45rb6olARhRVZej6LeudKh5JHrpcfkMCMcvQMs=
X-Google-Smtp-Source: ABdhPJymaJ4p2Zqv/BnijbLbr5lXfx/+C3J3rhxmuYz5IvjdK7JD0dSVlp4MrMoOiHaRJX9bMbMzi0jMIeOpku5HEZg=
X-Received: by 2002:a25:d16:: with SMTP id 22mr23256842ybn.51.1637198974832;
 Wed, 17 Nov 2021 17:29:34 -0800 (PST)
MIME-Version: 1.0
References: <20211111161452.86864-1-lmb@cloudflare.com> <CAADnVQKWk5VNT9Z_Cy6COO9NMjkUg1p9gYTsPPzH-fi1qCrDiw@mail.gmail.com>
 <CACAyw99EhJ8k4f3zeQMf3pRC+L=hQhK=Rb3UwSz19wt9gnMPrA@mail.gmail.com> <20211118010059.c2mixoshcrcz4ywq@ast-mbp>
In-Reply-To: <20211118010059.c2mixoshcrcz4ywq@ast-mbp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 17 Nov 2021 17:29:23 -0800
Message-ID: <CAEf4Bza=ZipeiwhvUvLLs9r4dbOUQ6JQTAotmgF6tUr1DAc9pw@mail.gmail.com>
Subject: Re: [PATCH bpf] selftests: bpf: check map in map pruning
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Lorenz Bauer <lmb@cloudflare.com>, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 17, 2021 at 5:01 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, Nov 17, 2021 at 08:47:45AM +0000, Lorenz Bauer wrote:
> > On Sat, 13 Nov 2021 at 01:27, Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > Not sure how you've tested it, but it doesn't work in unpriv:
> > > $ test_verifier 789
> > > #789/u map in map state pruning FAIL
> > > processed 26 insns (limit 1000000) max_states_per_insn 0 total_states
> > > 2 peak_states 2 mark_read 1
> > > #789/p map in map state pruning OK
> >
> > Strange, I have a script that I use for bisecting which uses a minimal
> > .config + virtue to run a vm, plus I was debugging in gdb at the same
> > time. I might have missed this, apologies.
> >
> > I guess vmtest.sh is the canonical way to run tests now?
>
> vmtest.sh runs test_progs only. That's the minimum bar that

It runs test_progs by default, unless something else is requested. You
can run anything inside it, e.g.:

./vmtest.sh -- ./test_maps

BTW, we recently moved configs around in libbpf repo on Github, so
this script broke. I'm sending a fix in a few minutes, hopefully.

> developers have to pass before sending patches.
> BPF CI runs test_progs, test_progs-no_alu32, test_verifier and test_maps.
> If in doubt run them all.
