Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3CA06E7959
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 14:08:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233152AbjDSMIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 08:08:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjDSMIA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 08:08:00 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DCC615A25
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 05:07:30 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id 46e09a7af769-6a5f9c1200eso685652a34.1
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 05:07:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681906049; x=1684498049;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=tZUE2rCukxYWFne7HeWnZXdo7zV5rV3bMVrdEXWrI/o=;
        b=tMd9qI3hEJmcpp+9vEGJCo8FXsYhQWfivwJFATuxnuN0ssjMzCI8bUXd022er6CebQ
         YdM3aljSvVEKArThzeEn+Tn0gb036SfpuQqfnFILG/G9QJnvXWV5S75Lq3fYbzOcnzPG
         9p+KPLbXNNAkGlAoJN3Mjpfa0q6E6z8aG6HgwNL3Edc29Pf81AQBC4UN6p+IFpO9Csxb
         hVOBR/8zNKI/v7QEeFRUk0w/MhBGVBgbK7UljRquGf48dSbapYEmZCrbUZ1oy37rDn+7
         Z9fcNhpOXWokS/CTsnir0oNA7Efs9KkMDWQfnNnhfo+x+ortJnRW3PtpurkGzVTwSduz
         TWIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681906049; x=1684498049;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tZUE2rCukxYWFne7HeWnZXdo7zV5rV3bMVrdEXWrI/o=;
        b=QJQbl/rji4iWf6PE+cHgdAxbQ5aP3VSqqKSIzhw8qDp74TUl7VoOodXKxOnNZNHlDP
         YEGIy9aCrseG4UrFbN35c3XWY26cicJlwLh4aBDY7n+S2mQC4ZG2M2vEundQLY43pT7J
         YjsEFzfSymAozeimrUm9nM8wrQu/rwbETZz/Mnlj1A8qMo/20rmCEmzdCNshbOh/BBDK
         hQkPPts9axwctlm9dcXRgq0jlnaTFbcnZ8es+oLClDDf26a2cNojYyVa9umM5W8tojRt
         YONvGzFMHBmmeG5XrId0d0md4/++832bXsd5rkkRTJmdCWylmGWLbhr1IkRA+WqmTYuf
         Nd6g==
X-Gm-Message-State: AAQBX9dMYfeoNCe+PD261CymQImAwYGSS7hO2C52EN3b2HHidDEAkWIT
        QeRsdLnjElpy9AQiIIyyqbJ+m2LIdY+G9oqaif3d/A==
X-Google-Smtp-Source: AKy350a+IGdiogTGHGdTUlhMI6RvtVxzzLW0Z3R2936ME8ApLdDPSLbhwvlvtx884jklqv0/Z5hhSIc1hxPEf50G0tA=
X-Received: by 2002:a05:6870:6125:b0:187:e208:3dd9 with SMTP id
 s37-20020a056870612500b00187e2083dd9mr2541554oae.6.1681906049602; Wed, 19 Apr
 2023 05:07:29 -0700 (PDT)
MIME-Version: 1.0
References: <20230417094617.2927393-1-slark_xiao@163.com>
In-Reply-To: <20230417094617.2927393-1-slark_xiao@163.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Wed, 19 Apr 2023 14:06:53 +0200
Message-ID: <CAMZdPi_WFxQ_aNU1t6dDh7F_aBB99XyeoFGBW2t6DryoJyFJuA@mail.gmail.com>
Subject: Re: [net-next v2] wwan: core: add print for wwan port attach/disconnect
To:     Slark Xiao <slark_xiao@163.com>
Cc:     ryazanov.s.a@gmail.com, johannes@sipsolutions.net,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 17 Apr 2023 at 11:47, Slark Xiao <slark_xiao@163.com> wrote:
>
> Refer to USB serial device or net device, there is a notice to
> let end user know the status of device, like attached or
> disconnected. Add attach/disconnect print for wwan device as
> well.
>
> Signed-off-by: Slark Xiao <slark_xiao@163.com>

Reviewed-by: Loic Poulain <loic.poulain@linaro.org>

> ---
>
> v2: Use dev_name() instead of kobj item and make print neat.
> ---
>  drivers/net/wwan/wwan_core.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/net/wwan/wwan_core.c b/drivers/net/wwan/wwan_core.c
> index 2e1c01cf00a9..aa54fa6d5f90 100644
> --- a/drivers/net/wwan/wwan_core.c
> +++ b/drivers/net/wwan/wwan_core.c
> @@ -492,6 +492,7 @@ struct wwan_port *wwan_create_port(struct device *parent,
>         if (err)
>                 goto error_put_device;
>
> +       dev_info(&wwandev->dev, "port %s attached\n", dev_name(&port->dev));
>         return port;
>
>  error_put_device:
> @@ -517,6 +518,8 @@ void wwan_remove_port(struct wwan_port *port)
>
>         skb_queue_purge(&port->rxq);
>         dev_set_drvdata(&port->dev, NULL);
> +
> +       dev_info(&wwandev->dev, "port %s disconnected\n", dev_name(&port->dev));
>         device_unregister(&port->dev);
>
>         /* Release related wwan device */
> --
> 2.34.1
>
