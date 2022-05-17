Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4997952A893
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 18:51:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351208AbiEQQvT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 12:51:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351207AbiEQQu7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 12:50:59 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E5AE2BE7;
        Tue, 17 May 2022 09:50:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652806257; x=1684342257;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9E/vttDFy0EFq5zSJDnsg0HX9OScE43/QxlsTcLOYjs=;
  b=UJP/OC/2KaLR5AWSQouaN1Gn86vjq8OiJlF4rj4czHPCzl1W20K28/yj
   E48d3/mnsQq9MGhMPHzQhwRhrS6Y9ylFqNVpHBMnlQzakcyonIljuzsw2
   /Wlm3MGAXM1oMtPb2hLe8UQuNX3atEIBNZ9vkcedVhvpUGBy4ergUvyFX
   USfbcdLREcD1wZsXsiZkkCqkqs3CEOdeqtxwb/KkLBc1nYuLP1tD28tAR
   WclN2XblDZRwtPIi/cwTw74EfMRQWhqcVg5SJNkZoebwdvVUp/h9Mi/k8
   UV1rn/PnmsWXLJovpJLIVBzc1DbLDpUNsAlV4eHBj+wSiX16F1JMgMiJl
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10350"; a="271371030"
X-IronPort-AV: E=Sophos;i="5.91,233,1647327600"; 
   d="scan'208";a="271371030"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2022 09:50:57 -0700
X-IronPort-AV: E=Sophos;i="5.91,233,1647327600"; 
   d="scan'208";a="672939443"
Received: from abhuwalk-mobl1.amr.corp.intel.com (HELO spandruv-desk1.amr.corp.intel.com) ([10.212.246.60])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2022 09:50:55 -0700
Message-ID: <7b1a9f3b5b5087f47bf4839858c7bfebdb60aa2f.camel@linux.intel.com>
Subject: Re: [PATCH v2 01/14] thermal/core: Change thermal_zone_ops to
 thermal_sensor_ops
From:   srinivas pandruvada <srinivas.pandruvada@linux.intel.com>
To:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linexp.org>
Cc:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Alexandre Bailon <abailon@baylibre.com>,
        Linux PM <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Amit Kucheria <amitk@kernel.org>,
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
        Niklas =?ISO-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund@ragnatech.se>,
        Miri Korenblit <miriam.rachel.korenblit@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sumeet Pawnikar <sumeet.r.pawnikar@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Chuansheng Liu <chuansheng.liu@intel.com>,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Antoine Tenart <atenart@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
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
Date:   Tue, 17 May 2022 09:50:54 -0700
In-Reply-To: <CAJZ5v0ik_JQ4Awtw7iR68W4-9ZL8FRDsDd-kWmL-n09fgg3reg@mail.gmail.com>
References: <20220507125443.2766939-1-daniel.lezcano@linexp.org>
         <20220507125443.2766939-2-daniel.lezcano@linexp.org>
         <CAJZ5v0ik_JQ4Awtw7iR68W4-9ZL8FRDsDd-kWmL-n09fgg3reg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-05-17 at 17:42 +0200, Rafael J. Wysocki wrote:
> On Sat, May 7, 2022 at 2:55 PM Daniel Lezcano
> <daniel.lezcano@linexp.org> wrote:
> > 
> > A thermal zone is software abstraction of a sensor associated with
> > properties and cooling devices if any.
> > 
> > The fact that we have thermal_zone and thermal_zone_ops mixed is
> > confusing and does not clearly identify the different components
> > entering in the thermal management process. A thermal zone appears
> > to
> > be a sensor while it is not.
> 
> Well, the majority of the operations in thermal_zone_ops don't apply
> to thermal sensors.  For example, ->set_trips(), ->get_trip_type(),
> ->get_trip_temp().
> 
In past we discussed adding thermal sensor sysfs with threshold to
notify temperature.

So sensor can have set/get_threshold() functions instead of the
set/get_trip for zones.

Like we have /sys/class/thermal_zone* we can have
/sys/class/thermal_sensor*.

Thermal sensor(s) are bound to  thermal zones. This can also include
multiple sensors in a zone and can create a virtual sensor also.

Thanks,
Srinivas

> > In order to set the scene for multiple thermal sensors aggregated
> > into
> > a single thermal zone. Rename the thermal_zone_ops to
> > thermal_sensor_ops, that will appear clearyl the thermal zone is
> > not a
> > sensor but an abstraction of one [or multiple] sensor(s).
> 
> So I'm not convinced that the renaming mentioned above is
> particularly
> clean either.
> 
> IMV the way to go would be to split the thermal sensor operations,
> like ->get_temp(), out of thermal_zone_ops.
> 
> But then it is not clear what a thermal zone with multiple sensors in
> it really means.  I guess it would require an aggregation function to
> combine the thermal sensors in it that would produce an effective
> temperature to check against the trip points.
> 
> Honestly, I don't think that setting a separate set of trips for each
> sensor in a thermal zone would make a lot of sense.

