Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A8E04926E4
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 14:15:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238954AbiARNPg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 08:15:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238634AbiARNPg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 08:15:36 -0500
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFEF2C061574
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 05:15:35 -0800 (PST)
Received: by mail-yb1-xb30.google.com with SMTP id m6so55579885ybc.9
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 05:15:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Rpi+gEQKxg6bybJKDC8voAnbib5Ei+cbtz3ckkEsVAQ=;
        b=LY+8QQHhh69Tpsg8h5fW1dBYD9AdH++Fa97MtabI6639FFaSRrQLXKCZvtroTTPwIN
         rre/fIdXz8g7oszQ7hB1jgpVXphMQX+NODYS//OVxc2ED9Pua0ocQzYYL5n/NDyWMrRS
         JmVaI+x0IorIyz++2vqX8Tbd1jMG9NIpvmJEBFRSyPlJUYh4o8WEb917m9V2KM2eGp5v
         Qe9LjgWRx1/viKTMW6BJ/dM0ysLwHz94HLlk5fVEjVUVINk6mKatOFYwhcZgsKDBHcUP
         00dsfHZXf+gKqURTsnnm8wJhRU0BBSssK2OG+I95KWrNytFTV7/bxsJ+aSMSLP7SgWsK
         NdxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Rpi+gEQKxg6bybJKDC8voAnbib5Ei+cbtz3ckkEsVAQ=;
        b=Epq50IBkBHiHUnMAgaBND8IeiEddKvzbRqDvNKAwfeqjhXIYEDruLTd1CNIqdvu0gZ
         oJgyKd1SBqia5RGtmowJLJw/8RK83eHbZACc/Z+OggMG+nS6Q3hJxdEL7pea3WSZNkLm
         icmuqrXXwz/ZPArzEIl5/RaPAAtnmwQstANduHciGp7uVM/++xOyt9IHuBbITSG7WlAy
         ek+ygaWRcYxhx2FjlM2o0U2iy0TbOiGld6uXh+TRQBT0pvtHtgYNoTz+Vuzv7wxKyIi9
         LQvxYnfEvghpIHa7RqJHrXLHrjgygQ92K2stkt1Pv0h/f4n7GYswT3ASQ91pgUdwJQyA
         nF1g==
X-Gm-Message-State: AOAM532iI4wwpsDlJpQ/77l+gjIYqrAYPRFZkc5qLVKGxZuNuQHgn+lw
        zjzWTkUhVAIHaVAqyFcBV9t06dRTST20G7js64TK7FVkBqimCnAX
X-Google-Smtp-Source: ABdhPJx7pgk46rlCiECDPMHx+dPfSzq6QAv2vCsZmt74l3UuLjEe5bamRvR/jnwqul+kGKDFZ+2dz718ATmSxT1+QMw=
X-Received: by 2002:a25:9c45:: with SMTP id x5mr16773712ybo.91.1642511734948;
 Tue, 18 Jan 2022 05:15:34 -0800 (PST)
MIME-Version: 1.0
References: <20220118102204.1258645-1-ardb@kernel.org>
In-Reply-To: <20220118102204.1258645-1-ardb@kernel.org>
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
Date:   Tue, 18 Jan 2022 15:14:58 +0200
Message-ID: <CAC_iWjJofXZAZt72tXvp0neWZ3FfbBrSucSRxuCwwwSh=J39Hg@mail.gmail.com>
Subject: Re: [PATCH net] net: cpsw: avoid alignment faults by taking
 NET_IP_ALIGN into account
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     netdev@vger.kernel.org, linux-omap@vger.kernel.org, arnd@arndb.de,
        davem@davemloft.net, kuba@kernel.org,
        Grygorii Strashko <grygorii.strashko@ti.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ard,

