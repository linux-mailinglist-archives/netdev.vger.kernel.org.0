Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E80FF22585C
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 09:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726109AbgGTHV5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 03:21:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726887AbgGTHVj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 03:21:39 -0400
Received: from mail-ua1-x942.google.com (mail-ua1-x942.google.com [IPv6:2607:f8b0:4864:20::942])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A8A5C0619D2
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 00:21:39 -0700 (PDT)
Received: by mail-ua1-x942.google.com with SMTP id c7so4723692uap.0
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 00:21:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lk9bxoTF19AsH+nbjrEOR1j+cZub7m55W6YZx8DEAGQ=;
        b=lOYSDLzgNeqYzSnpQycYzVulyymK6oBXPuoH/rvxFkesKhhctp8eHyLAFd8MMc8seZ
         KI4VD4oZnFdn+/RD3DmO9FW0wkB5bC86N+XPSxEo0Cfdq6RApQ/aaf1hrCbzDehl+3aI
         7+H/bVDOmq41xM3pzR1imgx86a1+s+CV57O+aU1aH5N8WGc1JdEZAQ93KpHI6wHtV70Y
         Vn6kjnnmj/7ZJPJtQQXc0V9NzQsSC3tN7/iPA2j5A7LObnFS+bqyMjQOI41EVd1Eor17
         9mOgbmLpviUBZHxtzHWon5cR4BmlYI5mhvKSaU2zBR0XzgBb1KVp955Y63tUHZx2ApC5
         UYzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lk9bxoTF19AsH+nbjrEOR1j+cZub7m55W6YZx8DEAGQ=;
        b=qrkIEM6kLcC1LHVa+rk62hFATLQyGcP9tFS0pAqOjquFPK2Kvjs0jdWK5GIxRgPofS
         Lw5drkoFgQthW80eKLa3XExafyydgFlLHrNE/ifDLNBYgmV0tuRobBYi/3Ex18bG1agH
         DOxM8k0SnHUVXnOCiU9nfjxd0yes0SqSZmtsTzgykU/R7qvimzWAgqIBRXHlOvoxc6/W
         PmlmzehRd/HgZ/wrDi7lL/+xVZh0K0iekRJ7G32boj2UwemwsotbuoBwEW8E/jS+Jigk
         nTiy5nzCqBYTqgUQh6wcj5ZjxhuX/5LhBbsEs/kejW/VNI6Yl25riH4214j6JvxRl9lc
         xlrA==
X-Gm-Message-State: AOAM532InI6fW4JKeoAbjnpn33ZLikh3DyPNYl6+OtE14gv3D26RM5wP
        D4lZRuJkLulCILyhidkh17q+Etwp0xHh1VuIFVU=
X-Google-Smtp-Source: ABdhPJwPPZvw9Ln/OBEx0G9f9nFbM9rgByLuLxOCe2l2ukck+z+4Yid+GUce/RuID+5tW9eBhIUPzJZk34rdKgRFiA4=
X-Received: by 2002:ab0:3753:: with SMTP id i19mr14814786uat.58.1595229698517;
 Mon, 20 Jul 2020 00:21:38 -0700 (PDT)
MIME-Version: 1.0
References: <1594967062-20674-1-git-send-email-lirongqing@baidu.com> <1594967062-20674-2-git-send-email-lirongqing@baidu.com>
In-Reply-To: <1594967062-20674-2-git-send-email-lirongqing@baidu.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Mon, 20 Jul 2020 09:21:27 +0200
Message-ID: <CAJ8uoz2hdemss9S5vuF=Ttapkfb8U4YJy41oVjpMUVLiCOJTkw@mail.gmail.com>
Subject: Re: [Intel-wired-lan] [PATCH 1/2] xdp: i40e: ixgbe: ixgbevf: not flip
 rx buffer for copy mode xdp
