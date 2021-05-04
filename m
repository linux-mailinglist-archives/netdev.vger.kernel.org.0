Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 289B3372E01
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 18:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231786AbhEDQ1I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 12:27:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231523AbhEDQ1G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 12:27:06 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F863C061574
        for <netdev@vger.kernel.org>; Tue,  4 May 2021 09:26:10 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id u3so14077988eja.12
        for <netdev@vger.kernel.org>; Tue, 04 May 2021 09:26:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bcGUfjJwxY1Gmm8snEy3Qc1fFdpsIhwZYjuRi0GgdE8=;
        b=lz5t3MQvbpnOAW3n0mftRB/PJnkXpo+wtYGbkcUwQ71eOr2339ydZL01ek/GX9Za97
         AvOEVCwUvr+6vzbc4jy9oV3nfgj8pZ764hqeL6AdQeAThGNBxKaaRnRyKQO4cx5l6817
         ZHavWsU7/mE6YbYg1x4XA08iyQtd5eSx+BacRv8zTZoQGWXaFz8WF6mCDoehCYj9a7q4
         esYMB+zRpesMcYa/uDzK6jq7vD/q0rrOXqE2HKSgUCF107Q9/+7Czt3MLkieOsi+FfPZ
         agFGKZRGRwjWUwkc+JJ36MGVxeZ8b7h6F9Y4iRiPr4Q9Wmr02sq5/I73ZaN2Bn+J3/cn
         WBgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bcGUfjJwxY1Gmm8snEy3Qc1fFdpsIhwZYjuRi0GgdE8=;
        b=F4gq9ZxqDCU6fSUGnLR/KrSa1nL+lVYhQ5BO82AworULd8zj8TLkgZHck2Z0I/8BV2
         cE3gVhhQxMeGkwrNCVH+GQs2x7bjNWbgXSWvVcTYWEBSUSG2cSWcReGfOzRkgtBYFOn3
         Nn/MPUGhKdZN/qhyesOZ2DDSgr6jQCq3EOPGpX6DLUddQrZDpHczGVghEqoulp5O6RMi
         G3pww9NVLyqkmFCTCcWUe98sblj+r9h5lSaVhUTqi0TA1h8WWqIXNJ/JxjtP5cRSu8JB
         HyN35iWfg6hPPPQfgVFca18PHQrC1Cf2xEPllbUoBhBPJqi77rzbIQYEwnctii80rXCj
         eDrQ==
X-Gm-Message-State: AOAM530iZlZjA4r5wa/Ce/Kd4vT4ZDDxNm/AWsjFREWKr3dwQosvYaMn
        Ku05jejoVUT2VbjmwUc5V9emjBkc+5+mPpEn2lE=
X-Google-Smtp-Source: ABdhPJz2djDgaYi2H+hAqzfUNd3bM8BxtPSt5rDdVgXoOMko9DvnZYxWyz4lnHT2LlH2WMM52+6gLo40tFAO3Z1eFfo=
X-Received: by 2002:a17:906:90b:: with SMTP id i11mr22836993ejd.168.1620145569174;
 Tue, 04 May 2021 09:26:09 -0700 (PDT)
MIME-Version: 1.0
References: <20210429190926.5086-1-smalin@marvell.com> <20210429190926.5086-6-smalin@marvell.com>
 <aef7561f-655a-5a89-f5e5-5bafe68bfa39@suse.de>
In-Reply-To: <aef7561f-655a-5a89-f5e5-5bafe68bfa39@suse.de>
From:   Shai Malin <malin1024@gmail.com>
Date:   Tue, 4 May 2021 19:25:57 +0300
Message-ID: <CAKKgK4xQweLOx+_Prw_E97NPZaeCygFYxJBUjsbPKagBhkiA_Q@mail.gmail.com>
Subject: Re: [RFC PATCH v4 05/27] qed: Add NVMeTCP Offload IO Level FW and HW HSI
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

