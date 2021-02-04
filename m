Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A728030FC05
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 19:56:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239468AbhBDSy5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 13:54:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:49666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238482AbhBDSyi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 13:54:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B4F7B64DE1;
        Thu,  4 Feb 2021 18:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612464837;
        bh=zLhrsQ3t0boP/eAaEbmY8Rcze1s9OVafy7KV+Tk7CrQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Z3ghuvAqq+zdbS8EvSzMw5PhYydM4BgjolpZ6p6bJPvk0PikHvX7rAyWuCE8BOsAR
         Oqrk8Q949eR6YdC3Y1sw4rQhZW8/8j+2kjmezZwxYN5Tc2MmFWykZzEryZadNkZ6oM
         XwGLMKOjOGrBtBZnKdm6vPc0c/ABpTUQ0LDSJi9a41AZKSGKvT8yFroYRtLpXJt6pN
         5ySzmeti9PZYTWKcCedlpNEKDIh0PyLt46msjdvbKPUVL3IIBFOwWZOQ9AQgrC+2zt
         C3hECIXlc/bFQWsr54VXE9kfcggSLh0z4wf1NSIOiSPp9sSZn25l9LW1OrKn1mcj7X
         7ZtXgC/Tjjayw==
Date:   Thu, 4 Feb 2021 10:53:56 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org,
        syzbot+c2a7e5c5211605a90865@syzkaller.appspotmail.com
Subject: Re: [PATCH] net/qrtr: replaced useless kzalloc with kmalloc in
 qrtr_tun_write_iter()
Message-ID: <20210204105356.3f41b3e2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210204105159.2ae254b2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210203162846.56a90288@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210204090230.1794169-1-snovitoll@gmail.com>
        <20210204105159.2ae254b2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 4 Feb 2021 10:51:59 -0800 Jakub Kicinski wrote:
> On Thu,  4 Feb 2021 15:02:30 +0600 Sabyrzhan Tasbolatov wrote:
> > Replaced kzalloc() with kmalloc(), there is no need for zeroed-out
> > memory for simple void *kbuf.  
> 
> There is no need for zeroed-out memory because it's immediately
> overwritten by copy_from_iter...

Also if you don't mind please wait a week until the fixes get merged
back into net-next and then repost. Otherwise this patch will not apply
cleanly. (Fixes are merged into a different tree than cleanups)

> > Signed-off-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
> > ---
> >  net/qrtr/tun.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/net/qrtr/tun.c b/net/qrtr/tun.c
> > index b238c40a9984..9b607c7614de 100644
> > --- a/net/qrtr/tun.c
> > +++ b/net/qrtr/tun.c
> > @@ -86,7 +86,7 @@ static ssize_t qrtr_tun_write_iter(struct kiocb *iocb, struct iov_iter *from)
> >  	if (len > KMALLOC_MAX_SIZE)
> >  		return -ENOMEM;
> >  
> > -	kbuf = kzalloc(len, GFP_KERNEL);
> > +	kbuf = kmalloc(len, GFP_KERNEL);
> >  	if (!kbuf)
> >  		return -ENOMEM;
> >    
> 

