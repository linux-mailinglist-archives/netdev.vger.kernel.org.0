Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B326B3FEE36
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 14:59:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344810AbhIBNA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 09:00:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234247AbhIBNAZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 09:00:25 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE6C2C061575;
        Thu,  2 Sep 2021 05:59:26 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id a25so4149735ejv.6;
        Thu, 02 Sep 2021 05:59:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vaGzIm5LsmBsaKouZzrmYUthPEgqDvMKDaRZQ7yEMO4=;
        b=i9GHpXvLiZcopIrVEMMb6V3w5gInseFZpl/2spgZ2hqPhy7dLzowfGqBKXvzK1VsZ2
         mloUwMvKQm7pnyWev0jOH7NgreEliw9+8cagJptnFASWj1jJUCVL1/qzO1rDwMKpyU61
         EDkt8BasV8WFI8VDRuwEX4XT+uwmI0L2xSoV+kO0uRLXHnvCzOOXzvHq99pSTwULKZ01
         6CZk0sYYiMcFrmnd0mDPnMb5KK5G+uY5+/3xcW2bLQLeS4meEEBvNKUzOi3/joTOgiwk
         2ZXUVgcztcc7HmjMHsyAtlGwiXembwPAMuxXEZuWLutOC5hqInnP0bcDJqDouYdhBnaH
         GINg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vaGzIm5LsmBsaKouZzrmYUthPEgqDvMKDaRZQ7yEMO4=;
        b=YRtM/9mmjcCii/MtKTZcvwbO30chpAFUF3ePZNT+u6OBQ5yOVF4CWfc1ZNAYetsulo
         +YXfcFr7cksMHITUnA5Q18abZuTykojgAcsKE1ENc+Ke0UOdmySj/zHz7a5CnRBW3rbn
         Il1OOE4dWymyRJOKEkYgRy8WfgZBpw6K5rqeW7ZA2yjB074Dyqrm5PkItc6xMWPOmzVC
         Orz4dc/rUYq3FqmhCzH9I+ecNXlzamdSZRXS4BvXKMAfWAUHs7n0wzXpDiX5dZFG5GZQ
         /oxxCEgEldih+Cl06PwiQVGLTe3ykLx8mIJozNe/e2npBX+ZcE/rl90iQ8tNZ92ZtreI
         Wg/Q==
X-Gm-Message-State: AOAM532/WW4lo40n5XFQoIVuf2RVSjwkVtIz5gejH/ZRFzZ2EYwW/Dil
        gjm4RaLdyCQNzemltcvrJAs=
X-Google-Smtp-Source: ABdhPJxM/T+zJF6YHAwRyfCS/+2BquIGUhci/K8jHTpCgFJDBp07tvm67krYUYmNh6gtUIwskeazrg==
X-Received: by 2002:a17:906:1d19:: with SMTP id n25mr3673483ejh.11.1630587565279;
        Thu, 02 Sep 2021 05:59:25 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id c25sm1079599ejm.9.2021.09.02.05.59.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 05:59:24 -0700 (PDT)
Date:   Thu, 2 Sep 2021 15:59:23 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        kernel-team <kernel-team@android.com>,
        Len Brown <lenb@kernel.org>
Subject: Re: [RFC PATCH net-next 0/3] Make the PHY library stop being so
 greedy when binding the generic PHY driver
Message-ID: <20210902125923.v7fq26iiqydtgq7g@skbuf>
References: <20210901225053.1205571-1-vladimir.oltean@nxp.com>
 <20210902121927.GE22278@shell.armlinux.org.uk>
 <20210902123532.ruvuecxoig67yv5v@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210902123532.ruvuecxoig67yv5v@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 02, 2021 at 03:35:32PM +0300, Vladimir Oltean wrote:
> On Thu, Sep 02, 2021 at 01:19:27PM +0100, Russell King (Oracle) wrote:
> > On Thu, Sep 02, 2021 at 01:50:50AM +0300, Vladimir Oltean wrote:
> > > The central point of that discussion is that DSA seems "broken" for
> > > expecting the PHY driver to probe immediately on PHYs belonging to the
> > > internal MDIO buses of switches. A few suggestions were made about what
> > > to do, but some were not satisfactory and some did not solve the problem.
> > 
> > I think you need to describe the mechanism here. Why wouldn't a PHY
> > belonging to an internal MDIO bus of a switch not probe immediately?
> > What resources may not be available?
> 
> As you point out below, the interrupt-controller is what is not available.
> There is a mechanism called fw_devlink which infers links from one OF
> node to another based on phandles. When you have an interrupt-parent,
> that OF node becomes a supplier to you. Those OF node links are then
> transferred to device links once the devices having those OF nodes are
> created.
> 
> > If we have a DSA driver that tries to probe the PHYs before e.g. the
> > interrupt controller inside the DSA switch has been configured, aren't
> > we just making completely unnecessary problems for ourselves?
> 
> This is not what happens, if that were the case, of course I would fix
> _that_ and not in this way.
> 
> > Wouldn't it be saner to ensure that the interrupt controller has been
> > setup and become available prior to attempting to setup anything that
> > relies upon that interrupt controller?
> 
> The interrupt controller _has_ been set up. The trouble is that the
> interrupt controller has the same OF node as the switch itself, and the
> same OF node. Therefore, fw_devlink waits for the _entire_ switch to

...and the same struct device, not "OF node" repeated twice, silly me.

> finish probing, it doesn't have insight into the fact that the
> dependency is just on the interrupt controller.
> 
> > From what I see of Marvell switches, the internal PHYs only ever rely
> > on internal resources of the switch they are embedded in.
> > 
> > External PHYs to the switch are a different matter - these can rely on
> > external clocks, and in that scenario, it would make sense for a
> > deferred probe to cause the entire switch to defer, since we don't
> > have all the resources for the switch to be functional (and, because we
> > want the PHYs to be present at switch probe time, not when we try to
> > bring up the interface, I don't see there's much other choice.)
> > 
> > Trying to move that to interface-up time /will/ break userspace - for
> > example, Debian's interfaces(8) bridge support will become unreliable,
> > and probably a whole host of other userspace. It will cause regressions
> > and instability to userspace. So that's a big no.
> 
> Why a big no? I expect there to be 2 call paths of phy_attach_direct:
> - At probe time. Both the MAC driver and the PHY driver are probing.
>   This is what has this patch addresses. There is no issue to return
>   -EPROBE_DEFER at that time, since drivers connect to the PHY before
>   they register their netdev. So if connecting defers, there is no
>   netdev to unregister, and user space knows nothing of this.
> - At .ndo_open time. This is where it maybe gets interesting, but not to
>   user space. If you open a netdev and it connects to the PHY then, I
>   wouldn't expect the PHY to be undergoing a probing process, all of
>   that should have been settled by then, should it not? Where it might
>   get interesting is with NFS root, and I admit I haven't tested that.
