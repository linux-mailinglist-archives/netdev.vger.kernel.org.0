Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07FFD49DDE1
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 10:25:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238532AbiA0JZu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 04:25:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbiA0JZt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 04:25:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DB8EC061714;
        Thu, 27 Jan 2022 01:25:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E2A53B820FC;
        Thu, 27 Jan 2022 09:25:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2040C340E4;
        Thu, 27 Jan 2022 09:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643275545;
        bh=/TsNE9wrpevdjUVU/1n7bHxltY5w0diGCgkYNB0V404=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AptJwHAos3tNVeZx/kKj71W7Zf046QaSjw3F4BjdQZsd8Fx5J6xIwIoIKK78b0ilX
         w6fH5ry2OjCUadeKy33Oml92xXO7cuFGrlvPrAOqMTQ7MuyhH6yrjU8xDF0Mskr7rM
         x9Dm0VNyz0iC/U/l1iEBsLvm0jNVZfKWW6Iwkd5T3xNvFfhUTnJmssbbN56mky+jpM
         0TL4ghJ90UVvrMI9os2U5qg0T/vkUkT3oQY+qQopFLoe31Kr2XlqECJuXu38Iu2wHp
         PY854QWWl4zAxOVD984NnKHJ9B4nO5dCVFE3egC4wv8RZFSwUtnCSykEcgajJJ4GtC
         kgnkDsKIpzhjA==
Date:   Thu, 27 Jan 2022 11:25:41 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Tony Lu <tonylu@linux.alibaba.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, kgraul@linux.ibm.com,
        kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: Re: [RFC PATCH net-next 0/6] net/smc: Spread workload over multiple
 cores
Message-ID: <YfJlFe3p2ABbzoYI@unreal>
References: <20220114054852.38058-1-tonylu@linux.alibaba.com>
 <YePesYRnrKCh1vFy@unreal>
 <YfD26mhGkM9DFBV+@TonyMac-Alibaba>
 <20220126152806.GN8034@ziepe.ca>
 <YfIOHZ7hSfogeTyS@TonyMac-Alibaba>
 <YfI50xqsv20KDpz9@unreal>
 <YfJQ6AwYMA/i4HvH@TonyMac-Alibaba>
 <YfJcDfkBZfeYA1Z/@unreal>
 <YfJieyROaAKE+ZO0@TonyMac-Alibaba>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YfJieyROaAKE+ZO0@TonyMac-Alibaba>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 27, 2022 at 05:14:35PM +0800, Tony Lu wrote:
> On Thu, Jan 27, 2022 at 10:47:09AM +0200, Leon Romanovsky wrote:
> > On Thu, Jan 27, 2022 at 03:59:36PM +0800, Tony Lu wrote:
> > > 
> > > Yes, I agree with you that the code is old. I think there are two
> > > problems, one for performance issue, the other one for API refactor.
> > > 
> > > We are running into the performance issues mentioned in patches in our
> > > cloud environment. So I think it is more urgent for a real world issue.
> > > 
> > > The current modification is less intrusive to the code. This makes
> > > changes simpler. And current implement works for now, this is why I put
> > > refactor behind.
> > 
> > We are not requesting to refactor the code, but properly use existing
> > in-kernel API, while implementing new feature ("Spread workload over
> > multiple cores").
> 
> Sorry for that if I missed something about properly using existing
> in-kernel API. I am not sure the proper API is to use ib_cq_pool_get()
> and ib_cq_pool_put()?
> 
> If so, these APIs doesn't suit for current smc's usage, I have to
> refactor logic (tasklet and wr_id) in smc. I think it is a huge work
> and should do it with full discussion.

This discussion is not going anywhere. Just to summarize, we (Jason and I)
are asking to use existing API, from the beginning.

You can try and convince netdev maintainers to merge the code despite
our request.

Thanks

> 
> Thanks,
> Tony Lu
