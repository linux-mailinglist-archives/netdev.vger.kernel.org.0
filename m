Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F23C71B7141
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 11:54:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbgDXJyf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 05:54:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726582AbgDXJyf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 05:54:35 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 802C9C09B045;
        Fri, 24 Apr 2020 02:54:34 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id o185so4413170pgo.3;
        Fri, 24 Apr 2020 02:54:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iVvYIfEqTyiL0cJpR1ziiocvVVbqCRYQEWmIpkQdSo4=;
        b=lNQg7yUM1uHwNZH9rRi6aMycHtL1Wrb5aNMA14RGDMtHDItmAykWFl25jb742vRfhF
         EToY+8xjZ3SGMPWKCWL/d0VBa26J8XWpkzgQ2YkpiobCnlFhsf2wFQJfRWFTEdJIxt+L
         tOALbRk1YJkPUconj59UScO5akAZO43/Rude99MbOaxAFladi7T3HCeVxwu3QVLyjXqW
         wuD6ASN6ByFkw5EXnKYCxq9ZKthzLmzdzmc/1QrG44xetQ7KbXWUL2MiCOgM0eeXCdQ6
         h4gYVDa3Ae5GfEJ5C1n9XwkuAvet6QEQfXGzAbAZ1naPIg45QtWPruZmvjAgTlJestom
         OZwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iVvYIfEqTyiL0cJpR1ziiocvVVbqCRYQEWmIpkQdSo4=;
        b=hp/Kq9Ehb8/xMSAKg0bBwH4kJc2wYYIeSIXxpGLNd35jXzMNEMJCiybiXNNO1XuUAt
         VQwsVdpYdLL7S9xaWeUbYoJuUNIf6oaWqYstvLLdCO021A7wDjDxQGUAOcp2VMSbVNpD
         T8OdXWDZfhBAQwOxk0Jfnh9lehBhaInORwgew2JlSHnVA73gcXCrt9gvg3CLMCzRyZpn
         KPutpCjXOtRjwu9l2Ba9Bd0NWIzc8Q/DOfnafO6rCLELLapGBKWOqZN1H6PjqAIGItGj
         wL7cUL30ZsDfgSvpFM5gwnRts0n+1pnX+SCNMm4uU3excu5bOul6PL7PVJsf8OEVlU6W
         T+yw==
X-Gm-Message-State: AGi0PuZcoUnINnrCvmECFTyuG2QW/4RVYtX1PdBLCDbjf5m1Cnq95puD
        L8P8kSLVObt4eEhY6G/8FrmEuDdWyltN1jpSVMs=
X-Google-Smtp-Source: APiQypLTdtY2h3+c0DJDMGPfzEIOPk2dta0lyKEsWgoM7Y++nWond/ddP3DuM+fDmLggdLnM2ad9czHqSI0wS3/NnOw=
X-Received: by 2002:aa7:8f26:: with SMTP id y6mr8944170pfr.36.1587722073914;
 Fri, 24 Apr 2020 02:54:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200424031617.24033-1-calvin.johnson@oss.nxp.com>
 <20200424031617.24033-2-calvin.johnson@oss.nxp.com> <b583f6fb-e6fe-3320-41c6-e019a4e10388@gmail.com>
 <20200424092651.GA4501@lsv03152.swis.in-blr01.nxp.com>
In-Reply-To: <20200424092651.GA4501@lsv03152.swis.in-blr01.nxp.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Fri, 24 Apr 2020 12:54:26 +0300
Message-ID: <CAHp75VdxFjzs2uj7ZYNmwt9DC386gMNahi3A_MYV4wE3kbtq=g@mail.gmail.com>
Subject: Re: [net-next PATCH v1 1/2] device property: Introduce fwnode_phy_find_device()
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, linux.cj@gmail.com,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        Pankaj Bansal <pankaj.bansal@nxp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, Varun Sethi <V.Sethi@nxp.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Makarand Pawagi <makarand.pawagi@nxp.com>,
        "Rajesh V . Bikkina" <rajesh.bikkina@nxp.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 24, 2020 at 12:27 PM Calvin Johnson
<calvin.johnson@oss.nxp.com> wrote:
> On Thu, Apr 23, 2020 at 08:45:03PM -0700, Florian Fainelli wrote:
> > On 4/23/2020 8:16 PM, Calvin Johnson wrote:

> > If you forget to update the MAINTAINERS file, or do not place this code
> > under drivers/net/phy/* or drivers/of/of_mdio.c then this is going to
> > completely escape the sight of the PHYLIB/PHYLINK maintainers...
>
> Did you mean the following change?

I don't think this is an appreciated option.
Second one was to locate this code under drivers/net, which may be
better. And perhaps other not basic (to the properties) stuff should
be also moved to respective subsystems.

-- 
With Best Regards,
Andy Shevchenko
