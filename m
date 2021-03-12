Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2156338984
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 10:59:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233524AbhCLJ6t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 04:58:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:54076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233446AbhCLJ6l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 04:58:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D7EC764F00;
        Fri, 12 Mar 2021 09:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615542691;
        bh=YlsEYrZ94YD7S2juhHhixfEf4CmyjxepGm1iYQM/AFc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=urvbU/P3yusDJ54thsdajUoIRyd/5VHkpaK9tlp0pob6b8UdG12cr9sLQo9fwBnm5
         WdQVLhu7po5B3c7lUQ1bCw1SIa7+3Kmj2YzcLCkwkEohQyPSy2JXeQZAlfio7WMOHJ
         h6C/jyRyzTwMpuSKnPtS2KO95ATiEbdUSUgTsgic=
Date:   Fri, 12 Mar 2021 10:51:25 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH 4.19-stable 1/3] tcp: annotate tp->copied_seq lockless
 reads
Message-ID: <YEs5nddIMrbuWqHX@kroah.com>
References: <20210312083323.3720479-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210312083323.3720479-1-eric.dumazet@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 12, 2021 at 12:33:21AM -0800, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> [ Upstream commit 7db48e983930285b765743ebd665aecf9850582b ]
> 
> There are few places where we fetch tp->copied_seq while
> this field can change from IRQ or other cpu.
> 
> We need to add READ_ONCE() annotations, and also make
> sure write sides use corresponding WRITE_ONCE() to avoid
> store-tearing.
> 
> Note that tcp_inq_hint() was already using READ_ONCE(tp->copied_seq)
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>

All now queued up, thanks!

greg k-h
