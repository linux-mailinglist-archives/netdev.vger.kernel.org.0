Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 618FD65C4E1
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 18:15:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238259AbjACRPQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 12:15:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238269AbjACRPG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 12:15:06 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C781BEE;
        Tue,  3 Jan 2023 09:15:04 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id vm8so68604391ejc.2;
        Tue, 03 Jan 2023 09:15:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SetGJdsbqgN8ruoTbL8RHXzsmA6agUY3i0K9FH+Xf0Y=;
        b=DEOMotdt3YjKEnXeAUxP6Nekk4DK/fmRiHZ3KQciCv1sSNl8yRKKhkRsMEaTodIWhj
         G+bItQA4JCUt0j1ci8+GIseCodptoSCNIUiqQ26AMlasRJ/AlylVD9qmgp9lxUqLrHzY
         WMnNgfDaI5wgyGzfi4e3vt0v9hjdPuYekcPIzuqvtbHu9RKxJNTDvAGjfNWxl6NchpY5
         J8O54Nx8JVyXBvGA2mPOW2DV/zLuJcn3jcCcdd2zcLRYNPnob96p3zbBUm5CvgWFFBSn
         y583qAI65GoG5xXnWR8nucxsZ9yneulpcSXI3VBb1htPwt4FEf+WcFQ0K5Igf0BQ80Jh
         nlbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SetGJdsbqgN8ruoTbL8RHXzsmA6agUY3i0K9FH+Xf0Y=;
        b=SPkg0A1ByjguXZhqgWhKUuM+ZOtI0lIhvX+VTZvyEuIdqThIDUUthEF/eEjMAqGNjt
         8+0qKGtNz/jm/d1hnIye4+osu60dZdnIGucy09HTi6RMUl8jKZ3GRsXXU7USPpnZ3KnS
         Pyv6WIjE4AyCJ0X/oUf+pXA2keuJqyrS9fqjDdptyn7lJoSgGueazm+e/+666jcutZMb
         Dxs5OpunuAOj7gmGRQTP26ANSGXwk8m/bH3K05N6k6AqyHeJQCeOdMcxLjdcErChjKdc
         Ixxpj8vgSZDTaI50KjFrGo6S/b94y9BDmE4idjTOpZYgrDQNP8Exwf5yKf/4LcEJJyAh
         g+GQ==
X-Gm-Message-State: AFqh2kr7x98GmOpdrKoNlxoGJpi8i95NPFjs1N32jsvI/qr99SqZHv5d
        H2cqP09FOV+hjBytdZDdFcE=
X-Google-Smtp-Source: AMrXdXtUTgtJ2yiqvHFrXb9w2RI7nD8c1HEa6WqHxVIUJFeCfUB+JZCUZfvYtCJf0udg6Zrw3ZwAOg==
X-Received: by 2002:a17:906:b142:b0:7c1:6fd3:1efa with SMTP id bt2-20020a170906b14200b007c16fd31efamr42140390ejb.28.1672766103135;
        Tue, 03 Jan 2023 09:15:03 -0800 (PST)
Received: from skbuf ([188.26.185.118])
        by smtp.gmail.com with ESMTPSA id m9-20020a1709062ac900b007c0d41736c0sm14230826eje.39.2023.01.03.09.15.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 09:15:02 -0800 (PST)
Date:   Tue, 3 Jan 2023 19:15:00 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@armlinux.org.uk,
        Tristram.Ha@microchip.com, richardcochran@gmail.com,
        ceggers@arri.de, jacob.e.keller@intel.com
Subject: Re: [Patch net-next v6 04/13] net: dsa: microchip: ptp: manipulating
 absolute time using ptp hw clock
Message-ID: <20230103171500.lbxpulx7jfrh5hnv@skbuf>
References: <20230102050459.31023-1-arun.ramadoss@microchip.com>
 <20230102050459.31023-5-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230102050459.31023-5-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 02, 2023 at 10:34:50AM +0530, Arun Ramadoss wrote:
