Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 685422073F0
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 15:03:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403885AbgFXNDY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 09:03:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403871AbgFXNDY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 09:03:24 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFEEAC061573;
        Wed, 24 Jun 2020 06:03:22 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id x11so1035606plo.7;
        Wed, 24 Jun 2020 06:03:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=dCLZ+U35i3BBc0VsP7kxNNeVr+6A6X8zDlMWShLSK9E=;
        b=rTWb9o8YePBh4H5yAqfXW3C5BIL3UHR4iN6hkZh/4G5THmcJCds04eai+kKM958hhz
         8fHjfoOBbjFAH6wyTSgwSAlwtvsm2RpmmA652kCnUq/peM9QVearI32dDqR5y5Ov84in
         mJ6MHQkpWlRjsMqTxNZu0tvoZUMVOnFjAdneQh9gHeZT1oHIJxKL7I1npq60SgKSh4Y0
         a8H+lC9FhFDGkC4Eo/EO84SnnaNYBAuV9F1KC3OHQcrGGwfZ4LIxOqCybFpbMvO0jkdq
         XgoURoeIYWdlQqZpeHa0KmmIoi88Dc+iCDshtFM0R3mSXa7msa01O3lFaneOy04kn9Ak
         eYkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=dCLZ+U35i3BBc0VsP7kxNNeVr+6A6X8zDlMWShLSK9E=;
        b=jYdSYiMsnqg6fINDgCLOcajLd+yr0ivHP9ofrSw5prDk/Lg6ZoPCENm2QyJgsN8W26
         IM5zLz4MVkWtkzNr7UK9uy26Ww3AXDZK31687CJ7UMvaY7BJBIDAdReZJ/i/oPNP+yMb
         d86SRX4qTrsL8rCXYIcOECm5ATrLF/cQ4LKaQ8Em2K49jpPDWM7xZkfRv0mtggA0mxO6
         62tcOX5QpSdAyH9TLkNj5L6eod66EydXcwUoVOPdl2w7PsH6LjZmA9Xd14Alast8f93O
         O4dWTLZJvQNgYBmZV+wT/oYM69oodf4mNM50QHLMLjAyKYeFo0+YCDFwj5U2SSws9Oa7
         NmPg==
X-Gm-Message-State: AOAM531ut4KhbNis/8ciX1dLwBPw46kHBHoYi/X5hK9u2HuiJPPfkEmE
        ZyYzuBlQC12W9NI86JyJVzM=
X-Google-Smtp-Source: ABdhPJx4jW8/BqvZOIgGKAChu23t5B6/N/w+C2WadNJwU+IsOEp+eBti1WcPI9NojccjEIJJS8Mv9A==
X-Received: by 2002:a17:90a:ee95:: with SMTP id i21mr6423586pjz.77.1593003802252;
        Wed, 24 Jun 2020 06:03:22 -0700 (PDT)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id m3sm11718959pfk.171.2020.06.24.06.03.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 06:03:21 -0700 (PDT)
Date:   Wed, 24 Jun 2020 06:03:18 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [RFC PATCH 3/9] net: dsa: hellcreek: Add PTP clock support
Message-ID: <20200624130318.GD7247@localhost>
References: <20200618064029.32168-1-kurt@linutronix.de>
 <20200618064029.32168-4-kurt@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200618064029.32168-4-kurt@linutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 18, 2020 at 08:40:23AM +0200, Kurt Kanzenbach wrote:

