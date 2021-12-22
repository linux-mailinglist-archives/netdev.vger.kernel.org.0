Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E069047D0E4
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 12:20:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244615AbhLVLUC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 06:20:02 -0500
Received: from mga14.intel.com ([192.55.52.115]:3030 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231187AbhLVLUB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Dec 2021 06:20:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640172001; x=1671708001;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=6+4R+FyB099Qr49bH3/1NFQGuuybyBlmj9/KUyRv5pE=;
  b=KUvAkD2dBUfsdSJb1mKBq3NSWLz2U7vqab7xUriGTBuvtzj2+XRkwfSR
   uj2+sz5kLxZSPyOwuf1HnufntQ2RW6lVixaSIIiWUaQL/jydxOTTrjqZ2
   DFyZtbxM28Dm2VVba3RxmtrpKww4N6VKTIZdNHukzxvCdnHdLTQjinnTk
   5usMOBKLbmZMotsxyRW5XXE8P6yEHxJuUIRl0buoweiJyxiKqNlo8Eria
   gXTLGLKuJSR6sSF5ZB1+K/X6B3XRkOrTLCe7/hdN8q+YU5KDK+Cr+9/B/
   /2km40F/OqSA/HG8hu87JPEMKuYN/RO9GO4POSnG50PdUxATgOOa8sKPa
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10205"; a="240823042"
X-IronPort-AV: E=Sophos;i="5.88,226,1635231600"; 
   d="scan'208";a="240823042"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2021 03:20:00 -0800
X-IronPort-AV: E=Sophos;i="5.88,226,1635231600"; 
   d="scan'208";a="484727047"
Received: from smile.fi.intel.com ([10.237.72.61])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2021 03:19:55 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1mzzdd-000jnv-Iv;
        Wed, 22 Dec 2021 13:18:29 +0200
Date:   Wed, 22 Dec 2021 13:18:29 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     "David E. Box" <david.e.box@linux.intel.com>
Cc:     gregkh@linuxfoundation.org, mustafa.ismail@intel.com,
        shiraz.saleem@intel.com, dledford@redhat.com, jgg@ziepe.ca,
        leon@kernel.org, saeedm@nvidia.com, davem@davemloft.net,
        kuba@kernel.org, vkoul@kernel.org, yung-chuan.liao@linux.intel.com,
        pierre-louis.bossart@linux.intel.com, mst@redhat.com,
        jasowang@redhat.com, hdegoede@redhat.com,
        virtualization@lists.linux-foundation.org,
        alsa-devel@alsa-project.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH 2/4] soundwire: intel: Use auxiliary_device driver data
 helpers
Message-ID: <YcMJhXQNXabezOya@smile.fi.intel.com>
References: <20211221235852.323752-1-david.e.box@linux.intel.com>
 <20211221235852.323752-3-david.e.box@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211221235852.323752-3-david.e.box@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 21, 2021 at 03:58:50PM -0800, David E. Box wrote:
> Use auxiliary_get_drvdata and auxiliary_set_drvdata helpers.

Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

> Signed-off-by: David E. Box <david.e.box@linux.intel.com>
> ---
>  drivers/soundwire/intel.c      | 8 ++++----
>  drivers/soundwire/intel_init.c | 2 +-
>  2 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/soundwire/intel.c b/drivers/soundwire/intel.c
> index 78037ffdb09b..d082d18e41a9 100644
> --- a/drivers/soundwire/intel.c
> +++ b/drivers/soundwire/intel.c
> @@ -1293,7 +1293,7 @@ static int intel_link_probe(struct auxiliary_device *auxdev,
>  	bus->ops = &sdw_intel_ops;
>  
>  	/* set driver data, accessed by snd_soc_dai_get_drvdata() */
> -	dev_set_drvdata(dev, cdns);
> +	auxiliary_set_drvdata(auxdev, cdns);
>  
>  	/* use generic bandwidth allocation algorithm */
>  	sdw->cdns.bus.compute_params = sdw_compute_params;
> @@ -1321,7 +1321,7 @@ int intel_link_startup(struct auxiliary_device *auxdev)
>  {
>  	struct sdw_cdns_stream_config config;
>  	struct device *dev = &auxdev->dev;
> -	struct sdw_cdns *cdns = dev_get_drvdata(dev);
> +	struct sdw_cdns *cdns = auxiliary_get_drvdata(auxdev);
>  	struct sdw_intel *sdw = cdns_to_intel(cdns);
>  	struct sdw_bus *bus = &cdns->bus;
>  	int link_flags;
> @@ -1463,7 +1463,7 @@ int intel_link_startup(struct auxiliary_device *auxdev)
>  static void intel_link_remove(struct auxiliary_device *auxdev)
>  {
>  	struct device *dev = &auxdev->dev;
> -	struct sdw_cdns *cdns = dev_get_drvdata(dev);
> +	struct sdw_cdns *cdns = auxiliary_get_drvdata(auxdev);
>  	struct sdw_intel *sdw = cdns_to_intel(cdns);
>  	struct sdw_bus *bus = &cdns->bus;
>  
> @@ -1488,7 +1488,7 @@ int intel_link_process_wakeen_event(struct auxiliary_device *auxdev)
>  	void __iomem *shim;
>  	u16 wake_sts;
>  
> -	sdw = dev_get_drvdata(dev);
> +	sdw = auxiliary_get_drvdata(auxdev);
>  	bus = &sdw->cdns.bus;
>  
>  	if (bus->prop.hw_disabled || !sdw->startup_done) {
> diff --git a/drivers/soundwire/intel_init.c b/drivers/soundwire/intel_init.c
> index e329022e1669..d99807765dfe 100644
> --- a/drivers/soundwire/intel_init.c
> +++ b/drivers/soundwire/intel_init.c
> @@ -244,7 +244,7 @@ static struct sdw_intel_ctx
>  			goto err;
>  
>  		link = &ldev->link_res;
> -		link->cdns = dev_get_drvdata(&ldev->auxdev.dev);
> +		link->cdns = auxiliary_get_drvdata(&ldev->auxdev);
>  
>  		if (!link->cdns) {
>  			dev_err(&adev->dev, "failed to get link->cdns\n");
> -- 
> 2.25.1
> 

-- 
With Best Regards,
Andy Shevchenko


