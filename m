Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE5BB49B003
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 10:40:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380220AbiAYJWk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 04:22:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1457601AbiAYJP7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 04:15:59 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE9E7C061392;
        Tue, 25 Jan 2022 01:09:38 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id b15so4065281plg.3;
        Tue, 25 Jan 2022 01:09:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=42lpJKH/197MI5hsdw9tU1SEO23Oa2DGBNUGHdx2ufE=;
        b=EDq+QJiMmK5DiOm8LZw4vU6lKmBQLJ8R/nKBBXhnpRIa9jalF+nt+2GvEs1LjZz4/S
         sCWADAp7bh2s35uVU1PYNu7sTU32szid/b6bxYGSUZNHqc/3unCq72mF5yacBzuvyg4A
         8IHWW73PtZXSK1apnqFhCwxWCaLhrxhXw1zT8JwKoC25NIodn+3PmKTJVjtUPuR3h3TI
         IVxOiiyXr9Mw0KPtsg/yJfnKM2EvRlWSFNpgIMiWFFgIf/Z72z1ftkN4uinJoSICE5q3
         H+LfAuxfkKCwRKRCwPZarO1wP7SmLcCYhyqHFiGXF54QI8rQ0qhP4IgZKKi+hYNWrXg7
         tQ5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=42lpJKH/197MI5hsdw9tU1SEO23Oa2DGBNUGHdx2ufE=;
        b=cTSByIQtFB7eqfNyDGF2a3ot2idF5Gmrxt8wQca+J2CiLVfQjw1FLs5JaPAyv1dwZQ
         RQLEAwFm66qj9xR2SO/YR9VeZcLBRI7Vh6KH6OXSjEm0qlQc/pH9WZ5zu9yqob7Ev9Sd
         V2DdXMFx6Q01Zqs/p79qYPEYYhndmTJUcDjfYUXnRlUE4kg0Wloag8ibwg/pr7f6V/Vd
         FDd50frlrI+BqIyqvIta36hvxIMMjV/DHqVoKtu5nYMTfb2m942ZPqWiVAoh6h+eC+dL
         dJGu+3rzD+rd0WSjxsU4Qu5VxdKLeEopRflIll9Qi9kaErVtPLISZmxul3Y/OD4A9TWx
         useg==
X-Gm-Message-State: AOAM530Ow/6Aj2kIdsmR0lfoSrcHS9dt87z0GzU6hj0nOSK49Mm2GSsw
        vQiokSvucdKLgfefmGCuo0qf3GLycKkcwsz6uzj3aa1t0YmvhiDM
X-Google-Smtp-Source: ABdhPJyqTFWftoQFx9H1Jiob42r1oDUTGn8X2rO0mPftKpNbSvZbQbr3Hz4gl9r61MHuv1Pud+yfBAbv8h8ZDQ/7iBY=
X-Received: by 2002:a17:90b:3912:: with SMTP id ob18mr2514051pjb.112.1643101778133;
 Tue, 25 Jan 2022 01:09:38 -0800 (PST)
MIME-Version: 1.0
References: <20220124165547.74412-1-maciej.fijalkowski@intel.com> <20220124165547.74412-5-maciej.fijalkowski@intel.com>
In-Reply-To: <20220124165547.74412-5-maciej.fijalkowski@intel.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Tue, 25 Jan 2022 10:09:27 +0100
Message-ID: <CAJ8uoz3Mq7JtfbwN4MvacBkV+7Rpv-=CyFwNdsZ1PN3jFH=7AQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 4/8] ice: make Tx threshold dependent on ring length
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

On Mon, Jan 24, 2022 at 8:38 PM Maciej Fijalkowski
<maciej.fijalkowski@intel.com> wrote:
>
> XDP_TX workloads use a concept of Tx threshold that indicates the
> interval of setting RS bit on descriptors which in turn tells the HW to
> generate an interrupt to signal the completion of Tx on HW side. It is
> currently based on a constant value of 32 which might not work out well
> for various sizes of ring combined with for example batch size that can
> be set via SO_BUSY_POLL_BUDGET.
>
> Internal tests based on AF_XDP showed that most convenient setup of
> mentioned threshold is when it is equal to quarter of a ring length.
>
> Make use of recently introduced ICE_RING_QUARTER macro and use this
> value as a substitute for ICE_TX_THRESH.
>
> Align also ethtool -G callback so that next_dd/next_rs fields are up to
> date in terms of the ring size.