On 5/2/21 2:22 PM, Hannes Reinecke wrote:
> On 4/29/21 9:09 PM, Shai Malin wrote:
> > This patch introduces the NVMeTCP Offload FW and HW  HSI in order
> > to initialize the IO level configuration into a per IO HW
> > resource ("task") as part of the IO path flow.
> >
> > Acked-by: Igor Russkikh <irusskikh@marvell.com>
> > Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> > Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
> > Signed-off-by: Shai Malin <smalin@marvell.com>
> > Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
> > Signed-off-by: Ariel Elior <aelior@marvell.com>
> > ---
> >   include/linux/qed/nvmetcp_common.h | 418 ++++++++++++++++++++++++++++=
-
> >   include/linux/qed/qed_nvmetcp_if.h |  37 +++
> >   2 files changed, 454 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/linux/qed/nvmetcp_common.h b/include/linux/qed/nvm=
etcp_common.h
> > index c8836b71b866..dda7a785c321 100644
> > --- a/include/linux/qed/nvmetcp_common.h
> > +++ b/include/linux/qed/nvmetcp_common.h
> > @@ -7,6 +7,7 @@
> >   #include "tcp_common.h"
> >
> >   #define NVMETCP_SLOW_PATH_LAYER_CODE (6)
> > +#define NVMETCP_WQE_NUM_SGES_SLOWIO (0xf)
> >
> >   /* NVMeTCP firmware function init parameters */
> >   struct nvmetcp_spe_func_init {
> > @@ -194,4 +195,419 @@ struct nvmetcp_wqe {
> >   #define NVMETCP_WQE_CDB_SIZE_OR_NVMETCP_CMD_SHIFT 24
> >   };
> >
> > -#endif /* __NVMETCP_COMMON__ */
> > +struct nvmetcp_host_cccid_itid_entry {
> > +     __le16 itid;
> > +};
> > +
> > +struct nvmetcp_connect_done_results {
> > +     __le16 icid;
> > +     __le16 conn_id;
> > +     struct tcp_ulp_connect_done_params params;
> > +};
> > +
> > +struct nvmetcp_eqe_data {
> > +     __le16 icid;
> > +     __le16 conn_id;
> > +     __le16 reserved;
> > +     u8 error_code;
> > +     u8 error_pdu_opcode_reserved;
> > +#define NVMETCP_EQE_DATA_ERROR_PDU_OPCODE_MASK 0x3F
> > +#define NVMETCP_EQE_DATA_ERROR_PDU_OPCODE_SHIFT  0
> > +#define NVMETCP_EQE_DATA_ERROR_PDU_OPCODE_VALID_MASK  0x1
> > +#define NVMETCP_EQE_DATA_ERROR_PDU_OPCODE_VALID_SHIFT  6
> > +#define NVMETCP_EQE_DATA_RESERVED0_MASK 0x1
> > +#define NVMETCP_EQE_DATA_RESERVED0_SHIFT 7
> > +};
> > +
> > +enum nvmetcp_task_type {
> > +     NVMETCP_TASK_TYPE_HOST_WRITE,
> > +     NVMETCP_TASK_TYPE_HOST_READ,
> > +     NVMETCP_TASK_TYPE_INIT_CONN_REQUEST,
> > +     NVMETCP_TASK_TYPE_RESERVED0,
> > +     NVMETCP_TASK_TYPE_CLEANUP,
> > +     NVMETCP_TASK_TYPE_HOST_READ_NO_CQE,
> > +     MAX_NVMETCP_TASK_TYPE
> > +};
> > +
> > +struct nvmetcp_db_data {
> > +     u8 params;
> > +#define NVMETCP_DB_DATA_DEST_MASK 0x3 /* destination of doorbell (use =
enum db_dest) */
> > +#define NVMETCP_DB_DATA_DEST_SHIFT 0
> > +#define NVMETCP_DB_DATA_AGG_CMD_MASK 0x3 /* aggregative command to CM =
(use enum db_agg_cmd_sel) */
> > +#define NVMETCP_DB_DATA_AGG_CMD_SHIFT 2
> > +#define NVMETCP_DB_DATA_BYPASS_EN_MASK 0x1 /* enable QM bypass */
> > +#define NVMETCP_DB_DATA_BYPASS_EN_SHIFT 4
> > +#define NVMETCP_DB_DATA_RESERVED_MASK 0x1
> > +#define NVMETCP_DB_DATA_RESERVED_SHIFT 5
> > +#define NVMETCP_DB_DATA_AGG_VAL_SEL_MASK 0x3 /* aggregative value sele=
ction */
> > +#define NVMETCP_DB_DATA_AGG_VAL_SEL_SHIFT 6
> > +     u8 agg_flags; /* bit for every DQ counter flags in CM context tha=
t DQ can increment */
> > +     __le16 sq_prod;
> > +};
> > +
> > +struct nvmetcp_fw_cqe_error_bitmap {
> > +     u8 cqe_error_status_bits;
> > +#define CQE_ERROR_BITMAP_DIF_ERR_BITS_MASK 0x7
> > +#define CQE_ERROR_BITMAP_DIF_ERR_BITS_SHIFT 0
> > +#define CQE_ERROR_BITMAP_DATA_DIGEST_ERR_MASK 0x1
> > +#define CQE_ERROR_BITMAP_DATA_DIGEST_ERR_SHIFT 3
> > +#define CQE_ERROR_BITMAP_RCV_ON_INVALID_CONN_MASK 0x1
> > +#define CQE_ERROR_BITMAP_RCV_ON_INVALID_CONN_SHIFT 4
> > +};
>
> Why exactly do you need a struct here?
> For just one 8 bit value?
>

