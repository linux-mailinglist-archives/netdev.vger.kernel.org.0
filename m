Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 114D6341B57
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 12:22:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbhCSLVm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 07:21:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbhCSLVT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 07:21:19 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 208C5C06175F
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 04:21:19 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id jy13so9065448ejc.2
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 04:21:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hjse9me5EBzPjRR/0KqYMdrF6LbwsKwBIB7UB53FeVU=;
        b=x7cZcVlhbYRJtM1CCIcUKRw3fN6CknZ27cbVQzKE/+sARUnDiEX+WfxT7jWWAQB014
         Yk4hjeXlJTdAIzK1HpfKBzbOYtW9QsV3FQm9s4rtHisUBTf2iXaCcDjPXm1txNZ7r8jX
         ckKL2qr5EU3c2BE4FA1HZU2wxLoy2q6r7D3ax5klfLiJSXPLh4Y81o45RYiezX6ZVWqW
         3DFJ2fM+joCAL/Vc3P2I/qAOTaE5nkS8dIojw7r0xI1W8ed1oH5D/Cwdq8Jrin5R7Hmh
         1dDQGWkWYbV7KW996TMNxIaiGxznUiihKaPSgPJbaeN/BScbFA1Emtfdih7mSol33HPS
         S1uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hjse9me5EBzPjRR/0KqYMdrF6LbwsKwBIB7UB53FeVU=;
        b=spi0xwyRRvqvYLaZvO/9OWSks8rSRG8BAbntI9O68LjmWzVCgwjNO+dqjPySPb1c8W
         iTKqYlIvTP6Wo3qcwsKPc8PgzTyty3KoF0sHFOYqJMz9I0IZpJe5t3HLdAfG4LBnrCWl
         1wzvZ7JPpwOxy8HZSpD0ZiBYYM3o24y3PAMfyJ+4RIDtnLFhB9eZSwgxFLbizj7hjdIp
         rAFx0izZyl8r2INFj9GhKe/uVyK7scdi25bXBTAFixM3BMxHCfAnGIYmeqEGPPZvVQYv
         SyRrQ1Kk5G3agMc4DGYMJbr5WyzLXNHEOUZ6sww0hjP5HjpxM79eS1cFuerzIDnHJnud
         bm+A==
X-Gm-Message-State: AOAM533nAUOIb9wf+7OA255EwrFSEvld5+M/KGFvNT8/1+3YpMozibHn
        QgVhy8Rxdt/jy0NFydB1Zxs8SA==
X-Google-Smtp-Source: ABdhPJy53Pvxa4cDx0z1ZYLkGZM6z3m/mbA8r0G8VdmzAYbsKLRESMk8TPa1i9+d7CK1t/TfTi3IEg==
X-Received: by 2002:a17:906:9be1:: with SMTP id de33mr3872655ejc.320.1616152877828;
        Fri, 19 Mar 2021 04:21:17 -0700 (PDT)
Received: from maple.lan (cpc141216-aztw34-2-0-cust174.18-1.cable.virginm.net. [80.7.220.175])
        by smtp.gmail.com with ESMTPSA id fi11sm3459083ejb.73.2021.03.19.04.21.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Mar 2021 04:21:17 -0700 (PDT)
Date:   Fri, 19 Mar 2021 11:21:15 +0000
From:   Daniel Thompson <daniel.thompson@linaro.org>
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>
Cc:     Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
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
        linux-arm-kernel@lists.infradead.org,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux.cj@gmail.com, netdev@vger.kernel.org,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [net-next PATCH v7 04/16] of: mdio: Refactor of_phy_find_device()
Message-ID: <20210319112115.7l46p3mtptxgjvsf@maple.lan>
References: <20210311062011.8054-1-calvin.johnson@oss.nxp.com>
 <20210311062011.8054-5-calvin.johnson@oss.nxp.com>
 <20210316191719.d7nxgywwhczo7tyg@holly.lan>
 <20210317084433.GA21433@lsv03152.swis.in-blr01.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210317084433.GA21433@lsv03152.swis.in-blr01.nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 17, 2021 at 02:15:20PM +0530, Calvin Johnson wrote:
> Hi Daniel,
> 
> On Tue, Mar 16, 2021 at 07:17:19PM +0000, Daniel Thompson wrote:
> > On Thu, Mar 11, 2021 at 11:49:59AM +0530, Calvin Johnson wrote:
> > > Refactor of_phy_find_device() to use fwnode_phy_find_device().
> > > 
> > > Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
> > 
> > This patch series is provoking depmod dependency cycles for me and
> > it bisected down to this patch (although I think later patches in
> > the series add further cycles).
> > 
> > The problems emerge when running modules_install either directly or
> > indirectly via packaging rules such as bindeb-pkg.
> > 
> > ~~~
> > make -j16 INSTALL_MOD_PATH=$PWD/modules modules_install
> > ...
> >   INSTALL sound/usb/misc/snd-ua101.ko
> >   INSTALL sound/usb/snd-usb-audio.ko
> >   INSTALL sound/usb/snd-usbmidi-lib.ko
> >   INSTALL sound/xen/snd_xen_front.ko
> >   DEPMOD  5.12.0-rc3-00009-g1fda33bf463d
> > depmod: ERROR: Cycle detected: fwnode_mdio -> of_mdio -> fwnode_mdio
> > depmod: ERROR: Found 2 modules in dependency cycles!
> > ~~~
> > 
> > Kconfig can be found here:
> > https://gist.github.com/daniel-thompson/6a7d224f3d3950ffa3f63f979b636474
> > 
> > This Kconfig file is for a highly modular kernel derived from the Debian
> > 5.10 arm64 kernel config. I was not able to reproduce using the defconfig
> > kernel for arm64.
> > 
> Thanks for catching this. I'm able to reproduce the issue and will fix it.
> 
> By the way, is there any integration tool/mechanism out there to which I can
> submit the patch series and build for various possible configs like these?

Not sure which autotester would be most likely to pick this up.

This issue is slightly unusual because it broke the install rather then
the build... and lots of people (including me) primarily run build
tests ;-) .

Anyhow, I guess the best way to pick up module problems like this is
going to be an `allmodconfig` build followed up with `rm -rf modtest;
make modules_install INSTALL_MOD_PATH=$PWD/modtest`.


Daniel.
