Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEAF166ADE8
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 21:54:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230420AbjANUx7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Jan 2023 15:53:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230358AbjANUx5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Jan 2023 15:53:57 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE35F59F4;
        Sat, 14 Jan 2023 12:53:55 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id bk15so2234068ejb.9;
        Sat, 14 Jan 2023 12:53:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RtfroO9MvUUjijZ+zMpXqbkwNTL3sFa668iAzURnyg0=;
        b=A0ckwpbkdrVCiCgJo81JrSP/kDK+XkbToAk1FWZfy0Xkh9WBUcB8AAWFoivvbrxYYC
         mvRXx9YWJ1WyxLH51gLABhpyPeArkBkuG6hCOogGvZbTxgl6DzjA24pl8VpTM1J7/tKb
         w+XVisey+EftmsEUbuZaYULvIuPlthOJMuaxxbDsvbkBiVFuTNw5wXWu4lVOKVm8ZQv5
         06G6AWenurvgx6O+o+tNSOsZ5fk2sx49aFY4ie3+SJLEKlj4/DnS4Zf4Wh5i9KeFf0r5
         zBgWhOzV7eqb0sH8X3LPd6r63wwhqkjsQ/Cd8gziZvjTLnx3rrIN5d2BlWUL1XLQCIXD
         s9Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RtfroO9MvUUjijZ+zMpXqbkwNTL3sFa668iAzURnyg0=;
        b=e2YTxSeg8sffIAGMj449dl54wa1wiGpQStjY9VtyoxgDci+66kvXVLQJPunrNtCDdJ
         ht1biahLCJcc1K8msDdsYRLuXN4o0wha5O8Ap43bh5hCPrQkgyj/Gpo9nTuWKecW/0j0
         AbNSJKy4yD1ShPQgFvSstaMWREwHCrQf9cH4JR+/0lX1hsuLx0Po/NVCMn0eXEz0ls5o
         JfZd5N6HQ1Uk7dLzTLUEan6l8tvTTcSsv+RORcy3jz283oO+5JCdGAoVhZRc5vw2tKkK
         h2zGpCF+dB7EoDRS2xxWzNKsUR4laAzFHmR2xNnlwHFzBMgj88s4d/co8mOpNHJbDeue
         bgOg==
X-Gm-Message-State: AFqh2kpJJuWIlPP2GxLUCEwHms/8Ug2MFND3PMBI6A8cp82H9HN9bDK+
        CC+ECh5qhbZgMU+lrZ5KfSY=
X-Google-Smtp-Source: AMrXdXvDrbndCeQAeb8F7Fl6alzczODQfJnl20jKSNBOgc6FupJtaGs9z0blhgaAjXIsjb8DZWobxA==
X-Received: by 2002:a17:907:d311:b0:7c4:e7b0:8491 with SMTP id vg17-20020a170907d31100b007c4e7b08491mr77381823ejc.61.1673729634453;
        Sat, 14 Jan 2023 12:53:54 -0800 (PST)
Received: from skbuf ([188.27.184.249])
        by smtp.gmail.com with ESMTPSA id r12-20020a170906364c00b0084c70c27407sm9893924ejb.84.2023.01.14.12.53.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Jan 2023 12:53:53 -0800 (PST)
Date:   Sat, 14 Jan 2023 22:53:51 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jerry Ray <jerry.ray@microchip.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>, jbe@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v6 5/6] dsa: lan9303: Port 0 is xMII port
Message-ID: <20230114205351.czy2fkfrulrl4w6k@skbuf>
References: <20230109211849.32530-1-jerry.ray@microchip.com>
 <20230109211849.32530-6-jerry.ray@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230109211849.32530-6-jerry.ray@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 09, 2023 at 03:18:48PM -0600, Jerry Ray wrote:
> In preparing to move the adjust_link logic into the phylink_mac_link_up
> api, change the macro used to check for the cpu port. In
> phylink_mac_link_up, the phydev pointer passed in for the CPU port is
> NULL, so we can't keep using phy_is_pseudo_fixed_link(phydev).
> 
> Signed-off-by: Jerry Ray <jerry.ray@microchip.com>
> ---
> v5->v6:
>   Using port 0 to identify the xMII port on the LAN9303.
> ---
>  drivers/net/dsa/lan9303-core.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
> index 792ce6a26a6a..7be4c491e5d9 100644
> --- a/drivers/net/dsa/lan9303-core.c
> +++ b/drivers/net/dsa/lan9303-core.c
> @@ -1063,7 +1063,11 @@ static void lan9303_adjust_link(struct dsa_switch *ds, int port,
>  {
>  	int ctl;
>  
> -	if (!phy_is_pseudo_fixed_link(phydev))
> +	/* On this device, we are only interested in doing something here if
> +	 * this is an xMII port. All other ports are 10/100 phys using MDIO
> +	 * to control there link settings.
> +	 */
> +	if (port != 0)

Maybe a macro LAN9303_XMII_PORT would be good, if it was also
consistently used in lan9303_setup()?

>  		return;
>  
>  	ctl = lan9303_phy_read(ds, port, MII_BMCR);
> -- 
> 2.17.1
> 
