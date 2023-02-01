Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12899686E56
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 19:45:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232079AbjBASpf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 13:45:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbjBASpe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 13:45:34 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD07444B9;
        Wed,  1 Feb 2023 10:45:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675277133; x=1706813133;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=p19pyjzp1EFUDT4hqnHuCHOq5ka+SXwLrgOqQTw0ekU=;
  b=bz9fowcTEK1P5mt8bHzgQS7U99CGkyzVAZFTayAxsENSoX8UajGdxQ1N
   jJ9DElRaqy9KhvxFt+hMtu9ajYVzs0IpDvwGMyK94TDRKsDK6P0ISafYZ
   7RWz9Cw/QoEWSxcHOWjkBP9LjFfOgS1rVLSbxbS/eCAfQYBsUV1CotkCR
   //zVzDo+JIEEVgLJARdyt8lzAH7ua5LDpM+iDRyAQJhhVeBRlyEkIERsy
   Vp0qnkAId7Zkka1Eqh05ARIKM8wCews0Y+rLY+bKhsokGX7SrjEqL2FE/
   5WTzZJUv8SKJfC94ew1p1UIWE8nougaXbNXJedo005ZJ71LDywlpsR53e
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10608"; a="316238243"
X-IronPort-AV: E=Sophos;i="5.97,265,1669104000"; 
   d="scan'208";a="316238243"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2023 10:45:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10608"; a="753778902"
X-IronPort-AV: E=Sophos;i="5.97,265,1669104000"; 
   d="scan'208";a="753778902"
Received: from smile.fi.intel.com ([10.237.72.54])
  by FMSMGA003.fm.intel.com with ESMTP; 01 Feb 2023 10:45:08 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1pNI6U-000pnk-0y;
        Wed, 01 Feb 2023 20:45:06 +0200
Date:   Wed, 1 Feb 2023 20:45:06 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Stefan Schmidt <stefan@datenfreihafen.org>
Cc:     Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Arnd Bergmann <arnd@kernel.org>,
        Alexander Aring <alex.aring@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        linux-wpan@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] [v2] at86rf230: convert to gpio descriptors
Message-ID: <Y9qzMplAeEGSH1SW@smile.fi.intel.com>
References: <20230126162323.2986682-1-arnd@kernel.org>
 <CAKdAkRQT_Jk5yBeMZqh=M1JscVLFieZTQjLGOGxy8nHh8SnD3A@mail.gmail.com>
 <CAKdAkRSuDJgdsSQqy9Cc_eUYuOfFsLmBJ8Rd93uQhY6HV8nN4w@mail.gmail.com>
 <77b78287-a352-85ae-0c3d-c3837be9bf1d@datenfreihafen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <77b78287-a352-85ae-0c3d-c3837be9bf1d@datenfreihafen.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 01, 2023 at 01:42:37PM +0100, Stefan Schmidt wrote:
> On 01.02.23 01:50, Dmitry Torokhov wrote:

...

> Thanks for having another look at these patches.

+1 here. I dunno where I was when reviewing these changes...

-- 
With Best Regards,
Andy Shevchenko


