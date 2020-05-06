Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2E1E1C6945
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 08:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728113AbgEFGrU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 02:47:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:34332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727812AbgEFGrU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 May 2020 02:47:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E42E820714;
        Wed,  6 May 2020 06:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588747639;
        bh=N4qdH4OxIaQgxglHU2KrfcqJnuqVbOOhzNp8eDLs7cA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aaCtrUnoxK/t+p/gX3MACzVfu6fXeGjp1x/VjQTWZYC3kNxGjOKEwd+6pNCyUFd+T
         dd+BkwFu4NNMv5m58jhy698NXJGwWgnRjOy9VzMpb9NS7TE+zCiLgbM2hiF2eLwjSG
         dOOPJUpt9uq0qFqWUr+pZBQwcf5j2jfz9lStbokI=
Date:   Wed, 6 May 2020 08:47:17 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     ashwin-h <ashwinh@vmware.com>
Cc:     vyasevich@gmail.com, nhorman@tuxdriver.com, davem@davemloft.net,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, srivatsab@vmware.com,
        srivatsa@csail.mit.edu, rostedt@goodmis.org, srostedt@vmware.com,
        ashwin.hiranniah@gmail.com, Xin Long <lucien.xin@gmail.com>
Subject: Re: [PATCH 2/2] sctp: implement memory accounting on rx path
Message-ID: <20200506064717.GB2273049@kroah.com>
References: <cover.1588242081.git.ashwinh@vmware.com>
 <b2d9886afc672b4120f101eeb9217e68abb61471.1588242081.git.ashwinh@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b2d9886afc672b4120f101eeb9217e68abb61471.1588242081.git.ashwinh@vmware.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 06, 2020 at 07:50:54PM +0530, ashwin-h wrote:
> From: Xin Long <lucien.xin@gmail.com>
> 
> commit 9dde27de3e5efa0d032f3c891a0ca833a0d31911 upstream.
> 
> sk_forward_alloc's updating is also done on rx path, but to be consistent
> we change to use sk_mem_charge() in sctp_skb_set_owner_r().
> 
> In sctp_eat_data(), it's not enough to check sctp_memory_pressure only,
> which doesn't work for mem_cgroup_sockets_enabled, so we change to use
> sk_under_memory_pressure().
> 
> When it's under memory pressure, sk_mem_reclaim() and sk_rmem_schedule()
> should be called on both RENEGE or CHUNK DELIVERY path exit the memory
> pressure status as soon as possible.
> 
> Note that sk_rmem_schedule() is using datalen to make things easy there.
> 
> Reported-by: Matteo Croce <mcroce@redhat.com>
> Tested-by: Matteo Croce <mcroce@redhat.com>
> Acked-by: Neil Horman <nhorman@tuxdriver.com>
> Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Ashwin H <ashwinh@vmware.com>
> ---
>  include/net/sctp/sctp.h |  2 +-
>  net/sctp/sm_statefuns.c |  6 ++++--
>  net/sctp/ulpevent.c     | 19 ++++++++-----------
>  net/sctp/ulpqueue.c     |  3 ++-
>  4 files changed, 15 insertions(+), 15 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
