Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3A224C16F5
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 16:38:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242134AbiBWPh6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 10:37:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242043AbiBWPh4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 10:37:56 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38572BBE0B;
        Wed, 23 Feb 2022 07:37:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645630648; x=1677166648;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=7ONB/aTHqMjYH/OmutKWhupcasaRbDK6GNSZHCYrgIs=;
  b=MEQumQnXn/kchseS79skJ8C/8UryZIzbBJ2HpjdjH6VRDDuuQa9i8ZWU
   Xx9hCvjh9wL9nOUCUm02fc6TPhdslylyTvdOAE52DvqqoBqwFp6KH2sQ/
   xdXRsWbgYyHiix6YTGJThfIYRXmMrH+hSFQbHNojfsoEr3kw2GIBfxpfh
   63xnBb7rRtbEth7E3aJukrgUDnEvimcT2aLk1FapUKRFgYH3Y0v8Hce6p
   UlNr/aUnRDcWdhqB72sJgWg++wApv0gDzomyagHM1Lk3zUJbBiwJ1L5QK
   N53SJSJaV+eLDs212HDyNrHHUVoNpJhjdGtXGMU9xiYJAqU4GiXP+CA4q
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10266"; a="338427660"
X-IronPort-AV: E=Sophos;i="5.88,391,1635231600"; 
   d="scan'208";a="338427660"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2022 07:37:27 -0800
X-IronPort-AV: E=Sophos;i="5.88,391,1635231600"; 
   d="scan'208";a="628121128"
Received: from smile.fi.intel.com ([10.237.72.59])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2022 07:37:23 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1nMtgt-007TeV-Tl;
        Wed, 23 Feb 2022 17:36:31 +0200
Date:   Wed, 23 Feb 2022 17:36:31 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Daniel Scally <djrscally@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Wolfram Sang <wsa@kernel.org>, Peter Rosin <peda@axentia.se>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-i2c@vger.kernel.org,
        netdev@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: Re: [RFC 10/10] net: sfp: add support for fwnode
Message-ID: <YhZUf6MXUTumYyvF@smile.fi.intel.com>
References: <20220221162652.103834-11-clement.leger@bootlin.com>
 <YhPSkz8+BIcdb72R@smile.fi.intel.com>
 <20220222142513.026ad98c@fixe.home>
 <YhYZAc5+Q1rN3vhk@smile.fi.intel.com>
 <888f9f1a-ca5a-1250-1423-6c012ec773e2@redhat.com>
 <YhYriwvHJKjrDQRf@shell.armlinux.org.uk>
 <4d611fe8-b82a-1709-507a-56be94263688@redhat.com>
 <20220223151436.4798e5ad@fixe.home>
 <YhZRgnPG5Yd8mvc/@lunn.ch>
 <d7c8a9fe-5c9b-2c9d-3731-c735da795bf8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d7c8a9fe-5c9b-2c9d-3731-c735da795bf8@redhat.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 23, 2022 at 04:27:33PM +0100, Hans de Goede wrote:
> On 2/23/22 16:23, Andrew Lunn wrote:
> >> As Russell asked, I'm also really interested if someone has a solution
> >> to reuse device-tree description (overlays ?) to describe such
> >> hardware. However, the fact that CONFIG_OF isn't enabled on x86 config
> >> seems a bit complicated on this side.
> > 
> > It does work, intel even used it for one of there tiny x86 SoCs. Maybe
> > it was Newton?
> 
> IIRC those SoCs did not use standard EFI/ACPI though, but rather some
> other special firmware, I think it was SFI ?  This is not so much about
> the CPU architecture as it is about the firmware/bootloader <->
> OS interface.

I think Andrew refers to Intel SoCs that are using OF. Those so far are
CE4xxx and SoFIA SoCs.

-- 
With Best Regards,
Andy Shevchenko


