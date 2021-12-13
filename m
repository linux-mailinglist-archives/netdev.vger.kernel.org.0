Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFB4B472CEE
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 14:13:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233518AbhLMNNN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 08:13:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232266AbhLMNNN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 08:13:13 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07C66C061574;
        Mon, 13 Dec 2021 05:13:13 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id r130so14943464pfc.1;
        Mon, 13 Dec 2021 05:13:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/n5g73Zi2zAOOD+aV8wfwUw34A87dZdhqC0QHxMoNdo=;
        b=hO1Xs6xfq1L9hJc06Z5zLQNeIGtctoBr9J0NxXtQNA1CtRqKWhlrwiWMJWr3cmWC7T
         BV96xuerbrRDABvjyMT24M91U1us4TqilE7XgSwfmygnA2UqzZzb40Z0Gpnjv33nUSXn
         sPvcNMMp8UZfP0xCYV7jbSfUpaT8p995zmlkaWAOB9rmAyYMfHUK3q3wMmoiKULI0S7W
         ilnqy994/aK20Zl7jSvfUI6PXftdThOwdvBe6/xOJ4qpjFzUOKB2qWZmTDZVmTKMoHlZ
         yh53cEDLuwOSGdIkuUdUiVvyJVX/cOsjtLmQsAEWD9dNvjXHRihK4ZibtiKAeESRV9hx
         d41g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/n5g73Zi2zAOOD+aV8wfwUw34A87dZdhqC0QHxMoNdo=;
        b=tt7ivkn0zejHCoHMB7BPQPep5Acmt6s9wsTk7F77m9R0qf9WtLhZANnxMsZhZSN4LD
         g4fOyeoXIBHv6eS2MHZ4t/tAFh0FND3oVI4SWZ1AqGOMlPlgOWclVQ4P9kvys/S8HrHz
         tN1Rlf6ntXB7/H3u9OY7kqvDKAg2P5okGOPr7+vWSQ6nzua1Akc4yINgHHOLPfCemo43
         gHSwXyd+V9uf37thffllItGQFNb5CWWCtS9R/PhXsL5mxi1XyAiOgjjhWTLGnD1z/2ZE
         5nKjqng4O0dMaS/Mee3obmPIeBmVTRT4O6yIhF6GmtYxyUvDb1CIFHuXlFuNwpEqQCdi
         eFww==
X-Gm-Message-State: AOAM532nufApW6tGU89jNBqEHZAjexBb5JBYa7tjZ7IHrCz78BlrTGUX
        EQvzfYfaUnw/a76B17QXCTkb3nUfncG4Tw2ZF4tEWe8Zwa0ssuMr
X-Google-Smtp-Source: ABdhPJwzlG6nHaQi5R/WYqtGpK+ujR2XjaCtGkGLKmjlBeXmLMEjmNpgYnSjyOBThfT0FZEIjoM6OZJxZG6g3JHtNJk=
X-Received: by 2002:aa7:9acc:0:b0:4a2:b8b5:8813 with SMTP id
 x12-20020aa79acc000000b004a2b8b58813mr33483223pfp.4.1639401192517; Mon, 13
 Dec 2021 05:13:12 -0800 (PST)
MIME-Version: 1.0
References: <20211210171425.11475-1-maciej.fijalkowski@intel.com> <20211210171425.11475-4-maciej.fijalkowski@intel.com>
In-Reply-To: <20211210171425.11475-4-maciej.fijalkowski@intel.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Mon, 13 Dec 2021 14:13:01 +0100
Message-ID: <CAJ8uoz0NBd9t87PtASWRyTR-YVwDaUi_Dd6gJKOCQBOROgLEzA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/3] ice: xsk: borrow xdp_tx_active logic from i40e
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
> One of the things that commit 5574ff7b7b3d ("i40e: optimize AF_XDP Tx
> completion path") introduced was the @xdp_tx_active field. Its usage
> from i40e can be adjusted to ice driver and give us positive performance
> results.
>
> If the descriptor that @next_dd to points has been sent by HW (its DD
> bit is set), then we are sure that there are ICE_TX_THRESH count of
> descriptors ready to be cleaned. If @xdp_tx_active is 0 which means that
> related xdp_ring is not used for XDP_{TX, REDIRECT} workloads, then we
> know how many XSK entries should placed to completion queue, IOW walking
> through the ring can be skipped.

Thanks for implementing this in ice too.

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_txrx.h     | 1 +
>  drivers/net/ethernet/intel/ice/ice_txrx_lib.c | 1 +
>  drivers/net/ethernet/intel/ice/ice_xsk.c      | 7 +++++++
>  3 files changed, 9 insertions(+)
>
> diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
> index f2ebbe2158e7..8dd9c92662ad 100644
> --- a/drivers/net/ethernet/intel/ice/ice_txrx.h
> +++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
> @@ -332,6 +332,7 @@ struct ice_tx_ring {
>         struct ice_ptp_tx *tx_tstamps;
>         spinlock_t tx_lock;
>         u32 txq_teid;                   /* Added Tx queue TEID */
> +       u16 xdp_tx_active;
>  #define ICE_TX_FLAGS_RING_XDP          BIT(0)
>         u8 flags;
>         u8 dcb_tc;                      /* Traffic class of ring */
> diff --git a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
> index 1dd7e84f41f8..f15c215c973c 100644
> --- a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
> +++ b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
> @@ -299,6 +299,7 @@ int ice_xmit_xdp_ring(void *data, u16 size, struct ice_tx_ring *xdp_ring)
>         tx_desc->cmd_type_offset_bsz = ice_build_ctob(ICE_TX_DESC_CMD_EOP, 0,
>                                                       size, 0);
>
> +       xdp_ring->xdp_tx_active++;
>         i++;
>         if (i == xdp_ring->count) {
>                 i = 0;
> diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
> index a7f866b3fcd7..8949a7be45c6 100644
> --- a/drivers/net/ethernet/intel/ice/ice_xsk.c
> +++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
> @@ -684,6 +684,7 @@ static void
>  ice_clean_xdp_tx_buf(struct ice_tx_ring *xdp_ring, struct ice_tx_buf *tx_buf)
>  {
>         xdp_return_frame((struct xdp_frame *)tx_buf->raw_buf);
> +       xdp_ring->xdp_tx_active--;
>         dma_unmap_single(xdp_ring->dev, dma_unmap_addr(tx_buf, dma),
>                          dma_unmap_len(tx_buf, len), DMA_TO_DEVICE);
>         dma_unmap_len_set(tx_buf, len, 0);
> @@ -713,6 +714,11 @@ bool ice_clean_tx_irq_zc(struct ice_tx_ring *xdp_ring)
>
>  again:
>         xsk_frames = 0;
> +       if (likely(!xdp_ring->xdp_tx_active)) {
> +               xsk_frames = ICE_TX_THRESH;
> +               goto skip;
> +       }
> +
>         ntc = xdp_ring->next_to_clean;
>
>         for (i = 0; i < ICE_TX_THRESH; i++) {
> @@ -729,6 +735,7 @@ bool ice_clean_tx_irq_zc(struct ice_tx_ring *xdp_ring)
>                 if (ntc >= xdp_ring->count)
>                         ntc = 0;
>         }
> +skip:
>         xdp_ring->next_to_clean += ICE_TX_THRESH;
>         if (xdp_ring->next_to_clean >= desc_cnt)
>                 xdp_ring->next_to_clean -= desc_cnt;
> --
> 2.33.1
>
