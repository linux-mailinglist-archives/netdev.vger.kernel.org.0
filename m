Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45FFE587B84
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 13:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236855AbiHBLYh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 07:24:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231860AbiHBLYg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 07:24:36 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 845D741D20;
        Tue,  2 Aug 2022 04:24:35 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id m8so17156090edd.9;
        Tue, 02 Aug 2022 04:24:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=w48HFMAZjndIC5cODQoFtjjiRPODVTp1zXkVJEA/F/Q=;
        b=Q+CPXK6p+iudpnt89hlchrpeLgWjdKbE4JbT00lBr7RhW9UWP+YRzT3r/ZwoVZ49Y6
         ecjs3vYXRYWphmWhKpDZLYoBxIVjNCQ3p89AK+rXuH1LqE82Wy3V2jQU1wH8fg70PHbR
         5tgUUWY7Qyk8wnpOYgVZsb1MwH6OmDWRQlRwQzOJtKjulmvzfo2tv2eij7OveEd9t3G/
         blvBX4ns6HR30I25ELFZInbs+FkzMHSY77dcIaDuIo+0VvvzkvTgd6NbVNCtu6f/0GnL
         8eWkWawIWlORkF5yhvs7FalUrREi5uhtYjKw/8Vjhay8JFBIjMhX1KJOilslAyJDvgX1
         ZB3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=w48HFMAZjndIC5cODQoFtjjiRPODVTp1zXkVJEA/F/Q=;
        b=PK3bRJPWlY6SZ4u9YwzJAiR/cEfqBzikG5BjFutijCb1pAjX4chbsGEdZ+txXQlBWp
         nFpSJEerIQZkrR7jVfwHnNNoQX0WO9usTGG+0dO1YenBGWbQ7/DsYwFCYJTpZPCN0saA
         OjXQMz3JKwDdbKuKHCfuR0oXnKsJVcAssjmrY6tRu1w7OlCrihNLbCPl5o7OvBSbvz0C
         vWioczbLXnZLBBh2nS9FHLiJ52i3R/cMUt2KqDaTCeM9yZtRw0/9kpAQ5zON2JD2K0yw
         o594/1tXHC+OiFfTUornj/eD7GTtoXWDy4F2ILVBWBUy9MQomqVhwznkLT2Xa8M6NYd2
         sXGw==
X-Gm-Message-State: ACgBeo3UTkAj9EGJsH/M6LwZEf4HXDQak8Oov8d6VvnSiEwJxr3/kXoF
        TRsZMtziiETAQ2Y6H1aa0W9xH8d4v3kfiQ==
X-Google-Smtp-Source: AA6agR6DyD0n7QfTFL1V0QaFBYEFSW+QEEg8j55NE0wTq8hOo0o4MG792qGI7uXoiVVTLT7qXxmSDw==
X-Received: by 2002:a05:6402:1d54:b0:43d:280c:f25b with SMTP id dz20-20020a0564021d5400b0043d280cf25bmr19113157edb.379.1659439474090;
        Tue, 02 Aug 2022 04:24:34 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id lb4-20020a170907784400b0072faa221b3asm6040011ejc.151.2022.08.02.04.24.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Aug 2022 04:24:33 -0700 (PDT)
Date:   Tue, 2 Aug 2022 14:24:30 +0300
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
Subject: Re: [PATCH net-next v1 04/10] net: dsa: microchip: ksz9477: add
 error handling to ksz9477_r/w_phy
Message-ID: <20220802112430.7e7kpoqqlvxqrflf@skbuf>
References: <20220729130346.2961889-1-o.rempel@pengutronix.de>
 <20220729130346.2961889-1-o.rempel@pengutronix.de>
 <20220729130346.2961889-5-o.rempel@pengutronix.de>
 <20220729130346.2961889-5-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220729130346.2961889-5-o.rempel@pengutronix.de>
 <20220729130346.2961889-5-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 29, 2022 at 03:03:40PM +0200, Oleksij Rempel wrote:
>  	} else {
> -		ksz_pread16(dev, addr, 0x100 + (reg << 1), &val);
> +		ret = ksz_pread16(dev, addr, 0x100 + (reg << 1), &val);
> +		if (ret)
> +			return ret;
> +
>  		ksz9477_r_phy_quirks(dev, addr, reg, &val);
>  	}
>  
> @@ -340,11 +344,9 @@ int ksz9477_w_phy(struct ksz_device *dev, u16 addr, u16 reg, u16 val)
>  
>  	/* No gigabit support.  Do not write to this register. */
>  	if (!(dev->features & GBIT_SUPPORT) && reg == MII_CTRL1000)
> -		return 0;
> +		return -ENOTSUPP;

I wonder if ENOTSUPP is the most appropriate error code, given that I
see it defined under a comment "Defined for the NFSv3 protocol".
How about -ENXIO?

>  
> -	ksz_pwrite16(dev, addr, 0x100 + (reg << 1), val);
> -
> -	return 0;
> +	return ksz_pwrite16(dev, addr, 0x100 + (reg << 1), val);
>  }
>  
>  void ksz9477_cfg_port_member(struct ksz_device *dev, int port, u8 member)
> -- 
> 2.30.2
> 

