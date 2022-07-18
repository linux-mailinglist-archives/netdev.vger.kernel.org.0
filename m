Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38B1757824B
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 14:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234253AbiGRM1G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 08:27:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233407AbiGRM1F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 08:27:05 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B91D5BAF;
        Mon, 18 Jul 2022 05:27:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658147224; x=1689683224;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=9pmvwK6gZKZsdPvJKC7erTRSJ1Azp96NhdXTB4qIeoo=;
  b=PsqWSWvhZs1FsjKfD8TmD/8cXT9hvRv8sUqsPVR11JKYhBhzEtOMVeyB
   wZrCJyvXmTE43gWDrFv/ABEIu4VvfjVZD2QLJuFY3ht88Rr7cCai5OPEh
   2joA9fYPZ7g7hkq0pUdcCRMGTQREGLFbCS/pM97VMYHdvpi+YyXdmRSMP
   KSYrHRyThfszqUK2VyOmuNPACBjNcuAzhAcJraquPWx7sKl6mwCJe3YvL
   McHT/+GJhdwdzCcSiJ7DIVgmZ6mVT5v2p/iPyywdzX7tXq2VFd8wnkkCN
   eEhoO6aur1fHDkrOBV56Hp/46BwHsjOwUsqmH5ppTsVhnerERFK0k82Wu
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10411"; a="286948011"
X-IronPort-AV: E=Sophos;i="5.92,281,1650956400"; 
   d="scan'208";a="286948011"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2022 05:27:03 -0700
X-IronPort-AV: E=Sophos;i="5.92,281,1650956400"; 
   d="scan'208";a="601206977"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2022 05:26:58 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1oDPpu-001OAV-2O;
        Mon, 18 Jul 2022 15:26:54 +0300
Date:   Mon, 18 Jul 2022 15:26:54 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Grzegorz Bernacki <gjb@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Samer El-Haj-Mahmoud <Samer.El-Haj-Mahmoud@arm.com>,
        upstream@semihalf.com
Subject: Re: [net-next: PATCH v2 5/8] device property: introduce
 fwnode_dev_node_match
Message-ID: <YtVRjvzgmeDjLz1k@smile.fi.intel.com>
References: <20220715085012.2630214-1-mw@semihalf.com>
 <20220715085012.2630214-6-mw@semihalf.com>
 <YtHBvb/kh/Sl0cmz@smile.fi.intel.com>
 <YtHDHtWU5Wbgknej@smile.fi.intel.com>
 <CAPv3WKcf7U_KLuxg5zgyQZru52QEAgrHq2dO7dD4JGMMCLq05w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPv3WKcf7U_KLuxg5zgyQZru52QEAgrHq2dO7dD4JGMMCLq05w@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 16, 2022 at 01:15:55AM +0200, Marcin Wojtas wrote:
> pt., 15 lip 2022 o 21:42 Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> napisał(a):
> >
> > On Fri, Jul 15, 2022 at 10:36:29PM +0300, Andy Shevchenko wrote:
> > > On Fri, Jul 15, 2022 at 10:50:09AM +0200, Marcin Wojtas wrote:
> > > > This patch adds a new generic routine fwnode_dev_node_match
> > > > that can be used e.g. as a callback for class_find_device().
> > > > It searches for the struct device corresponding to a
> > > > struct fwnode_handle by iterating over device and
> > > > its parents.
> > >
> > > Implementation
> > > 1) misses the word 'parent';
> 
> I'm not sure. We don't necessarily look for parent device(s). We start
> with a struct device and if it matches the fwnode, success is returned
> immediately. Only otherwise we iterate over parent devices to find a
> match.

Yes, you iterate over parents. 0 iterations doesn't change semantics of
all cases, right?

> > > 2) located outside of the group of fwnode APIs operating on parents.
> 
> I can shift it right below fwnode_get_nth_parent if you prefer.

Yes, please do.

> > > I would suggest to rename to fwnode_get_next_parent_node() and place
> > > near to fwnode_get_next_parent_dev() (either before or after, where
> > > it makes more sense).
> >
> > And matching function will be after that:
> >
> >         return fwnode_get_next_parent_node(...) != NULL;
> >
> > Think about it. Maybe current solution is good enough, just needs better
> > naming (fwnode_match_parent_node()? Dunno).
> >
> > P.S. Actually _get maybe misleading as we won't bump reference counting,
> >      rather _find?
> 
> How about the following name:
> fwnode_find_dev_match()
> ?

fwnode_find_parent_dev_match() LGTM, thanks!

You iterate over parents.

-- 
With Best Regards,
Andy Shevchenko