To:     Li RongQing <lirongqing@baidu.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 17, 2020 at 8:24 AM Li RongQing <lirongqing@baidu.com> wrote:
>
> i40e/ixgbe/ixgbevf_rx_buffer_flip in copy mode xdp can lead to
> data corruption, like the following flow:
>
>    1. first skb is not for xsk, and forwarded to another device
>       or socket queue
>    2. seconds skb is for xsk, copy data to xsk memory, and page
>       of skb->data is released
>    3. rx_buff is reusable since only first skb is in it, but
>       *_rx_buffer_flip will make that page_offset is set to
>       first skb data
>    4. then reuse rx buffer, first skb which still is living
>       will be corrupted.
>
> so add flags in xdp struct, to report xdp's data status, then
> driver has knowledge whether to flip rx buffer
>
> Fixes: c497176cb2e4 ("xsk: add Rx receive functions and poll support")
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> Signed-off-by: Dongsheng Rong <rongdongsheng@baidu.com>
> ---
>  drivers/net/ethernet/intel/i40e/i40e_txrx.c       | 5 ++++-
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c     | 5 ++++-
>  drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c | 5 ++++-
>  include/net/xdp.h                                 | 3 +++
>  net/xdp/xsk.c                                     | 4 +++-
>  5 files changed, 18 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> index b3836092c327..51fa6f86f917 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> @@ -2376,6 +2376,7 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget)
>
>                 /* retrieve a buffer from the ring */
>                 if (!skb) {
> +                       xdp.flags = 0;
>                         xdp.data = page_address(rx_buffer->page) +
>                                    rx_buffer->page_offset;
>                         xdp.data_meta = xdp.data;
> @@ -2394,7 +2395,9 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget)
>
>                         if (xdp_res & (I40E_XDP_TX | I40E_XDP_REDIR)) {
>                                 xdp_xmit |= xdp_res;
> -                               i40e_rx_buffer_flip(rx_ring, rx_buffer, size);
> +
> +                               if (!(xdp.flags & XDP_DATA_RELEASED))
> +                                       i40e_rx_buffer_flip(rx_ring, rx_buffer, size);
>                         } else {
>                                 rx_buffer->pagecnt_bias++;
>                         }
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> index a8bf941c5c29..9e44a7e1d91c 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> @@ -2333,6 +2333,7 @@ static int ixgbe_clean_rx_irq(struct ixgbe_q_vector *q_vector,
>
>                 /* retrieve a buffer from the ring */
>                 if (!skb) {
> +                       xdp.flags = 0;
>                         xdp.data = page_address(rx_buffer->page) +
>                                    rx_buffer->page_offset;
>                         xdp.data_meta = xdp.data;
> @@ -2351,7 +2352,9 @@ static int ixgbe_clean_rx_irq(struct ixgbe_q_vector *q_vector,
>
>                         if (xdp_res & (IXGBE_XDP_TX | IXGBE_XDP_REDIR)) {
>                                 xdp_xmit |= xdp_res;
> -                               ixgbe_rx_buffer_flip(rx_ring, rx_buffer, size);
> +
> +                               if (!(xdp.flags & XDP_DATA_RELEASED))
> +                                       ixgbe_rx_buffer_flip(rx_ring, rx_buffer, size);
>                         } else {
>                                 rx_buffer->pagecnt_bias++;
>                         }
> diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
> index a39e2cb384dd..1c1a8b6a5dcf 100644
> --- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
> +++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
> @@ -1168,6 +1168,7 @@ static int ixgbevf_clean_rx_irq(struct ixgbevf_q_vector *q_vector,
>
>                 /* retrieve a buffer from the ring */
>                 if (!skb) {
> +                       xdp.flags = 0;
>                         xdp.data = page_address(rx_buffer->page) +
>                                    rx_buffer->page_offset;
>                         xdp.data_meta = xdp.data;
> @@ -1184,7 +1185,9 @@ static int ixgbevf_clean_rx_irq(struct ixgbevf_q_vector *q_vector,
>                 if (IS_ERR(skb)) {
>                         if (PTR_ERR(skb) == -IXGBEVF_XDP_TX) {
>                                 xdp_xmit = true;
> -                               ixgbevf_rx_buffer_flip(rx_ring, rx_buffer,
> +
> +                               if (!(xdp.flags & XDP_DATA_RELEASED))
> +                                       ixgbevf_rx_buffer_flip(rx_ring, rx_buffer,
>                                                        size);
>                         } else {
>                                 rx_buffer->pagecnt_bias++;
> diff --git a/include/net/xdp.h b/include/net/xdp.h
> index 609f819ed08b..6b32a01ade19 100644
> --- a/include/net/xdp.h
> +++ b/include/net/xdp.h
> @@ -47,6 +47,8 @@ enum xdp_mem_type {
>  #define XDP_XMIT_FLUSH         (1U << 0)       /* doorbell signal consumer */
>  #define XDP_XMIT_FLAGS_MASK    XDP_XMIT_FLUSH
>
> +#define XDP_DATA_RELEASED (1U << 0)
> +
>  struct xdp_mem_info {
>         u32 type; /* enum xdp_mem_type, but known size type */
>         u32 id;
> @@ -73,6 +75,7 @@ struct xdp_buff {
>         struct xdp_rxq_info *rxq;
>         struct xdp_txq_info *txq;
>         u32 frame_sz; /* frame size to deduce data_hard_end/reserved tailroom*/
> +       u32 flags;

RongQing,

Sorry that I was not clear enough. Could you please submit the simple
patch you had, the one that only tests for the memory type.

if (xdp->rxq->mem.type != MEM_TYPE_XSK_BUFF_POOL)
      i40e_rx_buffer_flip(rx_ring, rx_buffer, size);

I do not think that adding a flags field in the xdp_mem_info to fix an
Intel driver problem will be hugely popular. The struct is also meant
to contain long lived information, not things that will frequently
change.

Thank you: Magnus

>  };
>
>  /* Reserve memory area at end-of data area.
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index b6c0f08bd80d..2c4c5c16660b 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -172,8 +172,10 @@ static int __xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp, u32 len,
>                 xsk_buff_free(xsk_xdp);
>                 return err;
>         }
> -       if (explicit_free)
> +       if (explicit_free) {
>                 xdp_return_buff(xdp);
> +               xdp->flags |= XDP_DATA_RELEASED;
> +       }
>         return 0;
>  }
>
> --
> 2.16.2
>
> _______________________________________________
> Intel-wired-lan mailing list
> Intel-wired-lan@osuosl.org
> https://lists.osuosl.org/mailman/listinfo/intel-wired-lan