Will be fixed in v5.

> > + > +struct nvmetcp_nvmf_cqe {
> > +     __le32 reserved[4];
> > +};
> > +
> > +struct nvmetcp_fw_cqe_data {
> > +     struct nvmetcp_nvmf_cqe nvme_cqe;
> > +     struct regpair task_opaque;
> > +     __le32 reserved[6];
> > +};
> > +
> > +struct nvmetcp_fw_cqe {
> > +     __le16 conn_id;
> > +     u8 cqe_type;
> > +     struct nvmetcp_fw_cqe_error_bitmap error_bitmap;
> > +     __le16 itid;
> > +     u8 task_type;
> > +     u8 fw_dbg_field;
> > +     u8 caused_conn_err;
> > +     u8 reserved0[3];
> > +     __le32 reserved1;
> > +     struct nvmetcp_nvmf_cqe nvme_cqe;
> > +     struct regpair task_opaque;
> > +     __le32 reserved[6];
> > +};
> > +
> > +enum nvmetcp_fw_cqes_type {
> > +     NVMETCP_FW_CQE_TYPE_NORMAL =3D 1,
> > +     NVMETCP_FW_CQE_TYPE_RESERVED0,
> > +     NVMETCP_FW_CQE_TYPE_RESERVED1,
> > +     NVMETCP_FW_CQE_TYPE_CLEANUP,
> > +     NVMETCP_FW_CQE_TYPE_DUMMY,
> > +     MAX_NVMETCP_FW_CQES_TYPE
> > +};
> > +
> > +struct ystorm_nvmetcp_task_state {
> > +     struct scsi_cached_sges data_desc;
> > +     struct scsi_sgl_params sgl_params;
> > +     __le32 resrved0;
> > +     __le32 buffer_offset;
> > +     __le16 cccid;
> > +     struct nvmetcp_dif_flags dif_flags;
> > +     u8 flags;
> > +#define YSTORM_NVMETCP_TASK_STATE_LOCAL_COMP_MASK 0x1
> > +#define YSTORM_NVMETCP_TASK_STATE_LOCAL_COMP_SHIFT 0
> > +#define YSTORM_NVMETCP_TASK_STATE_SLOW_IO_MASK 0x1
> > +#define YSTORM_NVMETCP_TASK_STATE_SLOW_IO_SHIFT 1
> > +#define YSTORM_NVMETCP_TASK_STATE_SET_DIF_OFFSET_MASK 0x1
> > +#define YSTORM_NVMETCP_TASK_STATE_SET_DIF_OFFSET_SHIFT 2
> > +#define YSTORM_NVMETCP_TASK_STATE_SEND_W_RSP_MASK 0x1
> > +#define YSTORM_NVMETCP_TASK_STATE_SEND_W_RSP_SHIFT 3
> > +};
> > +
> > +struct ystorm_nvmetcp_task_rxmit_opt {
> > +     __le32 reserved[4];
> > +};
> > +
> > +struct nvmetcp_task_hdr {
> > +     __le32 reg[18];
> > +};
> > +
> > +struct nvmetcp_task_hdr_aligned {
> > +     struct nvmetcp_task_hdr task_hdr;
> > +     __le32 reserved[2];     /* HSI_COMMENT: Align to QREG */
> > +};
> > +
> > +struct e5_tdif_task_context {
> > +     __le32 reserved[16];
> > +};
> > +
> > +struct e5_rdif_task_context {
> > +     __le32 reserved[12];
> > +};
> > +
> > +struct ystorm_nvmetcp_task_st_ctx {
> > +     struct ystorm_nvmetcp_task_state state;
> > +     struct ystorm_nvmetcp_task_rxmit_opt rxmit_opt;
> > +     struct nvmetcp_task_hdr_aligned pdu_hdr;
> > +};
> > +
> > +struct mstorm_nvmetcp_task_st_ctx {
> > +     struct scsi_cached_sges data_desc;
> > +     struct scsi_sgl_params sgl_params;
> > +     __le32 rem_task_size;
> > +     __le32 data_buffer_offset;
> > +     u8 task_type;
> > +     struct nvmetcp_dif_flags dif_flags;
> > +     __le16 dif_task_icid;
> > +     struct regpair reserved0;
> > +     __le32 expected_itt;
> > +     __le32 reserved1;
> > +};
> > +
> > +struct nvmetcp_reg1 {
> > +     __le32 reg1_map;
> > +#define NVMETCP_REG1_NUM_SGES_MASK 0xF
> > +#define NVMETCP_REG1_NUM_SGES_SHIFT 0
> > +#define NVMETCP_REG1_RESERVED1_MASK 0xFFFFFFF
> > +#define NVMETCP_REG1_RESERVED1_SHIFT 4
> > +};
> > +
>
> Similar here; it is 32 bits, true, but still just a single value.

