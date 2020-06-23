Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 171E7205A6C
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 20:23:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733151AbgFWSXc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 14:23:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732549AbgFWSXb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 14:23:31 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34F50C061573;
        Tue, 23 Jun 2020 11:23:30 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id d12so10141144qvn.0;
        Tue, 23 Jun 2020 11:23:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bMQYpDIy8pTiMh7h2c1eZC67U8/qIiWpyxsjALDYCWo=;
        b=loJRFe/jHrJQ8t6YMezt5Ndu1U8t+tbQUawJaKk7Beb99o5Zq9/76Cdvp8oA6wcMP8
         7OAGAQLIX3Ue6N2Q2WyGwN05y8NLEGyGXYokyO52koIKTxJCoQQr0GflkiOPFy4nqF2V
         EU4xHYjNUvZo3473Ue84zHLT8vUguyajN/bMJ3q8XurD+P+oy/qBJrjd1hqvP4WQLI+O
         sVBRewMe9ykcuLy5rC+xzA7eSFpZcVMpmBSUqvTsjTdGS9g4uN45irakWEoqpW+U8yc9
         1kbCVS4WzYt2Qgizy/kaMazcNrgv09u3CsBkkTn1EFwp+FvNUVW7rNa2wpR6Wblb9gUL
         QfQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bMQYpDIy8pTiMh7h2c1eZC67U8/qIiWpyxsjALDYCWo=;
        b=bsP1RAIQqEzTexPQUPEHuFCmzhIws0KooLWiZQ866dRNn/1UJgc+Fwbeh8NgfSWlhD
         35DtX3le6+Kbv5sNGaKu9RPZeEC/WQw7kt2FmDSalS7fF1Mgj3qOt+Zi0AUI+h2Z4dNM
         O5jWlntRZ5gRcEKTNeLeP7Jbdpsm2+dAKxgl39kTKT8YRCFHMCPWF+g3DQGc2aLNXTqt
         lyN6j3L3tUijJ1YP8LTnyvnXx0MVLBtzKmKQp7zXLShHz68Q75yzr+on8qxixf1a7CSB
         zlvwVPeHuDxyO1QkLOAWBDQNZFO3hBaterRw/p8VfJ9K/Ekr2MBF5LGSz4PgUvjZVTlq
         J83w==
X-Gm-Message-State: AOAM532sPH4EteYeXsSwy8XXvDidX/EiU3ztvK0opYQcxPNCd6IE1VDO
        6BAYs77kQ5t3jPo3I4/pjngu4opkuqv4syjxeLE=
X-Google-Smtp-Source: ABdhPJyCJ/PirNwivAXwaq5/fiUQWp9SkesGqBhWIKE22mhJMJBEjpw1fXrVXUYritm+QuE4qv5JmNM+QaNL0DiIG3g=
X-Received: by 2002:a05:6214:8f4:: with SMTP id dr20mr15073779qvb.228.1592936609325;
 Tue, 23 Jun 2020 11:23:29 -0700 (PDT)
MIME-Version: 1.0
References: <20200623003626.3072825-1-yhs@fb.com> <20200623003631.3073864-1-yhs@fb.com>
 <CAEf4BzaGWuAYzN2-+Gy9X8N2YPb341ZGugKzk78qiPURMgv7rw@mail.gmail.com> <26d6f7ee-28ea-80ba-fd76-e3b2f0327163@fb.com>
In-Reply-To: <26d6f7ee-28ea-80ba-fd76-e3b2f0327163@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 23 Jun 2020 11:23:18 -0700
Message-ID: <CAEf4BzYvra0bijcbzpBbwwtFQg4_8Uy3tGLwYYj=9CpkMPW=-w@mail.gmail.com>
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

