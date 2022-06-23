Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09EFD558B93
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 01:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230234AbiFWXOA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 19:14:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbiFWXN7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 19:13:59 -0400
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D07D454FBC
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 16:13:57 -0700 (PDT)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-317741c86fdso9030597b3.2
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 16:13:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=q4rQdhnWLSWo14RnjtXWJNi2g5jmxMvqoaFVDnX2E5Q=;
        b=cmIBzn0GUySKMskyqJKDVgDVN/8vHWzNfjJ+BREUrbPM7OiFQy/ATX7aLRhZ8MANv1
         DeCxgq5hoHNltsRta4mLMJ5CVkKh4hfP6LVOwSV/7ivHGPCIqDCrcZofNe4RU/N40PFA
         084lsyuhYt6X1dulYD/2vojMLUtCUUuNjPCYYrjag+23v4QnctG6vuufvkN8P84KHpsZ
         1smdglM09EjAq6n/VWxttVgTknSAAilZfUXcBMOYhadXU9RaXikEWNdJ2rEO52JTzByf
         AZX6K773hR1jhsQBFWv6Jdd8yXumqgqHK9g5FERmM19ObNBe6obaPeOOW1hv8UESqekO
         6hJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=q4rQdhnWLSWo14RnjtXWJNi2g5jmxMvqoaFVDnX2E5Q=;
        b=bwPSuTMbZQGb31mn/kxVAYgOyvz1rf9oqBeyKTJrawarVE2oPa7EmN/Kn3Ka0eOY8l
         o0chPOECNTuow30hKjYSG01rp5ldzdMywqzmLdRMloQLtyeaf0n4H6xuAGR+4FCQu0sD
         s56fc7kvL3VdcbL8hIZQOKcBtrJvAALcywdsM6MPN5VYW3GnG0GRTaUoTaRDXQqThjQM
         3PkOtVio9ZkY9h1tnFL+UjiMJRaJPCxhHZ15fOfkaK5rBqQwle1J6Z3+DouSjjotB5cH
         nLgCvwSXz6SwXxX5iaVxfV1WuCxIqKGZrSUxB3KF898mLhxBuFtEPmtcevEhCVkQ5t0T
         GnZg==
X-Gm-Message-State: AJIora+ItgamyCxxmB72HePGPMoifHMW10h7I62U0Wm4O3MvKwNocT35
        ndydlIdAbvX6EHB+j2o1ME+X1846NQ6dT0m4F53q+w==
X-Google-Smtp-Source: AGRyM1tmOAvKbstD4mNEDSzf5ARhyGW/aO0E7tWlKoUjb1ZKcoDOPfJmrPrA9mjxTsX3Z0whnYeMEFOcEVoRWtE94Ys=
X-Received: by 2002:a0d:dfd5:0:b0:317:f0d4:505b with SMTP id
 i204-20020a0ddfd5000000b00317f0d4505bmr12968633ywe.518.1656026036778; Thu, 23
 Jun 2022 16:13:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220623080344.783549-1-saravanak@google.com> <20220623080344.783549-3-saravanak@google.com>
 <20220623100421.GY1615@pengutronix.de> <CAGETcx_eVkYtVX9=TOKnhpP2_ZpJwRDoBye3i7ND2u5Q-eQfPg@mail.gmail.com>
 <20220623203716.GA1615@pengutronix.de>
In-Reply-To: <20220623203716.GA1615@pengutronix.de>
From:   Saravana Kannan <saravanak@google.com>
Date:   Thu, 23 Jun 2022 16:13:20 -0700
Message-ID: <CAGETcx-mCu+M0HhhX+bTNpzEswviJj2U8eCefLv3ezr29Nd+wA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] of: base: Avoid console probe delay when fw_devlink.strict=1
To:     sascha hauer <sha@pengutronix.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
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

