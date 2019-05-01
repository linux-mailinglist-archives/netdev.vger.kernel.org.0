Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7EB91044F
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 05:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726052AbfEADkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 23:40:17 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54654 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbfEADkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Apr 2019 23:40:17 -0400
Received: from localhost (adsl-173-228-226-134.prtc.net [173.228.226.134])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F1AC7136D6BC8;
        Tue, 30 Apr 2019 20:40:15 -0700 (PDT)
Date:   Tue, 30 Apr 2019 23:40:14 -0400 (EDT)
Message-Id: <20190430.234014.837178465736820152.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzkaller@googlegroups.com, dsahern@gmail.com
Subject: Re: [PATCH net] ipv6: fix races in ip6_dst_destroy()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190428192225.123882-1-edumazet@google.com>
References: <20190428192225.123882-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 30 Apr 2019 20:40:16 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Sun, 28 Apr 2019 12:22:25 -0700

> We had many syzbot reports that seem to be caused by use-after-free
> of struct fib6_info.
> 
> ip6_dst_destroy(), fib6_drop_pcpu_from() and rt6_remove_exception()
> are writers vs rt->from, and use non consistent synchronization among
> themselves.
> 
> Switching to xchg() will solve the issues with no possible
> lockdep issues.
 ...
> Fixes: a68886a69180 ("net/ipv6: Make from in rt6_info rcu protected")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Cc: David Ahern <dsahern@gmail.com>

Applied and queued up for -stable, thanks Eric.
