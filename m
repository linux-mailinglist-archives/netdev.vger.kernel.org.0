Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98D9331581B
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 21:58:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234119AbhBIUxT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 15:53:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233904AbhBIUmH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 15:42:07 -0500
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC713C0698C4
        for <netdev@vger.kernel.org>; Tue,  9 Feb 2021 12:09:44 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id p21so30265827lfu.11
        for <netdev@vger.kernel.org>; Tue, 09 Feb 2021 12:09:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5yicjJeOjogJ0GBzkbyijZntdK7Ju5RCDDq26xojPak=;
        b=AkqLjJVS69L2BZ803u4AcRr1NMKONSj0dEor9TQGaeLPX2QfLX3TfQm2A3e6PDMiFh
         gE76mBeqSSkEVK8VkeRss/fAAYiOlhhPG9rN2B+2STSeXhI1XhGsj/NRZ2rXM+tSyzii
         5vguStpjNGtnYE/4r/LrKioveAQAUhup7ASHhj/yJ/hDNWJL3SO+TLckcK3lxkQnMtnv
         t8rdvH0HCMe3vQKfzZJwWeo671QAdpbL6yh84TqkIG7Nuq43Xp1V+XflGGHpNw4P5iBG
         LbXhEVuJevVFSnvaqDK5cn9jSnT+K/S//9QfqVBz38ACB904w2YFUtLvZPuyAYZn5V27
         jNkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5yicjJeOjogJ0GBzkbyijZntdK7Ju5RCDDq26xojPak=;
        b=Dh5TxFwjGOhB6AQY0tPQxfE47jy+38dSI8YDQ0hSok1+hvI6+N2aoJC/7n8viFvsvV
         +TROemJ53srgWpwoysUl2Rf+8eaWy92kmpAKkrLOInXt0TjfnEHu/KYPrZr1WyHDARfe
         jvS7b+3+qjEz2Q4CHNM+byXpAUFnmfs9BLPsXT/AEiRweHVeXFZQWHN+8MDJmbN9h2bT
         8SelR/cmgzMV4MhdjYZPBvBumI8sy/QyRj2p9K0rJsJ3uiQyBqvLABvgbH6b5QShG35w
         klCX/rd07C5LegDdamCGcAEolFZiHA/GvHP1rCmGEswv3S3lBnJf6irsSLVo7oLd60mb
         6jRw==
X-Gm-Message-State: AOAM531gemzW3PYRZ+SLcyuXbEto8JbHBNVW5nsZymSfgTvbphVV78+0
        TSV/Tz5TVMekjzSoWo1Oln7pzPsf+59jYpJR4IgEtg==
X-Google-Smtp-Source: ABdhPJx4JWlNZAnonhNS1++AdmiMVMLNX1/AZ6G2Miq/JtdC0hC8kv56kaHXCKdVVUmbLdMIkkOumTDOx1PybRcljzM=
X-Received: by 2002:a05:6512:12c1:: with SMTP id p1mr15136130lfg.374.1612901382990;
 Tue, 09 Feb 2021 12:09:42 -0800 (PST)
MIME-Version: 1.0
References: <20210209034416.GA1669105@ubuntu-m3-large-x86> <CAEf4BzYnT-eoKRL9_Pu_DEuqXVa+edN5F-s+k2RxBSzcsSTJ1g@mail.gmail.com>
 <20210209052311.GA125918@ubuntu-m3-large-x86> <CAEf4BzZV0-zx6YKUUKmecs=icnQNXJjTokdkSAoexm36za+wdA@mail.gmail.com>
 <CAEf4BzYvri7wzRnGH_qQbavXOx5TfBA0qx4nYVnn=YNGv+vNVw@mail.gmail.com>
 <CAEf4Bzax90hn_5axpnCpW+E6gVc1mtUgCXWqmxV0tJ4Ud7bsaA@mail.gmail.com>
 <20210209074904.GA286822@ubuntu-m3-large-x86> <YCKB1TF5wz93EIBK@krava>
 <YCKlrLkTQXc4Cyx7@krava> <YCKwxNDkS9rdr43W@krava> <YCLdJPPC+6QjUsR4@krava>
