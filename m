Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D187609C1A
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 10:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbiJXIKp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 04:10:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230181AbiJXIKk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 04:10:40 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2A94356E5;
        Mon, 24 Oct 2022 01:10:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666599037; x=1698135037;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=uw170i99a3xYagUOLTRB+BH+zYQ/zEo4hLwD3cRpGnE=;
  b=kNhGC987e3EHKOv2CVLFbcr3XYpsM+fAjNcdSc+n182yM04lDdPSGt9l
   ToRs8UClmVZsT1YcsIs0qBs/Gi0P2Lv5N18MEGFvxpdo2ZJiqWw7sM+z9
   rrhAazPfMYe3VMRIuiIJcw6zpqEJsZ3VsTOPua4udAc53aGu5+OrOpJF8
   5HGft3nwhMlwicq04743MZU8BMysQwj46G/Q35FBDM1QND05CNhOxfk2Q
   pykFfS6UKmgHLqTh45vS4bHxQOp4woV2RBGKTnmU4O0vy04+tiQwmb4jc
   GgbvvPGbVQMatfdJVzmJvg2ubV1sXlA+7Y9dYO4HLa+8+hJHqzGTsYxMD
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10509"; a="294763395"
X-IronPort-AV: E=Sophos;i="5.95,207,1661842800"; 
   d="scan'208";a="294763395"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2022 01:10:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10509"; a="756496680"
X-IronPort-AV: E=Sophos;i="5.95,207,1661842800"; 
   d="scan'208";a="756496680"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga004.jf.intel.com with ESMTP; 24 Oct 2022 01:10:30 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1omsXT-001LDj-1z;
        Mon, 24 Oct 2022 11:10:27 +0300
Date:   Mon, 24 Oct 2022 11:10:27 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Dongliang Mu <dzm91@hust.edu.cn>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Stefan =?iso-8859-1?Q?M=E4tje?= <stefan.maetje@esd.eu>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Sebastian =?iso-8859-1?Q?W=FCrl?= <sebastian.wuerl@ororatech.com>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] can: mcp251x: fix error handling code in
 mcp251x_can_probe
Message-ID: <Y1ZIc51hxE4iV70a@smile.fi.intel.com>
References: <20221024053711.696124-1-dzm91@hust.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221024053711.696124-1-dzm91@hust.edu.cn>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 24, 2022 at 01:37:07PM +0800, Dongliang Mu wrote:
> In mcp251x_can_probe, if mcp251x_gpio_setup fails, it forgets to
> unregister the can device.
> 
> Fix this by unregistering can device in mcp251x_can_probe.

Fixes tag?

-- 
With Best Regards,
Andy Shevchenko


