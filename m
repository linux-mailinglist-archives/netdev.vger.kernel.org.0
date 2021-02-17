Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E97B31DB08
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 14:57:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233222AbhBQN4t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 08:56:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233182AbhBQN4o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 08:56:44 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C465FC061756
        for <netdev@vger.kernel.org>; Wed, 17 Feb 2021 05:56:03 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id f4so13803147ybk.11
        for <netdev@vger.kernel.org>; Wed, 17 Feb 2021 05:56:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Euy9q3Dg8nZRt8Xk+Qc+Td8mtT5QMxbfMBj9zzJ8FgI=;
        b=GB0geiCsX4/8p1lbxdeBIZyP+NqRdSwmQVoe5rf4xJg94C6rATYDHSc9nvunUI1ERY
         Wn6kACKAj4cz97c5U2P6xeuI/ijqOLus/2zfQwuF7I5XszW/zELWeXuiYgPjfCavs9Be
         5QnsXBe2+I8MmDDVzS4DLm59D9ex2dPZnWC2hnljj1F737qnT/dcsNskWRsAjJLl71Ym
         BnCkhSWAqufDijB1P6qN2g6td4bbdu7YhlymBsxqREXLbzN5OK7hat+cMu+z44KOQeD4
         SA3OtJwtcZp0TTcVjS65zIkdCP2VT0SQS+zoXRreQcqOrv+hTKRdOyqBzvbBQ3wq/EVZ
         /sQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Euy9q3Dg8nZRt8Xk+Qc+Td8mtT5QMxbfMBj9zzJ8FgI=;
        b=bgtLYdYiyrTiqRvolNA/L3nUXLQAHKEAYFcc6VG1ADB0uiLqDocta3vx/bL4abk46P
         vleeKUiKHmpTHsw3uFleCTyJXxFHccttv3QhctmU0y51FPf+YYDv7hJak+UE91+/AdsX
         x0NC32txRSsvKI1HcLTCXnX2UbUN6UiFC6s94d0DfqUTuDMHeO3liTNzC3oikTEFldJa
         qnuNSiXAVbNdOGyXPbE8I7i1GLU+AULsjS6LgKqHT1085BlhXpB+/Uum1HOqHFx5R/by
         euC5Rn3lx8NPs+mOGetpq5EWG0Z5ujN/IpN99iitOVaX/1h6YeERAku+ZuRKcm5RiAci
         p2Vg==
X-Gm-Message-State: AOAM5328zqtjrlrRgP7p5Xn9bA0rwN3uQLiTiwvpuonwmUxH3PNFABWi
        XjoNdcnFLy7mCY+eqAkRjbRQBO/cWvmiyDC6pXo=
X-Google-Smtp-Source: ABdhPJyAnLjigLI3YtVxNWAkyYl7z3qY7zhky7UQIDvgZuepJepZNwDvMPc2RXKJp5XKF6t8rF9Yr24e7tJQ5l8O2gc=
X-Received: by 2002:a25:9383:: with SMTP id a3mr37060610ybm.215.1613570163089;
 Wed, 17 Feb 2021 05:56:03 -0800 (PST)
MIME-Version: 1.0
References: <20210211211044.32701-1-borisp@mellanox.com> <20210211211044.32701-7-borisp@mellanox.com>
 <2dd10b2f-df00-e21c-7886-93f41a987040@gmail.com>
In-Reply-To: <2dd10b2f-df00-e21c-7886-93f41a987040@gmail.com>
From:   Or Gerlitz <gerlitz.or@gmail.com>
Date:   Wed, 17 Feb 2021 15:55:51 +0200
Message-ID: <CAJ3xEMjMqK81uNv21poD+DoZCRxYak0DYFZrjDbmWaSxw4R5ig@mail.gmail.com>
Subject: Re: [PATCH v4 net-next 06/21] nvme-tcp: Add DDP offload control path
To:     David Ahern <dsahern@gmail.com>
Cc:     Boris Pismenny <borisp@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>, axboe@fb.com,
        Keith Busch <kbusch@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Eric Dumazet <edumazet@google.com>, smalin@marvell.com,
        Yoray Zack <yorayz@mellanox.com>, yorayz@nvidia.com,
        boris.pismenny@gmail.com, Ben Ben-Ishay <benishay@mellanox.com>,
        benishay@nvidia.com, linux-nvme@lists.infradead.org,
        Linux Netdev List <netdev@vger.kernel.org>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Or Gerlitz <ogerlitz@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 14, 2021 at 8:20 PM David Ahern <dsahern@gmail.com> wrote:
