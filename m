Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0756959EF42
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 00:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234151AbiHWW2z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 18:28:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233839AbiHWW2b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 18:28:31 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 504278B2EF;
        Tue, 23 Aug 2022 15:27:10 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id n7so12002749ejh.2;
        Tue, 23 Aug 2022 15:27:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=KzjFib07S/CXi4M7EkgyNqOiZMQFeCxp1LV9Wu1btKM=;
        b=mbuUR86lVIbGJeZavEAs+MdPlrbxVwe1zGtAeUFtBcOAEyGRGAcYcLyPtpydR/eIIw
         b8hIyhxJnDvHNQaG75OOUh+s07W3Zhyex5epnFVEbTIMkc/pxSCA5I3zUPvJs+Zw07+M
         nWY4ZQM/q+J7wj6pLJLO8JqsfduoSrRe/YBy0ctb5Vi+8WpDG66zu58GAxOf/NYeJD5T
         t0jrwXIdx4FdjSnRlFtD9SjRZgRl/nf1TxT/L2cJOc2Loc22d7NajJizvT4qomRqG5hi
         NaWb7vcuMifPvY+VcKE3acnMqEUXAs+rqtqU0hfU9CpqTa8tMfrQKQWAkfZsGjWPWfv+
         rwSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=KzjFib07S/CXi4M7EkgyNqOiZMQFeCxp1LV9Wu1btKM=;
        b=0z3a7JfzsBSR07myO3Nhy50PwbSDTwXWPW2phLyHVB7RuE0KlUEatEREMMVk6kxhhn
         5X1NeBYMV2VW1lA4DATq8ClyWVTlsIxT8CmWBiWsFGHAuh2TlPPEBvFxZVYphepAwQuu
         gON+VVS1AZEgJh2kQzQ4F0mXqiQmq0/21Wbpm6YshZijmIEHSu7KbQ37TaTAaeZ3wpuA
         kq7gf+MpTR2zaHwPFLw12pZzrnUWBQXkM8y6dE0ek7C2D6efXSSy/KH5YXtxrvc+6NzY
         V4/LSmNwyx4bx413PgPiTnQH5tI8vt8eJw51bT/q6kFUBgWK2CpSKcqUOdAdxIlTkYxb
         8A2A==
X-Gm-Message-State: ACgBeo1FZFIins6RrEHY+bnZP+hhZMLA2V9+gAi2Rvy3/7SXjP/HzBec
        0yLOVXoJGrsBjO20B7UYg3fEbZAqyukCLQT5Hvdlf/Qaq90=
X-Google-Smtp-Source: AA6agR7ANnEKZIp/fET38e9DX8hLgoBj7JvFKQxU94SR3T01bzkpJMzjVbDFqlu9dlongVnu6JrLETCVvgingjbMKAk=
X-Received: by 2002:a17:906:84f0:b0:73d:837a:332c with SMTP id
 zp16-20020a17090684f000b0073d837a332cmr1034536ejb.679.1661293628600; Tue, 23
 Aug 2022 15:27:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220822235649.2218031-1-joannelkoong@gmail.com>
 <20220822235649.2218031-3-joannelkoong@gmail.com> <CAP01T77h2+a9OonHuiPRFsAForWYJfQ71G6teqbcLg4KuGpK5A@mail.gmail.com>
In-Reply-To: <CAP01T77h2+a9OonHuiPRFsAForWYJfQ71G6teqbcLg4KuGpK5A@mail.gmail.com>
From:   Joanne Koong <joannelkoong@gmail.com>
Date:   Tue, 23 Aug 2022 15:26:57 -0700
Message-ID: <CAJnrk1aq3gJgz0DKo47SS0J2wTtg1C_B3eVfsh-036nmDKKVWA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 2/3] bpf: Add xdp dynptrs
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf@vger.kernel.org, andrii@kernel.org, daniel@iogearbox.net,
        ast@kernel.org, kafai@fb.com, kuba@kernel.org,
        netdev@vger.kernel.org, "toke@redhat.com" <toke@redhat.com>,
        "brouer@redhat.com" <brouer@redhat.com>, lorenzo@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 22, 2022 at 7:31 PM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> +Cc XDP folks
