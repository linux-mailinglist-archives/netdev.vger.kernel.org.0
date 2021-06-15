Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 760933A8CE1
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 01:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbhFOXxL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 19:53:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbhFOXxL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 19:53:11 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19511C061574
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 16:51:05 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id q21so314117ybg.8
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 16:51:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5W6JsD37+4JNg5Ex0Nkcclj4+4EJ/V3/6fLxWeurc0I=;
        b=MMzy8t4E9wyW5qOkvR1UzJ7MKLcSn2bwr7VVz+8FpcgRGro9uJJ/pnPG2+VxlpB8D4
         QuD127YBMmirKv1B0rzByXi6C04KrFXstpvaUseLkUdc5Nmi+4YRD12CFEAFOeSUouUq
         Mco8mZPgnOwptAzyKiH7gh/MX49lB3qwWf7tXRiYvOaTyNAEUAZcvjO+rgp9v9vis6J0
         s2hSAxJd2MsZw6LdYUl6IOynBS8oCVbMtXqdgFPHtF/DvDnXCbdPUwsfywE+r8iHNX2I
         SvQA9iQkDXOWusZE4bUYbn5eWAT805k5SYo6LRewj0rUeSQzLl7CJKmW7uFDIXHnafyK
         Q10Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5W6JsD37+4JNg5Ex0Nkcclj4+4EJ/V3/6fLxWeurc0I=;
        b=P2RGnfYALBF+hHjzc946AqqRCtPNItBcobq5DfhcyG2rVSFuxukGle8BRHcS9kRCLZ
         XavpK/3FPwgvpI+9I9YpypblfEVb+6yr4+8XVOLQ9TNMQij51inOXltF15CPiZiDrW9r
         MkxPd+3Smu06GBq5CVwQoqjPZUc6NgvtdsWK6emtOy2TRZzAW0yuqgytEHq3Fz297AM7
         +rLhSlJIV/TNk5DxfSDjkyr+uGX/eCubS/RnjuBn+byeE/MiZ2LFCH9D4D6gBP5IEJxg
         idLbQJiGp01Am00Q8pWD3j4UZ7x5uumNPISzYZ0zIL8kkmEp1lfHrIeezAsPmMsuUm6u
         7twA==
X-Gm-Message-State: AOAM530VjlXtcoz+5c1LF9h7pHz5nWCeOWJSVgvPWSyNmdj30S4cHkJO
        vQj2sLu5sTfBlU3PuUdI0R4Emw08Xyve799Fb+s=
X-Google-Smtp-Source: ABdhPJxMio4EtpvR+XN/Wjs1pKtBurj6/zUU5iVoxQsxLo4fia26QMh/6mKqTSOajVsb9rMYYgB+yfwu82wUVQwcx8Y=
X-Received: by 2002:a25:4441:: with SMTP id r62mr2337897yba.179.1623801064093;
 Tue, 15 Jun 2021 16:51:04 -0700 (PDT)
MIME-Version: 1.0
References: <20210615001100.1008325-1-tannerlove.kernel@gmail.com>
 <20210615001100.1008325-2-tannerlove.kernel@gmail.com> <20210615222501.i7uvj63jv5h4faz4@kafai-mbp>
