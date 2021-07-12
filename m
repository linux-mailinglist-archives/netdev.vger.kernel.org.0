Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91A3C3C62E7
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 20:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236006AbhGLStT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 14:49:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235496AbhGLStT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 14:49:19 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C714C0613DD;
        Mon, 12 Jul 2021 11:46:30 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id l5so23913338iok.7;
        Mon, 12 Jul 2021 11:46:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=tuKk8bhfAHg0RiMEXKoLyaKw1Exnm5koXX13qI5Lb+0=;
        b=M12a2V7o/eDkv3lv+4LWTPMLFywG9IRoE4KcpzEOI9OrdeKHwBpwXmedfQkDa5EI7h
         jFUNwtlXauI8OYacJ9LuqVexQxCNDBsawpjCV7xS/Scuj4uoN6Kl48l7u9xRSmUs/25R
         ggzobU4q24l1gV1z72kUBdLXC+uDnJNQS3/exO5YPN/t03M0uYQ6SC8dQtHmSPZTYxO4
         6DyWXBtgSx4iX96JbW4XBZd/UK9Xkryju64u3hg7jFOwe6E9xzermmkAMR3rx8SKiIAS
         5epVM+s3XSHo1EYR/dWJXVnIhDDl9Qbz7W8AGrHqoTcCVrgWWLCtoRXqyrmRtCPKxEIE
         fKfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=tuKk8bhfAHg0RiMEXKoLyaKw1Exnm5koXX13qI5Lb+0=;
        b=rHPiUGB7Ai6sUHs1jX3MrRQx0g7vxO8RPOPtks+WaA2X0d78WXokBU4tQvfW3z2W/g
         2vWNhVBM9V9pKV6286Ql4LjRnqw0aqg0gv3p8tFRj0l9e1fEyACfm0167lg2Wb4r7rm8
         8TD+bGGC8vDw0sTRL++BqttIzg52YFy39uwrMudjpk8aslaAlUyauaDB6Nq+cl3Ve/5K
         NTETi3lHvgR5PxrjFj+wqGZ/45INQT2k9g9bHDfNM7zGossv8Q4M7Ie3dzbZbB9HwTGy
         +5PnVxn88XW/35XJSU7YWG3tKk74gRU29aKIPdZTmcP722+PwuMxE29ca/fR//YrkFH7
         rRuQ==
X-Gm-Message-State: AOAM531Q0YdOa2YccDw+WqNxSkBRxb5LVZBpqwaEYMlx2wLVUWRvIZ7M
        00sZT7KESewo/ub585SBYOE=
X-Google-Smtp-Source: ABdhPJxr22Wndu2rvYusM5JeNjk0M34Zkz5iOlc4zqj/I7R2CekiOl9bZ4hsw2ATM3HjMr9HWAd9ag==
X-Received: by 2002:a5d:8747:: with SMTP id k7mr267069iol.83.1626115589901;
        Mon, 12 Jul 2021 11:46:29 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id b2sm5241743ioj.19.2021.07.12.11.46.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 11:46:29 -0700 (PDT)
Date:   Mon, 12 Jul 2021 11:46:22 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, alexander.duyck@gmail.com, brouer@redhat.com,
        echaudro@redhat.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Message-ID: <60ec8dfeb42aa_50e1d20857@john-XPS-13-9370.notmuch>
In-Reply-To: <16f4244f5a506143f5becde501f1ecb120255b42.1625828537.git.lorenzo@kernel.org>
References: <cover.1625828537.git.lorenzo@kernel.org>
 <16f4244f5a506143f5becde501f1ecb120255b42.1625828537.git.lorenzo@kernel.org>
Subject: RE: [PATCH bpf-next 2/2] net: xdp: add xdp_update_skb_shared_info
 utility routine
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenzo Bianconi wrote:
> Introduce xdp_update_skb_shared_info routine to update frags array
> metadata from a given xdp_buffer/xdp_frame. We do not need to reset
> frags array since it is already initialized by the driver.
> Rely on xdp_update_skb_shared_info in mvneta driver.

