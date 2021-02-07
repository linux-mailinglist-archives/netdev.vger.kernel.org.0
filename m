Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D33A312613
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 17:41:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbhBGQlL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 11:41:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbhBGQlJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Feb 2021 11:41:09 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B5DFC06174A
        for <netdev@vger.kernel.org>; Sun,  7 Feb 2021 08:40:29 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id v5so3442908ybi.3
        for <netdev@vger.kernel.org>; Sun, 07 Feb 2021 08:40:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+af15nnN8Mn8kOsFGJ+l1sBVQPZaanqdoowobKS9Qxk=;
        b=GxmeiTvVodXKD4Oj++FV2fD0HnNlCRyoQDIkLrQPlXuwmcF8LP+S5sHuEDTLyQ2MP4
         tUn05ggz87AB285/kg3VPSvQvnEQRj0+BZk8+fIvjszHlnbLQf9OStlzUT+9gZBlHRf/
         aW3pY4gV40+GI7ugPnsCZ/qjK41Ii3vpp28uN0SNcB0D4880frKfdPbdrCg+NBxxovJE
         APtknchrVGRI1S5KqJVock0ZRR+khNRdlge+tRVktzD1NgPY+X/3q1czRiiYtaIkazTC
         C29BBhMV8sYalE4OXpHez4oJmsOH8KFYD3K34RkEBmJ4Q6zlYAj/lqc5iSntJYJP0rt/
         rEGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+af15nnN8Mn8kOsFGJ+l1sBVQPZaanqdoowobKS9Qxk=;
        b=ZdcWWVYrJvQ1Y35IDEgRH/FUTzwJnYp+EKq1tLZGvOgGnopIY2siuzo7wla365pubJ
         RvRk7NZ8C9DuEYV7/4t+uT+D1ZYiZEZMApvSXKtCxt7SwcDDQDLowsDABZIGwA71tb/5
         hs8YHyGazE62s7ffRpxUVZlKrpW7IyH4lpmsxf5Gvz/tgzFgvhLj2CNWu9T5UYRLBysb
         aXzMcU58VVMldAxc22ypvsnYihSMbudycDm+9SXFo7jSLkMJP9TkuOcI6X3FL6EDZrgO
         M/McR35NXB6M5P55oJyOazVW7geHHPvKm5WfJqHQEGfqC/EQwqqUMKTE64upAIIowU6D
         Cjcg==
X-Gm-Message-State: AOAM532kvaASSf6fbfEgAQDq+p3lpXrkYmgecqjfyW0RnwlMPxaW4ApB
        bU9sGxEgwhulzyM/7OLW4xI38WqI2DW0iv3p9NY=
X-Google-Smtp-Source: ABdhPJwyYXzZbHbMFDkYDfS3ULyfXLG63yzTIosMwgSvayHRyyqmfOyye4rMeqRM2LTTkg4X7qjY44TgDFfe4kl9xm8=
X-Received: by 2002:a25:1646:: with SMTP id 67mr20565556ybw.97.1612716028667;
 Sun, 07 Feb 2021 08:40:28 -0800 (PST)
MIME-Version: 1.0
References: <20210201100509.27351-1-borisp@mellanox.com> <20210201100509.27351-9-borisp@mellanox.com>
 <a104a5d1-b4cb-4275-6ced-b80f911b6f47@grimberg.me>
In-Reply-To: <a104a5d1-b4cb-4275-6ced-b80f911b6f47@grimberg.me>
From:   Or Gerlitz <gerlitz.or@gmail.com>
Date:   Sun, 7 Feb 2021 18:40:17 +0200
Message-ID: <CAJ3xEMjnCzs7+6iusPdD666KodjdAfZCUn0rhUZa6wd_qL+kWQ@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 08/21] nvme-tcp : Recalculate crc in the end
 of the capsule
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

On Wed, Feb 3, 2021 at 11:12 AM Sagi Grimberg <sagi@grimberg.me> wrote:
> On 2/1/21 2:04 AM, Boris Pismenny wrote:

> > @@ -290,12 +341,9 @@ int nvme_tcp_setup_ddp(struct nvme_tcp_queue *queue,
> >       }
> >
> >       req->ddp.command_id = command_id;
> > -     req->ddp.sg_table.sgl = req->ddp.first_sgl;
> > -     ret = sg_alloc_table_chained(&req->ddp.sg_table, blk_rq_nr_phys_segments(rq),
> > -                                  req->ddp.sg_table.sgl, SG_CHUNK_SIZE);
> > +     ret = nvme_tcp_req_map_sg(req, rq);
>
> Why didn't you introduce nvme_tcp_req_map_sg in the first place?

OK, will do

> >       if (ret)
> >               return -ENOMEM;
> > -     req->ddp.nents = blk_rq_map_sg(rq->q, rq, req->ddp.sg_table.sgl);
> >
> >       ret = netdev->tcp_ddp_ops->tcp_ddp_setup(netdev,
> >                                                queue->sock->sk,

> > @@ -1088,17 +1148,29 @@ static int nvme_tcp_recv_ddgst(struct nvme_tcp_queue *queue,
> >       if (queue->ddgst_remaining)
> >               return 0;
> >
> > -     if (queue->recv_ddgst != queue->exp_ddgst) {
> > -             dev_err(queue->ctrl->ctrl.device,
> > -                     "data digest error: recv %#x expected %#x\n",
> > -                     le32_to_cpu(queue->recv_ddgst),
> > -                     le32_to_cpu(queue->exp_ddgst));
> > -             return -EIO;
> > +     offload_fail = !nvme_tcp_ddp_ddgst_ok(queue);
> > +     offload_en = test_bit(NVME_TCP_Q_OFF_DDGST_RX, &queue->flags);
> > +     if (!offload_en || offload_fail) {
> > +             if (offload_en && offload_fail) { // software-fallback
> > +                     rq = blk_mq_tag_to_rq(nvme_tcp_tagset(queue),
> > +                                           pdu->command_id);
> > +                     nvme_tcp_ddp_ddgst_recalc(queue->rcv_hash, rq);
> > +             }
> > +
> > +             nvme_tcp_ddgst_final(queue->rcv_hash, &queue->exp_ddgst);
> > +             if (queue->recv_ddgst != queue->exp_ddgst) {
> > +                     dev_err(queue->ctrl->ctrl.device,
> > +                             "data digest error: recv %#x expected %#x\n",
> > +                             le32_to_cpu(queue->recv_ddgst),
> > +                             le32_to_cpu(queue->exp_ddgst));
> > +                     return -EIO;
> > +             }
>
> I still dislike this hunk. Can you split the recalc login to its
> own ddp function at least? This is just a confusing piece of code.

mmm, we added two boolean predicates (offload_en and
offload_failed) plus a comment (software-fallback)
to clarify this piece... thought it can fly

> >       if (pdu->hdr.flags & NVME_TCP_F_DATA_SUCCESS) {
> > -             struct request *rq = blk_mq_tag_to_rq(nvme_tcp_tagset(queue),
> > -                                             pdu->command_id);
> > +             if (!rq)
> > +                     rq = blk_mq_tag_to_rq(nvme_tcp_tagset(queue),
> > +                                           pdu->command_id);
>
> Why is this change needed? Maybe just move this assignment up?

OK will move it up
