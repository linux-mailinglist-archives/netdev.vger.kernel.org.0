Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21F45AC758
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 17:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436493AbfIGPtq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Sep 2019 11:49:46 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46406 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390962AbfIGPtq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Sep 2019 11:49:46 -0400
Received: from localhost (unknown [88.214.184.0])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D3F77152F1ADF;
        Sat,  7 Sep 2019 08:49:43 -0700 (PDT)
Date:   Sat, 07 Sep 2019 17:49:42 +0200 (CEST)
Message-Id: <20190907.174942.662063905491373058.davem@davemloft.net>
To:     liuhangbin@gmail.com
Cc:     netdev@vger.kernel.org, karn@ka9q.net, sukumarg1973@gmail.com,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        eric.dumazet@gmail.com
Subject: Re: [PATCHv3 net-next] ipmr: remove hard code
 cache_resolve_queue_len limit
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190906073601.10525-1-liuhangbin@gmail.com>
References: <20190903084359.13310-1-liuhangbin@gmail.com>
        <20190906073601.10525-1-liuhangbin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 07 Sep 2019 08:49:45 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>
Date: Fri,  6 Sep 2019 15:36:01 +0800

> This is a re-post of previous patch wrote by David Miller[1].
> 
> Phil Karn reported[2] that on busy networks with lots of unresolved
> multicast routing entries, the creation of new multicast group routes
> can be extremely slow and unreliable.
> 
> The reason is we hard-coded multicast route entries with unresolved source
> addresses(cache_resolve_queue_len) to 10. If some multicast route never
> resolves and the unresolved source addresses increased, there will
> be no ability to create new multicast route cache.
> 
> To resolve this issue, we need either add a sysctl entry to make the
> cache_resolve_queue_len configurable, or just remove cache_resolve_queue_len
> limit directly, as we already have the socket receive queue limits of mrouted
> socket, pointed by David.
> 
> From my side, I'd perfer to remove the cache_resolve_queue_len limit instead
> of creating two more(IPv4 and IPv6 version) sysctl entry.
> 
> [1] https://lkml.org/lkml/2018/7/22/11
> [2] https://lkml.org/lkml/2018/7/21/343
> 
> v3: instead of remove cache_resolve_queue_len totally, let's only remove
> the hard code limit when allocate the unresolved cache, as Eric Dumazet
> suggested, so we don't need to re-count it in other places.
> 
> v2: hold the mfc_unres_lock while walking the unresolved list in
> queue_count(), as Nikolay Aleksandrov remind.
> 
> Reported-by: Phil Karn <karn@ka9q.net>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Applied to net-next.
