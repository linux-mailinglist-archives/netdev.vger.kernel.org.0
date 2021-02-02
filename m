Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B84730B493
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 02:19:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230230AbhBBBTU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 20:19:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:50464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230194AbhBBBTS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Feb 2021 20:19:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D0A8864DD4;
        Tue,  2 Feb 2021 01:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612228717;
        bh=nubjV5RxPS9rBe0ST4Of24Ui70x9oAYNdmJ0tl2QhWI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VX5NiTQ9Jubs8sCIFZX5+4/UbBPOEWx5B+HxdzXkfH83BLJ+GDDV7Iksibf8AcKsp
         YfA7nFsLTTuZuK3Si2se9ublIX2GIHuhQaFxBHQXPQQ7QfAm80uvuUJgoAmb5S6UIT
         qfQx/CMJCrx2NKU8XM9OUfaY2v3TgsWmnM1DqRTXnyqXM7RcWfxTrWeTyaHcCakoSk
         bPqIsrVJ17Ex7s0pE+YPcbg7u0V9Xl6yRxHIcjI+OBMKo/BiXzFvUAuiyCt+NIrp66
         TSTBCwg6hwB5pvt97bywOh1JhP2Qz8xfI2P8BR1756EcewjICgpbewLVGatX5iYTgQ
         LM90b6lTC+rcw==
Date:   Mon, 1 Feb 2021 17:18:35 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     "David S. Miller" <davem@davemloft.net>,
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
Subject: Re: [PATCH v3 net-next 0/5] net: consolidate page_is_pfmemalloc()
 usage
Message-ID: <20210201171835.690558df@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210131120844.7529-1-alobakin@pm.me>
References: <20210131120844.7529-1-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 31 Jan 2021 12:11:16 +0000 Alexander Lobakin wrote:
> page_is_pfmemalloc() is used mostly by networking drivers to test
> if a page can be considered for reusing/recycling.
> It doesn't write anything to the struct page itself, so its sole
> argument can be constified, as well as the first argument of
> skb_propagate_pfmemalloc().
> In Page Pool core code, it can be simply inlined instead.
> Most of the callers from NIC drivers were just doppelgangers of
> the same condition tests. Derive them into a new common function
> do deduplicate the code.

Please resend, this did not get into patchwork :/
