Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C30EF49DD99
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 10:15:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231691AbiA0JOt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 04:14:49 -0500
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:33608 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238417AbiA0JOj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 04:14:39 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0V2zNxYh_1643274875;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0V2zNxYh_1643274875)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 27 Jan 2022 17:14:36 +0800
Date:   Thu, 27 Jan 2022 17:14:35 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, kgraul@linux.ibm.com,
        kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: Re: [RFC PATCH net-next 0/6] net/smc: Spread workload over multiple
 cores
Message-ID: <YfJieyROaAKE+ZO0@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <20220114054852.38058-1-tonylu@linux.alibaba.com>
 <YePesYRnrKCh1vFy@unreal>
 <YfD26mhGkM9DFBV+@TonyMac-Alibaba>
 <20220126152806.GN8034@ziepe.ca>
 <YfIOHZ7hSfogeTyS@TonyMac-Alibaba>
 <YfI50xqsv20KDpz9@unreal>
 <YfJQ6AwYMA/i4HvH@TonyMac-Alibaba>
 <YfJcDfkBZfeYA1Z/@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YfJcDfkBZfeYA1Z/@unreal>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 27, 2022 at 10:47:09AM +0200, Leon Romanovsky wrote:
> On Thu, Jan 27, 2022 at 03:59:36PM +0800, Tony Lu wrote:
> > 
> > Yes, I agree with you that the code is old. I think there are two
> > problems, one for performance issue, the other one for API refactor.
> > 
> > We are running into the performance issues mentioned in patches in our
> > cloud environment. So I think it is more urgent for a real world issue.
> > 
> > The current modification is less intrusive to the code. This makes
> > changes simpler. And current implement works for now, this is why I put
> > refactor behind.
> 
> We are not requesting to refactor the code, but properly use existing
> in-kernel API, while implementing new feature ("Spread workload over
> multiple cores").

Sorry for that if I missed something about properly using existing
in-kernel API. I am not sure the proper API is to use ib_cq_pool_get()
and ib_cq_pool_put()?

If so, these APIs doesn't suit for current smc's usage, I have to
refactor logic (tasklet and wr_id) in smc. I think it is a huge work
and should do it with full discussion.

Thanks,
Tony Lu
