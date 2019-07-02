Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D6635D6B8
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 21:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727122AbfGBTQN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 15:16:13 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40494 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbfGBTQL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 15:16:11 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AF4F3136E13EF;
        Tue,  2 Jul 2019 12:16:10 -0700 (PDT)
Date:   Tue, 02 Jul 2019 12:16:10 -0700 (PDT)
Message-Id: <20190702.121610.2172819670405515831.davem@davemloft.net>
To:     dhowells@redhat.com
Cc:     netdev@vger.kernel.org,
        syzbot+7966f2a0b2c7da8939b4@syzkaller.appspotmail.com,
        marc.dionne@auristor.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] rxrpc: Fix send on a connected, but unbound socket
From:   David Miller <davem@davemloft.net>
In-Reply-To: <156207955265.1655.13658692984261290810.stgit@warthog.procyon.org.uk>
References: <156207955265.1655.13658692984261290810.stgit@warthog.procyon.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 02 Jul 2019 12:16:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Howells <dhowells@redhat.com>
Date: Tue, 02 Jul 2019 15:59:12 +0100

> If sendmsg() or sendmmsg() is called on a connected socket that hasn't had
> bind() called on it, then an oops will occur when the kernel tries to
> connect the call because no local endpoint has been allocated.
> 
> Fix this by implicitly binding the socket if it is in the
> RXRPC_CLIENT_UNBOUND state, just like it does for the RXRPC_UNBOUND state.
> 
> Further, the state should be transitioned to RXRPC_CLIENT_BOUND after this
> to prevent further attempts to bind it.
> 
> This can be tested with:
 ...
> Leading to the following oops:
 ...
> Fixes: 2341e0775747 ("rxrpc: Simplify connect() implementation and simplify sendmsg() op")
> Reported-by: syzbot+7966f2a0b2c7da8939b4@syzkaller.appspotmail.com
> Signed-off-by: David Howells <dhowells@redhat.com>
> Reviewed-by: Marc Dionne <marc.dionne@auristor.com>

Applied and queued up for -stable, thanks.
