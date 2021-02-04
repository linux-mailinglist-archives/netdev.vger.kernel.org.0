Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E470930FC81
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 20:23:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239691AbhBDTVd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 14:21:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238870AbhBDTVO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 14:21:14 -0500
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B88F3C0613D6
        for <netdev@vger.kernel.org>; Thu,  4 Feb 2021 11:20:33 -0800 (PST)
Received: by mail-yb1-xb30.google.com with SMTP id r2so4277484ybk.11
        for <netdev@vger.kernel.org>; Thu, 04 Feb 2021 11:20:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oAPvN9PvQ0aeegkq7czJXnWT6Ex32v8rIdvrvrQ0TK4=;
        b=bSCfIjwmVna6/En2QBXXGJdT4hSi1eZn7wg1Urn4e2JSe0ysn3ARxtJyLWHyL/CzNf
         2qjJ3BUL0eofbInj7Ia5p5ZVDw0EK5Rcjysjc/pMlK/ftS7zFuGEL62HGqDexen65wu3
         2yFFk/x1d+ykf5LKzytqwrkVWQps0tO40M+doKiWDoqbxVCUXd9P3hQhpBR2oBcjyZhR
         g6GdXNEVeb2eir/zPqcZ5y7RHgUbgFYxhYLPcWt1BlEVkBgH0lwnzM2V7IogdChyWvBB
         QULfqEK2+qYII6V0gbyDXHJ9ZKTnkuIbeyezUao4qxV76u3IgVRFQgYX2N+a/IDGVvpG
         CUfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oAPvN9PvQ0aeegkq7czJXnWT6Ex32v8rIdvrvrQ0TK4=;
        b=d2ML3cW3XX5a3CnOrxsXEldanJSrZXKxNMAQ6YK+QjuOzPAU2Vsu/Ec21RRQNjath9
         HEZ6SvuiP9OIUuxvTE/xxNLPhxc/VS8NbVahG+89/q1Kqy4bLpCs4KABKwrvxSqFGZ7W
         G93S3Fdt+xrR20mT3qXtz0u7292PbLz4vvFpUmXzZNX0GS1JV+wIa+O+chNoLpFsla0L
         c4zF6U3a6gpwiP99gaKglaKy8FXHCl5gimv7RN+8emWc1p7CyUZK9HJT52ibmimCh3tI
         7jZWvC15uumRxS8J28vWOjjGiLcYXCS2/ZtvET2e/3hpU0EQc4ZLnfWA45K9qfRNC9za
         hu/Q==
X-Gm-Message-State: AOAM5304OTyeIYJD1ocTDWsZtdmtTM8gMV7aTRP/hDCqPV3CoDs1xeuF
        JyowMDMwthsOSB6h4pItUjhJWU4G/C27ay/OFIM=
X-Google-Smtp-Source: ABdhPJzcjaMba+lk9vznshdtjf7avhXwZ3ue3+X8Y+1o3f8/F7oa/dcNU4gqkY1fMEd32vUXrbDiw6QEIPq6Arq6fmk=
X-Received: by 2002:a25:858e:: with SMTP id x14mr1080558ybk.257.1612466433019;
 Thu, 04 Feb 2021 11:20:33 -0800 (PST)
MIME-Version: 1.0
References: <20210201100509.27351-1-borisp@mellanox.com> <20210201100509.27351-8-borisp@mellanox.com>
 <9a8041aa-513f-09b9-63f4-3d12db19231c@grimberg.me>
In-Reply-To: <9a8041aa-513f-09b9-63f4-3d12db19231c@grimberg.me>
From:   Or Gerlitz <gerlitz.or@gmail.com>
Date:   Thu, 4 Feb 2021 21:20:21 +0200
Message-ID: <CAJ3xEMh90F8LKn2CCW5pP83moVQ3+O8ON_7q0HmoD8YNyomKyA@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 07/21] nvme-tcp: Add DDP data-path
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     Boris Pismenny <borisp@mellanox.com>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Christoph Hellwig <hch@lst.de>, axboe@fb.com,
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

On Wed, Feb 3, 2021 at 10:54 AM Sagi Grimberg <sagi@grimberg.me> wrote:

> > +static
> > +int nvme_tcp_teardown_ddp(struct nvme_tcp_queue *queue,
> > +                       u16 command_id,
> > +                       struct request *rq)
> > +{
> > +     struct nvme_tcp_request *req = blk_mq_rq_to_pdu(rq);
> > +     struct net_device *netdev = queue->ctrl->offloading_netdev;
> > +     int ret;
> > +
> > +     if (unlikely(!netdev)) {
> > +             pr_info_ratelimited("%s: netdev not found\n", __func__);
> > +             return -EINVAL;
> > +     }
> > +
> > +     ret = netdev->tcp_ddp_ops->tcp_ddp_teardown(netdev, queue->sock->sk,
> > +                                                 &req->ddp, rq);
> > +     sg_free_table_chained(&req->ddp.sg_table, SG_CHUNK_SIZE);
> > +     req->offloaded = false;
>
> Why is the offloaded = false needed here? you also clear it when you setup.

yep, there two places where we needlessly falsified the offloaded flag
- will remove them

The lifetime rules are - set to false on cmd setup and set to true in
ddp setup if it succeeded

>
> > +     return ret;
> > +}
> > +
> > +static void nvme_tcp_ddp_teardown_done(void *ddp_ctx)
> > +{
> > +     struct request *rq = ddp_ctx;
> > +     struct nvme_tcp_request *req = blk_mq_rq_to_pdu(rq);
> > +
> > +     if (!nvme_try_complete_req(rq, cpu_to_le16(req->status << 1), req->result))
> > +             nvme_complete_rq(rq);
>
> Why is the status shifted here? it was taken from the cqe as is..

there are two cases

1. the status is taken from the cqe as is
2. the status is taken from the req with shift left (the success bit
IO read flow)

for #2 we already do the shift left in nvme_tcp_end_request so no need to
repeat it here,  will fix

>
> > +}
> > +
> > +static
> > +int nvme_tcp_setup_ddp(struct nvme_tcp_queue *queue,
> > +                    u16 command_id,
> > +                    struct request *rq)
> > +{
> > +     struct nvme_tcp_request *req = blk_mq_rq_to_pdu(rq);
> > +     struct net_device *netdev = queue->ctrl->offloading_netdev;
> > +     int ret;
> > +
> > +     req->offloaded = false;
> > +
> > +     if (unlikely(!netdev)) {
> > +             pr_info_ratelimited("%s: netdev not found\n", __func__);
>
> dev_info_ratelimited please.

ok

> > +             return -EINVAL;
> > +     }
> > +
> > +     req->ddp.command_id = command_id;
> > +     req->ddp.sg_table.sgl = req->ddp.first_sgl;
> > +     ret = sg_alloc_table_chained(&req->ddp.sg_table, blk_rq_nr_phys_segments(rq),
> > +                                  req->ddp.sg_table.sgl, SG_CHUNK_SIZE);
> > +     if (ret)
> > +             return -ENOMEM;
> > +     req->ddp.nents = blk_rq_map_sg(rq->q, rq, req->ddp.sg_table.sgl);
> > +
> > +     ret = netdev->tcp_ddp_ops->tcp_ddp_setup(netdev,
> > +                                              queue->sock->sk,
> > +                                              &req->ddp);
> > +     if (!ret)
> > +             req->offloaded = true;
> > +     return ret;
> > +}
> > +
> >   static
> >   int nvme_tcp_offload_socket(struct nvme_tcp_queue *queue)
> >   {
> > @@ -377,6 +446,25 @@ bool nvme_tcp_resync_request(struct sock *sk, u32 seq, u32 flags)
> >
> >   #else
> >
> > +static
> > +int nvme_tcp_setup_ddp(struct nvme_tcp_queue *queue,
> > +                    u16 command_id,
> > +                    struct request *rq)
> > +{
> > +     return -EINVAL;
> > +}
> > +
> > +static
> > +int nvme_tcp_teardown_ddp(struct nvme_tcp_queue *queue,
> > +                       u16 command_id,
> > +                       struct request *rq)
> > +{
> > +     return -EINVAL;
> > +}
> > +
> > +static void nvme_tcp_ddp_teardown_done(void *ddp_ctx)
> > +{}
> > +
> >   static
> >   int nvme_tcp_offload_socket(struct nvme_tcp_queue *queue)
> >   {
> > @@ -665,6 +753,7 @@ static void nvme_tcp_error_recovery(struct nvme_ctrl *ctrl)
> >   static int nvme_tcp_process_nvme_cqe(struct nvme_tcp_queue *queue,
> >               struct nvme_completion *cqe)
> >   {
> > +     struct nvme_tcp_request *req;
> >       struct request *rq;
> >
> >       rq = blk_mq_tag_to_rq(nvme_tcp_tagset(queue), cqe->command_id);
> > @@ -676,8 +765,15 @@ static int nvme_tcp_process_nvme_cqe(struct nvme_tcp_queue *queue,
> >               return -EINVAL;
> >       }
> >
> > -     if (!nvme_try_complete_req(rq, cqe->status, cqe->result))
> > -             nvme_complete_rq(rq);
> > +     req = blk_mq_rq_to_pdu(rq);
> > +     if (req->offloaded) {
> > +             req->status = cqe->status;
> > +             req->result = cqe->result;
> > +             nvme_tcp_teardown_ddp(queue, cqe->command_id, rq);
> > +     } else {
> > +             if (!nvme_try_complete_req(rq, cqe->status, cqe->result))
> > +                     nvme_complete_rq(rq);
> > +     }
>
> Maybe move this to nvme_tcp_complete_request as it is called from two
> code paths.

to make sure, add

void nvme_tcp_complete_request(struct request *rq, u16 status, union
nvme_result *res, u16 status)

and invoke it from the two calls sites?

> >       queue->nr_cqe++;
> >
> >       return 0;
> > @@ -871,9 +967,18 @@ static int nvme_tcp_recv_pdu(struct nvme_tcp_queue *queue, struct sk_buff *skb,
> >   static inline void nvme_tcp_end_request(struct request *rq, u16 status)
> >   {
> >       union nvme_result res = {};
> > +     struct nvme_tcp_request *req = blk_mq_rq_to_pdu(rq);
> > +     struct nvme_tcp_queue *queue = req->queue;
> > +     struct nvme_tcp_data_pdu *pdu = (void *)queue->pdu;
> >
> > -     if (!nvme_try_complete_req(rq, cpu_to_le16(status << 1), res))
> > -             nvme_complete_rq(rq);
> > +     if (req->offloaded) {
> > +             req->status = cpu_to_le16(status << 1);
> > +             req->result = res;
> > +             nvme_tcp_teardown_ddp(queue, pdu->command_id, rq);
> > +     } else {
> > +             if (!nvme_try_complete_req(rq, cpu_to_le16(status << 1), res))
> > +                     nvme_complete_rq(rq);
> > +     }
> >   }
> >
> >   static int nvme_tcp_recv_data(struct nvme_tcp_queue *queue, struct sk_buff *skb,
> > @@ -920,12 +1025,22 @@ static int nvme_tcp_recv_data(struct nvme_tcp_queue *queue, struct sk_buff *skb,
> >               recv_len = min_t(size_t, recv_len,
> >                               iov_iter_count(&req->iter));
> >
> > -             if (queue->data_digest)
> > -                     ret = skb_copy_and_hash_datagram_iter(skb, *offset,
> > -                             &req->iter, recv_len, queue->rcv_hash);
> > -             else
> > -                     ret = skb_copy_datagram_iter(skb, *offset,
> > -                                     &req->iter, recv_len);
> > +             if (test_bit(NVME_TCP_Q_OFF_DDP, &queue->flags)) {
> > +                     if (queue->data_digest)
> > +                             ret = skb_ddp_copy_and_hash_datagram_iter(skb, *offset,
> > +                                             &req->iter, recv_len, queue->rcv_hash);
> > +                     else
> > +                             ret = skb_ddp_copy_datagram_iter(skb, *offset,
> > +                                             &req->iter, recv_len);
> > +             } else {
> > +                     if (queue->data_digest)
> > +                             ret = skb_copy_and_hash_datagram_iter(skb, *offset,
> > +                                             &req->iter, recv_len, queue->rcv_hash);
> > +                     else
> > +                             ret = skb_copy_datagram_iter(skb, *offset,
> > +                                             &req->iter, recv_len);
> > +             }
> > +
>
> Maybe move this hunk to nvme_tcp_consume_skb or something?

ok, we can add

int nvme_tcp_consume_skb(queue, skb, offset, iter, recv_len)

and put this hunk there

> > @@ -2464,6 +2584,7 @@ static blk_status_t nvme_tcp_setup_cmd_pdu(struct nvme_ns *ns,
> >       req->data_len = blk_rq_nr_phys_segments(rq) ?
> >                               blk_rq_payload_bytes(rq) : 0;
> >       req->curr_bio = rq->bio;
> > +     req->offloaded = false;
>
> offloaded is being cleared lots of times, and I'm not clear what are
> the lifetime rules here.

replied above
