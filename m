Return-Path: <netdev+bounces-7438-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EB6972047E
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 16:30:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DC2BD28197C
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 14:30:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 420A63D7A;
	Fri,  2 Jun 2023 14:30:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3565A19BC7
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 14:30:25 +0000 (UTC)
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 793E79F
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 07:30:24 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id 5b1f17b1804b1-3f606912ebaso21583685e9.3
        for <netdev@vger.kernel.org>; Fri, 02 Jun 2023 07:30:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685716223; x=1688308223;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IG41cu9uTI8OX8K2UEb0GiOZqEF8uyVDonOH0Uh3Wzo=;
        b=Nw1PaGF14LPcN9PBQiAwEHU8dOEV0k7jEa+1fHI9UZMKNlSn1FyLlcWA8HPYeRiUfj
         rCPtedfbn8dufVnfRmJmDZHG08ehFECFDbrHiVBI/Jm4XRAzIjygyxrIXGwtTa9LruTV
         NKk5S9s2C2d76cjEgqBxXW57/dlOwF+WQ04CveR4leE6J1mE1DmtwTCRAU2X2TJ8qSzB
         XCe3+yGUiBicZkYKmtpxkQigjB5DFqMZfwS75QbLFRb0S2GAD1fKMM14f5PHn5JdrGzD
         A6guccsRrbQ9bFy1LIi4cT4ZuE4IOXVpzJTyQc9RNA8tsVGOBkfBlXRkZsBOjQGd0uFK
         e59Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685716223; x=1688308223;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IG41cu9uTI8OX8K2UEb0GiOZqEF8uyVDonOH0Uh3Wzo=;
        b=VFbKtkjSS0+t/JatNSYCEVAyDv0N9/0u5pejfFuX3M5DIVR5YW8JcBY+xyrCXvCwKA
         jmpsiRgbDgtvNWoQyBRL5K6mbBg+JQOe7UNQxSSgye0THSB5ZwX+cdhWe33Hd6UX/60U
         senfT7GCIfa6gxgGV7AVOMGTe1cBvnck4CfSnBGhy1qkwySKtkealiFtMhLljnvpjyqA
         rYD6Biarc6BOFIeG/4YWR4H+/p4bbhXjhWSe/mG3GKFbzvfVJ7rKGa3MTklTM+8bewRW
         BvALKilx0/7pWXF5oiFFYbYny+AYFC3Jeov/IYrRAG03DiNBfJQpG2j/6Up4+EF1y0ng
         crOg==
X-Gm-Message-State: AC+VfDwKnHf+0zB+ECZcx45taKWOdxw/6S1zBQ+cQXP1Zu8rknBIXIx/
	wWIj1N+IpIKO//vFIY/sVHZghA+cz4WlwQ==
X-Google-Smtp-Source: ACHHUZ6Kvb8lSgvrvjy6Pv4VzI+/YH0tVlxrTx74kQcpISfyBuarRqGfXBB4O7hykWX/cCP6cJtFLA==
X-Received: by 2002:a05:600c:b42:b0:3f1:7581:eaaf with SMTP id k2-20020a05600c0b4200b003f17581eaafmr2072502wmr.4.1685716222672;
        Fri, 02 Jun 2023 07:30:22 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id y20-20020a05600c365400b003f60a446fe5sm2134070wmq.29.2023.06.02.07.30.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jun 2023 07:30:22 -0700 (PDT)
Date: Fri, 2 Jun 2023 17:30:20 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc: Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Jose Abreu <Jose.Abreu@synopsys.com>, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next 1/3] net: dsa: sja1105: allow XPCS to handle
 mdiodev lifetime
Message-ID: <20230602143020.w7czsg5ldqpkqhep@skbuf>
References: <ZHn1cTGFtEQ1Rv6E@shell.armlinux.org.uk>
 <E1q55IZ-00Bp4w-6V@rmk-PC.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1q55IZ-00Bp4w-6V@rmk-PC.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 02, 2023 at 02:58:35PM +0100, Russell King (Oracle) wrote:
> Put the mdiodev after xpcs_create() so that the XPCS driver can manage
> the lifetime of the mdiodev its using.

nitpick: "it's using"

> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---
>  drivers/net/dsa/sja1105/sja1105_mdio.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/net/dsa/sja1105/sja1105_mdio.c b/drivers/net/dsa/sja1105/sja1105_mdio.c
> index 01f1cb719042..166fe747f70a 100644
> --- a/drivers/net/dsa/sja1105/sja1105_mdio.c
> +++ b/drivers/net/dsa/sja1105/sja1105_mdio.c
> @@ -417,6 +417,7 @@ static int sja1105_mdiobus_pcs_register(struct sja1105_private *priv)
>  		}
>  
>  		xpcs = xpcs_create(mdiodev, priv->phy_mode[port]);
> +		mdio_device_put(mdiodev);
>  		if (IS_ERR(xpcs)) {
>  			rc = PTR_ERR(xpcs);
>  			goto out_pcs_free;
> @@ -434,7 +435,6 @@ static int sja1105_mdiobus_pcs_register(struct sja1105_private *priv)
>  		if (!priv->xpcs[port])
>  			continue;
>  
> -		mdio_device_free(priv->xpcs[port]->mdiodev);
>  		xpcs_destroy(priv->xpcs[port]);
>  		priv->xpcs[port] = NULL;
>  	}
> @@ -457,7 +457,6 @@ static void sja1105_mdiobus_pcs_unregister(struct sja1105_private *priv)
>  		if (!priv->xpcs[port])
>  			continue;
>  
> -		mdio_device_free(priv->xpcs[port]->mdiodev);
>  		xpcs_destroy(priv->xpcs[port]);
>  		priv->xpcs[port] = NULL;
>  	}
> -- 
> 2.30.2
> 

So before this patch, sja1105 was using xpcs with an mdiodev refcount
of 2 (a transition phase after commit 9a5d500cffdb ("net: pcs: xpcs: add
xpcs_create_mdiodev()")), and now it's back to using it with a refcount
of 1? okay.

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>