On Tue, Jun 23, 2020 at 7:52 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 6/22/20 11:39 PM, Andrii Nakryiko wrote:
> > On Mon, Jun 22, 2020 at 5:38 PM Yonghong Song <yhs@fb.com> wrote:
> >>
> >> The helper is used in tracing programs to cast a socket
> >> pointer to a tcp6_sock pointer.
> >> The return value could be NULL if the casting is illegal.
> >>
> >> A new helper return type RET_PTR_TO_BTF_ID_OR_NULL is added
> >> so the verifier is able to deduce proper return types for the helper.
> >>
> >> Different from the previous BTF_ID based helpers,
> >> the bpf_skc_to_tcp6_sock() argument can be several possible
> >> btf_ids. More specifically, all possible socket data structures
> >> with sock_common appearing in the first in the memory layout.
> >> This patch only added socket types related to tcp and udp.
> >>
> >> All possible argument btf_id and return value btf_id
> >> for helper bpf_skc_to_tcp6_sock() are pre-calculcated and
> >> cached. In the future, it is even possible to precompute
> >> these btf_id's at kernel build time.
> >>
> >> Acked-by: Martin KaFai Lau <kafai@fb.com>
> >> Signed-off-by: Yonghong Song <yhs@fb.com>
> >> ---
> >
> > Looks good to me as is, but see a few suggestions, they will probably
> > save me time at some point as well :)
> >
> > Acked-by: Andrii Nakryiko <andriin@fb.com>
> >
> >
> >>   include/linux/bpf.h            | 12 +++++
> >>   include/uapi/linux/bpf.h       |  9 +++-
> >>   kernel/bpf/btf.c               |  1 +
> >>   kernel/bpf/verifier.c          | 43 +++++++++++++-----
> >>   kernel/trace/bpf_trace.c       |  2 +
> >>   net/core/filter.c              | 80 ++++++++++++++++++++++++++++++++++
> >>   scripts/bpf_helpers_doc.py     |  2 +
> >>   tools/include/uapi/linux/bpf.h |  9 +++-
> >>   8 files changed, 146 insertions(+), 12 deletions(-)
> >>
> >
> > [...]
> >
> >> @@ -4815,6 +4826,18 @@ static int check_helper_call(struct bpf_verifier_env *env, int func_id, int insn
> >>                  regs[BPF_REG_0].type = PTR_TO_MEM_OR_NULL;
> >>                  regs[BPF_REG_0].id = ++env->id_gen;
> >>                  regs[BPF_REG_0].mem_size = meta.mem_size;
> >> +       } else if (fn->ret_type == RET_PTR_TO_BTF_ID_OR_NULL) {
> >> +               int ret_btf_id;
> >> +
> >> +               mark_reg_known_zero(env, regs, BPF_REG_0);
> >> +               regs[BPF_REG_0].type = PTR_TO_BTF_ID_OR_NULL;
> >> +               ret_btf_id = *fn->ret_btf_id;
> >
> > might be a good idea to check fb->ret_btf_id for NULL and print a
> > warning + return -EFAULT. It's not supposed to happen on properly
> > configured kernel, but during development this will save a bunch of
> > time and frustration for next person trying to add something with
> > RET_PTR_TO_BTF_ID_OR_NULL.
>
> I would like prefer to delay this with current code. Otherwise,
> it gives an impression fn->ret_btf_id might be NULL and it is
> actually never NULL. We can add NULL check if the future change
> requires it. I am not sure what the future change could be,
> but you need some way to get the return btf_id, the above is
> one of them.

It's not **supposed** to be NULL, same as a bunch of other invariants
about BPF helper proto definitions, but verifier does check sanity for
such cases, instead of crashing. But up to you. I'm pretty sure
someone will trip up on this.

>
> >
> >> +               if (ret_btf_id == 0) {
> >
> > This also has to be struct/union (after typedef/mods stripping, of
> > course). Or are there other cases?
>
> This is an "int". The func_proto difinition is below:
> int *ret_btf_id; /* return value btf_id */

I meant the BTF type itself that this btf_id points to. Is there any
use case where this won't be a pointer to struct/union and instead
something like a pointer to an int?

>
> >
> >> +                       verbose(env, "invalid return type %d of func %s#%d\n",
> >> +                               fn->ret_type, func_id_name(func_id), func_id);
> >> +                       return -EINVAL;
> >> +               }
> >> +               regs[BPF_REG_0].btf_id = ret_btf_id;
> >>          } else {
> >>                  verbose(env, "unknown return type %d of func %s#%d\n",
> >>                          fn->ret_type, func_id_name(func_id), func_id);
> >
> > [...]
> >
> >> +void init_btf_sock_ids(struct btf *btf)
> >> +{
> >> +       int i, btf_id;
> >> +
> >> +       for (i = 0; i < MAX_BTF_SOCK_TYPE; i++) {
> >> +               btf_id = btf_find_by_name_kind(btf, bpf_sock_types[i],
> >> +                                              BTF_KIND_STRUCT);
> >> +               if (btf_id > 0)
> >> +                       btf_sock_ids[i] = btf_id;
> >> +       }
> >> +}
> >
> > This will hopefully go away with Jiri's work on static BTF IDs, right?
> > So looking forward to that :)
>
> Yes. That's the plan.
>
> >
> >> +
> >> +static bool check_arg_btf_id(u32 btf_id, u32 arg)
> >> +{
> >> +       int i;
> >> +
> >> +       /* only one argument, no need to check arg */
> >> +       for (i = 0; i < MAX_BTF_SOCK_TYPE; i++)
> >> +               if (btf_sock_ids[i] == btf_id)
> >> +                       return true;
> >> +       return false;
> >> +}
> >> +
> >
> > [...]
> >
