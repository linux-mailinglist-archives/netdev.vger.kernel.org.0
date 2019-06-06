Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7F5C3688A
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 02:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbfFFABA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 20:01:00 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42720 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726537AbfFFABA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 20:01:00 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DF80B136E16AB;
        Wed,  5 Jun 2019 17:00:59 -0700 (PDT)
Date:   Wed, 05 Jun 2019 17:00:59 -0700 (PDT)
Message-Id: <20190605.170059.665995320664978361.davem@davemloft.net>
To:     lucien.xin@gmail.com
Cc:     netdev@vger.kernel.org, dsahern@gmail.com
Subject: Re: [PATCH net] ipv4: not do cache for local delivery if
 bc_forwarding is enabled
From:   David Miller <davem@davemloft.net>
In-Reply-To: <9b4ce2be76ea7a635fe431ec42a784db0196a5a0.1559473824.git.lucien.xin@gmail.com>
References: <9b4ce2be76ea7a635fe431ec42a784db0196a5a0.1559473824.git.lucien.xin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 05 Jun 2019 17:01:00 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>
Date: Sun,  2 Jun 2019 19:10:24 +0800

> With the topo:
> 
>     h1 ---| rp1            |
>           |     route  rp3 |--- h3 (192.168.200.1)
>     h2 ---| rp2            |
> 
> If rp1 bc_forwarding is set while rp2 bc_forwarding is not, after
> doing "ping 192.168.200.255" on h1, then ping 192.168.200.255 on
> h2, and the packets can still be forwared.
> 
> This issue was caused by the input route cache. It should only do
> the cache for either bc forwarding or local delivery. Otherwise,
> local delivery can use the route cache for bc forwarding of other
> interfaces.
> 
> This patch is to fix it by not doing cache for local delivery if
> all.bc_forwarding is enabled.
> 
> Note that we don't fix it by checking route cache local flag after
> rt_cache_valid() in "local_input:" and "ip_mkroute_input", as the
> common route code shouldn't be touched for bc_forwarding.
> 
> Fixes: 5cbf777cfdf6 ("route: add support for directed broadcast forwarding")
> Reported-by: Jianlin Shi <jishi@redhat.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied and queued up for -stable.
