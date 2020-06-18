Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B09451FEE04
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 10:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728742AbgFRIqK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 04:46:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728536AbgFRIqI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 04:46:08 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1403AC06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 01:46:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=F8BeSVOOvL0LPqW8hl3ViiGKgayWjEyJ+gtoO9fu4nQ=; b=a/PNhGf0dXMV/OMJQUeoqK2+/
        sW2ukMtp5C6+eSzsJxlrBnoz0wzKm0oZA/hH2mUfxjEUlu3tU8OjIrFA9CQLkjQ28385GGDOxUdE3
        mRhMLWChoCgdBwVX6stfZQq2MiTKTR9OiiiN0L2QA6gs6iEo+wdC4TDgVw/JsQh/7xGEo9xh8U9+l
        E7o/3MTsVGN4N8lSn0/klltoG/csFQZmlcUx5uEn8m/xKDgSKQJ+cZLWlT6H0e8o++5gy02dfoZAI
        tV5pv79q+GttielL8JJaG/o8Tzlhff/OIdtOHYQYlk4gYWBgSwr4vXWMJTRW6DIhc0Euue/nvCQxk
        gUuAFLvWg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58772)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jlqBL-0004m4-0Z; Thu, 18 Jun 2020 09:45:59 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jlqBG-0004ak-Hw; Thu, 18 Jun 2020 09:45:54 +0100
Date:   Thu, 18 Jun 2020 09:45:54 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Helmut Grohne <helmut.grohne@intenta.de>
Cc:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH] net: macb: reject unsupported rgmii delays
Message-ID: <20200618084554.GY1551@shell.armlinux.org.uk>
References: <20200616074955.GA9092@laureti-dev>
 <20200617105518.GO1551@shell.armlinux.org.uk>
 <20200617112153.GB28783@laureti-dev>
 <20200617114025.GQ1551@shell.armlinux.org.uk>
 <20200617115201.GA30172@laureti-dev>
 <20200617120809.GS1551@shell.armlinux.org.uk>
 <20200618081433.GA22636@laureti-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200618081433.GA22636@laureti-dev>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 18, 2020 at 10:14:33AM +0200, Helmut Grohne wrote:
> On Wed, Jun 17, 2020 at 02:08:09PM +0200, Russell King - ARM Linux admin wrote:
> > With a fixed link, we could be in either a MAC-to-PHY or MAC-to-MAC
> > setup; we just don't know.  However, we don't have is access to the
> > PHY (if it exists) in the fixed link case to configure it for the
> > delay.
> 
> Let me twist that a little: We may have access to the PHY, but we don't
> always have access. When we do have access, we have a separate device
> tree node with another fixed-link and another phy-mode. For fixed-links,
> we specify the phy-mode for each end.

If you have access to the PHY, you shouldn't be using fixed-link. In
any case, there is no support for a fixed-link specification at the
PHY end in the kernel.  The PHY binding doc does not allow for this
either.

> > In the MAC-to-MAC RGMII setup, where neither MAC can insert the
> > necessary delay, the only way to have a RGMII conformant link is to
> > have the PCB traces induce the necessary delay. That errs towards
> > PHY_INTERFACE_MODE_RGMII for this case.
> 
> Yes.
> 
> > However, considering the MAC-to-PHY RGMII fixed link case, where the
> > PHY may not be accessible, and may be configured with the necessary
> > delay, should that case also use PHY_INTERFACE_MODE_RGMII - clearly
> > that would be as wrong as using PHY_INTERFACE_MODE_RGMII_ID would
> > be for the MAC-to-MAC RGMII with PCB-delays case.
> 
> If you take into account that the PHY has a separate node with phy-mode
> being rgmii-id, it makes a lot more sense to use rgmii for the phy-mode
> of the MAC. So I don't think it is that clear that doing so is wrong.

The PHY binding document does not allow for this, neither does the
kernel.

