Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B94BA64A276
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 14:54:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233230AbiLLNyk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 08:54:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233216AbiLLNyN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 08:54:13 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE75C2AF5;
        Mon, 12 Dec 2022 05:54:12 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id fc4so28096730ejc.12;
        Mon, 12 Dec 2022 05:54:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YrqnHu9WTeRN234a31B5lZIUWTkJP7oJ2r4I37DZ9Cc=;
        b=R8JumW17wBW6T2M+cCmPxYNeoDabzGl6wDAEDaMggdQJyFMhhN8poEKRNTzyq3FO8E
         4kgdpM2uc0Qk7FY4QqE0ZQNbOE5Y+K7bYDz5U4NJb8hkyhxO+F5sHPYTmCQWdN1CLVMR
         Wv328q22uM00GKX0JY1zMRCIPH+me3o/XOYVWtRaNC1BeulnFTnn7/YXe3OOyadiBt+O
         nehb7iZRqJOoQ4eNVnUdjwpbkHlYFH7dKsg7QKxDjydUKaDVuCJIlQirLfXvtK5RaYxn
         zC7GlW8ODlX068JBM9NTQSadQoQLP6cQZofeYWLfpXSzFCgiuBYDdFiHnh6Rojo9Ova0
         R2Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YrqnHu9WTeRN234a31B5lZIUWTkJP7oJ2r4I37DZ9Cc=;
        b=LAPWzMol1k76hMEgERFa3sbAwzVSt8Ns04sMNbNg/it2nC3cO+70PIKqJp9YWhPPFL
         DBVSqGFhjrVKn7IV75Jgo4q65dBIa1tQm87FhPol4HNNddnUByR1rpuLzh4FPx4oqjkV
         VKnWxYv76tGMiJetAOtkJ6FWz85oMC/mQPI10awDlIa97W7itbMspOrbT4Gc35INLd9f
         xtAcC+JocRW+irMAKqyzb8iiCAsQK2HE2AsrdPQVSSGUbPsNKVBUyOSM1qCBYJm9FI9s
         AdGebswSoJiameqEUtVDU69iYZ5Tf9qYB9S/9bIzsrrf7DlAMXCcOGuhszyGPPCbLTen
         5xcA==
X-Gm-Message-State: ANoB5plnBG79gYKzVALU49pZLLy5fI82mls5MC4R2Zz1weFeeuuOivz8
        Iko+44bwrDEnhgNfZyqD5vo=
X-Google-Smtp-Source: AA0mqf7VYG8pqqbA/vGlObK6vZxT6V1VD8sX8M3KMu+IZL0oUF6BnGFItKcfKJk/7dNIo3B0OgYktQ==
X-Received: by 2002:a17:906:f2d5:b0:7c0:ff76:dc12 with SMTP id gz21-20020a170906f2d500b007c0ff76dc12mr13226446ejb.2.1670853251387;
        Mon, 12 Dec 2022 05:54:11 -0800 (PST)
Received: from skbuf ([188.27.185.63])
        by smtp.gmail.com with ESMTPSA id ss2-20020a170907c00200b007c100eba66asm3322351ejc.77.2022.12.12.05.54.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 05:54:10 -0800 (PST)
Date:   Mon, 12 Dec 2022 15:54:08 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Claudiu Beznea <claudiu.beznea@microchip.com>
Cc:     nicolas.ferre@microchip.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux@armlinux.org.uk, andrew@lunn.ch, hkallweit1@gmail.com,
        sergiu.moga@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] net: phylink: init phydev on phylink_resume()
Message-ID: <20221212135408.j23agcjrikiucq4a@skbuf>
References: <20221212112845.73290-1-claudiu.beznea@microchip.com>
 <20221212112845.73290-2-claudiu.beznea@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221212112845.73290-2-claudiu.beznea@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Claudiu,

On Mon, Dec 12, 2022 at 01:28:44PM +0200, Claudiu Beznea wrote:
> There are scenarios where PHY power is cut off on system suspend.
> There are also MAC drivers which handles themselves the PHY on
> suspend/resume path. For such drivers the
> struct phy_device::mac_managed_phy is set to true and thus the
> mdio_bus_phy_suspend()/mdio_bus_phy_resume() wouldn't do the
> proper PHY suspend/resume. For such scenarios call phy_init_hw()
> from phylink_resume().
> 
> Suggested-by: Russell King (Oracle) <linux@armlinux.org.uk>
> Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
> ---
> 
> Hi, Russel,
> 
> I let phy_init_hw() to execute for all devices. I can restrict it only
> for PHYs that has struct phy_device::mac_managed_phy = true.
> 
> Please let me know what you think.
> 
> Thank you,
> Claudiu Beznea
> 
> 
>  drivers/net/phy/phylink.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> index 09cc65c0da93..6003c329638e 100644
> --- a/drivers/net/phy/phylink.c
> +++ b/drivers/net/phy/phylink.c
> @@ -2031,6 +2031,12 @@ void phylink_resume(struct phylink *pl)
>  {
>  	ASSERT_RTNL();
>  
> +	if (pl->phydev) {
> +		int ret = phy_init_hw(pl->phydev);
> +		if (ret)
> +			return;
> +	}
> +

If the config_init() method of the driver does things such as this:

	phydev->mdix_ctrl = ETH_TP_MDI_AUTO;

like for example the marvell10g.c driver, won't a user-configured manual
MDI setting get overwritten after a suspend/resume cycle?

>  	if (test_bit(PHYLINK_DISABLE_MAC_WOL, &pl->phylink_disable_state)) {
>  		/* Wake-on-Lan enabled, MAC handling */
>  
> -- 
> 2.34.1
> 
