Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD2F3717FB
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 17:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230460AbhECP1s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 11:27:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230122AbhECP1q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 May 2021 11:27:46 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 535D9C06174A
        for <netdev@vger.kernel.org>; Mon,  3 May 2021 08:26:53 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id w3so8485691ejc.4
        for <netdev@vger.kernel.org>; Mon, 03 May 2021 08:26:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=yK10Qbxhi0DdjRSF+/c60IeX9meswy035oCz2BvnHB0=;
        b=kjkycvzaniz3s6qoTU3GI7gsmjiMMtPvDvv20+sz50k1fiPoporiclDKXMABEDj8yf
         pPAMzdUqbShMG33u17j3rmDEXFWOfeGBN6ZbILe6xK09Y9CnztwQpEvN279FCtFT1oEY
         6mBopj0CAvn7QVXabydaYAfxLlPVdYYMuSICZA8FoNT9CVN5LSEgYQCzj1eVLPozrxEc
         UXCQaPNEh1PErQRmmDE2xy6WMrnIjCd+Y5ImpWRwAwWCn752EEbMK/PmykQkC6GyC1xJ
         vUEcZmBd6eyxZyfk22cIruGYEgWEBm3swWDsQc0YGoyIZO94clM86b0A8qTn+gk3EQZ+
         bW7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=yK10Qbxhi0DdjRSF+/c60IeX9meswy035oCz2BvnHB0=;
        b=uCBsFhUgUmsHWGz60DxfLwVcvcDxdu36onh+ThAm3Uy8LP6n56v6dUA1BBHMFR20qv
         x98Rmr+kaxq9dhnabc4jEcghx3MEGu7kk3U6rbQqfN1E2+OOLqVXbZuDRrOyQluTowvD
         oexQinwjfDtD7F11s73N/RCZQmJmnllVv6tG1mQDY4AMqYdDRFzqD0dJo7V8aMYfG8jm
         1PqyOWPQen+b5inhoy2KXtZ0kJrFKm3c3oeHF//Fbcl9cqhgrN1Q0Cp0w9zRcrQeBetF
         fKG5tDeW8GXBhy5CmVstY4miDa9CGYqp9wJWPllI3BigXvQKteDEAezRV3dDUs/DXKS3
         iwBw==
X-Gm-Message-State: AOAM5336AJ5hkYWvB11usFvf+K3kLJBoSEgAjpwqqx23ViN683X3xQvR
        MzR9U1Hv2O7+ZkjoxyKuR3BNXynMgbgm3NM2GL81vCjt7ek=
X-Google-Smtp-Source: ABdhPJze5QdEmDSEShr4+U/AgFr1anfp9rXY2mZSKWAm0N8738DcgtB4u8QRqWo7yhrSJhrUcFmpSxnxCzV95dFGBus=
X-Received: by 2002:a17:906:7806:: with SMTP id u6mr16333334ejm.130.1620055610885;
 Mon, 03 May 2021 08:26:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210429190926.5086-1-smalin@marvell.com> <20210429190926.5086-4-smalin@marvell.com>
 <6b933b6e-684a-fc58-8db6-4404806ab114@suse.de>
In-Reply-To: <6b933b6e-684a-fc58-8db6-4404806ab114@suse.de>
From:   Shai Malin <malin1024@gmail.com>
Date:   Mon, 3 May 2021 18:26:39 +0300
Message-ID: <CAKKgK4x5Q1Y+qgkx55629BkFn=TNZDQGqNajaJ-EPVM6BXb6Sg@mail.gmail.com>
Subject: Re: [RFC PATCH v4 03/27] qed: Add qed-NVMeTCP personality
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

