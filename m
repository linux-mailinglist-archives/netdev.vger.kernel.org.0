Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63765F2730
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 06:38:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726436AbfKGFiw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 00:38:52 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:33996 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbfKGFiw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 00:38:52 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E38271511FD51;
        Wed,  6 Nov 2019 21:38:51 -0800 (PST)
Date:   Wed, 06 Nov 2019 21:38:51 -0800 (PST)
Message-Id: <20191106.213851.1054347109219818319.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com, soheil@google.com,
        syzkaller@googlegroups.com
Subject: Re: [PATCH net-next] tcp: fix data-race in tcp_recvmsg()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191106205933.149697-1-edumazet@google.com>
References: <20191106205933.149697-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 06 Nov 2019 21:38:52 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Wed,  6 Nov 2019 12:59:33 -0800

> Reading tp->recvmsg_inq after socket lock is released
> raises a KCSAN warning [1]
> 
> Replace has_tss & has_cmsg by cmsg_flags and make
> sure to not read tp->recvmsg_inq a second time.
> 
> [1]
> BUG: KCSAN: data-race in tcp_chrono_stop / tcp_recvmsg
 ...
> Fixes: b75eba76d3d7 ("tcp: send in-queue bytes in cmsg upon read")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>

Applied, thanks Eric.
