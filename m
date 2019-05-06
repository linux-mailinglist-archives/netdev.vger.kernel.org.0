Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E43C614E9A
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 17:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbfEFOjO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 10:39:14 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:33524 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727748AbfEFOjO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 10:39:14 -0400
Received: by mail-lj1-f196.google.com with SMTP id f23so11327648ljc.0;
        Mon, 06 May 2019 07:39:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=aea4AeGRcNFYVaxX9HKC+puP0Uu/dDxECENRVLl8ZzQ=;
        b=hKgCp8gP1dbtFfMP1v2Z6/JR65Xgq8Df0RqAuCJQ9vs/9uy/h8M0pWhM65UvcdvWy7
         EzHPVghXOEczgnEYKPs3RoXqNBOk8kjvoYYfIfA6pOtzdnkLvrDn4r5CE6BvI0zBxo4R
         kiEWvwJdyCWc38A/7O3XNOisUPzDYRfMChRsjowiP8xjTLPu6dv63WzRtT6dm1p9m4CW
         jVR9NzG8VkcxPEArSjO2NEvknjvp4tA3x/+LA24wRGUodIdoWpLEz2QxLEtsBx9rmxG0
         3oiYYQOtz03f9ud+IY8flRIV6Hi3Cfi4Bx6R5hp4bFFKos8xIIH/9orVEcsr11pejURe
         ebDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=aea4AeGRcNFYVaxX9HKC+puP0Uu/dDxECENRVLl8ZzQ=;
        b=XOx9RSkMkIdi8j+IbbZE2rA1R1Cxo8JCVmd5xcCrgBdP+69zARZVUkBQ5CeLw/BhPR
         3HoqGOR/AaHUt/2gRy7w1jXwDmmY1Jd0pzBqlCtrwnOKnT7Tsk0kVAoBmEkHnW/llib3
         dhKgBMdua5dN9jrjuND2Y0CDHEtuqgcxaFycP7/6oDGddWnvuE99kYOGVPQYYahWBbLr
         VfI0I+ClXE3bKDno+mDnW3MfWrdNpKH8x0PT4YhXcLv1IJJRpxKQCWsRdQ4Za891oiTZ
         kAAX53wgDMLgIQEwtX/55Xdff07VmQ6KBomrlxfFJdqEtdC9h1o1ANeSneLwmiqZP1Ie
         O/cA==
X-Gm-Message-State: APjAAAXGFNA/ChKHsLgnetp1BUoU0U0HsRCscpsg+raWg6Yty5VfjWzq
        gQYKIhAdjy/ZU042GLK1qV8=
X-Google-Smtp-Source: APXvYqxSzsUHKviXNs/xM2+ZB2tYRfkOuCfgvHSUV1EGi1G7PCKqMGLpl6MFky2QGSZHRz+h8uvViw==
X-Received: by 2002:a2e:9c57:: with SMTP id t23mr13974422ljj.152.1557153550534;
        Mon, 06 May 2019 07:39:10 -0700 (PDT)
Received: from mobilestation ([5.164.217.122])
        by smtp.gmail.com with ESMTPSA id q29sm2416918ljc.8.2019.05.06.07.39.09
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 06 May 2019 07:39:09 -0700 (PDT)
Date:   Mon, 6 May 2019 17:39:07 +0300
From:   Serge Semin <fancer.lancer@gmail.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Serge Semin <Sergey.Semin@t-platforms.ru>,
        netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] net: phy: realtek: Change TX-delay setting for
 RGMII modes only
Message-ID: <20190506143906.o3tublcxr5ge46rg@mobilestation>
References: <20190426212112.5624-1-fancer.lancer@gmail.com>
 <20190426212112.5624-2-fancer.lancer@gmail.com>
 <20190426214631.GV4041@lunn.ch>
 <20190426233511.qnkgz75ag7axt5lp@mobilestation>
 <f27df721-47aa-a708-aaee-69be53def814@gmail.com>
 <CA+h21hpTRCrD=FxDr=ihDPr+Pdhu6hXT3xcKs47-NZZZ3D9zyg@mail.gmail.com>
 <20190429211225.ce7cspqwvlhwdxv6@mobilestation>
 <CAFBinCBxgMr6ZkOSGfXZ9VwJML=GnzrL+FSo5jMpN27L2o5+JA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFBinCBxgMr6ZkOSGfXZ9VwJML=GnzrL+FSo5jMpN27L2o5+JA@mail.gmail.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Martin.

