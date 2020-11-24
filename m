Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CDFB2C20A2
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 10:01:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730947AbgKXJBe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 04:01:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726458AbgKXJBd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 04:01:33 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A12E1C0613CF;
        Tue, 24 Nov 2020 01:01:33 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id j19so16867287pgg.5;
        Tue, 24 Nov 2020 01:01:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OGxCRem2plcSbshMzDeeuRRkFaO8+Fvd+z+GotYkgBU=;
        b=dR6unxlx2P2VbynjJ1HysD5gwJ37BNNlaHY48ld0oGI4GzHKdSVCqWTBEF5ekUxIwk
         AAxG6AvQa2yHB7f2jMP/24+/WrQ00fFWEP1ZRavYZryvbhvRpbJQnJyWvQAYJB5B2u7m
         MXtIf9j8Q8lWiqsDZZGpbkEYhb/eZ81EePeNIBongQTvYisd8eu4CYPpWNOCsHXbQMoM
         NQE/s9oi8Qu+jiYDKuyiwMFKnHRkQluuvKXIG7W6mBO4cnNBvxACkmAneugG1y5Myqs6
         4dlU42rI95kDkc1gjLwTeFXd/rzZiGbBY7nSY8xpK49G6O26EKOA+QklIqunLPu5nsDe
         AnzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OGxCRem2plcSbshMzDeeuRRkFaO8+Fvd+z+GotYkgBU=;
        b=LypQ2OUMfxqrvI8F5lQSoOy3hZ039hhqRrGZSKt9ydLDwCTFf5Ie1jBmZvWJDd0ZLL
         5Iq3IGMWZC+9Zh5jVmEd+b6inHVgNn03J3LIL0pnA0cRO+a6voQVw7/tb8+51fsdgpuC
         OEvUMFD/5X1PAho9nLJEuvgvN5xc0Cr24grzvMObzLCOtUjvmknaanYfq5BsYTkAVnk0
         N+8g6InPnqcOE4kaS2q8Jamv5J4bCLuxn/0ThhpF8BnJ9aWuWTQ+shyZ+SiYw1UJNnS3
         SXdSgHg0XqD6H+OOOt2yrZg0ZQ9SZ3TA170s3KdTchidJMcpplbQ51wvFxWmn1OK2aIg
         99JA==
X-Gm-Message-State: AOAM532PwPlbn1mV0wYbqTE8qabLOJebxlMcay/LxBpcwOUlmWUTzArB
        R1NcfKM9Mi9/+wweAsb0JImHQ+pFe3VDgzePjbrvD40oV22D4FscJvw=
X-Google-Smtp-Source: ABdhPJwfRu2XGeqBBBx2PCSQfK2H2pK1P/kfhdAXKrSvxuwtXHIba46MdPqE1UJayQFnw87fFZ+9mFSP/mky7AZ/bnc=
X-Received: by 2002:a17:90a:4687:: with SMTP id z7mr3718398pjf.168.1606208493175;
 Tue, 24 Nov 2020 01:01:33 -0800 (PST)
MIME-Version: 1.0
References: <CAJ8uoz0hEiXFY9q_HJmfuY4vpf-DYH_gnDPvRhFpnc6OcQbj_Q@mail.gmail.com>
 <1606142229.4575405-1-xuanzhuo@linux.alibaba.com>
