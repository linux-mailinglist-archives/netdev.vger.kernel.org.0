Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D67E651ECE6
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 12:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231325AbiEHKaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 06:30:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbiEHKa2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 06:30:28 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01903DFBD;
        Sun,  8 May 2022 03:26:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652005598; x=1683541598;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=bSU9fO4lrWoDsIEUgjYMWmwmoe4o/mjHCu3zxv5muLo=;
  b=bgLWj9Ugko7x3VrxEUt+bA8JPpASnmfAw1o6MUinh/egqAJlZVsOZsUF
   OpPwjg74P73SVlHzQASclgOQg4JTNnba5JSvrildL03zgVBAY0p45BZdu
   jD4Jcdduwompy3biUGjGM25k5I9iPlGJWiAkUezPkjTMKenvlgS6bISEd
   hAX3rGbYH1z7abWiBc7ax3lWfnPHJqPaJr8+0Amxngs1cE7qFPjh9/Vu6
   09+GnLlT86T3odBOHPQ5nDErTa+0E3TSkhS0WV1+BJR3INzkkyofOs9D7
   rrRFI+9LzW399sOhtfVynAJgv9XUlzCK3e0SLSS3ZQuGgtQfMre4VGm3b
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10340"; a="329386548"
X-IronPort-AV: E=Sophos;i="5.91,208,1647327600"; 
   d="scan'208";a="329386548"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2022 03:26:37 -0700
X-IronPort-AV: E=Sophos;i="5.91,208,1647327600"; 
   d="scan'208";a="564569270"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2022 03:26:26 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1nne7J-00DSlW-Qt;
        Sun, 08 May 2022 13:26:21 +0300
Date:   Sun, 8 May 2022 13:26:21 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Daniel Lezcano <daniel.lezcano@linexp.org>
Cc:     daniel.lezcano@linaro.org, rafael@kernel.org, khilman@baylibre.com,
        abailon@baylibre.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Amit Kucheria <amitk@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Jonathan Corbet <corbet@lwn.net>, Len Brown <lenb@kernel.org>,
        Raju Rangoju <rajur@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@kernel.org>, Peter Kaestle <peter@piie.net>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Support Opensource <support.opensource@diasemi.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund@ragnatech.se>,
        Miri Korenblit <miriam.rachel.korenblit@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Sumeet Pawnikar <sumeet.r.pawnikar@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Chuansheng Liu <chuansheng.liu@intel.com>,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Antoine Tenart <atenart@kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        "open list:ACPI THERMAL DRIVER" <linux-acpi@vger.kernel.org>,
        "open list:CXGB4 ETHERNET DRIVER (CXGB4)" <netdev@vger.kernel.org>,
        "open list:INTEL WIRELESS WIFI LINK (iwlwifi)" 
        <linux-wireless@vger.kernel.org>,
        "open list:ACER ASPIRE ONE TEMPERATURE AND FAN DRIVER" 
        <platform-driver-x86@vger.kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        "open list:RENESAS R-CAR THERMAL DRIVERS" 
        <linux-renesas-soc@vger.kernel.org>
Subject: Re: [PATCH v2 01/14] thermal/core: Change thermal_zone_ops to
 thermal_sensor_ops
Message-ID: <YneazaFEg3nONazs@smile.fi.intel.com>
References: <20220507125443.2766939-1-daniel.lezcano@linexp.org>
 <20220507125443.2766939-2-daniel.lezcano@linexp.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220507125443.2766939-2-daniel.lezcano@linexp.org>
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

On Sat, May 07, 2022 at 02:54:29PM +0200, Daniel Lezcano wrote:
> A thermal zone is software abstraction of a sensor associated with
> properties and cooling devices if any.
> 
> The fact that we have thermal_zone and thermal_zone_ops mixed is
> confusing and does not clearly identify the different components
> entering in the thermal management process. A thermal zone appears to
> be a sensor while it is not.
> 
> In order to set the scene for multiple thermal sensors aggregated into
> a single thermal zone. Rename the thermal_zone_ops to
> thermal_sensor_ops, that will appear clearyl the thermal zone is not a
> sensor but an abstraction of one [or multiple] sensor(s).

Acked-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
for whatever drivers in this series I have somehow been involved into.

-- 
With Best Regards,
Andy Shevchenko


