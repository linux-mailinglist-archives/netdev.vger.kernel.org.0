Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CEC088200
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 20:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437362AbfHISHI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 14:07:08 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35854 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726582AbfHISHI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 14:07:08 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 15A7C15422F8B;
        Fri,  9 Aug 2019 11:07:08 -0700 (PDT)
Date:   Fri, 09 Aug 2019 11:07:05 -0700 (PDT)
Message-Id: <20190809.110705.591778512450074017.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com, soheil@google.com
Subject: Re: [PATCH net-next] tcp: batch calls to sk_flush_backlog()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190809120447.93591-1-edumazet@google.com>
References: <20190809120447.93591-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 09 Aug 2019 11:07:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Fri,  9 Aug 2019 05:04:47 -0700

> Starting from commit d41a69f1d390 ("tcp: make tcp_sendmsg() aware of socket backlog")
> loopback flows got hurt, because for each skb sent, the socket receives an
> immediate ACK and sk_flush_backlog() causes extra work.
> 
> Intent was to not let the backlog grow too much, but we went a bit too far.
> 
> We can check the backlog every 16 skbs (about 1MB chunks)
> to increase TCP over loopback performance by about 15 %
> 
> Note that the call to sk_flush_backlog() handles a single ACK,
> thanks to coalescing done on backlog, but cleans the 16 skbs
> found in rtx rb-tree.
> 
> Reported-by: Soheil Hassas Yeganeh <soheil@google.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied.
