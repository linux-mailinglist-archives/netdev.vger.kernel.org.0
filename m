Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E5636BBA7F
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 18:08:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232269AbjCORIN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 13:08:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231127AbjCORII (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 13:08:08 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FBA07A917;
        Wed, 15 Mar 2023 10:07:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678900070; x=1710436070;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=wlFjJ+rq4ry10mllsndB33ENFH6j1f+xx7sS9iYKEIw=;
  b=CH9d9YSYPlDwvUAJNc/onov0Md3PtjTiaLW2kaDvYz99IPfbSbu8mXYX
   Qa8v0RFoPS2+7OPRDKNS/+7KIOeSireqxBRchE502eW181dtNWA7LMREB
   ajkB72dQxU+CmkSloEapCVXDWbzjyTKoJ0MGuVFgt7loxBgZRE2gmkkGZ
   4aYfhIV6g2nkCHGrbAlsAGO660J0qDPNYya8uunzOcoCgtMgQQ2H5ZIcM
   PY4LmAKNS6q9LuQJOIeS2QcRyQVPMWJe1IVLNxUzSH3OTqKCB0DXyn96+
   3/bGgKE8y+BCWVkDZziNoL4gMTp1hofK21l7lePAcnlARZ34EjcOtG2Mq
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="318165200"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="318165200"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 10:07:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="743780917"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="743780917"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga008.fm.intel.com with ESMTP; 15 Mar 2023 10:07:46 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1pcUbH-003xoA-2l;
        Wed, 15 Mar 2023 19:07:43 +0200
Date:   Wed, 15 Mar 2023 19:07:43 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v6 1/1] net: dsa: hellcreek: Get rid of custom
 led_init_default_state_get()
Message-ID: <ZBH7X8ng8Ji4Bma7@smile.fi.intel.com>
References: <20230314181824.56881-1-andriy.shevchenko@linux.intel.com>
 <ZBFeUazA9X9mmWiJ@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZBFeUazA9X9mmWiJ@localhost.localdomain>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 06:57:37AM +0100, Michal Swiatkowski wrote:
> On Tue, Mar 14, 2023 at 08:18:24PM +0200, Andy Shevchenko wrote:

...

> You have to fix implict declaration of the led_init_default_state_get().

FWIW, I have spent more than a couple of hours on this and have no idea
how it's even possible. If there is a bug it must have been reproduced
without my patch.

-- 
With Best Regards,
Andy Shevchenko


