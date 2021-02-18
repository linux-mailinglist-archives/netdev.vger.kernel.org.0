Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 713FC31ED5D
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 18:37:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbhBRRcR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 12:32:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230487AbhBROxC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Feb 2021 09:53:02 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 351F6C061574;
        Thu, 18 Feb 2021 06:52:21 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id z9so1605105pjl.5;
        Thu, 18 Feb 2021 06:52:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8jS31/1Xy+yRuy91zGYhjBqYA9AzfRcHmkz195N5Ino=;
        b=a5EsrysyjYS2a3vIaxGq657Ry7MQI+NuO/AkfEuVdskDMAZ7G71BzRfPVmksdG56W/
         3fAATQrKa3yCs+icFjOeOgjgNunLPTd63UJenFJ2QeEJJAq5L5EiBoXNGXqyluh7kvm/
         Pr1yQMWKZmkRfM7IeHLvsLbYMdGxoyw0qSumoMZ+F2SO9Jivus+xeEo2OAm8XWx8yJoH
         Id61kAt6ZOw/Mp6/aDt9JIM/p+GSNgiNy+4Za3ROSGqEP06JMtFuG2aMTiJfVQGi+hhr
         G4X90zlP8P6VLqoFlepGV2rexaMl/D6C22YIvK/WoyTW6f09Pk43n4AwOyOiG+ni+lqp
         PT/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8jS31/1Xy+yRuy91zGYhjBqYA9AzfRcHmkz195N5Ino=;
        b=sE643N3bvrm47EcYMcGpZUM3kDE0FzPaySmnt5yhR5/bAMfnXTnwCaiNkhCW0DTurv
         kfzTVp/dUp5rvkcBRmRaLv0rQjU055+YcRAMyHhEGapkBlKvodFe8Lvni0pMZu2C5UfT
         2Hx9nF1WpVDNmqyY0Qw0xrjaQWhtyr3WR3kxz5SsRKS90iqn5gpYqZYL4IIfocmU5NR7
         SunqGgBVkkGBS35uQ/VVmp7LN09ADEC3lvQcVX+/Cij/6TmeBAYuDp8XzocuNc4f5sjq
         VFsOCqmE3udsB5CJJC7OupaXDMMzeDU5n4yaeTDrmMfsg627yAUzjX4bnBQxPl/GWpvX
         XQzg==
X-Gm-Message-State: AOAM532bd63tJeFyMWMr8sSb3RApP9aKTCh+6SiijklTcQAIjPWDZPpY
        BatREyFuyVkEFrGROBel6WL0MvDVEgpTCfcSR5I=
X-Google-Smtp-Source: ABdhPJxZI+4VfRDkag4o49pJKHBbnYmuybuwr0rlNf4PNsh4hcHvrKgQYLePPB3gebs5CWrYpfq6N3/h19hC0Wz5GGo=
X-Received: by 2002:a17:902:a710:b029:e3:b18:7e5b with SMTP id
 w16-20020a170902a710b02900e30b187e5bmr4353726plq.17.1613659940699; Thu, 18
 Feb 2021 06:52:20 -0800 (PST)
MIME-Version: 1.0
References: <20210218052654.28995-1-calvin.johnson@oss.nxp.com> <20210218052654.28995-8-calvin.johnson@oss.nxp.com>
In-Reply-To: <20210218052654.28995-8-calvin.johnson@oss.nxp.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Thu, 18 Feb 2021 16:52:04 +0200
Message-ID: <CAHp75VetyEo6+KhWm=h3iCSfRS6KGFXR4fOHE3KA9sWcwZsXrg@mail.gmail.com>
Subject: Re: [net-next PATCH v6 07/15] net: mdiobus: Introduce fwnode_mdiobus_register_phy()
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
        Jon <jon@solid-run.com>, Saravana Kannan <saravanak@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        "linux.cj" <linux.cj@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Frank Rowand <frowand.list@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        devicetree <devicetree@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 18, 2021 at 7:28 AM Calvin Johnson
<calvin.johnson@oss.nxp.com> wrote:
>
> Introduce fwnode_mdiobus_register_phy() to register PHYs on the
> mdiobus. From the compatible string, identify whether the PHY is
> c45 and based on this create a PHY device instance which is
> registered on the mdiobus.

Thanks for an update!
Below some nit-picks, may be ignored.

> uninitialized symbol 'mii_ts'
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>

I don't think the above deserves to be in the commit message (rather
after the cutter '---' line as a changelog).

> Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>

...

> +               if (mii_ts)
> +                       unregister_mii_timestamper(mii_ts);

...

> +                       if (mii_ts)
> +                               unregister_mii_timestamper(mii_ts);

I'm wondering if we can move this check to the
unregister_mii_timestamper() to make it NULL aware as many other
similar (unregister) APIs do. I have checked that there are currently
three users of this that can benefit of the change.

...

> +       /* phy->mii_ts may already be defined by the PHY driver. A
> +        * mii_timestamper probed via the device tree will still have
> +        * precedence.
> +        */
> +       if (mii_ts)
> +               phy->mii_ts = mii_ts;

I'm wondering if the belo form is better to read

        phy->mii_ts = mii_ts ?: phy->mii_ts;

-- 
With Best Regards,
Andy Shevchenko