On Tue, 18 Jan 2022 at 12:22, Ard Biesheuvel <ardb@kernel.org> wrote:
>
> Both versions of the CPSW driver declare a CPSW_HEADROOM_NA macro that
> takes NET_IP_ALIGN into account, but fail to use it appropriately when
> storing incoming packets in memory. This results in the IPv4 source and
> destination addresses to appear misaligned in memory, which causes
> aligment faults that need to be fixed up in software.
>
> So let's switch from CPSW_HEADROOM to CPSW_HEADROOM_NA where needed.
> This gets rid of any alignment faults on the RX path on a Beaglebone
> White.
>
> Cc: Grygorii Strashko <grygorii.strashko@ti.com>
> Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  drivers/net/ethernet/ti/cpsw.c      | 6 +++---
>  drivers/net/ethernet/ti/cpsw_new.c  | 6 +++---
>  drivers/net/ethernet/ti/cpsw_priv.c | 2 +-
>  3 files changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
> index 33142d505fc8..03575c017500 100644
> --- a/drivers/net/ethernet/ti/cpsw.c
> +++ b/drivers/net/ethernet/ti/cpsw.c
> @@ -349,7 +349,7 @@ static void cpsw_rx_handler(void *token, int len, int status)
>         struct cpsw_common      *cpsw = ndev_to_cpsw(xmeta->ndev);
>         int                     pkt_size = cpsw->rx_packet_max;
>         int                     ret = 0, port, ch = xmeta->ch;
> -       int                     headroom = CPSW_HEADROOM;
> +       int                     headroom = CPSW_HEADROOM_NA;
>         struct net_device       *ndev = xmeta->ndev;
>         struct cpsw_priv        *priv;
>         struct page_pool        *pool;
> @@ -392,7 +392,7 @@ static void cpsw_rx_handler(void *token, int len, int status)
>         }
>
>         if (priv->xdp_prog) {
> -               int headroom = CPSW_HEADROOM, size = len;
> +               int size = len;
>
>                 xdp_init_buff(&xdp, PAGE_SIZE, &priv->xdp_rxq[ch]);
>                 if (status & CPDMA_RX_VLAN_ENCAP) {
> @@ -442,7 +442,7 @@ static void cpsw_rx_handler(void *token, int len, int status)
>         xmeta->ndev = ndev;
>         xmeta->ch = ch;
>
> -       dma = page_pool_get_dma_addr(new_page) + CPSW_HEADROOM;
> +       dma = page_pool_get_dma_addr(new_page) + CPSW_HEADROOM_NA;
>         ret = cpdma_chan_submit_mapped(cpsw->rxv[ch].ch, new_page, dma,
>                                        pkt_size, 0);
>         if (ret < 0) {
> diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
> index 279e261e4720..bd4b1528cf99 100644
> --- a/drivers/net/ethernet/ti/cpsw_new.c
> +++ b/drivers/net/ethernet/ti/cpsw_new.c
> @@ -283,7 +283,7 @@ static void cpsw_rx_handler(void *token, int len, int status)
>  {
>         struct page *new_page, *page = token;
>         void *pa = page_address(page);
> -       int headroom = CPSW_HEADROOM;
> +       int headroom = CPSW_HEADROOM_NA;
>         struct cpsw_meta_xdp *xmeta;
>         struct cpsw_common *cpsw;
>         struct net_device *ndev;
> @@ -336,7 +336,7 @@ static void cpsw_rx_handler(void *token, int len, int status)
>         }
>
>         if (priv->xdp_prog) {
> -               int headroom = CPSW_HEADROOM, size = len;
> +               int size = len;
>
>                 xdp_init_buff(&xdp, PAGE_SIZE, &priv->xdp_rxq[ch]);
>                 if (status & CPDMA_RX_VLAN_ENCAP) {
> @@ -386,7 +386,7 @@ static void cpsw_rx_handler(void *token, int len, int status)
>         xmeta->ndev = ndev;
>         xmeta->ch = ch;
>
> -       dma = page_pool_get_dma_addr(new_page) + CPSW_HEADROOM;
> +       dma = page_pool_get_dma_addr(new_page) + CPSW_HEADROOM_NA;
>         ret = cpdma_chan_submit_mapped(cpsw->rxv[ch].ch, new_page, dma,
>                                        pkt_size, 0);
>         if (ret < 0) {
> diff --git a/drivers/net/ethernet/ti/cpsw_priv.c b/drivers/net/ethernet/ti/cpsw_priv.c
> index 3537502e5e8b..ba220593e6db 100644
> --- a/drivers/net/ethernet/ti/cpsw_priv.c
> +++ b/drivers/net/ethernet/ti/cpsw_priv.c
> @@ -1122,7 +1122,7 @@ int cpsw_fill_rx_channels(struct cpsw_priv *priv)
>                         xmeta->ndev = priv->ndev;
>                         xmeta->ch = ch;
>
> -                       dma = page_pool_get_dma_addr(page) + CPSW_HEADROOM;
> +                       dma = page_pool_get_dma_addr(page) + CPSW_HEADROOM_NA;
>                         ret = cpdma_chan_idle_submit_mapped(cpsw->rxv[ch].ch,
>                                                             page, dma,
>                                                             cpsw->rx_packet_max,
> --
> 2.30.2
>

This looks good to me.
Grygorii I assume cpdma is ok with potential unaligned accesses?

Thanks
/Ilias
