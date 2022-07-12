Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0D65571FF0
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 17:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233393AbiGLPvr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 11:51:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233271AbiGLPvq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 11:51:46 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3A42B41B1;
        Tue, 12 Jul 2022 08:51:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=oqX+95HJH3+GolX5T31WOW5kFxPh81eavvkMu256WSs=; b=AqjCcEbfX++/jHSnNzwOtwLUUZ
        NluT6amZAheEFJN7QBQf0m6vZp8cNCfmVptpf2vc2iuIQmrXTANUKw8rX6ZE+I2LaVgvfU5bFFfEp
        a+W9AFiKadTX4CHaSMn4CbhIzxYZ5G45WLNkH1FwZzumAPCFzHnUMjecfDN+8dekK+PXShyv8HfWD
        uacnRlXo7+ZZAJjToToVfhHIJj5gbjbvDGqJPazf9zrOJM+NCrUJh94a8ROjGgMjZVsUw5UF1Ft3D
        R7E1ETVZkrO9CpNhYL/ePYKyebMsOIgbIVzQN31FkTUaOIQfdJL/KkhKM0P/1dm2KoVWWs6DLsiiT
        LDKQrF9w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33304)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oBIAm-000329-JU; Tue, 12 Jul 2022 16:51:40 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oBIAk-0004o4-1r; Tue, 12 Jul 2022 16:51:38 +0100
Date:   Tue, 12 Jul 2022 16:51:38 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Frank Rowand <frowand.list@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Saravana Kannan <saravanak@google.com>,
        devicetree@vger.kernel.org
Subject: Re: [RFC PATCH net-next 3/9] net: pcs: Add helpers for registering
 and finding PCSs
Message-ID: <Ys2Yiis53M+Lb9rR@shell.armlinux.org.uk>
References: <20220711160519.741990-1-sean.anderson@seco.com>
 <20220711160519.741990-4-sean.anderson@seco.com>
 <YsyPGMOiIGktUlqD@shell.armlinux.org.uk>
 <3aad4e83-4aee-767e-b36d-e014582be7bd@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3aad4e83-4aee-767e-b36d-e014582be7bd@seco.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 11, 2022 at 05:47:26PM -0400, Sean Anderson wrote:
> Hi Russell,
> 
> On 7/11/22 4:59 PM, Russell King (Oracle) wrote:
> > Hi Sean,
> > 
> > It's a good attempt and may be nice to have, but I'm afraid the
> > implementation has a flaw to do with the lifetime of data structures
> > which always becomes a problem when we have multiple devices being
> > used in aggregate.
> > 
> > On Mon, Jul 11, 2022 at 12:05:13PM -0400, Sean Anderson wrote:
> >> +/**
> >> + * pcs_get_tail() - Finish getting a PCS
> >> + * @pcs: The PCS to get, or %NULL if one could not be found
> >> + *
> >> + * This performs common operations necessary when getting a PCS (chiefly
> >> + * incrementing reference counts)
> >> + *
> >> + * Return: @pcs, or an error pointer on failure
> >> + */
> >> +static struct phylink_pcs *pcs_get_tail(struct phylink_pcs *pcs)
> >> +{
> >> +	if (!pcs)
> >> +		return ERR_PTR(-EPROBE_DEFER);
> >> +
> >> +	if (!try_module_get(pcs->ops->owner))
> >> +		return ERR_PTR(-ENODEV);
> > 
> > What you're trying to prevent here is the PCS going away - but holding a
> > reference to the module doesn't prevent that with the driver model. The
> > driver model design is such that a device can be unbound from its driver
> > at any moment. Taking a reference to the module doesn't prevent that,
> > all it does is ensure that the user can't remove the module. It doesn't
> > mean that the "pcs" structure will remain allocated.
> 
> So how do things like (serdes) phys work? Presumably the same hazard
> occurs any time a MAC uses a phy, because the phy can disappear at any time.
> 
> As it happens I can easily trigger an Oops by unbinding my serdes driver
> and the plugging in an ethernet cable. Presumably this means that the phy
> subsystem needs the devlink treatment? There are already several in-tree
> MAC drivers using phys...

It's sadly another example of this kind of thing. When you consider
that the system should operate in a safe manner with as few "gotchas"
as possible, then being able to "easily trigger an Oops" is something
that we should be avoiding. It's not hard to avoid - we have multiple
mechanisms in the kernel now to deal with it. We have the component
helper. We have devlinks. We can come up with other solutions such
as what I mentioned in my previous reply (which I consider to be the
superior solution in this case - because it doesn't mess up cases
where a single struct device is associated with multiple network
devices (such as on Armada 8040 based systems.)

It's really about "Quality of Implementation" - and I expect high
quality. I don't want my systems crashing because I've tried to
temporarily unbind some device.

> > The second issue that this creates is if a MAC driver creates the PCS
> > and then "gets" it through this interface, then the MAC driver module
> > ends up being locked in until the MAC driver devices are all unbound,
> > which isn't friendly at all.
> 
> The intention here is not to use this for "internal" PCSs, but only for
> external ones. I suppose you're referring to 

I wish I could say that intentions for use bear the test of time, but
sadly I can not.

> > So, anything that proposes to create a new subsystem where we have
> > multiple devices that make up an aggregate device needs to nicely cope
> > with any of those devices going away. For that to happen in this
> > instance, phylink would need to know that its in-use PCS for a
> > particular MAC is going away, then it could force the link down before
> > removing all references to the PCS device.
> > 
> > Another solution would be devlinks, but I am really not a fan of that
> > when there may be a single struct device backing multiple network
> > interfaces, where some of them may require PCS and others do not. One
> > wouldn't want the network interface with nfs-root to suddenly go away
> > because a PCS was unbound from its driver!
> 
> Well, you can also do
> 
> echo "mmc0:0001" > /sys/bus/mmc/drivers/mmcblk/unbind
> 
> which will (depending on your system) have the same effect.
> 
> If being able to unbind any driver at any time is intended,
> then I don't think we can save userspace from itself.

If you unbind the device that contains your rootfs, you are absolutely
correct. It's the same as taking down the network interface that gives
you access to your NFS root.

However, neither of these cause the kernel to crash - they make
userspace unusable.

So, let's say that it is acceptable that the kernel crashes if one
unbinds a device. Why then bother with try_module_get() - if the user
is silly enough to remove the module containing the PCS code, doesn't
the same argument apply? "Shouldn't have done that then."

I don't see the logic.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
