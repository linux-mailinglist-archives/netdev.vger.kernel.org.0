Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E42F94C6105
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 03:17:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231289AbiB1CRq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Feb 2022 21:17:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231304AbiB1CRn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Feb 2022 21:17:43 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CA4646C1D6
        for <netdev@vger.kernel.org>; Sun, 27 Feb 2022 18:16:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646014562;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CNnWgfiQ5Q6Qh97dwmTTW8CSwF1BaMsz3d9uB0mZlfU=;
        b=FfRshwVbt20L4NftCSMKH6sWyHlDjBMVUwIo4GuLMnWZWvDwq9qsD3U+yk2NqU5F6f1s2E
        0jDnxR0RKkMq0SLicHqBwylgyNs2RqKl/tZIbQeBVlz+VS/9m1KdPMVG+vAOqcnFAV+vjp
        ZkELG5PjSPqzJYmEZiyvK8m5x1cL5YE=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-220--wTW5RZMND2Yq84crpHnrA-1; Sun, 27 Feb 2022 21:16:01 -0500
X-MC-Unique: -wTW5RZMND2Yq84crpHnrA-1
Received: by mail-lj1-f197.google.com with SMTP id d23-20020a05651c089700b002463e31a5ffso4988177ljq.3
        for <netdev@vger.kernel.org>; Sun, 27 Feb 2022 18:16:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CNnWgfiQ5Q6Qh97dwmTTW8CSwF1BaMsz3d9uB0mZlfU=;
        b=dwXYyQcotY73edGBs2osrGOvlO0HluQt5wuSkXumh6olFQ4Yh9lmeslS6qN6NYUhH/
         irLjzLmavOvnZQlWUwt/PNXq62U480jl1NAUh4naYm6FAyhBwhY493RYydqYYDHwPqC3
         M/889OSn5veCXr3DhIrOCVve7oBYaEprkxlJa0PSCuyFAhDrtXAnNYn613u7flnWVudV
         uhyNoBy/B/8vZwtNYj5qkOzAHaOSgROcw1Mm7P/0B54mt2cGWQEaO6XXZknOH4yKOKE+
         C/OyqLWYBtR8he2h1yzL5vstU3UYJhy7kdhbZk7FIHnLSuGQeAJGPTkn5MXdcwjG4gRf
         WL+A==
X-Gm-Message-State: AOAM530jKJvWBL0jpfA9DE0EpmgA7DOKTe7s9uCuMHj2kk7+mW4gVPWP
        UMzhEHjUVKpCFAKDE7fc1aAfqeLOGM0brhWY1ZoIMbA7uASLf9oE0UpJKWNhx0dedJ3r/pIdy9N
        bxZWHvgRWzjF++gIrtPaMuEvd8Wz5xquD
X-Received: by 2002:a05:651c:b12:b0:246:74cb:4a4 with SMTP id b18-20020a05651c0b1200b0024674cb04a4mr9044580ljr.492.1646014558591;
        Sun, 27 Feb 2022 18:15:58 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz2IUEdlig5Qxrnulga+hl3unA9Ll/9S9C/ZsbSGHeENvGx+vqIAwaZpk161mttnlyBOJreuBl3ckcaf9f4JsU=
X-Received: by 2002:a05:651c:b12:b0:246:74cb:4a4 with SMTP id
 b18-20020a05651c0b1200b0024674cb04a4mr9044559ljr.492.1646014558307; Sun, 27
 Feb 2022 18:15:58 -0800 (PST)
MIME-Version: 1.0
References: <20220224103852.311369-1-baymaxhuang@gmail.com> <20220225090223.636877-1-baymaxhuang@gmail.com>
In-Reply-To: <20220225090223.636877-1-baymaxhuang@gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Mon, 28 Feb 2022 10:15:47 +0800
Message-ID: <CACGkMEvRxb02LgF9Tq9ypnAmfBmrw1iG1W8pB5hqNs3DROxmvw@mail.gmail.com>
Subject: Re: [PATCH net-next v2] tun: support NAPI for packets received from
 batched XDP buffs
