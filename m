Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A69E83A9891
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 13:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232241AbhFPLEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 07:04:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230436AbhFPLDZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 07:03:25 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C8CFC0617AE
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 04:01:19 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id s6so2073673edu.10
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 04:01:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PUBBubKwxYjik5SgXaW62cBqx3UIch1oK3sRuO467z0=;
        b=HQlAr1E+yl7QT3u4fc5yULKrONVjbwldwHSNYltgyCu6p2WbHwZu6Hj783VwQK/cdY
         OVemN/C4diQIXT+SWUbAkkAqepsh2Wf/RTXO2R3BaAwpDYoHLDBJEcsHJx1ErpUidgfG
         BesuBPWeGfBnKLKBKQ5JuZR48W2FCu9NvAMNAduosk/sXP+auuifQ0RDPfQTB5sxbMrP
         zHYJthi9hd+kdYNJuy9Vl5Dra0lVxJ0EO/nkFUqGtHNIs7QRsPJsVl/C7zW+rPy57Bjk
         0EruQRp3HT/8dHUPz1WqIDls/z6uAmHMZvQscvfa5d8w4CHcs7/ObxA/XS+OC93085hW
         SalQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PUBBubKwxYjik5SgXaW62cBqx3UIch1oK3sRuO467z0=;
        b=CTbC03X04UH2IGT2fl7o0h+PoFqSR/++37Y5kTCyz8S39eHDUARNXih0V0titmcPYc
         QzFCEJjBWm5dZ6reJ1d8QRwX4blKIF8GuhSqIU6FMReG0dyvK55hJ+9CMdD4FYj2BEaO
         /EHd7bM30KN8TCgMUW2Y+MJTmqEkSTANEch09e7efVW0tNvxSWNjLRup2h8RGrZJji+s
         tGjX2pxyGHGqyRUARVTnQzM6D5pX6pYiMPn9WEY0DBe1rBtfxjbI6GOucha/PY0k5jDx
         Ds1KSEQ3Vtw6KWG7Fxn70rIFLKOp0F8igKWpgakYRTBb2/tjdHBcPVBrJsvgaEK7zXyx
         2OXg==
X-Gm-Message-State: AOAM5300+Bis/WTsw/Bb8DmhFo5qEzt5QXDKpwkTVZ5oVDiAKqHlklaQ
        BDkCH+bHD+N24keP/cba04T4KbA6dGg=
X-Google-Smtp-Source: ABdhPJwlnj4UaN4CoKdEBpgj9uS0h8rspgYdLcfv/Ak9IxfjAWvx88pLnUv1TuZrv91Qff4m5isfLA==
X-Received: by 2002:a05:6402:1111:: with SMTP id u17mr3414926edv.87.1623841277555;
        Wed, 16 Jun 2021 04:01:17 -0700 (PDT)
Received: from skbuf ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id gz5sm1357095ejb.113.2021.06.16.04.01.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jun 2021 04:01:17 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
X-Google-Original-From: Ioana Ciornei <ciornei.ioana@gmail.com>
Date:   Wed, 16 Jun 2021 14:01:15 +0300
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Ioana Ciornei <ciorneiioana@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        calvin.johnson@oss.nxp.com, hkallweit1@gmail.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: [PATCH net-next] mdio: mdiobus: setup of_node for the MDIO device
Message-ID: <20210616110115.i3zykpc73qxu5odk@skbuf>
References: <20210615154401.1274322-1-ciorneiioana@gmail.com>
 <20210615171330.GW22278@shell.armlinux.org.uk>
 <YMjx6iBD88+xdODZ@lunn.ch>
 <20210615210907.GY22278@shell.armlinux.org.uk>
 <20210615212153.fvfenkyqabyqp7dk@skbuf>
 <YMkcQ6F2FXWvpeKu@lunn.ch>
 <20210616082052.s56l54vycxilv5is@skbuf>
 <20210616094012.GA22278@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210616094012.GA22278@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 16, 2021 at 10:40:12AM +0100, Russell King (Oracle) wrote:
> On Wed, Jun 16, 2021 at 11:20:52AM +0300, Ioana Ciornei wrote:
> > On Tue, Jun 15, 2021 at 11:31:47PM +0200, Andrew Lunn wrote:
> > > > The fwnode_operations declared in drivers/acpi/property.c also suggest
> > > > the ACPI fwnodes are not refcounted.
> > > 
> > > Is this because ACPI is not dynamic, unlike DT, where you can
> > > add/remove overlays at runtime?
> > > 
> > 
> > I am really not an expert here but the git history suggests so, yes.
> > 
> > Without the CONFIG_OF_DYNAMIC enabled, the fwnode_handle_get() call is
> > actually a no-op even in the OF case.
> 
> More accurately, of_node_get() is a no-op if CONFIG_OF_DYNAMIC is
> disabled, which in turn makes fwnode_handle_get() also a no-op.
> 
> I'm wondering whether we would need two helpers to assign these, or
> just a single helper that takes a fwnode and assigns both pointers.
> to_of_node() returns NULL if the fwnode is not a DT node, so would
> be safe to use even with ACPI.
> 

Yes, I think this approach was exactly what Andrew suggested initially.

> Then there's the cleanup side when the device is released. I haven't
> yet found where we release the reference to the fwnode/of_node when
> we release the phy_device. I would have expected it in
> phy_device_release() but that does nothing.

Looking at the fixed_phy.c use of the refcounts, I would expect that a
call to fwnode_handle_put/of_node_put should be right after a
phy_device_remove() call is made.

	void fixed_phy_unregister(struct phy_device *phy)
	{
		phy_device_remove(phy);
		of_node_put(phy->mdio.dev.of_node);
		fixed_phy_del(phy->mdio.addr);
	}


Now going back to the phy_device.c, the phy_device_remove() call is done
in phy_mdio_device_remove. This is the device_remove callback of any PHY
MDIO device, called when, for example, the MDIO bus is unregistered.

After a first pass through the code, I would expect the refcount to be
released in phy_mdio_device_remove().

> We could only add that
> when we are certain that all users who assign the firmware node to
> the phy device has properly refcounted it in the DT case.
> 

Agree. I think we need a proper mapping of the register/unregister code
paths before any of_node/fwnode_handle put is added.

Ioana
