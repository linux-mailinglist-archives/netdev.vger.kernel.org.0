Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D852B64FF6
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 03:45:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727857AbfGKBpZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 21:45:25 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:43796 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727463AbfGKBpY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 21:45:24 -0400
Received: by mail-qk1-f196.google.com with SMTP id m14so3522814qka.10;
        Wed, 10 Jul 2019 18:45:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5K81MBLH00J2kPIBYEvDIWJr5eCVy3Vqr9oFm8Prox0=;
        b=TUaTL55wLcx1xfbTjhZdQfKoHy7pjivxQgi06Pj0HON7KChhTV+IXd14KO8b7UCqGR
         t00mUCcswM7tRhBV0n/k9yeIhokVVPSK4QzY/EgZCpzECwcSfpM8xDs8wkMXZ2uq9Hl3
         6JN/VIaA9jE1zLrBTocWAJvr8uHDOYtBVnRjwyvESG33YZ9RNeezb1NGO4c9uMSU/KzF
         SxvBEBoM2Vll4y8MuKgx8QgE4ysWU2Wd7qVO9nFen1omzKZI18Eji3bLYQrXgNL8GYKJ
         cOwP8lSzn3om67I1X12sBFOZgA+2Hm4CMOyqa3u8DqOFVMAzgOdjLbX7lWlz+1Z1HJMU
         zfnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5K81MBLH00J2kPIBYEvDIWJr5eCVy3Vqr9oFm8Prox0=;
        b=UDXJfJCe5FmLIExJOnwvItzSDjBI4xlIIxetV+1VItIzV44ATgsDsNeduVhPjY+fYY
         dycc++Aw3OjAIOBsqUsKk7h8qW7dh/UjVn2sBf7cO+uhlAUQNtQ3Xy0grC+DfrsdC53I
         6AWqkqP3z+KNFM7+DCKFnUDAYGpUbgY2LQlZmkEf7xANoxivymUEZ3QM8UIgLmiKkz2f
         tK6XI0+tk+UI6/6GzHiiI3QK6M1Q/gwFXDbfLUKA9KtAFFQJpzku2xr/oWvSrH0kOocw
         27cPZfKyb+A5HGKczBg0icVeFocbZc3odeTE3L5fA5jVxZ5U7k81zwVGI+EOSuj1Tt/R
         XZJw==
X-Gm-Message-State: APjAAAXDdS2lXxQcqNihN0kNHLkkL6Y5u/vfEW9XdeCCAR8IHDKPYhen
        P75N6wxV2SDxI+scTm0f4T0QcozEKbtU1HPHbjs=
X-Google-Smtp-Source: APXvYqzhu01utxChvReSL5YYaHLLnxISsUDDaAs0enEbEotLAL5LAfr5rOzglI3nvvskRVMb5wS6w6SeMR2qZMImFJE=
X-Received: by 2002:a37:660d:: with SMTP id a13mr1097416qkc.36.1562809523195;
 Wed, 10 Jul 2019 18:45:23 -0700 (PDT)
MIME-Version: 1.0
References: <20190710080840.2613160-1-andriin@fb.com> <f6bc7a95-e8e1-eec4-9728-3b9e36b434fa@fb.com>
 <CAEf4BzaVouFd=3whC1EjhQ9mit62b-C+NhQuW4RiXW02Rq_1Ug@mail.gmail.com> <304d8535-5043-836d-2933-1a5efb7aec72@fb.com>
