Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8418F427C83
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 20:08:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbhJISK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 14:10:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbhJISK1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Oct 2021 14:10:27 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35C6DC061570;
        Sat,  9 Oct 2021 11:08:30 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id z20so48938908edc.13;
        Sat, 09 Oct 2021 11:08:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UnnvRWJLkepc9TqBG6AXA25unMvK8Yk7T2RTgklmfTY=;
        b=Ibdr0spF52RuS1ZydZK+8AL/uPz2izxQey8nt6XtdLMb36blpBRU7pCYXSWywT3yY/
         TL0AqBGyIaBSzlmcaBftggl0uy5kK73jf9ORgetQFY0jzNty2BlzHMaYxoNRcObG7thg
         lU5j5xfS6ctbTTc+NM4V4JowDnrxRgV16VBBQmQMzHSWire0hX09yPp6ug7X4174x0jR
         n9zn/aaGMIDotSg52kz6nJYHk98vvJ3uRQXsPGN9oa7fa6bF7A39s4JosHV8Nu16ot7Z
         SNJLHCysTTJKVj7PH0LmuwkcvRqiUjTl+/SowS356z4oeLEF82jQRgz8DnpOp8sFuTV6
         xl2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UnnvRWJLkepc9TqBG6AXA25unMvK8Yk7T2RTgklmfTY=;
        b=xVGRw2xbVzbScCavUwX+VQJaOF007tE8NGik39T1q/tmcB77i0X3wKQ2vxmsZ0pW6z
         f5rWJJHLkArL/XUQut4QsVzlt7kBHmvXvhk6rcSf1sHB+CO1CWpbUZWMzi+txrhdyZBJ
         4keSGouwrvHvWZH5LSgoj+iM59zK0BJTblPHY58FHpqNo/P7XIkQdNrXsDQcI5Cn5i0c
         wzYxx4y4q6qjtccJxm/S36+LdRzwiJC31Sq4mMDJ3+U8nEHQqLFHyxMQnt3Haa2KRbYM
         6p3A/0CcVhhsjiIlN5bffbH9SAtvwzTAxqhcKkMLkAPLebkmJoNWJuZsefzDh8F9YbjD
         TomQ==
X-Gm-Message-State: AOAM530WEOpiwQuE94ay1cbmKdugnu2Mz/G/PN3b+8bAVwR39XLh0q8z
        GVybByAkk47hre9URDPgljk=
X-Google-Smtp-Source: ABdhPJzan03w4d2FojSAnGhHS0JkRsb3xqdRgQucj+KQqROcc+Su8AF2Md1SvGQQwu6Po9a3b6MnEQ==
X-Received: by 2002:a17:906:f98c:: with SMTP id li12mr13295205ejb.108.1633802908518;
        Sat, 09 Oct 2021 11:08:28 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id jv12sm1226293ejc.83.2021.10.09.11.08.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Oct 2021 11:08:27 -0700 (PDT)
Date:   Sat, 9 Oct 2021 20:08:24 +0200
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
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthew Hagan <mnhagan88@gmail.com>
Subject: Re: [net-next PATCH v2 08/15] dt-bindings: net: dsa: qca8k: Add MAC
 swap and clock phase properties
Message-ID: <YWHamNcXmxuaVgB+@Ansuel-xps.localdomain>
References: <20211008002225.2426-1-ansuelsmth@gmail.com>
 <20211008002225.2426-9-ansuelsmth@gmail.com>
 <YWHMRMTSa8xP4SKK@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YWHMRMTSa8xP4SKK@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 09, 2021 at 07:07:16PM +0200, Andrew Lunn wrote:
> On Fri, Oct 08, 2021 at 02:22:18AM +0200, Ansuel Smith wrote:
> > Add names and decriptions of additional PORT0_PAD_CTRL properties.
> > Document new binding qca,mac6_exchange that exchange the mac0 port
> > with mac6.
> > qca,sgmii-(rx|tx)clk-falling-edge are for setting the respective clock
> > phase to failling edge.
> > 
> > Signed-off-by: Matthew Hagan <mnhagan88@gmail.com>
> > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> > ---
> >  Documentation/devicetree/bindings/net/dsa/qca8k.txt | 5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.txt b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
> > index 9383d6bf2426..208ee5bc1bbb 100644
> > --- a/Documentation/devicetree/bindings/net/dsa/qca8k.txt
> > +++ b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
> > @@ -13,6 +13,11 @@ Required properties:
> >  Optional properties:
> >  
> >  - reset-gpios: GPIO to be used to reset the whole device
> > +- qca,mac6-exchange: Internally swap MAC0 with MAC6.
> > +- qca,sgmii-rxclk-falling-edge: Set the receive clock phase to falling edge.
> > +                                Mostly used in qca8327 with CPU port 0 set to
> > +                                sgmii.
> > +- qca,sgmii-txclk-falling-edge: Set the transmit clock phase to falling edge.
> >  - qca,rgmii0-1-8v: Set the internal regulator to supply 1.8v for MAC0 port.
> >                     This is needed for qca8337 and toggles the supply voltage
> >                     from 1.5v to 1.8v. For the specific regs it was observed
> 
> The edge configuration is a port configuration. So it should be inside
> the port DT node it applies to. That also gives a clean way forward
> when a new switch appears with more SGMII interfaces, each with its
> own edge configuration.
> 

Problem here is that from Documentation falling edge can be set only on
PAD0. PAD5 and PAD6 have the related bit reserved.
But anyway qca8k support only single sgmii and it's not supported a
config with multiple sgmii. Do we have standard binding for this?

> But that then leads into the MAC0/MAC6 swap mess. I need to think
> about that some more, how do we cleanly describe that in DT.
> 
>       Andrew

About the mac swap. Do we really need to implement a complex thing for
something that is really implemented internally to the switch? With this
option MAC6 is swapped with MAC0. But with the port configuration in DT
it doesn't change anything. Same reg, no change. It's really that some
OEM connect the secondary port instead of the primary (for some reason,
hw choice?) and swap them internally.

Anyway some question.
I will move the falling binding to the port DT node and move the
configuration to mac_config. Should I keep the
dedicated function to setup PAD0 swap or I can directly add the check in
the qca8k_setup for only the bit related to enable the swap?

-- 
	Ansuel
