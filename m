Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3114764DEAF
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 17:31:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230135AbiLOQbg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 11:31:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230231AbiLOQbJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 11:31:09 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0E6E10061;
        Thu, 15 Dec 2022 08:31:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=iusyxPYyLd64XV4Av5w1K79Hex9dGUV2ZXLPs+Qj0uM=; b=yBJ0luSsxN0X6uU8A/3vG74cum
        EhMuEii6ewCM8214Xuhl8HUFGl52HOI06AVhYVaYvmfyj9q3Dpw0zrAOiEvSWyUAWW1EcMwwrAYqz
        6h9w4JMCx4/6urSgdEjEpYRGz4ZEBZMOqzGMGhuk6JYH01aeERLbuyo1mMQmeVwcgpOydcpcm4N2H
        BG8dRdsbwRWAZvxOCoG/+I/bo1ysMj7smzrUP/JgCSzHUi8ErnwX4lr3KYkZOIYLcZMpti6qU7i3L
        REh/UVa0HAEO9iqvVc4Ag5oK1QButHYk6F3cI/vFUfFUjykhMorlENAaGuwqqTgwh4tXtseHscbMP
        K8jvqlkA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35724)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1p5r8F-0003L7-58; Thu, 15 Dec 2022 16:30:51 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1p5r8D-0008UX-Dk; Thu, 15 Dec 2022 16:30:49 +0000
Date:   Thu, 15 Dec 2022 16:30:49 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org,
        Tim Harvey <tharvey@gateworks.com>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: Re: [PATCH v7 02/11] leds: add function to configure hardware
 controlled LED
Message-ID: <Y5tLuaqp9MHcW7rU@shell.armlinux.org.uk>
References: <20221214235438.30271-1-ansuelsmth@gmail.com>
 <20221214235438.30271-3-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221214235438.30271-3-ansuelsmth@gmail.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Christian,

On Thu, Dec 15, 2022 at 12:54:29AM +0100, Christian Marangi wrote:
> +A trigger once he declared support for hardware controlled blinks, will use the function
> +hw_control_configure() provided by the driver to check support for a particular blink mode.

Please improve the above. I think what is actually meant is "Where a
trigger has support for hardware controlled blink modes,
hw_control_configure() will be used to check whether a particular blink
mode is supported and configure the blink mode."

> +This function passes as the first argument (flag) a u32 flag.

I don't think "(flag)" is necessary, as I think "a u32 flag"
sufficiently suggests that it's called "flag". In any case, it doesn't
appear to be a "u32" but an "unsigned long".

> +The second argument (cmd) of hw_control_configure() method can be used to do various
> +operations for the specific blink mode. We currently support ENABLE, DISABLE, READ, ZERO
> +and SUPPORTED to enable, disable, read the state of the blink mode, ask the LED
> +driver if it does supports the specific blink mode and to reset any blink mode active.
> +
> +In ENABLE/DISABLE hw_control_configure() should configure the LED to enable/disable the
> +requested blink mode (flag).
> +In READ hw_control_configure() should return 0 or 1 based on the status of the requested
> +blink mode (flag).
> +In SUPPORTED hw_control_configure() should return 0 or 1 if the LED driver supports the
> +requested blink mode (flags) or not.
> +In ZERO hw_control_configure() should return 0 with success operation or error.

I think some kind of tabular description of this would be better.
Something like this but on docbook format:

hw_control_configure()'s second argument, cmd, is used to specify
various operations for the LED blink mode, and will be one of:

ENABLE - to enable the blink mode requested in flag. Returns ?
DISABLE - to disable the blink mode requested in flag. Returbns ?
READ - to indicate whether the blink mode requested in flag is enabled.
       Returns 0 if disabled or 1 if enabled.
SUPPORTED - to indicate whether the blink mode requested in flag is
            supported. Returns 0 if unsupported or 1 if supported.
ZERO - to disable all blink modes. Returns 0 or negative errno.

The problem with the way you've listed it is you've listed the
operations in a different order to the description in the same sentence,
so effectiely ZERO means to report whether supported and SUPPORTED means
to reset all blink modes!

> +
> +The unsigned long flag is specific to the trigger and change across them. It's in the LED
> +driver interest know how to elaborate this flag and to declare support for a
> +particular trigger.

Hmm, as a casual observer, this doesn't really give much information.
Does this mean that it's up to the hardware LED driver to decide what
each bit in the "flag" argument means? If not, I think this needs to
be worded better!

> For this exact reason explicit support for the specific
> +trigger is mandatory or the driver returns -EOPNOTSUPP if asked to enter offload mode
> +with a not supported trigger.

Seems to be a change in terminology - weren't we using "HARDWARE" and
"SOFTWARE" to describe the mode, rather than "offload" ?

> +If the driver returns -EOPNOTSUPP on hw_control_configure(), the trigger activation will
> +fail as the driver doesn't support that specific offload trigger or doesn't know
> +how to handle the provided flags.

This gets rather ambiguous. When can -EOPNOTSUPP be returned - for which
cmds? Surely, if we have already tested for support using the SUPPORTED
cmd which returns a 0/1 value, we should not be going on to trigger a
request to enable something that isn't supported?

> +
>  Known Issues
>  ============
>  
> diff --git a/include/linux/leds.h b/include/linux/leds.h
> index 09ff1dc6f48d..b5aad67fecfb 100644
> --- a/include/linux/leds.h
> +++ b/include/linux/leds.h
> @@ -73,6 +73,16 @@ enum led_blink_modes {
>  	SOFTWARE_HARDWARE_CONTROLLED,
>  };
>  
> +#ifdef CONFIG_LEDS_HARDWARE_CONTROL
> +enum blink_mode_cmd {
> +	BLINK_MODE_ENABLE, /* Enable the hardware blink mode */
> +	BLINK_MODE_DISABLE, /* Disable the hardware blink mode */
> +	BLINK_MODE_READ, /* Read the status of the hardware blink mode */
> +	BLINK_MODE_SUPPORTED, /* Ask the driver if the hardware blink mode is supported */
> +	BLINK_MODE_ZERO, /* Disable any hardware blink active */
> +};
> +#endif

Generally not a good idea to make definitions in header files
conditional on configuration symbols - it makes build-testing more
problematical.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
