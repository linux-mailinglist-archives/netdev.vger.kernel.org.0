Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAC00396304
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 17:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232659AbhEaPDJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 11:03:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234210AbhEaPBF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 11:01:05 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8B42C00F788
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 07:04:14 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id b11so6814831edy.4
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 07:04:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=lEUyB7p/lvndzywXJwKKhhvKvo7jpaxyCinyPZn8o6k=;
        b=GrMFAKBeagK/70KFNi7UCG7M1/zmZkI1quCu3JoOAEbN9dg1FiOzbeD2Yo3payT7+m
         ubtwlbh5D1p80i4K33/B+6f5xgdmMA4bvspq2Yr9C0JGzUmXyArP2Y5Ev4RBgZBaDkjG
         FYCOeQImLX/i9Qj/AEfem/U41VFw6Tv2luWqeNxouKbTLoB3bQTnE3vJBj5UoQJV5l2g
         cWREo6IvJGcHpNLyrPqZJHpj1tGf/35tx31ZgCu0fweFhfbhwD9Ki9dQoY+Et7kyxTYL
         FgpbZRGdVNS+vFdvxbm7mOHohPH1MPfahFd6C3YKvUKkGQKAHePV4F5J9GqrhbR42Jf2
         YL1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=lEUyB7p/lvndzywXJwKKhhvKvo7jpaxyCinyPZn8o6k=;
        b=fxxWREIJK6wWVIuoqxhl9KkW3wv2nRZeEm8QPHW0H4oskP1q8M+iS4KHrLd2//Nv7h
         iN6l3iPmUC2LuZkMIfOqyRJbznRjPTiJVd5A/U/SJkc/OdL4XsvzuaK0ysYmRmsZR2fY
         KkUJ/d1yh2qBqkFn+/bkOOglon0+kQEHT9b0jaTM9ChvA4XFZway5WUxVO8vkr6168Sr
         Rsb94YSBbyJ5p5y615jDrO7OOQkPTKZicgdeThepaP+rgYkWhN3sNrHXk4UgAbB9GhPD
         0flSYw9UNncma/vv1Xj0llsSVpZ1eotq9qoEa7nV7Bl5id/Dut8y3sDBXy0NqHJnlgPj
         +DNQ==
X-Gm-Message-State: AOAM532ZHdTY46paf1qIWUOcQQTdcR2TBjgQxoeIgLxdQ/MAFta3iEyE
        4Vh9e/NPUnXSTzJsZqOnERDCYmLbVhTsHswO4go=
X-Google-Smtp-Source: ABdhPJwVtqkPVm51woaxkzQhwxFPaK+xktB3JKPb+MyrkPzzjrsY3j3TRE6Uy7/yU3fnpJv/u/8F0pzRFR9WGhy+bEQ=
X-Received: by 2002:aa7:d610:: with SMTP id c16mr15949222edr.207.1622469853304;
 Mon, 31 May 2021 07:04:13 -0700 (PDT)
MIME-Version: 1.0
References: <20210527235902.2185-1-smalin@marvell.com> <20210527235902.2185-8-smalin@marvell.com>
 <4afc9965-cef6-1bba-9ab0-1272bfa6077f@suse.de>
In-Reply-To: <4afc9965-cef6-1bba-9ab0-1272bfa6077f@suse.de>
From:   Shai Malin <malin1024@gmail.com>
Date:   Mon, 31 May 2021 17:04:00 +0300
Message-ID: <CAKKgK4xEtWsn+eL24mroDYwQWev20ajzq6tZn7CEtG9sL3ybrA@mail.gmail.com>
Subject: Re: [RFC PATCH v6 07/27] nvme-tcp-offload: Add queue level implementation
To:     Hannes Reinecke <hare@suse.de>
Cc:     Shai Malin <smalin@marvell.com>, netdev@vger.kernel.org,
        linux-nvme@lists.infradead.org, davem@davemloft.net,
        kuba@kernel.org, Sagi Grimberg <sagi@grimberg.me>, hch@lst.de,
        axboe@fb.com, kbusch@kernel.org, Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>, okulkarni@marvell.com,
        pkushwaha@marvell.com, Dean Balandin <dbalandin@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/28/21 2:30 PM, Hannes Reinecke wrote:
> On 5/28/21 1:58 AM, Shai Malin wrote:
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
> > Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
> > ---
> >  drivers/nvme/host/tcp-offload.c | 418 +++++++++++++++++++++++++++++---
> >  drivers/nvme/host/tcp-offload.h |   4 +
> >  2 files changed, 394 insertions(+), 28 deletions(-)
> >
> > diff --git a/drivers/nvme/host/tcp-offload.c b/drivers/nvme/host/tcp-of=
fload.c
> > index 52d310f7636a..eff10e31f17f 100644
> > --- a/drivers/nvme/host/tcp-offload.c
> > +++ b/drivers/nvme/host/tcp-offload.c
> > @@ -22,6 +22,11 @@ static inline struct nvme_tcp_ofld_ctrl *to_tcp_ofld=
_ctrl(struct nvme_ctrl *nctr
> >       return container_of(nctrl, struct nvme_tcp_ofld_ctrl, nctrl);
> >  }
> >
> > +static inline int nvme_tcp_ofld_qid(struct nvme_tcp_ofld_queue *queue)
> > +{
> > +     return queue - queue->ctrl->queues;
> > +}
> > +
> >  /**
> >   * nvme_tcp_ofld_register_dev() - NVMeTCP Offload Library registration
> >   * function.
> > @@ -182,19 +187,125 @@ nvme_tcp_ofld_alloc_tagset(struct nvme_ctrl *nct=
rl, bool admin)
> >       return set;
> >  }
> >
> > +static void __nvme_tcp_ofld_stop_queue(struct nvme_tcp_ofld_queue *que=
ue)
> > +{
> > +     queue->dev->ops->drain_queue(queue);
> > +}
> > +
> > +static void nvme_tcp_ofld_stop_queue(struct nvme_ctrl *nctrl, int qid)
> > +{
> > +     struct nvme_tcp_ofld_ctrl *ctrl =3D to_tcp_ofld_ctrl(nctrl);
> > +     struct nvme_tcp_ofld_queue *queue =3D &ctrl->queues[qid];
> > +
> > +     mutex_lock(&queue->queue_lock);
> > +     if (test_and_clear_bit(NVME_TCP_OFLD_Q_LIVE, &queue->flags))
> > +             __nvme_tcp_ofld_stop_queue(queue);
> > +     mutex_unlock(&queue->queue_lock);
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
> > +static void __nvme_tcp_ofld_free_queue(struct nvme_tcp_ofld_queue *que=
ue)
> > +{
> > +     queue->dev->ops->destroy_queue(queue);
> > +}
> > +
> > +static void nvme_tcp_ofld_free_queue(struct nvme_ctrl *nctrl, int qid)
> > +{
> > +     struct nvme_tcp_ofld_ctrl *ctrl =3D to_tcp_ofld_ctrl(nctrl);
> > +     struct nvme_tcp_ofld_queue *queue =3D &ctrl->queues[qid];
> > +
> > +     test_and_clear_bit(NVME_TCP_OFLD_Q_ALLOCATED, &queue->flags);
>
> You really want to make this an 'if' clause to avoid double free

Thanks. Will be fixed.

>
> > +
> > +     __nvme_tcp_ofld_free_queue(queue);
> > +
> > +     mutex_destroy(&queue->queue_lock);
> > +}
> > +
> > +static void
> > +nvme_tcp_ofld_free_io_queues(struct nvme_ctrl *nctrl)
> > +{
> > +     int i;
> > +
> > +     for (i =3D 1; i < nctrl->queue_count; i++)
> > +             nvme_tcp_ofld_free_queue(nctrl, i);
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
> > +     nvme_tcp_ofld_free_io_queues(nctrl);
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
> > +     nvme_tcp_ofld_free_queue(nctrl, 0);
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
>
> Why do you need to call 'stop_queue' here?
> A failure indicates that the queue wasn't started, no?

It is in order to clear any pending requests. It's the same design as tcp.c=
.
Please refer commit f34e25898a6083("nvme-tcp: fix possible null deref on
a timed out io queue connect").

>
> > +             dev_err(nctrl->device,
> > +                     "failed to connect queue: %d ret=3D%d\n", qid, rc=
);
> > +     }
> > +
> > +     return rc;
> > +}
> > +
> >  static int nvme_tcp_ofld_configure_admin_queue(struct nvme_ctrl *nctrl=
,
> >                                              bool new)
> >  {
> > +     struct nvme_tcp_ofld_ctrl *ctrl =3D to_tcp_ofld_ctrl(nctrl);
> > +     struct nvme_tcp_ofld_queue *queue =3D &ctrl->queues[0];
> >       int rc;
> >
> > -     /* Placeholder - alloc_admin_queue */
> > +     mutex_init(&queue->queue_lock);
> > +
> > +     rc =3D ctrl->dev->ops->create_queue(queue, 0, NVME_AQ_DEPTH);
> > +     if (rc)
> > +             return rc;
> > +
> > +     set_bit(NVME_TCP_OFLD_Q_ALLOCATED, &queue->flags);
> >       if (new) {
> >               nctrl->admin_tagset =3D
> >                               nvme_tcp_ofld_alloc_tagset(nctrl, true);
> >               if (IS_ERR(nctrl->admin_tagset)) {
> >                       rc =3D PTR_ERR(nctrl->admin_tagset);
> >                       nctrl->admin_tagset =3D NULL;
> > -                     goto out_destroy_queue;
> > +                     goto out_free_queue;
> >               }
> >
> >               nctrl->fabrics_q =3D blk_mq_init_queue(nctrl->admin_tagse=
t);
> > @@ -212,7 +323,9 @@ static int nvme_tcp_ofld_configure_admin_queue(stru=
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
> > @@ -229,19 +342,143 @@ static int nvme_tcp_ofld_configure_admin_queue(s=
truct nvme_ctrl *nctrl,
> >  out_quiesce_queue:
> >       blk_mq_quiesce_queue(nctrl->admin_q);
> >       blk_sync_queue(nctrl->admin_q);
> > -
> >  out_stop_queue:
> > -     /* Placeholder - stop offload queue */
> > +     nvme_tcp_ofld_stop_queue(nctrl, 0);
> >       nvme_cancel_admin_tagset(nctrl);
> > -
> > +out_cleanup_queue:
> > +     if (new)
> > +             blk_cleanup_queue(nctrl->admin_q);
> >  out_cleanup_fabrics_q:
> >       if (new)
> >               blk_cleanup_queue(nctrl->fabrics_q);
> >  out_free_tagset:
> >       if (new)
> >               blk_mq_free_tag_set(nctrl->admin_tagset);
> > -out_destroy_queue:
> > -     /* Placeholder - free admin queue */
> > +out_free_queue:
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
> > +static int nvme_tcp_ofld_create_io_queues(struct nvme_ctrl *nctrl)
> > +{
> > +     struct nvme_tcp_ofld_ctrl *ctrl =3D to_tcp_ofld_ctrl(nctrl);
> > +     int i, rc;
> > +
> > +     for (i =3D 1; i < nctrl->queue_count; i++) {
> > +             mutex_init(&ctrl->queues[i].queue_lock);
> > +
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
> > +     for (i--; i >=3D 1; i--)
> > +             nvme_tcp_ofld_free_queue(nctrl, i);
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
> > +                     goto out_stop_queues;
> > +     }
> > +
> > +     return 0;
> > +
> > +out_stop_queues:
> > +     for (i--; i >=3D 1; i--)
> > +             nvme_tcp_ofld_stop_queue(nctrl, i);
> >
> >       return rc;
> >  }
> > @@ -249,9 +486,10 @@ static int nvme_tcp_ofld_configure_admin_queue(str=
uct nvme_ctrl *nctrl,
> >  static int
> >  nvme_tcp_ofld_configure_io_queues(struct nvme_ctrl *nctrl, bool new)
> >  {
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
> > @@ -269,7 +507,9 @@ nvme_tcp_ofld_configure_io_queues(struct nvme_ctrl =
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
> > @@ -291,16 +531,16 @@ nvme_tcp_ofld_configure_io_queues(struct nvme_ctr=
l *nctrl, bool new)
> >  out_wait_freeze_timed_out:
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
> >  out_free_tag_set:
> >       if (new)
> >               blk_mq_free_tag_set(nctrl->tagset);
> >  out_free_io_queues:
> > -     /* Placeholder - free_io_queues */
> > +     nvme_tcp_ofld_free_io_queues(nctrl);
> >
> >       return rc;
> >  }
> > @@ -327,6 +567,17 @@ static void nvme_tcp_ofld_reconnect_or_remove(stru=
ct nvme_ctrl *nctrl)
> >       }
> >  }
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
> >  static int nvme_tcp_ofld_setup_ctrl(struct nvme_ctrl *nctrl, bool new)
> >  {
> >       struct nvme_tcp_ofld_ctrl *ctrl =3D to_tcp_ofld_ctrl(nctrl);
> > @@ -388,9 +639,19 @@ static int nvme_tcp_ofld_setup_ctrl(struct nvme_ct=
rl *nctrl, bool new)
> >       return 0;
> >
> >  destroy_io:
> > -     /* Placeholder - stop and destroy io queues*/
> > +     if (nctrl->queue_count > 1) {
> > +             nvme_stop_queues(nctrl);
> > +             nvme_sync_io_queues(nctrl);
> > +             nvme_tcp_ofld_stop_io_queues(nctrl);
> > +             nvme_cancel_tagset(nctrl);
> > +             nvme_tcp_ofld_destroy_io_queues(nctrl, new);
> > +     }
> >  destroy_admin:
> > -     /* Placeholder - stop and destroy admin queue*/
> > +     blk_mq_quiesce_queue(nctrl->admin_q);
> > +     blk_sync_queue(nctrl->admin_q);
> > +     nvme_tcp_ofld_stop_queue(nctrl, 0);
> > +     nvme_cancel_admin_tagset(nctrl);
> > +     nvme_tcp_ofld_destroy_admin_queue(nctrl, new);
> >  out_release_ctrl:
> >       ctrl->dev->ops->release_ctrl(ctrl);
> >
> > @@ -439,15 +700,37 @@ static void nvme_tcp_ofld_free_ctrl(struct nvme_c=
trl *nctrl)
> >  }
> >
> >  static void
> > -nvme_tcp_ofld_teardown_admin_queue(struct nvme_ctrl *ctrl, bool remove=
)
> > +nvme_tcp_ofld_teardown_admin_queue(struct nvme_ctrl *nctrl, bool remov=
e)
> >  {
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
> >  }
> >
> >  static void
> >  nvme_tcp_ofld_teardown_io_queues(struct nvme_ctrl *nctrl, bool remove)
> >  {
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
>
> That looks odd.
> Surely all requests need to be flushed even for the not-remove case?

In the not-remove case nvme_start_queues() will be invoked from
nvme_tcp_ofld_error_recovery_work(). We are keeping the same design as tcp.=
c.

>
> > +
> > +     nvme_tcp_ofld_destroy_io_queues(nctrl, remove);
> >  }
> >
> >  static void nvme_tcp_ofld_reconnect_ctrl_work(struct work_struct *work=
)
> > @@ -562,6 +845,12 @@ nvme_tcp_ofld_init_request(struct blk_mq_tag_set *=
set,
> >       return 0;
> >  }
> >
> > +inline size_t nvme_tcp_ofld_inline_data_size(struct nvme_tcp_ofld_queu=
e *queue)
> > +{
> > +     return queue->cmnd_capsule_len - sizeof(struct nvme_command);
> > +}
> > +EXPORT_SYMBOL_GPL(nvme_tcp_ofld_inline_data_size);
> > +
> >  static blk_status_t
> >  nvme_tcp_ofld_queue_rq(struct blk_mq_hw_ctx *hctx,
> >                      const struct blk_mq_queue_data *bd)
> > @@ -573,22 +862,95 @@ nvme_tcp_ofld_queue_rq(struct blk_mq_hw_ctx *hctx=
,
> >       return BLK_STS_OK;
> >  }
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
> >  static struct blk_mq_ops nvme_tcp_ofld_mq_ops =3D {
> >       .queue_rq       =3D nvme_tcp_ofld_queue_rq,
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
> >  };
> >
> >  static struct blk_mq_ops nvme_tcp_ofld_admin_mq_ops =3D {
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
> >  };
> >
> >  static const struct nvme_ctrl_ops nvme_tcp_ofld_ctrl_ops =3D {
> > diff --git a/drivers/nvme/host/tcp-offload.h b/drivers/nvme/host/tcp-of=
fload.h
> > index b80cdef8511a..fcc377680d9f 100644
> > --- a/drivers/nvme/host/tcp-offload.h
> > +++ b/drivers/nvme/host/tcp-offload.h
> > @@ -65,6 +65,9 @@ struct nvme_tcp_ofld_queue {
> >       unsigned long flags;
> >       size_t cmnd_capsule_len;
> >
> > +     /* mutex used during stop_queue */
> > +     struct mutex queue_lock;
> > +
> >       u8 hdr_digest;
> >       u8 data_digest;
> >       u8 tos;
> > @@ -197,3 +200,4 @@ struct nvme_tcp_ofld_ops {
> >  int nvme_tcp_ofld_register_dev(struct nvme_tcp_ofld_dev *dev);
> >  void nvme_tcp_ofld_unregister_dev(struct nvme_tcp_ofld_dev *dev);
> >  void nvme_tcp_ofld_error_recovery(struct nvme_ctrl *nctrl);
> > +inline size_t nvme_tcp_ofld_inline_data_size(struct nvme_tcp_ofld_queu=
e *queue);
> >
> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke                     Kernel Storage Architect
> hare@suse.de                                   +49 911 74053 688
> SUSE Software Solutions Germany GmbH, 90409 N=C3=BCrnberg
> GF: F. Imend=C3=B6rffer, HRB 36809 (AG N=C3=BCrnberg)
