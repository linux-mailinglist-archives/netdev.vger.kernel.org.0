Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 920B249D90F
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 04:14:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235622AbiA0DOp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 22:14:45 -0500
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:33616 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229997AbiA0DOo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 22:14:44 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R771e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0V2xw8MM_1643253280;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0V2xw8MM_1643253280)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 27 Jan 2022 11:14:41 +0800
Date:   Thu, 27 Jan 2022 11:14:37 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Leon Romanovsky <leon@kernel.org>, kgraul@linux.ibm.com,
        kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: Re: [RFC PATCH net-next 0/6] net/smc: Spread workload over multiple
 cores
Message-ID: <YfIOHZ7hSfogeTyS@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <20220114054852.38058-1-tonylu@linux.alibaba.com>
 <YePesYRnrKCh1vFy@unreal>
 <YfD26mhGkM9DFBV+@TonyMac-Alibaba>
 <20220126152806.GN8034@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220126152806.GN8034@ziepe.ca>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 26, 2022 at 11:28:06AM -0400, Jason Gunthorpe wrote:
> On Wed, Jan 26, 2022 at 03:23:22PM +0800, Tony Lu wrote:
> > On Sun, Jan 16, 2022 at 11:00:33AM +0200, Leon Romanovsky wrote:
> > > 
> > > Please CC RDMA mailing list next time.
> > > 
> > > Why didn't you use already existed APIs in drivers/infiniband/core/cq.c?
> > > ib_cq_pool_get() will do most if not all of your open-coded CQ spreading
> > > logic.
> > 
> > I am working on replacing with ib_cq_pool_get(), this need ib_poll_context
> > to indicate the poller which provides by ib_poll_handler(). It's okay
> > for now, but for the callback function. When it polled a ib_wc, it
> > would call wc->wr_cqe->done(cq, wc), which is the union with wr_id. The
> > wr_id is heavily used in SMC.
> 
> Part of using the new interface is converting to use wr_cqe, you
> should just do that work instead of trying to duplicate a core API in
> a driver.

Thanks for your advice. This patch set aims to improve performance with
current API in SMC protocol, which is more urgent. I will do that work
with new API in the next separate patch.That work may require a lot of
revisions, I will issue patches after a full discussion with Karsten
and finalization of the solution.

Thanks,
Tony Lu
