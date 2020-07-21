Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE808227414
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 02:48:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728063AbgGUArp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 20:47:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726390AbgGUAro (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 20:47:44 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEEC8C061794;
        Mon, 20 Jul 2020 17:47:44 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7A0FD11E8EC06;
        Mon, 20 Jul 2020 17:30:59 -0700 (PDT)
Date:   Mon, 20 Jul 2020 17:47:43 -0700 (PDT)
Message-Id: <20200720.174743.1334852224037041234.davem@davemloft.net>
To:     dhowells@redhat.com
Cc:     netdev@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] rxrpc: Fix sendmsg() returning EPIPE due to
 recvmsg() returning ENODATA
From:   David Miller <davem@davemloft.net>
In-Reply-To: <159524530669.329784.1191492556041235335.stgit@warthog.procyon.org.uk>
References: <159524530669.329784.1191492556041235335.stgit@warthog.procyon.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 20 Jul 2020 17:30:59 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Howells <dhowells@redhat.com>
Date: Mon, 20 Jul 2020 12:41:46 +0100

> rxrpc_sendmsg() returns EPIPE if there's an outstanding error, such as if
> rxrpc_recvmsg() indicating ENODATA if there's nothing for it to read.
> 
> Change rxrpc_recvmsg() to return EAGAIN instead if there's nothing to read
> as this particular error doesn't get stored in ->sk_err by the networking
> core.
> 
> Also change rxrpc_sendmsg() so that it doesn't fail with delayed receive
> errors (there's no way for it to report which call, if any, the error was
> caused by).
> 
> Fixes: 17926a79320a ("[AF_RXRPC]: Provide secure RxRPC sockets for use by userspace and kernel both")
> Signed-off-by: David Howells <dhowells@redhat.com>

Applied and queued up for -stable, thanks David.
