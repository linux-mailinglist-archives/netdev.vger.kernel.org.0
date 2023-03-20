Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69EF16C21B0
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 20:37:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231215AbjCTThv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 15:37:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230337AbjCTThT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 15:37:19 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 390E83645F;
        Mon, 20 Mar 2023 12:31:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=HojbwMSiEtZKlQdfE1hnnoB2RYxodFjMqNVmkdMaTE4=; b=UTwuS59N/DkJgr/7fUE2JTH62X
        AhIEtJYFFX67UsLmhqkAOgHh4nQviuZbanJJ5f7SM98Xq/YbeJU1Mc3XeoxdfdEsym7a4Q0bty5sf
        XU2PDo/aguksS9t7Gp0rZ6vDxNs0cA+Dmaf3GIHQ3xeplirk2AthvAl5u+QeTJ5Csk/8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1peLEG-007tlX-8U; Mon, 20 Mar 2023 20:31:36 +0100
Date:   Mon, 20 Mar 2023 20:31:36 +0100
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
Message-ID: <5ee3c2cf-8100-4f35-a2df-b379846a8736@lunn.ch>
References: <20230319191814.22067-1-ansuelsmth@gmail.com>
 <20230319191814.22067-5-ansuelsmth@gmail.com>
 <aa2d0a8b-b98b-4821-9413-158be578e8e0@lunn.ch>
 <64189d72.190a0220.8d965.4a1c@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64189d72.190a0220.8d965.4a1c@mx.google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 20, 2023 at 06:52:47PM +0100, Christian Marangi wrote:
> On Sun, Mar 19, 2023 at 11:49:02PM +0100, Andrew Lunn wrote:
> > > +#if IS_ENABLED(CONFIG_LEDS_CLASS)
> > >  enum led_default_state led_init_default_state_get(struct fwnode_handle *fwnode);
> > > +#else
> > > +static inline enum led_default_state
> > > +led_init_default_state_get(struct fwnode_handle *fwnode)
> > > +{
> > > +	return LEDS_DEFSTATE_OFF;
> > > +}
> > > +#endif
> > 
> > 0-day is telling me i have this wrong. The function is in led-core.c,
> > so this should be CONFIG_NEW_LEDS, not CONFIG_LEDS_CLASS.
> > 
> 
> Any idea why? NEW_LEDS just enable LEDS_CLASS selection so why we need
> to use that? Should not make a difference (in theory)

0-day came up with a configuration which resulted in NEW_LEDS enabled
but LEDS_CLASS disabled. That then resulted in multiple definitions of 
led_init_default_state_get() when linking.

I _guess_ this is because select is used, which is not mandatory. So
randconfig can turn off something which is enabled by select.

I updated my tree, and so far 0-day has not complained, but it can
take a few days when it is busy.

	Andrew
