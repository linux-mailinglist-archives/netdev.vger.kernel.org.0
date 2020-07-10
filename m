Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5903821BEE8
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 23:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbgGJVBj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 17:01:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726374AbgGJVBh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 17:01:37 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 680BDC08C5DC;
        Fri, 10 Jul 2020 14:01:37 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id o22so3124137pjw.2;
        Fri, 10 Jul 2020 14:01:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/jfpD0ajn/lo+yQ7m4BQ4OdyYnJ6P/bgDedKUHu37Rg=;
        b=Nh2jdHe8x8WAdYeG1ogXcvH7phd+VinXTyA7S5Gxz1BC6d2jphp6exKnhyPFvMCXMz
         3LNVv5cFPZWCV+FySLNCU6VsEFzeuXsAztYnVrWB+Bt63Zo3W/b0WasXuEwREyLCqFvk
         HOUFyeZIVJyknIQ+mhrH3WJzTrQOwzCBj9ZiRK2Rx9iHvV6Fqq8y+/DRbcc9pD90njWH
         YTdcMC6Vj+uFMnY8fUD7ruyWPXh0BAtxlnZv8MKLgezy54AGp+o8nTERzIRIXXaWPQhJ
         hs4/rXrh5aGTvAnxUw4b8//GsuAEp7zMDcq8E/k25ZLkenHRNbG+mchLUNIQDTm6rJJ0
         neiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/jfpD0ajn/lo+yQ7m4BQ4OdyYnJ6P/bgDedKUHu37Rg=;
        b=Ytm4K7C7zD85TLToXr96HJmdNSq4uzj6IWOxNfrFU7UhDFz2XmQWJw4/zSg8yFonGR
         WEwBLXOWjDf75koB2KyD5WUpGBOKGxsm9N4bgaVQt0J5BbcGlX9pBuZstJiiIYOiRzAw
         aFspU3O5T1gMeRzqh3hbiM+r3XYSf0aE5mdnTOXr7uL9uhybZwm2XQOClXaHcu8DJs7O
         tVws2ToWrLao9XLQM0aYY332atN1jpQ7Ac7N5OUKrw6Ms/T2Ws+7x5jjnMfI9n1vNPFt
         J3E/jJ2DzYBH771S9NqmtdECxhR0oYXnnWwtL5A6+tLEUuiWvNF5J1Lcwet5kIuDH4cW
         eAZQ==
X-Gm-Message-State: AOAM5332OikDGjBKROko8KU3pI6Qwc0JawVdj80pT86WwS+3o64GYxXQ
        CfCPXioFmlhGqFBJb99r1+XTgG9MdO58g7ac0Yw=
X-Google-Smtp-Source: ABdhPJwEZP8egV/8/yQnw/9a5Zl4LuAEBel0j+SiDz2X/bnShsXn8zIk39uq7W+hVirXcL9wKaaqDliFTW9Pqo5GurU=
X-Received: by 2002:a17:90b:3547:: with SMTP id lt7mr7528756pjb.181.1594414896952;
 Fri, 10 Jul 2020 14:01:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200710163115.2740-1-calvin.johnson@oss.nxp.com> <20200710163115.2740-6-calvin.johnson@oss.nxp.com>
In-Reply-To: <20200710163115.2740-6-calvin.johnson@oss.nxp.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Sat, 11 Jul 2020 00:01:20 +0300
Message-ID: <CAHp75Vef0wTJj775PFwXs3XhbXqZBmOQ_E9qdHFYPPCegW4rfA@mail.gmail.com>
Subject: Re: [net-next PATCH v5 5/6] phylink: introduce phylink_fwnode_phy_connect()
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>
Cc:     Jeremy Linton <jeremy.linton@arm.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        netdev <netdev@vger.kernel.org>, linux.cj@gmail.com,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 10, 2020 at 7:32 PM Calvin Johnson
<calvin.johnson@oss.nxp.com> wrote:
>
> Define phylink_fwnode_phy_connect() to connect phy specified by
> a fwnode to a phylink instance.

...

> +int phylink_fwnode_phy_connect(struct phylink *pl,
> +                              struct fwnode_handle *fwnode,
> +                              u32 flags)
> +{
> +       struct phy_device *phy_dev;

> +       int ret = 0;

This assignment is redundant and actually entire var is not needed.

> +       if (is_of_node(fwnode)) {
> +               ret = phylink_of_phy_connect(pl, to_of_node(fwnode), flags);
> +       } else if (is_acpi_device_node(fwnode)) {
> +               phy_dev = phy_find_by_mdio_handle(fwnode);
> +               if (!phy_dev)
> +                       return -ENODEV;
> +               ret = phylink_connect_phy(pl, phy_dev);
> +       } else {
> +               ret = -EINVAL;
> +       }
> +
> +       return ret;

You may refactor in the similar way, i.e.

if (is_of_node(...))
  return phy...
if (is_acpi_device_node(...)) {
  ... return phylink_connect_phy();
}
return -EINVAL;

> +}

-- 
With Best Regards,
Andy Shevchenko
