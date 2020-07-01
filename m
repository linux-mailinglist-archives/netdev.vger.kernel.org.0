Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0D54210931
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 12:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729914AbgGAKXo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 06:23:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729781AbgGAKXm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 06:23:42 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D919C061755;
        Wed,  1 Jul 2020 03:23:42 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id j19so4628361pgm.11;
        Wed, 01 Jul 2020 03:23:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XlyOreYcq7l3PbaTN7d7mPxu6E5D6MEe46NhFAGwU6E=;
        b=Hv3t7+iuMbkQLI/nvjRpT8LkUq23BXDfCK9qAIxtbwGDzsm27zbq6qFP8dofmINNVe
         KKEPgdIceIfx7gsmAn9SQi/UUWWKZwo+DjvYnn7/5C/yeLCJ4rDPgPvBJfNwFOHtybxZ
         XShxPE39LUaQ0fRe+ahUp/yn+IsriZJWpvw/9w3gERmxozRAsmpNZ08kwK2xvxaGyxww
         zwmwlgsv5JLPoyBmDm04n5BQajIAgjboGLr/SD63PycmODS6rwb3g/sVbYWCED4Ng9IO
         /x16kmrkmBt1s2drY7QFf1odm1rfgVMyZMWDNHAZHPlKx/MwA773XfFMnXtFDeTAz3xg
         jIHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XlyOreYcq7l3PbaTN7d7mPxu6E5D6MEe46NhFAGwU6E=;
        b=bSsiEBq/FH0eDw1jWgWm3mXIdrt10hlvKSAhbLzX1QHtyL2y0Yz5f2Udn6YaNfOoOn
         yHWw3kSY9Og6lor6oTxTaiFU7dZNW4byIu9aA3Ohv9I6UZ3ZRe+E8aW3a6WYqZ1kvn7W
         L6aZ2ui4zDgFaB5AA15Vlas3NvgR9yRx4ZAIeYxFFUNQatqLNBGN2d4udGfIk6IOqoI3
         J/YIRgoVo/e9i3ph5OvKiifMjgbfB9LKOIPB51emuWNHGgOMChMPDPb6QpRpARH/9/RN
         Sx54NBFSB+y61GMuHlB0z9GPR8oUAvoaioexEwwk7GkEBB+HOcFA8nhFURqUICRm4mpp
         yYNQ==
X-Gm-Message-State: AOAM531KnMLMttqt2QsfmzYWKaGkmTPUAEIrx9CZuCOiwRmxx8zpHjQa
        CuHxS3P/3MuNh8+BCrtj0aqLM1Zg+bIERBYlK3M=
X-Google-Smtp-Source: ABdhPJx0SLfaSW02C8p6MHec9QZP/GgouZWuLhNL6jXiQPupAa6Coi1OYPtqiFf5YIPDoIvWF5rcwi96zputH6jNHgQ=
X-Received: by 2002:a63:a05f:: with SMTP id u31mr13486486pgn.4.1593599021934;
 Wed, 01 Jul 2020 03:23:41 -0700 (PDT)
MIME-Version: 1.0
References: <20200701061233.31120-1-calvin.johnson@oss.nxp.com> <20200701061233.31120-2-calvin.johnson@oss.nxp.com>
In-Reply-To: <20200701061233.31120-2-calvin.johnson@oss.nxp.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Wed, 1 Jul 2020 13:23:28 +0300
Message-ID: <CAHp75VdhuPsx0Kz8=NHxf6KtC0ff9oJWkSMEdNsLeMznEGLnqQ@mail.gmail.com>
Subject: Re: [net-next PATCH v2 1/3] net: phy: introduce find_phy_device()
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>
Cc:     Jeremy Linton <jeremy.linton@arm.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        netdev <netdev@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        linux.cj@gmail.com, "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 1, 2020 at 9:13 AM Calvin Johnson
<calvin.johnson@oss.nxp.com> wrote:
>
> The PHYs on a mdiobus are probed and registered using mdiobus_register().
> Later, for connecting these PHYs to MAC, the PHYs registered on the
> mdiobus have to be referenced.
>
> For each MAC node, a property "mdio-handle" is used to reference the
> MDIO bus on which the PHYs are registered. On getting hold of the MDIO
> bus, use find_phy_device() to get the PHY connected to the MAC.

...

> +       struct platform_device *pdev;

This...

> +       fwnode_mdio = fwnode_find_reference(fwnode, "mdio-handle", 0);
> +       dev = bus_find_device_by_fwnode(&platform_bus_type, fwnode_mdio);

> +       if (IS_ERR_OR_NULL(dev))

IS_ERR()?!

> +               return NULL;

> +       pdev =  to_platform_device(dev);
> +       mdio = platform_get_drvdata(pdev);

...and this can be simple:

mdio = dev_get_drvdata(dev);

> +       err = fwnode_property_read_u32(fwnode, "phy-channel", &addr);
> +       if (err < 0 || addr < 0 || addr >= PHY_MAX_ADDR)
> +               return NULL;

-- 
With Best Regards,
Andy Shevchenko
