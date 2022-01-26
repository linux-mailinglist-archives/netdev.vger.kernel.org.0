Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10F9D49CACF
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 14:30:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239639AbiAZNaf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 08:30:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239570AbiAZNac (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 08:30:32 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C52D0C061747
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 05:30:31 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id a28so32910137lfl.7
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 05:30:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=41gfOK3SwjHN5QGLkwbAzzyj+KqK0hiE/9CoXJsNy30=;
        b=fazgTc8LYb2smVQ9HIHKZum2qBRuwRdewGBr6Nb1DMBW7ikf8wauel84++vEdeQflr
         910HrL8zmfvJ34plx+JbFRO2MUVzAMhPlsh5idqEO2AN+YjiJcCD6N4JyZ+uuYbCm8lv
         dcJdy10hsa+Dxi1v3OT3/5/psct8K1aayjkbfXnxU8qJGeqh4m2/RGAOlILJUhJnx7cj
         IMBVK8R2Lnp4n2cyWKQP6sELFsL06YYcRUrExNy88Elk957U/rHV7rX+CUeme6gV/T2O
         cykUT7d+OEQd4znkAKG0fLbVLexvgelbgxbyG0pmgEG4FUUH101nYKZG+p11GjuS26X3
         bRQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=41gfOK3SwjHN5QGLkwbAzzyj+KqK0hiE/9CoXJsNy30=;
        b=c8rnB8AG8nCRV65EhZBpdrEOGDKaAeEJCjMC1d+BqJg7ByCLXjJRbPLjep9M9EePAz
         SyL8/7zE3M4Hwz9U2JUH4CVt1Y6z2n1s/j/SXPqQKEg1fLPFpaRtDO9BddyKlyZThpzU
         GhAGdEjbIyDmFXmQRapxs/xGItJTc2Rdix5uYQuUdgGmtQLqj3b8lDzdJa2ewWs/6w+4
         yz3l7ivbUE6bsjZe7qfK4IsueorAYpRnvNVLESCzXzPuYIi63QbSHI4mDGPOmr1RUb4K
         BxhdvtUhQrlwl9x1dkxIGLTxtsL2xRtxSz7c8haKB1MizYA9FG1pTDrOimMWEs7GcZet
         /tTA==
X-Gm-Message-State: AOAM532SEDmnlmZwn3jgQZV1CbfWGFBfkPmjZaC2BcfVNGxLahFKl6g4
        Ng0KV7YngH+CjfrAv0QGwylnkPrVHc2wig==
X-Google-Smtp-Source: ABdhPJwgZnK1VTV9czEZu8TldMygF0tKYTolQG20/RIdfWmw9JA0z6P14IouH5OT+t781NWHyRuirg==
X-Received: by 2002:a19:431e:: with SMTP id q30mr8353511lfa.285.1643203829807;
        Wed, 26 Jan 2022 05:30:29 -0800 (PST)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id p15sm1828709lfc.307.2022.01.26.05.30.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 05:30:29 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Marcin Wojtas <mw@semihalf.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Markus Koch <markus@notsyncing.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 4/5] net/fsl: xgmac_mdio: Support setting the
 MDC frequency
In-Reply-To: <YfFHmkFXtlVus9IW@lunn.ch>
References: <20220126101432.822818-1-tobias@waldekranz.com>
 <20220126101432.822818-5-tobias@waldekranz.com> <YfFHmkFXtlVus9IW@lunn.ch>
Date:   Wed, 26 Jan 2022 14:30:28 +0100
Message-ID: <87r18ubp57.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 26, 2022 at 14:07, Andrew Lunn <andrew@lunn.ch> wrote:
> Hi Tobias
>
>>  struct mdio_fsl_priv {
>>  	struct	tgec_mdio_controller __iomem *mdio_base;
>> +	struct clk *enet_clk;
>
> It looks like there is a whitespace issue here?
>

Ahh, sorry about that!

>> +	u32	mdc_freq;
>>  	bool	is_little_endian;
>>  	bool	has_a009885;
>>  	bool	has_a011043;
>> @@ -255,6 +258,34 @@ static int xgmac_mdio_read(struct mii_bus *bus, int phy_id, int regnum)
>>  	return ret;
>>  }
>>  
>> +static void xgmac_mdio_set_mdc_freq(struct mii_bus *bus)
>> +{
>> +	struct mdio_fsl_priv *priv = (struct mdio_fsl_priv *)bus->priv;
>> +	struct tgec_mdio_controller __iomem *regs = priv->mdio_base;
>> +	struct device *dev = bus->parent;
>> +	u32 mdio_stat, div;
>> +
>> +	if (device_property_read_u32(dev, "clock-frequency", &priv->mdc_freq))
>> +		return;
>> +
>> +	priv->enet_clk = devm_clk_get(dev, NULL);
>> +	if (IS_ERR(priv->enet_clk)) {
>> +		dev_err(dev, "Input clock unknown, not changing MDC frequency");
>
> Is the clock optional or mandatory?

As the code is now, it is mandatory. I could add some default frequency,
but I fear that could do more harm than good?

> If mandatory, then i would prefer -ENODEV and fail the probe.
>
>> +		return;
>> +	}
>> +
>> +	div = ((clk_get_rate(priv->enet_clk) / priv->mdc_freq) - 1) / 2;
>> +	if (div < 5 || div > 0x1ff) {
>> +		dev_err(dev, "Requested MDC frequecy is out of range, ignoring");
>
> and here return -EINVAL.
>
> I always think it is best to make it obvious something is broken. One
> additional line on the console can be missed for a while. All the
> Ethernet devices missing because the PHYs are missing, because the
> MDIO bus is missing is going to get noticed very quickly.

Darn, the last thing I did was to change this from a hard to a soft
error :)

Ok, no worries about regressions for deployed stuff already out there?
