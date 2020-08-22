Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A7B524E5F1
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 09:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727055AbgHVHEo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 03:04:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725932AbgHVHEl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Aug 2020 03:04:41 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5D3DC061574
        for <netdev@vger.kernel.org>; Sat, 22 Aug 2020 00:04:40 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id f24so1108931edw.10
        for <netdev@vger.kernel.org>; Sat, 22 Aug 2020 00:04:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fwfunudANjOoTZXdPkqCPqeCMIZCPPl9JuhA1bl5pBw=;
        b=AtiHmTovOFzL0yalRrqMCdj2asvK/1cxQIlCX37p5Ym1vHLaK5/uyoXDO5PV0Cynn4
         dUM/RyqHAU8i3IVnpbxyAy5dQVFN3g1WwEgsnZVzWq2wHi8GnA8hZpnKmhaHNY1HPo7I
         NFWTu98Pw2ehMm3Mg9FVtUzRJ8xGKoxA8Cto7R84r8AZJDA4CVjbhQHT8pSBZ0sVyoEx
         P3xULHzA0ZOWuFJmDb5bDK2gJCPGMIn+ihEgGD4GwaiL75StGkLVdp9+E8TrJT4jSIF+
         WslnbwaP1YImU7zqbBh5iEYHAe5d1z08fGQSgSaPSylBFep6M6IalNYNsDlgFB5hK0MK
         ncYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fwfunudANjOoTZXdPkqCPqeCMIZCPPl9JuhA1bl5pBw=;
        b=kdfizlQaiKGxMRQbuDA2ul1YYuwH8XdHUkYTAqJzCOQQ93r15X5XmZzKRt/0Fgen+c
         QnNK7CnB4jy4wV8IcoQGw7gtZGXv+hdltBYVKEc/l9zBbUJ4P+56U6fJoJUZ8IJDl0G2
         UFnWoeYwG+olB1T4pm9+rPfBxmw5lQK1Q4UEdOKYsX21sWknI8KMV9+xxVvEStH8sB11
         dx6K+drGmXk3186CF3tDeBJPHEJfzUhg71wdHOuGayBEwNOI5OfdFdv0DqaStFGhj0kG
         rOPjmni2Zg6u5uqGVC9aG7R/w2kMk9OTQpgslJnCnfNMRnVIorfHYVl/a5Pv6g12F48k
         DP3A==
X-Gm-Message-State: AOAM532KEO8lZM5cSNGpWOV2SljmHroaWfoclHplD4qmSiAhyM7N0Lb/
        OF5uHBugD6gK6SbE3uUlu5m5hdMiu2pXtD+9GgXJSg==
X-Google-Smtp-Source: ABdhPJxYY8CRHDb7qzuMzF83Z04DfNrYhMMudL5DibJuxlaN0+NROigEgLH3AQp37MMKbZJaEeSrr6V8kf9TiBhN0P4=
X-Received: by 2002:a05:6402:30a5:: with SMTP id df5mr6082918edb.18.1598079878906;
 Sat, 22 Aug 2020 00:04:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200819224030.1615203-1-haoluo@google.com> <20200819224030.1615203-4-haoluo@google.com>
 <d50a1530-9a9f-45b2-5aba-05fe4b895fbc@fb.com> <CAEf4BzZmLUcw4M16U6w-s2Zd6KbsuY4dzzkeEBx9CejetT5BwQ@mail.gmail.com>
 <CA+khW7jZc=p50eGUb6kLUq00bq8C_JmN2pJcu66uMUu3aL7=ZQ@mail.gmail.com> <CAEf4Bzb70CYZMYXEW0RO+S99xG4iwr9BQmGhD4ymWkwq_NR=6Q@mail.gmail.com>
In-Reply-To: <CAEf4Bzb70CYZMYXEW0RO+S99xG4iwr9BQmGhD4ymWkwq_NR=6Q@mail.gmail.com>
From:   Hao Luo <haoluo@google.com>
Date:   Sat, 22 Aug 2020 00:04:27 -0700
Message-ID: <CA+khW7hQh8E8p=BAb=3WTD=0JTP_AX2x6wZp-QMQqwoQ2rgG-g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 3/8] bpf: Introduce help function to validate
 ksym's type.
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>, Networking <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, Andrey Ignatov <rdna@fb.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ah, I see bpf_core_types_are_compat() after sync'ing my local repo. It
seems the perfect fit for my use case. I only found the
btf_equal_xxx() defined in btf.c when posting these patches. I can
test and use bpf_core_types_are_compat() in v2. Thanks for pointing it
out and explaining the public APIs.

Hao

