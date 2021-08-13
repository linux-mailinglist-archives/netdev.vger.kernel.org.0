Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91A603EBC57
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 21:01:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233589AbhHMTBY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 15:01:24 -0400
Received: from wnew1-smtp.messagingengine.com ([64.147.123.26]:39509 "EHLO
        wnew1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230440AbhHMTBX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 15:01:23 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.west.internal (Postfix) with ESMTP id 935342B011D3;
        Fri, 13 Aug 2021 15:00:52 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 13 Aug 2021 15:00:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        joshtriplett.org; h=date:from:to:cc:subject:message-id
        :references:mime-version:content-type:in-reply-to; s=fm1; bh=Oi9
        pJS/VGWw696eTE+HoTGcxYFI8GqP9wVUUlw1PSOc=; b=fXlJPlutM/+izC+yijH
        iTEGyqvzLzEsBCwgkXcOhWVudDdiSvID7fBVnK/QeNVMLrDuyGQOuPSxbEZTCPRQ
        +UrgK6s+MTgFxYrdtADeFOPFvpJaWqZL4hF3rssxiNguhU6m0j5P/jU+zbeQsnXy
        NjRQqP9k1W2AFhGHUDMQuwVyMQ2tvyVKbH4+P2n2OpcT/Dh5XAgqiVz+irHTZYLW
        n8k//ViXfvgoYhh5VDIilvGPvBY+xJgWCigVrDtvbUnzUNkWLzT/7nlVV/zqJWtE
        F0Qwd8kIOoqmNlaaGxj0EWD+rLJqi5AWnLixNsTdk/3oH1Obk5lnnrB1ueyNUddL
        ILw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Oi9pJS
        /VGWw696eTE+HoTGcxYFI8GqP9wVUUlw1PSOc=; b=SoR9Ne5uhZS+goYczaeM41
        /w0Zk587Z16VWAbDRSBOGYHpzzPpxtX7fRMTi1xYsPbYivG0XBIsAxmYDmcE3i6S
        Nq8rLHJQ6AEtcl/t99gDjBnvJ5+OboJgU3v4sNAMShvqX3+ANcZEWAkLX2J4+7j4
        jv/1HfDL4GxDp1dmoem+Y28PATzMD8xeXCGvN7JQkSIhqR9b8rdllmIEaVhy+k1E
        78s5uJj8i9ZAbiaciDNLtQftUfekf/PeTsBwRDNkelfVR+q1KrOjL/acOXmaFqkr
        gwbSkBDzw48S/cm2Cq3w1ms0ALJ+Ia11n+b0bgCf/t36DUE6APWljHC/NTa/7nLg
        ==
X-ME-Sender: <xms:YsEWYXqUUWgYznRgblPPLLQzppxOE7Z-iX71jpUNfLcNN-FK84PiKw>
    <xme:YsEWYRrwj6qS7-xqtyfQrvigZE8H-UdgkZjeQvnEnFeB8CqOINKPldPbqiQjHNooA
    VXlb-6JyRJSB7ELUyM>
X-ME-Received: <xmr:YsEWYUPvWMwmx0x6w9ginb8mU-6YM4vybFYVUt7bvDJ29muuQXubIaWafO0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrkeehgddufeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeflohhshhcu
    vfhrihhplhgvthhtuceojhhoshhhsehjohhshhhtrhhiphhlvghtthdrohhrgheqnecugg
    ftrfgrthhtvghrnhepgedtgfefgefhveeglefgfeeigeduueehkeektdeuueetgfehffev
    geeuieetheetnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepjhhoshhhsehjohhshhhtrhhiphhlvghtthdrohhrgh
X-ME-Proxy: <xmx:YsEWYa59e9m1GzYPKp6KQ0YDCTCyZtZXvG6h_icYa-d-lfX527xUog>
    <xmx:YsEWYW6bKokVYlL4vjCf_FYtEbIcW261ajTKsFqhGduqMi468D6kkQ>
    <xmx:YsEWYSieF93-JQ2amW9-P2kyJj0FJg3cCxrxHrnB2rbLTwj7dS7a9g>
    <xmx:ZMEWYTsMldItVl5TYGTV-Z6VvAs-AWypBBmTJRSGFD4_PPjPmJ3hNQm8GX4>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 13 Aug 2021 15:00:49 -0400 (EDT)
Date:   Fri, 13 Aug 2021 12:00:48 -0700
From:   Josh Triplett <josh@joshtriplett.org>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Stefan Metzmacher <metze@samba.org>
Subject: Re: [PATCH v2 0/4] open/accept directly into io_uring fixed file
 table
Message-ID: <YRbBYCn29B+kgZcy@localhost>
References: <cover.1628871893.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1628871893.git.asml.silence@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 13, 2021 at 05:43:09PM +0100, Pavel Begunkov wrote:
> Add an optional feature to open/accept directly into io_uring's fixed
> file table bypassing the normal file table. Same behaviour if as the
> snippet below, but in one operation:
> 
> sqe = prep_[open,accept](...);
> cqe = submit_and_wait(sqe);
> // error handling
> io_uring_register_files_update(uring_idx, (fd = cqe->res));
> // optionally
> close((fd = cqe->res));
> 
> The idea in pretty old, and was brough up and implemented a year ago
> by Josh Triplett, though haven't sought the light for some reasons.

Thank you for working to get this over the finish line!

> Tested on basic cases, will be sent out as liburing patches later.
> 
> A copy paste from 2/2 describing user API and some notes:
> 
> The behaviour is controlled by setting sqe->file_index, where 0 implies
> the old behaviour. If non-zero value is specified, then it will behave
> as described and place the file into a fixed file slot
> sqe->file_index - 1. A file table should be already created, the slot
> should be valid and empty, otherwise the operation will fail.
> 
> Note 1: we can't use IOSQE_FIXED_FILE to switch between modes, because
> accept takes a file, and it already uses the flag with a different
> meaning.
> 
> Note 2: it's u16, where in theory the limit for fixed file tables might
> get increased in the future. If would ever happen so, we'll better
> workaround later, e.g. by making ioprio to represent upper bits 16 bits.
> The layout for open is tight already enough.

Rather than using sqe->file_index - 1, which feels like an error-prone
interface, I think it makes sense to use a dedicated flag for this, like
IOSQE_OPEN_FIXED. That flag could work for any open-like operation,
including open, accept, and in the future many other operations such as
memfd_create. (Imagine using a single ring submission to open a memfd,
write a buffer into it, seal it, send it over a UNIX socket, and then
close it.)

The only downside is that you'll need to reject that flag in all
non-open operations. One way to unify that code might be to add a flag
in io_op_def for open-like operations, and then check in common code for
the case of non-open-like operations passing IOSQE_OPEN_FIXED.

Also, rather than using a 16-bit index for the fixed file table and
potentially requiring expansion into a different field in the future,
what about overlapping it with the nofile field in the open and accept
requests? If they're not opening a normal file descriptor, they don't
need nofile. And in the original sqe, you can then overlap it with a
32-bit field like splice_fd_in.

EEXIST seems like the wrong error-code to use if the index is already in
use; open can already return EEXIST if you pass O_EXCL. How about EBADF,
or better yet EBADSLT which is unlikely to be returned for any other
reason?

- Josh Triplett
