Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29FB75B7C07
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 22:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbiIMULc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 16:11:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbiIMULa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 16:11:30 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CBA3642F6
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 13:11:28 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id g3so1628467wrq.13
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 13:11:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smile-fr.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=62zrroreV09z06pto3FC2TnPEa3QeqHeX1xMH+bNz9g=;
        b=MuyXEmm6WaSkEfZJ6KsnaVU6RD9fxVm4FIrfdybwcF446nIdBmzX8mvZzvLcoZmDpK
         IDMZuSYpJ+SjvvfIElWmxR8ywdC5FveAntzSy14nwv3i+lEwcxu2hkqolR7hjAgGvdLf
         3Q+Hk/39hoPz56ktyfyGBNjZjt5z5Iotfk+7gznu5lwUhiMuk3brpJ3fB7RdhNSUVCk3
         CUfhtvSXVQbGPbFsZLU8QvLtU9elDuUxUKzGjoY0UpbvbWKMiAYnVI18/7y6P3ppXAlT
         4g3I3uVhcLOBDBtydyQA+xh/2piFpOGtW8MYXzGINFUJwf+RF4wNVQdciAWBTbdQDE2O
         UZXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=62zrroreV09z06pto3FC2TnPEa3QeqHeX1xMH+bNz9g=;
        b=yo9Xuwk85hYRRemLR4xBb1VyBLUNdhpCd1hgrTAi3Pt9G+aFdmGuKzZCWLMWH6Otec
         Y0B9gnnEvoxHdrQDJHJmkVSbQY6MldG0Uo8lqEFbDtWqrWyAaM0jlh/U54ZGYpb0n2sN
         MNFXc56eot+uN5spO1QUsdeFhLTXsiC2XnvekacO+VBymihHASJCY46L7aN0qbbRyg3y
         wjVGAbRNxj/N1v0LExDzU9Hx0fEkVUrBipWlM7EIpzL6MX23RNh38uuhn4TitQBVVMoW
         pqK5bEnjnIWN3s0xexrKEBeCVdrvShNioU1xzYTnR2ZwRGz9mcFc+7rmfTYFmdpVCqKp
         waMw==
X-Gm-Message-State: ACgBeo0v9xFYjkki9a6zlk3zF75yCsZjvFLrSBSV6ZUbsutkD+12z+sz
        Bd6r6YIE6vzSOY7RhTWCseIz3A==
X-Google-Smtp-Source: AA6agR6zBUY0rKV6La+kg92fGbXvEHT+zLIxdYj5Uel7oNEZYcdtSOuwg3PULoIJ8Uo3A+mAgG8omQ==
X-Received: by 2002:a05:6000:80a:b0:229:4632:d1d1 with SMTP id bt10-20020a056000080a00b002294632d1d1mr19798951wrb.73.1663099887113;
        Tue, 13 Sep 2022 13:11:27 -0700 (PDT)
Received: from ?IPV6:2a01:cb05:8f8a:1800:1c97:b8d1:b477:d53f? (2a01cb058f8a18001c97b8d1b477d53f.ipv6.abo.wanadoo.fr. [2a01:cb05:8f8a:1800:1c97:b8d1:b477:d53f])
        by smtp.gmail.com with ESMTPSA id w21-20020a1cf615000000b003a63a3b55c3sm14262952wmc.14.2022.09.13.13.11.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Sep 2022 13:11:26 -0700 (PDT)
Message-ID: <c1a1f948-9d7a-b0cf-3c38-3455c4bd2f4a@smile.fr>
Date:   Tue, 13 Sep 2022 22:11:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [Patch net-next 1/5] net: dsa: microchip: determine number of
 port irq based on switch type
Content-Language: fr
To:     Arun Ramadoss <arun.ramadoss@microchip.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux@armlinux.org.uk,
        Tristram.Ha@microchip.com, prasanna.vengateshan@microchip.com,
        hkallweit1@gmail.com
References: <20220913160427.12749-1-arun.ramadoss@microchip.com>
 <20220913160427.12749-2-arun.ramadoss@microchip.com>
From:   Romain Naour <romain.naour@smile.fr>
In-Reply-To: <20220913160427.12749-2-arun.ramadoss@microchip.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Le 13/09/2022 à 18:04, Arun Ramadoss a écrit :
> Currently the number of port irqs is hard coded for the lan937x switch
> as 6. In order to make the generic interrupt handler for ksz switches,
> number of port irq supported by the switch is added to the
> ksz_chip_data. It is 4 for ksz9477, 2 for ksz9897 and 3 for ksz9567.

The ksz9896 has been added recently and it's close to the ksz9897.
So it should get ".port_nirqs = 2" too?

IIUC, to get the number of port irqs you have to look at table "Port Interrupt
Mask Register" in the datasheet.

4 port irqs for the ksz9477: SGMII, PTP, PHY and ACL.
2 port irqs for the ksz9897/ksz9896: PHY and ACL.
3 port irqs for the ksz9567: PTP, PHY and ACL.

Best regards,
Romain

