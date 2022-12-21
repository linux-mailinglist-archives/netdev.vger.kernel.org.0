Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECC9E65311E
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 13:55:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232763AbiLUMzF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 07:55:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiLUMzB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 07:55:01 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C79AE2317F;
        Wed, 21 Dec 2022 04:54:59 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id p1-20020a05600c1d8100b003d8c9b191e0so397353wms.4;
        Wed, 21 Dec 2022 04:54:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=dRK8jAShw4FKHMFTqOEZH8n9jGsLhbWM5T+ViFrWZBg=;
        b=DA/xPznmaeVcfMgPhSYETFahuh+6m6bx4PqwjjS3ya7Z9cNxQxuJDQ+8eRMylBRlLD
         wBD9T4/o4FuOu0rF62/OBwbm5QjXw2ARMiWmwjAI5kiVQGxjGrNVe7q5+7rEfshhGYjX
         fn4kMnqgmN8zGD3B3DieUgyC53GjduWUUfyGLUaKoP26L+qj8sj1ZbEzJ3ILbJhnfi8u
         7Ir72KoeeAcBre+acZlpfd3eI5K8VYHF6kPtcCVws3wWGc+aqClcBqhYFImpFPQgOzEG
         Jufw3hKzIpRp3HORukhmMsvZPpFhlGAnn11Qg39wLgBmz6aq/2mhjeVsyjcKPNSpNDZo
         fx6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dRK8jAShw4FKHMFTqOEZH8n9jGsLhbWM5T+ViFrWZBg=;
        b=haXUEy3Bo7/1RATrP/ktm+y8G/ZNz65sUsKqq0+JYF5i/YhJbYv2Fg6OhJ+lESf0gu
         OHrFOIMKN2f1X45XB0n8nWZjfDhNYqRtYuKdLUPhp1KlbZihr9BbRT/Y6AsqI5kbcPoF
         M4OvMcAuwyZ95Zc+/swNZ+TWH8Z704yE2hmbm3K1ZtDG9iz/Upa/oD7GZrRfi1SBx/g4
         rDkfEFAhR/gjEMr334Xt4F5DcywWI+ZlhBcAKkQruxlXUGZtJZynNJYbBLxs1jdeyre8
         KXpCecMeU2G1kNincxZjxRHQvdMoznnBnRWHwZjfc6GlmEHXLSgfMwUDf1t//bA4RGnd
         K1Vw==
X-Gm-Message-State: AFqh2kq7uUXjnNvPYCPq/h+v30yAVrh+958LK3xbzumdo1+j1RxtWmgO
        7cvCKTfqdogRyGHXqZyM9RPS3mmXlGw=
X-Google-Smtp-Source: AMrXdXsBytjhLZWs4x8v2DyBBkxP6etAA7zXggbAgPbplpRiy/tGRvWhF4zzKk2yBTSh1IGrY/vZeg==
X-Received: by 2002:a05:600c:500e:b0:3cf:88c3:d008 with SMTP id n14-20020a05600c500e00b003cf88c3d008mr4419819wmr.28.1671627298046;
        Wed, 21 Dec 2022 04:54:58 -0800 (PST)
Received: from Ansuel-xps. (host-82-55-238-56.retail.telecomitalia.it. [82.55.238.56])
        by smtp.gmail.com with ESMTPSA id 21-20020a05600c021500b003cf37c5ddc0sm2111276wmi.22.2022.12.21.04.54.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Dec 2022 04:54:57 -0800 (PST)
Message-ID: <63a30221.050a0220.16e5f.653a@mx.google.com>
X-Google-Original-Message-ID: <Y6MCHwWMABd0yUyG@Ansuel-xps.>
Date:   Wed, 21 Dec 2022 13:54:55 +0100
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Rob Herring <robh@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org,
        Tim Harvey <tharvey@gateworks.com>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: Re: [PATCH v7 11/11] dt-bindings: net: dsa: qca8k: add LEDs
 definition example
