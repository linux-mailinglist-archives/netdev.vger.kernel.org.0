Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82D9D3FFD10
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 11:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348782AbhICJ2b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 05:28:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232257AbhICJ2a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 05:28:30 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACF44C061575;
        Fri,  3 Sep 2021 02:27:30 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id e21so10757272ejz.12;
        Fri, 03 Sep 2021 02:27:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=98U6tP9GpBzT341VTGl00bgihnu7GKQ3T3inht08g64=;
        b=Gfms5tJb+S1JUnUcWuX8H59hWdYjbsq2N5xdq3+ApSAOrVu7Q2zTuKXSIPvoIYgSab
         zlAkNhaG5uK+rs8udVlW7Bqw9kSho+w5FgFmZOvZf948Gsu6VA8C+eZggEftfKWCJDoa
         Cs/GcGfsjuWiZO/+6P03B1lREgVKg7Yi/scawqKD2I35f4ZVLyP7KqfY0cLZV7HdRJFh
         ZzIRDl6n0gpJZYZRzvs126u6gLuF03q3vsHDWgRqlhXHxstwQHyJ3zOB12a6YlmPkAG4
         gDmfq05jP3VdBcDEJCdmaJn1+r7ClczyoohBoEIbkwCbS2nJ8JnMfV7TPgHtZwA+i7VV
         NF3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=98U6tP9GpBzT341VTGl00bgihnu7GKQ3T3inht08g64=;
        b=APaGCFkgv6pLofvHrts0IqrvY7jeEKXXB0Y9aa/+DEVbEdv7fiT4TlZ6lxfQM2vWZa
         CQ06GDsDAt9+gw30TilOhDSYXNd4AsE8eCsx/a4FJ+z/QRagpvdpRZ6UW6xalEm7F8S4
         itbTq/ulIT3zykCexacak5NrI7EPeXEiFZk502h0jXr5JQ8LQmgQdUBhQ8hi46mrL80H
         NI4P9sl++D5/GfwFBT6W+eeaU0c9jXc1syz7aUH2FrkrkTIjXatAEfK/crYldEmIeNLd
         uOwB5XDXX+znqddHoUqfaIS/8XAWPUoZo8KxCnGWXMSmbeKt6gcU/JruKb075WWOOT+b
         Gyzg==
X-Gm-Message-State: AOAM531HnIKG6zmkf8oEL9FdhO9VkCVGsFz0BjcI2BxJN5FUh4fk15/e
        y0ErxmLRjSxoaySrSzvZilo=
X-Google-Smtp-Source: ABdhPJz6Z+i1MKPF6nnWiX8wxORP4DxEP8XjnsoXDEfh8mtSUmLdxrS8BBfa22C7mVpq2PK+FxWFAw==
X-Received: by 2002:a17:906:802:: with SMTP id e2mr3126470ejd.133.1630661249140;
        Fri, 03 Sep 2021 02:27:29 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id b5sm2382684ejq.56.2021.09.03.02.27.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Sep 2021 02:27:28 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
X-Google-Original-From: Ioana Ciornei <ciornei.ioana@gmail.com>
Date:   Fri, 3 Sep 2021 12:27:27 +0300
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        kernel-team <kernel-team@android.com>,
        Len Brown <lenb@kernel.org>
Subject: Re: [RFC PATCH net-next 1/3] net: phy: don't bind genphy in
 phy_attach_direct if the specific driver defers probe
Message-ID: <20210903092727.ae44m5rk3qdhyq6x@skbuf>
References: <20210901225053.1205571-1-vladimir.oltean@nxp.com>
 <20210901225053.1205571-2-vladimir.oltean@nxp.com>
 <20210902185016.GL22278@shell.armlinux.org.uk>
 <YTErTRBnRYJpWDnH@lunn.ch>
 <bd7c9398-5d3d-ccd8-8804-25074cff6bde@gmail.com>
 <20210902213303.GO22278@shell.armlinux.org.uk>
 <20210902213949.r3q5764wykqgjm4z@skbuf>
 <20210902222439.GQ22278@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210902222439.GQ22278@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 02, 2021 at 11:24:39PM +0100, Russell King (Oracle) wrote:
> On Fri, Sep 03, 2021 at 12:39:49AM +0300, Vladimir Oltean wrote:
> > On Thu, Sep 02, 2021 at 10:33:03PM +0100, Russell King (Oracle) wrote:
> > > That's probably an unreliable indicator. DPAA2 has weirdness in the
> > > way it can dynamically create and destroy network interfaces, which
> > > does lead to problems with the rtnl lock. I've been carrying a patch
> > > from NXP for this for almost two years now, which NXP still haven't
> > > submitted:
> > > 
> > > http://git.armlinux.org.uk/cgit/linux-arm.git/commit/?h=cex7&id=a600f2ee50223e9bcdcf86b65b4c427c0fd425a4
> > > 
> > > ... and I've no idea why that patch never made mainline. I need it
> > > to avoid the stated deadlock on SolidRun Honeycomb platforms when
> > > creating additional network interfaces for the SFP cages in userspace.
> > 
> > Ah, nice, I've copied that broken logic for the dpaa2-switch too:
> > https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=d52ef12f7d6c016f3b249db95af33f725e3dd065
> > 
> > So why don't you send the patch? I can send it too if you want to, one
> > for the switch and one for the DPNI driver.
> 
> Sorry, I mis-stated. NXP did submit that exact patch, but it's actually
> incorrect for the reason I stated when it was sent:
> 
> https://patchwork.ozlabs.org/project/netdev/patch/1574363727-5437-2-git-send-email-ioana.ciornei@nxp.com/
> 
> I did miss the rtnl_lock() around phylink_disconnect_phy() in the
> description of the race, which goes someway towards hiding it, but
> there is still a race between phylink_destroy() and another thread
> calling dpaa2_eth_get_link_ksettings(), and priv->mac being freed:
> 
> static int
> dpaa2_eth_get_link_ksettings(struct net_device *net_dev,
>                              struct ethtool_link_ksettings *link_settings)
> {
>         struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
> 
>         if (dpaa2_eth_is_type_phy(priv))
>                 return phylink_ethtool_ksettings_get(priv->mac->phylink,
>                                                      link_settings);
> 
> which dereferences priv->mac and priv->mac->phylink, vs:
> 
> static irqreturn_t dpni_irq0_handler_thread(int irq_num, void *arg)
> {
> ...
>         if (status & DPNI_IRQ_EVENT_ENDPOINT_CHANGED) {
>                 dpaa2_eth_set_mac_addr(netdev_priv(net_dev));
>                 dpaa2_eth_update_tx_fqids(priv);
> 
>                 if (dpaa2_eth_has_mac(priv))
>                         dpaa2_eth_disconnect_mac(priv);
>                 else
>                         dpaa2_eth_connect_mac(priv);
>         }
> 
> static void dpaa2_eth_disconnect_mac(struct dpaa2_eth_priv *priv)
> {
>         if (dpaa2_eth_is_type_phy(priv))
>                 dpaa2_mac_disconnect(priv->mac);
> 
>         if (!dpaa2_eth_has_mac(priv))
>                 return;
> 
>         dpaa2_mac_close(priv->mac);
>         kfree(priv->mac);		<== potential use after free bug by
>         priv->mac = NULL;		<== dpaa2_eth_get_link_ksettings()
> }
> 
> void dpaa2_mac_disconnect(struct dpaa2_mac *mac)
> {
>         if (!mac->phylink)
>                 return;
> 
>         phylink_disconnect_phy(mac->phylink);
>         phylink_destroy(mac->phylink);	<== another use-after-free bug via
> 					    dpaa2_eth_get_link_ksettings()
>         dpaa2_pcs_destroy(mac);
> }
> 
> Note that phylink_destroy() is documented as:
> 
>  * Note: the rtnl lock must not be held when calling this function.
> 
> because it calls sfp_bus_del_upstream(), which will take the rtnl lock
> itself. An alternative solution would be to remove the rtnl locking
> from sfp_bus_del_upstream(), but then force _everyone_ to take the
> rtnl lock before calling phylink_destroy() - meaning a larger block of
> code ends up executing under the lock than is really necessary.
> 
> However, as I stated in my review of the patch "As I've already stated,
> the phylink is not designed to be created and destroyed on a published
> network device." That still remains true today, and it seems that the
> issue has never been fixed in DPAA2 despite having been pointed out.
> 

My attempt to fix this issue was that patch that you just pointed at.
Taking your feedback into account (that phylink is not designed to be
created and destroyed on a published networking device) I really do not
know what other viable solution to send out.

The alternative here would have been to just have a different driver for
the MAC side (probing on dpmac objects) that creates the phylink
instance at probe time and then is just used by the dpaa2-eth driver
when it connects to a dpmac. This way no phylink is created/destroyed
dynamically.

This was the architecture of my initial attempt at supporting phylink in
DPAA2.
https://patchwork.ozlabs.org/project/netdev/patch/1560470153-26155-5-git-send-email-ioana.ciornei@nxp.com/

If you have any suggestion on how I should go about fixing this, please
let me know.

Ioana

