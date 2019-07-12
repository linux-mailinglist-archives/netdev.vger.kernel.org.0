Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3F25673FD
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 19:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727035AbfGLRKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 13:10:25 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:37953 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726984AbfGLRKY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 13:10:24 -0400
Received: by mail-qt1-f194.google.com with SMTP id n11so8827621qtl.5;
        Fri, 12 Jul 2019 10:10:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Lw+6rtd9cUvwUqzwCU/4RKst7GkYxYhV3BtrqNap4jQ=;
        b=a2B6Uc7JQ+XjvJBfX4F3xHs2nIAlcxxvWZpiGVH6qt2amX2greN83rQuTO7iyDCunD
         /g+EC3RvaGM1KfAgo0Osp741b0YieLHgNwIG9QSb48g84UztCByW3Tl4wyfVQjf3dmHH
         5D8UdfBAzxdu0kYorwPzoy5Mp3NYUaCg04Z+yg1lMT92L27JRVStOvc7XnXRr8Ek+udQ
         JmJIRcmbJqH5tp4rNV6NuWLPj2Axs1PyBcO4CyXtu/55gYdeKK6a+cBtcnjEuU0mZnm5
         ieSSE+vnFvMJbr9c08kdNcvSi78zAGI6zcANcFlbqolXDxo4Q5Pp83/FJDpS6f8ggjQi
         wpUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Lw+6rtd9cUvwUqzwCU/4RKst7GkYxYhV3BtrqNap4jQ=;
        b=jByWkofwd1Y37YvSP7vcFN2lBRJp1W2unQAiH/e8Ac4nD56MADKdrMSGRjVNiS9kkl
         J89jGFsnuMPYpxt0+viBRMC91IgoLwVjAWrRkEiLfac//3uR4XMdxjA+QGSB87HwHhTD
         jh0M28VcP0tEzxV0ZOBkSsbpwml5HrTEpwbk1L2RiagbGtlcAxZ/ws/1pulqQ2ottDfC
         dquXrDsuBigXyLGFBHrytyVl62QOquqn5nF0f6+TN9elhnNigS6tsdwwv7VE340Wr+Gr
         OzkrFidiULwtxx7dKDYEdavx3Cl6p7weVdwOKlJl3fmprbSlX/QZitum/vPPk3dH3WWs
         1lmA==
X-Gm-Message-State: APjAAAUproqAKP1kAN5klP7TCOoHGsF5B+81bzUQ01e+zXf1d4ZS+90V
        hG9dJp4iuywDdqS6rXRKLNokwVRJmeYFyTYeYZ2nrkdi1ITGTNoP
X-Google-Smtp-Source: APXvYqz4lIIFUF9fwzLoCEGdh9Pmbq4midZLTqv/4f96/wlqrUYLHSUmoa+RfIY4rUN23ZzkPlu7abJTLOzwkqqxK1E=
X-Received: by 2002:a0c:ae50:: with SMTP id z16mr7457626qvc.60.1562951423541;
 Fri, 12 Jul 2019 10:10:23 -0700 (PDT)
MIME-Version: 1.0
References: <20190711065307.2425636-1-andriin@fb.com> <20190711065307.2425636-2-andriin@fb.com>
 <ad29872e-a127-f21e-5581-03df5a388a55@fb.com> <CAEf4Bzb4vzwRVPegF51Kv6oqTXUAWqnhK-jAVs8SESyh74+XTA@mail.gmail.com>
 <1563de9c-b5f6-cb15-18f6-cc01d3ddd110@fb.com>
