Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C0E5309DA2
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 16:38:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232228AbhAaM5z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jan 2021 07:57:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231953AbhAaMhF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jan 2021 07:37:05 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1A99C061573;
        Sun, 31 Jan 2021 04:24:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=R8+JxZSpbHiMxsv5TLCmqmv2hyGPLbx0zPwRvsESoT8=; b=Va5+mSbba56ABTdMGmAv/C++pK
        /W28Q6TwZmVEZsX8HgZZ/HPOcp3zr1hv4YthleldIqNIt6uZunVSsFBBPx7eVDMAcIxW/UPzjIBK5
        JzdEItl1XJXViz7h1EG+4LZkx3G5PCgKizGxtld/r8iEXwUUG3e0JVvNMhEfSDlbaT/yh74y4FaJ8
        QQQnRSuWCRET8KgpOA/4ZSLVJTDpR5loU560WdMG4vfu8TxXuXVk3Rol1BRuFWcMico3hLQmcDDsg
        oMCrWMWO9JPD3DrPG2o6sr2SJtf2cN0pjPpXTlIBrnkM+qtkIE0xt/2OAwNKiOgwxuI2ErKOc6zc5
        R124FSfg==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l6Blc-00CQnr-Gg; Sun, 31 Jan 2021 12:23:48 +0000
Date:   Sun, 31 Jan 2021 12:23:48 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Hubbard <jhubbard@nvidia.com>,
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
Subject: Re: [PATCH v3 net-next 5/5] net: page_pool: simplify page recycling
 condition tests
Message-ID: <20210131122348.GM308988@casper.infradead.org>
References: <20210131120844.7529-1-alobakin@pm.me>
 <20210131120844.7529-6-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210131120844.7529-6-alobakin@pm.me>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 31, 2021 at 12:12:11PM +0000, Alexander Lobakin wrote:
> pool_page_reusable() is a leftover from pre-NUMA-aware times. For now,
> this function is just a redundant wrapper over page_is_pfmemalloc(),
> so inline it into its sole call site.

Why doesn't this want to use {dev_}page_is_reusable()?

