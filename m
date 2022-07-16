Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2F11576D5B
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 12:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbiGPK5U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 06:57:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiGPK5S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 06:57:18 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BB0BCE2A;
        Sat, 16 Jul 2022 03:57:16 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id eq6so9199650edb.6;
        Sat, 16 Jul 2022 03:57:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Y2w+/D0qVC/MxuYc8kSX8+b66qSmQVaXiMac4uHSn80=;
        b=CYfq/a44gFubyWQKFIXHlM7reCKU/S/gz8mxBEBgeJxbgYLT0jDP07ae47dFNpwTyb
         cCLvh2L+CbnG3bLUr+cqP2HhTIh/1O7/Tpu6RwFD0FZsfuvBIDYkONQLpT6tf45HExbe
         nUle/gN8RRGAFT9ulovCzcYnBTLCyoGmkqjiUKhVbiU0wLzBtXFd8Wjb2VS8D8k1GxGL
         0+T9Sffv0kP9cE3g+4+7VZcyEf5U+n5a4W3hETqNNvjRHx4Xo+Lbn4fxkABb6vQUi6sL
         SSWUIyaPoK4uGFkc4jB9jYAVT5XMNojlZZD9FfwA/o+YP6tLmRrjAEYDB2oQXr2m2cyR
         YLEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Y2w+/D0qVC/MxuYc8kSX8+b66qSmQVaXiMac4uHSn80=;
        b=tc12JnRjKgupjk4wCiUvD9asW3VPndnBfLFWn2HD4vsKDaWhzkv2uCXbE9mGBBdSTN
         n0qDrr/V0w8Nx5BcgYJJLf+VRb9uRC0EKnPF6mv0DeYxCRzEQgwAqlXP7NY4fJZzu19j
         j5jp4WFELrVlw+ArfOqKAiKFMV2IhDfRjQOXk45BMlD2TlY+dLlQ8eLnMaYU61A10R2v
         Sot4G47krqSbr16/flVTkPF4PdGL3XHedi2AOpiU3v+WyRPGWVjfA5fnfLpgBdJCctMI
         91nRwAFA/prl/G9R6Vh+0GHoNB79S2lckPCzQRIPzTGhUEyOp7qZTYbscCDHbpy974/u
         6xRA==
X-Gm-Message-State: AJIora8W7NZKIsuQUhWIlt3dI6X2JNWN9xbF0v+4iY8uogdyzFgmhkqb
        K26QRKjFyGPcErB1Oenj0P8=
X-Google-Smtp-Source: AGRyM1tTQPUNZdfW5CjlZaMUuGmjZY0BtVvaB4lz4j+y8Rw9J+waSuNBuaZcCkhDKqXIhjZCyyB9hA==
X-Received: by 2002:a05:6402:5001:b0:437:8918:8dbe with SMTP id p1-20020a056402500100b0043789188dbemr24547489eda.70.1657969035042;
        Sat, 16 Jul 2022 03:57:15 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id e2-20020a50fb82000000b0042bdb6a3602sm4382499edq.69.2022.07.16.03.57.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Jul 2022 03:57:14 -0700 (PDT)
Date:   Sat, 16 Jul 2022 13:57:11 +0300
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
Message-ID: <20220716105711.bjsh763smf6bfjy2@skbuf>
References: <YtGPO5SkMZfN8b/s@shell.armlinux.org.uk>
 <YtGPO5SkMZfN8b/s@shell.armlinux.org.uk>
 <E1oCNl3-006e3n-PT@rmk-PC.armlinux.org.uk>
 <E1oCNl3-006e3n-PT@rmk-PC.armlinux.org.uk>
 <20220715172444.yins4kb2b6b35aql@skbuf>
 <YtHcpf4otJQS9hTO@shell.armlinux.org.uk>
 <20220715222348.okmeyd55o5u3gkyi@skbuf>
 <YtHw0O5NB6kGkdwV@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtHw0O5NB6kGkdwV@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 15, 2022 at 11:57:20PM +0100, Russell King (Oracle) wrote:
> > > The problem is this - we call get_caps(), and we have to read registers
> > > to work out what the port supports. If we have a separate callback, then
> > > we need to re-read those registers to get the same information to report
> > > what the default interface should be.
> > > 
> > > Since almost all of the Marvell implementations the values for both the
> > > list of supported interfaces and the default interface both require
> > > reading a register and translating it to a phy_interface_t, and then
> > > setting the support mask, it seems logical to combine these two
> > > functioalities into one function.
> > 
> > In essence that doesn't mean much; DSA isn't Marvell only, but I'll give
> > it to you: if only the Marvell driver (and Broadcom later, I expect) is
> > going to add support for the context-specific interpretation of CPU port
> > OF nodes, then we may consider tailoring the implementation to their
> > hardware register layout details. In any case, my concern can be
> > addressed even if you insist on keeping the default interface as an
> > argument of phylink_get_caps. There just needs to be a lot more
> > documentation explaining who needs to populate that argument and why.
> 
> I don't get the point you're making here.

