Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBE5346B174
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 04:23:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234043AbhLGD0h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 22:26:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233915AbhLGD0h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 22:26:37 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4DB5C061746
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 19:23:07 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id y12so51005151eda.12
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 19:23:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=knslmANvZrVffQMufdYJiKZFqv0/JY/mnlrHYX6OLO0=;
        b=MRPUC8AGEvSDFoHPuLLJrLe+fbCW2HkReygH9dQLJkGhSKhKETXy52AmGViu3XSNmM
         zU6BMYqajtPiqDis1Kf12RlkfojbnL48tDnetWmfaSoNTEe6IHwbUVkBCKdOb5Ys4uNp
         H32tsFWA9O0TIA2tYXQSpPQ7U/BguVe+A9YMg6y3KJjqu7h8vqrphQJHlYoq8XTQzOLh
         ysmSpMGqGI9lSZNU4Qou3H3FGZ0Xpleb8DFC/9RQ7oMBrUbjtyBRZHfl5oQKw4Aey9Wv
         OTAxX4anZEukyUdKIm6gRx7Q4PgwdEZ2vDgnkB+cgqeKuickarRHJl9EY3LKHcWzHOEw
         rSsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=knslmANvZrVffQMufdYJiKZFqv0/JY/mnlrHYX6OLO0=;
        b=L2mZh/E+nRm/+WI+8N6wpQexfeebziUhz5VOwab5ilUr7R4Y6NhP6tMqeYwsH6Kt57
         13wosER7AUOLvaJy2qjezI9nLt+ra+Ov4U+BXqBQXJ0ZswfJxyfePPBeeCAsvHPWt90N
         UcwGVKGNUypG7ePmrw4D4KWkXiK0LiMxvGmcp2B514RZwq8GnhyQEKYc8zqW7sEwDGLB
         vQFUnYhPQhCer+iGj8dgk94aSRJx2J6TuO5HJoBekmJ9fgRy6HW68dWuoNNe4eMAiEyW
         WyHRq5C4521vSW3AAsmp9q6UPZ9T0AA5QTWWfyEloNb3fDyWari4x5l+VESkJcpP6e02
         vCcg==
X-Gm-Message-State: AOAM533ZM37e6/7Lt2FvOY6qTZFziPqe4kYSMDqy4wOFydodALip7Sc0
        g3d3wHW9XAC+sjTdBDxnLtxOu+MZ0MhnT7RUQjg/FnAwuh2J9A==
X-Google-Smtp-Source: ABdhPJyDK1aR3/m+kqQkvmZapX+onCNNf5w1fYxaH/0PH/i36vJ7rZ7FOTLA0Moz5hJ5OyzVzZAcP/X/hEkgXeg8jWY=
X-Received: by 2002:a17:907:3f19:: with SMTP id hq25mr48183532ejc.225.1638847386382;
 Mon, 06 Dec 2021 19:23:06 -0800 (PST)
MIME-Version: 1.0
References: <20211206080512.36610-1-xiangxia.m.yue@gmail.com>
 <20211206080512.36610-2-xiangxia.m.yue@gmail.com> <20211206124001.5a264583@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAMDZJNVnvAXfqFSah4wgXri1c3jnQhxCdBVo41uP37e0L3BUAg@mail.gmail.com> <20211206183301.50e44a41@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211206183301.50e44a41@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Tue, 7 Dec 2021 11:22:28 +0800
Message-ID: <CAMDZJNUwWnq9+d_2a3UatfxKz3+gjDo3GLftgOE9-=3-smA8BQ@mail.gmail.com>
Subject: Re: [net-next v1 1/2] net: sched: use queue_mapping to pick tx queue
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Paolo Abeni <pabeni@redhat.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kevin Hao <haokexin@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Kees Cook <keescook@chromium.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Antoine Tenart <atenart@kernel.org>,
        Wei Wang <weiwan@google.com>, Arnd Bergmann <arnd@arndb.de>,
        Alexander Duyck <alexander.duyck@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 7, 2021 at 10:33 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 7 Dec 2021 10:10:22 +0800 Tonghao Zhang wrote:
> > > In general recording the decision in the skb seems a little heavy
> > > handed. We just need to carry the information from the egress hook
> > > to the queue selection a few lines below. Or in fact maybe egress
> > Yes, we can refactor netdev_core_pick_tx to
> > 1. select queue_index and invoke skb_set_queue_mapping, but don't
> > return the txq.
> > 2. after egress hook, use skb_get_queue_mapping/netdev_get_tx_queue to get txq.
>
> I'm not sure that's what I meant, I meant the information you need to
> store does not need to be stored in the skb, you can pass a pointer to
> a stack variable to both egress handling and pick_tx.
Thanks, I got it. I think we store the txq index in skb->queue_mapping
better. because in egress hook,
act_skbedit/act_bpf can change the skb queue_mapping. Then we can
pick_tx depending on queue_mapping.

> > > hook shouldn't be used for this in the first place, and we need
> > > a more appropriate root qdisc than simple mq?
> > I have no idea about mq, I think clsact may make the things more flexible.
> > and act_bpf can also support to change sk queue_mapping. queue_mapping
> > was included in __sk_buff.
>
> Qdiscs can run a classifier to select a sub-queue. The advantage of
> the classifier run by the Qdisc is that it runs after pick_tx.
Yes, we should consider the qdisc lock too. Qdisc lock may affect
performance and latency when running a classifier in Qdisc
and clsact is outside of qdisc.


-- 
Best regards, Tonghao
