Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 801C5372E25
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 18:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231713AbhEDQfp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 12:35:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231602AbhEDQfp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 12:35:45 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30B9FC061574
        for <netdev@vger.kernel.org>; Tue,  4 May 2021 09:34:50 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id bf4so11174053edb.11
        for <netdev@vger.kernel.org>; Tue, 04 May 2021 09:34:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=nX2dfFBRajuwy4uDCDvaOxSnqkVKKpTquv2PJ/eKH8Q=;
        b=IlSBvg8qpE/7fVz+eE27ewcb9udV9jIiVhXsFCEE8ITnduXq5EEsDaPObOPqB37tuM
         jNPa67X0RXs2RnZfXeB0i1yeoEXYyt/JLCMBEskQvYvweXWZWLWVruS+qxsE87ygxBJ3
         5q/PUjArRDLcadhBuR/S5UyZ2r2v4aEgwKsFJ1kluTMYL3XNzNxfum/EuBXjvA2yZbA9
         VDUngfuxk6jCgSokDlPTd4kM9REr/UdDFtDDov4ynK4rG5RSHFxVJV6B9JZnaT9m+iCS
         QwZOHltkcJ+ZMTh7bv97zVkox2fiDStVwiwedjJcod2YEZj2g9zFV+WsXOo7vaZl1ucs
         060A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=nX2dfFBRajuwy4uDCDvaOxSnqkVKKpTquv2PJ/eKH8Q=;
        b=PC6LfETSoQl7agoEDeBw9bOznEzustbyfvKSB0AhsDlG6J7LwdRUJ5dy8hQLFsZz7K
         EZrjUb7dctLnyWRY7lAq34lWIv2tB0gHzT8rGwQHFhFdQqIv+TrAKUxP1HZhzvp9aTh9
         LTccC51mdcHShB7CUA7D7ahL26+FQph3eGn9oieU/enprvQN61ndFMjRvdOU5Yeb5COt
         9g7e4P0t/KnKkcVZh6eElWtXzz87AbvhWfDmAMZPuZPcLBiBqKPD7O99Ve/WWF5VGp9i
         lGzR67gaW1iGDIATcDvHWdGXlBnS3vf2WkB40CvZzIT3i4oGRlSuC7SL9kfIh9QV1Das
         uwdw==
X-Gm-Message-State: AOAM5317hFBddMsPsurplL3z31YtfV7X7RE7e3ba5qfYgkSK/fQYkbDU
        4h6pHVjhcepACVk0XdzQWi46AQ6pq7N0j8n+BTo=
X-Google-Smtp-Source: ABdhPJyXEhtvANidkdf3NoQ09aJziZO9kiaPtU94e10HyGgTUHA6RY4zNY2C+ozrCgnM+6fefw08sy0sjw8IKs42roo=
X-Received: by 2002:aa7:c30c:: with SMTP id l12mr26812726edq.217.1620146088651;
 Tue, 04 May 2021 09:34:48 -0700 (PDT)
MIME-Version: 1.0
References: <20210429190926.5086-1-smalin@marvell.com> <20210429190926.5086-15-smalin@marvell.com>
 <bc7514a1-df4e-04b1-ecd2-ed4223bb4cd5@suse.de>
In-Reply-To: <bc7514a1-df4e-04b1-ecd2-ed4223bb4cd5@suse.de>
From:   Shai Malin <malin1024@gmail.com>
Date:   Tue, 4 May 2021 19:34:37 +0300
Message-ID: <CAKKgK4wYzD+8vk2Uty8LQSnOpvBPhf2-zeoQ=T+nU_Ls4Dv+3Q@mail.gmail.com>
Subject: Re: [RFC PATCH v4 14/27] nvme-tcp-offload: Add IO level implementation
To:     Hannes Reinecke <hare@suse.de>
Cc:     Shai Malin <smalin@marvell.com>, netdev@vger.kernel.org,
        linux-nvme@lists.infradead.org, davem@davemloft.net,
        kuba@kernel.org, sagi@grimberg.me, hch@lst.de, axboe@fb.com,
        kbusch@kernel.org, Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>, okulkarni@marvell.com,
        pkushwaha@marvell.com, Dean Balandin <dbalandin@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/1/21 7:38 PM, Hannes Reinecke wrote:
> On 4/29/21 9:09 PM, Shai Malin wrote:
> > From: Dean Balandin <dbalandin@marvell.com>
> >
> > In this patch, we present the IO level functionality.
> > The nvme-tcp-offload shall work on the IO-level, meaning the
> > nvme-tcp-offload ULP module shall pass the request to the nvme-tcp-offl=
oad
> > vendor driver and shall expect for the request compilation.
>
> Request compilation? Not request completion?

Completion. Thanks!

