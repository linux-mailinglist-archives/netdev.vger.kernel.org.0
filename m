Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC21357CC7C
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 15:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230058AbiGUNr2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 09:47:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbiGUNrN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 09:47:13 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3375578233;
        Thu, 21 Jul 2022 06:46:24 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id m13so2223769edc.5;
        Thu, 21 Jul 2022 06:46:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GFYaO3lKdBQOZgxDPdNq3Av3oecPqgKRyrbG9aidV/Y=;
        b=D6TZHjSUmzXvzDxLXjlNMssyaqBzUgHg0ruAB0IuMqGRHUg/wcSZY96jHqoLMxD4vF
         iZCR9oAB3PEletONkwpucJg8qEDQaIIYwbGthkAp8NfMwbB8LtlpvPbn3Q0LZ0dlcLEU
         3GZJJbutn7D3dMJEr2MlfEr5yjqBUU8z2bz5BZLLLUE5UjQNlS13ZVykjS1mRFkS9UB+
         2gx8aaRFwFvaV94wyD1yMmeMMaMY7Sx+wd5ASBFySRSLJ1a5fqx+FuG6xYfezAbRWsN9
         XiuAebhbcJx236kfwZlxjBKWpuX+UDV7yYJ4KB9vhWzexghQchcLQK47JP9VyhN75e6E
         tSuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GFYaO3lKdBQOZgxDPdNq3Av3oecPqgKRyrbG9aidV/Y=;
        b=77ACuf+mwGJbw/HvKUKevSrCyewZgkv/wSILKimsoycpuinBOiwiFoUUR6sDOeYxl1
         mJdiJPKBZMqHU5e6FHHO92EUe00GMtFAoG7uPHGnsDvTszTOjmkLhXJzd5WlIEzouQdh
         9pAyh/2JD9XWsCZy8NvfscKzH8KXl8YomrZCZaj+QPE0NeVHA/4dex2zbgW860HMx3CP
         aZG3rn/IX1W1tCkjTd28GANT2KKKF73i9HObGrZ5kpCovp4dl21UoKc2C/ZMGXE0blx/
         fZbwAZMypTcEmbvwkOsW2cRm0Nh+DnwnpB/LVy7GeBw2YWVKvExNnxwYLOfRUefC4YVt
         lh/g==
X-Gm-Message-State: AJIora9THYMT1L3kpmizp3HX0yP9lRQv0CVwL2ukuxWBqB3adUZMjK3e
        K4hpkdsdNas0yUgS2myj1GhvdSyiZoOJgg==
X-Google-Smtp-Source: AGRyM1va55K1SZWLz0E6z50sOUk12tbHBTTVllyDYDSE9WX6LAxbFJA+gj27a33bSzA8E8QWWL4OnA==
X-Received: by 2002:a05:6402:370:b0:43b:bb2e:a0c6 with SMTP id s16-20020a056402037000b0043bbb2ea0c6mr8323565edw.378.1658411182751;
        Thu, 21 Jul 2022 06:46:22 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id rn9-20020a170906d92900b0072f1e7b06d9sm878295ejb.59.2022.07.21.06.46.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 06:46:21 -0700 (PDT)
Date:   Thu, 21 Jul 2022 16:46:18 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Alvin __ipraga <alsi@bang-olufsen.dk>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Daniel Scally <djrscally@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        DENG Qingfang <dqfext@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sean Wang <sean.wang@mediatek.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>
Subject: Re: [PATCH net-next 3/6] net: dsa: add support for retrieving the
 interface mode
Message-ID: <20220721134618.axq3hmtckrumpoy6@skbuf>
References: <E1oCNl3-006e3n-PT@rmk-PC.armlinux.org.uk>
 <20220715172444.yins4kb2b6b35aql@skbuf>
 <YtHcpf4otJQS9hTO@shell.armlinux.org.uk>
 <20220715222348.okmeyd55o5u3gkyi@skbuf>
 <YtHw0O5NB6kGkdwV@shell.armlinux.org.uk>
 <20220716105711.bjsh763smf6bfjy2@skbuf>
 <YtKdcxupT+INVAhR@shell.armlinux.org.uk>
 <20220716123608.chdzbvpinso546oh@skbuf>
 <YtUec3GTWTC59sky@shell.armlinux.org.uk>
 <20220720224447.ygoto4av7odsy2tj@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220720224447.ygoto4av7odsy2tj@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 21, 2022 at 01:44:47AM +0300, Vladimir Oltean wrote:
> I really wish there was a ready-made helper for validating phylink's
> OF node; I mentioned this already, it needs to cater for all of
> fixed-link/phy-handle/managed/sfp.

While I was going to expand on this point and state that DSA doesn't
currently instantiate phylink for this OF node:

			port@9 {
				reg = <0x9>;
				label = "cpu";
				ethernet = <&eth1>;
				phy-mode = "2500base-x";
				managed = "in-band-status";
			};

I was proven wrong. Today I learned that of_phy_is_fixed_link() returns
true if the "managed" property exists and its value differs from "auto".
So in the above case, of_phy_is_fixed_link() returns true, hmmm.



On the other hand I found arm64/boot/dts/marvell/cn9130-crb.dtsi, where
the switch, a "marvell,mv88e6190"-compatible (can't determine going just
by that what it actually is) has this:

			port@a {
				reg = <10>;
				label = "cpu";
				ethernet = <&cp0_eth0>;
			};

To illustrate how odd the situation is, I am able to follow the phandle
to the CPU port and find a comment that it's a 88E6393X, and that the
CPU port uses managed = "in-band-status":

&cp0_eth0 {
	/* This port is connected to 88E6393X switch */
	status = "okay";
	phy-mode = "10gbase-r";
	managed = "in-band-status";
	phys = <&cp0_comphy4 0>;
};

Open question: is it sane to even do what we're trying here, to create a
fixed-link for port@a (which makes the phylink instance use MLO_AN_FIXED)
when &cp0_eth0 uses MLO_AN_INBAND? My simple mind thinks that if all
involved drivers were to behave correctly and not have bugs that cancel
out other bugs, the above device tree shouldn't work. The host port
would expect a clause 37 base page exchange to take place, the switch
wouldn't send any in-band information, and the SERDES lane would never
transition to data mode. To fix the above, we'd really need to chase the
"ethernet" phandle and attempt to mimic what the DSA master did. This is
indeed logic that never existed before, and I don't particularly feel
like adding it. How far do we want to go? It seems like never-ending
insanity the more I look at it.
