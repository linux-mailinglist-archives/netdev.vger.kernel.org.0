Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 655DE14F06E
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 17:09:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729334AbgAaQJH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 11:09:07 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:47103 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729138AbgAaQJH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 11:09:07 -0500
Received: by mail-pl1-f193.google.com with SMTP id y8so2903565pll.13;
        Fri, 31 Jan 2020 08:09:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hpBiH5UvVga2L9qKrNHriieDIEKJ+7dJl3rJvusAxwU=;
        b=iFcwZ0g/ZmSbPVnVcfloa/kuREbVy0mNbss2N6WTeo+WiRF62OvdpOQEZOYKaem8Ty
         UOPNm2KP9rQC51B/axKOuyRfRSlOb18LAqgRP7FBpUQU7DewyS+Bv9l9uQCl5Zn/ghWB
         mtPENHVp8IYzOcY57TDUO75Qn85sXrQ7MDwUmOJZIrYiH/ANpLhtg3lfxe7GEMVVK4M0
         GrDJYt1CYI8qp4JZ39P32xPQcH6HeoPT70yd7q5qeKsuqBCrJPM1I5Rmal8BCsXKgAha
         LgiLP0Aj9i3KWoyQr2VHhaYQEZJ8er8sBhD0+z+keuP6zsmJHVJAur/Mzu3qrSXq4o9E
         gDLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hpBiH5UvVga2L9qKrNHriieDIEKJ+7dJl3rJvusAxwU=;
        b=FVobY/Yr2jpIA8VFb33dXEX6QpmTq48fdIlgiTpp56LXrTvQxQpwZFfGPUZL5jBR4g
         qrArm/Dm7Jagxb4sfljrwUcsSk19fBZnTw2YhZhR5JYAlnQxqTsY/94smewtHIbeL5/B
         PXfB4cFDAWZ/8vkckXBCbzbR6RPofuBWbp/bMV35afdn4z76e5Ce4EUeyTf3f9sD+TUQ
         IH1vjf0BRW9Low1guOzDle6bBqAJmGaYthwN/639yKrZ/ZjbIUKFU8uBxtRaazfgI+tk
         1AkPiz1n7cttb5eu6iHuMf4Wob3gO/pObxBHPz9iAnA4VrngAdZKPb7pARydOEiFhWY2
         zFBw==
X-Gm-Message-State: APjAAAVeGIli4BwYccPiH+J+9I4HLO0Q1mxc4nOmfvH2XiCzHUOpnZz+
        +7/mIOjU2ghMYy9nT1pxCZS6UBb5oLu2NQFbQ/SyYu4NueE+Wg==
X-Google-Smtp-Source: APXvYqykvrqIfRm3NrlMePhULUO63QsI46EgzavCRq/mFt6uhD6wzoqn9+XwRLaI5sx8zOxRvdIt5NDWLuaYj0bpOJk=
X-Received: by 2002:a17:90a:2004:: with SMTP id n4mr13343842pjc.20.1580486946392;
 Fri, 31 Jan 2020 08:09:06 -0800 (PST)
MIME-Version: 1.0
References: <20200131153440.20870-1-calvin.johnson@nxp.com> <20200131153440.20870-4-calvin.johnson@nxp.com>
In-Reply-To: <20200131153440.20870-4-calvin.johnson@nxp.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Fri, 31 Jan 2020 18:08:58 +0200
Message-ID: <CAHp75VeRq8XT67LJOM+9R9xVpsfv7MxZpaCHYkfnCqAzgjXo9A@mail.gmail.com>
Subject: Re: [PATCH v1 3/7] net/fsl: add ACPI support for mdio bus
To:     Calvin Johnson <calvin.johnson@nxp.com>
Cc:     linux.cj@gmail.com, Jon Nettleton <jon@solid-run.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Makarand Pawagi <makarand.pawagi@nxp.com>,
        cristian.sovaiala@nxp.com, laurentiu.tudor@nxp.com,
        ioana.ciornei@nxp.com, V.Sethi@nxp.com, pankaj.bansal@nxp.com,
        "Rajesh V . Bikkina" <rajesh.bikkina@nxp.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 31, 2020 at 5:37 PM Calvin Johnson <calvin.johnson@nxp.com> wrote:
>
> From: Calvin Johnson <calvin.johnson@oss.nxp.com>
>
> Add ACPI support for MDIO bus registration while maintaining
> the existing DT support.

...

> -       ret = of_address_to_resource(np, 0, &res);
> -       if (ret) {
> +       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +       if (!res) {
>                 dev_err(&pdev->dev, "could not obtain address\n");
> -               return ret;
> +               return -ENODEV;
>         }

...

> -       snprintf(bus->id, MII_BUS_ID_SIZE, "%llx", (unsigned long long)res.start);
> +       snprintf(bus->id, MII_BUS_ID_SIZE, "%llx",
> +                (unsigned long long)res->start);

Why this has been touched?

...

> -       priv->mdio_base = of_iomap(np, 0);
> +       priv->mdio_base = devm_ioremap_resource(&pdev->dev, res);
>         if (!priv->mdio_base) {

Are you sure the check is correct now?

>                 ret = -ENOMEM;
>                 goto err_ioremap;
>         }

...

>
> -       priv->is_little_endian = of_property_read_bool(pdev->dev.of_node,
> -                                                      "little-endian");
> -
> -       priv->has_a011043 = of_property_read_bool(pdev->dev.of_node,
> -                                                 "fsl,erratum-a011043");
> -
> -       ret = of_mdiobus_register(bus, np);
> -       if (ret) {
> -               dev_err(&pdev->dev, "cannot register MDIO bus\n");

> +       if (is_of_node(pdev->dev.fwnode)) {

> +       } else if (is_acpi_node(pdev->dev.fwnode)) {

Oh, no, this is wrong. Pure approach AFAICS is to use fwnode API or
device property API.

And actually what you need to include is rather <linux/property.h>,
and not acpi.h.

> +       } else {
> +               dev_err(&pdev->dev, "Cannot get cfg data from DT or ACPI\n");
> +               ret = -ENXIO;
>                 goto err_registration;
>         }

> +static const struct acpi_device_id xgmac_mdio_acpi_match[] = {
> +       {"NXP0006", 0}

How did you test this on platforms with the same IP and without device
 of this ACPI ID present?

(Hint: missed terminator)

> +};
> +MODULE_DEVICE_TABLE(acpi, xgmac_mdio_acpi_match);

> +               .acpi_match_table = ACPI_PTR(xgmac_mdio_acpi_match),

ACPI_PTR is not needed otherwise you will get a compiler warning.

-- 
With Best Regards,
Andy Shevchenko
