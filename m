Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C7D420727
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 14:44:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727398AbfEPMod (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 08:44:33 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:34806 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726911AbfEPMod (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 08:44:33 -0400
Received: from penelope.horms.nl (ip4dab7138.direct-adsl.nl [77.171.113.56])
        by kirsty.vergenet.net (Postfix) with ESMTPA id E2E9C25AD69;
        Thu, 16 May 2019 22:44:30 +1000 (AEST)
Received: by penelope.horms.nl (Postfix, from userid 7100)
        id D590EE216B9; Thu, 16 May 2019 14:44:28 +0200 (CEST)
Date:   Thu, 16 May 2019 14:44:28 +0200
From:   Simon Horman <horms@verge.net.au>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Doug Ledford <dledford@redhat.com>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH v2] RDMA: Directly cast the sockaddr union to sockaddr
Message-ID: <20190516124428.hytvkwfltfi24lrv@verge.net.au>
References: <20190514005521.GA18085@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190514005521.GA18085@ziepe.ca>
Organisation: Horms Solutions BV
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 13, 2019 at 09:55:21PM -0300, Jason Gunthorpe wrote:
> gcc 9 now does allocation size tracking and thinks that passing the member
> of a union and then accessing beyond that member's bounds is an overflow.
> 
> Instead of using the union member, use the entire union with a cast to
> get to the sockaddr. gcc will now know that the memory extends the full
> size of the union.
> 
> Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
> ---
>  drivers/infiniband/core/addr.c           | 16 ++++++++--------
>  drivers/infiniband/hw/ocrdma/ocrdma_ah.c |  5 ++---
>  drivers/infiniband/hw/ocrdma/ocrdma_hw.c |  5 ++---
>  3 files changed, 12 insertions(+), 14 deletions(-)
> 
> I missed the ocrdma files in the v1
> 
> We can revisit what to do with that repetitive union after the merge
> window, but this simple patch will eliminate the warnings for now.
> 
> Linus, I'll send this as a PR tomorrow - there is also a bug fix for
> the rdma-netlink changes posted that should go too.

<2c>
I would be very happy to see this revisited in such a way
that some use is made of the C type system (instead of casts).
</2c>
