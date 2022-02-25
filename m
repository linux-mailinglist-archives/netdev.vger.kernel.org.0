Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1BED4C4299
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 11:41:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238509AbiBYKlT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 05:41:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239780AbiBYKlQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 05:41:16 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73B651ACA27
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 02:40:41 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id hw13so9940780ejc.9
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 02:40:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wZcUWaksnyFVw+fcU2TDV2LVHNwbuNPYGGYaMH5LNis=;
        b=m8/vh4QxNDqdsEs0yEpLvV33L72dKlkuJipfP2DWs9n0PI4h0djRyL+fV4RKviIn9G
         N8BcyS93SeT89Nwje4z4ZmFMsopyMBunk0B7NHy5mzO+F7K/lBDniLPLEhDaceW8DgYb
         1X2JZ/kN9s/qDhnYy+bMxl7OMtGTjdLVE71sNr7qnDONEcaFqtvvwT31Ag1KeK588eT9
         Hsn4cT1qft1HdjHLtKEoNwGEh+2i9raqToRn1NbzHaGUAAdUle9WJBDsbToh1qqOhzlW
         hNmlUJfmn9rqqCnX5q+vixwxDhG0+1+DBAdKwzuyPJaRVytHZcT79YT+gk2h6OtygoRv
         pQCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wZcUWaksnyFVw+fcU2TDV2LVHNwbuNPYGGYaMH5LNis=;
        b=qMTR9k0LcnPvL4RJiJI4zYGiEP66UuUOAmI8lS9kb/m9OqYjoioWwrAmPHIlHJViur
         6a9WGqgEaXaghoo9JdqVuzTl4tlMd2iC19tl5TEjZs14VulCrFlx9kbpeQXtlDKBZypQ
         Q3O1UAF3TohbjTF3e0GAC+SZdUR9GKu94M1/kBBNjfyI6/XfTdsgsCQYMgzZWjjwA2ti
         Y56dYQgAWUfu/DYs+/2nWG9A/by1D2ZITNh3lJ1qTqTPt0rbq2RpA5zOf8tmA/+fuUfs
         wY/FbO3NeKIUUpfp9oQ4viDXj+vb1ZDxms/HmU1p5Oybp9X1p6ZXhgkGcHU3HFQ+OcY/
         haHg==
X-Gm-Message-State: AOAM531f1e1VAC0UwYkwC71Qp0saW+KO09vo+vgN1i5YZ5ztRVrTdhHM
        2pOHGdJI1BPMDpAKaYMUdzI=
X-Google-Smtp-Source: ABdhPJy9R4IZLlCiQzzpnjSJ9gxTGaPhX4WyRyAutwOZRQWqixpRvSPn9mcDgq3DIW6oC6rhkdsjbg==
X-Received: by 2002:a17:907:9956:b0:6cf:cd25:c5a7 with SMTP id kl22-20020a170907995600b006cfcd25c5a7mr5387533ejc.635.1645785639864;
        Fri, 25 Feb 2022 02:40:39 -0800 (PST)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id d4-20020a056402000400b00412d60fee38sm1148448edu.11.2022.02.25.02.40.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Feb 2022 02:40:39 -0800 (PST)
Date:   Fri, 25 Feb 2022 12:40:38 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Marek Beh__n <kabel@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC net-next 4/6] net: dsa: sja1105: mark as non-legacy
Message-ID: <20220225104038.buvxphxm4o5cc4jt@skbuf>
References: <YhevAJyU87bfCzfs@shell.armlinux.org.uk>
 <E1nNGmB-00AOj0-A8@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1nNGmB-00AOj0-A8@rmk-PC.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 24, 2022 at 04:15:31PM +0000, Russell King (Oracle) wrote:
> The sja1105 DSA driver does not have a phylink_mac_config() method
> implementation, it is safe to mark this as a non-legacy driver.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

>  drivers/net/dsa/sja1105/sja1105_main.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
> index b5c36f808df1..8f061cce77f0 100644
> --- a/drivers/net/dsa/sja1105/sja1105_main.c
> +++ b/drivers/net/dsa/sja1105/sja1105_main.c
> @@ -1396,6 +1396,12 @@ static void sja1105_phylink_get_caps(struct dsa_switch *ds, int port,
>  {
>  	struct sja1105_private *priv = ds->priv;
>  
> +	/* This driver does not make use of the speed, duplex, pause or the
> +	 * advertisement in its mac_config, so it is safe to mark this driver
> +	 * as non-legacy.
> +	 */
> +	config->legacy_pre_march2020 = false;
> +
>  	/* The SJA1105 MAC programming model is through the static config
>  	 * (the xMII Mode table cannot be dynamically reconfigured), and
>  	 * we have to program that early.
> -- 
> 2.30.2
> 