On 5/1/21 2:11 PM, Hannes Reinecke wrote:
> On 4/29/21 9:09 PM, Shai Malin wrote:
> > From: Omkar Kulkarni <okulkarni@marvell.com>
> >
> > This patch adds qed NVMeTCP personality in order to support the NVMeTCP
> > qed functionalities and manage the HW device shared resources.
> > The same design is used with Eth (qede), RDMA(qedr), iSCSI (qedi) and
> > FCoE (qedf).
> >
> > Acked-by: Igor Russkikh <irusskikh@marvell.com>
> > Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> > Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
> > Signed-off-by: Shai Malin <smalin@marvell.com>
> > Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
> > Signed-off-by: Ariel Elior <aelior@marvell.com>
> > ---
> >   drivers/net/ethernet/qlogic/qed/qed.h         |  3 ++
> >   drivers/net/ethernet/qlogic/qed/qed_cxt.c     | 32 ++++++++++++++
> >   drivers/net/ethernet/qlogic/qed/qed_cxt.h     |  1 +
> >   drivers/net/ethernet/qlogic/qed/qed_dev.c     | 44 ++++++++++++++++--=
-
> >   drivers/net/ethernet/qlogic/qed/qed_hsi.h     |  3 +-
> >   drivers/net/ethernet/qlogic/qed/qed_ll2.c     | 31 ++++++++-----
> >   drivers/net/ethernet/qlogic/qed/qed_mcp.c     |  3 ++
> >   drivers/net/ethernet/qlogic/qed/qed_mng_tlv.c |  3 +-
> >   drivers/net/ethernet/qlogic/qed/qed_ooo.c     |  5 ++-
> >   .../net/ethernet/qlogic/qed/qed_sp_commands.c |  1 +
> >   10 files changed, 108 insertions(+), 18 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/qlogic/qed/qed.h b/drivers/net/ethern=
et/qlogic/qed/qed.h
> > index 91d4635009ab..7ae648c4edba 100644
> > --- a/drivers/net/ethernet/qlogic/qed/qed.h
> > +++ b/drivers/net/ethernet/qlogic/qed/qed.h
> > @@ -200,6 +200,7 @@ enum qed_pci_personality {
> >       QED_PCI_ETH,
> >       QED_PCI_FCOE,
> >       QED_PCI_ISCSI,
> > +     QED_PCI_NVMETCP,
> >       QED_PCI_ETH_ROCE,
> >       QED_PCI_ETH_IWARP,
> >       QED_PCI_ETH_RDMA,
> > @@ -285,6 +286,8 @@ struct qed_hw_info {
> >       ((dev)->hw_info.personality =3D=3D QED_PCI_FCOE)
> >   #define QED_IS_ISCSI_PERSONALITY(dev)                                =
       \
> >       ((dev)->hw_info.personality =3D=3D QED_PCI_ISCSI)
> > +#define QED_IS_NVMETCP_PERSONALITY(dev)                               =
       \
> > +     ((dev)->hw_info.personality =3D=3D QED_PCI_NVMETCP)
> >
> So you have a distinct PCI personality for NVMe-oF, but not for the
> protocol? Strange.
> Why don't you have a distinct NVMe-oF protocol ID?
>
> >       /* Resource Allocation scheme results */
> >       u32                             resc_start[QED_MAX_RESC];
> > diff --git a/drivers/net/ethernet/qlogic/qed/qed_cxt.c b/drivers/net/et=
hernet/qlogic/qed/qed_cxt.c
> > index 0a22f8ce9a2c..6cef75723e38 100644
> > --- a/drivers/net/ethernet/qlogic/qed/qed_cxt.c
> > +++ b/drivers/net/ethernet/qlogic/qed/qed_cxt.c
> > @@ -2106,6 +2106,30 @@ int qed_cxt_set_pf_params(struct qed_hwfn *p_hwf=
n, u32 rdma_tasks)
> >               }
> >               break;
> >       }
> > +     case QED_PCI_NVMETCP:
> > +     {
> > +             struct qed_nvmetcp_pf_params *p_params;
> > +
> > +             p_params =3D &p_hwfn->pf_params.nvmetcp_pf_params;
> > +
> > +             if (p_params->num_cons && p_params->num_tasks) {
> > +                     qed_cxt_set_proto_cid_count(p_hwfn,
> > +                                                 PROTOCOLID_NVMETCP,
> > +                                                 p_params->num_cons,
> > +                                                 0);
> > +
> > +                     qed_cxt_set_proto_tid_count(p_hwfn,
> > +                                                 PROTOCOLID_NVMETCP,
> > +                                                 QED_CTX_NVMETCP_TID_S=
EG,
> > +                                                 0,
> > +                                                 p_params->num_tasks,
> > +                                                 true);
> > +             } else {
> > +                     DP_INFO(p_hwfn->cdev,
> > +                             "NvmeTCP personality used without setting=
 params!\n");
> > +             }
> > +             break;
> > +     }
> >       default:
> >               return -EINVAL;
> >       }
> > @@ -2132,6 +2156,10 @@ int qed_cxt_get_tid_mem_info(struct qed_hwfn *p_=
hwfn,
> >               proto =3D PROTOCOLID_ISCSI;
> >               seg =3D QED_CXT_ISCSI_TID_SEG;
> >               break;
> > +     case QED_PCI_NVMETCP:
> > +             proto =3D PROTOCOLID_NVMETCP;
> > +             seg =3D QED_CTX_NVMETCP_TID_SEG;
> > +             break;
> >       default:
> >               return -EINVAL;
> >       }
> > @@ -2458,6 +2486,10 @@ int qed_cxt_get_task_ctx(struct qed_hwfn *p_hwfn=
,
> >               proto =3D PROTOCOLID_ISCSI;
> >               seg =3D QED_CXT_ISCSI_TID_SEG;
> >               break;
> > +     case QED_PCI_NVMETCP:
> > +             proto =3D PROTOCOLID_NVMETCP;
> > +             seg =3D QED_CTX_NVMETCP_TID_SEG;
> > +             break;
> >       default:
> >               return -EINVAL;
> >       }
> > diff --git a/drivers/net/ethernet/qlogic/qed/qed_cxt.h b/drivers/net/et=
hernet/qlogic/qed/qed_cxt.h
> > index 056e79620a0e..8f1a77cb33f6 100644
> > --- a/drivers/net/ethernet/qlogic/qed/qed_cxt.h
> > +++ b/drivers/net/ethernet/qlogic/qed/qed_cxt.h
> > @@ -51,6 +51,7 @@ int qed_cxt_get_tid_mem_info(struct qed_hwfn *p_hwfn,
> >                            struct qed_tid_mem *p_info);
> >
> >   #define QED_CXT_ISCSI_TID_SEG       PROTOCOLID_ISCSI
> > +#define QED_CTX_NVMETCP_TID_SEG PROTOCOLID_NVMETCP
> >   #define QED_CXT_ROCE_TID_SEG        PROTOCOLID_ROCE
> >   #define QED_CXT_FCOE_TID_SEG        PROTOCOLID_FCOE
> >   enum qed_cxt_elem_type {
> > diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev.c b/drivers/net/et=
hernet/qlogic/qed/qed_dev.c
> > index d2f5855b2ea7..d3f8cc42d07e 100644
> > --- a/drivers/net/ethernet/qlogic/qed/qed_dev.c
> > +++ b/drivers/net/ethernet/qlogic/qed/qed_dev.c
> > @@ -37,6 +37,7 @@
> >   #include "qed_sriov.h"
> >   #include "qed_vf.h"
> >   #include "qed_rdma.h"
> > +#include "qed_nvmetcp.h"
> >
> >   static DEFINE_SPINLOCK(qm_lock);
> >
> > @@ -667,7 +668,8 @@ qed_llh_set_engine_affin(struct qed_hwfn *p_hwfn, s=
truct qed_ptt *p_ptt)
> >       }
> >
> >       /* Storage PF is bound to a single engine while L2 PF uses both *=
/
> > -     if (QED_IS_FCOE_PERSONALITY(p_hwfn) || QED_IS_ISCSI_PERSONALITY(p=
_hwfn))
> > +     if (QED_IS_FCOE_PERSONALITY(p_hwfn) || QED_IS_ISCSI_PERSONALITY(p=
_hwfn) ||
> > +         QED_IS_NVMETCP_PERSONALITY(p_hwfn))
> >               eng =3D cdev->fir_affin ? QED_ENG1 : QED_ENG0;
> >       else                    /* L2_PERSONALITY */
> >               eng =3D QED_BOTH_ENG;
> > @@ -1164,6 +1166,9 @@ void qed_llh_remove_mac_filter(struct qed_dev *cd=
ev,
> >       if (!test_bit(QED_MF_LLH_MAC_CLSS, &cdev->mf_bits))
> >               goto out;
> >
> > +     if (QED_IS_NVMETCP_PERSONALITY(p_hwfn))
> > +             return;
> > +
> >       ether_addr_copy(filter.mac.addr, mac_addr);
> >       rc =3D qed_llh_shadow_remove_filter(cdev, ppfid, &filter, &filter=
_idx,
> >                                         &ref_cnt);
> > @@ -1381,6 +1386,11 @@ void qed_resc_free(struct qed_dev *cdev)
> >                       qed_ooo_free(p_hwfn);
> >               }
> >
> > +             if (p_hwfn->hw_info.personality =3D=3D QED_PCI_NVMETCP) {
> > +                     qed_nvmetcp_free(p_hwfn);
> > +                     qed_ooo_free(p_hwfn);
> > +             }
> > +
> >               if (QED_IS_RDMA_PERSONALITY(p_hwfn) && rdma_info) {
> >                       qed_spq_unregister_async_cb(p_hwfn, rdma_info->pr=
oto);
> >                       qed_rdma_info_free(p_hwfn);
> > @@ -1423,6 +1433,7 @@ static u32 qed_get_pq_flags(struct qed_hwfn *p_hw=
fn)
> >               flags |=3D PQ_FLAGS_OFLD;
> >               break;
> >       case QED_PCI_ISCSI:
> > +     case QED_PCI_NVMETCP:
> >               flags |=3D PQ_FLAGS_ACK | PQ_FLAGS_OOO | PQ_FLAGS_OFLD;
> >               break;
> >       case QED_PCI_ETH_ROCE:
> > @@ -2269,6 +2280,12 @@ int qed_resc_alloc(struct qed_dev *cdev)
> >                                                       PROTOCOLID_ISCSI,
> >                                                       NULL);
> >                       n_eqes +=3D 2 * num_cons;
> > +             } else if (p_hwfn->hw_info.personality =3D=3D QED_PCI_NVM=
ETCP) {
> > +                     num_cons =3D
> > +                         qed_cxt_get_proto_cid_count(p_hwfn,
> > +                                                     PROTOCOLID_NVMETC=
P,
> > +                                                     NULL);
> > +                     n_eqes +=3D 2 * num_cons;
> >               }
> >
> >               if (n_eqes > 0xFFFF) {
> > @@ -2313,6 +2330,15 @@ int qed_resc_alloc(struct qed_dev *cdev)
> >                               goto alloc_err;
> >               }
> >
> > +             if (p_hwfn->hw_info.personality =3D=3D QED_PCI_NVMETCP) {
> > +                     rc =3D qed_nvmetcp_alloc(p_hwfn);
> > +                     if (rc)
> > +                             goto alloc_err;
> > +                     rc =3D qed_ooo_alloc(p_hwfn);
> > +                     if (rc)
> > +                             goto alloc_err;
> > +             }
> > +
> >               if (QED_IS_RDMA_PERSONALITY(p_hwfn)) {
> >                       rc =3D qed_rdma_info_alloc(p_hwfn);
> >                       if (rc)
> > @@ -2393,6 +2419,11 @@ void qed_resc_setup(struct qed_dev *cdev)
> >                       qed_iscsi_setup(p_hwfn);
> >                       qed_ooo_setup(p_hwfn);
> >               }
> > +
> > +             if (p_hwfn->hw_info.personality =3D=3D QED_PCI_NVMETCP) {
> > +                     qed_nvmetcp_setup(p_hwfn);
> > +                     qed_ooo_setup(p_hwfn);
> > +             }
> >       }
> >   }
> >
> > @@ -2854,7 +2885,8 @@ static int qed_hw_init_pf(struct qed_hwfn *p_hwfn=
,
> >
> >       /* Protocol Configuration */
> >       STORE_RT_REG(p_hwfn, PRS_REG_SEARCH_TCP_RT_OFFSET,
> > -                  (p_hwfn->hw_info.personality =3D=3D QED_PCI_ISCSI) ?=
 1 : 0);
> > +                  ((p_hwfn->hw_info.personality =3D=3D QED_PCI_ISCSI) =
||
> > +                      (p_hwfn->hw_info.personality =3D=3D QED_PCI_NVME=
TCP)) ? 1 : 0);
> >       STORE_RT_REG(p_hwfn, PRS_REG_SEARCH_FCOE_RT_OFFSET,
> >                    (p_hwfn->hw_info.personality =3D=3D QED_PCI_FCOE) ? =
1 : 0);
> >       STORE_RT_REG(p_hwfn, PRS_REG_SEARCH_ROCE_RT_OFFSET, 0);
> > @@ -3531,7 +3563,7 @@ static void qed_hw_set_feat(struct qed_hwfn *p_hw=
fn)
> >                                              RESC_NUM(p_hwfn,
> >                                                       QED_CMDQS_CQS));
> >
> > -     if (QED_IS_ISCSI_PERSONALITY(p_hwfn))
> > +     if (QED_IS_ISCSI_PERSONALITY(p_hwfn) || QED_IS_NVMETCP_PERSONALIT=
Y(p_hwfn))
> >               feat_num[QED_ISCSI_CQ] =3D min_t(u32, sb_cnt.cnt,
> >                                              RESC_NUM(p_hwfn,
> >                                                       QED_CMDQS_CQS));
> > @@ -3734,7 +3766,8 @@ int qed_hw_get_dflt_resc(struct qed_hwfn *p_hwfn,
> >               break;
> >       case QED_BDQ:
> >               if (p_hwfn->hw_info.personality !=3D QED_PCI_ISCSI &&
> > -                 p_hwfn->hw_info.personality !=3D QED_PCI_FCOE)
> > +                 p_hwfn->hw_info.personality !=3D QED_PCI_FCOE &&
> > +                     p_hwfn->hw_info.personality !=3D QED_PCI_NVMETCP)
> >                       *p_resc_num =3D 0;
> >               else
> >                       *p_resc_num =3D 1;
> > @@ -3755,7 +3788,8 @@ int qed_hw_get_dflt_resc(struct qed_hwfn *p_hwfn,
> >                       *p_resc_start =3D 0;
> >               else if (p_hwfn->cdev->num_ports_in_engine =3D=3D 4)
> >                       *p_resc_start =3D p_hwfn->port_id;
> > -             else if (p_hwfn->hw_info.personality =3D=3D QED_PCI_ISCSI=
)
> > +             else if (p_hwfn->hw_info.personality =3D=3D QED_PCI_ISCSI=
 ||
> > +                      p_hwfn->hw_info.personality =3D=3D QED_PCI_NVMET=
CP)
> >                       *p_resc_start =3D p_hwfn->port_id;
> >               else if (p_hwfn->hw_info.personality =3D=3D QED_PCI_FCOE)
> >                       *p_resc_start =3D p_hwfn->port_id + 2;
> > diff --git a/drivers/net/ethernet/qlogic/qed/qed_hsi.h b/drivers/net/et=
hernet/qlogic/qed/qed_hsi.h
> > index 24472f6a83c2..9c9ec8f53ef8 100644
> > --- a/drivers/net/ethernet/qlogic/qed/qed_hsi.h
> > +++ b/drivers/net/ethernet/qlogic/qed/qed_hsi.h
> > @@ -12148,7 +12148,8 @@ struct public_func {
> >   #define FUNC_MF_CFG_PROTOCOL_ISCSI              0x00000010
> >   #define FUNC_MF_CFG_PROTOCOL_FCOE               0x00000020
> >   #define FUNC_MF_CFG_PROTOCOL_ROCE               0x00000030
> > -#define FUNC_MF_CFG_PROTOCOL_MAX     0x00000030
> > +#define FUNC_MF_CFG_PROTOCOL_NVMETCP    0x00000040
> > +#define FUNC_MF_CFG_PROTOCOL_MAX     0x00000040
> >
> >   #define FUNC_MF_CFG_MIN_BW_MASK             0x0000ff00
> >   #define FUNC_MF_CFG_MIN_BW_SHIFT    8
> > diff --git a/drivers/net/ethernet/qlogic/qed/qed_ll2.c b/drivers/net/et=
hernet/qlogic/qed/qed_ll2.c
> > index 49783f365079..88bfcdcd4a4c 100644
> > --- a/drivers/net/ethernet/qlogic/qed/qed_ll2.c
> > +++ b/drivers/net/ethernet/qlogic/qed/qed_ll2.c
> > @@ -960,7 +960,8 @@ static int qed_sp_ll2_rx_queue_start(struct qed_hwf=
n *p_hwfn,
> >
> >       if (test_bit(QED_MF_LL2_NON_UNICAST, &p_hwfn->cdev->mf_bits) &&
> >           p_ramrod->main_func_queue && conn_type !=3D QED_LL2_TYPE_ROCE=
 &&
> > -         conn_type !=3D QED_LL2_TYPE_IWARP) {
> > +         conn_type !=3D QED_LL2_TYPE_IWARP &&
> > +             (!QED_IS_NVMETCP_PERSONALITY(p_hwfn))) {
> >               p_ramrod->mf_si_bcast_accept_all =3D 1;
> >               p_ramrod->mf_si_mcast_accept_all =3D 1;
> >       } else {
> > @@ -1049,6 +1050,8 @@ static int qed_sp_ll2_tx_queue_start(struct qed_h=
wfn *p_hwfn,
> >       case QED_LL2_TYPE_OOO:
> >               if (p_hwfn->hw_info.personality =3D=3D QED_PCI_ISCSI)
> >                       p_ramrod->conn_type =3D PROTOCOLID_ISCSI;
> > +             else if (p_hwfn->hw_info.personality =3D=3D QED_PCI_NVMET=
CP)
> > +                     p_ramrod->conn_type =3D PROTOCOLID_NVMETCP;
> >               else
> >                       p_ramrod->conn_type =3D PROTOCOLID_IWARP;
> >               break;
> > @@ -1634,7 +1637,8 @@ int qed_ll2_establish_connection(void *cxt, u8 co=
nnection_handle)
> >       if (rc)
> >               goto out;
> >
> > -     if (!QED_IS_RDMA_PERSONALITY(p_hwfn))
> > +     if (!QED_IS_RDMA_PERSONALITY(p_hwfn) &&
> > +         !QED_IS_NVMETCP_PERSONALITY(p_hwfn))
> >               qed_wr(p_hwfn, p_ptt, PRS_REG_USE_LIGHT_L2, 1);
> >
> >       qed_ll2_establish_connection_ooo(p_hwfn, p_ll2_conn);
> > @@ -2376,7 +2380,8 @@ static int qed_ll2_start_ooo(struct qed_hwfn *p_h=
wfn,
> >   static bool qed_ll2_is_storage_eng1(struct qed_dev *cdev)
> >   {
> >       return (QED_IS_FCOE_PERSONALITY(QED_LEADING_HWFN(cdev)) ||
> > -             QED_IS_ISCSI_PERSONALITY(QED_LEADING_HWFN(cdev))) &&
> > +             QED_IS_ISCSI_PERSONALITY(QED_LEADING_HWFN(cdev)) ||
> > +             QED_IS_NVMETCP_PERSONALITY(QED_LEADING_HWFN(cdev))) &&
> >               (QED_AFFIN_HWFN(cdev) !=3D QED_LEADING_HWFN(cdev));
> >   }
> >
> > @@ -2402,11 +2407,13 @@ static int qed_ll2_stop(struct qed_dev *cdev)
> >
> >       if (cdev->ll2->handle =3D=3D QED_LL2_UNUSED_HANDLE)
> >               return 0;
> > +     if (!QED_IS_NVMETCP_PERSONALITY(p_hwfn))
> > +             qed_llh_remove_mac_filter(cdev, 0, cdev->ll2_mac_address)=
;
> >
> >       qed_llh_remove_mac_filter(cdev, 0, cdev->ll2_mac_address);
> >       eth_zero_addr(cdev->ll2_mac_address);
> >
> > -     if (QED_IS_ISCSI_PERSONALITY(p_hwfn))
> > +     if (QED_IS_ISCSI_PERSONALITY(p_hwfn) || QED_IS_NVMETCP_PERSONALIT=
Y(p_hwfn))
> >               qed_ll2_stop_ooo(p_hwfn);
> >
> >       /* In CMT mode, LL2 is always started on engine 0 for a storage P=
F */
> > @@ -2442,6 +2449,7 @@ static int __qed_ll2_start(struct qed_hwfn *p_hwf=
n,
> >               conn_type =3D QED_LL2_TYPE_FCOE;
> >               break;
> >       case QED_PCI_ISCSI:
> > +     case QED_PCI_NVMETCP:
> >               conn_type =3D QED_LL2_TYPE_ISCSI;
> >               break;
> >       case QED_PCI_ETH_ROCE:
> > @@ -2567,7 +2575,7 @@ static int qed_ll2_start(struct qed_dev *cdev, st=
ruct qed_ll2_params *params)
> >               }
> >       }
> >
> > -     if (QED_IS_ISCSI_PERSONALITY(p_hwfn)) {
> > +     if (QED_IS_ISCSI_PERSONALITY(p_hwfn) || QED_IS_NVMETCP_PERSONALIT=
Y(p_hwfn)) {
> >               DP_VERBOSE(cdev, QED_MSG_STORAGE, "Starting OOO LL2 queue=
\n");
> >               rc =3D qed_ll2_start_ooo(p_hwfn, params);
> >               if (rc) {
> > @@ -2576,10 +2584,13 @@ static int qed_ll2_start(struct qed_dev *cdev, =
struct qed_ll2_params *params)
> >               }
> >       }
> >
> > -     rc =3D qed_llh_add_mac_filter(cdev, 0, params->ll2_mac_address);
> > -     if (rc) {
> > -             DP_NOTICE(cdev, "Failed to add an LLH filter\n");
> > -             goto err3;
> > +     if (!QED_IS_NVMETCP_PERSONALITY(p_hwfn)) {
> > +             rc =3D qed_llh_add_mac_filter(cdev, 0, params->ll2_mac_ad=
dress);
> > +             if (rc) {
> > +                     DP_NOTICE(cdev, "Failed to add an LLH filter\n");
> > +                     goto err3;
> > +             }
> > +
> >       }
> >
> >       ether_addr_copy(cdev->ll2_mac_address, params->ll2_mac_address);
> > @@ -2587,7 +2598,7 @@ static int qed_ll2_start(struct qed_dev *cdev, st=
ruct qed_ll2_params *params)
> >       return 0;
> >
> >   err3:
> > -     if (QED_IS_ISCSI_PERSONALITY(p_hwfn))
> > +     if (QED_IS_ISCSI_PERSONALITY(p_hwfn) || QED_IS_NVMETCP_PERSONALIT=
Y(p_hwfn))
> >               qed_ll2_stop_ooo(p_hwfn);
> >   err2:
> >       if (b_is_storage_eng1)
> > diff --git a/drivers/net/ethernet/qlogic/qed/qed_mcp.c b/drivers/net/et=
hernet/qlogic/qed/qed_mcp.c
> > index cd882c453394..4387292c37e2 100644
> > --- a/drivers/net/ethernet/qlogic/qed/qed_mcp.c
> > +++ b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
> > @@ -2446,6 +2446,9 @@ qed_mcp_get_shmem_proto(struct qed_hwfn *p_hwfn,
> >       case FUNC_MF_CFG_PROTOCOL_ISCSI:
> >               *p_proto =3D QED_PCI_ISCSI;
> >               break;
> > +     case FUNC_MF_CFG_PROTOCOL_NVMETCP:
> > +             *p_proto =3D QED_PCI_NVMETCP;
> > +             break;
> >       case FUNC_MF_CFG_PROTOCOL_FCOE:
> >               *p_proto =3D QED_PCI_FCOE;
> >               break;
> > diff --git a/drivers/net/ethernet/qlogic/qed/qed_mng_tlv.c b/drivers/ne=
t/ethernet/qlogic/qed/qed_mng_tlv.c
> > index 3e3192a3ad9b..6190adf965bc 100644
> > --- a/drivers/net/ethernet/qlogic/qed/qed_mng_tlv.c
> > +++ b/drivers/net/ethernet/qlogic/qed/qed_mng_tlv.c
> > @@ -1306,7 +1306,8 @@ int qed_mfw_process_tlv_req(struct qed_hwfn *p_hw=
fn, struct qed_ptt *p_ptt)
> >       }
> >
> >       if ((tlv_group & QED_MFW_TLV_ISCSI) &&
> > -         p_hwfn->hw_info.personality !=3D QED_PCI_ISCSI) {
> > +         p_hwfn->hw_info.personality !=3D QED_PCI_ISCSI &&
> > +             p_hwfn->hw_info.personality !=3D QED_PCI_NVMETCP) {
> >               DP_VERBOSE(p_hwfn, QED_MSG_SP,
> >                          "Skipping iSCSI TLVs for non-iSCSI function\n"=
);
> >               tlv_group &=3D ~QED_MFW_TLV_ISCSI;
> > diff --git a/drivers/net/ethernet/qlogic/qed/qed_ooo.c b/drivers/net/et=
hernet/qlogic/qed/qed_ooo.c
> > index 88353aa404dc..d37bb2463f98 100644
> > --- a/drivers/net/ethernet/qlogic/qed/qed_ooo.c
> > +++ b/drivers/net/ethernet/qlogic/qed/qed_ooo.c
> > @@ -16,7 +16,7 @@
> >   #include "qed_ll2.h"
> >   #include "qed_ooo.h"
> >   #include "qed_cxt.h"
> > -
> > +#include "qed_nvmetcp.h"
> >   static struct qed_ooo_archipelago
> >   *qed_ooo_seek_archipelago(struct qed_hwfn *p_hwfn,
> >                         struct qed_ooo_info
> > @@ -85,6 +85,9 @@ int qed_ooo_alloc(struct qed_hwfn *p_hwfn)
> >       case QED_PCI_ISCSI:
> >               proto =3D PROTOCOLID_ISCSI;
> >               break;
> > +     case QED_PCI_NVMETCP:
> > +             proto =3D PROTOCOLID_NVMETCP;
> > +             break;
> >       case QED_PCI_ETH_RDMA:
> >       case QED_PCI_ETH_IWARP:
> >               proto =3D PROTOCOLID_IWARP;
> > diff --git a/drivers/net/ethernet/qlogic/qed/qed_sp_commands.c b/driver=
s/net/ethernet/qlogic/qed/qed_sp_commands.c
> > index aa71adcf31ee..60b3876387a9 100644
> > --- a/drivers/net/ethernet/qlogic/qed/qed_sp_commands.c
> > +++ b/drivers/net/ethernet/qlogic/qed/qed_sp_commands.c
> > @@ -385,6 +385,7 @@ int qed_sp_pf_start(struct qed_hwfn *p_hwfn,
> >               p_ramrod->personality =3D PERSONALITY_FCOE;
> >               break;
> >       case QED_PCI_ISCSI:
> > +     case QED_PCI_NVMETCP:
> >               p_ramrod->personality =3D PERSONALITY_ISCSI;
> >               break;
> >       case QED_PCI_ETH_ROCE:
> >
> As indicated, I do find this mix of 'nvmetcp is nearly iscsi' a bit
> strange. I would have preferred to have distinct types for nvmetcp.
>

PERSONALITY_ determines the FW resource layout, which is the same for iSCSI=
 and
NVMeTCP. I will change PERSONALITY_ISCSI to PERSONALITY_TCP_ULP.

> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke                Kernel Storage Architect
> hare@suse.de                              +49 911 74053 688
> SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> HRB 36809 (AG N=C3=BCrnberg), Gesch=C3=A4ftsf=C3=BChrer: Felix Imend=C3=
=B6rffer
