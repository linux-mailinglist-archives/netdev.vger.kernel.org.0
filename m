Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8E6A214733
	for <lists+netdev@lfdr.de>; Sat,  4 Jul 2020 18:06:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbgGDQGB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jul 2020 12:06:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726501AbgGDQGA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jul 2020 12:06:00 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69C9EC061794;
        Sat,  4 Jul 2020 09:06:00 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id x9so29615772ila.3;
        Sat, 04 Jul 2020 09:06:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ODHZ3f5eaFjThQNy1ZH1ODuExiCMIx4dGKFuIMQycDw=;
        b=eXaw5hyn1DlJTN9+CuJ68vCNARTwivoLZmwxV2nk+eiU9l4cu8J57gvDVx2la4cdQH
         F45M46Hp2KUEL27s9NCuDwj7RqGvtJZeCqzVBB4uoBwYPhM0AgA0R38QKNPTxDpJtUAD
         2DUeaZOmKAppV2Hbt9QZqnGCZ3EyFIyAKtGRjS7GEHEMd840d6rm6gEQdE1OLh5Eh5aZ
         nEDFyrWul5L29yxZl0DChN4fsU9epiKleEkmpifHWTvrQ5+ARFsDSN6mlBkBd1belI+h
         MDdA6+vM4ON+hdBQTVKZrWCT2zFd8wRoMwOc15sR8yAUrZVbOE0UG1RVxjXn2RDc4bOg
         lSJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ODHZ3f5eaFjThQNy1ZH1ODuExiCMIx4dGKFuIMQycDw=;
        b=nb9wpIgcHVsCtje/+IIl3PbdZ7S9O9OHTjuSCUQnYpze7p1u0TEy7joumg0fff4PSQ
         txo3FY5i7NvQ7qEWvrozNXGQiH5dqlR5mF1xVXGyV/a9sqTYkByuxh6ZNEw5zPwdXFvE
         YukIV7HNzObvR23L1pv/JKLL+HmsItjL92pEmmYWvch5RuFADw/tG16mTup+fmBo3Xk3
         erHKPebT+IZwMBTa3nHOTMqehi4qt1vUTqrkullRhVd/mNJrQz/v6IrcxpwBfyJgZ0Qz
         cUf0EvmI33Jn+oYZuFMvYg22VLrpsFq6loGc+wxaih/RWftgij1hkqEBeBwnhI2UUBwk
         9Q2w==
X-Gm-Message-State: AOAM531KCudeg9rRMMsemZjcFVeMZ1HSpReS+MjdS0tzUEmX0j++Dsu3
        T7+6gS18QVV4Nt3/Q7Qq70D1OEVZ7JzFvx9cMr8=
X-Google-Smtp-Source: ABdhPJzWM29TMUej+iL+jdlpOERWnMeNOp63J3Uc4L++L7sTeG0IuET1vhWvp/f2zID3OWSCC0/FHOp8Sf4CxOvC7yo=
X-Received: by 2002:a92:5a05:: with SMTP id o5mr17126179ilb.237.1593878759489;
 Sat, 04 Jul 2020 09:05:59 -0700 (PDT)
MIME-Version: 1.0
References: <20200703182010.1867-1-bruceshenzk@gmail.com>
In-Reply-To: <20200703182010.1867-1-bruceshenzk@gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Sat, 4 Jul 2020 09:05:48 -0700
Message-ID: <CAKgT0Uc0sxRmADBozs3BvK2HFsDAcgzwUKWHyu91npQvyFRM1w@mail.gmail.com>
Subject: Re: [PATCH] net: fm10k: check size from dma region
To:     Zekun Shen <bruceshenzk@gmail.com>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 3, 2020 at 11:21 AM Zekun Shen <bruceshenzk@gmail.com> wrote:
>
> Size is read from a dma region as input from device. Add sanity
> check of size before calling dma_sync_single_range_for_cpu
> with it.
>
> This would prevent DMA-API warning: device driver tries to sync DMA
> memory it has not allocated.
>
> Signed-off-by: Zekun Shen <bruceshenzk@gmail.com>
> ---
>  drivers/net/ethernet/intel/fm10k/fm10k_main.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_main.c b/drivers/net/ethernet/intel/fm10k/fm10k_main.c
> index 17738b0a9..e020b346b 100644
> --- a/drivers/net/ethernet/intel/fm10k/fm10k_main.c
> +++ b/drivers/net/ethernet/intel/fm10k/fm10k_main.c
> @@ -304,6 +304,11 @@ static struct sk_buff *fm10k_fetch_rx_buffer(struct fm10k_ring *rx_ring,
>         struct fm10k_rx_buffer *rx_buffer;
>         struct page *page;
>
> +       if (unlikely(size > PAGE_SIZE)) {
> +               dev_err(rx_ring->dev, "size %d exceeds PAGE_SIZE\n", size);
> +               return NULL;
> +       }
> +
>         rx_buffer = &rx_ring->rx_buffer[rx_ring->next_to_clean];
>         page = rx_buffer->page;
>         prefetchw(page);

The upper limitation for the size should be 2K or FM10K_RX_BUFSZ, not
PAGE_SIZE. Otherwise you are still capable of going out of bounds
because the offset is used within the page to push the start of the
region up by 2K.

If this is actually fixing the warning it makes me wonder if the code
performing the check is broken itself since we would still be
accessing outside of the accessible DMA range.
