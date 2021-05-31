Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C2B4396396
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 17:20:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233510AbhEaPVl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 11:21:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234458AbhEaPTm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 11:19:42 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E5E8C03543B
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 07:12:55 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id k7so7348222ejv.12
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 07:12:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=wdVF4u0KnL5JDcMbyHjMtwgTNkf83YL8Bmymhm7oRFk=;
        b=eyl7XE7g8X8cgTADOHGYWqKkLdVeWnUyTjB5cyUkeHdCri5x7FI6E2seAAtD4kV/b1
         LN778pDf9b2iQb4QxacKvygBi993mZCxNFxHKRNV77bU1q4G3/pxbGNc2iaV5lrUNJQ3
         GFOVM1zR7s5jeVLUNvfz9B1fi4NN+c3TsjOmgPs2qYzdGhfxHGaxLuYWevTfvWkBLzps
         NmDWxPITqz8rFudAaJaDcZajPgfaNsGYU22k40zF0NYlBbSp2QGcKqV5yYA2WsdLGNMr
         YqBi291+gFlHaIepxojbeolR1J10/QO1kisLRAgOjKWNy7u8833yMWmfiCd9Az4HELK3
         HD1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=wdVF4u0KnL5JDcMbyHjMtwgTNkf83YL8Bmymhm7oRFk=;
        b=jqrFyvW0wPTHG2+PUTOPDZ+pC7TgVP9sfgCBtW077S4t8gBR79ugnNU/Rxvg64Oes/
         tvcEtPmWdNwwweCcBGaHAmDj+nltpjrpGY88VK7eEw6TaDi6nfGq+xCR5K5sAjMZCZdG
         To2EbTVRcQIRI7eiXe+U7p6D+/85BWahkkIHgYnbJ43Vtls9GzEegz1HJmxgZX9k2QUB
         ApBFWW/ZANB6kThvlddL2Zyw0uPDeW7C8KoJMjU/8DfA9aEGc1PqoTeZPPt8OMt0yFbH
         p7SaQ51J6hq+yqnsevC67ly0hFz8GuCMClAzv31gMfNEiKf19vMTIdhkGnn6JWw4wOQZ
         qEpA==
X-Gm-Message-State: AOAM531MoTogYjv1qPRJU/2aNc/GP5OxfNAv6nT7vTHwmNFaSz+rKi6I
        WwvLMyXHxl3arl++8EvK/RHpGvyvH6sbzKiA+9s=
X-Google-Smtp-Source: ABdhPJyWZzQAF7HbGGn1xvfUWxsbttQPY6PhO++caSN2mdJ1nppVwX18tO0JxbZlUa3EKyMLH1HPv6DXWBmds4P8QPw=
X-Received: by 2002:a17:907:2059:: with SMTP id pg25mr7844796ejb.130.1622470373628;
 Mon, 31 May 2021 07:12:53 -0700 (PDT)
MIME-Version: 1.0
References: <20210527235902.2185-1-smalin@marvell.com> <20210527235902.2185-23-smalin@marvell.com>
 <189ee11c-96fb-0fe0-9c55-e722af611f27@suse.de>
In-Reply-To: <189ee11c-96fb-0fe0-9c55-e722af611f27@suse.de>
From:   Shai Malin <malin1024@gmail.com>
Date:   Mon, 31 May 2021 17:12:40 +0300
Message-ID: <CAKKgK4x0oJJqwB3Q1Voy_SMBtJPHT+OVV6bF5PSBCiRDCAoomQ@mail.gmail.com>
Subject: Re: [RFC PATCH v6 22/27] qedn: Add IO level qedn_send_req and fw_cq workqueue
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

