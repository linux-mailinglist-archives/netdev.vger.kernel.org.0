Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CC588BFE8
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 19:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727806AbfHMRsZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 13:48:25 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:36285 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726323AbfHMRsY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 13:48:24 -0400
Received: by mail-pg1-f193.google.com with SMTP id l21so51623803pgm.3;
        Tue, 13 Aug 2019 10:48:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=XfNVQSjb+WFpQl0K46ml4eHsM6amiR019FOKrxA80/0=;
        b=Mhxd8tKRzslCk8d2cFs5KX1HYXk31WNRSL3d44ZSBBySwEaz8x4zUKviQby6rs7hDr
         sG5TJrJtZVUUFpAbNr6vm0NEUMOnD+w08ctIt/ZrHeQARBUcP9iq781EF7AXHL7Bw/fn
         llgLttdaUQSrLiuNuTF85sRvD2ZoTDPAyEkgQk6szA6Y4q4KFQyqWFp4dxsFckJ/OlQm
         1J2V6ifwRNBO8unfqiNiIBCFcxwVXcldQ/WBbfUjDPgb73d41zGc2JbtTCY2gqOYMXzm
         fdSP/uqbnyclM8ygyWRIcygpnvHE0MAbfjrUoF18wM0gwy2s8rLNQMUpe30++HGmd2S5
         JMrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=XfNVQSjb+WFpQl0K46ml4eHsM6amiR019FOKrxA80/0=;
        b=ZNAznsY5xH7pIMxOtwN4YcmF9ikqCLmpK/S+b2z+MjnwvGK7ioqhAHmOsUy/Jczl0/
         rAl6Q+ulU7jUHgRA+rXrdgYjBQhK4IZm4oxo6wIDZAbWmlSbjoj2+BMrrYGpdxsdpjS/
         iwqU/gUhNDdW0FU6SVITTjDU3mgfpfJrRB4XGI1o1KVH76bk6tNjlDZqajTu0nqKo35U
         v/yXEulcImCYqp/RsT0jvBEdrV5guL396PdqiHCi4DNM2lf9Lq8yUDtNHreZsH4pXeRS
         QTVTZownK5IPuklSRRyEHhM2SDDwrfZIgxVWTV7H18mciWQZ6K7iC7O8hXP3pNs0fql9
         1dFA==
X-Gm-Message-State: APjAAAVR6HybGqNFdImvCVyQ40hYeS6G0lOChg3gooFhnx5WWnG347Mm
        mbTFiZRcTFi2qRXaOMojWmI=
X-Google-Smtp-Source: APXvYqwf1SAs1m3ULu4DPvlTYw21z0F45xqJ8UzEuijCTMrqdYFncoq6tknOHL6TWq0qd4fErxlSaA==
X-Received: by 2002:aa7:915a:: with SMTP id 26mr42081187pfi.247.1565718504063;
        Tue, 13 Aug 2019 10:48:24 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id x1sm23119359pfj.182.2019.08.13.10.48.22
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 13 Aug 2019 10:48:23 -0700 (PDT)
Date:   Tue, 13 Aug 2019 10:48:21 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Felipe Balbi <felipe.balbi@linux.intel.com>
Cc:     netdev@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        "Christopher S . Hall" <christopher.s.hall@intel.com>
Subject: Re: [RFC PATCH 4/5] PTP: Add flag for non-periodic output
Message-ID: <20190813174821.GC3207@localhost>
References: <20190716072038.8408-1-felipe.balbi@linux.intel.com>
 <20190716072038.8408-5-felipe.balbi@linux.intel.com>
 <20190716163927.GA2125@localhost>
 <87k1ch2m1i.fsf@linux.intel.com>
 <20190717173645.GD1464@localhost>
 <87ftn3iuqp.fsf@linux.intel.com>
 <20190718164121.GB1533@localhost>
 <87tvalxzzi.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tvalxzzi.fsf@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 13, 2019 at 10:53:53AM +0300, Felipe Balbi wrote:
> before I send a new series built on top of this change, I thought I'd
> check with you if I'm on the right path. Below you can find my current
> take at the new IOCTLs. I maintained the same exact structures so that
> there's no maintenance burden. Also introduce a new IOCTL for every
> single one of the previously existing ones even though not all of them
> needed changes. The reason for that was just to make it easier for
> libary authors to update their library by a simple sed script adding '2'
> to the end of the IOCTL macro.

Sounds good.  I have a few comments, below...
 
