Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F783376686
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 16:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237344AbhEGOBz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 10:01:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237334AbhEGOBx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 10:01:53 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72A19C061574
        for <netdev@vger.kernel.org>; Fri,  7 May 2021 07:00:51 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id b17so10386483ede.0
        for <netdev@vger.kernel.org>; Fri, 07 May 2021 07:00:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ydbOpGsPhkv1euromDzfPzz0RdLgjBSNKHu+ZKR89Wo=;
        b=cfKLXwmo010tT+uuc5Hdp17G8vCJ03TQD9IV9/X3a+j6B0toSWQLH9SHM74eggdCyl
         S91AGm1KBCeuCRsMZEqS1Qc3L+KOxlswcYxJ8zdfDq6M1SrXxIRbZp6qNcXOnmYIEtFy
         6diy1PT0PT84BYLAcA0tgXPt+SnGlaVo1Tdsk2Snx6dGPfVj9I3xOlKQAdFGHHgd5xbQ
         YVf+NSmXi3Vyut7IJoZN6gDykCiDxpyN/fE/zxQHZ9439ft9QrsLP1x0GrQ1TkQAKv1C
         H8curoumiyazCk7Qxz7dGK5w1KsXXu1bWbo9Q3WnWPmz1gSKkIMDMNLjUAtqsUeIlGtL
         Dn4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ydbOpGsPhkv1euromDzfPzz0RdLgjBSNKHu+ZKR89Wo=;
        b=Ya6H7HyIUbW6e5z/B8fITUkTk/eGU5okXX0F5tKB7f74XnzGwIT4u5VtKKzGbza88G
         lFgmeQllblx/X9VLGunMzRVacaKtyRedoNe6XMGLSKe95pc/sP0xnT0rz+ww8dUqUHWO
         upji8uBQAt3glf5xVlbvT3qRyKZS8OBiIEaDAOMleC0u4+ct+sew1wgXWotUzZhFcGhJ
         hxxs4+xmelKjPMXlYRPCg7jEIfgbuJYDqavYLJ7m0U9op+hSCio7NfexiQuEhV76Tmkj
         ByT6cbNu8Xw6rkU4j4sm0B+wwgIPZR5fKRMYauJJ9lkAZzgSTAm3RCI+6fAShcNUo9ib
         DHAw==
X-Gm-Message-State: AOAM531lpXRfko5EA3tOu3mtFh/vsdbGEdU6YfOm+vh2SFDP3EEaceY0
        FcTL/3sYFF2OGb5CYLDkW+u+SPuCIVCB5eEQOls=
X-Google-Smtp-Source: ABdhPJwmoLdlIBtpTCQRQ7QVp3MPlDXkjOkpchimjpLPRiqOkvtDTAdoUgBHf9Fw+CRKyP+IPq5mwmLvYf9kiMRQGek=
X-Received: by 2002:a05:6402:57:: with SMTP id f23mr11407425edu.323.1620396049871;
 Fri, 07 May 2021 07:00:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210429190926.5086-1-smalin@marvell.com> <20210429190926.5086-24-smalin@marvell.com>
 <3b9b048f-94e3-9bef-6d32-fc683636b649@suse.de>
In-Reply-To: <3b9b048f-94e3-9bef-6d32-fc683636b649@suse.de>
From:   Shai Malin <malin1024@gmail.com>
Date:   Fri, 7 May 2021 17:00:32 +0300
Message-ID: <CAKKgK4wfaqLdRsuC8AaS3krhD+_4zrpF_LAk6G6BnKpASJ1GUQ@mail.gmail.com>
Subject: Re: [RFC PATCH v4 23/27] qedn: Add support of Task and SGL
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

