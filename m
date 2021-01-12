Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E6562F34A7
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 16:52:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391919AbhALPv5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 10:51:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733044AbhALPvz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 10:51:55 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27AB2C061786;
        Tue, 12 Jan 2021 07:51:15 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id r4so1591308pls.11;
        Tue, 12 Jan 2021 07:51:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=R3JNDoPNmh/xsSk6z7wd+DpVkA7tUE/GQpUzABypsAE=;
        b=nZ6i5UFfAjxhQv39XnaJ63fnIyBFz4lpd7xk6yh39Qbit4d8OQl+7X7NuumhQ3zMIQ
         RrYQYwW4SOCqWbC6KmmcVkHoAMc3WSnORK/cBFFsVRXtivb2E0eGpti3cD58qTeYIE/g
         9wCd85fOYnHJdaaqv9TkEJXz3t+QLQMDwm/Wrnwc07VH3yZoDB46G1j3mkiXJ+jrntxY
         3JU1qSCe83wmvescrkQOMEi/nmdM6Jwxu6X5QMrHo6oQSor+NUPVjqOJ7ZYE7dV1aZN4
         WaFf3KJgDbEDC2pDDeUzKS9nhxAW/Z+lkFtrxi4FyBRYj0ImbunPTJrQzUm2r1R4kkPg
         9pPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R3JNDoPNmh/xsSk6z7wd+DpVkA7tUE/GQpUzABypsAE=;
        b=C4MCWWgMYqY124SZqE+cA7VaI1rMIg0oG3zJalUaeQLiqDrAJJ0lXmhq6rSmrnX0q2
         P7sI/oxDI5c4cUXVXlSTwGM2JHdhuwFtO5NqgclDJ6ECdrvlslJ9EZA3lRSSS3p/qimI
         jBZUbcuFarZEzyYlftk9lBE3PK6+e2rtN7TVRW2Lp4ezaydYJAI95snOn57KmnM0ce69
         QEihMCF6dCAtn1qkLEORnEuIKZ+ITSKXZORTPTeJKrNBek5n7b1DpgPxIvCA/ujHaPWu
         qS+oxNvweaUfDdEDhHoU0ws52pM2YoJuYqWYCEDFWhDWBFTExV9iEm1apCQ11V+WYbQj
         rATA==
X-Gm-Message-State: AOAM531VRuaRv1xp2GbJvGghNULkJxUm8kjCtCYpy/CkiUmJZAInzjUE
        Fz7Y3SiU8kz6g5i0KX84XK8bL+dr2G03cdmLBhk=
X-Google-Smtp-Source: ABdhPJx1RgjJc+Q8z63ZB5X0zrYHXbc6AKQYmKuKwzHpaZ26tka8dJ5+Fn9qqkJI6xUWKjywkGZ7Fv8TyMxacNRqiY0=
X-Received: by 2002:a17:90a:1050:: with SMTP id y16mr5384547pjd.181.1610466674728;
 Tue, 12 Jan 2021 07:51:14 -0800 (PST)
MIME-Version: 1.0
References: <20210112134054.342-1-calvin.johnson@oss.nxp.com> <20210112134054.342-12-calvin.johnson@oss.nxp.com>
In-Reply-To: <20210112134054.342-12-calvin.johnson@oss.nxp.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Tue, 12 Jan 2021 17:52:03 +0200
Message-ID: <CAHp75Vfdt9CCHY+tpYXf-jPTxkN0v5Jo5CHojgfz=DAb3hcAmg@mail.gmail.com>
Subject: Re: [net-next PATCH v3 11/15] net: mdiobus: Introduce fwnode_mdiobus_register()
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
        Jon <jon@solid-run.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "linux.cj" <linux.cj@gmail.com>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 3:42 PM Calvin Johnson
<calvin.johnson@oss.nxp.com> wrote:
>
> Introduce fwnode_mdiobus_register() to register PHYs on the  mdiobus.
> If the fwnode is DT node, then call of_mdiobus_register().
> If it is an ACPI node, then call acpi_mdiobus_register().

...

> +/**
> + * fwnode_mdiobus_register - Register mii_bus and create PHYs from fwnode
> + * @mdio: pointer to mii_bus structure
> + * @fwnode: pointer to fwnode of MDIO bus.
> + *
> + * This function returns of_mdiobus_register() for DT and
> + * acpi_mdiobus_register() for ACPI.
> + */
> +int fwnode_mdiobus_register(struct mii_bus *mdio, struct fwnode_handle *fwnode)
> +{
> +       if (is_of_node(fwnode))
> +               return of_mdiobus_register(mdio, to_of_node(fwnode));
> +       else if (is_acpi_node(fwnode))

Redundant 'else'

> +               return acpi_mdiobus_register(mdio, fwnode);
> +
> +       return -EINVAL;
> +}

-- 
With Best Regards,
Andy Shevchenko
