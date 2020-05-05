Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F87F1C5858
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 16:13:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729313AbgEEONg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 10:13:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729146AbgEEONf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 10:13:35 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B1E4C061A0F;
        Tue,  5 May 2020 07:13:35 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id mq3so1186874pjb.1;
        Tue, 05 May 2020 07:13:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vUI7H3zEQ9H8QIwCQ24EAq2pWsz3laTp86kjJwGCy2A=;
        b=YkZw8YQXDccsDbBS4C0O5LMJGsSXIuT1ovPSHZeibMB4ZhJbetT5karBIQDGZyMu0k
         IBdRJNOVOa1GNEbhoAuCCrvOK95e4ExfkjwNMMqw8yyFSpe6/HZclQjj/o/y/DEjyXQf
         D8bD98dH4TU8N9iILFu6DwhyrLrlFYj24qKgldff3S35uVjPxaC8qpPHMbhOElowls51
         NA+CUw+XfSpefYj0MsjjxqdD/1An+fcrvFfnPRdSVMHOAFB4Q7IZukrTfCHjNl6LuXlX
         SkcXFYf+6CloWECw34gLTvnp/U4XgJ2AEyem4IDuABqVEJH0tksWHndPxMQsIdIQQlgL
         50zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vUI7H3zEQ9H8QIwCQ24EAq2pWsz3laTp86kjJwGCy2A=;
        b=T/TvscqHdAIbMR/l9sfaTewI3wA0V+khggHHL3YFmdAyCvd1e1LkHhj33RmC7V3klf
         YQyheZtE8PimCDkc/EdiMIdMFIMgDt8TxXDOGyG/Yr5tRNQotUji9SMxzDKF3l1Az5Rx
         Dy/Q2oF8vl9xexPWXa97iw6ZWr69rwrKXmE/ri5Yplg97c38W4Te9VQjuNBmYAydYWJn
         h6xm12uxfEfVlUWrZfSqwgwu68h/KLC0SvGgtyVGugdUCf1PhK0qW2NRbh04q31tNuz+
         9s0XkPbNT0RjVEeXVEx7Q3yN5Z8q3sdz2Y2SP1Fak01Ety715SdKOEyQ9Ln5+T+RVvrF
         N9Hg==
X-Gm-Message-State: AGi0PuZYt4ZOwzb4DO6RhM+acBpokbvxX//GHQ0qfPzJHk7+6gVgz3lR
        DXSSWABZRi1x0PfVLxbe27g8OPLfqSVqDIYdUZk=
X-Google-Smtp-Source: APiQypKwqHcpUrfpqYd5uUdTyj3td5+1Wg/esi83wvGDAF8yQlrbm2K4xPgTkvNlPBQj0TfYH1WbhCd8ME96fqQEWY0=
X-Received: by 2002:a17:90a:37a3:: with SMTP id v32mr3401271pjb.2.1588688015023;
 Tue, 05 May 2020 07:13:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200505132905.10276-1-calvin.johnson@oss.nxp.com> <20200505132905.10276-4-calvin.johnson@oss.nxp.com>
In-Reply-To: <20200505132905.10276-4-calvin.johnson@oss.nxp.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Tue, 5 May 2020 17:13:28 +0300
Message-ID: <CAHp75Ve4RMhfkNjO9NtNpjT9uRi3p1BAifCGDrB2fhAyBA8YtQ@mail.gmail.com>
Subject: Re: [net-next PATCH v3 3/5] phylink: Introduce phylink_fwnode_phy_connect()
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>
Cc:     "Rafael J . Wysocki" <rafael@kernel.org>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        linux.cj@gmail.com, Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Varun Sethi <V.Sethi@nxp.com>,
        "Rajesh V . Bikkina" <rajesh.bikkina@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        netdev <netdev@vger.kernel.org>, Marcin Wojtas <mw@semihalf.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Makarand Pawagi <makarand.pawagi@nxp.com>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        Pankaj Bansal <pankaj.bansal@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 5, 2020 at 4:29 PM Calvin Johnson
<calvin.johnson@oss.nxp.com> wrote:
>
> Define phylink_fwnode_phy_connect() to connect phy specified by
> a fwnode to a phylink instance.

...

> +       int ret = 0;

Redundant assignment.

> +       if ((IS_ERR(phy_fwnode)) && pl->cfg_link_an_mode == MLO_AN_PHY)

No Lisp, please.

> +               return -ENODEV;

...

> +       phy_dev = fwnode_phy_find_device(phy_fwnode);
> +       fwnode_handle_put(phy_fwnode);

Hmm... Isn't it racy? I mean if you put fwnode here the phy_dev may
already be gone before you call phy_attach_direct, right?

> +       if (!phy_dev)
> +               return -ENODEV;
> +
> +       ret = phy_attach_direct(pl->netdev, phy_dev, flags,
> +                               pl->link_interface);
> +       if (ret)
> +               return ret;
> +
> +       ret = phylink_bringup_phy(pl, phy_dev, pl->link_config.interface);
> +       if (ret)
> +               phy_detach(phy_dev);
> +
> +       return ret;

-- 
With Best Regards,
Andy Shevchenko
