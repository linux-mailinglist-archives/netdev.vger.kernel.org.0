Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3FDD1DF57C
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 09:23:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387695AbgEWHXW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 May 2020 03:23:22 -0400
Received: from verein.lst.de ([213.95.11.211]:34128 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387622AbgEWHXV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 23 May 2020 03:23:21 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id EB36D68BEB; Sat, 23 May 2020 09:23:16 +0200 (CEST)
Date:   Sat, 23 May 2020 09:23:16 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-nvme@lists.infradead.org, linux-sctp@vger.kernel.org,
        target-devel@vger.kernel.org, linux-afs@lists.infradead.org,
        drbd-dev@lists.linbit.com, linux-cifs@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-rdma@vger.kernel.org,
        cluster-devel@redhat.com, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        ceph-devel@vger.kernel.org, linux-nfs@vger.kernel.org,
        Neil Horman <nhorman@tuxdriver.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>,
        linux-kernel@vger.kernel.org, Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>, ocfs2-devel@oss.oracle.com
Subject: Re: remove kernel_setsockopt and kernel_getsockopt v2
Message-ID: <20200523072316.GA10575@lst.de>
References: <20200520195509.2215098-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200520195509.2215098-1-hch@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 20, 2020 at 09:54:36PM +0200, Christoph Hellwig wrote:
> Hi Dave,
> 
> this series removes the kernel_setsockopt and kernel_getsockopt
> functions, and instead switches their users to small functions that
> implement setting (or in one case getting) a sockopt directly using
> a normal kernel function call with type safety and all the other
> benefits of not having a function call.
> 
> In some cases these functions seem pretty heavy handed as they do
> a lock_sock even for just setting a single variable, but this mirrors
> the real setsockopt implementation unlike a few drivers that just set
> set the fields directly.

Hi Dave and other maintainers,

can you take a look at and potentially merge patches 1-30 while we
discuss the sctp refactoring?  It would get a nice headstart by removing
kernel_getsockopt and most kernel_setsockopt users, and for the next
follow on I wouldn't need to spam lots of lists with 30+ patches again.
