Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87B0045AF7C
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 23:54:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240156AbhKWW5a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 17:57:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbhKWW5a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 17:57:30 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE3E4C061574;
        Tue, 23 Nov 2021 14:54:21 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id y12so1468926eda.12;
        Tue, 23 Nov 2021 14:54:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=kZngurb7Td0+PeZ1jd/rbNk8qe4Rsn/+CvzMe0TnbwQ=;
        b=Luz/Gu81d9tBosMUVuH8I6nS7JRe1sJ9E/G7wy7TLWK0HzESszAdUObMmFdxPqB4Hw
         0uJnBAtzAbh/RxDqcLIQCzwxMapANbtk94N8J1RMX2fkUYtUOf4TvJf59DCEs8Yztgi9
         z6RObxCMMhTL8YgxjGqBkRqyrFa40BfrLZUQ7h9zljL+MRQZ5Se/sZ7f2L9KpkstYE3t
         U/nbITyzxo2ZyeKgAgDrCjG02DGLUvt34taOLSbqSYlyit/KCTCJvV03jjHjRab5HuU9
         F7u+uOwkRQVLFxITMcW1WWQ60r+KeUi3mdFW2rtuZGX2x6BhzrhHaom1XZ217RiKzSrJ
         uCqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=kZngurb7Td0+PeZ1jd/rbNk8qe4Rsn/+CvzMe0TnbwQ=;
        b=GlNCpB7Fv1njC66vQZ3CwNmPUG2HcvgKB0aBu8QsTpl03AJmKXPzwmkt13qDWi1Yql
         /Yc0Kp7e0qcowN14t66lIKCg6/SGhUzn6/7hSrlL13q/ObM6xZNjU2CdwJQJ8DWNdwZ+
         ArSnzBxvny7C5Yd+41P+vpJJCvbXN9yJUL+PXLuy4JLq/x13NUdzwkOf8LCvuQxdf03g
         itFWDlmNwzjSB/KkdumBpfnqh5qzKV2uSxhYkZFKEF03MRvXyvhAKhBFRmJW11lCe4vW
         RltsjQccOWCa4upgK4mIF42fh3o2XcOX2SCkvEer0EAboxQ7Q60h3cv5gfHRHKEbt32k
         8O7g==
X-Gm-Message-State: AOAM531W3FbmtVwyNXTuAFh9la3g2vsA1b+Tgf1300gsxtfonUQV9UDU
        XxZBOQByBNFsOl24IAxv86A=
X-Google-Smtp-Source: ABdhPJwB50AYmyY4eiBePNDOwXdQg4RxncRjga7kyvbhV7FXqbjZ7YWLD3h0cbzmwvD0ul28KFS+dw==
X-Received: by 2002:a05:6402:5110:: with SMTP id m16mr15795644edd.15.1637708060161;
        Tue, 23 Nov 2021 14:54:20 -0800 (PST)
Received: from skbuf ([188.25.163.189])
        by smtp.gmail.com with ESMTPSA id ds17sm6121744ejc.45.2021.11.23.14.54.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Nov 2021 14:54:19 -0800 (PST)
Date:   Wed, 24 Nov 2021 00:54:18 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Sean Anderson <sean.anderson@seco.com>, davem@davemloft.net
Subject: Re: [PATCH net-next v2 4/8] net: phylink: update
 supported_interfaces with modes from fwnode
Message-ID: <20211123225418.skpnnhnrsdqrwv5f@skbuf>
References: <20211123164027.15618-1-kabel@kernel.org>
 <20211123164027.15618-5-kabel@kernel.org>
 <20211123212441.qwgqaad74zciw6wj@skbuf>
 <20211123232713.460e3241@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211123232713.460e3241@thinkpad>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 23, 2021 at 11:27:13PM +0100, Marek Behún wrote:
> Hi Vladimir,
> 
> On Tue, 23 Nov 2021 23:24:41 +0200
> Vladimir Oltean <olteanv@gmail.com> wrote:
> 
> > > +	/* We want the intersection of given supported modes with those defined
> > > +	 * in DT.
> > > +	 *
> > > +	 * Some older device-trees mention only one of `sgmii`, `1000base-x` or
> > > +	 * `2500base-x`, while supporting all three. Other mention `10gbase-r`
> > > +	 * or `usxgmii`, while supporting both, and also `sgmii`, `1000base-x`,
> > > +	 * `2500base-x` and `5gbase-r`.
> > > +	 * For backwards compatibility with these older DTs, make it so that if
> > > +	 * one of these modes is mentioned in DT and MAC supports more of them,
> > > +	 * keep all that are supported according to the logic above.
> > > +	 *
> > > +	 * Nonetheless it is possible that a device may support only one mode,
> > > +	 * for example 1000base-x, due to strapping pins or some other reasons.
> > > +	 * If a specific device supports only the mode mentioned in DT, the
> > > +	 * exception should be made here with of_machine_is_compatible().
> > > +	 */
> > > +	if (bitmap_weight(modes, PHY_INTERFACE_MODE_MAX) == 1) {  
> > 
> > I like the idea of extending the mask of phy_modes based on the
> > phylink_config.supported_interfaces bitmap that the driver populates
> > (assuming, of course, that it's converted correctly to this new format,
> > and I looked through the implementations and just found a bug).
> 
> Russell is working on converting/fixing the drivers, you can look at his
> changes at
>  http://git.armlinux.org.uk/cgit/linux-arm.git/log/?h=net-queue
> look at the first two pages, search for "populate supported_interfaces"

This one is a mistake in one of the existing conversions, I looked at
the git tree that you pointed to and I don't see any fixup patch on that
driver. I'm currently testing a fix, but it might take until tomorrow
until I post anything.

> > I think
> > it might just work with old device trees, too. In fact, it may work so
> > well, that I would even be tempted to ask "can we defer for a while
> > updating the device trees and bindings documents with an array, just
> > keep the phy modes as an array internally inside the kernel?"
> 
> We don't need to update the device-trees immediately, but I really
> think the DT binding should be ready to allow multiple modes, if
> someone does want to update.
> 
> > On the Marvell boards that you're working with, do you have an example
> > board on which not all the PHY modes supported by the driver might be
> > available? Do you also know the reason why? You give an example in the
> > comments about 1000base-X and strapping, can you expand on that?
> 
> On Macchiatobin, both the mvpp2 MAC driver and the marvell10g PHY
> driver support xaui mode, but that mode requires 4 SerDes lanes, and
> the boards wires only one lane between the SOC and the PHY, so obviously
> it cannot be used. Thinking about it, maybe I should have put this into
> the commit message.

Yes, so 4 lanes of 3.125 GHz or higher could support XAUI, 1 lane of
3.125 GHz or higher could support 2500base-X but not XAUI. Sounds like
simple logic.

> 
> > Because I think it's a bit strange to create a framework for fixups now,
> > when we don't even know what kind of stuff may be broken. The PHY modes
> > (effectively SERDES protocols) might not be what you actually want to restrict.
> > I mean, restricting the PHY modes is like saying: "the MAC supports
> > USXGMII and 10GBase-R, the PHY supports USXGMII and 10GBase-R, I know
> > how to configure both of them in each mode, but on this board, USXGMII
> > works and 10GBase-R doesn't".
> > 
> > ?!
> 
> As I said above, the best example is with SerDeses which use multiple
> lanes where not all may be wired. But this backward compatibility code
> concerns only one-lane SerDeses: usxgmii, 10gbaser-r, 5gbase-r,
> 2500base-x, 1000base-x, sgmii.

Right, why so? From phy-mode = "xaui", you could also infer support for
single-lane SERDES protocols up to 3.125 GHz, aren't you interested in
doing that too?

> For these, I can think only of 2
> possibilities why a fixup might be needed to restrict some mode when it
> is supported both by MAC and PHY:
> 1) the mode is not supported by the board because it has too large
>    frequency and the wiring on the board interferes with it.
>    Example:
>    - device tree defined phy-mode = "sgmii"
>    - from this we infer also 1000base-x and 2500base-x
>    - but 2500base-x works at 2.5x the frequency of 1000base-x/sgmii
>    - the board wiring does not work at that frequency
> 
>    I don't know of any such board, but I know that such thing is
>    possible, because for example the connetor on Turris MOX modules
>    allows only frequencies up to 6 GHz. So it is not impossible for
>    there to be boards where only 2 GHz is supported...

Right. We're saying the same thing, basically.

> 2) the mode is not supported by the board because the generic PHY
>    driver uses SMC calls to the firmware to change the SerDes mode, but
>    the board may have old version of firmware which does not support
>    SMC call correctly (or at all). This was a real issue with TF-A
>    firmware on Macchiatobin, where the 5gbase-r mode was not supported
>    in older versions

Ok, so in your proposal, U-Boot would have to fix up the device tree
based on a certain version of ATF, and remove "5gbase-r" from the
phy-mode array. Whereas in my proposal, the mvpp2 driver would need to
find out about the ATF version in use, and remove "5gbase-r" from the
supported interfaces.

As a user, I'd certainly prefer if Linux could figure this one out.

> > It may make more sense, when the time comes for the first fixup, to put
> > a cap on the maximum gross data rate attainable on that particular lane
> > (including stuff such as USXGMII symbol repetition), instead of having
> > to list out all the PHY modes that a driver might or might not support
> > right now. Imagine what pain it will be to update device trees each time
> > a driver gains software support for a SERDES protocol it didn't support
> > before. But if you cap the lane frequency, you can make phylink_update_phy_modes()
> > deduce what isn't acceptable using simple logic.
> 
> So we would need to specify max data rate, usxgmii symbol repetition,

No, not symbol repetition. Just data rate and number of lanes.

> and number of lanes connected, and even then it could be not enough.
> I think that simply specifying all the phy-modes that the HW supports
> is simpler.
> 
> The devicetree does not need and should not be updated each time
> software gains support for another SerDes protocol. The devicetree
> should be updated only once, to specify all SerDes protocols that the
> hardware supports (the SOC/MAC, the PHY, and the board wiring). The
> software then takes from this list only those modes that the drivers
> support. So no need to update device-tree each time SW gains support
> for new SerDes mode.

This implies that when you bring up a board and write the device tree
for it, you know that PHY mode X works without ever testing it. What if
it doesn't work when you finally add support for it? Now you already
have one DT blob in circulation. That's why I'm saying that maybe it
could be better if we could think in terms that are a bit more physical
and easy to characterize.

> > Also, if there's something to be broken by this change, why would we put
> > an of_machine_is_compatible() here, and why wouldn't we instead update
> > the phylink_config.supported_interfaces directly in the driver? I think
> > it's the driver's responsibility for passing a valid mask of supported
> > interfaces.
> 
> The whole idea of this code is to guarantee backward compatibility with
> older device-trees. In my opinion (and I think Russell agrees with me),
> this should be at one place, instead of putting various weird
> exceptions into various MAC drivers.

Yes, but they're more flexible in the driver... What if the check is not
as simple as a machine compatible (think about the ATF firmware example
you gave).
