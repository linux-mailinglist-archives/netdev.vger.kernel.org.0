Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D39162CDD2E
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 19:18:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbgLCSRD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 13:17:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726312AbgLCSRD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 13:17:03 -0500
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2C2FC061A4E
        for <netdev@vger.kernel.org>; Thu,  3 Dec 2020 10:16:22 -0800 (PST)
Received: by mail-il1-x143.google.com with SMTP id y9so2820968ilb.0
        for <netdev@vger.kernel.org>; Thu, 03 Dec 2020 10:16:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1ollTmGs+xqYHc2d9X1saJcnFCATzvfVN4Oo5/QShWA=;
        b=WJs0wSJxsEHvJ7ENJgtR2Iv6d2i9LkdmDpQpDhFaHi0RCcQ09l7EyUE/fVSEa3HUK+
         EfU9yDZa5Zgkp8NcaN+2Acq7ro+7MXRBKwzKkSHV7qH3ROCL9OSwtj/Zt121PByv0F7J
         ueAHBPpKkjzpsRMl78407BROIpchNvvrNiewqDFdNl9GzJwIaTBN2qqelMKK8JG69gAF
         9PkJRgXYIN9ubxZ2aNcOphZCAaTcGAQNeEKP9Y0pjWyBFRlRgFv7PKYp/gBoRWRYmTnq
         6Zb3+0QqA8EAeeeBKIAurKbFhkD+a8lyJRqcw5ZmrQwpvWLV1vhBUjYHKsU+nzb0e1rN
         OB4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1ollTmGs+xqYHc2d9X1saJcnFCATzvfVN4Oo5/QShWA=;
        b=JqhZ1VpSvvkQxvU8jMhWc4WGOoNXap/8OSfi5eQlnLzQoEHdqV1av+f/0uP6RGySAb
         62HS7PnKHvHTn1gJTx+eU4MmFOnkFNYaqs1bZUTLKwMLIMuQ/LsFonewIy3N8xgbW132
         uszLxG7s81HqQWRZubz/fVL59vTzW2vPxRNCRaezFzgGfpW0Ng85ancaahFjuLHNkZbn
         BXusKfFhNYwnnbLZyVVBIsjUW33cHwoaCG1TUv+sHY1JE9UO3HgD/kXVaEcCU1fC092p
         0DznMboTulCo0NudW+Ps2sa0nFWlNER+WhPP+iLTlxCXo1hR84JRfubTOU6Hvc7z6Fi9
         Hh6w==
X-Gm-Message-State: AOAM530Yu5dMaYCNXR9I0SZuw9tvjX6hDBvZ9MH2g42iSf17lsKqV5lN
        ugQ4Rx6JsYLZBBzEHxJLUq/Ccz2Y35y6s6PyryQ=
X-Google-Smtp-Source: ABdhPJwpIkcNFzV5ojHUH2SiEeE8oM8kvgcogimFFfVcpb5uRESDHqhoFXOHn3/QNXsltcRW12ymw4CuasxJtBJX0FQ=
X-Received: by 2002:a92:730d:: with SMTP id o13mr406052ilc.95.1607019382006;
 Thu, 03 Dec 2020 10:16:22 -0800 (PST)
MIME-Version: 1.0
References: <20201202182413.232510-1-awogbemila@google.com> <20201202182413.232510-5-awogbemila@google.com>
In-Reply-To: <20201202182413.232510-5-awogbemila@google.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 3 Dec 2020 10:16:11 -0800
Message-ID: <CAKgT0Uc66PS67HvrT8jzW0tCnzjRqaD1Hnm9-1YZ0XncTh_3BA@mail.gmail.com>
Subject: Re: [PATCH net-next v9 4/4] gve: Add support for raw addressing in
 the tx path