References: <20221214235438.30271-1-ansuelsmth@gmail.com>
 <20221214235438.30271-12-ansuelsmth@gmail.com>
 <20221220173958.GA784285-robh@kernel.org>
 <Y6JDOFmcEQ3FjFKq@lunn.ch>
 <Y6JkXnp0/lF4p0N1@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y6JkXnp0/lF4p0N1@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 21, 2022 at 02:41:50AM +0100, Andrew Lunn wrote:
> > > > +                        };
> > > > +
> > > > +                        led@1 {
> > > > +                            reg = <1>;
> > > > +                            color = <LED_COLOR_ID_AMBER>;
> > > > +                            function = LED_FUNCTION_LAN;
> > > > +                            function-enumerator = <1>;
> > > 
> > > Typo? These are supposed to be unique. Can't you use 'reg' in your case?
> > 
> > reg in this context is the address of the PHY on the MDIO bus. This is
> > an Ethernet switch, so has many PHYs, each with its own address.
> 
> Actually, i'm wrong about that. reg in this context is the LED number
> of the PHY. Typically there are 2 or 3 LEDs per PHY.
> 
> There is no reason the properties need to be unique. Often the LEDs
> have 8 or 16 functions, identical for each LED, but with different
> reset defaults so they show different things.
> 

Are we taking about reg or function-enumerator?

For reg it's really specific to the driver... My idea was that since a
single phy can have multiple leds attached, reg will represent the led
number.

This is an example of the dt implemented on a real device.

		mdio {
			#address-cells = <1>;
			#size-cells = <0>;

			phy_port1: phy@0 {
				reg = <0>;

				leds {
					#address-cells = <1>;
					#size-cells = <0>;

					lan1_led@0 {
						reg = <0>;
						color = <LED_COLOR_ID_WHITE>;
						function = LED_FUNCTION_LAN;
						function-enumerator = <1>;
						linux,default-trigger = "netdev";
					};

					lan1_led@1 {
						reg = <1>;
						color = <LED_COLOR_ID_AMBER>;
						function = LED_FUNCTION_LAN;
						function-enumerator = <1>;
						linux,default-trigger = "netdev";
					};
				};
			};

			phy_port2: phy@1 {
				reg = <1>;

				leds {
					#address-cells = <1>;
					#size-cells = <0>;


					lan2_led@0 {
						reg = <0>;
						color = <LED_COLOR_ID_WHITE>;
						function = LED_FUNCTION_LAN;
						function-enumerator = <2>;
						linux,default-trigger = "netdev";
					};

					lan2_led@1 {
						reg = <1>;
						color = <LED_COLOR_ID_AMBER>;
						function = LED_FUNCTION_LAN;
						function-enumerator = <2>;
						linux,default-trigger = "netdev";
					};
				};
			};

			phy_port3: phy@2 {
				reg = <2>;

				leds {
					#address-cells = <1>;
					#size-cells = <0>;

					lan3_led@0 {
						reg = <0>;
						color = <LED_COLOR_ID_WHITE>;
						function = LED_FUNCTION_LAN;
						function-enumerator = <3>;
						linux,default-trigger = "netdev";
					};

					lan3_led@1 {
						reg = <1>;
						color = <LED_COLOR_ID_AMBER>;
						function = LED_FUNCTION_LAN;
						function-enumerator = <3>;
						linux,default-trigger = "netdev";
					};
				};
			};

In the following implementation. Each port have 2 leds attached (out of
3) one white and one amber. The driver parse the reg and calculate the
offset to set the correct option with the regs by also checking the phy
number.

An alternative way would be set the reg to be the global led number in
the switch and deatch the phy from the calculation.

Something like
port 0 led 0 = reg 0
port 0 led 1 = reg 1
port 1 led 0 = reg 2
port 1 led 1 = reg 3
...

Using the function-enumerator can be problematic since ideally someone
would declare a dedicated function for wan led.

I'm very open to discuss and improve/fix this!

-- 
	Ansuel
