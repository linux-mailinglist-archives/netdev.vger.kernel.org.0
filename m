Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 148224806E9
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 08:11:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233244AbhL1HBV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 02:01:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233209AbhL1HBV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Dec 2021 02:01:21 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2590FC061574
        for <netdev@vger.kernel.org>; Mon, 27 Dec 2021 23:01:21 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id 8so15263651pgc.10
        for <netdev@vger.kernel.org>; Mon, 27 Dec 2021 23:01:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=t7paGthvC2McdlbTOKf2faWKZsTyrUum+MRDdgRXzcw=;
        b=eE8CQcYZKhMiOKkrAB6fLRNeG/zGBYePJlJ0Sqn0xDjL4FFD0pRebg9XRH5lPofdCd
         BcITRkbXFKQRM5mHLM5fsXJD1YTQ0gFQku1dznbdc0rd/jdcOZBJIxGLI9aCMOHI0h8D
         5YYdEO2TOk2k2is2rPyrxIYmcHbTNcVKiG4WTFEyuxzJtTc2YMlc1WbmuWfXJ7zI75Ld
         7MP6w9BVAr+NlOp5zNbEhbx1Qsbkhpbr05pi3I6TjfkJbGAycm9jtk2hSUv20PRM7BLV
         gt3EzBByqJ4PhEwyiBMgNN0crqw7md2alT/8VhyTIFLaRuL0E0Os+grm7hJLcczpj9Mh
         qIbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=t7paGthvC2McdlbTOKf2faWKZsTyrUum+MRDdgRXzcw=;
        b=uwEfH51iySJ761uovzaua2wzf8AjyeoVnRWSZ7wTsr1WItrl1zWUiP3nQv94U0dbsL
         8rmnodY25ndiu1chC6i6XbHKbcmx1P8YexELlKq8cbLSW8kDh30xdc0a6z8k3njEhjCw
         bzBQLljCAKiKvpLmkiA4ADh01KXUhnSrt35dmS3J8egE5L92K1wuM0953mbN4EKxSDqE
         Y2y1ZBqJMig0aD9RctjmRBpz1tosygDFMbPZZkzx0xiCre9zYn8BwXgH2gHZtUgloHmT
         1sI8j8/z+220LROfjNUBMqDQX8cQozbF+1i9SnrC/bKB6wTyas5dfJ8AAt4ni1m+ovlK
         mHyA==
X-Gm-Message-State: AOAM532JDQxOE3xyWR6X8NEXw83oYIi9Les62iuTagshfN1sqb7jRdMV
        7DF8WD9Ig/TLzNfC6JjBfHZ/Klq7bSo=
X-Google-Smtp-Source: ABdhPJznNNupY9hWt6+NANWX9HhQkarvWSpVFbkbZe9vIQJU1y4/k/7hnIAlIKJNLvfTyXVZKn0gpQ==
X-Received: by 2002:a62:6497:0:b0:4ba:737c:8021 with SMTP id y145-20020a626497000000b004ba737c8021mr21189769pfb.18.1640674880556;
        Mon, 27 Dec 2021 23:01:20 -0800 (PST)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b9sm19412476pfm.122.2021.12.27.23.01.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Dec 2021 23:01:19 -0800 (PST)
Date:   Tue, 28 Dec 2021 15:01:13 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCHv3 net-next 1/2] net_tstamp: add new flag
 HWTSTAMP_FLAG_BONDED_PHC_INDEX
Message-ID: <Ycq2Ofad9UHur0qE@Laptop-X1>
References: <20211210085959.2023644-1-liuhangbin@gmail.com>
 <20211210085959.2023644-2-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211210085959.2023644-2-liuhangbin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

When implement the user space support for this feature. I realized that
we can't use the new flag directly as the user space tool needs to have
backward compatibility. Because run the new tool with this flag enabled
on old kernel will get -EINVAL error. And we also could not use #ifdef
directly as HWTSTAMP_FLAG_BONDED_PHC_INDEX is a enum.

