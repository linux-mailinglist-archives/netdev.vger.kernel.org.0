Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA8C424E2DA
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 23:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbgHUVuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 17:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726187AbgHUVuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 17:50:16 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47A3CC061573;
        Fri, 21 Aug 2020 14:50:16 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id i10so1781223ybt.11;
        Fri, 21 Aug 2020 14:50:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LCtDZbEXzC+Kn+f0fxyMM1jOnFnep3y18ErpLmPyWt4=;
        b=T8qkn1gP+Rp85/WBW+E10QZI55mtY/lvclpr3P7fxqBrHSA7suC3XiloMsmuuWf/+m
         HmDmMB04s32ENwcls/J6AbATRIcvsmO+7lr+2ePM9UbcWDZC0tR1yvN1ch++35SfNpqN
         qV1Wx+XrikqB2RucXlQQro36UTEy8/13alnvL09oSLB1mp1Bnei89N9W7DWiwD6SQF5z
         NKD0AA5Cb/2D2oaZ1K7mIIiGD4z4kPLKHMzWUxBdW9+vr+buKs1ySwQVfukV11vWRVv5
         RrukKViMe3OkIWkbygbUP4X3ffqQBygwF0bZYkYHYoYESW/pmE0sAnHnnnaAXM0nHfNF
         8t/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LCtDZbEXzC+Kn+f0fxyMM1jOnFnep3y18ErpLmPyWt4=;
        b=VEmldfgKf4tdpxUyOhCwrQGBSmSX+sQ6g20MczEUldZci+vSlXQ6SNJshd61IFjyif
         6YiaSTyX8wH9+Kd4SsnOtjfUpbETXtT61Hn5bDwtjB7amNQFb/G/BxFdBJtF0R/ssC/2
         KNVJin++sohPxuwZBWTWwj8EdKzAIzzFypVCaf+UyjAZddQqItvN96xfXFfmpZg3emqk
         1Thu0yDpc0h/MG9QaofCnXNt19dPdiYFFCy7GzoHaO7F4evSAQiuZi8n4iq3PTLTx87k
         ykTItNkTuIWwKkvZxxEUBtBHljY4/7tAAWohUZRTwkNs4/PiMgGRs8ad0rdLpjJPf3y0
         lP3Q==
X-Gm-Message-State: AOAM531klb6ZjzL00vPj5jPubAIXYcnqPKcGmtT8aYm7bumghWBNiTek
        HVCESD8WuE/vAV4sd73Tu9i4pL22bSYlSqenAr8=
X-Google-Smtp-Source: ABdhPJxfazP3ESG4tMzcWn+ppdV1i2aqc1DNrqYNaLzJ3GbVy/tyCs1m/FpQa0NbRO17DXJ0YwXfaY18lWUIeijSrZs=
X-Received: by 2002:a25:2ad3:: with SMTP id q202mr6235577ybq.27.1598046615439;
 Fri, 21 Aug 2020 14:50:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200819224030.1615203-1-haoluo@google.com> <20200819224030.1615203-4-haoluo@google.com>
 <d50a1530-9a9f-45b2-5aba-05fe4b895fbc@fb.com>
In-Reply-To: <d50a1530-9a9f-45b2-5aba-05fe4b895fbc@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 21 Aug 2020 14:50:04 -0700
Message-ID: <CAEf4BzZmLUcw4M16U6w-s2Zd6KbsuY4dzzkeEBx9CejetT5BwQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 3/8] bpf: Introduce help function to validate
 ksym's type.
To:     Yonghong Song <yhs@fb.com>
Cc:     Hao Luo <haoluo@google.com>, Networking <netdev@vger.kernel.org>,
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