Will be fixed in v5.

>
> > +struct ustorm_nvmetcp_task_st_ctx {
> > +     __le32 rem_rcv_len;
> > +     __le32 exp_data_transfer_len;
> > +     __le32 exp_data_sn;
> > +     struct regpair reserved0;
> > +     struct nvmetcp_reg1 reg1;
> > +     u8 flags2;
> > +#define USTORM_NVMETCP_TASK_ST_CTX_AHS_EXIST_MASK 0x1
> > +#define USTORM_NVMETCP_TASK_ST_CTX_AHS_EXIST_SHIFT 0
> > +#define USTORM_NVMETCP_TASK_ST_CTX_RESERVED1_MASK 0x7F
> > +#define USTORM_NVMETCP_TASK_ST_CTX_RESERVED1_SHIFT 1
> > +     struct nvmetcp_dif_flags dif_flags;
> > +     __le16 reserved3;
> > +     __le16 tqe_opaque[2];
> > +     __le32 reserved5;
> > +     __le32 nvme_tcp_opaque_lo;
> > +     __le32 nvme_tcp_opaque_hi;
> > +     u8 task_type;
> > +     u8 error_flags;
> > +#define USTORM_NVMETCP_TASK_ST_CTX_DATA_DIGEST_ERROR_MASK 0x1
> > +#define USTORM_NVMETCP_TASK_ST_CTX_DATA_DIGEST_ERROR_SHIFT 0
> > +#define USTORM_NVMETCP_TASK_ST_CTX_DATA_TRUNCATED_ERROR_MASK 0x1
> > +#define USTORM_NVMETCP_TASK_ST_CTX_DATA_TRUNCATED_ERROR_SHIFT 1
> > +#define USTORM_NVMETCP_TASK_ST_CTX_UNDER_RUN_ERROR_MASK 0x1
> > +#define USTORM_NVMETCP_TASK_ST_CTX_UNDER_RUN_ERROR_SHIFT 2
> > +#define USTORM_NVMETCP_TASK_ST_CTX_NVME_TCP_MASK 0x1
> > +#define USTORM_NVMETCP_TASK_ST_CTX_NVME_TCP_SHIFT 3
> > +     u8 flags;
> > +#define USTORM_NVMETCP_TASK_ST_CTX_CQE_WRITE_MASK 0x3
> > +#define USTORM_NVMETCP_TASK_ST_CTX_CQE_WRITE_SHIFT 0
> > +#define USTORM_NVMETCP_TASK_ST_CTX_LOCAL_COMP_MASK 0x1
> > +#define USTORM_NVMETCP_TASK_ST_CTX_LOCAL_COMP_SHIFT 2
> > +#define USTORM_NVMETCP_TASK_ST_CTX_Q0_R2TQE_WRITE_MASK 0x1
> > +#define USTORM_NVMETCP_TASK_ST_CTX_Q0_R2TQE_WRITE_SHIFT 3
> > +#define USTORM_NVMETCP_TASK_ST_CTX_TOTAL_DATA_ACKED_DONE_MASK 0x1
> > +#define USTORM_NVMETCP_TASK_ST_CTX_TOTAL_DATA_ACKED_DONE_SHIFT 4
> > +#define USTORM_NVMETCP_TASK_ST_CTX_HQ_SCANNED_DONE_MASK 0x1
> > +#define USTORM_NVMETCP_TASK_ST_CTX_HQ_SCANNED_DONE_SHIFT 5
> > +#define USTORM_NVMETCP_TASK_ST_CTX_R2T2RECV_DONE_MASK 0x1
> > +#define USTORM_NVMETCP_TASK_ST_CTX_R2T2RECV_DONE_SHIFT 6
> > +     u8 cq_rss_number;
> > +};
> > +
> > +struct e5_ystorm_nvmetcp_task_ag_ctx {
> > +     u8 reserved /* cdu_validation */;
> > +     u8 byte1 /* state_and_core_id */;
> > +     __le16 word0 /* icid */;
> > +     u8 flags0;
> > +     u8 flags1;
> > +     u8 flags2;
> > +     u8 flags3;
> > +     __le32 TTT;
> > +     u8 byte2;
> > +     u8 byte3;
> > +     u8 byte4;
> > +     u8 e4_reserved7;
> > +};
> > +
> > +struct e5_mstorm_nvmetcp_task_ag_ctx {
> > +     u8 cdu_validation;
> > +     u8 byte1;
> > +     __le16 task_cid;
> > +     u8 flags0;
> > +#define E5_MSTORM_NVMETCP_TASK_AG_CTX_CONNECTION_TYPE_MASK 0xF
> > +#define E5_MSTORM_NVMETCP_TASK_AG_CTX_CONNECTION_TYPE_SHIFT 0
> > +#define E5_MSTORM_NVMETCP_TASK_AG_CTX_EXIST_IN_QM0_MASK 0x1
> > +#define E5_MSTORM_NVMETCP_TASK_AG_CTX_EXIST_IN_QM0_SHIFT 4
> > +#define E5_MSTORM_NVMETCP_TASK_AG_CTX_CONN_CLEAR_SQ_FLAG_MASK 0x1
> > +#define E5_MSTORM_NVMETCP_TASK_AG_CTX_CONN_CLEAR_SQ_FLAG_SHIFT 5
> > +#define E5_MSTORM_NVMETCP_TASK_AG_CTX_VALID_MASK 0x1
> > +#define E5_MSTORM_NVMETCP_TASK_AG_CTX_VALID_SHIFT 6
> > +#define E5_MSTORM_NVMETCP_TASK_AG_CTX_TASK_CLEANUP_FLAG_MASK 0x1
> > +#define E5_MSTORM_NVMETCP_TASK_AG_CTX_TASK_CLEANUP_FLAG_SHIFT 7
> > +     u8 flags1;
> > +#define E5_MSTORM_NVMETCP_TASK_AG_CTX_TASK_CLEANUP_CF_MASK 0x3
> > +#define E5_MSTORM_NVMETCP_TASK_AG_CTX_TASK_CLEANUP_CF_SHIFT 0
> > +#define E5_MSTORM_NVMETCP_TASK_AG_CTX_CF1_MASK 0x3
> > +#define E5_MSTORM_NVMETCP_TASK_AG_CTX_CF1_SHIFT 2
> > +#define E5_MSTORM_NVMETCP_TASK_AG_CTX_CF2_MASK 0x3
> > +#define E5_MSTORM_NVMETCP_TASK_AG_CTX_CF2_SHIFT 4
> > +#define E5_MSTORM_NVMETCP_TASK_AG_CTX_TASK_CLEANUP_CF_EN_MASK 0x1
> > +#define E5_MSTORM_NVMETCP_TASK_AG_CTX_TASK_CLEANUP_CF_EN_SHIFT 6
> > +#define E5_MSTORM_NVMETCP_TASK_AG_CTX_CF1EN_MASK 0x1
> > +#define E5_MSTORM_NVMETCP_TASK_AG_CTX_CF1EN_SHIFT 7
> > +     u8 flags2;
> > +     u8 flags3;
> > +     __le32 reg0;
> > +     u8 byte2;
> > +     u8 byte3;
> > +     u8 byte4;
> > +     u8 e4_reserved7;
> > +};
> > +
> > +struct e5_ustorm_nvmetcp_task_ag_ctx {
> > +     u8 reserved;
> > +     u8 state_and_core_id;
> > +     __le16 icid;
> > +     u8 flags0;
> > +#define E5_USTORM_NVMETCP_TASK_AG_CTX_CONNECTION_TYPE_MASK 0xF
> > +#define E5_USTORM_NVMETCP_TASK_AG_CTX_CONNECTION_TYPE_SHIFT 0
> > +#define E5_USTORM_NVMETCP_TASK_AG_CTX_EXIST_IN_QM0_MASK 0x1
> > +#define E5_USTORM_NVMETCP_TASK_AG_CTX_EXIST_IN_QM0_SHIFT 4
> > +#define E5_USTORM_NVMETCP_TASK_AG_CTX_CONN_CLEAR_SQ_FLAG_MASK 0x1
> > +#define E5_USTORM_NVMETCP_TASK_AG_CTX_CONN_CLEAR_SQ_FLAG_SHIFT 5
> > +#define E5_USTORM_NVMETCP_TASK_AG_CTX_HQ_SCANNED_CF_MASK 0x3
> > +#define E5_USTORM_NVMETCP_TASK_AG_CTX_HQ_SCANNED_CF_SHIFT 6
> > +     u8 flags1;
> > +#define E5_USTORM_NVMETCP_TASK_AG_CTX_RESERVED1_MASK 0x3
> > +#define E5_USTORM_NVMETCP_TASK_AG_CTX_RESERVED1_SHIFT 0
> > +#define E5_USTORM_NVMETCP_TASK_AG_CTX_R2T2RECV_MASK 0x3
> > +#define E5_USTORM_NVMETCP_TASK_AG_CTX_R2T2RECV_SHIFT 2
> > +#define E5_USTORM_NVMETCP_TASK_AG_CTX_CF3_MASK 0x3
> > +#define E5_USTORM_NVMETCP_TASK_AG_CTX_CF3_SHIFT 4
> > +#define E5_USTORM_NVMETCP_TASK_AG_CTX_DIF_ERROR_CF_MASK 0x3
> > +#define E5_USTORM_NVMETCP_TASK_AG_CTX_DIF_ERROR_CF_SHIFT 6
> > +     u8 flags2;
> > +#define E5_USTORM_NVMETCP_TASK_AG_CTX_HQ_SCANNED_CF_EN_MASK 0x1
> > +#define E5_USTORM_NVMETCP_TASK_AG_CTX_HQ_SCANNED_CF_EN_SHIFT 0
> > +#define E5_USTORM_NVMETCP_TASK_AG_CTX_DISABLE_DATA_ACKED_MASK 0x1
> > +#define E5_USTORM_NVMETCP_TASK_AG_CTX_DISABLE_DATA_ACKED_SHIFT 1
> > +#define E5_USTORM_NVMETCP_TASK_AG_CTX_R2T2RECV_EN_MASK 0x1
> > +#define E5_USTORM_NVMETCP_TASK_AG_CTX_R2T2RECV_EN_SHIFT 2
> > +#define E5_USTORM_NVMETCP_TASK_AG_CTX_CF3EN_MASK 0x1
> > +#define E5_USTORM_NVMETCP_TASK_AG_CTX_CF3EN_SHIFT 3
> > +#define E5_USTORM_NVMETCP_TASK_AG_CTX_DIF_ERROR_CF_EN_MASK 0x1
> > +#define E5_USTORM_NVMETCP_TASK_AG_CTX_DIF_ERROR_CF_EN_SHIFT 4
> > +#define E5_USTORM_NVMETCP_TASK_AG_CTX_CMP_DATA_TOTAL_EXP_EN_MASK 0x1
> > +#define E5_USTORM_NVMETCP_TASK_AG_CTX_CMP_DATA_TOTAL_EXP_EN_SHIFT 5
> > +#define E5_USTORM_NVMETCP_TASK_AG_CTX_RULE1EN_MASK 0x1
> > +#define E5_USTORM_NVMETCP_TASK_AG_CTX_RULE1EN_SHIFT 6
> > +#define E5_USTORM_NVMETCP_TASK_AG_CTX_CMP_CONT_RCV_EXP_EN_MASK 0x1
> > +#define E5_USTORM_NVMETCP_TASK_AG_CTX_CMP_CONT_RCV_EXP_EN_SHIFT 7
> > +     u8 flags3;
> > +     u8 flags4;
> > +#define E5_USTORM_NVMETCP_TASK_AG_CTX_E4_RESERVED5_MASK 0x3
> > +#define E5_USTORM_NVMETCP_TASK_AG_CTX_E4_RESERVED5_SHIFT 0
> > +#define E5_USTORM_NVMETCP_TASK_AG_CTX_E4_RESERVED6_MASK 0x1
> > +#define E5_USTORM_NVMETCP_TASK_AG_CTX_E4_RESERVED6_SHIFT 2
> > +#define E5_USTORM_NVMETCP_TASK_AG_CTX_E4_RESERVED7_MASK 0x1
> > +#define E5_USTORM_NVMETCP_TASK_AG_CTX_E4_RESERVED7_SHIFT 3
> > +#define E5_USTORM_NVMETCP_TASK_AG_CTX_DIF_ERROR_TYPE_MASK 0xF
> > +#define E5_USTORM_NVMETCP_TASK_AG_CTX_DIF_ERROR_TYPE_SHIFT 4
> > +     u8 byte2;
> > +     u8 byte3;
> > +     u8 e4_reserved8;
> > +     __le32 dif_err_intervals;
> > +     __le32 dif_error_1st_interval;
> > +     __le32 rcv_cont_len;
> > +     __le32 exp_cont_len;
> > +     __le32 total_data_acked;
> > +     __le32 exp_data_acked;
> > +     __le16 word1;
> > +     __le16 next_tid;
> > +     __le32 hdr_residual_count;
> > +     __le32 exp_r2t_sn;
> > +};
> > +
> > +struct e5_nvmetcp_task_context {
> > +     struct ystorm_nvmetcp_task_st_ctx ystorm_st_context;
> > +     struct e5_ystorm_nvmetcp_task_ag_ctx ystorm_ag_context;
> > +     struct regpair ystorm_ag_padding[2];
> > +     struct e5_tdif_task_context tdif_context;
> > +     struct e5_mstorm_nvmetcp_task_ag_ctx mstorm_ag_context;
> > +     struct regpair mstorm_ag_padding[2];
> > +     struct e5_ustorm_nvmetcp_task_ag_ctx ustorm_ag_context;
> > +     struct regpair ustorm_ag_padding[2];
> > +     struct mstorm_nvmetcp_task_st_ctx mstorm_st_context;
> > +     struct regpair mstorm_st_padding[2];
> > +     struct ustorm_nvmetcp_task_st_ctx ustorm_st_context;
> > +     struct regpair ustorm_st_padding[2];
> > +     struct e5_rdif_task_context rdif_context;
> > +};
> > +
> > +/* NVMe TCP common header in network order */
> > +struct nvmetcp_common_hdr {
> > +     u8 pdo;
> > +     u8 hlen;
> > +     u8 flags;
> > +#define NVMETCP_COMMON_HDR_HDGSTF_MASK 0x1
> > +#define NVMETCP_COMMON_HDR_HDGSTF_SHIFT 0
> > +#define NVMETCP_COMMON_HDR_DDGSTF_MASK 0x1
> > +#define NVMETCP_COMMON_HDR_DDGSTF_SHIFT 1
> > +#define NVMETCP_COMMON_HDR_LAST_PDU_MASK 0x1
> > +#define NVMETCP_COMMON_HDR_LAST_PDU_SHIFT 2
> > +#define NVMETCP_COMMON_HDR_SUCCESS_MASK 0x1
> > +#define NVMETCP_COMMON_HDR_SUCCESS_SHIFT 3
> > +#define NVMETCP_COMMON_HDR_RESERVED_MASK 0xF
> > +#define NVMETCP_COMMON_HDR_RESERVED_SHIFT 4
> > +     u8 pdu_type;
> > +     __le32 plen_swapped;
> > +};
> > +
> Why do you need to define this?
> Wouldn't it be easier to use the standard 'struct nvme_tcp_hdr' and swap
> the bytes before sending it off?

