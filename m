Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC2130937A
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 10:36:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231754AbhA3JgC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 04:36:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:34392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233510AbhA3DUm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Jan 2021 22:20:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E6A9464E0E;
        Sat, 30 Jan 2021 02:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611974348;
        bh=Xa3aXdkH6VcjkQv2mRzeHTVU3FePrWxYumhPtvDn8zo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CuA7saw/NDT+jltBVLbBOTtilmjJ0UnnOPSNhIp0vShR5tTLtelQ/Ci1Y9jrcJzjk
         3FDxe+ykvXfRDbwSZtUYnXtiMKt7H4HVivJJqrTYJLfVxJhJmmk9QLMSNTtOVqUTDb
         dZyybRVqcd4QDuNd46UIFCQs37Gnk5Wg+w4OCZp/BECSGKKr2Rsk1VOvwYaiqlQywb
         VzKklQrRbxLRmDiDCPqKf/0JADwvBNgIVZ5Q1Jh2qc26DZyViIudB0FLkI9srNwS0N
         JVXIyfhG944QWXOaymGasP3yjFfN1BYSqkbDq7WrhqUa8KGo01/23gOQAkgrkSry62
         RWTV4TxpCVpcg==
Date:   Fri, 29 Jan 2021 18:39:07 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     "David S. Miller" <davem@davemloft.net>,
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
Subject: Re: [PATCH v2 net-next 3/4] net: introduce common
 dev_page_is_reserved()
Message-ID: <20210129183907.2ae5ca3d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210127201031.98544-4-alobakin@pm.me>
References: <20210127201031.98544-1-alobakin@pm.me>
        <20210127201031.98544-4-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 Jan 2021 20:11:23 +0000 Alexander Lobakin wrote:
> + * dev_page_is_reserved - check whether a page can be reused for network Rx
> + * @page: the page to test
> + *
> + * A page shouldn't be considered for reusing/recycling if it was allocated
> + * under memory pressure or at a distant memory node.
> + *
> + * Returns true if this page should be returned to page allocator, false
> + * otherwise.
> + */
> +static inline bool dev_page_is_reserved(const struct page *page)

Am I the only one who feels like "reusable" is a better term than
"reserved".
