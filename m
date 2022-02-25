Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 585C24C3C9E
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 04:47:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236757AbiBYDrf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 22:47:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235607AbiBYDre (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 22:47:34 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E1F4FFFF8B
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 19:47:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645760821;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AN+RljBQxYbf73CPkJoQu7uYGtkkLK4GI8ktS0B03lM=;
        b=SMrxj9uXZhGR77Dw5QYwiWI+QjK+HLD1eSdstm9febDsouOA4HRXH7pht92TdZ3+Yx96kT
        r4pnE+RYkfUpaE3wVW/ykVVyQ8y5ypEWEONCIN7ga7t2r/09l0o6Z0i5iNjv/H7hiAOFvf
        aAFuXYwcp1xAS3j5awUIN3e5t0KVf5A=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-224-Y96RLXYuNVyIpygB1Q3jBg-1; Thu, 24 Feb 2022 22:46:57 -0500
X-MC-Unique: Y96RLXYuNVyIpygB1Q3jBg-1
Received: by mail-lf1-f69.google.com with SMTP id m13-20020a19520d000000b00443423ff116so510213lfb.11
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 19:46:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AN+RljBQxYbf73CPkJoQu7uYGtkkLK4GI8ktS0B03lM=;
        b=NnGQrlQbfR2kNBErb7+IfbsIT7NBlyNW8E58Dy4yF0wQe7Y0Aup4AI6viBnr6rcA8L
         L+xSCdoVFlx/2Hsidb7IEvstTiuWSqL+phzZKKCgY7yqLORa6RKt3hVY2iAUF9xoWbuQ
         gZ09XK8OHqsnUrdfpMIZpFgh0Rt4vnJ+cuh0V0N/V8aoBF8kYIHMC9+js7DxAMR3T7nx
         A4BI0EVYa6eo7fa7bJFMoc2ydo3sI+3gIHAl9uVRrUBE58lvMJ4Je3F9wG7UB53XqsdA
         srBikTmg96vs2Q9OoJCdc/2/Wp/7IYFW24PsbdTecadlojZpextAFCBVMA2FhrToQMFg
         FO5w==
X-Gm-Message-State: AOAM532WLtiwyjveJfhP8yKu8QJ0pS+Sq+AKDcVv9zVq8cwYzSa75/bv
        4CPwmUyM2pX3Voy75wsqklbfIjJQsxQrxLk04UNZCDvPvJdOMVM7K+XTbR5ryEhhkeBRYISupXj
        /a1GEKJKDTf//V46iksckYjYYCNzs/Von
X-Received: by 2002:a05:651c:90b:b0:244:c4a4:d5d8 with SMTP id e11-20020a05651c090b00b00244c4a4d5d8mr3844434ljq.97.1645760815510;
        Thu, 24 Feb 2022 19:46:55 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxlrEucrNT6Oj6btH3jTMQAiAovp8Jt2RzWw1pbp7kHf2Vjr1JlUtNCdzQbn394fIhctnnrdKC8drdPLMw44d8=
X-Received: by 2002:a05:651c:90b:b0:244:c4a4:d5d8 with SMTP id
 e11-20020a05651c090b00b00244c4a4d5d8mr3844424ljq.97.1645760815306; Thu, 24
 Feb 2022 19:46:55 -0800 (PST)
MIME-Version: 1.0
References: <20220224103852.311369-1-baymaxhuang@gmail.com>
In-Reply-To: <20220224103852.311369-1-baymaxhuang@gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Fri, 25 Feb 2022 11:46:43 +0800
Message-ID: <CACGkMEtR+e00Nyb=oytq4vHavwXZ7oFun7iNdRFBx3gDghRa_g@mail.gmail.com>
Subject: Re: [PATCH] tun: support NAPI to accelerate packet processing
To:     Harold Huang <baymaxhuang@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 24, 2022 at 6:39 PM Harold Huang <baymaxhuang@gmail.com> wrote:
>
> In tun, NAPI is supported and we can also use NAPI in the path of
> batched XDP buffs to accelerate packet processing. What is more, after
> we use NPAI, GRO is also supported. The iperf shows that the throughput
> could be improved from 4.5Gbsp to 9.2Gbps per stream.

It's better to describe the setup in the testing.

And we need to tweak the title as NAPI is supported in some paths,
something like "support NAPI for packets received from msg_control"?

>
> Reported-at: https://lore.kernel.org/netdev/CAHJXk3Y9_Fh04sakMMbcAkef7kOTEc-kf84Ne3DtWD7EAp13cg@mail.gmail.com/T/#t
> Signed-off-by: Harold Huang <baymaxhuang@gmail.com>
> ---
>  drivers/net/tun.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index fed85447701a..4e1cea659b42 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -2388,6 +2388,7 @@ static int tun_xdp_one(struct tun_struct *tun,
>         struct virtio_net_hdr *gso = &hdr->gso;
>         struct bpf_prog *xdp_prog;
>         struct sk_buff *skb = NULL;
> +       struct sk_buff_head *queue;
>         u32 rxhash = 0, act;
>         int buflen = hdr->buflen;
>         int err = 0;
> @@ -2464,7 +2465,14 @@ static int tun_xdp_one(struct tun_struct *tun,
>             !tfile->detached)
>                 rxhash = __skb_get_hash_symmetric(skb);
>
> -       netif_receive_skb(skb);
> +       if (tfile->napi_enabled) {
> +               queue = &tfile->sk.sk_write_queue;
> +               spin_lock(&queue->lock);
> +               __skb_queue_tail(queue, skb);
> +               spin_unlock(&queue->lock);
> +       } else {
> +               netif_receive_skb(skb);
> +       }
>
>         /* No need to disable preemption here since this function is
>          * always called with bh disabled
> @@ -2507,6 +2515,9 @@ static int tun_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
>                 if (flush)
>                         xdp_do_flush();
>
> +               if (tfile->napi_enabled)
> +                       napi_schedule(&tfile->napi);

It's better to check whether we've queued anything to avoid unnecessary napi.

Thanks

> +
>                 rcu_read_unlock();
>                 local_bh_enable();
>
> --
> 2.27.0
>

