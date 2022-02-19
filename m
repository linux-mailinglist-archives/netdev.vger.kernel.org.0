Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DFEF4BCAB3
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 22:14:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230130AbiBSVNJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Feb 2022 16:13:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiBSVNG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Feb 2022 16:13:06 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D186E3B3D7
        for <netdev@vger.kernel.org>; Sat, 19 Feb 2022 13:12:44 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id d10so23129474eje.10
        for <netdev@vger.kernel.org>; Sat, 19 Feb 2022 13:12:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Vm0kJ+Ecs5FNTEqY8yBGY9MZ2qx05zgERhNLj5CQBSI=;
        b=h/TD0744+PY7Kx3IZAcio7oaHrHuOCMNe2ZCdpaf6TEMwMkNmQsoXIGeBPK6fzzS1J
         Qcj2otXPvfP2F8ynSHDxgsbCH5tyAy4Nkj7fh1GwE4fL4NdXOWgV8MSfxdJWfGfoFdRd
         n478mCSbIcqsn4juRnvJFMy3Rc2vYsyIOj813HekdyuwxOGpoVo8MFfG74u4JDon8vDD
         eXhvJIRiw0sTemyXTS9+Dwk/S022aJyM8kQTnYsJ/LWvYn1U/zL2XSiaDv+C1KmT9o98
         4cIR8eVuWPvQck7A6EH68Mwz9AWPLfurmdZT20hMorCskviIaNc74tjyAy/R/Ye5ZRbV
         qfDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Vm0kJ+Ecs5FNTEqY8yBGY9MZ2qx05zgERhNLj5CQBSI=;
        b=Kzw587PLZjl3oHs3GhlkA0ev4zByRbpivH4Aw6k/yl0AOqCdU/OY7HcirFMTVXeDL0
         n1PoCbCR5n3nChXSE9+j0bFSkiDGIm4k5AOWV5ax/iBAXYc8jP77yl14g+qUmq12tQPS
         Mcva5Te61ApIc3yCpWKzCerPaQSUe5zwf9DDUD0Hd6pOxougTXQnTN7IKGYskbGYOpGz
         wPDrR8vmbNJQ4v5OSpT4+v5SyoOVbAaLH98PMf2IgiCWpwPvAlnBFU7S2jo8P0KWsZ5G
         Pgxc9+tuicP1Onb2IOswk1lsAjRe/I9BX546PZjmh2Mpj4s4NXL2bP+NOg4GG8com9Uk
         RN4g==
X-Gm-Message-State: AOAM531N1J9z73yFthxitXe8dFC3frvj/xN9+eHhsyFrmkwaxK9nyp3Z
        8DNEFRqKSxxe4VvtbjY9vt8=
X-Google-Smtp-Source: ABdhPJxb40R+4C8gbFVsXyVZRWYxB803fnJDbd590vRQjewFlCS1xnZYYVNhccelVZp4TeII8MVnng==
X-Received: by 2002:a17:906:255a:b0:6ce:3732:6f5f with SMTP id j26-20020a170906255a00b006ce37326f5fmr11034517ejb.565.1645305163256;
        Sat, 19 Feb 2022 13:12:43 -0800 (PST)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id b7sm3618375ejl.145.2022.02.19.13.12.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Feb 2022 13:12:42 -0800 (PST)
Date:   Sat, 19 Feb 2022 23:12:41 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net-next v2 1/6] net: dsa: add support for phylink
 mac_select_pcs()
Message-ID: <20220219211241.beyajbwmuz7fg2bt@skbuf>
References: <Yg6UHt2HAw7YTiwN@shell.armlinux.org.uk>
 <E1nKlY3-009aKs-Oo@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1nKlY3-009aKs-Oo@rmk-PC.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Thu, Feb 17, 2022 at 06:30:35PM +0000, Russell King (Oracle) wrote:
> Add DSA support for the phylink mac_select_pcs() method so DSA drivers
> can return provide phylink with the appropriate PCS for the PHY
> interface mode.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---
>  include/net/dsa.h |  3 +++
>  net/dsa/port.c    | 15 +++++++++++++++
>  2 files changed, 18 insertions(+)
> 
> diff --git a/include/net/dsa.h b/include/net/dsa.h
> index 85cb9aed4c51..87aef3ed88a7 100644
> --- a/include/net/dsa.h
> +++ b/include/net/dsa.h
> @@ -788,6 +788,9 @@ struct dsa_switch_ops {
>  	void	(*phylink_validate)(struct dsa_switch *ds, int port,
>  				    unsigned long *supported,
>  				    struct phylink_link_state *state);
> +	struct phylink_pcs *(*phylink_mac_select_pcs)(struct dsa_switch *ds,
> +						      int port,
> +						      phy_interface_t iface);
>  	int	(*phylink_mac_link_state)(struct dsa_switch *ds, int port,
>  					  struct phylink_link_state *state);
>  	void	(*phylink_mac_config)(struct dsa_switch *ds, int port,
> diff --git a/net/dsa/port.c b/net/dsa/port.c
> index cca5cf686f74..d8534fd9fab9 100644
> --- a/net/dsa/port.c
> +++ b/net/dsa/port.c
> @@ -1053,6 +1053,20 @@ static void dsa_port_phylink_mac_pcs_get_state(struct phylink_config *config,
>  	}
>  }
>  
> +static struct phylink_pcs *
> +dsa_port_phylink_mac_select_pcs(struct phylink_config *config,
> +				phy_interface_t interface)
> +{
> +	struct dsa_port *dp = container_of(config, struct dsa_port, pl_config);
> +	struct dsa_switch *ds = dp->ds;
> +	struct phylink_pcs *pcs = NULL;
> +
> +	if (ds->ops->phylink_mac_select_pcs)
> +		pcs = ds->ops->phylink_mac_select_pcs(ds, dp->index, interface);
> +
> +	return pcs;
> +}
> +
>  static void dsa_port_phylink_mac_config(struct phylink_config *config,
>  					unsigned int mode,
>  					const struct phylink_link_state *state)
> @@ -1119,6 +1133,7 @@ static void dsa_port_phylink_mac_link_up(struct phylink_config *config,
>  
>  static const struct phylink_mac_ops dsa_port_phylink_mac_ops = {
>  	.validate = dsa_port_phylink_validate,
> +	.mac_select_pcs = dsa_port_phylink_mac_select_pcs,

This patch breaks probing on DSA switch drivers that weren't converted
to supported_interfaces, due to this check in phylink_create():

	/* Validate the supplied configuration */
	if (mac_ops->mac_select_pcs &&
	    phy_interface_empty(config->supported_interfaces)) {
		dev_err(config->dev,
			"phylink: error: empty supported_interfaces but mac_select_pcs() method present\n");
		return ERR_PTR(-EINVAL);
	}

>  	.mac_pcs_get_state = dsa_port_phylink_mac_pcs_get_state,
>  	.mac_config = dsa_port_phylink_mac_config,
>  	.mac_an_restart = dsa_port_phylink_mac_an_restart,
> -- 
> 2.30.2
> 
