Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26FC5D863E
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 05:15:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390841AbfJPDPc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 23:15:32 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43734 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390837AbfJPDPc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 23:15:32 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C2EDC128F385C;
        Tue, 15 Oct 2019 20:15:31 -0700 (PDT)
Date:   Tue, 15 Oct 2019 20:15:29 -0700 (PDT)
Message-Id: <20191015.201529.1895543949965274139.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        jakub.kicinski@netronome.com, syzkaller@googlegroups.com
Subject: Re: [PATCH net] tcp: fix a possible lockdep splat in tcp_done()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191014134757.185995-1-edumazet@google.com>
References: <20191014134757.185995-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 15 Oct 2019 20:15:32 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Mon, 14 Oct 2019 06:47:57 -0700

> syzbot found that if __inet_inherit_port() returns an error,
> we call tcp_done() after inet_csk_prepare_forced_close(),
> meaning the socket lock is no longer held.
> 
> We might fix this in a different way in net-next, but
> for 5.4 it seems safer to relax the lockdep check.
> 
> Fixes: d983ea6f16b8 ("tcp: add rcu protection around tp->fastopen_rsk")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>

Applied.
