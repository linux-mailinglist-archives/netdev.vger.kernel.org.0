Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A39D2BBA58
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 00:49:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728412AbgKTXsN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 18:48:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726640AbgKTXsM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 18:48:12 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A662C0613CF;
        Fri, 20 Nov 2020 15:48:12 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id a15so11267375edy.1;
        Fri, 20 Nov 2020 15:48:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CyKAPxvMiczHwzRvYIDIEmLvOjkahE2iThwjzTWMcNM=;
        b=QB5ILDjqliOWl7IGgOprLh/zl7eIyoqodmchzjouywoX5puth2HmkiHpTYN5w/TuIp
         AmcPia8art/Cb26pTF2wDVVLYFBKlY1Jf5S6grkFtSqgSLxKI9n3rFAbBeL1eVLODeWr
         yYf9ct7BEfC3hM8W4YP8374F68modUAKpEPN/GDb/6waYjjLZTcSKPjrvL/lSQwlEbPv
         sieTRjYm6p+jrY4qg1TuXRz/B0WkYsD3twbZrzO9CCKYTOOzRsQPajoOKFHOKwPvgkGK
         wQ6lDj+4iTchKWhsGL/qfo4zdmW7piSL9XFFAEsSClFxfS6o4q/fTidoOILedNcOfAhs
         Pi9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CyKAPxvMiczHwzRvYIDIEmLvOjkahE2iThwjzTWMcNM=;
        b=SzdNwm7Noxn5Nm3ccU8XDhiiMhqtJcM2H/geV8i8WSFUL9AkCWbpYW9jzLZMyysno7
         FFHqQLTPcmPM2xTMAQg5xVxyPZvPYoNL8iM2yOCKqiHf1czQYCea4attj3jtfBufKEAT
         0MnMm3ABKRBevtZmfY2MbraBxiOez3zfL5kKVACZCfLW5NR7lFuxnGhDgRLJlNVu/NX/
         16Jtx6XG+G5icXZl3GRHqjJJar9SyjWZAhQiWWYqbJVAhm/h9vMRUGiaAetm0kXnuLPO
         kxbyWsOwlJSSERr5JTLxOLGQpPbXtIbQf0ud3xsd2Eh2WrwO9KC5yev0j9gL0eflB7pz
         9YsQ==
X-Gm-Message-State: AOAM531BgZcoEtEjrsAPsoxDrIsQiK0++jnwfAZx1jlzmtbmlatYukUm
        ob4N+x7QwSNmfLKBDt5zpWM=
X-Google-Smtp-Source: ABdhPJz7xnL/Gpl4xnShu57nlQxmS2wMPwaiX+0mSoBISVtgfNmDPFqeD+rGz83ZVLQ9VeiELOCysg==
X-Received: by 2002:a05:6402:b35:: with SMTP id bo21mr39651519edb.52.1605916090763;
        Fri, 20 Nov 2020 15:48:10 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id gn41sm910465ejc.32.2020.11.20.15.48.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 15:48:09 -0800 (PST)
Date:   Sat, 21 Nov 2020 01:48:08 +0200
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
Subject: Re: [PATCH net-next v3 12/12] net: dsa: microchip: ksz9477: add
 periodic output support
Message-ID: <20201120234808.q4qvxpuj6akuev6h@skbuf>
References: <20201118203013.5077-1-ceggers@arri.de>
 <20201118203013.5077-13-ceggers@arri.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201118203013.5077-13-ceggers@arri.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 18, 2020 at 09:30:13PM +0100, Christian Eggers wrote:
> The KSZ9563 has a Trigger Output Unit (TOU) which can be used to
> generate periodic signals.
> 
> The pulse length can be altered via a device attribute.
> 
> Tested on a Microchip KSZ9563 switch.
> 
> Signed-off-by: Christian Eggers <ceggers@arri.de>
> ---
>  drivers/net/dsa/microchip/ksz9477_ptp.c | 197 +++++++++++++++++++++++-
>  drivers/net/dsa/microchip/ksz_common.h  |   5 +
>  2 files changed, 201 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/microchip/ksz9477_ptp.c b/drivers/net/dsa/microchip/ksz9477_ptp.c
> index ce3fdc9a1f9e..3174574d52f6 100644
> --- a/drivers/net/dsa/microchip/ksz9477_ptp.c
> +++ b/drivers/net/dsa/microchip/ksz9477_ptp.c
> @@ -90,6 +90,20 @@ static int ksz9477_ptp_tou_cycle_count_set(struct ksz_device *dev, u16 count)
>  	return 0;
>  }
>  
> +static int ksz9477_ptp_tou_pulse_verify(u64 pulse_ns)
> +{
> +	u32 data;
> +
> +	if (pulse_ns & 0x3)
> +		return -EINVAL;
> +
> +	data = (pulse_ns / 8);
> +	if (data != (data & TRIG_PULSE_WIDTH_M))
> +		return -ERANGE;
> +
> +	return 0;
> +}
> +
>  static int ksz9477_ptp_tou_pulse_set(struct ksz_device *dev, u32 pulse_ns)
>  {
>  	u32 data;
> @@ -196,6 +210,7 @@ static int ksz9477_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
>  	return ret;
>  }
>  
> +static int ksz9477_ptp_restart_perout(struct ksz_device *dev);
>  static int ksz9477_ptp_enable_pps(struct ksz_device *dev, int on);
>  
>  static int ksz9477_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
> @@ -241,6 +256,15 @@ static int ksz9477_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
>  	case KSZ_PTP_TOU_IDLE:
>  		break;
>  
> +	case KSZ_PTP_TOU_PEROUT:
> +		dev_info(dev->dev, "Restarting periodic output signal\n");

