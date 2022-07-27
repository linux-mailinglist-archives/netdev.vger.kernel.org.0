Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29D0958242B
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 12:24:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbiG0KYw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 06:24:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229594AbiG0KYv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 06:24:51 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B82843317;
        Wed, 27 Jul 2022 03:24:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658917490; x=1690453490;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=JGWTlbYvtfSIAbNWy4AzEM+K/LsjT7gFuzUMIKvcb7g=;
  b=BgD8BmFlsmEk64ERIBst7UCd+wjcCPOprJfvWbwzYuWu2cFt/UyOKSEf
   xXyOXO9gfHPr2F3ud9lR/XFds4nr6MYJa0ndtOofWkU1vu7ttmxX4dHZv
   W3tC2FTpdG1Jnhx8ZJkmh/gUiOj4VQIR6KXzxL9lAQnILQ1TKpbcIqloH
   LusfyYU5BdXorFeEMdZ8cl4iNGw3xgSGbt2a0vfPoGMOV7xRDgy2zRAeX
   wfonFJE5XcKrwbw1xaDo7HSn8+QmxT1EdSP2hVZlqzmwg3KkQwlCjZtcT
   fETHryADugvu2Ym74V9YfCMvmeFP+OqNXTR246BWtdAI5rJgXtlq8cwtW
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10420"; a="349902989"
X-IronPort-AV: E=Sophos;i="5.93,195,1654585200"; 
   d="scan'208";a="349902989"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2022 03:24:49 -0700
X-IronPort-AV: E=Sophos;i="5.93,195,1654585200"; 
   d="scan'208";a="659138634"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2022 03:24:44 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1oGeDZ-001Y3n-16;
        Wed, 27 Jul 2022 13:24:41 +0300
Date:   Wed, 27 Jul 2022 13:24:41 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, rafael@kernel.org, sean.wang@mediatek.com,
        Landen.Chao@mediatek.com, linus.walleij@linaro.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@armlinux.org.uk, hkallweit1@gmail.com,
        gjb@semihalf.com, jaz@semihalf.com, tn@semihalf.com,
        Samer.El-Haj-Mahmoud@arm.com, upstream@semihalf.com
Subject: Re: [net-next: PATCH v3 1/8] net: phy: fixed_phy: switch to fwnode_
 API
Message-ID: <YuESaa42FZbJr3Jt@smile.fi.intel.com>
References: <20220727064321.2953971-1-mw@semihalf.com>
 <20220727064321.2953971-2-mw@semihalf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220727064321.2953971-2-mw@semihalf.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 27, 2022 at 08:43:14AM +0200, Marcin Wojtas wrote:
> This patch allows to use fixed_phy driver and its helper

Check "Submitting Patches" for "This patch..." and fix your message
accordingly.

> functions without Device Tree dependency, by swtiching from
> of_ to fwnode_ API.

-- 
With Best Regards,
Andy Shevchenko


