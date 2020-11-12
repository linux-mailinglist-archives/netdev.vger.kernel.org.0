Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F1152B12DD
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 00:47:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726143AbgKLXrU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 18:47:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725894AbgKLXrU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 18:47:20 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D473EC0613D1;
        Thu, 12 Nov 2020 15:47:19 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id v22so8514365edt.9;
        Thu, 12 Nov 2020 15:47:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lXeqN+RZgC4rnxXa5kUVVHNRIgkH8/pb6L8dmX3V+/Q=;
        b=VaMPVaEbldmBOCPJTurlQEPT3vna24cjZUp5o/ZT7kYzVi6LENldNP3wEEhKWuqy/F
         Qyk51bUnBAtFGWx67tn9oMKAOgxOKA5MnCaBomPZUr0vZHesYnzCZsM4ZDDrWgLLavPJ
         IsMuDsj8yeUQByabsPcvgu8rGM7wUJF/H7Rs9xILc3fAizDF13Et7FfKPuzWstM3np2g
         v5Nc9Rw/gqZPh/RH62JIv1jk2cWUeg/9ZbaYv+EMdUTQwUWEGWXpLau1bQUhEsnALx0h
         dAiZc5SjeREEC3b95NdehiPlwWd6m+i5R+JjNhiaJt+38+/SA6wfJIQdshMvTwxTe86J
         B9Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lXeqN+RZgC4rnxXa5kUVVHNRIgkH8/pb6L8dmX3V+/Q=;
        b=MturKqZplnhmWK8wv10hHlS5b31gupkV0Qm1XWKxF0wl0CyuCmxTyHRCkKuuGXNBfc
         5XANHGWBGjPSdyvrOR7YpHOvZCZjj2tGd65nVsc5+F2Ba65eAcz+VpdtBAXlklvWkGZf
         JgGyAU7VbzbwSknJSoytgkVXhapAeFBEWH1BA5/5EANqOpmpFQW9V25Pze4Bb+h5oMsv
         Y0ZsWSAMKC2ifqpHRLYFZlI/j9Sc/CxGKNz1UPdQ8/xuEXhVVUqU5yoYsKdGn9JId1Rb
         NkuXFhAOOF1ltm47eg8FCdQexEk+JXjZPSOset2NXsHw1SWXuPGhk+DeHvRuKCe4RZoe
         uowQ==
X-Gm-Message-State: AOAM5302zDSgg8+RaYQsGLmMFDwAiPMX5t75SM0vyx/+tNK6Hb/YZJHU
        ZSMKNJHjGVySST+gjfibxwU=
X-Google-Smtp-Source: ABdhPJwmcy6UwRW8cP+c1Yji0H8uYXiwly9AMrgIDs+rWcjtEXMiQRKGoDIYkEcXanCh7RNGWQYw4g==
X-Received: by 2002:a50:a105:: with SMTP id 5mr2484562edj.165.1605224838478;
        Thu, 12 Nov 2020 15:47:18 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id w18sm3033458edq.43.2020.11.12.15.47.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 15:47:17 -0800 (PST)
Date:   Fri, 13 Nov 2020 01:47:16 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Richard Cochran <richardcochran@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>,
        George McCollister <george.mccollister@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Helmut Grohne <helmut.grohne@intenta.de>,
        Paul Barker <pbarker@konsulko.com>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 07/11] net: dsa: microchip: ksz9477: add
 Posix clock support for chip PTP clock
Message-ID: <20201112234716.tkvjnkgxo236e6gv@skbuf>
References: <20201112153537.22383-1-ceggers@arri.de>
 <20201112153537.22383-8-ceggers@arri.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201112153537.22383-8-ceggers@arri.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 12, 2020 at 04:35:33PM +0100, Christian Eggers wrote:
> diff --git a/drivers/net/dsa/microchip/Kconfig b/drivers/net/dsa/microchip/Kconfig
> index 4ec6a47b7f72..71cc910e5941 100644
> --- a/drivers/net/dsa/microchip/Kconfig
> +++ b/drivers/net/dsa/microchip/Kconfig
> @@ -24,6 +24,15 @@ config NET_DSA_MICROCHIP_KSZ9477_SPI
>  	help
>  	  Select to enable support for registering switches configured through SPI.
>  
> +config NET_DSA_MICROCHIP_KSZ9477_PTP
> +	bool "PTP support for Microchip KSZ9477 series"
> +	default n

