Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC10346B07E
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 03:11:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239608AbhLGCOa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 21:14:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235404AbhLGCOa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 21:14:30 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEB44C061746
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 18:11:00 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id v1so50776208edx.2
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 18:11:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oK+1/X5uxcMe32HVo1xDMGFp9JFb+fN4nBPis7JTxFQ=;
        b=McCNtWGHZrwuOSR7apxTxTcs6x03QZ0Is2jeO6jASSNh92TxzXIWnCg6/u0ll9iLxu
         Td+9nA6Mm2e8r/U9XowWHnblIVfrpyy9dsCQSnTzlEogzQyksLNOlihArvykz8J199so
         0PGlvZAB8P4VjsAhMAF26B6uJ7mfbAtAu3EpOAEVVQX/r6I02WkZt71KyzU9XO2DJOii
         kFWJGVdavBwz19azfQMT4Xk5qmHgC+uc5/m2mEGj0LH6NgrQ4RGTuqZ2bk0bzVrme0sU
         7jvr/h21m4p1EpXkRapreMzLUlUBPhXy0wd7qKepUQnZICBEnuTftuC1ZpLEhovK8O5A
         UDWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oK+1/X5uxcMe32HVo1xDMGFp9JFb+fN4nBPis7JTxFQ=;
        b=36vZJ+wZV8AkPZ7/GpNRZkaF5Aa0BQ4CEPwJ0bJNNy7HNi+zoRgXf7YYwbg2XqRMZB
         rrSDnsc3skermiID+bgM3rbfsPDCTrLLx9uPSck58Gyk84W6Z9AcEuBwcRKNkAdMAn01
         WwiM+q91DFy9CaFrqGvjnQ/SYvpJ2Xe4MtM/CKGtqjAXUqTdH8QxYeycCYsK+GfCibs5
         kUC5+j4zlFsdl1dHCakSDem1ZRzhPMxoc6n7uYKxtKtUd6K2TexgKnfPKJF+jaKQW7IE
         PHLYxHp/g2mmj5ZlgQ3tQllzLJLSctQIaXnh5Mys4jCcgyfw8HU/ttbLCIm5HwyJ9Mcj
         vD1g==
X-Gm-Message-State: AOAM532NOjR0VTYT6f6SwZMv6vAcqpCay970ZSj5LDL/LVtZKFYo/+ev
        xj76mxlsnj0tQnHESTb2gV86NchR1XL2ffiilCk=
X-Google-Smtp-Source: ABdhPJzG/lkfZ+LYqho3++iuDXuZF3G2G32mzNcGFghPuZ0QhxmNzNlUhZCeMiAvphRQBZ+CGdrC6xJRunKtL2uOK9Q=
X-Received: by 2002:a17:906:7009:: with SMTP id n9mr49799155ejj.431.1638843059526;
 Mon, 06 Dec 2021 18:10:59 -0800 (PST)
MIME-Version: 1.0
References: <20211206080512.36610-1-xiangxia.m.yue@gmail.com>
 <20211206080512.36610-2-xiangxia.m.yue@gmail.com> <20211206124001.5a264583@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211206124001.5a264583@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Tue, 7 Dec 2021 10:10:22 +0800
Message-ID: <CAMDZJNVnvAXfqFSah4wgXri1c3jnQhxCdBVo41uP37e0L3BUAg@mail.gmail.com>
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

On Tue, Dec 7, 2021 at 4:40 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon,  6 Dec 2021 16:05:11 +0800 xiangxia.m.yue@gmail.com wrote:
> >   +----+      +----+      +----+
> >   | P1 |      | P2 |      | Pn |
> >   +----+      +----+      +----+
> >     |           |           |
> >     +-----------+-----------+
> >                 |
> >                 | clsact/skbedit
> >                 |    MQ
> >                 v
> >     +-----------+-----------+
> >     | q0        | q1        | qn
> >     v           v           v
> >    HTB         HTB   ...   FIFO
Hi Jakub, thanks for your comments
> The usual suggestion these days is to try to use FQ + EDT to
> implement efficient policies. You don't need dedicated qdiscs,
> just modulate transmission time appropriately on egress of the
> container.
FQ+EDT is good solution. But this patch should be used on another scenario.
1. the containers  which outbound traffic is not limited, want to use
the fifo qdisc.
If this traffic share the FQ/HTB Qdisc, the qdisc lock will affect the
performance and latency.
2. we can support user to select tx queue, range from A to B. skb hash
or cgroup classid is good to do load balance.
patch 2/2: https://patchwork.kernel.org/project/netdevbpf/patch/20211206080512.36610-3-xiangxia.m.yue@gmail.com/

> In general recording the decision in the skb seems a little heavy
> handed. We just need to carry the information from the egress hook
> to the queue selection a few lines below. Or in fact maybe egress
Yes, we can refactor netdev_core_pick_tx to
1. select queue_index and invoke skb_set_queue_mapping, but don't
return the txq.
2. after egress hook, use skb_get_queue_mapping/netdev_get_tx_queue to get txq.
> hook shouldn't be used for this in the first place, and we need
> a more appropriate root qdisc than simple mq?
I have no idea about mq, I think clsact may make the things more flexible.
and act_bpf can also support to change sk queue_mapping. queue_mapping
was included in __sk_buff.

> Not sure. What I am sure of is that you need to fix these warnings:
Ok
> include/linux/skbuff.h:937: warning: Function parameter or member 'tc_skip_txqueue' not described in 'sk_buff'
>
> ERROR: spaces required around that '=' (ctx:VxW)
> #103: FILE: net/sched/act_skbedit.c:42:
> +       queue_mapping= (queue_mapping & 0xff) + hash % mapping_mod;
>                      ^
>
> ;)



-- 
Best regards, Tonghao
