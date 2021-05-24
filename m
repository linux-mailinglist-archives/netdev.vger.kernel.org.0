Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8D938F421
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 22:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233103AbhEXUR4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 16:17:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232929AbhEXURz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 16:17:55 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 193D5C061574
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 13:16:26 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id f18so13527286ejq.10
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 13:16:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Zhg3kt/W/GK4IF7L6dH9qxWKjSC9ZNd1BZp+AZhD4XE=;
        b=BisjhHqGBBA+eja/R47WRZJ7pQO2DyAL9dUJ/9KNHYUOFbqzXE+qtuT1CxBZH453oq
         /kL64jfcNo02pCqdqwC3bLrnH6rkKfbDz08kOHdHY+xgrXL3ybtZhHkgJ0cM9/2CaOU3
         p6hRqGJTdk4V1au1ebBzaVBHaAeww5aGl22htOqtlWtWSXR6RD1z+GDqeqIiFANDPHw4
         abhRVsHnlRtfGPFhiP0rwwONtJdZy7IYcNitjxQAxFDpvNWhbOOmayWavcI/5zW0QxZP
         BTy6OjUtfCyzTIGCIAOTG6+WHGFqoc83FewB7/VHM3M5Mx5bPc3a5HhlavTvw6SGfgA1
         p2PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Zhg3kt/W/GK4IF7L6dH9qxWKjSC9ZNd1BZp+AZhD4XE=;
        b=CUkJnu2UayhextPhL8AVBvgLvLA9l2l7u/Mf2KlxirAF+SMEEOlJFHNqkOFn+MhRbC
         7RxMvjk8Tg1aa0e1XBO8q0Zfigqjq6RC3Dyi4lWJVxhIwbjjodcTi0zPMP1q4wyLcUTn
         n3ZT9Q0eQ/+TBH+hvImYgcTAsOdDOqw4N3YOPGY1/XcH82pCkj3volb3b6T0m9AMZY71
         RAmiy6dhJ+zdl8xsJ6de+oAHOiKUviiagDEOvSgizLeiMY4sBULawXJEYoEF0oZ3NiMM
         56XndU80o1AmTrQ86dw8WDIRZoDk7P0kcTxRrQuOneRmLkhlL9ToXYJZ+OkvOp8C1lB9
         Eagg==
X-Gm-Message-State: AOAM5330h6dOud5VYZ+rwwZsP2KpgSo+8MTE9dp5Nq9sx64dPE2p2vKk
        AFIqHvmoUWXY1mNZeRouc2mP3PbLkfa/fWF6/5U=
X-Google-Smtp-Source: ABdhPJy36r43VRIT+lHWbXdkoGA0a+I1YlMYe9ZPht6W1ccNQsy83pnzn5iJWtWx2bwmySaZx3La5YE0CljICBrogus=
X-Received: by 2002:a17:906:ccde:: with SMTP id ot30mr25754776ejb.353.1621887384445;
 Mon, 24 May 2021 13:16:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210519111340.20613-1-smalin@marvell.com> <20210519111340.20613-7-smalin@marvell.com>
 <68b04a31-e3a1-d42b-81e8-ec455284ab12@grimberg.me>
In-Reply-To: <68b04a31-e3a1-d42b-81e8-ec455284ab12@grimberg.me>
From:   Shai Malin <malin1024@gmail.com>
Date:   Mon, 24 May 2021 23:16:12 +0300
Message-ID: <CAKKgK4wDp7dr6rAmsXLbxprnD7qWfSP1wd6CfhdjHyVEFAnLEQ@mail.gmail.com>
Subject: Re: [RFC PATCH v5 06/27] nvme-tcp-offload: Add queue level implementation
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     netdev@vger.kernel.org, linux-nvme@lists.infradead.org,
        davem@davemloft.net, kuba@kernel.org, hch@lst.de, axboe@fb.com,
        kbusch@kernel.org, Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>, okulkarni@marvell.com,
        pkushwaha@marvell.com, Dean Balandin <dbalandin@marvell.com>,
        Shai Malin <smalin@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/22/21 1:49 AM, Sagi Grimberg wrote:
> On 5/19/21 4:13 AM, Shai Malin wrote:
> > From: Dean Balandin <dbalandin@marvell.com>
> >
> > In this patch we implement queue level functionality.
> > The implementation is similar to the nvme-tcp module, the main
> > difference being that we call the vendor specific create_queue op which
> > creates the TCP connection, and NVMeTPC connection including
> > icreq+icresp negotiation.
> > Once create_queue returns successfully, we can move on to the fabrics
> > connect.
> >
> > Acked-by: Igor Russkikh <irusskikh@marvell.com>
> > Signed-off-by: Dean Balandin <dbalandin@marvell.com>
> > Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> > Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
> > Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
> > Signed-off-by: Ariel Elior <aelior@marvell.com>
> > Signed-off-by: Shai Malin <smalin@marvell.com>
> > ---
> >   drivers/nvme/host/tcp-offload.c | 424 ++++++++++++++++++++++++++++++-=
-
> >   drivers/nvme/host/tcp-offload.h |   1 +
> >   2 files changed, 399 insertions(+), 26 deletions(-)
> >
> > diff --git a/drivers/nvme/host/tcp-offload.c b/drivers/nvme/host/tcp-of=
fload.c
> > index 9eb4b03e0f3d..8ed7668d987a 100644
> > --- a/drivers/nvme/host/tcp-offload.c
> > +++ b/drivers/nvme/host/tcp-offload.c
> > @@ -22,6 +22,11 @@ static inline struct nvme_tcp_ofld_ctrl *to_tcp_ofld=
_ctrl(struct nvme_ctrl *nctr
> >       return container_of(nctrl, struct nvme_tcp_ofld_ctrl, nctrl);
> >   }
> >
> > +static inline int nvme_tcp_ofld_qid(struct nvme_tcp_ofld_queue *queue)
> > +{
> > +     return queue - queue->ctrl->queues;
> > +}
> > +
> >   /**
> >    * nvme_tcp_ofld_register_dev() - NVMeTCP Offload Library registratio=
n
> >    * function.
> > @@ -191,12 +196,94 @@ nvme_tcp_ofld_alloc_tagset(struct nvme_ctrl *nctr=
l, bool admin)
> >       return set;
> >   }
> >
> > +static void __nvme_tcp_ofld_stop_queue(struct nvme_tcp_ofld_queue *que=
ue)
> > +{
> > +     queue->dev->ops->drain_queue(queue);
> > +     queue->dev->ops->destroy_queue(queue);
>
> Stop calls drain+destroy? is that something that is specific to
> your implementation? If this is designed to effectively stop
> the queue from generating completions and accessing host memory,
> why is it called destroy?

In our design, destroy_queue is a blocking call that will stop the queue fr=
om
generating completions, accessing host memory and will also destroy the TCP
connection.
Practically we don=E2=80=99t need the drain_queue() for qedn.
It was added for any future vendor driver. We can remove the drain_queue()
if you think it's not needed or we can call it in a different location.

>
> > +}
> > +
> > +static void nvme_tcp_ofld_stop_queue(struct nvme_ctrl *nctrl, int qid)
> > +{
> > +     struct nvme_tcp_ofld_ctrl *ctrl =3D to_tcp_ofld_ctrl(nctrl);
> > +     struct nvme_tcp_ofld_queue *queue =3D &ctrl->queues[qid];
> > +
> > +     if (!test_and_clear_bit(NVME_TCP_OFLD_Q_LIVE, &queue->flags))
> > +             return;
> > +
> > +     __nvme_tcp_ofld_stop_queue(queue);
> > +}
> > +
> > +static void nvme_tcp_ofld_stop_io_queues(struct nvme_ctrl *ctrl)
> > +{
> > +     int i;
> > +
> > +     for (i =3D 1; i < ctrl->queue_count; i++)
> > +             nvme_tcp_ofld_stop_queue(ctrl, i);
> > +}
> > +
> > +static void nvme_tcp_ofld_free_queue(struct nvme_ctrl *nctrl, int qid)
> > +{
> > +     struct nvme_tcp_ofld_ctrl *ctrl =3D to_tcp_ofld_ctrl(nctrl);
> > +     struct nvme_tcp_ofld_queue *queue =3D &ctrl->queues[qid];
> > +
> > +     if (!test_and_clear_bit(NVME_TCP_OFLD_Q_ALLOCATED, &queue->flags)=
)
> > +             return;
> > +
> > +     queue =3D &ctrl->queues[qid];
> > +     queue->ctrl =3D NULL;
> > +     queue->dev =3D NULL;
> > +     queue->report_err =3D NULL;
>
> Why are these needed? In what scenario are these accessed from a non
> established queue?

We will remove it.

>
> > +}
> > +
> > +static void nvme_tcp_ofld_destroy_admin_queue(struct nvme_ctrl *nctrl,=
 bool remove)
> > +{
> > +     nvme_tcp_ofld_stop_queue(nctrl, 0);
> > +     if (remove) {
> > +             blk_cleanup_queue(nctrl->admin_q);
> > +             blk_cleanup_queue(nctrl->fabrics_q);
> > +             blk_mq_free_tag_set(nctrl->admin_tagset);
> > +     }
> > +}
> > +
> > +static int nvme_tcp_ofld_start_queue(struct nvme_ctrl *nctrl, int qid)
> > +{
> > +     struct nvme_tcp_ofld_ctrl *ctrl =3D to_tcp_ofld_ctrl(nctrl);
> > +     struct nvme_tcp_ofld_queue *queue =3D &ctrl->queues[qid];
> > +     int rc;
> > +
> > +     queue =3D &ctrl->queues[qid];
> > +     if (qid) {
> > +             queue->cmnd_capsule_len =3D nctrl->ioccsz * 16;
> > +             rc =3D nvmf_connect_io_queue(nctrl, qid, false);
> > +     } else {
> > +             queue->cmnd_capsule_len =3D sizeof(struct nvme_command) +=
 NVME_TCP_ADMIN_CCSZ;
> > +             rc =3D nvmf_connect_admin_queue(nctrl);
> > +     }
> > +
> > +     if (!rc) {
> > +             set_bit(NVME_TCP_OFLD_Q_LIVE, &queue->flags);
> > +     } else {
> > +             if (test_bit(NVME_TCP_OFLD_Q_ALLOCATED, &queue->flags))
> > +                     __nvme_tcp_ofld_stop_queue(queue);
> > +             dev_err(nctrl->device,
> > +                     "failed to connect queue: %d ret=3D%d\n", qid, rc=
);
> > +     }
> > +
> > +     return rc;
> > +}
> > +
> >   static int nvme_tcp_ofld_configure_admin_queue(struct nvme_ctrl *nctr=
l,
> >                                              bool new)
> >   {
> > +     struct nvme_tcp_ofld_ctrl *ctrl =3D to_tcp_ofld_ctrl(nctrl);
> > +     struct nvme_tcp_ofld_queue *queue =3D &ctrl->queues[0];
> >       int rc;
> >
> > -     /* Placeholder - alloc_admin_queue */
> > +     rc =3D ctrl->dev->ops->create_queue(queue, 0, NVME_AQ_DEPTH);
> > +     if (rc)
> > +             return rc;
> > +
> > +     set_bit(NVME_TCP_OFLD_Q_ALLOCATED, &queue->flags);
> >       if (new) {
> >               nctrl->admin_tagset =3D
> >                               nvme_tcp_ofld_alloc_tagset(nctrl, true);
> > @@ -221,7 +308,9 @@ static int nvme_tcp_ofld_configure_admin_queue(stru=
ct nvme_ctrl *nctrl,
> >               }
> >       }
> >
> > -     /* Placeholder - nvme_tcp_ofld_start_queue */
> > +     rc =3D nvme_tcp_ofld_start_queue(nctrl, 0);
> > +     if (rc)
> > +             goto out_cleanup_queue;
> >
> >       rc =3D nvme_enable_ctrl(nctrl);
> >       if (rc)
> > @@ -238,11 +327,12 @@ static int nvme_tcp_ofld_configure_admin_queue(st=
ruct nvme_ctrl *nctrl,
> >   out_quiesce_queue:
> >       blk_mq_quiesce_queue(nctrl->admin_q);
> >       blk_sync_queue(nctrl->admin_q);
> > -
> >   out_stop_queue:
> > -     /* Placeholder - stop offload queue */
> > +     nvme_tcp_ofld_stop_queue(nctrl, 0);
> >       nvme_cancel_admin_tagset(nctrl);
> > -
> > +out_cleanup_queue:
> > +     if (new)
> > +             blk_cleanup_queue(nctrl->admin_q);
> >   out_cleanup_fabrics_q:
> >       if (new)
> >               blk_cleanup_queue(nctrl->fabrics_q);
> > @@ -250,7 +340,136 @@ static int nvme_tcp_ofld_configure_admin_queue(st=
ruct nvme_ctrl *nctrl,
> >       if (new)
> >               blk_mq_free_tag_set(nctrl->admin_tagset);
> >   out_free_queue:
> > -     /* Placeholder - free admin queue */
> > +     nvme_tcp_ofld_free_queue(nctrl, 0);
> > +
> > +     return rc;
> > +}
> > +
> > +static unsigned int nvme_tcp_ofld_nr_io_queues(struct nvme_ctrl *nctrl=
)
> > +{
> > +     struct nvme_tcp_ofld_ctrl *ctrl =3D to_tcp_ofld_ctrl(nctrl);
> > +     struct nvme_tcp_ofld_dev *dev =3D ctrl->dev;
> > +     u32 hw_vectors =3D dev->num_hw_vectors;
> > +     u32 nr_write_queues, nr_poll_queues;
> > +     u32 nr_io_queues, nr_total_queues;
> > +
> > +     nr_io_queues =3D min3(nctrl->opts->nr_io_queues, num_online_cpus(=
),
> > +                         hw_vectors);
> > +     nr_write_queues =3D min3(nctrl->opts->nr_write_queues, num_online=
_cpus(),
> > +                            hw_vectors);
> > +     nr_poll_queues =3D min3(nctrl->opts->nr_poll_queues, num_online_c=
pus(),
> > +                           hw_vectors);
> > +
> > +     nr_total_queues =3D nr_io_queues + nr_write_queues + nr_poll_queu=
es;
> > +
> > +     return nr_total_queues;
> > +}
> > +
> > +static void
> > +nvme_tcp_ofld_set_io_queues(struct nvme_ctrl *nctrl, unsigned int nr_i=
o_queues)
> > +{
> > +     struct nvme_tcp_ofld_ctrl *ctrl =3D to_tcp_ofld_ctrl(nctrl);
> > +     struct nvmf_ctrl_options *opts =3D nctrl->opts;
> > +
> > +     if (opts->nr_write_queues && opts->nr_io_queues < nr_io_queues) {
> > +             /*
> > +              * separate read/write queues
> > +              * hand out dedicated default queues only after we have
> > +              * sufficient read queues.
> > +              */
> > +             ctrl->io_queues[HCTX_TYPE_READ] =3D opts->nr_io_queues;
> > +             nr_io_queues -=3D ctrl->io_queues[HCTX_TYPE_READ];
> > +             ctrl->io_queues[HCTX_TYPE_DEFAULT] =3D
> > +                     min(opts->nr_write_queues, nr_io_queues);
> > +             nr_io_queues -=3D ctrl->io_queues[HCTX_TYPE_DEFAULT];
> > +     } else {
> > +             /*
> > +              * shared read/write queues
> > +              * either no write queues were requested, or we don't hav=
e
> > +              * sufficient queue count to have dedicated default queue=
s.
> > +              */
> > +             ctrl->io_queues[HCTX_TYPE_DEFAULT] =3D
> > +                     min(opts->nr_io_queues, nr_io_queues);
> > +             nr_io_queues -=3D ctrl->io_queues[HCTX_TYPE_DEFAULT];
> > +     }
> > +
> > +     if (opts->nr_poll_queues && nr_io_queues) {
> > +             /* map dedicated poll queues only if we have queues left =
*/
> > +             ctrl->io_queues[HCTX_TYPE_POLL] =3D
> > +                     min(opts->nr_poll_queues, nr_io_queues);
> > +     }
> > +}
> > +
> > +static void
> > +nvme_tcp_ofld_terminate_io_queues(struct nvme_ctrl *nctrl, int start_f=
rom)
> > +{
> > +     int i;
> > +
> > +     /* Loop condition will stop before index 0 which is the admin que=
ue */
> > +     for (i =3D start_from; i >=3D 1; i--)
> > +             nvme_tcp_ofld_stop_queue(nctrl, i);
> > +}
> > +
> > +static int nvme_tcp_ofld_create_io_queues(struct nvme_ctrl *nctrl)
> > +{
> > +     struct nvme_tcp_ofld_ctrl *ctrl =3D to_tcp_ofld_ctrl(nctrl);
> > +     int i, rc;
> > +
> > +     for (i =3D 1; i < nctrl->queue_count; i++) {
> > +             rc =3D ctrl->dev->ops->create_queue(&ctrl->queues[i],
> > +                                               i, nctrl->sqsize + 1);
> > +             if (rc)
> > +                     goto out_free_queues;
> > +
> > +             set_bit(NVME_TCP_OFLD_Q_ALLOCATED, &ctrl->queues[i].flags=
);
> > +     }
> > +
> > +     return 0;
> > +
> > +out_free_queues:
> > +     nvme_tcp_ofld_terminate_io_queues(nctrl, --i);
> > +
> > +     return rc;
> > +}
> > +
> > +static int nvme_tcp_ofld_alloc_io_queues(struct nvme_ctrl *nctrl)
> > +{
> > +     unsigned int nr_io_queues;
> > +     int rc;
> > +
> > +     nr_io_queues =3D nvme_tcp_ofld_nr_io_queues(nctrl);
> > +     rc =3D nvme_set_queue_count(nctrl, &nr_io_queues);
> > +     if (rc)
> > +             return rc;
> > +
> > +     nctrl->queue_count =3D nr_io_queues + 1;
> > +     if (nctrl->queue_count < 2) {
> > +             dev_err(nctrl->device,
> > +                     "unable to set any I/O queues\n");
> > +
> > +             return -ENOMEM;
> > +     }
> > +
> > +     dev_info(nctrl->device, "creating %d I/O queues.\n", nr_io_queues=
);
> > +     nvme_tcp_ofld_set_io_queues(nctrl, nr_io_queues);
> > +
> > +     return nvme_tcp_ofld_create_io_queues(nctrl);
> > +}
> > +
> > +static int nvme_tcp_ofld_start_io_queues(struct nvme_ctrl *nctrl)
> > +{
> > +     int i, rc =3D 0;
> > +
> > +     for (i =3D 1; i < nctrl->queue_count; i++) {
> > +             rc =3D nvme_tcp_ofld_start_queue(nctrl, i);
> > +             if (rc)
> > +                     goto terminate_queues;
> > +     }
> > +
> > +     return 0;
> > +
> > +terminate_queues:
> > +     nvme_tcp_ofld_terminate_io_queues(nctrl, --i);
> >
> >       return rc;
> >   }
> > @@ -258,9 +477,10 @@ static int nvme_tcp_ofld_configure_admin_queue(str=
uct nvme_ctrl *nctrl,
> >   static int
> >   nvme_tcp_ofld_configure_io_queues(struct nvme_ctrl *nctrl, bool new)
> >   {
> > -     int rc;
> > +     int rc =3D nvme_tcp_ofld_alloc_io_queues(nctrl);
> >
> > -     /* Placeholder - alloc_io_queues */
> > +     if (rc)
> > +             return rc;
> >
> >       if (new) {
> >               nctrl->tagset =3D nvme_tcp_ofld_alloc_tagset(nctrl, false=
);
> > @@ -278,7 +498,9 @@ nvme_tcp_ofld_configure_io_queues(struct nvme_ctrl =
*nctrl, bool new)
> >               }
> >       }
> >
> > -     /* Placeholder - start_io_queues */
> > +     rc =3D nvme_tcp_ofld_start_io_queues(nctrl);
> > +     if (rc)
> > +             goto out_cleanup_connect_q;
> >
> >       if (!new) {
> >               nvme_start_queues(nctrl);
> > @@ -300,16 +522,16 @@ nvme_tcp_ofld_configure_io_queues(struct nvme_ctr=
l *nctrl, bool new)
> >   out_wait_freeze_timed_out:
> >       nvme_stop_queues(nctrl);
> >       nvme_sync_io_queues(nctrl);
> > -
> > -     /* Placeholder - Stop IO queues */
> > -
> > +     nvme_tcp_ofld_stop_io_queues(nctrl);
> > +out_cleanup_connect_q:
> > +     nvme_cancel_tagset(nctrl);
> >       if (new)
> >               blk_cleanup_queue(nctrl->connect_q);
> >   out_free_tag_set:
> >       if (new)
> >               blk_mq_free_tag_set(nctrl->tagset);
> >   out_free_io_queues:
> > -     /* Placeholder - free_io_queues */
> > +     nvme_tcp_ofld_terminate_io_queues(nctrl, nctrl->queue_count);
> >
> >       return rc;
> >   }
> > @@ -336,6 +558,26 @@ static void nvme_tcp_ofld_reconnect_or_remove(stru=
ct nvme_ctrl *nctrl)
> >       }
> >   }
> >
> > +static int
> > +nvme_tcp_ofld_init_admin_hctx(struct blk_mq_hw_ctx *hctx, void *data,
> > +                           unsigned int hctx_idx)
> > +{
> > +     struct nvme_tcp_ofld_ctrl *ctrl =3D data;
> > +
> > +     hctx->driver_data =3D &ctrl->queues[0];
> > +
> > +     return 0;
> > +}
> > +
> > +static void nvme_tcp_ofld_destroy_io_queues(struct nvme_ctrl *nctrl, b=
ool remove)
> > +{
> > +     nvme_tcp_ofld_stop_io_queues(nctrl);
> > +     if (remove) {
> > +             blk_cleanup_queue(nctrl->connect_q);
> > +             blk_mq_free_tag_set(nctrl->tagset);
> > +     }
> > +}
> > +
> >   static int nvme_tcp_ofld_setup_ctrl(struct nvme_ctrl *nctrl, bool new=
)
> >   {
> >       struct nvmf_ctrl_options *opts =3D nctrl->opts;
> > @@ -392,9 +634,19 @@ static int nvme_tcp_ofld_setup_ctrl(struct nvme_ct=
rl *nctrl, bool new)
> >       return 0;
> >
> >   destroy_io:
> > -     /* Placeholder - stop and destroy io queues*/
> > +     if (nctrl->queue_count > 1) {
> > +             nvme_stop_queues(nctrl);
> > +             nvme_sync_io_queues(nctrl);
> > +             nvme_tcp_ofld_stop_io_queues(nctrl);
> > +             nvme_cancel_tagset(nctrl);
> > +             nvme_tcp_ofld_destroy_io_queues(nctrl, new);
> > +     }
> >   destroy_admin:
> > -     /* Placeholder - stop and destroy admin queue*/
> > +     blk_mq_quiesce_queue(nctrl->admin_q);
> > +     blk_sync_queue(nctrl->admin_q);
> > +     nvme_tcp_ofld_stop_queue(nctrl, 0);
> > +     nvme_cancel_admin_tagset(nctrl);
> > +     nvme_tcp_ofld_destroy_admin_queue(nctrl, new);
> >
> >       return rc;
> >   }
> > @@ -415,6 +667,18 @@ nvme_tcp_ofld_check_dev_opts(struct nvmf_ctrl_opti=
ons *opts,
> >       return 0;
> >   }
> >
> > +static void nvme_tcp_ofld_free_ctrl_queues(struct nvme_ctrl *nctrl)
> > +{
> > +     struct nvme_tcp_ofld_ctrl *ctrl =3D to_tcp_ofld_ctrl(nctrl);
> > +     int i;
> > +
> > +     for (i =3D 0; i < nctrl->queue_count; ++i)
> > +             nvme_tcp_ofld_free_queue(nctrl, i);
> > +
> > +     kfree(ctrl->queues);
> > +     ctrl->queues =3D NULL;
> > +}
> > +
> >   static void nvme_tcp_ofld_free_ctrl(struct nvme_ctrl *nctrl)
> >   {
> >       struct nvme_tcp_ofld_ctrl *ctrl =3D to_tcp_ofld_ctrl(nctrl);
> > @@ -424,6 +688,7 @@ static void nvme_tcp_ofld_free_ctrl(struct nvme_ctr=
l *nctrl)
> >               goto free_ctrl;
> >
> >       down_write(&nvme_tcp_ofld_ctrl_rwsem);
> > +     nvme_tcp_ofld_free_ctrl_queues(nctrl);
> >       ctrl->dev->ops->release_ctrl(ctrl);
> >       list_del(&ctrl->list);
> >       up_write(&nvme_tcp_ofld_ctrl_rwsem);
> > @@ -441,15 +706,37 @@ static void nvme_tcp_ofld_submit_async_event(stru=
ct nvme_ctrl *arg)
> >   }
> >
> >   static void
> > -nvme_tcp_ofld_teardown_admin_queue(struct nvme_ctrl *ctrl, bool remove=
)
> > +nvme_tcp_ofld_teardown_admin_queue(struct nvme_ctrl *nctrl, bool remov=
e)
> >   {
> > -     /* Placeholder - teardown_admin_queue */
> > +     blk_mq_quiesce_queue(nctrl->admin_q);
> > +     blk_sync_queue(nctrl->admin_q);
> > +
> > +     nvme_tcp_ofld_stop_queue(nctrl, 0);
> > +     nvme_cancel_admin_tagset(nctrl);
> > +
> > +     if (remove)
> > +             blk_mq_unquiesce_queue(nctrl->admin_q);
> > +
> > +     nvme_tcp_ofld_destroy_admin_queue(nctrl, remove);
> >   }
> >
> >   static void
> >   nvme_tcp_ofld_teardown_io_queues(struct nvme_ctrl *nctrl, bool remove=
)
> >   {
> > -     /* Placeholder - teardown_io_queues */
> > +     if (nctrl->queue_count <=3D 1)
> > +             return;
> > +
> > +     blk_mq_quiesce_queue(nctrl->admin_q);
> > +     nvme_start_freeze(nctrl);
> > +     nvme_stop_queues(nctrl);
> > +     nvme_sync_io_queues(nctrl);
> > +     nvme_tcp_ofld_stop_io_queues(nctrl);
> > +     nvme_cancel_tagset(nctrl);
> > +
> > +     if (remove)
> > +             nvme_start_queues(nctrl);
> > +
> > +     nvme_tcp_ofld_destroy_io_queues(nctrl, remove);
> >   }
> >
> >   static void nvme_tcp_ofld_reconnect_ctrl_work(struct work_struct *wor=
k)
> > @@ -577,6 +864,17 @@ nvme_tcp_ofld_init_request(struct blk_mq_tag_set *=
set,
> >       return 0;
> >   }
> >
> > +inline size_t nvme_tcp_ofld_inline_data_size(struct nvme_tcp_ofld_queu=
e *queue)
> > +{
> > +     return queue->cmnd_capsule_len - sizeof(struct nvme_command);
> > +}
> > +EXPORT_SYMBOL_GPL(nvme_tcp_ofld_inline_data_size);
> > +
> > +static void nvme_tcp_ofld_commit_rqs(struct blk_mq_hw_ctx *hctx)
> > +{
> > +     /* Call ops->commit_rqs */
> > +}
> > +
> >   static blk_status_t
> >   nvme_tcp_ofld_queue_rq(struct blk_mq_hw_ctx *hctx,
> >                      const struct blk_mq_queue_data *bd)
> > @@ -588,22 +886,96 @@ nvme_tcp_ofld_queue_rq(struct blk_mq_hw_ctx *hctx=
,
> >       return BLK_STS_OK;
> >   }
> >
> > +static void
> > +nvme_tcp_ofld_exit_request(struct blk_mq_tag_set *set,
> > +                        struct request *rq, unsigned int hctx_idx)
> > +{
> > +     /*
> > +      * Nothing is allocated in nvme_tcp_ofld_init_request,
> > +      * hence empty.
> > +      */
> > +}
> > +
> > +static int
> > +nvme_tcp_ofld_init_hctx(struct blk_mq_hw_ctx *hctx, void *data,
> > +                     unsigned int hctx_idx)
> > +{
> > +     struct nvme_tcp_ofld_ctrl *ctrl =3D data;
> > +
> > +     hctx->driver_data =3D &ctrl->queues[hctx_idx + 1];
> > +
> > +     return 0;
> > +}
> > +
> > +static int nvme_tcp_ofld_map_queues(struct blk_mq_tag_set *set)
> > +{
> > +     struct nvme_tcp_ofld_ctrl *ctrl =3D set->driver_data;
> > +     struct nvmf_ctrl_options *opts =3D ctrl->nctrl.opts;
> > +
> > +     if (opts->nr_write_queues && ctrl->io_queues[HCTX_TYPE_READ]) {
> > +             /* separate read/write queues */
> > +             set->map[HCTX_TYPE_DEFAULT].nr_queues =3D
> > +                     ctrl->io_queues[HCTX_TYPE_DEFAULT];
> > +             set->map[HCTX_TYPE_DEFAULT].queue_offset =3D 0;
> > +             set->map[HCTX_TYPE_READ].nr_queues =3D
> > +                     ctrl->io_queues[HCTX_TYPE_READ];
> > +             set->map[HCTX_TYPE_READ].queue_offset =3D
> > +                     ctrl->io_queues[HCTX_TYPE_DEFAULT];
> > +     } else {
> > +             /* shared read/write queues */
> > +             set->map[HCTX_TYPE_DEFAULT].nr_queues =3D
> > +                     ctrl->io_queues[HCTX_TYPE_DEFAULT];
> > +             set->map[HCTX_TYPE_DEFAULT].queue_offset =3D 0;
> > +             set->map[HCTX_TYPE_READ].nr_queues =3D
> > +                     ctrl->io_queues[HCTX_TYPE_DEFAULT];
> > +             set->map[HCTX_TYPE_READ].queue_offset =3D 0;
> > +     }
> > +     blk_mq_map_queues(&set->map[HCTX_TYPE_DEFAULT]);
> > +     blk_mq_map_queues(&set->map[HCTX_TYPE_READ]);
> > +
> > +     if (opts->nr_poll_queues && ctrl->io_queues[HCTX_TYPE_POLL]) {
> > +             /* map dedicated poll queues only if we have queues left =
*/
> > +             set->map[HCTX_TYPE_POLL].nr_queues =3D
> > +                             ctrl->io_queues[HCTX_TYPE_POLL];
> > +             set->map[HCTX_TYPE_POLL].queue_offset =3D
> > +                     ctrl->io_queues[HCTX_TYPE_DEFAULT] +
> > +                     ctrl->io_queues[HCTX_TYPE_READ];
> > +             blk_mq_map_queues(&set->map[HCTX_TYPE_POLL]);
> > +     }
> > +
> > +     dev_info(ctrl->nctrl.device,
> > +              "mapped %d/%d/%d default/read/poll queues.\n",
> > +              ctrl->io_queues[HCTX_TYPE_DEFAULT],
> > +              ctrl->io_queues[HCTX_TYPE_READ],
> > +              ctrl->io_queues[HCTX_TYPE_POLL]);
> > +
> > +     return 0;
> > +}
> > +
> > +static int nvme_tcp_ofld_poll(struct blk_mq_hw_ctx *hctx)
> > +{
> > +     /* Placeholder - Implement polling mechanism */
> > +
> > +     return 0;
> > +}
> > +
> >   static struct blk_mq_ops nvme_tcp_ofld_mq_ops =3D {
> >       .queue_rq       =3D nvme_tcp_ofld_queue_rq,
> > +     .commit_rqs     =3D nvme_tcp_ofld_commit_rqs,
> > +     .complete       =3D nvme_complete_rq,
> >       .init_request   =3D nvme_tcp_ofld_init_request,
> > -     /*
> > -      * All additional ops will be also implemented and registered sim=
ilar to
> > -      * tcp.c
> > -      */
> > +     .exit_request   =3D nvme_tcp_ofld_exit_request,
> > +     .init_hctx      =3D nvme_tcp_ofld_init_hctx,
> > +     .map_queues     =3D nvme_tcp_ofld_map_queues,
> > +     .poll           =3D nvme_tcp_ofld_poll,
> >   };
> >
> >   static struct blk_mq_ops nvme_tcp_ofld_admin_mq_ops =3D {
> >       .queue_rq       =3D nvme_tcp_ofld_queue_rq,
> > +     .complete       =3D nvme_complete_rq,
> >       .init_request   =3D nvme_tcp_ofld_init_request,
> > -     /*
> > -      * All additional ops will be also implemented and registered sim=
ilar to
> > -      * tcp.c
> > -      */
> > +     .exit_request   =3D nvme_tcp_ofld_exit_request,
> > +     .init_hctx      =3D nvme_tcp_ofld_init_admin_hctx,
> >   };
> >
> >   static const struct nvme_ctrl_ops nvme_tcp_ofld_ctrl_ops =3D {
> > diff --git a/drivers/nvme/host/tcp-offload.h b/drivers/nvme/host/tcp-of=
fload.h
> > index 2a931d05905d..2233d855aa10 100644
> > --- a/drivers/nvme/host/tcp-offload.h
> > +++ b/drivers/nvme/host/tcp-offload.h
> > @@ -211,3 +211,4 @@ struct nvme_tcp_ofld_ops {
> >   int nvme_tcp_ofld_register_dev(struct nvme_tcp_ofld_dev *dev);
> >   void nvme_tcp_ofld_unregister_dev(struct nvme_tcp_ofld_dev *dev);
> >   void nvme_tcp_ofld_error_recovery(struct nvme_ctrl *nctrl);
> > +inline size_t nvme_tcp_ofld_inline_data_size(struct nvme_tcp_ofld_queu=
e *queue);
> >
