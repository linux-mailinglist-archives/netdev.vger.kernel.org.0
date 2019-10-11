Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 836ACD4AC3
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 01:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726781AbfJKXNT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 19:13:19 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:42473 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726354AbfJKXNT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 19:13:19 -0400
Received: by mail-qt1-f193.google.com with SMTP id w14so16198883qto.9;
        Fri, 11 Oct 2019 16:13:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TiHBgnfJXl5U4KvXcrLGCdr2FDnDTuuCepelBB5vyv8=;
        b=lllyIOkf8jca2T9TRHViRIfM+V+YVXBgTDQh1vBaeLIwPwRmt0E3HuCimkYeBSgqNy
         Rzb6qefYoNl1uFUJ8TF14Fhb3woOsW/lx879l6xPZQGGw7XrXgOPZ+Qa9pl5BmNufKvu
         krlWIrv4A/fYuT9V5ZZtIQgPyMYHrEzfCDaxSKgM745J7cRNYU7Wsm50Umm1DZrthHDu
         /WwnhzA3hmNod2Kt2YHRZHtghFoXU1I9h5Nj//VU4q/YKZKDQ4yhw/7N3DzparuB+NB+
         cs5dHZEm6omE6PmrL3HWUJAPpnNOgN+iIYY9C7ixIN7/Kvb+Ik9IoMN5BkHbZ+/90UoD
         9eQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TiHBgnfJXl5U4KvXcrLGCdr2FDnDTuuCepelBB5vyv8=;
        b=iAq2bkTLCUTzLTDb0Mjza1B2mcPU8gcuG5jM/Ban4IqWAEbLXXowO7XTTxacehkkp+
         G70IXyA6i1Nu7rWnLtC/X+bEOvTKOQJIednHiDG22g1NNRdBf2G4PzmK8LQTa9gDhMML
         qmZEqLNKQn66YB1soiQvWUWKreAB+vNE58ddE+nn/g7UYdpcrn5IM+k/vN8uKv5n0+rT
         UQL5K/qaJ/Se+G5mlV/ePhUAN1NUSK5nevKMsR77B7A7+B6sq9zDd/jqpDhpYtgId/9x
         3x9CBUbWtrK0W2QjZg4PqQxcHrvs1SJWPQGq+2T+Va1vZOdtFWtHGd/KHasci0kallUP
         q5SA==
X-Gm-Message-State: APjAAAXRKiW8wl4SzDRP9a2w/5W1z8w0/0qX6fNC9dbIA7nDET4i2NML
        awtuwslCrYRL9tfV0wRabJoYi00So0XdTuEkNFA=
X-Google-Smtp-Source: APXvYqw4oz81OiUxONiDO+OStsX7RjBuwdZNu3fOmaN7djIfhQUjRo5iIyBf7jMriNNlPgRiVj0kQGJ3kNp49JLNl/Y=
X-Received: by 2002:ac8:1c34:: with SMTP id a49mr19521864qtk.59.1570835595831;
 Fri, 11 Oct 2019 16:13:15 -0700 (PDT)
MIME-Version: 1.0
References: <20191010041503.2526303-1-ast@kernel.org> <20191010041503.2526303-7-ast@kernel.org>
 <CAEf4BzYeM4mwXKHS3z3WQxWbMU+2XM6g6touV7vZZagGK0Xijg@mail.gmail.com>
