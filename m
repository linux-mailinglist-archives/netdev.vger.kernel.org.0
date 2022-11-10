Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B9B962447E
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 15:42:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbiKJOmI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 09:42:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbiKJOmG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 09:42:06 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 804F815A33;
        Thu, 10 Nov 2022 06:42:05 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id b29so2303609pfp.13;
        Thu, 10 Nov 2022 06:42:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KdYNS4O0o2KBJ8kxQHuPa0LkJ3YDWVT2gEFQNFkY/sg=;
        b=WdC3O4VJNQXBiuFVCXGTMGwPqljHBlgPBaDo06ypDMdaWi+i4aBdBL4UxbWK4AVb3x
         Dy8qSxJSrpEGaCZy2k1Qc3KhIqpT+lV5I4WkrMzPxYqYngEf/djmagkl+btwU2lmhbeR
         Wgw4dd1KiYHU4hnPZ1hmqzf//lvl+Teo9euyubR/B13j9A2EXejgWUHGACOxhbA3yoXU
         K+nA5ZGHk7UYKpUazLKyFYussT6joTpzzmQf1CeYwbjpKTyEPaRDjwmWb4KTHGNo/QMj
         zFKiMTJZcieKw1C8WIclpTn53Kv2BuQYXPii5AWrfZARHK6hmdHrI79gAvCj5IkyVGsG
         aEXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KdYNS4O0o2KBJ8kxQHuPa0LkJ3YDWVT2gEFQNFkY/sg=;
        b=Jk4zSgiXhzIT2QO0kVRrT9LuZi4CEScVl0qcmwz0ojxW7W9NHKWed/1AfTCb0vcRnl
         m8U6pS2SkxEheNUo6181R+WVGwBbZJ3NaSqEONBHiTPv+q4V27HkUHwBBnVi65ovJP+b
         di3QDi7kQxmXDKb9muOReza8My4dcSIT91PRCiahwa7r3sZpj5nwktgVi1oaI+Tq2bSV
         gPqqFla5i18hFGy0eczBbSDqH7BDaSmKyfTK46XQmayGFEo5BPf7ijMUzJYK9kt+N6rv
         E8OCq4rC0QkK6/m6ijhpMg8W251Aj8uf98Dim3oPUDP8m9JhUfMHi6PFhr9iZRvV21zl
         Ib5g==
X-Gm-Message-State: ACrzQf1HJnUi5ulSfL2bZs9oeY8lyjRTc73tSvWhPAlBC3qnstM5le3a
        wB5bErZnTuEVhbCNl6mAnC0=
X-Google-Smtp-Source: AMsMyM5ogWyL71/QskCnaY+EzuXekliTaWs0QZynY1z6xslDxKk6WNTcV7mXAKIwpSHxWIFasz6jBg==
X-Received: by 2002:a63:1748:0:b0:46f:18be:4880 with SMTP id 8-20020a631748000000b0046f18be4880mr55108963pgx.128.1668091324710;
        Thu, 10 Nov 2022 06:42:04 -0800 (PST)
Received: from ?IPV6:2600:8802:b00:4a48:c0ce:1fc9:9b4c:5c3d? ([2600:8802:b00:4a48:c0ce:1fc9:9b4c:5c3d])
        by smtp.gmail.com with ESMTPSA id gn16-20020a17090ac79000b002130c269b6fsm3180428pjb.1.2022.11.10.06.42.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Nov 2022 06:42:04 -0800 (PST)
Message-ID: <53bd4c46-17f9-91c1-fda5-bd2d09ae2ff7@gmail.com>
Date:   Thu, 10 Nov 2022 06:42:03 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next v4 1/4] net: dsa: microchip: move max mtu to one
 location
Content-Language: en-US
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Arun Ramadoss <arun.ramadoss@microchip.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20221110122225.1283326-1-o.rempel@pengutronix.de>
 <20221110122225.1283326-2-o.rempel@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221110122225.1283326-2-o.rempel@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/10/2022 4:22 AM, Oleksij Rempel wrote:
> There are no HW specific registers, so we can process all of them
> in one location.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> Tested-by: Arun Ramadoss <arun.ramadoss@microchip.com> (KSZ9893 and LAN937x)

This looks good to me, just one nit see below

[snip]

> @@ -2500,10 +2499,23 @@ static int ksz_max_mtu(struct dsa_switch *ds, int port)
>   {
>   	struct ksz_device *dev = ds->priv;
>   
> -	if (!dev->dev_ops->max_mtu)
> -		return -EOPNOTSUPP;
> +	switch (dev->chip_id) {
> +	case KSZ8563_CHIP_ID:
> +	case KSZ9477_CHIP_ID:
> +	case KSZ9563_CHIP_ID:
> +	case KSZ9567_CHIP_ID:
> +	case KSZ9893_CHIP_ID:
> +	case KSZ9896_CHIP_ID:
> +	case KSZ9897_CHIP_ID:
> +	case LAN9370_CHIP_ID:
> +	case LAN9371_CHIP_ID:
> +	case LAN9372_CHIP_ID:
> +	case LAN9373_CHIP_ID:
> +	case LAN9374_CHIP_ID:
> +		return KSZ9477_MAX_FRAME_SIZE - VLAN_ETH_HLEN - ETH_FCS_LEN;

Rename to KSZ_MAX_FRAME_SIZE to denote this is a common constant?

> +	}
>   
> -	return dev->dev_ops->max_mtu(dev, port);
> +	return -EOPNOTSUPP;
>   }
>   
>   static void ksz_set_xmii(struct ksz_device *dev, int port,
> diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
> index c6726cbd5465..27c26ee15af4 100644
> --- a/drivers/net/dsa/microchip/ksz_common.h
> +++ b/drivers/net/dsa/microchip/ksz_common.h
> @@ -322,7 +322,6 @@ struct ksz_dev_ops {
>   	void (*get_caps)(struct ksz_device *dev, int port,
>   			 struct phylink_config *config);
>   	int (*change_mtu)(struct ksz_device *dev, int port, int mtu);
> -	int (*max_mtu)(struct ksz_device *dev, int port);
>   	void (*freeze_mib)(struct ksz_device *dev, int port, bool freeze);
>   	void (*port_init_cnt)(struct ksz_device *dev, int port);
>   	void (*phylink_mac_config)(struct ksz_device *dev, int port,
> @@ -588,6 +587,8 @@ static inline int is_lan937x(struct ksz_device *dev)
>   
>   #define PORT_SRC_PHY_INT		1
>   
> +#define KSZ9477_MAX_FRAME_SIZE		9000\

And here are as well.
-- 
Florian
