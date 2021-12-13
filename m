Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA45472CDE
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 14:10:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231960AbhLMNKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 08:10:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231616AbhLMNKs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 08:10:48 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4D1AC061574;
        Mon, 13 Dec 2021 05:10:48 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id q16so14502590pgq.10;
        Mon, 13 Dec 2021 05:10:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qlNWhn3c3JrxCxBZYx5eseuh0dlEMT1Lc4OF/HedX3Q=;
        b=lYCtO2FjJVxuEmbVwEc4Z1ftxkavy9iVj0PUEArFMuKvRhXH4gZ3xyAlHVecG8kQSk
         0HxxW9MDyVzC9wjkmwBL1lx0rbX7MN/6kNHIovKyrXQojX4EaV3WRFMDucfVKc8mHqVU
         mJiaOdD6a/qDWr6iUR1+UPmzkiJ2OlR02W0s2/1Y/INFtKPIDVC87XWHRkj7qid1xtYG
         4U8zRMcA/Qz075QxAslDiXuPjsjCejHUQD3/Pg49xxmzADpcGDY1l5yAQbiBKPGd5EiG
         LQt0KH9netb+par1d/wxVX/AHQ4ypuUNZchkAe4P4ZZDD/M9+t7iGl7RIvvKqaQcG5o4
         f5Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qlNWhn3c3JrxCxBZYx5eseuh0dlEMT1Lc4OF/HedX3Q=;
        b=hHEMG35beyFj/MnXSv+ATgMMKn4R8UIrTFmCU9ke1kFBRUTfteg3wO6JgZRGOJ2xP6
         kv2HA2fNqSG0DB2qL5/vDrNnYwfT88uKGxgEHoiWaNZBoOsU009nXfTXQ764VHp1mcXr
         hY/WTgKXAneBaOOtuVl8hmKPJy2ATVMlekeBArI3q1pgXfNSRRIxxaih/53e64aimFdN
         E7gCHdrdzikMZnL8C1juTY9/iljRZRQV862VaNDJ9JIt77irZxwdGdEHARt4rM+9ANNE
         WYpL35UzmZKsGtlkmwAJknCH573ZNcC6LwLxJ/hFfKuWYy6HO/mG/MKiop1oORzoRDfs
         3tMw==
X-Gm-Message-State: AOAM5324REfDo/SNP3iZU6VRecfaf4Fu0/f9ewLUXeQvviTOMzhLiuFq
        c/r60rW4jhKHqjSGGSSvy7ZEDP6/TpEZ/UcuYhc=
X-Google-Smtp-Source: ABdhPJy650gZ2GnYO52aoSArLe3aOkWtuIE0fYu80Z9vk12JmvniQ0eSNqK34a3OtCZtnv0iJXKrP72jspmgXxOOTpM=
X-Received: by 2002:aa7:9acc:0:b0:4a2:b8b5:8813 with SMTP id
 x12-20020aa79acc000000b004a2b8b58813mr33471415pfp.4.1639401048099; Mon, 13
 Dec 2021 05:10:48 -0800 (PST)
