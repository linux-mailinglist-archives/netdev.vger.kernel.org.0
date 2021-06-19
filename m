Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 765073AD79E
	for <lists+netdev@lfdr.de>; Sat, 19 Jun 2021 06:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbhFSEIi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Jun 2021 00:08:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbhFSEIh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Jun 2021 00:08:37 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6978CC061574;
        Fri, 18 Jun 2021 21:06:26 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id h22-20020a05600c3516b02901a826f84095so6832056wmq.5;
        Fri, 18 Jun 2021 21:06:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=qvEO8E6NHwX0FfMs44sHJphC7boBDEt00ZHjlzvaAEg=;
        b=HocuyXyE9kRnYXv9Ihz5eB8BLMzaKII7lfDtSXTYbJH3695KJdRGpE5u00Mz8pQgVI
         41TPTyn0fH46h4UhPClEQZ26Kl2UiiY93g5QCmDUVh+0xFxifyiAmMry9xCmE+Ce2bfc
         lpIkxVEExtzswTXw6Z3fTbwWFXvUu+uBqlFsncaZ4HgdbDHOIxRWyQkqB2W9K3S1Q4EE
         Rs+JeqUibK7LBCbWvhLwjxqu9g0DLVa6wnPXWbRSIte9W6MlcIv8k8EZt1t1pjZtI9r9
         P/pAhUD83LWo5Darhn7ZObozoatkxrDzT8VM/9rn5wFGStKYQyvflmSR9a/As3JVFR/4
         Xh0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=qvEO8E6NHwX0FfMs44sHJphC7boBDEt00ZHjlzvaAEg=;
        b=QXdmzhG6tpHqo5KUAAv4jBj0IJGdi9Ze9cxqO2CddyzZQ8k3YB55WM5+SrDSe3N297
         DEJI7jDBvh8cMS3eesHA6rjZHu/UzzLTujO0H907iB41MZACC6FtK/jorptnSIo2cvHM
         AsUOlKfFb3z+dZ1su5zGUuz4cnPnSjjZZHhr2zSQQeHYtkmiP00/UgzT4L8Zmnse1UIM
         xtoe8HIzDs7ClRbCXfRaFobeiFALsQ7J1jGqq7/lv2wH4do1QOSTK4XiV+rJGh+AyRan
         lSsqksuWbWHFzVOCl3I7TBYKiziVKl2qocyNuOy8ewpwQJaK9VX+8QoEerU1v/aXzov2
         EAMg==
X-Gm-Message-State: AOAM533g+BWU2a45bO5OBcI32OvgjoVEE6CBhi0dufIaBDsfCi1Fr6fM
        lF85la9F9PugnYSk8KyZ7Bk=
X-Google-Smtp-Source: ABdhPJwk1fLZvfe/2S+r8w08v9/BV34y1966ujYFJ0sBhh+r9mg7mUBvUUIzYSom77l4NNfWn/tr2g==
X-Received: by 2002:a05:600c:2150:: with SMTP id v16mr12490051wml.170.1624075584860;
        Fri, 18 Jun 2021 21:06:24 -0700 (PDT)
Received: from localhost (195-70-108-137.stat.salzburg-online.at. [195.70.108.137])
        by smtp.gmail.com with ESMTPSA id m5sm10364796wmg.32.2021.06.18.21.06.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 21:06:24 -0700 (PDT)
Date:   Sat, 19 Jun 2021 06:06:23 +0200
From:   Richard Cochran <richardcochran@gmail.com>
To:     Yangbo Lu <yangbo.lu@nxp.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, mptcp@lists.linux.dev,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Shuah Khan <shuah@kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Rui Sousa <rui.sousa@nxp.com>,
        Sebastien Laveze <sebastien.laveze@nxp.com>
Subject: Re: [net-next, v3, 02/10] ptp: support ptp physical/virtual clocks
 conversion
Message-ID: <20210619040623.GA14326@localhost>
References: <20210615094517.48752-1-yangbo.lu@nxp.com>
 <20210615094517.48752-3-yangbo.lu@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210615094517.48752-3-yangbo.lu@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 15, 2021 at 05:45:09PM +0800, Yangbo Lu wrote:

> diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
> index a780435331c8..78414b3e16dd 100644
> --- a/drivers/ptp/ptp_clock.c
> +++ b/drivers/ptp/ptp_clock.c
> @@ -76,6 +76,11 @@ static int ptp_clock_settime(struct posix_clock *pc, const struct timespec64 *tp
>  {
>  	struct ptp_clock *ptp = container_of(pc, struct ptp_clock, clock);
>  
> +	if (ptp_guaranteed_pclock(ptp)) {

Can we please invent a more descriptive name for this method?
The word "guaranteed" suggests much more.

> +		pr_err("ptp: virtual clock in use, guarantee physical clock free running\n");

This is good:           ^^^^^^^^^^^^^^^^^^^^^^^^^
You can drop this part:                            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

So, please rename ptp_guaranteed_pclock() to ptp_vclock_in_use();

> +		return -EBUSY;
> +	}
> +
>  	return  ptp->info->settime64(ptp->info, tp);
>  }


> diff --git a/drivers/ptp/ptp_private.h b/drivers/ptp/ptp_private.h
> index 3f388d63904c..6949afc9d733 100644
> --- a/drivers/ptp/ptp_private.h
> +++ b/drivers/ptp/ptp_private.h
> @@ -46,6 +46,9 @@ struct ptp_clock {
>  	const struct attribute_group *pin_attr_groups[2];
>  	struct kthread_worker *kworker;
>  	struct kthread_delayed_work aux_work;
> +	u8 n_vclocks;

Why not use "unsigned int" type?  I don't see a need to set an artificial limit.

> +	struct mutex n_vclocks_mux; /* protect concurrent n_vclocks access */
> +	bool vclock_flag;

"flag" is vague.  How about "is_virtual_clock" instead?

>  };
>  
>  #define info_to_vclock(d) container_of((d), struct ptp_vclock, info)
> @@ -75,6 +78,18 @@ static inline int queue_cnt(struct timestamp_event_queue *q)
>  	return cnt < 0 ? PTP_MAX_TIMESTAMPS + cnt : cnt;
>  }
>  
> +/*
> + * Guarantee physical clock to stay free running, if ptp virtual clocks
> + * on it are in use.
> + */
> +static inline bool ptp_guaranteed_pclock(struct ptp_clock *ptp)
> +{
> +	if (!ptp->vclock_flag && ptp->n_vclocks)

Need to take mutex for n_vclocks to prevent load tearing.

> +		return true;
> +
> +	return false;
> +}
> +
>  /*
>   * see ptp_chardev.c
>   */

> @@ -148,6 +149,90 @@ static ssize_t pps_enable_store(struct device *dev,
>  }
>  static DEVICE_ATTR(pps_enable, 0220, NULL, pps_enable_store);
>  
> +static int unregister_vclock(struct device *dev, void *data)
> +{
> +	struct ptp_clock *ptp = dev_get_drvdata(dev);
> +	struct ptp_clock_info *info = ptp->info;
> +	struct ptp_vclock *vclock;
> +	u8 *num = data;
> +
> +	vclock = info_to_vclock(info);
> +	dev_info(dev->parent, "delete virtual clock ptp%d\n",
> +		 vclock->clock->index);
> +
> +	ptp_vclock_unregister(vclock);
> +	(*num)--;
> +
> +	/* For break. Not error. */
> +	if (*num == 0)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +static ssize_t n_vclocks_show(struct device *dev,
> +			      struct device_attribute *attr, char *page)
> +{
> +	struct ptp_clock *ptp = dev_get_drvdata(dev);
> +
> +	return snprintf(page, PAGE_SIZE-1, "%d\n", ptp->n_vclocks);

Take mutex.

> +}
> +
> +static ssize_t n_vclocks_store(struct device *dev,
> +			       struct device_attribute *attr,
> +			       const char *buf, size_t count)
> +{
> +	struct ptp_clock *ptp = dev_get_drvdata(dev);
> +	struct ptp_vclock *vclock;
> +	int err = -EINVAL;
> +	u8 num, i;
> +
> +	if (kstrtou8(buf, 0, &num))
> +		goto out;
> +
> +	if (num > PTP_MAX_VCLOCKS) {
> +		dev_err(dev, "max value is %d\n", PTP_MAX_VCLOCKS);
> +		goto out;
> +	}
> +
> +	if (mutex_lock_interruptible(&ptp->n_vclocks_mux))
> +		return -ERESTARTSYS;
> +
> +	/* Need to create more vclocks */
> +	if (num > ptp->n_vclocks) {
> +		for (i = 0; i < num - ptp->n_vclocks; i++) {
> +			vclock = ptp_vclock_register(ptp);
> +			if (!vclock) {
> +				mutex_unlock(&ptp->n_vclocks_mux);
> +				goto out;
> +			}
> +
> +			dev_info(dev, "new virtual clock ptp%d\n",
> +				 vclock->clock->index);
> +		}
> +	}
> +
> +	/* Need to delete vclocks */
> +	if (num < ptp->n_vclocks) {
> +		i = ptp->n_vclocks - num;
> +		device_for_each_child_reverse(dev, &i,
> +					      unregister_vclock);
> +	}
> +
> +	if (num == 0)
> +		dev_info(dev, "only physical clock in use now\n");
> +	else
> +		dev_info(dev, "guarantee physical clock free running\n");
> +
> +	ptp->n_vclocks = num;
> +	mutex_unlock(&ptp->n_vclocks_mux);
> +
> +	return count;
> +out:
> +	return err;
> +}
> +static DEVICE_ATTR_RW(n_vclocks);
> +
>  static struct attribute *ptp_attrs[] = {
>  	&dev_attr_clock_name.attr,
>  


> diff --git a/include/uapi/linux/ptp_clock.h b/include/uapi/linux/ptp_clock.h
> index 1d108d597f66..4b933dc1b81b 100644
> --- a/include/uapi/linux/ptp_clock.h
> +++ b/include/uapi/linux/ptp_clock.h
> @@ -69,6 +69,11 @@
>   */
>  #define PTP_PEROUT_V1_VALID_FLAGS	(0)
>  
> +/*
> + * Max number of PTP virtual clocks per PTP physical clock
> + */
> +#define PTP_MAX_VCLOCKS			20

Why limit this to twenty clocks?

Thanks,
Richard
