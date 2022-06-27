Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BCB455E29C
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240187AbiF0SVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 14:21:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239947AbiF0SVV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 14:21:21 -0400
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2E8CEE26
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 11:21:19 -0700 (PDT)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-31780ad7535so93872687b3.8
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 11:21:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zAvy14WQSJajEvtEq9Z9V458WL9rypKqsSWZ5e8ff+Q=;
        b=QfczmHRT9/HR8HyazKLbsqrs7cCP2iZKaxG/OXGSPnAc8W5YAiaVA0WqjZ3/6QtXqU
         42K81l24QIf3XynW/JKjRGJ7dmfzwI2FUm73m5CnsNDIqxjEz+NWZjbRqeUpE3CO+oZH
         +WHVevlpyQHs4NMeAMNGbQrzcjZNAN6YiP+T/yfSSMD0p0fn3Nshe7kDoUKHwoSYa4N3
         VnE5Z7u+uJPgYCZdcfgQYEKpStJa5alN/Ge9h9ME6zGeGt1uUwucGuzxD4iyBvikWn6I
         UNKi3EkIpSabWBkxoc2zg+IeRkTOZHzN8h/RLyTzMjG2hCOwCIaltZxdV6oluuLg1E7j
         RMQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zAvy14WQSJajEvtEq9Z9V458WL9rypKqsSWZ5e8ff+Q=;
        b=jbGfgc+3e24RHkAPh9ZxCcCFOZZnbnHdhXIYMg7c4BFcPi+X3kqSYaB74+5Ei7ahLV
         qmLRP2cWD34OSKBl7r6PpC0W9LFh2erfCjU9u/Bj+o7CEQ0R9WnkNmM2W4RBFESppOnD
         aEkBGGinr2QHKJCYAJL/MzicmGXzaF7pvU5ATNe/XlfzQfpYkvAoYN7l/FBhbJgt5lNv
         aTZDmBQ0ZiQsgykHwiDxCPlFnEh6aQhkGDfEFGU7aELx/fOw/2csp+Ftw3rL2tyvIH9/
         lHERNjHt9VU/U9uMgT6zZnUMHaPGiYTQ/gztu0ApuGfvFoIt5T8oqmiX0BdoU6CI81mN
         /E8g==
X-Gm-Message-State: AJIora/qq/88kW1nmnPpm2Vzy5QoFUG+5nTYp46RES5TWiV8nJuzAvHQ
        Cvm/fL1RSpB72CkdL9J3nTB2JEIEfQeeqZtoWDCoFw==
X-Google-Smtp-Source: AGRyM1ut1mmdvIzz+fGssaCHywTk0zdoNUyWRaIm6VKkay06+F6yyhsbCZbfM6hX7GjWG5RLUmdofYrPpF5aZ5NeSXg=
X-Received: by 2002:a0d:eace:0:b0:317:87ac:b3a8 with SMTP id
 t197-20020a0deace000000b0031787acb3a8mr16855244ywe.126.1656354078827; Mon, 27
 Jun 2022 11:21:18 -0700 (PDT)
MIME-Version: 1.0
References: <20220623080344.783549-1-saravanak@google.com> <20220623080344.783549-3-saravanak@google.com>
 <20220623100421.GY1615@pengutronix.de> <20220627175046.GA2644138-robh@kernel.org>
In-Reply-To: <20220627175046.GA2644138-robh@kernel.org>
From:   Saravana Kannan <saravanak@google.com>
Date:   Mon, 27 Jun 2022 11:20:42 -0700
Message-ID: <CAGETcx8YSuq+_tiWwShjZBeHd7+CHwLRdvdT6yb3xfEUD7DB0Q@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] of: base: Avoid console probe delay when fw_devlink.strict=1
To:     Rob Herring <robh@kernel.org>
Cc:     sascha hauer <sha@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Daniel Scally <djrscally@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Len Brown <lenb@kernel.org>, peng fan <peng.fan@nxp.com>,
        kevin hilman <khilman@kernel.org>,
        ulf hansson <ulf.hansson@linaro.org>,
        len brown <len.brown@intel.com>, pavel machek <pavel@ucw.cz>,
        joerg roedel <joro@8bytes.org>, will deacon <will@kernel.org>,
        andrew lunn <andrew@lunn.ch>,
        heiner kallweit <hkallweit1@gmail.com>,
        russell king <linux@armlinux.org.uk>,
        "david s. miller" <davem@davemloft.net>,
        eric dumazet <edumazet@google.com>,
        jakub kicinski <kuba@kernel.org>,
        paolo abeni <pabeni@redhat.com>,
        linus walleij <linus.walleij@linaro.org>,
        hideaki yoshifuji <yoshfuji@linux-ipv6.org>,
        david ahern <dsahern@kernel.org>, kernel-team@android.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        iommu@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-gpio@vger.kernel.org, kernel@pengutronix.de,
        devicetree@vger.kernel.org, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 27, 2022 at 10:50 AM Rob Herring <robh@kernel.org> wrote:
>
> On Thu, Jun 23, 2022 at 12:04:21PM +0200, sascha hauer wrote:
> > On Thu, Jun 23, 2022 at 01:03:43AM -0700, Saravana Kannan wrote:
> > > Commit 71066545b48e ("driver core: Set fw_devlink.strict=1 by default")
> > > enabled iommus and dmas dependency enforcement by default. On some
> > > systems, this caused the console device's probe to get delayed until the
> > > deferred_probe_timeout expires.
> > >
> > > We need consoles to work as soon as possible, so mark the console device
> > > node with FWNODE_FLAG_BEST_EFFORT so that fw_delink knows not to delay
> > > the probe of the console device for suppliers without drivers. The
> > > driver can then make the decision on where it can probe without those
> > > suppliers or defer its probe.
> > >
> > > Fixes: 71066545b48e ("driver core: Set fw_devlink.strict=1 by default")
> > > Reported-by: Sascha Hauer <sha@pengutronix.de>
> > > Reported-by: Peng Fan <peng.fan@nxp.com>
> > > Signed-off-by: Saravana Kannan <saravanak@google.com>
> > > Tested-by: Peng Fan <peng.fan@nxp.com>
> > > ---
> > >  drivers/of/base.c | 2 ++
> > >  1 file changed, 2 insertions(+)
> > >
> > > diff --git a/drivers/of/base.c b/drivers/of/base.c
> > > index d4f98c8469ed..a19cd0c73644 100644
> > > --- a/drivers/of/base.c
> > > +++ b/drivers/of/base.c
> > > @@ -1919,6 +1919,8 @@ void of_alias_scan(void * (*dt_alloc)(u64 size, u64 align))
> > >                     of_property_read_string(of_aliases, "stdout", &name);
> > >             if (name)
> > >                     of_stdout = of_find_node_opts_by_path(name, &of_stdout_options);
> > > +           if (of_stdout)
> > > +                   of_stdout->fwnode.flags |= FWNODE_FLAG_BEST_EFFORT;
> >
> > The device given in the stdout-path property doesn't necessarily have to
> > be consistent with the console= parameter. The former is usually
> > statically set in the device trees contained in the kernel while the
> > latter is dynamically set by the bootloader. So if you change the
> > console uart in the bootloader then you'll still run into this trap.
> >
> > It's problematic to consult only the device tree for dependencies. I
> > found several examples of drivers in the tree for which dma support
> > is optional. They use it if they can, but continue without it when
> > not available. "hwlock" is another property which consider several
> > drivers as optional. Also consider SoCs in early upstreaming phases
> > when the device tree is merged with "dmas" or "hwlock" properties,
> > but the corresponding drivers are not yet upstreamed. It's not nice
> > to defer probing of all these devices for a long time.
> >
> > I wonder if it wouldn't be a better approach to just probe all devices
> > and record the device(node) they are waiting on. Then you know that you
> > don't need to probe them again until the device they are waiting for
> > is available.
>
> Can't we have a driver flag 'I have optional dependencies' that will
> trigger probe without all dependencies and then the driver can defer
> probe if required dependencies are not yet met.

Haha... that's kinda what I'm working on right now. But named
intentionally in a more limited sense of "I can't wait for the
timeout" where fw_devlink will relax and allow the driver to probe
(and have it make the call) once we hit late_initcall(). I'm
explicitly limiting it to "timeout" because we don't want everyone
adding this flag everytime they hit an issue. That'll beat the point
of fw_devlink=on.

Also, setting the flag for a driver to fix one system might break
another system because in the other system the user might want to wait
for the timeout because the supplier drivers would be loaded before
the timeout.

Another option is to restart the timer (if it hasn't expired) when
filesystems get mounted (in addition to the current "when new driver
gets registered). That way, we might be able to drop the timeout from
10s to 5s.

-Saravana