> diff --git a/drivers/net/dsa/hirschmann/hellcreek.h b/drivers/net/dsa/hirschmann/hellcreek.h
> index a08a10cb5ab7..2d4422fd2567 100644
> --- a/drivers/net/dsa/hirschmann/hellcreek.h
> +++ b/drivers/net/dsa/hirschmann/hellcreek.h
> @@ -234,10 +234,17 @@ struct hellcreek_fdb_entry {
>  struct hellcreek {
>  	struct device *dev;
>  	struct dsa_switch *ds;
> +	struct ptp_clock *ptp_clock;
> +	struct ptp_clock_info ptp_clock_info;
>  	struct hellcreek_port ports[4];
> +	struct delayed_work overflow_work;
>  	spinlock_t reg_lock;	/* Switch IP register lock */
> +	spinlock_t ptp_lock;	/* PTP IP register lock */

Why use a spin lock and not a mutex?

>  	void __iomem *base;
> +	void __iomem *ptp_base;
>  	u8 *vidmbrcfg;		/* vidmbrcfg shadow */
> +	u64 seconds;		/* PTP seconds */
> +	u64 last_ts;		/* Used for overflow detection */
>  	size_t fdb_entries;
>  };

> +static int hellcreek_ptp_gettime(struct ptp_clock_info *ptp,
> +				 struct timespec64 *ts)
> +{
> +	struct hellcreek *hellcreek = ptp_to_hellcreek(ptp);
> +	u64 ns;
> +
> +	spin_lock(&hellcreek->ptp_lock);

Won't a mutex do here instead?

> +	ns = __hellcreek_ptp_gettime(hellcreek);
> +	spin_unlock(&hellcreek->ptp_lock);
> +
> +	*ts = ns_to_timespec64(ns);
> +
> +	return 0;
> +}

> +static int hellcreek_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
> +{
> +	struct hellcreek *hellcreek = ptp_to_hellcreek(ptp);
> +	u16 negative = 0, counth, countl;
> +	u32 count_val;
> +
> +	/* If the offset is larger than IP-Core slow offset resources. Don't
> +	 * concider slow adjustment. Rather, add the offset directly to the

consider

> +	 * current time
> +	 */
> +	if (abs(delta) > MAX_SLOW_OFFSET_ADJ) {
> +		struct timespec64 now, then = ns_to_timespec64(delta);
> +
> +		hellcreek_ptp_gettime(ptp, &now);
> +		now = timespec64_add(now, then);
> +		hellcreek_ptp_settime(ptp, &now);
> +
> +		return 0;
> +	}
> +
> +	if (delta < 0) {
> +		negative = 1;
> +		delta = -delta;
> +	}
> +
> +	/* 'count_val' does not exceed the maximum register size (2^30) */
> +	count_val = div_s64(delta, MAX_NS_PER_STEP);
> +
> +	counth = (count_val & 0xffff0000) >> 16;
> +	countl = count_val & 0xffff;
> +
> +	negative = (negative << 15) & 0x8000;
> +
> +	spin_lock(&hellcreek->ptp_lock);
> +
> +	/* Set offset write register */
> +	hellcreek_ptp_write(hellcreek, negative, PR_CLOCK_OFFSET_C);
> +	hellcreek_ptp_write(hellcreek, MAX_NS_PER_STEP, PR_CLOCK_OFFSET_C);
> +	hellcreek_ptp_write(hellcreek, MIN_CLK_CYCLES_BETWEEN_STEPS,
> +			    PR_CLOCK_OFFSET_C);
> +	hellcreek_ptp_write(hellcreek, countl,  PR_CLOCK_OFFSET_C);
> +	hellcreek_ptp_write(hellcreek, counth,  PR_CLOCK_OFFSET_C);
> +
> +	spin_unlock(&hellcreek->ptp_lock);
> +
> +	return 0;
> +}

> +int hellcreek_ptp_setup(struct hellcreek *hellcreek)
> +{
> +	u16 status;
> +
> +	/* Set up the overflow work */
> +	INIT_DELAYED_WORK(&hellcreek->overflow_work,
> +			  hellcreek_ptp_overflow_check);
> +
> +	/* Setup PTP clock */
> +	hellcreek->ptp_clock_info.owner = THIS_MODULE;
> +	snprintf(hellcreek->ptp_clock_info.name,
> +		 sizeof(hellcreek->ptp_clock_info.name),
> +		 dev_name(hellcreek->dev));
> +
> +	/* IP-Core can add up to 0.5 ns per 8 ns cycle, which means
> +	 * accumulator_overflow_rate shall not exceed 62.5 MHz (which adjusts
> +	 * the nominal frequency by 6.25%)
> +	 */
> +	hellcreek->ptp_clock_info.max_adj   = 62500000;
> +	hellcreek->ptp_clock_info.n_alarm   = 0;
> +	hellcreek->ptp_clock_info.n_pins    = 0;
> +	hellcreek->ptp_clock_info.n_ext_ts  = 0;
> +	hellcreek->ptp_clock_info.n_per_out = 0;
> +	hellcreek->ptp_clock_info.pps	    = 0;
> +	hellcreek->ptp_clock_info.adjfine   = hellcreek_ptp_adjfine;
> +	hellcreek->ptp_clock_info.adjtime   = hellcreek_ptp_adjtime;
> +	hellcreek->ptp_clock_info.gettime64 = hellcreek_ptp_gettime;
> +	hellcreek->ptp_clock_info.settime64 = hellcreek_ptp_settime;
> +	hellcreek->ptp_clock_info.enable    = hellcreek_ptp_enable;
> +
> +	hellcreek->ptp_clock = ptp_clock_register(&hellcreek->ptp_clock_info,
> +						  hellcreek->dev);
> +	if (IS_ERR(hellcreek->ptp_clock))
> +		return PTR_ERR(hellcreek->ptp_clock);

The ptp_clock_register() can also return NULL:

 * Returns a valid pointer on success or PTR_ERR on failure.  If PHC
 * support is missing at the configuration level, this function
 * returns NULL, and drivers are expected to gracefully handle that
 * case separately.

> +
> +	/* Enable the offset correction process, if no offset correction is
> +	 * already taking place
> +	 */
> +	status = hellcreek_ptp_read(hellcreek, PR_CLOCK_STATUS_C);
> +	if (!(status & PR_CLOCK_STATUS_C_OFS_ACT))
> +		hellcreek_ptp_write(hellcreek,
> +				    status | PR_CLOCK_STATUS_C_ENA_OFS,
> +				    PR_CLOCK_STATUS_C);
> +
> +	/* Enable the drift correction process */
> +	hellcreek_ptp_write(hellcreek, status | PR_CLOCK_STATUS_C_ENA_DRIFT,
> +			    PR_CLOCK_STATUS_C);
> +
> +	schedule_delayed_work(&hellcreek->overflow_work,
> +			      HELLCREEK_OVERFLOW_PERIOD);
> +
> +	return 0;
> +}

Thanks,
Richard
