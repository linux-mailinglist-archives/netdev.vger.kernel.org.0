Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 699323091DE
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 05:34:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233760AbhA3E3K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 23:29:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:37000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233605AbhA3EF7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Jan 2021 23:05:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9DE0464E1A;
        Sat, 30 Jan 2021 02:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611973892;
        bh=cGf3iJ+ecwtb9Ubl0TlE4VdI62kqOG/SRgvcxfXZejg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Wyotr9H9B00UJUKheIXtljvx8UCaT02HI/9TZ//h3FJLuKKoSlXIoUT4dm6LRRuVv
         AUVjtQBdvXqMf4nJUiAd8k1d8TkppgzKPcKYBIq527jRWD3XHIy0fiJkEkxNZthJvx
         3YD6JzlBY2rtZOnwnxCqjZYRG3Tp9Iz5+9HEbe3615xDxhTdjSuGf9yxlvpeK5zzmO
         D4fPKYi/j0h0Urv7ObZS28fLIdKiQL90fnnAcGF9W2dFqKpeV5tNQ+h8miISEY0PSP
         NEFeNtttgTEBEGpKv4rAQDR1NI7PhXdj4rbOefks8jgfQ61g1GQ/k+Y4dxmeqiybEk
         Yu2M65T9m2x7w==
Date:   Fri, 29 Jan 2021 18:30:51 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        "David S. Miller" <davem@davemloft.net>,
        David Rientjes <rientjes@google.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Dexuan Cui <decui@microsoft.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Marco Elver <elver@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        linux-rdma@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 net-next 1/4] mm: constify page_is_pfmemalloc()
 argument
Message-ID: <20210129183051.62874a6d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210127201031.98544-2-alobakin@pm.me>
References: <20210127201031.98544-1-alobakin@pm.me>
        <20210127201031.98544-2-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 Jan 2021 20:11:01 +0000 Alexander Lobakin wrote:
> The function only tests for page->index, so its argument should be
> const.
> 
> Signed-off-by: Alexander Lobakin <alobakin@pm.me>
> ---
>  include/linux/mm.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index ecdf8a8cd6ae..078633d43af9 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1584,7 +1584,7 @@ struct address_space *page_mapping_file(struct page *page);
>   * ALLOC_NO_WATERMARKS and the low watermark was not
>   * met implying that the system is under some pressure.
>   */
> -static inline bool page_is_pfmemalloc(struct page *page)
> +static inline bool page_is_pfmemalloc(const struct page *page)
>  {
>  	/*
>  	 * Page index cannot be this large so this must be

No objections for this going via net-next?
