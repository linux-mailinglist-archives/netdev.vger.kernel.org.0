Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3DD9308B6E
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 18:32:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231297AbhA2RWI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 12:22:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbhA2RWF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 12:22:05 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C3CFC061573;
        Fri, 29 Jan 2021 09:21:25 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id w14so6647347pfi.2;
        Fri, 29 Jan 2021 09:21:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mpRwxmNoK4zRm0ABxxngmN28HRh6rDJ6+OLZGZ+9rbg=;
        b=Pd0gq8sBQOE7jDW7l3EY2lggegQw+66lD6svdPfel98i9pRz5ibkDIgCo4m5B5wfaC
         A+jhjOz5zp7kK4L0pZSkU6PxFe855OmDNEVpD4HdSybmDa5CdBiVeD4j2Md41Z4sla/c
         glnbOeaR3Q8cb9ffwmsHFuSmh5PJ0jjeH2OCl01aMC/+OBABG09H71zrmAKQn0YPA+4O
         BIvUfV1J15URctuRg5R6CWy9BpZhJyNFF5sCsFXs7uHFIA0CWTGl+YTocK9aIgFY8Mu2
         KhKtjQeUa3zGsB1WSg6Bt44eSKvY3u5hA7H/s2saX/hmpKkBiD0vTxxwbShdvsB0HyQx
         N58g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mpRwxmNoK4zRm0ABxxngmN28HRh6rDJ6+OLZGZ+9rbg=;
        b=jfXPw1sJcUZBTEGUq36C5fQFw9HYD24YiBIegYeM4JP+Bzh3sVHb3PTW08r1GlLssY
         f74z9J9OhYrESb43MGQ8D6kSw07eKSnXu+lKLSfJ0NcW91Q4zFnqHpRxMIy3LYcf9Pob
         JkEdDUSwyJz05tO/UIGpwrL/9iIfaTIVL4UVeE5kKGQxX4Udx1nQROlPvyE4nV9BeaeX
         G8YcD/VR1G5ung8V68w2JCVResawr2Hy+FVseeDJxBlan+CozxUMdv7eLFGr25qP5tR4
         QBDygUm5MKbLCH7g5xNjeWmCwlkQEDmCBwoxu+G2efg8Jm/qkWduMQpLbkgeWgrnP/CB
         lrWg==
X-Gm-Message-State: AOAM530RK9/T88MX3HouG/1AKJjTHlLbKmxjIyG8Pya+jO6B63CWI1zW
        QOp7cpitF1sC6Dxeag5MwN4Yq9ZejxgaqSwCSIU=
X-Google-Smtp-Source: ABdhPJycqBO07z91rrjUNeFij2ntnYs+9hiTrGVGfrQpNhdNPNyCS+p+/sdPX9vOlqiDKZGUgIZBd3VW5p+NmjUWr50=
X-Received: by 2002:a62:5a86:0:b029:1ae:6b45:b6a9 with SMTP id
 o128-20020a625a860000b02901ae6b45b6a9mr5255939pfb.7.1611940884875; Fri, 29
 Jan 2021 09:21:24 -0800 (PST)
MIME-Version: 1.0
References: <20210122154300.7628-1-calvin.johnson@oss.nxp.com>
 <20210122154300.7628-2-calvin.johnson@oss.nxp.com> <CAJZ5v0iX3uU36448ALA20hiVk968VKTsvgwLrp8ur96MQo3Acw@mail.gmail.com>
 <20210128112729.GA28413@lsv03152.swis.in-blr01.nxp.com> <CAJZ5v0id1i57K_=7eiK0cpOE6UtsKNfR7L7UEBcN1=G+WS+1TA@mail.gmail.com>
 <20210128131205.GA7882@lsv03152.swis.in-blr01.nxp.com> <CAJZ5v0j1XVSyFa1q4RZ=FnSmfR5VOyX+u1uWBWdvTOVBJJ-JXw@mail.gmail.com>
 <20210129064739.GA24267@lsv03152.swis.in-blr01.nxp.com> <CAJZ5v0hrG_-_3LLb956TdFO830DaPv6NdobKetXrc9H+u9bdgw@mail.gmail.com>
 <CAJZ5v0jKuHbK0BSUR6+qU-8zVxrwKrAFRn3ssyWtwvvhQNObQg@mail.gmail.com>
In-Reply-To: <CAJZ5v0jKuHbK0BSUR6+qU-8zVxrwKrAFRn3ssyWtwvvhQNObQg@mail.gmail.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Fri, 29 Jan 2021 19:21:07 +0200
Message-ID: <CAHp75Vcq53+Ogret0d=4ThOM9bqF21FFFLDnW0AQzeKmM62gFA@mail.gmail.com>
Subject: Re: [net-next PATCH v4 01/15] Documentation: ACPI: DSD: Document MDIO PHY
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Grant Likely <grant.likely@arm.com>,
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
        "linux.cj" <linux.cj@gmail.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 29, 2021 at 6:44 PM Rafael J. Wysocki <rafael@kernel.org> wrote:
> On Fri, Jan 29, 2021 at 5:37 PM Rafael J. Wysocki <rafael@kernel.org> wrote:
> > On Fri, Jan 29, 2021 at 7:48 AM Calvin Johnson
> > <calvin.johnson@oss.nxp.com> wrote:

...

> > It would work, but I would introduce a wrapper around the _ADR
> > evaluation, something like:
> >
> > int acpi_get_local_address(acpi_handle handle, u32 *addr)
> > {
> >       unsigned long long adr;
> >       acpi_status status;
> >
> >       status = acpi_evaluate_integer(handle, METHOD_NAME__ADR, NULL, &adr);
> >       if (ACPI_FAILURE(status))
> >                 return -ENODATA;
> >
> >       *addr = (u32)adr;
> >       return 0;
> > }
> >
> > in drivers/acpi/utils.c and add a static inline stub always returning
> > -ENODEV for it for !CONFIG_ACPI.

...

> BTW, you may not need the fwnode_get_local_addr() at all then, just
> evaluate either the "reg" property for OF or acpi_get_local_address()
> for ACPI in the "caller" code directly. A common helper doing this can
> be added later.

Sounds good to me and it will address your concern about different
semantics of reg/_ADR on per driver/subsystem basis.

-- 
With Best Regards,
Andy Shevchenko
