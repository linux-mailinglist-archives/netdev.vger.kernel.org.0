Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06CEF53E904
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 19:08:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233746AbiFFKTx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 06:19:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233619AbiFFKTv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 06:19:51 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FC7E1760CE;
        Mon,  6 Jun 2022 03:19:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654510789; x=1686046789;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=XkXW18DsxASgWy3W6vVrSfD8C2RLZ7Hhaeol5XaMazA=;
  b=WBTOrMNmN1vs8gNXRaRzgWQ6jzWK4S2vJSIuh5wyZ1UMoeKqg6U0IrZt
   OXJS1NBUZvkaOCB0grovQG8H8KuU/oUenEd04cmtyEyMkay2gGLR2aNNI
   VgLX12SmpjJ14YAY6dKZiKTxlU0EK0aFkoKzz0JhW5Gwn5I06vQ/i0IYK
   X74V59BQ3g1fXX/zE5RwatLw0LhbOeUuvihpXHtpcqBjcTx6vsGDytGKQ
   Dudocxg+x3OC9nrGPI+D6QIfxFAc1IWDLIZShut/2gp4sVZz4DI4pmd5X
   16YgKuatvQXHtN8XCXdeE6xaBT4uAlzd/fD9S10xpduaKGsPv1aUj1Bp7
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10369"; a="276593154"
X-IronPort-AV: E=Sophos;i="5.91,280,1647327600"; 
   d="scan'208";a="276593154"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2022 03:19:48 -0700
X-IronPort-AV: E=Sophos;i="5.91,280,1647327600"; 
   d="scan'208";a="647476480"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2022 03:19:40 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1ny9nZ-000UYV-54;
        Mon, 06 Jun 2022 13:17:25 +0300
Date:   Mon, 6 Jun 2022 13:17:24 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Saravana Kannan <saravanak@google.com>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Kevin Hilman <khilman@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Daniel Scally <djrscally@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh@kernel.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        John Stultz <jstultz@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Android Kernel Team <kernel-team@android.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: [RFC PATCH v1 2/9] pinctrl: devicetree: Delete usage of
 driver_deferred_probe_check_state()
Message-ID: <Yp3UNAW5Zv+RjabA@smile.fi.intel.com>
References: <20220526081550.1089805-1-saravanak@google.com>
 <20220526081550.1089805-3-saravanak@google.com>
 <CAMuHMdV4Uzfg8aBY=tKnRcig=Npebd158J7UK3zg5_DtHwAR5w@mail.gmail.com>
 <CAGETcx-=kAJp282OvG4yd830fhQowN7-yXifERqiHRi2w0bGFw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGETcx-=kAJp282OvG4yd830fhQowN7-yXifERqiHRi2w0bGFw@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 04, 2022 at 08:41:01PM -0700, Saravana Kannan wrote:
> On Mon, May 30, 2022 at 2:22 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > On Thu, May 26, 2022 at 10:16 AM Saravana Kannan <saravanak@google.com> wrote:
> > > Now that fw_devlink=on by default and fw_devlink supports
> > > "pinctrl-[0-8]" property, the execution will never get to the point
> >
> > 0-9?
> >
> > oh, it's really 0-8:
> >
> >     drivers/of/property.c:DEFINE_SIMPLE_PROP(pinctrl0, "pinctrl-0", NULL)
> >     drivers/of/property.c:DEFINE_SIMPLE_PROP(pinctrl1, "pinctrl-1", NULL)
> >     drivers/of/property.c:DEFINE_SIMPLE_PROP(pinctrl2, "pinctrl-2", NULL)
> >     drivers/of/property.c:DEFINE_SIMPLE_PROP(pinctrl3, "pinctrl-3", NULL)
> >     drivers/of/property.c:DEFINE_SIMPLE_PROP(pinctrl4, "pinctrl-4", NULL)
> >     drivers/of/property.c:DEFINE_SIMPLE_PROP(pinctrl5, "pinctrl-5", NULL)
> >     drivers/of/property.c:DEFINE_SIMPLE_PROP(pinctrl6, "pinctrl-6", NULL)
> >     drivers/of/property.c:DEFINE_SIMPLE_PROP(pinctrl7, "pinctrl-7", NULL)
> >     drivers/of/property.c:DEFINE_SIMPLE_PROP(pinctrl8, "pinctrl-8", NULL)
> >
> > Looks fragile, especially since we now have:
> >
> >     arch/arm64/boot/dts/microchip/sparx5_pcb134_board.dtsi:
> > pinctrl-9 = <&i2cmux_9>;
> >     arch/arm64/boot/dts/microchip/sparx5_pcb134_board.dtsi: pinctrl-10
> > = <&i2cmux_10>;
> >     arch/arm64/boot/dts/microchip/sparx5_pcb134_board.dtsi: pinctrl-11
> > = <&i2cmux_11>;
> >     arch/arm64/boot/dts/microchip/sparx5_pcb134_board.dtsi: pinctrl-12
> > = <&i2cmux_pins_i>;
> 
> Checking for pinctrl-* and then verifying if * matches %d would be
> more complicated and probably more expensive compared to listing
> pinctrl-[0-8]. Especially because more than 50% of pinctrl-*
> properties in DT files are NOT pinctrl-%d. So back when we merged
> this, Rob and I agreed [0-8] was good enough for now and we can add
> more if we needed to. Also, when I checked back then, all the
> pinctrl-5+ properties ended up pointing to the same suppliers as the
> lower numbered ones. So it didn't make a difference.
> 
> Ok, I just checked linux-next all the pinctrl-9+ instances and it's
> still true that they all point to the same supplier pointed to by
> pinctrl-[0-8].
> 
> So yeah, it looks fragile, 

And feels fragile, adds into confusion, etc.
Please, consider redesigning this to be more robust.

>	but is not broken and it's more efficient
> than looking for pinctrl-%d or adding more pinctrl-xx entries. So,
> let's fix it if it actually breaks? Not going to oppose a patch if
> anyone wants to make it more complete.
> 
> > > where driver_deferred_probe_check_state() is called before the supplier
> > > has probed successfully or before deferred probe timeout has expired.
> > >
> > > So, delete the call and replace it with -ENODEV.

-- 
With Best Regards,
Andy Shevchenko


