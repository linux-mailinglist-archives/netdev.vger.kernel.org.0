Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6862865EE54
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 15:05:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234437AbjAEOFp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 09:05:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234452AbjAEOF0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 09:05:26 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D4FA5D42C;
        Thu,  5 Jan 2023 06:04:25 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id vm8so83358148ejc.2;
        Thu, 05 Jan 2023 06:04:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MIRXXRB+sw2omNtjMhkV2HFQPFTLCgL9wZ2vi4bV6S0=;
        b=QEYOhyxvDuZKucaFK5ymbZjBykJO3QlfnVvtHvGJb4alIwc0mOYX35B6PQ9+zUHkf5
         KgBzJNyeqmEUlxiBdAp3T9wwBiToTrCuhlN+kI2ZyXE3V9Bbr6nI9xNL/9OHUCiWSlmk
         CMUms4jTsAv6yvxIrhkPkJDKqKRTUrinl1OHBQweJEruL5uRGKY+uBkXoPAg2KWeTKLj
         nFMsxFhSysGs3H3vWFE9HXGwvoPJzTGxWIl7ZtQSznNNHH+iKqf6dDcBXMHl4TBYFReL
         RS/VBEtaRvfE21sqoG/KHa4zUB2BANsXi6BTgOaaRkNxQdwvKPnbpJWf9YRXngfns4i2
         Oaow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MIRXXRB+sw2omNtjMhkV2HFQPFTLCgL9wZ2vi4bV6S0=;
        b=2+12yAxk3RQZQjgTV4cnLvUjGJbrh183/ySTCTDVYHqb8tP044htcAMpoc3xGDG5RU
         T/740gBjkb6uVw+QyqcuXXuykB00+3QmEP6Tx9fR9YjLxjH4W1/ZxZY+6694RZbmJaqo
         x3uiQkA/AZdl5Sn3/HqW+7P7Hr/CyqMyPHuQk8tA6Lwjur0BF/zgwE1Ap9XQFgA92Hcc
         d8cuCRRQJXQWAtILMm+9lrAZxt4Hq2XOF+FVHaNLzar0o6oup5jYYnaiw+Xh2DJG7jVt
         PcKcDiAQxo+knoSjhKJcie0XeIRuLvNZoiQrMaw/BIGvCchyZIT7prlA3xYZaLMgmQrT
         skaA==
X-Gm-Message-State: AFqh2kpZCXbWl0CF756rxfJhUREwxQ5vjUtdtAevIMuF8YZs7gaUapKX
        H6IPp2laWuWBKl5u/KL15S8=
X-Google-Smtp-Source: AMrXdXv35xPx9swlre+rFgoitFWWHdm9wKBXF8gloEDID6Jfjmyd+RgShsJEKfVgHi3NYBP3G/KW9A==
X-Received: by 2002:a17:907:8b0a:b0:7c0:ae13:7407 with SMTP id sz10-20020a1709078b0a00b007c0ae137407mr48620138ejc.3.1672927464143;
        Thu, 05 Jan 2023 06:04:24 -0800 (PST)
Received: from skbuf ([188.26.184.223])
        by smtp.gmail.com with ESMTPSA id kx20-20020a170907775400b0078d3f96d293sm16562530ejc.30.2023.01.05.06.04.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 06:04:23 -0800 (PST)
Date:   Thu, 5 Jan 2023 16:04:21 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Tim Harvey <tharvey@gateworks.com>
Subject: Re: [PATCH net-next v5 4/4] phy: aquantia: Determine rate adaptation
 support from registers
Message-ID: <20230105140421.bqd2aed6du5mtxn4@skbuf>
References: <20230103220511.3378316-1-sean.anderson@seco.com>
 <20230103220511.3378316-5-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230103220511.3378316-5-sean.anderson@seco.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 03, 2023 at 05:05:11PM -0500, Sean Anderson wrote:
>  static int aqr107_get_rate_matching(struct phy_device *phydev,
>  				    phy_interface_t iface)
>  {
> -	if (iface == PHY_INTERFACE_MODE_10GBASER ||
> -	    iface == PHY_INTERFACE_MODE_2500BASEX ||
> -	    iface == PHY_INTERFACE_MODE_NA)
> -		return RATE_MATCH_PAUSE;
> -	return RATE_MATCH_NONE;
> +	static const struct aqr107_link_speed_cfg speed_table[] = {
> +		{
> +			.speed = SPEED_10,
> +			.reg = VEND1_GLOBAL_CFG_10M,
> +			.speed_bit = MDIO_PMA_SPEED_10,
> +		},
> +		{
> +			.speed = SPEED_100,
> +			.reg = VEND1_GLOBAL_CFG_100M,
> +			.speed_bit = MDIO_PMA_SPEED_100,
> +		},
> +		{
> +			.speed = SPEED_1000,
> +			.reg = VEND1_GLOBAL_CFG_1G,
> +			.speed_bit = MDIO_PMA_SPEED_1000,
> +		},
> +		{
> +			.speed = SPEED_2500,
> +			.reg = VEND1_GLOBAL_CFG_2_5G,
> +			.speed_bit = MDIO_PMA_SPEED_2_5G,
> +		},
> +		{
> +			.speed = SPEED_5000,
> +			.reg = VEND1_GLOBAL_CFG_5G,
> +			.speed_bit = MDIO_PMA_SPEED_5G,
> +		},
> +		{
> +			.speed = SPEED_10000,
> +			.reg = VEND1_GLOBAL_CFG_10G,
> +			.speed_bit = MDIO_PMA_SPEED_10G,
> +		},
> +	};
> +	int speed = phy_interface_max_speed(iface);
> +	bool got_one = false;
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(speed_table) &&
> +		    speed_table[i].speed <= speed; i++) {
> +		if (!aqr107_rate_adapt_ok(phydev, speed, &speed_table[i]))
> +			return RATE_MATCH_NONE;
> +		got_one = true;
> +	}

Trying to wrap my head around the API for rate matching that was
originally proposed and how it applies to what we read from Aquantia
registers now.

IIUC, phylink (via the PHY library) asks "what kind of rate matching is
supported for this SERDES protocol?". It doesn't ask "via what kind of
rate matching can this SERDES protocol support this particular media
side speed?".

Your code walks through the speed_table[] of media speeds (from 10M up
until the max speed of the SERDES) and sees whether the PHY was
provisioned, for that speed, to use PAUSE rate adaptation.

If the PHY firmware uses a combination like this: 10GBASE-R/XFI for
media speeds of 10G, 5G, 2.5G (rate adapted), and SGMII for 1G, 100M
and 10M, a call to your implementation of
aqr107_get_rate_matching(PHY_INTERFACE_MODE_10GBASER) would return
RATE_MATCH_NONE, right? So only ETHTOOL_LINK_MODE_10000baseT_Full_BIT
would be advertised on the media side?

Shouldn't you take into consideration in your aqr107_rate_adapt_ok()
function only the media side link speeds for which the PHY was actually
*configured* to use the SERDES protocol @iface?

> +
> +	/* Must match at least one speed */
> +	return got_one ? RATE_MATCH_PAUSE : RATE_MATCH_NONE;
>  }
