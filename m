Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC3A7261C7F
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 21:21:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731193AbgIHTUz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 15:20:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731111AbgIHQBp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 12:01:45 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70190C061755
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 09:01:03 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id y6so16920415oie.5
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 09:01:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=puresoftware-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ERibafgUGmQQjuV0cPeI4iiQoUgm9b3CzSx1l+xtk7Q=;
        b=1sdUXpwPB4k2bAh7Pdll7pQcxl09pPiQ72jlRYy0WhXI2yGse+mjRXn2RooQs7U/i+
         xOQ8KFZ1YhtfqM2J11zgYR7EAAjpTxMFjwpUN1/GcUxGKkbF5LEK5FmbhnurzzC9a7GC
         dbmSWlPgY+JT5ZP8Og1y4XUPax/yBYkAcVr+LVmuU+RbP/rtQbHuj6dp1ySHpI9+ilAm
         7cZ0+sAZhEy4RwMkurl41shJXz5dfErYUYyNBAUHG5FeLvgEoJSin1602uNrvF3v3e7s
         5EMycoaHe2OpFugIX6YyY0/RWBTagITGNs5XpHN0TPIm3iwzxk1wv+/pBT3i4DxIrNYd
         o1Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ERibafgUGmQQjuV0cPeI4iiQoUgm9b3CzSx1l+xtk7Q=;
        b=eGKhmqnbyJhUcfxMxD4LO4E90TRJhsfnXlozf3jkgJ/7gZwdoZ1ifmREmIUi63+hze
         OetLcxoNI1MJxBIsFd1rtcLEa4wFEYaZ+PK3UQ61hlZyu37pEstUdNfEkFfW6YkM7iyA
         VhoobyLRkdSWSqUv5FnUYz69wZxvzZxEkSI4lFQ3Y+duI9Qhf6P80QW6RM+LlD4v2fq/
         PNXohJNHdu5bf5kTb4b57HjgAzUPfHvOkJFa/S+EJxHS/6awk/4y36AicbtQC4yd3Gbw
         G8VQqzIbUHP9Wre7P3btytkH6YY+JJiyT/5LzPaR5DqUrAv3OjEu7F7FB4BLk9U1Q7lD
         +yaw==
X-Gm-Message-State: AOAM532aiWymZAEkAhGEy7UfF5vUaJHx/dOcL3+ofVP6QvpA/cJA94SK
        H8uvTI+HfezC9Um6JoDKmpPkKp1J4H4j5Cr1QzUsO+VDzS4ciQ==
X-Google-Smtp-Source: ABdhPJxtpPANGBZaL9+Oc5EomLz+U9b/FB3qiNqUqrwN7VTRPJ8FHztKQzLM8mAwi/NrMu85VH1nwAb0hmpQy6nk6ZA=
X-Received: by 2002:aca:c6cd:: with SMTP id w196mr3148446oif.7.1599580861319;
 Tue, 08 Sep 2020 09:01:01 -0700 (PDT)
MIME-Version: 1.0
References: <1595938298-13190-1-git-send-email-vikas.singh@puresoftware.com>
 <20200731165455.GD1748118@lunn.ch> <CADvVLtUAd0X7c39BX791CuyWBcmfBsp7Xvw9Jyp05w45agJY9g@mail.gmail.com>
 <20200801093805.GG1551@shell.armlinux.org.uk>
In-Reply-To: <20200801093805.GG1551@shell.armlinux.org.uk>
From:   Vikas Singh <vikas.singh@puresoftware.com>
Date:   Tue, 8 Sep 2020 21:30:35 +0530
Message-ID: <CADvVLtW_1+huUF_giFkOpDSARQyH9CEo+j9ZG5ZYXvKYR+o9Hg@mail.gmail.com>
Subject: Re: [PATCH] net: Phy: Add PHY lookup support on MDIO bus in case of
 ACPI probe
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>, f.fainelli@gmail.com,
        hkallweit1@gmail.com, netdev@vger.kernel.org,
        "Calvin Johnson (OSS)" <calvin.johnson@oss.nxp.com>,
        Kuldip Dwivedi <kuldip.dwivedi@puresoftware.com>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        Vikas Singh <vikas.singh@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 1, 2020 at 3:08 PM Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
