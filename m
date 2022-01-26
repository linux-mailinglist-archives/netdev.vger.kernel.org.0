Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4771D49C43B
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 08:23:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237729AbiAZHX1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 02:23:27 -0500
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:40866 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237725AbiAZHX0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 02:23:26 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V2uVFRL_1643181803;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0V2uVFRL_1643181803)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 26 Jan 2022 15:23:24 +0800
Date:   Wed, 26 Jan 2022 15:23:22 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     kgraul@linux.ibm.com, kuba@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: Re: [RFC PATCH net-next 0/6] net/smc: Spread workload over multiple
 cores
Message-ID: <YfD26mhGkM9DFBV+@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <20220114054852.38058-1-tonylu@linux.alibaba.com>
 <YePesYRnrKCh1vFy@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YePesYRnrKCh1vFy@unreal>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 16, 2022 at 11:00:33AM +0200, Leon Romanovsky wrote:
> 
> Please CC RDMA mailing list next time.
> 
> Why didn't you use already existed APIs in drivers/infiniband/core/cq.c?
> ib_cq_pool_get() will do most if not all of your open-coded CQ spreading
> logic.

I am working on replacing with ib_cq_pool_get(), this need ib_poll_context
to indicate the poller which provides by ib_poll_handler(). It's okay
for now, but for the callback function. When it polled a ib_wc, it
would call wc->wr_cqe->done(cq, wc), which is the union with wr_id. The
wr_id is heavily used in SMC.

In this patch set, I am not going to change the logic which is out of cq
allocation. So I have to use original interface to allocate cq this
time.

I am glad to hear your advice, if I missed information or misunderstood.

Thanks,
Tony Lu
