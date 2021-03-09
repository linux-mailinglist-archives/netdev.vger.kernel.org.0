Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 433D7332DAC
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 18:58:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230425AbhCIR5b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 12:57:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231840AbhCIR5M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 12:57:12 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55F3EC06174A
        for <netdev@vger.kernel.org>; Tue,  9 Mar 2021 09:57:12 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id f12so17429031wrx.8
        for <netdev@vger.kernel.org>; Tue, 09 Mar 2021 09:57:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OZ1afXUkFipehQmyzlYhzPLXHPkEEXtXkPM0N1xgILo=;
        b=ZTFsEiR7X+shbgZLU+Bv2vOj2OiWfZcOcpROM+Stx+FYrO6a5bSLNA+rqRTE8CaVZU
         eIheGiksmJcQe3iEqqvg6CQMUuKRvSnzxz99lxqtAwe655FtFXEr+Zt8JWuZRklGNRc/
         zKctEUhckCai/L0EyrzsE2SfaXbCHNVlMAYpNuXEDgb2U5yfeWrC2P9ObGhII6SfFB/Y
         sA7YwuVQRk9I2FxSxuodxJ/VViTAAGMES6A5VUkGxPdbhowUjS+VzLZy/Km8ytpa0cJy
         NujLsKI6+mV7QiVfVaq/8iEFOlo6lTp3Xro7EqrwTciIiL3ty0B+hrXZQGavQgbz88yS
         Ed2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OZ1afXUkFipehQmyzlYhzPLXHPkEEXtXkPM0N1xgILo=;
        b=ZY1DuWASX9NrsoinZo4bhMJsHJyt+kUYTVx2sTU2rOxV+eQlBYseIf8MHVQSlvG4oV
         Sx6JGnRz2iaHpy1Kk6935bq9Dbw9qMIMt/9yma+8qJShjT1mQLzWYz4TWKnJrEVXJ87k
         dxAoDAaqgqv5x7IxpL6SGfIod0a0wdXKwRtm1EVTiwQKc2EzE8dQCrrfO1nS5j9blZA0
         lrfVorc8CLGVg4Ur04/8Ma/8pEWe0s2jGArpt06yZ34k2IV7noPhRMjM2LvimOZM1MmE
         gZAbTDCPG+Yf08iDsPqdFses9sobGVsmIXAIpUZH8GhQMqI3qkRIS2QzZNw2th7s6OR8
         kMVw==
X-Gm-Message-State: AOAM532QCvx2SMB7lqFLFs6XigMPLQGl2ARtn5jgGg/59wklWSl+ze7p
        9FppXU3EzeTBxNO0IY/QEis=
X-Google-Smtp-Source: ABdhPJzWclTT/BboCxNHG6Q8VpDBfPST617ec35bEo/OYlQI5GJyMk/pJ4g16DU0QpUK7tdAK83gUw==
X-Received: by 2002:a05:6000:10c3:: with SMTP id b3mr29109376wrx.96.1615312631113;
        Tue, 09 Mar 2021 09:57:11 -0800 (PST)
Received: from [192.168.1.101] ([37.165.49.26])
        by smtp.gmail.com with ESMTPSA id r26sm5201201wmn.28.2021.03.09.09.57.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Mar 2021 09:57:09 -0800 (PST)
Subject: Re: [RFC Patch v1 1/3] net: ena: implement local page cache (LPC)
 system
To:     Shay Agroskin <shayagr@amazon.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     "Woodhouse, David" <dwmw@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        Saeed Bshara <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Tzalik, Guy" <gtzalik@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Jubran, Samih" <sameehj@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>
References: <20210309171014.2200020-1-shayagr@amazon.com>
 <20210309171014.2200020-2-shayagr@amazon.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <67d3cf28-b1fd-ce51-5011-96ddd783dc71@gmail.com>
Date:   Tue, 9 Mar 2021 18:57:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210309171014.2200020-2-shayagr@amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/9/21 6:10 PM, Shay Agroskin wrote:
> The page cache holds pages we allocated in the past during napi cycle,
> and tracks their availability status using page ref count.
> 
> The cache can hold up to 2048 pages. Upon allocating a page, we check
> whether the next entry in the cache contains an unused page, and if so
> fetch it. If the next page is already used by another entity or if it
> belongs to a different NUMA core than the napi routine, we allocate a
> page in the regular way (page from a different NUMA core is replaced by
> the newly allocated page).
> 
> This system can help us reduce the contention between different cores
> when allocating page since every cache is unique to a queue.

For reference, many drivers already use a similar strategy.

> +
> +/* Fetch the cached page (mark the page as used and pass it to the caller).
> + * If the page belongs to a different NUMA than the current one, free the cache
> + * page and allocate another one instead.
> + */
> +static struct page *ena_fetch_cache_page(struct ena_ring *rx_ring,
> +					 struct ena_page *ena_page,
> +					 dma_addr_t *dma,
> +					 int current_nid)
> +{
> +	/* Remove pages belonging to different node than current_nid from cache */
> +	if (unlikely(page_to_nid(ena_page->page) != current_nid)) {
> +		ena_increase_stat(&rx_ring->rx_stats.lpc_wrong_numa, 1, &rx_ring->syncp);
> +		ena_replace_cache_page(rx_ring, ena_page);
> +	}
> +
> 

And they use dev_page_is_reusable() instead of copy/pasting this logic.

As a bonus, they properly deal with pfmemalloc




