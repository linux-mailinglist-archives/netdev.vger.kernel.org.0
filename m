Return-Path: <netdev+bounces-12204-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 82BAB736B16
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 13:34:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4168A28123D
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 11:34:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4343514262;
	Tue, 20 Jun 2023 11:34:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31AABBA38
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 11:34:35 +0000 (UTC)
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D845FE
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 04:34:34 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id 4fb4d7f45d1cf-51a3f911135so5343482a12.2
        for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 04:34:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687260873; x=1689852873;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=shC1wW8egsl/kkJUojZpbSUfOxdSs0wwTEFd98MBfII=;
        b=N+8/VAECjPNF5CGLmJf3WkhwtsjCPoLz3qb9lew2B7UFtTjvvpI8UIfiWKyVEZtoFn
         mvY/LVm+za17ayclBdp5GIPEufdWIsCat/8+uVtmC6yac2xAr2l9igZLTdTUrDC4ntzo
         d0R7SvpTnsQrhFA0CA/WFwQp9zIDqPi787Qn7XPDOFQCoGe9Dc/7rhnOA7XJNvucxxSZ
         EHFjOeHhOrjb/ACf3zyNZoI4VK+0kxN2JLg0jVbVIHTeH9FRthPU59oMDq0wvxAdYlbg
         5sEs6xXPIm0PP78USFKARdIx6wlpwX+pBnuUhDUIs1QL3A62t6BSO/mDwAthhb8LeKoq
         mn9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687260873; x=1689852873;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=shC1wW8egsl/kkJUojZpbSUfOxdSs0wwTEFd98MBfII=;
        b=Rw+j4RLC6CGcnEc2XYbXMW+J/qOjyq41s7oQERBiSPVNKeyI5owYuStQZg+X7VpnkJ
         5U7ipEW1Sp/GLQvb4dcEKQTIeKIcx0J5kUzdw1lgL+eCUBEJN6I6VyPuFYT4E92ptUD6
         FdkZwUtcHeeypAOJIQLdVyAIMpMjok72lq25UfqRpxoJXrFr3OEIVVfy+WfY5BodjmmW
         +l5dmuhmTvYPremG3BnVMEp5AfzFBEDRFvv39TgUrLJaC0MjV/+/qwv5pmywhY6YZfea
         Dg/SbmCT4B98dBlgLdb2v+W+ASMqNx8Q3E+Y6qlAY7zvFay4sXQpNcNwxw9Zh4RJlYcJ
         jeSQ==
X-Gm-Message-State: AC+VfDx+vrIh6rl0wv8PJ9RlTl4xz7fF0BZ7YAAlIQa/aSLnjkrnjTqw
	06oAxwMW37K81WDHZgwmUPU=
X-Google-Smtp-Source: ACHHUZ7kcy+fdMi6pnZntxAPk3QpwuAjE8bdOKK+o8YucFhnGvYOEU0g5ysWDLAIywJRYejH22YorA==
X-Received: by 2002:a05:6402:350:b0:51a:53f3:704e with SMTP id r16-20020a056402035000b0051a53f3704emr3991784edw.30.1687260872835;
        Tue, 20 Jun 2023 04:34:32 -0700 (PDT)
Received: from skbuf ([188.25.159.134])
        by smtp.gmail.com with ESMTPSA id u12-20020aa7db8c000000b0051a2edb49b0sm1055193edt.63.2023.06.20.04.34.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jun 2023 04:34:32 -0700 (PDT)
Date: Tue, 20 Jun 2023 14:34:29 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc: Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Alexander Couzens <lynxis@fe80.eu>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Cc@web.codeaurora.org:Claudiu Beznea <claudiu.beznea@microchip.com>,
	Daniel Golle <daniel@makrotopia.org>,
	Daniel Machon <daniel.machon@microchip.com>,
	"David S. Miller" <davem@davemloft.net>,
	DENG Qingfang <dqfext@gmail.com>, Eric Dumazet <edumazet@google.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Jose Abreu <Jose.Abreu@synopsys.com>,
	Landen Chao <Landen.Chao@mediatek.com>,
	Lars Povlsen <lars.povlsen@microchip.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org,
	Madalin Bucur <madalin.bucur@nxp.com>,
	Marcin Wojtas <mw@semihalf.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Michal Simek <michal.simek@amd.com>, netdev@vger.kernel.org,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
	Sean Anderson <sean.anderson@seco.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Steen Hegelund <Steen.Hegelund@microchip.com>,
	Taras Chornyi <taras.chornyi@plvision.eu>,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next 01/15] net: phylink: add PCS negotiation mode
