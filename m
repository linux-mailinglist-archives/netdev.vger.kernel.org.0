Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FAC64EBB5D
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 09:01:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243558AbiC3HCT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 03:02:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241845AbiC3HB5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 03:01:57 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 879A6DF484;
        Wed, 30 Mar 2022 00:00:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648623612; x=1680159612;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=a/yS06E/f5TlhFE99MfmA8gjZt8NoZmWScc2/+Gac5Y=;
  b=Kab4Gj2KqZ/uTuU+hBH93dJhAMs2RwDVp19DAwGfPHOgldPZoDcDP7/r
   ZXzW9UC84qQuHAJFU5Wkzvgn6oxO4chjZb83ZEhLEusb5nStVN2KtmnG+
   DetFxe2EBcvyKxOL5iQZtGHGuMwEaZuGdAmDlELJ8cjAH5N/iPxLR3FgC
   NfVNaI46e5pKfPGBpU8Gk29YeJZEsZRFId505tw9oMEpsUgu3GfAJ51Ch
   Q+2yqNW7E/AveLwBlkdzJtpeP3SSZsJIbc+v2+8CLZJNp/VCGfm6FPYkj
   5BckXYOoDj5xnhxZ9H7ktKwmjRikcszTCeZD+ZQm2DdaIuT8spfvKIL4+
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10301"; a="258293974"
X-IronPort-AV: E=Sophos;i="5.90,222,1643702400"; 
   d="scan'208";a="258293974"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2022 00:00:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,222,1643702400"; 
   d="scan'208";a="565346120"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.135])
  by orsmga008.jf.intel.com with ESMTP; 30 Mar 2022 00:00:05 -0700
Date:   Wed, 30 Mar 2022 14:52:51 +0800
From:   Xu Yilun <yilun.xu@intel.com>
To:     Michael Walle <michael@walle.cc>
Cc:     Tom Rix <trix@redhat.com>, Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-hwmon@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 2/5] hwmon: intel-m10-bmc-hwmon: use
 devm_hwmon_sanitize_name()
Message-ID: <20220330065251.GB212503@yilunxu-OptiPlex-7050>
References: <20220329160730.3265481-1-michael@walle.cc>
 <20220329160730.3265481-3-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220329160730.3265481-3-michael@walle.cc>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 29, 2022 at 06:07:27PM +0200, Michael Walle wrote:
> Instead of open-coding the bad characters replacement in the hwmon name,
> use the new devm_hwmon_sanitize_name().
> 
> Signed-off-by: Michael Walle <michael@walle.cc>

Acked-by: Xu Yilun <yilun.xu@intel.com>

> ---
>  drivers/hwmon/intel-m10-bmc-hwmon.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
> 
> diff --git a/drivers/hwmon/intel-m10-bmc-hwmon.c b/drivers/hwmon/intel-m10-bmc-hwmon.c
> index 7a08e4c44a4b..29370108fa1c 100644
> --- a/drivers/hwmon/intel-m10-bmc-hwmon.c
> +++ b/drivers/hwmon/intel-m10-bmc-hwmon.c
> @@ -515,7 +515,6 @@ static int m10bmc_hwmon_probe(struct platform_device *pdev)
>  	struct intel_m10bmc *m10bmc = dev_get_drvdata(pdev->dev.parent);
>  	struct device *hwmon_dev, *dev = &pdev->dev;
>  	struct m10bmc_hwmon *hw;
> -	int i;
>  
>  	hw = devm_kzalloc(dev, sizeof(*hw), GFP_KERNEL);
>  	if (!hw)
> @@ -528,14 +527,10 @@ static int m10bmc_hwmon_probe(struct platform_device *pdev)
>  	hw->chip.info = hw->bdata->hinfo;
>  	hw->chip.ops = &m10bmc_hwmon_ops;
>  
> -	hw->hw_name = devm_kstrdup(dev, id->name, GFP_KERNEL);
> +	hw->hw_name = devm_hwmon_sanitize_name(dev, id->name);
>  	if (!hw->hw_name)
>  		return -ENOMEM;
>  
> -	for (i = 0; hw->hw_name[i]; i++)
> -		if (hwmon_is_bad_char(hw->hw_name[i]))
> -			hw->hw_name[i] = '_';
> -
>  	hwmon_dev = devm_hwmon_device_register_with_info(dev, hw->hw_name,
>  							 hw, &hw->chip, NULL);
>  	return PTR_ERR_OR_ZERO(hwmon_dev);
> -- 
> 2.30.2