On Fri, Aug 21, 2020 at 7:43 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Fri, Aug 21, 2020 at 5:43 PM Hao Luo <haoluo@google.com> wrote:
> >
> > On Fri, Aug 21, 2020 at 2:50 PM Andrii Nakryiko
> > <andrii.nakryiko@gmail.com> wrote:
> > >
> > > On Thu, Aug 20, 2020 at 10:22 AM Yonghong Song <yhs@fb.com> wrote:
> > > >
> > > >
> > > >
> > > > On 8/19/20 3:40 PM, Hao Luo wrote:
> > > > > For a ksym to be safely dereferenced and accessed, its type defined in
> > > > > bpf program should basically match its type defined in kernel. Implement
> > > > > a help function for a quick matching, which is used by libbpf when
> > > > > resolving the kernel btf_id of a ksym.
> > > > >
> > > > > Signed-off-by: Hao Luo <haoluo@google.com>
> > > > > ---
> > [...]
> > > > > +/*
> > > > > + * Match a ksym's type defined in bpf programs against its type encoded in
> > > > > + * kernel btf.
> > > > > + */
> > > > > +bool btf_ksym_type_match(const struct btf *ba, __u32 id_a,
> > > > > +                      const struct btf *bb, __u32 id_b)
> > > > > +{
> > >
> > > [...]
> > >
> > > > > +                     }
> > > > > +             }
> > > >
> > > > I am wondering whether this is too strict and how this can co-work with
> > > > CO-RE. Forcing users to write almost identical structure definition to
> > > > the underlying kernel will not be user friendly and may not work cross
> > > > kernel versions even if the field user cares have not changed.
> > > >
> > > > Maybe we can relax the constraint here. You can look at existing
> > > > libbpf CO-RE code.
> > >
> > > Right. Hao, can you just re-use bpf_core_types_are_compat() instead?
> > > See if semantics makes sense, but I think it should. BPF CO-RE has
> > > been permissive in terms of struct size and few other type aspects,
> > > because it handles relocations so well. This approach allows to not
> > > have to exactly match all possible variations of some struct
> > > definition, which is a big problem with ever-changing kernel data
> > > structures.
> > >
> >
> > I have to say I hate myself writing another type comparison instead of
> > reusing the existing one. The issue is that when bpf_core_types_compat
> > compares names, it uses t1->name_off == t2->name_off. It is also used
>
> Huh? Are we talking about the same bpf_core_types_are_compat() (there
> is no bpf_core_types_compat, I think it's a typo)?
> bpf_core_types_are_compat() doesn't even compare any name, so I'm not
> sure what you are talking about. Some of btf_dedup functions do string
> comparisons using name_off directly, but that's a special and very
> careful case, it's not relevant here.
>
>
> > in bpf_equal_common(). In my case, because these types are from two
> > different BTFs, their name_off are not expected to be the same, right?
> > I didn't find a good solution to refactor before posting this patch. I
>
> bpf_core_types_are_compat() didn't land until this week, so you must
> be confusing something. Please take another look.
>
> > think I can adapt bpf_core_type_compat() and pay more attention to
> > CO-RE.
> >
> > > >
> > > > > +             break;
> > > > > +     }
> > >
> > > [...]
> > >
> > > > > +
> > > > >   struct btf_ext_sec_setup_param {
> > > > >       __u32 off;
> > > > >       __u32 len;
> > > > > diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
> > > > > index 91f0ad0e0325..5ef220e52485 100644
> > > > > --- a/tools/lib/bpf/btf.h
> > > > > +++ b/tools/lib/bpf/btf.h
> > > > > @@ -52,6 +52,8 @@ LIBBPF_API int btf__get_map_kv_tids(const struct btf *btf, const char *map_name,
> > > > >                                   __u32 expected_key_size,
> > > > >                                   __u32 expected_value_size,
> > > > >                                   __u32 *key_type_id, __u32 *value_type_id);
> > > > > +LIBBPF_API bool btf_ksym_type_match(const struct btf *ba, __u32 id_a,
> > > > > +                                 const struct btf *bb, __u32 id_b);
> > > > >
> > > > >   LIBBPF_API struct btf_ext *btf_ext__new(__u8 *data, __u32 size);
> > > > >   LIBBPF_API void btf_ext__free(struct btf_ext *btf_ext);
> > > >
> > > > The new API function should be added to libbpf.map.
> > >
> > > My question is why does this even have to be a public API?
> >
> > I can fix. Please pardon my ignorance, what is the difference between
> > public and internal APIs? I wasn't sure, so used it improperly.
>
> public APIs are those that users of libbpf are supposed to use,
> internal one is just for libbpf internal use. The former can't change,
> the latter can be refactor as much as we need to.
>
> >
> > Thanks,
> > Hao
