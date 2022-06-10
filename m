Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 123D254652A
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 13:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348456AbiFJLJf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 07:09:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348925AbiFJLJa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 07:09:30 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56889146405;
        Fri, 10 Jun 2022 04:09:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654859369; x=1686395369;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=vPekLyqtRJctV4Stin8NJxATqTgWrggk5f+uvZ5RiY4=;
  b=mlE4Tmqgoy77Aww4AoEDge+/k+DG8EpjN+XoMIQUiWv0LNPziHVs+iZj
   aqg/rx7mQ6gPM7NeHPO4lbyt4ju5EUjtuMzZUFRLO9pgIraBJOFw4z3Q7
   QlEzidfPr5woW9HWPH7CbX1kfpiAKG7Ww++nvTMbDlyh7WOcF4gMIfe3T
   MmuZjtojpsivgY+rvZldsPr8mkX92AiElXh9a6dQ7HQWeT1QStxkNEYC1
   LnI4fMA2CFftLl3iijOEs7Z9hJN/2ojFq2ortYUWPL4EvhYYbXJ3aC+MY
   seR0Nt6nl4erCVfaXhcBKqy3G5l3UEudHG0zyj5HymO1ToXdca0JF18iJ
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10373"; a="260714419"
X-IronPort-AV: E=Sophos;i="5.91,290,1647327600"; 
   d="scan'208";a="260714419"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2022 04:09:28 -0700
X-IronPort-AV: E=Sophos;i="5.91,290,1647327600"; 
   d="scan'208";a="671798863"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2022 04:09:27 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1nzcW4-000Yhm-EE;
        Fri, 10 Jun 2022 14:09:24 +0300
Date:   Fri, 10 Jun 2022 14:09:24 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jonathan Lemon <jonathan.lemon@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH net-next v1 1/5] ptp_ocp: use dev_err_probe()
Message-ID: <YqMmZBEsCv+f19se@smile.fi.intel.com>
References: <20220608120358.81147-1-andriy.shevchenko@linux.intel.com>
 <20220608120358.81147-2-andriy.shevchenko@linux.intel.com>
 <20220609224523.78b6a6e6@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220609224523.78b6a6e6@kernel.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 09, 2022 at 10:45:23PM -0700, Jakub Kicinski wrote:
> On Wed,  8 Jun 2022 15:03:54 +0300 Andy Shevchenko wrote:
> > Simplify the error path in ->probe() and unify message format a bit
> > by using dev_err_probe().
> 
> Let's not do this. I get that using dev_err_probe() even without
> possibility of -EPROBE_DEFER is acceptable, but converting
> existing drivers is too much IMO. Acceptable < best practice.

Noted.

I have just checked that if you drop this patch the rest will be still
applicable. If you have no objections, can you apply patches 2-5 then?

-- 
With Best Regards,
Andy Shevchenko