In-Reply-To: <20210615222501.i7uvj63jv5h4faz4@kafai-mbp>
From:   Tanner Love <tannerlove.kernel@gmail.com>
Date:   Tue, 15 Jun 2021 16:50:53 -0700
Message-ID: <CAHrNZNgAqOMDn0qnmbaY0d=h8RPDu_nFamA2t_o8AJxnsYFTqw@mail.gmail.com>
Subject: Re: [PATCH net-next v6 1/3] net: flow_dissector: extend bpf flow
 dissector support with vnet hdr
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Tanner Love <tannerlove@google.com>,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 15, 2021 at 3:25 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Mon, Jun 14, 2021 at 08:10:58PM -0400, Tanner Love wrote:
> > From: Tanner Love <tannerlove@google.com>
> >
> > Amend the bpf flow dissector program type to be able to process
> > virtio-net headers. Do this to enable bpf flow dissector programs to
> > perform virtio-net header validation. The next patch in this series
> > will add a flow dissection hook in virtio_net_hdr_to_skb and make use
> > of this extended functionality. That commit message has more
> > background on the use case.
> >
> > Add two new members to struct bpf_flow_keys: a pointer to struct
> > virtio_net_hdr, and vhdr_is_little_endian. The latter is required to
> > inform the BPF program of the endianness of the virtio-net header
> > fields, to handle the case of a version 1+ header on a big endian
> > machine.
> >
> > Changes
> > v6:
> >   - Move bpf_flow_dissector_btf_ids, check_flow_keys_access() to
> >     filter.c
> >   - Verify (off % size == 0) in check_flow_keys_access()
> >   - Check bpf_flow_dissector_btf_ids[0] is nonzero in
> >     check_flow_keys_access()
> > v5:
> >   - Use PTR_TO_BTF_ID_OR_NULL instead of defining new
> >     PTR_TO_VNET_HDR_OR_NULL
> >   - Make check_flow_keys_access() disallow writes to keys->vhdr
> >   - Make check_flow_keys_access() check loading keys->vhdr is in
> >     sizeof(__u64)
> >   - Use BPF_REG_AX instead of BPF_REG_TMP as scratch reg
> >   - Describe parameter vhdr_is_little_endian in __skb_flow_dissect
> >     documentation
> > v4:
> >   - Add virtio_net_hdr pointer to struct bpf_flow_keys
> >   - Add vhdr_is_little_endian to struct bpf_flow_keys
> > v2:
> >   - Describe parameter vhdr in __skb_flow_dissect documentation
> >
> > Signed-off-by: Tanner Love <tannerlove@google.com>
> > Reviewed-by: Willem de Bruijn <willemb@google.com>
> > Reviewed-by: Petar Penkov <ppenkov@google.com>
> > Reviewed-by: Stanislav Fomichev <sdf@google.com>
> > ---
> >  drivers/net/bonding/bond_main.c |  2 +-
> >  include/linux/bpf.h             |  3 ++
> >  include/linux/skbuff.h          | 35 ++++++++++++++++-----
> >  include/uapi/linux/bpf.h        |  2 ++
> >  kernel/bpf/verifier.c           | 35 ++++++++++++---------
> >  net/bpf/test_run.c              |  2 +-
> >  net/core/filter.c               | 56 +++++++++++++++++++++++++++++++++
> >  net/core/flow_dissector.c       | 18 ++++++++---
> >  tools/include/uapi/linux/bpf.h  |  2 ++
> >  9 files changed, 127 insertions(+), 28 deletions(-)
> >
> > diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> > index eb79a9f05914..36993636d56d 100644
> > --- a/drivers/net/bonding/bond_main.c
> > +++ b/drivers/net/bonding/bond_main.c
> > @@ -3554,7 +3554,7 @@ static bool bond_flow_dissect(struct bonding *bond, struct sk_buff *skb,
> >       case BOND_XMIT_POLICY_ENCAP34:
> >               memset(fk, 0, sizeof(*fk));
> >               return __skb_flow_dissect(NULL, skb, &flow_keys_bonding,
> > -                                       fk, NULL, 0, 0, 0, 0);
> > +                                       fk, NULL, 0, 0, 0, 0, NULL, false);
> >       default:
> >               break;
> >       }
> > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > index 9dc44ba97584..f08dee59b099 100644
> > --- a/include/linux/bpf.h
> > +++ b/include/linux/bpf.h
> > @@ -1515,6 +1515,9 @@ static inline int bpf_map_attr_numa_node(const union bpf_attr *attr)
> >               attr->numa_node : NUMA_NO_NODE;
> >  }
> >
> > +int check_flow_keys_access(int off, int size, enum bpf_access_type t,
> > +                        struct bpf_insn_access_aux *info);
> Thanks for moving it!

Thanks for all your helpful feedback!

