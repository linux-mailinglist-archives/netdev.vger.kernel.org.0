Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47D4A6EBA4F
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 18:26:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbjDVQ0W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Apr 2023 12:26:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbjDVQ0V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Apr 2023 12:26:21 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D24A1717;
        Sat, 22 Apr 2023 09:26:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682180780; x=1713716780;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Wd0xk5nKWuCk5lXjfaeBYT1AZ+9GeuONVnRjp/lX5Oc=;
  b=hvS0kUayzlpv0S5rckL9PxDalTVKf9WutfM8RpKCH9PnLvnBy4oNG1r4
   aMeGoW6RHiOXyfb3EhbasmMoEpyna+shwBPmXhUpY979z9c2G8gm/4GWI
   St24E0rIQApv81hvg1+I2Jfk3Mmu67iOkuznqOH9Ba5osaNqkspIubnIy
   TBfFvjsdZWq3tFkx3islC11cE9EBUZn8J1hfV7pjrKCLqhOvavdf4Fvgg
   kXSimgsjnIhgDk5vd03TObvxWq5agiu2v129KosoN0qw6aEsRWU8vEiUO
   QDqZz0tipd8uHQXGQ17aaKNCtZXcXLPIOgXWZzpui16HmkQT2C0Ib4Q0D
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10688"; a="335061487"
X-IronPort-AV: E=Sophos;i="5.99,218,1677571200"; 
   d="scan'208";a="335061487"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2023 09:26:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10688"; a="1022201661"
X-IronPort-AV: E=Sophos;i="5.99,218,1677571200"; 
   d="scan'208";a="1022201661"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga005.fm.intel.com with ESMTP; 22 Apr 2023 09:25:59 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1pqG3i-003fwC-07;
        Sat, 22 Apr 2023 19:25:58 +0300
Date:   Sat, 22 Apr 2023 19:25:57 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Jiawen Wu <jiawenwu@trustnetic.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, linux@armlinux.org.uk,
        jarkko.nikula@linux.intel.com, olteanv@gmail.com,
        hkallweit1@gmail.com, linux-i2c@vger.kernel.org,
        linux-gpio@vger.kernel.org, mengyuanlou@net-swift.com
Subject: Re: [PATCH net-next v4 2/8] i2c: designware: Add driver support for
 Wangxun 10Gb NIC
Message-ID: <ZEQKlSIIZi9941Bh@smile.fi.intel.com>
References: <20230422045621.360918-1-jiawenwu@trustnetic.com>
 <20230422045621.360918-3-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230422045621.360918-3-jiawenwu@trustnetic.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 22, 2023 at 12:56:15PM +0800, Jiawen Wu wrote:
> Wangxun 10Gb ethernet chip is connected to Designware I2C, to communicate
> with SFP.
> 
> Add platform data to pass IOMEM base address, board flag since resource
> address was mapped on ethernet driver. Since there is no device tree to
> get the clock, the parameters hcnt/lcnt are also set by platform data.
> 
> The exists IP limitations are dealt as workarounds:
> - IP does not support interrupt mode, it works on polling mode.
> - Additionally set FIFO depth address the chip issue.
> 
> Cc: Jarkko Nikula <jarkko.nikula@linux.intel.com>

Please, use --cc parameter to `git format-patch ...`.

Also for tag block we do not use blank lines.

...

>  #define MODEL_MSCC_OCELOT			BIT(8)
>  #define MODEL_BAIKAL_BT1			BIT(9)
>  #define MODEL_AMD_NAVI_GPU			BIT(10)
> +#define MODEL_WANGXUN_SP			BIT(11)
>  #define MODEL_MASK				GENMASK(11, 8)

Yeah, maybe next one will need to transform this from bitfield to plain number.

...

> -static int amd_i2c_adap_quirk(struct dw_i2c_dev *dev)
> +static int poll_i2c_adap_quirk(struct dw_i2c_dev *dev)

i2c_dw_poll_adap_quirk()

...

> +static bool i2c_is_model_poll(struct dw_i2c_dev *dev)

i2c_dw_is_...

...

> +++ b/include/linux/platform_data/i2c-dw.h

No way we need this in a new code.

> +struct dw_i2c_platform_data {
> +	void __iomem *base;

You should use regmap.

> +	unsigned int flags;
> +	unsigned int ss_hcnt;
> +	unsigned int ss_lcnt;
> +	unsigned int fs_hcnt;
> +	unsigned int fs_lcnt;

No, use device properties.

> +};

-- 
With Best Regards,
Andy Shevchenko