On Thu, Jun 23, 2022 at 1:37 PM sascha hauer <sha@pengutronix.de> wrote:
>
> On Thu, Jun 23, 2022 at 10:26:46AM -0700, Saravana Kannan wrote:
> > On Thu, Jun 23, 2022 at 3:05 AM sascha hauer <sha@pengutronix.de> wrote:
> > >
> > > On Thu, Jun 23, 2022 at 01:03:43AM -0700, Saravana Kannan wrote:
> > > > Commit 71066545b48e ("driver core: Set fw_devlink.strict=1 by default")
> > > > enabled iommus and dmas dependency enforcement by default. On some
> > > > systems, this caused the console device's probe to get delayed until the
> > > > deferred_probe_timeout expires.
> > > >
> > > > We need consoles to work as soon as possible, so mark the console device
> > > > node with FWNODE_FLAG_BEST_EFFORT so that fw_delink knows not to delay
> > > > the probe of the console device for suppliers without drivers. The
> > > > driver can then make the decision on where it can probe without those
> > > > suppliers or defer its probe.
> > > >
> > > > Fixes: 71066545b48e ("driver core: Set fw_devlink.strict=1 by default")
> > > > Reported-by: Sascha Hauer <sha@pengutronix.de>
> > > > Reported-by: Peng Fan <peng.fan@nxp.com>
> > > > Signed-off-by: Saravana Kannan <saravanak@google.com>
> > > > Tested-by: Peng Fan <peng.fan@nxp.com>
> > > > ---
> > > >  drivers/of/base.c | 2 ++
> > > >  1 file changed, 2 insertions(+)
> > > >
> > > > diff --git a/drivers/of/base.c b/drivers/of/base.c
> > > > index d4f98c8469ed..a19cd0c73644 100644
> > > > --- a/drivers/of/base.c
> > > > +++ b/drivers/of/base.c
> > > > @@ -1919,6 +1919,8 @@ void of_alias_scan(void * (*dt_alloc)(u64 size, u64 align))
> > > >                       of_property_read_string(of_aliases, "stdout", &name);
> > > >               if (name)
> > > >                       of_stdout = of_find_node_opts_by_path(name, &of_stdout_options);
> > > > +             if (of_stdout)
> > > > +                     of_stdout->fwnode.flags |= FWNODE_FLAG_BEST_EFFORT;
> > >
> > > The device given in the stdout-path property doesn't necessarily have to
> > > be consistent with the console= parameter. The former is usually
> > > statically set in the device trees contained in the kernel while the
> > > latter is dynamically set by the bootloader. So if you change the
> > > console uart in the bootloader then you'll still run into this trap.
> > >
> > > It's problematic to consult only the device tree for dependencies. I
> > > found several examples of drivers in the tree for which dma support
> > > is optional. They use it if they can, but continue without it when
> > > not available. "hwlock" is another property which consider several
> > > drivers as optional. Also consider SoCs in early upstreaming phases
> > > when the device tree is merged with "dmas" or "hwlock" properties,
> > > but the corresponding drivers are not yet upstreamed. It's not nice
> > > to defer probing of all these devices for a long time.
> > >
> > > I wonder if it wouldn't be a better approach to just probe all devices
> > > and record the device(node) they are waiting on. Then you know that you
> > > don't need to probe them again until the device they are waiting for
> > > is available.
> >
> > That actually breaks things in a worse sense. There are cases where
> > the consumer driver is built in and the optional supplier driver is
> > loaded at boot. Without fw_devlink and the deferred probe timeout, we
> > end up probing the consumer with limited functionality. With the
> > current setup, sure we delay some probes a bit but at least everything
> > works with the right functionality. And you can reduce or remove the
> > delay if you want to optimize it.
>
> We have optional and mandatory resources. In this situation a driver has
> to decide what to do. Either it continues with limited resources or it
> defers probing. Some drivers try to allocate the optional resources at
> open time so that they are able to use them once they are available.  We
> could even think of an asynchronous callback into a driver when a
> resource becomes available. Whether we put this decision what is
> optional or not into the driver or in the framework doesn't make a
> difference to the problem, it is still the same: When a resource is not
> yet available we have no idea if and when it becomes available, if it's
> worth waiting for it or not.
>
> The difference is that with my proposal (which isn't actually mine but
> from my collegue Lucas) a driver can decide very fine grained how it
> wants to deal with the situation. With fw_devlink we try to put this
> intelligence into the framework and it seems there are quite some quirks
> necessary to get that running for everyone.

That's one possible solution, but for that to work, all drivers with
optional suppliers would need to be changed to take advantage of this
callback to work correctly when the optional suppliers become
available. We could add this callback, but it would be a long time
before the callback handles all/most cases of optional suppliers.

One of the goals of fw_devlink is so that people can stop having to
play initcall chicken where they try to tune their initcall levels wrt
to the chain of suppliers to avoid probe failures or minimize deferred
probed. Technically with deferred probes and proper error handling,
people shouldn't have to play initcall chicken, but we still have a
lot of those. Adding this callback is just going to make writing
drivers even harder. And there are tons of drivers that can't do
proper clean up and some drivers can't even be unbound once they are
bound.

Also, if I'm not mistaken (I could be), stuff like pinctrl is setup
before we even get to driver->probe(). So when the pinctrl supplier
becomes available, the driver would need to unbind fully and rebind.
What if there's a current user of the device?

> Anyway, we have fw_devlink now and actually I think the dependency graph
> that we have with fw_devlink is quite nice to resolve the natural probe
> order. But why do we have to put an extra penalty on drivers whose
> resources are not yet available?  Probe devices with complete resources
> as long as you find them, execute more initcalls as long as there are
> any, but when there are no more left, you could start probing devices
> with incomplete resources, why wait for another ten seconds?

The timeout is defining how long after the most recent module load
that we give up waiting for more modules to be loaded. On a Pixel 6
with serial console output, the timeout of 5 seconds would work
because the worst case gap between two module loads is ~2.8 seconds
(so 5 seconds for some margin). The default is this high to
accommodate slow storage devices where mounting all the filesystems
can take time (think HDD or network FS). The default is configured for
correctness so that we can maximize functionality across systems, but
people can optimize for the specific case.

> For me it's no problem when the UART probes late, we have earlycon which
> can be used to debug problems that arise before the UART probes, but
> what nags is the ten seconds delay. zero would be a much saner value for
> me.

Having said all that, I empathize with your annoyance at the delay.
Open to ideas of making this better without making the default
functionality worse.

-Saravana