Some more context here would really help. I had to jump into the mvneta
driver to see what is happening.

So as I read this we have a loop processing the descriptor in
mvneta_rx_swbm()

 mvneta_rx_swbm()
   while (rx_proc < budget && rx_proc < rx_todo) {
     if (rx_status & MVNETA_RXD_FIRST_DESC) ...
     else {
       mvneta_swbm_add_rx_fragment()
     }
     ..
     if (!rx_status & MVNETA_RXD_LAST_DESC)
         continue;
     ..
     if (xdp_prog)
       mvneta_run_xdp(...)
   }

roughly looking like above. First question, do you ever hit
!MVNETA_RXD_LAST_DESC today? I assume this is avoided by hardware
setup when XDP is enabled, otherwise _run_xdp() would be
broken correct? Next question, given last descriptor bit
logic whats the condition to hit the code added in this patch?
wouldn't we need more than 1 descriptor and then we would
skip the xdp_run... sorry lost me and its probably easier
to let you give the flow vs spending an hour trying to
track it down.

But, in theory as you handle a hardware discriptor you can build
up a set of pages using them to create a single skb rather than a
skb per descriptor. But don't we know if pfmemalloc should be
done while we are building the frag list? Can't se just set it
vs this for loop in xdp_update_skb_shared_info(),

> +	for (i = 0; i < nr_frags; i++) {
> +		struct page *page = skb_frag_page(&sinfo->frags[i]);
> +
> +		page = compound_head(page);
> +		if (page_is_pfmemalloc(page)) {
> +			skb->pfmemalloc = true;
> +			break;
> +		}
> +	}
> +}

...

> diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
> index 361bc4fbe20b..abf2e50880e0 100644
> --- a/drivers/net/ethernet/marvell/mvneta.c
> +++ b/drivers/net/ethernet/marvell/mvneta.c
> @@ -2294,18 +2294,29 @@ mvneta_swbm_add_rx_fragment(struct mvneta_port *pp,
>  	rx_desc->buf_phys_addr = 0;
>  
>  	if (data_len > 0 && xdp_sinfo->nr_frags < MAX_SKB_FRAGS) {
> -		skb_frag_t *frag = &xdp_sinfo->frags[xdp_sinfo->nr_frags++];
> +		skb_frag_t *frag = &xdp_sinfo->frags[xdp_sinfo->nr_frags];
>  
>  		skb_frag_off_set(frag, pp->rx_offset_correction);
>  		skb_frag_size_set(frag, data_len);
>  		__skb_frag_set_page(frag, page);
> +		/* We don't need to reset pp_recycle here. It's already set, so
> +		 * just mark fragments for recycling.
> +		 */
> +		page_pool_store_mem_info(page, rxq->page_pool);
> +
> +		/* first fragment */
> +		if (!xdp_sinfo->nr_frags)
> +			xdp_sinfo->gso_type = *size;

Would be nice to also change 'int size' -> 'unsigned int size' so the
types matched. Presumably you really can't have a negative size.

Also how about giving gso_type a better name. xdp_sinfo->size maybe?


> +		xdp_sinfo->nr_frags++;
>  
>  		/* last fragment */
>  		if (len == *size) {
>  			struct skb_shared_info *sinfo;
>  
>  			sinfo = xdp_get_shared_info_from_buff(xdp);
> +			sinfo->xdp_frags_tsize = xdp_sinfo->nr_frags * PAGE_SIZE;
>  			sinfo->nr_frags = xdp_sinfo->nr_frags;
> +			sinfo->gso_type = xdp_sinfo->gso_type;
>  			memcpy(sinfo->frags, xdp_sinfo->frags,
>  			       sinfo->nr_frags * sizeof(skb_frag_t));
>  		}

Thanks,
John