To:     Harold Huang <baymaxhuang@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:XDP (eXpress Data Path)" <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 25, 2022 at 5:03 PM Harold Huang <baymaxhuang@gmail.com> wrote:
>
> In tun, NAPI is supported and we can also use NAPI in the path of
> batched XDP buffs to accelerate packet processing. What is more, after
> we use NAPI, GRO is also supported. The iperf shows that the throughput of
> single stream could be improved from 4.5Gbps to 9.2Gbps. Additionally, 9.2
> Gbps nearly reachs the line speed of the phy nic and there is still about
> 15% idle cpu core remaining on the vhost thread.
>
> Test topology:
>
> [iperf server]<--->tap<--->dpdk testpmd<--->phy nic<--->[iperf client]
>
> Iperf stream:
>
> Before:
> ...
> [  5]   5.00-6.00   sec   558 MBytes  4.68 Gbits/sec    0   1.50 MBytes
> [  5]   6.00-7.00   sec   556 MBytes  4.67 Gbits/sec    1   1.35 MBytes
> [  5]   7.00-8.00   sec   556 MBytes  4.67 Gbits/sec    2   1.18 MBytes
> [  5]   8.00-9.00   sec   559 MBytes  4.69 Gbits/sec    0   1.48 MBytes
> [  5]   9.00-10.00  sec   556 MBytes  4.67 Gbits/sec    1   1.33 MBytes
> - - - - - - - - - - - - - - - - - - - - - - - - -
> [ ID] Interval           Transfer     Bitrate         Retr
> [  5]   0.00-10.00  sec  5.39 GBytes  4.63 Gbits/sec   72          sender
> [  5]   0.00-10.04  sec  5.39 GBytes  4.61 Gbits/sec               receiver
>
> After:
> ...
> [  5]   5.00-6.00   sec  1.07 GBytes  9.19 Gbits/sec    0   1.55 MBytes
> [  5]   6.00-7.00   sec  1.08 GBytes  9.30 Gbits/sec    0   1.63 MBytes
> [  5]   7.00-8.00   sec  1.08 GBytes  9.25 Gbits/sec    0   1.72 MBytes
> [  5]   8.00-9.00   sec  1.08 GBytes  9.25 Gbits/sec   77   1.31 MBytes
> [  5]   9.00-10.00  sec  1.08 GBytes  9.24 Gbits/sec    0   1.48 MBytes
> - - - - - - - - - - - - - - - - - - - - - - - - -
> [ ID] Interval           Transfer     Bitrate         Retr
> [  5]   0.00-10.00  sec  10.8 GBytes  9.28 Gbits/sec  166          sender
> [  5]   0.00-10.04  sec  10.8 GBytes  9.24 Gbits/sec               receiver
> ....
>
> Reported-at: https://lore.kernel.org/all/CACGkMEvTLG0Ayg+TtbN4q4pPW-ycgCCs3sC3-TF8cuRTf7Pp1A@mail.gmail.com
> Signed-off-by: Harold Huang <baymaxhuang@gmail.com>
> ---
> v1 -> v2
>  - fix commit messages
>  - add queued flag to avoid void unnecessary napi suggested by Jason
>
>  drivers/net/tun.c | 20 ++++++++++++++++----
>  1 file changed, 16 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index fed85447701a..c7d8b7c821d8 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -2379,7 +2379,7 @@ static void tun_put_page(struct tun_page *tpage)
>  }
>
>  static int tun_xdp_one(struct tun_struct *tun,
> -                      struct tun_file *tfile,
> +                      struct tun_file *tfile, int *queued,
>                        struct xdp_buff *xdp, int *flush,
>                        struct tun_page *tpage)

Nit: how about simply returning the number of packets queued here?

Thanks

>  {
> @@ -2388,6 +2388,7 @@ static int tun_xdp_one(struct tun_struct *tun,
>         struct virtio_net_hdr *gso = &hdr->gso;
>         struct bpf_prog *xdp_prog;
>         struct sk_buff *skb = NULL;
> +       struct sk_buff_head *queue;
>         u32 rxhash = 0, act;
>         int buflen = hdr->buflen;
>         int err = 0;
> @@ -2464,7 +2465,15 @@ static int tun_xdp_one(struct tun_struct *tun,
>             !tfile->detached)
>                 rxhash = __skb_get_hash_symmetric(skb);
>
> -       netif_receive_skb(skb);
> +       if (tfile->napi_enabled) {
> +               queue = &tfile->sk.sk_write_queue;
> +               spin_lock(&queue->lock);
> +               __skb_queue_tail(queue, skb);
> +               spin_unlock(&queue->lock);
> +               (*queued)++;
> +       } else {
> +               netif_receive_skb(skb);
> +       }
>
>         /* No need to disable preemption here since this function is
>          * always called with bh disabled
> @@ -2492,7 +2501,7 @@ static int tun_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
>         if (ctl && (ctl->type == TUN_MSG_PTR)) {
>                 struct tun_page tpage;
>                 int n = ctl->num;
> -               int flush = 0;
> +               int flush = 0, queued = 0;
>
>                 memset(&tpage, 0, sizeof(tpage));
>
> @@ -2501,12 +2510,15 @@ static int tun_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
>
>                 for (i = 0; i < n; i++) {
>                         xdp = &((struct xdp_buff *)ctl->ptr)[i];
> -                       tun_xdp_one(tun, tfile, xdp, &flush, &tpage);
> +                       tun_xdp_one(tun, tfile, &queued, xdp, &flush, &tpage);
>                 }
>
>                 if (flush)
>                         xdp_do_flush();
>
> +               if (tfile->napi_enabled && queued > 0)
> +                       napi_schedule(&tfile->napi);
> +
>                 rcu_read_unlock();
>                 local_bh_enable();
>
> --
> 2.27.0
>

