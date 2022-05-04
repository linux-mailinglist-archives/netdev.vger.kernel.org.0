Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD88E51AEA5
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 22:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352844AbiEDULI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 16:11:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230295AbiEDULH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 16:11:07 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD411205E8;
        Wed,  4 May 2022 13:07:30 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id i19so4940263eja.11;
        Wed, 04 May 2022 13:07:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7lSSNpXXfR9Qy/9yZmZMditNWGkfTBxEtIAkXYQaMHY=;
        b=DwrZPfkdvYwiBurT5FmmNntdTqHrVcc8lePpYW6+Ntes+tTNLEObFTfQJrJYVQTl5A
         BJ+jQ6xn7udqIMO2MjGbtuOgMursdwv//eRcXUBeC0RjImLY78VJCOCnVJBcp2GUrjTr
         4TUcKyKXcNUpqnn5WU8bRPUj6VMOdL5pI3scjr+2zSYIBvbg2sZfVcG88vFh5OkSe36A
         sMfw1WtJe3tIipPmStwJQwzyRJISt9Y3Z8vkL2MplGRahYAd8JqVeGq8b4D6VqiAuqGq
         k0l2x0ebEVOeHfzui4wu2UmbxvRqb2es+mmk4mOsaPDrRlxMatTClQgctgei0RB0Voch
         5zrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7lSSNpXXfR9Qy/9yZmZMditNWGkfTBxEtIAkXYQaMHY=;
        b=yWc5Au9lAvJHeGNs9FKWjqUvrmQNvntWCFpZ5xy8AA8SXO38fwcTxGvEzEdkTw1AFd
         f7YZpYTrCvIEXURncBSX2dbOa2PIOVK78t9zAlRgCzmJ4Cbk4dg5yBH4h0BtGgK7i8km
         O3hDSaqYvkxJi29yZwY4gDIe/gvwJ1ODqYYxHtlhwHZmDA1JmeBTLfC8q8dZzXWynvIr
         QJc3bjfPosV3lDPIRA1FtkzzRWYhHU9nGJuHyHksq1YrY3nFjp0SipNZWpracIlmN+W4
         Fw68XyLCn0nxJmGpGbOx1nfSucnYmcfL+kNfB2OOEjCYVc1eDvHlcQTVzsWW6ktnHP5H
         pLvQ==
X-Gm-Message-State: AOAM533f0V53oYcAIWjKxwqw3In9NO8nHw6Z+9yjEIVBBrOaj+MSoAp7
        UI+3NSCczgXGmon2Tx3E1+8=
X-Google-Smtp-Source: ABdhPJzlGXzx5m76HwjZ3ekvNPEQriouGOD8PegIt5LcRvA/OXYGxxHNoM74Oe4PeDvJgXSnhTVgRw==
X-Received: by 2002:a17:906:9b8a:b0:6f3:fcc9:f863 with SMTP id dd10-20020a1709069b8a00b006f3fcc9f863mr22090808ejc.672.1651694849219;
        Wed, 04 May 2022 13:07:29 -0700 (PDT)
Received: from skbuf ([188.25.160.86])
        by smtp.gmail.com with ESMTPSA id hf27-20020a1709072c5b00b006f3ef214e2fsm6164979ejc.149.2022.05.04.13.07.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 13:07:28 -0700 (PDT)
Date:   Wed, 4 May 2022 23:07:26 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        KP Singh <kpsingh@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Yonghong Song <yhs@fb.com>, Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [Patch net-next v13 07/13] net: dsa: microchip: add LAN937x SPI
 driver
Message-ID: <20220504200726.pn7y73gt7wc2dpsg@skbuf>
References: <20220504151755.11737-1-arun.ramadoss@microchip.com>
 <20220504151755.11737-8-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220504151755.11737-8-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 04, 2022 at 08:47:49PM +0530, Arun Ramadoss wrote:
> This patch add the SPI driver for the LAN937x switches. It uses the
> lan937x_main.c and lan937x_dev.c functions.
> 
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> ---
>  drivers/net/dsa/microchip/Makefile      |   1 +
>  drivers/net/dsa/microchip/ksz_common.h  |   1 +
>  drivers/net/dsa/microchip/lan937x_dev.c |   7 +
>  drivers/net/dsa/microchip/lan937x_spi.c | 236 ++++++++++++++++++++++++
>  4 files changed, 245 insertions(+)
>  create mode 100644 drivers/net/dsa/microchip/lan937x_spi.c
> 
> diff --git a/drivers/net/dsa/microchip/Makefile b/drivers/net/dsa/microchip/Makefile
> index d32ff38dc240..28d8eb62a795 100644
> --- a/drivers/net/dsa/microchip/Makefile
> +++ b/drivers/net/dsa/microchip/Makefile
> @@ -10,3 +10,4 @@ obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ8863_SMI)	+= ksz8863_smi.o
>  obj-$(CONFIG_NET_DSA_MICROCHIP_LAN937X)		+= lan937x.o
>  lan937x-objs := lan937x_dev.o
>  lan937x-objs += lan937x_main.o
> +lan937x-objs += lan937x_spi.o
> diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
> index 5671f580948d..fd9e0705d2d2 100644
> --- a/drivers/net/dsa/microchip/ksz_common.h
> +++ b/drivers/net/dsa/microchip/ksz_common.h
> @@ -151,6 +151,7 @@ void ksz_switch_remove(struct ksz_device *dev);
>  int ksz8_switch_register(struct ksz_device *dev);
>  int ksz9477_switch_register(struct ksz_device *dev);
>  int lan937x_switch_register(struct ksz_device *dev);
> +int lan937x_check_device_id(struct ksz_device *dev);
>  
>  void ksz_update_port_member(struct ksz_device *dev, int port);
>  void ksz_init_mib_timer(struct ksz_device *dev);
> diff --git a/drivers/net/dsa/microchip/lan937x_dev.c b/drivers/net/dsa/microchip/lan937x_dev.c
> index 3f1797cc1d16..f430a8711775 100644
> --- a/drivers/net/dsa/microchip/lan937x_dev.c
> +++ b/drivers/net/dsa/microchip/lan937x_dev.c
> @@ -386,8 +386,15 @@ static int lan937x_mdio_register(struct ksz_device *dev)
>  
>  static int lan937x_switch_init(struct ksz_device *dev)
>  {
> +	int ret;
> +
>  	dev->ds->ops = &lan937x_switch_ops;
>  
> +	/* Check device tree */
> +	ret = lan937x_check_device_id(dev);
> +	if (ret < 0)
> +		return ret;
> +

Can't this be called from lan937x_spi_probe() directly, why do you need
to go through lan937x_switch_register() first?

>  	dev->port_mask = (1 << dev->port_cnt) - 1;
>  
>  	dev->ports = devm_kzalloc(dev->dev,
