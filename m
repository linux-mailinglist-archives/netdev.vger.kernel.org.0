Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A41DB206542
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 23:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387804AbgFWUME (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 16:12:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388912AbgFWULy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 16:11:54 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99BEAC061573;
        Tue, 23 Jun 2020 13:11:54 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id h23so9318599qtr.0;
        Tue, 23 Jun 2020 13:11:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nDwWByC8Ar56Z4zR3w5yx/IeXP1wkHtIj67Ct0+hsF8=;
        b=lziI7Y5pEMhhUHyHcGhVXL6VPqikxtRVMS4Xy4Z2yG93PRpKqwmaHlV3W8/n/1VEHi
         w45xDzMHS6yzfwz7TeO5vXkH70X8WAm3vDRb24D4OTa8bABIVx8mwcvVaHDBINgDtdLM
         GdyAQzPR8TXdJn/4IKo3Ol5dxqbsfuKoDf3SC3FpGzEenV9RypM9QGgFGpwO24i5Y2ly
         FS09D3bU32C2YBiK3kFGhB+rr75W23Xhh4tG27aBAMPgoSyAc/MvpYiiN17qZWc0ytHa
         avX8+FmTzv/XzM5IhfPy3fDQZhg3F9SvW+ykJBISzj08wUrRMD3ALiaprpwBvesJLsuW
         V95w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nDwWByC8Ar56Z4zR3w5yx/IeXP1wkHtIj67Ct0+hsF8=;
        b=VBe37vCGAPQbfwjrU7gH0D+6Yw6RpTb1pWy+9buSCJK/SREEpjdeNuOz0SjyCQkyci
         D5zH2AY9APiDRJsYfpFBPsfm3bKW9BD4IgtTC3HFVW1c8r3iLJyd1IrWsu77ZYFycVeC
         hnlmCdBpFqhKxWpTH4ZbS3s2XPdPup0Q8GaZGEj4PKNzaTLcQOcwNUAfPUWQ9pCvNBD2
         xbpBL15doSdPbsp51b/E0WXm4JZpIILsNbVYHvvKBoZsP7F1PR2env9pM/v64D89lnSF
         ULoPsBSbBfLUrsup0KzCV8TW7yMzyPVxQYCdEpvKjOlMlYQaNcjWKakzof84Q7Y3eSx2
         A5ng==
X-Gm-Message-State: AOAM53128R04u1ifxAwxY1B6yALq66iyIGTKgjxnxOGlyuz5IbNeFa3q
        4/SHn2BH2FsiH5jxSNtFSzjyCLtcCMcZDhKsTUtfZ1I2xbE=
X-Google-Smtp-Source: ABdhPJzpujLHGAOv3FOGumXzobOFnJX1IAMHmcycgQMqUboTFJDbal3lAymtGRg3XM3l2TfOT0gnC3Wv2eXDhXPa3Hk=
X-Received: by 2002:ac8:1991:: with SMTP id u17mr16003839qtj.93.1592943113685;
 Tue, 23 Jun 2020 13:11:53 -0700 (PDT)
MIME-Version: 1.0
References: <20200623003626.3072825-1-yhs@fb.com> <20200623003631.3073864-1-yhs@fb.com>
 <CAEf4BzaGWuAYzN2-+Gy9X8N2YPb341ZGugKzk78qiPURMgv7rw@mail.gmail.com>
 <26d6f7ee-28ea-80ba-fd76-e3b2f0327163@fb.com> <CAEf4BzYvra0bijcbzpBbwwtFQg4_8Uy3tGLwYYj=9CpkMPW=-w@mail.gmail.com>
 <bfd134a9-d808-d66d-3870-361f8f5aab64@fb.com>
In-Reply-To: <bfd134a9-d808-d66d-3870-361f8f5aab64@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 23 Jun 2020 13:11:42 -0700
Message-ID: <CAEf4BzYMG7xu2ot-8OVJjYG7w14OciKgN=hZombOqo=7d5oUNQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 05/15] bpf: add bpf_skc_to_tcp6_sock() helper
To:     Yonghong Song <yhs@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 23, 2020 at 12:47 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 6/23/20 11:23 AM, Andrii Nakryiko wrote:
> > On Tue, Jun 23, 2020 at 7:52 AM Yonghong Song <yhs@fb.com> wrote:
> >>
> >>
> >>
> >> On 6/22/20 11:39 PM, Andrii Nakryiko wrote:
> >>> On Mon, Jun 22, 2020 at 5:38 PM Yonghong Song <yhs@fb.com> wrote:
> >>>>
> >>>> The helper is used in tracing programs to cast a socket
> >>>> pointer to a tcp6_sock pointer.
> >>>> The return value could be NULL if the casting is illegal.
> >>>>
> >>>> A new helper return type RET_PTR_TO_BTF_ID_OR_NULL is added
> >>>> so the verifier is able to deduce proper return types for the helper.
> >>>>
> >>>> Different from the previous BTF_ID based helpers,
> >>>> the bpf_skc_to_tcp6_sock() argument can be several possible
> >>>> btf_ids. More specifically, all possible socket data structures
> >>>> with sock_common appearing in the first in the memory layout.
> >>>> This patch only added socket types related to tcp and udp.
> >>>>
> >>>> All possible argument btf_id and return value btf_id
> >>>> for helper bpf_skc_to_tcp6_sock() are pre-calculcated and
> >>>> cached. In the future, it is even possible to precompute
> >>>> these btf_id's at kernel build time.
> >>>>
> >>>> Acked-by: Martin KaFai Lau <kafai@fb.com>
> >>>> Signed-off-by: Yonghong Song <yhs@fb.com>
> >>>> ---
> >>>
> >>> Looks good to me as is, but see a few suggestions, they will probably
> >>> save me time at some point as well :)
> >>>
> >>> Acked-by: Andrii Nakryiko <andriin@fb.com>
> >>>
> >>>
> >>>>    include/linux/bpf.h            | 12 +++++
> >>>>    include/uapi/linux/bpf.h       |  9 +++-
> >>>>    kernel/bpf/btf.c               |  1 +
> >>>>    kernel/bpf/verifier.c          | 43 +++++++++++++-----
> >>>>    kernel/trace/bpf_trace.c       |  2 +
> >>>>    net/core/filter.c              | 80 ++++++++++++++++++++++++++++++++++
> >>>>    scripts/bpf_helpers_doc.py     |  2 +
> >>>>    tools/include/uapi/linux/bpf.h |  9 +++-
> >>>>    8 files changed, 146 insertions(+), 12 deletions(-)
> >>>>
> >>>
> >>> [...]
> >>>
> >>>> @@ -4815,6 +4826,18 @@ static int check_helper_call(struct bpf_verifier_env *env, int func_id, int insn
> >>>>                   regs[BPF_REG_0].type = PTR_TO_MEM_OR_NULL;
> >>>>                   regs[BPF_REG_0].id = ++env->id_gen;
> >>>>                   regs[BPF_REG_0].mem_size = meta.mem_size;
> >>>> +       } else if (fn->ret_type == RET_PTR_TO_BTF_ID_OR_NULL) {
> >>>> +               int ret_btf_id;
> >>>> +
> >>>> +               mark_reg_known_zero(env, regs, BPF_REG_0);
> >>>> +               regs[BPF_REG_0].type = PTR_TO_BTF_ID_OR_NULL;
> >>>> +               ret_btf_id = *fn->ret_btf_id;
> >>>
> >>> might be a good idea to check fb->ret_btf_id for NULL and print a
> >>> warning + return -EFAULT. It's not supposed to happen on properly
> >>> configured kernel, but during development this will save a bunch of
> >>> time and frustration for next person trying to add something with
> >>> RET_PTR_TO_BTF_ID_OR_NULL.
> >>
> >> I would like prefer to delay this with current code. Otherwise,
> >> it gives an impression fn->ret_btf_id might be NULL and it is
> >> actually never NULL. We can add NULL check if the future change
> >> requires it. I am not sure what the future change could be,
> >> but you need some way to get the return btf_id, the above is
> >> one of them.
> >
> > It's not **supposed** to be NULL, same as a bunch of other invariants
> > about BPF helper proto definitions, but verifier does check sanity for
> > such cases, instead of crashing. But up to you. I'm pretty sure
> > someone will trip up on this.
>
> I think there are certain expectation for argument reg_state vs. certain
> fields in the structure.
>
> int btf_resolve_helper_id(struct bpf_verifier_log *log,
>                            const struct bpf_func_proto *fn, int arg)
> {
>          int *btf_id = &fn->btf_id[arg];
>          int ret;
>
>          if (fn->arg_type[arg] != ARG_PTR_TO_BTF_ID)
>                  return -EINVAL;
>
>          ret = READ_ONCE(*btf_id);
>         ...
> }
>
> If ARG_PTR_TO_BTF_ID, the verifier did not really check
> whether btf_id pointer is valid or not. It just use it.

Right, it's not a universal rule. But grep for "misconfigured" in
kernel/bpf/verifier.c to see a bunch of places where the verifier
could crash on NULL dereference, but instead emits an error message
and returns failure.

This was a suggestion, I'll stop asking for this :)

>
> The same applies to the new return type. If in func_proto,
> somebody sets RET_PTR_TO_BTF_ID_OR_NULL, it is expected
> that func_proto->ret_btf_id is valid.
>
> Code review or feature selftest should catch errors
> if they are out-of-sync.
>
> >
> >>
> >>>
> >>>> +               if (ret_btf_id == 0) {
> >>>
> >>> This also has to be struct/union (after typedef/mods stripping, of
> >>> course). Or are there other cases?
> >>
> >> This is an "int". The func_proto difinition is below:
> >> int *ret_btf_id; /* return value btf_id */
> >
> > I meant the BTF type itself that this btf_id points to. Is there any
> > use case where this won't be a pointer to struct/union and instead
> > something like a pointer to an int?
>
> Maybe you misunderstood. The mechanism is similar to the argument btf_id
> encoding in func_proto's:
>
> static int bpf_seq_printf_btf_ids[5];
> ...
>          .btf_id         = bpf_seq_printf_btf_ids,
>
> func_proto->ret_btf_id will be a pointer to int which encodes the
> btf_id, not the btf_type.

I understand that. Say it points to value 25. BTF type with ID=25 is
going to be BTF_KIND_PTR -> BTF_KIND_STRUCT. I was wondering if we
want/need to check that it's always BTF_KIND_PTR -> (modifier)* ->
BTF_KIND_STRUCT/BTF_KIND_UNION. That's it.

>
> >
> >>
> >>>
> >>>> +                       verbose(env, "invalid return type %d of func %s#%d\n",
> >>>> +                               fn->ret_type, func_id_name(func_id), func_id);
> >>>> +                       return -EINVAL;
> >>>> +               }
> >>>> +               regs[BPF_REG_0].btf_id = ret_btf_id;
> >>>>           } else {
> >>>>                   verbose(env, "unknown return type %d of func %s#%d\n",
> >>>>                           fn->ret_type, func_id_name(func_id), func_id);
> >>>
> >>> [...]
> >>>
> >>>> +void init_btf_sock_ids(struct btf *btf)
> >>>> +{
> >>>> +       int i, btf_id;
> >>>> +
> >>>> +       for (i = 0; i < MAX_BTF_SOCK_TYPE; i++) {
> >>>> +               btf_id = btf_find_by_name_kind(btf, bpf_sock_types[i],
> >>>> +                                              BTF_KIND_STRUCT);
> >>>> +               if (btf_id > 0)
> >>>> +                       btf_sock_ids[i] = btf_id;
> >>>> +       }
> >>>> +}
> >>>
> >>> This will hopefully go away with Jiri's work on static BTF IDs, right?
> >>> So looking forward to that :)
> >>
> >> Yes. That's the plan.
> >>
> >>>
> >>>> +
> >>>> +static bool check_arg_btf_id(u32 btf_id, u32 arg)
> >>>> +{
> >>>> +       int i;
> >>>> +
> >>>> +       /* only one argument, no need to check arg */
> >>>> +       for (i = 0; i < MAX_BTF_SOCK_TYPE; i++)
> >>>> +               if (btf_sock_ids[i] == btf_id)
> >>>> +                       return true;
> >>>> +       return false;
> >>>> +}
> >>>> +
> >>>
> >>> [...]
> >>>