Thanks Maciej.

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_ethtool.c  |  2 ++
>  drivers/net/ethernet/intel/ice/ice_main.c     |  4 ++--
>  drivers/net/ethernet/intel/ice/ice_txrx.h     |  1 -
>  drivers/net/ethernet/intel/ice/ice_txrx_lib.c | 14 ++++++++------
>  4 files changed, 12 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
> index e2e3ef7fba7f..e3df0134dc77 100644
> --- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
> +++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
> @@ -2803,6 +2803,8 @@ ice_set_ringparam(struct net_device *netdev, struct ethtool_ringparam *ring,
>                 /* clone ring and setup updated count */
>                 xdp_rings[i] = *vsi->xdp_rings[i];
>                 xdp_rings[i].count = new_tx_cnt;
> +               xdp_rings[i].next_dd = ICE_RING_QUARTER(&xdp_rings[i]) - 1;
> +               xdp_rings[i].next_rs = ICE_RING_QUARTER(&xdp_rings[i]) - 1;
>                 xdp_rings[i].desc = NULL;
>                 xdp_rings[i].tx_buf = NULL;
>                 err = ice_setup_tx_ring(&xdp_rings[i]);
> diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
> index 30814435f779..1980eff8f0e7 100644
> --- a/drivers/net/ethernet/intel/ice/ice_main.c
> +++ b/drivers/net/ethernet/intel/ice/ice_main.c
> @@ -2495,10 +2495,10 @@ static int ice_xdp_alloc_setup_rings(struct ice_vsi *vsi)
>                 xdp_ring->reg_idx = vsi->txq_map[xdp_q_idx];
>                 xdp_ring->vsi = vsi;
>                 xdp_ring->netdev = NULL;
> -               xdp_ring->next_dd = ICE_TX_THRESH - 1;
> -               xdp_ring->next_rs = ICE_TX_THRESH - 1;
>                 xdp_ring->dev = dev;
>                 xdp_ring->count = vsi->num_tx_desc;
> +               xdp_ring->next_dd = ICE_RING_QUARTER(xdp_ring) - 1;
> +               xdp_ring->next_rs = ICE_RING_QUARTER(xdp_ring) - 1;
>                 WRITE_ONCE(vsi->xdp_rings[i], xdp_ring);
>                 if (ice_setup_tx_ring(xdp_ring))
>                         goto free_xdp_rings;
> diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
> index f70a5eb74839..611dd7c4a631 100644
> --- a/drivers/net/ethernet/intel/ice/ice_txrx.h
> +++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
> @@ -13,7 +13,6 @@
>  #define ICE_MAX_CHAINED_RX_BUFS        5
>  #define ICE_MAX_BUF_TXD                8
>  #define ICE_MIN_TX_LEN         17
> -#define ICE_TX_THRESH          32
>
>  /* The size limit for a transmit buffer in a descriptor is (16K - 1).
>   * In order to align with the read requests we will align the value to
> diff --git a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
> index 0e87b98e0966..9677cf880a4b 100644
> --- a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
> +++ b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
> @@ -222,6 +222,7 @@ ice_receive_skb(struct ice_rx_ring *rx_ring, struct sk_buff *skb, u16 vlan_tag)
>  static void ice_clean_xdp_irq(struct ice_tx_ring *xdp_ring)
>  {
>         unsigned int total_bytes = 0, total_pkts = 0;
> +       u16 tx_thresh = ICE_RING_QUARTER(xdp_ring);
>         u16 ntc = xdp_ring->next_to_clean;
>         struct ice_tx_desc *next_dd_desc;
>         u16 next_dd = xdp_ring->next_dd;
> @@ -233,7 +234,7 @@ static void ice_clean_xdp_irq(struct ice_tx_ring *xdp_ring)
>             cpu_to_le64(ICE_TX_DESC_DTYPE_DESC_DONE)))
>                 return;
>
> -       for (i = 0; i < ICE_TX_THRESH; i++) {
> +       for (i = 0; i < tx_thresh; i++) {
>                 tx_buf = &xdp_ring->tx_buf[ntc];
>
>                 total_bytes += tx_buf->bytecount;
> @@ -254,9 +255,9 @@ static void ice_clean_xdp_irq(struct ice_tx_ring *xdp_ring)
>         }
>
>         next_dd_desc->cmd_type_offset_bsz = 0;
> -       xdp_ring->next_dd = xdp_ring->next_dd + ICE_TX_THRESH;
> +       xdp_ring->next_dd = xdp_ring->next_dd + tx_thresh;
>         if (xdp_ring->next_dd > xdp_ring->count)
> -               xdp_ring->next_dd = ICE_TX_THRESH - 1;
> +               xdp_ring->next_dd = tx_thresh - 1;
>         xdp_ring->next_to_clean = ntc;
>         ice_update_tx_ring_stats(xdp_ring, total_pkts, total_bytes);
>  }
> @@ -269,12 +270,13 @@ static void ice_clean_xdp_irq(struct ice_tx_ring *xdp_ring)
>   */
>  int ice_xmit_xdp_ring(void *data, u16 size, struct ice_tx_ring *xdp_ring)
>  {
> +       u16 tx_thresh = ICE_RING_QUARTER(xdp_ring);
>         u16 i = xdp_ring->next_to_use;
>         struct ice_tx_desc *tx_desc;
>         struct ice_tx_buf *tx_buf;
>         dma_addr_t dma;
>
> -       if (ICE_DESC_UNUSED(xdp_ring) < ICE_TX_THRESH)
> +       if (ICE_DESC_UNUSED(xdp_ring) < tx_thresh)
>                 ice_clean_xdp_irq(xdp_ring);
>
>         if (!unlikely(ICE_DESC_UNUSED(xdp_ring))) {
> @@ -306,7 +308,7 @@ int ice_xmit_xdp_ring(void *data, u16 size, struct ice_tx_ring *xdp_ring)
>                 tx_desc = ICE_TX_DESC(xdp_ring, xdp_ring->next_rs);
>                 tx_desc->cmd_type_offset_bsz |=
>                         cpu_to_le64(ICE_TX_DESC_CMD_RS << ICE_TXD_QW1_CMD_S);
> -               xdp_ring->next_rs = ICE_TX_THRESH - 1;
> +               xdp_ring->next_rs = tx_thresh - 1;
>         }
>         xdp_ring->next_to_use = i;
>
> @@ -314,7 +316,7 @@ int ice_xmit_xdp_ring(void *data, u16 size, struct ice_tx_ring *xdp_ring)
>                 tx_desc = ICE_TX_DESC(xdp_ring, xdp_ring->next_rs);
>                 tx_desc->cmd_type_offset_bsz |=
>                         cpu_to_le64(ICE_TX_DESC_CMD_RS << ICE_TXD_QW1_CMD_S);
> -               xdp_ring->next_rs += ICE_TX_THRESH;
> +               xdp_ring->next_rs += tx_thresh;
>         }
>
>         return ICE_XDP_TX;
> --
> 2.33.1
>
