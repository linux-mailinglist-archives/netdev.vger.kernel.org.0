Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA4806E0756
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 09:08:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbjDMHIB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 03:08:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjDMHIA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 03:08:00 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5BA01BD
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 00:07:58 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id bm45so3676147oib.4
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 00:07:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681369678; x=1683961678;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=pMNjTon4yKZUaNx1tiPdNGd7Z6N+uzozCYugn5Cr1m0=;
        b=fBPV2EoAs48OGDIo6A0RB5oxx6S/+v9ZwtkMQfiMhI7yM6Ca495u6H7uYdJG5NHoqL
         K4OUB4aECHx0I8RR1Ib2kyrwfmJo0XZYLeCSa6zoZLVH2pLY97pSuSqTpzsRAs1ymqCk
         22Cm+8EYeBH3hKgHKJ1XKOgzb7POclT3lEXZXFJDAu/k3NA2spC17rN6OQC6GovhUh2Y
         ju2Im7x9RkTmR5pJOdSWOsMHInD0fEtZswBABMYJ1xzK35zaMJy+TAcdmZjEnVsbp2UH
         V7BbAR+Lmt8IsvCOj6Ploh4hc2gPUK9gM/3ykld0P+CHtTPA5HxogngxvOrYTfRtsKMR
         pEyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681369678; x=1683961678;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pMNjTon4yKZUaNx1tiPdNGd7Z6N+uzozCYugn5Cr1m0=;
        b=O3WLw5X9DWrlC7F+hNxkfxmog6uBTw4s1/ZxqmT6+wfLKFrcyXhJMqBrldrpWkpCDc
         EJpuqZU9d8EYMbHSOO6YTiQJF0zMswxpdZ9uRklPAexx3UkSMq/yYhFLLDIkfc6EDy2v
         NeHsTB3aQJVonPns7GbzEfvHa8RWsvclQwztFVdu0ErrkntAfSH/TtlscwPEkDS9vhyA
         GeyxYOzjJ3Rufw6K4pvTu5kDALSNJv9voRorbNWULo4dyr5FNyF8ajH1sYJLzsdalmHB
         2cZ3ZnqxajuTDi8yThuqy5uEzEVCCV59i2d3E+MEV68a0I5zL+3ss62KFtw3zPzGXqyX
         abqQ==
X-Gm-Message-State: AAQBX9elhPQKYvldUwH+myaA/ELnBdr+6Ojgf5msQxO/SAbVPaVdU3sL
        i1SEvggNaVLeOxi43+lo2kVgy/jY91tPOljz8tyDgQ==
X-Google-Smtp-Source: AKy350az771X7gz/iHKHBXVCzAAutT++JEvaZWQV+W7QwSpJ35EYGAmp6Fn8f3ziqt1w+9npJ/oYLp8mlzkMQBU9TTM=
X-Received: by 2002:a54:451a:0:b0:386:b6a7:c093 with SMTP id
 l26-20020a54451a000000b00386b6a7c093mr270735oil.6.1681369677707; Thu, 13 Apr
 2023 00:07:57 -0700 (PDT)
MIME-Version: 1.0
References: <20230412114402.1119956-1-slark_xiao@163.com>
In-Reply-To: <20230412114402.1119956-1-slark_xiao@163.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Thu, 13 Apr 2023 09:07:21 +0200
Message-ID: <CAMZdPi9gHzPaKcwoRR8-gQtiSxQupL=QickXqNE2owVs-nOrxg@mail.gmail.com>
Subject: Re: [PATCH net] wwan: core: add print for wwan port attach/disconnect
To:     Slark Xiao <slark_xiao@163.com>
Cc:     ryazanov.s.a@gmail.com, johannes@sipsolutions.net,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 12 Apr 2023 at 13:45, Slark Xiao <slark_xiao@163.com> wrote:
>
> Refer to USB serial device or net device, there is notice to
> let end user know the status of device, like attached or
> disconnected. Add attach/disconnect print for wwan device as
> well. This change works for MHI device and USB device.

This change works for wwan port devices, whatever the bus is.

>
> Signed-off-by: Slark Xiao <slark_xiao@163.com>
> ---
>  drivers/net/wwan/wwan_core.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/drivers/net/wwan/wwan_core.c b/drivers/net/wwan/wwan_core.c
> index 2e1c01cf00a9..d3ac6c5b0b26 100644
> --- a/drivers/net/wwan/wwan_core.c
> +++ b/drivers/net/wwan/wwan_core.c
> @@ -492,6 +492,8 @@ struct wwan_port *wwan_create_port(struct device *parent,
>         if (err)
>                 goto error_put_device;
>
> +       dev_info(&wwandev->dev, "%s converter now attached to %s\n",
> +                wwan_port_dev_type.name, port->dev.kobj.name);

You should use `dev_name()` instead of direct reference to kobj.

Why 'converter' ? If you really want to print, it should be something like:
wwan0: wwan0at1 port attached

>         return port;
>
>  error_put_device:
> @@ -517,6 +519,9 @@ void wwan_remove_port(struct wwan_port *port)
>
>         skb_queue_purge(&port->rxq);
>         dev_set_drvdata(&port->dev, NULL);
> +
> +       dev_info(&wwandev->dev, "%s converter now disconnected from %s\n",
> +                wwan_port_dev_type.name, port->dev.kobj.name);
>         device_unregister(&port->dev);
>
>         /* Release related wwan device */
> --
> 2.34.1
>

Regards,
Loic
