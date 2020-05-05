Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F37CE1C55DD
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 14:44:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728968AbgEEMoz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 08:44:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728497AbgEEMoz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 08:44:55 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0FAEC061A0F;
        Tue,  5 May 2020 05:44:54 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jVwwF-001UFP-0k; Tue, 05 May 2020 12:44:43 +0000
Date:   Tue, 5 May 2020 13:44:42 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     SeongJae Park <sjpark@amazon.com>
Cc:     davem@davemloft.net, kuba@kernel.org, gregkh@linuxfoundation.org,
        edumazet@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, SeongJae Park <sjpark@amazon.de>
Subject: Re: [PATCH net 0/2] Revert the 'socket_alloc' life cycle change
Message-ID: <20200505124442.GX23230@ZenIV.linux.org.uk>
References: <20200505072841.25365-1-sjpark@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200505072841.25365-1-sjpark@amazon.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 05, 2020 at 09:28:39AM +0200, SeongJae Park wrote:
> From: SeongJae Park <sjpark@amazon.de>
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
> To avoid the problem, this commit reverts the changes.

Is it "could cause" or is it "have been actually observed to"?