Message-ID: <20230620113429.mc4p4y6mny5cm4ih@skbuf>
References: <ZIxQIBfO9dH5xFlg@shell.armlinux.org.uk>
 <E1qA8De-00EaFA-Ht@rmk-PC.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1qA8De-00EaFA-Ht@rmk-PC.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 16, 2023 at 01:06:22PM +0100, Russell King (Oracle) wrote:
> PCS have to work out whether they should enable PCS negotiation by
> looking at the "mode" and "interface" arguments, and the Autoneg bit
> in the advertising mask.
> 
> This leads to some complex logic, so lets pull that out into phylink
> and instead pass a "neg_mode" argument to the PCS configuration and
> link up methods, instead of the "mode" argument.
> 
> In order to transition drivers, add a "neg_mode" flag to the phylink
> PCS structure to PCS can indicate whether they want to be passed the
> neg_mode or the old mode argument.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---
> diff --git a/include/linux/phylink.h b/include/linux/phylink.h
> index 0cf07d7d11b8..2b322d7fa51a 100644
> --- a/include/linux/phylink.h
> +++ b/include/linux/phylink.h
> @@ -21,6 +21,24 @@ enum {
>  	MLO_AN_FIXED,	/* Fixed-link mode */
>  	MLO_AN_INBAND,	/* In-band protocol */
>  
> +	/* PCS "negotiation" mode.
> +	 *  PHYLINK_PCS_NEG_NONE - protocol has no inband capability
> +	 *  PHYLINK_PCS_NEG_OUTBAND - some out of band or fixed link setting

Would OUTBAND be more clearly named as FORCED maybe?

> +	 *  PHYLINK_PCS_NEG_INBAND_DISABLED - inband mode disabled, e.g.
> +	 *				      1000base-X with autoneg off
> +	 *  PHYLINK_PCS_NEG_INBAND_ENABLED - inband mode enabled
> +	 * Additionally, this can be tested using bitmasks:
> +	 *  PHYLINK_PCS_NEG_INBAND - inband mode selected
> +	 *  PHYLINK_PCS_NEG_ENABLED - negotiation mode enabled
> +	 */
> +	PHYLINK_PCS_NEG_NONE = 0,
> +	PHYLINK_PCS_NEG_ENABLED = BIT(4),

Why do we start the enum values from BIT(4)? What are we colliding with,
in the range of lower values?

> +	PHYLINK_PCS_NEG_OUTBAND = BIT(5),
> +	PHYLINK_PCS_NEG_INBAND = BIT(6),
> +	PHYLINK_PCS_NEG_INBAND_DISABLED = PHYLINK_PCS_NEG_INBAND,
> +	PHYLINK_PCS_NEG_INBAND_ENABLED = PHYLINK_PCS_NEG_INBAND |
> +					 PHYLINK_PCS_NEG_ENABLED,
> +
>  	/* MAC_SYM_PAUSE and MAC_ASYM_PAUSE are used when configuring our
>  	 * autonegotiation advertisement. They correspond to the PAUSE and
>  	 * ASM_DIR bits defined by 802.3, respectively.
> @@ -79,6 +97,70 @@ static inline bool phylink_autoneg_inband(unsigned int mode)
>  	return mode == MLO_AN_INBAND;
>  }
>  
> +/**
> + * phylink_pcs_neg_mode() - helper to determine PCS inband mode

I think you are naming it "neg_mode" rather than "aneg_mode" because
with OUTBAND/NONE, there's nothing "automatic" about the negotiation.
However, "neg" rather than "aneg" sounds more like a shorthand form of
"negation" or "negative". Would you oppose renaming it to "aneg_mode"?

