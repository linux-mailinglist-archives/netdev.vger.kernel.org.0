Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 398699F977
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 06:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726100AbfH1EiJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 00:38:09 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54752 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725827AbfH1EiJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 00:38:09 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 67F86153BF45E;
        Tue, 27 Aug 2019 21:38:08 -0700 (PDT)
Date:   Tue, 27 Aug 2019 21:38:05 -0700 (PDT)
Message-Id: <20190827.213805.294784850249692598.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, soheil@google.com, ncardwell@google.com,
        eric.dumazet@gmail.com, jbaron@akamai.com, rutsky@google.com
Subject: Re: [PATCH net] tcp: remove empty skb from write queue in error
 cases
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190826161915.81676-1-edumazet@google.com>
References: <20190826161915.81676-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 27 Aug 2019 21:38:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Mon, 26 Aug 2019 09:19:15 -0700

> Vladimir Rutsky reported stuck TCP sessions after memory pressure
> events. Edge Trigger epoll() user would never receive an EPOLLOUT
> notification allowing them to retry a sendmsg().
> 
> Jason tested the case of sk_stream_alloc_skb() returning NULL,
> but there are other paths that could lead both sendmsg() and sendpage()
> to return -1 (EAGAIN), with an empty skb queued on the write queue.
> 
> This patch makes sure we remove this empty skb so that
> Jason code can detect that the queue is empty, and
> call sk->sk_write_space(sk) accordingly.
> 
> Fixes: ce5ec440994b ("tcp: ensure epoll edge trigger wakeup when write queue is empty")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Jason Baron <jbaron@akamai.com>
> Reported-by: Vladimir Rutsky <rutsky@google.com>

Applied and queued up for -stable.