We will change it and use the standard 'struct nvme_tcp_hdr'.

>
> (Or modify the firmware to do the byte-swapping itself ...)
>
> > +/* We don't need the entire 128 Bytes of the ICReq, hence passing only=
 16
> > + * Bytes to the FW in network order.
> > + */
> > +struct nvmetcp_icreq_hdr_psh {
> > +     __le16 pfv;
> > +     u8 hpda;
> > +     u8 digest;
> > +#define NVMETCP_ICREQ_HDR_PSH_16B_HDGST_EN_MASK 0x1
> > +#define NVMETCP_ICREQ_HDR_PSH_16B_HDGST_EN_SHIFT 0
> > +#define NVMETCP_ICREQ_HDR_PSH_16B_DDGST_EN_MASK 0x1
> > +#define NVMETCP_ICREQ_HDR_PSH_16B_DDGST_EN_SHIFT 1
> > +#define NVMETCP_ICREQ_HDR_PSH_16B_RESERVED1_MASK 0x3F
> > +#define NVMETCP_ICREQ_HDR_PSH_16B_RESERVED1_SHIFT 2
> > +     __le32 maxr2t;
> > +     u8 reserved[8];
> > +};
> > +
>
> One of these short-cuts which will come back to haunt you eventually; I
> would consider updating the firmware to process the entire icreq.