MIME-Version: 1.0
References: <20211210171425.11475-1-maciej.fijalkowski@intel.com> <20211210171425.11475-3-maciej.fijalkowski@intel.com>
In-Reply-To: <20211210171425.11475-3-maciej.fijalkowski@intel.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Mon, 13 Dec 2021 14:10:37 +0100
Message-ID: <CAJ8uoz1CqZ4t4QagmYBgoB2C8MLPeVBRK-YO98jejD=Xemc22A@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/3] ice: xsk: improve AF_XDP ZC Tx side
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 11, 2021 at 3:02 AM Maciej Fijalkowski
<maciej.fijalkowski@intel.com> wrote:
>
> Follow mostly the logic from commit 9610bd988df9 ("ice: optimize XDP_TX
> workloads") that has been done in order to address the massive tx_busy
> statistic bump and improve the performance as well.
>
> One difference from 'xdpdrv' XDP_TX is when ring has less than
> ICE_TX_THRESH free entries, the cleaning routine will not stop after
> cleaning a single ICE_TX_THRESH amount of descs but rather will forward
> the next_dd pointer and check the DD bit and for this bit being set the
> cleaning will be repeated. IOW clean until there are descs that can be
> cleaned.
>
> Single instance of txonly scenario from xdpsock is improved by 20%. It
> takes four instances to achieve the line rate, which was not possible to
> achieve previously.
>
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_txrx.c |   2 +-
>  drivers/net/ethernet/intel/ice/ice_txrx.h |   2 +-
>  drivers/net/ethernet/intel/ice/ice_xsk.c  | 131 ++++++++++++----------
>  drivers/net/ethernet/intel/ice/ice_xsk.h  |   5 +-
>  4 files changed, 73 insertions(+), 67 deletions(-)
>
> diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
> index 227513b687b9..4b0ddb6df0c7 100644
> --- a/drivers/net/ethernet/intel/ice/ice_txrx.c
> +++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
> @@ -1452,7 +1452,7 @@ int ice_napi_poll(struct napi_struct *napi, int budget)
>                 bool wd;
>
>                 if (tx_ring->xsk_pool)
> -                       wd = ice_clean_tx_irq_zc(tx_ring, budget);
> +                       wd = ice_clean_tx_irq_zc(tx_ring);
>                 else if (ice_ring_is_xdp(tx_ring))
>                         wd = true;
>                 else
> diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
> index b7b3bd4816f0..f2ebbe2158e7 100644
> --- a/drivers/net/ethernet/intel/ice/ice_txrx.h
> +++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
> @@ -321,9 +321,9 @@ struct ice_tx_ring {
>         u16 count;                      /* Number of descriptors */
>         u16 q_index;                    /* Queue number of ring */
>         /* stats structs */
> +       struct ice_txq_stats tx_stats;
>         struct ice_q_stats      stats;
>         struct u64_stats_sync syncp;
> -       struct ice_txq_stats tx_stats;

Why this move?

>         /* CL3 - 3rd cacheline starts here */
>         struct rcu_head rcu;            /* to avoid race on free */
> diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
> index 925326c70701..a7f866b3fcd7 100644
> --- a/drivers/net/ethernet/intel/ice/ice_xsk.c
> +++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
> @@ -613,55 +613,68 @@ int ice_clean_rx_irq_zc(struct ice_rx_ring *rx_ring, int budget)
>  /**
>   * ice_xmit_zc - Completes AF_XDP entries, and cleans XDP entries
>   * @xdp_ring: XDP Tx ring
> - * @budget: max number of frames to xmit
>   *
>   * Returns true if cleanup/transmission is done.
>   */
> -static bool ice_xmit_zc(struct ice_tx_ring *xdp_ring, int budget)
> +static bool ice_xmit_zc(struct ice_tx_ring *xdp_ring)
>  {
> +       int total_packets = 0, total_bytes = 0;

Why not an unsigned type like u32?

>         struct ice_tx_desc *tx_desc = NULL;
> -       bool work_done = true;
> +       u16 ntu = xdp_ring->next_to_use;
>         struct xdp_desc desc;
>         dma_addr_t dma;
> +       u16 budget = 0;
>
> -       while (likely(budget-- > 0)) {
> -               struct ice_tx_buf *tx_buf;
> -
> -               if (unlikely(!ICE_DESC_UNUSED(xdp_ring))) {
> -                       xdp_ring->tx_stats.tx_busy++;
> -                       work_done = false;
> -                       break;
> -               }
> -
> -               tx_buf = &xdp_ring->tx_buf[xdp_ring->next_to_use];
> +       budget = ICE_DESC_UNUSED(xdp_ring);
> +       if (unlikely(!budget)) {
> +               xdp_ring->tx_stats.tx_busy++;
> +               return false;
> +       }
>
> +       while (budget-- > 0) {
>                 if (!xsk_tx_peek_desc(xdp_ring->xsk_pool, &desc))
>                         break;
>
> +               total_packets++;
>                 dma = xsk_buff_raw_get_dma(xdp_ring->xsk_pool, desc.addr);
>                 xsk_buff_raw_dma_sync_for_device(xdp_ring->xsk_pool, dma,
>                                                  desc.len);
>
> -               tx_buf->bytecount = desc.len;
> +               total_bytes += desc.len;
>
> -               tx_desc = ICE_TX_DESC(xdp_ring, xdp_ring->next_to_use);
> +               tx_desc = ICE_TX_DESC(xdp_ring, ntu);
>                 tx_desc->buf_addr = cpu_to_le64(dma);
>                 tx_desc->cmd_type_offset_bsz =
> -                       ice_build_ctob(ICE_TXD_LAST_DESC_CMD, 0, desc.len, 0);
> -
> -               xdp_ring->next_to_use++;
> -               if (xdp_ring->next_to_use == xdp_ring->count)
> -                       xdp_ring->next_to_use = 0;
> +                       ice_build_ctob(ICE_TX_DESC_CMD_EOP, 0, desc.len, 0);
> +
> +               ntu++;
> +               if (ntu == xdp_ring->count) {
> +                       ntu = 0;
> +                       tx_desc = ICE_TX_DESC(xdp_ring, xdp_ring->next_rs);
> +                       tx_desc->cmd_type_offset_bsz |=
> +                               cpu_to_le64(ICE_TX_DESC_CMD_RS << ICE_TXD_QW1_CMD_S);
> +                       xdp_ring->next_rs = ICE_TX_THRESH - 1;
> +               }
> +               if (ntu > xdp_ring->next_rs) {
> +                       tx_desc = ICE_TX_DESC(xdp_ring, xdp_ring->next_rs);
> +                       tx_desc->cmd_type_offset_bsz |=
> +                               cpu_to_le64(ICE_TX_DESC_CMD_RS << ICE_TXD_QW1_CMD_S);
> +                       xdp_ring->next_rs += ICE_TX_THRESH;
> +               }
>         }
>
> +       xdp_ring->next_to_use = ntu;
>         if (tx_desc) {
>                 ice_xdp_ring_update_tail(xdp_ring);
>                 xsk_tx_release(xdp_ring->xsk_pool);
>         }
>
> -       return budget > 0 && work_done;
> -}
> +       if (xsk_uses_need_wakeup(xdp_ring->xsk_pool))
> +               xsk_set_tx_need_wakeup(xdp_ring->xsk_pool);
> +       ice_update_tx_ring_stats(xdp_ring, total_packets, total_bytes);
>
> +       return budget > 0;
> +}
>  /**
>   * ice_clean_xdp_tx_buf - Free and unmap XDP Tx buffer
>   * @xdp_ring: XDP Tx ring
> @@ -679,30 +692,31 @@ ice_clean_xdp_tx_buf(struct ice_tx_ring *xdp_ring, struct ice_tx_buf *tx_buf)
>  /**
>   * ice_clean_tx_irq_zc - Completes AF_XDP entries, and cleans XDP entries
>   * @xdp_ring: XDP Tx ring
> - * @budget: NAPI budget
>   *
>   * Returns true if cleanup/tranmission is done.

Nit and not your fault, but it should be transmission with an "s". If
there is a v2, you might as well change it.

>   */
> -bool ice_clean_tx_irq_zc(struct ice_tx_ring *xdp_ring, int budget)
> +bool ice_clean_tx_irq_zc(struct ice_tx_ring *xdp_ring)
>  {
> -       int total_packets = 0, total_bytes = 0;
> -       s16 ntc = xdp_ring->next_to_clean;
> +       u16 next_dd = xdp_ring->next_dd;
> +       u16 desc_cnt = xdp_ring->count;
>         struct ice_tx_desc *tx_desc;
>         struct ice_tx_buf *tx_buf;
> -       u32 xsk_frames = 0;
> -       bool xmit_done;
> +       u32 xsk_frames;
> +       u16 ntc;
> +       int i;

u32 since it can never be negative?

>
> -       tx_desc = ICE_TX_DESC(xdp_ring, ntc);
> -       tx_buf = &xdp_ring->tx_buf[ntc];
> -       ntc -= xdp_ring->count;
> +       tx_desc = ICE_TX_DESC(xdp_ring, next_dd);
>
> -       do {
> -               if (!(tx_desc->cmd_type_offset_bsz &
> -                     cpu_to_le64(ICE_TX_DESC_DTYPE_DESC_DONE)))
> -                       break;
> +       if (!(tx_desc->cmd_type_offset_bsz &
> +             cpu_to_le64(ICE_TX_DESC_DTYPE_DESC_DONE)))
> +               return ice_xmit_zc(xdp_ring);
>
> -               total_bytes += tx_buf->bytecount;
> -               total_packets++;
> +again:
> +       xsk_frames = 0;
> +       ntc = xdp_ring->next_to_clean;
> +
> +       for (i = 0; i < ICE_TX_THRESH; i++) {
> +               tx_buf = &xdp_ring->tx_buf[ntc];
>
>                 if (tx_buf->raw_buf) {
>                         ice_clean_xdp_tx_buf(xdp_ring, tx_buf);
> @@ -711,34 +725,27 @@ bool ice_clean_tx_irq_zc(struct ice_tx_ring *xdp_ring, int budget)
>                         xsk_frames++;
>                 }
>
> -               tx_desc->cmd_type_offset_bsz = 0;
> -               tx_buf++;
> -               tx_desc++;
>                 ntc++;
> -
> -               if (unlikely(!ntc)) {
> -                       ntc -= xdp_ring->count;
> -                       tx_buf = xdp_ring->tx_buf;
> -                       tx_desc = ICE_TX_DESC(xdp_ring, 0);
> -               }
> -
> -               prefetch(tx_desc);

Did the removal of the prefetch improve performance?

> -
> -       } while (likely(--budget));
> -
> -       ntc += xdp_ring->count;
> -       xdp_ring->next_to_clean = ntc;
> -
> +               if (ntc >= xdp_ring->count)
> +                       ntc = 0;
> +       }
> +       xdp_ring->next_to_clean += ICE_TX_THRESH;
> +       if (xdp_ring->next_to_clean >= desc_cnt)
> +               xdp_ring->next_to_clean -= desc_cnt;
>         if (xsk_frames)
>                 xsk_tx_completed(xdp_ring->xsk_pool, xsk_frames);
> -
> -       if (xsk_uses_need_wakeup(xdp_ring->xsk_pool))
> -               xsk_set_tx_need_wakeup(xdp_ring->xsk_pool);
> -
> -       ice_update_tx_ring_stats(xdp_ring, total_packets, total_bytes);
> -       xmit_done = ice_xmit_zc(xdp_ring, ICE_DFLT_IRQ_WORK);
> -
> -       return budget > 0 && xmit_done;
> +       tx_desc->cmd_type_offset_bsz = 0;
> +       next_dd += ICE_TX_THRESH;
> +       if (next_dd > desc_cnt)
> +               next_dd = ICE_TX_THRESH - 1;
> +
> +       tx_desc = ICE_TX_DESC(xdp_ring, next_dd);
> +       if ((tx_desc->cmd_type_offset_bsz &
> +           cpu_to_le64(ICE_TX_DESC_DTYPE_DESC_DONE)))
> +               goto again;
> +       xdp_ring->next_dd = next_dd;
> +
> +       return ice_xmit_zc(xdp_ring);
>  }
>
>  /**
> diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.h b/drivers/net/ethernet/intel/ice/ice_xsk.h
> index 4c7bd8e9dfc4..1f98ad090f89 100644
> --- a/drivers/net/ethernet/intel/ice/ice_xsk.h
> +++ b/drivers/net/ethernet/intel/ice/ice_xsk.h
> @@ -12,7 +12,7 @@ struct ice_vsi;
>  int ice_xsk_pool_setup(struct ice_vsi *vsi, struct xsk_buff_pool *pool,
>                        u16 qid);
>  int ice_clean_rx_irq_zc(struct ice_rx_ring *rx_ring, int budget);
> -bool ice_clean_tx_irq_zc(struct ice_tx_ring *xdp_ring, int budget);
> +bool ice_clean_tx_irq_zc(struct ice_tx_ring *xdp_ring);
>  int ice_xsk_wakeup(struct net_device *netdev, u32 queue_id, u32 flags);
>  bool ice_alloc_rx_bufs_zc(struct ice_rx_ring *rx_ring, u16 count);
>  bool ice_xsk_any_rx_ring_ena(struct ice_vsi *vsi);
> @@ -35,8 +35,7 @@ ice_clean_rx_irq_zc(struct ice_rx_ring __always_unused *rx_ring,
>  }
>
>  static inline bool
> -ice_clean_tx_irq_zc(struct ice_tx_ring __always_unused *xdp_ring,
> -                   int __always_unused budget)
> +ice_clean_tx_irq_zc(struct ice_tx_ring __always_unused *xdp_ring)
>  {
>         return false;
>  }
> --
> 2.33.1
>