> 
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> ---
>  drivers/net/dsa/microchip/ksz_common.c   | 9 +++++++++
>  drivers/net/dsa/microchip/ksz_common.h   | 1 +
>  drivers/net/dsa/microchip/lan937x_main.c | 4 +---
>  3 files changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
> index fcaa71f66322..b91089a483e7 100644
> --- a/drivers/net/dsa/microchip/ksz_common.c
> +++ b/drivers/net/dsa/microchip/ksz_common.c
> @@ -1168,6 +1168,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
>  		.num_statics = 16,
>  		.cpu_ports = 0x7F,	/* can be configured as cpu port */
>  		.port_cnt = 7,		/* total physical port count */
> +		.port_nirqs = 4,
>  		.ops = &ksz9477_dev_ops,
>  		.phy_errata_9477 = true,
>  		.mib_names = ksz9477_mib_names,
> @@ -1230,6 +1231,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
>  		.num_statics = 16,
>  		.cpu_ports = 0x7F,	/* can be configured as cpu port */
>  		.port_cnt = 7,		/* total physical port count */
> +		.port_nirqs = 2,
>  		.ops = &ksz9477_dev_ops,
>  		.phy_errata_9477 = true,
>  		.mib_names = ksz9477_mib_names,
> @@ -1259,6 +1261,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
>  		.num_statics = 16,
>  		.cpu_ports = 0x07,	/* can be configured as cpu port */
>  		.port_cnt = 3,		/* total port count */
> +		.port_nirqs = 2,
>  		.ops = &ksz9477_dev_ops,
>  		.mib_names = ksz9477_mib_names,
>  		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
> @@ -1283,6 +1286,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
>  		.num_statics = 16,
>  		.cpu_ports = 0x7F,	/* can be configured as cpu port */
>  		.port_cnt = 7,		/* total physical port count */
> +		.port_nirqs = 3,
>  		.ops = &ksz9477_dev_ops,
>  		.phy_errata_9477 = true,
>  		.mib_names = ksz9477_mib_names,
> @@ -1312,6 +1316,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
>  		.num_statics = 256,
>  		.cpu_ports = 0x10,	/* can be configured as cpu port */
>  		.port_cnt = 5,		/* total physical port count */
> +		.port_nirqs = 6,
>  		.ops = &lan937x_dev_ops,
>  		.mib_names = ksz9477_mib_names,
>  		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
> @@ -1335,6 +1340,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
>  		.num_statics = 256,
>  		.cpu_ports = 0x30,	/* can be configured as cpu port */
>  		.port_cnt = 6,		/* total physical port count */
> +		.port_nirqs = 6,
>  		.ops = &lan937x_dev_ops,
>  		.mib_names = ksz9477_mib_names,
>  		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
> @@ -1358,6 +1364,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
>  		.num_statics = 256,
>  		.cpu_ports = 0x30,	/* can be configured as cpu port */
>  		.port_cnt = 8,		/* total physical port count */
> +		.port_nirqs = 6,
>  		.ops = &lan937x_dev_ops,
>  		.mib_names = ksz9477_mib_names,
>  		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
> @@ -1385,6 +1392,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
>  		.num_statics = 256,
>  		.cpu_ports = 0x38,	/* can be configured as cpu port */
>  		.port_cnt = 5,		/* total physical port count */
> +		.port_nirqs = 6,
>  		.ops = &lan937x_dev_ops,
>  		.mib_names = ksz9477_mib_names,
>  		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
> @@ -1412,6 +1420,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
>  		.num_statics = 256,
>  		.cpu_ports = 0x30,	/* can be configured as cpu port */
>  		.port_cnt = 8,		/* total physical port count */
> +		.port_nirqs = 6,
>  		.ops = &lan937x_dev_ops,
>  		.mib_names = ksz9477_mib_names,
>  		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
> diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
> index 6203dcd8c8f7..baa1e1bc1b7c 100644
> --- a/drivers/net/dsa/microchip/ksz_common.h
> +++ b/drivers/net/dsa/microchip/ksz_common.h
> @@ -45,6 +45,7 @@ struct ksz_chip_data {
>  	int num_statics;
>  	int cpu_ports;
>  	int port_cnt;
> +	u8 port_nirqs;
>  	const struct ksz_dev_ops *ops;
>  	bool phy_errata_9477;
>  	bool ksz87xx_eee_link_erratum;
> diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
> index 9b6760b1e572..7136d9c55315 100644
> --- a/drivers/net/dsa/microchip/lan937x_main.c
> +++ b/drivers/net/dsa/microchip/lan937x_main.c
> @@ -20,8 +20,6 @@
>  #include "ksz_common.h"
>  #include "lan937x.h"
>  
> -#define LAN937x_PNIRQS 6
> -
>  static int lan937x_cfg(struct ksz_device *dev, u32 addr, u8 bits, bool set)
>  {
>  	return regmap_update_bits(dev->regmap[0], addr, bits, set ? bits : 0);
> @@ -697,7 +695,7 @@ static int lan937x_pirq_setup(struct ksz_device *dev, u8 p)
>  	int ret, irq;
>  	int irq_num;
>  
> -	port->pirq.nirqs = LAN937x_PNIRQS;
> +	port->pirq.nirqs = dev->info->port_nirqs;
>  	port->pirq.domain = irq_domain_add_simple(dev->dev->of_node,
>  						  port->pirq.nirqs, 0,
>  						  &lan937x_pirq_domain_ops,

