Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83DB018FE69
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 21:03:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725877AbgCWUDO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 16:03:14 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:51638 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbgCWUDN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 16:03:13 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 400E615AD6080;
        Mon, 23 Mar 2020 13:03:13 -0700 (PDT)
Date:   Mon, 23 Mar 2020 13:03:12 -0700 (PDT)
Message-Id: <20200323.130312.657468851247957068.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzkaller@googlegroups.com
Subject: Re: [PATCH net] tcp: repair: fix TCP_QUEUE_SEQ implementation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200319022102.188776-1-edumazet@google.com>
References: <20200319022102.188776-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 23 Mar 2020 13:03:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Wed, 18 Mar 2020 19:21:02 -0700

> When application uses TCP_QUEUE_SEQ socket option to
> change tp->rcv_next, we must also update tp->copied_seq.
> 
> Otherwise, stuff relying on tcp_inq() being precise can
> eventually be confused.
> 
> For example, tcp_zerocopy_receive() might crash because
> it does not expect tcp_recv_skb() to return NULL.
> 
> We could add tests in various places to fix the issue,
> or simply make sure tcp_inq() wont return a random value,
> and leave fast path as it is.
> 
> Note that this fixes ioctl(fd, SIOCINQ, &val) at the same
> time.
> 
> Fixes: ee9952831cfd ("tcp: Initial repair mode")
> Fixes: 05255b823a61 ("tcp: add TCP_ZEROCOPY_RECEIVE support for zerocopy receive")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>

Applied and queued up for -stable, thanks Eric.
