Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD867300E84
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 22:07:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729094AbhAVVHK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 16:07:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729342AbhAVVGF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 16:06:05 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5346C06174A;
        Fri, 22 Jan 2021 13:05:25 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id p18so4624029pgm.11;
        Fri, 22 Jan 2021 13:05:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0+FVmVKDe2MoonBQPJh+WFy/vq4SQqjBfSX0+brJygs=;
        b=ednwYABfe8sA98UvTPMN9T40IOylLOQQZEvo1t931jl8Ag18tNevC8GGNYrtw8P+9d
         TW2wcMWVJc9Q4WQHAjeHxIbmqW02Pxi6Wc9ryNsYVspnG6U6eSVFqN5IILNNHuvAY9vx
         L/rPzb1DgrIgL8kmD2h14jfMiwPav2cajp2KJ68khkwDTivvY+6EVoDhXl5Tl4UjQcQw
         Fd2zpXr3UWCsJQGRht9xpZK20E2TTWZc04Qf/8D7oL/Cc7KAXI/EmVnteeFUB3um/Hf6
         NpSjApWZ6kc5x47GfYUOaelT7E5L4ZOadaipihqU+juQQ01Lv7pmwScMpx0CfXg86hcL
         jmWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0+FVmVKDe2MoonBQPJh+WFy/vq4SQqjBfSX0+brJygs=;
        b=JLMcvnCMx7WOANKVJaj6L814r3UF9YuSp0DtaIJ+ozDv4PuY6SlSbiCnWLMOJ643Vd
         HQ1qV1AH1ac8awgyTNIVdjq0aFYpoWXX/TWQJMDv3UDfaEWbzwlmeUsnz604W2ZMCjLm
         QSLXsjt1ME1zycGa/1w42MSpb4NjNsunNVpHyoM0g20z6rOZewWqRIbWETT3IcBQgIm1
         0nAilKDz6zI4XNliTZsTPIokOQIgzAkGSYvKqswH7LfQcMhGrELvvVzPV9SNHs5oH0fs
         NgoA9K+glEh7gufctsfl8tBxJJj9cBjgfLQIcgqJimiItkHf3lmgy6pbfS3U35KST+NT
         wOKQ==
X-Gm-Message-State: AOAM532HA5X7t9aTe7CyfVYd3Hqv7oDz96S4+I6v1oBeVtfttcDdZ/ad
        kdK99x370tuoyCtkAtDceBfmQA9z1ESpSV71Pso=
X-Google-Smtp-Source: ABdhPJzAsHblzv49GgM92BS0ukgnMn6tLTMJgDyNNPYoequtUf0RwRSasV4WoH7bir1rnRhafke74/cg6OMYDr6bH90=
X-Received: by 2002:a62:5a86:0:b029:1ae:6b45:b6a9 with SMTP id
 o128-20020a625a860000b02901ae6b45b6a9mr6566386pfb.7.1611349525011; Fri, 22
 Jan 2021 13:05:25 -0800 (PST)
MIME-Version: 1.0
References: <20210112134054.342-1-calvin.johnson@oss.nxp.com>
 <20210112134054.342-10-calvin.johnson@oss.nxp.com> <CAGETcx-7JVz=QLCMWicHqoagWYjeBXdFJmSv1v6MQhtPt2RS=Q@mail.gmail.com>
 <20210112180343.GI4077@smile.fi.intel.com> <CAJZ5v0iW0jJUcXtiQtLOakkSejZCJD=hTFLL4mvoAN3ZTB+1Tw@mail.gmail.com>
 <CAHp75VcJS10KMA5amUc36PFgj0FLddj1fXD4dUtuAchrVhhzPg@mail.gmail.com>
 <CAJZ5v0ga5RqwFzbBqSChJ7=gBBM-7dWNQPz6bqvqsNAkWZJ=vQ@mail.gmail.com>
 <CAGETcx8DP8J53ntxX2VCSnbMfq1qki7gD-md+NC_jVfOkTam3g@mail.gmail.com>
 <CAJZ5v0gUCUxJX9sGJiZ+zTVYrc3rjuUO2B2fx+O6PewbG7F8aw@mail.gmail.com> <CAGETcx-904Cr11nVW6PC=OqWnwM-ZC-DdEUa8+7JmhsH3UOqHw@mail.gmail.com>
In-Reply-To: <CAGETcx-904Cr11nVW6PC=OqWnwM-ZC-DdEUa8+7JmhsH3UOqHw@mail.gmail.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Fri, 22 Jan 2021 23:06:14 +0200
Message-ID: <CAHp75VcVNj0+KZiLEsPgfz=fZoLr9g1=6ikeUo7FZ1rd4FKpWQ@mail.gmail.com>
Subject: Re: [net-next PATCH v3 09/15] device property: Introduce fwnode_get_id()
To:     Saravana Kannan <saravanak@google.com>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
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
        Jon <jon@solid-run.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "linux.cj" <linux.cj@gmail.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Randy Dunlap <rdunlap@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 22, 2021 at 10:59 PM Saravana Kannan <saravanak@google.com> wrote:
> On Fri, Jan 22, 2021 at 8:34 AM Rafael J. Wysocki <rafael@kernel.org> wrote:
> > On Wed, Jan 20, 2021 at 9:01 PM Saravana Kannan <saravanak@google.com> wrote:
> > > On Wed, Jan 20, 2021 at 11:15 AM Rafael J. Wysocki <rafael@kernel.org> wrote:


> > > I'd rather this new function be an ops instead of a bunch of #ifdef or
> > > if (acpi) checks. Thoughts?
> >
> > Well, it looks more like a helper function than like an op and I'm not
> > even sure how many potential users of it will expect that _ADR should
> > be evaluated in the absence of the "reg" property.
> >
> > It's just that the "reg" property happens to be kind of an _ADR
> > equivalent in this particular binding AFAICS.
>
> I agree it is not clear how useful this helper function is going to be.
>
> But in general, to me, any time the wrapper/helper functions in
> drivers/base/property.c need to do something like this:
>
> if (ACPI)
>    ACPI specific code
> if (OF)
>    OF specific code
>
> I think the code should be pushed to the fwnode ops. That's one of the
> main point of fwnode. So that firmware specific stuff is done by
> firmware specific code. Also, when adding support for new firmware,
> it's pretty clear what support the firmware needs to implement.
> Instead of having to go fix up a bunch of code all over the place.

Wishful thinking.
In the very case of GPIO it's related to framework using headers local
to framework. Are you suggesting to open its guts to the entire wild
world?
I don't think it's a good idea. You see, here we have different
layering POD types, which are natural and quite low level that ops
suits best for them and quite different resource types like GPIO. And
the latter is closer to certain framework rather than to POD handling
cases.

> So fwnode_ops->get_id() would be the OP ACPI and OF would implement.
> And then we can have a wrapper in drivers/base/property.c.


-- 
With Best Regards,
Andy Shevchenko
