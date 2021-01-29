Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 448C230860C
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 07:55:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232146AbhA2GwQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 01:52:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232019AbhA2GwP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 01:52:15 -0500
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3740C061573;
        Thu, 28 Jan 2021 22:51:34 -0800 (PST)
Received: by mail-il1-x136.google.com with SMTP id p8so7652422ilg.3;
        Thu, 28 Jan 2021 22:51:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=lcJw81Q+OKYcd85kLMGnKwMb4stE73hnXSxinSG3wzU=;
        b=TF7qEdlmERYDBy5+f/Tn0iHDIVyVkna7dU5ZSAiokFioSuatlZjvhNi7mQL80AolWF
         ctsnr9xzi/1WrAkpIMzVXvDASDELXfIUJo1bfSEaHWPihPjofh7rdml2zGgxEvK+t+yI
         2XfAcMkFxFX602zqW5GOGN2tjBOPQD/5n2gPgq3vnkzvZWl3dLIeCsgIn7nbejYTpbaX
         dGUiTJ+/tL8eekEg4Y+A5sRHlU4RiYpwcarqV0P1/s+j69/Rs5Fjdgpmkkx9vUn/JSZe
         7YFQcsRdpDS680nq4GTF/5+pM4i/Mv+4+5yJDJnQ1uoYMol/YVFhUPWwzcfUzLOICs1f
         XqXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=lcJw81Q+OKYcd85kLMGnKwMb4stE73hnXSxinSG3wzU=;
        b=mLrRBKOYCbVBsKCfSlQFJsyQKdlO8CsyH2XXINPs0piAlJriZZ2vAorswzq03HkRhr
         uN9ZBMis+Zk9pH9pgscRNad69/QTKye+CjrzJ76eQknL3LlsXYkg1zUSPA9wMH5UWcWq
         hmaPq4H+eVd6ExNkXybuyBLK9FMYzrfLLg8dOc4Lc/C482VC3k5dLNm9wWMyUDCU8FUk
         JX3VkYHUqyRm6itqm6r+tMpXUA6eNa0HuGZGQcEGEnp0Drv6jQ46nw3UKfKYvPOEZj8x
         uy8/EV8weUxWXWB5kPs8bwvRH5CNm9kTt7RQaXfUI76nZRfqP5d+ZPbcgTHnKgsXDmbp
         Z5+Q==
X-Gm-Message-State: AOAM531/AaIq9Rnp0ZNF1WuqwT6eHHercLCZcNdWAN+JUl0RdT2u0zIr
        uTtRE+b3gak8UyhnFrVvrSI=
X-Google-Smtp-Source: ABdhPJwKlQmLrQcePDj3t2mULL692QF/9cp8UvqwpVu94hp3j2+1ZL412DUgzMFQpFwL1NdqvUC51w==
X-Received: by 2002:a05:6e02:dea:: with SMTP id m10mr2235927ilj.241.1611903094278;
        Thu, 28 Jan 2021 22:51:34 -0800 (PST)
Received: from localhost ([172.243.146.206])
        by smtp.gmail.com with ESMTPSA id 186sm3576466ioc.30.2021.01.28.22.51.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jan 2021 22:51:33 -0800 (PST)
Date:   Thu, 28 Jan 2021 22:51:23 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>, bpf@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com,
        colrack@gmail.com
Message-ID: <6013b06b83ae2_2683c2085d@john-XPS-13-9370.notmuch>
In-Reply-To: <161159457239.321749.9067604476261493815.stgit@firesoul>
References: <161159451743.321749.17528005626909164523.stgit@firesoul>
 <161159457239.321749.9067604476261493815.stgit@firesoul>
