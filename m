Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86945587BAA
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 13:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236415AbiHBLgl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 07:36:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231860AbiHBLgl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 07:36:41 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED9BC313A2;
        Tue,  2 Aug 2022 04:36:37 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id j8so170479ejx.9;
        Tue, 02 Aug 2022 04:36:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gCdoZci4qISca3fnCeBw6F5QQccyLV7en2QNJTlXxC8=;
        b=lramhtbVEg/he4uED59mDZci90TMOg+FjuQUALzNCMsw3iWUfQWn1yzN8Li7mQENfY
         JsThpjgBECIronVxLOb9Tt4OI49Igk54c8ZVvGdDnEfHtN3z69niRyj17qV2cbuTWeKW
         +AJVm1adIeH46k/I2wYlk9QxPH3nnDdJcM1TfoizHkU8Njzejv2i3W9MFwurI+GqBdXK
         ayzXk9mzQcvBHWpje4Lh2jzD9+38RcvpIf7ms4EuZVtXTP7efka3AecM3gnx/m6PyfeE
         uoB1P9CxSnZhBZS8Y48ZVqebKG74wQwm9HgzDsRjgZ01RwxLQkxe3kmYv11jJtEk9+fc
         B2Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gCdoZci4qISca3fnCeBw6F5QQccyLV7en2QNJTlXxC8=;
        b=erdtkYJ37Yn+wao5k1Wo2QYnY0OYj4o3QoUDp7VW2lM6qbttBzqiKvUGQihpyK4DnY
         5P2frQFI983+7LQftPV4A1QFAWGWJph5a6zbgHOm8EJjSI2h3bdGZKE1wFpUp5d882Wa
         alraMRiPpz3NkzK+IKpJ/9tLULtIimh0Dy9QFKxriJb8f/Rduwee72J7xOH0A6K5RLVt
         SQGuK/35p+boNVXdcvfJVFFPwz4rTGenkQlr49N983iPihVNBo7gtXnd7MbBHaji8X1F
         stuB5jTA2VaT97o7tbLHnBulIvwoVIgXsJ1m7AGVqoVha6yPUwVNY0U6GPjT85+zThG1
         +ugA==
X-Gm-Message-State: AJIora9L/qCkwutv4tV2oXhaG4NUOGdZd+pfuMLPqUQ/OXFRJFvgKeeC
        ZjN5gkNYu3PhPJJbMBWu+VMu4HLHtgA6cA==
X-Google-Smtp-Source: AGRyM1vI8dtAxWUWYShe+bt2oa5RAI9Y6dPsdiUKskj/PlUG3rjq/tag+9JxqmMMXkNHdjK/AWyJvQ==
X-Received: by 2002:a17:906:5a5b:b0:72b:39cf:6042 with SMTP id my27-20020a1709065a5b00b0072b39cf6042mr15489740ejc.301.1659440196417;
        Tue, 02 Aug 2022 04:36:36 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id e21-20020a170906315500b0072af930cf97sm6168551eje.115.2022.08.02.04.36.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Aug 2022 04:36:35 -0700 (PDT)
Date:   Tue, 2 Aug 2022 14:36:33 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1 07/10] net: dsa: microchip: warn about not
 supported synclko properties on KSZ9893 chips
Message-ID: <20220802113633.73rxlb2kmihivwpx@skbuf>
References: <20220729130346.2961889-1-o.rempel@pengutronix.de>
 <20220729130346.2961889-8-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220729130346.2961889-8-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 29, 2022 at 03:03:43PM +0200, Oleksij Rempel wrote:
> KSZ9893 family of chips do not support synclko property. So warn about
> without preventing driver from start.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  drivers/net/dsa/microchip/ksz_common.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
> index 71b5349d006a..d3a9836c706f 100644
> --- a/drivers/net/dsa/microchip/ksz_common.c
> +++ b/drivers/net/dsa/microchip/ksz_common.c
> @@ -1916,6 +1916,13 @@ int ksz_switch_register(struct ksz_device *dev)
>  			dev_err(dev->dev, "inconsistent synclko settings\n");
>  			return -EINVAL;
>  		}
> +
> +		if (dev->chip_id == KSZ9893_CHIP_ID && (dev->synclko_125 ||
> +							dev->synclko_disable)) {
> +			dev_warn(dev->dev, "microchip,synclko-125 and microchip,synclko-disable "
> +				 "properties are not supported on this chip. "
> +				 "Please fix you devicetree.\n");

s/you/your/

Does KSZ8 have a REFCLK output of any sort? If it doesn't, then
"microchip,synclko-disable" is kind of supported, right?

I wonder what there is to gain by saying that you should remove some
device tree properties from non-ksz9477. After all, anyone can add any
random properties to a KSZ8 switch OF node and you won't warn about
those.

> +		}
>  	}
>  
>  	ret = dsa_register_switch(dev->ds);
> -- 
> 2.30.2
> 
