Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24DD73AEC5B
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 17:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbhFUPa4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 11:30:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:55080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229904AbhFUPaz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 11:30:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 91C81610A3;
        Mon, 21 Jun 2021 15:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624289321;
        bh=2I5sDArcYUqiV0aAit2mksHSHs8kCm+3kN63ozS6XnQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OQvLJN0e4Y57h12cOlFnNjp0QbsR7XDeUe9FIbkei8I48jtG/3sVRlF5JYQzvMeE1
         upma7n9YxwcdmZ17lkGy9iUaYcpAAlDAIRfzCU7SdUwavx5nY0ELazorv5QgKkhXCF
         rxG42lmUf2S6rQ2NCIwH4XYjb+XSU+io7mhey0Yo=
Date:   Mon, 21 Jun 2021 17:28:38 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Amit Klein <aksecurity@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        edumazet@google.com, w@1wt.eu, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH 4.19] inet: use bigger hash table for IP ID generation
 (backported to 4.19)
Message-ID: <YNCwJqtKKCskB2Au@kroah.com>
References: <60cb0586.1c69fb81.8015b.37a1@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <60cb0586.1c69fb81.8015b.37a1@mx.google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 17, 2021 at 01:19:18AM -0700, Amit Klein wrote:
> Subject: inet: use bigger hash table for IP ID generation (backported to 4.19)
> From: Amit Klein <aksecurity@gmail.com>
> 
> This is a backport to 4.19 of the following patch, originally
> developed by Eric Dumazet.
> 
> In commit 73f156a6e8c1 ("inetpeer: get rid of ip_id_count")
> I used a very small hash table that could be abused
> by patient attackers to reveal sensitive information.
> 
> Switch to a dynamic sizing, depending on RAM size.
> 
> Typical big hosts will now use 128x more storage (2 MB)
> to get a similar increase in security and reduction
> of hash collisions.
> 
> As a bonus, use of alloc_large_system_hash() spreads
> allocated memory among all NUMA nodes.
> 
> Fixes: 73f156a6e8c1 ("inetpeer: get rid of ip_id_count")
> Reported-by: Amit Klein <aksecurity@gmail.com>
> Cc: stable@vger.kernel.org
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Willy Tarreau <w@1wt.eu>
> ---
>  net/ipv4/route.c | 42 ++++++++++++++++++++++++++++--------------
>  1 file changed, 28 insertions(+), 14 deletions(-)
> 
> (limited to 'net/ipv4/route.c')

I had to dig up what the upstream git commit id was for this, please
specify it next time :(

I've queued this, and the 4.14 version up.  Can you create a 4.4.y and
4.9.y version as well?

thanks,

greg k-h
