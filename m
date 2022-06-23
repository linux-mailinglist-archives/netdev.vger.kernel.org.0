Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBBBF55800E
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 18:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232317AbiFWQjX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 12:39:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232305AbiFWQjV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 12:39:21 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9471E48E62;
        Thu, 23 Jun 2022 09:39:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656002359; x=1687538359;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=EI+QQ+/jwbwz1xOCAJK7+a2mr8/Kd1EZs7K/UPWhtF4=;
  b=B0H4jhAwT9yCuhl5RKUj+DgehXTWyTO13dtL+RzviDUf49Eqwagc4mY1
   e+6KS7drkldGFz6RD73L6/G5Mi6jFD8u0GrrTx0hon1VzXGA6w/wvuLlr
   PDGNSzSRPQXgSMDeveGU1Rqt5x7ut5fRpHIYxY7r0JyQ8nlTDa9S2eXWL
   HBYIy1n90+z7GqSUobqfkCRuefsC2hyDkQdCNzwkawFu3vfKwl2E6OTRm
   0/3xis/GfyDVqIUX6CLvGLqnivMc9ZpxuSPRp1H1v+l++btgtn5hIJg0C
   hgzFtZDX5OquyljzLAe0eBpbvo6klCjvhZFPluvLBE7mkvt6b64BGdz7j
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10386"; a="342455606"
X-IronPort-AV: E=Sophos;i="5.92,216,1650956400"; 
   d="scan'208";a="342455606"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2022 09:39:19 -0700
X-IronPort-AV: E=Sophos;i="5.92,216,1650956400"; 
   d="scan'208";a="834715838"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2022 09:39:11 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1o4PrG-000tDS-Q2;
        Thu, 23 Jun 2022 19:39:06 +0300
Date:   Thu, 23 Jun 2022 19:39:06 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     sascha hauer <sha@pengutronix.de>
Cc:     Saravana Kannan <saravanak@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
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
Subject: Re: [PATCH v2 2/2] of: base: Avoid console probe delay when
 fw_devlink.strict=1
Message-ID: <YrSXKkYfr+Hinsuu@smile.fi.intel.com>
References: <20220623080344.783549-1-saravanak@google.com>
 <20220623080344.783549-3-saravanak@google.com>
 <20220623100421.GY1615@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220623100421.GY1615@pengutronix.de>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 23, 2022 at 12:04:21PM +0200, sascha hauer wrote:
> On Thu, Jun 23, 2022 at 01:03:43AM -0700, Saravana Kannan wrote:

...

> I wonder if it wouldn't be a better approach to just probe all devices
> and record the device(node) they are waiting on. Then you know that you
> don't need to probe them again until the device they are waiting for
> is available.

There may be no device, but resource. And we become again to the something like
deferred probe ugly hack.

The real solution is to rework device driver model in the kernel that it will
create a graph of dependencies and then simply follow it. But actually it should
be more than 1 graph, because there are resources and there are power, clock and
resets that may be orthogonal to the higher dependencies (like driver X provides
a resource to driver Y).

-- 
With Best Regards,
Andy Shevchenko


