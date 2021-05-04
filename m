Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58814372E3E
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 18:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231680AbhEDQuJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 12:50:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230133AbhEDQuJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 12:50:09 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B93CC061574
        for <netdev@vger.kernel.org>; Tue,  4 May 2021 09:49:13 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id l7so2584356edb.1
        for <netdev@vger.kernel.org>; Tue, 04 May 2021 09:49:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=BN0v6p/+A9dnmJBNgZbXsgLIzrPnvPiZ5clIW94x8Mo=;
        b=J2a/XWIGOxgcJtiH8jz+EvIU/mcuf7PA7uO8jCEbbdm5Hkv9Bna66efpcVKjnnkgG5
         srGxdRJXYyGySAXycJeaEleCZvUw06jk3tNunSO8OZOrQ1+UL5T1oHsaXncNiYlskegC
         wHowGKG9VWLJ/7cGul82K6t7YvqLYwQ7eTA1fTyIBkVH3+NeUhOKgMdb0//XEuPuvwpA
         8a03MkkrT7yCPQrRz8si4E0fVYITA2e0gh1azdLkPHHol6zGJFLcV44S0VKJBJn/hqdK
         qGhGR0BjnPcp00m7GqgNkfgrAoE3a4zOfB5s0Ez1HSd4lwAm96hN4bFE4TCeZ7chG7/d
         K9aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=BN0v6p/+A9dnmJBNgZbXsgLIzrPnvPiZ5clIW94x8Mo=;
        b=XsczbMfMfjSuwIG62d82BxyynddVXPe2EOT/X5R1pSusuczmr2+qKa50VSsgJezBk/
         PSidRmyKXsFaEAHPhJP0a2BwSXZWVmFPTgsMxSMTZR25XdlHhxlUB1AXulz+ZTXilOk8
         aRt3GXNHo14U+c337Fr8x7fQYmeddEcTlXnabaFKMSoNZdRJW4aZLGV6LlySacXOYppY
         sgrJP33pEzhUpNth+srODMeuN9jpSQ/EUGOMFn46p5SZEuCjGzxE1msypBOMpgyYh9Bm
         TgCd5zvaJKR7N1RIRzhWtUszjsx19tWS4fh+kKadzLuH/na5cAshxFdUn0SKutylB0xg
         YkzQ==
X-Gm-Message-State: AOAM533DpwigLOOCodgvkGpWRyVGb8vRv3HX5xZcsidih/j86Iek03VU
        Ld4LPrE9j4LYVnl6K5HSK0ig30IFgl3XAy2w/fs=
X-Google-Smtp-Source: ABdhPJzOiwUErIcmcmvfZ9qSvNz6lVMBwIPR+ts6ihrImjexY6JH9R6MpKGmJRsxzCNx6sKm7lhlReojAa+/pT3nAfU=
X-Received: by 2002:a05:6402:138f:: with SMTP id b15mr27065821edv.121.1620146951671;
 Tue, 04 May 2021 09:49:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210429190926.5086-1-smalin@marvell.com> <20210429190926.5086-16-smalin@marvell.com>
 <d762b4f0-c048-f9bd-a58b-fdbf3804e6a7@suse.de>
In-Reply-To: <d762b4f0-c048-f9bd-a58b-fdbf3804e6a7@suse.de>
From:   Shai Malin <malin1024@gmail.com>
Date:   Tue, 4 May 2021 19:49:00 +0300
Message-ID: <CAKKgK4yShPYpJdWmkRmEbuDp9yy691977gQ_Asmg9iX76fafiQ@mail.gmail.com>
Subject: Re: [RFC PATCH v4 15/27] nvme-tcp-offload: Add Timeout and ASYNC Support
To:     Hannes Reinecke <hare@suse.de>
Cc:     Shai Malin <smalin@marvell.com>, netdev@vger.kernel.org,
        linux-nvme@lists.infradead.org, davem@davemloft.net,
        kuba@kernel.org, sagi@grimberg.me, hch@lst.de, axboe@fb.com,
        kbusch@kernel.org, Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>, okulkarni@marvell.com,
        pkushwaha@marvell.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/1/21 7:45 PM, Hannes Reinecke wrote:
> On 4/29/21 9:09 PM, Shai Malin wrote:
> > In this patch, we present the nvme-tcp-offload timeout support
> > nvme_tcp_ofld_timeout() and ASYNC support
> > nvme_tcp_ofld_submit_async_event().
> >
> > Acked-by: Igor Russkikh <irusskikh@marvell.com>
> > Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> > Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
> > Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
> > Signed-off-by: Ariel Elior <aelior@marvell.com>
> > Signed-off-by: Shai Malin <smalin@marvell.com>
> > ---
> >   drivers/nvme/host/tcp-offload.c | 85 ++++++++++++++++++++++++++++++++=
-
> >   drivers/nvme/host/tcp-offload.h |  2 +
> >   2 files changed, 86 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/nvme/host/tcp-offload.c b/drivers/nvme/host/tcp-of=
fload.c
> > index 0cdf5a432208..1d62f921f109 100644
> > --- a/drivers/nvme/host/tcp-offload.c
> > +++ b/drivers/nvme/host/tcp-offload.c
> > @@ -133,6 +133,26 @@ void nvme_tcp_ofld_req_done(struct nvme_tcp_ofld_r=
eq *req,
> >               nvme_complete_rq(rq);
> >   }
> >
> > +/**
> > + * nvme_tcp_ofld_async_req_done() - NVMeTCP Offload request done callb=
ack
> > + * function for async request. Pointed to by nvme_tcp_ofld_req->done.
> > + * Handles both NVME_TCP_F_DATA_SUCCESS flag and NVMe CQ.
> > + * @req:     NVMeTCP offload request to complete.
> > + * @result:     The nvme_result.
> > + * @status:     The completion status.
> > + *
> > + * API function that allows the vendor specific offload driver to repo=
rt request
> > + * completions to the common offload layer.
> > + */
> > +void nvme_tcp_ofld_async_req_done(struct nvme_tcp_ofld_req *req,
> > +                               union nvme_result *result, __le16 statu=
s)
> > +{
> > +     struct nvme_tcp_ofld_queue *queue =3D req->queue;
> > +     struct nvme_tcp_ofld_ctrl *ctrl =3D queue->ctrl;
> > +
> > +     nvme_complete_async_event(&ctrl->nctrl, status, result);
> > +}
> > +
> >   struct nvme_tcp_ofld_dev *
> >   nvme_tcp_ofld_lookup_dev(struct nvme_tcp_ofld_ctrl *ctrl)
> >   {
> > @@ -719,7 +739,23 @@ void nvme_tcp_ofld_map_data(struct nvme_command *c=
, u32 data_len)
> >
> >   static void nvme_tcp_ofld_submit_async_event(struct nvme_ctrl *arg)
> >   {
> > -     /* Placeholder - submit_async_event */
> > +     struct nvme_tcp_ofld_ctrl *ctrl =3D to_tcp_ofld_ctrl(arg);
> > +     struct nvme_tcp_ofld_queue *queue =3D &ctrl->queues[0];
> > +     struct nvme_tcp_ofld_dev *dev =3D queue->dev;
> > +     struct nvme_tcp_ofld_ops *ops =3D dev->ops;
> > +
> > +     ctrl->async_req.nvme_cmd.common.opcode =3D nvme_admin_async_event=
;
> > +     ctrl->async_req.nvme_cmd.common.command_id =3D NVME_AQ_BLK_MQ_DEP=
TH;
> > +     ctrl->async_req.nvme_cmd.common.flags |=3D NVME_CMD_SGL_METABUF;
> > +
> > +     nvme_tcp_ofld_set_sg_null(&ctrl->async_req.nvme_cmd);
> > +
> > +     ctrl->async_req.async =3D true;
> > +     ctrl->async_req.queue =3D queue;
> > +     ctrl->async_req.last =3D true;
> > +     ctrl->async_req.done =3D nvme_tcp_ofld_async_req_done;
> > +
> > +     ops->send_req(&ctrl->async_req);
> >   }
> >
> >   static void
> > @@ -1024,6 +1060,51 @@ static int nvme_tcp_ofld_poll(struct blk_mq_hw_c=
tx *hctx)
> >       return ops->poll_queue(queue);
> >   }
> >
> > +static void nvme_tcp_ofld_complete_timed_out(struct request *rq)
> > +{
> > +     struct nvme_tcp_ofld_req *req =3D blk_mq_rq_to_pdu(rq);
> > +     struct nvme_ctrl *nctrl =3D &req->queue->ctrl->nctrl;
> > +
> > +     nvme_tcp_ofld_stop_queue(nctrl, nvme_tcp_ofld_qid(req->queue));
> > +     if (blk_mq_request_started(rq) && !blk_mq_request_completed(rq)) =
{
> > +             nvme_req(rq)->status =3D NVME_SC_HOST_ABORTED_CMD;
> > +             blk_mq_complete_request(rq);
> > +     }
> > +}
> > +
> > +static enum blk_eh_timer_return nvme_tcp_ofld_timeout(struct request *=
rq, bool reserved)
> > +{
> > +     struct nvme_tcp_ofld_req *req =3D blk_mq_rq_to_pdu(rq);
> > +     struct nvme_tcp_ofld_ctrl *ctrl =3D req->queue->ctrl;
> > +
> > +     dev_warn(ctrl->nctrl.device,
> > +              "queue %d: timeout request %#x type %d\n",
> > +              nvme_tcp_ofld_qid(req->queue), rq->tag, req->nvme_cmd.co=
mmon.opcode);
> > +
> > +     if (ctrl->nctrl.state !=3D NVME_CTRL_LIVE) {
> > +             /*
> > +              * If we are resetting, connecting or deleting we should
> > +              * complete immediately because we may block controller
> > +              * teardown or setup sequence
> > +              * - ctrl disable/shutdown fabrics requests
> > +              * - connect requests
> > +              * - initialization admin requests
> > +              * - I/O requests that entered after unquiescing and
> > +              *   the controller stopped responding
> > +              *
> > +              * All other requests should be cancelled by the error
> > +              * recovery work, so it's fine that we fail it here.
> > +              */
> > +             nvme_tcp_ofld_complete_timed_out(rq);
> > +
> > +             return BLK_EH_DONE;
> > +     }
>
> And this particular error code has been causing _so_ _many_ issues
> during testing, that I'd rather get rid of it altogether.
> But probably not your fault, your just copying what tcp and rdma is doing=
.
>

I agree. We preferred to keep all the teardown/error flows similar to the t=
cp
and rdma design in order to be able to align the tcp-offload to any future
changes. Would you like us to do anything differently?

> > +
> > +     nvme_tcp_ofld_error_recovery(&ctrl->nctrl);
> > +
> > +     return BLK_EH_RESET_TIMER;
> > +}
> > +
> >   static struct blk_mq_ops nvme_tcp_ofld_mq_ops =3D {
> >       .queue_rq       =3D nvme_tcp_ofld_queue_rq,
> >       .commit_rqs     =3D nvme_tcp_ofld_commit_rqs,
> > @@ -1031,6 +1112,7 @@ static struct blk_mq_ops nvme_tcp_ofld_mq_ops =3D=
 {
> >       .init_request   =3D nvme_tcp_ofld_init_request,
> >       .exit_request   =3D nvme_tcp_ofld_exit_request,
> >       .init_hctx      =3D nvme_tcp_ofld_init_hctx,
> > +     .timeout        =3D nvme_tcp_ofld_timeout,
> >       .map_queues     =3D nvme_tcp_ofld_map_queues,
> >       .poll           =3D nvme_tcp_ofld_poll,
> >   };
> > @@ -1041,6 +1123,7 @@ static struct blk_mq_ops nvme_tcp_ofld_admin_mq_o=
ps =3D {
> >       .init_request   =3D nvme_tcp_ofld_init_request,
> >       .exit_request   =3D nvme_tcp_ofld_exit_request,
> >       .init_hctx      =3D nvme_tcp_ofld_init_admin_hctx,
> > +     .timeout        =3D nvme_tcp_ofld_timeout,
> >   };
> >
> >   static const struct nvme_ctrl_ops nvme_tcp_ofld_ctrl_ops =3D {
> > diff --git a/drivers/nvme/host/tcp-offload.h b/drivers/nvme/host/tcp-of=
fload.h
> > index d82645fcf9da..275a7e2d9d8a 100644
> > --- a/drivers/nvme/host/tcp-offload.h
> > +++ b/drivers/nvme/host/tcp-offload.h
> > @@ -110,6 +110,8 @@ struct nvme_tcp_ofld_ctrl {
> >       /* Connectivity params */
> >       struct nvme_tcp_ofld_ctrl_con_params conn_params;
> >
> > +     struct nvme_tcp_ofld_req async_req;
> > +
> >       /* Vendor specific driver context */
> >       void *private_data;
> >   };
> >
> So:
>
> Reviewed-by: Hannes Reinecke <hare@suse.de>

Thanks.

>
> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke                Kernel Storage Architect
> hare@suse.de                              +49 911 74053 688
> SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> HRB 36809 (AG N=C3=BCrnberg), Gesch=C3=A4ftsf=C3=BChrer: Felix Imend=C3=
=B6rffer