We will change it and use the standard 'struct nvme_tcp_icreq_pdu'.

>
> > +struct nvmetcp_cmd_capsule_hdr_psh {
> > +     __le32 raw_swapped[16];
> > +};
> > +
> > +struct nvmetcp_cmd_capsule_hdr {
> > +     struct nvmetcp_common_hdr chdr;
> > +     struct nvmetcp_cmd_capsule_hdr_psh pshdr;
> > +};
> > +
> > +struct nvmetcp_data_hdr {
> > +     __le32 data[6];
> > +};
> > +
> > +struct nvmetcp_h2c_hdr_psh {
> > +     __le16 ttag_swapped;
> > +     __le16 command_id_swapped;
> > +     __le32 data_offset_swapped;
> > +     __le32 data_length_swapped;
> > +     __le32 reserved1;
> > +};
> > +
> > +struct nvmetcp_h2c_hdr {
> > +     struct nvmetcp_common_hdr chdr;
> > +     struct nvmetcp_h2c_hdr_psh pshdr;
> > +};
> > +
> > +/* We don't need the entire 128 Bytes of the ICResp, hence passing onl=
y 16
> > + * Bytes to the FW in network order.
> > + */
> > +struct nvmetcp_icresp_hdr_psh {
> > +     u8 digest;
> > +#define NVMETCP_ICRESP_HDR_PSH_16B_HDGST_EN_MASK 0x1
> > +#define NVMETCP_ICRESP_HDR_PSH_16B_HDGST_EN_SHIFT 0
> > +#define NVMETCP_ICRESP_HDR_PSH_16B_DDGST_EN_MASK 0x1
> > +#define NVMETCP_ICRESP_HDR_PSH_16B_DDGST_EN_SHIFT 1
> > +     u8 cpda;
> > +     __le16 pfv_swapped;
> > +     __le32 maxdata_swapped;
> > +     __le16 reserved2[4];
> > +};
> > +
>
> Same here.

