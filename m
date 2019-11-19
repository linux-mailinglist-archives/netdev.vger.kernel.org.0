Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 476E3103077
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 00:58:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727518AbfKSX6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 18:58:02 -0500
Received: from mail-lj1-f169.google.com ([209.85.208.169]:43875 "EHLO
        mail-lj1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727140AbfKSX6B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 18:58:01 -0500
Received: by mail-lj1-f169.google.com with SMTP id y23so25382069ljh.10
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 15:58:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=J36FJ7YQ1uESgxSZKv52HL/pbmln3+90eNYNeoovl/E=;
        b=UqrW9fKk+nqgaCf5nAiGa2nCxO+KlX37J2KmCc5NOVA9P7xK/L3B2RailH9l1DGjc7
         ROrW1HeuZYw0eAEWzFlsqwNNtDhLzNe6wEI8z9tzlm/sP/SRGq1dEpU3+VZ1qAAYHNOi
         GoRUGZRVceDsWo2jpjIh3Bi8cojrrp564bjF1D84EnbC+b4bwkyANPZW3P23g6tLXfM0
         PC7jEo8cuU6DwUJaXaTBi2fD0wTkBvRDnJkk4UDUHGL3GjtdzzQoHd2jdfRAPtmZ/XZ2
         jFXQLLywUlGEbaKiPMiNH1XYMebN2PdBAWSOs+hFUILZxpGKvvlZnkIjqotoCjHxTXYp
         8k6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=J36FJ7YQ1uESgxSZKv52HL/pbmln3+90eNYNeoovl/E=;
        b=d/a4azQjWiwuTVyc8W4i+F1ro+PU1IUC3LWOVf34b8LGOUo01COKa8rfJyzTKzb4oa
         EpEvhB8RpBxSqhGnsbwTxbgKXQuRc9i+Ciyrj4Q8XdFLLkJzjs4wEMQ0VSENG47YWSBt
         9uhW6SRXTqwxFK++QlPQj0Ke3tRISY5C1hdFWcPf2yjFxvXHXC6knxaR5NuzhYwU2NvX
         J/W/tQOMlgAe+mDZp7MUSxu5v2OdtoYpRwqPOMTPt+wqgHgarL5jNm8LNyPwXUB588D2
         3PvKyy75UaApBni2gBQPoGydses3aSspVsuhvnuBYK4h3gESUgVGZJGi6sb/712zl/sr
         ae5Q==
X-Gm-Message-State: APjAAAX03XeoJSXf1d/RO5PvnuVh5Q3gB9zWE4Ac/+LmaehALs1NmYDs
        oGqFqPCqt2k19RSqdvXfyep3hg==
X-Google-Smtp-Source: APXvYqw6/huSdfKLXBwY1DFWkZarClq2M56NGB5rZ+8gW4qViuYgKp1croNuII9JORpkEFWazWISKA==
X-Received: by 2002:a2e:2903:: with SMTP id u3mr108224lje.131.1574207879627;
        Tue, 19 Nov 2019 15:57:59 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id 28sm11421950lfy.38.2019.11.19.15.57.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2019 15:57:59 -0800 (PST)
Date:   Tue, 19 Nov 2019 15:57:44 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     <sameehj@amazon.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>
Subject: Re: [PATCH V2 net-next v2 1/3] net: ena: implement XDP drop support
Message-ID: <20191119155744.6c5338b0@cakuba.netronome.com>
In-Reply-To: <20191119133419.9734-2-sameehj@amazon.com>
References: <20191119133419.9734-1-sameehj@amazon.com>
        <20191119133419.9734-2-sameehj@amazon.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 Nov 2019 15:34:17 +0200, sameehj@amazon.com wrote:
> @@ -1082,11 +1180,16 @@ static int ena_clean_rx_irq(struct ena_ring *rx_ring, struct napi_struct *napi,
>  			  rx_ring->qid, ena_rx_ctx.descs, ena_rx_ctx.l3_proto,
>  			  ena_rx_ctx.l4_proto, ena_rx_ctx.hash);
>  
> +		if (ena_xdp_present_ring(rx_ring))
> +			xdp_verdict = ena_xdp_handle_buff(rx_ring, &xdp);
> +
>  		/* allocate skb and fill it */
> -		skb = ena_rx_skb(rx_ring, rx_ring->ena_bufs, ena_rx_ctx.descs,
> -				 &next_to_clean);
> +		if (xdp_verdict == XDP_PASS)
> +			skb = ena_rx_skb(rx_ring,
> +					 rx_ring->ena_bufs,
> +					 ena_rx_ctx.descs,
> +					 &next_to_clean);

XDP may move the start of frame (consume or add headers), the start of
frame used when constructing the skb must reflect the changes made by
XDP.

>  
> -		/* exit if we failed to retrieve a buffer */
>  		if (unlikely(!skb)) {
>  			for (i = 0; i < ena_rx_ctx.descs; i++) {
>  				rx_ring->free_ids[next_to_clean] =

