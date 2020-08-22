Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE8F824E440
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 02:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726887AbgHVAoC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 20:44:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726688AbgHVAoB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 20:44:01 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9A6BC061574
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 17:44:00 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id bo3so4569034ejb.11
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 17:43:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZiWSg+hYBkj5lzGxjv3JQWa7cVF6R88j6OVrhK2uYBA=;
        b=KxL3pP6yAfeMPoV7fDm3WekUknERTlN3sAOsvzQLQkyjAPp1Ai0394nLI+3h8BstI4
         cru5zfAnacjkVdbkWZKptmu3nH5JmOdHq/mZXKeEkjrRDTiAPESIhswWFmdGY3J3Wa0P
         UWl9N6os5BIvy5xbJnvxPZmeQbI3R7rd6k1q7pNY7Tn0FRXChLTOaTf9z26toa3XC+rX
         B+M6JjoDPmc77B3lGYxP5YOv95QMIWagwMZI0jCVHBVP4f4UgBhs3qNZKNUBKW6x5Du6
         ETkB8bZ2VZcINjgFqM8Zrqv7t7K19MHiNn0g0GmZ4j+YXBirIjRiZ8Ob8CZkBUtAISYa
         /hCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZiWSg+hYBkj5lzGxjv3JQWa7cVF6R88j6OVrhK2uYBA=;
        b=Xi0Xcf1CpxeQz8YQ0MrEKg3BgkRhmZtojMcsZ+fNm9BRES2o+bZj8YIHbF8EjcLn6B
         +obNHhIrRweeMie5hvkKGsfDFd6/smX2oSCEOKgbhPNuhn6INPby3ss2GzwgR23SK28f
         v3fIQOe2W3CbCUBPtAWj0TVOxGSxT6nwPAVeVzgexwAd3cFhSmlDThUYsh9rch2w9kIF
         8iFVKRYYt9mC2D9sRDKfaEmGMgbUCJbXQ4i3SFK6uSiKnEdvShy6K7YptAUkTZs1shqv
         1LN4927pMFTw2E5xzD9i28wucEQ/l4ramiuL/ihOT75OyMjDzcF6iRyaHG/orEaxmlMF
         W7xg==
X-Gm-Message-State: AOAM532SOfjgANwwGdStuZBFThydJ7YU/GP6FoDhMA7uZ3umrnZaWDpf
        1esHKZbm3kz3soO0eCAg41WeMVGEaS59enKMKqq4OFTzncq+UhOe
X-Google-Smtp-Source: ABdhPJzATvG66iDiWsnk9V+x2N0xgxATTIy14bazridH8+hJaAYN1Kl5IRln8g1MlvHdvXBuspRm0Pdsx3RKb+HBTR8=
X-Received: by 2002:a17:906:54d3:: with SMTP id c19mr5711543ejp.408.1598057038351;
 Fri, 21 Aug 2020 17:43:58 -0700 (PDT)
MIME-Version: 1.0
References: <20200819224030.1615203-1-haoluo@google.com> <20200819224030.1615203-4-haoluo@google.com>
 <d50a1530-9a9f-45b2-5aba-05fe4b895fbc@fb.com> <CAEf4BzZmLUcw4M16U6w-s2Zd6KbsuY4dzzkeEBx9CejetT5BwQ@mail.gmail.com>
In-Reply-To: <CAEf4BzZmLUcw4M16U6w-s2Zd6KbsuY4dzzkeEBx9CejetT5BwQ@mail.gmail.com>
From:   Hao Luo <haoluo@google.com>
Date:   Fri, 21 Aug 2020 17:43:47 -0700
Message-ID: <CA+khW7jZc=p50eGUb6kLUq00bq8C_JmN2pJcu66uMUu3aL7=ZQ@mail.gmail.com>
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

On Fri, Aug 21, 2020 at 2:50 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Thu, Aug 20, 2020 at 10:22 AM Yonghong Song <yhs@fb.com> wrote:
> >
> >
> >
> > On 8/19/20 3:40 PM, Hao Luo wrote:
> > > For a ksym to be safely dereferenced and accessed, its type defined in
> > > bpf program should basically match its type defined in kernel. Implement
> > > a help function for a quick matching, which is used by libbpf when
> > > resolving the kernel btf_id of a ksym.
> > >
> > > Signed-off-by: Hao Luo <haoluo@google.com>
> > > ---
[...]
> > > +/*
> > > + * Match a ksym's type defined in bpf programs against its type encoded in
> > > + * kernel btf.
> > > + */
> > > +bool btf_ksym_type_match(const struct btf *ba, __u32 id_a,
> > > +                      const struct btf *bb, __u32 id_b)
> > > +{
>
> [...]
>
> > > +                     }
> > > +             }
> >
> > I am wondering whether this is too strict and how this can co-work with
> > CO-RE. Forcing users to write almost identical structure definition to
> > the underlying kernel will not be user friendly and may not work cross
> > kernel versions even if the field user cares have not changed.
> >
> > Maybe we can relax the constraint here. You can look at existing
> > libbpf CO-RE code.
>
> Right. Hao, can you just re-use bpf_core_types_are_compat() instead?
> See if semantics makes sense, but I think it should. BPF CO-RE has
> been permissive in terms of struct size and few other type aspects,
> because it handles relocations so well. This approach allows to not
> have to exactly match all possible variations of some struct
> definition, which is a big problem with ever-changing kernel data
> structures.
>

I have to say I hate myself writing another type comparison instead of
reusing the existing one. The issue is that when bpf_core_types_compat
compares names, it uses t1->name_off == t2->name_off. It is also used
in bpf_equal_common(). In my case, because these types are from two
different BTFs, their name_off are not expected to be the same, right?
I didn't find a good solution to refactor before posting this patch. I
think I can adapt bpf_core_type_compat() and pay more attention to
CO-RE.

> >
> > > +             break;
> > > +     }
>
> [...]
>
> > > +
> > >   struct btf_ext_sec_setup_param {
> > >       __u32 off;
> > >       __u32 len;
> > > diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
> > > index 91f0ad0e0325..5ef220e52485 100644
> > > --- a/tools/lib/bpf/btf.h
> > > +++ b/tools/lib/bpf/btf.h
> > > @@ -52,6 +52,8 @@ LIBBPF_API int btf__get_map_kv_tids(const struct btf *btf, const char *map_name,
> > >                                   __u32 expected_key_size,
> > >                                   __u32 expected_value_size,
> > >                                   __u32 *key_type_id, __u32 *value_type_id);
> > > +LIBBPF_API bool btf_ksym_type_match(const struct btf *ba, __u32 id_a,
> > > +                                 const struct btf *bb, __u32 id_b);
> > >
> > >   LIBBPF_API struct btf_ext *btf_ext__new(__u8 *data, __u32 size);
> > >   LIBBPF_API void btf_ext__free(struct btf_ext *btf_ext);
> >
> > The new API function should be added to libbpf.map.
>
> My question is why does this even have to be a public API?

I can fix. Please pardon my ignorance, what is the difference between
public and internal APIs? I wasn't sure, so used it improperly.

Thanks,
Hao
