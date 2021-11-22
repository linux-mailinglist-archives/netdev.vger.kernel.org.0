Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED1E5458A9A
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 09:37:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232383AbhKVIky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 03:40:54 -0500
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:41526 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229716AbhKVIky (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 03:40:54 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0UxhWwDJ_1637570265;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0UxhWwDJ_1637570265)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 22 Nov 2021 16:37:46 +0800
Date:   Mon, 22 Nov 2021 16:37:45 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     Daxing Guo <guodaxing@huawei.com>
Cc:     netdev@vger.kernel.org, chenzhe@huawei.com,
        linux-s390@vger.kernel.org, greg@kroah.com
Subject: Re: [PATCH] net/smc: loop in smc_listen
Message-ID: <YZtW2cOyFLosjVjL@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <20211120075451.16764-1-guodaxing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211120075451.16764-1-guodaxing@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 20, 2021 at 03:54:51PM +0800, Daxing Guo wrote:
> From: Guo DaXing <guodaxing@huawei.com>
> 
> The kernel_listen function in smc_listen will fail when all the available
> ports are occupied.  At this point smc->clcsock->sk->sk_data_ready has 
> been changed to smc_clcsock_data_ready.  When we call smc_listen again, 
> now both smc->clcsock->sk->sk_data_ready and smc->clcsk_data_ready point 
> to the smc_clcsock_data_ready function.
> 
> The smc_clcsock_data_ready() function calls lsmc->clcsk_data_ready which 
> now points to itself resulting in an infinite loop.
> 
> This patch restores smc->clcsock->sk->sk_data_ready with the old value.
> 
> Signed-off-by: Guo DaXing <guodaxing@huawei.com>

It works in my testing environment, thanks.

Acked-by: Tony Lu <tonylu@linux.alibaba.com>
