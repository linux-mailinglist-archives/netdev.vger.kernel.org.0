Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43AA7D4CC2
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 06:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727117AbfJLEV0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 00:21:26 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55442 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725308AbfJLEV0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Oct 2019 00:21:26 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 456F815004EAC;
        Fri, 11 Oct 2019 21:21:25 -0700 (PDT)
Date:   Fri, 11 Oct 2019 21:21:24 -0700 (PDT)
Message-Id: <20191011.212124.1517786431494477849.davem@davemloft.net>
To:     dhowells@redhat.com
Cc:     netdev@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] rxrpc: Fix possible NULL pointer access in ICMP
 handling
From:   David Miller <davem@davemloft.net>
In-Reply-To: <157071915431.29197.5055122258964729288.stgit@warthog.procyon.org.uk>
References: <157071915431.29197.5055122258964729288.stgit@warthog.procyon.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 11 Oct 2019 21:21:25 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Howells <dhowells@redhat.com>
Date: Thu, 10 Oct 2019 15:52:34 +0100

> If an ICMP packet comes in on the UDP socket backing an AF_RXRPC socket as
> the UDP socket is being shut down, rxrpc_error_report() may get called to
> deal with it after sk_user_data on the UDP socket has been cleared, leading
> to a NULL pointer access when this local endpoint record gets accessed.
> 
> Fix this by just returning immediately if sk_user_data was NULL.
> 
> The oops looks like the following:
 ...
> Fixes: 17926a79320a ("[AF_RXRPC]: Provide secure RxRPC sockets for use by userspace and kernel both")
> Reported-by: syzbot+611164843bd48cc2190c@syzkaller.appspotmail.com
> Signed-off-by: David Howells <dhowells@redhat.com>

Applied and queued up for -stable, thanks.
