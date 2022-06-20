Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B34F5522DA
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 19:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243321AbiFTRoQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 13:44:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232587AbiFTRoP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 13:44:15 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8760E19C03;
        Mon, 20 Jun 2022 10:44:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655747053; x=1687283053;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=49F6Qlkni1HEmNtcuftY0iBgdLMBs7pfcE3RK6wafsg=;
  b=F4hedf3olm7Xw9ntHevYspZCIdNmaMIHFeS8VN14hZCu9LLyDjjAoa41
   hqqFs0NbLBXISb9C/LssLZwtLEp81+aoOIUD5NA6XmsgE7sc9I4AirFsw
   srMo3BwYNhPICZGe6ARvfgWXe8F8hyFFF4Ld+5yAgPQFpQPCQPJBfQr71
   nLwty5aMLFyCrzxpfM4NEystDRSHZATgvlcS3FdIwcKRl85VdJBD5M2Ok
   bSVLnoUM0bfsVTiR6WKGFnYWGZGfcv/7BdJWJKyI2Xf6zIPjZUZQa8azv
   T4gf+EDzj3lWr6zzsq7q0lmE3wGGx+g/+wu/vOdW/x7S7tYL+zzv4ihyL
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10384"; a="278719449"
X-IronPort-AV: E=Sophos;i="5.92,207,1650956400"; 
   d="scan'208";a="278719449"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2022 10:44:13 -0700
X-IronPort-AV: E=Sophos;i="5.92,207,1650956400"; 
   d="scan'208";a="654778352"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2022 10:44:08 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1o3LRV-000kZs-Hv;
        Mon, 20 Jun 2022 20:44:05 +0300
Date:   Mon, 20 Jun 2022 20:44:05 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, rafael@kernel.org, lenb@kernel.org,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux@armlinux.org.uk,
        hkallweit1@gmail.com, gjb@semihalf.com, jaz@semihalf.com,
        tn@semihalf.com, Samer.El-Haj-Mahmoud@arm.com,
        upstream@semihalf.com
Subject: Re: [net-next: PATCH 04/12] net: mvpp2: initialize port fwnode
 pointer
Message-ID: <YrCx5SkADWBzRokM@smile.fi.intel.com>
References: <20220620150225.1307946-1-mw@semihalf.com>
 <20220620150225.1307946-5-mw@semihalf.com>
 <YrCxqDYg6OIdgmG1@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YrCxqDYg6OIdgmG1@smile.fi.intel.com>
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

On Mon, Jun 20, 2022 at 08:43:05PM +0300, Andy Shevchenko wrote:
> On Mon, Jun 20, 2022 at 05:02:17PM +0200, Marcin Wojtas wrote:
> > As a preparation to switch the DSA subsystem from using
> > of_find_net_device_by_node() to its more generic fwnode_
> > equivalent, the port's device structure should be updated
> > with its fwnode pointer, similarly to of_node - see analogous
> > commit c4053ef32208 ("net: mvpp2: initialize port of_node pointer").
> > 
> > This patch is required to prevent a regression before updating
> > the DSA API on boards that connect the mvpp2 port to switch,
> > such as Clearfog GT-8K or CN913x CEx7 Evaluation Board.
> 
> ...
> 
> >  	dev->dev.of_node = port_node;
> > +	dev->dev.fwnode = port_fwnode;
> 
> device_set_node() ?

Ah, important remark to all device_set_node() comments. It assumes that you
replace _both_ assignments with _single_ call.

-- 
With Best Regards,
Andy Shevchenko