>
> On Tue, 23 Aug 2022 at 02:12, Joanne Koong <joannelkoong@gmail.com> wrote:
> >
> > Add xdp dynptrs, which are dynptrs whose underlying pointer points
> > to a xdp_buff. The dynptr acts on xdp data. xdp dynptrs have two main
> > benefits. One is that they allow operations on sizes that are not
> > statically known at compile-time (eg variable-sized accesses).
> > Another is that parsing the packet data through dynptrs (instead of
> > through direct access of xdp->data and xdp->data_end) can be more
> > ergonomic and less brittle (eg does not need manual if checking for
> > being within bounds of data_end).
> >
> > For reads and writes on the dynptr, this includes reading/writing
> > from/to and across fragments. For data slices, direct access to
>
> It's a bit awkward to have such a difference between xdp and skb
> dynptr's read/write. I understand why it is the way it is, but it
> still doesn't feel right. I'm not sure if we can reconcile the
> differences, but it makes writing common code for both xdp and tc
> harder as it needs to be aware of the differences (and then the flags
> for dynptr_write would differ too). So we're 90% there but not the
> whole way...

Yeah, it'd be great if the behavior for skb/xdp progs could be the
same, but I'm not seeing a better solution here (unless we invalidate
data slices on writes in xdp progs, just to make it match more :P).

Regarding having 2 different interfaces bpf_dynptr_from_{skb/xdp}, I'm
not convinced this is much of a problem - xdp and skb programs already
have different interfaces for doing things (eg
bpf_{skb/xdp}_{store/load}_bytes).