>
> > No additional handling is needed in between, this design will reduce th=
e
> > CPU utilization as we will describe below.
> >
> > The nvme-tcp-offload vendor driver shall register to nvme-tcp-offload U=
LP
> > with the following IO-path ops:
> >   - init_req
> >   - send_req - in order to pass the request to the handling of the offl=
oad
> >     driver that shall pass it to the vendor specific device
> >   - poll_queue
> >
> > The vendor driver will manage the context from which the request will b=
e
> > executed and the request aggregations.
> > Once the IO completed, the nvme-tcp-offload vendor driver shall call
> > command.done() that shall invoke the nvme-tcp-offload ULP layer for
> > completing the request.
> >
> > This patch also contains initial definition of nvme_tcp_ofld_queue_rq()=
.
> >
> > Acked-by: Igor Russkikh <irusskikh@marvell.com>
> > Signed-off-by: Dean Balandin <dbalandin@marvell.com>
> > Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> > Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
> > Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
> > Signed-off-by: Ariel Elior <aelior@marvell.com>
> > Signed-off-by: Shai Malin <smalin@marvell.com>
> > ---
> >   drivers/nvme/host/tcp-offload.c | 95 ++++++++++++++++++++++++++++++--=
-
> >   1 file changed, 87 insertions(+), 8 deletions(-)
> >
> > diff --git a/drivers/nvme/host/tcp-offload.c b/drivers/nvme/host/tcp-of=
fload.c
> > index 8ddce2257100..0cdf5a432208 100644
> > --- a/drivers/nvme/host/tcp-offload.c
> > +++ b/drivers/nvme/host/tcp-offload.c
> > @@ -127,7 +127,10 @@ void nvme_tcp_ofld_req_done(struct nvme_tcp_ofld_r=
eq *req,
> >                           union nvme_result *result,
> >                           __le16 status)
> >   {
> > -     /* Placeholder - complete request with/without error */
> > +     struct request *rq =3D blk_mq_rq_from_pdu(req);
> > +
> > +     if (!nvme_try_complete_req(rq, cpu_to_le16(status << 1), *result)=
)
> > +             nvme_complete_rq(rq);
> >   }
> >
> >   struct nvme_tcp_ofld_dev *
> > @@ -686,6 +689,34 @@ static void nvme_tcp_ofld_free_ctrl(struct nvme_ct=
rl *nctrl)
> >       kfree(ctrl);
> >   }
> >
> > +static void nvme_tcp_ofld_set_sg_null(struct nvme_command *c)
> > +{
> > +     struct nvme_sgl_desc *sg =3D &c->common.dptr.sgl;
> > +
> > +     sg->addr =3D 0;
> > +     sg->length =3D 0;
> > +     sg->type =3D (NVME_TRANSPORT_SGL_DATA_DESC << 4) | NVME_SGL_FMT_T=
RANSPORT_A;
> > +}
> > +
> > +inline void nvme_tcp_ofld_set_sg_inline(struct nvme_tcp_ofld_queue *qu=
eue,
> > +                                     struct nvme_command *c, u32 data_=
len)
> > +{
> > +     struct nvme_sgl_desc *sg =3D &c->common.dptr.sgl;
> > +
> > +     sg->addr =3D cpu_to_le64(queue->ctrl->nctrl.icdoff);
> > +     sg->length =3D cpu_to_le32(data_len);
> > +     sg->type =3D (NVME_SGL_FMT_DATA_DESC << 4) | NVME_SGL_FMT_OFFSET;
> > +}
> > +
> > +void nvme_tcp_ofld_map_data(struct nvme_command *c, u32 data_len)
> > +{
> > +     struct nvme_sgl_desc *sg =3D &c->common.dptr.sgl;
> > +
> > +     sg->addr =3D 0;
> > +     sg->length =3D cpu_to_le32(data_len);
> > +     sg->type =3D (NVME_TRANSPORT_SGL_DATA_DESC << 4) | NVME_SGL_FMT_T=
RANSPORT_A;
> > +}
> > +
> >   static void nvme_tcp_ofld_submit_async_event(struct nvme_ctrl *arg)
> >   {
> >       /* Placeholder - submit_async_event */
> > @@ -841,9 +872,11 @@ nvme_tcp_ofld_init_request(struct blk_mq_tag_set *=
set,
> >   {
> >       struct nvme_tcp_ofld_req *req =3D blk_mq_rq_to_pdu(rq);
> >       struct nvme_tcp_ofld_ctrl *ctrl =3D set->driver_data;
> > +     int qid;
> >
> > -     /* Placeholder - init request */
> > -
> > +     qid =3D (set =3D=3D &ctrl->tag_set) ? hctx_idx + 1 : 0;
> > +     req->queue =3D &ctrl->queues[qid];
> > +     nvme_req(rq)->ctrl =3D &ctrl->nctrl;
> >       req->done =3D nvme_tcp_ofld_req_done;
> >       ctrl->dev->ops->init_req(req);
> >
> > @@ -858,16 +891,60 @@ EXPORT_SYMBOL_GPL(nvme_tcp_ofld_inline_data_size)=
;
> >
> >   static void nvme_tcp_ofld_commit_rqs(struct blk_mq_hw_ctx *hctx)
> >   {
> > -     /* Call ops->commit_rqs */
> > +     struct nvme_tcp_ofld_queue *queue =3D hctx->driver_data;
> > +     struct nvme_tcp_ofld_dev *dev =3D queue->dev;
> > +     struct nvme_tcp_ofld_ops *ops =3D dev->ops;
> > +
> > +     ops->commit_rqs(queue);
> >   }
> >
> >   static blk_status_t
> >   nvme_tcp_ofld_queue_rq(struct blk_mq_hw_ctx *hctx,
> >                      const struct blk_mq_queue_data *bd)
> >   {
> > -     /* Call nvme_setup_cmd(...) */
> > +     struct nvme_tcp_ofld_req *req =3D blk_mq_rq_to_pdu(bd->rq);
> > +     struct nvme_tcp_ofld_queue *queue =3D hctx->driver_data;
> > +     struct nvme_tcp_ofld_ctrl *ctrl =3D queue->ctrl;
> > +     struct nvme_ns *ns =3D hctx->queue->queuedata;
> > +     struct nvme_tcp_ofld_dev *dev =3D queue->dev;
> > +     struct nvme_tcp_ofld_ops *ops =3D dev->ops;
> > +     struct nvme_command *nvme_cmd;
> > +     struct request *rq;
> > +     bool queue_ready;
> > +     u32 data_len;
> > +     int rc;
> > +
> > +     queue_ready =3D test_bit(NVME_TCP_OFLD_Q_LIVE, &queue->flags);
> > +
> > +     req->rq =3D bd->rq;
> > +     req->async =3D false;
> > +     rq =3D req->rq;
> > +
> > +     if (!nvmf_check_ready(&ctrl->nctrl, req->rq, queue_ready))
> > +             return nvmf_fail_nonready_command(&ctrl->nctrl, req->rq);
> > +
> > +     rc =3D nvme_setup_cmd(ns, req->rq, &req->nvme_cmd);
> > +     if (unlikely(rc))
> > +             return rc;
> >
> > -     /* Call ops->send_req(...) */
> > +     blk_mq_start_request(req->rq);
> > +     req->last =3D bd->last;
> > +
> > +     nvme_cmd =3D &req->nvme_cmd;
> > +     nvme_cmd->common.flags |=3D NVME_CMD_SGL_METABUF;
> > +
> > +     data_len =3D blk_rq_nr_phys_segments(rq) ? blk_rq_payload_bytes(r=
q) : 0;
> > +     if (!data_len)
> > +             nvme_tcp_ofld_set_sg_null(&req->nvme_cmd);
> > +     else if ((rq_data_dir(rq) =3D=3D WRITE) &&
> > +              data_len <=3D nvme_tcp_ofld_inline_data_size(queue))
> > +             nvme_tcp_ofld_set_sg_inline(queue, nvme_cmd, data_len);
> > +     else
> > +             nvme_tcp_ofld_map_data(nvme_cmd, data_len);
> > +
> > +     rc =3D ops->send_req(req);
> > +     if (unlikely(rc))
> > +             return rc;
> >
> >       return BLK_STS_OK;
> >   }
> > @@ -940,9 +1017,11 @@ static int nvme_tcp_ofld_map_queues(struct blk_mq=
_tag_set *set)
> >
> >   static int nvme_tcp_ofld_poll(struct blk_mq_hw_ctx *hctx)
> >   {
> > -     /* Placeholder - Implement polling mechanism */
> > +     struct nvme_tcp_ofld_queue *queue =3D hctx->driver_data;
> > +     struct nvme_tcp_ofld_dev *dev =3D queue->dev;
> > +     struct nvme_tcp_ofld_ops *ops =3D dev->ops;
> >
> > -     return 0;
> > +     return ops->poll_queue(queue);
> >   }
> >
> >   static struct blk_mq_ops nvme_tcp_ofld_mq_ops =3D {
> >
> Reviewed-by: Hannes Reinecke <hare@suse.de>
>

Thanks.

> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke                Kernel Storage Architect
> hare@suse.de                              +49 911 74053 688
> SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> HRB 36809 (AG N=C3=BCrnberg), Gesch=C3=A4ftsf=C3=BChrer: Felix Imend=C3=
=B6rffer
