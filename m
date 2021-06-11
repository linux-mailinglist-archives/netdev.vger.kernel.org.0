Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 915E63A4142
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 13:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231584AbhFKLcs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 07:32:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231308AbhFKLcr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 07:32:47 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2373AC061574;
        Fri, 11 Jun 2021 04:30:36 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id 22-20020a17090a0c16b0290164a5354ad0so5686027pjs.2;
        Fri, 11 Jun 2021 04:30:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dn++4wjWdJC82IkTsNckyaTN9xTcN2xZoxyfKEnJ3TE=;
        b=ousaMN/9RekV34CJcgSdOFUSl4Mj065OfpbosLlqqw80P1gjIvtXU9aK8f7zm1+HSg
         tmOeKLhpN/e4kbcCmx+DbEywHyQy8o7DaNWnNxyq28eMJWe/QHVrMgBGQo+uDDwLxqW4
         bdZybLwr7oP1lbqXCrg4q0tOBD/hteVcRGyYFTuUH891OLV3OBxNmqVWV5vgrkZFnTco
         3jXUZ9npMAHdiRZ1cZZ+7N30xhIP0pS1Wf1UAgs2mza9R2eEwcJ4pmOBhfZA1E6isxWO
         Urnn7WpMw/4jOX5fluIMSUoAzY6rB6iUhwn7gxib83ZAQxTsYrAPo6ZW9Hf9hld1f1RE
         L8xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dn++4wjWdJC82IkTsNckyaTN9xTcN2xZoxyfKEnJ3TE=;
        b=lI/8fkdwVnwOkBMoval0XbUAhfDXzjGJvPpvYqSB+TqqZfF9vX9vuuiEg0Dv0QaJFd
         p7Q/gzqb9mnJgn3NjHvASX4eg17C8hr06la+3C2LFyO1yvHrzGTvvEyoRVOkHZNItEA5
         vWVX/NLinbHrslJlrDl6bJtKr5pVXmCljgsLQhzEMHNQYTOSX/s8kq9KiDS4bQpY57Q7
         3zf94wUiMltNKtl2/NcHxPeuB35/5n9XsWU+tfUCr4yOe9KQaq3k+LF2cY+LAW+kgMNg
         4ycpO5TPspukhWVdH66hLcIXD7yi/XD/F/G5GMnHQctmEByqMfHYZkS/FvvfStxbeaYW
         DRGw==
X-Gm-Message-State: AOAM530kGwflqudEki1sxScqO1z70oDqx9QmzYGbqhE9ZAOLgIFOf0w4
        1kfO2U+9Q0FPQtoDFzu/X28UssZRTjL/3fc/YvQ=
X-Google-Smtp-Source: ABdhPJxnOSUwZ2YOaD+l9LdK1oYAgf9X8VjEyd59c44R0/Ux6r6yZ0bbiyg+R+auvZ424AtZlhCJY05GYqCmm8WJpLI=
X-Received: by 2002:a17:90a:17ad:: with SMTP id q42mr8831750pja.181.1623411035640;
 Fri, 11 Jun 2021 04:30:35 -0700 (PDT)
MIME-Version: 1.0
References: <20210611105401.270673-1-ciorneiioana@gmail.com>
 <20210611105401.270673-5-ciorneiioana@gmail.com> <CAHp75VdmqLnESxf5R8Yvn02QDv=_WmkWEcRZMjxUjLg+KDcyQg@mail.gmail.com>
In-Reply-To: <CAHp75VdmqLnESxf5R8Yvn02QDv=_WmkWEcRZMjxUjLg+KDcyQg@mail.gmail.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Fri, 11 Jun 2021 14:30:19 +0300
Message-ID: <CAHp75Ve6X5j31ZO4_Rzd5uTgVk2VOGjos4M4m=GxwnRHw2gbHQ@mail.gmail.com>
Subject: Re: [PATCH net-next v9 04/15] of: mdio: Refactor of_phy_find_device()
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

On Fri, Jun 11, 2021 at 2:28 PM Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
> On Fri, Jun 11, 2021 at 1:54 PM Ioana Ciornei <ciorneiioana@gmail.com> wrote:
> >
> > From: Calvin Johnson <calvin.johnson@oss.nxp.com>
> >
> > Refactor of_phy_find_device() to use fwnode_phy_find_device().
>
> I see that there are many users of this, but I think eventually we
> should kill of_phy_find_device() completely.

Looking into other examples of such I think this series may not touch
them right now, but clearly state that it's the plan in the future to
kill this kind of OF APIs that call fwnode underneath.


-- 
With Best Regards,
Andy Shevchenko