In-Reply-To: <CAEf4BzYeM4mwXKHS3z3WQxWbMU+2XM6g6touV7vZZagGK0Xijg@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 11 Oct 2019 16:13:04 -0700
Message-ID: <CAEf4BzZ+edCGD8v3FgX-wMaKDYKpSPrwjQNwDuaagnkH--wBpA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 06/12] bpf: implement accurate raw_tp context
 access via BTF
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>, x86@kernel.org,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 11, 2019 at 11:31 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Wed, Oct 9, 2019 at 9:17 PM Alexei Starovoitov <ast@kernel.org> wrote:
> >
> > libbpf analyzes bpf C program, searches in-kernel BTF for given type name
> > and stores it into expected_attach_type.
> > The kernel verifier expects this btf_id to point to something like:
> > typedef void (*btf_trace_kfree_skb)(void *, struct sk_buff *skb, void *loc);
> > which represents signature of raw_tracepoint "kfree_skb".
> >
> > Then btf_ctx_access() matches ctx+0 access in bpf program with 'skb'
> > and 'ctx+8' access with 'loc' arguments of "kfree_skb" tracepoint.
> > In first case it passes btf_id of 'struct sk_buff *' back to the verifier core
> > and 'void *' in second case.
> >
> > Then the verifier tracks PTR_TO_BTF_ID as any other pointer type.
> > Like PTR_TO_SOCKET points to 'struct bpf_sock',
> > PTR_TO_TCP_SOCK points to 'struct bpf_tcp_sock', and so on.
> > PTR_TO_BTF_ID points to in-kernel structs.
> > If 1234 is btf_id of 'struct sk_buff' in vmlinux's BTF
> > then PTR_TO_BTF_ID#1234 points to one of in kernel skbs.
> >
> > When PTR_TO_BTF_ID#1234 is dereferenced (like r2 = *(u64 *)r1 + 32)
> > the btf_struct_access() checks which field of 'struct sk_buff' is
> > at offset 32. Checks that size of access matches type definition
> > of the field and continues to track the dereferenced type.
> > If that field was a pointer to 'struct net_device' the r2's type
> > will be PTR_TO_BTF_ID#456. Where 456 is btf_id of 'struct net_device'
> > in vmlinux's BTF.
> >
> > Such verifier analysis prevents "cheating" in BPF C program.
> > The program cannot cast arbitrary pointer to 'struct sk_buff *'
> > and access it. C compiler would allow type cast, of course,
> > but the verifier will notice type mismatch based on BPF assembly
> > and in-kernel BTF.
> >
> > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > ---
> >  include/linux/bpf.h          |  17 +++-
> >  include/linux/bpf_verifier.h |   4 +
> >  kernel/bpf/btf.c             | 186 +++++++++++++++++++++++++++++++++++
> >  kernel/bpf/verifier.c        |  86 +++++++++++++++-
> >  kernel/trace/bpf_trace.c     |   2 +-
> >  5 files changed, 290 insertions(+), 5 deletions(-)
> >
>
> [...]
>
> > +int btf_struct_access(struct bpf_verifier_log *log,
> > +                     const struct btf_type *t, int off, int size,
> > +                     enum bpf_access_type atype,
> > +                     u32 *next_btf_id)
> > +{
> > +       const struct btf_member *member;
> > +       const struct btf_type *mtype;
> > +       const char *tname, *mname;
> > +       int i, moff = 0, msize;
> > +
> > +again:
> > +       tname = __btf_name_by_offset(btf_vmlinux, t->name_off);
> > +       if (!btf_type_is_struct(t)) {
> > +               bpf_log(log, "Type '%s' is not a struct", tname);
> > +               return -EINVAL;
> > +       }
> > +
> > +       for_each_member(i, t, member) {
> > +               /* offset of the field in bits */
> > +               moff = btf_member_bit_offset(t, member);
>
> This whole logic of offset/size checking doesn't work for bitfields.
> Your moff % 8 might be non-zero (most probably, actually, for
> bitfield). Also, msize of underlying integer type is not the same as
> member's bit size. So probably just check that it's a bitfield and
> skip it?
>
> The check is surprisingly subtle and not straightforward, btw. You

Well, this part is not true, checking btf_member_bitfield_size(t,
member) for non-zero is enough to derive it's bitfield.

> need to get btf_member_bitfield_size(t, member) and check that it's
> not equal to underlying type's size (which is in bytes, so * 8). It's
> unfortunate it's so non-straightforward. But if you don't filter that,
> all those `moff / 8` and `msize` checks are bogus.
>
> > +
> > +               if (off + size <= moff / 8)
> > +                       /* won't find anything, field is already too far */
> > +                       break;
> > +
> > +               /* type of the field */
> > +               mtype = btf_type_by_id(btf_vmlinux, member->type);
> > +               mname = __btf_name_by_offset(btf_vmlinux, member->name_off);
> > +
> > +               /* skip modifiers */
> > +               while (btf_type_is_modifier(mtype))
> > +                       mtype = btf_type_by_id(btf_vmlinux, mtype->type);
> > +
> > +               if (btf_type_is_array(mtype))
> > +                       /* array deref is not supported yet */
> > +                       continue;
> > +
> > +               if (!btf_type_has_size(mtype) && !btf_type_is_ptr(mtype)) {
> > +                       bpf_log(log, "field %s doesn't have size\n", mname);
> > +                       return -EFAULT;
> > +               }
> > +               if (btf_type_is_ptr(mtype))
> > +                       msize = 8;
> > +               else
> > +                       msize = mtype->size;
> > +               if (off >= moff / 8 + msize)
> > +                       /* no overlap with member, keep iterating */
> > +                       continue;
> > +               /* the 'off' we're looking for is either equal to start
> > +                * of this field or inside of this struct
> > +                */
> > +               if (btf_type_is_struct(mtype)) {
> > +                       /* our field must be inside that union or struct */
> > +                       t = mtype;
> > +
> > +                       /* adjust offset we're looking for */
> > +                       off -= moff / 8;
> > +                       goto again;
> > +               }
> > +               if (msize != size) {
> > +                       /* field access size doesn't match */
> > +                       bpf_log(log,
> > +                               "cannot access %d bytes in struct %s field %s that has size %d\n",
> > +                               size, tname, mname, msize);
> > +                       return -EACCES;
>
> Are you sure this has to be an error? Why not just default to
> SCALAR_VALUE here? E.g., if compiler generated one read for few
> smaller fields, or user wants to read lower 1 byte of int field, etc.
> I think if you move this size check into the following ptr check, it
> should be fine. Pointer is the only case where you care about correct
> read/value, isn't it?
>
> > +               }
> > +
> > +               if (btf_type_is_ptr(mtype)) {
> > +                       const struct btf_type *stype;
> > +
> > +                       stype = btf_type_by_id(btf_vmlinux, mtype->type);
> > +                       /* skip modifiers */
> > +                       while (btf_type_is_modifier(stype))
> > +                               stype = btf_type_by_id(btf_vmlinux, stype->type);
> > +                       if (btf_type_is_struct(stype)) {
> > +                               *next_btf_id = mtype->type;
> > +                               return PTR_TO_BTF_ID;
> > +                       }
> > +               }
> > +               /* all other fields are treated as scalars */
> > +               return SCALAR_VALUE;
> > +       }
> > +       bpf_log(log, "struct %s doesn't have field at offset %d\n", tname, off);
> > +       return -EINVAL;
> > +}
> > +
>
> [...]
