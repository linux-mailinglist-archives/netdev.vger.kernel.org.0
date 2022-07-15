Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52A51576829
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 22:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbiGOUdz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 16:33:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbiGOUdy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 16:33:54 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DB9E13DE8;
        Fri, 15 Jul 2022 13:33:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657917233; x=1689453233;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=XzNWkK32OdUPfify8t3CgVvtAtYBTKOWpWWoVHFF5eE=;
  b=JQuQJZizkP0iJDcKb5nrp55++1ttE6Uudc0CUKosgbDFsJ9QoqEAaOFE
   TS/nQTap4SHli4zLv/Ix+HYIDGTQjN/u0xwliR1KbPLcwPdbf4iTmVG/z
   HjGQqAkXONP47IeA0O9yREliepHVBYDXP3YrmSD/CSwNXbRZaaqVY91el
   peUZ/ZEu3nZ6BYC0L5wTHxr5BIH6Whehf8hEyKUAbD2jttULqeUHQ1uat
   hnPh6WHsv4hrII6MPHn0LebbYo4ROJOf/BnYKlYwl6BJlkdXcPa7UzhO6
   7kkH0shLm568RvD2zPAIumfsofJ6HTX8Yrq07q3rFDKHlB/8fzakIaaOt
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10409"; a="265683971"
X-IronPort-AV: E=Sophos;i="5.92,274,1650956400"; 
   d="scan'208";a="265683971"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2022 13:33:52 -0700
X-IronPort-AV: E=Sophos;i="5.92,274,1650956400"; 
   d="scan'208";a="546785486"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2022 13:33:45 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1oCS0L-001JGB-0F;
        Fri, 15 Jul 2022 23:33:41 +0300
Date:   Fri, 15 Jul 2022 23:33:40 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Alvin __ipraga <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Daniel Scally <djrscally@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        DENG Qingfang <dqfext@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sean Wang <sean.wang@mediatek.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Subject: Re: [PATCH net-next 2/6] software node: allow named software node to
 be created
Message-ID: <YtHPJNpcN4vNfgT6@smile.fi.intel.com>
References: <YtGPO5SkMZfN8b/s@shell.armlinux.org.uk>
 <E1oCNky-006e3g-KA@rmk-PC.armlinux.org.uk>
 <YtHGwz4v7VWKhIXG@smile.fi.intel.com>
 <20220715201715.foea4rifegmnti46@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220715201715.foea4rifegmnti46@skbuf>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 15, 2022 at 11:17:15PM +0300, Vladimir Oltean wrote:
> On Fri, Jul 15, 2022 at 10:57:55PM +0300, Andy Shevchenko wrote:
> > On Fri, Jul 15, 2022 at 05:01:32PM +0100, Russell King wrote:
> > > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > > 
> > > Allow a named software node to be created, which is needed for software
> > > nodes for a fixed-link specification for DSA.
> > 
> > In general I have no objection, but what's worrying me is a possibility to
> > collide in namespace. With the current code the name is generated based on
> > unique IDs, how can we make this one more robust?
> 
> Could you be more clear about the exact concern?

Each software node can be created with a name. The hierarchy should be unique,
means that there can't be two or more nodes with the same path (like on file
system or more specifically here, Device Tree). Allowing to pass names we may
end up with the situation when it will be a path collision. Yet, the static
names are easier to check, because one may run `git grep ...` or coccinelle
script to see what's in the kernel.

-- 
With Best Regards,
Andy Shevchenko


