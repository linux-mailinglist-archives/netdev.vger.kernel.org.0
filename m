Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A12E46F4B
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 11:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726400AbfFOJdq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 05:33:46 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:42443 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725927AbfFOJdq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 05:33:46 -0400
Received: by mail-lj1-f195.google.com with SMTP id t28so4713866lje.9
        for <netdev@vger.kernel.org>; Sat, 15 Jun 2019 02:33:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=bVsBULHurWYzQsO/P5RxovuoW2Gqr7jYgucOFC/PIkY=;
        b=sffvC/m+cAbmohXOgxdSzXFlsBvqG8UyBhSlOe1GtpLkEisi8XtKClUAcQJaUF6wE8
         x7o2+ihoj98oVmFPuqQ7Bc6pziL8ULikr1VfWPVWwcXxS4XKI+RZL7x1lKJB++PT6u2R
         pqpHcpeXI9fDk7pPjfJgJzqVOMVAAo10TofFg8bf2a8MoWMcq0YSzFmFl8HefVhnBcjD
         fKXP/6FegHOEuazbKqhDo6IxobFrGU2WMEnV12ou0elDcWtyf8n+Hcf3usd/N6KuhGGN
         dK88Hl0OfgeTEk/b5w7WY68y6YOm6d93/ML6WB82DsF4J6ErPjv6SUdhAEDjbtbfYR9C
         VAdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=bVsBULHurWYzQsO/P5RxovuoW2Gqr7jYgucOFC/PIkY=;
        b=E2GRwz9OliptPXPRuT0ps41vzvNV2KLpKlTeOHzrVQHY1MA94FEH7YDlg+kfsK1yV8
         qg3i+yW+PaAottrZ/HW9wy+zDn9i3DqKh1nzT+D+kX6B1zlPEJPB/WzRzPozlv5csPDu
         yqqRzMVVn5d9s1Ldoh5a2ij2pJ3pr2XSVZFFAGTHAI/hwj6X5YMkzhTvGu2GHZL0clmc
         o+doDxLtVHbaNzQywvt6+pMfTbJawwUbe+OZnPb8z4GNR1mjNE5f2URQUptxJMVbJW5v
         5ApfJ6FFtBnH/ttb4yYw/QPurDITqlP6ERGbJQ709v13BmDeOo2XLrH+IokfPP8Le/UQ
         c0bg==
X-Gm-Message-State: APjAAAU11DVrd+TtFJ4rFOa5UIEvp2r98klFp6armd6jI8ar86nS2kIq
        JcnoWz3YEGHRwUPKNK8xpziEFw==
X-Google-Smtp-Source: APXvYqyKGHAjQstamQIoB82zMIpo38P68wUyeBsaBGJHeLfuYaq4pEImjKF5ZIOK6bn2SiNnlTb3VA==
X-Received: by 2002:a2e:9e07:: with SMTP id e7mr34776264ljk.55.1560591223387;
        Sat, 15 Jun 2019 02:33:43 -0700 (PDT)
Received: from khorivan (59-201-94-178.pool.ukrtel.net. [178.94.201.59])
        by smtp.gmail.com with ESMTPSA id b25sm809594lff.42.2019.06.15.02.33.42
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 15 Jun 2019 02:33:42 -0700 (PDT)
Date:   Sat, 15 Jun 2019 12:33:40 +0300
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        Tariq Toukan <tariqt@mellanox.com>, toshiaki.makita1@gmail.com,
        grygorii.strashko@ti.com, mcroce@redhat.com
Subject: Re: [PATCH net-next v1 08/11] xdp: tracking page_pool resources and
 safe removal
Message-ID: <20190615093339.GB3771@khorivan>
References: <156045046024.29115.11802895015973488428.stgit@firesoul>
 <156045052249.29115.2357668905441684019.stgit@firesoul>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <156045052249.29115.2357668905441684019.stgit@firesoul>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 13, 2019 at 08:28:42PM +0200, Jesper Dangaard Brouer wrote:
