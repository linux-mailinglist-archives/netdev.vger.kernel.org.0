Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F11C262575
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 04:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728442AbgIIC51 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 22:57:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726642AbgIIC51 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 22:57:27 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12D4DC061573
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 19:57:27 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8F2F111E3E4C2;
        Tue,  8 Sep 2020 19:40:39 -0700 (PDT)
Date:   Tue, 08 Sep 2020 19:57:25 -0700 (PDT)
Message-Id: <20200908.195725.1372066279904059904.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com, dsahern@gmail.com
Subject: Re: [PATCH net] ipv6: avoid lockdep issue in fib6_del()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200908082023.3690438-1-edumazet@google.com>
References: <20200908082023.3690438-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 08 Sep 2020 19:40:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Tue,  8 Sep 2020 01:20:23 -0700

> syzbot reported twice a lockdep issue in fib6_del() [1]
> which I think is caused by net->ipv6.fib6_null_entry
> having a NULL fib6_table pointer.
> 
> fib6_del() already checks for fib6_null_entry special
> case, we only need to return earlier.
> 
> Bug seems to occur very rarely, I have thus chosen
> a 'bug origin' that makes backports not too complex.
 ...
> Fixes: 421842edeaf6 ("net/ipv6: Add fib6_null_entry")
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied and queued up for -stable, thanks Eric.
