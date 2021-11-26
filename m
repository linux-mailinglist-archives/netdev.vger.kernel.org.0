Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B974F45E544
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 03:39:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357817AbhKZClR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 21:41:17 -0500
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:54941 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1357966AbhKZCjQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 21:39:16 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0UyKa2w-_1637894161;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0UyKa2w-_1637894161)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 26 Nov 2021 10:36:02 +0800
Date:   Fri, 26 Nov 2021 10:36:01 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net v2] net/smc: Don't call clcsock shutdown twice when
 smc shutdown
Message-ID: <YaBIEUO0eOUNqf0b@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <20211125132431.23264-1-tonylu@linux.alibaba.com>
 <1a7b27ec-22fc-f1b0-6b7c-4a61c072ff38@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1a7b27ec-22fc-f1b0-6b7c-4a61c072ff38@linux.ibm.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 25, 2021 at 03:51:06PM +0100, Karsten Graul wrote:
> On 25/11/2021 14:24, Tony Lu wrote:
> > @@ -2398,7 +2400,12 @@ static int smc_shutdown(struct socket *sock, int how)
> >  	}
> >  	switch (how) {
> >  	case SHUT_RDWR:		/* shutdown in both directions */
> > +		old_state = sk->sk_state;
> >  		rc = smc_close_active(smc);
> > +		if (old_state == SMC_ACTIVE &&
> > +		    sk->sk_state == SMC_PEERCLOSEWAIT1)
> > +			do_shutdown = false;
> > +
> >  		break;
> 
> Please send a v3 without the extra empty line before the break statement,
> and then the patch is fine with me.
> 
> Thank you!

I will fix it, and send it out soon.

Thanks,
Tony Lu
