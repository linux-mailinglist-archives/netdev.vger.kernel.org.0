Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E62959C92
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 15:07:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726672AbfF1NHP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 09:07:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54336 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726590AbfF1NHP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jun 2019 09:07:15 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C4DF530BB37D;
        Fri, 28 Jun 2019 13:07:09 +0000 (UTC)
Received: from carbon (ovpn-200-45.brq.redhat.com [10.40.200.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 952E86012D;
        Fri, 28 Jun 2019 13:07:02 +0000 (UTC)
Date:   Fri, 28 Jun 2019 15:07:01 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     netdev@vger.kernel.org, jaswinder.singh@linaro.org,
        ard.biesheuvel@linaro.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, daniel@iogearbox.net, ast@kernel.org,
        makita.toshiaki@lab.ntt.co.jp, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com, davem@davemloft.net,
        maciejromanfijalkowski@gmail.com, brouer@redhat.com
Subject: Re: [PATCH 2/3, net-next] net: page_pool: add helper function for
 retrieving dma direction
Message-ID: <20190628150701.383b17f6@carbon>
In-Reply-To: <1561718355-13919-3-git-send-email-ilias.apalodimas@linaro.org>
References: <1561718355-13919-1-git-send-email-ilias.apalodimas@linaro.org>
        <1561718355-13919-3-git-send-email-ilias.apalodimas@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Fri, 28 Jun 2019 13:07:14 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Jun 2019 13:39:14 +0300
Ilias Apalodimas <ilias.apalodimas@linaro.org> wrote:

> Since the dma direction is stored in page pool params, offer an API
> helper for driver that choose not to keep track of it locally
> 
> Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> ---
>  include/net/page_pool.h | 9 +++++++++
>  1 file changed, 9 insertions(+)

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

This is simple enough and you also explained the downside.
Thanks for adding a helper for this.

 
> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> index f07c518ef8a5..ee9c871d2043 100644
> --- a/include/net/page_pool.h
> +++ b/include/net/page_pool.h
> @@ -112,6 +112,15 @@ static inline struct page *page_pool_dev_alloc_pages(struct page_pool *pool)
>  	return page_pool_alloc_pages(pool, gfp);
>  }
>  
> +/* get the stored dma direction. A driver might decide to treat this locally and
> + * avoid the extra cache line from page_pool to determine the direction
> + */
> +static
> +inline enum dma_data_direction page_pool_get_dma_dir(struct page_pool *pool)
> +{
> +	return pool->p.dma_dir;
> +}
> +
>  struct page_pool *page_pool_create(const struct page_pool_params *params);
>  
>  void __page_pool_free(struct page_pool *pool);


-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
