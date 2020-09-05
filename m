Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB03525E930
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 19:03:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728390AbgIERDH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 13:03:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727875AbgIERDB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Sep 2020 13:03:01 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A86F4C061244
        for <netdev@vger.kernel.org>; Sat,  5 Sep 2020 10:03:01 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id b17so2316619pji.1
        for <netdev@vger.kernel.org>; Sat, 05 Sep 2020 10:03:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=qZBrG6jSkAZXW7zioyMRVCXVHRUrzrzJuakxtB45EN4=;
        b=Su53ERhkLIhtX0ciuTuNZuZ7zkLu6/puy1Dtg8780ZJbijI51iuYJEo9CTzEVgYhE8
         McSXDT3Bf6reBAMyIxQRsGFMJFQc5MEgyZ0YcMq1u5XZ0jQkCW2fE+cFxeBMkIq/Z5QR
         cWti+rg92D3Kv/6ABbZUv5cZ7rFZ3RgSaYUp5fj46sfqmGQKOO9I54cvG9QccdZInaXy
         BLM1pVjWY2O7VfJBWzRTK8GNRyW3T6LziLSwziLg/UWWkm1MPWLToxA0kfvb+lJ/e2Ku
         9awRxIPJ/Kp7yaWOa08eeMm+fALuVCMl82RjI/7qWMxKRMvNxMb7HtY19KPijGsd8/HB
         //iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=qZBrG6jSkAZXW7zioyMRVCXVHRUrzrzJuakxtB45EN4=;
        b=UibQjzOdH6sONdVFXp5vkjqCTkashSnqgvpPN5aWx1ZdRCft1nMcYeJGQ4wbYHHBI0
         aGfkQ+VC5EJyGq0WVbCuFbaQhhawdkMh+e18ujfMqMSx/7JTEfzXgaH73dfZCWlWQoI4
         XGIPS18foEFLr4gOkqB53cCSNG4oka4Y8zTaVGPb0xVXnYy86ikPPEDWKM0RDeLOD44a
         uuNdRSWOfqrDnneEYo11papQoIA42lJtvrcb1fgB/ODVS0s0XPRjT/rxuA/wlJNu9+HE
         WyVYwXyLO1caT8ClI4lGB5qtJ0nAAu2WkWzNNdtE0+J8eiQcL+KmB9YPYFr+ZBS+3tD8
         hPlw==
X-Gm-Message-State: AOAM530ZMhN9ekC9EMIKdYq/w4dsbvYPEPZC/Yv+ePvgbMx5MMdrUfsc
        JEZrQrQe3BvasUaBZym63LE=
X-Google-Smtp-Source: ABdhPJzd48Egc6na+eKewKINspHCHFq0RLNqEqcEdwmsis6nMQgFFwdO/GzPSTY/uGKhkQQ/AZjtig==
X-Received: by 2002:a17:90b:d89:: with SMTP id bg9mr12498344pjb.26.1599325380870;
        Sat, 05 Sep 2020 10:03:00 -0700 (PDT)
Received: from hoboy (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id w19sm10635190pfq.60.2020.09.05.10.02.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2020 10:03:00 -0700 (PDT)
Date:   Sat, 5 Sep 2020 10:02:58 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Matteo Croce <mcroce@redhat.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Sven Auhagen <sven.auhagen@voleatech.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 4/6] net: mvpp2: ptp: add TAI support
Message-ID: <20200905170258.GA30943@hoboy>
References: <20200904072828.GQ1551@shell.armlinux.org.uk>
 <E1kE6A3-00057k-8t@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1kE6A3-00057k-8t@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 04, 2020 at 08:29:27AM +0100, Russell King wrote:
> Add support for the TAI block in the mvpp2.2 hardware.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Acked-by: Richard Cochran <richardcochran@gmail.com>

A few minor questions/comments follow...

> diff --git a/drivers/net/ethernet/marvell/Kconfig b/drivers/net/ethernet/marvell/Kconfig
> index ef4f35ba077d..a599e44a36a8 100644
> --- a/drivers/net/ethernet/marvell/Kconfig
> +++ b/drivers/net/ethernet/marvell/Kconfig
> @@ -92,6 +92,12 @@ config MVPP2
>  	  This driver supports the network interface units in the
>  	  Marvell ARMADA 375, 7K and 8K SoCs.
>  
> +config MVPP2_PTP
> +	bool "Marvell Armada 8K Enable PTP support"
> +	depends on NETWORK_PHY_TIMESTAMPING
> +	depends on (PTP_1588_CLOCK = y && MVPP2 = y) || \
> +		   (PTP_1588_CLOCK && MVPP2 = m)

So I guess this incantation obviates the need for checking whether
ptp_clock_register() returns null?


> +static long mvpp22_tai_aux_work(struct ptp_clock_info *ptp)
> +{
> +	return 0;
> +}

Since this is a noop, you can leave 
	tai->caps.do_aux_work = mvpp22_tai_aux_work;
as null.

> +static void mvpp22_tai_set_step(struct mvpp2_tai *tai)
> +{
> +	void __iomem *base = tai->base;
> +	u32 nano, frac;
> +
> +	nano = upper_32_bits(tai->period);
> +	frac = lower_32_bits(tai->period);
> +
> +	/* As the fractional nanosecond is a signed offset, if the MSB (sign)
> +	 * bit is set, we have to increment the whole nanoseconds.
> +	 */
> +	if (frac >= 0x80000000)
> +		nano += 1;
> +
> +	mvpp2_tai_write(nano, base + MVPP22_TAI_TOD_STEP_NANO_CR);
> +	mvpp2_tai_write(frac >> 16, base + MVPP22_TAI_TOD_STEP_FRAC_HIGH);
> +	mvpp2_tai_write(frac, base + MVPP22_TAI_TOD_STEP_FRAC_LOW);
> +}
> +
> +static void mvpp22_tai_set_tod(struct mvpp2_tai *tai)
> +{
> +	struct timespec64 now;
> +
> +	ktime_get_real_ts64(&now);
> +	mvpp22_tai_settime64(&tai->caps, &now);
> +}
> +
> +static void mvpp22_tai_init(struct mvpp2_tai *tai)
> +{
> +	void __iomem *base = tai->base;
> +
> +	mvpp22_tai_set_step(tai);
> +
> +	/* Release the TAI reset */
> +	mvpp2_tai_modify(base + MVPP22_TAI_CR0, CR0_SW_NRESET, CR0_SW_NRESET);
> +
> +	mvpp22_tai_set_tod(tai);

The consensus on the list seems to be that new PHCs should start
ticking from time zero (1970), although some older drivers do use
ktime.  For new clocks, I'd prefer using zero.

> +}

Thanks,
Richard
