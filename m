Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAB473A3E68
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 10:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231308AbhFKI7v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 04:59:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231161AbhFKI7u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 04:59:50 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36889C061574;
        Fri, 11 Jun 2021 01:57:36 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id k7so5329474pjf.5;
        Fri, 11 Jun 2021 01:57:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ouekwhno07itCig8YCgajxgS9RkFe/Y+2BrTY237h+s=;
        b=VgTtoPPKM3igTzT5SIAvAHNZZBTUBbosJcxArByn42tReSuhuRZNoEutO9z0lVMfQl
         NoLDgaECGiYfocJIx0zZsaNFDWM4LVr32+oXw9JMsrplqTRxhorawwhdAdLelq5v37Bj
         R2S+D0JODPC5fkTsa91Gi9BZCw+2PsaMAIY46ygvQhaWYUIqmDEV+sOG7TSymGaFtHg0
         nbNEfd2l0zsw0Al7i0NX8xJ1kAC7uqwKwi8QCe7cj4K8UYXNdnBPIRJEucvFEkAy7IJc
         86oe5fTFeTsHHNp/NSBP3ni2JddqIDDHTHtcQ9d3zTLsovkTbBx1GA5nhCBrCYn20xD5
         8L+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ouekwhno07itCig8YCgajxgS9RkFe/Y+2BrTY237h+s=;
        b=MImVY6GLB6B09i2bxRTgkPG5fxBCyIIT3kn+QDKu3L4JshrZK0CmdojV6ziGL9xy1s
         6lramuQYNCvUCH1Y43+Gm33pVuleYWhyKV26xBom2eqtv9xGOWpuu4kkp7pVxp9gfEuW
         hTh3Cae2/WvhIqj84+kF8bpXkzJOgV04uE29zqiUS9ndPpRjdemGTzlyqMBE4qX0jkm0
         qpGnpC+YPviN8ZMoNu5uproCToN7lZw5OfqPRJyfIx7SuzA8oqmXG+Z3nY/LzhTu8QwY
         QdjYLVgjLKswkOfAyjP3/PDg1ez/y7cZoXm8F1adOEIVEYtBYgUypGzWS2+Q5IJYmalE
         lQLA==
X-Gm-Message-State: AOAM531bKaDitK2FXTRtImFthboV7Po5Nt57A7Kl0ICuyNzfc9J/hiDT
        +ae643I2ciCWtMfPgB/u6UA6iyhPN2y7IqWyz+8=
X-Google-Smtp-Source: ABdhPJyXN4rhndd5UsCHJJUELDHbwDk5Xg+Nv9b19zHCwlCngN67bB+XYCPMx0lCSA3EVZp+1pmBNWC+uFSdeRin1hI=
X-Received: by 2002:a17:902:c784:b029:104:9a21:262a with SMTP id
 w4-20020a170902c784b02901049a21262amr3068721pla.21.1623401855633; Fri, 11 Jun
 2021 01:57:35 -0700 (PDT)
MIME-Version: 1.0
References: <20210610163917.4138412-1-ciorneiioana@gmail.com> <20210610163917.4138412-13-ciorneiioana@gmail.com>
In-Reply-To: <20210610163917.4138412-13-ciorneiioana@gmail.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Fri, 11 Jun 2021 11:57:19 +0300
Message-ID: <CAHp75Vcch1aO97Dg86Eo9bdrdwSfPE+p5iFJLk8Y5jx13q8Cpg@mail.gmail.com>
Subject: Re: [PATCH net-next v8 12/15] net/fsl: Use [acpi|of]_mdiobus_register
To:     Ioana Ciornei <ciorneiioana@gmail.com>
Cc:     Grant Likely <grant.likely@arm.com>,
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
        Calvin Johnson <calvin.johnson@nxp.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux.cj" <linux.cj@gmail.com>, netdev <netdev@vger.kernel.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Len Brown <lenb@kernel.org>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 10, 2021 at 7:40 PM Ioana Ciornei <ciorneiioana@gmail.com> wrote:
>
> From: Calvin Johnson <calvin.johnson@oss.nxp.com>
>
> Depending on the device node type, call the specific OF or ACPI
> mdiobus_register function.
>
> Note: For both ACPI and DT cases, endianness of MDIO controller

controllers

> need to be specified using "little-endian" property.

using the

...

> Changes in v8:
> - Directly call the OF or ACPI variants of registering the MDIO bus.
>   This is needed because the fwnode_mdio.c module should only implement
>   features which can be achieved without going back to the OF/ACPI
>   variants. Without this restrictions we directly end up in a dependency
>   cycle: of_mdio -> fwnode_mdio -> of_mdio.

Shouldn't be simple fwnode_mdio.h.
The idea of fwnode APIs that they provide a common ground for all
resource providers.

> - Changed the commit title since the fwnode_mdiobus_register() is no
>   longer available
>
> Changes in v7:
> - Include fwnode_mdio.h

> - Alphabetically sort header inclusions

I suppose this should be a separate change.


-- 
With Best Regards,
Andy Shevchenko
