Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BDFC598254
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 13:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244127AbiHRLcB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 07:32:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239816AbiHRLcA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 07:32:00 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0509F9BB52
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 04:31:58 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id j8so2659544ejx.9
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 04:31:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc;
        bh=Y/PR9Rnj0ZoI0rlNbegkIno2eq8Ax70Bk9edRa+0uo0=;
        b=Y1dDRgdoJ2ZX8R2j9JdRth11sVw890OaHNfUhojlmZp/UbUer5ths9oYNKJMRx8tZz
         GB4n+uQgLuRsuL7lbXgwdirlLpQC9mif781Vel0UlMphbqNhAnzLWFfVo7x9M7e3JvfR
         i95OHjm3zYCKbUYh92gG8+KSivgZdYeuGDl9Fq6tov9p1YvCpmWgp9a1rAtKQABmZWPI
         SkhX6o1KOc8C8HaGUoHxcdNte/FoNPuFqq3le1S9t1FdYw1QyBFuDal0b5aOCSIAuIT1
         GaKxOw5A8X2nAk/8/3G0O1Cd1SaCq9EE6t2UqQ3WwP1R/zeAdP0wsLGpZ7kRkQj31/lH
         ZmsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc;
        bh=Y/PR9Rnj0ZoI0rlNbegkIno2eq8Ax70Bk9edRa+0uo0=;
        b=E6qMwWTFMPT7y2irl8tiGzZ9AucUKYO/U9Dq945kohnkr11hDqA4sqUemnCvIjvXoC
         Y7gSmuNU2v2wGpzqQEQUd27HE2xxZofcpAYjH1gcIMRdt1KW4PUB4fzj4Al4sQ47JeFH
         GVL6YFIpX6euvQBTsaxs1hHhBA+FFLGC1Ke8/60cLhExcQATTw87qnx+u8bSz8gl6QPj
         sNH4oG8cnacMFz9tYznDO53yOr3W5VdKmoBY709Ac7qs8IN5xbqbgmJL1cVmNmv7Ifgz
         0H7CuZ6wvOgfcYLpVWvkU/4BBYNIfeFq0nmj7KpGF539LUrUEyAbV7rFWMNL5G15+G14
         dULw==
X-Gm-Message-State: ACgBeo1GOiAOsR6e6ijN6qGijTX/eCS8vDDdBSN70R39u0ivob/cmsDj
        /D157jrzCYDLV3jyUcjtOyQUKFWkXQg=
X-Google-Smtp-Source: AA6agR7AJUzk8ILGVCf+49XrMQtBP8zqCXFCTFYK1hPGG0TENlA5w0qEEQau0rhd8nN350o+OAMFOA==
X-Received: by 2002:a17:907:a064:b0:730:726f:c62c with SMTP id ia4-20020a170907a06400b00730726fc62cmr1618655ejc.86.1660822316322;
        Thu, 18 Aug 2022 04:31:56 -0700 (PDT)
Received: from skbuf ([188.25.231.137])
        by smtp.gmail.com with ESMTPSA id o26-20020a170906289a00b0071cbc7487e1sm710327ejd.69.2022.08.18.04.31.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 04:31:51 -0700 (PDT)
Date:   Thu, 18 Aug 2022 14:31:47 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Alvin =?utf-8?Q?=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Network Development <netdev@vger.kernel.org>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: commit 65ac79e181 breaks our ksz9567
Message-ID: <20220818113147.42kqi45wlihwuhly@skbuf>
References: <408851bb-5245-7a10-3335-c475d4d1ca0f@prevas.dk>
 <20220818112846.ghhiqody2lwuznci@bang-olufsen.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220818112846.ghhiqody2lwuznci@bang-olufsen.dk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 18, 2022 at 11:28:46AM +0000, Alvin Šipraga wrote:
> Hi Rasmus,
> 
> On Thu, Aug 18, 2022 at 01:03:13PM +0200, Rasmus Villemoes wrote:
> > We have a board in development which includes a ksz9567 switch, whose
> > cpu port is connected to a lan7801 usb chip. This works fine up until
> > 5.18, but is broken in 5.19. The kernel log contains
> > 
> >  ksz9477-switch 4-005f lan1 (uninitialized): validation of gmii with
> > support 00000000,00000000,000062ff and advertisement
> > 00000000,00000000,000062ff failed: -EINVAL
> >  ksz9477-switch 4-005f lan1 (uninitialized): failed to connect to PHY:
> > -EINVAL
> >  ksz9477-switch 4-005f lan1 (uninitialized): error -22 setting up PHY
> > for tree 0, switch 0, port 0
> > 
> > and similar lines for the other four ports.
> 
> I think this is because the phylink_get_caps callback does not set
> PHY_INTERFACE_MODE_GMII for ports with integrated PHY, which is the
> default interface mode for phylib.
> 
> You can try this and see if it works (not even compile tested):
> 
> ---
> diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
> index 92a500e1ccd2..0d8044f2bd38 100644
> --- a/drivers/net/dsa/microchip/ksz_common.c
> +++ b/drivers/net/dsa/microchip/ksz_common.c
> @@ -453,9 +453,16 @@ void ksz_phylink_get_caps(struct dsa_switch *ds, int port,
>         if (dev->info->supports_rgmii[port])
>                 phy_interface_set_rgmii(config->supported_interfaces);
>  
> -       if (dev->info->internal_phy[port])
> +       if (dev->info->internal_phy[port]) {
>                 __set_bit(PHY_INTERFACE_MODE_INTERNAL,
>                           config->supported_interfaces);
> +
> +               /* GMII is the default interface mode for phylib, so
> +                * we have to support it for ports with integrated PHY.
> +                */
> +               __set_bit(PHY_INTERFACE_MODE_GMII,
> +                         config->supported_interfaces);
> +       }
>  }
>  EXPORT_SYMBOL_GPL(ksz_phylink_get_caps);

What a strange coincidence, yesterday we got the exact same bug report but for KSZ8:
https://lore.kernel.org/netdev/967ef480-2fac-9724-61c7-2d5e69c26ec3@leemhuis.info/
