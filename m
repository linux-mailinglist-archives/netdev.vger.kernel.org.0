Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71A3B650EEE
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 16:43:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232473AbiLSPnV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 10:43:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232418AbiLSPmu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 10:42:50 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CA6912606;
        Mon, 19 Dec 2022 07:42:49 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id f3so6435806pgc.2;
        Mon, 19 Dec 2022 07:42:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=J72cwfUYT77oLMYmIVN0Q7oozc7lmDGcLuo9OfX1ntc=;
        b=UECQqs2TizCpYXMtlGQWMKFg6Jm9WXhRV5BVHBOEwzxZhocEWo09A/LKEnO5qH31yI
         Ps67So31z9Q/H9m52CYN+/gJUnfbM4vUsLvnScMvkUDd8oYvJ9k4EZzqU1H+/pEcM5qu
         KQQBE4aRQUwIWDg/sGtcr8LGCPpVjlEUowHdJsLK3ayrPWKDDynws76sNgFFmJWd7Mxg
         rhwMVws/2d9gRwSw3i4Eeio3ydjibeyeFha0W+u2Zti5prbZlocRk3oAke7GbXV8FWaN
         3BtpQYXV+joir+yAqHSiMSaecYMTA+BAM9iNIipFB0/wFJbPZAO2Lxe+aKqL1sRCqI57
         O5cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=J72cwfUYT77oLMYmIVN0Q7oozc7lmDGcLuo9OfX1ntc=;
        b=TbAxfOekJ1FQOVfr6dLolvmGvSXnFmFcv3b7nMmJ3s3VMvNvVeRTVERO0yjoHbDV/h
         spR+SJZkTjUGLjwYxKVDCBt/6fBYRpwGC7g59GxxhdlsrfZg5ZNJPZPlnkyBQeLB78gN
         jSDkHirAfcID37YbmBZTPRGZGfWjbj6HWPIzQ5LBzyGw4WeRN1c70pwN4rmUAa3cO538
         gJ7bRu7UnrppAR3oHQcPeC1CywRgfzGqB7t30FOJq4lU/2wNGT+CAZBIZxSKUwmxiP82
         jCVkom1lFYg5ZIRGVVFkPonaEfYH7f3fJqH3UYKQHgyEhZIIiE9tGY6qfVUrPBvrlScB
         GuDw==
X-Gm-Message-State: ANoB5plzqbg2TUYwKDxH12SeaOnXw6hzJX/VtAPFfSTb/pTbeMNhOu3p
        RXNtzKyg95kRk2eaVz6PD0hFfIygqBJu4EicRh0=
X-Google-Smtp-Source: AA0mqf7ma9vceTQSUGvGo/DXmLJ3epgJ0LCMlL14M4cQfUPNrjvhu993H8FsyoczjzZ0auTGuBLBcKirT+MveoaHb+k=
X-Received: by 2002:a63:f241:0:b0:46f:da0:f093 with SMTP id
 d1-20020a63f241000000b0046f0da0f093mr71241817pgk.441.1671464568727; Mon, 19
 Dec 2022 07:42:48 -0800 (PST)
MIME-Version: 1.0
References: <20221219022755.1047573-1-wei.fang@nxp.com>
In-Reply-To: <20221219022755.1047573-1-wei.fang@nxp.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 19 Dec 2022 07:42:37 -0800
Message-ID: <CAKgT0UemukpRyqQEeOMSnoV5qeuvUb+tTTdcbmSP4HFPoZQ2vA@mail.gmail.com>
Subject: Re: [PATCH V2 net] net: fec: Coverity issue: Dereference null return value
To:     wei.fang@nxp.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, xiaoning.wang@nxp.com, shenwei.wang@nxp.com,
        linux-imx@nxp.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Sun, Dec 18, 2022 at 6:31 PM <wei.fang@nxp.com> wrote:
>
> From: Wei Fang <wei.fang@nxp.com>
>
> The build_skb might return a null pointer but there is no check on the
> return value in the fec_enet_rx_queue(). So a null pointer dereference
> might occur. To avoid this, we check the return value of build_skb. If
> the return value is a null pointer, the driver will recycle the page and
> update the statistic of ndev. Then jump to rx_processing_done to clear
> the status flags of the BD so that the hardware can recycle the BD.
>
> Signed-off-by: Wei Fang <wei.fang@nxp.com>
> Reviewed-by: Shenwei Wang <Shenwei.wang@nxp.com>
> ---
> V2 changes:
> 1. Remove rx_packets and rx_bytes counters.
> 2. Use netdev_err_once instead of netdev_err.
> ---
>  drivers/net/ethernet/freescale/fec_main.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
> index 5528b0af82ae..644f3c963730 100644
> --- a/drivers/net/ethernet/freescale/fec_main.c
> +++ b/drivers/net/ethernet/freescale/fec_main.c
> @@ -1674,6 +1674,14 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
>                  * bridging applications.
>                  */
>                 skb = build_skb(page_address(page), PAGE_SIZE);
> +               if (unlikely(!skb)) {
> +                       page_pool_recycle_direct(rxq->page_pool, page);
> +                       ndev->stats.rx_dropped++;
> +
> +                       netdev_err_once(ndev, "build_skb failed!\n");
> +                       goto rx_processing_done;
> +               }
> +
>                 skb_reserve(skb, data_start);
>                 skb_put(skb, pkt_len - sub_len);
>                 skb_mark_for_recycle(skb);


Looks good to me.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
