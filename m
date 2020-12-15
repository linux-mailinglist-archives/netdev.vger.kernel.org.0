Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F8152DB314
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 18:55:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731270AbgLORzB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 12:55:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725973AbgLORyx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 12:54:53 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 478CBC06179C;
        Tue, 15 Dec 2020 09:54:13 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id v3so11422061plz.13;
        Tue, 15 Dec 2020 09:54:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Imm3qTkuoDk7CQF3C2jQl/pGCHvRyWbGvp5H8N4iN3o=;
        b=vHZrgEGJHh/22GCAt73JD6CLGnlrkFlwoF/Nvnh1Rx1k/74QEBbQoOXXeb4yYITNDM
         Mzy3FUS8e+etYpgCZ2n4aP1R8JjTVnV/QlHXa5jwnwh2BZdV0eRaDL4KJEPgNTv2ixoo
         VCTjBM9cD25taOOJQldrnDK8bw6AeLYi00tiskafi9VpuqXDssSE/PCIBogBEve/RkBi
         vCH16c/GXjzk85CA5BCJ08U8SFOdJ8iXLM+sWlO7LtQaUo7hVjH9cwkYbraHQ6s+2ZSR
         xBXRZxRKqvC47sO2sILhomBGtfgoEwO07T49bzxmezasRXIucbNEERX9WO7vMoLMRG12
         2k3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Imm3qTkuoDk7CQF3C2jQl/pGCHvRyWbGvp5H8N4iN3o=;
        b=lf4ue0UYvQGPvrP7siBTezB997kV6IHc7sZhSbzZyXBWlX8k7rMmilRS0ByeUMcNC2
         gA1RQz5tBvEC67fx0ZQHANLt0c9FdXw4ur9t0PaAvTbXsQkShX/dvwL0xNnWrIDG9XJS
         eQH9yGTNFBpW0lahy+/Qb/iksFNKXQbw8l+UWjfU5VnS7ZApChKmG8e6TSHH8WZUYD/m
         ki2LKSynRNL4uxY0Ppi7SciUiEKkaJbDO2tcSFEHf5qsk3SPPHCn2gKWskJ3Tab+O8LU
         K/gzpFEIErKp9nq+yU29ZU/c7OpVyKdRCykUpSGzJVclbzstdfkxka8msBedA0i5zLEt
         yaLQ==
X-Gm-Message-State: AOAM533P2yt5f3TPblIv1tID8dqzYY+/vqO3HBR4qd+kEpFi7sKB+iHz
        fMDCwCc/T2wBZAWVTEET6AJn1rbayF+y3IGJQUQ=
X-Google-Smtp-Source: ABdhPJwub519C6COC+xUOfBDKNnTtjj4F8G3dk+pPzgjeNH2EtNKhkRk1+UGRjj9xodbX0Xs0OGbqZ+431AbEsjjLG4=
X-Received: by 2002:a17:902:b7c3:b029:da:76bc:2aa9 with SMTP id
 v3-20020a170902b7c3b02900da76bc2aa9mr28627847plz.21.1608054852814; Tue, 15
 Dec 2020 09:54:12 -0800 (PST)
MIME-Version: 1.0
References: <20201215164315.3666-1-calvin.johnson@oss.nxp.com> <20201215164315.3666-10-calvin.johnson@oss.nxp.com>
In-Reply-To: <20201215164315.3666-10-calvin.johnson@oss.nxp.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Tue, 15 Dec 2020 19:55:01 +0200
Message-ID: <CAHp75Vc19QCqYpp12Q3ofzXCVsujc0qVuhtQo5LhDJqiy+JNpw@mail.gmail.com>
Subject: Re: [net-next PATCH v2 09/14] net/fsl: Use fwnode_mdiobus_register()
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
        Jakub Kicinski <kuba@kernel.org>,
        Jamie Iles <jamie@nuviainc.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 15, 2020 at 6:44 PM Calvin Johnson
<calvin.johnson@oss.nxp.com> wrote:
>
> fwnode_mdiobus_register() internally takes care of both DT
> and ACPI cases to register mdiobus. Replace existing
> of_mdiobus_register() with fwnode_mdiobus_register().
>
> Note: For both ACPI and DT cases, endianness of MDIO controller
> need to be specified using "little-endian" property.

...

> @@ -2,6 +2,7 @@
>   * QorIQ 10G MDIO Controller
>   *
>   * Copyright 2012 Freescale Semiconductor, Inc.
> + * Copyright 2020 NXP
>   *
>   * Authors: Andy Fleming <afleming@freescale.com>
>   *          Timur Tabi <timur@freescale.com>
> @@ -11,6 +12,7 @@

I guess this...

>         priv->is_little_endian = device_property_read_bool(&pdev->dev,
>                                                            "little-endian");
> -
>         priv->has_a011043 = device_property_read_bool(&pdev->dev,
>                                                       "fsl,erratum-a011043");

...this...

> -

...and this changes can go to a separate patch.

-- 
With Best Regards,
Andy Shevchenko
