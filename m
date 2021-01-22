Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AA14300B81
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 19:40:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728373AbhAVSjT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 13:39:19 -0500
Received: from mail-oi1-f169.google.com ([209.85.167.169]:33649 "EHLO
        mail-oi1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729481AbhAVSNN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 13:13:13 -0500
Received: by mail-oi1-f169.google.com with SMTP id j25so1531962oii.0;
        Fri, 22 Jan 2021 10:12:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2w1MGZ9mEKOeW8Sp4+SROoauRQHqq4ffMB/bBOfyNEw=;
        b=ORlX412qKrgV4JxTUpFT7Q3WyB+zYa+fLa0Bs9LScPIOK5sjcx1NWchZeaWv9nSvux
         PtrkdwDPKtWms7X7u36XxQTNSFj7xOjO419EFlN0QKlUbyPd+ttPaSMl3iSmGNSP0n0u
         kbHkMjbX/H+tImVw5oTJYABK7QGUPkIoNJJDpXTIn1plWzk555DzsVKJ6ZoJ8AiXA6D8
         nC1s93Fvjdi6udPfV/Ev/AP7J4cExVTcxhDC2xn+WJ9WVoMSDWXyNQUJIfSzqAKXuKv2
         BhfwH6uNUWh1vQ3a0Em+62V5suvPKyFZ/Iv+UWheVm46k/H4QG1TwQOvUB21iU6HpkDD
         nBpg==
X-Gm-Message-State: AOAM532PKjiRrHDdw9Lk9DzL2J0ebAuh7HxecvV+yQgLDQLtHoHhe6Fm
        2zP6hDDyjxI9zQosRde3wPra9dqkxYTfYtWv1bQ=
X-Google-Smtp-Source: ABdhPJy91RVudidWYxELqnygUSA2p+C95kGYOGIrI1wvFq4TZMb7X0SCn3XrnZILhPOJoQqW++x7/SLKAYPKkqA3EOQ=
X-Received: by 2002:aca:308a:: with SMTP id w132mr3993915oiw.69.1611339127524;
 Fri, 22 Jan 2021 10:12:07 -0800 (PST)
MIME-Version: 1.0
References: <20210122154300.7628-1-calvin.johnson@oss.nxp.com>
 <20210122154300.7628-10-calvin.johnson@oss.nxp.com> <CAJZ5v0gzdi08fwf0e3NyP1WzuSBk47J5OT5DW_aaUHn_9icfag@mail.gmail.com>
 <YAsHqu/nW3zU/JgO@smile.fi.intel.com>
In-Reply-To: <YAsHqu/nW3zU/JgO@smile.fi.intel.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Fri, 22 Jan 2021 19:11:56 +0100
Message-ID: <CAJZ5v0izwiuD+gRmbw=i=DojDMwqOevDQwXArcmq4WyPVrEDfQ@mail.gmail.com>
Subject: Re: [net-next PATCH v4 09/15] device property: Introduce fwnode_get_id()
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
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
        Jon <jon@solid-run.com>, Saravana Kannan <saravanak@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        "linux.cj" <linux.cj@gmail.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 22, 2021 at 6:12 PM Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
>
> On Fri, Jan 22, 2021 at 05:40:41PM +0100, Rafael J. Wysocki wrote:
> > On Fri, Jan 22, 2021 at 4:46 PM Calvin Johnson
> > <calvin.johnson@oss.nxp.com> wrote:
> > >
> > > Using fwnode_get_id(), get the reg property value for DT node
> > > or get the _ADR object value for ACPI node.
> >
> > So I'm not really sure if this is going to be generically useful.
> >
> > First of all, the meaning of the _ADR return value is specific to a
> > given bus type (e.g. the PCI encoding of it is different from the I2C
> > encoding of it) and it just happens to be matching the definition of
> > the "reg" property for this particular binding.
>
> > IOW, not everyone may expect the "reg" property and the _ADR return
> > value to have the same encoding and belong to the same set of values,
>
> I have counted three or even four attempts to open code exact this scenario
> in the past couple of years. And I have no idea where to put a common base for
> them so they will not duplicate this in each case.

In that case it makes sense to have it in the core, but calling the
_ADR return value an "id" generically is a stretch to put it lightly.

It may be better to call the function something like
fwnode_get_local_bus_id() end explain in the kerneldoc comment that
the return value provides a way to distinguish the given device from
the other devices on the same bus segment.

Otherwise it may cause people to expect that the "reg" property and
_ADR are generally equivalent, which is not the case AFAICS.

At least the kerneldoc should say something like "use only if it is
known for a fact that the _ADR return value can be treated as a
fallback replacement for the "reg" property that is missing in the
given use case".

> > so maybe put this function somewhere closer to the code that's going
> > to use it, because it seems to be kind of specific to this particular
> > use case?