>
> 1. It needs to be put under CONFIG_NET.  There is one earlier where
>    bpf_sock_is_valid_access() also resides.
> 2. nit. Rename it to xyz_is_valid_access().  xyz probably is
>    bpf_flow_keys here.
>
> >  void skb_flow_dissect_meta(const struct sk_buff *skb,
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index 418b9b813d65..e1ac34548f9a 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -6017,6 +6017,8 @@ struct bpf_flow_keys {
> >       };
> >       __u32   flags;
> >       __be32  flow_label;
> > +     __bpf_md_ptr(const struct virtio_net_hdr *, vhdr);
> > +     __u8    vhdr_is_little_endian;
> I am not familiar with virtio.  A question on the "vhdr_is_little_endian" field.
> The commit message said
> "to handle the case of a version 1+ header on a big endian machine".
> iiuc, version 1+ is always in little endian?

That's right.

> Does it mean most cases are in little endian?
> and at least will eventually be moved to version 1+?
>
> I wonder if this field will eventually be useless (because of always
> true) and can it be avoided from the uapi now.  The current uapi
> fields (e.g. in bpf_sock) are always in one particular order.
>
> If it is in big endian, can it be changed to little endian first
> before calling the bpf prog?

In fact, v1 of this patch set did the conversion prior to passing
the fields to the bpf prog, which meant that the bpf prog did not
have to do anything about endianness. I changed that, though,
at the suggestion of Alexei; Alexei suggested that we pass a
pointer to struct virtio_net_hdr, rather than copying the individual
virtio_net_hdr fields. V1 did the endianness conversion as part
of that copying process. If we go back to doing it like that, then
we lose the advantage that Alexei's suggestion aimed to achieve
(i.e. avoiding the cost of copying the fields).

I will address your other comments in the next version. Thanks

>
> >  };
> >
> >  struct bpf_func_info {
> > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > index 331b170d9fcc..a037476954f5 100644
> > --- a/kernel/bpf/verifier.c
> > +++ b/kernel/bpf/verifier.c
> > @@ -22,6 +22,7 @@
> >  #include <linux/error-injection.h>
> >  #include <linux/bpf_lsm.h>
> >  #include <linux/btf_ids.h>
> > +#include <linux/virtio_net.h>
> >
> >  #include "disasm.h"
> >
> > @@ -3372,18 +3373,6 @@ static int check_ctx_access(struct bpf_verifier_env *env, int insn_idx, int off,
> >       return -EACCES;
> >  }
> >
> > -static int check_flow_keys_access(struct bpf_verifier_env *env, int off,
> > -                               int size)
> > -{
> > -     if (size < 0 || off < 0 ||
> > -         (u64)off + size > sizeof(struct bpf_flow_keys)) {
> > -             verbose(env, "invalid access to flow keys off=%d size=%d\n",
> > -                     off, size);
> > -             return -EACCES;
> > -     }
> > -     return 0;
> > -}
> > -
> >  static int check_sock_access(struct bpf_verifier_env *env, int insn_idx,
> >                            u32 regno, int off, int size,
> >                            enum bpf_access_type t)
> > @@ -4210,6 +4199,8 @@ static int check_mem_access(struct bpf_verifier_env *env, int insn_idx, u32 regn
> >               if (!err && t == BPF_READ && value_regno >= 0)
> >                       mark_reg_unknown(env, regs, value_regno);
> >       } else if (reg->type == PTR_TO_FLOW_KEYS) {
> > +             struct bpf_insn_access_aux info = {};
> > +
> >               if (t == BPF_WRITE && value_regno >= 0 &&
> >                   is_pointer_value(env, value_regno)) {
> >                       verbose(env, "R%d leaks addr into flow keys\n",
> > @@ -4217,9 +4208,23 @@ static int check_mem_access(struct bpf_verifier_env *env, int insn_idx, u32 regn
> >                       return -EACCES;
> >               }
> >
> > -             err = check_flow_keys_access(env, off, size);
> > -             if (!err && t == BPF_READ && value_regno >= 0)
> > -                     mark_reg_unknown(env, regs, value_regno);
> > +             err = check_flow_keys_access(off, size, t, &info);
> > +             if (err) {
> > +                     verbose(env,
> > +                             "invalid access to flow keys off=%d size=%d\n",
> > +                             off, size);
> > +             } else if (t == BPF_READ && value_regno >= 0) {
> > +                     if (off == offsetof(struct bpf_flow_keys, vhdr)) {
> The logic below is very similar to the earlier PTR_TO_CTX case and
> they can be refactored in the future.
>
> It is better to check a generic PTR_TO_BTF_ID_OR_NULL value (and more on the
> info.reg_type and info.btf later) instead of something specific to bpf_flow_keys
> such that it will be easier to make sense with when refactoring with the
> PTR_TO_CTX case in the future.  Something like:
>
>                         if (info.reg_type == PTR_TO_BTF_ID_OR_NULL) {
>                                 mark_reg_known_zero(env, regs, value_regno);
>                                 regs[value_regno].type = info.reg_type;
>                                 regs[value_regno].btf = info.btf;
>                                 regs[value_regno.btf_id = info.btf_id;
>                                 regs[value_regno].id = ++env->id_gen;
>                         } else {
>                                 mark_reg_unknown(env, regs, value_regno);
>                         }
> > +                             mark_reg_known_zero(env, regs, value_regno);
> > +                             regs[value_regno].type = PTR_TO_BTF_ID_OR_NULL;
> > +                             regs[value_regno].btf = btf_vmlinux;
> > +                             regs[value_regno].btf_id = info.btf_id;
> > +                             /* required for dropping or_null */
> > +                             regs[value_regno].id = ++env->id_gen;
> > +                     } else {
> > +                             mark_reg_unknown(env, regs, value_regno);
> > +                     }
> > +             }
> >       } else if (type_is_sk_pointer(reg->type)) {
> >               if (t == BPF_WRITE) {
> >                       verbose(env, "R%d cannot write into %s\n",
> > diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
> > index aa47af349ba8..a11c5ce99ccb 100644
> > --- a/net/bpf/test_run.c
> > +++ b/net/bpf/test_run.c
> > @@ -797,7 +797,7 @@ int bpf_prog_test_run_flow_dissector(struct bpf_prog *prog,
> >       bpf_test_timer_enter(&t);
> >       do {
> >               retval = bpf_flow_dissect(prog, &ctx, eth->h_proto, ETH_HLEN,
> > -                                       size, flags);
> > +                                       size, flags, NULL, false);
> >       } while (bpf_test_timer_continue(&t, repeat, &ret, &duration));
> >       bpf_test_timer_leave(&t);
> >
> > diff --git a/net/core/filter.c b/net/core/filter.c
> > index 239de1306de9..f5be14b947cd 100644
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
> > @@ -8329,6 +8329,36 @@ static bool sk_msg_is_valid_access(int off, int size,
> >       return true;
> >  }
> >
> > +BTF_ID_LIST_SINGLE(bpf_flow_dissector_btf_ids, struct, virtio_net_hdr);
> > +
> > +int check_flow_keys_access(int off, int size, enum bpf_access_type t,
> > +                        struct bpf_insn_access_aux *info)
> > +{
> > +     if (size < 0 || off < 0 ||
> > +         (u64)off + size > sizeof(struct bpf_flow_keys))
> "size" must be > 0 here or the verifier should have already rejected it,
> so "size < 0" can be removed.
>
> sizeof() is not enough now.  There is end padding now beause of
> the "__u8 vhdr_is_little_endian;".  It is a good chance
> to repleace it with offsetofend(struct bpf_flow_keys, whatever_last_member).
>
> > +             return -EACCES;
> > +
> > +     switch (off) {
> > +     case bpf_ctx_range_ptr(struct bpf_flow_keys, vhdr):
> > +             if (t == BPF_WRITE || off % size != 0 || size != sizeof(__u64))
> > +                     return -EACCES;
> > +
> > +             if (!bpf_flow_dissector_btf_ids[0])
> > +                     return -EINVAL;
> > +
> > +             info->btf_id = bpf_flow_dissector_btf_ids[0];
> It is setting the info->btf_id.  Set the info->btf and info->reg_type
> here also instead of having the caller to second guess.
>
>                 info->btf = btf_vmlinux;
>                 info->reg_type = PTR_TO_BTF_ID_OR_NULL;
>
> others lgtm.
>
> > +
> > +             break;
> > +     case offsetof(struct bpf_flow_keys, vhdr_is_little_endian):
> > +             if (t == BPF_WRITE)
> > +                     return -EACCES;
> > +
> > +             break;
> > +     }
> > +
> > +     return 0;
> > +}
> > +
