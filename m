Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 977ED4CEC3D
	for <lists+netdev@lfdr.de>; Sun,  6 Mar 2022 17:36:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233818AbiCFQhF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 11:37:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230439AbiCFQhE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 11:37:04 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8B202654D
        for <netdev@vger.kernel.org>; Sun,  6 Mar 2022 08:36:09 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id 6so7105312pgg.0
        for <netdev@vger.kernel.org>; Sun, 06 Mar 2022 08:36:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=6Bpzb6DgAmZYvH1g+TmIuH7PL7fiw16yeauhDDFs/l4=;
        b=LlK67IVNyv15TluPLnRFkiIprJzp7Qs7Xjz26fqa1SQCcPca4YttAuxqbznOLEuP59
         Ho+p7rbeYF6lRHEgUbFpSA/p57TD4piBeFCAjCjnbBbpWiNARfpa3VzwxHJ2ypV+ZTpe
         6dQ/jIA8Qsf+HwTzpf0ZlyGpvfjAzwxj9uGmLzCC80UxEv5EVNDnI+QR7U/Mmv0JT7pw
         cXAMoVphXaDZP6KKKZiSfYQC8I2K00E+ctJmje/nrl7arg4TVmfTZpA+pnrWyytXWqks
         FV2jPlH3nW/S7vIOKTj1ZeJE9lGwr+64AmhavmEtCwXJH0BilvnremekznPiKA0qjplF
         tzqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=6Bpzb6DgAmZYvH1g+TmIuH7PL7fiw16yeauhDDFs/l4=;
        b=LfTJDLUOaaVPbLjhTJrJY65FbJIIbjf2HarhS3NPU5Lii/hdJ5ANHmdPtCsbeXaapH
         8sZCBajZ5D1QjMcE6Py7eOFXYrFEiHNlKJaytMsFn2Z9wbeqjLAUbd3WW/5qGSZBpy59
         xvvARRDWAJQ7mBpfnqighbXHqVuQzR0mG05rny6Z+HU9fdXSIxzJ6Mpr+4oFVpFEuQV1
         DWuDvrk8mTyS1O0P2XKUKkgZWkyVxHlMWtRcGjriKfGWa2f7ZgAcPmeXzIfQH0T7fhxJ
         W3oj7wn61+yIW3+TCqKQP654n5RxmnTDgfHRkrrAXdRLanc6vdKeCTdI0K0jWdZlvGhd
         h5ow==
X-Gm-Message-State: AOAM533NekLfD+0EiG7SxaU6WPlafBAT3RUhjcGup6CbPPhP/wwWNEyD
        yRJR/A1xe7x4cR9ZJAQtzLU=
X-Google-Smtp-Source: ABdhPJwOltsjhWsrUxoJNUMm8LNs0IXhkSm19K9aGGtqA5SsZuOSTefqEeh/WL0QT/JnNF0+vnK4lg==
X-Received: by 2002:a65:6e09:0:b0:380:4723:b4e9 with SMTP id bd9-20020a656e09000000b003804723b4e9mr1231084pgb.346.1646584569260;
        Sun, 06 Mar 2022 08:36:09 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id a11-20020a63cd4b000000b00378b9167493sm9678571pgj.52.2022.03.06.08.36.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Mar 2022 08:36:08 -0800 (PST)
Date:   Sun, 6 Mar 2022 08:36:06 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     yangbo.lu@nxp.com, davem@davemloft.net, kuba@kernel.org,
        mlichvar@redhat.com, vinicius.gomes@intel.com,
        netdev@vger.kernel.org
Subject: Re: [RFC PATCH net-next 3/6] ptp: Add free running time support
Message-ID: <20220306163606.GA6290@hoboy.vegasvil.org>
References: <20220306085658.1943-1-gerhard@engleder-embedded.com>
 <20220306085658.1943-4-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220306085658.1943-4-gerhard@engleder-embedded.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 06, 2022 at 09:56:55AM +0100, Gerhard Engleder wrote:
> ptp vclocks require a clock with free running time for the timecounter.
> Currently only a physical clock forced to free running is supported.
> If vclocks are used, then the physical clock cannot be synchronized
> anymore. The synchronized time is not available in hardware in this
> case. As a result, timed transmission with ETF/TAPRIO hardware support
> is not possible anymore.
> 
> If hardware would support a free running time additionally to the
> physical clock, then the physical clock does not need to be forced to
> free running. Thus, the physical clocks can still be synchronized while
> vclocks are in use.
> 
> The physical clock could be used to synchronize the time domain of the
> TSN network and trigger ETF/TAPRIO. In parallel vclocks can be used to
> synchronize other time domains.
> 
> Allow read and cross time stamp of additional free running time for
> physical clocks. Let vclocks use free running time if available.
> 
> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
> ---
>  drivers/ptp/ptp_vclock.c         | 20 +++++++++++++++-----
>  include/linux/ptp_clock_kernel.h | 27 +++++++++++++++++++++++++++
>  2 files changed, 42 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/ptp/ptp_vclock.c b/drivers/ptp/ptp_vclock.c
> index cb179a3ea508..3715d75ee8bd 100644
> --- a/drivers/ptp/ptp_vclock.c
> +++ b/drivers/ptp/ptp_vclock.c
> @@ -68,7 +68,10 @@ static int ptp_vclock_gettimex(struct ptp_clock_info *ptp,
>  	int err;
>  	u64 ns;
>  
> -	err = pptp->info->gettimex64(pptp->info, &pts, sts);
> +	if (pptp->info->getfreeruntimex64)
> +		err = pptp->info->getfreeruntimex64(pptp->info, &pts, sts);
> +	else
> +		err = pptp->info->gettimex64(pptp->info, &pts, sts);

Why all this extra if/then/else here and at registration?
Just provide new ptp_vclock_ helpers and drop the run time conditionals.

>  	if (err)
>  		return err;
>  
> @@ -104,7 +107,10 @@ static int ptp_vclock_getcrosststamp(struct ptp_clock_info *ptp,
>  	int err;
>  	u64 ns;
>  
> -	err = pptp->info->getcrosststamp(pptp->info, xtstamp);
> +	if (pptp->info->getfreeruncrosststamp)
> +		err = pptp->info->getfreeruncrosststamp(pptp->info, xtstamp);
> +	else
> +		err = pptp->info->getcrosststamp(pptp->info, xtstamp);

same here

>  	if (err)
>  		return err;
>  
> @@ -143,7 +149,9 @@ static u64 ptp_vclock_read(const struct cyclecounter *cc)
>  	struct ptp_clock *ptp = vclock->pclock;
>  	struct timespec64 ts = {};
>  
> -	if (ptp->info->gettimex64)
> +	if (ptp->info->getfreeruntimex64)
> +		ptp->info->getfreeruntimex64(ptp->info, &ts, NULL);
> +	else if (ptp->info->gettimex64)
>  		ptp->info->gettimex64(ptp->info, &ts, NULL);
>  	else
>  		ptp->info->gettime64(ptp->info, &ts);
> @@ -168,11 +176,13 @@ struct ptp_vclock *ptp_vclock_register(struct ptp_clock *pclock)
>  
>  	vclock->pclock = pclock;
>  	vclock->info = ptp_vclock_info;
> -	if (pclock->info->gettimex64)
> +	if (pclock->info->getfreeruntimex64 || pclock->info->gettimex64)
>  		vclock->info.gettimex64 = ptp_vclock_gettimex;
>  	else
>  		vclock->info.gettime64 = ptp_vclock_gettime;
> -	if (pclock->info->getcrosststamp)
> +	if ((pclock->info->getfreeruntimex64 &&
> +	     pclock->info->getfreeruncrosststamp) ||
> +	    pclock->info->getcrosststamp)
>  		vclock->info.getcrosststamp = ptp_vclock_getcrosststamp;
>  	vclock->cc = ptp_vclock_cc;
>  
> diff --git a/include/linux/ptp_clock_kernel.h b/include/linux/ptp_clock_kernel.h
> index 554454cb8693..b291517fc7c8 100644
> --- a/include/linux/ptp_clock_kernel.h
> +++ b/include/linux/ptp_clock_kernel.h
> @@ -108,6 +108,28 @@ struct ptp_system_timestamp {
>   * @settime64:  Set the current time on the hardware clock.
>   *              parameter ts: Time value to set.
>   *
> + * @getfreeruntimex64:  Reads the current free running time from the hardware
> + *                      clock and optionally also the system clock. This
> + *                      operation requires hardware support for an additional
> + *                      free running time including support for hardware time
> + *                      stamps based on that free running time.
> + *                      The free running time must be completely independet from
> + *                      the actual time of the PTP clock. It must be monotonic
> + *                      and its frequency must be constant.
> + *                      parameter ts: Holds the PHC free running timestamp.
> + *                      parameter sts: If not NULL, it holds a pair of
> + *                      timestamps from the system clock. The first reading is
> + *                      made right before reading the lowest bits of the PHC
> + *                      free running timestamp and the second reading
> + *                      immediately follows that.
> + *
> + * @getfreeruncrosststamp:  Reads the current time from the free running
> + *                          hardware clock and system clock simultaneously.
> + *                          parameter cts: Contains timestamp (device,system)
> + *                          pair, where device time is the free running time
> + *                          also used for @getfreeruntimex64 and system time is
> + *                          realtime and monotonic.
> + *
>   * @enable:   Request driver to enable or disable an ancillary feature.
>   *            parameter request: Desired resource to enable or disable.
>   *            parameter on: Caller passes one to enable or zero to disable.
> @@ -155,6 +177,11 @@ struct ptp_clock_info {
>  	int (*getcrosststamp)(struct ptp_clock_info *ptp,
>  			      struct system_device_crosststamp *cts);
>  	int (*settime64)(struct ptp_clock_info *p, const struct timespec64 *ts);
> +	int (*getfreeruntimex64)(struct ptp_clock_info *ptp,
> +				 struct timespec64 *ts,
> +				 struct ptp_system_timestamp *sts);
> +	int (*getfreeruncrosststamp)(struct ptp_clock_info *ptp,
> +				     struct system_device_crosststamp *cts);

Wow, that is really hard to read.  Suggest freerun_gettimex64 and
freerun_crosststamp instead.

>  	int (*enable)(struct ptp_clock_info *ptp,
>  		      struct ptp_clock_request *request, int on);
>  	int (*verify)(struct ptp_clock_info *ptp, unsigned int pin,
> -- 
> 2.20.1
> 

Thanks,
Richard
