Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3896F2D797C
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 16:35:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732784AbgLKPdk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 10:33:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729715AbgLKPc6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 10:32:58 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42D6BC0613CF;
        Fri, 11 Dec 2020 07:32:18 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id s21so7184771pfu.13;
        Fri, 11 Dec 2020 07:32:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=slsIDsd/BxRPzHFmP0Hn8ONAhqq8r+sw1t497Woapto=;
        b=P6H2jclUFrChVC1vr91qzytN+J3cccxVzQaejxl+6CuLtkdwNMMWGuitsqeyRF4iTb
         pnh7snP/33Q1ChdG0wuaPhkuEIViNViy6cWPEqzCwtYDL6F7xWN/62MswRj4fpzNS5PO
         W1hbNfLJpaovLg5scWW5BBB8ILKzM0asygeO3UDwWdyBV2dGCU3wgEsN477MPCZkcHVw
         ADi3Tsd5WrzOJo2/XpsOk+nGtTHAOlzkSD0OZjme0TORngKuulqDZz0GVLr3gSMheQLm
         uHTw8ZyBzF+7A/bc/XQVUaC8xIFaA/PP7lgJyfl9FnbU6KMfn/MX9eJFhgKU0JurgSsA
         4QcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=slsIDsd/BxRPzHFmP0Hn8ONAhqq8r+sw1t497Woapto=;
        b=XLi5QntDBBKNAUggKD0D2LKVSrMk9vZKYGbMSekkqlO/jCi8t7ObXQ3Hkt2qSy9gF6
         cv0nllG9rtGtvVQM4b++c1RN/U0qyFLffJHtwTow42hJSo0C+Qy6XvdB2TPte14eSqSM
         vYsd3aX+ljSM2FDIYAgba2T9htNIFVZqprQ2WQX3vXf/ORuhnpC/6vORC4GrN5Af8OZu
         uR/wbm+eiq7+T16utxs8JMt+2T1VAgUUzYPMbqObvHfVAvDJs1wrjTHIPdYeI6D2KP8G
         XhOxAYKpDaU41fzXB6PwnaP349ltOSg1IU1g6AAcIjnlmQRAt84o28TIWp9ixSVCTw+1
         u3Cg==
X-Gm-Message-State: AOAM533joQbkup7mjypNK0xQc8y73P/dJ50Zt74P8N0blPxkhpjyaLrr
        IrFYKZAffZqoWqLcPe+nFYOZkn8GCPDEKVhbCQcM5k7wy8Rcl6f/
X-Google-Smtp-Source: ABdhPJw99If/RKGpRUwjlonKyPTaQXN2j/DqCO2JMwZhCa5H9xVGqOtmDGFUVsZJeUc2hznag+nhVu+jlU1EoAfXwf0=
X-Received: by 2002:a63:4f07:: with SMTP id d7mr12544687pgb.126.1607700737743;
 Fri, 11 Dec 2020 07:32:17 -0800 (PST)
MIME-Version: 1.0
References: <8c251b09e29f5c36a824f73211a22e64460d4e4e.1607678556.git.xuanzhuo@linux.alibaba.com>
In-Reply-To: <8c251b09e29f5c36a824f73211a22e64460d4e4e.1607678556.git.xuanzhuo@linux.alibaba.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Fri, 11 Dec 2020 16:32:06 +0100
Message-ID: <CAJ8uoz3wQ=mtPUsyQsgHPHcMNT55aayAQ+JmmL7VAz3KJEOtpw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] xsk: save the undone skb
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        "open list:XDP SOCKETS (AF_XDP)" <netdev@vger.kernel.org>,
        "open list:XDP SOCKETS (AF_XDP)" <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 11, 2020 at 2:12 PM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