On 5/2/21 2:48 PM, Hannes Reinecke wrote:
> On 4/29/21 9:09 PM, Shai Malin wrote:
> > From: Prabhakar Kushwaha <pkushwaha@marvell.com>
> >
> > This patch will add support of Task and SGL which is used
> > for slowpath and fast path IO. here Task is IO granule used
> > by firmware to perform tasks
> >
> > The internal implementation:
> > - Create task/sgl resources used by all connection
> > - Provide APIs to allocate and free task.
> > - Add task support during connection establishment i.e. slowpath
> >
> > Acked-by: Igor Russkikh <irusskikh@marvell.com>
> > Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> > Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
> > Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
> > Signed-off-by: Ariel Elior <aelior@marvell.com>
> > Signed-off-by: Shai Malin <smalin@marvell.com>
> > ---
> >   drivers/nvme/hw/qedn/qedn.h      |  66 +++++
> >   drivers/nvme/hw/qedn/qedn_conn.c |  43 +++-
> >   drivers/nvme/hw/qedn/qedn_main.c |  34 ++-
> >   drivers/nvme/hw/qedn/qedn_task.c | 411 ++++++++++++++++++++++++++++++=
+
> >   4 files changed, 550 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/nvme/hw/qedn/qedn.h b/drivers/nvme/hw/qedn/qedn.h
> > index bd9a250cb2f5..880ca245b02c 100644
> > --- a/drivers/nvme/hw/qedn/qedn.h
> > +++ b/drivers/nvme/hw/qedn/qedn.h
> > @@ -50,6 +50,21 @@
> >   #define QEDN_FW_CQ_FP_WQ_WORKQUEUE "qedn_fw_cq_fp_wq"
> >   #define QEDN_NVME_REQ_FP_WQ_WORKQUEUE "qedn_nvme_req_fp_wq"
> >
> > +/* Protocol defines */
> > +#define QEDN_MAX_IO_SIZE QED_NVMETCP_MAX_IO_SIZE
> > +
> > +#define QEDN_SGE_BUFF_SIZE 4096
> > +#define QEDN_MAX_SGES_PER_TASK DIV_ROUND_UP(QEDN_MAX_IO_SIZE, QEDN_SGE=
_BUFF_SIZE)
> > +#define QEDN_FW_SGE_SIZE sizeof(struct nvmetcp_sge)
> > +#define QEDN_MAX_FW_SGL_SIZE ((QEDN_MAX_SGES_PER_TASK) * QEDN_FW_SGE_S=
IZE)
> > +#define QEDN_FW_SLOW_IO_MIN_SGE_LIMIT (9700 / 6)
> > +
> > +#define QEDN_MAX_HW_SECTORS (QEDN_MAX_IO_SIZE / 512)
> > +#define QEDN_MAX_SEGMENTS QEDN_MAX_SGES_PER_TASK
> > +
> > +#define QEDN_TASK_INSIST_TMO 1000 /* 1 sec */
> > +#define QEDN_INVALID_ITID 0xFFFF
> > +
> >   /*
> >    * TCP offload stack default configurations and defines.
> >    * Future enhancements will allow controlling the configurable
> > @@ -95,6 +110,15 @@ enum qedn_state {
> >       QEDN_STATE_MODULE_REMOVE_ONGOING,
> >   };
> >
> > +struct qedn_io_resources {
> > +     /* Lock for IO resources */
> > +     spinlock_t resources_lock;
> > +     struct list_head task_free_list;
> > +     u32 num_alloc_tasks;
> > +     u32 num_free_tasks;
> > +     u32 no_avail_resrc_cnt;
> > +};
> > +
> >   /* Per CPU core params */
> >   struct qedn_fp_queue {
> >       struct qed_chain cq_chain;
> > @@ -104,6 +128,10 @@ struct qedn_fp_queue {
> >       struct qed_sb_info *sb_info;
> >       unsigned int cpu;
> >       struct work_struct fw_cq_fp_wq_entry;
> > +
> > +     /* IO related resources for host */
> > +     struct qedn_io_resources host_resrc;
> > +
> >       u16 sb_id;
> >       char irqname[QEDN_IRQ_NAME_LEN];
> >   };
> > @@ -130,6 +158,8 @@ struct qedn_ctx {
> >       /* Connections */
> >       DECLARE_HASHTABLE(conn_ctx_hash, 16);
> >
> > +     u32 num_tasks_per_pool;
> > +
> >       /* Fast path queues */
> >       u8 num_fw_cqs;
> >       struct qedn_fp_queue *fp_q_arr;
> > @@ -137,6 +167,27 @@ struct qedn_ctx {
> >       dma_addr_t fw_cq_array_phy; /* Physical address of fw_cq_array_vi=
rt */
> >       struct workqueue_struct *nvme_req_fp_wq;
> >       struct workqueue_struct *fw_cq_fp_wq;
> > +
> > +     /* Fast Path Tasks */
> > +     struct qed_nvmetcp_tid  tasks;
> > +};
> > +
> > +struct qedn_task_ctx {
> > +     struct qedn_conn_ctx *qedn_conn;
> > +     struct qedn_ctx *qedn;
> > +     void *fw_task_ctx;
> > +     struct qedn_fp_queue *fp_q;
> > +     struct scatterlist *nvme_sg;
> > +     struct nvme_tcp_ofld_req *req; /* currently proccessed request */
> > +     struct list_head entry;
> > +     spinlock_t lock; /* To protect task resources */
> > +     bool valid;
> > +     unsigned long flags; /* Used by qedn_task_flags */
> > +     u32 task_size;
> > +     u16 itid;
> > +     u16 cccid;
> > +     int req_direction;
> > +     struct storage_sgl_task_params sgl_task_params;
> >   };
> >
> >   struct qedn_endpoint {
> > @@ -243,6 +294,7 @@ struct qedn_conn_ctx {
> >       struct nvme_tcp_ofld_ctrl *ctrl;
> >       u32 conn_handle;
> >       u32 fw_cid;
> > +     u8 default_cq;
> >
> >       atomic_t est_conn_indicator;
> >       atomic_t destroy_conn_indicator;
> > @@ -260,6 +312,11 @@ struct qedn_conn_ctx {
> >       dma_addr_t host_cccid_itid_phy_addr;
> >       struct qedn_endpoint ep;
> >       int abrt_flag;
> > +     /* Spinlock for accessing active_task_list */
> > +     spinlock_t task_list_lock;
> > +     struct list_head active_task_list;
> > +     atomic_t num_active_tasks;
> > +     atomic_t num_active_fw_tasks;
> >
> >       /* Connection resources - turned on to indicate what resource was
> >        * allocated, to that it can later be released.
> > @@ -279,6 +336,7 @@ struct qedn_conn_ctx {
> >   enum qedn_conn_resources_state {
> >       QEDN_CONN_RESRC_FW_SQ,
> >       QEDN_CONN_RESRC_ACQUIRE_CONN,
> > +     QEDN_CONN_RESRC_TASKS,
> >       QEDN_CONN_RESRC_CCCID_ITID_MAP,
> >       QEDN_CONN_RESRC_TCP_PORT,
> >       QEDN_CONN_RESRC_MAX =3D 64
> > @@ -309,5 +367,13 @@ inline int qedn_validate_cccid_in_range(struct qed=
n_conn_ctx *conn_ctx, u16 ccci
> >   void qedn_queue_request(struct qedn_conn_ctx *qedn_conn, struct nvme_=
tcp_ofld_req *req);
> >   void qedn_nvme_req_fp_wq_handler(struct work_struct *work);
> >   void qedn_io_work_cq(struct qedn_ctx *qedn, struct nvmetcp_fw_cqe *cq=
e);
> > +int qedn_alloc_tasks(struct qedn_conn_ctx *conn_ctx);
> > +inline int qedn_qid(struct nvme_tcp_ofld_queue *queue);
> > +struct qedn_task_ctx *
> > +     qedn_get_task_from_pool_insist(struct qedn_conn_ctx *conn_ctx, u1=
6 cccid);
> > +void qedn_common_clear_fw_sgl(struct storage_sgl_task_params *sgl_task=
_params);
> > +void qedn_return_active_tasks(struct qedn_conn_ctx *conn_ctx);
> > +void qedn_destroy_free_tasks(struct qedn_fp_queue *fp_q,
> > +                          struct qedn_io_resources *io_resrc);
> >
> >   #endif /* _QEDN_H_ */
> > diff --git a/drivers/nvme/hw/qedn/qedn_conn.c b/drivers/nvme/hw/qedn/qe=
dn_conn.c
> > index 90d8aa36d219..10a80fbeac43 100644
> > --- a/drivers/nvme/hw/qedn/qedn_conn.c
> > +++ b/drivers/nvme/hw/qedn/qedn_conn.c
> > @@ -29,6 +29,11 @@ static const char * const qedn_conn_state_str[] =3D =
{
> >       NULL
> >   };
> >
> > +inline int qedn_qid(struct nvme_tcp_ofld_queue *queue)
> > +{
> > +     return queue - queue->ctrl->queues;
> > +}
> > +
> >   int qedn_set_con_state(struct qedn_conn_ctx *conn_ctx, enum qedn_conn=
_state new_state)
> >   {
> >       spin_lock_bh(&conn_ctx->conn_state_lock);
> > @@ -146,6 +151,11 @@ static void qedn_release_conn_ctx(struct qedn_conn=
_ctx *conn_ctx)
> >               clear_bit(QEDN_CONN_RESRC_ACQUIRE_CONN, &conn_ctx->resrc_=
state);
> >       }
> >
> > +     if (test_bit(QEDN_CONN_RESRC_TASKS, &conn_ctx->resrc_state)) {
> > +             clear_bit(QEDN_CONN_RESRC_TASKS, &conn_ctx->resrc_state);
> > +                     qedn_return_active_tasks(conn_ctx);
> > +     }
> > +
> >       if (test_bit(QEDN_CONN_RESRC_CCCID_ITID_MAP, &conn_ctx->resrc_sta=
te)) {
> >               dma_free_coherent(&qedn->pdev->dev,
> >                                 conn_ctx->sq_depth *
> > @@ -247,6 +257,7 @@ static int qedn_nvmetcp_offload_conn(struct qedn_co=
nn_ctx *conn_ctx)
> >       offld_prms.max_rt_time =3D QEDN_TCP_MAX_RT_TIME;
> >       offld_prms.sq_pbl_addr =3D
> >               (u64)qed_chain_get_pbl_phys(&qedn_ep->fw_sq_chain);
> > +     offld_prms.default_cq =3D conn_ctx->default_cq;
> >
> >       rc =3D qed_ops->offload_conn(qedn->cdev,
> >                                  conn_ctx->conn_handle,
> > @@ -375,6 +386,9 @@ int qedn_event_cb(void *context, u8 fw_event_code, =
void *event_ring_data)
> >   static int qedn_prep_and_offload_queue(struct qedn_conn_ctx *conn_ctx=
)
> >   {
> >       struct qedn_ctx *qedn =3D conn_ctx->qedn;
> > +     struct qedn_io_resources *io_resrc;
> > +     struct qedn_fp_queue *fp_q;
> > +     u8 default_cq_idx, qid;
> >       size_t dma_size;
> >       int rc;
> >
> > @@ -387,6 +401,8 @@ static int qedn_prep_and_offload_queue(struct qedn_=
conn_ctx *conn_ctx)
> >       set_bit(QEDN_CONN_RESRC_FW_SQ, &conn_ctx->resrc_state);
> >       INIT_LIST_HEAD(&conn_ctx->host_pend_req_list);
> >       spin_lock_init(&conn_ctx->nvme_req_lock);
> > +     atomic_set(&conn_ctx->num_active_tasks, 0);
> > +     atomic_set(&conn_ctx->num_active_fw_tasks, 0);
> >
> >       rc =3D qed_ops->acquire_conn(qedn->cdev,
> >                                  &conn_ctx->conn_handle,
> > @@ -401,7 +417,32 @@ static int qedn_prep_and_offload_queue(struct qedn=
_conn_ctx *conn_ctx)
> >                conn_ctx->conn_handle);
> >       set_bit(QEDN_CONN_RESRC_ACQUIRE_CONN, &conn_ctx->resrc_state);
> >
> > -     /* Placeholder - Allocate task resources and initialize fields */
> > +     qid =3D qedn_qid(conn_ctx->queue);
> > +     default_cq_idx =3D qid ? qid - 1 : 0; /* Offset adminq */
> > +
> > +     conn_ctx->default_cq =3D (default_cq_idx % qedn->num_fw_cqs);
> > +     fp_q =3D &qedn->fp_q_arr[conn_ctx->default_cq];
> > +     conn_ctx->fp_q =3D fp_q;
> > +     io_resrc =3D &fp_q->host_resrc;
> > +
> > +     /* The first connection on each fp_q will fill task
> > +      * resources
> > +      */
> > +     spin_lock(&io_resrc->resources_lock);
> > +     if (io_resrc->num_alloc_tasks =3D=3D 0) {
> > +             rc =3D qedn_alloc_tasks(conn_ctx);
> > +             if (rc) {
> > +                     pr_err("Failed allocating tasks: CID=3D0x%x\n",
> > +                            conn_ctx->fw_cid);
> > +                     spin_unlock(&io_resrc->resources_lock);
> > +                     goto rel_conn;
> > +             }
> > +     }
> > +     spin_unlock(&io_resrc->resources_lock);
> > +
> > +     spin_lock_init(&conn_ctx->task_list_lock);
> > +     INIT_LIST_HEAD(&conn_ctx->active_task_list);
> > +     set_bit(QEDN_CONN_RESRC_TASKS, &conn_ctx->resrc_state);
> >    >          rc =3D qedn_fetch_tcp_port(conn_ctx);
> >       if (rc)
> > diff --git a/drivers/nvme/hw/qedn/qedn_main.c b/drivers/nvme/hw/qedn/qe=
dn_main.c
> > index 38f23dbb03a5..8d9c19d63480 100644
> > --- a/drivers/nvme/hw/qedn/qedn_main.c
> > +++ b/drivers/nvme/hw/qedn/qedn_main.c
> > @@ -30,6 +30,12 @@ __be16 qedn_get_in_port(struct sockaddr_storage *sa)
> >               : ((struct sockaddr_in6 *)sa)->sin6_port;
> >   }
> >
> > +static void qedn_init_io_resc(struct qedn_io_resources *io_resrc)
> > +{
> > +     spin_lock_init(&io_resrc->resources_lock);
> > +     INIT_LIST_HEAD(&io_resrc->task_free_list);
> > +}
> > +
> >   struct qedn_llh_filter *qedn_add_llh_filter(struct qedn_ctx *qedn, u1=
6 tcp_port)
> >   {
> >       struct qedn_llh_filter *llh_filter =3D NULL;
> > @@ -436,6 +442,8 @@ static struct nvme_tcp_ofld_ops qedn_ofld_ops =3D {
> >                *      NVMF_OPT_HDR_DIGEST | NVMF_OPT_DATA_DIGEST |
> >                *      NVMF_OPT_NR_POLL_QUEUES | NVMF_OPT_TOS
> >                */
> > +     .max_hw_sectors =3D QEDN_MAX_HW_SECTORS,
> > +     .max_segments =3D QEDN_MAX_SEGMENTS,
> >       .claim_dev =3D qedn_claim_dev,
> >       .setup_ctrl =3D qedn_setup_ctrl,
> >       .release_ctrl =3D qedn_release_ctrl,
> > @@ -657,8 +665,24 @@ static void qedn_remove_pf_from_gl_list(struct qed=
n_ctx *qedn)
> >       mutex_unlock(&qedn_glb.glb_mutex);
> >   }
> >
> > +static void qedn_call_destroy_free_tasks(struct qedn_fp_queue *fp_q,
> > +                                      struct qedn_io_resources *io_res=
rc)
> > +{
> > +     if (list_empty(&io_resrc->task_free_list))
> > +             return;
> > +
> > +     if (io_resrc->num_alloc_tasks !=3D io_resrc->num_free_tasks)
> > +             pr_err("Task Pool:Not all returned allocated=3D0x%x, free=
=3D0x%x\n",
> > +                    io_resrc->num_alloc_tasks, io_resrc->num_free_task=
s);
> > +
> > +     qedn_destroy_free_tasks(fp_q, io_resrc);
> > +     if (io_resrc->num_free_tasks)
> > +             pr_err("Expected num_free_tasks to be 0\n");
> > +}
> > +
> >   static void qedn_free_function_queues(struct qedn_ctx *qedn)
> >   {
> > +     struct qedn_io_resources *host_resrc;
> >       struct qed_sb_info *sb_info =3D NULL;
> >       struct qedn_fp_queue *fp_q;
> >       int i;
> > @@ -673,6 +697,9 @@ static void qedn_free_function_queues(struct qedn_c=
tx *qedn)
> >       /* Free the fast path queues*/
> >       for (i =3D 0; i < qedn->num_fw_cqs; i++) {
> >               fp_q =3D &qedn->fp_q_arr[i];
> > +             host_resrc =3D &fp_q->host_resrc;
> > +
> > +             qedn_call_destroy_free_tasks(fp_q, host_resrc);
> >
> >               /* Free SB */
> >               sb_info =3D fp_q->sb_info;
> > @@ -769,7 +796,8 @@ static int qedn_alloc_function_queues(struct qedn_c=
tx *qedn)
> >               goto mem_alloc_failure;
> >       }
> >
> > -     /* placeholder - create task pools */
> > +     qedn->num_tasks_per_pool =3D
> > +             qedn->pf_params.nvmetcp_pf_params.num_tasks / qedn->num_f=
w_cqs;
> >
> >       for (i =3D 0; i < qedn->num_fw_cqs; i++) {
> >               fp_q =3D &qedn->fp_q_arr[i];
> > @@ -811,7 +839,7 @@ static int qedn_alloc_function_queues(struct qedn_c=
tx *qedn)
> >               fp_q->qedn =3D qedn;
> >               INIT_WORK(&fp_q->fw_cq_fp_wq_entry, qedn_fw_cq_fq_wq_hand=
ler);
> >
> > -             /* Placeholder - Init IO-path resources */
> > +             qedn_init_io_resc(&fp_q->host_resrc);
> >       }
> >
> >       return 0;
> > @@ -1005,7 +1033,7 @@ static int __qedn_probe(struct pci_dev *pdev)
> >
> >       /* NVMeTCP start HW PF */
> >       rc =3D qed_ops->start(qedn->cdev,
> > -                         NULL /* Placeholder for FW IO-path resources =
*/,
> > +                         &qedn->tasks,
> >                           qedn,
> >                           qedn_event_cb);
> >       if (rc) {
> > diff --git a/drivers/nvme/hw/qedn/qedn_task.c b/drivers/nvme/hw/qedn/qe=
dn_task.c
> > index d3474188efdc..54f2f4cba6ea 100644
> > --- a/drivers/nvme/hw/qedn/qedn_task.c
> > +++ b/drivers/nvme/hw/qedn/qedn_task.c
> > @@ -11,6 +11,263 @@
> >   /* Driver includes */
> >   #include "qedn.h"
> >
> > +static bool qedn_sgl_has_small_mid_sge(struct nvmetcp_sge *sgl, u16 sg=
e_count)
> > +{
> > +     u16 sge_num;
> > +
> > +     if (sge_count > 8) {
> > +             for (sge_num =3D 0; sge_num < sge_count; sge_num++) {
> > +                     if (le32_to_cpu(sgl[sge_num].sge_len) <
> > +                         QEDN_FW_SLOW_IO_MIN_SGE_LIMIT)
> > +                             return true; /* small middle SGE found */
> > +             }
> > +     }
> > +
> > +     return false; /* no small middle SGEs */
> > +}
> > +
> > +static int qedn_init_sgl(struct qedn_ctx *qedn, struct qedn_task_ctx *=
qedn_task)
> > +{
> > +     struct storage_sgl_task_params *sgl_task_params;
> > +     enum dma_data_direction dma_dir;
> > +     struct scatterlist *sg;
> > +     struct request *rq;
> > +     u16 num_sges;
> > +     int index;
> > +     int rc;
> > +
> > +     sgl_task_params =3D &qedn_task->sgl_task_params;
> > +     rq =3D blk_mq_rq_from_pdu(qedn_task->req);
> > +     if (qedn_task->task_size =3D=3D 0) {
> > +             sgl_task_params->num_sges =3D 0;
> > +
> > +             return 0;
> > +     }
> > +
> > +     /* Convert BIO to scatterlist */
> > +     num_sges =3D blk_rq_map_sg(rq->q, rq, qedn_task->nvme_sg);
> > +     if (qedn_task->req_direction =3D=3D WRITE)
> > +             dma_dir =3D DMA_TO_DEVICE;
> > +     else
> > +             dma_dir =3D DMA_FROM_DEVICE;
> > +
> > +     /* DMA map the scatterlist */
> > +     if (dma_map_sg(&qedn->pdev->dev, qedn_task->nvme_sg, num_sges, dm=
a_dir) !=3D num_sges) {
> > +             pr_err("Couldn't map sgl\n");
> > +             rc =3D -EPERM;
> > +
> > +             return rc;
> > +     }
> > +
> > +     sgl_task_params->total_buffer_size =3D qedn_task->task_size;
> > +     sgl_task_params->num_sges =3D num_sges;
> > +
> > +     for_each_sg(qedn_task->nvme_sg, sg, num_sges, index) {
> > +             DMA_REGPAIR_LE(sgl_task_params->sgl[index].sge_addr, sg_d=
ma_address(sg));
> > +             sgl_task_params->sgl[index].sge_len =3D cpu_to_le32(sg_dm=
a_len(sg));
> > +     }
> > +
> > +     /* Relevant for Host Write Only */
> > +     sgl_task_params->small_mid_sge =3D (qedn_task->req_direction =3D=
=3D READ) ?
> > +             false :
> > +             qedn_sgl_has_small_mid_sge(sgl_task_params->sgl,
> > +                                        sgl_task_params->num_sges);
> > +
> > +     return 0;
> > +}
> > +
> > +static void qedn_free_nvme_sg(struct qedn_task_ctx *qedn_task)
> > +{
> > +     kfree(qedn_task->nvme_sg);
> > +     qedn_task->nvme_sg =3D NULL;
> > +}
> > +
> > +static void qedn_free_fw_sgl(struct qedn_task_ctx *qedn_task)
> > +{
> > +     struct qedn_ctx *qedn =3D qedn_task->qedn;
> > +     dma_addr_t sgl_pa;
> > +
> > +     sgl_pa =3D HILO_DMA_REGPAIR(qedn_task->sgl_task_params.sgl_phys_a=
ddr);
> > +     dma_free_coherent(&qedn->pdev->dev,
> > +                       QEDN_MAX_FW_SGL_SIZE,
> > +                       qedn_task->sgl_task_params.sgl,
> > +                       sgl_pa);
> > +     qedn_task->sgl_task_params.sgl =3D NULL;
> > +}
> > +
> > +static void qedn_destroy_single_task(struct qedn_task_ctx *qedn_task)
> > +{
> > +     u16 itid;
> > +
> > +     itid =3D qedn_task->itid;
> > +     list_del(&qedn_task->entry);
> > +     qedn_free_nvme_sg(qedn_task);
> > +     qedn_free_fw_sgl(qedn_task);
> > +     kfree(qedn_task);
> > +     qedn_task =3D NULL;
> > +}
> > +
> > +void qedn_destroy_free_tasks(struct qedn_fp_queue *fp_q,
> > +                          struct qedn_io_resources *io_resrc)
> > +{
> > +     struct qedn_task_ctx *qedn_task, *task_tmp;
> > +
> > +     /* Destroy tasks from the free task list */
> > +     list_for_each_entry_safe(qedn_task, task_tmp,
> > +                              &io_resrc->task_free_list, entry) {
> > +             qedn_destroy_single_task(qedn_task);
> > +             io_resrc->num_free_tasks -=3D 1;
> > +     }
> > +}
> > +
> > +static int qedn_alloc_nvme_sg(struct qedn_task_ctx *qedn_task)
> > +{
> > +     int rc;
> > +
> > +     qedn_task->nvme_sg =3D kcalloc(QEDN_MAX_SGES_PER_TASK,
> > +                                  sizeof(*qedn_task->nvme_sg), GFP_KER=
NEL);
> > +     if (!qedn_task->nvme_sg) {
> > +             rc =3D -ENOMEM;
> > +
> > +             return rc;
> > +     }
> > +
> > +     return 0;
> > +}
> > +
> > +static int qedn_alloc_fw_sgl(struct qedn_task_ctx *qedn_task)
> > +{
> > +     struct qedn_ctx *qedn =3D qedn_task->qedn_conn->qedn;
> > +     dma_addr_t fw_sgl_phys;
> > +
> > +     qedn_task->sgl_task_params.sgl =3D
> > +             dma_alloc_coherent(&qedn->pdev->dev, QEDN_MAX_FW_SGL_SIZE=
,
> > +                                &fw_sgl_phys, GFP_KERNEL);
> > +     if (!qedn_task->sgl_task_params.sgl) {
> > +             pr_err("Couldn't allocate FW sgl\n");
> > +
> > +             return -ENOMEM;
> > +     }
> > +
> > +     DMA_REGPAIR_LE(qedn_task->sgl_task_params.sgl_phys_addr, fw_sgl_p=
hys);
> > +
> > +     return 0;
> > +}
> > +
> > +static inline void *qedn_get_fw_task(struct qed_nvmetcp_tid *info, u16=
 itid)
> > +{
> > +     return (void *)(info->blocks[itid / info->num_tids_per_block] +
> > +                     (itid % info->num_tids_per_block) * info->size);
> > +}
> > +
> > +static struct qedn_task_ctx *qedn_alloc_task(struct qedn_conn_ctx *con=
n_ctx, u16 itid)
> > +{
> > +     struct qedn_ctx *qedn =3D conn_ctx->qedn;
> > +     struct qedn_task_ctx *qedn_task;
> > +     void *fw_task_ctx;
> > +     int rc =3D 0;
> > +
> > +     qedn_task =3D kzalloc(sizeof(*qedn_task), GFP_KERNEL);
> > +     if (!qedn_task)
> > +             return NULL;
> > +
>
> As this is a pool, why don't you use mempools here?

As far as I know, the main reason to use mempool is where memory allocation=
s
cannot be allowed to fail. With our design, the per CPU task pool is alloca=
ted
as part of the first connection offload (from this CPU) and will be used fo=
r
all the IOs on this CPU. As part of the IO path flow, we are re-using the s=
ame
task elements from the pool, hence I believe it's not different from any ot=
her
memory we are allocating as part of driver load and connection offload whic=
h
is allowed to fail.

>
> > +     spin_lock_init(&qedn_task->lock);
> > +     fw_task_ctx =3D qedn_get_fw_task(&qedn->tasks, itid);
> > +     if (!fw_task_ctx) {
> > +             pr_err("iTID: 0x%x; Failed getting fw_task_ctx memory\n",=
 itid);
> > +             goto release_task;
> > +     }
> > +
> > +     /* No need to memset fw_task_ctx - its done in the HSI func */
> > +     qedn_task->qedn_conn =3D conn_ctx;
> > +     qedn_task->qedn =3D qedn;
> > +     qedn_task->fw_task_ctx =3D fw_task_ctx;
> > +     qedn_task->valid =3D 0;
> > +     qedn_task->flags =3D 0;
> > +     qedn_task->itid =3D itid;
> > +     rc =3D qedn_alloc_fw_sgl(qedn_task);
> > +     if (rc) {
> > +             pr_err("iTID: 0x%x; Failed allocating FW sgl\n", itid);
> > +             goto release_task;
> > +     }
> > +
> > +     rc =3D qedn_alloc_nvme_sg(qedn_task);
> > +     if (rc) {
> > +             pr_err("iTID: 0x%x; Failed allocating FW sgl\n", itid);
> > +             goto release_fw_sgl;
> > +     }
> > +
> > +     return qedn_task;
> > +
> > +release_fw_sgl:
> > +     qedn_free_fw_sgl(qedn_task);
> > +release_task:
> > +     kfree(qedn_task);
> > +
> > +     return NULL;
> > +}
> > +
> > +int qedn_alloc_tasks(struct qedn_conn_ctx *conn_ctx)
> > +{
> > +     struct qedn_ctx *qedn =3D conn_ctx->qedn;
> > +     struct qedn_task_ctx *qedn_task =3D NULL;
> > +     struct qedn_io_resources *io_resrc;
> > +     u16 itid, start_itid, offset;
> > +     struct qedn_fp_queue *fp_q;
> > +     int i, rc;
> > +
> > +     fp_q =3D conn_ctx->fp_q;
> > +
> > +     offset =3D fp_q->sb_id;
> > +     io_resrc =3D &fp_q->host_resrc;
> > +
> > +     start_itid =3D qedn->num_tasks_per_pool * offset;
> > +     for (i =3D 0; i < qedn->num_tasks_per_pool; ++i) {
> > +             itid =3D start_itid + i;
> > +             qedn_task =3D qedn_alloc_task(conn_ctx, itid);
> > +             if (!qedn_task) {
> > +                     pr_err("Failed allocating task\n");
> > +                     rc =3D -ENOMEM;
> > +                     goto release_tasks;
> > +             }
> > +
> > +             qedn_task->fp_q =3D fp_q;
> > +             io_resrc->num_free_tasks +=3D 1;
> > +             list_add_tail(&qedn_task->entry, &io_resrc->task_free_lis=
t);
> > +     }
> > +
> > +     io_resrc->num_alloc_tasks =3D io_resrc->num_free_tasks;
> > +
> > +     return 0;
> > +
> > +release_tasks:
> > +     qedn_destroy_free_tasks(fp_q, io_resrc);
> > +
> > +     return rc;
> > +}
> > +
> > +void qedn_common_clear_fw_sgl(struct storage_sgl_task_params *sgl_task=
_params)
> > +{
> > +     u16 sge_cnt =3D sgl_task_params->num_sges;
> > +
> > +     memset(&sgl_task_params->sgl[(sge_cnt - 1)], 0,
> > +            sizeof(struct nvmetcp_sge));
> > +     sgl_task_params->total_buffer_size =3D 0;
> > +     sgl_task_params->small_mid_sge =3D false;
> > +     sgl_task_params->num_sges =3D 0;
> > +}
> > +
> > +inline void qedn_host_reset_cccid_itid_entry(struct qedn_conn_ctx *con=
n_ctx,
> > +                                          u16 cccid)
> > +{
> > +     conn_ctx->host_cccid_itid[cccid].itid =3D cpu_to_le16(QEDN_INVALI=
D_ITID);
> > +}
> > +
> > +inline void qedn_host_set_cccid_itid_entry(struct qedn_conn_ctx *conn_=
ctx, u16 cccid, u16 itid)
> > +{
> > +     conn_ctx->host_cccid_itid[cccid].itid =3D cpu_to_le16(itid);
> > +}
> > +
> >   inline int qedn_validate_cccid_in_range(struct qedn_conn_ctx *conn_ct=
x, u16 cccid)
> >   {
> >       int rc =3D 0;
> > @@ -23,6 +280,160 @@ inline int qedn_validate_cccid_in_range(struct qed=
n_conn_ctx *conn_ctx, u16 ccci
> >       return rc;
> >   }
> >
> > +static void qedn_clear_sgl(struct qedn_ctx *qedn,
> > +                        struct qedn_task_ctx *qedn_task)
> > +{
> > +     struct storage_sgl_task_params *sgl_task_params;
> > +     enum dma_data_direction dma_dir;
> > +     u32 sge_cnt;
> > +
> > +     sgl_task_params =3D &qedn_task->sgl_task_params;
> > +     sge_cnt =3D sgl_task_params->num_sges;
> > +
> > +     /* Nothing to do if no SGEs were used */
> > +     if (!qedn_task->task_size || !sge_cnt)
> > +             return;
> > +
> > +     dma_dir =3D (qedn_task->req_direction =3D=3D WRITE ? DMA_TO_DEVIC=
E : DMA_FROM_DEVICE);
> > +     dma_unmap_sg(&qedn->pdev->dev, qedn_task->nvme_sg, sge_cnt, dma_d=
ir);
> > +     memset(&qedn_task->nvme_sg[(sge_cnt - 1)], 0, sizeof(struct scatt=
erlist));
> > +     qedn_common_clear_fw_sgl(sgl_task_params);
> > +     qedn_task->task_size =3D 0;
> > +}
> > +
> > +static void qedn_clear_task(struct qedn_conn_ctx *conn_ctx,
> > +                         struct qedn_task_ctx *qedn_task)
> > +{
> > +     /* Task lock isn't needed since it is no longer in use */
> > +     qedn_clear_sgl(conn_ctx->qedn, qedn_task);
> > +     qedn_task->valid =3D 0;
> > +     qedn_task->flags =3D 0;
> > +
> > +     atomic_dec(&conn_ctx->num_active_tasks);
> > +}
> > +
> > +void qedn_return_active_tasks(struct qedn_conn_ctx *conn_ctx)
> > +{
> > +     struct qedn_fp_queue *fp_q =3D conn_ctx->fp_q;
> > +     struct qedn_task_ctx *qedn_task, *task_tmp;
> > +     struct qedn_io_resources *io_resrc;
> > +     int num_returned_tasks =3D 0;
> > +     int num_active_tasks;
> > +
> > +     io_resrc =3D &fp_q->host_resrc;
> > +
> > +     /* Return tasks that aren't "Used by FW" to the pool */
> > +     list_for_each_entry_safe(qedn_task, task_tmp,
> > +                              &conn_ctx->active_task_list, entry) {
> > +             qedn_clear_task(conn_ctx, qedn_task);
> > +             num_returned_tasks++;
> > +     }
> > +
> > +     if (num_returned_tasks) {
> > +             spin_lock(&io_resrc->resources_lock);
> > +             /* Return tasks to FP_Q pool in one shot */
> > +
> > +             list_splice_tail_init(&conn_ctx->active_task_list,
> > +                                   &io_resrc->task_free_list);
> > +             io_resrc->num_free_tasks +=3D num_returned_tasks;
> > +             spin_unlock(&io_resrc->resources_lock);
> > +     }
> > +
> > +     num_active_tasks =3D atomic_read(&conn_ctx->num_active_tasks);
> > +     if (num_active_tasks)
> > +             pr_err("num_active_tasks is %u after cleanup.\n", num_act=
ive_tasks);
> > +}
> > +
> > +void qedn_return_task_to_pool(struct qedn_conn_ctx *conn_ctx,
> > +                           struct qedn_task_ctx *qedn_task)
> > +{
> > +     struct qedn_fp_queue *fp_q =3D conn_ctx->fp_q;
> > +     struct qedn_io_resources *io_resrc;
> > +     unsigned long lock_flags;
> > +
> > +     io_resrc =3D &fp_q->host_resrc;
> > +
> > +     spin_lock_irqsave(&qedn_task->lock, lock_flags);
> > +     qedn_task->valid =3D 0;
> > +     qedn_task->flags =3D 0;
> > +     qedn_clear_sgl(conn_ctx->qedn, qedn_task);
> > +     spin_unlock_irqrestore(&qedn_task->lock, lock_flags);
> > +
> > +     spin_lock(&conn_ctx->task_list_lock);
> > +     list_del(&qedn_task->entry);
> > +     qedn_host_reset_cccid_itid_entry(conn_ctx, qedn_task->cccid);
> > +     spin_unlock(&conn_ctx->task_list_lock);
> > +
> > +     atomic_dec(&conn_ctx->num_active_tasks);
> > +     atomic_dec(&conn_ctx->num_active_fw_tasks);
> > +
> > +     spin_lock(&io_resrc->resources_lock);
> > +     list_add_tail(&qedn_task->entry, &io_resrc->task_free_list);
> > +     io_resrc->num_free_tasks +=3D 1;
> > +     spin_unlock(&io_resrc->resources_lock);
> > +}
> > +
> > +struct qedn_task_ctx *
> > +qedn_get_free_task_from_pool(struct qedn_conn_ctx *conn_ctx, u16 cccid=
)
> > +{
> > +     struct qedn_task_ctx *qedn_task =3D NULL;
> > +     struct qedn_io_resources *io_resrc;
> > +     struct qedn_fp_queue *fp_q;
> > +
> > +     fp_q =3D conn_ctx->fp_q;
> > +     io_resrc =3D &fp_q->host_resrc;
> > +
> > +     spin_lock(&io_resrc->resources_lock);
> > +     qedn_task =3D list_first_entry_or_null(&io_resrc->task_free_list,
> > +                                          struct qedn_task_ctx, entry)=
;
> > +     if (unlikely(!qedn_task)) {
> > +             spin_unlock(&io_resrc->resources_lock);
> > +
> > +             return NULL;
> > +     }
> > +     list_del(&qedn_task->entry);
> > +     io_resrc->num_free_tasks -=3D 1;
> > +     spin_unlock(&io_resrc->resources_lock);
> > +
> > +     spin_lock(&conn_ctx->task_list_lock);
> > +     list_add_tail(&qedn_task->entry, &conn_ctx->active_task_list);
> > +     qedn_host_set_cccid_itid_entry(conn_ctx, cccid, qedn_task->itid);
> > +     spin_unlock(&conn_ctx->task_list_lock);
> > +
> > +     atomic_inc(&conn_ctx->num_active_tasks);
> > +     qedn_task->cccid =3D cccid;
> > +     qedn_task->qedn_conn =3D conn_ctx;
> > +     qedn_task->valid =3D 1;
> > +
> > +     return qedn_task;
> > +}
> > +
> > +struct qedn_task_ctx *
> > +qedn_get_task_from_pool_insist(struct qedn_conn_ctx *conn_ctx, u16 ccc=
id)
> > +{
> > +     struct qedn_task_ctx *qedn_task =3D NULL;
> > +     unsigned long timeout;
> > +
> > +     qedn_task =3D qedn_get_free_task_from_pool(conn_ctx, cccid);
> > +     if (unlikely(!qedn_task)) {
> > +             timeout =3D msecs_to_jiffies(QEDN_TASK_INSIST_TMO) + jiff=
ies;
> > +             while (1) {
> > +                     qedn_task =3D qedn_get_free_task_from_pool(conn_c=
tx, cccid);
> > +                     if (likely(qedn_task))
> > +                             break;
> > +
> > +                     msleep(100);
> > +                     if (time_after(jiffies, timeout)) {
> > +                             pr_err("Failed on timeout of fetching tas=
k\n");
> > +
> > +                             return NULL;
> > +                     }
> > +             }
> > +     }
> > +
> > +     return qedn_task;
> > +}
> > +
> >   static bool qedn_process_req(struct qedn_conn_ctx *qedn_conn)
> >   {
> >       return true;
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
