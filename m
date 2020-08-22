Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 684AC24E4B2
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 04:43:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726730AbgHVCnX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 22:43:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725935AbgHVCnT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 22:43:19 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB073C061573;
        Fri, 21 Aug 2020 19:43:18 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id a34so2055942ybj.9;
        Fri, 21 Aug 2020 19:43:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tT+1l+/BC3EOuKQ2iWSGuqNPPQLKkFRRGGmFxrYn8yg=;
        b=DhxNyoLLtWcFmfqGGrlqvHxFgvfcnbkSbNE3tTPwExZJJ61TcjFx0tSTHXWEcbKJgX
         afo73BWK2RVl0K0yDgM8PMfESnkjVKEpftIUzIPhF2NfyRiRJBzarsB2YjuUIUgEUlme
         6Qs80wYKTu+DtgGunUMStozQ2oZAlESEbvutwoUKhgnO5ZXSWOiky/bgn66uGbAk14ob
         P9Z4iwX32lt3iREFd/WCesSVkMQe1iRLvygvFTc5zuPl7Jaqk1ZqbRLFthQcg96J1uZV
         AnHhOcVVKsuJsCagQJnqkNqC+DpfSHytVfWiIr5cRI8DTc5dCLRO6DdF1OazrxEGOFeg
         G8cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tT+1l+/BC3EOuKQ2iWSGuqNPPQLKkFRRGGmFxrYn8yg=;
        b=glhabZkAVKJ1ZaJFKoBE/PCnmtA1Ck0Zyq/0JgqGAL/d398ooBMKWhjT1EUQsNG64R
         MXZXCx4QtHGBGu4d/PQO1RLjH7O51NEvJ9BbtTJzmeT+W2rsqcitORGwKd0jlaZaegjM
         nLQJJf0s6mIHnKtLXdCNapiVDxupsT0Cdch67EwrHWi9HNPJG/Y25xvwUcclt+xkCCbY
         TH8FC5iWj5U0b+a9wF8LJJJDWt2ymmOLTqcBD2KZs+YXa5WcvleA+25wwPp18Mtwp7FF
         IaJGFl2yzkpMvR5jCnMeu1JyYiHb8hMLWDKwNHXAuQW2x+fBoHnnML1/PeISw5yAQ9i8
         xYNA==
X-Gm-Message-State: AOAM531U18DUZOKtLzi0y9FooNL4zpDXY9E6ZPuO4BbvHUl71PyLIiyP
        oEMlc98r/CV8zMNgZj/GVNwGTVyLEdBvyxPE3FU=
X-Google-Smtp-Source: ABdhPJwLz0bTjIfjL7Q/EfBWQn1Mj2+ggqWeLXxo64+iot7jlMG7IdezK+72EYgTefou96VRSQOFnnjC3FzG9qtMYrs=
X-Received: by 2002:a25:2ad3:: with SMTP id q202mr7321797ybq.27.1598064197708;
 Fri, 21 Aug 2020 19:43:17 -0700 (PDT)
MIME-Version: 1.0
References: <20200819224030.1615203-1-haoluo@google.com> <20200819224030.1615203-4-haoluo@google.com>
 <d50a1530-9a9f-45b2-5aba-05fe4b895fbc@fb.com> <CAEf4BzZmLUcw4M16U6w-s2Zd6KbsuY4dzzkeEBx9CejetT5BwQ@mail.gmail.com>
 <CA+khW7jZc=p50eGUb6kLUq00bq8C_JmN2pJcu66uMUu3aL7=ZQ@mail.gmail.com>
In-Reply-To: <CA+khW7jZc=p50eGUb6kLUq00bq8C_JmN2pJcu66uMUu3aL7=ZQ@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 21 Aug 2020 19:43:06 -0700
Message-ID: <CAEf4Bzb70CYZMYXEW0RO+S99xG4iwr9BQmGhD4ymWkwq_NR=6Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 3/8] bpf: Introduce help function to validate
 ksym's type.
To:     Hao Luo <haoluo@google.com>
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

