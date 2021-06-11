Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED05D3A4137
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 13:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231495AbhFKL3l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 07:29:41 -0400
Received: from mail-pj1-f54.google.com ([209.85.216.54]:38735 "EHLO
        mail-pj1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230248AbhFKL3k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 07:29:40 -0400
Received: by mail-pj1-f54.google.com with SMTP id m13-20020a17090b068db02901656cc93a75so5672025pjz.3;
        Fri, 11 Jun 2021 04:27:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h4XBx6hy/8HemTestI8gx5CVIEJQPh5SHNT2c3CXnb4=;
        b=rcciTaLnGKf0bY+pPO8FwxoOXt0lVZm79aIo1gkrehaurfpJDOI9ugW/6rpoprP2p0
         eR/c/rDamGM2HF4c0TNczIAXWs7O9JyvxdCPnkBGndSC0i767zSjoV+BmvfHVBSqQWyV
         iFlBuXhampJ7t8Cb7+xV3/yCngTtHrPHnmeqY7OCasqUjntyocJljMWz1CTpzHNnTzpb
         LVx6xMLL1nB4S/kpUW/NJ9s6Zysk3DvGmYCA7bXvEqXmQqRkn6Lc9tnp3WIZbRd7vFRI
         oWbbq5BXntVc/zufWP6Lz0wJhvzSivys4gB6sPnbseSYghKvWidvHxifW9jRBajTumSr
         qn4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h4XBx6hy/8HemTestI8gx5CVIEJQPh5SHNT2c3CXnb4=;
        b=mFuJr2jNjg56fuqQouxJkqGDxTM8UNeTFMV5RkHgDr2A8CQPH90OaoBHTaxB91zPEu
         T+ZllQ1weay6zU7+toMBC+dvVNsf3Oz3BxBCSSw50W44yEmhEgZaU+A0CMkux79iB5Ow
         kuX38SlvRuqXUcgkzNlQw79873zKMnzN0zForW+K+0htd1GdF+e+nlbDqQQMbMR7njXL
         uGhZfzGO1Fb3o587YZINb9fhPtUUvb3FnC41jXUvKIbDfmoXVCBNfmE+8xr3U+Vj1DY/
         ZOZ8kYo1lUwIZ9aiAExeZ1vGBrV5G4Ib//7PyvyCC7KmuCWGH/SNIYc3rnVXk48agNnE
         X7Ng==
X-Gm-Message-State: AOAM532T/AcTkuLs1mjS9kAD6rZJxeHhzX5+c3taSKpGa2tDshiYw2cd
        aoC2gJoGu/iSbSt7W6liOTJz7ukC2JkS5mSXSOY=
X-Google-Smtp-Source: ABdhPJzu9xzYtnBrRvh2AQos0EplFhBidiSQVytvzwTGQJ7UQDj+xrv8IWDD18RS/gAhTpmrdgRZsL5uHfb4I1HK1vU=
X-Received: by 2002:a17:90a:80c5:: with SMTP id k5mr8780907pjw.129.1623410802452;
 Fri, 11 Jun 2021 04:26:42 -0700 (PDT)
MIME-Version: 1.0
References: <20210611105401.270673-1-ciorneiioana@gmail.com> <20210611105401.270673-4-ciorneiioana@gmail.com>
In-Reply-To: <20210611105401.270673-4-ciorneiioana@gmail.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Fri, 11 Jun 2021 14:26:26 +0300
Message-ID: <CAHp75VcfEbMecsGprNW33OtiddVw1MhmOVrtb9Gx4tKL5BjvYw@mail.gmail.com>
Subject: Re: [PATCH net-next v9 03/15] net: phy: Introduce phy related fwnode functions
To:     Ioana Ciornei <ciorneiioana@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Jon <jon@solid-run.com>, Saravana Kannan <saravanak@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux.cj" <linux.cj@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Len Brown <lenb@kernel.org>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 11, 2021 at 1:54 PM Ioana Ciornei <ciorneiioana@gmail.com> wrote:
>
> From: Calvin Johnson <calvin.johnson@oss.nxp.com>
>
> Define fwnode_phy_find_device() to iterate an mdiobus and find the
> phy device of the provided phy fwnode. Additionally define
> device_phy_find_device() to find phy device of provided device.
>
> Define fwnode_get_phy_node() to get phy_node using named reference.

using a named

...

> +struct fwnode_handle *fwnode_get_phy_node(struct fwnode_handle *fwnode)
> +{
> +       struct fwnode_handle *phy_node;
> +
> +       /* Only phy-handle is used for ACPI */
> +       phy_node = fwnode_find_reference(fwnode, "phy-handle", 0);
> +       if (is_acpi_node(fwnode) || !IS_ERR(phy_node))
> +               return phy_node;
> +       phy_node = fwnode_find_reference(fwnode, "phy", 0);
> +       if (IS_ERR(phy_node))
> +               phy_node = fwnode_find_reference(fwnode, "phy-device", 0);
> +       return phy_node;

Looking into the patterns in this code I would perhaps refactor it the
following way:

     /* First try "phy-handle" as most common in use */
     phy_node = fwnode_find_reference(fwnode, "phy-handle", 0);
     /* Only phy-handle is used for ACPI */
     if (is_acpi_node(fwnode))
              return phy_node;
     if (!IS_ERR(phy_node))
              return phy_node;
     /* Try "phy" reference */
     phy_node = fwnode_find_reference(fwnode, "phy", 0);
     if (!IS_ERR(phy_node))
              return phy_node;
     /* At last try "phy-device" reference */
     return fwnode_find_reference(fwnode, "phy-device", 0);

> +}


-- 
With Best Regards,
Andy Shevchenko