Subject: RE: [PATCH bpf-next V13 4/7] bpf: add BPF-helper for MTU checking
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesper Dangaard Brouer wrote:
> This BPF-helper bpf_check_mtu() works for both XDP and TC-BPF programs.
> 
> The SKB object is complex and the skb->len value (accessible from
> BPF-prog) also include the length of any extra GRO/GSO segments, but
> without taking into account that these GRO/GSO segments get added
> transport (L4) and network (L3) headers before being transmitted. Thus,
> this BPF-helper is created such that the BPF-programmer don't need to
> handle these details in the BPF-prog.
> 
> The API is designed to help the BPF-programmer, that want to do packet
> context size changes, which involves other helpers. These other helpers
> usually does a delta size adjustment. This helper also support a delta
> size (len_diff), which allow BPF-programmer to reuse arguments needed by
> these other helpers, and perform the MTU check prior to doing any actual
> size adjustment of the packet context.
> 
> It is on purpose, that we allow the len adjustment to become a negative
> result, that will pass the MTU check. This might seem weird, but it's not
> this helpers responsibility to "catch" wrong len_diff adjustments. Other
> helpers will take care of these checks, if BPF-programmer chooses to do
> actual size adjustment.
> 
> V13:
>  - Enforce flag BPF_MTU_CHK_SEGS cannot use len_diff.
> 
> V12:
>  - Simplify segment check that calls skb_gso_validate_network_len.
>  - Helpers should return long
> 
> V9:
> - Use dev->hard_header_len (instead of ETH_HLEN)
> - Annotate with unlikely req from Daniel
> - Fix logic error using skb_gso_validate_network_len from Daniel
> 
> V6:
> - Took John's advice and dropped BPF_MTU_CHK_RELAX
> - Returned MTU is kept at L3-level (like fib_lookup)
> 
> V4: Lot of changes
>  - ifindex 0 now use current netdev for MTU lookup
>  - rename helper from bpf_mtu_check to bpf_check_mtu
>  - fix bug for GSO pkt length (as skb->len is total len)
>  - remove __bpf_len_adj_positive, simply allow negative len adj
> 
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>  include/uapi/linux/bpf.h       |   67 ++++++++++++++++++++++++
>  net/core/filter.c              |  114 ++++++++++++++++++++++++++++++++++++++++
>  tools/include/uapi/linux/bpf.h |   67 ++++++++++++++++++++++++
>  3 files changed, 248 insertions(+)
> 
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 05bfc8c843dc..f17381a337ec 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -3839,6 +3839,61 @@ union bpf_attr {

[...]

> +
> +BPF_CALL_5(bpf_skb_check_mtu, struct sk_buff *, skb,
> +	   u32, ifindex, u32 *, mtu_len, s32, len_diff, u64, flags)

Maybe worth mentioning in description we expect len_diff < skb->len,
at least I expect that otherwise result may be undefined.

> +{
> +	int ret = BPF_MTU_CHK_RET_FRAG_NEEDED;
> +	struct net_device *dev = skb->dev;
> +	int skb_len, dev_len;
> +	int mtu;

Perhaps getting a bit nit-picky here but shouldn't skb_len, dev_len
and mtu all be 'unsigned int'

Then all the types will align. I guess MTUs are small so it
doesn't really matter, but is easier to read IMO.

> +
> +	if (unlikely(flags & ~(BPF_MTU_CHK_SEGS)))
> +		return -EINVAL;
> +
> +	if (unlikely(flags & BPF_MTU_CHK_SEGS && len_diff))
> +		return -EINVAL;
> +
> +	dev = __dev_via_ifindex(dev, ifindex);
> +	if (unlikely(!dev))
> +		return -ENODEV;
> +
> +	mtu = READ_ONCE(dev->mtu);
> +
> +	dev_len = mtu + dev->hard_header_len;
> +	skb_len = skb->len + len_diff; /* minus result pass check */
> +	if (skb_len <= dev_len) {

If skb_len is unsigned it will be >> dev_len when skb->len < len_diff. I
think its a good idea to throw an error if skb_len calculation goes
negative?

> +		ret = BPF_MTU_CHK_RET_SUCCESS;
> +		goto out;
> +	}
> +	/* At this point, skb->len exceed MTU, but as it include length of all
> +	 * segments, it can still be below MTU.  The SKB can possibly get
> +	 * re-segmented in transmit path (see validate_xmit_skb).  Thus, user
> +	 * must choose if segs are to be MTU checked.
> +	 */
> +	if (skb_is_gso(skb)) {
> +		ret = BPF_MTU_CHK_RET_SUCCESS;
> +
> +		if (flags & BPF_MTU_CHK_SEGS &&
> +		    !skb_gso_validate_network_len(skb, mtu))
> +			ret = BPF_MTU_CHK_RET_SEGS_TOOBIG;
> +	}
> +out:
> +	/* BPF verifier guarantees valid pointer */
> +	*mtu_len = mtu;
> +
> +	return ret;
> +}
> +
> +BPF_CALL_5(bpf_xdp_check_mtu, struct xdp_buff *, xdp,
> +	   u32, ifindex, u32 *, mtu_len, s32, len_diff, u64, flags)
> +{
> +	struct net_device *dev = xdp->rxq->dev;
> +	int xdp_len = xdp->data_end - xdp->data;
> +	int ret = BPF_MTU_CHK_RET_SUCCESS;
> +	int mtu, dev_len;

Same comment about types.

> +
> +	/* XDP variant doesn't support multi-buffer segment check (yet) */
> +	if (unlikely(flags))
> +		return -EINVAL;
> +
> +	dev = __dev_via_ifindex(dev, ifindex);
> +	if (unlikely(!dev))
> +		return -ENODEV;
> +
> +	mtu = READ_ONCE(dev->mtu);
> +
> +	/* Add L2-header as dev MTU is L3 size */
> +	dev_len = mtu + dev->hard_header_len;
> +
> +	xdp_len += len_diff; /* minus result pass check */
> +	if (xdp_len > dev_len)
> +		ret = BPF_MTU_CHK_RET_FRAG_NEEDED;
> +
> +	/* BPF verifier guarantees valid pointer */
> +	*mtu_len = mtu;
> +
> +	return ret;
> +}

Otherwise LGTM.
