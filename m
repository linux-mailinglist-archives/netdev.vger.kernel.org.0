Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAABD52825B
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 12:42:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236019AbiEPKmT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 06:42:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242814AbiEPKk6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 06:40:58 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 065A426D9;
        Mon, 16 May 2022 03:40:42 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id eg11so3859166edb.11;
        Mon, 16 May 2022 03:40:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PIifhda7PPrqAp0CxQdnH6aDfxlPJMB9AvrT60uPWvU=;
        b=SM27mlK/X5lpvPUmxmc3slLBW+B9FQTh/Dec2eB4uKMwSAg83HSU+wccu0zgc89Fv+
         s7sYKAVtrqD0BeaBSQ7kBYliH3j2YNoTKSqM7zfBuNmZOYRQsnMNMuDEYFWIAe3j/AXT
         nfAqrAAMy8+H+kIo5OveVdRl5Nt1Yrr/BtKSlEpTWekXbNu9JLJsmBEJzlMIDYWdT7Kr
         pPJTBurzAGtKrYDlzf3j1c/RnRcO8qKC13NpMt+qKS9hE6ctPvX9kXQuTw3s4E5/P4Y9
         oluHtHL7b9ddxUwIy8GWs2Gxxe/O6p5CsrNgfUOVEk01ypn+iR8uqPtZYoRs3ONcU/cv
         qFiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PIifhda7PPrqAp0CxQdnH6aDfxlPJMB9AvrT60uPWvU=;
        b=EwT2XKn8Ki6dOrByl/SNf0D0znCQY/Gi91rH9wF7X7ld34Zh1iT3dQtOUb+0gIuhLo
         htLZ/m3wG16oAm4YKH/04RWJTDqHUYw8NFchGJ62P1NcXK3e0MTMgaEqkFQ8j9bmL3hF
         Ejh2ZggmKdMSuzKI0OY4KeHsurb2GiFV3OBiqR3RFDf2f1+OR/D4PS+P1AQ9d4CJpspS
         57LE6uQ2hV8z8sHKzDVPMj5HAwKwueR1lpUaaW+p3YXl3mmmWU2viPA12gw0q0EWukuV
         lKb5faYLJxoRy4IU0WVMgyNckrAlRpQuT0zNBMhwU3LbB5y7fS3P71GeSvGVC8/lbVrs
         ThXg==
X-Gm-Message-State: AOAM5301FVXyxOrTAk/W/Sw2z2J0MNGJDGyrgpbwTvywSRocByqO/dAf
        ak+Uk+8h9iJaPgd/oWMPZZ8=
X-Google-Smtp-Source: ABdhPJxhjqx1LtSED5Lcjpp0MdBYAjOemvUKPhq03VyRkupIkCcB4AOp8n5LW2v48oQ6cLZIWI76aw==
X-Received: by 2002:a05:6402:5113:b0:427:f443:f63e with SMTP id m19-20020a056402511300b00427f443f63emr12458895edd.317.1652697641361;
        Mon, 16 May 2022 03:40:41 -0700 (PDT)
Received: from skbuf ([188.25.160.86])
        by smtp.gmail.com with ESMTPSA id hf27-20020a1709072c5b00b006f3ef214e2asm3594220ejc.144.2022.05.16.03.40.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 03:40:40 -0700 (PDT)
Date:   Mon, 16 May 2022 13:40:39 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Marek Vasut <marex@denx.de>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [RFC Patch net-next v2 1/9] net: dsa: microchip: ksz8795: update
 the port_cnt value in ksz_chip_data
Message-ID: <20220516104039.akra6bloviak22qe@skbuf>
References: <20220513102219.30399-1-arun.ramadoss@microchip.com>
 <20220513102219.30399-2-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220513102219.30399-2-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 13, 2022 at 03:52:11PM +0530, Arun Ramadoss wrote:
> The port_cnt value in the structure is not used in the switch_init.
> Instead it uses the fls(chip->cpu_port), this is due to one of port in
> the ksz8794 unavailable. The cpu_port for the 8794 is 0x10, fls(0x10) =
> 5, hence updating it directly in the ksz_chip_data structure in order to
> same with all the other switches in ksz8795.c and ksz9477.c files.
> 
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> ---

Sounds like a straightforward transformation based on a valid observation.

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

>  drivers/net/dsa/microchip/ksz8795.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
> index f91deea9368e..83bcabf2dc54 100644
> --- a/drivers/net/dsa/microchip/ksz8795.c
> +++ b/drivers/net/dsa/microchip/ksz8795.c
> @@ -1607,6 +1607,7 @@ static const struct ksz_chip_data ksz8_switch_chips[] = {
>  		 * KSZ8794   0,1,2      4
>  		 * KSZ8795   0,1,2,3    4
>  		 * KSZ8765   0,1,2,3    4
> +		 * port_cnt is configured as 5, even though it is 4
>  		 */
>  		.chip_id = 0x8794,
>  		.dev_name = "KSZ8794",
> @@ -1614,7 +1615,7 @@ static const struct ksz_chip_data ksz8_switch_chips[] = {
>  		.num_alus = 0,
>  		.num_statics = 8,
>  		.cpu_ports = 0x10,	/* can be configured as cpu port */
> -		.port_cnt = 4,		/* total cpu and user ports */
> +		.port_cnt = 5,		/* total cpu and user ports */
>  		.ksz87xx_eee_link_erratum = true,
>  	},
>  	{
> @@ -1653,7 +1654,7 @@ static int ksz8_switch_init(struct ksz_device *dev)
>  			dev->num_vlans = chip->num_vlans;
>  			dev->num_alus = chip->num_alus;
>  			dev->num_statics = chip->num_statics;
> -			dev->port_cnt = fls(chip->cpu_ports);
> +			dev->port_cnt = chip->port_cnt;
>  			dev->cpu_port = fls(chip->cpu_ports) - 1;
>  			dev->phy_port_cnt = dev->port_cnt - 1;
>  			dev->cpu_ports = chip->cpu_ports;
> -- 
> 2.33.0
> 

