Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1348B3717E4
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 17:25:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230364AbhECP0T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 11:26:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230333AbhECP0S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 May 2021 11:26:18 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80841C06174A
        for <netdev@vger.kernel.org>; Mon,  3 May 2021 08:25:24 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id u21so8426606ejo.13
        for <netdev@vger.kernel.org>; Mon, 03 May 2021 08:25:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=S49e1+U7g1Nar8stG/DqFjsL6aBy95j0qBjzDnu1l4Y=;
        b=H56jaVs7nh6e4Hi5y9moxJSWL/bI+a611RZU/f1yHIaUA14NWEJuvekA7ZN2D6r+35
         o5b/P6/2DEsTr0uLj4k7CfBwqDj9QGwnYJdde2xiJYnGE0dItVGXyuzqcRCLZCB70Kqz
         rXh+TY51BK7hxt7VP7ZzLMDrm+yNeShKYVl/1mdRKyEZX9wQ9OEnf07cnOeumQ2kArdg
         tDoNUT8C2Knf7NFvMVR5ao5I6eORB1PSgOuLbDyfEgvVKgh7JNDRWDeIdoXZUUASE30C
         SrQxJ+geRCZZO3mwDuRhA5EqliHntbJcSHyATIoqlREHt4befJH8xOvxSX8XKVU5Vn1n
         lJsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=S49e1+U7g1Nar8stG/DqFjsL6aBy95j0qBjzDnu1l4Y=;
        b=ZafELNvwYME0L47RxzG2FHu0428BI4T6Cfk70/SgVv300RsqJuYkryWL8ielnZcukS
         v7llnrWdURKcULcXR1aA6mZLkk1qGyuQUyYREGh0q7BlzeWRVJGOVciHT7BnsicgGvtP
         b+SBZZvjt7PGob6+x6XSeBy+4vYSs1T63PUQ6vz+2zCiXyJxzTiAgeJkUJ7KcdA7gEEB
         dG05pdBfQbqsxCRzFu2LaP3qmYbjtcODKAaI+OjO/fpaUR5esUbJ4623XKa1mQLX1u5v
         myWalaCfxGUfJgfmjlN6oWb4StHDlC4d7Dbr6+egNyLd+Rzc98rg3LXfkbc0PVjiKepm
         3k2w==
X-Gm-Message-State: AOAM532yrHtaH/Oi6mm2FoCFQ65J0i3OKkG9/YhEWxLAXz3eeK6PMpWd
        3ItRhg782I322EkyLlzVEO4E97TB9agZgX4UIDo=
X-Google-Smtp-Source: ABdhPJxNTFKz6X3b9bo095NoMnh4jj5jqAZB6N5w8+1d+KM1kYJUd9hMoXV6Brhk+gi1tQn9m70cjlQ8yWmGq8uEZuc=
X-Received: by 2002:a17:906:600b:: with SMTP id o11mr17293216ejj.345.1620055522819;
 Mon, 03 May 2021 08:25:22 -0700 (PDT)
MIME-Version: 1.0
References: <20210429190926.5086-1-smalin@marvell.com> <20210429190926.5086-3-smalin@marvell.com>
 <c35e89df-e9b7-fd45-9ad6-bf0f6be1dc5d@suse.de>
In-Reply-To: <c35e89df-e9b7-fd45-9ad6-bf0f6be1dc5d@suse.de>
From:   Shai Malin <malin1024@gmail.com>
Date:   Mon, 3 May 2021 18:25:10 +0300
Message-ID: <CAKKgK4wZ61O_1owhi7wHUYS77FOC34-8AR3xcE=kvGMDifyt8A@mail.gmail.com>
Subject: Re: [RFC PATCH v4 02/27] qed: Add NVMeTCP Offload Connection Level FW
 and HW HSI
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