On 5/28/21 3:57 PM, Hannes Reinecke wrote:
> On 5/28/21 1:58 AM, Shai Malin wrote:
> > This patch will present the IO level skeleton flows:
> >
> > - qedn_send_req(): process new requests, similar to nvme_tcp_queue_rq()=
.
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
> >  drivers/nvme/hw/qedn/Makefile    |   2 +-
> >  drivers/nvme/hw/qedn/qedn.h      |  15 +++++
> >  drivers/nvme/hw/qedn/qedn_conn.c |   2 +
> >  drivers/nvme/hw/qedn/qedn_main.c | 107 +++++++++++++++++++++++++++++--
> >  drivers/nvme/hw/qedn/qedn_task.c |  90 ++++++++++++++++++++++++++
> >  5 files changed, 208 insertions(+), 8 deletions(-)
> >  create mode 100644 drivers/nvme/hw/qedn/qedn_task.c
> >
> > diff --git a/drivers/nvme/hw/qedn/Makefile b/drivers/nvme/hw/qedn/Makef=
ile
> > index ece84772d317..888d466fa5ed 100644
> > --- a/drivers/nvme/hw/qedn/Makefile
> > +++ b/drivers/nvme/hw/qedn/Makefile
> > @@ -1,4 +1,4 @@
> >  # SPDX-License-Identifier: GPL-2.0
> >
> >  obj-$(CONFIG_NVME_QEDN) +=3D qedn.o
> > -qedn-y :=3D qedn_main.o qedn_conn.o
> > +qedn-y :=3D qedn_main.o qedn_conn.o qedn_task.o
> > \ No newline at end of file
> > diff --git a/drivers/nvme/hw/qedn/qedn.h b/drivers/nvme/hw/qedn/qedn.h
> > index 6908409eb5b5..d56184f58840 100644
> > --- a/drivers/nvme/hw/qedn/qedn.h
> > +++ b/drivers/nvme/hw/qedn/qedn.h
> > @@ -38,6 +38,8 @@
> >  #define QEDN_NON_ABORTIVE_TERMINATION 0
> >  #define QEDN_ABORTIVE_TERMINATION 1
> >
> > +#define QEDN_FW_CQ_FP_WQ_WORKQUEUE "qedn_fw_cq_fp_wq"
> > +
> >  /*
> >   * TCP offload stack default configurations and defines.
> >   * Future enhancements will allow controlling the configurable
> > @@ -90,6 +92,7 @@ struct qedn_fp_queue {
> >       struct qedn_ctx *qedn;
> >       struct qed_sb_info *sb_info;
> >       unsigned int cpu;
> > +     struct work_struct fw_cq_fp_wq_entry;
> >       u16 sb_id;
> >       char irqname[QEDN_IRQ_NAME_LEN];
> >  };
> > @@ -118,6 +121,7 @@ struct qedn_ctx {
> >       struct qedn_fp_queue *fp_q_arr;
> >       struct nvmetcp_glbl_queue_entry *fw_cq_array_virt;
> >       dma_addr_t fw_cq_array_phy; /* Physical address of fw_cq_array_vi=
rt */
> > +     struct workqueue_struct *fw_cq_fp_wq;
> >  };
> >
> >  struct qedn_endpoint {
> > @@ -204,6 +208,13 @@ struct qedn_ctrl {
> >
> >  /* Connection level struct */
> >  struct qedn_conn_ctx {
> > +     /* IO path */
> > +     struct qedn_fp_queue *fp_q;
> > +     /* mutex for queueing request */
> > +     struct mutex send_mutex;
> > +     unsigned int cpu;
> > +     int qid;
> > +
> >       struct qedn_ctx *qedn;
> >       struct nvme_tcp_ofld_queue *queue;
> >       struct nvme_tcp_ofld_ctrl *ctrl;
> > @@ -263,5 +274,9 @@ int qedn_set_con_state(struct qedn_conn_ctx *conn_c=
tx, enum qedn_conn_state new_
> >  void qedn_terminate_connection(struct qedn_conn_ctx *conn_ctx);
> >  void qedn_cleanp_fw(struct qedn_conn_ctx *conn_ctx);
> >  __be16 qedn_get_in_port(struct sockaddr_storage *sa);
> > +inline int qedn_validate_cccid_in_range(struct qedn_conn_ctx *conn_ctx=
, u16 cccid);
> > +int qedn_queue_request(struct qedn_conn_ctx *qedn_conn, struct nvme_tc=
p_ofld_req *req);
> > +void qedn_nvme_req_fp_wq_handler(struct work_struct *work);
> > +void qedn_io_work_cq(struct qedn_ctx *qedn, struct nvmetcp_fw_cqe *cqe=
);
> >
> >  #endif /* _QEDN_H_ */
> > diff --git a/drivers/nvme/hw/qedn/qedn_conn.c b/drivers/nvme/hw/qedn/qe=
dn_conn.c
> > index 150ee53b6095..049db20b69e8 100644
> > --- a/drivers/nvme/hw/qedn/qedn_conn.c
> > +++ b/drivers/nvme/hw/qedn/qedn_conn.c
> > @@ -179,6 +179,7 @@ static void qedn_release_conn_ctx(struct qedn_conn_=
ctx *conn_ctx)
> >               pr_err("Conn resources state isn't 0 as expected 0x%lx\n"=
,
> >                      conn_ctx->resrc_state);
> >
> > +     mutex_destroy(&conn_ctx->send_mutex);
> >       atomic_inc(&conn_ctx->destroy_conn_indicator);
> >       qedn_set_con_state(conn_ctx, CONN_STATE_DESTROY_COMPLETE);
> >       wake_up_interruptible(&conn_ctx->conn_waitq);
> > @@ -407,6 +408,7 @@ static int qedn_prep_and_offload_queue(struct qedn_=
conn_ctx *conn_ctx)
> >       }
> >
> >       set_bit(QEDN_CONN_RESRC_FW_SQ, &conn_ctx->resrc_state);
> > +
> >       rc =3D qed_ops->acquire_conn(qedn->cdev,
> >                                  &conn_ctx->conn_handle,
> >                                  &conn_ctx->fw_cid,
> > diff --git a/drivers/nvme/hw/qedn/qedn_main.c b/drivers/nvme/hw/qedn/qe=
dn_main.c
> > index a2d0ae0c2c65..db8c27dd8876 100644
> > --- a/drivers/nvme/hw/qedn/qedn_main.c
> > +++ b/drivers/nvme/hw/qedn/qedn_main.c
> > @@ -261,6 +261,18 @@ static int qedn_release_ctrl(struct nvme_tcp_ofld_=
ctrl *ctrl)
> >       return 0;
> >  }
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
>
> why do you need this?
> Isn't the 'qid' here the block-layer hardware queue index?

You are right!
The "% qedn->num_fw_cqs" is not needed. The cpu which will be used is
according to:
             conn_ctx->cpu =3D qid ? (qid - 1) : 0)

We will remove the qedn_set_ctrl_io_cpus() and we will fix it as part of
qedn_prep_and_offload_queue().

> And if so, shouldn't you let interrupt affinity decide on which cpu the
> completion will be handled?

At any rate, the interrupt affinity will only determine the CPU which will
handle the irq, but the completion handling is done from workqueue which
will be scheduled on the cpu which was determined based on the qid.

We will also remove "fp_q->cpu =3D smp_processor_id();" from the
qedn_irq_handler() in order to achieve it.

>
> >  static int qedn_create_queue(struct nvme_tcp_ofld_queue *queue, int qi=
d,
> >                            size_t queue_size)
> >  {
> > @@ -288,6 +300,8 @@ static int qedn_create_queue(struct nvme_tcp_ofld_q=
ueue *queue, int qid,
> >       conn_ctx->queue =3D queue;
> >       conn_ctx->ctrl =3D ctrl;
> >       conn_ctx->sq_depth =3D queue_size;
> > +     mutex_init(&conn_ctx->send_mutex);
> > +     qedn_set_ctrl_io_cpus(conn_ctx, qid);
> >
> >       init_waitqueue_head(&conn_ctx->conn_waitq);
> >       atomic_set(&conn_ctx->est_conn_indicator, 0);
> > @@ -295,6 +309,8 @@ static int qedn_create_queue(struct nvme_tcp_ofld_q=
ueue *queue, int qid,
> >
> >       spin_lock_init(&conn_ctx->conn_state_lock);
> >
> > +     conn_ctx->qid =3D qid;
> > +
> >       qedn_initialize_endpoint(&conn_ctx->ep, qedn->local_mac_addr, ctr=
l);
> >
> >       atomic_inc(&qctrl->host_num_active_conns);
> > @@ -384,11 +400,30 @@ static int qedn_poll_queue(struct nvme_tcp_ofld_q=
ueue *queue)
> >       return 0;
> >  }
> >
> > +int qedn_process_request(struct qedn_conn_ctx *qedn_conn,
> > +                      struct nvme_tcp_ofld_req *req)
> > +{
> > +     int rc =3D 0;
> > +
> > +     mutex_lock(&qedn_conn->send_mutex);
> > +     rc =3D qedn_queue_request(qedn_conn, req);
> > +     mutex_unlock(&qedn_conn->send_mutex);
> > +
> > +     return rc;
> > +}
> > +
> >  static int qedn_send_req(struct nvme_tcp_ofld_req *req)
> >  {
> > -     /* Placeholder - qedn_send_req */
> > +     struct qedn_conn_ctx *qedn_conn =3D (struct qedn_conn_ctx *)req->=
queue->private_data;
> > +     struct request *rq;
> >
> > -     return 0;
> > +     rq =3D blk_mq_rq_from_pdu(req);
> > +
> > +     /* Under the assumption that the cccid/tag will be in the range o=
f 0 to sq_depth-1. */
> > +     if (!req->async && qedn_validate_cccid_in_range(qedn_conn, rq->ta=
g))
> > +             return BLK_STS_NOTSUPP;
> > +
> > +     return qedn_process_request(qedn_conn, req);
> >  }
> >
>
> Why? The tag number will never exceed the queue depth ...

It was added in order to protect the HW from invalid values.
We will remove it.

>
> >  static struct nvme_tcp_ofld_ops qedn_ofld_ops =3D {
> > @@ -428,9 +463,59 @@ struct qedn_conn_ctx *qedn_get_conn_hash(struct qe=
dn_ctx *qedn, u16 icid)
> >  }
> >
> >  /* Fastpath IRQ handler */
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
> >  static irqreturn_t qedn_irq_handler(int irq, void *dev_id)
> >  {
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
> >  }
> > @@ -564,6 +649,8 @@ static void qedn_free_function_queues(struct qedn_c=
tx *qedn)
> >       int i;
> >
> >       /* Free workqueues */
> > +     destroy_workqueue(qedn->fw_cq_fp_wq);
> > +     qedn->fw_cq_fp_wq =3D NULL;
> >
> >       /* Free the fast path queues*/
> >       for (i =3D 0; i < qedn->num_fw_cqs; i++) {
> > @@ -631,7 +718,14 @@ static int qedn_alloc_function_queues(struct qedn_=
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
> >
> >       qedn->fp_q_arr =3D kcalloc(qedn->num_fw_cqs,
> >                                sizeof(struct qedn_fp_queue), GFP_KERNEL=
);
> > @@ -659,7 +753,7 @@ static int qedn_alloc_function_queues(struct qedn_c=
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
> > @@ -688,8 +782,7 @@ static int qedn_alloc_function_queues(struct qedn_c=
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
> > index 000000000000..ea6745b94817
> > --- /dev/null
> > +++ b/drivers/nvme/hw/qedn/qedn_task.c
> > @@ -0,0 +1,90 @@
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
> > +int qedn_queue_request(struct qedn_conn_ctx *qedn_conn, struct nvme_tc=
p_ofld_req *req)
> > +{
> > +     /* Process the request */
> > +
> > +     return 0;
> > +}
> > +
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
> Dr. Hannes Reinecke                     Kernel Storage Architect
> hare@suse.de                                   +49 911 74053 688
> SUSE Software Solutions Germany GmbH, 90409 N=C3=BCrnberg
> GF: F. Imend=C3=B6rffer, HRB 36809 (AG N=C3=BCrnberg)
