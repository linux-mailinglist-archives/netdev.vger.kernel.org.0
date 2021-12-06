Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2062468F81
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 04:07:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235571AbhLFDKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Dec 2021 22:10:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235402AbhLFDKc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Dec 2021 22:10:32 -0500
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9664C0613F8;
        Sun,  5 Dec 2021 19:07:04 -0800 (PST)
Received: by mail-il1-x134.google.com with SMTP id m5so8801002ilh.11;
        Sun, 05 Dec 2021 19:07:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=X55f6rIyxMAeTkg3TDveTFlB+gqqpA+K+Mun7+M717g=;
        b=mknr1zSxDyDbvYIPNQQVYXP3WrHtVHy2+70P/ZIsDsoqtkDAtzuEYjDoIJkV1J73DA
         bujhgI48w3dTh8yi+irxuVzCiJagWpFVlF5OTvv/VtpAw3q5ZDb7sD1bHZ32lJcqTMco
         YzCbWSgJqs9x8KZoEk7jji2Z2XAZXoJj/Q1ph+x8111Oks0zvssR0NKQksxNGz8sDshX
         i+FXsPAJUh6Yrc3md4//SS5wgd5h681kHo7d7leh9Pb4b4KZFvZQ4xt4f7Moku6lpv91
         Sfzk/Vzt9wgyRm2SStVmIwUH4/XESnYm3ibbXN7kKTzkTP34xtIhBsZLHVEE7VkhYg3H
         SVTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=X55f6rIyxMAeTkg3TDveTFlB+gqqpA+K+Mun7+M717g=;
        b=CKlqCDp4E1Gp9L6az6yBnm2kduM+9G37ahjfgKo5jciVf2BiOjQDnqZNcmzrme/UOX
         JrvIQ+0Br+NUB84/crE4OkafPFDk0oDNfWlCym7kZ9wpWl0cvmohNdGtD5Nj9qDVKm7n
         C5v8GBZAvey2vdWKduMJ8a5DCYS9wXgBOD0T6LJp2NEwPOp5jMMQGHomV5vdx3Gp9Ul4
         2DO9eSkwpfnIbuTwObCVC1kM6LkCDYPtihWbtSudRfw94hKFt1ZkOMCORLVlD1ZaTMwq
         Q5Y6XzZEfYM8eqSqUSwdqfV1Mee9xXCnCBozi1aeGI6OdmssxRz9ytwmxwMe8q21qute
         PAaw==
X-Gm-Message-State: AOAM533tbvapWJUK/cgS2tnMDy9vyF7tmzK/OSpqi5KQjtCVuKfD+EK9
        UE2EJMP0EIce71u4HtkjL/4=
X-Google-Smtp-Source: ABdhPJxO5BUmaKTFICc1LNTGkVxjmfBxmj4LMsA1F93TMnKyH6vkrW94naPxPSDTye2MBNxetH91Zg==
X-Received: by 2002:a92:c248:: with SMTP id k8mr27590450ilo.297.1638760024085;
        Sun, 05 Dec 2021 19:07:04 -0800 (PST)
Received: from localhost ([172.243.151.11])
        by smtp.gmail.com with ESMTPSA id l3sm7138439ilv.37.2021.12.05.19.07.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Dec 2021 19:07:03 -0800 (PST)
Date:   Sun, 05 Dec 2021 19:06:52 -0800
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
Message-ID: <61ad7e4cbc69d_444e20888@john.notmuch>
In-Reply-To: <95151f4b8a25ce38243e82f0a82104d0f46fb33a.1638272238.git.lorenzo@kernel.org>
References: <cover.1638272238.git.lorenzo@kernel.org>
 <95151f4b8a25ce38243e82f0a82104d0f46fb33a.1638272238.git.lorenzo@kernel.org>
Subject: RE: [PATCH v19 bpf-next 03/23] net: mvneta: update mb bit before
 passing the xdp buffer to eBPF layer
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenzo Bianconi wrote:
> Update multi-buffer bit (mb) in xdp_buff to notify XDP/eBPF layer and
> XDP remote drivers if this is a "non-linear" XDP buffer. Access
> skb_shared_info only if xdp_buff mb is set in order to avoid possible
> cache-misses.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

[...]

> @@ -2320,8 +2325,12 @@ mvneta_swbm_build_skb(struct mvneta_port *pp, struct page_pool *pool,
>  		      struct xdp_buff *xdp, u32 desc_status)
>  {
>  	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
> -	int i, num_frags = sinfo->nr_frags;
>  	struct sk_buff *skb;
> +	u8 num_frags;
> +	int i;
> +
> +	if (unlikely(xdp_buff_is_mb(xdp)))
> +		num_frags = sinfo->nr_frags;

Doesn't really need a respin IMO, but rather an observation. Its not
obvious to me the unlikely/likely pair here is wanted. Seems it could
be relatively common for some applications sending jumbo frames.

Maybe worth some experimenting in the future.

>  
>  	skb = build_skb(xdp->data_hard_start, PAGE_SIZE);
>  	if (!skb)
> @@ -2333,6 +2342,9 @@ mvneta_swbm_build_skb(struct mvneta_port *pp, struct page_pool *pool,
>  	skb_put(skb, xdp->data_end - xdp->data);
>  	skb->ip_summed = mvneta_rx_csum(pp, desc_status);
>  
> +	if (likely(!xdp_buff_is_mb(xdp)))
> +		goto out;
> +
>  	for (i = 0; i < num_frags; i++) {
>  		skb_frag_t *frag = &sinfo->frags[i];
