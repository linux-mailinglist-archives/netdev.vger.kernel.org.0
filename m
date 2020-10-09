Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9FB289C26
	for <lists+netdev@lfdr.de>; Sat, 10 Oct 2020 01:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727610AbgJIXgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 19:36:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727220AbgJIX3t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 19:29:49 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADA8EC0613D2
        for <netdev@vger.kernel.org>; Fri,  9 Oct 2020 16:29:58 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id g7so11923845iov.13
        for <netdev@vger.kernel.org>; Fri, 09 Oct 2020 16:29:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=X8GXAGVLmkdbvIpzG0DfyE1Tx1pJmKswm4SaQAsxBIg=;
        b=s7kqvVGiwoavLasPftb9/T1tBL9EKx8IK2iGbjCRROz7b/2vmwMditJAdrOzNiSadO
         otwakAxgJjb0MLKvjfJ1BS2xADV85n06AuqyE5P7jwDMLu/zk9O7v6Pvf/8OdK2OrADp
         tLl0tIXDvv2rzMo0HnLOtSwvquxBPsUPzZzcqqdrby7V/gkJ5QGtIEHKruvUNh6fp9S0
         0e0ZrusspXrLDS4ffB6/6Vq+c3I1884NmcwNKzctsWT6SJf00d4Gp3EwbWMOVvIGuvot
         PBgzoj/znNCilw1+0WQyWt/KDCsFG4kzNXG6ILZOx7KIH0yIkd6Ud3rd+FofMhAt/ZIq
         iHpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=X8GXAGVLmkdbvIpzG0DfyE1Tx1pJmKswm4SaQAsxBIg=;
        b=GtTmo2Vk/x8oPggiBoWYmo1QDqPuHiLr1twcECyzmDi3T3b6LRtVb0iV8ovhNnH3zd
         BpQwtfIydiFd7JkLf9cuYxx9oUez4EUowjLNg8N0b3+m/NfyQ+y4qbroiRTDAGIEIjZM
         9E7+0Ge008zkB4azRNoOQF/0nlu1NnEz/388u/qUkWXlEFtBOMLZSgQmwow85f+a2OWk
         wTsBuyOq5zszuG8LovamoG3msCwSWNAkANpNgZb+L43tJu5InDejJFOmOh4Q1Tq12St4
         WRPJrs3c2ixfUocPYYzG/3XW0avtPjPXZ+VrUQIfygNK9Cco43Gk6UuCrFtm5ZhT1bDN
         9Dfg==
X-Gm-Message-State: AOAM532tiYYGTZPZLl+nggYFUtNCr5IhAqjQgucu7+urC4H6bBDmi7gx
        uakWfkkXvfqliyjMrysOeUGhTzeu3l2BQ0QS7kEHY/CcyRs=
X-Google-Smtp-Source: ABdhPJyuxikiGcB/VFyjn7avZTPwnIkIgDt2uV39np0XLijqIB35fkPg8nDWNjFXMoX94/jKNQcHjEG/5esEUZt/aOY=
X-Received: by 2002:a02:a10f:: with SMTP id f15mr12170175jag.62.1602286197677;
 Fri, 09 Oct 2020 16:29:57 -0700 (PDT)
MIME-Version: 1.0
References: <160216609656.882446.16642490462568561112.stgit@firesoul> <160216615258.882446.12640007391672866038.stgit@firesoul>
In-Reply-To: <160216615258.882446.12640007391672866038.stgit@firesoul>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date:   Fri, 9 Oct 2020 16:29:46 -0700
Message-ID: <CANP3RGdq-irQ7w8=1xWNPh0Fn+72d9wrKR24vQJTFMa8w4+b6w@mail.gmail.com>
Subject: Re: [PATCH bpf-next V3 3/6] bpf: add BPF-helper for MTU checking
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     bpf <bpf@vger.kernel.org>, Linux NetDev <netdev@vger.kernel.org>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Shaun Crampton <shaun@tigera.io>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Marek Majkowski <marek@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eyal Birger <eyal.birger@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 8, 2020 at 7:09 AM Jesper Dangaard Brouer <brouer@redhat.com> wrote:
>
> This BPF-helper bpf_mtu_check() works for both XDP and TC-BPF programs.

