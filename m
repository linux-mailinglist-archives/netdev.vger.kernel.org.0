Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0142F3B10AF
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 01:38:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbhFVXkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 19:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbhFVXkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 19:40:17 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F5F5C061574;
        Tue, 22 Jun 2021 16:38:00 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id d9so1197625ioo.2;
        Tue, 22 Jun 2021 16:38:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=8fEzBbUVM6Br303r9wPjZ5cak2kYT/wYK8XH8paPOy8=;
        b=t4WqQZS7JomsUMWmchBW1LwUmA1X1tjqycdE8/wv3Ty5DZO8pMT1wLrLEIlM1zEd8B
         hGie5vpGis6A21O/bmh+ccFaLF13IBcoC8z3kNgYDCVS6pf6TzPlLD+CllvItGnTrpga
         jaPeFlzbxOQq6c9zxgIYgrtn2F+sn2w093v3TAFcw2iE4TIH5S7Sg+hVTg0M3+TPPIN3
         af60S17dcplncx8LXcAqMB3zFCO1LI6Zxfu2mdgkVWwkxZ0DZXPWwyuPQktnSYK2RcbQ
         ASxGR4ovGROCCsttE4L18YvFO9hh/34hUVLsx8w++bSsC+EvS7LMxSb9F7rSIY2kozUs
         TLcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=8fEzBbUVM6Br303r9wPjZ5cak2kYT/wYK8XH8paPOy8=;
        b=ERzVIMAioPBTp/7/iE8IXkcnE43ezvhN8pNEOsF9WzJt628Ywn6MzN2mQOb+569ynA
         G037oa0uxaPmIw3GIV6K05zE5Y+oL5hTLXRQ1Ra0FmaYBR75CddF1cWtWAQ1ZYpAwCEb
         CLYwHSGsASXhfF2RzcNI6dNHNtIf3R80LEurUGGMGVtul6PSyDY2hmM0sqIYhpYAJuCH
         PEQM8NnhU4WY43mZgVA2HF4/oLvMd6npZqivyi8EhCm5/whAVjVbI3pYyxXJ1+UcsuNQ
         OW6lHr1qL/LmgyYHsDrkVKfTawQ1UO5djRIR6X2lPzqo/DETAfO66lBHNikO1MWG5c9D
         lPTA==
X-Gm-Message-State: AOAM530UCGmhOWlfx7yQyfMtbv4/60OoUeLAtpo7TgGa53o9IouK8m/z
        tTII9Na0SgUFx2gZB2bJInA=
X-Google-Smtp-Source: ABdhPJzOpjusoTATNk78lE6l9ADCbWG7QsB5AbJP09T0NvBUROQ6qhwbsZy3kx0htbtTNqPEZ/vAIQ==
X-Received: by 2002:a05:6602:2001:: with SMTP id y1mr4815280iod.181.1624405079751;
        Tue, 22 Jun 2021 16:37:59 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id z19sm12307486ioc.29.2021.06.22.16.37.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 16:37:59 -0700 (PDT)
Date:   Tue, 22 Jun 2021 16:37:50 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        sameehj@amazon.com, john.fastabend@gmail.com, dsahern@kernel.org,
        brouer@redhat.com, echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com
Message-ID: <60d2744ee12c2_1342e208f7@john-XPS-13-9370.notmuch>
In-Reply-To: <863f4934d251f44ad85a6be08b3737fac74f9b5a.1623674025.git.lorenzo@kernel.org>
References: <cover.1623674025.git.lorenzo@kernel.org>
 <863f4934d251f44ad85a6be08b3737fac74f9b5a.1623674025.git.lorenzo@kernel.org>
Subject: RE: [PATCH v9 bpf-next 08/14] bpf: add multi-buff support to the
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

It would be nice if the commit message gave us some details on how the
growing/shrinking works in the multi-buff support.

> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  include/net/xdp.h |  7 ++++++
>  net/core/filter.c | 62 +++++++++++++++++++++++++++++++++++++++++++++++
>  net/core/xdp.c    |  5 ++--
>  3 files changed, 72 insertions(+), 2 deletions(-)
> 
> diff --git a/include/net/xdp.h b/include/net/xdp.h
> index 935a6f83115f..3525801c6ed5 100644
> --- a/include/net/xdp.h
> +++ b/include/net/xdp.h
> @@ -132,6 +132,11 @@ xdp_get_shared_info_from_buff(struct xdp_buff *xdp)
>  	return (struct skb_shared_info *)xdp_data_hard_end(xdp);
>  }
>  
> +static inline unsigned int xdp_get_frag_tailroom(const skb_frag_t *frag)
> +{
> +	return PAGE_SIZE - skb_frag_size(frag) - skb_frag_off(frag);
> +}
> +
>  struct xdp_frame {
>  	void *data;
>  	u16 len;
> @@ -259,6 +264,8 @@ struct xdp_frame *xdp_convert_buff_to_frame(struct xdp_buff *xdp)
>  	return xdp_frame;
>  }
>  
> +void __xdp_return(void *data, struct xdp_mem_info *mem, bool napi_direct,
> +		  struct xdp_buff *xdp);
>  void xdp_return_frame(struct xdp_frame *xdpf);
>  void xdp_return_frame_rx_napi(struct xdp_frame *xdpf);
>  void xdp_return_buff(struct xdp_buff *xdp);
> diff --git a/net/core/filter.c b/net/core/filter.c
> index caa88955562e..05f574a3d690 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -3859,11 +3859,73 @@ static const struct bpf_func_proto bpf_xdp_adjust_head_proto = {
>  	.arg2_type	= ARG_ANYTHING,
>  };
>  
> +static int bpf_xdp_mb_adjust_tail(struct xdp_buff *xdp, int offset)
> +{
> +	struct skb_shared_info *sinfo;
> +
> +	if (unlikely(!xdp_buff_is_mb(xdp)))
> +		return -EINVAL;
> +
> +	sinfo = xdp_get_shared_info_from_buff(xdp);
> +	if (offset >= 0) {
> +		skb_frag_t *frag = &sinfo->frags[sinfo->nr_frags - 1];
> +		int size;
> +
> +		if (unlikely(offset > xdp_get_frag_tailroom(frag)))
> +			return -EINVAL;
> +
> +		size = skb_frag_size(frag);
> +		memset(skb_frag_address(frag) + size, 0, offset);
> +		skb_frag_size_set(frag, size + offset);
> +		sinfo->data_len += offset;

Can you add some comment on how this works? So today I call
bpf_xdp_adjust_tail() to add some trailer to my packet.
This looks like it adds tailroom to the last frag? But, then
how do I insert my trailer? I don't think we can without the
extra multi-buffer access support right.

Also data_end will be unchanged yet it will return 0 so my
current programs will likely be a bit confused by this.

> +	} else {
