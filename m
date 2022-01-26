Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E689E49C4DF
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 09:07:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbiAZIH2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 03:07:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230011AbiAZIH1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 03:07:27 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51195C06161C;
        Wed, 26 Jan 2022 00:07:27 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id h20-20020a17090adb9400b001b518bf99ffso3993730pjv.1;
        Wed, 26 Jan 2022 00:07:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WK1m9YGMIOU47nTvl2kdOoyGhuyNMDYzbDohinKezdc=;
        b=N+YPh5xjqoSydTKNpzJ5hMlKUC7AnDBc9HPQRM+ImxjektnmmydPb5CIdeNLqd7nWN
         d8qrH6pgPDKnwno7lJMYvOC3Q2wnB/TjwxgtHT8UR86RB6lQUbzL6ctoHKmoTFJfSTKn
         4GWoYUNE+6SPe93nXEU0CkVMmD7jXN4HQBYxogHu/JXGHjYYL/10SV+KdfBOPPMQe113
         isPsdFmyDbN07Zt0fvN3B58TiwvbnxddzkatQAR/7tvsqw5IfhYise4TBzX99eCU78uV
         wEIMpuAEB0Eu6JlBGaVoX9D1UbiIFY6l6T6qVqCd4LLVjFrKw67SocY84iIUjTrgMwmC
         F2Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WK1m9YGMIOU47nTvl2kdOoyGhuyNMDYzbDohinKezdc=;
        b=CrgO++NezBDW+YYpQNRcoFMqp5oOgqpSogDKUnHpx5crYeN8wGn2vnfbCFnUtBTyPf
         jN0vHJkPV72jNpRCyD2Lma2ooW2qV9HdaG2XjwRQkTZrXJNO51F8mbV90QQftuyugwnc
         oirOpKo0jWxRahMOpQmnM+IFTdu/TZ9FnaMWRRVVWqgm+I6k8I2VB7/vsXCHpsiJziqI
         i09DWlfwS/2rAVKklXTPT04mO7Pif5LjCSfx0tlHhz9fkFkf0WOUdmhfoEu3pOuzW1EF
         uEzwHIpQVj79fX2bjOuC2BJU1cIz/0VVfnjo6C/K8dzrOZoTKG7lMeT9dQccA0cvDRCr
         XYdw==
X-Gm-Message-State: AOAM530InIRO20dT92Jya3QPuyil2CV21swMVf9SRqpXwAYndIxI4/OR
        qmBIxTZEx3DKKJftbvAWuuvh1vEepr3AJckVPRKLGY74L7V0mg==
X-Google-Smtp-Source: ABdhPJy3npHkp4muntCPuuN3taHcWgfTMM2vPynP6YkfKJnoorurZfnd8xG08Slqmy8zPP3aXigdPCi3eKrEnpx3JAk=
X-Received: by 2002:a17:902:7148:b0:14b:650c:4ce7 with SMTP id
 u8-20020a170902714800b0014b650c4ce7mr8969378plm.4.1643184446641; Wed, 26 Jan
 2022 00:07:26 -0800 (PST)