>
> We can reserve the skb. When sending fails, NETDEV_TX_BUSY or
> xskq_prod_reserve fails. As long as skb is successfully generated and
> successfully configured, we can reserve skb if we encounter exceptions
> later.
>
> Especially when NETDEV_TX_BUSY fails, there is no need to deal with
> the problem that xskq_prod_reserve has been updated.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>  include/net/xdp_sock.h |  3 +++
>  net/xdp/xsk.c          | 36 +++++++++++++++++++++++++++---------
>  2 files changed, 30 insertions(+), 9 deletions(-)
>
> diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
> index 4f4e93b..fead0c9 100644
> --- a/include/net/xdp_sock.h
> +++ b/include/net/xdp_sock.h
> @@ -76,6 +76,9 @@ struct xdp_sock {
>         struct mutex mutex;
>         struct xsk_queue *fq_tmp; /* Only as tmp storage before bind */
>         struct xsk_queue *cq_tmp; /* Only as tmp storage before bind */
> +
> +       struct sk_buff *skb_undone;
> +       bool skb_undone_reserve;
>  };
>
>  #ifdef CONFIG_XDP_SOCKETS
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index e28c682..1051024 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -435,6 +435,19 @@ static int xsk_generic_xmit(struct sock *sk)
>         if (xs->queue_id >= xs->dev->real_num_tx_queues)
>                 goto out;
>
> +       if (xs->skb_undone) {
> +               if (xs->skb_undone_reserve) {
> +                       if (xskq_prod_reserve(xs->pool->cq))
> +                               goto out;
> +
> +                       xs->skb_undone_reserve = false;
> +               }
> +
> +               skb = xs->skb_undone;
> +               xs->skb_undone = NULL;
> +               goto xmit;
> +       }
> +
>         while (xskq_cons_peek_desc(xs->tx, &desc, xs->pool)) {
>                 char *buffer;
>                 u64 addr;
> @@ -454,12 +467,7 @@ static int xsk_generic_xmit(struct sock *sk)
>                 addr = desc.addr;
>                 buffer = xsk_buff_raw_get_data(xs->pool, addr);
>                 err = skb_store_bits(skb, 0, buffer, len);
> -               /* This is the backpressure mechanism for the Tx path.
> -                * Reserve space in the completion queue and only proceed
> -                * if there is space in it. This avoids having to implement
> -                * any buffering in the Tx path.
> -                */
> -               if (unlikely(err) || xskq_prod_reserve(xs->pool->cq)) {
> +               if (unlikely(err)) {
>                         kfree_skb(skb);
>                         goto out;
>                 }
> @@ -470,12 +478,22 @@ static int xsk_generic_xmit(struct sock *sk)
>                 skb_shinfo(skb)->destructor_arg = (void *)(long)desc.addr;
>                 skb->destructor = xsk_destruct_skb;
>
> +               /* This is the backpressure mechanism for the Tx path.
> +                * Reserve space in the completion queue and only proceed
> +                * if there is space in it. This avoids having to implement
> +                * any buffering in the Tx path.
> +                */
> +               if (xskq_prod_reserve(xs->pool->cq)) {
> +                       xs->skb_undone_reserve = true;
> +                       xs->skb_undone = skb;
> +                       goto out;
> +               }
> +
> +xmit:

This will not work in the general case since we cannot guarantee that
the application does not replace the packet in the Tx ring before it
calls send() again. This is fully legal. I also do not like to
introduce state between calls. Much simpler to have it stateless which
means less error prone.

On the positive side, I will submit a patch that improves performance
of this transmit function by using the new batch interfaces I
introduced a month ago. With this patch I get a throughput improvement
of between 15 and 25% for the txpush benchmark in xdpsock. This is
much more than you will get from this patch. It also avoids the
problem you are addressing here completely. I will submit the patch
next week after the bug fix in this code has trickled down to
bpf-next. Hope you will like the throughput improvement that it
provides.

>                 err = __dev_direct_xmit(skb, xs->queue_id);
>                 if  (err == NETDEV_TX_BUSY) {
>                         /* Tell user-space to retry the send */
> -                       skb->destructor = sock_wfree;
> -                       /* Free skb without triggering the perf drop trace */
> -                       consume_skb(skb);
> +                       xs->skb_undone = skb;
>                         err = -EAGAIN;
>                         goto out;
>                 }
> --
> 1.8.3.1
>