To:     David Awogbemila <awogbemila@google.com>
Cc:     Netdev <netdev@vger.kernel.org>, Saeed Mahameed <saeed@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Catherine Sullivan <csully@google.com>,
        Yangchun Fu <yangchun@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 2, 2020 at 10:24 AM David Awogbemila <awogbemila@google.com> wrote:
>
> From: Catherine Sullivan <csully@google.com>
>
> During TX, skbs' data addresses are dma_map'ed and passed to the NIC.
> This means that the device can perform DMA directly from these addresses
> and the driver does not have to copy the buffer content into
> pre-allocated buffers/qpls (as in qpl mode).
>
> Reviewed-by: Yangchun Fu <yangchun@google.com>
> Signed-off-by: Catherine Sullivan <csully@google.com>
> Signed-off-by: David Awogbemila <awogbemila@google.com>
> ---
>  drivers/net/ethernet/google/gve/gve.h         |  16 +-
>  drivers/net/ethernet/google/gve/gve_adminq.c  |   4 +-
>  drivers/net/ethernet/google/gve/gve_desc.h    |   8 +-
>  drivers/net/ethernet/google/gve/gve_ethtool.c |   2 +
>  drivers/net/ethernet/google/gve/gve_tx.c      | 197 ++++++++++++++----
>  5 files changed, 185 insertions(+), 42 deletions(-)
>
> diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
> index 8aad4af2aa2b..9888fa92be86 100644
> --- a/drivers/net/ethernet/google/gve/gve.h
> +++ b/drivers/net/ethernet/google/gve/gve.h
> @@ -112,12 +112,20 @@ struct gve_tx_iovec {
>         u32 iov_padding; /* padding associated with this segment */
>  };
>
> +struct gve_tx_dma_buf {
> +       DEFINE_DMA_UNMAP_ADDR(dma);
> +       DEFINE_DMA_UNMAP_LEN(len);
> +};
> +
>  /* Tracks the memory in the fifo occupied by the skb. Mapped 1:1 to a desc
>   * ring entry but only used for a pkt_desc not a seg_desc
>   */
>  struct gve_tx_buffer_state {
>         struct sk_buff *skb; /* skb for this pkt */
> -       struct gve_tx_iovec iov[GVE_TX_MAX_IOVEC]; /* segments of this pkt */
> +       union {
> +               struct gve_tx_iovec iov[GVE_TX_MAX_IOVEC]; /* segments of this pkt */
> +               struct gve_tx_dma_buf buf;
> +       };
>  };
>
>  /* A TX buffer - each queue has one */
> @@ -140,19 +148,23 @@ struct gve_tx_ring {
>         __be32 last_nic_done ____cacheline_aligned; /* NIC tail pointer */
>         u64 pkt_done; /* free-running - total packets completed */
>         u64 bytes_done; /* free-running - total bytes completed */
> +       u32 dropped_pkt; /* free-running - total packets dropped */

Generally I would probably use a u64 for any count values. I'm not
sure what rate you will be moving packets at but if something goes
wrong you are better off with the counter not rolling over every few
minutes.

>         /* Cacheline 2 -- Read-mostly fields */
>         union gve_tx_desc *desc ____cacheline_aligned;
>         struct gve_tx_buffer_state *info; /* Maps 1:1 to a desc */
>         struct netdev_queue *netdev_txq;
>         struct gve_queue_resources *q_resources; /* head and tail pointer idx */
> +       struct device *dev;
>         u32 mask; /* masks req and done down to queue size */
> +       u8 raw_addressing; /* use raw_addressing? */
>
>         /* Slow-path fields */
>         u32 q_num ____cacheline_aligned; /* queue idx */
>         u32 stop_queue; /* count of queue stops */
>         u32 wake_queue; /* count of queue wakes */
>         u32 ntfy_id; /* notification block index */
> +       u32 dma_mapping_error; /* count of dma mapping errors */

Since this is a counter wouldn't it make more sense to place it up
with the other counters?

Looking over the rest of the patch it seems fine to me. The counters
were the only thing that had me a bit concerned.
