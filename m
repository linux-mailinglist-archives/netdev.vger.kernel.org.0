Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC1310E273
	for <lists+netdev@lfdr.de>; Sun,  1 Dec 2019 17:01:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727059AbfLAQBv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Dec 2019 11:01:51 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:35226 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726393AbfLAQBv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Dec 2019 11:01:51 -0500
Received: by mail-lj1-f194.google.com with SMTP id j6so28062447lja.2
        for <netdev@vger.kernel.org>; Sun, 01 Dec 2019 08:01:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YpO6XDrp0yXWxHymhCG2SwW96NEehhPc30x8g8p0LbA=;
        b=FzOMWLHT/QyzwLSX1lfK8qlsbkXgWWYi2xJRhplAnWB/uEnYZ9ZZcLgxsuDuS4qJ7a
         SfYFx0sUVLzvw8utx+utYnT41g8kiLdMBDp/AHNZFKLuKnWXwqkw9aNdbVZiGPbW1py8
         GdCLJcZowe4mMOObkXfWm7EfRvrd/JAtlikN+0A/5bRZQrQvXNKo9t56pkmHJ0l4hO6N
         B21Q011I9Y/0HGEADGQMvwhD5bEJdUVLlw4FE0LOo8TeLrI7QvjK3xoUhHsImQcwQ1nA
         l5mTD8qyuwAd6nTa5goghR6ZG7RuB6av+LVXG44tTsbHQop2pd4Uys6DfHvYB19zKHLJ
         OgvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YpO6XDrp0yXWxHymhCG2SwW96NEehhPc30x8g8p0LbA=;
        b=FIPAh+G+AQXwwaBTcOLoQ2MoabrBGhgELnRGLTHbD4WkbxyBiSi/rq1033kdkFRyZE
         JDlkiA9At8HB0PuaBYJNzaJXCjpEJ0TE1/56akJU3AXyq5AYQfKR5xyEPE3y9xyFqrRt
         EV+algz1xMebVbkn9go/zSHJA1PXVlSd3a46FjGep3AB2vNKmlVWWEmBtGo5WLGOGElm
         Lkn/uraJumm8v54FG5mLxskhit7ROEfPPJqCR8zPZg1vG3weaS3fyUYRzybv7fHQi6VM
         SAu9TLQlkvzAd2E53sI8ICM0lDIFfPmLs+t949ULD9aulxP6tHM3ArkXG4YADd/w4TxK
         DIoA==
X-Gm-Message-State: APjAAAUdZ5ToJ3X0Dgc0y6jVUs7jlSTpileVbZpDiM2/0NQAqzn5t4ff
        1aZngmoSPSz/IA0RJl9saoc6IDILzljsxaY8lfwMuD9Z
X-Google-Smtp-Source: APXvYqz3bmPjSRQCPCwPPclchiHzG1mpq+D0yKVZwIxKSXyLmSFSg4DzMLmLsoyX0Kz4bZwhRPkbjX7DLbkTvPbWCss=
X-Received: by 2002:a2e:9758:: with SMTP id f24mr43988351ljj.105.1575216109318;
 Sun, 01 Dec 2019 08:01:49 -0800 (PST)
MIME-Version: 1.0
References: <20191130142400.3930-1-ap420073@gmail.com> <CAM_iQpWmwreeCuOVnTTucHcXkmLP-QRtzW22_g6QWM2-QoS5WA@mail.gmail.com>
In-Reply-To: <CAM_iQpWmwreeCuOVnTTucHcXkmLP-QRtzW22_g6QWM2-QoS5WA@mail.gmail.com>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Mon, 2 Dec 2019 01:01:38 +0900
Message-ID: <CAMArcTXCXYw08MuJgCot5p7cXXtUbuHej+wxONe78tDCD2_PPA@mail.gmail.com>
Subject: Re: [net PATCH] hsr: fix a NULL pointer dereference in hsr_dev_xmit()
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        treeze.taeung@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 1 Dec 2019 at 03:36, Cong Wang <xiyou.wangcong@gmail.com> wrote:
>

Hi Cong,
Thank you for the review!

> On Sat, Nov 30, 2019 at 6:24 AM Taehee Yoo <ap420073@gmail.com> wrote:
> >
> > hsr_dev_xmit() calls hsr_port_get_hsr() to find master node and that would
> > return NULL if master node is not existing in the list.
> > But hsr_dev_xmit() doesn't check return pointer so a NULL dereference
> > could occur.
>
> If you look at the git history, I made a same patch but reverted it later. :)
>

Yes, you already made the same patch and reverted.

>
> >
> > In the TX datapath, there is no rcu_read_lock() so this patch adds missing
> > rcu_read_lock() in the hsr_dev_xmit() too.
>
> This is wrong.
>

I thought hsr_dev_xmit() needs rcu_read_lock() because hsr_port_get_hsr() and
hsr_forward_skb() should be called under rcu_read_lock().
Could you let me know about the reason?

>
> >
> > Test commands:
> >     ip netns add nst
> >     ip link add v0 type veth peer name v1
> >     ip link add v2 type veth peer name v3
> >     ip link set v1 netns nst
> >     ip link set v3 netns nst
> >     ip link add hsr0 type hsr slave1 v0 slave2 v2
> >     ip a a 192.168.100.1/24 dev hsr0
> >     ip link set v0 up
> >     ip link set v2 up
> >     ip link set hsr0 up
> >     ip netns exec nst ip link add hsr1 type hsr slave1 v1 slave2 v3
> >     ip netns exec nst ip a a 192.168.100.2/24 dev hsr1
> >     ip netns exec nst ip link set v1 up
> >     ip netns exec nst ip link set v3 up
> >     ip netns exec nst ip link set hsr1 up
> >     hping3 192.168.100.2 -2 --flood &
> >     modprobe -rv hsr
>
> Looks like the master port got deleted without respecting RCU
> readers, let me look into it.
>
> Thanks!

Thank you!
Taehee
