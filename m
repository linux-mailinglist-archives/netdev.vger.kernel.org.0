Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 859EB149F62
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 09:01:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726092AbgA0IBs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 03:01:48 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42832 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726029AbgA0IBs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 03:01:48 -0500
Received: by mail-wr1-f65.google.com with SMTP id q6so9886339wro.9
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 00:01:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mO+uOLzTAzvhqksrROazPvqrmBagPtcoLiSBXqQoSdo=;
        b=e1xt2wZMF8XhH37d1XReanjt55OUPYsJwjitcAVc4wtCgZUYYiO1XQkTF4SAcXavw3
         SytCkqOzRR1/VZ6choelobupE4mJvAYabJlRqYs6jqaEqwIRAeqU5Uf5XQ5Ry4WEt2Z5
         Oakr7QBKI4f8xI1XjbLOWENUzqiQU5L0qQ4c0guwHLQ7B4kV5FckbPfGxyhhIObhWIui
         b9zea+x0uXoIL9leXf4B1GbUEycOjLJS5NQNKdevUSNP4SSSAtq8A/H19a5NaS9V/wb2
         yRH9hI4vX6cF18vtOIb9HzmEvlzPcLei4tcszAz90w8FhMLRYyqS6s6wQHiotIYVaXR6
         bFnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mO+uOLzTAzvhqksrROazPvqrmBagPtcoLiSBXqQoSdo=;
        b=eAXA5tY7FnerrkaUTWJlz1Jyrt0+RnxjvHSZS26BgqbmU/GZHh1zuB2yU4sa9XHBuw
         6k0yJLlM+9wS5AgbefhbYHuGYRhEY4FMTvvoOL4XgBFMFCE3IuJ35PucM1SG+bQlKFKu
         uPedNpvwYaST40liGyC7WWAHWUx1fNM2qQvRDMyBVKnxJvhUbBB812Pnq6DNcd/BZbJ0
         RYq2A04jSFvw9G0CillEshA4l43ossBakk+Q4oR8gqrkXq+fgZZnu54nBkcxIqcvpLAh
         wfO3XitjKI+DTROWGNTMUXQN6ypvdvsxgxRJbLzLWC5zMltohdYbW3bugQ5l/oABe28U
         EAHw==
X-Gm-Message-State: APjAAAUgz5zMsRqWdFJtRmaiRNP1BNt1MIXGo93GKrCdR+BieXohBOSo
        +hW+bu8IOHxhEv5ciZUrXdSNvg==
X-Google-Smtp-Source: APXvYqzLEYEChRlnCst3d5+K6PfS6MNsDn1XyKmwBAXcZfnosHYnaGizmaekZDy3NpODWkiqvzZG+A==
X-Received: by 2002:adf:dd8a:: with SMTP id x10mr20910992wrl.117.1580112106166;
        Mon, 27 Jan 2020 00:01:46 -0800 (PST)
Received: from apalos.home (ppp-94-66-201-28.home.otenet.gr. [94.66.201.28])
        by smtp.gmail.com with ESMTPSA id q10sm8558497wme.16.2020.01.27.00.01.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2020 00:01:44 -0800 (PST)
Date:   Mon, 27 Jan 2020 10:01:39 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        lorenzo.bianconi@redhat.com, brouer@redhat.com
Subject: Re: [PATCH net 2/2] net: socionext: fix xdp_result initialization in
 netsec_process_rx
Message-ID: <20200127080139.GB24434@apalos.home>
References: <cover.1579952387.git.lorenzo@kernel.org>
 <6c5c8394590826f4d69172cf31e95d44eae92245.1579952387.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6c5c8394590826f4d69172cf31e95d44eae92245.1579952387.git.lorenzo@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 25, 2020 at 12:48:51PM +0100, Lorenzo Bianconi wrote:
> Fix xdp_result initialization in netsec_process_rx in order to not
> increase rx counters if there is no bpf program attached to the xdp hook
> and napi_gro_receive returns GRO_DROP
> 
> Fixes: ba2b232108d3c ("net: netsec: add XDP support")
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/ethernet/socionext/netsec.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
> index 0e12a9856aea..56c0e643f430 100644
> --- a/drivers/net/ethernet/socionext/netsec.c
> +++ b/drivers/net/ethernet/socionext/netsec.c
> @@ -942,8 +942,8 @@ static int netsec_process_rx(struct netsec_priv *priv, int budget)
>  		struct netsec_de *de = dring->vaddr + (DESC_SZ * idx);
>  		struct netsec_desc *desc = &dring->desc[idx];
>  		struct page *page = virt_to_page(desc->addr);
> +		u32 xdp_result = NETSEC_XDP_PASS;
>  		struct sk_buff *skb = NULL;
> -		u32 xdp_result = XDP_PASS;
>  		u16 pkt_len, desc_len;
>  		dma_addr_t dma_handle;
>  		struct xdp_buff xdp;
> -- 
> 2.21.1
> 

Acked-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
