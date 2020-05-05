Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 536CC1C4F71
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 09:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728574AbgEEHpS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 03:45:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:40562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728565AbgEEHpP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 03:45:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 179002078E;
        Tue,  5 May 2020 07:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588664715;
        bh=d7kGl8EmDAO8ZOBK3gZ//gfpMqkW08L56eEq7FgxXWk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Z0SS3n1fnEgyhA06l2/QuLbQ0/QDNt18elj+gWpCVRwcrNus8vy9DwuClxJ8pB5gN
         nVSOdJNcaOsnEkF6q8yzqVNMnpvt1OvDrqolEqWgfMUYAYfuFKgZs+csxtkDVrngjr
         VSEpbaFdvLuaCleSmCj/4VMCust8N+VB3s9QcZpI=
Date:   Tue, 5 May 2020 09:45:11 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     SeongJae Park <sjpark@amazon.com>
Cc:     davem@davemloft.net, viro@zeniv.linux.org.uk, kuba@kernel.org,
        edumazet@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, SeongJae Park <sjpark@amazon.de>
Subject: Re: [PATCH net 1/2] Revert "coallocate socket_wq with socket itself"
Message-ID: <20200505074511.GA4054974@kroah.com>
References: <20200505072841.25365-1-sjpark@amazon.com>
 <20200505072841.25365-2-sjpark@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200505072841.25365-2-sjpark@amazon.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 05, 2020 at 09:28:40AM +0200, SeongJae Park wrote:
> From: SeongJae Park <sjpark@amazon.de>
> 
> This reverts commit 333f7909a8573145811c4ab7d8c9092301707721.
> 
> The commit 6d7855c54e1e ("sockfs: switch to ->free_inode()") made the
> deallocation of 'socket_alloc' to be done asynchronously using RCU, as
> same to 'sock.wq'.  And the following commit 333f7909a857 ("coallocate
> socket_sq with socket itself") made those to have same life cycle.
> 
> The changes made the code much more simple, but also made 'socket_alloc'
> live longer than before.  For the reason, user programs intensively
> repeating allocations and deallocations of sockets could cause memory
> pressure on recent kernels.
> 
> To avoid the problem, this commit separates the life cycle of
> 'socket_alloc' and 'sock.wq' again.  The following commit will make the
> deallocation of 'socket_alloc' to be done synchronously again.
> ---

No signed-off-by?
No "Fixes:"?

:(

