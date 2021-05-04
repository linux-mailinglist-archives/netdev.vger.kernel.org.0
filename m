Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 072CA372E0F
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 18:28:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231734AbhEDQ3m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 12:29:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231781AbhEDQ3j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 12:29:39 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6914DC061574
        for <netdev@vger.kernel.org>; Tue,  4 May 2021 09:28:44 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id l4so14104775ejc.10
        for <netdev@vger.kernel.org>; Tue, 04 May 2021 09:28:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Z/XXSFGnjR3kTMpJJL6/uEtZkYFyQ/w68fOcgUqaYlI=;
        b=fSG+EnJ4/Jz4+DPhjR6ISzcENbWM+pbYGKUks+Ht4ZvggWaqPazOFyOeJ7C5d5rGDq
         4d67Wzzyh4TdCjODf3CkgRff5Dw8ILTb8Mkull623Yim9x1h5hOTTDaIpIWYZ5xEpC1K
         HbNnO5ofZre31jvUACfZebE4Z43EGJMQAtQEQV/L9UBYT+uZ6B3vFo3BD1HLe5n2aDUM
         ohe06UzqqXPETBm4M7GKVjQQNndpzsOSzhuOGgctsgk8b2WSHDOJIdK5jV2WaSh2zMqh
         5pmBD03c5KBZ+D2U9BC0bDjP8pGc7alEQ4puJflgtRtebAJMokKvB6WOuRweAKt0c4Vm
         KbYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Z/XXSFGnjR3kTMpJJL6/uEtZkYFyQ/w68fOcgUqaYlI=;
        b=qrMaJVApjIvWwGm0QXabjQzs6nLeLkiLZn+QGnQrmLcmqyOvG2AFr+M18HeYBa49Ux
         NicI0NBVhq0uwGlaG9ayg/qjrZ26ZJCbCyNbZWELfsAMrXWWTPQv8w5WYMTM0ZSiuasH
         yYxsynzibvfSByliMUEG4EdXuE7bN5Y84iSX56P4RNmLUghQCWW10//diQNa7jNf+ogU
         geNChhlsVf0jhnp62gGANrdj/8/MhQSH+jAUOHhyEa47Bphemukl2freRYDXVhPDP8YL
         JAABlwF6V0lewh8VzYwSDYUUrCcO6GiKIF7y5dRf/QNNBbndiclJ5R/+ZAmdDOrRTyMO
         1KJQ==
X-Gm-Message-State: AOAM530GAkDV8oaCQf03BRTdiPwYf12VKZaSmfdpjougnTGlQUGSOgQU
        REmLEpGXx6G5A0ZA/s7jg8HhqnLgIlhygewRW0k=
X-Google-Smtp-Source: ABdhPJw+Vlo2wIuop4v3nZVy7vgehSUoi7d132w3jP1ADPLQ0eTE4PsDNriD8KCc8jHFcIlCRwp2/LnimF9wrQAQlLs=
X-Received: by 2002:a17:906:90b:: with SMTP id i11mr22848207ejd.168.1620145723009;
 Tue, 04 May 2021 09:28:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210429190926.5086-1-smalin@marvell.com> <20210429190926.5086-7-smalin@marvell.com>
 <88d052a4-4a91-b5e7-5d53-1fb2a1507909@suse.de>
In-Reply-To: <88d052a4-4a91-b5e7-5d53-1fb2a1507909@suse.de>
From:   Shai Malin <malin1024@gmail.com>
Date:   Tue, 4 May 2021 19:28:30 +0300
Message-ID: <CAKKgK4xLaCfpkHCLPaC4rekGO01K0iO=idbRh+bEU7UcwHc+kQ@mail.gmail.com>
Subject: Re: [RFC PATCH v4 06/27] qed: Add NVMeTCP Offload IO Level FW Initializations
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