bpf_check_mtu() seems a better name.

>
> The API is designed to help the BPF-programmer, that want to do packet
> context size changes, which involves other helpers. These other helpers
> usually does a delta size adjustment. This helper also support a delta
> size (len_diff), which allow BPF-programmer to reuse arguments needed by
> these other helpers, and perform the MTU check prior to doing any actual
> size adjustment of the packet context.
>
> V3: Take L2/ETH_HLEN header size into account and document it.
>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>  include/uapi/linux/bpf.h       |   63 +++++++++++++++++++++
>  net/core/filter.c              |  119 ++++++++++++++++++++++++++++++++++++++++
>  tools/include/uapi/linux/bpf.h |   63 +++++++++++++++++++++
>  3 files changed, 245 insertions(+)
>
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 4a46a1de6d16..1dcf5d8195f4 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -3718,6 +3718,56 @@ union bpf_attr {
>   *             never return NULL.
>   *     Return
>   *             A pointer pointing to the kernel percpu variable on this cpu.
> + *
> + * int bpf_mtu_check(void *ctx, u32 ifindex, u32 *mtu_result, s32 len_diff, u64 flags)
> + *     Description
> + *             Check ctx packet size against MTU of net device (based on
> + *             *ifindex*).  This helper will likely be used in combination with
> + *             helpers that adjust/change the packet size.  The argument
> + *             *len_diff* can be used for querying with a planned size
> + *             change. This allows to check MTU prior to changing packet ctx.
> + *
> + *             The Linux kernel route table can configure MTUs on a more
> + *             specific per route level, which is not provided by this helper.
> + *             For route level MTU checks use the **bpf_fib_lookup**\ ()
> + *             helper.
> + *
> + *             *ctx* is either **struct xdp_md** for XDP programs or
> + *             **struct sk_buff** for tc cls_act programs.
> + *
> + *             The *flags* argument can be a combination of one or more of the
> + *             following values:
> + *
> + *              **BPF_MTU_CHK_RELAX**
> + *                     This flag relax or increase the MTU with room for one
> + *                     VLAN header (4 bytes) and take into account net device
> + *                     hard_header_len.  This relaxation is also used by the
> + *                     kernels own forwarding MTU checks.
> + *
> + *             **BPF_MTU_CHK_GSO**
> + *                     This flag will only works for *ctx* **struct sk_buff**.
> + *                     If packet context contains extra packet segment buffers
> + *                     (often knows as frags), then those are also checked
> + *                     against the MTU size.

naming is weird... what does GSO have to do with frags?
Aren't these orthogonal things?

> + *
> + *             The *mtu_result* pointer contains the MTU value of the net
> + *             device including the L2 header size (usually 14 bytes Ethernet
> + *             header). The net device configured MTU is the L3 size, but as
> + *             XDP and TX length operate at L2 this helper include L2 header
> + *             size in reported MTU.
> + *
> + *     Return
> + *             * 0 on success, and populate MTU value in *mtu_result* pointer.
> + *
> + *             * < 0 if any input argument is invalid (*mtu_result* not updated)

not -EINVAL?

> + *
> + *             MTU violations return positive values, but also populate MTU
> + *             value in *mtu_result* pointer, as this can be needed for
> + *             implemeting PMTU handing:
implementing

> + *
> + *             * **BPF_MTU_CHK_RET_FRAG_NEEDED**
> + *             * **BPF_MTU_CHK_RET_GSO_TOOBIG**
> + *
>   */
>  #define __BPF_FUNC_MAPPER(FN)          \
>         FN(unspec),                     \
> @@ -3875,6 +3925,7 @@ union bpf_attr {
>         FN(redirect_neigh),             \
>         FN(bpf_per_cpu_ptr),            \
>         FN(bpf_this_cpu_ptr),           \
> +       FN(mtu_check),                  \
>         /* */
>
>  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
> @@ -4889,6 +4940,18 @@ struct bpf_fib_lookup {
>         __u8    dmac[6];     /* ETH_ALEN */
>  };
>
> +/* bpf_mtu_check flags*/
> +enum  bpf_mtu_check_flags {
> +       BPF_MTU_CHK_RELAX = (1U << 0),
> +       BPF_MTU_CHK_GSO   = (1U << 1),
> +};
> +
> +enum bpf_mtu_check_ret {
> +       BPF_MTU_CHK_RET_SUCCESS,      /* check and lookup successful */
> +       BPF_MTU_CHK_RET_FRAG_NEEDED,  /* fragmentation required to fwd */
> +       BPF_MTU_CHK_RET_GSO_TOOBIG,   /* GSO re-segmentation needed to fwd */
> +};
> +
>  enum bpf_task_fd_type {
>         BPF_FD_TYPE_RAW_TRACEPOINT,     /* tp name */
>         BPF_FD_TYPE_TRACEPOINT,         /* tp name */
> diff --git a/net/core/filter.c b/net/core/filter.c
> index da74d6ddc4d7..5986156e700e 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -5513,6 +5513,121 @@ static const struct bpf_func_proto bpf_skb_fib_lookup_proto = {
>         .arg4_type      = ARG_ANYTHING,
>  };
>
> +static int bpf_mtu_lookup(struct net *netns, u32 ifindex, u64 flags)

bpf_lookup_mtu() ???

> +{
> +       struct net_device *dev;
> +       int mtu;
> +
> +       dev = dev_get_by_index_rcu(netns, ifindex);

my understanding is this is a bit of a perf hit, maybe ifindex 0 means
use skb->dev ???
or have bpf_lookup_mtu(skb) function as well?

> +       if (!dev)
> +               return -ENODEV;
> +
> +       /* XDP+TC len is L2: Add L2-header as dev MTU is L3 size */
> +       mtu = dev->mtu + dev->hard_header_len;
> +
> +       /*  Same relax as xdp_ok_fwd_dev() and is_skb_forwardable() */
> +       if (flags & BPF_MTU_CHK_RELAX)

could this check device vlan tx offload state instead?

> +               mtu += VLAN_HLEN;
> +
> +       return mtu;
> +}
> +
> +static unsigned int __bpf_len_adjust_positive(unsigned int len, int len_diff)
> +{
> +       int len_new = len + len_diff; /* notice len_diff can be negative */
> +
> +       if (len_new > 0)
> +               return len_new;
> +
> +       return 0;

not return len ?

oh I see the function doesn't do what the name implies...
nor sure this func is helpful... why not simply int len_new = (int)len
+ (int)len_diff; directly down below and check < 0 there?
>2GB skb->len is meaningless anyway

> +}
> +
> +BPF_CALL_5(bpf_skb_mtu_check, struct sk_buff *, skb,
> +          u32, ifindex, u32 *, mtu_result, s32, len_diff, u64, flags)
> +{
> +       struct net *netns = dev_net(skb->dev);
> +       int ret = BPF_MTU_CHK_RET_SUCCESS;
> +       unsigned int len = skb->len;
> +       int mtu;
> +
> +       if (flags & ~(BPF_MTU_CHK_RELAX | BPF_MTU_CHK_GSO))
> +               return -EINVAL;
> +
> +       mtu = bpf_mtu_lookup(netns, ifindex, flags);
> +       if (unlikely(mtu < 0))
> +               return mtu; /* errno */
> +
> +       len = __bpf_len_adjust_positive(len, len_diff);
> +       if (len > mtu) {
> +               ret = BPF_MTU_CHK_RET_FRAG_NEEDED;

Can't this fail if skb->len includes the entire packet, and yet gso is
on, and packet is greater then mtu, yet gso size is smaller?

Think 200 byte gso packet with 2 100 byte segs, and a 150 byte mtu.
Does gso actually require frags?  [As you can tell I don't have a good
handle on gso vs frags vs skb->len, maybe what I"m asking is bogus]


> +               goto out;
> +       }
> +
> +       if (flags & BPF_MTU_CHK_GSO &&
> +           skb_is_gso(skb) &&
> +           skb_gso_validate_network_len(skb, mtu)) {
> +               ret = BPF_MTU_CHK_RET_GSO_TOOBIG;
> +               goto out;
> +       }
> +
> +out:
> +       if (mtu_result)
> +               *mtu_result = mtu;
> +
> +       return ret;
> +}
> +
> +BPF_CALL_5(bpf_xdp_mtu_check, struct xdp_buff *, xdp,
> +          u32, ifindex, u32 *, mtu_result, s32, len_diff, u64, flags)
> +{
> +       unsigned int len = xdp->data_end - xdp->data;
> +       struct net_device *dev = xdp->rxq->dev;
> +       struct net *netns = dev_net(dev);
> +       int ret = BPF_MTU_CHK_RET_SUCCESS;
> +       int mtu;
> +
> +       /* XDP variant doesn't support multi-buffer segment check (yet) */
> +       if (flags & ~BPF_MTU_CHK_RELAX)
> +               return -EINVAL;
> +
> +       mtu = bpf_mtu_lookup(netns, ifindex, flags);
> +       if (unlikely(mtu < 0))
> +               return mtu; /* errno */
> +
> +       len = __bpf_len_adjust_positive(len, len_diff);
> +       if (len > mtu) {
> +               ret = BPF_MTU_CHK_RET_FRAG_NEEDED;
> +               goto out;
> +       }
> +out:
> +       if (mtu_result)
> +               *mtu_result = mtu;
> +
> +       return ret;
> +}
> +
> +static const struct bpf_func_proto bpf_skb_mtu_check_proto = {
> +       .func           = bpf_skb_mtu_check,
> +       .gpl_only       = true,
> +       .ret_type       = RET_INTEGER,
> +       .arg1_type      = ARG_PTR_TO_CTX,
> +       .arg2_type      = ARG_ANYTHING,
> +       .arg3_type      = ARG_PTR_TO_MEM,
> +       .arg4_type      = ARG_ANYTHING,
> +       .arg5_type      = ARG_ANYTHING,
> +};
> +
> +static const struct bpf_func_proto bpf_xdp_mtu_check_proto = {
> +       .func           = bpf_xdp_mtu_check,
> +       .gpl_only       = true,
> +       .ret_type       = RET_INTEGER,
> +       .arg1_type      = ARG_PTR_TO_CTX,
> +       .arg2_type      = ARG_ANYTHING,
> +       .arg3_type      = ARG_PTR_TO_MEM,
> +       .arg4_type      = ARG_ANYTHING,
> +       .arg5_type      = ARG_ANYTHING,
> +};
> +
>  #if IS_ENABLED(CONFIG_IPV6_SEG6_BPF)
>  static int bpf_push_seg6_encap(struct sk_buff *skb, u32 type, void *hdr, u32 len)
>  {
> @@ -7076,6 +7191,8 @@ tc_cls_act_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>                 return &bpf_get_socket_uid_proto;
>         case BPF_FUNC_fib_lookup:
>                 return &bpf_skb_fib_lookup_proto;
> +       case BPF_FUNC_mtu_check:
> +               return &bpf_skb_mtu_check_proto;
>         case BPF_FUNC_sk_fullsock:
>                 return &bpf_sk_fullsock_proto;
>         case BPF_FUNC_sk_storage_get:
> @@ -7145,6 +7262,8 @@ xdp_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>                 return &bpf_xdp_adjust_tail_proto;
>         case BPF_FUNC_fib_lookup:
>                 return &bpf_xdp_fib_lookup_proto;
> +       case BPF_FUNC_mtu_check:
> +               return &bpf_xdp_mtu_check_proto;
>  #ifdef CONFIG_INET
>         case BPF_FUNC_sk_lookup_udp:
>                 return &bpf_xdp_sk_lookup_udp_proto;
> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> index 4a46a1de6d16..1dcf5d8195f4 100644
> --- a/tools/include/uapi/linux/bpf.h
> +++ b/tools/include/uapi/linux/bpf.h
> @@ -3718,6 +3718,56 @@ union bpf_attr {
>   *             never return NULL.
>   *     Return
>   *             A pointer pointing to the kernel percpu variable on this cpu.
> + *
> + * int bpf_mtu_check(void *ctx, u32 ifindex, u32 *mtu_result, s32 len_diff, u64 flags)
> + *     Description
> + *             Check ctx packet size against MTU of net device (based on
> + *             *ifindex*).  This helper will likely be used in combination with
> + *             helpers that adjust/change the packet size.  The argument
> + *             *len_diff* can be used for querying with a planned size
> + *             change. This allows to check MTU prior to changing packet ctx.
> + *
> + *             The Linux kernel route table can configure MTUs on a more
> + *             specific per route level, which is not provided by this helper.
> + *             For route level MTU checks use the **bpf_fib_lookup**\ ()
> + *             helper.
> + *
> + *             *ctx* is either **struct xdp_md** for XDP programs or
> + *             **struct sk_buff** for tc cls_act programs.
> + *
> + *             The *flags* argument can be a combination of one or more of the
> + *             following values:
> + *
> + *              **BPF_MTU_CHK_RELAX**
> + *                     This flag relax or increase the MTU with room for one
> + *                     VLAN header (4 bytes) and take into account net device
> + *                     hard_header_len.  This relaxation is also used by the
> + *                     kernels own forwarding MTU checks.
> + *
> + *             **BPF_MTU_CHK_GSO**
> + *                     This flag will only works for *ctx* **struct sk_buff**.
> + *                     If packet context contains extra packet segment buffers
> + *                     (often knows as frags), then those are also checked
> + *                     against the MTU size.
> + *
> + *             The *mtu_result* pointer contains the MTU value of the net
> + *             device including the L2 header size (usually 14 bytes Ethernet
> + *             header). The net device configured MTU is the L3 size, but as
> + *             XDP and TX length operate at L2 this helper include L2 header
> + *             size in reported MTU.
> + *
> + *     Return
> + *             * 0 on success, and populate MTU value in *mtu_result* pointer.
> + *
> + *             * < 0 if any input argument is invalid (*mtu_result* not updated)
> + *
> + *             MTU violations return positive values, but also populate MTU
> + *             value in *mtu_result* pointer, as this can be needed for
> + *             implemeting PMTU handing:
> + *
> + *             * **BPF_MTU_CHK_RET_FRAG_NEEDED**
> + *             * **BPF_MTU_CHK_RET_GSO_TOOBIG**
> + *
>   */
>  #define __BPF_FUNC_MAPPER(FN)          \
>         FN(unspec),                     \
> @@ -3875,6 +3925,7 @@ union bpf_attr {
>         FN(redirect_neigh),             \
>         FN(bpf_per_cpu_ptr),            \
>         FN(bpf_this_cpu_ptr),           \
> +       FN(mtu_check),                  \
>         /* */
>
>  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
> @@ -4889,6 +4940,18 @@ struct bpf_fib_lookup {
>         __u8    dmac[6];     /* ETH_ALEN */
>  };
>
> +/* bpf_mtu_check flags*/
> +enum  bpf_mtu_check_flags {
> +       BPF_MTU_CHK_RELAX = (1U << 0),
> +       BPF_MTU_CHK_GSO   = (1U << 1),
> +};
> +
> +enum bpf_mtu_check_ret {
> +       BPF_MTU_CHK_RET_SUCCESS,      /* check and lookup successful */
> +       BPF_MTU_CHK_RET_FRAG_NEEDED,  /* fragmentation required to fwd */
> +       BPF_MTU_CHK_RET_GSO_TOOBIG,   /* GSO re-segmentation needed to fwd */
> +};
> +
>  enum bpf_task_fd_type {
>         BPF_FD_TYPE_RAW_TRACEPOINT,     /* tp name */
>         BPF_FD_TYPE_TRACEPOINT,         /* tp name */