We will change it.

> > +struct nvmetcp_init_conn_req_hdr {
> > +     struct nvmetcp_common_hdr chdr;
> > +     struct nvmetcp_icreq_hdr_psh pshdr;
> > +};
> > +
> > +#endif /* __NVMETCP_COMMON__*/
> > diff --git a/include/linux/qed/qed_nvmetcp_if.h b/include/linux/qed/qed=
_nvmetcp_if.h
> > index 686f924238e3..04e90dc42c12 100644
> > --- a/include/linux/qed/qed_nvmetcp_if.h
> > +++ b/include/linux/qed/qed_nvmetcp_if.h
> > @@ -5,6 +5,8 @@
> >   #define _QED_NVMETCP_IF_H
> >   #include <linux/types.h>
> >   #include <linux/qed/qed_if.h>
> > +#include <linux/qed/storage_common.h>
> > +#include <linux/qed/nvmetcp_common.h>
> >
> >   #define QED_NVMETCP_MAX_IO_SIZE     0x800000
> >
> > @@ -73,6 +75,41 @@ struct qed_nvmetcp_cb_ops {
> >       struct qed_common_cb_ops common;
> >   };
> >
> > +struct nvmetcp_sge {
> > +     struct regpair sge_addr; /* SGE address */
> > +     __le32 sge_len; /* SGE length */
> > +     __le32 reserved;
> > +};
> > +
> > +/* IO path HSI function SGL params */
> > +struct storage_sgl_task_params {
> > +     struct nvmetcp_sge *sgl;
> > +     struct regpair sgl_phys_addr;
> > +     u32 total_buffer_size;
> > +     u16 num_sges;
> > +     bool small_mid_sge;
> > +};
> > +
> > +/* IO path HSI function FW task context params */
> > +struct nvmetcp_task_params {
> > +     void *context; /* Output parameter - set/filled by the HSI functi=
on */
> > +     struct nvmetcp_wqe *sqe;
> > +     u32 tx_io_size; /* in bytes (Without DIF, if exists) */
> > +     u32 rx_io_size; /* in bytes (Without DIF, if exists) */
> > +     u16 conn_icid;
> > +     u16 itid;
> > +     struct regpair opq; /* qedn_task_ctx address */
> > +     u16 host_cccid;
> > +     u8 cq_rss_number;
> > +     bool send_write_incapsule;
> > +};
> > +
> > +/* IO path HSI function FW conn level input params */
> > +
> > +struct nvmetcp_conn_params {
> > +     u32 max_burst_length;
> > +};
> > +
> >   /**
> >    * struct qed_nvmetcp_ops - qed NVMeTCP operations.
> >    * @common:         common operations pointer
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
