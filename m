Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37953222E16
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 23:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726201AbgGPVg1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 17:36:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725959AbgGPVg1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 17:36:27 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6CFCC061755
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 14:36:26 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id h28so5912847edz.0
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 14:36:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2jF7QbULHhlgBtpjxwVNi945HY5nKQLwNL8uGkUvM+c=;
        b=ng2aVOq0H8VA7aNUuzuRBf9AUTmTENdPCt7tfLgHdgDwP6o6CXsaYwA47tGDRFC8ML
         hlh8yj/o82WBnFE2NsryVe+JOtcTddgxrGKZGYP3Y7tJrz4fkznSXZ0icNsBifccubwX
         fUiceqL+on1ntFjVcj43089GynI/EA9jjU4oUkfxLzS8TfsgTJx4V+0+l08GXef8Gnza
         WcqwSCckDifMM4NMXhM9+3TLsv/yTEV7KJVp/HosTi5XASNw3Uco/W6mNPb+Kttq+ucM
         A3cwvNGS/d5IGoUjHz+oDBkVgk3PH+HuW0nRYvIbSfY3oYO9l7C7Mo3GuTnwbuqn6d6Z
         eraw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2jF7QbULHhlgBtpjxwVNi945HY5nKQLwNL8uGkUvM+c=;
        b=rrYPYoKaxkjTi4D3IaY4xRbc23l2IAH4MpB8SwmdGc2sSRPT15auM/O1gCBp7XFSha
         PQ9Z/wo3MwA/By4oLIXQ2a13gVzvnleam77i0VHj/FIQOCzEfzhDLWi2I82VBNjj7q5y
         zOSxnXivViOOenYP7kzplDatsnBUml38NdQlmaeE8iTNelYIYs+ASciNWzXDYPPTQAwS
         kUUhGUJ3an4dmW0ncPJBHjtSwOUSTo9f3X4GMhnszrcLYddkcF2W8pc9UXnZt6R8TZKZ
         BaeGMo5k1RPIaSXwMrsFr8vHO004Y5bNaq/U32UhZM0sy4fYUu00C6VbK27aQIL999N3
         duVA==
X-Gm-Message-State: AOAM5303trYiSiMyajS3Buellg7GmST2TBWuoSzL6j4GNvRWV8AEelW2
        v4QN/fG4ikplgWaAv861wbE=
X-Google-Smtp-Source: ABdhPJw3I4HtLBAgWCRQUoUbz+j1UtUoV5fDot8M8D5NGXOXtZxo4rP7bhbnfDuPi0Q3ydYFrkw3kw==
X-Received: by 2002:a50:e883:: with SMTP id f3mr6413566edn.220.1594935385030;
        Thu, 16 Jul 2020 14:36:25 -0700 (PDT)
Received: from skbuf ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id i22sm6091900eja.6.2020.07.16.14.36.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 14:36:24 -0700 (PDT)
Date:   Fri, 17 Jul 2020 00:36:22 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org
Cc:     richardcochran@gmail.com, jacob.e.keller@intel.com,
        yangbo.lu@nxp.com, xiaoliang.yang_1@nxp.com, po.liu@nxp.com,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next 3/3] net: mscc: ocelot: add support for PTP
 waveform configuration
Message-ID: <20200716213622.zlsmaz56io4d6vgl@skbuf>
References: <20200716212032.1024188-1-olteanv@gmail.com>
 <20200716212032.1024188-4-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200716212032.1024188-4-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 17, 2020 at 12:20:32AM +0300, Vladimir Oltean wrote:
> For PPS output (perout period is 1.000000000), accept the new "phase"
> parameter from the periodic output request structure.
> 
> For both PPS and freeform output, accept the new "on" argument for
> specifying the duty cycle of the generated signal. Preserve the old
> defaults for this "on" time: 1 us for PPS, and half the period for
> freeform output.
> 
> Also preserve the old behavior that accepted the "phase" via the "start"
> argument.
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> ---
>  drivers/net/ethernet/mscc/ocelot_ptp.c | 74 +++++++++++++++++---------
>  1 file changed, 50 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mscc/ocelot_ptp.c b/drivers/net/ethernet/mscc/ocelot_ptp.c
> index 62188772a75d..1e08fe4daaef 100644
> --- a/drivers/net/ethernet/mscc/ocelot_ptp.c
> +++ b/drivers/net/ethernet/mscc/ocelot_ptp.c
> @@ -184,18 +184,20 @@ int ocelot_ptp_enable(struct ptp_clock_info *ptp,
>  		      struct ptp_clock_request *rq, int on)
>  {
>  	struct ocelot *ocelot = container_of(ptp, struct ocelot, ptp_info);
> -	struct timespec64 ts_start, ts_period;
> +	struct timespec64 ts_phase, ts_period;
>  	enum ocelot_ptp_pins ptp_pin;
>  	unsigned long flags;
>  	bool pps = false;
>  	int pin = -1;
> +	s64 wf_high;
> +	s64 wf_low;
>  	u32 val;
> -	s64 ns;
>  
>  	switch (rq->type) {
>  	case PTP_CLK_REQ_PEROUT:
>  		/* Reject requests with unsupported flags */
> -		if (rq->perout.flags)
> +		if (rq->perout.flags & ~(PTP_PEROUT_DUTY_CYCLE |
> +					 PTP_PEROUT_PHASE))
>  			return -EOPNOTSUPP;
>  
>  		pin = ptp_find_pin(ocelot->ptp_clock, PTP_PF_PEROUT,
> @@ -211,22 +213,12 @@ int ocelot_ptp_enable(struct ptp_clock_info *ptp,
>  		else
>  			return -EBUSY;
>  
> -		ts_start.tv_sec = rq->perout.start.sec;
> -		ts_start.tv_nsec = rq->perout.start.nsec;
>  		ts_period.tv_sec = rq->perout.period.sec;
>  		ts_period.tv_nsec = rq->perout.period.nsec;
>  
>  		if (ts_period.tv_sec == 1 && ts_period.tv_nsec == 0)
>  			pps = true;
>  
> -		if (ts_start.tv_sec || (ts_start.tv_nsec && !pps)) {
> -			dev_warn(ocelot->dev,
> -				 "Absolute start time not supported!\n");
> -			dev_warn(ocelot->dev,
> -				 "Accept nsec for PPS phase adjustment, otherwise start time should be 0 0.\n");
> -			return -EINVAL;
> -		}
> -
>  		/* Handle turning off */
>  		if (!on) {
>  			spin_lock_irqsave(&ocelot->ptp_clock_lock, flags);
> @@ -236,16 +228,48 @@ int ocelot_ptp_enable(struct ptp_clock_info *ptp,
>  			break;
>  		}
>  
> +		if (rq->perout.flags & PTP_PEROUT_PHASE) {
> +			ts_phase.tv_sec = rq->perout.phase.sec;
> +			ts_phase.tv_nsec = rq->perout.phase.nsec;
> +		} else {
> +			/* Compatibility */
> +			ts_phase.tv_sec = rq->perout.start.sec;
> +			ts_phase.tv_nsec = rq->perout.start.nsec;
> +		}
> +		if (ts_phase.tv_sec || (ts_phase.tv_nsec && !pps)) {
> +			dev_warn(ocelot->dev,
> +				 "Absolute start time not supported!\n");
> +			dev_warn(ocelot->dev,
> +				 "Accept nsec for PPS phase adjustment, otherwise start time should be 0 0.\n");
> +			return -EINVAL;
> +		}
> +
> +		/* Calculate waveform high and low times */
> +		if (rq->perout.flags & PTP_PEROUT_DUTY_CYCLE) {
> +			struct timespec64 ts_on;
> +
> +			ts_on.tv_sec = rq->perout.on.sec;
> +			ts_on.tv_nsec = rq->perout.on.nsec;
> +
> +			wf_high = timespec64_to_ns(&ts_on);
> +		} else {
> +			if (pps) {
> +				wf_high = 1000;
> +			} else {
> +				wf_high = timespec64_to_ns(&ts_period);
> +				wf_high = div_s64(wf_high, 2);
> +			}
> +		}
> +
> +		wf_low = timespec64_to_ns(&ts_period);
> +		wf_low -= wf_high;
> +
>  		/* Handle PPS request */
>  		if (pps) {
>  			spin_lock_irqsave(&ocelot->ptp_clock_lock, flags);
> -			/* Pulse generated perout.start.nsec after TOD has
> -			 * increased seconds.
> -			 * Pulse width is set to 1us.
> -			 */
> -			ocelot_write_rix(ocelot, ts_start.tv_nsec,
> +			ocelot_write_rix(ocelot, ts_phase.tv_nsec,
>  					 PTP_PIN_WF_LOW_PERIOD, ptp_pin);
> -			ocelot_write_rix(ocelot, NSEC_PER_SEC / 2,

Damn. I had this patch in my tree:

diff --git a/drivers/net/ethernet/mscc/ocelot_ptp.c b/drivers/net/ethernet/mscc/ocelot_ptp.c
index a3088a1676ed..62188772a75d 100644
--- a/drivers/net/ethernet/mscc/ocelot_ptp.c
+++ b/drivers/net/ethernet/mscc/ocelot_ptp.c
@@ -245,7 +245,7 @@ int ocelot_ptp_enable(struct ptp_clock_info *ptp,
 			 */
 			ocelot_write_rix(ocelot, ts_start.tv_nsec,
 					 PTP_PIN_WF_LOW_PERIOD, ptp_pin);
-			ocelot_write_rix(ocelot, 1000,
+			ocelot_write_rix(ocelot, NSEC_PER_SEC / 2,
 					 PTP_PIN_WF_HIGH_PERIOD, ptp_pin);
 			val = PTP_PIN_CFG_ACTION(PTP_PIN_ACTION_CLOCK);
 			val |= PTP_PIN_CFG_SYNC;

which I used for testing until I exposed this into an ioctl. I knew I
forgot to do something, and that was to squash that patch into this one.
So I'll need to send a v2, because otherwise this doesn't apply to
mainline. Please review taking this into consideration.

> +			ocelot_write_rix(ocelot, wf_high,
>  					 PTP_PIN_WF_HIGH_PERIOD, ptp_pin);
>  			val = PTP_PIN_CFG_ACTION(PTP_PIN_ACTION_CLOCK);
>  			val |= PTP_PIN_CFG_SYNC;
> @@ -255,14 +279,16 @@ int ocelot_ptp_enable(struct ptp_clock_info *ptp,
>  		}
>  
>  		/* Handle periodic clock */
> -		ns = timespec64_to_ns(&ts_period);
> -		ns = ns >> 1;
> -		if (ns > 0x3fffffff || ns <= 0x6)
> +		if (wf_high > 0x3fffffff || wf_high <= 0x6)
> +			return -EINVAL;
> +		if (wf_low > 0x3fffffff || wf_low <= 0x6)
>  			return -EINVAL;
>  
>  		spin_lock_irqsave(&ocelot->ptp_clock_lock, flags);
> -		ocelot_write_rix(ocelot, ns, PTP_PIN_WF_LOW_PERIOD, ptp_pin);
> -		ocelot_write_rix(ocelot, ns, PTP_PIN_WF_HIGH_PERIOD, ptp_pin);
> +		ocelot_write_rix(ocelot, wf_low, PTP_PIN_WF_LOW_PERIOD,
> +				 ptp_pin);
> +		ocelot_write_rix(ocelot, wf_high, PTP_PIN_WF_HIGH_PERIOD,
> +				 ptp_pin);
>  		val = PTP_PIN_CFG_ACTION(PTP_PIN_ACTION_CLOCK);
>  		ocelot_write_rix(ocelot, val, PTP_PIN_CFG, ptp_pin);
>  		spin_unlock_irqrestore(&ocelot->ptp_clock_lock, flags);
> -- 
> 2.25.1
> 

Thanks,
-Vladimir
