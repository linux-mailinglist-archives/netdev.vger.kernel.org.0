Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1653F25B89C
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 04:13:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbgICCNm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 22:13:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726177AbgICCNl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 22:13:41 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D891C061244;
        Wed,  2 Sep 2020 19:13:39 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id c142so943836pfb.7;
        Wed, 02 Sep 2020 19:13:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=epj8lPbKNU/j4OEf9AnfwYoi5ZNUxWpbPOU9JH2CNvk=;
        b=O6jTk2W03DUJN9BHD4tv2NFKTkm4QfY0gdsN1q511yMpPdr8MzsPCHZ+py5xUwAzKz
         NmlcaQj2ATHyqxdqCKHmS7rOynf4MmG5NnpZPVOq+vcNBv4CH/KGrBZjqaxowmlBMm8f
         xWWyBPer6t/lIQ2YMWn3QGz7Tekv+/fiARPxZEBJZ1/O+xZ5tL2AmanPYENyOil32uaC
         xn1sBTU+DZfMMMp6XnJgAx2/EBtG/SV/c7tOduvJcz0QHktB0JvD4azisrV9mGenB8S/
         RfzaMLQ78PeyH2Kf0RrtZ8VhXtg3UBWYddSZpSyV+06fiAxMC2GuilXx3/itOUVaWKcP
         zYAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=epj8lPbKNU/j4OEf9AnfwYoi5ZNUxWpbPOU9JH2CNvk=;
        b=uXT2vHgiVG6MfRgirMrHkgOQkRqCbbRsE52rxCLbd5sV5+twIxMYFDqid99Hj5QGkD
         /vNl9o76jsmU8/rRfwzpbZdIu+K/HmL6Tdez5GpREvUIFz7MwK7mrNRzIxy7K9Vy/gmg
         8Do+gQXuzyFApohH1YnYTzAg1400LDp/kN4UFIs+z1FEZ4yKFlW1ayRK/r2A29H48FSx
         4+IXfJWtE6Ziuun3LiQto8xUhcHnAPOrbLMMZLn1UVotTMUDUp8gmuWZ7GVxOWfXiCe+
         oPXnhYIPwQpMyDPciC0ifU1CTlG1VqwKKCqG6CxtEbm47GUZRgk9VBEnCo632EKgNHOH
         PwMQ==
X-Gm-Message-State: AOAM5317MkzWOxnW1T41WlxpG1uHsfRqglh0TZgCzDXbFNqbkipfXBI1
        bhAiFurb9hkb2bccbng+QlA=
X-Google-Smtp-Source: ABdhPJwtY1G/9Gm2aR2+u5W638AJD7BFrQ7Tc9LUDapwky5KZzA9JxKuL3oT97oNiYFUndc3200U8w==
X-Received: by 2002:a65:4208:: with SMTP id c8mr825623pgq.266.1599099213641;
        Wed, 02 Sep 2020 19:13:33 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id s24sm625150pgv.55.2020.09.02.19.13.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Sep 2020 19:13:32 -0700 (PDT)
Subject: Re: [RFC net-next 2/2] net: phy: bcm7xxx: request and manage GPHY
 clock
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, adam.rudzinski@arf.net.pl,
        m.felsch@pengutronix.de, hkallweit1@gmail.com,
        richard.leitner@skidata.com, zhengdejin5@gmail.com,
        devicetree@vger.kernel.org, kernel@pengutronix.de, kuba@kernel.org,
        robh+dt@kernel.org
References: <20200902213347.3177881-1-f.fainelli@gmail.com>
 <20200902213347.3177881-3-f.fainelli@gmail.com>
 <20200902222030.GJ3050651@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <7696bf30-9d7b-ecc9-041d-7d899dd07915@gmail.com>
Date:   Wed, 2 Sep 2020 19:13:30 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.1.1
MIME-Version: 1.0
In-Reply-To: <20200902222030.GJ3050651@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/2/2020 3:20 PM, Andrew Lunn wrote:
>> +	priv->clk = devm_clk_get_optional(&phydev->mdio.dev, "sw_gphy");
>> +	if (IS_ERR(priv->clk))
>> +		return PTR_ERR(priv->clk);
>> +
>> +	/* To get there, the mdiobus registration logic already enabled our
>> +	 * clock otherwise we would not have probed this device since we would
>> +	 * not be able to read its ID. To avoid artificially bumping up the
>> +	 * clock reference count, only do the clock enable from a phy_remove ->
>> +	 * phy_probe path (driver unbind, then rebind).
>> +	 */
>> +	if (!__clk_is_enabled(priv->clk))
>> +		ret = clk_prepare_enable(priv->clk);
> 
> This i don't get. The clock subsystem does reference counting. So what
> i would expect to happen is that during scanning of the bus, phylib
> enables the clock and keeps it enabled until after probe. To keep
> things balanced, phylib would disable the clock after probe.

That would be fine, although it assumes that the individual PHY drivers 
have obtained the clocks and called clk_prepare_enable(), which is a 
fair assumption I suppose.

> 
> If the driver wants the clock enabled all the time, it can enable it
> in the probe method. The common clock framework will then have two
> reference counts for the clock, so that when the probe exists, and
> phylib disables the clock, the CCF keeps the clock ticking. The PHY
> driver can then disable the clock in .remove.

But then the lowest count you will have is 1, which will lead to the 
clock being left on despite having unbound the PHY driver from the 
device (->remove was called). This does not allow saving any power 
unfortunately.

> 
> There are some PHYs which will enumerate with the clock disabled. They
> only need it ticking for packet transfer. Such PHY drivers can enable
> the clock only when needed in order to save some power when the
> interface is administratively down.

Then the best approach would be for the OF scanning code to enable all 
clocks reference by the Ethernet PHY node (like it does in the proposed 
patch), since there is no knowledge of which clock is necessary and all 
must be assumed to be critical for MDIO bus scanning. Right before 
drv->probe() we drop all resources reference counts, and from there on 
->probe() is assumed to manage the necessary clocks.

It looks like another solution may be to use the assigned-clocks 
property which will take care of assigning clock references to devices 
and having those applied as soon as the clock provider is available.
-- 
Florian
