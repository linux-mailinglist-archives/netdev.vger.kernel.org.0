Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D817254F8A
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 21:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727949AbgH0T4V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 15:56:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726246AbgH0T4V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 15:56:21 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51487C061264;
        Thu, 27 Aug 2020 12:56:21 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7806D126BEC10;
        Thu, 27 Aug 2020 12:39:27 -0700 (PDT)
Date:   Thu, 27 Aug 2020 12:56:10 -0700 (PDT)
Message-Id: <20200827.125610.1855963268633335218.davem@davemloft.net>
To:     dhowells@redhat.com
Cc:     netdev@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 0/7] rxrpc, afs: Fix probing issues
From:   David Miller <davem@davemloft.net>
In-Reply-To: <159854061331.1382667.9693163318506702951.stgit@warthog.procyon.org.uk>
References: <159854061331.1382667.9693163318506702951.stgit@warthog.procyon.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 27 Aug 2020 12:39:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Howells <dhowells@redhat.com>
Date: Thu, 27 Aug 2020 16:03:33 +0100

> 
> Here are some fixes for rxrpc and afs to fix issues in the RTT measuring in
> rxrpc and thence the Volume Location server probing in afs:
> 
>  (1) Move the serial number of a received ACK into a local variable to
>      simplify the next patch.
> 
>  (2) Fix the loss of RTT samples due to extra interposed ACKs causing
>      baseline information to be discarded too early.  This is a particular
>      problem for afs when it sends a single very short call to probe a
>      server it hasn't talked to recently.
> 
>  (3) Fix rxrpc_kernel_get_srtt() to indicate whether it actually has seen
>      any valid samples or not.
> 
>  (4) Remove a field that's set/woken, but never read/waited on.
> 
>  (5) Expose the RTT and other probe information through procfs to make
>      debugging of this stuff easier.
> 
>  (6) Fix VL rotation in afs to only use summary information from VL probing
>      and not the probe running state (which gets clobbered when next a
>      probe is issued).
> 
>  (7) Fix VL rotation to actually return the error aggregated from the probe
>      errors.
> 
> The patches are tagged here:
> 
> 	git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git
> 	rxrpc-fixes-20200820

Pulled, thanks David.
