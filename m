Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F7D51DF288
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 00:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731248AbgEVWyU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 18:54:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731138AbgEVWyU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 18:54:20 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42AE9C061A0E;
        Fri, 22 May 2020 15:54:20 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B1F0F12748826;
        Fri, 22 May 2020 15:54:19 -0700 (PDT)
Date:   Fri, 22 May 2020 15:54:18 -0700 (PDT)
Message-Id: <20200522.155418.406408375053374516.davem@davemloft.net>
To:     dhowells@redhat.com
Cc:     netdev@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 0/3] rxrpc: Fix retransmission timeout and ACK
 discard
From:   David Miller <davem@davemloft.net>
In-Reply-To: <159001690181.18663.663730118645460940.stgit@warthog.procyon.org.uk>
References: <159001690181.18663.663730118645460940.stgit@warthog.procyon.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 22 May 2020 15:54:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Howells <dhowells@redhat.com>
Date: Thu, 21 May 2020 00:21:42 +0100

> 
> Here are a couple of fixes and an extra tracepoint for AF_RXRPC:
> 
>  (1) Calculate the RTO pretty much as TCP does, rather than making
>      something up, including an initial 4s timeout (which causes return
>      probes from the fileserver to fail if a packet goes missing), and add
>      backoff.
> 
>  (2) Fix the discarding of out-of-order received ACKs.  We mustn't let the
>      hard-ACK point regress, nor do we want to do unnecessary
>      retransmission because the soft-ACK list regresses.  This is not
>      trivial, however, due to some loose wording in various old protocol
>      specs, the ACK field that should be used for this sometimes has the
>      wrong information in it.
> 
>  (3) Add a tracepoint to log a discarded ACK.
> 
> The patches are tagged here:
> 
> 	git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git
> 	rxrpc-fixes-20200520

Pulled, thanks David.