On 5/1/21 8:28 PM, Hannes Reinecke wrote:
> On 4/29/21 9:09 PM, Shai Malin wrote:
> > This patch introduces the NVMeTCP HSI and HSI functionality in order to
> > initialize and interact with the HW device as part of the connection le=
vel
> > HSI.
> >
> > This includes:
> > - Connection offload: offload a TCP connection to the FW.
> > - Connection update: update the ICReq-ICResp params
> > - Connection clear SQ: outstanding IOs FW flush.
> > - Connection termination: terminate the TCP connection and flush the FW=
.
> >
> > Acked-by: Igor Russkikh <irusskikh@marvell.com>
> > Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> > Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
> > Signed-off-by: Shai Malin <smalin@marvell.com>
> > Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
> > Signed-off-by: Ariel Elior <aelior@marvell.com>
> > ---
> >   drivers/net/ethernet/qlogic/qed/qed_nvmetcp.c | 580 +++++++++++++++++=
-
> >   drivers/net/ethernet/qlogic/qed/qed_nvmetcp.h |  63 ++
> >   drivers/net/ethernet/qlogic/qed/qed_sp.h      |   3 +
> >   include/linux/qed/nvmetcp_common.h            | 143 +++++
> >   include/linux/qed/qed_nvmetcp_if.h            |  94 +++
> >   5 files changed, 881 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/qlogic/qed/qed_nvmetcp.c b/drivers/ne=
t/ethernet/qlogic/qed/qed_nvmetcp.c
> > index da3b5002d216..79bd1cc6677f 100644
> > --- a/drivers/net/ethernet/qlogic/qed/qed_nvmetcp.c
> > +++ b/drivers/net/ethernet/qlogic/qed/qed_nvmetcp.c
> > @@ -259,6 +259,578 @@ static int qed_nvmetcp_start(struct qed_dev *cdev=
,
> >       return 0;
> >   }
> >
> > +static struct qed_hash_nvmetcp_con *qed_nvmetcp_get_hash(struct qed_de=
v *cdev,
> > +                                                      u32 handle)
> > +{
> > +     struct qed_hash_nvmetcp_con *hash_con =3D NULL;
> > +
> > +     if (!(cdev->flags & QED_FLAG_STORAGE_STARTED))
> > +             return NULL;
> > +
> > +     hash_for_each_possible(cdev->connections, hash_con, node, handle)=
 {
> > +             if (hash_con->con->icid =3D=3D handle)
> > +                     break;
> > +     }
> > +
> > +     if (!hash_con || hash_con->con->icid !=3D handle)
> > +             return NULL;
> > +
> > +     return hash_con;
> > +}
> > +
> > +static int qed_sp_nvmetcp_conn_offload(struct qed_hwfn *p_hwfn,
> > +                                    struct qed_nvmetcp_conn *p_conn,
> > +                                    enum spq_mode comp_mode,
> > +                                    struct qed_spq_comp_cb *p_comp_add=
r)
> > +{
> > +     struct nvmetcp_spe_conn_offload *p_ramrod =3D NULL;
> > +     struct tcp_offload_params_opt2 *p_tcp2 =3D NULL;
> > +     struct qed_sp_init_data init_data =3D { 0 };
> > +     struct qed_spq_entry *p_ent =3D NULL;
> > +     dma_addr_t r2tq_pbl_addr;
> > +     dma_addr_t xhq_pbl_addr;
> > +     dma_addr_t uhq_pbl_addr;
> > +     u16 physical_q;
> > +     int rc =3D 0;
> > +     u32 dval;
> > +     u8 i;
> > +
> > +     /* Get SPQ entry */
> > +     init_data.cid =3D p_conn->icid;
> > +     init_data.opaque_fid =3D p_hwfn->hw_info.opaque_fid;
> > +     init_data.comp_mode =3D comp_mode;
> > +     init_data.p_comp_data =3D p_comp_addr;
> > +
> > +     rc =3D qed_sp_init_request(p_hwfn, &p_ent,
> > +                              NVMETCP_RAMROD_CMD_ID_OFFLOAD_CONN,
> > +                              PROTOCOLID_NVMETCP, &init_data);
> > +     if (rc)
> > +             return rc;
> > +
> > +     p_ramrod =3D &p_ent->ramrod.nvmetcp_conn_offload;
> > +
> > +     /* Transmission PQ is the first of the PF */
> > +     physical_q =3D qed_get_cm_pq_idx(p_hwfn, PQ_FLAGS_OFLD);
> > +     p_conn->physical_q0 =3D cpu_to_le16(physical_q);
> > +     p_ramrod->nvmetcp.physical_q0 =3D cpu_to_le16(physical_q);
> > +
> > +     /* nvmetcp Pure-ACK PQ */
> > +     physical_q =3D qed_get_cm_pq_idx(p_hwfn, PQ_FLAGS_ACK);
> > +     p_conn->physical_q1 =3D cpu_to_le16(physical_q);
> > +     p_ramrod->nvmetcp.physical_q1 =3D cpu_to_le16(physical_q);
> > +
> > +     p_ramrod->conn_id =3D cpu_to_le16(p_conn->conn_id);
> > +
> > +     DMA_REGPAIR_LE(p_ramrod->nvmetcp.sq_pbl_addr, p_conn->sq_pbl_addr=
);
> > +
> > +     r2tq_pbl_addr =3D qed_chain_get_pbl_phys(&p_conn->r2tq);
> > +     DMA_REGPAIR_LE(p_ramrod->nvmetcp.r2tq_pbl_addr, r2tq_pbl_addr);
> > +
> > +     xhq_pbl_addr =3D qed_chain_get_pbl_phys(&p_conn->xhq);
> > +     DMA_REGPAIR_LE(p_ramrod->nvmetcp.xhq_pbl_addr, xhq_pbl_addr);
> > +
> > +     uhq_pbl_addr =3D qed_chain_get_pbl_phys(&p_conn->uhq);
> > +     DMA_REGPAIR_LE(p_ramrod->nvmetcp.uhq_pbl_addr, uhq_pbl_addr);
> > +
> > +     p_ramrod->nvmetcp.flags =3D p_conn->offl_flags;
> > +     p_ramrod->nvmetcp.default_cq =3D p_conn->default_cq;
> > +     p_ramrod->nvmetcp.initial_ack =3D 0;
> > +
> > +     DMA_REGPAIR_LE(p_ramrod->nvmetcp.nvmetcp.cccid_itid_table_addr,
> > +                    p_conn->nvmetcp_cccid_itid_table_addr);
> > +     p_ramrod->nvmetcp.nvmetcp.cccid_max_range =3D
> > +              cpu_to_le16(p_conn->nvmetcp_cccid_max_range);
> > +
> > +     p_tcp2 =3D &p_ramrod->tcp;
> > +
> > +     qed_set_fw_mac_addr(&p_tcp2->remote_mac_addr_hi,
> > +                         &p_tcp2->remote_mac_addr_mid,
> > +                         &p_tcp2->remote_mac_addr_lo, p_conn->remote_m=
ac);
> > +     qed_set_fw_mac_addr(&p_tcp2->local_mac_addr_hi,
> > +                         &p_tcp2->local_mac_addr_mid,
> > +                         &p_tcp2->local_mac_addr_lo, p_conn->local_mac=
);
> > +
> > +     p_tcp2->vlan_id =3D cpu_to_le16(p_conn->vlan_id);
> > +     p_tcp2->flags =3D cpu_to_le16(p_conn->tcp_flags);
> > +
> > +     p_tcp2->ip_version =3D p_conn->ip_version;
> > +     for (i =3D 0; i < 4; i++) {
> > +             dval =3D p_conn->remote_ip[i];
> > +             p_tcp2->remote_ip[i] =3D cpu_to_le32(dval);
> > +             dval =3D p_conn->local_ip[i];
> > +             p_tcp2->local_ip[i] =3D cpu_to_le32(dval);
> > +     }
> > +
>
> What is this?
> Some convoluted way of assigning the IP address in little endian?
> Pointless if it's IPv4, as then each bit is just one byte.
> And if it's for IPv6, what do you do for IPv4?
> And isn't there a helper for it?

Endianity here is only for BE machines.
I haven't found a relevant helper function,
Will re-write to have cleaner implementation separately for ipv4 and ipv6.

>
> > +     p_tcp2->flow_label =3D cpu_to_le32(p_conn->flow_label);
> > +     p_tcp2->ttl =3D p_conn->ttl;
> > +     p_tcp2->tos_or_tc =3D p_conn->tos_or_tc;
> > +     p_tcp2->remote_port =3D cpu_to_le16(p_conn->remote_port);
> > +     p_tcp2->local_port =3D cpu_to_le16(p_conn->local_port);
> > +     p_tcp2->mss =3D cpu_to_le16(p_conn->mss);
> > +     p_tcp2->rcv_wnd_scale =3D p_conn->rcv_wnd_scale;
> > +     p_tcp2->connect_mode =3D p_conn->connect_mode;
> > +     p_tcp2->cwnd =3D cpu_to_le32(p_conn->cwnd);
> > +     p_tcp2->ka_max_probe_cnt =3D p_conn->ka_max_probe_cnt;
> > +     p_tcp2->ka_timeout =3D cpu_to_le32(p_conn->ka_timeout);
> > +     p_tcp2->max_rt_time =3D cpu_to_le32(p_conn->max_rt_time);
> > +     p_tcp2->ka_interval =3D cpu_to_le32(p_conn->ka_interval);
> > +
> > +     return qed_spq_post(p_hwfn, p_ent, NULL);
> > +}
> > +
> > +static int qed_sp_nvmetcp_conn_update(struct qed_hwfn *p_hwfn,
> > +                                   struct qed_nvmetcp_conn *p_conn,
> > +                                   enum spq_mode comp_mode,
> > +                                   struct qed_spq_comp_cb *p_comp_addr=
)
> > +{
> > +     struct nvmetcp_conn_update_ramrod_params *p_ramrod =3D NULL;
> > +     struct qed_spq_entry *p_ent =3D NULL;
> > +     struct qed_sp_init_data init_data;
> > +     int rc =3D -EINVAL;
> > +     u32 dval;
> > +
> > +     /* Get SPQ entry */
> > +     memset(&init_data, 0, sizeof(init_data));
> > +     init_data.cid =3D p_conn->icid;
> > +     init_data.opaque_fid =3D p_hwfn->hw_info.opaque_fid;
> > +     init_data.comp_mode =3D comp_mode;
> > +     init_data.p_comp_data =3D p_comp_addr;
> > +
> > +     rc =3D qed_sp_init_request(p_hwfn, &p_ent,
> > +                              NVMETCP_RAMROD_CMD_ID_UPDATE_CONN,
> > +                              PROTOCOLID_NVMETCP, &init_data);
> > +     if (rc)
> > +             return rc;
> > +
> > +     p_ramrod =3D &p_ent->ramrod.nvmetcp_conn_update;
> > +     p_ramrod->conn_id =3D cpu_to_le16(p_conn->conn_id);
> > +     p_ramrod->flags =3D p_conn->update_flag;
> > +     p_ramrod->max_seq_size =3D cpu_to_le32(p_conn->max_seq_size);
> > +     dval =3D p_conn->max_recv_pdu_length;
> > +     p_ramrod->max_recv_pdu_length =3D cpu_to_le32(dval);
> > +     dval =3D p_conn->max_send_pdu_length;
> > +     p_ramrod->max_send_pdu_length =3D cpu_to_le32(dval);
> > +     dval =3D p_conn->first_seq_length;
> > +     p_ramrod->first_seq_length =3D cpu_to_le32(dval);
> > +
> > +     return qed_spq_post(p_hwfn, p_ent, NULL);
> > +}
> > +
> > +static int qed_sp_nvmetcp_conn_terminate(struct qed_hwfn *p_hwfn,
> > +                                      struct qed_nvmetcp_conn *p_conn,
> > +                                      enum spq_mode comp_mode,
> > +                                      struct qed_spq_comp_cb *p_comp_a=
ddr)
> > +{
> > +     struct nvmetcp_spe_conn_termination *p_ramrod =3D NULL;
> > +     struct qed_spq_entry *p_ent =3D NULL;
> > +     struct qed_sp_init_data init_data;
> > +     int rc =3D -EINVAL;
> > +
> > +     /* Get SPQ entry */
> > +     memset(&init_data, 0, sizeof(init_data));
> > +     init_data.cid =3D p_conn->icid;
> > +     init_data.opaque_fid =3D p_hwfn->hw_info.opaque_fid;
> > +     init_data.comp_mode =3D comp_mode;
> > +     init_data.p_comp_data =3D p_comp_addr;
> > +
> > +     rc =3D qed_sp_init_request(p_hwfn, &p_ent,
> > +                              NVMETCP_RAMROD_CMD_ID_TERMINATION_CONN,
> > +                              PROTOCOLID_NVMETCP, &init_data);
> > +     if (rc)
> > +             return rc;
> > +
> > +     p_ramrod =3D &p_ent->ramrod.nvmetcp_conn_terminate;
> > +     p_ramrod->conn_id =3D cpu_to_le16(p_conn->conn_id);
> > +     p_ramrod->abortive =3D p_conn->abortive_dsconnect;
> > +
> > +     return qed_spq_post(p_hwfn, p_ent, NULL);
> > +}
> > +
> > +static int qed_sp_nvmetcp_conn_clear_sq(struct qed_hwfn *p_hwfn,
> > +                                     struct qed_nvmetcp_conn *p_conn,
> > +                                     enum spq_mode comp_mode,
> > +                                     struct qed_spq_comp_cb *p_comp_ad=
dr)
> > +{
> > +     struct qed_spq_entry *p_ent =3D NULL;
> > +     struct qed_sp_init_data init_data;
> > +     int rc =3D -EINVAL;
> > +
> > +     /* Get SPQ entry */
> > +     memset(&init_data, 0, sizeof(init_data));
> > +     init_data.cid =3D p_conn->icid;
> > +     init_data.opaque_fid =3D p_hwfn->hw_info.opaque_fid;
> > +     init_data.comp_mode =3D comp_mode;
> > +     init_data.p_comp_data =3D p_comp_addr;
> > +
> > +     rc =3D qed_sp_init_request(p_hwfn, &p_ent,
> > +                              NVMETCP_RAMROD_CMD_ID_CLEAR_SQ,
> > +                              PROTOCOLID_NVMETCP, &init_data);
> > +     if (rc)
> > +             return rc;
> > +
> > +     return qed_spq_post(p_hwfn, p_ent, NULL);
> > +}
> > +
> > +static void __iomem *qed_nvmetcp_get_db_addr(struct qed_hwfn *p_hwfn, =
u32 cid)
> > +{
> > +     return (u8 __iomem *)p_hwfn->doorbells +
> > +                          qed_db_addr(cid, DQ_DEMS_LEGACY);
> > +}
> > +
> > +static int qed_nvmetcp_allocate_connection(struct qed_hwfn *p_hwfn,
> > +                                        struct qed_nvmetcp_conn **p_ou=
t_conn)
> > +{
> > +     struct qed_chain_init_params params =3D {
> > +             .mode           =3D QED_CHAIN_MODE_PBL,
> > +             .intended_use   =3D QED_CHAIN_USE_TO_CONSUME_PRODUCE,
> > +             .cnt_type       =3D QED_CHAIN_CNT_TYPE_U16,
> > +     };
> > +     struct qed_nvmetcp_pf_params *p_params =3D NULL;
> > +     struct qed_nvmetcp_conn *p_conn =3D NULL;
> > +     int rc =3D 0;
> > +
> > +     /* Try finding a free connection that can be used */
> > +     spin_lock_bh(&p_hwfn->p_nvmetcp_info->lock);
> > +     if (!list_empty(&p_hwfn->p_nvmetcp_info->free_list))
> > +             p_conn =3D list_first_entry(&p_hwfn->p_nvmetcp_info->free=
_list,
> > +                                       struct qed_nvmetcp_conn, list_e=
ntry);
> > +     if (p_conn) {
> > +             list_del(&p_conn->list_entry);
> > +             spin_unlock_bh(&p_hwfn->p_nvmetcp_info->lock);
> > +             *p_out_conn =3D p_conn;
> > +
> > +             return 0;
> > +     }
> > +     spin_unlock_bh(&p_hwfn->p_nvmetcp_info->lock);
> > +
> > +     /* Need to allocate a new connection */
> > +     p_params =3D &p_hwfn->pf_params.nvmetcp_pf_params;
> > +
> > +     p_conn =3D kzalloc(sizeof(*p_conn), GFP_KERNEL);
> > +     if (!p_conn)
> > +             return -ENOMEM;
> > +
> > +     params.num_elems =3D p_params->num_r2tq_pages_in_ring *
> > +                        QED_CHAIN_PAGE_SIZE / sizeof(struct nvmetcp_wq=
e);
> > +     params.elem_size =3D sizeof(struct nvmetcp_wqe);
> > +
> > +     rc =3D qed_chain_alloc(p_hwfn->cdev, &p_conn->r2tq, &params);
> > +     if (rc)
> > +             goto nomem_r2tq;
> > +
> > +     params.num_elems =3D p_params->num_uhq_pages_in_ring *
> > +                        QED_CHAIN_PAGE_SIZE / sizeof(struct iscsi_uhqe=
);
> > +     params.elem_size =3D sizeof(struct iscsi_uhqe);
> > +
> > +     rc =3D qed_chain_alloc(p_hwfn->cdev, &p_conn->uhq, &params);
> > +     if (rc)
> > +             goto nomem_uhq;
> > +
> > +     params.elem_size =3D sizeof(struct iscsi_xhqe);
> > +
> > +     rc =3D qed_chain_alloc(p_hwfn->cdev, &p_conn->xhq, &params);
> > +     if (rc)
> > +             goto nomem;
> > +
> > +     p_conn->free_on_delete =3D true;
> > +     *p_out_conn =3D p_conn;
> > +
> > +     return 0;
> > +
> > +nomem:
> > +     qed_chain_free(p_hwfn->cdev, &p_conn->uhq);
> > +nomem_uhq:
> > +     qed_chain_free(p_hwfn->cdev, &p_conn->r2tq);
> > +nomem_r2tq:
> > +     kfree(p_conn);
> > +
> > +     return -ENOMEM;
> > +}
> > +
> > +static int qed_nvmetcp_acquire_connection(struct qed_hwfn *p_hwfn,
> > +                                       struct qed_nvmetcp_conn **p_out=
_conn)
> > +{
> > +     struct qed_nvmetcp_conn *p_conn =3D NULL;
> > +     int rc =3D 0;
> > +     u32 icid;
> > +
> > +     spin_lock_bh(&p_hwfn->p_nvmetcp_info->lock);
> > +     rc =3D qed_cxt_acquire_cid(p_hwfn, PROTOCOLID_NVMETCP, &icid);
> > +     spin_unlock_bh(&p_hwfn->p_nvmetcp_info->lock);
> > +
> > +     if (rc)
> > +             return rc;
> > +
> > +     rc =3D qed_nvmetcp_allocate_connection(p_hwfn, &p_conn);
> > +     if (rc) {
> > +             spin_lock_bh(&p_hwfn->p_nvmetcp_info->lock);
> > +             qed_cxt_release_cid(p_hwfn, icid);
> > +             spin_unlock_bh(&p_hwfn->p_nvmetcp_info->lock);
> > +
> > +             return rc;
> > +     }
> > +
> > +     p_conn->icid =3D icid;
> > +     p_conn->conn_id =3D (u16)icid;
> > +     p_conn->fw_cid =3D (p_hwfn->hw_info.opaque_fid << 16) | icid;
> > +     *p_out_conn =3D p_conn;
> > +
> > +     return rc;
> > +}
> > +
> > +static void qed_nvmetcp_release_connection(struct qed_hwfn *p_hwfn,
> > +                                        struct qed_nvmetcp_conn *p_con=
n)
> > +{
> > +     spin_lock_bh(&p_hwfn->p_nvmetcp_info->lock);
> > +     list_add_tail(&p_conn->list_entry, &p_hwfn->p_nvmetcp_info->free_=
list);
> > +     qed_cxt_release_cid(p_hwfn, p_conn->icid);
> > +     spin_unlock_bh(&p_hwfn->p_nvmetcp_info->lock);
> > +}
> > +
> > +static void qed_nvmetcp_free_connection(struct qed_hwfn *p_hwfn,
> > +                                     struct qed_nvmetcp_conn *p_conn)
> > +{
> > +     qed_chain_free(p_hwfn->cdev, &p_conn->xhq);
> > +     qed_chain_free(p_hwfn->cdev, &p_conn->uhq);
> > +     qed_chain_free(p_hwfn->cdev, &p_conn->r2tq);
> > +
> > +     kfree(p_conn);
> > +}
> > +
> > +int qed_nvmetcp_alloc(struct qed_hwfn *p_hwfn)
> > +{
> > +     struct qed_nvmetcp_info *p_nvmetcp_info;
> > +
> > +     p_nvmetcp_info =3D kzalloc(sizeof(*p_nvmetcp_info), GFP_KERNEL);
> > +     if (!p_nvmetcp_info)
> > +             return -ENOMEM;
> > +
> > +     INIT_LIST_HEAD(&p_nvmetcp_info->free_list);
> > +
> > +     p_hwfn->p_nvmetcp_info =3D p_nvmetcp_info;
> > +
> > +     return 0;
> > +}
> > +
> > +void qed_nvmetcp_setup(struct qed_hwfn *p_hwfn)
> > +{
> > +     spin_lock_init(&p_hwfn->p_nvmetcp_info->lock);
> > +}
> > +
> > +void qed_nvmetcp_free(struct qed_hwfn *p_hwfn)
> > +{
> > +     struct qed_nvmetcp_conn *p_conn =3D NULL;
> > +
> > +     if (!p_hwfn->p_nvmetcp_info)
> > +             return;
> > +
> > +     while (!list_empty(&p_hwfn->p_nvmetcp_info->free_list)) {
> > +             p_conn =3D list_first_entry(&p_hwfn->p_nvmetcp_info->free=
_list,
> > +                                       struct qed_nvmetcp_conn, list_e=
ntry);
> > +             if (p_conn) {
> > +                     list_del(&p_conn->list_entry);
> > +                     qed_nvmetcp_free_connection(p_hwfn, p_conn);
> > +             }
> > +     }
> > +
> > +     kfree(p_hwfn->p_nvmetcp_info);
> > +     p_hwfn->p_nvmetcp_info =3D NULL;
> > +}
> > +
> > +static int qed_nvmetcp_acquire_conn(struct qed_dev *cdev,
> > +                                 u32 *handle,
> > +                                 u32 *fw_cid, void __iomem **p_doorbel=
l)
> > +{
> > +     struct qed_hash_nvmetcp_con *hash_con;
> > +     int rc;
> > +
> > +     /* Allocate a hashed connection */
> > +     hash_con =3D kzalloc(sizeof(*hash_con), GFP_ATOMIC);
> > +     if (!hash_con)
> > +             return -ENOMEM;
> > +
> > +     /* Acquire the connection */
> > +     rc =3D qed_nvmetcp_acquire_connection(QED_AFFIN_HWFN(cdev),
> > +                                         &hash_con->con);
> > +     if (rc) {
> > +             DP_NOTICE(cdev, "Failed to acquire Connection\n");
> > +             kfree(hash_con);
> > +
> > +             return rc;
> > +     }
> > +
> > +     /* Added the connection to hash table */
> > +     *handle =3D hash_con->con->icid;
> > +     *fw_cid =3D hash_con->con->fw_cid;
> > +     hash_add(cdev->connections, &hash_con->node, *handle);
> > +
> > +     if (p_doorbell)
> > +             *p_doorbell =3D qed_nvmetcp_get_db_addr(QED_AFFIN_HWFN(cd=
ev),
> > +                                                   *handle);
> > +
> > +     return 0;
> > +}
> > +
> > +static int qed_nvmetcp_release_conn(struct qed_dev *cdev, u32 handle)
> > +{
> > +     struct qed_hash_nvmetcp_con *hash_con;
> > +
> > +     hash_con =3D qed_nvmetcp_get_hash(cdev, handle);
> > +     if (!hash_con) {
> > +             DP_NOTICE(cdev, "Failed to find connection for handle %d\=
n",
> > +                       handle);
> > +
> > +             return -EINVAL;
> > +     }
> > +
> > +     hlist_del(&hash_con->node);
> > +     qed_nvmetcp_release_connection(QED_AFFIN_HWFN(cdev), hash_con->co=
n);
> > +     kfree(hash_con);
> > +
> > +     return 0;
> > +}
> > +
> > +static int qed_nvmetcp_offload_conn(struct qed_dev *cdev, u32 handle,
> > +                                 struct qed_nvmetcp_params_offload *co=
nn_info)
> > +{
> > +     struct qed_hash_nvmetcp_con *hash_con;
> > +     struct qed_nvmetcp_conn *con;
> > +
> > +     hash_con =3D qed_nvmetcp_get_hash(cdev, handle);
> > +     if (!hash_con) {
> > +             DP_NOTICE(cdev, "Failed to find connection for handle %d\=
n",
> > +                       handle);
> > +
> > +             return -EINVAL;
> > +     }
> > +
> > +     /* Update the connection with information from the params */
> > +     con =3D hash_con->con;
> > +
> > +     /* FW initializations */
> > +     con->layer_code =3D NVMETCP_SLOW_PATH_LAYER_CODE;
> > +     con->sq_pbl_addr =3D conn_info->sq_pbl_addr;
> > +     con->nvmetcp_cccid_max_range =3D conn_info->nvmetcp_cccid_max_ran=
ge;
> > +     con->nvmetcp_cccid_itid_table_addr =3D conn_info->nvmetcp_cccid_i=
tid_table_addr;
> > +     con->default_cq =3D conn_info->default_cq;
> > +
> > +     SET_FIELD(con->offl_flags, NVMETCP_CONN_OFFLOAD_PARAMS_TARGET_MOD=
E, 0);
> > +     SET_FIELD(con->offl_flags, NVMETCP_CONN_OFFLOAD_PARAMS_NVMETCP_MO=
DE, 1);
> > +     SET_FIELD(con->offl_flags, NVMETCP_CONN_OFFLOAD_PARAMS_TCP_ON_CHI=
P_1B, 1);
> > +
> > +     /* Networking and TCP stack initializations */
> > +     ether_addr_copy(con->local_mac, conn_info->src.mac);
> > +     ether_addr_copy(con->remote_mac, conn_info->dst.mac);
> > +     memcpy(con->local_ip, conn_info->src.ip, sizeof(con->local_ip));
> > +     memcpy(con->remote_ip, conn_info->dst.ip, sizeof(con->remote_ip))=
;
> > +     con->local_port =3D conn_info->src.port;
> > +     con->remote_port =3D conn_info->dst.port;
> > +     con->vlan_id =3D conn_info->vlan_id;
> > +
> > +     if (conn_info->timestamp_en)
> > +             SET_FIELD(con->tcp_flags, TCP_OFFLOAD_PARAMS_OPT2_TS_EN, =
1);
> > +
> > +     if (conn_info->delayed_ack_en)
> > +             SET_FIELD(con->tcp_flags, TCP_OFFLOAD_PARAMS_OPT2_DA_EN, =
1);
> > +
> > +     if (conn_info->tcp_keep_alive_en)
> > +             SET_FIELD(con->tcp_flags, TCP_OFFLOAD_PARAMS_OPT2_KA_EN, =
1);
> > +
> > +     if (conn_info->ecn_en)
> > +             SET_FIELD(con->tcp_flags, TCP_OFFLOAD_PARAMS_OPT2_ECN_EN,=
 1);
> > +
> > +     con->ip_version =3D conn_info->ip_version;
> > +     con->flow_label =3D QED_TCP_FLOW_LABEL;
> > +     con->ka_max_probe_cnt =3D conn_info->ka_max_probe_cnt;
> > +     con->ka_timeout =3D conn_info->ka_timeout;
> > +     con->ka_interval =3D conn_info->ka_interval;
> > +     con->max_rt_time =3D conn_info->max_rt_time;
> > +     con->ttl =3D conn_info->ttl;
> > +     con->tos_or_tc =3D conn_info->tos_or_tc;
> > +     con->mss =3D conn_info->mss;
> > +     con->cwnd =3D conn_info->cwnd;
> > +     con->rcv_wnd_scale =3D conn_info->rcv_wnd_scale;
> > +     con->connect_mode =3D 0; /* TCP_CONNECT_ACTIVE */
> > +
> > +     return qed_sp_nvmetcp_conn_offload(QED_AFFIN_HWFN(cdev), con,
> > +                                      QED_SPQ_MODE_EBLOCK, NULL);
> > +}
> > +
> > +static int qed_nvmetcp_update_conn(struct qed_dev *cdev,
> > +                                u32 handle,
> > +                                struct qed_nvmetcp_params_update *conn=
_info)
> > +{
> > +     struct qed_hash_nvmetcp_con *hash_con;
> > +     struct qed_nvmetcp_conn *con;
> > +
> > +     hash_con =3D qed_nvmetcp_get_hash(cdev, handle);
> > +     if (!hash_con) {
> > +             DP_NOTICE(cdev, "Failed to find connection for handle %d\=
n",
> > +                       handle);
> > +
> > +             return -EINVAL;
> > +     }
> > +
> > +     /* Update the connection with information from the params */
> > +     con =3D hash_con->con;
> > +
> > +     SET_FIELD(con->update_flag,
> > +               ISCSI_CONN_UPDATE_RAMROD_PARAMS_INITIAL_R2T, 0);
> > +     SET_FIELD(con->update_flag,
> > +               ISCSI_CONN_UPDATE_RAMROD_PARAMS_IMMEDIATE_DATA, 1);
> > +
> > +     if (conn_info->hdr_digest_en)
> > +             SET_FIELD(con->update_flag, ISCSI_CONN_UPDATE_RAMROD_PARA=
MS_HD_EN, 1);
> > +
> > +     if (conn_info->data_digest_en)
> > +             SET_FIELD(con->update_flag, ISCSI_CONN_UPDATE_RAMROD_PARA=
MS_DD_EN, 1);
> > +
> > +     /* Placeholder - initialize pfv, cpda, hpda */
> > +
> > +     con->max_seq_size =3D conn_info->max_io_size;
> > +     con->max_recv_pdu_length =3D conn_info->max_recv_pdu_length;
> > +     con->max_send_pdu_length =3D conn_info->max_send_pdu_length;
> > +     con->first_seq_length =3D conn_info->max_io_size;
> > +
> > +     return qed_sp_nvmetcp_conn_update(QED_AFFIN_HWFN(cdev), con,
> > +                                     QED_SPQ_MODE_EBLOCK, NULL);
> > +}
> > +
> > +static int qed_nvmetcp_clear_conn_sq(struct qed_dev *cdev, u32 handle)
> > +{
> > +     struct qed_hash_nvmetcp_con *hash_con;
> > +
> > +     hash_con =3D qed_nvmetcp_get_hash(cdev, handle);
> > +     if (!hash_con) {
> > +             DP_NOTICE(cdev, "Failed to find connection for handle %d\=
n",
> > +                       handle);
> > +
> > +             return -EINVAL;
> > +     }
> > +
> > +     return qed_sp_nvmetcp_conn_clear_sq(QED_AFFIN_HWFN(cdev), hash_co=
n->con,
> > +                                         QED_SPQ_MODE_EBLOCK, NULL);
> > +}
> > +
> > +static int qed_nvmetcp_destroy_conn(struct qed_dev *cdev,
> > +                                 u32 handle, u8 abrt_conn)
> > +{
> > +     struct qed_hash_nvmetcp_con *hash_con;
> > +
> > +     hash_con =3D qed_nvmetcp_get_hash(cdev, handle);
> > +     if (!hash_con) {
> > +             DP_NOTICE(cdev, "Failed to find connection for handle %d\=
n",
> > +                       handle);
> > +
> > +             return -EINVAL;
> > +     }
> > +
> > +     hash_con->con->abortive_dsconnect =3D abrt_conn;
> > +
> > +     return qed_sp_nvmetcp_conn_terminate(QED_AFFIN_HWFN(cdev), hash_c=
on->con,
> > +                                        QED_SPQ_MODE_EBLOCK, NULL);
> > +}
> > +
> >   static const struct qed_nvmetcp_ops qed_nvmetcp_ops_pass =3D {
> >       .common =3D &qed_common_ops_pass,
> >       .ll2 =3D &qed_ll2_ops_pass,
> > @@ -266,8 +838,12 @@ static const struct qed_nvmetcp_ops qed_nvmetcp_op=
s_pass =3D {
> >       .register_ops =3D &qed_register_nvmetcp_ops,
> >       .start =3D &qed_nvmetcp_start,
> >       .stop =3D &qed_nvmetcp_stop,
> > -
> > -     /* Placeholder - Connection level ops */
> > +     .acquire_conn =3D &qed_nvmetcp_acquire_conn,
> > +     .release_conn =3D &qed_nvmetcp_release_conn,
> > +     .offload_conn =3D &qed_nvmetcp_offload_conn,
> > +     .update_conn =3D &qed_nvmetcp_update_conn,
> > +     .destroy_conn =3D &qed_nvmetcp_destroy_conn,
> > +     .clear_sq =3D &qed_nvmetcp_clear_conn_sq,
> >   };
> >
> >   const struct qed_nvmetcp_ops *qed_get_nvmetcp_ops(void)
> > diff --git a/drivers/net/ethernet/qlogic/qed/qed_nvmetcp.h b/drivers/ne=
t/ethernet/qlogic/qed/qed_nvmetcp.h
> > index 774b46ade408..749169f0bdb1 100644
> > --- a/drivers/net/ethernet/qlogic/qed/qed_nvmetcp.h
> > +++ b/drivers/net/ethernet/qlogic/qed/qed_nvmetcp.h
> > @@ -19,6 +19,7 @@
> >   #define QED_NVMETCP_FW_CQ_SIZE (4 * 1024)
> >
> >   /* tcp parameters */
> > +#define QED_TCP_FLOW_LABEL 0
> >   #define QED_TCP_TWO_MSL_TIMER 4000
> >   #define QED_TCP_HALF_WAY_CLOSE_TIMEOUT 10
> >   #define QED_TCP_MAX_FIN_RT 2
> > @@ -32,6 +33,68 @@ struct qed_nvmetcp_info {
> >       nvmetcp_event_cb_t event_cb;
> >   };
> >
> > +struct qed_hash_nvmetcp_con {
> > +     struct hlist_node node;
> > +     struct qed_nvmetcp_conn *con;
> > +};
> > +
> > +struct qed_nvmetcp_conn {
> > +     struct list_head list_entry;
> > +     bool free_on_delete;
> > +
> > +     u16 conn_id;
> > +     u32 icid;
> > +     u32 fw_cid;
> > +
> > +     u8 layer_code;
> > +     u8 offl_flags;
> > +     u8 connect_mode;
> > +
> > +     dma_addr_t sq_pbl_addr;
> > +     struct qed_chain r2tq;
> > +     struct qed_chain xhq;
> > +     struct qed_chain uhq;
> > +
> > +     u8 local_mac[6];
> > +     u8 remote_mac[6];
> > +     u8 ip_version;
> > +     u8 ka_max_probe_cnt;
> > +
> > +     u16 vlan_id;
> > +     u16 tcp_flags;
> > +     u32 remote_ip[4];
> > +     u32 local_ip[4];
> > +
> > +     u32 flow_label;
> > +     u32 ka_timeout;
> > +     u32 ka_interval;
> > +     u32 max_rt_time;
> > +
> > +     u8 ttl;
> > +     u8 tos_or_tc;
> > +     u16 remote_port;
> > +     u16 local_port;
> > +     u16 mss;
> > +     u8 rcv_wnd_scale;
> > +     u32 rcv_wnd;
> > +     u32 cwnd;
> > +
> > +     u8 update_flag;
> > +     u8 default_cq;
> > +     u8 abortive_dsconnect;
> > +
> > +     u32 max_seq_size;
> > +     u32 max_recv_pdu_length;
> > +     u32 max_send_pdu_length;
> > +     u32 first_seq_length;
> > +
> > +     u16 physical_q0;
> > +     u16 physical_q1;
> > +
> > +     u16 nvmetcp_cccid_max_range;
> > +     dma_addr_t nvmetcp_cccid_itid_table_addr;
> > +};
> > +
> >   #if IS_ENABLED(CONFIG_QED_NVMETCP)
> >   int qed_nvmetcp_alloc(struct qed_hwfn *p_hwfn);
> >   void qed_nvmetcp_setup(struct qed_hwfn *p_hwfn);
> > diff --git a/drivers/net/ethernet/qlogic/qed/qed_sp.h b/drivers/net/eth=
ernet/qlogic/qed/qed_sp.h
> > index 525159e747a5..60ff3222bf55 100644
> > --- a/drivers/net/ethernet/qlogic/qed/qed_sp.h
> > +++ b/drivers/net/ethernet/qlogic/qed/qed_sp.h
> > @@ -101,6 +101,9 @@ union ramrod_data {
> >       struct iscsi_spe_conn_termination iscsi_conn_terminate;
> >
> >       struct nvmetcp_init_ramrod_params nvmetcp_init;
> > +     struct nvmetcp_spe_conn_offload nvmetcp_conn_offload;
> > +     struct nvmetcp_conn_update_ramrod_params nvmetcp_conn_update;
> > +     struct nvmetcp_spe_conn_termination nvmetcp_conn_terminate;
> >
> >       struct vf_start_ramrod_data vf_start;
> >       struct vf_stop_ramrod_data vf_stop;
> > diff --git a/include/linux/qed/nvmetcp_common.h b/include/linux/qed/nvm=
etcp_common.h
> > index e9ccfc07041d..c8836b71b866 100644
> > --- a/include/linux/qed/nvmetcp_common.h
> > +++ b/include/linux/qed/nvmetcp_common.h
> > @@ -6,6 +6,8 @@
> >
> >   #include "tcp_common.h"
> >
> > +#define NVMETCP_SLOW_PATH_LAYER_CODE (6)
> > +
> >   /* NVMeTCP firmware function init parameters */
> >   struct nvmetcp_spe_func_init {
> >       __le16 half_way_close_timeout;
> > @@ -43,6 +45,10 @@ enum nvmetcp_ramrod_cmd_id {
> >       NVMETCP_RAMROD_CMD_ID_UNUSED =3D 0,
> >       NVMETCP_RAMROD_CMD_ID_INIT_FUNC =3D 1,
> >       NVMETCP_RAMROD_CMD_ID_DESTROY_FUNC =3D 2,
> > +     NVMETCP_RAMROD_CMD_ID_OFFLOAD_CONN =3D 3,
> > +     NVMETCP_RAMROD_CMD_ID_UPDATE_CONN =3D 4,
> > +     NVMETCP_RAMROD_CMD_ID_TERMINATION_CONN =3D 5,
> > +     NVMETCP_RAMROD_CMD_ID_CLEAR_SQ =3D 6,
> >       MAX_NVMETCP_RAMROD_CMD_ID
> >   };
> >
> > @@ -51,4 +57,141 @@ struct nvmetcp_glbl_queue_entry {
> >       struct regpair reserved;
> >   };
> >
> > +/* NVMeTCP conn level EQEs */
> > +enum nvmetcp_eqe_opcode {
> > +     NVMETCP_EVENT_TYPE_INIT_FUNC =3D 0, /* Response after init Ramrod=
 */
> > +     NVMETCP_EVENT_TYPE_DESTROY_FUNC, /* Response after destroy Ramrod=
 */
> > +     NVMETCP_EVENT_TYPE_OFFLOAD_CONN,/* Response after option 2 offloa=
d Ramrod */
> > +     NVMETCP_EVENT_TYPE_UPDATE_CONN, /* Response after update Ramrod *=
/
> > +     NVMETCP_EVENT_TYPE_CLEAR_SQ, /* Response after clear sq Ramrod */
> > +     NVMETCP_EVENT_TYPE_TERMINATE_CONN, /* Response after termination =
Ramrod */
> > +     NVMETCP_EVENT_TYPE_RESERVED0,
> > +     NVMETCP_EVENT_TYPE_RESERVED1,
> > +     NVMETCP_EVENT_TYPE_ASYN_CONNECT_COMPLETE, /* Connect completed (A=
-syn EQE) */
> > +     NVMETCP_EVENT_TYPE_ASYN_TERMINATE_DONE, /* Termination completed =
(A-syn EQE) */
> > +     NVMETCP_EVENT_TYPE_START_OF_ERROR_TYPES =3D 10, /* Separate EQs f=
rom err EQs */
> > +     NVMETCP_EVENT_TYPE_ASYN_ABORT_RCVD, /* TCP RST packet receive (A-=
syn EQE) */
> > +     NVMETCP_EVENT_TYPE_ASYN_CLOSE_RCVD, /* TCP FIN packet receive (A-=
syn EQE) */
> > +     NVMETCP_EVENT_TYPE_ASYN_SYN_RCVD, /* TCP SYN+ACK packet receive (=
A-syn EQE) */
> > +     NVMETCP_EVENT_TYPE_ASYN_MAX_RT_TIME, /* TCP max retransmit time (=
A-syn EQE) */
> > +     NVMETCP_EVENT_TYPE_ASYN_MAX_RT_CNT, /* TCP max retransmit count (=
A-syn EQE) */
> > +     NVMETCP_EVENT_TYPE_ASYN_MAX_KA_PROBES_CNT, /* TCP ka probes count=
 (A-syn EQE) */
> > +     NVMETCP_EVENT_TYPE_ASYN_FIN_WAIT2, /* TCP fin wait 2 (A-syn EQE) =
*/
> > +     NVMETCP_EVENT_TYPE_NVMETCP_CONN_ERROR, /* NVMeTCP error response =
(A-syn EQE) */
> > +     NVMETCP_EVENT_TYPE_TCP_CONN_ERROR, /* NVMeTCP error - tcp error (=
A-syn EQE) */
> > +     MAX_NVMETCP_EQE_OPCODE
> > +};
> > +
> > +struct nvmetcp_conn_offload_section {
> > +     struct regpair cccid_itid_table_addr; /* CCCID to iTID table addr=
ess */
> > +     __le16 cccid_max_range; /* CCCID max value - used for validation =
*/
> > +     __le16 reserved[3];
> > +};
> > +
> > +/* NVMe TCP connection offload params passed by driver to FW in NVMeTC=
P offload ramrod */
> > +struct nvmetcp_conn_offload_params {
> > +     struct regpair sq_pbl_addr;
> > +     struct regpair r2tq_pbl_addr;
> > +     struct regpair xhq_pbl_addr;
> > +     struct regpair uhq_pbl_addr;
> > +     __le16 physical_q0;
> > +     __le16 physical_q1;
> > +     u8 flags;
> > +#define NVMETCP_CONN_OFFLOAD_PARAMS_TCP_ON_CHIP_1B_MASK 0x1
> > +#define NVMETCP_CONN_OFFLOAD_PARAMS_TCP_ON_CHIP_1B_SHIFT 0
> > +#define NVMETCP_CONN_OFFLOAD_PARAMS_TARGET_MODE_MASK 0x1
> > +#define NVMETCP_CONN_OFFLOAD_PARAMS_TARGET_MODE_SHIFT 1
> > +#define NVMETCP_CONN_OFFLOAD_PARAMS_RESTRICTED_MODE_MASK 0x1
> > +#define NVMETCP_CONN_OFFLOAD_PARAMS_RESTRICTED_MODE_SHIFT 2
> > +#define NVMETCP_CONN_OFFLOAD_PARAMS_NVMETCP_MODE_MASK 0x1
> > +#define NVMETCP_CONN_OFFLOAD_PARAMS_NVMETCP_MODE_SHIFT 3
> > +#define NVMETCP_CONN_OFFLOAD_PARAMS_RESERVED1_MASK 0xF
> > +#define NVMETCP_CONN_OFFLOAD_PARAMS_RESERVED1_SHIFT 4
> > +     u8 default_cq;
> > +     __le16 reserved0;
> > +     __le32 reserved1;
> > +     __le32 initial_ack;
> > +
> > +     struct nvmetcp_conn_offload_section nvmetcp; /* NVMe/TCP section =
*/
> > +};
> > +
> > +/* NVMe TCP and TCP connection offload params passed by driver to FW i=
n NVMeTCP offload ramrod. */
> > +struct nvmetcp_spe_conn_offload {
> > +     __le16 reserved;
> > +     __le16 conn_id;
> > +     __le32 fw_cid;
> > +     struct nvmetcp_conn_offload_params nvmetcp;
> > +     struct tcp_offload_params_opt2 tcp;
> > +};
> > +
> > +/* NVMeTCP connection update params passed by driver to FW in NVMETCP =
update ramrod. */
> > +struct nvmetcp_conn_update_ramrod_params {
> > +     __le16 reserved0;
> > +     __le16 conn_id;
> > +     __le32 reserved1;
> > +     u8 flags;
> > +#define NVMETCP_CONN_UPDATE_RAMROD_PARAMS_HD_EN_MASK 0x1
> > +#define NVMETCP_CONN_UPDATE_RAMROD_PARAMS_HD_EN_SHIFT 0
> > +#define NVMETCP_CONN_UPDATE_RAMROD_PARAMS_DD_EN_MASK 0x1
> > +#define NVMETCP_CONN_UPDATE_RAMROD_PARAMS_DD_EN_SHIFT 1
> > +#define NVMETCP_CONN_UPDATE_RAMROD_PARAMS_RESERVED0_MASK 0x1
> > +#define NVMETCP_CONN_UPDATE_RAMROD_PARAMS_RESERVED0_SHIFT 2
> > +#define NVMETCP_CONN_UPDATE_RAMROD_PARAMS_RESERVED1_MASK 0x1
> > +#define NVMETCP_CONN_UPDATE_RAMROD_PARAMS_RESERVED1_DATA_SHIFT 3
> > +#define NVMETCP_CONN_UPDATE_RAMROD_PARAMS_RESERVED2_MASK 0x1
> > +#define NVMETCP_CONN_UPDATE_RAMROD_PARAMS_RESERVED2_SHIFT 4
> > +#define NVMETCP_CONN_UPDATE_RAMROD_PARAMS_RESERVED3_MASK 0x1
> > +#define NVMETCP_CONN_UPDATE_RAMROD_PARAMS_RESERVED3_SHIFT 5
> > +#define NVMETCP_CONN_UPDATE_RAMROD_PARAMS_RESERVED4_MASK 0x1
> > +#define NVMETCP_CONN_UPDATE_RAMROD_PARAMS_RESERVED4_SHIFT 6
> > +#define NVMETCP_CONN_UPDATE_RAMROD_PARAMS_RESERVED5_MASK 0x1
> > +#define NVMETCP_CONN_UPDATE_RAMROD_PARAMS_RESERVED5_SHIFT 7
> > +     u8 reserved3[3];
> > +     __le32 max_seq_size;
> > +     __le32 max_send_pdu_length;
> > +     __le32 max_recv_pdu_length;
> > +     __le32 first_seq_length;
> > +     __le32 reserved4[5];
> > +};
> > +
> > +/* NVMeTCP connection termination request */
> > +struct nvmetcp_spe_conn_termination {
> > +     __le16 reserved0;
> > +     __le16 conn_id;
> > +     __le32 reserved1;
> > +     u8 abortive;
> > +     u8 reserved2[7];
> > +     struct regpair reserved3;
> > +     struct regpair reserved4;
> > +};
> > +
> > +struct nvmetcp_dif_flags {
> > +     u8 flags;
> > +};
> > +
> > +enum nvmetcp_wqe_type {
> > +     NVMETCP_WQE_TYPE_NORMAL,
> > +     NVMETCP_WQE_TYPE_TASK_CLEANUP,
> > +     NVMETCP_WQE_TYPE_MIDDLE_PATH,
> > +     NVMETCP_WQE_TYPE_IC,
> > +     MAX_NVMETCP_WQE_TYPE
> > +};
> > +
> > +struct nvmetcp_wqe {
> > +     __le16 task_id;
> > +     u8 flags;
> > +#define NVMETCP_WQE_WQE_TYPE_MASK 0x7 /* [use nvmetcp_wqe_type] */
> > +#define NVMETCP_WQE_WQE_TYPE_SHIFT 0
> > +#define NVMETCP_WQE_NUM_SGES_MASK 0xF
> > +#define NVMETCP_WQE_NUM_SGES_SHIFT 3
> > +#define NVMETCP_WQE_RESPONSE_MASK 0x1
> > +#define NVMETCP_WQE_RESPONSE_SHIFT 7
> > +     struct nvmetcp_dif_flags prot_flags;
> > +     __le32 contlen_cdbsize;
> > +#define NVMETCP_WQE_CONT_LEN_MASK 0xFFFFFF
> > +#define NVMETCP_WQE_CONT_LEN_SHIFT 0
> > +#define NVMETCP_WQE_CDB_SIZE_OR_NVMETCP_CMD_MASK 0xFF
> > +#define NVMETCP_WQE_CDB_SIZE_OR_NVMETCP_CMD_SHIFT 24
> > +};
> > +
> >   #endif /* __NVMETCP_COMMON__ */
> > diff --git a/include/linux/qed/qed_nvmetcp_if.h b/include/linux/qed/qed=
_nvmetcp_if.h
> > index abc1f41862e3..96263e3cfa1e 100644
> > --- a/include/linux/qed/qed_nvmetcp_if.h
> > +++ b/include/linux/qed/qed_nvmetcp_if.h
> > @@ -25,6 +25,50 @@ struct qed_nvmetcp_tid {
> >       u8 *blocks[MAX_TID_BLOCKS_NVMETCP];
> >   };
> >
> > +struct qed_nvmetcp_id_params {
> > +     u8 mac[ETH_ALEN];
> > +     u32 ip[4];
> > +     u16 port;
> > +};
> > +
> > +struct qed_nvmetcp_params_offload {
> > +     /* FW initializations */
> > +     dma_addr_t sq_pbl_addr;
> > +     dma_addr_t nvmetcp_cccid_itid_table_addr;
> > +     u16 nvmetcp_cccid_max_range;
> > +     u8 default_cq;
> > +
> > +     /* Networking and TCP stack initializations */
> > +     struct qed_nvmetcp_id_params src;
> > +     struct qed_nvmetcp_id_params dst;
> > +     u32 ka_timeout;
> > +     u32 ka_interval;
> > +     u32 max_rt_time;
> > +     u32 cwnd;
> > +     u16 mss;
> > +     u16 vlan_id;
> > +     bool timestamp_en;
> > +     bool delayed_ack_en;
> > +     bool tcp_keep_alive_en;
> > +     bool ecn_en;
> > +     u8 ip_version;
> > +     u8 ka_max_probe_cnt;
> > +     u8 ttl;
> > +     u8 tos_or_tc;
> > +     u8 rcv_wnd_scale;
> > +};
> > +
> > +struct qed_nvmetcp_params_update {
> > +     u32 max_io_size;
> > +     u32 max_recv_pdu_length;
> > +     u32 max_send_pdu_length;
> > +
> > +     /* Placeholder: pfv, cpda, hpda */
> > +
> > +     bool hdr_digest_en;
> > +     bool data_digest_en;
> > +};
> > +
> >   struct qed_nvmetcp_cb_ops {
> >       struct qed_common_cb_ops common;
> >   };
> > @@ -48,6 +92,38 @@ struct qed_nvmetcp_cb_ops {
> >    * @stop:           nvmetcp in FW
> >    *                  @param cdev
> >    *                  return 0 on success, otherwise error value.
> > + * @acquire_conn:    acquire a new nvmetcp connection
> > + *                   @param cdev
> > + *                   @param handle - qed will fill handle that should =
be
> > + *                           used henceforth as identifier of the
> > + *                           connection.
> > + *                   @param p_doorbell - qed will fill the address of =
the
> > + *                           doorbell.
> > + *                   @return 0 on sucesss, otherwise error value.
> > + * @release_conn:    release a previously acquired nvmetcp connection
> > + *                   @param cdev
> > + *                   @param handle - the connection handle.
> > + *                   @return 0 on success, otherwise error value.
> > + * @offload_conn:    configures an offloaded connection
> > + *                   @param cdev
> > + *                   @param handle - the connection handle.
> > + *                   @param conn_info - the configuration to use for t=
he
> > + *                           offload.
> > + *                   @return 0 on success, otherwise error value.
> > + * @update_conn:     updates an offloaded connection
> > + *                   @param cdev
> > + *                   @param handle - the connection handle.
> > + *                   @param conn_info - the configuration to use for t=
he
> > + *                           offload.
> > + *                   @return 0 on success, otherwise error value.
> > + * @destroy_conn:    stops an offloaded connection
> > + *                   @param cdev
> > + *                   @param handle - the connection handle.
> > + *                   @return 0 on success, otherwise error value.
> > + * @clear_sq:                clear all task in sq
> > + *                   @param cdev
> > + *                   @param handle - the connection handle.
> > + *                   @return 0 on success, otherwise error value.
> >    */
> >   struct qed_nvmetcp_ops {
> >       const struct qed_common_ops *common;
> > @@ -65,6 +141,24 @@ struct qed_nvmetcp_ops {
> >                    void *event_context, nvmetcp_event_cb_t async_event_=
cb);
> >
> >       int (*stop)(struct qed_dev *cdev);
> > +
> > +     int (*acquire_conn)(struct qed_dev *cdev,
> > +                         u32 *handle,
> > +                         u32 *fw_cid, void __iomem **p_doorbell);
> > +
> > +     int (*release_conn)(struct qed_dev *cdev, u32 handle);
> > +
> > +     int (*offload_conn)(struct qed_dev *cdev,
> > +                         u32 handle,
> > +                         struct qed_nvmetcp_params_offload *conn_info)=
;
> > +
> > +     int (*update_conn)(struct qed_dev *cdev,
> > +                        u32 handle,
> > +                        struct qed_nvmetcp_params_update *conn_info);
> > +
> > +     int (*destroy_conn)(struct qed_dev *cdev, u32 handle, u8 abrt_con=
n);
> > +
> > +     int (*clear_sq)(struct qed_dev *cdev, u32 handle);
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
