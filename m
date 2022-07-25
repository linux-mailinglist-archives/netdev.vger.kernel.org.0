Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A67645802A8
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 18:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236074AbiGYQ1t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 12:27:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236065AbiGYQ1s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 12:27:48 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 279F61CFD0
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 09:27:47 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id 17so10951145pfy.0
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 09:27:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=rXFH9U3T2tSrxlBT2C8C0ifoE8gVIhTOKlHJ8pnn3Xk=;
        b=mtTiW8rI0Fpsx7VCHWakBKd2J980LTCPGXI51IPUBYWZK90K1iG9XeoY/IJ65oT+o0
         ahvt+5dO2MlbiUHuxJf8e/2NwlaLtKsv8l/LMACQGmTrX3b1F+ufEfJOPx5DiH2RvNaS
         5ASvIy2AnlG89SKaiTNBeYKteIMJ6plIR8dE3ic84f8cXZ0KoV96D/M08XpbWdYv1DkJ
         NFGQoMndnOOSaC3ILWYubKEHXLhTht0ura/KwgmfghR28M8jps0BD0lVWF0kzkBD2cAD
         EQ1V7LEYyu5elOxB4wR1gPngLLTDjD0v4ZZ1078yvg43B9VH5vTF0lIbwCtRsYJwB1XP
         m0og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=rXFH9U3T2tSrxlBT2C8C0ifoE8gVIhTOKlHJ8pnn3Xk=;
        b=db+SncRY4E5rcVc5KoD/PY+mbRq2xFrFD0+VVialK5Fj3/YNPzeHf8GLDH1Zz0HSt9
         ZVMdXzSuysgsDckbchWY2dP8BjsnN5WbMx1IOfyGRn1X6GJRkbwhGaKC7Q/2x9E9tA4I
         n19ovkSSmko/8tO20zqE79VuBVs8i/twzX/C/TMmdbPlsgdY4RwMymYatmoUhIGOKUu8
         mEAUwcFRMr1BCnguTFNb+peNQ/FL8un4Wj68qKpbpp6s7/d73pkpNP+p3i0S9UfR4TG5
         D5hTlQLKV+IFgGx3ww2fFLWFvF1jg2piHCt+7L6hwsOGVl920Zvcfg/SMY9dlpeRxIVs
         L6+g==
X-Gm-Message-State: AJIora+PA/B+MKVKqAE2W+xAlMZOzUOvXTp7TUoJ7JxLhMxtsIoYgSS2
        m6p4WmxU+3ffKsbKj9gcxwQ=
X-Google-Smtp-Source: AGRyM1vKVs+UPkBLwqJZAtkJyXdH/uxNdg/JArEfjQF/QeG/87vd2nDiQyjB0yX2Hjx8xJjoKgJHVA==
X-Received: by 2002:a63:d90b:0:b0:41a:ff05:4808 with SMTP id r11-20020a63d90b000000b0041aff054808mr4624345pgg.159.1658766466587;
        Mon, 25 Jul 2022 09:27:46 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id me5-20020a17090b17c500b001f29ba338c1sm6472464pjb.2.2022.07.25.09.27.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Jul 2022 09:27:46 -0700 (PDT)
Message-ID: <41ef4895-0450-c0ae-558c-45cdd4f8739b@gmail.com>
Date:   Mon, 25 Jul 2022 09:27:42 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next] net: dsa: validate that DT nodes of shared ports
 have the properties they need
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Mans Rullgard <mans@mansr.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Aleksander Jan Bajkowski <olek2@wp.pl>,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alsi@bang-olufsen.dk>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Pawel Dembicki <paweldembicki@gmail.com>,
        =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Russell King <rmk+kernel@armlinux.org.uk>
References: <20220723164635.1621911-1-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220723164635.1621911-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/23/22 09:46, Vladimir Oltean wrote:

[snip]

> +static int dsa_shared_port_validate_of_node(struct dsa_port *dp,
> +					    const char *description)
> +{
> +	struct device_node *dn = dp->dn, *phy_np;
> +	struct dsa_switch *ds = dp->ds;
> +	phy_interface_t mode;
> +
> +	/* Suppress validation if using platform data */
> +	if (!dn)
> +		return 0;
> +
> +	if (of_device_compatible_match(ds->dev->of_node,
> +				       dsa_switches_skipping_validation))
> +		return 0;
> +
> +	if (of_get_phy_mode(dn, &mode)) {
> +		dev_err(ds->dev,
> +			"%s port %d lacks the required \"phy-mode\" property\n",
> +			description, dp->index);
> +		return -EINVAL;
> +	}
> +
> +	phy_np = of_parse_phandle(dn, "phy-handle", 0);
> +	if (phy_np) {
> +		of_node_put(phy_np);
> +		return 0;
> +	}
> +
> +	/* Note: of_phy_is_fixed_link() also returns true for
> +	 * managed = "in-band-status"
> +	 */
> +	if (of_phy_is_fixed_link(dn))
> +		return 0;

To echo back my reply from the other email here, if we look beyond the rabbit hole and also attempt to parse these properties from the device_node pointed to us by the "ethernet" property, then I think we can trim down the list, and we still have some assurance that we can use phylink and a fixed link property, except we have to replicate the information from the CPU-port connected Ethernet controller.

> +
> +	/* TODO support SFP cages on DSA/CPU ports,
> +	 * here and in dsa_port_link_register_of()
> +	 */
> +	dev_err(ds->dev,
> +		"%s port %d lacks the required \"phy-handle\", \"fixed-link\" or \"managed\" properties\n",
> +		description, dp->index);
> +
> +	return -EINVAL;
> +}
> +
>  static int dsa_port_parse_user(struct dsa_port *dp, const char *name)
>  {
>  	if (!name)
> @@ -1373,6 +1534,12 @@ static int dsa_port_parse_user(struct dsa_port *dp, const char *name)
>  
>  static int dsa_port_parse_dsa(struct dsa_port *dp)
>  {
> +	int err;
> +
> +	err = dsa_shared_port_validate_of_node(dp, "DSA");
> +	if (err)
> +		return err;
> +
>  	dp->type = DSA_PORT_TYPE_DSA;

Move up the assignment so you can just read the type from dsa_shared_port_validate_of_node()?

>  
>  	return 0;
> @@ -1411,6 +1578,11 @@ static int dsa_port_parse_cpu(struct dsa_port *dp, struct net_device *master,
>  	struct dsa_switch_tree *dst = ds->dst;
>  	const struct dsa_device_ops *tag_ops;
>  	enum dsa_tag_protocol default_proto;
> +	int err;
> +
> +	err = dsa_shared_port_validate_of_node(dp, "CPU");
> +	if (err)
> +		return err;

Likewise, I don't think there are adverse effects of moving up the dp->type assignment all the way to the top?

>  
>  	/* Find out which protocol the switch would prefer. */
>  	default_proto = dsa_get_tag_protocol(dp, master);


-- 
Florian