MIME-Version: 1.0
References: <20220125160446.78976-1-maciej.fijalkowski@intel.com> <20220125160446.78976-9-maciej.fijalkowski@intel.com>
In-Reply-To: <20220125160446.78976-9-maciej.fijalkowski@intel.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Wed, 26 Jan 2022 09:07:15 +0100
Message-ID: <CAJ8uoz39QX5weOyJEgQC9r-V58C1wqTYSnbc+s+uZSxnsWP=qw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 8/8] ice: xsk: borrow xdp_tx_active logic from i40e
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 25, 2022 at 11:58 PM Maciej Fijalkowski
<maciej.fijalkowski@intel.com> wrote:
>
> One of the things that commit 5574ff7b7b3d ("i40e: optimize AF_XDP Tx
> completion path") introduced was the @xdp_tx_active field. Its usage
> from i40e can be adjusted to ice driver and give us positive performance
> results.
>
> If the descriptor that @next_dd points to has been sent by HW (its DD
> bit is set), then we are sure that at least quarter of the ring is ready
> to be cleaned. If @xdp_tx_active is 0 which means that related xdp_ring
> is not used for XDP_{TX, REDIRECT} workloads, then we know how many XSK
> entries should placed to completion queue, IOW walking through the ring
> can be skipped.

Thanks Maciej.

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

> Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_txrx.h     |  1 +
>  drivers/net/ethernet/intel/ice/ice_txrx_lib.c |  1 +
>  drivers/net/ethernet/intel/ice/ice_xsk.c      | 15 ++++++++++++---
>  3 files changed, 14 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
> index 666db35a2919..466253ac2ee1 100644
> --- a/drivers/net/ethernet/intel/ice/ice_txrx.h
> +++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
> @@ -333,6 +333,7 @@ struct ice_tx_ring {
>         spinlock_t tx_lock;
>         u32 txq_teid;                   /* Added Tx queue TEID */
>         /* CL4 - 4th cacheline starts here */
> +       u16 xdp_tx_active;
>  #define ICE_TX_FLAGS_RING_XDP          BIT(0)
>         u8 flags;
>         u8 dcb_tc;                      /* Traffic class of ring */
> diff --git a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
> index 9677cf880a4b..eb21cec1d772 100644
> --- a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
> +++ b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
> @@ -302,6 +302,7 @@ int ice_xmit_xdp_ring(void *data, u16 size, struct ice_tx_ring *xdp_ring)
>         tx_desc->cmd_type_offset_bsz = ice_build_ctob(ICE_TX_DESC_CMD_EOP, 0,
>                                                       size, 0);
>
> +       xdp_ring->xdp_tx_active++;
>         i++;
>         if (i == xdp_ring->count) {
>                 i = 0;
> diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
> index 8b6acb4afb7f..2976991c0ab2 100644
> --- a/drivers/net/ethernet/intel/ice/ice_xsk.c
> +++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
> @@ -687,6 +687,7 @@ static void
>  ice_clean_xdp_tx_buf(struct ice_tx_ring *xdp_ring, struct ice_tx_buf *tx_buf)
>  {
>         xdp_return_frame((struct xdp_frame *)tx_buf->raw_buf);
> +       xdp_ring->xdp_tx_active--;
>         dma_unmap_single(xdp_ring->dev, dma_unmap_addr(tx_buf, dma),
>                          dma_unmap_len(tx_buf, len), DMA_TO_DEVICE);
>         dma_unmap_len_set(tx_buf, len, 0);
> @@ -703,9 +704,8 @@ static u16 ice_clean_xdp_irq_zc(struct ice_tx_ring *xdp_ring, int napi_budget)
>  {
>         u16 tx_thresh = ICE_RING_QUARTER(xdp_ring);
>         int budget = napi_budget / tx_thresh;
> -       u16 ntc = xdp_ring->next_to_clean;
>         u16 next_dd = xdp_ring->next_dd;
> -       u16 cleared_dds = 0;
> +       u16 ntc, cleared_dds = 0;
>
>         do {
>                 struct ice_tx_desc *next_dd_desc;
> @@ -721,6 +721,12 @@ static u16 ice_clean_xdp_irq_zc(struct ice_tx_ring *xdp_ring, int napi_budget)
>
>                 cleared_dds++;
>                 xsk_frames = 0;
> +               if (likely(!xdp_ring->xdp_tx_active)) {
> +                       xsk_frames = tx_thresh;
> +                       goto skip;
> +               }
> +
> +               ntc = xdp_ring->next_to_clean;
>
>                 for (i = 0; i < tx_thresh; i++) {
>                         tx_buf = &xdp_ring->tx_buf[ntc];
> @@ -736,6 +742,10 @@ static u16 ice_clean_xdp_irq_zc(struct ice_tx_ring *xdp_ring, int napi_budget)
>                         if (ntc >= xdp_ring->count)
>                                 ntc = 0;
>                 }
> +skip:
> +               xdp_ring->next_to_clean += tx_thresh;
> +               if (xdp_ring->next_to_clean >= desc_cnt)
> +                       xdp_ring->next_to_clean -= desc_cnt;
>                 if (xsk_frames)
>                         xsk_tx_completed(xdp_ring->xsk_pool, xsk_frames);
>                 next_dd_desc->cmd_type_offset_bsz = 0;
> @@ -744,7 +754,6 @@ static u16 ice_clean_xdp_irq_zc(struct ice_tx_ring *xdp_ring, int napi_budget)
>                         next_dd = tx_thresh - 1;
>         } while (budget--);
>
> -       xdp_ring->next_to_clean = ntc;
>         xdp_ring->next_dd = next_dd;
>
>         return cleared_dds * tx_thresh;
> --
> 2.33.1
>