> In an earlier discussion Florian Fainelli said:
> https://patchwork.ozlabs.org/project/netdev/patch/20190410005700.31582-19-olteanv@gmail.com/#2149183
> | fixed-link really should denote a MAC to MAC connection so if you have
> | "rgmii-id" on one side, you would expect "rgmii" on the other side
> | (unless PCB traces account for delays, grrr).
> 
> For these reasons, I still think that rgmii would be a useful
> description for the fixed-link to PHY connection where the PHY adds the
> delay.

I think Florian is wrong; consider what it means when you have a
fixed-link connection between a MAC and an inaccessible PHY and
the link as a whole is operating in what we would call "rgmii-id"
mode if the PHY were accessible.

Taking Florian's stance, it basically means that DT no longer
describes the hardware, but how we have chosen to interpret the
properties in _one_ specific case in a completely different way
to all the other cases.

> > So, I think a MAC driver should not care about the specific RGMII
> > mode being asked for in any case, and just accept them all.
> 
> I would like to agree to this. However, the implication is that when you
> get your delays wrong, your driver silently ignores you and you never
> notice your mistake until you see no traffic passing and wonder why.

So explain to me this aspect of your reasoning:

- If the link is operating in non-fixed-link mode, the rgmii* PHY modes
  describe the delay to be applied at the PHY end.
- If the link is operating in fixed-link mode, the rgmii* PHY modes
  describe the delay to be applied at the MAC end.

That doesn't make sense, and excludes properly describing a MAC-to-
inaccessible-PHY setup.

It also means that we're having to conditionalise how we deal with
this PHY mode in every single driver, which means that every single
driver is going to end up interpreting it differently, and it's going
to become a buggy mess.

> In this case, I was faced with a PHY that would do rgmii-txid and I
> configured that on the MAC. Unfortunately, macb_main.c didn't tell me
> that it did rgmii-id instead.

The documentation makes it clear that "rgmii-*" (note the hyphen) are
to be applied by the PHY *only*, and not by the MAC.

> > I also think that some of this ought to be put in the documentation
> > as guidance for new implementations.
> 
> That seems to be the part where everyone agrees.
> 
> Given the state of the discussion, I'm wondering whether this could be
> fixed at a more fundamental level in the device tree bindings.
> 
> A number of people (including you) pointed out that retroactively fixing
> the meaning of phy modes does not work and causes pain instead. That
> hints that the only way to fix this is adding new properties. How about
> this?
> 
> rgmii-delay-type:
>   description:
>     Responsibility for adding the rgmii delay
>   enum:
>     # The remote PHY or MAC to this MAC is responsible for adding the
>     # delay.
>     - remote
>     # The delay is added by neither MAC nor MAC, but using PCB traces
>     # instead.
>     - pcb
>     # The MAC must add the delay.
>     - local

Why do we need that complexity?  If we decide that we can allow
phy-mode = "rgmii" and introduce new properties to control the
delay, then we just need:

  rgmii-tx-delay-ps = <nnn>;
  rgmii-rx-delay-ps = <nnn>;

specified in the MAC node (to be applied only at the MAC end) or
specified in the PHY node (to be applied only at the PHY end.)
In the normal case, this would be the standard delay value, but
in exceptional cases where supported, the delays can be arbitary.
We know there are PHYs out there which allow other delays.

This means each end is responsible for parsing these properties in
its own node and applying them - or raising an error if they can't
be supported.

With your "rgmii-delay-type" idea, if this is only specified at the
MAC end, then the PHY code somehow needs to know what that setting is,
which adds a lot of complexity - the PHY code has to go digging for
the MAC node, we may even have to introduce a back-reference from the
PHY node to the MAC node so the PHY can find it.  There are MAC drivers
out there where there is one struct device, but multiple net devices,
so digging inside struct net_device to get at the parent struct device,
and then trying to parse "rgmii-delay-type" from the of-node won't work.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