> From: Christian Eggers <ceggers@arri.de>
> 
> This patch is used for reconstructing the absolute time from the 32bit
> hardware time stamping value. The do_aux ioctl is used for reading the
> ptp hardware clock and store it to global variable.
> The timestamped value in tail tag during rx and register during tx are
> 32 bit value (2 bit seconds and 30 bit nanoseconds). The time taken to
> read entire ptp clock will be time consuming. In order to speed up, the
> software clock is maintained. This clock time will be added to 32 bit
> timestamp to get the absolute time stamp.
> 
> Signed-off-by: Christian Eggers <ceggers@arri.de>
> Co-developed-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> ---
> v1 -> v2
> - Used ksz_ptp_gettime instead of _ksz_ptp_gettime in do_aux_work()
> - Removed the spin_lock_bh in the ksz_ptp_start_clock()
> 
> RFC v1
> - This patch is based on Christian Eggers Initial hardware timestamping
> support
> ---
>  drivers/net/dsa/microchip/ksz_ptp.c | 52 ++++++++++++++++++++++++++++-
>  drivers/net/dsa/microchip/ksz_ptp.h |  3 ++
>  2 files changed, 54 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/microchip/ksz_ptp.c b/drivers/net/dsa/microchip/ksz_ptp.c
> index 8be03095e061..16f172c1f5c2 100644
> --- a/drivers/net/dsa/microchip/ksz_ptp.c
> +++ b/drivers/net/dsa/microchip/ksz_ptp.c
> @@ -28,9 +28,11 @@
>  static int ksz_ptp_enable_mode(struct ksz_device *dev)
>  {
>  	struct ksz_tagger_data *tagger_data = ksz_tagger_data(dev->ds);
> +	struct ksz_ptp_data *ptp_data = &dev->ptp_data;
>  	struct ksz_port *prt;
>  	struct dsa_port *dp;
>  	bool tag_en = false;
> +	int ret;
>  
>  	dsa_switch_for_each_user_port(dp, dev->ds) {
>  		prt = &dev->ports[dp->index];
> @@ -40,6 +42,14 @@ static int ksz_ptp_enable_mode(struct ksz_device *dev)
>  		}
>  	}
>  
> +	if (tag_en) {
> +		ret = ptp_schedule_worker(ptp_data->clock, 0);
> +		if (ret)
> +			return ret;
> +	} else {
> +		ptp_cancel_worker_sync(ptp_data->clock);
> +	}
> +
>  	tagger_data->hwtstamp_set_state(dev->ds, tag_en);
>  
>  	return ksz_rmw16(dev, REG_PTP_MSG_CONF1, PTP_ENABLE,
> @@ -221,6 +231,12 @@ static int ksz_ptp_settime(struct ptp_clock_info *ptp,
>  		goto unlock;
>  
>  	ret = ksz_rmw16(dev, REG_PTP_CLK_CTRL, PTP_LOAD_TIME, PTP_LOAD_TIME);
> +	if (ret)
> +		goto unlock;
> +
> +	spin_lock_bh(&ptp_data->clock_lock);
> +	ptp_data->clock_time = *ts;
> +	spin_unlock_bh(&ptp_data->clock_lock);
>  
>  unlock:
>  	mutex_unlock(&ptp_data->lock);
> @@ -271,6 +287,7 @@ static int ksz_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
>  {
>  	struct ksz_ptp_data *ptp_data = ptp_caps_to_data(ptp);
>  	struct ksz_device *dev = ptp_data_to_ksz_dev(ptp_data);
> +	struct timespec64 delta64 = ns_to_timespec64(delta);
>  	s32 sec, nsec;
>  	u16 data16;
>  	int ret;
> @@ -303,15 +320,46 @@ static int ksz_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
>  		data16 |= PTP_STEP_DIR;
>  
>  	ret = ksz_write16(dev, REG_PTP_CLK_CTRL, data16);
> +	if (ret)
> +		goto unlock;
> +
> +	spin_lock_bh(&ptp_data->clock_lock);
> +	ptp_data->clock_time = timespec64_add(ptp_data->clock_time, delta64);
> +	spin_unlock_bh(&ptp_data->clock_lock);
>  
>  unlock:
>  	mutex_unlock(&ptp_data->lock);
>  	return ret;
>  }
>  
> +/*  Function is pointer to the do_aux_work in the ptp_clock capability */
> +static long ksz_ptp_do_aux_work(struct ptp_clock_info *ptp)
> +{
> +	struct ksz_ptp_data *ptp_data = ptp_caps_to_data(ptp);
> +	struct timespec64 ts;
> +
> +	ksz_ptp_gettime(ptp, &ts);
> +
> +	spin_lock_bh(&ptp_data->clock_lock);
> +	ptp_data->clock_time = ts;
> +	spin_unlock_bh(&ptp_data->clock_lock);
> +
> +	return HZ;  /* reschedule in 1 second */
> +}

This races with both ksz_ptp_adjtime() and ksz_ptp_settime() because here,
ptp_data->clock_time is not written under mutex_unlock(&ptp_data->lock).

So the following can happen:

CPU 0                                         |   CPU 1
                                              |
ksz_ptp_do_aux_work()                         |
-> ksz_ptp_gettime(ptp, &ts);                 |
   -> mutex_lock(&ptp_data->lock);            |
   -> mutex_unlock(&ptp_data->lock);          |
                                              |   ksz_ptp_adjtime()
                                              |   -> mutex_lock(&ptp_data->lock);
                                              |   -> spin_lock_bh(&ptp_data->clock_lock);
                                              |   -> updates ptp_data->clock_time
                                              |   -> spin_unlock_bh(&ptp_data->clock_lock);
                                              |   -> mutex_unlock(&ptp_data->lock);
   -> spin_lock_bh(&ptp_data->clock_lock);    |
   -> overwites ptp_data->clock_time          |
   -> spin_unlock_bh(&ptp_data->clock_lock);  |


So at the end, ptp_data->clock_time will contain a time prior to the
ksz_ptp_adjtime() call, which can drift over time. This can lead to the
30 us phase offset that Christian has been complaining about privately
to you, me and Richard.

You see, the entire ksz_ptp_do_aux_work() operation needs to take place
under the mutex, to block user space from modifying the clock.

Neither yourself nor Christian wanted to get rid of this apparent
shortcut (to cache ptp_data->clock_time instead of reading it when
needed, and making ksz_port_rxtstamp() ask for skb deferral so that we
have sleepable context to access SPI/I2C).

As a result (because we can't make ksz_tstamp_reconstruct() block user
space, so we need to make the cached value take into account user space
modifications too), we now have this more complicated alternative which
also contains subtle bugs.

> +
>  static int ksz_ptp_start_clock(struct ksz_device *dev)
>  {
> -	return ksz_rmw16(dev, REG_PTP_CLK_CTRL, PTP_CLK_ENABLE, PTP_CLK_ENABLE);
> +	struct ksz_ptp_data *ptp_data = &dev->ptp_data;
> +	int ret;
> +
> +	ret = ksz_rmw16(dev, REG_PTP_CLK_CTRL, PTP_CLK_ENABLE, PTP_CLK_ENABLE);
> +	if (ret)
> +		return ret;
> +
> +	ptp_data->clock_time.tv_sec = 0;
> +	ptp_data->clock_time.tv_nsec = 0;
> +
> +	return 0;
>  }
>  
>  int ksz_ptp_clock_register(struct dsa_switch *ds)
> @@ -322,6 +370,7 @@ int ksz_ptp_clock_register(struct dsa_switch *ds)
>  
>  	ptp_data = &dev->ptp_data;
>  	mutex_init(&ptp_data->lock);
> +	spin_lock_init(&ptp_data->clock_lock);
>  
>  	ptp_data->caps.owner		= THIS_MODULE;
>  	snprintf(ptp_data->caps.name, 16, "Microchip Clock");
> @@ -330,6 +379,7 @@ int ksz_ptp_clock_register(struct dsa_switch *ds)
>  	ptp_data->caps.settime64	= ksz_ptp_settime;
>  	ptp_data->caps.adjfine		= ksz_ptp_adjfine;
>  	ptp_data->caps.adjtime		= ksz_ptp_adjtime;
> +	ptp_data->caps.do_aux_work	= ksz_ptp_do_aux_work;
>  
>  	ret = ksz_ptp_start_clock(dev);
>  	if (ret)
> diff --git a/drivers/net/dsa/microchip/ksz_ptp.h b/drivers/net/dsa/microchip/ksz_ptp.h
> index 7bb3fde2dd14..2c29a0b604bb 100644
> --- a/drivers/net/dsa/microchip/ksz_ptp.h
> +++ b/drivers/net/dsa/microchip/ksz_ptp.h
> @@ -17,6 +17,9 @@ struct ksz_ptp_data {
>  	struct ptp_clock *clock;
>  	/* Serializes all operations on the PTP hardware clock */
>  	struct mutex lock;
> +	/* lock for accessing the clock_time */
> +	spinlock_t clock_lock;
> +	struct timespec64 clock_time;
>  };
>  
>  int ksz_ptp_clock_register(struct dsa_switch *ds);
> -- 
> 2.36.1
> 