On Fri, Aug 21, 2020 at 5:43 PM Hao Luo <haoluo@google.com> wrote:
>
> On Fri, Aug 21, 2020 at 2:50 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Thu, Aug 20, 2020 at 10:22 AM Yonghong Song <yhs@fb.com> wrote:
> > >
> > >
> > >
> > > On 8/19/20 3:40 PM, Hao Luo wrote:
> > > > For a ksym to be safely dereferenced and accessed, its type defined in
> > > > bpf program should basically match its type defined in kernel. Implement
> > > > a help function for a quick matching, which is used by libbpf when
> > > > resolving the kernel btf_id of a ksym.
> > > >
> > > > Signed-off-by: Hao Luo <haoluo@google.com>
> > > > ---
> [...]
> > > > +/*
> > > > + * Match a ksym's type defined in bpf programs against its type encoded in
> > > > + * kernel btf.
> > > > + */
> > > > +bool btf_ksym_type_match(const struct btf *ba, __u32 id_a,
> > > > +                      const struct btf *bb, __u32 id_b)
> > > > +{
> >
> > [...]
> >
> > > > +                     }
> > > > +             }
> > >
> > > I am wondering whether this is too strict and how this can co-work with
> > > CO-RE. Forcing users to write almost identical structure definition to
> > > the underlying kernel will not be user friendly and may not work cross
> > > kernel versions even if the field user cares have not changed.
> > >
> > > Maybe we can relax the constraint here. You can look at existing
> > > libbpf CO-RE code.
> >
> > Right. Hao, can you just re-use bpf_core_types_are_compat() instead?
> > See if semantics makes sense, but I think it should. BPF CO-RE has
> > been permissive in terms of struct size and few other type aspects,
> > because it handles relocations so well. This approach allows to not
> > have to exactly match all possible variations of some struct
> > definition, which is a big problem with ever-changing kernel data
> > structures.
> >
>
> I have to say I hate myself writing another type comparison instead of
> reusing the existing one. The issue is that when bpf_core_types_compat
> compares names, it uses t1->name_off == t2->name_off. It is also used

Huh? Are we talking about the same bpf_core_types_are_compat() (there
is no bpf_core_types_compat, I think it's a typo)?
bpf_core_types_are_compat() doesn't even compare any name, so I'm not
sure what you are talking about. Some of btf_dedup functions do string
comparisons using name_off directly, but that's a special and very
careful case, it's not relevant here.


> in bpf_equal_common(). In my case, because these types are from two
> different BTFs, their name_off are not expected to be the same, right?
> I didn't find a good solution to refactor before posting this patch. I

bpf_core_types_are_compat() didn't land until this week, so you must
be confusing something. Please take another look.

> think I can adapt bpf_core_type_compat() and pay more attention to
> CO-RE.
>
> > >
> > > > +             break;
> > > > +     }
> >
> > [...]
> >
> > > > +
> > > >   struct btf_ext_sec_setup_param {
> > > >       __u32 off;
> > > >       __u32 len;
> > > > diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
> > > > index 91f0ad0e0325..5ef220e52485 100644
> > > > --- a/tools/lib/bpf/btf.h
> > > > +++ b/tools/lib/bpf/btf.h
> > > > @@ -52,6 +52,8 @@ LIBBPF_API int btf__get_map_kv_tids(const struct btf *btf, const char *map_name,
> > > >                                   __u32 expected_key_size,
> > > >                                   __u32 expected_value_size,
> > > >                                   __u32 *key_type_id, __u32 *value_type_id);
> > > > +LIBBPF_API bool btf_ksym_type_match(const struct btf *ba, __u32 id_a,
> > > > +                                 const struct btf *bb, __u32 id_b);
> > > >
> > > >   LIBBPF_API struct btf_ext *btf_ext__new(__u8 *data, __u32 size);
> > > >   LIBBPF_API void btf_ext__free(struct btf_ext *btf_ext);
> > >
> > > The new API function should be added to libbpf.map.
> >
> > My question is why does this even have to be a public API?
>
> I can fix. Please pardon my ignorance, what is the difference between
> public and internal APIs? I wasn't sure, so used it improperly.

public APIs are those that users of libbpf are supposed to use,
internal one is just for libbpf internal use. The former can't change,
the latter can be refactor as much as we need to.

>
> Thanks,
> Hao