Do you think if we could add a #define in linux/net_tstamp.h like

#define HWTSTAMP_FLAGS_SUPPORT 1

So that the user space tool could use it like

#ifdef HWTSTAMP_FLAGS_SUPPORT
       cfg->flags = HWTSTAMP_FLAG_BONDED_PHC_INDEX;
#endif

Thanks
Hangbin

On Fri, Dec 10, 2021 at 04:59:58PM +0800, Hangbin Liu wrote:
> Since commit 94dd016ae538 ("bond: pass get_ts_info and SIOC[SG]HWTSTAMP
> ioctl to active device") the user could get bond active interface's
> PHC index directly. But when there is a failover, the bond active
> interface will change, thus the PHC index is also changed. This may
> break the user's program if they did not update the PHC timely.
> 
> This patch adds a new hwtstamp_config flag HWTSTAMP_FLAG_BONDED_PHC_INDEX.
> When the user wants to get the bond active interface's PHC, they need to
> add this flag and be aware the PHC index may be changed.
> 
> With the new flag. All flag checks in current drivers are removed. Only
> the checking in net_hwtstamp_validate() is kept.
> 
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> 
> ---
> v3: Use bitwise test to check the flags validation
> v2: Keep the flag validation check in net_hwtstamp_validate()
>     Rename the flag to HWTSTAMP_FLAG_BONDED_PHC_INDEX

[...]

> diff --git a/include/uapi/linux/net_tstamp.h b/include/uapi/linux/net_tstamp.h
> index fcc61c73a666..e258e52cfd1f 100644
> --- a/include/uapi/linux/net_tstamp.h
> +++ b/include/uapi/linux/net_tstamp.h
> @@ -62,7 +62,7 @@ struct so_timestamping {
>  /**
>   * struct hwtstamp_config - %SIOCGHWTSTAMP and %SIOCSHWTSTAMP parameter
>   *
> - * @flags:	no flags defined right now, must be zero for %SIOCSHWTSTAMP
> + * @flags:	one of HWTSTAMP_FLAG_*
>   * @tx_type:	one of HWTSTAMP_TX_*
>   * @rx_filter:	one of HWTSTAMP_FILTER_*
>   *
> @@ -78,6 +78,20 @@ struct hwtstamp_config {
>  	int rx_filter;
>  };
>  
> +/* possible values for hwtstamp_config->flags */
> +enum hwtstamp_flags {
> +	/*
> +	 * With this flag, the user could get bond active interface's
> +	 * PHC index. Note this PHC index is not stable as when there
> +	 * is a failover, the bond active interface will be changed, so
> +	 * will be the PHC index.
> +	 */
> +	HWTSTAMP_FLAG_BONDED_PHC_INDEX = (1<<0),
> +
> +	HWTSTAMP_FLAG_LAST = HWTSTAMP_FLAG_BONDED_PHC_INDEX,
> +	HWTSTAMP_FLAG_MASK = (HWTSTAMP_FLAG_LAST - 1) | HWTSTAMP_FLAG_LAST
> +};
> +
>  /* possible values for hwtstamp_config->tx_type */
>  enum hwtstamp_tx_types {
>  	/*
> diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
> index 1d309a666932..1b807d119da5 100644
> --- a/net/core/dev_ioctl.c
> +++ b/net/core/dev_ioctl.c
> @@ -192,7 +192,7 @@ static int net_hwtstamp_validate(struct ifreq *ifr)
>  	if (copy_from_user(&cfg, ifr->ifr_data, sizeof(cfg)))
>  		return -EFAULT;
>  
> -	if (cfg.flags) /* reserved for future extensions */
> +	if (cfg.flags & ~HWTSTAMP_FLAG_MASK)
>  		return -EINVAL;
>  
>  	tx_type = cfg.tx_type;
> -- 
> 2.31.1
> 
