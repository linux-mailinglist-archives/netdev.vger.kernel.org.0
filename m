Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C28C2CDD99
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 19:29:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502124AbgLCS01 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 13:26:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502109AbgLCS0X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 13:26:23 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 594F5C061A4F
        for <netdev@vger.kernel.org>; Thu,  3 Dec 2020 10:25:43 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id n62so3757356ybf.19
        for <netdev@vger.kernel.org>; Thu, 03 Dec 2020 10:25:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=JPsN81bxaH3Ux+uDJE0JlEaY8H7Xb5K1SpTIB3jRpaw=;
        b=UJS/OFXEGOMe1ifwLwUCjGVqX1vxI8HMYj/Gez/KqHycUcZxlb4m75ChGCc8xkEZUc
         Sk//D/yaa2KhcgHBQK+Ojc2B4xapTyCLy2cH5jGKHqsj6Xit//Z8DeCH1xbX7NcmEiYM
         6aUVM0tgUDf0uECS5VROAeC0+6wbdawjP7E4Lkrz13siR9pVI+ftorKfqtm3bZswK1MR
         gtER3942F8e+AKtnpD9QMcw3FR/LVJVilRFNDMLUZnaafz53bC3kk0rPVexJbs6Hpw+a
         UCGnk7KOhn6+e24M5qoFedBjSFpPVGouSCAbwWXP7q3Spvi1qKA96Fx5BCK3k1emPD/y
         EFLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=JPsN81bxaH3Ux+uDJE0JlEaY8H7Xb5K1SpTIB3jRpaw=;
        b=IWcXlWyhbc5o1GRw6GCWekg2GVN9m7Pkbmf4b2D04lwzbu2dDkv44lNA6T8mqaw5M8
         Js7CwI3Q+VtvoP8pSvfUWM1g9TTe5jT97tk9wBdgtW+qy/UGLKnv3vEN1B5+yhbe0wh1
         FRaukL6DFnrScwcRfKqJ8UO116FiJaQgIDVddik1Y7vybJZk+dxOxBjEBF21cqWg5xZU
         q1Ix9WfqOsX48TEXK1i0IRA2LK5cfR8wAtH8KGPmqf0VGpEt5WPMoLxp779kQSyRKCkO
         MZ40Qhr9l5fBbfvF6XnMcKs21uwJfjUzafdg/hbBnILnSPR0ohkx2D4IQt3MNkRKI+Et
         1XFQ==
X-Gm-Message-State: AOAM532aAMEeJ6sljnT71yVMfZ7ZVha8b9G6vwGWvm//zV951DHY8I7w
        2cxabR5/+NoxyIzuH2eNy+5X5WA=
X-Google-Smtp-Source: ABdhPJzUtZEYQ3Mt8tXuptHj6K6LCLFwSd/QccAjB6zAUKfwk6spkm/+tcwHPCUsTw4tXrZ/5Q92Ngo=
Sender: "sdf via sendgmr" <sdf@sdf2.svl.corp.google.com>
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:1:7220:84ff:fe09:7732])
 (user=sdf job=sendgmr) by 2002:a25:b11e:: with SMTP id g30mr572286ybj.71.1607019942548;
 Thu, 03 Dec 2020 10:25:42 -0800 (PST)
Date:   Thu, 3 Dec 2020 10:25:41 -0800
In-Reply-To: <160588910708.2817268.17750536562819017509.stgit@firesoul>
Message-Id: <X8ktpX/BYfiL0l2l@google.com>
Mime-Version: 1.0
References: <160588903254.2817268.4861837335793475314.stgit@firesoul> <160588910708.2817268.17750536562819017509.stgit@firesoul>
Subject: Re: [PATCH bpf-next V7 4/8] bpf: add BPF-helper for MTU checking
From:   sdf@google.com
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com,
        colrack@gmail.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/20, Jesper Dangaard Brouer wrote:
> This BPF-helper bpf_check_mtu() works for both XDP and TC-BPF programs.

> The SKB object is complex and the skb->len value (accessible from
> BPF-prog) also include the length of any extra GRO/GSO segments, but
> without taking into account that these GRO/GSO segments get added
> transport (L4) and network (L3) headers before being transmitted. Thus,
> this BPF-helper is created such that the BPF-programmer don't need to
> handle these details in the BPF-prog.

> The API is designed to help the BPF-programmer, that want to do packet
> context size changes, which involves other helpers. These other helpers
> usually does a delta size adjustment. This helper also support a delta
> size (len_diff), which allow BPF-programmer to reuse arguments needed by
> these other helpers, and perform the MTU check prior to doing any actual
> size adjustment of the packet context.

> It is on purpose, that we allow the len adjustment to become a negative
> result, that will pass the MTU check. This might seem weird, but it's not
> this helpers responsibility to "catch" wrong len_diff adjustments. Other
> helpers will take care of these checks, if BPF-programmer chooses to do
> actual size adjustment.

> V6:
> - Took John's advice and dropped BPF_MTU_CHK_RELAX
> - Returned MTU is kept at L3-level (like fib_lookup)

> V4: Lot of changes
>   - ifindex 0 now use current netdev for MTU lookup
>   - rename helper from bpf_mtu_check to bpf_check_mtu
>   - fix bug for GSO pkt length (as skb->len is total len)
>   - remove __bpf_len_adj_positive, simply allow negative len adj

> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>   include/uapi/linux/bpf.h       |   67 ++++++++++++++++++++++
>   net/core/filter.c              |  122  
> ++++++++++++++++++++++++++++++++++++++++
>   tools/include/uapi/linux/bpf.h |   67 ++++++++++++++++++++++
>   3 files changed, 256 insertions(+)

> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index beacd312ea17..2619ea8c5a08 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -3790,6 +3790,61 @@ union bpf_attr {
>    *		*ARG_PTR_TO_BTF_ID* of type *task_struct*.
>    *	Return
>    *		Pointer to the current task.
> + *
> + * int bpf_check_mtu(void *ctx, u32 ifindex, u32 *mtu_len, s32 len_diff,  
> u64 flags)
> + *	Description
> + *		Check ctx packet size against MTU of net device (based on
> + *		*ifindex*).  This helper will likely be used in combination with
> + *		helpers that adjust/change the packet size.  The argument
> + *		*len_diff* can be used for querying with a planned size
> + *		change. This allows to check MTU prior to changing packet ctx.
> + *
> + *		Specifying *ifindex* zero means the MTU check is performed
> + *		against the current net device.  This is practical if this isn't
> + *		used prior to redirect.
> + *
> + *		The Linux kernel route table can configure MTUs on a more
> + *		specific per route level, which is not provided by this helper.
> + *		For route level MTU checks use the **bpf_fib_lookup**\ ()
> + *		helper.
> + *
> + *		*ctx* is either **struct xdp_md** for XDP programs or
> + *		**struct sk_buff** for tc cls_act programs.
> + *
> + *		The *flags* argument can be a combination of one or more of the
> + *		following values:
> + *
> + *		**BPF_MTU_CHK_SEGS**
> + *			This flag will only works for *ctx* **struct sk_buff**.
> + *			If packet context contains extra packet segment buffers
> + *			(often knows as GSO skb), then MTU check is harder to
> + *			check at this point, because in transmit path it is
> + *			possible for the skb packet to get re-segmented
> + *			(depending on net device features).  This could still be
> + *			a MTU violation, so this flag enables performing MTU
> + *			check against segments, with a different violation
> + *			return code to tell it apart. Check cannot use len_diff.
> + *
> + *		On return *mtu_len* pointer contains the MTU value of the net
> + *		device.  Remember the net device configured MTU is the L3 size,
> + *		which is returned here and XDP and TX length operate at L2.
> + *		Helper take this into account for you, but remember when using
> + *		MTU value in your BPF-code.  On input *mtu_len* must be a valid
> + *		pointer and be initialized (to zero), else verifier will reject
> + *		BPF program.
> + *
> + *	Return
> + *		* 0 on success, and populate MTU value in *mtu_len* pointer.
> + *
> + *		* < 0 if any input argument is invalid (*mtu_len* not updated)
> + *
> + *		MTU violations return positive values, but also populate MTU
> + *		value in *mtu_len* pointer, as this can be needed for
> + *		implementing PMTU handing:
> + *
> + *		* **BPF_MTU_CHK_RET_FRAG_NEEDED**
> + *		* **BPF_MTU_CHK_RET_SEGS_TOOBIG**
> + *
>    */
>   #define __BPF_FUNC_MAPPER(FN)		\
>   	FN(unspec),			\
> @@ -3951,6 +4006,7 @@ union bpf_attr {
>   	FN(task_storage_get),		\
>   	FN(task_storage_delete),	\
>   	FN(get_current_task_btf),	\
> +	FN(check_mtu),			\
>   	/* */

>   /* integer value in 'imm' field of BPF_CALL instruction selects which  
> helper
> @@ -4978,6 +5034,17 @@ struct bpf_redir_neigh {
>   	};
>   };

> +/* bpf_check_mtu flags*/
> +enum  bpf_check_mtu_flags {
> +	BPF_MTU_CHK_SEGS  = (1U << 0),
> +};
> +
> +enum bpf_check_mtu_ret {
> +	BPF_MTU_CHK_RET_SUCCESS,      /* check and lookup successful */
> +	BPF_MTU_CHK_RET_FRAG_NEEDED,  /* fragmentation required to fwd */
> +	BPF_MTU_CHK_RET_SEGS_TOOBIG,  /* GSO re-segmentation needed to fwd */
> +};
> +
>   enum bpf_task_fd_type {
>   	BPF_FD_TYPE_RAW_TRACEPOINT,	/* tp name */
>   	BPF_FD_TYPE_TRACEPOINT,		/* tp name */
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 25b137ffdced..d6125cfc49c3 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -5604,6 +5604,124 @@ static const struct bpf_func_proto  
> bpf_skb_fib_lookup_proto = {
>   	.arg4_type	= ARG_ANYTHING,
>   };

> +static struct net_device *__dev_via_ifindex(struct net_device *dev_curr,
> +					    u32 ifindex)
> +{
> +	struct net *netns = dev_net(dev_curr);
> +
> +	/* Non-redirect use-cases can use ifindex=0 and save ifindex lookup */
> +	if (ifindex == 0)
> +		return dev_curr;
> +
> +	return dev_get_by_index_rcu(netns, ifindex);
> +}
> +
> +BPF_CALL_5(bpf_skb_check_mtu, struct sk_buff *, skb,
> +	   u32, ifindex, u32 *, mtu_len, s32, len_diff, u64, flags)
> +{
> +	int ret = BPF_MTU_CHK_RET_FRAG_NEEDED;
> +	struct net_device *dev = skb->dev;
> +	int len;
> +	int mtu;
> +
> +	if (flags & ~(BPF_MTU_CHK_SEGS))
> +		return -EINVAL;
> +
> +	dev = __dev_via_ifindex(dev, ifindex);
> +	if (!dev)
> +		return -ENODEV;
> +
> +	mtu = READ_ONCE(dev->mtu);
> +
> +	/* TC len is L2, remove L2-header as dev MTU is L3 size */

[..]
> +	len = skb->len - ETH_HLEN;
Any reason not to do s/ETH_HLEN/dev->hard_header_len/ (or min_header_len?)
thought this patch?
