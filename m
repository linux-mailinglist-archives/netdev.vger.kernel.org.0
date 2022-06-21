Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9015955305E
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 13:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241768AbiFULCv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 07:02:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbiFULCu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 07:02:50 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BC2B2981E;
        Tue, 21 Jun 2022 04:02:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655809370; x=1687345370;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=XV4/5tqNYqxROdwVrNcTbxKf9vrOy8Yg4VYbG25o8Rs=;
  b=KGwRp6Xj/zpGynRaDoFIZrfYEKHcKoTquc93BakfC1rNn7koeYCt8BKD
   T4VLirFwOM2Qmb+I++Wxb7/SMCjI2c0RdDhDjKVpAraRPTCMu5eODk+vQ
   ofeSef6u47R5D+jzU1xud+OsV5MdRvCl4GnENIBhy4VzkcW5ckv9YSUvT
   WL3/Hpnh5agKpR5tPeR5Y2SBZzjsDcI88S8yYVi2ZNk6t0boNQc/Ce8Py
   RFMQnlBEKMomlDks97WYZauneYxrALj+4oc9wBrKbfM+/1z+oFrz3JNma
   hmj5rqdwSJgtiV3Xfh/2YuEofc/qpwA1ScZTfX7LJFnToV6Ng0CgS9lzd
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10384"; a="341775201"
X-IronPort-AV: E=Sophos;i="5.92,209,1650956400"; 
   d="scan'208";a="341775201"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2022 04:02:49 -0700
X-IronPort-AV: E=Sophos;i="5.92,209,1650956400"; 
   d="scan'208";a="562331164"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2022 04:02:44 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1o3beb-000qxI-56;
        Tue, 21 Jun 2022 14:02:41 +0300
Date:   Tue, 21 Jun 2022 14:02:40 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        vivien.didelot@gmail.com, Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, pabeni@redhat.com,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Grzegorz Bernacki <gjb@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Samer El-Haj-Mahmoud <Samer.El-Haj-Mahmoud@arm.com>,
        upstream@semihalf.com
Subject: Re: [net-next: PATCH 03/12] net: dsa: switch to device_/fwnode_ APIs
Message-ID: <YrGlUPxrK4XeaT5h@smile.fi.intel.com>
References: <20220620150225.1307946-1-mw@semihalf.com>
 <20220620150225.1307946-4-mw@semihalf.com>
 <YrCxUfTDmvm9zLXq@smile.fi.intel.com>
 <CAPv3WKch9hC3ZjZE0f4JntqFDY04PUpQ1yzsgShThmhkqV01-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPv3WKch9hC3ZjZE0f4JntqFDY04PUpQ1yzsgShThmhkqV01-g@mail.gmail.com>
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

On Tue, Jun 21, 2022 at 11:27:43AM +0200, Marcin Wojtas wrote:
> pon., 20 cze 2022 o 19:41 Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> napisał(a):
> > On Mon, Jun 20, 2022 at 05:02:16PM +0200, Marcin Wojtas wrote:

...

> > >       struct device_node      *dn;
> >
> > What prevents us from removing this?
> 
> I left it to satisfy possible issues with backward compatibility - I
> migrated mv88e6xxx, other DSA drivers still rely on of_* and may use
> this field.

If it is so, it's a way to get into troubles of desynchronized dn and fwnode.

> > > +     struct fwnode_handle    *fwnode;

-- 
With Best Regards,
Andy Shevchenko