The point I'm making is that I dislike where this is going. The addition
of "default_interface" to phylink_get_caps is confusing because it lacks
proper qualifiers.

The concrete reasons why it's confusing are:

(a) there is no comment which specifies on which kinds of ports (DSA and CPU)
    the default_interface will be used. This might result in useless effort
    from driver authors to report a default_interface for a port where it
    will never be asked for.

(b) there is no comment which specifies that only the drivers which have
    DT blobs with missing phylink bindings on CPU and DSA ports should
    fill this out. I wouldn't want to see a new driver use this facility,
    I just don't see a reason for it. I'd rather see a comment that the
    recommendation for new drivers is to validate their bindings and not
    rely on context-specific interpretations of empty DT nodes.

(c) especially with the dsa_port_find_max_caps() heuristic in place, I
    can't say I'm clear at all on who should populate "default_interface"
    and who could safely rely on the heuristic if they populate
    supported_interfaces. It's simply put unclear what is the expectation
    from driver authors.

For (b) I was thinking that making it a separate function would make it
clearer that it isn't for everyone. Doing just that wouldn't solve everything,
so I've also said that adding more documentation to this function
prototype would go a long way.

Some dsa_switch_ops already have inline comments in include/net/dsa.h,
see get_tag_protocol, change_tag_protocol, port_change_mtu. Also, there
is the the "PHY devices and link management" chapter in Documentation/networking/dsa/dsa.rst.
We have places to document what the DSA framework expects drivers to do.
I was expecting that wherever default_interface gets reported, we could
see some answers and explanations to the questions above.

> > Also, perhaps more importantly, a real effort needs to be put to prevent
> > breakage for drivers that work without a phylink instance registered for
> > the CPU port, and also don't report the default interface. Practically
> > that just means not deleting the current logic, but making it one of 3
> > options.
> > 
> > fwnode is valid from phylink's perspective?
> >        /                             \
> >  yes  /                               \ no
> >      /                                 \
> > register with phylink         can we determine the link parameters to create
> >                                   a fixed-link software node?
> >                                        /                \                     \
> >                                  yes  /                  \  no                |
> >                                      /                    \                   | this is missing
> >                                     /                      \                  |
> >              create the software node and       don't put the port down,      |
> >              register with phylink              don't register with phylink   /
> 
> This is exactly what we have today,

Wait a minute, how come this is exactly what we have "today"?

In tree we have this:

fwnode is valid from phylink's perspective?
       /                             \
 yes  /                               \  no
     /                                 \
register with phylink                   \
                             don't put the port down,
                             don't register with phylink


In your patch set we have this:


fwnode is valid from phylink's perspective?
       /                             \
 yes  /                               \ no
     /                                 \
register with phylink         can we determine the link parameters to create
                                  a fixed-link software node?
                                       /                \
                                 yes  /                  \  no
                                     /                    \
                                    /                      \
             create the software node and            fail to create the port
             register with phylink

> and is exactly what I'm trying to get rid of, so we have _consistency_
> in the implementation, to prevent fuckups like I've created by
> converting many DSA drivers to use phylink_pcs. Any DSA driver that
> used a PCS for the DSA or CPu port and has been converted to
> phylink_pcs support has been broken in the last few kernel cycles. I'm
> trying to address that breakage before converting the Marvell DSA
> driver - which is the driver that highlighted the problem.

You are essentially saying that it's of no use to keep in DSA the
fallback logic of not registering with phylink, because the phylink_pcs
conversions have broken the defaulting functionality already in all
other drivers.

I may have missed something, but this is new information to me.
Specifically, before you've said that it is *this* patch set which would
risk introducing breakage (by forcing a link down + a phylink creation).
https://lore.kernel.org/netdev/YsCqFM8qM1h1MKu%2F@shell.armlinux.org.uk/
What you're saying now directly contradicts that.

Do you have concrete evidence that there is actually any regression of
this kind introduced by prior phylink_pcs conversions? Because if there
is, I retract the proposal to keep the fallback logic.

> We need to move away from the current model in DSA where we only use
> stuff in random situations.
> 
> Well, at this point, I'm just going to give up with this kernel cycle.
> It seems impossible to get this sorted. It seems impossible to move
> forward with the conversion of Marvell DSA to phylink_pcs. In fact,
> I might just give up with the idea of further phylink development
> because it's just too fucking difficult, and getting feedback is just
> impossible.
> 
> -- 
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
