Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7753F1F6092
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 05:32:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbgFKDbP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 23:31:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726290AbgFKDbP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 23:31:15 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2624BC08C5C1;
        Wed, 10 Jun 2020 20:31:15 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id m1so1942131pgk.1;
        Wed, 10 Jun 2020 20:31:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ifqf2Un5jE0l1zQWqbZs5hLwhdORiEodHIoMd3lL3Rc=;
        b=BJg2vKRXRBP4qd7PsJWhRANUxbJR80RTC4Yt6Y8Q6qdg2u3BCJUTu5JpXtBBQIoXQG
         y0H4622bWrBJU4T0zHyEn3tnqGedf58VGlIeJ83oIWr+DPW/jLM25XlsNn5MPioWkLj4
         id97tpB3/tbhDPZkNDDi88bevqOkvuR/Zsf33Q1bGBnWVEecJe46OcykldH+s1V08CuM
         BlLvDt9uhOzLpDaxAQlczJxeLjLQ3JWwSD3xspbbqOIkna7y1yu+BQrUHrkw1eer4BQm
         KvdnFO5fShnj35p40YBeqsOwTqdyE5IUW9H8h7LHEb4oiZIlkDVOdZazHh/1Esm8EpWY
         unyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ifqf2Un5jE0l1zQWqbZs5hLwhdORiEodHIoMd3lL3Rc=;
        b=PxtwUNr7v/Ak57keNjpilUOWeaa+UdWSXi/mcrH9IhEow23F8AQ9m10pfjpcYGsnfH
         QNHG5WmdYP5Xbth1uVGsPafHYuW0wq7CjLBN1/1Yu+5bfdL50ZIJfqzRHCjUikBxLVEi
         XgqBSZbRfCqKsq30mvExoR+TlR+GCIGeS9ci7XjulQoED68cD1Bog2BvtjvzvnesvTZG
         +eiZ+ksKnOVcleHmNWRr7mli1QVlYiuFS3oeke4hMPRr63Q4uiCIGl9zZH87jYkoSznl
         SK/JzOxvOZ/KZ5EODW6fbpd3Okp3Zn/8F2h08OlHRTTHZ3zEN86gngnpUNi2E2pFA4dd
         HCmA==
X-Gm-Message-State: AOAM530xmLfOGI0uidFeiYuOdVqOrATA2y71Ih/vZpImF+0F/AqCV9Vg
        YBtD+Rlvn0SLA91P8xTtk/pdTZmJ
X-Google-Smtp-Source: ABdhPJwXy+eJ3GCr9pnFxPxMuhxo+cDmsg3cYqt0silefEXhio+jrQ4+zPl5AyAHsviBwLXKqJZRFQ==
X-Received: by 2002:a62:3645:: with SMTP id d66mr5621823pfa.275.1591846274091;
        Wed, 10 Jun 2020 20:31:14 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x77sm1338008pfc.4.2020.06.10.20.31.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Jun 2020 20:31:13 -0700 (PDT)
Subject: Re: [PATCH 2/2] net: dsa: qca8k: Improve SGMII interface handling
To:     Jonathan McDowell <noodles@earth.li>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1591816172.git.noodles@earth.li>
 <2150f4c70c754aed179e46e166f3c305254cf85a.1591816172.git.noodles@earth.li>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <9d7d09d5-393f-d5bd-5c57-78c914bdc850@gmail.com>
Date:   Wed, 10 Jun 2020 20:31:11 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <2150f4c70c754aed179e46e166f3c305254cf85a.1591816172.git.noodles@earth.li>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/10/2020 12:15 PM, Jonathan McDowell wrote:
> This patch improves the handling of the SGMII interface on the QCA8K
> devices. Previously the driver did no configuration of the port, even if
> it was selected. We now configure it up in the appropriate
> PHY/MAC/Base-X mode depending on what phylink tells us we are connected
> to and ensure it is enabled.
> 
> Tested with a device where the CPU connection is RGMII (i.e. the common
> current use case) + one where the CPU connection is SGMII. I don't have
> any devices where the SGMII interface is brought out to something other
> than the CPU.
> 
> Signed-off-by: Jonathan McDowell <noodles@earth.li>
> ---
>  drivers/net/dsa/qca8k.c | 28 +++++++++++++++++++++++++++-
>  drivers/net/dsa/qca8k.h | 13 +++++++++++++
>  2 files changed, 40 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> index dcd9e8fa99b6..33e62598289e 100644
> --- a/drivers/net/dsa/qca8k.c
> +++ b/drivers/net/dsa/qca8k.c
> @@ -681,7 +681,7 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
>  			 const struct phylink_link_state *state)
>  {
>  	struct qca8k_priv *priv = ds->priv;
> -	u32 reg;
> +	u32 reg, val;
>  
>  	switch (port) {
>  	case 0: /* 1st CPU port */
> @@ -740,6 +740,32 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
>  	case PHY_INTERFACE_MODE_1000BASEX:
>  		/* Enable SGMII on the port */
>  		qca8k_write(priv, reg, QCA8K_PORT_PAD_SGMII_EN);
> +
> +		/* Enable/disable SerDes auto-negotiation as necessary */
> +		val = qca8k_read(priv, QCA8K_REG_PWS);
> +		if (phylink_autoneg_inband(mode))
> +			val &= ~QCA8K_PWS_SERDES_AEN_DIS;
> +		else
> +			val |= QCA8K_PWS_SERDES_AEN_DIS;
> +		qca8k_write(priv, QCA8K_REG_PWS, val);
> +
> +		/* Configure the SGMII parameters */
> +		val = qca8k_read(priv, QCA8K_REG_SGMII_CTRL);
> +
> +		val |= QCA8K_SGMII_EN_PLL | QCA8K_SGMII_EN_RX |
> +			QCA8K_SGMII_EN_TX | QCA8K_SGMII_EN_SD;
> +
> +		val &= ~QCA8K_SGMII_MODE_CTRL_MASK;
> +		if (dsa_is_cpu_port(ds, port)) {
> +			/* CPU port, we're talking to the CPU MAC, be a PHY */
> +			val |= QCA8K_SGMII_MODE_CTRL_PHY;

Since port 6 can be interfaced to an external PHY, do not you have to
differentiate here whether this port is connected to an actual PHY,
versus connected to a MAC? You should be able to use mode == MLO_AN_PHY
to differentiate that case from the others.

> +		} else if (state->interface == PHY_INTERFACE_MODE_SGMII) {
> +			val |= QCA8K_SGMII_MODE_CTRL_MAC;
> +		} else {
> +			val |= QCA8K_SGMII_MODE_CTRL_BASEX;

Better make this explicit and check for PHY_INTERFACE_MODE_1000BASEX,
even if those are the only two possible values covered by this part of
the case statement.
-- 
Florian