>
> > data in fragments is also permitted, but access across fragments
> > is not. The returned data slice is reg type PTR_TO_PACKET | PTR_MAYBE_NULL.
> >
> > Any helper calls that change the underlying packet buffer (eg
> > bpf_xdp_adjust_head) invalidates any data slices of the associated
> > dynptr. Whenever such a helper call is made, the verifier marks any
> > PTR_TO_PACKET reg type (which includes xdp dynptr slices since they are
> > PTR_TO_PACKETs) as unknown. The stack trace for this is
> > check_helper_call() -> clear_all_pkt_pointers() ->
> > __clear_all_pkt_pointers() -> mark_reg_unknown()
> >
> > For examples of how xdp dynptrs can be used, please see the attached
> > selftests.
> >
> > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > ---
> >  include/linux/bpf.h            |  6 ++++-
> >  include/linux/filter.h         |  3 +++
> >  include/uapi/linux/bpf.h       | 25 +++++++++++++++---
> >  kernel/bpf/helpers.c           | 14 ++++++++++-
> >  kernel/bpf/verifier.c          |  8 +++++-
> >  net/core/filter.c              | 46 +++++++++++++++++++++++++++++-----
> >  tools/include/uapi/linux/bpf.h | 25 +++++++++++++++---
> >  7 files changed, 112 insertions(+), 15 deletions(-)
> >
> > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > index 30615d1a0c13..455a215b6c57 100644
> > --- a/include/linux/bpf.h
> > +++ b/include/linux/bpf.h
> > @@ -410,11 +410,15 @@ enum bpf_type_flag {
> >         /* DYNPTR points to sk_buff */
> >         DYNPTR_TYPE_SKB         = BIT(11 + BPF_BASE_TYPE_BITS),
> >
> > +       /* DYNPTR points to xdp_buff */
> > +       DYNPTR_TYPE_XDP         = BIT(12 + BPF_BASE_TYPE_BITS),
> > +
> >         __BPF_TYPE_FLAG_MAX,
> >         __BPF_TYPE_LAST_FLAG    = __BPF_TYPE_FLAG_MAX - 1,
> >  };
> >
> > -#define DYNPTR_TYPE_FLAG_MASK  (DYNPTR_TYPE_LOCAL | DYNPTR_TYPE_RINGBUF | DYNPTR_TYPE_SKB)
> > +#define DYNPTR_TYPE_FLAG_MASK  (DYNPTR_TYPE_LOCAL | DYNPTR_TYPE_RINGBUF | DYNPTR_TYPE_SKB \
> > +                                | DYNPTR_TYPE_XDP)
> >
> >  /* Max number of base types. */
> >  #define BPF_BASE_TYPE_LIMIT    (1UL << BPF_BASE_TYPE_BITS)
> > diff --git a/include/linux/filter.h b/include/linux/filter.h
> > index 649063d9cbfd..80f030239877 100644
> > --- a/include/linux/filter.h
> > +++ b/include/linux/filter.h
> > @@ -1535,5 +1535,8 @@ static __always_inline int __bpf_xdp_redirect_map(struct bpf_map *map, u32 ifind
> >  int __bpf_skb_load_bytes(const struct sk_buff *skb, u32 offset, void *to, u32 len);
> >  int __bpf_skb_store_bytes(struct sk_buff *skb, u32 offset, const void *from,
> >                           u32 len, u64 flags);
> > +int __bpf_xdp_load_bytes(struct xdp_buff *xdp, u32 offset, void *buf, u32 len);
> > +int __bpf_xdp_store_bytes(struct xdp_buff *xdp, u32 offset, void *buf, u32 len);
> > +void *bpf_xdp_pointer(struct xdp_buff *xdp, u32 offset, u32 len);
> >
> >  #endif /* __LINUX_FILTER_H__ */
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index 320e6b95d95c..9feea29eebcd 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -5283,13 +5283,18 @@ union bpf_attr {
> >   *                   and try again.
> >   *
> >   *                 * The data slice is automatically invalidated anytime
> > - *                   **bpf_dynptr_write**\ () or a helper call that changes
> > - *                   the underlying packet buffer (eg **bpf_skb_pull_data**\ ())
> > + *                   **bpf_dynptr_write**\ () is called.
> > + *
> > + *             For skb-type and xdp-type dynptrs:
> > + *                 * The data slice is automatically invalidated anytime a
> > + *                   helper call that changes the underlying packet buffer
> > + *                   (eg **bpf_skb_pull_data**\ (), **bpf_xdp_adjust_head**\ ())
> >   *                   is called.
> >   *     Return
> >   *             Pointer to the underlying dynptr data, NULL if the dynptr is
> >   *             read-only, if the dynptr is invalid, or if the offset and length
> > - *             is out of bounds or in a paged buffer for skb-type dynptrs.
> > + *             is out of bounds or in a paged buffer for skb-type dynptrs or
> > + *             across fragments for xdp-type dynptrs.
> >   *
> >   * s64 bpf_tcp_raw_gen_syncookie_ipv4(struct iphdr *iph, struct tcphdr *th, u32 th_len)
> >   *     Description
> > @@ -5388,6 +5393,19 @@ union bpf_attr {
> >   *             *flags* is currently unused, it must be 0 for now.
> >   *     Return
> >   *             0 on success or -EINVAL if flags is not 0.
> > + *
> > + * long bpf_dynptr_from_xdp(struct xdp_buff *xdp_md, u64 flags, struct bpf_dynptr *ptr)
> > + *     Description
> > + *             Get a dynptr to the data in *xdp_md*. *xdp_md* must be the BPF program
> > + *             context.
> > + *
> > + *             Calls that change the *xdp_md*'s underlying packet buffer
> > + *             (eg **bpf_xdp_adjust_head**\ ()) do not invalidate the dynptr, but
> > + *             they do invalidate any data slices associated with the dynptr.
> > + *
> > + *             *flags* is currently unused, it must be 0 for now.
> > + *     Return
> > + *             0 on success, -EINVAL if flags is not 0.
> >   */
> >  #define __BPF_FUNC_MAPPER(FN)          \
> >         FN(unspec),                     \
> > @@ -5600,6 +5618,7 @@ union bpf_attr {
> >         FN(tcp_raw_check_syncookie_ipv6),       \
> >         FN(ktime_get_tai_ns),           \
> >         FN(dynptr_from_skb),            \
> > +       FN(dynptr_from_xdp),            \
> >         /* */
> >
> >  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
> > diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
> > index 471a01a9b6ae..2b9dc4c6de04 100644
> > --- a/kernel/bpf/helpers.c
> > +++ b/kernel/bpf/helpers.c
> > @@ -1541,6 +1541,8 @@ BPF_CALL_5(bpf_dynptr_read, void *, dst, u32, len, struct bpf_dynptr_kern *, src
> >                 return 0;
> >         case BPF_DYNPTR_TYPE_SKB:
> >                 return __bpf_skb_load_bytes(src->data, src->offset + offset, dst, len);
> > +       case BPF_DYNPTR_TYPE_XDP:
> > +               return __bpf_xdp_load_bytes(src->data, src->offset + offset, dst, len);
> >         default:
> >                 WARN(true, "bpf_dynptr_read: unknown dynptr type %d\n", type);
> >                 return -EFAULT;
> > @@ -1583,6 +1585,10 @@ BPF_CALL_5(bpf_dynptr_write, struct bpf_dynptr_kern *, dst, u32, offset, void *,
> >         case BPF_DYNPTR_TYPE_SKB:
> >                 return __bpf_skb_store_bytes(dst->data, dst->offset + offset, src, len,
> >                                              flags);
> > +       case BPF_DYNPTR_TYPE_XDP:
> > +               if (flags)
> > +                       return -EINVAL;
> > +               return __bpf_xdp_store_bytes(dst->data, dst->offset + offset, src, len);
> >         default:
> >                 WARN(true, "bpf_dynptr_write: unknown dynptr type %d\n", type);
> >                 return -EFAULT;
> > @@ -1616,7 +1622,7 @@ BPF_CALL_3(bpf_dynptr_data, struct bpf_dynptr_kern *, ptr, u32, offset, u32, len
> >
> >         type = bpf_dynptr_get_type(ptr);
> >
> > -       /* Only skb dynptrs can get read-only data slices, because the
> > +       /* Only skb and xdp dynptrs can get read-only data slices, because the
> >          * verifier enforces PTR_TO_PACKET accesses
> >          */
> >         is_rdonly = bpf_dynptr_is_rdonly(ptr);
> > @@ -1640,6 +1646,12 @@ BPF_CALL_3(bpf_dynptr_data, struct bpf_dynptr_kern *, ptr, u32, offset, u32, len
> >                 data = skb->data;
> >                 break;
> >         }
> > +       case BPF_DYNPTR_TYPE_XDP:
> > +               /* if the requested data in across fragments, then it cannot
> > +                * be accessed directly - bpf_xdp_pointer will return NULL
> > +                */
> > +               return (unsigned long)bpf_xdp_pointer(ptr->data,
> > +                                                     ptr->offset + offset, len);
> >         default:
> >                 WARN(true, "bpf_dynptr_data: unknown dynptr type %d\n", type);
> >                 return 0;
> > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > index 1ea295f47525..d33648eee188 100644
> > --- a/kernel/bpf/verifier.c
> > +++ b/kernel/bpf/verifier.c
> > @@ -686,6 +686,8 @@ static enum bpf_dynptr_type arg_to_dynptr_type(enum bpf_arg_type arg_type)
> >                 return BPF_DYNPTR_TYPE_RINGBUF;
> >         case DYNPTR_TYPE_SKB:
> >                 return BPF_DYNPTR_TYPE_SKB;
> > +       case DYNPTR_TYPE_XDP:
> > +               return BPF_DYNPTR_TYPE_XDP;
> >         default:
> >                 return BPF_DYNPTR_TYPE_INVALID;
> >         }
> > @@ -6078,6 +6080,9 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
> >                         case DYNPTR_TYPE_SKB:
> >                                 err_extra = "skb ";
> >                                 break;
> > +                       case DYNPTR_TYPE_XDP:
> > +                               err_extra = "xdp ";
> > +                               break;
> >                         }
> >
> >                         verbose(env, "Expected an initialized %sdynptr as arg #%d\n",
> > @@ -7439,7 +7444,8 @@ static int check_helper_call(struct bpf_verifier_env *env, struct bpf_insn *insn
> >                 mark_reg_known_zero(env, regs, BPF_REG_0);
> >
> >                 if (func_id == BPF_FUNC_dynptr_data &&
> > -                   dynptr_type == BPF_DYNPTR_TYPE_SKB) {
> > +                   (dynptr_type == BPF_DYNPTR_TYPE_SKB ||
> > +                    dynptr_type == BPF_DYNPTR_TYPE_XDP)) {
> >                         regs[BPF_REG_0].type = PTR_TO_PACKET | ret_flag;
> >                         regs[BPF_REG_0].range = meta.mem_size;
>
> It doesn't seem like this is safe. Since PTR_TO_PACKET's range can be
> modified by comparisons with packet pointers loaded from the xdp/skb
> ctx, how do we distinguish e.g. between a pkt slice obtained from some
> frag in a multi-buff XDP vs pkt pointer from a linear area?
>
> Someone can compare data_meta from ctx with PTR_TO_PACKET from
> bpf_dynptr_data on xdp dynptr (which might be pointing to a xdp mb
> frag). While MAX_PACKET_OFF is 0xffff, it can still be used to do OOB
> access for the linear area. reg_is_init_pkt_pointer will return true
> as modified range is not considered for it. Same kind of issues when
> doing comparison with data_end from ctx (though maybe you won't be
> able to do incorrect data access at runtime using that).
>
> I had a pkt_uid field in my patch [0] which disallowed comparisons
> among bpf_packet_pointer slices. Each call assigned a fresh pkt_uid,
> and that disabled comparisons for them. reg->id is used for var_off
> range propagation so it cannot be reused.
>
> Coming back to this: What we really want here is a PTR_TO_MEM with a
> mem_size, so maybe you should go that route instead of PTR_TO_PACKET
> (and add a type tag to maybe pretty print it also as a packet pointer
> in verifier log), or add some way to distinguish slice vs non-slice
> pkt pointers like I did in my patch. You might also want to add some
> tests for this corner case (there are some later in [0] if you want to
> reuse them).
>
> So TBH, I kinda dislike my own solution in [0] :). The complexity does
> not seem worth it. The pkt_uid distinction is more useful (and
> actually would be needed) in Toke's xdp queueing series, where in a
> dequeue program you have multiple xdp_mds and want scoped slice
> invalidations (i.e. adjust_head on one xdp_md doesn't invalidate
> slices of some other xdp_md). Here we can just get away with normal
> PTR_TO_MEM.
>
> ... Or just let me know if you handle this correctly already, or if
> this won't be an actual problem :).

Ooh interesting, I hadn't previously taken a look at
try_match_pkt_pointers(), thanks for mentioning it :)

The cleanest solution to me is to add the flag "DYNPTR_TYPE_{SKB/XDP}"
to PTR_TO_PACKET and change reg_is_init_pkt_pointer() to return false
if the DYNPTR_TYPE_{SKB/XDP} flag is present. I prefer this over
returning PTR_TO_MEM because it seems more robust (eg if in the future
we reject x behavior on the packet data reg types, this will
automatically apply to the data slices), and because it'll keep the
logic more efficient/simpler for the case when the pkt pointer has to
be cleared after any helper that changes pkt data is called (aka the
case where the data slice gets invalidated).

What are your thoughts?

>
>   [0]: https://lore.kernel.org/bpf/20220306234311.452206-3-memxor@gmail.com
