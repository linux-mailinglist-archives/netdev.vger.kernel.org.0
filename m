Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0F2C31DB18
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 15:04:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233313AbhBQOCU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 09:02:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233035AbhBQOCG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 09:02:06 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87A88C061574
        for <netdev@vger.kernel.org>; Wed, 17 Feb 2021 06:01:26 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id c131so9042603ybf.7
        for <netdev@vger.kernel.org>; Wed, 17 Feb 2021 06:01:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cG0ZCrhxDmfLowBT67ycPSjzuXTsCVhbGgDwz/Q0RjI=;
        b=TSh77xs4RDgnUP8XsfODubsjshqjFNOeiV/VN3vrMvGag/iLsFh5tPO+qNgrN6ccEU
         ZTItNQyqYhpptWVCgMqmLVWYPc6kChK/OGxi5ta8grn0heCHbNSF4aDYBeNAJm4u98uR
         OtphwugFC0r9Hlj/+RpouuOO4rVTpN1S60OYpykaZhQfJ6HOa96i3wYNX+yg0MhlWihV
         E8+JS/NWI2sgmXd+7oYipZJ7RBxkq9j08Iw/Lr9IAwJ0vE/tcOU49IXUwopBzR+MZvKl
         OLqpWa3vNw3bf4GLYCJX/3O8zLh0wVsI2dXz0nlYlux9kcFjL0gsRXVcj8gQFaXFtx5h
         4qXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cG0ZCrhxDmfLowBT67ycPSjzuXTsCVhbGgDwz/Q0RjI=;
        b=iKpsjPwPgE614X3DM5j/g1ari5gqyFqGr9d9kNHDmGlhSochRmTjoyfaDZrSKh/7NW
         O8fmbek0XX26hAKaY73E2Mb/OQr4PBSgfN6Hj9PH+X//hH+FHHXoQmABMKQb7yMNFKSt
         LJBVasE0/+tOTX7rFa8Abzy3ig/9BeZyMeNjNkmgUXB6Bq6jknK5lRFNZtjUyOSL6PQ0
         0D0qx1Wcd3bKWsRsBO5R3FEwA4YSAGyYJmwoehgSPeOz49P/m3fbtfMuPd/tgUdVSVk8
         CyehPrfjQuUXOT/riSHImxwHUpTGAHtZws99rFkwuPeYc48QOReV7QWTKBsnT0sh2w7V
         IaYw==
X-Gm-Message-State: AOAM531Zo695567RIt/YohAcAHQfTahtjmGsJwTejG/0RKoNVBohSP3a
        Wnz1YlwhPZmFuGXxZ1u63PNLC0f9KS7Dzoss+MZQbVajNiw=
X-Google-Smtp-Source: ABdhPJy88s3nCoo7Mqqws77w2F2jGj/7sxyUUA+DN57SgF0O799UTH41qKGwtTptiiTzp5ApuJ9IJxzU+BL42/y/2GA=
X-Received: by 2002:a25:3417:: with SMTP id b23mr37471288yba.257.1613570485455;
 Wed, 17 Feb 2021 06:01:25 -0800 (PST)
MIME-Version: 1.0
References: <20210211211044.32701-1-borisp@mellanox.com> <20210211211044.32701-8-borisp@mellanox.com>
 <cfd61c5a-c5fd-e0d9-fb60-be93f1c98735@gmail.com>
In-Reply-To: <cfd61c5a-c5fd-e0d9-fb60-be93f1c98735@gmail.com>
From:   Or Gerlitz <gerlitz.or@gmail.com>
Date:   Wed, 17 Feb 2021 16:01:14 +0200
Message-ID: <CAJ3xEMgZg9dFyc8cnbuPPAFT3jd2k27TdLOz-vtVmxy9k9zHcg@mail.gmail.com>
Subject: Re: [PATCH v4 net-next 07/21] nvme-tcp: Add DDP data-path
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
        boris.pismenny@gmail.com, linux-nvme@lists.infradead.org,
        Linux Netdev List <netdev@vger.kernel.org>,
        benishay@nvidia.com, Or Gerlitz <ogerlitz@nvidia.com>,
        yorayz@nvidia.com, Ben Ben-Ishay <benishay@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yoray Zack <yorayz@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 14, 2021 at 8:30 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 2/11/21 2:10 PM, Boris Pismenny wrote:
> >
> > +static int nvme_tcp_teardown_ddp(struct nvme_tcp_queue *queue,
> > +                              u16 command_id,
> > +                              struct request *rq)
> > +{
> > +     struct nvme_tcp_request *req = blk_mq_rq_to_pdu(rq);
> > +     struct net_device *netdev = queue->ctrl->offloading_netdev;
> > +     int ret;
> > +
> > +     if (unlikely(!netdev)) {
> > +             dev_info_ratelimited(queue->ctrl->ctrl.device, "netdev not found\n");
>
> again, unnecessary. you only get here because the rquest is marked
> offloaded and that only happens if the netdev exists and supports DDP.
>
> > +             return -EINVAL;
> > +     }
> > +
> > +     ret = netdev->tcp_ddp_ops->tcp_ddp_teardown(netdev, queue->sock->sk,
> > +                                                 &req->ddp, rq);
> > +     sg_free_table_chained(&req->ddp.sg_table, SG_CHUNK_SIZE);
> > +     return ret;
> > +}
> > +
> > +static void nvme_tcp_ddp_teardown_done(void *ddp_ctx)
> > +{
> > +     struct request *rq = ddp_ctx;
> > +     struct nvme_tcp_request *req = blk_mq_rq_to_pdu(rq);
> > +
> > +     if (!nvme_try_complete_req(rq, req->status, req->result))
> > +             nvme_complete_rq(rq);
> > +}
> > +
> > +static int nvme_tcp_setup_ddp(struct nvme_tcp_queue *queue,
> > +                           u16 command_id,
> > +                           struct request *rq)
> > +{
> > +     struct nvme_tcp_request *req = blk_mq_rq_to_pdu(rq);
> > +     struct net_device *netdev = queue->ctrl->offloading_netdev;
> > +     int ret;
> > +
> > +     if (unlikely(!netdev)) {
> > +             dev_info_ratelimited(queue->ctrl->ctrl.device, "netdev not found\n");
>
> similarly here. you can't get here if netdev is null.
>
> > +             return -EINVAL;
> > +     }
> > +
> > +     req->ddp.command_id = command_id;
> > +     ret = nvme_tcp_req_map_sg(req, rq);
> > +     if (ret)
> > +             return -ENOMEM;
> > +
> > +     ret = netdev->tcp_ddp_ops->tcp_ddp_setup(netdev,
> > +                                              queue->sock->sk,
> > +                                              &req->ddp);
> > +     if (!ret)
> > +             req->offloaded = true;
> > +     return ret;
> > +}
> > +
> >  static int nvme_tcp_offload_socket(struct nvme_tcp_queue *queue)
> >  {
> >       struct net_device *netdev = queue->ctrl->offloading_netdev;
> > @@ -343,7 +417,7 @@ static void nvme_tcp_resync_response(struct nvme_tcp_queue *queue,
> >               return;
> >
> >       if (unlikely(!netdev)) {
> > -             pr_info_ratelimited("%s: netdev not found\n", __func__);
> > +             dev_info_ratelimited(queue->ctrl->ctrl.device, "netdev not found\n");
>
> and per comment on the last patch, this is not needed.
>
> > @@ -849,10 +953,39 @@ static int nvme_tcp_recv_pdu(struct nvme_tcp_queue *queue, struct sk_buff *skb,
> >
> >  static inline void nvme_tcp_end_request(struct request *rq, u16 status)
> >  {
> > +     struct nvme_tcp_request *req = blk_mq_rq_to_pdu(rq);
> > +     struct nvme_tcp_queue *queue = req->queue;
> > +     struct nvme_tcp_data_pdu *pdu = (void *)queue->pdu;
> >       union nvme_result res = {};
> >
> > -     if (!nvme_try_complete_req(rq, cpu_to_le16(status << 1), res))
> > -             nvme_complete_rq(rq);
> > +     nvme_tcp_complete_request(rq, cpu_to_le16(status << 1), res, pdu->command_id);
> > +}
> > +
> > +
> > +static int nvme_tcp_consume_skb(struct nvme_tcp_queue *queue, struct sk_buff *skb,
> > +                             unsigned int *offset, struct iov_iter *iter, int recv_len)
> > +{
> > +     int ret;
> > +
> > +#ifdef CONFIG_TCP_DDP
> > +     if (test_bit(NVME_TCP_Q_OFF_DDP, &queue->flags)) {
> > +             if (queue->data_digest)
> > +                     ret = skb_ddp_copy_and_hash_datagram_iter(skb, *offset, iter, recv_len,
> > +                                     queue->rcv_hash);
> > +             else
> > +                     ret = skb_ddp_copy_datagram_iter(skb, *offset, iter, recv_len);
> > +     } else {
> > +#endif
>
> why not make that a helper defined in the CONFIG_TCP_DDP section with an
> inline for the unset case. Keeps this code from being polluted with the
> ifdef checks.

will check that

>
> > +             if (queue->data_digest)
> > +                     ret = skb_copy_and_hash_datagram_iter(skb, *offset, iter, recv_len,
> > +                                     queue->rcv_hash);
> > +             else
> > +                     ret = skb_copy_datagram_iter(skb, *offset, iter, recv_len);
> > +#ifdef CONFIG_TCP_DDP
> > +     }
> > +#endif
> > +
> > +     return ret;
> >  }
> >
> >  static int nvme_tcp_recv_data(struct nvme_tcp_queue *queue, struct sk_buff *skb,
> > @@ -899,12 +1032,7 @@ static int nvme_tcp_recv_data(struct nvme_tcp_queue *queue, struct sk_buff *skb,
> >               recv_len = min_t(size_t, recv_len,
> >                               iov_iter_count(&req->iter));
> >
> > -             if (queue->data_digest)
> > -                     ret = skb_copy_and_hash_datagram_iter(skb, *offset,
> > -                             &req->iter, recv_len, queue->rcv_hash);
> > -             else
> > -                     ret = skb_copy_datagram_iter(skb, *offset,
> > -                                     &req->iter, recv_len);
> > +             ret = nvme_tcp_consume_skb(queue, skb, offset, &req->iter, recv_len);
> >               if (ret) {
> >                       dev_err(queue->ctrl->ctrl.device,
> >                               "queue %d failed to copy request %#x data",
> > @@ -1128,6 +1256,7 @@ static int nvme_tcp_try_send_cmd_pdu(struct nvme_tcp_request *req)
> >       bool inline_data = nvme_tcp_has_inline_data(req);
> >       u8 hdgst = nvme_tcp_hdgst_len(queue);
> >       int len = sizeof(*pdu) + hdgst - req->offset;
> > +     struct request *rq = blk_mq_rq_from_pdu(req);
> >       int flags = MSG_DONTWAIT;
> >       int ret;
> >
> > @@ -1136,6 +1265,10 @@ static int nvme_tcp_try_send_cmd_pdu(struct nvme_tcp_request *req)
> >       else
> >               flags |= MSG_EOR;
> >
> > +     if (test_bit(NVME_TCP_Q_OFF_DDP, &queue->flags) &&
> > +         blk_rq_nr_phys_segments(rq) && rq_data_dir(rq) == READ)
> > +             nvme_tcp_setup_ddp(queue, pdu->cmd.common.command_id, rq);
> > +
>
> For consistency, shouldn't this be wrapped in the CONFIG_TCP_DDP check too?

We tried to avoid the wrapping in some places where it was
possible to do without adding confusion, this one is a good
example IMOH.


> >       if (queue->hdr_digest && !req->offset)
> >               nvme_tcp_hdgst(queue->snd_hash, pdu, sizeof(*pdu));
> >
