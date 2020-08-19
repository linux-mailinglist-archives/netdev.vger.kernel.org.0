Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF08249476
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 07:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725804AbgHSFcz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 01:32:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbgHSFcx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 01:32:53 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 723F6C061389;
        Tue, 18 Aug 2020 22:32:53 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id a34so12660468ybj.9;
        Tue, 18 Aug 2020 22:32:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nInBslMemewmJR6XwL9uFhtJNcEgzVaw5eUhNFIih2Q=;
        b=idxkSLt7jTuIgo81/o1cn+tbYqWRApz739JHe61Kq7/X++4Skkuzkb4L4TwINf57i5
         sUpi+z8GyKesEtGSfEcxXG9TnHqSBnh43560ryniAFnxNHqEkQvJoWG+2i2/K1k9+9y7
         AlYv0lv+HwS/45vEKJ4HP2lMfoLyKVapIQuIR2cv08RrShuNsGuM5C9NgOXvlpiEkOP0
         61ILC+wd672dFpqRodtdmaX2YN9ogb3Elux+NIQagh5qZILChyGHoSPVEQE/hYwxTJE8
         0H2UhjdoFCg0QmJSBnMoMpzp8yimOLOj9ZF7xeoRUI2t2bKPluLxjgs8TSYrZIiquOHo
         9Enw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nInBslMemewmJR6XwL9uFhtJNcEgzVaw5eUhNFIih2Q=;
        b=NcwvLgDR0mPLwrmmFIlt4ibgG4q1O9zmu2SfjMhiVYdu4f8YVVYgYWUCypv72SB5XC
         AgQu7hKzLN4OeAWBjAf6oRxrdMQjG06thQj3R4L1WmDzfb+8GamhTnQeuFQ2n+z3m4+L
         Jb79CFffXhqkjbbR6ohKvIelz3gDL5ZkAP0TqB3ytDXI5YHJ546aozVZ+Bx8NYTZxX47
         qtA12RCd/XZlNYL6PUiOsIkKmvKGQxGiGD0Mqz50+XrDkFPErHcDHIE8Ze17XqkbRerF
         RDNx0wrb5fYbwXw6Z3c3LDJMjiPMo8J7RtORX6Vqq4CFqccv/IseQ3JuodxbaRTl9lyK
         rYrQ==
X-Gm-Message-State: AOAM531I/YIIvVEFgpE9N6iMBZOBUten/oFmeIAodO57h0B8X20eECXk
        6Sh/pStFglsFZZM993kmJke5Hb157ASbjE1bsDjVLi27
X-Google-Smtp-Source: ABdhPJz3nC37q2jGnWxdty0RUDTCQirqVuDkOQ91xhi8xtRI5r0DWalLaW1ru7IUKz4+cw0Ed9ue7r+k8RxdGDdxmnQ=
X-Received: by 2002:a25:2ad3:: with SMTP id q202mr30245113ybq.27.1597815171991;
 Tue, 18 Aug 2020 22:32:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200818223921.2911963-1-andriin@fb.com> <20200819012146.okpmhcqcffoe43sw@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzbpJ4M0X2XPEadXPzPM+2cOPf-9QDMp=2qz3VvY+bbqsg@mail.gmail.com> <20200819013703.cgbty6b6ufp7wuqm@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200819013703.cgbty6b6ufp7wuqm@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 18 Aug 2020 22:32:41 -0700
Message-ID: <CAEf4BzZG7fi4fZLW4O_OB4tueGjX8jz3PdX7iFNjCi9zZc6QQg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/9] Add support for type-based and enum
 value-based CO-RE relocations
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 18, 2020 at 6:37 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Aug 18, 2020 at 06:31:51PM -0700, Andrii Nakryiko wrote:
> > On Tue, Aug 18, 2020 at 6:21 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Tue, Aug 18, 2020 at 03:39:12PM -0700, Andrii Nakryiko wrote:
> > > > This patch set adds libbpf support to two new classes of CO-RE relocations:
> > > > type-based (TYPE_EXISTS/TYPE_SIZE/TYPE_ID_LOCAL/TYPE_ID_TARGET) and enum
> > > > value-vased (ENUMVAL_EXISTS/ENUMVAL_VALUE):
> > > >
> > > > LLVM patches adding these relocation in Clang:
> > > >   - __builtin_btf_type_id() ([0], [1], [2]);
> > > >   - __builtin_preserve_type_info(), __builtin_preserve_enum_value() ([3], [4]).
> > >
> > > I've applied patches 1-4, since they're somewhat indepedent of new features in 5+.
> > > What should be the process to land the rest?
> > > Land llvm first and add to bpf/README.rst that certain llvm commmits are necessary
> > > to build the tests?
> >
> > Clang patches landed about two weeks ago, so they are already in Clang
> > nightly builds. libbpf CI should work fine as it uses clang-12 nightly
> > builds.
> >
> >
> > > But CI will start failing. We can wait for that to be fixed,
> > > but I wonder is there way to detect new clang __builtins automatically in
> > > selftests and skip them if clang is too old?
> >
> > There is a way to detect built-ins availability (__has_builtin macro,
> > [0]) from C code. If we want to do it from Makefile, though, we'd need
> > to do feature detection similar to how we did reallocarray and
> > libbpf-elf-mmap detection I just removed in the other patch set :).
> > Then we'll also need to somehow blacklist tests. Maintaining that
> > would be a pain, honestly. So far selftests/bpf assumed the latest
> > Clang, though, so do you think we should change that, or you were
> > worried that patches hadn't landed yet?
>
> I was hoping that libbpf.h can have builtins unconditionally, but selftests can
> do feature detection automatically and mark them as 'skip'.
> People have been forever complaining about constant need to upgrade clang.
> In this case I think the feature is not fundamental enough (unlike the first
> set of builtins) to force adoption of new clang.
> If/when we start using these new builtins beyond selftests
> that would be a different story.

Ok, took some tinkering to do this for btf_type_id() tests, but
everything works now as you described above. Posted v2.