In-Reply-To: <YCLdJPPC+6QjUsR4@krava>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Tue, 9 Feb 2021 12:09:31 -0800
Message-ID: <CAKwvOdnqx5-SsicRf01yhxKOq8mAkYRd+zBScSOmEQ0XJe2mAg@mail.gmail.com>
Subject: Re: FAILED unresolved symbol vfs_truncate on arm64 with LLVM
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Veronika Kabatova <vkabatov@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Daniel Kiss <daniel.kiss@arm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 9, 2021 at 11:06 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Tue, Feb 09, 2021 at 05:13:42PM +0100, Jiri Olsa wrote:
> > On Tue, Feb 09, 2021 at 04:09:36PM +0100, Jiri Olsa wrote:
> >
> > SNIP
> >
> > > > > > >                 DW_AT_prototyped        (true)
> > > > > > >                 DW_AT_type      (0x01cfdfe4 "long int")
> > > > > > >                 DW_AT_external  (true)
> > > > > > >
> > > > > >
> > > > > > Ok, the problem appears to be not in DWARF, but in mcount_loc data.
> > > > > > vfs_truncate's address is not recorded as ftrace-attachable, and thus
> > > > > > pahole ignores it. I don't know why this happens and it's quite
> > > > > > strange, given vfs_truncate is just a normal global function.
> > > >
> > > > right, I can't see it in mcount adresses.. but it begins with instructions
> > > > that appears to be nops, which would suggest it's traceable
> > > >
> > > >   ffff80001031f430 <vfs_truncate>:
> > > >   ffff80001031f430: 5f 24 03 d5   hint    #34
> > > >   ffff80001031f434: 1f 20 03 d5   nop
> > > >   ffff80001031f438: 1f 20 03 d5   nop
> > > >   ffff80001031f43c: 3f 23 03 d5   hint    #25
> > > >
> > > > > >
> > > > > > I'd like to understand this issue before we try to fix it, but there
> > > > > > is at least one improvement we can make: pahole should check ftrace
> > > > > > addresses only for static functions, not the global ones (global ones
> > > > > > should be always attachable, unless they are special, e.g., notrace
> > > > > > and stuff). We can easily check that by looking at the corresponding
> > > > > > symbol. But I'd like to verify that vfs_truncate is ftrace-attachable
> > >
> > > I'm still trying to build the kernel.. however ;-)
> >
> > I finally reproduced.. however arm's not using mcount_loc
> > but some other special section.. so it's new mess for me
>
> so ftrace data actualy has vfs_truncate address but with extra 4 bytes:
>
>         ffff80001031f434
>
> real vfs_truncate address:
>
>         ffff80001031f430 g     F .text  0000000000000168 vfs_truncate
>
> vfs_truncate disasm:
>
>         ffff80001031f430 <vfs_truncate>:
>         ffff80001031f430: 5f 24 03 d5   hint    #34
>         ffff80001031f434: 1f 20 03 d5   nop
>         ffff80001031f438: 1f 20 03 d5   nop
>         ffff80001031f43c: 3f 23 03 d5   hint    #25
>
> thats why we don't match it in pahole.. I checked few other functions
> and some have the same problem and some match the function boundary
>
> those that match don't have that first hint instrucion, like:
>
>         ffff800010321e40 <do_faccessat>:
>         ffff800010321e40: 1f 20 03 d5   nop
>         ffff800010321e44: 1f 20 03 d5   nop
>         ffff800010321e48: 3f 23 03 d5   hint    #25
>
> any hints about hint instructions? ;-)

aarch64 makes *some* newer instructions reuse the "hint" ie "nop"
encoding space to make software backwards compatible on older hardware
that doesn't support such instructions.  Is this BTI, perhaps? (The
function is perhaps the destination of an indirect call?)
-- 
Thanks,
~Nick Desaulniers
