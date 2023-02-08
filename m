Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 835A768F13B
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 15:52:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231609AbjBHOwD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 09:52:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231256AbjBHOvx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 09:51:53 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F345C15B;
        Wed,  8 Feb 2023 06:51:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675867913; x=1707403913;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=3P68b0TVOlpRiURRNLVvw64Yo8IjZVFB+vqzhU4qIC8=;
  b=N4m5Epe6+urLldVT+ALcBfv7cRHHaaacs8NI6i86a+/bMg7up1jRQul3
   K2cXc9lMW+EVI7gkHMN61O28/BPPihQ+YbJgorsIhnSvftSYEVyRGkTfC
   ZCix5FuXDdTfOSIHY5zTGRSuFjnR2TX4Vs5YCran3+jezZ8FTp7t4rYKZ
   6icmnw5U8T8SVX3MHd8g1iPkGC8Wj0VXJlpSy+Xa5KAOUw8qCEuswgy9k
   wrzatSM7BmFrjHXRGa784JlNOErghFYOjQ2SdnyyhN+QNMlBGc0NG1WgY
   cRm7XE/vO320D5kl4GsxEcmF06ICIIT+o0t2yeXOac4WWy+cbdT7IJDdY
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="313454189"
X-IronPort-AV: E=Sophos;i="5.97,281,1669104000"; 
   d="scan'208";a="313454189"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2023 06:51:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="841199018"
X-IronPort-AV: E=Sophos;i="5.97,281,1669104000"; 
   d="scan'208";a="841199018"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga005.jf.intel.com with ESMTP; 08 Feb 2023 06:51:44 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1pPlnR-004ANT-0z;
        Wed, 08 Feb 2023 16:51:41 +0200
Date:   Wed, 8 Feb 2023 16:51:41 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        linux-gpio@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-doc-tw-discuss@lists.sourceforge.net,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
        linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-input@vger.kernel.org,
        linux-media@vger.kernel.org, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, linux-arch@vger.kernel.org,
        devicetree@vger.kernel.org, Bartosz Golaszewski <brgl@bgdev.pl>
Subject: Re: [PATCH v3 06/12] gpiolib: split linux/gpio/driver.h out of
 linux/gpio.h
Message-ID: <Y+O2/dVDcvnXByc+@smile.fi.intel.com>
References: <20230207142952.51844-1-andriy.shevchenko@linux.intel.com>
 <20230207142952.51844-7-andriy.shevchenko@linux.intel.com>
 <CACRpkdaPgjDijPjCdinWy5_Rd8g3idv-8K=YPTv5iTfJKFuJfw@mail.gmail.com>
 <Y+LWyc4rqCVq5hEi@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+LWyc4rqCVq5hEi@smile.fi.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 08, 2023 at 12:55:06AM +0200, Andy Shevchenko wrote:
> On Tue, Feb 07, 2023 at 03:55:23PM +0100, Linus Walleij wrote:
> > On Tue, Feb 7, 2023 at 3:29 PM Andy Shevchenko
> > <andriy.shevchenko@linux.intel.com> wrote:
> > 
> > > From: Arnd Bergmann <arnd@arndb.de>
> > >
> > > Almost all gpio drivers include linux/gpio/driver.h, and other
> > > files should not rely on includes from this header.
> > >
> > > Remove the indirect include from here and include the correct
> > > headers directly from where they are used.
> 
> ...
> 
> > Make sure you push this to the kernel.org build servers (zeroday builds),
> 
> Of course, that is the purpose of publishing this before the release (so we
> will have some TODO list that eventually this can be applied for v6.4-rc1).
> 
> > I think this patch needs to hit some more files, in my tests with a similar
> > patch at least these:
> 
> Right. I forgot to also incorporate your stuff into this series.
> Do you have anything that I can take as is?

I'm going to incorporate the following:

	gpio: Make the legacy <linux/gpio.h> consumer-only
	ARM: s3c24xx: Use the right include
	ARM: orion/gpio: Use the right include
	hte: tegra-194: Use proper includes
	pcmcia: pxa2xx_viper: Include dependency


-- 
With Best Regards,
Andy Shevchenko


