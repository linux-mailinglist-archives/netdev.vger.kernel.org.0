Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 848934BB6F6
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 11:35:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232671AbiBRKf3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 05:35:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbiBRKf2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 05:35:28 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F8672B3572;
        Fri, 18 Feb 2022 02:35:11 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id bg10so13990225ejb.4;
        Fri, 18 Feb 2022 02:35:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DMIZ5lABDflApwOeO77n15CihXQRNHwNqvhHQviVVds=;
        b=fe2d9PYoIUk7wdVNXjiFn5iUrul3MSPFn9mTKTMF+c4Q4hK1xM2RNECDhQBW2wK5xw
         CqPwl8mWkbh9tFNvEfnLwgyNr0Kcj5wZwmdIdwXnnUZtiV2z4XUamFXC88f1fJ8diUdU
         JGofUjSzyFX0jKEcDOHIX3KP7PcplqDT7G8FIh5VGw3m3G5gbU7YtqXNKD9w+qC/IqlS
         Kndr0WRa0QU3ScYgcKx3LHWC6y6cGLjRCBOTAP3R80HIEVvfvwf8dhps1+KP4D8xKIU5
         8u5bWf7xYLFFcvNY5W2/0icGMJ7mFAwIw86Ya7ScOzk5TOF5erFchK9gipAr4+TJL3DL
         wT3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DMIZ5lABDflApwOeO77n15CihXQRNHwNqvhHQviVVds=;
        b=8PY4GWoEx2NZYPiAwUZibqYxZQ/GxxFS90gTaO4hRulrz2D8fwo2DJZ4oso1RugkMV
         VnI9pjamiOMrMJ2FSoT7UMhN/II3B2B6Oxo72L1P8JaF8yh5p0yupYR4mu+eG4MOFZwZ
         r2KWLHyZmMlToIcZwAcEp87y29MJCq30x7OHk65P3N5hU1vJu/qGLiP3H98Hrund/G+R
         POiJGKg14w0rMWqtKpO10lli7YCGCZ0tKfWafM1SDhBLCCdgCiDn8bW0njoHWeV4xina
         RT1W55QjAvfkx9rc9COrfWJn5ZF7JrJa3+PLq4+GGGv0RrolFDkJ/jSWKGzp+yXnKz0d
         Cv1Q==
X-Gm-Message-State: AOAM5301yaVsReeKQeH4dTBlASz8IpLvvDD3vfNK7ALUtaV6FhdLTz9o
        T6AnPkzEetR1mRu/rpTXkng=
X-Google-Smtp-Source: ABdhPJwNiFOFYU+jj7NF4l1RgM2Xum8wXusSvb7euZWlF6ubUMUof10Jrcluh/hQ3YdMnnyL9x/7EA==
X-Received: by 2002:a17:906:b1d0:b0:6cf:7f39:50e0 with SMTP id bv16-20020a170906b1d000b006cf7f3950e0mr6220358ejb.760.1645180510006;
        Fri, 18 Feb 2022 02:35:10 -0800 (PST)
Received: from skbuf ([188.27.184.105])
        by smtp.gmail.com with ESMTPSA id g3sm2112712ejz.180.2022.02.18.02.35.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 02:35:09 -0800 (PST)
Date:   Fri, 18 Feb 2022 12:35:07 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 1/1] net: dsa: microchip: ksz9477: export HW
 stats over stats64 interface
Message-ID: <20220218103507.fmwdtd7gaqsvcblt@skbuf>
References: <20220218085554.1187089-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220218085554.1187089-1-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 18, 2022 at 09:55:54AM +0100, Oleksij Rempel wrote:
> diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
> index 7e33ec73f803..16fade9a088b 100644
> --- a/drivers/net/dsa/microchip/ksz_common.c
> +++ b/drivers/net/dsa/microchip/ksz_common.c
> @@ -111,6 +111,9 @@ static void ksz_mib_read_work(struct work_struct *work)
>  		port_r_cnt(dev, i);
>  		p->read = false;
>  		mutex_unlock(&mib->cnt_mutex);
> +
> +		if (dev->dev_ops->r_mib_stat64)
> +			dev->dev_ops->r_mib_stat64(dev, i);

Why not call dev->dev_ops->r_mib_stat64() under &mib->cnt_mutex here?
You grab the mutex in that function anyway. It's not a problem if the
&mib->stats64_lock spinlock is a sub-lock of the cnt_mutex. It's only a
problem if you're taking the mutex in the atomic path.

>  	}
>  
>  	schedule_delayed_work(&dev->mib_read, dev->mib_read_interval);
> diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
> index 3db63f62f0a1..c6fa487fb006 100644
> --- a/drivers/net/dsa/microchip/ksz_common.h
> +++ b/drivers/net/dsa/microchip/ksz_common.h
> @@ -22,6 +22,8 @@ struct ksz_port_mib {
>  	struct mutex cnt_mutex;		/* structure access */
>  	u8 cnt_ptr;
>  	u64 *counters;
> +	struct rtnl_link_stats64 stats64;
> +	struct spinlock stats64_lock;
>  };
>  
>  struct ksz_port {
> @@ -128,6 +130,7 @@ struct ksz_dev_ops {
>  			  u64 *cnt);
>  	void (*r_mib_pkt)(struct ksz_device *dev, int port, u16 addr,
>  			  u64 *dropped, u64 *cnt);
> +	void (*r_mib_stat64)(struct ksz_device *dev, int port);
>  	void (*freeze_mib)(struct ksz_device *dev, int port, bool freeze);
>  	void (*port_init_cnt)(struct ksz_device *dev, int port);
>  	int (*shutdown)(struct ksz_device *dev);
> -- 
> 2.30.2
> 

