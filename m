Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE91468FE0
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 05:44:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbhLFEqS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Dec 2021 23:46:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbhLFEqR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Dec 2021 23:46:17 -0500
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68393C0613F8;
        Sun,  5 Dec 2021 20:42:49 -0800 (PST)
Received: by mail-il1-x12b.google.com with SMTP id j7so8951189ilk.13;
        Sun, 05 Dec 2021 20:42:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=Xa9v0ejh68fPBoT5GfktnnRqee583EcLBsEsuZrCA+g=;
        b=h1sfPDZyR+XUrmY3wFoYrLnvYHUmQIiUe1LtVZCSf4cVH6Mr3vNXTqOGyQV0Yy4UBl
         fQrL0DgelOM7225UvXcupbbt5X+9VmlnkWJ/IAwynLe2aanEKosK92/BJa8zhKslNlWq
         fjEklTKpCzFVEsmDjQ2nJ2/ToQa8VZe7noNgH8nHTL/te5+6cM7MkeGgXBFmnfVzHVA2
         EoQ2XR+ZzHKriePghfKQIC86foWQfbXiDxEyMVJf2YYYSDwz8Utxp1u5swpGXomOFX1C
         kP/oYOhggkM3RIZ5C5ul7zHvWNqSts2R60/Ww0Gl6Flb1NvA0RPCGK+zy+BfsyJ8s1+m
         neyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=Xa9v0ejh68fPBoT5GfktnnRqee583EcLBsEsuZrCA+g=;
        b=ha7bI7rEaQch7tO0F3XTNLzwruFbcDfcy/oDeWPIy+er+KSHnKc2+7s1VI7sb+chUE
         m7XcYvhG9HM8X7R/ncm7FK+LuGlqdaDCCPJ+lnkW+7n0mCo3qWmOvdRP1Etlbe7xJimm
         qnCUfoyLnXbAcHHmxUehsOfFd+jWcnSEFWPWAECJQGYcHwgFevKjFfBufNhtVj/9ZfMy
         8+A3RzweIOFG/gGHtWyWeoFmIh8BkS8xS8xQHxvz/+N5U3K7P840fRP1tBJeQ5nNhBEA
         3ZDy64Z5Q1oU0PVHaJlEdvBH4jTI2Z6hvXWh064Qlmb4F3AJtrFuRemx6ih7iX0A8kUh
         n+/g==
X-Gm-Message-State: AOAM5339BNDMO7MrqUe3x8lJo1G2pzXxRteqIaC/zcbf8cYFUovs1YP9
        pYp01rjUTE6yNp8A8GBANf0=
X-Google-Smtp-Source: ABdhPJwA2NL8z4ue6nUUEjRV+9073uYEuibCm0+7GEGwp7kkQOMprDM7Om3EBzz/ubt7kyudYRXacQ==
X-Received: by 2002:a92:cf0d:: with SMTP id c13mr29630912ilo.319.1638765767488;
        Sun, 05 Dec 2021 20:42:47 -0800 (PST)
Received: from localhost ([172.243.151.11])
        by smtp.gmail.com with ESMTPSA id g15sm6605551ile.88.2021.12.05.20.42.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Dec 2021 20:42:46 -0800 (PST)
Date:   Sun, 05 Dec 2021 20:42:37 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Message-ID: <61ad94bde1ea6_50c22081e@john.notmuch>
In-Reply-To: <81319e52462c07361dbf99b9ec1748b41cdcf9fa.1638272238.git.lorenzo@kernel.org>
References: <cover.1638272238.git.lorenzo@kernel.org>
 <81319e52462c07361dbf99b9ec1748b41cdcf9fa.1638272238.git.lorenzo@kernel.org>
Subject: RE: [PATCH v19 bpf-next 12/23] bpf: add multi-buff support to the
 bpf_xdp_adjust_tail() API
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenzo Bianconi wrote:
> From: Eelco Chaudron <echaudro@redhat.com>
> 
> This change adds support for tail growing and shrinking for XDP multi-buff.
> 
> When called on a multi-buffer packet with a grow request, it will work
> on the last fragment of the packet. So the maximum grow size is the
> last fragments tailroom, i.e. no new buffer will be allocated.
> A XDP mb capable driver is expected to set frag_size in xdp_rxq_info data
> structure to notify the XDP core the fragment size. frag_size set to 0 is
> interpreted by the XDP core as tail growing is not allowed.
> Introduce __xdp_rxq_info_reg utility routine to initialize frag_size field.
> 
> When shrinking, it will work from the last fragment, all the way down to
> the base buffer depending on the shrinking size. It's important to mention
> that once you shrink down the fragment(s) are freed, so you can not grow
> again to the original size.
> 
> Acked-by: Jakub Kicinski <kuba@kernel.org>
> Co-developed-by: Lorenzo Bianconi <lorenzo@kernel.org>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
> ---
>  drivers/net/ethernet/marvell/mvneta.c |  3 +-
>  include/net/xdp.h                     | 16 ++++++-
>  net/core/filter.c                     | 67 +++++++++++++++++++++++++++
>  net/core/xdp.c                        | 12 +++--
>  4 files changed, 90 insertions(+), 8 deletions(-)

