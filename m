Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B5344961DD
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 16:15:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351250AbiAUPPt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 10:15:49 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:47922 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351244AbiAUPPt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Jan 2022 10:15:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=L37WcsUefj8Jz5AzuxcgPxVzGeBfExcEj5ygi97jhK0=; b=CJPqh6ejMdHcFBW82NcTFBVRbG
        6zyWkx7zY95Z35HkMTUWEgzew8LEswjg4AG1MVIrJmllfpcjEM8bpivQAAkRPP9aDGXZrhqub5Uc/
        vSBbkrXbS1UHMW5zUwhZIg+yzVZxoWTJdEmc9fBDNDcxSRWGsCnbqfwS5j2CZCrlPzA8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nAvdh-0026Fs-5B; Fri, 21 Jan 2022 16:15:45 +0100
Date:   Fri, 21 Jan 2022 16:15:45 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: phy: marvell: Honor phy LED set by system
 firmware on a Dell hardware
Message-ID: <YerOIXi7afbH/3QJ@lunn.ch>
References: <20220120051929.1625791-1-kai.heng.feng@canonical.com>
 <YelxMFOiqnfIVmyy@lunn.ch>
 <CAAd53p7NjvzsBs2aWTP-3GMjoyefMmLB3ou+7fDcrNVfKwALHw@mail.gmail.com>
 <Yeqzhx3GbMzaIbj6@lunn.ch>
 <CAAd53p5pF+SRfwGfJaBTPkH7+9Z6vhPHcuk-c=w8aPTzMBxPcg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAd53p5pF+SRfwGfJaBTPkH7+9Z6vhPHcuk-c=w8aPTzMBxPcg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > They are similar to what DT has, but expressed in an ACPI way. DT has
> > been used with PHY drivers for a long time, but ACPI is new. The ACPI
> > standard also says nothing about PHYs. So Linux has defined its own
> > properties, which we expect all ACPI machine to use. According to the
> > ACPI maintainers, this is within the ACPI standard. Maybe at some
> > point somebody will submit the current definitions to the standards
> > body for approval, or maybe the standard will do something completely
> > different, but for the moment, this is what we have, and what you
> > should use.
> 
> Right, so we can add a new property, document it, and just use it?

Yes. So long as you follow the scheme documented there, cleanly
integrate it into the code as needed, you can add a new property.

> Maybe others will use the new property once we set the precedence?

Yes, which is why i keep saying you need to think of the general case,
not your specific machine.

> How about what Heiner proposed? Maybe we should leave the LED as is,
> and restore it on system resume?

I don't think we can change the current code because it will cause
regressions. The LEDs probably work on some boards because of the
current code.

At some point in the future, we hope to be able to control the PHY
LEDs via /sys/class/LEDs. But until then, telling the PHY driver to
not touch the LED configuration seems a reasonable request.

    Andrew
