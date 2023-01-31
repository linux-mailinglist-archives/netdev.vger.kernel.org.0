Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFC996837E4
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 21:52:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230265AbjAaUwn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 15:52:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbjAaUwm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 15:52:42 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B057F521DE;
        Tue, 31 Jan 2023 12:52:36 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id mf7so26660903ejc.6;
        Tue, 31 Jan 2023 12:52:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lSs89qXjTQ67Cde0i1nwbdabu1mpbTofnuOIiF2jamU=;
        b=puOZp64/rB7iq147HrZ8f3XHaz4XNqfzYfMjdLsWixo2g9JisfjIMfoPRRASoSg8WA
         2cc1J5PdQwpWoxYfLQaxlEfJwRnXN4p9f1piy87sCzv0GRhsG2YHvBW3cd5IwukBB9tb
         38v3MIWmyzfimzcLydv1EFRdlNWYsSF3Qu+6DvELfkJdTDHRcm0VY3ouZ+H6+Z99q4Os
         +6ro+AHoWFxv83az+4dIIVObH+vTodkp7lU1Cri5FO8jl0JyhdkpfQJTqi7xmu78UG6W
         CrwO7XoDIImkJwOFsVxcqAW00RoSFL5pZHUw9fxzXs0zib1B23HojIxJEy87lu87jdaM
         AQ3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lSs89qXjTQ67Cde0i1nwbdabu1mpbTofnuOIiF2jamU=;
        b=vkJRroLJClqlXFWx7MVOpcerP4FRCTlLOdrqmT88jnx0Go603Kns8zBh9flUsOds4l
         uhuz8XaI2gXilWy9LOVWfQwBDTxJxT+LGzbRYmPbOD5zl+aWDx8RxpGGLZJQfsJ878a/
         a9xasqkberwvYauuDJRX+LmM89fnyP81z/gavF8HPLymP72ROpFZ2UufiAYH/SkP44Zb
         J5aS5ea5hh4UjAuNgZ0q05DAlv8Iw5XyPrjmOy1jQuD3P1IOokMB0yQBUnq2PZBEzQdP
         9aJjVQ48HJAgj+2f72++pu1lIgxLLrneYnufkyq6WTWzJ5euUH7PiVqTHa4hk+l4fAg2
         YK+A==
X-Gm-Message-State: AO0yUKXzJTGfxqhYoGss840xrdNuvD1CitwyrzBhygFhDdOY/ZPowlz4
        v3dIDhW9IxZ27ghZOUiH6a4=
X-Google-Smtp-Source: AK7set9BprxGZZAx8NBw50XtsoSvyvR+wAIULUeJ77MJiHfUVEhhZOfawZNA61B22ck3up1IMWBYYA==
X-Received: by 2002:a17:906:274a:b0:88a:292d:be8c with SMTP id a10-20020a170906274a00b0088a292dbe8cmr3866166ejd.22.1675198354884;
        Tue, 31 Jan 2023 12:52:34 -0800 (PST)
Received: from skbuf ([188.25.255.186])
        by smtp.gmail.com with ESMTPSA id v24-20020a1709067d9800b008857fe10c5csm4971768ejo.126.2023.01.31.12.52.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 12:52:34 -0800 (PST)
Date:   Tue, 31 Jan 2023 22:52:31 +0200
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
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Arun.Ramadoss@microchip.com
Subject: Re: [PATCH net-next v3 15/15] net: fec: add support for PHYs with
 SmartEEE support
Message-ID: <20230131205231.ck3xnziejgtr64ig@skbuf>
References: <20230130080714.139492-1-o.rempel@pengutronix.de>
 <20230130080714.139492-16-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230130080714.139492-16-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 30, 2023 at 09:07:14AM +0100, Oleksij Rempel wrote:
> Ethernet controller in i.MX6*/i.MX7* series do not provide EEE support.
> But this chips are used sometimes in combinations with SmartEEE capable
> PHYs.
> So, instead of aborting get/set_eee access on MACs without EEE support,
> ask PHY if it is able to do the EEE job by using SmartEEE.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  drivers/net/ethernet/freescale/fec_main.c | 22 ++++++++++++++++++----
>  1 file changed, 18 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
> index e6238e53940d..25a2a9d860de 100644
> --- a/drivers/net/ethernet/freescale/fec_main.c
> +++ b/drivers/net/ethernet/freescale/fec_main.c
> @@ -3102,8 +3102,15 @@ fec_enet_get_eee(struct net_device *ndev, struct ethtool_eee *edata)
>  	struct fec_enet_private *fep = netdev_priv(ndev);
>  	struct ethtool_eee *p = &fep->eee;
>  
> -	if (!(fep->quirks & FEC_QUIRK_HAS_EEE))
> -		return -EOPNOTSUPP;
> +	if (!(fep->quirks & FEC_QUIRK_HAS_EEE)) {
> +		if (!netif_running(ndev))
> +			return -ENETDOWN;
> +
> +		if (!phy_has_smarteee(ndev->phydev))
> +			return -EOPNOTSUPP;
> +
> +		return phy_ethtool_get_eee(ndev->phydev, edata);

I see many places in the fec driver guarding against a NULL
ndev->phydev, and TBH I don't completely understand why.
I guess it's because ndev->phydev is populated at fec_enet_open() time.

But then again, if the netif_running() check is sufficient to imply
presence of ndev->phydev as you suggest, then why does fec_enet_ioctl()
have this?

	if (!netif_running(ndev))
		return -EINVAL;

	if (!phydev)
		return -ENODEV;

Asking because phy_init_eee(), phy_ethtool_set_eee() and
phy_ethtool_get_eee() don't support being called with a NULL phydev.