> On 2/11/21 2:10 PM, Boris Pismenny wrote:
> > @@ -223,6 +229,164 @@ static inline size_t nvme_tcp_pdu_last_send(struct nvme_tcp_request *req,
> >       return nvme_tcp_pdu_data_left(req) <= len;
> >  }
> >
> > +#ifdef CONFIG_TCP_DDP
> > +
> > +static bool nvme_tcp_resync_request(struct sock *sk, u32 seq, u32 flags);
> > +static const struct tcp_ddp_ulp_ops nvme_tcp_ddp_ulp_ops = {
> > +     .resync_request         = nvme_tcp_resync_request,
> > +};
> > +
> > +static int nvme_tcp_offload_socket(struct nvme_tcp_queue *queue)
> > +{
> > +     struct net_device *netdev = queue->ctrl->offloading_netdev;
> > +     struct nvme_tcp_ddp_config config = {};
> > +     int ret;
> > +
> > +     if (!(netdev->features & NETIF_F_HW_TCP_DDP))
>
> If nvme_tcp_offload_limits does not find a dst_entry on the socket then
> offloading_netdev may not NULL at this point.

correct :( will look on that

>
> > +             return -EOPNOTSUPP;
> > +
> > +     config.cfg.type         = TCP_DDP_NVME;
> > +     config.pfv              = NVME_TCP_PFV_1_0;
> > +     config.cpda             = 0;
> > +     config.dgst             = queue->hdr_digest ?
> > +             NVME_TCP_HDR_DIGEST_ENABLE : 0;
> > +     config.dgst             |= queue->data_digest ?
> > +             NVME_TCP_DATA_DIGEST_ENABLE : 0;
> > +     config.queue_size       = queue->queue_size;
> > +     config.queue_id         = nvme_tcp_queue_id(queue);
> > +     config.io_cpu           = queue->io_cpu;
> > +
> > +     dev_hold(netdev); /* put by unoffload_socket */
> > +     ret = netdev->tcp_ddp_ops->tcp_ddp_sk_add(netdev,
> > +                                               queue->sock->sk,
> > +                                               &config.cfg);
> > +     if (ret) {
> > +             dev_put(netdev);
> > +             return ret;
> > +     }
> > +
> > +     inet_csk(queue->sock->sk)->icsk_ulp_ddp_ops = &nvme_tcp_ddp_ulp_ops;
> > +     if (netdev->features & NETIF_F_HW_TCP_DDP)
> > +             set_bit(NVME_TCP_Q_OFF_DDP, &queue->flags);
> > +
> > +     return ret;
> > +}
> > +
> > +static void nvme_tcp_unoffload_socket(struct nvme_tcp_queue *queue)
> > +{
> > +     struct net_device *netdev = queue->ctrl->offloading_netdev;
> > +
> > +     if (!netdev) {
> > +             dev_info_ratelimited(queue->ctrl->ctrl.device, "netdev not found\n");
>
> you are already logged in nvme_tcp_offload_limits that
> get_netdev_for_sock returned NULL; no need to do it again.

yeah, re this one and the few other places where you commented
on the same or similar thing, I tend to agree we need to go on the
kernel trusted programming paradigm and avoid over checking, will
discuss that with the team.


> > +             return;
> > +     }
> > +
> > +     netdev->tcp_ddp_ops->tcp_ddp_sk_del(netdev, queue->sock->sk);
> > +
> > +     inet_csk(queue->sock->sk)->icsk_ulp_ddp_ops = NULL;
> > +     dev_put(netdev); /* held by offload_socket */
> > +}
> > +
> > +static int nvme_tcp_offload_limits(struct nvme_tcp_queue *queue)
> > +{
> > +     struct net_device *netdev = get_netdev_for_sock(queue->sock->sk, true);
> > +     struct tcp_ddp_limits limits;
> > +     int ret = 0;
> > +
> > +     if (!netdev) {
> > +             dev_info_ratelimited(queue->ctrl->ctrl.device, "netdev not found\n");
>
> This should be more informative.

okk

> > +             queue->ctrl->offloading_netdev = NULL;
> > +             return -ENODEV;
> > +     }
> > +
> > +     if (netdev->features & NETIF_F_HW_TCP_DDP &&
> > +         netdev->tcp_ddp_ops &&
> > +         netdev->tcp_ddp_ops->tcp_ddp_limits)
> > +             ret = netdev->tcp_ddp_ops->tcp_ddp_limits(netdev, &limits);
> > +     else
> > +             ret = -EOPNOTSUPP;
> > +
> > +     if (!ret) {
> > +             queue->ctrl->offloading_netdev = netdev;
>
> you save a reference to the netdev here, but then release the refcnt
> below. That device could be deleted between this point in time and the
> initialization of all queues.

> > +             dev_dbg_ratelimited(queue->ctrl->ctrl.device,
> > +                                 "netdev %s offload limits: max_ddp_sgl_len %d\n",
> > +                                 netdev->name, limits.max_ddp_sgl_len);
> > +             queue->ctrl->ctrl.max_segments = limits.max_ddp_sgl_len;
> > +             queue->ctrl->ctrl.max_hw_sectors =
> > +                     limits.max_ddp_sgl_len << (ilog2(SZ_4K) - 9);
> > +     } else {
> > +             queue->ctrl->offloading_netdev = NULL;
> > +     }
> > +
> > +     /* release the device as no offload context is established yet. */
> > +     dev_put(netdev);
> > +
> > +     return ret;
> > +}
> > +
> > +static void nvme_tcp_resync_response(struct nvme_tcp_queue *queue,
> > +                                  struct sk_buff *skb, unsigned int offset)
> > +{
> > +     u64 pdu_seq = TCP_SKB_CB(skb)->seq + offset - queue->pdu_offset;
> > +     struct net_device *netdev = queue->ctrl->offloading_netdev;
> > +     u64 resync_val;
> > +     u32 resync_seq;
> > +
> > +     resync_val = atomic64_read(&queue->resync_req);
> > +     /* Lower 32 bit flags. Check validity of the request */
> > +     if ((resync_val & TCP_DDP_RESYNC_REQ) == 0)
> > +             return;
> > +
> > +     /* Obtain and check requested sequence number: is this PDU header before the request? */
> > +     resync_seq = resync_val >> 32;
> > +     if (before(pdu_seq, resync_seq))
> > +             return;
> > +
> > +     if (unlikely(!netdev)) {
> > +             pr_info_ratelimited("%s: netdev not found\n", __func__);
>
> can't happen right? you get here because NVME_TCP_Q_OFF_DDP is set and
> it is only set if offloading_netdev is set and the device supports offload.

as I wrote above, will discuss this general comment and likely
go the direction you are pointing on
