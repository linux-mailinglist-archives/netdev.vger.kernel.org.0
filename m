Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B953A149CB3
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 21:08:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbgAZUH0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 15:07:26 -0500
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:47299 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726087AbgAZUH0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 15:07:26 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id C5BA9340;
        Sun, 26 Jan 2020 15:07:24 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Sun, 26 Jan 2020 15:07:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=rxpeOaTdH7L79zgNXd+OwxuC13S
        KYvqs33NWg5sZcKo=; b=HoekoDg/DJSZKJyUj+abHzQvpD6blR5lBdTl3L/gVNs
        qR6o9SIHLWBdABOPHABTaAY0r9NmRg3cX5e1F1jLzjsHC9jnUjOGwBLZLRBfUJkC
        uo0fuCCw9GgiMCnx4wFmo4EonJ8jbzQ3gfj51Hn9lGL9g561G4gopWwLhQiWbhyo
        QaOGYvlWAHk7NscxMa4xop/ePMBJ63baVj6QGX+3CyIA4BTkICugHGAhZKGoaPhk
        FGFOZFz1fNDgAy7oj8TddS5JZbW0T/JFHygRfvewpUkFDFjsKPThZe3sigjzMrGx
        tixECSNmGFSatE7bTG0lYtjE61wGryo9NTdSBv3HVEQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=rxpeOa
        TdH7L79zgNXd+OwxuC13SKYvqs33NWg5sZcKo=; b=CQgnLn6h371CbzgtjlAZz4
        qZiHLJgFbH4IbAGWmkHHtHGG7HOaRaKpvCi8Aczm51lZIJJRheeXqggx511E2IAL
        +/1sImb/Z8ExuKUHVbefy+se32cJ+dt2d60aOWk5jYK9Cd8rAlf5ofNXHC6tBuLy
        6+PX0GNnbct1X1fczalNUvgnliq0nk4/bvgd4yZY8lRSdaTbjt7mYjCQQ65Q2wKf
        J9n6g4X54KKefbY9cjo5ObTf+A1Rm77eo5/NJeWHmO4pQxC/fbWC6Ql5s+pN0RJy
        59mTh84GecmLm86cMbZEUW5fDcMNrid/PtkaAEoaGmrGrD1oADqYeKil85jUNG1Q
        ==
X-ME-Sender: <xms:e_EtXvLqV93s51ghG1e6nXsMgiOiIJCm9c98aShcdupa7YP6x4ZKWQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrfedtgddufeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeetnhgurhgv
    shcuhfhrvghunhguuceorghnughrvghssegrnhgrrhgriigvlhdruggvqeenucfkphepie
    ejrdduiedtrddvudejrddvhedtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghm
    pehmrghilhhfrhhomheprghnughrvghssegrnhgrrhgriigvlhdruggv
X-ME-Proxy: <xmx:e_EtXpl3BL5s2vXxOIa7lvHeeWilm9PVVRonlFBL09Cd2aOFuWOYjQ>
    <xmx:e_EtXgiZlaj38uDOpEi98IXnfF-0GvV9CLJoOAANfAwjRiUVeZBzLA>
    <xmx:e_EtXnpMP6N5gdAqujrK3Ix1KQO9M7xzxNdxfnQvitDgxVJYAQ6v4g>
    <xmx:fPEtXi6ises9PwIseDmUg7eGxRe9kOKEjK6NsXJyytk25XBUhQHtXA>
Received: from intern.anarazel.de (c-67-160-217-250.hsd1.ca.comcast.net [67.160.217.250])
        by mail.messagingengine.com (Postfix) with ESMTPA id 97B3630685ED;
        Sun, 26 Jan 2020 15:07:23 -0500 (EST)
Date:   Sun, 26 Jan 2020 12:07:22 -0800
From:   Andres Freund <andres@anarazel.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, io-uring <io-uring@vger.kernel.org>,
        davem@davemloft.net, netdev@vger.kernel.org, jannh@google.com
Subject: Re: [PATCH 2/4] io_uring: io_uring: add support for async work
 inheriting files
