Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8CF63FF75C
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 00:45:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348325AbhIBWqK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 18:46:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348316AbhIBWqJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 18:46:09 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C973BC061575;
        Thu,  2 Sep 2021 15:45:09 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id jg16so4836421ejc.1;
        Thu, 02 Sep 2021 15:45:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Mab6iFx7vPOJLixcce4Re9IRPB+O1/BszQb8EGuGv5Q=;
        b=nm2nhRsIKC1rVdjUva/HDsuqJdhBJYEKAH1qiwk/yBAaUNao8JHSCBex3k6s5wY6Op
         Rwzo4FBVq8CjiQRA52zW1Nr4FDPr5/6JywFoNhWNI9lq786lF7r/QLMTTeF1D3B7m3Ky
         POcEPDgxEU+qXpPEVonbdg6Ajcv3WtxKL0D2uauEdEMFyefnI34xuAh/RZh5R4OYLaFv
         kjoJmZFSwfmaT01Nf+w9fs3bTexXyyqJATO9K0DSBj73J8KlnzQFIv4Ykwy/+/2xIs+Z
         SG66Zbj2NKIGKzhi4hIlj0spElfubmTbpiRB7zstdjYIvO+IVlFSBtkbLyzR2EQW38IX
         LHrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Mab6iFx7vPOJLixcce4Re9IRPB+O1/BszQb8EGuGv5Q=;
        b=jsveyKWAQeCAIG8t/1hYZhhCONP0gI1wz7cSqepT32bjqhAPfraiq3gYXrXLAjtVcC
         pyuSfws562z5S2J3oRAKKlJqs9yjdfkY4nLiXvjIJ+DjaDouEVMu1zVg8hguTKRmIIYL
         fX9yCDVUS3zQKt1zhlJYig31qlioVIEn7uDhczOAH9KLdWBPyCIpVWjgyR7j1Tgwnlky
         RrYt4bfEN7XKgBitqKC0iWQpcm/TI1zC4jKgEi5GionkuJj5NZlD+NKu4MS9rrET5FJR
         Uux7FzH2rrlFofRnFGd0joBOSmxJHFxmdwfIC3o+p0+CttEBcq2+e/2ErOmyAr6f+KZT
         0jEA==
X-Gm-Message-State: AOAM532K7vP0njOTh7ImIDky+zy5CuehY4u6uRRL1ExfAg0HSd+0iifU
        RmmDStFwPPz/Memt9kXHZ8Q=
X-Google-Smtp-Source: ABdhPJwzFaYzgiq1IeUcUksMRdLc+C517sdgU7OZCHejrQzGI+3lj8uCKMAMaXdwsFkwWlYA3S/pmw==
X-Received: by 2002:a17:906:3809:: with SMTP id v9mr541465ejc.355.1630622708394;
        Thu, 02 Sep 2021 15:45:08 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id i18sm1742296ejg.100.2021.09.02.15.45.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 15:45:07 -0700 (PDT)
Date:   Fri, 3 Sep 2021 01:45:06 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
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
Message-ID: <20210902224506.5h7bnybjbljs5uxz@skbuf>
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

So why are you carrying it then?

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

Okay, so this needs to stay under the rtnetlink mutex, to serialize with
dpaa2_eth_get_link_ksettings which is already under the rtnetlink mutex.
So the way in which rtnl_lock is taken right now is actually fine in a way.

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

So phylink_destroy has exactly 20 call sites, it is not that bad?

And as for "larger block than necessary" - doesn't the dpaa2 prolonged
usage count as necessary?

> However, as I stated in my review of the patch "As I've already stated,
> the phylink is not designed to be created and destroyed on a published
> network device." That still remains true today, and it seems that the
> issue has never been fixed in DPAA2 despite having been pointed out.

So what would you do, exactly, to "fix" the issue that a DPNI can
connect and disconnect at runtime from a DPMAC?

Also, "X is not designed to Y" doesn't really say much, given a bit of
will power. Linux was not designed to run on non-i386 either.

Any other issues besides needing to take rtnl_mutex top-level when
calling phylink_destroy? Since phylink_disconnect_phy needs it anyway,
and phylink_destroy ends up calling sfp_bus_del_upstream which takes the
same mutex again, and drivers that connect/disconnect at probe/remove
time end up calling both in a row, I don't think there is much of an
issue to speak of, or that the rework would be that difficult.
