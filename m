Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 444D1459A57
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 04:04:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231785AbhKWDHI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 22:07:08 -0500
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:42235 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229628AbhKWDHH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 22:07:07 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R441e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0UxpkTqL_1637636637;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0UxpkTqL_1637636637)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 23 Nov 2021 11:03:58 +0800
Date:   Tue, 23 Nov 2021 11:03:57 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     kuba@kernel.org, davem@davemloft.net, guwen@linux.alibaba.com,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH RFC net] net/smc: Ensure the active closing peer first
 closes clcsock
Message-ID: <YZxaHVHTg5cxnarY@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <20211116033011.16658-1-tonylu@linux.alibaba.com>
 <9af1f859-0299-d1d7-d5ce-af46cf102025@linux.ibm.com>
 <12d0d06b-8337-401e-fb87-e9c4e423cc11@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12d0d06b-8337-401e-fb87-e9c4e423cc11@linux.ibm.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 22, 2021 at 05:47:43PM +0100, Karsten Graul wrote:
> On 17/11/2021 17:19, Karsten Graul wrote:
> > On 16/11/2021 04:30, Tony Lu wrote:
> >> We found an issue when replacing TCP with SMC. When the actively closed
> >> peer called close() in userspace, the clcsock of peer doesn't enter TCP
> >> active close progress, but the passive closed peer close it first, and
> >> enters TIME_WAIT state. It means the behavior doesn't match what we
> >> expected. After reading RFC7609, there is no clear description of the
> >> order in which we close clcsock during close progress.
> > 
> > Thanks for your detailed description, it helped me to understand the problem.
> > Your point is that SMC sockets should show the same behavior as TCP sockets
> > in this situation: the side that actively closed the socket should get into
> > TIME_WAIT state, and not the passive side. I agree with this.
> > Your idea to fix it looks like a good solution for me. But I need to do more
> > testing to make sure that other SMC implementations (not Linux) work as
> > expected with this change. For example, Linux does not actively monitor the 
> > clcsocket state, but if another implementation would do this it could happen
> > that the SMC socket is closed already when the clcsocket shutdown arrives, and
> > pending data transfers are aborted.
> > 
> > I will respond to your RFC when I finished my testing.
> > 
> > Thank you.
> > 
> 
> Testing and discussions are finished, the patch looks good.
> Can you please send your change as a patch to the mailing list?

Thanks for your advice and testing. I will send it soon.

Cheers,
Tony Lu
