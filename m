Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C48123332F3
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 03:05:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232031AbhCJCEw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 21:04:52 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:48652 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231235AbhCJCEp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Mar 2021 21:04:45 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lJoD9-00A6SO-NR; Wed, 10 Mar 2021 03:04:31 +0100
Date:   Wed, 10 Mar 2021 03:04:31 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Shay Agroskin <shayagr@amazon.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        "Woodhouse, David" <dwmw@amazon.com>,
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
Subject: Re: [RFC Patch v1 1/3] net: ena: implement local page cache (LPC)
 system
Message-ID: <YEgpL4xYSa7/r38v@lunn.ch>
References: <20210309171014.2200020-1-shayagr@amazon.com>
 <20210309171014.2200020-2-shayagr@amazon.com>
 <67d3cf28-b1fd-ce51-5011-96ddd783dc71@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <67d3cf28-b1fd-ce51-5011-96ddd783dc71@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 09, 2021 at 06:57:06PM +0100, Eric Dumazet wrote:
> 
> 
> On 3/9/21 6:10 PM, Shay Agroskin wrote:
> > The page cache holds pages we allocated in the past during napi cycle,
> > and tracks their availability status using page ref count.
> > 
> > The cache can hold up to 2048 pages. Upon allocating a page, we check
> > whether the next entry in the cache contains an unused page, and if so
> > fetch it. If the next page is already used by another entity or if it
> > belongs to a different NUMA core than the napi routine, we allocate a
> > page in the regular way (page from a different NUMA core is replaced by
> > the newly allocated page).
> > 
> > This system can help us reduce the contention between different cores
> > when allocating page since every cache is unique to a queue.
> 
> For reference, many drivers already use a similar strategy.

Hi Eric

So rather than yet another implementation, should we push for a
generic implementation which any driver can use?

	Andrew
