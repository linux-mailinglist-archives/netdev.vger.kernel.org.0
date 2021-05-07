Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 485E437667C
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 15:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237320AbhEGN5r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 09:57:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234081AbhEGN5q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 09:57:46 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59672C061574
        for <netdev@vger.kernel.org>; Fri,  7 May 2021 06:56:45 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id n15so5706871edw.8
        for <netdev@vger.kernel.org>; Fri, 07 May 2021 06:56:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=WU2HFxokStv/fsujN7QkeDnEqgAHx4a+3N6hw3MmM1M=;
        b=dqDUJAAGmGVY2LAsNDzdXqbKOsPrVS2iBinEMwnRkfPo7XEP47/wOpHDFbHk2Avbof
         VKt9UW6WNvihyjlQtiADJRxGolICLg0iuoCwAMX9NRCkZ1nmAbW4PM8nGsJKlxjGaq6r
         tJ3edvC+8OLQWxq4qbZjnQNphcL3rK/U96bd1Fs0YOPr9vwXrTuNkzvxwACRjhDePryH
         LE4gbD5WmrxmfzpgevleNaH7SCduohS9qISDqFQnVOBBweTAOp9gWN1gwxrAQ3YLT7J8
         ftdjVdAjHFC6pLZY52DQhS38Rl9G1VXL5YabJwzO2PRstAgfUGonhhQh8k+1CvD4eCSD
         92ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=WU2HFxokStv/fsujN7QkeDnEqgAHx4a+3N6hw3MmM1M=;
        b=LkgePZqHdAt04gbjBrk65vd1/ln+j6sH9dDOvgWCETAaXLl+IGVRLxP7XTPVufjBD9
         yYmbzGtfh+f+tptezuwwHWhpAtCg8lAZCgpzKd9BCRCIKo6xMU7zEt8M6lKrd14WtCf6
         wQvqUfwJfKI3COM8LGz6LWROjgM7751MOVL8m7ZOwVBk294TQeY77RyxblTaTTW8Uu9d
         Lce1zI8AFJH5BcrVpjIfZoqH9cpo1alCAY/NuPRVYVkjUldaHvs6F7EmZADI3UCAa4r5
         QL8GpWt2ExTv9RlEbHnoGsewxoYPkmlbkQrVxkTX0A2DOJ+aZCZzZHxv8b7DbXMuoC/f
         fgnA==
X-Gm-Message-State: AOAM5336Nc+L5lLZY7wuEy8khBck0GnnZf/xz9nHt50EqPXPcT3oR4Gq
        bERw8FOT4LQOwRp5aZX4w6Mj+/HqZciu1rDiyPAtoFc0nqc=
X-Google-Smtp-Source: ABdhPJxMeOXtOYg3+ea49pDi8OyDfzsPC2iPyvQh3JPDuv/dDR7Q1NnRwZCUzVvItn/wi64CLdqWdIdlfk6RSLnHHak=
X-Received: by 2002:a05:6402:57:: with SMTP id f23mr11385414edu.323.1620395803840;
 Fri, 07 May 2021 06:56:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210429190926.5086-1-smalin@marvell.com> <20210429190926.5086-23-smalin@marvell.com>
 <42912221-29b4-e97a-bec0-9d8eec2c97fa@suse.de>
In-Reply-To: <42912221-29b4-e97a-bec0-9d8eec2c97fa@suse.de>
From:   Shai Malin <malin1024@gmail.com>
Date:   Fri, 7 May 2021 16:56:30 +0300
Message-ID: <CAKKgK4yCZ_VKZuvwr3mJFmp7CPg_8vBts+zaV5Xa0bY6hcZjhw@mail.gmail.com>
Subject: Re: [RFC PATCH v4 22/27] qedn: Add IO level nvme_req and fw_cq workqueues
To:     Hannes Reinecke <hare@suse.de>
Cc:     Shai Malin <smalin@marvell.com>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org,
        linux-nvme@lists.infradead.org, sagi@grimberg.me, hch@lst.de,
        axboe@fb.com, kbusch@kernel.org, Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>, okulkarni@marvell.com,
        pkushwaha@marvell.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/2/21 2:42 PM, Hannes Reinecke wrote:
> On 4/29/21 9:09 PM, Shai Malin wrote:
> > This patch will present the IO level workqueues:
> >
> > - qedn_nvme_req_fp_wq(): process new requests, similar to
> >                        nvme_tcp_io_work(). The flow starts from
> >                        send_req() and will aggregate all the requests
> >                        on this CPU core.
> >
> > - qedn_fw_cq_fp_wq():   process new FW completions, the flow starts fro=
m
> >                       the IRQ handler and for a single interrupt it wil=
l
> >                       process all the pending NVMeoF Completions under
> >                       polling mode.
> >
> > Acked-by: Igor Russkikh <irusskikh@marvell.com>
> > Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> > Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
> > Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
> > Signed-off-by: Ariel Elior <aelior@marvell.com>
> > Signed-off-by: Shai Malin <smalin@marvell.com>
> > ---
> >   drivers/nvme/hw/qedn/Makefile    |   2 +-
> >   drivers/nvme/hw/qedn/qedn.h      |  29 +++++++
> >   drivers/nvme/hw/qedn/qedn_conn.c |   3 +
> >   drivers/nvme/hw/qedn/qedn_main.c | 114 +++++++++++++++++++++++--
> >   drivers/nvme/hw/qedn/qedn_task.c | 138 ++++++++++++++++++++++++++++++=
+
> >   5 files changed, 278 insertions(+), 8 deletions(-)
> >   create mode 100644 drivers/nvme/hw/qedn/qedn_task.c
> >
> > diff --git a/drivers/nvme/hw/qedn/Makefile b/drivers/nvme/hw/qedn/Makef=
ile
> > index d8b343afcd16..c7d838a61ae6 100644
> > --- a/drivers/nvme/hw/qedn/Makefile
> > +++ b/drivers/nvme/hw/qedn/Makefile
> > @@ -1,4 +1,4 @@
> >   # SPDX-License-Identifier: GPL-2.0-only
> >
> >   obj-$(CONFIG_NVME_QEDN) +=3D qedn.o
> > -qedn-y :=3D qedn_main.o qedn_conn.o
> > +qedn-y :=3D qedn_main.o qedn_conn.o qedn_task.o
> > \ No newline at end of file
> > diff --git a/drivers/nvme/hw/qedn/qedn.h b/drivers/nvme/hw/qedn/qedn.h
> > index c15cac37ec1e..bd9a250cb2f5 100644
> > --- a/drivers/nvme/hw/qedn/qedn.h
> > +++ b/drivers/nvme/hw/qedn/qedn.h
> > @@ -47,6 +47,9 @@
> >   #define QEDN_NON_ABORTIVE_TERMINATION 0
> >   #define QEDN_ABORTIVE_TERMINATION 1
> >
> > +#define QEDN_FW_CQ_FP_WQ_WORKQUEUE "qedn_fw_cq_fp_wq"
> > +#define QEDN_NVME_REQ_FP_WQ_WORKQUEUE "qedn_nvme_req_fp_wq"
> > +
> >   /*
> >    * TCP offload stack default configurations and defines.
> >    * Future enhancements will allow controlling the configurable
> > @@ -100,6 +103,7 @@ struct qedn_fp_queue {
> >       struct qedn_ctx *qedn;
> >       struct qed_sb_info *sb_info;
> >       unsigned int cpu;
> > +     struct work_struct fw_cq_fp_wq_entry;
> >       u16 sb_id;
> >       char irqname[QEDN_IRQ_NAME_LEN];
> >   };
> > @@ -131,6 +135,8 @@ struct qedn_ctx {
> >       struct qedn_fp_queue *fp_q_arr;
> >       struct nvmetcp_glbl_queue_entry *fw_cq_array_virt;
> >       dma_addr_t fw_cq_array_phy; /* Physical address of fw_cq_array_vi=
rt */
> > +     struct workqueue_struct *nvme_req_fp_wq;
> > +     struct workqueue_struct *fw_cq_fp_wq;
> >   };
> >
> >   struct qedn_endpoint {
> > @@ -213,6 +219,25 @@ struct qedn_ctrl {
> >
> >   /* Connection level struct */
> >   struct qedn_conn_ctx {
> > +     /* IO path */
> > +     struct workqueue_struct *nvme_req_fp_wq; /* ptr to qedn->nvme_req=
_fp_wq */
> > +     struct nvme_tcp_ofld_req *req; /* currently proccessed request */
> > +
> > +     struct list_head host_pend_req_list;
> > +     /* Spinlock to access pending request list */
> > +     spinlock_t nvme_req_lock;
> > +     unsigned int cpu;
> > +
> > +     /* Entry for registering to nvme_req_fp_wq */
> > +     struct work_struct nvme_req_fp_wq_entry;
> > +     /*
> > +      * Spinlock for accessing qedn_process_req as it can be called
> > +      * from multiple place like queue_rq, async, self requeued
> > +      */
> > +     struct mutex nvme_req_mutex;
> > +     struct qedn_fp_queue *fp_q;
> > +     int qid;
> > +
> >       struct qedn_ctx *qedn;
> >       struct nvme_tcp_ofld_queue *queue;
> >       struct nvme_tcp_ofld_ctrl *ctrl;
> > @@ -280,5 +305,9 @@ int qedn_wait_for_conn_est(struct qedn_conn_ctx *co=
nn_ctx);
> >   int qedn_set_con_state(struct qedn_conn_ctx *conn_ctx, enum qedn_conn=
_state new_state);
> >   void qedn_terminate_connection(struct qedn_conn_ctx *conn_ctx, int ab=
rt_flag);
> >   __be16 qedn_get_in_port(struct sockaddr_storage *sa);
> > +inline int qedn_validate_cccid_in_range(struct qedn_conn_ctx *conn_ctx=
, u16 cccid);
> > +void qedn_queue_request(struct qedn_conn_ctx *qedn_conn, struct nvme_t=
cp_ofld_req *req);
> > +void qedn_nvme_req_fp_wq_handler(struct work_struct *work);
> > +void qedn_io_work_cq(struct qedn_ctx *qedn, struct nvmetcp_fw_cqe *cqe=
);
> >
> >   #endif /* _QEDN_H_ */
> > diff --git a/drivers/nvme/hw/qedn/qedn_conn.c b/drivers/nvme/hw/qedn/qe=
dn_conn.c
> > index 9bfc0a5f0cdb..90d8aa36d219 100644
> > --- a/drivers/nvme/hw/qedn/qedn_conn.c
> > +++ b/drivers/nvme/hw/qedn/qedn_conn.c
> > @@ -385,6 +385,9 @@ static int qedn_prep_and_offload_queue(struct qedn_=
conn_ctx *conn_ctx)
> >       }
> >
> >       set_bit(QEDN_CONN_RESRC_FW_SQ, &conn_ctx->resrc_state);
> > +     INIT_LIST_HEAD(&conn_ctx->host_pend_req_list);
> > +     spin_lock_init(&conn_ctx->nvme_req_lock);
> > +
> >       rc =3D qed_ops->acquire_conn(qedn->cdev,
> >                                  &conn_ctx->conn_handle,
> >                                  &conn_ctx->fw_cid,
> > diff --git a/drivers/nvme/hw/qedn/qedn_main.c b/drivers/nvme/hw/qedn/qe=
dn_main.c
> > index 8b5714e7e2bb..38f23dbb03a5 100644
> > --- a/drivers/nvme/hw/qedn/qedn_main.c
> > +++ b/drivers/nvme/hw/qedn/qedn_main.c
> > @@ -267,6 +267,18 @@ static int qedn_release_ctrl(struct nvme_tcp_ofld_=
ctrl *ctrl)
> >       return 0;
> >   }
> >
> > +static void qedn_set_ctrl_io_cpus(struct qedn_conn_ctx *conn_ctx, int =
qid)
> > +{
> > +     struct qedn_ctx *qedn =3D conn_ctx->qedn;
> > +     struct qedn_fp_queue *fp_q =3D NULL;
> > +     int index;
> > +
> > +     index =3D qid ? (qid - 1) % qedn->num_fw_cqs : 0;
> > +     fp_q =3D &qedn->fp_q_arr[index];
> > +
> > +     conn_ctx->cpu =3D fp_q->cpu;
> > +}
> > +
> >   static int qedn_create_queue(struct nvme_tcp_ofld_queue *queue, int q=
id, size_t q_size)
> >   {
> >       struct nvme_tcp_ofld_ctrl *ctrl =3D queue->ctrl;
> > @@ -288,6 +300,7 @@ static int qedn_create_queue(struct nvme_tcp_ofld_q=
ueue *queue, int qid, size_t
> >       conn_ctx->queue =3D queue;
> >       conn_ctx->ctrl =3D ctrl;
> >       conn_ctx->sq_depth =3D q_size;
> > +     qedn_set_ctrl_io_cpus(conn_ctx, qid);
> >
> >       init_waitqueue_head(&conn_ctx->conn_waitq);
> >       atomic_set(&conn_ctx->est_conn_indicator, 0);
> > @@ -295,6 +308,10 @@ static int qedn_create_queue(struct nvme_tcp_ofld_=
queue *queue, int qid, size_t
> >
> >       spin_lock_init(&conn_ctx->conn_state_lock);
> >
> > +     INIT_WORK(&conn_ctx->nvme_req_fp_wq_entry, qedn_nvme_req_fp_wq_ha=
ndler);
> > +     conn_ctx->nvme_req_fp_wq =3D qedn->nvme_req_fp_wq;
> > +     conn_ctx->qid =3D qid;
> > +
> >       qedn_initialize_endpoint(&conn_ctx->ep, qedn->local_mac_addr,
> >                                &ctrl->conn_params);
> >
> > @@ -356,6 +373,7 @@ static void qedn_destroy_queue(struct nvme_tcp_ofld=
_queue *queue)
> >       if (!conn_ctx)
> >               return;
> >
> > +     cancel_work_sync(&conn_ctx->nvme_req_fp_wq_entry);
> >       qedn_terminate_connection(conn_ctx, QEDN_ABORTIVE_TERMINATION);
> >
> >       qedn_queue_wait_for_terminate_complete(conn_ctx);
> > @@ -385,12 +403,24 @@ static int qedn_init_req(struct nvme_tcp_ofld_req=
 *req)
> >
> >   static void qedn_commit_rqs(struct nvme_tcp_ofld_queue *queue)
> >   {
> > -     /* Placeholder - queue work */
> > +     struct qedn_conn_ctx *conn_ctx;
> > +
> > +     conn_ctx =3D (struct qedn_conn_ctx *)queue->private_data;
> > +
> > +     if (!list_empty(&conn_ctx->host_pend_req_list))
> > +             queue_work_on(conn_ctx->cpu, conn_ctx->nvme_req_fp_wq,
> > +                           &conn_ctx->nvme_req_fp_wq_entry);
> >   }
> >
> >   static int qedn_send_req(struct nvme_tcp_ofld_req *req)
> >   {
> > -     /* Placeholder - qedn_send_req */
> > +     struct qedn_conn_ctx *qedn_conn =3D (struct qedn_conn_ctx *)req->=
queue->private_data;
> > +
> > +     /* Under the assumption that the cccid/tag will be in the range o=
f 0 to sq_depth-1. */
> > +     if (!req->async && qedn_validate_cccid_in_range(qedn_conn, req->r=
q->tag))
> > +             return BLK_STS_NOTSUPP;
> > +
> > +     qedn_queue_request(qedn_conn, req);
> >
> >       return 0;
> >   }
> > @@ -434,9 +464,59 @@ struct qedn_conn_ctx *qedn_get_conn_hash(struct qe=
dn_ctx *qedn, u16 icid)
> >   }
> >
> >   /* Fastpath IRQ handler */
> > +void qedn_fw_cq_fp_handler(struct qedn_fp_queue *fp_q)
> > +{
> > +     u16 sb_id, cq_prod_idx, cq_cons_idx;
> > +     struct qedn_ctx *qedn =3D fp_q->qedn;
> > +     struct nvmetcp_fw_cqe *cqe =3D NULL;
> > +
> > +     sb_id =3D fp_q->sb_id;
> > +     qed_sb_update_sb_idx(fp_q->sb_info);
> > +
> > +     /* rmb - to prevent missing new cqes */
> > +     rmb();
> > +
> > +     /* Read the latest cq_prod from the SB */
> > +     cq_prod_idx =3D *fp_q->cq_prod;
> > +     cq_cons_idx =3D qed_chain_get_cons_idx(&fp_q->cq_chain);
> > +
> > +     while (cq_cons_idx !=3D cq_prod_idx) {
> > +             cqe =3D qed_chain_consume(&fp_q->cq_chain);
> > +             if (likely(cqe))
> > +                     qedn_io_work_cq(qedn, cqe);
> > +             else
> > +                     pr_err("Failed consuming cqe\n");
> > +
> > +             cq_cons_idx =3D qed_chain_get_cons_idx(&fp_q->cq_chain);
> > +
> > +             /* Check if new completions were posted */
> > +             if (unlikely(cq_prod_idx =3D=3D cq_cons_idx)) {
> > +                     /* rmb - to prevent missing new cqes */
> > +                     rmb();
> > +
> > +                     /* Update the latest cq_prod from the SB */
> > +                     cq_prod_idx =3D *fp_q->cq_prod;
> > +             }
> > +     }
> > +}
> > +
> > +static void qedn_fw_cq_fq_wq_handler(struct work_struct *work)
> > +{
> > +     struct qedn_fp_queue *fp_q =3D container_of(work, struct qedn_fp_=
queue, fw_cq_fp_wq_entry);
> > +
> > +     qedn_fw_cq_fp_handler(fp_q);
> > +     qed_sb_ack(fp_q->sb_info, IGU_INT_ENABLE, 1);
> > +}
> > +
> >   static irqreturn_t qedn_irq_handler(int irq, void *dev_id)
> >   {
> > -     /* Placeholder */
> > +     struct qedn_fp_queue *fp_q =3D dev_id;
> > +     struct qedn_ctx *qedn =3D fp_q->qedn;
> > +
> > +     fp_q->cpu =3D smp_processor_id();
> > +
> > +     qed_sb_ack(fp_q->sb_info, IGU_INT_DISABLE, 0);
> > +     queue_work_on(fp_q->cpu, qedn->fw_cq_fp_wq, &fp_q->fw_cq_fp_wq_en=
try);
> >
> >       return IRQ_HANDLED;
> >   }
> > @@ -584,6 +664,11 @@ static void qedn_free_function_queues(struct qedn_=
ctx *qedn)
> >       int i;
> >
> >       /* Free workqueues */
> > +     destroy_workqueue(qedn->fw_cq_fp_wq);
> > +     qedn->fw_cq_fp_wq =3D NULL;
> > +
> > +     destroy_workqueue(qedn->nvme_req_fp_wq);
> > +     qedn->nvme_req_fp_wq =3D NULL;
> >
> >       /* Free the fast path queues*/
> >       for (i =3D 0; i < qedn->num_fw_cqs; i++) {
> > @@ -651,7 +736,23 @@ static int qedn_alloc_function_queues(struct qedn_=
ctx *qedn)
> >       u64 cq_phy_addr;
> >       int i;
> >
> > -     /* Place holder - IO-path workqueues */
> > +     qedn->fw_cq_fp_wq =3D alloc_workqueue(QEDN_FW_CQ_FP_WQ_WORKQUEUE,
> > +                                         WQ_HIGHPRI | WQ_MEM_RECLAIM, =
0);
> > +     if (!qedn->fw_cq_fp_wq) {
> > +             rc =3D -ENODEV;
> > +             pr_err("Unable to create fastpath FW CQ workqueue!\n");
> > +
> > +             return rc;
> > +     }
> > +
> > +     qedn->nvme_req_fp_wq =3D alloc_workqueue(QEDN_NVME_REQ_FP_WQ_WORK=
QUEUE,
> > +                                            WQ_HIGHPRI | WQ_MEM_RECLAI=
M, 1);
> > +     if (!qedn->nvme_req_fp_wq) {
> > +             rc =3D -ENODEV;
> > +             pr_err("Unable to create fastpath qedn nvme workqueue!\n"=
);
> > +
> > +             return rc;
> > +     }
> >
> >       qedn->fp_q_arr =3D kcalloc(qedn->num_fw_cqs,
> >                                sizeof(struct qedn_fp_queue), GFP_KERNEL=
);
>
> Why don't you use threaded interrupts if you're spinning off a workqueue
> for handling interrupts anyway?

We compared the performance (IOPS, CPU utilization, average latency,
and 99.99% tail latency) between workqueue and threaded interrupts and we a=
re
seeing the same results under different workloads.

We will continue to evaluate the threaded interrupts design and if we will =
see
performance improvement we will change it in V5.

>
> > @@ -679,7 +780,7 @@ static int qedn_alloc_function_queues(struct qedn_c=
tx *qedn)
> >               chain_params.mode =3D QED_CHAIN_MODE_PBL,
> >               chain_params.cnt_type =3D QED_CHAIN_CNT_TYPE_U16,
> >               chain_params.num_elems =3D QEDN_FW_CQ_SIZE;
> > -             chain_params.elem_size =3D 64; /*Placeholder - sizeof(str=
uct nvmetcp_fw_cqe)*/
> > +             chain_params.elem_size =3D sizeof(struct nvmetcp_fw_cqe);
> >
> >               rc =3D qed_ops->common->chain_alloc(qedn->cdev,
> >                                                 &fp_q->cq_chain,
> > @@ -708,8 +809,7 @@ static int qedn_alloc_function_queues(struct qedn_c=
tx *qedn)
> >               sb =3D fp_q->sb_info->sb_virt;
> >               fp_q->cq_prod =3D (u16 *)&sb->pi_array[QEDN_PROTO_CQ_PROD=
_IDX];
> >               fp_q->qedn =3D qedn;
> > -
> > -             /* Placeholder - Init IO-path workqueue */
> > +             INIT_WORK(&fp_q->fw_cq_fp_wq_entry, qedn_fw_cq_fq_wq_hand=
ler);
> >
> >               /* Placeholder - Init IO-path resources */
> >       }
> > diff --git a/drivers/nvme/hw/qedn/qedn_task.c b/drivers/nvme/hw/qedn/qe=
dn_task.c
> > new file mode 100644
> > index 000000000000..d3474188efdc
> > --- /dev/null
> > +++ b/drivers/nvme/hw/qedn/qedn_task.c
> > @@ -0,0 +1,138 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Copyright 2021 Marvell. All rights reserved.
> > + */
> > +
> > +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> > +
> > + /* Kernel includes */
> > +#include <linux/kernel.h>
> > +
> > +/* Driver includes */
> > +#include "qedn.h"
> > +
> > +inline int qedn_validate_cccid_in_range(struct qedn_conn_ctx *conn_ctx=
, u16 cccid)
> > +{
> > +     int rc =3D 0;
> > +
> > +     if (unlikely(cccid >=3D conn_ctx->sq_depth)) {
> > +             pr_err("cccid 0x%x out of range ( > sq depth)\n", cccid);
> > +             rc =3D -EINVAL;
> > +     }
> > +
> > +     return rc;
> > +}
> > +
> > +static bool qedn_process_req(struct qedn_conn_ctx *qedn_conn)
> > +{
> > +     return true;
> > +}
> > +
> > +/* The WQ handler can be call from 3 flows:
> > + *   1. queue_rq.
> > + *   2. async.
> > + *   3. self requeued
> > + * Try to send requests from the pending list. If a request proccess h=
as failed,
> > + * re-register to the workqueue.
> > + * If there are no additional pending requests - exit the handler.
> > + */
> > +void qedn_nvme_req_fp_wq_handler(struct work_struct *work)
> > +{
> > +     struct qedn_conn_ctx *qedn_conn;
> > +     bool more =3D false;
> > +
> > +     qedn_conn =3D container_of(work, struct qedn_conn_ctx, nvme_req_f=
p_wq_entry);
> > +     do {
> > +             if (mutex_trylock(&qedn_conn->nvme_req_mutex)) {
> > +                     more =3D qedn_process_req(qedn_conn);
> > +                     qedn_conn->req =3D NULL;
> > +                     mutex_unlock(&qedn_conn->nvme_req_mutex);
> > +             }
> > +     } while (more);
> > +
> > +     if (!list_empty(&qedn_conn->host_pend_req_list))
> > +             queue_work_on(qedn_conn->cpu, qedn_conn->nvme_req_fp_wq,
> > +                           &qedn_conn->nvme_req_fp_wq_entry);
> > +}
> > +
> > +void qedn_queue_request(struct qedn_conn_ctx *qedn_conn, struct nvme_t=
cp_ofld_req *req)
> > +{
> > +     bool empty, res =3D false;
> > +
> > +     spin_lock(&qedn_conn->nvme_req_lock);
> > +     empty =3D list_empty(&qedn_conn->host_pend_req_list) && !qedn_con=
n->req;
> > +     list_add_tail(&req->queue_entry, &qedn_conn->host_pend_req_list);
> > +     spin_unlock(&qedn_conn->nvme_req_lock);
> > +
> > +     /* attempt workqueue bypass */
> > +     if (qedn_conn->cpu =3D=3D smp_processor_id() && empty &&
> > +         mutex_trylock(&qedn_conn->nvme_req_mutex)) {
> > +             res =3D qedn_process_req(qedn_conn);
> > +             qedn_conn->req =3D NULL;
> > +             mutex_unlock(&qedn_conn->nvme_req_mutex);
> > +             if (res || list_empty(&qedn_conn->host_pend_req_list))
> > +                     return;
> > +     } else if (req->last) {
> > +             queue_work_on(qedn_conn->cpu, qedn_conn->nvme_req_fp_wq,
> > +                           &qedn_conn->nvme_req_fp_wq_entry);
> > +     }
> > +}
> > +
>
> Queueing a request?
> Does wonders for your latency ... Can't you do without?

Yes, we can.
Will be fixed in V5.

>
> > +struct qedn_task_ctx *qedn_cqe_get_active_task(struct nvmetcp_fw_cqe *=
cqe)
> > +{
> > +     struct regpair *p =3D &cqe->task_opaque;
> > +
> > +     return (struct qedn_task_ctx *)((((u64)(le32_to_cpu(p->hi)) << 32=
)
> > +                                     + le32_to_cpu(p->lo)));
> > +}
> > +
> > +void qedn_io_work_cq(struct qedn_ctx *qedn, struct nvmetcp_fw_cqe *cqe=
)
> > +{
> > +     struct qedn_task_ctx *qedn_task =3D NULL;
> > +     struct qedn_conn_ctx *conn_ctx =3D NULL;
> > +     u16 itid;
> > +     u32 cid;
> > +
> > +     conn_ctx =3D qedn_get_conn_hash(qedn, le16_to_cpu(cqe->conn_id));
> > +     if (unlikely(!conn_ctx)) {
> > +             pr_err("CID 0x%x: Failed to fetch conn_ctx from hash\n",
> > +                    le16_to_cpu(cqe->conn_id));
> > +
> > +             return;
> > +     }
> > +
> > +     cid =3D conn_ctx->fw_cid;
> > +     itid =3D le16_to_cpu(cqe->itid);
> > +     qedn_task =3D qedn_cqe_get_active_task(cqe);
> > +     if (unlikely(!qedn_task))
> > +             return;
> > +
> > +     if (likely(cqe->cqe_type =3D=3D NVMETCP_FW_CQE_TYPE_NORMAL)) {
> > +             /* Placeholder - verify the connection was established */
> > +
> > +             switch (cqe->task_type) {
> > +             case NVMETCP_TASK_TYPE_HOST_WRITE:
> > +             case NVMETCP_TASK_TYPE_HOST_READ:
> > +
> > +                     /* Placeholder - IO flow */
> > +
> > +                     break;
> > +
> > +             case NVMETCP_TASK_TYPE_HOST_READ_NO_CQE:
> > +
> > +                     /* Placeholder - IO flow */
> > +
> > +                     break;
> > +
> > +             case NVMETCP_TASK_TYPE_INIT_CONN_REQUEST:
> > +
> > +                     /* Placeholder - ICReq flow */
> > +
> > +                     break;
> > +             default:
> > +                     pr_info("Could not identify task type\n");
> > +             }
> > +     } else {
> > +             /* Placeholder - Recovery flows */
> > +     }
> > +}
> >
> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke                Kernel Storage Architect
> hare@suse.de                              +49 911 74053 688
> SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> HRB 36809 (AG N=C3=BCrnberg), Gesch=C3=A4ftsf=C3=BChrer: Felix Imend=C3=
=B6rffer