In-Reply-To: <1563de9c-b5f6-cb15-18f6-cc01d3ddd110@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 12 Jul 2019 10:10:12 -0700
Message-ID: <CAEf4BzZ4ntBRY-+W=hSxrDMuSA53bXTqorAweQLqRPNDm_f9Aw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 1/3] bpf: fix BTF verifier size resolution logic
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>, Martin Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 12, 2019 at 8:47 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 7/12/19 8:36 AM, Andrii Nakryiko wrote:
> > On Thu, Jul 11, 2019 at 10:59 PM Yonghong Song <yhs@fb.com> wrote:
> >>
> >>
> >>
> >> On 7/10/19 11:53 PM, Andrii Nakryiko wrote:
> >>> BTF verifier has a size resolution bug which in some circumstances leads to
> >>> invalid size resolution for, e.g., TYPEDEF modifier.  This happens if we have
> >>> [1] PTR -> [2] TYPEDEF -> [3] ARRAY, in which case due to being in pointer
> >>> context ARRAY size won't be resolved (because for pointer it doesn't matter, so
> >>> it's a sink in pointer context), but it will be permanently remembered as zero
> >>> for TYPEDEF and TYPEDEF will be marked as RESOLVED. Eventually ARRAY size will
> >>> be resolved correctly, but TYPEDEF resolved_size won't be updated anymore.
> >>> This, subsequently, will lead to erroneous map creation failure, if that
> >>> TYPEDEF is specified as either key or value, as key_size/value_size won't
> >>> correspond to resolved size of TYPEDEF (kernel will believe it's zero).
> >>>
> >>> Note, that if BTF was ordered as [1] ARRAY <- [2] TYPEDEF <- [3] PTR, this
> >>> won't be a problem, as by the time we get to TYPEDEF, ARRAY's size is already
> >>> calculated and stored.
> >>>
> >>> This bug manifests itself in rejecting BTF-defined maps that use array
> >>> typedef as a value type:
> >>>
> >>> typedef int array_t[16];
> >>>
> >>> struct {
> >>>       __uint(type, BPF_MAP_TYPE_ARRAY);
> >>>       __type(value, array_t); /* i.e., array_t *value; */
> >>> } test_map SEC(".maps");
> >>>
> >>> The fix consists on not relying on modifier's resolved_size and instead using
> >>> modifier's resolved_id (type ID for "concrete" type to which modifier
> >>> eventually resolves) and doing size determination for that resolved type. This
> >>> allow to preserve existing "early DFS termination" logic for PTR or
> >>> STRUCT_OR_ARRAY contexts, but still do correct size determination for modifier
> >>> types.
> >>>
> >>> Fixes: eb3f595dab40 ("bpf: btf: Validate type reference")
> >>> Cc: Martin KaFai Lau <kafai@fb.com>
> >>> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> >>> ---
> >>>    kernel/bpf/btf.c | 14 ++++++++++----
> >>>    1 file changed, 10 insertions(+), 4 deletions(-)
> >>>
> >>> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> >>> index cad09858a5f2..22fe8b155e51 100644
> >>> --- a/kernel/bpf/btf.c
> >>> +++ b/kernel/bpf/btf.c
> >>> @@ -1073,11 +1073,18 @@ const struct btf_type *btf_type_id_size(const struct btf *btf,
> >>>                                 !btf_type_is_var(size_type)))
> >>>                        return NULL;
> >>>
> >>> -             size = btf->resolved_sizes[size_type_id];
> >>>                size_type_id = btf->resolved_ids[size_type_id];
> >>>                size_type = btf_type_by_id(btf, size_type_id);
> >>>                if (btf_type_nosize_or_null(size_type))
> >>>                        return NULL;
> >>> +             else if (btf_type_has_size(size_type))
> >>> +                     size = size_type->size;
> >>> +             else if (btf_type_is_array(size_type))
> >>> +                     size = btf->resolved_sizes[size_type_id];
> >>> +             else if (btf_type_is_ptr(size_type))
> >>> +                     size = sizeof(void *);
> >>> +             else
> >>> +                     return NULL;
> >>
> >> Looks good to me. Not sure whether we need to do any adjustment for
> >> var kind or not. Maybe we can do similar change in btf_var_resolve()
> >
> > I don't think btf_var_resolve() needs any change. btf_var_resolve
> > can't be referenced by modifier, so it doesn't have any problem. It's
> > similar to array in that it's size will be determined correctly.
>
> Correct. With your previous patch, the resolved_sizes[..] for var type
> is not used, so that is why I suggest to just set it to 0.

Ah, sorry, I misunderstood your initial suggestion. Yes,
resolved_sizes for VAR is not used anymore, so yeah, I'll set it to
zero.

>
> >
> > But I think btf_type_id_size() doesn't handle var case correctly, I'll do
> >
> > +             else if (btf_type_is_array(size_type) ||
> > btf_type_is_var(size_type))
> > +                     size = btf->resolved_sizes[size_type_id];
>
> This change should work too (to use btf->resolved_sizes[...]).

Reading code again, VAR's size is handled similar to modifier's size,
so I won't change btf_type_id_size().

Posting v3 soon.

>
> >
> > to fix that.
> >
> >> to btf_modifier_resolve()? But I do not think it impacts correctness
> >> similar to btf_modifier_resolve() below as you changed
> >> btf_type_id_size() implementation in the above.
> >>
> >>>        }
> >>>
> >>>        *type_id = size_type_id;
> >>> @@ -1602,7 +1609,6 @@ static int btf_modifier_resolve(struct btf_verifier_env *env,
> >>>        const struct btf_type *next_type;
> >>>        u32 next_type_id = t->type;
> >>>        struct btf *btf = env->btf;
> >>> -     u32 next_type_size = 0;
> >>>
> >>>        next_type = btf_type_by_id(btf, next_type_id);
> >>>        if (!next_type || btf_type_is_resolve_source_only(next_type)) {
> >>> @@ -1620,7 +1626,7 @@ static int btf_modifier_resolve(struct btf_verifier_env *env,
> >>>         * save us a few type-following when we use it later (e.g. in
> >>>         * pretty print).
> >>>         */
> >>> -     if (!btf_type_id_size(btf, &next_type_id, &next_type_size)) {
> >>> +     if (!btf_type_id_size(btf, &next_type_id, NULL)) {
> >>>                if (env_type_is_resolved(env, next_type_id))
> >>>                        next_type = btf_type_id_resolve(btf, &next_type_id);
> >>>
> >>> @@ -1633,7 +1639,7 @@ static int btf_modifier_resolve(struct btf_verifier_env *env,
> >>>                }
> >>>        }
> >>>
> >>> -     env_stack_pop_resolved(env, next_type_id, next_type_size);
> >>> +     env_stack_pop_resolved(env, next_type_id, 0);
> >>>
> >>>        return 0;
> >>>    }
> >>>
