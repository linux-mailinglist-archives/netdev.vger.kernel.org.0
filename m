Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB206514B
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 06:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727774AbfGKE4j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 00:56:39 -0400
Received: from mail-yw1-f68.google.com ([209.85.161.68]:45527 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725963AbfGKE4j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 00:56:39 -0400
Received: by mail-yw1-f68.google.com with SMTP id m16so1683935ywh.12;
        Wed, 10 Jul 2019 21:56:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8kernPxKqBCueXBoaza253A523H7ruFc7m+roLUJLMY=;
        b=oohuWeaSLtrIy6Eyz9zUPxnfuzsrp9JGGhvhbWwi7dP7nU4WV6MnCNJJr///jtQVq1
         g6fG2S6UMm3x21XT568HnEc4ljEcElzQWaXx7oWn8D0/9tpb6j0+nUZeIyuKGvgFNSzH
         mCciZ1S/R9JJhon0Y4zxgz5DjjmTOs8HbywtdonBqAwIGW7Iw+sfflWjnUdk5LRxcBrc
         OYq1PEvH6g111XCeOtnBdUBwfp70pt7C6OZTPdMGUorCTf5m6nyVEHOs3Mx0WzZAoB9/
         HyaHlsaM7EeJs4+USZxkjT0/xbIocU7LjUXd10T4ogy2+oazoCWGqvEujYQzbZ5sqq+9
         Z6Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8kernPxKqBCueXBoaza253A523H7ruFc7m+roLUJLMY=;
        b=UUJy//snEYI3dwBRlyZ7dsATmqzAicpzrpoDZDwu0fgiXuLUVlY5PV3OlvP9OJZrS0
         zLe0jWXI5i7p55pcPGPsW6Bj/yTcWbJN1E2J2iSGABaJNo0XMhkqHiMoZqNnUrd2uo4p
         TW5qQENxcXQ9RQEv5BDswMjCxDXIVPjhMJjhSJnh2122vaKGUqdrCZwZy7NwPzDoYR3r
         0Ck8mVIx/bGZHEnaXsGBvrdhLfTB8OIxBT/aC7MIoLCUreVHUMob4FwK8P42kOGxGiPb
         WP9icCrYEDgRT4RBUgxPex1mh2BmNtZQcP5yNVhqcHolLLJRZ8VjvgbULSMjm8KWhRUO
         uWJA==
X-Gm-Message-State: APjAAAU7SBjISaUX/AvFwExItUTm0SFToX2OR5ZQaY5SJlBPyDnckSLw
        r2Q+kt0DRbQzi3lVJeoFzlVPozLlr076E0o2PhdaIYHHvd11sA==
X-Google-Smtp-Source: APXvYqwerfLx/7FOYPnh+1IMgBvekfr4vyapSajMcXgDsLNC//JurqTQfwcn6WzTdILCdXZKS0bT2sYbGORvirEgb34=
X-Received: by 2002:ac8:6601:: with SMTP id c1mr1239041qtp.93.1562820997809;
 Wed, 10 Jul 2019 21:56:37 -0700 (PDT)
MIME-Version: 1.0
References: <20190710080840.2613160-1-andriin@fb.com> <f6bc7a95-e8e1-eec4-9728-3b9e36b434fa@fb.com>
 <CAEf4BzaVouFd=3whC1EjhQ9mit62b-C+NhQuW4RiXW02Rq_1Ug@mail.gmail.com>
 <304d8535-5043-836d-2933-1a5efb7aec72@fb.com> <CAEf4Bza6Y87C2_Fobj9CwU-2YRTU32S61f8_8CQdhMPenJiJZQ@mail.gmail.com>
 <05db3afa-b94e-d0ba-7d61-ec1bf9a82777@fb.com>
In-Reply-To: <05db3afa-b94e-d0ba-7d61-ec1bf9a82777@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 10 Jul 2019 21:56:26 -0700
Message-ID: <CAEf4BzYoPUa2DOH-neH70wj4NjZK89UbX3igYk2H84ryx4=a4A@mail.gmail.com>
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

On Wed, Jul 10, 2019 at 9:14 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 7/10/19 6:45 PM, Andrii Nakryiko wrote:
> > On Wed, Jul 10, 2019 at 5:36 PM Yonghong Song <yhs@fb.com> wrote:
> >>
> >>
> >>
> >> On 7/10/19 5:29 PM, Andrii Nakryiko wrote:
> >>> On Wed, Jul 10, 2019 at 5:16 PM Yonghong Song <yhs@fb.com> wrote:
> >>>>
> >>>>
> >>>>
> >>>> On 7/10/19 1:08 AM, Andrii Nakryiko wrote:
> >>>>> BTF verifier has Different logic depending on whether we are following
> >>>>> a PTR or STRUCT/ARRAY (or something else). This is an optimization to
> >>>>> stop early in DFS traversal while resolving BTF types. But it also
> >>>>> results in a size resolution bug, when there is a chain, e.g., of PTR ->
> >>>>> TYPEDEF -> ARRAY, in which case due to being in pointer context ARRAY
> >>>>> size won't be resolved, as it is considered to be a sink for pointer,
> >>>>> leading to TYPEDEF being in RESOLVED state with zero size, which is
> >>>>> completely wrong.
> >>>>>
> >>>>> Optimization is doubtful, though, as btf_check_all_types() will iterate
> >>>>> over all BTF types anyways, so the only saving is a potentially slightly
> >>>>> shorter stack. But correctness is more important that tiny savings.
> >>>>>
> >>>>> This bug manifests itself in rejecting BTF-defined maps that use array
> >>>>> typedef as a value type:
> >>>>>
> >>>>> typedef int array_t[16];
> >>>>>
> >>>>> struct {
> >>>>>         __uint(type, BPF_MAP_TYPE_ARRAY);
> >>>>>         __type(value, array_t); /* i.e., array_t *value; */
> >>>>> } test_map SEC(".maps");
> >>>>>
> >>>>> Fixes: eb3f595dab40 ("bpf: btf: Validate type reference")
> >>>>> Cc: Martin KaFai Lau <kafai@fb.com>
> >>>>> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> >>>>
> >>>> The change seems okay to me. Currently, looks like intermediate
> >>>> modifier type will carry size = 0 (in the internal data structure).
> >>>
> >>> Yes, which is totally wrong, especially that we use that size in some
> >>> cases to reject map with specified BTF.
> >>>
> >>>>
> >>>> If we remove RESOLVE logic, we probably want to double check
> >>>> whether we handle circular types correctly or not. Maybe we will
> >>>> be okay if all self tests pass.
> >>>
> >>> I checked, it does. We'll attempt to add referenced type unless it's a
> >>> "resolve sink" (where size is immediately known) or is already
> >>> resolved (it's state is RESOLVED). In other cases, we'll attempt to
> >>> env_stack_push(), which check that the state of that type is
> >>> NOT_VISITED. If it's RESOLVED or VISITED, it returns -EEXISTS. When
> >>> type is added into the stack, it's resolve state goes from NOT_VISITED
> >>> to VISITED.
> >>>
> >>> So, if there is a loop, then we'll detect it as soon as we'll attempt
> >>> to add the same type onto the stack second time.
> >>>
> >>>>
> >>>> I may still be worthwhile to qualify the RESOLVE optimization benefit
> >>>> before removing it.
> >>>
> >>> I don't think there is any, because every type will be visited exactly
> >>> once, due to DFS nature of algorithm. The only difference is that if
> >>> we have a long chain of modifiers, we can technically reach the max
> >>> limit and fail. But at 32 I think it's pretty unrealistic to have such
> >>> a long chain of PTR/TYPEDEF/CONST/VOLATILE/RESTRICTs :)
> >>>
> >>>>
> >>>> Another possible change is, for external usage, removing
> >>>> modifiers, before checking the size, something like below.
> >>>> Note that I am not strongly advocating my below patch as
> >>>> it has the same shortcoming that maintained modifier type
> >>>> size may not be correct.
> >>>
> >>> I don't think your patch helps, it can actually confuse things even
> >>> more. It skips modifiers until underlying type is found, but you still
> >>> don't guarantee that at that time that underlying type will have its
> >>> size resolved.
> >>
> >> It actually does help. It does not change the internal btf type
> >> traversal algorithms. It only change the implementation of
> >> an external API btf_type_id_size(). Previously, this function
> >> is used by externals and internal btf.c. I broke it into two,
> >> one internal __btf_type_id_size(), and another external
> >> btf_type_id_size(). The external one removes modifier before
> >> finding type size. The external one is typically used only
> >> after btf is validated.
> >
> > Sure, for external callers yes, it solves the problem. But there is
> > deeper problem: we mark modifier types RESOLVED before types they
> > ultimately point to are resolved. Then in all those btf_xxx_resolve()
> > functions we have check:
> >
> > if (!env_type_is_resolve_sink && !env_type_is_resolved)
> >    return env_stack_push();
> > else {
> >
> >    /* here we assume that we can calculate size of the type */
> >    /* so even if we traverse through all the modifiers and find
> > underlying type */
> >    /* that type will have resolved_size = 0, because we haven't
> > processed it yet */
> >    /* but we will just incorrectly assume that zero is *final* size */
> > }
> >
> > So I think that your patch is still just hiding the problem, not solving it.
> >
> > BTW, I've also identified part of btf_ptr_resolve() logic that can be
> > now safely removed (it's a special case that "restarts" DFS traversal
> > for modifiers, because they could have been prematurely marked
> > resolved). This is another sign that there is something wrong in an
> > algorithm.
> >
> > I'd rather remove unnecessary complexity and fix underlying problem,
> > especially given that there is no performance or correctness penalty.
>
> Could you create a special btf with type like
> typedef int a1;
> typedef a1 a2;
> ...
> typedef a65533 a65532;
> (maximum kernel allowed number of types is 64KB)
>
> In the BTF, the typedef order is reverse
> 1: typedef a65533 to 2
> 2: typedef ... to 3
> 3 ...
>
> So kernel won't run into deep recursion or panic?

Yeah I was just thinking about the need to generate artificially
constructed BTFs to stress-test BTF verification. Will add something.

>
> Thanks.
>
> >
> > I'll post v2 soon.
> >
> >>
> >> Will go through your other comments later.
> >>
> >>>
> >>>>
> >>>> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> >>>> index 546ebee39e2a..6f927c3e0a89 100644
> >>>> --- a/kernel/bpf/btf.c
> >>>> +++ b/kernel/bpf/btf.c
> >>>> @@ -620,6 +620,54 @@ static bool btf_type_int_is_regular(const struct
> >>>> btf_type *t)
> >>>>            return true;
> >>>>     }
> >>>>
> >>>> +static const struct btf_type *__btf_type_id_size(const struct btf *btf,
> >>>> +                                                u32 *type_id, u32
> >>>> *ret_size,
> >>>> +                                                bool skip_modifier)
> >>>> +{
> >>>> +       const struct btf_type *size_type;
> >>>> +       u32 size_type_id = *type_id;
> >>>> +       u32 size = 0;
> >>>> +
> >>>> +       size_type = btf_type_by_id(btf, size_type_id);
> >>>> +       if (size_type && skip_modifier) {
> >>>> +               while (btf_type_is_modifier(size_type))
> >>>> +                       size_type = btf_type_by_id(btf, size_type->type);
> >>>> +       }
> >>>> +
> >>>> +       if (btf_type_nosize_or_null(size_type))
> >>>> +               return NULL;
> >>>> +
> >>>> +       if (btf_type_has_size(size_type)) {
> >>>> +               size = size_type->size;
> >>>> +       } else if (btf_type_is_array(size_type)) {
> >>>> +               size = btf->resolved_sizes[size_type_id];
> >>>> +       } else if (btf_type_is_ptr(size_type)) {
> >>>> +               size = sizeof(void *);
> >>>> +       } else {
> >>>> +               if (WARN_ON_ONCE(!btf_type_is_modifier(size_type) &&
> >>>> +                                !btf_type_is_var(size_type)))
> >>>> +                       return NULL;
> >>>> +
> >>>> +               size = btf->resolved_sizes[size_type_id];
> >>>> +               size_type_id = btf->resolved_ids[size_type_id];
> >>>> +               size_type = btf_type_by_id(btf, size_type_id);
> >>>> +               if (btf_type_nosize_or_null(size_type))
> >>>> +                       return NULL;
> >>>> +       }
> >>>> +
> >>>> +       *type_id = size_type_id;
> >>>> +       if (ret_size)
> >>>> +               *ret_size = size;
> >>>> +
> >>>> +       return size_type;
> >>>> +}
> >>>> +
> >> [...]
> >
