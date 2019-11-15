Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A3D5FE500
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 19:38:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726865AbfKOSiX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 13:38:23 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:35236 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726182AbfKOSiX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 13:38:23 -0500
Received: by mail-pl1-f195.google.com with SMTP id s10so5252579plp.2
        for <netdev@vger.kernel.org>; Fri, 15 Nov 2019 10:38:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=yOWvwWR0NyxTb2c1FWIZ5Yhp00Fh1wJP7GZyfA2WkUE=;
        b=WfqFchl9Qfluhp7OrBrunwIBqlIjwYxzL40D2+mIuep92tBeN+l2maezwDRjJGS5qG
         gaOyWnF5PM6wpw6LzDhMqs2ZA7JZOFBJoNVgGODPBIfJoRg5AYhzy6655H5IoN78DJ6n
         4JUEYBlHOxTUC5E9MxBn16b2umCUKQSNLec9SGCnvk1azYBOnOhq/gxpyab+Py85rrgJ
         IYDTxpPGkd52Jl8HRjSfS/fOWs0jwrm6A4hswZMhk1QfW2IWOvY1TTL/Sd+lFIz8r2wz
         7m66miqZbPPaw2E020IVIm5noYjsdjkAQh4w0gMdYlcCVNzNEXxF6mXyPd8pvjeprkx0
         DSOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=yOWvwWR0NyxTb2c1FWIZ5Yhp00Fh1wJP7GZyfA2WkUE=;
        b=Y4BOwE/+dfxTr2scWjMdrI8sKZfLcnSqFkH+6Houcso9JCoxmLLTqQ+eDaFY4t5njl
         k9X6Bn7QsUAj5Q/9GJp1aYCafiSALJw6w7L7u6XQ60scs/DflmtXErm/qoChCiFKt8xH
         JjU2R7iidV+qd4YsdmUrY+i9WAmFfI0uX0/irT88adLCDqoT58Fg6URBI4RkImPOWcSJ
         BVugonzdztrFYxfCGygJRh2d/NEVnpjVAnXWRgncjb6ofPDLN5OA+NxAg7RE5fxWZwdf
         64piATAj+LxqXOoIT98MaPZwSlIKkszvEF+d/6K8E4QCNK1UsVF/N1QsH2D6nCa6BDVn
         zLjA==
X-Gm-Message-State: APjAAAV3YV7zNvV1zgdCTqnaBL+CRb/vGHQ8H6feO76Q0AFp23kXwB3G
        yBPebjVTOou7RuBkF19B+Ps=
X-Google-Smtp-Source: APXvYqxsrkg7dPbEVV6mrJjRPDH1EFa2EaWRh3Zc3k6xdzqLFB1Eq9Ur3kHHNmUjk+seTazWKykkPQ==
X-Received: by 2002:a17:90a:cc07:: with SMTP id b7mr21184595pju.135.1573843102838;
        Fri, 15 Nov 2019 10:38:22 -0800 (PST)
Received: from [172.20.54.79] ([2620:10d:c090:200::2:83d7])
        by smtp.gmail.com with ESMTPSA id n23sm10579756pff.137.2019.11.15.10.38.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Nov 2019 10:38:22 -0800 (PST)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Jesper Dangaard Brouer" <brouer@redhat.com>
Cc:     "Toke =?utf-8?b?SMO4aWxhbmQtSsO4cmdlbnNlbg==?=" <toke@redhat.com>,
        netdev@vger.kernel.org,
        "Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
        "Saeed Mahameed" <saeedm@mellanox.com>,
        "Matteo Croce" <mcroce@redhat.com>,
        "Lorenzo Bianconi" <lorenzo@kernel.org>,
        "Tariq Toukan" <tariqt@mellanox.com>
Subject: Re: [net-next v1 PATCH 3/4] page_pool: block alloc cache during
 shutdown
Date:   Fri, 15 Nov 2019 10:38:21 -0800
X-Mailer: MailMate (1.13r5655)
Message-ID: <8FD50D75-44C3-4C67-984E-0B85ADE6BAA5@gmail.com>
In-Reply-To: <157383036914.3173.12541360542055110975.stgit@firesoul>
References: <157383032789.3173.11648581637167135301.stgit@firesoul>
 <157383036914.3173.12541360542055110975.stgit@firesoul>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 15 Nov 2019, at 7:06, Jesper Dangaard Brouer wrote:

> It is documented that driver API users, have to disconnect
> the page_pool, before starting shutdown phase, but is it only
> documentation, there is not code catching such violations.
>
> Given (in page_pool_empty_alloc_cache_once) alloc cache is only
> flushed once, there is now an opportunity to catch this case.
>
> This patch blocks the RX/alloc-side cache, via pretending it is
> full and poison last element.  This code change will enforce that
> drivers cannot use alloc cache during shutdown phase.
>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>  net/core/page_pool.c |    4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index e28db2ef8e12..b31f3bb7818d 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -364,6 +364,10 @@ static void 
> page_pool_empty_alloc_cache_once(struct page_pool *pool)
>  		page = pool->alloc.cache[--pool->alloc.count];
>  		__page_pool_return_page(pool, page);
>  	}
> +
> +	/* Block alloc cache, pretend it's full and poison last element */
> +	pool->alloc.cache[PP_ALLOC_CACHE_SIZE - 1] = NULL;
> +	pool->alloc.count = PP_ALLOC_CACHE_SIZE;
>  }
>
>  static void page_pool_scrub(struct page_pool *pool)

I'm really unclear on how this is going to be helpful at all.

Suppose that page_pool_destroy() is called, and this is the last user
of the pool, so page_pool_release() is entered, but finds there are
outstanding pages, so the actual free is delayed.

Case 1:
Now, if the driver screws up and tries to re-use the pool and allocate
another packet, it enters __page_pool_get_cached(), which will decrement
the alloc.count, and return NULL.  This causes a fallback to
__get_alloc_pages_slow(), which bumps up the pool inflight count.

A repeat call of the above results in garbage, since the alloc.count
will return stale values.   A call to __page_pool_put_page() may put
the value back in the cache since the alloc.count was decremented.
Now, the retry may sit there forever since the cache is never flushed.

Case 2:
An inflight packet somehow arrives at __page_pool_put_page() and
enters __page_pool_recycle_direct().  With the above patch, the cache
pretends it is full, (assuming nothing was allocated) so it falls back
to the ring.

Without the patch, the packet is placed in the cache, and then flushed
out to the ring later, resulting in the same behavior.  Any mistaken
allocations are handled gracefully.
-- 
Jonathan