In-Reply-To: <1606142229.4575405-1-xuanzhuo@linux.alibaba.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Tue, 24 Nov 2020 10:01:22 +0100
Message-ID: <CAJ8uoz1yxjYyfrKkvJrjLWOzm78M2CtNVRC+GkeGRCWBq5xAYA@mail.gmail.com>
Subject: Re: [PATCH 0/3] xsk: fix for xsk_poll writeable
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 23, 2020 at 4:21 PM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
>
> On Mon, 23 Nov 2020 15:00:48 +0100, Magnus Karlsson <magnus.karlsson@gmail.com> wrote:
> > On Wed, Nov 18, 2020 at 9:25 AM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
> > >
> > > I tried to combine cq available and tx writeable, but I found it very difficult.
> > > Sometimes we pay attention to the status of "available" for both, but sometimes,
> > > we may only pay attention to one, such as tx writeable, because we can use the
> > > item of fq to write to tx. And this kind of demand may be constantly changing,
> > > and it may be necessary to set it every time before entering xsk_poll, so
> > > setsockopt is not very convenient. I feel even more that using a new event may
> > > be a better solution, such as EPOLLPRI, I think it can be used here, after all,
> > > xsk should not have OOB data ^_^.
> > >
> > > However, two other problems were discovered during the test:
> > >
> > > * The mask returned by datagram_poll always contains EPOLLOUT
> > > * It is not particularly reasonable to return EPOLLOUT based on tx not full
> > >
> > > After fixing these two problems, I found that when the process is awakened by
> > > EPOLLOUT, the process can always get the item from cq.
> > >
> > > Because the number of packets that the network card can send at a time is
> > > actually limited, suppose this value is "nic_num". Once the number of
> > > consumed items in the tx queue is greater than nic_num, this means that there
> > > must also be new recycled items in the cq queue from nic.
> > >
> > > In this way, as long as the tx configured by the user is larger, we won't have
> > > the situation that tx is already in the writeable state but cannot get the item
> > > from cq.
> >
> > I think the overall approach of tying this into poll() instead of
> > setsockopt() is the right way to go. But we need a more robust
> > solution. Your patch #3 also breaks backwards compatibility and that
> > is not allowed. Could you please post some simple code example of what
> > it is you would like to do in user space? So you would like to wake up
> > when there are entries in the cq that can be retrieved and the reason
> > you would like to do this is that you then know you can put some more
> > entries into the Tx ring and they will get sent as there now are free
> > slots in the cq. Correct me if wrong. Would an event that wakes you up
> > when there is both space in the Tx ring and space in the cq work? Is
> > there a case in which we would like to be woken up when only the Tx
> > ring is non-full? Maybe there are as it might be beneficial to fill
> > the Tx and while doing that some entries in the cq has been completed
> > and away the packets go. But it would be great if you could post some
> > simple example code, does not need to compile or anything. Can be
> > pseudo code.
> >
> > It would also be good to know if your goal is max throughput, max
> > burst size, or something else.
> >
> > Thanks: Magnus
> >
>
> My goal is max pps, If possible, increase the size of buf appropriately to
> improve throughput. like pktgen.
>
> The code like this: (tx and umem cq also is 1024, and that works with zero
> copy.)
>
> ```
> void send_handler(xsk)
> {
>     char buf[22];
>
>         while (true) {
>             while (true){
>                 if (send_buf_to_tx_ring(xsk, buf, sizeof(buf)))
>                     break; // break this when no cq or tx is full
>             }
>
>             if (sendto(xsk->fd))
>                 break;
>                 }
>         }
> }
>
>
> static int loop(int efd, xsk)
> {
>         struct epoll_event e[1024];
>         struct epoll_event ee;
>         int n, i;
>
>         ee.events = EPOLLOUT;
>         ee.data.ptr = NULL;
>
>         epoll_ctl(efd, EPOLL_CTL_ADD, xsk->fd, &e);
>
>         while (1) {
>                 n = epoll_wait(efd, e, sizeof(e)/sizeof(e[0]), -1);
>
>                 if (n == 0)
>                         continue;
>
>                 if (n < 0) {
>                         continue;
>                 }
>
>                 for (i = 0; i < n; ++i) {
>             send_handler(xsk);
>                 }
>         }
> }
> ```
>
> 1. Now, since datagram_poll(that determine whether it is write able based on
>    sock_writeable function) will return EPOLLOUT every time, epoll_wait will
>    always return directly(this results in cpu 100%).

We should keep patch #1. Just need to make sure we do not break
anything as I am not familiar with the path after xsk_poll returns.

> 2. After removing datagram_poll, since tx full is a very short moment, so every
>    time tx is not full is always true, epoll_wait will still return directly
> 3. After epoll_wait returns, app will try to get cq and writes it to tx again,
>    but this time basically it will fail when getting cq. My analysis is that
>    cq item has not returned from the network card at this time.
>
>
> Under normal circumstances, the judgment preparation for this event that can be
> written is not whether the queue or buffer is full. The judgment criterion of
> tcp is whether the free space is more than half.
> This is the origin of my #2 patch, and I found that after adding this patch, my
> above problems no longer appear.
> 1. epoll_wait no longer exits directly
> 2. Every time you receive EPOLLOUT, you can always get cq

Got it. Make sense. And good that there is some precedence that you
are not supposed to wake up when there is one free slot. Instead you
should wake up when a lot of them are free so you can insert a batch.
So let us also keep patch #2, though I might have some comments on it,
but I will reply to that patch in that case.

But patch #3 needs to go. How about you instead make the Tx ring
double the size of the completion ring? Let us assume patch #1 and #2
are in place. You will get woken up when at least half the entries in
the Tx ring are available. At this point fill the Tx ring completely
and after that start cleaning the completion ring. Hopefully by this
time, there will be a number of entries in there that can be cleaned
up. Then you call sendto(). It might even be a good idea to do cq, Tx,
cq in that order.

I consider #1 and #2 bug fixes so please base them on the bpf tree and
note this in your mail header like this: "[PATCH bpf 0/3] xsk: fix for
xsk_poll writeable".

>
> In addition:
>     What is the goal of TX_BATCH_SIZE and why this "restriction" should be added,
>     which causes a lot of trouble in programming without using zero copy

You are right, this is likely too low. I never thought of this as
something that would be used as a "fast-path". It was only a generic
fall back. But it need not be. Please produce a patch #3 that sets
this to a higher value. We do need the limit though. How about 512?

If you are interested in improving the performance of the Tx SKB path,
then there might be other avenues to try if you are interested. Here
are some examples:

* Batch dev_direct_xmit. Maybe skb lists can be used.
* Do not unlock and lock for every single packet in dev_direct_xmit().
Can be combined with the above.
* Use fragments instead of copying packets into the skb itself
* Can the bool more in netdev_start_xmit be used to increase performance

>
> Thanks.
>
> >
> > > Xuan Zhuo (3):
> > >   xsk: replace datagram_poll by sock_poll_wait
> > >   xsk: change the tx writeable condition
> > >   xsk: set tx/rx the min entries
> > >
> > >  include/uapi/linux/if_xdp.h |  2 ++
> > >  net/xdp/xsk.c               | 26 ++++++++++++++++++++++----
> > >  net/xdp/xsk_queue.h         |  6 ++++++
> > >  3 files changed, 30 insertions(+), 4 deletions(-)
> > >
> > > --
> > > 1.8.3.1
> > >
