Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E553A10364
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 01:42:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727012AbfD3Xmo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 19:42:44 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:37095 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726086AbfD3Xmo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Apr 2019 19:42:44 -0400
Received: by mail-pg1-f194.google.com with SMTP id e6so7579703pgc.4;
        Tue, 30 Apr 2019 16:42:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ry7tbWIJBK9Hf7LIqKMAwHqMDwQA5WOsikziPF9zW00=;
        b=qMLOPFCnndch3BcwtbTSRIveKdoxKzr6c2J4wNeHlXZk0Zehr7dB/B/PyzcL29w6zj
         WKVgcG0RSDO2ZCsxisxMw+CNK7eY7Vo/ZIj2rvCYo2lUcNwxVVESGVWrhXwrLhP5gUS1
         rdv5pv9iXQJR2NjFNoSCOPufM8J8/eBedl2GiKW7yy5PvJm7XHYFa/h3+p+NlUBMhsig
         aQ23HVJ5PbocFP6beCY8Ae5mPr9O2MgWCzLuDw4VLU4DQSZys64qzAT5E+5/8IduV1yd
         EqzqveCGFY2QWQmlE5z9nEQ7hxN6FJH5RakHFPXC4CFn1uozV6jMKI/6zvc38aYTjePS
         eQAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ry7tbWIJBK9Hf7LIqKMAwHqMDwQA5WOsikziPF9zW00=;
        b=CWswZvjYBWX6AoUp0qezvHDeV/TPXEhUYTp+KXTfgl71CZ8X6aEG9EvfygqduEDXyc
         bZl6eOOdJi6YrTJm6SZQ8OZyLOCK3+HkDjgRUR52iov5HDMvUwcR/iCNidO8QItSPXVR
         6JKY7mHZKL+ex4U15W/4e6kDNgmzATOk3xKQ5Fj5A5rpRh373HuPDJImnm+0HkPn6PSz
         ybyKHztOVS7egzEx9Fu34o0f6Y4qL+0KxznBFGUEFaQAVxLMEPzqrbR/ikPCIoDCNrcb
         8++6eeYqChMeh3k2+nGKcSSEm0hdt61nte2TcbzFwXOvrcB7enU7KroGyoRF5K2nx7kQ
         GQ2w==
X-Gm-Message-State: APjAAAWiQCQ4Oymv0v8T3nMF9DPYuMmju+Q198gjFgvNt0lj1q9s8rMx
        BYESeMbsZEfrxyj+nGBFZ6zABlUABFmfVQIrUvI=
X-Google-Smtp-Source: APXvYqwacrh2slPEFiUQM77AsbP5zFjDcSs/QvCDBs7gclIpUDjLLyNOTSSCCTYiv3dfG4LwkzXdI46WHFJBH3olu0Y=
X-Received: by 2002:a63:6604:: with SMTP id a4mr38321480pgc.104.1556667763280;
 Tue, 30 Apr 2019 16:42:43 -0700 (PDT)
MIME-Version: 1.0
References: <71250616-36c1-0d96-8fac-4aaaae6a28d4@redhat.com>
 <20190428030539.17776-1-yuehaibing@huawei.com> <20190429105422-mutt-send-email-mst@kernel.org>
 <CAM_iQpWvp2i6iOZtSPskqU_uXHL2zKfM_cS1rGTh_T0r3BwvnA@mail.gmail.com> <6AADFAC011213A4C87B956458587ADB4021FE16C@dggeml532-mbs.china.huawei.com>
In-Reply-To: <6AADFAC011213A4C87B956458587ADB4021FE16C@dggeml532-mbs.china.huawei.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 30 Apr 2019 16:42:31 -0700
Message-ID: <CAM_iQpXbQ4X+ohmNFy79D+MPu6remA7hU0DTTypS=Yt+BCxujA@mail.gmail.com>
Subject: Re: [PATCH] tun: Fix use-after-free in tun_net_xmit
To:     "weiyongjun (A)" <weiyongjun1@huawei.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        yuehaibing <yuehaibing@huawei.com>,
        David Miller <davem@davemloft.net>,
        Jason Wang <jasowang@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        "Li,Rongqing" <lirongqing@baidu.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Chas Williams <3chas3@gmail.com>,
        "wangli39@baidu.com" <wangli39@baidu.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 29, 2019 at 10:11 PM weiyongjun (A) <weiyongjun1@huawei.com> wrote:
> This patch should not work. The key point is that when detach the queue
> with index is equal to tun->numqueues - 1, we do not clear the point
> in tun->tfiles:
>
> static void __tun_detach(...)
> {
> ...
>         **** if index == tun->numqueues - 1, nothing changed ****
>         rcu_assign_pointer(tun->tfiles[index],
>                                                 tun->tfiles[tun->numqueues - 1]);
> ....
> }


This is _perfectly_ fine. This is just how we _unpublish_ it, RCU is NOT
against unpublish, you keep missing this point.

Think about list_del_rcu(). RCU readers could still read the list entry
even _after_ list_del_rcu(), this is perfectly fine, list_del_rcu() just
unpublishes the list entry from a global list, kfree_rcu() is the one frees
it. So, RCU readers never hate "unpublish", they just hate "free".


>
> And after tfile free, xmit have change to get and use the freed file point.

With SOCK_RCU_FREE, it won't be freed until the last reader is gone.
This is the fundamental of RCU.

Please, at least look into sk_destruct().

Thanks.