> Let me know if you want anything to be changed or had a different idea
> about any of this. Also, if you prefer that I finish the entire series
> before you review, no worries either ;-)
> 
> Cheers, patch follows:
> 
> From bc2aa511d4c2e2228590fb29604c6c33b56527ad Mon Sep 17 00:00:00 2001
> From: Felipe Balbi <felipe.balbi@linux.intel.com>
> Date: Tue, 13 Aug 2019 10:32:35 +0300
> Subject: [PATCH] PTP: introduce new versions of IOCTLs
> 
> The current version of the IOCTL have a small problem which prevents
> us from extending the API by making use of reserved fields. In these
> new IOCTLs, we are now making sure that flags and rsv fields are zero
> which will allow us to extend the API in the future.
> 
> Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
> ---
>  drivers/ptp/ptp_chardev.c      | 105 +++++++++++++++++++++++++++++++++
>  include/uapi/linux/ptp_clock.h |  12 ++++
>  2 files changed, 117 insertions(+)
> 
> diff --git a/drivers/ptp/ptp_chardev.c b/drivers/ptp/ptp_chardev.c
> index 18ffe449efdf..94775073527b 100644
> --- a/drivers/ptp/ptp_chardev.c
> +++ b/drivers/ptp/ptp_chardev.c
> @@ -126,6 +126,7 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
>  	switch (cmd) {
>  
>  	case PTP_CLOCK_GETCAPS:
> +	case PTP_CLOCK_GETCAPS2:
>  		memset(&caps, 0, sizeof(caps));
>  		caps.max_adj = ptp->info->max_adj;
>  		caps.n_alarm = ptp->info->n_alarm;
> @@ -153,6 +154,28 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
>  		err = ops->enable(ops, &req, enable);
>  		break;
>  
> +	case PTP_EXTTS_REQUEST2:
> +		memset(&req, 0, sizeof(req));

This memset not needed, AFAICT.  Oh wait, you want to keep drivers
from seeing stack data in the unused parts of the union.  That is
fine, but please just do that unconditionally at the top of the
function.

> +		if (copy_from_user(&req.extts, (void __user *)arg,
> +				   sizeof(req.extts))) {
> +			err = -EFAULT;
> +			break;
> +		}
> +		if (req.extts.flags || req.extts.rsv[0]
> +				|| req.extts.rsv[1]) {
> +			err = -EINVAL;

Since the code is mostly the same as in the PTP_EXTTS_REQUEST case,
maybe just double up the case statements (like in the other) and add
an extra test for (cmd == PTP_EXTTS_REQUEST2) for this if-block.

> +			break;
> +		}
> +			
> +		if (req.extts.index >= ops->n_ext_ts) {
> +			err = -EINVAL;
> +			break;
> +		}
> +		req.type = PTP_CLK_REQ_EXTTS;
> +		enable = req.extts.flags & PTP_ENABLE_FEATURE ? 1 : 0;
> +		err = ops->enable(ops, &req, enable);
> +		break;
> +
>  	case PTP_PEROUT_REQUEST:
>  		if (copy_from_user(&req.perout, (void __user *)arg,
>  				   sizeof(req.perout))) {
> @@ -168,6 +191,28 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
>  		err = ops->enable(ops, &req, enable);
>  		break;
>  
> +	case PTP_PEROUT_REQUEST2:
> +		memset(&req, 0, sizeof(req));
> +		if (copy_from_user(&req.perout, (void __user *)arg,
> +				   sizeof(req.perout))) {
> +			err = -EFAULT;
> +			break;
> +		}
> +		if (req.perout.flags || req.perout.rsv[0]
> +				|| req.perout.rsv[1] || req.perout.rsv[2]
> +				|| req.perout.rsv[3]) {
> +			err = -EINVAL;
> +			break;
> +		}

Also this could share code with the legacy ioctl.

> +		if (req.perout.index >= ops->n_per_out) {
> +			err = -EINVAL;
> +			break;
> +		}
> +		req.type = PTP_CLK_REQ_PEROUT;
> +		enable = req.perout.period.sec || req.perout.period.nsec;
> +		err = ops->enable(ops, &req, enable);
> +		break;
> +
>  	case PTP_ENABLE_PPS:
>  		if (!capable(CAP_SYS_TIME))
>  			return -EPERM;
> @@ -176,7 +221,17 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
>  		err = ops->enable(ops, &req, enable);
>  		break;
>  
> +	case PTP_ENABLE_PPS2:
> +		if (!capable(CAP_SYS_TIME))
> +			return -EPERM;
> +		memset(&req, 0, sizeof(req));

Clearing 'req' unconditionally will make this case the same as the
legacy case.

> +		req.type = PTP_CLK_REQ_PPS;
> +		enable = arg ? 1 : 0;
> +		err = ops->enable(ops, &req, enable);
> +		break;
> +
>  	case PTP_SYS_OFFSET_PRECISE:
> +	case PTP_SYS_OFFSET_PRECISE2:
>  		if (!ptp->info->getcrosststamp) {
>  			err = -EOPNOTSUPP;
>  			break;
> @@ -201,6 +256,7 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
>  		break;
>  
>  	case PTP_SYS_OFFSET_EXTENDED:
> +	case PTP_SYS_OFFSET_EXTENDED2:
>  		if (!ptp->info->gettimex64) {
>  			err = -EOPNOTSUPP;
>  			break;
> @@ -232,6 +288,7 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
>  		break;
>  
>  	case PTP_SYS_OFFSET:
> +	case PTP_SYS_OFFSET2:
>  		sysoff = memdup_user((void __user *)arg, sizeof(*sysoff));
>  		if (IS_ERR(sysoff)) {
>  			err = PTR_ERR(sysoff);
> @@ -284,6 +341,31 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
>  			err = -EFAULT;
>  		break;
>  
> +	case PTP_PIN_GETFUNC2:
> +		memset(&pd, 0, sizeof(pd));

This memset is pointless because of the following copy_from_user().

> +		if (copy_from_user(&pd, (void __user *)arg, sizeof(pd))) {
> +			err = -EFAULT;
> +			break;
> +		}
> +		if (pd.rsv[0] || pd.rsv[1] || pd.rsv[2]
> +				|| pd.rsv[3] || pd.rsv[4]) {
> +			err = -EINVAL;
> +			break;
> +		}

Again maybe share the code?

> +		pin_index = pd.index;
> +		if (pin_index >= ops->n_pins) {
> +			err = -EINVAL;
> +			break;
> +		}
> +		pin_index = array_index_nospec(pin_index, ops->n_pins);
> +		if (mutex_lock_interruptible(&ptp->pincfg_mux))
> +			return -ERESTARTSYS;
> +		pd = ops->pin_config[pin_index];
> +		mutex_unlock(&ptp->pincfg_mux);
> +		if (!err && copy_to_user((void __user *)arg, &pd, sizeof(pd)))
> +			err = -EFAULT;
> +		break;
> +
>  	case PTP_PIN_SETFUNC:
>  		if (copy_from_user(&pd, (void __user *)arg, sizeof(pd))) {
>  			err = -EFAULT;
> @@ -301,6 +383,29 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
>  		mutex_unlock(&ptp->pincfg_mux);
>  		break;
>  
> +	case PTP_PIN_SETFUNC2:
> +		memset(&pd, 0, sizeof(pd));

memset not needed here either.

> +		if (copy_from_user(&pd, (void __user *)arg, sizeof(pd))) {
> +			err = -EFAULT;
> +			break;
> +		}
> +		if (pd.rsv[0] || pd.rsv[1] || pd.rsv[2]
> +				|| pd.rsv[3] || pd.rsv[4]) {
> +			err = -EINVAL;
> +			break;
> +		}

also shareable.

Thanks,
Richard

> +		pin_index = pd.index;
> +		if (pin_index >= ops->n_pins) {
> +			err = -EINVAL;
> +			break;
> +		}
> +		pin_index = array_index_nospec(pin_index, ops->n_pins);
> +		if (mutex_lock_interruptible(&ptp->pincfg_mux))
> +			return -ERESTARTSYS;
> +		err = ptp_set_pinfunc(ptp, pin_index, pd.func, pd.chan);
> +		mutex_unlock(&ptp->pincfg_mux);
> +		break;
> +
>  	default:
>  		err = -ENOTTY;
>  		break;
> diff --git a/include/uapi/linux/ptp_clock.h b/include/uapi/linux/ptp_clock.h
> index 1bc794ad957a..039cd62ec706 100644
> --- a/include/uapi/linux/ptp_clock.h
> +++ b/include/uapi/linux/ptp_clock.h
> @@ -149,6 +149,18 @@ struct ptp_pin_desc {
>  #define PTP_SYS_OFFSET_EXTENDED \
>  	_IOWR(PTP_CLK_MAGIC, 9, struct ptp_sys_offset_extended)
>  
> +#define PTP_CLOCK_GETCAPS2  _IOR(PTP_CLK_MAGIC, 10, struct ptp_clock_caps)
> +#define PTP_EXTTS_REQUEST2  _IOW(PTP_CLK_MAGIC, 11, struct ptp_extts_request)
> +#define PTP_PEROUT_REQUEST2 _IOW(PTP_CLK_MAGIC, 12, struct ptp_perout_request)
> +#define PTP_ENABLE_PPS2     _IOW(PTP_CLK_MAGIC, 13, int)
> +#define PTP_SYS_OFFSET2     _IOW(PTP_CLK_MAGIC, 14, struct ptp_sys_offset)
> +#define PTP_PIN_GETFUNC2    _IOWR(PTP_CLK_MAGIC, 15, struct ptp_pin_desc)
> +#define PTP_PIN_SETFUNC2    _IOW(PTP_CLK_MAGIC, 16, struct ptp_pin_desc)
> +#define PTP_SYS_OFFSET_PRECISE2 \
> +	_IOWR(PTP_CLK_MAGIC, 17, struct ptp_sys_offset_precise)
> +#define PTP_SYS_OFFSET_EXTENDED2 \
> +	_IOWR(PTP_CLK_MAGIC, 18, struct ptp_sys_offset_extended)
> +
>  struct ptp_extts_event {
>  	struct ptp_clock_time t; /* Time event occured. */
>  	unsigned int index;      /* Which channel produced the event. */
> -- 
> 2.22.0
> 
> 
> 
> -- 
> balbi
