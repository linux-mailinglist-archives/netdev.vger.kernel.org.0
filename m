Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 296EE1E80EC
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 16:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727069AbgE2OvG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 10:51:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726838AbgE2OvF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 10:51:05 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4129DC03E969;
        Fri, 29 May 2020 07:51:04 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id j21so1583188pgb.7;
        Fri, 29 May 2020 07:51:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=jOr9kSCuiRiGZqn8Tb20ICSny+xva6gwuSuQrspoPj0=;
        b=KgwcPZgZePP7ksJE/N3Elst8TGaRjtTyng3aVjAQVMiuK5WRj3KBrPfHTaEo6hH/5e
         NneEeN/a3Q4eVBsbszr8/xziSKQK53Cx1/6TLkiXvS8U4iZAh68lgseLhACqZS43k1Y0
         N1X3LVpLdfopR37McJJB4ZVw8N9NVCcsz8RHKEzSnz335rwWLh3vfQiQSGRherRJ0hYP
         lBLgwY5IO3LGlXYEe4+o53bxWcxv57+99+ayF1+XEQ5xRQ9pV127/3/7OjdsJYysJjO7
         Zgqh36dbycrH4G3rU1cCji+DELoV0L/qNEk0OVOlqbv/RwkIlvpncwtNXGy0eWhtF9Wp
         Iwjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=jOr9kSCuiRiGZqn8Tb20ICSny+xva6gwuSuQrspoPj0=;
        b=aJ8Lav+fUMBAFKpKknvfCCxBkaPSXlHFlWnsMbhl+9cgIxubYUiTLiRU4dXuveSbVw
         XZ2artoEyI4Bl85B3XEYXkL4XiNBLGZqVAZCiSxbvPqsvaO/2NZMMsunvM/sEmF4DBuY
         OXKnh39fzMb220svjmfuwTdrbQFf4urV/w2WVpuIdxCM3myzZsENp4SC+v+Ksp/piVbQ
         +7Idmp6TMHEKrwdfNgNJxf/gYzUml+88HK41Xjqne71PE4mGb6iY1PlkKqerxtP9SA6s
         TFKcaNHmgJazoIkO8Zuf3EGoqQtLpxAzlPc/yg4EtY0QPa0OzM0YCUvvDj3twpkSC45B
         nmDQ==
X-Gm-Message-State: AOAM531kmArv7HqLBwCJi/0AUzcx4CWz4jSDBf/j4rUMcSlg43X39hjK
        TicfyEVNLiwbB94dBQjoqd0=
X-Google-Smtp-Source: ABdhPJyuEWKA2q+MgeYdj6dmRKu/uvmTHR2Eywfghl8T0eMS68ZZfCLq9KCdRvKzdhJYo7ebVpb7jg==
X-Received: by 2002:a62:1d48:: with SMTP id d69mr9214260pfd.27.1590763863863;
        Fri, 29 May 2020 07:51:03 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id b23sm6933857pgs.33.2020.05.29.07.51.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 29 May 2020 07:51:03 -0700 (PDT)
Date:   Fri, 29 May 2020 07:51:02 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Andrzej Pietrasiewicz <andrzej.p@collabora.com>
Cc:     linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-renesas-soc@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Heiko Stuebner <heiko@sntech.de>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Vishal Kulkarni <vishal@chelsio.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        kernel@collabora.com, Fabio Estevam <festevam@gmail.com>,
        Amit Kucheria <amit.kucheria@verdurent.com>,
        Chunyan Zhang <zhang.lyra@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Allison Randal <allison@lohutok.net>,
        NXP Linux Team <linux-imx@nxp.com>,
        Darren Hart <dvhart@infradead.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Gayatri Kammela <gayatri.kammela@intel.com>,
        Len Brown <lenb@kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Ido Schimmel <idosch@mellanox.com>,
        Baolin Wang <baolin.wang7@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Orson Zhai <orsonzhai@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        Support Opensource <support.opensource@diasemi.com>,
        Enrico Weigelt <info@metux.net>,
        Peter Kaestle <peter@piie.net>,
        Sebastian Reichel <sre@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund@ragnatech.se>, Shawn Guo <shawnguo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Andy Shevchenko <andy@infradead.org>
Subject: Re: [PATCH v4 03/11] thermal: Add current mode to thermal zone device
Message-ID: <20200529145102.GA125312@roeck-us.net>
References: <4493c0e4-51aa-3907-810c-74949ff27ca4@samsung.com>
 <20200528192051.28034-1-andrzej.p@collabora.com>
 <20200528192051.28034-4-andrzej.p@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200528192051.28034-4-andrzej.p@collabora.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 28, 2020 at 09:20:43PM +0200, Andrzej Pietrasiewicz wrote:
> Prepare for changing the place where the mode is stored: now it is in
> drivers, which might or might not implement get_mode()/set_mode() methods.
> A lot of cleanup can be done thanks to storing it in struct tzd. The
> get_mode() methods will become redundant.
> 
> Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

> ---
>  include/linux/thermal.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/include/linux/thermal.h b/include/linux/thermal.h
> index 216185bb3014..5f91d7f04512 100644
> --- a/include/linux/thermal.h
> +++ b/include/linux/thermal.h
> @@ -128,6 +128,7 @@ struct thermal_cooling_device {
>   * @trip_temp_attrs:	attributes for trip points for sysfs: trip temperature
>   * @trip_type_attrs:	attributes for trip points for sysfs: trip type
>   * @trip_hyst_attrs:	attributes for trip points for sysfs: trip hysteresis
> + * @mode:		current mode of this thermal zone
>   * @devdata:	private pointer for device private data
>   * @trips:	number of trip points the thermal zone supports
>   * @trips_disabled;	bitmap for disabled trips
> @@ -170,6 +171,7 @@ struct thermal_zone_device {
>  	struct thermal_attr *trip_temp_attrs;
>  	struct thermal_attr *trip_type_attrs;
>  	struct thermal_attr *trip_hyst_attrs;
> +	enum thermal_device_mode mode;
>  	void *devdata;
>  	int trips;
>  	unsigned long trips_disabled;	/* bitmap for disabled trips */
