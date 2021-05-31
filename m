Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 647AE3966A9
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 19:14:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232712AbhEaRQO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 13:16:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233695AbhEaROI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 13:14:08 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA723C0018FB
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 07:15:12 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id r11so13613843edt.13
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 07:15:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=NfnQIyGYt5Xt3iHIFcTWVYKuQnAGa2T8ketEC5sgqjc=;
        b=n04qXJbEUKci2uE3A0yWHTBiMBQbpc1fncYd362WVs1gB5QE1cl9PH3T2sSbiPdHUI
         GQrfYT3xWpfKiJkSJxfisn76SfE3rZJ7rfRmo2/ca4NJLOtt+HgLWrSIxdRZincfmCdz
         JaCt5838Lqs5RMoEKDwct0CnhgMr28mooJ9dweLzAX2x0agpaj0dSbQpYvjZEs/pKHB9
         FvyZDxAEEeV3XXALrNqq/MVYKJXObkQDpuaNwz4QmAKdy9bkM0gHRDwRvwh9vb4ch6KE
         EoYMtZrYuLNQ+oZFVTV8CIdqfW+xYqS+3sk8WulDLZW0uzj0lSJsUTvFpzrSq0kr8Wv8
         fsAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=NfnQIyGYt5Xt3iHIFcTWVYKuQnAGa2T8ketEC5sgqjc=;
        b=KF4vqDhNVBMZLJMuNw4JEruhj8vRq2J/Zln51GmSaO1KzYI1mOa83I135c77E4YA16
         cBVJZR9TPAWSNvu8dmw8o8bfBgLLclC6ZWK08NYWWGkyKXMyj/qZydd1qNh4T18xsEZq
         pmP6Y2EtiU+iMU26R0Db2WKIXrzHIxMfep3udU1TYIByhK39vs3WcY3W2fxmilVv7S+q
         d5cSa4p8GUjZ+XYrtD3Dqc7IUeihNTzYINmbkQrS6fBIhWkl6EezbBb5go4eAUM2KpOP
         rJkJHzqMwadVkx3nY6tSScbJP66AZYfHyR118pNTZ+QtlgUih0XIfWj7z1x01HV83buP
         uDJw==
X-Gm-Message-State: AOAM530eFbXXfnVdbQItNwjquOxOaUaUgfcZxKtgMjrk0bbywYFOA1GN
        doBOAWroaKtipOIxQYlqgemLkvt+vKI+BVtE5UI=
X-Google-Smtp-Source: ABdhPJwwjtulAGA2+7QtY01woBBIVUSSBx/UtuZ9NqOobUcDf9BUI7ECp+gK+CC96B4YBSYkw3l+Tpg0U0e/VUxhonU=
X-Received: by 2002:a50:ab16:: with SMTP id s22mr25061933edc.323.1622470511260;
 Mon, 31 May 2021 07:15:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210527235902.2185-1-smalin@marvell.com> <20210527235902.2185-24-smalin@marvell.com>
 <1dd192c4-de2a-c95d-6798-9a02895227b2@suse.de>
In-Reply-To: <1dd192c4-de2a-c95d-6798-9a02895227b2@suse.de>
From:   Shai Malin <malin1024@gmail.com>
Date:   Mon, 31 May 2021 17:14:58 +0300
Message-ID: <CAKKgK4xEJLu4sFizWn2jSVYhzN7rmQb1BG88E-3ZHp-asPc3Zw@mail.gmail.com>
Subject: Re: [RFC PATCH v6 23/27] qedn: Add support of Task and SGL
To:     Hannes Reinecke <hare@suse.de>
Cc:     Shai Malin <smalin@marvell.com>, netdev@vger.kernel.org,
        linux-nvme@lists.infradead.org, davem@davemloft.net,
        kuba@kernel.org, Sagi Grimberg <sagi@grimberg.me>, hch@lst.de,
        axboe@fb.com, kbusch@kernel.org, Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>, okulkarni@marvell.com,
        pkushwaha@marvell.com, prabhakar.pkin@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/28/21 4:06 PM, Hannes Reinecke wrote:
> On 5/28/21 1:58 AM, Shai Malin wrote:
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
> >  drivers/nvme/hw/qedn/qedn.h      |  65 +++++++
> >  drivers/nvme/hw/qedn/qedn_conn.c |  44 ++++-
> >  drivers/nvme/hw/qedn/qedn_main.c |  34 +++-
> >  drivers/nvme/hw/qedn/qedn_task.c | 320 +++++++++++++++++++++++++++++++
> >  4 files changed, 459 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/nvme/hw/qedn/qedn.h b/drivers/nvme/hw/qedn/qedn.h
> > index d56184f58840..cfb5e1b0fbaa 100644
> > --- a/drivers/nvme/hw/qedn/qedn.h
> > +++ b/drivers/nvme/hw/qedn/qedn.h
> > @@ -40,6 +40,20 @@
> >
> >  #define QEDN_FW_CQ_FP_WQ_WORKQUEUE "qedn_fw_cq_fp_wq"
> >
> > +/* Protocol defines */
> > +#define QEDN_MAX_IO_SIZE QED_NVMETCP_MAX_IO_SIZE
> > +
> > +#define QEDN_SGE_BUFF_SIZE 4096
>
> Just one 4k page per SGE?
> What about architectures with larger page sizes?

This define is not related to platform page size, and actually,
we can remove it.