On Thu, Aug 20, 2020 at 10:22 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 8/19/20 3:40 PM, Hao Luo wrote:
> > For a ksym to be safely dereferenced and accessed, its type defined in
> > bpf program should basically match its type defined in kernel. Implement
> > a help function for a quick matching, which is used by libbpf when
> > resolving the kernel btf_id of a ksym.
> >
> > Signed-off-by: Hao Luo <haoluo@google.com>
> > ---
> >   tools/lib/bpf/btf.c | 171 ++++++++++++++++++++++++++++++++++++++++++++
> >   tools/lib/bpf/btf.h |   2 +
> >   2 files changed, 173 insertions(+)
> >
> > diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
> > index a3d259e614b0..2ff31f244d7a 100644
> > --- a/tools/lib/bpf/btf.c
> > +++ b/tools/lib/bpf/btf.c
> > @@ -1005,6 +1005,177 @@ int btf__get_map_kv_tids(const struct btf *btf, const char *map_name,
> >       return 0;
> >   }
> >
> > +/*
> > + * Basic type check for ksym support. Only checks type kind and resolved size.
> > + */
> > +static inline
> > +bool btf_ksym_equal_type(const struct btf *ba, __u32 type_a,
> > +                      const struct btf *bb, __u32 type_b)
>
> "ba" and "bb" is not descriptive. Maybe "btf_a" or "btf_b"?
> or even "btf1" or "btf2" since the number does not carry
> extra meaning compared to letters.
>
> The same for below, may be t1, t2?
>
> > +{
> > +     const struct btf_type *ta, *tb;
> > +
> > +     ta = btf__type_by_id(ba, type_a);
> > +     tb = btf__type_by_id(bb, type_b);
> > +
> > +     /* compare type kind */
> > +     if (btf_kind(ta) != btf_kind(tb))
> > +             return false;
> > +
> > +     /* compare resolved type size */
> > +     return btf__resolve_size(ba, type_a) == btf__resolve_size(bb, type_b);
> > +}
> > +
> > +/*
> > + * Match a ksym's type defined in bpf programs against its type encoded in
> > + * kernel btf.
> > + */
> > +bool btf_ksym_type_match(const struct btf *ba, __u32 id_a,
> > +                      const struct btf *bb, __u32 id_b)
> > +{

[...]

> > +                     }
> > +             }
>
> I am wondering whether this is too strict and how this can co-work with
> CO-RE. Forcing users to write almost identical structure definition to
> the underlying kernel will not be user friendly and may not work cross
> kernel versions even if the field user cares have not changed.
>
> Maybe we can relax the constraint here. You can look at existing
> libbpf CO-RE code.

Right. Hao, can you just re-use bpf_core_types_are_compat() instead?
See if semantics makes sense, but I think it should. BPF CO-RE has
been permissive in terms of struct size and few other type aspects,
because it handles relocations so well. This approach allows to not
have to exactly match all possible variations of some struct
definition, which is a big problem with ever-changing kernel data
structures.

>
> > +             break;
> > +     }

[...]

> > +
> >   struct btf_ext_sec_setup_param {
> >       __u32 off;
> >       __u32 len;
> > diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
> > index 91f0ad0e0325..5ef220e52485 100644
> > --- a/tools/lib/bpf/btf.h
> > +++ b/tools/lib/bpf/btf.h
> > @@ -52,6 +52,8 @@ LIBBPF_API int btf__get_map_kv_tids(const struct btf *btf, const char *map_name,
> >                                   __u32 expected_key_size,
> >                                   __u32 expected_value_size,
> >                                   __u32 *key_type_id, __u32 *value_type_id);
> > +LIBBPF_API bool btf_ksym_type_match(const struct btf *ba, __u32 id_a,
> > +                                 const struct btf *bb, __u32 id_b);
> >
> >   LIBBPF_API struct btf_ext *btf_ext__new(__u8 *data, __u32 size);
> >   LIBBPF_API void btf_ext__free(struct btf_ext *btf_ext);
>
> The new API function should be added to libbpf.map.

My question is why does this even have to be a public API?
