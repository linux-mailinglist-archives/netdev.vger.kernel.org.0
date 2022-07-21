Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B90157CEB5
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 17:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbiGUPPn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 11:15:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbiGUPPm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 11:15:42 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A131101D8;
        Thu, 21 Jul 2022 08:15:39 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id y8so2577347eda.3;
        Thu, 21 Jul 2022 08:15:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Xi5mwFUrkcEqv8uinrvMbw85jw9fyWSslhc1m9xOJm4=;
        b=RDLCMAvU53GBaBc3B8YnjR+gUrt0/9ZxdTE1AWe9RU/jH4t5fYHutWejl0Xn3dQ67y
         y/4P8R4VLyjC2PUokA98FA19n6eBPpcPA51B8IXpdg/5xD9GfOi/NDndxWdSsm3HOxJz
         OhtMs5VJCef+wDIeWFx9l/iM3RXLrqsL0SdOLhdEZszDuek26Y2NV6eGJnDl1mYzKtoi
         KEJl0sCPVEmJE6vTu2ci3jqHjDZY6Ycf46OEZpFq4veChAy89Pzo3W38gyHlQa2jkPif
         LBFIXOGbFBi1fSpwGkQbJCldExmghuOmqPahX7rTpbU2o4InmvWKEUPvskLc/Gu4FsdS
         OKTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Xi5mwFUrkcEqv8uinrvMbw85jw9fyWSslhc1m9xOJm4=;
        b=VlqUPMnJbZ7N46eJIZARvQ2cFd0kPk5gzjiJ+TpttIcKHDXQ/IFhHG3QSvAjlmQo53
         UMaCk1P69XcV8IIrRL3Wi4Hw/H0wPZSb71rCLVRL+y6Ox9tHZt75bJT0VhEbNYYKiRf4
         v82jQIKTy3eLgxOgJLJWQAw/588Wyv/NrlBWhcHICZdr1tjjrTXq0xufgy/DKwYdFVkS
         VdadTAb2Bl1VzwVwwhxeGpsbOAFpU2PW9wtpWT7ElWWiPo644JOCoLxG3NueO1UP+lZY
         zHxYnxTPd5AccaUM8YYjpPek0qmP+ilc0QWN6G39pJzlcabfq2YoIovVNpOI4emFCkNL
         N49w==
X-Gm-Message-State: AJIora9uM+k9bHsJxR+DQSahvPfnCgJp7Qucbq/4p9iV5NBnc74cHIBT
        cTbktLCLPAw1vyiFD3DtQlU=
X-Google-Smtp-Source: AGRyM1vpKMg4OV6hvcqhFrgW9rez7LGngemVBFdKvoxXhmQWgzvZjEJ22WPJ3QhhMMbw315IXgxfNg==
X-Received: by 2002:a05:6402:2554:b0:43a:902b:d31f with SMTP id l20-20020a056402255400b0043a902bd31fmr57354668edb.416.1658416537761;
        Thu, 21 Jul 2022 08:15:37 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id sb12-20020a1709076d8c00b00718e4e64b7bsm944037ejc.79.2022.07.21.08.15.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 08:15:36 -0700 (PDT)
Date:   Thu, 21 Jul 2022 18:15:33 +0300
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
Message-ID: <20220721151533.3zomvnfogshk5ze3@skbuf>
References: <YtHcpf4otJQS9hTO@shell.armlinux.org.uk>
 <20220715222348.okmeyd55o5u3gkyi@skbuf>
 <YtHw0O5NB6kGkdwV@shell.armlinux.org.uk>
 <20220716105711.bjsh763smf6bfjy2@skbuf>
 <YtKdcxupT+INVAhR@shell.armlinux.org.uk>
 <20220716123608.chdzbvpinso546oh@skbuf>
 <YtUec3GTWTC59sky@shell.armlinux.org.uk>
 <20220720224447.ygoto4av7odsy2tj@skbuf>
 <20220721134618.axq3hmtckrumpoy6@skbuf>
 <Ytlol8ApI6O2wy99@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ytlol8ApI6O2wy99@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 21, 2022 at 03:54:15PM +0100, Russell King (Oracle) wrote:
> Yes, which is why I said on July 7th:
> 
> "So I also don't see a problem - sja1105 rejects DTs that fail to
> describe a port using at least one of a phy-handle, a fixed-link, or
> a managed in-band link, and I don't think it needs to do further
> validation, certainly not for the phy describing properties that
> the kernel has chosen to deprecate for new implementations."
> 
> I had assumed you knew of_phy_is_fixed_link() returns true in this
> case. Do you now see that sja1105's validation is close enough
> (except for the legacy phy phandle properties which we don't care
> about),

This is why your comment struck me as odd for mentioning managed in-band.

> and thus do we finally have agreement on this point?

Yes we do.

> > On the other hand I found arm64/boot/dts/marvell/cn9130-crb.dtsi, where
> > the switch, a "marvell,mv88e6190"-compatible (can't determine going just
> > by that what it actually is) has this:
> > 
> > 			port@a {
> > 				reg = <10>;
> > 				label = "cpu";
> > 				ethernet = <&cp0_eth0>;
> > 			};
> 
> Port 10 on 88E6393X supports 10GBASE-R, and maybe one day someone will
> get around to implementing USXGMII. This description relies upon this
> defaulting behaviour - as Andrew has described, this has been entirely
> normal behaviour with mv88e6xxx.
> 
> > To illustrate how odd the situation is, I am able to follow the phandle
> > to the CPU port and find a comment that it's a 88E6393X, and that the
> > CPU port uses managed = "in-band-status":
> > 
> > &cp0_eth0 {
> > 	/* This port is connected to 88E6393X switch */
> > 	status = "okay";
> > 	phy-mode = "10gbase-r";
> > 	managed = "in-band-status";
> > 	phys = <&cp0_comphy4 0>;
> > };
> 
> 10GBASE-R has no in-band signalling per-se, so the only effect this has
> on the phylink instance on the CPU side is to read the status from the
> PCS as it does for any other in-band mode. In the case of 10GBASE-R, the
> only retrievable parameter is the link up/down status. This is no
> different from a 10GBASE-R based fibre link in that regard.

Is there any formal definition for what managed = "in-band-status"
actually means? Is it context-specific depending on phy-mode?
In the case of SGMII, would it also mean that clause 37 exchange would
also take place (and its absence would mean it wouldn't), or does it
mean just that, that the driver should read the status from the PCS?

> A fixed link on the other hand would not read status from the PCS but
> would assume that the link is always up.
> 
> > Open question: is it sane to even do what we're trying here, to create a
> > fixed-link for port@a (which makes the phylink instance use MLO_AN_FIXED)
> > when &cp0_eth0 uses MLO_AN_INBAND? My simple mind thinks that if all
> > involved drivers were to behave correctly and not have bugs that cancel
> > out other bugs, the above device tree shouldn't work. The host port
> > would expect a clause 37 base page exchange to take place, the switch
> > wouldn't send any in-band information, and the SERDES lane would never
> > transition to data mode. To fix the above, we'd really need to chase the
> > "ethernet" phandle and attempt to mimic what the DSA master did. This is
> > indeed logic that never existed before, and I don't particularly feel
> > like adding it. How far do we want to go? It seems like never-ending
> > insanity the more I look at it.
> 
> 10GBASE-R doesn't support clause 37 AN. 10GBASE-KR does support
> inband AN, but it's a different clause and different format.

I thought it wouldn't, but then I was led to believe, after seeing it
here, that just the hardware I'm working with doesn't. How about
2500base-x in Marvell, is there any base page exchange, or is this still
only about retrieving link status from the PCS?