On 5/2/21 2:25 PM, Hannes Reinecke wrote:
> On 4/29/21 9:09 PM, Shai Malin wrote:
> > This patch introduces the NVMeTCP FW initializations which is used
> > to initialize the IO level configuration into a per IO HW
> > resource ("task") as part of the IO path flow.
> >
> > This includes:
> > - Write IO FW initialization
> > - Read IO FW initialization.
> > - IC-Req and IC-Resp FW exchange.
> > - FW Cleanup flow (Flush IO).
> >
> > Acked-by: Igor Russkikh <irusskikh@marvell.com>
> > Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> > Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
> > Signed-off-by: Shai Malin <smalin@marvell.com>
> > Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
> > Signed-off-by: Ariel Elior <aelior@marvell.com>
> > ---
> >   drivers/net/ethernet/qlogic/qed/Makefile      |   5 +-
> >   drivers/net/ethernet/qlogic/qed/qed_nvmetcp.c |   7 +-
> >   .../qlogic/qed/qed_nvmetcp_fw_funcs.c         | 372 +++++++++++++++++=
+
> >   .../qlogic/qed/qed_nvmetcp_fw_funcs.h         |  43 ++
> >   include/linux/qed/nvmetcp_common.h            |   3 +
> >   include/linux/qed/qed_nvmetcp_if.h            |  17 +
> >   6 files changed, 445 insertions(+), 2 deletions(-)
> >   create mode 100644 drivers/net/ethernet/qlogic/qed/qed_nvmetcp_fw_fun=
cs.c
> >   create mode 100644 drivers/net/ethernet/qlogic/qed/qed_nvmetcp_fw_fun=
cs.h
> >
> > diff --git a/drivers/net/ethernet/qlogic/qed/Makefile b/drivers/net/eth=
ernet/qlogic/qed/Makefile
> > index 7cb0db67ba5b..0d9c2fe0245d 100644
> > --- a/drivers/net/ethernet/qlogic/qed/Makefile
> > +++ b/drivers/net/ethernet/qlogic/qed/Makefile
> > @@ -28,7 +28,10 @@ qed-$(CONFIG_QED_ISCSI) +=3D qed_iscsi.o
> >   qed-$(CONFIG_QED_LL2) +=3D qed_ll2.o
> >   qed-$(CONFIG_QED_OOO) +=3D qed_ooo.o
> >
> > -qed-$(CONFIG_QED_NVMETCP) +=3D qed_nvmetcp.o
> > +qed-$(CONFIG_QED_NVMETCP) +=3D \
> > +     qed_nvmetcp.o           \
> > +     qed_nvmetcp_fw_funcs.o  \
> > +     qed_nvmetcp_ip_services.o
> >
> >   qed-$(CONFIG_QED_RDMA) +=3D   \
> >       qed_iwarp.o             \
> > diff --git a/drivers/net/ethernet/qlogic/qed/qed_nvmetcp.c b/drivers/ne=
t/ethernet/qlogic/qed/qed_nvmetcp.c
> > index 1e2eb6dcbd6e..434363f8b5c0 100644
> > --- a/drivers/net/ethernet/qlogic/qed/qed_nvmetcp.c
> > +++ b/drivers/net/ethernet/qlogic/qed/qed_nvmetcp.c
> > @@ -27,6 +27,7 @@
> >   #include "qed_mcp.h"
> >   #include "qed_sp.h"
> >   #include "qed_reg_addr.h"
> > +#include "qed_nvmetcp_fw_funcs.h"
> >
> >   static int qed_nvmetcp_async_event(struct qed_hwfn *p_hwfn, u8 fw_eve=
nt_code,
> >                                  u16 echo, union event_ring_data *data,
> > @@ -848,7 +849,11 @@ static const struct qed_nvmetcp_ops qed_nvmetcp_op=
s_pass =3D {
> >       .remove_src_tcp_port_filter =3D &qed_llh_remove_src_tcp_port_filt=
er,
> >       .add_dst_tcp_port_filter =3D &qed_llh_add_dst_tcp_port_filter,
> >       .remove_dst_tcp_port_filter =3D &qed_llh_remove_dst_tcp_port_filt=
er,
> > -     .clear_all_filters =3D &qed_llh_clear_all_filters
> > +     .clear_all_filters =3D &qed_llh_clear_all_filters,
> > +     .init_read_io =3D &init_nvmetcp_host_read_task,
> > +     .init_write_io =3D &init_nvmetcp_host_write_task,
> > +     .init_icreq_exchange =3D &init_nvmetcp_init_conn_req_task,
> > +     .init_task_cleanup =3D &init_cleanup_task_nvmetcp
> >   };
> >
> >   const struct qed_nvmetcp_ops *qed_get_nvmetcp_ops(void)
> > diff --git a/drivers/net/ethernet/qlogic/qed/qed_nvmetcp_fw_funcs.c b/d=
rivers/net/ethernet/qlogic/qed/qed_nvmetcp_fw_funcs.c
> > new file mode 100644
> > index 000000000000..8485ad678284
> > --- /dev/null
> > +++ b/drivers/net/ethernet/qlogic/qed/qed_nvmetcp_fw_funcs.c
> > @@ -0,0 +1,372 @@
> > +// SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause)
> > +/* Copyright 2021 Marvell. All rights reserved. */
> > +
> > +#include <linux/kernel.h>
> > +#include <linux/module.h>
> > +#include <linux/pci.h>
> > +#include <linux/kernel.h>
> > +#include <linux/list.h>
> > +#include <linux/mm.h>
> > +#include <linux/types.h>
> > +#include <asm/byteorder.h>
> > +#include <linux/qed/common_hsi.h>
> > +#include <linux/qed/storage_common.h>
> > +#include <linux/qed/nvmetcp_common.h>
> > +#include <linux/qed/qed_nvmetcp_if.h>
> > +#include "qed_nvmetcp_fw_funcs.h"
> > +
> > +#define NVMETCP_NUM_SGES_IN_CACHE 0x4
> > +
> > +bool nvmetcp_is_slow_sgl(u16 num_sges, bool small_mid_sge)
> > +{
> > +     return (num_sges > SCSI_NUM_SGES_SLOW_SGL_THR && small_mid_sge);
> > +}
> > +
> > +void init_scsi_sgl_context(struct scsi_sgl_params *ctx_sgl_params,
> > +                        struct scsi_cached_sges *ctx_data_desc,
> > +                        struct storage_sgl_task_params *sgl_params)
> > +{
> > +     u8 num_sges_to_init =3D (u8)(sgl_params->num_sges > NVMETCP_NUM_S=
GES_IN_CACHE ?
> > +                                NVMETCP_NUM_SGES_IN_CACHE : sgl_params=
->num_sges);
> > +     u8 sge_index;
> > +
> > +     /* sgl params */
> > +     ctx_sgl_params->sgl_addr.lo =3D cpu_to_le32(sgl_params->sgl_phys_=
addr.lo);
> > +     ctx_sgl_params->sgl_addr.hi =3D cpu_to_le32(sgl_params->sgl_phys_=
addr.hi);
> > +     ctx_sgl_params->sgl_total_length =3D cpu_to_le32(sgl_params->tota=
l_buffer_size);
> > +     ctx_sgl_params->sgl_num_sges =3D cpu_to_le16(sgl_params->num_sges=
);
> > +
> > +     for (sge_index =3D 0; sge_index < num_sges_to_init; sge_index++) =
{
> > +             ctx_data_desc->sge[sge_index].sge_addr.lo =3D
> > +                     cpu_to_le32(sgl_params->sgl[sge_index].sge_addr.l=
o);
> > +             ctx_data_desc->sge[sge_index].sge_addr.hi =3D
> > +                     cpu_to_le32(sgl_params->sgl[sge_index].sge_addr.h=
i);
> > +             ctx_data_desc->sge[sge_index].sge_len =3D
> > +                     cpu_to_le32(sgl_params->sgl[sge_index].sge_len);
> > +     }
> > +}
> > +
> > +static inline u32 calc_rw_task_size(struct nvmetcp_task_params *task_p=
arams,
> > +                                 enum nvmetcp_task_type task_type)
> > +{
> > +     u32 io_size;
> > +
> > +     if (task_type =3D=3D NVMETCP_TASK_TYPE_HOST_WRITE)
> > +             io_size =3D task_params->tx_io_size;
> > +     else
> > +             io_size =3D task_params->rx_io_size;
> > +
> > +     if (unlikely(!io_size))
> > +             return 0;
> > +
> > +     return io_size;
> > +}
> > +
> > +static inline void init_sqe(struct nvmetcp_task_params *task_params,
> > +                         struct storage_sgl_task_params *sgl_task_para=
ms,
> > +                         enum nvmetcp_task_type task_type)
> > +{
> > +     if (!task_params->sqe)
> > +             return;
> > +
> > +     memset(task_params->sqe, 0, sizeof(*task_params->sqe));
> > +     task_params->sqe->task_id =3D cpu_to_le16(task_params->itid);
> > +
> > +     switch (task_type) {
> > +     case NVMETCP_TASK_TYPE_HOST_WRITE: {
> > +             u32 buf_size =3D 0;
> > +             u32 num_sges =3D 0;
> > +
> > +             SET_FIELD(task_params->sqe->contlen_cdbsize,
> > +                       NVMETCP_WQE_CDB_SIZE_OR_NVMETCP_CMD, 1);
> > +             SET_FIELD(task_params->sqe->flags, NVMETCP_WQE_WQE_TYPE,
> > +                       NVMETCP_WQE_TYPE_NORMAL);
> > +             if (task_params->tx_io_size) {
> > +                     if (task_params->send_write_incapsule)
> > +                             buf_size =3D calc_rw_task_size(task_param=
s, task_type);
> > +
> > +                     if (nvmetcp_is_slow_sgl(sgl_task_params->num_sges=
,
> > +                                             sgl_task_params->small_mi=
d_sge))
> > +                             num_sges =3D NVMETCP_WQE_NUM_SGES_SLOWIO;
> > +                     else
> > +                             num_sges =3D min((u16)sgl_task_params->nu=
m_sges,
> > +                                            (u16)SCSI_NUM_SGES_SLOW_SG=
L_THR);
> > +             }
> > +             SET_FIELD(task_params->sqe->flags, NVMETCP_WQE_NUM_SGES, =
num_sges);
> > +             SET_FIELD(task_params->sqe->contlen_cdbsize, NVMETCP_WQE_=
CONT_LEN, buf_size);
> > +     } break;
> > +
> > +     case NVMETCP_TASK_TYPE_HOST_READ: {
> > +             SET_FIELD(task_params->sqe->flags, NVMETCP_WQE_WQE_TYPE,
> > +                       NVMETCP_WQE_TYPE_NORMAL);
> > +             SET_FIELD(task_params->sqe->contlen_cdbsize,
> > +                       NVMETCP_WQE_CDB_SIZE_OR_NVMETCP_CMD, 1);
> > +     } break;
> > +
> > +     case NVMETCP_TASK_TYPE_INIT_CONN_REQUEST: {
> > +             SET_FIELD(task_params->sqe->flags, NVMETCP_WQE_WQE_TYPE,
> > +                       NVMETCP_WQE_TYPE_MIDDLE_PATH);
> > +
> > +             if (task_params->tx_io_size) {
> > +                     SET_FIELD(task_params->sqe->contlen_cdbsize, NVME=
TCP_WQE_CONT_LEN,
> > +                               task_params->tx_io_size);
> > +                     SET_FIELD(task_params->sqe->flags, NVMETCP_WQE_NU=
M_SGES,
> > +                               min((u16)sgl_task_params->num_sges,
> > +                                   (u16)SCSI_NUM_SGES_SLOW_SGL_THR));
> > +             }
> > +     } break;
> > +
> > +     case NVMETCP_TASK_TYPE_CLEANUP:
> > +             SET_FIELD(task_params->sqe->flags, NVMETCP_WQE_WQE_TYPE,
> > +                       NVMETCP_WQE_TYPE_TASK_CLEANUP);
> > +
> > +     default:
> > +             break;
> > +     }
> > +}
> > +
> > +/* The following function initializes of NVMeTCP task params */
> > +static inline void
> > +init_nvmetcp_task_params(struct e5_nvmetcp_task_context *context,
> > +                      struct nvmetcp_task_params *task_params,
> > +                      enum nvmetcp_task_type task_type)
> > +{
> > +     context->ystorm_st_context.state.cccid =3D task_params->host_ccci=
d;
> > +     SET_FIELD(context->ustorm_st_context.error_flags, USTORM_NVMETCP_=
TASK_ST_CTX_NVME_TCP, 1);
> > +     context->ustorm_st_context.nvme_tcp_opaque_lo =3D cpu_to_le32(tas=
k_params->opq.lo);
> > +     context->ustorm_st_context.nvme_tcp_opaque_hi =3D cpu_to_le32(tas=
k_params->opq.hi);
> > +}
> > +
> > +/* The following function initializes default values to all tasks */
> > +static inline void
> > +init_default_nvmetcp_task(struct nvmetcp_task_params *task_params, voi=
d *pdu_header,
> > +                       enum nvmetcp_task_type task_type)
> > +{
> > +     struct e5_nvmetcp_task_context *context =3D task_params->context;
> > +     const u8 val_byte =3D context->mstorm_ag_context.cdu_validation;
> > +     u8 dw_index;
> > +
> > +     memset(context, 0, sizeof(*context));
> > +
> > +     init_nvmetcp_task_params(context, task_params,
> > +                              (enum nvmetcp_task_type)task_type);
> > +
> > +     if (task_type =3D=3D NVMETCP_TASK_TYPE_HOST_WRITE ||
> > +         task_type =3D=3D NVMETCP_TASK_TYPE_HOST_READ) {
> > +             for (dw_index =3D 0; dw_index < QED_NVMETCP_CMD_HDR_SIZE =
/ 4; dw_index++)
> > +                     context->ystorm_st_context.pdu_hdr.task_hdr.reg[d=
w_index] =3D
> > +                             cpu_to_le32(((u32 *)pdu_header)[dw_index]=
);
> > +     } else {
> > +             for (dw_index =3D 0; dw_index < QED_NVMETCP_CMN_HDR_SIZE =
/ 4; dw_index++)
> > +                     context->ystorm_st_context.pdu_hdr.task_hdr.reg[d=
w_index] =3D
> > +                             cpu_to_le32(((u32 *)pdu_header)[dw_index]=
);
> > +     }
> > +
>
> And this is what I meant. You are twiddling with the bytes already, so
> why bother with a separate struct at all?

We agree, will be fixed in V5.

>
> > +     /* M-Storm Context: */
> > +     context->mstorm_ag_context.cdu_validation =3D val_byte;
> > +     context->mstorm_st_context.task_type =3D (u8)(task_type);
> > +     context->mstorm_ag_context.task_cid =3D cpu_to_le16(task_params->=
conn_icid);
> > +
> > +     /* Ustorm Context: */
> > +     SET_FIELD(context->ustorm_ag_context.flags1, E5_USTORM_NVMETCP_TA=
SK_AG_CTX_R2T2RECV, 1);
> > +     context->ustorm_st_context.task_type =3D (u8)(task_type);
> > +     context->ustorm_st_context.cq_rss_number =3D task_params->cq_rss_=
number;
> > +     context->ustorm_ag_context.icid =3D cpu_to_le16(task_params->conn=
_icid);
> > +}
> > +
> > +/* The following function initializes the U-Storm Task Contexts */
> > +static inline void
> > +init_ustorm_task_contexts(struct ustorm_nvmetcp_task_st_ctx *ustorm_st=
_context,
> > +                       struct e5_ustorm_nvmetcp_task_ag_ctx *ustorm_ag=
_context,
> > +                       u32 remaining_recv_len,
> > +                       u32 expected_data_transfer_len, u8 num_sges,
> > +                       bool tx_dif_conn_err_en)
> > +{
> > +     /* Remaining data to be received in bytes. Used in validations*/
> > +     ustorm_st_context->rem_rcv_len =3D cpu_to_le32(remaining_recv_len=
);
> > +     ustorm_ag_context->exp_data_acked =3D cpu_to_le32(expected_data_t=
ransfer_len);
> > +     ustorm_st_context->exp_data_transfer_len =3D cpu_to_le32(expected=
_data_transfer_len);
> > +     SET_FIELD(ustorm_st_context->reg1.reg1_map, NVMETCP_REG1_NUM_SGES=
, num_sges);
> > +     SET_FIELD(ustorm_ag_context->flags2, E5_USTORM_NVMETCP_TASK_AG_CT=
X_DIF_ERROR_CF_EN,
> > +               tx_dif_conn_err_en ? 1 : 0);
> > +}
> > +
> > +/* The following function initializes Local Completion Contexts: */
> > +static inline void
> > +set_local_completion_context(struct e5_nvmetcp_task_context *context)
> > +{
> > +     SET_FIELD(context->ystorm_st_context.state.flags,
> > +               YSTORM_NVMETCP_TASK_STATE_LOCAL_COMP, 1);
> > +     SET_FIELD(context->ustorm_st_context.flags,
> > +               USTORM_NVMETCP_TASK_ST_CTX_LOCAL_COMP, 1);
> > +}
> > +
> > +/* Common Fastpath task init function: */
> > +static inline void
> > +init_rw_nvmetcp_task(struct nvmetcp_task_params *task_params,
> > +                  enum nvmetcp_task_type task_type,
> > +                  struct nvmetcp_conn_params *conn_params, void *pdu_h=
eader,
> > +                  struct storage_sgl_task_params *sgl_task_params)
> > +{
> > +     struct e5_nvmetcp_task_context *context =3D task_params->context;
> > +     u32 task_size =3D calc_rw_task_size(task_params, task_type);
> > +     u32 exp_data_transfer_len =3D conn_params->max_burst_length;
> > +     bool slow_io =3D false;
> > +     u8 num_sges =3D 0;
> > +
> > +     init_default_nvmetcp_task(task_params, pdu_header, task_type);
> > +
> > +     /* Tx/Rx: */
> > +     if (task_params->tx_io_size) {
> > +             /* if data to transmit: */
> > +             init_scsi_sgl_context(&context->ystorm_st_context.state.s=
gl_params,
> > +                                   &context->ystorm_st_context.state.d=
ata_desc,
> > +                                   sgl_task_params);
> > +             slow_io =3D nvmetcp_is_slow_sgl(sgl_task_params->num_sges=
,
> > +                                           sgl_task_params->small_mid_=
sge);
> > +             num_sges =3D
> > +                     (u8)(!slow_io ? min((u32)sgl_task_params->num_sge=
s,
> > +                                         (u32)SCSI_NUM_SGES_SLOW_SGL_T=
HR) :
> > +                                         NVMETCP_WQE_NUM_SGES_SLOWIO);
> > +             if (slow_io) {
> > +                     SET_FIELD(context->ystorm_st_context.state.flags,
> > +                               YSTORM_NVMETCP_TASK_STATE_SLOW_IO, 1);
> > +             }
> > +     } else if (task_params->rx_io_size) {
> > +             /* if data to receive: */
> > +             init_scsi_sgl_context(&context->mstorm_st_context.sgl_par=
ams,
> > +                                   &context->mstorm_st_context.data_de=
sc,
> > +                                   sgl_task_params);
> > +             num_sges =3D
> > +                     (u8)(!nvmetcp_is_slow_sgl(sgl_task_params->num_sg=
es,
> > +                                               sgl_task_params->small_=
mid_sge) ?
> > +                                               min((u32)sgl_task_param=
s->num_sges,
> > +                                                   (u32)SCSI_NUM_SGES_=
SLOW_SGL_THR) :
> > +                                                   NVMETCP_WQE_NUM_SGE=
S_SLOWIO);
> > +             context->mstorm_st_context.rem_task_size =3D cpu_to_le32(=
task_size);
> > +     }
> > +
> > +     /* Ustorm context: */
> > +     if (exp_data_transfer_len > task_size)
> > +             /* The size of the transmitted task*/
> > +             exp_data_transfer_len =3D task_size;
> > +     init_ustorm_task_contexts(&context->ustorm_st_context,
> > +                               &context->ustorm_ag_context,
> > +                               /* Remaining Receive length is the Task=
 Size */
> > +                               task_size,
> > +                               /* The size of the transmitted task */
> > +                               exp_data_transfer_len,
> > +                               /* num_sges */
> > +                               num_sges,
> > +                               false);
> > +
> > +     /* Set exp_data_acked */
> > +     if (task_type =3D=3D NVMETCP_TASK_TYPE_HOST_WRITE) {
> > +             if (task_params->send_write_incapsule)
> > +                     context->ustorm_ag_context.exp_data_acked =3D tas=
k_size;
> > +             else
> > +                     context->ustorm_ag_context.exp_data_acked =3D 0;
> > +     } else if (task_type =3D=3D NVMETCP_TASK_TYPE_HOST_READ) {
> > +             context->ustorm_ag_context.exp_data_acked =3D 0;
> > +     }
> > +
> > +     context->ustorm_ag_context.exp_cont_len =3D 0;
> > +
> > +     init_sqe(task_params, sgl_task_params, task_type);
> > +}
> > +
> > +static void
> > +init_common_initiator_read_task(struct nvmetcp_task_params *task_param=
s,
> > +                             struct nvmetcp_conn_params *conn_params,
> > +                             struct nvmetcp_cmd_capsule_hdr *cmd_pdu_h=
eader,
> > +                             struct storage_sgl_task_params *sgl_task_=
params)
> > +{
> > +     init_rw_nvmetcp_task(task_params, NVMETCP_TASK_TYPE_HOST_READ,
> > +                          conn_params, cmd_pdu_header, sgl_task_params=
);
> > +}
> > +
> > +void init_nvmetcp_host_read_task(struct nvmetcp_task_params *task_para=
ms,
> > +                              struct nvmetcp_conn_params *conn_params,
> > +                              struct nvmetcp_cmd_capsule_hdr *cmd_pdu_=
header,
> > +                              struct storage_sgl_task_params *sgl_task=
_params)
> > +{
> > +     init_common_initiator_read_task(task_params, conn_params,
> > +                                     (void *)cmd_pdu_header, sgl_task_=
params);
> > +}
> > +
> > +static void
> > +init_common_initiator_write_task(struct nvmetcp_task_params *task_para=
ms,
> > +                              struct nvmetcp_conn_params *conn_params,
> > +                              struct nvmetcp_cmd_capsule_hdr *cmd_pdu_=
header,
> > +                              struct storage_sgl_task_params *sgl_task=
_params)
> > +{
> > +     init_rw_nvmetcp_task(task_params, NVMETCP_TASK_TYPE_HOST_WRITE,
> > +                          conn_params, cmd_pdu_header, sgl_task_params=
);
> > +}
> > +
> > +void init_nvmetcp_host_write_task(struct nvmetcp_task_params *task_par=
ams,
> > +                               struct nvmetcp_conn_params *conn_params=
,
> > +                               struct nvmetcp_cmd_capsule_hdr *cmd_pdu=
_header,
> > +                               struct storage_sgl_task_params *sgl_tas=
k_params)
> > +{
> > +     init_common_initiator_write_task(task_params, conn_params,
> > +                                      (void *)cmd_pdu_header,
> > +                                      sgl_task_params);
> > +}
> > +
> > +static void
> > +init_common_login_request_task(struct nvmetcp_task_params *task_params=
,
> > +                            void *login_req_pdu_header,
> > +                            struct storage_sgl_task_params *tx_sgl_tas=
k_params,
> > +                            struct storage_sgl_task_params *rx_sgl_tas=
k_params)
> > +{
> > +     struct e5_nvmetcp_task_context *context =3D task_params->context;
> > +
> > +     init_default_nvmetcp_task(task_params, (void *)login_req_pdu_head=
er,
> > +                               NVMETCP_TASK_TYPE_INIT_CONN_REQUEST);
> > +
> > +     /* Ustorm Context: */
> > +     init_ustorm_task_contexts(&context->ustorm_st_context,
> > +                               &context->ustorm_ag_context,
> > +
> > +                               /* Remaining Receive length is the Task=
 Size */
> > +                               task_params->rx_io_size ?
> > +                               rx_sgl_task_params->total_buffer_size :=
 0,
> > +
> > +                               /* The size of the transmitted task */
> > +                               task_params->tx_io_size ?
> > +                               tx_sgl_task_params->total_buffer_size :=
 0,
> > +                               0, /* num_sges */
> > +                               0); /* tx_dif_conn_err_en */
> > +
> > +     /* SGL context: */
> > +     if (task_params->tx_io_size)
> > +             init_scsi_sgl_context(&context->ystorm_st_context.state.s=
gl_params,
> > +                                   &context->ystorm_st_context.state.d=
ata_desc,
> > +                                   tx_sgl_task_params);
> > +     if (task_params->rx_io_size)
> > +             init_scsi_sgl_context(&context->mstorm_st_context.sgl_par=
ams,
> > +                                   &context->mstorm_st_context.data_de=
sc,
> > +                                   rx_sgl_task_params);
> > +
> > +     context->mstorm_st_context.rem_task_size =3D
> > +             cpu_to_le32(task_params->rx_io_size ?
> > +                              rx_sgl_task_params->total_buffer_size : =
0);
> > +
> > +     init_sqe(task_params, tx_sgl_task_params, NVMETCP_TASK_TYPE_INIT_=
CONN_REQUEST);
> > +}
> > +
> > +/* The following function initializes Login task in Host mode: */
> > +void init_nvmetcp_init_conn_req_task(struct nvmetcp_task_params *task_=
params,
> > +                                  struct nvmetcp_init_conn_req_hdr *in=
it_conn_req_pdu_hdr,
> > +                                  struct storage_sgl_task_params *tx_s=
gl_task_params,
> > +                                  struct storage_sgl_task_params *rx_s=
gl_task_params)
> > +{
> > +     init_common_login_request_task(task_params, init_conn_req_pdu_hdr=
,
> > +                                    tx_sgl_task_params, rx_sgl_task_pa=
rams);
> > +}
> > +
> > +void init_cleanup_task_nvmetcp(struct nvmetcp_task_params *task_params=
)
> > +{
> > +     init_sqe(task_params, NULL, NVMETCP_TASK_TYPE_CLEANUP);
> > +}
> > diff --git a/drivers/net/ethernet/qlogic/qed/qed_nvmetcp_fw_funcs.h b/d=
rivers/net/ethernet/qlogic/qed/qed_nvmetcp_fw_funcs.h
> > new file mode 100644
> > index 000000000000..3a8c74356c4c
> > --- /dev/null
> > +++ b/drivers/net/ethernet/qlogic/qed/qed_nvmetcp_fw_funcs.h
> > @@ -0,0 +1,43 @@
> > +/* SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause) */
> > +/* Copyright 2021 Marvell. All rights reserved. */
> > +
> > +#ifndef _QED_NVMETCP_FW_FUNCS_H
> > +#define _QED_NVMETCP_FW_FUNCS_H
> > +
> > +#include <linux/kernel.h>
> > +#include <linux/module.h>
> > +#include <linux/pci.h>
> > +#include <linux/kernel.h>
> > +#include <linux/list.h>
> > +#include <linux/mm.h>
> > +#include <linux/types.h>
> > +#include <asm/byteorder.h>
> > +#include <linux/qed/common_hsi.h>
> > +#include <linux/qed/storage_common.h>
> > +#include <linux/qed/nvmetcp_common.h>
> > +#include <linux/qed/qed_nvmetcp_if.h>
> > +
> > +#if IS_ENABLED(CONFIG_QED_NVMETCP)
> > +
> > +void init_nvmetcp_host_read_task(struct nvmetcp_task_params *task_para=
ms,
> > +                              struct nvmetcp_conn_params *conn_params,
> > +                              struct nvmetcp_cmd_capsule_hdr *cmd_pdu_=
header,
> > +                              struct storage_sgl_task_params *sgl_task=
_params);
> > +
> > +void init_nvmetcp_host_write_task(struct nvmetcp_task_params *task_par=
ams,
> > +                               struct nvmetcp_conn_params *conn_params=
,
> > +                               struct nvmetcp_cmd_capsule_hdr *cmd_pdu=
_header,
> > +                               struct storage_sgl_task_params *sgl_tas=
k_params);
> > +
> > +void init_nvmetcp_init_conn_req_task(struct nvmetcp_task_params *task_=
params,
> > +                                  struct nvmetcp_init_conn_req_hdr *in=
it_conn_req_pdu_hdr,
> > +                                  struct storage_sgl_task_params *tx_s=
gl_task_params,
> > +                                  struct storage_sgl_task_params *rx_s=
gl_task_params);
> > +
> > +void init_cleanup_task_nvmetcp(struct nvmetcp_task_params *task_params=
);
> > +
> > +#else /* IS_ENABLED(CONFIG_QED_NVMETCP) */
> > +
> > +#endif /* IS_ENABLED(CONFIG_QED_NVMETCP) */
> > +
> > +#endif /* _QED_NVMETCP_FW_FUNCS_H */
> > diff --git a/include/linux/qed/nvmetcp_common.h b/include/linux/qed/nvm=
etcp_common.h
> > index dda7a785c321..c0023bb185dd 100644
> > --- a/include/linux/qed/nvmetcp_common.h
> > +++ b/include/linux/qed/nvmetcp_common.h
> > @@ -9,6 +9,9 @@
> >   #define NVMETCP_SLOW_PATH_LAYER_CODE (6)
> >   #define NVMETCP_WQE_NUM_SGES_SLOWIO (0xf)
> >
> > +#define QED_NVMETCP_CMD_HDR_SIZE 72
> > +#define QED_NVMETCP_CMN_HDR_SIZE 24
> > +
> >   /* NVMeTCP firmware function init parameters */
> >   struct nvmetcp_spe_func_init {
> >       __le16 half_way_close_timeout;
> > diff --git a/include/linux/qed/qed_nvmetcp_if.h b/include/linux/qed/qed=
_nvmetcp_if.h
> > index 04e90dc42c12..d971be84f804 100644
> > --- a/include/linux/qed/qed_nvmetcp_if.h
> > +++ b/include/linux/qed/qed_nvmetcp_if.h
> > @@ -220,6 +220,23 @@ struct qed_nvmetcp_ops {
> >       void (*remove_dst_tcp_port_filter)(struct qed_dev *cdev, u16 dest=
_port);
> >
> >       void (*clear_all_filters)(struct qed_dev *cdev);
> > +
> > +     void (*init_read_io)(struct nvmetcp_task_params *task_params,
> > +                          struct nvmetcp_conn_params *conn_params,
> > +                          struct nvmetcp_cmd_capsule_hdr *cmd_pdu_head=
er,
> > +                          struct storage_sgl_task_params *sgl_task_par=
ams);
> > +
> > +     void (*init_write_io)(struct nvmetcp_task_params *task_params,
> > +                           struct nvmetcp_conn_params *conn_params,
> > +                           struct nvmetcp_cmd_capsule_hdr *cmd_pdu_hea=
der,
> > +                           struct storage_sgl_task_params *sgl_task_pa=
rams);
> > +
> > +     void (*init_icreq_exchange)(struct nvmetcp_task_params *task_para=
ms,
> > +                                 struct nvmetcp_init_conn_req_hdr *ini=
t_conn_req_pdu_hdr,
> > +                                 struct storage_sgl_task_params *tx_sg=
l_task_params,
> > +                                 struct storage_sgl_task_params *rx_sg=
l_task_params);
> > +
> > +     void (*init_task_cleanup)(struct nvmetcp_task_params *task_params=
);
> >   };
> >
> >   const struct qed_nvmetcp_ops *qed_get_nvmetcp_ops(void);
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
