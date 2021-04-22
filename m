Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D233367829
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 06:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbhDVEAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 00:00:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbhDVEAi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 00:00:38 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65960C06174A;
        Wed, 21 Apr 2021 21:00:02 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id v3so47416796ybi.1;
        Wed, 21 Apr 2021 21:00:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XrmiHn9veLJZtruOzFEYxfRmanDJ+LDdZNSOgA37p+4=;
        b=hx3OvCwl6VNHXOWE6Efxu2zzB2VxzN8gkGSbSj8GiQ7oHA/cpKEY2uByb16l6L7b/a
         SoXODyZemZ0LoXOXwEWWp2H2Ssr/VlnuLDCLKOL48pw8o5cLJgqtG49x7h2xDuC5Sw4g
         tyZ6fkLTtXUHD2QFPI6WNwQbcvevdMETKneGK0anxQqZo4oTwmN9iGaQSxSaz4NudNu9
         rmuDZs7nKfzNZO/T+XQ+C15FfCmGpjGxA+Uqz9/tqWh+f6dOetZcgHPlZlQDLwniOzJJ
         NwkJtY+Gm4glHixs7uqWN4HmOg7oGRwi19RkgqioGmYVKTcbfXAM6RyBsQ/svAw2J/C1
         5cWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XrmiHn9veLJZtruOzFEYxfRmanDJ+LDdZNSOgA37p+4=;
        b=Npg0FyojjNUVdWmjFHJEZcyOA3r6n+73MZoDWLh6hWjBzWzzXMW1VLRyBfip3Grh/R
         O58eos4Ou9LLozKA/5Yxq3ceu2k8vJxUGt/EUMV4+4a+CECqfZH/3rBDV9q9ZC0Ccg9F
         99PS7xKIAhdf8RfOBSVSK+ICGJitlFbZ2GA6X/kXjNUDTZoqY3zh+tJcMVM4JcBrZV/W
         gw1ZUlrhnR5KDtbZHhYCex6jGrH6PUk3eQ9NDp8POVH2v3TQ8oWy9q94ZKcRjC9sR/hS
         B0Eu0IJsL+DWxfTZu+x5sT25rJfB7rmFDZolEsA3GyPxhVfB6sQqYS/T0IZHss+1D61y
         VVtQ==
X-Gm-Message-State: AOAM533D6n1Iuvud7d46+riidL7IhxVXXA0WaSmN73O6FZLPYMca1S95
        gzx/5NCvCKQCeBXu3v7q4eXOy58QpByvI31NYsA=
X-Google-Smtp-Source: ABdhPJwzGeskpZsGlTF8Pff4DLzeb+hWhNgq1LZWlacRa3BBHV8IIuj184EiaMmGJXAqp+FfhcEjSN4clgKhj/RGRn0=
X-Received: by 2002:a25:ae8c:: with SMTP id b12mr1845190ybj.347.1619064001784;
 Wed, 21 Apr 2021 21:00:01 -0700 (PDT)
MIME-Version: 1.0
References: <20210416202404.3443623-1-andrii@kernel.org> <20210416202404.3443623-4-andrii@kernel.org>
 <c9367c9d-527c-ba50-bb28-59abad9f5009@fb.com>
In-Reply-To: <c9367c9d-527c-ba50-bb28-59abad9f5009@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 21 Apr 2021 20:59:50 -0700
Message-ID: <CAEf4BzbJMtqxkaJNAvv_M1OoxN6TKZgniLbJD1u5nxj1H32wKw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 03/17] libbpf: suppress compiler warning when
 using SEC() macro with externs
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 21, 2021 at 8:48 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 4/16/21 1:23 PM, Andrii Nakryiko wrote:
> > When used on externs SEC() macro will trigger compilation warning about
> > inapplicable `__attribute__((used))`. That's expected for extern declarations,
> > so suppress it with the corresponding _Pragma.
> >
> > Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
>
> Ack with some comments below.
> Acked-by: Yonghong Song <yhs@fb.com>
>
> > ---
> >   tools/lib/bpf/bpf_helpers.h | 11 +++++++++--
> >   1 file changed, 9 insertions(+), 2 deletions(-)
> >
> > diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
> > index b904128626c2..75c7581b304c 100644
> > --- a/tools/lib/bpf/bpf_helpers.h
> > +++ b/tools/lib/bpf/bpf_helpers.h
> > @@ -25,9 +25,16 @@
> >   /*
> >    * Helper macro to place programs, maps, license in
> >    * different sections in elf_bpf file. Section names
> > - * are interpreted by elf_bpf loader
> > + * are interpreted by libbpf depending on the context (BPF programs, BPF maps,
> > + * extern variables, etc).
> > + * To allow use of SEC() with externs (e.g., for extern .maps declarations),
> > + * make sure __attribute__((unused)) doesn't trigger compilation warning.
> >    */
> > -#define SEC(NAME) __attribute__((section(NAME), used))
> > +#define SEC(name) \
> > +     _Pragma("GCC diagnostic push")                                      \
> > +     _Pragma("GCC diagnostic ignored \"-Wignored-attributes\"")          \
> > +     __attribute__((section(name), used))                                \
> > +     _Pragma("GCC diagnostic pop")                                       \
>
> The 'used' attribute is mostly useful for static variable/functions
> since otherwise if not really used, the compiler could delete them
> freely. The 'used' attribute does not really have an impact on
> global variables regardless whether they are used or not in a particular
> compilation unit. We could drop 'used' here and selftests should still
> work. The only worry is that if people define something like
>     static int _version SEC("version") = 1;
>     static char _license[] SEC("license") = "GPL";
> Removing 'used' may cause failure.
>
> Since we don't want to remove 'used', then adding _Pragma to silence
> the warning is a right thing to do here.

Right, SEC() has become a universal macro used for functions,
variables, and externs. I didn't want to introduce multiple variants,
but also we can't break existing use cases. So pragma, luckily,
allowed to support all cases.

>
> >
> >   /* Avoid 'linux/stddef.h' definition of '__always_inline'. */
> >   #undef __always_inline
> >
