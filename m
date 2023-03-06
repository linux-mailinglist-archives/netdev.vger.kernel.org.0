Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BFD56AC5F7
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 16:54:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbjCFPys (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 10:54:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbjCFPyr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 10:54:47 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0462E23669;
        Mon,  6 Mar 2023 07:54:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678118086; x=1709654086;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=nqBEyqCxPf0CdDuSxcYS7HYgQHSI7GNHr2exg16wCz4=;
  b=jVQzGY7cm78n24RleIe4Y3IOOs3UvWUJWxBpsB/poUmwiF9/IrOrNKZM
   OD+iw8EXaul0+YEKyD++alUsF8rrZaLXwZMBqO6v5iUz9O+Ifd1btlGPa
   3gegQYjR+fJPu8tu63x4Fw3C3HDl/HpPjVOCDftObd0Cf+McdcLyiQwJr
   SZymu+KeyZnGzYLPIvkO1vYi5VFyfxB+B3827udan9BaXt0wN5mvJisGp
   o8ACMGyZtn9lsB9bTVxO+Sxi4lLIsXmEAKeGeM0A3O1mbK4gPyhq9Oqjf
   yC1KptYpTosbjzUQA4ux1R5xkslaiLHrxQEKCz6OBmOJMrNMVGQXW+Alz
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="400411726"
X-IronPort-AV: E=Sophos;i="5.98,238,1673942400"; 
   d="scan'208";a="400411726"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2023 07:54:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="850346560"
X-IronPort-AV: E=Sophos;i="5.98,238,1673942400"; 
   d="scan'208";a="850346560"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga005.jf.intel.com with ESMTP; 06 Mar 2023 07:54:40 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1pZDAc-00GVWx-0e;
        Mon, 06 Mar 2023 17:54:38 +0200
Date:   Mon, 6 Mar 2023 17:54:37 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Gene Chen <gene_chen@richtek.com>, linux-leds@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH v4 11/11] net: dsa: hellcreek: Get rid of custom
 led_init_default_state_get()
Message-ID: <ZAYMvVR+6eQ9qjAk@smile.fi.intel.com>
References: <20230103131256.33894-1-andriy.shevchenko@linux.intel.com>
 <20230103131256.33894-12-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230103131256.33894-12-andriy.shevchenko@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 03, 2023 at 03:12:56PM +0200, Andy Shevchenko wrote:
> LED core provides a helper to parse default state from firmware node.
> Use it instead of custom implementation.

Jakub, if you are okay with thi, it may be applied now
(Lee hadn't taken it in via LEDS subsystem for v6.3-rc1).

-- 
With Best Regards,
Andy Shevchenko