>
> On Sat, Aug 01, 2020 at 10:23:38AM +0530, Vikas Singh wrote:
> > Hi Andrew,
> >
> > As i have already mentioned that this patch is based on
> > https://www.spinics.net/lists/netdev/msg662173.html,
> > <https://www.spinics.net/lists/netdev/msg662173.html>
> >
> > When MDIO bus gets registered itself along with devices on it , the
> > function mdiobus_register() inside of_mdiobus_register(), brings
> > up all the PHYs on the mdio bus and attach them to the bus with the help
> > of_mdiobus_link_mdiodev() inside mdiobus_scan() .
> > Additionally it has been discussed with the maintainers that the
> > mdiobus_register() function should be capable of handling both ACPI & DTB
> > stuff
> > without any change to existing implementation.
> > Now of_mdiobus_link_mdiodev() inside mdiobus_scan() see if the auto-probed
> > phy has a corresponding child in the bus node, and set the "of_node"
> > pointer in DT case.
> > But lacks to set the "fwnode" pointer in ACPI case which is resulting in
> > mdiobus_register() failure as an end result theoretically.
> >
> > Now this patch set (changes) will attempt to fill this gap and generalise
> > the mdiobus_register() implementation for both ACPI & DT with no duplicacy
> > or redundancy.
>
> Please do not top-post.
>
> What Andrew is asking is why _should_ a DT specific function (which
> starts with of_, meaning "open firmware") have anything to do with
> ACPI.  The function you refer to (of_mdiobus_link_mdiodev()) is only
> built when CONFIG_OF_MDIO is enabled, which is again, a DT specific
> thing.
>
> So, why should a DT specific function care about ACPI?
>
> We're not asking about the fine details, we're asking about the high
> level idea that DT functions should know about ACPI.
>
> The assignment in of_mdiobus_link_mdiodev() to dev->fwnode is not
> itself about ACPI, it's about enabling drivers that wish to access
> DT properties through the fwnode property APIs can do so.
>
> IMHO, the right way to go about this is to implement it as a non-DT
> function.  Given that it is a static function, Andrew may find it
> acceptable if you also renamed of_mdiobus_link_mdiodev() as
> mdiobus_link_mdiodev() and moved it out of the #ifdef.
>
> +               bus->dev.fwnode = bus->parent->fwnode;
>
> That should be done elsewhere, not here.  of_mdiobus_register() already
> ensures that this is appropriately set, and if it isn't, maybe there's
> a bug elsewhere.
>
> Lastly, note that you don't need two loops, one for ACPI and one for
> DT (it's a shame there isn't a device_for_each_available_child_node()):
>
>         int addr;
>
>         if (dev->fwnode && !bus->dev.fwnode)
>                 return;
>
>         device_for_each_child_node(&bus->dev, fwnode) {
>                 if (!fwnode_device_is_available(fwnode))
>                         continue;
>
>                 if (is_of_node(fwnode))
>                         addr = of_mdio_parse_addr(dev, to_of_node(fwnode));
>                 else if (fwnode_property_read_u32(fwnode, "reg", &addr))
>                         continue;
>
>                 if (addr == mdiodev->addr) {
>                         dev->of_node = to_of_node(fwnode);
>                         dev->fwnode = fwnode;
>                         return;
>                 }
>         }
>
> which, I think, will behave identically to the existing implementation
> when called in a DT setup, but should also add what you want.
>
> So, maybe with the above, moving it out from under the ifdef, and
> renaming it _may_ be acceptable.  This is just a suggestion.
>
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

Hi Russell,

Apologies for the late response, I was stuck with other critical stuff !!

Thank you so much. Agreed. I will do the suggested changes and send a
V2 patch shortly.

Thnx !!
