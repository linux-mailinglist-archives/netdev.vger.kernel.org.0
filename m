Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF1B659CE9D
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 04:33:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239232AbiHWCbZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 22:31:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239675AbiHWCbW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 22:31:22 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC2A15B7A1;
        Mon, 22 Aug 2022 19:31:20 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id r141so9894016iod.4;
        Mon, 22 Aug 2022 19:31:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=wFNsiGjmi80tuNhNG4S7r7aXWiaSaso2Xi6HELhYG6U=;
        b=Dhy/N0Lc0ZlxKqbiExevPdDkkleHU5w5C8ypiYQuxSPjAfAc6qTPf5p1K3UJ6LjAOb
         HAHG2/bKGkcHEBKcayoj8EaDwg87nOd4vS4QThBJ/cXZlc+ojoGwjz5+dn8osctWE5Z0
         NuK27fYs6Bf2lmYl5tbkI0ZTC8w/V0cysXabCrIrlMGnjnTTKK9xWoLiRQwhiDSe0FqQ
         sBCcz/PBHRtylMrrGft4rgkef+fa5h053KlfHUqYUQD1urwnmUZ7SzX2pZe9qDOYubPL
         Kye322H2XUYgBCxPjPos+j3drMaO8ETkPivbjH2VBDrQKLT5LdfrB97Ww52rwOZZhrJn
         BqbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=wFNsiGjmi80tuNhNG4S7r7aXWiaSaso2Xi6HELhYG6U=;
        b=frLOKwVGJX4/oRzbQFT214gc7elK6aUsDvdvFS+STFx7qGMB/vUz7Rv4MxL8OnqN5M
         DSBG3WVrXo4dRD5+GdP2izAZMT1y1KeSHQ2Yv7XHJIXT8k4Zd//akBx24j8miduQipx/
         dekNwKr5wyttsgOB5bjPfNn0nnTv/Z/XSY5Gg2muWcthyG4iFbyGzn865/gtl1IdpDXj
         LHBw+Yd0Cqeg+7v2xhkGy/bBpI6CVaodXty5evqX0KJN3lCQ4SOI4pJhCPsL0iEa4ykB
         mI3WBQ+VVcL2jSg4HUVM1zWuhzB6g2IROJ+tKEJNV3fajd/TKw9vcVxxZDndhV82YxzV
         +p5A==
X-Gm-Message-State: ACgBeo0ZHZQkXkFI8q6NmMNCsvkuLfygg+zEH14hyyctE6bdNxSmIMJj
        /cE9jtlpXByiN/32aH+rQeS+b9dwUpJLn5PeaLA=
X-Google-Smtp-Source: AA6agR4r89R8hXVIyjTZRkwiiYQeGSBxGDXr5z8qGTYSYIt+jiTteBxWiS0fBz8hdsOdrGGn1YsM6QNKyJ0TaIVsCKo=
X-Received: by 2002:a6b:2ac4:0:b0:688:3a14:2002 with SMTP id
 q187-20020a6b2ac4000000b006883a142002mr9665185ioq.62.1661221880083; Mon, 22
 Aug 2022 19:31:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220822235649.2218031-1-joannelkoong@gmail.com> <20220822235649.2218031-3-joannelkoong@gmail.com>
In-Reply-To: <20220822235649.2218031-3-joannelkoong@gmail.com>
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date:   Tue, 23 Aug 2022 04:30:42 +0200
Message-ID: <CAP01T77h2+a9OonHuiPRFsAForWYJfQ71G6teqbcLg4KuGpK5A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 2/3] bpf: Add xdp dynptrs
To:     Joanne Koong <joannelkoong@gmail.com>
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

+Cc XDP folks

On Tue, 23 Aug 2022 at 02:12, Joanne Koong <joannelkoong@gmail.com> wrote:
>
> Add xdp dynptrs, which are dynptrs whose underlying pointer points
> to a xdp_buff. The dynptr acts on xdp data. xdp dynptrs have two main
> benefits. One is that they allow operations on sizes that are not
> statically known at compile-time (eg variable-sized accesses).
> Another is that parsing the packet data through dynptrs (instead of
> through direct access of xdp->data and xdp->data_end) can be more
> ergonomic and less brittle (eg does not need manual if checking for
> being within bounds of data_end).
>
> For reads and writes on the dynptr, this includes reading/writing
> from/to and across fragments. For data slices, direct access to

