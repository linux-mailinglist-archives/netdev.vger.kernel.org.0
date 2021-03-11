Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A939336C84
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 07:52:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231494AbhCKGwF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 01:52:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231328AbhCKGve (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 01:51:34 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9C43C061574
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 22:51:33 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id f145so4223382ybg.11
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 22:51:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/TWjmkYOsjWxuSvsZczTiKRCUZs8/TXiLhq6HTYxrkc=;
        b=ZiX9Rg7lAbNihf5ARUd3fj7zUcwh3LumoEDPAk5Ai99apA62qWW2GkHJk6efyfiEy7
         coJVlTQ102RjumLiZAw6DPjna6+4gPzHFKWtY5g+xILHxGYvd6jDQPDP5QtdTlQD/Hc9
         ik5KFF9f83yCTuTTdV2f8XqHJ6sJIrr/hnF6DlsiO+xBdbFU+FaYxKUTgWWqQ2fFmQqt
         eZEkduD+GIm6/za07O/KG2PEyO/LxQHG0B1W632QMeeJXb5cYOQ2FRa+nfD+UdCXcCvn
         N3naoX+/jUCKauItbzKRwv5w5FelkgvfUjxo6FypJWGjGHvc72A44VN4Nq0XUONe9PV+
         4C3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/TWjmkYOsjWxuSvsZczTiKRCUZs8/TXiLhq6HTYxrkc=;
        b=mtUH6W246m+s7xt9ZWf7frBU1xICtqmyPzW7oauoit7uSmYadgO/8dkfKw62L+ccgg
         287LITgjPiWWW3DPv0mEkN7LsYf92Quu3AisLA+m3M9XQbWCY+P1rY1KtepBvKa74iP8
         t9udbbW5JZFp7rnjyp8tOHcjBVcmuw0mdRLPRpl93OjNgcyw28NVOkmDnD7Iz0awkXKL
         nd5l7ujmTHlTKb9Y9ARYRzJfxcOm6tnf/anNdzY3geLSWUdxbE4XzU0aPIvLGOhUbHUl
         h5+rMrvjm/XspIzqTLaHb+jX7+xf4Mm0HdzCCSIk7hhpw7bCwVfIM8pTo/PugxXHcI7E
         Lf6g==
X-Gm-Message-State: AOAM531PU6ta2tpFcMHF3kso9YhU2CWF4roZJ0IKi7Lx86hHluwwk9uh
        UMRqAN6n3WDOoraH55biCQUcwGJhKkG3VDoDF5nSww==
X-Google-Smtp-Source: ABdhPJyeMMYfKt7AqgiPS4WR08oFWWbtn89mOZetlzxKAEFqnCJiyg8wlDXKmHktl0o6G3gFpBAeEwo1DQv7jjqj8so=
X-Received: by 2002:a25:aa43:: with SMTP id s61mr10180775ybi.32.1615445492980;
 Wed, 10 Mar 2021 22:51:32 -0800 (PST)
MIME-Version: 1.0
References: <20210311062011.8054-1-calvin.johnson@oss.nxp.com> <20210311062011.8054-3-calvin.johnson@oss.nxp.com>
In-Reply-To: <20210311062011.8054-3-calvin.johnson@oss.nxp.com>
From:   Saravana Kannan <saravanak@google.com>
Date:   Wed, 10 Mar 2021 22:50:57 -0800
Message-ID: <CAGETcx87Upc701NZstiDx8Px1o9b+s4ANpbG0AP5bjC8DxMMrg@mail.gmail.com>
Subject: Re: [net-next PATCH v7 02/16] net: phy: Introduce fwnode_mdio_find_device()
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>
Cc:     Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Jon <jon@solid-run.com>, Randy Dunlap <rdunlap@infradead.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux.cj" <linux.cj@gmail.com>, netdev <netdev@vger.kernel.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 10, 2021 at 10:21 PM Calvin Johnson
<calvin.johnson@oss.nxp.com> wrote:
>
> Define fwnode_mdio_find_device() to get a pointer to the
> mdio_device from fwnode passed to the function.
>
> Refactor of_mdio_find_device() to use fwnode_mdio_find_device().
>
> Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
> ---
>
> Changes in v7:
> - correct fwnode_mdio_find_device() description
>
> Changes in v6:
> - fix warning for function parameter of fwnode_mdio_find_device()
>
> Changes in v5: None
> Changes in v4: None
> Changes in v3: None
> Changes in v2: None
>
>  drivers/net/mdio/of_mdio.c   | 11 +----------
>  drivers/net/phy/phy_device.c | 23 +++++++++++++++++++++++
>  include/linux/phy.h          |  6 ++++++
>  3 files changed, 30 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
> index ea9d5855fb52..d5e0970b2561 100644
> --- a/drivers/net/mdio/of_mdio.c
> +++ b/drivers/net/mdio/of_mdio.c
> @@ -347,16 +347,7 @@ EXPORT_SYMBOL(of_mdiobus_register);
>   */
>  struct mdio_device *of_mdio_find_device(struct device_node *np)
>  {
> -       struct device *d;
> -
> -       if (!np)
> -               return NULL;
> -
> -       d = bus_find_device_by_of_node(&mdio_bus_type, np);
> -       if (!d)
> -               return NULL;
> -
> -       return to_mdio_device(d);
> +       return fwnode_mdio_find_device(of_fwnode_handle(np));
>  }
>  EXPORT_SYMBOL(of_mdio_find_device);
>
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index cc38e326405a..daabb17bba00 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -2819,6 +2819,29 @@ static bool phy_drv_supports_irq(struct phy_driver *phydrv)
>         return phydrv->config_intr && phydrv->handle_interrupt;
>  }
>
> +/**
> + * fwnode_mdio_find_device - Given a fwnode, find the mdio_device
> + * @fwnode: pointer to the mdio_device's fwnode
> + *
> + * If successful, returns a pointer to the mdio_device with the embedded
> + * struct device refcount incremented by one, or NULL on failure.
> + * The caller should call put_device() on the mdio_device after its use.
> + */
> +struct mdio_device *fwnode_mdio_find_device(struct fwnode_handle *fwnode)
> +{
> +       struct device *d;
> +
> +       if (!fwnode)
> +               return NULL;
> +
> +       d = bus_find_device_by_fwnode(&mdio_bus_type, fwnode);

Sorry about the late review, but can you look into using
get_dev_from_fwnode()? As long as you aren't registering two devices
for the same fwnode, it's an O(1) operation instead of having to loop
through a list of devices in a bus. You can check the returned
device's bus type if you aren't sure about not registering two devices
with the same fw_node and then fall back to this looping.

-Saravana

> +       if (!d)
> +               return NULL;
> +
> +       return to_mdio_device(d);
> +}
> +EXPORT_SYMBOL(fwnode_mdio_find_device);
> +
>  /**
>   * phy_probe - probe and init a PHY device
>   * @dev: device to probe and init
> diff --git a/include/linux/phy.h b/include/linux/phy.h
> index 1a12e4436b5b..f5eb1e3981a1 100644
> --- a/include/linux/phy.h
> +++ b/include/linux/phy.h
> @@ -1366,11 +1366,17 @@ struct phy_device *phy_device_create(struct mii_bus *bus, int addr, u32 phy_id,
>                                      bool is_c45,
>                                      struct phy_c45_device_ids *c45_ids);
>  #if IS_ENABLED(CONFIG_PHYLIB)
> +struct mdio_device *fwnode_mdio_find_device(struct fwnode_handle *fwnode);
>  struct phy_device *get_phy_device(struct mii_bus *bus, int addr, bool is_c45);
>  int phy_device_register(struct phy_device *phy);
>  void phy_device_free(struct phy_device *phydev);
>  #else
>  static inline
> +struct mdio_device *fwnode_mdio_find_device(struct fwnode_handle *fwnode)
> +{
> +       return 0;
> +}
> +static inline
>  struct phy_device *get_phy_device(struct mii_bus *bus, int addr, bool is_c45)
>  {
>         return NULL;
> --
> 2.17.1
>
