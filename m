Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CB0849DE6E
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 10:50:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238842AbiA0Juf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 04:50:35 -0500
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:38763 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229483AbiA0Jue (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 04:50:34 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0V2zUp2u_1643277031;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0V2zUp2u_1643277031)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 27 Jan 2022 17:50:31 +0800
Date:   Thu, 27 Jan 2022 17:50:30 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, kgraul@linux.ibm.com,
        kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: Re: [RFC PATCH net-next 0/6] net/smc: Spread workload over multiple
 cores
Message-ID: <YfJq5pygXS13XRhp@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <20220114054852.38058-1-tonylu@linux.alibaba.com>
 <YePesYRnrKCh1vFy@unreal>
 <YfD26mhGkM9DFBV+@TonyMac-Alibaba>
 <20220126152806.GN8034@ziepe.ca>
 <YfIOHZ7hSfogeTyS@TonyMac-Alibaba>
 <YfI50xqsv20KDpz9@unreal>
 <YfJQ6AwYMA/i4HvH@TonyMac-Alibaba>
 <YfJcDfkBZfeYA1Z/@unreal>
 <YfJieyROaAKE+ZO0@TonyMac-Alibaba>
 <YfJlFe3p2ABbzoYI@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YfJlFe3p2ABbzoYI@unreal>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 27, 2022 at 11:25:41AM +0200, Leon Romanovsky wrote:
> On Thu, Jan 27, 2022 at 05:14:35PM +0800, Tony Lu wrote:
> > On Thu, Jan 27, 2022 at 10:47:09AM +0200, Leon Romanovsky wrote:
> > > On Thu, Jan 27, 2022 at 03:59:36PM +0800, Tony Lu wrote:
> > 
> > Sorry for that if I missed something about properly using existing
> > in-kernel API. I am not sure the proper API is to use ib_cq_pool_get()
> > and ib_cq_pool_put()?
> > 
> > If so, these APIs doesn't suit for current smc's usage, I have to
> > refactor logic (tasklet and wr_id) in smc. I think it is a huge work
> > and should do it with full discussion.
> 
> This discussion is not going anywhere. Just to summarize, we (Jason and I)
> are asking to use existing API, from the beginning.

Yes, I can't agree more with you about using existing API and I have
tried them earlier. The existing APIs are easy to use if I wrote a new
logic. I also don't want to repeat the codes.

The main obstacle is that the packet and wr processing of smc is
tightly bound to the old API and not easy to replace with existing API.

To solve a real issue, I have to fix it based on the old API. If using
existing API in this patch, I have to refactor smc logics which needs
more time. Our production tree is synced with smc next. So I choose to
fix this issue first, then refactor these logic to fit existing API once
and for all.
 
> You can try and convince netdev maintainers to merge the code despite
> our request.

That's not my purpose to recklessly merge this patch. I appreciate that
you can tell me existing APIs are available. So I listened to everyone
and decided to go with a compromise, fix it first, then refactor. 

Thanks for your advice.

Tony Lu
