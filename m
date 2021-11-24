Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D681C45C70C
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 15:17:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351176AbhKXOVF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 09:21:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353562AbhKXOS7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 09:18:59 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E706C09ECD0;
        Wed, 24 Nov 2021 04:31:38 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id x15so9733533edv.1;
        Wed, 24 Nov 2021 04:31:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=X5je2/JyWbZDgEix/0iijJu6E649kdB2MShuic6l19c=;
        b=glqvVH0ZWNXWeAacsTHEVBLyekrLB3AQ8NtAzGScFKx8xTYwAo335/g7fbQ9cKGP3O
         165XqgkEwC8PHyswGFuzQwe2QrPCwzQMv+a+nK5BQTsrEG2YdNh1WpiIWO6rErEguu5S
         iBE9cm+akpQxpc0m0ov/QwMYQ2ODVdrGq5szOAed99bgpBL1UgCwhncyW9ezLG1u4K4y
         vrC4fY8rpxXk6L+4iqDnqptv4TKHUWfk3uZVngQrFtfrBVYHdxz2OEHEReDcDl6f1/Ly
         00sMDAn6WIZ6RQu1WSTCmqi5zuzsd3cA79B2U5iK+iDxJSwEnJBnRy9iF9ud3i4R648k
         5FgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=X5je2/JyWbZDgEix/0iijJu6E649kdB2MShuic6l19c=;
        b=Bwn0fIFb4JI3pjUvs0ipd7IqtoTkKVc4ycvgJLBqwlLfvXFOu0VLJF0PpFKb9+CsEF
         cxKwXtiXjlZk3ZhZgqY/Qr1nBV5yUsV900bJfrEjerhuHksehTFUDe0DTYnHEXHZ9TYF
         GgPKXI6vxuwKZk+Cn5NguPHFkPKQ3ZTmtfSkN4graQbNvHN54Ew8zF0Qky6+SBiOGMCG
         EL68Wdz2csuGcRtNT2X3zDhY7FR+SNBJzbDMCHFn95meXH5AhNLHe5J/3JE8swP0zee4
         uPLikFZ4mymm0K6YaXzZS03UQQhsuj5OnJJIhKvu6eKj6BNnUS5QSudkBAwR2O34k+11
         aQmA==
X-Gm-Message-State: AOAM5325ZTegiUP/Hl1UR0WxkBKiYsepHY/PQLZcR0aAEqf95X51zYJI
        ACXx9ZxlNltjFrqCIOZ8h8FeDCafaQQ=
X-Google-Smtp-Source: ABdhPJzQZ14vlyXVA1zbOxCmypxqMjsz6ZV1ngM71Eyx9n3mBvO6PSm4xUpKr6qvFeyKaxz/lgJkrA==
X-Received: by 2002:a05:6402:3550:: with SMTP id f16mr24332132edd.377.1637757097011;
        Wed, 24 Nov 2021 04:31:37 -0800 (PST)
Received: from skbuf ([188.25.163.189])
        by smtp.gmail.com with ESMTPSA id t5sm8170493edd.68.2021.11.24.04.31.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 04:31:36 -0800 (PST)
Date:   Wed, 24 Nov 2021 14:31:35 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Sean Anderson <sean.anderson@seco.com>, davem@davemloft.net
Subject: Re: [PATCH net-next v2 4/8] net: phylink: update
 supported_interfaces with modes from fwnode
Message-ID: <20211124123135.wn4lef5iv2k26txb@skbuf>
References: <20211123164027.15618-1-kabel@kernel.org>
 <20211123164027.15618-5-kabel@kernel.org>
 <20211123212441.qwgqaad74zciw6wj@skbuf>
 <20211123232713.460e3241@thinkpad>
 <20211123225418.skpnnhnrsdqrwv5f@skbuf>
 <YZ4cRWkEO+l1W08u@shell.armlinux.org.uk>
 <20211124120441.i7735czjm5k3mkwh@skbuf>
 <20211124131703.30176315@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211124131703.30176315@thinkpad>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 24, 2021 at 01:17:03PM +0100, Marek Behún wrote:
> On Wed, 24 Nov 2021 14:04:41 +0200
> Vladimir Oltean <olteanv@gmail.com> wrote:
> 
> > On Wed, Nov 24, 2021 at 11:04:37AM +0000, Russell King (Oracle) wrote:
> > > On Wed, Nov 24, 2021 at 12:54:18AM +0200, Vladimir Oltean wrote:  
> > > > This implies that when you bring up a board and write the device tree
> > > > for it, you know that PHY mode X works without ever testing it. What if
> > > > it doesn't work when you finally add support for it? Now you already
> > > > have one DT blob in circulation. That's why I'm saying that maybe it
> > > > could be better if we could think in terms that are a bit more physical
> > > > and easy to characterize.  
> > > 
> > > However, it doesn't solve the problem. Let's take an example.
> > > 
> > > The 3310 supports a mode where it runs in XAUI/5GBASE-R/2500BASE-X/SGMII
> > > depending on the negotiated media parameters.
> > > 
> > > XAUI is four lanes of 3.125Gbaud.
> > > 5GBASE-R is one lane of 5.15625Gbaud.
> > > 
> > > Let's say you're using this, and test the 10G speed using XAUI,
> > > intending the other speeds to work. So you put in DT that you support
> > > four lanes and up to 5.15625Gbaud.  
> > 
> > Yes, see, the blame's on you if you do that.You effectively declared
> > that the lane is able of sustaining a data rate higher than you've
> > actually had proof it does (5.156 vs 3.125).
> 
> But the blame is on the DT writer in the same way if they declare
> support for a PHY mode that wasn't tested. (Or at least self-tests with
> PRBS patterns at given frequency.)

I think we're running around in circles on this one. I think there's an
overlap between the supported_interfaces and the phy-mode array in
device tree. Going back to your example with the SMC calls unsupported
by ATF, you may run into the surprise that you have a phy-mode in the
device tree which you need to mask out in Linux, via supported_interfaces.
You would have needed to mask it out anyway, even with my proposal, so
you don't gain anything except the extra burden of spelling out 5 lines
of a phy-mode array in the device tree. It's going to be a nightmare for
review, it isn't obvious to say that "this phy-mode shouldn't be here"
or "you're missing this phy-mode".

> > The reason why I'm making this suggestion is because I think it lends
> > itself better to the way in which hardware manufacturers work.
> > A hobbyist like me has no choice than to test the highest data rate when
> > determining what frequency to declare in the DT (it's the same thing for
> > spi-max-frequency and other limilar DT properties, really), but hardware
> > people have simulations based on IBIS-AMI models, they can do SERDES
> > self-tests using PRBS patterns, lots of stuff to characterize what
> > frequency a lane is rated for, without actually speaking any Ethernet
> > protocol on it. In fact there are lots of people who can do this stuff
> > (which I know mostly nothing about) with precision without even knowing
> > how to even type a simple "ls" inside a Linux shell.
> >
> > > Later, you discover that 5GBASE-R doesn't work because there's an
> > > electrical issue with the board. You now have DT in circulation
> > > which doesn't match the capabilities of the hardware.
> > > 
> > > How is this any different from the situation you describe above?
> > > To me, it seems to be exactly the same problem.  
> > 
> > To err is human, of course. But one thing I think we learned from the
> > old implementation of phylink_validate is that it gets very tiring to
> > keep adding PHY modes, and we always seem to miss some. When that array
> > will be described in DT, it could be just a tad more painful to maintain.
> 
> The thing is that we will still need the `phy-mode` property, it can't
> be deprecated IMO.

Wait a minute, who said anything about deprecating it? I just said
"let's not make it an array, in the actual device tree". The phy-mode
was, and will remain, the initial MII-side protocol, which can or cannot
be changed at runtime.

> There are non-SerDes modes, like rgmii, which may use different pins
> than SerDes modes.

And, as discussed, there is no use case for dynamic switchover between
RGMII and a SERDES lane.

> There may theoretically also be a SoC or PHY where the lanes for XAUI
> do not share pins with the lane of 2500base-x, and this lane may not be
> wired. Tis true that I don't know of any such hardware and it probably
> does not and will not exist, but we don't know that for sure and this is
> a case where your proposal will fail and the phy-mode extension would
> work nicely.

We haven't gotten to discussing any of the details yet, but my proposal
of course would have been to describe the number of SERDES lanes and max
frequency in the COMPHY nodes, and have the COMPHY tell you what is
supported. At least with Layerscape, that would be the model. So when
you have pinmuxing, you just get the capabilities from the lane in use.

> 
> Maybe we need opinions from other people here.

Other opinions are welcome of course.
