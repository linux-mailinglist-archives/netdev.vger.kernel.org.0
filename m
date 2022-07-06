Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 043CF56857C
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 12:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232198AbiGFK0d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 06:26:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbiGFK01 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 06:26:27 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A2502612C
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 03:26:26 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id f23so2036825ejc.4
        for <netdev@vger.kernel.org>; Wed, 06 Jul 2022 03:26:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SjRmVROgCVCrD68mnMllqSYMo0WntjWjA9LHp6o9oqA=;
        b=h452JCJnpG7zK1uEExxGDG1FY4Hi8dSeNLe1kHcxTsFX4KW+GQOfDktDGUWDlvzn8+
         KFs53/28jO+EcrGpZE/lAigEIpSL29aYT4vl2tVBb7tPgmNF9V5W/pCIoWRmtUvcXPRG
         AzgMPQNFOF8+m1TCzBV0ptAu/kpEFHUcEn6qSqTpPTU6kKwyaEIocypEW7TpULcEvDwe
         sHH4UjWMGX1/cTWXz7LwBKz+eLB2cUuEHqxjvyswRi3ARvO7SuscsBKrN2hwqIlHQPmg
         e3at6kDn8WVtg5QxYJGj+S1nlY70le1uFqmt5iMMOXQ/uSGq7v370lGVA8G6DBrqzcnn
         H4XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SjRmVROgCVCrD68mnMllqSYMo0WntjWjA9LHp6o9oqA=;
        b=m6Btb7va7UBMbU4CIs8WKMTw7sE8OXFoAIS4/tukhgukMwP3zflONkct+9MynPOaAa
         JY693xI3D3U5/uLzoSx2Q0bwBJmU+gitsxEhdP57fRBbLLHEQh8+wap70fMv3e+TNOnD
         M4Se0doJtZi4jGyaFrkVP2IYN6W7xZtN5mAPYaxVvPPvi6C+poQXwa/VHZqIm5KHP4j9
         L4FAD+Lin0uElmdPKsWvxCByht8qxJMzn51ludkgR5M61a/bSRbY6/py6eJ/uScpM52A
         nwnWSz/x37eWdu4gQVXIkfs5Sk6qRa9m2Gdu4CLUV1gDHPHjltKlk6z/8Alq5QnvWGfs
         W4iA==
X-Gm-Message-State: AJIora93Y60kkBUDrGyAcIT0SSMBsazjIiz5zy2O7S+WQU775t6uQJBB
        z+KY23vuZHWNTSCg2K4MH/I=
X-Google-Smtp-Source: AGRyM1uku0il88KlzBKlOIlDgPqYgrK6xuOSEqnGuVCo1KHCmKWAVPGNlq/47Q03sMFpOBjdzU1G9g==
X-Received: by 2002:a17:907:7e81:b0:726:2912:7467 with SMTP id qb1-20020a1709077e8100b0072629127467mr38178464ejc.373.1657103185019;
        Wed, 06 Jul 2022 03:26:25 -0700 (PDT)
Received: from skbuf ([188.26.185.61])
        by smtp.gmail.com with ESMTPSA id p4-20020a056402154400b0043a46f5fb82sm7370964edx.73.2022.07.06.03.26.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 03:26:23 -0700 (PDT)
Date:   Wed, 6 Jul 2022 13:26:21 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Alvin __ipraga <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        DENG Qingfang <dqfext@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Sean Wang <sean.wang@mediatek.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>
Subject: Re: [PATCH RFC net-next 5/5] net: dsa: always use phylink for CPU
 and DSA ports
Message-ID: <20220706102621.hfubvn3wa6wlw735@skbuf>
References: <YsQIjC7UpcGWJovx@shell.armlinux.org.uk>
 <E1o8fA7-0059aO-K8@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1o8fA7-0059aO-K8@rmk-PC.armlinux.org.uk>
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

On Tue, Jul 05, 2022 at 10:48:07AM +0100, Russell King (Oracle) wrote:
> diff --git a/net/dsa/port.c b/net/dsa/port.c
> index 35b4e1f8dc05..34487e62eb03 100644
> --- a/net/dsa/port.c
> +++ b/net/dsa/port.c
> @@ -1525,6 +1525,7 @@ int dsa_port_phylink_create(struct dsa_port *dp)
>  {
>  	struct dsa_switch *ds = dp->ds;
>  	phy_interface_t mode, def_mode;
> +	struct device_node *phy_np;
>  	int err;
>  
>  	/* Presence of phylink_mac_link_state or phylink_mac_an_restart is
> @@ -1559,6 +1560,13 @@ int dsa_port_phylink_create(struct dsa_port *dp)
>  		return PTR_ERR(dp->pl);
>  	}
>  
> +	if (dp->type == DSA_PORT_TYPE_CPU || dp->type == DSA_PORT_TYPE_DSA) {
> +		phy_np = of_parse_phandle(dp->dn, "phy-handle", 0);
> +		of_node_put(phy_np);
> +		if (!phy_np)
> +			err = phylink_set_max_fixed_link(dp->pl);

Can we please limit phylink_set_max_link_speed() to just the CPU ports
where a fixed-link property is also missing, not just a phy-handle?
Although to be entirely correct, we can also have MLO_AN_INBAND, which
wouldn't be covered by these 2 checks and would still represent a valid
DT binding.

> +	}
> +
>  	return 0;
>  }
>  
> @@ -1663,20 +1671,14 @@ static int dsa_port_phylink_register(struct dsa_port *dp)
>  int dsa_port_link_register_of(struct dsa_port *dp)
>  {
>  	struct dsa_switch *ds = dp->ds;
> -	struct device_node *phy_np;
>  	int port = dp->index;
>  
>  	if (!ds->ops->adjust_link) {
> -		phy_np = of_parse_phandle(dp->dn, "phy-handle", 0);
> -		if (of_phy_is_fixed_link(dp->dn) || phy_np) {
> -			if (ds->ops->phylink_mac_link_down)
> -				ds->ops->phylink_mac_link_down(ds, port,
> -					MLO_AN_FIXED, PHY_INTERFACE_MODE_NA);
> -			of_node_put(phy_np);
> -			return dsa_port_phylink_register(dp);
> -		}
> -		of_node_put(phy_np);
> -		return 0;
> +		if (ds->ops->phylink_mac_link_down)
> +			ds->ops->phylink_mac_link_down(ds, port,
> +				MLO_AN_FIXED, PHY_INTERFACE_MODE_NA);

Can you please align these arguments to the open bracket?

> +
> +		return dsa_port_phylink_register(dp);
>  	}
>  
>  	dev_warn(ds->dev,
> -- 
> 2.30.2
> 
