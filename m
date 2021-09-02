Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C33543FEDD8
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 14:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344474AbhIBMge (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 08:36:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234098AbhIBMgd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 08:36:33 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42AB0C061575;
        Thu,  2 Sep 2021 05:35:35 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id t19so3968100ejr.8;
        Thu, 02 Sep 2021 05:35:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JDtXEunmFOOZmW+0aOsXK0Lm5ZI2ij8ux95FUu34ZJM=;
        b=PqW1GirCBDvwbp/Ga2Ddg6i2pz1R5Yc9bMNfbDavKrmCfQny7D35f6ATVhel0WDeZg
         pdPAAj9emto4iW43J3Ubj4AgOofDMzzbB3ELwMgrkPLddqEWEk313MlGf7jU8ZYCx+H/
         B2y/W9fH6P4sBYx999uv6Xzrhn/MdWEGU8uk7v6I3sh+qBjXZzQFhPrPpr4D0LH8TsDQ
         bHBjKDfCyy7Hg8mmWicLishULAZqrqAo35qGy94l+FdaQFnA0lG6/wezJ+J7lRlg+QeF
         hxk5MMvbdR3PhWhf2fXJVE8UAY4l+BYEBisEjRt2v1qjCqkB+aEXuwWLpGZemTRknIS/
         DOoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JDtXEunmFOOZmW+0aOsXK0Lm5ZI2ij8ux95FUu34ZJM=;
        b=Pp8bZagVLXMzD92Ohir6cyD7cZwaOFizMIyXSetm48RYWYfaJPYjt7ZQAXf7VPyGKW
         8ctbCBYmvbqermr7eVkEWseZChI2lwDjMhv0f6qua3b32JnwnhtrbSpiWAZGOxN4mQR8
         HkE5+jZ/JadfdwmKEzIDuN748iVyybiIsbGGCSp8IIQhxq1med5JDqsFNPmXd0aZ+gSQ
         Ke9iXOiBCETL1Vp49FRgUdbI1aPRMyp2ERZ6ME0uyVWnE7snX058QGAriEtIGlQ/1+6N
         f6EwuQLpUytVhR+bYAR5es0qt+qdUwBI5WAQe6iVGQtRHnE5qj+GxScvBO0UuvpmWVLU
         2mfQ==
X-Gm-Message-State: AOAM532Zv6lUMA8y4dCNrcxZ/WHI2zl+h2nmnWAs8gW5nBD1bEhT38NB
        8M4yNhy0MM5UWL/p8oZlokE=
X-Google-Smtp-Source: ABdhPJxayQYena70A4LcBxGfe1LMU/MXJPCCZZbBKEyyCDlZ9DlVxh2w74gWxfqOAOJz/MpIS615lw==
X-Received: by 2002:a17:907:7601:: with SMTP id jx1mr3548149ejc.69.1630586133751;
        Thu, 02 Sep 2021 05:35:33 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id n23sm1150940eds.41.2021.09.02.05.35.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 05:35:33 -0700 (PDT)
Date:   Thu, 2 Sep 2021 15:35:32 +0300
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
Message-ID: <20210902123532.ruvuecxoig67yv5v@skbuf>
References: <20210901225053.1205571-1-vladimir.oltean@nxp.com>
 <20210902121927.GE22278@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210902121927.GE22278@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 02, 2021 at 01:19:27PM +0100, Russell King (Oracle) wrote:
> On Thu, Sep 02, 2021 at 01:50:50AM +0300, Vladimir Oltean wrote:
> > The central point of that discussion is that DSA seems "broken" for
> > expecting the PHY driver to probe immediately on PHYs belonging to the
> > internal MDIO buses of switches. A few suggestions were made about what
> > to do, but some were not satisfactory and some did not solve the problem.
> 
> I think you need to describe the mechanism here. Why wouldn't a PHY
> belonging to an internal MDIO bus of a switch not probe immediately?
> What resources may not be available?

As you point out below, the interrupt-controller is what is not available.
There is a mechanism called fw_devlink which infers links from one OF
node to another based on phandles. When you have an interrupt-parent,
that OF node becomes a supplier to you. Those OF node links are then
transferred to device links once the devices having those OF nodes are
created.

> If we have a DSA driver that tries to probe the PHYs before e.g. the
> interrupt controller inside the DSA switch has been configured, aren't
> we just making completely unnecessary problems for ourselves?

This is not what happens, if that were the case, of course I would fix
_that_ and not in this way.

> Wouldn't it be saner to ensure that the interrupt controller has been
> setup and become available prior to attempting to setup anything that
> relies upon that interrupt controller?

The interrupt controller _has_ been set up. The trouble is that the
interrupt controller has the same OF node as the switch itself, and the
same OF node. Therefore, fw_devlink waits for the _entire_ switch to
finish probing, it doesn't have insight into the fact that the
dependency is just on the interrupt controller.

> From what I see of Marvell switches, the internal PHYs only ever rely
> on internal resources of the switch they are embedded in.
> 
> External PHYs to the switch are a different matter - these can rely on
> external clocks, and in that scenario, it would make sense for a
> deferred probe to cause the entire switch to defer, since we don't
> have all the resources for the switch to be functional (and, because we
> want the PHYs to be present at switch probe time, not when we try to
> bring up the interface, I don't see there's much other choice.)
> 
> Trying to move that to interface-up time /will/ break userspace - for
> example, Debian's interfaces(8) bridge support will become unreliable,
> and probably a whole host of other userspace. It will cause regressions
> and instability to userspace. So that's a big no.

Why a big no? I expect there to be 2 call paths of phy_attach_direct:
- At probe time. Both the MAC driver and the PHY driver are probing.
  This is what has this patch addresses. There is no issue to return
  -EPROBE_DEFER at that time, since drivers connect to the PHY before
  they register their netdev. So if connecting defers, there is no
  netdev to unregister, and user space knows nothing of this.
- At .ndo_open time. This is where it maybe gets interesting, but not to
  user space. If you open a netdev and it connects to the PHY then, I
  wouldn't expect the PHY to be undergoing a probing process, all of
  that should have been settled by then, should it not? Where it might
  get interesting is with NFS root, and I admit I haven't tested that.