Isn't this a bit too verbose, or is there something for the user to be
concerned about?

> +
> +		ret = ksz9477_ptp_restart_perout(dev);
> +		if (ret)
> +			goto error_return;
> +
> +		break;
> +
>  	case KSZ_PTP_TOU_PPS:
>  		dev_info(dev->dev, "Restarting PPS\n");
>  
> @@ -358,6 +382,15 @@ static int ksz9477_ptp_settime(struct ptp_clock_info *ptp,
>  	case KSZ_PTP_TOU_IDLE:
>  		break;
>  
> +	case KSZ_PTP_TOU_PEROUT:
> +		dev_info(dev->dev, "Restarting periodic output signal\n");
> +
> +		ret = ksz9477_ptp_restart_perout(dev);
> +		if (ret)
> +			goto error_return;
> +
> +		break;
> +
>  	case KSZ_PTP_TOU_PPS:
>  		dev_info(dev->dev, "Restarting PPS\n");
>  
> @@ -377,6 +410,159 @@ static int ksz9477_ptp_settime(struct ptp_clock_info *ptp,
>  	return ret;
>  }
>  
> +static int ksz9477_ptp_configure_perout(struct ksz_device *dev, u32 cycle_width_ns,

Watch out for 80 characters, please!

> +					u16 cycle_count, u32 pulse_width_ns,
> +					struct timespec64 const *target_time)
> +{
> +	int ret;
> +	u32 trig_ctrl;

Reverse Christmas tree.

> +
> +	/* Enable notify, set rising edge, set periodic pattern */
> +	trig_ctrl = TRIG_NOTIFY | (TRIG_POS_PERIOD << TRIG_PATTERN_S);
> +	ret = ksz_write32(dev, REG_TRIG_CTRL__4, trig_ctrl);
> +	if (ret)
> +		return ret;
> +
> +	ret = ksz9477_ptp_tou_cycle_width_set(dev, cycle_width_ns);
> +	if (ret)
> +		return ret;
> +
> +	ksz9477_ptp_tou_cycle_count_set(dev,  cycle_count);
> +	if (ret)
> +		return ret;
> +
> +	ret = ksz9477_ptp_tou_pulse_set(dev, pulse_width_ns);
> +	if (ret)
> +		return ret;
> +
> +	ret = ksz9477_ptp_tou_target_time_set(dev, target_time);
> +	if (ret)
> +		return ret;
> +
> +	return 0;
> +}
> +
> +static int ksz9477_ptp_enable_perout(struct ksz_device *dev,
> +				     struct ptp_perout_request const *perout_request, int on)
> +{
> +	u32 gpio_stat0;
> +	u64 cycle_width_ns;
> +	int ret;
> +
> +	if (dev->ptp_tou_mode != KSZ_PTP_TOU_PEROUT && dev->ptp_tou_mode != KSZ_PTP_TOU_IDLE)
> +		return -EBUSY;
> +
> +	ret = ksz9477_ptp_tou_reset(dev, 0);
> +	if (ret)
> +		return ret;
> +
> +	if (!on) {
> +		dev->ptp_tou_mode = KSZ_PTP_TOU_IDLE;
> +		return 0;  /* success */
> +	}
> +
> +	dev->ptp_perout_target_time_first.tv_sec  = perout_request->start.sec;
> +	dev->ptp_perout_target_time_first.tv_nsec = perout_request->start.nsec;
> +
> +	dev->ptp_perout_period.tv_sec = perout_request->period.sec;
> +	dev->ptp_perout_period.tv_nsec = perout_request->period.nsec;
> +
> +	cycle_width_ns = timespec64_to_ns(&dev->ptp_perout_period);
> +	if ((cycle_width_ns & GENMASK(31, 0)) != cycle_width_ns)
> +		return -EINVAL;
> +
> +	if (perout_request->flags & PTP_PEROUT_DUTY_CYCLE) {
> +		u64 value = perout_request->on.sec * NSEC_PER_SEC +
> +			    perout_request->on.nsec;
> +
> +		ret = ksz9477_ptp_tou_pulse_verify(value);
> +		if (ret)
> +			return ret;
> +
> +		dev->ptp_perout_pulse_width_ns = value;
> +	}

It is not guaranteed that user space will set this flag. Shouldn't you
assign a default value for the pulse width? I don't know, half the
period should be a good default.

Also, please reject PTP_PEROUT_ONE_SHOT and PTP_PEROUT_PHASE, since you
don't do anything with them, but user space might be led into believing
otherwise.

> +
> +	ret = ksz9477_ptp_configure_perout(dev, cycle_width_ns,
> +					   dev->ptp_perout_cycle_count,
> +					   dev->ptp_perout_pulse_width_ns,
> +					   &dev->ptp_perout_target_time_first);
> +	if (ret)
> +		return ret;
> +
> +	/* Activate trigger unit */
> +	ret = ksz9477_ptp_tou_start(dev, NULL);
> +	if (ret)
> +		return ret;
> +
> +	/* Check error flag:
> +	 * - the ACTIVE flag is NOT cleared an error!
> +	 */
> +	ret = ksz_read32(dev, REG_PTP_TRIG_STATUS__4, &gpio_stat0);
> +	if (ret)
> +		return ret;
> +
> +	if (gpio_stat0 & (1 << (0 + TRIG_ERROR_S))) {

What is the role of this "0 +" term here?

> +		dev_err(dev->dev, "%s: Trigger unit0 error!\n", __func__);
> +		ret = -EIO;
> +		/* Unit will be reset on next access */
> +		return ret;
> +	}
> +
> +	dev->ptp_tou_mode = KSZ_PTP_TOU_PEROUT;
> +	return 0;
> +}
