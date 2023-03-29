Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 054776CD801
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 12:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbjC2K5e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 06:57:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbjC2K5d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 06:57:33 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AE1440D3;
        Wed, 29 Mar 2023 03:57:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680087449; x=1711623449;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=g8tmQkHSeufmVBcI3Dij8gMJLqulR4/uMzt+bIAphTY=;
  b=WWFi3NR4zqzkpjsIPXuwEqTN9gyHQ7Y2ej4uvYtcQQ9MaxnTTqNgHFbo
   SH8mQiQovKrxNBXyx/XAd5ztlru3VQ3UZ4ScH+cVIwf10uQ3jNPIRnJti
   Urnb/Gwagd4cNJCgFw7JP4vos/AfP8cywArrSOp//3SPPzOSoN4W4ufw7
   2S2+z/3tWAPg1an8wa4qHSziBJ/BPRTPQv4gqouhGKOuMdRKcNHVEd74U
   RgYdqRkD8xOXvMF07mAmYXu2rqSNovDfhovuGJikuWbaGS//BLe/VkKfV
   yD1U0ivnqvCwRaijpngMERpu8mbEGesYjyemIN3C9T9GTmrXllBkjHF83
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="342438759"
X-IronPort-AV: E=Sophos;i="5.98,300,1673942400"; 
   d="scan'208";a="342438759"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2023 03:57:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="661555266"
X-IronPort-AV: E=Sophos;i="5.98,300,1673942400"; 
   d="scan'208";a="661555266"
Received: from ijimenez-mobl1.ger.corp.intel.com ([10.252.51.67])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2023 03:57:25 -0700
Date:   Wed, 29 Mar 2023 13:57:19 +0300 (EEST)
From:   =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
To:     Tianfei Zhang <tianfei.zhang@intel.com>
cc:     richardcochran@gmail.com, Netdev <netdev@vger.kernel.org>,
        linux-fpga@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        vinicius.gomes@intel.com, pierre-louis.bossart@linux.intel.com,
        marpagan@redhat.com, Russ Weight <russell.h.weight@intel.com>,
        matthew.gerlach@linux.intel.com, nico@fluxnic.net,
        Raghavendra Khadatare <raghavendrax.anand.khadatare@intel.com>
Subject: Re: [PATCH v3] ptp: add ToD device driver for Intel FPGA cards
In-Reply-To: <20230328142455.481146-1-tianfei.zhang@intel.com>
Message-ID: <4c4a416d-605f-939-62e7-5f779dffbc73@linux.intel.com>
References: <20230328142455.481146-1-tianfei.zhang@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-177517658-1680087448=:2004"
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-177517658-1680087448=:2004
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

On Tue, 28 Mar 2023, Tianfei Zhang wrote:

> Adding a DFL (Device Feature List) device driver of ToD device for
> Intel FPGA cards.
> 
> The Intel FPGA Time of Day(ToD) IP within the FPGA DFL bus is exposed
> as PTP Hardware clock(PHC) device to the Linux PTP stack to synchronize
> the system clock to its ToD information using phc2sys utility of the
> Linux PTP stack. The DFL is a hardware List within FPGA, which defines
> a linked list of feature headers within the device MMIO space to provide
> an extensible way of adding subdevice features.
> 
> Signed-off-by: Raghavendra Khadatare <raghavendrax.anand.khadatare@intel.com>
> Signed-off-by: Tianfei Zhang <tianfei.zhang@intel.com>
> 
> ---
> v3:
> - add PTP_1588_CLOCK dependency for PTP_DFL_TOD in Kconfig file.
> - don't need handle NULL case for ptp_clock_register() after adding
>   PTP_1588_CLOCK dependency.
> - wrap the code at 80 characters.
> 
> v2:
> - handle NULL for ptp_clock_register().
> - use readl_poll_timeout_atomic() instead of readl_poll_timeout(), and
>   change the interval timeout to 10us.
> - fix the uninitialized variable.
> ---

> diff --git a/drivers/ptp/ptp_dfl_tod.c b/drivers/ptp/ptp_dfl_tod.c
> new file mode 100644
> index 000000000000..f699d541b360
> --- /dev/null
> +++ b/drivers/ptp/ptp_dfl_tod.c
> @@ -0,0 +1,332 @@
> +#include <linux/bitfield.h>
> +#include <linux/delay.h>
> +#include <linux/dfl.h>
> +#include <linux/gcd.h>
> +#include <linux/iopoll.h>
> +#include <linux/module.h>
> +#include <linux/ptp_clock_kernel.h>
> +#include <linux/spinlock.h>
> +#include <linux/units.h>

> +static int dfl_tod_probe(struct dfl_device *ddev)
> +{
> +	struct device *dev = &ddev->dev;
> +	struct dfl_tod *dt;
> +
> +	dt = devm_kzalloc(dev, sizeof(*dt), GFP_KERNEL);

+ #include <linux/device.h>

Other than that,

Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

-- 
 i.

--8323329-177517658-1680087448=:2004--
