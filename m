Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE7416C061D
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 23:49:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbjCSWtY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 18:49:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbjCSWtX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 18:49:23 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94B2A13DFF;
        Sun, 19 Mar 2023 15:49:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=6DxZO2hH60e5R+3GI4rscUU2uKUcFxM5hHa6Am0rX+o=; b=xam6TR0IzPC5KXUIu8Z6eY+YPf
        /UUSYcR6SmeikvRv1qsRGJ4eMyfIUvbfSzjFrZXrvjCoML2Hl+JFD+AuzecOoOi8RZ7Z++Xu3Zyo6
        4zoNUE+F68zQ4M+gi8FOfy6hdsQP8zXRJj5cWR/7SiovQUjcl2GMmFyLwo5slJHuE0aw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pe1pm-007nEY-FJ; Sun, 19 Mar 2023 23:49:02 +0100
Date:   Sun, 19 Mar 2023 23:49:02 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-leds@vger.kernel.org
Subject: Re: [net-next PATCH v5 04/15] leds: Provide stubs for when CLASS_LED
 is disabled
Message-ID: <aa2d0a8b-b98b-4821-9413-158be578e8e0@lunn.ch>
References: <20230319191814.22067-1-ansuelsmth@gmail.com>
 <20230319191814.22067-5-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230319191814.22067-5-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +#if IS_ENABLED(CONFIG_LEDS_CLASS)
>  enum led_default_state led_init_default_state_get(struct fwnode_handle *fwnode);
> +#else
> +static inline enum led_default_state
> +led_init_default_state_get(struct fwnode_handle *fwnode)
> +{
> +	return LEDS_DEFSTATE_OFF;
> +}
> +#endif

0-day is telling me i have this wrong. The function is in led-core.c,
so this should be CONFIG_NEW_LEDS, not CONFIG_LEDS_CLASS.

	    Andrew