>
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
> > +#define QEDN_INVALID_ITID 0xFFFF
> > +
> >  /*
> >   * TCP offload stack default configurations and defines.
> >   * Future enhancements will allow controlling the configurable
> > @@ -84,6 +98,15 @@ enum qedn_state {
> >       QEDN_STATE_MODULE_REMOVE_ONGOING,
> >  };
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
> >  /* Per CPU core params */
> >  struct qedn_fp_queue {
> >       struct qed_chain cq_chain;
> > @@ -93,6 +116,10 @@ struct qedn_fp_queue {
> >       struct qed_sb_info *sb_info;
> >       unsigned int cpu;
> >       struct work_struct fw_cq_fp_wq_entry;
> > +
> > +     /* IO related resources for host */
> > +     struct qedn_io_resources host_resrc;
> > +
> >       u16 sb_id;
> >       char irqname[QEDN_IRQ_NAME_LEN];
> >  };
> > @@ -116,12 +143,35 @@ struct qedn_ctx {
> >       /* Connections */
> >       DECLARE_HASHTABLE(conn_ctx_hash, 16);
> >
> > +     u32 num_tasks_per_pool;
> > +
> >       /* Fast path queues */
> >       u8 num_fw_cqs;
> >       struct qedn_fp_queue *fp_q_arr;
> >       struct nvmetcp_glbl_queue_entry *fw_cq_array_virt;
> >       dma_addr_t fw_cq_array_phy; /* Physical address of fw_cq_array_vi=
rt */
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
> >  };
> >
> >  struct qedn_endpoint {
> > @@ -220,6 +270,7 @@ struct qedn_conn_ctx {
> >       struct nvme_tcp_ofld_ctrl *ctrl;
> >       u32 conn_handle;
> >       u32 fw_cid;
> > +     u8 default_cq;
> >
> >       atomic_t est_conn_indicator;
> >       atomic_t destroy_conn_indicator;
> > @@ -237,6 +288,11 @@ struct qedn_conn_ctx {
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
> > @@ -256,6 +312,7 @@ struct qedn_conn_ctx {
> >  enum qedn_conn_resources_state {
> >       QEDN_CONN_RESRC_FW_SQ,
> >       QEDN_CONN_RESRC_ACQUIRE_CONN,
> > +     QEDN_CONN_RESRC_TASKS,
> >       QEDN_CONN_RESRC_CCCID_ITID_MAP,
> >       QEDN_CONN_RESRC_TCP_PORT,
> >       QEDN_CONN_RESRC_DB_ADD,
> > @@ -278,5 +335,13 @@ inline int qedn_validate_cccid_in_range(struct qed=
n_conn_ctx *conn_ctx, u16 ccci
> >  int qedn_queue_request(struct qedn_conn_ctx *qedn_conn, struct nvme_tc=
p_ofld_req *req);
> >  void qedn_nvme_req_fp_wq_handler(struct work_struct *work);
> >  void qedn_io_work_cq(struct qedn_ctx *qedn, struct nvmetcp_fw_cqe *cqe=
);
> > +int qedn_alloc_tasks(struct qedn_conn_ctx *conn_ctx);
> > +inline int qedn_qid(struct nvme_tcp_ofld_queue *queue);
> > +void qedn_common_clear_fw_sgl(struct storage_sgl_task_params *sgl_task=
_params);
> > +void qedn_return_active_tasks(struct qedn_conn_ctx *conn_ctx);
> > +struct qedn_task_ctx *
> > +qedn_get_free_task_from_pool(struct qedn_conn_ctx *conn_ctx, u16 cccid=
);
> > +void qedn_destroy_free_tasks(struct qedn_fp_queue *fp_q,
> > +                          struct qedn_io_resources *io_resrc);
> >
> >  #endif /* _QEDN_H_ */
> > diff --git a/drivers/nvme/hw/qedn/qedn_conn.c b/drivers/nvme/hw/qedn/qe=
dn_conn.c
> > index 049db20b69e8..7e38edccbb56 100644
> > --- a/drivers/nvme/hw/qedn/qedn_conn.c
> > +++ b/drivers/nvme/hw/qedn/qedn_conn.c
> > @@ -29,6 +29,11 @@ static const char * const qedn_conn_state_str[] =3D =
{
> >       NULL
> >  };
> >
> > +inline int qedn_qid(struct nvme_tcp_ofld_queue *queue)
> > +{
> > +     return queue - queue->ctrl->queues;
> > +}
> > +
> >  int qedn_set_con_state(struct qedn_conn_ctx *conn_ctx, enum qedn_conn_=
state new_state)
> >  {
> >       spin_lock_bh(&conn_ctx->conn_state_lock);
> > @@ -159,6 +164,11 @@ static void qedn_release_conn_ctx(struct qedn_conn=
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
> > @@ -261,6 +271,7 @@ static int qedn_nvmetcp_offload_conn(struct qedn_co=
nn_ctx *conn_ctx)
> >       offld_prms.max_rt_time =3D QEDN_TCP_MAX_RT_TIME;
> >       offld_prms.sq_pbl_addr =3D
> >               (u64)qed_chain_get_pbl_phys(&qedn_ep->fw_sq_chain);
> > +     offld_prms.default_cq =3D conn_ctx->default_cq;
> >
> >       rc =3D qed_ops->offload_conn(qedn->cdev,
> >                                  conn_ctx->conn_handle,
> > @@ -398,6 +409,9 @@ void qedn_prep_db_data(struct qedn_conn_ctx *conn_c=
tx)
> >  static int qedn_prep_and_offload_queue(struct qedn_conn_ctx *conn_ctx)
> >  {
> >       struct qedn_ctx *qedn =3D conn_ctx->qedn;
> > +     struct qedn_io_resources *io_resrc;
> > +     struct qedn_fp_queue *fp_q;
> > +     u8 default_cq_idx, qid;
> >       size_t dma_size;
> >       int rc;
> >
> > @@ -409,6 +423,9 @@ static int qedn_prep_and_offload_queue(struct qedn_=
conn_ctx *conn_ctx)
> >
> >       set_bit(QEDN_CONN_RESRC_FW_SQ, &conn_ctx->resrc_state);
> >
> > +     atomic_set(&conn_ctx->num_active_tasks, 0);
> > +     atomic_set(&conn_ctx->num_active_fw_tasks, 0);
> > +
> >       rc =3D qed_ops->acquire_conn(qedn->cdev,
> >                                  &conn_ctx->conn_handle,
> >                                  &conn_ctx->fw_cid,
> > @@ -422,7 +439,32 @@ static int qedn_prep_and_offload_queue(struct qedn=
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
> >
> >       rc =3D qedn_fetch_tcp_port(conn_ctx);
> >       if (rc)
> > diff --git a/drivers/nvme/hw/qedn/qedn_main.c b/drivers/nvme/hw/qedn/qe=
dn_main.c
> > index db8c27dd8876..444db6d58a0a 100644
> > --- a/drivers/nvme/hw/qedn/qedn_main.c
> > +++ b/drivers/nvme/hw/qedn/qedn_main.c
> > @@ -29,6 +29,12 @@ __be16 qedn_get_in_port(struct sockaddr_storage *sa)
> >               : ((struct sockaddr_in6 *)sa)->sin6_port;
> >  }
> >
> > +static void qedn_init_io_resc(struct qedn_io_resources *io_resrc)
> > +{
> > +     spin_lock_init(&io_resrc->resources_lock);
> > +     INIT_LIST_HEAD(&io_resrc->task_free_list);
> > +}
> > +
> >  struct qedn_llh_filter *qedn_add_llh_filter(struct qedn_ctx *qedn, u16=
 tcp_port)
> >  {
> >       struct qedn_llh_filter *llh_filter =3D NULL;
> > @@ -437,6 +443,8 @@ static struct nvme_tcp_ofld_ops qedn_ofld_ops =3D {
> >                *      NVMF_OPT_HDR_DIGEST | NVMF_OPT_DATA_DIGEST |
> >                *      NVMF_OPT_NR_POLL_QUEUES | NVMF_OPT_TOS
> >                */
> > +     .max_hw_sectors =3D QEDN_MAX_HW_SECTORS,
> > +     .max_segments =3D QEDN_MAX_SEGMENTS,
> >       .claim_dev =3D qedn_claim_dev,
> >       .setup_ctrl =3D qedn_setup_ctrl,
> >       .release_ctrl =3D qedn_release_ctrl,
> > @@ -642,8 +650,24 @@ static inline int qedn_core_probe(struct qedn_ctx =
*qedn)
> >       return rc;
> >  }
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
> >  static void qedn_free_function_queues(struct qedn_ctx *qedn)
> >  {
> > +     struct qedn_io_resources *host_resrc;
> >       struct qed_sb_info *sb_info =3D NULL;
> >       struct qedn_fp_queue *fp_q;
> >       int i;
> > @@ -655,6 +679,9 @@ static void qedn_free_function_queues(struct qedn_c=
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
> > @@ -742,7 +769,8 @@ static int qedn_alloc_function_queues(struct qedn_c=
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
> > @@ -784,7 +812,7 @@ static int qedn_alloc_function_queues(struct qedn_c=
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
> > @@ -966,7 +994,7 @@ static int __qedn_probe(struct pci_dev *pdev)
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
> > index ea6745b94817..35cb5e8e4e61 100644
> > --- a/drivers/nvme/hw/qedn/qedn_task.c
> > +++ b/drivers/nvme/hw/qedn/qedn_task.c
> > @@ -11,6 +11,198 @@
> >  /* Driver includes */
> >  #include "qedn.h"
> >
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
>
> Well ... this is less than optimal.
> In effect you are splitting the available hardware tasks between pools.
> And the way I see it you allocate one pool per connection.
> Is that correct?

No, we have a pool per CPU core (per fp_q) and not per connection.
All the connections assigned to this core will use the same pool.

>
> So what about the scaling here?
> How many hardware tasks do you have in total?

We can scale up to 64K pending tasks.

> And what happens if you add more and more connections?

In this series, if we don=E2=80=99t have a task resource in the per core po=
ol we will
fail the IO. With the next version (not included in this series) we will qu=
eue
the IO until we will have a free task resource.

>
> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke                     Kernel Storage Architect
> hare@suse.de                                   +49 911 74053 688
> SUSE Software Solutions Germany GmbH, 90409 N=C3=BCrnberg
> GF: F. Imend=C3=B6rffer, HRB 36809 (AG N=C3=BCrnberg)