Some nits and one questiopn about offset > 0 on shrink.

>  void xdp_rxq_info_unreg(struct xdp_rxq_info *xdp_rxq);
>  void xdp_rxq_info_unused(struct xdp_rxq_info *xdp_rxq);
>  bool xdp_rxq_info_is_reg(struct xdp_rxq_info *xdp_rxq);
> diff --git a/net/core/filter.c b/net/core/filter.c
> index b9bfe6fac6df..ace67957e685 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -3831,11 +3831,78 @@ static const struct bpf_func_proto bpf_xdp_adjust_head_proto = {
>  	.arg2_type	= ARG_ANYTHING,
>  };
>  
> +static int bpf_xdp_mb_increase_tail(struct xdp_buff *xdp, int offset)
> +{
> +	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
> +	skb_frag_t *frag = &sinfo->frags[sinfo->nr_frags - 1];
> +	struct xdp_rxq_info *rxq = xdp->rxq;
> +	int size, tailroom;

These could be 'unsized int'.

> +
> +	if (!rxq->frag_size || rxq->frag_size > xdp->frame_sz)
> +		return -EOPNOTSUPP;
> +
> +	tailroom = rxq->frag_size - skb_frag_size(frag) - skb_frag_off(frag);
> +	if (unlikely(offset > tailroom))
> +		return -EINVAL;
> +
> +	size = skb_frag_size(frag);
> +	memset(skb_frag_address(frag) + size, 0, offset);
> +	skb_frag_size_set(frag, size + offset);

Could probably make this a helper skb_frag_grow() or something in
skbuff.h we have sub, add, put_zero, etc. there.

> +	sinfo->xdp_frags_size += offset;
> +
> +	return 0;
> +}
> +
> +static int bpf_xdp_mb_shrink_tail(struct xdp_buff *xdp, int offset)
> +{
> +	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
> +	int i, n_frags_free = 0, len_free = 0;
> +
> +	if (unlikely(offset > (int)xdp_get_buff_len(xdp) - ETH_HLEN))
> +		return -EINVAL;
> +
> +	for (i = sinfo->nr_frags - 1; i >= 0 && offset > 0; i--) {
> +		skb_frag_t *frag = &sinfo->frags[i];
> +		int size = skb_frag_size(frag);
> +		int shrink = min_t(int, offset, size);
> +
> +		len_free += shrink;
> +		offset -= shrink;
> +
> +		if (unlikely(size == shrink)) {

not so sure about the unlikely.

> +			struct page *page = skb_frag_page(frag);
> +
> +			__xdp_return(page_address(page), &xdp->rxq->mem,
> +				     false, NULL);
> +			n_frags_free++;
> +		} else {
> +			skb_frag_size_set(frag, size - shrink);

skb_frag_size_sub() maybe, but you need to pull out size anyways
so its not a big deal to me.

> +			break;
> +		}
> +	}
> +	sinfo->nr_frags -= n_frags_free;
> +	sinfo->xdp_frags_size -= len_free;
> +
> +	if (unlikely(offset > 0)) {

hmm whats the case for offset to != 0? Seems with initial unlikely
check and shrinking while walking backwards through the frags it
should be zero? Maybe a comment would help?

> +		xdp_buff_clear_mb(xdp);
> +		xdp->data_end -= offset;
> +	}
> +
> +	return 0;
> +}
> +
>  BPF_CALL_2(bpf_xdp_adjust_tail, struct xdp_buff *, xdp, int, offset)
>  {
>  	void *data_hard_end = xdp_data_hard_end(xdp); /* use xdp->frame_sz */
>  	void *data_end = xdp->data_end + offset;
>  
> +	if (unlikely(xdp_buff_is_mb(xdp))) { /* xdp multi-buffer */
> +		if (offset < 0)
> +			return bpf_xdp_mb_shrink_tail(xdp, -offset);
> +
> +		return bpf_xdp_mb_increase_tail(xdp, offset);
> +	}
> +
>  	/* Notice that xdp_data_hard_end have reserved some tailroom */
>  	if (unlikely(data_end > data_hard_end))
>  		return -EINVAL;

[...]

Thanks,
John
