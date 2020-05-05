Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42D351C5907
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 16:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730597AbgEEOVS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 10:21:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729797AbgEEOPX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 10:15:23 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FC5DC061A0F;
        Tue,  5 May 2020 07:15:23 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id s8so1135687pgq.1;
        Tue, 05 May 2020 07:15:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0nX/PJie6N8ENA2Zvbm0yQ+G3ZDyBTfdd9KJ7MPuSj4=;
        b=nfmE75xAk2mRtYELliGHUe/ax/6qkgrPatqmkxJZ/4QQY+o+lMk11CjpG4sAQ3FVBV
         WzncbHPCgbdKwNdc+0McksELLJMYnMAiR59i9RiNpkJ1wTWQvRjMj/LOf+Xb5oeK3q9X
         8VD8zvXA45j3xTucUWd8a6+SrLV7AXDs8dsNgTmPYadNJvCSJY3+9yk+3FG9cqznsAn1
         Ayjs9sTijBSlXb0wCaoDlmLuPkX19TLs6CSO8ttbuzlrxO+xpFQbVBsTgFRVP0zVj4wd
         QyMxU4d3tVal6fMMXpNV6WOxd3TZfCk2bsV8QT8ybu6iLP/OmMTw0MsgxUT8NrAH2Rv+
         1Ceg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0nX/PJie6N8ENA2Zvbm0yQ+G3ZDyBTfdd9KJ7MPuSj4=;
        b=L303mJpbVSMNy1ExethZrn1BrbfB9EogsM9HridS/D8+4WcZiXGqoWk7vWF6GPZiwo
         ShmaWWFGJ/lyaH7gqfTXYghTHub9QlUO9yz7cn1laBMCOMwbudx9/lUWLuGL5xuJsNPo
         CI2/0YQ5F4AV4a4lCye0DXUkXVIqhJBIFeqaCZIeyjXJz25GoUDcSbduNuFXuXG1N0Il
         aR7+eG5H1tpsAUtCeJAVMMxvj//QmYLwQnhRPokCYQg8i4fnhrU8bTRoi60H2Z/K8kVY
         OqMOUi1o1U6nMLpn3D1XnMCvtKo15MO15T8WFUGIHH+dzfcK0X1j6BB+qCz34GA751PF
         AJMw==
X-Gm-Message-State: AGi0PuamiyE38pwwZG5ADwgsmkPDl8yYZxVtl5QOKKVlbSCLmL/w7NJm
        BnWthRIaovLTx4nmjYGsV71Mz904+ktKfu2m3T4=
X-Google-Smtp-Source: APiQypLc7JWdA097hNwo8eG2GAZy8/3FtlTIfHPPFCBF9V0wjqm7rU8EeIuNboUNOrlwwMtxJqnfA7pV8Mn60TSZrt8=
X-Received: by 2002:a62:5ec7:: with SMTP id s190mr3257831pfb.130.1588688122575;
 Tue, 05 May 2020 07:15:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200505132905.10276-1-calvin.johnson@oss.nxp.com> <20200505132905.10276-5-calvin.johnson@oss.nxp.com>
In-Reply-To: <20200505132905.10276-5-calvin.johnson@oss.nxp.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Tue, 5 May 2020 17:15:16 +0300
Message-ID: <CAHp75VfQ_ueABUcgUUirQ7kK60CR6vMi1gP-UsdDd+UmsSE4Sw@mail.gmail.com>
Subject: Re: [net-next PATCH v3 4/5] net: phy: Introduce fwnode_get_phy_id()
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
> Extract phy_id from compatible string. This will be used by
> fwnode_mdiobus_register_phy() to create phy device using the
> phy_id.

> +int fwnode_get_phy_id(struct fwnode_handle *fwnode, u32 *phy_id)
> +{
> +       const char *cp;
> +       unsigned int upper, lower;
> +       int ret;
> +
> +       ret = fwnode_property_read_string(fwnode, "compatible", &cp);
> +       if (!ret) {

if (ret)
 return ret;

will help a lot with readability of this.

> +               if (sscanf(cp, "ethernet-phy-id%4x.%4x",
> +                          &upper, &lower) == 2) {

> +                       *phy_id = ((upper & 0xFFFF) << 16) | (lower & 0xFFFF);

How upper can be bigger than 0xfff? Same for lower.

> +                       return 0;
> +               }
> +       }
> +       return -EINVAL;
> +}

-- 
With Best Regards,
Andy Shevchenko