On Tue, Apr 30, 2019 at 11:16:21PM +0200, Martin Blumenstingl wrote:
>  Hello Serge,
> 
> On Mon, Apr 29, 2019 at 11:12 PM Serge Semin <fancer.lancer@gmail.com> wrote:
> [...]
> > > > > Apparently the current config_init method doesn't support RXID setting.
> > > > > The patch introduced current function code was submitted by
> > > > > Martin Blumenstingl in 2016:
> > > > > https://patchwork.kernel.org/patch/9447581/
> > > > > and was reviewed by Florian. So we'd better ask him why it was ok to mark
> > > > > the RGMII_ID as supported while only TX-delay could be set.
> > > > > I also failed to find anything regarding programmatic rtl8211f delays setting
> > > > > in the Internet. So at this point we can set TX-delay only for f-model of the PHY.
> let me give you a bit of context on that patch:
> most boards (SBCs and TV boxes) with an Amlogic SoC and a Gigabit
> Ethernet PHY use a Realtek RTL8211F PHY. we were seeing high packet
> loss when transmitting from the board to another device.
> it took us very long to understand that a combination of different
> hardware and driver pieces lead to this issue:
> - in the MAC driver we enabled a 2ns TX delay by default, like Amlogic
> does it in their vendor (BSP) kernel
> - we used the upstream Realtek RTL8211F PHY driver which only enabled
> the TX delay if requested (it never disabled the TX delay)
> - hardware defaults or pin strapping of the Realtek RTL8211F PHY
> enabled the TX delay in the PHY
> 
> This means that the TX delay was applied twice: once at the MAC and
> once at the PHY.
> That lead to high packet loss when transmitting data.
> To solve that I wrote the patch you mentioned, which has since been
> ported over to u-boot (for a non-Amlogic related board)
> 

Yeah. This is a standard problem if you ever worked with a hardware just
designed, when you try to make MAC+PHY working together. If you experienced
packets loss and it's RGMII, then most likely the problem with delays.

> > > > > Anyway lets clarify the situation before to proceed further. You are suggesting
> > > > > to return an error in case if either RGMII_ID or RGMII_RXID interface mode is
> > > > > requested to be enabled for the PHY. It's fair seeing the driver can't fully
> > > > > support either of them.
> I don't have any datasheet for the Realtek RTL8211F PHY and I'm not in
> the position to get one (company contracts seem to be required for
> this).
> Linux is not my main job, I do driver development in my spare time.
> 
> there may or may not be a register or pin strapping to configure the RX delay.
> due to this I decided to leave the RX delay behavior "not defined"
> instead of rejecting RGMII_RXID and RGMII_ID.
> 
> > > > That is how I read Andrew's suggestion and it is reasonable. WRT to the
> > > > original changes from Martin, he is probably the one you would want to
> > > > add to this conversation in case there are any RX delay control knobs
> > > > available, I certainly don't have the datasheet, and Martin's change
> > > > looks and looked reasonable, seemingly independent of the direction of
> > > > this very conversation we are having.
> the changes in patch 1 are looking good to me (except that I would use
> phy_modify_paged instead of open-coding it, functionally it's
> identical with what you have already)
> 

Nah, this isn't going to work since the config register is placed on an extension
page. So in order to reach the register first I needed to enable a standard page,
then select an extended page, then modify the register bits.

> I'm not sure about patch 2:
> personally I would wait for someone to come up with the requirement to
> use RGMII_RXID with a RTL8211F PHY.
> that person will then a board to test the changes and (hopefully) a
> datasheet to explain the RX delay situation with that PHY.
> that way we only change the RGMII_RXID behavior once (when someone
> requests support for it) instead of twice (now with your change, later
> on when someone needs RGMII_RXID support in the RTL8211F driver)
> 
> that said, the change in patch 2 itself looks fine on Amlogic boards
> (because all upstream .dts let the MAC generate the TX delay). I
> haven't runtime-tested your patch there yet.
> but there seem to be other boards (than the Amlogic ones, the RTL8211F
> PHY driver discussion in u-boot was not related to an Amlogic board)
> out there with a RTL8211F PHY (these may or may not be supported in
> mainline Linux or u-boot and may or may not use RGMII_RXID where you
> are now changing the behavior). that's not a problem by itself, but
> you should be aware of this.
> 
> [...]
> > rtl8211(e|f) TX/RX delays can be configured either by external pins
> > strapping or via software registers. This is one of the clue to provide
> > a proper config_init method code. But not all rtl8211f phys provide
> > that software register, and if they do it only concerns TX-delay (as we
> > aware of). So we need to take this into account when creating the updated
> > versions of these functions.
> >
> > (Martin, I also Cc'ed you in this discussion, so if you have anything to
> > say in this matter, please don't hesitate to comment.)
> Amlogic boards, such as the Hardkernel Odroid-C1 and Odroid-C2 as well
> as the Khadas VIM2 use a "RTL8211F" RGMII PHY. I don't know whether
> there are multiple versions of this PHY. all RTL8211F I have seen so
> far did behave exactly the same.
> 
> I also don't know whether the RX delay is configurable (by pin
> strapping or some register) on RTL8211F PHYs because I don't have
> access to the datasheet.
> 
> 
> Martin

Ok. Thanks for the comments. I am sure the RX-delay is configurable at list
via external RXD pin strapping at the chip powering up procedure. The only
problem with a way of software to change the setting.

I don't think there is going to be anyone revealing that realtek black boxed
registers layout anytime soon. So as I see it it's better to leave the
rtl8211f-part as is for now.

-Sergey
