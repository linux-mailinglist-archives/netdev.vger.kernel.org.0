Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11A99337200
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 13:06:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232992AbhCKMFc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 07:05:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232976AbhCKMFE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 07:05:04 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF4F0C061574;
        Thu, 11 Mar 2021 04:05:04 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id kk2-20020a17090b4a02b02900c777aa746fso9244883pjb.3;
        Thu, 11 Mar 2021 04:05:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5mPzWNzDKlhgZjalb5GgSxS0reZzfOeD44HtiEBuIPY=;
        b=Fcb3tje0dUKxkdjlkPSqlau11mGAIZpHC3GasdRMlPEHGqN2RlDrqCT9yYNxTHcNjC
         oscHBf0jUyN5YvxPCz4V4kbfOCQw3njjjWGNChM57qGq+uPCOkEk/kYZXUymRF/3EJme
         125ltp9+2o8TdCKC37u5o0L4UsNtukzNsVJF2MyWYERGDfN/iYSUimys/FtzXWclI1Z1
         plus0rtOfdNORwwde/BnJUfI/H/1jy+dcpU+CP+3dCVqgyYUXQ0mfSotJVQbQC77ills
         e+BGUL2yFGgTwAMc6ujbNHidRlVPuXovkbAaz3w8Yx2yE+JBB79uwMMvK3weOK2PM2UX
         KwuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5mPzWNzDKlhgZjalb5GgSxS0reZzfOeD44HtiEBuIPY=;
        b=ko6spRBKqVwiri45YnvGzCdm63YAgxRmDm+kkc+H1SHgNSiOZEiGO2Qq02+dhvUKrP
         wFO1tslEethsY4d/GO4jyn89gXxraWcBjZsu24Qk+EbaocqE2dkjn9KJq7/brV+LQZVF
         LilIYgt91Qd0X6Ty+riDkqh6PxAjcxV7UuXf6jvfMst5tkvIQ8W9D4KWs9f2i+ImZGJt
         cUsLw/DlgmZazvJS/FMtDDL1i4lzbwZx9JsY4AYNFwCkTkzJ8QQdLGxo04fnOUUFhXl2
         kNdQ6DsP+NfMBtN321prccjBUs0c3MhO6BR22KZFPG/vxsjjV2MwCKmNrGM7uXGyuK49
         miiQ==
X-Gm-Message-State: AOAM531y3RQy7SO8j+KLX2eW6hOhTI/pRZ9KLSAMtBREEIX3XUcXbt2z
        GE+55LRwxQ9oSYuEYZpJSvBMLYMYPV2E/b6yCiM=
X-Google-Smtp-Source: ABdhPJyS9A1hySsLSIhEDeVFwTEOELxWVczuWlA6A1LhJpAvGsEeSzFVGy7/zzKW87Ub4z+hoStcJYlPFhy/rZCwZOM=
X-Received: by 2002:a17:90a:b311:: with SMTP id d17mr1616787pjr.228.1615464304262;
 Thu, 11 Mar 2021 04:05:04 -0800 (PST)
MIME-Version: 1.0
References: <20210311062011.8054-1-calvin.johnson@oss.nxp.com> <20210311062011.8054-8-calvin.johnson@oss.nxp.com>
In-Reply-To: <20210311062011.8054-8-calvin.johnson@oss.nxp.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Thu, 11 Mar 2021 14:04:48 +0200
Message-ID: <CAHp75VdMhBf8MsO+QqMOt_u3+BAiYsT2OeG5qOKnhCbZt1ygmQ@mail.gmail.com>
Subject: Re: [net-next PATCH v7 07/16] net: mii_timestamper: check NULL in unregister_mii_timestamper()
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
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux.cj" <linux.cj@gmail.com>, netdev <netdev@vger.kernel.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 11, 2021 at 8:21 AM Calvin Johnson
<calvin.johnson@oss.nxp.com> wrote:
>
> Callers of unregister_mii_timestamper() currently check for NULL
> value of mii_ts before calling it.
>
> Place the NULL check inside unregister_mii_timestamper() and update
> the callers accordingly

FWIW,
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>

(Don't remember if it has been suggested by somebody, in that case
perhaps Suggested-by?)

> Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
> ---
>
> Changes in v7:
> - check NULL in unregister_mii_timestamper()
>
> Changes in v6: None
> Changes in v5: None
> Changes in v4: None
> Changes in v3: None
> Changes in v2: None
>
>  drivers/net/mdio/of_mdio.c        | 6 ++----
>  drivers/net/phy/mii_timestamper.c | 3 +++
>  drivers/net/phy/phy_device.c      | 3 +--
>  3 files changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
> index 612a37970f14..48b6b8458c17 100644
> --- a/drivers/net/mdio/of_mdio.c
> +++ b/drivers/net/mdio/of_mdio.c
> @@ -115,15 +115,13 @@ static int of_mdiobus_register_phy(struct mii_bus *mdio,
>         else
>                 phy = get_phy_device(mdio, addr, is_c45);
>         if (IS_ERR(phy)) {
> -               if (mii_ts)
> -                       unregister_mii_timestamper(mii_ts);
> +               unregister_mii_timestamper(mii_ts);
>                 return PTR_ERR(phy);
>         }
>
>         rc = of_mdiobus_phy_device_register(mdio, phy, child, addr);
>         if (rc) {
> -               if (mii_ts)
> -                       unregister_mii_timestamper(mii_ts);
> +               unregister_mii_timestamper(mii_ts);
>                 phy_device_free(phy);
>                 return rc;
>         }
> diff --git a/drivers/net/phy/mii_timestamper.c b/drivers/net/phy/mii_timestamper.c
> index b71b7456462d..51ae0593a04f 100644
> --- a/drivers/net/phy/mii_timestamper.c
> +++ b/drivers/net/phy/mii_timestamper.c
> @@ -111,6 +111,9 @@ void unregister_mii_timestamper(struct mii_timestamper *mii_ts)
>         struct mii_timestamping_desc *desc;
>         struct list_head *this;
>
> +       if (!mii_ts)
> +               return;
> +
>         /* mii_timestamper statically registered by the PHY driver won't use the
>          * register_mii_timestamper() and thus don't have ->device set. Don't
>          * try to unregister these.
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index f875efe7b4d1..9c5127405d91 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -928,8 +928,7 @@ EXPORT_SYMBOL(phy_device_register);
>   */
>  void phy_device_remove(struct phy_device *phydev)
>  {
> -       if (phydev->mii_ts)
> -               unregister_mii_timestamper(phydev->mii_ts);
> +       unregister_mii_timestamper(phydev->mii_ts);
>
>         device_del(&phydev->mdio.dev);
>
> --
> 2.17.1
>


-- 
With Best Regards,
Andy Shevchenko