Hi, Jesper

>This patch is needed before we can allow drivers to use page_pool for
>DMA-mappings. Today with page_pool and XDP return API, it is possible to
>remove the page_pool object (from rhashtable), while there are still
>in-flight packet-pages. This is safely handled via RCU and failed lookups in
>__xdp_return() fallback to call put_page(), when page_pool object is gone.
>In-case page is still DMA mapped, this will result in page note getting
>correctly DMA unmapped.
>
>To solve this, the page_pool is extended with tracking in-flight pages. And
>XDP disconnect system queries page_pool and waits, via workqueue, for all
>in-flight pages to be returned.
>
>To avoid killing performance when tracking in-flight pages, the implement
>use two (unsigned) counters, that in placed on different cache-lines, and
>can be used to deduct in-flight packets. This is done by mapping the
>unsigned "sequence" counters onto signed Two's complement arithmetic
>operations. This is e.g. used by kernel's time_after macros, described in
>kernel commit 1ba3aab3033b and 5a581b367b5, and also explained in RFC1982.
>
>The trick is these two incrementing counters only need to be read and
>compared, when checking if it's safe to free the page_pool structure. Which
>will only happen when driver have disconnected RX/alloc side. Thus, on a
>non-fast-path.
>
>It is chosen that page_pool tracking is also enabled for the non-DMA
>use-case, as this can be used for statistics later.
>
>After this patch, using page_pool requires more strict resource "release",
>e.g. via page_pool_release_page() that was introduced in this patchset, and
>previous patches implement/fix this more strict requirement.
>
>Drivers no-longer call page_pool_destroy(). Drivers already call
>xdp_rxq_info_unreg() which call xdp_rxq_info_unreg_mem_model(), which will
>attempt to disconnect the mem id, and if attempt fails schedule the
>disconnect for later via delayed workqueue.
>
>Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
>---
> drivers/net/ethernet/mellanox/mlx5/core/en_main.c |    3 -
> include/net/page_pool.h                           |   41 ++++++++++---
> net/core/page_pool.c                              |   62 +++++++++++++++-----
> net/core/xdp.c                                    |   65 +++++++++++++++++++--
> 4 files changed, 136 insertions(+), 35 deletions(-)
>
>diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
>index 2f647be292b6..6c9d4d7defbc 100644
>--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
>+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c

[...]

>--- a/net/core/xdp.c
>+++ b/net/core/xdp.c
>@@ -38,6 +38,7 @@ struct xdp_mem_allocator {
> 	};
> 	struct rhash_head node;
> 	struct rcu_head rcu;
>+	struct delayed_work defer_wq;
> };
>
> static u32 xdp_mem_id_hashfn(const void *data, u32 len, u32 seed)
>@@ -79,13 +80,13 @@ static void __xdp_mem_allocator_rcu_free(struct rcu_head *rcu)
>
> 	xa = container_of(rcu, struct xdp_mem_allocator, rcu);
>
>+	/* Allocator have indicated safe to remove before this is called */
>+	if (xa->mem.type == MEM_TYPE_PAGE_POOL)
>+		page_pool_free(xa->page_pool);
>+

What would you recommend to do for the following situation:

Same receive queue is shared between 2 network devices. The receive ring is
filled by pages from page_pool, but you don't know the actual port (ndev)
filling this ring, because a device is recognized only after packet is received.

The API is so that xdp rxq is bind to network device, each frame has reference
on it, so rxq ndev must be static. That means each netdev has it's own rxq
instance even no need in it. Thus, after your changes, page must be returned to
the pool it was taken from, or released from old pool and recycled in new one
somehow.

And that is inconvenience at least. It's hard to move pages between pools w/o
performance penalty. No way to use common pool either, as unreg_rxq now drops
the pool and 2 rxqa can't reference same pool.

-- 
Regards,
Ivan Khoronzhuk
