Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2674B1C4F76
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 09:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728588AbgEEHpi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 03:45:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:40892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727938AbgEEHpi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 03:45:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 404F2206CC;
        Tue,  5 May 2020 07:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588664737;
        bh=KabGD4ekn5YE4Pzx/iZDYkiL8RHInKLJTdo36GuGiug=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MB5J6NxaWPPdA49yOdcc3E0eCCKZGUoGTno53CYL4PpBBM0d82eJK4gHwBkshuHOX
         acn3ntKp+HFX7GBsVFTTyEahgRy8Ldhw5p+P6HNpnUcIHFYJuN1FH+uQ/d7qKDZ6LW
         IHK/pe2cHDJg0yQK4VwxjS3h9fF3c91V442WA26o=
Date:   Tue, 5 May 2020 09:45:35 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     SeongJae Park <sjpark@amazon.com>
Cc:     davem@davemloft.net, viro@zeniv.linux.org.uk, kuba@kernel.org,
        edumazet@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, SeongJae Park <sjpark@amazon.de>
Subject: Re: [PATCH net 2/2] Revert "sockfs: switch to ->free_inode()"
Message-ID: <20200505074535.GB4054974@kroah.com>
References: <20200505072841.25365-1-sjpark@amazon.com>
 <20200505072841.25365-3-sjpark@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200505072841.25365-3-sjpark@amazon.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 05, 2020 at 09:28:41AM +0200, SeongJae Park wrote:
> From: SeongJae Park <sjpark@amazon.de>
> 
> This reverts commit 6d7855c54e1e269275d7c504f8f62a0b7a5b3f18.
> 
> The commit 6d7855c54e1e ("sockfs: switch to ->free_inode()") made the
> deallocation of 'socket_alloc' to be done asynchronously using RCU, as
> same to 'sock.wq'.
> 
> The change made 'socket_alloc' live longer than before.  As a result,
> user programs intensively repeating allocations and deallocations of
> sockets could cause memory pressure on recent kernels.
> 
> To avoid the problem, this commit reverts the change.
> ---
>  net/socket.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Same problems here as in patch 1/2 :(
