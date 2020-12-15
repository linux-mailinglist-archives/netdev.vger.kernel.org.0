Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65BD42DB290
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 18:29:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729872AbgLOR2K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 12:28:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726431AbgLOR2C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 12:28:02 -0500
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 736BEC06179C;
        Tue, 15 Dec 2020 09:27:22 -0800 (PST)
Received: by mail-pj1-x1043.google.com with SMTP id lj6so1613629pjb.0;
        Tue, 15 Dec 2020 09:27:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YLQe1sM4Ge2CHlLzOz2p/trhD+G58BxTmNBt25LRZ8A=;
        b=mtRXacPgffa47mMHg0mb+jE2Uic1s/vh3S7sCBxhHYjvzthmVLzIhwhGpfUGV8suE/
         ZaaYyacg7kpzmnlJoPPBkhXEOr4rxWuWZi9VhRYODw5JLp6LKb4rzi9AH6D23jG7wB7y
         iJHSSQ/bc+Ub7HIbwibushpozgI25EwzwGOYpEXNi0+Uux/Cz7F2ownzUE6Yqygbg/3r
         N2Ei0jsQOvWH8mwF3Sj/1OGcFltg2PkPFsPZqNBUKrJy2zM/kc1giBz4cnnHrLEYL5Dn
         qpo2qAZqzNZxWJK6JavzI4QkjrnyhwK3AHbgjuVs5VX1/g4sDRRPcIOhF30E7IPup6IY
         W8lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YLQe1sM4Ge2CHlLzOz2p/trhD+G58BxTmNBt25LRZ8A=;
        b=IUaJ/yiRiZU8dlBmmBHB3LY52Xq+73SPQoBMXnSwfo6+QQVnCHIYB46v3nUTAlHVDV
         2PpUIw+vD34tPNYbM67TE/NmgpgpvJxucw3jDtHAF6G34IiWKisC5Ue47PDPZilk03vb
         EGTOLYAQoYJTL0f3WUd8AiO+wKDY1ZARy6MxjnkqaEUa5wal+IzLRgQsXzxITaeFCf4P
         uJaoYrr8VecO8D3uyrj1CHl9uHkILUZ7YtL+GW3Z6pwhzm96Dhn12rh0BoacXm/Ir5Kc
         epWkp/h99M+0pU9t2iabij994aQAHSFrtMOhyYwcXHdl5LWw5JcVrI+dmYTyYBqrgPJD
         thNQ==
X-Gm-Message-State: AOAM5333pbtRq99mXuuK3U2Ki1pQfhoqO+0ta9CmIg2tXKsErVIkzMu9
        KOhOWaOX2d5jDDRlBGZDZ/xP0ISRz6dl6fBBTvI=
X-Google-Smtp-Source: ABdhPJyD+yx+eQaFiZVDFvolPHHBDMQn/csck7cKFaQIPdyK4pVw193xnlm+vbAxPWLqoWx3okwRpAgzBq0zXmYooFg=
X-Received: by 2002:a17:90a:c592:: with SMTP id l18mr31159805pjt.228.1608053241871;
 Tue, 15 Dec 2020 09:27:21 -0800 (PST)
MIME-Version: 1.0
References: <20201215164315.3666-1-calvin.johnson@oss.nxp.com> <20201215164315.3666-5-calvin.johnson@oss.nxp.com>
In-Reply-To: <20201215164315.3666-5-calvin.johnson@oss.nxp.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Tue, 15 Dec 2020 19:28:10 +0200
Message-ID: <CAHp75VcHrBtAY3KDugBYEo9=YuDwbh+QLdOU8yiKb2VyaU2x9A@mail.gmail.com>
Subject: Re: [net-next PATCH v2 04/14] net: phy: Introduce fwnode_get_phy_id()
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>
Cc:     Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Jon <jon@solid-run.com>, "linux.cj" <linux.cj@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 15, 2020 at 6:44 PM Calvin Johnson
<calvin.johnson@oss.nxp.com> wrote:
>
> Extract phy_id from compatible string. This will be used by
> fwnode_mdiobus_register_phy() to create phy device using the
> phy_id.

...

> +       if (sscanf(cp, "ethernet-phy-id%4x.%4x", &upper, &lower) == 2) {
> +               *phy_id = ((upper & 0xFFFF) << 16) | (lower & 0xFFFF);
> +               return 0;
> +       }
> +       return -EINVAL;

Perhaps traditional pattern, i.e.
       if (sscanf(cp, "ethernet-phy-id%4x.%4x", &upper, &lower) != 2)
               return -EINVAL;

       *phy_id = ((upper & 0xFFFF) << 16) | (lower & 0xFFFF);
       return 0;

And perhaps GENMASK() ?

-- 
With Best Regards,
Andy Shevchenko