It's a bit awkward to have such a difference between xdp and skb
dynptr's read/write. I understand why it is the way it is, but it
still doesn't feel right. I'm not sure if we can reconcile the
differences, but it makes writing common code for both xdp and tc
harder as it needs to be aware of the differences (and then the flags
for dynptr_write would differ too). So we're 90% there but not the
whole way...

> data in fragments is also permitted, but access across fragments
> is not. The returned data slice is reg type PTR_TO_PACKET | PTR_MAYBE_NULL.
>
> Any helper calls that change the underlying packet buffer (eg
> bpf_xdp_adjust_head) invalidates any data slices of the associated
> dynptr. Whenever such a helper call is made, the verifier marks any
> PTR_TO_PACKET reg type (which includes xdp dynptr slices since they are
> PTR_TO_PACKETs) as unknown. The stack trace for this is
> check_helper_call() -> clear_all_pkt_pointers() ->
> __clear_all_pkt_pointers() -> mark_reg_unknown()
>
> For examples of how xdp dynptrs can be used, please see the attached
> selftests.
>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---
>  include/linux/bpf.h            |  6 ++++-
>  include/linux/filter.h         |  3 +++
>  include/uapi/linux/bpf.h       | 25 +++++++++++++++---
>  kernel/bpf/helpers.c           | 14 ++++++++++-
>  kernel/bpf/verifier.c          |  8 +++++-
>  net/core/filter.c              | 46 +++++++++++++++++++++++++++++-----
>  tools/include/uapi/linux/bpf.h | 25 +++++++++++++++---
>  7 files changed, 112 insertions(+), 15 deletions(-)
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 30615d1a0c13..455a215b6c57 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -410,11 +410,15 @@ enum bpf_type_flag {
>         /* DYNPTR points to sk_buff */
>         DYNPTR_TYPE_SKB         = BIT(11 + BPF_BASE_TYPE_BITS),
>
> +       /* DYNPTR points to xdp_buff */
> +       DYNPTR_TYPE_XDP         = BIT(12 + BPF_BASE_TYPE_BITS),
> +
>         __BPF_TYPE_FLAG_MAX,
>         __BPF_TYPE_LAST_FLAG    = __BPF_TYPE_FLAG_MAX - 1,
>  };
>
> -#define DYNPTR_TYPE_FLAG_MASK  (DYNPTR_TYPE_LOCAL | DYNPTR_TYPE_RINGBUF | DYNPTR_TYPE_SKB)
> +#define DYNPTR_TYPE_FLAG_MASK  (DYNPTR_TYPE_LOCAL | DYNPTR_TYPE_RINGBUF | DYNPTR_TYPE_SKB \
> +                                | DYNPTR_TYPE_XDP)
>
>  /* Max number of base types. */
>  #define BPF_BASE_TYPE_LIMIT    (1UL << BPF_BASE_TYPE_BITS)
> diff --git a/include/linux/filter.h b/include/linux/filter.h
> index 649063d9cbfd..80f030239877 100644
> --- a/include/linux/filter.h
> +++ b/include/linux/filter.h
> @@ -1535,5 +1535,8 @@ static __always_inline int __bpf_xdp_redirect_map(struct bpf_map *map, u32 ifind
>  int __bpf_skb_load_bytes(const struct sk_buff *skb, u32 offset, void *to, u32 len);
>  int __bpf_skb_store_bytes(struct sk_buff *skb, u32 offset, const void *from,
>                           u32 len, u64 flags);
> +int __bpf_xdp_load_bytes(struct xdp_buff *xdp, u32 offset, void *buf, u32 len);
> +int __bpf_xdp_store_bytes(struct xdp_buff *xdp, u32 offset, void *buf, u32 len);
> +void *bpf_xdp_pointer(struct xdp_buff *xdp, u32 offset, u32 len);
>
>  #endif /* __LINUX_FILTER_H__ */
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 320e6b95d95c..9feea29eebcd 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -5283,13 +5283,18 @@ union bpf_attr {
>   *                   and try again.
>   *
>   *                 * The data slice is automatically invalidated anytime
> - *                   **bpf_dynptr_write**\ () or a helper call that changes
> - *                   the underlying packet buffer (eg **bpf_skb_pull_data**\ ())
> + *                   **bpf_dynptr_write**\ () is called.
> + *
> + *             For skb-type and xdp-type dynptrs:
> + *                 * The data slice is automatically invalidated anytime a
> + *                   helper call that changes the underlying packet buffer
> + *                   (eg **bpf_skb_pull_data**\ (), **bpf_xdp_adjust_head**\ ())
>   *                   is called.
>   *     Return
>   *             Pointer to the underlying dynptr data, NULL if the dynptr is
>   *             read-only, if the dynptr is invalid, or if the offset and length
> - *             is out of bounds or in a paged buffer for skb-type dynptrs.
> + *             is out of bounds or in a paged buffer for skb-type dynptrs or
> + *             across fragments for xdp-type dynptrs.
>   *
>   * s64 bpf_tcp_raw_gen_syncookie_ipv4(struct iphdr *iph, struct tcphdr *th, u32 th_len)
>   *     Description
> @@ -5388,6 +5393,19 @@ union bpf_attr {
>   *             *flags* is currently unused, it must be 0 for now.
>   *     Return
>   *             0 on success or -EINVAL if flags is not 0.
> + *
> + * long bpf_dynptr_from_xdp(struct xdp_buff *xdp_md, u64 flags, struct bpf_dynptr *ptr)
> + *     Description
> + *             Get a dynptr to the data in *xdp_md*. *xdp_md* must be the BPF program
> + *             context.
> + *
> + *             Calls that change the *xdp_md*'s underlying packet buffer
> + *             (eg **bpf_xdp_adjust_head**\ ()) do not invalidate the dynptr, but
> + *             they do invalidate any data slices associated with the dynptr.
> + *
> + *             *flags* is currently unused, it must be 0 for now.
> + *     Return
> + *             0 on success, -EINVAL if flags is not 0.
>   */
>  #define __BPF_FUNC_MAPPER(FN)          \
>         FN(unspec),                     \
> @@ -5600,6 +5618,7 @@ union bpf_attr {
>         FN(tcp_raw_check_syncookie_ipv6),       \
>         FN(ktime_get_tai_ns),           \
>         FN(dynptr_from_skb),            \
> +       FN(dynptr_from_xdp),            \
>         /* */
>
>  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
> diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
> index 471a01a9b6ae..2b9dc4c6de04 100644
> --- a/kernel/bpf/helpers.c
> +++ b/kernel/bpf/helpers.c
> @@ -1541,6 +1541,8 @@ BPF_CALL_5(bpf_dynptr_read, void *, dst, u32, len, struct bpf_dynptr_kern *, src
>                 return 0;
>         case BPF_DYNPTR_TYPE_SKB:
>                 return __bpf_skb_load_bytes(src->data, src->offset + offset, dst, len);
> +       case BPF_DYNPTR_TYPE_XDP:
> +               return __bpf_xdp_load_bytes(src->data, src->offset + offset, dst, len);
>         default:
>                 WARN(true, "bpf_dynptr_read: unknown dynptr type %d\n", type);
>                 return -EFAULT;
> @@ -1583,6 +1585,10 @@ BPF_CALL_5(bpf_dynptr_write, struct bpf_dynptr_kern *, dst, u32, offset, void *,
>         case BPF_DYNPTR_TYPE_SKB:
>                 return __bpf_skb_store_bytes(dst->data, dst->offset + offset, src, len,
>                                              flags);
> +       case BPF_DYNPTR_TYPE_XDP:
> +               if (flags)
> +                       return -EINVAL;
> +               return __bpf_xdp_store_bytes(dst->data, dst->offset + offset, src, len);
>         default:
>                 WARN(true, "bpf_dynptr_write: unknown dynptr type %d\n", type);
>                 return -EFAULT;
> @@ -1616,7 +1622,7 @@ BPF_CALL_3(bpf_dynptr_data, struct bpf_dynptr_kern *, ptr, u32, offset, u32, len
>
>         type = bpf_dynptr_get_type(ptr);
>
> -       /* Only skb dynptrs can get read-only data slices, because the
> +       /* Only skb and xdp dynptrs can get read-only data slices, because the
>          * verifier enforces PTR_TO_PACKET accesses
>          */
>         is_rdonly = bpf_dynptr_is_rdonly(ptr);
> @@ -1640,6 +1646,12 @@ BPF_CALL_3(bpf_dynptr_data, struct bpf_dynptr_kern *, ptr, u32, offset, u32, len
>                 data = skb->data;
>                 break;
>         }
> +       case BPF_DYNPTR_TYPE_XDP:
> +               /* if the requested data in across fragments, then it cannot
> +                * be accessed directly - bpf_xdp_pointer will return NULL
> +                */
> +               return (unsigned long)bpf_xdp_pointer(ptr->data,
> +                                                     ptr->offset + offset, len);
>         default:
>                 WARN(true, "bpf_dynptr_data: unknown dynptr type %d\n", type);
>                 return 0;
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 1ea295f47525..d33648eee188 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -686,6 +686,8 @@ static enum bpf_dynptr_type arg_to_dynptr_type(enum bpf_arg_type arg_type)
>                 return BPF_DYNPTR_TYPE_RINGBUF;
>         case DYNPTR_TYPE_SKB:
>                 return BPF_DYNPTR_TYPE_SKB;
> +       case DYNPTR_TYPE_XDP:
> +               return BPF_DYNPTR_TYPE_XDP;
>         default:
>                 return BPF_DYNPTR_TYPE_INVALID;
>         }
> @@ -6078,6 +6080,9 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
>                         case DYNPTR_TYPE_SKB:
>                                 err_extra = "skb ";
>                                 break;
> +                       case DYNPTR_TYPE_XDP:
> +                               err_extra = "xdp ";
> +                               break;
>                         }
>
>                         verbose(env, "Expected an initialized %sdynptr as arg #%d\n",
> @@ -7439,7 +7444,8 @@ static int check_helper_call(struct bpf_verifier_env *env, struct bpf_insn *insn
>                 mark_reg_known_zero(env, regs, BPF_REG_0);
>
>                 if (func_id == BPF_FUNC_dynptr_data &&
> -                   dynptr_type == BPF_DYNPTR_TYPE_SKB) {
> +                   (dynptr_type == BPF_DYNPTR_TYPE_SKB ||
> +                    dynptr_type == BPF_DYNPTR_TYPE_XDP)) {
>                         regs[BPF_REG_0].type = PTR_TO_PACKET | ret_flag;
>                         regs[BPF_REG_0].range = meta.mem_size;

It doesn't seem like this is safe. Since PTR_TO_PACKET's range can be
modified by comparisons with packet pointers loaded from the xdp/skb
ctx, how do we distinguish e.g. between a pkt slice obtained from some
frag in a multi-buff XDP vs pkt pointer from a linear area?

Someone can compare data_meta from ctx with PTR_TO_PACKET from
bpf_dynptr_data on xdp dynptr (which might be pointing to a xdp mb
frag). While MAX_PACKET_OFF is 0xffff, it can still be used to do OOB
access for the linear area. reg_is_init_pkt_pointer will return true
as modified range is not considered for it. Same kind of issues when
doing comparison with data_end from ctx (though maybe you won't be
able to do incorrect data access at runtime using that).

I had a pkt_uid field in my patch [0] which disallowed comparisons
among bpf_packet_pointer slices. Each call assigned a fresh pkt_uid,
and that disabled comparisons for them. reg->id is used for var_off
range propagation so it cannot be reused.

Coming back to this: What we really want here is a PTR_TO_MEM with a
mem_size, so maybe you should go that route instead of PTR_TO_PACKET
(and add a type tag to maybe pretty print it also as a packet pointer
in verifier log), or add some way to distinguish slice vs non-slice
pkt pointers like I did in my patch. You might also want to add some
tests for this corner case (there are some later in [0] if you want to
reuse them).

So TBH, I kinda dislike my own solution in [0] :). The complexity does
not seem worth it. The pkt_uid distinction is more useful (and
actually would be needed) in Toke's xdp queueing series, where in a
dequeue program you have multiple xdp_mds and want scoped slice
invalidations (i.e. adjust_head on one xdp_md doesn't invalidate
slices of some other xdp_md). Here we can just get away with normal
PTR_TO_MEM.

... Or just let me know if you handle this correctly already, or if
this won't be an actual problem :).

  [0]: https://lore.kernel.org/bpf/20220306234311.452206-3-memxor@gmail.com