In-Reply-To: <304d8535-5043-836d-2933-1a5efb7aec72@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 10 Jul 2019 18:45:12 -0700
Message-ID: <CAEf4Bza6Y87C2_Fobj9CwU-2YRTU32S61f8_8CQdhMPenJiJZQ@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: fix BTF verifier size resolution logic
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>, Martin Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 10, 2019 at 5:36 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 7/10/19 5:29 PM, Andrii Nakryiko wrote:
> > On Wed, Jul 10, 2019 at 5:16 PM Yonghong Song <yhs@fb.com> wrote:
> >>
> >>
> >>
> >> On 7/10/19 1:08 AM, Andrii Nakryiko wrote:
> >>> BTF verifier has Different logic depending on whether we are following
> >>> a PTR or STRUCT/ARRAY (or something else). This is an optimization to
> >>> stop early in DFS traversal while resolving BTF types. But it also
> >>> results in a size resolution bug, when there is a chain, e.g., of PTR ->
> >>> TYPEDEF -> ARRAY, in which case due to being in pointer context ARRAY
> >>> size won't be resolved, as it is considered to be a sink for pointer,
> >>> leading to TYPEDEF being in RESOLVED state with zero size, which is
> >>> completely wrong.
> >>>
> >>> Optimization is doubtful, though, as btf_check_all_types() will iterate
> >>> over all BTF types anyways, so the only saving is a potentially slightly
> >>> shorter stack. But correctness is more important that tiny savings.
> >>>
> >>> This bug manifests itself in rejecting BTF-defined maps that use array
> >>> typedef as a value type:
> >>>
> >>> typedef int array_t[16];
> >>>
> >>> struct {
> >>>        __uint(type, BPF_MAP_TYPE_ARRAY);
> >>>        __type(value, array_t); /* i.e., array_t *value; */
> >>> } test_map SEC(".maps");
> >>>
> >>> Fixes: eb3f595dab40 ("bpf: btf: Validate type reference")
> >>> Cc: Martin KaFai Lau <kafai@fb.com>
> >>> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> >>
> >> The change seems okay to me. Currently, looks like intermediate
> >> modifier type will carry size = 0 (in the internal data structure).
> >
> > Yes, which is totally wrong, especially that we use that size in some
> > cases to reject map with specified BTF.
> >
> >>
> >> If we remove RESOLVE logic, we probably want to double check
> >> whether we handle circular types correctly or not. Maybe we will
> >> be okay if all self tests pass.
> >
> > I checked, it does. We'll attempt to add referenced type unless it's a
> > "resolve sink" (where size is immediately known) or is already
> > resolved (it's state is RESOLVED). In other cases, we'll attempt to
> > env_stack_push(), which check that the state of that type is
> > NOT_VISITED. If it's RESOLVED or VISITED, it returns -EEXISTS. When
> > type is added into the stack, it's resolve state goes from NOT_VISITED
> > to VISITED.
> >
> > So, if there is a loop, then we'll detect it as soon as we'll attempt
> > to add the same type onto the stack second time.
> >
> >>
> >> I may still be worthwhile to qualify the RESOLVE optimization benefit
> >> before removing it.
> >
> > I don't think there is any, because every type will be visited exactly
> > once, due to DFS nature of algorithm. The only difference is that if
> > we have a long chain of modifiers, we can technically reach the max
> > limit and fail. But at 32 I think it's pretty unrealistic to have such
> > a long chain of PTR/TYPEDEF/CONST/VOLATILE/RESTRICTs :)
> >
> >>
> >> Another possible change is, for external usage, removing
> >> modifiers, before checking the size, something like below.
> >> Note that I am not strongly advocating my below patch as
> >> it has the same shortcoming that maintained modifier type
> >> size may not be correct.
> >
> > I don't think your patch helps, it can actually confuse things even
> > more. It skips modifiers until underlying type is found, but you still
> > don't guarantee that at that time that underlying type will have its
> > size resolved.
>
> It actually does help. It does not change the internal btf type
> traversal algorithms. It only change the implementation of
> an external API btf_type_id_size(). Previously, this function
> is used by externals and internal btf.c. I broke it into two,
> one internal __btf_type_id_size(), and another external
> btf_type_id_size(). The external one removes modifier before
> finding type size. The external one is typically used only
> after btf is validated.

Sure, for external callers yes, it solves the problem. But there is
deeper problem: we mark modifier types RESOLVED before types they
ultimately point to are resolved. Then in all those btf_xxx_resolve()
functions we have check:

if (!env_type_is_resolve_sink && !env_type_is_resolved)
  return env_stack_push();
else {

  /* here we assume that we can calculate size of the type */
  /* so even if we traverse through all the modifiers and find
underlying type */
  /* that type will have resolved_size = 0, because we haven't
processed it yet */
  /* but we will just incorrectly assume that zero is *final* size */
}

So I think that your patch is still just hiding the problem, not solving it.

BTW, I've also identified part of btf_ptr_resolve() logic that can be
now safely removed (it's a special case that "restarts" DFS traversal
for modifiers, because they could have been prematurely marked
resolved). This is another sign that there is something wrong in an
algorithm.

I'd rather remove unnecessary complexity and fix underlying problem,
especially given that there is no performance or correctness penalty.

I'll post v2 soon.

>
> Will go through your other comments later.
>
> >
> >>
> >> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> >> index 546ebee39e2a..6f927c3e0a89 100644
> >> --- a/kernel/bpf/btf.c
> >> +++ b/kernel/bpf/btf.c
> >> @@ -620,6 +620,54 @@ static bool btf_type_int_is_regular(const struct
> >> btf_type *t)
> >>           return true;
> >>    }
> >>
> >> +static const struct btf_type *__btf_type_id_size(const struct btf *btf,
> >> +                                                u32 *type_id, u32
> >> *ret_size,
> >> +                                                bool skip_modifier)
> >> +{
> >> +       const struct btf_type *size_type;
> >> +       u32 size_type_id = *type_id;
> >> +       u32 size = 0;
> >> +
> >> +       size_type = btf_type_by_id(btf, size_type_id);
> >> +       if (size_type && skip_modifier) {
> >> +               while (btf_type_is_modifier(size_type))
> >> +                       size_type = btf_type_by_id(btf, size_type->type);
> >> +       }
> >> +
> >> +       if (btf_type_nosize_or_null(size_type))
> >> +               return NULL;
> >> +
> >> +       if (btf_type_has_size(size_type)) {
> >> +               size = size_type->size;
> >> +       } else if (btf_type_is_array(size_type)) {
> >> +               size = btf->resolved_sizes[size_type_id];
> >> +       } else if (btf_type_is_ptr(size_type)) {
> >> +               size = sizeof(void *);
> >> +       } else {
> >> +               if (WARN_ON_ONCE(!btf_type_is_modifier(size_type) &&
> >> +                                !btf_type_is_var(size_type)))
> >> +                       return NULL;
> >> +
> >> +               size = btf->resolved_sizes[size_type_id];
> >> +               size_type_id = btf->resolved_ids[size_type_id];
> >> +               size_type = btf_type_by_id(btf, size_type_id);
> >> +               if (btf_type_nosize_or_null(size_type))
> >> +                       return NULL;
> >> +       }
> >> +
> >> +       *type_id = size_type_id;
> >> +       if (ret_size)
> >> +               *ret_size = size;
> >> +
> >> +       return size_type;
> >> +}
> >> +
> [...]
