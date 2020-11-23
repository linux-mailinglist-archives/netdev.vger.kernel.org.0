Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7070A2C0CA8
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 15:14:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729462AbgKWOBE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 09:01:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729372AbgKWOBB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 09:01:01 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FB03C0613CF;
        Mon, 23 Nov 2020 06:01:01 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id 18so8872786pli.13;
        Mon, 23 Nov 2020 06:01:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kTzAwGnKctQP6f8k4mc+aVTNiIF28i6q0wCQZdb9TIQ=;
        b=hzVDgoB/C4oCV5aKdslaJu2N+g9Q9d002IloasUd8GbE1Jvmm8w+D0sl07Jmw8TvqS
         OMaWK4JoIe+9TvZ7w1XaH1c2zUubPwwrCVGmovVqE73YdvCQm14BsFI9QFhdtHYKEtZn
         SvXZzykNEljNWrRwwbtQANRdla2V6JiguVQo/7/TNUOMDimtbhXlgtJZzBbL7ECrEkGh
         Vf7NDk3Ldsbt+q4JAhhI9l7NqTcb33LwRvl0O4fPThQCuvZ+2mQMs4pQW/8uDTUv7r7N
         DIcJIdd2dz6Jl96XLJ5bCRa7J0fezcdIowEsdtElYAtIWkfHz+pGsDYtIeo49CUMo2NE
         8y1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kTzAwGnKctQP6f8k4mc+aVTNiIF28i6q0wCQZdb9TIQ=;
        b=jZD4l2J0orwhxCqGubMUxRcgn7vKSSkzsGn33yUkxeGcNIMBOgYQzs8mYSdjaNGi4v
         i8g7uhC1wtX6kXMEXRWK2izKgBow8WJEYh2haJT3JldZ0pZxkE8aeUehnoFJP6NSay/n
         mRje9k4GgRcikJ/hgZAzQMnSQBd++xrOr/WVCyWwJItbPwTzPWg0S6jZJ0ULj3blA6p2
         5QTJtVWjnms0OKy5veWlNdtr9VNe+kZvNNN9Yi2jf2A+h4L94mnaZlR/y8cB9XVU1OTs
         s4Kw+Zq7JZBFuq9GbnBqxLfdE5VmInyDMk5uGku6ecyqUEco6/fYdxh1eqYX2Ah6N6+J
         XPkg==
X-Gm-Message-State: AOAM530iwW6uOG0ivoYZeD5xs5fYiTdNDYbOgWdzwqFmWMexmr9ZkCOb
        KfEnIWrTa1jSk4xW18QnZrEOSzbhHGt4HXvkClU=
X-Google-Smtp-Source: ABdhPJyS/m04iepzH+/zdL9XmL9/ST3WynYaUHAn8JSvsCr4+x4OX4zGjTvC/SwXSb6JSirwmHKC6ozm3+5dFIzXT40=
X-Received: by 2002:a17:902:bd02:b029:da:8fd:af6b with SMTP id
 p2-20020a170902bd02b02900da08fdaf6bmr4870343pls.7.1606140059409; Mon, 23 Nov
 2020 06:00:59 -0800 (PST)
MIME-Version: 1.0
References: <3306b4d8-8689-b0e7-3f6d-c3ad873b7093@intel.com> <cover.1605686678.git.xuanzhuo@linux.alibaba.com>
In-Reply-To: <cover.1605686678.git.xuanzhuo@linux.alibaba.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Mon, 23 Nov 2020 15:00:48 +0100
Message-ID: <CAJ8uoz0hEiXFY9q_HJmfuY4vpf-DYH_gnDPvRhFpnc6OcQbj_Q@mail.gmail.com>
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

On Wed, Nov 18, 2020 at 9:25 AM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
>
> I tried to combine cq available and tx writeable, but I found it very difficult.
> Sometimes we pay attention to the status of "available" for both, but sometimes,
> we may only pay attention to one, such as tx writeable, because we can use the
> item of fq to write to tx. And this kind of demand may be constantly changing,
> and it may be necessary to set it every time before entering xsk_poll, so
> setsockopt is not very convenient. I feel even more that using a new event may
> be a better solution, such as EPOLLPRI, I think it can be used here, after all,
> xsk should not have OOB data ^_^.
>
> However, two other problems were discovered during the test:
>
> * The mask returned by datagram_poll always contains EPOLLOUT
> * It is not particularly reasonable to return EPOLLOUT based on tx not full
>
> After fixing these two problems, I found that when the process is awakened by
> EPOLLOUT, the process can always get the item from cq.
>
> Because the number of packets that the network card can send at a time is
> actually limited, suppose this value is "nic_num". Once the number of
> consumed items in the tx queue is greater than nic_num, this means that there
> must also be new recycled items in the cq queue from nic.
>
> In this way, as long as the tx configured by the user is larger, we won't have
> the situation that tx is already in the writeable state but cannot get the item
> from cq.

I think the overall approach of tying this into poll() instead of
setsockopt() is the right way to go. But we need a more robust
solution. Your patch #3 also breaks backwards compatibility and that
is not allowed. Could you please post some simple code example of what
it is you would like to do in user space? So you would like to wake up
when there are entries in the cq that can be retrieved and the reason
you would like to do this is that you then know you can put some more
entries into the Tx ring and they will get sent as there now are free
slots in the cq. Correct me if wrong. Would an event that wakes you up
when there is both space in the Tx ring and space in the cq work? Is
there a case in which we would like to be woken up when only the Tx
ring is non-full? Maybe there are as it might be beneficial to fill
the Tx and while doing that some entries in the cq has been completed
and away the packets go. But it would be great if you could post some
simple example code, does not need to compile or anything. Can be
pseudo code.

It would also be good to know if your goal is max throughput, max
burst size, or something else.

Thanks: Magnus


> Xuan Zhuo (3):
>   xsk: replace datagram_poll by sock_poll_wait
>   xsk: change the tx writeable condition
>   xsk: set tx/rx the min entries
>
>  include/uapi/linux/if_xdp.h |  2 ++
>  net/xdp/xsk.c               | 26 ++++++++++++++++++++++----
>  net/xdp/xsk_queue.h         |  6 ++++++
>  3 files changed, 30 insertions(+), 4 deletions(-)
>
> --
> 1.8.3.1
>
