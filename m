Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D20F767E8B0
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 15:54:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234043AbjA0Oy4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 09:54:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234052AbjA0Oyv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 09:54:51 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 703C373773;
        Fri, 27 Jan 2023 06:54:49 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id me3so14381972ejb.7;
        Fri, 27 Jan 2023 06:54:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+gn+XHL+I5DO4+DWbAun4810C7fhfSL0Li+nXaVTEvs=;
        b=mCiDhwHhXiHMHtKBUL42B/Fdk/e9V9X42CMjAoBcq7XHtgd+zt5Vh+zrvJiuHWBMa5
         GZ19+XJtlWwKy/WTyjmGAiAgyHsDiwuyFcpH7thw7A/FzWAIKm0cklxSxJ8mJFvW5/L9
         Kw8xUd6rxriX5m8ZDYciLfvU2Cmh4vn0Z/rk8qF0OPo7/8Phs50RJdhJQSl2NngdEOkf
         zMnXCz/IP+8Eh4mwOKA/M3vF4Eq65ZOzXIN4RcAF2WoRM7c4JH/hY00JUcNyE5TN6mU1
         tNLotSPxdKTJ4IWnCfxuXuBjLz5JQSnZbYfdkHn4bJXVdZLGz7hHymfvp2YqI9CBrHNe
         1t+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+gn+XHL+I5DO4+DWbAun4810C7fhfSL0Li+nXaVTEvs=;
        b=YhxAUIsqftTW0XA6hgIWnfO7iKa+xqsEPDG8T2CDpjBLGh4qdDYbXV1cPHYlzI7WVM
         1MrMbjOGSw3DnhgPxaXiVFKniIMJmcslCiu6594b3/KXl6cQDsUfXT1rmbu9Qx5mNiyY
         4vQbxHeS7RqFNrjM5lYD9Pewm21O9gMH2un8z7jKExqknOhmJfhPjZCmmTWY0kkq314v
         2QgGRyUEhzxf5S9ner9cXWvC+pPuspDug/2JSJMCufORPTObUKbKp0M9hGzaihzU3gbO
         Tw8gQJMh92KGh10YxTxdsaP3dX3XcurL/WiJgdb3mUdqPCPgutMHb7D8CndE/57sGVxr
         6xzw==
X-Gm-Message-State: AO0yUKW0Gpf8zx4Rth1dLLrVqtYbZddEcDpFsH3UF0oFYBupf6PVMyA+
        KiiBHI/+1ukKKWw8WxZrMj00K4Acx5UJAfGfeUs=
X-Google-Smtp-Source: AK7set/kHYkx9F2iYVASYAX2AnRyTPsgkk0idgKriSw0PFsOBfGsDbSrzRkb79ZMtFjfHCKu/D4DWvreR7aTmwoQyY4=
X-Received: by 2002:a17:906:53d3:b0:878:4c93:5b70 with SMTP id
 p19-20020a17090653d300b008784c935b70mr1813929ejo.16.1674831287856; Fri, 27
 Jan 2023 06:54:47 -0800 (PST)
MIME-Version: 1.0
References: <20230127122018.2839-1-kerneljasonxing@gmail.com>
In-Reply-To: <20230127122018.2839-1-kerneljasonxing@gmail.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Fri, 27 Jan 2023 22:54:11 +0800
Message-ID: <CAL+tcoAci+fwk6-JsTL7+yOiom08XSpc9Y5xbTZZ=WWRjYvnuw@mail.gmail.com>
Subject: Re: [PATCH v2 net] ixgbe: allow to increase MTU to some extent with
 XDP enabled
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, richardcochran@gmail.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        alexandr.lobakin@intel.com
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        Jason Xing <kernelxing@tencent.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

My bad. It's not that right. Please ignore the v2 patch. I need some
time to do more studies and tests on this part.

Thanks,
Jason

On Fri, Jan 27, 2023 at 8:20 PM Jason Xing <kerneljasonxing@gmail.com> wrote:
>
> From: Jason Xing <kernelxing@tencent.com>
>
> I encountered one case where I cannot increase the MTU size directly
> from 1500 to 2000 with XDP enabled if the server is equipped with
> IXGBE card, which happened on thousands of servers in production
> environment.
>
> This patch follows the behavior of changing MTU as i40e/ice does.
>
> Referrences:
> commit 23b44513c3e6f ("ice: allow 3k MTU for XDP")
> commit 0c8493d90b6bb ("i40e: add XDP support for pass and drop actions")
>
> Link: https://lore.kernel.org/lkml/20230121085521.9566-1-kerneljasonxing@gmail.com/
> Signed-off-by: Jason Xing <kernelxing@tencent.com>
> ---
> v2:
> 1) change the commit message.
> 2) modify the logic when changing MTU size suggested by Maciej and Alexander.
> ---
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 25 ++++++++++++-------
>  1 file changed, 16 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> index ab8370c413f3..2c1b6eb60436 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> @@ -6777,6 +6777,18 @@ static void ixgbe_free_all_rx_resources(struct ixgbe_adapter *adapter)
>                         ixgbe_free_rx_resources(adapter->rx_ring[i]);
>  }
>
> +/**
> + * ixgbe_max_xdp_frame_size - returns the maximum allowed frame size for XDP
> + * @adapter - device handle, pointer to adapter
> + */
> +static int ixgbe_max_xdp_frame_size(struct ixgbe_adapter *adapter)
> +{
> +       if (PAGE_SIZE >= 8192 || adapter->flags2 & IXGBE_FLAG2_RX_LEGACY)
> +               return IXGBE_RXBUFFER_2K;
> +       else
> +               return IXGBE_RXBUFFER_3K;
> +}
> +
>  /**
>   * ixgbe_change_mtu - Change the Maximum Transfer Unit
>   * @netdev: network interface device structure
> @@ -6788,18 +6800,13 @@ static int ixgbe_change_mtu(struct net_device *netdev, int new_mtu)
>  {
>         struct ixgbe_adapter *adapter = netdev_priv(netdev);
>
> -       if (adapter->xdp_prog) {
> +       if (ixgbe_enabled_xdp_adapter(adapter)) {
>                 int new_frame_size = new_mtu + ETH_HLEN + ETH_FCS_LEN +
>                                      VLAN_HLEN;
> -               int i;
> -
> -               for (i = 0; i < adapter->num_rx_queues; i++) {
> -                       struct ixgbe_ring *ring = adapter->rx_ring[i];
>
> -                       if (new_frame_size > ixgbe_rx_bufsz(ring)) {
> -                               e_warn(probe, "Requested MTU size is not supported with XDP\n");
> -                               return -EINVAL;
> -                       }
> +               if (new_frame_size > ixgbe_max_xdp_frame_size(adapter)) {
> +                       e_warn(probe, "Requested MTU size is not supported with XDP\n");
> +                       return -EINVAL;
>                 }
>         }
>
> --
> 2.37.3
>