Message-ID: <20200126200722.zesl2x45tbw7nib7@alap3.anarazel.de>
References: <20191025173037.13486-1-axboe@kernel.dk>
 <20191025173037.13486-3-axboe@kernel.dk>
 <20200126101207.oqovstqfr4iddc3p@alap3.anarazel.de>
 <1f9a5869-845a-f7ca-7530-49e407602023@kernel.dk>
 <e9e79b75-9e0f-1a36-5618-e8d27e995cc1@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9e79b75-9e0f-1a36-5618-e8d27e995cc1@kernel.dk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 2020-01-26 10:17:00 -0700, Jens Axboe wrote:
> On 1/26/20 10:10 AM, Jens Axboe wrote:
> >> Unfortunately this partially breaks sharing a uring across with forked
> >> off processes, even though it initially appears to work:
> >>
> >>
> >>> +static int io_uring_flush(struct file *file, void *data)
> >>> +{
> >>> +	struct io_ring_ctx *ctx = file->private_data;
> >>> +
> >>> +	io_uring_cancel_files(ctx, data);
> >>> +	if (fatal_signal_pending(current) || (current->flags & PF_EXITING))
> >>> +		io_wq_cancel_all(ctx->io_wq);
> >>> +	return 0;
> >>> +}
> >>
> >> Once one process having the uring fd open (even if it were just a fork
> >> never touching the uring, I believe) exits, this prevents the uring from
> >> being usable for any async tasks. The process exiting closes the fd,
> >> which triggers flush. io_wq_cancel_all() sets IO_WQ_BIT_CANCEL, which
> >> never gets unset, which causes all future async sqes to be be
> >> immediately returned as -ECANCELLED by the worker, via io_req_cancelled.
> >>
> >> It's not clear to me why a close() should cancel the the wq (nor clear
> >> the entire backlog, after 1d7bb1d50fb4)? Couldn't that even just be a
> >> dup()ed fd? Or a fork that immediately exec()s?
> >>
> >> After rudely ifdefing out the above if, and reverting 44d282796f81, my
> >> WIP io_uring using version of postgres appears to pass its tests - which
> >> are very sparse at this point - again with 5.5-rc7.
> > 
> > We need to cancel work items using the files from this process if it
> > exits, but I think we should be fine not canceling all work. Especially
> > since thet setting of IO_WQ_BIT_CANCEL is a one way street...  I'm assuming
> > the below works for you?
> 
> Could be even simpler, for shared ring setup, it also doesn't make any sense
> to flush the cq ring on exit.
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index e5b502091804..e54556b0fcc6 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -5044,10 +5044,6 @@ static int io_uring_flush(struct file *file, void *data)
>  	struct io_ring_ctx *ctx = file->private_data;
>  
>  	io_uring_cancel_files(ctx, data);
> -	if (fatal_signal_pending(current) || (current->flags & PF_EXITING)) {
> -		io_cqring_overflow_flush(ctx, true);
> -		io_wq_cancel_all(ctx->io_wq);
> -	}
>  	return 0;
>  }

Yea, that's what I basically did locally, and it seems to work for my
uses.


It took me quite a while to understand why I wasn't seeing anything
actively causing requests inside the workqueue being cancelled, but
submissions to it continuing to succeed.  Wonder if it's a good idea to
continue enqueing new jobs if the WQ is already cancelled. E.g. during
release, afaict the sqpoll thread is still running, and could just
continue pumping work into the wq?  Perhaps the sqthread (and the enter
syscall? Not sure if possible) need to stop submitting once the ring is
being closed.


Btw, one of the reasons, besides not being familiar with the code, it
took me a while to figure out what was happening, is that the flags for
individual wqes and the whole wq are named so similarly. Generally, for
the casual reader, the non-distinctive naming of the different parts
makes it somewhat hard to follow along. Like which part is about sq
offload (sqo_mm one might think, but its also used for sync work I
believe), which about the user-facing sq, which about the workqueue,
etc.

Greetings,

Andres Freund
