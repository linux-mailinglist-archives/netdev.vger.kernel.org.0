Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE34468E3B5
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 23:55:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbjBGWzW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 17:55:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbjBGWzR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 17:55:17 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFB0A22A03;
        Tue,  7 Feb 2023 14:55:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675810516; x=1707346516;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=lx4c26ErU5S2ynIOqkxO2qwwwvS3CfD4nsakwC60WCg=;
  b=mu/z6cTOCDPgZUilvM9Bq/eoEj50tNojFCJ0N7nV16QZB5UUngGgSU+s
   Qb2/LCTJdRCxQTNdv3zZ4FlCuCz2maW9IN1guwZ8n3P8mzGeWhv5RkvE6
   3gipDzwaJwcZYz1a2EFaOM19ReHHV6lO/yeNK7A5kUW/wuElFsy19rUcQ
   s4pO1X+rdn1WY3XATtEP1jgLoEEGuMDad0hOYdY/x8GFrfGX6sKIZLQyL
   bdYgkHS/U3uDXhhVBmWqnCg5+vaczexRyWzh47Pl5UU+U5QLSjqfgG0C+
   KIkO6wss5lYdBgK/rjTCUjrlI2mU5bqOoPsmo8eizABH9EvR6miSoFm67
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="309298586"
X-IronPort-AV: E=Sophos;i="5.97,279,1669104000"; 
   d="scan'208";a="309298586"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 14:55:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="755794715"
X-IronPort-AV: E=Sophos;i="5.97,279,1669104000"; 
   d="scan'208";a="755794715"
Received: from smile.fi.intel.com ([10.237.72.54])
  by FMSMGA003.fm.intel.com with ESMTP; 07 Feb 2023 14:55:09 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1pPWri-003on0-0X;
        Wed, 08 Feb 2023 00:55:06 +0200
Date:   Wed, 8 Feb 2023 00:55:05 +0200
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
Message-ID: <Y+LWyc4rqCVq5hEi@smile.fi.intel.com>
References: <20230207142952.51844-1-andriy.shevchenko@linux.intel.com>
 <20230207142952.51844-7-andriy.shevchenko@linux.intel.com>
 <CACRpkdaPgjDijPjCdinWy5_Rd8g3idv-8K=YPTv5iTfJKFuJfw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdaPgjDijPjCdinWy5_Rd8g3idv-8K=YPTv5iTfJKFuJfw@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 07, 2023 at 03:55:23PM +0100, Linus Walleij wrote:
> On Tue, Feb 7, 2023 at 3:29 PM Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
> 
> > From: Arnd Bergmann <arnd@arndb.de>
> >
> > Almost all gpio drivers include linux/gpio/driver.h, and other
> > files should not rely on includes from this header.
> >
> > Remove the indirect include from here and include the correct
> > headers directly from where they are used.

...

> Make sure you push this to the kernel.org build servers (zeroday builds),

Of course, that is the purpose of publishing this before the release (so we
will have some TODO list that eventually this can be applied for v6.4-rc1).

> I think this patch needs to hit some more files, in my tests with a similar
> patch at least these:

Right. I forgot to also incorporate your stuff into this series.
Do you have anything that I can take as is?

-- 
With Best Regards,
Andy Shevchenko


