Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02D4E5B7923
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 20:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231872AbiIMSHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 14:07:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231370AbiIMSHN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 14:07:13 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBC89C5C;
        Tue, 13 Sep 2022 10:11:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663089068; x=1694625068;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=eLee7VFB2i1ceBLF9tn9Hcf09OVD35DhU3XPQpEwR8Q=;
  b=Xk2XovAetQwKysJI4InYFil4Ovsh9BQEhAkEtTfcuWSSFSgiX7CdwaSD
   RoEZV5wvwaS7Vh2TqAtgi49096zVnS+mB/6wUV6vrZKkA2WbP+OwFQB6z
   G9sfo+X32Iwj9xKY+wgJW61GDw1VS9Fy+qFcHeAT2DAsj8sMWm7rz55ua
   FDV9+38tFr5UOD+md0v1KqGh26kEaDNj1XYluvcaw3U1xw5nQHkJ5rx8h
   Oqk4JP9IRg/UpJA3wiOhYXhIDjGjfnxv3wOhZ1EmZJcODtdh2lTdEMZNf
   PUggf7mmYek/XaDB7YInc72/VRMceMY3IsyFOzmacCKZ3c1g72EpByMFD
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10469"; a="359920022"
X-IronPort-AV: E=Sophos;i="5.93,313,1654585200"; 
   d="scan'208";a="359920022"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2022 10:11:05 -0700
X-IronPort-AV: E=Sophos;i="5.93,313,1654585200"; 
   d="scan'208";a="758871608"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2022 10:11:00 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1oY9R3-001quU-0X;
        Tue, 13 Sep 2022 20:10:57 +0300
Date:   Tue, 13 Sep 2022 20:10:56 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Raul E Rangel <rrangel@chromium.org>
Cc:     linux-acpi@vger.kernel.org, linux-input@vger.kernel.org,
        jingle.wu@emc.com.tw, mario.limonciello@amd.com, timvp@google.com,
        linus.walleij@linaro.org, hdegoede@redhat.com, rafael@kernel.org,
        Asmaa Mnebhi <asmaa@nvidia.com>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        "David S. Miller" <davem@davemloft.net>,
        David Thompson <davthompson@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, Len Brown <lenb@kernel.org>,
        Lu Wei <luwei32@huawei.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 05/13] gpiolib: acpi: Add wake_capable parameter to
 acpi_dev_gpio_irq_get_by
Message-ID: <YyC5oEH6NKCMTzzt@smile.fi.intel.com>
References: <20220912221317.2775651-1-rrangel@chromium.org>
 <20220912160931.v2.5.I4ff95ba7e884a486d7814ee888bf864be2ebdef4@changeid>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220912160931.v2.5.I4ff95ba7e884a486d7814ee888bf864be2ebdef4@changeid>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 12, 2022 at 04:13:09PM -0600, Raul E Rangel wrote:
> The ACPI spec defines the SharedAndWake and ExclusiveAndWake share type
> keywords. This is an indication that the GPIO IRQ can also be used as a
> wake source. This change exposes the wake_capable bit so drivers can
> correctly enable wake functionality instead of making an assumption.

...

> -	ret = acpi_dev_gpio_irq_get_by(ACPI_COMPANION(dev), "irq-gpios", 0);
> +	ret = acpi_dev_gpio_irq_get_by(ACPI_COMPANION(dev), "irq-gpios", 0,
> +				       NULL);
>  	if (ret < 0)
>  		return ret;

Looking at these changes, can't we first introduce

	int acpi_dev_gpio_irq_get_by_name(struct acpi_device *adev, const char *name);

convert users, and then add wake stuff to the basic function.
In such case you will make less invasive main part of the idea.

-- 
With Best Regards,
Andy Shevchenko


