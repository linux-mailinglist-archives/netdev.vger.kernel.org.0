Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0609F29FDD
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 22:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404108AbfEXU2k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 16:28:40 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42772 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403852AbfEXU2k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 16:28:40 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D42C814E2A500;
        Fri, 24 May 2019 13:28:39 -0700 (PDT)
Date:   Fri, 24 May 2019 13:28:39 -0700 (PDT)
Message-Id: <20190524.132839.1622018394749383575.davem@davemloft.net>
To:     dsahern@kernel.org
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        idosch@mellanox.com, dsahern@gmail.com
Subject: Re: [PATCH net-next 0/7] ipv6: Move exceptions to fib6_nh and make
 it optional in a fib6_info
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190523032801.11122-1-dsahern@kernel.org>
References: <20190523032801.11122-1-dsahern@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 24 May 2019 13:28:40 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@kernel.org>
Date: Wed, 22 May 2019 20:27:54 -0700

> From: David Ahern <dsahern@gmail.com>
> 
> Patches 1 and 4 move pcpu and exception caches from fib6_info to fib6_nh.
> With respect to the current FIB entries this is only a movement from one
> struct to another contained within the first.
> 
> Patch 2 refactors the core logic of fib6_drop_pcpu_from into a helper
> that is invoked per fib6_nh.
> 
> Patch 3 refactors exception handling in a similar way - creating a bunch
> of helpers that can be invoked per fib6_nh with the goal of making patch
> 4 easier to review as well as creating the code needed for nexthop
> objects.
> 
> Patch 5 makes a fib6_nh at the end of a fib6_info an array similar to
> IPv4 and its fib_info. For the current fib entry model, all fib6_info
> will have a fib6_nh allocated for it.
> 
> Patch 6 refactors ip6_route_del moving the code for deleting an
> exception entry into a new function.
> 
> Patch 7 adds tests for redirect route exceptions. The new test was
> written against 5.1 (before any of the nexthop refactoring). It and the
> pmtu.sh selftest exercise the exception code paths - from creating
> exceptions to cleaning them up on device delete. All tests pass without
> any rcu locking or memleak warnings.

Series applied, thanks David.
