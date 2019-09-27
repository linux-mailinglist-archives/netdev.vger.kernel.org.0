Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 047C0BFD92
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 05:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728960AbfI0DQi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 23:16:38 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:38798 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727796AbfI0DQh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 23:16:37 -0400
Received: by mail-io1-f68.google.com with SMTP id u8so12494688iom.5;
        Thu, 26 Sep 2019 20:16:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=nhpJmmCWFxguq4INCKuRzsW/NZW8MQkE7UQnGQjjt/M=;
        b=TEQHGUIn5IwSIH88Gk1uKeAKCnWEDBX12tILcuFeCc1hNCKTxO7Co8ld4YXMOYAEdV
         ogoV55AMv67TaHERxDzINpLCi+zlqGDg7nbyAO2KWkrEuJTfudoNWK1ufhj9egXWAzHO
         o0iAyEggI8za8j1TNWBq5ZZC4A9iN9Lq/UekBImyPPwrVhp2w/eYGZjogBs29hFLrfjA
         SfNnBh/tBfer5HWnjS6Tzox0cjQ5/kCP6AmmDrFr2trIojLUZ+/VdZ6QDu9xot/nhgOx
         tIzkN+8e/69+e1frwCscHojt3zi+7L4KSJj2+C9FgjfyZvqmH9m8Nw9O8UaDMv9COL2P
         3XYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=nhpJmmCWFxguq4INCKuRzsW/NZW8MQkE7UQnGQjjt/M=;
        b=cJB7Dxt5aLX2hMLUK0K+WQh7i9NXakFQsPlx1i62VbggjfH47Jw+VpzlE3vStxl23o
         NFn/PSq/4CJSZU/z9WiXrva6ZMYMwLtZMCliQvOd3EXa5gb31/AWLtiL99xXF7wkEU5o
         oSx9HlvlRmdSVzZEJxVyfsULTSoGbK4HhK72u5EcVF2GZAfggBoisAc6nI2onnPHyxUY
         SuBVyGMqs/bq2DrEpjB1d478T3s4PjDYGG/iH+qibPAS2zK4O+F8h+Fmqpfs9NcNIb5N
         jjiCC4YpQEn5TxNMp5eCDjYtwC+zoxL7gBjhZ7+75bmZdYJbFuRgdi/qA3EQM//NOPq4
         QbiA==
X-Gm-Message-State: APjAAAWX9DDbaOiAh+EXpHJqlnTnvK+S8EX2HWYkS+Xbgy/K3Eut1yNT
        0aR1f0q2E12YvQFjJB8qTXwgzAiB5wQ=
X-Google-Smtp-Source: APXvYqzLskxgI6QmLIt/OfvRZP+gdbFZt829hTPYdLsQ5y8EO03M1gsC1GffoRzk6N0sp5dVQfuUVA==
X-Received: by 2002:a92:1603:: with SMTP id r3mr2353189ill.243.1569554195338;
        Thu, 26 Sep 2019 20:16:35 -0700 (PDT)
Received: from cs-dulles.cs.umn.edu (cs-dulles.cs.umn.edu. [128.101.35.54])
        by smtp.gmail.com with ESMTPSA id i26sm1803849iol.84.2019.09.26.20.16.34
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 26 Sep 2019 20:16:35 -0700 (PDT)
Date:   Thu, 26 Sep 2019 22:16:32 -0500
From:   Navid Emamdoost <navid.emamdoost@gmail.com>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     emamd001@umn.edu, smccaman@umn.edu, kjlu@umn.edu,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: qrtr: fix memory leak in qrtr_tun_read_iter
Message-ID: <20190927031632.GG22969@cs-dulles.cs.umn.edu>
References: <20190925230416.20126-1-navid.emamdoost@gmail.com>
 <20190925232112.GR26530@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190925232112.GR26530@ZenIV.linux.org.uk>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 26, 2019 at 12:21:12AM +0100, Al Viro wrote:
> On Wed, Sep 25, 2019 at 06:04:13PM -0500, Navid Emamdoost wrote:
> > In qrtr_tun_read_iter we need an error handling path to appropriately
> > release skb in cases of error.
> 
> Release _what_ skb?
It is not a leak clearly! My bad ...
> 
> > Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
> > ---
> >  net/qrtr/tun.c | 13 +++++++++----
> >  1 file changed, 9 insertions(+), 4 deletions(-)
> > 
> > diff --git a/net/qrtr/tun.c b/net/qrtr/tun.c
> > index e35869e81766..0f6e6d1d2901 100644
> > --- a/net/qrtr/tun.c
> > +++ b/net/qrtr/tun.c
> > @@ -54,19 +54,24 @@ static ssize_t qrtr_tun_read_iter(struct kiocb *iocb, struct iov_iter *to)
> >  	int count;
> >  
> >  	while (!(skb = skb_dequeue(&tun->queue))) {
> 
> The body of the loop is entered only if the loop condition has
> evaluated true.  In this case, it means that the value of
> 	!(skb = skb_dequeue(&tun->queue))
> had been true, i.e. the value of
> 	skb = skb_dequeue(&tun->queue)
> has been NULL, i.e. that skb_dequeue() has returned NULL, which had
> been copied into skb.
> 
> In other words, in the body of that loop we have skb equal to NULL.
> 
> > -		if (filp->f_flags & O_NONBLOCK)
> > -			return -EAGAIN;
> > +		if (filp->f_flags & O_NONBLOCK) {
> > +			count = -EAGAIN;
> > +			goto out;
> > +		}
> >  
> >  		/* Wait until we get data or the endpoint goes away */
> >  		if (wait_event_interruptible(tun->readq,
> > -					     !skb_queue_empty(&tun->queue)))
> > -			return -ERESTARTSYS;
> > +					     !skb_queue_empty(&tun->queue))) {
> > +			count = -ERESTARTSYS;
> > +			goto out;
> > +		}
> >  	}
> 
> The meaning of that loop is fairly clear, isn't it?  Keep looking int
> tun->queue until an skb shows up there.  If it's not immediately there,
> fail with -EAGAIN for non-blocking files and wait on tun->readq until
> some skb arrives.

Thanks for the explainations.

Navid.
