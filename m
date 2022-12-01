Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F6B863E6DD
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 02:05:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbiLABFE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 20:05:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbiLABFC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 20:05:02 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C549C8DFD8;
        Wed, 30 Nov 2022 17:05:01 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id o13so700825ejm.1;
        Wed, 30 Nov 2022 17:05:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MozxBZ2nqvbuh4U0WDktsKh5e7hNOw7NR4ywwxy2J/U=;
        b=eliJBWKgg1OSxa3ReNljvguDDnGkbOu3LnH6dOHFg2mQi7ReErVw1kbpZ/5VRbXi9U
         nc7SxMFDlwZ1ZjBF2UvgrMNF5pH44SjCfF1Xj4BzybufSUYa+BgRIzSWSSUJE8Ilot9t
         K9s27L3udHxvMkP17yxMQvhdKAfT8h8HC2wqJvz8TRqmio7dtwAZzSVbvwQyL3lXiNSL
         lDbaS35t74Us0KTsvTP/9mgGNAYniU4uGyonZVGZvJjirM1BOs41g6GDV9g32nvqzvSh
         +0lZbiTiQNB70KzuKLLN1hKglVO5oyJnXwJUyeRcVpSCdJvgs7fnbpXodYRLdGzoBGKJ
         cRKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MozxBZ2nqvbuh4U0WDktsKh5e7hNOw7NR4ywwxy2J/U=;
        b=A7QX18XM89FjMw75f6ufuY5oUTpF6qIlTZvazhL+VYQ9NYqrviKPREWB2xcb1bWRnK
         R/aI34GhZ/2AIGB5blRqekYt4jRK9YUEFi/8nbMMfgZTluO3aKbX7NabW3pvNLydA/XU
         y1ZSHU2nbd9nMqJSFuiHg2/oF+i58/it9lh7PrPR/z6d9ldyx5YCuuD/UutClmo/Q2Nu
         OTGIGAw+UpG4XwqVD5mGsDUaKjG19A14ZY4nHDGlKUsQI26rPqO7KONUtW7NiMivQvdw
         wORRzs3agtIgVWEM35dkGfq7ZbNhw0lZytNEdqe6D9l4/Ili8VwI9szJHf1kVV37+v6W
         +vkQ==
X-Gm-Message-State: ANoB5plfs2QLv4UR5uFdFtFoHbBjxg/IPBoQk5U/AicWIJy4Q0WSZzIS
        KRElaVYmkldsCjNNiq1kLOcJAELAqoDf9Q==
X-Google-Smtp-Source: AA0mqf4k+kxRyNapgUpujfA14SoojjrYy8NxXG87oy+NxZOKEsX9JXLG0aoiGJV/AGoHswdUNUWbEQ==
X-Received: by 2002:a17:906:6806:b0:7bf:e1f3:543f with SMTP id k6-20020a170906680600b007bfe1f3543fmr14239894ejr.161.1669856700207;
        Wed, 30 Nov 2022 17:05:00 -0800 (PST)
Received: from skbuf ([188.26.184.222])
        by smtp.gmail.com with ESMTPSA id s17-20020a05640217d100b004585eba4baesm1144074edy.80.2022.11.30.17.04.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 17:04:59 -0800 (PST)
Date:   Thu, 1 Dec 2022 03:04:57 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@armlinux.org.uk,
        Tristram.Ha@microchip.com, richardcochran@gmail.com,
        ceggers@arri.de
Subject: Re: [Patch net-next v1 04/12] net: dsa: microchip: ptp: Manipulating
 absolute time using ptp hw clock
Message-ID: <20221201010457.ig6jtrp326xj6ux6@skbuf>
References: <20221128103227.23171-1-arun.ramadoss@microchip.com>
 <20221128103227.23171-1-arun.ramadoss@microchip.com>
 <20221128103227.23171-5-arun.ramadoss@microchip.com>
 <20221128103227.23171-5-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221128103227.23171-5-arun.ramadoss@microchip.com>
 <20221128103227.23171-5-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 28, 2022 at 04:02:19PM +0530, Arun Ramadoss wrote:
> diff --git a/drivers/net/dsa/microchip/ksz_ptp.c b/drivers/net/dsa/microchip/ksz_ptp.c
> index 184aa57a8489..415522ef4ce9 100644
> --- a/drivers/net/dsa/microchip/ksz_ptp.c
> +++ b/drivers/net/dsa/microchip/ksz_ptp.c
> @@ -200,6 +209,12 @@ static int ksz_ptp_settime(struct ptp_clock_info *ptp,
>  		goto error_return;
>  
>  	ret = ksz_rmw16(dev, REG_PTP_CLK_CTRL, PTP_LOAD_TIME, PTP_LOAD_TIME);
> +	if (ret)
> +		goto error_return;
> +
> +	spin_lock_bh(&ptp_data->clock_lock);

Why disable bottom halves? Where is the bottom half that this races with?

> +	ptp_data->clock_time = *ts;
> +	spin_unlock_bh(&ptp_data->clock_lock);
>  
>  error_return:
>  	mutex_unlock(&ptp_data->lock);
> @@ -254,6 +269,7 @@ static int ksz_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
>  {
>  	struct ksz_ptp_data *ptp_data = ptp_caps_to_data(ptp);
>  	struct ksz_device *dev = ptp_data_to_ksz_dev(ptp_data);
> +	struct timespec64 delta64 = ns_to_timespec64(delta);
>  	s32 sec, nsec;
>  	u16 data16;
>  	int ret;
> @@ -286,15 +302,51 @@ static int ksz_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
>  		data16 |= PTP_STEP_DIR;
>  
>  	ret = ksz_write16(dev, REG_PTP_CLK_CTRL, data16);
> +	if (ret)
> +		goto error_return;
> +
> +	spin_lock_bh(&ptp_data->clock_lock);
> +	ptp_data->clock_time = timespec64_add(ptp_data->clock_time, delta64);
> +	spin_unlock_bh(&ptp_data->clock_lock);
>  
>  error_return:
>  	mutex_unlock(&ptp_data->lock);
>  	return ret;
>  }
>  
> +/*  Function is pointer to the do_aux_work in the ptp_clock capability */
> +static long ksz_ptp_do_aux_work(struct ptp_clock_info *ptp)
> +{
> +	struct ksz_ptp_data *ptp_data = ptp_caps_to_data(ptp);
> +	struct ksz_device *dev = ptp_data_to_ksz_dev(ptp_data);
> +	struct timespec64 ts;
> +
> +	mutex_lock(&ptp_data->lock);
> +	_ksz_ptp_gettime(dev, &ts);
> +	mutex_unlock(&ptp_data->lock);

Why don't you call ksz_ptp_gettime(ptp, &ts) directly?

> +
> +	spin_lock_bh(&ptp_data->clock_lock);
> +	ptp_data->clock_time = ts;
> +	spin_unlock_bh(&ptp_data->clock_lock);
> +
> +	return HZ;  /* reschedule in 1 second */
> +}
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
> +	spin_lock_bh(&ptp_data->clock_lock);
> +	ptp_data->clock_time.tv_sec = 0;
> +	ptp_data->clock_time.tv_nsec = 0;
> +	spin_unlock_bh(&ptp_data->clock_lock);

Does ksz_ptp_start_clock() race with anything? The PTP clock has not
even been registered by the time this has been called. This is literally
an example of the "spin_lock_init(); spin_lock();" antipattern.

> +
> +	return 0;
>  }
