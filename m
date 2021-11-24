Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64E4645BB18
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 13:14:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234102AbhKXMQ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 07:16:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242301AbhKXMOm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 07:14:42 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92CCEC061A1B;
        Wed, 24 Nov 2021 04:04:44 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id l25so9153835eda.11;
        Wed, 24 Nov 2021 04:04:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=10gsK4tMkUuOgwUjtjiVsuHLHQT8TklFPGac4Ek2dJY=;
        b=eZ/OhZGJXWnKG7BD4BDmsrKfNEblO+SKsMT5BUheXLhSkAnAAGBG+6paAwFDXYQgyq
         48a0yVTpLIoxT3fYlzWfLi9JhRgD2St3fp5avwpdSam1aHAzkhuVJorHWhdDqHRjMFTV
         PaqOrPXSeR7hoBSCoNHdVfHdO8HY2rzHOW6aaZB8D8RGvqafOb/OsoS2YrNC5ins2Vyu
         HroHfQNBlK10xPXnvIgWfQS6I48uDAF5IGQgKdwI4IrjbNBxbenHkb/WwHQADpnd6pXy
         7aplz5f7/WfoSVHQQ9Fk6wp6FsCx1XNxEqaJs7gn0E9AXvIZ0XFVTovr7G7ccsP7959t
         3PRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=10gsK4tMkUuOgwUjtjiVsuHLHQT8TklFPGac4Ek2dJY=;
        b=WNfdiyV/YCwiTPFCnUKhVs0fOgqcHkgPXu2V/fUrhW8hZ6f+fpJbHW4ZqdTn8E4Tae
         OHL5+/3JSx/br3qj7RZs+BmBbzg/NAzAeWlPPn7MBtNeP5LOrfXCTKyfFqHpD8gUPgzy
         na0pLWSq+zrbKsZsFin1WxHivNbrl/TyXBQROmzwtB2qr0GxMtqBZQgntN26uhA8uj85
         UeyvMhJ1wwo4+B4u1RXTSl6ywI46j9GbQsHmBmna7nTLrpl5nRJzr/wPWjoYggRB+NZD
         pTLA8kwOdmUd8/BfLfm67RiHBdfzRnJYUsS2D8dAAro6bbU0Ex5dk112eqI0XbQIUl6a
         VsOw==
X-Gm-Message-State: AOAM530kfhB3TkFP537C/lB0e88iyE3BCQTeuxMS3KXOtCW3KkTV1VxE
        EYQmnuelVq0P8KMzdabrEmg=
X-Google-Smtp-Source: ABdhPJzrekwIT3pQ4VqIsdRstBm861+KfoqTHCvWCt2O4oZzs6NHieqnVCbn7mkRn+cYIH1AFHx/IA==
X-Received: by 2002:a05:6402:3da:: with SMTP id t26mr23542755edw.232.1637755482888;
        Wed, 24 Nov 2021 04:04:42 -0800 (PST)
Received: from skbuf ([188.25.163.189])
        by smtp.gmail.com with ESMTPSA id aq14sm6388557ejc.23.2021.11.24.04.04.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 04:04:42 -0800 (PST)
Date:   Wed, 24 Nov 2021 14:04:41 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>,
        netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Sean Anderson <sean.anderson@seco.com>, davem@davemloft.net
Subject: Re: [PATCH net-next v2 4/8] net: phylink: update
 supported_interfaces with modes from fwnode
Message-ID: <20211124120441.i7735czjm5k3mkwh@skbuf>
References: <20211123164027.15618-1-kabel@kernel.org>
 <20211123164027.15618-5-kabel@kernel.org>
 <20211123212441.qwgqaad74zciw6wj@skbuf>
 <20211123232713.460e3241@thinkpad>
 <20211123225418.skpnnhnrsdqrwv5f@skbuf>
 <YZ4cRWkEO+l1W08u@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YZ4cRWkEO+l1W08u@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 24, 2021 at 11:04:37AM +0000, Russell King (Oracle) wrote:
> On Wed, Nov 24, 2021 at 12:54:18AM +0200, Vladimir Oltean wrote:
> > This implies that when you bring up a board and write the device tree
> > for it, you know that PHY mode X works without ever testing it. What if
> > it doesn't work when you finally add support for it? Now you already
> > have one DT blob in circulation. That's why I'm saying that maybe it
> > could be better if we could think in terms that are a bit more physical
> > and easy to characterize.
> 
> However, it doesn't solve the problem. Let's take an example.
> 
> The 3310 supports a mode where it runs in XAUI/5GBASE-R/2500BASE-X/SGMII
> depending on the negotiated media parameters.
> 
> XAUI is four lanes of 3.125Gbaud.
> 5GBASE-R is one lane of 5.15625Gbaud.
> 
> Let's say you're using this, and test the 10G speed using XAUI,
> intending the other speeds to work. So you put in DT that you support
> four lanes and up to 5.15625Gbaud.

Yes, see, the blame's on you if you do that. You effectively declared
that the lane is able of sustaining a data rate higher than you've
actually had proof it does (5.156 vs 3.125).

The reason why I'm making this suggestion is because I think it lends
itself better to the way in which hardware manufacturers work.
A hobbyist like me has no choice than to test the highest data rate when
determining what frequency to declare in the DT (it's the same thing for
spi-max-frequency and other limilar DT properties, really), but hardware
people have simulations based on IBIS-AMI models, they can do SERDES
self-tests using PRBS patterns, lots of stuff to characterize what
frequency a lane is rated for, without actually speaking any Ethernet
protocol on it. In fact there are lots of people who can do this stuff
(which I know mostly nothing about) with precision without even knowing
how to even type a simple "ls" inside a Linux shell.

> Later, you discover that 5GBASE-R doesn't work because there's an
> electrical issue with the board. You now have DT in circulation
> which doesn't match the capabilities of the hardware.
> 
> How is this any different from the situation you describe above?
> To me, it seems to be exactly the same problem.

To err is human, of course. But one thing I think we learned from the
old implementation of phylink_validate is that it gets very tiring to
keep adding PHY modes, and we always seem to miss some. When that array
will be described in DT, it could be just a tad more painful to maintain.

> So, I don't think one can get away from these kinds of issues - where
> you create a board, do insufficient testing, publish a DT description,
> and then through further testing discover you have to restrict the
> hardware capabilities in DT. In fact, this is sadly an entirely normal
> process - problems always get found after boards have been sent out
> and initial DT has been created.
> 
> A good example is the 6th switch port on the original Clearfog boards.
> This was connected to an external PHY at address 0 on the MDIO bus
> behind the switch. However, the 88E6176 switch already has an internal
> PHY at address 0, so the external PHY can't be accessed. Consequently,
> port 6 is unreliable. That only came to light some time later, and
> resulted in the DT needing to be modified.

Sure, but this is a bit unrelated.

> There are always problems that need DT to be fixed - I don't think it's
> possible to get away from that by changing what or how something is
> described. In fact, I think trying to make that argument actually shows
> a misunderstanding of the process of hardware bringup.

Oh, how so?

> Just like software, hardware is buggy and takes time to be debugged,
> and that process continues after the first version of DT for a board
> has been produced, and there will always be changes required to DT.
> 
> I'm not saying that describing the maximum frequency and lanes doesn't
> have merit, I'm merely taking issue with the basis of your argument.
> 
> -- 
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