"default n" is implicit, please remove this

> +	depends on NET_DSA_MICROCHIP_KSZ9477
> +	depends on PTP_1588_CLOCK
> +	help
> +	  Say Y to enable PTP hardware timestamping on Microchip KSZ switch
> +	  chips that support it.
> +
>  menuconfig NET_DSA_MICROCHIP_KSZ8795
>  	tristate "Microchip KSZ8795 series switch support"
>  	depends on NET_DSA
> diff --git a/drivers/net/dsa/microchip/Makefile b/drivers/net/dsa/microchip/Makefile
> index c5cc1d5dea06..35c4356bad65 100644
> --- a/drivers/net/dsa/microchip/Makefile
> +++ b/drivers/net/dsa/microchip/Makefile
> @@ -2,6 +2,7 @@
>  obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ_COMMON)	+= ksz_common.o
>  obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ9477)		+= ksz9477.o
>  ksz9477-objs := ksz9477_main.o
> +ksz9477-$(CONFIG_NET_DSA_MICROCHIP_KSZ9477_PTP)	+= ksz9477_ptp.o
>  obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ9477_I2C)	+= ksz9477_i2c.o
>  obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ9477_SPI)	+= ksz9477_spi.o
>  obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ8795)		+= ksz8795.o
> diff --git a/drivers/net/dsa/microchip/ksz9477_i2c.c b/drivers/net/dsa/microchip/ksz9477_i2c.c
> index 4ed1f503044a..315eb24c444d 100644
> --- a/drivers/net/dsa/microchip/ksz9477_i2c.c
> +++ b/drivers/net/dsa/microchip/ksz9477_i2c.c
> @@ -58,7 +58,7 @@ static int ksz9477_i2c_remove(struct i2c_client *i2c)
>  {
>  	struct ksz_device *dev = i2c_get_clientdata(i2c);
>  
> -	ksz_switch_remove(dev);
> +	ksz9477_switch_remove(dev);
>  
>  	return 0;
>  }
> diff --git a/drivers/net/dsa/microchip/ksz9477_main.c b/drivers/net/dsa/microchip/ksz9477_main.c
> index 6b5a981fb21f..7d623400139f 100644
> --- a/drivers/net/dsa/microchip/ksz9477_main.c
> +++ b/drivers/net/dsa/microchip/ksz9477_main.c
> @@ -18,6 +18,7 @@
>  
>  #include "ksz9477_reg.h"
>  #include "ksz_common.h"
> +#include "ksz9477_ptp.h"
>  
>  /* Used with variable features to indicate capabilities. */
>  #define GBIT_SUPPORT			BIT(0)
> @@ -1719,10 +1720,26 @@ int ksz9477_switch_register(struct ksz_device *dev)
>  			phy_remove_link_mode(phydev,
>  					     ETHTOOL_LINK_MODE_1000baseT_Full_BIT);
>  	}
> +
> +	ret = ksz9477_ptp_init(dev);
> +	if (ret)
> +		goto error_switch_unregister;
> +
> +	return 0;
> +
> +error_switch_unregister:
> +	ksz_switch_remove(dev);
>  	return ret;
>  }
>  EXPORT_SYMBOL(ksz9477_switch_register);
>  
> +void ksz9477_switch_remove(struct ksz_device *dev)
> +{
> +	ksz9477_ptp_deinit(dev);
> +	ksz_switch_remove(dev);
> +}
> +EXPORT_SYMBOL(ksz9477_switch_remove);
> +
>  MODULE_AUTHOR("Woojung Huh <Woojung.Huh@microchip.com>");
>  MODULE_DESCRIPTION("Microchip KSZ9477 Series Switch DSA Driver");
>  MODULE_LICENSE("GPL");
> diff --git a/drivers/net/dsa/microchip/ksz9477_ptp.c b/drivers/net/dsa/microchip/ksz9477_ptp.c
> new file mode 100644
> index 000000000000..44d7bbdea518
> --- /dev/null
> +++ b/drivers/net/dsa/microchip/ksz9477_ptp.c
> @@ -0,0 +1,301 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Microchip KSZ9477 switch driver PTP routines
> + *
> + * Author: Christian Eggers <ceggers@arri.de>
> + *
> + * Copyright (c) 2020 ARRI Lighting
> + */
> +
> +#include <linux/ptp_clock_kernel.h>
> +
> +#include "ksz_common.h"
> +#include "ksz9477_reg.h"
> +
> +#include "ksz9477_ptp.h"
> +
> +#define KSZ_PTP_INC_NS 40  /* HW clock is incremented every 40 ns (by 40) */
> +#define KSZ_PTP_SUBNS_BITS 32  /* Number of bits in sub-nanoseconds counter */
> +
> +/* Posix clock support */
> +
> +static int ksz9477_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
> +{
> +	struct ksz_device *dev = container_of(ptp, struct ksz_device, ptp_caps);
> +	u16 data16;
> +	int ret;
> +
> +	if (scaled_ppm) {
> +		/* basic calculation:
> +		 * s32 ppb = scaled_ppm_to_ppb(scaled_ppm);
> +		 * s64 adj = div_s64(((s64)ppb * KSZ_PTP_INC_NS) << KSZ_PTP_SUBNS_BITS,
> +		 *                   NSEC_PER_SEC);
> +		 */
> +
> +		/* more precise calculation (avoids shifting out precision) */
> +		s64 ppb, adj;
> +		u32 data32;

Don't you want to move these declarations right beneath the "if" line?

> +
> +		/* see scaled_ppm_to_ppb() in ptp_clock.c for details */
> +		ppb = 1 + scaled_ppm;
> +		ppb *= 125;
> +		ppb *= KSZ_PTP_INC_NS;
> +		ppb <<= KSZ_PTP_SUBNS_BITS - 13;
> +		adj = div_s64(ppb, NSEC_PER_SEC);
> +
> +		data32 = abs(adj);
> +		data32 &= BIT_MASK(30) - 1;
> +		if (adj >= 0)
> +			data32 |= PTP_RATE_DIR;
> +
> +		ret = ksz_write32(dev, REG_PTP_SUBNANOSEC_RATE, data32);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	ret = ksz_read16(dev, REG_PTP_CLK_CTRL, &data16);
> +	if (ret)
> +		return ret;
> +
> +	if (scaled_ppm)
> +		data16 |= PTP_CLK_ADJ_ENABLE;
> +	else
> +		data16 &= ~PTP_CLK_ADJ_ENABLE;
> +
> +	ret = ksz_write16(dev, REG_PTP_CLK_CTRL, data16);
> +	if (ret)
> +		return ret;
> +
> +	return 0;
> +}
> +
> +static int ksz9477_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
> +{
> +	struct ksz_device *dev = container_of(ptp, struct ksz_device, ptp_caps);
> +	s32 sec, nsec;
> +	u16 data16;
> +	int ret;
> +
> +	mutex_lock(&dev->ptp_mutex);

You're skipping the mutex in ksz9477_ptp_adjfine, is that intentional or
just a proof that it's useless? You should add a comment at its
declaration site about what it's meant to protect.

> +
> +	/* do not use ns_to_timespec64(), both sec and nsec are subtracted by hw */
> +	sec = div_s64_rem(delta, NSEC_PER_SEC, &nsec);
> +
> +	ret = ksz_write32(dev, REG_PTP_RTC_NANOSEC, abs(nsec));
> +	if (ret)
> +		goto error_return;
> +
> +	/* contradictory to the data sheet, seconds are also considered */
> +	ret = ksz_write32(dev, REG_PTP_RTC_SEC, abs(sec));
> +	if (ret)
> +		goto error_return;
> +
> +	ret = ksz_read16(dev, REG_PTP_CLK_CTRL, &data16);
> +	if (ret)
> +		goto error_return;
> +
> +	data16 |= PTP_STEP_ADJ;
> +	if (delta < 0)
> +		data16 &= ~PTP_STEP_DIR;  /* 0: subtract */
> +	else
> +		data16 |= PTP_STEP_DIR;   /* 1: add */
> +
> +	ret = ksz_write16(dev, REG_PTP_CLK_CTRL, data16);
> +	if (ret)
> +		goto error_return;
> +
> +error_return:
> +	mutex_unlock(&dev->ptp_mutex);
> +	return ret;
> +}
> +
> +static int _ksz9477_ptp_gettime(struct ksz_device *dev, struct timespec64 *ts)
> +{
> +	u32 nanoseconds;
> +	u32 seconds;
> +	u16 data16;
> +	u8 phase;
> +	int ret;
> +
> +	/* Copy current PTP clock into shadow registers */
> +	ret = ksz_read16(dev, REG_PTP_CLK_CTRL, &data16);
> +	if (ret)
> +		return ret;
> +
> +	data16 |= PTP_READ_TIME;
> +
> +	ret = ksz_write16(dev, REG_PTP_CLK_CTRL, data16);
> +	if (ret)
> +		return ret;
> +
> +	/* Read from shadow registers */
> +	ret = ksz_read8(dev, REG_PTP_RTC_SUB_NANOSEC__2, &phase);
> +	if (ret)
> +		return ret;
> +	ret = ksz_read32(dev, REG_PTP_RTC_NANOSEC, &nanoseconds);
> +	if (ret)
> +		return ret;
> +	ret = ksz_read32(dev, REG_PTP_RTC_SEC, &seconds);
> +	if (ret)
> +		return ret;
> +
> +	ts->tv_sec = seconds;
> +	ts->tv_nsec = nanoseconds + phase * 8;
> +
> +	return 0;
> +}
> +
> +static int ksz9477_ptp_gettime(struct ptp_clock_info *ptp, struct timespec64 *ts)
> +{
> +	struct ksz_device *dev = container_of(ptp, struct ksz_device, ptp_caps);
> +	int ret;
> +
> +	mutex_lock(&dev->ptp_mutex);
> +	ret = _ksz9477_ptp_gettime(dev, ts);
> +	mutex_unlock(&dev->ptp_mutex);
> +
> +	return ret;
> +}
> +
> +static int ksz9477_ptp_settime(struct ptp_clock_info *ptp, struct timespec64 const *ts)
> +{
> +	struct ksz_device *dev = container_of(ptp, struct ksz_device, ptp_caps);
> +	u16 data16;
> +	int ret;
> +
> +	mutex_lock(&dev->ptp_mutex);
> +
> +	/* Write to shadow registers */
> +
> +	/* clock phase */
> +	ret = ksz_read16(dev, REG_PTP_RTC_SUB_NANOSEC__2, &data16);
> +	if (ret)
> +		goto error_return;
> +
> +	data16 &= ~PTP_RTC_SUB_NANOSEC_M;
> +
> +	ret = ksz_write16(dev, REG_PTP_RTC_SUB_NANOSEC__2, data16);
> +	if (ret)
> +		goto error_return;
> +
> +	/* nanoseconds */
> +	ret = ksz_write32(dev, REG_PTP_RTC_NANOSEC, ts->tv_nsec);
> +	if (ret)
> +		goto error_return;
> +
> +	/* seconds */
> +	ret = ksz_write32(dev, REG_PTP_RTC_SEC, ts->tv_sec);
> +	if (ret)
> +		goto error_return;
> +
> +	/* Load PTP clock from shadow registers */
> +	ret = ksz_read16(dev, REG_PTP_CLK_CTRL, &data16);
> +	if (ret)
> +		goto error_return;
> +
> +	data16 |= PTP_LOAD_TIME;
> +
> +	ret = ksz_write16(dev, REG_PTP_CLK_CTRL, data16);
> +	if (ret)
> +		goto error_return;
> +
> +error_return:
> +	mutex_unlock(&dev->ptp_mutex);
> +	return ret;
> +}
> +
> +static int ksz9477_ptp_enable(struct ptp_clock_info *ptp, struct ptp_clock_request *req, int on)
> +{
> +	return -ENOTTY;
> +}

How about -EOPNOTSUPP? I think -ENOTTY is reserved for "invalid ioctl on
the PTP clock", you wouldn't want to confuse a user into thinking that
they got the ioctls wrong (such as with the recent introduction of
PTP_PEROUT_REQUEST2 etc) when in fact the error comes from the driver.
