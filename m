Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F298E5797AA
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 12:28:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236957AbiGSK2M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 06:28:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230098AbiGSK2L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 06:28:11 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 758AD108D;
        Tue, 19 Jul 2022 03:28:10 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id oy13so26267629ejb.1;
        Tue, 19 Jul 2022 03:28:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=B32cV0Fo8UXexAQJ5JEvLWLIs/XUs9dwHeG0yUAAuoQ=;
        b=hnbqJ7FIKxY29UoGXg+x0N4vyO+zMw4WIg3txmTBybgCikCLS7t6ra2qdOyz+befpE
         symCrY4LW6AFKszP5hid8I2emBOoi34Aq0mExAxKngJFgLD/OBoZ9qJhy7Fgh1kymS/6
         Zp3nQTjJg1+AKHFfwzsoKoDO5y1hJHp4JoPe6Drob9OZLPgGxkW/l2bBWoFgUCKglepK
         A68hZxmYY8CdtXqPO4OH8pIBhgEYD8S0qn7WrgwF09ox64/wfP0De10ZyvJ0CSlAvfJ5
         McZtTXMJKjLm9juX0V7lYATPtWt7xR6Tr141DDzLFxqkZINsq6KqW43FWwjerq1ZzlG5
         x9Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=B32cV0Fo8UXexAQJ5JEvLWLIs/XUs9dwHeG0yUAAuoQ=;
        b=iM6/JzmFqwN6zCQXyDCuoycp/bF8XIq3f3v8Fn7AI9n/8gcgpWGx0J5mkxvL1xFs8D
         FbdF82pl20CRghyTDLITaR90DtHMPNiDCHPhinq1xogVbII0aVHctOO+tvGFJSyHLo1P
         0LUVNHLgQ2LAVk9hqRurWNbTBjC7DSe/4XNqgACA7fzbIttVywHneeo7jOuUVjzKiig6
         x+Y4zALA9J3Hqv4438r99f6TzwtXvuK2e1tpQQVK4zjWlIgTH3KGUazpyTbOlHlbmyuX
         h4dkZ1rqqkpOmnnoRuH0R4rGVbaZ8Y/+066xQILM+djLbUWPsriLPZBo7JS96P9EF4y8
         F2sA==
X-Gm-Message-State: AJIora9RBQ8ErRjGjBDSt02TZXo/VZ+vloS0NaEUGLeH4IzAns/AIvRc
        UnmP6Tbh4gPLU4MlimCkqco=
X-Google-Smtp-Source: AGRyM1t7mrsEinBbJhyV33WQf191kWTM9+LqWuBcqk0XHGjZEhNBs43RLWEdWD6hBgnzRYR72SYJTw==
X-Received: by 2002:a17:906:93f0:b0:72e:d01f:b882 with SMTP id yl16-20020a17090693f000b0072ed01fb882mr26632506ejb.273.1658226489051;
        Tue, 19 Jul 2022 03:28:09 -0700 (PDT)
Received: from skbuf ([188.27.185.104])
        by smtp.gmail.com with ESMTPSA id gz13-20020a170906f2cd00b00722e1bca239sm6509051ejb.204.2022.07.19.03.28.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 03:28:08 -0700 (PDT)
Date:   Tue, 19 Jul 2022 13:28:06 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [RFC Patch net-next 01/10] net: dsa: microchip: lan937x: read
 rgmii delay from device tree
Message-ID: <20220719102806.3v7s3metdgo4tmmp@skbuf>
References: <20220712160308.13253-1-arun.ramadoss@microchip.com>
 <20220712160308.13253-2-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220712160308.13253-2-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 12, 2022 at 09:32:59PM +0530, Arun Ramadoss wrote:
> This patch read the rgmii tx and rx delay from device tree and stored it
> in the ksz_port.
> 
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> ---

I think this patch should be squashed into the change that actually uses
the parsed values.

>  drivers/net/dsa/microchip/ksz_common.c | 16 ++++++++++++++++
>  drivers/net/dsa/microchip/ksz_common.h |  2 ++
>  2 files changed, 18 insertions(+)
> 
> diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
> index 28d7cb2ce98f..4bc6277b4361 100644
> --- a/drivers/net/dsa/microchip/ksz_common.c
> +++ b/drivers/net/dsa/microchip/ksz_common.c
> @@ -1499,6 +1499,7 @@ int ksz_switch_register(struct ksz_device *dev)
>  	struct device_node *port, *ports;
>  	phy_interface_t interface;
>  	unsigned int port_num;
> +	u32 *value;
>  	int ret;
>  	int i;
>  
> @@ -1589,6 +1590,21 @@ int ksz_switch_register(struct ksz_device *dev)
>  				}
>  				of_get_phy_mode(port,
>  						&dev->ports[port_num].interface);
> +
> +				if (!dev->info->supports_rgmii[port_num])
> +					continue;
> +
> +				value = &dev->ports[port_num].rgmii_rx_val;
> +				if (of_property_read_u32(port,
> +							 "rx-internal-delay-ps",
> +							 value))
> +					*value = 0;
> +
> +				value = &dev->ports[port_num].rgmii_tx_val;
> +				if (of_property_read_u32(port,
> +							 "tx-internal-delay-ps",
> +							 value))
> +					*value = 0;
>  			}
>  		dev->synclko_125 = of_property_read_bool(dev->dev->of_node,
>  							 "microchip,synclko-125");
> diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
> index d5dddb7ec045..41fe6388af9e 100644
> --- a/drivers/net/dsa/microchip/ksz_common.h
> +++ b/drivers/net/dsa/microchip/ksz_common.h
> @@ -77,6 +77,8 @@ struct ksz_port {
>  	struct ksz_port_mib mib;
>  	phy_interface_t interface;
>  	u16 max_frame;
> +	u32 rgmii_tx_val;
> +	u32 rgmii_rx_val;
>  };
>  
>  struct ksz_device {
> -- 
> 2.36.1
> 
