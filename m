Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B822335A0C6
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 16:12:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233917AbhDIOMv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 10:12:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231402AbhDIOMu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 10:12:50 -0400
Received: from mail-oo1-xc34.google.com (mail-oo1-xc34.google.com [IPv6:2607:f8b0:4864:20::c34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8B4AC061760;
        Fri,  9 Apr 2021 07:12:35 -0700 (PDT)
Received: by mail-oo1-xc34.google.com with SMTP id j20-20020a4ad6d40000b02901b66fe8acd6so1363281oot.7;
        Fri, 09 Apr 2021 07:12:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CpQHn57amOsWI+OpdDVdAxOV6I/PlLrCLOlZZkn9GPQ=;
        b=Z9p3LiByZ1X3mW6GEFc4/tI0qTERGziUmU3r1/OPk2Hjpuvtjit34CjRkn+nmUXr7K
         GEHDqFLRvxAdvzYmeY+csxyEhOT8bFKY7DFzhkweUsOczq91sieLrYXdMaYzvaO7EusF
         V8sB0ztN/9OSYbNb9+YXv0rIO9w/s9JZGulSbPJu+LO5eyVmzhAzF9nHYgpYY+z257DZ
         BwoNYQJYk0NTenMAV+y7v45mTcXBJW0Muj+4itN7cfmj/CvWenVpr2oRazX/5GEMw71D
         vnglR8XUT5ZXuwKUz7Cjj0Wx9ENLDkIcL3m3M8r++kPi/l/BcglDQnoQ/3mNc+0uAvFa
         4JBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CpQHn57amOsWI+OpdDVdAxOV6I/PlLrCLOlZZkn9GPQ=;
        b=pl2mYxxmBJ8aJrp1aD+CTResciCcTG9EVypHUTBoIvn/Ra3roxa5N87cIb/x+z0/+9
         /tYqpTc2Z0i8mGuMKbV1gcSv7vYmfhpyNp6N1PFVIaDcU0p7hI1BYeQLjvZDP9gvVXmC
         TmecDPQFqJePIoQ53arX1kQaiF5gAxKJLWBwyd336G8gGRUknXFl904x3zZJMUI7yHL3
         zeEO8kd5pUrMvZlVZx+Y+SwxIy+YHrorDesI7Vk+JmIQRIWBdGdbcdAJRVL1hRV5raKy
         OjLzmFSkN2MMeqy7Yc99/qU3g3aLKH+Mae0Yri6X+xwN7BN28RqpWf7jCZ3ycoVqImCX
         nN3A==
X-Gm-Message-State: AOAM532Wcs3E+LKQaDrXE4Yo8V72OHyHhH+sjZHMNS+ZyF0eFIjKk0//
        yOYm1u4vapvjLjFqIk6yV5HDbqWx3IHRxYw0jn6WLVRdn0x/
X-Google-Smtp-Source: ABdhPJxyt0ic1lHvV025CibhRWK/pckqHEKp+vtB/lJCEj95Xv8JAXzGeVZiqbY9iB2w0y8IR09DTqPd80/86CZ+AtI=
X-Received: by 2002:a4a:d0ce:: with SMTP id u14mr12099539oor.36.1617977555254;
 Fri, 09 Apr 2021 07:12:35 -0700 (PDT)
MIME-Version: 1.0
References: <20210409003904.8957-1-TheSven73@gmail.com>
In-Reply-To: <20210409003904.8957-1-TheSven73@gmail.com>
From:   George McCollister <george.mccollister@gmail.com>
Date:   Fri, 9 Apr 2021 09:12:23 -0500
Message-ID: <CAFSKS=OQ0wv7mWVcZrDdrP_1WKZ+sGPZWyNMV6snc7SWRi-o5A@mail.gmail.com>
Subject: Re: [PATCH net v1] lan743x: fix ethernet frame cutoff issue
To:     Sven Van Asbroeck <thesven73@gmail.com>
Cc:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        David S Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 8, 2021 at 7:39 PM Sven Van Asbroeck <thesven73@gmail.com> wrote:
>
> From: Sven Van Asbroeck <thesven73@gmail.com>
>
> The ethernet frame length is calculated incorrectly. Depending on
> the value of RX_HEAD_PADDING, this may result in ethernet frames
> that are too short (cut off at the end), or too long (garbage added
> to the end).
>
> Fix by calculating the ethernet frame length correctly. For added
> clarity, use the ETH_FCS_LEN constant in the calculation.
>
> Many thanks to Heiner Kallweit for suggesting this solution.
>
> Fixes: 3e21a10fdea3 ("lan743x: trim all 4 bytes of the FCS; not just 2")
> Link: https://lore.kernel.org/lkml/20210408172353.21143-1-TheSven73@gmail.com/
> Signed-off-by: Sven Van Asbroeck <thesven73@gmail.com>

I'm glad everyone was able to work together to get this fixed properly
without any figure pointing or mud slinging! Kudos everyone.

Reviewed-by: George McCollister <george.mccollister@gmail.com>
Tested-By: George McCollister <george.mccollister@gmail.com>

> ---
>
> Tree: git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git # 864db232dc70
>
> To: Bryan Whitehead <bryan.whitehead@microchip.com>
> To: "David S. Miller" <davem@davemloft.net>
> To: Jakub Kicinski <kuba@kernel.org>
> To: George McCollister <george.mccollister@gmail.com>
> Cc: Heiner Kallweit <hkallweit1@gmail.com>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: UNGLinuxDriver@microchip.com
> Cc: netdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
>
>  drivers/net/ethernet/microchip/lan743x_main.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
> index 1c3e204d727c..7b6794aa8ea9 100644
> --- a/drivers/net/ethernet/microchip/lan743x_main.c
> +++ b/drivers/net/ethernet/microchip/lan743x_main.c
> @@ -885,8 +885,8 @@ static int lan743x_mac_set_mtu(struct lan743x_adapter *adapter, int new_mtu)
>         }
>
>         mac_rx &= ~(MAC_RX_MAX_SIZE_MASK_);
> -       mac_rx |= (((new_mtu + ETH_HLEN + 4) << MAC_RX_MAX_SIZE_SHIFT_) &
> -                 MAC_RX_MAX_SIZE_MASK_);
> +       mac_rx |= (((new_mtu + ETH_HLEN + ETH_FCS_LEN)
> +                 << MAC_RX_MAX_SIZE_SHIFT_) & MAC_RX_MAX_SIZE_MASK_);
>         lan743x_csr_write(adapter, MAC_RX, mac_rx);
>
>         if (enabled) {
> @@ -1944,7 +1944,7 @@ static int lan743x_rx_init_ring_element(struct lan743x_rx *rx, int index)
>         struct sk_buff *skb;
>         dma_addr_t dma_ptr;
>
> -       buffer_length = netdev->mtu + ETH_HLEN + 4 + RX_HEAD_PADDING;
> +       buffer_length = netdev->mtu + ETH_HLEN + ETH_FCS_LEN + RX_HEAD_PADDING;
>
>         descriptor = &rx->ring_cpu_ptr[index];
>         buffer_info = &rx->buffer_info[index];
> @@ -2040,7 +2040,7 @@ lan743x_rx_trim_skb(struct sk_buff *skb, int frame_length)
>                 dev_kfree_skb_irq(skb);
>                 return NULL;
>         }
> -       frame_length = max_t(int, 0, frame_length - RX_HEAD_PADDING - 4);
> +       frame_length = max_t(int, 0, frame_length - ETH_FCS_LEN);
>         if (skb->len > frame_length) {
>                 skb->tail -= skb->len - frame_length;
>                 skb->len = frame_length;
> --
> 2.17.1
>
