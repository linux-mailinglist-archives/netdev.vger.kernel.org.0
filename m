Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4948E425486
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 15:45:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241668AbhJGNr2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 09:47:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241536AbhJGNr1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 09:47:27 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B2B5C061570;
        Thu,  7 Oct 2021 06:45:33 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id t16so1458122eds.9;
        Thu, 07 Oct 2021 06:45:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=E+L+Wf7T2Owcsoh/9oeTRFjF2XYJmuQTubfTOTv8RUQ=;
        b=dna3fPOCY61Yr8YaGu45UfNQl7yiPxRWlcy/YaJ7DuckrOuxhhlEzZELPt/GX4eZYR
         mHJjvWpdIAygYQ23eAlM7tK6Fdv4eE3rM9jzB3hXRnTlQmTBA04/Y88+LTPxB7NA/C3T
         WYHeUghL5MuZZDleEVFFcAt4juIRdyApwcOUU3H57dVm44U98WmmHupEC+hVw8F+0Ltc
         U+f4jFwBSQ/35bNBN5nLFw/mc1gICZwKjHIvDeWenrMv3SBYX16CvAxpwQpsNAkQpi7W
         BNIpCyd//9LEi08LHMINTNSnZgwXo7UNsSNTM5nieHVmgx5dKdE6/pirSKzcNQDstQE/
         EuOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=E+L+Wf7T2Owcsoh/9oeTRFjF2XYJmuQTubfTOTv8RUQ=;
        b=BFvvLvrVaNwOxdUie3E+UXs2CwIzc5jOmG6MqLo+NxQGxEgmwnyTNf+bqh0DWWWaX6
         4KigFjGwkQ3Oyn/1uLBLunUaXH8Dq6vYWcDSbtZbFRg5m/roJFi7c+DyIAYG20ZuKtg8
         V6lLjNJQZ/fsbLJXdR24btdentlzqi2Ws1ceeO28xdYx6a8n/pxNCTEfGeYuPK5c9eP2
         kU8ComzJP+7chjnl1Ox7bMlbaZfaW2nZhB+ND/x+8humRZWBC5LBjBhoRe5i1imSjZwG
         cg5VLziNL/qvoaTAmRAAAp5tEBQqyMgZPfPCcxxRBAH+QQwVuNik8vPMyiRDrfpGe4xG
         zyUw==
X-Gm-Message-State: AOAM533gU0rMk8gEzpuBo6abppZcZoT+EWuX1rCOyec3U4QrarblzBKb
        NXfRhgJn+/rJX2I+zSCEO7UxjllTH+c=
X-Google-Smtp-Source: ABdhPJwsGFQPWm0CvXOPf+vGxUP6xJfYlgkwyA1BUukCw39e7fBUgMnp5hjDJ2X0eo/05VCws5STqQ==
X-Received: by 2002:a17:906:71d4:: with SMTP id i20mr5809591ejk.390.1633614327933;
        Thu, 07 Oct 2021 06:45:27 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id r6sm356647edv.42.2021.10.07.06.45.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 06:45:27 -0700 (PDT)
Date:   Thu, 7 Oct 2021 15:45:25 +0200
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH 12/13] drivers: net: dsa: qca8k: add support for
 pws config reg
Message-ID: <YV759SSdKu0w83UB@Ansuel-xps.localdomain>
References: <20211006223603.18858-1-ansuelsmth@gmail.com>
 <20211006223603.18858-13-ansuelsmth@gmail.com>
 <YV5CJvb2k1/61IU2@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YV5CJvb2k1/61IU2@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 07, 2021 at 02:41:10AM +0200, Andrew Lunn wrote:
> > +static int
> > +qca8k_setup_of_pws_reg(struct qca8k_priv *priv)
> > +{
> > +	struct device_node *node = priv->dev->of_node;
> > +	u32 val = 0;
> > +
> > +	if (priv->switch_id == QCA8K_ID_QCA8327)
> > +		if (of_property_read_bool(node, "qca,package48"))
> > +			val |= QCA8327_PWS_PACKAGE48_EN;
> 
> What does this actually do? How is PACKAGE48 different to normal mode?
>

I actually made a typo.
Anyway the difference is that they made 2 different package version of
the qca8327. One with 176 pin and one with 148 pin. Setting the wrong
layout cause the switch malfunction (no traffic, we found this on one
xiaomi device). This is from Documenation and it does toggle the MAC
interface configuration for the 2 different package.

> > +
> > +	if (of_property_read_bool(node, "qca,power-on-sel"))
> > +		val |= QCA8K_PWS_POWER_ON_SEL;
> 
> What happens if you unconditionally do this? Why is a DT property
> required?
> 

This is needed to bypass the power on strapping and use the regs config.
The switch can use hardware pin to set eeprom presence and leds open
drain. Setting this bit on bypass the hardware strapping and sets these
2 thing based on the regs. We didn't add the eeprom binding as we didn't
find any switch using it and we don't have any support for it.

> > +
> > +	if (of_property_read_bool(node, "qca,led-open-drain"))
> > +		/* POWER_ON_SEL needs to be set when configuring led to open drain */
> > +		val |= QCA8K_PWS_LED_OPEN_EN_CSR | QCA8K_PWS_POWER_ON_SEL;
> 
> This is getting into territory of adding LED support for PHYs, which
> we want to do via the LED subsystem.
> 

Don't know if it would be the correct way. Without this the switch leds
chaese to work. I think this should be handled in a dedicated way than
defined in a binding in the leds configuration. But I could be wrong.

>    Andrew

-- 
	Ansuel
